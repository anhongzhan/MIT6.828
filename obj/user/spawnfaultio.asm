
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
  80003d:	a1 08 50 80 00       	mov    0x805008,%eax
  800042:	8b 40 48             	mov    0x48(%eax),%eax
  800045:	50                   	push   %eax
  800046:	68 c0 2a 80 00       	push   $0x802ac0
  80004b:	e8 7e 01 00 00       	call   8001ce <cprintf>
	if ((r = spawnl("faultio", "faultio", 0)) < 0)
  800050:	83 c4 0c             	add    $0xc,%esp
  800053:	6a 00                	push   $0x0
  800055:	68 de 2a 80 00       	push   $0x802ade
  80005a:	68 de 2a 80 00       	push   $0x802ade
  80005f:	e8 21 1c 00 00       	call   801c85 <spawnl>
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	85 c0                	test   %eax,%eax
  800069:	78 02                	js     80006d <umain+0x3a>
		panic("spawn(faultio) failed: %e", r);
}
  80006b:	c9                   	leave  
  80006c:	c3                   	ret    
		panic("spawn(faultio) failed: %e", r);
  80006d:	50                   	push   %eax
  80006e:	68 e6 2a 80 00       	push   $0x802ae6
  800073:	6a 09                	push   $0x9
  800075:	68 00 2b 80 00       	push   $0x802b00
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
  8000a0:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a5:	85 db                	test   %ebx,%ebx
  8000a7:	7e 07                	jle    8000b0 <libmain+0x31>
		binaryname = argv[0];
  8000a9:	8b 06                	mov    (%esi),%eax
  8000ab:	a3 00 40 80 00       	mov    %eax,0x804000

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
  8000d3:	e8 f6 0f 00 00       	call   8010ce <close_all>
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
  8000f3:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8000f9:	e8 d6 0a 00 00       	call   800bd4 <sys_getenvid>
  8000fe:	83 ec 0c             	sub    $0xc,%esp
  800101:	ff 75 0c             	pushl  0xc(%ebp)
  800104:	ff 75 08             	pushl  0x8(%ebp)
  800107:	56                   	push   %esi
  800108:	50                   	push   %eax
  800109:	68 20 2b 80 00       	push   $0x802b20
  80010e:	e8 bb 00 00 00       	call   8001ce <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800113:	83 c4 18             	add    $0x18,%esp
  800116:	53                   	push   %ebx
  800117:	ff 75 10             	pushl  0x10(%ebp)
  80011a:	e8 5a 00 00 00       	call   800179 <vcprintf>
	cprintf("\n");
  80011f:	c7 04 24 47 30 80 00 	movl   $0x803047,(%esp)
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
  800234:	e8 17 26 00 00       	call   802850 <__udivdi3>
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
  800272:	e8 e9 26 00 00       	call   802960 <__umoddi3>
  800277:	83 c4 14             	add    $0x14,%esp
  80027a:	0f be 80 43 2b 80 00 	movsbl 0x802b43(%eax),%eax
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
  800321:	3e ff 24 85 80 2c 80 	notrack jmp *0x802c80(,%eax,4)
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
  8003ee:	8b 14 85 e0 2d 80 00 	mov    0x802de0(,%eax,4),%edx
  8003f5:	85 d2                	test   %edx,%edx
  8003f7:	74 18                	je     800411 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8003f9:	52                   	push   %edx
  8003fa:	68 15 2f 80 00       	push   $0x802f15
  8003ff:	53                   	push   %ebx
  800400:	56                   	push   %esi
  800401:	e8 aa fe ff ff       	call   8002b0 <printfmt>
  800406:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800409:	89 7d 14             	mov    %edi,0x14(%ebp)
  80040c:	e9 66 02 00 00       	jmp    800677 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800411:	50                   	push   %eax
  800412:	68 5b 2b 80 00       	push   $0x802b5b
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
  800439:	b8 54 2b 80 00       	mov    $0x802b54,%eax
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
  800bc3:	68 3f 2e 80 00       	push   $0x802e3f
  800bc8:	6a 23                	push   $0x23
  800bca:	68 5c 2e 80 00       	push   $0x802e5c
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
  800c50:	68 3f 2e 80 00       	push   $0x802e3f
  800c55:	6a 23                	push   $0x23
  800c57:	68 5c 2e 80 00       	push   $0x802e5c
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
  800c96:	68 3f 2e 80 00       	push   $0x802e3f
  800c9b:	6a 23                	push   $0x23
  800c9d:	68 5c 2e 80 00       	push   $0x802e5c
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
  800cdc:	68 3f 2e 80 00       	push   $0x802e3f
  800ce1:	6a 23                	push   $0x23
  800ce3:	68 5c 2e 80 00       	push   $0x802e5c
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
  800d22:	68 3f 2e 80 00       	push   $0x802e3f
  800d27:	6a 23                	push   $0x23
  800d29:	68 5c 2e 80 00       	push   $0x802e5c
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
  800d68:	68 3f 2e 80 00       	push   $0x802e3f
  800d6d:	6a 23                	push   $0x23
  800d6f:	68 5c 2e 80 00       	push   $0x802e5c
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
  800dae:	68 3f 2e 80 00       	push   $0x802e3f
  800db3:	6a 23                	push   $0x23
  800db5:	68 5c 2e 80 00       	push   $0x802e5c
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
  800e1a:	68 3f 2e 80 00       	push   $0x802e3f
  800e1f:	6a 23                	push   $0x23
  800e21:	68 5c 2e 80 00       	push   $0x802e5c
  800e26:	e8 bc f2 ff ff       	call   8000e7 <_panic>

00800e2b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e2b:	f3 0f 1e fb          	endbr32 
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	57                   	push   %edi
  800e33:	56                   	push   %esi
  800e34:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e35:	ba 00 00 00 00       	mov    $0x0,%edx
  800e3a:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e3f:	89 d1                	mov    %edx,%ecx
  800e41:	89 d3                	mov    %edx,%ebx
  800e43:	89 d7                	mov    %edx,%edi
  800e45:	89 d6                	mov    %edx,%esi
  800e47:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e49:	5b                   	pop    %ebx
  800e4a:	5e                   	pop    %esi
  800e4b:	5f                   	pop    %edi
  800e4c:	5d                   	pop    %ebp
  800e4d:	c3                   	ret    

00800e4e <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  800e4e:	f3 0f 1e fb          	endbr32 
  800e52:	55                   	push   %ebp
  800e53:	89 e5                	mov    %esp,%ebp
  800e55:	57                   	push   %edi
  800e56:	56                   	push   %esi
  800e57:	53                   	push   %ebx
  800e58:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e5b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e60:	8b 55 08             	mov    0x8(%ebp),%edx
  800e63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e66:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e6b:	89 df                	mov    %ebx,%edi
  800e6d:	89 de                	mov    %ebx,%esi
  800e6f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e71:	85 c0                	test   %eax,%eax
  800e73:	7f 08                	jg     800e7d <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  800e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e78:	5b                   	pop    %ebx
  800e79:	5e                   	pop    %esi
  800e7a:	5f                   	pop    %edi
  800e7b:	5d                   	pop    %ebp
  800e7c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7d:	83 ec 0c             	sub    $0xc,%esp
  800e80:	50                   	push   %eax
  800e81:	6a 0f                	push   $0xf
  800e83:	68 3f 2e 80 00       	push   $0x802e3f
  800e88:	6a 23                	push   $0x23
  800e8a:	68 5c 2e 80 00       	push   $0x802e5c
  800e8f:	e8 53 f2 ff ff       	call   8000e7 <_panic>

00800e94 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  800e94:	f3 0f 1e fb          	endbr32 
  800e98:	55                   	push   %ebp
  800e99:	89 e5                	mov    %esp,%ebp
  800e9b:	57                   	push   %edi
  800e9c:	56                   	push   %esi
  800e9d:	53                   	push   %ebx
  800e9e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eac:	b8 10 00 00 00       	mov    $0x10,%eax
  800eb1:	89 df                	mov    %ebx,%edi
  800eb3:	89 de                	mov    %ebx,%esi
  800eb5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb7:	85 c0                	test   %eax,%eax
  800eb9:	7f 08                	jg     800ec3 <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  800ebb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ebe:	5b                   	pop    %ebx
  800ebf:	5e                   	pop    %esi
  800ec0:	5f                   	pop    %edi
  800ec1:	5d                   	pop    %ebp
  800ec2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec3:	83 ec 0c             	sub    $0xc,%esp
  800ec6:	50                   	push   %eax
  800ec7:	6a 10                	push   $0x10
  800ec9:	68 3f 2e 80 00       	push   $0x802e3f
  800ece:	6a 23                	push   $0x23
  800ed0:	68 5c 2e 80 00       	push   $0x802e5c
  800ed5:	e8 0d f2 ff ff       	call   8000e7 <_panic>

00800eda <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800eda:	f3 0f 1e fb          	endbr32 
  800ede:	55                   	push   %ebp
  800edf:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	05 00 00 00 30       	add    $0x30000000,%eax
  800ee9:	c1 e8 0c             	shr    $0xc,%eax
}
  800eec:	5d                   	pop    %ebp
  800eed:	c3                   	ret    

00800eee <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800eee:	f3 0f 1e fb          	endbr32 
  800ef2:	55                   	push   %ebp
  800ef3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef8:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800efd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f02:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f07:	5d                   	pop    %ebp
  800f08:	c3                   	ret    

00800f09 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f09:	f3 0f 1e fb          	endbr32 
  800f0d:	55                   	push   %ebp
  800f0e:	89 e5                	mov    %esp,%ebp
  800f10:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f15:	89 c2                	mov    %eax,%edx
  800f17:	c1 ea 16             	shr    $0x16,%edx
  800f1a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f21:	f6 c2 01             	test   $0x1,%dl
  800f24:	74 2d                	je     800f53 <fd_alloc+0x4a>
  800f26:	89 c2                	mov    %eax,%edx
  800f28:	c1 ea 0c             	shr    $0xc,%edx
  800f2b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f32:	f6 c2 01             	test   $0x1,%dl
  800f35:	74 1c                	je     800f53 <fd_alloc+0x4a>
  800f37:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f3c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f41:	75 d2                	jne    800f15 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800f4c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f51:	eb 0a                	jmp    800f5d <fd_alloc+0x54>
			*fd_store = fd;
  800f53:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f56:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f5d:	5d                   	pop    %ebp
  800f5e:	c3                   	ret    

00800f5f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f5f:	f3 0f 1e fb          	endbr32 
  800f63:	55                   	push   %ebp
  800f64:	89 e5                	mov    %esp,%ebp
  800f66:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f69:	83 f8 1f             	cmp    $0x1f,%eax
  800f6c:	77 30                	ja     800f9e <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f6e:	c1 e0 0c             	shl    $0xc,%eax
  800f71:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f76:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800f7c:	f6 c2 01             	test   $0x1,%dl
  800f7f:	74 24                	je     800fa5 <fd_lookup+0x46>
  800f81:	89 c2                	mov    %eax,%edx
  800f83:	c1 ea 0c             	shr    $0xc,%edx
  800f86:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f8d:	f6 c2 01             	test   $0x1,%dl
  800f90:	74 1a                	je     800fac <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f92:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f95:	89 02                	mov    %eax,(%edx)
	return 0;
  800f97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f9c:	5d                   	pop    %ebp
  800f9d:	c3                   	ret    
		return -E_INVAL;
  800f9e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fa3:	eb f7                	jmp    800f9c <fd_lookup+0x3d>
		return -E_INVAL;
  800fa5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800faa:	eb f0                	jmp    800f9c <fd_lookup+0x3d>
  800fac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fb1:	eb e9                	jmp    800f9c <fd_lookup+0x3d>

00800fb3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800fb3:	f3 0f 1e fb          	endbr32 
  800fb7:	55                   	push   %ebp
  800fb8:	89 e5                	mov    %esp,%ebp
  800fba:	83 ec 08             	sub    $0x8,%esp
  800fbd:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800fc0:	ba 00 00 00 00       	mov    $0x0,%edx
  800fc5:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800fca:	39 08                	cmp    %ecx,(%eax)
  800fcc:	74 38                	je     801006 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  800fce:	83 c2 01             	add    $0x1,%edx
  800fd1:	8b 04 95 e8 2e 80 00 	mov    0x802ee8(,%edx,4),%eax
  800fd8:	85 c0                	test   %eax,%eax
  800fda:	75 ee                	jne    800fca <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800fdc:	a1 08 50 80 00       	mov    0x805008,%eax
  800fe1:	8b 40 48             	mov    0x48(%eax),%eax
  800fe4:	83 ec 04             	sub    $0x4,%esp
  800fe7:	51                   	push   %ecx
  800fe8:	50                   	push   %eax
  800fe9:	68 6c 2e 80 00       	push   $0x802e6c
  800fee:	e8 db f1 ff ff       	call   8001ce <cprintf>
	*dev = 0;
  800ff3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800ffc:	83 c4 10             	add    $0x10,%esp
  800fff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801004:	c9                   	leave  
  801005:	c3                   	ret    
			*dev = devtab[i];
  801006:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801009:	89 01                	mov    %eax,(%ecx)
			return 0;
  80100b:	b8 00 00 00 00       	mov    $0x0,%eax
  801010:	eb f2                	jmp    801004 <dev_lookup+0x51>

00801012 <fd_close>:
{
  801012:	f3 0f 1e fb          	endbr32 
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
  801019:	57                   	push   %edi
  80101a:	56                   	push   %esi
  80101b:	53                   	push   %ebx
  80101c:	83 ec 24             	sub    $0x24,%esp
  80101f:	8b 75 08             	mov    0x8(%ebp),%esi
  801022:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801025:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801028:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801029:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80102f:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801032:	50                   	push   %eax
  801033:	e8 27 ff ff ff       	call   800f5f <fd_lookup>
  801038:	89 c3                	mov    %eax,%ebx
  80103a:	83 c4 10             	add    $0x10,%esp
  80103d:	85 c0                	test   %eax,%eax
  80103f:	78 05                	js     801046 <fd_close+0x34>
	    || fd != fd2)
  801041:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801044:	74 16                	je     80105c <fd_close+0x4a>
		return (must_exist ? r : 0);
  801046:	89 f8                	mov    %edi,%eax
  801048:	84 c0                	test   %al,%al
  80104a:	b8 00 00 00 00       	mov    $0x0,%eax
  80104f:	0f 44 d8             	cmove  %eax,%ebx
}
  801052:	89 d8                	mov    %ebx,%eax
  801054:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801057:	5b                   	pop    %ebx
  801058:	5e                   	pop    %esi
  801059:	5f                   	pop    %edi
  80105a:	5d                   	pop    %ebp
  80105b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80105c:	83 ec 08             	sub    $0x8,%esp
  80105f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801062:	50                   	push   %eax
  801063:	ff 36                	pushl  (%esi)
  801065:	e8 49 ff ff ff       	call   800fb3 <dev_lookup>
  80106a:	89 c3                	mov    %eax,%ebx
  80106c:	83 c4 10             	add    $0x10,%esp
  80106f:	85 c0                	test   %eax,%eax
  801071:	78 1a                	js     80108d <fd_close+0x7b>
		if (dev->dev_close)
  801073:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801076:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801079:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80107e:	85 c0                	test   %eax,%eax
  801080:	74 0b                	je     80108d <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801082:	83 ec 0c             	sub    $0xc,%esp
  801085:	56                   	push   %esi
  801086:	ff d0                	call   *%eax
  801088:	89 c3                	mov    %eax,%ebx
  80108a:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80108d:	83 ec 08             	sub    $0x8,%esp
  801090:	56                   	push   %esi
  801091:	6a 00                	push   $0x0
  801093:	e8 0f fc ff ff       	call   800ca7 <sys_page_unmap>
	return r;
  801098:	83 c4 10             	add    $0x10,%esp
  80109b:	eb b5                	jmp    801052 <fd_close+0x40>

0080109d <close>:

