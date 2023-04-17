
obj/user/spawnfaultio.debug:     file format elf32-i386


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
  80002c:	e8 4e 00 00 00       	call   80007f <libmain>
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
  80003a:	83 ec 10             	sub    $0x10,%esp
	int r;
	cprintf("i am parent environment %08x\n", thisenv->env_id);
  80003d:	a1 04 40 80 00       	mov    0x804004,%eax
  800042:	8b 40 48             	mov    0x48(%eax),%eax
  800045:	50                   	push   %eax
  800046:	68 40 25 80 00       	push   $0x802540
  80004b:	e8 7e 01 00 00       	call   8001ce <cprintf>
	if ((r = spawnl("faultio", "faultio", 0)) < 0)
  800050:	83 c4 0c             	add    $0xc,%esp
  800053:	6a 00                	push   $0x0
  800055:	68 5e 25 80 00       	push   $0x80255e
  80005a:	68 5e 25 80 00       	push   $0x80255e
  80005f:	e8 6d 1b 00 00       	call   801bd1 <spawnl>
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	85 c0                	test   %eax,%eax
  800069:	78 02                	js     80006d <umain+0x3a>
		panic("spawn(faultio) failed: %e", r);
}
  80006b:	c9                   	leave  
  80006c:	c3                   	ret    
		panic("spawn(faultio) failed: %e", r);
  80006d:	50                   	push   %eax
  80006e:	68 66 25 80 00       	push   $0x802566
  800073:	6a 09                	push   $0x9
  800075:	68 80 25 80 00       	push   $0x802580
  80007a:	e8 68 00 00 00       	call   8000e7 <_panic>

0080007f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80007f:	f3 0f 1e fb          	endbr32 
  800083:	55                   	push   %ebp
  800084:	89 e5                	mov    %esp,%ebp
  800086:	56                   	push   %esi
  800087:	53                   	push   %ebx
  800088:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80008b:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80008e:	e8 41 0b 00 00       	call   800bd4 <sys_getenvid>
  800093:	25 ff 03 00 00       	and    $0x3ff,%eax
  800098:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80009b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000a0:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a5:	85 db                	test   %ebx,%ebx
  8000a7:	7e 07                	jle    8000b0 <libmain+0x31>
		binaryname = argv[0];
  8000a9:	8b 06                	mov    (%esi),%eax
  8000ab:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000b0:	83 ec 08             	sub    $0x8,%esp
  8000b3:	56                   	push   %esi
  8000b4:	53                   	push   %ebx
  8000b5:	e8 79 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000ba:	e8 0a 00 00 00       	call   8000c9 <exit>
}
  8000bf:	83 c4 10             	add    $0x10,%esp
  8000c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000c5:	5b                   	pop    %ebx
  8000c6:	5e                   	pop    %esi
  8000c7:	5d                   	pop    %ebp
  8000c8:	c3                   	ret    

008000c9 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000c9:	f3 0f 1e fb          	endbr32 
  8000cd:	55                   	push   %ebp
  8000ce:	89 e5                	mov    %esp,%ebp
  8000d0:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000d3:	e8 42 0f 00 00       	call   80101a <close_all>
	sys_env_destroy(0);
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	6a 00                	push   $0x0
  8000dd:	e8 ad 0a 00 00       	call   800b8f <sys_env_destroy>
}
  8000e2:	83 c4 10             	add    $0x10,%esp
  8000e5:	c9                   	leave  
  8000e6:	c3                   	ret    

008000e7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8000e7:	f3 0f 1e fb          	endbr32 
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	56                   	push   %esi
  8000ef:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8000f0:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8000f3:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8000f9:	e8 d6 0a 00 00       	call   800bd4 <sys_getenvid>
  8000fe:	83 ec 0c             	sub    $0xc,%esp
  800101:	ff 75 0c             	pushl  0xc(%ebp)
  800104:	ff 75 08             	pushl  0x8(%ebp)
  800107:	56                   	push   %esi
  800108:	50                   	push   %eax
  800109:	68 a0 25 80 00       	push   $0x8025a0
  80010e:	e8 bb 00 00 00       	call   8001ce <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800113:	83 c4 18             	add    $0x18,%esp
  800116:	53                   	push   %ebx
  800117:	ff 75 10             	pushl  0x10(%ebp)
  80011a:	e8 5a 00 00 00       	call   800179 <vcprintf>
	cprintf("\n");
  80011f:	c7 04 24 8a 2a 80 00 	movl   $0x802a8a,(%esp)
  800126:	e8 a3 00 00 00       	call   8001ce <cprintf>
  80012b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80012e:	cc                   	int3   
  80012f:	eb fd                	jmp    80012e <_panic+0x47>

00800131 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800131:	f3 0f 1e fb          	endbr32 
  800135:	55                   	push   %ebp
  800136:	89 e5                	mov    %esp,%ebp
  800138:	53                   	push   %ebx
  800139:	83 ec 04             	sub    $0x4,%esp
  80013c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80013f:	8b 13                	mov    (%ebx),%edx
  800141:	8d 42 01             	lea    0x1(%edx),%eax
  800144:	89 03                	mov    %eax,(%ebx)
  800146:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800149:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80014d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800152:	74 09                	je     80015d <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800154:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800158:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80015b:	c9                   	leave  
  80015c:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80015d:	83 ec 08             	sub    $0x8,%esp
  800160:	68 ff 00 00 00       	push   $0xff
  800165:	8d 43 08             	lea    0x8(%ebx),%eax
  800168:	50                   	push   %eax
  800169:	e8 dc 09 00 00       	call   800b4a <sys_cputs>
		b->idx = 0;
  80016e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800174:	83 c4 10             	add    $0x10,%esp
  800177:	eb db                	jmp    800154 <putch+0x23>

00800179 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800179:	f3 0f 1e fb          	endbr32 
  80017d:	55                   	push   %ebp
  80017e:	89 e5                	mov    %esp,%ebp
  800180:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800186:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80018d:	00 00 00 
	b.cnt = 0;
  800190:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800197:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80019a:	ff 75 0c             	pushl  0xc(%ebp)
  80019d:	ff 75 08             	pushl  0x8(%ebp)
  8001a0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001a6:	50                   	push   %eax
  8001a7:	68 31 01 80 00       	push   $0x800131
  8001ac:	e8 20 01 00 00       	call   8002d1 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001b1:	83 c4 08             	add    $0x8,%esp
  8001b4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001ba:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001c0:	50                   	push   %eax
  8001c1:	e8 84 09 00 00       	call   800b4a <sys_cputs>

	return b.cnt;
}
  8001c6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001cc:	c9                   	leave  
  8001cd:	c3                   	ret    

008001ce <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001ce:	f3 0f 1e fb          	endbr32 
  8001d2:	55                   	push   %ebp
  8001d3:	89 e5                	mov    %esp,%ebp
  8001d5:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001d8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001db:	50                   	push   %eax
  8001dc:	ff 75 08             	pushl  0x8(%ebp)
  8001df:	e8 95 ff ff ff       	call   800179 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001e4:	c9                   	leave  
  8001e5:	c3                   	ret    

008001e6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001e6:	55                   	push   %ebp
  8001e7:	89 e5                	mov    %esp,%ebp
  8001e9:	57                   	push   %edi
  8001ea:	56                   	push   %esi
  8001eb:	53                   	push   %ebx
  8001ec:	83 ec 1c             	sub    $0x1c,%esp
  8001ef:	89 c7                	mov    %eax,%edi
  8001f1:	89 d6                	mov    %edx,%esi
  8001f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001f9:	89 d1                	mov    %edx,%ecx
  8001fb:	89 c2                	mov    %eax,%edx
  8001fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800200:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800203:	8b 45 10             	mov    0x10(%ebp),%eax
  800206:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800209:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80020c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800213:	39 c2                	cmp    %eax,%edx
  800215:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800218:	72 3e                	jb     800258 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	ff 75 18             	pushl  0x18(%ebp)
  800220:	83 eb 01             	sub    $0x1,%ebx
  800223:	53                   	push   %ebx
  800224:	50                   	push   %eax
  800225:	83 ec 08             	sub    $0x8,%esp
  800228:	ff 75 e4             	pushl  -0x1c(%ebp)
  80022b:	ff 75 e0             	pushl  -0x20(%ebp)
  80022e:	ff 75 dc             	pushl  -0x24(%ebp)
  800231:	ff 75 d8             	pushl  -0x28(%ebp)
  800234:	e8 a7 20 00 00       	call   8022e0 <__udivdi3>
  800239:	83 c4 18             	add    $0x18,%esp
  80023c:	52                   	push   %edx
  80023d:	50                   	push   %eax
  80023e:	89 f2                	mov    %esi,%edx
  800240:	89 f8                	mov    %edi,%eax
  800242:	e8 9f ff ff ff       	call   8001e6 <printnum>
  800247:	83 c4 20             	add    $0x20,%esp
  80024a:	eb 13                	jmp    80025f <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80024c:	83 ec 08             	sub    $0x8,%esp
  80024f:	56                   	push   %esi
  800250:	ff 75 18             	pushl  0x18(%ebp)
  800253:	ff d7                	call   *%edi
  800255:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800258:	83 eb 01             	sub    $0x1,%ebx
  80025b:	85 db                	test   %ebx,%ebx
  80025d:	7f ed                	jg     80024c <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80025f:	83 ec 08             	sub    $0x8,%esp
  800262:	56                   	push   %esi
  800263:	83 ec 04             	sub    $0x4,%esp
  800266:	ff 75 e4             	pushl  -0x1c(%ebp)
  800269:	ff 75 e0             	pushl  -0x20(%ebp)
  80026c:	ff 75 dc             	pushl  -0x24(%ebp)
  80026f:	ff 75 d8             	pushl  -0x28(%ebp)
  800272:	e8 79 21 00 00       	call   8023f0 <__umoddi3>
  800277:	83 c4 14             	add    $0x14,%esp
  80027a:	0f be 80 c3 25 80 00 	movsbl 0x8025c3(%eax),%eax
  800281:	50                   	push   %eax
  800282:	ff d7                	call   *%edi
}
  800284:	83 c4 10             	add    $0x10,%esp
  800287:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80028a:	5b                   	pop    %ebx
  80028b:	5e                   	pop    %esi
  80028c:	5f                   	pop    %edi
  80028d:	5d                   	pop    %ebp
  80028e:	c3                   	ret    

0080028f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80028f:	f3 0f 1e fb          	endbr32 
  800293:	55                   	push   %ebp
  800294:	89 e5                	mov    %esp,%ebp
  800296:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800299:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80029d:	8b 10                	mov    (%eax),%edx
  80029f:	3b 50 04             	cmp    0x4(%eax),%edx
  8002a2:	73 0a                	jae    8002ae <sprintputch+0x1f>
		*b->buf++ = ch;
  8002a4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002a7:	89 08                	mov    %ecx,(%eax)
  8002a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ac:	88 02                	mov    %al,(%edx)
}
  8002ae:	5d                   	pop    %ebp
  8002af:	c3                   	ret    

008002b0 <printfmt>:
{
  8002b0:	f3 0f 1e fb          	endbr32 
  8002b4:	55                   	push   %ebp
  8002b5:	89 e5                	mov    %esp,%ebp
  8002b7:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002ba:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002bd:	50                   	push   %eax
  8002be:	ff 75 10             	pushl  0x10(%ebp)
  8002c1:	ff 75 0c             	pushl  0xc(%ebp)
  8002c4:	ff 75 08             	pushl  0x8(%ebp)
  8002c7:	e8 05 00 00 00       	call   8002d1 <vprintfmt>
}
  8002cc:	83 c4 10             	add    $0x10,%esp
  8002cf:	c9                   	leave  
  8002d0:	c3                   	ret    

