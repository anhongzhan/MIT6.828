
obj/user/faultread:     file format elf32-i386


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
  80002c:	e8 36 00 00 00       	call   800067 <libmain>
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
  80003b:	83 ec 0c             	sub    $0xc,%esp
  80003e:	e8 20 00 00 00       	call   800063 <__x86.get_pc_thunk.bx>
  800043:	81 c3 bd 1f 00 00    	add    $0x1fbd,%ebx
	cprintf("I read %08x from location 0!\n", *(unsigned*)0);
  800049:	ff 35 00 00 00 00    	pushl  0x0
  80004f:	8d 83 40 ef ff ff    	lea    -0x10c0(%ebx),%eax
  800055:	50                   	push   %eax
  800056:	e8 4c 01 00 00       	call   8001a7 <cprintf>
}
  80005b:	83 c4 10             	add    $0x10,%esp
  80005e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800061:	c9                   	leave  
  800062:	c3                   	ret    

00800063 <__x86.get_pc_thunk.bx>:
  800063:	8b 1c 24             	mov    (%esp),%ebx
  800066:	c3                   	ret    

00800067 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800067:	f3 0f 1e fb          	endbr32 
  80006b:	55                   	push   %ebp
  80006c:	89 e5                	mov    %esp,%ebp
  80006e:	57                   	push   %edi
  80006f:	56                   	push   %esi
  800070:	53                   	push   %ebx
  800071:	83 ec 0c             	sub    $0xc,%esp
  800074:	e8 ea ff ff ff       	call   800063 <__x86.get_pc_thunk.bx>
  800079:	81 c3 87 1f 00 00    	add    $0x1f87,%ebx
  80007f:	8b 75 08             	mov    0x8(%ebp),%esi
  800082:	8b 7d 0c             	mov    0xc(%ebp),%edi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800085:	e8 c6 0b 00 00       	call   800c50 <sys_getenvid>
  80008a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80008f:	8d 04 40             	lea    (%eax,%eax,2),%eax
  800092:	c1 e0 05             	shl    $0x5,%eax
  800095:	81 c0 00 00 c0 ee    	add    $0xeec00000,%eax
  80009b:	c7 c2 2c 20 80 00    	mov    $0x80202c,%edx
  8000a1:	89 02                	mov    %eax,(%edx)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a3:	85 f6                	test   %esi,%esi
  8000a5:	7e 08                	jle    8000af <libmain+0x48>
		binaryname = argv[0];
  8000a7:	8b 07                	mov    (%edi),%eax
  8000a9:	89 83 0c 00 00 00    	mov    %eax,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	57                   	push   %edi
  8000b3:	56                   	push   %esi
  8000b4:	e8 7a ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000b9:	e8 0b 00 00 00       	call   8000c9 <exit>
}
  8000be:	83 c4 10             	add    $0x10,%esp
  8000c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000c4:	5b                   	pop    %ebx
  8000c5:	5e                   	pop    %esi
  8000c6:	5f                   	pop    %edi
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
  8000d0:	53                   	push   %ebx
  8000d1:	83 ec 10             	sub    $0x10,%esp
  8000d4:	e8 8a ff ff ff       	call   800063 <__x86.get_pc_thunk.bx>
  8000d9:	81 c3 27 1f 00 00    	add    $0x1f27,%ebx
	sys_env_destroy(0);
  8000df:	6a 00                	push   $0x0
  8000e1:	e8 11 0b 00 00       	call   800bf7 <sys_env_destroy>
}
  8000e6:	83 c4 10             	add    $0x10,%esp
  8000e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000ec:	c9                   	leave  
  8000ed:	c3                   	ret    

008000ee <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000ee:	f3 0f 1e fb          	endbr32 
  8000f2:	55                   	push   %ebp
  8000f3:	89 e5                	mov    %esp,%ebp
  8000f5:	56                   	push   %esi
  8000f6:	53                   	push   %ebx
  8000f7:	e8 67 ff ff ff       	call   800063 <__x86.get_pc_thunk.bx>
  8000fc:	81 c3 04 1f 00 00    	add    $0x1f04,%ebx
  800102:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
  800105:	8b 16                	mov    (%esi),%edx
  800107:	8d 42 01             	lea    0x1(%edx),%eax
  80010a:	89 06                	mov    %eax,(%esi)
  80010c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80010f:	88 4c 16 08          	mov    %cl,0x8(%esi,%edx,1)
	if (b->idx == 256-1) {
  800113:	3d ff 00 00 00       	cmp    $0xff,%eax
  800118:	74 0b                	je     800125 <putch+0x37>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80011a:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  80011e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800121:	5b                   	pop    %ebx
  800122:	5e                   	pop    %esi
  800123:	5d                   	pop    %ebp
  800124:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800125:	83 ec 08             	sub    $0x8,%esp
  800128:	68 ff 00 00 00       	push   $0xff
  80012d:	8d 46 08             	lea    0x8(%esi),%eax
  800130:	50                   	push   %eax
  800131:	e8 7c 0a 00 00       	call   800bb2 <sys_cputs>
		b->idx = 0;
  800136:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  80013c:	83 c4 10             	add    $0x10,%esp
  80013f:	eb d9                	jmp    80011a <putch+0x2c>

00800141 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800141:	f3 0f 1e fb          	endbr32 
  800145:	55                   	push   %ebp
  800146:	89 e5                	mov    %esp,%ebp
  800148:	53                   	push   %ebx
  800149:	81 ec 14 01 00 00    	sub    $0x114,%esp
  80014f:	e8 0f ff ff ff       	call   800063 <__x86.get_pc_thunk.bx>
  800154:	81 c3 ac 1e 00 00    	add    $0x1eac,%ebx
	struct printbuf b;

	b.idx = 0;
  80015a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800161:	00 00 00 
	b.cnt = 0;
  800164:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80016b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80016e:	ff 75 0c             	pushl  0xc(%ebp)
  800171:	ff 75 08             	pushl  0x8(%ebp)
  800174:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80017a:	50                   	push   %eax
  80017b:	8d 83 ee e0 ff ff    	lea    -0x1f12(%ebx),%eax
  800181:	50                   	push   %eax
  800182:	e8 38 01 00 00       	call   8002bf <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800187:	83 c4 08             	add    $0x8,%esp
  80018a:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800190:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800196:	50                   	push   %eax
  800197:	e8 16 0a 00 00       	call   800bb2 <sys_cputs>

	return b.cnt;
}
  80019c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001a5:	c9                   	leave  
  8001a6:	c3                   	ret    

008001a7 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001a7:	f3 0f 1e fb          	endbr32 
  8001ab:	55                   	push   %ebp
  8001ac:	89 e5                	mov    %esp,%ebp
  8001ae:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001b1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001b4:	50                   	push   %eax
  8001b5:	ff 75 08             	pushl  0x8(%ebp)
  8001b8:	e8 84 ff ff ff       	call   800141 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001bd:	c9                   	leave  
  8001be:	c3                   	ret    

008001bf <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001bf:	55                   	push   %ebp
  8001c0:	89 e5                	mov    %esp,%ebp
  8001c2:	57                   	push   %edi
  8001c3:	56                   	push   %esi
  8001c4:	53                   	push   %ebx
  8001c5:	83 ec 2c             	sub    $0x2c,%esp
  8001c8:	e8 2c 06 00 00       	call   8007f9 <__x86.get_pc_thunk.cx>
  8001cd:	81 c1 33 1e 00 00    	add    $0x1e33,%ecx
  8001d3:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001d6:	89 c7                	mov    %eax,%edi
  8001d8:	89 d6                	mov    %edx,%esi
  8001da:	8b 45 08             	mov    0x8(%ebp),%eax
  8001dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001e0:	89 d1                	mov    %edx,%ecx
  8001e2:	89 c2                	mov    %eax,%edx
  8001e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8001e7:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8001ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8001ed:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001f3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001fa:	39 c2                	cmp    %eax,%edx
  8001fc:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8001ff:	72 41                	jb     800242 <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800201:	83 ec 0c             	sub    $0xc,%esp
  800204:	ff 75 18             	pushl  0x18(%ebp)
  800207:	83 eb 01             	sub    $0x1,%ebx
  80020a:	53                   	push   %ebx
  80020b:	50                   	push   %eax
  80020c:	83 ec 08             	sub    $0x8,%esp
  80020f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800212:	ff 75 e0             	pushl  -0x20(%ebp)
  800215:	ff 75 d4             	pushl  -0x2c(%ebp)
  800218:	ff 75 d0             	pushl  -0x30(%ebp)
  80021b:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80021e:	e8 bd 0a 00 00       	call   800ce0 <__udivdi3>
  800223:	83 c4 18             	add    $0x18,%esp
  800226:	52                   	push   %edx
  800227:	50                   	push   %eax
  800228:	89 f2                	mov    %esi,%edx
  80022a:	89 f8                	mov    %edi,%eax
  80022c:	e8 8e ff ff ff       	call   8001bf <printnum>
  800231:	83 c4 20             	add    $0x20,%esp
  800234:	eb 13                	jmp    800249 <printnum+0x8a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800236:	83 ec 08             	sub    $0x8,%esp
  800239:	56                   	push   %esi
  80023a:	ff 75 18             	pushl  0x18(%ebp)
  80023d:	ff d7                	call   *%edi
  80023f:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800242:	83 eb 01             	sub    $0x1,%ebx
  800245:	85 db                	test   %ebx,%ebx
  800247:	7f ed                	jg     800236 <printnum+0x77>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800249:	83 ec 08             	sub    $0x8,%esp
  80024c:	56                   	push   %esi
  80024d:	83 ec 04             	sub    $0x4,%esp
  800250:	ff 75 e4             	pushl  -0x1c(%ebp)
  800253:	ff 75 e0             	pushl  -0x20(%ebp)
  800256:	ff 75 d4             	pushl  -0x2c(%ebp)
  800259:	ff 75 d0             	pushl  -0x30(%ebp)
  80025c:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80025f:	e8 8c 0b 00 00       	call   800df0 <__umoddi3>
  800264:	83 c4 14             	add    $0x14,%esp
  800267:	0f be 84 03 68 ef ff 	movsbl -0x1098(%ebx,%eax,1),%eax
  80026e:	ff 
  80026f:	50                   	push   %eax
  800270:	ff d7                	call   *%edi
}
  800272:	83 c4 10             	add    $0x10,%esp
  800275:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800278:	5b                   	pop    %ebx
  800279:	5e                   	pop    %esi
  80027a:	5f                   	pop    %edi
  80027b:	5d                   	pop    %ebp
  80027c:	c3                   	ret    

