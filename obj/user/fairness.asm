
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
  800046:	81 3d 04 40 80 00 7c 	cmpl   $0xeec0007c,0x804004
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
  80005c:	68 71 1f 80 00       	push   $0x801f71
  800061:	e8 44 01 00 00       	call   8001aa <cprintf>
  800066:	83 c4 10             	add    $0x10,%esp
		while (1)
			ipc_send(envs[1].env_id, 0, 0, 0);
  800069:	a1 c4 00 c0 ee       	mov    0xeec000c4,%eax
  80006e:	6a 00                	push   $0x0
  800070:	6a 00                	push   $0x0
  800072:	6a 00                	push   $0x0
  800074:	50                   	push   %eax
  800075:	e8 12 0e 00 00       	call   800e8c <ipc_send>
  80007a:	83 c4 10             	add    $0x10,%esp
  80007d:	eb ea                	jmp    800069 <umain+0x36>
			ipc_recv(&who, 0, 0);
  80007f:	8d 75 f4             	lea    -0xc(%ebp),%esi
  800082:	83 ec 04             	sub    $0x4,%esp
  800085:	6a 00                	push   $0x0
  800087:	6a 00                	push   $0x0
  800089:	56                   	push   %esi
  80008a:	e8 78 0d 00 00       	call   800e07 <ipc_recv>
			cprintf("%x recv from %x\n", id, who);
  80008f:	83 c4 0c             	add    $0xc,%esp
  800092:	ff 75 f4             	pushl  -0xc(%ebp)
  800095:	53                   	push   %ebx
  800096:	68 60 1f 80 00       	push   $0x801f60
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
  8000c6:	a3 04 40 80 00       	mov    %eax,0x804004

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
  8000f9:	e8 12 10 00 00       	call   801110 <close_all>
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
  800210:	e8 db 1a 00 00       	call   801cf0 <__udivdi3>
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
  80024e:	e8 ad 1b 00 00       	call   801e00 <__umoddi3>
  800253:	83 c4 14             	add    $0x14,%esp
  800256:	0f be 80 92 1f 80 00 	movsbl 0x801f92(%eax),%eax
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
  8002fd:	3e ff 24 85 e0 20 80 	notrack jmp *0x8020e0(,%eax,4)
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
  8003ca:	8b 14 85 40 22 80 00 	mov    0x802240(,%eax,4),%edx
  8003d1:	85 d2                	test   %edx,%edx
  8003d3:	74 18                	je     8003ed <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8003d5:	52                   	push   %edx
  8003d6:	68 95 23 80 00       	push   $0x802395
  8003db:	53                   	push   %ebx
  8003dc:	56                   	push   %esi
  8003dd:	e8 aa fe ff ff       	call   80028c <printfmt>
  8003e2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003e5:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003e8:	e9 66 02 00 00       	jmp    800653 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8003ed:	50                   	push   %eax
  8003ee:	68 aa 1f 80 00       	push   $0x801faa
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
  800415:	b8 a3 1f 80 00       	mov    $0x801fa3,%eax
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
  800b9f:	68 9f 22 80 00       	push   $0x80229f
  800ba4:	6a 23                	push   $0x23
  800ba6:	68 bc 22 80 00       	push   $0x8022bc
  800bab:	e8 b6 10 00 00       	call   801c66 <_panic>

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
  800c2c:	68 9f 22 80 00       	push   $0x80229f
  800c31:	6a 23                	push   $0x23
  800c33:	68 bc 22 80 00       	push   $0x8022bc
  800c38:	e8 29 10 00 00       	call   801c66 <_panic>

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
  800c72:	68 9f 22 80 00       	push   $0x80229f
  800c77:	6a 23                	push   $0x23
  800c79:	68 bc 22 80 00       	push   $0x8022bc
  800c7e:	e8 e3 0f 00 00       	call   801c66 <_panic>

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
  800cb8:	68 9f 22 80 00       	push   $0x80229f
  800cbd:	6a 23                	push   $0x23
  800cbf:	68 bc 22 80 00       	push   $0x8022bc
  800cc4:	e8 9d 0f 00 00       	call   801c66 <_panic>

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
  800cfe:	68 9f 22 80 00       	push   $0x80229f
  800d03:	6a 23                	push   $0x23
  800d05:	68 bc 22 80 00       	push   $0x8022bc
  800d0a:	e8 57 0f 00 00       	call   801c66 <_panic>

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
  800d44:	68 9f 22 80 00       	push   $0x80229f
  800d49:	6a 23                	push   $0x23
  800d4b:	68 bc 22 80 00       	push   $0x8022bc
  800d50:	e8 11 0f 00 00       	call   801c66 <_panic>

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
  800d8a:	68 9f 22 80 00       	push   $0x80229f
  800d8f:	6a 23                	push   $0x23
  800d91:	68 bc 22 80 00       	push   $0x8022bc
  800d96:	e8 cb 0e 00 00       	call   801c66 <_panic>

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
  800df6:	68 9f 22 80 00       	push   $0x80229f
  800dfb:	6a 23                	push   $0x23
  800dfd:	68 bc 22 80 00       	push   $0x8022bc
  800e02:	e8 5f 0e 00 00       	call   801c66 <_panic>

00800e07 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  800e07:	f3 0f 1e fb          	endbr32 
  800e0b:	55                   	push   %ebp
  800e0c:	89 e5                	mov    %esp,%ebp
  800e0e:	56                   	push   %esi
  800e0f:	53                   	push   %ebx
  800e10:	8b 75 08             	mov    0x8(%ebp),%esi
  800e13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e16:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  800e19:	85 c0                	test   %eax,%eax
  800e1b:	74 3d                	je     800e5a <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  800e1d:	83 ec 0c             	sub    $0xc,%esp
  800e20:	50                   	push   %eax
  800e21:	e8 9c ff ff ff       	call   800dc2 <sys_ipc_recv>
  800e26:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  800e29:	85 f6                	test   %esi,%esi
  800e2b:	74 0b                	je     800e38 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  800e2d:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800e33:	8b 52 74             	mov    0x74(%edx),%edx
  800e36:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  800e38:	85 db                	test   %ebx,%ebx
  800e3a:	74 0b                	je     800e47 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  800e3c:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800e42:	8b 52 78             	mov    0x78(%edx),%edx
  800e45:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  800e47:	85 c0                	test   %eax,%eax
  800e49:	78 21                	js     800e6c <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  800e4b:	a1 04 40 80 00       	mov    0x804004,%eax
  800e50:	8b 40 70             	mov    0x70(%eax),%eax
}
  800e53:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e56:	5b                   	pop    %ebx
  800e57:	5e                   	pop    %esi
  800e58:	5d                   	pop    %ebp
  800e59:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  800e5a:	83 ec 0c             	sub    $0xc,%esp
  800e5d:	68 00 00 c0 ee       	push   $0xeec00000
  800e62:	e8 5b ff ff ff       	call   800dc2 <sys_ipc_recv>
  800e67:	83 c4 10             	add    $0x10,%esp
  800e6a:	eb bd                	jmp    800e29 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  800e6c:	85 f6                	test   %esi,%esi
  800e6e:	74 10                	je     800e80 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  800e70:	85 db                	test   %ebx,%ebx
  800e72:	75 df                	jne    800e53 <ipc_recv+0x4c>
  800e74:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  800e7b:	00 00 00 
  800e7e:	eb d3                	jmp    800e53 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  800e80:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  800e87:	00 00 00 
  800e8a:	eb e4                	jmp    800e70 <ipc_recv+0x69>

00800e8c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  800e8c:	f3 0f 1e fb          	endbr32 
  800e90:	55                   	push   %ebp
  800e91:	89 e5                	mov    %esp,%ebp
  800e93:	57                   	push   %edi
  800e94:	56                   	push   %esi
  800e95:	53                   	push   %ebx
  800e96:	83 ec 0c             	sub    $0xc,%esp
  800e99:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e9c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e9f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  800ea2:	85 db                	test   %ebx,%ebx
  800ea4:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  800ea9:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  800eac:	ff 75 14             	pushl  0x14(%ebp)
  800eaf:	53                   	push   %ebx
  800eb0:	56                   	push   %esi
  800eb1:	57                   	push   %edi
  800eb2:	e8 e4 fe ff ff       	call   800d9b <sys_ipc_try_send>
  800eb7:	83 c4 10             	add    $0x10,%esp
  800eba:	85 c0                	test   %eax,%eax
  800ebc:	79 1e                	jns    800edc <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  800ebe:	83 f8 f9             	cmp    $0xfffffff9,%eax
  800ec1:	75 07                	jne    800eca <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  800ec3:	e8 0b fd ff ff       	call   800bd3 <sys_yield>
  800ec8:	eb e2                	jmp    800eac <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  800eca:	50                   	push   %eax
  800ecb:	68 ca 22 80 00       	push   $0x8022ca
  800ed0:	6a 59                	push   $0x59
  800ed2:	68 e5 22 80 00       	push   $0x8022e5
  800ed7:	e8 8a 0d 00 00       	call   801c66 <_panic>
	}
}
  800edc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800edf:	5b                   	pop    %ebx
  800ee0:	5e                   	pop    %esi
  800ee1:	5f                   	pop    %edi
  800ee2:	5d                   	pop    %ebp
  800ee3:	c3                   	ret    

00800ee4 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  800ee4:	f3 0f 1e fb          	endbr32 
  800ee8:	55                   	push   %ebp
  800ee9:	89 e5                	mov    %esp,%ebp
  800eeb:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  800eee:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  800ef3:	6b d0 7c             	imul   $0x7c,%eax,%edx
  800ef6:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800efc:	8b 52 50             	mov    0x50(%edx),%edx
  800eff:	39 ca                	cmp    %ecx,%edx
  800f01:	74 11                	je     800f14 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  800f03:	83 c0 01             	add    $0x1,%eax
  800f06:	3d 00 04 00 00       	cmp    $0x400,%eax
  800f0b:	75 e6                	jne    800ef3 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  800f0d:	b8 00 00 00 00       	mov    $0x0,%eax
  800f12:	eb 0b                	jmp    800f1f <ipc_find_env+0x3b>
			return envs[i].env_id;
  800f14:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f17:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f1c:	8b 40 48             	mov    0x48(%eax),%eax
}
  800f1f:	5d                   	pop    %ebp
  800f20:	c3                   	ret    

00800f21 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f21:	f3 0f 1e fb          	endbr32 
  800f25:	55                   	push   %ebp
  800f26:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	05 00 00 00 30       	add    $0x30000000,%eax
  800f30:	c1 e8 0c             	shr    $0xc,%eax
}
  800f33:	5d                   	pop    %ebp
  800f34:	c3                   	ret    