int
close(int fdnum)
{
  80109d:	f3 0f 1e fb          	endbr32 
  8010a1:	55                   	push   %ebp
  8010a2:	89 e5                	mov    %esp,%ebp
  8010a4:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010aa:	50                   	push   %eax
  8010ab:	ff 75 08             	pushl  0x8(%ebp)
  8010ae:	e8 ac fe ff ff       	call   800f5f <fd_lookup>
  8010b3:	83 c4 10             	add    $0x10,%esp
  8010b6:	85 c0                	test   %eax,%eax
  8010b8:	79 02                	jns    8010bc <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8010ba:	c9                   	leave  
  8010bb:	c3                   	ret    
		return fd_close(fd, 1);
  8010bc:	83 ec 08             	sub    $0x8,%esp
  8010bf:	6a 01                	push   $0x1
  8010c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8010c4:	e8 49 ff ff ff       	call   801012 <fd_close>
  8010c9:	83 c4 10             	add    $0x10,%esp
  8010cc:	eb ec                	jmp    8010ba <close+0x1d>

008010ce <close_all>:

void
close_all(void)
{
  8010ce:	f3 0f 1e fb          	endbr32 
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	53                   	push   %ebx
  8010d6:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8010d9:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8010de:	83 ec 0c             	sub    $0xc,%esp
  8010e1:	53                   	push   %ebx
  8010e2:	e8 b6 ff ff ff       	call   80109d <close>
	for (i = 0; i < MAXFD; i++)
  8010e7:	83 c3 01             	add    $0x1,%ebx
  8010ea:	83 c4 10             	add    $0x10,%esp
  8010ed:	83 fb 20             	cmp    $0x20,%ebx
  8010f0:	75 ec                	jne    8010de <close_all+0x10>
}
  8010f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010f5:	c9                   	leave  
  8010f6:	c3                   	ret    

008010f7 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8010f7:	f3 0f 1e fb          	endbr32 
  8010fb:	55                   	push   %ebp
  8010fc:	89 e5                	mov    %esp,%ebp
  8010fe:	57                   	push   %edi
  8010ff:	56                   	push   %esi
  801100:	53                   	push   %ebx
  801101:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801104:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801107:	50                   	push   %eax
  801108:	ff 75 08             	pushl  0x8(%ebp)
  80110b:	e8 4f fe ff ff       	call   800f5f <fd_lookup>
  801110:	89 c3                	mov    %eax,%ebx
  801112:	83 c4 10             	add    $0x10,%esp
  801115:	85 c0                	test   %eax,%eax
  801117:	0f 88 81 00 00 00    	js     80119e <dup+0xa7>
		return r;
	close(newfdnum);
  80111d:	83 ec 0c             	sub    $0xc,%esp
  801120:	ff 75 0c             	pushl  0xc(%ebp)
  801123:	e8 75 ff ff ff       	call   80109d <close>

	newfd = INDEX2FD(newfdnum);
  801128:	8b 75 0c             	mov    0xc(%ebp),%esi
  80112b:	c1 e6 0c             	shl    $0xc,%esi
  80112e:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801134:	83 c4 04             	add    $0x4,%esp
  801137:	ff 75 e4             	pushl  -0x1c(%ebp)
  80113a:	e8 af fd ff ff       	call   800eee <fd2data>
  80113f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801141:	89 34 24             	mov    %esi,(%esp)
  801144:	e8 a5 fd ff ff       	call   800eee <fd2data>
  801149:	83 c4 10             	add    $0x10,%esp
  80114c:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80114e:	89 d8                	mov    %ebx,%eax
  801150:	c1 e8 16             	shr    $0x16,%eax
  801153:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80115a:	a8 01                	test   $0x1,%al
  80115c:	74 11                	je     80116f <dup+0x78>
  80115e:	89 d8                	mov    %ebx,%eax
  801160:	c1 e8 0c             	shr    $0xc,%eax
  801163:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80116a:	f6 c2 01             	test   $0x1,%dl
  80116d:	75 39                	jne    8011a8 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80116f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801172:	89 d0                	mov    %edx,%eax
  801174:	c1 e8 0c             	shr    $0xc,%eax
  801177:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80117e:	83 ec 0c             	sub    $0xc,%esp
  801181:	25 07 0e 00 00       	and    $0xe07,%eax
  801186:	50                   	push   %eax
  801187:	56                   	push   %esi
  801188:	6a 00                	push   $0x0
  80118a:	52                   	push   %edx
  80118b:	6a 00                	push   $0x0
  80118d:	e8 cf fa ff ff       	call   800c61 <sys_page_map>
  801192:	89 c3                	mov    %eax,%ebx
  801194:	83 c4 20             	add    $0x20,%esp
  801197:	85 c0                	test   %eax,%eax
  801199:	78 31                	js     8011cc <dup+0xd5>
		goto err;

	return newfdnum;
  80119b:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80119e:	89 d8                	mov    %ebx,%eax
  8011a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011a3:	5b                   	pop    %ebx
  8011a4:	5e                   	pop    %esi
  8011a5:	5f                   	pop    %edi
  8011a6:	5d                   	pop    %ebp
  8011a7:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8011a8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011af:	83 ec 0c             	sub    $0xc,%esp
  8011b2:	25 07 0e 00 00       	and    $0xe07,%eax
  8011b7:	50                   	push   %eax
  8011b8:	57                   	push   %edi
  8011b9:	6a 00                	push   $0x0
  8011bb:	53                   	push   %ebx
  8011bc:	6a 00                	push   $0x0
  8011be:	e8 9e fa ff ff       	call   800c61 <sys_page_map>
  8011c3:	89 c3                	mov    %eax,%ebx
  8011c5:	83 c4 20             	add    $0x20,%esp
  8011c8:	85 c0                	test   %eax,%eax
  8011ca:	79 a3                	jns    80116f <dup+0x78>
	sys_page_unmap(0, newfd);
  8011cc:	83 ec 08             	sub    $0x8,%esp
  8011cf:	56                   	push   %esi
  8011d0:	6a 00                	push   $0x0
  8011d2:	e8 d0 fa ff ff       	call   800ca7 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8011d7:	83 c4 08             	add    $0x8,%esp
  8011da:	57                   	push   %edi
  8011db:	6a 00                	push   $0x0
  8011dd:	e8 c5 fa ff ff       	call   800ca7 <sys_page_unmap>
	return r;
  8011e2:	83 c4 10             	add    $0x10,%esp
  8011e5:	eb b7                	jmp    80119e <dup+0xa7>

008011e7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8011e7:	f3 0f 1e fb          	endbr32 
  8011eb:	55                   	push   %ebp
  8011ec:	89 e5                	mov    %esp,%ebp
  8011ee:	53                   	push   %ebx
  8011ef:	83 ec 1c             	sub    $0x1c,%esp
  8011f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011f5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011f8:	50                   	push   %eax
  8011f9:	53                   	push   %ebx
  8011fa:	e8 60 fd ff ff       	call   800f5f <fd_lookup>
  8011ff:	83 c4 10             	add    $0x10,%esp
  801202:	85 c0                	test   %eax,%eax
  801204:	78 3f                	js     801245 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801206:	83 ec 08             	sub    $0x8,%esp
  801209:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80120c:	50                   	push   %eax
  80120d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801210:	ff 30                	pushl  (%eax)
  801212:	e8 9c fd ff ff       	call   800fb3 <dev_lookup>
  801217:	83 c4 10             	add    $0x10,%esp
  80121a:	85 c0                	test   %eax,%eax
  80121c:	78 27                	js     801245 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80121e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801221:	8b 42 08             	mov    0x8(%edx),%eax
  801224:	83 e0 03             	and    $0x3,%eax
  801227:	83 f8 01             	cmp    $0x1,%eax
  80122a:	74 1e                	je     80124a <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80122c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80122f:	8b 40 08             	mov    0x8(%eax),%eax
  801232:	85 c0                	test   %eax,%eax
  801234:	74 35                	je     80126b <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801236:	83 ec 04             	sub    $0x4,%esp
  801239:	ff 75 10             	pushl  0x10(%ebp)
  80123c:	ff 75 0c             	pushl  0xc(%ebp)
  80123f:	52                   	push   %edx
  801240:	ff d0                	call   *%eax
  801242:	83 c4 10             	add    $0x10,%esp
}
  801245:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801248:	c9                   	leave  
  801249:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80124a:	a1 08 50 80 00       	mov    0x805008,%eax
  80124f:	8b 40 48             	mov    0x48(%eax),%eax
  801252:	83 ec 04             	sub    $0x4,%esp
  801255:	53                   	push   %ebx
  801256:	50                   	push   %eax
  801257:	68 ad 2e 80 00       	push   $0x802ead
  80125c:	e8 6d ef ff ff       	call   8001ce <cprintf>
		return -E_INVAL;
  801261:	83 c4 10             	add    $0x10,%esp
  801264:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801269:	eb da                	jmp    801245 <read+0x5e>
		return -E_NOT_SUPP;
  80126b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801270:	eb d3                	jmp    801245 <read+0x5e>

00801272 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801272:	f3 0f 1e fb          	endbr32 
  801276:	55                   	push   %ebp
  801277:	89 e5                	mov    %esp,%ebp
  801279:	57                   	push   %edi
  80127a:	56                   	push   %esi
  80127b:	53                   	push   %ebx
  80127c:	83 ec 0c             	sub    $0xc,%esp
  80127f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801282:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801285:	bb 00 00 00 00       	mov    $0x0,%ebx
  80128a:	eb 02                	jmp    80128e <readn+0x1c>
  80128c:	01 c3                	add    %eax,%ebx
  80128e:	39 f3                	cmp    %esi,%ebx
  801290:	73 21                	jae    8012b3 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801292:	83 ec 04             	sub    $0x4,%esp
  801295:	89 f0                	mov    %esi,%eax
  801297:	29 d8                	sub    %ebx,%eax
  801299:	50                   	push   %eax
  80129a:	89 d8                	mov    %ebx,%eax
  80129c:	03 45 0c             	add    0xc(%ebp),%eax
  80129f:	50                   	push   %eax
  8012a0:	57                   	push   %edi
  8012a1:	e8 41 ff ff ff       	call   8011e7 <read>
		if (m < 0)
  8012a6:	83 c4 10             	add    $0x10,%esp
  8012a9:	85 c0                	test   %eax,%eax
  8012ab:	78 04                	js     8012b1 <readn+0x3f>
			return m;
		if (m == 0)
  8012ad:	75 dd                	jne    80128c <readn+0x1a>
  8012af:	eb 02                	jmp    8012b3 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012b1:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8012b3:	89 d8                	mov    %ebx,%eax
  8012b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012b8:	5b                   	pop    %ebx
  8012b9:	5e                   	pop    %esi
  8012ba:	5f                   	pop    %edi
  8012bb:	5d                   	pop    %ebp
  8012bc:	c3                   	ret    

008012bd <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8012bd:	f3 0f 1e fb          	endbr32 
  8012c1:	55                   	push   %ebp
  8012c2:	89 e5                	mov    %esp,%ebp
  8012c4:	53                   	push   %ebx
  8012c5:	83 ec 1c             	sub    $0x1c,%esp
  8012c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012cb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012ce:	50                   	push   %eax
  8012cf:	53                   	push   %ebx
  8012d0:	e8 8a fc ff ff       	call   800f5f <fd_lookup>
  8012d5:	83 c4 10             	add    $0x10,%esp
  8012d8:	85 c0                	test   %eax,%eax
  8012da:	78 3a                	js     801316 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012dc:	83 ec 08             	sub    $0x8,%esp
  8012df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012e2:	50                   	push   %eax
  8012e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012e6:	ff 30                	pushl  (%eax)
  8012e8:	e8 c6 fc ff ff       	call   800fb3 <dev_lookup>
  8012ed:	83 c4 10             	add    $0x10,%esp
  8012f0:	85 c0                	test   %eax,%eax
  8012f2:	78 22                	js     801316 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012f7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012fb:	74 1e                	je     80131b <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8012fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801300:	8b 52 0c             	mov    0xc(%edx),%edx
  801303:	85 d2                	test   %edx,%edx
  801305:	74 35                	je     80133c <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801307:	83 ec 04             	sub    $0x4,%esp
  80130a:	ff 75 10             	pushl  0x10(%ebp)
  80130d:	ff 75 0c             	pushl  0xc(%ebp)
  801310:	50                   	push   %eax
  801311:	ff d2                	call   *%edx
  801313:	83 c4 10             	add    $0x10,%esp
}
  801316:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801319:	c9                   	leave  
  80131a:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80131b:	a1 08 50 80 00       	mov    0x805008,%eax
  801320:	8b 40 48             	mov    0x48(%eax),%eax
  801323:	83 ec 04             	sub    $0x4,%esp
  801326:	53                   	push   %ebx
  801327:	50                   	push   %eax
  801328:	68 c9 2e 80 00       	push   $0x802ec9
  80132d:	e8 9c ee ff ff       	call   8001ce <cprintf>
		return -E_INVAL;
  801332:	83 c4 10             	add    $0x10,%esp
  801335:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80133a:	eb da                	jmp    801316 <write+0x59>
		return -E_NOT_SUPP;
  80133c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801341:	eb d3                	jmp    801316 <write+0x59>

00801343 <seek>:

int
seek(int fdnum, off_t offset)
{
  801343:	f3 0f 1e fb          	endbr32 
  801347:	55                   	push   %ebp
  801348:	89 e5                	mov    %esp,%ebp
  80134a:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80134d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801350:	50                   	push   %eax
  801351:	ff 75 08             	pushl  0x8(%ebp)
  801354:	e8 06 fc ff ff       	call   800f5f <fd_lookup>
  801359:	83 c4 10             	add    $0x10,%esp
  80135c:	85 c0                	test   %eax,%eax
  80135e:	78 0e                	js     80136e <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801360:	8b 55 0c             	mov    0xc(%ebp),%edx
  801363:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801366:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801369:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80136e:	c9                   	leave  
  80136f:	c3                   	ret    

00801370 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801370:	f3 0f 1e fb          	endbr32 
  801374:	55                   	push   %ebp
  801375:	89 e5                	mov    %esp,%ebp
  801377:	53                   	push   %ebx
  801378:	83 ec 1c             	sub    $0x1c,%esp
  80137b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80137e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801381:	50                   	push   %eax
  801382:	53                   	push   %ebx
  801383:	e8 d7 fb ff ff       	call   800f5f <fd_lookup>
  801388:	83 c4 10             	add    $0x10,%esp
  80138b:	85 c0                	test   %eax,%eax
  80138d:	78 37                	js     8013c6 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80138f:	83 ec 08             	sub    $0x8,%esp
  801392:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801395:	50                   	push   %eax
  801396:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801399:	ff 30                	pushl  (%eax)
  80139b:	e8 13 fc ff ff       	call   800fb3 <dev_lookup>
  8013a0:	83 c4 10             	add    $0x10,%esp
  8013a3:	85 c0                	test   %eax,%eax
  8013a5:	78 1f                	js     8013c6 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013aa:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013ae:	74 1b                	je     8013cb <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8013b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b3:	8b 52 18             	mov    0x18(%edx),%edx
  8013b6:	85 d2                	test   %edx,%edx
  8013b8:	74 32                	je     8013ec <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8013ba:	83 ec 08             	sub    $0x8,%esp
  8013bd:	ff 75 0c             	pushl  0xc(%ebp)
  8013c0:	50                   	push   %eax
  8013c1:	ff d2                	call   *%edx
  8013c3:	83 c4 10             	add    $0x10,%esp
}
  8013c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013c9:	c9                   	leave  
  8013ca:	c3                   	ret    
			thisenv->env_id, fdnum);
  8013cb:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8013d0:	8b 40 48             	mov    0x48(%eax),%eax
  8013d3:	83 ec 04             	sub    $0x4,%esp
  8013d6:	53                   	push   %ebx
  8013d7:	50                   	push   %eax
  8013d8:	68 8c 2e 80 00       	push   $0x802e8c
  8013dd:	e8 ec ed ff ff       	call   8001ce <cprintf>
		return -E_INVAL;
  8013e2:	83 c4 10             	add    $0x10,%esp
  8013e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013ea:	eb da                	jmp    8013c6 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8013ec:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013f1:	eb d3                	jmp    8013c6 <ftruncate+0x56>