0080027d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80027d:	f3 0f 1e fb          	endbr32 
  800281:	55                   	push   %ebp
  800282:	89 e5                	mov    %esp,%ebp
  800284:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800287:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80028b:	8b 10                	mov    (%eax),%edx
  80028d:	3b 50 04             	cmp    0x4(%eax),%edx
  800290:	73 0a                	jae    80029c <sprintputch+0x1f>
		*b->buf++ = ch;
  800292:	8d 4a 01             	lea    0x1(%edx),%ecx
  800295:	89 08                	mov    %ecx,(%eax)
  800297:	8b 45 08             	mov    0x8(%ebp),%eax
  80029a:	88 02                	mov    %al,(%edx)
}
  80029c:	5d                   	pop    %ebp
  80029d:	c3                   	ret    

0080029e <printfmt>:
{
  80029e:	f3 0f 1e fb          	endbr32 
  8002a2:	55                   	push   %ebp
  8002a3:	89 e5                	mov    %esp,%ebp
  8002a5:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002a8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002ab:	50                   	push   %eax
  8002ac:	ff 75 10             	pushl  0x10(%ebp)
  8002af:	ff 75 0c             	pushl  0xc(%ebp)
  8002b2:	ff 75 08             	pushl  0x8(%ebp)
  8002b5:	e8 05 00 00 00       	call   8002bf <vprintfmt>
}
  8002ba:	83 c4 10             	add    $0x10,%esp
  8002bd:	c9                   	leave  
  8002be:	c3                   	ret    

