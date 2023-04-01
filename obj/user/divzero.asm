
obj/user/divzero:     file format elf32-i386


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
  80002c:	e8 4a 00 00 00       	call   80007b <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

int zero;

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	53                   	push   %ebx
  80003b:	83 ec 0c             	sub    $0xc,%esp
  80003e:	e8 34 00 00 00       	call   800077 <__x86.get_pc_thunk.bx>
  800043:	81 c3 bd 1f 00 00    	add    $0x1fbd,%ebx
	zero = 0;
  800049:	c7 c0 2c 20 80 00    	mov    $0x80202c,%eax
  80004f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	cprintf("1/0 is %08x!\n", 1/zero);
  800055:	b8 01 00 00 00       	mov    $0x1,%eax
  80005a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80005f:	99                   	cltd   
  800060:	f7 f9                	idiv   %ecx
  800062:	50                   	push   %eax
  800063:	8d 83 50 ef ff ff    	lea    -0x10b0(%ebx),%eax
  800069:	50                   	push   %eax
  80006a:	e8 4c 01 00 00       	call   8001bb <cprintf>
}
  80006f:	83 c4 10             	add    $0x10,%esp
  800072:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800075:	c9                   	leave  
  800076:	c3                   	ret    

00800077 <__x86.get_pc_thunk.bx>:
  800077:	8b 1c 24             	mov    (%esp),%ebx
  80007a:	c3                   	ret    

0080007b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80007b:	f3 0f 1e fb          	endbr32 
  80007f:	55                   	push   %ebp
  800080:	89 e5                	mov    %esp,%ebp
  800082:	57                   	push   %edi
  800083:	56                   	push   %esi
  800084:	53                   	push   %ebx
  800085:	83 ec 0c             	sub    $0xc,%esp
  800088:	e8 ea ff ff ff       	call   800077 <__x86.get_pc_thunk.bx>
  80008d:	81 c3 73 1f 00 00    	add    $0x1f73,%ebx
  800093:	8b 75 08             	mov    0x8(%ebp),%esi
  800096:	8b 7d 0c             	mov    0xc(%ebp),%edi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800099:	e8 c6 0b 00 00       	call   800c64 <sys_getenvid>
  80009e:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000a3:	8d 04 40             	lea    (%eax,%eax,2),%eax
  8000a6:	c1 e0 05             	shl    $0x5,%eax
  8000a9:	81 c0 00 00 c0 ee    	add    $0xeec00000,%eax
  8000af:	c7 c2 30 20 80 00    	mov    $0x802030,%edx
  8000b5:	89 02                	mov    %eax,(%edx)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b7:	85 f6                	test   %esi,%esi
  8000b9:	7e 08                	jle    8000c3 <libmain+0x48>
		binaryname = argv[0];
  8000bb:	8b 07                	mov    (%edi),%eax
  8000bd:	89 83 0c 00 00 00    	mov    %eax,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  8000c3:	83 ec 08             	sub    $0x8,%esp
  8000c6:	57                   	push   %edi
  8000c7:	56                   	push   %esi
  8000c8:	e8 66 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000cd:	e8 0b 00 00 00       	call   8000dd <exit>
}
  8000d2:	83 c4 10             	add    $0x10,%esp
  8000d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000d8:	5b                   	pop    %ebx
  8000d9:	5e                   	pop    %esi
  8000da:	5f                   	pop    %edi
  8000db:	5d                   	pop    %ebp
  8000dc:	c3                   	ret    

008000dd <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000dd:	f3 0f 1e fb          	endbr32 
  8000e1:	55                   	push   %ebp
  8000e2:	89 e5                	mov    %esp,%ebp
  8000e4:	53                   	push   %ebx
  8000e5:	83 ec 10             	sub    $0x10,%esp
  8000e8:	e8 8a ff ff ff       	call   800077 <__x86.get_pc_thunk.bx>
  8000ed:	81 c3 13 1f 00 00    	add    $0x1f13,%ebx
	sys_env_destroy(0);
  8000f3:	6a 00                	push   $0x0
  8000f5:	e8 11 0b 00 00       	call   800c0b <sys_env_destroy>
}
  8000fa:	83 c4 10             	add    $0x10,%esp
  8000fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800100:	c9                   	leave  
  800101:	c3                   	ret    

00800102 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800102:	f3 0f 1e fb          	endbr32 
  800106:	55                   	push   %ebp
  800107:	89 e5                	mov    %esp,%ebp
  800109:	56                   	push   %esi
  80010a:	53                   	push   %ebx
  80010b:	e8 67 ff ff ff       	call   800077 <__x86.get_pc_thunk.bx>
  800110:	81 c3 f0 1e 00 00    	add    $0x1ef0,%ebx
  800116:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
  800119:	8b 16                	mov    (%esi),%edx
  80011b:	8d 42 01             	lea    0x1(%edx),%eax
  80011e:	89 06                	mov    %eax,(%esi)
  800120:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800123:	88 4c 16 08          	mov    %cl,0x8(%esi,%edx,1)
	if (b->idx == 256-1) {
  800127:	3d ff 00 00 00       	cmp    $0xff,%eax
  80012c:	74 0b                	je     800139 <putch+0x37>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80012e:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  800132:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800135:	5b                   	pop    %ebx
  800136:	5e                   	pop    %esi
  800137:	5d                   	pop    %ebp
  800138:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800139:	83 ec 08             	sub    $0x8,%esp
  80013c:	68 ff 00 00 00       	push   $0xff
  800141:	8d 46 08             	lea    0x8(%esi),%eax
  800144:	50                   	push   %eax
  800145:	e8 7c 0a 00 00       	call   800bc6 <sys_cputs>
		b->idx = 0;
  80014a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  800150:	83 c4 10             	add    $0x10,%esp
  800153:	eb d9                	jmp    80012e <putch+0x2c>

00800155 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800155:	f3 0f 1e fb          	endbr32 
  800159:	55                   	push   %ebp
  80015a:	89 e5                	mov    %esp,%ebp
  80015c:	53                   	push   %ebx
  80015d:	81 ec 14 01 00 00    	sub    $0x114,%esp
  800163:	e8 0f ff ff ff       	call   800077 <__x86.get_pc_thunk.bx>
  800168:	81 c3 98 1e 00 00    	add    $0x1e98,%ebx
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
  80018f:	8d 83 02 e1 ff ff    	lea    -0x1efe(%ebx),%eax
  800195:	50                   	push   %eax
  800196:	e8 38 01 00 00       	call   8002d3 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80019b:	83 c4 08             	add    $0x8,%esp
  80019e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001a4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001aa:	50                   	push   %eax
  8001ab:	e8 16 0a 00 00       	call   800bc6 <sys_cputs>

	return b.cnt;
}
  8001b0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001b9:	c9                   	leave  
  8001ba:	c3                   	ret    

008001bb <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001bb:	f3 0f 1e fb          	endbr32 
  8001bf:	55                   	push   %ebp
  8001c0:	89 e5                	mov    %esp,%ebp
  8001c2:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001c5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001c8:	50                   	push   %eax
  8001c9:	ff 75 08             	pushl  0x8(%ebp)
  8001cc:	e8 84 ff ff ff       	call   800155 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001d1:	c9                   	leave  
  8001d2:	c3                   	ret    

008001d3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001d3:	55                   	push   %ebp
  8001d4:	89 e5                	mov    %esp,%ebp
  8001d6:	57                   	push   %edi
  8001d7:	56                   	push   %esi
  8001d8:	53                   	push   %ebx
  8001d9:	83 ec 2c             	sub    $0x2c,%esp
  8001dc:	e8 2c 06 00 00       	call   80080d <__x86.get_pc_thunk.cx>
  8001e1:	81 c1 1f 1e 00 00    	add    $0x1e1f,%ecx
  8001e7:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001ea:	89 c7                	mov    %eax,%edi
  8001ec:	89 d6                	mov    %edx,%esi
  8001ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001f4:	89 d1                	mov    %edx,%ecx
  8001f6:	89 c2                	mov    %eax,%edx
  8001f8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8001fb:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8001fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800201:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800204:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800207:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80020e:	39 c2                	cmp    %eax,%edx
  800210:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800213:	72 41                	jb     800256 <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800215:	83 ec 0c             	sub    $0xc,%esp
  800218:	ff 75 18             	pushl  0x18(%ebp)
  80021b:	83 eb 01             	sub    $0x1,%ebx
  80021e:	53                   	push   %ebx
  80021f:	50                   	push   %eax
  800220:	83 ec 08             	sub    $0x8,%esp
  800223:	ff 75 e4             	pushl  -0x1c(%ebp)
  800226:	ff 75 e0             	pushl  -0x20(%ebp)
  800229:	ff 75 d4             	pushl  -0x2c(%ebp)
  80022c:	ff 75 d0             	pushl  -0x30(%ebp)
  80022f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800232:	e8 b9 0a 00 00       	call   800cf0 <__udivdi3>
  800237:	83 c4 18             	add    $0x18,%esp
  80023a:	52                   	push   %edx
  80023b:	50                   	push   %eax
  80023c:	89 f2                	mov    %esi,%edx
  80023e:	89 f8                	mov    %edi,%eax
  800240:	e8 8e ff ff ff       	call   8001d3 <printnum>
  800245:	83 c4 20             	add    $0x20,%esp
  800248:	eb 13                	jmp    80025d <printnum+0x8a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80024a:	83 ec 08             	sub    $0x8,%esp
  80024d:	56                   	push   %esi
  80024e:	ff 75 18             	pushl  0x18(%ebp)
  800251:	ff d7                	call   *%edi
  800253:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800256:	83 eb 01             	sub    $0x1,%ebx
  800259:	85 db                	test   %ebx,%ebx
  80025b:	7f ed                	jg     80024a <printnum+0x77>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80025d:	83 ec 08             	sub    $0x8,%esp
  800260:	56                   	push   %esi
  800261:	83 ec 04             	sub    $0x4,%esp
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	ff 75 e0             	pushl  -0x20(%ebp)
  80026a:	ff 75 d4             	pushl  -0x2c(%ebp)
  80026d:	ff 75 d0             	pushl  -0x30(%ebp)
  800270:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800273:	e8 88 0b 00 00       	call   800e00 <__umoddi3>
  800278:	83 c4 14             	add    $0x14,%esp
  80027b:	0f be 84 03 68 ef ff 	movsbl -0x1098(%ebx,%eax,1),%eax
  800282:	ff 
  800283:	50                   	push   %eax
  800284:	ff d7                	call   *%edi
}
  800286:	83 c4 10             	add    $0x10,%esp
  800289:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80028c:	5b                   	pop    %ebx
  80028d:	5e                   	pop    %esi
  80028e:	5f                   	pop    %edi
  80028f:	5d                   	pop    %ebp
  800290:	c3                   	ret    

