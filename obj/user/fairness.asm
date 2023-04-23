
obj/user/fairness.debug:     file format elf32-i386


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
  80002c:	e8 74 00 00 00       	call   8000a5 <libmain>
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
  80003a:	56                   	push   %esi
  80003b:	53                   	push   %ebx
  80003c:	83 ec 10             	sub    $0x10,%esp
	envid_t who, id;

	id = sys_getenvid();
  80003f:	e8 6c 0b 00 00       	call   800bb0 <sys_getenvid>
  800044:	89 c3                	mov    %eax,%ebx

	if (thisenv == &envs[1]) {
  800046:	81 3d 08 40 80 00 7c 	cmpl   $0xeec0007c,0x804008
  80004d:	00 c0 ee 
  800050:	74 2d                	je     80007f <umain+0x4c>
		while (1) {
			ipc_recv(&who, 0, 0);
			cprintf("%x recv from %x\n", id, who);
		}
	} else {
		cprintf("%x loop sending to %x\n", id, envs[1].env_id);
  800052:	a1 c4 00 c0 ee       	mov    0xeec000c4,%eax
  800057:	83 ec 04             	sub    $0x4,%esp
  80005a:	50                   	push   %eax
  80005b:	53                   	push   %ebx
  80005c:	68 d1 24 80 00       	push   $0x8024d1
  800061:	e8 44 01 00 00       	call   8001aa <cprintf>
  800066:	83 c4 10             	add    $0x10,%esp
		while (1)
			ipc_send(envs[1].env_id, 0, 0, 0);
  800069:	a1 c4 00 c0 ee       	mov    0xeec000c4,%eax
  80006e:	6a 00                	push   $0x0
  800070:	6a 00                	push   $0x0
  800072:	6a 00                	push   $0x0
  800074:	50                   	push   %eax
  800075:	e8 c1 0e 00 00       	call   800f3b <ipc_send>
  80007a:	83 c4 10             	add    $0x10,%esp
  80007d:	eb ea                	jmp    800069 <umain+0x36>
			ipc_recv(&who, 0, 0);
  80007f:	8d 75 f4             	lea    -0xc(%ebp),%esi
  800082:	83 ec 04             	sub    $0x4,%esp
  800085:	6a 00                	push   $0x0
  800087:	6a 00                	push   $0x0
  800089:	56                   	push   %esi
  80008a:	e8 27 0e 00 00       	call   800eb6 <ipc_recv>
			cprintf("%x recv from %x\n", id, who);
  80008f:	83 c4 0c             	add    $0xc,%esp
  800092:	ff 75 f4             	pushl  -0xc(%ebp)
  800095:	53                   	push   %ebx
  800096:	68 c0 24 80 00       	push   $0x8024c0
  80009b:	e8 0a 01 00 00       	call   8001aa <cprintf>
  8000a0:	83 c4 10             	add    $0x10,%esp
  8000a3:	eb dd                	jmp    800082 <umain+0x4f>

008000a5 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000a5:	f3 0f 1e fb          	endbr32 
  8000a9:	55                   	push   %ebp
  8000aa:	89 e5                	mov    %esp,%ebp
  8000ac:	56                   	push   %esi
  8000ad:	53                   	push   %ebx
  8000ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000b1:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000b4:	e8 f7 0a 00 00       	call   800bb0 <sys_getenvid>
  8000b9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000be:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000c1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000c6:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000cb:	85 db                	test   %ebx,%ebx
  8000cd:	7e 07                	jle    8000d6 <libmain+0x31>
		binaryname = argv[0];
  8000cf:	8b 06                	mov    (%esi),%eax
  8000d1:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000d6:	83 ec 08             	sub    $0x8,%esp
  8000d9:	56                   	push   %esi
  8000da:	53                   	push   %ebx
  8000db:	e8 53 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000e0:	e8 0a 00 00 00       	call   8000ef <exit>
}
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000eb:	5b                   	pop    %ebx
  8000ec:	5e                   	pop    %esi
  8000ed:	5d                   	pop    %ebp
  8000ee:	c3                   	ret    

008000ef <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ef:	f3 0f 1e fb          	endbr32 
  8000f3:	55                   	push   %ebp
  8000f4:	89 e5                	mov    %esp,%ebp
  8000f6:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000f9:	e8 c6 10 00 00       	call   8011c4 <close_all>
	sys_env_destroy(0);
  8000fe:	83 ec 0c             	sub    $0xc,%esp
  800101:	6a 00                	push   $0x0
  800103:	e8 63 0a 00 00       	call   800b6b <sys_env_destroy>
}
  800108:	83 c4 10             	add    $0x10,%esp
  80010b:	c9                   	leave  
  80010c:	c3                   	ret    

0080010d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80010d:	f3 0f 1e fb          	endbr32 
  800111:	55                   	push   %ebp
  800112:	89 e5                	mov    %esp,%ebp
  800114:	53                   	push   %ebx
  800115:	83 ec 04             	sub    $0x4,%esp
  800118:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80011b:	8b 13                	mov    (%ebx),%edx
  80011d:	8d 42 01             	lea    0x1(%edx),%eax
  800120:	89 03                	mov    %eax,(%ebx)
  800122:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800125:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800129:	3d ff 00 00 00       	cmp    $0xff,%eax
  80012e:	74 09                	je     800139 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800130:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800134:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800137:	c9                   	leave  
  800138:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800139:	83 ec 08             	sub    $0x8,%esp
  80013c:	68 ff 00 00 00       	push   $0xff
  800141:	8d 43 08             	lea    0x8(%ebx),%eax
  800144:	50                   	push   %eax
  800145:	e8 dc 09 00 00       	call   800b26 <sys_cputs>
		b->idx = 0;
  80014a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800150:	83 c4 10             	add    $0x10,%esp
  800153:	eb db                	jmp    800130 <putch+0x23>

00800155 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800155:	f3 0f 1e fb          	endbr32 
  800159:	55                   	push   %ebp
  80015a:	89 e5                	mov    %esp,%ebp
  80015c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800162:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800169:	00 00 00 
	b.cnt = 0;
  80016c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800173:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800176:	ff 75 0c             	pushl  0xc(%ebp)
  800179:	ff 75 08             	pushl  0x8(%ebp)
  80017c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800182:	50                   	push   %eax
  800183:	68 0d 01 80 00       	push   $0x80010d
  800188:	e8 20 01 00 00       	call   8002ad <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80018d:	83 c4 08             	add    $0x8,%esp
  800190:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800196:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80019c:	50                   	push   %eax
  80019d:	e8 84 09 00 00       	call   800b26 <sys_cputs>

	return b.cnt;
}
  8001a2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001a8:	c9                   	leave  
  8001a9:	c3                   	ret    

008001aa <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001aa:	f3 0f 1e fb          	endbr32 
  8001ae:	55                   	push   %ebp
  8001af:	89 e5                	mov    %esp,%ebp
  8001b1:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001b4:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001b7:	50                   	push   %eax
  8001b8:	ff 75 08             	pushl  0x8(%ebp)
  8001bb:	e8 95 ff ff ff       	call   800155 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001c0:	c9                   	leave  
  8001c1:	c3                   	ret    

008001c2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001c2:	55                   	push   %ebp
  8001c3:	89 e5                	mov    %esp,%ebp
  8001c5:	57                   	push   %edi
  8001c6:	56                   	push   %esi
  8001c7:	53                   	push   %ebx
  8001c8:	83 ec 1c             	sub    $0x1c,%esp
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	89 d6                	mov    %edx,%esi
  8001cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d5:	89 d1                	mov    %edx,%ecx
  8001d7:	89 c2                	mov    %eax,%edx
  8001d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001dc:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001df:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e2:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001e8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001ef:	39 c2                	cmp    %eax,%edx
  8001f1:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8001f4:	72 3e                	jb     800234 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001f6:	83 ec 0c             	sub    $0xc,%esp
  8001f9:	ff 75 18             	pushl  0x18(%ebp)
  8001fc:	83 eb 01             	sub    $0x1,%ebx
  8001ff:	53                   	push   %ebx
  800200:	50                   	push   %eax
  800201:	83 ec 08             	sub    $0x8,%esp
  800204:	ff 75 e4             	pushl  -0x1c(%ebp)
  800207:	ff 75 e0             	pushl  -0x20(%ebp)
  80020a:	ff 75 dc             	pushl  -0x24(%ebp)
  80020d:	ff 75 d8             	pushl  -0x28(%ebp)
  800210:	e8 4b 20 00 00       	call   802260 <__udivdi3>
  800215:	83 c4 18             	add    $0x18,%esp
  800218:	52                   	push   %edx
  800219:	50                   	push   %eax
  80021a:	89 f2                	mov    %esi,%edx
  80021c:	89 f8                	mov    %edi,%eax
  80021e:	e8 9f ff ff ff       	call   8001c2 <printnum>
  800223:	83 c4 20             	add    $0x20,%esp
  800226:	eb 13                	jmp    80023b <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800228:	83 ec 08             	sub    $0x8,%esp
  80022b:	56                   	push   %esi
  80022c:	ff 75 18             	pushl  0x18(%ebp)
  80022f:	ff d7                	call   *%edi
  800231:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800234:	83 eb 01             	sub    $0x1,%ebx
  800237:	85 db                	test   %ebx,%ebx
  800239:	7f ed                	jg     800228 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80023b:	83 ec 08             	sub    $0x8,%esp
  80023e:	56                   	push   %esi
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	ff 75 e4             	pushl  -0x1c(%ebp)
  800245:	ff 75 e0             	pushl  -0x20(%ebp)
  800248:	ff 75 dc             	pushl  -0x24(%ebp)
  80024b:	ff 75 d8             	pushl  -0x28(%ebp)
  80024e:	e8 1d 21 00 00       	call   802370 <__umoddi3>
  800253:	83 c4 14             	add    $0x14,%esp
  800256:	0f be 80 f2 24 80 00 	movsbl 0x8024f2(%eax),%eax
  80025d:	50                   	push   %eax
  80025e:	ff d7                	call   *%edi
}
  800260:	83 c4 10             	add    $0x10,%esp
  800263:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800266:	5b                   	pop    %ebx
  800267:	5e                   	pop    %esi
  800268:	5f                   	pop    %edi
  800269:	5d                   	pop    %ebp
  80026a:	c3                   	ret    

0080026b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80026b:	f3 0f 1e fb          	endbr32 
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
  800272:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800275:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800279:	8b 10                	mov    (%eax),%edx
  80027b:	3b 50 04             	cmp    0x4(%eax),%edx
  80027e:	73 0a                	jae    80028a <sprintputch+0x1f>
		*b->buf++ = ch;
  800280:	8d 4a 01             	lea    0x1(%edx),%ecx
  800283:	89 08                	mov    %ecx,(%eax)
  800285:	8b 45 08             	mov    0x8(%ebp),%eax
  800288:	88 02                	mov    %al,(%edx)
}
  80028a:	5d                   	pop    %ebp
  80028b:	c3                   	ret    

0080028c <printfmt>:
{
  80028c:	f3 0f 1e fb          	endbr32 
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800296:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800299:	50                   	push   %eax
  80029a:	ff 75 10             	pushl  0x10(%ebp)
  80029d:	ff 75 0c             	pushl  0xc(%ebp)
  8002a0:	ff 75 08             	pushl  0x8(%ebp)
  8002a3:	e8 05 00 00 00       	call   8002ad <vprintfmt>
}
  8002a8:	83 c4 10             	add    $0x10,%esp
  8002ab:	c9                   	leave  
  8002ac:	c3                   	ret    

008002ad <vprintfmt>:
{
  8002ad:	f3 0f 1e fb          	endbr32 
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	57                   	push   %edi
  8002b5:	56                   	push   %esi
  8002b6:	53                   	push   %ebx
  8002b7:	83 ec 3c             	sub    $0x3c,%esp
  8002ba:	8b 75 08             	mov    0x8(%ebp),%esi
  8002bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002c0:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002c3:	e9 8e 03 00 00       	jmp    800656 <vprintfmt+0x3a9>
		padc = ' ';
  8002c8:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002cc:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002d3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002da:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002e1:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002e6:	8d 47 01             	lea    0x1(%edi),%eax
  8002e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ec:	0f b6 17             	movzbl (%edi),%edx
  8002ef:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002f2:	3c 55                	cmp    $0x55,%al
  8002f4:	0f 87 df 03 00 00    	ja     8006d9 <vprintfmt+0x42c>
  8002fa:	0f b6 c0             	movzbl %al,%eax
  8002fd:	3e ff 24 85 40 26 80 	notrack jmp *0x802640(,%eax,4)
  800304:	00 
  800305:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800308:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80030c:	eb d8                	jmp    8002e6 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80030e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800311:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800315:	eb cf                	jmp    8002e6 <vprintfmt+0x39>
  800317:	0f b6 d2             	movzbl %dl,%edx
  80031a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80031d:	b8 00 00 00 00       	mov    $0x0,%eax
  800322:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800325:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800328:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80032c:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80032f:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800332:	83 f9 09             	cmp    $0x9,%ecx
  800335:	77 55                	ja     80038c <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800337:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80033a:	eb e9                	jmp    800325 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80033c:	8b 45 14             	mov    0x14(%ebp),%eax
  80033f:	8b 00                	mov    (%eax),%eax
  800341:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800344:	8b 45 14             	mov    0x14(%ebp),%eax
  800347:	8d 40 04             	lea    0x4(%eax),%eax
  80034a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80034d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800350:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800354:	79 90                	jns    8002e6 <vprintfmt+0x39>
				width = precision, precision = -1;
  800356:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800359:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80035c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800363:	eb 81                	jmp    8002e6 <vprintfmt+0x39>
  800365:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800368:	85 c0                	test   %eax,%eax
  80036a:	ba 00 00 00 00       	mov    $0x0,%edx
  80036f:	0f 49 d0             	cmovns %eax,%edx
  800372:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800375:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800378:	e9 69 ff ff ff       	jmp    8002e6 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80037d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800380:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800387:	e9 5a ff ff ff       	jmp    8002e6 <vprintfmt+0x39>
  80038c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80038f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800392:	eb bc                	jmp    800350 <vprintfmt+0xa3>
			lflag++;
  800394:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800397:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80039a:	e9 47 ff ff ff       	jmp    8002e6 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80039f:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a2:	8d 78 04             	lea    0x4(%eax),%edi
  8003a5:	83 ec 08             	sub    $0x8,%esp
  8003a8:	53                   	push   %ebx
  8003a9:	ff 30                	pushl  (%eax)
  8003ab:	ff d6                	call   *%esi
			break;
  8003ad:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003b0:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003b3:	e9 9b 02 00 00       	jmp    800653 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8003b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003bb:	8d 78 04             	lea    0x4(%eax),%edi
  8003be:	8b 00                	mov    (%eax),%eax
  8003c0:	99                   	cltd   
  8003c1:	31 d0                	xor    %edx,%eax
  8003c3:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003c5:	83 f8 0f             	cmp    $0xf,%eax
  8003c8:	7f 23                	jg     8003ed <vprintfmt+0x140>
  8003ca:	8b 14 85 a0 27 80 00 	mov    0x8027a0(,%eax,4),%edx
  8003d1:	85 d2                	test   %edx,%edx
  8003d3:	74 18                	je     8003ed <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8003d5:	52                   	push   %edx
  8003d6:	68 f9 28 80 00       	push   $0x8028f9
  8003db:	53                   	push   %ebx
  8003dc:	56                   	push   %esi
  8003dd:	e8 aa fe ff ff       	call   80028c <printfmt>
  8003e2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003e5:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003e8:	e9 66 02 00 00       	jmp    800653 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8003ed:	50                   	push   %eax
  8003ee:	68 0a 25 80 00       	push   $0x80250a
  8003f3:	53                   	push   %ebx
  8003f4:	56                   	push   %esi
  8003f5:	e8 92 fe ff ff       	call   80028c <printfmt>
  8003fa:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003fd:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800400:	e9 4e 02 00 00       	jmp    800653 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800405:	8b 45 14             	mov    0x14(%ebp),%eax
  800408:	83 c0 04             	add    $0x4,%eax
  80040b:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80040e:	8b 45 14             	mov    0x14(%ebp),%eax
  800411:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800413:	85 d2                	test   %edx,%edx
  800415:	b8 03 25 80 00       	mov    $0x802503,%eax
  80041a:	0f 45 c2             	cmovne %edx,%eax
  80041d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800420:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800424:	7e 06                	jle    80042c <vprintfmt+0x17f>
  800426:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80042a:	75 0d                	jne    800439 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80042c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80042f:	89 c7                	mov    %eax,%edi
  800431:	03 45 e0             	add    -0x20(%ebp),%eax
  800434:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800437:	eb 55                	jmp    80048e <vprintfmt+0x1e1>
  800439:	83 ec 08             	sub    $0x8,%esp
  80043c:	ff 75 d8             	pushl  -0x28(%ebp)
  80043f:	ff 75 cc             	pushl  -0x34(%ebp)
  800442:	e8 46 03 00 00       	call   80078d <strnlen>
  800447:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80044a:	29 c2                	sub    %eax,%edx
  80044c:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80044f:	83 c4 10             	add    $0x10,%esp
  800452:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800454:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800458:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80045b:	85 ff                	test   %edi,%edi
  80045d:	7e 11                	jle    800470 <vprintfmt+0x1c3>
					putch(padc, putdat);
  80045f:	83 ec 08             	sub    $0x8,%esp
  800462:	53                   	push   %ebx
  800463:	ff 75 e0             	pushl  -0x20(%ebp)
  800466:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800468:	83 ef 01             	sub    $0x1,%edi
  80046b:	83 c4 10             	add    $0x10,%esp
  80046e:	eb eb                	jmp    80045b <vprintfmt+0x1ae>
  800470:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800473:	85 d2                	test   %edx,%edx
  800475:	b8 00 00 00 00       	mov    $0x0,%eax
  80047a:	0f 49 c2             	cmovns %edx,%eax
  80047d:	29 c2                	sub    %eax,%edx
  80047f:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800482:	eb a8                	jmp    80042c <vprintfmt+0x17f>
					putch(ch, putdat);
  800484:	83 ec 08             	sub    $0x8,%esp
  800487:	53                   	push   %ebx
  800488:	52                   	push   %edx
  800489:	ff d6                	call   *%esi
  80048b:	83 c4 10             	add    $0x10,%esp
  80048e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800491:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800493:	83 c7 01             	add    $0x1,%edi
  800496:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80049a:	0f be d0             	movsbl %al,%edx
  80049d:	85 d2                	test   %edx,%edx
  80049f:	74 4b                	je     8004ec <vprintfmt+0x23f>
  8004a1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004a5:	78 06                	js     8004ad <vprintfmt+0x200>
  8004a7:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004ab:	78 1e                	js     8004cb <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004ad:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004b1:	74 d1                	je     800484 <vprintfmt+0x1d7>
  8004b3:	0f be c0             	movsbl %al,%eax
  8004b6:	83 e8 20             	sub    $0x20,%eax
  8004b9:	83 f8 5e             	cmp    $0x5e,%eax
  8004bc:	76 c6                	jbe    800484 <vprintfmt+0x1d7>
					putch('?', putdat);
  8004be:	83 ec 08             	sub    $0x8,%esp
  8004c1:	53                   	push   %ebx
  8004c2:	6a 3f                	push   $0x3f
  8004c4:	ff d6                	call   *%esi
  8004c6:	83 c4 10             	add    $0x10,%esp
  8004c9:	eb c3                	jmp    80048e <vprintfmt+0x1e1>
  8004cb:	89 cf                	mov    %ecx,%edi
  8004cd:	eb 0e                	jmp    8004dd <vprintfmt+0x230>
				putch(' ', putdat);
  8004cf:	83 ec 08             	sub    $0x8,%esp
  8004d2:	53                   	push   %ebx
  8004d3:	6a 20                	push   $0x20
  8004d5:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004d7:	83 ef 01             	sub    $0x1,%edi
  8004da:	83 c4 10             	add    $0x10,%esp
  8004dd:	85 ff                	test   %edi,%edi
  8004df:	7f ee                	jg     8004cf <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8004e1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004e4:	89 45 14             	mov    %eax,0x14(%ebp)
  8004e7:	e9 67 01 00 00       	jmp    800653 <vprintfmt+0x3a6>
  8004ec:	89 cf                	mov    %ecx,%edi
  8004ee:	eb ed                	jmp    8004dd <vprintfmt+0x230>
	if (lflag >= 2)
  8004f0:	83 f9 01             	cmp    $0x1,%ecx
  8004f3:	7f 1b                	jg     800510 <vprintfmt+0x263>
	else if (lflag)
  8004f5:	85 c9                	test   %ecx,%ecx
  8004f7:	74 63                	je     80055c <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8004f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fc:	8b 00                	mov    (%eax),%eax
  8004fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800501:	99                   	cltd   
  800502:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800505:	8b 45 14             	mov    0x14(%ebp),%eax
  800508:	8d 40 04             	lea    0x4(%eax),%eax
  80050b:	89 45 14             	mov    %eax,0x14(%ebp)
  80050e:	eb 17                	jmp    800527 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800510:	8b 45 14             	mov    0x14(%ebp),%eax
  800513:	8b 50 04             	mov    0x4(%eax),%edx
  800516:	8b 00                	mov    (%eax),%eax
  800518:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80051b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80051e:	8b 45 14             	mov    0x14(%ebp),%eax
  800521:	8d 40 08             	lea    0x8(%eax),%eax
  800524:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800527:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80052a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80052d:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800532:	85 c9                	test   %ecx,%ecx
  800534:	0f 89 ff 00 00 00    	jns    800639 <vprintfmt+0x38c>
				putch('-', putdat);
  80053a:	83 ec 08             	sub    $0x8,%esp
  80053d:	53                   	push   %ebx
  80053e:	6a 2d                	push   $0x2d
  800540:	ff d6                	call   *%esi
				num = -(long long) num;
  800542:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800545:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800548:	f7 da                	neg    %edx
  80054a:	83 d1 00             	adc    $0x0,%ecx
  80054d:	f7 d9                	neg    %ecx
  80054f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800552:	b8 0a 00 00 00       	mov    $0xa,%eax
  800557:	e9 dd 00 00 00       	jmp    800639 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  80055c:	8b 45 14             	mov    0x14(%ebp),%eax
  80055f:	8b 00                	mov    (%eax),%eax
  800561:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800564:	99                   	cltd   
  800565:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800568:	8b 45 14             	mov    0x14(%ebp),%eax
  80056b:	8d 40 04             	lea    0x4(%eax),%eax
  80056e:	89 45 14             	mov    %eax,0x14(%ebp)
  800571:	eb b4                	jmp    800527 <vprintfmt+0x27a>
	if (lflag >= 2)
  800573:	83 f9 01             	cmp    $0x1,%ecx
  800576:	7f 1e                	jg     800596 <vprintfmt+0x2e9>
	else if (lflag)
  800578:	85 c9                	test   %ecx,%ecx
  80057a:	74 32                	je     8005ae <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	8b 10                	mov    (%eax),%edx
  800581:	b9 00 00 00 00       	mov    $0x0,%ecx
  800586:	8d 40 04             	lea    0x4(%eax),%eax
  800589:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80058c:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800591:	e9 a3 00 00 00       	jmp    800639 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800596:	8b 45 14             	mov    0x14(%ebp),%eax
  800599:	8b 10                	mov    (%eax),%edx
  80059b:	8b 48 04             	mov    0x4(%eax),%ecx
  80059e:	8d 40 08             	lea    0x8(%eax),%eax
  8005a1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005a4:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8005a9:	e9 8b 00 00 00       	jmp    800639 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b1:	8b 10                	mov    (%eax),%edx
  8005b3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005b8:	8d 40 04             	lea    0x4(%eax),%eax
  8005bb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005be:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8005c3:	eb 74                	jmp    800639 <vprintfmt+0x38c>
	if (lflag >= 2)
  8005c5:	83 f9 01             	cmp    $0x1,%ecx
  8005c8:	7f 1b                	jg     8005e5 <vprintfmt+0x338>
	else if (lflag)
  8005ca:	85 c9                	test   %ecx,%ecx
  8005cc:	74 2c                	je     8005fa <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8005ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d1:	8b 10                	mov    (%eax),%edx
  8005d3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005d8:	8d 40 04             	lea    0x4(%eax),%eax
  8005db:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005de:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8005e3:	eb 54                	jmp    800639 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e8:	8b 10                	mov    (%eax),%edx
  8005ea:	8b 48 04             	mov    0x4(%eax),%ecx
  8005ed:	8d 40 08             	lea    0x8(%eax),%eax
  8005f0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005f3:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  8005f8:	eb 3f                	jmp    800639 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fd:	8b 10                	mov    (%eax),%edx
  8005ff:	b9 00 00 00 00       	mov    $0x0,%ecx
  800604:	8d 40 04             	lea    0x4(%eax),%eax
  800607:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80060a:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  80060f:	eb 28                	jmp    800639 <vprintfmt+0x38c>
			putch('0', putdat);
  800611:	83 ec 08             	sub    $0x8,%esp
  800614:	53                   	push   %ebx
  800615:	6a 30                	push   $0x30
  800617:	ff d6                	call   *%esi
			putch('x', putdat);
  800619:	83 c4 08             	add    $0x8,%esp
  80061c:	53                   	push   %ebx
  80061d:	6a 78                	push   $0x78
  80061f:	ff d6                	call   *%esi
			num = (unsigned long long)
  800621:	8b 45 14             	mov    0x14(%ebp),%eax
  800624:	8b 10                	mov    (%eax),%edx
  800626:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80062b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80062e:	8d 40 04             	lea    0x4(%eax),%eax
  800631:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800634:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800639:	83 ec 0c             	sub    $0xc,%esp
  80063c:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800640:	57                   	push   %edi
  800641:	ff 75 e0             	pushl  -0x20(%ebp)
  800644:	50                   	push   %eax
  800645:	51                   	push   %ecx
  800646:	52                   	push   %edx
  800647:	89 da                	mov    %ebx,%edx
  800649:	89 f0                	mov    %esi,%eax
  80064b:	e8 72 fb ff ff       	call   8001c2 <printnum>
			break;
  800650:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800653:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800656:	83 c7 01             	add    $0x1,%edi
  800659:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80065d:	83 f8 25             	cmp    $0x25,%eax
  800660:	0f 84 62 fc ff ff    	je     8002c8 <vprintfmt+0x1b>
			if (ch == '\0')
  800666:	85 c0                	test   %eax,%eax
  800668:	0f 84 8b 00 00 00    	je     8006f9 <vprintfmt+0x44c>
			putch(ch, putdat);
  80066e:	83 ec 08             	sub    $0x8,%esp
  800671:	53                   	push   %ebx
  800672:	50                   	push   %eax
  800673:	ff d6                	call   *%esi
  800675:	83 c4 10             	add    $0x10,%esp
  800678:	eb dc                	jmp    800656 <vprintfmt+0x3a9>
	if (lflag >= 2)
  80067a:	83 f9 01             	cmp    $0x1,%ecx
  80067d:	7f 1b                	jg     80069a <vprintfmt+0x3ed>
	else if (lflag)
  80067f:	85 c9                	test   %ecx,%ecx
  800681:	74 2c                	je     8006af <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800683:	8b 45 14             	mov    0x14(%ebp),%eax
  800686:	8b 10                	mov    (%eax),%edx
  800688:	b9 00 00 00 00       	mov    $0x0,%ecx
  80068d:	8d 40 04             	lea    0x4(%eax),%eax
  800690:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800693:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800698:	eb 9f                	jmp    800639 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80069a:	8b 45 14             	mov    0x14(%ebp),%eax
  80069d:	8b 10                	mov    (%eax),%edx
  80069f:	8b 48 04             	mov    0x4(%eax),%ecx
  8006a2:	8d 40 08             	lea    0x8(%eax),%eax
  8006a5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a8:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8006ad:	eb 8a                	jmp    800639 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006af:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b2:	8b 10                	mov    (%eax),%edx
  8006b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b9:	8d 40 04             	lea    0x4(%eax),%eax
  8006bc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006bf:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8006c4:	e9 70 ff ff ff       	jmp    800639 <vprintfmt+0x38c>
			putch(ch, putdat);
  8006c9:	83 ec 08             	sub    $0x8,%esp
  8006cc:	53                   	push   %ebx
  8006cd:	6a 25                	push   $0x25
  8006cf:	ff d6                	call   *%esi
			break;
  8006d1:	83 c4 10             	add    $0x10,%esp
  8006d4:	e9 7a ff ff ff       	jmp    800653 <vprintfmt+0x3a6>
			putch('%', putdat);
  8006d9:	83 ec 08             	sub    $0x8,%esp
  8006dc:	53                   	push   %ebx
  8006dd:	6a 25                	push   $0x25
  8006df:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006e1:	83 c4 10             	add    $0x10,%esp
  8006e4:	89 f8                	mov    %edi,%eax
  8006e6:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006ea:	74 05                	je     8006f1 <vprintfmt+0x444>
  8006ec:	83 e8 01             	sub    $0x1,%eax
  8006ef:	eb f5                	jmp    8006e6 <vprintfmt+0x439>
  8006f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006f4:	e9 5a ff ff ff       	jmp    800653 <vprintfmt+0x3a6>
}
  8006f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006fc:	5b                   	pop    %ebx
  8006fd:	5e                   	pop    %esi
  8006fe:	5f                   	pop    %edi
  8006ff:	5d                   	pop    %ebp
  800700:	c3                   	ret    

