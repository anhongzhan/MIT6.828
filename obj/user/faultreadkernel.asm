
obj/user/faultreadkernel.debug:     file format elf32-i386


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
  800043:	68 00 1f 80 00       	push   $0x801f00
  800048:	e8 0a 01 00 00       	call   800157 <cprintf>
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
  800061:	e8 f7 0a 00 00       	call   800b5d <sys_getenvid>
  800066:	25 ff 03 00 00       	and    $0x3ff,%eax
  80006b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80006e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800073:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800078:	85 db                	test   %ebx,%ebx
  80007a:	7e 07                	jle    800083 <libmain+0x31>
		binaryname = argv[0];
  80007c:	8b 06                	mov    (%esi),%eax
  80007e:	a3 00 30 80 00       	mov    %eax,0x803000

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
  8000a3:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000a6:	e8 f8 0e 00 00       	call   800fa3 <close_all>
	sys_env_destroy(0);
  8000ab:	83 ec 0c             	sub    $0xc,%esp
  8000ae:	6a 00                	push   $0x0
  8000b0:	e8 63 0a 00 00       	call   800b18 <sys_env_destroy>
}
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	c9                   	leave  
  8000b9:	c3                   	ret    

008000ba <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000ba:	f3 0f 1e fb          	endbr32 
  8000be:	55                   	push   %ebp
  8000bf:	89 e5                	mov    %esp,%ebp
  8000c1:	53                   	push   %ebx
  8000c2:	83 ec 04             	sub    $0x4,%esp
  8000c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000c8:	8b 13                	mov    (%ebx),%edx
  8000ca:	8d 42 01             	lea    0x1(%edx),%eax
  8000cd:	89 03                	mov    %eax,(%ebx)
  8000cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000d2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000d6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000db:	74 09                	je     8000e6 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000dd:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000e4:	c9                   	leave  
  8000e5:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000e6:	83 ec 08             	sub    $0x8,%esp
  8000e9:	68 ff 00 00 00       	push   $0xff
  8000ee:	8d 43 08             	lea    0x8(%ebx),%eax
  8000f1:	50                   	push   %eax
  8000f2:	e8 dc 09 00 00       	call   800ad3 <sys_cputs>
		b->idx = 0;
  8000f7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000fd:	83 c4 10             	add    $0x10,%esp
  800100:	eb db                	jmp    8000dd <putch+0x23>

00800102 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800102:	f3 0f 1e fb          	endbr32 
  800106:	55                   	push   %ebp
  800107:	89 e5                	mov    %esp,%ebp
  800109:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80010f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800116:	00 00 00 
	b.cnt = 0;
  800119:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800120:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800123:	ff 75 0c             	pushl  0xc(%ebp)
  800126:	ff 75 08             	pushl  0x8(%ebp)
  800129:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80012f:	50                   	push   %eax
  800130:	68 ba 00 80 00       	push   $0x8000ba
  800135:	e8 20 01 00 00       	call   80025a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80013a:	83 c4 08             	add    $0x8,%esp
  80013d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800143:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800149:	50                   	push   %eax
  80014a:	e8 84 09 00 00       	call   800ad3 <sys_cputs>

	return b.cnt;
}
  80014f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800155:	c9                   	leave  
  800156:	c3                   	ret    

00800157 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800157:	f3 0f 1e fb          	endbr32 
  80015b:	55                   	push   %ebp
  80015c:	89 e5                	mov    %esp,%ebp
  80015e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800161:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800164:	50                   	push   %eax
  800165:	ff 75 08             	pushl  0x8(%ebp)
  800168:	e8 95 ff ff ff       	call   800102 <vcprintf>
	va_end(ap);

	return cnt;
}
  80016d:	c9                   	leave  
  80016e:	c3                   	ret    

0080016f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80016f:	55                   	push   %ebp
  800170:	89 e5                	mov    %esp,%ebp
  800172:	57                   	push   %edi
  800173:	56                   	push   %esi
  800174:	53                   	push   %ebx
  800175:	83 ec 1c             	sub    $0x1c,%esp
  800178:	89 c7                	mov    %eax,%edi
  80017a:	89 d6                	mov    %edx,%esi
  80017c:	8b 45 08             	mov    0x8(%ebp),%eax
  80017f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800182:	89 d1                	mov    %edx,%ecx
  800184:	89 c2                	mov    %eax,%edx
  800186:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800189:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80018c:	8b 45 10             	mov    0x10(%ebp),%eax
  80018f:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800192:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800195:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80019c:	39 c2                	cmp    %eax,%edx
  80019e:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8001a1:	72 3e                	jb     8001e1 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001a3:	83 ec 0c             	sub    $0xc,%esp
  8001a6:	ff 75 18             	pushl  0x18(%ebp)
  8001a9:	83 eb 01             	sub    $0x1,%ebx
  8001ac:	53                   	push   %ebx
  8001ad:	50                   	push   %eax
  8001ae:	83 ec 08             	sub    $0x8,%esp
  8001b1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001b4:	ff 75 e0             	pushl  -0x20(%ebp)
  8001b7:	ff 75 dc             	pushl  -0x24(%ebp)
  8001ba:	ff 75 d8             	pushl  -0x28(%ebp)
  8001bd:	e8 de 1a 00 00       	call   801ca0 <__udivdi3>
  8001c2:	83 c4 18             	add    $0x18,%esp
  8001c5:	52                   	push   %edx
  8001c6:	50                   	push   %eax
  8001c7:	89 f2                	mov    %esi,%edx
  8001c9:	89 f8                	mov    %edi,%eax
  8001cb:	e8 9f ff ff ff       	call   80016f <printnum>
  8001d0:	83 c4 20             	add    $0x20,%esp
  8001d3:	eb 13                	jmp    8001e8 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001d5:	83 ec 08             	sub    $0x8,%esp
  8001d8:	56                   	push   %esi
  8001d9:	ff 75 18             	pushl  0x18(%ebp)
  8001dc:	ff d7                	call   *%edi
  8001de:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001e1:	83 eb 01             	sub    $0x1,%ebx
  8001e4:	85 db                	test   %ebx,%ebx
  8001e6:	7f ed                	jg     8001d5 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001e8:	83 ec 08             	sub    $0x8,%esp
  8001eb:	56                   	push   %esi
  8001ec:	83 ec 04             	sub    $0x4,%esp
  8001ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001f2:	ff 75 e0             	pushl  -0x20(%ebp)
  8001f5:	ff 75 dc             	pushl  -0x24(%ebp)
  8001f8:	ff 75 d8             	pushl  -0x28(%ebp)
  8001fb:	e8 b0 1b 00 00       	call   801db0 <__umoddi3>
  800200:	83 c4 14             	add    $0x14,%esp
  800203:	0f be 80 31 1f 80 00 	movsbl 0x801f31(%eax),%eax
  80020a:	50                   	push   %eax
  80020b:	ff d7                	call   *%edi
}
  80020d:	83 c4 10             	add    $0x10,%esp
  800210:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800213:	5b                   	pop    %ebx
  800214:	5e                   	pop    %esi
  800215:	5f                   	pop    %edi
  800216:	5d                   	pop    %ebp
  800217:	c3                   	ret    

00800218 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800218:	f3 0f 1e fb          	endbr32 
  80021c:	55                   	push   %ebp
  80021d:	89 e5                	mov    %esp,%ebp
  80021f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800222:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800226:	8b 10                	mov    (%eax),%edx
  800228:	3b 50 04             	cmp    0x4(%eax),%edx
  80022b:	73 0a                	jae    800237 <sprintputch+0x1f>
		*b->buf++ = ch;
  80022d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800230:	89 08                	mov    %ecx,(%eax)
  800232:	8b 45 08             	mov    0x8(%ebp),%eax
  800235:	88 02                	mov    %al,(%edx)
}
  800237:	5d                   	pop    %ebp
  800238:	c3                   	ret    

00800239 <printfmt>:
{
  800239:	f3 0f 1e fb          	endbr32 
  80023d:	55                   	push   %ebp
  80023e:	89 e5                	mov    %esp,%ebp
  800240:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800243:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800246:	50                   	push   %eax
  800247:	ff 75 10             	pushl  0x10(%ebp)
  80024a:	ff 75 0c             	pushl  0xc(%ebp)
  80024d:	ff 75 08             	pushl  0x8(%ebp)
  800250:	e8 05 00 00 00       	call   80025a <vprintfmt>
}
  800255:	83 c4 10             	add    $0x10,%esp
  800258:	c9                   	leave  
  800259:	c3                   	ret    

0080025a <vprintfmt>:
{
  80025a:	f3 0f 1e fb          	endbr32 
  80025e:	55                   	push   %ebp
  80025f:	89 e5                	mov    %esp,%ebp
  800261:	57                   	push   %edi
  800262:	56                   	push   %esi
  800263:	53                   	push   %ebx
  800264:	83 ec 3c             	sub    $0x3c,%esp
  800267:	8b 75 08             	mov    0x8(%ebp),%esi
  80026a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80026d:	8b 7d 10             	mov    0x10(%ebp),%edi
  800270:	e9 8e 03 00 00       	jmp    800603 <vprintfmt+0x3a9>
		padc = ' ';
  800275:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800279:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800280:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800287:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80028e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800293:	8d 47 01             	lea    0x1(%edi),%eax
  800296:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800299:	0f b6 17             	movzbl (%edi),%edx
  80029c:	8d 42 dd             	lea    -0x23(%edx),%eax
  80029f:	3c 55                	cmp    $0x55,%al
  8002a1:	0f 87 df 03 00 00    	ja     800686 <vprintfmt+0x42c>
  8002a7:	0f b6 c0             	movzbl %al,%eax
  8002aa:	3e ff 24 85 80 20 80 	notrack jmp *0x802080(,%eax,4)
  8002b1:	00 
  8002b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002b5:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8002b9:	eb d8                	jmp    800293 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8002bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8002be:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8002c2:	eb cf                	jmp    800293 <vprintfmt+0x39>
  8002c4:	0f b6 d2             	movzbl %dl,%edx
  8002c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8002cf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002d2:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002d5:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002d9:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002dc:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002df:	83 f9 09             	cmp    $0x9,%ecx
  8002e2:	77 55                	ja     800339 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8002e4:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002e7:	eb e9                	jmp    8002d2 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8002e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8002ec:	8b 00                	mov    (%eax),%eax
  8002ee:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8002f4:	8d 40 04             	lea    0x4(%eax),%eax
  8002f7:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002fa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8002fd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800301:	79 90                	jns    800293 <vprintfmt+0x39>
				width = precision, precision = -1;
  800303:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800306:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800309:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800310:	eb 81                	jmp    800293 <vprintfmt+0x39>
  800312:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800315:	85 c0                	test   %eax,%eax
  800317:	ba 00 00 00 00       	mov    $0x0,%edx
  80031c:	0f 49 d0             	cmovns %eax,%edx
  80031f:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800322:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800325:	e9 69 ff ff ff       	jmp    800293 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80032a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80032d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800334:	e9 5a ff ff ff       	jmp    800293 <vprintfmt+0x39>
  800339:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80033c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80033f:	eb bc                	jmp    8002fd <vprintfmt+0xa3>
			lflag++;
  800341:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800344:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800347:	e9 47 ff ff ff       	jmp    800293 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80034c:	8b 45 14             	mov    0x14(%ebp),%eax
  80034f:	8d 78 04             	lea    0x4(%eax),%edi
  800352:	83 ec 08             	sub    $0x8,%esp
  800355:	53                   	push   %ebx
  800356:	ff 30                	pushl  (%eax)
  800358:	ff d6                	call   *%esi
			break;
  80035a:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80035d:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800360:	e9 9b 02 00 00       	jmp    800600 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800365:	8b 45 14             	mov    0x14(%ebp),%eax
  800368:	8d 78 04             	lea    0x4(%eax),%edi
  80036b:	8b 00                	mov    (%eax),%eax
  80036d:	99                   	cltd   
  80036e:	31 d0                	xor    %edx,%eax
  800370:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800372:	83 f8 0f             	cmp    $0xf,%eax
  800375:	7f 23                	jg     80039a <vprintfmt+0x140>
  800377:	8b 14 85 e0 21 80 00 	mov    0x8021e0(,%eax,4),%edx
  80037e:	85 d2                	test   %edx,%edx
  800380:	74 18                	je     80039a <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800382:	52                   	push   %edx
  800383:	68 11 23 80 00       	push   $0x802311
  800388:	53                   	push   %ebx
  800389:	56                   	push   %esi
  80038a:	e8 aa fe ff ff       	call   800239 <printfmt>
  80038f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800392:	89 7d 14             	mov    %edi,0x14(%ebp)
  800395:	e9 66 02 00 00       	jmp    800600 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80039a:	50                   	push   %eax
  80039b:	68 49 1f 80 00       	push   $0x801f49
  8003a0:	53                   	push   %ebx
  8003a1:	56                   	push   %esi
  8003a2:	e8 92 fe ff ff       	call   800239 <printfmt>
  8003a7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003aa:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003ad:	e9 4e 02 00 00       	jmp    800600 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8003b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b5:	83 c0 04             	add    $0x4,%eax
  8003b8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8003bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003be:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8003c0:	85 d2                	test   %edx,%edx
  8003c2:	b8 42 1f 80 00       	mov    $0x801f42,%eax
  8003c7:	0f 45 c2             	cmovne %edx,%eax
  8003ca:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8003cd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003d1:	7e 06                	jle    8003d9 <vprintfmt+0x17f>
  8003d3:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8003d7:	75 0d                	jne    8003e6 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003d9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003dc:	89 c7                	mov    %eax,%edi
  8003de:	03 45 e0             	add    -0x20(%ebp),%eax
  8003e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003e4:	eb 55                	jmp    80043b <vprintfmt+0x1e1>
  8003e6:	83 ec 08             	sub    $0x8,%esp
  8003e9:	ff 75 d8             	pushl  -0x28(%ebp)
  8003ec:	ff 75 cc             	pushl  -0x34(%ebp)
  8003ef:	e8 46 03 00 00       	call   80073a <strnlen>
  8003f4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003f7:	29 c2                	sub    %eax,%edx
  8003f9:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8003fc:	83 c4 10             	add    $0x10,%esp
  8003ff:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800401:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800405:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800408:	85 ff                	test   %edi,%edi
  80040a:	7e 11                	jle    80041d <vprintfmt+0x1c3>
					putch(padc, putdat);
  80040c:	83 ec 08             	sub    $0x8,%esp
  80040f:	53                   	push   %ebx
  800410:	ff 75 e0             	pushl  -0x20(%ebp)
  800413:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800415:	83 ef 01             	sub    $0x1,%edi
  800418:	83 c4 10             	add    $0x10,%esp
  80041b:	eb eb                	jmp    800408 <vprintfmt+0x1ae>
  80041d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800420:	85 d2                	test   %edx,%edx
  800422:	b8 00 00 00 00       	mov    $0x0,%eax
  800427:	0f 49 c2             	cmovns %edx,%eax
  80042a:	29 c2                	sub    %eax,%edx
  80042c:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80042f:	eb a8                	jmp    8003d9 <vprintfmt+0x17f>
					putch(ch, putdat);
  800431:	83 ec 08             	sub    $0x8,%esp
  800434:	53                   	push   %ebx
  800435:	52                   	push   %edx
  800436:	ff d6                	call   *%esi
  800438:	83 c4 10             	add    $0x10,%esp
  80043b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80043e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800440:	83 c7 01             	add    $0x1,%edi
  800443:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800447:	0f be d0             	movsbl %al,%edx
  80044a:	85 d2                	test   %edx,%edx
  80044c:	74 4b                	je     800499 <vprintfmt+0x23f>
  80044e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800452:	78 06                	js     80045a <vprintfmt+0x200>
  800454:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800458:	78 1e                	js     800478 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  80045a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80045e:	74 d1                	je     800431 <vprintfmt+0x1d7>
  800460:	0f be c0             	movsbl %al,%eax
  800463:	83 e8 20             	sub    $0x20,%eax
  800466:	83 f8 5e             	cmp    $0x5e,%eax
  800469:	76 c6                	jbe    800431 <vprintfmt+0x1d7>
					putch('?', putdat);
  80046b:	83 ec 08             	sub    $0x8,%esp
  80046e:	53                   	push   %ebx
  80046f:	6a 3f                	push   $0x3f
  800471:	ff d6                	call   *%esi
  800473:	83 c4 10             	add    $0x10,%esp
  800476:	eb c3                	jmp    80043b <vprintfmt+0x1e1>
  800478:	89 cf                	mov    %ecx,%edi
  80047a:	eb 0e                	jmp    80048a <vprintfmt+0x230>
				putch(' ', putdat);
  80047c:	83 ec 08             	sub    $0x8,%esp
  80047f:	53                   	push   %ebx
  800480:	6a 20                	push   $0x20
  800482:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800484:	83 ef 01             	sub    $0x1,%edi
  800487:	83 c4 10             	add    $0x10,%esp
  80048a:	85 ff                	test   %edi,%edi
  80048c:	7f ee                	jg     80047c <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  80048e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800491:	89 45 14             	mov    %eax,0x14(%ebp)
  800494:	e9 67 01 00 00       	jmp    800600 <vprintfmt+0x3a6>
  800499:	89 cf                	mov    %ecx,%edi
  80049b:	eb ed                	jmp    80048a <vprintfmt+0x230>
	if (lflag >= 2)
  80049d:	83 f9 01             	cmp    $0x1,%ecx
  8004a0:	7f 1b                	jg     8004bd <vprintfmt+0x263>
	else if (lflag)
  8004a2:	85 c9                	test   %ecx,%ecx
  8004a4:	74 63                	je     800509 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8004a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004ae:	99                   	cltd   
  8004af:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b5:	8d 40 04             	lea    0x4(%eax),%eax
  8004b8:	89 45 14             	mov    %eax,0x14(%ebp)
  8004bb:	eb 17                	jmp    8004d4 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  8004bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c0:	8b 50 04             	mov    0x4(%eax),%edx
  8004c3:	8b 00                	mov    (%eax),%eax
  8004c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ce:	8d 40 08             	lea    0x8(%eax),%eax
  8004d1:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004d4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004d7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8004da:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8004df:	85 c9                	test   %ecx,%ecx
  8004e1:	0f 89 ff 00 00 00    	jns    8005e6 <vprintfmt+0x38c>
				putch('-', putdat);
  8004e7:	83 ec 08             	sub    $0x8,%esp
  8004ea:	53                   	push   %ebx
  8004eb:	6a 2d                	push   $0x2d
  8004ed:	ff d6                	call   *%esi
				num = -(long long) num;
  8004ef:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004f2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004f5:	f7 da                	neg    %edx
  8004f7:	83 d1 00             	adc    $0x0,%ecx
  8004fa:	f7 d9                	neg    %ecx
  8004fc:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8004ff:	b8 0a 00 00 00       	mov    $0xa,%eax
  800504:	e9 dd 00 00 00       	jmp    8005e6 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  800509:	8b 45 14             	mov    0x14(%ebp),%eax
  80050c:	8b 00                	mov    (%eax),%eax
  80050e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800511:	99                   	cltd   
  800512:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800515:	8b 45 14             	mov    0x14(%ebp),%eax
  800518:	8d 40 04             	lea    0x4(%eax),%eax
  80051b:	89 45 14             	mov    %eax,0x14(%ebp)
  80051e:	eb b4                	jmp    8004d4 <vprintfmt+0x27a>
	if (lflag >= 2)
  800520:	83 f9 01             	cmp    $0x1,%ecx
  800523:	7f 1e                	jg     800543 <vprintfmt+0x2e9>
	else if (lflag)
  800525:	85 c9                	test   %ecx,%ecx
  800527:	74 32                	je     80055b <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800529:	8b 45 14             	mov    0x14(%ebp),%eax
  80052c:	8b 10                	mov    (%eax),%edx
  80052e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800533:	8d 40 04             	lea    0x4(%eax),%eax
  800536:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800539:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  80053e:	e9 a3 00 00 00       	jmp    8005e6 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800543:	8b 45 14             	mov    0x14(%ebp),%eax
  800546:	8b 10                	mov    (%eax),%edx
  800548:	8b 48 04             	mov    0x4(%eax),%ecx
  80054b:	8d 40 08             	lea    0x8(%eax),%eax
  80054e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800551:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800556:	e9 8b 00 00 00       	jmp    8005e6 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80055b:	8b 45 14             	mov    0x14(%ebp),%eax
  80055e:	8b 10                	mov    (%eax),%edx
  800560:	b9 00 00 00 00       	mov    $0x0,%ecx
  800565:	8d 40 04             	lea    0x4(%eax),%eax
  800568:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80056b:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800570:	eb 74                	jmp    8005e6 <vprintfmt+0x38c>
	if (lflag >= 2)
  800572:	83 f9 01             	cmp    $0x1,%ecx
  800575:	7f 1b                	jg     800592 <vprintfmt+0x338>
	else if (lflag)
  800577:	85 c9                	test   %ecx,%ecx
  800579:	74 2c                	je     8005a7 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  80057b:	8b 45 14             	mov    0x14(%ebp),%eax
  80057e:	8b 10                	mov    (%eax),%edx
  800580:	b9 00 00 00 00       	mov    $0x0,%ecx
  800585:	8d 40 04             	lea    0x4(%eax),%eax
  800588:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80058b:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800590:	eb 54                	jmp    8005e6 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800592:	8b 45 14             	mov    0x14(%ebp),%eax
  800595:	8b 10                	mov    (%eax),%edx
  800597:	8b 48 04             	mov    0x4(%eax),%ecx
  80059a:	8d 40 08             	lea    0x8(%eax),%eax
  80059d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005a0:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  8005a5:	eb 3f                	jmp    8005e6 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005aa:	8b 10                	mov    (%eax),%edx
  8005ac:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005b1:	8d 40 04             	lea    0x4(%eax),%eax
  8005b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005b7:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  8005bc:	eb 28                	jmp    8005e6 <vprintfmt+0x38c>
			putch('0', putdat);
  8005be:	83 ec 08             	sub    $0x8,%esp
  8005c1:	53                   	push   %ebx
  8005c2:	6a 30                	push   $0x30
  8005c4:	ff d6                	call   *%esi
			putch('x', putdat);
  8005c6:	83 c4 08             	add    $0x8,%esp
  8005c9:	53                   	push   %ebx
  8005ca:	6a 78                	push   $0x78
  8005cc:	ff d6                	call   *%esi
			num = (unsigned long long)
  8005ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d1:	8b 10                	mov    (%eax),%edx
  8005d3:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8005d8:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8005db:	8d 40 04             	lea    0x4(%eax),%eax
  8005de:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8005e1:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8005e6:	83 ec 0c             	sub    $0xc,%esp
  8005e9:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8005ed:	57                   	push   %edi
  8005ee:	ff 75 e0             	pushl  -0x20(%ebp)
  8005f1:	50                   	push   %eax
  8005f2:	51                   	push   %ecx
  8005f3:	52                   	push   %edx
  8005f4:	89 da                	mov    %ebx,%edx
  8005f6:	89 f0                	mov    %esi,%eax
  8005f8:	e8 72 fb ff ff       	call   80016f <printnum>
			break;
  8005fd:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800600:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800603:	83 c7 01             	add    $0x1,%edi
  800606:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80060a:	83 f8 25             	cmp    $0x25,%eax
  80060d:	0f 84 62 fc ff ff    	je     800275 <vprintfmt+0x1b>
			if (ch == '\0')
  800613:	85 c0                	test   %eax,%eax
  800615:	0f 84 8b 00 00 00    	je     8006a6 <vprintfmt+0x44c>
			putch(ch, putdat);
  80061b:	83 ec 08             	sub    $0x8,%esp
  80061e:	53                   	push   %ebx
  80061f:	50                   	push   %eax
  800620:	ff d6                	call   *%esi
  800622:	83 c4 10             	add    $0x10,%esp
  800625:	eb dc                	jmp    800603 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800627:	83 f9 01             	cmp    $0x1,%ecx
  80062a:	7f 1b                	jg     800647 <vprintfmt+0x3ed>
	else if (lflag)
  80062c:	85 c9                	test   %ecx,%ecx
  80062e:	74 2c                	je     80065c <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800630:	8b 45 14             	mov    0x14(%ebp),%eax
  800633:	8b 10                	mov    (%eax),%edx
  800635:	b9 00 00 00 00       	mov    $0x0,%ecx
  80063a:	8d 40 04             	lea    0x4(%eax),%eax
  80063d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800640:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800645:	eb 9f                	jmp    8005e6 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800647:	8b 45 14             	mov    0x14(%ebp),%eax
  80064a:	8b 10                	mov    (%eax),%edx
  80064c:	8b 48 04             	mov    0x4(%eax),%ecx
  80064f:	8d 40 08             	lea    0x8(%eax),%eax
  800652:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800655:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  80065a:	eb 8a                	jmp    8005e6 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8b 10                	mov    (%eax),%edx
  800661:	b9 00 00 00 00       	mov    $0x0,%ecx
  800666:	8d 40 04             	lea    0x4(%eax),%eax
  800669:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80066c:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800671:	e9 70 ff ff ff       	jmp    8005e6 <vprintfmt+0x38c>
			putch(ch, putdat);
  800676:	83 ec 08             	sub    $0x8,%esp
  800679:	53                   	push   %ebx
  80067a:	6a 25                	push   $0x25
  80067c:	ff d6                	call   *%esi
			break;
  80067e:	83 c4 10             	add    $0x10,%esp
  800681:	e9 7a ff ff ff       	jmp    800600 <vprintfmt+0x3a6>
			putch('%', putdat);
  800686:	83 ec 08             	sub    $0x8,%esp
  800689:	53                   	push   %ebx
  80068a:	6a 25                	push   $0x25
  80068c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80068e:	83 c4 10             	add    $0x10,%esp
  800691:	89 f8                	mov    %edi,%eax
  800693:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800697:	74 05                	je     80069e <vprintfmt+0x444>
  800699:	83 e8 01             	sub    $0x1,%eax
  80069c:	eb f5                	jmp    800693 <vprintfmt+0x439>
  80069e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006a1:	e9 5a ff ff ff       	jmp    800600 <vprintfmt+0x3a6>
}
  8006a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006a9:	5b                   	pop    %ebx
  8006aa:	5e                   	pop    %esi
  8006ab:	5f                   	pop    %edi
  8006ac:	5d                   	pop    %ebp
  8006ad:	c3                   	ret    

