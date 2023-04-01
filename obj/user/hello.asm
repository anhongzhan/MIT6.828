
obj/user/hello:     file format elf32-i386


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
  80002c:	e8 4b 00 00 00       	call   80007c <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	53                   	push   %ebx
  80003b:	83 ec 10             	sub    $0x10,%esp
  80003e:	e8 35 00 00 00       	call   800078 <__x86.get_pc_thunk.bx>
  800043:	81 c3 bd 1f 00 00    	add    $0x1fbd,%ebx
	cprintf("hello, world\n");
  800049:	8d 83 50 ef ff ff    	lea    -0x10b0(%ebx),%eax
  80004f:	50                   	push   %eax
  800050:	e8 67 01 00 00       	call   8001bc <cprintf>
	cprintf("i am environment %08x\n", thisenv->env_id);
  800055:	c7 c0 2c 20 80 00    	mov    $0x80202c,%eax
  80005b:	8b 00                	mov    (%eax),%eax
  80005d:	8b 40 48             	mov    0x48(%eax),%eax
  800060:	83 c4 08             	add    $0x8,%esp
  800063:	50                   	push   %eax
  800064:	8d 83 5e ef ff ff    	lea    -0x10a2(%ebx),%eax
  80006a:	50                   	push   %eax
  80006b:	e8 4c 01 00 00       	call   8001bc <cprintf>
}
  800070:	83 c4 10             	add    $0x10,%esp
  800073:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800076:	c9                   	leave  
  800077:	c3                   	ret    

00800078 <__x86.get_pc_thunk.bx>:
  800078:	8b 1c 24             	mov    (%esp),%ebx
  80007b:	c3                   	ret    

0080007c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80007c:	f3 0f 1e fb          	endbr32 
  800080:	55                   	push   %ebp
  800081:	89 e5                	mov    %esp,%ebp
  800083:	57                   	push   %edi
  800084:	56                   	push   %esi
  800085:	53                   	push   %ebx
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	e8 ea ff ff ff       	call   800078 <__x86.get_pc_thunk.bx>
  80008e:	81 c3 72 1f 00 00    	add    $0x1f72,%ebx
  800094:	8b 75 08             	mov    0x8(%ebp),%esi
  800097:	8b 7d 0c             	mov    0xc(%ebp),%edi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80009a:	e8 c6 0b 00 00       	call   800c65 <sys_getenvid>
  80009f:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000a4:	8d 04 40             	lea    (%eax,%eax,2),%eax
  8000a7:	c1 e0 05             	shl    $0x5,%eax
  8000aa:	81 c0 00 00 c0 ee    	add    $0xeec00000,%eax
  8000b0:	c7 c2 2c 20 80 00    	mov    $0x80202c,%edx
  8000b6:	89 02                	mov    %eax,(%edx)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b8:	85 f6                	test   %esi,%esi
  8000ba:	7e 08                	jle    8000c4 <libmain+0x48>
		binaryname = argv[0];
  8000bc:	8b 07                	mov    (%edi),%eax
  8000be:	89 83 0c 00 00 00    	mov    %eax,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  8000c4:	83 ec 08             	sub    $0x8,%esp
  8000c7:	57                   	push   %edi
  8000c8:	56                   	push   %esi
  8000c9:	e8 65 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000ce:	e8 0b 00 00 00       	call   8000de <exit>
}
  8000d3:	83 c4 10             	add    $0x10,%esp
  8000d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000d9:	5b                   	pop    %ebx
  8000da:	5e                   	pop    %esi
  8000db:	5f                   	pop    %edi
  8000dc:	5d                   	pop    %ebp
  8000dd:	c3                   	ret    

008000de <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000de:	f3 0f 1e fb          	endbr32 
  8000e2:	55                   	push   %ebp
  8000e3:	89 e5                	mov    %esp,%ebp
  8000e5:	53                   	push   %ebx
  8000e6:	83 ec 10             	sub    $0x10,%esp
  8000e9:	e8 8a ff ff ff       	call   800078 <__x86.get_pc_thunk.bx>
  8000ee:	81 c3 12 1f 00 00    	add    $0x1f12,%ebx
	sys_env_destroy(0);
  8000f4:	6a 00                	push   $0x0
  8000f6:	e8 11 0b 00 00       	call   800c0c <sys_env_destroy>
}
  8000fb:	83 c4 10             	add    $0x10,%esp
  8000fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800101:	c9                   	leave  
  800102:	c3                   	ret    

00800103 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800103:	f3 0f 1e fb          	endbr32 
  800107:	55                   	push   %ebp
  800108:	89 e5                	mov    %esp,%ebp
  80010a:	56                   	push   %esi
  80010b:	53                   	push   %ebx
  80010c:	e8 67 ff ff ff       	call   800078 <__x86.get_pc_thunk.bx>
  800111:	81 c3 ef 1e 00 00    	add    $0x1eef,%ebx
  800117:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
  80011a:	8b 16                	mov    (%esi),%edx
  80011c:	8d 42 01             	lea    0x1(%edx),%eax
  80011f:	89 06                	mov    %eax,(%esi)
  800121:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800124:	88 4c 16 08          	mov    %cl,0x8(%esi,%edx,1)
	if (b->idx == 256-1) {
  800128:	3d ff 00 00 00       	cmp    $0xff,%eax
  80012d:	74 0b                	je     80013a <putch+0x37>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80012f:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  800133:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800136:	5b                   	pop    %ebx
  800137:	5e                   	pop    %esi
  800138:	5d                   	pop    %ebp
  800139:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80013a:	83 ec 08             	sub    $0x8,%esp
  80013d:	68 ff 00 00 00       	push   $0xff
  800142:	8d 46 08             	lea    0x8(%esi),%eax
  800145:	50                   	push   %eax
  800146:	e8 7c 0a 00 00       	call   800bc7 <sys_cputs>
		b->idx = 0;
  80014b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  800151:	83 c4 10             	add    $0x10,%esp
  800154:	eb d9                	jmp    80012f <putch+0x2c>

00800156 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800156:	f3 0f 1e fb          	endbr32 
  80015a:	55                   	push   %ebp
  80015b:	89 e5                	mov    %esp,%ebp
  80015d:	53                   	push   %ebx
  80015e:	81 ec 14 01 00 00    	sub    $0x114,%esp
  800164:	e8 0f ff ff ff       	call   800078 <__x86.get_pc_thunk.bx>
  800169:	81 c3 97 1e 00 00    	add    $0x1e97,%ebx
	struct printbuf b;

	b.idx = 0;
  80016f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800176:	00 00 00 
	b.cnt = 0;
  800179:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800180:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800183:	ff 75 0c             	pushl  0xc(%ebp)
  800186:	ff 75 08             	pushl  0x8(%ebp)
  800189:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80018f:	50                   	push   %eax
  800190:	8d 83 03 e1 ff ff    	lea    -0x1efd(%ebx),%eax
  800196:	50                   	push   %eax
  800197:	e8 38 01 00 00       	call   8002d4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80019c:	83 c4 08             	add    $0x8,%esp
  80019f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001a5:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001ab:	50                   	push   %eax
  8001ac:	e8 16 0a 00 00       	call   800bc7 <sys_cputs>

	return b.cnt;
}
  8001b1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001ba:	c9                   	leave  
  8001bb:	c3                   	ret    

008001bc <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001bc:	f3 0f 1e fb          	endbr32 
  8001c0:	55                   	push   %ebp
  8001c1:	89 e5                	mov    %esp,%ebp
  8001c3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001c6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001c9:	50                   	push   %eax
  8001ca:	ff 75 08             	pushl  0x8(%ebp)
  8001cd:	e8 84 ff ff ff       	call   800156 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001d2:	c9                   	leave  
  8001d3:	c3                   	ret    

