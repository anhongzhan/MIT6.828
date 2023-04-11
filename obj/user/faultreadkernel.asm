
obj/user/faultreadkernel:     file format elf32-i386


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
  80002c:	e8 21 00 00 00       	call   800052 <libmain>
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
	cprintf("I read %08x from location 0xf0100000!\n", *(unsigned*)0xf0100000);
  80003d:	ff 35 00 00 10 f0    	pushl  0xf0100000
  800043:	68 20 10 80 00       	push   $0x801020
  800048:	e8 02 01 00 00       	call   80014f <cprintf>
}
  80004d:	83 c4 10             	add    $0x10,%esp
  800050:	c9                   	leave  
  800051:	c3                   	ret    

00800052 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800052:	f3 0f 1e fb          	endbr32 
  800056:	55                   	push   %ebp
  800057:	89 e5                	mov    %esp,%ebp
  800059:	56                   	push   %esi
  80005a:	53                   	push   %ebx
  80005b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80005e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800061:	e8 ef 0a 00 00       	call   800b55 <sys_getenvid>
  800066:	25 ff 03 00 00       	and    $0x3ff,%eax
  80006b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80006e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800073:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800078:	85 db                	test   %ebx,%ebx
  80007a:	7e 07                	jle    800083 <libmain+0x31>
		binaryname = argv[0];
  80007c:	8b 06                	mov    (%esi),%eax
  80007e:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800083:	83 ec 08             	sub    $0x8,%esp
  800086:	56                   	push   %esi
  800087:	53                   	push   %ebx
  800088:	e8 a6 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80008d:	e8 0a 00 00 00       	call   80009c <exit>
}
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800098:	5b                   	pop    %ebx
  800099:	5e                   	pop    %esi
  80009a:	5d                   	pop    %ebp
  80009b:	c3                   	ret    

0080009c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80009c:	f3 0f 1e fb          	endbr32 
  8000a0:	55                   	push   %ebp
  8000a1:	89 e5                	mov    %esp,%ebp
  8000a3:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  8000a6:	6a 00                	push   $0x0
  8000a8:	e8 63 0a 00 00       	call   800b10 <sys_env_destroy>
}
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	c9                   	leave  
  8000b1:	c3                   	ret    

008000b2 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000b2:	f3 0f 1e fb          	endbr32 
  8000b6:	55                   	push   %ebp
  8000b7:	89 e5                	mov    %esp,%ebp
  8000b9:	53                   	push   %ebx
  8000ba:	83 ec 04             	sub    $0x4,%esp
  8000bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000c0:	8b 13                	mov    (%ebx),%edx
  8000c2:	8d 42 01             	lea    0x1(%edx),%eax
  8000c5:	89 03                	mov    %eax,(%ebx)
  8000c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000ca:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000ce:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000d3:	74 09                	je     8000de <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000d5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000dc:	c9                   	leave  
  8000dd:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000de:	83 ec 08             	sub    $0x8,%esp
  8000e1:	68 ff 00 00 00       	push   $0xff
  8000e6:	8d 43 08             	lea    0x8(%ebx),%eax
  8000e9:	50                   	push   %eax
  8000ea:	e8 dc 09 00 00       	call   800acb <sys_cputs>
		b->idx = 0;
  8000ef:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000f5:	83 c4 10             	add    $0x10,%esp
  8000f8:	eb db                	jmp    8000d5 <putch+0x23>

008000fa <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8000fa:	f3 0f 1e fb          	endbr32 
  8000fe:	55                   	push   %ebp
  8000ff:	89 e5                	mov    %esp,%ebp
  800101:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800107:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80010e:	00 00 00 
	b.cnt = 0;
  800111:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800118:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80011b:	ff 75 0c             	pushl  0xc(%ebp)
  80011e:	ff 75 08             	pushl  0x8(%ebp)
  800121:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800127:	50                   	push   %eax
  800128:	68 b2 00 80 00       	push   $0x8000b2
  80012d:	e8 20 01 00 00       	call   800252 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800132:	83 c4 08             	add    $0x8,%esp
  800135:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80013b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800141:	50                   	push   %eax
  800142:	e8 84 09 00 00       	call   800acb <sys_cputs>

	return b.cnt;
}
  800147:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80014d:	c9                   	leave  
  80014e:	c3                   	ret    

0080014f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80014f:	f3 0f 1e fb          	endbr32 
  800153:	55                   	push   %ebp
  800154:	89 e5                	mov    %esp,%ebp
  800156:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800159:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80015c:	50                   	push   %eax
  80015d:	ff 75 08             	pushl  0x8(%ebp)
  800160:	e8 95 ff ff ff       	call   8000fa <vcprintf>
	va_end(ap);

	return cnt;
}
  800165:	c9                   	leave  
  800166:	c3                   	ret    

00800167 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800167:	55                   	push   %ebp
  800168:	89 e5                	mov    %esp,%ebp
  80016a:	57                   	push   %edi
  80016b:	56                   	push   %esi
  80016c:	53                   	push   %ebx
  80016d:	83 ec 1c             	sub    $0x1c,%esp
  800170:	89 c7                	mov    %eax,%edi
  800172:	89 d6                	mov    %edx,%esi
  800174:	8b 45 08             	mov    0x8(%ebp),%eax
  800177:	8b 55 0c             	mov    0xc(%ebp),%edx
  80017a:	89 d1                	mov    %edx,%ecx
  80017c:	89 c2                	mov    %eax,%edx
  80017e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800181:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800184:	8b 45 10             	mov    0x10(%ebp),%eax
  800187:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80018a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80018d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800194:	39 c2                	cmp    %eax,%edx
  800196:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800199:	72 3e                	jb     8001d9 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80019b:	83 ec 0c             	sub    $0xc,%esp
  80019e:	ff 75 18             	pushl  0x18(%ebp)
  8001a1:	83 eb 01             	sub    $0x1,%ebx
  8001a4:	53                   	push   %ebx
  8001a5:	50                   	push   %eax
  8001a6:	83 ec 08             	sub    $0x8,%esp
  8001a9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001ac:	ff 75 e0             	pushl  -0x20(%ebp)
  8001af:	ff 75 dc             	pushl  -0x24(%ebp)
  8001b2:	ff 75 d8             	pushl  -0x28(%ebp)
  8001b5:	e8 f6 0b 00 00       	call   800db0 <__udivdi3>
  8001ba:	83 c4 18             	add    $0x18,%esp
  8001bd:	52                   	push   %edx
  8001be:	50                   	push   %eax
  8001bf:	89 f2                	mov    %esi,%edx
  8001c1:	89 f8                	mov    %edi,%eax
  8001c3:	e8 9f ff ff ff       	call   800167 <printnum>
  8001c8:	83 c4 20             	add    $0x20,%esp
  8001cb:	eb 13                	jmp    8001e0 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001cd:	83 ec 08             	sub    $0x8,%esp
  8001d0:	56                   	push   %esi
  8001d1:	ff 75 18             	pushl  0x18(%ebp)
  8001d4:	ff d7                	call   *%edi
  8001d6:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001d9:	83 eb 01             	sub    $0x1,%ebx
  8001dc:	85 db                	test   %ebx,%ebx
  8001de:	7f ed                	jg     8001cd <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001e0:	83 ec 08             	sub    $0x8,%esp
  8001e3:	56                   	push   %esi
  8001e4:	83 ec 04             	sub    $0x4,%esp
  8001e7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001ea:	ff 75 e0             	pushl  -0x20(%ebp)
  8001ed:	ff 75 dc             	pushl  -0x24(%ebp)
  8001f0:	ff 75 d8             	pushl  -0x28(%ebp)
  8001f3:	e8 c8 0c 00 00       	call   800ec0 <__umoddi3>
  8001f8:	83 c4 14             	add    $0x14,%esp
  8001fb:	0f be 80 51 10 80 00 	movsbl 0x801051(%eax),%eax
  800202:	50                   	push   %eax
  800203:	ff d7                	call   *%edi
}
  800205:	83 c4 10             	add    $0x10,%esp
  800208:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80020b:	5b                   	pop    %ebx
  80020c:	5e                   	pop    %esi
  80020d:	5f                   	pop    %edi
  80020e:	5d                   	pop    %ebp
  80020f:	c3                   	ret    

00800210 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800210:	f3 0f 1e fb          	endbr32 
  800214:	55                   	push   %ebp
  800215:	89 e5                	mov    %esp,%ebp
  800217:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80021a:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80021e:	8b 10                	mov    (%eax),%edx
  800220:	3b 50 04             	cmp    0x4(%eax),%edx
  800223:	73 0a                	jae    80022f <sprintputch+0x1f>
		*b->buf++ = ch;
  800225:	8d 4a 01             	lea    0x1(%edx),%ecx
  800228:	89 08                	mov    %ecx,(%eax)
  80022a:	8b 45 08             	mov    0x8(%ebp),%eax
  80022d:	88 02                	mov    %al,(%edx)
}
  80022f:	5d                   	pop    %ebp
  800230:	c3                   	ret    

00800231 <printfmt>:
{
  800231:	f3 0f 1e fb          	endbr32 
  800235:	55                   	push   %ebp
  800236:	89 e5                	mov    %esp,%ebp
  800238:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80023b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80023e:	50                   	push   %eax
  80023f:	ff 75 10             	pushl  0x10(%ebp)
  800242:	ff 75 0c             	pushl  0xc(%ebp)
  800245:	ff 75 08             	pushl  0x8(%ebp)
  800248:	e8 05 00 00 00       	call   800252 <vprintfmt>
}
  80024d:	83 c4 10             	add    $0x10,%esp
  800250:	c9                   	leave  
  800251:	c3                   	ret    