008002d1 <vprintfmt>:
{
  8002d1:	f3 0f 1e fb          	endbr32 
  8002d5:	55                   	push   %ebp
  8002d6:	89 e5                	mov    %esp,%ebp
  8002d8:	57                   	push   %edi
  8002d9:	56                   	push   %esi
  8002da:	53                   	push   %ebx
  8002db:	83 ec 3c             	sub    $0x3c,%esp
  8002de:	8b 75 08             	mov    0x8(%ebp),%esi
  8002e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002e4:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002e7:	e9 8e 03 00 00       	jmp    80067a <vprintfmt+0x3a9>
		padc = ' ';
  8002ec:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002f0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002f7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002fe:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800305:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80030a:	8d 47 01             	lea    0x1(%edi),%eax
  80030d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800310:	0f b6 17             	movzbl (%edi),%edx
  800313:	8d 42 dd             	lea    -0x23(%edx),%eax
  800316:	3c 55                	cmp    $0x55,%al
  800318:	0f 87 df 03 00 00    	ja     8006fd <vprintfmt+0x42c>
  80031e:	0f b6 c0             	movzbl %al,%eax
  800321:	3e ff 24 85 00 27 80 	notrack jmp *0x802700(,%eax,4)
  800328:	00 
  800329:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80032c:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800330:	eb d8                	jmp    80030a <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800332:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800335:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800339:	eb cf                	jmp    80030a <vprintfmt+0x39>
  80033b:	0f b6 d2             	movzbl %dl,%edx
  80033e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800341:	b8 00 00 00 00       	mov    $0x0,%eax
  800346:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800349:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80034c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800350:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800353:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800356:	83 f9 09             	cmp    $0x9,%ecx
  800359:	77 55                	ja     8003b0 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  80035b:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80035e:	eb e9                	jmp    800349 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800360:	8b 45 14             	mov    0x14(%ebp),%eax
  800363:	8b 00                	mov    (%eax),%eax
  800365:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800368:	8b 45 14             	mov    0x14(%ebp),%eax
  80036b:	8d 40 04             	lea    0x4(%eax),%eax
  80036e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800371:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800374:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800378:	79 90                	jns    80030a <vprintfmt+0x39>
				width = precision, precision = -1;
  80037a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80037d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800380:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800387:	eb 81                	jmp    80030a <vprintfmt+0x39>
  800389:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80038c:	85 c0                	test   %eax,%eax
  80038e:	ba 00 00 00 00       	mov    $0x0,%edx
  800393:	0f 49 d0             	cmovns %eax,%edx
  800396:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800399:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80039c:	e9 69 ff ff ff       	jmp    80030a <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003a1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003a4:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003ab:	e9 5a ff ff ff       	jmp    80030a <vprintfmt+0x39>
  8003b0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003b6:	eb bc                	jmp    800374 <vprintfmt+0xa3>
			lflag++;
  8003b8:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003be:	e9 47 ff ff ff       	jmp    80030a <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8003c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c6:	8d 78 04             	lea    0x4(%eax),%edi
  8003c9:	83 ec 08             	sub    $0x8,%esp
  8003cc:	53                   	push   %ebx
  8003cd:	ff 30                	pushl  (%eax)
  8003cf:	ff d6                	call   *%esi
			break;
  8003d1:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003d4:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003d7:	e9 9b 02 00 00       	jmp    800677 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8003dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8003df:	8d 78 04             	lea    0x4(%eax),%edi
  8003e2:	8b 00                	mov    (%eax),%eax
  8003e4:	99                   	cltd   
  8003e5:	31 d0                	xor    %edx,%eax
  8003e7:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003e9:	83 f8 0f             	cmp    $0xf,%eax
  8003ec:	7f 23                	jg     800411 <vprintfmt+0x140>
  8003ee:	8b 14 85 60 28 80 00 	mov    0x802860(,%eax,4),%edx
  8003f5:	85 d2                	test   %edx,%edx
  8003f7:	74 18                	je     800411 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8003f9:	52                   	push   %edx
  8003fa:	68 91 29 80 00       	push   $0x802991
  8003ff:	53                   	push   %ebx
  800400:	56                   	push   %esi
  800401:	e8 aa fe ff ff       	call   8002b0 <printfmt>
  800406:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800409:	89 7d 14             	mov    %edi,0x14(%ebp)
  80040c:	e9 66 02 00 00       	jmp    800677 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800411:	50                   	push   %eax
  800412:	68 db 25 80 00       	push   $0x8025db
  800417:	53                   	push   %ebx
  800418:	56                   	push   %esi
  800419:	e8 92 fe ff ff       	call   8002b0 <printfmt>
  80041e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800421:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800424:	e9 4e 02 00 00       	jmp    800677 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800429:	8b 45 14             	mov    0x14(%ebp),%eax
  80042c:	83 c0 04             	add    $0x4,%eax
  80042f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800432:	8b 45 14             	mov    0x14(%ebp),%eax
  800435:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800437:	85 d2                	test   %edx,%edx
  800439:	b8 d4 25 80 00       	mov    $0x8025d4,%eax
  80043e:	0f 45 c2             	cmovne %edx,%eax
  800441:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800444:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800448:	7e 06                	jle    800450 <vprintfmt+0x17f>
  80044a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80044e:	75 0d                	jne    80045d <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  800450:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800453:	89 c7                	mov    %eax,%edi
  800455:	03 45 e0             	add    -0x20(%ebp),%eax
  800458:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80045b:	eb 55                	jmp    8004b2 <vprintfmt+0x1e1>
  80045d:	83 ec 08             	sub    $0x8,%esp
  800460:	ff 75 d8             	pushl  -0x28(%ebp)
  800463:	ff 75 cc             	pushl  -0x34(%ebp)
  800466:	e8 46 03 00 00       	call   8007b1 <strnlen>
  80046b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80046e:	29 c2                	sub    %eax,%edx
  800470:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800473:	83 c4 10             	add    $0x10,%esp
  800476:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800478:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80047c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80047f:	85 ff                	test   %edi,%edi
  800481:	7e 11                	jle    800494 <vprintfmt+0x1c3>
					putch(padc, putdat);
  800483:	83 ec 08             	sub    $0x8,%esp
  800486:	53                   	push   %ebx
  800487:	ff 75 e0             	pushl  -0x20(%ebp)
  80048a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80048c:	83 ef 01             	sub    $0x1,%edi
  80048f:	83 c4 10             	add    $0x10,%esp
  800492:	eb eb                	jmp    80047f <vprintfmt+0x1ae>
  800494:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800497:	85 d2                	test   %edx,%edx
  800499:	b8 00 00 00 00       	mov    $0x0,%eax
  80049e:	0f 49 c2             	cmovns %edx,%eax
  8004a1:	29 c2                	sub    %eax,%edx
  8004a3:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004a6:	eb a8                	jmp    800450 <vprintfmt+0x17f>
					putch(ch, putdat);
  8004a8:	83 ec 08             	sub    $0x8,%esp
  8004ab:	53                   	push   %ebx
  8004ac:	52                   	push   %edx
  8004ad:	ff d6                	call   *%esi
  8004af:	83 c4 10             	add    $0x10,%esp
  8004b2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004b5:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004b7:	83 c7 01             	add    $0x1,%edi
  8004ba:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004be:	0f be d0             	movsbl %al,%edx
  8004c1:	85 d2                	test   %edx,%edx
  8004c3:	74 4b                	je     800510 <vprintfmt+0x23f>
  8004c5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004c9:	78 06                	js     8004d1 <vprintfmt+0x200>
  8004cb:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004cf:	78 1e                	js     8004ef <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004d1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004d5:	74 d1                	je     8004a8 <vprintfmt+0x1d7>
  8004d7:	0f be c0             	movsbl %al,%eax
  8004da:	83 e8 20             	sub    $0x20,%eax
  8004dd:	83 f8 5e             	cmp    $0x5e,%eax
  8004e0:	76 c6                	jbe    8004a8 <vprintfmt+0x1d7>
					putch('?', putdat);
  8004e2:	83 ec 08             	sub    $0x8,%esp
  8004e5:	53                   	push   %ebx
  8004e6:	6a 3f                	push   $0x3f
  8004e8:	ff d6                	call   *%esi
  8004ea:	83 c4 10             	add    $0x10,%esp
  8004ed:	eb c3                	jmp    8004b2 <vprintfmt+0x1e1>
  8004ef:	89 cf                	mov    %ecx,%edi
  8004f1:	eb 0e                	jmp    800501 <vprintfmt+0x230>
				putch(' ', putdat);
  8004f3:	83 ec 08             	sub    $0x8,%esp
  8004f6:	53                   	push   %ebx
  8004f7:	6a 20                	push   $0x20
  8004f9:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004fb:	83 ef 01             	sub    $0x1,%edi
  8004fe:	83 c4 10             	add    $0x10,%esp
  800501:	85 ff                	test   %edi,%edi
  800503:	7f ee                	jg     8004f3 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800505:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800508:	89 45 14             	mov    %eax,0x14(%ebp)
  80050b:	e9 67 01 00 00       	jmp    800677 <vprintfmt+0x3a6>
  800510:	89 cf                	mov    %ecx,%edi
  800512:	eb ed                	jmp    800501 <vprintfmt+0x230>
	if (lflag >= 2)
  800514:	83 f9 01             	cmp    $0x1,%ecx
  800517:	7f 1b                	jg     800534 <vprintfmt+0x263>
	else if (lflag)
  800519:	85 c9                	test   %ecx,%ecx
  80051b:	74 63                	je     800580 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80051d:	8b 45 14             	mov    0x14(%ebp),%eax
  800520:	8b 00                	mov    (%eax),%eax
  800522:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800525:	99                   	cltd   
  800526:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800529:	8b 45 14             	mov    0x14(%ebp),%eax
  80052c:	8d 40 04             	lea    0x4(%eax),%eax
  80052f:	89 45 14             	mov    %eax,0x14(%ebp)
  800532:	eb 17                	jmp    80054b <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800534:	8b 45 14             	mov    0x14(%ebp),%eax
  800537:	8b 50 04             	mov    0x4(%eax),%edx
  80053a:	8b 00                	mov    (%eax),%eax
  80053c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80053f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800542:	8b 45 14             	mov    0x14(%ebp),%eax
  800545:	8d 40 08             	lea    0x8(%eax),%eax
  800548:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80054b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80054e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800551:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800556:	85 c9                	test   %ecx,%ecx
  800558:	0f 89 ff 00 00 00    	jns    80065d <vprintfmt+0x38c>
				putch('-', putdat);
  80055e:	83 ec 08             	sub    $0x8,%esp
  800561:	53                   	push   %ebx
  800562:	6a 2d                	push   $0x2d
  800564:	ff d6                	call   *%esi
				num = -(long long) num;
  800566:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800569:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80056c:	f7 da                	neg    %edx
  80056e:	83 d1 00             	adc    $0x0,%ecx
  800571:	f7 d9                	neg    %ecx
  800573:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800576:	b8 0a 00 00 00       	mov    $0xa,%eax
  80057b:	e9 dd 00 00 00       	jmp    80065d <vprintfmt+0x38c>
		return va_arg(*ap, int);
  800580:	8b 45 14             	mov    0x14(%ebp),%eax
  800583:	8b 00                	mov    (%eax),%eax
  800585:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800588:	99                   	cltd   
  800589:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80058c:	8b 45 14             	mov    0x14(%ebp),%eax
  80058f:	8d 40 04             	lea    0x4(%eax),%eax
  800592:	89 45 14             	mov    %eax,0x14(%ebp)
  800595:	eb b4                	jmp    80054b <vprintfmt+0x27a>
	if (lflag >= 2)
  800597:	83 f9 01             	cmp    $0x1,%ecx
  80059a:	7f 1e                	jg     8005ba <vprintfmt+0x2e9>
	else if (lflag)
  80059c:	85 c9                	test   %ecx,%ecx
  80059e:	74 32                	je     8005d2 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8005a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a3:	8b 10                	mov    (%eax),%edx
  8005a5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005aa:	8d 40 04             	lea    0x4(%eax),%eax
  8005ad:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005b0:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8005b5:	e9 a3 00 00 00       	jmp    80065d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bd:	8b 10                	mov    (%eax),%edx
  8005bf:	8b 48 04             	mov    0x4(%eax),%ecx
  8005c2:	8d 40 08             	lea    0x8(%eax),%eax
  8005c5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005c8:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8005cd:	e9 8b 00 00 00       	jmp    80065d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d5:	8b 10                	mov    (%eax),%edx
  8005d7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005dc:	8d 40 04             	lea    0x4(%eax),%eax
  8005df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005e2:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8005e7:	eb 74                	jmp    80065d <vprintfmt+0x38c>
	if (lflag >= 2)
  8005e9:	83 f9 01             	cmp    $0x1,%ecx
  8005ec:	7f 1b                	jg     800609 <vprintfmt+0x338>
	else if (lflag)
  8005ee:	85 c9                	test   %ecx,%ecx
  8005f0:	74 2c                	je     80061e <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8005f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f5:	8b 10                	mov    (%eax),%edx
  8005f7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005fc:	8d 40 04             	lea    0x4(%eax),%eax
  8005ff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800602:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800607:	eb 54                	jmp    80065d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800609:	8b 45 14             	mov    0x14(%ebp),%eax
  80060c:	8b 10                	mov    (%eax),%edx
  80060e:	8b 48 04             	mov    0x4(%eax),%ecx
  800611:	8d 40 08             	lea    0x8(%eax),%eax
  800614:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800617:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80061c:	eb 3f                	jmp    80065d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80061e:	8b 45 14             	mov    0x14(%ebp),%eax
  800621:	8b 10                	mov    (%eax),%edx
  800623:	b9 00 00 00 00       	mov    $0x0,%ecx
  800628:	8d 40 04             	lea    0x4(%eax),%eax
  80062b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80062e:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800633:	eb 28                	jmp    80065d <vprintfmt+0x38c>
			putch('0', putdat);
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	53                   	push   %ebx
  800639:	6a 30                	push   $0x30
  80063b:	ff d6                	call   *%esi
			putch('x', putdat);
  80063d:	83 c4 08             	add    $0x8,%esp
  800640:	53                   	push   %ebx
  800641:	6a 78                	push   $0x78
  800643:	ff d6                	call   *%esi
			num = (unsigned long long)
  800645:	8b 45 14             	mov    0x14(%ebp),%eax
  800648:	8b 10                	mov    (%eax),%edx
  80064a:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80064f:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800652:	8d 40 04             	lea    0x4(%eax),%eax
  800655:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800658:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80065d:	83 ec 0c             	sub    $0xc,%esp
  800660:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800664:	57                   	push   %edi
  800665:	ff 75 e0             	pushl  -0x20(%ebp)
  800668:	50                   	push   %eax
  800669:	51                   	push   %ecx
  80066a:	52                   	push   %edx
  80066b:	89 da                	mov    %ebx,%edx
  80066d:	89 f0                	mov    %esi,%eax
  80066f:	e8 72 fb ff ff       	call   8001e6 <printnum>
			break;
  800674:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800677:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80067a:	83 c7 01             	add    $0x1,%edi
  80067d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800681:	83 f8 25             	cmp    $0x25,%eax
  800684:	0f 84 62 fc ff ff    	je     8002ec <vprintfmt+0x1b>
			if (ch == '\0')
  80068a:	85 c0                	test   %eax,%eax
  80068c:	0f 84 8b 00 00 00    	je     80071d <vprintfmt+0x44c>
			putch(ch, putdat);
  800692:	83 ec 08             	sub    $0x8,%esp
  800695:	53                   	push   %ebx
  800696:	50                   	push   %eax
  800697:	ff d6                	call   *%esi
  800699:	83 c4 10             	add    $0x10,%esp
  80069c:	eb dc                	jmp    80067a <vprintfmt+0x3a9>
	if (lflag >= 2)
  80069e:	83 f9 01             	cmp    $0x1,%ecx
  8006a1:	7f 1b                	jg     8006be <vprintfmt+0x3ed>
	else if (lflag)
  8006a3:	85 c9                	test   %ecx,%ecx
  8006a5:	74 2c                	je     8006d3 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8006a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006aa:	8b 10                	mov    (%eax),%edx
  8006ac:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b1:	8d 40 04             	lea    0x4(%eax),%eax
  8006b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b7:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8006bc:	eb 9f                	jmp    80065d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8006be:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c1:	8b 10                	mov    (%eax),%edx
  8006c3:	8b 48 04             	mov    0x4(%eax),%ecx
  8006c6:	8d 40 08             	lea    0x8(%eax),%eax
  8006c9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006cc:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8006d1:	eb 8a                	jmp    80065d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d6:	8b 10                	mov    (%eax),%edx
  8006d8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006dd:	8d 40 04             	lea    0x4(%eax),%eax
  8006e0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006e3:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8006e8:	e9 70 ff ff ff       	jmp    80065d <vprintfmt+0x38c>
			putch(ch, putdat);
  8006ed:	83 ec 08             	sub    $0x8,%esp
  8006f0:	53                   	push   %ebx
  8006f1:	6a 25                	push   $0x25
  8006f3:	ff d6                	call   *%esi
			break;
  8006f5:	83 c4 10             	add    $0x10,%esp
  8006f8:	e9 7a ff ff ff       	jmp    800677 <vprintfmt+0x3a6>
			putch('%', putdat);
  8006fd:	83 ec 08             	sub    $0x8,%esp
  800700:	53                   	push   %ebx
  800701:	6a 25                	push   $0x25
  800703:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800705:	83 c4 10             	add    $0x10,%esp
  800708:	89 f8                	mov    %edi,%eax
  80070a:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80070e:	74 05                	je     800715 <vprintfmt+0x444>
  800710:	83 e8 01             	sub    $0x1,%eax
  800713:	eb f5                	jmp    80070a <vprintfmt+0x439>
  800715:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800718:	e9 5a ff ff ff       	jmp    800677 <vprintfmt+0x3a6>
}
  80071d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800720:	5b                   	pop    %ebx
  800721:	5e                   	pop    %esi
  800722:	5f                   	pop    %edi
  800723:	5d                   	pop    %ebp
  800724:	c3                   	ret    

00800725 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800725:	f3 0f 1e fb          	endbr32 
  800729:	55                   	push   %ebp
  80072a:	89 e5                	mov    %esp,%ebp
  80072c:	83 ec 18             	sub    $0x18,%esp
  80072f:	8b 45 08             	mov    0x8(%ebp),%eax
  800732:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800735:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800738:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80073c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80073f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800746:	85 c0                	test   %eax,%eax
  800748:	74 26                	je     800770 <vsnprintf+0x4b>
  80074a:	85 d2                	test   %edx,%edx
  80074c:	7e 22                	jle    800770 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80074e:	ff 75 14             	pushl  0x14(%ebp)
  800751:	ff 75 10             	pushl  0x10(%ebp)
  800754:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800757:	50                   	push   %eax
  800758:	68 8f 02 80 00       	push   $0x80028f
  80075d:	e8 6f fb ff ff       	call   8002d1 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800762:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800765:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80076b:	83 c4 10             	add    $0x10,%esp
}
  80076e:	c9                   	leave  
  80076f:	c3                   	ret    
		return -E_INVAL;
  800770:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800775:	eb f7                	jmp    80076e <vsnprintf+0x49>

00800777 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800777:	f3 0f 1e fb          	endbr32 
  80077b:	55                   	push   %ebp
  80077c:	89 e5                	mov    %esp,%ebp
  80077e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800781:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800784:	50                   	push   %eax
  800785:	ff 75 10             	pushl  0x10(%ebp)
  800788:	ff 75 0c             	pushl  0xc(%ebp)
  80078b:	ff 75 08             	pushl  0x8(%ebp)
  80078e:	e8 92 ff ff ff       	call   800725 <vsnprintf>
	va_end(ap);

	return rc;
}
  800793:	c9                   	leave  
  800794:	c3                   	ret    

00800795 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800795:	f3 0f 1e fb          	endbr32 
  800799:	55                   	push   %ebp
  80079a:	89 e5                	mov    %esp,%ebp
  80079c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80079f:	b8 00 00 00 00       	mov    $0x0,%eax
  8007a4:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007a8:	74 05                	je     8007af <strlen+0x1a>
		n++;
  8007aa:	83 c0 01             	add    $0x1,%eax
  8007ad:	eb f5                	jmp    8007a4 <strlen+0xf>
	return n;
}
  8007af:	5d                   	pop    %ebp
  8007b0:	c3                   	ret    

008007b1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007b1:	f3 0f 1e fb          	endbr32 
  8007b5:	55                   	push   %ebp
  8007b6:	89 e5                	mov    %esp,%ebp
  8007b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007bb:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007be:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c3:	39 d0                	cmp    %edx,%eax
  8007c5:	74 0d                	je     8007d4 <strnlen+0x23>
  8007c7:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007cb:	74 05                	je     8007d2 <strnlen+0x21>
		n++;
  8007cd:	83 c0 01             	add    $0x1,%eax
  8007d0:	eb f1                	jmp    8007c3 <strnlen+0x12>
  8007d2:	89 c2                	mov    %eax,%edx
	return n;
}
  8007d4:	89 d0                	mov    %edx,%eax
  8007d6:	5d                   	pop    %ebp
  8007d7:	c3                   	ret    

008007d8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007d8:	f3 0f 1e fb          	endbr32 
  8007dc:	55                   	push   %ebp
  8007dd:	89 e5                	mov    %esp,%ebp
  8007df:	53                   	push   %ebx
  8007e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007e3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007eb:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8007ef:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8007f2:	83 c0 01             	add    $0x1,%eax
  8007f5:	84 d2                	test   %dl,%dl
  8007f7:	75 f2                	jne    8007eb <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8007f9:	89 c8                	mov    %ecx,%eax
  8007fb:	5b                   	pop    %ebx
  8007fc:	5d                   	pop    %ebp
  8007fd:	c3                   	ret    

008007fe <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007fe:	f3 0f 1e fb          	endbr32 
  800802:	55                   	push   %ebp
  800803:	89 e5                	mov    %esp,%ebp
  800805:	53                   	push   %ebx
  800806:	83 ec 10             	sub    $0x10,%esp
  800809:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80080c:	53                   	push   %ebx
  80080d:	e8 83 ff ff ff       	call   800795 <strlen>
  800812:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800815:	ff 75 0c             	pushl  0xc(%ebp)
  800818:	01 d8                	add    %ebx,%eax
  80081a:	50                   	push   %eax
  80081b:	e8 b8 ff ff ff       	call   8007d8 <strcpy>
	return dst;
}
  800820:	89 d8                	mov    %ebx,%eax
  800822:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800825:	c9                   	leave  
  800826:	c3                   	ret    

00800827 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800827:	f3 0f 1e fb          	endbr32 
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
  80082e:	56                   	push   %esi
  80082f:	53                   	push   %ebx
  800830:	8b 75 08             	mov    0x8(%ebp),%esi
  800833:	8b 55 0c             	mov    0xc(%ebp),%edx
  800836:	89 f3                	mov    %esi,%ebx
  800838:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80083b:	89 f0                	mov    %esi,%eax
  80083d:	39 d8                	cmp    %ebx,%eax
  80083f:	74 11                	je     800852 <strncpy+0x2b>
		*dst++ = *src;
  800841:	83 c0 01             	add    $0x1,%eax
  800844:	0f b6 0a             	movzbl (%edx),%ecx
  800847:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80084a:	80 f9 01             	cmp    $0x1,%cl
  80084d:	83 da ff             	sbb    $0xffffffff,%edx
  800850:	eb eb                	jmp    80083d <strncpy+0x16>
	}
	return ret;
}
  800852:	89 f0                	mov    %esi,%eax
  800854:	5b                   	pop    %ebx
  800855:	5e                   	pop    %esi
  800856:	5d                   	pop    %ebp
  800857:	c3                   	ret    

00800858 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800858:	f3 0f 1e fb          	endbr32 
  80085c:	55                   	push   %ebp
  80085d:	89 e5                	mov    %esp,%ebp
  80085f:	56                   	push   %esi
  800860:	53                   	push   %ebx
  800861:	8b 75 08             	mov    0x8(%ebp),%esi
  800864:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800867:	8b 55 10             	mov    0x10(%ebp),%edx
  80086a:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80086c:	85 d2                	test   %edx,%edx
  80086e:	74 21                	je     800891 <strlcpy+0x39>
  800870:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800874:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800876:	39 c2                	cmp    %eax,%edx
  800878:	74 14                	je     80088e <strlcpy+0x36>
  80087a:	0f b6 19             	movzbl (%ecx),%ebx
  80087d:	84 db                	test   %bl,%bl
  80087f:	74 0b                	je     80088c <strlcpy+0x34>
			*dst++ = *src++;
  800881:	83 c1 01             	add    $0x1,%ecx
  800884:	83 c2 01             	add    $0x1,%edx
  800887:	88 5a ff             	mov    %bl,-0x1(%edx)
  80088a:	eb ea                	jmp    800876 <strlcpy+0x1e>
  80088c:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80088e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800891:	29 f0                	sub    %esi,%eax
}
  800893:	5b                   	pop    %ebx
  800894:	5e                   	pop    %esi
  800895:	5d                   	pop    %ebp
  800896:	c3                   	ret    