008002bf <vprintfmt>:
{
  8002bf:	f3 0f 1e fb          	endbr32 
  8002c3:	55                   	push   %ebp
  8002c4:	89 e5                	mov    %esp,%ebp
  8002c6:	57                   	push   %edi
  8002c7:	56                   	push   %esi
  8002c8:	53                   	push   %ebx
  8002c9:	83 ec 3c             	sub    $0x3c,%esp
  8002cc:	e8 24 05 00 00       	call   8007f5 <__x86.get_pc_thunk.ax>
  8002d1:	05 2f 1d 00 00       	add    $0x1d2f,%eax
  8002d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002d9:	8b 75 08             	mov    0x8(%ebp),%esi
  8002dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8002df:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8002e2:	8d 80 10 00 00 00    	lea    0x10(%eax),%eax
  8002e8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8002eb:	e9 cd 03 00 00       	jmp    8006bd <.L25+0x48>
		padc = ' ';
  8002f0:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		altflag = 0;
  8002f4:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8002fb:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800302:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  800309:	b9 00 00 00 00       	mov    $0x0,%ecx
  80030e:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800311:	89 75 08             	mov    %esi,0x8(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800314:	8d 43 01             	lea    0x1(%ebx),%eax
  800317:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80031a:	0f b6 13             	movzbl (%ebx),%edx
  80031d:	8d 42 dd             	lea    -0x23(%edx),%eax
  800320:	3c 55                	cmp    $0x55,%al
  800322:	0f 87 21 04 00 00    	ja     800749 <.L20>
  800328:	0f b6 c0             	movzbl %al,%eax
  80032b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80032e:	89 ce                	mov    %ecx,%esi
  800330:	03 b4 81 f8 ef ff ff 	add    -0x1008(%ecx,%eax,4),%esi
  800337:	3e ff e6             	notrack jmp *%esi

0080033a <.L68>:
  80033a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			padc = '-';
  80033d:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800341:	eb d1                	jmp    800314 <vprintfmt+0x55>

00800343 <.L32>:
		switch (ch = *(unsigned char *) fmt++) {
  800343:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800346:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80034a:	eb c8                	jmp    800314 <vprintfmt+0x55>

0080034c <.L31>:
  80034c:	0f b6 d2             	movzbl %dl,%edx
  80034f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			for (precision = 0; ; ++fmt) {
  800352:	b8 00 00 00 00       	mov    $0x0,%eax
  800357:	8b 75 08             	mov    0x8(%ebp),%esi
				precision = precision * 10 + ch - '0';
  80035a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80035d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800361:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  800364:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800367:	83 f9 09             	cmp    $0x9,%ecx
  80036a:	77 58                	ja     8003c4 <.L36+0xf>
			for (precision = 0; ; ++fmt) {
  80036c:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  80036f:	eb e9                	jmp    80035a <.L31+0xe>

00800371 <.L34>:
			precision = va_arg(ap, int);
  800371:	8b 45 14             	mov    0x14(%ebp),%eax
  800374:	8b 00                	mov    (%eax),%eax
  800376:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800379:	8b 45 14             	mov    0x14(%ebp),%eax
  80037c:	8d 40 04             	lea    0x4(%eax),%eax
  80037f:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800382:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			if (width < 0)
  800385:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800389:	79 89                	jns    800314 <vprintfmt+0x55>
				width = precision, precision = -1;
  80038b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80038e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800391:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800398:	e9 77 ff ff ff       	jmp    800314 <vprintfmt+0x55>

0080039d <.L33>:
  80039d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003a0:	85 c0                	test   %eax,%eax
  8003a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8003a7:	0f 49 d0             	cmovns %eax,%edx
  8003aa:	89 55 d4             	mov    %edx,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ad:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  8003b0:	e9 5f ff ff ff       	jmp    800314 <vprintfmt+0x55>

008003b5 <.L36>:
		switch (ch = *(unsigned char *) fmt++) {
  8003b5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			altflag = 1;
  8003b8:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003bf:	e9 50 ff ff ff       	jmp    800314 <vprintfmt+0x55>
  8003c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003c7:	89 75 08             	mov    %esi,0x8(%ebp)
  8003ca:	eb b9                	jmp    800385 <.L34+0x14>

008003cc <.L27>:
			lflag++;
  8003cc:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d0:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  8003d3:	e9 3c ff ff ff       	jmp    800314 <vprintfmt+0x55>

008003d8 <.L30>:
  8003d8:	8b 75 08             	mov    0x8(%ebp),%esi
			putch(va_arg(ap, int), putdat);
  8003db:	8b 45 14             	mov    0x14(%ebp),%eax
  8003de:	8d 58 04             	lea    0x4(%eax),%ebx
  8003e1:	83 ec 08             	sub    $0x8,%esp
  8003e4:	57                   	push   %edi
  8003e5:	ff 30                	pushl  (%eax)
  8003e7:	ff d6                	call   *%esi
			break;
  8003e9:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003ec:	89 5d 14             	mov    %ebx,0x14(%ebp)
			break;
  8003ef:	e9 c6 02 00 00       	jmp    8006ba <.L25+0x45>

008003f4 <.L28>:
  8003f4:	8b 75 08             	mov    0x8(%ebp),%esi
			err = va_arg(ap, int);
  8003f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fa:	8d 58 04             	lea    0x4(%eax),%ebx
  8003fd:	8b 00                	mov    (%eax),%eax
  8003ff:	99                   	cltd   
  800400:	31 d0                	xor    %edx,%eax
  800402:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800404:	83 f8 06             	cmp    $0x6,%eax
  800407:	7f 27                	jg     800430 <.L28+0x3c>
  800409:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80040c:	8b 14 82             	mov    (%edx,%eax,4),%edx
  80040f:	85 d2                	test   %edx,%edx
  800411:	74 1d                	je     800430 <.L28+0x3c>
				printfmt(putch, putdat, "%s", p);
  800413:	52                   	push   %edx
  800414:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800417:	8d 80 89 ef ff ff    	lea    -0x1077(%eax),%eax
  80041d:	50                   	push   %eax
  80041e:	57                   	push   %edi
  80041f:	56                   	push   %esi
  800420:	e8 79 fe ff ff       	call   80029e <printfmt>
  800425:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800428:	89 5d 14             	mov    %ebx,0x14(%ebp)
  80042b:	e9 8a 02 00 00       	jmp    8006ba <.L25+0x45>
				printfmt(putch, putdat, "error %d", err);
  800430:	50                   	push   %eax
  800431:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800434:	8d 80 80 ef ff ff    	lea    -0x1080(%eax),%eax
  80043a:	50                   	push   %eax
  80043b:	57                   	push   %edi
  80043c:	56                   	push   %esi
  80043d:	e8 5c fe ff ff       	call   80029e <printfmt>
  800442:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800445:	89 5d 14             	mov    %ebx,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800448:	e9 6d 02 00 00       	jmp    8006ba <.L25+0x45>

0080044d <.L24>:
  80044d:	8b 75 08             	mov    0x8(%ebp),%esi
			if ((p = va_arg(ap, char *)) == NULL)
  800450:	8b 45 14             	mov    0x14(%ebp),%eax
  800453:	83 c0 04             	add    $0x4,%eax
  800456:	89 45 c0             	mov    %eax,-0x40(%ebp)
  800459:	8b 45 14             	mov    0x14(%ebp),%eax
  80045c:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80045e:	85 d2                	test   %edx,%edx
  800460:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800463:	8d 80 79 ef ff ff    	lea    -0x1087(%eax),%eax
  800469:	0f 45 c2             	cmovne %edx,%eax
  80046c:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80046f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800473:	7e 06                	jle    80047b <.L24+0x2e>
  800475:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800479:	75 0d                	jne    800488 <.L24+0x3b>
				for (width -= strnlen(p, precision); width > 0; width--)
  80047b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80047e:	89 c3                	mov    %eax,%ebx
  800480:	03 45 d4             	add    -0x2c(%ebp),%eax
  800483:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800486:	eb 58                	jmp    8004e0 <.L24+0x93>
  800488:	83 ec 08             	sub    $0x8,%esp
  80048b:	ff 75 d8             	pushl  -0x28(%ebp)
  80048e:	ff 75 c8             	pushl  -0x38(%ebp)
  800491:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800494:	e8 80 03 00 00       	call   800819 <strnlen>
  800499:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80049c:	29 c2                	sub    %eax,%edx
  80049e:	89 55 bc             	mov    %edx,-0x44(%ebp)
  8004a1:	83 c4 10             	add    $0x10,%esp
  8004a4:	89 d3                	mov    %edx,%ebx
					putch(padc, putdat);
  8004a6:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004aa:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ad:	85 db                	test   %ebx,%ebx
  8004af:	7e 11                	jle    8004c2 <.L24+0x75>
					putch(padc, putdat);
  8004b1:	83 ec 08             	sub    $0x8,%esp
  8004b4:	57                   	push   %edi
  8004b5:	ff 75 d4             	pushl  -0x2c(%ebp)
  8004b8:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ba:	83 eb 01             	sub    $0x1,%ebx
  8004bd:	83 c4 10             	add    $0x10,%esp
  8004c0:	eb eb                	jmp    8004ad <.L24+0x60>
  8004c2:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8004c5:	85 d2                	test   %edx,%edx
  8004c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8004cc:	0f 49 c2             	cmovns %edx,%eax
  8004cf:	29 c2                	sub    %eax,%edx
  8004d1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8004d4:	eb a5                	jmp    80047b <.L24+0x2e>
					putch(ch, putdat);
  8004d6:	83 ec 08             	sub    $0x8,%esp
  8004d9:	57                   	push   %edi
  8004da:	52                   	push   %edx
  8004db:	ff d6                	call   *%esi
  8004dd:	83 c4 10             	add    $0x10,%esp
  8004e0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8004e3:	29 d9                	sub    %ebx,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004e5:	83 c3 01             	add    $0x1,%ebx
  8004e8:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  8004ec:	0f be d0             	movsbl %al,%edx
  8004ef:	85 d2                	test   %edx,%edx
  8004f1:	74 4b                	je     80053e <.L24+0xf1>
  8004f3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004f7:	78 06                	js     8004ff <.L24+0xb2>
  8004f9:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004fd:	78 1e                	js     80051d <.L24+0xd0>
				if (altflag && (ch < ' ' || ch > '~'))
  8004ff:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800503:	74 d1                	je     8004d6 <.L24+0x89>
  800505:	0f be c0             	movsbl %al,%eax
  800508:	83 e8 20             	sub    $0x20,%eax
  80050b:	83 f8 5e             	cmp    $0x5e,%eax
  80050e:	76 c6                	jbe    8004d6 <.L24+0x89>
					putch('?', putdat);
  800510:	83 ec 08             	sub    $0x8,%esp
  800513:	57                   	push   %edi
  800514:	6a 3f                	push   $0x3f
  800516:	ff d6                	call   *%esi
  800518:	83 c4 10             	add    $0x10,%esp
  80051b:	eb c3                	jmp    8004e0 <.L24+0x93>
  80051d:	89 cb                	mov    %ecx,%ebx
  80051f:	eb 0e                	jmp    80052f <.L24+0xe2>
				putch(' ', putdat);
  800521:	83 ec 08             	sub    $0x8,%esp
  800524:	57                   	push   %edi
  800525:	6a 20                	push   $0x20
  800527:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800529:	83 eb 01             	sub    $0x1,%ebx
  80052c:	83 c4 10             	add    $0x10,%esp
  80052f:	85 db                	test   %ebx,%ebx
  800531:	7f ee                	jg     800521 <.L24+0xd4>
			if ((p = va_arg(ap, char *)) == NULL)
  800533:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800536:	89 45 14             	mov    %eax,0x14(%ebp)
  800539:	e9 7c 01 00 00       	jmp    8006ba <.L25+0x45>
  80053e:	89 cb                	mov    %ecx,%ebx
  800540:	eb ed                	jmp    80052f <.L24+0xe2>

00800542 <.L29>:
  800542:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800545:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  800548:	83 f9 01             	cmp    $0x1,%ecx
  80054b:	7f 1b                	jg     800568 <.L29+0x26>
	else if (lflag)
  80054d:	85 c9                	test   %ecx,%ecx
  80054f:	74 63                	je     8005b4 <.L29+0x72>
		return va_arg(*ap, long);
  800551:	8b 45 14             	mov    0x14(%ebp),%eax
  800554:	8b 00                	mov    (%eax),%eax
  800556:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800559:	99                   	cltd   
  80055a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80055d:	8b 45 14             	mov    0x14(%ebp),%eax
  800560:	8d 40 04             	lea    0x4(%eax),%eax
  800563:	89 45 14             	mov    %eax,0x14(%ebp)
  800566:	eb 17                	jmp    80057f <.L29+0x3d>
		return va_arg(*ap, long long);
  800568:	8b 45 14             	mov    0x14(%ebp),%eax
  80056b:	8b 50 04             	mov    0x4(%eax),%edx
  80056e:	8b 00                	mov    (%eax),%eax
  800570:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800573:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800576:	8b 45 14             	mov    0x14(%ebp),%eax
  800579:	8d 40 08             	lea    0x8(%eax),%eax
  80057c:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80057f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800582:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800585:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80058a:	85 c9                	test   %ecx,%ecx
  80058c:	0f 89 0e 01 00 00    	jns    8006a0 <.L25+0x2b>
				putch('-', putdat);
  800592:	83 ec 08             	sub    $0x8,%esp
  800595:	57                   	push   %edi
  800596:	6a 2d                	push   $0x2d
  800598:	ff d6                	call   *%esi
				num = -(long long) num;
  80059a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80059d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005a0:	f7 da                	neg    %edx
  8005a2:	83 d1 00             	adc    $0x0,%ecx
  8005a5:	f7 d9                	neg    %ecx
  8005a7:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005aa:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005af:	e9 ec 00 00 00       	jmp    8006a0 <.L25+0x2b>
		return va_arg(*ap, int);
  8005b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b7:	8b 00                	mov    (%eax),%eax
  8005b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005bc:	99                   	cltd   
  8005bd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c3:	8d 40 04             	lea    0x4(%eax),%eax
  8005c6:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c9:	eb b4                	jmp    80057f <.L29+0x3d>

008005cb <.L23>:
  8005cb:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8005ce:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  8005d1:	83 f9 01             	cmp    $0x1,%ecx
  8005d4:	7f 1e                	jg     8005f4 <.L23+0x29>
	else if (lflag)
  8005d6:	85 c9                	test   %ecx,%ecx
  8005d8:	74 32                	je     80060c <.L23+0x41>
		return va_arg(*ap, unsigned long);
  8005da:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dd:	8b 10                	mov    (%eax),%edx
  8005df:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005e4:	8d 40 04             	lea    0x4(%eax),%eax
  8005e7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ea:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8005ef:	e9 ac 00 00 00       	jmp    8006a0 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  8005f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f7:	8b 10                	mov    (%eax),%edx
  8005f9:	8b 48 04             	mov    0x4(%eax),%ecx
  8005fc:	8d 40 08             	lea    0x8(%eax),%eax
  8005ff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800602:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800607:	e9 94 00 00 00       	jmp    8006a0 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  80060c:	8b 45 14             	mov    0x14(%ebp),%eax
  80060f:	8b 10                	mov    (%eax),%edx
  800611:	b9 00 00 00 00       	mov    $0x0,%ecx
  800616:	8d 40 04             	lea    0x4(%eax),%eax
  800619:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80061c:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800621:	eb 7d                	jmp    8006a0 <.L25+0x2b>

00800623 <.L26>:
  800623:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800626:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  800629:	83 f9 01             	cmp    $0x1,%ecx
  80062c:	7f 1b                	jg     800649 <.L26+0x26>
	else if (lflag)
  80062e:	85 c9                	test   %ecx,%ecx
  800630:	74 2c                	je     80065e <.L26+0x3b>
		return va_arg(*ap, unsigned long);
  800632:	8b 45 14             	mov    0x14(%ebp),%eax
  800635:	8b 10                	mov    (%eax),%edx
  800637:	b9 00 00 00 00       	mov    $0x0,%ecx
  80063c:	8d 40 04             	lea    0x4(%eax),%eax
  80063f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800642:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800647:	eb 57                	jmp    8006a0 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  800649:	8b 45 14             	mov    0x14(%ebp),%eax
  80064c:	8b 10                	mov    (%eax),%edx
  80064e:	8b 48 04             	mov    0x4(%eax),%ecx
  800651:	8d 40 08             	lea    0x8(%eax),%eax
  800654:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800657:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80065c:	eb 42                	jmp    8006a0 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  80065e:	8b 45 14             	mov    0x14(%ebp),%eax
  800661:	8b 10                	mov    (%eax),%edx
  800663:	b9 00 00 00 00       	mov    $0x0,%ecx
  800668:	8d 40 04             	lea    0x4(%eax),%eax
  80066b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80066e:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800673:	eb 2b                	jmp    8006a0 <.L25+0x2b>

00800675 <.L25>:
  800675:	8b 75 08             	mov    0x8(%ebp),%esi
			putch('0', putdat);
  800678:	83 ec 08             	sub    $0x8,%esp
  80067b:	57                   	push   %edi
  80067c:	6a 30                	push   $0x30
  80067e:	ff d6                	call   *%esi
			putch('x', putdat);
  800680:	83 c4 08             	add    $0x8,%esp
  800683:	57                   	push   %edi
  800684:	6a 78                	push   $0x78
  800686:	ff d6                	call   *%esi
			num = (unsigned long long)
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	8b 10                	mov    (%eax),%edx
  80068d:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800692:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800695:	8d 40 04             	lea    0x4(%eax),%eax
  800698:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80069b:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006a0:	83 ec 0c             	sub    $0xc,%esp
  8006a3:	0f be 5d cf          	movsbl -0x31(%ebp),%ebx
  8006a7:	53                   	push   %ebx
  8006a8:	ff 75 d4             	pushl  -0x2c(%ebp)
  8006ab:	50                   	push   %eax
  8006ac:	51                   	push   %ecx
  8006ad:	52                   	push   %edx
  8006ae:	89 fa                	mov    %edi,%edx
  8006b0:	89 f0                	mov    %esi,%eax
  8006b2:	e8 08 fb ff ff       	call   8001bf <printnum>
			break;
  8006b7:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006ba:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006bd:	83 c3 01             	add    $0x1,%ebx
  8006c0:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  8006c4:	83 f8 25             	cmp    $0x25,%eax
  8006c7:	0f 84 23 fc ff ff    	je     8002f0 <vprintfmt+0x31>
			if (ch == '\0')
  8006cd:	85 c0                	test   %eax,%eax
  8006cf:	0f 84 97 00 00 00    	je     80076c <.L20+0x23>
			putch(ch, putdat);
  8006d5:	83 ec 08             	sub    $0x8,%esp
  8006d8:	57                   	push   %edi
  8006d9:	50                   	push   %eax
  8006da:	ff d6                	call   *%esi
  8006dc:	83 c4 10             	add    $0x10,%esp
  8006df:	eb dc                	jmp    8006bd <.L25+0x48>

008006e1 <.L21>:
  8006e1:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006e4:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  8006e7:	83 f9 01             	cmp    $0x1,%ecx
  8006ea:	7f 1b                	jg     800707 <.L21+0x26>
	else if (lflag)
  8006ec:	85 c9                	test   %ecx,%ecx
  8006ee:	74 2c                	je     80071c <.L21+0x3b>
		return va_arg(*ap, unsigned long);
  8006f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f3:	8b 10                	mov    (%eax),%edx
  8006f5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006fa:	8d 40 04             	lea    0x4(%eax),%eax
  8006fd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800700:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800705:	eb 99                	jmp    8006a0 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  800707:	8b 45 14             	mov    0x14(%ebp),%eax
  80070a:	8b 10                	mov    (%eax),%edx
  80070c:	8b 48 04             	mov    0x4(%eax),%ecx
  80070f:	8d 40 08             	lea    0x8(%eax),%eax
  800712:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800715:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  80071a:	eb 84                	jmp    8006a0 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  80071c:	8b 45 14             	mov    0x14(%ebp),%eax
  80071f:	8b 10                	mov    (%eax),%edx
  800721:	b9 00 00 00 00       	mov    $0x0,%ecx
  800726:	8d 40 04             	lea    0x4(%eax),%eax
  800729:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80072c:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800731:	e9 6a ff ff ff       	jmp    8006a0 <.L25+0x2b>

00800736 <.L35>:
  800736:	8b 75 08             	mov    0x8(%ebp),%esi
			putch(ch, putdat);
  800739:	83 ec 08             	sub    $0x8,%esp
  80073c:	57                   	push   %edi
  80073d:	6a 25                	push   $0x25
  80073f:	ff d6                	call   *%esi
			break;
  800741:	83 c4 10             	add    $0x10,%esp
  800744:	e9 71 ff ff ff       	jmp    8006ba <.L25+0x45>

00800749 <.L20>:
  800749:	8b 75 08             	mov    0x8(%ebp),%esi
			putch('%', putdat);
  80074c:	83 ec 08             	sub    $0x8,%esp
  80074f:	57                   	push   %edi
  800750:	6a 25                	push   $0x25
  800752:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800754:	83 c4 10             	add    $0x10,%esp
  800757:	89 d8                	mov    %ebx,%eax
  800759:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80075d:	74 05                	je     800764 <.L20+0x1b>
  80075f:	83 e8 01             	sub    $0x1,%eax
  800762:	eb f5                	jmp    800759 <.L20+0x10>
  800764:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800767:	e9 4e ff ff ff       	jmp    8006ba <.L25+0x45>
}
  80076c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80076f:	5b                   	pop    %ebx
  800770:	5e                   	pop    %esi
  800771:	5f                   	pop    %edi
  800772:	5d                   	pop    %ebp
  800773:	c3                   	ret    

00800774 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800774:	f3 0f 1e fb          	endbr32 
  800778:	55                   	push   %ebp
  800779:	89 e5                	mov    %esp,%ebp
  80077b:	53                   	push   %ebx
  80077c:	83 ec 14             	sub    $0x14,%esp
  80077f:	e8 df f8 ff ff       	call   800063 <__x86.get_pc_thunk.bx>
  800784:	81 c3 7c 18 00 00    	add    $0x187c,%ebx
  80078a:	8b 45 08             	mov    0x8(%ebp),%eax
  80078d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800790:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800793:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800797:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80079a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007a1:	85 c0                	test   %eax,%eax
  8007a3:	74 2b                	je     8007d0 <vsnprintf+0x5c>
  8007a5:	85 d2                	test   %edx,%edx
  8007a7:	7e 27                	jle    8007d0 <vsnprintf+0x5c>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007a9:	ff 75 14             	pushl  0x14(%ebp)
  8007ac:	ff 75 10             	pushl  0x10(%ebp)
  8007af:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007b2:	50                   	push   %eax
  8007b3:	8d 83 7d e2 ff ff    	lea    -0x1d83(%ebx),%eax
  8007b9:	50                   	push   %eax
  8007ba:	e8 00 fb ff ff       	call   8002bf <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007c2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007c8:	83 c4 10             	add    $0x10,%esp
}
  8007cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007ce:	c9                   	leave  
  8007cf:	c3                   	ret    
		return -E_INVAL;
  8007d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007d5:	eb f4                	jmp    8007cb <vsnprintf+0x57>

008007d7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007d7:	f3 0f 1e fb          	endbr32 
  8007db:	55                   	push   %ebp
  8007dc:	89 e5                	mov    %esp,%ebp
  8007de:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007e1:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007e4:	50                   	push   %eax
  8007e5:	ff 75 10             	pushl  0x10(%ebp)
  8007e8:	ff 75 0c             	pushl  0xc(%ebp)
  8007eb:	ff 75 08             	pushl  0x8(%ebp)
  8007ee:	e8 81 ff ff ff       	call   800774 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007f3:	c9                   	leave  
  8007f4:	c3                   	ret    

008007f5 <__x86.get_pc_thunk.ax>:
  8007f5:	8b 04 24             	mov    (%esp),%eax
  8007f8:	c3                   	ret    

008007f9 <__x86.get_pc_thunk.cx>:
  8007f9:	8b 0c 24             	mov    (%esp),%ecx
  8007fc:	c3                   	ret    

008007fd <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007fd:	f3 0f 1e fb          	endbr32 
  800801:	55                   	push   %ebp
  800802:	89 e5                	mov    %esp,%ebp
  800804:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800807:	b8 00 00 00 00       	mov    $0x0,%eax
  80080c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800810:	74 05                	je     800817 <strlen+0x1a>
		n++;
  800812:	83 c0 01             	add    $0x1,%eax
  800815:	eb f5                	jmp    80080c <strlen+0xf>
	return n;
}
  800817:	5d                   	pop    %ebp
  800818:	c3                   	ret    

00800819 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800819:	f3 0f 1e fb          	endbr32 
  80081d:	55                   	push   %ebp
  80081e:	89 e5                	mov    %esp,%ebp
  800820:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800823:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800826:	b8 00 00 00 00       	mov    $0x0,%eax
  80082b:	39 d0                	cmp    %edx,%eax
  80082d:	74 0d                	je     80083c <strnlen+0x23>
  80082f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800833:	74 05                	je     80083a <strnlen+0x21>
		n++;
  800835:	83 c0 01             	add    $0x1,%eax
  800838:	eb f1                	jmp    80082b <strnlen+0x12>
  80083a:	89 c2                	mov    %eax,%edx
	return n;
}
  80083c:	89 d0                	mov    %edx,%eax
  80083e:	5d                   	pop    %ebp
  80083f:	c3                   	ret    

00800840 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800840:	f3 0f 1e fb          	endbr32 
  800844:	55                   	push   %ebp
  800845:	89 e5                	mov    %esp,%ebp
  800847:	53                   	push   %ebx
  800848:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80084b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80084e:	b8 00 00 00 00       	mov    $0x0,%eax
  800853:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800857:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  80085a:	83 c0 01             	add    $0x1,%eax
  80085d:	84 d2                	test   %dl,%dl
  80085f:	75 f2                	jne    800853 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800861:	89 c8                	mov    %ecx,%eax
  800863:	5b                   	pop    %ebx
  800864:	5d                   	pop    %ebp
  800865:	c3                   	ret    

00800866 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800866:	f3 0f 1e fb          	endbr32 
  80086a:	55                   	push   %ebp
  80086b:	89 e5                	mov    %esp,%ebp
  80086d:	53                   	push   %ebx
  80086e:	83 ec 10             	sub    $0x10,%esp
  800871:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800874:	53                   	push   %ebx
  800875:	e8 83 ff ff ff       	call   8007fd <strlen>
  80087a:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80087d:	ff 75 0c             	pushl  0xc(%ebp)
  800880:	01 d8                	add    %ebx,%eax
  800882:	50                   	push   %eax
  800883:	e8 b8 ff ff ff       	call   800840 <strcpy>
	return dst;
}
  800888:	89 d8                	mov    %ebx,%eax
  80088a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80088d:	c9                   	leave  
  80088e:	c3                   	ret    

0080088f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80088f:	f3 0f 1e fb          	endbr32 
  800893:	55                   	push   %ebp
  800894:	89 e5                	mov    %esp,%ebp
  800896:	56                   	push   %esi
  800897:	53                   	push   %ebx
  800898:	8b 75 08             	mov    0x8(%ebp),%esi
  80089b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80089e:	89 f3                	mov    %esi,%ebx
  8008a0:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008a3:	89 f0                	mov    %esi,%eax
  8008a5:	39 d8                	cmp    %ebx,%eax
  8008a7:	74 11                	je     8008ba <strncpy+0x2b>
		*dst++ = *src;
  8008a9:	83 c0 01             	add    $0x1,%eax
  8008ac:	0f b6 0a             	movzbl (%edx),%ecx
  8008af:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008b2:	80 f9 01             	cmp    $0x1,%cl
  8008b5:	83 da ff             	sbb    $0xffffffff,%edx
  8008b8:	eb eb                	jmp    8008a5 <strncpy+0x16>
	}
	return ret;
}
  8008ba:	89 f0                	mov    %esi,%eax
  8008bc:	5b                   	pop    %ebx
  8008bd:	5e                   	pop    %esi
  8008be:	5d                   	pop    %ebp
  8008bf:	c3                   	ret    