00800252 <vprintfmt>:
{
  800252:	f3 0f 1e fb          	endbr32 
  800256:	55                   	push   %ebp
  800257:	89 e5                	mov    %esp,%ebp
  800259:	57                   	push   %edi
  80025a:	56                   	push   %esi
  80025b:	53                   	push   %ebx
  80025c:	83 ec 3c             	sub    $0x3c,%esp
  80025f:	8b 75 08             	mov    0x8(%ebp),%esi
  800262:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800265:	8b 7d 10             	mov    0x10(%ebp),%edi
  800268:	e9 8e 03 00 00       	jmp    8005fb <vprintfmt+0x3a9>
		padc = ' ';
  80026d:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800271:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800278:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80027f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800286:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80028b:	8d 47 01             	lea    0x1(%edi),%eax
  80028e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800291:	0f b6 17             	movzbl (%edi),%edx
  800294:	8d 42 dd             	lea    -0x23(%edx),%eax
  800297:	3c 55                	cmp    $0x55,%al
  800299:	0f 87 df 03 00 00    	ja     80067e <vprintfmt+0x42c>
  80029f:	0f b6 c0             	movzbl %al,%eax
  8002a2:	3e ff 24 85 20 11 80 	notrack jmp *0x801120(,%eax,4)
  8002a9:	00 
  8002aa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002ad:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8002b1:	eb d8                	jmp    80028b <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8002b3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8002b6:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8002ba:	eb cf                	jmp    80028b <vprintfmt+0x39>
  8002bc:	0f b6 d2             	movzbl %dl,%edx
  8002bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002ca:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002cd:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002d1:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002d4:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002d7:	83 f9 09             	cmp    $0x9,%ecx
  8002da:	77 55                	ja     800331 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8002dc:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002df:	eb e9                	jmp    8002ca <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8002e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8002e4:	8b 00                	mov    (%eax),%eax
  8002e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8002ec:	8d 40 04             	lea    0x4(%eax),%eax
  8002ef:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8002f5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8002f9:	79 90                	jns    80028b <vprintfmt+0x39>
				width = precision, precision = -1;
  8002fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800301:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800308:	eb 81                	jmp    80028b <vprintfmt+0x39>
  80030a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80030d:	85 c0                	test   %eax,%eax
  80030f:	ba 00 00 00 00       	mov    $0x0,%edx
  800314:	0f 49 d0             	cmovns %eax,%edx
  800317:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80031a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80031d:	e9 69 ff ff ff       	jmp    80028b <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800322:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800325:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80032c:	e9 5a ff ff ff       	jmp    80028b <vprintfmt+0x39>
  800331:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800334:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800337:	eb bc                	jmp    8002f5 <vprintfmt+0xa3>
			lflag++;
  800339:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80033c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80033f:	e9 47 ff ff ff       	jmp    80028b <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800344:	8b 45 14             	mov    0x14(%ebp),%eax
  800347:	8d 78 04             	lea    0x4(%eax),%edi
  80034a:	83 ec 08             	sub    $0x8,%esp
  80034d:	53                   	push   %ebx
  80034e:	ff 30                	pushl  (%eax)
  800350:	ff d6                	call   *%esi
			break;
  800352:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800355:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800358:	e9 9b 02 00 00       	jmp    8005f8 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80035d:	8b 45 14             	mov    0x14(%ebp),%eax
  800360:	8d 78 04             	lea    0x4(%eax),%edi
  800363:	8b 00                	mov    (%eax),%eax
  800365:	99                   	cltd   
  800366:	31 d0                	xor    %edx,%eax
  800368:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80036a:	83 f8 08             	cmp    $0x8,%eax
  80036d:	7f 23                	jg     800392 <vprintfmt+0x140>
  80036f:	8b 14 85 80 12 80 00 	mov    0x801280(,%eax,4),%edx
  800376:	85 d2                	test   %edx,%edx
  800378:	74 18                	je     800392 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80037a:	52                   	push   %edx
  80037b:	68 72 10 80 00       	push   $0x801072
  800380:	53                   	push   %ebx
  800381:	56                   	push   %esi
  800382:	e8 aa fe ff ff       	call   800231 <printfmt>
  800387:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80038a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80038d:	e9 66 02 00 00       	jmp    8005f8 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800392:	50                   	push   %eax
  800393:	68 69 10 80 00       	push   $0x801069
  800398:	53                   	push   %ebx
  800399:	56                   	push   %esi
  80039a:	e8 92 fe ff ff       	call   800231 <printfmt>
  80039f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003a2:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003a5:	e9 4e 02 00 00       	jmp    8005f8 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8003aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ad:	83 c0 04             	add    $0x4,%eax
  8003b0:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8003b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b6:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8003b8:	85 d2                	test   %edx,%edx
  8003ba:	b8 62 10 80 00       	mov    $0x801062,%eax
  8003bf:	0f 45 c2             	cmovne %edx,%eax
  8003c2:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8003c5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003c9:	7e 06                	jle    8003d1 <vprintfmt+0x17f>
  8003cb:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8003cf:	75 0d                	jne    8003de <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003d1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003d4:	89 c7                	mov    %eax,%edi
  8003d6:	03 45 e0             	add    -0x20(%ebp),%eax
  8003d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003dc:	eb 55                	jmp    800433 <vprintfmt+0x1e1>
  8003de:	83 ec 08             	sub    $0x8,%esp
  8003e1:	ff 75 d8             	pushl  -0x28(%ebp)
  8003e4:	ff 75 cc             	pushl  -0x34(%ebp)
  8003e7:	e8 46 03 00 00       	call   800732 <strnlen>
  8003ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003ef:	29 c2                	sub    %eax,%edx
  8003f1:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8003f4:	83 c4 10             	add    $0x10,%esp
  8003f7:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8003f9:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8003fd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800400:	85 ff                	test   %edi,%edi
  800402:	7e 11                	jle    800415 <vprintfmt+0x1c3>
					putch(padc, putdat);
  800404:	83 ec 08             	sub    $0x8,%esp
  800407:	53                   	push   %ebx
  800408:	ff 75 e0             	pushl  -0x20(%ebp)
  80040b:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80040d:	83 ef 01             	sub    $0x1,%edi
  800410:	83 c4 10             	add    $0x10,%esp
  800413:	eb eb                	jmp    800400 <vprintfmt+0x1ae>
  800415:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800418:	85 d2                	test   %edx,%edx
  80041a:	b8 00 00 00 00       	mov    $0x0,%eax
  80041f:	0f 49 c2             	cmovns %edx,%eax
  800422:	29 c2                	sub    %eax,%edx
  800424:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800427:	eb a8                	jmp    8003d1 <vprintfmt+0x17f>
					putch(ch, putdat);
  800429:	83 ec 08             	sub    $0x8,%esp
  80042c:	53                   	push   %ebx
  80042d:	52                   	push   %edx
  80042e:	ff d6                	call   *%esi
  800430:	83 c4 10             	add    $0x10,%esp
  800433:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800436:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800438:	83 c7 01             	add    $0x1,%edi
  80043b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80043f:	0f be d0             	movsbl %al,%edx
  800442:	85 d2                	test   %edx,%edx
  800444:	74 4b                	je     800491 <vprintfmt+0x23f>
  800446:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80044a:	78 06                	js     800452 <vprintfmt+0x200>
  80044c:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800450:	78 1e                	js     800470 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800452:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800456:	74 d1                	je     800429 <vprintfmt+0x1d7>
  800458:	0f be c0             	movsbl %al,%eax
  80045b:	83 e8 20             	sub    $0x20,%eax
  80045e:	83 f8 5e             	cmp    $0x5e,%eax
  800461:	76 c6                	jbe    800429 <vprintfmt+0x1d7>
					putch('?', putdat);
  800463:	83 ec 08             	sub    $0x8,%esp
  800466:	53                   	push   %ebx
  800467:	6a 3f                	push   $0x3f
  800469:	ff d6                	call   *%esi
  80046b:	83 c4 10             	add    $0x10,%esp
  80046e:	eb c3                	jmp    800433 <vprintfmt+0x1e1>
  800470:	89 cf                	mov    %ecx,%edi
  800472:	eb 0e                	jmp    800482 <vprintfmt+0x230>
				putch(' ', putdat);
  800474:	83 ec 08             	sub    $0x8,%esp
  800477:	53                   	push   %ebx
  800478:	6a 20                	push   $0x20
  80047a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80047c:	83 ef 01             	sub    $0x1,%edi
  80047f:	83 c4 10             	add    $0x10,%esp
  800482:	85 ff                	test   %edi,%edi
  800484:	7f ee                	jg     800474 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800486:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800489:	89 45 14             	mov    %eax,0x14(%ebp)
  80048c:	e9 67 01 00 00       	jmp    8005f8 <vprintfmt+0x3a6>
  800491:	89 cf                	mov    %ecx,%edi
  800493:	eb ed                	jmp    800482 <vprintfmt+0x230>
	if (lflag >= 2)
  800495:	83 f9 01             	cmp    $0x1,%ecx
  800498:	7f 1b                	jg     8004b5 <vprintfmt+0x263>
	else if (lflag)
  80049a:	85 c9                	test   %ecx,%ecx
  80049c:	74 63                	je     800501 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80049e:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a1:	8b 00                	mov    (%eax),%eax
  8004a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004a6:	99                   	cltd   
  8004a7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ad:	8d 40 04             	lea    0x4(%eax),%eax
  8004b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8004b3:	eb 17                	jmp    8004cc <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  8004b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b8:	8b 50 04             	mov    0x4(%eax),%edx
  8004bb:	8b 00                	mov    (%eax),%eax
  8004bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c6:	8d 40 08             	lea    0x8(%eax),%eax
  8004c9:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004cc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004cf:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8004d2:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8004d7:	85 c9                	test   %ecx,%ecx
  8004d9:	0f 89 ff 00 00 00    	jns    8005de <vprintfmt+0x38c>
				putch('-', putdat);
  8004df:	83 ec 08             	sub    $0x8,%esp
  8004e2:	53                   	push   %ebx
  8004e3:	6a 2d                	push   $0x2d
  8004e5:	ff d6                	call   *%esi
				num = -(long long) num;
  8004e7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004ea:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004ed:	f7 da                	neg    %edx
  8004ef:	83 d1 00             	adc    $0x0,%ecx
  8004f2:	f7 d9                	neg    %ecx
  8004f4:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8004f7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8004fc:	e9 dd 00 00 00       	jmp    8005de <vprintfmt+0x38c>
		return va_arg(*ap, int);
  800501:	8b 45 14             	mov    0x14(%ebp),%eax
  800504:	8b 00                	mov    (%eax),%eax
  800506:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800509:	99                   	cltd   
  80050a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80050d:	8b 45 14             	mov    0x14(%ebp),%eax
  800510:	8d 40 04             	lea    0x4(%eax),%eax
  800513:	89 45 14             	mov    %eax,0x14(%ebp)
  800516:	eb b4                	jmp    8004cc <vprintfmt+0x27a>
	if (lflag >= 2)
  800518:	83 f9 01             	cmp    $0x1,%ecx
  80051b:	7f 1e                	jg     80053b <vprintfmt+0x2e9>
	else if (lflag)
  80051d:	85 c9                	test   %ecx,%ecx
  80051f:	74 32                	je     800553 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800521:	8b 45 14             	mov    0x14(%ebp),%eax
  800524:	8b 10                	mov    (%eax),%edx
  800526:	b9 00 00 00 00       	mov    $0x0,%ecx
  80052b:	8d 40 04             	lea    0x4(%eax),%eax
  80052e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800531:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800536:	e9 a3 00 00 00       	jmp    8005de <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80053b:	8b 45 14             	mov    0x14(%ebp),%eax
  80053e:	8b 10                	mov    (%eax),%edx
  800540:	8b 48 04             	mov    0x4(%eax),%ecx
  800543:	8d 40 08             	lea    0x8(%eax),%eax
  800546:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800549:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80054e:	e9 8b 00 00 00       	jmp    8005de <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800553:	8b 45 14             	mov    0x14(%ebp),%eax
  800556:	8b 10                	mov    (%eax),%edx
  800558:	b9 00 00 00 00       	mov    $0x0,%ecx
  80055d:	8d 40 04             	lea    0x4(%eax),%eax
  800560:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800563:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800568:	eb 74                	jmp    8005de <vprintfmt+0x38c>
	if (lflag >= 2)
  80056a:	83 f9 01             	cmp    $0x1,%ecx
  80056d:	7f 1b                	jg     80058a <vprintfmt+0x338>
	else if (lflag)
  80056f:	85 c9                	test   %ecx,%ecx
  800571:	74 2c                	je     80059f <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800573:	8b 45 14             	mov    0x14(%ebp),%eax
  800576:	8b 10                	mov    (%eax),%edx
  800578:	b9 00 00 00 00       	mov    $0x0,%ecx
  80057d:	8d 40 04             	lea    0x4(%eax),%eax
  800580:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800583:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800588:	eb 54                	jmp    8005de <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80058a:	8b 45 14             	mov    0x14(%ebp),%eax
  80058d:	8b 10                	mov    (%eax),%edx
  80058f:	8b 48 04             	mov    0x4(%eax),%ecx
  800592:	8d 40 08             	lea    0x8(%eax),%eax
  800595:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800598:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80059d:	eb 3f                	jmp    8005de <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80059f:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a2:	8b 10                	mov    (%eax),%edx
  8005a4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005a9:	8d 40 04             	lea    0x4(%eax),%eax
  8005ac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005af:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  8005b4:	eb 28                	jmp    8005de <vprintfmt+0x38c>
			putch('0', putdat);
  8005b6:	83 ec 08             	sub    $0x8,%esp
  8005b9:	53                   	push   %ebx
  8005ba:	6a 30                	push   $0x30
  8005bc:	ff d6                	call   *%esi
			putch('x', putdat);
  8005be:	83 c4 08             	add    $0x8,%esp
  8005c1:	53                   	push   %ebx
  8005c2:	6a 78                	push   $0x78
  8005c4:	ff d6                	call   *%esi
			num = (unsigned long long)
  8005c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c9:	8b 10                	mov    (%eax),%edx
  8005cb:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8005d0:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8005d3:	8d 40 04             	lea    0x4(%eax),%eax
  8005d6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8005d9:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8005de:	83 ec 0c             	sub    $0xc,%esp
  8005e1:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8005e5:	57                   	push   %edi
  8005e6:	ff 75 e0             	pushl  -0x20(%ebp)
  8005e9:	50                   	push   %eax
  8005ea:	51                   	push   %ecx
  8005eb:	52                   	push   %edx
  8005ec:	89 da                	mov    %ebx,%edx
  8005ee:	89 f0                	mov    %esi,%eax
  8005f0:	e8 72 fb ff ff       	call   800167 <printnum>
			break;
  8005f5:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8005f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005fb:	83 c7 01             	add    $0x1,%edi
  8005fe:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800602:	83 f8 25             	cmp    $0x25,%eax
  800605:	0f 84 62 fc ff ff    	je     80026d <vprintfmt+0x1b>
			if (ch == '\0')
  80060b:	85 c0                	test   %eax,%eax
  80060d:	0f 84 8b 00 00 00    	je     80069e <vprintfmt+0x44c>
			putch(ch, putdat);
  800613:	83 ec 08             	sub    $0x8,%esp
  800616:	53                   	push   %ebx
  800617:	50                   	push   %eax
  800618:	ff d6                	call   *%esi
  80061a:	83 c4 10             	add    $0x10,%esp
  80061d:	eb dc                	jmp    8005fb <vprintfmt+0x3a9>
	if (lflag >= 2)
  80061f:	83 f9 01             	cmp    $0x1,%ecx
  800622:	7f 1b                	jg     80063f <vprintfmt+0x3ed>
	else if (lflag)
  800624:	85 c9                	test   %ecx,%ecx
  800626:	74 2c                	je     800654 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800628:	8b 45 14             	mov    0x14(%ebp),%eax
  80062b:	8b 10                	mov    (%eax),%edx
  80062d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800632:	8d 40 04             	lea    0x4(%eax),%eax
  800635:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800638:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80063d:	eb 9f                	jmp    8005de <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80063f:	8b 45 14             	mov    0x14(%ebp),%eax
  800642:	8b 10                	mov    (%eax),%edx
  800644:	8b 48 04             	mov    0x4(%eax),%ecx
  800647:	8d 40 08             	lea    0x8(%eax),%eax
  80064a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80064d:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800652:	eb 8a                	jmp    8005de <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800654:	8b 45 14             	mov    0x14(%ebp),%eax
  800657:	8b 10                	mov    (%eax),%edx
  800659:	b9 00 00 00 00       	mov    $0x0,%ecx
  80065e:	8d 40 04             	lea    0x4(%eax),%eax
  800661:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800664:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800669:	e9 70 ff ff ff       	jmp    8005de <vprintfmt+0x38c>
			putch(ch, putdat);
  80066e:	83 ec 08             	sub    $0x8,%esp
  800671:	53                   	push   %ebx
  800672:	6a 25                	push   $0x25
  800674:	ff d6                	call   *%esi
			break;
  800676:	83 c4 10             	add    $0x10,%esp
  800679:	e9 7a ff ff ff       	jmp    8005f8 <vprintfmt+0x3a6>
			putch('%', putdat);
  80067e:	83 ec 08             	sub    $0x8,%esp
  800681:	53                   	push   %ebx
  800682:	6a 25                	push   $0x25
  800684:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800686:	83 c4 10             	add    $0x10,%esp
  800689:	89 f8                	mov    %edi,%eax
  80068b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80068f:	74 05                	je     800696 <vprintfmt+0x444>
  800691:	83 e8 01             	sub    $0x1,%eax
  800694:	eb f5                	jmp    80068b <vprintfmt+0x439>
  800696:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800699:	e9 5a ff ff ff       	jmp    8005f8 <vprintfmt+0x3a6>
}
  80069e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006a1:	5b                   	pop    %ebx
  8006a2:	5e                   	pop    %esi
  8006a3:	5f                   	pop    %edi
  8006a4:	5d                   	pop    %ebp
  8006a5:	c3                   	ret    