008006ae <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006ae:	f3 0f 1e fb          	endbr32 
  8006b2:	55                   	push   %ebp
  8006b3:	89 e5                	mov    %esp,%ebp
  8006b5:	83 ec 18             	sub    $0x18,%esp
  8006b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006c1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006c5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006cf:	85 c0                	test   %eax,%eax
  8006d1:	74 26                	je     8006f9 <vsnprintf+0x4b>
  8006d3:	85 d2                	test   %edx,%edx
  8006d5:	7e 22                	jle    8006f9 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006d7:	ff 75 14             	pushl  0x14(%ebp)
  8006da:	ff 75 10             	pushl  0x10(%ebp)
  8006dd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006e0:	50                   	push   %eax
  8006e1:	68 18 02 80 00       	push   $0x800218
  8006e6:	e8 6f fb ff ff       	call   80025a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006ee:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006f4:	83 c4 10             	add    $0x10,%esp
}
  8006f7:	c9                   	leave  
  8006f8:	c3                   	ret    
		return -E_INVAL;
  8006f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006fe:	eb f7                	jmp    8006f7 <vsnprintf+0x49>

00800700 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800700:	f3 0f 1e fb          	endbr32 
  800704:	55                   	push   %ebp
  800705:	89 e5                	mov    %esp,%ebp
  800707:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80070a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80070d:	50                   	push   %eax
  80070e:	ff 75 10             	pushl  0x10(%ebp)
  800711:	ff 75 0c             	pushl  0xc(%ebp)
  800714:	ff 75 08             	pushl  0x8(%ebp)
  800717:	e8 92 ff ff ff       	call   8006ae <vsnprintf>
	va_end(ap);

	return rc;
}
  80071c:	c9                   	leave  
  80071d:	c3                   	ret    

0080071e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80071e:	f3 0f 1e fb          	endbr32 
  800722:	55                   	push   %ebp
  800723:	89 e5                	mov    %esp,%ebp
  800725:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800728:	b8 00 00 00 00       	mov    $0x0,%eax
  80072d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800731:	74 05                	je     800738 <strlen+0x1a>
		n++;
  800733:	83 c0 01             	add    $0x1,%eax
  800736:	eb f5                	jmp    80072d <strlen+0xf>
	return n;
}
  800738:	5d                   	pop    %ebp
  800739:	c3                   	ret    

0080073a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80073a:	f3 0f 1e fb          	endbr32 
  80073e:	55                   	push   %ebp
  80073f:	89 e5                	mov    %esp,%ebp
  800741:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800744:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800747:	b8 00 00 00 00       	mov    $0x0,%eax
  80074c:	39 d0                	cmp    %edx,%eax
  80074e:	74 0d                	je     80075d <strnlen+0x23>
  800750:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800754:	74 05                	je     80075b <strnlen+0x21>
		n++;
  800756:	83 c0 01             	add    $0x1,%eax
  800759:	eb f1                	jmp    80074c <strnlen+0x12>
  80075b:	89 c2                	mov    %eax,%edx
	return n;
}
  80075d:	89 d0                	mov    %edx,%eax
  80075f:	5d                   	pop    %ebp
  800760:	c3                   	ret    

00800761 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800761:	f3 0f 1e fb          	endbr32 
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
  800768:	53                   	push   %ebx
  800769:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80076c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80076f:	b8 00 00 00 00       	mov    $0x0,%eax
  800774:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800778:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  80077b:	83 c0 01             	add    $0x1,%eax
  80077e:	84 d2                	test   %dl,%dl
  800780:	75 f2                	jne    800774 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800782:	89 c8                	mov    %ecx,%eax
  800784:	5b                   	pop    %ebx
  800785:	5d                   	pop    %ebp
  800786:	c3                   	ret    

00800787 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800787:	f3 0f 1e fb          	endbr32 
  80078b:	55                   	push   %ebp
  80078c:	89 e5                	mov    %esp,%ebp
  80078e:	53                   	push   %ebx
  80078f:	83 ec 10             	sub    $0x10,%esp
  800792:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800795:	53                   	push   %ebx
  800796:	e8 83 ff ff ff       	call   80071e <strlen>
  80079b:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80079e:	ff 75 0c             	pushl  0xc(%ebp)
  8007a1:	01 d8                	add    %ebx,%eax
  8007a3:	50                   	push   %eax
  8007a4:	e8 b8 ff ff ff       	call   800761 <strcpy>
	return dst;
}
  8007a9:	89 d8                	mov    %ebx,%eax
  8007ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007ae:	c9                   	leave  
  8007af:	c3                   	ret    

008007b0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007b0:	f3 0f 1e fb          	endbr32 
  8007b4:	55                   	push   %ebp
  8007b5:	89 e5                	mov    %esp,%ebp
  8007b7:	56                   	push   %esi
  8007b8:	53                   	push   %ebx
  8007b9:	8b 75 08             	mov    0x8(%ebp),%esi
  8007bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007bf:	89 f3                	mov    %esi,%ebx
  8007c1:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007c4:	89 f0                	mov    %esi,%eax
  8007c6:	39 d8                	cmp    %ebx,%eax
  8007c8:	74 11                	je     8007db <strncpy+0x2b>
		*dst++ = *src;
  8007ca:	83 c0 01             	add    $0x1,%eax
  8007cd:	0f b6 0a             	movzbl (%edx),%ecx
  8007d0:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007d3:	80 f9 01             	cmp    $0x1,%cl
  8007d6:	83 da ff             	sbb    $0xffffffff,%edx
  8007d9:	eb eb                	jmp    8007c6 <strncpy+0x16>
	}
	return ret;
}
  8007db:	89 f0                	mov    %esi,%eax
  8007dd:	5b                   	pop    %ebx
  8007de:	5e                   	pop    %esi
  8007df:	5d                   	pop    %ebp
  8007e0:	c3                   	ret    

008007e1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007e1:	f3 0f 1e fb          	endbr32 
  8007e5:	55                   	push   %ebp
  8007e6:	89 e5                	mov    %esp,%ebp
  8007e8:	56                   	push   %esi
  8007e9:	53                   	push   %ebx
  8007ea:	8b 75 08             	mov    0x8(%ebp),%esi
  8007ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007f0:	8b 55 10             	mov    0x10(%ebp),%edx
  8007f3:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007f5:	85 d2                	test   %edx,%edx
  8007f7:	74 21                	je     80081a <strlcpy+0x39>
  8007f9:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8007fd:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8007ff:	39 c2                	cmp    %eax,%edx
  800801:	74 14                	je     800817 <strlcpy+0x36>
  800803:	0f b6 19             	movzbl (%ecx),%ebx
  800806:	84 db                	test   %bl,%bl
  800808:	74 0b                	je     800815 <strlcpy+0x34>
			*dst++ = *src++;
  80080a:	83 c1 01             	add    $0x1,%ecx
  80080d:	83 c2 01             	add    $0x1,%edx
  800810:	88 5a ff             	mov    %bl,-0x1(%edx)
  800813:	eb ea                	jmp    8007ff <strlcpy+0x1e>
  800815:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800817:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80081a:	29 f0                	sub    %esi,%eax
}
  80081c:	5b                   	pop    %ebx
  80081d:	5e                   	pop    %esi
  80081e:	5d                   	pop    %ebp
  80081f:	c3                   	ret    

00800820 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800820:	f3 0f 1e fb          	endbr32 
  800824:	55                   	push   %ebp
  800825:	89 e5                	mov    %esp,%ebp
  800827:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80082a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80082d:	0f b6 01             	movzbl (%ecx),%eax
  800830:	84 c0                	test   %al,%al
  800832:	74 0c                	je     800840 <strcmp+0x20>
  800834:	3a 02                	cmp    (%edx),%al
  800836:	75 08                	jne    800840 <strcmp+0x20>
		p++, q++;
  800838:	83 c1 01             	add    $0x1,%ecx
  80083b:	83 c2 01             	add    $0x1,%edx
  80083e:	eb ed                	jmp    80082d <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800840:	0f b6 c0             	movzbl %al,%eax
  800843:	0f b6 12             	movzbl (%edx),%edx
  800846:	29 d0                	sub    %edx,%eax
}
  800848:	5d                   	pop    %ebp
  800849:	c3                   	ret    

0080084a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80084a:	f3 0f 1e fb          	endbr32 
  80084e:	55                   	push   %ebp
  80084f:	89 e5                	mov    %esp,%ebp
  800851:	53                   	push   %ebx
  800852:	8b 45 08             	mov    0x8(%ebp),%eax
  800855:	8b 55 0c             	mov    0xc(%ebp),%edx
  800858:	89 c3                	mov    %eax,%ebx
  80085a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80085d:	eb 06                	jmp    800865 <strncmp+0x1b>
		n--, p++, q++;
  80085f:	83 c0 01             	add    $0x1,%eax
  800862:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800865:	39 d8                	cmp    %ebx,%eax
  800867:	74 16                	je     80087f <strncmp+0x35>
  800869:	0f b6 08             	movzbl (%eax),%ecx
  80086c:	84 c9                	test   %cl,%cl
  80086e:	74 04                	je     800874 <strncmp+0x2a>
  800870:	3a 0a                	cmp    (%edx),%cl
  800872:	74 eb                	je     80085f <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800874:	0f b6 00             	movzbl (%eax),%eax
  800877:	0f b6 12             	movzbl (%edx),%edx
  80087a:	29 d0                	sub    %edx,%eax
}
  80087c:	5b                   	pop    %ebx
  80087d:	5d                   	pop    %ebp
  80087e:	c3                   	ret    
		return 0;
  80087f:	b8 00 00 00 00       	mov    $0x0,%eax
  800884:	eb f6                	jmp    80087c <strncmp+0x32>

