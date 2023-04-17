
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
  80003e:	68 00 23 80 00       	push   $0x802300
  800043:	e8 76 01 00 00       	call   8001be <cprintf>
	if ((env = fork()) == 0) {
  800048:	e8 ae 0e 00 00       	call   800efb <fork>
  80004d:	83 c4 10             	add    $0x10,%esp
  800050:	85 c0                	test   %eax,%eax
  800052:	75 12                	jne    800066 <umain+0x33>
		cprintf("I am the child.  Spinning...\n");
  800054:	83 ec 0c             	sub    $0xc,%esp
  800057:	68 78 23 80 00       	push   $0x802378
  80005c:	e8 5d 01 00 00       	call   8001be <cprintf>
  800061:	83 c4 10             	add    $0x10,%esp
  800064:	eb fe                	jmp    800064 <umain+0x31>
  800066:	89 c3                	mov    %eax,%ebx
		while (1)
			/* do nothing */;
	}

	cprintf("I am the parent.  Running the child...\n");
  800068:	83 ec 0c             	sub    $0xc,%esp
  80006b:	68 28 23 80 00       	push   $0x802328
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
  80009d:	c7 04 24 50 23 80 00 	movl   $0x802350,(%esp)
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
  8000da:	a3 04 40 80 00       	mov    %eax,0x804004

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
  80010d:	e8 f1 11 00 00       	call   801303 <close_all>
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
  800224:	e8 77 1e 00 00       	call   8020a0 <__udivdi3>
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
  800262:	e8 49 1f 00 00       	call   8021b0 <__umoddi3>
  800267:	83 c4 14             	add    $0x14,%esp
  80026a:	0f be 80 a0 23 80 00 	movsbl 0x8023a0(%eax),%eax
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
  800311:	3e ff 24 85 e0 24 80 	notrack jmp *0x8024e0(,%eax,4)
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
  8003de:	8b 14 85 40 26 80 00 	mov    0x802640(,%eax,4),%edx
  8003e5:	85 d2                	test   %edx,%edx
  8003e7:	74 18                	je     800401 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8003e9:	52                   	push   %edx
  8003ea:	68 01 28 80 00       	push   $0x802801
  8003ef:	53                   	push   %ebx
  8003f0:	56                   	push   %esi
  8003f1:	e8 aa fe ff ff       	call   8002a0 <printfmt>
  8003f6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003f9:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003fc:	e9 66 02 00 00       	jmp    800667 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800401:	50                   	push   %eax
  800402:	68 b8 23 80 00       	push   $0x8023b8
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
  800429:	b8 b1 23 80 00       	mov    $0x8023b1,%eax
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
  800bb3:	68 9f 26 80 00       	push   $0x80269f
  800bb8:	6a 23                	push   $0x23
  800bba:	68 bc 26 80 00       	push   $0x8026bc
  800bbf:	e8 95 12 00 00       	call   801e59 <_panic>

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
  800c40:	68 9f 26 80 00       	push   $0x80269f
  800c45:	6a 23                	push   $0x23
  800c47:	68 bc 26 80 00       	push   $0x8026bc
  800c4c:	e8 08 12 00 00       	call   801e59 <_panic>

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
  800c86:	68 9f 26 80 00       	push   $0x80269f
  800c8b:	6a 23                	push   $0x23
  800c8d:	68 bc 26 80 00       	push   $0x8026bc
  800c92:	e8 c2 11 00 00       	call   801e59 <_panic>

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
  800ccc:	68 9f 26 80 00       	push   $0x80269f
  800cd1:	6a 23                	push   $0x23
  800cd3:	68 bc 26 80 00       	push   $0x8026bc
  800cd8:	e8 7c 11 00 00       	call   801e59 <_panic>

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
  800d12:	68 9f 26 80 00       	push   $0x80269f
  800d17:	6a 23                	push   $0x23
  800d19:	68 bc 26 80 00       	push   $0x8026bc
  800d1e:	e8 36 11 00 00       	call   801e59 <_panic>

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
  800d58:	68 9f 26 80 00       	push   $0x80269f
  800d5d:	6a 23                	push   $0x23
  800d5f:	68 bc 26 80 00       	push   $0x8026bc
  800d64:	e8 f0 10 00 00       	call   801e59 <_panic>

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
  800d9e:	68 9f 26 80 00       	push   $0x80269f
  800da3:	6a 23                	push   $0x23
  800da5:	68 bc 26 80 00       	push   $0x8026bc
  800daa:	e8 aa 10 00 00       	call   801e59 <_panic>

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
  800e0a:	68 9f 26 80 00       	push   $0x80269f
  800e0f:	6a 23                	push   $0x23
  800e11:	68 bc 26 80 00       	push   $0x8026bc
  800e16:	e8 3e 10 00 00       	call   801e59 <_panic>

00800e1b <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800e1b:	f3 0f 1e fb          	endbr32 
  800e1f:	55                   	push   %ebp
  800e20:	89 e5                	mov    %esp,%ebp
  800e22:	53                   	push   %ebx
  800e23:	83 ec 04             	sub    $0x4,%esp
  800e26:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800e29:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  800e2b:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800e2f:	74 74                	je     800ea5 <pgfault+0x8a>
  800e31:	89 d8                	mov    %ebx,%eax
  800e33:	c1 e8 0c             	shr    $0xc,%eax
  800e36:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800e3d:	f6 c4 08             	test   $0x8,%ah
  800e40:	74 63                	je     800ea5 <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800e42:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  800e48:	83 ec 0c             	sub    $0xc,%esp
  800e4b:	6a 05                	push   $0x5
  800e4d:	68 00 f0 7f 00       	push   $0x7ff000
  800e52:	6a 00                	push   $0x0
  800e54:	53                   	push   %ebx
  800e55:	6a 00                	push   $0x0
  800e57:	e8 f5 fd ff ff       	call   800c51 <sys_page_map>
  800e5c:	83 c4 20             	add    $0x20,%esp
  800e5f:	85 c0                	test   %eax,%eax
  800e61:	78 59                	js     800ebc <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  800e63:	83 ec 04             	sub    $0x4,%esp
  800e66:	6a 07                	push   $0x7
  800e68:	53                   	push   %ebx
  800e69:	6a 00                	push   $0x0
  800e6b:	e8 9a fd ff ff       	call   800c0a <sys_page_alloc>
  800e70:	83 c4 10             	add    $0x10,%esp
  800e73:	85 c0                	test   %eax,%eax
  800e75:	78 5a                	js     800ed1 <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  800e77:	83 ec 04             	sub    $0x4,%esp
  800e7a:	68 00 10 00 00       	push   $0x1000
  800e7f:	68 00 f0 7f 00       	push   $0x7ff000
  800e84:	53                   	push   %ebx
  800e85:	e8 f4 fa ff ff       	call   80097e <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  800e8a:	83 c4 08             	add    $0x8,%esp
  800e8d:	68 00 f0 7f 00       	push   $0x7ff000
  800e92:	6a 00                	push   $0x0
  800e94:	e8 fe fd ff ff       	call   800c97 <sys_page_unmap>
  800e99:	83 c4 10             	add    $0x10,%esp
  800e9c:	85 c0                	test   %eax,%eax
  800e9e:	78 46                	js     800ee6 <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  800ea0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ea3:	c9                   	leave  
  800ea4:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  800ea5:	83 ec 04             	sub    $0x4,%esp
  800ea8:	68 ca 26 80 00       	push   $0x8026ca
  800ead:	68 d3 00 00 00       	push   $0xd3
  800eb2:	68 e6 26 80 00       	push   $0x8026e6
  800eb7:	e8 9d 0f 00 00       	call   801e59 <_panic>
		panic("pgfault: %e\n", r);
  800ebc:	50                   	push   %eax
  800ebd:	68 f1 26 80 00       	push   $0x8026f1
  800ec2:	68 df 00 00 00       	push   $0xdf
  800ec7:	68 e6 26 80 00       	push   $0x8026e6
  800ecc:	e8 88 0f 00 00       	call   801e59 <_panic>
		panic("pgfault: %e\n", r);
  800ed1:	50                   	push   %eax
  800ed2:	68 f1 26 80 00       	push   $0x8026f1
  800ed7:	68 e3 00 00 00       	push   $0xe3
  800edc:	68 e6 26 80 00       	push   $0x8026e6
  800ee1:	e8 73 0f 00 00       	call   801e59 <_panic>
		panic("pgfault: %e\n", r);
  800ee6:	50                   	push   %eax
  800ee7:	68 f1 26 80 00       	push   $0x8026f1
  800eec:	68 e9 00 00 00       	push   $0xe9
  800ef1:	68 e6 26 80 00       	push   $0x8026e6
  800ef6:	e8 5e 0f 00 00       	call   801e59 <_panic>