008008c0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008c0:	f3 0f 1e fb          	endbr32 
  8008c4:	55                   	push   %ebp
  8008c5:	89 e5                	mov    %esp,%ebp
  8008c7:	56                   	push   %esi
  8008c8:	53                   	push   %ebx
  8008c9:	8b 75 08             	mov    0x8(%ebp),%esi
  8008cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008cf:	8b 55 10             	mov    0x10(%ebp),%edx
  8008d2:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008d4:	85 d2                	test   %edx,%edx
  8008d6:	74 21                	je     8008f9 <strlcpy+0x39>
  8008d8:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008dc:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008de:	39 c2                	cmp    %eax,%edx
  8008e0:	74 14                	je     8008f6 <strlcpy+0x36>
  8008e2:	0f b6 19             	movzbl (%ecx),%ebx
  8008e5:	84 db                	test   %bl,%bl
  8008e7:	74 0b                	je     8008f4 <strlcpy+0x34>
			*dst++ = *src++;
  8008e9:	83 c1 01             	add    $0x1,%ecx
  8008ec:	83 c2 01             	add    $0x1,%edx
  8008ef:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008f2:	eb ea                	jmp    8008de <strlcpy+0x1e>
  8008f4:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008f6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008f9:	29 f0                	sub    %esi,%eax
}
  8008fb:	5b                   	pop    %ebx
  8008fc:	5e                   	pop    %esi
  8008fd:	5d                   	pop    %ebp
  8008fe:	c3                   	ret    