00800886 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800886:	f3 0f 1e fb          	endbr32 
  80088a:	55                   	push   %ebp
  80088b:	89 e5                	mov    %esp,%ebp
  80088d:	8b 45 08             	mov    0x8(%ebp),%eax
  800890:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800894:	0f b6 10             	movzbl (%eax),%edx
  800897:	84 d2                	test   %dl,%dl
  800899:	74 09                	je     8008a4 <strchr+0x1e>
		if (*s == c)
  80089b:	38 ca                	cmp    %cl,%dl
  80089d:	74 0a                	je     8008a9 <strchr+0x23>
	for (; *s; s++)
  80089f:	83 c0 01             	add    $0x1,%eax
  8008a2:	eb f0                	jmp    800894 <strchr+0xe>
			return (char *) s;
	return 0;
  8008a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008a9:	5d                   	pop    %ebp
  8008aa:	c3                   	ret    

008008ab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008ab:	f3 0f 1e fb          	endbr32 
  8008af:	55                   	push   %ebp
  8008b0:	89 e5                	mov    %esp,%ebp
  8008b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008b9:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008bc:	38 ca                	cmp    %cl,%dl
  8008be:	74 09                	je     8008c9 <strfind+0x1e>
  8008c0:	84 d2                	test   %dl,%dl
  8008c2:	74 05                	je     8008c9 <strfind+0x1e>
	for (; *s; s++)
  8008c4:	83 c0 01             	add    $0x1,%eax
  8008c7:	eb f0                	jmp    8008b9 <strfind+0xe>
			break;
	return (char *) s;
}
  8008c9:	5d                   	pop    %ebp
  8008ca:	c3                   	ret    

008008cb <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008cb:	f3 0f 1e fb          	endbr32 
  8008cf:	55                   	push   %ebp
  8008d0:	89 e5                	mov    %esp,%ebp
  8008d2:	57                   	push   %edi
  8008d3:	56                   	push   %esi
  8008d4:	53                   	push   %ebx
  8008d5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008db:	85 c9                	test   %ecx,%ecx
  8008dd:	74 31                	je     800910 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008df:	89 f8                	mov    %edi,%eax
  8008e1:	09 c8                	or     %ecx,%eax
  8008e3:	a8 03                	test   $0x3,%al
  8008e5:	75 23                	jne    80090a <memset+0x3f>
		c &= 0xFF;
  8008e7:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008eb:	89 d3                	mov    %edx,%ebx
  8008ed:	c1 e3 08             	shl    $0x8,%ebx
  8008f0:	89 d0                	mov    %edx,%eax
  8008f2:	c1 e0 18             	shl    $0x18,%eax
  8008f5:	89 d6                	mov    %edx,%esi
  8008f7:	c1 e6 10             	shl    $0x10,%esi
  8008fa:	09 f0                	or     %esi,%eax
  8008fc:	09 c2                	or     %eax,%edx
  8008fe:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800900:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800903:	89 d0                	mov    %edx,%eax
  800905:	fc                   	cld    
  800906:	f3 ab                	rep stos %eax,%es:(%edi)
  800908:	eb 06                	jmp    800910 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80090a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80090d:	fc                   	cld    
  80090e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800910:	89 f8                	mov    %edi,%eax
  800912:	5b                   	pop    %ebx
  800913:	5e                   	pop    %esi
  800914:	5f                   	pop    %edi
  800915:	5d                   	pop    %ebp
  800916:	c3                   	ret    

00800917 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800917:	f3 0f 1e fb          	endbr32 
  80091b:	55                   	push   %ebp
  80091c:	89 e5                	mov    %esp,%ebp
  80091e:	57                   	push   %edi
  80091f:	56                   	push   %esi
  800920:	8b 45 08             	mov    0x8(%ebp),%eax
  800923:	8b 75 0c             	mov    0xc(%ebp),%esi
  800926:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800929:	39 c6                	cmp    %eax,%esi
  80092b:	73 32                	jae    80095f <memmove+0x48>
  80092d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800930:	39 c2                	cmp    %eax,%edx
  800932:	76 2b                	jbe    80095f <memmove+0x48>
		s += n;
		d += n;
  800934:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800937:	89 fe                	mov    %edi,%esi
  800939:	09 ce                	or     %ecx,%esi
  80093b:	09 d6                	or     %edx,%esi
  80093d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800943:	75 0e                	jne    800953 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800945:	83 ef 04             	sub    $0x4,%edi
  800948:	8d 72 fc             	lea    -0x4(%edx),%esi
  80094b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80094e:	fd                   	std    
  80094f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800951:	eb 09                	jmp    80095c <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800953:	83 ef 01             	sub    $0x1,%edi
  800956:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800959:	fd                   	std    
  80095a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80095c:	fc                   	cld    
  80095d:	eb 1a                	jmp    800979 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80095f:	89 c2                	mov    %eax,%edx
  800961:	09 ca                	or     %ecx,%edx
  800963:	09 f2                	or     %esi,%edx
  800965:	f6 c2 03             	test   $0x3,%dl
  800968:	75 0a                	jne    800974 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80096a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80096d:	89 c7                	mov    %eax,%edi
  80096f:	fc                   	cld    
  800970:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800972:	eb 05                	jmp    800979 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800974:	89 c7                	mov    %eax,%edi
  800976:	fc                   	cld    
  800977:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800979:	5e                   	pop    %esi
  80097a:	5f                   	pop    %edi
  80097b:	5d                   	pop    %ebp
  80097c:	c3                   	ret    

0080097d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80097d:	f3 0f 1e fb          	endbr32 
  800981:	55                   	push   %ebp
  800982:	89 e5                	mov    %esp,%ebp
  800984:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800987:	ff 75 10             	pushl  0x10(%ebp)
  80098a:	ff 75 0c             	pushl  0xc(%ebp)
  80098d:	ff 75 08             	pushl  0x8(%ebp)
  800990:	e8 82 ff ff ff       	call   800917 <memmove>
}
  800995:	c9                   	leave  
  800996:	c3                   	ret    

00800997 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800997:	f3 0f 1e fb          	endbr32 
  80099b:	55                   	push   %ebp
  80099c:	89 e5                	mov    %esp,%ebp
  80099e:	56                   	push   %esi
  80099f:	53                   	push   %ebx
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a6:	89 c6                	mov    %eax,%esi
  8009a8:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009ab:	39 f0                	cmp    %esi,%eax
  8009ad:	74 1c                	je     8009cb <memcmp+0x34>
		if (*s1 != *s2)
  8009af:	0f b6 08             	movzbl (%eax),%ecx
  8009b2:	0f b6 1a             	movzbl (%edx),%ebx
  8009b5:	38 d9                	cmp    %bl,%cl
  8009b7:	75 08                	jne    8009c1 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009b9:	83 c0 01             	add    $0x1,%eax
  8009bc:	83 c2 01             	add    $0x1,%edx
  8009bf:	eb ea                	jmp    8009ab <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  8009c1:	0f b6 c1             	movzbl %cl,%eax
  8009c4:	0f b6 db             	movzbl %bl,%ebx
  8009c7:	29 d8                	sub    %ebx,%eax
  8009c9:	eb 05                	jmp    8009d0 <memcmp+0x39>
	}

	return 0;
  8009cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009d0:	5b                   	pop    %ebx
  8009d1:	5e                   	pop    %esi
  8009d2:	5d                   	pop    %ebp
  8009d3:	c3                   	ret    

008009d4 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009d4:	f3 0f 1e fb          	endbr32 
  8009d8:	55                   	push   %ebp
  8009d9:	89 e5                	mov    %esp,%ebp
  8009db:	8b 45 08             	mov    0x8(%ebp),%eax
  8009de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009e1:	89 c2                	mov    %eax,%edx
  8009e3:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009e6:	39 d0                	cmp    %edx,%eax
  8009e8:	73 09                	jae    8009f3 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009ea:	38 08                	cmp    %cl,(%eax)
  8009ec:	74 05                	je     8009f3 <memfind+0x1f>
	for (; s < ends; s++)
  8009ee:	83 c0 01             	add    $0x1,%eax
  8009f1:	eb f3                	jmp    8009e6 <memfind+0x12>
			break;
	return (void *) s;
}
  8009f3:	5d                   	pop    %ebp
  8009f4:	c3                   	ret    

008009f5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009f5:	f3 0f 1e fb          	endbr32 
  8009f9:	55                   	push   %ebp
  8009fa:	89 e5                	mov    %esp,%ebp
  8009fc:	57                   	push   %edi
  8009fd:	56                   	push   %esi
  8009fe:	53                   	push   %ebx
  8009ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a02:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a05:	eb 03                	jmp    800a0a <strtol+0x15>
		s++;
  800a07:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a0a:	0f b6 01             	movzbl (%ecx),%eax
  800a0d:	3c 20                	cmp    $0x20,%al
  800a0f:	74 f6                	je     800a07 <strtol+0x12>
  800a11:	3c 09                	cmp    $0x9,%al
  800a13:	74 f2                	je     800a07 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a15:	3c 2b                	cmp    $0x2b,%al
  800a17:	74 2a                	je     800a43 <strtol+0x4e>
	int neg = 0;
  800a19:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a1e:	3c 2d                	cmp    $0x2d,%al
  800a20:	74 2b                	je     800a4d <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a22:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a28:	75 0f                	jne    800a39 <strtol+0x44>
  800a2a:	80 39 30             	cmpb   $0x30,(%ecx)
  800a2d:	74 28                	je     800a57 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a2f:	85 db                	test   %ebx,%ebx
  800a31:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a36:	0f 44 d8             	cmove  %eax,%ebx
  800a39:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a41:	eb 46                	jmp    800a89 <strtol+0x94>
		s++;
  800a43:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a46:	bf 00 00 00 00       	mov    $0x0,%edi
  800a4b:	eb d5                	jmp    800a22 <strtol+0x2d>
		s++, neg = 1;
  800a4d:	83 c1 01             	add    $0x1,%ecx
  800a50:	bf 01 00 00 00       	mov    $0x1,%edi
  800a55:	eb cb                	jmp    800a22 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a57:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a5b:	74 0e                	je     800a6b <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a5d:	85 db                	test   %ebx,%ebx
  800a5f:	75 d8                	jne    800a39 <strtol+0x44>
		s++, base = 8;
  800a61:	83 c1 01             	add    $0x1,%ecx
  800a64:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a69:	eb ce                	jmp    800a39 <strtol+0x44>
		s += 2, base = 16;
  800a6b:	83 c1 02             	add    $0x2,%ecx
  800a6e:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a73:	eb c4                	jmp    800a39 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800a75:	0f be d2             	movsbl %dl,%edx
  800a78:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a7b:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a7e:	7d 3a                	jge    800aba <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a80:	83 c1 01             	add    $0x1,%ecx
  800a83:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a87:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a89:	0f b6 11             	movzbl (%ecx),%edx
  800a8c:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a8f:	89 f3                	mov    %esi,%ebx
  800a91:	80 fb 09             	cmp    $0x9,%bl
  800a94:	76 df                	jbe    800a75 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800a96:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a99:	89 f3                	mov    %esi,%ebx
  800a9b:	80 fb 19             	cmp    $0x19,%bl
  800a9e:	77 08                	ja     800aa8 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800aa0:	0f be d2             	movsbl %dl,%edx
  800aa3:	83 ea 57             	sub    $0x57,%edx
  800aa6:	eb d3                	jmp    800a7b <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800aa8:	8d 72 bf             	lea    -0x41(%edx),%esi
  800aab:	89 f3                	mov    %esi,%ebx
  800aad:	80 fb 19             	cmp    $0x19,%bl
  800ab0:	77 08                	ja     800aba <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ab2:	0f be d2             	movsbl %dl,%edx
  800ab5:	83 ea 37             	sub    $0x37,%edx
  800ab8:	eb c1                	jmp    800a7b <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800aba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800abe:	74 05                	je     800ac5 <strtol+0xd0>
		*endptr = (char *) s;
  800ac0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ac3:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ac5:	89 c2                	mov    %eax,%edx
  800ac7:	f7 da                	neg    %edx
  800ac9:	85 ff                	test   %edi,%edi
  800acb:	0f 45 c2             	cmovne %edx,%eax
}
  800ace:	5b                   	pop    %ebx
  800acf:	5e                   	pop    %esi
  800ad0:	5f                   	pop    %edi
  800ad1:	5d                   	pop    %ebp
  800ad2:	c3                   	ret    

00800ad3 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ad3:	f3 0f 1e fb          	endbr32 
  800ad7:	55                   	push   %ebp
  800ad8:	89 e5                	mov    %esp,%ebp
  800ada:	57                   	push   %edi
  800adb:	56                   	push   %esi
  800adc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800add:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ae5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ae8:	89 c3                	mov    %eax,%ebx
  800aea:	89 c7                	mov    %eax,%edi
  800aec:	89 c6                	mov    %eax,%esi
  800aee:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800af0:	5b                   	pop    %ebx
  800af1:	5e                   	pop    %esi
  800af2:	5f                   	pop    %edi
  800af3:	5d                   	pop    %ebp
  800af4:	c3                   	ret    

00800af5 <sys_cgetc>:

int
sys_cgetc(void)
{
  800af5:	f3 0f 1e fb          	endbr32 
  800af9:	55                   	push   %ebp
  800afa:	89 e5                	mov    %esp,%ebp
  800afc:	57                   	push   %edi
  800afd:	56                   	push   %esi
  800afe:	53                   	push   %ebx
	asm volatile("int %1\n"
  800aff:	ba 00 00 00 00       	mov    $0x0,%edx
  800b04:	b8 01 00 00 00       	mov    $0x1,%eax
  800b09:	89 d1                	mov    %edx,%ecx
  800b0b:	89 d3                	mov    %edx,%ebx
  800b0d:	89 d7                	mov    %edx,%edi
  800b0f:	89 d6                	mov    %edx,%esi
  800b11:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b13:	5b                   	pop    %ebx
  800b14:	5e                   	pop    %esi
  800b15:	5f                   	pop    %edi
  800b16:	5d                   	pop    %ebp
  800b17:	c3                   	ret    

00800b18 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b18:	f3 0f 1e fb          	endbr32 
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
  800b1f:	57                   	push   %edi
  800b20:	56                   	push   %esi
  800b21:	53                   	push   %ebx
  800b22:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b25:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b2d:	b8 03 00 00 00       	mov    $0x3,%eax
  800b32:	89 cb                	mov    %ecx,%ebx
  800b34:	89 cf                	mov    %ecx,%edi
  800b36:	89 ce                	mov    %ecx,%esi
  800b38:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b3a:	85 c0                	test   %eax,%eax
  800b3c:	7f 08                	jg     800b46 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b41:	5b                   	pop    %ebx
  800b42:	5e                   	pop    %esi
  800b43:	5f                   	pop    %edi
  800b44:	5d                   	pop    %ebp
  800b45:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b46:	83 ec 0c             	sub    $0xc,%esp
  800b49:	50                   	push   %eax
  800b4a:	6a 03                	push   $0x3
  800b4c:	68 3f 22 80 00       	push   $0x80223f
  800b51:	6a 23                	push   $0x23
  800b53:	68 5c 22 80 00       	push   $0x80225c
  800b58:	e8 9c 0f 00 00       	call   801af9 <_panic>

00800b5d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b5d:	f3 0f 1e fb          	endbr32 
  800b61:	55                   	push   %ebp
  800b62:	89 e5                	mov    %esp,%ebp
  800b64:	57                   	push   %edi
  800b65:	56                   	push   %esi
  800b66:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b67:	ba 00 00 00 00       	mov    $0x0,%edx
  800b6c:	b8 02 00 00 00       	mov    $0x2,%eax
  800b71:	89 d1                	mov    %edx,%ecx
  800b73:	89 d3                	mov    %edx,%ebx
  800b75:	89 d7                	mov    %edx,%edi
  800b77:	89 d6                	mov    %edx,%esi
  800b79:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b7b:	5b                   	pop    %ebx
  800b7c:	5e                   	pop    %esi
  800b7d:	5f                   	pop    %edi
  800b7e:	5d                   	pop    %ebp
  800b7f:	c3                   	ret    

00800b80 <sys_yield>:

void
sys_yield(void)
{
  800b80:	f3 0f 1e fb          	endbr32 
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
  800b87:	57                   	push   %edi
  800b88:	56                   	push   %esi
  800b89:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b94:	89 d1                	mov    %edx,%ecx
  800b96:	89 d3                	mov    %edx,%ebx
  800b98:	89 d7                	mov    %edx,%edi
  800b9a:	89 d6                	mov    %edx,%esi
  800b9c:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b9e:	5b                   	pop    %ebx
  800b9f:	5e                   	pop    %esi
  800ba0:	5f                   	pop    %edi
  800ba1:	5d                   	pop    %ebp
  800ba2:	c3                   	ret    

00800ba3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ba3:	f3 0f 1e fb          	endbr32 
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	57                   	push   %edi
  800bab:	56                   	push   %esi
  800bac:	53                   	push   %ebx
  800bad:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bb0:	be 00 00 00 00       	mov    $0x0,%esi
  800bb5:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bbb:	b8 04 00 00 00       	mov    $0x4,%eax
  800bc0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bc3:	89 f7                	mov    %esi,%edi
  800bc5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bc7:	85 c0                	test   %eax,%eax
  800bc9:	7f 08                	jg     800bd3 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bcb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bce:	5b                   	pop    %ebx
  800bcf:	5e                   	pop    %esi
  800bd0:	5f                   	pop    %edi
  800bd1:	5d                   	pop    %ebp
  800bd2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bd3:	83 ec 0c             	sub    $0xc,%esp
  800bd6:	50                   	push   %eax
  800bd7:	6a 04                	push   $0x4
  800bd9:	68 3f 22 80 00       	push   $0x80223f
  800bde:	6a 23                	push   $0x23
  800be0:	68 5c 22 80 00       	push   $0x80225c
  800be5:	e8 0f 0f 00 00       	call   801af9 <_panic>

00800bea <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bea:	f3 0f 1e fb          	endbr32 
  800bee:	55                   	push   %ebp
  800bef:	89 e5                	mov    %esp,%ebp
  800bf1:	57                   	push   %edi
  800bf2:	56                   	push   %esi
  800bf3:	53                   	push   %ebx
  800bf4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bf7:	8b 55 08             	mov    0x8(%ebp),%edx
  800bfa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bfd:	b8 05 00 00 00       	mov    $0x5,%eax
  800c02:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c05:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c08:	8b 75 18             	mov    0x18(%ebp),%esi
  800c0b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c0d:	85 c0                	test   %eax,%eax
  800c0f:	7f 08                	jg     800c19 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c14:	5b                   	pop    %ebx
  800c15:	5e                   	pop    %esi
  800c16:	5f                   	pop    %edi
  800c17:	5d                   	pop    %ebp
  800c18:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c19:	83 ec 0c             	sub    $0xc,%esp
  800c1c:	50                   	push   %eax
  800c1d:	6a 05                	push   $0x5
  800c1f:	68 3f 22 80 00       	push   $0x80223f
  800c24:	6a 23                	push   $0x23
  800c26:	68 5c 22 80 00       	push   $0x80225c
  800c2b:	e8 c9 0e 00 00       	call   801af9 <_panic>

00800c30 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c30:	f3 0f 1e fb          	endbr32 
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	57                   	push   %edi
  800c38:	56                   	push   %esi
  800c39:	53                   	push   %ebx
  800c3a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c3d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c42:	8b 55 08             	mov    0x8(%ebp),%edx
  800c45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c48:	b8 06 00 00 00       	mov    $0x6,%eax
  800c4d:	89 df                	mov    %ebx,%edi
  800c4f:	89 de                	mov    %ebx,%esi
  800c51:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c53:	85 c0                	test   %eax,%eax
  800c55:	7f 08                	jg     800c5f <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c57:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c5a:	5b                   	pop    %ebx
  800c5b:	5e                   	pop    %esi
  800c5c:	5f                   	pop    %edi
  800c5d:	5d                   	pop    %ebp
  800c5e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c5f:	83 ec 0c             	sub    $0xc,%esp
  800c62:	50                   	push   %eax
  800c63:	6a 06                	push   $0x6
  800c65:	68 3f 22 80 00       	push   $0x80223f
  800c6a:	6a 23                	push   $0x23
  800c6c:	68 5c 22 80 00       	push   $0x80225c
  800c71:	e8 83 0e 00 00       	call   801af9 <_panic>

00800c76 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c76:	f3 0f 1e fb          	endbr32 
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
  800c7d:	57                   	push   %edi
  800c7e:	56                   	push   %esi
  800c7f:	53                   	push   %ebx
  800c80:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c83:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c88:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c8e:	b8 08 00 00 00       	mov    $0x8,%eax
  800c93:	89 df                	mov    %ebx,%edi
  800c95:	89 de                	mov    %ebx,%esi
  800c97:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c99:	85 c0                	test   %eax,%eax
  800c9b:	7f 08                	jg     800ca5 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca0:	5b                   	pop    %ebx
  800ca1:	5e                   	pop    %esi
  800ca2:	5f                   	pop    %edi
  800ca3:	5d                   	pop    %ebp
  800ca4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ca5:	83 ec 0c             	sub    $0xc,%esp
  800ca8:	50                   	push   %eax
  800ca9:	6a 08                	push   $0x8
  800cab:	68 3f 22 80 00       	push   $0x80223f
  800cb0:	6a 23                	push   $0x23
  800cb2:	68 5c 22 80 00       	push   $0x80225c
  800cb7:	e8 3d 0e 00 00       	call   801af9 <_panic>

00800cbc <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cbc:	f3 0f 1e fb          	endbr32 
  800cc0:	55                   	push   %ebp
  800cc1:	89 e5                	mov    %esp,%ebp
  800cc3:	57                   	push   %edi
  800cc4:	56                   	push   %esi
  800cc5:	53                   	push   %ebx
  800cc6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cc9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cce:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd4:	b8 09 00 00 00       	mov    $0x9,%eax
  800cd9:	89 df                	mov    %ebx,%edi
  800cdb:	89 de                	mov    %ebx,%esi
  800cdd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cdf:	85 c0                	test   %eax,%eax
  800ce1:	7f 08                	jg     800ceb <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ce3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce6:	5b                   	pop    %ebx
  800ce7:	5e                   	pop    %esi
  800ce8:	5f                   	pop    %edi
  800ce9:	5d                   	pop    %ebp
  800cea:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ceb:	83 ec 0c             	sub    $0xc,%esp
  800cee:	50                   	push   %eax
  800cef:	6a 09                	push   $0x9
  800cf1:	68 3f 22 80 00       	push   $0x80223f
  800cf6:	6a 23                	push   $0x23
  800cf8:	68 5c 22 80 00       	push   $0x80225c
  800cfd:	e8 f7 0d 00 00       	call   801af9 <_panic>

00800d02 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d02:	f3 0f 1e fb          	endbr32 
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	57                   	push   %edi
  800d0a:	56                   	push   %esi
  800d0b:	53                   	push   %ebx
  800d0c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d0f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d14:	8b 55 08             	mov    0x8(%ebp),%edx
  800d17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d1a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d1f:	89 df                	mov    %ebx,%edi
  800d21:	89 de                	mov    %ebx,%esi
  800d23:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d25:	85 c0                	test   %eax,%eax
  800d27:	7f 08                	jg     800d31 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2c:	5b                   	pop    %ebx
  800d2d:	5e                   	pop    %esi
  800d2e:	5f                   	pop    %edi
  800d2f:	5d                   	pop    %ebp
  800d30:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d31:	83 ec 0c             	sub    $0xc,%esp
  800d34:	50                   	push   %eax
  800d35:	6a 0a                	push   $0xa
  800d37:	68 3f 22 80 00       	push   $0x80223f
  800d3c:	6a 23                	push   $0x23
  800d3e:	68 5c 22 80 00       	push   $0x80225c
  800d43:	e8 b1 0d 00 00       	call   801af9 <_panic>

00800d48 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d48:	f3 0f 1e fb          	endbr32 
  800d4c:	55                   	push   %ebp
  800d4d:	89 e5                	mov    %esp,%ebp
  800d4f:	57                   	push   %edi
  800d50:	56                   	push   %esi
  800d51:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d52:	8b 55 08             	mov    0x8(%ebp),%edx
  800d55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d58:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d5d:	be 00 00 00 00       	mov    $0x0,%esi
  800d62:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d65:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d68:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d6a:	5b                   	pop    %ebx
  800d6b:	5e                   	pop    %esi
  800d6c:	5f                   	pop    %edi
  800d6d:	5d                   	pop    %ebp
  800d6e:	c3                   	ret    

00800d6f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d6f:	f3 0f 1e fb          	endbr32 
  800d73:	55                   	push   %ebp
  800d74:	89 e5                	mov    %esp,%ebp
  800d76:	57                   	push   %edi
  800d77:	56                   	push   %esi
  800d78:	53                   	push   %ebx
  800d79:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d7c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d81:	8b 55 08             	mov    0x8(%ebp),%edx
  800d84:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d89:	89 cb                	mov    %ecx,%ebx
  800d8b:	89 cf                	mov    %ecx,%edi
  800d8d:	89 ce                	mov    %ecx,%esi
  800d8f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d91:	85 c0                	test   %eax,%eax
  800d93:	7f 08                	jg     800d9d <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d95:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d98:	5b                   	pop    %ebx
  800d99:	5e                   	pop    %esi
  800d9a:	5f                   	pop    %edi
  800d9b:	5d                   	pop    %ebp
  800d9c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9d:	83 ec 0c             	sub    $0xc,%esp
  800da0:	50                   	push   %eax
  800da1:	6a 0d                	push   $0xd
  800da3:	68 3f 22 80 00       	push   $0x80223f
  800da8:	6a 23                	push   $0x23
  800daa:	68 5c 22 80 00       	push   $0x80225c
  800daf:	e8 45 0d 00 00       	call   801af9 <_panic>

00800db4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800db4:	f3 0f 1e fb          	endbr32 
  800db8:	55                   	push   %ebp
  800db9:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	05 00 00 00 30       	add    $0x30000000,%eax
  800dc3:	c1 e8 0c             	shr    $0xc,%eax
}
  800dc6:	5d                   	pop    %ebp
  800dc7:	c3                   	ret    

00800dc8 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800dc8:	f3 0f 1e fb          	endbr32 
  800dcc:	55                   	push   %ebp
  800dcd:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800dd7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ddc:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800de1:	5d                   	pop    %ebp
  800de2:	c3                   	ret    

00800de3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800de3:	f3 0f 1e fb          	endbr32 
  800de7:	55                   	push   %ebp
  800de8:	89 e5                	mov    %esp,%ebp
  800dea:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800def:	89 c2                	mov    %eax,%edx
  800df1:	c1 ea 16             	shr    $0x16,%edx
  800df4:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800dfb:	f6 c2 01             	test   $0x1,%dl
  800dfe:	74 2d                	je     800e2d <fd_alloc+0x4a>
  800e00:	89 c2                	mov    %eax,%edx
  800e02:	c1 ea 0c             	shr    $0xc,%edx
  800e05:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e0c:	f6 c2 01             	test   $0x1,%dl
  800e0f:	74 1c                	je     800e2d <fd_alloc+0x4a>
  800e11:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800e16:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e1b:	75 d2                	jne    800def <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800e26:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800e2b:	eb 0a                	jmp    800e37 <fd_alloc+0x54>
			*fd_store = fd;
  800e2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e30:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e37:	5d                   	pop    %ebp
  800e38:	c3                   	ret    

00800e39 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800e39:	f3 0f 1e fb          	endbr32 
  800e3d:	55                   	push   %ebp
  800e3e:	89 e5                	mov    %esp,%ebp
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800e43:	83 f8 1f             	cmp    $0x1f,%eax
  800e46:	77 30                	ja     800e78 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800e48:	c1 e0 0c             	shl    $0xc,%eax
  800e4b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800e50:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800e56:	f6 c2 01             	test   $0x1,%dl
  800e59:	74 24                	je     800e7f <fd_lookup+0x46>
  800e5b:	89 c2                	mov    %eax,%edx
  800e5d:	c1 ea 0c             	shr    $0xc,%edx
  800e60:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e67:	f6 c2 01             	test   $0x1,%dl
  800e6a:	74 1a                	je     800e86 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800e6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e6f:	89 02                	mov    %eax,(%edx)
	return 0;
  800e71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e76:	5d                   	pop    %ebp
  800e77:	c3                   	ret    
		return -E_INVAL;
  800e78:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e7d:	eb f7                	jmp    800e76 <fd_lookup+0x3d>
		return -E_INVAL;
  800e7f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e84:	eb f0                	jmp    800e76 <fd_lookup+0x3d>
  800e86:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e8b:	eb e9                	jmp    800e76 <fd_lookup+0x3d>

00800e8d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800e8d:	f3 0f 1e fb          	endbr32 
  800e91:	55                   	push   %ebp
  800e92:	89 e5                	mov    %esp,%ebp
  800e94:	83 ec 08             	sub    $0x8,%esp
  800e97:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e9a:	ba e8 22 80 00       	mov    $0x8022e8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800e9f:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800ea4:	39 08                	cmp    %ecx,(%eax)
  800ea6:	74 33                	je     800edb <dev_lookup+0x4e>
  800ea8:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800eab:	8b 02                	mov    (%edx),%eax
  800ead:	85 c0                	test   %eax,%eax
  800eaf:	75 f3                	jne    800ea4 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800eb1:	a1 04 40 80 00       	mov    0x804004,%eax
  800eb6:	8b 40 48             	mov    0x48(%eax),%eax
  800eb9:	83 ec 04             	sub    $0x4,%esp
  800ebc:	51                   	push   %ecx
  800ebd:	50                   	push   %eax
  800ebe:	68 6c 22 80 00       	push   $0x80226c
  800ec3:	e8 8f f2 ff ff       	call   800157 <cprintf>
	*dev = 0;
  800ec8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800ed1:	83 c4 10             	add    $0x10,%esp
  800ed4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800ed9:	c9                   	leave  
  800eda:	c3                   	ret    
			*dev = devtab[i];
  800edb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ede:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ee0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee5:	eb f2                	jmp    800ed9 <dev_lookup+0x4c>

00800ee7 <fd_close>:
{
  800ee7:	f3 0f 1e fb          	endbr32 
  800eeb:	55                   	push   %ebp
  800eec:	89 e5                	mov    %esp,%ebp
  800eee:	57                   	push   %edi
  800eef:	56                   	push   %esi
  800ef0:	53                   	push   %ebx
  800ef1:	83 ec 24             	sub    $0x24,%esp
  800ef4:	8b 75 08             	mov    0x8(%ebp),%esi
  800ef7:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800efa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800efd:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800efe:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800f04:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f07:	50                   	push   %eax
  800f08:	e8 2c ff ff ff       	call   800e39 <fd_lookup>
  800f0d:	89 c3                	mov    %eax,%ebx
  800f0f:	83 c4 10             	add    $0x10,%esp
  800f12:	85 c0                	test   %eax,%eax
  800f14:	78 05                	js     800f1b <fd_close+0x34>
	    || fd != fd2)
  800f16:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800f19:	74 16                	je     800f31 <fd_close+0x4a>
		return (must_exist ? r : 0);
  800f1b:	89 f8                	mov    %edi,%eax
  800f1d:	84 c0                	test   %al,%al
  800f1f:	b8 00 00 00 00       	mov    $0x0,%eax
  800f24:	0f 44 d8             	cmove  %eax,%ebx
}
  800f27:	89 d8                	mov    %ebx,%eax
  800f29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f2c:	5b                   	pop    %ebx
  800f2d:	5e                   	pop    %esi
  800f2e:	5f                   	pop    %edi
  800f2f:	5d                   	pop    %ebp
  800f30:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800f31:	83 ec 08             	sub    $0x8,%esp
  800f34:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800f37:	50                   	push   %eax
  800f38:	ff 36                	pushl  (%esi)
  800f3a:	e8 4e ff ff ff       	call   800e8d <dev_lookup>
  800f3f:	89 c3                	mov    %eax,%ebx
  800f41:	83 c4 10             	add    $0x10,%esp
  800f44:	85 c0                	test   %eax,%eax
  800f46:	78 1a                	js     800f62 <fd_close+0x7b>
		if (dev->dev_close)
  800f48:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f4b:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800f4e:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800f53:	85 c0                	test   %eax,%eax
  800f55:	74 0b                	je     800f62 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  800f57:	83 ec 0c             	sub    $0xc,%esp
  800f5a:	56                   	push   %esi
  800f5b:	ff d0                	call   *%eax
  800f5d:	89 c3                	mov    %eax,%ebx
  800f5f:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800f62:	83 ec 08             	sub    $0x8,%esp
  800f65:	56                   	push   %esi
  800f66:	6a 00                	push   $0x0
  800f68:	e8 c3 fc ff ff       	call   800c30 <sys_page_unmap>
	return r;
  800f6d:	83 c4 10             	add    $0x10,%esp
  800f70:	eb b5                	jmp    800f27 <fd_close+0x40>

00800f72 <close>:

int
close(int fdnum)
{
  800f72:	f3 0f 1e fb          	endbr32 
  800f76:	55                   	push   %ebp
  800f77:	89 e5                	mov    %esp,%ebp
  800f79:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f7c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f7f:	50                   	push   %eax
  800f80:	ff 75 08             	pushl  0x8(%ebp)
  800f83:	e8 b1 fe ff ff       	call   800e39 <fd_lookup>
  800f88:	83 c4 10             	add    $0x10,%esp
  800f8b:	85 c0                	test   %eax,%eax
  800f8d:	79 02                	jns    800f91 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  800f8f:	c9                   	leave  
  800f90:	c3                   	ret    
		return fd_close(fd, 1);
  800f91:	83 ec 08             	sub    $0x8,%esp
  800f94:	6a 01                	push   $0x1
  800f96:	ff 75 f4             	pushl  -0xc(%ebp)
  800f99:	e8 49 ff ff ff       	call   800ee7 <fd_close>
  800f9e:	83 c4 10             	add    $0x10,%esp
  800fa1:	eb ec                	jmp    800f8f <close+0x1d>

00800fa3 <close_all>:

void
close_all(void)
{
  800fa3:	f3 0f 1e fb          	endbr32 
  800fa7:	55                   	push   %ebp
  800fa8:	89 e5                	mov    %esp,%ebp
  800faa:	53                   	push   %ebx
  800fab:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800fae:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800fb3:	83 ec 0c             	sub    $0xc,%esp
  800fb6:	53                   	push   %ebx
  800fb7:	e8 b6 ff ff ff       	call   800f72 <close>
	for (i = 0; i < MAXFD; i++)
  800fbc:	83 c3 01             	add    $0x1,%ebx
  800fbf:	83 c4 10             	add    $0x10,%esp
  800fc2:	83 fb 20             	cmp    $0x20,%ebx
  800fc5:	75 ec                	jne    800fb3 <close_all+0x10>
}
  800fc7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fca:	c9                   	leave  
  800fcb:	c3                   	ret    

00800fcc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800fcc:	f3 0f 1e fb          	endbr32 
  800fd0:	55                   	push   %ebp
  800fd1:	89 e5                	mov    %esp,%ebp
  800fd3:	57                   	push   %edi
  800fd4:	56                   	push   %esi
  800fd5:	53                   	push   %ebx
  800fd6:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800fd9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800fdc:	50                   	push   %eax
  800fdd:	ff 75 08             	pushl  0x8(%ebp)
  800fe0:	e8 54 fe ff ff       	call   800e39 <fd_lookup>
  800fe5:	89 c3                	mov    %eax,%ebx
  800fe7:	83 c4 10             	add    $0x10,%esp
  800fea:	85 c0                	test   %eax,%eax
  800fec:	0f 88 81 00 00 00    	js     801073 <dup+0xa7>
		return r;
	close(newfdnum);
  800ff2:	83 ec 0c             	sub    $0xc,%esp
  800ff5:	ff 75 0c             	pushl  0xc(%ebp)
  800ff8:	e8 75 ff ff ff       	call   800f72 <close>

	newfd = INDEX2FD(newfdnum);
  800ffd:	8b 75 0c             	mov    0xc(%ebp),%esi
  801000:	c1 e6 0c             	shl    $0xc,%esi
  801003:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801009:	83 c4 04             	add    $0x4,%esp
  80100c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80100f:	e8 b4 fd ff ff       	call   800dc8 <fd2data>
  801014:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801016:	89 34 24             	mov    %esi,(%esp)
  801019:	e8 aa fd ff ff       	call   800dc8 <fd2data>
  80101e:	83 c4 10             	add    $0x10,%esp
  801021:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801023:	89 d8                	mov    %ebx,%eax
  801025:	c1 e8 16             	shr    $0x16,%eax
  801028:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80102f:	a8 01                	test   $0x1,%al
  801031:	74 11                	je     801044 <dup+0x78>
  801033:	89 d8                	mov    %ebx,%eax
  801035:	c1 e8 0c             	shr    $0xc,%eax
  801038:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80103f:	f6 c2 01             	test   $0x1,%dl
  801042:	75 39                	jne    80107d <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801044:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801047:	89 d0                	mov    %edx,%eax
  801049:	c1 e8 0c             	shr    $0xc,%eax
  80104c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801053:	83 ec 0c             	sub    $0xc,%esp
  801056:	25 07 0e 00 00       	and    $0xe07,%eax
  80105b:	50                   	push   %eax
  80105c:	56                   	push   %esi
  80105d:	6a 00                	push   $0x0
  80105f:	52                   	push   %edx
  801060:	6a 00                	push   $0x0
  801062:	e8 83 fb ff ff       	call   800bea <sys_page_map>
  801067:	89 c3                	mov    %eax,%ebx
  801069:	83 c4 20             	add    $0x20,%esp
  80106c:	85 c0                	test   %eax,%eax
  80106e:	78 31                	js     8010a1 <dup+0xd5>
		goto err;

	return newfdnum;
  801070:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801073:	89 d8                	mov    %ebx,%eax
  801075:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801078:	5b                   	pop    %ebx
  801079:	5e                   	pop    %esi
  80107a:	5f                   	pop    %edi
  80107b:	5d                   	pop    %ebp
  80107c:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80107d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801084:	83 ec 0c             	sub    $0xc,%esp
  801087:	25 07 0e 00 00       	and    $0xe07,%eax
  80108c:	50                   	push   %eax
  80108d:	57                   	push   %edi
  80108e:	6a 00                	push   $0x0
  801090:	53                   	push   %ebx
  801091:	6a 00                	push   $0x0
  801093:	e8 52 fb ff ff       	call   800bea <sys_page_map>
  801098:	89 c3                	mov    %eax,%ebx
  80109a:	83 c4 20             	add    $0x20,%esp
  80109d:	85 c0                	test   %eax,%eax
  80109f:	79 a3                	jns    801044 <dup+0x78>
	sys_page_unmap(0, newfd);
  8010a1:	83 ec 08             	sub    $0x8,%esp
  8010a4:	56                   	push   %esi
  8010a5:	6a 00                	push   $0x0
  8010a7:	e8 84 fb ff ff       	call   800c30 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8010ac:	83 c4 08             	add    $0x8,%esp
  8010af:	57                   	push   %edi
  8010b0:	6a 00                	push   $0x0
  8010b2:	e8 79 fb ff ff       	call   800c30 <sys_page_unmap>
	return r;
  8010b7:	83 c4 10             	add    $0x10,%esp
  8010ba:	eb b7                	jmp    801073 <dup+0xa7>

008010bc <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8010bc:	f3 0f 1e fb          	endbr32 
  8010c0:	55                   	push   %ebp
  8010c1:	89 e5                	mov    %esp,%ebp
  8010c3:	53                   	push   %ebx
  8010c4:	83 ec 1c             	sub    $0x1c,%esp
  8010c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010ca:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010cd:	50                   	push   %eax
  8010ce:	53                   	push   %ebx
  8010cf:	e8 65 fd ff ff       	call   800e39 <fd_lookup>
  8010d4:	83 c4 10             	add    $0x10,%esp
  8010d7:	85 c0                	test   %eax,%eax
  8010d9:	78 3f                	js     80111a <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010db:	83 ec 08             	sub    $0x8,%esp
  8010de:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010e1:	50                   	push   %eax
  8010e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010e5:	ff 30                	pushl  (%eax)
  8010e7:	e8 a1 fd ff ff       	call   800e8d <dev_lookup>
  8010ec:	83 c4 10             	add    $0x10,%esp
  8010ef:	85 c0                	test   %eax,%eax
  8010f1:	78 27                	js     80111a <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8010f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010f6:	8b 42 08             	mov    0x8(%edx),%eax
  8010f9:	83 e0 03             	and    $0x3,%eax
  8010fc:	83 f8 01             	cmp    $0x1,%eax
  8010ff:	74 1e                	je     80111f <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801101:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801104:	8b 40 08             	mov    0x8(%eax),%eax
  801107:	85 c0                	test   %eax,%eax
  801109:	74 35                	je     801140 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80110b:	83 ec 04             	sub    $0x4,%esp
  80110e:	ff 75 10             	pushl  0x10(%ebp)
  801111:	ff 75 0c             	pushl  0xc(%ebp)
  801114:	52                   	push   %edx
  801115:	ff d0                	call   *%eax
  801117:	83 c4 10             	add    $0x10,%esp
}
  80111a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80111d:	c9                   	leave  
  80111e:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80111f:	a1 04 40 80 00       	mov    0x804004,%eax
  801124:	8b 40 48             	mov    0x48(%eax),%eax
  801127:	83 ec 04             	sub    $0x4,%esp
  80112a:	53                   	push   %ebx
  80112b:	50                   	push   %eax
  80112c:	68 ad 22 80 00       	push   $0x8022ad
  801131:	e8 21 f0 ff ff       	call   800157 <cprintf>
		return -E_INVAL;
  801136:	83 c4 10             	add    $0x10,%esp
  801139:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80113e:	eb da                	jmp    80111a <read+0x5e>
		return -E_NOT_SUPP;
  801140:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801145:	eb d3                	jmp    80111a <read+0x5e>

00801147 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801147:	f3 0f 1e fb          	endbr32 
  80114b:	55                   	push   %ebp
  80114c:	89 e5                	mov    %esp,%ebp
  80114e:	57                   	push   %edi
  80114f:	56                   	push   %esi
  801150:	53                   	push   %ebx
  801151:	83 ec 0c             	sub    $0xc,%esp
  801154:	8b 7d 08             	mov    0x8(%ebp),%edi
  801157:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80115a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80115f:	eb 02                	jmp    801163 <readn+0x1c>
  801161:	01 c3                	add    %eax,%ebx
  801163:	39 f3                	cmp    %esi,%ebx
  801165:	73 21                	jae    801188 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801167:	83 ec 04             	sub    $0x4,%esp
  80116a:	89 f0                	mov    %esi,%eax
  80116c:	29 d8                	sub    %ebx,%eax
  80116e:	50                   	push   %eax
  80116f:	89 d8                	mov    %ebx,%eax
  801171:	03 45 0c             	add    0xc(%ebp),%eax
  801174:	50                   	push   %eax
  801175:	57                   	push   %edi
  801176:	e8 41 ff ff ff       	call   8010bc <read>
		if (m < 0)
  80117b:	83 c4 10             	add    $0x10,%esp
  80117e:	85 c0                	test   %eax,%eax
  801180:	78 04                	js     801186 <readn+0x3f>
			return m;
		if (m == 0)
  801182:	75 dd                	jne    801161 <readn+0x1a>
  801184:	eb 02                	jmp    801188 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801186:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801188:	89 d8                	mov    %ebx,%eax
  80118a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80118d:	5b                   	pop    %ebx
  80118e:	5e                   	pop    %esi
  80118f:	5f                   	pop    %edi
  801190:	5d                   	pop    %ebp
  801191:	c3                   	ret    

00801192 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801192:	f3 0f 1e fb          	endbr32 
  801196:	55                   	push   %ebp
  801197:	89 e5                	mov    %esp,%ebp
  801199:	53                   	push   %ebx
  80119a:	83 ec 1c             	sub    $0x1c,%esp
  80119d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011a3:	50                   	push   %eax
  8011a4:	53                   	push   %ebx
  8011a5:	e8 8f fc ff ff       	call   800e39 <fd_lookup>
  8011aa:	83 c4 10             	add    $0x10,%esp
  8011ad:	85 c0                	test   %eax,%eax
  8011af:	78 3a                	js     8011eb <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011b1:	83 ec 08             	sub    $0x8,%esp
  8011b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011b7:	50                   	push   %eax
  8011b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011bb:	ff 30                	pushl  (%eax)
  8011bd:	e8 cb fc ff ff       	call   800e8d <dev_lookup>
  8011c2:	83 c4 10             	add    $0x10,%esp
  8011c5:	85 c0                	test   %eax,%eax
  8011c7:	78 22                	js     8011eb <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8011c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011cc:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8011d0:	74 1e                	je     8011f0 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8011d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011d5:	8b 52 0c             	mov    0xc(%edx),%edx
  8011d8:	85 d2                	test   %edx,%edx
  8011da:	74 35                	je     801211 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8011dc:	83 ec 04             	sub    $0x4,%esp
  8011df:	ff 75 10             	pushl  0x10(%ebp)
  8011e2:	ff 75 0c             	pushl  0xc(%ebp)
  8011e5:	50                   	push   %eax
  8011e6:	ff d2                	call   *%edx
  8011e8:	83 c4 10             	add    $0x10,%esp
}
  8011eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011ee:	c9                   	leave  
  8011ef:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8011f0:	a1 04 40 80 00       	mov    0x804004,%eax
  8011f5:	8b 40 48             	mov    0x48(%eax),%eax
  8011f8:	83 ec 04             	sub    $0x4,%esp
  8011fb:	53                   	push   %ebx
  8011fc:	50                   	push   %eax
  8011fd:	68 c9 22 80 00       	push   $0x8022c9
  801202:	e8 50 ef ff ff       	call   800157 <cprintf>
		return -E_INVAL;
  801207:	83 c4 10             	add    $0x10,%esp
  80120a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80120f:	eb da                	jmp    8011eb <write+0x59>
		return -E_NOT_SUPP;
  801211:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801216:	eb d3                	jmp    8011eb <write+0x59>

