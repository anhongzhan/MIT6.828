
obj/user/fairness:     file format elf32-i386


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
  80003f:	e8 64 0b 00 00       	call   800ba8 <sys_getenvid>
  800044:	89 c3                	mov    %eax,%ebx

	if (thisenv == &envs[1]) {
  800046:	81 3d 04 20 80 00 7c 	cmpl   $0xeec0007c,0x802004
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
  80005c:	68 91 11 80 00       	push   $0x801191
  800061:	e8 3c 01 00 00       	call   8001a2 <cprintf>
  800066:	83 c4 10             	add    $0x10,%esp
		while (1)
			ipc_send(envs[1].env_id, 0, 0, 0);
  800069:	a1 c4 00 c0 ee       	mov    0xeec000c4,%eax
  80006e:	6a 00                	push   $0x0
  800070:	6a 00                	push   $0x0
  800072:	6a 00                	push   $0x0
  800074:	50                   	push   %eax
  800075:	e8 c4 0d 00 00       	call   800e3e <ipc_send>
  80007a:	83 c4 10             	add    $0x10,%esp
  80007d:	eb ea                	jmp    800069 <umain+0x36>
			ipc_recv(&who, 0, 0);
  80007f:	8d 75 f4             	lea    -0xc(%ebp),%esi
  800082:	83 ec 04             	sub    $0x4,%esp
  800085:	6a 00                	push   $0x0
  800087:	6a 00                	push   $0x0
  800089:	56                   	push   %esi
  80008a:	e8 2a 0d 00 00       	call   800db9 <ipc_recv>
			cprintf("%x recv from %x\n", id, who);
  80008f:	83 c4 0c             	add    $0xc,%esp
  800092:	ff 75 f4             	pushl  -0xc(%ebp)
  800095:	53                   	push   %ebx
  800096:	68 80 11 80 00       	push   $0x801180
  80009b:	e8 02 01 00 00       	call   8001a2 <cprintf>
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
  8000b4:	e8 ef 0a 00 00       	call   800ba8 <sys_getenvid>
  8000b9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000be:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000c1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000c6:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000cb:	85 db                	test   %ebx,%ebx
  8000cd:	7e 07                	jle    8000d6 <libmain+0x31>
		binaryname = argv[0];
  8000cf:	8b 06                	mov    (%esi),%eax
  8000d1:	a3 00 20 80 00       	mov    %eax,0x802000

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
  8000f6:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  8000f9:	6a 00                	push   $0x0
  8000fb:	e8 63 0a 00 00       	call   800b63 <sys_env_destroy>
}
  800100:	83 c4 10             	add    $0x10,%esp
  800103:	c9                   	leave  
  800104:	c3                   	ret    

00800105 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800105:	f3 0f 1e fb          	endbr32 
  800109:	55                   	push   %ebp
  80010a:	89 e5                	mov    %esp,%ebp
  80010c:	53                   	push   %ebx
  80010d:	83 ec 04             	sub    $0x4,%esp
  800110:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800113:	8b 13                	mov    (%ebx),%edx
  800115:	8d 42 01             	lea    0x1(%edx),%eax
  800118:	89 03                	mov    %eax,(%ebx)
  80011a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80011d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800121:	3d ff 00 00 00       	cmp    $0xff,%eax
  800126:	74 09                	je     800131 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800128:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80012c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80012f:	c9                   	leave  
  800130:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800131:	83 ec 08             	sub    $0x8,%esp
  800134:	68 ff 00 00 00       	push   $0xff
  800139:	8d 43 08             	lea    0x8(%ebx),%eax
  80013c:	50                   	push   %eax
  80013d:	e8 dc 09 00 00       	call   800b1e <sys_cputs>
		b->idx = 0;
  800142:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800148:	83 c4 10             	add    $0x10,%esp
  80014b:	eb db                	jmp    800128 <putch+0x23>

0080014d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80014d:	f3 0f 1e fb          	endbr32 
  800151:	55                   	push   %ebp
  800152:	89 e5                	mov    %esp,%ebp
  800154:	81 ec 18 01 00 00    	sub    $0x118,%esp
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
  80017b:	68 05 01 80 00       	push   $0x800105
  800180:	e8 20 01 00 00       	call   8002a5 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800185:	83 c4 08             	add    $0x8,%esp
  800188:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80018e:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800194:	50                   	push   %eax
  800195:	e8 84 09 00 00       	call   800b1e <sys_cputs>

	return b.cnt;
}
  80019a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001a0:	c9                   	leave  
  8001a1:	c3                   	ret    

008001a2 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001a2:	f3 0f 1e fb          	endbr32 
  8001a6:	55                   	push   %ebp
  8001a7:	89 e5                	mov    %esp,%ebp
  8001a9:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001ac:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001af:	50                   	push   %eax
  8001b0:	ff 75 08             	pushl  0x8(%ebp)
  8001b3:	e8 95 ff ff ff       	call   80014d <vcprintf>
	va_end(ap);

	return cnt;
}
  8001b8:	c9                   	leave  
  8001b9:	c3                   	ret    

008001ba <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001ba:	55                   	push   %ebp
  8001bb:	89 e5                	mov    %esp,%ebp
  8001bd:	57                   	push   %edi
  8001be:	56                   	push   %esi
  8001bf:	53                   	push   %ebx
  8001c0:	83 ec 1c             	sub    $0x1c,%esp
  8001c3:	89 c7                	mov    %eax,%edi
  8001c5:	89 d6                	mov    %edx,%esi
  8001c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001cd:	89 d1                	mov    %edx,%ecx
  8001cf:	89 c2                	mov    %eax,%edx
  8001d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001d4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8001da:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001e0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001e7:	39 c2                	cmp    %eax,%edx
  8001e9:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8001ec:	72 3e                	jb     80022c <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	ff 75 18             	pushl  0x18(%ebp)
  8001f4:	83 eb 01             	sub    $0x1,%ebx
  8001f7:	53                   	push   %ebx
  8001f8:	50                   	push   %eax
  8001f9:	83 ec 08             	sub    $0x8,%esp
  8001fc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001ff:	ff 75 e0             	pushl  -0x20(%ebp)
  800202:	ff 75 dc             	pushl  -0x24(%ebp)
  800205:	ff 75 d8             	pushl  -0x28(%ebp)
  800208:	e8 13 0d 00 00       	call   800f20 <__udivdi3>
  80020d:	83 c4 18             	add    $0x18,%esp
  800210:	52                   	push   %edx
  800211:	50                   	push   %eax
  800212:	89 f2                	mov    %esi,%edx
  800214:	89 f8                	mov    %edi,%eax
  800216:	e8 9f ff ff ff       	call   8001ba <printnum>
  80021b:	83 c4 20             	add    $0x20,%esp
  80021e:	eb 13                	jmp    800233 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800220:	83 ec 08             	sub    $0x8,%esp
  800223:	56                   	push   %esi
  800224:	ff 75 18             	pushl  0x18(%ebp)
  800227:	ff d7                	call   *%edi
  800229:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80022c:	83 eb 01             	sub    $0x1,%ebx
  80022f:	85 db                	test   %ebx,%ebx
  800231:	7f ed                	jg     800220 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800233:	83 ec 08             	sub    $0x8,%esp
  800236:	56                   	push   %esi
  800237:	83 ec 04             	sub    $0x4,%esp
  80023a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80023d:	ff 75 e0             	pushl  -0x20(%ebp)
  800240:	ff 75 dc             	pushl  -0x24(%ebp)
  800243:	ff 75 d8             	pushl  -0x28(%ebp)
  800246:	e8 e5 0d 00 00       	call   801030 <__umoddi3>
  80024b:	83 c4 14             	add    $0x14,%esp
  80024e:	0f be 80 b2 11 80 00 	movsbl 0x8011b2(%eax),%eax
  800255:	50                   	push   %eax
  800256:	ff d7                	call   *%edi
}
  800258:	83 c4 10             	add    $0x10,%esp
  80025b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80025e:	5b                   	pop    %ebx
  80025f:	5e                   	pop    %esi
  800260:	5f                   	pop    %edi
  800261:	5d                   	pop    %ebp
  800262:	c3                   	ret    

00800263 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800263:	f3 0f 1e fb          	endbr32 
  800267:	55                   	push   %ebp
  800268:	89 e5                	mov    %esp,%ebp
  80026a:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80026d:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800271:	8b 10                	mov    (%eax),%edx
  800273:	3b 50 04             	cmp    0x4(%eax),%edx
  800276:	73 0a                	jae    800282 <sprintputch+0x1f>
		*b->buf++ = ch;
  800278:	8d 4a 01             	lea    0x1(%edx),%ecx
  80027b:	89 08                	mov    %ecx,(%eax)
  80027d:	8b 45 08             	mov    0x8(%ebp),%eax
  800280:	88 02                	mov    %al,(%edx)
}
  800282:	5d                   	pop    %ebp
  800283:	c3                   	ret    

00800284 <printfmt>:
{
  800284:	f3 0f 1e fb          	endbr32 
  800288:	55                   	push   %ebp
  800289:	89 e5                	mov    %esp,%ebp
  80028b:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80028e:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800291:	50                   	push   %eax
  800292:	ff 75 10             	pushl  0x10(%ebp)
  800295:	ff 75 0c             	pushl  0xc(%ebp)
  800298:	ff 75 08             	pushl  0x8(%ebp)
  80029b:	e8 05 00 00 00       	call   8002a5 <vprintfmt>
}
  8002a0:	83 c4 10             	add    $0x10,%esp
  8002a3:	c9                   	leave  
  8002a4:	c3                   	ret    