00800701 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800701:	f3 0f 1e fb          	endbr32 
  800705:	55                   	push   %ebp
  800706:	89 e5                	mov    %esp,%ebp
  800708:	83 ec 18             	sub    $0x18,%esp
  80070b:	8b 45 08             	mov    0x8(%ebp),%eax
  80070e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800711:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800714:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800718:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80071b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800722:	85 c0                	test   %eax,%eax
  800724:	74 26                	je     80074c <vsnprintf+0x4b>
  800726:	85 d2                	test   %edx,%edx
  800728:	7e 22                	jle    80074c <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80072a:	ff 75 14             	pushl  0x14(%ebp)
  80072d:	ff 75 10             	pushl  0x10(%ebp)
  800730:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800733:	50                   	push   %eax
  800734:	68 6b 02 80 00       	push   $0x80026b
  800739:	e8 6f fb ff ff       	call   8002ad <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80073e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800741:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800744:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800747:	83 c4 10             	add    $0x10,%esp
}
  80074a:	c9                   	leave  
  80074b:	c3                   	ret    
		return -E_INVAL;
  80074c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800751:	eb f7                	jmp    80074a <vsnprintf+0x49>

00800753 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800753:	f3 0f 1e fb          	endbr32 
  800757:	55                   	push   %ebp
  800758:	89 e5                	mov    %esp,%ebp
  80075a:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80075d:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800760:	50                   	push   %eax
  800761:	ff 75 10             	pushl  0x10(%ebp)
  800764:	ff 75 0c             	pushl  0xc(%ebp)
  800767:	ff 75 08             	pushl  0x8(%ebp)
  80076a:	e8 92 ff ff ff       	call   800701 <vsnprintf>
	va_end(ap);

	return rc;
}
  80076f:	c9                   	leave  
  800770:	c3                   	ret    

00800771 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800771:	f3 0f 1e fb          	endbr32 
  800775:	55                   	push   %ebp
  800776:	89 e5                	mov    %esp,%ebp
  800778:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80077b:	b8 00 00 00 00       	mov    $0x0,%eax
  800780:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800784:	74 05                	je     80078b <strlen+0x1a>
		n++;
  800786:	83 c0 01             	add    $0x1,%eax
  800789:	eb f5                	jmp    800780 <strlen+0xf>
	return n;
}
  80078b:	5d                   	pop    %ebp
  80078c:	c3                   	ret    

0080078d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80078d:	f3 0f 1e fb          	endbr32 
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
  800794:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800797:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80079a:	b8 00 00 00 00       	mov    $0x0,%eax
  80079f:	39 d0                	cmp    %edx,%eax
  8007a1:	74 0d                	je     8007b0 <strnlen+0x23>
  8007a3:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007a7:	74 05                	je     8007ae <strnlen+0x21>
		n++;
  8007a9:	83 c0 01             	add    $0x1,%eax
  8007ac:	eb f1                	jmp    80079f <strnlen+0x12>
  8007ae:	89 c2                	mov    %eax,%edx
	return n;
}
  8007b0:	89 d0                	mov    %edx,%eax
  8007b2:	5d                   	pop    %ebp
  8007b3:	c3                   	ret    

008007b4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007b4:	f3 0f 1e fb          	endbr32 
  8007b8:	55                   	push   %ebp
  8007b9:	89 e5                	mov    %esp,%ebp
  8007bb:	53                   	push   %ebx
  8007bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c7:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8007cb:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8007ce:	83 c0 01             	add    $0x1,%eax
  8007d1:	84 d2                	test   %dl,%dl
  8007d3:	75 f2                	jne    8007c7 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8007d5:	89 c8                	mov    %ecx,%eax
  8007d7:	5b                   	pop    %ebx
  8007d8:	5d                   	pop    %ebp
  8007d9:	c3                   	ret    

008007da <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007da:	f3 0f 1e fb          	endbr32 
  8007de:	55                   	push   %ebp
  8007df:	89 e5                	mov    %esp,%ebp
  8007e1:	53                   	push   %ebx
  8007e2:	83 ec 10             	sub    $0x10,%esp
  8007e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007e8:	53                   	push   %ebx
  8007e9:	e8 83 ff ff ff       	call   800771 <strlen>
  8007ee:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8007f1:	ff 75 0c             	pushl  0xc(%ebp)
  8007f4:	01 d8                	add    %ebx,%eax
  8007f6:	50                   	push   %eax
  8007f7:	e8 b8 ff ff ff       	call   8007b4 <strcpy>
	return dst;
}
  8007fc:	89 d8                	mov    %ebx,%eax
  8007fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800801:	c9                   	leave  
  800802:	c3                   	ret    

00800803 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800803:	f3 0f 1e fb          	endbr32 
  800807:	55                   	push   %ebp
  800808:	89 e5                	mov    %esp,%ebp
  80080a:	56                   	push   %esi
  80080b:	53                   	push   %ebx
  80080c:	8b 75 08             	mov    0x8(%ebp),%esi
  80080f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800812:	89 f3                	mov    %esi,%ebx
  800814:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800817:	89 f0                	mov    %esi,%eax
  800819:	39 d8                	cmp    %ebx,%eax
  80081b:	74 11                	je     80082e <strncpy+0x2b>
		*dst++ = *src;
  80081d:	83 c0 01             	add    $0x1,%eax
  800820:	0f b6 0a             	movzbl (%edx),%ecx
  800823:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800826:	80 f9 01             	cmp    $0x1,%cl
  800829:	83 da ff             	sbb    $0xffffffff,%edx
  80082c:	eb eb                	jmp    800819 <strncpy+0x16>
	}
	return ret;
}
  80082e:	89 f0                	mov    %esi,%eax
  800830:	5b                   	pop    %ebx
  800831:	5e                   	pop    %esi
  800832:	5d                   	pop    %ebp
  800833:	c3                   	ret    

00800834 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800834:	f3 0f 1e fb          	endbr32 
  800838:	55                   	push   %ebp
  800839:	89 e5                	mov    %esp,%ebp
  80083b:	56                   	push   %esi
  80083c:	53                   	push   %ebx
  80083d:	8b 75 08             	mov    0x8(%ebp),%esi
  800840:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800843:	8b 55 10             	mov    0x10(%ebp),%edx
  800846:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800848:	85 d2                	test   %edx,%edx
  80084a:	74 21                	je     80086d <strlcpy+0x39>
  80084c:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800850:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800852:	39 c2                	cmp    %eax,%edx
  800854:	74 14                	je     80086a <strlcpy+0x36>
  800856:	0f b6 19             	movzbl (%ecx),%ebx
  800859:	84 db                	test   %bl,%bl
  80085b:	74 0b                	je     800868 <strlcpy+0x34>
			*dst++ = *src++;
  80085d:	83 c1 01             	add    $0x1,%ecx
  800860:	83 c2 01             	add    $0x1,%edx
  800863:	88 5a ff             	mov    %bl,-0x1(%edx)
  800866:	eb ea                	jmp    800852 <strlcpy+0x1e>
  800868:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80086a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80086d:	29 f0                	sub    %esi,%eax
}
  80086f:	5b                   	pop    %ebx
  800870:	5e                   	pop    %esi
  800871:	5d                   	pop    %ebp
  800872:	c3                   	ret    

00800873 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800873:	f3 0f 1e fb          	endbr32 
  800877:	55                   	push   %ebp
  800878:	89 e5                	mov    %esp,%ebp
  80087a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80087d:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800880:	0f b6 01             	movzbl (%ecx),%eax
  800883:	84 c0                	test   %al,%al
  800885:	74 0c                	je     800893 <strcmp+0x20>
  800887:	3a 02                	cmp    (%edx),%al
  800889:	75 08                	jne    800893 <strcmp+0x20>
		p++, q++;
  80088b:	83 c1 01             	add    $0x1,%ecx
  80088e:	83 c2 01             	add    $0x1,%edx
  800891:	eb ed                	jmp    800880 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800893:	0f b6 c0             	movzbl %al,%eax
  800896:	0f b6 12             	movzbl (%edx),%edx
  800899:	29 d0                	sub    %edx,%eax
}
  80089b:	5d                   	pop    %ebp
  80089c:	c3                   	ret    

0080089d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80089d:	f3 0f 1e fb          	endbr32 
  8008a1:	55                   	push   %ebp
  8008a2:	89 e5                	mov    %esp,%ebp
  8008a4:	53                   	push   %ebx
  8008a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ab:	89 c3                	mov    %eax,%ebx
  8008ad:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008b0:	eb 06                	jmp    8008b8 <strncmp+0x1b>
		n--, p++, q++;
  8008b2:	83 c0 01             	add    $0x1,%eax
  8008b5:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008b8:	39 d8                	cmp    %ebx,%eax
  8008ba:	74 16                	je     8008d2 <strncmp+0x35>
  8008bc:	0f b6 08             	movzbl (%eax),%ecx
  8008bf:	84 c9                	test   %cl,%cl
  8008c1:	74 04                	je     8008c7 <strncmp+0x2a>
  8008c3:	3a 0a                	cmp    (%edx),%cl
  8008c5:	74 eb                	je     8008b2 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008c7:	0f b6 00             	movzbl (%eax),%eax
  8008ca:	0f b6 12             	movzbl (%edx),%edx
  8008cd:	29 d0                	sub    %edx,%eax
}
  8008cf:	5b                   	pop    %ebx
  8008d0:	5d                   	pop    %ebp
  8008d1:	c3                   	ret    
		return 0;
  8008d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d7:	eb f6                	jmp    8008cf <strncmp+0x32>

008008d9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008d9:	f3 0f 1e fb          	endbr32 
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008e7:	0f b6 10             	movzbl (%eax),%edx
  8008ea:	84 d2                	test   %dl,%dl
  8008ec:	74 09                	je     8008f7 <strchr+0x1e>
		if (*s == c)
  8008ee:	38 ca                	cmp    %cl,%dl
  8008f0:	74 0a                	je     8008fc <strchr+0x23>
	for (; *s; s++)
  8008f2:	83 c0 01             	add    $0x1,%eax
  8008f5:	eb f0                	jmp    8008e7 <strchr+0xe>
			return (char *) s;
	return 0;
  8008f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008fc:	5d                   	pop    %ebp
  8008fd:	c3                   	ret    

008008fe <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008fe:	f3 0f 1e fb          	endbr32 
  800902:	55                   	push   %ebp
  800903:	89 e5                	mov    %esp,%ebp
  800905:	8b 45 08             	mov    0x8(%ebp),%eax
  800908:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80090c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80090f:	38 ca                	cmp    %cl,%dl
  800911:	74 09                	je     80091c <strfind+0x1e>
  800913:	84 d2                	test   %dl,%dl
  800915:	74 05                	je     80091c <strfind+0x1e>
	for (; *s; s++)
  800917:	83 c0 01             	add    $0x1,%eax
  80091a:	eb f0                	jmp    80090c <strfind+0xe>
			break;
	return (char *) s;
}
  80091c:	5d                   	pop    %ebp
  80091d:	c3                   	ret    

0080091e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80091e:	f3 0f 1e fb          	endbr32 
  800922:	55                   	push   %ebp
  800923:	89 e5                	mov    %esp,%ebp
  800925:	57                   	push   %edi
  800926:	56                   	push   %esi
  800927:	53                   	push   %ebx
  800928:	8b 7d 08             	mov    0x8(%ebp),%edi
  80092b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80092e:	85 c9                	test   %ecx,%ecx
  800930:	74 31                	je     800963 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800932:	89 f8                	mov    %edi,%eax
  800934:	09 c8                	or     %ecx,%eax
  800936:	a8 03                	test   $0x3,%al
  800938:	75 23                	jne    80095d <memset+0x3f>
		c &= 0xFF;
  80093a:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80093e:	89 d3                	mov    %edx,%ebx
  800940:	c1 e3 08             	shl    $0x8,%ebx
  800943:	89 d0                	mov    %edx,%eax
  800945:	c1 e0 18             	shl    $0x18,%eax
  800948:	89 d6                	mov    %edx,%esi
  80094a:	c1 e6 10             	shl    $0x10,%esi
  80094d:	09 f0                	or     %esi,%eax
  80094f:	09 c2                	or     %eax,%edx
  800951:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800953:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800956:	89 d0                	mov    %edx,%eax
  800958:	fc                   	cld    
  800959:	f3 ab                	rep stos %eax,%es:(%edi)
  80095b:	eb 06                	jmp    800963 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80095d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800960:	fc                   	cld    
  800961:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800963:	89 f8                	mov    %edi,%eax
  800965:	5b                   	pop    %ebx
  800966:	5e                   	pop    %esi
  800967:	5f                   	pop    %edi
  800968:	5d                   	pop    %ebp
  800969:	c3                   	ret    