00801218 <seek>:

int
seek(int fdnum, off_t offset)
{
  801218:	f3 0f 1e fb          	endbr32 
  80121c:	55                   	push   %ebp
  80121d:	89 e5                	mov    %esp,%ebp
  80121f:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801222:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801225:	50                   	push   %eax
  801226:	ff 75 08             	pushl  0x8(%ebp)
  801229:	e8 0b fc ff ff       	call   800e39 <fd_lookup>
  80122e:	83 c4 10             	add    $0x10,%esp
  801231:	85 c0                	test   %eax,%eax
  801233:	78 0e                	js     801243 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801235:	8b 55 0c             	mov    0xc(%ebp),%edx
  801238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80123b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80123e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801243:	c9                   	leave  
  801244:	c3                   	ret    

00801245 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801245:	f3 0f 1e fb          	endbr32 
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
  80124c:	53                   	push   %ebx
  80124d:	83 ec 1c             	sub    $0x1c,%esp
  801250:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801253:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801256:	50                   	push   %eax
  801257:	53                   	push   %ebx
  801258:	e8 dc fb ff ff       	call   800e39 <fd_lookup>
  80125d:	83 c4 10             	add    $0x10,%esp
  801260:	85 c0                	test   %eax,%eax
  801262:	78 37                	js     80129b <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801264:	83 ec 08             	sub    $0x8,%esp
  801267:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80126a:	50                   	push   %eax
  80126b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80126e:	ff 30                	pushl  (%eax)
  801270:	e8 18 fc ff ff       	call   800e8d <dev_lookup>
  801275:	83 c4 10             	add    $0x10,%esp
  801278:	85 c0                	test   %eax,%eax
  80127a:	78 1f                	js     80129b <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80127c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80127f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801283:	74 1b                	je     8012a0 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801285:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801288:	8b 52 18             	mov    0x18(%edx),%edx
  80128b:	85 d2                	test   %edx,%edx
  80128d:	74 32                	je     8012c1 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80128f:	83 ec 08             	sub    $0x8,%esp
  801292:	ff 75 0c             	pushl  0xc(%ebp)
  801295:	50                   	push   %eax
  801296:	ff d2                	call   *%edx
  801298:	83 c4 10             	add    $0x10,%esp
}
  80129b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80129e:	c9                   	leave  
  80129f:	c3                   	ret    
			thisenv->env_id, fdnum);
  8012a0:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8012a5:	8b 40 48             	mov    0x48(%eax),%eax
  8012a8:	83 ec 04             	sub    $0x4,%esp
  8012ab:	53                   	push   %ebx
  8012ac:	50                   	push   %eax
  8012ad:	68 8c 22 80 00       	push   $0x80228c
  8012b2:	e8 a0 ee ff ff       	call   800157 <cprintf>
		return -E_INVAL;
  8012b7:	83 c4 10             	add    $0x10,%esp
  8012ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012bf:	eb da                	jmp    80129b <ftruncate+0x56>
		return -E_NOT_SUPP;
  8012c1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012c6:	eb d3                	jmp    80129b <ftruncate+0x56>

008012c8 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8012c8:	f3 0f 1e fb          	endbr32 
  8012cc:	55                   	push   %ebp
  8012cd:	89 e5                	mov    %esp,%ebp
  8012cf:	53                   	push   %ebx
  8012d0:	83 ec 1c             	sub    $0x1c,%esp
  8012d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012d9:	50                   	push   %eax
  8012da:	ff 75 08             	pushl  0x8(%ebp)
  8012dd:	e8 57 fb ff ff       	call   800e39 <fd_lookup>
  8012e2:	83 c4 10             	add    $0x10,%esp
  8012e5:	85 c0                	test   %eax,%eax
  8012e7:	78 4b                	js     801334 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012e9:	83 ec 08             	sub    $0x8,%esp
  8012ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012ef:	50                   	push   %eax
  8012f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012f3:	ff 30                	pushl  (%eax)
  8012f5:	e8 93 fb ff ff       	call   800e8d <dev_lookup>
  8012fa:	83 c4 10             	add    $0x10,%esp
  8012fd:	85 c0                	test   %eax,%eax
  8012ff:	78 33                	js     801334 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801301:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801304:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801308:	74 2f                	je     801339 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80130a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80130d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801314:	00 00 00 
	stat->st_isdir = 0;
  801317:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80131e:	00 00 00 
	stat->st_dev = dev;
  801321:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801327:	83 ec 08             	sub    $0x8,%esp
  80132a:	53                   	push   %ebx
  80132b:	ff 75 f0             	pushl  -0x10(%ebp)
  80132e:	ff 50 14             	call   *0x14(%eax)
  801331:	83 c4 10             	add    $0x10,%esp
}
  801334:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801337:	c9                   	leave  
  801338:	c3                   	ret    
		return -E_NOT_SUPP;
  801339:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80133e:	eb f4                	jmp    801334 <fstat+0x6c>

00801340 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801340:	f3 0f 1e fb          	endbr32 
  801344:	55                   	push   %ebp
  801345:	89 e5                	mov    %esp,%ebp
  801347:	56                   	push   %esi
  801348:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801349:	83 ec 08             	sub    $0x8,%esp
  80134c:	6a 00                	push   $0x0
  80134e:	ff 75 08             	pushl  0x8(%ebp)
  801351:	e8 fb 01 00 00       	call   801551 <open>
  801356:	89 c3                	mov    %eax,%ebx
  801358:	83 c4 10             	add    $0x10,%esp
  80135b:	85 c0                	test   %eax,%eax
  80135d:	78 1b                	js     80137a <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80135f:	83 ec 08             	sub    $0x8,%esp
  801362:	ff 75 0c             	pushl  0xc(%ebp)
  801365:	50                   	push   %eax
  801366:	e8 5d ff ff ff       	call   8012c8 <fstat>
  80136b:	89 c6                	mov    %eax,%esi
	close(fd);
  80136d:	89 1c 24             	mov    %ebx,(%esp)
  801370:	e8 fd fb ff ff       	call   800f72 <close>
	return r;
  801375:	83 c4 10             	add    $0x10,%esp
  801378:	89 f3                	mov    %esi,%ebx
}
  80137a:	89 d8                	mov    %ebx,%eax
  80137c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80137f:	5b                   	pop    %ebx
  801380:	5e                   	pop    %esi
  801381:	5d                   	pop    %ebp
  801382:	c3                   	ret    