00800efb <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800efb:	f3 0f 1e fb          	endbr32 
  800eff:	55                   	push   %ebp
  800f00:	89 e5                	mov    %esp,%ebp
  800f02:	57                   	push   %edi
  800f03:	56                   	push   %esi
  800f04:	53                   	push   %ebx
  800f05:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  800f08:	68 1b 0e 80 00       	push   $0x800e1b
  800f0d:	e8 91 0f 00 00       	call   801ea3 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f12:	b8 07 00 00 00       	mov    $0x7,%eax
  800f17:	cd 30                	int    $0x30
  800f19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  800f1c:	83 c4 10             	add    $0x10,%esp
  800f1f:	85 c0                	test   %eax,%eax
  800f21:	78 2d                	js     800f50 <fork+0x55>
  800f23:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800f25:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  800f2a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f2e:	0f 85 9b 00 00 00    	jne    800fcf <fork+0xd4>
		thisenv = &envs[ENVX(sys_getenvid())];
  800f34:	e8 8b fc ff ff       	call   800bc4 <sys_getenvid>
  800f39:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f3e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f41:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f46:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  800f4b:	e9 71 01 00 00       	jmp    8010c1 <fork+0x1c6>
		panic("sys_exofork: %e", envid);
  800f50:	50                   	push   %eax
  800f51:	68 fe 26 80 00       	push   $0x8026fe
  800f56:	68 2a 01 00 00       	push   $0x12a
  800f5b:	68 e6 26 80 00       	push   $0x8026e6
  800f60:	e8 f4 0e 00 00       	call   801e59 <_panic>
		sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_SYSCALL);
  800f65:	c1 e6 0c             	shl    $0xc,%esi
  800f68:	83 ec 0c             	sub    $0xc,%esp
  800f6b:	68 07 0e 00 00       	push   $0xe07
  800f70:	56                   	push   %esi
  800f71:	57                   	push   %edi
  800f72:	56                   	push   %esi
  800f73:	6a 00                	push   $0x0
  800f75:	e8 d7 fc ff ff       	call   800c51 <sys_page_map>
  800f7a:	83 c4 20             	add    $0x20,%esp
  800f7d:	eb 3e                	jmp    800fbd <fork+0xc2>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  800f7f:	c1 e6 0c             	shl    $0xc,%esi
  800f82:	83 ec 0c             	sub    $0xc,%esp
  800f85:	68 05 08 00 00       	push   $0x805
  800f8a:	56                   	push   %esi
  800f8b:	57                   	push   %edi
  800f8c:	56                   	push   %esi
  800f8d:	6a 00                	push   $0x0
  800f8f:	e8 bd fc ff ff       	call   800c51 <sys_page_map>
  800f94:	83 c4 20             	add    $0x20,%esp
  800f97:	85 c0                	test   %eax,%eax
  800f99:	0f 88 bc 00 00 00    	js     80105b <fork+0x160>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  800f9f:	83 ec 0c             	sub    $0xc,%esp
  800fa2:	68 05 08 00 00       	push   $0x805
  800fa7:	56                   	push   %esi
  800fa8:	6a 00                	push   $0x0
  800faa:	56                   	push   %esi
  800fab:	6a 00                	push   $0x0
  800fad:	e8 9f fc ff ff       	call   800c51 <sys_page_map>
  800fb2:	83 c4 20             	add    $0x20,%esp
  800fb5:	85 c0                	test   %eax,%eax
  800fb7:	0f 88 b3 00 00 00    	js     801070 <fork+0x175>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800fbd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800fc3:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  800fc9:	0f 84 b6 00 00 00    	je     801085 <fork+0x18a>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  800fcf:	89 d8                	mov    %ebx,%eax
  800fd1:	c1 e8 16             	shr    $0x16,%eax
  800fd4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fdb:	a8 01                	test   $0x1,%al
  800fdd:	74 de                	je     800fbd <fork+0xc2>
  800fdf:	89 de                	mov    %ebx,%esi
  800fe1:	c1 ee 0c             	shr    $0xc,%esi
  800fe4:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  800feb:	a8 01                	test   $0x1,%al
  800fed:	74 ce                	je     800fbd <fork+0xc2>
  800fef:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  800ff6:	a8 04                	test   $0x4,%al
  800ff8:	74 c3                	je     800fbd <fork+0xc2>
	if ((uvpt[pn] & PTE_SHARE)){
  800ffa:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801001:	f6 c4 04             	test   $0x4,%ah
  801004:	0f 85 5b ff ff ff    	jne    800f65 <fork+0x6a>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  80100a:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801011:	a8 02                	test   $0x2,%al
  801013:	0f 85 66 ff ff ff    	jne    800f7f <fork+0x84>
  801019:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801020:	f6 c4 08             	test   $0x8,%ah
  801023:	0f 85 56 ff ff ff    	jne    800f7f <fork+0x84>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  801029:	c1 e6 0c             	shl    $0xc,%esi
  80102c:	83 ec 0c             	sub    $0xc,%esp
  80102f:	6a 05                	push   $0x5
  801031:	56                   	push   %esi
  801032:	57                   	push   %edi
  801033:	56                   	push   %esi
  801034:	6a 00                	push   $0x0
  801036:	e8 16 fc ff ff       	call   800c51 <sys_page_map>
  80103b:	83 c4 20             	add    $0x20,%esp
  80103e:	85 c0                	test   %eax,%eax
  801040:	0f 89 77 ff ff ff    	jns    800fbd <fork+0xc2>
		panic("duppage: %e\n", r);
  801046:	50                   	push   %eax
  801047:	68 0e 27 80 00       	push   $0x80270e
  80104c:	68 0c 01 00 00       	push   $0x10c
  801051:	68 e6 26 80 00       	push   $0x8026e6
  801056:	e8 fe 0d 00 00       	call   801e59 <_panic>
			panic("duppage: %e\n", r);
  80105b:	50                   	push   %eax
  80105c:	68 0e 27 80 00       	push   $0x80270e
  801061:	68 05 01 00 00       	push   $0x105
  801066:	68 e6 26 80 00       	push   $0x8026e6
  80106b:	e8 e9 0d 00 00       	call   801e59 <_panic>
			panic("duppage: %e\n", r);
  801070:	50                   	push   %eax
  801071:	68 0e 27 80 00       	push   $0x80270e
  801076:	68 09 01 00 00       	push   $0x109
  80107b:	68 e6 26 80 00       	push   $0x8026e6
  801080:	e8 d4 0d 00 00       	call   801e59 <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  801085:	83 ec 04             	sub    $0x4,%esp
  801088:	6a 07                	push   $0x7
  80108a:	68 00 f0 bf ee       	push   $0xeebff000
  80108f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801092:	e8 73 fb ff ff       	call   800c0a <sys_page_alloc>
  801097:	83 c4 10             	add    $0x10,%esp
  80109a:	85 c0                	test   %eax,%eax
  80109c:	78 2e                	js     8010cc <fork+0x1d1>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  80109e:	83 ec 08             	sub    $0x8,%esp
  8010a1:	68 16 1f 80 00       	push   $0x801f16
  8010a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8010a9:	57                   	push   %edi
  8010aa:	e8 ba fc ff ff       	call   800d69 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8010af:	83 c4 08             	add    $0x8,%esp
  8010b2:	6a 02                	push   $0x2
  8010b4:	57                   	push   %edi
  8010b5:	e8 23 fc ff ff       	call   800cdd <sys_env_set_status>
  8010ba:	83 c4 10             	add    $0x10,%esp
  8010bd:	85 c0                	test   %eax,%eax
  8010bf:	78 20                	js     8010e1 <fork+0x1e6>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  8010c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8010c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010c7:	5b                   	pop    %ebx
  8010c8:	5e                   	pop    %esi
  8010c9:	5f                   	pop    %edi
  8010ca:	5d                   	pop    %ebp
  8010cb:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  8010cc:	50                   	push   %eax
  8010cd:	68 1b 27 80 00       	push   $0x80271b
  8010d2:	68 3e 01 00 00       	push   $0x13e
  8010d7:	68 e6 26 80 00       	push   $0x8026e6
  8010dc:	e8 78 0d 00 00       	call   801e59 <_panic>
		panic("sys_env_set_status: %e", r);
  8010e1:	50                   	push   %eax
  8010e2:	68 2e 27 80 00       	push   $0x80272e
  8010e7:	68 43 01 00 00       	push   $0x143
  8010ec:	68 e6 26 80 00       	push   $0x8026e6
  8010f1:	e8 63 0d 00 00       	call   801e59 <_panic>

008010f6 <sfork>:

// Challenge!
int
sfork(void)
{
  8010f6:	f3 0f 1e fb          	endbr32 
  8010fa:	55                   	push   %ebp
  8010fb:	89 e5                	mov    %esp,%ebp
  8010fd:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801100:	68 45 27 80 00       	push   $0x802745
  801105:	68 4c 01 00 00       	push   $0x14c
  80110a:	68 e6 26 80 00       	push   $0x8026e6
  80110f:	e8 45 0d 00 00       	call   801e59 <_panic>

00801114 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801114:	f3 0f 1e fb          	endbr32 
  801118:	55                   	push   %ebp
  801119:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80111b:	8b 45 08             	mov    0x8(%ebp),%eax
  80111e:	05 00 00 00 30       	add    $0x30000000,%eax
  801123:	c1 e8 0c             	shr    $0xc,%eax
}
  801126:	5d                   	pop    %ebp
  801127:	c3                   	ret    

00801128 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801128:	f3 0f 1e fb          	endbr32 
  80112c:	55                   	push   %ebp
  80112d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80112f:	8b 45 08             	mov    0x8(%ebp),%eax
  801132:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801137:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80113c:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801141:	5d                   	pop    %ebp
  801142:	c3                   	ret    

00801143 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801143:	f3 0f 1e fb          	endbr32 
  801147:	55                   	push   %ebp
  801148:	89 e5                	mov    %esp,%ebp
  80114a:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80114f:	89 c2                	mov    %eax,%edx
  801151:	c1 ea 16             	shr    $0x16,%edx
  801154:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80115b:	f6 c2 01             	test   $0x1,%dl
  80115e:	74 2d                	je     80118d <fd_alloc+0x4a>
  801160:	89 c2                	mov    %eax,%edx
  801162:	c1 ea 0c             	shr    $0xc,%edx
  801165:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80116c:	f6 c2 01             	test   $0x1,%dl
  80116f:	74 1c                	je     80118d <fd_alloc+0x4a>
  801171:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801176:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80117b:	75 d2                	jne    80114f <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80117d:	8b 45 08             	mov    0x8(%ebp),%eax
  801180:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801186:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80118b:	eb 0a                	jmp    801197 <fd_alloc+0x54>
			*fd_store = fd;
  80118d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801190:	89 01                	mov    %eax,(%ecx)
			return 0;
  801192:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801197:	5d                   	pop    %ebp
  801198:	c3                   	ret    

00801199 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801199:	f3 0f 1e fb          	endbr32 
  80119d:	55                   	push   %ebp
  80119e:	89 e5                	mov    %esp,%ebp
  8011a0:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011a3:	83 f8 1f             	cmp    $0x1f,%eax
  8011a6:	77 30                	ja     8011d8 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011a8:	c1 e0 0c             	shl    $0xc,%eax
  8011ab:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011b0:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8011b6:	f6 c2 01             	test   $0x1,%dl
  8011b9:	74 24                	je     8011df <fd_lookup+0x46>
  8011bb:	89 c2                	mov    %eax,%edx
  8011bd:	c1 ea 0c             	shr    $0xc,%edx
  8011c0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011c7:	f6 c2 01             	test   $0x1,%dl
  8011ca:	74 1a                	je     8011e6 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011cf:	89 02                	mov    %eax,(%edx)
	return 0;
  8011d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011d6:	5d                   	pop    %ebp
  8011d7:	c3                   	ret    
		return -E_INVAL;
  8011d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011dd:	eb f7                	jmp    8011d6 <fd_lookup+0x3d>
		return -E_INVAL;
  8011df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011e4:	eb f0                	jmp    8011d6 <fd_lookup+0x3d>
  8011e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011eb:	eb e9                	jmp    8011d6 <fd_lookup+0x3d>

008011ed <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011ed:	f3 0f 1e fb          	endbr32 
  8011f1:	55                   	push   %ebp
  8011f2:	89 e5                	mov    %esp,%ebp
  8011f4:	83 ec 08             	sub    $0x8,%esp
  8011f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011fa:	ba d8 27 80 00       	mov    $0x8027d8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8011ff:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801204:	39 08                	cmp    %ecx,(%eax)
  801206:	74 33                	je     80123b <dev_lookup+0x4e>
  801208:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80120b:	8b 02                	mov    (%edx),%eax
  80120d:	85 c0                	test   %eax,%eax
  80120f:	75 f3                	jne    801204 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801211:	a1 04 40 80 00       	mov    0x804004,%eax
  801216:	8b 40 48             	mov    0x48(%eax),%eax
  801219:	83 ec 04             	sub    $0x4,%esp
  80121c:	51                   	push   %ecx
  80121d:	50                   	push   %eax
  80121e:	68 5c 27 80 00       	push   $0x80275c
  801223:	e8 96 ef ff ff       	call   8001be <cprintf>
	*dev = 0;
  801228:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801231:	83 c4 10             	add    $0x10,%esp
  801234:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801239:	c9                   	leave  
  80123a:	c3                   	ret    
			*dev = devtab[i];
  80123b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80123e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801240:	b8 00 00 00 00       	mov    $0x0,%eax
  801245:	eb f2                	jmp    801239 <dev_lookup+0x4c>

00801247 <fd_close>:
{
  801247:	f3 0f 1e fb          	endbr32 
  80124b:	55                   	push   %ebp
  80124c:	89 e5                	mov    %esp,%ebp
  80124e:	57                   	push   %edi
  80124f:	56                   	push   %esi
  801250:	53                   	push   %ebx
  801251:	83 ec 24             	sub    $0x24,%esp
  801254:	8b 75 08             	mov    0x8(%ebp),%esi
  801257:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80125a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80125d:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80125e:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801264:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801267:	50                   	push   %eax
  801268:	e8 2c ff ff ff       	call   801199 <fd_lookup>
  80126d:	89 c3                	mov    %eax,%ebx
  80126f:	83 c4 10             	add    $0x10,%esp
  801272:	85 c0                	test   %eax,%eax
  801274:	78 05                	js     80127b <fd_close+0x34>
	    || fd != fd2)
  801276:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801279:	74 16                	je     801291 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80127b:	89 f8                	mov    %edi,%eax
  80127d:	84 c0                	test   %al,%al
  80127f:	b8 00 00 00 00       	mov    $0x0,%eax
  801284:	0f 44 d8             	cmove  %eax,%ebx
}
  801287:	89 d8                	mov    %ebx,%eax
  801289:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80128c:	5b                   	pop    %ebx
  80128d:	5e                   	pop    %esi
  80128e:	5f                   	pop    %edi
  80128f:	5d                   	pop    %ebp
  801290:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801291:	83 ec 08             	sub    $0x8,%esp
  801294:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801297:	50                   	push   %eax
  801298:	ff 36                	pushl  (%esi)
  80129a:	e8 4e ff ff ff       	call   8011ed <dev_lookup>
  80129f:	89 c3                	mov    %eax,%ebx
  8012a1:	83 c4 10             	add    $0x10,%esp
  8012a4:	85 c0                	test   %eax,%eax
  8012a6:	78 1a                	js     8012c2 <fd_close+0x7b>
		if (dev->dev_close)
  8012a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ab:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8012ae:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8012b3:	85 c0                	test   %eax,%eax
  8012b5:	74 0b                	je     8012c2 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8012b7:	83 ec 0c             	sub    $0xc,%esp
  8012ba:	56                   	push   %esi
  8012bb:	ff d0                	call   *%eax
  8012bd:	89 c3                	mov    %eax,%ebx
  8012bf:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8012c2:	83 ec 08             	sub    $0x8,%esp
  8012c5:	56                   	push   %esi
  8012c6:	6a 00                	push   $0x0
  8012c8:	e8 ca f9 ff ff       	call   800c97 <sys_page_unmap>
	return r;
  8012cd:	83 c4 10             	add    $0x10,%esp
  8012d0:	eb b5                	jmp    801287 <fd_close+0x40>

008012d2 <close>:

int
close(int fdnum)
{
  8012d2:	f3 0f 1e fb          	endbr32 
  8012d6:	55                   	push   %ebp
  8012d7:	89 e5                	mov    %esp,%ebp
  8012d9:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012df:	50                   	push   %eax
  8012e0:	ff 75 08             	pushl  0x8(%ebp)
  8012e3:	e8 b1 fe ff ff       	call   801199 <fd_lookup>
  8012e8:	83 c4 10             	add    $0x10,%esp
  8012eb:	85 c0                	test   %eax,%eax
  8012ed:	79 02                	jns    8012f1 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8012ef:	c9                   	leave  
  8012f0:	c3                   	ret    
		return fd_close(fd, 1);
  8012f1:	83 ec 08             	sub    $0x8,%esp
  8012f4:	6a 01                	push   $0x1
  8012f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8012f9:	e8 49 ff ff ff       	call   801247 <fd_close>
  8012fe:	83 c4 10             	add    $0x10,%esp
  801301:	eb ec                	jmp    8012ef <close+0x1d>

00801303 <close_all>:

void
close_all(void)
{
  801303:	f3 0f 1e fb          	endbr32 
  801307:	55                   	push   %ebp
  801308:	89 e5                	mov    %esp,%ebp
  80130a:	53                   	push   %ebx
  80130b:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80130e:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801313:	83 ec 0c             	sub    $0xc,%esp
  801316:	53                   	push   %ebx
  801317:	e8 b6 ff ff ff       	call   8012d2 <close>
	for (i = 0; i < MAXFD; i++)
  80131c:	83 c3 01             	add    $0x1,%ebx
  80131f:	83 c4 10             	add    $0x10,%esp
  801322:	83 fb 20             	cmp    $0x20,%ebx
  801325:	75 ec                	jne    801313 <close_all+0x10>
}
  801327:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80132a:	c9                   	leave  
  80132b:	c3                   	ret    

0080132c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80132c:	f3 0f 1e fb          	endbr32 
  801330:	55                   	push   %ebp
  801331:	89 e5                	mov    %esp,%ebp
  801333:	57                   	push   %edi
  801334:	56                   	push   %esi
  801335:	53                   	push   %ebx
  801336:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801339:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80133c:	50                   	push   %eax
  80133d:	ff 75 08             	pushl  0x8(%ebp)
  801340:	e8 54 fe ff ff       	call   801199 <fd_lookup>
  801345:	89 c3                	mov    %eax,%ebx
  801347:	83 c4 10             	add    $0x10,%esp
  80134a:	85 c0                	test   %eax,%eax
  80134c:	0f 88 81 00 00 00    	js     8013d3 <dup+0xa7>
		return r;
	close(newfdnum);
  801352:	83 ec 0c             	sub    $0xc,%esp
  801355:	ff 75 0c             	pushl  0xc(%ebp)
  801358:	e8 75 ff ff ff       	call   8012d2 <close>

	newfd = INDEX2FD(newfdnum);
  80135d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801360:	c1 e6 0c             	shl    $0xc,%esi
  801363:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801369:	83 c4 04             	add    $0x4,%esp
  80136c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80136f:	e8 b4 fd ff ff       	call   801128 <fd2data>
  801374:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801376:	89 34 24             	mov    %esi,(%esp)
  801379:	e8 aa fd ff ff       	call   801128 <fd2data>
  80137e:	83 c4 10             	add    $0x10,%esp
  801381:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801383:	89 d8                	mov    %ebx,%eax
  801385:	c1 e8 16             	shr    $0x16,%eax
  801388:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80138f:	a8 01                	test   $0x1,%al
  801391:	74 11                	je     8013a4 <dup+0x78>
  801393:	89 d8                	mov    %ebx,%eax
  801395:	c1 e8 0c             	shr    $0xc,%eax
  801398:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80139f:	f6 c2 01             	test   $0x1,%dl
  8013a2:	75 39                	jne    8013dd <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013a7:	89 d0                	mov    %edx,%eax
  8013a9:	c1 e8 0c             	shr    $0xc,%eax
  8013ac:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013b3:	83 ec 0c             	sub    $0xc,%esp
  8013b6:	25 07 0e 00 00       	and    $0xe07,%eax
  8013bb:	50                   	push   %eax
  8013bc:	56                   	push   %esi
  8013bd:	6a 00                	push   $0x0
  8013bf:	52                   	push   %edx
  8013c0:	6a 00                	push   $0x0
  8013c2:	e8 8a f8 ff ff       	call   800c51 <sys_page_map>
  8013c7:	89 c3                	mov    %eax,%ebx
  8013c9:	83 c4 20             	add    $0x20,%esp
  8013cc:	85 c0                	test   %eax,%eax
  8013ce:	78 31                	js     801401 <dup+0xd5>
		goto err;

	return newfdnum;
  8013d0:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013d3:	89 d8                	mov    %ebx,%eax
  8013d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013d8:	5b                   	pop    %ebx
  8013d9:	5e                   	pop    %esi
  8013da:	5f                   	pop    %edi
  8013db:	5d                   	pop    %ebp
  8013dc:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013dd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013e4:	83 ec 0c             	sub    $0xc,%esp
  8013e7:	25 07 0e 00 00       	and    $0xe07,%eax
  8013ec:	50                   	push   %eax
  8013ed:	57                   	push   %edi
  8013ee:	6a 00                	push   $0x0
  8013f0:	53                   	push   %ebx
  8013f1:	6a 00                	push   $0x0
  8013f3:	e8 59 f8 ff ff       	call   800c51 <sys_page_map>
  8013f8:	89 c3                	mov    %eax,%ebx
  8013fa:	83 c4 20             	add    $0x20,%esp
  8013fd:	85 c0                	test   %eax,%eax
  8013ff:	79 a3                	jns    8013a4 <dup+0x78>
	sys_page_unmap(0, newfd);
  801401:	83 ec 08             	sub    $0x8,%esp
  801404:	56                   	push   %esi
  801405:	6a 00                	push   $0x0
  801407:	e8 8b f8 ff ff       	call   800c97 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80140c:	83 c4 08             	add    $0x8,%esp
  80140f:	57                   	push   %edi
  801410:	6a 00                	push   $0x0
  801412:	e8 80 f8 ff ff       	call   800c97 <sys_page_unmap>
	return r;
  801417:	83 c4 10             	add    $0x10,%esp
  80141a:	eb b7                	jmp    8013d3 <dup+0xa7>

0080141c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80141c:	f3 0f 1e fb          	endbr32 
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
  801423:	53                   	push   %ebx
  801424:	83 ec 1c             	sub    $0x1c,%esp
  801427:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80142a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80142d:	50                   	push   %eax
  80142e:	53                   	push   %ebx
  80142f:	e8 65 fd ff ff       	call   801199 <fd_lookup>
  801434:	83 c4 10             	add    $0x10,%esp
  801437:	85 c0                	test   %eax,%eax
  801439:	78 3f                	js     80147a <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80143b:	83 ec 08             	sub    $0x8,%esp
  80143e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801441:	50                   	push   %eax
  801442:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801445:	ff 30                	pushl  (%eax)
  801447:	e8 a1 fd ff ff       	call   8011ed <dev_lookup>
  80144c:	83 c4 10             	add    $0x10,%esp
  80144f:	85 c0                	test   %eax,%eax
  801451:	78 27                	js     80147a <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801453:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801456:	8b 42 08             	mov    0x8(%edx),%eax
  801459:	83 e0 03             	and    $0x3,%eax
  80145c:	83 f8 01             	cmp    $0x1,%eax
  80145f:	74 1e                	je     80147f <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801464:	8b 40 08             	mov    0x8(%eax),%eax
  801467:	85 c0                	test   %eax,%eax
  801469:	74 35                	je     8014a0 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80146b:	83 ec 04             	sub    $0x4,%esp
  80146e:	ff 75 10             	pushl  0x10(%ebp)
  801471:	ff 75 0c             	pushl  0xc(%ebp)
  801474:	52                   	push   %edx
  801475:	ff d0                	call   *%eax
  801477:	83 c4 10             	add    $0x10,%esp
}
  80147a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80147d:	c9                   	leave  
  80147e:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80147f:	a1 04 40 80 00       	mov    0x804004,%eax
  801484:	8b 40 48             	mov    0x48(%eax),%eax
  801487:	83 ec 04             	sub    $0x4,%esp
  80148a:	53                   	push   %ebx
  80148b:	50                   	push   %eax
  80148c:	68 9d 27 80 00       	push   $0x80279d
  801491:	e8 28 ed ff ff       	call   8001be <cprintf>
		return -E_INVAL;
  801496:	83 c4 10             	add    $0x10,%esp
  801499:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80149e:	eb da                	jmp    80147a <read+0x5e>
		return -E_NOT_SUPP;
  8014a0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014a5:	eb d3                	jmp    80147a <read+0x5e>

008014a7 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014a7:	f3 0f 1e fb          	endbr32 
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
  8014ae:	57                   	push   %edi
  8014af:	56                   	push   %esi
  8014b0:	53                   	push   %ebx
  8014b1:	83 ec 0c             	sub    $0xc,%esp
  8014b4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014b7:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014ba:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014bf:	eb 02                	jmp    8014c3 <readn+0x1c>
  8014c1:	01 c3                	add    %eax,%ebx
  8014c3:	39 f3                	cmp    %esi,%ebx
  8014c5:	73 21                	jae    8014e8 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014c7:	83 ec 04             	sub    $0x4,%esp
  8014ca:	89 f0                	mov    %esi,%eax
  8014cc:	29 d8                	sub    %ebx,%eax
  8014ce:	50                   	push   %eax
  8014cf:	89 d8                	mov    %ebx,%eax
  8014d1:	03 45 0c             	add    0xc(%ebp),%eax
  8014d4:	50                   	push   %eax
  8014d5:	57                   	push   %edi
  8014d6:	e8 41 ff ff ff       	call   80141c <read>
		if (m < 0)
  8014db:	83 c4 10             	add    $0x10,%esp
  8014de:	85 c0                	test   %eax,%eax
  8014e0:	78 04                	js     8014e6 <readn+0x3f>
			return m;
		if (m == 0)
  8014e2:	75 dd                	jne    8014c1 <readn+0x1a>
  8014e4:	eb 02                	jmp    8014e8 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014e6:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8014e8:	89 d8                	mov    %ebx,%eax
  8014ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014ed:	5b                   	pop    %ebx
  8014ee:	5e                   	pop    %esi
  8014ef:	5f                   	pop    %edi
  8014f0:	5d                   	pop    %ebp
  8014f1:	c3                   	ret    

008014f2 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014f2:	f3 0f 1e fb          	endbr32 
  8014f6:	55                   	push   %ebp
  8014f7:	89 e5                	mov    %esp,%ebp
  8014f9:	53                   	push   %ebx
  8014fa:	83 ec 1c             	sub    $0x1c,%esp
  8014fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801500:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801503:	50                   	push   %eax
  801504:	53                   	push   %ebx
  801505:	e8 8f fc ff ff       	call   801199 <fd_lookup>
  80150a:	83 c4 10             	add    $0x10,%esp
  80150d:	85 c0                	test   %eax,%eax
  80150f:	78 3a                	js     80154b <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801511:	83 ec 08             	sub    $0x8,%esp
  801514:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801517:	50                   	push   %eax
  801518:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80151b:	ff 30                	pushl  (%eax)
  80151d:	e8 cb fc ff ff       	call   8011ed <dev_lookup>
  801522:	83 c4 10             	add    $0x10,%esp
  801525:	85 c0                	test   %eax,%eax
  801527:	78 22                	js     80154b <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801529:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801530:	74 1e                	je     801550 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801532:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801535:	8b 52 0c             	mov    0xc(%edx),%edx
  801538:	85 d2                	test   %edx,%edx
  80153a:	74 35                	je     801571 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80153c:	83 ec 04             	sub    $0x4,%esp
  80153f:	ff 75 10             	pushl  0x10(%ebp)
  801542:	ff 75 0c             	pushl  0xc(%ebp)
  801545:	50                   	push   %eax
  801546:	ff d2                	call   *%edx
  801548:	83 c4 10             	add    $0x10,%esp
}
  80154b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80154e:	c9                   	leave  
  80154f:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801550:	a1 04 40 80 00       	mov    0x804004,%eax
  801555:	8b 40 48             	mov    0x48(%eax),%eax
  801558:	83 ec 04             	sub    $0x4,%esp
  80155b:	53                   	push   %ebx
  80155c:	50                   	push   %eax
  80155d:	68 b9 27 80 00       	push   $0x8027b9
  801562:	e8 57 ec ff ff       	call   8001be <cprintf>
		return -E_INVAL;
  801567:	83 c4 10             	add    $0x10,%esp
  80156a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80156f:	eb da                	jmp    80154b <write+0x59>
		return -E_NOT_SUPP;
  801571:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801576:	eb d3                	jmp    80154b <write+0x59>