008008ff <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008ff:	f3 0f 1e fb          	endbr32 
  800903:	55                   	push   %ebp
  800904:	89 e5                	mov    %esp,%ebp
  800906:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800909:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80090c:	0f b6 01             	movzbl (%ecx),%eax
  80090f:	84 c0                	test   %al,%al
  800911:	74 0c                	je     80091f <strcmp+0x20>
  800913:	3a 02                	cmp    (%edx),%al
  800915:	75 08                	jne    80091f <strcmp+0x20>
		p++, q++;
  800917:	83 c1 01             	add    $0x1,%ecx
  80091a:	83 c2 01             	add    $0x1,%edx
  80091d:	eb ed                	jmp    80090c <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80091f:	0f b6 c0             	movzbl %al,%eax
  800922:	0f b6 12             	movzbl (%edx),%edx
  800925:	29 d0                	sub    %edx,%eax
}
  800927:	5d                   	pop    %ebp
  800928:	c3                   	ret    

00800929 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800929:	f3 0f 1e fb          	endbr32 
  80092d:	55                   	push   %ebp
  80092e:	89 e5                	mov    %esp,%ebp
  800930:	53                   	push   %ebx
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	8b 55 0c             	mov    0xc(%ebp),%edx
  800937:	89 c3                	mov    %eax,%ebx
  800939:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80093c:	eb 06                	jmp    800944 <strncmp+0x1b>
		n--, p++, q++;
  80093e:	83 c0 01             	add    $0x1,%eax
  800941:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800944:	39 d8                	cmp    %ebx,%eax
  800946:	74 16                	je     80095e <strncmp+0x35>
  800948:	0f b6 08             	movzbl (%eax),%ecx
  80094b:	84 c9                	test   %cl,%cl
  80094d:	74 04                	je     800953 <strncmp+0x2a>
  80094f:	3a 0a                	cmp    (%edx),%cl
  800951:	74 eb                	je     80093e <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800953:	0f b6 00             	movzbl (%eax),%eax
  800956:	0f b6 12             	movzbl (%edx),%edx
  800959:	29 d0                	sub    %edx,%eax
}
  80095b:	5b                   	pop    %ebx
  80095c:	5d                   	pop    %ebp
  80095d:	c3                   	ret    
		return 0;
  80095e:	b8 00 00 00 00       	mov    $0x0,%eax
  800963:	eb f6                	jmp    80095b <strncmp+0x32>

00800965 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800965:	f3 0f 1e fb          	endbr32 
  800969:	55                   	push   %ebp
  80096a:	89 e5                	mov    %esp,%ebp
  80096c:	8b 45 08             	mov    0x8(%ebp),%eax
  80096f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800973:	0f b6 10             	movzbl (%eax),%edx
  800976:	84 d2                	test   %dl,%dl
  800978:	74 09                	je     800983 <strchr+0x1e>
		if (*s == c)
  80097a:	38 ca                	cmp    %cl,%dl
  80097c:	74 0a                	je     800988 <strchr+0x23>
	for (; *s; s++)
  80097e:	83 c0 01             	add    $0x1,%eax
  800981:	eb f0                	jmp    800973 <strchr+0xe>
			return (char *) s;
	return 0;
  800983:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800988:	5d                   	pop    %ebp
  800989:	c3                   	ret    

0080098a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80098a:	f3 0f 1e fb          	endbr32 
  80098e:	55                   	push   %ebp
  80098f:	89 e5                	mov    %esp,%ebp
  800991:	8b 45 08             	mov    0x8(%ebp),%eax
  800994:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800998:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80099b:	38 ca                	cmp    %cl,%dl
  80099d:	74 09                	je     8009a8 <strfind+0x1e>
  80099f:	84 d2                	test   %dl,%dl
  8009a1:	74 05                	je     8009a8 <strfind+0x1e>
	for (; *s; s++)
  8009a3:	83 c0 01             	add    $0x1,%eax
  8009a6:	eb f0                	jmp    800998 <strfind+0xe>
			break;
	return (char *) s;
}
  8009a8:	5d                   	pop    %ebp
  8009a9:	c3                   	ret    

008009aa <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009aa:	f3 0f 1e fb          	endbr32 
  8009ae:	55                   	push   %ebp
  8009af:	89 e5                	mov    %esp,%ebp
  8009b1:	57                   	push   %edi
  8009b2:	56                   	push   %esi
  8009b3:	53                   	push   %ebx
  8009b4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009ba:	85 c9                	test   %ecx,%ecx
  8009bc:	74 31                	je     8009ef <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009be:	89 f8                	mov    %edi,%eax
  8009c0:	09 c8                	or     %ecx,%eax
  8009c2:	a8 03                	test   $0x3,%al
  8009c4:	75 23                	jne    8009e9 <memset+0x3f>
		c &= 0xFF;
  8009c6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009ca:	89 d3                	mov    %edx,%ebx
  8009cc:	c1 e3 08             	shl    $0x8,%ebx
  8009cf:	89 d0                	mov    %edx,%eax
  8009d1:	c1 e0 18             	shl    $0x18,%eax
  8009d4:	89 d6                	mov    %edx,%esi
  8009d6:	c1 e6 10             	shl    $0x10,%esi
  8009d9:	09 f0                	or     %esi,%eax
  8009db:	09 c2                	or     %eax,%edx
  8009dd:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009df:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009e2:	89 d0                	mov    %edx,%eax
  8009e4:	fc                   	cld    
  8009e5:	f3 ab                	rep stos %eax,%es:(%edi)
  8009e7:	eb 06                	jmp    8009ef <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ec:	fc                   	cld    
  8009ed:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009ef:	89 f8                	mov    %edi,%eax
  8009f1:	5b                   	pop    %ebx
  8009f2:	5e                   	pop    %esi
  8009f3:	5f                   	pop    %edi
  8009f4:	5d                   	pop    %ebp
  8009f5:	c3                   	ret    