00800897 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800897:	f3 0f 1e fb          	endbr32 
  80089b:	55                   	push   %ebp
  80089c:	89 e5                	mov    %esp,%ebp
  80089e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008a1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008a4:	0f b6 01             	movzbl (%ecx),%eax
  8008a7:	84 c0                	test   %al,%al
  8008a9:	74 0c                	je     8008b7 <strcmp+0x20>
  8008ab:	3a 02                	cmp    (%edx),%al
  8008ad:	75 08                	jne    8008b7 <strcmp+0x20>
		p++, q++;
  8008af:	83 c1 01             	add    $0x1,%ecx
  8008b2:	83 c2 01             	add    $0x1,%edx
  8008b5:	eb ed                	jmp    8008a4 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008b7:	0f b6 c0             	movzbl %al,%eax
  8008ba:	0f b6 12             	movzbl (%edx),%edx
  8008bd:	29 d0                	sub    %edx,%eax
}
  8008bf:	5d                   	pop    %ebp
  8008c0:	c3                   	ret    

008008c1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008c1:	f3 0f 1e fb          	endbr32 
  8008c5:	55                   	push   %ebp
  8008c6:	89 e5                	mov    %esp,%ebp
  8008c8:	53                   	push   %ebx
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008cf:	89 c3                	mov    %eax,%ebx
  8008d1:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008d4:	eb 06                	jmp    8008dc <strncmp+0x1b>
		n--, p++, q++;
  8008d6:	83 c0 01             	add    $0x1,%eax
  8008d9:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008dc:	39 d8                	cmp    %ebx,%eax
  8008de:	74 16                	je     8008f6 <strncmp+0x35>
  8008e0:	0f b6 08             	movzbl (%eax),%ecx
  8008e3:	84 c9                	test   %cl,%cl
  8008e5:	74 04                	je     8008eb <strncmp+0x2a>
  8008e7:	3a 0a                	cmp    (%edx),%cl
  8008e9:	74 eb                	je     8008d6 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008eb:	0f b6 00             	movzbl (%eax),%eax
  8008ee:	0f b6 12             	movzbl (%edx),%edx
  8008f1:	29 d0                	sub    %edx,%eax
}
  8008f3:	5b                   	pop    %ebx
  8008f4:	5d                   	pop    %ebp
  8008f5:	c3                   	ret    
		return 0;
  8008f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008fb:	eb f6                	jmp    8008f3 <strncmp+0x32>

008008fd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008fd:	f3 0f 1e fb          	endbr32 
  800901:	55                   	push   %ebp
  800902:	89 e5                	mov    %esp,%ebp
  800904:	8b 45 08             	mov    0x8(%ebp),%eax
  800907:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80090b:	0f b6 10             	movzbl (%eax),%edx
  80090e:	84 d2                	test   %dl,%dl
  800910:	74 09                	je     80091b <strchr+0x1e>
		if (*s == c)
  800912:	38 ca                	cmp    %cl,%dl
  800914:	74 0a                	je     800920 <strchr+0x23>
	for (; *s; s++)
  800916:	83 c0 01             	add    $0x1,%eax
  800919:	eb f0                	jmp    80090b <strchr+0xe>
			return (char *) s;
	return 0;
  80091b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800920:	5d                   	pop    %ebp
  800921:	c3                   	ret    

00800922 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800922:	f3 0f 1e fb          	endbr32 
  800926:	55                   	push   %ebp
  800927:	89 e5                	mov    %esp,%ebp
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800930:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800933:	38 ca                	cmp    %cl,%dl
  800935:	74 09                	je     800940 <strfind+0x1e>
  800937:	84 d2                	test   %dl,%dl
  800939:	74 05                	je     800940 <strfind+0x1e>
	for (; *s; s++)
  80093b:	83 c0 01             	add    $0x1,%eax
  80093e:	eb f0                	jmp    800930 <strfind+0xe>
			break;
	return (char *) s;
}
  800940:	5d                   	pop    %ebp
  800941:	c3                   	ret    

00800942 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800942:	f3 0f 1e fb          	endbr32 
  800946:	55                   	push   %ebp
  800947:	89 e5                	mov    %esp,%ebp
  800949:	57                   	push   %edi
  80094a:	56                   	push   %esi
  80094b:	53                   	push   %ebx
  80094c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80094f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800952:	85 c9                	test   %ecx,%ecx
  800954:	74 31                	je     800987 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800956:	89 f8                	mov    %edi,%eax
  800958:	09 c8                	or     %ecx,%eax
  80095a:	a8 03                	test   $0x3,%al
  80095c:	75 23                	jne    800981 <memset+0x3f>
		c &= 0xFF;
  80095e:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800962:	89 d3                	mov    %edx,%ebx
  800964:	c1 e3 08             	shl    $0x8,%ebx
  800967:	89 d0                	mov    %edx,%eax
  800969:	c1 e0 18             	shl    $0x18,%eax
  80096c:	89 d6                	mov    %edx,%esi
  80096e:	c1 e6 10             	shl    $0x10,%esi
  800971:	09 f0                	or     %esi,%eax
  800973:	09 c2                	or     %eax,%edx
  800975:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800977:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80097a:	89 d0                	mov    %edx,%eax
  80097c:	fc                   	cld    
  80097d:	f3 ab                	rep stos %eax,%es:(%edi)
  80097f:	eb 06                	jmp    800987 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800981:	8b 45 0c             	mov    0xc(%ebp),%eax
  800984:	fc                   	cld    
  800985:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800987:	89 f8                	mov    %edi,%eax
  800989:	5b                   	pop    %ebx
  80098a:	5e                   	pop    %esi
  80098b:	5f                   	pop    %edi
  80098c:	5d                   	pop    %ebp
  80098d:	c3                   	ret    

0080098e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80098e:	f3 0f 1e fb          	endbr32 
  800992:	55                   	push   %ebp
  800993:	89 e5                	mov    %esp,%ebp
  800995:	57                   	push   %edi
  800996:	56                   	push   %esi
  800997:	8b 45 08             	mov    0x8(%ebp),%eax
  80099a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80099d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009a0:	39 c6                	cmp    %eax,%esi
  8009a2:	73 32                	jae    8009d6 <memmove+0x48>
  8009a4:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009a7:	39 c2                	cmp    %eax,%edx
  8009a9:	76 2b                	jbe    8009d6 <memmove+0x48>
		s += n;
		d += n;
  8009ab:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009ae:	89 fe                	mov    %edi,%esi
  8009b0:	09 ce                	or     %ecx,%esi
  8009b2:	09 d6                	or     %edx,%esi
  8009b4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009ba:	75 0e                	jne    8009ca <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009bc:	83 ef 04             	sub    $0x4,%edi
  8009bf:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009c2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009c5:	fd                   	std    
  8009c6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009c8:	eb 09                	jmp    8009d3 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009ca:	83 ef 01             	sub    $0x1,%edi
  8009cd:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009d0:	fd                   	std    
  8009d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009d3:	fc                   	cld    
  8009d4:	eb 1a                	jmp    8009f0 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009d6:	89 c2                	mov    %eax,%edx
  8009d8:	09 ca                	or     %ecx,%edx
  8009da:	09 f2                	or     %esi,%edx
  8009dc:	f6 c2 03             	test   $0x3,%dl
  8009df:	75 0a                	jne    8009eb <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009e1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009e4:	89 c7                	mov    %eax,%edi
  8009e6:	fc                   	cld    
  8009e7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009e9:	eb 05                	jmp    8009f0 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8009eb:	89 c7                	mov    %eax,%edi
  8009ed:	fc                   	cld    
  8009ee:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009f0:	5e                   	pop    %esi
  8009f1:	5f                   	pop    %edi
  8009f2:	5d                   	pop    %ebp
  8009f3:	c3                   	ret    

008009f4 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009f4:	f3 0f 1e fb          	endbr32 
  8009f8:	55                   	push   %ebp
  8009f9:	89 e5                	mov    %esp,%ebp
  8009fb:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009fe:	ff 75 10             	pushl  0x10(%ebp)
  800a01:	ff 75 0c             	pushl  0xc(%ebp)
  800a04:	ff 75 08             	pushl  0x8(%ebp)
  800a07:	e8 82 ff ff ff       	call   80098e <memmove>
}
  800a0c:	c9                   	leave  
  800a0d:	c3                   	ret    

00800a0e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a0e:	f3 0f 1e fb          	endbr32 
  800a12:	55                   	push   %ebp
  800a13:	89 e5                	mov    %esp,%ebp
  800a15:	56                   	push   %esi
  800a16:	53                   	push   %ebx
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a1d:	89 c6                	mov    %eax,%esi
  800a1f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a22:	39 f0                	cmp    %esi,%eax
  800a24:	74 1c                	je     800a42 <memcmp+0x34>
		if (*s1 != *s2)
  800a26:	0f b6 08             	movzbl (%eax),%ecx
  800a29:	0f b6 1a             	movzbl (%edx),%ebx
  800a2c:	38 d9                	cmp    %bl,%cl
  800a2e:	75 08                	jne    800a38 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a30:	83 c0 01             	add    $0x1,%eax
  800a33:	83 c2 01             	add    $0x1,%edx
  800a36:	eb ea                	jmp    800a22 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a38:	0f b6 c1             	movzbl %cl,%eax
  800a3b:	0f b6 db             	movzbl %bl,%ebx
  800a3e:	29 d8                	sub    %ebx,%eax
  800a40:	eb 05                	jmp    800a47 <memcmp+0x39>
	}

	return 0;
  800a42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a47:	5b                   	pop    %ebx
  800a48:	5e                   	pop    %esi
  800a49:	5d                   	pop    %ebp
  800a4a:	c3                   	ret    

00800a4b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a4b:	f3 0f 1e fb          	endbr32 
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
  800a52:	8b 45 08             	mov    0x8(%ebp),%eax
  800a55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a58:	89 c2                	mov    %eax,%edx
  800a5a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a5d:	39 d0                	cmp    %edx,%eax
  800a5f:	73 09                	jae    800a6a <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a61:	38 08                	cmp    %cl,(%eax)
  800a63:	74 05                	je     800a6a <memfind+0x1f>
	for (; s < ends; s++)
  800a65:	83 c0 01             	add    $0x1,%eax
  800a68:	eb f3                	jmp    800a5d <memfind+0x12>
			break;
	return (void *) s;
}
  800a6a:	5d                   	pop    %ebp
  800a6b:	c3                   	ret    

00800a6c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a6c:	f3 0f 1e fb          	endbr32 
  800a70:	55                   	push   %ebp
  800a71:	89 e5                	mov    %esp,%ebp
  800a73:	57                   	push   %edi
  800a74:	56                   	push   %esi
  800a75:	53                   	push   %ebx
  800a76:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a79:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a7c:	eb 03                	jmp    800a81 <strtol+0x15>
		s++;
  800a7e:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a81:	0f b6 01             	movzbl (%ecx),%eax
  800a84:	3c 20                	cmp    $0x20,%al
  800a86:	74 f6                	je     800a7e <strtol+0x12>
  800a88:	3c 09                	cmp    $0x9,%al
  800a8a:	74 f2                	je     800a7e <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a8c:	3c 2b                	cmp    $0x2b,%al
  800a8e:	74 2a                	je     800aba <strtol+0x4e>
	int neg = 0;
  800a90:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a95:	3c 2d                	cmp    $0x2d,%al
  800a97:	74 2b                	je     800ac4 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a99:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a9f:	75 0f                	jne    800ab0 <strtol+0x44>
  800aa1:	80 39 30             	cmpb   $0x30,(%ecx)
  800aa4:	74 28                	je     800ace <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800aa6:	85 db                	test   %ebx,%ebx
  800aa8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800aad:	0f 44 d8             	cmove  %eax,%ebx
  800ab0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab5:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ab8:	eb 46                	jmp    800b00 <strtol+0x94>
		s++;
  800aba:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800abd:	bf 00 00 00 00       	mov    $0x0,%edi
  800ac2:	eb d5                	jmp    800a99 <strtol+0x2d>
		s++, neg = 1;
  800ac4:	83 c1 01             	add    $0x1,%ecx
  800ac7:	bf 01 00 00 00       	mov    $0x1,%edi
  800acc:	eb cb                	jmp    800a99 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ace:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ad2:	74 0e                	je     800ae2 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800ad4:	85 db                	test   %ebx,%ebx
  800ad6:	75 d8                	jne    800ab0 <strtol+0x44>
		s++, base = 8;
  800ad8:	83 c1 01             	add    $0x1,%ecx
  800adb:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ae0:	eb ce                	jmp    800ab0 <strtol+0x44>
		s += 2, base = 16;
  800ae2:	83 c1 02             	add    $0x2,%ecx
  800ae5:	bb 10 00 00 00       	mov    $0x10,%ebx
  800aea:	eb c4                	jmp    800ab0 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800aec:	0f be d2             	movsbl %dl,%edx
  800aef:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800af2:	3b 55 10             	cmp    0x10(%ebp),%edx
  800af5:	7d 3a                	jge    800b31 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800af7:	83 c1 01             	add    $0x1,%ecx
  800afa:	0f af 45 10          	imul   0x10(%ebp),%eax
  800afe:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b00:	0f b6 11             	movzbl (%ecx),%edx
  800b03:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b06:	89 f3                	mov    %esi,%ebx
  800b08:	80 fb 09             	cmp    $0x9,%bl
  800b0b:	76 df                	jbe    800aec <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b0d:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b10:	89 f3                	mov    %esi,%ebx
  800b12:	80 fb 19             	cmp    $0x19,%bl
  800b15:	77 08                	ja     800b1f <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b17:	0f be d2             	movsbl %dl,%edx
  800b1a:	83 ea 57             	sub    $0x57,%edx
  800b1d:	eb d3                	jmp    800af2 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b1f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b22:	89 f3                	mov    %esi,%ebx
  800b24:	80 fb 19             	cmp    $0x19,%bl
  800b27:	77 08                	ja     800b31 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b29:	0f be d2             	movsbl %dl,%edx
  800b2c:	83 ea 37             	sub    $0x37,%edx
  800b2f:	eb c1                	jmp    800af2 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b31:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b35:	74 05                	je     800b3c <strtol+0xd0>
		*endptr = (char *) s;
  800b37:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b3a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b3c:	89 c2                	mov    %eax,%edx
  800b3e:	f7 da                	neg    %edx
  800b40:	85 ff                	test   %edi,%edi
  800b42:	0f 45 c2             	cmovne %edx,%eax
}
  800b45:	5b                   	pop    %ebx
  800b46:	5e                   	pop    %esi
  800b47:	5f                   	pop    %edi
  800b48:	5d                   	pop    %ebp
  800b49:	c3                   	ret    

00800b4a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b4a:	f3 0f 1e fb          	endbr32 
  800b4e:	55                   	push   %ebp
  800b4f:	89 e5                	mov    %esp,%ebp
  800b51:	57                   	push   %edi
  800b52:	56                   	push   %esi
  800b53:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b54:	b8 00 00 00 00       	mov    $0x0,%eax
  800b59:	8b 55 08             	mov    0x8(%ebp),%edx
  800b5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b5f:	89 c3                	mov    %eax,%ebx
  800b61:	89 c7                	mov    %eax,%edi
  800b63:	89 c6                	mov    %eax,%esi
  800b65:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b67:	5b                   	pop    %ebx
  800b68:	5e                   	pop    %esi
  800b69:	5f                   	pop    %edi
  800b6a:	5d                   	pop    %ebp
  800b6b:	c3                   	ret    

00800b6c <sys_cgetc>:

int
sys_cgetc(void)
{
  800b6c:	f3 0f 1e fb          	endbr32 
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
  800b73:	57                   	push   %edi
  800b74:	56                   	push   %esi
  800b75:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b76:	ba 00 00 00 00       	mov    $0x0,%edx
  800b7b:	b8 01 00 00 00       	mov    $0x1,%eax
  800b80:	89 d1                	mov    %edx,%ecx
  800b82:	89 d3                	mov    %edx,%ebx
  800b84:	89 d7                	mov    %edx,%edi
  800b86:	89 d6                	mov    %edx,%esi
  800b88:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b8a:	5b                   	pop    %ebx
  800b8b:	5e                   	pop    %esi
  800b8c:	5f                   	pop    %edi
  800b8d:	5d                   	pop    %ebp
  800b8e:	c3                   	ret    

00800b8f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b8f:	f3 0f 1e fb          	endbr32 
  800b93:	55                   	push   %ebp
  800b94:	89 e5                	mov    %esp,%ebp
  800b96:	57                   	push   %edi
  800b97:	56                   	push   %esi
  800b98:	53                   	push   %ebx
  800b99:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b9c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ba1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba4:	b8 03 00 00 00       	mov    $0x3,%eax
  800ba9:	89 cb                	mov    %ecx,%ebx
  800bab:	89 cf                	mov    %ecx,%edi
  800bad:	89 ce                	mov    %ecx,%esi
  800baf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bb1:	85 c0                	test   %eax,%eax
  800bb3:	7f 08                	jg     800bbd <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bb8:	5b                   	pop    %ebx
  800bb9:	5e                   	pop    %esi
  800bba:	5f                   	pop    %edi
  800bbb:	5d                   	pop    %ebp
  800bbc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bbd:	83 ec 0c             	sub    $0xc,%esp
  800bc0:	50                   	push   %eax
  800bc1:	6a 03                	push   $0x3
  800bc3:	68 bf 28 80 00       	push   $0x8028bf
  800bc8:	6a 23                	push   $0x23
  800bca:	68 dc 28 80 00       	push   $0x8028dc
  800bcf:	e8 13 f5 ff ff       	call   8000e7 <_panic>

00800bd4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bd4:	f3 0f 1e fb          	endbr32 
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	57                   	push   %edi
  800bdc:	56                   	push   %esi
  800bdd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bde:	ba 00 00 00 00       	mov    $0x0,%edx
  800be3:	b8 02 00 00 00       	mov    $0x2,%eax
  800be8:	89 d1                	mov    %edx,%ecx
  800bea:	89 d3                	mov    %edx,%ebx
  800bec:	89 d7                	mov    %edx,%edi
  800bee:	89 d6                	mov    %edx,%esi
  800bf0:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bf2:	5b                   	pop    %ebx
  800bf3:	5e                   	pop    %esi
  800bf4:	5f                   	pop    %edi
  800bf5:	5d                   	pop    %ebp
  800bf6:	c3                   	ret    

00800bf7 <sys_yield>:

void
sys_yield(void)
{
  800bf7:	f3 0f 1e fb          	endbr32 
  800bfb:	55                   	push   %ebp
  800bfc:	89 e5                	mov    %esp,%ebp
  800bfe:	57                   	push   %edi
  800bff:	56                   	push   %esi
  800c00:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c01:	ba 00 00 00 00       	mov    $0x0,%edx
  800c06:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c0b:	89 d1                	mov    %edx,%ecx
  800c0d:	89 d3                	mov    %edx,%ebx
  800c0f:	89 d7                	mov    %edx,%edi
  800c11:	89 d6                	mov    %edx,%esi
  800c13:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c15:	5b                   	pop    %ebx
  800c16:	5e                   	pop    %esi
  800c17:	5f                   	pop    %edi
  800c18:	5d                   	pop    %ebp
  800c19:	c3                   	ret    

00800c1a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c1a:	f3 0f 1e fb          	endbr32 
  800c1e:	55                   	push   %ebp
  800c1f:	89 e5                	mov    %esp,%ebp
  800c21:	57                   	push   %edi
  800c22:	56                   	push   %esi
  800c23:	53                   	push   %ebx
  800c24:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c27:	be 00 00 00 00       	mov    $0x0,%esi
  800c2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c32:	b8 04 00 00 00       	mov    $0x4,%eax
  800c37:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c3a:	89 f7                	mov    %esi,%edi
  800c3c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c3e:	85 c0                	test   %eax,%eax
  800c40:	7f 08                	jg     800c4a <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c42:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c45:	5b                   	pop    %ebx
  800c46:	5e                   	pop    %esi
  800c47:	5f                   	pop    %edi
  800c48:	5d                   	pop    %ebp
  800c49:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c4a:	83 ec 0c             	sub    $0xc,%esp
  800c4d:	50                   	push   %eax
  800c4e:	6a 04                	push   $0x4
  800c50:	68 bf 28 80 00       	push   $0x8028bf
  800c55:	6a 23                	push   $0x23
  800c57:	68 dc 28 80 00       	push   $0x8028dc
  800c5c:	e8 86 f4 ff ff       	call   8000e7 <_panic>

00800c61 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c61:	f3 0f 1e fb          	endbr32 
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	57                   	push   %edi
  800c69:	56                   	push   %esi
  800c6a:	53                   	push   %ebx
  800c6b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c74:	b8 05 00 00 00       	mov    $0x5,%eax
  800c79:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c7c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c7f:	8b 75 18             	mov    0x18(%ebp),%esi
  800c82:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c84:	85 c0                	test   %eax,%eax
  800c86:	7f 08                	jg     800c90 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c8b:	5b                   	pop    %ebx
  800c8c:	5e                   	pop    %esi
  800c8d:	5f                   	pop    %edi
  800c8e:	5d                   	pop    %ebp
  800c8f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c90:	83 ec 0c             	sub    $0xc,%esp
  800c93:	50                   	push   %eax
  800c94:	6a 05                	push   $0x5
  800c96:	68 bf 28 80 00       	push   $0x8028bf
  800c9b:	6a 23                	push   $0x23
  800c9d:	68 dc 28 80 00       	push   $0x8028dc
  800ca2:	e8 40 f4 ff ff       	call   8000e7 <_panic>

00800ca7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ca7:	f3 0f 1e fb          	endbr32 
  800cab:	55                   	push   %ebp
  800cac:	89 e5                	mov    %esp,%ebp
  800cae:	57                   	push   %edi
  800caf:	56                   	push   %esi
  800cb0:	53                   	push   %ebx
  800cb1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cbf:	b8 06 00 00 00       	mov    $0x6,%eax
  800cc4:	89 df                	mov    %ebx,%edi
  800cc6:	89 de                	mov    %ebx,%esi
  800cc8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cca:	85 c0                	test   %eax,%eax
  800ccc:	7f 08                	jg     800cd6 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd1:	5b                   	pop    %ebx
  800cd2:	5e                   	pop    %esi
  800cd3:	5f                   	pop    %edi
  800cd4:	5d                   	pop    %ebp
  800cd5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd6:	83 ec 0c             	sub    $0xc,%esp
  800cd9:	50                   	push   %eax
  800cda:	6a 06                	push   $0x6
  800cdc:	68 bf 28 80 00       	push   $0x8028bf
  800ce1:	6a 23                	push   $0x23
  800ce3:	68 dc 28 80 00       	push   $0x8028dc
  800ce8:	e8 fa f3 ff ff       	call   8000e7 <_panic>

00800ced <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ced:	f3 0f 1e fb          	endbr32 
  800cf1:	55                   	push   %ebp
  800cf2:	89 e5                	mov    %esp,%ebp
  800cf4:	57                   	push   %edi
  800cf5:	56                   	push   %esi
  800cf6:	53                   	push   %ebx
  800cf7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cfa:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cff:	8b 55 08             	mov    0x8(%ebp),%edx
  800d02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d05:	b8 08 00 00 00       	mov    $0x8,%eax
  800d0a:	89 df                	mov    %ebx,%edi
  800d0c:	89 de                	mov    %ebx,%esi
  800d0e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d10:	85 c0                	test   %eax,%eax
  800d12:	7f 08                	jg     800d1c <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d17:	5b                   	pop    %ebx
  800d18:	5e                   	pop    %esi
  800d19:	5f                   	pop    %edi
  800d1a:	5d                   	pop    %ebp
  800d1b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1c:	83 ec 0c             	sub    $0xc,%esp
  800d1f:	50                   	push   %eax
  800d20:	6a 08                	push   $0x8
  800d22:	68 bf 28 80 00       	push   $0x8028bf
  800d27:	6a 23                	push   $0x23
  800d29:	68 dc 28 80 00       	push   $0x8028dc
  800d2e:	e8 b4 f3 ff ff       	call   8000e7 <_panic>

00800d33 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d33:	f3 0f 1e fb          	endbr32 
  800d37:	55                   	push   %ebp
  800d38:	89 e5                	mov    %esp,%ebp
  800d3a:	57                   	push   %edi
  800d3b:	56                   	push   %esi
  800d3c:	53                   	push   %ebx
  800d3d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d40:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d45:	8b 55 08             	mov    0x8(%ebp),%edx
  800d48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4b:	b8 09 00 00 00       	mov    $0x9,%eax
  800d50:	89 df                	mov    %ebx,%edi
  800d52:	89 de                	mov    %ebx,%esi
  800d54:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d56:	85 c0                	test   %eax,%eax
  800d58:	7f 08                	jg     800d62 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d5d:	5b                   	pop    %ebx
  800d5e:	5e                   	pop    %esi
  800d5f:	5f                   	pop    %edi
  800d60:	5d                   	pop    %ebp
  800d61:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d62:	83 ec 0c             	sub    $0xc,%esp
  800d65:	50                   	push   %eax
  800d66:	6a 09                	push   $0x9
  800d68:	68 bf 28 80 00       	push   $0x8028bf
  800d6d:	6a 23                	push   $0x23
  800d6f:	68 dc 28 80 00       	push   $0x8028dc
  800d74:	e8 6e f3 ff ff       	call   8000e7 <_panic>

00800d79 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d79:	f3 0f 1e fb          	endbr32 
  800d7d:	55                   	push   %ebp
  800d7e:	89 e5                	mov    %esp,%ebp
  800d80:	57                   	push   %edi
  800d81:	56                   	push   %esi
  800d82:	53                   	push   %ebx
  800d83:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d86:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d91:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d96:	89 df                	mov    %ebx,%edi
  800d98:	89 de                	mov    %ebx,%esi
  800d9a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d9c:	85 c0                	test   %eax,%eax
  800d9e:	7f 08                	jg     800da8 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800da0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da3:	5b                   	pop    %ebx
  800da4:	5e                   	pop    %esi
  800da5:	5f                   	pop    %edi
  800da6:	5d                   	pop    %ebp
  800da7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da8:	83 ec 0c             	sub    $0xc,%esp
  800dab:	50                   	push   %eax
  800dac:	6a 0a                	push   $0xa
  800dae:	68 bf 28 80 00       	push   $0x8028bf
  800db3:	6a 23                	push   $0x23
  800db5:	68 dc 28 80 00       	push   $0x8028dc
  800dba:	e8 28 f3 ff ff       	call   8000e7 <_panic>

00800dbf <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dbf:	f3 0f 1e fb          	endbr32 
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
  800dc6:	57                   	push   %edi
  800dc7:	56                   	push   %esi
  800dc8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dcf:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dd4:	be 00 00 00 00       	mov    $0x0,%esi
  800dd9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ddc:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ddf:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800de1:	5b                   	pop    %ebx
  800de2:	5e                   	pop    %esi
  800de3:	5f                   	pop    %edi
  800de4:	5d                   	pop    %ebp
  800de5:	c3                   	ret    

00800de6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800de6:	f3 0f 1e fb          	endbr32 
  800dea:	55                   	push   %ebp
  800deb:	89 e5                	mov    %esp,%ebp
  800ded:	57                   	push   %edi
  800dee:	56                   	push   %esi
  800def:	53                   	push   %ebx
  800df0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800df8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfb:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e00:	89 cb                	mov    %ecx,%ebx
  800e02:	89 cf                	mov    %ecx,%edi
  800e04:	89 ce                	mov    %ecx,%esi
  800e06:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e08:	85 c0                	test   %eax,%eax
  800e0a:	7f 08                	jg     800e14 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e0f:	5b                   	pop    %ebx
  800e10:	5e                   	pop    %esi
  800e11:	5f                   	pop    %edi
  800e12:	5d                   	pop    %ebp
  800e13:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e14:	83 ec 0c             	sub    $0xc,%esp
  800e17:	50                   	push   %eax
  800e18:	6a 0d                	push   $0xd
  800e1a:	68 bf 28 80 00       	push   $0x8028bf
  800e1f:	6a 23                	push   $0x23
  800e21:	68 dc 28 80 00       	push   $0x8028dc
  800e26:	e8 bc f2 ff ff       	call   8000e7 <_panic>

00800e2b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e2b:	f3 0f 1e fb          	endbr32 
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	05 00 00 00 30       	add    $0x30000000,%eax
  800e3a:	c1 e8 0c             	shr    $0xc,%eax
}
  800e3d:	5d                   	pop    %ebp
  800e3e:	c3                   	ret    

00800e3f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e3f:	f3 0f 1e fb          	endbr32 
  800e43:	55                   	push   %ebp
  800e44:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e4e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e53:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e58:	5d                   	pop    %ebp
  800e59:	c3                   	ret    

00800e5a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e5a:	f3 0f 1e fb          	endbr32 
  800e5e:	55                   	push   %ebp
  800e5f:	89 e5                	mov    %esp,%ebp
  800e61:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e66:	89 c2                	mov    %eax,%edx
  800e68:	c1 ea 16             	shr    $0x16,%edx
  800e6b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e72:	f6 c2 01             	test   $0x1,%dl
  800e75:	74 2d                	je     800ea4 <fd_alloc+0x4a>
  800e77:	89 c2                	mov    %eax,%edx
  800e79:	c1 ea 0c             	shr    $0xc,%edx
  800e7c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e83:	f6 c2 01             	test   $0x1,%dl
  800e86:	74 1c                	je     800ea4 <fd_alloc+0x4a>
  800e88:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800e8d:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e92:	75 d2                	jne    800e66 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800e9d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800ea2:	eb 0a                	jmp    800eae <fd_alloc+0x54>
			*fd_store = fd;
  800ea4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ea7:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ea9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eae:	5d                   	pop    %ebp
  800eaf:	c3                   	ret    

00800eb0 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800eb0:	f3 0f 1e fb          	endbr32 
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800eba:	83 f8 1f             	cmp    $0x1f,%eax
  800ebd:	77 30                	ja     800eef <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800ebf:	c1 e0 0c             	shl    $0xc,%eax
  800ec2:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800ec7:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800ecd:	f6 c2 01             	test   $0x1,%dl
  800ed0:	74 24                	je     800ef6 <fd_lookup+0x46>
  800ed2:	89 c2                	mov    %eax,%edx
  800ed4:	c1 ea 0c             	shr    $0xc,%edx
  800ed7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ede:	f6 c2 01             	test   $0x1,%dl
  800ee1:	74 1a                	je     800efd <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800ee3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee6:	89 02                	mov    %eax,(%edx)
	return 0;
  800ee8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eed:	5d                   	pop    %ebp
  800eee:	c3                   	ret    
		return -E_INVAL;
  800eef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ef4:	eb f7                	jmp    800eed <fd_lookup+0x3d>
		return -E_INVAL;
  800ef6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800efb:	eb f0                	jmp    800eed <fd_lookup+0x3d>
  800efd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f02:	eb e9                	jmp    800eed <fd_lookup+0x3d>

00800f04 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f04:	f3 0f 1e fb          	endbr32 
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	83 ec 08             	sub    $0x8,%esp
  800f0e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f11:	ba 68 29 80 00       	mov    $0x802968,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800f16:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f1b:	39 08                	cmp    %ecx,(%eax)
  800f1d:	74 33                	je     800f52 <dev_lookup+0x4e>
  800f1f:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800f22:	8b 02                	mov    (%edx),%eax
  800f24:	85 c0                	test   %eax,%eax
  800f26:	75 f3                	jne    800f1b <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f28:	a1 04 40 80 00       	mov    0x804004,%eax
  800f2d:	8b 40 48             	mov    0x48(%eax),%eax
  800f30:	83 ec 04             	sub    $0x4,%esp
  800f33:	51                   	push   %ecx
  800f34:	50                   	push   %eax
  800f35:	68 ec 28 80 00       	push   $0x8028ec
  800f3a:	e8 8f f2 ff ff       	call   8001ce <cprintf>
	*dev = 0;
  800f3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f42:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f48:	83 c4 10             	add    $0x10,%esp
  800f4b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f50:	c9                   	leave  
  800f51:	c3                   	ret    
			*dev = devtab[i];
  800f52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f55:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f57:	b8 00 00 00 00       	mov    $0x0,%eax
  800f5c:	eb f2                	jmp    800f50 <dev_lookup+0x4c>

00800f5e <fd_close>:
{
  800f5e:	f3 0f 1e fb          	endbr32 
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
  800f65:	57                   	push   %edi
  800f66:	56                   	push   %esi
  800f67:	53                   	push   %ebx
  800f68:	83 ec 24             	sub    $0x24,%esp
  800f6b:	8b 75 08             	mov    0x8(%ebp),%esi
  800f6e:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f71:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f74:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f75:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800f7b:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f7e:	50                   	push   %eax
  800f7f:	e8 2c ff ff ff       	call   800eb0 <fd_lookup>
  800f84:	89 c3                	mov    %eax,%ebx
  800f86:	83 c4 10             	add    $0x10,%esp
  800f89:	85 c0                	test   %eax,%eax
  800f8b:	78 05                	js     800f92 <fd_close+0x34>
	    || fd != fd2)
  800f8d:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800f90:	74 16                	je     800fa8 <fd_close+0x4a>
		return (must_exist ? r : 0);
  800f92:	89 f8                	mov    %edi,%eax
  800f94:	84 c0                	test   %al,%al
  800f96:	b8 00 00 00 00       	mov    $0x0,%eax
  800f9b:	0f 44 d8             	cmove  %eax,%ebx
}
  800f9e:	89 d8                	mov    %ebx,%eax
  800fa0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fa3:	5b                   	pop    %ebx
  800fa4:	5e                   	pop    %esi
  800fa5:	5f                   	pop    %edi
  800fa6:	5d                   	pop    %ebp
  800fa7:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800fa8:	83 ec 08             	sub    $0x8,%esp
  800fab:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800fae:	50                   	push   %eax
  800faf:	ff 36                	pushl  (%esi)
  800fb1:	e8 4e ff ff ff       	call   800f04 <dev_lookup>
  800fb6:	89 c3                	mov    %eax,%ebx
  800fb8:	83 c4 10             	add    $0x10,%esp
  800fbb:	85 c0                	test   %eax,%eax
  800fbd:	78 1a                	js     800fd9 <fd_close+0x7b>
		if (dev->dev_close)
  800fbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fc2:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800fc5:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800fca:	85 c0                	test   %eax,%eax
  800fcc:	74 0b                	je     800fd9 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  800fce:	83 ec 0c             	sub    $0xc,%esp
  800fd1:	56                   	push   %esi
  800fd2:	ff d0                	call   *%eax
  800fd4:	89 c3                	mov    %eax,%ebx
  800fd6:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800fd9:	83 ec 08             	sub    $0x8,%esp
  800fdc:	56                   	push   %esi
  800fdd:	6a 00                	push   $0x0
  800fdf:	e8 c3 fc ff ff       	call   800ca7 <sys_page_unmap>
	return r;
  800fe4:	83 c4 10             	add    $0x10,%esp
  800fe7:	eb b5                	jmp    800f9e <fd_close+0x40>

00800fe9 <close>:

int
close(int fdnum)
{
  800fe9:	f3 0f 1e fb          	endbr32 
  800fed:	55                   	push   %ebp
  800fee:	89 e5                	mov    %esp,%ebp
  800ff0:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800ff3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ff6:	50                   	push   %eax
  800ff7:	ff 75 08             	pushl  0x8(%ebp)
  800ffa:	e8 b1 fe ff ff       	call   800eb0 <fd_lookup>
  800fff:	83 c4 10             	add    $0x10,%esp
  801002:	85 c0                	test   %eax,%eax
  801004:	79 02                	jns    801008 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801006:	c9                   	leave  
  801007:	c3                   	ret    
		return fd_close(fd, 1);
  801008:	83 ec 08             	sub    $0x8,%esp
  80100b:	6a 01                	push   $0x1
  80100d:	ff 75 f4             	pushl  -0xc(%ebp)
  801010:	e8 49 ff ff ff       	call   800f5e <fd_close>
  801015:	83 c4 10             	add    $0x10,%esp
  801018:	eb ec                	jmp    801006 <close+0x1d>

0080101a <close_all>:

void
close_all(void)
{
  80101a:	f3 0f 1e fb          	endbr32 
  80101e:	55                   	push   %ebp
  80101f:	89 e5                	mov    %esp,%ebp
  801021:	53                   	push   %ebx
  801022:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801025:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80102a:	83 ec 0c             	sub    $0xc,%esp
  80102d:	53                   	push   %ebx
  80102e:	e8 b6 ff ff ff       	call   800fe9 <close>
	for (i = 0; i < MAXFD; i++)
  801033:	83 c3 01             	add    $0x1,%ebx
  801036:	83 c4 10             	add    $0x10,%esp
  801039:	83 fb 20             	cmp    $0x20,%ebx
  80103c:	75 ec                	jne    80102a <close_all+0x10>
}
  80103e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801041:	c9                   	leave  
  801042:	c3                   	ret    

00801043 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801043:	f3 0f 1e fb          	endbr32 
  801047:	55                   	push   %ebp
  801048:	89 e5                	mov    %esp,%ebp
  80104a:	57                   	push   %edi
  80104b:	56                   	push   %esi
  80104c:	53                   	push   %ebx
  80104d:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801050:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801053:	50                   	push   %eax
  801054:	ff 75 08             	pushl  0x8(%ebp)
  801057:	e8 54 fe ff ff       	call   800eb0 <fd_lookup>
  80105c:	89 c3                	mov    %eax,%ebx
  80105e:	83 c4 10             	add    $0x10,%esp
  801061:	85 c0                	test   %eax,%eax
  801063:	0f 88 81 00 00 00    	js     8010ea <dup+0xa7>
		return r;
	close(newfdnum);
  801069:	83 ec 0c             	sub    $0xc,%esp
  80106c:	ff 75 0c             	pushl  0xc(%ebp)
  80106f:	e8 75 ff ff ff       	call   800fe9 <close>

	newfd = INDEX2FD(newfdnum);
  801074:	8b 75 0c             	mov    0xc(%ebp),%esi
  801077:	c1 e6 0c             	shl    $0xc,%esi
  80107a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801080:	83 c4 04             	add    $0x4,%esp
  801083:	ff 75 e4             	pushl  -0x1c(%ebp)
  801086:	e8 b4 fd ff ff       	call   800e3f <fd2data>
  80108b:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80108d:	89 34 24             	mov    %esi,(%esp)
  801090:	e8 aa fd ff ff       	call   800e3f <fd2data>
  801095:	83 c4 10             	add    $0x10,%esp
  801098:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80109a:	89 d8                	mov    %ebx,%eax
  80109c:	c1 e8 16             	shr    $0x16,%eax
  80109f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010a6:	a8 01                	test   $0x1,%al
  8010a8:	74 11                	je     8010bb <dup+0x78>
  8010aa:	89 d8                	mov    %ebx,%eax
  8010ac:	c1 e8 0c             	shr    $0xc,%eax
  8010af:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010b6:	f6 c2 01             	test   $0x1,%dl
  8010b9:	75 39                	jne    8010f4 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8010bb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8010be:	89 d0                	mov    %edx,%eax
  8010c0:	c1 e8 0c             	shr    $0xc,%eax
  8010c3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010ca:	83 ec 0c             	sub    $0xc,%esp
  8010cd:	25 07 0e 00 00       	and    $0xe07,%eax
  8010d2:	50                   	push   %eax
  8010d3:	56                   	push   %esi
  8010d4:	6a 00                	push   $0x0
  8010d6:	52                   	push   %edx
  8010d7:	6a 00                	push   $0x0
  8010d9:	e8 83 fb ff ff       	call   800c61 <sys_page_map>
  8010de:	89 c3                	mov    %eax,%ebx
  8010e0:	83 c4 20             	add    $0x20,%esp
  8010e3:	85 c0                	test   %eax,%eax
  8010e5:	78 31                	js     801118 <dup+0xd5>
		goto err;

	return newfdnum;
  8010e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8010ea:	89 d8                	mov    %ebx,%eax
  8010ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ef:	5b                   	pop    %ebx
  8010f0:	5e                   	pop    %esi
  8010f1:	5f                   	pop    %edi
  8010f2:	5d                   	pop    %ebp
  8010f3:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8010f4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010fb:	83 ec 0c             	sub    $0xc,%esp
  8010fe:	25 07 0e 00 00       	and    $0xe07,%eax
  801103:	50                   	push   %eax
  801104:	57                   	push   %edi
  801105:	6a 00                	push   $0x0
  801107:	53                   	push   %ebx
  801108:	6a 00                	push   $0x0
  80110a:	e8 52 fb ff ff       	call   800c61 <sys_page_map>
  80110f:	89 c3                	mov    %eax,%ebx
  801111:	83 c4 20             	add    $0x20,%esp
  801114:	85 c0                	test   %eax,%eax
  801116:	79 a3                	jns    8010bb <dup+0x78>
	sys_page_unmap(0, newfd);
  801118:	83 ec 08             	sub    $0x8,%esp
  80111b:	56                   	push   %esi
  80111c:	6a 00                	push   $0x0
  80111e:	e8 84 fb ff ff       	call   800ca7 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801123:	83 c4 08             	add    $0x8,%esp
  801126:	57                   	push   %edi
  801127:	6a 00                	push   $0x0
  801129:	e8 79 fb ff ff       	call   800ca7 <sys_page_unmap>
	return r;
  80112e:	83 c4 10             	add    $0x10,%esp
  801131:	eb b7                	jmp    8010ea <dup+0xa7>

00801133 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801133:	f3 0f 1e fb          	endbr32 
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
  80113a:	53                   	push   %ebx
  80113b:	83 ec 1c             	sub    $0x1c,%esp
  80113e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801141:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801144:	50                   	push   %eax
  801145:	53                   	push   %ebx
  801146:	e8 65 fd ff ff       	call   800eb0 <fd_lookup>
  80114b:	83 c4 10             	add    $0x10,%esp
  80114e:	85 c0                	test   %eax,%eax
  801150:	78 3f                	js     801191 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801152:	83 ec 08             	sub    $0x8,%esp
  801155:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801158:	50                   	push   %eax
  801159:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80115c:	ff 30                	pushl  (%eax)
  80115e:	e8 a1 fd ff ff       	call   800f04 <dev_lookup>
  801163:	83 c4 10             	add    $0x10,%esp
  801166:	85 c0                	test   %eax,%eax
  801168:	78 27                	js     801191 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80116a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80116d:	8b 42 08             	mov    0x8(%edx),%eax
  801170:	83 e0 03             	and    $0x3,%eax
  801173:	83 f8 01             	cmp    $0x1,%eax
  801176:	74 1e                	je     801196 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801178:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80117b:	8b 40 08             	mov    0x8(%eax),%eax
  80117e:	85 c0                	test   %eax,%eax
  801180:	74 35                	je     8011b7 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801182:	83 ec 04             	sub    $0x4,%esp
  801185:	ff 75 10             	pushl  0x10(%ebp)
  801188:	ff 75 0c             	pushl  0xc(%ebp)
  80118b:	52                   	push   %edx
  80118c:	ff d0                	call   *%eax
  80118e:	83 c4 10             	add    $0x10,%esp
}
  801191:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801194:	c9                   	leave  
  801195:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801196:	a1 04 40 80 00       	mov    0x804004,%eax
  80119b:	8b 40 48             	mov    0x48(%eax),%eax
  80119e:	83 ec 04             	sub    $0x4,%esp
  8011a1:	53                   	push   %ebx
  8011a2:	50                   	push   %eax
  8011a3:	68 2d 29 80 00       	push   $0x80292d
  8011a8:	e8 21 f0 ff ff       	call   8001ce <cprintf>
		return -E_INVAL;
  8011ad:	83 c4 10             	add    $0x10,%esp
  8011b0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011b5:	eb da                	jmp    801191 <read+0x5e>
		return -E_NOT_SUPP;
  8011b7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011bc:	eb d3                	jmp    801191 <read+0x5e>

008011be <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8011be:	f3 0f 1e fb          	endbr32 
  8011c2:	55                   	push   %ebp
  8011c3:	89 e5                	mov    %esp,%ebp
  8011c5:	57                   	push   %edi
  8011c6:	56                   	push   %esi
  8011c7:	53                   	push   %ebx
  8011c8:	83 ec 0c             	sub    $0xc,%esp
  8011cb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011ce:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8011d1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011d6:	eb 02                	jmp    8011da <readn+0x1c>
  8011d8:	01 c3                	add    %eax,%ebx
  8011da:	39 f3                	cmp    %esi,%ebx
  8011dc:	73 21                	jae    8011ff <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011de:	83 ec 04             	sub    $0x4,%esp
  8011e1:	89 f0                	mov    %esi,%eax
  8011e3:	29 d8                	sub    %ebx,%eax
  8011e5:	50                   	push   %eax
  8011e6:	89 d8                	mov    %ebx,%eax
  8011e8:	03 45 0c             	add    0xc(%ebp),%eax
  8011eb:	50                   	push   %eax
  8011ec:	57                   	push   %edi
  8011ed:	e8 41 ff ff ff       	call   801133 <read>
		if (m < 0)
  8011f2:	83 c4 10             	add    $0x10,%esp
  8011f5:	85 c0                	test   %eax,%eax
  8011f7:	78 04                	js     8011fd <readn+0x3f>
			return m;
		if (m == 0)
  8011f9:	75 dd                	jne    8011d8 <readn+0x1a>
  8011fb:	eb 02                	jmp    8011ff <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011fd:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8011ff:	89 d8                	mov    %ebx,%eax
  801201:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801204:	5b                   	pop    %ebx
  801205:	5e                   	pop    %esi
  801206:	5f                   	pop    %edi
  801207:	5d                   	pop    %ebp
  801208:	c3                   	ret    

00801209 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801209:	f3 0f 1e fb          	endbr32 
  80120d:	55                   	push   %ebp
  80120e:	89 e5                	mov    %esp,%ebp
  801210:	53                   	push   %ebx
  801211:	83 ec 1c             	sub    $0x1c,%esp
  801214:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801217:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80121a:	50                   	push   %eax
  80121b:	53                   	push   %ebx
  80121c:	e8 8f fc ff ff       	call   800eb0 <fd_lookup>
  801221:	83 c4 10             	add    $0x10,%esp
  801224:	85 c0                	test   %eax,%eax
  801226:	78 3a                	js     801262 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801228:	83 ec 08             	sub    $0x8,%esp
  80122b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80122e:	50                   	push   %eax
  80122f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801232:	ff 30                	pushl  (%eax)
  801234:	e8 cb fc ff ff       	call   800f04 <dev_lookup>
  801239:	83 c4 10             	add    $0x10,%esp
  80123c:	85 c0                	test   %eax,%eax
  80123e:	78 22                	js     801262 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801240:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801243:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801247:	74 1e                	je     801267 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801249:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80124c:	8b 52 0c             	mov    0xc(%edx),%edx
  80124f:	85 d2                	test   %edx,%edx
  801251:	74 35                	je     801288 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801253:	83 ec 04             	sub    $0x4,%esp
  801256:	ff 75 10             	pushl  0x10(%ebp)
  801259:	ff 75 0c             	pushl  0xc(%ebp)
  80125c:	50                   	push   %eax
  80125d:	ff d2                	call   *%edx
  80125f:	83 c4 10             	add    $0x10,%esp
}
  801262:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801265:	c9                   	leave  
  801266:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801267:	a1 04 40 80 00       	mov    0x804004,%eax
  80126c:	8b 40 48             	mov    0x48(%eax),%eax
  80126f:	83 ec 04             	sub    $0x4,%esp
  801272:	53                   	push   %ebx
  801273:	50                   	push   %eax
  801274:	68 49 29 80 00       	push   $0x802949
  801279:	e8 50 ef ff ff       	call   8001ce <cprintf>
		return -E_INVAL;
  80127e:	83 c4 10             	add    $0x10,%esp
  801281:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801286:	eb da                	jmp    801262 <write+0x59>
		return -E_NOT_SUPP;
  801288:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80128d:	eb d3                	jmp    801262 <write+0x59>

0080128f <seek>:

int
seek(int fdnum, off_t offset)
{
  80128f:	f3 0f 1e fb          	endbr32 
  801293:	55                   	push   %ebp
  801294:	89 e5                	mov    %esp,%ebp
  801296:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801299:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80129c:	50                   	push   %eax
  80129d:	ff 75 08             	pushl  0x8(%ebp)
  8012a0:	e8 0b fc ff ff       	call   800eb0 <fd_lookup>
  8012a5:	83 c4 10             	add    $0x10,%esp
  8012a8:	85 c0                	test   %eax,%eax
  8012aa:	78 0e                	js     8012ba <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8012ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012b2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8012b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012ba:	c9                   	leave  
  8012bb:	c3                   	ret    

008012bc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8012bc:	f3 0f 1e fb          	endbr32 
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
  8012c3:	53                   	push   %ebx
  8012c4:	83 ec 1c             	sub    $0x1c,%esp
  8012c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012ca:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012cd:	50                   	push   %eax
  8012ce:	53                   	push   %ebx
  8012cf:	e8 dc fb ff ff       	call   800eb0 <fd_lookup>
  8012d4:	83 c4 10             	add    $0x10,%esp
  8012d7:	85 c0                	test   %eax,%eax
  8012d9:	78 37                	js     801312 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012db:	83 ec 08             	sub    $0x8,%esp
  8012de:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012e1:	50                   	push   %eax
  8012e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012e5:	ff 30                	pushl  (%eax)
  8012e7:	e8 18 fc ff ff       	call   800f04 <dev_lookup>
  8012ec:	83 c4 10             	add    $0x10,%esp
  8012ef:	85 c0                	test   %eax,%eax
  8012f1:	78 1f                	js     801312 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012f6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012fa:	74 1b                	je     801317 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8012fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012ff:	8b 52 18             	mov    0x18(%edx),%edx
  801302:	85 d2                	test   %edx,%edx
  801304:	74 32                	je     801338 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801306:	83 ec 08             	sub    $0x8,%esp
  801309:	ff 75 0c             	pushl  0xc(%ebp)
  80130c:	50                   	push   %eax
  80130d:	ff d2                	call   *%edx
  80130f:	83 c4 10             	add    $0x10,%esp
}
  801312:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801315:	c9                   	leave  
  801316:	c3                   	ret    
			thisenv->env_id, fdnum);
  801317:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80131c:	8b 40 48             	mov    0x48(%eax),%eax
  80131f:	83 ec 04             	sub    $0x4,%esp
  801322:	53                   	push   %ebx
  801323:	50                   	push   %eax
  801324:	68 0c 29 80 00       	push   $0x80290c
  801329:	e8 a0 ee ff ff       	call   8001ce <cprintf>
		return -E_INVAL;
  80132e:	83 c4 10             	add    $0x10,%esp
  801331:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801336:	eb da                	jmp    801312 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801338:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80133d:	eb d3                	jmp    801312 <ftruncate+0x56>

0080133f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80133f:	f3 0f 1e fb          	endbr32 
  801343:	55                   	push   %ebp
  801344:	89 e5                	mov    %esp,%ebp
  801346:	53                   	push   %ebx
  801347:	83 ec 1c             	sub    $0x1c,%esp
  80134a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80134d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801350:	50                   	push   %eax
  801351:	ff 75 08             	pushl  0x8(%ebp)
  801354:	e8 57 fb ff ff       	call   800eb0 <fd_lookup>
  801359:	83 c4 10             	add    $0x10,%esp
  80135c:	85 c0                	test   %eax,%eax
  80135e:	78 4b                	js     8013ab <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801360:	83 ec 08             	sub    $0x8,%esp
  801363:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801366:	50                   	push   %eax
  801367:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80136a:	ff 30                	pushl  (%eax)
  80136c:	e8 93 fb ff ff       	call   800f04 <dev_lookup>
  801371:	83 c4 10             	add    $0x10,%esp
  801374:	85 c0                	test   %eax,%eax
  801376:	78 33                	js     8013ab <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80137b:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80137f:	74 2f                	je     8013b0 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801381:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801384:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80138b:	00 00 00 
	stat->st_isdir = 0;
  80138e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801395:	00 00 00 
	stat->st_dev = dev;
  801398:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80139e:	83 ec 08             	sub    $0x8,%esp
  8013a1:	53                   	push   %ebx
  8013a2:	ff 75 f0             	pushl  -0x10(%ebp)
  8013a5:	ff 50 14             	call   *0x14(%eax)
  8013a8:	83 c4 10             	add    $0x10,%esp
}
  8013ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ae:	c9                   	leave  
  8013af:	c3                   	ret    
		return -E_NOT_SUPP;
  8013b0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013b5:	eb f4                	jmp    8013ab <fstat+0x6c>

008013b7 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8013b7:	f3 0f 1e fb          	endbr32 
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
  8013be:	56                   	push   %esi
  8013bf:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8013c0:	83 ec 08             	sub    $0x8,%esp
  8013c3:	6a 00                	push   $0x0
  8013c5:	ff 75 08             	pushl  0x8(%ebp)
  8013c8:	e8 fb 01 00 00       	call   8015c8 <open>
  8013cd:	89 c3                	mov    %eax,%ebx
  8013cf:	83 c4 10             	add    $0x10,%esp
  8013d2:	85 c0                	test   %eax,%eax
  8013d4:	78 1b                	js     8013f1 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8013d6:	83 ec 08             	sub    $0x8,%esp
  8013d9:	ff 75 0c             	pushl  0xc(%ebp)
  8013dc:	50                   	push   %eax
  8013dd:	e8 5d ff ff ff       	call   80133f <fstat>
  8013e2:	89 c6                	mov    %eax,%esi
	close(fd);
  8013e4:	89 1c 24             	mov    %ebx,(%esp)
  8013e7:	e8 fd fb ff ff       	call   800fe9 <close>
	return r;
  8013ec:	83 c4 10             	add    $0x10,%esp
  8013ef:	89 f3                	mov    %esi,%ebx
}
  8013f1:	89 d8                	mov    %ebx,%eax
  8013f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013f6:	5b                   	pop    %ebx
  8013f7:	5e                   	pop    %esi
  8013f8:	5d                   	pop    %ebp
  8013f9:	c3                   	ret    