00801383 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801383:	55                   	push   %ebp
  801384:	89 e5                	mov    %esp,%ebp
  801386:	56                   	push   %esi
  801387:	53                   	push   %ebx
  801388:	89 c6                	mov    %eax,%esi
  80138a:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80138c:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801393:	74 27                	je     8013bc <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801395:	6a 07                	push   $0x7
  801397:	68 00 50 80 00       	push   $0x805000
  80139c:	56                   	push   %esi
  80139d:	ff 35 00 40 80 00    	pushl  0x804000
  8013a3:	e8 20 08 00 00       	call   801bc8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8013a8:	83 c4 0c             	add    $0xc,%esp
  8013ab:	6a 00                	push   $0x0
  8013ad:	53                   	push   %ebx
  8013ae:	6a 00                	push   $0x0
  8013b0:	e8 8e 07 00 00       	call   801b43 <ipc_recv>
}
  8013b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013b8:	5b                   	pop    %ebx
  8013b9:	5e                   	pop    %esi
  8013ba:	5d                   	pop    %ebp
  8013bb:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8013bc:	83 ec 0c             	sub    $0xc,%esp
  8013bf:	6a 01                	push   $0x1
  8013c1:	e8 5a 08 00 00       	call   801c20 <ipc_find_env>
  8013c6:	a3 00 40 80 00       	mov    %eax,0x804000
  8013cb:	83 c4 10             	add    $0x10,%esp
  8013ce:	eb c5                	jmp    801395 <fsipc+0x12>

008013d0 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8013d0:	f3 0f 1e fb          	endbr32 
  8013d4:	55                   	push   %ebp
  8013d5:	89 e5                	mov    %esp,%ebp
  8013d7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8013da:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8013e0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8013e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e8:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8013ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8013f2:	b8 02 00 00 00       	mov    $0x2,%eax
  8013f7:	e8 87 ff ff ff       	call   801383 <fsipc>
}
  8013fc:	c9                   	leave  
  8013fd:	c3                   	ret    

008013fe <devfile_flush>:
{
  8013fe:	f3 0f 1e fb          	endbr32 
  801402:	55                   	push   %ebp
  801403:	89 e5                	mov    %esp,%ebp
  801405:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801408:	8b 45 08             	mov    0x8(%ebp),%eax
  80140b:	8b 40 0c             	mov    0xc(%eax),%eax
  80140e:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801413:	ba 00 00 00 00       	mov    $0x0,%edx
  801418:	b8 06 00 00 00       	mov    $0x6,%eax
  80141d:	e8 61 ff ff ff       	call   801383 <fsipc>
}
  801422:	c9                   	leave  
  801423:	c3                   	ret    

00801424 <devfile_stat>:
{
  801424:	f3 0f 1e fb          	endbr32 
  801428:	55                   	push   %ebp
  801429:	89 e5                	mov    %esp,%ebp
  80142b:	53                   	push   %ebx
  80142c:	83 ec 04             	sub    $0x4,%esp
  80142f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801432:	8b 45 08             	mov    0x8(%ebp),%eax
  801435:	8b 40 0c             	mov    0xc(%eax),%eax
  801438:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80143d:	ba 00 00 00 00       	mov    $0x0,%edx
  801442:	b8 05 00 00 00       	mov    $0x5,%eax
  801447:	e8 37 ff ff ff       	call   801383 <fsipc>
  80144c:	85 c0                	test   %eax,%eax
  80144e:	78 2c                	js     80147c <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801450:	83 ec 08             	sub    $0x8,%esp
  801453:	68 00 50 80 00       	push   $0x805000
  801458:	53                   	push   %ebx
  801459:	e8 03 f3 ff ff       	call   800761 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80145e:	a1 80 50 80 00       	mov    0x805080,%eax
  801463:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801469:	a1 84 50 80 00       	mov    0x805084,%eax
  80146e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801474:	83 c4 10             	add    $0x10,%esp
  801477:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80147c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80147f:	c9                   	leave  
  801480:	c3                   	ret    

00801481 <devfile_write>:
{
  801481:	f3 0f 1e fb          	endbr32 
  801485:	55                   	push   %ebp
  801486:	89 e5                	mov    %esp,%ebp
  801488:	83 ec 0c             	sub    $0xc,%esp
  80148b:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80148e:	8b 55 08             	mov    0x8(%ebp),%edx
  801491:	8b 52 0c             	mov    0xc(%edx),%edx
  801494:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  80149a:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80149f:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8014a4:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  8014a7:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  8014ac:	50                   	push   %eax
  8014ad:	ff 75 0c             	pushl  0xc(%ebp)
  8014b0:	68 08 50 80 00       	push   $0x805008
  8014b5:	e8 5d f4 ff ff       	call   800917 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  8014ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8014bf:	b8 04 00 00 00       	mov    $0x4,%eax
  8014c4:	e8 ba fe ff ff       	call   801383 <fsipc>
}
  8014c9:	c9                   	leave  
  8014ca:	c3                   	ret    

008014cb <devfile_read>:
{
  8014cb:	f3 0f 1e fb          	endbr32 
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
  8014d2:	56                   	push   %esi
  8014d3:	53                   	push   %ebx
  8014d4:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8014d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014da:	8b 40 0c             	mov    0xc(%eax),%eax
  8014dd:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8014e2:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8014e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ed:	b8 03 00 00 00       	mov    $0x3,%eax
  8014f2:	e8 8c fe ff ff       	call   801383 <fsipc>
  8014f7:	89 c3                	mov    %eax,%ebx
  8014f9:	85 c0                	test   %eax,%eax
  8014fb:	78 1f                	js     80151c <devfile_read+0x51>
	assert(r <= n);
  8014fd:	39 f0                	cmp    %esi,%eax
  8014ff:	77 24                	ja     801525 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801501:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801506:	7f 33                	jg     80153b <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801508:	83 ec 04             	sub    $0x4,%esp
  80150b:	50                   	push   %eax
  80150c:	68 00 50 80 00       	push   $0x805000
  801511:	ff 75 0c             	pushl  0xc(%ebp)
  801514:	e8 fe f3 ff ff       	call   800917 <memmove>
	return r;
  801519:	83 c4 10             	add    $0x10,%esp
}
  80151c:	89 d8                	mov    %ebx,%eax
  80151e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801521:	5b                   	pop    %ebx
  801522:	5e                   	pop    %esi
  801523:	5d                   	pop    %ebp
  801524:	c3                   	ret    
	assert(r <= n);
  801525:	68 f8 22 80 00       	push   $0x8022f8
  80152a:	68 ff 22 80 00       	push   $0x8022ff
  80152f:	6a 7c                	push   $0x7c
  801531:	68 14 23 80 00       	push   $0x802314
  801536:	e8 be 05 00 00       	call   801af9 <_panic>
	assert(r <= PGSIZE);
  80153b:	68 1f 23 80 00       	push   $0x80231f
  801540:	68 ff 22 80 00       	push   $0x8022ff
  801545:	6a 7d                	push   $0x7d
  801547:	68 14 23 80 00       	push   $0x802314
  80154c:	e8 a8 05 00 00       	call   801af9 <_panic>

00801551 <open>:
{
  801551:	f3 0f 1e fb          	endbr32 
  801555:	55                   	push   %ebp
  801556:	89 e5                	mov    %esp,%ebp
  801558:	56                   	push   %esi
  801559:	53                   	push   %ebx
  80155a:	83 ec 1c             	sub    $0x1c,%esp
  80155d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801560:	56                   	push   %esi
  801561:	e8 b8 f1 ff ff       	call   80071e <strlen>
  801566:	83 c4 10             	add    $0x10,%esp
  801569:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80156e:	7f 6c                	jg     8015dc <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801570:	83 ec 0c             	sub    $0xc,%esp
  801573:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801576:	50                   	push   %eax
  801577:	e8 67 f8 ff ff       	call   800de3 <fd_alloc>
  80157c:	89 c3                	mov    %eax,%ebx
  80157e:	83 c4 10             	add    $0x10,%esp
  801581:	85 c0                	test   %eax,%eax
  801583:	78 3c                	js     8015c1 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801585:	83 ec 08             	sub    $0x8,%esp
  801588:	56                   	push   %esi
  801589:	68 00 50 80 00       	push   $0x805000
  80158e:	e8 ce f1 ff ff       	call   800761 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801593:	8b 45 0c             	mov    0xc(%ebp),%eax
  801596:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80159b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80159e:	b8 01 00 00 00       	mov    $0x1,%eax
  8015a3:	e8 db fd ff ff       	call   801383 <fsipc>
  8015a8:	89 c3                	mov    %eax,%ebx
  8015aa:	83 c4 10             	add    $0x10,%esp
  8015ad:	85 c0                	test   %eax,%eax
  8015af:	78 19                	js     8015ca <open+0x79>
	return fd2num(fd);
  8015b1:	83 ec 0c             	sub    $0xc,%esp
  8015b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8015b7:	e8 f8 f7 ff ff       	call   800db4 <fd2num>
  8015bc:	89 c3                	mov    %eax,%ebx
  8015be:	83 c4 10             	add    $0x10,%esp
}
  8015c1:	89 d8                	mov    %ebx,%eax
  8015c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015c6:	5b                   	pop    %ebx
  8015c7:	5e                   	pop    %esi
  8015c8:	5d                   	pop    %ebp
  8015c9:	c3                   	ret    
		fd_close(fd, 0);
  8015ca:	83 ec 08             	sub    $0x8,%esp
  8015cd:	6a 00                	push   $0x0
  8015cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8015d2:	e8 10 f9 ff ff       	call   800ee7 <fd_close>
		return r;
  8015d7:	83 c4 10             	add    $0x10,%esp
  8015da:	eb e5                	jmp    8015c1 <open+0x70>
		return -E_BAD_PATH;
  8015dc:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8015e1:	eb de                	jmp    8015c1 <open+0x70>

008015e3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8015e3:	f3 0f 1e fb          	endbr32 
  8015e7:	55                   	push   %ebp
  8015e8:	89 e5                	mov    %esp,%ebp
  8015ea:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8015ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f2:	b8 08 00 00 00       	mov    $0x8,%eax
  8015f7:	e8 87 fd ff ff       	call   801383 <fsipc>
}
  8015fc:	c9                   	leave  
  8015fd:	c3                   	ret    

008015fe <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8015fe:	f3 0f 1e fb          	endbr32 
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
  801605:	56                   	push   %esi
  801606:	53                   	push   %ebx
  801607:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80160a:	83 ec 0c             	sub    $0xc,%esp
  80160d:	ff 75 08             	pushl  0x8(%ebp)
  801610:	e8 b3 f7 ff ff       	call   800dc8 <fd2data>
  801615:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801617:	83 c4 08             	add    $0x8,%esp
  80161a:	68 2b 23 80 00       	push   $0x80232b
  80161f:	53                   	push   %ebx
  801620:	e8 3c f1 ff ff       	call   800761 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801625:	8b 46 04             	mov    0x4(%esi),%eax
  801628:	2b 06                	sub    (%esi),%eax
  80162a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801630:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801637:	00 00 00 
	stat->st_dev = &devpipe;
  80163a:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801641:	30 80 00 
	return 0;
}
  801644:	b8 00 00 00 00       	mov    $0x0,%eax
  801649:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80164c:	5b                   	pop    %ebx
  80164d:	5e                   	pop    %esi
  80164e:	5d                   	pop    %ebp
  80164f:	c3                   	ret    

00801650 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801650:	f3 0f 1e fb          	endbr32 
  801654:	55                   	push   %ebp
  801655:	89 e5                	mov    %esp,%ebp
  801657:	53                   	push   %ebx
  801658:	83 ec 0c             	sub    $0xc,%esp
  80165b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80165e:	53                   	push   %ebx
  80165f:	6a 00                	push   $0x0
  801661:	e8 ca f5 ff ff       	call   800c30 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801666:	89 1c 24             	mov    %ebx,(%esp)
  801669:	e8 5a f7 ff ff       	call   800dc8 <fd2data>
  80166e:	83 c4 08             	add    $0x8,%esp
  801671:	50                   	push   %eax
  801672:	6a 00                	push   $0x0
  801674:	e8 b7 f5 ff ff       	call   800c30 <sys_page_unmap>
}
  801679:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80167c:	c9                   	leave  
  80167d:	c3                   	ret    

0080167e <_pipeisclosed>:
{
  80167e:	55                   	push   %ebp
  80167f:	89 e5                	mov    %esp,%ebp
  801681:	57                   	push   %edi
  801682:	56                   	push   %esi
  801683:	53                   	push   %ebx
  801684:	83 ec 1c             	sub    $0x1c,%esp
  801687:	89 c7                	mov    %eax,%edi
  801689:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80168b:	a1 04 40 80 00       	mov    0x804004,%eax
  801690:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801693:	83 ec 0c             	sub    $0xc,%esp
  801696:	57                   	push   %edi
  801697:	e8 c1 05 00 00       	call   801c5d <pageref>
  80169c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80169f:	89 34 24             	mov    %esi,(%esp)
  8016a2:	e8 b6 05 00 00       	call   801c5d <pageref>
		nn = thisenv->env_runs;
  8016a7:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8016ad:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8016b0:	83 c4 10             	add    $0x10,%esp
  8016b3:	39 cb                	cmp    %ecx,%ebx
  8016b5:	74 1b                	je     8016d2 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8016b7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8016ba:	75 cf                	jne    80168b <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8016bc:	8b 42 58             	mov    0x58(%edx),%eax
  8016bf:	6a 01                	push   $0x1
  8016c1:	50                   	push   %eax
  8016c2:	53                   	push   %ebx
  8016c3:	68 32 23 80 00       	push   $0x802332
  8016c8:	e8 8a ea ff ff       	call   800157 <cprintf>
  8016cd:	83 c4 10             	add    $0x10,%esp
  8016d0:	eb b9                	jmp    80168b <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8016d2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8016d5:	0f 94 c0             	sete   %al
  8016d8:	0f b6 c0             	movzbl %al,%eax
}
  8016db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016de:	5b                   	pop    %ebx
  8016df:	5e                   	pop    %esi
  8016e0:	5f                   	pop    %edi
  8016e1:	5d                   	pop    %ebp
  8016e2:	c3                   	ret    