00800f35 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f35:	f3 0f 1e fb          	endbr32 
  800f39:	55                   	push   %ebp
  800f3a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3f:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800f44:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f49:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f4e:	5d                   	pop    %ebp
  800f4f:	c3                   	ret    

00800f50 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f50:	f3 0f 1e fb          	endbr32 
  800f54:	55                   	push   %ebp
  800f55:	89 e5                	mov    %esp,%ebp
  800f57:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f5c:	89 c2                	mov    %eax,%edx
  800f5e:	c1 ea 16             	shr    $0x16,%edx
  800f61:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f68:	f6 c2 01             	test   $0x1,%dl
  800f6b:	74 2d                	je     800f9a <fd_alloc+0x4a>
  800f6d:	89 c2                	mov    %eax,%edx
  800f6f:	c1 ea 0c             	shr    $0xc,%edx
  800f72:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f79:	f6 c2 01             	test   $0x1,%dl
  800f7c:	74 1c                	je     800f9a <fd_alloc+0x4a>
  800f7e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f83:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f88:	75 d2                	jne    800f5c <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800f93:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f98:	eb 0a                	jmp    800fa4 <fd_alloc+0x54>
			*fd_store = fd;
  800f9a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f9d:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fa4:	5d                   	pop    %ebp
  800fa5:	c3                   	ret    

00800fa6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800fa6:	f3 0f 1e fb          	endbr32 
  800faa:	55                   	push   %ebp
  800fab:	89 e5                	mov    %esp,%ebp
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800fb0:	83 f8 1f             	cmp    $0x1f,%eax
  800fb3:	77 30                	ja     800fe5 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800fb5:	c1 e0 0c             	shl    $0xc,%eax
  800fb8:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800fbd:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800fc3:	f6 c2 01             	test   $0x1,%dl
  800fc6:	74 24                	je     800fec <fd_lookup+0x46>
  800fc8:	89 c2                	mov    %eax,%edx
  800fca:	c1 ea 0c             	shr    $0xc,%edx
  800fcd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fd4:	f6 c2 01             	test   $0x1,%dl
  800fd7:	74 1a                	je     800ff3 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800fd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fdc:	89 02                	mov    %eax,(%edx)
	return 0;
  800fde:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fe3:	5d                   	pop    %ebp
  800fe4:	c3                   	ret    
		return -E_INVAL;
  800fe5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fea:	eb f7                	jmp    800fe3 <fd_lookup+0x3d>
		return -E_INVAL;
  800fec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ff1:	eb f0                	jmp    800fe3 <fd_lookup+0x3d>
  800ff3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ff8:	eb e9                	jmp    800fe3 <fd_lookup+0x3d>

00800ffa <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800ffa:	f3 0f 1e fb          	endbr32 
  800ffe:	55                   	push   %ebp
  800fff:	89 e5                	mov    %esp,%ebp
  801001:	83 ec 08             	sub    $0x8,%esp
  801004:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801007:	ba 6c 23 80 00       	mov    $0x80236c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80100c:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801011:	39 08                	cmp    %ecx,(%eax)
  801013:	74 33                	je     801048 <dev_lookup+0x4e>
  801015:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801018:	8b 02                	mov    (%edx),%eax
  80101a:	85 c0                	test   %eax,%eax
  80101c:	75 f3                	jne    801011 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80101e:	a1 04 40 80 00       	mov    0x804004,%eax
  801023:	8b 40 48             	mov    0x48(%eax),%eax
  801026:	83 ec 04             	sub    $0x4,%esp
  801029:	51                   	push   %ecx
  80102a:	50                   	push   %eax
  80102b:	68 f0 22 80 00       	push   $0x8022f0
  801030:	e8 75 f1 ff ff       	call   8001aa <cprintf>
	*dev = 0;
  801035:	8b 45 0c             	mov    0xc(%ebp),%eax
  801038:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80103e:	83 c4 10             	add    $0x10,%esp
  801041:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801046:	c9                   	leave  
  801047:	c3                   	ret    
			*dev = devtab[i];
  801048:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80104b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80104d:	b8 00 00 00 00       	mov    $0x0,%eax
  801052:	eb f2                	jmp    801046 <dev_lookup+0x4c>

00801054 <fd_close>:
{
  801054:	f3 0f 1e fb          	endbr32 
  801058:	55                   	push   %ebp
  801059:	89 e5                	mov    %esp,%ebp
  80105b:	57                   	push   %edi
  80105c:	56                   	push   %esi
  80105d:	53                   	push   %ebx
  80105e:	83 ec 24             	sub    $0x24,%esp
  801061:	8b 75 08             	mov    0x8(%ebp),%esi
  801064:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801067:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80106a:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80106b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801071:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801074:	50                   	push   %eax
  801075:	e8 2c ff ff ff       	call   800fa6 <fd_lookup>
  80107a:	89 c3                	mov    %eax,%ebx
  80107c:	83 c4 10             	add    $0x10,%esp
  80107f:	85 c0                	test   %eax,%eax
  801081:	78 05                	js     801088 <fd_close+0x34>
	    || fd != fd2)
  801083:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801086:	74 16                	je     80109e <fd_close+0x4a>
		return (must_exist ? r : 0);
  801088:	89 f8                	mov    %edi,%eax
  80108a:	84 c0                	test   %al,%al
  80108c:	b8 00 00 00 00       	mov    $0x0,%eax
  801091:	0f 44 d8             	cmove  %eax,%ebx
}
  801094:	89 d8                	mov    %ebx,%eax
  801096:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801099:	5b                   	pop    %ebx
  80109a:	5e                   	pop    %esi
  80109b:	5f                   	pop    %edi
  80109c:	5d                   	pop    %ebp
  80109d:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80109e:	83 ec 08             	sub    $0x8,%esp
  8010a1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8010a4:	50                   	push   %eax
  8010a5:	ff 36                	pushl  (%esi)
  8010a7:	e8 4e ff ff ff       	call   800ffa <dev_lookup>
  8010ac:	89 c3                	mov    %eax,%ebx
  8010ae:	83 c4 10             	add    $0x10,%esp
  8010b1:	85 c0                	test   %eax,%eax
  8010b3:	78 1a                	js     8010cf <fd_close+0x7b>
		if (dev->dev_close)
  8010b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010b8:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8010bb:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8010c0:	85 c0                	test   %eax,%eax
  8010c2:	74 0b                	je     8010cf <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8010c4:	83 ec 0c             	sub    $0xc,%esp
  8010c7:	56                   	push   %esi
  8010c8:	ff d0                	call   *%eax
  8010ca:	89 c3                	mov    %eax,%ebx
  8010cc:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8010cf:	83 ec 08             	sub    $0x8,%esp
  8010d2:	56                   	push   %esi
  8010d3:	6a 00                	push   $0x0
  8010d5:	e8 a9 fb ff ff       	call   800c83 <sys_page_unmap>
	return r;
  8010da:	83 c4 10             	add    $0x10,%esp
  8010dd:	eb b5                	jmp    801094 <fd_close+0x40>

008010df <close>:

int
close(int fdnum)
{
  8010df:	f3 0f 1e fb          	endbr32 
  8010e3:	55                   	push   %ebp
  8010e4:	89 e5                	mov    %esp,%ebp
  8010e6:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010ec:	50                   	push   %eax
  8010ed:	ff 75 08             	pushl  0x8(%ebp)
  8010f0:	e8 b1 fe ff ff       	call   800fa6 <fd_lookup>
  8010f5:	83 c4 10             	add    $0x10,%esp
  8010f8:	85 c0                	test   %eax,%eax
  8010fa:	79 02                	jns    8010fe <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8010fc:	c9                   	leave  
  8010fd:	c3                   	ret    
		return fd_close(fd, 1);
  8010fe:	83 ec 08             	sub    $0x8,%esp
  801101:	6a 01                	push   $0x1
  801103:	ff 75 f4             	pushl  -0xc(%ebp)
  801106:	e8 49 ff ff ff       	call   801054 <fd_close>
  80110b:	83 c4 10             	add    $0x10,%esp
  80110e:	eb ec                	jmp    8010fc <close+0x1d>

00801110 <close_all>:

void
close_all(void)
{
  801110:	f3 0f 1e fb          	endbr32 
  801114:	55                   	push   %ebp
  801115:	89 e5                	mov    %esp,%ebp
  801117:	53                   	push   %ebx
  801118:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80111b:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801120:	83 ec 0c             	sub    $0xc,%esp
  801123:	53                   	push   %ebx
  801124:	e8 b6 ff ff ff       	call   8010df <close>
	for (i = 0; i < MAXFD; i++)
  801129:	83 c3 01             	add    $0x1,%ebx
  80112c:	83 c4 10             	add    $0x10,%esp
  80112f:	83 fb 20             	cmp    $0x20,%ebx
  801132:	75 ec                	jne    801120 <close_all+0x10>
}
  801134:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801137:	c9                   	leave  
  801138:	c3                   	ret    

00801139 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801139:	f3 0f 1e fb          	endbr32 
  80113d:	55                   	push   %ebp
  80113e:	89 e5                	mov    %esp,%ebp
  801140:	57                   	push   %edi
  801141:	56                   	push   %esi
  801142:	53                   	push   %ebx
  801143:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801146:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801149:	50                   	push   %eax
  80114a:	ff 75 08             	pushl  0x8(%ebp)
  80114d:	e8 54 fe ff ff       	call   800fa6 <fd_lookup>
  801152:	89 c3                	mov    %eax,%ebx
  801154:	83 c4 10             	add    $0x10,%esp
  801157:	85 c0                	test   %eax,%eax
  801159:	0f 88 81 00 00 00    	js     8011e0 <dup+0xa7>
		return r;
	close(newfdnum);
  80115f:	83 ec 0c             	sub    $0xc,%esp
  801162:	ff 75 0c             	pushl  0xc(%ebp)
  801165:	e8 75 ff ff ff       	call   8010df <close>

	newfd = INDEX2FD(newfdnum);
  80116a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80116d:	c1 e6 0c             	shl    $0xc,%esi
  801170:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801176:	83 c4 04             	add    $0x4,%esp
  801179:	ff 75 e4             	pushl  -0x1c(%ebp)
  80117c:	e8 b4 fd ff ff       	call   800f35 <fd2data>
  801181:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801183:	89 34 24             	mov    %esi,(%esp)
  801186:	e8 aa fd ff ff       	call   800f35 <fd2data>
  80118b:	83 c4 10             	add    $0x10,%esp
  80118e:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801190:	89 d8                	mov    %ebx,%eax
  801192:	c1 e8 16             	shr    $0x16,%eax
  801195:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80119c:	a8 01                	test   $0x1,%al
  80119e:	74 11                	je     8011b1 <dup+0x78>
  8011a0:	89 d8                	mov    %ebx,%eax
  8011a2:	c1 e8 0c             	shr    $0xc,%eax
  8011a5:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011ac:	f6 c2 01             	test   $0x1,%dl
  8011af:	75 39                	jne    8011ea <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8011b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011b4:	89 d0                	mov    %edx,%eax
  8011b6:	c1 e8 0c             	shr    $0xc,%eax
  8011b9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011c0:	83 ec 0c             	sub    $0xc,%esp
  8011c3:	25 07 0e 00 00       	and    $0xe07,%eax
  8011c8:	50                   	push   %eax
  8011c9:	56                   	push   %esi
  8011ca:	6a 00                	push   $0x0
  8011cc:	52                   	push   %edx
  8011cd:	6a 00                	push   $0x0
  8011cf:	e8 69 fa ff ff       	call   800c3d <sys_page_map>
  8011d4:	89 c3                	mov    %eax,%ebx
  8011d6:	83 c4 20             	add    $0x20,%esp
  8011d9:	85 c0                	test   %eax,%eax
  8011db:	78 31                	js     80120e <dup+0xd5>
		goto err;

	return newfdnum;
  8011dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8011e0:	89 d8                	mov    %ebx,%eax
  8011e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011e5:	5b                   	pop    %ebx
  8011e6:	5e                   	pop    %esi
  8011e7:	5f                   	pop    %edi
  8011e8:	5d                   	pop    %ebp
  8011e9:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8011ea:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011f1:	83 ec 0c             	sub    $0xc,%esp
  8011f4:	25 07 0e 00 00       	and    $0xe07,%eax
  8011f9:	50                   	push   %eax
  8011fa:	57                   	push   %edi
  8011fb:	6a 00                	push   $0x0
  8011fd:	53                   	push   %ebx
  8011fe:	6a 00                	push   $0x0
  801200:	e8 38 fa ff ff       	call   800c3d <sys_page_map>
  801205:	89 c3                	mov    %eax,%ebx
  801207:	83 c4 20             	add    $0x20,%esp
  80120a:	85 c0                	test   %eax,%eax
  80120c:	79 a3                	jns    8011b1 <dup+0x78>
	sys_page_unmap(0, newfd);
  80120e:	83 ec 08             	sub    $0x8,%esp
  801211:	56                   	push   %esi
  801212:	6a 00                	push   $0x0
  801214:	e8 6a fa ff ff       	call   800c83 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801219:	83 c4 08             	add    $0x8,%esp
  80121c:	57                   	push   %edi
  80121d:	6a 00                	push   $0x0
  80121f:	e8 5f fa ff ff       	call   800c83 <sys_page_unmap>
	return r;
  801224:	83 c4 10             	add    $0x10,%esp
  801227:	eb b7                	jmp    8011e0 <dup+0xa7>

00801229 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801229:	f3 0f 1e fb          	endbr32 
  80122d:	55                   	push   %ebp
  80122e:	89 e5                	mov    %esp,%ebp
  801230:	53                   	push   %ebx
  801231:	83 ec 1c             	sub    $0x1c,%esp
  801234:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801237:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80123a:	50                   	push   %eax
  80123b:	53                   	push   %ebx
  80123c:	e8 65 fd ff ff       	call   800fa6 <fd_lookup>
  801241:	83 c4 10             	add    $0x10,%esp
  801244:	85 c0                	test   %eax,%eax
  801246:	78 3f                	js     801287 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801248:	83 ec 08             	sub    $0x8,%esp
  80124b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80124e:	50                   	push   %eax
  80124f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801252:	ff 30                	pushl  (%eax)
  801254:	e8 a1 fd ff ff       	call   800ffa <dev_lookup>
  801259:	83 c4 10             	add    $0x10,%esp
  80125c:	85 c0                	test   %eax,%eax
  80125e:	78 27                	js     801287 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801260:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801263:	8b 42 08             	mov    0x8(%edx),%eax
  801266:	83 e0 03             	and    $0x3,%eax
  801269:	83 f8 01             	cmp    $0x1,%eax
  80126c:	74 1e                	je     80128c <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80126e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801271:	8b 40 08             	mov    0x8(%eax),%eax
  801274:	85 c0                	test   %eax,%eax
  801276:	74 35                	je     8012ad <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801278:	83 ec 04             	sub    $0x4,%esp
  80127b:	ff 75 10             	pushl  0x10(%ebp)
  80127e:	ff 75 0c             	pushl  0xc(%ebp)
  801281:	52                   	push   %edx
  801282:	ff d0                	call   *%eax
  801284:	83 c4 10             	add    $0x10,%esp
}
  801287:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80128a:	c9                   	leave  
  80128b:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80128c:	a1 04 40 80 00       	mov    0x804004,%eax
  801291:	8b 40 48             	mov    0x48(%eax),%eax
  801294:	83 ec 04             	sub    $0x4,%esp
  801297:	53                   	push   %ebx
  801298:	50                   	push   %eax
  801299:	68 31 23 80 00       	push   $0x802331
  80129e:	e8 07 ef ff ff       	call   8001aa <cprintf>
		return -E_INVAL;
  8012a3:	83 c4 10             	add    $0x10,%esp
  8012a6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012ab:	eb da                	jmp    801287 <read+0x5e>
		return -E_NOT_SUPP;
  8012ad:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012b2:	eb d3                	jmp    801287 <read+0x5e>

008012b4 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8012b4:	f3 0f 1e fb          	endbr32 
  8012b8:	55                   	push   %ebp
  8012b9:	89 e5                	mov    %esp,%ebp
  8012bb:	57                   	push   %edi
  8012bc:	56                   	push   %esi
  8012bd:	53                   	push   %ebx
  8012be:	83 ec 0c             	sub    $0xc,%esp
  8012c1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012c4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8012c7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012cc:	eb 02                	jmp    8012d0 <readn+0x1c>
  8012ce:	01 c3                	add    %eax,%ebx
  8012d0:	39 f3                	cmp    %esi,%ebx
  8012d2:	73 21                	jae    8012f5 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012d4:	83 ec 04             	sub    $0x4,%esp
  8012d7:	89 f0                	mov    %esi,%eax
  8012d9:	29 d8                	sub    %ebx,%eax
  8012db:	50                   	push   %eax
  8012dc:	89 d8                	mov    %ebx,%eax
  8012de:	03 45 0c             	add    0xc(%ebp),%eax
  8012e1:	50                   	push   %eax
  8012e2:	57                   	push   %edi
  8012e3:	e8 41 ff ff ff       	call   801229 <read>
		if (m < 0)
  8012e8:	83 c4 10             	add    $0x10,%esp
  8012eb:	85 c0                	test   %eax,%eax
  8012ed:	78 04                	js     8012f3 <readn+0x3f>
			return m;
		if (m == 0)
  8012ef:	75 dd                	jne    8012ce <readn+0x1a>
  8012f1:	eb 02                	jmp    8012f5 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012f3:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8012f5:	89 d8                	mov    %ebx,%eax
  8012f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012fa:	5b                   	pop    %ebx
  8012fb:	5e                   	pop    %esi
  8012fc:	5f                   	pop    %edi
  8012fd:	5d                   	pop    %ebp
  8012fe:	c3                   	ret    

008012ff <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8012ff:	f3 0f 1e fb          	endbr32 
  801303:	55                   	push   %ebp
  801304:	89 e5                	mov    %esp,%ebp
  801306:	53                   	push   %ebx
  801307:	83 ec 1c             	sub    $0x1c,%esp
  80130a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80130d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801310:	50                   	push   %eax
  801311:	53                   	push   %ebx
  801312:	e8 8f fc ff ff       	call   800fa6 <fd_lookup>
  801317:	83 c4 10             	add    $0x10,%esp
  80131a:	85 c0                	test   %eax,%eax
  80131c:	78 3a                	js     801358 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80131e:	83 ec 08             	sub    $0x8,%esp
  801321:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801324:	50                   	push   %eax
  801325:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801328:	ff 30                	pushl  (%eax)
  80132a:	e8 cb fc ff ff       	call   800ffa <dev_lookup>
  80132f:	83 c4 10             	add    $0x10,%esp
  801332:	85 c0                	test   %eax,%eax
  801334:	78 22                	js     801358 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801336:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801339:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80133d:	74 1e                	je     80135d <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80133f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801342:	8b 52 0c             	mov    0xc(%edx),%edx
  801345:	85 d2                	test   %edx,%edx
  801347:	74 35                	je     80137e <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801349:	83 ec 04             	sub    $0x4,%esp
  80134c:	ff 75 10             	pushl  0x10(%ebp)
  80134f:	ff 75 0c             	pushl  0xc(%ebp)
  801352:	50                   	push   %eax
  801353:	ff d2                	call   *%edx
  801355:	83 c4 10             	add    $0x10,%esp
}
  801358:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80135b:	c9                   	leave  
  80135c:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80135d:	a1 04 40 80 00       	mov    0x804004,%eax
  801362:	8b 40 48             	mov    0x48(%eax),%eax
  801365:	83 ec 04             	sub    $0x4,%esp
  801368:	53                   	push   %ebx
  801369:	50                   	push   %eax
  80136a:	68 4d 23 80 00       	push   $0x80234d
  80136f:	e8 36 ee ff ff       	call   8001aa <cprintf>
		return -E_INVAL;
  801374:	83 c4 10             	add    $0x10,%esp
  801377:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80137c:	eb da                	jmp    801358 <write+0x59>
		return -E_NOT_SUPP;
  80137e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801383:	eb d3                	jmp    801358 <write+0x59>

00801385 <seek>:

int
seek(int fdnum, off_t offset)
{
  801385:	f3 0f 1e fb          	endbr32 
  801389:	55                   	push   %ebp
  80138a:	89 e5                	mov    %esp,%ebp
  80138c:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80138f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801392:	50                   	push   %eax
  801393:	ff 75 08             	pushl  0x8(%ebp)
  801396:	e8 0b fc ff ff       	call   800fa6 <fd_lookup>
  80139b:	83 c4 10             	add    $0x10,%esp
  80139e:	85 c0                	test   %eax,%eax
  8013a0:	78 0e                	js     8013b0 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8013a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013a8:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8013ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013b0:	c9                   	leave  
  8013b1:	c3                   	ret    

008013b2 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8013b2:	f3 0f 1e fb          	endbr32 
  8013b6:	55                   	push   %ebp
  8013b7:	89 e5                	mov    %esp,%ebp
  8013b9:	53                   	push   %ebx
  8013ba:	83 ec 1c             	sub    $0x1c,%esp
  8013bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013c3:	50                   	push   %eax
  8013c4:	53                   	push   %ebx
  8013c5:	e8 dc fb ff ff       	call   800fa6 <fd_lookup>
  8013ca:	83 c4 10             	add    $0x10,%esp
  8013cd:	85 c0                	test   %eax,%eax
  8013cf:	78 37                	js     801408 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013d1:	83 ec 08             	sub    $0x8,%esp
  8013d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013d7:	50                   	push   %eax
  8013d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013db:	ff 30                	pushl  (%eax)
  8013dd:	e8 18 fc ff ff       	call   800ffa <dev_lookup>
  8013e2:	83 c4 10             	add    $0x10,%esp
  8013e5:	85 c0                	test   %eax,%eax
  8013e7:	78 1f                	js     801408 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ec:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013f0:	74 1b                	je     80140d <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8013f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013f5:	8b 52 18             	mov    0x18(%edx),%edx
  8013f8:	85 d2                	test   %edx,%edx
  8013fa:	74 32                	je     80142e <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8013fc:	83 ec 08             	sub    $0x8,%esp
  8013ff:	ff 75 0c             	pushl  0xc(%ebp)
  801402:	50                   	push   %eax
  801403:	ff d2                	call   *%edx
  801405:	83 c4 10             	add    $0x10,%esp
}
  801408:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80140b:	c9                   	leave  
  80140c:	c3                   	ret    
			thisenv->env_id, fdnum);
  80140d:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801412:	8b 40 48             	mov    0x48(%eax),%eax
  801415:	83 ec 04             	sub    $0x4,%esp
  801418:	53                   	push   %ebx
  801419:	50                   	push   %eax
  80141a:	68 10 23 80 00       	push   $0x802310
  80141f:	e8 86 ed ff ff       	call   8001aa <cprintf>
		return -E_INVAL;
  801424:	83 c4 10             	add    $0x10,%esp
  801427:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80142c:	eb da                	jmp    801408 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80142e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801433:	eb d3                	jmp    801408 <ftruncate+0x56>

00801435 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801435:	f3 0f 1e fb          	endbr32 
  801439:	55                   	push   %ebp
  80143a:	89 e5                	mov    %esp,%ebp
  80143c:	53                   	push   %ebx
  80143d:	83 ec 1c             	sub    $0x1c,%esp
  801440:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801443:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801446:	50                   	push   %eax
  801447:	ff 75 08             	pushl  0x8(%ebp)
  80144a:	e8 57 fb ff ff       	call   800fa6 <fd_lookup>
  80144f:	83 c4 10             	add    $0x10,%esp
  801452:	85 c0                	test   %eax,%eax
  801454:	78 4b                	js     8014a1 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801456:	83 ec 08             	sub    $0x8,%esp
  801459:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80145c:	50                   	push   %eax
  80145d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801460:	ff 30                	pushl  (%eax)
  801462:	e8 93 fb ff ff       	call   800ffa <dev_lookup>
  801467:	83 c4 10             	add    $0x10,%esp
  80146a:	85 c0                	test   %eax,%eax
  80146c:	78 33                	js     8014a1 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80146e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801471:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801475:	74 2f                	je     8014a6 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801477:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80147a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801481:	00 00 00 
	stat->st_isdir = 0;
  801484:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80148b:	00 00 00 
	stat->st_dev = dev;
  80148e:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801494:	83 ec 08             	sub    $0x8,%esp
  801497:	53                   	push   %ebx
  801498:	ff 75 f0             	pushl  -0x10(%ebp)
  80149b:	ff 50 14             	call   *0x14(%eax)
  80149e:	83 c4 10             	add    $0x10,%esp
}
  8014a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014a4:	c9                   	leave  
  8014a5:	c3                   	ret    
		return -E_NOT_SUPP;
  8014a6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014ab:	eb f4                	jmp    8014a1 <fstat+0x6c>

008014ad <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8014ad:	f3 0f 1e fb          	endbr32 
  8014b1:	55                   	push   %ebp
  8014b2:	89 e5                	mov    %esp,%ebp
  8014b4:	56                   	push   %esi
  8014b5:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8014b6:	83 ec 08             	sub    $0x8,%esp
  8014b9:	6a 00                	push   $0x0
  8014bb:	ff 75 08             	pushl  0x8(%ebp)
  8014be:	e8 fb 01 00 00       	call   8016be <open>
  8014c3:	89 c3                	mov    %eax,%ebx
  8014c5:	83 c4 10             	add    $0x10,%esp
  8014c8:	85 c0                	test   %eax,%eax
  8014ca:	78 1b                	js     8014e7 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8014cc:	83 ec 08             	sub    $0x8,%esp
  8014cf:	ff 75 0c             	pushl  0xc(%ebp)
  8014d2:	50                   	push   %eax
  8014d3:	e8 5d ff ff ff       	call   801435 <fstat>
  8014d8:	89 c6                	mov    %eax,%esi
	close(fd);
  8014da:	89 1c 24             	mov    %ebx,(%esp)
  8014dd:	e8 fd fb ff ff       	call   8010df <close>
	return r;
  8014e2:	83 c4 10             	add    $0x10,%esp
  8014e5:	89 f3                	mov    %esi,%ebx
}
  8014e7:	89 d8                	mov    %ebx,%eax
  8014e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014ec:	5b                   	pop    %ebx
  8014ed:	5e                   	pop    %esi
  8014ee:	5d                   	pop    %ebp
  8014ef:	c3                   	ret    

008014f0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
  8014f3:	56                   	push   %esi
  8014f4:	53                   	push   %ebx
  8014f5:	89 c6                	mov    %eax,%esi
  8014f7:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8014f9:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801500:	74 27                	je     801529 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801502:	6a 07                	push   $0x7
  801504:	68 00 50 80 00       	push   $0x805000
  801509:	56                   	push   %esi
  80150a:	ff 35 00 40 80 00    	pushl  0x804000
  801510:	e8 77 f9 ff ff       	call   800e8c <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801515:	83 c4 0c             	add    $0xc,%esp
  801518:	6a 00                	push   $0x0
  80151a:	53                   	push   %ebx
  80151b:	6a 00                	push   $0x0
  80151d:	e8 e5 f8 ff ff       	call   800e07 <ipc_recv>
}
  801522:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801525:	5b                   	pop    %ebx
  801526:	5e                   	pop    %esi
  801527:	5d                   	pop    %ebp
  801528:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801529:	83 ec 0c             	sub    $0xc,%esp
  80152c:	6a 01                	push   $0x1
  80152e:	e8 b1 f9 ff ff       	call   800ee4 <ipc_find_env>
  801533:	a3 00 40 80 00       	mov    %eax,0x804000
  801538:	83 c4 10             	add    $0x10,%esp
  80153b:	eb c5                	jmp    801502 <fsipc+0x12>

0080153d <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80153d:	f3 0f 1e fb          	endbr32 
  801541:	55                   	push   %ebp
  801542:	89 e5                	mov    %esp,%ebp
  801544:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801547:	8b 45 08             	mov    0x8(%ebp),%eax
  80154a:	8b 40 0c             	mov    0xc(%eax),%eax
  80154d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801552:	8b 45 0c             	mov    0xc(%ebp),%eax
  801555:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80155a:	ba 00 00 00 00       	mov    $0x0,%edx
  80155f:	b8 02 00 00 00       	mov    $0x2,%eax
  801564:	e8 87 ff ff ff       	call   8014f0 <fsipc>
}
  801569:	c9                   	leave  
  80156a:	c3                   	ret    

0080156b <devfile_flush>:
{
  80156b:	f3 0f 1e fb          	endbr32 
  80156f:	55                   	push   %ebp
  801570:	89 e5                	mov    %esp,%ebp
  801572:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801575:	8b 45 08             	mov    0x8(%ebp),%eax
  801578:	8b 40 0c             	mov    0xc(%eax),%eax
  80157b:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801580:	ba 00 00 00 00       	mov    $0x0,%edx
  801585:	b8 06 00 00 00       	mov    $0x6,%eax
  80158a:	e8 61 ff ff ff       	call   8014f0 <fsipc>
}
  80158f:	c9                   	leave  
  801590:	c3                   	ret    