008006a6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006a6:	f3 0f 1e fb          	endbr32 
  8006aa:	55                   	push   %ebp
  8006ab:	89 e5                	mov    %esp,%ebp
  8006ad:	83 ec 18             	sub    $0x18,%esp
  8006b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b3:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006b9:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006bd:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006c7:	85 c0                	test   %eax,%eax
  8006c9:	74 26                	je     8006f1 <vsnprintf+0x4b>
  8006cb:	85 d2                	test   %edx,%edx
  8006cd:	7e 22                	jle    8006f1 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006cf:	ff 75 14             	pushl  0x14(%ebp)
  8006d2:	ff 75 10             	pushl  0x10(%ebp)
  8006d5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006d8:	50                   	push   %eax
  8006d9:	68 10 02 80 00       	push   $0x800210
  8006de:	e8 6f fb ff ff       	call   800252 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006e6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006ec:	83 c4 10             	add    $0x10,%esp
}
  8006ef:	c9                   	leave  
  8006f0:	c3                   	ret    
		return -E_INVAL;
  8006f1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006f6:	eb f7                	jmp    8006ef <vsnprintf+0x49>

008006f8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8006f8:	f3 0f 1e fb          	endbr32 
  8006fc:	55                   	push   %ebp
  8006fd:	89 e5                	mov    %esp,%ebp
  8006ff:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800702:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800705:	50                   	push   %eax
  800706:	ff 75 10             	pushl  0x10(%ebp)
  800709:	ff 75 0c             	pushl  0xc(%ebp)
  80070c:	ff 75 08             	pushl  0x8(%ebp)
  80070f:	e8 92 ff ff ff       	call   8006a6 <vsnprintf>
	va_end(ap);

	return rc;
}
  800714:	c9                   	leave  
  800715:	c3                   	ret    