008009f6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009f6:	f3 0f 1e fb          	endbr32 
  8009fa:	55                   	push   %ebp
  8009fb:	89 e5                	mov    %esp,%ebp
  8009fd:	57                   	push   %edi
  8009fe:	56                   	push   %esi
  8009ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800a02:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a05:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a08:	39 c6                	cmp    %eax,%esi
  800a0a:	73 32                	jae    800a3e <memmove+0x48>
  800a0c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a0f:	39 c2                	cmp    %eax,%edx
  800a11:	76 2b                	jbe    800a3e <memmove+0x48>
		s += n;
		d += n;
  800a13:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a16:	89 fe                	mov    %edi,%esi
  800a18:	09 ce                	or     %ecx,%esi
  800a1a:	09 d6                	or     %edx,%esi
  800a1c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a22:	75 0e                	jne    800a32 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a24:	83 ef 04             	sub    $0x4,%edi
  800a27:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a2a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a2d:	fd                   	std    
  800a2e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a30:	eb 09                	jmp    800a3b <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a32:	83 ef 01             	sub    $0x1,%edi
  800a35:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a38:	fd                   	std    
  800a39:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a3b:	fc                   	cld    
  800a3c:	eb 1a                	jmp    800a58 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a3e:	89 c2                	mov    %eax,%edx
  800a40:	09 ca                	or     %ecx,%edx
  800a42:	09 f2                	or     %esi,%edx
  800a44:	f6 c2 03             	test   $0x3,%dl
  800a47:	75 0a                	jne    800a53 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a49:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a4c:	89 c7                	mov    %eax,%edi
  800a4e:	fc                   	cld    
  800a4f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a51:	eb 05                	jmp    800a58 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800a53:	89 c7                	mov    %eax,%edi
  800a55:	fc                   	cld    
  800a56:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a58:	5e                   	pop    %esi
  800a59:	5f                   	pop    %edi
  800a5a:	5d                   	pop    %ebp
  800a5b:	c3                   	ret    

00800a5c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a5c:	f3 0f 1e fb          	endbr32 
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
  800a63:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a66:	ff 75 10             	pushl  0x10(%ebp)
  800a69:	ff 75 0c             	pushl  0xc(%ebp)
  800a6c:	ff 75 08             	pushl  0x8(%ebp)
  800a6f:	e8 82 ff ff ff       	call   8009f6 <memmove>
}
  800a74:	c9                   	leave  
  800a75:	c3                   	ret    

00800a76 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a76:	f3 0f 1e fb          	endbr32 
  800a7a:	55                   	push   %ebp
  800a7b:	89 e5                	mov    %esp,%ebp
  800a7d:	56                   	push   %esi
  800a7e:	53                   	push   %ebx
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a85:	89 c6                	mov    %eax,%esi
  800a87:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a8a:	39 f0                	cmp    %esi,%eax
  800a8c:	74 1c                	je     800aaa <memcmp+0x34>
		if (*s1 != *s2)
  800a8e:	0f b6 08             	movzbl (%eax),%ecx
  800a91:	0f b6 1a             	movzbl (%edx),%ebx
  800a94:	38 d9                	cmp    %bl,%cl
  800a96:	75 08                	jne    800aa0 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a98:	83 c0 01             	add    $0x1,%eax
  800a9b:	83 c2 01             	add    $0x1,%edx
  800a9e:	eb ea                	jmp    800a8a <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800aa0:	0f b6 c1             	movzbl %cl,%eax
  800aa3:	0f b6 db             	movzbl %bl,%ebx
  800aa6:	29 d8                	sub    %ebx,%eax
  800aa8:	eb 05                	jmp    800aaf <memcmp+0x39>
	}

	return 0;
  800aaa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aaf:	5b                   	pop    %ebx
  800ab0:	5e                   	pop    %esi
  800ab1:	5d                   	pop    %ebp
  800ab2:	c3                   	ret    

00800ab3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ab3:	f3 0f 1e fb          	endbr32 
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
  800aba:	8b 45 08             	mov    0x8(%ebp),%eax
  800abd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ac0:	89 c2                	mov    %eax,%edx
  800ac2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ac5:	39 d0                	cmp    %edx,%eax
  800ac7:	73 09                	jae    800ad2 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ac9:	38 08                	cmp    %cl,(%eax)
  800acb:	74 05                	je     800ad2 <memfind+0x1f>
	for (; s < ends; s++)
  800acd:	83 c0 01             	add    $0x1,%eax
  800ad0:	eb f3                	jmp    800ac5 <memfind+0x12>
			break;
	return (void *) s;
}
  800ad2:	5d                   	pop    %ebp
  800ad3:	c3                   	ret    

00800ad4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ad4:	f3 0f 1e fb          	endbr32 
  800ad8:	55                   	push   %ebp
  800ad9:	89 e5                	mov    %esp,%ebp
  800adb:	57                   	push   %edi
  800adc:	56                   	push   %esi
  800add:	53                   	push   %ebx
  800ade:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ae1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ae4:	eb 03                	jmp    800ae9 <strtol+0x15>
		s++;
  800ae6:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ae9:	0f b6 01             	movzbl (%ecx),%eax
  800aec:	3c 20                	cmp    $0x20,%al
  800aee:	74 f6                	je     800ae6 <strtol+0x12>
  800af0:	3c 09                	cmp    $0x9,%al
  800af2:	74 f2                	je     800ae6 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800af4:	3c 2b                	cmp    $0x2b,%al
  800af6:	74 2a                	je     800b22 <strtol+0x4e>
	int neg = 0;
  800af8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800afd:	3c 2d                	cmp    $0x2d,%al
  800aff:	74 2b                	je     800b2c <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b01:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b07:	75 0f                	jne    800b18 <strtol+0x44>
  800b09:	80 39 30             	cmpb   $0x30,(%ecx)
  800b0c:	74 28                	je     800b36 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b0e:	85 db                	test   %ebx,%ebx
  800b10:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b15:	0f 44 d8             	cmove  %eax,%ebx
  800b18:	b8 00 00 00 00       	mov    $0x0,%eax
  800b1d:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b20:	eb 46                	jmp    800b68 <strtol+0x94>
		s++;
  800b22:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b25:	bf 00 00 00 00       	mov    $0x0,%edi
  800b2a:	eb d5                	jmp    800b01 <strtol+0x2d>
		s++, neg = 1;
  800b2c:	83 c1 01             	add    $0x1,%ecx
  800b2f:	bf 01 00 00 00       	mov    $0x1,%edi
  800b34:	eb cb                	jmp    800b01 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b36:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b3a:	74 0e                	je     800b4a <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b3c:	85 db                	test   %ebx,%ebx
  800b3e:	75 d8                	jne    800b18 <strtol+0x44>
		s++, base = 8;
  800b40:	83 c1 01             	add    $0x1,%ecx
  800b43:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b48:	eb ce                	jmp    800b18 <strtol+0x44>
		s += 2, base = 16;
  800b4a:	83 c1 02             	add    $0x2,%ecx
  800b4d:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b52:	eb c4                	jmp    800b18 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b54:	0f be d2             	movsbl %dl,%edx
  800b57:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b5a:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b5d:	7d 3a                	jge    800b99 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b5f:	83 c1 01             	add    $0x1,%ecx
  800b62:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b66:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b68:	0f b6 11             	movzbl (%ecx),%edx
  800b6b:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b6e:	89 f3                	mov    %esi,%ebx
  800b70:	80 fb 09             	cmp    $0x9,%bl
  800b73:	76 df                	jbe    800b54 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b75:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b78:	89 f3                	mov    %esi,%ebx
  800b7a:	80 fb 19             	cmp    $0x19,%bl
  800b7d:	77 08                	ja     800b87 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b7f:	0f be d2             	movsbl %dl,%edx
  800b82:	83 ea 57             	sub    $0x57,%edx
  800b85:	eb d3                	jmp    800b5a <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b87:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b8a:	89 f3                	mov    %esi,%ebx
  800b8c:	80 fb 19             	cmp    $0x19,%bl
  800b8f:	77 08                	ja     800b99 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b91:	0f be d2             	movsbl %dl,%edx
  800b94:	83 ea 37             	sub    $0x37,%edx
  800b97:	eb c1                	jmp    800b5a <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b99:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b9d:	74 05                	je     800ba4 <strtol+0xd0>
		*endptr = (char *) s;
  800b9f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ba2:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ba4:	89 c2                	mov    %eax,%edx
  800ba6:	f7 da                	neg    %edx
  800ba8:	85 ff                	test   %edi,%edi
  800baa:	0f 45 c2             	cmovne %edx,%eax
}
  800bad:	5b                   	pop    %ebx
  800bae:	5e                   	pop    %esi
  800baf:	5f                   	pop    %edi
  800bb0:	5d                   	pop    %ebp
  800bb1:	c3                   	ret    

00800bb2 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bb2:	f3 0f 1e fb          	endbr32 
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	57                   	push   %edi
  800bba:	56                   	push   %esi
  800bbb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bbc:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc7:	89 c3                	mov    %eax,%ebx
  800bc9:	89 c7                	mov    %eax,%edi
  800bcb:	89 c6                	mov    %eax,%esi
  800bcd:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bcf:	5b                   	pop    %ebx
  800bd0:	5e                   	pop    %esi
  800bd1:	5f                   	pop    %edi
  800bd2:	5d                   	pop    %ebp
  800bd3:	c3                   	ret    

00800bd4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800bd4:	f3 0f 1e fb          	endbr32 
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	57                   	push   %edi
  800bdc:	56                   	push   %esi
  800bdd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bde:	ba 00 00 00 00       	mov    $0x0,%edx
  800be3:	b8 01 00 00 00       	mov    $0x1,%eax
  800be8:	89 d1                	mov    %edx,%ecx
  800bea:	89 d3                	mov    %edx,%ebx
  800bec:	89 d7                	mov    %edx,%edi
  800bee:	89 d6                	mov    %edx,%esi
  800bf0:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bf2:	5b                   	pop    %ebx
  800bf3:	5e                   	pop    %esi
  800bf4:	5f                   	pop    %edi
  800bf5:	5d                   	pop    %ebp
  800bf6:	c3                   	ret    