00800291 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800291:	f3 0f 1e fb          	endbr32 
  800295:	55                   	push   %ebp
  800296:	89 e5                	mov    %esp,%ebp
  800298:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80029b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80029f:	8b 10                	mov    (%eax),%edx
  8002a1:	3b 50 04             	cmp    0x4(%eax),%edx
  8002a4:	73 0a                	jae    8002b0 <sprintputch+0x1f>
		*b->buf++ = ch;
  8002a6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002a9:	89 08                	mov    %ecx,(%eax)
  8002ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ae:	88 02                	mov    %al,(%edx)
}
  8002b0:	5d                   	pop    %ebp
  8002b1:	c3                   	ret    

008002b2 <printfmt>:
{
  8002b2:	f3 0f 1e fb          	endbr32 
  8002b6:	55                   	push   %ebp
  8002b7:	89 e5                	mov    %esp,%ebp
  8002b9:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002bc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002bf:	50                   	push   %eax
  8002c0:	ff 75 10             	pushl  0x10(%ebp)
  8002c3:	ff 75 0c             	pushl  0xc(%ebp)
  8002c6:	ff 75 08             	pushl  0x8(%ebp)
  8002c9:	e8 05 00 00 00       	call   8002d3 <vprintfmt>
}
  8002ce:	83 c4 10             	add    $0x10,%esp
  8002d1:	c9                   	leave  
  8002d2:	c3                   	ret    