0080096a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80096a:	f3 0f 1e fb          	endbr32 
  80096e:	55                   	push   %ebp
  80096f:	89 e5                	mov    %esp,%ebp
  800971:	57                   	push   %edi
  800972:	56                   	push   %esi
  800973:	8b 45 08             	mov    0x8(%ebp),%eax
  800976:	8b 75 0c             	mov    0xc(%ebp),%esi
  800979:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80097c:	39 c6                	cmp    %eax,%esi
  80097e:	73 32                	jae    8009b2 <memmove+0x48>
  800980:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800983:	39 c2                	cmp    %eax,%edx
  800985:	76 2b                	jbe    8009b2 <memmove+0x48>
		s += n;
		d += n;
  800987:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80098a:	89 fe                	mov    %edi,%esi
  80098c:	09 ce                	or     %ecx,%esi
  80098e:	09 d6                	or     %edx,%esi
  800990:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800996:	75 0e                	jne    8009a6 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800998:	83 ef 04             	sub    $0x4,%edi
  80099b:	8d 72 fc             	lea    -0x4(%edx),%esi
  80099e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009a1:	fd                   	std    
  8009a2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009a4:	eb 09                	jmp    8009af <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009a6:	83 ef 01             	sub    $0x1,%edi
  8009a9:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009ac:	fd                   	std    
  8009ad:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009af:	fc                   	cld    
  8009b0:	eb 1a                	jmp    8009cc <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009b2:	89 c2                	mov    %eax,%edx
  8009b4:	09 ca                	or     %ecx,%edx
  8009b6:	09 f2                	or     %esi,%edx
  8009b8:	f6 c2 03             	test   $0x3,%dl
  8009bb:	75 0a                	jne    8009c7 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009bd:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009c0:	89 c7                	mov    %eax,%edi
  8009c2:	fc                   	cld    
  8009c3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009c5:	eb 05                	jmp    8009cc <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8009c7:	89 c7                	mov    %eax,%edi
  8009c9:	fc                   	cld    
  8009ca:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009cc:	5e                   	pop    %esi
  8009cd:	5f                   	pop    %edi
  8009ce:	5d                   	pop    %ebp
  8009cf:	c3                   	ret    

008009d0 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009d0:	f3 0f 1e fb          	endbr32 
  8009d4:	55                   	push   %ebp
  8009d5:	89 e5                	mov    %esp,%ebp
  8009d7:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009da:	ff 75 10             	pushl  0x10(%ebp)
  8009dd:	ff 75 0c             	pushl  0xc(%ebp)
  8009e0:	ff 75 08             	pushl  0x8(%ebp)
  8009e3:	e8 82 ff ff ff       	call   80096a <memmove>
}
  8009e8:	c9                   	leave  
  8009e9:	c3                   	ret    

008009ea <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009ea:	f3 0f 1e fb          	endbr32 
  8009ee:	55                   	push   %ebp
  8009ef:	89 e5                	mov    %esp,%ebp
  8009f1:	56                   	push   %esi
  8009f2:	53                   	push   %ebx
  8009f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f9:	89 c6                	mov    %eax,%esi
  8009fb:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009fe:	39 f0                	cmp    %esi,%eax
  800a00:	74 1c                	je     800a1e <memcmp+0x34>
		if (*s1 != *s2)
  800a02:	0f b6 08             	movzbl (%eax),%ecx
  800a05:	0f b6 1a             	movzbl (%edx),%ebx
  800a08:	38 d9                	cmp    %bl,%cl
  800a0a:	75 08                	jne    800a14 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a0c:	83 c0 01             	add    $0x1,%eax
  800a0f:	83 c2 01             	add    $0x1,%edx
  800a12:	eb ea                	jmp    8009fe <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a14:	0f b6 c1             	movzbl %cl,%eax
  800a17:	0f b6 db             	movzbl %bl,%ebx
  800a1a:	29 d8                	sub    %ebx,%eax
  800a1c:	eb 05                	jmp    800a23 <memcmp+0x39>
	}

	return 0;
  800a1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a23:	5b                   	pop    %ebx
  800a24:	5e                   	pop    %esi
  800a25:	5d                   	pop    %ebp
  800a26:	c3                   	ret    

00800a27 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a27:	f3 0f 1e fb          	endbr32 
  800a2b:	55                   	push   %ebp
  800a2c:	89 e5                	mov    %esp,%ebp
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a34:	89 c2                	mov    %eax,%edx
  800a36:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a39:	39 d0                	cmp    %edx,%eax
  800a3b:	73 09                	jae    800a46 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a3d:	38 08                	cmp    %cl,(%eax)
  800a3f:	74 05                	je     800a46 <memfind+0x1f>
	for (; s < ends; s++)
  800a41:	83 c0 01             	add    $0x1,%eax
  800a44:	eb f3                	jmp    800a39 <memfind+0x12>
			break;
	return (void *) s;
}
  800a46:	5d                   	pop    %ebp
  800a47:	c3                   	ret    

00800a48 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a48:	f3 0f 1e fb          	endbr32 
  800a4c:	55                   	push   %ebp
  800a4d:	89 e5                	mov    %esp,%ebp
  800a4f:	57                   	push   %edi
  800a50:	56                   	push   %esi
  800a51:	53                   	push   %ebx
  800a52:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a55:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a58:	eb 03                	jmp    800a5d <strtol+0x15>
		s++;
  800a5a:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a5d:	0f b6 01             	movzbl (%ecx),%eax
  800a60:	3c 20                	cmp    $0x20,%al
  800a62:	74 f6                	je     800a5a <strtol+0x12>
  800a64:	3c 09                	cmp    $0x9,%al
  800a66:	74 f2                	je     800a5a <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a68:	3c 2b                	cmp    $0x2b,%al
  800a6a:	74 2a                	je     800a96 <strtol+0x4e>
	int neg = 0;
  800a6c:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a71:	3c 2d                	cmp    $0x2d,%al
  800a73:	74 2b                	je     800aa0 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a75:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a7b:	75 0f                	jne    800a8c <strtol+0x44>
  800a7d:	80 39 30             	cmpb   $0x30,(%ecx)
  800a80:	74 28                	je     800aaa <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a82:	85 db                	test   %ebx,%ebx
  800a84:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a89:	0f 44 d8             	cmove  %eax,%ebx
  800a8c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a91:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a94:	eb 46                	jmp    800adc <strtol+0x94>
		s++;
  800a96:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a99:	bf 00 00 00 00       	mov    $0x0,%edi
  800a9e:	eb d5                	jmp    800a75 <strtol+0x2d>
		s++, neg = 1;
  800aa0:	83 c1 01             	add    $0x1,%ecx
  800aa3:	bf 01 00 00 00       	mov    $0x1,%edi
  800aa8:	eb cb                	jmp    800a75 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800aaa:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800aae:	74 0e                	je     800abe <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800ab0:	85 db                	test   %ebx,%ebx
  800ab2:	75 d8                	jne    800a8c <strtol+0x44>
		s++, base = 8;
  800ab4:	83 c1 01             	add    $0x1,%ecx
  800ab7:	bb 08 00 00 00       	mov    $0x8,%ebx
  800abc:	eb ce                	jmp    800a8c <strtol+0x44>
		s += 2, base = 16;
  800abe:	83 c1 02             	add    $0x2,%ecx
  800ac1:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ac6:	eb c4                	jmp    800a8c <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800ac8:	0f be d2             	movsbl %dl,%edx
  800acb:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ace:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ad1:	7d 3a                	jge    800b0d <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ad3:	83 c1 01             	add    $0x1,%ecx
  800ad6:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ada:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800adc:	0f b6 11             	movzbl (%ecx),%edx
  800adf:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ae2:	89 f3                	mov    %esi,%ebx
  800ae4:	80 fb 09             	cmp    $0x9,%bl
  800ae7:	76 df                	jbe    800ac8 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800ae9:	8d 72 9f             	lea    -0x61(%edx),%esi
  800aec:	89 f3                	mov    %esi,%ebx
  800aee:	80 fb 19             	cmp    $0x19,%bl
  800af1:	77 08                	ja     800afb <strtol+0xb3>
			dig = *s - 'a' + 10;
  800af3:	0f be d2             	movsbl %dl,%edx
  800af6:	83 ea 57             	sub    $0x57,%edx
  800af9:	eb d3                	jmp    800ace <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800afb:	8d 72 bf             	lea    -0x41(%edx),%esi
  800afe:	89 f3                	mov    %esi,%ebx
  800b00:	80 fb 19             	cmp    $0x19,%bl
  800b03:	77 08                	ja     800b0d <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b05:	0f be d2             	movsbl %dl,%edx
  800b08:	83 ea 37             	sub    $0x37,%edx
  800b0b:	eb c1                	jmp    800ace <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b0d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b11:	74 05                	je     800b18 <strtol+0xd0>
		*endptr = (char *) s;
  800b13:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b16:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b18:	89 c2                	mov    %eax,%edx
  800b1a:	f7 da                	neg    %edx
  800b1c:	85 ff                	test   %edi,%edi
  800b1e:	0f 45 c2             	cmovne %edx,%eax
}
  800b21:	5b                   	pop    %ebx
  800b22:	5e                   	pop    %esi
  800b23:	5f                   	pop    %edi
  800b24:	5d                   	pop    %ebp
  800b25:	c3                   	ret    

00800b26 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b26:	f3 0f 1e fb          	endbr32 
  800b2a:	55                   	push   %ebp
  800b2b:	89 e5                	mov    %esp,%ebp
  800b2d:	57                   	push   %edi
  800b2e:	56                   	push   %esi
  800b2f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b30:	b8 00 00 00 00       	mov    $0x0,%eax
  800b35:	8b 55 08             	mov    0x8(%ebp),%edx
  800b38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b3b:	89 c3                	mov    %eax,%ebx
  800b3d:	89 c7                	mov    %eax,%edi
  800b3f:	89 c6                	mov    %eax,%esi
  800b41:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b43:	5b                   	pop    %ebx
  800b44:	5e                   	pop    %esi
  800b45:	5f                   	pop    %edi
  800b46:	5d                   	pop    %ebp
  800b47:	c3                   	ret    

00800b48 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b48:	f3 0f 1e fb          	endbr32 
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	57                   	push   %edi
  800b50:	56                   	push   %esi
  800b51:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b52:	ba 00 00 00 00       	mov    $0x0,%edx
  800b57:	b8 01 00 00 00       	mov    $0x1,%eax
  800b5c:	89 d1                	mov    %edx,%ecx
  800b5e:	89 d3                	mov    %edx,%ebx
  800b60:	89 d7                	mov    %edx,%edi
  800b62:	89 d6                	mov    %edx,%esi
  800b64:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b66:	5b                   	pop    %ebx
  800b67:	5e                   	pop    %esi
  800b68:	5f                   	pop    %edi
  800b69:	5d                   	pop    %ebp
  800b6a:	c3                   	ret    

00800b6b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b6b:	f3 0f 1e fb          	endbr32 
  800b6f:	55                   	push   %ebp
  800b70:	89 e5                	mov    %esp,%ebp
  800b72:	57                   	push   %edi
  800b73:	56                   	push   %esi
  800b74:	53                   	push   %ebx
  800b75:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b78:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b80:	b8 03 00 00 00       	mov    $0x3,%eax
  800b85:	89 cb                	mov    %ecx,%ebx
  800b87:	89 cf                	mov    %ecx,%edi
  800b89:	89 ce                	mov    %ecx,%esi
  800b8b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b8d:	85 c0                	test   %eax,%eax
  800b8f:	7f 08                	jg     800b99 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b94:	5b                   	pop    %ebx
  800b95:	5e                   	pop    %esi
  800b96:	5f                   	pop    %edi
  800b97:	5d                   	pop    %ebp
  800b98:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b99:	83 ec 0c             	sub    $0xc,%esp
  800b9c:	50                   	push   %eax
  800b9d:	6a 03                	push   $0x3
  800b9f:	68 ff 27 80 00       	push   $0x8027ff
  800ba4:	6a 23                	push   $0x23
  800ba6:	68 1c 28 80 00       	push   $0x80281c
  800bab:	e8 22 16 00 00       	call   8021d2 <_panic>

00800bb0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bb0:	f3 0f 1e fb          	endbr32 
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	57                   	push   %edi
  800bb8:	56                   	push   %esi
  800bb9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bba:	ba 00 00 00 00       	mov    $0x0,%edx
  800bbf:	b8 02 00 00 00       	mov    $0x2,%eax
  800bc4:	89 d1                	mov    %edx,%ecx
  800bc6:	89 d3                	mov    %edx,%ebx
  800bc8:	89 d7                	mov    %edx,%edi
  800bca:	89 d6                	mov    %edx,%esi
  800bcc:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bce:	5b                   	pop    %ebx
  800bcf:	5e                   	pop    %esi
  800bd0:	5f                   	pop    %edi
  800bd1:	5d                   	pop    %ebp
  800bd2:	c3                   	ret    

00800bd3 <sys_yield>:

void
sys_yield(void)
{
  800bd3:	f3 0f 1e fb          	endbr32 
  800bd7:	55                   	push   %ebp
  800bd8:	89 e5                	mov    %esp,%ebp
  800bda:	57                   	push   %edi
  800bdb:	56                   	push   %esi
  800bdc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bdd:	ba 00 00 00 00       	mov    $0x0,%edx
  800be2:	b8 0b 00 00 00       	mov    $0xb,%eax
  800be7:	89 d1                	mov    %edx,%ecx
  800be9:	89 d3                	mov    %edx,%ebx
  800beb:	89 d7                	mov    %edx,%edi
  800bed:	89 d6                	mov    %edx,%esi
  800bef:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bf1:	5b                   	pop    %ebx
  800bf2:	5e                   	pop    %esi
  800bf3:	5f                   	pop    %edi
  800bf4:	5d                   	pop    %ebp
  800bf5:	c3                   	ret    

00800bf6 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bf6:	f3 0f 1e fb          	endbr32 
  800bfa:	55                   	push   %ebp
  800bfb:	89 e5                	mov    %esp,%ebp
  800bfd:	57                   	push   %edi
  800bfe:	56                   	push   %esi
  800bff:	53                   	push   %ebx
  800c00:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c03:	be 00 00 00 00       	mov    $0x0,%esi
  800c08:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c0e:	b8 04 00 00 00       	mov    $0x4,%eax
  800c13:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c16:	89 f7                	mov    %esi,%edi
  800c18:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c1a:	85 c0                	test   %eax,%eax
  800c1c:	7f 08                	jg     800c26 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c21:	5b                   	pop    %ebx
  800c22:	5e                   	pop    %esi
  800c23:	5f                   	pop    %edi
  800c24:	5d                   	pop    %ebp
  800c25:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c26:	83 ec 0c             	sub    $0xc,%esp
  800c29:	50                   	push   %eax
  800c2a:	6a 04                	push   $0x4
  800c2c:	68 ff 27 80 00       	push   $0x8027ff
  800c31:	6a 23                	push   $0x23
  800c33:	68 1c 28 80 00       	push   $0x80281c
  800c38:	e8 95 15 00 00       	call   8021d2 <_panic>

00800c3d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c3d:	f3 0f 1e fb          	endbr32 
  800c41:	55                   	push   %ebp
  800c42:	89 e5                	mov    %esp,%ebp
  800c44:	57                   	push   %edi
  800c45:	56                   	push   %esi
  800c46:	53                   	push   %ebx
  800c47:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c50:	b8 05 00 00 00       	mov    $0x5,%eax
  800c55:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c58:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c5b:	8b 75 18             	mov    0x18(%ebp),%esi
  800c5e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c60:	85 c0                	test   %eax,%eax
  800c62:	7f 08                	jg     800c6c <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c67:	5b                   	pop    %ebx
  800c68:	5e                   	pop    %esi
  800c69:	5f                   	pop    %edi
  800c6a:	5d                   	pop    %ebp
  800c6b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c6c:	83 ec 0c             	sub    $0xc,%esp
  800c6f:	50                   	push   %eax
  800c70:	6a 05                	push   $0x5
  800c72:	68 ff 27 80 00       	push   $0x8027ff
  800c77:	6a 23                	push   $0x23
  800c79:	68 1c 28 80 00       	push   $0x80281c
  800c7e:	e8 4f 15 00 00       	call   8021d2 <_panic>

00800c83 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c83:	f3 0f 1e fb          	endbr32 
  800c87:	55                   	push   %ebp
  800c88:	89 e5                	mov    %esp,%ebp
  800c8a:	57                   	push   %edi
  800c8b:	56                   	push   %esi
  800c8c:	53                   	push   %ebx
  800c8d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c90:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c95:	8b 55 08             	mov    0x8(%ebp),%edx
  800c98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9b:	b8 06 00 00 00       	mov    $0x6,%eax
  800ca0:	89 df                	mov    %ebx,%edi
  800ca2:	89 de                	mov    %ebx,%esi
  800ca4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ca6:	85 c0                	test   %eax,%eax
  800ca8:	7f 08                	jg     800cb2 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800caa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cad:	5b                   	pop    %ebx
  800cae:	5e                   	pop    %esi
  800caf:	5f                   	pop    %edi
  800cb0:	5d                   	pop    %ebp
  800cb1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb2:	83 ec 0c             	sub    $0xc,%esp
  800cb5:	50                   	push   %eax
  800cb6:	6a 06                	push   $0x6
  800cb8:	68 ff 27 80 00       	push   $0x8027ff
  800cbd:	6a 23                	push   $0x23
  800cbf:	68 1c 28 80 00       	push   $0x80281c
  800cc4:	e8 09 15 00 00       	call   8021d2 <_panic>

00800cc9 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cc9:	f3 0f 1e fb          	endbr32 
  800ccd:	55                   	push   %ebp
  800cce:	89 e5                	mov    %esp,%ebp
  800cd0:	57                   	push   %edi
  800cd1:	56                   	push   %esi
  800cd2:	53                   	push   %ebx
  800cd3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cd6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cdb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce1:	b8 08 00 00 00       	mov    $0x8,%eax
  800ce6:	89 df                	mov    %ebx,%edi
  800ce8:	89 de                	mov    %ebx,%esi
  800cea:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cec:	85 c0                	test   %eax,%eax
  800cee:	7f 08                	jg     800cf8 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf3:	5b                   	pop    %ebx
  800cf4:	5e                   	pop    %esi
  800cf5:	5f                   	pop    %edi
  800cf6:	5d                   	pop    %ebp
  800cf7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf8:	83 ec 0c             	sub    $0xc,%esp
  800cfb:	50                   	push   %eax
  800cfc:	6a 08                	push   $0x8
  800cfe:	68 ff 27 80 00       	push   $0x8027ff
  800d03:	6a 23                	push   $0x23
  800d05:	68 1c 28 80 00       	push   $0x80281c
  800d0a:	e8 c3 14 00 00       	call   8021d2 <_panic>

00800d0f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d0f:	f3 0f 1e fb          	endbr32 
  800d13:	55                   	push   %ebp
  800d14:	89 e5                	mov    %esp,%ebp
  800d16:	57                   	push   %edi
  800d17:	56                   	push   %esi
  800d18:	53                   	push   %ebx
  800d19:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d1c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d21:	8b 55 08             	mov    0x8(%ebp),%edx
  800d24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d27:	b8 09 00 00 00       	mov    $0x9,%eax
  800d2c:	89 df                	mov    %ebx,%edi
  800d2e:	89 de                	mov    %ebx,%esi
  800d30:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d32:	85 c0                	test   %eax,%eax
  800d34:	7f 08                	jg     800d3e <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d36:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d39:	5b                   	pop    %ebx
  800d3a:	5e                   	pop    %esi
  800d3b:	5f                   	pop    %edi
  800d3c:	5d                   	pop    %ebp
  800d3d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3e:	83 ec 0c             	sub    $0xc,%esp
  800d41:	50                   	push   %eax
  800d42:	6a 09                	push   $0x9
  800d44:	68 ff 27 80 00       	push   $0x8027ff
  800d49:	6a 23                	push   $0x23
  800d4b:	68 1c 28 80 00       	push   $0x80281c
  800d50:	e8 7d 14 00 00       	call   8021d2 <_panic>

00800d55 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d55:	f3 0f 1e fb          	endbr32 
  800d59:	55                   	push   %ebp
  800d5a:	89 e5                	mov    %esp,%ebp
  800d5c:	57                   	push   %edi
  800d5d:	56                   	push   %esi
  800d5e:	53                   	push   %ebx
  800d5f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d62:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d67:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d72:	89 df                	mov    %ebx,%edi
  800d74:	89 de                	mov    %ebx,%esi
  800d76:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d78:	85 c0                	test   %eax,%eax
  800d7a:	7f 08                	jg     800d84 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7f:	5b                   	pop    %ebx
  800d80:	5e                   	pop    %esi
  800d81:	5f                   	pop    %edi
  800d82:	5d                   	pop    %ebp
  800d83:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d84:	83 ec 0c             	sub    $0xc,%esp
  800d87:	50                   	push   %eax
  800d88:	6a 0a                	push   $0xa
  800d8a:	68 ff 27 80 00       	push   $0x8027ff
  800d8f:	6a 23                	push   $0x23
  800d91:	68 1c 28 80 00       	push   $0x80281c
  800d96:	e8 37 14 00 00       	call   8021d2 <_panic>

00800d9b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d9b:	f3 0f 1e fb          	endbr32 
  800d9f:	55                   	push   %ebp
  800da0:	89 e5                	mov    %esp,%ebp
  800da2:	57                   	push   %edi
  800da3:	56                   	push   %esi
  800da4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800da5:	8b 55 08             	mov    0x8(%ebp),%edx
  800da8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dab:	b8 0c 00 00 00       	mov    $0xc,%eax
  800db0:	be 00 00 00 00       	mov    $0x0,%esi
  800db5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800db8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dbb:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800dbd:	5b                   	pop    %ebx
  800dbe:	5e                   	pop    %esi
  800dbf:	5f                   	pop    %edi
  800dc0:	5d                   	pop    %ebp
  800dc1:	c3                   	ret    

00800dc2 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dc2:	f3 0f 1e fb          	endbr32 
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	57                   	push   %edi
  800dca:	56                   	push   %esi
  800dcb:	53                   	push   %ebx
  800dcc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dcf:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ddc:	89 cb                	mov    %ecx,%ebx
  800dde:	89 cf                	mov    %ecx,%edi
  800de0:	89 ce                	mov    %ecx,%esi
  800de2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de4:	85 c0                	test   %eax,%eax
  800de6:	7f 08                	jg     800df0 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800de8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800deb:	5b                   	pop    %ebx
  800dec:	5e                   	pop    %esi
  800ded:	5f                   	pop    %edi
  800dee:	5d                   	pop    %ebp
  800def:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df0:	83 ec 0c             	sub    $0xc,%esp
  800df3:	50                   	push   %eax
  800df4:	6a 0d                	push   $0xd
  800df6:	68 ff 27 80 00       	push   $0x8027ff
  800dfb:	6a 23                	push   $0x23
  800dfd:	68 1c 28 80 00       	push   $0x80281c
  800e02:	e8 cb 13 00 00       	call   8021d2 <_panic>

00800e07 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e07:	f3 0f 1e fb          	endbr32 
  800e0b:	55                   	push   %ebp
  800e0c:	89 e5                	mov    %esp,%ebp
  800e0e:	57                   	push   %edi
  800e0f:	56                   	push   %esi
  800e10:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e11:	ba 00 00 00 00       	mov    $0x0,%edx
  800e16:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e1b:	89 d1                	mov    %edx,%ecx
  800e1d:	89 d3                	mov    %edx,%ebx
  800e1f:	89 d7                	mov    %edx,%edi
  800e21:	89 d6                	mov    %edx,%esi
  800e23:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e25:	5b                   	pop    %ebx
  800e26:	5e                   	pop    %esi
  800e27:	5f                   	pop    %edi
  800e28:	5d                   	pop    %ebp
  800e29:	c3                   	ret    

00800e2a <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  800e2a:	f3 0f 1e fb          	endbr32 
  800e2e:	55                   	push   %ebp
  800e2f:	89 e5                	mov    %esp,%ebp
  800e31:	57                   	push   %edi
  800e32:	56                   	push   %esi
  800e33:	53                   	push   %ebx
  800e34:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e37:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e42:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e47:	89 df                	mov    %ebx,%edi
  800e49:	89 de                	mov    %ebx,%esi
  800e4b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e4d:	85 c0                	test   %eax,%eax
  800e4f:	7f 08                	jg     800e59 <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  800e51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e54:	5b                   	pop    %ebx
  800e55:	5e                   	pop    %esi
  800e56:	5f                   	pop    %edi
  800e57:	5d                   	pop    %ebp
  800e58:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e59:	83 ec 0c             	sub    $0xc,%esp
  800e5c:	50                   	push   %eax
  800e5d:	6a 0f                	push   $0xf
  800e5f:	68 ff 27 80 00       	push   $0x8027ff
  800e64:	6a 23                	push   $0x23
  800e66:	68 1c 28 80 00       	push   $0x80281c
  800e6b:	e8 62 13 00 00       	call   8021d2 <_panic>

00800e70 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  800e70:	f3 0f 1e fb          	endbr32 
  800e74:	55                   	push   %ebp
  800e75:	89 e5                	mov    %esp,%ebp
  800e77:	57                   	push   %edi
  800e78:	56                   	push   %esi
  800e79:	53                   	push   %ebx
  800e7a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e7d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e82:	8b 55 08             	mov    0x8(%ebp),%edx
  800e85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e88:	b8 10 00 00 00       	mov    $0x10,%eax
  800e8d:	89 df                	mov    %ebx,%edi
  800e8f:	89 de                	mov    %ebx,%esi
  800e91:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e93:	85 c0                	test   %eax,%eax
  800e95:	7f 08                	jg     800e9f <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  800e97:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e9a:	5b                   	pop    %ebx
  800e9b:	5e                   	pop    %esi
  800e9c:	5f                   	pop    %edi
  800e9d:	5d                   	pop    %ebp
  800e9e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9f:	83 ec 0c             	sub    $0xc,%esp
  800ea2:	50                   	push   %eax
  800ea3:	6a 10                	push   $0x10
  800ea5:	68 ff 27 80 00       	push   $0x8027ff
  800eaa:	6a 23                	push   $0x23
  800eac:	68 1c 28 80 00       	push   $0x80281c
  800eb1:	e8 1c 13 00 00       	call   8021d2 <_panic>

00800eb6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  800eb6:	f3 0f 1e fb          	endbr32 
  800eba:	55                   	push   %ebp
  800ebb:	89 e5                	mov    %esp,%ebp
  800ebd:	56                   	push   %esi
  800ebe:	53                   	push   %ebx
  800ebf:	8b 75 08             	mov    0x8(%ebp),%esi
  800ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  800ec8:	85 c0                	test   %eax,%eax
  800eca:	74 3d                	je     800f09 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  800ecc:	83 ec 0c             	sub    $0xc,%esp
  800ecf:	50                   	push   %eax
  800ed0:	e8 ed fe ff ff       	call   800dc2 <sys_ipc_recv>
  800ed5:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  800ed8:	85 f6                	test   %esi,%esi
  800eda:	74 0b                	je     800ee7 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  800edc:	8b 15 08 40 80 00    	mov    0x804008,%edx
  800ee2:	8b 52 74             	mov    0x74(%edx),%edx
  800ee5:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  800ee7:	85 db                	test   %ebx,%ebx
  800ee9:	74 0b                	je     800ef6 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  800eeb:	8b 15 08 40 80 00    	mov    0x804008,%edx
  800ef1:	8b 52 78             	mov    0x78(%edx),%edx
  800ef4:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  800ef6:	85 c0                	test   %eax,%eax
  800ef8:	78 21                	js     800f1b <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  800efa:	a1 08 40 80 00       	mov    0x804008,%eax
  800eff:	8b 40 70             	mov    0x70(%eax),%eax
}
  800f02:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f05:	5b                   	pop    %ebx
  800f06:	5e                   	pop    %esi
  800f07:	5d                   	pop    %ebp
  800f08:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  800f09:	83 ec 0c             	sub    $0xc,%esp
  800f0c:	68 00 00 c0 ee       	push   $0xeec00000
  800f11:	e8 ac fe ff ff       	call   800dc2 <sys_ipc_recv>
  800f16:	83 c4 10             	add    $0x10,%esp
  800f19:	eb bd                	jmp    800ed8 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  800f1b:	85 f6                	test   %esi,%esi
  800f1d:	74 10                	je     800f2f <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  800f1f:	85 db                	test   %ebx,%ebx
  800f21:	75 df                	jne    800f02 <ipc_recv+0x4c>
  800f23:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  800f2a:	00 00 00 
  800f2d:	eb d3                	jmp    800f02 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  800f2f:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  800f36:	00 00 00 
  800f39:	eb e4                	jmp    800f1f <ipc_recv+0x69>

00800f3b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  800f3b:	f3 0f 1e fb          	endbr32 
  800f3f:	55                   	push   %ebp
  800f40:	89 e5                	mov    %esp,%ebp
  800f42:	57                   	push   %edi
  800f43:	56                   	push   %esi
  800f44:	53                   	push   %ebx
  800f45:	83 ec 0c             	sub    $0xc,%esp
  800f48:	8b 7d 08             	mov    0x8(%ebp),%edi
  800f4b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f4e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  800f51:	85 db                	test   %ebx,%ebx
  800f53:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  800f58:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  800f5b:	ff 75 14             	pushl  0x14(%ebp)
  800f5e:	53                   	push   %ebx
  800f5f:	56                   	push   %esi
  800f60:	57                   	push   %edi
  800f61:	e8 35 fe ff ff       	call   800d9b <sys_ipc_try_send>
  800f66:	83 c4 10             	add    $0x10,%esp
  800f69:	85 c0                	test   %eax,%eax
  800f6b:	79 1e                	jns    800f8b <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  800f6d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  800f70:	75 07                	jne    800f79 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  800f72:	e8 5c fc ff ff       	call   800bd3 <sys_yield>
  800f77:	eb e2                	jmp    800f5b <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  800f79:	50                   	push   %eax
  800f7a:	68 2a 28 80 00       	push   $0x80282a
  800f7f:	6a 59                	push   $0x59
  800f81:	68 45 28 80 00       	push   $0x802845
  800f86:	e8 47 12 00 00       	call   8021d2 <_panic>
	}
}
  800f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f8e:	5b                   	pop    %ebx
  800f8f:	5e                   	pop    %esi
  800f90:	5f                   	pop    %edi
  800f91:	5d                   	pop    %ebp
  800f92:	c3                   	ret    

00800f93 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  800f93:	f3 0f 1e fb          	endbr32 
  800f97:	55                   	push   %ebp
  800f98:	89 e5                	mov    %esp,%ebp
  800f9a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  800f9d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  800fa2:	6b d0 7c             	imul   $0x7c,%eax,%edx
  800fa5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800fab:	8b 52 50             	mov    0x50(%edx),%edx
  800fae:	39 ca                	cmp    %ecx,%edx
  800fb0:	74 11                	je     800fc3 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  800fb2:	83 c0 01             	add    $0x1,%eax
  800fb5:	3d 00 04 00 00       	cmp    $0x400,%eax
  800fba:	75 e6                	jne    800fa2 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  800fbc:	b8 00 00 00 00       	mov    $0x0,%eax
  800fc1:	eb 0b                	jmp    800fce <ipc_find_env+0x3b>
			return envs[i].env_id;
  800fc3:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800fc6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800fcb:	8b 40 48             	mov    0x48(%eax),%eax
}
  800fce:	5d                   	pop    %ebp
  800fcf:	c3                   	ret    

00800fd0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fd0:	f3 0f 1e fb          	endbr32 
  800fd4:	55                   	push   %ebp
  800fd5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	05 00 00 00 30       	add    $0x30000000,%eax
  800fdf:	c1 e8 0c             	shr    $0xc,%eax
}
  800fe2:	5d                   	pop    %ebp
  800fe3:	c3                   	ret    

00800fe4 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fe4:	f3 0f 1e fb          	endbr32 
  800fe8:	55                   	push   %ebp
  800fe9:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800ff3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ff8:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800ffd:	5d                   	pop    %ebp
  800ffe:	c3                   	ret    

00800fff <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800fff:	f3 0f 1e fb          	endbr32 
  801003:	55                   	push   %ebp
  801004:	89 e5                	mov    %esp,%ebp
  801006:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80100b:	89 c2                	mov    %eax,%edx
  80100d:	c1 ea 16             	shr    $0x16,%edx
  801010:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801017:	f6 c2 01             	test   $0x1,%dl
  80101a:	74 2d                	je     801049 <fd_alloc+0x4a>
  80101c:	89 c2                	mov    %eax,%edx
  80101e:	c1 ea 0c             	shr    $0xc,%edx
  801021:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801028:	f6 c2 01             	test   $0x1,%dl
  80102b:	74 1c                	je     801049 <fd_alloc+0x4a>
  80102d:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801032:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801037:	75 d2                	jne    80100b <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801042:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801047:	eb 0a                	jmp    801053 <fd_alloc+0x54>
			*fd_store = fd;
  801049:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80104c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80104e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801053:	5d                   	pop    %ebp
  801054:	c3                   	ret    

00801055 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801055:	f3 0f 1e fb          	endbr32 
  801059:	55                   	push   %ebp
  80105a:	89 e5                	mov    %esp,%ebp
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80105f:	83 f8 1f             	cmp    $0x1f,%eax
  801062:	77 30                	ja     801094 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801064:	c1 e0 0c             	shl    $0xc,%eax
  801067:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80106c:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801072:	f6 c2 01             	test   $0x1,%dl
  801075:	74 24                	je     80109b <fd_lookup+0x46>
  801077:	89 c2                	mov    %eax,%edx
  801079:	c1 ea 0c             	shr    $0xc,%edx
  80107c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801083:	f6 c2 01             	test   $0x1,%dl
  801086:	74 1a                	je     8010a2 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801088:	8b 55 0c             	mov    0xc(%ebp),%edx
  80108b:	89 02                	mov    %eax,(%edx)
	return 0;
  80108d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801092:	5d                   	pop    %ebp
  801093:	c3                   	ret    
		return -E_INVAL;
  801094:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801099:	eb f7                	jmp    801092 <fd_lookup+0x3d>
		return -E_INVAL;
  80109b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010a0:	eb f0                	jmp    801092 <fd_lookup+0x3d>
  8010a2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010a7:	eb e9                	jmp    801092 <fd_lookup+0x3d>

008010a9 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010a9:	f3 0f 1e fb          	endbr32 
  8010ad:	55                   	push   %ebp
  8010ae:	89 e5                	mov    %esp,%ebp
  8010b0:	83 ec 08             	sub    $0x8,%esp
  8010b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8010b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8010bb:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8010c0:	39 08                	cmp    %ecx,(%eax)
  8010c2:	74 38                	je     8010fc <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  8010c4:	83 c2 01             	add    $0x1,%edx
  8010c7:	8b 04 95 cc 28 80 00 	mov    0x8028cc(,%edx,4),%eax
  8010ce:	85 c0                	test   %eax,%eax
  8010d0:	75 ee                	jne    8010c0 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010d2:	a1 08 40 80 00       	mov    0x804008,%eax
  8010d7:	8b 40 48             	mov    0x48(%eax),%eax
  8010da:	83 ec 04             	sub    $0x4,%esp
  8010dd:	51                   	push   %ecx
  8010de:	50                   	push   %eax
  8010df:	68 50 28 80 00       	push   $0x802850
  8010e4:	e8 c1 f0 ff ff       	call   8001aa <cprintf>
	*dev = 0;
  8010e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010f2:	83 c4 10             	add    $0x10,%esp
  8010f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010fa:	c9                   	leave  
  8010fb:	c3                   	ret    
			*dev = devtab[i];
  8010fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ff:	89 01                	mov    %eax,(%ecx)
			return 0;
  801101:	b8 00 00 00 00       	mov    $0x0,%eax
  801106:	eb f2                	jmp    8010fa <dev_lookup+0x51>

00801108 <fd_close>:
{
  801108:	f3 0f 1e fb          	endbr32 
  80110c:	55                   	push   %ebp
  80110d:	89 e5                	mov    %esp,%ebp
  80110f:	57                   	push   %edi
  801110:	56                   	push   %esi
  801111:	53                   	push   %ebx
  801112:	83 ec 24             	sub    $0x24,%esp
  801115:	8b 75 08             	mov    0x8(%ebp),%esi
  801118:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80111b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80111e:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80111f:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801125:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801128:	50                   	push   %eax
  801129:	e8 27 ff ff ff       	call   801055 <fd_lookup>
  80112e:	89 c3                	mov    %eax,%ebx
  801130:	83 c4 10             	add    $0x10,%esp
  801133:	85 c0                	test   %eax,%eax
  801135:	78 05                	js     80113c <fd_close+0x34>
	    || fd != fd2)
  801137:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80113a:	74 16                	je     801152 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80113c:	89 f8                	mov    %edi,%eax
  80113e:	84 c0                	test   %al,%al
  801140:	b8 00 00 00 00       	mov    $0x0,%eax
  801145:	0f 44 d8             	cmove  %eax,%ebx
}
  801148:	89 d8                	mov    %ebx,%eax
  80114a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80114d:	5b                   	pop    %ebx
  80114e:	5e                   	pop    %esi
  80114f:	5f                   	pop    %edi
  801150:	5d                   	pop    %ebp
  801151:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801152:	83 ec 08             	sub    $0x8,%esp
  801155:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801158:	50                   	push   %eax
  801159:	ff 36                	pushl  (%esi)
  80115b:	e8 49 ff ff ff       	call   8010a9 <dev_lookup>
  801160:	89 c3                	mov    %eax,%ebx
  801162:	83 c4 10             	add    $0x10,%esp
  801165:	85 c0                	test   %eax,%eax
  801167:	78 1a                	js     801183 <fd_close+0x7b>
		if (dev->dev_close)
  801169:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80116c:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80116f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801174:	85 c0                	test   %eax,%eax
  801176:	74 0b                	je     801183 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801178:	83 ec 0c             	sub    $0xc,%esp
  80117b:	56                   	push   %esi
  80117c:	ff d0                	call   *%eax
  80117e:	89 c3                	mov    %eax,%ebx
  801180:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801183:	83 ec 08             	sub    $0x8,%esp
  801186:	56                   	push   %esi
  801187:	6a 00                	push   $0x0
  801189:	e8 f5 fa ff ff       	call   800c83 <sys_page_unmap>
	return r;
  80118e:	83 c4 10             	add    $0x10,%esp
  801191:	eb b5                	jmp    801148 <fd_close+0x40>

00801193 <close>:

int
close(int fdnum)
{
  801193:	f3 0f 1e fb          	endbr32 
  801197:	55                   	push   %ebp
  801198:	89 e5                	mov    %esp,%ebp
  80119a:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80119d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011a0:	50                   	push   %eax
  8011a1:	ff 75 08             	pushl  0x8(%ebp)
  8011a4:	e8 ac fe ff ff       	call   801055 <fd_lookup>
  8011a9:	83 c4 10             	add    $0x10,%esp
  8011ac:	85 c0                	test   %eax,%eax
  8011ae:	79 02                	jns    8011b2 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8011b0:	c9                   	leave  
  8011b1:	c3                   	ret    
		return fd_close(fd, 1);
  8011b2:	83 ec 08             	sub    $0x8,%esp
  8011b5:	6a 01                	push   $0x1
  8011b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8011ba:	e8 49 ff ff ff       	call   801108 <fd_close>
  8011bf:	83 c4 10             	add    $0x10,%esp
  8011c2:	eb ec                	jmp    8011b0 <close+0x1d>

008011c4 <close_all>:

void
close_all(void)
{
  8011c4:	f3 0f 1e fb          	endbr32 
  8011c8:	55                   	push   %ebp
  8011c9:	89 e5                	mov    %esp,%ebp
  8011cb:	53                   	push   %ebx
  8011cc:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011cf:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011d4:	83 ec 0c             	sub    $0xc,%esp
  8011d7:	53                   	push   %ebx
  8011d8:	e8 b6 ff ff ff       	call   801193 <close>
	for (i = 0; i < MAXFD; i++)
  8011dd:	83 c3 01             	add    $0x1,%ebx
  8011e0:	83 c4 10             	add    $0x10,%esp
  8011e3:	83 fb 20             	cmp    $0x20,%ebx
  8011e6:	75 ec                	jne    8011d4 <close_all+0x10>
}
  8011e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011eb:	c9                   	leave  
  8011ec:	c3                   	ret    

008011ed <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011ed:	f3 0f 1e fb          	endbr32 
  8011f1:	55                   	push   %ebp
  8011f2:	89 e5                	mov    %esp,%ebp
  8011f4:	57                   	push   %edi
  8011f5:	56                   	push   %esi
  8011f6:	53                   	push   %ebx
  8011f7:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011fa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011fd:	50                   	push   %eax
  8011fe:	ff 75 08             	pushl  0x8(%ebp)
  801201:	e8 4f fe ff ff       	call   801055 <fd_lookup>
  801206:	89 c3                	mov    %eax,%ebx
  801208:	83 c4 10             	add    $0x10,%esp
  80120b:	85 c0                	test   %eax,%eax
  80120d:	0f 88 81 00 00 00    	js     801294 <dup+0xa7>
		return r;
	close(newfdnum);
  801213:	83 ec 0c             	sub    $0xc,%esp
  801216:	ff 75 0c             	pushl  0xc(%ebp)
  801219:	e8 75 ff ff ff       	call   801193 <close>

	newfd = INDEX2FD(newfdnum);
  80121e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801221:	c1 e6 0c             	shl    $0xc,%esi
  801224:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80122a:	83 c4 04             	add    $0x4,%esp
  80122d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801230:	e8 af fd ff ff       	call   800fe4 <fd2data>
  801235:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801237:	89 34 24             	mov    %esi,(%esp)
  80123a:	e8 a5 fd ff ff       	call   800fe4 <fd2data>
  80123f:	83 c4 10             	add    $0x10,%esp
  801242:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801244:	89 d8                	mov    %ebx,%eax
  801246:	c1 e8 16             	shr    $0x16,%eax
  801249:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801250:	a8 01                	test   $0x1,%al
  801252:	74 11                	je     801265 <dup+0x78>
  801254:	89 d8                	mov    %ebx,%eax
  801256:	c1 e8 0c             	shr    $0xc,%eax
  801259:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801260:	f6 c2 01             	test   $0x1,%dl
  801263:	75 39                	jne    80129e <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801265:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801268:	89 d0                	mov    %edx,%eax
  80126a:	c1 e8 0c             	shr    $0xc,%eax
  80126d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801274:	83 ec 0c             	sub    $0xc,%esp
  801277:	25 07 0e 00 00       	and    $0xe07,%eax
  80127c:	50                   	push   %eax
  80127d:	56                   	push   %esi
  80127e:	6a 00                	push   $0x0
  801280:	52                   	push   %edx
  801281:	6a 00                	push   $0x0
  801283:	e8 b5 f9 ff ff       	call   800c3d <sys_page_map>
  801288:	89 c3                	mov    %eax,%ebx
  80128a:	83 c4 20             	add    $0x20,%esp
  80128d:	85 c0                	test   %eax,%eax
  80128f:	78 31                	js     8012c2 <dup+0xd5>
		goto err;

	return newfdnum;
  801291:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801294:	89 d8                	mov    %ebx,%eax
  801296:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801299:	5b                   	pop    %ebx
  80129a:	5e                   	pop    %esi
  80129b:	5f                   	pop    %edi
  80129c:	5d                   	pop    %ebp
  80129d:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80129e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012a5:	83 ec 0c             	sub    $0xc,%esp
  8012a8:	25 07 0e 00 00       	and    $0xe07,%eax
  8012ad:	50                   	push   %eax
  8012ae:	57                   	push   %edi
  8012af:	6a 00                	push   $0x0
  8012b1:	53                   	push   %ebx
  8012b2:	6a 00                	push   $0x0
  8012b4:	e8 84 f9 ff ff       	call   800c3d <sys_page_map>
  8012b9:	89 c3                	mov    %eax,%ebx
  8012bb:	83 c4 20             	add    $0x20,%esp
  8012be:	85 c0                	test   %eax,%eax
  8012c0:	79 a3                	jns    801265 <dup+0x78>
	sys_page_unmap(0, newfd);
  8012c2:	83 ec 08             	sub    $0x8,%esp
  8012c5:	56                   	push   %esi
  8012c6:	6a 00                	push   $0x0
  8012c8:	e8 b6 f9 ff ff       	call   800c83 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012cd:	83 c4 08             	add    $0x8,%esp
  8012d0:	57                   	push   %edi
  8012d1:	6a 00                	push   $0x0
  8012d3:	e8 ab f9 ff ff       	call   800c83 <sys_page_unmap>
	return r;
  8012d8:	83 c4 10             	add    $0x10,%esp
  8012db:	eb b7                	jmp    801294 <dup+0xa7>

008012dd <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012dd:	f3 0f 1e fb          	endbr32 
  8012e1:	55                   	push   %ebp
  8012e2:	89 e5                	mov    %esp,%ebp
  8012e4:	53                   	push   %ebx
  8012e5:	83 ec 1c             	sub    $0x1c,%esp
  8012e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012eb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012ee:	50                   	push   %eax
  8012ef:	53                   	push   %ebx
  8012f0:	e8 60 fd ff ff       	call   801055 <fd_lookup>
  8012f5:	83 c4 10             	add    $0x10,%esp
  8012f8:	85 c0                	test   %eax,%eax
  8012fa:	78 3f                	js     80133b <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012fc:	83 ec 08             	sub    $0x8,%esp
  8012ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801302:	50                   	push   %eax
  801303:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801306:	ff 30                	pushl  (%eax)
  801308:	e8 9c fd ff ff       	call   8010a9 <dev_lookup>
  80130d:	83 c4 10             	add    $0x10,%esp
  801310:	85 c0                	test   %eax,%eax
  801312:	78 27                	js     80133b <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801314:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801317:	8b 42 08             	mov    0x8(%edx),%eax
  80131a:	83 e0 03             	and    $0x3,%eax
  80131d:	83 f8 01             	cmp    $0x1,%eax
  801320:	74 1e                	je     801340 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801322:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801325:	8b 40 08             	mov    0x8(%eax),%eax
  801328:	85 c0                	test   %eax,%eax
  80132a:	74 35                	je     801361 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80132c:	83 ec 04             	sub    $0x4,%esp
  80132f:	ff 75 10             	pushl  0x10(%ebp)
  801332:	ff 75 0c             	pushl  0xc(%ebp)
  801335:	52                   	push   %edx
  801336:	ff d0                	call   *%eax
  801338:	83 c4 10             	add    $0x10,%esp
}
  80133b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80133e:	c9                   	leave  
  80133f:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801340:	a1 08 40 80 00       	mov    0x804008,%eax
  801345:	8b 40 48             	mov    0x48(%eax),%eax
  801348:	83 ec 04             	sub    $0x4,%esp
  80134b:	53                   	push   %ebx
  80134c:	50                   	push   %eax
  80134d:	68 91 28 80 00       	push   $0x802891
  801352:	e8 53 ee ff ff       	call   8001aa <cprintf>
		return -E_INVAL;
  801357:	83 c4 10             	add    $0x10,%esp
  80135a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80135f:	eb da                	jmp    80133b <read+0x5e>
		return -E_NOT_SUPP;
  801361:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801366:	eb d3                	jmp    80133b <read+0x5e>

00801368 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801368:	f3 0f 1e fb          	endbr32 
  80136c:	55                   	push   %ebp
  80136d:	89 e5                	mov    %esp,%ebp
  80136f:	57                   	push   %edi
  801370:	56                   	push   %esi
  801371:	53                   	push   %ebx
  801372:	83 ec 0c             	sub    $0xc,%esp
  801375:	8b 7d 08             	mov    0x8(%ebp),%edi
  801378:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80137b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801380:	eb 02                	jmp    801384 <readn+0x1c>
  801382:	01 c3                	add    %eax,%ebx
  801384:	39 f3                	cmp    %esi,%ebx
  801386:	73 21                	jae    8013a9 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801388:	83 ec 04             	sub    $0x4,%esp
  80138b:	89 f0                	mov    %esi,%eax
  80138d:	29 d8                	sub    %ebx,%eax
  80138f:	50                   	push   %eax
  801390:	89 d8                	mov    %ebx,%eax
  801392:	03 45 0c             	add    0xc(%ebp),%eax
  801395:	50                   	push   %eax
  801396:	57                   	push   %edi
  801397:	e8 41 ff ff ff       	call   8012dd <read>
		if (m < 0)
  80139c:	83 c4 10             	add    $0x10,%esp
  80139f:	85 c0                	test   %eax,%eax
  8013a1:	78 04                	js     8013a7 <readn+0x3f>
			return m;
		if (m == 0)
  8013a3:	75 dd                	jne    801382 <readn+0x1a>
  8013a5:	eb 02                	jmp    8013a9 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013a7:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013a9:	89 d8                	mov    %ebx,%eax
  8013ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013ae:	5b                   	pop    %ebx
  8013af:	5e                   	pop    %esi
  8013b0:	5f                   	pop    %edi
  8013b1:	5d                   	pop    %ebp
  8013b2:	c3                   	ret    

008013b3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013b3:	f3 0f 1e fb          	endbr32 
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
  8013ba:	53                   	push   %ebx
  8013bb:	83 ec 1c             	sub    $0x1c,%esp
  8013be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013c4:	50                   	push   %eax
  8013c5:	53                   	push   %ebx
  8013c6:	e8 8a fc ff ff       	call   801055 <fd_lookup>
  8013cb:	83 c4 10             	add    $0x10,%esp
  8013ce:	85 c0                	test   %eax,%eax
  8013d0:	78 3a                	js     80140c <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013d2:	83 ec 08             	sub    $0x8,%esp
  8013d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013d8:	50                   	push   %eax
  8013d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013dc:	ff 30                	pushl  (%eax)
  8013de:	e8 c6 fc ff ff       	call   8010a9 <dev_lookup>
  8013e3:	83 c4 10             	add    $0x10,%esp
  8013e6:	85 c0                	test   %eax,%eax
  8013e8:	78 22                	js     80140c <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ed:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013f1:	74 1e                	je     801411 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013f6:	8b 52 0c             	mov    0xc(%edx),%edx
  8013f9:	85 d2                	test   %edx,%edx
  8013fb:	74 35                	je     801432 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013fd:	83 ec 04             	sub    $0x4,%esp
  801400:	ff 75 10             	pushl  0x10(%ebp)
  801403:	ff 75 0c             	pushl  0xc(%ebp)
  801406:	50                   	push   %eax
  801407:	ff d2                	call   *%edx
  801409:	83 c4 10             	add    $0x10,%esp
}
  80140c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80140f:	c9                   	leave  
  801410:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801411:	a1 08 40 80 00       	mov    0x804008,%eax
  801416:	8b 40 48             	mov    0x48(%eax),%eax
  801419:	83 ec 04             	sub    $0x4,%esp
  80141c:	53                   	push   %ebx
  80141d:	50                   	push   %eax
  80141e:	68 ad 28 80 00       	push   $0x8028ad
  801423:	e8 82 ed ff ff       	call   8001aa <cprintf>
		return -E_INVAL;
  801428:	83 c4 10             	add    $0x10,%esp
  80142b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801430:	eb da                	jmp    80140c <write+0x59>
		return -E_NOT_SUPP;
  801432:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801437:	eb d3                	jmp    80140c <write+0x59>

00801439 <seek>:

int
seek(int fdnum, off_t offset)
{
  801439:	f3 0f 1e fb          	endbr32 
  80143d:	55                   	push   %ebp
  80143e:	89 e5                	mov    %esp,%ebp
  801440:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801443:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801446:	50                   	push   %eax
  801447:	ff 75 08             	pushl  0x8(%ebp)
  80144a:	e8 06 fc ff ff       	call   801055 <fd_lookup>
  80144f:	83 c4 10             	add    $0x10,%esp
  801452:	85 c0                	test   %eax,%eax
  801454:	78 0e                	js     801464 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801456:	8b 55 0c             	mov    0xc(%ebp),%edx
  801459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80145c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80145f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801464:	c9                   	leave  
  801465:	c3                   	ret    

00801466 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801466:	f3 0f 1e fb          	endbr32 
  80146a:	55                   	push   %ebp
  80146b:	89 e5                	mov    %esp,%ebp
  80146d:	53                   	push   %ebx
  80146e:	83 ec 1c             	sub    $0x1c,%esp
  801471:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801474:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801477:	50                   	push   %eax
  801478:	53                   	push   %ebx
  801479:	e8 d7 fb ff ff       	call   801055 <fd_lookup>
  80147e:	83 c4 10             	add    $0x10,%esp
  801481:	85 c0                	test   %eax,%eax
  801483:	78 37                	js     8014bc <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801485:	83 ec 08             	sub    $0x8,%esp
  801488:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80148b:	50                   	push   %eax
  80148c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80148f:	ff 30                	pushl  (%eax)
  801491:	e8 13 fc ff ff       	call   8010a9 <dev_lookup>
  801496:	83 c4 10             	add    $0x10,%esp
  801499:	85 c0                	test   %eax,%eax
  80149b:	78 1f                	js     8014bc <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80149d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014a4:	74 1b                	je     8014c1 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014a9:	8b 52 18             	mov    0x18(%edx),%edx
  8014ac:	85 d2                	test   %edx,%edx
  8014ae:	74 32                	je     8014e2 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014b0:	83 ec 08             	sub    $0x8,%esp
  8014b3:	ff 75 0c             	pushl  0xc(%ebp)
  8014b6:	50                   	push   %eax
  8014b7:	ff d2                	call   *%edx
  8014b9:	83 c4 10             	add    $0x10,%esp
}
  8014bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014bf:	c9                   	leave  
  8014c0:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014c1:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014c6:	8b 40 48             	mov    0x48(%eax),%eax
  8014c9:	83 ec 04             	sub    $0x4,%esp
  8014cc:	53                   	push   %ebx
  8014cd:	50                   	push   %eax
  8014ce:	68 70 28 80 00       	push   $0x802870
  8014d3:	e8 d2 ec ff ff       	call   8001aa <cprintf>
		return -E_INVAL;
  8014d8:	83 c4 10             	add    $0x10,%esp
  8014db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014e0:	eb da                	jmp    8014bc <ftruncate+0x56>
		return -E_NOT_SUPP;
  8014e2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014e7:	eb d3                	jmp    8014bc <ftruncate+0x56>

008014e9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014e9:	f3 0f 1e fb          	endbr32 
  8014ed:	55                   	push   %ebp
  8014ee:	89 e5                	mov    %esp,%ebp
  8014f0:	53                   	push   %ebx
  8014f1:	83 ec 1c             	sub    $0x1c,%esp
  8014f4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014f7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014fa:	50                   	push   %eax
  8014fb:	ff 75 08             	pushl  0x8(%ebp)
  8014fe:	e8 52 fb ff ff       	call   801055 <fd_lookup>
  801503:	83 c4 10             	add    $0x10,%esp
  801506:	85 c0                	test   %eax,%eax
  801508:	78 4b                	js     801555 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80150a:	83 ec 08             	sub    $0x8,%esp
  80150d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801510:	50                   	push   %eax
  801511:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801514:	ff 30                	pushl  (%eax)
  801516:	e8 8e fb ff ff       	call   8010a9 <dev_lookup>
  80151b:	83 c4 10             	add    $0x10,%esp
  80151e:	85 c0                	test   %eax,%eax
  801520:	78 33                	js     801555 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801522:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801525:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801529:	74 2f                	je     80155a <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80152b:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80152e:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801535:	00 00 00 
	stat->st_isdir = 0;
  801538:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80153f:	00 00 00 
	stat->st_dev = dev;
  801542:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801548:	83 ec 08             	sub    $0x8,%esp
  80154b:	53                   	push   %ebx
  80154c:	ff 75 f0             	pushl  -0x10(%ebp)
  80154f:	ff 50 14             	call   *0x14(%eax)
  801552:	83 c4 10             	add    $0x10,%esp
}
  801555:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801558:	c9                   	leave  
  801559:	c3                   	ret    
		return -E_NOT_SUPP;
  80155a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80155f:	eb f4                	jmp    801555 <fstat+0x6c>

00801561 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801561:	f3 0f 1e fb          	endbr32 
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
  801568:	56                   	push   %esi
  801569:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80156a:	83 ec 08             	sub    $0x8,%esp
  80156d:	6a 00                	push   $0x0
  80156f:	ff 75 08             	pushl  0x8(%ebp)
  801572:	e8 fb 01 00 00       	call   801772 <open>
  801577:	89 c3                	mov    %eax,%ebx
  801579:	83 c4 10             	add    $0x10,%esp
  80157c:	85 c0                	test   %eax,%eax
  80157e:	78 1b                	js     80159b <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801580:	83 ec 08             	sub    $0x8,%esp
  801583:	ff 75 0c             	pushl  0xc(%ebp)
  801586:	50                   	push   %eax
  801587:	e8 5d ff ff ff       	call   8014e9 <fstat>
  80158c:	89 c6                	mov    %eax,%esi
	close(fd);
  80158e:	89 1c 24             	mov    %ebx,(%esp)
  801591:	e8 fd fb ff ff       	call   801193 <close>
	return r;
  801596:	83 c4 10             	add    $0x10,%esp
  801599:	89 f3                	mov    %esi,%ebx
}
  80159b:	89 d8                	mov    %ebx,%eax
  80159d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015a0:	5b                   	pop    %ebx
  8015a1:	5e                   	pop    %esi
  8015a2:	5d                   	pop    %ebp
  8015a3:	c3                   	ret    

008015a4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015a4:	55                   	push   %ebp
  8015a5:	89 e5                	mov    %esp,%ebp
  8015a7:	56                   	push   %esi
  8015a8:	53                   	push   %ebx
  8015a9:	89 c6                	mov    %eax,%esi
  8015ab:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015ad:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015b4:	74 27                	je     8015dd <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015b6:	6a 07                	push   $0x7
  8015b8:	68 00 50 80 00       	push   $0x805000
  8015bd:	56                   	push   %esi
  8015be:	ff 35 00 40 80 00    	pushl  0x804000
  8015c4:	e8 72 f9 ff ff       	call   800f3b <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015c9:	83 c4 0c             	add    $0xc,%esp
  8015cc:	6a 00                	push   $0x0
  8015ce:	53                   	push   %ebx
  8015cf:	6a 00                	push   $0x0
  8015d1:	e8 e0 f8 ff ff       	call   800eb6 <ipc_recv>
}
  8015d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015d9:	5b                   	pop    %ebx
  8015da:	5e                   	pop    %esi
  8015db:	5d                   	pop    %ebp
  8015dc:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015dd:	83 ec 0c             	sub    $0xc,%esp
  8015e0:	6a 01                	push   $0x1
  8015e2:	e8 ac f9 ff ff       	call   800f93 <ipc_find_env>
  8015e7:	a3 00 40 80 00       	mov    %eax,0x804000
  8015ec:	83 c4 10             	add    $0x10,%esp
  8015ef:	eb c5                	jmp    8015b6 <fsipc+0x12>

008015f1 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015f1:	f3 0f 1e fb          	endbr32 
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
  8015f8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fe:	8b 40 0c             	mov    0xc(%eax),%eax
  801601:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801606:	8b 45 0c             	mov    0xc(%ebp),%eax
  801609:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80160e:	ba 00 00 00 00       	mov    $0x0,%edx
  801613:	b8 02 00 00 00       	mov    $0x2,%eax
  801618:	e8 87 ff ff ff       	call   8015a4 <fsipc>
}
  80161d:	c9                   	leave  
  80161e:	c3                   	ret    

0080161f <devfile_flush>:
{
  80161f:	f3 0f 1e fb          	endbr32 
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
  801626:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801629:	8b 45 08             	mov    0x8(%ebp),%eax
  80162c:	8b 40 0c             	mov    0xc(%eax),%eax
  80162f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801634:	ba 00 00 00 00       	mov    $0x0,%edx
  801639:	b8 06 00 00 00       	mov    $0x6,%eax
  80163e:	e8 61 ff ff ff       	call   8015a4 <fsipc>
}
  801643:	c9                   	leave  
  801644:	c3                   	ret    