008002a5 <vprintfmt>:
{
  8002a5:	f3 0f 1e fb          	endbr32 
  8002a9:	55                   	push   %ebp
  8002aa:	89 e5                	mov    %esp,%ebp
  8002ac:	57                   	push   %edi
  8002ad:	56                   	push   %esi
  8002ae:	53                   	push   %ebx
  8002af:	83 ec 3c             	sub    $0x3c,%esp
  8002b2:	8b 75 08             	mov    0x8(%ebp),%esi
  8002b5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002b8:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002bb:	e9 8e 03 00 00       	jmp    80064e <vprintfmt+0x3a9>
		padc = ' ';
  8002c0:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002c4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002cb:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002d2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002d9:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002de:	8d 47 01             	lea    0x1(%edi),%eax
  8002e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002e4:	0f b6 17             	movzbl (%edi),%edx
  8002e7:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002ea:	3c 55                	cmp    $0x55,%al
  8002ec:	0f 87 df 03 00 00    	ja     8006d1 <vprintfmt+0x42c>
  8002f2:	0f b6 c0             	movzbl %al,%eax
  8002f5:	3e ff 24 85 80 12 80 	notrack jmp *0x801280(,%eax,4)
  8002fc:	00 
  8002fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800300:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800304:	eb d8                	jmp    8002de <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800306:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800309:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80030d:	eb cf                	jmp    8002de <vprintfmt+0x39>
  80030f:	0f b6 d2             	movzbl %dl,%edx
  800312:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800315:	b8 00 00 00 00       	mov    $0x0,%eax
  80031a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80031d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800320:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800324:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800327:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80032a:	83 f9 09             	cmp    $0x9,%ecx
  80032d:	77 55                	ja     800384 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  80032f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800332:	eb e9                	jmp    80031d <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800334:	8b 45 14             	mov    0x14(%ebp),%eax
  800337:	8b 00                	mov    (%eax),%eax
  800339:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80033c:	8b 45 14             	mov    0x14(%ebp),%eax
  80033f:	8d 40 04             	lea    0x4(%eax),%eax
  800342:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800345:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800348:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80034c:	79 90                	jns    8002de <vprintfmt+0x39>
				width = precision, precision = -1;
  80034e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800351:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800354:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80035b:	eb 81                	jmp    8002de <vprintfmt+0x39>
  80035d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800360:	85 c0                	test   %eax,%eax
  800362:	ba 00 00 00 00       	mov    $0x0,%edx
  800367:	0f 49 d0             	cmovns %eax,%edx
  80036a:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80036d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800370:	e9 69 ff ff ff       	jmp    8002de <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800375:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800378:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80037f:	e9 5a ff ff ff       	jmp    8002de <vprintfmt+0x39>
  800384:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800387:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80038a:	eb bc                	jmp    800348 <vprintfmt+0xa3>
			lflag++;
  80038c:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80038f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800392:	e9 47 ff ff ff       	jmp    8002de <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800397:	8b 45 14             	mov    0x14(%ebp),%eax
  80039a:	8d 78 04             	lea    0x4(%eax),%edi
  80039d:	83 ec 08             	sub    $0x8,%esp
  8003a0:	53                   	push   %ebx
  8003a1:	ff 30                	pushl  (%eax)
  8003a3:	ff d6                	call   *%esi
			break;
  8003a5:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003a8:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003ab:	e9 9b 02 00 00       	jmp    80064b <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8003b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b3:	8d 78 04             	lea    0x4(%eax),%edi
  8003b6:	8b 00                	mov    (%eax),%eax
  8003b8:	99                   	cltd   
  8003b9:	31 d0                	xor    %edx,%eax
  8003bb:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003bd:	83 f8 08             	cmp    $0x8,%eax
  8003c0:	7f 23                	jg     8003e5 <vprintfmt+0x140>
  8003c2:	8b 14 85 e0 13 80 00 	mov    0x8013e0(,%eax,4),%edx
  8003c9:	85 d2                	test   %edx,%edx
  8003cb:	74 18                	je     8003e5 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8003cd:	52                   	push   %edx
  8003ce:	68 d3 11 80 00       	push   $0x8011d3
  8003d3:	53                   	push   %ebx
  8003d4:	56                   	push   %esi
  8003d5:	e8 aa fe ff ff       	call   800284 <printfmt>
  8003da:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003dd:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003e0:	e9 66 02 00 00       	jmp    80064b <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8003e5:	50                   	push   %eax
  8003e6:	68 ca 11 80 00       	push   $0x8011ca
  8003eb:	53                   	push   %ebx
  8003ec:	56                   	push   %esi
  8003ed:	e8 92 fe ff ff       	call   800284 <printfmt>
  8003f2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003f5:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003f8:	e9 4e 02 00 00       	jmp    80064b <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8003fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800400:	83 c0 04             	add    $0x4,%eax
  800403:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800406:	8b 45 14             	mov    0x14(%ebp),%eax
  800409:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80040b:	85 d2                	test   %edx,%edx
  80040d:	b8 c3 11 80 00       	mov    $0x8011c3,%eax
  800412:	0f 45 c2             	cmovne %edx,%eax
  800415:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800418:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80041c:	7e 06                	jle    800424 <vprintfmt+0x17f>
  80041e:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800422:	75 0d                	jne    800431 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  800424:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800427:	89 c7                	mov    %eax,%edi
  800429:	03 45 e0             	add    -0x20(%ebp),%eax
  80042c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80042f:	eb 55                	jmp    800486 <vprintfmt+0x1e1>
  800431:	83 ec 08             	sub    $0x8,%esp
  800434:	ff 75 d8             	pushl  -0x28(%ebp)
  800437:	ff 75 cc             	pushl  -0x34(%ebp)
  80043a:	e8 46 03 00 00       	call   800785 <strnlen>
  80043f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800442:	29 c2                	sub    %eax,%edx
  800444:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800447:	83 c4 10             	add    $0x10,%esp
  80044a:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80044c:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800450:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800453:	85 ff                	test   %edi,%edi
  800455:	7e 11                	jle    800468 <vprintfmt+0x1c3>
					putch(padc, putdat);
  800457:	83 ec 08             	sub    $0x8,%esp
  80045a:	53                   	push   %ebx
  80045b:	ff 75 e0             	pushl  -0x20(%ebp)
  80045e:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800460:	83 ef 01             	sub    $0x1,%edi
  800463:	83 c4 10             	add    $0x10,%esp
  800466:	eb eb                	jmp    800453 <vprintfmt+0x1ae>
  800468:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80046b:	85 d2                	test   %edx,%edx
  80046d:	b8 00 00 00 00       	mov    $0x0,%eax
  800472:	0f 49 c2             	cmovns %edx,%eax
  800475:	29 c2                	sub    %eax,%edx
  800477:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80047a:	eb a8                	jmp    800424 <vprintfmt+0x17f>
					putch(ch, putdat);
  80047c:	83 ec 08             	sub    $0x8,%esp
  80047f:	53                   	push   %ebx
  800480:	52                   	push   %edx
  800481:	ff d6                	call   *%esi
  800483:	83 c4 10             	add    $0x10,%esp
  800486:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800489:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80048b:	83 c7 01             	add    $0x1,%edi
  80048e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800492:	0f be d0             	movsbl %al,%edx
  800495:	85 d2                	test   %edx,%edx
  800497:	74 4b                	je     8004e4 <vprintfmt+0x23f>
  800499:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80049d:	78 06                	js     8004a5 <vprintfmt+0x200>
  80049f:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004a3:	78 1e                	js     8004c3 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004a5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004a9:	74 d1                	je     80047c <vprintfmt+0x1d7>
  8004ab:	0f be c0             	movsbl %al,%eax
  8004ae:	83 e8 20             	sub    $0x20,%eax
  8004b1:	83 f8 5e             	cmp    $0x5e,%eax
  8004b4:	76 c6                	jbe    80047c <vprintfmt+0x1d7>
					putch('?', putdat);
  8004b6:	83 ec 08             	sub    $0x8,%esp
  8004b9:	53                   	push   %ebx
  8004ba:	6a 3f                	push   $0x3f
  8004bc:	ff d6                	call   *%esi
  8004be:	83 c4 10             	add    $0x10,%esp
  8004c1:	eb c3                	jmp    800486 <vprintfmt+0x1e1>
  8004c3:	89 cf                	mov    %ecx,%edi
  8004c5:	eb 0e                	jmp    8004d5 <vprintfmt+0x230>
				putch(' ', putdat);
  8004c7:	83 ec 08             	sub    $0x8,%esp
  8004ca:	53                   	push   %ebx
  8004cb:	6a 20                	push   $0x20
  8004cd:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004cf:	83 ef 01             	sub    $0x1,%edi
  8004d2:	83 c4 10             	add    $0x10,%esp
  8004d5:	85 ff                	test   %edi,%edi
  8004d7:	7f ee                	jg     8004c7 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8004d9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8004df:	e9 67 01 00 00       	jmp    80064b <vprintfmt+0x3a6>
  8004e4:	89 cf                	mov    %ecx,%edi
  8004e6:	eb ed                	jmp    8004d5 <vprintfmt+0x230>
	if (lflag >= 2)
  8004e8:	83 f9 01             	cmp    $0x1,%ecx
  8004eb:	7f 1b                	jg     800508 <vprintfmt+0x263>
	else if (lflag)
  8004ed:	85 c9                	test   %ecx,%ecx
  8004ef:	74 63                	je     800554 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8004f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f4:	8b 00                	mov    (%eax),%eax
  8004f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004f9:	99                   	cltd   
  8004fa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800500:	8d 40 04             	lea    0x4(%eax),%eax
  800503:	89 45 14             	mov    %eax,0x14(%ebp)
  800506:	eb 17                	jmp    80051f <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800508:	8b 45 14             	mov    0x14(%ebp),%eax
  80050b:	8b 50 04             	mov    0x4(%eax),%edx
  80050e:	8b 00                	mov    (%eax),%eax
  800510:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800513:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800516:	8b 45 14             	mov    0x14(%ebp),%eax
  800519:	8d 40 08             	lea    0x8(%eax),%eax
  80051c:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80051f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800522:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800525:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80052a:	85 c9                	test   %ecx,%ecx
  80052c:	0f 89 ff 00 00 00    	jns    800631 <vprintfmt+0x38c>
				putch('-', putdat);
  800532:	83 ec 08             	sub    $0x8,%esp
  800535:	53                   	push   %ebx
  800536:	6a 2d                	push   $0x2d
  800538:	ff d6                	call   *%esi
				num = -(long long) num;
  80053a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80053d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800540:	f7 da                	neg    %edx
  800542:	83 d1 00             	adc    $0x0,%ecx
  800545:	f7 d9                	neg    %ecx
  800547:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80054a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80054f:	e9 dd 00 00 00       	jmp    800631 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  800554:	8b 45 14             	mov    0x14(%ebp),%eax
  800557:	8b 00                	mov    (%eax),%eax
  800559:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80055c:	99                   	cltd   
  80055d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800560:	8b 45 14             	mov    0x14(%ebp),%eax
  800563:	8d 40 04             	lea    0x4(%eax),%eax
  800566:	89 45 14             	mov    %eax,0x14(%ebp)
  800569:	eb b4                	jmp    80051f <vprintfmt+0x27a>
	if (lflag >= 2)
  80056b:	83 f9 01             	cmp    $0x1,%ecx
  80056e:	7f 1e                	jg     80058e <vprintfmt+0x2e9>
	else if (lflag)
  800570:	85 c9                	test   %ecx,%ecx
  800572:	74 32                	je     8005a6 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800574:	8b 45 14             	mov    0x14(%ebp),%eax
  800577:	8b 10                	mov    (%eax),%edx
  800579:	b9 00 00 00 00       	mov    $0x0,%ecx
  80057e:	8d 40 04             	lea    0x4(%eax),%eax
  800581:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800584:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800589:	e9 a3 00 00 00       	jmp    800631 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80058e:	8b 45 14             	mov    0x14(%ebp),%eax
  800591:	8b 10                	mov    (%eax),%edx
  800593:	8b 48 04             	mov    0x4(%eax),%ecx
  800596:	8d 40 08             	lea    0x8(%eax),%eax
  800599:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80059c:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8005a1:	e9 8b 00 00 00       	jmp    800631 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a9:	8b 10                	mov    (%eax),%edx
  8005ab:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005b0:	8d 40 04             	lea    0x4(%eax),%eax
  8005b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005b6:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8005bb:	eb 74                	jmp    800631 <vprintfmt+0x38c>
	if (lflag >= 2)
  8005bd:	83 f9 01             	cmp    $0x1,%ecx
  8005c0:	7f 1b                	jg     8005dd <vprintfmt+0x338>
	else if (lflag)
  8005c2:	85 c9                	test   %ecx,%ecx
  8005c4:	74 2c                	je     8005f2 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8005c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c9:	8b 10                	mov    (%eax),%edx
  8005cb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005d0:	8d 40 04             	lea    0x4(%eax),%eax
  8005d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005d6:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8005db:	eb 54                	jmp    800631 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e0:	8b 10                	mov    (%eax),%edx
  8005e2:	8b 48 04             	mov    0x4(%eax),%ecx
  8005e5:	8d 40 08             	lea    0x8(%eax),%eax
  8005e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005eb:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  8005f0:	eb 3f                	jmp    800631 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f5:	8b 10                	mov    (%eax),%edx
  8005f7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005fc:	8d 40 04             	lea    0x4(%eax),%eax
  8005ff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800602:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800607:	eb 28                	jmp    800631 <vprintfmt+0x38c>
			putch('0', putdat);
  800609:	83 ec 08             	sub    $0x8,%esp
  80060c:	53                   	push   %ebx
  80060d:	6a 30                	push   $0x30
  80060f:	ff d6                	call   *%esi
			putch('x', putdat);
  800611:	83 c4 08             	add    $0x8,%esp
  800614:	53                   	push   %ebx
  800615:	6a 78                	push   $0x78
  800617:	ff d6                	call   *%esi
			num = (unsigned long long)
  800619:	8b 45 14             	mov    0x14(%ebp),%eax
  80061c:	8b 10                	mov    (%eax),%edx
  80061e:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800623:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800626:	8d 40 04             	lea    0x4(%eax),%eax
  800629:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80062c:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800631:	83 ec 0c             	sub    $0xc,%esp
  800634:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800638:	57                   	push   %edi
  800639:	ff 75 e0             	pushl  -0x20(%ebp)
  80063c:	50                   	push   %eax
  80063d:	51                   	push   %ecx
  80063e:	52                   	push   %edx
  80063f:	89 da                	mov    %ebx,%edx
  800641:	89 f0                	mov    %esi,%eax
  800643:	e8 72 fb ff ff       	call   8001ba <printnum>
			break;
  800648:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80064b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80064e:	83 c7 01             	add    $0x1,%edi
  800651:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800655:	83 f8 25             	cmp    $0x25,%eax
  800658:	0f 84 62 fc ff ff    	je     8002c0 <vprintfmt+0x1b>
			if (ch == '\0')
  80065e:	85 c0                	test   %eax,%eax
  800660:	0f 84 8b 00 00 00    	je     8006f1 <vprintfmt+0x44c>
			putch(ch, putdat);
  800666:	83 ec 08             	sub    $0x8,%esp
  800669:	53                   	push   %ebx
  80066a:	50                   	push   %eax
  80066b:	ff d6                	call   *%esi
  80066d:	83 c4 10             	add    $0x10,%esp
  800670:	eb dc                	jmp    80064e <vprintfmt+0x3a9>
	if (lflag >= 2)
  800672:	83 f9 01             	cmp    $0x1,%ecx
  800675:	7f 1b                	jg     800692 <vprintfmt+0x3ed>
	else if (lflag)
  800677:	85 c9                	test   %ecx,%ecx
  800679:	74 2c                	je     8006a7 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  80067b:	8b 45 14             	mov    0x14(%ebp),%eax
  80067e:	8b 10                	mov    (%eax),%edx
  800680:	b9 00 00 00 00       	mov    $0x0,%ecx
  800685:	8d 40 04             	lea    0x4(%eax),%eax
  800688:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80068b:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800690:	eb 9f                	jmp    800631 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800692:	8b 45 14             	mov    0x14(%ebp),%eax
  800695:	8b 10                	mov    (%eax),%edx
  800697:	8b 48 04             	mov    0x4(%eax),%ecx
  80069a:	8d 40 08             	lea    0x8(%eax),%eax
  80069d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a0:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8006a5:	eb 8a                	jmp    800631 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006aa:	8b 10                	mov    (%eax),%edx
  8006ac:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b1:	8d 40 04             	lea    0x4(%eax),%eax
  8006b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b7:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8006bc:	e9 70 ff ff ff       	jmp    800631 <vprintfmt+0x38c>
			putch(ch, putdat);
  8006c1:	83 ec 08             	sub    $0x8,%esp
  8006c4:	53                   	push   %ebx
  8006c5:	6a 25                	push   $0x25
  8006c7:	ff d6                	call   *%esi
			break;
  8006c9:	83 c4 10             	add    $0x10,%esp
  8006cc:	e9 7a ff ff ff       	jmp    80064b <vprintfmt+0x3a6>
			putch('%', putdat);
  8006d1:	83 ec 08             	sub    $0x8,%esp
  8006d4:	53                   	push   %ebx
  8006d5:	6a 25                	push   $0x25
  8006d7:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006d9:	83 c4 10             	add    $0x10,%esp
  8006dc:	89 f8                	mov    %edi,%eax
  8006de:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006e2:	74 05                	je     8006e9 <vprintfmt+0x444>
  8006e4:	83 e8 01             	sub    $0x1,%eax
  8006e7:	eb f5                	jmp    8006de <vprintfmt+0x439>
  8006e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006ec:	e9 5a ff ff ff       	jmp    80064b <vprintfmt+0x3a6>
}
  8006f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006f4:	5b                   	pop    %ebx
  8006f5:	5e                   	pop    %esi
  8006f6:	5f                   	pop    %edi
  8006f7:	5d                   	pop    %ebp
  8006f8:	c3                   	ret    