008002d3 <vprintfmt>:
{
  8002d3:	f3 0f 1e fb          	endbr32 
  8002d7:	55                   	push   %ebp
  8002d8:	89 e5                	mov    %esp,%ebp
  8002da:	57                   	push   %edi
  8002db:	56                   	push   %esi
  8002dc:	53                   	push   %ebx
  8002dd:	83 ec 3c             	sub    $0x3c,%esp
  8002e0:	e8 24 05 00 00       	call   800809 <__x86.get_pc_thunk.ax>
  8002e5:	05 1b 1d 00 00       	add    $0x1d1b,%eax
  8002ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002ed:	8b 75 08             	mov    0x8(%ebp),%esi
  8002f0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8002f3:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8002f6:	8d 80 10 00 00 00    	lea    0x10(%eax),%eax
  8002fc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8002ff:	e9 cd 03 00 00       	jmp    8006d1 <.L25+0x48>
		padc = ' ';
  800304:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		altflag = 0;
  800308:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80030f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800316:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  80031d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800322:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800325:	89 75 08             	mov    %esi,0x8(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800328:	8d 43 01             	lea    0x1(%ebx),%eax
  80032b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80032e:	0f b6 13             	movzbl (%ebx),%edx
  800331:	8d 42 dd             	lea    -0x23(%edx),%eax
  800334:	3c 55                	cmp    $0x55,%al
  800336:	0f 87 21 04 00 00    	ja     80075d <.L20>
  80033c:	0f b6 c0             	movzbl %al,%eax
  80033f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800342:	89 ce                	mov    %ecx,%esi
  800344:	03 b4 81 f8 ef ff ff 	add    -0x1008(%ecx,%eax,4),%esi
  80034b:	3e ff e6             	notrack jmp *%esi

0080034e <.L68>:
  80034e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			padc = '-';
  800351:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800355:	eb d1                	jmp    800328 <vprintfmt+0x55>

00800357 <.L32>:
		switch (ch = *(unsigned char *) fmt++) {
  800357:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80035a:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80035e:	eb c8                	jmp    800328 <vprintfmt+0x55>

00800360 <.L31>:
  800360:	0f b6 d2             	movzbl %dl,%edx
  800363:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			for (precision = 0; ; ++fmt) {
  800366:	b8 00 00 00 00       	mov    $0x0,%eax
  80036b:	8b 75 08             	mov    0x8(%ebp),%esi
				precision = precision * 10 + ch - '0';
  80036e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800371:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800375:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  800378:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80037b:	83 f9 09             	cmp    $0x9,%ecx
  80037e:	77 58                	ja     8003d8 <.L36+0xf>
			for (precision = 0; ; ++fmt) {
  800380:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  800383:	eb e9                	jmp    80036e <.L31+0xe>

00800385 <.L34>:
			precision = va_arg(ap, int);
  800385:	8b 45 14             	mov    0x14(%ebp),%eax
  800388:	8b 00                	mov    (%eax),%eax
  80038a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80038d:	8b 45 14             	mov    0x14(%ebp),%eax
  800390:	8d 40 04             	lea    0x4(%eax),%eax
  800393:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800396:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			if (width < 0)
  800399:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80039d:	79 89                	jns    800328 <vprintfmt+0x55>
				width = precision, precision = -1;
  80039f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003a2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8003a5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003ac:	e9 77 ff ff ff       	jmp    800328 <vprintfmt+0x55>

008003b1 <.L33>:
  8003b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003b4:	85 c0                	test   %eax,%eax
  8003b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8003bb:	0f 49 d0             	cmovns %eax,%edx
  8003be:	89 55 d4             	mov    %edx,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  8003c4:	e9 5f ff ff ff       	jmp    800328 <vprintfmt+0x55>

008003c9 <.L36>:
		switch (ch = *(unsigned char *) fmt++) {
  8003c9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			altflag = 1;
  8003cc:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003d3:	e9 50 ff ff ff       	jmp    800328 <vprintfmt+0x55>
  8003d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003db:	89 75 08             	mov    %esi,0x8(%ebp)
  8003de:	eb b9                	jmp    800399 <.L34+0x14>

008003e0 <.L27>:
			lflag++;
  8003e0:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003e4:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  8003e7:	e9 3c ff ff ff       	jmp    800328 <vprintfmt+0x55>

008003ec <.L30>:
  8003ec:	8b 75 08             	mov    0x8(%ebp),%esi
			putch(va_arg(ap, int), putdat);
  8003ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f2:	8d 58 04             	lea    0x4(%eax),%ebx
  8003f5:	83 ec 08             	sub    $0x8,%esp
  8003f8:	57                   	push   %edi
  8003f9:	ff 30                	pushl  (%eax)
  8003fb:	ff d6                	call   *%esi
			break;
  8003fd:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800400:	89 5d 14             	mov    %ebx,0x14(%ebp)
			break;
  800403:	e9 c6 02 00 00       	jmp    8006ce <.L25+0x45>

00800408 <.L28>:
  800408:	8b 75 08             	mov    0x8(%ebp),%esi
			err = va_arg(ap, int);
  80040b:	8b 45 14             	mov    0x14(%ebp),%eax
  80040e:	8d 58 04             	lea    0x4(%eax),%ebx
  800411:	8b 00                	mov    (%eax),%eax
  800413:	99                   	cltd   
  800414:	31 d0                	xor    %edx,%eax
  800416:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800418:	83 f8 06             	cmp    $0x6,%eax
  80041b:	7f 27                	jg     800444 <.L28+0x3c>
  80041d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800420:	8b 14 82             	mov    (%edx,%eax,4),%edx
  800423:	85 d2                	test   %edx,%edx
  800425:	74 1d                	je     800444 <.L28+0x3c>
				printfmt(putch, putdat, "%s", p);
  800427:	52                   	push   %edx
  800428:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80042b:	8d 80 89 ef ff ff    	lea    -0x1077(%eax),%eax
  800431:	50                   	push   %eax
  800432:	57                   	push   %edi
  800433:	56                   	push   %esi
  800434:	e8 79 fe ff ff       	call   8002b2 <printfmt>
  800439:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80043c:	89 5d 14             	mov    %ebx,0x14(%ebp)
  80043f:	e9 8a 02 00 00       	jmp    8006ce <.L25+0x45>
				printfmt(putch, putdat, "error %d", err);
  800444:	50                   	push   %eax
  800445:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800448:	8d 80 80 ef ff ff    	lea    -0x1080(%eax),%eax
  80044e:	50                   	push   %eax
  80044f:	57                   	push   %edi
  800450:	56                   	push   %esi
  800451:	e8 5c fe ff ff       	call   8002b2 <printfmt>
  800456:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800459:	89 5d 14             	mov    %ebx,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80045c:	e9 6d 02 00 00       	jmp    8006ce <.L25+0x45>

00800461 <.L24>:
  800461:	8b 75 08             	mov    0x8(%ebp),%esi
			if ((p = va_arg(ap, char *)) == NULL)
  800464:	8b 45 14             	mov    0x14(%ebp),%eax
  800467:	83 c0 04             	add    $0x4,%eax
  80046a:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80046d:	8b 45 14             	mov    0x14(%ebp),%eax
  800470:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800472:	85 d2                	test   %edx,%edx
  800474:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800477:	8d 80 79 ef ff ff    	lea    -0x1087(%eax),%eax
  80047d:	0f 45 c2             	cmovne %edx,%eax
  800480:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800483:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800487:	7e 06                	jle    80048f <.L24+0x2e>
  800489:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80048d:	75 0d                	jne    80049c <.L24+0x3b>
				for (width -= strnlen(p, precision); width > 0; width--)
  80048f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800492:	89 c3                	mov    %eax,%ebx
  800494:	03 45 d4             	add    -0x2c(%ebp),%eax
  800497:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80049a:	eb 58                	jmp    8004f4 <.L24+0x93>
  80049c:	83 ec 08             	sub    $0x8,%esp
  80049f:	ff 75 d8             	pushl  -0x28(%ebp)
  8004a2:	ff 75 c8             	pushl  -0x38(%ebp)
  8004a5:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004a8:	e8 80 03 00 00       	call   80082d <strnlen>
  8004ad:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004b0:	29 c2                	sub    %eax,%edx
  8004b2:	89 55 bc             	mov    %edx,-0x44(%ebp)
  8004b5:	83 c4 10             	add    $0x10,%esp
  8004b8:	89 d3                	mov    %edx,%ebx
					putch(padc, putdat);
  8004ba:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004be:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c1:	85 db                	test   %ebx,%ebx
  8004c3:	7e 11                	jle    8004d6 <.L24+0x75>
					putch(padc, putdat);
  8004c5:	83 ec 08             	sub    $0x8,%esp
  8004c8:	57                   	push   %edi
  8004c9:	ff 75 d4             	pushl  -0x2c(%ebp)
  8004cc:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ce:	83 eb 01             	sub    $0x1,%ebx
  8004d1:	83 c4 10             	add    $0x10,%esp
  8004d4:	eb eb                	jmp    8004c1 <.L24+0x60>
  8004d6:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8004d9:	85 d2                	test   %edx,%edx
  8004db:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e0:	0f 49 c2             	cmovns %edx,%eax
  8004e3:	29 c2                	sub    %eax,%edx
  8004e5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8004e8:	eb a5                	jmp    80048f <.L24+0x2e>
					putch(ch, putdat);
  8004ea:	83 ec 08             	sub    $0x8,%esp
  8004ed:	57                   	push   %edi
  8004ee:	52                   	push   %edx
  8004ef:	ff d6                	call   *%esi
  8004f1:	83 c4 10             	add    $0x10,%esp
  8004f4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8004f7:	29 d9                	sub    %ebx,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004f9:	83 c3 01             	add    $0x1,%ebx
  8004fc:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  800500:	0f be d0             	movsbl %al,%edx
  800503:	85 d2                	test   %edx,%edx
  800505:	74 4b                	je     800552 <.L24+0xf1>
  800507:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80050b:	78 06                	js     800513 <.L24+0xb2>
  80050d:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800511:	78 1e                	js     800531 <.L24+0xd0>
				if (altflag && (ch < ' ' || ch > '~'))
  800513:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800517:	74 d1                	je     8004ea <.L24+0x89>
  800519:	0f be c0             	movsbl %al,%eax
  80051c:	83 e8 20             	sub    $0x20,%eax
  80051f:	83 f8 5e             	cmp    $0x5e,%eax
  800522:	76 c6                	jbe    8004ea <.L24+0x89>
					putch('?', putdat);
  800524:	83 ec 08             	sub    $0x8,%esp
  800527:	57                   	push   %edi
  800528:	6a 3f                	push   $0x3f
  80052a:	ff d6                	call   *%esi
  80052c:	83 c4 10             	add    $0x10,%esp
  80052f:	eb c3                	jmp    8004f4 <.L24+0x93>
  800531:	89 cb                	mov    %ecx,%ebx
  800533:	eb 0e                	jmp    800543 <.L24+0xe2>
				putch(' ', putdat);
  800535:	83 ec 08             	sub    $0x8,%esp
  800538:	57                   	push   %edi
  800539:	6a 20                	push   $0x20
  80053b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80053d:	83 eb 01             	sub    $0x1,%ebx
  800540:	83 c4 10             	add    $0x10,%esp
  800543:	85 db                	test   %ebx,%ebx
  800545:	7f ee                	jg     800535 <.L24+0xd4>
			if ((p = va_arg(ap, char *)) == NULL)
  800547:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80054a:	89 45 14             	mov    %eax,0x14(%ebp)
  80054d:	e9 7c 01 00 00       	jmp    8006ce <.L25+0x45>
  800552:	89 cb                	mov    %ecx,%ebx
  800554:	eb ed                	jmp    800543 <.L24+0xe2>

00800556 <.L29>:
  800556:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800559:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  80055c:	83 f9 01             	cmp    $0x1,%ecx
  80055f:	7f 1b                	jg     80057c <.L29+0x26>
	else if (lflag)
  800561:	85 c9                	test   %ecx,%ecx
  800563:	74 63                	je     8005c8 <.L29+0x72>
		return va_arg(*ap, long);
  800565:	8b 45 14             	mov    0x14(%ebp),%eax
  800568:	8b 00                	mov    (%eax),%eax
  80056a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80056d:	99                   	cltd   
  80056e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800571:	8b 45 14             	mov    0x14(%ebp),%eax
  800574:	8d 40 04             	lea    0x4(%eax),%eax
  800577:	89 45 14             	mov    %eax,0x14(%ebp)
  80057a:	eb 17                	jmp    800593 <.L29+0x3d>
		return va_arg(*ap, long long);
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	8b 50 04             	mov    0x4(%eax),%edx
  800582:	8b 00                	mov    (%eax),%eax
  800584:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800587:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80058a:	8b 45 14             	mov    0x14(%ebp),%eax
  80058d:	8d 40 08             	lea    0x8(%eax),%eax
  800590:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800593:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800596:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800599:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80059e:	85 c9                	test   %ecx,%ecx
  8005a0:	0f 89 0e 01 00 00    	jns    8006b4 <.L25+0x2b>
				putch('-', putdat);
  8005a6:	83 ec 08             	sub    $0x8,%esp
  8005a9:	57                   	push   %edi
  8005aa:	6a 2d                	push   $0x2d
  8005ac:	ff d6                	call   *%esi
				num = -(long long) num;
  8005ae:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005b1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005b4:	f7 da                	neg    %edx
  8005b6:	83 d1 00             	adc    $0x0,%ecx
  8005b9:	f7 d9                	neg    %ecx
  8005bb:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005be:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005c3:	e9 ec 00 00 00       	jmp    8006b4 <.L25+0x2b>
		return va_arg(*ap, int);
  8005c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cb:	8b 00                	mov    (%eax),%eax
  8005cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d0:	99                   	cltd   
  8005d1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d7:	8d 40 04             	lea    0x4(%eax),%eax
  8005da:	89 45 14             	mov    %eax,0x14(%ebp)
  8005dd:	eb b4                	jmp    800593 <.L29+0x3d>

008005df <.L23>:
  8005df:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8005e2:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  8005e5:	83 f9 01             	cmp    $0x1,%ecx
  8005e8:	7f 1e                	jg     800608 <.L23+0x29>
	else if (lflag)
  8005ea:	85 c9                	test   %ecx,%ecx
  8005ec:	74 32                	je     800620 <.L23+0x41>
		return va_arg(*ap, unsigned long);
  8005ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f1:	8b 10                	mov    (%eax),%edx
  8005f3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005f8:	8d 40 04             	lea    0x4(%eax),%eax
  8005fb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005fe:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800603:	e9 ac 00 00 00       	jmp    8006b4 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  800608:	8b 45 14             	mov    0x14(%ebp),%eax
  80060b:	8b 10                	mov    (%eax),%edx
  80060d:	8b 48 04             	mov    0x4(%eax),%ecx
  800610:	8d 40 08             	lea    0x8(%eax),%eax
  800613:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800616:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80061b:	e9 94 00 00 00       	jmp    8006b4 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  800620:	8b 45 14             	mov    0x14(%ebp),%eax
  800623:	8b 10                	mov    (%eax),%edx
  800625:	b9 00 00 00 00       	mov    $0x0,%ecx
  80062a:	8d 40 04             	lea    0x4(%eax),%eax
  80062d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800630:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800635:	eb 7d                	jmp    8006b4 <.L25+0x2b>

00800637 <.L26>:
  800637:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80063a:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  80063d:	83 f9 01             	cmp    $0x1,%ecx
  800640:	7f 1b                	jg     80065d <.L26+0x26>
	else if (lflag)
  800642:	85 c9                	test   %ecx,%ecx
  800644:	74 2c                	je     800672 <.L26+0x3b>
		return va_arg(*ap, unsigned long);
  800646:	8b 45 14             	mov    0x14(%ebp),%eax
  800649:	8b 10                	mov    (%eax),%edx
  80064b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800650:	8d 40 04             	lea    0x4(%eax),%eax
  800653:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800656:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  80065b:	eb 57                	jmp    8006b4 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  80065d:	8b 45 14             	mov    0x14(%ebp),%eax
  800660:	8b 10                	mov    (%eax),%edx
  800662:	8b 48 04             	mov    0x4(%eax),%ecx
  800665:	8d 40 08             	lea    0x8(%eax),%eax
  800668:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80066b:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800670:	eb 42                	jmp    8006b4 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  800672:	8b 45 14             	mov    0x14(%ebp),%eax
  800675:	8b 10                	mov    (%eax),%edx
  800677:	b9 00 00 00 00       	mov    $0x0,%ecx
  80067c:	8d 40 04             	lea    0x4(%eax),%eax
  80067f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800682:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800687:	eb 2b                	jmp    8006b4 <.L25+0x2b>

00800689 <.L25>:
  800689:	8b 75 08             	mov    0x8(%ebp),%esi
			putch('0', putdat);
  80068c:	83 ec 08             	sub    $0x8,%esp
  80068f:	57                   	push   %edi
  800690:	6a 30                	push   $0x30
  800692:	ff d6                	call   *%esi
			putch('x', putdat);
  800694:	83 c4 08             	add    $0x8,%esp
  800697:	57                   	push   %edi
  800698:	6a 78                	push   $0x78
  80069a:	ff d6                	call   *%esi
			num = (unsigned long long)
  80069c:	8b 45 14             	mov    0x14(%ebp),%eax
  80069f:	8b 10                	mov    (%eax),%edx
  8006a1:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006a6:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006a9:	8d 40 04             	lea    0x4(%eax),%eax
  8006ac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006af:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006b4:	83 ec 0c             	sub    $0xc,%esp
  8006b7:	0f be 5d cf          	movsbl -0x31(%ebp),%ebx
  8006bb:	53                   	push   %ebx
  8006bc:	ff 75 d4             	pushl  -0x2c(%ebp)
  8006bf:	50                   	push   %eax
  8006c0:	51                   	push   %ecx
  8006c1:	52                   	push   %edx
  8006c2:	89 fa                	mov    %edi,%edx
  8006c4:	89 f0                	mov    %esi,%eax
  8006c6:	e8 08 fb ff ff       	call   8001d3 <printnum>
			break;
  8006cb:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006ce:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006d1:	83 c3 01             	add    $0x1,%ebx
  8006d4:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  8006d8:	83 f8 25             	cmp    $0x25,%eax
  8006db:	0f 84 23 fc ff ff    	je     800304 <vprintfmt+0x31>
			if (ch == '\0')
  8006e1:	85 c0                	test   %eax,%eax
  8006e3:	0f 84 97 00 00 00    	je     800780 <.L20+0x23>
			putch(ch, putdat);
  8006e9:	83 ec 08             	sub    $0x8,%esp
  8006ec:	57                   	push   %edi
  8006ed:	50                   	push   %eax
  8006ee:	ff d6                	call   *%esi
  8006f0:	83 c4 10             	add    $0x10,%esp
  8006f3:	eb dc                	jmp    8006d1 <.L25+0x48>

008006f5 <.L21>:
  8006f5:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006f8:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  8006fb:	83 f9 01             	cmp    $0x1,%ecx
  8006fe:	7f 1b                	jg     80071b <.L21+0x26>
	else if (lflag)
  800700:	85 c9                	test   %ecx,%ecx
  800702:	74 2c                	je     800730 <.L21+0x3b>
		return va_arg(*ap, unsigned long);
  800704:	8b 45 14             	mov    0x14(%ebp),%eax
  800707:	8b 10                	mov    (%eax),%edx
  800709:	b9 00 00 00 00       	mov    $0x0,%ecx
  80070e:	8d 40 04             	lea    0x4(%eax),%eax
  800711:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800714:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800719:	eb 99                	jmp    8006b4 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  80071b:	8b 45 14             	mov    0x14(%ebp),%eax
  80071e:	8b 10                	mov    (%eax),%edx
  800720:	8b 48 04             	mov    0x4(%eax),%ecx
  800723:	8d 40 08             	lea    0x8(%eax),%eax
  800726:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800729:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  80072e:	eb 84                	jmp    8006b4 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  800730:	8b 45 14             	mov    0x14(%ebp),%eax
  800733:	8b 10                	mov    (%eax),%edx
  800735:	b9 00 00 00 00       	mov    $0x0,%ecx
  80073a:	8d 40 04             	lea    0x4(%eax),%eax
  80073d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800740:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800745:	e9 6a ff ff ff       	jmp    8006b4 <.L25+0x2b>

0080074a <.L35>:
  80074a:	8b 75 08             	mov    0x8(%ebp),%esi
			putch(ch, putdat);
  80074d:	83 ec 08             	sub    $0x8,%esp
  800750:	57                   	push   %edi
  800751:	6a 25                	push   $0x25
  800753:	ff d6                	call   *%esi
			break;
  800755:	83 c4 10             	add    $0x10,%esp
  800758:	e9 71 ff ff ff       	jmp    8006ce <.L25+0x45>

0080075d <.L20>:
  80075d:	8b 75 08             	mov    0x8(%ebp),%esi
			putch('%', putdat);
  800760:	83 ec 08             	sub    $0x8,%esp
  800763:	57                   	push   %edi
  800764:	6a 25                	push   $0x25
  800766:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800768:	83 c4 10             	add    $0x10,%esp
  80076b:	89 d8                	mov    %ebx,%eax
  80076d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800771:	74 05                	je     800778 <.L20+0x1b>
  800773:	83 e8 01             	sub    $0x1,%eax
  800776:	eb f5                	jmp    80076d <.L20+0x10>
  800778:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80077b:	e9 4e ff ff ff       	jmp    8006ce <.L25+0x45>
}
  800780:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800783:	5b                   	pop    %ebx
  800784:	5e                   	pop    %esi
  800785:	5f                   	pop    %edi
  800786:	5d                   	pop    %ebp
  800787:	c3                   	ret    

00800788 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800788:	f3 0f 1e fb          	endbr32 
  80078c:	55                   	push   %ebp
  80078d:	89 e5                	mov    %esp,%ebp
  80078f:	53                   	push   %ebx
  800790:	83 ec 14             	sub    $0x14,%esp
  800793:	e8 df f8 ff ff       	call   800077 <__x86.get_pc_thunk.bx>
  800798:	81 c3 68 18 00 00    	add    $0x1868,%ebx
  80079e:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007a7:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007ab:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007b5:	85 c0                	test   %eax,%eax
  8007b7:	74 2b                	je     8007e4 <vsnprintf+0x5c>
  8007b9:	85 d2                	test   %edx,%edx
  8007bb:	7e 27                	jle    8007e4 <vsnprintf+0x5c>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007bd:	ff 75 14             	pushl  0x14(%ebp)
  8007c0:	ff 75 10             	pushl  0x10(%ebp)
  8007c3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007c6:	50                   	push   %eax
  8007c7:	8d 83 91 e2 ff ff    	lea    -0x1d6f(%ebx),%eax
  8007cd:	50                   	push   %eax
  8007ce:	e8 00 fb ff ff       	call   8002d3 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007d6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007dc:	83 c4 10             	add    $0x10,%esp
}
  8007df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007e2:	c9                   	leave  
  8007e3:	c3                   	ret    
		return -E_INVAL;
  8007e4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007e9:	eb f4                	jmp    8007df <vsnprintf+0x57>

008007eb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007eb:	f3 0f 1e fb          	endbr32 
  8007ef:	55                   	push   %ebp
  8007f0:	89 e5                	mov    %esp,%ebp
  8007f2:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007f5:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007f8:	50                   	push   %eax
  8007f9:	ff 75 10             	pushl  0x10(%ebp)
  8007fc:	ff 75 0c             	pushl  0xc(%ebp)
  8007ff:	ff 75 08             	pushl  0x8(%ebp)
  800802:	e8 81 ff ff ff       	call   800788 <vsnprintf>
	va_end(ap);

	return rc;
}
  800807:	c9                   	leave  
  800808:	c3                   	ret    

00800809 <__x86.get_pc_thunk.ax>:
  800809:	8b 04 24             	mov    (%esp),%eax
  80080c:	c3                   	ret    

0080080d <__x86.get_pc_thunk.cx>:
  80080d:	8b 0c 24             	mov    (%esp),%ecx
  800810:	c3                   	ret    

00800811 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800811:	f3 0f 1e fb          	endbr32 
  800815:	55                   	push   %ebp
  800816:	89 e5                	mov    %esp,%ebp
  800818:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80081b:	b8 00 00 00 00       	mov    $0x0,%eax
  800820:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800824:	74 05                	je     80082b <strlen+0x1a>
		n++;
  800826:	83 c0 01             	add    $0x1,%eax
  800829:	eb f5                	jmp    800820 <strlen+0xf>
	return n;
}
  80082b:	5d                   	pop    %ebp
  80082c:	c3                   	ret    

0080082d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80082d:	f3 0f 1e fb          	endbr32 
  800831:	55                   	push   %ebp
  800832:	89 e5                	mov    %esp,%ebp
  800834:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800837:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80083a:	b8 00 00 00 00       	mov    $0x0,%eax
  80083f:	39 d0                	cmp    %edx,%eax
  800841:	74 0d                	je     800850 <strnlen+0x23>
  800843:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800847:	74 05                	je     80084e <strnlen+0x21>
		n++;
  800849:	83 c0 01             	add    $0x1,%eax
  80084c:	eb f1                	jmp    80083f <strnlen+0x12>
  80084e:	89 c2                	mov    %eax,%edx
	return n;
}
  800850:	89 d0                	mov    %edx,%eax
  800852:	5d                   	pop    %ebp
  800853:	c3                   	ret    

00800854 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800854:	f3 0f 1e fb          	endbr32 
  800858:	55                   	push   %ebp
  800859:	89 e5                	mov    %esp,%ebp
  80085b:	53                   	push   %ebx
  80085c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80085f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800862:	b8 00 00 00 00       	mov    $0x0,%eax
  800867:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80086b:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  80086e:	83 c0 01             	add    $0x1,%eax
  800871:	84 d2                	test   %dl,%dl
  800873:	75 f2                	jne    800867 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800875:	89 c8                	mov    %ecx,%eax
  800877:	5b                   	pop    %ebx
  800878:	5d                   	pop    %ebp
  800879:	c3                   	ret    

0080087a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80087a:	f3 0f 1e fb          	endbr32 
  80087e:	55                   	push   %ebp
  80087f:	89 e5                	mov    %esp,%ebp
  800881:	53                   	push   %ebx
  800882:	83 ec 10             	sub    $0x10,%esp
  800885:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800888:	53                   	push   %ebx
  800889:	e8 83 ff ff ff       	call   800811 <strlen>
  80088e:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800891:	ff 75 0c             	pushl  0xc(%ebp)
  800894:	01 d8                	add    %ebx,%eax
  800896:	50                   	push   %eax
  800897:	e8 b8 ff ff ff       	call   800854 <strcpy>
	return dst;
}
  80089c:	89 d8                	mov    %ebx,%eax
  80089e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008a1:	c9                   	leave  
  8008a2:	c3                   	ret    