00801645 <devfile_stat>:
{
  801645:	f3 0f 1e fb          	endbr32 
  801649:	55                   	push   %ebp
  80164a:	89 e5                	mov    %esp,%ebp
  80164c:	53                   	push   %ebx
  80164d:	83 ec 04             	sub    $0x4,%esp
  801650:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801653:	8b 45 08             	mov    0x8(%ebp),%eax
  801656:	8b 40 0c             	mov    0xc(%eax),%eax
  801659:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80165e:	ba 00 00 00 00       	mov    $0x0,%edx
  801663:	b8 05 00 00 00       	mov    $0x5,%eax
  801668:	e8 37 ff ff ff       	call   8015a4 <fsipc>
  80166d:	85 c0                	test   %eax,%eax
  80166f:	78 2c                	js     80169d <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801671:	83 ec 08             	sub    $0x8,%esp
  801674:	68 00 50 80 00       	push   $0x805000
  801679:	53                   	push   %ebx
  80167a:	e8 35 f1 ff ff       	call   8007b4 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80167f:	a1 80 50 80 00       	mov    0x805080,%eax
  801684:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80168a:	a1 84 50 80 00       	mov    0x805084,%eax
  80168f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801695:	83 c4 10             	add    $0x10,%esp
  801698:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80169d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a0:	c9                   	leave  
  8016a1:	c3                   	ret    

008016a2 <devfile_write>:
{
  8016a2:	f3 0f 1e fb          	endbr32 
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
  8016a9:	83 ec 0c             	sub    $0xc,%esp
  8016ac:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016af:	8b 55 08             	mov    0x8(%ebp),%edx
  8016b2:	8b 52 0c             	mov    0xc(%edx),%edx
  8016b5:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  8016bb:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8016c0:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8016c5:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  8016c8:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  8016cd:	50                   	push   %eax
  8016ce:	ff 75 0c             	pushl  0xc(%ebp)
  8016d1:	68 08 50 80 00       	push   $0x805008
  8016d6:	e8 8f f2 ff ff       	call   80096a <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  8016db:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e0:	b8 04 00 00 00       	mov    $0x4,%eax
  8016e5:	e8 ba fe ff ff       	call   8015a4 <fsipc>
}
  8016ea:	c9                   	leave  
  8016eb:	c3                   	ret    

008016ec <devfile_read>:
{
  8016ec:	f3 0f 1e fb          	endbr32 
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
  8016f3:	56                   	push   %esi
  8016f4:	53                   	push   %ebx
  8016f5:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8016fe:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801703:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801709:	ba 00 00 00 00       	mov    $0x0,%edx
  80170e:	b8 03 00 00 00       	mov    $0x3,%eax
  801713:	e8 8c fe ff ff       	call   8015a4 <fsipc>
  801718:	89 c3                	mov    %eax,%ebx
  80171a:	85 c0                	test   %eax,%eax
  80171c:	78 1f                	js     80173d <devfile_read+0x51>
	assert(r <= n);
  80171e:	39 f0                	cmp    %esi,%eax
  801720:	77 24                	ja     801746 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801722:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801727:	7f 33                	jg     80175c <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801729:	83 ec 04             	sub    $0x4,%esp
  80172c:	50                   	push   %eax
  80172d:	68 00 50 80 00       	push   $0x805000
  801732:	ff 75 0c             	pushl  0xc(%ebp)
  801735:	e8 30 f2 ff ff       	call   80096a <memmove>
	return r;
  80173a:	83 c4 10             	add    $0x10,%esp
}
  80173d:	89 d8                	mov    %ebx,%eax
  80173f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801742:	5b                   	pop    %ebx
  801743:	5e                   	pop    %esi
  801744:	5d                   	pop    %ebp
  801745:	c3                   	ret    
	assert(r <= n);
  801746:	68 e0 28 80 00       	push   $0x8028e0
  80174b:	68 e7 28 80 00       	push   $0x8028e7
  801750:	6a 7c                	push   $0x7c
  801752:	68 fc 28 80 00       	push   $0x8028fc
  801757:	e8 76 0a 00 00       	call   8021d2 <_panic>
	assert(r <= PGSIZE);
  80175c:	68 07 29 80 00       	push   $0x802907
  801761:	68 e7 28 80 00       	push   $0x8028e7
  801766:	6a 7d                	push   $0x7d
  801768:	68 fc 28 80 00       	push   $0x8028fc
  80176d:	e8 60 0a 00 00       	call   8021d2 <_panic>

00801772 <open>:
{
  801772:	f3 0f 1e fb          	endbr32 
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
  801779:	56                   	push   %esi
  80177a:	53                   	push   %ebx
  80177b:	83 ec 1c             	sub    $0x1c,%esp
  80177e:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801781:	56                   	push   %esi
  801782:	e8 ea ef ff ff       	call   800771 <strlen>
  801787:	83 c4 10             	add    $0x10,%esp
  80178a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80178f:	7f 6c                	jg     8017fd <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801791:	83 ec 0c             	sub    $0xc,%esp
  801794:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801797:	50                   	push   %eax
  801798:	e8 62 f8 ff ff       	call   800fff <fd_alloc>
  80179d:	89 c3                	mov    %eax,%ebx
  80179f:	83 c4 10             	add    $0x10,%esp
  8017a2:	85 c0                	test   %eax,%eax
  8017a4:	78 3c                	js     8017e2 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8017a6:	83 ec 08             	sub    $0x8,%esp
  8017a9:	56                   	push   %esi
  8017aa:	68 00 50 80 00       	push   $0x805000
  8017af:	e8 00 f0 ff ff       	call   8007b4 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b7:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017bf:	b8 01 00 00 00       	mov    $0x1,%eax
  8017c4:	e8 db fd ff ff       	call   8015a4 <fsipc>
  8017c9:	89 c3                	mov    %eax,%ebx
  8017cb:	83 c4 10             	add    $0x10,%esp
  8017ce:	85 c0                	test   %eax,%eax
  8017d0:	78 19                	js     8017eb <open+0x79>
	return fd2num(fd);
  8017d2:	83 ec 0c             	sub    $0xc,%esp
  8017d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8017d8:	e8 f3 f7 ff ff       	call   800fd0 <fd2num>
  8017dd:	89 c3                	mov    %eax,%ebx
  8017df:	83 c4 10             	add    $0x10,%esp
}
  8017e2:	89 d8                	mov    %ebx,%eax
  8017e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017e7:	5b                   	pop    %ebx
  8017e8:	5e                   	pop    %esi
  8017e9:	5d                   	pop    %ebp
  8017ea:	c3                   	ret    
		fd_close(fd, 0);
  8017eb:	83 ec 08             	sub    $0x8,%esp
  8017ee:	6a 00                	push   $0x0
  8017f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8017f3:	e8 10 f9 ff ff       	call   801108 <fd_close>
		return r;
  8017f8:	83 c4 10             	add    $0x10,%esp
  8017fb:	eb e5                	jmp    8017e2 <open+0x70>
		return -E_BAD_PATH;
  8017fd:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801802:	eb de                	jmp    8017e2 <open+0x70>

00801804 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801804:	f3 0f 1e fb          	endbr32 
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
  80180b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80180e:	ba 00 00 00 00       	mov    $0x0,%edx
  801813:	b8 08 00 00 00       	mov    $0x8,%eax
  801818:	e8 87 fd ff ff       	call   8015a4 <fsipc>
}
  80181d:	c9                   	leave  
  80181e:	c3                   	ret    

0080181f <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80181f:	f3 0f 1e fb          	endbr32 
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
  801826:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801829:	68 13 29 80 00       	push   $0x802913
  80182e:	ff 75 0c             	pushl  0xc(%ebp)
  801831:	e8 7e ef ff ff       	call   8007b4 <strcpy>
	return 0;
}
  801836:	b8 00 00 00 00       	mov    $0x0,%eax
  80183b:	c9                   	leave  
  80183c:	c3                   	ret    

0080183d <devsock_close>:
{
  80183d:	f3 0f 1e fb          	endbr32 
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
  801844:	53                   	push   %ebx
  801845:	83 ec 10             	sub    $0x10,%esp
  801848:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80184b:	53                   	push   %ebx
  80184c:	e8 cb 09 00 00       	call   80221c <pageref>
  801851:	89 c2                	mov    %eax,%edx
  801853:	83 c4 10             	add    $0x10,%esp
		return 0;
  801856:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  80185b:	83 fa 01             	cmp    $0x1,%edx
  80185e:	74 05                	je     801865 <devsock_close+0x28>
}
  801860:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801863:	c9                   	leave  
  801864:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801865:	83 ec 0c             	sub    $0xc,%esp
  801868:	ff 73 0c             	pushl  0xc(%ebx)
  80186b:	e8 e3 02 00 00       	call   801b53 <nsipc_close>
  801870:	83 c4 10             	add    $0x10,%esp
  801873:	eb eb                	jmp    801860 <devsock_close+0x23>

00801875 <devsock_write>:
{
  801875:	f3 0f 1e fb          	endbr32 
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
  80187c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80187f:	6a 00                	push   $0x0
  801881:	ff 75 10             	pushl  0x10(%ebp)
  801884:	ff 75 0c             	pushl  0xc(%ebp)
  801887:	8b 45 08             	mov    0x8(%ebp),%eax
  80188a:	ff 70 0c             	pushl  0xc(%eax)
  80188d:	e8 b5 03 00 00       	call   801c47 <nsipc_send>
}
  801892:	c9                   	leave  
  801893:	c3                   	ret    

00801894 <devsock_read>:
{
  801894:	f3 0f 1e fb          	endbr32 
  801898:	55                   	push   %ebp
  801899:	89 e5                	mov    %esp,%ebp
  80189b:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80189e:	6a 00                	push   $0x0
  8018a0:	ff 75 10             	pushl  0x10(%ebp)
  8018a3:	ff 75 0c             	pushl  0xc(%ebp)
  8018a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a9:	ff 70 0c             	pushl  0xc(%eax)
  8018ac:	e8 1f 03 00 00       	call   801bd0 <nsipc_recv>
}
  8018b1:	c9                   	leave  
  8018b2:	c3                   	ret    

008018b3 <fd2sockid>:
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
  8018b6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8018b9:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8018bc:	52                   	push   %edx
  8018bd:	50                   	push   %eax
  8018be:	e8 92 f7 ff ff       	call   801055 <fd_lookup>
  8018c3:	83 c4 10             	add    $0x10,%esp
  8018c6:	85 c0                	test   %eax,%eax
  8018c8:	78 10                	js     8018da <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8018ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018cd:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8018d3:	39 08                	cmp    %ecx,(%eax)
  8018d5:	75 05                	jne    8018dc <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8018d7:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8018da:	c9                   	leave  
  8018db:	c3                   	ret    
		return -E_NOT_SUPP;
  8018dc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018e1:	eb f7                	jmp    8018da <fd2sockid+0x27>

008018e3 <alloc_sockfd>:
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	56                   	push   %esi
  8018e7:	53                   	push   %ebx
  8018e8:	83 ec 1c             	sub    $0x1c,%esp
  8018eb:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8018ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018f0:	50                   	push   %eax
  8018f1:	e8 09 f7 ff ff       	call   800fff <fd_alloc>
  8018f6:	89 c3                	mov    %eax,%ebx
  8018f8:	83 c4 10             	add    $0x10,%esp
  8018fb:	85 c0                	test   %eax,%eax
  8018fd:	78 43                	js     801942 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8018ff:	83 ec 04             	sub    $0x4,%esp
  801902:	68 07 04 00 00       	push   $0x407
  801907:	ff 75 f4             	pushl  -0xc(%ebp)
  80190a:	6a 00                	push   $0x0
  80190c:	e8 e5 f2 ff ff       	call   800bf6 <sys_page_alloc>
  801911:	89 c3                	mov    %eax,%ebx
  801913:	83 c4 10             	add    $0x10,%esp
  801916:	85 c0                	test   %eax,%eax
  801918:	78 28                	js     801942 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80191a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191d:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801923:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801928:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80192f:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801932:	83 ec 0c             	sub    $0xc,%esp
  801935:	50                   	push   %eax
  801936:	e8 95 f6 ff ff       	call   800fd0 <fd2num>
  80193b:	89 c3                	mov    %eax,%ebx
  80193d:	83 c4 10             	add    $0x10,%esp
  801940:	eb 0c                	jmp    80194e <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801942:	83 ec 0c             	sub    $0xc,%esp
  801945:	56                   	push   %esi
  801946:	e8 08 02 00 00       	call   801b53 <nsipc_close>
		return r;
  80194b:	83 c4 10             	add    $0x10,%esp
}
  80194e:	89 d8                	mov    %ebx,%eax
  801950:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801953:	5b                   	pop    %ebx
  801954:	5e                   	pop    %esi
  801955:	5d                   	pop    %ebp
  801956:	c3                   	ret    

00801957 <accept>:
{
  801957:	f3 0f 1e fb          	endbr32 
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
  80195e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801961:	8b 45 08             	mov    0x8(%ebp),%eax
  801964:	e8 4a ff ff ff       	call   8018b3 <fd2sockid>
  801969:	85 c0                	test   %eax,%eax
  80196b:	78 1b                	js     801988 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80196d:	83 ec 04             	sub    $0x4,%esp
  801970:	ff 75 10             	pushl  0x10(%ebp)
  801973:	ff 75 0c             	pushl  0xc(%ebp)
  801976:	50                   	push   %eax
  801977:	e8 22 01 00 00       	call   801a9e <nsipc_accept>
  80197c:	83 c4 10             	add    $0x10,%esp
  80197f:	85 c0                	test   %eax,%eax
  801981:	78 05                	js     801988 <accept+0x31>
	return alloc_sockfd(r);
  801983:	e8 5b ff ff ff       	call   8018e3 <alloc_sockfd>
}
  801988:	c9                   	leave  
  801989:	c3                   	ret    

0080198a <bind>:
{
  80198a:	f3 0f 1e fb          	endbr32 
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
  801991:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801994:	8b 45 08             	mov    0x8(%ebp),%eax
  801997:	e8 17 ff ff ff       	call   8018b3 <fd2sockid>
  80199c:	85 c0                	test   %eax,%eax
  80199e:	78 12                	js     8019b2 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  8019a0:	83 ec 04             	sub    $0x4,%esp
  8019a3:	ff 75 10             	pushl  0x10(%ebp)
  8019a6:	ff 75 0c             	pushl  0xc(%ebp)
  8019a9:	50                   	push   %eax
  8019aa:	e8 45 01 00 00       	call   801af4 <nsipc_bind>
  8019af:	83 c4 10             	add    $0x10,%esp
}
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <shutdown>:
{
  8019b4:	f3 0f 1e fb          	endbr32 
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
  8019bb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	e8 ed fe ff ff       	call   8018b3 <fd2sockid>
  8019c6:	85 c0                	test   %eax,%eax
  8019c8:	78 0f                	js     8019d9 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  8019ca:	83 ec 08             	sub    $0x8,%esp
  8019cd:	ff 75 0c             	pushl  0xc(%ebp)
  8019d0:	50                   	push   %eax
  8019d1:	e8 57 01 00 00       	call   801b2d <nsipc_shutdown>
  8019d6:	83 c4 10             	add    $0x10,%esp
}
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <connect>:
{
  8019db:	f3 0f 1e fb          	endbr32 
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
  8019e2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e8:	e8 c6 fe ff ff       	call   8018b3 <fd2sockid>
  8019ed:	85 c0                	test   %eax,%eax
  8019ef:	78 12                	js     801a03 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  8019f1:	83 ec 04             	sub    $0x4,%esp
  8019f4:	ff 75 10             	pushl  0x10(%ebp)
  8019f7:	ff 75 0c             	pushl  0xc(%ebp)
  8019fa:	50                   	push   %eax
  8019fb:	e8 71 01 00 00       	call   801b71 <nsipc_connect>
  801a00:	83 c4 10             	add    $0x10,%esp
}
  801a03:	c9                   	leave  
  801a04:	c3                   	ret    

00801a05 <listen>:
{
  801a05:	f3 0f 1e fb          	endbr32 
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
  801a0c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a12:	e8 9c fe ff ff       	call   8018b3 <fd2sockid>
  801a17:	85 c0                	test   %eax,%eax
  801a19:	78 0f                	js     801a2a <listen+0x25>
	return nsipc_listen(r, backlog);
  801a1b:	83 ec 08             	sub    $0x8,%esp
  801a1e:	ff 75 0c             	pushl  0xc(%ebp)
  801a21:	50                   	push   %eax
  801a22:	e8 83 01 00 00       	call   801baa <nsipc_listen>
  801a27:	83 c4 10             	add    $0x10,%esp
}
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <socket>:

int
socket(int domain, int type, int protocol)
{
  801a2c:	f3 0f 1e fb          	endbr32 
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
  801a33:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a36:	ff 75 10             	pushl  0x10(%ebp)
  801a39:	ff 75 0c             	pushl  0xc(%ebp)
  801a3c:	ff 75 08             	pushl  0x8(%ebp)
  801a3f:	e8 65 02 00 00       	call   801ca9 <nsipc_socket>
  801a44:	83 c4 10             	add    $0x10,%esp
  801a47:	85 c0                	test   %eax,%eax
  801a49:	78 05                	js     801a50 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801a4b:	e8 93 fe ff ff       	call   8018e3 <alloc_sockfd>
}
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    

00801a52 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
  801a55:	53                   	push   %ebx
  801a56:	83 ec 04             	sub    $0x4,%esp
  801a59:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a5b:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a62:	74 26                	je     801a8a <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a64:	6a 07                	push   $0x7
  801a66:	68 00 60 80 00       	push   $0x806000
  801a6b:	53                   	push   %ebx
  801a6c:	ff 35 04 40 80 00    	pushl  0x804004
  801a72:	e8 c4 f4 ff ff       	call   800f3b <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a77:	83 c4 0c             	add    $0xc,%esp
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	e8 31 f4 ff ff       	call   800eb6 <ipc_recv>
}
  801a85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a8a:	83 ec 0c             	sub    $0xc,%esp
  801a8d:	6a 02                	push   $0x2
  801a8f:	e8 ff f4 ff ff       	call   800f93 <ipc_find_env>
  801a94:	a3 04 40 80 00       	mov    %eax,0x804004
  801a99:	83 c4 10             	add    $0x10,%esp
  801a9c:	eb c6                	jmp    801a64 <nsipc+0x12>

00801a9e <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a9e:	f3 0f 1e fb          	endbr32 
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
  801aa5:	56                   	push   %esi
  801aa6:	53                   	push   %ebx
  801aa7:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  801aad:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801ab2:	8b 06                	mov    (%esi),%eax
  801ab4:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ab9:	b8 01 00 00 00       	mov    $0x1,%eax
  801abe:	e8 8f ff ff ff       	call   801a52 <nsipc>
  801ac3:	89 c3                	mov    %eax,%ebx
  801ac5:	85 c0                	test   %eax,%eax
  801ac7:	79 09                	jns    801ad2 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801ac9:	89 d8                	mov    %ebx,%eax
  801acb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ace:	5b                   	pop    %ebx
  801acf:	5e                   	pop    %esi
  801ad0:	5d                   	pop    %ebp
  801ad1:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ad2:	83 ec 04             	sub    $0x4,%esp
  801ad5:	ff 35 10 60 80 00    	pushl  0x806010
  801adb:	68 00 60 80 00       	push   $0x806000
  801ae0:	ff 75 0c             	pushl  0xc(%ebp)
  801ae3:	e8 82 ee ff ff       	call   80096a <memmove>
		*addrlen = ret->ret_addrlen;
  801ae8:	a1 10 60 80 00       	mov    0x806010,%eax
  801aed:	89 06                	mov    %eax,(%esi)
  801aef:	83 c4 10             	add    $0x10,%esp
	return r;
  801af2:	eb d5                	jmp    801ac9 <nsipc_accept+0x2b>

00801af4 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801af4:	f3 0f 1e fb          	endbr32 
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
  801afb:	53                   	push   %ebx
  801afc:	83 ec 08             	sub    $0x8,%esp
  801aff:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b02:	8b 45 08             	mov    0x8(%ebp),%eax
  801b05:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b0a:	53                   	push   %ebx
  801b0b:	ff 75 0c             	pushl  0xc(%ebp)
  801b0e:	68 04 60 80 00       	push   $0x806004
  801b13:	e8 52 ee ff ff       	call   80096a <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b18:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b1e:	b8 02 00 00 00       	mov    $0x2,%eax
  801b23:	e8 2a ff ff ff       	call   801a52 <nsipc>
}
  801b28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b2b:	c9                   	leave  
  801b2c:	c3                   	ret    

00801b2d <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b2d:	f3 0f 1e fb          	endbr32 
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
  801b34:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b42:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b47:	b8 03 00 00 00       	mov    $0x3,%eax
  801b4c:	e8 01 ff ff ff       	call   801a52 <nsipc>
}
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <nsipc_close>:

int
nsipc_close(int s)
{
  801b53:	f3 0f 1e fb          	endbr32 
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
  801b5a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b60:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b65:	b8 04 00 00 00       	mov    $0x4,%eax
  801b6a:	e8 e3 fe ff ff       	call   801a52 <nsipc>
}
  801b6f:	c9                   	leave  
  801b70:	c3                   	ret    

00801b71 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b71:	f3 0f 1e fb          	endbr32 
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
  801b78:	53                   	push   %ebx
  801b79:	83 ec 08             	sub    $0x8,%esp
  801b7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b82:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b87:	53                   	push   %ebx
  801b88:	ff 75 0c             	pushl  0xc(%ebp)
  801b8b:	68 04 60 80 00       	push   $0x806004
  801b90:	e8 d5 ed ff ff       	call   80096a <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b95:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b9b:	b8 05 00 00 00       	mov    $0x5,%eax
  801ba0:	e8 ad fe ff ff       	call   801a52 <nsipc>
}
  801ba5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ba8:	c9                   	leave  
  801ba9:	c3                   	ret    

00801baa <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801baa:	f3 0f 1e fb          	endbr32 
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
  801bb1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bbf:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801bc4:	b8 06 00 00 00       	mov    $0x6,%eax
  801bc9:	e8 84 fe ff ff       	call   801a52 <nsipc>
}
  801bce:	c9                   	leave  
  801bcf:	c3                   	ret    