008013f3 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8013f3:	f3 0f 1e fb          	endbr32 
  8013f7:	55                   	push   %ebp
  8013f8:	89 e5                	mov    %esp,%ebp
  8013fa:	53                   	push   %ebx
  8013fb:	83 ec 1c             	sub    $0x1c,%esp
  8013fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801401:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801404:	50                   	push   %eax
  801405:	ff 75 08             	pushl  0x8(%ebp)
  801408:	e8 52 fb ff ff       	call   800f5f <fd_lookup>
  80140d:	83 c4 10             	add    $0x10,%esp
  801410:	85 c0                	test   %eax,%eax
  801412:	78 4b                	js     80145f <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801414:	83 ec 08             	sub    $0x8,%esp
  801417:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80141a:	50                   	push   %eax
  80141b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80141e:	ff 30                	pushl  (%eax)
  801420:	e8 8e fb ff ff       	call   800fb3 <dev_lookup>
  801425:	83 c4 10             	add    $0x10,%esp
  801428:	85 c0                	test   %eax,%eax
  80142a:	78 33                	js     80145f <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80142c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80142f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801433:	74 2f                	je     801464 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801435:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801438:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80143f:	00 00 00 
	stat->st_isdir = 0;
  801442:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801449:	00 00 00 
	stat->st_dev = dev;
  80144c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801452:	83 ec 08             	sub    $0x8,%esp
  801455:	53                   	push   %ebx
  801456:	ff 75 f0             	pushl  -0x10(%ebp)
  801459:	ff 50 14             	call   *0x14(%eax)
  80145c:	83 c4 10             	add    $0x10,%esp
}
  80145f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801462:	c9                   	leave  
  801463:	c3                   	ret    
		return -E_NOT_SUPP;
  801464:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801469:	eb f4                	jmp    80145f <fstat+0x6c>

0080146b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80146b:	f3 0f 1e fb          	endbr32 
  80146f:	55                   	push   %ebp
  801470:	89 e5                	mov    %esp,%ebp
  801472:	56                   	push   %esi
  801473:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801474:	83 ec 08             	sub    $0x8,%esp
  801477:	6a 00                	push   $0x0
  801479:	ff 75 08             	pushl  0x8(%ebp)
  80147c:	e8 fb 01 00 00       	call   80167c <open>
  801481:	89 c3                	mov    %eax,%ebx
  801483:	83 c4 10             	add    $0x10,%esp
  801486:	85 c0                	test   %eax,%eax
  801488:	78 1b                	js     8014a5 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80148a:	83 ec 08             	sub    $0x8,%esp
  80148d:	ff 75 0c             	pushl  0xc(%ebp)
  801490:	50                   	push   %eax
  801491:	e8 5d ff ff ff       	call   8013f3 <fstat>
  801496:	89 c6                	mov    %eax,%esi
	close(fd);
  801498:	89 1c 24             	mov    %ebx,(%esp)
  80149b:	e8 fd fb ff ff       	call   80109d <close>
	return r;
  8014a0:	83 c4 10             	add    $0x10,%esp
  8014a3:	89 f3                	mov    %esi,%ebx
}
  8014a5:	89 d8                	mov    %ebx,%eax
  8014a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014aa:	5b                   	pop    %ebx
  8014ab:	5e                   	pop    %esi
  8014ac:	5d                   	pop    %ebp
  8014ad:	c3                   	ret    

008014ae <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8014ae:	55                   	push   %ebp
  8014af:	89 e5                	mov    %esp,%ebp
  8014b1:	56                   	push   %esi
  8014b2:	53                   	push   %ebx
  8014b3:	89 c6                	mov    %eax,%esi
  8014b5:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8014b7:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8014be:	74 27                	je     8014e7 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8014c0:	6a 07                	push   $0x7
  8014c2:	68 00 60 80 00       	push   $0x806000
  8014c7:	56                   	push   %esi
  8014c8:	ff 35 00 50 80 00    	pushl  0x805000
  8014ce:	e8 9c 12 00 00       	call   80276f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8014d3:	83 c4 0c             	add    $0xc,%esp
  8014d6:	6a 00                	push   $0x0
  8014d8:	53                   	push   %ebx
  8014d9:	6a 00                	push   $0x0
  8014db:	e8 0a 12 00 00       	call   8026ea <ipc_recv>
}
  8014e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014e3:	5b                   	pop    %ebx
  8014e4:	5e                   	pop    %esi
  8014e5:	5d                   	pop    %ebp
  8014e6:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8014e7:	83 ec 0c             	sub    $0xc,%esp
  8014ea:	6a 01                	push   $0x1
  8014ec:	e8 d6 12 00 00       	call   8027c7 <ipc_find_env>
  8014f1:	a3 00 50 80 00       	mov    %eax,0x805000
  8014f6:	83 c4 10             	add    $0x10,%esp
  8014f9:	eb c5                	jmp    8014c0 <fsipc+0x12>

008014fb <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8014fb:	f3 0f 1e fb          	endbr32 
  8014ff:	55                   	push   %ebp
  801500:	89 e5                	mov    %esp,%ebp
  801502:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801505:	8b 45 08             	mov    0x8(%ebp),%eax
  801508:	8b 40 0c             	mov    0xc(%eax),%eax
  80150b:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801510:	8b 45 0c             	mov    0xc(%ebp),%eax
  801513:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801518:	ba 00 00 00 00       	mov    $0x0,%edx
  80151d:	b8 02 00 00 00       	mov    $0x2,%eax
  801522:	e8 87 ff ff ff       	call   8014ae <fsipc>
}
  801527:	c9                   	leave  
  801528:	c3                   	ret    

00801529 <devfile_flush>:
{
  801529:	f3 0f 1e fb          	endbr32 
  80152d:	55                   	push   %ebp
  80152e:	89 e5                	mov    %esp,%ebp
  801530:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	8b 40 0c             	mov    0xc(%eax),%eax
  801539:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  80153e:	ba 00 00 00 00       	mov    $0x0,%edx
  801543:	b8 06 00 00 00       	mov    $0x6,%eax
  801548:	e8 61 ff ff ff       	call   8014ae <fsipc>
}
  80154d:	c9                   	leave  
  80154e:	c3                   	ret    

0080154f <devfile_stat>:
{
  80154f:	f3 0f 1e fb          	endbr32 
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
  801556:	53                   	push   %ebx
  801557:	83 ec 04             	sub    $0x4,%esp
  80155a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	8b 40 0c             	mov    0xc(%eax),%eax
  801563:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801568:	ba 00 00 00 00       	mov    $0x0,%edx
  80156d:	b8 05 00 00 00       	mov    $0x5,%eax
  801572:	e8 37 ff ff ff       	call   8014ae <fsipc>
  801577:	85 c0                	test   %eax,%eax
  801579:	78 2c                	js     8015a7 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80157b:	83 ec 08             	sub    $0x8,%esp
  80157e:	68 00 60 80 00       	push   $0x806000
  801583:	53                   	push   %ebx
  801584:	e8 4f f2 ff ff       	call   8007d8 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801589:	a1 80 60 80 00       	mov    0x806080,%eax
  80158e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801594:	a1 84 60 80 00       	mov    0x806084,%eax
  801599:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80159f:	83 c4 10             	add    $0x10,%esp
  8015a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015aa:	c9                   	leave  
  8015ab:	c3                   	ret    

008015ac <devfile_write>:
{
  8015ac:	f3 0f 1e fb          	endbr32 
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
  8015b3:	83 ec 0c             	sub    $0xc,%esp
  8015b6:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8015b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8015bc:	8b 52 0c             	mov    0xc(%edx),%edx
  8015bf:	89 15 00 60 80 00    	mov    %edx,0x806000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  8015c5:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8015ca:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8015cf:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  8015d2:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, n);
  8015d7:	50                   	push   %eax
  8015d8:	ff 75 0c             	pushl  0xc(%ebp)
  8015db:	68 08 60 80 00       	push   $0x806008
  8015e0:	e8 a9 f3 ff ff       	call   80098e <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  8015e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ea:	b8 04 00 00 00       	mov    $0x4,%eax
  8015ef:	e8 ba fe ff ff       	call   8014ae <fsipc>
}
  8015f4:	c9                   	leave  
  8015f5:	c3                   	ret    

008015f6 <devfile_read>:
{
  8015f6:	f3 0f 1e fb          	endbr32 
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
  8015fd:	56                   	push   %esi
  8015fe:	53                   	push   %ebx
  8015ff:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801602:	8b 45 08             	mov    0x8(%ebp),%eax
  801605:	8b 40 0c             	mov    0xc(%eax),%eax
  801608:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  80160d:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801613:	ba 00 00 00 00       	mov    $0x0,%edx
  801618:	b8 03 00 00 00       	mov    $0x3,%eax
  80161d:	e8 8c fe ff ff       	call   8014ae <fsipc>
  801622:	89 c3                	mov    %eax,%ebx
  801624:	85 c0                	test   %eax,%eax
  801626:	78 1f                	js     801647 <devfile_read+0x51>
	assert(r <= n);
  801628:	39 f0                	cmp    %esi,%eax
  80162a:	77 24                	ja     801650 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  80162c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801631:	7f 33                	jg     801666 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801633:	83 ec 04             	sub    $0x4,%esp
  801636:	50                   	push   %eax
  801637:	68 00 60 80 00       	push   $0x806000
  80163c:	ff 75 0c             	pushl  0xc(%ebp)
  80163f:	e8 4a f3 ff ff       	call   80098e <memmove>
	return r;
  801644:	83 c4 10             	add    $0x10,%esp
}
  801647:	89 d8                	mov    %ebx,%eax
  801649:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80164c:	5b                   	pop    %ebx
  80164d:	5e                   	pop    %esi
  80164e:	5d                   	pop    %ebp
  80164f:	c3                   	ret    
	assert(r <= n);
  801650:	68 fc 2e 80 00       	push   $0x802efc
  801655:	68 03 2f 80 00       	push   $0x802f03
  80165a:	6a 7c                	push   $0x7c
  80165c:	68 18 2f 80 00       	push   $0x802f18
  801661:	e8 81 ea ff ff       	call   8000e7 <_panic>
	assert(r <= PGSIZE);
  801666:	68 23 2f 80 00       	push   $0x802f23
  80166b:	68 03 2f 80 00       	push   $0x802f03
  801670:	6a 7d                	push   $0x7d
  801672:	68 18 2f 80 00       	push   $0x802f18
  801677:	e8 6b ea ff ff       	call   8000e7 <_panic>

0080167c <open>:
{
  80167c:	f3 0f 1e fb          	endbr32 
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
  801683:	56                   	push   %esi
  801684:	53                   	push   %ebx
  801685:	83 ec 1c             	sub    $0x1c,%esp
  801688:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80168b:	56                   	push   %esi
  80168c:	e8 04 f1 ff ff       	call   800795 <strlen>
  801691:	83 c4 10             	add    $0x10,%esp
  801694:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801699:	7f 6c                	jg     801707 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  80169b:	83 ec 0c             	sub    $0xc,%esp
  80169e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016a1:	50                   	push   %eax
  8016a2:	e8 62 f8 ff ff       	call   800f09 <fd_alloc>
  8016a7:	89 c3                	mov    %eax,%ebx
  8016a9:	83 c4 10             	add    $0x10,%esp
  8016ac:	85 c0                	test   %eax,%eax
  8016ae:	78 3c                	js     8016ec <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8016b0:	83 ec 08             	sub    $0x8,%esp
  8016b3:	56                   	push   %esi
  8016b4:	68 00 60 80 00       	push   $0x806000
  8016b9:	e8 1a f1 ff ff       	call   8007d8 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8016be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c1:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8016c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8016ce:	e8 db fd ff ff       	call   8014ae <fsipc>
  8016d3:	89 c3                	mov    %eax,%ebx
  8016d5:	83 c4 10             	add    $0x10,%esp
  8016d8:	85 c0                	test   %eax,%eax
  8016da:	78 19                	js     8016f5 <open+0x79>
	return fd2num(fd);
  8016dc:	83 ec 0c             	sub    $0xc,%esp
  8016df:	ff 75 f4             	pushl  -0xc(%ebp)
  8016e2:	e8 f3 f7 ff ff       	call   800eda <fd2num>
  8016e7:	89 c3                	mov    %eax,%ebx
  8016e9:	83 c4 10             	add    $0x10,%esp
}
  8016ec:	89 d8                	mov    %ebx,%eax
  8016ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016f1:	5b                   	pop    %ebx
  8016f2:	5e                   	pop    %esi
  8016f3:	5d                   	pop    %ebp
  8016f4:	c3                   	ret    
		fd_close(fd, 0);
  8016f5:	83 ec 08             	sub    $0x8,%esp
  8016f8:	6a 00                	push   $0x0
  8016fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8016fd:	e8 10 f9 ff ff       	call   801012 <fd_close>
		return r;
  801702:	83 c4 10             	add    $0x10,%esp
  801705:	eb e5                	jmp    8016ec <open+0x70>
		return -E_BAD_PATH;
  801707:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80170c:	eb de                	jmp    8016ec <open+0x70>

0080170e <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80170e:	f3 0f 1e fb          	endbr32 
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
  801715:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801718:	ba 00 00 00 00       	mov    $0x0,%edx
  80171d:	b8 08 00 00 00       	mov    $0x8,%eax
  801722:	e8 87 fd ff ff       	call   8014ae <fsipc>
}
  801727:	c9                   	leave  
  801728:	c3                   	ret    