00800716 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800716:	f3 0f 1e fb          	endbr32 
  80071a:	55                   	push   %ebp
  80071b:	89 e5                	mov    %esp,%ebp
  80071d:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800720:	b8 00 00 00 00       	mov    $0x0,%eax
  800725:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800729:	74 05                	je     800730 <strlen+0x1a>
		n++;
  80072b:	83 c0 01             	add    $0x1,%eax
  80072e:	eb f5                	jmp    800725 <strlen+0xf>
	return n;
}
  800730:	5d                   	pop    %ebp
  800731:	c3                   	ret    

00800732 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800732:	f3 0f 1e fb          	endbr32 
  800736:	55                   	push   %ebp
  800737:	89 e5                	mov    %esp,%ebp
  800739:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80073c:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80073f:	b8 00 00 00 00       	mov    $0x0,%eax
  800744:	39 d0                	cmp    %edx,%eax
  800746:	74 0d                	je     800755 <strnlen+0x23>
  800748:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80074c:	74 05                	je     800753 <strnlen+0x21>
		n++;
  80074e:	83 c0 01             	add    $0x1,%eax
  800751:	eb f1                	jmp    800744 <strnlen+0x12>
  800753:	89 c2                	mov    %eax,%edx
	return n;
}
  800755:	89 d0                	mov    %edx,%eax
  800757:	5d                   	pop    %ebp
  800758:	c3                   	ret    

00800759 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800759:	f3 0f 1e fb          	endbr32 
  80075d:	55                   	push   %ebp
  80075e:	89 e5                	mov    %esp,%ebp
  800760:	53                   	push   %ebx
  800761:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800764:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800767:	b8 00 00 00 00       	mov    $0x0,%eax
  80076c:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800770:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800773:	83 c0 01             	add    $0x1,%eax
  800776:	84 d2                	test   %dl,%dl
  800778:	75 f2                	jne    80076c <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  80077a:	89 c8                	mov    %ecx,%eax
  80077c:	5b                   	pop    %ebx
  80077d:	5d                   	pop    %ebp
  80077e:	c3                   	ret    

0080077f <strcat>:

char *
strcat(char *dst, const char *src)
{
  80077f:	f3 0f 1e fb          	endbr32 
  800783:	55                   	push   %ebp
  800784:	89 e5                	mov    %esp,%ebp
  800786:	53                   	push   %ebx
  800787:	83 ec 10             	sub    $0x10,%esp
  80078a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80078d:	53                   	push   %ebx
  80078e:	e8 83 ff ff ff       	call   800716 <strlen>
  800793:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800796:	ff 75 0c             	pushl  0xc(%ebp)
  800799:	01 d8                	add    %ebx,%eax
  80079b:	50                   	push   %eax
  80079c:	e8 b8 ff ff ff       	call   800759 <strcpy>
	return dst;
}
  8007a1:	89 d8                	mov    %ebx,%eax
  8007a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007a6:	c9                   	leave  
  8007a7:	c3                   	ret    

008007a8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007a8:	f3 0f 1e fb          	endbr32 
  8007ac:	55                   	push   %ebp
  8007ad:	89 e5                	mov    %esp,%ebp
  8007af:	56                   	push   %esi
  8007b0:	53                   	push   %ebx
  8007b1:	8b 75 08             	mov    0x8(%ebp),%esi
  8007b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007b7:	89 f3                	mov    %esi,%ebx
  8007b9:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007bc:	89 f0                	mov    %esi,%eax
  8007be:	39 d8                	cmp    %ebx,%eax
  8007c0:	74 11                	je     8007d3 <strncpy+0x2b>
		*dst++ = *src;
  8007c2:	83 c0 01             	add    $0x1,%eax
  8007c5:	0f b6 0a             	movzbl (%edx),%ecx
  8007c8:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007cb:	80 f9 01             	cmp    $0x1,%cl
  8007ce:	83 da ff             	sbb    $0xffffffff,%edx
  8007d1:	eb eb                	jmp    8007be <strncpy+0x16>
	}
	return ret;
}
  8007d3:	89 f0                	mov    %esi,%eax
  8007d5:	5b                   	pop    %ebx
  8007d6:	5e                   	pop    %esi
  8007d7:	5d                   	pop    %ebp
  8007d8:	c3                   	ret    

008007d9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007d9:	f3 0f 1e fb          	endbr32 
  8007dd:	55                   	push   %ebp
  8007de:	89 e5                	mov    %esp,%ebp
  8007e0:	56                   	push   %esi
  8007e1:	53                   	push   %ebx
  8007e2:	8b 75 08             	mov    0x8(%ebp),%esi
  8007e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007e8:	8b 55 10             	mov    0x10(%ebp),%edx
  8007eb:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007ed:	85 d2                	test   %edx,%edx
  8007ef:	74 21                	je     800812 <strlcpy+0x39>
  8007f1:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8007f5:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8007f7:	39 c2                	cmp    %eax,%edx
  8007f9:	74 14                	je     80080f <strlcpy+0x36>
  8007fb:	0f b6 19             	movzbl (%ecx),%ebx
  8007fe:	84 db                	test   %bl,%bl
  800800:	74 0b                	je     80080d <strlcpy+0x34>
			*dst++ = *src++;
  800802:	83 c1 01             	add    $0x1,%ecx
  800805:	83 c2 01             	add    $0x1,%edx
  800808:	88 5a ff             	mov    %bl,-0x1(%edx)
  80080b:	eb ea                	jmp    8007f7 <strlcpy+0x1e>
  80080d:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80080f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800812:	29 f0                	sub    %esi,%eax
}
  800814:	5b                   	pop    %ebx
  800815:	5e                   	pop    %esi
  800816:	5d                   	pop    %ebp
  800817:	c3                   	ret    

00800818 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800818:	f3 0f 1e fb          	endbr32 
  80081c:	55                   	push   %ebp
  80081d:	89 e5                	mov    %esp,%ebp
  80081f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800822:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800825:	0f b6 01             	movzbl (%ecx),%eax
  800828:	84 c0                	test   %al,%al
  80082a:	74 0c                	je     800838 <strcmp+0x20>
  80082c:	3a 02                	cmp    (%edx),%al
  80082e:	75 08                	jne    800838 <strcmp+0x20>
		p++, q++;
  800830:	83 c1 01             	add    $0x1,%ecx
  800833:	83 c2 01             	add    $0x1,%edx
  800836:	eb ed                	jmp    800825 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800838:	0f b6 c0             	movzbl %al,%eax
  80083b:	0f b6 12             	movzbl (%edx),%edx
  80083e:	29 d0                	sub    %edx,%eax
}
  800840:	5d                   	pop    %ebp
  800841:	c3                   	ret    

00800842 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800842:	f3 0f 1e fb          	endbr32 
  800846:	55                   	push   %ebp
  800847:	89 e5                	mov    %esp,%ebp
  800849:	53                   	push   %ebx
  80084a:	8b 45 08             	mov    0x8(%ebp),%eax
  80084d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800850:	89 c3                	mov    %eax,%ebx
  800852:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800855:	eb 06                	jmp    80085d <strncmp+0x1b>
		n--, p++, q++;
  800857:	83 c0 01             	add    $0x1,%eax
  80085a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80085d:	39 d8                	cmp    %ebx,%eax
  80085f:	74 16                	je     800877 <strncmp+0x35>
  800861:	0f b6 08             	movzbl (%eax),%ecx
  800864:	84 c9                	test   %cl,%cl
  800866:	74 04                	je     80086c <strncmp+0x2a>
  800868:	3a 0a                	cmp    (%edx),%cl
  80086a:	74 eb                	je     800857 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80086c:	0f b6 00             	movzbl (%eax),%eax
  80086f:	0f b6 12             	movzbl (%edx),%edx
  800872:	29 d0                	sub    %edx,%eax
}
  800874:	5b                   	pop    %ebx
  800875:	5d                   	pop    %ebp
  800876:	c3                   	ret    
		return 0;
  800877:	b8 00 00 00 00       	mov    $0x0,%eax
  80087c:	eb f6                	jmp    800874 <strncmp+0x32>

0080087e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80087e:	f3 0f 1e fb          	endbr32 
  800882:	55                   	push   %ebp
  800883:	89 e5                	mov    %esp,%ebp
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80088c:	0f b6 10             	movzbl (%eax),%edx
  80088f:	84 d2                	test   %dl,%dl
  800891:	74 09                	je     80089c <strchr+0x1e>
		if (*s == c)
  800893:	38 ca                	cmp    %cl,%dl
  800895:	74 0a                	je     8008a1 <strchr+0x23>
	for (; *s; s++)
  800897:	83 c0 01             	add    $0x1,%eax
  80089a:	eb f0                	jmp    80088c <strchr+0xe>
			return (char *) s;
	return 0;
  80089c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008a1:	5d                   	pop    %ebp
  8008a2:	c3                   	ret    

008008a3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008a3:	f3 0f 1e fb          	endbr32 
  8008a7:	55                   	push   %ebp
  8008a8:	89 e5                	mov    %esp,%ebp
  8008aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ad:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008b1:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008b4:	38 ca                	cmp    %cl,%dl
  8008b6:	74 09                	je     8008c1 <strfind+0x1e>
  8008b8:	84 d2                	test   %dl,%dl
  8008ba:	74 05                	je     8008c1 <strfind+0x1e>
	for (; *s; s++)
  8008bc:	83 c0 01             	add    $0x1,%eax
  8008bf:	eb f0                	jmp    8008b1 <strfind+0xe>
			break;
	return (char *) s;
}
  8008c1:	5d                   	pop    %ebp
  8008c2:	c3                   	ret    