00801bd0 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801bd0:	f3 0f 1e fb          	endbr32 
  801bd4:	55                   	push   %ebp
  801bd5:	89 e5                	mov    %esp,%ebp
  801bd7:	56                   	push   %esi
  801bd8:	53                   	push   %ebx
  801bd9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdf:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801be4:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801bea:	8b 45 14             	mov    0x14(%ebp),%eax
  801bed:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801bf2:	b8 07 00 00 00       	mov    $0x7,%eax
  801bf7:	e8 56 fe ff ff       	call   801a52 <nsipc>
  801bfc:	89 c3                	mov    %eax,%ebx
  801bfe:	85 c0                	test   %eax,%eax
  801c00:	78 26                	js     801c28 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801c02:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801c08:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801c0d:	0f 4e c6             	cmovle %esi,%eax
  801c10:	39 c3                	cmp    %eax,%ebx
  801c12:	7f 1d                	jg     801c31 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c14:	83 ec 04             	sub    $0x4,%esp
  801c17:	53                   	push   %ebx
  801c18:	68 00 60 80 00       	push   $0x806000
  801c1d:	ff 75 0c             	pushl  0xc(%ebp)
  801c20:	e8 45 ed ff ff       	call   80096a <memmove>
  801c25:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c28:	89 d8                	mov    %ebx,%eax
  801c2a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c2d:	5b                   	pop    %ebx
  801c2e:	5e                   	pop    %esi
  801c2f:	5d                   	pop    %ebp
  801c30:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c31:	68 1f 29 80 00       	push   $0x80291f
  801c36:	68 e7 28 80 00       	push   $0x8028e7
  801c3b:	6a 62                	push   $0x62
  801c3d:	68 34 29 80 00       	push   $0x802934
  801c42:	e8 8b 05 00 00       	call   8021d2 <_panic>

00801c47 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c47:	f3 0f 1e fb          	endbr32 
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
  801c4e:	53                   	push   %ebx
  801c4f:	83 ec 04             	sub    $0x4,%esp
  801c52:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c55:	8b 45 08             	mov    0x8(%ebp),%eax
  801c58:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c5d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c63:	7f 2e                	jg     801c93 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c65:	83 ec 04             	sub    $0x4,%esp
  801c68:	53                   	push   %ebx
  801c69:	ff 75 0c             	pushl  0xc(%ebp)
  801c6c:	68 0c 60 80 00       	push   $0x80600c
  801c71:	e8 f4 ec ff ff       	call   80096a <memmove>
	nsipcbuf.send.req_size = size;
  801c76:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c7c:	8b 45 14             	mov    0x14(%ebp),%eax
  801c7f:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c84:	b8 08 00 00 00       	mov    $0x8,%eax
  801c89:	e8 c4 fd ff ff       	call   801a52 <nsipc>
}
  801c8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c91:	c9                   	leave  
  801c92:	c3                   	ret    
	assert(size < 1600);
  801c93:	68 40 29 80 00       	push   $0x802940
  801c98:	68 e7 28 80 00       	push   $0x8028e7
  801c9d:	6a 6d                	push   $0x6d
  801c9f:	68 34 29 80 00       	push   $0x802934
  801ca4:	e8 29 05 00 00       	call   8021d2 <_panic>

00801ca9 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801ca9:	f3 0f 1e fb          	endbr32 
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
  801cb0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801cbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cbe:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801cc3:	8b 45 10             	mov    0x10(%ebp),%eax
  801cc6:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801ccb:	b8 09 00 00 00       	mov    $0x9,%eax
  801cd0:	e8 7d fd ff ff       	call   801a52 <nsipc>
}
  801cd5:	c9                   	leave  
  801cd6:	c3                   	ret    

00801cd7 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801cd7:	f3 0f 1e fb          	endbr32 
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
  801cde:	56                   	push   %esi
  801cdf:	53                   	push   %ebx
  801ce0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ce3:	83 ec 0c             	sub    $0xc,%esp
  801ce6:	ff 75 08             	pushl  0x8(%ebp)
  801ce9:	e8 f6 f2 ff ff       	call   800fe4 <fd2data>
  801cee:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801cf0:	83 c4 08             	add    $0x8,%esp
  801cf3:	68 4c 29 80 00       	push   $0x80294c
  801cf8:	53                   	push   %ebx
  801cf9:	e8 b6 ea ff ff       	call   8007b4 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cfe:	8b 46 04             	mov    0x4(%esi),%eax
  801d01:	2b 06                	sub    (%esi),%eax
  801d03:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d09:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d10:	00 00 00 
	stat->st_dev = &devpipe;
  801d13:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d1a:	30 80 00 
	return 0;
}
  801d1d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d22:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d25:	5b                   	pop    %ebx
  801d26:	5e                   	pop    %esi
  801d27:	5d                   	pop    %ebp
  801d28:	c3                   	ret    

00801d29 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d29:	f3 0f 1e fb          	endbr32 
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
  801d30:	53                   	push   %ebx
  801d31:	83 ec 0c             	sub    $0xc,%esp
  801d34:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d37:	53                   	push   %ebx
  801d38:	6a 00                	push   $0x0
  801d3a:	e8 44 ef ff ff       	call   800c83 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d3f:	89 1c 24             	mov    %ebx,(%esp)
  801d42:	e8 9d f2 ff ff       	call   800fe4 <fd2data>
  801d47:	83 c4 08             	add    $0x8,%esp
  801d4a:	50                   	push   %eax
  801d4b:	6a 00                	push   $0x0
  801d4d:	e8 31 ef ff ff       	call   800c83 <sys_page_unmap>
}
  801d52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d55:	c9                   	leave  
  801d56:	c3                   	ret    

00801d57 <_pipeisclosed>:
{
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
  801d5a:	57                   	push   %edi
  801d5b:	56                   	push   %esi
  801d5c:	53                   	push   %ebx
  801d5d:	83 ec 1c             	sub    $0x1c,%esp
  801d60:	89 c7                	mov    %eax,%edi
  801d62:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d64:	a1 08 40 80 00       	mov    0x804008,%eax
  801d69:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d6c:	83 ec 0c             	sub    $0xc,%esp
  801d6f:	57                   	push   %edi
  801d70:	e8 a7 04 00 00       	call   80221c <pageref>
  801d75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d78:	89 34 24             	mov    %esi,(%esp)
  801d7b:	e8 9c 04 00 00       	call   80221c <pageref>
		nn = thisenv->env_runs;
  801d80:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d86:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d89:	83 c4 10             	add    $0x10,%esp
  801d8c:	39 cb                	cmp    %ecx,%ebx
  801d8e:	74 1b                	je     801dab <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d90:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d93:	75 cf                	jne    801d64 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d95:	8b 42 58             	mov    0x58(%edx),%eax
  801d98:	6a 01                	push   $0x1
  801d9a:	50                   	push   %eax
  801d9b:	53                   	push   %ebx
  801d9c:	68 53 29 80 00       	push   $0x802953
  801da1:	e8 04 e4 ff ff       	call   8001aa <cprintf>
  801da6:	83 c4 10             	add    $0x10,%esp
  801da9:	eb b9                	jmp    801d64 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801dab:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801dae:	0f 94 c0             	sete   %al
  801db1:	0f b6 c0             	movzbl %al,%eax
}
  801db4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801db7:	5b                   	pop    %ebx
  801db8:	5e                   	pop    %esi
  801db9:	5f                   	pop    %edi
  801dba:	5d                   	pop    %ebp
  801dbb:	c3                   	ret    

00801dbc <devpipe_write>:
{
  801dbc:	f3 0f 1e fb          	endbr32 
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
  801dc3:	57                   	push   %edi
  801dc4:	56                   	push   %esi
  801dc5:	53                   	push   %ebx
  801dc6:	83 ec 28             	sub    $0x28,%esp
  801dc9:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801dcc:	56                   	push   %esi
  801dcd:	e8 12 f2 ff ff       	call   800fe4 <fd2data>
  801dd2:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dd4:	83 c4 10             	add    $0x10,%esp
  801dd7:	bf 00 00 00 00       	mov    $0x0,%edi
  801ddc:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ddf:	74 4f                	je     801e30 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801de1:	8b 43 04             	mov    0x4(%ebx),%eax
  801de4:	8b 0b                	mov    (%ebx),%ecx
  801de6:	8d 51 20             	lea    0x20(%ecx),%edx
  801de9:	39 d0                	cmp    %edx,%eax
  801deb:	72 14                	jb     801e01 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801ded:	89 da                	mov    %ebx,%edx
  801def:	89 f0                	mov    %esi,%eax
  801df1:	e8 61 ff ff ff       	call   801d57 <_pipeisclosed>
  801df6:	85 c0                	test   %eax,%eax
  801df8:	75 3b                	jne    801e35 <devpipe_write+0x79>
			sys_yield();
  801dfa:	e8 d4 ed ff ff       	call   800bd3 <sys_yield>
  801dff:	eb e0                	jmp    801de1 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e04:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e08:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e0b:	89 c2                	mov    %eax,%edx
  801e0d:	c1 fa 1f             	sar    $0x1f,%edx
  801e10:	89 d1                	mov    %edx,%ecx
  801e12:	c1 e9 1b             	shr    $0x1b,%ecx
  801e15:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e18:	83 e2 1f             	and    $0x1f,%edx
  801e1b:	29 ca                	sub    %ecx,%edx
  801e1d:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e21:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e25:	83 c0 01             	add    $0x1,%eax
  801e28:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e2b:	83 c7 01             	add    $0x1,%edi
  801e2e:	eb ac                	jmp    801ddc <devpipe_write+0x20>
	return i;
  801e30:	8b 45 10             	mov    0x10(%ebp),%eax
  801e33:	eb 05                	jmp    801e3a <devpipe_write+0x7e>
				return 0;
  801e35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e3d:	5b                   	pop    %ebx
  801e3e:	5e                   	pop    %esi
  801e3f:	5f                   	pop    %edi
  801e40:	5d                   	pop    %ebp
  801e41:	c3                   	ret    

00801e42 <devpipe_read>:
{
  801e42:	f3 0f 1e fb          	endbr32 
  801e46:	55                   	push   %ebp
  801e47:	89 e5                	mov    %esp,%ebp
  801e49:	57                   	push   %edi
  801e4a:	56                   	push   %esi
  801e4b:	53                   	push   %ebx
  801e4c:	83 ec 18             	sub    $0x18,%esp
  801e4f:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e52:	57                   	push   %edi
  801e53:	e8 8c f1 ff ff       	call   800fe4 <fd2data>
  801e58:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e5a:	83 c4 10             	add    $0x10,%esp
  801e5d:	be 00 00 00 00       	mov    $0x0,%esi
  801e62:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e65:	75 14                	jne    801e7b <devpipe_read+0x39>
	return i;
  801e67:	8b 45 10             	mov    0x10(%ebp),%eax
  801e6a:	eb 02                	jmp    801e6e <devpipe_read+0x2c>
				return i;
  801e6c:	89 f0                	mov    %esi,%eax
}
  801e6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e71:	5b                   	pop    %ebx
  801e72:	5e                   	pop    %esi
  801e73:	5f                   	pop    %edi
  801e74:	5d                   	pop    %ebp
  801e75:	c3                   	ret    
			sys_yield();
  801e76:	e8 58 ed ff ff       	call   800bd3 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e7b:	8b 03                	mov    (%ebx),%eax
  801e7d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e80:	75 18                	jne    801e9a <devpipe_read+0x58>
			if (i > 0)
  801e82:	85 f6                	test   %esi,%esi
  801e84:	75 e6                	jne    801e6c <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801e86:	89 da                	mov    %ebx,%edx
  801e88:	89 f8                	mov    %edi,%eax
  801e8a:	e8 c8 fe ff ff       	call   801d57 <_pipeisclosed>
  801e8f:	85 c0                	test   %eax,%eax
  801e91:	74 e3                	je     801e76 <devpipe_read+0x34>
				return 0;
  801e93:	b8 00 00 00 00       	mov    $0x0,%eax
  801e98:	eb d4                	jmp    801e6e <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e9a:	99                   	cltd   
  801e9b:	c1 ea 1b             	shr    $0x1b,%edx
  801e9e:	01 d0                	add    %edx,%eax
  801ea0:	83 e0 1f             	and    $0x1f,%eax
  801ea3:	29 d0                	sub    %edx,%eax
  801ea5:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801eaa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ead:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801eb0:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801eb3:	83 c6 01             	add    $0x1,%esi
  801eb6:	eb aa                	jmp    801e62 <devpipe_read+0x20>

00801eb8 <pipe>:
{
  801eb8:	f3 0f 1e fb          	endbr32 
  801ebc:	55                   	push   %ebp
  801ebd:	89 e5                	mov    %esp,%ebp
  801ebf:	56                   	push   %esi
  801ec0:	53                   	push   %ebx
  801ec1:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ec4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ec7:	50                   	push   %eax
  801ec8:	e8 32 f1 ff ff       	call   800fff <fd_alloc>
  801ecd:	89 c3                	mov    %eax,%ebx
  801ecf:	83 c4 10             	add    $0x10,%esp
  801ed2:	85 c0                	test   %eax,%eax
  801ed4:	0f 88 23 01 00 00    	js     801ffd <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eda:	83 ec 04             	sub    $0x4,%esp
  801edd:	68 07 04 00 00       	push   $0x407
  801ee2:	ff 75 f4             	pushl  -0xc(%ebp)
  801ee5:	6a 00                	push   $0x0
  801ee7:	e8 0a ed ff ff       	call   800bf6 <sys_page_alloc>
  801eec:	89 c3                	mov    %eax,%ebx
  801eee:	83 c4 10             	add    $0x10,%esp
  801ef1:	85 c0                	test   %eax,%eax
  801ef3:	0f 88 04 01 00 00    	js     801ffd <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801ef9:	83 ec 0c             	sub    $0xc,%esp
  801efc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801eff:	50                   	push   %eax
  801f00:	e8 fa f0 ff ff       	call   800fff <fd_alloc>
  801f05:	89 c3                	mov    %eax,%ebx
  801f07:	83 c4 10             	add    $0x10,%esp
  801f0a:	85 c0                	test   %eax,%eax
  801f0c:	0f 88 db 00 00 00    	js     801fed <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f12:	83 ec 04             	sub    $0x4,%esp
  801f15:	68 07 04 00 00       	push   $0x407
  801f1a:	ff 75 f0             	pushl  -0x10(%ebp)
  801f1d:	6a 00                	push   $0x0
  801f1f:	e8 d2 ec ff ff       	call   800bf6 <sys_page_alloc>
  801f24:	89 c3                	mov    %eax,%ebx
  801f26:	83 c4 10             	add    $0x10,%esp
  801f29:	85 c0                	test   %eax,%eax
  801f2b:	0f 88 bc 00 00 00    	js     801fed <pipe+0x135>
	va = fd2data(fd0);
  801f31:	83 ec 0c             	sub    $0xc,%esp
  801f34:	ff 75 f4             	pushl  -0xc(%ebp)
  801f37:	e8 a8 f0 ff ff       	call   800fe4 <fd2data>
  801f3c:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f3e:	83 c4 0c             	add    $0xc,%esp
  801f41:	68 07 04 00 00       	push   $0x407
  801f46:	50                   	push   %eax
  801f47:	6a 00                	push   $0x0
  801f49:	e8 a8 ec ff ff       	call   800bf6 <sys_page_alloc>
  801f4e:	89 c3                	mov    %eax,%ebx
  801f50:	83 c4 10             	add    $0x10,%esp
  801f53:	85 c0                	test   %eax,%eax
  801f55:	0f 88 82 00 00 00    	js     801fdd <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f5b:	83 ec 0c             	sub    $0xc,%esp
  801f5e:	ff 75 f0             	pushl  -0x10(%ebp)
  801f61:	e8 7e f0 ff ff       	call   800fe4 <fd2data>
  801f66:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f6d:	50                   	push   %eax
  801f6e:	6a 00                	push   $0x0
  801f70:	56                   	push   %esi
  801f71:	6a 00                	push   $0x0
  801f73:	e8 c5 ec ff ff       	call   800c3d <sys_page_map>
  801f78:	89 c3                	mov    %eax,%ebx
  801f7a:	83 c4 20             	add    $0x20,%esp
  801f7d:	85 c0                	test   %eax,%eax
  801f7f:	78 4e                	js     801fcf <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801f81:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f89:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f8e:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f95:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f98:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801fa4:	83 ec 0c             	sub    $0xc,%esp
  801fa7:	ff 75 f4             	pushl  -0xc(%ebp)
  801faa:	e8 21 f0 ff ff       	call   800fd0 <fd2num>
  801faf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fb2:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801fb4:	83 c4 04             	add    $0x4,%esp
  801fb7:	ff 75 f0             	pushl  -0x10(%ebp)
  801fba:	e8 11 f0 ff ff       	call   800fd0 <fd2num>
  801fbf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fc2:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801fc5:	83 c4 10             	add    $0x10,%esp
  801fc8:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fcd:	eb 2e                	jmp    801ffd <pipe+0x145>
	sys_page_unmap(0, va);
  801fcf:	83 ec 08             	sub    $0x8,%esp
  801fd2:	56                   	push   %esi
  801fd3:	6a 00                	push   $0x0
  801fd5:	e8 a9 ec ff ff       	call   800c83 <sys_page_unmap>
  801fda:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801fdd:	83 ec 08             	sub    $0x8,%esp
  801fe0:	ff 75 f0             	pushl  -0x10(%ebp)
  801fe3:	6a 00                	push   $0x0
  801fe5:	e8 99 ec ff ff       	call   800c83 <sys_page_unmap>
  801fea:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801fed:	83 ec 08             	sub    $0x8,%esp
  801ff0:	ff 75 f4             	pushl  -0xc(%ebp)
  801ff3:	6a 00                	push   $0x0
  801ff5:	e8 89 ec ff ff       	call   800c83 <sys_page_unmap>
  801ffa:	83 c4 10             	add    $0x10,%esp
}
  801ffd:	89 d8                	mov    %ebx,%eax
  801fff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802002:	5b                   	pop    %ebx
  802003:	5e                   	pop    %esi
  802004:	5d                   	pop    %ebp
  802005:	c3                   	ret    

00802006 <pipeisclosed>:
{
  802006:	f3 0f 1e fb          	endbr32 
  80200a:	55                   	push   %ebp
  80200b:	89 e5                	mov    %esp,%ebp
  80200d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802010:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802013:	50                   	push   %eax
  802014:	ff 75 08             	pushl  0x8(%ebp)
  802017:	e8 39 f0 ff ff       	call   801055 <fd_lookup>
  80201c:	83 c4 10             	add    $0x10,%esp
  80201f:	85 c0                	test   %eax,%eax
  802021:	78 18                	js     80203b <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802023:	83 ec 0c             	sub    $0xc,%esp
  802026:	ff 75 f4             	pushl  -0xc(%ebp)
  802029:	e8 b6 ef ff ff       	call   800fe4 <fd2data>
  80202e:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802033:	e8 1f fd ff ff       	call   801d57 <_pipeisclosed>
  802038:	83 c4 10             	add    $0x10,%esp
}
  80203b:	c9                   	leave  
  80203c:	c3                   	ret    

0080203d <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80203d:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  802041:	b8 00 00 00 00       	mov    $0x0,%eax
  802046:	c3                   	ret    

00802047 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802047:	f3 0f 1e fb          	endbr32 
  80204b:	55                   	push   %ebp
  80204c:	89 e5                	mov    %esp,%ebp
  80204e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802051:	68 6b 29 80 00       	push   $0x80296b
  802056:	ff 75 0c             	pushl  0xc(%ebp)
  802059:	e8 56 e7 ff ff       	call   8007b4 <strcpy>
	return 0;
}
  80205e:	b8 00 00 00 00       	mov    $0x0,%eax
  802063:	c9                   	leave  
  802064:	c3                   	ret    

00802065 <devcons_write>:
{
  802065:	f3 0f 1e fb          	endbr32 
  802069:	55                   	push   %ebp
  80206a:	89 e5                	mov    %esp,%ebp
  80206c:	57                   	push   %edi
  80206d:	56                   	push   %esi
  80206e:	53                   	push   %ebx
  80206f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802075:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80207a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802080:	3b 75 10             	cmp    0x10(%ebp),%esi
  802083:	73 31                	jae    8020b6 <devcons_write+0x51>
		m = n - tot;
  802085:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802088:	29 f3                	sub    %esi,%ebx
  80208a:	83 fb 7f             	cmp    $0x7f,%ebx
  80208d:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802092:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802095:	83 ec 04             	sub    $0x4,%esp
  802098:	53                   	push   %ebx
  802099:	89 f0                	mov    %esi,%eax
  80209b:	03 45 0c             	add    0xc(%ebp),%eax
  80209e:	50                   	push   %eax
  80209f:	57                   	push   %edi
  8020a0:	e8 c5 e8 ff ff       	call   80096a <memmove>
		sys_cputs(buf, m);
  8020a5:	83 c4 08             	add    $0x8,%esp
  8020a8:	53                   	push   %ebx
  8020a9:	57                   	push   %edi
  8020aa:	e8 77 ea ff ff       	call   800b26 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8020af:	01 de                	add    %ebx,%esi
  8020b1:	83 c4 10             	add    $0x10,%esp
  8020b4:	eb ca                	jmp    802080 <devcons_write+0x1b>
}
  8020b6:	89 f0                	mov    %esi,%eax
  8020b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020bb:	5b                   	pop    %ebx
  8020bc:	5e                   	pop    %esi
  8020bd:	5f                   	pop    %edi
  8020be:	5d                   	pop    %ebp
  8020bf:	c3                   	ret    