008016e3 <devpipe_write>:
{
  8016e3:	f3 0f 1e fb          	endbr32 
  8016e7:	55                   	push   %ebp
  8016e8:	89 e5                	mov    %esp,%ebp
  8016ea:	57                   	push   %edi
  8016eb:	56                   	push   %esi
  8016ec:	53                   	push   %ebx
  8016ed:	83 ec 28             	sub    $0x28,%esp
  8016f0:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8016f3:	56                   	push   %esi
  8016f4:	e8 cf f6 ff ff       	call   800dc8 <fd2data>
  8016f9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8016fb:	83 c4 10             	add    $0x10,%esp
  8016fe:	bf 00 00 00 00       	mov    $0x0,%edi
  801703:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801706:	74 4f                	je     801757 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801708:	8b 43 04             	mov    0x4(%ebx),%eax
  80170b:	8b 0b                	mov    (%ebx),%ecx
  80170d:	8d 51 20             	lea    0x20(%ecx),%edx
  801710:	39 d0                	cmp    %edx,%eax
  801712:	72 14                	jb     801728 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801714:	89 da                	mov    %ebx,%edx
  801716:	89 f0                	mov    %esi,%eax
  801718:	e8 61 ff ff ff       	call   80167e <_pipeisclosed>
  80171d:	85 c0                	test   %eax,%eax
  80171f:	75 3b                	jne    80175c <devpipe_write+0x79>
			sys_yield();
  801721:	e8 5a f4 ff ff       	call   800b80 <sys_yield>
  801726:	eb e0                	jmp    801708 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801728:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80172b:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80172f:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801732:	89 c2                	mov    %eax,%edx
  801734:	c1 fa 1f             	sar    $0x1f,%edx
  801737:	89 d1                	mov    %edx,%ecx
  801739:	c1 e9 1b             	shr    $0x1b,%ecx
  80173c:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80173f:	83 e2 1f             	and    $0x1f,%edx
  801742:	29 ca                	sub    %ecx,%edx
  801744:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801748:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80174c:	83 c0 01             	add    $0x1,%eax
  80174f:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801752:	83 c7 01             	add    $0x1,%edi
  801755:	eb ac                	jmp    801703 <devpipe_write+0x20>
	return i;
  801757:	8b 45 10             	mov    0x10(%ebp),%eax
  80175a:	eb 05                	jmp    801761 <devpipe_write+0x7e>
				return 0;
  80175c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801761:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801764:	5b                   	pop    %ebx
  801765:	5e                   	pop    %esi
  801766:	5f                   	pop    %edi
  801767:	5d                   	pop    %ebp
  801768:	c3                   	ret    

00801769 <devpipe_read>:
{
  801769:	f3 0f 1e fb          	endbr32 
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
  801770:	57                   	push   %edi
  801771:	56                   	push   %esi
  801772:	53                   	push   %ebx
  801773:	83 ec 18             	sub    $0x18,%esp
  801776:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801779:	57                   	push   %edi
  80177a:	e8 49 f6 ff ff       	call   800dc8 <fd2data>
  80177f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801781:	83 c4 10             	add    $0x10,%esp
  801784:	be 00 00 00 00       	mov    $0x0,%esi
  801789:	3b 75 10             	cmp    0x10(%ebp),%esi
  80178c:	75 14                	jne    8017a2 <devpipe_read+0x39>
	return i;
  80178e:	8b 45 10             	mov    0x10(%ebp),%eax
  801791:	eb 02                	jmp    801795 <devpipe_read+0x2c>
				return i;
  801793:	89 f0                	mov    %esi,%eax
}
  801795:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801798:	5b                   	pop    %ebx
  801799:	5e                   	pop    %esi
  80179a:	5f                   	pop    %edi
  80179b:	5d                   	pop    %ebp
  80179c:	c3                   	ret    
			sys_yield();
  80179d:	e8 de f3 ff ff       	call   800b80 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8017a2:	8b 03                	mov    (%ebx),%eax
  8017a4:	3b 43 04             	cmp    0x4(%ebx),%eax
  8017a7:	75 18                	jne    8017c1 <devpipe_read+0x58>
			if (i > 0)
  8017a9:	85 f6                	test   %esi,%esi
  8017ab:	75 e6                	jne    801793 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8017ad:	89 da                	mov    %ebx,%edx
  8017af:	89 f8                	mov    %edi,%eax
  8017b1:	e8 c8 fe ff ff       	call   80167e <_pipeisclosed>
  8017b6:	85 c0                	test   %eax,%eax
  8017b8:	74 e3                	je     80179d <devpipe_read+0x34>
				return 0;
  8017ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8017bf:	eb d4                	jmp    801795 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8017c1:	99                   	cltd   
  8017c2:	c1 ea 1b             	shr    $0x1b,%edx
  8017c5:	01 d0                	add    %edx,%eax
  8017c7:	83 e0 1f             	and    $0x1f,%eax
  8017ca:	29 d0                	sub    %edx,%eax
  8017cc:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8017d1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017d4:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8017d7:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8017da:	83 c6 01             	add    $0x1,%esi
  8017dd:	eb aa                	jmp    801789 <devpipe_read+0x20>

008017df <pipe>:
{
  8017df:	f3 0f 1e fb          	endbr32 
  8017e3:	55                   	push   %ebp
  8017e4:	89 e5                	mov    %esp,%ebp
  8017e6:	56                   	push   %esi
  8017e7:	53                   	push   %ebx
  8017e8:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8017eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ee:	50                   	push   %eax
  8017ef:	e8 ef f5 ff ff       	call   800de3 <fd_alloc>
  8017f4:	89 c3                	mov    %eax,%ebx
  8017f6:	83 c4 10             	add    $0x10,%esp
  8017f9:	85 c0                	test   %eax,%eax
  8017fb:	0f 88 23 01 00 00    	js     801924 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801801:	83 ec 04             	sub    $0x4,%esp
  801804:	68 07 04 00 00       	push   $0x407
  801809:	ff 75 f4             	pushl  -0xc(%ebp)
  80180c:	6a 00                	push   $0x0
  80180e:	e8 90 f3 ff ff       	call   800ba3 <sys_page_alloc>
  801813:	89 c3                	mov    %eax,%ebx
  801815:	83 c4 10             	add    $0x10,%esp
  801818:	85 c0                	test   %eax,%eax
  80181a:	0f 88 04 01 00 00    	js     801924 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801820:	83 ec 0c             	sub    $0xc,%esp
  801823:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801826:	50                   	push   %eax
  801827:	e8 b7 f5 ff ff       	call   800de3 <fd_alloc>
  80182c:	89 c3                	mov    %eax,%ebx
  80182e:	83 c4 10             	add    $0x10,%esp
  801831:	85 c0                	test   %eax,%eax
  801833:	0f 88 db 00 00 00    	js     801914 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801839:	83 ec 04             	sub    $0x4,%esp
  80183c:	68 07 04 00 00       	push   $0x407
  801841:	ff 75 f0             	pushl  -0x10(%ebp)
  801844:	6a 00                	push   $0x0
  801846:	e8 58 f3 ff ff       	call   800ba3 <sys_page_alloc>
  80184b:	89 c3                	mov    %eax,%ebx
  80184d:	83 c4 10             	add    $0x10,%esp
  801850:	85 c0                	test   %eax,%eax
  801852:	0f 88 bc 00 00 00    	js     801914 <pipe+0x135>
	va = fd2data(fd0);
  801858:	83 ec 0c             	sub    $0xc,%esp
  80185b:	ff 75 f4             	pushl  -0xc(%ebp)
  80185e:	e8 65 f5 ff ff       	call   800dc8 <fd2data>
  801863:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801865:	83 c4 0c             	add    $0xc,%esp
  801868:	68 07 04 00 00       	push   $0x407
  80186d:	50                   	push   %eax
  80186e:	6a 00                	push   $0x0
  801870:	e8 2e f3 ff ff       	call   800ba3 <sys_page_alloc>
  801875:	89 c3                	mov    %eax,%ebx
  801877:	83 c4 10             	add    $0x10,%esp
  80187a:	85 c0                	test   %eax,%eax
  80187c:	0f 88 82 00 00 00    	js     801904 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801882:	83 ec 0c             	sub    $0xc,%esp
  801885:	ff 75 f0             	pushl  -0x10(%ebp)
  801888:	e8 3b f5 ff ff       	call   800dc8 <fd2data>
  80188d:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801894:	50                   	push   %eax
  801895:	6a 00                	push   $0x0
  801897:	56                   	push   %esi
  801898:	6a 00                	push   $0x0
  80189a:	e8 4b f3 ff ff       	call   800bea <sys_page_map>
  80189f:	89 c3                	mov    %eax,%ebx
  8018a1:	83 c4 20             	add    $0x20,%esp
  8018a4:	85 c0                	test   %eax,%eax
  8018a6:	78 4e                	js     8018f6 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8018a8:	a1 20 30 80 00       	mov    0x803020,%eax
  8018ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018b0:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8018b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018b5:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8018bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018bf:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8018c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c4:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8018cb:	83 ec 0c             	sub    $0xc,%esp
  8018ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8018d1:	e8 de f4 ff ff       	call   800db4 <fd2num>
  8018d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018d9:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8018db:	83 c4 04             	add    $0x4,%esp
  8018de:	ff 75 f0             	pushl  -0x10(%ebp)
  8018e1:	e8 ce f4 ff ff       	call   800db4 <fd2num>
  8018e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018e9:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8018ec:	83 c4 10             	add    $0x10,%esp
  8018ef:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018f4:	eb 2e                	jmp    801924 <pipe+0x145>
	sys_page_unmap(0, va);
  8018f6:	83 ec 08             	sub    $0x8,%esp
  8018f9:	56                   	push   %esi
  8018fa:	6a 00                	push   $0x0
  8018fc:	e8 2f f3 ff ff       	call   800c30 <sys_page_unmap>
  801901:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801904:	83 ec 08             	sub    $0x8,%esp
  801907:	ff 75 f0             	pushl  -0x10(%ebp)
  80190a:	6a 00                	push   $0x0
  80190c:	e8 1f f3 ff ff       	call   800c30 <sys_page_unmap>
  801911:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801914:	83 ec 08             	sub    $0x8,%esp
  801917:	ff 75 f4             	pushl  -0xc(%ebp)
  80191a:	6a 00                	push   $0x0
  80191c:	e8 0f f3 ff ff       	call   800c30 <sys_page_unmap>
  801921:	83 c4 10             	add    $0x10,%esp
}
  801924:	89 d8                	mov    %ebx,%eax
  801926:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801929:	5b                   	pop    %ebx
  80192a:	5e                   	pop    %esi
  80192b:	5d                   	pop    %ebp
  80192c:	c3                   	ret    

0080192d <pipeisclosed>:
{
  80192d:	f3 0f 1e fb          	endbr32 
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801937:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80193a:	50                   	push   %eax
  80193b:	ff 75 08             	pushl  0x8(%ebp)
  80193e:	e8 f6 f4 ff ff       	call   800e39 <fd_lookup>
  801943:	83 c4 10             	add    $0x10,%esp
  801946:	85 c0                	test   %eax,%eax
  801948:	78 18                	js     801962 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  80194a:	83 ec 0c             	sub    $0xc,%esp
  80194d:	ff 75 f4             	pushl  -0xc(%ebp)
  801950:	e8 73 f4 ff ff       	call   800dc8 <fd2data>
  801955:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801957:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80195a:	e8 1f fd ff ff       	call   80167e <_pipeisclosed>
  80195f:	83 c4 10             	add    $0x10,%esp
}
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801964:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801968:	b8 00 00 00 00       	mov    $0x0,%eax
  80196d:	c3                   	ret    

0080196e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80196e:	f3 0f 1e fb          	endbr32 
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
  801975:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801978:	68 4a 23 80 00       	push   $0x80234a
  80197d:	ff 75 0c             	pushl  0xc(%ebp)
  801980:	e8 dc ed ff ff       	call   800761 <strcpy>
	return 0;
}
  801985:	b8 00 00 00 00       	mov    $0x0,%eax
  80198a:	c9                   	leave  
  80198b:	c3                   	ret    

0080198c <devcons_write>:
{
  80198c:	f3 0f 1e fb          	endbr32 
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
  801993:	57                   	push   %edi
  801994:	56                   	push   %esi
  801995:	53                   	push   %ebx
  801996:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80199c:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8019a1:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8019a7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8019aa:	73 31                	jae    8019dd <devcons_write+0x51>
		m = n - tot;
  8019ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8019af:	29 f3                	sub    %esi,%ebx
  8019b1:	83 fb 7f             	cmp    $0x7f,%ebx
  8019b4:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8019b9:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8019bc:	83 ec 04             	sub    $0x4,%esp
  8019bf:	53                   	push   %ebx
  8019c0:	89 f0                	mov    %esi,%eax
  8019c2:	03 45 0c             	add    0xc(%ebp),%eax
  8019c5:	50                   	push   %eax
  8019c6:	57                   	push   %edi
  8019c7:	e8 4b ef ff ff       	call   800917 <memmove>
		sys_cputs(buf, m);
  8019cc:	83 c4 08             	add    $0x8,%esp
  8019cf:	53                   	push   %ebx
  8019d0:	57                   	push   %edi
  8019d1:	e8 fd f0 ff ff       	call   800ad3 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8019d6:	01 de                	add    %ebx,%esi
  8019d8:	83 c4 10             	add    $0x10,%esp
  8019db:	eb ca                	jmp    8019a7 <devcons_write+0x1b>
}
  8019dd:	89 f0                	mov    %esi,%eax
  8019df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019e2:	5b                   	pop    %ebx
  8019e3:	5e                   	pop    %esi
  8019e4:	5f                   	pop    %edi
  8019e5:	5d                   	pop    %ebp
  8019e6:	c3                   	ret    

008019e7 <devcons_read>:
{
  8019e7:	f3 0f 1e fb          	endbr32 
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
  8019ee:	83 ec 08             	sub    $0x8,%esp
  8019f1:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8019f6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019fa:	74 21                	je     801a1d <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8019fc:	e8 f4 f0 ff ff       	call   800af5 <sys_cgetc>
  801a01:	85 c0                	test   %eax,%eax
  801a03:	75 07                	jne    801a0c <devcons_read+0x25>
		sys_yield();
  801a05:	e8 76 f1 ff ff       	call   800b80 <sys_yield>
  801a0a:	eb f0                	jmp    8019fc <devcons_read+0x15>
	if (c < 0)
  801a0c:	78 0f                	js     801a1d <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801a0e:	83 f8 04             	cmp    $0x4,%eax
  801a11:	74 0c                	je     801a1f <devcons_read+0x38>
	*(char*)vbuf = c;
  801a13:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a16:	88 02                	mov    %al,(%edx)
	return 1;
  801a18:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    
		return 0;
  801a1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a24:	eb f7                	jmp    801a1d <devcons_read+0x36>

00801a26 <cputchar>:
{
  801a26:	f3 0f 1e fb          	endbr32 
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
  801a2d:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801a30:	8b 45 08             	mov    0x8(%ebp),%eax
  801a33:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801a36:	6a 01                	push   $0x1
  801a38:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801a3b:	50                   	push   %eax
  801a3c:	e8 92 f0 ff ff       	call   800ad3 <sys_cputs>
}
  801a41:	83 c4 10             	add    $0x10,%esp
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <getchar>:
{
  801a46:	f3 0f 1e fb          	endbr32 
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
  801a4d:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801a50:	6a 01                	push   $0x1
  801a52:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801a55:	50                   	push   %eax
  801a56:	6a 00                	push   $0x0
  801a58:	e8 5f f6 ff ff       	call   8010bc <read>
	if (r < 0)
  801a5d:	83 c4 10             	add    $0x10,%esp
  801a60:	85 c0                	test   %eax,%eax
  801a62:	78 06                	js     801a6a <getchar+0x24>
	if (r < 1)
  801a64:	74 06                	je     801a6c <getchar+0x26>
	return c;
  801a66:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    
		return -E_EOF;
  801a6c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801a71:	eb f7                	jmp    801a6a <getchar+0x24>

00801a73 <iscons>:
{
  801a73:	f3 0f 1e fb          	endbr32 
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
  801a7a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a7d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a80:	50                   	push   %eax
  801a81:	ff 75 08             	pushl  0x8(%ebp)
  801a84:	e8 b0 f3 ff ff       	call   800e39 <fd_lookup>
  801a89:	83 c4 10             	add    $0x10,%esp
  801a8c:	85 c0                	test   %eax,%eax
  801a8e:	78 11                	js     801aa1 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a93:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801a99:	39 10                	cmp    %edx,(%eax)
  801a9b:	0f 94 c0             	sete   %al
  801a9e:	0f b6 c0             	movzbl %al,%eax
}
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <opencons>:
{
  801aa3:	f3 0f 1e fb          	endbr32 
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
  801aaa:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801aad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ab0:	50                   	push   %eax
  801ab1:	e8 2d f3 ff ff       	call   800de3 <fd_alloc>
  801ab6:	83 c4 10             	add    $0x10,%esp
  801ab9:	85 c0                	test   %eax,%eax
  801abb:	78 3a                	js     801af7 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801abd:	83 ec 04             	sub    $0x4,%esp
  801ac0:	68 07 04 00 00       	push   $0x407
  801ac5:	ff 75 f4             	pushl  -0xc(%ebp)
  801ac8:	6a 00                	push   $0x0
  801aca:	e8 d4 f0 ff ff       	call   800ba3 <sys_page_alloc>
  801acf:	83 c4 10             	add    $0x10,%esp
  801ad2:	85 c0                	test   %eax,%eax
  801ad4:	78 21                	js     801af7 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801adf:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801aeb:	83 ec 0c             	sub    $0xc,%esp
  801aee:	50                   	push   %eax
  801aef:	e8 c0 f2 ff ff       	call   800db4 <fd2num>
  801af4:	83 c4 10             	add    $0x10,%esp
}
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    

00801af9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801af9:	f3 0f 1e fb          	endbr32 
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
  801b00:	56                   	push   %esi
  801b01:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801b02:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801b05:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801b0b:	e8 4d f0 ff ff       	call   800b5d <sys_getenvid>
  801b10:	83 ec 0c             	sub    $0xc,%esp
  801b13:	ff 75 0c             	pushl  0xc(%ebp)
  801b16:	ff 75 08             	pushl  0x8(%ebp)
  801b19:	56                   	push   %esi
  801b1a:	50                   	push   %eax
  801b1b:	68 58 23 80 00       	push   $0x802358
  801b20:	e8 32 e6 ff ff       	call   800157 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801b25:	83 c4 18             	add    $0x18,%esp
  801b28:	53                   	push   %ebx
  801b29:	ff 75 10             	pushl  0x10(%ebp)
  801b2c:	e8 d1 e5 ff ff       	call   800102 <vcprintf>
	cprintf("\n");
  801b31:	c7 04 24 94 23 80 00 	movl   $0x802394,(%esp)
  801b38:	e8 1a e6 ff ff       	call   800157 <cprintf>
  801b3d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801b40:	cc                   	int3   
  801b41:	eb fd                	jmp    801b40 <_panic+0x47>

00801b43 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b43:	f3 0f 1e fb          	endbr32 
  801b47:	55                   	push   %ebp
  801b48:	89 e5                	mov    %esp,%ebp
  801b4a:	56                   	push   %esi
  801b4b:	53                   	push   %ebx
  801b4c:	8b 75 08             	mov    0x8(%ebp),%esi
  801b4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b52:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  801b55:	85 c0                	test   %eax,%eax
  801b57:	74 3d                	je     801b96 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  801b59:	83 ec 0c             	sub    $0xc,%esp
  801b5c:	50                   	push   %eax
  801b5d:	e8 0d f2 ff ff       	call   800d6f <sys_ipc_recv>
  801b62:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  801b65:	85 f6                	test   %esi,%esi
  801b67:	74 0b                	je     801b74 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801b69:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b6f:	8b 52 74             	mov    0x74(%edx),%edx
  801b72:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801b74:	85 db                	test   %ebx,%ebx
  801b76:	74 0b                	je     801b83 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  801b78:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b7e:	8b 52 78             	mov    0x78(%edx),%edx
  801b81:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  801b83:	85 c0                	test   %eax,%eax
  801b85:	78 21                	js     801ba8 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  801b87:	a1 04 40 80 00       	mov    0x804004,%eax
  801b8c:	8b 40 70             	mov    0x70(%eax),%eax
}
  801b8f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b92:	5b                   	pop    %ebx
  801b93:	5e                   	pop    %esi
  801b94:	5d                   	pop    %ebp
  801b95:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  801b96:	83 ec 0c             	sub    $0xc,%esp
  801b99:	68 00 00 c0 ee       	push   $0xeec00000
  801b9e:	e8 cc f1 ff ff       	call   800d6f <sys_ipc_recv>
  801ba3:	83 c4 10             	add    $0x10,%esp
  801ba6:	eb bd                	jmp    801b65 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  801ba8:	85 f6                	test   %esi,%esi
  801baa:	74 10                	je     801bbc <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  801bac:	85 db                	test   %ebx,%ebx
  801bae:	75 df                	jne    801b8f <ipc_recv+0x4c>
  801bb0:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801bb7:	00 00 00 
  801bba:	eb d3                	jmp    801b8f <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  801bbc:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801bc3:	00 00 00 
  801bc6:	eb e4                	jmp    801bac <ipc_recv+0x69>

00801bc8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801bc8:	f3 0f 1e fb          	endbr32 
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
  801bcf:	57                   	push   %edi
  801bd0:	56                   	push   %esi
  801bd1:	53                   	push   %ebx
  801bd2:	83 ec 0c             	sub    $0xc,%esp
  801bd5:	8b 7d 08             	mov    0x8(%ebp),%edi
  801bd8:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bdb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  801bde:	85 db                	test   %ebx,%ebx
  801be0:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801be5:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  801be8:	ff 75 14             	pushl  0x14(%ebp)
  801beb:	53                   	push   %ebx
  801bec:	56                   	push   %esi
  801bed:	57                   	push   %edi
  801bee:	e8 55 f1 ff ff       	call   800d48 <sys_ipc_try_send>
  801bf3:	83 c4 10             	add    $0x10,%esp
  801bf6:	85 c0                	test   %eax,%eax
  801bf8:	79 1e                	jns    801c18 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  801bfa:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801bfd:	75 07                	jne    801c06 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  801bff:	e8 7c ef ff ff       	call   800b80 <sys_yield>
  801c04:	eb e2                	jmp    801be8 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  801c06:	50                   	push   %eax
  801c07:	68 7b 23 80 00       	push   $0x80237b
  801c0c:	6a 59                	push   $0x59
  801c0e:	68 96 23 80 00       	push   $0x802396
  801c13:	e8 e1 fe ff ff       	call   801af9 <_panic>
	}
}
  801c18:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c1b:	5b                   	pop    %ebx
  801c1c:	5e                   	pop    %esi
  801c1d:	5f                   	pop    %edi
  801c1e:	5d                   	pop    %ebp
  801c1f:	c3                   	ret    