00801729 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801729:	f3 0f 1e fb          	endbr32 
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
  801730:	57                   	push   %edi
  801731:	56                   	push   %esi
  801732:	53                   	push   %ebx
  801733:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801739:	6a 00                	push   $0x0
  80173b:	ff 75 08             	pushl  0x8(%ebp)
  80173e:	e8 39 ff ff ff       	call   80167c <open>
  801743:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801749:	83 c4 10             	add    $0x10,%esp
  80174c:	85 c0                	test   %eax,%eax
  80174e:	0f 88 e7 04 00 00    	js     801c3b <spawn+0x512>
  801754:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801756:	83 ec 04             	sub    $0x4,%esp
  801759:	68 00 02 00 00       	push   $0x200
  80175e:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801764:	50                   	push   %eax
  801765:	52                   	push   %edx
  801766:	e8 07 fb ff ff       	call   801272 <readn>
  80176b:	83 c4 10             	add    $0x10,%esp
  80176e:	3d 00 02 00 00       	cmp    $0x200,%eax
  801773:	75 7e                	jne    8017f3 <spawn+0xca>
	    || elf->e_magic != ELF_MAGIC) {
  801775:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  80177c:	45 4c 46 
  80177f:	75 72                	jne    8017f3 <spawn+0xca>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801781:	b8 07 00 00 00       	mov    $0x7,%eax
  801786:	cd 30                	int    $0x30
  801788:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  80178e:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801794:	85 c0                	test   %eax,%eax
  801796:	0f 88 93 04 00 00    	js     801c2f <spawn+0x506>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80179c:	25 ff 03 00 00       	and    $0x3ff,%eax
  8017a1:	6b f0 7c             	imul   $0x7c,%eax,%esi
  8017a4:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  8017aa:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8017b0:	b9 11 00 00 00       	mov    $0x11,%ecx
  8017b5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8017b7:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  8017bd:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8017c3:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  8017c8:	be 00 00 00 00       	mov    $0x0,%esi
  8017cd:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8017d0:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
	for (argc = 0; argv[argc] != 0; argc++)
  8017d7:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  8017da:	85 c0                	test   %eax,%eax
  8017dc:	74 4d                	je     80182b <spawn+0x102>
		string_size += strlen(argv[argc]) + 1;
  8017de:	83 ec 0c             	sub    $0xc,%esp
  8017e1:	50                   	push   %eax
  8017e2:	e8 ae ef ff ff       	call   800795 <strlen>
  8017e7:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  8017eb:	83 c3 01             	add    $0x1,%ebx
  8017ee:	83 c4 10             	add    $0x10,%esp
  8017f1:	eb dd                	jmp    8017d0 <spawn+0xa7>
		close(fd);
  8017f3:	83 ec 0c             	sub    $0xc,%esp
  8017f6:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8017fc:	e8 9c f8 ff ff       	call   80109d <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801801:	83 c4 0c             	add    $0xc,%esp
  801804:	68 7f 45 4c 46       	push   $0x464c457f
  801809:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  80180f:	68 2f 2f 80 00       	push   $0x802f2f
  801814:	e8 b5 e9 ff ff       	call   8001ce <cprintf>
		return -E_NOT_EXEC;
  801819:	83 c4 10             	add    $0x10,%esp
  80181c:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801823:	ff ff ff 
  801826:	e9 10 04 00 00       	jmp    801c3b <spawn+0x512>
  80182b:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801831:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801837:	bf 00 10 40 00       	mov    $0x401000,%edi
  80183c:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  80183e:	89 fa                	mov    %edi,%edx
  801840:	83 e2 fc             	and    $0xfffffffc,%edx
  801843:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  80184a:	29 c2                	sub    %eax,%edx
  80184c:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801852:	8d 42 f8             	lea    -0x8(%edx),%eax
  801855:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  80185a:	0f 86 fe 03 00 00    	jbe    801c5e <spawn+0x535>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801860:	83 ec 04             	sub    $0x4,%esp
  801863:	6a 07                	push   $0x7
  801865:	68 00 00 40 00       	push   $0x400000
  80186a:	6a 00                	push   $0x0
  80186c:	e8 a9 f3 ff ff       	call   800c1a <sys_page_alloc>
  801871:	83 c4 10             	add    $0x10,%esp
  801874:	85 c0                	test   %eax,%eax
  801876:	0f 88 e7 03 00 00    	js     801c63 <spawn+0x53a>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80187c:	be 00 00 00 00       	mov    $0x0,%esi
  801881:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801887:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80188a:	eb 30                	jmp    8018bc <spawn+0x193>
		argv_store[i] = UTEMP2USTACK(string_store);
  80188c:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801892:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801898:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  80189b:	83 ec 08             	sub    $0x8,%esp
  80189e:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8018a1:	57                   	push   %edi
  8018a2:	e8 31 ef ff ff       	call   8007d8 <strcpy>
		string_store += strlen(argv[i]) + 1;
  8018a7:	83 c4 04             	add    $0x4,%esp
  8018aa:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8018ad:	e8 e3 ee ff ff       	call   800795 <strlen>
  8018b2:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  8018b6:	83 c6 01             	add    $0x1,%esi
  8018b9:	83 c4 10             	add    $0x10,%esp
  8018bc:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  8018c2:	7f c8                	jg     80188c <spawn+0x163>
	}
	argv_store[argc] = 0;
  8018c4:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8018ca:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  8018d0:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8018d7:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  8018dd:	0f 85 86 00 00 00    	jne    801969 <spawn+0x240>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8018e3:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  8018e9:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  8018ef:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  8018f2:	89 c8                	mov    %ecx,%eax
  8018f4:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  8018fa:	89 48 f8             	mov    %ecx,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8018fd:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801902:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801908:	83 ec 0c             	sub    $0xc,%esp
  80190b:	6a 07                	push   $0x7
  80190d:	68 00 d0 bf ee       	push   $0xeebfd000
  801912:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801918:	68 00 00 40 00       	push   $0x400000
  80191d:	6a 00                	push   $0x0
  80191f:	e8 3d f3 ff ff       	call   800c61 <sys_page_map>
  801924:	89 c3                	mov    %eax,%ebx
  801926:	83 c4 20             	add    $0x20,%esp
  801929:	85 c0                	test   %eax,%eax
  80192b:	0f 88 3a 03 00 00    	js     801c6b <spawn+0x542>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801931:	83 ec 08             	sub    $0x8,%esp
  801934:	68 00 00 40 00       	push   $0x400000
  801939:	6a 00                	push   $0x0
  80193b:	e8 67 f3 ff ff       	call   800ca7 <sys_page_unmap>
  801940:	89 c3                	mov    %eax,%ebx
  801942:	83 c4 10             	add    $0x10,%esp
  801945:	85 c0                	test   %eax,%eax
  801947:	0f 88 1e 03 00 00    	js     801c6b <spawn+0x542>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  80194d:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801953:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80195a:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  801961:	00 00 00 
  801964:	e9 4f 01 00 00       	jmp    801ab8 <spawn+0x38f>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801969:	68 a4 2f 80 00       	push   $0x802fa4
  80196e:	68 03 2f 80 00       	push   $0x802f03
  801973:	68 f2 00 00 00       	push   $0xf2
  801978:	68 49 2f 80 00       	push   $0x802f49
  80197d:	e8 65 e7 ff ff       	call   8000e7 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801982:	83 ec 04             	sub    $0x4,%esp
  801985:	6a 07                	push   $0x7
  801987:	68 00 00 40 00       	push   $0x400000
  80198c:	6a 00                	push   $0x0
  80198e:	e8 87 f2 ff ff       	call   800c1a <sys_page_alloc>
  801993:	83 c4 10             	add    $0x10,%esp
  801996:	85 c0                	test   %eax,%eax
  801998:	0f 88 ab 02 00 00    	js     801c49 <spawn+0x520>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  80199e:	83 ec 08             	sub    $0x8,%esp
  8019a1:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  8019a7:	01 f0                	add    %esi,%eax
  8019a9:	50                   	push   %eax
  8019aa:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8019b0:	e8 8e f9 ff ff       	call   801343 <seek>
  8019b5:	83 c4 10             	add    $0x10,%esp
  8019b8:	85 c0                	test   %eax,%eax
  8019ba:	0f 88 90 02 00 00    	js     801c50 <spawn+0x527>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8019c0:	83 ec 04             	sub    $0x4,%esp
  8019c3:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8019c9:	29 f0                	sub    %esi,%eax
  8019cb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019d0:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8019d5:	0f 47 c1             	cmova  %ecx,%eax
  8019d8:	50                   	push   %eax
  8019d9:	68 00 00 40 00       	push   $0x400000
  8019de:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8019e4:	e8 89 f8 ff ff       	call   801272 <readn>
  8019e9:	83 c4 10             	add    $0x10,%esp
  8019ec:	85 c0                	test   %eax,%eax
  8019ee:	0f 88 63 02 00 00    	js     801c57 <spawn+0x52e>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8019f4:	83 ec 0c             	sub    $0xc,%esp
  8019f7:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8019fd:	53                   	push   %ebx
  8019fe:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801a04:	68 00 00 40 00       	push   $0x400000
  801a09:	6a 00                	push   $0x0
  801a0b:	e8 51 f2 ff ff       	call   800c61 <sys_page_map>
  801a10:	83 c4 20             	add    $0x20,%esp
  801a13:	85 c0                	test   %eax,%eax
  801a15:	78 7c                	js     801a93 <spawn+0x36a>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801a17:	83 ec 08             	sub    $0x8,%esp
  801a1a:	68 00 00 40 00       	push   $0x400000
  801a1f:	6a 00                	push   $0x0
  801a21:	e8 81 f2 ff ff       	call   800ca7 <sys_page_unmap>
  801a26:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801a29:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801a2f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801a35:	89 fe                	mov    %edi,%esi
  801a37:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801a3d:	76 69                	jbe    801aa8 <spawn+0x37f>
		if (i >= filesz) {
  801a3f:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801a45:	0f 87 37 ff ff ff    	ja     801982 <spawn+0x259>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801a4b:	83 ec 04             	sub    $0x4,%esp
  801a4e:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801a54:	53                   	push   %ebx
  801a55:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801a5b:	e8 ba f1 ff ff       	call   800c1a <sys_page_alloc>
  801a60:	83 c4 10             	add    $0x10,%esp
  801a63:	85 c0                	test   %eax,%eax
  801a65:	79 c2                	jns    801a29 <spawn+0x300>
  801a67:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801a69:	83 ec 0c             	sub    $0xc,%esp
  801a6c:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801a72:	e8 18 f1 ff ff       	call   800b8f <sys_env_destroy>
	close(fd);
  801a77:	83 c4 04             	add    $0x4,%esp
  801a7a:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801a80:	e8 18 f6 ff ff       	call   80109d <close>
	return r;
  801a85:	83 c4 10             	add    $0x10,%esp
  801a88:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801a8e:	e9 a8 01 00 00       	jmp    801c3b <spawn+0x512>
				panic("spawn: sys_page_map data: %e", r);
  801a93:	50                   	push   %eax
  801a94:	68 55 2f 80 00       	push   $0x802f55
  801a99:	68 25 01 00 00       	push   $0x125
  801a9e:	68 49 2f 80 00       	push   $0x802f49
  801aa3:	e8 3f e6 ff ff       	call   8000e7 <_panic>
  801aa8:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801aae:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801ab5:	83 c6 20             	add    $0x20,%esi
  801ab8:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801abf:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801ac5:	7e 6d                	jle    801b34 <spawn+0x40b>
		if (ph->p_type != ELF_PROG_LOAD)
  801ac7:	83 3e 01             	cmpl   $0x1,(%esi)
  801aca:	75 e2                	jne    801aae <spawn+0x385>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801acc:	8b 46 18             	mov    0x18(%esi),%eax
  801acf:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801ad2:	83 f8 01             	cmp    $0x1,%eax
  801ad5:	19 c0                	sbb    %eax,%eax
  801ad7:	83 e0 fe             	and    $0xfffffffe,%eax
  801ada:	83 c0 07             	add    $0x7,%eax
  801add:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801ae3:	8b 4e 04             	mov    0x4(%esi),%ecx
  801ae6:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801aec:	8b 56 10             	mov    0x10(%esi),%edx
  801aef:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801af5:	8b 7e 14             	mov    0x14(%esi),%edi
  801af8:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  801afe:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801b01:	89 d8                	mov    %ebx,%eax
  801b03:	25 ff 0f 00 00       	and    $0xfff,%eax
  801b08:	74 1a                	je     801b24 <spawn+0x3fb>
		va -= i;
  801b0a:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801b0c:	01 c7                	add    %eax,%edi
  801b0e:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801b14:	01 c2                	add    %eax,%edx
  801b16:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  801b1c:	29 c1                	sub    %eax,%ecx
  801b1e:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801b24:	bf 00 00 00 00       	mov    $0x0,%edi
  801b29:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801b2f:	e9 01 ff ff ff       	jmp    801a35 <spawn+0x30c>
	close(fd);
  801b34:	83 ec 0c             	sub    $0xc,%esp
  801b37:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801b3d:	e8 5b f5 ff ff       	call   80109d <close>
  801b42:	83 c4 10             	add    $0x10,%esp
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	uint32_t addr;
	int r;
	for(addr = 0; addr < USTACKTOP; addr += PGSIZE){
  801b45:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b4a:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  801b50:	eb 0e                	jmp    801b60 <spawn+0x437>
  801b52:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801b58:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801b5e:	74 5a                	je     801bba <spawn+0x491>
		if((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U) && (uvpt[PGNUM(addr)] & PTE_SHARE)){
  801b60:	89 d8                	mov    %ebx,%eax
  801b62:	c1 e8 16             	shr    $0x16,%eax
  801b65:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801b6c:	a8 01                	test   $0x1,%al
  801b6e:	74 e2                	je     801b52 <spawn+0x429>
  801b70:	89 d8                	mov    %ebx,%eax
  801b72:	c1 e8 0c             	shr    $0xc,%eax
  801b75:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801b7c:	f6 c2 01             	test   $0x1,%dl
  801b7f:	74 d1                	je     801b52 <spawn+0x429>
  801b81:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801b88:	f6 c2 04             	test   $0x4,%dl
  801b8b:	74 c5                	je     801b52 <spawn+0x429>
  801b8d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801b94:	f6 c6 04             	test   $0x4,%dh
  801b97:	74 b9                	je     801b52 <spawn+0x429>
			if(r = sys_page_map(0, (void*)addr, child, (void*)addr, (uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  801b99:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801ba0:	83 ec 0c             	sub    $0xc,%esp
  801ba3:	25 07 0e 00 00       	and    $0xe07,%eax
  801ba8:	50                   	push   %eax
  801ba9:	53                   	push   %ebx
  801baa:	56                   	push   %esi
  801bab:	53                   	push   %ebx
  801bac:	6a 00                	push   $0x0
  801bae:	e8 ae f0 ff ff       	call   800c61 <sys_page_map>
  801bb3:	83 c4 20             	add    $0x20,%esp
  801bb6:	85 c0                	test   %eax,%eax
  801bb8:	79 98                	jns    801b52 <spawn+0x429>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801bba:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801bc1:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801bc4:	83 ec 08             	sub    $0x8,%esp
  801bc7:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801bcd:	50                   	push   %eax
  801bce:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801bd4:	e8 5a f1 ff ff       	call   800d33 <sys_env_set_trapframe>
  801bd9:	83 c4 10             	add    $0x10,%esp
  801bdc:	85 c0                	test   %eax,%eax
  801bde:	78 25                	js     801c05 <spawn+0x4dc>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801be0:	83 ec 08             	sub    $0x8,%esp
  801be3:	6a 02                	push   $0x2
  801be5:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801beb:	e8 fd f0 ff ff       	call   800ced <sys_env_set_status>
  801bf0:	83 c4 10             	add    $0x10,%esp
  801bf3:	85 c0                	test   %eax,%eax
  801bf5:	78 23                	js     801c1a <spawn+0x4f1>
	return child;
  801bf7:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801bfd:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801c03:	eb 36                	jmp    801c3b <spawn+0x512>
		panic("sys_env_set_trapframe: %e", r);
  801c05:	50                   	push   %eax
  801c06:	68 72 2f 80 00       	push   $0x802f72
  801c0b:	68 86 00 00 00       	push   $0x86
  801c10:	68 49 2f 80 00       	push   $0x802f49
  801c15:	e8 cd e4 ff ff       	call   8000e7 <_panic>
		panic("sys_env_set_status: %e", r);
  801c1a:	50                   	push   %eax
  801c1b:	68 8c 2f 80 00       	push   $0x802f8c
  801c20:	68 89 00 00 00       	push   $0x89
  801c25:	68 49 2f 80 00       	push   $0x802f49
  801c2a:	e8 b8 e4 ff ff       	call   8000e7 <_panic>
		return r;
  801c2f:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801c35:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  801c3b:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801c41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c44:	5b                   	pop    %ebx
  801c45:	5e                   	pop    %esi
  801c46:	5f                   	pop    %edi
  801c47:	5d                   	pop    %ebp
  801c48:	c3                   	ret    
  801c49:	89 c7                	mov    %eax,%edi
  801c4b:	e9 19 fe ff ff       	jmp    801a69 <spawn+0x340>
  801c50:	89 c7                	mov    %eax,%edi
  801c52:	e9 12 fe ff ff       	jmp    801a69 <spawn+0x340>
  801c57:	89 c7                	mov    %eax,%edi
  801c59:	e9 0b fe ff ff       	jmp    801a69 <spawn+0x340>
		return -E_NO_MEM;
  801c5e:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(addr = 0; addr < USTACKTOP; addr += PGSIZE){
  801c63:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801c69:	eb d0                	jmp    801c3b <spawn+0x512>
	sys_page_unmap(0, UTEMP);
  801c6b:	83 ec 08             	sub    $0x8,%esp
  801c6e:	68 00 00 40 00       	push   $0x400000
  801c73:	6a 00                	push   $0x0
  801c75:	e8 2d f0 ff ff       	call   800ca7 <sys_page_unmap>
  801c7a:	83 c4 10             	add    $0x10,%esp
  801c7d:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801c83:	eb b6                	jmp    801c3b <spawn+0x512>

00801c85 <spawnl>:
{
  801c85:	f3 0f 1e fb          	endbr32 
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
  801c8c:	57                   	push   %edi
  801c8d:	56                   	push   %esi
  801c8e:	53                   	push   %ebx
  801c8f:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801c92:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801c95:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801c9a:	8d 4a 04             	lea    0x4(%edx),%ecx
  801c9d:	83 3a 00             	cmpl   $0x0,(%edx)
  801ca0:	74 07                	je     801ca9 <spawnl+0x24>
		argc++;
  801ca2:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801ca5:	89 ca                	mov    %ecx,%edx
  801ca7:	eb f1                	jmp    801c9a <spawnl+0x15>
	const char *argv[argc+2];
  801ca9:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  801cb0:	89 d1                	mov    %edx,%ecx
  801cb2:	83 e1 f0             	and    $0xfffffff0,%ecx
  801cb5:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801cbb:	89 e6                	mov    %esp,%esi
  801cbd:	29 d6                	sub    %edx,%esi
  801cbf:	89 f2                	mov    %esi,%edx
  801cc1:	39 d4                	cmp    %edx,%esp
  801cc3:	74 10                	je     801cd5 <spawnl+0x50>
  801cc5:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  801ccb:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  801cd2:	00 
  801cd3:	eb ec                	jmp    801cc1 <spawnl+0x3c>
  801cd5:	89 ca                	mov    %ecx,%edx
  801cd7:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  801cdd:	29 d4                	sub    %edx,%esp
  801cdf:	85 d2                	test   %edx,%edx
  801ce1:	74 05                	je     801ce8 <spawnl+0x63>
  801ce3:	83 4c 14 fc 00       	orl    $0x0,-0x4(%esp,%edx,1)
  801ce8:	8d 74 24 03          	lea    0x3(%esp),%esi
  801cec:	89 f2                	mov    %esi,%edx
  801cee:	c1 ea 02             	shr    $0x2,%edx
  801cf1:	83 e6 fc             	and    $0xfffffffc,%esi
  801cf4:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801cf6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cf9:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801d00:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801d07:	00 
	va_start(vl, arg0);
  801d08:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801d0b:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801d0d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d12:	eb 0b                	jmp    801d1f <spawnl+0x9a>
		argv[i+1] = va_arg(vl, const char *);
  801d14:	83 c0 01             	add    $0x1,%eax
  801d17:	8b 39                	mov    (%ecx),%edi
  801d19:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801d1c:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801d1f:	39 d0                	cmp    %edx,%eax
  801d21:	75 f1                	jne    801d14 <spawnl+0x8f>
	return spawn(prog, argv);
  801d23:	83 ec 08             	sub    $0x8,%esp
  801d26:	56                   	push   %esi
  801d27:	ff 75 08             	pushl  0x8(%ebp)
  801d2a:	e8 fa f9 ff ff       	call   801729 <spawn>
}
  801d2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d32:	5b                   	pop    %ebx
  801d33:	5e                   	pop    %esi
  801d34:	5f                   	pop    %edi
  801d35:	5d                   	pop    %ebp
  801d36:	c3                   	ret    

00801d37 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801d37:	f3 0f 1e fb          	endbr32 
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
  801d3e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801d41:	68 ca 2f 80 00       	push   $0x802fca
  801d46:	ff 75 0c             	pushl  0xc(%ebp)
  801d49:	e8 8a ea ff ff       	call   8007d8 <strcpy>
	return 0;
}
  801d4e:	b8 00 00 00 00       	mov    $0x0,%eax
  801d53:	c9                   	leave  
  801d54:	c3                   	ret    

00801d55 <devsock_close>:
{
  801d55:	f3 0f 1e fb          	endbr32 
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
  801d5c:	53                   	push   %ebx
  801d5d:	83 ec 10             	sub    $0x10,%esp
  801d60:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801d63:	53                   	push   %ebx
  801d64:	e8 9b 0a 00 00       	call   802804 <pageref>
  801d69:	89 c2                	mov    %eax,%edx
  801d6b:	83 c4 10             	add    $0x10,%esp
		return 0;
  801d6e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801d73:	83 fa 01             	cmp    $0x1,%edx
  801d76:	74 05                	je     801d7d <devsock_close+0x28>
}
  801d78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d7b:	c9                   	leave  
  801d7c:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801d7d:	83 ec 0c             	sub    $0xc,%esp
  801d80:	ff 73 0c             	pushl  0xc(%ebx)
  801d83:	e8 e3 02 00 00       	call   80206b <nsipc_close>
  801d88:	83 c4 10             	add    $0x10,%esp
  801d8b:	eb eb                	jmp    801d78 <devsock_close+0x23>

00801d8d <devsock_write>:
{
  801d8d:	f3 0f 1e fb          	endbr32 
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
  801d94:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801d97:	6a 00                	push   $0x0
  801d99:	ff 75 10             	pushl  0x10(%ebp)
  801d9c:	ff 75 0c             	pushl  0xc(%ebp)
  801d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801da2:	ff 70 0c             	pushl  0xc(%eax)
  801da5:	e8 b5 03 00 00       	call   80215f <nsipc_send>
}
  801daa:	c9                   	leave  
  801dab:	c3                   	ret    

00801dac <devsock_read>:
{
  801dac:	f3 0f 1e fb          	endbr32 
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
  801db3:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801db6:	6a 00                	push   $0x0
  801db8:	ff 75 10             	pushl  0x10(%ebp)
  801dbb:	ff 75 0c             	pushl  0xc(%ebp)
  801dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc1:	ff 70 0c             	pushl  0xc(%eax)
  801dc4:	e8 1f 03 00 00       	call   8020e8 <nsipc_recv>
}
  801dc9:	c9                   	leave  
  801dca:	c3                   	ret    

00801dcb <fd2sockid>:
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
  801dce:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801dd1:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801dd4:	52                   	push   %edx
  801dd5:	50                   	push   %eax
  801dd6:	e8 84 f1 ff ff       	call   800f5f <fd_lookup>
  801ddb:	83 c4 10             	add    $0x10,%esp
  801dde:	85 c0                	test   %eax,%eax
  801de0:	78 10                	js     801df2 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de5:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801deb:	39 08                	cmp    %ecx,(%eax)
  801ded:	75 05                	jne    801df4 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801def:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801df2:	c9                   	leave  
  801df3:	c3                   	ret    
		return -E_NOT_SUPP;
  801df4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801df9:	eb f7                	jmp    801df2 <fd2sockid+0x27>

00801dfb <alloc_sockfd>:
{
  801dfb:	55                   	push   %ebp
  801dfc:	89 e5                	mov    %esp,%ebp
  801dfe:	56                   	push   %esi
  801dff:	53                   	push   %ebx
  801e00:	83 ec 1c             	sub    $0x1c,%esp
  801e03:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801e05:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e08:	50                   	push   %eax
  801e09:	e8 fb f0 ff ff       	call   800f09 <fd_alloc>
  801e0e:	89 c3                	mov    %eax,%ebx
  801e10:	83 c4 10             	add    $0x10,%esp
  801e13:	85 c0                	test   %eax,%eax
  801e15:	78 43                	js     801e5a <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801e17:	83 ec 04             	sub    $0x4,%esp
  801e1a:	68 07 04 00 00       	push   $0x407
  801e1f:	ff 75 f4             	pushl  -0xc(%ebp)
  801e22:	6a 00                	push   $0x0
  801e24:	e8 f1 ed ff ff       	call   800c1a <sys_page_alloc>
  801e29:	89 c3                	mov    %eax,%ebx
  801e2b:	83 c4 10             	add    $0x10,%esp
  801e2e:	85 c0                	test   %eax,%eax
  801e30:	78 28                	js     801e5a <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e35:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801e3b:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e40:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801e47:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801e4a:	83 ec 0c             	sub    $0xc,%esp
  801e4d:	50                   	push   %eax
  801e4e:	e8 87 f0 ff ff       	call   800eda <fd2num>
  801e53:	89 c3                	mov    %eax,%ebx
  801e55:	83 c4 10             	add    $0x10,%esp
  801e58:	eb 0c                	jmp    801e66 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801e5a:	83 ec 0c             	sub    $0xc,%esp
  801e5d:	56                   	push   %esi
  801e5e:	e8 08 02 00 00       	call   80206b <nsipc_close>
		return r;
  801e63:	83 c4 10             	add    $0x10,%esp
}
  801e66:	89 d8                	mov    %ebx,%eax
  801e68:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e6b:	5b                   	pop    %ebx
  801e6c:	5e                   	pop    %esi
  801e6d:	5d                   	pop    %ebp
  801e6e:	c3                   	ret    

00801e6f <accept>:
{
  801e6f:	f3 0f 1e fb          	endbr32 
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
  801e76:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e79:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7c:	e8 4a ff ff ff       	call   801dcb <fd2sockid>
  801e81:	85 c0                	test   %eax,%eax
  801e83:	78 1b                	js     801ea0 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e85:	83 ec 04             	sub    $0x4,%esp
  801e88:	ff 75 10             	pushl  0x10(%ebp)
  801e8b:	ff 75 0c             	pushl  0xc(%ebp)
  801e8e:	50                   	push   %eax
  801e8f:	e8 22 01 00 00       	call   801fb6 <nsipc_accept>
  801e94:	83 c4 10             	add    $0x10,%esp
  801e97:	85 c0                	test   %eax,%eax
  801e99:	78 05                	js     801ea0 <accept+0x31>
	return alloc_sockfd(r);
  801e9b:	e8 5b ff ff ff       	call   801dfb <alloc_sockfd>
}
  801ea0:	c9                   	leave  
  801ea1:	c3                   	ret    

00801ea2 <bind>:
{
  801ea2:	f3 0f 1e fb          	endbr32 
  801ea6:	55                   	push   %ebp
  801ea7:	89 e5                	mov    %esp,%ebp
  801ea9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801eac:	8b 45 08             	mov    0x8(%ebp),%eax
  801eaf:	e8 17 ff ff ff       	call   801dcb <fd2sockid>
  801eb4:	85 c0                	test   %eax,%eax
  801eb6:	78 12                	js     801eca <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801eb8:	83 ec 04             	sub    $0x4,%esp
  801ebb:	ff 75 10             	pushl  0x10(%ebp)
  801ebe:	ff 75 0c             	pushl  0xc(%ebp)
  801ec1:	50                   	push   %eax
  801ec2:	e8 45 01 00 00       	call   80200c <nsipc_bind>
  801ec7:	83 c4 10             	add    $0x10,%esp
}
  801eca:	c9                   	leave  
  801ecb:	c3                   	ret    

00801ecc <shutdown>:
{
  801ecc:	f3 0f 1e fb          	endbr32 
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
  801ed3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed9:	e8 ed fe ff ff       	call   801dcb <fd2sockid>
  801ede:	85 c0                	test   %eax,%eax
  801ee0:	78 0f                	js     801ef1 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801ee2:	83 ec 08             	sub    $0x8,%esp
  801ee5:	ff 75 0c             	pushl  0xc(%ebp)
  801ee8:	50                   	push   %eax
  801ee9:	e8 57 01 00 00       	call   802045 <nsipc_shutdown>
  801eee:	83 c4 10             	add    $0x10,%esp
}
  801ef1:	c9                   	leave  
  801ef2:	c3                   	ret    

00801ef3 <connect>:
{
  801ef3:	f3 0f 1e fb          	endbr32 
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
  801efa:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801efd:	8b 45 08             	mov    0x8(%ebp),%eax
  801f00:	e8 c6 fe ff ff       	call   801dcb <fd2sockid>
  801f05:	85 c0                	test   %eax,%eax
  801f07:	78 12                	js     801f1b <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801f09:	83 ec 04             	sub    $0x4,%esp
  801f0c:	ff 75 10             	pushl  0x10(%ebp)
  801f0f:	ff 75 0c             	pushl  0xc(%ebp)
  801f12:	50                   	push   %eax
  801f13:	e8 71 01 00 00       	call   802089 <nsipc_connect>
  801f18:	83 c4 10             	add    $0x10,%esp
}
  801f1b:	c9                   	leave  
  801f1c:	c3                   	ret    

00801f1d <listen>:
{
  801f1d:	f3 0f 1e fb          	endbr32 
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
  801f24:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f27:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2a:	e8 9c fe ff ff       	call   801dcb <fd2sockid>
  801f2f:	85 c0                	test   %eax,%eax
  801f31:	78 0f                	js     801f42 <listen+0x25>
	return nsipc_listen(r, backlog);
  801f33:	83 ec 08             	sub    $0x8,%esp
  801f36:	ff 75 0c             	pushl  0xc(%ebp)
  801f39:	50                   	push   %eax
  801f3a:	e8 83 01 00 00       	call   8020c2 <nsipc_listen>
  801f3f:	83 c4 10             	add    $0x10,%esp
}
  801f42:	c9                   	leave  
  801f43:	c3                   	ret    

00801f44 <socket>:

int
socket(int domain, int type, int protocol)
{
  801f44:	f3 0f 1e fb          	endbr32 
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
  801f4b:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801f4e:	ff 75 10             	pushl  0x10(%ebp)
  801f51:	ff 75 0c             	pushl  0xc(%ebp)
  801f54:	ff 75 08             	pushl  0x8(%ebp)
  801f57:	e8 65 02 00 00       	call   8021c1 <nsipc_socket>
  801f5c:	83 c4 10             	add    $0x10,%esp
  801f5f:	85 c0                	test   %eax,%eax
  801f61:	78 05                	js     801f68 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801f63:	e8 93 fe ff ff       	call   801dfb <alloc_sockfd>
}
  801f68:	c9                   	leave  
  801f69:	c3                   	ret    

00801f6a <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801f6a:	55                   	push   %ebp
  801f6b:	89 e5                	mov    %esp,%ebp
  801f6d:	53                   	push   %ebx
  801f6e:	83 ec 04             	sub    $0x4,%esp
  801f71:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801f73:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801f7a:	74 26                	je     801fa2 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801f7c:	6a 07                	push   $0x7
  801f7e:	68 00 70 80 00       	push   $0x807000
  801f83:	53                   	push   %ebx
  801f84:	ff 35 04 50 80 00    	pushl  0x805004
  801f8a:	e8 e0 07 00 00       	call   80276f <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801f8f:	83 c4 0c             	add    $0xc,%esp
  801f92:	6a 00                	push   $0x0
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	e8 4d 07 00 00       	call   8026ea <ipc_recv>
}
  801f9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fa0:	c9                   	leave  
  801fa1:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801fa2:	83 ec 0c             	sub    $0xc,%esp
  801fa5:	6a 02                	push   $0x2
  801fa7:	e8 1b 08 00 00       	call   8027c7 <ipc_find_env>
  801fac:	a3 04 50 80 00       	mov    %eax,0x805004
  801fb1:	83 c4 10             	add    $0x10,%esp
  801fb4:	eb c6                	jmp    801f7c <nsipc+0x12>

00801fb6 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801fb6:	f3 0f 1e fb          	endbr32 
  801fba:	55                   	push   %ebp
  801fbb:	89 e5                	mov    %esp,%ebp
  801fbd:	56                   	push   %esi
  801fbe:	53                   	push   %ebx
  801fbf:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc5:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801fca:	8b 06                	mov    (%esi),%eax
  801fcc:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801fd1:	b8 01 00 00 00       	mov    $0x1,%eax
  801fd6:	e8 8f ff ff ff       	call   801f6a <nsipc>
  801fdb:	89 c3                	mov    %eax,%ebx
  801fdd:	85 c0                	test   %eax,%eax
  801fdf:	79 09                	jns    801fea <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801fe1:	89 d8                	mov    %ebx,%eax
  801fe3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fe6:	5b                   	pop    %ebx
  801fe7:	5e                   	pop    %esi
  801fe8:	5d                   	pop    %ebp
  801fe9:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801fea:	83 ec 04             	sub    $0x4,%esp
  801fed:	ff 35 10 70 80 00    	pushl  0x807010
  801ff3:	68 00 70 80 00       	push   $0x807000
  801ff8:	ff 75 0c             	pushl  0xc(%ebp)
  801ffb:	e8 8e e9 ff ff       	call   80098e <memmove>
		*addrlen = ret->ret_addrlen;
  802000:	a1 10 70 80 00       	mov    0x807010,%eax
  802005:	89 06                	mov    %eax,(%esi)
  802007:	83 c4 10             	add    $0x10,%esp
	return r;
  80200a:	eb d5                	jmp    801fe1 <nsipc_accept+0x2b>

0080200c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80200c:	f3 0f 1e fb          	endbr32 
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
  802013:	53                   	push   %ebx
  802014:	83 ec 08             	sub    $0x8,%esp
  802017:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80201a:	8b 45 08             	mov    0x8(%ebp),%eax
  80201d:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802022:	53                   	push   %ebx
  802023:	ff 75 0c             	pushl  0xc(%ebp)
  802026:	68 04 70 80 00       	push   $0x807004
  80202b:	e8 5e e9 ff ff       	call   80098e <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802030:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802036:	b8 02 00 00 00       	mov    $0x2,%eax
  80203b:	e8 2a ff ff ff       	call   801f6a <nsipc>
}
  802040:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802043:	c9                   	leave  
  802044:	c3                   	ret    

00802045 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802045:	f3 0f 1e fb          	endbr32 
  802049:	55                   	push   %ebp
  80204a:	89 e5                	mov    %esp,%ebp
  80204c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80204f:	8b 45 08             	mov    0x8(%ebp),%eax
  802052:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802057:	8b 45 0c             	mov    0xc(%ebp),%eax
  80205a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80205f:	b8 03 00 00 00       	mov    $0x3,%eax
  802064:	e8 01 ff ff ff       	call   801f6a <nsipc>
}
  802069:	c9                   	leave  
  80206a:	c3                   	ret    

0080206b <nsipc_close>:

int
nsipc_close(int s)
{
  80206b:	f3 0f 1e fb          	endbr32 
  80206f:	55                   	push   %ebp
  802070:	89 e5                	mov    %esp,%ebp
  802072:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802075:	8b 45 08             	mov    0x8(%ebp),%eax
  802078:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80207d:	b8 04 00 00 00       	mov    $0x4,%eax
  802082:	e8 e3 fe ff ff       	call   801f6a <nsipc>
}
  802087:	c9                   	leave  
  802088:	c3                   	ret    

00802089 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802089:	f3 0f 1e fb          	endbr32 
  80208d:	55                   	push   %ebp
  80208e:	89 e5                	mov    %esp,%ebp
  802090:	53                   	push   %ebx
  802091:	83 ec 08             	sub    $0x8,%esp
  802094:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802097:	8b 45 08             	mov    0x8(%ebp),%eax
  80209a:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80209f:	53                   	push   %ebx
  8020a0:	ff 75 0c             	pushl  0xc(%ebp)
  8020a3:	68 04 70 80 00       	push   $0x807004
  8020a8:	e8 e1 e8 ff ff       	call   80098e <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8020ad:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8020b3:	b8 05 00 00 00       	mov    $0x5,%eax
  8020b8:	e8 ad fe ff ff       	call   801f6a <nsipc>
}
  8020bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020c0:	c9                   	leave  
  8020c1:	c3                   	ret    

008020c2 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8020c2:	f3 0f 1e fb          	endbr32 
  8020c6:	55                   	push   %ebp
  8020c7:	89 e5                	mov    %esp,%ebp
  8020c9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8020cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cf:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8020d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d7:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8020dc:	b8 06 00 00 00       	mov    $0x6,%eax
  8020e1:	e8 84 fe ff ff       	call   801f6a <nsipc>
}
  8020e6:	c9                   	leave  
  8020e7:	c3                   	ret    

008020e8 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8020e8:	f3 0f 1e fb          	endbr32 
  8020ec:	55                   	push   %ebp
  8020ed:	89 e5                	mov    %esp,%ebp
  8020ef:	56                   	push   %esi
  8020f0:	53                   	push   %ebx
  8020f1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8020f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8020fc:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802102:	8b 45 14             	mov    0x14(%ebp),%eax
  802105:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80210a:	b8 07 00 00 00       	mov    $0x7,%eax
  80210f:	e8 56 fe ff ff       	call   801f6a <nsipc>
  802114:	89 c3                	mov    %eax,%ebx
  802116:	85 c0                	test   %eax,%eax
  802118:	78 26                	js     802140 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  80211a:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  802120:	b8 3f 06 00 00       	mov    $0x63f,%eax
  802125:	0f 4e c6             	cmovle %esi,%eax
  802128:	39 c3                	cmp    %eax,%ebx
  80212a:	7f 1d                	jg     802149 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80212c:	83 ec 04             	sub    $0x4,%esp
  80212f:	53                   	push   %ebx
  802130:	68 00 70 80 00       	push   $0x807000
  802135:	ff 75 0c             	pushl  0xc(%ebp)
  802138:	e8 51 e8 ff ff       	call   80098e <memmove>
  80213d:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802140:	89 d8                	mov    %ebx,%eax
  802142:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802145:	5b                   	pop    %ebx
  802146:	5e                   	pop    %esi
  802147:	5d                   	pop    %ebp
  802148:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802149:	68 d6 2f 80 00       	push   $0x802fd6
  80214e:	68 03 2f 80 00       	push   $0x802f03
  802153:	6a 62                	push   $0x62
  802155:	68 eb 2f 80 00       	push   $0x802feb
  80215a:	e8 88 df ff ff       	call   8000e7 <_panic>

0080215f <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80215f:	f3 0f 1e fb          	endbr32 
  802163:	55                   	push   %ebp
  802164:	89 e5                	mov    %esp,%ebp
  802166:	53                   	push   %ebx
  802167:	83 ec 04             	sub    $0x4,%esp
  80216a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80216d:	8b 45 08             	mov    0x8(%ebp),%eax
  802170:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802175:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80217b:	7f 2e                	jg     8021ab <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80217d:	83 ec 04             	sub    $0x4,%esp
  802180:	53                   	push   %ebx
  802181:	ff 75 0c             	pushl  0xc(%ebp)
  802184:	68 0c 70 80 00       	push   $0x80700c
  802189:	e8 00 e8 ff ff       	call   80098e <memmove>
	nsipcbuf.send.req_size = size;
  80218e:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802194:	8b 45 14             	mov    0x14(%ebp),%eax
  802197:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80219c:	b8 08 00 00 00       	mov    $0x8,%eax
  8021a1:	e8 c4 fd ff ff       	call   801f6a <nsipc>
}
  8021a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021a9:	c9                   	leave  
  8021aa:	c3                   	ret    
	assert(size < 1600);
  8021ab:	68 f7 2f 80 00       	push   $0x802ff7
  8021b0:	68 03 2f 80 00       	push   $0x802f03
  8021b5:	6a 6d                	push   $0x6d
  8021b7:	68 eb 2f 80 00       	push   $0x802feb
  8021bc:	e8 26 df ff ff       	call   8000e7 <_panic>