008001d4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001d4:	55                   	push   %ebp
  8001d5:	89 e5                	mov    %esp,%ebp
  8001d7:	57                   	push   %edi
  8001d8:	56                   	push   %esi
  8001d9:	53                   	push   %ebx
  8001da:	83 ec 2c             	sub    $0x2c,%esp
  8001dd:	e8 2c 06 00 00       	call   80080e <__x86.get_pc_thunk.cx>
  8001e2:	81 c1 1e 1e 00 00    	add    $0x1e1e,%ecx
  8001e8:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001eb:	89 c7                	mov    %eax,%edi
  8001ed:	89 d6                	mov    %edx,%esi
  8001ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001f5:	89 d1                	mov    %edx,%ecx
  8001f7:	89 c2                	mov    %eax,%edx
  8001f9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8001fc:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8001ff:	8b 45 10             	mov    0x10(%ebp),%eax
  800202:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800205:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800208:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80020f:	39 c2                	cmp    %eax,%edx
  800211:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800214:	72 41                	jb     800257 <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800216:	83 ec 0c             	sub    $0xc,%esp
  800219:	ff 75 18             	pushl  0x18(%ebp)
  80021c:	83 eb 01             	sub    $0x1,%ebx
  80021f:	53                   	push   %ebx
  800220:	50                   	push   %eax
  800221:	83 ec 08             	sub    $0x8,%esp
  800224:	ff 75 e4             	pushl  -0x1c(%ebp)
  800227:	ff 75 e0             	pushl  -0x20(%ebp)
  80022a:	ff 75 d4             	pushl  -0x2c(%ebp)
  80022d:	ff 75 d0             	pushl  -0x30(%ebp)
  800230:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800233:	e8 b8 0a 00 00       	call   800cf0 <__udivdi3>
  800238:	83 c4 18             	add    $0x18,%esp
  80023b:	52                   	push   %edx
  80023c:	50                   	push   %eax
  80023d:	89 f2                	mov    %esi,%edx
  80023f:	89 f8                	mov    %edi,%eax
  800241:	e8 8e ff ff ff       	call   8001d4 <printnum>
  800246:	83 c4 20             	add    $0x20,%esp
  800249:	eb 13                	jmp    80025e <printnum+0x8a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80024b:	83 ec 08             	sub    $0x8,%esp
  80024e:	56                   	push   %esi
  80024f:	ff 75 18             	pushl  0x18(%ebp)
  800252:	ff d7                	call   *%edi
  800254:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800257:	83 eb 01             	sub    $0x1,%ebx
  80025a:	85 db                	test   %ebx,%ebx
  80025c:	7f ed                	jg     80024b <printnum+0x77>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80025e:	83 ec 08             	sub    $0x8,%esp
  800261:	56                   	push   %esi
  800262:	83 ec 04             	sub    $0x4,%esp
  800265:	ff 75 e4             	pushl  -0x1c(%ebp)
  800268:	ff 75 e0             	pushl  -0x20(%ebp)
  80026b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80026e:	ff 75 d0             	pushl  -0x30(%ebp)
  800271:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800274:	e8 87 0b 00 00       	call   800e00 <__umoddi3>
  800279:	83 c4 14             	add    $0x14,%esp
  80027c:	0f be 84 03 7f ef ff 	movsbl -0x1081(%ebx,%eax,1),%eax
  800283:	ff 
  800284:	50                   	push   %eax
  800285:	ff d7                	call   *%edi
}
  800287:	83 c4 10             	add    $0x10,%esp
  80028a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80028d:	5b                   	pop    %ebx
  80028e:	5e                   	pop    %esi
  80028f:	5f                   	pop    %edi
  800290:	5d                   	pop    %ebp
  800291:	c3                   	ret    

00800292 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800292:	f3 0f 1e fb          	endbr32 
  800296:	55                   	push   %ebp
  800297:	89 e5                	mov    %esp,%ebp
  800299:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80029c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002a0:	8b 10                	mov    (%eax),%edx
  8002a2:	3b 50 04             	cmp    0x4(%eax),%edx
  8002a5:	73 0a                	jae    8002b1 <sprintputch+0x1f>
		*b->buf++ = ch;
  8002a7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002aa:	89 08                	mov    %ecx,(%eax)
  8002ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8002af:	88 02                	mov    %al,(%edx)
}
  8002b1:	5d                   	pop    %ebp
  8002b2:	c3                   	ret    

008002b3 <printfmt>:
{
  8002b3:	f3 0f 1e fb          	endbr32 
  8002b7:	55                   	push   %ebp
  8002b8:	89 e5                	mov    %esp,%ebp
  8002ba:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002bd:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002c0:	50                   	push   %eax
  8002c1:	ff 75 10             	pushl  0x10(%ebp)
  8002c4:	ff 75 0c             	pushl  0xc(%ebp)
  8002c7:	ff 75 08             	pushl  0x8(%ebp)
  8002ca:	e8 05 00 00 00       	call   8002d4 <vprintfmt>
}
  8002cf:	83 c4 10             	add    $0x10,%esp
  8002d2:	c9                   	leave  
  8002d3:	c3                   	ret    