00801578 <seek>:

int
seek(int fdnum, off_t offset)
{
  801578:	f3 0f 1e fb          	endbr32 
  80157c:	55                   	push   %ebp
  80157d:	89 e5                	mov    %esp,%ebp
  80157f:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801582:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801585:	50                   	push   %eax
  801586:	ff 75 08             	pushl  0x8(%ebp)
  801589:	e8 0b fc ff ff       	call   801199 <fd_lookup>
  80158e:	83 c4 10             	add    $0x10,%esp
  801591:	85 c0                	test   %eax,%eax
  801593:	78 0e                	js     8015a3 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801595:	8b 55 0c             	mov    0xc(%ebp),%edx
  801598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80159b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80159e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015a3:	c9                   	leave  
  8015a4:	c3                   	ret    

008015a5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015a5:	f3 0f 1e fb          	endbr32 
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
  8015ac:	53                   	push   %ebx
  8015ad:	83 ec 1c             	sub    $0x1c,%esp
  8015b0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015b3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015b6:	50                   	push   %eax
  8015b7:	53                   	push   %ebx
  8015b8:	e8 dc fb ff ff       	call   801199 <fd_lookup>
  8015bd:	83 c4 10             	add    $0x10,%esp
  8015c0:	85 c0                	test   %eax,%eax
  8015c2:	78 37                	js     8015fb <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015c4:	83 ec 08             	sub    $0x8,%esp
  8015c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ca:	50                   	push   %eax
  8015cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ce:	ff 30                	pushl  (%eax)
  8015d0:	e8 18 fc ff ff       	call   8011ed <dev_lookup>
  8015d5:	83 c4 10             	add    $0x10,%esp
  8015d8:	85 c0                	test   %eax,%eax
  8015da:	78 1f                	js     8015fb <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015df:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015e3:	74 1b                	je     801600 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8015e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015e8:	8b 52 18             	mov    0x18(%edx),%edx
  8015eb:	85 d2                	test   %edx,%edx
  8015ed:	74 32                	je     801621 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015ef:	83 ec 08             	sub    $0x8,%esp
  8015f2:	ff 75 0c             	pushl  0xc(%ebp)
  8015f5:	50                   	push   %eax
  8015f6:	ff d2                	call   *%edx
  8015f8:	83 c4 10             	add    $0x10,%esp
}
  8015fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015fe:	c9                   	leave  
  8015ff:	c3                   	ret    
			thisenv->env_id, fdnum);
  801600:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801605:	8b 40 48             	mov    0x48(%eax),%eax
  801608:	83 ec 04             	sub    $0x4,%esp
  80160b:	53                   	push   %ebx
  80160c:	50                   	push   %eax
  80160d:	68 7c 27 80 00       	push   $0x80277c
  801612:	e8 a7 eb ff ff       	call   8001be <cprintf>
		return -E_INVAL;
  801617:	83 c4 10             	add    $0x10,%esp
  80161a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80161f:	eb da                	jmp    8015fb <ftruncate+0x56>
		return -E_NOT_SUPP;
  801621:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801626:	eb d3                	jmp    8015fb <ftruncate+0x56>

00801628 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801628:	f3 0f 1e fb          	endbr32 
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
  80162f:	53                   	push   %ebx
  801630:	83 ec 1c             	sub    $0x1c,%esp
  801633:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801636:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801639:	50                   	push   %eax
  80163a:	ff 75 08             	pushl  0x8(%ebp)
  80163d:	e8 57 fb ff ff       	call   801199 <fd_lookup>
  801642:	83 c4 10             	add    $0x10,%esp
  801645:	85 c0                	test   %eax,%eax
  801647:	78 4b                	js     801694 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801649:	83 ec 08             	sub    $0x8,%esp
  80164c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80164f:	50                   	push   %eax
  801650:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801653:	ff 30                	pushl  (%eax)
  801655:	e8 93 fb ff ff       	call   8011ed <dev_lookup>
  80165a:	83 c4 10             	add    $0x10,%esp
  80165d:	85 c0                	test   %eax,%eax
  80165f:	78 33                	js     801694 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801664:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801668:	74 2f                	je     801699 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80166a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80166d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801674:	00 00 00 
	stat->st_isdir = 0;
  801677:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80167e:	00 00 00 
	stat->st_dev = dev;
  801681:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801687:	83 ec 08             	sub    $0x8,%esp
  80168a:	53                   	push   %ebx
  80168b:	ff 75 f0             	pushl  -0x10(%ebp)
  80168e:	ff 50 14             	call   *0x14(%eax)
  801691:	83 c4 10             	add    $0x10,%esp
}
  801694:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801697:	c9                   	leave  
  801698:	c3                   	ret    
		return -E_NOT_SUPP;
  801699:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80169e:	eb f4                	jmp    801694 <fstat+0x6c>

008016a0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016a0:	f3 0f 1e fb          	endbr32 
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
  8016a7:	56                   	push   %esi
  8016a8:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016a9:	83 ec 08             	sub    $0x8,%esp
  8016ac:	6a 00                	push   $0x0
  8016ae:	ff 75 08             	pushl  0x8(%ebp)
  8016b1:	e8 fb 01 00 00       	call   8018b1 <open>
  8016b6:	89 c3                	mov    %eax,%ebx
  8016b8:	83 c4 10             	add    $0x10,%esp
  8016bb:	85 c0                	test   %eax,%eax
  8016bd:	78 1b                	js     8016da <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8016bf:	83 ec 08             	sub    $0x8,%esp
  8016c2:	ff 75 0c             	pushl  0xc(%ebp)
  8016c5:	50                   	push   %eax
  8016c6:	e8 5d ff ff ff       	call   801628 <fstat>
  8016cb:	89 c6                	mov    %eax,%esi
	close(fd);
  8016cd:	89 1c 24             	mov    %ebx,(%esp)
  8016d0:	e8 fd fb ff ff       	call   8012d2 <close>
	return r;
  8016d5:	83 c4 10             	add    $0x10,%esp
  8016d8:	89 f3                	mov    %esi,%ebx
}
  8016da:	89 d8                	mov    %ebx,%eax
  8016dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016df:	5b                   	pop    %ebx
  8016e0:	5e                   	pop    %esi
  8016e1:	5d                   	pop    %ebp
  8016e2:	c3                   	ret    

008016e3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016e3:	55                   	push   %ebp
  8016e4:	89 e5                	mov    %esp,%ebp
  8016e6:	56                   	push   %esi
  8016e7:	53                   	push   %ebx
  8016e8:	89 c6                	mov    %eax,%esi
  8016ea:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016ec:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016f3:	74 27                	je     80171c <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016f5:	6a 07                	push   $0x7
  8016f7:	68 00 50 80 00       	push   $0x805000
  8016fc:	56                   	push   %esi
  8016fd:	ff 35 00 40 80 00    	pushl  0x804000
  801703:	e8 b9 08 00 00       	call   801fc1 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801708:	83 c4 0c             	add    $0xc,%esp
  80170b:	6a 00                	push   $0x0
  80170d:	53                   	push   %ebx
  80170e:	6a 00                	push   $0x0
  801710:	e8 27 08 00 00       	call   801f3c <ipc_recv>
}
  801715:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801718:	5b                   	pop    %ebx
  801719:	5e                   	pop    %esi
  80171a:	5d                   	pop    %ebp
  80171b:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80171c:	83 ec 0c             	sub    $0xc,%esp
  80171f:	6a 01                	push   $0x1
  801721:	e8 f3 08 00 00       	call   802019 <ipc_find_env>
  801726:	a3 00 40 80 00       	mov    %eax,0x804000
  80172b:	83 c4 10             	add    $0x10,%esp
  80172e:	eb c5                	jmp    8016f5 <fsipc+0x12>

00801730 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801730:	f3 0f 1e fb          	endbr32 
  801734:	55                   	push   %ebp
  801735:	89 e5                	mov    %esp,%ebp
  801737:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80173a:	8b 45 08             	mov    0x8(%ebp),%eax
  80173d:	8b 40 0c             	mov    0xc(%eax),%eax
  801740:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801745:	8b 45 0c             	mov    0xc(%ebp),%eax
  801748:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80174d:	ba 00 00 00 00       	mov    $0x0,%edx
  801752:	b8 02 00 00 00       	mov    $0x2,%eax
  801757:	e8 87 ff ff ff       	call   8016e3 <fsipc>
}
  80175c:	c9                   	leave  
  80175d:	c3                   	ret    

0080175e <devfile_flush>:
{
  80175e:	f3 0f 1e fb          	endbr32 
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
  801765:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801768:	8b 45 08             	mov    0x8(%ebp),%eax
  80176b:	8b 40 0c             	mov    0xc(%eax),%eax
  80176e:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801773:	ba 00 00 00 00       	mov    $0x0,%edx
  801778:	b8 06 00 00 00       	mov    $0x6,%eax
  80177d:	e8 61 ff ff ff       	call   8016e3 <fsipc>
}
  801782:	c9                   	leave  
  801783:	c3                   	ret    