008013fa <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8013fa:	55                   	push   %ebp
  8013fb:	89 e5                	mov    %esp,%ebp
  8013fd:	56                   	push   %esi
  8013fe:	53                   	push   %ebx
  8013ff:	89 c6                	mov    %eax,%esi
  801401:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801403:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80140a:	74 27                	je     801433 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80140c:	6a 07                	push   $0x7
  80140e:	68 00 50 80 00       	push   $0x805000
  801413:	56                   	push   %esi
  801414:	ff 35 00 40 80 00    	pushl  0x804000
  80141a:	e8 e4 0d 00 00       	call   802203 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80141f:	83 c4 0c             	add    $0xc,%esp
  801422:	6a 00                	push   $0x0
  801424:	53                   	push   %ebx
  801425:	6a 00                	push   $0x0
  801427:	e8 52 0d 00 00       	call   80217e <ipc_recv>
}
  80142c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80142f:	5b                   	pop    %ebx
  801430:	5e                   	pop    %esi
  801431:	5d                   	pop    %ebp
  801432:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801433:	83 ec 0c             	sub    $0xc,%esp
  801436:	6a 01                	push   $0x1
  801438:	e8 1e 0e 00 00       	call   80225b <ipc_find_env>
  80143d:	a3 00 40 80 00       	mov    %eax,0x804000
  801442:	83 c4 10             	add    $0x10,%esp
  801445:	eb c5                	jmp    80140c <fsipc+0x12>

00801447 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801447:	f3 0f 1e fb          	endbr32 
  80144b:	55                   	push   %ebp
  80144c:	89 e5                	mov    %esp,%ebp
  80144e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801451:	8b 45 08             	mov    0x8(%ebp),%eax
  801454:	8b 40 0c             	mov    0xc(%eax),%eax
  801457:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80145c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145f:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801464:	ba 00 00 00 00       	mov    $0x0,%edx
  801469:	b8 02 00 00 00       	mov    $0x2,%eax
  80146e:	e8 87 ff ff ff       	call   8013fa <fsipc>
}
  801473:	c9                   	leave  
  801474:	c3                   	ret    

00801475 <devfile_flush>:
{
  801475:	f3 0f 1e fb          	endbr32 
  801479:	55                   	push   %ebp
  80147a:	89 e5                	mov    %esp,%ebp
  80147c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	8b 40 0c             	mov    0xc(%eax),%eax
  801485:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80148a:	ba 00 00 00 00       	mov    $0x0,%edx
  80148f:	b8 06 00 00 00       	mov    $0x6,%eax
  801494:	e8 61 ff ff ff       	call   8013fa <fsipc>
}
  801499:	c9                   	leave  
  80149a:	c3                   	ret    

0080149b <devfile_stat>:
{
  80149b:	f3 0f 1e fb          	endbr32 
  80149f:	55                   	push   %ebp
  8014a0:	89 e5                	mov    %esp,%ebp
  8014a2:	53                   	push   %ebx
  8014a3:	83 ec 04             	sub    $0x4,%esp
  8014a6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8014af:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8014b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b9:	b8 05 00 00 00       	mov    $0x5,%eax
  8014be:	e8 37 ff ff ff       	call   8013fa <fsipc>
  8014c3:	85 c0                	test   %eax,%eax
  8014c5:	78 2c                	js     8014f3 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8014c7:	83 ec 08             	sub    $0x8,%esp
  8014ca:	68 00 50 80 00       	push   $0x805000
  8014cf:	53                   	push   %ebx
  8014d0:	e8 03 f3 ff ff       	call   8007d8 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8014d5:	a1 80 50 80 00       	mov    0x805080,%eax
  8014da:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8014e0:	a1 84 50 80 00       	mov    0x805084,%eax
  8014e5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8014eb:	83 c4 10             	add    $0x10,%esp
  8014ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014f6:	c9                   	leave  
  8014f7:	c3                   	ret    

008014f8 <devfile_write>:
{
  8014f8:	f3 0f 1e fb          	endbr32 
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
  8014ff:	83 ec 0c             	sub    $0xc,%esp
  801502:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801505:	8b 55 08             	mov    0x8(%ebp),%edx
  801508:	8b 52 0c             	mov    0xc(%edx),%edx
  80150b:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801511:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801516:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80151b:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  80151e:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801523:	50                   	push   %eax
  801524:	ff 75 0c             	pushl  0xc(%ebp)
  801527:	68 08 50 80 00       	push   $0x805008
  80152c:	e8 5d f4 ff ff       	call   80098e <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801531:	ba 00 00 00 00       	mov    $0x0,%edx
  801536:	b8 04 00 00 00       	mov    $0x4,%eax
  80153b:	e8 ba fe ff ff       	call   8013fa <fsipc>
}
  801540:	c9                   	leave  
  801541:	c3                   	ret    

00801542 <devfile_read>:
{
  801542:	f3 0f 1e fb          	endbr32 
  801546:	55                   	push   %ebp
  801547:	89 e5                	mov    %esp,%ebp
  801549:	56                   	push   %esi
  80154a:	53                   	push   %ebx
  80154b:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80154e:	8b 45 08             	mov    0x8(%ebp),%eax
  801551:	8b 40 0c             	mov    0xc(%eax),%eax
  801554:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801559:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80155f:	ba 00 00 00 00       	mov    $0x0,%edx
  801564:	b8 03 00 00 00       	mov    $0x3,%eax
  801569:	e8 8c fe ff ff       	call   8013fa <fsipc>
  80156e:	89 c3                	mov    %eax,%ebx
  801570:	85 c0                	test   %eax,%eax
  801572:	78 1f                	js     801593 <devfile_read+0x51>
	assert(r <= n);
  801574:	39 f0                	cmp    %esi,%eax
  801576:	77 24                	ja     80159c <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801578:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80157d:	7f 33                	jg     8015b2 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80157f:	83 ec 04             	sub    $0x4,%esp
  801582:	50                   	push   %eax
  801583:	68 00 50 80 00       	push   $0x805000
  801588:	ff 75 0c             	pushl  0xc(%ebp)
  80158b:	e8 fe f3 ff ff       	call   80098e <memmove>
	return r;
  801590:	83 c4 10             	add    $0x10,%esp
}
  801593:	89 d8                	mov    %ebx,%eax
  801595:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801598:	5b                   	pop    %ebx
  801599:	5e                   	pop    %esi
  80159a:	5d                   	pop    %ebp
  80159b:	c3                   	ret    
	assert(r <= n);
  80159c:	68 78 29 80 00       	push   $0x802978
  8015a1:	68 7f 29 80 00       	push   $0x80297f
  8015a6:	6a 7c                	push   $0x7c
  8015a8:	68 94 29 80 00       	push   $0x802994
  8015ad:	e8 35 eb ff ff       	call   8000e7 <_panic>
	assert(r <= PGSIZE);
  8015b2:	68 9f 29 80 00       	push   $0x80299f
  8015b7:	68 7f 29 80 00       	push   $0x80297f
  8015bc:	6a 7d                	push   $0x7d
  8015be:	68 94 29 80 00       	push   $0x802994
  8015c3:	e8 1f eb ff ff       	call   8000e7 <_panic>

008015c8 <open>:
{
  8015c8:	f3 0f 1e fb          	endbr32 
  8015cc:	55                   	push   %ebp
  8015cd:	89 e5                	mov    %esp,%ebp
  8015cf:	56                   	push   %esi
  8015d0:	53                   	push   %ebx
  8015d1:	83 ec 1c             	sub    $0x1c,%esp
  8015d4:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8015d7:	56                   	push   %esi
  8015d8:	e8 b8 f1 ff ff       	call   800795 <strlen>
  8015dd:	83 c4 10             	add    $0x10,%esp
  8015e0:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8015e5:	7f 6c                	jg     801653 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8015e7:	83 ec 0c             	sub    $0xc,%esp
  8015ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ed:	50                   	push   %eax
  8015ee:	e8 67 f8 ff ff       	call   800e5a <fd_alloc>
  8015f3:	89 c3                	mov    %eax,%ebx
  8015f5:	83 c4 10             	add    $0x10,%esp
  8015f8:	85 c0                	test   %eax,%eax
  8015fa:	78 3c                	js     801638 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8015fc:	83 ec 08             	sub    $0x8,%esp
  8015ff:	56                   	push   %esi
  801600:	68 00 50 80 00       	push   $0x805000
  801605:	e8 ce f1 ff ff       	call   8007d8 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80160a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160d:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801612:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801615:	b8 01 00 00 00       	mov    $0x1,%eax
  80161a:	e8 db fd ff ff       	call   8013fa <fsipc>
  80161f:	89 c3                	mov    %eax,%ebx
  801621:	83 c4 10             	add    $0x10,%esp
  801624:	85 c0                	test   %eax,%eax
  801626:	78 19                	js     801641 <open+0x79>
	return fd2num(fd);
  801628:	83 ec 0c             	sub    $0xc,%esp
  80162b:	ff 75 f4             	pushl  -0xc(%ebp)
  80162e:	e8 f8 f7 ff ff       	call   800e2b <fd2num>
  801633:	89 c3                	mov    %eax,%ebx
  801635:	83 c4 10             	add    $0x10,%esp
}
  801638:	89 d8                	mov    %ebx,%eax
  80163a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80163d:	5b                   	pop    %ebx
  80163e:	5e                   	pop    %esi
  80163f:	5d                   	pop    %ebp
  801640:	c3                   	ret    
		fd_close(fd, 0);
  801641:	83 ec 08             	sub    $0x8,%esp
  801644:	6a 00                	push   $0x0
  801646:	ff 75 f4             	pushl  -0xc(%ebp)
  801649:	e8 10 f9 ff ff       	call   800f5e <fd_close>
		return r;
  80164e:	83 c4 10             	add    $0x10,%esp
  801651:	eb e5                	jmp    801638 <open+0x70>
		return -E_BAD_PATH;
  801653:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801658:	eb de                	jmp    801638 <open+0x70>

0080165a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80165a:	f3 0f 1e fb          	endbr32 
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
  801661:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801664:	ba 00 00 00 00       	mov    $0x0,%edx
  801669:	b8 08 00 00 00       	mov    $0x8,%eax
  80166e:	e8 87 fd ff ff       	call   8013fa <fsipc>
}
  801673:	c9                   	leave  
  801674:	c3                   	ret    