008020c0 <devcons_read>:
{
  8020c0:	f3 0f 1e fb          	endbr32 
  8020c4:	55                   	push   %ebp
  8020c5:	89 e5                	mov    %esp,%ebp
  8020c7:	83 ec 08             	sub    $0x8,%esp
  8020ca:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8020cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020d3:	74 21                	je     8020f6 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8020d5:	e8 6e ea ff ff       	call   800b48 <sys_cgetc>
  8020da:	85 c0                	test   %eax,%eax
  8020dc:	75 07                	jne    8020e5 <devcons_read+0x25>
		sys_yield();
  8020de:	e8 f0 ea ff ff       	call   800bd3 <sys_yield>
  8020e3:	eb f0                	jmp    8020d5 <devcons_read+0x15>
	if (c < 0)
  8020e5:	78 0f                	js     8020f6 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8020e7:	83 f8 04             	cmp    $0x4,%eax
  8020ea:	74 0c                	je     8020f8 <devcons_read+0x38>
	*(char*)vbuf = c;
  8020ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ef:	88 02                	mov    %al,(%edx)
	return 1;
  8020f1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020f6:	c9                   	leave  
  8020f7:	c3                   	ret    
		return 0;
  8020f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8020fd:	eb f7                	jmp    8020f6 <devcons_read+0x36>

008020ff <cputchar>:
{
  8020ff:	f3 0f 1e fb          	endbr32 
  802103:	55                   	push   %ebp
  802104:	89 e5                	mov    %esp,%ebp
  802106:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802109:	8b 45 08             	mov    0x8(%ebp),%eax
  80210c:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80210f:	6a 01                	push   $0x1
  802111:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802114:	50                   	push   %eax
  802115:	e8 0c ea ff ff       	call   800b26 <sys_cputs>
}
  80211a:	83 c4 10             	add    $0x10,%esp
  80211d:	c9                   	leave  
  80211e:	c3                   	ret    

0080211f <getchar>:
{
  80211f:	f3 0f 1e fb          	endbr32 
  802123:	55                   	push   %ebp
  802124:	89 e5                	mov    %esp,%ebp
  802126:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802129:	6a 01                	push   $0x1
  80212b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80212e:	50                   	push   %eax
  80212f:	6a 00                	push   $0x0
  802131:	e8 a7 f1 ff ff       	call   8012dd <read>
	if (r < 0)
  802136:	83 c4 10             	add    $0x10,%esp
  802139:	85 c0                	test   %eax,%eax
  80213b:	78 06                	js     802143 <getchar+0x24>
	if (r < 1)
  80213d:	74 06                	je     802145 <getchar+0x26>
	return c;
  80213f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802143:	c9                   	leave  
  802144:	c3                   	ret    
		return -E_EOF;
  802145:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80214a:	eb f7                	jmp    802143 <getchar+0x24>

0080214c <iscons>:
{
  80214c:	f3 0f 1e fb          	endbr32 
  802150:	55                   	push   %ebp
  802151:	89 e5                	mov    %esp,%ebp
  802153:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802156:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802159:	50                   	push   %eax
  80215a:	ff 75 08             	pushl  0x8(%ebp)
  80215d:	e8 f3 ee ff ff       	call   801055 <fd_lookup>
  802162:	83 c4 10             	add    $0x10,%esp
  802165:	85 c0                	test   %eax,%eax
  802167:	78 11                	js     80217a <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  802169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216c:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802172:	39 10                	cmp    %edx,(%eax)
  802174:	0f 94 c0             	sete   %al
  802177:	0f b6 c0             	movzbl %al,%eax
}
  80217a:	c9                   	leave  
  80217b:	c3                   	ret    

0080217c <opencons>:
{
  80217c:	f3 0f 1e fb          	endbr32 
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
  802183:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802186:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802189:	50                   	push   %eax
  80218a:	e8 70 ee ff ff       	call   800fff <fd_alloc>
  80218f:	83 c4 10             	add    $0x10,%esp
  802192:	85 c0                	test   %eax,%eax
  802194:	78 3a                	js     8021d0 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802196:	83 ec 04             	sub    $0x4,%esp
  802199:	68 07 04 00 00       	push   $0x407
  80219e:	ff 75 f4             	pushl  -0xc(%ebp)
  8021a1:	6a 00                	push   $0x0
  8021a3:	e8 4e ea ff ff       	call   800bf6 <sys_page_alloc>
  8021a8:	83 c4 10             	add    $0x10,%esp
  8021ab:	85 c0                	test   %eax,%eax
  8021ad:	78 21                	js     8021d0 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8021af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b2:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021b8:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8021ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bd:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8021c4:	83 ec 0c             	sub    $0xc,%esp
  8021c7:	50                   	push   %eax
  8021c8:	e8 03 ee ff ff       	call   800fd0 <fd2num>
  8021cd:	83 c4 10             	add    $0x10,%esp
}
  8021d0:	c9                   	leave  
  8021d1:	c3                   	ret    

008021d2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8021d2:	f3 0f 1e fb          	endbr32 
  8021d6:	55                   	push   %ebp
  8021d7:	89 e5                	mov    %esp,%ebp
  8021d9:	56                   	push   %esi
  8021da:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8021db:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8021de:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8021e4:	e8 c7 e9 ff ff       	call   800bb0 <sys_getenvid>
  8021e9:	83 ec 0c             	sub    $0xc,%esp
  8021ec:	ff 75 0c             	pushl  0xc(%ebp)
  8021ef:	ff 75 08             	pushl  0x8(%ebp)
  8021f2:	56                   	push   %esi
  8021f3:	50                   	push   %eax
  8021f4:	68 78 29 80 00       	push   $0x802978
  8021f9:	e8 ac df ff ff       	call   8001aa <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8021fe:	83 c4 18             	add    $0x18,%esp
  802201:	53                   	push   %ebx
  802202:	ff 75 10             	pushl  0x10(%ebp)
  802205:	e8 4b df ff ff       	call   800155 <vcprintf>
	cprintf("\n");
  80220a:	c7 04 24 43 28 80 00 	movl   $0x802843,(%esp)
  802211:	e8 94 df ff ff       	call   8001aa <cprintf>
  802216:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802219:	cc                   	int3   
  80221a:	eb fd                	jmp    802219 <_panic+0x47>

0080221c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80221c:	f3 0f 1e fb          	endbr32 
  802220:	55                   	push   %ebp
  802221:	89 e5                	mov    %esp,%ebp
  802223:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802226:	89 c2                	mov    %eax,%edx
  802228:	c1 ea 16             	shr    $0x16,%edx
  80222b:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802232:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802237:	f6 c1 01             	test   $0x1,%cl
  80223a:	74 1c                	je     802258 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  80223c:	c1 e8 0c             	shr    $0xc,%eax
  80223f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802246:	a8 01                	test   $0x1,%al
  802248:	74 0e                	je     802258 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80224a:	c1 e8 0c             	shr    $0xc,%eax
  80224d:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802254:	ef 
  802255:	0f b7 d2             	movzwl %dx,%edx
}
  802258:	89 d0                	mov    %edx,%eax
  80225a:	5d                   	pop    %ebp
  80225b:	c3                   	ret    
  80225c:	66 90                	xchg   %ax,%ax
  80225e:	66 90                	xchg   %ax,%ax

00802260 <__udivdi3>:
  802260:	f3 0f 1e fb          	endbr32 
  802264:	55                   	push   %ebp
  802265:	57                   	push   %edi
  802266:	56                   	push   %esi
  802267:	53                   	push   %ebx
  802268:	83 ec 1c             	sub    $0x1c,%esp
  80226b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80226f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802273:	8b 74 24 34          	mov    0x34(%esp),%esi
  802277:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80227b:	85 d2                	test   %edx,%edx
  80227d:	75 19                	jne    802298 <__udivdi3+0x38>
  80227f:	39 f3                	cmp    %esi,%ebx
  802281:	76 4d                	jbe    8022d0 <__udivdi3+0x70>
  802283:	31 ff                	xor    %edi,%edi
  802285:	89 e8                	mov    %ebp,%eax
  802287:	89 f2                	mov    %esi,%edx
  802289:	f7 f3                	div    %ebx
  80228b:	89 fa                	mov    %edi,%edx
  80228d:	83 c4 1c             	add    $0x1c,%esp
  802290:	5b                   	pop    %ebx
  802291:	5e                   	pop    %esi
  802292:	5f                   	pop    %edi
  802293:	5d                   	pop    %ebp
  802294:	c3                   	ret    
  802295:	8d 76 00             	lea    0x0(%esi),%esi
  802298:	39 f2                	cmp    %esi,%edx
  80229a:	76 14                	jbe    8022b0 <__udivdi3+0x50>
  80229c:	31 ff                	xor    %edi,%edi
  80229e:	31 c0                	xor    %eax,%eax
  8022a0:	89 fa                	mov    %edi,%edx
  8022a2:	83 c4 1c             	add    $0x1c,%esp
  8022a5:	5b                   	pop    %ebx
  8022a6:	5e                   	pop    %esi
  8022a7:	5f                   	pop    %edi
  8022a8:	5d                   	pop    %ebp
  8022a9:	c3                   	ret    
  8022aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8022b0:	0f bd fa             	bsr    %edx,%edi
  8022b3:	83 f7 1f             	xor    $0x1f,%edi
  8022b6:	75 48                	jne    802300 <__udivdi3+0xa0>
  8022b8:	39 f2                	cmp    %esi,%edx
  8022ba:	72 06                	jb     8022c2 <__udivdi3+0x62>
  8022bc:	31 c0                	xor    %eax,%eax
  8022be:	39 eb                	cmp    %ebp,%ebx
  8022c0:	77 de                	ja     8022a0 <__udivdi3+0x40>
  8022c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8022c7:	eb d7                	jmp    8022a0 <__udivdi3+0x40>
  8022c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022d0:	89 d9                	mov    %ebx,%ecx
  8022d2:	85 db                	test   %ebx,%ebx
  8022d4:	75 0b                	jne    8022e1 <__udivdi3+0x81>
  8022d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8022db:	31 d2                	xor    %edx,%edx
  8022dd:	f7 f3                	div    %ebx
  8022df:	89 c1                	mov    %eax,%ecx
  8022e1:	31 d2                	xor    %edx,%edx
  8022e3:	89 f0                	mov    %esi,%eax
  8022e5:	f7 f1                	div    %ecx
  8022e7:	89 c6                	mov    %eax,%esi
  8022e9:	89 e8                	mov    %ebp,%eax
  8022eb:	89 f7                	mov    %esi,%edi
  8022ed:	f7 f1                	div    %ecx
  8022ef:	89 fa                	mov    %edi,%edx
  8022f1:	83 c4 1c             	add    $0x1c,%esp
  8022f4:	5b                   	pop    %ebx
  8022f5:	5e                   	pop    %esi
  8022f6:	5f                   	pop    %edi
  8022f7:	5d                   	pop    %ebp
  8022f8:	c3                   	ret    
  8022f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802300:	89 f9                	mov    %edi,%ecx
  802302:	b8 20 00 00 00       	mov    $0x20,%eax
  802307:	29 f8                	sub    %edi,%eax
  802309:	d3 e2                	shl    %cl,%edx
  80230b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80230f:	89 c1                	mov    %eax,%ecx
  802311:	89 da                	mov    %ebx,%edx
  802313:	d3 ea                	shr    %cl,%edx
  802315:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802319:	09 d1                	or     %edx,%ecx
  80231b:	89 f2                	mov    %esi,%edx
  80231d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802321:	89 f9                	mov    %edi,%ecx
  802323:	d3 e3                	shl    %cl,%ebx
  802325:	89 c1                	mov    %eax,%ecx
  802327:	d3 ea                	shr    %cl,%edx
  802329:	89 f9                	mov    %edi,%ecx
  80232b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80232f:	89 eb                	mov    %ebp,%ebx
  802331:	d3 e6                	shl    %cl,%esi
  802333:	89 c1                	mov    %eax,%ecx
  802335:	d3 eb                	shr    %cl,%ebx
  802337:	09 de                	or     %ebx,%esi
  802339:	89 f0                	mov    %esi,%eax
  80233b:	f7 74 24 08          	divl   0x8(%esp)
  80233f:	89 d6                	mov    %edx,%esi
  802341:	89 c3                	mov    %eax,%ebx
  802343:	f7 64 24 0c          	mull   0xc(%esp)
  802347:	39 d6                	cmp    %edx,%esi
  802349:	72 15                	jb     802360 <__udivdi3+0x100>
  80234b:	89 f9                	mov    %edi,%ecx
  80234d:	d3 e5                	shl    %cl,%ebp
  80234f:	39 c5                	cmp    %eax,%ebp
  802351:	73 04                	jae    802357 <__udivdi3+0xf7>
  802353:	39 d6                	cmp    %edx,%esi
  802355:	74 09                	je     802360 <__udivdi3+0x100>
  802357:	89 d8                	mov    %ebx,%eax
  802359:	31 ff                	xor    %edi,%edi
  80235b:	e9 40 ff ff ff       	jmp    8022a0 <__udivdi3+0x40>
  802360:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802363:	31 ff                	xor    %edi,%edi
  802365:	e9 36 ff ff ff       	jmp    8022a0 <__udivdi3+0x40>
  80236a:	66 90                	xchg   %ax,%ax
  80236c:	66 90                	xchg   %ax,%ax
  80236e:	66 90                	xchg   %ax,%ax

00802370 <__umoddi3>:
  802370:	f3 0f 1e fb          	endbr32 
  802374:	55                   	push   %ebp
  802375:	57                   	push   %edi
  802376:	56                   	push   %esi
  802377:	53                   	push   %ebx
  802378:	83 ec 1c             	sub    $0x1c,%esp
  80237b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80237f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802383:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802387:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80238b:	85 c0                	test   %eax,%eax
  80238d:	75 19                	jne    8023a8 <__umoddi3+0x38>
  80238f:	39 df                	cmp    %ebx,%edi
  802391:	76 5d                	jbe    8023f0 <__umoddi3+0x80>
  802393:	89 f0                	mov    %esi,%eax
  802395:	89 da                	mov    %ebx,%edx
  802397:	f7 f7                	div    %edi
  802399:	89 d0                	mov    %edx,%eax
  80239b:	31 d2                	xor    %edx,%edx
  80239d:	83 c4 1c             	add    $0x1c,%esp
  8023a0:	5b                   	pop    %ebx
  8023a1:	5e                   	pop    %esi
  8023a2:	5f                   	pop    %edi
  8023a3:	5d                   	pop    %ebp
  8023a4:	c3                   	ret    
  8023a5:	8d 76 00             	lea    0x0(%esi),%esi
  8023a8:	89 f2                	mov    %esi,%edx
  8023aa:	39 d8                	cmp    %ebx,%eax
  8023ac:	76 12                	jbe    8023c0 <__umoddi3+0x50>
  8023ae:	89 f0                	mov    %esi,%eax
  8023b0:	89 da                	mov    %ebx,%edx
  8023b2:	83 c4 1c             	add    $0x1c,%esp
  8023b5:	5b                   	pop    %ebx
  8023b6:	5e                   	pop    %esi
  8023b7:	5f                   	pop    %edi
  8023b8:	5d                   	pop    %ebp
  8023b9:	c3                   	ret    
  8023ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8023c0:	0f bd e8             	bsr    %eax,%ebp
  8023c3:	83 f5 1f             	xor    $0x1f,%ebp
  8023c6:	75 50                	jne    802418 <__umoddi3+0xa8>
  8023c8:	39 d8                	cmp    %ebx,%eax
  8023ca:	0f 82 e0 00 00 00    	jb     8024b0 <__umoddi3+0x140>
  8023d0:	89 d9                	mov    %ebx,%ecx
  8023d2:	39 f7                	cmp    %esi,%edi
  8023d4:	0f 86 d6 00 00 00    	jbe    8024b0 <__umoddi3+0x140>
  8023da:	89 d0                	mov    %edx,%eax
  8023dc:	89 ca                	mov    %ecx,%edx
  8023de:	83 c4 1c             	add    $0x1c,%esp
  8023e1:	5b                   	pop    %ebx
  8023e2:	5e                   	pop    %esi
  8023e3:	5f                   	pop    %edi
  8023e4:	5d                   	pop    %ebp
  8023e5:	c3                   	ret    
  8023e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023ed:	8d 76 00             	lea    0x0(%esi),%esi
  8023f0:	89 fd                	mov    %edi,%ebp
  8023f2:	85 ff                	test   %edi,%edi
  8023f4:	75 0b                	jne    802401 <__umoddi3+0x91>
  8023f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8023fb:	31 d2                	xor    %edx,%edx
  8023fd:	f7 f7                	div    %edi
  8023ff:	89 c5                	mov    %eax,%ebp
  802401:	89 d8                	mov    %ebx,%eax
  802403:	31 d2                	xor    %edx,%edx
  802405:	f7 f5                	div    %ebp
  802407:	89 f0                	mov    %esi,%eax
  802409:	f7 f5                	div    %ebp
  80240b:	89 d0                	mov    %edx,%eax
  80240d:	31 d2                	xor    %edx,%edx
  80240f:	eb 8c                	jmp    80239d <__umoddi3+0x2d>
  802411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802418:	89 e9                	mov    %ebp,%ecx
  80241a:	ba 20 00 00 00       	mov    $0x20,%edx
  80241f:	29 ea                	sub    %ebp,%edx
  802421:	d3 e0                	shl    %cl,%eax
  802423:	89 44 24 08          	mov    %eax,0x8(%esp)
  802427:	89 d1                	mov    %edx,%ecx
  802429:	89 f8                	mov    %edi,%eax
  80242b:	d3 e8                	shr    %cl,%eax
  80242d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802431:	89 54 24 04          	mov    %edx,0x4(%esp)
  802435:	8b 54 24 04          	mov    0x4(%esp),%edx
  802439:	09 c1                	or     %eax,%ecx
  80243b:	89 d8                	mov    %ebx,%eax
  80243d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802441:	89 e9                	mov    %ebp,%ecx
  802443:	d3 e7                	shl    %cl,%edi
  802445:	89 d1                	mov    %edx,%ecx
  802447:	d3 e8                	shr    %cl,%eax
  802449:	89 e9                	mov    %ebp,%ecx
  80244b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80244f:	d3 e3                	shl    %cl,%ebx
  802451:	89 c7                	mov    %eax,%edi
  802453:	89 d1                	mov    %edx,%ecx
  802455:	89 f0                	mov    %esi,%eax
  802457:	d3 e8                	shr    %cl,%eax
  802459:	89 e9                	mov    %ebp,%ecx
  80245b:	89 fa                	mov    %edi,%edx
  80245d:	d3 e6                	shl    %cl,%esi
  80245f:	09 d8                	or     %ebx,%eax
  802461:	f7 74 24 08          	divl   0x8(%esp)
  802465:	89 d1                	mov    %edx,%ecx
  802467:	89 f3                	mov    %esi,%ebx
  802469:	f7 64 24 0c          	mull   0xc(%esp)
  80246d:	89 c6                	mov    %eax,%esi
  80246f:	89 d7                	mov    %edx,%edi
  802471:	39 d1                	cmp    %edx,%ecx
  802473:	72 06                	jb     80247b <__umoddi3+0x10b>
  802475:	75 10                	jne    802487 <__umoddi3+0x117>
  802477:	39 c3                	cmp    %eax,%ebx
  802479:	73 0c                	jae    802487 <__umoddi3+0x117>
  80247b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80247f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802483:	89 d7                	mov    %edx,%edi
  802485:	89 c6                	mov    %eax,%esi
  802487:	89 ca                	mov    %ecx,%edx
  802489:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80248e:	29 f3                	sub    %esi,%ebx
  802490:	19 fa                	sbb    %edi,%edx
  802492:	89 d0                	mov    %edx,%eax
  802494:	d3 e0                	shl    %cl,%eax
  802496:	89 e9                	mov    %ebp,%ecx
  802498:	d3 eb                	shr    %cl,%ebx
  80249a:	d3 ea                	shr    %cl,%edx
  80249c:	09 d8                	or     %ebx,%eax
  80249e:	83 c4 1c             	add    $0x1c,%esp
  8024a1:	5b                   	pop    %ebx
  8024a2:	5e                   	pop    %esi
  8024a3:	5f                   	pop    %edi
  8024a4:	5d                   	pop    %ebp
  8024a5:	c3                   	ret    
  8024a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024ad:	8d 76 00             	lea    0x0(%esi),%esi
  8024b0:	29 fe                	sub    %edi,%esi
  8024b2:	19 c3                	sbb    %eax,%ebx
  8024b4:	89 f2                	mov    %esi,%edx
  8024b6:	89 d9                	mov    %ebx,%ecx
  8024b8:	e9 1d ff ff ff       	jmp    8023da <__umoddi3+0x6a>