00801784 <devfile_stat>:
{
  801784:	f3 0f 1e fb          	endbr32 
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
  80178b:	53                   	push   %ebx
  80178c:	83 ec 04             	sub    $0x4,%esp
  80178f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801792:	8b 45 08             	mov    0x8(%ebp),%eax
  801795:	8b 40 0c             	mov    0xc(%eax),%eax
  801798:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80179d:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a2:	b8 05 00 00 00       	mov    $0x5,%eax
  8017a7:	e8 37 ff ff ff       	call   8016e3 <fsipc>
  8017ac:	85 c0                	test   %eax,%eax
  8017ae:	78 2c                	js     8017dc <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017b0:	83 ec 08             	sub    $0x8,%esp
  8017b3:	68 00 50 80 00       	push   $0x805000
  8017b8:	53                   	push   %ebx
  8017b9:	e8 0a f0 ff ff       	call   8007c8 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017be:	a1 80 50 80 00       	mov    0x805080,%eax
  8017c3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017c9:	a1 84 50 80 00       	mov    0x805084,%eax
  8017ce:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017d4:	83 c4 10             	add    $0x10,%esp
  8017d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017df:	c9                   	leave  
  8017e0:	c3                   	ret    

008017e1 <devfile_write>:
{
  8017e1:	f3 0f 1e fb          	endbr32 
  8017e5:	55                   	push   %ebp
  8017e6:	89 e5                	mov    %esp,%ebp
  8017e8:	83 ec 0c             	sub    $0xc,%esp
  8017eb:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8017f1:	8b 52 0c             	mov    0xc(%edx),%edx
  8017f4:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  8017fa:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8017ff:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801804:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  801807:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  80180c:	50                   	push   %eax
  80180d:	ff 75 0c             	pushl  0xc(%ebp)
  801810:	68 08 50 80 00       	push   $0x805008
  801815:	e8 64 f1 ff ff       	call   80097e <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  80181a:	ba 00 00 00 00       	mov    $0x0,%edx
  80181f:	b8 04 00 00 00       	mov    $0x4,%eax
  801824:	e8 ba fe ff ff       	call   8016e3 <fsipc>
}
  801829:	c9                   	leave  
  80182a:	c3                   	ret    

0080182b <devfile_read>:
{
  80182b:	f3 0f 1e fb          	endbr32 
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
  801832:	56                   	push   %esi
  801833:	53                   	push   %ebx
  801834:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	8b 40 0c             	mov    0xc(%eax),%eax
  80183d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801842:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801848:	ba 00 00 00 00       	mov    $0x0,%edx
  80184d:	b8 03 00 00 00       	mov    $0x3,%eax
  801852:	e8 8c fe ff ff       	call   8016e3 <fsipc>
  801857:	89 c3                	mov    %eax,%ebx
  801859:	85 c0                	test   %eax,%eax
  80185b:	78 1f                	js     80187c <devfile_read+0x51>
	assert(r <= n);
  80185d:	39 f0                	cmp    %esi,%eax
  80185f:	77 24                	ja     801885 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801861:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801866:	7f 33                	jg     80189b <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801868:	83 ec 04             	sub    $0x4,%esp
  80186b:	50                   	push   %eax
  80186c:	68 00 50 80 00       	push   $0x805000
  801871:	ff 75 0c             	pushl  0xc(%ebp)
  801874:	e8 05 f1 ff ff       	call   80097e <memmove>
	return r;
  801879:	83 c4 10             	add    $0x10,%esp
}
  80187c:	89 d8                	mov    %ebx,%eax
  80187e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801881:	5b                   	pop    %ebx
  801882:	5e                   	pop    %esi
  801883:	5d                   	pop    %ebp
  801884:	c3                   	ret    
	assert(r <= n);
  801885:	68 e8 27 80 00       	push   $0x8027e8
  80188a:	68 ef 27 80 00       	push   $0x8027ef
  80188f:	6a 7c                	push   $0x7c
  801891:	68 04 28 80 00       	push   $0x802804
  801896:	e8 be 05 00 00       	call   801e59 <_panic>
	assert(r <= PGSIZE);
  80189b:	68 0f 28 80 00       	push   $0x80280f
  8018a0:	68 ef 27 80 00       	push   $0x8027ef
  8018a5:	6a 7d                	push   $0x7d
  8018a7:	68 04 28 80 00       	push   $0x802804
  8018ac:	e8 a8 05 00 00       	call   801e59 <_panic>

008018b1 <open>:
{
  8018b1:	f3 0f 1e fb          	endbr32 
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
  8018b8:	56                   	push   %esi
  8018b9:	53                   	push   %ebx
  8018ba:	83 ec 1c             	sub    $0x1c,%esp
  8018bd:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8018c0:	56                   	push   %esi
  8018c1:	e8 bf ee ff ff       	call   800785 <strlen>
  8018c6:	83 c4 10             	add    $0x10,%esp
  8018c9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018ce:	7f 6c                	jg     80193c <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8018d0:	83 ec 0c             	sub    $0xc,%esp
  8018d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018d6:	50                   	push   %eax
  8018d7:	e8 67 f8 ff ff       	call   801143 <fd_alloc>
  8018dc:	89 c3                	mov    %eax,%ebx
  8018de:	83 c4 10             	add    $0x10,%esp
  8018e1:	85 c0                	test   %eax,%eax
  8018e3:	78 3c                	js     801921 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8018e5:	83 ec 08             	sub    $0x8,%esp
  8018e8:	56                   	push   %esi
  8018e9:	68 00 50 80 00       	push   $0x805000
  8018ee:	e8 d5 ee ff ff       	call   8007c8 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f6:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018fe:	b8 01 00 00 00       	mov    $0x1,%eax
  801903:	e8 db fd ff ff       	call   8016e3 <fsipc>
  801908:	89 c3                	mov    %eax,%ebx
  80190a:	83 c4 10             	add    $0x10,%esp
  80190d:	85 c0                	test   %eax,%eax
  80190f:	78 19                	js     80192a <open+0x79>
	return fd2num(fd);
  801911:	83 ec 0c             	sub    $0xc,%esp
  801914:	ff 75 f4             	pushl  -0xc(%ebp)
  801917:	e8 f8 f7 ff ff       	call   801114 <fd2num>
  80191c:	89 c3                	mov    %eax,%ebx
  80191e:	83 c4 10             	add    $0x10,%esp
}
  801921:	89 d8                	mov    %ebx,%eax
  801923:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801926:	5b                   	pop    %ebx
  801927:	5e                   	pop    %esi
  801928:	5d                   	pop    %ebp
  801929:	c3                   	ret    
		fd_close(fd, 0);
  80192a:	83 ec 08             	sub    $0x8,%esp
  80192d:	6a 00                	push   $0x0
  80192f:	ff 75 f4             	pushl  -0xc(%ebp)
  801932:	e8 10 f9 ff ff       	call   801247 <fd_close>
		return r;
  801937:	83 c4 10             	add    $0x10,%esp
  80193a:	eb e5                	jmp    801921 <open+0x70>
		return -E_BAD_PATH;
  80193c:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801941:	eb de                	jmp    801921 <open+0x70>

00801943 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801943:	f3 0f 1e fb          	endbr32 
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
  80194a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80194d:	ba 00 00 00 00       	mov    $0x0,%edx
  801952:	b8 08 00 00 00       	mov    $0x8,%eax
  801957:	e8 87 fd ff ff       	call   8016e3 <fsipc>
}
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

0080195e <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80195e:	f3 0f 1e fb          	endbr32 
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
  801965:	56                   	push   %esi
  801966:	53                   	push   %ebx
  801967:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80196a:	83 ec 0c             	sub    $0xc,%esp
  80196d:	ff 75 08             	pushl  0x8(%ebp)
  801970:	e8 b3 f7 ff ff       	call   801128 <fd2data>
  801975:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801977:	83 c4 08             	add    $0x8,%esp
  80197a:	68 1b 28 80 00       	push   $0x80281b
  80197f:	53                   	push   %ebx
  801980:	e8 43 ee ff ff       	call   8007c8 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801985:	8b 46 04             	mov    0x4(%esi),%eax
  801988:	2b 06                	sub    (%esi),%eax
  80198a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801990:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801997:	00 00 00 
	stat->st_dev = &devpipe;
  80199a:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8019a1:	30 80 00 
	return 0;
}
  8019a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8019a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ac:	5b                   	pop    %ebx
  8019ad:	5e                   	pop    %esi
  8019ae:	5d                   	pop    %ebp
  8019af:	c3                   	ret    

008019b0 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8019b0:	f3 0f 1e fb          	endbr32 
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
  8019b7:	53                   	push   %ebx
  8019b8:	83 ec 0c             	sub    $0xc,%esp
  8019bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8019be:	53                   	push   %ebx
  8019bf:	6a 00                	push   $0x0
  8019c1:	e8 d1 f2 ff ff       	call   800c97 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8019c6:	89 1c 24             	mov    %ebx,(%esp)
  8019c9:	e8 5a f7 ff ff       	call   801128 <fd2data>
  8019ce:	83 c4 08             	add    $0x8,%esp
  8019d1:	50                   	push   %eax
  8019d2:	6a 00                	push   $0x0
  8019d4:	e8 be f2 ff ff       	call   800c97 <sys_page_unmap>
}
  8019d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019dc:	c9                   	leave  
  8019dd:	c3                   	ret    

008019de <_pipeisclosed>:
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
  8019e1:	57                   	push   %edi
  8019e2:	56                   	push   %esi
  8019e3:	53                   	push   %ebx
  8019e4:	83 ec 1c             	sub    $0x1c,%esp
  8019e7:	89 c7                	mov    %eax,%edi
  8019e9:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8019eb:	a1 04 40 80 00       	mov    0x804004,%eax
  8019f0:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8019f3:	83 ec 0c             	sub    $0xc,%esp
  8019f6:	57                   	push   %edi
  8019f7:	e8 5a 06 00 00       	call   802056 <pageref>
  8019fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8019ff:	89 34 24             	mov    %esi,(%esp)
  801a02:	e8 4f 06 00 00       	call   802056 <pageref>
		nn = thisenv->env_runs;
  801a07:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801a0d:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801a10:	83 c4 10             	add    $0x10,%esp
  801a13:	39 cb                	cmp    %ecx,%ebx
  801a15:	74 1b                	je     801a32 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801a17:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a1a:	75 cf                	jne    8019eb <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801a1c:	8b 42 58             	mov    0x58(%edx),%eax
  801a1f:	6a 01                	push   $0x1
  801a21:	50                   	push   %eax
  801a22:	53                   	push   %ebx
  801a23:	68 22 28 80 00       	push   $0x802822
  801a28:	e8 91 e7 ff ff       	call   8001be <cprintf>
  801a2d:	83 c4 10             	add    $0x10,%esp
  801a30:	eb b9                	jmp    8019eb <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801a32:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a35:	0f 94 c0             	sete   %al
  801a38:	0f b6 c0             	movzbl %al,%eax
}
  801a3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a3e:	5b                   	pop    %ebx
  801a3f:	5e                   	pop    %esi
  801a40:	5f                   	pop    %edi
  801a41:	5d                   	pop    %ebp
  801a42:	c3                   	ret    