008002d4 <vprintfmt>:
{
  8002d4:	f3 0f 1e fb          	endbr32 
  8002d8:	55                   	push   %ebp
  8002d9:	89 e5                	mov    %esp,%ebp
  8002db:	57                   	push   %edi
  8002dc:	56                   	push   %esi
  8002dd:	53                   	push   %ebx
  8002de:	83 ec 3c             	sub    $0x3c,%esp
  8002e1:	e8 24 05 00 00       	call   80080a <__x86.get_pc_thunk.ax>
  8002e6:	05 1a 1d 00 00       	add    $0x1d1a,%eax
  8002eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002ee:	8b 75 08             	mov    0x8(%ebp),%esi
  8002f1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8002f4:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8002f7:	8d 80 10 00 00 00    	lea    0x10(%eax),%eax
  8002fd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800300:	e9 cd 03 00 00       	jmp    8006d2 <.L25+0x48>
		padc = ' ';
  800305:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		altflag = 0;
  800309:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800310:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800317:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  80031e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800323:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800326:	89 75 08             	mov    %esi,0x8(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800329:	8d 43 01             	lea    0x1(%ebx),%eax
  80032c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80032f:	0f b6 13             	movzbl (%ebx),%edx
  800332:	8d 42 dd             	lea    -0x23(%edx),%eax
  800335:	3c 55                	cmp    $0x55,%al
  800337:	0f 87 21 04 00 00    	ja     80075e <.L20>
  80033d:	0f b6 c0             	movzbl %al,%eax
  800340:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800343:	89 ce                	mov    %ecx,%esi
  800345:	03 b4 81 0c f0 ff ff 	add    -0xff4(%ecx,%eax,4),%esi
  80034c:	3e ff e6             	notrack jmp *%esi

0080034f <.L68>:
  80034f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			padc = '-';
  800352:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800356:	eb d1                	jmp    800329 <vprintfmt+0x55>

00800358 <.L32>:
		switch (ch = *(unsigned char *) fmt++) {
  800358:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80035b:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80035f:	eb c8                	jmp    800329 <vprintfmt+0x55>

00800361 <.L31>:
  800361:	0f b6 d2             	movzbl %dl,%edx
  800364:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			for (precision = 0; ; ++fmt) {
  800367:	b8 00 00 00 00       	mov    $0x0,%eax
  80036c:	8b 75 08             	mov    0x8(%ebp),%esi
				precision = precision * 10 + ch - '0';
  80036f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800372:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800376:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  800379:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80037c:	83 f9 09             	cmp    $0x9,%ecx
  80037f:	77 58                	ja     8003d9 <.L36+0xf>
			for (precision = 0; ; ++fmt) {
  800381:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  800384:	eb e9                	jmp    80036f <.L31+0xe>

00800386 <.L34>:
			precision = va_arg(ap, int);
  800386:	8b 45 14             	mov    0x14(%ebp),%eax
  800389:	8b 00                	mov    (%eax),%eax
  80038b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80038e:	8b 45 14             	mov    0x14(%ebp),%eax
  800391:	8d 40 04             	lea    0x4(%eax),%eax
  800394:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800397:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			if (width < 0)
  80039a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80039e:	79 89                	jns    800329 <vprintfmt+0x55>
				width = precision, precision = -1;
  8003a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8003a6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003ad:	e9 77 ff ff ff       	jmp    800329 <vprintfmt+0x55>

008003b2 <.L33>:
  8003b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003b5:	85 c0                	test   %eax,%eax
  8003b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8003bc:	0f 49 d0             	cmovns %eax,%edx
  8003bf:	89 55 d4             	mov    %edx,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  8003c5:	e9 5f ff ff ff       	jmp    800329 <vprintfmt+0x55>

008003ca <.L36>:
		switch (ch = *(unsigned char *) fmt++) {
  8003ca:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			altflag = 1;
  8003cd:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003d4:	e9 50 ff ff ff       	jmp    800329 <vprintfmt+0x55>
  8003d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003dc:	89 75 08             	mov    %esi,0x8(%ebp)
  8003df:	eb b9                	jmp    80039a <.L34+0x14>

008003e1 <.L27>:
			lflag++;
  8003e1:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003e5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  8003e8:	e9 3c ff ff ff       	jmp    800329 <vprintfmt+0x55>

008003ed <.L30>:
  8003ed:	8b 75 08             	mov    0x8(%ebp),%esi
			putch(va_arg(ap, int), putdat);
  8003f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f3:	8d 58 04             	lea    0x4(%eax),%ebx
  8003f6:	83 ec 08             	sub    $0x8,%esp
  8003f9:	57                   	push   %edi
  8003fa:	ff 30                	pushl  (%eax)
  8003fc:	ff d6                	call   *%esi
			break;
  8003fe:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800401:	89 5d 14             	mov    %ebx,0x14(%ebp)
			break;
  800404:	e9 c6 02 00 00       	jmp    8006cf <.L25+0x45>

00800409 <.L28>:
  800409:	8b 75 08             	mov    0x8(%ebp),%esi
			err = va_arg(ap, int);
  80040c:	8b 45 14             	mov    0x14(%ebp),%eax
  80040f:	8d 58 04             	lea    0x4(%eax),%ebx
  800412:	8b 00                	mov    (%eax),%eax
  800414:	99                   	cltd   
  800415:	31 d0                	xor    %edx,%eax
  800417:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800419:	83 f8 06             	cmp    $0x6,%eax
  80041c:	7f 27                	jg     800445 <.L28+0x3c>
  80041e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800421:	8b 14 82             	mov    (%edx,%eax,4),%edx
  800424:	85 d2                	test   %edx,%edx
  800426:	74 1d                	je     800445 <.L28+0x3c>
				printfmt(putch, putdat, "%s", p);
  800428:	52                   	push   %edx
  800429:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80042c:	8d 80 a0 ef ff ff    	lea    -0x1060(%eax),%eax
  800432:	50                   	push   %eax
  800433:	57                   	push   %edi
  800434:	56                   	push   %esi
  800435:	e8 79 fe ff ff       	call   8002b3 <printfmt>
  80043a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80043d:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800440:	e9 8a 02 00 00       	jmp    8006cf <.L25+0x45>
				printfmt(putch, putdat, "error %d", err);
  800445:	50                   	push   %eax
  800446:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800449:	8d 80 97 ef ff ff    	lea    -0x1069(%eax),%eax
  80044f:	50                   	push   %eax
  800450:	57                   	push   %edi
  800451:	56                   	push   %esi
  800452:	e8 5c fe ff ff       	call   8002b3 <printfmt>
  800457:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80045a:	89 5d 14             	mov    %ebx,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80045d:	e9 6d 02 00 00       	jmp    8006cf <.L25+0x45>

00800462 <.L24>:
  800462:	8b 75 08             	mov    0x8(%ebp),%esi
			if ((p = va_arg(ap, char *)) == NULL)
  800465:	8b 45 14             	mov    0x14(%ebp),%eax
  800468:	83 c0 04             	add    $0x4,%eax
  80046b:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80046e:	8b 45 14             	mov    0x14(%ebp),%eax
  800471:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800473:	85 d2                	test   %edx,%edx
  800475:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800478:	8d 80 90 ef ff ff    	lea    -0x1070(%eax),%eax
  80047e:	0f 45 c2             	cmovne %edx,%eax
  800481:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800484:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800488:	7e 06                	jle    800490 <.L24+0x2e>
  80048a:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80048e:	75 0d                	jne    80049d <.L24+0x3b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800490:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800493:	89 c3                	mov    %eax,%ebx
  800495:	03 45 d4             	add    -0x2c(%ebp),%eax
  800498:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80049b:	eb 58                	jmp    8004f5 <.L24+0x93>
  80049d:	83 ec 08             	sub    $0x8,%esp
  8004a0:	ff 75 d8             	pushl  -0x28(%ebp)
  8004a3:	ff 75 c8             	pushl  -0x38(%ebp)
  8004a6:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004a9:	e8 80 03 00 00       	call   80082e <strnlen>
  8004ae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004b1:	29 c2                	sub    %eax,%edx
  8004b3:	89 55 bc             	mov    %edx,-0x44(%ebp)
  8004b6:	83 c4 10             	add    $0x10,%esp
  8004b9:	89 d3                	mov    %edx,%ebx
					putch(padc, putdat);
  8004bb:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c2:	85 db                	test   %ebx,%ebx
  8004c4:	7e 11                	jle    8004d7 <.L24+0x75>
					putch(padc, putdat);
  8004c6:	83 ec 08             	sub    $0x8,%esp
  8004c9:	57                   	push   %edi
  8004ca:	ff 75 d4             	pushl  -0x2c(%ebp)
  8004cd:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004cf:	83 eb 01             	sub    $0x1,%ebx
  8004d2:	83 c4 10             	add    $0x10,%esp
  8004d5:	eb eb                	jmp    8004c2 <.L24+0x60>
  8004d7:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8004da:	85 d2                	test   %edx,%edx
  8004dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e1:	0f 49 c2             	cmovns %edx,%eax
  8004e4:	29 c2                	sub    %eax,%edx
  8004e6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8004e9:	eb a5                	jmp    800490 <.L24+0x2e>
					putch(ch, putdat);
  8004eb:	83 ec 08             	sub    $0x8,%esp
  8004ee:	57                   	push   %edi
  8004ef:	52                   	push   %edx
  8004f0:	ff d6                	call   *%esi
  8004f2:	83 c4 10             	add    $0x10,%esp
  8004f5:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8004f8:	29 d9                	sub    %ebx,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004fa:	83 c3 01             	add    $0x1,%ebx
  8004fd:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  800501:	0f be d0             	movsbl %al,%edx
  800504:	85 d2                	test   %edx,%edx
  800506:	74 4b                	je     800553 <.L24+0xf1>
  800508:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80050c:	78 06                	js     800514 <.L24+0xb2>
  80050e:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800512:	78 1e                	js     800532 <.L24+0xd0>
				if (altflag && (ch < ' ' || ch > '~'))
  800514:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800518:	74 d1                	je     8004eb <.L24+0x89>
  80051a:	0f be c0             	movsbl %al,%eax
  80051d:	83 e8 20             	sub    $0x20,%eax
  800520:	83 f8 5e             	cmp    $0x5e,%eax
  800523:	76 c6                	jbe    8004eb <.L24+0x89>
					putch('?', putdat);
  800525:	83 ec 08             	sub    $0x8,%esp
  800528:	57                   	push   %edi
  800529:	6a 3f                	push   $0x3f
  80052b:	ff d6                	call   *%esi
  80052d:	83 c4 10             	add    $0x10,%esp
  800530:	eb c3                	jmp    8004f5 <.L24+0x93>
  800532:	89 cb                	mov    %ecx,%ebx
  800534:	eb 0e                	jmp    800544 <.L24+0xe2>
				putch(' ', putdat);
  800536:	83 ec 08             	sub    $0x8,%esp
  800539:	57                   	push   %edi
  80053a:	6a 20                	push   $0x20
  80053c:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80053e:	83 eb 01             	sub    $0x1,%ebx
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	85 db                	test   %ebx,%ebx
  800546:	7f ee                	jg     800536 <.L24+0xd4>
			if ((p = va_arg(ap, char *)) == NULL)
  800548:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80054b:	89 45 14             	mov    %eax,0x14(%ebp)
  80054e:	e9 7c 01 00 00       	jmp    8006cf <.L25+0x45>
  800553:	89 cb                	mov    %ecx,%ebx
  800555:	eb ed                	jmp    800544 <.L24+0xe2>

00800557 <.L29>:
  800557:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80055a:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  80055d:	83 f9 01             	cmp    $0x1,%ecx
  800560:	7f 1b                	jg     80057d <.L29+0x26>
	else if (lflag)
  800562:	85 c9                	test   %ecx,%ecx
  800564:	74 63                	je     8005c9 <.L29+0x72>
		return va_arg(*ap, long);
  800566:	8b 45 14             	mov    0x14(%ebp),%eax
  800569:	8b 00                	mov    (%eax),%eax
  80056b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80056e:	99                   	cltd   
  80056f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800572:	8b 45 14             	mov    0x14(%ebp),%eax
  800575:	8d 40 04             	lea    0x4(%eax),%eax
  800578:	89 45 14             	mov    %eax,0x14(%ebp)
  80057b:	eb 17                	jmp    800594 <.L29+0x3d>
		return va_arg(*ap, long long);
  80057d:	8b 45 14             	mov    0x14(%ebp),%eax
  800580:	8b 50 04             	mov    0x4(%eax),%edx
  800583:	8b 00                	mov    (%eax),%eax
  800585:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800588:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80058b:	8b 45 14             	mov    0x14(%ebp),%eax
  80058e:	8d 40 08             	lea    0x8(%eax),%eax
  800591:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800594:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800597:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80059a:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80059f:	85 c9                	test   %ecx,%ecx
  8005a1:	0f 89 0e 01 00 00    	jns    8006b5 <.L25+0x2b>
				putch('-', putdat);
  8005a7:	83 ec 08             	sub    $0x8,%esp
  8005aa:	57                   	push   %edi
  8005ab:	6a 2d                	push   $0x2d
  8005ad:	ff d6                	call   *%esi
				num = -(long long) num;
  8005af:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005b2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005b5:	f7 da                	neg    %edx
  8005b7:	83 d1 00             	adc    $0x0,%ecx
  8005ba:	f7 d9                	neg    %ecx
  8005bc:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005bf:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005c4:	e9 ec 00 00 00       	jmp    8006b5 <.L25+0x2b>
		return va_arg(*ap, int);
  8005c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cc:	8b 00                	mov    (%eax),%eax
  8005ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d1:	99                   	cltd   
  8005d2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d8:	8d 40 04             	lea    0x4(%eax),%eax
  8005db:	89 45 14             	mov    %eax,0x14(%ebp)
  8005de:	eb b4                	jmp    800594 <.L29+0x3d>

008005e0 <.L23>:
  8005e0:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8005e3:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  8005e6:	83 f9 01             	cmp    $0x1,%ecx
  8005e9:	7f 1e                	jg     800609 <.L23+0x29>
	else if (lflag)
  8005eb:	85 c9                	test   %ecx,%ecx
  8005ed:	74 32                	je     800621 <.L23+0x41>
		return va_arg(*ap, unsigned long);
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	8b 10                	mov    (%eax),%edx
  8005f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005f9:	8d 40 04             	lea    0x4(%eax),%eax
  8005fc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ff:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800604:	e9 ac 00 00 00       	jmp    8006b5 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  800609:	8b 45 14             	mov    0x14(%ebp),%eax
  80060c:	8b 10                	mov    (%eax),%edx
  80060e:	8b 48 04             	mov    0x4(%eax),%ecx
  800611:	8d 40 08             	lea    0x8(%eax),%eax
  800614:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800617:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80061c:	e9 94 00 00 00       	jmp    8006b5 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  800621:	8b 45 14             	mov    0x14(%ebp),%eax
  800624:	8b 10                	mov    (%eax),%edx
  800626:	b9 00 00 00 00       	mov    $0x0,%ecx
  80062b:	8d 40 04             	lea    0x4(%eax),%eax
  80062e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800631:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800636:	eb 7d                	jmp    8006b5 <.L25+0x2b>

00800638 <.L26>:
  800638:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80063b:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  80063e:	83 f9 01             	cmp    $0x1,%ecx
  800641:	7f 1b                	jg     80065e <.L26+0x26>
	else if (lflag)
  800643:	85 c9                	test   %ecx,%ecx
  800645:	74 2c                	je     800673 <.L26+0x3b>
		return va_arg(*ap, unsigned long);
  800647:	8b 45 14             	mov    0x14(%ebp),%eax
  80064a:	8b 10                	mov    (%eax),%edx
  80064c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800651:	8d 40 04             	lea    0x4(%eax),%eax
  800654:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800657:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  80065c:	eb 57                	jmp    8006b5 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  80065e:	8b 45 14             	mov    0x14(%ebp),%eax
  800661:	8b 10                	mov    (%eax),%edx
  800663:	8b 48 04             	mov    0x4(%eax),%ecx
  800666:	8d 40 08             	lea    0x8(%eax),%eax
  800669:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80066c:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800671:	eb 42                	jmp    8006b5 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  800673:	8b 45 14             	mov    0x14(%ebp),%eax
  800676:	8b 10                	mov    (%eax),%edx
  800678:	b9 00 00 00 00       	mov    $0x0,%ecx
  80067d:	8d 40 04             	lea    0x4(%eax),%eax
  800680:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800683:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800688:	eb 2b                	jmp    8006b5 <.L25+0x2b>

0080068a <.L25>:
  80068a:	8b 75 08             	mov    0x8(%ebp),%esi
			putch('0', putdat);
  80068d:	83 ec 08             	sub    $0x8,%esp
  800690:	57                   	push   %edi
  800691:	6a 30                	push   $0x30
  800693:	ff d6                	call   *%esi
			putch('x', putdat);
  800695:	83 c4 08             	add    $0x8,%esp
  800698:	57                   	push   %edi
  800699:	6a 78                	push   $0x78
  80069b:	ff d6                	call   *%esi
			num = (unsigned long long)
  80069d:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a0:	8b 10                	mov    (%eax),%edx
  8006a2:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006a7:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006aa:	8d 40 04             	lea    0x4(%eax),%eax
  8006ad:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b0:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006b5:	83 ec 0c             	sub    $0xc,%esp
  8006b8:	0f be 5d cf          	movsbl -0x31(%ebp),%ebx
  8006bc:	53                   	push   %ebx
  8006bd:	ff 75 d4             	pushl  -0x2c(%ebp)
  8006c0:	50                   	push   %eax
  8006c1:	51                   	push   %ecx
  8006c2:	52                   	push   %edx
  8006c3:	89 fa                	mov    %edi,%edx
  8006c5:	89 f0                	mov    %esi,%eax
  8006c7:	e8 08 fb ff ff       	call   8001d4 <printnum>
			break;
  8006cc:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006cf:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006d2:	83 c3 01             	add    $0x1,%ebx
  8006d5:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  8006d9:	83 f8 25             	cmp    $0x25,%eax
  8006dc:	0f 84 23 fc ff ff    	je     800305 <vprintfmt+0x31>
			if (ch == '\0')
  8006e2:	85 c0                	test   %eax,%eax
  8006e4:	0f 84 97 00 00 00    	je     800781 <.L20+0x23>
			putch(ch, putdat);
  8006ea:	83 ec 08             	sub    $0x8,%esp
  8006ed:	57                   	push   %edi
  8006ee:	50                   	push   %eax
  8006ef:	ff d6                	call   *%esi
  8006f1:	83 c4 10             	add    $0x10,%esp
  8006f4:	eb dc                	jmp    8006d2 <.L25+0x48>

008006f6 <.L21>:
  8006f6:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006f9:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  8006fc:	83 f9 01             	cmp    $0x1,%ecx
  8006ff:	7f 1b                	jg     80071c <.L21+0x26>
	else if (lflag)
  800701:	85 c9                	test   %ecx,%ecx
  800703:	74 2c                	je     800731 <.L21+0x3b>
		return va_arg(*ap, unsigned long);
  800705:	8b 45 14             	mov    0x14(%ebp),%eax
  800708:	8b 10                	mov    (%eax),%edx
  80070a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80070f:	8d 40 04             	lea    0x4(%eax),%eax
  800712:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800715:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80071a:	eb 99                	jmp    8006b5 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  80071c:	8b 45 14             	mov    0x14(%ebp),%eax
  80071f:	8b 10                	mov    (%eax),%edx
  800721:	8b 48 04             	mov    0x4(%eax),%ecx
  800724:	8d 40 08             	lea    0x8(%eax),%eax
  800727:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80072a:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  80072f:	eb 84                	jmp    8006b5 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  800731:	8b 45 14             	mov    0x14(%ebp),%eax
  800734:	8b 10                	mov    (%eax),%edx
  800736:	b9 00 00 00 00       	mov    $0x0,%ecx
  80073b:	8d 40 04             	lea    0x4(%eax),%eax
  80073e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800741:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800746:	e9 6a ff ff ff       	jmp    8006b5 <.L25+0x2b>

0080074b <.L35>:
  80074b:	8b 75 08             	mov    0x8(%ebp),%esi
			putch(ch, putdat);
  80074e:	83 ec 08             	sub    $0x8,%esp
  800751:	57                   	push   %edi
  800752:	6a 25                	push   $0x25
  800754:	ff d6                	call   *%esi
			break;
  800756:	83 c4 10             	add    $0x10,%esp
  800759:	e9 71 ff ff ff       	jmp    8006cf <.L25+0x45>

0080075e <.L20>:
  80075e:	8b 75 08             	mov    0x8(%ebp),%esi
			putch('%', putdat);
  800761:	83 ec 08             	sub    $0x8,%esp
  800764:	57                   	push   %edi
  800765:	6a 25                	push   $0x25
  800767:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800769:	83 c4 10             	add    $0x10,%esp
  80076c:	89 d8                	mov    %ebx,%eax
  80076e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800772:	74 05                	je     800779 <.L20+0x1b>
  800774:	83 e8 01             	sub    $0x1,%eax
  800777:	eb f5                	jmp    80076e <.L20+0x10>
  800779:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80077c:	e9 4e ff ff ff       	jmp    8006cf <.L25+0x45>
}
  800781:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800784:	5b                   	pop    %ebx
  800785:	5e                   	pop    %esi
  800786:	5f                   	pop    %edi
  800787:	5d                   	pop    %ebp
  800788:	c3                   	ret    

00800789 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800789:	f3 0f 1e fb          	endbr32 
  80078d:	55                   	push   %ebp
  80078e:	89 e5                	mov    %esp,%ebp
  800790:	53                   	push   %ebx
  800791:	83 ec 14             	sub    $0x14,%esp
  800794:	e8 df f8 ff ff       	call   800078 <__x86.get_pc_thunk.bx>
  800799:	81 c3 67 18 00 00    	add    $0x1867,%ebx
  80079f:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a2:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007a8:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007ac:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007b6:	85 c0                	test   %eax,%eax
  8007b8:	74 2b                	je     8007e5 <vsnprintf+0x5c>
  8007ba:	85 d2                	test   %edx,%edx
  8007bc:	7e 27                	jle    8007e5 <vsnprintf+0x5c>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007be:	ff 75 14             	pushl  0x14(%ebp)
  8007c1:	ff 75 10             	pushl  0x10(%ebp)
  8007c4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007c7:	50                   	push   %eax
  8007c8:	8d 83 92 e2 ff ff    	lea    -0x1d6e(%ebx),%eax
  8007ce:	50                   	push   %eax
  8007cf:	e8 00 fb ff ff       	call   8002d4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007d7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007dd:	83 c4 10             	add    $0x10,%esp
}
  8007e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007e3:	c9                   	leave  
  8007e4:	c3                   	ret    
		return -E_INVAL;
  8007e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007ea:	eb f4                	jmp    8007e0 <vsnprintf+0x57>

008007ec <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007ec:	f3 0f 1e fb          	endbr32 
  8007f0:	55                   	push   %ebp
  8007f1:	89 e5                	mov    %esp,%ebp
  8007f3:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007f6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007f9:	50                   	push   %eax
  8007fa:	ff 75 10             	pushl  0x10(%ebp)
  8007fd:	ff 75 0c             	pushl  0xc(%ebp)
  800800:	ff 75 08             	pushl  0x8(%ebp)
  800803:	e8 81 ff ff ff       	call   800789 <vsnprintf>
	va_end(ap);

	return rc;
}
  800808:	c9                   	leave  
  800809:	c3                   	ret    

0080080a <__x86.get_pc_thunk.ax>:
  80080a:	8b 04 24             	mov    (%esp),%eax
  80080d:	c3                   	ret    

0080080e <__x86.get_pc_thunk.cx>:
  80080e:	8b 0c 24             	mov    (%esp),%ecx
  800811:	c3                   	ret    

00800812 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800812:	f3 0f 1e fb          	endbr32 
  800816:	55                   	push   %ebp
  800817:	89 e5                	mov    %esp,%ebp
  800819:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80081c:	b8 00 00 00 00       	mov    $0x0,%eax
  800821:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800825:	74 05                	je     80082c <strlen+0x1a>
		n++;
  800827:	83 c0 01             	add    $0x1,%eax
  80082a:	eb f5                	jmp    800821 <strlen+0xf>
	return n;
}
  80082c:	5d                   	pop    %ebp
  80082d:	c3                   	ret    

0080082e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80082e:	f3 0f 1e fb          	endbr32 
  800832:	55                   	push   %ebp
  800833:	89 e5                	mov    %esp,%ebp
  800835:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800838:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80083b:	b8 00 00 00 00       	mov    $0x0,%eax
  800840:	39 d0                	cmp    %edx,%eax
  800842:	74 0d                	je     800851 <strnlen+0x23>
  800844:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800848:	74 05                	je     80084f <strnlen+0x21>
		n++;
  80084a:	83 c0 01             	add    $0x1,%eax
  80084d:	eb f1                	jmp    800840 <strnlen+0x12>
  80084f:	89 c2                	mov    %eax,%edx
	return n;
}
  800851:	89 d0                	mov    %edx,%eax
  800853:	5d                   	pop    %ebp
  800854:	c3                   	ret    

00800855 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800855:	f3 0f 1e fb          	endbr32 
  800859:	55                   	push   %ebp
  80085a:	89 e5                	mov    %esp,%ebp
  80085c:	53                   	push   %ebx
  80085d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800860:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800863:	b8 00 00 00 00       	mov    $0x0,%eax
  800868:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80086c:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  80086f:	83 c0 01             	add    $0x1,%eax
  800872:	84 d2                	test   %dl,%dl
  800874:	75 f2                	jne    800868 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800876:	89 c8                	mov    %ecx,%eax
  800878:	5b                   	pop    %ebx
  800879:	5d                   	pop    %ebp
  80087a:	c3                   	ret    

0080087b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80087b:	f3 0f 1e fb          	endbr32 
  80087f:	55                   	push   %ebp
  800880:	89 e5                	mov    %esp,%ebp
  800882:	53                   	push   %ebx
  800883:	83 ec 10             	sub    $0x10,%esp
  800886:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800889:	53                   	push   %ebx
  80088a:	e8 83 ff ff ff       	call   800812 <strlen>
  80088f:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800892:	ff 75 0c             	pushl  0xc(%ebp)
  800895:	01 d8                	add    %ebx,%eax
  800897:	50                   	push   %eax
  800898:	e8 b8 ff ff ff       	call   800855 <strcpy>
	return dst;
}
  80089d:	89 d8                	mov    %ebx,%eax
  80089f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008a2:	c9                   	leave  
  8008a3:	c3                   	ret    