00801591 <devfile_stat>:
{
  801591:	f3 0f 1e fb          	endbr32 
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
  801598:	53                   	push   %ebx
  801599:	83 ec 04             	sub    $0x4,%esp
  80159c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80159f:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8015a5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8015af:	b8 05 00 00 00       	mov    $0x5,%eax
  8015b4:	e8 37 ff ff ff       	call   8014f0 <fsipc>
  8015b9:	85 c0                	test   %eax,%eax
  8015bb:	78 2c                	js     8015e9 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8015bd:	83 ec 08             	sub    $0x8,%esp
  8015c0:	68 00 50 80 00       	push   $0x805000
  8015c5:	53                   	push   %ebx
  8015c6:	e8 e9 f1 ff ff       	call   8007b4 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8015cb:	a1 80 50 80 00       	mov    0x805080,%eax
  8015d0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8015d6:	a1 84 50 80 00       	mov    0x805084,%eax
  8015db:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8015e1:	83 c4 10             	add    $0x10,%esp
  8015e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ec:	c9                   	leave  
  8015ed:	c3                   	ret    

008015ee <devfile_write>:
{
  8015ee:	f3 0f 1e fb          	endbr32 
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
  8015f5:	83 ec 0c             	sub    $0xc,%esp
  8015f8:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8015fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8015fe:	8b 52 0c             	mov    0xc(%edx),%edx
  801601:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801607:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80160c:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801611:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  801614:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801619:	50                   	push   %eax
  80161a:	ff 75 0c             	pushl  0xc(%ebp)
  80161d:	68 08 50 80 00       	push   $0x805008
  801622:	e8 43 f3 ff ff       	call   80096a <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801627:	ba 00 00 00 00       	mov    $0x0,%edx
  80162c:	b8 04 00 00 00       	mov    $0x4,%eax
  801631:	e8 ba fe ff ff       	call   8014f0 <fsipc>
}
  801636:	c9                   	leave  
  801637:	c3                   	ret    

00801638 <devfile_read>:
{
  801638:	f3 0f 1e fb          	endbr32 
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
  80163f:	56                   	push   %esi
  801640:	53                   	push   %ebx
  801641:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801644:	8b 45 08             	mov    0x8(%ebp),%eax
  801647:	8b 40 0c             	mov    0xc(%eax),%eax
  80164a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80164f:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801655:	ba 00 00 00 00       	mov    $0x0,%edx
  80165a:	b8 03 00 00 00       	mov    $0x3,%eax
  80165f:	e8 8c fe ff ff       	call   8014f0 <fsipc>
  801664:	89 c3                	mov    %eax,%ebx
  801666:	85 c0                	test   %eax,%eax
  801668:	78 1f                	js     801689 <devfile_read+0x51>
	assert(r <= n);
  80166a:	39 f0                	cmp    %esi,%eax
  80166c:	77 24                	ja     801692 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  80166e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801673:	7f 33                	jg     8016a8 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801675:	83 ec 04             	sub    $0x4,%esp
  801678:	50                   	push   %eax
  801679:	68 00 50 80 00       	push   $0x805000
  80167e:	ff 75 0c             	pushl  0xc(%ebp)
  801681:	e8 e4 f2 ff ff       	call   80096a <memmove>
	return r;
  801686:	83 c4 10             	add    $0x10,%esp
}
  801689:	89 d8                	mov    %ebx,%eax
  80168b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80168e:	5b                   	pop    %ebx
  80168f:	5e                   	pop    %esi
  801690:	5d                   	pop    %ebp
  801691:	c3                   	ret    
	assert(r <= n);
  801692:	68 7c 23 80 00       	push   $0x80237c
  801697:	68 83 23 80 00       	push   $0x802383
  80169c:	6a 7c                	push   $0x7c
  80169e:	68 98 23 80 00       	push   $0x802398
  8016a3:	e8 be 05 00 00       	call   801c66 <_panic>
	assert(r <= PGSIZE);
  8016a8:	68 a3 23 80 00       	push   $0x8023a3
  8016ad:	68 83 23 80 00       	push   $0x802383
  8016b2:	6a 7d                	push   $0x7d
  8016b4:	68 98 23 80 00       	push   $0x802398
  8016b9:	e8 a8 05 00 00       	call   801c66 <_panic>

008016be <open>:
{
  8016be:	f3 0f 1e fb          	endbr32 
  8016c2:	55                   	push   %ebp
  8016c3:	89 e5                	mov    %esp,%ebp
  8016c5:	56                   	push   %esi
  8016c6:	53                   	push   %ebx
  8016c7:	83 ec 1c             	sub    $0x1c,%esp
  8016ca:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8016cd:	56                   	push   %esi
  8016ce:	e8 9e f0 ff ff       	call   800771 <strlen>
  8016d3:	83 c4 10             	add    $0x10,%esp
  8016d6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8016db:	7f 6c                	jg     801749 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8016dd:	83 ec 0c             	sub    $0xc,%esp
  8016e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016e3:	50                   	push   %eax
  8016e4:	e8 67 f8 ff ff       	call   800f50 <fd_alloc>
  8016e9:	89 c3                	mov    %eax,%ebx
  8016eb:	83 c4 10             	add    $0x10,%esp
  8016ee:	85 c0                	test   %eax,%eax
  8016f0:	78 3c                	js     80172e <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8016f2:	83 ec 08             	sub    $0x8,%esp
  8016f5:	56                   	push   %esi
  8016f6:	68 00 50 80 00       	push   $0x805000
  8016fb:	e8 b4 f0 ff ff       	call   8007b4 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801700:	8b 45 0c             	mov    0xc(%ebp),%eax
  801703:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801708:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80170b:	b8 01 00 00 00       	mov    $0x1,%eax
  801710:	e8 db fd ff ff       	call   8014f0 <fsipc>
  801715:	89 c3                	mov    %eax,%ebx
  801717:	83 c4 10             	add    $0x10,%esp
  80171a:	85 c0                	test   %eax,%eax
  80171c:	78 19                	js     801737 <open+0x79>
	return fd2num(fd);
  80171e:	83 ec 0c             	sub    $0xc,%esp
  801721:	ff 75 f4             	pushl  -0xc(%ebp)
  801724:	e8 f8 f7 ff ff       	call   800f21 <fd2num>
  801729:	89 c3                	mov    %eax,%ebx
  80172b:	83 c4 10             	add    $0x10,%esp
}
  80172e:	89 d8                	mov    %ebx,%eax
  801730:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801733:	5b                   	pop    %ebx
  801734:	5e                   	pop    %esi
  801735:	5d                   	pop    %ebp
  801736:	c3                   	ret    
		fd_close(fd, 0);
  801737:	83 ec 08             	sub    $0x8,%esp
  80173a:	6a 00                	push   $0x0
  80173c:	ff 75 f4             	pushl  -0xc(%ebp)
  80173f:	e8 10 f9 ff ff       	call   801054 <fd_close>
		return r;
  801744:	83 c4 10             	add    $0x10,%esp
  801747:	eb e5                	jmp    80172e <open+0x70>
		return -E_BAD_PATH;
  801749:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80174e:	eb de                	jmp    80172e <open+0x70>

00801750 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801750:	f3 0f 1e fb          	endbr32 
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
  801757:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80175a:	ba 00 00 00 00       	mov    $0x0,%edx
  80175f:	b8 08 00 00 00       	mov    $0x8,%eax
  801764:	e8 87 fd ff ff       	call   8014f0 <fsipc>
}
  801769:	c9                   	leave  
  80176a:	c3                   	ret    

0080176b <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80176b:	f3 0f 1e fb          	endbr32 
  80176f:	55                   	push   %ebp
  801770:	89 e5                	mov    %esp,%ebp
  801772:	56                   	push   %esi
  801773:	53                   	push   %ebx
  801774:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801777:	83 ec 0c             	sub    $0xc,%esp
  80177a:	ff 75 08             	pushl  0x8(%ebp)
  80177d:	e8 b3 f7 ff ff       	call   800f35 <fd2data>
  801782:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801784:	83 c4 08             	add    $0x8,%esp
  801787:	68 af 23 80 00       	push   $0x8023af
  80178c:	53                   	push   %ebx
  80178d:	e8 22 f0 ff ff       	call   8007b4 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801792:	8b 46 04             	mov    0x4(%esi),%eax
  801795:	2b 06                	sub    (%esi),%eax
  801797:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80179d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017a4:	00 00 00 
	stat->st_dev = &devpipe;
  8017a7:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8017ae:	30 80 00 
	return 0;
}
  8017b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017b9:	5b                   	pop    %ebx
  8017ba:	5e                   	pop    %esi
  8017bb:	5d                   	pop    %ebp
  8017bc:	c3                   	ret    

008017bd <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8017bd:	f3 0f 1e fb          	endbr32 
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
  8017c4:	53                   	push   %ebx
  8017c5:	83 ec 0c             	sub    $0xc,%esp
  8017c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8017cb:	53                   	push   %ebx
  8017cc:	6a 00                	push   $0x0
  8017ce:	e8 b0 f4 ff ff       	call   800c83 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8017d3:	89 1c 24             	mov    %ebx,(%esp)
  8017d6:	e8 5a f7 ff ff       	call   800f35 <fd2data>
  8017db:	83 c4 08             	add    $0x8,%esp
  8017de:	50                   	push   %eax
  8017df:	6a 00                	push   $0x0
  8017e1:	e8 9d f4 ff ff       	call   800c83 <sys_page_unmap>
}
  8017e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017e9:	c9                   	leave  
  8017ea:	c3                   	ret    

008017eb <_pipeisclosed>:
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
  8017ee:	57                   	push   %edi
  8017ef:	56                   	push   %esi
  8017f0:	53                   	push   %ebx
  8017f1:	83 ec 1c             	sub    $0x1c,%esp
  8017f4:	89 c7                	mov    %eax,%edi
  8017f6:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8017f8:	a1 04 40 80 00       	mov    0x804004,%eax
  8017fd:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801800:	83 ec 0c             	sub    $0xc,%esp
  801803:	57                   	push   %edi
  801804:	e8 a7 04 00 00       	call   801cb0 <pageref>
  801809:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80180c:	89 34 24             	mov    %esi,(%esp)
  80180f:	e8 9c 04 00 00       	call   801cb0 <pageref>
		nn = thisenv->env_runs;
  801814:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80181a:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80181d:	83 c4 10             	add    $0x10,%esp
  801820:	39 cb                	cmp    %ecx,%ebx
  801822:	74 1b                	je     80183f <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801824:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801827:	75 cf                	jne    8017f8 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801829:	8b 42 58             	mov    0x58(%edx),%eax
  80182c:	6a 01                	push   $0x1
  80182e:	50                   	push   %eax
  80182f:	53                   	push   %ebx
  801830:	68 b6 23 80 00       	push   $0x8023b6
  801835:	e8 70 e9 ff ff       	call   8001aa <cprintf>
  80183a:	83 c4 10             	add    $0x10,%esp
  80183d:	eb b9                	jmp    8017f8 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80183f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801842:	0f 94 c0             	sete   %al
  801845:	0f b6 c0             	movzbl %al,%eax
}
  801848:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80184b:	5b                   	pop    %ebx
  80184c:	5e                   	pop    %esi
  80184d:	5f                   	pop    %edi
  80184e:	5d                   	pop    %ebp
  80184f:	c3                   	ret    