00801a43 <devpipe_write>:
{
  801a43:	f3 0f 1e fb          	endbr32 
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
  801a4a:	57                   	push   %edi
  801a4b:	56                   	push   %esi
  801a4c:	53                   	push   %ebx
  801a4d:	83 ec 28             	sub    $0x28,%esp
  801a50:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801a53:	56                   	push   %esi
  801a54:	e8 cf f6 ff ff       	call   801128 <fd2data>
  801a59:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801a5b:	83 c4 10             	add    $0x10,%esp
  801a5e:	bf 00 00 00 00       	mov    $0x0,%edi
  801a63:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801a66:	74 4f                	je     801ab7 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a68:	8b 43 04             	mov    0x4(%ebx),%eax
  801a6b:	8b 0b                	mov    (%ebx),%ecx
  801a6d:	8d 51 20             	lea    0x20(%ecx),%edx
  801a70:	39 d0                	cmp    %edx,%eax
  801a72:	72 14                	jb     801a88 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801a74:	89 da                	mov    %ebx,%edx
  801a76:	89 f0                	mov    %esi,%eax
  801a78:	e8 61 ff ff ff       	call   8019de <_pipeisclosed>
  801a7d:	85 c0                	test   %eax,%eax
  801a7f:	75 3b                	jne    801abc <devpipe_write+0x79>
			sys_yield();
  801a81:	e8 61 f1 ff ff       	call   800be7 <sys_yield>
  801a86:	eb e0                	jmp    801a68 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a8b:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801a8f:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801a92:	89 c2                	mov    %eax,%edx
  801a94:	c1 fa 1f             	sar    $0x1f,%edx
  801a97:	89 d1                	mov    %edx,%ecx
  801a99:	c1 e9 1b             	shr    $0x1b,%ecx
  801a9c:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801a9f:	83 e2 1f             	and    $0x1f,%edx
  801aa2:	29 ca                	sub    %ecx,%edx
  801aa4:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801aa8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801aac:	83 c0 01             	add    $0x1,%eax
  801aaf:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801ab2:	83 c7 01             	add    $0x1,%edi
  801ab5:	eb ac                	jmp    801a63 <devpipe_write+0x20>
	return i;
  801ab7:	8b 45 10             	mov    0x10(%ebp),%eax
  801aba:	eb 05                	jmp    801ac1 <devpipe_write+0x7e>
				return 0;
  801abc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ac1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ac4:	5b                   	pop    %ebx
  801ac5:	5e                   	pop    %esi
  801ac6:	5f                   	pop    %edi
  801ac7:	5d                   	pop    %ebp
  801ac8:	c3                   	ret    

00801ac9 <devpipe_read>:
{
  801ac9:	f3 0f 1e fb          	endbr32 
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
  801ad0:	57                   	push   %edi
  801ad1:	56                   	push   %esi
  801ad2:	53                   	push   %ebx
  801ad3:	83 ec 18             	sub    $0x18,%esp
  801ad6:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801ad9:	57                   	push   %edi
  801ada:	e8 49 f6 ff ff       	call   801128 <fd2data>
  801adf:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ae1:	83 c4 10             	add    $0x10,%esp
  801ae4:	be 00 00 00 00       	mov    $0x0,%esi
  801ae9:	3b 75 10             	cmp    0x10(%ebp),%esi
  801aec:	75 14                	jne    801b02 <devpipe_read+0x39>
	return i;
  801aee:	8b 45 10             	mov    0x10(%ebp),%eax
  801af1:	eb 02                	jmp    801af5 <devpipe_read+0x2c>
				return i;
  801af3:	89 f0                	mov    %esi,%eax
}
  801af5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801af8:	5b                   	pop    %ebx
  801af9:	5e                   	pop    %esi
  801afa:	5f                   	pop    %edi
  801afb:	5d                   	pop    %ebp
  801afc:	c3                   	ret    
			sys_yield();
  801afd:	e8 e5 f0 ff ff       	call   800be7 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801b02:	8b 03                	mov    (%ebx),%eax
  801b04:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b07:	75 18                	jne    801b21 <devpipe_read+0x58>
			if (i > 0)
  801b09:	85 f6                	test   %esi,%esi
  801b0b:	75 e6                	jne    801af3 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801b0d:	89 da                	mov    %ebx,%edx
  801b0f:	89 f8                	mov    %edi,%eax
  801b11:	e8 c8 fe ff ff       	call   8019de <_pipeisclosed>
  801b16:	85 c0                	test   %eax,%eax
  801b18:	74 e3                	je     801afd <devpipe_read+0x34>
				return 0;
  801b1a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b1f:	eb d4                	jmp    801af5 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801b21:	99                   	cltd   
  801b22:	c1 ea 1b             	shr    $0x1b,%edx
  801b25:	01 d0                	add    %edx,%eax
  801b27:	83 e0 1f             	and    $0x1f,%eax
  801b2a:	29 d0                	sub    %edx,%eax
  801b2c:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801b31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b34:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801b37:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801b3a:	83 c6 01             	add    $0x1,%esi
  801b3d:	eb aa                	jmp    801ae9 <devpipe_read+0x20>

00801b3f <pipe>:
{
  801b3f:	f3 0f 1e fb          	endbr32 
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
  801b46:	56                   	push   %esi
  801b47:	53                   	push   %ebx
  801b48:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801b4b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b4e:	50                   	push   %eax
  801b4f:	e8 ef f5 ff ff       	call   801143 <fd_alloc>
  801b54:	89 c3                	mov    %eax,%ebx
  801b56:	83 c4 10             	add    $0x10,%esp
  801b59:	85 c0                	test   %eax,%eax
  801b5b:	0f 88 23 01 00 00    	js     801c84 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b61:	83 ec 04             	sub    $0x4,%esp
  801b64:	68 07 04 00 00       	push   $0x407
  801b69:	ff 75 f4             	pushl  -0xc(%ebp)
  801b6c:	6a 00                	push   $0x0
  801b6e:	e8 97 f0 ff ff       	call   800c0a <sys_page_alloc>
  801b73:	89 c3                	mov    %eax,%ebx
  801b75:	83 c4 10             	add    $0x10,%esp
  801b78:	85 c0                	test   %eax,%eax
  801b7a:	0f 88 04 01 00 00    	js     801c84 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801b80:	83 ec 0c             	sub    $0xc,%esp
  801b83:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b86:	50                   	push   %eax
  801b87:	e8 b7 f5 ff ff       	call   801143 <fd_alloc>
  801b8c:	89 c3                	mov    %eax,%ebx
  801b8e:	83 c4 10             	add    $0x10,%esp
  801b91:	85 c0                	test   %eax,%eax
  801b93:	0f 88 db 00 00 00    	js     801c74 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b99:	83 ec 04             	sub    $0x4,%esp
  801b9c:	68 07 04 00 00       	push   $0x407
  801ba1:	ff 75 f0             	pushl  -0x10(%ebp)
  801ba4:	6a 00                	push   $0x0
  801ba6:	e8 5f f0 ff ff       	call   800c0a <sys_page_alloc>
  801bab:	89 c3                	mov    %eax,%ebx
  801bad:	83 c4 10             	add    $0x10,%esp
  801bb0:	85 c0                	test   %eax,%eax
  801bb2:	0f 88 bc 00 00 00    	js     801c74 <pipe+0x135>
	va = fd2data(fd0);
  801bb8:	83 ec 0c             	sub    $0xc,%esp
  801bbb:	ff 75 f4             	pushl  -0xc(%ebp)
  801bbe:	e8 65 f5 ff ff       	call   801128 <fd2data>
  801bc3:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bc5:	83 c4 0c             	add    $0xc,%esp
  801bc8:	68 07 04 00 00       	push   $0x407
  801bcd:	50                   	push   %eax
  801bce:	6a 00                	push   $0x0
  801bd0:	e8 35 f0 ff ff       	call   800c0a <sys_page_alloc>
  801bd5:	89 c3                	mov    %eax,%ebx
  801bd7:	83 c4 10             	add    $0x10,%esp
  801bda:	85 c0                	test   %eax,%eax
  801bdc:	0f 88 82 00 00 00    	js     801c64 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801be2:	83 ec 0c             	sub    $0xc,%esp
  801be5:	ff 75 f0             	pushl  -0x10(%ebp)
  801be8:	e8 3b f5 ff ff       	call   801128 <fd2data>
  801bed:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801bf4:	50                   	push   %eax
  801bf5:	6a 00                	push   $0x0
  801bf7:	56                   	push   %esi
  801bf8:	6a 00                	push   $0x0
  801bfa:	e8 52 f0 ff ff       	call   800c51 <sys_page_map>
  801bff:	89 c3                	mov    %eax,%ebx
  801c01:	83 c4 20             	add    $0x20,%esp
  801c04:	85 c0                	test   %eax,%eax
  801c06:	78 4e                	js     801c56 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801c08:	a1 20 30 80 00       	mov    0x803020,%eax
  801c0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c10:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801c12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c15:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801c1c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c1f:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801c21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c24:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801c2b:	83 ec 0c             	sub    $0xc,%esp
  801c2e:	ff 75 f4             	pushl  -0xc(%ebp)
  801c31:	e8 de f4 ff ff       	call   801114 <fd2num>
  801c36:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c39:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801c3b:	83 c4 04             	add    $0x4,%esp
  801c3e:	ff 75 f0             	pushl  -0x10(%ebp)
  801c41:	e8 ce f4 ff ff       	call   801114 <fd2num>
  801c46:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c49:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801c4c:	83 c4 10             	add    $0x10,%esp
  801c4f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c54:	eb 2e                	jmp    801c84 <pipe+0x145>
	sys_page_unmap(0, va);
  801c56:	83 ec 08             	sub    $0x8,%esp
  801c59:	56                   	push   %esi
  801c5a:	6a 00                	push   $0x0
  801c5c:	e8 36 f0 ff ff       	call   800c97 <sys_page_unmap>
  801c61:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801c64:	83 ec 08             	sub    $0x8,%esp
  801c67:	ff 75 f0             	pushl  -0x10(%ebp)
  801c6a:	6a 00                	push   $0x0
  801c6c:	e8 26 f0 ff ff       	call   800c97 <sys_page_unmap>
  801c71:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801c74:	83 ec 08             	sub    $0x8,%esp
  801c77:	ff 75 f4             	pushl  -0xc(%ebp)
  801c7a:	6a 00                	push   $0x0
  801c7c:	e8 16 f0 ff ff       	call   800c97 <sys_page_unmap>
  801c81:	83 c4 10             	add    $0x10,%esp
}
  801c84:	89 d8                	mov    %ebx,%eax
  801c86:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c89:	5b                   	pop    %ebx
  801c8a:	5e                   	pop    %esi
  801c8b:	5d                   	pop    %ebp
  801c8c:	c3                   	ret    

00801c8d <pipeisclosed>:
{
  801c8d:	f3 0f 1e fb          	endbr32 
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
  801c94:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c97:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c9a:	50                   	push   %eax
  801c9b:	ff 75 08             	pushl  0x8(%ebp)
  801c9e:	e8 f6 f4 ff ff       	call   801199 <fd_lookup>
  801ca3:	83 c4 10             	add    $0x10,%esp
  801ca6:	85 c0                	test   %eax,%eax
  801ca8:	78 18                	js     801cc2 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801caa:	83 ec 0c             	sub    $0xc,%esp
  801cad:	ff 75 f4             	pushl  -0xc(%ebp)
  801cb0:	e8 73 f4 ff ff       	call   801128 <fd2data>
  801cb5:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cba:	e8 1f fd ff ff       	call   8019de <_pipeisclosed>
  801cbf:	83 c4 10             	add    $0x10,%esp
}
  801cc2:	c9                   	leave  
  801cc3:	c3                   	ret    

00801cc4 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801cc4:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801cc8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ccd:	c3                   	ret    

00801cce <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801cce:	f3 0f 1e fb          	endbr32 
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
  801cd5:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801cd8:	68 3a 28 80 00       	push   $0x80283a
  801cdd:	ff 75 0c             	pushl  0xc(%ebp)
  801ce0:	e8 e3 ea ff ff       	call   8007c8 <strcpy>
	return 0;
}
  801ce5:	b8 00 00 00 00       	mov    $0x0,%eax
  801cea:	c9                   	leave  
  801ceb:	c3                   	ret    

00801cec <devcons_write>:
{
  801cec:	f3 0f 1e fb          	endbr32 
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
  801cf3:	57                   	push   %edi
  801cf4:	56                   	push   %esi
  801cf5:	53                   	push   %ebx
  801cf6:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801cfc:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801d01:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801d07:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d0a:	73 31                	jae    801d3d <devcons_write+0x51>
		m = n - tot;
  801d0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d0f:	29 f3                	sub    %esi,%ebx
  801d11:	83 fb 7f             	cmp    $0x7f,%ebx
  801d14:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801d19:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801d1c:	83 ec 04             	sub    $0x4,%esp
  801d1f:	53                   	push   %ebx
  801d20:	89 f0                	mov    %esi,%eax
  801d22:	03 45 0c             	add    0xc(%ebp),%eax
  801d25:	50                   	push   %eax
  801d26:	57                   	push   %edi
  801d27:	e8 52 ec ff ff       	call   80097e <memmove>
		sys_cputs(buf, m);
  801d2c:	83 c4 08             	add    $0x8,%esp
  801d2f:	53                   	push   %ebx
  801d30:	57                   	push   %edi
  801d31:	e8 04 ee ff ff       	call   800b3a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801d36:	01 de                	add    %ebx,%esi
  801d38:	83 c4 10             	add    $0x10,%esp
  801d3b:	eb ca                	jmp    801d07 <devcons_write+0x1b>
}
  801d3d:	89 f0                	mov    %esi,%eax
  801d3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d42:	5b                   	pop    %ebx
  801d43:	5e                   	pop    %esi
  801d44:	5f                   	pop    %edi
  801d45:	5d                   	pop    %ebp
  801d46:	c3                   	ret    