008006f9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006f9:	f3 0f 1e fb          	endbr32 
  8006fd:	55                   	push   %ebp
  8006fe:	89 e5                	mov    %esp,%ebp
  800700:	83 ec 18             	sub    $0x18,%esp
  800703:	8b 45 08             	mov    0x8(%ebp),%eax
  800706:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800709:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80070c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800710:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800713:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80071a:	85 c0                	test   %eax,%eax
  80071c:	74 26                	je     800744 <vsnprintf+0x4b>
  80071e:	85 d2                	test   %edx,%edx
  800720:	7e 22                	jle    800744 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800722:	ff 75 14             	pushl  0x14(%ebp)
  800725:	ff 75 10             	pushl  0x10(%ebp)
  800728:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80072b:	50                   	push   %eax
  80072c:	68 63 02 80 00       	push   $0x800263
  800731:	e8 6f fb ff ff       	call   8002a5 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800736:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800739:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80073c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80073f:	83 c4 10             	add    $0x10,%esp
}
  800742:	c9                   	leave  
  800743:	c3                   	ret    
		return -E_INVAL;
  800744:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800749:	eb f7                	jmp    800742 <vsnprintf+0x49>

0080074b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80074b:	f3 0f 1e fb          	endbr32 
  80074f:	55                   	push   %ebp
  800750:	89 e5                	mov    %esp,%ebp
  800752:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800755:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800758:	50                   	push   %eax
  800759:	ff 75 10             	pushl  0x10(%ebp)
  80075c:	ff 75 0c             	pushl  0xc(%ebp)
  80075f:	ff 75 08             	pushl  0x8(%ebp)
  800762:	e8 92 ff ff ff       	call   8006f9 <vsnprintf>
	va_end(ap);

	return rc;
}
  800767:	c9                   	leave  
  800768:	c3                   	ret    

00800769 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800769:	f3 0f 1e fb          	endbr32 
  80076d:	55                   	push   %ebp
  80076e:	89 e5                	mov    %esp,%ebp
  800770:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800773:	b8 00 00 00 00       	mov    $0x0,%eax
  800778:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80077c:	74 05                	je     800783 <strlen+0x1a>
		n++;
  80077e:	83 c0 01             	add    $0x1,%eax
  800781:	eb f5                	jmp    800778 <strlen+0xf>
	return n;
}
  800783:	5d                   	pop    %ebp
  800784:	c3                   	ret    

00800785 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800785:	f3 0f 1e fb          	endbr32 
  800789:	55                   	push   %ebp
  80078a:	89 e5                	mov    %esp,%ebp
  80078c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80078f:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800792:	b8 00 00 00 00       	mov    $0x0,%eax
  800797:	39 d0                	cmp    %edx,%eax
  800799:	74 0d                	je     8007a8 <strnlen+0x23>
  80079b:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80079f:	74 05                	je     8007a6 <strnlen+0x21>
		n++;
  8007a1:	83 c0 01             	add    $0x1,%eax
  8007a4:	eb f1                	jmp    800797 <strnlen+0x12>
  8007a6:	89 c2                	mov    %eax,%edx
	return n;
}
  8007a8:	89 d0                	mov    %edx,%eax
  8007aa:	5d                   	pop    %ebp
  8007ab:	c3                   	ret    