00801850 <devpipe_write>:
{
  801850:	f3 0f 1e fb          	endbr32 
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
  801857:	57                   	push   %edi
  801858:	56                   	push   %esi
  801859:	53                   	push   %ebx
  80185a:	83 ec 28             	sub    $0x28,%esp
  80185d:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801860:	56                   	push   %esi
  801861:	e8 cf f6 ff ff       	call   800f35 <fd2data>
  801866:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801868:	83 c4 10             	add    $0x10,%esp
  80186b:	bf 00 00 00 00       	mov    $0x0,%edi
  801870:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801873:	74 4f                	je     8018c4 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801875:	8b 43 04             	mov    0x4(%ebx),%eax
  801878:	8b 0b                	mov    (%ebx),%ecx
  80187a:	8d 51 20             	lea    0x20(%ecx),%edx
  80187d:	39 d0                	cmp    %edx,%eax
  80187f:	72 14                	jb     801895 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801881:	89 da                	mov    %ebx,%edx
  801883:	89 f0                	mov    %esi,%eax
  801885:	e8 61 ff ff ff       	call   8017eb <_pipeisclosed>
  80188a:	85 c0                	test   %eax,%eax
  80188c:	75 3b                	jne    8018c9 <devpipe_write+0x79>
			sys_yield();
  80188e:	e8 40 f3 ff ff       	call   800bd3 <sys_yield>
  801893:	eb e0                	jmp    801875 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801895:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801898:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80189c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80189f:	89 c2                	mov    %eax,%edx
  8018a1:	c1 fa 1f             	sar    $0x1f,%edx
  8018a4:	89 d1                	mov    %edx,%ecx
  8018a6:	c1 e9 1b             	shr    $0x1b,%ecx
  8018a9:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8018ac:	83 e2 1f             	and    $0x1f,%edx
  8018af:	29 ca                	sub    %ecx,%edx
  8018b1:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8018b5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8018b9:	83 c0 01             	add    $0x1,%eax
  8018bc:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8018bf:	83 c7 01             	add    $0x1,%edi
  8018c2:	eb ac                	jmp    801870 <devpipe_write+0x20>
	return i;
  8018c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c7:	eb 05                	jmp    8018ce <devpipe_write+0x7e>
				return 0;
  8018c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018d1:	5b                   	pop    %ebx
  8018d2:	5e                   	pop    %esi
  8018d3:	5f                   	pop    %edi
  8018d4:	5d                   	pop    %ebp
  8018d5:	c3                   	ret    

008018d6 <devpipe_read>:
{
  8018d6:	f3 0f 1e fb          	endbr32 
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	57                   	push   %edi
  8018de:	56                   	push   %esi
  8018df:	53                   	push   %ebx
  8018e0:	83 ec 18             	sub    $0x18,%esp
  8018e3:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8018e6:	57                   	push   %edi
  8018e7:	e8 49 f6 ff ff       	call   800f35 <fd2data>
  8018ec:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8018ee:	83 c4 10             	add    $0x10,%esp
  8018f1:	be 00 00 00 00       	mov    $0x0,%esi
  8018f6:	3b 75 10             	cmp    0x10(%ebp),%esi
  8018f9:	75 14                	jne    80190f <devpipe_read+0x39>
	return i;
  8018fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8018fe:	eb 02                	jmp    801902 <devpipe_read+0x2c>
				return i;
  801900:	89 f0                	mov    %esi,%eax
}
  801902:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801905:	5b                   	pop    %ebx
  801906:	5e                   	pop    %esi
  801907:	5f                   	pop    %edi
  801908:	5d                   	pop    %ebp
  801909:	c3                   	ret    
			sys_yield();
  80190a:	e8 c4 f2 ff ff       	call   800bd3 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80190f:	8b 03                	mov    (%ebx),%eax
  801911:	3b 43 04             	cmp    0x4(%ebx),%eax
  801914:	75 18                	jne    80192e <devpipe_read+0x58>
			if (i > 0)
  801916:	85 f6                	test   %esi,%esi
  801918:	75 e6                	jne    801900 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  80191a:	89 da                	mov    %ebx,%edx
  80191c:	89 f8                	mov    %edi,%eax
  80191e:	e8 c8 fe ff ff       	call   8017eb <_pipeisclosed>
  801923:	85 c0                	test   %eax,%eax
  801925:	74 e3                	je     80190a <devpipe_read+0x34>
				return 0;
  801927:	b8 00 00 00 00       	mov    $0x0,%eax
  80192c:	eb d4                	jmp    801902 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80192e:	99                   	cltd   
  80192f:	c1 ea 1b             	shr    $0x1b,%edx
  801932:	01 d0                	add    %edx,%eax
  801934:	83 e0 1f             	and    $0x1f,%eax
  801937:	29 d0                	sub    %edx,%eax
  801939:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80193e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801941:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801944:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801947:	83 c6 01             	add    $0x1,%esi
  80194a:	eb aa                	jmp    8018f6 <devpipe_read+0x20>

0080194c <pipe>:
{
  80194c:	f3 0f 1e fb          	endbr32 
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
  801953:	56                   	push   %esi
  801954:	53                   	push   %ebx
  801955:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801958:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80195b:	50                   	push   %eax
  80195c:	e8 ef f5 ff ff       	call   800f50 <fd_alloc>
  801961:	89 c3                	mov    %eax,%ebx
  801963:	83 c4 10             	add    $0x10,%esp
  801966:	85 c0                	test   %eax,%eax
  801968:	0f 88 23 01 00 00    	js     801a91 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80196e:	83 ec 04             	sub    $0x4,%esp
  801971:	68 07 04 00 00       	push   $0x407
  801976:	ff 75 f4             	pushl  -0xc(%ebp)
  801979:	6a 00                	push   $0x0
  80197b:	e8 76 f2 ff ff       	call   800bf6 <sys_page_alloc>
  801980:	89 c3                	mov    %eax,%ebx
  801982:	83 c4 10             	add    $0x10,%esp
  801985:	85 c0                	test   %eax,%eax
  801987:	0f 88 04 01 00 00    	js     801a91 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  80198d:	83 ec 0c             	sub    $0xc,%esp
  801990:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801993:	50                   	push   %eax
  801994:	e8 b7 f5 ff ff       	call   800f50 <fd_alloc>
  801999:	89 c3                	mov    %eax,%ebx
  80199b:	83 c4 10             	add    $0x10,%esp
  80199e:	85 c0                	test   %eax,%eax
  8019a0:	0f 88 db 00 00 00    	js     801a81 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019a6:	83 ec 04             	sub    $0x4,%esp
  8019a9:	68 07 04 00 00       	push   $0x407
  8019ae:	ff 75 f0             	pushl  -0x10(%ebp)
  8019b1:	6a 00                	push   $0x0
  8019b3:	e8 3e f2 ff ff       	call   800bf6 <sys_page_alloc>
  8019b8:	89 c3                	mov    %eax,%ebx
  8019ba:	83 c4 10             	add    $0x10,%esp
  8019bd:	85 c0                	test   %eax,%eax
  8019bf:	0f 88 bc 00 00 00    	js     801a81 <pipe+0x135>
	va = fd2data(fd0);
  8019c5:	83 ec 0c             	sub    $0xc,%esp
  8019c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8019cb:	e8 65 f5 ff ff       	call   800f35 <fd2data>
  8019d0:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019d2:	83 c4 0c             	add    $0xc,%esp
  8019d5:	68 07 04 00 00       	push   $0x407
  8019da:	50                   	push   %eax
  8019db:	6a 00                	push   $0x0
  8019dd:	e8 14 f2 ff ff       	call   800bf6 <sys_page_alloc>
  8019e2:	89 c3                	mov    %eax,%ebx
  8019e4:	83 c4 10             	add    $0x10,%esp
  8019e7:	85 c0                	test   %eax,%eax
  8019e9:	0f 88 82 00 00 00    	js     801a71 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019ef:	83 ec 0c             	sub    $0xc,%esp
  8019f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8019f5:	e8 3b f5 ff ff       	call   800f35 <fd2data>
  8019fa:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801a01:	50                   	push   %eax
  801a02:	6a 00                	push   $0x0
  801a04:	56                   	push   %esi
  801a05:	6a 00                	push   $0x0
  801a07:	e8 31 f2 ff ff       	call   800c3d <sys_page_map>
  801a0c:	89 c3                	mov    %eax,%ebx
  801a0e:	83 c4 20             	add    $0x20,%esp
  801a11:	85 c0                	test   %eax,%eax
  801a13:	78 4e                	js     801a63 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801a15:	a1 20 30 80 00       	mov    0x803020,%eax
  801a1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a1d:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801a1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a22:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801a29:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a2c:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801a2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a31:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801a38:	83 ec 0c             	sub    $0xc,%esp
  801a3b:	ff 75 f4             	pushl  -0xc(%ebp)
  801a3e:	e8 de f4 ff ff       	call   800f21 <fd2num>
  801a43:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a46:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801a48:	83 c4 04             	add    $0x4,%esp
  801a4b:	ff 75 f0             	pushl  -0x10(%ebp)
  801a4e:	e8 ce f4 ff ff       	call   800f21 <fd2num>
  801a53:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a56:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801a59:	83 c4 10             	add    $0x10,%esp
  801a5c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a61:	eb 2e                	jmp    801a91 <pipe+0x145>
	sys_page_unmap(0, va);
  801a63:	83 ec 08             	sub    $0x8,%esp
  801a66:	56                   	push   %esi
  801a67:	6a 00                	push   $0x0
  801a69:	e8 15 f2 ff ff       	call   800c83 <sys_page_unmap>
  801a6e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801a71:	83 ec 08             	sub    $0x8,%esp
  801a74:	ff 75 f0             	pushl  -0x10(%ebp)
  801a77:	6a 00                	push   $0x0
  801a79:	e8 05 f2 ff ff       	call   800c83 <sys_page_unmap>
  801a7e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801a81:	83 ec 08             	sub    $0x8,%esp
  801a84:	ff 75 f4             	pushl  -0xc(%ebp)
  801a87:	6a 00                	push   $0x0
  801a89:	e8 f5 f1 ff ff       	call   800c83 <sys_page_unmap>
  801a8e:	83 c4 10             	add    $0x10,%esp
}
  801a91:	89 d8                	mov    %ebx,%eax
  801a93:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a96:	5b                   	pop    %ebx
  801a97:	5e                   	pop    %esi
  801a98:	5d                   	pop    %ebp
  801a99:	c3                   	ret    

00801a9a <pipeisclosed>:
{
  801a9a:	f3 0f 1e fb          	endbr32 
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
  801aa1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801aa4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aa7:	50                   	push   %eax
  801aa8:	ff 75 08             	pushl  0x8(%ebp)
  801aab:	e8 f6 f4 ff ff       	call   800fa6 <fd_lookup>
  801ab0:	83 c4 10             	add    $0x10,%esp
  801ab3:	85 c0                	test   %eax,%eax
  801ab5:	78 18                	js     801acf <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801ab7:	83 ec 0c             	sub    $0xc,%esp
  801aba:	ff 75 f4             	pushl  -0xc(%ebp)
  801abd:	e8 73 f4 ff ff       	call   800f35 <fd2data>
  801ac2:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac7:	e8 1f fd ff ff       	call   8017eb <_pipeisclosed>
  801acc:	83 c4 10             	add    $0x10,%esp
}
  801acf:	c9                   	leave  
  801ad0:	c3                   	ret    

00801ad1 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801ad1:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801ad5:	b8 00 00 00 00       	mov    $0x0,%eax
  801ada:	c3                   	ret    

00801adb <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801adb:	f3 0f 1e fb          	endbr32 
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
  801ae2:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801ae5:	68 ce 23 80 00       	push   $0x8023ce
  801aea:	ff 75 0c             	pushl  0xc(%ebp)
  801aed:	e8 c2 ec ff ff       	call   8007b4 <strcpy>
	return 0;
}
  801af2:	b8 00 00 00 00       	mov    $0x0,%eax
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    