00801d47 <devcons_read>:
{
  801d47:	f3 0f 1e fb          	endbr32 
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
  801d4e:	83 ec 08             	sub    $0x8,%esp
  801d51:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801d56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d5a:	74 21                	je     801d7d <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801d5c:	e8 fb ed ff ff       	call   800b5c <sys_cgetc>
  801d61:	85 c0                	test   %eax,%eax
  801d63:	75 07                	jne    801d6c <devcons_read+0x25>
		sys_yield();
  801d65:	e8 7d ee ff ff       	call   800be7 <sys_yield>
  801d6a:	eb f0                	jmp    801d5c <devcons_read+0x15>
	if (c < 0)
  801d6c:	78 0f                	js     801d7d <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801d6e:	83 f8 04             	cmp    $0x4,%eax
  801d71:	74 0c                	je     801d7f <devcons_read+0x38>
	*(char*)vbuf = c;
  801d73:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d76:	88 02                	mov    %al,(%edx)
	return 1;
  801d78:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d7d:	c9                   	leave  
  801d7e:	c3                   	ret    
		return 0;
  801d7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d84:	eb f7                	jmp    801d7d <devcons_read+0x36>

00801d86 <cputchar>:
{
  801d86:	f3 0f 1e fb          	endbr32 
  801d8a:	55                   	push   %ebp
  801d8b:	89 e5                	mov    %esp,%ebp
  801d8d:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801d90:	8b 45 08             	mov    0x8(%ebp),%eax
  801d93:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801d96:	6a 01                	push   $0x1
  801d98:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d9b:	50                   	push   %eax
  801d9c:	e8 99 ed ff ff       	call   800b3a <sys_cputs>
}
  801da1:	83 c4 10             	add    $0x10,%esp
  801da4:	c9                   	leave  
  801da5:	c3                   	ret    

00801da6 <getchar>:
{
  801da6:	f3 0f 1e fb          	endbr32 
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
  801dad:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801db0:	6a 01                	push   $0x1
  801db2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801db5:	50                   	push   %eax
  801db6:	6a 00                	push   $0x0
  801db8:	e8 5f f6 ff ff       	call   80141c <read>
	if (r < 0)
  801dbd:	83 c4 10             	add    $0x10,%esp
  801dc0:	85 c0                	test   %eax,%eax
  801dc2:	78 06                	js     801dca <getchar+0x24>
	if (r < 1)
  801dc4:	74 06                	je     801dcc <getchar+0x26>
	return c;
  801dc6:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801dca:	c9                   	leave  
  801dcb:	c3                   	ret    
		return -E_EOF;
  801dcc:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801dd1:	eb f7                	jmp    801dca <getchar+0x24>

00801dd3 <iscons>:
{
  801dd3:	f3 0f 1e fb          	endbr32 
  801dd7:	55                   	push   %ebp
  801dd8:	89 e5                	mov    %esp,%ebp
  801dda:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ddd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801de0:	50                   	push   %eax
  801de1:	ff 75 08             	pushl  0x8(%ebp)
  801de4:	e8 b0 f3 ff ff       	call   801199 <fd_lookup>
  801de9:	83 c4 10             	add    $0x10,%esp
  801dec:	85 c0                	test   %eax,%eax
  801dee:	78 11                	js     801e01 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df3:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801df9:	39 10                	cmp    %edx,(%eax)
  801dfb:	0f 94 c0             	sete   %al
  801dfe:	0f b6 c0             	movzbl %al,%eax
}
  801e01:	c9                   	leave  
  801e02:	c3                   	ret    

00801e03 <opencons>:
{
  801e03:	f3 0f 1e fb          	endbr32 
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
  801e0a:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801e0d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e10:	50                   	push   %eax
  801e11:	e8 2d f3 ff ff       	call   801143 <fd_alloc>
  801e16:	83 c4 10             	add    $0x10,%esp
  801e19:	85 c0                	test   %eax,%eax
  801e1b:	78 3a                	js     801e57 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e1d:	83 ec 04             	sub    $0x4,%esp
  801e20:	68 07 04 00 00       	push   $0x407
  801e25:	ff 75 f4             	pushl  -0xc(%ebp)
  801e28:	6a 00                	push   $0x0
  801e2a:	e8 db ed ff ff       	call   800c0a <sys_page_alloc>
  801e2f:	83 c4 10             	add    $0x10,%esp
  801e32:	85 c0                	test   %eax,%eax
  801e34:	78 21                	js     801e57 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e39:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e3f:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e44:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801e4b:	83 ec 0c             	sub    $0xc,%esp
  801e4e:	50                   	push   %eax
  801e4f:	e8 c0 f2 ff ff       	call   801114 <fd2num>
  801e54:	83 c4 10             	add    $0x10,%esp
}
  801e57:	c9                   	leave  
  801e58:	c3                   	ret    

00801e59 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801e59:	f3 0f 1e fb          	endbr32 
  801e5d:	55                   	push   %ebp
  801e5e:	89 e5                	mov    %esp,%ebp
  801e60:	56                   	push   %esi
  801e61:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801e62:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801e65:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801e6b:	e8 54 ed ff ff       	call   800bc4 <sys_getenvid>
  801e70:	83 ec 0c             	sub    $0xc,%esp
  801e73:	ff 75 0c             	pushl  0xc(%ebp)
  801e76:	ff 75 08             	pushl  0x8(%ebp)
  801e79:	56                   	push   %esi
  801e7a:	50                   	push   %eax
  801e7b:	68 48 28 80 00       	push   $0x802848
  801e80:	e8 39 e3 ff ff       	call   8001be <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801e85:	83 c4 18             	add    $0x18,%esp
  801e88:	53                   	push   %ebx
  801e89:	ff 75 10             	pushl  0x10(%ebp)
  801e8c:	e8 d8 e2 ff ff       	call   800169 <vcprintf>
	cprintf("\n");
  801e91:	c7 04 24 94 23 80 00 	movl   $0x802394,(%esp)
  801e98:	e8 21 e3 ff ff       	call   8001be <cprintf>
  801e9d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801ea0:	cc                   	int3   
  801ea1:	eb fd                	jmp    801ea0 <_panic+0x47>

00801ea3 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801ea3:	f3 0f 1e fb          	endbr32 
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
  801eaa:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801ead:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801eb4:	74 0a                	je     801ec0 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb9:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801ebe:	c9                   	leave  
  801ebf:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  801ec0:	83 ec 04             	sub    $0x4,%esp
  801ec3:	6a 07                	push   $0x7
  801ec5:	68 00 f0 bf ee       	push   $0xeebff000
  801eca:	6a 00                	push   $0x0
  801ecc:	e8 39 ed ff ff       	call   800c0a <sys_page_alloc>
  801ed1:	83 c4 10             	add    $0x10,%esp
  801ed4:	85 c0                	test   %eax,%eax
  801ed6:	78 2a                	js     801f02 <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  801ed8:	83 ec 08             	sub    $0x8,%esp
  801edb:	68 16 1f 80 00       	push   $0x801f16
  801ee0:	6a 00                	push   $0x0
  801ee2:	e8 82 ee ff ff       	call   800d69 <sys_env_set_pgfault_upcall>
  801ee7:	83 c4 10             	add    $0x10,%esp
  801eea:	85 c0                	test   %eax,%eax
  801eec:	79 c8                	jns    801eb6 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  801eee:	83 ec 04             	sub    $0x4,%esp
  801ef1:	68 98 28 80 00       	push   $0x802898
  801ef6:	6a 25                	push   $0x25
  801ef8:	68 d0 28 80 00       	push   $0x8028d0
  801efd:	e8 57 ff ff ff       	call   801e59 <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  801f02:	83 ec 04             	sub    $0x4,%esp
  801f05:	68 6c 28 80 00       	push   $0x80286c
  801f0a:	6a 22                	push   $0x22
  801f0c:	68 d0 28 80 00       	push   $0x8028d0
  801f11:	e8 43 ff ff ff       	call   801e59 <_panic>

00801f16 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801f16:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801f17:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  801f1c:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801f1e:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  801f21:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  801f25:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  801f29:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  801f2c:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  801f2e:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  801f32:	83 c4 08             	add    $0x8,%esp
	popal
  801f35:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  801f36:	83 c4 04             	add    $0x4,%esp
	popfl
  801f39:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  801f3a:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  801f3b:	c3                   	ret    

00801f3c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f3c:	f3 0f 1e fb          	endbr32 
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
  801f43:	56                   	push   %esi
  801f44:	53                   	push   %ebx
  801f45:	8b 75 08             	mov    0x8(%ebp),%esi
  801f48:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f4b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  801f4e:	85 c0                	test   %eax,%eax
  801f50:	74 3d                	je     801f8f <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  801f52:	83 ec 0c             	sub    $0xc,%esp
  801f55:	50                   	push   %eax
  801f56:	e8 7b ee ff ff       	call   800dd6 <sys_ipc_recv>
  801f5b:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  801f5e:	85 f6                	test   %esi,%esi
  801f60:	74 0b                	je     801f6d <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801f62:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801f68:	8b 52 74             	mov    0x74(%edx),%edx
  801f6b:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801f6d:	85 db                	test   %ebx,%ebx
  801f6f:	74 0b                	je     801f7c <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  801f71:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801f77:	8b 52 78             	mov    0x78(%edx),%edx
  801f7a:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  801f7c:	85 c0                	test   %eax,%eax
  801f7e:	78 21                	js     801fa1 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  801f80:	a1 04 40 80 00       	mov    0x804004,%eax
  801f85:	8b 40 70             	mov    0x70(%eax),%eax
}
  801f88:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f8b:	5b                   	pop    %ebx
  801f8c:	5e                   	pop    %esi
  801f8d:	5d                   	pop    %ebp
  801f8e:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  801f8f:	83 ec 0c             	sub    $0xc,%esp
  801f92:	68 00 00 c0 ee       	push   $0xeec00000
  801f97:	e8 3a ee ff ff       	call   800dd6 <sys_ipc_recv>
  801f9c:	83 c4 10             	add    $0x10,%esp
  801f9f:	eb bd                	jmp    801f5e <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  801fa1:	85 f6                	test   %esi,%esi
  801fa3:	74 10                	je     801fb5 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  801fa5:	85 db                	test   %ebx,%ebx
  801fa7:	75 df                	jne    801f88 <ipc_recv+0x4c>
  801fa9:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801fb0:	00 00 00 
  801fb3:	eb d3                	jmp    801f88 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  801fb5:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801fbc:	00 00 00 
  801fbf:	eb e4                	jmp    801fa5 <ipc_recv+0x69>

00801fc1 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801fc1:	f3 0f 1e fb          	endbr32 
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
  801fc8:	57                   	push   %edi
  801fc9:	56                   	push   %esi
  801fca:	53                   	push   %ebx
  801fcb:	83 ec 0c             	sub    $0xc,%esp
  801fce:	8b 7d 08             	mov    0x8(%ebp),%edi
  801fd1:	8b 75 0c             	mov    0xc(%ebp),%esi
  801fd4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  801fd7:	85 db                	test   %ebx,%ebx
  801fd9:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801fde:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  801fe1:	ff 75 14             	pushl  0x14(%ebp)
  801fe4:	53                   	push   %ebx
  801fe5:	56                   	push   %esi
  801fe6:	57                   	push   %edi
  801fe7:	e8 c3 ed ff ff       	call   800daf <sys_ipc_try_send>
  801fec:	83 c4 10             	add    $0x10,%esp
  801fef:	85 c0                	test   %eax,%eax
  801ff1:	79 1e                	jns    802011 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  801ff3:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801ff6:	75 07                	jne    801fff <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  801ff8:	e8 ea eb ff ff       	call   800be7 <sys_yield>
  801ffd:	eb e2                	jmp    801fe1 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  801fff:	50                   	push   %eax
  802000:	68 de 28 80 00       	push   $0x8028de
  802005:	6a 59                	push   $0x59
  802007:	68 f9 28 80 00       	push   $0x8028f9
  80200c:	e8 48 fe ff ff       	call   801e59 <_panic>
	}
}
  802011:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802014:	5b                   	pop    %ebx
  802015:	5e                   	pop    %esi
  802016:	5f                   	pop    %edi
  802017:	5d                   	pop    %ebp
  802018:	c3                   	ret    

00802019 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802019:	f3 0f 1e fb          	endbr32 
  80201d:	55                   	push   %ebp
  80201e:	89 e5                	mov    %esp,%ebp
  802020:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802023:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802028:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80202b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802031:	8b 52 50             	mov    0x50(%edx),%edx
  802034:	39 ca                	cmp    %ecx,%edx
  802036:	74 11                	je     802049 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802038:	83 c0 01             	add    $0x1,%eax
  80203b:	3d 00 04 00 00       	cmp    $0x400,%eax
  802040:	75 e6                	jne    802028 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802042:	b8 00 00 00 00       	mov    $0x0,%eax
  802047:	eb 0b                	jmp    802054 <ipc_find_env+0x3b>
			return envs[i].env_id;
  802049:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80204c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802051:	8b 40 48             	mov    0x48(%eax),%eax
}
  802054:	5d                   	pop    %ebp
  802055:	c3                   	ret    

00802056 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802056:	f3 0f 1e fb          	endbr32 
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
  80205d:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802060:	89 c2                	mov    %eax,%edx
  802062:	c1 ea 16             	shr    $0x16,%edx
  802065:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80206c:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802071:	f6 c1 01             	test   $0x1,%cl
  802074:	74 1c                	je     802092 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802076:	c1 e8 0c             	shr    $0xc,%eax
  802079:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802080:	a8 01                	test   $0x1,%al
  802082:	74 0e                	je     802092 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802084:	c1 e8 0c             	shr    $0xc,%eax
  802087:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80208e:	ef 
  80208f:	0f b7 d2             	movzwl %dx,%edx
}
  802092:	89 d0                	mov    %edx,%eax
  802094:	5d                   	pop    %ebp
  802095:	c3                   	ret    
  802096:	66 90                	xchg   %ax,%ax
  802098:	66 90                	xchg   %ax,%ax
  80209a:	66 90                	xchg   %ax,%ax
  80209c:	66 90                	xchg   %ax,%ax
  80209e:	66 90                	xchg   %ax,%ax