008008a4 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008a4:	f3 0f 1e fb          	endbr32 
  8008a8:	55                   	push   %ebp
  8008a9:	89 e5                	mov    %esp,%ebp
  8008ab:	56                   	push   %esi
  8008ac:	53                   	push   %ebx
  8008ad:	8b 75 08             	mov    0x8(%ebp),%esi
  8008b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b3:	89 f3                	mov    %esi,%ebx
  8008b5:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008b8:	89 f0                	mov    %esi,%eax
  8008ba:	39 d8                	cmp    %ebx,%eax
  8008bc:	74 11                	je     8008cf <strncpy+0x2b>
		*dst++ = *src;
  8008be:	83 c0 01             	add    $0x1,%eax
  8008c1:	0f b6 0a             	movzbl (%edx),%ecx
  8008c4:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008c7:	80 f9 01             	cmp    $0x1,%cl
  8008ca:	83 da ff             	sbb    $0xffffffff,%edx
  8008cd:	eb eb                	jmp    8008ba <strncpy+0x16>
	}
	return ret;
}
  8008cf:	89 f0                	mov    %esi,%eax
  8008d1:	5b                   	pop    %ebx
  8008d2:	5e                   	pop    %esi
  8008d3:	5d                   	pop    %ebp
  8008d4:	c3                   	ret    