00801af9 <devcons_write>:
{
  801af9:	f3 0f 1e fb          	endbr32 
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
  801b00:	57                   	push   %edi
  801b01:	56                   	push   %esi
  801b02:	53                   	push   %ebx
  801b03:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801b09:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801b0e:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801b14:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b17:	73 31                	jae    801b4a <devcons_write+0x51>
		m = n - tot;
  801b19:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801b1c:	29 f3                	sub    %esi,%ebx
  801b1e:	83 fb 7f             	cmp    $0x7f,%ebx
  801b21:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801b26:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801b29:	83 ec 04             	sub    $0x4,%esp
  801b2c:	53                   	push   %ebx
  801b2d:	89 f0                	mov    %esi,%eax
  801b2f:	03 45 0c             	add    0xc(%ebp),%eax
  801b32:	50                   	push   %eax
  801b33:	57                   	push   %edi
  801b34:	e8 31 ee ff ff       	call   80096a <memmove>
		sys_cputs(buf, m);
  801b39:	83 c4 08             	add    $0x8,%esp
  801b3c:	53                   	push   %ebx
  801b3d:	57                   	push   %edi
  801b3e:	e8 e3 ef ff ff       	call   800b26 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801b43:	01 de                	add    %ebx,%esi
  801b45:	83 c4 10             	add    $0x10,%esp
  801b48:	eb ca                	jmp    801b14 <devcons_write+0x1b>
}
  801b4a:	89 f0                	mov    %esi,%eax
  801b4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b4f:	5b                   	pop    %ebx
  801b50:	5e                   	pop    %esi
  801b51:	5f                   	pop    %edi
  801b52:	5d                   	pop    %ebp
  801b53:	c3                   	ret    