008007ac <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007ac:	f3 0f 1e fb          	endbr32 
  8007b0:	55                   	push   %ebp
  8007b1:	89 e5                	mov    %esp,%ebp
  8007b3:	53                   	push   %ebx
  8007b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8007bf:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8007c3:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8007c6:	83 c0 01             	add    $0x1,%eax
  8007c9:	84 d2                	test   %dl,%dl
  8007cb:	75 f2                	jne    8007bf <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8007cd:	89 c8                	mov    %ecx,%eax
  8007cf:	5b                   	pop    %ebx
  8007d0:	5d                   	pop    %ebp
  8007d1:	c3                   	ret    

008007d2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007d2:	f3 0f 1e fb          	endbr32 
  8007d6:	55                   	push   %ebp
  8007d7:	89 e5                	mov    %esp,%ebp
  8007d9:	53                   	push   %ebx
  8007da:	83 ec 10             	sub    $0x10,%esp
  8007dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007e0:	53                   	push   %ebx
  8007e1:	e8 83 ff ff ff       	call   800769 <strlen>
  8007e6:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8007e9:	ff 75 0c             	pushl  0xc(%ebp)
  8007ec:	01 d8                	add    %ebx,%eax
  8007ee:	50                   	push   %eax
  8007ef:	e8 b8 ff ff ff       	call   8007ac <strcpy>
	return dst;
}
  8007f4:	89 d8                	mov    %ebx,%eax
  8007f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007f9:	c9                   	leave  
  8007fa:	c3                   	ret    

008007fb <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007fb:	f3 0f 1e fb          	endbr32 
  8007ff:	55                   	push   %ebp
  800800:	89 e5                	mov    %esp,%ebp
  800802:	56                   	push   %esi
  800803:	53                   	push   %ebx
  800804:	8b 75 08             	mov    0x8(%ebp),%esi
  800807:	8b 55 0c             	mov    0xc(%ebp),%edx
  80080a:	89 f3                	mov    %esi,%ebx
  80080c:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80080f:	89 f0                	mov    %esi,%eax
  800811:	39 d8                	cmp    %ebx,%eax
  800813:	74 11                	je     800826 <strncpy+0x2b>
		*dst++ = *src;
  800815:	83 c0 01             	add    $0x1,%eax
  800818:	0f b6 0a             	movzbl (%edx),%ecx
  80081b:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80081e:	80 f9 01             	cmp    $0x1,%cl
  800821:	83 da ff             	sbb    $0xffffffff,%edx
  800824:	eb eb                	jmp    800811 <strncpy+0x16>
	}
	return ret;
}
  800826:	89 f0                	mov    %esi,%eax
  800828:	5b                   	pop    %ebx
  800829:	5e                   	pop    %esi
  80082a:	5d                   	pop    %ebp
  80082b:	c3                   	ret    

0080082c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80082c:	f3 0f 1e fb          	endbr32 
  800830:	55                   	push   %ebp
  800831:	89 e5                	mov    %esp,%ebp
  800833:	56                   	push   %esi
  800834:	53                   	push   %ebx
  800835:	8b 75 08             	mov    0x8(%ebp),%esi
  800838:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80083b:	8b 55 10             	mov    0x10(%ebp),%edx
  80083e:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800840:	85 d2                	test   %edx,%edx
  800842:	74 21                	je     800865 <strlcpy+0x39>
  800844:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800848:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80084a:	39 c2                	cmp    %eax,%edx
  80084c:	74 14                	je     800862 <strlcpy+0x36>
  80084e:	0f b6 19             	movzbl (%ecx),%ebx
  800851:	84 db                	test   %bl,%bl
  800853:	74 0b                	je     800860 <strlcpy+0x34>
			*dst++ = *src++;
  800855:	83 c1 01             	add    $0x1,%ecx
  800858:	83 c2 01             	add    $0x1,%edx
  80085b:	88 5a ff             	mov    %bl,-0x1(%edx)
  80085e:	eb ea                	jmp    80084a <strlcpy+0x1e>
  800860:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800862:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800865:	29 f0                	sub    %esi,%eax
}
  800867:	5b                   	pop    %ebx
  800868:	5e                   	pop    %esi
  800869:	5d                   	pop    %ebp
  80086a:	c3                   	ret    

0080086b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80086b:	f3 0f 1e fb          	endbr32 
  80086f:	55                   	push   %ebp
  800870:	89 e5                	mov    %esp,%ebp
  800872:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800875:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800878:	0f b6 01             	movzbl (%ecx),%eax
  80087b:	84 c0                	test   %al,%al
  80087d:	74 0c                	je     80088b <strcmp+0x20>
  80087f:	3a 02                	cmp    (%edx),%al
  800881:	75 08                	jne    80088b <strcmp+0x20>
		p++, q++;
  800883:	83 c1 01             	add    $0x1,%ecx
  800886:	83 c2 01             	add    $0x1,%edx
  800889:	eb ed                	jmp    800878 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80088b:	0f b6 c0             	movzbl %al,%eax
  80088e:	0f b6 12             	movzbl (%edx),%edx
  800891:	29 d0                	sub    %edx,%eax
}
  800893:	5d                   	pop    %ebp
  800894:	c3                   	ret    

00800895 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800895:	f3 0f 1e fb          	endbr32 
  800899:	55                   	push   %ebp
  80089a:	89 e5                	mov    %esp,%ebp
  80089c:	53                   	push   %ebx
  80089d:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a3:	89 c3                	mov    %eax,%ebx
  8008a5:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008a8:	eb 06                	jmp    8008b0 <strncmp+0x1b>
		n--, p++, q++;
  8008aa:	83 c0 01             	add    $0x1,%eax
  8008ad:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008b0:	39 d8                	cmp    %ebx,%eax
  8008b2:	74 16                	je     8008ca <strncmp+0x35>
  8008b4:	0f b6 08             	movzbl (%eax),%ecx
  8008b7:	84 c9                	test   %cl,%cl
  8008b9:	74 04                	je     8008bf <strncmp+0x2a>
  8008bb:	3a 0a                	cmp    (%edx),%cl
  8008bd:	74 eb                	je     8008aa <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008bf:	0f b6 00             	movzbl (%eax),%eax
  8008c2:	0f b6 12             	movzbl (%edx),%edx
  8008c5:	29 d0                	sub    %edx,%eax
}
  8008c7:	5b                   	pop    %ebx
  8008c8:	5d                   	pop    %ebp
  8008c9:	c3                   	ret    
		return 0;
  8008ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8008cf:	eb f6                	jmp    8008c7 <strncmp+0x32>

008008d1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008d1:	f3 0f 1e fb          	endbr32 
  8008d5:	55                   	push   %ebp
  8008d6:	89 e5                	mov    %esp,%ebp
  8008d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008db:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008df:	0f b6 10             	movzbl (%eax),%edx
  8008e2:	84 d2                	test   %dl,%dl
  8008e4:	74 09                	je     8008ef <strchr+0x1e>
		if (*s == c)
  8008e6:	38 ca                	cmp    %cl,%dl
  8008e8:	74 0a                	je     8008f4 <strchr+0x23>
	for (; *s; s++)
  8008ea:	83 c0 01             	add    $0x1,%eax
  8008ed:	eb f0                	jmp    8008df <strchr+0xe>
			return (char *) s;
	return 0;
  8008ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008f4:	5d                   	pop    %ebp
  8008f5:	c3                   	ret    

008008f6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008f6:	f3 0f 1e fb          	endbr32 
  8008fa:	55                   	push   %ebp
  8008fb:	89 e5                	mov    %esp,%ebp
  8008fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800900:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800904:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800907:	38 ca                	cmp    %cl,%dl
  800909:	74 09                	je     800914 <strfind+0x1e>
  80090b:	84 d2                	test   %dl,%dl
  80090d:	74 05                	je     800914 <strfind+0x1e>
	for (; *s; s++)
  80090f:	83 c0 01             	add    $0x1,%eax
  800912:	eb f0                	jmp    800904 <strfind+0xe>
			break;
	return (char *) s;
}
  800914:	5d                   	pop    %ebp
  800915:	c3                   	ret    

00800916 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800916:	f3 0f 1e fb          	endbr32 
  80091a:	55                   	push   %ebp
  80091b:	89 e5                	mov    %esp,%ebp
  80091d:	57                   	push   %edi
  80091e:	56                   	push   %esi
  80091f:	53                   	push   %ebx
  800920:	8b 7d 08             	mov    0x8(%ebp),%edi
  800923:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800926:	85 c9                	test   %ecx,%ecx
  800928:	74 31                	je     80095b <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80092a:	89 f8                	mov    %edi,%eax
  80092c:	09 c8                	or     %ecx,%eax
  80092e:	a8 03                	test   $0x3,%al
  800930:	75 23                	jne    800955 <memset+0x3f>
		c &= 0xFF;
  800932:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800936:	89 d3                	mov    %edx,%ebx
  800938:	c1 e3 08             	shl    $0x8,%ebx
  80093b:	89 d0                	mov    %edx,%eax
  80093d:	c1 e0 18             	shl    $0x18,%eax
  800940:	89 d6                	mov    %edx,%esi
  800942:	c1 e6 10             	shl    $0x10,%esi
  800945:	09 f0                	or     %esi,%eax
  800947:	09 c2                	or     %eax,%edx
  800949:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80094b:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80094e:	89 d0                	mov    %edx,%eax
  800950:	fc                   	cld    
  800951:	f3 ab                	rep stos %eax,%es:(%edi)
  800953:	eb 06                	jmp    80095b <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800955:	8b 45 0c             	mov    0xc(%ebp),%eax
  800958:	fc                   	cld    
  800959:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80095b:	89 f8                	mov    %edi,%eax
  80095d:	5b                   	pop    %ebx
  80095e:	5e                   	pop    %esi
  80095f:	5f                   	pop    %edi
  800960:	5d                   	pop    %ebp
  800961:	c3                   	ret    