008008d5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008d5:	f3 0f 1e fb          	endbr32 
  8008d9:	55                   	push   %ebp
  8008da:	89 e5                	mov    %esp,%ebp
  8008dc:	56                   	push   %esi
  8008dd:	53                   	push   %ebx
  8008de:	8b 75 08             	mov    0x8(%ebp),%esi
  8008e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008e4:	8b 55 10             	mov    0x10(%ebp),%edx
  8008e7:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008e9:	85 d2                	test   %edx,%edx
  8008eb:	74 21                	je     80090e <strlcpy+0x39>
  8008ed:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008f1:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008f3:	39 c2                	cmp    %eax,%edx
  8008f5:	74 14                	je     80090b <strlcpy+0x36>
  8008f7:	0f b6 19             	movzbl (%ecx),%ebx
  8008fa:	84 db                	test   %bl,%bl
  8008fc:	74 0b                	je     800909 <strlcpy+0x34>
			*dst++ = *src++;
  8008fe:	83 c1 01             	add    $0x1,%ecx
  800901:	83 c2 01             	add    $0x1,%edx
  800904:	88 5a ff             	mov    %bl,-0x1(%edx)
  800907:	eb ea                	jmp    8008f3 <strlcpy+0x1e>
  800909:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80090b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80090e:	29 f0                	sub    %esi,%eax
}
  800910:	5b                   	pop    %ebx
  800911:	5e                   	pop    %esi
  800912:	5d                   	pop    %ebp
  800913:	c3                   	ret    