00801c20 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c20:	f3 0f 1e fb          	endbr32 
  801c24:	55                   	push   %ebp
  801c25:	89 e5                	mov    %esp,%ebp
  801c27:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801c2a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801c2f:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801c32:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801c38:	8b 52 50             	mov    0x50(%edx),%edx
  801c3b:	39 ca                	cmp    %ecx,%edx
  801c3d:	74 11                	je     801c50 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801c3f:	83 c0 01             	add    $0x1,%eax
  801c42:	3d 00 04 00 00       	cmp    $0x400,%eax
  801c47:	75 e6                	jne    801c2f <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801c49:	b8 00 00 00 00       	mov    $0x0,%eax
  801c4e:	eb 0b                	jmp    801c5b <ipc_find_env+0x3b>
			return envs[i].env_id;
  801c50:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801c53:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801c58:	8b 40 48             	mov    0x48(%eax),%eax
}
  801c5b:	5d                   	pop    %ebp
  801c5c:	c3                   	ret    

00801c5d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c5d:	f3 0f 1e fb          	endbr32 
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
  801c64:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c67:	89 c2                	mov    %eax,%edx
  801c69:	c1 ea 16             	shr    $0x16,%edx
  801c6c:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801c73:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801c78:	f6 c1 01             	test   $0x1,%cl
  801c7b:	74 1c                	je     801c99 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801c7d:	c1 e8 0c             	shr    $0xc,%eax
  801c80:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801c87:	a8 01                	test   $0x1,%al
  801c89:	74 0e                	je     801c99 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801c8b:	c1 e8 0c             	shr    $0xc,%eax
  801c8e:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801c95:	ef 
  801c96:	0f b7 d2             	movzwl %dx,%edx
}
  801c99:	89 d0                	mov    %edx,%eax
  801c9b:	5d                   	pop    %ebp
  801c9c:	c3                   	ret    
  801c9d:	66 90                	xchg   %ax,%ax
  801c9f:	90                   	nop

00801ca0 <__udivdi3>:
  801ca0:	f3 0f 1e fb          	endbr32 
  801ca4:	55                   	push   %ebp
  801ca5:	57                   	push   %edi
  801ca6:	56                   	push   %esi
  801ca7:	53                   	push   %ebx
  801ca8:	83 ec 1c             	sub    $0x1c,%esp
  801cab:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801caf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801cb3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801cb7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801cbb:	85 d2                	test   %edx,%edx
  801cbd:	75 19                	jne    801cd8 <__udivdi3+0x38>
  801cbf:	39 f3                	cmp    %esi,%ebx
  801cc1:	76 4d                	jbe    801d10 <__udivdi3+0x70>
  801cc3:	31 ff                	xor    %edi,%edi
  801cc5:	89 e8                	mov    %ebp,%eax
  801cc7:	89 f2                	mov    %esi,%edx
  801cc9:	f7 f3                	div    %ebx
  801ccb:	89 fa                	mov    %edi,%edx
  801ccd:	83 c4 1c             	add    $0x1c,%esp
  801cd0:	5b                   	pop    %ebx
  801cd1:	5e                   	pop    %esi
  801cd2:	5f                   	pop    %edi
  801cd3:	5d                   	pop    %ebp
  801cd4:	c3                   	ret    
  801cd5:	8d 76 00             	lea    0x0(%esi),%esi
  801cd8:	39 f2                	cmp    %esi,%edx
  801cda:	76 14                	jbe    801cf0 <__udivdi3+0x50>
  801cdc:	31 ff                	xor    %edi,%edi
  801cde:	31 c0                	xor    %eax,%eax
  801ce0:	89 fa                	mov    %edi,%edx
  801ce2:	83 c4 1c             	add    $0x1c,%esp
  801ce5:	5b                   	pop    %ebx
  801ce6:	5e                   	pop    %esi
  801ce7:	5f                   	pop    %edi
  801ce8:	5d                   	pop    %ebp
  801ce9:	c3                   	ret    
  801cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801cf0:	0f bd fa             	bsr    %edx,%edi
  801cf3:	83 f7 1f             	xor    $0x1f,%edi
  801cf6:	75 48                	jne    801d40 <__udivdi3+0xa0>
  801cf8:	39 f2                	cmp    %esi,%edx
  801cfa:	72 06                	jb     801d02 <__udivdi3+0x62>
  801cfc:	31 c0                	xor    %eax,%eax
  801cfe:	39 eb                	cmp    %ebp,%ebx
  801d00:	77 de                	ja     801ce0 <__udivdi3+0x40>
  801d02:	b8 01 00 00 00       	mov    $0x1,%eax
  801d07:	eb d7                	jmp    801ce0 <__udivdi3+0x40>
  801d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d10:	89 d9                	mov    %ebx,%ecx
  801d12:	85 db                	test   %ebx,%ebx
  801d14:	75 0b                	jne    801d21 <__udivdi3+0x81>
  801d16:	b8 01 00 00 00       	mov    $0x1,%eax
  801d1b:	31 d2                	xor    %edx,%edx
  801d1d:	f7 f3                	div    %ebx
  801d1f:	89 c1                	mov    %eax,%ecx
  801d21:	31 d2                	xor    %edx,%edx
  801d23:	89 f0                	mov    %esi,%eax
  801d25:	f7 f1                	div    %ecx
  801d27:	89 c6                	mov    %eax,%esi
  801d29:	89 e8                	mov    %ebp,%eax
  801d2b:	89 f7                	mov    %esi,%edi
  801d2d:	f7 f1                	div    %ecx
  801d2f:	89 fa                	mov    %edi,%edx
  801d31:	83 c4 1c             	add    $0x1c,%esp
  801d34:	5b                   	pop    %ebx
  801d35:	5e                   	pop    %esi
  801d36:	5f                   	pop    %edi
  801d37:	5d                   	pop    %ebp
  801d38:	c3                   	ret    
  801d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d40:	89 f9                	mov    %edi,%ecx
  801d42:	b8 20 00 00 00       	mov    $0x20,%eax
  801d47:	29 f8                	sub    %edi,%eax
  801d49:	d3 e2                	shl    %cl,%edx
  801d4b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d4f:	89 c1                	mov    %eax,%ecx
  801d51:	89 da                	mov    %ebx,%edx
  801d53:	d3 ea                	shr    %cl,%edx
  801d55:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801d59:	09 d1                	or     %edx,%ecx
  801d5b:	89 f2                	mov    %esi,%edx
  801d5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d61:	89 f9                	mov    %edi,%ecx
  801d63:	d3 e3                	shl    %cl,%ebx
  801d65:	89 c1                	mov    %eax,%ecx
  801d67:	d3 ea                	shr    %cl,%edx
  801d69:	89 f9                	mov    %edi,%ecx
  801d6b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801d6f:	89 eb                	mov    %ebp,%ebx
  801d71:	d3 e6                	shl    %cl,%esi
  801d73:	89 c1                	mov    %eax,%ecx
  801d75:	d3 eb                	shr    %cl,%ebx
  801d77:	09 de                	or     %ebx,%esi
  801d79:	89 f0                	mov    %esi,%eax
  801d7b:	f7 74 24 08          	divl   0x8(%esp)
  801d7f:	89 d6                	mov    %edx,%esi
  801d81:	89 c3                	mov    %eax,%ebx
  801d83:	f7 64 24 0c          	mull   0xc(%esp)
  801d87:	39 d6                	cmp    %edx,%esi
  801d89:	72 15                	jb     801da0 <__udivdi3+0x100>
  801d8b:	89 f9                	mov    %edi,%ecx
  801d8d:	d3 e5                	shl    %cl,%ebp
  801d8f:	39 c5                	cmp    %eax,%ebp
  801d91:	73 04                	jae    801d97 <__udivdi3+0xf7>
  801d93:	39 d6                	cmp    %edx,%esi
  801d95:	74 09                	je     801da0 <__udivdi3+0x100>
  801d97:	89 d8                	mov    %ebx,%eax
  801d99:	31 ff                	xor    %edi,%edi
  801d9b:	e9 40 ff ff ff       	jmp    801ce0 <__udivdi3+0x40>
  801da0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801da3:	31 ff                	xor    %edi,%edi
  801da5:	e9 36 ff ff ff       	jmp    801ce0 <__udivdi3+0x40>
  801daa:	66 90                	xchg   %ax,%ax
  801dac:	66 90                	xchg   %ax,%ax
  801dae:	66 90                	xchg   %ax,%ax

00801db0 <__umoddi3>:
  801db0:	f3 0f 1e fb          	endbr32 
  801db4:	55                   	push   %ebp
  801db5:	57                   	push   %edi
  801db6:	56                   	push   %esi
  801db7:	53                   	push   %ebx
  801db8:	83 ec 1c             	sub    $0x1c,%esp
  801dbb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801dbf:	8b 74 24 30          	mov    0x30(%esp),%esi
  801dc3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801dc7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801dcb:	85 c0                	test   %eax,%eax
  801dcd:	75 19                	jne    801de8 <__umoddi3+0x38>
  801dcf:	39 df                	cmp    %ebx,%edi
  801dd1:	76 5d                	jbe    801e30 <__umoddi3+0x80>
  801dd3:	89 f0                	mov    %esi,%eax
  801dd5:	89 da                	mov    %ebx,%edx
  801dd7:	f7 f7                	div    %edi
  801dd9:	89 d0                	mov    %edx,%eax
  801ddb:	31 d2                	xor    %edx,%edx
  801ddd:	83 c4 1c             	add    $0x1c,%esp
  801de0:	5b                   	pop    %ebx
  801de1:	5e                   	pop    %esi
  801de2:	5f                   	pop    %edi
  801de3:	5d                   	pop    %ebp
  801de4:	c3                   	ret    
  801de5:	8d 76 00             	lea    0x0(%esi),%esi
  801de8:	89 f2                	mov    %esi,%edx
  801dea:	39 d8                	cmp    %ebx,%eax
  801dec:	76 12                	jbe    801e00 <__umoddi3+0x50>
  801dee:	89 f0                	mov    %esi,%eax
  801df0:	89 da                	mov    %ebx,%edx
  801df2:	83 c4 1c             	add    $0x1c,%esp
  801df5:	5b                   	pop    %ebx
  801df6:	5e                   	pop    %esi
  801df7:	5f                   	pop    %edi
  801df8:	5d                   	pop    %ebp
  801df9:	c3                   	ret    
  801dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801e00:	0f bd e8             	bsr    %eax,%ebp
  801e03:	83 f5 1f             	xor    $0x1f,%ebp
  801e06:	75 50                	jne    801e58 <__umoddi3+0xa8>
  801e08:	39 d8                	cmp    %ebx,%eax
  801e0a:	0f 82 e0 00 00 00    	jb     801ef0 <__umoddi3+0x140>
  801e10:	89 d9                	mov    %ebx,%ecx
  801e12:	39 f7                	cmp    %esi,%edi
  801e14:	0f 86 d6 00 00 00    	jbe    801ef0 <__umoddi3+0x140>
  801e1a:	89 d0                	mov    %edx,%eax
  801e1c:	89 ca                	mov    %ecx,%edx
  801e1e:	83 c4 1c             	add    $0x1c,%esp
  801e21:	5b                   	pop    %ebx
  801e22:	5e                   	pop    %esi
  801e23:	5f                   	pop    %edi
  801e24:	5d                   	pop    %ebp
  801e25:	c3                   	ret    
  801e26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e2d:	8d 76 00             	lea    0x0(%esi),%esi
  801e30:	89 fd                	mov    %edi,%ebp
  801e32:	85 ff                	test   %edi,%edi
  801e34:	75 0b                	jne    801e41 <__umoddi3+0x91>
  801e36:	b8 01 00 00 00       	mov    $0x1,%eax
  801e3b:	31 d2                	xor    %edx,%edx
  801e3d:	f7 f7                	div    %edi
  801e3f:	89 c5                	mov    %eax,%ebp
  801e41:	89 d8                	mov    %ebx,%eax
  801e43:	31 d2                	xor    %edx,%edx
  801e45:	f7 f5                	div    %ebp
  801e47:	89 f0                	mov    %esi,%eax
  801e49:	f7 f5                	div    %ebp
  801e4b:	89 d0                	mov    %edx,%eax
  801e4d:	31 d2                	xor    %edx,%edx
  801e4f:	eb 8c                	jmp    801ddd <__umoddi3+0x2d>
  801e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e58:	89 e9                	mov    %ebp,%ecx
  801e5a:	ba 20 00 00 00       	mov    $0x20,%edx
  801e5f:	29 ea                	sub    %ebp,%edx
  801e61:	d3 e0                	shl    %cl,%eax
  801e63:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e67:	89 d1                	mov    %edx,%ecx
  801e69:	89 f8                	mov    %edi,%eax
  801e6b:	d3 e8                	shr    %cl,%eax
  801e6d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801e71:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e75:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e79:	09 c1                	or     %eax,%ecx
  801e7b:	89 d8                	mov    %ebx,%eax
  801e7d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e81:	89 e9                	mov    %ebp,%ecx
  801e83:	d3 e7                	shl    %cl,%edi
  801e85:	89 d1                	mov    %edx,%ecx
  801e87:	d3 e8                	shr    %cl,%eax
  801e89:	89 e9                	mov    %ebp,%ecx
  801e8b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801e8f:	d3 e3                	shl    %cl,%ebx
  801e91:	89 c7                	mov    %eax,%edi
  801e93:	89 d1                	mov    %edx,%ecx
  801e95:	89 f0                	mov    %esi,%eax
  801e97:	d3 e8                	shr    %cl,%eax
  801e99:	89 e9                	mov    %ebp,%ecx
  801e9b:	89 fa                	mov    %edi,%edx
  801e9d:	d3 e6                	shl    %cl,%esi
  801e9f:	09 d8                	or     %ebx,%eax
  801ea1:	f7 74 24 08          	divl   0x8(%esp)
  801ea5:	89 d1                	mov    %edx,%ecx
  801ea7:	89 f3                	mov    %esi,%ebx
  801ea9:	f7 64 24 0c          	mull   0xc(%esp)
  801ead:	89 c6                	mov    %eax,%esi
  801eaf:	89 d7                	mov    %edx,%edi
  801eb1:	39 d1                	cmp    %edx,%ecx
  801eb3:	72 06                	jb     801ebb <__umoddi3+0x10b>
  801eb5:	75 10                	jne    801ec7 <__umoddi3+0x117>
  801eb7:	39 c3                	cmp    %eax,%ebx
  801eb9:	73 0c                	jae    801ec7 <__umoddi3+0x117>
  801ebb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  801ebf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801ec3:	89 d7                	mov    %edx,%edi
  801ec5:	89 c6                	mov    %eax,%esi
  801ec7:	89 ca                	mov    %ecx,%edx
  801ec9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801ece:	29 f3                	sub    %esi,%ebx
  801ed0:	19 fa                	sbb    %edi,%edx
  801ed2:	89 d0                	mov    %edx,%eax
  801ed4:	d3 e0                	shl    %cl,%eax
  801ed6:	89 e9                	mov    %ebp,%ecx
  801ed8:	d3 eb                	shr    %cl,%ebx
  801eda:	d3 ea                	shr    %cl,%edx
  801edc:	09 d8                	or     %ebx,%eax
  801ede:	83 c4 1c             	add    $0x1c,%esp
  801ee1:	5b                   	pop    %ebx
  801ee2:	5e                   	pop    %esi
  801ee3:	5f                   	pop    %edi
  801ee4:	5d                   	pop    %ebp
  801ee5:	c3                   	ret    
  801ee6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801eed:	8d 76 00             	lea    0x0(%esi),%esi
  801ef0:	29 fe                	sub    %edi,%esi
  801ef2:	19 c3                	sbb    %eax,%ebx
  801ef4:	89 f2                	mov    %esi,%edx
  801ef6:	89 d9                	mov    %ebx,%ecx
  801ef8:	e9 1d ff ff ff       	jmp    801e1a <__umoddi3+0x6a>