008008a3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008a3:	f3 0f 1e fb          	endbr32 
  8008a7:	55                   	push   %ebp
  8008a8:	89 e5                	mov    %esp,%ebp
  8008aa:	56                   	push   %esi
  8008ab:	53                   	push   %ebx
  8008ac:	8b 75 08             	mov    0x8(%ebp),%esi
  8008af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b2:	89 f3                	mov    %esi,%ebx
  8008b4:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008b7:	89 f0                	mov    %esi,%eax
  8008b9:	39 d8                	cmp    %ebx,%eax
  8008bb:	74 11                	je     8008ce <strncpy+0x2b>
		*dst++ = *src;
  8008bd:	83 c0 01             	add    $0x1,%eax
  8008c0:	0f b6 0a             	movzbl (%edx),%ecx
  8008c3:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008c6:	80 f9 01             	cmp    $0x1,%cl
  8008c9:	83 da ff             	sbb    $0xffffffff,%edx
  8008cc:	eb eb                	jmp    8008b9 <strncpy+0x16>
	}
	return ret;
}
  8008ce:	89 f0                	mov    %esi,%eax
  8008d0:	5b                   	pop    %ebx
  8008d1:	5e                   	pop    %esi
  8008d2:	5d                   	pop    %ebp
  8008d3:	c3                   	ret    