00800962 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800962:	f3 0f 1e fb          	endbr32 
  800966:	55                   	push   %ebp
  800967:	89 e5                	mov    %esp,%ebp
  800969:	57                   	push   %edi
  80096a:	56                   	push   %esi
  80096b:	8b 45 08             	mov    0x8(%ebp),%eax
  80096e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800971:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800974:	39 c6                	cmp    %eax,%esi
  800976:	73 32                	jae    8009aa <memmove+0x48>
  800978:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80097b:	39 c2                	cmp    %eax,%edx
  80097d:	76 2b                	jbe    8009aa <memmove+0x48>
		s += n;
		d += n;
  80097f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800982:	89 fe                	mov    %edi,%esi
  800984:	09 ce                	or     %ecx,%esi
  800986:	09 d6                	or     %edx,%esi
  800988:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80098e:	75 0e                	jne    80099e <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800990:	83 ef 04             	sub    $0x4,%edi
  800993:	8d 72 fc             	lea    -0x4(%edx),%esi
  800996:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800999:	fd                   	std    
  80099a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80099c:	eb 09                	jmp    8009a7 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80099e:	83 ef 01             	sub    $0x1,%edi
  8009a1:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009a4:	fd                   	std    
  8009a5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009a7:	fc                   	cld    
  8009a8:	eb 1a                	jmp    8009c4 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009aa:	89 c2                	mov    %eax,%edx
  8009ac:	09 ca                	or     %ecx,%edx
  8009ae:	09 f2                	or     %esi,%edx
  8009b0:	f6 c2 03             	test   $0x3,%dl
  8009b3:	75 0a                	jne    8009bf <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009b5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009b8:	89 c7                	mov    %eax,%edi
  8009ba:	fc                   	cld    
  8009bb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009bd:	eb 05                	jmp    8009c4 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8009bf:	89 c7                	mov    %eax,%edi
  8009c1:	fc                   	cld    
  8009c2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009c4:	5e                   	pop    %esi
  8009c5:	5f                   	pop    %edi
  8009c6:	5d                   	pop    %ebp
  8009c7:	c3                   	ret    

008009c8 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009c8:	f3 0f 1e fb          	endbr32 
  8009cc:	55                   	push   %ebp
  8009cd:	89 e5                	mov    %esp,%ebp
  8009cf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009d2:	ff 75 10             	pushl  0x10(%ebp)
  8009d5:	ff 75 0c             	pushl  0xc(%ebp)
  8009d8:	ff 75 08             	pushl  0x8(%ebp)
  8009db:	e8 82 ff ff ff       	call   800962 <memmove>
}
  8009e0:	c9                   	leave  
  8009e1:	c3                   	ret    

008009e2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009e2:	f3 0f 1e fb          	endbr32 
  8009e6:	55                   	push   %ebp
  8009e7:	89 e5                	mov    %esp,%ebp
  8009e9:	56                   	push   %esi
  8009ea:	53                   	push   %ebx
  8009eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f1:	89 c6                	mov    %eax,%esi
  8009f3:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009f6:	39 f0                	cmp    %esi,%eax
  8009f8:	74 1c                	je     800a16 <memcmp+0x34>
		if (*s1 != *s2)
  8009fa:	0f b6 08             	movzbl (%eax),%ecx
  8009fd:	0f b6 1a             	movzbl (%edx),%ebx
  800a00:	38 d9                	cmp    %bl,%cl
  800a02:	75 08                	jne    800a0c <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a04:	83 c0 01             	add    $0x1,%eax
  800a07:	83 c2 01             	add    $0x1,%edx
  800a0a:	eb ea                	jmp    8009f6 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a0c:	0f b6 c1             	movzbl %cl,%eax
  800a0f:	0f b6 db             	movzbl %bl,%ebx
  800a12:	29 d8                	sub    %ebx,%eax
  800a14:	eb 05                	jmp    800a1b <memcmp+0x39>
	}

	return 0;
  800a16:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a1b:	5b                   	pop    %ebx
  800a1c:	5e                   	pop    %esi
  800a1d:	5d                   	pop    %ebp
  800a1e:	c3                   	ret    

00800a1f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a1f:	f3 0f 1e fb          	endbr32 
  800a23:	55                   	push   %ebp
  800a24:	89 e5                	mov    %esp,%ebp
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a2c:	89 c2                	mov    %eax,%edx
  800a2e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a31:	39 d0                	cmp    %edx,%eax
  800a33:	73 09                	jae    800a3e <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a35:	38 08                	cmp    %cl,(%eax)
  800a37:	74 05                	je     800a3e <memfind+0x1f>
	for (; s < ends; s++)
  800a39:	83 c0 01             	add    $0x1,%eax
  800a3c:	eb f3                	jmp    800a31 <memfind+0x12>
			break;
	return (void *) s;
}
  800a3e:	5d                   	pop    %ebp
  800a3f:	c3                   	ret    

00800a40 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a40:	f3 0f 1e fb          	endbr32 
  800a44:	55                   	push   %ebp
  800a45:	89 e5                	mov    %esp,%ebp
  800a47:	57                   	push   %edi
  800a48:	56                   	push   %esi
  800a49:	53                   	push   %ebx
  800a4a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a4d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a50:	eb 03                	jmp    800a55 <strtol+0x15>
		s++;
  800a52:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a55:	0f b6 01             	movzbl (%ecx),%eax
  800a58:	3c 20                	cmp    $0x20,%al
  800a5a:	74 f6                	je     800a52 <strtol+0x12>
  800a5c:	3c 09                	cmp    $0x9,%al
  800a5e:	74 f2                	je     800a52 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a60:	3c 2b                	cmp    $0x2b,%al
  800a62:	74 2a                	je     800a8e <strtol+0x4e>
	int neg = 0;
  800a64:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a69:	3c 2d                	cmp    $0x2d,%al
  800a6b:	74 2b                	je     800a98 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a6d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a73:	75 0f                	jne    800a84 <strtol+0x44>
  800a75:	80 39 30             	cmpb   $0x30,(%ecx)
  800a78:	74 28                	je     800aa2 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a7a:	85 db                	test   %ebx,%ebx
  800a7c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a81:	0f 44 d8             	cmove  %eax,%ebx
  800a84:	b8 00 00 00 00       	mov    $0x0,%eax
  800a89:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a8c:	eb 46                	jmp    800ad4 <strtol+0x94>
		s++;
  800a8e:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a91:	bf 00 00 00 00       	mov    $0x0,%edi
  800a96:	eb d5                	jmp    800a6d <strtol+0x2d>
		s++, neg = 1;
  800a98:	83 c1 01             	add    $0x1,%ecx
  800a9b:	bf 01 00 00 00       	mov    $0x1,%edi
  800aa0:	eb cb                	jmp    800a6d <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800aa2:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800aa6:	74 0e                	je     800ab6 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800aa8:	85 db                	test   %ebx,%ebx
  800aaa:	75 d8                	jne    800a84 <strtol+0x44>
		s++, base = 8;
  800aac:	83 c1 01             	add    $0x1,%ecx
  800aaf:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ab4:	eb ce                	jmp    800a84 <strtol+0x44>
		s += 2, base = 16;
  800ab6:	83 c1 02             	add    $0x2,%ecx
  800ab9:	bb 10 00 00 00       	mov    $0x10,%ebx
  800abe:	eb c4                	jmp    800a84 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800ac0:	0f be d2             	movsbl %dl,%edx
  800ac3:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ac6:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ac9:	7d 3a                	jge    800b05 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800acb:	83 c1 01             	add    $0x1,%ecx
  800ace:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ad2:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ad4:	0f b6 11             	movzbl (%ecx),%edx
  800ad7:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ada:	89 f3                	mov    %esi,%ebx
  800adc:	80 fb 09             	cmp    $0x9,%bl
  800adf:	76 df                	jbe    800ac0 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800ae1:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ae4:	89 f3                	mov    %esi,%ebx
  800ae6:	80 fb 19             	cmp    $0x19,%bl
  800ae9:	77 08                	ja     800af3 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800aeb:	0f be d2             	movsbl %dl,%edx
  800aee:	83 ea 57             	sub    $0x57,%edx
  800af1:	eb d3                	jmp    800ac6 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800af3:	8d 72 bf             	lea    -0x41(%edx),%esi
  800af6:	89 f3                	mov    %esi,%ebx
  800af8:	80 fb 19             	cmp    $0x19,%bl
  800afb:	77 08                	ja     800b05 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800afd:	0f be d2             	movsbl %dl,%edx
  800b00:	83 ea 37             	sub    $0x37,%edx
  800b03:	eb c1                	jmp    800ac6 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b05:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b09:	74 05                	je     800b10 <strtol+0xd0>
		*endptr = (char *) s;
  800b0b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b0e:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b10:	89 c2                	mov    %eax,%edx
  800b12:	f7 da                	neg    %edx
  800b14:	85 ff                	test   %edi,%edi
  800b16:	0f 45 c2             	cmovne %edx,%eax
}
  800b19:	5b                   	pop    %ebx
  800b1a:	5e                   	pop    %esi
  800b1b:	5f                   	pop    %edi
  800b1c:	5d                   	pop    %ebp
  800b1d:	c3                   	ret    

00800b1e <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b1e:	f3 0f 1e fb          	endbr32 
  800b22:	55                   	push   %ebp
  800b23:	89 e5                	mov    %esp,%ebp
  800b25:	57                   	push   %edi
  800b26:	56                   	push   %esi
  800b27:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b28:	b8 00 00 00 00       	mov    $0x0,%eax
  800b2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b30:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b33:	89 c3                	mov    %eax,%ebx
  800b35:	89 c7                	mov    %eax,%edi
  800b37:	89 c6                	mov    %eax,%esi
  800b39:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b3b:	5b                   	pop    %ebx
  800b3c:	5e                   	pop    %esi
  800b3d:	5f                   	pop    %edi
  800b3e:	5d                   	pop    %ebp
  800b3f:	c3                   	ret    

00800b40 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b40:	f3 0f 1e fb          	endbr32 
  800b44:	55                   	push   %ebp
  800b45:	89 e5                	mov    %esp,%ebp
  800b47:	57                   	push   %edi
  800b48:	56                   	push   %esi
  800b49:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b4a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b4f:	b8 01 00 00 00       	mov    $0x1,%eax
  800b54:	89 d1                	mov    %edx,%ecx
  800b56:	89 d3                	mov    %edx,%ebx
  800b58:	89 d7                	mov    %edx,%edi
  800b5a:	89 d6                	mov    %edx,%esi
  800b5c:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b5e:	5b                   	pop    %ebx
  800b5f:	5e                   	pop    %esi
  800b60:	5f                   	pop    %edi
  800b61:	5d                   	pop    %ebp
  800b62:	c3                   	ret    