008020a0 <__udivdi3>:
  8020a0:	f3 0f 1e fb          	endbr32 
  8020a4:	55                   	push   %ebp
  8020a5:	57                   	push   %edi
  8020a6:	56                   	push   %esi
  8020a7:	53                   	push   %ebx
  8020a8:	83 ec 1c             	sub    $0x1c,%esp
  8020ab:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8020af:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8020b3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8020b7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8020bb:	85 d2                	test   %edx,%edx
  8020bd:	75 19                	jne    8020d8 <__udivdi3+0x38>
  8020bf:	39 f3                	cmp    %esi,%ebx
  8020c1:	76 4d                	jbe    802110 <__udivdi3+0x70>
  8020c3:	31 ff                	xor    %edi,%edi
  8020c5:	89 e8                	mov    %ebp,%eax
  8020c7:	89 f2                	mov    %esi,%edx
  8020c9:	f7 f3                	div    %ebx
  8020cb:	89 fa                	mov    %edi,%edx
  8020cd:	83 c4 1c             	add    $0x1c,%esp
  8020d0:	5b                   	pop    %ebx
  8020d1:	5e                   	pop    %esi
  8020d2:	5f                   	pop    %edi
  8020d3:	5d                   	pop    %ebp
  8020d4:	c3                   	ret    
  8020d5:	8d 76 00             	lea    0x0(%esi),%esi
  8020d8:	39 f2                	cmp    %esi,%edx
  8020da:	76 14                	jbe    8020f0 <__udivdi3+0x50>
  8020dc:	31 ff                	xor    %edi,%edi
  8020de:	31 c0                	xor    %eax,%eax
  8020e0:	89 fa                	mov    %edi,%edx
  8020e2:	83 c4 1c             	add    $0x1c,%esp
  8020e5:	5b                   	pop    %ebx
  8020e6:	5e                   	pop    %esi
  8020e7:	5f                   	pop    %edi
  8020e8:	5d                   	pop    %ebp
  8020e9:	c3                   	ret    
  8020ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8020f0:	0f bd fa             	bsr    %edx,%edi
  8020f3:	83 f7 1f             	xor    $0x1f,%edi
  8020f6:	75 48                	jne    802140 <__udivdi3+0xa0>
  8020f8:	39 f2                	cmp    %esi,%edx
  8020fa:	72 06                	jb     802102 <__udivdi3+0x62>
  8020fc:	31 c0                	xor    %eax,%eax
  8020fe:	39 eb                	cmp    %ebp,%ebx
  802100:	77 de                	ja     8020e0 <__udivdi3+0x40>
  802102:	b8 01 00 00 00       	mov    $0x1,%eax
  802107:	eb d7                	jmp    8020e0 <__udivdi3+0x40>
  802109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802110:	89 d9                	mov    %ebx,%ecx
  802112:	85 db                	test   %ebx,%ebx
  802114:	75 0b                	jne    802121 <__udivdi3+0x81>
  802116:	b8 01 00 00 00       	mov    $0x1,%eax
  80211b:	31 d2                	xor    %edx,%edx
  80211d:	f7 f3                	div    %ebx
  80211f:	89 c1                	mov    %eax,%ecx
  802121:	31 d2                	xor    %edx,%edx
  802123:	89 f0                	mov    %esi,%eax
  802125:	f7 f1                	div    %ecx
  802127:	89 c6                	mov    %eax,%esi
  802129:	89 e8                	mov    %ebp,%eax
  80212b:	89 f7                	mov    %esi,%edi
  80212d:	f7 f1                	div    %ecx
  80212f:	89 fa                	mov    %edi,%edx
  802131:	83 c4 1c             	add    $0x1c,%esp
  802134:	5b                   	pop    %ebx
  802135:	5e                   	pop    %esi
  802136:	5f                   	pop    %edi
  802137:	5d                   	pop    %ebp
  802138:	c3                   	ret    
  802139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802140:	89 f9                	mov    %edi,%ecx
  802142:	b8 20 00 00 00       	mov    $0x20,%eax
  802147:	29 f8                	sub    %edi,%eax
  802149:	d3 e2                	shl    %cl,%edx
  80214b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80214f:	89 c1                	mov    %eax,%ecx
  802151:	89 da                	mov    %ebx,%edx
  802153:	d3 ea                	shr    %cl,%edx
  802155:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802159:	09 d1                	or     %edx,%ecx
  80215b:	89 f2                	mov    %esi,%edx
  80215d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802161:	89 f9                	mov    %edi,%ecx
  802163:	d3 e3                	shl    %cl,%ebx
  802165:	89 c1                	mov    %eax,%ecx
  802167:	d3 ea                	shr    %cl,%edx
  802169:	89 f9                	mov    %edi,%ecx
  80216b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80216f:	89 eb                	mov    %ebp,%ebx
  802171:	d3 e6                	shl    %cl,%esi
  802173:	89 c1                	mov    %eax,%ecx
  802175:	d3 eb                	shr    %cl,%ebx
  802177:	09 de                	or     %ebx,%esi
  802179:	89 f0                	mov    %esi,%eax
  80217b:	f7 74 24 08          	divl   0x8(%esp)
  80217f:	89 d6                	mov    %edx,%esi
  802181:	89 c3                	mov    %eax,%ebx
  802183:	f7 64 24 0c          	mull   0xc(%esp)
  802187:	39 d6                	cmp    %edx,%esi
  802189:	72 15                	jb     8021a0 <__udivdi3+0x100>
  80218b:	89 f9                	mov    %edi,%ecx
  80218d:	d3 e5                	shl    %cl,%ebp
  80218f:	39 c5                	cmp    %eax,%ebp
  802191:	73 04                	jae    802197 <__udivdi3+0xf7>
  802193:	39 d6                	cmp    %edx,%esi
  802195:	74 09                	je     8021a0 <__udivdi3+0x100>
  802197:	89 d8                	mov    %ebx,%eax
  802199:	31 ff                	xor    %edi,%edi
  80219b:	e9 40 ff ff ff       	jmp    8020e0 <__udivdi3+0x40>
  8021a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021a3:	31 ff                	xor    %edi,%edi
  8021a5:	e9 36 ff ff ff       	jmp    8020e0 <__udivdi3+0x40>
  8021aa:	66 90                	xchg   %ax,%ax
  8021ac:	66 90                	xchg   %ax,%ax
  8021ae:	66 90                	xchg   %ax,%ax

008021b0 <__umoddi3>:
  8021b0:	f3 0f 1e fb          	endbr32 
  8021b4:	55                   	push   %ebp
  8021b5:	57                   	push   %edi
  8021b6:	56                   	push   %esi
  8021b7:	53                   	push   %ebx
  8021b8:	83 ec 1c             	sub    $0x1c,%esp
  8021bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8021bf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8021c3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8021c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021cb:	85 c0                	test   %eax,%eax
  8021cd:	75 19                	jne    8021e8 <__umoddi3+0x38>
  8021cf:	39 df                	cmp    %ebx,%edi
  8021d1:	76 5d                	jbe    802230 <__umoddi3+0x80>
  8021d3:	89 f0                	mov    %esi,%eax
  8021d5:	89 da                	mov    %ebx,%edx
  8021d7:	f7 f7                	div    %edi
  8021d9:	89 d0                	mov    %edx,%eax
  8021db:	31 d2                	xor    %edx,%edx
  8021dd:	83 c4 1c             	add    $0x1c,%esp
  8021e0:	5b                   	pop    %ebx
  8021e1:	5e                   	pop    %esi
  8021e2:	5f                   	pop    %edi
  8021e3:	5d                   	pop    %ebp
  8021e4:	c3                   	ret    
  8021e5:	8d 76 00             	lea    0x0(%esi),%esi
  8021e8:	89 f2                	mov    %esi,%edx
  8021ea:	39 d8                	cmp    %ebx,%eax
  8021ec:	76 12                	jbe    802200 <__umoddi3+0x50>
  8021ee:	89 f0                	mov    %esi,%eax
  8021f0:	89 da                	mov    %ebx,%edx
  8021f2:	83 c4 1c             	add    $0x1c,%esp
  8021f5:	5b                   	pop    %ebx
  8021f6:	5e                   	pop    %esi
  8021f7:	5f                   	pop    %edi
  8021f8:	5d                   	pop    %ebp
  8021f9:	c3                   	ret    
  8021fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802200:	0f bd e8             	bsr    %eax,%ebp
  802203:	83 f5 1f             	xor    $0x1f,%ebp
  802206:	75 50                	jne    802258 <__umoddi3+0xa8>
  802208:	39 d8                	cmp    %ebx,%eax
  80220a:	0f 82 e0 00 00 00    	jb     8022f0 <__umoddi3+0x140>
  802210:	89 d9                	mov    %ebx,%ecx
  802212:	39 f7                	cmp    %esi,%edi
  802214:	0f 86 d6 00 00 00    	jbe    8022f0 <__umoddi3+0x140>
  80221a:	89 d0                	mov    %edx,%eax
  80221c:	89 ca                	mov    %ecx,%edx
  80221e:	83 c4 1c             	add    $0x1c,%esp
  802221:	5b                   	pop    %ebx
  802222:	5e                   	pop    %esi
  802223:	5f                   	pop    %edi
  802224:	5d                   	pop    %ebp
  802225:	c3                   	ret    
  802226:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80222d:	8d 76 00             	lea    0x0(%esi),%esi
  802230:	89 fd                	mov    %edi,%ebp
  802232:	85 ff                	test   %edi,%edi
  802234:	75 0b                	jne    802241 <__umoddi3+0x91>
  802236:	b8 01 00 00 00       	mov    $0x1,%eax
  80223b:	31 d2                	xor    %edx,%edx
  80223d:	f7 f7                	div    %edi
  80223f:	89 c5                	mov    %eax,%ebp
  802241:	89 d8                	mov    %ebx,%eax
  802243:	31 d2                	xor    %edx,%edx
  802245:	f7 f5                	div    %ebp
  802247:	89 f0                	mov    %esi,%eax
  802249:	f7 f5                	div    %ebp
  80224b:	89 d0                	mov    %edx,%eax
  80224d:	31 d2                	xor    %edx,%edx
  80224f:	eb 8c                	jmp    8021dd <__umoddi3+0x2d>
  802251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802258:	89 e9                	mov    %ebp,%ecx
  80225a:	ba 20 00 00 00       	mov    $0x20,%edx
  80225f:	29 ea                	sub    %ebp,%edx
  802261:	d3 e0                	shl    %cl,%eax
  802263:	89 44 24 08          	mov    %eax,0x8(%esp)
  802267:	89 d1                	mov    %edx,%ecx
  802269:	89 f8                	mov    %edi,%eax
  80226b:	d3 e8                	shr    %cl,%eax
  80226d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802271:	89 54 24 04          	mov    %edx,0x4(%esp)
  802275:	8b 54 24 04          	mov    0x4(%esp),%edx
  802279:	09 c1                	or     %eax,%ecx
  80227b:	89 d8                	mov    %ebx,%eax
  80227d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802281:	89 e9                	mov    %ebp,%ecx
  802283:	d3 e7                	shl    %cl,%edi
  802285:	89 d1                	mov    %edx,%ecx
  802287:	d3 e8                	shr    %cl,%eax
  802289:	89 e9                	mov    %ebp,%ecx
  80228b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80228f:	d3 e3                	shl    %cl,%ebx
  802291:	89 c7                	mov    %eax,%edi
  802293:	89 d1                	mov    %edx,%ecx
  802295:	89 f0                	mov    %esi,%eax
  802297:	d3 e8                	shr    %cl,%eax
  802299:	89 e9                	mov    %ebp,%ecx
  80229b:	89 fa                	mov    %edi,%edx
  80229d:	d3 e6                	shl    %cl,%esi
  80229f:	09 d8                	or     %ebx,%eax
  8022a1:	f7 74 24 08          	divl   0x8(%esp)
  8022a5:	89 d1                	mov    %edx,%ecx
  8022a7:	89 f3                	mov    %esi,%ebx
  8022a9:	f7 64 24 0c          	mull   0xc(%esp)
  8022ad:	89 c6                	mov    %eax,%esi
  8022af:	89 d7                	mov    %edx,%edi
  8022b1:	39 d1                	cmp    %edx,%ecx
  8022b3:	72 06                	jb     8022bb <__umoddi3+0x10b>
  8022b5:	75 10                	jne    8022c7 <__umoddi3+0x117>
  8022b7:	39 c3                	cmp    %eax,%ebx
  8022b9:	73 0c                	jae    8022c7 <__umoddi3+0x117>
  8022bb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8022bf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8022c3:	89 d7                	mov    %edx,%edi
  8022c5:	89 c6                	mov    %eax,%esi
  8022c7:	89 ca                	mov    %ecx,%edx
  8022c9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8022ce:	29 f3                	sub    %esi,%ebx
  8022d0:	19 fa                	sbb    %edi,%edx
  8022d2:	89 d0                	mov    %edx,%eax
  8022d4:	d3 e0                	shl    %cl,%eax
  8022d6:	89 e9                	mov    %ebp,%ecx
  8022d8:	d3 eb                	shr    %cl,%ebx
  8022da:	d3 ea                	shr    %cl,%edx
  8022dc:	09 d8                	or     %ebx,%eax
  8022de:	83 c4 1c             	add    $0x1c,%esp
  8022e1:	5b                   	pop    %ebx
  8022e2:	5e                   	pop    %esi
  8022e3:	5f                   	pop    %edi
  8022e4:	5d                   	pop    %ebp
  8022e5:	c3                   	ret    
  8022e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022ed:	8d 76 00             	lea    0x0(%esi),%esi
  8022f0:	29 fe                	sub    %edi,%esi
  8022f2:	19 c3                	sbb    %eax,%ebx
  8022f4:	89 f2                	mov    %esi,%edx
  8022f6:	89 d9                	mov    %ebx,%ecx
  8022f8:	e9 1d ff ff ff       	jmp    80221a <__umoddi3+0x6a>