008008c3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008c3:	f3 0f 1e fb          	endbr32 
  8008c7:	55                   	push   %ebp
  8008c8:	89 e5                	mov    %esp,%ebp
  8008ca:	57                   	push   %edi
  8008cb:	56                   	push   %esi
  8008cc:	53                   	push   %ebx
  8008cd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008d3:	85 c9                	test   %ecx,%ecx
  8008d5:	74 31                	je     800908 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008d7:	89 f8                	mov    %edi,%eax
  8008d9:	09 c8                	or     %ecx,%eax
  8008db:	a8 03                	test   $0x3,%al
  8008dd:	75 23                	jne    800902 <memset+0x3f>
		c &= 0xFF;
  8008df:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008e3:	89 d3                	mov    %edx,%ebx
  8008e5:	c1 e3 08             	shl    $0x8,%ebx
  8008e8:	89 d0                	mov    %edx,%eax
  8008ea:	c1 e0 18             	shl    $0x18,%eax
  8008ed:	89 d6                	mov    %edx,%esi
  8008ef:	c1 e6 10             	shl    $0x10,%esi
  8008f2:	09 f0                	or     %esi,%eax
  8008f4:	09 c2                	or     %eax,%edx
  8008f6:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8008f8:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8008fb:	89 d0                	mov    %edx,%eax
  8008fd:	fc                   	cld    
  8008fe:	f3 ab                	rep stos %eax,%es:(%edi)
  800900:	eb 06                	jmp    800908 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800902:	8b 45 0c             	mov    0xc(%ebp),%eax
  800905:	fc                   	cld    
  800906:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800908:	89 f8                	mov    %edi,%eax
  80090a:	5b                   	pop    %ebx
  80090b:	5e                   	pop    %esi
  80090c:	5f                   	pop    %edi
  80090d:	5d                   	pop    %ebp
  80090e:	c3                   	ret    

0080090f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80090f:	f3 0f 1e fb          	endbr32 
  800913:	55                   	push   %ebp
  800914:	89 e5                	mov    %esp,%ebp
  800916:	57                   	push   %edi
  800917:	56                   	push   %esi
  800918:	8b 45 08             	mov    0x8(%ebp),%eax
  80091b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80091e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800921:	39 c6                	cmp    %eax,%esi
  800923:	73 32                	jae    800957 <memmove+0x48>
  800925:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800928:	39 c2                	cmp    %eax,%edx
  80092a:	76 2b                	jbe    800957 <memmove+0x48>
		s += n;
		d += n;
  80092c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80092f:	89 fe                	mov    %edi,%esi
  800931:	09 ce                	or     %ecx,%esi
  800933:	09 d6                	or     %edx,%esi
  800935:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80093b:	75 0e                	jne    80094b <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80093d:	83 ef 04             	sub    $0x4,%edi
  800940:	8d 72 fc             	lea    -0x4(%edx),%esi
  800943:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800946:	fd                   	std    
  800947:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800949:	eb 09                	jmp    800954 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80094b:	83 ef 01             	sub    $0x1,%edi
  80094e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800951:	fd                   	std    
  800952:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800954:	fc                   	cld    
  800955:	eb 1a                	jmp    800971 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800957:	89 c2                	mov    %eax,%edx
  800959:	09 ca                	or     %ecx,%edx
  80095b:	09 f2                	or     %esi,%edx
  80095d:	f6 c2 03             	test   $0x3,%dl
  800960:	75 0a                	jne    80096c <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800962:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800965:	89 c7                	mov    %eax,%edi
  800967:	fc                   	cld    
  800968:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80096a:	eb 05                	jmp    800971 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  80096c:	89 c7                	mov    %eax,%edi
  80096e:	fc                   	cld    
  80096f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800971:	5e                   	pop    %esi
  800972:	5f                   	pop    %edi
  800973:	5d                   	pop    %ebp
  800974:	c3                   	ret    

00800975 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800975:	f3 0f 1e fb          	endbr32 
  800979:	55                   	push   %ebp
  80097a:	89 e5                	mov    %esp,%ebp
  80097c:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  80097f:	ff 75 10             	pushl  0x10(%ebp)
  800982:	ff 75 0c             	pushl  0xc(%ebp)
  800985:	ff 75 08             	pushl  0x8(%ebp)
  800988:	e8 82 ff ff ff       	call   80090f <memmove>
}
  80098d:	c9                   	leave  
  80098e:	c3                   	ret    

0080098f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80098f:	f3 0f 1e fb          	endbr32 
  800993:	55                   	push   %ebp
  800994:	89 e5                	mov    %esp,%ebp
  800996:	56                   	push   %esi
  800997:	53                   	push   %ebx
  800998:	8b 45 08             	mov    0x8(%ebp),%eax
  80099b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80099e:	89 c6                	mov    %eax,%esi
  8009a0:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009a3:	39 f0                	cmp    %esi,%eax
  8009a5:	74 1c                	je     8009c3 <memcmp+0x34>
		if (*s1 != *s2)
  8009a7:	0f b6 08             	movzbl (%eax),%ecx
  8009aa:	0f b6 1a             	movzbl (%edx),%ebx
  8009ad:	38 d9                	cmp    %bl,%cl
  8009af:	75 08                	jne    8009b9 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009b1:	83 c0 01             	add    $0x1,%eax
  8009b4:	83 c2 01             	add    $0x1,%edx
  8009b7:	eb ea                	jmp    8009a3 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  8009b9:	0f b6 c1             	movzbl %cl,%eax
  8009bc:	0f b6 db             	movzbl %bl,%ebx
  8009bf:	29 d8                	sub    %ebx,%eax
  8009c1:	eb 05                	jmp    8009c8 <memcmp+0x39>
	}

	return 0;
  8009c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009c8:	5b                   	pop    %ebx
  8009c9:	5e                   	pop    %esi
  8009ca:	5d                   	pop    %ebp
  8009cb:	c3                   	ret    

008009cc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009cc:	f3 0f 1e fb          	endbr32 
  8009d0:	55                   	push   %ebp
  8009d1:	89 e5                	mov    %esp,%ebp
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009d9:	89 c2                	mov    %eax,%edx
  8009db:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009de:	39 d0                	cmp    %edx,%eax
  8009e0:	73 09                	jae    8009eb <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009e2:	38 08                	cmp    %cl,(%eax)
  8009e4:	74 05                	je     8009eb <memfind+0x1f>
	for (; s < ends; s++)
  8009e6:	83 c0 01             	add    $0x1,%eax
  8009e9:	eb f3                	jmp    8009de <memfind+0x12>
			break;
	return (void *) s;
}
  8009eb:	5d                   	pop    %ebp
  8009ec:	c3                   	ret    

008009ed <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009ed:	f3 0f 1e fb          	endbr32 
  8009f1:	55                   	push   %ebp
  8009f2:	89 e5                	mov    %esp,%ebp
  8009f4:	57                   	push   %edi
  8009f5:	56                   	push   %esi
  8009f6:	53                   	push   %ebx
  8009f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009fa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009fd:	eb 03                	jmp    800a02 <strtol+0x15>
		s++;
  8009ff:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a02:	0f b6 01             	movzbl (%ecx),%eax
  800a05:	3c 20                	cmp    $0x20,%al
  800a07:	74 f6                	je     8009ff <strtol+0x12>
  800a09:	3c 09                	cmp    $0x9,%al
  800a0b:	74 f2                	je     8009ff <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a0d:	3c 2b                	cmp    $0x2b,%al
  800a0f:	74 2a                	je     800a3b <strtol+0x4e>
	int neg = 0;
  800a11:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a16:	3c 2d                	cmp    $0x2d,%al
  800a18:	74 2b                	je     800a45 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a1a:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a20:	75 0f                	jne    800a31 <strtol+0x44>
  800a22:	80 39 30             	cmpb   $0x30,(%ecx)
  800a25:	74 28                	je     800a4f <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a27:	85 db                	test   %ebx,%ebx
  800a29:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a2e:	0f 44 d8             	cmove  %eax,%ebx
  800a31:	b8 00 00 00 00       	mov    $0x0,%eax
  800a36:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a39:	eb 46                	jmp    800a81 <strtol+0x94>
		s++;
  800a3b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a3e:	bf 00 00 00 00       	mov    $0x0,%edi
  800a43:	eb d5                	jmp    800a1a <strtol+0x2d>
		s++, neg = 1;
  800a45:	83 c1 01             	add    $0x1,%ecx
  800a48:	bf 01 00 00 00       	mov    $0x1,%edi
  800a4d:	eb cb                	jmp    800a1a <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a4f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a53:	74 0e                	je     800a63 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a55:	85 db                	test   %ebx,%ebx
  800a57:	75 d8                	jne    800a31 <strtol+0x44>
		s++, base = 8;
  800a59:	83 c1 01             	add    $0x1,%ecx
  800a5c:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a61:	eb ce                	jmp    800a31 <strtol+0x44>
		s += 2, base = 16;
  800a63:	83 c1 02             	add    $0x2,%ecx
  800a66:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a6b:	eb c4                	jmp    800a31 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800a6d:	0f be d2             	movsbl %dl,%edx
  800a70:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a73:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a76:	7d 3a                	jge    800ab2 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a78:	83 c1 01             	add    $0x1,%ecx
  800a7b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a7f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a81:	0f b6 11             	movzbl (%ecx),%edx
  800a84:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a87:	89 f3                	mov    %esi,%ebx
  800a89:	80 fb 09             	cmp    $0x9,%bl
  800a8c:	76 df                	jbe    800a6d <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800a8e:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a91:	89 f3                	mov    %esi,%ebx
  800a93:	80 fb 19             	cmp    $0x19,%bl
  800a96:	77 08                	ja     800aa0 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800a98:	0f be d2             	movsbl %dl,%edx
  800a9b:	83 ea 57             	sub    $0x57,%edx
  800a9e:	eb d3                	jmp    800a73 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800aa0:	8d 72 bf             	lea    -0x41(%edx),%esi
  800aa3:	89 f3                	mov    %esi,%ebx
  800aa5:	80 fb 19             	cmp    $0x19,%bl
  800aa8:	77 08                	ja     800ab2 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800aaa:	0f be d2             	movsbl %dl,%edx
  800aad:	83 ea 37             	sub    $0x37,%edx
  800ab0:	eb c1                	jmp    800a73 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ab2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ab6:	74 05                	je     800abd <strtol+0xd0>
		*endptr = (char *) s;
  800ab8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800abb:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800abd:	89 c2                	mov    %eax,%edx
  800abf:	f7 da                	neg    %edx
  800ac1:	85 ff                	test   %edi,%edi
  800ac3:	0f 45 c2             	cmovne %edx,%eax
}
  800ac6:	5b                   	pop    %ebx
  800ac7:	5e                   	pop    %esi
  800ac8:	5f                   	pop    %edi
  800ac9:	5d                   	pop    %ebp
  800aca:	c3                   	ret    