00800914 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800914:	f3 0f 1e fb          	endbr32 
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
  80091b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80091e:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800921:	0f b6 01             	movzbl (%ecx),%eax
  800924:	84 c0                	test   %al,%al
  800926:	74 0c                	je     800934 <strcmp+0x20>
  800928:	3a 02                	cmp    (%edx),%al
  80092a:	75 08                	jne    800934 <strcmp+0x20>
		p++, q++;
  80092c:	83 c1 01             	add    $0x1,%ecx
  80092f:	83 c2 01             	add    $0x1,%edx
  800932:	eb ed                	jmp    800921 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800934:	0f b6 c0             	movzbl %al,%eax
  800937:	0f b6 12             	movzbl (%edx),%edx
  80093a:	29 d0                	sub    %edx,%eax
}
  80093c:	5d                   	pop    %ebp
  80093d:	c3                   	ret    

0080093e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80093e:	f3 0f 1e fb          	endbr32 
  800942:	55                   	push   %ebp
  800943:	89 e5                	mov    %esp,%ebp
  800945:	53                   	push   %ebx
  800946:	8b 45 08             	mov    0x8(%ebp),%eax
  800949:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094c:	89 c3                	mov    %eax,%ebx
  80094e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800951:	eb 06                	jmp    800959 <strncmp+0x1b>
		n--, p++, q++;
  800953:	83 c0 01             	add    $0x1,%eax
  800956:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800959:	39 d8                	cmp    %ebx,%eax
  80095b:	74 16                	je     800973 <strncmp+0x35>
  80095d:	0f b6 08             	movzbl (%eax),%ecx
  800960:	84 c9                	test   %cl,%cl
  800962:	74 04                	je     800968 <strncmp+0x2a>
  800964:	3a 0a                	cmp    (%edx),%cl
  800966:	74 eb                	je     800953 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800968:	0f b6 00             	movzbl (%eax),%eax
  80096b:	0f b6 12             	movzbl (%edx),%edx
  80096e:	29 d0                	sub    %edx,%eax
}
  800970:	5b                   	pop    %ebx
  800971:	5d                   	pop    %ebp
  800972:	c3                   	ret    
		return 0;
  800973:	b8 00 00 00 00       	mov    $0x0,%eax
  800978:	eb f6                	jmp    800970 <strncmp+0x32>

0080097a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80097a:	f3 0f 1e fb          	endbr32 
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	8b 45 08             	mov    0x8(%ebp),%eax
  800984:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800988:	0f b6 10             	movzbl (%eax),%edx
  80098b:	84 d2                	test   %dl,%dl
  80098d:	74 09                	je     800998 <strchr+0x1e>
		if (*s == c)
  80098f:	38 ca                	cmp    %cl,%dl
  800991:	74 0a                	je     80099d <strchr+0x23>
	for (; *s; s++)
  800993:	83 c0 01             	add    $0x1,%eax
  800996:	eb f0                	jmp    800988 <strchr+0xe>
			return (char *) s;
	return 0;
  800998:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80099d:	5d                   	pop    %ebp
  80099e:	c3                   	ret    

0080099f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80099f:	f3 0f 1e fb          	endbr32 
  8009a3:	55                   	push   %ebp
  8009a4:	89 e5                	mov    %esp,%ebp
  8009a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009ad:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009b0:	38 ca                	cmp    %cl,%dl
  8009b2:	74 09                	je     8009bd <strfind+0x1e>
  8009b4:	84 d2                	test   %dl,%dl
  8009b6:	74 05                	je     8009bd <strfind+0x1e>
	for (; *s; s++)
  8009b8:	83 c0 01             	add    $0x1,%eax
  8009bb:	eb f0                	jmp    8009ad <strfind+0xe>
			break;
	return (char *) s;
}
  8009bd:	5d                   	pop    %ebp
  8009be:	c3                   	ret    