00800b63 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b63:	f3 0f 1e fb          	endbr32 
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
  800b6a:	57                   	push   %edi
  800b6b:	56                   	push   %esi
  800b6c:	53                   	push   %ebx
  800b6d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b70:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b75:	8b 55 08             	mov    0x8(%ebp),%edx
  800b78:	b8 03 00 00 00       	mov    $0x3,%eax
  800b7d:	89 cb                	mov    %ecx,%ebx
  800b7f:	89 cf                	mov    %ecx,%edi
  800b81:	89 ce                	mov    %ecx,%esi
  800b83:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b85:	85 c0                	test   %eax,%eax
  800b87:	7f 08                	jg     800b91 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b89:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b8c:	5b                   	pop    %ebx
  800b8d:	5e                   	pop    %esi
  800b8e:	5f                   	pop    %edi
  800b8f:	5d                   	pop    %ebp
  800b90:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b91:	83 ec 0c             	sub    $0xc,%esp
  800b94:	50                   	push   %eax
  800b95:	6a 03                	push   $0x3
  800b97:	68 04 14 80 00       	push   $0x801404
  800b9c:	6a 23                	push   $0x23
  800b9e:	68 21 14 80 00       	push   $0x801421
  800ba3:	e8 2b 03 00 00       	call   800ed3 <_panic>

00800ba8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ba8:	f3 0f 1e fb          	endbr32 
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	57                   	push   %edi
  800bb0:	56                   	push   %esi
  800bb1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bb2:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb7:	b8 02 00 00 00       	mov    $0x2,%eax
  800bbc:	89 d1                	mov    %edx,%ecx
  800bbe:	89 d3                	mov    %edx,%ebx
  800bc0:	89 d7                	mov    %edx,%edi
  800bc2:	89 d6                	mov    %edx,%esi
  800bc4:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bc6:	5b                   	pop    %ebx
  800bc7:	5e                   	pop    %esi
  800bc8:	5f                   	pop    %edi
  800bc9:	5d                   	pop    %ebp
  800bca:	c3                   	ret    

00800bcb <sys_yield>:

void
sys_yield(void)
{
  800bcb:	f3 0f 1e fb          	endbr32 
  800bcf:	55                   	push   %ebp
  800bd0:	89 e5                	mov    %esp,%ebp
  800bd2:	57                   	push   %edi
  800bd3:	56                   	push   %esi
  800bd4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd5:	ba 00 00 00 00       	mov    $0x0,%edx
  800bda:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bdf:	89 d1                	mov    %edx,%ecx
  800be1:	89 d3                	mov    %edx,%ebx
  800be3:	89 d7                	mov    %edx,%edi
  800be5:	89 d6                	mov    %edx,%esi
  800be7:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800be9:	5b                   	pop    %ebx
  800bea:	5e                   	pop    %esi
  800beb:	5f                   	pop    %edi
  800bec:	5d                   	pop    %ebp
  800bed:	c3                   	ret    

00800bee <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bee:	f3 0f 1e fb          	endbr32 
  800bf2:	55                   	push   %ebp
  800bf3:	89 e5                	mov    %esp,%ebp
  800bf5:	57                   	push   %edi
  800bf6:	56                   	push   %esi
  800bf7:	53                   	push   %ebx
  800bf8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bfb:	be 00 00 00 00       	mov    $0x0,%esi
  800c00:	8b 55 08             	mov    0x8(%ebp),%edx
  800c03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c06:	b8 04 00 00 00       	mov    $0x4,%eax
  800c0b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c0e:	89 f7                	mov    %esi,%edi
  800c10:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c12:	85 c0                	test   %eax,%eax
  800c14:	7f 08                	jg     800c1e <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c16:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c19:	5b                   	pop    %ebx
  800c1a:	5e                   	pop    %esi
  800c1b:	5f                   	pop    %edi
  800c1c:	5d                   	pop    %ebp
  800c1d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c1e:	83 ec 0c             	sub    $0xc,%esp
  800c21:	50                   	push   %eax
  800c22:	6a 04                	push   $0x4
  800c24:	68 04 14 80 00       	push   $0x801404
  800c29:	6a 23                	push   $0x23
  800c2b:	68 21 14 80 00       	push   $0x801421
  800c30:	e8 9e 02 00 00       	call   800ed3 <_panic>

00800c35 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c35:	f3 0f 1e fb          	endbr32 
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
  800c3c:	57                   	push   %edi
  800c3d:	56                   	push   %esi
  800c3e:	53                   	push   %ebx
  800c3f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c42:	8b 55 08             	mov    0x8(%ebp),%edx
  800c45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c48:	b8 05 00 00 00       	mov    $0x5,%eax
  800c4d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c50:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c53:	8b 75 18             	mov    0x18(%ebp),%esi
  800c56:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c58:	85 c0                	test   %eax,%eax
  800c5a:	7f 08                	jg     800c64 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c5f:	5b                   	pop    %ebx
  800c60:	5e                   	pop    %esi
  800c61:	5f                   	pop    %edi
  800c62:	5d                   	pop    %ebp
  800c63:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c64:	83 ec 0c             	sub    $0xc,%esp
  800c67:	50                   	push   %eax
  800c68:	6a 05                	push   $0x5
  800c6a:	68 04 14 80 00       	push   $0x801404
  800c6f:	6a 23                	push   $0x23
  800c71:	68 21 14 80 00       	push   $0x801421
  800c76:	e8 58 02 00 00       	call   800ed3 <_panic>

00800c7b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c7b:	f3 0f 1e fb          	endbr32 
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	57                   	push   %edi
  800c83:	56                   	push   %esi
  800c84:	53                   	push   %ebx
  800c85:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c88:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c93:	b8 06 00 00 00       	mov    $0x6,%eax
  800c98:	89 df                	mov    %ebx,%edi
  800c9a:	89 de                	mov    %ebx,%esi
  800c9c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c9e:	85 c0                	test   %eax,%eax
  800ca0:	7f 08                	jg     800caa <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ca2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca5:	5b                   	pop    %ebx
  800ca6:	5e                   	pop    %esi
  800ca7:	5f                   	pop    %edi
  800ca8:	5d                   	pop    %ebp
  800ca9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800caa:	83 ec 0c             	sub    $0xc,%esp
  800cad:	50                   	push   %eax
  800cae:	6a 06                	push   $0x6
  800cb0:	68 04 14 80 00       	push   $0x801404
  800cb5:	6a 23                	push   $0x23
  800cb7:	68 21 14 80 00       	push   $0x801421
  800cbc:	e8 12 02 00 00       	call   800ed3 <_panic>

00800cc1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cc1:	f3 0f 1e fb          	endbr32 
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	57                   	push   %edi
  800cc9:	56                   	push   %esi
  800cca:	53                   	push   %ebx
  800ccb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cce:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd9:	b8 08 00 00 00       	mov    $0x8,%eax
  800cde:	89 df                	mov    %ebx,%edi
  800ce0:	89 de                	mov    %ebx,%esi
  800ce2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce4:	85 c0                	test   %eax,%eax
  800ce6:	7f 08                	jg     800cf0 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ce8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ceb:	5b                   	pop    %ebx
  800cec:	5e                   	pop    %esi
  800ced:	5f                   	pop    %edi
  800cee:	5d                   	pop    %ebp
  800cef:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf0:	83 ec 0c             	sub    $0xc,%esp
  800cf3:	50                   	push   %eax
  800cf4:	6a 08                	push   $0x8
  800cf6:	68 04 14 80 00       	push   $0x801404
  800cfb:	6a 23                	push   $0x23
  800cfd:	68 21 14 80 00       	push   $0x801421
  800d02:	e8 cc 01 00 00       	call   800ed3 <_panic>

00800d07 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d07:	f3 0f 1e fb          	endbr32 
  800d0b:	55                   	push   %ebp
  800d0c:	89 e5                	mov    %esp,%ebp
  800d0e:	57                   	push   %edi
  800d0f:	56                   	push   %esi
  800d10:	53                   	push   %ebx
  800d11:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d14:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d19:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d1f:	b8 09 00 00 00       	mov    $0x9,%eax
  800d24:	89 df                	mov    %ebx,%edi
  800d26:	89 de                	mov    %ebx,%esi
  800d28:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d2a:	85 c0                	test   %eax,%eax
  800d2c:	7f 08                	jg     800d36 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d31:	5b                   	pop    %ebx
  800d32:	5e                   	pop    %esi
  800d33:	5f                   	pop    %edi
  800d34:	5d                   	pop    %ebp
  800d35:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d36:	83 ec 0c             	sub    $0xc,%esp
  800d39:	50                   	push   %eax
  800d3a:	6a 09                	push   $0x9
  800d3c:	68 04 14 80 00       	push   $0x801404
  800d41:	6a 23                	push   $0x23
  800d43:	68 21 14 80 00       	push   $0x801421
  800d48:	e8 86 01 00 00       	call   800ed3 <_panic>

00800d4d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d4d:	f3 0f 1e fb          	endbr32 
  800d51:	55                   	push   %ebp
  800d52:	89 e5                	mov    %esp,%ebp
  800d54:	57                   	push   %edi
  800d55:	56                   	push   %esi
  800d56:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d57:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d62:	be 00 00 00 00       	mov    $0x0,%esi
  800d67:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d6a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d6d:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d6f:	5b                   	pop    %ebx
  800d70:	5e                   	pop    %esi
  800d71:	5f                   	pop    %edi
  800d72:	5d                   	pop    %ebp
  800d73:	c3                   	ret    

00800d74 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d74:	f3 0f 1e fb          	endbr32 
  800d78:	55                   	push   %ebp
  800d79:	89 e5                	mov    %esp,%ebp
  800d7b:	57                   	push   %edi
  800d7c:	56                   	push   %esi
  800d7d:	53                   	push   %ebx
  800d7e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d81:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d86:	8b 55 08             	mov    0x8(%ebp),%edx
  800d89:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d8e:	89 cb                	mov    %ecx,%ebx
  800d90:	89 cf                	mov    %ecx,%edi
  800d92:	89 ce                	mov    %ecx,%esi
  800d94:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d96:	85 c0                	test   %eax,%eax
  800d98:	7f 08                	jg     800da2 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9d:	5b                   	pop    %ebx
  800d9e:	5e                   	pop    %esi
  800d9f:	5f                   	pop    %edi
  800da0:	5d                   	pop    %ebp
  800da1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da2:	83 ec 0c             	sub    $0xc,%esp
  800da5:	50                   	push   %eax
  800da6:	6a 0c                	push   $0xc
  800da8:	68 04 14 80 00       	push   $0x801404
  800dad:	6a 23                	push   $0x23
  800daf:	68 21 14 80 00       	push   $0x801421
  800db4:	e8 1a 01 00 00       	call   800ed3 <_panic>

00800db9 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  800db9:	f3 0f 1e fb          	endbr32 
  800dbd:	55                   	push   %ebp
  800dbe:	89 e5                	mov    %esp,%ebp
  800dc0:	56                   	push   %esi
  800dc1:	53                   	push   %ebx
  800dc2:	8b 75 08             	mov    0x8(%ebp),%esi
  800dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  800dcb:	85 c0                	test   %eax,%eax
  800dcd:	74 3d                	je     800e0c <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  800dcf:	83 ec 0c             	sub    $0xc,%esp
  800dd2:	50                   	push   %eax
  800dd3:	e8 9c ff ff ff       	call   800d74 <sys_ipc_recv>
  800dd8:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  800ddb:	85 f6                	test   %esi,%esi
  800ddd:	74 0b                	je     800dea <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  800ddf:	8b 15 04 20 80 00    	mov    0x802004,%edx
  800de5:	8b 52 74             	mov    0x74(%edx),%edx
  800de8:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  800dea:	85 db                	test   %ebx,%ebx
  800dec:	74 0b                	je     800df9 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  800dee:	8b 15 04 20 80 00    	mov    0x802004,%edx
  800df4:	8b 52 78             	mov    0x78(%edx),%edx
  800df7:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  800df9:	85 c0                	test   %eax,%eax
  800dfb:	78 21                	js     800e1e <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  800dfd:	a1 04 20 80 00       	mov    0x802004,%eax
  800e02:	8b 40 70             	mov    0x70(%eax),%eax
}
  800e05:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e08:	5b                   	pop    %ebx
  800e09:	5e                   	pop    %esi
  800e0a:	5d                   	pop    %ebp
  800e0b:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  800e0c:	83 ec 0c             	sub    $0xc,%esp
  800e0f:	68 00 00 c0 ee       	push   $0xeec00000
  800e14:	e8 5b ff ff ff       	call   800d74 <sys_ipc_recv>
  800e19:	83 c4 10             	add    $0x10,%esp
  800e1c:	eb bd                	jmp    800ddb <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  800e1e:	85 f6                	test   %esi,%esi
  800e20:	74 10                	je     800e32 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  800e22:	85 db                	test   %ebx,%ebx
  800e24:	75 df                	jne    800e05 <ipc_recv+0x4c>
  800e26:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  800e2d:	00 00 00 
  800e30:	eb d3                	jmp    800e05 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  800e32:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  800e39:	00 00 00 
  800e3c:	eb e4                	jmp    800e22 <ipc_recv+0x69>