00800acb <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800acb:	f3 0f 1e fb          	endbr32 
  800acf:	55                   	push   %ebp
  800ad0:	89 e5                	mov    %esp,%ebp
  800ad2:	57                   	push   %edi
  800ad3:	56                   	push   %esi
  800ad4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ad5:	b8 00 00 00 00       	mov    $0x0,%eax
  800ada:	8b 55 08             	mov    0x8(%ebp),%edx
  800add:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ae0:	89 c3                	mov    %eax,%ebx
  800ae2:	89 c7                	mov    %eax,%edi
  800ae4:	89 c6                	mov    %eax,%esi
  800ae6:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ae8:	5b                   	pop    %ebx
  800ae9:	5e                   	pop    %esi
  800aea:	5f                   	pop    %edi
  800aeb:	5d                   	pop    %ebp
  800aec:	c3                   	ret    

00800aed <sys_cgetc>:

int
sys_cgetc(void)
{
  800aed:	f3 0f 1e fb          	endbr32 
  800af1:	55                   	push   %ebp
  800af2:	89 e5                	mov    %esp,%ebp
  800af4:	57                   	push   %edi
  800af5:	56                   	push   %esi
  800af6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800af7:	ba 00 00 00 00       	mov    $0x0,%edx
  800afc:	b8 01 00 00 00       	mov    $0x1,%eax
  800b01:	89 d1                	mov    %edx,%ecx
  800b03:	89 d3                	mov    %edx,%ebx
  800b05:	89 d7                	mov    %edx,%edi
  800b07:	89 d6                	mov    %edx,%esi
  800b09:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b0b:	5b                   	pop    %ebx
  800b0c:	5e                   	pop    %esi
  800b0d:	5f                   	pop    %edi
  800b0e:	5d                   	pop    %ebp
  800b0f:	c3                   	ret    

00800b10 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b10:	f3 0f 1e fb          	endbr32 
  800b14:	55                   	push   %ebp
  800b15:	89 e5                	mov    %esp,%ebp
  800b17:	57                   	push   %edi
  800b18:	56                   	push   %esi
  800b19:	53                   	push   %ebx
  800b1a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b1d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b22:	8b 55 08             	mov    0x8(%ebp),%edx
  800b25:	b8 03 00 00 00       	mov    $0x3,%eax
  800b2a:	89 cb                	mov    %ecx,%ebx
  800b2c:	89 cf                	mov    %ecx,%edi
  800b2e:	89 ce                	mov    %ecx,%esi
  800b30:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b32:	85 c0                	test   %eax,%eax
  800b34:	7f 08                	jg     800b3e <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b36:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b39:	5b                   	pop    %ebx
  800b3a:	5e                   	pop    %esi
  800b3b:	5f                   	pop    %edi
  800b3c:	5d                   	pop    %ebp
  800b3d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b3e:	83 ec 0c             	sub    $0xc,%esp
  800b41:	50                   	push   %eax
  800b42:	6a 03                	push   $0x3
  800b44:	68 a4 12 80 00       	push   $0x8012a4
  800b49:	6a 23                	push   $0x23
  800b4b:	68 c1 12 80 00       	push   $0x8012c1
  800b50:	e8 11 02 00 00       	call   800d66 <_panic>

00800b55 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b55:	f3 0f 1e fb          	endbr32 
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
  800b5c:	57                   	push   %edi
  800b5d:	56                   	push   %esi
  800b5e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b5f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b64:	b8 02 00 00 00       	mov    $0x2,%eax
  800b69:	89 d1                	mov    %edx,%ecx
  800b6b:	89 d3                	mov    %edx,%ebx
  800b6d:	89 d7                	mov    %edx,%edi
  800b6f:	89 d6                	mov    %edx,%esi
  800b71:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b73:	5b                   	pop    %ebx
  800b74:	5e                   	pop    %esi
  800b75:	5f                   	pop    %edi
  800b76:	5d                   	pop    %ebp
  800b77:	c3                   	ret    

00800b78 <sys_yield>:

void
sys_yield(void)
{
  800b78:	f3 0f 1e fb          	endbr32 
  800b7c:	55                   	push   %ebp
  800b7d:	89 e5                	mov    %esp,%ebp
  800b7f:	57                   	push   %edi
  800b80:	56                   	push   %esi
  800b81:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b82:	ba 00 00 00 00       	mov    $0x0,%edx
  800b87:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b8c:	89 d1                	mov    %edx,%ecx
  800b8e:	89 d3                	mov    %edx,%ebx
  800b90:	89 d7                	mov    %edx,%edi
  800b92:	89 d6                	mov    %edx,%esi
  800b94:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b96:	5b                   	pop    %ebx
  800b97:	5e                   	pop    %esi
  800b98:	5f                   	pop    %edi
  800b99:	5d                   	pop    %ebp
  800b9a:	c3                   	ret    

00800b9b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b9b:	f3 0f 1e fb          	endbr32 
  800b9f:	55                   	push   %ebp
  800ba0:	89 e5                	mov    %esp,%ebp
  800ba2:	57                   	push   %edi
  800ba3:	56                   	push   %esi
  800ba4:	53                   	push   %ebx
  800ba5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ba8:	be 00 00 00 00       	mov    $0x0,%esi
  800bad:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bb3:	b8 04 00 00 00       	mov    $0x4,%eax
  800bb8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bbb:	89 f7                	mov    %esi,%edi
  800bbd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bbf:	85 c0                	test   %eax,%eax
  800bc1:	7f 08                	jg     800bcb <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bc6:	5b                   	pop    %ebx
  800bc7:	5e                   	pop    %esi
  800bc8:	5f                   	pop    %edi
  800bc9:	5d                   	pop    %ebp
  800bca:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bcb:	83 ec 0c             	sub    $0xc,%esp
  800bce:	50                   	push   %eax
  800bcf:	6a 04                	push   $0x4
  800bd1:	68 a4 12 80 00       	push   $0x8012a4
  800bd6:	6a 23                	push   $0x23
  800bd8:	68 c1 12 80 00       	push   $0x8012c1
  800bdd:	e8 84 01 00 00       	call   800d66 <_panic>

00800be2 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800be2:	f3 0f 1e fb          	endbr32 
  800be6:	55                   	push   %ebp
  800be7:	89 e5                	mov    %esp,%ebp
  800be9:	57                   	push   %edi
  800bea:	56                   	push   %esi
  800beb:	53                   	push   %ebx
  800bec:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bef:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf5:	b8 05 00 00 00       	mov    $0x5,%eax
  800bfa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bfd:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c00:	8b 75 18             	mov    0x18(%ebp),%esi
  800c03:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c05:	85 c0                	test   %eax,%eax
  800c07:	7f 08                	jg     800c11 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c09:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c0c:	5b                   	pop    %ebx
  800c0d:	5e                   	pop    %esi
  800c0e:	5f                   	pop    %edi
  800c0f:	5d                   	pop    %ebp
  800c10:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c11:	83 ec 0c             	sub    $0xc,%esp
  800c14:	50                   	push   %eax
  800c15:	6a 05                	push   $0x5
  800c17:	68 a4 12 80 00       	push   $0x8012a4
  800c1c:	6a 23                	push   $0x23
  800c1e:	68 c1 12 80 00       	push   $0x8012c1
  800c23:	e8 3e 01 00 00       	call   800d66 <_panic>

00800c28 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c28:	f3 0f 1e fb          	endbr32 
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
  800c2f:	57                   	push   %edi
  800c30:	56                   	push   %esi
  800c31:	53                   	push   %ebx
  800c32:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c35:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c40:	b8 06 00 00 00       	mov    $0x6,%eax
  800c45:	89 df                	mov    %ebx,%edi
  800c47:	89 de                	mov    %ebx,%esi
  800c49:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c4b:	85 c0                	test   %eax,%eax
  800c4d:	7f 08                	jg     800c57 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c52:	5b                   	pop    %ebx
  800c53:	5e                   	pop    %esi
  800c54:	5f                   	pop    %edi
  800c55:	5d                   	pop    %ebp
  800c56:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c57:	83 ec 0c             	sub    $0xc,%esp
  800c5a:	50                   	push   %eax
  800c5b:	6a 06                	push   $0x6
  800c5d:	68 a4 12 80 00       	push   $0x8012a4
  800c62:	6a 23                	push   $0x23
  800c64:	68 c1 12 80 00       	push   $0x8012c1
  800c69:	e8 f8 00 00 00       	call   800d66 <_panic>

00800c6e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c6e:	f3 0f 1e fb          	endbr32 
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
  800c75:	57                   	push   %edi
  800c76:	56                   	push   %esi
  800c77:	53                   	push   %ebx
  800c78:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c7b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c80:	8b 55 08             	mov    0x8(%ebp),%edx
  800c83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c86:	b8 08 00 00 00       	mov    $0x8,%eax
  800c8b:	89 df                	mov    %ebx,%edi
  800c8d:	89 de                	mov    %ebx,%esi
  800c8f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c91:	85 c0                	test   %eax,%eax
  800c93:	7f 08                	jg     800c9d <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c95:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c98:	5b                   	pop    %ebx
  800c99:	5e                   	pop    %esi
  800c9a:	5f                   	pop    %edi
  800c9b:	5d                   	pop    %ebp
  800c9c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c9d:	83 ec 0c             	sub    $0xc,%esp
  800ca0:	50                   	push   %eax
  800ca1:	6a 08                	push   $0x8
  800ca3:	68 a4 12 80 00       	push   $0x8012a4
  800ca8:	6a 23                	push   $0x23
  800caa:	68 c1 12 80 00       	push   $0x8012c1
  800caf:	e8 b2 00 00 00       	call   800d66 <_panic>

00800cb4 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cb4:	f3 0f 1e fb          	endbr32 
  800cb8:	55                   	push   %ebp
  800cb9:	89 e5                	mov    %esp,%ebp
  800cbb:	57                   	push   %edi
  800cbc:	56                   	push   %esi
  800cbd:	53                   	push   %ebx
  800cbe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cc1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ccc:	b8 09 00 00 00       	mov    $0x9,%eax
  800cd1:	89 df                	mov    %ebx,%edi
  800cd3:	89 de                	mov    %ebx,%esi
  800cd5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cd7:	85 c0                	test   %eax,%eax
  800cd9:	7f 08                	jg     800ce3 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800cdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cde:	5b                   	pop    %ebx
  800cdf:	5e                   	pop    %esi
  800ce0:	5f                   	pop    %edi
  800ce1:	5d                   	pop    %ebp
  800ce2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce3:	83 ec 0c             	sub    $0xc,%esp
  800ce6:	50                   	push   %eax
  800ce7:	6a 09                	push   $0x9
  800ce9:	68 a4 12 80 00       	push   $0x8012a4
  800cee:	6a 23                	push   $0x23
  800cf0:	68 c1 12 80 00       	push   $0x8012c1
  800cf5:	e8 6c 00 00 00       	call   800d66 <_panic>

00800cfa <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800cfa:	f3 0f 1e fb          	endbr32 
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	57                   	push   %edi
  800d02:	56                   	push   %esi
  800d03:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d04:	8b 55 08             	mov    0x8(%ebp),%edx
  800d07:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d0a:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d0f:	be 00 00 00 00       	mov    $0x0,%esi
  800d14:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d17:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d1a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d1c:	5b                   	pop    %ebx
  800d1d:	5e                   	pop    %esi
  800d1e:	5f                   	pop    %edi
  800d1f:	5d                   	pop    %ebp
  800d20:	c3                   	ret    

00800d21 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d21:	f3 0f 1e fb          	endbr32 
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
  800d28:	57                   	push   %edi
  800d29:	56                   	push   %esi
  800d2a:	53                   	push   %ebx
  800d2b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d2e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d33:	8b 55 08             	mov    0x8(%ebp),%edx
  800d36:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d3b:	89 cb                	mov    %ecx,%ebx
  800d3d:	89 cf                	mov    %ecx,%edi
  800d3f:	89 ce                	mov    %ecx,%esi
  800d41:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d43:	85 c0                	test   %eax,%eax
  800d45:	7f 08                	jg     800d4f <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d47:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4a:	5b                   	pop    %ebx
  800d4b:	5e                   	pop    %esi
  800d4c:	5f                   	pop    %edi
  800d4d:	5d                   	pop    %ebp
  800d4e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d4f:	83 ec 0c             	sub    $0xc,%esp
  800d52:	50                   	push   %eax
  800d53:	6a 0c                	push   $0xc
  800d55:	68 a4 12 80 00       	push   $0x8012a4
  800d5a:	6a 23                	push   $0x23
  800d5c:	68 c1 12 80 00       	push   $0x8012c1
  800d61:	e8 00 00 00 00       	call   800d66 <_panic>

00800d66 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800d66:	f3 0f 1e fb          	endbr32 
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
  800d6d:	56                   	push   %esi
  800d6e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800d6f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800d72:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800d78:	e8 d8 fd ff ff       	call   800b55 <sys_getenvid>
  800d7d:	83 ec 0c             	sub    $0xc,%esp
  800d80:	ff 75 0c             	pushl  0xc(%ebp)
  800d83:	ff 75 08             	pushl  0x8(%ebp)
  800d86:	56                   	push   %esi
  800d87:	50                   	push   %eax
  800d88:	68 d0 12 80 00       	push   $0x8012d0
  800d8d:	e8 bd f3 ff ff       	call   80014f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800d92:	83 c4 18             	add    $0x18,%esp
  800d95:	53                   	push   %ebx
  800d96:	ff 75 10             	pushl  0x10(%ebp)
  800d99:	e8 5c f3 ff ff       	call   8000fa <vcprintf>
	cprintf("\n");
  800d9e:	c7 04 24 f3 12 80 00 	movl   $0x8012f3,(%esp)
  800da5:	e8 a5 f3 ff ff       	call   80014f <cprintf>
  800daa:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800dad:	cc                   	int3   
  800dae:	eb fd                	jmp    800dad <_panic+0x47>

00800db0 <__udivdi3>:
  800db0:	f3 0f 1e fb          	endbr32 
  800db4:	55                   	push   %ebp
  800db5:	57                   	push   %edi
  800db6:	56                   	push   %esi
  800db7:	53                   	push   %ebx
  800db8:	83 ec 1c             	sub    $0x1c,%esp
  800dbb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800dbf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800dc3:	8b 74 24 34          	mov    0x34(%esp),%esi
  800dc7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800dcb:	85 d2                	test   %edx,%edx
  800dcd:	75 19                	jne    800de8 <__udivdi3+0x38>
  800dcf:	39 f3                	cmp    %esi,%ebx
  800dd1:	76 4d                	jbe    800e20 <__udivdi3+0x70>
  800dd3:	31 ff                	xor    %edi,%edi
  800dd5:	89 e8                	mov    %ebp,%eax
  800dd7:	89 f2                	mov    %esi,%edx
  800dd9:	f7 f3                	div    %ebx
  800ddb:	89 fa                	mov    %edi,%edx
  800ddd:	83 c4 1c             	add    $0x1c,%esp
  800de0:	5b                   	pop    %ebx
  800de1:	5e                   	pop    %esi
  800de2:	5f                   	pop    %edi
  800de3:	5d                   	pop    %ebp
  800de4:	c3                   	ret    
  800de5:	8d 76 00             	lea    0x0(%esi),%esi
  800de8:	39 f2                	cmp    %esi,%edx
  800dea:	76 14                	jbe    800e00 <__udivdi3+0x50>
  800dec:	31 ff                	xor    %edi,%edi
  800dee:	31 c0                	xor    %eax,%eax
  800df0:	89 fa                	mov    %edi,%edx
  800df2:	83 c4 1c             	add    $0x1c,%esp
  800df5:	5b                   	pop    %ebx
  800df6:	5e                   	pop    %esi
  800df7:	5f                   	pop    %edi
  800df8:	5d                   	pop    %ebp
  800df9:	c3                   	ret    
  800dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800e00:	0f bd fa             	bsr    %edx,%edi
  800e03:	83 f7 1f             	xor    $0x1f,%edi
  800e06:	75 48                	jne    800e50 <__udivdi3+0xa0>
  800e08:	39 f2                	cmp    %esi,%edx
  800e0a:	72 06                	jb     800e12 <__udivdi3+0x62>
  800e0c:	31 c0                	xor    %eax,%eax
  800e0e:	39 eb                	cmp    %ebp,%ebx
  800e10:	77 de                	ja     800df0 <__udivdi3+0x40>
  800e12:	b8 01 00 00 00       	mov    $0x1,%eax
  800e17:	eb d7                	jmp    800df0 <__udivdi3+0x40>
  800e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800e20:	89 d9                	mov    %ebx,%ecx
  800e22:	85 db                	test   %ebx,%ebx
  800e24:	75 0b                	jne    800e31 <__udivdi3+0x81>
  800e26:	b8 01 00 00 00       	mov    $0x1,%eax
  800e2b:	31 d2                	xor    %edx,%edx
  800e2d:	f7 f3                	div    %ebx
  800e2f:	89 c1                	mov    %eax,%ecx
  800e31:	31 d2                	xor    %edx,%edx
  800e33:	89 f0                	mov    %esi,%eax
  800e35:	f7 f1                	div    %ecx
  800e37:	89 c6                	mov    %eax,%esi
  800e39:	89 e8                	mov    %ebp,%eax
  800e3b:	89 f7                	mov    %esi,%edi
  800e3d:	f7 f1                	div    %ecx
  800e3f:	89 fa                	mov    %edi,%edx
  800e41:	83 c4 1c             	add    $0x1c,%esp
  800e44:	5b                   	pop    %ebx
  800e45:	5e                   	pop    %esi
  800e46:	5f                   	pop    %edi
  800e47:	5d                   	pop    %ebp
  800e48:	c3                   	ret    
  800e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800e50:	89 f9                	mov    %edi,%ecx
  800e52:	b8 20 00 00 00       	mov    $0x20,%eax
  800e57:	29 f8                	sub    %edi,%eax
  800e59:	d3 e2                	shl    %cl,%edx
  800e5b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800e5f:	89 c1                	mov    %eax,%ecx
  800e61:	89 da                	mov    %ebx,%edx
  800e63:	d3 ea                	shr    %cl,%edx
  800e65:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800e69:	09 d1                	or     %edx,%ecx
  800e6b:	89 f2                	mov    %esi,%edx
  800e6d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800e71:	89 f9                	mov    %edi,%ecx
  800e73:	d3 e3                	shl    %cl,%ebx
  800e75:	89 c1                	mov    %eax,%ecx
  800e77:	d3 ea                	shr    %cl,%edx
  800e79:	89 f9                	mov    %edi,%ecx
  800e7b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800e7f:	89 eb                	mov    %ebp,%ebx
  800e81:	d3 e6                	shl    %cl,%esi
  800e83:	89 c1                	mov    %eax,%ecx
  800e85:	d3 eb                	shr    %cl,%ebx
  800e87:	09 de                	or     %ebx,%esi
  800e89:	89 f0                	mov    %esi,%eax
  800e8b:	f7 74 24 08          	divl   0x8(%esp)
  800e8f:	89 d6                	mov    %edx,%esi
  800e91:	89 c3                	mov    %eax,%ebx
  800e93:	f7 64 24 0c          	mull   0xc(%esp)
  800e97:	39 d6                	cmp    %edx,%esi
  800e99:	72 15                	jb     800eb0 <__udivdi3+0x100>
  800e9b:	89 f9                	mov    %edi,%ecx
  800e9d:	d3 e5                	shl    %cl,%ebp
  800e9f:	39 c5                	cmp    %eax,%ebp
  800ea1:	73 04                	jae    800ea7 <__udivdi3+0xf7>
  800ea3:	39 d6                	cmp    %edx,%esi
  800ea5:	74 09                	je     800eb0 <__udivdi3+0x100>
  800ea7:	89 d8                	mov    %ebx,%eax
  800ea9:	31 ff                	xor    %edi,%edi
  800eab:	e9 40 ff ff ff       	jmp    800df0 <__udivdi3+0x40>
  800eb0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800eb3:	31 ff                	xor    %edi,%edi
  800eb5:	e9 36 ff ff ff       	jmp    800df0 <__udivdi3+0x40>
  800eba:	66 90                	xchg   %ax,%ax
  800ebc:	66 90                	xchg   %ax,%ax
  800ebe:	66 90                	xchg   %ax,%ax

00800ec0 <__umoddi3>:
  800ec0:	f3 0f 1e fb          	endbr32 
  800ec4:	55                   	push   %ebp
  800ec5:	57                   	push   %edi
  800ec6:	56                   	push   %esi
  800ec7:	53                   	push   %ebx
  800ec8:	83 ec 1c             	sub    $0x1c,%esp
  800ecb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800ecf:	8b 74 24 30          	mov    0x30(%esp),%esi
  800ed3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800ed7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800edb:	85 c0                	test   %eax,%eax
  800edd:	75 19                	jne    800ef8 <__umoddi3+0x38>
  800edf:	39 df                	cmp    %ebx,%edi
  800ee1:	76 5d                	jbe    800f40 <__umoddi3+0x80>
  800ee3:	89 f0                	mov    %esi,%eax
  800ee5:	89 da                	mov    %ebx,%edx
  800ee7:	f7 f7                	div    %edi
  800ee9:	89 d0                	mov    %edx,%eax
  800eeb:	31 d2                	xor    %edx,%edx
  800eed:	83 c4 1c             	add    $0x1c,%esp
  800ef0:	5b                   	pop    %ebx
  800ef1:	5e                   	pop    %esi
  800ef2:	5f                   	pop    %edi
  800ef3:	5d                   	pop    %ebp
  800ef4:	c3                   	ret    
  800ef5:	8d 76 00             	lea    0x0(%esi),%esi
  800ef8:	89 f2                	mov    %esi,%edx
  800efa:	39 d8                	cmp    %ebx,%eax
  800efc:	76 12                	jbe    800f10 <__umoddi3+0x50>
  800efe:	89 f0                	mov    %esi,%eax
  800f00:	89 da                	mov    %ebx,%edx
  800f02:	83 c4 1c             	add    $0x1c,%esp
  800f05:	5b                   	pop    %ebx
  800f06:	5e                   	pop    %esi
  800f07:	5f                   	pop    %edi
  800f08:	5d                   	pop    %ebp
  800f09:	c3                   	ret    
  800f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800f10:	0f bd e8             	bsr    %eax,%ebp
  800f13:	83 f5 1f             	xor    $0x1f,%ebp
  800f16:	75 50                	jne    800f68 <__umoddi3+0xa8>
  800f18:	39 d8                	cmp    %ebx,%eax
  800f1a:	0f 82 e0 00 00 00    	jb     801000 <__umoddi3+0x140>
  800f20:	89 d9                	mov    %ebx,%ecx
  800f22:	39 f7                	cmp    %esi,%edi
  800f24:	0f 86 d6 00 00 00    	jbe    801000 <__umoddi3+0x140>
  800f2a:	89 d0                	mov    %edx,%eax
  800f2c:	89 ca                	mov    %ecx,%edx
  800f2e:	83 c4 1c             	add    $0x1c,%esp
  800f31:	5b                   	pop    %ebx
  800f32:	5e                   	pop    %esi
  800f33:	5f                   	pop    %edi
  800f34:	5d                   	pop    %ebp
  800f35:	c3                   	ret    
  800f36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f3d:	8d 76 00             	lea    0x0(%esi),%esi
  800f40:	89 fd                	mov    %edi,%ebp
  800f42:	85 ff                	test   %edi,%edi
  800f44:	75 0b                	jne    800f51 <__umoddi3+0x91>
  800f46:	b8 01 00 00 00       	mov    $0x1,%eax
  800f4b:	31 d2                	xor    %edx,%edx
  800f4d:	f7 f7                	div    %edi
  800f4f:	89 c5                	mov    %eax,%ebp
  800f51:	89 d8                	mov    %ebx,%eax
  800f53:	31 d2                	xor    %edx,%edx
  800f55:	f7 f5                	div    %ebp
  800f57:	89 f0                	mov    %esi,%eax
  800f59:	f7 f5                	div    %ebp
  800f5b:	89 d0                	mov    %edx,%eax
  800f5d:	31 d2                	xor    %edx,%edx
  800f5f:	eb 8c                	jmp    800eed <__umoddi3+0x2d>
  800f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f68:	89 e9                	mov    %ebp,%ecx
  800f6a:	ba 20 00 00 00       	mov    $0x20,%edx
  800f6f:	29 ea                	sub    %ebp,%edx
  800f71:	d3 e0                	shl    %cl,%eax
  800f73:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f77:	89 d1                	mov    %edx,%ecx
  800f79:	89 f8                	mov    %edi,%eax
  800f7b:	d3 e8                	shr    %cl,%eax
  800f7d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800f81:	89 54 24 04          	mov    %edx,0x4(%esp)
  800f85:	8b 54 24 04          	mov    0x4(%esp),%edx
  800f89:	09 c1                	or     %eax,%ecx
  800f8b:	89 d8                	mov    %ebx,%eax
  800f8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800f91:	89 e9                	mov    %ebp,%ecx
  800f93:	d3 e7                	shl    %cl,%edi
  800f95:	89 d1                	mov    %edx,%ecx
  800f97:	d3 e8                	shr    %cl,%eax
  800f99:	89 e9                	mov    %ebp,%ecx
  800f9b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800f9f:	d3 e3                	shl    %cl,%ebx
  800fa1:	89 c7                	mov    %eax,%edi
  800fa3:	89 d1                	mov    %edx,%ecx
  800fa5:	89 f0                	mov    %esi,%eax
  800fa7:	d3 e8                	shr    %cl,%eax
  800fa9:	89 e9                	mov    %ebp,%ecx
  800fab:	89 fa                	mov    %edi,%edx
  800fad:	d3 e6                	shl    %cl,%esi
  800faf:	09 d8                	or     %ebx,%eax
  800fb1:	f7 74 24 08          	divl   0x8(%esp)
  800fb5:	89 d1                	mov    %edx,%ecx
  800fb7:	89 f3                	mov    %esi,%ebx
  800fb9:	f7 64 24 0c          	mull   0xc(%esp)
  800fbd:	89 c6                	mov    %eax,%esi
  800fbf:	89 d7                	mov    %edx,%edi
  800fc1:	39 d1                	cmp    %edx,%ecx
  800fc3:	72 06                	jb     800fcb <__umoddi3+0x10b>
  800fc5:	75 10                	jne    800fd7 <__umoddi3+0x117>
  800fc7:	39 c3                	cmp    %eax,%ebx
  800fc9:	73 0c                	jae    800fd7 <__umoddi3+0x117>
  800fcb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  800fcf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  800fd3:	89 d7                	mov    %edx,%edi
  800fd5:	89 c6                	mov    %eax,%esi
  800fd7:	89 ca                	mov    %ecx,%edx
  800fd9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800fde:	29 f3                	sub    %esi,%ebx
  800fe0:	19 fa                	sbb    %edi,%edx
  800fe2:	89 d0                	mov    %edx,%eax
  800fe4:	d3 e0                	shl    %cl,%eax
  800fe6:	89 e9                	mov    %ebp,%ecx
  800fe8:	d3 eb                	shr    %cl,%ebx
  800fea:	d3 ea                	shr    %cl,%edx
  800fec:	09 d8                	or     %ebx,%eax
  800fee:	83 c4 1c             	add    $0x1c,%esp
  800ff1:	5b                   	pop    %ebx
  800ff2:	5e                   	pop    %esi
  800ff3:	5f                   	pop    %edi
  800ff4:	5d                   	pop    %ebp
  800ff5:	c3                   	ret    
  800ff6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ffd:	8d 76 00             	lea    0x0(%esi),%esi
  801000:	29 fe                	sub    %edi,%esi
  801002:	19 c3                	sbb    %eax,%ebx
  801004:	89 f2                	mov    %esi,%edx
  801006:	89 d9                	mov    %ebx,%ecx
  801008:	e9 1d ff ff ff       	jmp    800f2a <__umoddi3+0x6a>