00801675 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801675:	f3 0f 1e fb          	endbr32 
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
  80167c:	57                   	push   %edi
  80167d:	56                   	push   %esi
  80167e:	53                   	push   %ebx
  80167f:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801685:	6a 00                	push   $0x0
  801687:	ff 75 08             	pushl  0x8(%ebp)
  80168a:	e8 39 ff ff ff       	call   8015c8 <open>
  80168f:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801695:	83 c4 10             	add    $0x10,%esp
  801698:	85 c0                	test   %eax,%eax
  80169a:	0f 88 e7 04 00 00    	js     801b87 <spawn+0x512>
  8016a0:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8016a2:	83 ec 04             	sub    $0x4,%esp
  8016a5:	68 00 02 00 00       	push   $0x200
  8016aa:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8016b0:	50                   	push   %eax
  8016b1:	52                   	push   %edx
  8016b2:	e8 07 fb ff ff       	call   8011be <readn>
  8016b7:	83 c4 10             	add    $0x10,%esp
  8016ba:	3d 00 02 00 00       	cmp    $0x200,%eax
  8016bf:	75 7e                	jne    80173f <spawn+0xca>
	    || elf->e_magic != ELF_MAGIC) {
  8016c1:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8016c8:	45 4c 46 
  8016cb:	75 72                	jne    80173f <spawn+0xca>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8016cd:	b8 07 00 00 00       	mov    $0x7,%eax
  8016d2:	cd 30                	int    $0x30
  8016d4:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  8016da:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8016e0:	85 c0                	test   %eax,%eax
  8016e2:	0f 88 93 04 00 00    	js     801b7b <spawn+0x506>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8016e8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8016ed:	6b f0 7c             	imul   $0x7c,%eax,%esi
  8016f0:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  8016f6:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8016fc:	b9 11 00 00 00       	mov    $0x11,%ecx
  801701:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801703:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801709:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  80170f:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801714:	be 00 00 00 00       	mov    $0x0,%esi
  801719:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80171c:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
	for (argc = 0; argv[argc] != 0; argc++)
  801723:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801726:	85 c0                	test   %eax,%eax
  801728:	74 4d                	je     801777 <spawn+0x102>
		string_size += strlen(argv[argc]) + 1;
  80172a:	83 ec 0c             	sub    $0xc,%esp
  80172d:	50                   	push   %eax
  80172e:	e8 62 f0 ff ff       	call   800795 <strlen>
  801733:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801737:	83 c3 01             	add    $0x1,%ebx
  80173a:	83 c4 10             	add    $0x10,%esp
  80173d:	eb dd                	jmp    80171c <spawn+0xa7>
		close(fd);
  80173f:	83 ec 0c             	sub    $0xc,%esp
  801742:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801748:	e8 9c f8 ff ff       	call   800fe9 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80174d:	83 c4 0c             	add    $0xc,%esp
  801750:	68 7f 45 4c 46       	push   $0x464c457f
  801755:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  80175b:	68 ab 29 80 00       	push   $0x8029ab
  801760:	e8 69 ea ff ff       	call   8001ce <cprintf>
		return -E_NOT_EXEC;
  801765:	83 c4 10             	add    $0x10,%esp
  801768:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  80176f:	ff ff ff 
  801772:	e9 10 04 00 00       	jmp    801b87 <spawn+0x512>
  801777:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  80177d:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801783:	bf 00 10 40 00       	mov    $0x401000,%edi
  801788:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  80178a:	89 fa                	mov    %edi,%edx
  80178c:	83 e2 fc             	and    $0xfffffffc,%edx
  80178f:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801796:	29 c2                	sub    %eax,%edx
  801798:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80179e:	8d 42 f8             	lea    -0x8(%edx),%eax
  8017a1:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8017a6:	0f 86 fe 03 00 00    	jbe    801baa <spawn+0x535>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8017ac:	83 ec 04             	sub    $0x4,%esp
  8017af:	6a 07                	push   $0x7
  8017b1:	68 00 00 40 00       	push   $0x400000
  8017b6:	6a 00                	push   $0x0
  8017b8:	e8 5d f4 ff ff       	call   800c1a <sys_page_alloc>
  8017bd:	83 c4 10             	add    $0x10,%esp
  8017c0:	85 c0                	test   %eax,%eax
  8017c2:	0f 88 e7 03 00 00    	js     801baf <spawn+0x53a>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8017c8:	be 00 00 00 00       	mov    $0x0,%esi
  8017cd:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  8017d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8017d6:	eb 30                	jmp    801808 <spawn+0x193>
		argv_store[i] = UTEMP2USTACK(string_store);
  8017d8:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  8017de:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  8017e4:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  8017e7:	83 ec 08             	sub    $0x8,%esp
  8017ea:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8017ed:	57                   	push   %edi
  8017ee:	e8 e5 ef ff ff       	call   8007d8 <strcpy>
		string_store += strlen(argv[i]) + 1;
  8017f3:	83 c4 04             	add    $0x4,%esp
  8017f6:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8017f9:	e8 97 ef ff ff       	call   800795 <strlen>
  8017fe:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801802:	83 c6 01             	add    $0x1,%esi
  801805:	83 c4 10             	add    $0x10,%esp
  801808:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  80180e:	7f c8                	jg     8017d8 <spawn+0x163>
	}
	argv_store[argc] = 0;
  801810:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801816:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  80181c:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801823:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801829:	0f 85 86 00 00 00    	jne    8018b5 <spawn+0x240>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  80182f:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801835:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  80183b:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  80183e:	89 c8                	mov    %ecx,%eax
  801840:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  801846:	89 48 f8             	mov    %ecx,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801849:	2d 08 30 80 11       	sub    $0x11803008,%eax
  80184e:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801854:	83 ec 0c             	sub    $0xc,%esp
  801857:	6a 07                	push   $0x7
  801859:	68 00 d0 bf ee       	push   $0xeebfd000
  80185e:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801864:	68 00 00 40 00       	push   $0x400000
  801869:	6a 00                	push   $0x0
  80186b:	e8 f1 f3 ff ff       	call   800c61 <sys_page_map>
  801870:	89 c3                	mov    %eax,%ebx
  801872:	83 c4 20             	add    $0x20,%esp
  801875:	85 c0                	test   %eax,%eax
  801877:	0f 88 3a 03 00 00    	js     801bb7 <spawn+0x542>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80187d:	83 ec 08             	sub    $0x8,%esp
  801880:	68 00 00 40 00       	push   $0x400000
  801885:	6a 00                	push   $0x0
  801887:	e8 1b f4 ff ff       	call   800ca7 <sys_page_unmap>
  80188c:	89 c3                	mov    %eax,%ebx
  80188e:	83 c4 10             	add    $0x10,%esp
  801891:	85 c0                	test   %eax,%eax
  801893:	0f 88 1e 03 00 00    	js     801bb7 <spawn+0x542>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801899:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  80189f:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8018a6:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  8018ad:	00 00 00 
  8018b0:	e9 4f 01 00 00       	jmp    801a04 <spawn+0x38f>
	assert(string_store == (char*)UTEMP + PGSIZE);
  8018b5:	68 20 2a 80 00       	push   $0x802a20
  8018ba:	68 7f 29 80 00       	push   $0x80297f
  8018bf:	68 f2 00 00 00       	push   $0xf2
  8018c4:	68 c5 29 80 00       	push   $0x8029c5
  8018c9:	e8 19 e8 ff ff       	call   8000e7 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8018ce:	83 ec 04             	sub    $0x4,%esp
  8018d1:	6a 07                	push   $0x7
  8018d3:	68 00 00 40 00       	push   $0x400000
  8018d8:	6a 00                	push   $0x0
  8018da:	e8 3b f3 ff ff       	call   800c1a <sys_page_alloc>
  8018df:	83 c4 10             	add    $0x10,%esp
  8018e2:	85 c0                	test   %eax,%eax
  8018e4:	0f 88 ab 02 00 00    	js     801b95 <spawn+0x520>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8018ea:	83 ec 08             	sub    $0x8,%esp
  8018ed:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  8018f3:	01 f0                	add    %esi,%eax
  8018f5:	50                   	push   %eax
  8018f6:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8018fc:	e8 8e f9 ff ff       	call   80128f <seek>
  801901:	83 c4 10             	add    $0x10,%esp
  801904:	85 c0                	test   %eax,%eax
  801906:	0f 88 90 02 00 00    	js     801b9c <spawn+0x527>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80190c:	83 ec 04             	sub    $0x4,%esp
  80190f:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801915:	29 f0                	sub    %esi,%eax
  801917:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80191c:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801921:	0f 47 c1             	cmova  %ecx,%eax
  801924:	50                   	push   %eax
  801925:	68 00 00 40 00       	push   $0x400000
  80192a:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801930:	e8 89 f8 ff ff       	call   8011be <readn>
  801935:	83 c4 10             	add    $0x10,%esp
  801938:	85 c0                	test   %eax,%eax
  80193a:	0f 88 63 02 00 00    	js     801ba3 <spawn+0x52e>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801940:	83 ec 0c             	sub    $0xc,%esp
  801943:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801949:	53                   	push   %ebx
  80194a:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801950:	68 00 00 40 00       	push   $0x400000
  801955:	6a 00                	push   $0x0
  801957:	e8 05 f3 ff ff       	call   800c61 <sys_page_map>
  80195c:	83 c4 20             	add    $0x20,%esp
  80195f:	85 c0                	test   %eax,%eax
  801961:	78 7c                	js     8019df <spawn+0x36a>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801963:	83 ec 08             	sub    $0x8,%esp
  801966:	68 00 00 40 00       	push   $0x400000
  80196b:	6a 00                	push   $0x0
  80196d:	e8 35 f3 ff ff       	call   800ca7 <sys_page_unmap>
  801972:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801975:	81 c7 00 10 00 00    	add    $0x1000,%edi
  80197b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801981:	89 fe                	mov    %edi,%esi
  801983:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801989:	76 69                	jbe    8019f4 <spawn+0x37f>
		if (i >= filesz) {
  80198b:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801991:	0f 87 37 ff ff ff    	ja     8018ce <spawn+0x259>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801997:	83 ec 04             	sub    $0x4,%esp
  80199a:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8019a0:	53                   	push   %ebx
  8019a1:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  8019a7:	e8 6e f2 ff ff       	call   800c1a <sys_page_alloc>
  8019ac:	83 c4 10             	add    $0x10,%esp
  8019af:	85 c0                	test   %eax,%eax
  8019b1:	79 c2                	jns    801975 <spawn+0x300>
  8019b3:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  8019b5:	83 ec 0c             	sub    $0xc,%esp
  8019b8:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8019be:	e8 cc f1 ff ff       	call   800b8f <sys_env_destroy>
	close(fd);
  8019c3:	83 c4 04             	add    $0x4,%esp
  8019c6:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8019cc:	e8 18 f6 ff ff       	call   800fe9 <close>
	return r;
  8019d1:	83 c4 10             	add    $0x10,%esp
  8019d4:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  8019da:	e9 a8 01 00 00       	jmp    801b87 <spawn+0x512>
				panic("spawn: sys_page_map data: %e", r);
  8019df:	50                   	push   %eax
  8019e0:	68 d1 29 80 00       	push   $0x8029d1
  8019e5:	68 25 01 00 00       	push   $0x125
  8019ea:	68 c5 29 80 00       	push   $0x8029c5
  8019ef:	e8 f3 e6 ff ff       	call   8000e7 <_panic>
  8019f4:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8019fa:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801a01:	83 c6 20             	add    $0x20,%esi
  801a04:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801a0b:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801a11:	7e 6d                	jle    801a80 <spawn+0x40b>
		if (ph->p_type != ELF_PROG_LOAD)
  801a13:	83 3e 01             	cmpl   $0x1,(%esi)
  801a16:	75 e2                	jne    8019fa <spawn+0x385>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801a18:	8b 46 18             	mov    0x18(%esi),%eax
  801a1b:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801a1e:	83 f8 01             	cmp    $0x1,%eax
  801a21:	19 c0                	sbb    %eax,%eax
  801a23:	83 e0 fe             	and    $0xfffffffe,%eax
  801a26:	83 c0 07             	add    $0x7,%eax
  801a29:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801a2f:	8b 4e 04             	mov    0x4(%esi),%ecx
  801a32:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801a38:	8b 56 10             	mov    0x10(%esi),%edx
  801a3b:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801a41:	8b 7e 14             	mov    0x14(%esi),%edi
  801a44:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  801a4a:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801a4d:	89 d8                	mov    %ebx,%eax
  801a4f:	25 ff 0f 00 00       	and    $0xfff,%eax
  801a54:	74 1a                	je     801a70 <spawn+0x3fb>
		va -= i;
  801a56:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801a58:	01 c7                	add    %eax,%edi
  801a5a:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801a60:	01 c2                	add    %eax,%edx
  801a62:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  801a68:	29 c1                	sub    %eax,%ecx
  801a6a:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801a70:	bf 00 00 00 00       	mov    $0x0,%edi
  801a75:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801a7b:	e9 01 ff ff ff       	jmp    801981 <spawn+0x30c>
	close(fd);
  801a80:	83 ec 0c             	sub    $0xc,%esp
  801a83:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801a89:	e8 5b f5 ff ff       	call   800fe9 <close>
  801a8e:	83 c4 10             	add    $0x10,%esp
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	uint32_t addr;
	int r;
	for(addr = 0; addr < USTACKTOP; addr += PGSIZE){
  801a91:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a96:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  801a9c:	eb 0e                	jmp    801aac <spawn+0x437>
  801a9e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801aa4:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801aaa:	74 5a                	je     801b06 <spawn+0x491>
		if((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U) && (uvpt[PGNUM(addr)] & PTE_SHARE)){
  801aac:	89 d8                	mov    %ebx,%eax
  801aae:	c1 e8 16             	shr    $0x16,%eax
  801ab1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801ab8:	a8 01                	test   $0x1,%al
  801aba:	74 e2                	je     801a9e <spawn+0x429>
  801abc:	89 d8                	mov    %ebx,%eax
  801abe:	c1 e8 0c             	shr    $0xc,%eax
  801ac1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801ac8:	f6 c2 01             	test   $0x1,%dl
  801acb:	74 d1                	je     801a9e <spawn+0x429>
  801acd:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801ad4:	f6 c2 04             	test   $0x4,%dl
  801ad7:	74 c5                	je     801a9e <spawn+0x429>
  801ad9:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801ae0:	f6 c6 04             	test   $0x4,%dh
  801ae3:	74 b9                	je     801a9e <spawn+0x429>
			if(r = sys_page_map(0, (void*)addr, child, (void*)addr, (uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  801ae5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801aec:	83 ec 0c             	sub    $0xc,%esp
  801aef:	25 07 0e 00 00       	and    $0xe07,%eax
  801af4:	50                   	push   %eax
  801af5:	53                   	push   %ebx
  801af6:	56                   	push   %esi
  801af7:	53                   	push   %ebx
  801af8:	6a 00                	push   $0x0
  801afa:	e8 62 f1 ff ff       	call   800c61 <sys_page_map>
  801aff:	83 c4 20             	add    $0x20,%esp
  801b02:	85 c0                	test   %eax,%eax
  801b04:	79 98                	jns    801a9e <spawn+0x429>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801b06:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801b0d:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801b10:	83 ec 08             	sub    $0x8,%esp
  801b13:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801b19:	50                   	push   %eax
  801b1a:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801b20:	e8 0e f2 ff ff       	call   800d33 <sys_env_set_trapframe>
  801b25:	83 c4 10             	add    $0x10,%esp
  801b28:	85 c0                	test   %eax,%eax
  801b2a:	78 25                	js     801b51 <spawn+0x4dc>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801b2c:	83 ec 08             	sub    $0x8,%esp
  801b2f:	6a 02                	push   $0x2
  801b31:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801b37:	e8 b1 f1 ff ff       	call   800ced <sys_env_set_status>
  801b3c:	83 c4 10             	add    $0x10,%esp
  801b3f:	85 c0                	test   %eax,%eax
  801b41:	78 23                	js     801b66 <spawn+0x4f1>
	return child;
  801b43:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801b49:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801b4f:	eb 36                	jmp    801b87 <spawn+0x512>
		panic("sys_env_set_trapframe: %e", r);
  801b51:	50                   	push   %eax
  801b52:	68 ee 29 80 00       	push   $0x8029ee
  801b57:	68 86 00 00 00       	push   $0x86
  801b5c:	68 c5 29 80 00       	push   $0x8029c5
  801b61:	e8 81 e5 ff ff       	call   8000e7 <_panic>
		panic("sys_env_set_status: %e", r);
  801b66:	50                   	push   %eax
  801b67:	68 08 2a 80 00       	push   $0x802a08
  801b6c:	68 89 00 00 00       	push   $0x89
  801b71:	68 c5 29 80 00       	push   $0x8029c5
  801b76:	e8 6c e5 ff ff       	call   8000e7 <_panic>
		return r;
  801b7b:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801b81:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  801b87:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801b8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b90:	5b                   	pop    %ebx
  801b91:	5e                   	pop    %esi
  801b92:	5f                   	pop    %edi
  801b93:	5d                   	pop    %ebp
  801b94:	c3                   	ret    
  801b95:	89 c7                	mov    %eax,%edi
  801b97:	e9 19 fe ff ff       	jmp    8019b5 <spawn+0x340>
  801b9c:	89 c7                	mov    %eax,%edi
  801b9e:	e9 12 fe ff ff       	jmp    8019b5 <spawn+0x340>
  801ba3:	89 c7                	mov    %eax,%edi
  801ba5:	e9 0b fe ff ff       	jmp    8019b5 <spawn+0x340>
		return -E_NO_MEM;
  801baa:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(addr = 0; addr < USTACKTOP; addr += PGSIZE){
  801baf:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801bb5:	eb d0                	jmp    801b87 <spawn+0x512>
	sys_page_unmap(0, UTEMP);
  801bb7:	83 ec 08             	sub    $0x8,%esp
  801bba:	68 00 00 40 00       	push   $0x400000
  801bbf:	6a 00                	push   $0x0
  801bc1:	e8 e1 f0 ff ff       	call   800ca7 <sys_page_unmap>
  801bc6:	83 c4 10             	add    $0x10,%esp
  801bc9:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801bcf:	eb b6                	jmp    801b87 <spawn+0x512>

00801bd1 <spawnl>:
{
  801bd1:	f3 0f 1e fb          	endbr32 
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
  801bd8:	57                   	push   %edi
  801bd9:	56                   	push   %esi
  801bda:	53                   	push   %ebx
  801bdb:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801bde:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801be1:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801be6:	8d 4a 04             	lea    0x4(%edx),%ecx
  801be9:	83 3a 00             	cmpl   $0x0,(%edx)
  801bec:	74 07                	je     801bf5 <spawnl+0x24>
		argc++;
  801bee:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801bf1:	89 ca                	mov    %ecx,%edx
  801bf3:	eb f1                	jmp    801be6 <spawnl+0x15>
	const char *argv[argc+2];
  801bf5:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  801bfc:	89 d1                	mov    %edx,%ecx
  801bfe:	83 e1 f0             	and    $0xfffffff0,%ecx
  801c01:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801c07:	89 e6                	mov    %esp,%esi
  801c09:	29 d6                	sub    %edx,%esi
  801c0b:	89 f2                	mov    %esi,%edx
  801c0d:	39 d4                	cmp    %edx,%esp
  801c0f:	74 10                	je     801c21 <spawnl+0x50>
  801c11:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  801c17:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  801c1e:	00 
  801c1f:	eb ec                	jmp    801c0d <spawnl+0x3c>
  801c21:	89 ca                	mov    %ecx,%edx
  801c23:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  801c29:	29 d4                	sub    %edx,%esp
  801c2b:	85 d2                	test   %edx,%edx
  801c2d:	74 05                	je     801c34 <spawnl+0x63>
  801c2f:	83 4c 14 fc 00       	orl    $0x0,-0x4(%esp,%edx,1)
  801c34:	8d 74 24 03          	lea    0x3(%esp),%esi
  801c38:	89 f2                	mov    %esi,%edx
  801c3a:	c1 ea 02             	shr    $0x2,%edx
  801c3d:	83 e6 fc             	and    $0xfffffffc,%esi
  801c40:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801c42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c45:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801c4c:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801c53:	00 
	va_start(vl, arg0);
  801c54:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801c57:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801c59:	b8 00 00 00 00       	mov    $0x0,%eax
  801c5e:	eb 0b                	jmp    801c6b <spawnl+0x9a>
		argv[i+1] = va_arg(vl, const char *);
  801c60:	83 c0 01             	add    $0x1,%eax
  801c63:	8b 39                	mov    (%ecx),%edi
  801c65:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801c68:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801c6b:	39 d0                	cmp    %edx,%eax
  801c6d:	75 f1                	jne    801c60 <spawnl+0x8f>
	return spawn(prog, argv);
  801c6f:	83 ec 08             	sub    $0x8,%esp
  801c72:	56                   	push   %esi
  801c73:	ff 75 08             	pushl  0x8(%ebp)
  801c76:	e8 fa f9 ff ff       	call   801675 <spawn>
}
  801c7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c7e:	5b                   	pop    %ebx
  801c7f:	5e                   	pop    %esi
  801c80:	5f                   	pop    %edi
  801c81:	5d                   	pop    %ebp
  801c82:	c3                   	ret    

00801c83 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c83:	f3 0f 1e fb          	endbr32 
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
  801c8a:	56                   	push   %esi
  801c8b:	53                   	push   %ebx
  801c8c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c8f:	83 ec 0c             	sub    $0xc,%esp
  801c92:	ff 75 08             	pushl  0x8(%ebp)
  801c95:	e8 a5 f1 ff ff       	call   800e3f <fd2data>
  801c9a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c9c:	83 c4 08             	add    $0x8,%esp
  801c9f:	68 46 2a 80 00       	push   $0x802a46
  801ca4:	53                   	push   %ebx
  801ca5:	e8 2e eb ff ff       	call   8007d8 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801caa:	8b 46 04             	mov    0x4(%esi),%eax
  801cad:	2b 06                	sub    (%esi),%eax
  801caf:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801cb5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cbc:	00 00 00 
	stat->st_dev = &devpipe;
  801cbf:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801cc6:	30 80 00 
	return 0;
}
  801cc9:	b8 00 00 00 00       	mov    $0x0,%eax
  801cce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cd1:	5b                   	pop    %ebx
  801cd2:	5e                   	pop    %esi
  801cd3:	5d                   	pop    %ebp
  801cd4:	c3                   	ret    

00801cd5 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801cd5:	f3 0f 1e fb          	endbr32 
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
  801cdc:	53                   	push   %ebx
  801cdd:	83 ec 0c             	sub    $0xc,%esp
  801ce0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ce3:	53                   	push   %ebx
  801ce4:	6a 00                	push   $0x0
  801ce6:	e8 bc ef ff ff       	call   800ca7 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ceb:	89 1c 24             	mov    %ebx,(%esp)
  801cee:	e8 4c f1 ff ff       	call   800e3f <fd2data>
  801cf3:	83 c4 08             	add    $0x8,%esp
  801cf6:	50                   	push   %eax
  801cf7:	6a 00                	push   $0x0
  801cf9:	e8 a9 ef ff ff       	call   800ca7 <sys_page_unmap>
}
  801cfe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d01:	c9                   	leave  
  801d02:	c3                   	ret    

00801d03 <_pipeisclosed>:
{
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
  801d06:	57                   	push   %edi
  801d07:	56                   	push   %esi
  801d08:	53                   	push   %ebx
  801d09:	83 ec 1c             	sub    $0x1c,%esp
  801d0c:	89 c7                	mov    %eax,%edi
  801d0e:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d10:	a1 04 40 80 00       	mov    0x804004,%eax
  801d15:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d18:	83 ec 0c             	sub    $0xc,%esp
  801d1b:	57                   	push   %edi
  801d1c:	e8 77 05 00 00       	call   802298 <pageref>
  801d21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d24:	89 34 24             	mov    %esi,(%esp)
  801d27:	e8 6c 05 00 00       	call   802298 <pageref>
		nn = thisenv->env_runs;
  801d2c:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801d32:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d35:	83 c4 10             	add    $0x10,%esp
  801d38:	39 cb                	cmp    %ecx,%ebx
  801d3a:	74 1b                	je     801d57 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d3c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d3f:	75 cf                	jne    801d10 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d41:	8b 42 58             	mov    0x58(%edx),%eax
  801d44:	6a 01                	push   $0x1
  801d46:	50                   	push   %eax
  801d47:	53                   	push   %ebx
  801d48:	68 4d 2a 80 00       	push   $0x802a4d
  801d4d:	e8 7c e4 ff ff       	call   8001ce <cprintf>
  801d52:	83 c4 10             	add    $0x10,%esp
  801d55:	eb b9                	jmp    801d10 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d57:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d5a:	0f 94 c0             	sete   %al
  801d5d:	0f b6 c0             	movzbl %al,%eax
}
  801d60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d63:	5b                   	pop    %ebx
  801d64:	5e                   	pop    %esi
  801d65:	5f                   	pop    %edi
  801d66:	5d                   	pop    %ebp
  801d67:	c3                   	ret    

00801d68 <devpipe_write>:
{
  801d68:	f3 0f 1e fb          	endbr32 
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
  801d6f:	57                   	push   %edi
  801d70:	56                   	push   %esi
  801d71:	53                   	push   %ebx
  801d72:	83 ec 28             	sub    $0x28,%esp
  801d75:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d78:	56                   	push   %esi
  801d79:	e8 c1 f0 ff ff       	call   800e3f <fd2data>
  801d7e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d80:	83 c4 10             	add    $0x10,%esp
  801d83:	bf 00 00 00 00       	mov    $0x0,%edi
  801d88:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d8b:	74 4f                	je     801ddc <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d8d:	8b 43 04             	mov    0x4(%ebx),%eax
  801d90:	8b 0b                	mov    (%ebx),%ecx
  801d92:	8d 51 20             	lea    0x20(%ecx),%edx
  801d95:	39 d0                	cmp    %edx,%eax
  801d97:	72 14                	jb     801dad <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801d99:	89 da                	mov    %ebx,%edx
  801d9b:	89 f0                	mov    %esi,%eax
  801d9d:	e8 61 ff ff ff       	call   801d03 <_pipeisclosed>
  801da2:	85 c0                	test   %eax,%eax
  801da4:	75 3b                	jne    801de1 <devpipe_write+0x79>
			sys_yield();
  801da6:	e8 4c ee ff ff       	call   800bf7 <sys_yield>
  801dab:	eb e0                	jmp    801d8d <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801dad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801db0:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801db4:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801db7:	89 c2                	mov    %eax,%edx
  801db9:	c1 fa 1f             	sar    $0x1f,%edx
  801dbc:	89 d1                	mov    %edx,%ecx
  801dbe:	c1 e9 1b             	shr    $0x1b,%ecx
  801dc1:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801dc4:	83 e2 1f             	and    $0x1f,%edx
  801dc7:	29 ca                	sub    %ecx,%edx
  801dc9:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801dcd:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801dd1:	83 c0 01             	add    $0x1,%eax
  801dd4:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801dd7:	83 c7 01             	add    $0x1,%edi
  801dda:	eb ac                	jmp    801d88 <devpipe_write+0x20>
	return i;
  801ddc:	8b 45 10             	mov    0x10(%ebp),%eax
  801ddf:	eb 05                	jmp    801de6 <devpipe_write+0x7e>
				return 0;
  801de1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801de9:	5b                   	pop    %ebx
  801dea:	5e                   	pop    %esi
  801deb:	5f                   	pop    %edi
  801dec:	5d                   	pop    %ebp
  801ded:	c3                   	ret    

00801dee <devpipe_read>:
{
  801dee:	f3 0f 1e fb          	endbr32 
  801df2:	55                   	push   %ebp
  801df3:	89 e5                	mov    %esp,%ebp
  801df5:	57                   	push   %edi
  801df6:	56                   	push   %esi
  801df7:	53                   	push   %ebx
  801df8:	83 ec 18             	sub    $0x18,%esp
  801dfb:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801dfe:	57                   	push   %edi
  801dff:	e8 3b f0 ff ff       	call   800e3f <fd2data>
  801e04:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e06:	83 c4 10             	add    $0x10,%esp
  801e09:	be 00 00 00 00       	mov    $0x0,%esi
  801e0e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e11:	75 14                	jne    801e27 <devpipe_read+0x39>
	return i;
  801e13:	8b 45 10             	mov    0x10(%ebp),%eax
  801e16:	eb 02                	jmp    801e1a <devpipe_read+0x2c>
				return i;
  801e18:	89 f0                	mov    %esi,%eax
}
  801e1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e1d:	5b                   	pop    %ebx
  801e1e:	5e                   	pop    %esi
  801e1f:	5f                   	pop    %edi
  801e20:	5d                   	pop    %ebp
  801e21:	c3                   	ret    
			sys_yield();
  801e22:	e8 d0 ed ff ff       	call   800bf7 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e27:	8b 03                	mov    (%ebx),%eax
  801e29:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e2c:	75 18                	jne    801e46 <devpipe_read+0x58>
			if (i > 0)
  801e2e:	85 f6                	test   %esi,%esi
  801e30:	75 e6                	jne    801e18 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801e32:	89 da                	mov    %ebx,%edx
  801e34:	89 f8                	mov    %edi,%eax
  801e36:	e8 c8 fe ff ff       	call   801d03 <_pipeisclosed>
  801e3b:	85 c0                	test   %eax,%eax
  801e3d:	74 e3                	je     801e22 <devpipe_read+0x34>
				return 0;
  801e3f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e44:	eb d4                	jmp    801e1a <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e46:	99                   	cltd   
  801e47:	c1 ea 1b             	shr    $0x1b,%edx
  801e4a:	01 d0                	add    %edx,%eax
  801e4c:	83 e0 1f             	and    $0x1f,%eax
  801e4f:	29 d0                	sub    %edx,%eax
  801e51:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e59:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e5c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e5f:	83 c6 01             	add    $0x1,%esi
  801e62:	eb aa                	jmp    801e0e <devpipe_read+0x20>

00801e64 <pipe>:
{
  801e64:	f3 0f 1e fb          	endbr32 
  801e68:	55                   	push   %ebp
  801e69:	89 e5                	mov    %esp,%ebp
  801e6b:	56                   	push   %esi
  801e6c:	53                   	push   %ebx
  801e6d:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e70:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e73:	50                   	push   %eax
  801e74:	e8 e1 ef ff ff       	call   800e5a <fd_alloc>
  801e79:	89 c3                	mov    %eax,%ebx
  801e7b:	83 c4 10             	add    $0x10,%esp
  801e7e:	85 c0                	test   %eax,%eax
  801e80:	0f 88 23 01 00 00    	js     801fa9 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e86:	83 ec 04             	sub    $0x4,%esp
  801e89:	68 07 04 00 00       	push   $0x407
  801e8e:	ff 75 f4             	pushl  -0xc(%ebp)
  801e91:	6a 00                	push   $0x0
  801e93:	e8 82 ed ff ff       	call   800c1a <sys_page_alloc>
  801e98:	89 c3                	mov    %eax,%ebx
  801e9a:	83 c4 10             	add    $0x10,%esp
  801e9d:	85 c0                	test   %eax,%eax
  801e9f:	0f 88 04 01 00 00    	js     801fa9 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801ea5:	83 ec 0c             	sub    $0xc,%esp
  801ea8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801eab:	50                   	push   %eax
  801eac:	e8 a9 ef ff ff       	call   800e5a <fd_alloc>
  801eb1:	89 c3                	mov    %eax,%ebx
  801eb3:	83 c4 10             	add    $0x10,%esp
  801eb6:	85 c0                	test   %eax,%eax
  801eb8:	0f 88 db 00 00 00    	js     801f99 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ebe:	83 ec 04             	sub    $0x4,%esp
  801ec1:	68 07 04 00 00       	push   $0x407
  801ec6:	ff 75 f0             	pushl  -0x10(%ebp)
  801ec9:	6a 00                	push   $0x0
  801ecb:	e8 4a ed ff ff       	call   800c1a <sys_page_alloc>
  801ed0:	89 c3                	mov    %eax,%ebx
  801ed2:	83 c4 10             	add    $0x10,%esp
  801ed5:	85 c0                	test   %eax,%eax
  801ed7:	0f 88 bc 00 00 00    	js     801f99 <pipe+0x135>
	va = fd2data(fd0);
  801edd:	83 ec 0c             	sub    $0xc,%esp
  801ee0:	ff 75 f4             	pushl  -0xc(%ebp)
  801ee3:	e8 57 ef ff ff       	call   800e3f <fd2data>
  801ee8:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eea:	83 c4 0c             	add    $0xc,%esp
  801eed:	68 07 04 00 00       	push   $0x407
  801ef2:	50                   	push   %eax
  801ef3:	6a 00                	push   $0x0
  801ef5:	e8 20 ed ff ff       	call   800c1a <sys_page_alloc>
  801efa:	89 c3                	mov    %eax,%ebx
  801efc:	83 c4 10             	add    $0x10,%esp
  801eff:	85 c0                	test   %eax,%eax
  801f01:	0f 88 82 00 00 00    	js     801f89 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f07:	83 ec 0c             	sub    $0xc,%esp
  801f0a:	ff 75 f0             	pushl  -0x10(%ebp)
  801f0d:	e8 2d ef ff ff       	call   800e3f <fd2data>
  801f12:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f19:	50                   	push   %eax
  801f1a:	6a 00                	push   $0x0
  801f1c:	56                   	push   %esi
  801f1d:	6a 00                	push   $0x0
  801f1f:	e8 3d ed ff ff       	call   800c61 <sys_page_map>
  801f24:	89 c3                	mov    %eax,%ebx
  801f26:	83 c4 20             	add    $0x20,%esp
  801f29:	85 c0                	test   %eax,%eax
  801f2b:	78 4e                	js     801f7b <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801f2d:	a1 20 30 80 00       	mov    0x803020,%eax
  801f32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f35:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f3a:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f41:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f44:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f49:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f50:	83 ec 0c             	sub    $0xc,%esp
  801f53:	ff 75 f4             	pushl  -0xc(%ebp)
  801f56:	e8 d0 ee ff ff       	call   800e2b <fd2num>
  801f5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f5e:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f60:	83 c4 04             	add    $0x4,%esp
  801f63:	ff 75 f0             	pushl  -0x10(%ebp)
  801f66:	e8 c0 ee ff ff       	call   800e2b <fd2num>
  801f6b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f6e:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f71:	83 c4 10             	add    $0x10,%esp
  801f74:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f79:	eb 2e                	jmp    801fa9 <pipe+0x145>
	sys_page_unmap(0, va);
  801f7b:	83 ec 08             	sub    $0x8,%esp
  801f7e:	56                   	push   %esi
  801f7f:	6a 00                	push   $0x0
  801f81:	e8 21 ed ff ff       	call   800ca7 <sys_page_unmap>
  801f86:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f89:	83 ec 08             	sub    $0x8,%esp
  801f8c:	ff 75 f0             	pushl  -0x10(%ebp)
  801f8f:	6a 00                	push   $0x0
  801f91:	e8 11 ed ff ff       	call   800ca7 <sys_page_unmap>
  801f96:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f99:	83 ec 08             	sub    $0x8,%esp
  801f9c:	ff 75 f4             	pushl  -0xc(%ebp)
  801f9f:	6a 00                	push   $0x0
  801fa1:	e8 01 ed ff ff       	call   800ca7 <sys_page_unmap>
  801fa6:	83 c4 10             	add    $0x10,%esp
}
  801fa9:	89 d8                	mov    %ebx,%eax
  801fab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fae:	5b                   	pop    %ebx
  801faf:	5e                   	pop    %esi
  801fb0:	5d                   	pop    %ebp
  801fb1:	c3                   	ret    

00801fb2 <pipeisclosed>:
{
  801fb2:	f3 0f 1e fb          	endbr32 
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
  801fb9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fbc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fbf:	50                   	push   %eax
  801fc0:	ff 75 08             	pushl  0x8(%ebp)
  801fc3:	e8 e8 ee ff ff       	call   800eb0 <fd_lookup>
  801fc8:	83 c4 10             	add    $0x10,%esp
  801fcb:	85 c0                	test   %eax,%eax
  801fcd:	78 18                	js     801fe7 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801fcf:	83 ec 0c             	sub    $0xc,%esp
  801fd2:	ff 75 f4             	pushl  -0xc(%ebp)
  801fd5:	e8 65 ee ff ff       	call   800e3f <fd2data>
  801fda:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801fdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdf:	e8 1f fd ff ff       	call   801d03 <_pipeisclosed>
  801fe4:	83 c4 10             	add    $0x10,%esp
}
  801fe7:	c9                   	leave  
  801fe8:	c3                   	ret    

00801fe9 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801fe9:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801fed:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff2:	c3                   	ret    

00801ff3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801ff3:	f3 0f 1e fb          	endbr32 
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
  801ffa:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801ffd:	68 65 2a 80 00       	push   $0x802a65
  802002:	ff 75 0c             	pushl  0xc(%ebp)
  802005:	e8 ce e7 ff ff       	call   8007d8 <strcpy>
	return 0;
}
  80200a:	b8 00 00 00 00       	mov    $0x0,%eax
  80200f:	c9                   	leave  
  802010:	c3                   	ret    

00802011 <devcons_write>:
{
  802011:	f3 0f 1e fb          	endbr32 
  802015:	55                   	push   %ebp
  802016:	89 e5                	mov    %esp,%ebp
  802018:	57                   	push   %edi
  802019:	56                   	push   %esi
  80201a:	53                   	push   %ebx
  80201b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802021:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802026:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80202c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80202f:	73 31                	jae    802062 <devcons_write+0x51>
		m = n - tot;
  802031:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802034:	29 f3                	sub    %esi,%ebx
  802036:	83 fb 7f             	cmp    $0x7f,%ebx
  802039:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80203e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802041:	83 ec 04             	sub    $0x4,%esp
  802044:	53                   	push   %ebx
  802045:	89 f0                	mov    %esi,%eax
  802047:	03 45 0c             	add    0xc(%ebp),%eax
  80204a:	50                   	push   %eax
  80204b:	57                   	push   %edi
  80204c:	e8 3d e9 ff ff       	call   80098e <memmove>
		sys_cputs(buf, m);
  802051:	83 c4 08             	add    $0x8,%esp
  802054:	53                   	push   %ebx
  802055:	57                   	push   %edi
  802056:	e8 ef ea ff ff       	call   800b4a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80205b:	01 de                	add    %ebx,%esi
  80205d:	83 c4 10             	add    $0x10,%esp
  802060:	eb ca                	jmp    80202c <devcons_write+0x1b>
}
  802062:	89 f0                	mov    %esi,%eax
  802064:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802067:	5b                   	pop    %ebx
  802068:	5e                   	pop    %esi
  802069:	5f                   	pop    %edi
  80206a:	5d                   	pop    %ebp
  80206b:	c3                   	ret    

0080206c <devcons_read>:
{
  80206c:	f3 0f 1e fb          	endbr32 
  802070:	55                   	push   %ebp
  802071:	89 e5                	mov    %esp,%ebp
  802073:	83 ec 08             	sub    $0x8,%esp
  802076:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80207b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80207f:	74 21                	je     8020a2 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802081:	e8 e6 ea ff ff       	call   800b6c <sys_cgetc>
  802086:	85 c0                	test   %eax,%eax
  802088:	75 07                	jne    802091 <devcons_read+0x25>
		sys_yield();
  80208a:	e8 68 eb ff ff       	call   800bf7 <sys_yield>
  80208f:	eb f0                	jmp    802081 <devcons_read+0x15>
	if (c < 0)
  802091:	78 0f                	js     8020a2 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  802093:	83 f8 04             	cmp    $0x4,%eax
  802096:	74 0c                	je     8020a4 <devcons_read+0x38>
	*(char*)vbuf = c;
  802098:	8b 55 0c             	mov    0xc(%ebp),%edx
  80209b:	88 02                	mov    %al,(%edx)
	return 1;
  80209d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020a2:	c9                   	leave  
  8020a3:	c3                   	ret    
		return 0;
  8020a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a9:	eb f7                	jmp    8020a2 <devcons_read+0x36>

008020ab <cputchar>:
{
  8020ab:	f3 0f 1e fb          	endbr32 
  8020af:	55                   	push   %ebp
  8020b0:	89 e5                	mov    %esp,%ebp
  8020b2:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b8:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020bb:	6a 01                	push   $0x1
  8020bd:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020c0:	50                   	push   %eax
  8020c1:	e8 84 ea ff ff       	call   800b4a <sys_cputs>
}
  8020c6:	83 c4 10             	add    $0x10,%esp
  8020c9:	c9                   	leave  
  8020ca:	c3                   	ret    

008020cb <getchar>:
{
  8020cb:	f3 0f 1e fb          	endbr32 
  8020cf:	55                   	push   %ebp
  8020d0:	89 e5                	mov    %esp,%ebp
  8020d2:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020d5:	6a 01                	push   $0x1
  8020d7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020da:	50                   	push   %eax
  8020db:	6a 00                	push   $0x0
  8020dd:	e8 51 f0 ff ff       	call   801133 <read>
	if (r < 0)
  8020e2:	83 c4 10             	add    $0x10,%esp
  8020e5:	85 c0                	test   %eax,%eax
  8020e7:	78 06                	js     8020ef <getchar+0x24>
	if (r < 1)
  8020e9:	74 06                	je     8020f1 <getchar+0x26>
	return c;
  8020eb:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020ef:	c9                   	leave  
  8020f0:	c3                   	ret    
		return -E_EOF;
  8020f1:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020f6:	eb f7                	jmp    8020ef <getchar+0x24>

008020f8 <iscons>:
{
  8020f8:	f3 0f 1e fb          	endbr32 
  8020fc:	55                   	push   %ebp
  8020fd:	89 e5                	mov    %esp,%ebp
  8020ff:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802102:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802105:	50                   	push   %eax
  802106:	ff 75 08             	pushl  0x8(%ebp)
  802109:	e8 a2 ed ff ff       	call   800eb0 <fd_lookup>
  80210e:	83 c4 10             	add    $0x10,%esp
  802111:	85 c0                	test   %eax,%eax
  802113:	78 11                	js     802126 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  802115:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802118:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80211e:	39 10                	cmp    %edx,(%eax)
  802120:	0f 94 c0             	sete   %al
  802123:	0f b6 c0             	movzbl %al,%eax
}
  802126:	c9                   	leave  
  802127:	c3                   	ret    

00802128 <opencons>:
{
  802128:	f3 0f 1e fb          	endbr32 
  80212c:	55                   	push   %ebp
  80212d:	89 e5                	mov    %esp,%ebp
  80212f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802132:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802135:	50                   	push   %eax
  802136:	e8 1f ed ff ff       	call   800e5a <fd_alloc>
  80213b:	83 c4 10             	add    $0x10,%esp
  80213e:	85 c0                	test   %eax,%eax
  802140:	78 3a                	js     80217c <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802142:	83 ec 04             	sub    $0x4,%esp
  802145:	68 07 04 00 00       	push   $0x407
  80214a:	ff 75 f4             	pushl  -0xc(%ebp)
  80214d:	6a 00                	push   $0x0
  80214f:	e8 c6 ea ff ff       	call   800c1a <sys_page_alloc>
  802154:	83 c4 10             	add    $0x10,%esp
  802157:	85 c0                	test   %eax,%eax
  802159:	78 21                	js     80217c <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80215b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215e:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802164:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802166:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802169:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802170:	83 ec 0c             	sub    $0xc,%esp
  802173:	50                   	push   %eax
  802174:	e8 b2 ec ff ff       	call   800e2b <fd2num>
  802179:	83 c4 10             	add    $0x10,%esp
}
  80217c:	c9                   	leave  
  80217d:	c3                   	ret    

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
  802198:	e8 49 ec ff ff       	call   800de6 <sys_ipc_recv>
  80219d:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  8021a0:	85 f6                	test   %esi,%esi
  8021a2:	74 0b                	je     8021af <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8021a4:	8b 15 04 40 80 00    	mov    0x804004,%edx
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
  8021b3:	8b 15 04 40 80 00    	mov    0x804004,%edx
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
  8021c2:	a1 04 40 80 00       	mov    0x804004,%eax
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
  8021d9:	e8 08 ec ff ff       	call   800de6 <sys_ipc_recv>
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
  802229:	e8 91 eb ff ff       	call   800dbf <sys_ipc_try_send>
  80222e:	83 c4 10             	add    $0x10,%esp
  802231:	85 c0                	test   %eax,%eax
  802233:	79 1e                	jns    802253 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  802235:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802238:	75 07                	jne    802241 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  80223a:	e8 b8 e9 ff ff       	call   800bf7 <sys_yield>
  80223f:	eb e2                	jmp    802223 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  802241:	50                   	push   %eax
  802242:	68 71 2a 80 00       	push   $0x802a71
  802247:	6a 59                	push   $0x59
  802249:	68 8c 2a 80 00       	push   $0x802a8c
  80224e:	e8 94 de ff ff       	call   8000e7 <_panic>
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