00800e3e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  800e3e:	f3 0f 1e fb          	endbr32 
  800e42:	55                   	push   %ebp
  800e43:	89 e5                	mov    %esp,%ebp
  800e45:	57                   	push   %edi
  800e46:	56                   	push   %esi
  800e47:	53                   	push   %ebx
  800e48:	83 ec 0c             	sub    $0xc,%esp
  800e4b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e4e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e51:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  800e54:	85 db                	test   %ebx,%ebx
  800e56:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  800e5b:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  800e5e:	ff 75 14             	pushl  0x14(%ebp)
  800e61:	53                   	push   %ebx
  800e62:	56                   	push   %esi
  800e63:	57                   	push   %edi
  800e64:	e8 e4 fe ff ff       	call   800d4d <sys_ipc_try_send>
  800e69:	83 c4 10             	add    $0x10,%esp
  800e6c:	85 c0                	test   %eax,%eax
  800e6e:	79 1e                	jns    800e8e <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  800e70:	83 f8 f9             	cmp    $0xfffffff9,%eax
  800e73:	75 07                	jne    800e7c <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  800e75:	e8 51 fd ff ff       	call   800bcb <sys_yield>
  800e7a:	eb e2                	jmp    800e5e <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  800e7c:	50                   	push   %eax
  800e7d:	68 2f 14 80 00       	push   $0x80142f
  800e82:	6a 59                	push   $0x59
  800e84:	68 4a 14 80 00       	push   $0x80144a
  800e89:	e8 45 00 00 00       	call   800ed3 <_panic>
	}


}
  800e8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e91:	5b                   	pop    %ebx
  800e92:	5e                   	pop    %esi
  800e93:	5f                   	pop    %edi
  800e94:	5d                   	pop    %ebp
  800e95:	c3                   	ret    

00800e96 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  800e96:	f3 0f 1e fb          	endbr32 
  800e9a:	55                   	push   %ebp
  800e9b:	89 e5                	mov    %esp,%ebp
  800e9d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  800ea0:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  800ea5:	6b d0 7c             	imul   $0x7c,%eax,%edx
  800ea8:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800eae:	8b 52 50             	mov    0x50(%edx),%edx
  800eb1:	39 ca                	cmp    %ecx,%edx
  800eb3:	74 11                	je     800ec6 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  800eb5:	83 c0 01             	add    $0x1,%eax
  800eb8:	3d 00 04 00 00       	cmp    $0x400,%eax
  800ebd:	75 e6                	jne    800ea5 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  800ebf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec4:	eb 0b                	jmp    800ed1 <ipc_find_env+0x3b>
			return envs[i].env_id;
  800ec6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800ec9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800ece:	8b 40 48             	mov    0x48(%eax),%eax
}
  800ed1:	5d                   	pop    %ebp
  800ed2:	c3                   	ret    

00800ed3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800ed3:	f3 0f 1e fb          	endbr32 
  800ed7:	55                   	push   %ebp
  800ed8:	89 e5                	mov    %esp,%ebp
  800eda:	56                   	push   %esi
  800edb:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800edc:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800edf:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800ee5:	e8 be fc ff ff       	call   800ba8 <sys_getenvid>
  800eea:	83 ec 0c             	sub    $0xc,%esp
  800eed:	ff 75 0c             	pushl  0xc(%ebp)
  800ef0:	ff 75 08             	pushl  0x8(%ebp)
  800ef3:	56                   	push   %esi
  800ef4:	50                   	push   %eax
  800ef5:	68 54 14 80 00       	push   $0x801454
  800efa:	e8 a3 f2 ff ff       	call   8001a2 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800eff:	83 c4 18             	add    $0x18,%esp
  800f02:	53                   	push   %ebx
  800f03:	ff 75 10             	pushl  0x10(%ebp)
  800f06:	e8 42 f2 ff ff       	call   80014d <vcprintf>
	cprintf("\n");
  800f0b:	c7 04 24 48 14 80 00 	movl   $0x801448,(%esp)
  800f12:	e8 8b f2 ff ff       	call   8001a2 <cprintf>
  800f17:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800f1a:	cc                   	int3   
  800f1b:	eb fd                	jmp    800f1a <_panic+0x47>
  800f1d:	66 90                	xchg   %ax,%ax
  800f1f:	90                   	nop

00800f20 <__udivdi3>:
  800f20:	f3 0f 1e fb          	endbr32 
  800f24:	55                   	push   %ebp
  800f25:	57                   	push   %edi
  800f26:	56                   	push   %esi
  800f27:	53                   	push   %ebx
  800f28:	83 ec 1c             	sub    $0x1c,%esp
  800f2b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800f2f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800f33:	8b 74 24 34          	mov    0x34(%esp),%esi
  800f37:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800f3b:	85 d2                	test   %edx,%edx
  800f3d:	75 19                	jne    800f58 <__udivdi3+0x38>
  800f3f:	39 f3                	cmp    %esi,%ebx
  800f41:	76 4d                	jbe    800f90 <__udivdi3+0x70>
  800f43:	31 ff                	xor    %edi,%edi
  800f45:	89 e8                	mov    %ebp,%eax
  800f47:	89 f2                	mov    %esi,%edx
  800f49:	f7 f3                	div    %ebx
  800f4b:	89 fa                	mov    %edi,%edx
  800f4d:	83 c4 1c             	add    $0x1c,%esp
  800f50:	5b                   	pop    %ebx
  800f51:	5e                   	pop    %esi
  800f52:	5f                   	pop    %edi
  800f53:	5d                   	pop    %ebp
  800f54:	c3                   	ret    
  800f55:	8d 76 00             	lea    0x0(%esi),%esi
  800f58:	39 f2                	cmp    %esi,%edx
  800f5a:	76 14                	jbe    800f70 <__udivdi3+0x50>
  800f5c:	31 ff                	xor    %edi,%edi
  800f5e:	31 c0                	xor    %eax,%eax
  800f60:	89 fa                	mov    %edi,%edx
  800f62:	83 c4 1c             	add    $0x1c,%esp
  800f65:	5b                   	pop    %ebx
  800f66:	5e                   	pop    %esi
  800f67:	5f                   	pop    %edi
  800f68:	5d                   	pop    %ebp
  800f69:	c3                   	ret    
  800f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800f70:	0f bd fa             	bsr    %edx,%edi
  800f73:	83 f7 1f             	xor    $0x1f,%edi
  800f76:	75 48                	jne    800fc0 <__udivdi3+0xa0>
  800f78:	39 f2                	cmp    %esi,%edx
  800f7a:	72 06                	jb     800f82 <__udivdi3+0x62>
  800f7c:	31 c0                	xor    %eax,%eax
  800f7e:	39 eb                	cmp    %ebp,%ebx
  800f80:	77 de                	ja     800f60 <__udivdi3+0x40>
  800f82:	b8 01 00 00 00       	mov    $0x1,%eax
  800f87:	eb d7                	jmp    800f60 <__udivdi3+0x40>
  800f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f90:	89 d9                	mov    %ebx,%ecx
  800f92:	85 db                	test   %ebx,%ebx
  800f94:	75 0b                	jne    800fa1 <__udivdi3+0x81>
  800f96:	b8 01 00 00 00       	mov    $0x1,%eax
  800f9b:	31 d2                	xor    %edx,%edx
  800f9d:	f7 f3                	div    %ebx
  800f9f:	89 c1                	mov    %eax,%ecx
  800fa1:	31 d2                	xor    %edx,%edx
  800fa3:	89 f0                	mov    %esi,%eax
  800fa5:	f7 f1                	div    %ecx
  800fa7:	89 c6                	mov    %eax,%esi
  800fa9:	89 e8                	mov    %ebp,%eax
  800fab:	89 f7                	mov    %esi,%edi
  800fad:	f7 f1                	div    %ecx
  800faf:	89 fa                	mov    %edi,%edx
  800fb1:	83 c4 1c             	add    $0x1c,%esp
  800fb4:	5b                   	pop    %ebx
  800fb5:	5e                   	pop    %esi
  800fb6:	5f                   	pop    %edi
  800fb7:	5d                   	pop    %ebp
  800fb8:	c3                   	ret    
  800fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fc0:	89 f9                	mov    %edi,%ecx
  800fc2:	b8 20 00 00 00       	mov    $0x20,%eax
  800fc7:	29 f8                	sub    %edi,%eax
  800fc9:	d3 e2                	shl    %cl,%edx
  800fcb:	89 54 24 08          	mov    %edx,0x8(%esp)
  800fcf:	89 c1                	mov    %eax,%ecx
  800fd1:	89 da                	mov    %ebx,%edx
  800fd3:	d3 ea                	shr    %cl,%edx
  800fd5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800fd9:	09 d1                	or     %edx,%ecx
  800fdb:	89 f2                	mov    %esi,%edx
  800fdd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800fe1:	89 f9                	mov    %edi,%ecx
  800fe3:	d3 e3                	shl    %cl,%ebx
  800fe5:	89 c1                	mov    %eax,%ecx
  800fe7:	d3 ea                	shr    %cl,%edx
  800fe9:	89 f9                	mov    %edi,%ecx
  800feb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800fef:	89 eb                	mov    %ebp,%ebx
  800ff1:	d3 e6                	shl    %cl,%esi
  800ff3:	89 c1                	mov    %eax,%ecx
  800ff5:	d3 eb                	shr    %cl,%ebx
  800ff7:	09 de                	or     %ebx,%esi
  800ff9:	89 f0                	mov    %esi,%eax
  800ffb:	f7 74 24 08          	divl   0x8(%esp)
  800fff:	89 d6                	mov    %edx,%esi
  801001:	89 c3                	mov    %eax,%ebx
  801003:	f7 64 24 0c          	mull   0xc(%esp)
  801007:	39 d6                	cmp    %edx,%esi
  801009:	72 15                	jb     801020 <__udivdi3+0x100>
  80100b:	89 f9                	mov    %edi,%ecx
  80100d:	d3 e5                	shl    %cl,%ebp
  80100f:	39 c5                	cmp    %eax,%ebp
  801011:	73 04                	jae    801017 <__udivdi3+0xf7>
  801013:	39 d6                	cmp    %edx,%esi
  801015:	74 09                	je     801020 <__udivdi3+0x100>
  801017:	89 d8                	mov    %ebx,%eax
  801019:	31 ff                	xor    %edi,%edi
  80101b:	e9 40 ff ff ff       	jmp    800f60 <__udivdi3+0x40>
  801020:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801023:	31 ff                	xor    %edi,%edi
  801025:	e9 36 ff ff ff       	jmp    800f60 <__udivdi3+0x40>
  80102a:	66 90                	xchg   %ax,%ax
  80102c:	66 90                	xchg   %ax,%ax
  80102e:	66 90                	xchg   %ax,%ax