008021c1 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8021c1:	f3 0f 1e fb          	endbr32 
  8021c5:	55                   	push   %ebp
  8021c6:	89 e5                	mov    %esp,%ebp
  8021c8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8021cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ce:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8021d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d6:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8021db:	8b 45 10             	mov    0x10(%ebp),%eax
  8021de:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8021e3:	b8 09 00 00 00       	mov    $0x9,%eax
  8021e8:	e8 7d fd ff ff       	call   801f6a <nsipc>
}
  8021ed:	c9                   	leave  
  8021ee:	c3                   	ret    

008021ef <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8021ef:	f3 0f 1e fb          	endbr32 
  8021f3:	55                   	push   %ebp
  8021f4:	89 e5                	mov    %esp,%ebp
  8021f6:	56                   	push   %esi
  8021f7:	53                   	push   %ebx
  8021f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8021fb:	83 ec 0c             	sub    $0xc,%esp
  8021fe:	ff 75 08             	pushl  0x8(%ebp)
  802201:	e8 e8 ec ff ff       	call   800eee <fd2data>
  802206:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802208:	83 c4 08             	add    $0x8,%esp
  80220b:	68 03 30 80 00       	push   $0x803003
  802210:	53                   	push   %ebx
  802211:	e8 c2 e5 ff ff       	call   8007d8 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802216:	8b 46 04             	mov    0x4(%esi),%eax
  802219:	2b 06                	sub    (%esi),%eax
  80221b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802221:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802228:	00 00 00 
	stat->st_dev = &devpipe;
  80222b:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802232:	40 80 00 
	return 0;
}
  802235:	b8 00 00 00 00       	mov    $0x0,%eax
  80223a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80223d:	5b                   	pop    %ebx
  80223e:	5e                   	pop    %esi
  80223f:	5d                   	pop    %ebp
  802240:	c3                   	ret    