008009bf <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009bf:	f3 0f 1e fb          	endbr32 
  8009c3:	55                   	push   %ebp
  8009c4:	89 e5                	mov    %esp,%ebp
  8009c6:	57                   	push   %edi
  8009c7:	56                   	push   %esi
  8009c8:	53                   	push   %ebx
  8009c9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009cf:	85 c9                	test   %ecx,%ecx
  8009d1:	74 31                	je     800a04 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009d3:	89 f8                	mov    %edi,%eax
  8009d5:	09 c8                	or     %ecx,%eax
  8009d7:	a8 03                	test   $0x3,%al
  8009d9:	75 23                	jne    8009fe <memset+0x3f>
		c &= 0xFF;
  8009db:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009df:	89 d3                	mov    %edx,%ebx
  8009e1:	c1 e3 08             	shl    $0x8,%ebx
  8009e4:	89 d0                	mov    %edx,%eax
  8009e6:	c1 e0 18             	shl    $0x18,%eax
  8009e9:	89 d6                	mov    %edx,%esi
  8009eb:	c1 e6 10             	shl    $0x10,%esi
  8009ee:	09 f0                	or     %esi,%eax
  8009f0:	09 c2                	or     %eax,%edx
  8009f2:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009f4:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009f7:	89 d0                	mov    %edx,%eax
  8009f9:	fc                   	cld    
  8009fa:	f3 ab                	rep stos %eax,%es:(%edi)
  8009fc:	eb 06                	jmp    800a04 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a01:	fc                   	cld    
  800a02:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a04:	89 f8                	mov    %edi,%eax
  800a06:	5b                   	pop    %ebx
  800a07:	5e                   	pop    %esi
  800a08:	5f                   	pop    %edi
  800a09:	5d                   	pop    %ebp
  800a0a:	c3                   	ret    

00800a0b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a0b:	f3 0f 1e fb          	endbr32 
  800a0f:	55                   	push   %ebp
  800a10:	89 e5                	mov    %esp,%ebp
  800a12:	57                   	push   %edi
  800a13:	56                   	push   %esi
  800a14:	8b 45 08             	mov    0x8(%ebp),%eax
  800a17:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a1a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a1d:	39 c6                	cmp    %eax,%esi
  800a1f:	73 32                	jae    800a53 <memmove+0x48>
  800a21:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a24:	39 c2                	cmp    %eax,%edx
  800a26:	76 2b                	jbe    800a53 <memmove+0x48>
		s += n;
		d += n;
  800a28:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a2b:	89 fe                	mov    %edi,%esi
  800a2d:	09 ce                	or     %ecx,%esi
  800a2f:	09 d6                	or     %edx,%esi
  800a31:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a37:	75 0e                	jne    800a47 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a39:	83 ef 04             	sub    $0x4,%edi
  800a3c:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a3f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a42:	fd                   	std    
  800a43:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a45:	eb 09                	jmp    800a50 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a47:	83 ef 01             	sub    $0x1,%edi
  800a4a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a4d:	fd                   	std    
  800a4e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a50:	fc                   	cld    
  800a51:	eb 1a                	jmp    800a6d <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a53:	89 c2                	mov    %eax,%edx
  800a55:	09 ca                	or     %ecx,%edx
  800a57:	09 f2                	or     %esi,%edx
  800a59:	f6 c2 03             	test   $0x3,%dl
  800a5c:	75 0a                	jne    800a68 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a5e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a61:	89 c7                	mov    %eax,%edi
  800a63:	fc                   	cld    
  800a64:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a66:	eb 05                	jmp    800a6d <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800a68:	89 c7                	mov    %eax,%edi
  800a6a:	fc                   	cld    
  800a6b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a6d:	5e                   	pop    %esi
  800a6e:	5f                   	pop    %edi
  800a6f:	5d                   	pop    %ebp
  800a70:	c3                   	ret    

00800a71 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a71:	f3 0f 1e fb          	endbr32 
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
  800a78:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a7b:	ff 75 10             	pushl  0x10(%ebp)
  800a7e:	ff 75 0c             	pushl  0xc(%ebp)
  800a81:	ff 75 08             	pushl  0x8(%ebp)
  800a84:	e8 82 ff ff ff       	call   800a0b <memmove>
}
  800a89:	c9                   	leave  
  800a8a:	c3                   	ret    

00800a8b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a8b:	f3 0f 1e fb          	endbr32 
  800a8f:	55                   	push   %ebp
  800a90:	89 e5                	mov    %esp,%ebp
  800a92:	56                   	push   %esi
  800a93:	53                   	push   %ebx
  800a94:	8b 45 08             	mov    0x8(%ebp),%eax
  800a97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9a:	89 c6                	mov    %eax,%esi
  800a9c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a9f:	39 f0                	cmp    %esi,%eax
  800aa1:	74 1c                	je     800abf <memcmp+0x34>
		if (*s1 != *s2)
  800aa3:	0f b6 08             	movzbl (%eax),%ecx
  800aa6:	0f b6 1a             	movzbl (%edx),%ebx
  800aa9:	38 d9                	cmp    %bl,%cl
  800aab:	75 08                	jne    800ab5 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800aad:	83 c0 01             	add    $0x1,%eax
  800ab0:	83 c2 01             	add    $0x1,%edx
  800ab3:	eb ea                	jmp    800a9f <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800ab5:	0f b6 c1             	movzbl %cl,%eax
  800ab8:	0f b6 db             	movzbl %bl,%ebx
  800abb:	29 d8                	sub    %ebx,%eax
  800abd:	eb 05                	jmp    800ac4 <memcmp+0x39>
	}

	return 0;
  800abf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ac4:	5b                   	pop    %ebx
  800ac5:	5e                   	pop    %esi
  800ac6:	5d                   	pop    %ebp
  800ac7:	c3                   	ret    

00800ac8 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ac8:	f3 0f 1e fb          	endbr32 
  800acc:	55                   	push   %ebp
  800acd:	89 e5                	mov    %esp,%ebp
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ad5:	89 c2                	mov    %eax,%edx
  800ad7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ada:	39 d0                	cmp    %edx,%eax
  800adc:	73 09                	jae    800ae7 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ade:	38 08                	cmp    %cl,(%eax)
  800ae0:	74 05                	je     800ae7 <memfind+0x1f>
	for (; s < ends; s++)
  800ae2:	83 c0 01             	add    $0x1,%eax
  800ae5:	eb f3                	jmp    800ada <memfind+0x12>
			break;
	return (void *) s;
}
  800ae7:	5d                   	pop    %ebp
  800ae8:	c3                   	ret    