008008d4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008d4:	f3 0f 1e fb          	endbr32 
  8008d8:	55                   	push   %ebp
  8008d9:	89 e5                	mov    %esp,%ebp
  8008db:	56                   	push   %esi
  8008dc:	53                   	push   %ebx
  8008dd:	8b 75 08             	mov    0x8(%ebp),%esi
  8008e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008e3:	8b 55 10             	mov    0x10(%ebp),%edx
  8008e6:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008e8:	85 d2                	test   %edx,%edx
  8008ea:	74 21                	je     80090d <strlcpy+0x39>
  8008ec:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008f0:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008f2:	39 c2                	cmp    %eax,%edx
  8008f4:	74 14                	je     80090a <strlcpy+0x36>
  8008f6:	0f b6 19             	movzbl (%ecx),%ebx
  8008f9:	84 db                	test   %bl,%bl
  8008fb:	74 0b                	je     800908 <strlcpy+0x34>
			*dst++ = *src++;
  8008fd:	83 c1 01             	add    $0x1,%ecx
  800900:	83 c2 01             	add    $0x1,%edx
  800903:	88 5a ff             	mov    %bl,-0x1(%edx)
  800906:	eb ea                	jmp    8008f2 <strlcpy+0x1e>
  800908:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80090a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80090d:	29 f0                	sub    %esi,%eax
}
  80090f:	5b                   	pop    %ebx
  800910:	5e                   	pop    %esi
  800911:	5d                   	pop    %ebp
  800912:	c3                   	ret    

00800913 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800913:	f3 0f 1e fb          	endbr32 
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
  80091a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80091d:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800920:	0f b6 01             	movzbl (%ecx),%eax
  800923:	84 c0                	test   %al,%al
  800925:	74 0c                	je     800933 <strcmp+0x20>
  800927:	3a 02                	cmp    (%edx),%al
  800929:	75 08                	jne    800933 <strcmp+0x20>
		p++, q++;
  80092b:	83 c1 01             	add    $0x1,%ecx
  80092e:	83 c2 01             	add    $0x1,%edx
  800931:	eb ed                	jmp    800920 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800933:	0f b6 c0             	movzbl %al,%eax
  800936:	0f b6 12             	movzbl (%edx),%edx
  800939:	29 d0                	sub    %edx,%eax
}
  80093b:	5d                   	pop    %ebp
  80093c:	c3                   	ret    

0080093d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80093d:	f3 0f 1e fb          	endbr32 
  800941:	55                   	push   %ebp
  800942:	89 e5                	mov    %esp,%ebp
  800944:	53                   	push   %ebx
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094b:	89 c3                	mov    %eax,%ebx
  80094d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800950:	eb 06                	jmp    800958 <strncmp+0x1b>
		n--, p++, q++;
  800952:	83 c0 01             	add    $0x1,%eax
  800955:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800958:	39 d8                	cmp    %ebx,%eax
  80095a:	74 16                	je     800972 <strncmp+0x35>
  80095c:	0f b6 08             	movzbl (%eax),%ecx
  80095f:	84 c9                	test   %cl,%cl
  800961:	74 04                	je     800967 <strncmp+0x2a>
  800963:	3a 0a                	cmp    (%edx),%cl
  800965:	74 eb                	je     800952 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800967:	0f b6 00             	movzbl (%eax),%eax
  80096a:	0f b6 12             	movzbl (%edx),%edx
  80096d:	29 d0                	sub    %edx,%eax
}
  80096f:	5b                   	pop    %ebx
  800970:	5d                   	pop    %ebp
  800971:	c3                   	ret    
		return 0;
  800972:	b8 00 00 00 00       	mov    $0x0,%eax
  800977:	eb f6                	jmp    80096f <strncmp+0x32>

00800979 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800979:	f3 0f 1e fb          	endbr32 
  80097d:	55                   	push   %ebp
  80097e:	89 e5                	mov    %esp,%ebp
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
  800983:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800987:	0f b6 10             	movzbl (%eax),%edx
  80098a:	84 d2                	test   %dl,%dl
  80098c:	74 09                	je     800997 <strchr+0x1e>
		if (*s == c)
  80098e:	38 ca                	cmp    %cl,%dl
  800990:	74 0a                	je     80099c <strchr+0x23>
	for (; *s; s++)
  800992:	83 c0 01             	add    $0x1,%eax
  800995:	eb f0                	jmp    800987 <strchr+0xe>
			return (char *) s;
	return 0;
  800997:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80099c:	5d                   	pop    %ebp
  80099d:	c3                   	ret    

0080099e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80099e:	f3 0f 1e fb          	endbr32 
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009ac:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009af:	38 ca                	cmp    %cl,%dl
  8009b1:	74 09                	je     8009bc <strfind+0x1e>
  8009b3:	84 d2                	test   %dl,%dl
  8009b5:	74 05                	je     8009bc <strfind+0x1e>
	for (; *s; s++)
  8009b7:	83 c0 01             	add    $0x1,%eax
  8009ba:	eb f0                	jmp    8009ac <strfind+0xe>
			break;
	return (char *) s;
}
  8009bc:	5d                   	pop    %ebp
  8009bd:	c3                   	ret    

008009be <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009be:	f3 0f 1e fb          	endbr32 
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	57                   	push   %edi
  8009c6:	56                   	push   %esi
  8009c7:	53                   	push   %ebx
  8009c8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009ce:	85 c9                	test   %ecx,%ecx
  8009d0:	74 31                	je     800a03 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009d2:	89 f8                	mov    %edi,%eax
  8009d4:	09 c8                	or     %ecx,%eax
  8009d6:	a8 03                	test   $0x3,%al
  8009d8:	75 23                	jne    8009fd <memset+0x3f>
		c &= 0xFF;
  8009da:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009de:	89 d3                	mov    %edx,%ebx
  8009e0:	c1 e3 08             	shl    $0x8,%ebx
  8009e3:	89 d0                	mov    %edx,%eax
  8009e5:	c1 e0 18             	shl    $0x18,%eax
  8009e8:	89 d6                	mov    %edx,%esi
  8009ea:	c1 e6 10             	shl    $0x10,%esi
  8009ed:	09 f0                	or     %esi,%eax
  8009ef:	09 c2                	or     %eax,%edx
  8009f1:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009f3:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009f6:	89 d0                	mov    %edx,%eax
  8009f8:	fc                   	cld    
  8009f9:	f3 ab                	rep stos %eax,%es:(%edi)
  8009fb:	eb 06                	jmp    800a03 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a00:	fc                   	cld    
  800a01:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a03:	89 f8                	mov    %edi,%eax
  800a05:	5b                   	pop    %ebx
  800a06:	5e                   	pop    %esi
  800a07:	5f                   	pop    %edi
  800a08:	5d                   	pop    %ebp
  800a09:	c3                   	ret    