00800bf7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bf7:	f3 0f 1e fb          	endbr32 
  800bfb:	55                   	push   %ebp
  800bfc:	89 e5                	mov    %esp,%ebp
  800bfe:	57                   	push   %edi
  800bff:	56                   	push   %esi
  800c00:	53                   	push   %ebx
  800c01:	83 ec 1c             	sub    $0x1c,%esp
  800c04:	e8 ec fb ff ff       	call   8007f5 <__x86.get_pc_thunk.ax>
  800c09:	05 f7 13 00 00       	add    $0x13f7,%eax
  800c0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	asm volatile("int %1\n"
  800c11:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c16:	8b 55 08             	mov    0x8(%ebp),%edx
  800c19:	b8 03 00 00 00       	mov    $0x3,%eax
  800c1e:	89 cb                	mov    %ecx,%ebx
  800c20:	89 cf                	mov    %ecx,%edi
  800c22:	89 ce                	mov    %ecx,%esi
  800c24:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c26:	85 c0                	test   %eax,%eax
  800c28:	7f 08                	jg     800c32 <sys_env_destroy+0x3b>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
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
  800c36:	6a 03                	push   $0x3
  800c38:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800c3b:	8d 83 50 f1 ff ff    	lea    -0xeb0(%ebx),%eax
  800c41:	50                   	push   %eax
  800c42:	6a 23                	push   $0x23
  800c44:	8d 83 6d f1 ff ff    	lea    -0xe93(%ebx),%eax
  800c4a:	50                   	push   %eax
  800c4b:	e8 23 00 00 00       	call   800c73 <_panic>

00800c50 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c50:	f3 0f 1e fb          	endbr32 
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	57                   	push   %edi
  800c58:	56                   	push   %esi
  800c59:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c5a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c5f:	b8 02 00 00 00       	mov    $0x2,%eax
  800c64:	89 d1                	mov    %edx,%ecx
  800c66:	89 d3                	mov    %edx,%ebx
  800c68:	89 d7                	mov    %edx,%edi
  800c6a:	89 d6                	mov    %edx,%esi
  800c6c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c6e:	5b                   	pop    %ebx
  800c6f:	5e                   	pop    %esi
  800c70:	5f                   	pop    %edi
  800c71:	5d                   	pop    %ebp
  800c72:	c3                   	ret    

00800c73 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800c73:	f3 0f 1e fb          	endbr32 
  800c77:	55                   	push   %ebp
  800c78:	89 e5                	mov    %esp,%ebp
  800c7a:	57                   	push   %edi
  800c7b:	56                   	push   %esi
  800c7c:	53                   	push   %ebx
  800c7d:	83 ec 0c             	sub    $0xc,%esp
  800c80:	e8 de f3 ff ff       	call   800063 <__x86.get_pc_thunk.bx>
  800c85:	81 c3 7b 13 00 00    	add    $0x137b,%ebx
	va_list ap;

	va_start(ap, fmt);
  800c8b:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800c8e:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  800c94:	8b 38                	mov    (%eax),%edi
  800c96:	e8 b5 ff ff ff       	call   800c50 <sys_getenvid>
  800c9b:	83 ec 0c             	sub    $0xc,%esp
  800c9e:	ff 75 0c             	pushl  0xc(%ebp)
  800ca1:	ff 75 08             	pushl  0x8(%ebp)
  800ca4:	57                   	push   %edi
  800ca5:	50                   	push   %eax
  800ca6:	8d 83 7c f1 ff ff    	lea    -0xe84(%ebx),%eax
  800cac:	50                   	push   %eax
  800cad:	e8 f5 f4 ff ff       	call   8001a7 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800cb2:	83 c4 18             	add    $0x18,%esp
  800cb5:	56                   	push   %esi
  800cb6:	ff 75 10             	pushl  0x10(%ebp)
  800cb9:	e8 83 f4 ff ff       	call   800141 <vcprintf>
	cprintf("\n");
  800cbe:	8d 83 5c ef ff ff    	lea    -0x10a4(%ebx),%eax
  800cc4:	89 04 24             	mov    %eax,(%esp)
  800cc7:	e8 db f4 ff ff       	call   8001a7 <cprintf>
  800ccc:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800ccf:	cc                   	int3   
  800cd0:	eb fd                	jmp    800ccf <_panic+0x5c>
  800cd2:	66 90                	xchg   %ax,%ax
  800cd4:	66 90                	xchg   %ax,%ax
  800cd6:	66 90                	xchg   %ax,%ax
  800cd8:	66 90                	xchg   %ax,%ax
  800cda:	66 90                	xchg   %ax,%ax
  800cdc:	66 90                	xchg   %ax,%ax
  800cde:	66 90                	xchg   %ax,%ax

00800ce0 <__udivdi3>:
  800ce0:	f3 0f 1e fb          	endbr32 
  800ce4:	55                   	push   %ebp
  800ce5:	57                   	push   %edi
  800ce6:	56                   	push   %esi
  800ce7:	53                   	push   %ebx
  800ce8:	83 ec 1c             	sub    $0x1c,%esp
  800ceb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800cef:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800cf3:	8b 74 24 34          	mov    0x34(%esp),%esi
  800cf7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800cfb:	85 d2                	test   %edx,%edx
  800cfd:	75 19                	jne    800d18 <__udivdi3+0x38>
  800cff:	39 f3                	cmp    %esi,%ebx
  800d01:	76 4d                	jbe    800d50 <__udivdi3+0x70>
  800d03:	31 ff                	xor    %edi,%edi
  800d05:	89 e8                	mov    %ebp,%eax
  800d07:	89 f2                	mov    %esi,%edx
  800d09:	f7 f3                	div    %ebx
  800d0b:	89 fa                	mov    %edi,%edx
  800d0d:	83 c4 1c             	add    $0x1c,%esp
  800d10:	5b                   	pop    %ebx
  800d11:	5e                   	pop    %esi
  800d12:	5f                   	pop    %edi
  800d13:	5d                   	pop    %ebp
  800d14:	c3                   	ret    
  800d15:	8d 76 00             	lea    0x0(%esi),%esi
  800d18:	39 f2                	cmp    %esi,%edx
  800d1a:	76 14                	jbe    800d30 <__udivdi3+0x50>
  800d1c:	31 ff                	xor    %edi,%edi
  800d1e:	31 c0                	xor    %eax,%eax
  800d20:	89 fa                	mov    %edi,%edx
  800d22:	83 c4 1c             	add    $0x1c,%esp
  800d25:	5b                   	pop    %ebx
  800d26:	5e                   	pop    %esi
  800d27:	5f                   	pop    %edi
  800d28:	5d                   	pop    %ebp
  800d29:	c3                   	ret    
  800d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800d30:	0f bd fa             	bsr    %edx,%edi
  800d33:	83 f7 1f             	xor    $0x1f,%edi
  800d36:	75 48                	jne    800d80 <__udivdi3+0xa0>
  800d38:	39 f2                	cmp    %esi,%edx
  800d3a:	72 06                	jb     800d42 <__udivdi3+0x62>
  800d3c:	31 c0                	xor    %eax,%eax
  800d3e:	39 eb                	cmp    %ebp,%ebx
  800d40:	77 de                	ja     800d20 <__udivdi3+0x40>
  800d42:	b8 01 00 00 00       	mov    $0x1,%eax
  800d47:	eb d7                	jmp    800d20 <__udivdi3+0x40>
  800d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800d50:	89 d9                	mov    %ebx,%ecx
  800d52:	85 db                	test   %ebx,%ebx
  800d54:	75 0b                	jne    800d61 <__udivdi3+0x81>
  800d56:	b8 01 00 00 00       	mov    $0x1,%eax
  800d5b:	31 d2                	xor    %edx,%edx
  800d5d:	f7 f3                	div    %ebx
  800d5f:	89 c1                	mov    %eax,%ecx
  800d61:	31 d2                	xor    %edx,%edx
  800d63:	89 f0                	mov    %esi,%eax
  800d65:	f7 f1                	div    %ecx
  800d67:	89 c6                	mov    %eax,%esi
  800d69:	89 e8                	mov    %ebp,%eax
  800d6b:	89 f7                	mov    %esi,%edi
  800d6d:	f7 f1                	div    %ecx
  800d6f:	89 fa                	mov    %edi,%edx
  800d71:	83 c4 1c             	add    $0x1c,%esp
  800d74:	5b                   	pop    %ebx
  800d75:	5e                   	pop    %esi
  800d76:	5f                   	pop    %edi
  800d77:	5d                   	pop    %ebp
  800d78:	c3                   	ret    
  800d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800d80:	89 f9                	mov    %edi,%ecx
  800d82:	b8 20 00 00 00       	mov    $0x20,%eax
  800d87:	29 f8                	sub    %edi,%eax
  800d89:	d3 e2                	shl    %cl,%edx
  800d8b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800d8f:	89 c1                	mov    %eax,%ecx
  800d91:	89 da                	mov    %ebx,%edx
  800d93:	d3 ea                	shr    %cl,%edx
  800d95:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800d99:	09 d1                	or     %edx,%ecx
  800d9b:	89 f2                	mov    %esi,%edx
  800d9d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800da1:	89 f9                	mov    %edi,%ecx
  800da3:	d3 e3                	shl    %cl,%ebx
  800da5:	89 c1                	mov    %eax,%ecx
  800da7:	d3 ea                	shr    %cl,%edx
  800da9:	89 f9                	mov    %edi,%ecx
  800dab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800daf:	89 eb                	mov    %ebp,%ebx
  800db1:	d3 e6                	shl    %cl,%esi
  800db3:	89 c1                	mov    %eax,%ecx
  800db5:	d3 eb                	shr    %cl,%ebx
  800db7:	09 de                	or     %ebx,%esi
  800db9:	89 f0                	mov    %esi,%eax
  800dbb:	f7 74 24 08          	divl   0x8(%esp)
  800dbf:	89 d6                	mov    %edx,%esi
  800dc1:	89 c3                	mov    %eax,%ebx
  800dc3:	f7 64 24 0c          	mull   0xc(%esp)
  800dc7:	39 d6                	cmp    %edx,%esi
  800dc9:	72 15                	jb     800de0 <__udivdi3+0x100>
  800dcb:	89 f9                	mov    %edi,%ecx
  800dcd:	d3 e5                	shl    %cl,%ebp
  800dcf:	39 c5                	cmp    %eax,%ebp
  800dd1:	73 04                	jae    800dd7 <__udivdi3+0xf7>
  800dd3:	39 d6                	cmp    %edx,%esi
  800dd5:	74 09                	je     800de0 <__udivdi3+0x100>
  800dd7:	89 d8                	mov    %ebx,%eax
  800dd9:	31 ff                	xor    %edi,%edi
  800ddb:	e9 40 ff ff ff       	jmp    800d20 <__udivdi3+0x40>
  800de0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800de3:	31 ff                	xor    %edi,%edi
  800de5:	e9 36 ff ff ff       	jmp    800d20 <__udivdi3+0x40>
  800dea:	66 90                	xchg   %ax,%ax
  800dec:	66 90                	xchg   %ax,%ax
  800dee:	66 90                	xchg   %ax,%ax

00800df0 <__umoddi3>:
  800df0:	f3 0f 1e fb          	endbr32 
  800df4:	55                   	push   %ebp
  800df5:	57                   	push   %edi
  800df6:	56                   	push   %esi
  800df7:	53                   	push   %ebx
  800df8:	83 ec 1c             	sub    $0x1c,%esp
  800dfb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800dff:	8b 74 24 30          	mov    0x30(%esp),%esi
  800e03:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800e07:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800e0b:	85 c0                	test   %eax,%eax
  800e0d:	75 19                	jne    800e28 <__umoddi3+0x38>
  800e0f:	39 df                	cmp    %ebx,%edi
  800e11:	76 5d                	jbe    800e70 <__umoddi3+0x80>
  800e13:	89 f0                	mov    %esi,%eax
  800e15:	89 da                	mov    %ebx,%edx
  800e17:	f7 f7                	div    %edi
  800e19:	89 d0                	mov    %edx,%eax
  800e1b:	31 d2                	xor    %edx,%edx
  800e1d:	83 c4 1c             	add    $0x1c,%esp
  800e20:	5b                   	pop    %ebx
  800e21:	5e                   	pop    %esi
  800e22:	5f                   	pop    %edi
  800e23:	5d                   	pop    %ebp
  800e24:	c3                   	ret    
  800e25:	8d 76 00             	lea    0x0(%esi),%esi
  800e28:	89 f2                	mov    %esi,%edx
  800e2a:	39 d8                	cmp    %ebx,%eax
  800e2c:	76 12                	jbe    800e40 <__umoddi3+0x50>
  800e2e:	89 f0                	mov    %esi,%eax
  800e30:	89 da                	mov    %ebx,%edx
  800e32:	83 c4 1c             	add    $0x1c,%esp
  800e35:	5b                   	pop    %ebx
  800e36:	5e                   	pop    %esi
  800e37:	5f                   	pop    %edi
  800e38:	5d                   	pop    %ebp
  800e39:	c3                   	ret    
  800e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800e40:	0f bd e8             	bsr    %eax,%ebp
  800e43:	83 f5 1f             	xor    $0x1f,%ebp
  800e46:	75 50                	jne    800e98 <__umoddi3+0xa8>
  800e48:	39 d8                	cmp    %ebx,%eax
  800e4a:	0f 82 e0 00 00 00    	jb     800f30 <__umoddi3+0x140>
  800e50:	89 d9                	mov    %ebx,%ecx
  800e52:	39 f7                	cmp    %esi,%edi
  800e54:	0f 86 d6 00 00 00    	jbe    800f30 <__umoddi3+0x140>
  800e5a:	89 d0                	mov    %edx,%eax
  800e5c:	89 ca                	mov    %ecx,%edx
  800e5e:	83 c4 1c             	add    $0x1c,%esp
  800e61:	5b                   	pop    %ebx
  800e62:	5e                   	pop    %esi
  800e63:	5f                   	pop    %edi
  800e64:	5d                   	pop    %ebp
  800e65:	c3                   	ret    
  800e66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800e6d:	8d 76 00             	lea    0x0(%esi),%esi
  800e70:	89 fd                	mov    %edi,%ebp
  800e72:	85 ff                	test   %edi,%edi
  800e74:	75 0b                	jne    800e81 <__umoddi3+0x91>
  800e76:	b8 01 00 00 00       	mov    $0x1,%eax
  800e7b:	31 d2                	xor    %edx,%edx
  800e7d:	f7 f7                	div    %edi
  800e7f:	89 c5                	mov    %eax,%ebp
  800e81:	89 d8                	mov    %ebx,%eax
  800e83:	31 d2                	xor    %edx,%edx
  800e85:	f7 f5                	div    %ebp
  800e87:	89 f0                	mov    %esi,%eax
  800e89:	f7 f5                	div    %ebp
  800e8b:	89 d0                	mov    %edx,%eax
  800e8d:	31 d2                	xor    %edx,%edx
  800e8f:	eb 8c                	jmp    800e1d <__umoddi3+0x2d>
  800e91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800e98:	89 e9                	mov    %ebp,%ecx
  800e9a:	ba 20 00 00 00       	mov    $0x20,%edx
  800e9f:	29 ea                	sub    %ebp,%edx
  800ea1:	d3 e0                	shl    %cl,%eax
  800ea3:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ea7:	89 d1                	mov    %edx,%ecx
  800ea9:	89 f8                	mov    %edi,%eax
  800eab:	d3 e8                	shr    %cl,%eax
  800ead:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800eb1:	89 54 24 04          	mov    %edx,0x4(%esp)
  800eb5:	8b 54 24 04          	mov    0x4(%esp),%edx
  800eb9:	09 c1                	or     %eax,%ecx
  800ebb:	89 d8                	mov    %ebx,%eax
  800ebd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800ec1:	89 e9                	mov    %ebp,%ecx
  800ec3:	d3 e7                	shl    %cl,%edi
  800ec5:	89 d1                	mov    %edx,%ecx
  800ec7:	d3 e8                	shr    %cl,%eax
  800ec9:	89 e9                	mov    %ebp,%ecx
  800ecb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800ecf:	d3 e3                	shl    %cl,%ebx
  800ed1:	89 c7                	mov    %eax,%edi
  800ed3:	89 d1                	mov    %edx,%ecx
  800ed5:	89 f0                	mov    %esi,%eax
  800ed7:	d3 e8                	shr    %cl,%eax
  800ed9:	89 e9                	mov    %ebp,%ecx
  800edb:	89 fa                	mov    %edi,%edx
  800edd:	d3 e6                	shl    %cl,%esi
  800edf:	09 d8                	or     %ebx,%eax
  800ee1:	f7 74 24 08          	divl   0x8(%esp)
  800ee5:	89 d1                	mov    %edx,%ecx
  800ee7:	89 f3                	mov    %esi,%ebx
  800ee9:	f7 64 24 0c          	mull   0xc(%esp)
  800eed:	89 c6                	mov    %eax,%esi
  800eef:	89 d7                	mov    %edx,%edi
  800ef1:	39 d1                	cmp    %edx,%ecx
  800ef3:	72 06                	jb     800efb <__umoddi3+0x10b>
  800ef5:	75 10                	jne    800f07 <__umoddi3+0x117>
  800ef7:	39 c3                	cmp    %eax,%ebx
  800ef9:	73 0c                	jae    800f07 <__umoddi3+0x117>
  800efb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  800eff:	1b 54 24 08          	sbb    0x8(%esp),%edx
  800f03:	89 d7                	mov    %edx,%edi
  800f05:	89 c6                	mov    %eax,%esi
  800f07:	89 ca                	mov    %ecx,%edx
  800f09:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800f0e:	29 f3                	sub    %esi,%ebx
  800f10:	19 fa                	sbb    %edi,%edx
  800f12:	89 d0                	mov    %edx,%eax
  800f14:	d3 e0                	shl    %cl,%eax
  800f16:	89 e9                	mov    %ebp,%ecx
  800f18:	d3 eb                	shr    %cl,%ebx
  800f1a:	d3 ea                	shr    %cl,%edx
  800f1c:	09 d8                	or     %ebx,%eax
  800f1e:	83 c4 1c             	add    $0x1c,%esp
  800f21:	5b                   	pop    %ebx
  800f22:	5e                   	pop    %esi
  800f23:	5f                   	pop    %edi
  800f24:	5d                   	pop    %ebp
  800f25:	c3                   	ret    
  800f26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f2d:	8d 76 00             	lea    0x0(%esi),%esi
  800f30:	29 fe                	sub    %edi,%esi
  800f32:	19 c3                	sbb    %eax,%ebx
  800f34:	89 f2                	mov    %esi,%edx
  800f36:	89 d9                	mov    %ebx,%ecx
  800f38:	e9 1d ff ff ff       	jmp    800e5a <__umoddi3+0x6a>