00800ae9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ae9:	f3 0f 1e fb          	endbr32 
  800aed:	55                   	push   %ebp
  800aee:	89 e5                	mov    %esp,%ebp
  800af0:	57                   	push   %edi
  800af1:	56                   	push   %esi
  800af2:	53                   	push   %ebx
  800af3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800af6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800af9:	eb 03                	jmp    800afe <strtol+0x15>
		s++;
  800afb:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800afe:	0f b6 01             	movzbl (%ecx),%eax
  800b01:	3c 20                	cmp    $0x20,%al
  800b03:	74 f6                	je     800afb <strtol+0x12>
  800b05:	3c 09                	cmp    $0x9,%al
  800b07:	74 f2                	je     800afb <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800b09:	3c 2b                	cmp    $0x2b,%al
  800b0b:	74 2a                	je     800b37 <strtol+0x4e>
	int neg = 0;
  800b0d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b12:	3c 2d                	cmp    $0x2d,%al
  800b14:	74 2b                	je     800b41 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b16:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b1c:	75 0f                	jne    800b2d <strtol+0x44>
  800b1e:	80 39 30             	cmpb   $0x30,(%ecx)
  800b21:	74 28                	je     800b4b <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b23:	85 db                	test   %ebx,%ebx
  800b25:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b2a:	0f 44 d8             	cmove  %eax,%ebx
  800b2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b32:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b35:	eb 46                	jmp    800b7d <strtol+0x94>
		s++;
  800b37:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b3a:	bf 00 00 00 00       	mov    $0x0,%edi
  800b3f:	eb d5                	jmp    800b16 <strtol+0x2d>
		s++, neg = 1;
  800b41:	83 c1 01             	add    $0x1,%ecx
  800b44:	bf 01 00 00 00       	mov    $0x1,%edi
  800b49:	eb cb                	jmp    800b16 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b4b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b4f:	74 0e                	je     800b5f <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b51:	85 db                	test   %ebx,%ebx
  800b53:	75 d8                	jne    800b2d <strtol+0x44>
		s++, base = 8;
  800b55:	83 c1 01             	add    $0x1,%ecx
  800b58:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b5d:	eb ce                	jmp    800b2d <strtol+0x44>
		s += 2, base = 16;
  800b5f:	83 c1 02             	add    $0x2,%ecx
  800b62:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b67:	eb c4                	jmp    800b2d <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b69:	0f be d2             	movsbl %dl,%edx
  800b6c:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b6f:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b72:	7d 3a                	jge    800bae <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b74:	83 c1 01             	add    $0x1,%ecx
  800b77:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b7b:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b7d:	0f b6 11             	movzbl (%ecx),%edx
  800b80:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b83:	89 f3                	mov    %esi,%ebx
  800b85:	80 fb 09             	cmp    $0x9,%bl
  800b88:	76 df                	jbe    800b69 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b8a:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b8d:	89 f3                	mov    %esi,%ebx
  800b8f:	80 fb 19             	cmp    $0x19,%bl
  800b92:	77 08                	ja     800b9c <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b94:	0f be d2             	movsbl %dl,%edx
  800b97:	83 ea 57             	sub    $0x57,%edx
  800b9a:	eb d3                	jmp    800b6f <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b9c:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b9f:	89 f3                	mov    %esi,%ebx
  800ba1:	80 fb 19             	cmp    $0x19,%bl
  800ba4:	77 08                	ja     800bae <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ba6:	0f be d2             	movsbl %dl,%edx
  800ba9:	83 ea 37             	sub    $0x37,%edx
  800bac:	eb c1                	jmp    800b6f <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb2:	74 05                	je     800bb9 <strtol+0xd0>
		*endptr = (char *) s;
  800bb4:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bb7:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bb9:	89 c2                	mov    %eax,%edx
  800bbb:	f7 da                	neg    %edx
  800bbd:	85 ff                	test   %edi,%edi
  800bbf:	0f 45 c2             	cmovne %edx,%eax
}
  800bc2:	5b                   	pop    %ebx
  800bc3:	5e                   	pop    %esi
  800bc4:	5f                   	pop    %edi
  800bc5:	5d                   	pop    %ebp
  800bc6:	c3                   	ret    

00800bc7 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bc7:	f3 0f 1e fb          	endbr32 
  800bcb:	55                   	push   %ebp
  800bcc:	89 e5                	mov    %esp,%ebp
  800bce:	57                   	push   %edi
  800bcf:	56                   	push   %esi
  800bd0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd1:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bdc:	89 c3                	mov    %eax,%ebx
  800bde:	89 c7                	mov    %eax,%edi
  800be0:	89 c6                	mov    %eax,%esi
  800be2:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800be4:	5b                   	pop    %ebx
  800be5:	5e                   	pop    %esi
  800be6:	5f                   	pop    %edi
  800be7:	5d                   	pop    %ebp
  800be8:	c3                   	ret    

00800be9 <sys_cgetc>:

int
sys_cgetc(void)
{
  800be9:	f3 0f 1e fb          	endbr32 
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	57                   	push   %edi
  800bf1:	56                   	push   %esi
  800bf2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bf3:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf8:	b8 01 00 00 00       	mov    $0x1,%eax
  800bfd:	89 d1                	mov    %edx,%ecx
  800bff:	89 d3                	mov    %edx,%ebx
  800c01:	89 d7                	mov    %edx,%edi
  800c03:	89 d6                	mov    %edx,%esi
  800c05:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c07:	5b                   	pop    %ebx
  800c08:	5e                   	pop    %esi
  800c09:	5f                   	pop    %edi
  800c0a:	5d                   	pop    %ebp
  800c0b:	c3                   	ret    

00800c0c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c0c:	f3 0f 1e fb          	endbr32 
  800c10:	55                   	push   %ebp
  800c11:	89 e5                	mov    %esp,%ebp
  800c13:	57                   	push   %edi
  800c14:	56                   	push   %esi
  800c15:	53                   	push   %ebx
  800c16:	83 ec 1c             	sub    $0x1c,%esp
  800c19:	e8 ec fb ff ff       	call   80080a <__x86.get_pc_thunk.ax>
  800c1e:	05 e2 13 00 00       	add    $0x13e2,%eax
  800c23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	asm volatile("int %1\n"
  800c26:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2e:	b8 03 00 00 00       	mov    $0x3,%eax
  800c33:	89 cb                	mov    %ecx,%ebx
  800c35:	89 cf                	mov    %ecx,%edi
  800c37:	89 ce                	mov    %ecx,%esi
  800c39:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c3b:	85 c0                	test   %eax,%eax
  800c3d:	7f 08                	jg     800c47 <sys_env_destroy+0x3b>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
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
  800c4b:	6a 03                	push   $0x3
  800c4d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800c50:	8d 83 64 f1 ff ff    	lea    -0xe9c(%ebx),%eax
  800c56:	50                   	push   %eax
  800c57:	6a 23                	push   $0x23
  800c59:	8d 83 81 f1 ff ff    	lea    -0xe7f(%ebx),%eax
  800c5f:	50                   	push   %eax
  800c60:	e8 23 00 00 00       	call   800c88 <_panic>

00800c65 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c65:	f3 0f 1e fb          	endbr32 
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	57                   	push   %edi
  800c6d:	56                   	push   %esi
  800c6e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c6f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c74:	b8 02 00 00 00       	mov    $0x2,%eax
  800c79:	89 d1                	mov    %edx,%ecx
  800c7b:	89 d3                	mov    %edx,%ebx
  800c7d:	89 d7                	mov    %edx,%edi
  800c7f:	89 d6                	mov    %edx,%esi
  800c81:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c83:	5b                   	pop    %ebx
  800c84:	5e                   	pop    %esi
  800c85:	5f                   	pop    %edi
  800c86:	5d                   	pop    %ebp
  800c87:	c3                   	ret    

00800c88 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800c88:	f3 0f 1e fb          	endbr32 
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	57                   	push   %edi
  800c90:	56                   	push   %esi
  800c91:	53                   	push   %ebx
  800c92:	83 ec 0c             	sub    $0xc,%esp
  800c95:	e8 de f3 ff ff       	call   800078 <__x86.get_pc_thunk.bx>
  800c9a:	81 c3 66 13 00 00    	add    $0x1366,%ebx
	va_list ap;

	va_start(ap, fmt);
  800ca0:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800ca3:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  800ca9:	8b 38                	mov    (%eax),%edi
  800cab:	e8 b5 ff ff ff       	call   800c65 <sys_getenvid>
  800cb0:	83 ec 0c             	sub    $0xc,%esp
  800cb3:	ff 75 0c             	pushl  0xc(%ebp)
  800cb6:	ff 75 08             	pushl  0x8(%ebp)
  800cb9:	57                   	push   %edi
  800cba:	50                   	push   %eax
  800cbb:	8d 83 90 f1 ff ff    	lea    -0xe70(%ebx),%eax
  800cc1:	50                   	push   %eax
  800cc2:	e8 f5 f4 ff ff       	call   8001bc <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800cc7:	83 c4 18             	add    $0x18,%esp
  800cca:	56                   	push   %esi
  800ccb:	ff 75 10             	pushl  0x10(%ebp)
  800cce:	e8 83 f4 ff ff       	call   800156 <vcprintf>
	cprintf("\n");
  800cd3:	8d 83 5c ef ff ff    	lea    -0x10a4(%ebx),%eax
  800cd9:	89 04 24             	mov    %eax,(%esp)
  800cdc:	e8 db f4 ff ff       	call   8001bc <cprintf>
  800ce1:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800ce4:	cc                   	int3   
  800ce5:	eb fd                	jmp    800ce4 <_panic+0x5c>
  800ce7:	66 90                	xchg   %ax,%ax
  800ce9:	66 90                	xchg   %ax,%ax
  800ceb:	66 90                	xchg   %ax,%ax
  800ced:	66 90                	xchg   %ax,%ax
  800cef:	90                   	nop

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