00800a0a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a0a:	f3 0f 1e fb          	endbr32 
  800a0e:	55                   	push   %ebp
  800a0f:	89 e5                	mov    %esp,%ebp
  800a11:	57                   	push   %edi
  800a12:	56                   	push   %esi
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a19:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a1c:	39 c6                	cmp    %eax,%esi
  800a1e:	73 32                	jae    800a52 <memmove+0x48>
  800a20:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a23:	39 c2                	cmp    %eax,%edx
  800a25:	76 2b                	jbe    800a52 <memmove+0x48>
		s += n;
		d += n;
  800a27:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a2a:	89 fe                	mov    %edi,%esi
  800a2c:	09 ce                	or     %ecx,%esi
  800a2e:	09 d6                	or     %edx,%esi
  800a30:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a36:	75 0e                	jne    800a46 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a38:	83 ef 04             	sub    $0x4,%edi
  800a3b:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a3e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a41:	fd                   	std    
  800a42:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a44:	eb 09                	jmp    800a4f <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a46:	83 ef 01             	sub    $0x1,%edi
  800a49:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a4c:	fd                   	std    
  800a4d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a4f:	fc                   	cld    
  800a50:	eb 1a                	jmp    800a6c <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a52:	89 c2                	mov    %eax,%edx
  800a54:	09 ca                	or     %ecx,%edx
  800a56:	09 f2                	or     %esi,%edx
  800a58:	f6 c2 03             	test   $0x3,%dl
  800a5b:	75 0a                	jne    800a67 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a5d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a60:	89 c7                	mov    %eax,%edi
  800a62:	fc                   	cld    
  800a63:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a65:	eb 05                	jmp    800a6c <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800a67:	89 c7                	mov    %eax,%edi
  800a69:	fc                   	cld    
  800a6a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a6c:	5e                   	pop    %esi
  800a6d:	5f                   	pop    %edi
  800a6e:	5d                   	pop    %ebp
  800a6f:	c3                   	ret    

00800a70 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a70:	f3 0f 1e fb          	endbr32 
  800a74:	55                   	push   %ebp
  800a75:	89 e5                	mov    %esp,%ebp
  800a77:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a7a:	ff 75 10             	pushl  0x10(%ebp)
  800a7d:	ff 75 0c             	pushl  0xc(%ebp)
  800a80:	ff 75 08             	pushl  0x8(%ebp)
  800a83:	e8 82 ff ff ff       	call   800a0a <memmove>
}
  800a88:	c9                   	leave  
  800a89:	c3                   	ret    

00800a8a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a8a:	f3 0f 1e fb          	endbr32 
  800a8e:	55                   	push   %ebp
  800a8f:	89 e5                	mov    %esp,%ebp
  800a91:	56                   	push   %esi
  800a92:	53                   	push   %ebx
  800a93:	8b 45 08             	mov    0x8(%ebp),%eax
  800a96:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a99:	89 c6                	mov    %eax,%esi
  800a9b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a9e:	39 f0                	cmp    %esi,%eax
  800aa0:	74 1c                	je     800abe <memcmp+0x34>
		if (*s1 != *s2)
  800aa2:	0f b6 08             	movzbl (%eax),%ecx
  800aa5:	0f b6 1a             	movzbl (%edx),%ebx
  800aa8:	38 d9                	cmp    %bl,%cl
  800aaa:	75 08                	jne    800ab4 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800aac:	83 c0 01             	add    $0x1,%eax
  800aaf:	83 c2 01             	add    $0x1,%edx
  800ab2:	eb ea                	jmp    800a9e <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800ab4:	0f b6 c1             	movzbl %cl,%eax
  800ab7:	0f b6 db             	movzbl %bl,%ebx
  800aba:	29 d8                	sub    %ebx,%eax
  800abc:	eb 05                	jmp    800ac3 <memcmp+0x39>
	}

	return 0;
  800abe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ac3:	5b                   	pop    %ebx
  800ac4:	5e                   	pop    %esi
  800ac5:	5d                   	pop    %ebp
  800ac6:	c3                   	ret    

00800ac7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ac7:	f3 0f 1e fb          	endbr32 
  800acb:	55                   	push   %ebp
  800acc:	89 e5                	mov    %esp,%ebp
  800ace:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ad4:	89 c2                	mov    %eax,%edx
  800ad6:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ad9:	39 d0                	cmp    %edx,%eax
  800adb:	73 09                	jae    800ae6 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800add:	38 08                	cmp    %cl,(%eax)
  800adf:	74 05                	je     800ae6 <memfind+0x1f>
	for (; s < ends; s++)
  800ae1:	83 c0 01             	add    $0x1,%eax
  800ae4:	eb f3                	jmp    800ad9 <memfind+0x12>
			break;
	return (void *) s;
}
  800ae6:	5d                   	pop    %ebp
  800ae7:	c3                   	ret    

00800ae8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ae8:	f3 0f 1e fb          	endbr32 
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	57                   	push   %edi
  800af0:	56                   	push   %esi
  800af1:	53                   	push   %ebx
  800af2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800af5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800af8:	eb 03                	jmp    800afd <strtol+0x15>
		s++;
  800afa:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800afd:	0f b6 01             	movzbl (%ecx),%eax
  800b00:	3c 20                	cmp    $0x20,%al
  800b02:	74 f6                	je     800afa <strtol+0x12>
  800b04:	3c 09                	cmp    $0x9,%al
  800b06:	74 f2                	je     800afa <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800b08:	3c 2b                	cmp    $0x2b,%al
  800b0a:	74 2a                	je     800b36 <strtol+0x4e>
	int neg = 0;
  800b0c:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b11:	3c 2d                	cmp    $0x2d,%al
  800b13:	74 2b                	je     800b40 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b15:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b1b:	75 0f                	jne    800b2c <strtol+0x44>
  800b1d:	80 39 30             	cmpb   $0x30,(%ecx)
  800b20:	74 28                	je     800b4a <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b22:	85 db                	test   %ebx,%ebx
  800b24:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b29:	0f 44 d8             	cmove  %eax,%ebx
  800b2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b31:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b34:	eb 46                	jmp    800b7c <strtol+0x94>
		s++;
  800b36:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b39:	bf 00 00 00 00       	mov    $0x0,%edi
  800b3e:	eb d5                	jmp    800b15 <strtol+0x2d>
		s++, neg = 1;
  800b40:	83 c1 01             	add    $0x1,%ecx
  800b43:	bf 01 00 00 00       	mov    $0x1,%edi
  800b48:	eb cb                	jmp    800b15 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b4a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b4e:	74 0e                	je     800b5e <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b50:	85 db                	test   %ebx,%ebx
  800b52:	75 d8                	jne    800b2c <strtol+0x44>
		s++, base = 8;
  800b54:	83 c1 01             	add    $0x1,%ecx
  800b57:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b5c:	eb ce                	jmp    800b2c <strtol+0x44>
		s += 2, base = 16;
  800b5e:	83 c1 02             	add    $0x2,%ecx
  800b61:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b66:	eb c4                	jmp    800b2c <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b68:	0f be d2             	movsbl %dl,%edx
  800b6b:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b6e:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b71:	7d 3a                	jge    800bad <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b73:	83 c1 01             	add    $0x1,%ecx
  800b76:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b7a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b7c:	0f b6 11             	movzbl (%ecx),%edx
  800b7f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b82:	89 f3                	mov    %esi,%ebx
  800b84:	80 fb 09             	cmp    $0x9,%bl
  800b87:	76 df                	jbe    800b68 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b89:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b8c:	89 f3                	mov    %esi,%ebx
  800b8e:	80 fb 19             	cmp    $0x19,%bl
  800b91:	77 08                	ja     800b9b <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b93:	0f be d2             	movsbl %dl,%edx
  800b96:	83 ea 57             	sub    $0x57,%edx
  800b99:	eb d3                	jmp    800b6e <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b9b:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b9e:	89 f3                	mov    %esi,%ebx
  800ba0:	80 fb 19             	cmp    $0x19,%bl
  800ba3:	77 08                	ja     800bad <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ba5:	0f be d2             	movsbl %dl,%edx
  800ba8:	83 ea 37             	sub    $0x37,%edx
  800bab:	eb c1                	jmp    800b6e <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb1:	74 05                	je     800bb8 <strtol+0xd0>
		*endptr = (char *) s;
  800bb3:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bb6:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bb8:	89 c2                	mov    %eax,%edx
  800bba:	f7 da                	neg    %edx
  800bbc:	85 ff                	test   %edi,%edi
  800bbe:	0f 45 c2             	cmovne %edx,%eax
}
  800bc1:	5b                   	pop    %ebx
  800bc2:	5e                   	pop    %esi
  800bc3:	5f                   	pop    %edi
  800bc4:	5d                   	pop    %ebp
  800bc5:	c3                   	ret    

00800bc6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bc6:	f3 0f 1e fb          	endbr32 
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	57                   	push   %edi
  800bce:	56                   	push   %esi
  800bcf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd0:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd5:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bdb:	89 c3                	mov    %eax,%ebx
  800bdd:	89 c7                	mov    %eax,%edi
  800bdf:	89 c6                	mov    %eax,%esi
  800be1:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800be3:	5b                   	pop    %ebx
  800be4:	5e                   	pop    %esi
  800be5:	5f                   	pop    %edi
  800be6:	5d                   	pop    %ebp
  800be7:	c3                   	ret    

00800be8 <sys_cgetc>:

int
sys_cgetc(void)
{
  800be8:	f3 0f 1e fb          	endbr32 
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	57                   	push   %edi
  800bf0:	56                   	push   %esi
  800bf1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bf2:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf7:	b8 01 00 00 00       	mov    $0x1,%eax
  800bfc:	89 d1                	mov    %edx,%ecx
  800bfe:	89 d3                	mov    %edx,%ebx
  800c00:	89 d7                	mov    %edx,%edi
  800c02:	89 d6                	mov    %edx,%esi
  800c04:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c06:	5b                   	pop    %ebx
  800c07:	5e                   	pop    %esi
  800c08:	5f                   	pop    %edi
  800c09:	5d                   	pop    %ebp
  800c0a:	c3                   	ret    

00800c0b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c0b:	f3 0f 1e fb          	endbr32 
  800c0f:	55                   	push   %ebp
  800c10:	89 e5                	mov    %esp,%ebp
  800c12:	57                   	push   %edi
  800c13:	56                   	push   %esi
  800c14:	53                   	push   %ebx
  800c15:	83 ec 1c             	sub    $0x1c,%esp
  800c18:	e8 ec fb ff ff       	call   800809 <__x86.get_pc_thunk.ax>
  800c1d:	05 e3 13 00 00       	add    $0x13e3,%eax
  800c22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	asm volatile("int %1\n"
  800c25:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2d:	b8 03 00 00 00       	mov    $0x3,%eax
  800c32:	89 cb                	mov    %ecx,%ebx
  800c34:	89 cf                	mov    %ecx,%edi
  800c36:	89 ce                	mov    %ecx,%esi
  800c38:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c3a:	85 c0                	test   %eax,%eax
  800c3c:	7f 08                	jg     800c46 <sys_env_destroy+0x3b>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c41:	5b                   	pop    %ebx
  800c42:	5e                   	pop    %esi
  800c43:	5f                   	pop    %edi
  800c44:	5d                   	pop    %ebp
  800c45:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c46:	83 ec 0c             	sub    $0xc,%esp
  800c49:	50                   	push   %eax
  800c4a:	6a 03                	push   $0x3
  800c4c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800c4f:	8d 83 50 f1 ff ff    	lea    -0xeb0(%ebx),%eax
  800c55:	50                   	push   %eax
  800c56:	6a 23                	push   $0x23
  800c58:	8d 83 6d f1 ff ff    	lea    -0xe93(%ebx),%eax
  800c5e:	50                   	push   %eax
  800c5f:	e8 23 00 00 00       	call   800c87 <_panic>

00800c64 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c64:	f3 0f 1e fb          	endbr32 
  800c68:	55                   	push   %ebp
  800c69:	89 e5                	mov    %esp,%ebp
  800c6b:	57                   	push   %edi
  800c6c:	56                   	push   %esi
  800c6d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c6e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c73:	b8 02 00 00 00       	mov    $0x2,%eax
  800c78:	89 d1                	mov    %edx,%ecx
  800c7a:	89 d3                	mov    %edx,%ebx
  800c7c:	89 d7                	mov    %edx,%edi
  800c7e:	89 d6                	mov    %edx,%esi
  800c80:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c82:	5b                   	pop    %ebx
  800c83:	5e                   	pop    %esi
  800c84:	5f                   	pop    %edi
  800c85:	5d                   	pop    %ebp
  800c86:	c3                   	ret    

00800c87 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800c87:	f3 0f 1e fb          	endbr32 
  800c8b:	55                   	push   %ebp
  800c8c:	89 e5                	mov    %esp,%ebp
  800c8e:	57                   	push   %edi
  800c8f:	56                   	push   %esi
  800c90:	53                   	push   %ebx
  800c91:	83 ec 0c             	sub    $0xc,%esp
  800c94:	e8 de f3 ff ff       	call   800077 <__x86.get_pc_thunk.bx>
  800c99:	81 c3 67 13 00 00    	add    $0x1367,%ebx
	va_list ap;

	va_start(ap, fmt);
  800c9f:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800ca2:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  800ca8:	8b 38                	mov    (%eax),%edi
  800caa:	e8 b5 ff ff ff       	call   800c64 <sys_getenvid>
  800caf:	83 ec 0c             	sub    $0xc,%esp
  800cb2:	ff 75 0c             	pushl  0xc(%ebp)
  800cb5:	ff 75 08             	pushl  0x8(%ebp)
  800cb8:	57                   	push   %edi
  800cb9:	50                   	push   %eax
  800cba:	8d 83 7c f1 ff ff    	lea    -0xe84(%ebx),%eax
  800cc0:	50                   	push   %eax
  800cc1:	e8 f5 f4 ff ff       	call   8001bb <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800cc6:	83 c4 18             	add    $0x18,%esp
  800cc9:	56                   	push   %esi
  800cca:	ff 75 10             	pushl  0x10(%ebp)
  800ccd:	e8 83 f4 ff ff       	call   800155 <vcprintf>
	cprintf("\n");
  800cd2:	8d 83 5c ef ff ff    	lea    -0x10a4(%ebx),%eax
  800cd8:	89 04 24             	mov    %eax,(%esp)
  800cdb:	e8 db f4 ff ff       	call   8001bb <cprintf>
  800ce0:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800ce3:	cc                   	int3   
  800ce4:	eb fd                	jmp    800ce3 <_panic+0x5c>
  800ce6:	66 90                	xchg   %ax,%ax
  800ce8:	66 90                	xchg   %ax,%ax
  800cea:	66 90                	xchg   %ax,%ax
  800cec:	66 90                	xchg   %ax,%ax
  800cee:	66 90                	xchg   %ax,%ax

00800cf0 <__udivdi3>:
  800cf0:	f3 0f 1e fb          	endbr32 
  800cf4:	55                   	push   %ebp
  800cf5:	57                   	push   %edi
  800cf6:	56                   	push   %esi
  800cf7:	53                   	push   %ebx
  800cf8:	83 ec 1c             	sub    $0x1c,%esp
  800cfb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800cff:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800d03:	8b 74 24 34          	mov    0x34(%esp),%esi
  800d07:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800d0b:	85 d2                	test   %edx,%edx
  800d0d:	75 19                	jne    800d28 <__udivdi3+0x38>
  800d0f:	39 f3                	cmp    %esi,%ebx
  800d11:	76 4d                	jbe    800d60 <__udivdi3+0x70>
  800d13:	31 ff                	xor    %edi,%edi
  800d15:	89 e8                	mov    %ebp,%eax
  800d17:	89 f2                	mov    %esi,%edx
  800d19:	f7 f3                	div    %ebx
  800d1b:	89 fa                	mov    %edi,%edx
  800d1d:	83 c4 1c             	add    $0x1c,%esp
  800d20:	5b                   	pop    %ebx
  800d21:	5e                   	pop    %esi
  800d22:	5f                   	pop    %edi
  800d23:	5d                   	pop    %ebp
  800d24:	c3                   	ret    
  800d25:	8d 76 00             	lea    0x0(%esi),%esi
  800d28:	39 f2                	cmp    %esi,%edx
  800d2a:	76 14                	jbe    800d40 <__udivdi3+0x50>
  800d2c:	31 ff                	xor    %edi,%edi
  800d2e:	31 c0                	xor    %eax,%eax
  800d30:	89 fa                	mov    %edi,%edx
  800d32:	83 c4 1c             	add    $0x1c,%esp
  800d35:	5b                   	pop    %ebx
  800d36:	5e                   	pop    %esi
  800d37:	5f                   	pop    %edi
  800d38:	5d                   	pop    %ebp
  800d39:	c3                   	ret    
  800d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800d40:	0f bd fa             	bsr    %edx,%edi
  800d43:	83 f7 1f             	xor    $0x1f,%edi
  800d46:	75 48                	jne    800d90 <__udivdi3+0xa0>
  800d48:	39 f2                	cmp    %esi,%edx
  800d4a:	72 06                	jb     800d52 <__udivdi3+0x62>
  800d4c:	31 c0                	xor    %eax,%eax
  800d4e:	39 eb                	cmp    %ebp,%ebx
  800d50:	77 de                	ja     800d30 <__udivdi3+0x40>
  800d52:	b8 01 00 00 00       	mov    $0x1,%eax
  800d57:	eb d7                	jmp    800d30 <__udivdi3+0x40>
  800d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800d60:	89 d9                	mov    %ebx,%ecx
  800d62:	85 db                	test   %ebx,%ebx
  800d64:	75 0b                	jne    800d71 <__udivdi3+0x81>
  800d66:	b8 01 00 00 00       	mov    $0x1,%eax
  800d6b:	31 d2                	xor    %edx,%edx
  800d6d:	f7 f3                	div    %ebx
  800d6f:	89 c1                	mov    %eax,%ecx
  800d71:	31 d2                	xor    %edx,%edx
  800d73:	89 f0                	mov    %esi,%eax
  800d75:	f7 f1                	div    %ecx
  800d77:	89 c6                	mov    %eax,%esi
  800d79:	89 e8                	mov    %ebp,%eax
  800d7b:	89 f7                	mov    %esi,%edi
  800d7d:	f7 f1                	div    %ecx
  800d7f:	89 fa                	mov    %edi,%edx
  800d81:	83 c4 1c             	add    $0x1c,%esp
  800d84:	5b                   	pop    %ebx
  800d85:	5e                   	pop    %esi
  800d86:	5f                   	pop    %edi
  800d87:	5d                   	pop    %ebp
  800d88:	c3                   	ret    
  800d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800d90:	89 f9                	mov    %edi,%ecx
  800d92:	b8 20 00 00 00       	mov    $0x20,%eax
  800d97:	29 f8                	sub    %edi,%eax
  800d99:	d3 e2                	shl    %cl,%edx
  800d9b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800d9f:	89 c1                	mov    %eax,%ecx
  800da1:	89 da                	mov    %ebx,%edx
  800da3:	d3 ea                	shr    %cl,%edx
  800da5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800da9:	09 d1                	or     %edx,%ecx
  800dab:	89 f2                	mov    %esi,%edx
  800dad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800db1:	89 f9                	mov    %edi,%ecx
  800db3:	d3 e3                	shl    %cl,%ebx
  800db5:	89 c1                	mov    %eax,%ecx
  800db7:	d3 ea                	shr    %cl,%edx
  800db9:	89 f9                	mov    %edi,%ecx
  800dbb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800dbf:	89 eb                	mov    %ebp,%ebx
  800dc1:	d3 e6                	shl    %cl,%esi
  800dc3:	89 c1                	mov    %eax,%ecx
  800dc5:	d3 eb                	shr    %cl,%ebx
  800dc7:	09 de                	or     %ebx,%esi
  800dc9:	89 f0                	mov    %esi,%eax
  800dcb:	f7 74 24 08          	divl   0x8(%esp)
  800dcf:	89 d6                	mov    %edx,%esi
  800dd1:	89 c3                	mov    %eax,%ebx
  800dd3:	f7 64 24 0c          	mull   0xc(%esp)
  800dd7:	39 d6                	cmp    %edx,%esi
  800dd9:	72 15                	jb     800df0 <__udivdi3+0x100>
  800ddb:	89 f9                	mov    %edi,%ecx
  800ddd:	d3 e5                	shl    %cl,%ebp
  800ddf:	39 c5                	cmp    %eax,%ebp
  800de1:	73 04                	jae    800de7 <__udivdi3+0xf7>
  800de3:	39 d6                	cmp    %edx,%esi
  800de5:	74 09                	je     800df0 <__udivdi3+0x100>
  800de7:	89 d8                	mov    %ebx,%eax
  800de9:	31 ff                	xor    %edi,%edi
  800deb:	e9 40 ff ff ff       	jmp    800d30 <__udivdi3+0x40>
  800df0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800df3:	31 ff                	xor    %edi,%edi
  800df5:	e9 36 ff ff ff       	jmp    800d30 <__udivdi3+0x40>
  800dfa:	66 90                	xchg   %ax,%ax
  800dfc:	66 90                	xchg   %ax,%ax
  800dfe:	66 90                	xchg   %ax,%ax

00800e00 <__umoddi3>:
  800e00:	f3 0f 1e fb          	endbr32 
  800e04:	55                   	push   %ebp
  800e05:	57                   	push   %edi
  800e06:	56                   	push   %esi
  800e07:	53                   	push   %ebx
  800e08:	83 ec 1c             	sub    $0x1c,%esp
  800e0b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800e0f:	8b 74 24 30          	mov    0x30(%esp),%esi
  800e13:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800e17:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800e1b:	85 c0                	test   %eax,%eax
  800e1d:	75 19                	jne    800e38 <__umoddi3+0x38>
  800e1f:	39 df                	cmp    %ebx,%edi
  800e21:	76 5d                	jbe    800e80 <__umoddi3+0x80>
  800e23:	89 f0                	mov    %esi,%eax
  800e25:	89 da                	mov    %ebx,%edx
  800e27:	f7 f7                	div    %edi
  800e29:	89 d0                	mov    %edx,%eax
  800e2b:	31 d2                	xor    %edx,%edx
  800e2d:	83 c4 1c             	add    $0x1c,%esp
  800e30:	5b                   	pop    %ebx
  800e31:	5e                   	pop    %esi
  800e32:	5f                   	pop    %edi
  800e33:	5d                   	pop    %ebp
  800e34:	c3                   	ret    
  800e35:	8d 76 00             	lea    0x0(%esi),%esi
  800e38:	89 f2                	mov    %esi,%edx
  800e3a:	39 d8                	cmp    %ebx,%eax
  800e3c:	76 12                	jbe    800e50 <__umoddi3+0x50>
  800e3e:	89 f0                	mov    %esi,%eax
  800e40:	89 da                	mov    %ebx,%edx
  800e42:	83 c4 1c             	add    $0x1c,%esp
  800e45:	5b                   	pop    %ebx
  800e46:	5e                   	pop    %esi
  800e47:	5f                   	pop    %edi
  800e48:	5d                   	pop    %ebp
  800e49:	c3                   	ret    
  800e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800e50:	0f bd e8             	bsr    %eax,%ebp
  800e53:	83 f5 1f             	xor    $0x1f,%ebp
  800e56:	75 50                	jne    800ea8 <__umoddi3+0xa8>
  800e58:	39 d8                	cmp    %ebx,%eax
  800e5a:	0f 82 e0 00 00 00    	jb     800f40 <__umoddi3+0x140>
  800e60:	89 d9                	mov    %ebx,%ecx
  800e62:	39 f7                	cmp    %esi,%edi
  800e64:	0f 86 d6 00 00 00    	jbe    800f40 <__umoddi3+0x140>
  800e6a:	89 d0                	mov    %edx,%eax
  800e6c:	89 ca                	mov    %ecx,%edx
  800e6e:	83 c4 1c             	add    $0x1c,%esp
  800e71:	5b                   	pop    %ebx
  800e72:	5e                   	pop    %esi
  800e73:	5f                   	pop    %edi
  800e74:	5d                   	pop    %ebp
  800e75:	c3                   	ret    
  800e76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800e7d:	8d 76 00             	lea    0x0(%esi),%esi
  800e80:	89 fd                	mov    %edi,%ebp
  800e82:	85 ff                	test   %edi,%edi
  800e84:	75 0b                	jne    800e91 <__umoddi3+0x91>
  800e86:	b8 01 00 00 00       	mov    $0x1,%eax
  800e8b:	31 d2                	xor    %edx,%edx
  800e8d:	f7 f7                	div    %edi
  800e8f:	89 c5                	mov    %eax,%ebp
  800e91:	89 d8                	mov    %ebx,%eax
  800e93:	31 d2                	xor    %edx,%edx
  800e95:	f7 f5                	div    %ebp
  800e97:	89 f0                	mov    %esi,%eax
  800e99:	f7 f5                	div    %ebp
  800e9b:	89 d0                	mov    %edx,%eax
  800e9d:	31 d2                	xor    %edx,%edx
  800e9f:	eb 8c                	jmp    800e2d <__umoddi3+0x2d>
  800ea1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ea8:	89 e9                	mov    %ebp,%ecx
  800eaa:	ba 20 00 00 00       	mov    $0x20,%edx
  800eaf:	29 ea                	sub    %ebp,%edx
  800eb1:	d3 e0                	shl    %cl,%eax
  800eb3:	89 44 24 08          	mov    %eax,0x8(%esp)
  800eb7:	89 d1                	mov    %edx,%ecx
  800eb9:	89 f8                	mov    %edi,%eax
  800ebb:	d3 e8                	shr    %cl,%eax
  800ebd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800ec1:	89 54 24 04          	mov    %edx,0x4(%esp)
  800ec5:	8b 54 24 04          	mov    0x4(%esp),%edx
  800ec9:	09 c1                	or     %eax,%ecx
  800ecb:	89 d8                	mov    %ebx,%eax
  800ecd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800ed1:	89 e9                	mov    %ebp,%ecx
  800ed3:	d3 e7                	shl    %cl,%edi
  800ed5:	89 d1                	mov    %edx,%ecx
  800ed7:	d3 e8                	shr    %cl,%eax
  800ed9:	89 e9                	mov    %ebp,%ecx
  800edb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800edf:	d3 e3                	shl    %cl,%ebx
  800ee1:	89 c7                	mov    %eax,%edi
  800ee3:	89 d1                	mov    %edx,%ecx
  800ee5:	89 f0                	mov    %esi,%eax
  800ee7:	d3 e8                	shr    %cl,%eax
  800ee9:	89 e9                	mov    %ebp,%ecx
  800eeb:	89 fa                	mov    %edi,%edx
  800eed:	d3 e6                	shl    %cl,%esi
  800eef:	09 d8                	or     %ebx,%eax
  800ef1:	f7 74 24 08          	divl   0x8(%esp)
  800ef5:	89 d1                	mov    %edx,%ecx
  800ef7:	89 f3                	mov    %esi,%ebx
  800ef9:	f7 64 24 0c          	mull   0xc(%esp)
  800efd:	89 c6                	mov    %eax,%esi
  800eff:	89 d7                	mov    %edx,%edi
  800f01:	39 d1                	cmp    %edx,%ecx
  800f03:	72 06                	jb     800f0b <__umoddi3+0x10b>
  800f05:	75 10                	jne    800f17 <__umoddi3+0x117>
  800f07:	39 c3                	cmp    %eax,%ebx
  800f09:	73 0c                	jae    800f17 <__umoddi3+0x117>
  800f0b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  800f0f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  800f13:	89 d7                	mov    %edx,%edi
  800f15:	89 c6                	mov    %eax,%esi
  800f17:	89 ca                	mov    %ecx,%edx
  800f19:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800f1e:	29 f3                	sub    %esi,%ebx
  800f20:	19 fa                	sbb    %edi,%edx
  800f22:	89 d0                	mov    %edx,%eax
  800f24:	d3 e0                	shl    %cl,%eax
  800f26:	89 e9                	mov    %ebp,%ecx
  800f28:	d3 eb                	shr    %cl,%ebx
  800f2a:	d3 ea                	shr    %cl,%edx
  800f2c:	09 d8                	or     %ebx,%eax
  800f2e:	83 c4 1c             	add    $0x1c,%esp
  800f31:	5b                   	pop    %ebx
  800f32:	5e                   	pop    %esi
  800f33:	5f                   	pop    %edi
  800f34:	5d                   	pop    %ebp
  800f35:	c3                   	ret    
  800f36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f3d:	8d 76 00             	lea    0x0(%esi),%esi
  800f40:	29 fe                	sub    %edi,%esi
  800f42:	19 c3                	sbb    %eax,%ebx
  800f44:	89 f2                	mov    %esi,%edx
  800f46:	89 d9                	mov    %ebx,%ecx
  800f48:	e9 1d ff ff ff       	jmp    800e6a <__umoddi3+0x6a>