00802241 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802241:	f3 0f 1e fb          	endbr32 
  802245:	55                   	push   %ebp
  802246:	89 e5                	mov    %esp,%ebp
  802248:	53                   	push   %ebx
  802249:	83 ec 0c             	sub    $0xc,%esp
  80224c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80224f:	53                   	push   %ebx
  802250:	6a 00                	push   $0x0
  802252:	e8 50 ea ff ff       	call   800ca7 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802257:	89 1c 24             	mov    %ebx,(%esp)
  80225a:	e8 8f ec ff ff       	call   800eee <fd2data>
  80225f:	83 c4 08             	add    $0x8,%esp
  802262:	50                   	push   %eax
  802263:	6a 00                	push   $0x0
  802265:	e8 3d ea ff ff       	call   800ca7 <sys_page_unmap>
}
  80226a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80226d:	c9                   	leave  
  80226e:	c3                   	ret    

0080226f <_pipeisclosed>:
{
  80226f:	55                   	push   %ebp
  802270:	89 e5                	mov    %esp,%ebp
  802272:	57                   	push   %edi
  802273:	56                   	push   %esi
  802274:	53                   	push   %ebx
  802275:	83 ec 1c             	sub    $0x1c,%esp
  802278:	89 c7                	mov    %eax,%edi
  80227a:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80227c:	a1 08 50 80 00       	mov    0x805008,%eax
  802281:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802284:	83 ec 0c             	sub    $0xc,%esp
  802287:	57                   	push   %edi
  802288:	e8 77 05 00 00       	call   802804 <pageref>
  80228d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802290:	89 34 24             	mov    %esi,(%esp)
  802293:	e8 6c 05 00 00       	call   802804 <pageref>
		nn = thisenv->env_runs;
  802298:	8b 15 08 50 80 00    	mov    0x805008,%edx
  80229e:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8022a1:	83 c4 10             	add    $0x10,%esp
  8022a4:	39 cb                	cmp    %ecx,%ebx
  8022a6:	74 1b                	je     8022c3 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8022a8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8022ab:	75 cf                	jne    80227c <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8022ad:	8b 42 58             	mov    0x58(%edx),%eax
  8022b0:	6a 01                	push   $0x1
  8022b2:	50                   	push   %eax
  8022b3:	53                   	push   %ebx
  8022b4:	68 0a 30 80 00       	push   $0x80300a
  8022b9:	e8 10 df ff ff       	call   8001ce <cprintf>
  8022be:	83 c4 10             	add    $0x10,%esp
  8022c1:	eb b9                	jmp    80227c <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8022c3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8022c6:	0f 94 c0             	sete   %al
  8022c9:	0f b6 c0             	movzbl %al,%eax
}
  8022cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022cf:	5b                   	pop    %ebx
  8022d0:	5e                   	pop    %esi
  8022d1:	5f                   	pop    %edi
  8022d2:	5d                   	pop    %ebp
  8022d3:	c3                   	ret    

008022d4 <devpipe_write>:
{
  8022d4:	f3 0f 1e fb          	endbr32 
  8022d8:	55                   	push   %ebp
  8022d9:	89 e5                	mov    %esp,%ebp
  8022db:	57                   	push   %edi
  8022dc:	56                   	push   %esi
  8022dd:	53                   	push   %ebx
  8022de:	83 ec 28             	sub    $0x28,%esp
  8022e1:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8022e4:	56                   	push   %esi
  8022e5:	e8 04 ec ff ff       	call   800eee <fd2data>
  8022ea:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8022ec:	83 c4 10             	add    $0x10,%esp
  8022ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8022f4:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8022f7:	74 4f                	je     802348 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8022f9:	8b 43 04             	mov    0x4(%ebx),%eax
  8022fc:	8b 0b                	mov    (%ebx),%ecx
  8022fe:	8d 51 20             	lea    0x20(%ecx),%edx
  802301:	39 d0                	cmp    %edx,%eax
  802303:	72 14                	jb     802319 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  802305:	89 da                	mov    %ebx,%edx
  802307:	89 f0                	mov    %esi,%eax
  802309:	e8 61 ff ff ff       	call   80226f <_pipeisclosed>
  80230e:	85 c0                	test   %eax,%eax
  802310:	75 3b                	jne    80234d <devpipe_write+0x79>
			sys_yield();
  802312:	e8 e0 e8 ff ff       	call   800bf7 <sys_yield>
  802317:	eb e0                	jmp    8022f9 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802319:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80231c:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802320:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802323:	89 c2                	mov    %eax,%edx
  802325:	c1 fa 1f             	sar    $0x1f,%edx
  802328:	89 d1                	mov    %edx,%ecx
  80232a:	c1 e9 1b             	shr    $0x1b,%ecx
  80232d:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802330:	83 e2 1f             	and    $0x1f,%edx
  802333:	29 ca                	sub    %ecx,%edx
  802335:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802339:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80233d:	83 c0 01             	add    $0x1,%eax
  802340:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802343:	83 c7 01             	add    $0x1,%edi
  802346:	eb ac                	jmp    8022f4 <devpipe_write+0x20>
	return i;
  802348:	8b 45 10             	mov    0x10(%ebp),%eax
  80234b:	eb 05                	jmp    802352 <devpipe_write+0x7e>
				return 0;
  80234d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802352:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802355:	5b                   	pop    %ebx
  802356:	5e                   	pop    %esi
  802357:	5f                   	pop    %edi
  802358:	5d                   	pop    %ebp
  802359:	c3                   	ret    

0080235a <devpipe_read>:
{
  80235a:	f3 0f 1e fb          	endbr32 
  80235e:	55                   	push   %ebp
  80235f:	89 e5                	mov    %esp,%ebp
  802361:	57                   	push   %edi
  802362:	56                   	push   %esi
  802363:	53                   	push   %ebx
  802364:	83 ec 18             	sub    $0x18,%esp
  802367:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80236a:	57                   	push   %edi
  80236b:	e8 7e eb ff ff       	call   800eee <fd2data>
  802370:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802372:	83 c4 10             	add    $0x10,%esp
  802375:	be 00 00 00 00       	mov    $0x0,%esi
  80237a:	3b 75 10             	cmp    0x10(%ebp),%esi
  80237d:	75 14                	jne    802393 <devpipe_read+0x39>
	return i;
  80237f:	8b 45 10             	mov    0x10(%ebp),%eax
  802382:	eb 02                	jmp    802386 <devpipe_read+0x2c>
				return i;
  802384:	89 f0                	mov    %esi,%eax
}
  802386:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802389:	5b                   	pop    %ebx
  80238a:	5e                   	pop    %esi
  80238b:	5f                   	pop    %edi
  80238c:	5d                   	pop    %ebp
  80238d:	c3                   	ret    
			sys_yield();
  80238e:	e8 64 e8 ff ff       	call   800bf7 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802393:	8b 03                	mov    (%ebx),%eax
  802395:	3b 43 04             	cmp    0x4(%ebx),%eax
  802398:	75 18                	jne    8023b2 <devpipe_read+0x58>
			if (i > 0)
  80239a:	85 f6                	test   %esi,%esi
  80239c:	75 e6                	jne    802384 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  80239e:	89 da                	mov    %ebx,%edx
  8023a0:	89 f8                	mov    %edi,%eax
  8023a2:	e8 c8 fe ff ff       	call   80226f <_pipeisclosed>
  8023a7:	85 c0                	test   %eax,%eax
  8023a9:	74 e3                	je     80238e <devpipe_read+0x34>
				return 0;
  8023ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b0:	eb d4                	jmp    802386 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8023b2:	99                   	cltd   
  8023b3:	c1 ea 1b             	shr    $0x1b,%edx
  8023b6:	01 d0                	add    %edx,%eax
  8023b8:	83 e0 1f             	and    $0x1f,%eax
  8023bb:	29 d0                	sub    %edx,%eax
  8023bd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8023c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023c5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8023c8:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8023cb:	83 c6 01             	add    $0x1,%esi
  8023ce:	eb aa                	jmp    80237a <devpipe_read+0x20>

008023d0 <pipe>:
{
  8023d0:	f3 0f 1e fb          	endbr32 
  8023d4:	55                   	push   %ebp
  8023d5:	89 e5                	mov    %esp,%ebp
  8023d7:	56                   	push   %esi
  8023d8:	53                   	push   %ebx
  8023d9:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8023dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023df:	50                   	push   %eax
  8023e0:	e8 24 eb ff ff       	call   800f09 <fd_alloc>
  8023e5:	89 c3                	mov    %eax,%ebx
  8023e7:	83 c4 10             	add    $0x10,%esp
  8023ea:	85 c0                	test   %eax,%eax
  8023ec:	0f 88 23 01 00 00    	js     802515 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023f2:	83 ec 04             	sub    $0x4,%esp
  8023f5:	68 07 04 00 00       	push   $0x407
  8023fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8023fd:	6a 00                	push   $0x0
  8023ff:	e8 16 e8 ff ff       	call   800c1a <sys_page_alloc>
  802404:	89 c3                	mov    %eax,%ebx
  802406:	83 c4 10             	add    $0x10,%esp
  802409:	85 c0                	test   %eax,%eax
  80240b:	0f 88 04 01 00 00    	js     802515 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  802411:	83 ec 0c             	sub    $0xc,%esp
  802414:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802417:	50                   	push   %eax
  802418:	e8 ec ea ff ff       	call   800f09 <fd_alloc>
  80241d:	89 c3                	mov    %eax,%ebx
  80241f:	83 c4 10             	add    $0x10,%esp
  802422:	85 c0                	test   %eax,%eax
  802424:	0f 88 db 00 00 00    	js     802505 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80242a:	83 ec 04             	sub    $0x4,%esp
  80242d:	68 07 04 00 00       	push   $0x407
  802432:	ff 75 f0             	pushl  -0x10(%ebp)
  802435:	6a 00                	push   $0x0
  802437:	e8 de e7 ff ff       	call   800c1a <sys_page_alloc>
  80243c:	89 c3                	mov    %eax,%ebx
  80243e:	83 c4 10             	add    $0x10,%esp
  802441:	85 c0                	test   %eax,%eax
  802443:	0f 88 bc 00 00 00    	js     802505 <pipe+0x135>
	va = fd2data(fd0);
  802449:	83 ec 0c             	sub    $0xc,%esp
  80244c:	ff 75 f4             	pushl  -0xc(%ebp)
  80244f:	e8 9a ea ff ff       	call   800eee <fd2data>
  802454:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802456:	83 c4 0c             	add    $0xc,%esp
  802459:	68 07 04 00 00       	push   $0x407
  80245e:	50                   	push   %eax
  80245f:	6a 00                	push   $0x0
  802461:	e8 b4 e7 ff ff       	call   800c1a <sys_page_alloc>
  802466:	89 c3                	mov    %eax,%ebx
  802468:	83 c4 10             	add    $0x10,%esp
  80246b:	85 c0                	test   %eax,%eax
  80246d:	0f 88 82 00 00 00    	js     8024f5 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802473:	83 ec 0c             	sub    $0xc,%esp
  802476:	ff 75 f0             	pushl  -0x10(%ebp)
  802479:	e8 70 ea ff ff       	call   800eee <fd2data>
  80247e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802485:	50                   	push   %eax
  802486:	6a 00                	push   $0x0
  802488:	56                   	push   %esi
  802489:	6a 00                	push   $0x0
  80248b:	e8 d1 e7 ff ff       	call   800c61 <sys_page_map>
  802490:	89 c3                	mov    %eax,%ebx
  802492:	83 c4 20             	add    $0x20,%esp
  802495:	85 c0                	test   %eax,%eax
  802497:	78 4e                	js     8024e7 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  802499:	a1 3c 40 80 00       	mov    0x80403c,%eax
  80249e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a1:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8024a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a6:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8024ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024b0:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8024b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8024bc:	83 ec 0c             	sub    $0xc,%esp
  8024bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8024c2:	e8 13 ea ff ff       	call   800eda <fd2num>
  8024c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024ca:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8024cc:	83 c4 04             	add    $0x4,%esp
  8024cf:	ff 75 f0             	pushl  -0x10(%ebp)
  8024d2:	e8 03 ea ff ff       	call   800eda <fd2num>
  8024d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024da:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8024dd:	83 c4 10             	add    $0x10,%esp
  8024e0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8024e5:	eb 2e                	jmp    802515 <pipe+0x145>
	sys_page_unmap(0, va);
  8024e7:	83 ec 08             	sub    $0x8,%esp
  8024ea:	56                   	push   %esi
  8024eb:	6a 00                	push   $0x0
  8024ed:	e8 b5 e7 ff ff       	call   800ca7 <sys_page_unmap>
  8024f2:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8024f5:	83 ec 08             	sub    $0x8,%esp
  8024f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8024fb:	6a 00                	push   $0x0
  8024fd:	e8 a5 e7 ff ff       	call   800ca7 <sys_page_unmap>
  802502:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802505:	83 ec 08             	sub    $0x8,%esp
  802508:	ff 75 f4             	pushl  -0xc(%ebp)
  80250b:	6a 00                	push   $0x0
  80250d:	e8 95 e7 ff ff       	call   800ca7 <sys_page_unmap>
  802512:	83 c4 10             	add    $0x10,%esp
}
  802515:	89 d8                	mov    %ebx,%eax
  802517:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80251a:	5b                   	pop    %ebx
  80251b:	5e                   	pop    %esi
  80251c:	5d                   	pop    %ebp
  80251d:	c3                   	ret    

0080251e <pipeisclosed>:
{
  80251e:	f3 0f 1e fb          	endbr32 
  802522:	55                   	push   %ebp
  802523:	89 e5                	mov    %esp,%ebp
  802525:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802528:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80252b:	50                   	push   %eax
  80252c:	ff 75 08             	pushl  0x8(%ebp)
  80252f:	e8 2b ea ff ff       	call   800f5f <fd_lookup>
  802534:	83 c4 10             	add    $0x10,%esp
  802537:	85 c0                	test   %eax,%eax
  802539:	78 18                	js     802553 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  80253b:	83 ec 0c             	sub    $0xc,%esp
  80253e:	ff 75 f4             	pushl  -0xc(%ebp)
  802541:	e8 a8 e9 ff ff       	call   800eee <fd2data>
  802546:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254b:	e8 1f fd ff ff       	call   80226f <_pipeisclosed>
  802550:	83 c4 10             	add    $0x10,%esp
}
  802553:	c9                   	leave  
  802554:	c3                   	ret    

00802555 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802555:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  802559:	b8 00 00 00 00       	mov    $0x0,%eax
  80255e:	c3                   	ret    

0080255f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80255f:	f3 0f 1e fb          	endbr32 
  802563:	55                   	push   %ebp
  802564:	89 e5                	mov    %esp,%ebp
  802566:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802569:	68 22 30 80 00       	push   $0x803022
  80256e:	ff 75 0c             	pushl  0xc(%ebp)
  802571:	e8 62 e2 ff ff       	call   8007d8 <strcpy>
	return 0;
}
  802576:	b8 00 00 00 00       	mov    $0x0,%eax
  80257b:	c9                   	leave  
  80257c:	c3                   	ret    