00801030 <__umoddi3>:
  801030:	f3 0f 1e fb          	endbr32 
  801034:	55                   	push   %ebp
  801035:	57                   	push   %edi
  801036:	56                   	push   %esi
  801037:	53                   	push   %ebx
  801038:	83 ec 1c             	sub    $0x1c,%esp
  80103b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80103f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801043:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801047:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80104b:	85 c0                	test   %eax,%eax
  80104d:	75 19                	jne    801068 <__umoddi3+0x38>
  80104f:	39 df                	cmp    %ebx,%edi
  801051:	76 5d                	jbe    8010b0 <__umoddi3+0x80>
  801053:	89 f0                	mov    %esi,%eax
  801055:	89 da                	mov    %ebx,%edx
  801057:	f7 f7                	div    %edi
  801059:	89 d0                	mov    %edx,%eax
  80105b:	31 d2                	xor    %edx,%edx
  80105d:	83 c4 1c             	add    $0x1c,%esp
  801060:	5b                   	pop    %ebx
  801061:	5e                   	pop    %esi
  801062:	5f                   	pop    %edi
  801063:	5d                   	pop    %ebp
  801064:	c3                   	ret    
  801065:	8d 76 00             	lea    0x0(%esi),%esi
  801068:	89 f2                	mov    %esi,%edx
  80106a:	39 d8                	cmp    %ebx,%eax
  80106c:	76 12                	jbe    801080 <__umoddi3+0x50>
  80106e:	89 f0                	mov    %esi,%eax
  801070:	89 da                	mov    %ebx,%edx
  801072:	83 c4 1c             	add    $0x1c,%esp
  801075:	5b                   	pop    %ebx
  801076:	5e                   	pop    %esi
  801077:	5f                   	pop    %edi
  801078:	5d                   	pop    %ebp
  801079:	c3                   	ret    
  80107a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801080:	0f bd e8             	bsr    %eax,%ebp
  801083:	83 f5 1f             	xor    $0x1f,%ebp
  801086:	75 50                	jne    8010d8 <__umoddi3+0xa8>
  801088:	39 d8                	cmp    %ebx,%eax
  80108a:	0f 82 e0 00 00 00    	jb     801170 <__umoddi3+0x140>
  801090:	89 d9                	mov    %ebx,%ecx
  801092:	39 f7                	cmp    %esi,%edi
  801094:	0f 86 d6 00 00 00    	jbe    801170 <__umoddi3+0x140>
  80109a:	89 d0                	mov    %edx,%eax
  80109c:	89 ca                	mov    %ecx,%edx
  80109e:	83 c4 1c             	add    $0x1c,%esp
  8010a1:	5b                   	pop    %ebx
  8010a2:	5e                   	pop    %esi
  8010a3:	5f                   	pop    %edi
  8010a4:	5d                   	pop    %ebp
  8010a5:	c3                   	ret    
  8010a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010ad:	8d 76 00             	lea    0x0(%esi),%esi
  8010b0:	89 fd                	mov    %edi,%ebp
  8010b2:	85 ff                	test   %edi,%edi
  8010b4:	75 0b                	jne    8010c1 <__umoddi3+0x91>
  8010b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8010bb:	31 d2                	xor    %edx,%edx
  8010bd:	f7 f7                	div    %edi
  8010bf:	89 c5                	mov    %eax,%ebp
  8010c1:	89 d8                	mov    %ebx,%eax
  8010c3:	31 d2                	xor    %edx,%edx
  8010c5:	f7 f5                	div    %ebp
  8010c7:	89 f0                	mov    %esi,%eax
  8010c9:	f7 f5                	div    %ebp
  8010cb:	89 d0                	mov    %edx,%eax
  8010cd:	31 d2                	xor    %edx,%edx
  8010cf:	eb 8c                	jmp    80105d <__umoddi3+0x2d>
  8010d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010d8:	89 e9                	mov    %ebp,%ecx
  8010da:	ba 20 00 00 00       	mov    $0x20,%edx
  8010df:	29 ea                	sub    %ebp,%edx
  8010e1:	d3 e0                	shl    %cl,%eax
  8010e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010e7:	89 d1                	mov    %edx,%ecx
  8010e9:	89 f8                	mov    %edi,%eax
  8010eb:	d3 e8                	shr    %cl,%eax
  8010ed:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8010f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8010f5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8010f9:	09 c1                	or     %eax,%ecx
  8010fb:	89 d8                	mov    %ebx,%eax
  8010fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801101:	89 e9                	mov    %ebp,%ecx
  801103:	d3 e7                	shl    %cl,%edi
  801105:	89 d1                	mov    %edx,%ecx
  801107:	d3 e8                	shr    %cl,%eax
  801109:	89 e9                	mov    %ebp,%ecx
  80110b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80110f:	d3 e3                	shl    %cl,%ebx
  801111:	89 c7                	mov    %eax,%edi
  801113:	89 d1                	mov    %edx,%ecx
  801115:	89 f0                	mov    %esi,%eax
  801117:	d3 e8                	shr    %cl,%eax
  801119:	89 e9                	mov    %ebp,%ecx
  80111b:	89 fa                	mov    %edi,%edx
  80111d:	d3 e6                	shl    %cl,%esi
  80111f:	09 d8                	or     %ebx,%eax
  801121:	f7 74 24 08          	divl   0x8(%esp)
  801125:	89 d1                	mov    %edx,%ecx
  801127:	89 f3                	mov    %esi,%ebx
  801129:	f7 64 24 0c          	mull   0xc(%esp)
  80112d:	89 c6                	mov    %eax,%esi
  80112f:	89 d7                	mov    %edx,%edi
  801131:	39 d1                	cmp    %edx,%ecx
  801133:	72 06                	jb     80113b <__umoddi3+0x10b>
  801135:	75 10                	jne    801147 <__umoddi3+0x117>
  801137:	39 c3                	cmp    %eax,%ebx
  801139:	73 0c                	jae    801147 <__umoddi3+0x117>
  80113b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80113f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801143:	89 d7                	mov    %edx,%edi
  801145:	89 c6                	mov    %eax,%esi
  801147:	89 ca                	mov    %ecx,%edx
  801149:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80114e:	29 f3                	sub    %esi,%ebx
  801150:	19 fa                	sbb    %edi,%edx
  801152:	89 d0                	mov    %edx,%eax
  801154:	d3 e0                	shl    %cl,%eax
  801156:	89 e9                	mov    %ebp,%ecx
  801158:	d3 eb                	shr    %cl,%ebx
  80115a:	d3 ea                	shr    %cl,%edx
  80115c:	09 d8                	or     %ebx,%eax
  80115e:	83 c4 1c             	add    $0x1c,%esp
  801161:	5b                   	pop    %ebx
  801162:	5e                   	pop    %esi
  801163:	5f                   	pop    %edi
  801164:	5d                   	pop    %ebp
  801165:	c3                   	ret    
  801166:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80116d:	8d 76 00             	lea    0x0(%esi),%esi
  801170:	29 fe                	sub    %edi,%esi
  801172:	19 c3                	sbb    %eax,%ebx
  801174:	89 f2                	mov    %esi,%edx
  801176:	89 d9                	mov    %ebx,%ecx
  801178:	e9 1d ff ff ff       	jmp    80109a <__umoddi3+0x6a>