00801b54 <devcons_read>:
{
  801b54:	f3 0f 1e fb          	endbr32 
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
  801b5b:	83 ec 08             	sub    $0x8,%esp
  801b5e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801b63:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b67:	74 21                	je     801b8a <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801b69:	e8 da ef ff ff       	call   800b48 <sys_cgetc>
  801b6e:	85 c0                	test   %eax,%eax
  801b70:	75 07                	jne    801b79 <devcons_read+0x25>
		sys_yield();
  801b72:	e8 5c f0 ff ff       	call   800bd3 <sys_yield>
  801b77:	eb f0                	jmp    801b69 <devcons_read+0x15>
	if (c < 0)
  801b79:	78 0f                	js     801b8a <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801b7b:	83 f8 04             	cmp    $0x4,%eax
  801b7e:	74 0c                	je     801b8c <devcons_read+0x38>
	*(char*)vbuf = c;
  801b80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b83:	88 02                	mov    %al,(%edx)
	return 1;
  801b85:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    
		return 0;
  801b8c:	b8 00 00 00 00       	mov    $0x0,%eax
  801b91:	eb f7                	jmp    801b8a <devcons_read+0x36>

00801b93 <cputchar>:
{
  801b93:	f3 0f 1e fb          	endbr32 
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
  801b9a:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba0:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801ba3:	6a 01                	push   $0x1
  801ba5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ba8:	50                   	push   %eax
  801ba9:	e8 78 ef ff ff       	call   800b26 <sys_cputs>
}
  801bae:	83 c4 10             	add    $0x10,%esp
  801bb1:	c9                   	leave  
  801bb2:	c3                   	ret    

00801bb3 <getchar>:
{
  801bb3:	f3 0f 1e fb          	endbr32 
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
  801bba:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801bbd:	6a 01                	push   $0x1
  801bbf:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801bc2:	50                   	push   %eax
  801bc3:	6a 00                	push   $0x0
  801bc5:	e8 5f f6 ff ff       	call   801229 <read>
	if (r < 0)
  801bca:	83 c4 10             	add    $0x10,%esp
  801bcd:	85 c0                	test   %eax,%eax
  801bcf:	78 06                	js     801bd7 <getchar+0x24>
	if (r < 1)
  801bd1:	74 06                	je     801bd9 <getchar+0x26>
	return c;
  801bd3:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    
		return -E_EOF;
  801bd9:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801bde:	eb f7                	jmp    801bd7 <getchar+0x24>

00801be0 <iscons>:
{
  801be0:	f3 0f 1e fb          	endbr32 
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
  801be7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bed:	50                   	push   %eax
  801bee:	ff 75 08             	pushl  0x8(%ebp)
  801bf1:	e8 b0 f3 ff ff       	call   800fa6 <fd_lookup>
  801bf6:	83 c4 10             	add    $0x10,%esp
  801bf9:	85 c0                	test   %eax,%eax
  801bfb:	78 11                	js     801c0e <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c00:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c06:	39 10                	cmp    %edx,(%eax)
  801c08:	0f 94 c0             	sete   %al
  801c0b:	0f b6 c0             	movzbl %al,%eax
}
  801c0e:	c9                   	leave  
  801c0f:	c3                   	ret    

00801c10 <opencons>:
{
  801c10:	f3 0f 1e fb          	endbr32 
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
  801c17:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801c1a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c1d:	50                   	push   %eax
  801c1e:	e8 2d f3 ff ff       	call   800f50 <fd_alloc>
  801c23:	83 c4 10             	add    $0x10,%esp
  801c26:	85 c0                	test   %eax,%eax
  801c28:	78 3a                	js     801c64 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801c2a:	83 ec 04             	sub    $0x4,%esp
  801c2d:	68 07 04 00 00       	push   $0x407
  801c32:	ff 75 f4             	pushl  -0xc(%ebp)
  801c35:	6a 00                	push   $0x0
  801c37:	e8 ba ef ff ff       	call   800bf6 <sys_page_alloc>
  801c3c:	83 c4 10             	add    $0x10,%esp
  801c3f:	85 c0                	test   %eax,%eax
  801c41:	78 21                	js     801c64 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c46:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c4c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c51:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801c58:	83 ec 0c             	sub    $0xc,%esp
  801c5b:	50                   	push   %eax
  801c5c:	e8 c0 f2 ff ff       	call   800f21 <fd2num>
  801c61:	83 c4 10             	add    $0x10,%esp
}
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    

00801c66 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801c66:	f3 0f 1e fb          	endbr32 
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
  801c6d:	56                   	push   %esi
  801c6e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801c6f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801c72:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801c78:	e8 33 ef ff ff       	call   800bb0 <sys_getenvid>
  801c7d:	83 ec 0c             	sub    $0xc,%esp
  801c80:	ff 75 0c             	pushl  0xc(%ebp)
  801c83:	ff 75 08             	pushl  0x8(%ebp)
  801c86:	56                   	push   %esi
  801c87:	50                   	push   %eax
  801c88:	68 dc 23 80 00       	push   $0x8023dc
  801c8d:	e8 18 e5 ff ff       	call   8001aa <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801c92:	83 c4 18             	add    $0x18,%esp
  801c95:	53                   	push   %ebx
  801c96:	ff 75 10             	pushl  0x10(%ebp)
  801c99:	e8 b7 e4 ff ff       	call   800155 <vcprintf>
	cprintf("\n");
  801c9e:	c7 04 24 e3 22 80 00 	movl   $0x8022e3,(%esp)
  801ca5:	e8 00 e5 ff ff       	call   8001aa <cprintf>
  801caa:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801cad:	cc                   	int3   
  801cae:	eb fd                	jmp    801cad <_panic+0x47>

00801cb0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801cb0:	f3 0f 1e fb          	endbr32 
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
  801cb7:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801cba:	89 c2                	mov    %eax,%edx
  801cbc:	c1 ea 16             	shr    $0x16,%edx
  801cbf:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801cc6:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801ccb:	f6 c1 01             	test   $0x1,%cl
  801cce:	74 1c                	je     801cec <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801cd0:	c1 e8 0c             	shr    $0xc,%eax
  801cd3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801cda:	a8 01                	test   $0x1,%al
  801cdc:	74 0e                	je     801cec <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801cde:	c1 e8 0c             	shr    $0xc,%eax
  801ce1:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801ce8:	ef 
  801ce9:	0f b7 d2             	movzwl %dx,%edx
}
  801cec:	89 d0                	mov    %edx,%eax
  801cee:	5d                   	pop    %ebp
  801cef:	c3                   	ret    

00801cf0 <__udivdi3>:
  801cf0:	f3 0f 1e fb          	endbr32 
  801cf4:	55                   	push   %ebp
  801cf5:	57                   	push   %edi
  801cf6:	56                   	push   %esi
  801cf7:	53                   	push   %ebx
  801cf8:	83 ec 1c             	sub    $0x1c,%esp
  801cfb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801cff:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801d03:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d07:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801d0b:	85 d2                	test   %edx,%edx
  801d0d:	75 19                	jne    801d28 <__udivdi3+0x38>
  801d0f:	39 f3                	cmp    %esi,%ebx
  801d11:	76 4d                	jbe    801d60 <__udivdi3+0x70>
  801d13:	31 ff                	xor    %edi,%edi
  801d15:	89 e8                	mov    %ebp,%eax
  801d17:	89 f2                	mov    %esi,%edx
  801d19:	f7 f3                	div    %ebx
  801d1b:	89 fa                	mov    %edi,%edx
  801d1d:	83 c4 1c             	add    $0x1c,%esp
  801d20:	5b                   	pop    %ebx
  801d21:	5e                   	pop    %esi
  801d22:	5f                   	pop    %edi
  801d23:	5d                   	pop    %ebp
  801d24:	c3                   	ret    
  801d25:	8d 76 00             	lea    0x0(%esi),%esi
  801d28:	39 f2                	cmp    %esi,%edx
  801d2a:	76 14                	jbe    801d40 <__udivdi3+0x50>
  801d2c:	31 ff                	xor    %edi,%edi
  801d2e:	31 c0                	xor    %eax,%eax
  801d30:	89 fa                	mov    %edi,%edx
  801d32:	83 c4 1c             	add    $0x1c,%esp
  801d35:	5b                   	pop    %ebx
  801d36:	5e                   	pop    %esi
  801d37:	5f                   	pop    %edi
  801d38:	5d                   	pop    %ebp
  801d39:	c3                   	ret    
  801d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801d40:	0f bd fa             	bsr    %edx,%edi
  801d43:	83 f7 1f             	xor    $0x1f,%edi
  801d46:	75 48                	jne    801d90 <__udivdi3+0xa0>
  801d48:	39 f2                	cmp    %esi,%edx
  801d4a:	72 06                	jb     801d52 <__udivdi3+0x62>
  801d4c:	31 c0                	xor    %eax,%eax
  801d4e:	39 eb                	cmp    %ebp,%ebx
  801d50:	77 de                	ja     801d30 <__udivdi3+0x40>
  801d52:	b8 01 00 00 00       	mov    $0x1,%eax
  801d57:	eb d7                	jmp    801d30 <__udivdi3+0x40>
  801d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d60:	89 d9                	mov    %ebx,%ecx
  801d62:	85 db                	test   %ebx,%ebx
  801d64:	75 0b                	jne    801d71 <__udivdi3+0x81>
  801d66:	b8 01 00 00 00       	mov    $0x1,%eax
  801d6b:	31 d2                	xor    %edx,%edx
  801d6d:	f7 f3                	div    %ebx
  801d6f:	89 c1                	mov    %eax,%ecx
  801d71:	31 d2                	xor    %edx,%edx
  801d73:	89 f0                	mov    %esi,%eax
  801d75:	f7 f1                	div    %ecx
  801d77:	89 c6                	mov    %eax,%esi
  801d79:	89 e8                	mov    %ebp,%eax
  801d7b:	89 f7                	mov    %esi,%edi
  801d7d:	f7 f1                	div    %ecx
  801d7f:	89 fa                	mov    %edi,%edx
  801d81:	83 c4 1c             	add    $0x1c,%esp
  801d84:	5b                   	pop    %ebx
  801d85:	5e                   	pop    %esi
  801d86:	5f                   	pop    %edi
  801d87:	5d                   	pop    %ebp
  801d88:	c3                   	ret    
  801d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d90:	89 f9                	mov    %edi,%ecx
  801d92:	b8 20 00 00 00       	mov    $0x20,%eax
  801d97:	29 f8                	sub    %edi,%eax
  801d99:	d3 e2                	shl    %cl,%edx
  801d9b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d9f:	89 c1                	mov    %eax,%ecx
  801da1:	89 da                	mov    %ebx,%edx
  801da3:	d3 ea                	shr    %cl,%edx
  801da5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801da9:	09 d1                	or     %edx,%ecx
  801dab:	89 f2                	mov    %esi,%edx
  801dad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801db1:	89 f9                	mov    %edi,%ecx
  801db3:	d3 e3                	shl    %cl,%ebx
  801db5:	89 c1                	mov    %eax,%ecx
  801db7:	d3 ea                	shr    %cl,%edx
  801db9:	89 f9                	mov    %edi,%ecx
  801dbb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801dbf:	89 eb                	mov    %ebp,%ebx
  801dc1:	d3 e6                	shl    %cl,%esi
  801dc3:	89 c1                	mov    %eax,%ecx
  801dc5:	d3 eb                	shr    %cl,%ebx
  801dc7:	09 de                	or     %ebx,%esi
  801dc9:	89 f0                	mov    %esi,%eax
  801dcb:	f7 74 24 08          	divl   0x8(%esp)
  801dcf:	89 d6                	mov    %edx,%esi
  801dd1:	89 c3                	mov    %eax,%ebx
  801dd3:	f7 64 24 0c          	mull   0xc(%esp)
  801dd7:	39 d6                	cmp    %edx,%esi
  801dd9:	72 15                	jb     801df0 <__udivdi3+0x100>
  801ddb:	89 f9                	mov    %edi,%ecx
  801ddd:	d3 e5                	shl    %cl,%ebp
  801ddf:	39 c5                	cmp    %eax,%ebp
  801de1:	73 04                	jae    801de7 <__udivdi3+0xf7>
  801de3:	39 d6                	cmp    %edx,%esi
  801de5:	74 09                	je     801df0 <__udivdi3+0x100>
  801de7:	89 d8                	mov    %ebx,%eax
  801de9:	31 ff                	xor    %edi,%edi
  801deb:	e9 40 ff ff ff       	jmp    801d30 <__udivdi3+0x40>
  801df0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801df3:	31 ff                	xor    %edi,%edi
  801df5:	e9 36 ff ff ff       	jmp    801d30 <__udivdi3+0x40>
  801dfa:	66 90                	xchg   %ax,%ax
  801dfc:	66 90                	xchg   %ax,%ax
  801dfe:	66 90                	xchg   %ax,%ax

00801e00 <__umoddi3>:
  801e00:	f3 0f 1e fb          	endbr32 
  801e04:	55                   	push   %ebp
  801e05:	57                   	push   %edi
  801e06:	56                   	push   %esi
  801e07:	53                   	push   %ebx
  801e08:	83 ec 1c             	sub    $0x1c,%esp
  801e0b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e0f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801e13:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801e17:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e1b:	85 c0                	test   %eax,%eax
  801e1d:	75 19                	jne    801e38 <__umoddi3+0x38>
  801e1f:	39 df                	cmp    %ebx,%edi
  801e21:	76 5d                	jbe    801e80 <__umoddi3+0x80>
  801e23:	89 f0                	mov    %esi,%eax
  801e25:	89 da                	mov    %ebx,%edx
  801e27:	f7 f7                	div    %edi
  801e29:	89 d0                	mov    %edx,%eax
  801e2b:	31 d2                	xor    %edx,%edx
  801e2d:	83 c4 1c             	add    $0x1c,%esp
  801e30:	5b                   	pop    %ebx
  801e31:	5e                   	pop    %esi
  801e32:	5f                   	pop    %edi
  801e33:	5d                   	pop    %ebp
  801e34:	c3                   	ret    
  801e35:	8d 76 00             	lea    0x0(%esi),%esi
  801e38:	89 f2                	mov    %esi,%edx
  801e3a:	39 d8                	cmp    %ebx,%eax
  801e3c:	76 12                	jbe    801e50 <__umoddi3+0x50>
  801e3e:	89 f0                	mov    %esi,%eax
  801e40:	89 da                	mov    %ebx,%edx
  801e42:	83 c4 1c             	add    $0x1c,%esp
  801e45:	5b                   	pop    %ebx
  801e46:	5e                   	pop    %esi
  801e47:	5f                   	pop    %edi
  801e48:	5d                   	pop    %ebp
  801e49:	c3                   	ret    
  801e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801e50:	0f bd e8             	bsr    %eax,%ebp
  801e53:	83 f5 1f             	xor    $0x1f,%ebp
  801e56:	75 50                	jne    801ea8 <__umoddi3+0xa8>
  801e58:	39 d8                	cmp    %ebx,%eax
  801e5a:	0f 82 e0 00 00 00    	jb     801f40 <__umoddi3+0x140>
  801e60:	89 d9                	mov    %ebx,%ecx
  801e62:	39 f7                	cmp    %esi,%edi
  801e64:	0f 86 d6 00 00 00    	jbe    801f40 <__umoddi3+0x140>
  801e6a:	89 d0                	mov    %edx,%eax
  801e6c:	89 ca                	mov    %ecx,%edx
  801e6e:	83 c4 1c             	add    $0x1c,%esp
  801e71:	5b                   	pop    %ebx
  801e72:	5e                   	pop    %esi
  801e73:	5f                   	pop    %edi
  801e74:	5d                   	pop    %ebp
  801e75:	c3                   	ret    
  801e76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e7d:	8d 76 00             	lea    0x0(%esi),%esi
  801e80:	89 fd                	mov    %edi,%ebp
  801e82:	85 ff                	test   %edi,%edi
  801e84:	75 0b                	jne    801e91 <__umoddi3+0x91>
  801e86:	b8 01 00 00 00       	mov    $0x1,%eax
  801e8b:	31 d2                	xor    %edx,%edx
  801e8d:	f7 f7                	div    %edi
  801e8f:	89 c5                	mov    %eax,%ebp
  801e91:	89 d8                	mov    %ebx,%eax
  801e93:	31 d2                	xor    %edx,%edx
  801e95:	f7 f5                	div    %ebp
  801e97:	89 f0                	mov    %esi,%eax
  801e99:	f7 f5                	div    %ebp
  801e9b:	89 d0                	mov    %edx,%eax
  801e9d:	31 d2                	xor    %edx,%edx
  801e9f:	eb 8c                	jmp    801e2d <__umoddi3+0x2d>
  801ea1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ea8:	89 e9                	mov    %ebp,%ecx
  801eaa:	ba 20 00 00 00       	mov    $0x20,%edx
  801eaf:	29 ea                	sub    %ebp,%edx
  801eb1:	d3 e0                	shl    %cl,%eax
  801eb3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801eb7:	89 d1                	mov    %edx,%ecx
  801eb9:	89 f8                	mov    %edi,%eax
  801ebb:	d3 e8                	shr    %cl,%eax
  801ebd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801ec1:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ec5:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ec9:	09 c1                	or     %eax,%ecx
  801ecb:	89 d8                	mov    %ebx,%eax
  801ecd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ed1:	89 e9                	mov    %ebp,%ecx
  801ed3:	d3 e7                	shl    %cl,%edi
  801ed5:	89 d1                	mov    %edx,%ecx
  801ed7:	d3 e8                	shr    %cl,%eax
  801ed9:	89 e9                	mov    %ebp,%ecx
  801edb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801edf:	d3 e3                	shl    %cl,%ebx
  801ee1:	89 c7                	mov    %eax,%edi
  801ee3:	89 d1                	mov    %edx,%ecx
  801ee5:	89 f0                	mov    %esi,%eax
  801ee7:	d3 e8                	shr    %cl,%eax
  801ee9:	89 e9                	mov    %ebp,%ecx
  801eeb:	89 fa                	mov    %edi,%edx
  801eed:	d3 e6                	shl    %cl,%esi
  801eef:	09 d8                	or     %ebx,%eax
  801ef1:	f7 74 24 08          	divl   0x8(%esp)
  801ef5:	89 d1                	mov    %edx,%ecx
  801ef7:	89 f3                	mov    %esi,%ebx
  801ef9:	f7 64 24 0c          	mull   0xc(%esp)
  801efd:	89 c6                	mov    %eax,%esi
  801eff:	89 d7                	mov    %edx,%edi
  801f01:	39 d1                	cmp    %edx,%ecx
  801f03:	72 06                	jb     801f0b <__umoddi3+0x10b>
  801f05:	75 10                	jne    801f17 <__umoddi3+0x117>
  801f07:	39 c3                	cmp    %eax,%ebx
  801f09:	73 0c                	jae    801f17 <__umoddi3+0x117>
  801f0b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  801f0f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801f13:	89 d7                	mov    %edx,%edi
  801f15:	89 c6                	mov    %eax,%esi
  801f17:	89 ca                	mov    %ecx,%edx
  801f19:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801f1e:	29 f3                	sub    %esi,%ebx
  801f20:	19 fa                	sbb    %edi,%edx
  801f22:	89 d0                	mov    %edx,%eax
  801f24:	d3 e0                	shl    %cl,%eax
  801f26:	89 e9                	mov    %ebp,%ecx
  801f28:	d3 eb                	shr    %cl,%ebx
  801f2a:	d3 ea                	shr    %cl,%edx
  801f2c:	09 d8                	or     %ebx,%eax
  801f2e:	83 c4 1c             	add    $0x1c,%esp
  801f31:	5b                   	pop    %ebx
  801f32:	5e                   	pop    %esi
  801f33:	5f                   	pop    %edi
  801f34:	5d                   	pop    %ebp
  801f35:	c3                   	ret    
  801f36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f3d:	8d 76 00             	lea    0x0(%esi),%esi
  801f40:	29 fe                	sub    %edi,%esi
  801f42:	19 c3                	sbb    %eax,%ebx
  801f44:	89 f2                	mov    %esi,%edx
  801f46:	89 d9                	mov    %ebx,%ecx
  801f48:	e9 1d ff ff ff       	jmp    801e6a <__umoddi3+0x6a>