0080257d <devcons_write>:
{
  80257d:	f3 0f 1e fb          	endbr32 
  802581:	55                   	push   %ebp
  802582:	89 e5                	mov    %esp,%ebp
  802584:	57                   	push   %edi
  802585:	56                   	push   %esi
  802586:	53                   	push   %ebx
  802587:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80258d:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802592:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802598:	3b 75 10             	cmp    0x10(%ebp),%esi
  80259b:	73 31                	jae    8025ce <devcons_write+0x51>
		m = n - tot;
  80259d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8025a0:	29 f3                	sub    %esi,%ebx
  8025a2:	83 fb 7f             	cmp    $0x7f,%ebx
  8025a5:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8025aa:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8025ad:	83 ec 04             	sub    $0x4,%esp
  8025b0:	53                   	push   %ebx
  8025b1:	89 f0                	mov    %esi,%eax
  8025b3:	03 45 0c             	add    0xc(%ebp),%eax
  8025b6:	50                   	push   %eax
  8025b7:	57                   	push   %edi
  8025b8:	e8 d1 e3 ff ff       	call   80098e <memmove>
		sys_cputs(buf, m);
  8025bd:	83 c4 08             	add    $0x8,%esp
  8025c0:	53                   	push   %ebx
  8025c1:	57                   	push   %edi
  8025c2:	e8 83 e5 ff ff       	call   800b4a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8025c7:	01 de                	add    %ebx,%esi
  8025c9:	83 c4 10             	add    $0x10,%esp
  8025cc:	eb ca                	jmp    802598 <devcons_write+0x1b>
}
  8025ce:	89 f0                	mov    %esi,%eax
  8025d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025d3:	5b                   	pop    %ebx
  8025d4:	5e                   	pop    %esi
  8025d5:	5f                   	pop    %edi
  8025d6:	5d                   	pop    %ebp
  8025d7:	c3                   	ret    

008025d8 <devcons_read>:
{
  8025d8:	f3 0f 1e fb          	endbr32 
  8025dc:	55                   	push   %ebp
  8025dd:	89 e5                	mov    %esp,%ebp
  8025df:	83 ec 08             	sub    $0x8,%esp
  8025e2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8025e7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025eb:	74 21                	je     80260e <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8025ed:	e8 7a e5 ff ff       	call   800b6c <sys_cgetc>
  8025f2:	85 c0                	test   %eax,%eax
  8025f4:	75 07                	jne    8025fd <devcons_read+0x25>
		sys_yield();
  8025f6:	e8 fc e5 ff ff       	call   800bf7 <sys_yield>
  8025fb:	eb f0                	jmp    8025ed <devcons_read+0x15>
	if (c < 0)
  8025fd:	78 0f                	js     80260e <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8025ff:	83 f8 04             	cmp    $0x4,%eax
  802602:	74 0c                	je     802610 <devcons_read+0x38>
	*(char*)vbuf = c;
  802604:	8b 55 0c             	mov    0xc(%ebp),%edx
  802607:	88 02                	mov    %al,(%edx)
	return 1;
  802609:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80260e:	c9                   	leave  
  80260f:	c3                   	ret    
		return 0;
  802610:	b8 00 00 00 00       	mov    $0x0,%eax
  802615:	eb f7                	jmp    80260e <devcons_read+0x36>

00802617 <cputchar>:
{
  802617:	f3 0f 1e fb          	endbr32 
  80261b:	55                   	push   %ebp
  80261c:	89 e5                	mov    %esp,%ebp
  80261e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802621:	8b 45 08             	mov    0x8(%ebp),%eax
  802624:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802627:	6a 01                	push   $0x1
  802629:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80262c:	50                   	push   %eax
  80262d:	e8 18 e5 ff ff       	call   800b4a <sys_cputs>
}
  802632:	83 c4 10             	add    $0x10,%esp
  802635:	c9                   	leave  
  802636:	c3                   	ret    

00802637 <getchar>:
{
  802637:	f3 0f 1e fb          	endbr32 
  80263b:	55                   	push   %ebp
  80263c:	89 e5                	mov    %esp,%ebp
  80263e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802641:	6a 01                	push   $0x1
  802643:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802646:	50                   	push   %eax
  802647:	6a 00                	push   $0x0
  802649:	e8 99 eb ff ff       	call   8011e7 <read>
	if (r < 0)
  80264e:	83 c4 10             	add    $0x10,%esp
  802651:	85 c0                	test   %eax,%eax
  802653:	78 06                	js     80265b <getchar+0x24>
	if (r < 1)
  802655:	74 06                	je     80265d <getchar+0x26>
	return c;
  802657:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80265b:	c9                   	leave  
  80265c:	c3                   	ret    
		return -E_EOF;
  80265d:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802662:	eb f7                	jmp    80265b <getchar+0x24>

00802664 <iscons>:
{
  802664:	f3 0f 1e fb          	endbr32 
  802668:	55                   	push   %ebp
  802669:	89 e5                	mov    %esp,%ebp
  80266b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80266e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802671:	50                   	push   %eax
  802672:	ff 75 08             	pushl  0x8(%ebp)
  802675:	e8 e5 e8 ff ff       	call   800f5f <fd_lookup>
  80267a:	83 c4 10             	add    $0x10,%esp
  80267d:	85 c0                	test   %eax,%eax
  80267f:	78 11                	js     802692 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  802681:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802684:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80268a:	39 10                	cmp    %edx,(%eax)
  80268c:	0f 94 c0             	sete   %al
  80268f:	0f b6 c0             	movzbl %al,%eax
}
  802692:	c9                   	leave  
  802693:	c3                   	ret    

00802694 <opencons>:
{
  802694:	f3 0f 1e fb          	endbr32 
  802698:	55                   	push   %ebp
  802699:	89 e5                	mov    %esp,%ebp
  80269b:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80269e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026a1:	50                   	push   %eax
  8026a2:	e8 62 e8 ff ff       	call   800f09 <fd_alloc>
  8026a7:	83 c4 10             	add    $0x10,%esp
  8026aa:	85 c0                	test   %eax,%eax
  8026ac:	78 3a                	js     8026e8 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8026ae:	83 ec 04             	sub    $0x4,%esp
  8026b1:	68 07 04 00 00       	push   $0x407
  8026b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8026b9:	6a 00                	push   $0x0
  8026bb:	e8 5a e5 ff ff       	call   800c1a <sys_page_alloc>
  8026c0:	83 c4 10             	add    $0x10,%esp
  8026c3:	85 c0                	test   %eax,%eax
  8026c5:	78 21                	js     8026e8 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8026c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ca:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8026d0:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8026d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8026dc:	83 ec 0c             	sub    $0xc,%esp
  8026df:	50                   	push   %eax
  8026e0:	e8 f5 e7 ff ff       	call   800eda <fd2num>
  8026e5:	83 c4 10             	add    $0x10,%esp
}
  8026e8:	c9                   	leave  
  8026e9:	c3                   	ret    

008026ea <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8026ea:	f3 0f 1e fb          	endbr32 
  8026ee:	55                   	push   %ebp
  8026ef:	89 e5                	mov    %esp,%ebp
  8026f1:	56                   	push   %esi
  8026f2:	53                   	push   %ebx
  8026f3:	8b 75 08             	mov    0x8(%ebp),%esi
  8026f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026f9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  8026fc:	85 c0                	test   %eax,%eax
  8026fe:	74 3d                	je     80273d <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  802700:	83 ec 0c             	sub    $0xc,%esp
  802703:	50                   	push   %eax
  802704:	e8 dd e6 ff ff       	call   800de6 <sys_ipc_recv>
  802709:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  80270c:	85 f6                	test   %esi,%esi
  80270e:	74 0b                	je     80271b <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  802710:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802716:	8b 52 74             	mov    0x74(%edx),%edx
  802719:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  80271b:	85 db                	test   %ebx,%ebx
  80271d:	74 0b                	je     80272a <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  80271f:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802725:	8b 52 78             	mov    0x78(%edx),%edx
  802728:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  80272a:	85 c0                	test   %eax,%eax
  80272c:	78 21                	js     80274f <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  80272e:	a1 08 50 80 00       	mov    0x805008,%eax
  802733:	8b 40 70             	mov    0x70(%eax),%eax
}
  802736:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802739:	5b                   	pop    %ebx
  80273a:	5e                   	pop    %esi
  80273b:	5d                   	pop    %ebp
  80273c:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  80273d:	83 ec 0c             	sub    $0xc,%esp
  802740:	68 00 00 c0 ee       	push   $0xeec00000
  802745:	e8 9c e6 ff ff       	call   800de6 <sys_ipc_recv>
  80274a:	83 c4 10             	add    $0x10,%esp
  80274d:	eb bd                	jmp    80270c <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  80274f:	85 f6                	test   %esi,%esi
  802751:	74 10                	je     802763 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  802753:	85 db                	test   %ebx,%ebx
  802755:	75 df                	jne    802736 <ipc_recv+0x4c>
  802757:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80275e:	00 00 00 
  802761:	eb d3                	jmp    802736 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  802763:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80276a:	00 00 00 
  80276d:	eb e4                	jmp    802753 <ipc_recv+0x69>

0080276f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80276f:	f3 0f 1e fb          	endbr32 
  802773:	55                   	push   %ebp
  802774:	89 e5                	mov    %esp,%ebp
  802776:	57                   	push   %edi
  802777:	56                   	push   %esi
  802778:	53                   	push   %ebx
  802779:	83 ec 0c             	sub    $0xc,%esp
  80277c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80277f:	8b 75 0c             	mov    0xc(%ebp),%esi
  802782:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  802785:	85 db                	test   %ebx,%ebx
  802787:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80278c:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  80278f:	ff 75 14             	pushl  0x14(%ebp)
  802792:	53                   	push   %ebx
  802793:	56                   	push   %esi
  802794:	57                   	push   %edi
  802795:	e8 25 e6 ff ff       	call   800dbf <sys_ipc_try_send>
  80279a:	83 c4 10             	add    $0x10,%esp
  80279d:	85 c0                	test   %eax,%eax
  80279f:	79 1e                	jns    8027bf <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  8027a1:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8027a4:	75 07                	jne    8027ad <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  8027a6:	e8 4c e4 ff ff       	call   800bf7 <sys_yield>
  8027ab:	eb e2                	jmp    80278f <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  8027ad:	50                   	push   %eax
  8027ae:	68 2e 30 80 00       	push   $0x80302e
  8027b3:	6a 59                	push   $0x59
  8027b5:	68 49 30 80 00       	push   $0x803049
  8027ba:	e8 28 d9 ff ff       	call   8000e7 <_panic>
	}
}
  8027bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027c2:	5b                   	pop    %ebx
  8027c3:	5e                   	pop    %esi
  8027c4:	5f                   	pop    %edi
  8027c5:	5d                   	pop    %ebp
  8027c6:	c3                   	ret    

008027c7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8027c7:	f3 0f 1e fb          	endbr32 
  8027cb:	55                   	push   %ebp
  8027cc:	89 e5                	mov    %esp,%ebp
  8027ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8027d1:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8027d6:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8027d9:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8027df:	8b 52 50             	mov    0x50(%edx),%edx
  8027e2:	39 ca                	cmp    %ecx,%edx
  8027e4:	74 11                	je     8027f7 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8027e6:	83 c0 01             	add    $0x1,%eax
  8027e9:	3d 00 04 00 00       	cmp    $0x400,%eax
  8027ee:	75 e6                	jne    8027d6 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8027f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f5:	eb 0b                	jmp    802802 <ipc_find_env+0x3b>
			return envs[i].env_id;
  8027f7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8027fa:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8027ff:	8b 40 48             	mov    0x48(%eax),%eax
}
  802802:	5d                   	pop    %ebp
  802803:	c3                   	ret    

00802804 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802804:	f3 0f 1e fb          	endbr32 
  802808:	55                   	push   %ebp
  802809:	89 e5                	mov    %esp,%ebp
  80280b:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80280e:	89 c2                	mov    %eax,%edx
  802810:	c1 ea 16             	shr    $0x16,%edx
  802813:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80281a:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  80281f:	f6 c1 01             	test   $0x1,%cl
  802822:	74 1c                	je     802840 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802824:	c1 e8 0c             	shr    $0xc,%eax
  802827:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80282e:	a8 01                	test   $0x1,%al
  802830:	74 0e                	je     802840 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802832:	c1 e8 0c             	shr    $0xc,%eax
  802835:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80283c:	ef 
  80283d:	0f b7 d2             	movzwl %dx,%edx
}
  802840:	89 d0                	mov    %edx,%eax
  802842:	5d                   	pop    %ebp
  802843:	c3                   	ret    
  802844:	66 90                	xchg   %ax,%ax
  802846:	66 90                	xchg   %ax,%ax
  802848:	66 90                	xchg   %ax,%ax
  80284a:	66 90                	xchg   %ax,%ax
  80284c:	66 90                	xchg   %ax,%ax
  80284e:	66 90                	xchg   %ax,%ax

00802850 <__udivdi3>:
  802850:	f3 0f 1e fb          	endbr32 
  802854:	55                   	push   %ebp
  802855:	57                   	push   %edi
  802856:	56                   	push   %esi
  802857:	53                   	push   %ebx
  802858:	83 ec 1c             	sub    $0x1c,%esp
  80285b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80285f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802863:	8b 74 24 34          	mov    0x34(%esp),%esi
  802867:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80286b:	85 d2                	test   %edx,%edx
  80286d:	75 19                	jne    802888 <__udivdi3+0x38>
  80286f:	39 f3                	cmp    %esi,%ebx
  802871:	76 4d                	jbe    8028c0 <__udivdi3+0x70>
  802873:	31 ff                	xor    %edi,%edi
  802875:	89 e8                	mov    %ebp,%eax
  802877:	89 f2                	mov    %esi,%edx
  802879:	f7 f3                	div    %ebx
  80287b:	89 fa                	mov    %edi,%edx
  80287d:	83 c4 1c             	add    $0x1c,%esp
  802880:	5b                   	pop    %ebx
  802881:	5e                   	pop    %esi
  802882:	5f                   	pop    %edi
  802883:	5d                   	pop    %ebp
  802884:	c3                   	ret    
  802885:	8d 76 00             	lea    0x0(%esi),%esi
  802888:	39 f2                	cmp    %esi,%edx
  80288a:	76 14                	jbe    8028a0 <__udivdi3+0x50>
  80288c:	31 ff                	xor    %edi,%edi
  80288e:	31 c0                	xor    %eax,%eax
  802890:	89 fa                	mov    %edi,%edx
  802892:	83 c4 1c             	add    $0x1c,%esp
  802895:	5b                   	pop    %ebx
  802896:	5e                   	pop    %esi
  802897:	5f                   	pop    %edi
  802898:	5d                   	pop    %ebp
  802899:	c3                   	ret    
  80289a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8028a0:	0f bd fa             	bsr    %edx,%edi
  8028a3:	83 f7 1f             	xor    $0x1f,%edi
  8028a6:	75 48                	jne    8028f0 <__udivdi3+0xa0>
  8028a8:	39 f2                	cmp    %esi,%edx
  8028aa:	72 06                	jb     8028b2 <__udivdi3+0x62>
  8028ac:	31 c0                	xor    %eax,%eax
  8028ae:	39 eb                	cmp    %ebp,%ebx
  8028b0:	77 de                	ja     802890 <__udivdi3+0x40>
  8028b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8028b7:	eb d7                	jmp    802890 <__udivdi3+0x40>
  8028b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028c0:	89 d9                	mov    %ebx,%ecx
  8028c2:	85 db                	test   %ebx,%ebx
  8028c4:	75 0b                	jne    8028d1 <__udivdi3+0x81>
  8028c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8028cb:	31 d2                	xor    %edx,%edx
  8028cd:	f7 f3                	div    %ebx
  8028cf:	89 c1                	mov    %eax,%ecx
  8028d1:	31 d2                	xor    %edx,%edx
  8028d3:	89 f0                	mov    %esi,%eax
  8028d5:	f7 f1                	div    %ecx
  8028d7:	89 c6                	mov    %eax,%esi
  8028d9:	89 e8                	mov    %ebp,%eax
  8028db:	89 f7                	mov    %esi,%edi
  8028dd:	f7 f1                	div    %ecx
  8028df:	89 fa                	mov    %edi,%edx
  8028e1:	83 c4 1c             	add    $0x1c,%esp
  8028e4:	5b                   	pop    %ebx
  8028e5:	5e                   	pop    %esi
  8028e6:	5f                   	pop    %edi
  8028e7:	5d                   	pop    %ebp
  8028e8:	c3                   	ret    
  8028e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028f0:	89 f9                	mov    %edi,%ecx
  8028f2:	b8 20 00 00 00       	mov    $0x20,%eax
  8028f7:	29 f8                	sub    %edi,%eax
  8028f9:	d3 e2                	shl    %cl,%edx
  8028fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8028ff:	89 c1                	mov    %eax,%ecx
  802901:	89 da                	mov    %ebx,%edx
  802903:	d3 ea                	shr    %cl,%edx
  802905:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802909:	09 d1                	or     %edx,%ecx
  80290b:	89 f2                	mov    %esi,%edx
  80290d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802911:	89 f9                	mov    %edi,%ecx
  802913:	d3 e3                	shl    %cl,%ebx
  802915:	89 c1                	mov    %eax,%ecx
  802917:	d3 ea                	shr    %cl,%edx
  802919:	89 f9                	mov    %edi,%ecx
  80291b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80291f:	89 eb                	mov    %ebp,%ebx
  802921:	d3 e6                	shl    %cl,%esi
  802923:	89 c1                	mov    %eax,%ecx
  802925:	d3 eb                	shr    %cl,%ebx
  802927:	09 de                	or     %ebx,%esi
  802929:	89 f0                	mov    %esi,%eax
  80292b:	f7 74 24 08          	divl   0x8(%esp)
  80292f:	89 d6                	mov    %edx,%esi
  802931:	89 c3                	mov    %eax,%ebx
  802933:	f7 64 24 0c          	mull   0xc(%esp)
  802937:	39 d6                	cmp    %edx,%esi
  802939:	72 15                	jb     802950 <__udivdi3+0x100>
  80293b:	89 f9                	mov    %edi,%ecx
  80293d:	d3 e5                	shl    %cl,%ebp
  80293f:	39 c5                	cmp    %eax,%ebp
  802941:	73 04                	jae    802947 <__udivdi3+0xf7>
  802943:	39 d6                	cmp    %edx,%esi
  802945:	74 09                	je     802950 <__udivdi3+0x100>
  802947:	89 d8                	mov    %ebx,%eax
  802949:	31 ff                	xor    %edi,%edi
  80294b:	e9 40 ff ff ff       	jmp    802890 <__udivdi3+0x40>
  802950:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802953:	31 ff                	xor    %edi,%edi
  802955:	e9 36 ff ff ff       	jmp    802890 <__udivdi3+0x40>
  80295a:	66 90                	xchg   %ax,%ax
  80295c:	66 90                	xchg   %ax,%ax
  80295e:	66 90                	xchg   %ax,%ax

00802960 <__umoddi3>:
  802960:	f3 0f 1e fb          	endbr32 
  802964:	55                   	push   %ebp
  802965:	57                   	push   %edi
  802966:	56                   	push   %esi
  802967:	53                   	push   %ebx
  802968:	83 ec 1c             	sub    $0x1c,%esp
  80296b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80296f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802973:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802977:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80297b:	85 c0                	test   %eax,%eax
  80297d:	75 19                	jne    802998 <__umoddi3+0x38>
  80297f:	39 df                	cmp    %ebx,%edi
  802981:	76 5d                	jbe    8029e0 <__umoddi3+0x80>
  802983:	89 f0                	mov    %esi,%eax
  802985:	89 da                	mov    %ebx,%edx
  802987:	f7 f7                	div    %edi
  802989:	89 d0                	mov    %edx,%eax
  80298b:	31 d2                	xor    %edx,%edx
  80298d:	83 c4 1c             	add    $0x1c,%esp
  802990:	5b                   	pop    %ebx
  802991:	5e                   	pop    %esi
  802992:	5f                   	pop    %edi
  802993:	5d                   	pop    %ebp
  802994:	c3                   	ret    
  802995:	8d 76 00             	lea    0x0(%esi),%esi
  802998:	89 f2                	mov    %esi,%edx
  80299a:	39 d8                	cmp    %ebx,%eax
  80299c:	76 12                	jbe    8029b0 <__umoddi3+0x50>
  80299e:	89 f0                	mov    %esi,%eax
  8029a0:	89 da                	mov    %ebx,%edx
  8029a2:	83 c4 1c             	add    $0x1c,%esp
  8029a5:	5b                   	pop    %ebx
  8029a6:	5e                   	pop    %esi
  8029a7:	5f                   	pop    %edi
  8029a8:	5d                   	pop    %ebp
  8029a9:	c3                   	ret    
  8029aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8029b0:	0f bd e8             	bsr    %eax,%ebp
  8029b3:	83 f5 1f             	xor    $0x1f,%ebp
  8029b6:	75 50                	jne    802a08 <__umoddi3+0xa8>
  8029b8:	39 d8                	cmp    %ebx,%eax
  8029ba:	0f 82 e0 00 00 00    	jb     802aa0 <__umoddi3+0x140>
  8029c0:	89 d9                	mov    %ebx,%ecx
  8029c2:	39 f7                	cmp    %esi,%edi
  8029c4:	0f 86 d6 00 00 00    	jbe    802aa0 <__umoddi3+0x140>
  8029ca:	89 d0                	mov    %edx,%eax
  8029cc:	89 ca                	mov    %ecx,%edx
  8029ce:	83 c4 1c             	add    $0x1c,%esp
  8029d1:	5b                   	pop    %ebx
  8029d2:	5e                   	pop    %esi
  8029d3:	5f                   	pop    %edi
  8029d4:	5d                   	pop    %ebp
  8029d5:	c3                   	ret    
  8029d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029dd:	8d 76 00             	lea    0x0(%esi),%esi
  8029e0:	89 fd                	mov    %edi,%ebp
  8029e2:	85 ff                	test   %edi,%edi
  8029e4:	75 0b                	jne    8029f1 <__umoddi3+0x91>
  8029e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8029eb:	31 d2                	xor    %edx,%edx
  8029ed:	f7 f7                	div    %edi
  8029ef:	89 c5                	mov    %eax,%ebp
  8029f1:	89 d8                	mov    %ebx,%eax
  8029f3:	31 d2                	xor    %edx,%edx
  8029f5:	f7 f5                	div    %ebp
  8029f7:	89 f0                	mov    %esi,%eax
  8029f9:	f7 f5                	div    %ebp
  8029fb:	89 d0                	mov    %edx,%eax
  8029fd:	31 d2                	xor    %edx,%edx
  8029ff:	eb 8c                	jmp    80298d <__umoddi3+0x2d>
  802a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a08:	89 e9                	mov    %ebp,%ecx
  802a0a:	ba 20 00 00 00       	mov    $0x20,%edx
  802a0f:	29 ea                	sub    %ebp,%edx
  802a11:	d3 e0                	shl    %cl,%eax
  802a13:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a17:	89 d1                	mov    %edx,%ecx
  802a19:	89 f8                	mov    %edi,%eax
  802a1b:	d3 e8                	shr    %cl,%eax
  802a1d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a21:	89 54 24 04          	mov    %edx,0x4(%esp)
  802a25:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a29:	09 c1                	or     %eax,%ecx
  802a2b:	89 d8                	mov    %ebx,%eax
  802a2d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a31:	89 e9                	mov    %ebp,%ecx
  802a33:	d3 e7                	shl    %cl,%edi
  802a35:	89 d1                	mov    %edx,%ecx
  802a37:	d3 e8                	shr    %cl,%eax
  802a39:	89 e9                	mov    %ebp,%ecx
  802a3b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a3f:	d3 e3                	shl    %cl,%ebx
  802a41:	89 c7                	mov    %eax,%edi
  802a43:	89 d1                	mov    %edx,%ecx
  802a45:	89 f0                	mov    %esi,%eax
  802a47:	d3 e8                	shr    %cl,%eax
  802a49:	89 e9                	mov    %ebp,%ecx
  802a4b:	89 fa                	mov    %edi,%edx
  802a4d:	d3 e6                	shl    %cl,%esi
  802a4f:	09 d8                	or     %ebx,%eax
  802a51:	f7 74 24 08          	divl   0x8(%esp)
  802a55:	89 d1                	mov    %edx,%ecx
  802a57:	89 f3                	mov    %esi,%ebx
  802a59:	f7 64 24 0c          	mull   0xc(%esp)
  802a5d:	89 c6                	mov    %eax,%esi
  802a5f:	89 d7                	mov    %edx,%edi
  802a61:	39 d1                	cmp    %edx,%ecx
  802a63:	72 06                	jb     802a6b <__umoddi3+0x10b>
  802a65:	75 10                	jne    802a77 <__umoddi3+0x117>
  802a67:	39 c3                	cmp    %eax,%ebx
  802a69:	73 0c                	jae    802a77 <__umoddi3+0x117>
  802a6b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802a6f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802a73:	89 d7                	mov    %edx,%edi
  802a75:	89 c6                	mov    %eax,%esi
  802a77:	89 ca                	mov    %ecx,%edx
  802a79:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802a7e:	29 f3                	sub    %esi,%ebx
  802a80:	19 fa                	sbb    %edi,%edx
  802a82:	89 d0                	mov    %edx,%eax
  802a84:	d3 e0                	shl    %cl,%eax
  802a86:	89 e9                	mov    %ebp,%ecx
  802a88:	d3 eb                	shr    %cl,%ebx
  802a8a:	d3 ea                	shr    %cl,%edx
  802a8c:	09 d8                	or     %ebx,%eax
  802a8e:	83 c4 1c             	add    $0x1c,%esp
  802a91:	5b                   	pop    %ebx
  802a92:	5e                   	pop    %esi
  802a93:	5f                   	pop    %edi
  802a94:	5d                   	pop    %ebp
  802a95:	c3                   	ret    
  802a96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a9d:	8d 76 00             	lea    0x0(%esi),%esi
  802aa0:	29 fe                	sub    %edi,%esi
  802aa2:	19 c3                	sbb    %eax,%ebx
  802aa4:	89 f2                	mov    %esi,%edx
  802aa6:	89 d9                	mov    %ebx,%ecx
  802aa8:	e9 1d ff ff ff       	jmp    8029ca <__umoddi3+0x6a>
