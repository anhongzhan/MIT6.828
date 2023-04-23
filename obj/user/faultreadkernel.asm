
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
  800043:	68 80 24 80 00       	push   $0x802480
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
  800073:	a3 08 40 80 00       	mov    %eax,0x804008

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
  8000a6:	e8 ac 0f 00 00       	call   801057 <close_all>
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
  8001bd:	e8 4e 20 00 00       	call   802210 <__udivdi3>
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
  8001fb:	e8 20 21 00 00       	call   802320 <__umoddi3>
  800200:	83 c4 14             	add    $0x14,%esp
  800203:	0f be 80 b1 24 80 00 	movsbl 0x8024b1(%eax),%eax
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
  8002aa:	3e ff 24 85 00 26 80 	notrack jmp *0x802600(,%eax,4)
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
  800377:	8b 14 85 60 27 80 00 	mov    0x802760(,%eax,4),%edx
  80037e:	85 d2                	test   %edx,%edx
  800380:	74 18                	je     80039a <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800382:	52                   	push   %edx
  800383:	68 95 28 80 00       	push   $0x802895
  800388:	53                   	push   %ebx
  800389:	56                   	push   %esi
  80038a:	e8 aa fe ff ff       	call   800239 <printfmt>
  80038f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800392:	89 7d 14             	mov    %edi,0x14(%ebp)
  800395:	e9 66 02 00 00       	jmp    800600 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80039a:	50                   	push   %eax
  80039b:	68 c9 24 80 00       	push   $0x8024c9
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
  8003c2:	b8 c2 24 80 00       	mov    $0x8024c2,%eax
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
  800b4c:	68 bf 27 80 00       	push   $0x8027bf
  800b51:	6a 23                	push   $0x23
  800b53:	68 dc 27 80 00       	push   $0x8027dc
  800b58:	e8 08 15 00 00       	call   802065 <_panic>

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
  800bd9:	68 bf 27 80 00       	push   $0x8027bf
  800bde:	6a 23                	push   $0x23
  800be0:	68 dc 27 80 00       	push   $0x8027dc
  800be5:	e8 7b 14 00 00       	call   802065 <_panic>

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
  800c1f:	68 bf 27 80 00       	push   $0x8027bf
  800c24:	6a 23                	push   $0x23
  800c26:	68 dc 27 80 00       	push   $0x8027dc
  800c2b:	e8 35 14 00 00       	call   802065 <_panic>

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
  800c65:	68 bf 27 80 00       	push   $0x8027bf
  800c6a:	6a 23                	push   $0x23
  800c6c:	68 dc 27 80 00       	push   $0x8027dc
  800c71:	e8 ef 13 00 00       	call   802065 <_panic>

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
  800cab:	68 bf 27 80 00       	push   $0x8027bf
  800cb0:	6a 23                	push   $0x23
  800cb2:	68 dc 27 80 00       	push   $0x8027dc
  800cb7:	e8 a9 13 00 00       	call   802065 <_panic>

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
  800cf1:	68 bf 27 80 00       	push   $0x8027bf
  800cf6:	6a 23                	push   $0x23
  800cf8:	68 dc 27 80 00       	push   $0x8027dc
  800cfd:	e8 63 13 00 00       	call   802065 <_panic>

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
  800d37:	68 bf 27 80 00       	push   $0x8027bf
  800d3c:	6a 23                	push   $0x23
  800d3e:	68 dc 27 80 00       	push   $0x8027dc
  800d43:	e8 1d 13 00 00       	call   802065 <_panic>

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
  800da3:	68 bf 27 80 00       	push   $0x8027bf
  800da8:	6a 23                	push   $0x23
  800daa:	68 dc 27 80 00       	push   $0x8027dc
  800daf:	e8 b1 12 00 00       	call   802065 <_panic>

00800db4 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800db4:	f3 0f 1e fb          	endbr32 
  800db8:	55                   	push   %ebp
  800db9:	89 e5                	mov    %esp,%ebp
  800dbb:	57                   	push   %edi
  800dbc:	56                   	push   %esi
  800dbd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dbe:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc3:	b8 0e 00 00 00       	mov    $0xe,%eax
  800dc8:	89 d1                	mov    %edx,%ecx
  800dca:	89 d3                	mov    %edx,%ebx
  800dcc:	89 d7                	mov    %edx,%edi
  800dce:	89 d6                	mov    %edx,%esi
  800dd0:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800dd2:	5b                   	pop    %ebx
  800dd3:	5e                   	pop    %esi
  800dd4:	5f                   	pop    %edi
  800dd5:	5d                   	pop    %ebp
  800dd6:	c3                   	ret    

00800dd7 <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  800dd7:	f3 0f 1e fb          	endbr32 
  800ddb:	55                   	push   %ebp
  800ddc:	89 e5                	mov    %esp,%ebp
  800dde:	57                   	push   %edi
  800ddf:	56                   	push   %esi
  800de0:	53                   	push   %ebx
  800de1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800de9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800def:	b8 0f 00 00 00       	mov    $0xf,%eax
  800df4:	89 df                	mov    %ebx,%edi
  800df6:	89 de                	mov    %ebx,%esi
  800df8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dfa:	85 c0                	test   %eax,%eax
  800dfc:	7f 08                	jg     800e06 <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  800dfe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e01:	5b                   	pop    %ebx
  800e02:	5e                   	pop    %esi
  800e03:	5f                   	pop    %edi
  800e04:	5d                   	pop    %ebp
  800e05:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e06:	83 ec 0c             	sub    $0xc,%esp
  800e09:	50                   	push   %eax
  800e0a:	6a 0f                	push   $0xf
  800e0c:	68 bf 27 80 00       	push   $0x8027bf
  800e11:	6a 23                	push   $0x23
  800e13:	68 dc 27 80 00       	push   $0x8027dc
  800e18:	e8 48 12 00 00       	call   802065 <_panic>

00800e1d <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  800e1d:	f3 0f 1e fb          	endbr32 
  800e21:	55                   	push   %ebp
  800e22:	89 e5                	mov    %esp,%ebp
  800e24:	57                   	push   %edi
  800e25:	56                   	push   %esi
  800e26:	53                   	push   %ebx
  800e27:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e2a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e2f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e35:	b8 10 00 00 00       	mov    $0x10,%eax
  800e3a:	89 df                	mov    %ebx,%edi
  800e3c:	89 de                	mov    %ebx,%esi
  800e3e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e40:	85 c0                	test   %eax,%eax
  800e42:	7f 08                	jg     800e4c <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  800e44:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e47:	5b                   	pop    %ebx
  800e48:	5e                   	pop    %esi
  800e49:	5f                   	pop    %edi
  800e4a:	5d                   	pop    %ebp
  800e4b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4c:	83 ec 0c             	sub    $0xc,%esp
  800e4f:	50                   	push   %eax
  800e50:	6a 10                	push   $0x10
  800e52:	68 bf 27 80 00       	push   $0x8027bf
  800e57:	6a 23                	push   $0x23
  800e59:	68 dc 27 80 00       	push   $0x8027dc
  800e5e:	e8 02 12 00 00       	call   802065 <_panic>

00800e63 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e63:	f3 0f 1e fb          	endbr32 
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6d:	05 00 00 00 30       	add    $0x30000000,%eax
  800e72:	c1 e8 0c             	shr    $0xc,%eax
}
  800e75:	5d                   	pop    %ebp
  800e76:	c3                   	ret    

00800e77 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e77:	f3 0f 1e fb          	endbr32 
  800e7b:	55                   	push   %ebp
  800e7c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e81:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e86:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e8b:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e90:	5d                   	pop    %ebp
  800e91:	c3                   	ret    

00800e92 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e92:	f3 0f 1e fb          	endbr32 
  800e96:	55                   	push   %ebp
  800e97:	89 e5                	mov    %esp,%ebp
  800e99:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e9e:	89 c2                	mov    %eax,%edx
  800ea0:	c1 ea 16             	shr    $0x16,%edx
  800ea3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800eaa:	f6 c2 01             	test   $0x1,%dl
  800ead:	74 2d                	je     800edc <fd_alloc+0x4a>
  800eaf:	89 c2                	mov    %eax,%edx
  800eb1:	c1 ea 0c             	shr    $0xc,%edx
  800eb4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ebb:	f6 c2 01             	test   $0x1,%dl
  800ebe:	74 1c                	je     800edc <fd_alloc+0x4a>
  800ec0:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800ec5:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800eca:	75 d2                	jne    800e9e <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800ed5:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800eda:	eb 0a                	jmp    800ee6 <fd_alloc+0x54>
			*fd_store = fd;
  800edc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800edf:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ee1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ee6:	5d                   	pop    %ebp
  800ee7:	c3                   	ret    

00800ee8 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800ee8:	f3 0f 1e fb          	endbr32 
  800eec:	55                   	push   %ebp
  800eed:	89 e5                	mov    %esp,%ebp
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800ef2:	83 f8 1f             	cmp    $0x1f,%eax
  800ef5:	77 30                	ja     800f27 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800ef7:	c1 e0 0c             	shl    $0xc,%eax
  800efa:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800eff:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800f05:	f6 c2 01             	test   $0x1,%dl
  800f08:	74 24                	je     800f2e <fd_lookup+0x46>
  800f0a:	89 c2                	mov    %eax,%edx
  800f0c:	c1 ea 0c             	shr    $0xc,%edx
  800f0f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f16:	f6 c2 01             	test   $0x1,%dl
  800f19:	74 1a                	je     800f35 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f1e:	89 02                	mov    %eax,(%edx)
	return 0;
  800f20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f25:	5d                   	pop    %ebp
  800f26:	c3                   	ret    
		return -E_INVAL;
  800f27:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f2c:	eb f7                	jmp    800f25 <fd_lookup+0x3d>
		return -E_INVAL;
  800f2e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f33:	eb f0                	jmp    800f25 <fd_lookup+0x3d>
  800f35:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f3a:	eb e9                	jmp    800f25 <fd_lookup+0x3d>

00800f3c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f3c:	f3 0f 1e fb          	endbr32 
  800f40:	55                   	push   %ebp
  800f41:	89 e5                	mov    %esp,%ebp
  800f43:	83 ec 08             	sub    $0x8,%esp
  800f46:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800f49:	ba 00 00 00 00       	mov    $0x0,%edx
  800f4e:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f53:	39 08                	cmp    %ecx,(%eax)
  800f55:	74 38                	je     800f8f <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  800f57:	83 c2 01             	add    $0x1,%edx
  800f5a:	8b 04 95 68 28 80 00 	mov    0x802868(,%edx,4),%eax
  800f61:	85 c0                	test   %eax,%eax
  800f63:	75 ee                	jne    800f53 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f65:	a1 08 40 80 00       	mov    0x804008,%eax
  800f6a:	8b 40 48             	mov    0x48(%eax),%eax
  800f6d:	83 ec 04             	sub    $0x4,%esp
  800f70:	51                   	push   %ecx
  800f71:	50                   	push   %eax
  800f72:	68 ec 27 80 00       	push   $0x8027ec
  800f77:	e8 db f1 ff ff       	call   800157 <cprintf>
	*dev = 0;
  800f7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f85:	83 c4 10             	add    $0x10,%esp
  800f88:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f8d:	c9                   	leave  
  800f8e:	c3                   	ret    
			*dev = devtab[i];
  800f8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f92:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f94:	b8 00 00 00 00       	mov    $0x0,%eax
  800f99:	eb f2                	jmp    800f8d <dev_lookup+0x51>

00800f9b <fd_close>:
{
  800f9b:	f3 0f 1e fb          	endbr32 
  800f9f:	55                   	push   %ebp
  800fa0:	89 e5                	mov    %esp,%ebp
  800fa2:	57                   	push   %edi
  800fa3:	56                   	push   %esi
  800fa4:	53                   	push   %ebx
  800fa5:	83 ec 24             	sub    $0x24,%esp
  800fa8:	8b 75 08             	mov    0x8(%ebp),%esi
  800fab:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fae:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800fb1:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fb2:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800fb8:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fbb:	50                   	push   %eax
  800fbc:	e8 27 ff ff ff       	call   800ee8 <fd_lookup>
  800fc1:	89 c3                	mov    %eax,%ebx
  800fc3:	83 c4 10             	add    $0x10,%esp
  800fc6:	85 c0                	test   %eax,%eax
  800fc8:	78 05                	js     800fcf <fd_close+0x34>
	    || fd != fd2)
  800fca:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800fcd:	74 16                	je     800fe5 <fd_close+0x4a>
		return (must_exist ? r : 0);
  800fcf:	89 f8                	mov    %edi,%eax
  800fd1:	84 c0                	test   %al,%al
  800fd3:	b8 00 00 00 00       	mov    $0x0,%eax
  800fd8:	0f 44 d8             	cmove  %eax,%ebx
}
  800fdb:	89 d8                	mov    %ebx,%eax
  800fdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe0:	5b                   	pop    %ebx
  800fe1:	5e                   	pop    %esi
  800fe2:	5f                   	pop    %edi
  800fe3:	5d                   	pop    %ebp
  800fe4:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800fe5:	83 ec 08             	sub    $0x8,%esp
  800fe8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800feb:	50                   	push   %eax
  800fec:	ff 36                	pushl  (%esi)
  800fee:	e8 49 ff ff ff       	call   800f3c <dev_lookup>
  800ff3:	89 c3                	mov    %eax,%ebx
  800ff5:	83 c4 10             	add    $0x10,%esp
  800ff8:	85 c0                	test   %eax,%eax
  800ffa:	78 1a                	js     801016 <fd_close+0x7b>
		if (dev->dev_close)
  800ffc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fff:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801002:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801007:	85 c0                	test   %eax,%eax
  801009:	74 0b                	je     801016 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80100b:	83 ec 0c             	sub    $0xc,%esp
  80100e:	56                   	push   %esi
  80100f:	ff d0                	call   *%eax
  801011:	89 c3                	mov    %eax,%ebx
  801013:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801016:	83 ec 08             	sub    $0x8,%esp
  801019:	56                   	push   %esi
  80101a:	6a 00                	push   $0x0
  80101c:	e8 0f fc ff ff       	call   800c30 <sys_page_unmap>
	return r;
  801021:	83 c4 10             	add    $0x10,%esp
  801024:	eb b5                	jmp    800fdb <fd_close+0x40>

00801026 <close>:

int
close(int fdnum)
{
  801026:	f3 0f 1e fb          	endbr32 
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801030:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801033:	50                   	push   %eax
  801034:	ff 75 08             	pushl  0x8(%ebp)
  801037:	e8 ac fe ff ff       	call   800ee8 <fd_lookup>
  80103c:	83 c4 10             	add    $0x10,%esp
  80103f:	85 c0                	test   %eax,%eax
  801041:	79 02                	jns    801045 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801043:	c9                   	leave  
  801044:	c3                   	ret    
		return fd_close(fd, 1);
  801045:	83 ec 08             	sub    $0x8,%esp
  801048:	6a 01                	push   $0x1
  80104a:	ff 75 f4             	pushl  -0xc(%ebp)
  80104d:	e8 49 ff ff ff       	call   800f9b <fd_close>
  801052:	83 c4 10             	add    $0x10,%esp
  801055:	eb ec                	jmp    801043 <close+0x1d>

00801057 <close_all>:

void
close_all(void)
{
  801057:	f3 0f 1e fb          	endbr32 
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
  80105e:	53                   	push   %ebx
  80105f:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801062:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801067:	83 ec 0c             	sub    $0xc,%esp
  80106a:	53                   	push   %ebx
  80106b:	e8 b6 ff ff ff       	call   801026 <close>
	for (i = 0; i < MAXFD; i++)
  801070:	83 c3 01             	add    $0x1,%ebx
  801073:	83 c4 10             	add    $0x10,%esp
  801076:	83 fb 20             	cmp    $0x20,%ebx
  801079:	75 ec                	jne    801067 <close_all+0x10>
}
  80107b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80107e:	c9                   	leave  
  80107f:	c3                   	ret    

00801080 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801080:	f3 0f 1e fb          	endbr32 
  801084:	55                   	push   %ebp
  801085:	89 e5                	mov    %esp,%ebp
  801087:	57                   	push   %edi
  801088:	56                   	push   %esi
  801089:	53                   	push   %ebx
  80108a:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80108d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801090:	50                   	push   %eax
  801091:	ff 75 08             	pushl  0x8(%ebp)
  801094:	e8 4f fe ff ff       	call   800ee8 <fd_lookup>
  801099:	89 c3                	mov    %eax,%ebx
  80109b:	83 c4 10             	add    $0x10,%esp
  80109e:	85 c0                	test   %eax,%eax
  8010a0:	0f 88 81 00 00 00    	js     801127 <dup+0xa7>
		return r;
	close(newfdnum);
  8010a6:	83 ec 0c             	sub    $0xc,%esp
  8010a9:	ff 75 0c             	pushl  0xc(%ebp)
  8010ac:	e8 75 ff ff ff       	call   801026 <close>

	newfd = INDEX2FD(newfdnum);
  8010b1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010b4:	c1 e6 0c             	shl    $0xc,%esi
  8010b7:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8010bd:	83 c4 04             	add    $0x4,%esp
  8010c0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010c3:	e8 af fd ff ff       	call   800e77 <fd2data>
  8010c8:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8010ca:	89 34 24             	mov    %esi,(%esp)
  8010cd:	e8 a5 fd ff ff       	call   800e77 <fd2data>
  8010d2:	83 c4 10             	add    $0x10,%esp
  8010d5:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8010d7:	89 d8                	mov    %ebx,%eax
  8010d9:	c1 e8 16             	shr    $0x16,%eax
  8010dc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010e3:	a8 01                	test   $0x1,%al
  8010e5:	74 11                	je     8010f8 <dup+0x78>
  8010e7:	89 d8                	mov    %ebx,%eax
  8010e9:	c1 e8 0c             	shr    $0xc,%eax
  8010ec:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010f3:	f6 c2 01             	test   $0x1,%dl
  8010f6:	75 39                	jne    801131 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8010f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8010fb:	89 d0                	mov    %edx,%eax
  8010fd:	c1 e8 0c             	shr    $0xc,%eax
  801100:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801107:	83 ec 0c             	sub    $0xc,%esp
  80110a:	25 07 0e 00 00       	and    $0xe07,%eax
  80110f:	50                   	push   %eax
  801110:	56                   	push   %esi
  801111:	6a 00                	push   $0x0
  801113:	52                   	push   %edx
  801114:	6a 00                	push   $0x0
  801116:	e8 cf fa ff ff       	call   800bea <sys_page_map>
  80111b:	89 c3                	mov    %eax,%ebx
  80111d:	83 c4 20             	add    $0x20,%esp
  801120:	85 c0                	test   %eax,%eax
  801122:	78 31                	js     801155 <dup+0xd5>
		goto err;

	return newfdnum;
  801124:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801127:	89 d8                	mov    %ebx,%eax
  801129:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80112c:	5b                   	pop    %ebx
  80112d:	5e                   	pop    %esi
  80112e:	5f                   	pop    %edi
  80112f:	5d                   	pop    %ebp
  801130:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801131:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801138:	83 ec 0c             	sub    $0xc,%esp
  80113b:	25 07 0e 00 00       	and    $0xe07,%eax
  801140:	50                   	push   %eax
  801141:	57                   	push   %edi
  801142:	6a 00                	push   $0x0
  801144:	53                   	push   %ebx
  801145:	6a 00                	push   $0x0
  801147:	e8 9e fa ff ff       	call   800bea <sys_page_map>
  80114c:	89 c3                	mov    %eax,%ebx
  80114e:	83 c4 20             	add    $0x20,%esp
  801151:	85 c0                	test   %eax,%eax
  801153:	79 a3                	jns    8010f8 <dup+0x78>
	sys_page_unmap(0, newfd);
  801155:	83 ec 08             	sub    $0x8,%esp
  801158:	56                   	push   %esi
  801159:	6a 00                	push   $0x0
  80115b:	e8 d0 fa ff ff       	call   800c30 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801160:	83 c4 08             	add    $0x8,%esp
  801163:	57                   	push   %edi
  801164:	6a 00                	push   $0x0
  801166:	e8 c5 fa ff ff       	call   800c30 <sys_page_unmap>
	return r;
  80116b:	83 c4 10             	add    $0x10,%esp
  80116e:	eb b7                	jmp    801127 <dup+0xa7>

00801170 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801170:	f3 0f 1e fb          	endbr32 
  801174:	55                   	push   %ebp
  801175:	89 e5                	mov    %esp,%ebp
  801177:	53                   	push   %ebx
  801178:	83 ec 1c             	sub    $0x1c,%esp
  80117b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80117e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801181:	50                   	push   %eax
  801182:	53                   	push   %ebx
  801183:	e8 60 fd ff ff       	call   800ee8 <fd_lookup>
  801188:	83 c4 10             	add    $0x10,%esp
  80118b:	85 c0                	test   %eax,%eax
  80118d:	78 3f                	js     8011ce <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80118f:	83 ec 08             	sub    $0x8,%esp
  801192:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801195:	50                   	push   %eax
  801196:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801199:	ff 30                	pushl  (%eax)
  80119b:	e8 9c fd ff ff       	call   800f3c <dev_lookup>
  8011a0:	83 c4 10             	add    $0x10,%esp
  8011a3:	85 c0                	test   %eax,%eax
  8011a5:	78 27                	js     8011ce <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8011a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011aa:	8b 42 08             	mov    0x8(%edx),%eax
  8011ad:	83 e0 03             	and    $0x3,%eax
  8011b0:	83 f8 01             	cmp    $0x1,%eax
  8011b3:	74 1e                	je     8011d3 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8011b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011b8:	8b 40 08             	mov    0x8(%eax),%eax
  8011bb:	85 c0                	test   %eax,%eax
  8011bd:	74 35                	je     8011f4 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8011bf:	83 ec 04             	sub    $0x4,%esp
  8011c2:	ff 75 10             	pushl  0x10(%ebp)
  8011c5:	ff 75 0c             	pushl  0xc(%ebp)
  8011c8:	52                   	push   %edx
  8011c9:	ff d0                	call   *%eax
  8011cb:	83 c4 10             	add    $0x10,%esp
}
  8011ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011d1:	c9                   	leave  
  8011d2:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8011d3:	a1 08 40 80 00       	mov    0x804008,%eax
  8011d8:	8b 40 48             	mov    0x48(%eax),%eax
  8011db:	83 ec 04             	sub    $0x4,%esp
  8011de:	53                   	push   %ebx
  8011df:	50                   	push   %eax
  8011e0:	68 2d 28 80 00       	push   $0x80282d
  8011e5:	e8 6d ef ff ff       	call   800157 <cprintf>
		return -E_INVAL;
  8011ea:	83 c4 10             	add    $0x10,%esp
  8011ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011f2:	eb da                	jmp    8011ce <read+0x5e>
		return -E_NOT_SUPP;
  8011f4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011f9:	eb d3                	jmp    8011ce <read+0x5e>

008011fb <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8011fb:	f3 0f 1e fb          	endbr32 
  8011ff:	55                   	push   %ebp
  801200:	89 e5                	mov    %esp,%ebp
  801202:	57                   	push   %edi
  801203:	56                   	push   %esi
  801204:	53                   	push   %ebx
  801205:	83 ec 0c             	sub    $0xc,%esp
  801208:	8b 7d 08             	mov    0x8(%ebp),%edi
  80120b:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80120e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801213:	eb 02                	jmp    801217 <readn+0x1c>
  801215:	01 c3                	add    %eax,%ebx
  801217:	39 f3                	cmp    %esi,%ebx
  801219:	73 21                	jae    80123c <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80121b:	83 ec 04             	sub    $0x4,%esp
  80121e:	89 f0                	mov    %esi,%eax
  801220:	29 d8                	sub    %ebx,%eax
  801222:	50                   	push   %eax
  801223:	89 d8                	mov    %ebx,%eax
  801225:	03 45 0c             	add    0xc(%ebp),%eax
  801228:	50                   	push   %eax
  801229:	57                   	push   %edi
  80122a:	e8 41 ff ff ff       	call   801170 <read>
		if (m < 0)
  80122f:	83 c4 10             	add    $0x10,%esp
  801232:	85 c0                	test   %eax,%eax
  801234:	78 04                	js     80123a <readn+0x3f>
			return m;
		if (m == 0)
  801236:	75 dd                	jne    801215 <readn+0x1a>
  801238:	eb 02                	jmp    80123c <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80123a:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80123c:	89 d8                	mov    %ebx,%eax
  80123e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801241:	5b                   	pop    %ebx
  801242:	5e                   	pop    %esi
  801243:	5f                   	pop    %edi
  801244:	5d                   	pop    %ebp
  801245:	c3                   	ret    

00801246 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801246:	f3 0f 1e fb          	endbr32 
  80124a:	55                   	push   %ebp
  80124b:	89 e5                	mov    %esp,%ebp
  80124d:	53                   	push   %ebx
  80124e:	83 ec 1c             	sub    $0x1c,%esp
  801251:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801254:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801257:	50                   	push   %eax
  801258:	53                   	push   %ebx
  801259:	e8 8a fc ff ff       	call   800ee8 <fd_lookup>
  80125e:	83 c4 10             	add    $0x10,%esp
  801261:	85 c0                	test   %eax,%eax
  801263:	78 3a                	js     80129f <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801265:	83 ec 08             	sub    $0x8,%esp
  801268:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80126b:	50                   	push   %eax
  80126c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80126f:	ff 30                	pushl  (%eax)
  801271:	e8 c6 fc ff ff       	call   800f3c <dev_lookup>
  801276:	83 c4 10             	add    $0x10,%esp
  801279:	85 c0                	test   %eax,%eax
  80127b:	78 22                	js     80129f <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80127d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801280:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801284:	74 1e                	je     8012a4 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801286:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801289:	8b 52 0c             	mov    0xc(%edx),%edx
  80128c:	85 d2                	test   %edx,%edx
  80128e:	74 35                	je     8012c5 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801290:	83 ec 04             	sub    $0x4,%esp
  801293:	ff 75 10             	pushl  0x10(%ebp)
  801296:	ff 75 0c             	pushl  0xc(%ebp)
  801299:	50                   	push   %eax
  80129a:	ff d2                	call   *%edx
  80129c:	83 c4 10             	add    $0x10,%esp
}
  80129f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012a2:	c9                   	leave  
  8012a3:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8012a4:	a1 08 40 80 00       	mov    0x804008,%eax
  8012a9:	8b 40 48             	mov    0x48(%eax),%eax
  8012ac:	83 ec 04             	sub    $0x4,%esp
  8012af:	53                   	push   %ebx
  8012b0:	50                   	push   %eax
  8012b1:	68 49 28 80 00       	push   $0x802849
  8012b6:	e8 9c ee ff ff       	call   800157 <cprintf>
		return -E_INVAL;
  8012bb:	83 c4 10             	add    $0x10,%esp
  8012be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012c3:	eb da                	jmp    80129f <write+0x59>
		return -E_NOT_SUPP;
  8012c5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012ca:	eb d3                	jmp    80129f <write+0x59>

008012cc <seek>:

int
seek(int fdnum, off_t offset)
{
  8012cc:	f3 0f 1e fb          	endbr32 
  8012d0:	55                   	push   %ebp
  8012d1:	89 e5                	mov    %esp,%ebp
  8012d3:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012d9:	50                   	push   %eax
  8012da:	ff 75 08             	pushl  0x8(%ebp)
  8012dd:	e8 06 fc ff ff       	call   800ee8 <fd_lookup>
  8012e2:	83 c4 10             	add    $0x10,%esp
  8012e5:	85 c0                	test   %eax,%eax
  8012e7:	78 0e                	js     8012f7 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8012e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ef:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8012f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012f7:	c9                   	leave  
  8012f8:	c3                   	ret    

008012f9 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8012f9:	f3 0f 1e fb          	endbr32 
  8012fd:	55                   	push   %ebp
  8012fe:	89 e5                	mov    %esp,%ebp
  801300:	53                   	push   %ebx
  801301:	83 ec 1c             	sub    $0x1c,%esp
  801304:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801307:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80130a:	50                   	push   %eax
  80130b:	53                   	push   %ebx
  80130c:	e8 d7 fb ff ff       	call   800ee8 <fd_lookup>
  801311:	83 c4 10             	add    $0x10,%esp
  801314:	85 c0                	test   %eax,%eax
  801316:	78 37                	js     80134f <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801318:	83 ec 08             	sub    $0x8,%esp
  80131b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80131e:	50                   	push   %eax
  80131f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801322:	ff 30                	pushl  (%eax)
  801324:	e8 13 fc ff ff       	call   800f3c <dev_lookup>
  801329:	83 c4 10             	add    $0x10,%esp
  80132c:	85 c0                	test   %eax,%eax
  80132e:	78 1f                	js     80134f <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801330:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801333:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801337:	74 1b                	je     801354 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801339:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80133c:	8b 52 18             	mov    0x18(%edx),%edx
  80133f:	85 d2                	test   %edx,%edx
  801341:	74 32                	je     801375 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801343:	83 ec 08             	sub    $0x8,%esp
  801346:	ff 75 0c             	pushl  0xc(%ebp)
  801349:	50                   	push   %eax
  80134a:	ff d2                	call   *%edx
  80134c:	83 c4 10             	add    $0x10,%esp
}
  80134f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801352:	c9                   	leave  
  801353:	c3                   	ret    
			thisenv->env_id, fdnum);
  801354:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801359:	8b 40 48             	mov    0x48(%eax),%eax
  80135c:	83 ec 04             	sub    $0x4,%esp
  80135f:	53                   	push   %ebx
  801360:	50                   	push   %eax
  801361:	68 0c 28 80 00       	push   $0x80280c
  801366:	e8 ec ed ff ff       	call   800157 <cprintf>
		return -E_INVAL;
  80136b:	83 c4 10             	add    $0x10,%esp
  80136e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801373:	eb da                	jmp    80134f <ftruncate+0x56>
		return -E_NOT_SUPP;
  801375:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80137a:	eb d3                	jmp    80134f <ftruncate+0x56>

0080137c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80137c:	f3 0f 1e fb          	endbr32 
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
  801383:	53                   	push   %ebx
  801384:	83 ec 1c             	sub    $0x1c,%esp
  801387:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80138a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80138d:	50                   	push   %eax
  80138e:	ff 75 08             	pushl  0x8(%ebp)
  801391:	e8 52 fb ff ff       	call   800ee8 <fd_lookup>
  801396:	83 c4 10             	add    $0x10,%esp
  801399:	85 c0                	test   %eax,%eax
  80139b:	78 4b                	js     8013e8 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80139d:	83 ec 08             	sub    $0x8,%esp
  8013a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013a3:	50                   	push   %eax
  8013a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a7:	ff 30                	pushl  (%eax)
  8013a9:	e8 8e fb ff ff       	call   800f3c <dev_lookup>
  8013ae:	83 c4 10             	add    $0x10,%esp
  8013b1:	85 c0                	test   %eax,%eax
  8013b3:	78 33                	js     8013e8 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8013b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013b8:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8013bc:	74 2f                	je     8013ed <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8013be:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8013c1:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8013c8:	00 00 00 
	stat->st_isdir = 0;
  8013cb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8013d2:	00 00 00 
	stat->st_dev = dev;
  8013d5:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8013db:	83 ec 08             	sub    $0x8,%esp
  8013de:	53                   	push   %ebx
  8013df:	ff 75 f0             	pushl  -0x10(%ebp)
  8013e2:	ff 50 14             	call   *0x14(%eax)
  8013e5:	83 c4 10             	add    $0x10,%esp
}
  8013e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013eb:	c9                   	leave  
  8013ec:	c3                   	ret    
		return -E_NOT_SUPP;
  8013ed:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013f2:	eb f4                	jmp    8013e8 <fstat+0x6c>

008013f4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8013f4:	f3 0f 1e fb          	endbr32 
  8013f8:	55                   	push   %ebp
  8013f9:	89 e5                	mov    %esp,%ebp
  8013fb:	56                   	push   %esi
  8013fc:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8013fd:	83 ec 08             	sub    $0x8,%esp
  801400:	6a 00                	push   $0x0
  801402:	ff 75 08             	pushl  0x8(%ebp)
  801405:	e8 fb 01 00 00       	call   801605 <open>
  80140a:	89 c3                	mov    %eax,%ebx
  80140c:	83 c4 10             	add    $0x10,%esp
  80140f:	85 c0                	test   %eax,%eax
  801411:	78 1b                	js     80142e <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801413:	83 ec 08             	sub    $0x8,%esp
  801416:	ff 75 0c             	pushl  0xc(%ebp)
  801419:	50                   	push   %eax
  80141a:	e8 5d ff ff ff       	call   80137c <fstat>
  80141f:	89 c6                	mov    %eax,%esi
	close(fd);
  801421:	89 1c 24             	mov    %ebx,(%esp)
  801424:	e8 fd fb ff ff       	call   801026 <close>
	return r;
  801429:	83 c4 10             	add    $0x10,%esp
  80142c:	89 f3                	mov    %esi,%ebx
}
  80142e:	89 d8                	mov    %ebx,%eax
  801430:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801433:	5b                   	pop    %ebx
  801434:	5e                   	pop    %esi
  801435:	5d                   	pop    %ebp
  801436:	c3                   	ret    

00801437 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801437:	55                   	push   %ebp
  801438:	89 e5                	mov    %esp,%ebp
  80143a:	56                   	push   %esi
  80143b:	53                   	push   %ebx
  80143c:	89 c6                	mov    %eax,%esi
  80143e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801440:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801447:	74 27                	je     801470 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801449:	6a 07                	push   $0x7
  80144b:	68 00 50 80 00       	push   $0x805000
  801450:	56                   	push   %esi
  801451:	ff 35 00 40 80 00    	pushl  0x804000
  801457:	e8 d8 0c 00 00       	call   802134 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80145c:	83 c4 0c             	add    $0xc,%esp
  80145f:	6a 00                	push   $0x0
  801461:	53                   	push   %ebx
  801462:	6a 00                	push   $0x0
  801464:	e8 46 0c 00 00       	call   8020af <ipc_recv>
}
  801469:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80146c:	5b                   	pop    %ebx
  80146d:	5e                   	pop    %esi
  80146e:	5d                   	pop    %ebp
  80146f:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801470:	83 ec 0c             	sub    $0xc,%esp
  801473:	6a 01                	push   $0x1
  801475:	e8 12 0d 00 00       	call   80218c <ipc_find_env>
  80147a:	a3 00 40 80 00       	mov    %eax,0x804000
  80147f:	83 c4 10             	add    $0x10,%esp
  801482:	eb c5                	jmp    801449 <fsipc+0x12>

00801484 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801484:	f3 0f 1e fb          	endbr32 
  801488:	55                   	push   %ebp
  801489:	89 e5                	mov    %esp,%ebp
  80148b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80148e:	8b 45 08             	mov    0x8(%ebp),%eax
  801491:	8b 40 0c             	mov    0xc(%eax),%eax
  801494:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801499:	8b 45 0c             	mov    0xc(%ebp),%eax
  80149c:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8014a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8014a6:	b8 02 00 00 00       	mov    $0x2,%eax
  8014ab:	e8 87 ff ff ff       	call   801437 <fsipc>
}
  8014b0:	c9                   	leave  
  8014b1:	c3                   	ret    

008014b2 <devfile_flush>:
{
  8014b2:	f3 0f 1e fb          	endbr32 
  8014b6:	55                   	push   %ebp
  8014b7:	89 e5                	mov    %esp,%ebp
  8014b9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8014bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8014c2:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8014c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8014cc:	b8 06 00 00 00       	mov    $0x6,%eax
  8014d1:	e8 61 ff ff ff       	call   801437 <fsipc>
}
  8014d6:	c9                   	leave  
  8014d7:	c3                   	ret    

008014d8 <devfile_stat>:
{
  8014d8:	f3 0f 1e fb          	endbr32 
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
  8014df:	53                   	push   %ebx
  8014e0:	83 ec 04             	sub    $0x4,%esp
  8014e3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8014ec:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8014f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8014f6:	b8 05 00 00 00       	mov    $0x5,%eax
  8014fb:	e8 37 ff ff ff       	call   801437 <fsipc>
  801500:	85 c0                	test   %eax,%eax
  801502:	78 2c                	js     801530 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801504:	83 ec 08             	sub    $0x8,%esp
  801507:	68 00 50 80 00       	push   $0x805000
  80150c:	53                   	push   %ebx
  80150d:	e8 4f f2 ff ff       	call   800761 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801512:	a1 80 50 80 00       	mov    0x805080,%eax
  801517:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80151d:	a1 84 50 80 00       	mov    0x805084,%eax
  801522:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801528:	83 c4 10             	add    $0x10,%esp
  80152b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801530:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801533:	c9                   	leave  
  801534:	c3                   	ret    

00801535 <devfile_write>:
{
  801535:	f3 0f 1e fb          	endbr32 
  801539:	55                   	push   %ebp
  80153a:	89 e5                	mov    %esp,%ebp
  80153c:	83 ec 0c             	sub    $0xc,%esp
  80153f:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801542:	8b 55 08             	mov    0x8(%ebp),%edx
  801545:	8b 52 0c             	mov    0xc(%edx),%edx
  801548:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  80154e:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801553:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801558:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  80155b:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801560:	50                   	push   %eax
  801561:	ff 75 0c             	pushl  0xc(%ebp)
  801564:	68 08 50 80 00       	push   $0x805008
  801569:	e8 a9 f3 ff ff       	call   800917 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  80156e:	ba 00 00 00 00       	mov    $0x0,%edx
  801573:	b8 04 00 00 00       	mov    $0x4,%eax
  801578:	e8 ba fe ff ff       	call   801437 <fsipc>
}
  80157d:	c9                   	leave  
  80157e:	c3                   	ret    

0080157f <devfile_read>:
{
  80157f:	f3 0f 1e fb          	endbr32 
  801583:	55                   	push   %ebp
  801584:	89 e5                	mov    %esp,%ebp
  801586:	56                   	push   %esi
  801587:	53                   	push   %ebx
  801588:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80158b:	8b 45 08             	mov    0x8(%ebp),%eax
  80158e:	8b 40 0c             	mov    0xc(%eax),%eax
  801591:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801596:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80159c:	ba 00 00 00 00       	mov    $0x0,%edx
  8015a1:	b8 03 00 00 00       	mov    $0x3,%eax
  8015a6:	e8 8c fe ff ff       	call   801437 <fsipc>
  8015ab:	89 c3                	mov    %eax,%ebx
  8015ad:	85 c0                	test   %eax,%eax
  8015af:	78 1f                	js     8015d0 <devfile_read+0x51>
	assert(r <= n);
  8015b1:	39 f0                	cmp    %esi,%eax
  8015b3:	77 24                	ja     8015d9 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8015b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8015ba:	7f 33                	jg     8015ef <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8015bc:	83 ec 04             	sub    $0x4,%esp
  8015bf:	50                   	push   %eax
  8015c0:	68 00 50 80 00       	push   $0x805000
  8015c5:	ff 75 0c             	pushl  0xc(%ebp)
  8015c8:	e8 4a f3 ff ff       	call   800917 <memmove>
	return r;
  8015cd:	83 c4 10             	add    $0x10,%esp
}
  8015d0:	89 d8                	mov    %ebx,%eax
  8015d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015d5:	5b                   	pop    %ebx
  8015d6:	5e                   	pop    %esi
  8015d7:	5d                   	pop    %ebp
  8015d8:	c3                   	ret    
	assert(r <= n);
  8015d9:	68 7c 28 80 00       	push   $0x80287c
  8015de:	68 83 28 80 00       	push   $0x802883
  8015e3:	6a 7c                	push   $0x7c
  8015e5:	68 98 28 80 00       	push   $0x802898
  8015ea:	e8 76 0a 00 00       	call   802065 <_panic>
	assert(r <= PGSIZE);
  8015ef:	68 a3 28 80 00       	push   $0x8028a3
  8015f4:	68 83 28 80 00       	push   $0x802883
  8015f9:	6a 7d                	push   $0x7d
  8015fb:	68 98 28 80 00       	push   $0x802898
  801600:	e8 60 0a 00 00       	call   802065 <_panic>

00801605 <open>:
{
  801605:	f3 0f 1e fb          	endbr32 
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
  80160c:	56                   	push   %esi
  80160d:	53                   	push   %ebx
  80160e:	83 ec 1c             	sub    $0x1c,%esp
  801611:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801614:	56                   	push   %esi
  801615:	e8 04 f1 ff ff       	call   80071e <strlen>
  80161a:	83 c4 10             	add    $0x10,%esp
  80161d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801622:	7f 6c                	jg     801690 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801624:	83 ec 0c             	sub    $0xc,%esp
  801627:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80162a:	50                   	push   %eax
  80162b:	e8 62 f8 ff ff       	call   800e92 <fd_alloc>
  801630:	89 c3                	mov    %eax,%ebx
  801632:	83 c4 10             	add    $0x10,%esp
  801635:	85 c0                	test   %eax,%eax
  801637:	78 3c                	js     801675 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801639:	83 ec 08             	sub    $0x8,%esp
  80163c:	56                   	push   %esi
  80163d:	68 00 50 80 00       	push   $0x805000
  801642:	e8 1a f1 ff ff       	call   800761 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801647:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164a:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80164f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801652:	b8 01 00 00 00       	mov    $0x1,%eax
  801657:	e8 db fd ff ff       	call   801437 <fsipc>
  80165c:	89 c3                	mov    %eax,%ebx
  80165e:	83 c4 10             	add    $0x10,%esp
  801661:	85 c0                	test   %eax,%eax
  801663:	78 19                	js     80167e <open+0x79>
	return fd2num(fd);
  801665:	83 ec 0c             	sub    $0xc,%esp
  801668:	ff 75 f4             	pushl  -0xc(%ebp)
  80166b:	e8 f3 f7 ff ff       	call   800e63 <fd2num>
  801670:	89 c3                	mov    %eax,%ebx
  801672:	83 c4 10             	add    $0x10,%esp
}
  801675:	89 d8                	mov    %ebx,%eax
  801677:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80167a:	5b                   	pop    %ebx
  80167b:	5e                   	pop    %esi
  80167c:	5d                   	pop    %ebp
  80167d:	c3                   	ret    
		fd_close(fd, 0);
  80167e:	83 ec 08             	sub    $0x8,%esp
  801681:	6a 00                	push   $0x0
  801683:	ff 75 f4             	pushl  -0xc(%ebp)
  801686:	e8 10 f9 ff ff       	call   800f9b <fd_close>
		return r;
  80168b:	83 c4 10             	add    $0x10,%esp
  80168e:	eb e5                	jmp    801675 <open+0x70>
		return -E_BAD_PATH;
  801690:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801695:	eb de                	jmp    801675 <open+0x70>

00801697 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801697:	f3 0f 1e fb          	endbr32 
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
  80169e:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8016a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a6:	b8 08 00 00 00       	mov    $0x8,%eax
  8016ab:	e8 87 fd ff ff       	call   801437 <fsipc>
}
  8016b0:	c9                   	leave  
  8016b1:	c3                   	ret    

008016b2 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8016b2:	f3 0f 1e fb          	endbr32 
  8016b6:	55                   	push   %ebp
  8016b7:	89 e5                	mov    %esp,%ebp
  8016b9:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8016bc:	68 af 28 80 00       	push   $0x8028af
  8016c1:	ff 75 0c             	pushl  0xc(%ebp)
  8016c4:	e8 98 f0 ff ff       	call   800761 <strcpy>
	return 0;
}
  8016c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ce:	c9                   	leave  
  8016cf:	c3                   	ret    

008016d0 <devsock_close>:
{
  8016d0:	f3 0f 1e fb          	endbr32 
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
  8016d7:	53                   	push   %ebx
  8016d8:	83 ec 10             	sub    $0x10,%esp
  8016db:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8016de:	53                   	push   %ebx
  8016df:	e8 e5 0a 00 00       	call   8021c9 <pageref>
  8016e4:	89 c2                	mov    %eax,%edx
  8016e6:	83 c4 10             	add    $0x10,%esp
		return 0;
  8016e9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  8016ee:	83 fa 01             	cmp    $0x1,%edx
  8016f1:	74 05                	je     8016f8 <devsock_close+0x28>
}
  8016f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016f6:	c9                   	leave  
  8016f7:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8016f8:	83 ec 0c             	sub    $0xc,%esp
  8016fb:	ff 73 0c             	pushl  0xc(%ebx)
  8016fe:	e8 e3 02 00 00       	call   8019e6 <nsipc_close>
  801703:	83 c4 10             	add    $0x10,%esp
  801706:	eb eb                	jmp    8016f3 <devsock_close+0x23>

00801708 <devsock_write>:
{
  801708:	f3 0f 1e fb          	endbr32 
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
  80170f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801712:	6a 00                	push   $0x0
  801714:	ff 75 10             	pushl  0x10(%ebp)
  801717:	ff 75 0c             	pushl  0xc(%ebp)
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	ff 70 0c             	pushl  0xc(%eax)
  801720:	e8 b5 03 00 00       	call   801ada <nsipc_send>
}
  801725:	c9                   	leave  
  801726:	c3                   	ret    

00801727 <devsock_read>:
{
  801727:	f3 0f 1e fb          	endbr32 
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
  80172e:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801731:	6a 00                	push   $0x0
  801733:	ff 75 10             	pushl  0x10(%ebp)
  801736:	ff 75 0c             	pushl  0xc(%ebp)
  801739:	8b 45 08             	mov    0x8(%ebp),%eax
  80173c:	ff 70 0c             	pushl  0xc(%eax)
  80173f:	e8 1f 03 00 00       	call   801a63 <nsipc_recv>
}
  801744:	c9                   	leave  
  801745:	c3                   	ret    

00801746 <fd2sockid>:
{
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
  801749:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80174c:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80174f:	52                   	push   %edx
  801750:	50                   	push   %eax
  801751:	e8 92 f7 ff ff       	call   800ee8 <fd_lookup>
  801756:	83 c4 10             	add    $0x10,%esp
  801759:	85 c0                	test   %eax,%eax
  80175b:	78 10                	js     80176d <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80175d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801760:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801766:	39 08                	cmp    %ecx,(%eax)
  801768:	75 05                	jne    80176f <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80176a:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80176d:	c9                   	leave  
  80176e:	c3                   	ret    
		return -E_NOT_SUPP;
  80176f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801774:	eb f7                	jmp    80176d <fd2sockid+0x27>

00801776 <alloc_sockfd>:
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
  801779:	56                   	push   %esi
  80177a:	53                   	push   %ebx
  80177b:	83 ec 1c             	sub    $0x1c,%esp
  80177e:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801780:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801783:	50                   	push   %eax
  801784:	e8 09 f7 ff ff       	call   800e92 <fd_alloc>
  801789:	89 c3                	mov    %eax,%ebx
  80178b:	83 c4 10             	add    $0x10,%esp
  80178e:	85 c0                	test   %eax,%eax
  801790:	78 43                	js     8017d5 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801792:	83 ec 04             	sub    $0x4,%esp
  801795:	68 07 04 00 00       	push   $0x407
  80179a:	ff 75 f4             	pushl  -0xc(%ebp)
  80179d:	6a 00                	push   $0x0
  80179f:	e8 ff f3 ff ff       	call   800ba3 <sys_page_alloc>
  8017a4:	89 c3                	mov    %eax,%ebx
  8017a6:	83 c4 10             	add    $0x10,%esp
  8017a9:	85 c0                	test   %eax,%eax
  8017ab:	78 28                	js     8017d5 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8017ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b0:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8017b6:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8017b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017bb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8017c2:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8017c5:	83 ec 0c             	sub    $0xc,%esp
  8017c8:	50                   	push   %eax
  8017c9:	e8 95 f6 ff ff       	call   800e63 <fd2num>
  8017ce:	89 c3                	mov    %eax,%ebx
  8017d0:	83 c4 10             	add    $0x10,%esp
  8017d3:	eb 0c                	jmp    8017e1 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8017d5:	83 ec 0c             	sub    $0xc,%esp
  8017d8:	56                   	push   %esi
  8017d9:	e8 08 02 00 00       	call   8019e6 <nsipc_close>
		return r;
  8017de:	83 c4 10             	add    $0x10,%esp
}
  8017e1:	89 d8                	mov    %ebx,%eax
  8017e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017e6:	5b                   	pop    %ebx
  8017e7:	5e                   	pop    %esi
  8017e8:	5d                   	pop    %ebp
  8017e9:	c3                   	ret    

008017ea <accept>:
{
  8017ea:	f3 0f 1e fb          	endbr32 
  8017ee:	55                   	push   %ebp
  8017ef:	89 e5                	mov    %esp,%ebp
  8017f1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8017f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f7:	e8 4a ff ff ff       	call   801746 <fd2sockid>
  8017fc:	85 c0                	test   %eax,%eax
  8017fe:	78 1b                	js     80181b <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801800:	83 ec 04             	sub    $0x4,%esp
  801803:	ff 75 10             	pushl  0x10(%ebp)
  801806:	ff 75 0c             	pushl  0xc(%ebp)
  801809:	50                   	push   %eax
  80180a:	e8 22 01 00 00       	call   801931 <nsipc_accept>
  80180f:	83 c4 10             	add    $0x10,%esp
  801812:	85 c0                	test   %eax,%eax
  801814:	78 05                	js     80181b <accept+0x31>
	return alloc_sockfd(r);
  801816:	e8 5b ff ff ff       	call   801776 <alloc_sockfd>
}
  80181b:	c9                   	leave  
  80181c:	c3                   	ret    

0080181d <bind>:
{
  80181d:	f3 0f 1e fb          	endbr32 
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
  801824:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801827:	8b 45 08             	mov    0x8(%ebp),%eax
  80182a:	e8 17 ff ff ff       	call   801746 <fd2sockid>
  80182f:	85 c0                	test   %eax,%eax
  801831:	78 12                	js     801845 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801833:	83 ec 04             	sub    $0x4,%esp
  801836:	ff 75 10             	pushl  0x10(%ebp)
  801839:	ff 75 0c             	pushl  0xc(%ebp)
  80183c:	50                   	push   %eax
  80183d:	e8 45 01 00 00       	call   801987 <nsipc_bind>
  801842:	83 c4 10             	add    $0x10,%esp
}
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <shutdown>:
{
  801847:	f3 0f 1e fb          	endbr32 
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
  80184e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801851:	8b 45 08             	mov    0x8(%ebp),%eax
  801854:	e8 ed fe ff ff       	call   801746 <fd2sockid>
  801859:	85 c0                	test   %eax,%eax
  80185b:	78 0f                	js     80186c <shutdown+0x25>
	return nsipc_shutdown(r, how);
  80185d:	83 ec 08             	sub    $0x8,%esp
  801860:	ff 75 0c             	pushl  0xc(%ebp)
  801863:	50                   	push   %eax
  801864:	e8 57 01 00 00       	call   8019c0 <nsipc_shutdown>
  801869:	83 c4 10             	add    $0x10,%esp
}
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    

0080186e <connect>:
{
  80186e:	f3 0f 1e fb          	endbr32 
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801878:	8b 45 08             	mov    0x8(%ebp),%eax
  80187b:	e8 c6 fe ff ff       	call   801746 <fd2sockid>
  801880:	85 c0                	test   %eax,%eax
  801882:	78 12                	js     801896 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801884:	83 ec 04             	sub    $0x4,%esp
  801887:	ff 75 10             	pushl  0x10(%ebp)
  80188a:	ff 75 0c             	pushl  0xc(%ebp)
  80188d:	50                   	push   %eax
  80188e:	e8 71 01 00 00       	call   801a04 <nsipc_connect>
  801893:	83 c4 10             	add    $0x10,%esp
}
  801896:	c9                   	leave  
  801897:	c3                   	ret    

00801898 <listen>:
{
  801898:	f3 0f 1e fb          	endbr32 
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
  80189f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8018a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a5:	e8 9c fe ff ff       	call   801746 <fd2sockid>
  8018aa:	85 c0                	test   %eax,%eax
  8018ac:	78 0f                	js     8018bd <listen+0x25>
	return nsipc_listen(r, backlog);
  8018ae:	83 ec 08             	sub    $0x8,%esp
  8018b1:	ff 75 0c             	pushl  0xc(%ebp)
  8018b4:	50                   	push   %eax
  8018b5:	e8 83 01 00 00       	call   801a3d <nsipc_listen>
  8018ba:	83 c4 10             	add    $0x10,%esp
}
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <socket>:

int
socket(int domain, int type, int protocol)
{
  8018bf:	f3 0f 1e fb          	endbr32 
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
  8018c6:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8018c9:	ff 75 10             	pushl  0x10(%ebp)
  8018cc:	ff 75 0c             	pushl  0xc(%ebp)
  8018cf:	ff 75 08             	pushl  0x8(%ebp)
  8018d2:	e8 65 02 00 00       	call   801b3c <nsipc_socket>
  8018d7:	83 c4 10             	add    $0x10,%esp
  8018da:	85 c0                	test   %eax,%eax
  8018dc:	78 05                	js     8018e3 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  8018de:	e8 93 fe ff ff       	call   801776 <alloc_sockfd>
}
  8018e3:	c9                   	leave  
  8018e4:	c3                   	ret    

008018e5 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
  8018e8:	53                   	push   %ebx
  8018e9:	83 ec 04             	sub    $0x4,%esp
  8018ec:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8018ee:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8018f5:	74 26                	je     80191d <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8018f7:	6a 07                	push   $0x7
  8018f9:	68 00 60 80 00       	push   $0x806000
  8018fe:	53                   	push   %ebx
  8018ff:	ff 35 04 40 80 00    	pushl  0x804004
  801905:	e8 2a 08 00 00       	call   802134 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80190a:	83 c4 0c             	add    $0xc,%esp
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	e8 97 07 00 00       	call   8020af <ipc_recv>
}
  801918:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80191d:	83 ec 0c             	sub    $0xc,%esp
  801920:	6a 02                	push   $0x2
  801922:	e8 65 08 00 00       	call   80218c <ipc_find_env>
  801927:	a3 04 40 80 00       	mov    %eax,0x804004
  80192c:	83 c4 10             	add    $0x10,%esp
  80192f:	eb c6                	jmp    8018f7 <nsipc+0x12>

00801931 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801931:	f3 0f 1e fb          	endbr32 
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
  801938:	56                   	push   %esi
  801939:	53                   	push   %ebx
  80193a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80193d:	8b 45 08             	mov    0x8(%ebp),%eax
  801940:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801945:	8b 06                	mov    (%esi),%eax
  801947:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80194c:	b8 01 00 00 00       	mov    $0x1,%eax
  801951:	e8 8f ff ff ff       	call   8018e5 <nsipc>
  801956:	89 c3                	mov    %eax,%ebx
  801958:	85 c0                	test   %eax,%eax
  80195a:	79 09                	jns    801965 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80195c:	89 d8                	mov    %ebx,%eax
  80195e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801961:	5b                   	pop    %ebx
  801962:	5e                   	pop    %esi
  801963:	5d                   	pop    %ebp
  801964:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801965:	83 ec 04             	sub    $0x4,%esp
  801968:	ff 35 10 60 80 00    	pushl  0x806010
  80196e:	68 00 60 80 00       	push   $0x806000
  801973:	ff 75 0c             	pushl  0xc(%ebp)
  801976:	e8 9c ef ff ff       	call   800917 <memmove>
		*addrlen = ret->ret_addrlen;
  80197b:	a1 10 60 80 00       	mov    0x806010,%eax
  801980:	89 06                	mov    %eax,(%esi)
  801982:	83 c4 10             	add    $0x10,%esp
	return r;
  801985:	eb d5                	jmp    80195c <nsipc_accept+0x2b>

00801987 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801987:	f3 0f 1e fb          	endbr32 
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
  80198e:	53                   	push   %ebx
  80198f:	83 ec 08             	sub    $0x8,%esp
  801992:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801995:	8b 45 08             	mov    0x8(%ebp),%eax
  801998:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80199d:	53                   	push   %ebx
  80199e:	ff 75 0c             	pushl  0xc(%ebp)
  8019a1:	68 04 60 80 00       	push   $0x806004
  8019a6:	e8 6c ef ff ff       	call   800917 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8019ab:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8019b1:	b8 02 00 00 00       	mov    $0x2,%eax
  8019b6:	e8 2a ff ff ff       	call   8018e5 <nsipc>
}
  8019bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8019c0:	f3 0f 1e fb          	endbr32 
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
  8019c7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8019ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cd:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8019d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d5:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8019da:	b8 03 00 00 00       	mov    $0x3,%eax
  8019df:	e8 01 ff ff ff       	call   8018e5 <nsipc>
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <nsipc_close>:

int
nsipc_close(int s)
{
  8019e6:	f3 0f 1e fb          	endbr32 
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
  8019ed:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8019f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f3:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8019f8:	b8 04 00 00 00       	mov    $0x4,%eax
  8019fd:	e8 e3 fe ff ff       	call   8018e5 <nsipc>
}
  801a02:	c9                   	leave  
  801a03:	c3                   	ret    

00801a04 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801a04:	f3 0f 1e fb          	endbr32 
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
  801a0b:	53                   	push   %ebx
  801a0c:	83 ec 08             	sub    $0x8,%esp
  801a0f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801a12:	8b 45 08             	mov    0x8(%ebp),%eax
  801a15:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801a1a:	53                   	push   %ebx
  801a1b:	ff 75 0c             	pushl  0xc(%ebp)
  801a1e:	68 04 60 80 00       	push   $0x806004
  801a23:	e8 ef ee ff ff       	call   800917 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801a28:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801a2e:	b8 05 00 00 00       	mov    $0x5,%eax
  801a33:	e8 ad fe ff ff       	call   8018e5 <nsipc>
}
  801a38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a3b:	c9                   	leave  
  801a3c:	c3                   	ret    

00801a3d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801a3d:	f3 0f 1e fb          	endbr32 
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
  801a44:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801a47:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801a4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a52:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801a57:	b8 06 00 00 00       	mov    $0x6,%eax
  801a5c:	e8 84 fe ff ff       	call   8018e5 <nsipc>
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801a63:	f3 0f 1e fb          	endbr32 
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
  801a6a:	56                   	push   %esi
  801a6b:	53                   	push   %ebx
  801a6c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a72:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801a77:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801a7d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a80:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801a85:	b8 07 00 00 00       	mov    $0x7,%eax
  801a8a:	e8 56 fe ff ff       	call   8018e5 <nsipc>
  801a8f:	89 c3                	mov    %eax,%ebx
  801a91:	85 c0                	test   %eax,%eax
  801a93:	78 26                	js     801abb <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801a95:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801a9b:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801aa0:	0f 4e c6             	cmovle %esi,%eax
  801aa3:	39 c3                	cmp    %eax,%ebx
  801aa5:	7f 1d                	jg     801ac4 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801aa7:	83 ec 04             	sub    $0x4,%esp
  801aaa:	53                   	push   %ebx
  801aab:	68 00 60 80 00       	push   $0x806000
  801ab0:	ff 75 0c             	pushl  0xc(%ebp)
  801ab3:	e8 5f ee ff ff       	call   800917 <memmove>
  801ab8:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801abb:	89 d8                	mov    %ebx,%eax
  801abd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ac0:	5b                   	pop    %ebx
  801ac1:	5e                   	pop    %esi
  801ac2:	5d                   	pop    %ebp
  801ac3:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801ac4:	68 bb 28 80 00       	push   $0x8028bb
  801ac9:	68 83 28 80 00       	push   $0x802883
  801ace:	6a 62                	push   $0x62
  801ad0:	68 d0 28 80 00       	push   $0x8028d0
  801ad5:	e8 8b 05 00 00       	call   802065 <_panic>

00801ada <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801ada:	f3 0f 1e fb          	endbr32 
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
  801ae1:	53                   	push   %ebx
  801ae2:	83 ec 04             	sub    $0x4,%esp
  801ae5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aeb:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801af0:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801af6:	7f 2e                	jg     801b26 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801af8:	83 ec 04             	sub    $0x4,%esp
  801afb:	53                   	push   %ebx
  801afc:	ff 75 0c             	pushl  0xc(%ebp)
  801aff:	68 0c 60 80 00       	push   $0x80600c
  801b04:	e8 0e ee ff ff       	call   800917 <memmove>
	nsipcbuf.send.req_size = size;
  801b09:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801b0f:	8b 45 14             	mov    0x14(%ebp),%eax
  801b12:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801b17:	b8 08 00 00 00       	mov    $0x8,%eax
  801b1c:	e8 c4 fd ff ff       	call   8018e5 <nsipc>
}
  801b21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b24:	c9                   	leave  
  801b25:	c3                   	ret    
	assert(size < 1600);
  801b26:	68 dc 28 80 00       	push   $0x8028dc
  801b2b:	68 83 28 80 00       	push   $0x802883
  801b30:	6a 6d                	push   $0x6d
  801b32:	68 d0 28 80 00       	push   $0x8028d0
  801b37:	e8 29 05 00 00       	call   802065 <_panic>

00801b3c <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801b3c:	f3 0f 1e fb          	endbr32 
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
  801b43:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801b46:	8b 45 08             	mov    0x8(%ebp),%eax
  801b49:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801b4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b51:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801b56:	8b 45 10             	mov    0x10(%ebp),%eax
  801b59:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801b5e:	b8 09 00 00 00       	mov    $0x9,%eax
  801b63:	e8 7d fd ff ff       	call   8018e5 <nsipc>
}
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    

00801b6a <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b6a:	f3 0f 1e fb          	endbr32 
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
  801b71:	56                   	push   %esi
  801b72:	53                   	push   %ebx
  801b73:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b76:	83 ec 0c             	sub    $0xc,%esp
  801b79:	ff 75 08             	pushl  0x8(%ebp)
  801b7c:	e8 f6 f2 ff ff       	call   800e77 <fd2data>
  801b81:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b83:	83 c4 08             	add    $0x8,%esp
  801b86:	68 e8 28 80 00       	push   $0x8028e8
  801b8b:	53                   	push   %ebx
  801b8c:	e8 d0 eb ff ff       	call   800761 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b91:	8b 46 04             	mov    0x4(%esi),%eax
  801b94:	2b 06                	sub    (%esi),%eax
  801b96:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b9c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ba3:	00 00 00 
	stat->st_dev = &devpipe;
  801ba6:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801bad:	30 80 00 
	return 0;
}
  801bb0:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bb8:	5b                   	pop    %ebx
  801bb9:	5e                   	pop    %esi
  801bba:	5d                   	pop    %ebp
  801bbb:	c3                   	ret    

00801bbc <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801bbc:	f3 0f 1e fb          	endbr32 
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
  801bc3:	53                   	push   %ebx
  801bc4:	83 ec 0c             	sub    $0xc,%esp
  801bc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801bca:	53                   	push   %ebx
  801bcb:	6a 00                	push   $0x0
  801bcd:	e8 5e f0 ff ff       	call   800c30 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801bd2:	89 1c 24             	mov    %ebx,(%esp)
  801bd5:	e8 9d f2 ff ff       	call   800e77 <fd2data>
  801bda:	83 c4 08             	add    $0x8,%esp
  801bdd:	50                   	push   %eax
  801bde:	6a 00                	push   $0x0
  801be0:	e8 4b f0 ff ff       	call   800c30 <sys_page_unmap>
}
  801be5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801be8:	c9                   	leave  
  801be9:	c3                   	ret    

00801bea <_pipeisclosed>:
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
  801bed:	57                   	push   %edi
  801bee:	56                   	push   %esi
  801bef:	53                   	push   %ebx
  801bf0:	83 ec 1c             	sub    $0x1c,%esp
  801bf3:	89 c7                	mov    %eax,%edi
  801bf5:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801bf7:	a1 08 40 80 00       	mov    0x804008,%eax
  801bfc:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801bff:	83 ec 0c             	sub    $0xc,%esp
  801c02:	57                   	push   %edi
  801c03:	e8 c1 05 00 00       	call   8021c9 <pageref>
  801c08:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c0b:	89 34 24             	mov    %esi,(%esp)
  801c0e:	e8 b6 05 00 00       	call   8021c9 <pageref>
		nn = thisenv->env_runs;
  801c13:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801c19:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c1c:	83 c4 10             	add    $0x10,%esp
  801c1f:	39 cb                	cmp    %ecx,%ebx
  801c21:	74 1b                	je     801c3e <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c23:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c26:	75 cf                	jne    801bf7 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c28:	8b 42 58             	mov    0x58(%edx),%eax
  801c2b:	6a 01                	push   $0x1
  801c2d:	50                   	push   %eax
  801c2e:	53                   	push   %ebx
  801c2f:	68 ef 28 80 00       	push   $0x8028ef
  801c34:	e8 1e e5 ff ff       	call   800157 <cprintf>
  801c39:	83 c4 10             	add    $0x10,%esp
  801c3c:	eb b9                	jmp    801bf7 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801c3e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c41:	0f 94 c0             	sete   %al
  801c44:	0f b6 c0             	movzbl %al,%eax
}
  801c47:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c4a:	5b                   	pop    %ebx
  801c4b:	5e                   	pop    %esi
  801c4c:	5f                   	pop    %edi
  801c4d:	5d                   	pop    %ebp
  801c4e:	c3                   	ret    

00801c4f <devpipe_write>:
{
  801c4f:	f3 0f 1e fb          	endbr32 
  801c53:	55                   	push   %ebp
  801c54:	89 e5                	mov    %esp,%ebp
  801c56:	57                   	push   %edi
  801c57:	56                   	push   %esi
  801c58:	53                   	push   %ebx
  801c59:	83 ec 28             	sub    $0x28,%esp
  801c5c:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801c5f:	56                   	push   %esi
  801c60:	e8 12 f2 ff ff       	call   800e77 <fd2data>
  801c65:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c67:	83 c4 10             	add    $0x10,%esp
  801c6a:	bf 00 00 00 00       	mov    $0x0,%edi
  801c6f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c72:	74 4f                	je     801cc3 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c74:	8b 43 04             	mov    0x4(%ebx),%eax
  801c77:	8b 0b                	mov    (%ebx),%ecx
  801c79:	8d 51 20             	lea    0x20(%ecx),%edx
  801c7c:	39 d0                	cmp    %edx,%eax
  801c7e:	72 14                	jb     801c94 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801c80:	89 da                	mov    %ebx,%edx
  801c82:	89 f0                	mov    %esi,%eax
  801c84:	e8 61 ff ff ff       	call   801bea <_pipeisclosed>
  801c89:	85 c0                	test   %eax,%eax
  801c8b:	75 3b                	jne    801cc8 <devpipe_write+0x79>
			sys_yield();
  801c8d:	e8 ee ee ff ff       	call   800b80 <sys_yield>
  801c92:	eb e0                	jmp    801c74 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c94:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c97:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c9b:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c9e:	89 c2                	mov    %eax,%edx
  801ca0:	c1 fa 1f             	sar    $0x1f,%edx
  801ca3:	89 d1                	mov    %edx,%ecx
  801ca5:	c1 e9 1b             	shr    $0x1b,%ecx
  801ca8:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801cab:	83 e2 1f             	and    $0x1f,%edx
  801cae:	29 ca                	sub    %ecx,%edx
  801cb0:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801cb4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801cb8:	83 c0 01             	add    $0x1,%eax
  801cbb:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801cbe:	83 c7 01             	add    $0x1,%edi
  801cc1:	eb ac                	jmp    801c6f <devpipe_write+0x20>
	return i;
  801cc3:	8b 45 10             	mov    0x10(%ebp),%eax
  801cc6:	eb 05                	jmp    801ccd <devpipe_write+0x7e>
				return 0;
  801cc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ccd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cd0:	5b                   	pop    %ebx
  801cd1:	5e                   	pop    %esi
  801cd2:	5f                   	pop    %edi
  801cd3:	5d                   	pop    %ebp
  801cd4:	c3                   	ret    

00801cd5 <devpipe_read>:
{
  801cd5:	f3 0f 1e fb          	endbr32 
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
  801cdc:	57                   	push   %edi
  801cdd:	56                   	push   %esi
  801cde:	53                   	push   %ebx
  801cdf:	83 ec 18             	sub    $0x18,%esp
  801ce2:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801ce5:	57                   	push   %edi
  801ce6:	e8 8c f1 ff ff       	call   800e77 <fd2data>
  801ceb:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ced:	83 c4 10             	add    $0x10,%esp
  801cf0:	be 00 00 00 00       	mov    $0x0,%esi
  801cf5:	3b 75 10             	cmp    0x10(%ebp),%esi
  801cf8:	75 14                	jne    801d0e <devpipe_read+0x39>
	return i;
  801cfa:	8b 45 10             	mov    0x10(%ebp),%eax
  801cfd:	eb 02                	jmp    801d01 <devpipe_read+0x2c>
				return i;
  801cff:	89 f0                	mov    %esi,%eax
}
  801d01:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d04:	5b                   	pop    %ebx
  801d05:	5e                   	pop    %esi
  801d06:	5f                   	pop    %edi
  801d07:	5d                   	pop    %ebp
  801d08:	c3                   	ret    
			sys_yield();
  801d09:	e8 72 ee ff ff       	call   800b80 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801d0e:	8b 03                	mov    (%ebx),%eax
  801d10:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d13:	75 18                	jne    801d2d <devpipe_read+0x58>
			if (i > 0)
  801d15:	85 f6                	test   %esi,%esi
  801d17:	75 e6                	jne    801cff <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801d19:	89 da                	mov    %ebx,%edx
  801d1b:	89 f8                	mov    %edi,%eax
  801d1d:	e8 c8 fe ff ff       	call   801bea <_pipeisclosed>
  801d22:	85 c0                	test   %eax,%eax
  801d24:	74 e3                	je     801d09 <devpipe_read+0x34>
				return 0;
  801d26:	b8 00 00 00 00       	mov    $0x0,%eax
  801d2b:	eb d4                	jmp    801d01 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d2d:	99                   	cltd   
  801d2e:	c1 ea 1b             	shr    $0x1b,%edx
  801d31:	01 d0                	add    %edx,%eax
  801d33:	83 e0 1f             	and    $0x1f,%eax
  801d36:	29 d0                	sub    %edx,%eax
  801d38:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d40:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d43:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801d46:	83 c6 01             	add    $0x1,%esi
  801d49:	eb aa                	jmp    801cf5 <devpipe_read+0x20>

00801d4b <pipe>:
{
  801d4b:	f3 0f 1e fb          	endbr32 
  801d4f:	55                   	push   %ebp
  801d50:	89 e5                	mov    %esp,%ebp
  801d52:	56                   	push   %esi
  801d53:	53                   	push   %ebx
  801d54:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801d57:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d5a:	50                   	push   %eax
  801d5b:	e8 32 f1 ff ff       	call   800e92 <fd_alloc>
  801d60:	89 c3                	mov    %eax,%ebx
  801d62:	83 c4 10             	add    $0x10,%esp
  801d65:	85 c0                	test   %eax,%eax
  801d67:	0f 88 23 01 00 00    	js     801e90 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d6d:	83 ec 04             	sub    $0x4,%esp
  801d70:	68 07 04 00 00       	push   $0x407
  801d75:	ff 75 f4             	pushl  -0xc(%ebp)
  801d78:	6a 00                	push   $0x0
  801d7a:	e8 24 ee ff ff       	call   800ba3 <sys_page_alloc>
  801d7f:	89 c3                	mov    %eax,%ebx
  801d81:	83 c4 10             	add    $0x10,%esp
  801d84:	85 c0                	test   %eax,%eax
  801d86:	0f 88 04 01 00 00    	js     801e90 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801d8c:	83 ec 0c             	sub    $0xc,%esp
  801d8f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d92:	50                   	push   %eax
  801d93:	e8 fa f0 ff ff       	call   800e92 <fd_alloc>
  801d98:	89 c3                	mov    %eax,%ebx
  801d9a:	83 c4 10             	add    $0x10,%esp
  801d9d:	85 c0                	test   %eax,%eax
  801d9f:	0f 88 db 00 00 00    	js     801e80 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801da5:	83 ec 04             	sub    $0x4,%esp
  801da8:	68 07 04 00 00       	push   $0x407
  801dad:	ff 75 f0             	pushl  -0x10(%ebp)
  801db0:	6a 00                	push   $0x0
  801db2:	e8 ec ed ff ff       	call   800ba3 <sys_page_alloc>
  801db7:	89 c3                	mov    %eax,%ebx
  801db9:	83 c4 10             	add    $0x10,%esp
  801dbc:	85 c0                	test   %eax,%eax
  801dbe:	0f 88 bc 00 00 00    	js     801e80 <pipe+0x135>
	va = fd2data(fd0);
  801dc4:	83 ec 0c             	sub    $0xc,%esp
  801dc7:	ff 75 f4             	pushl  -0xc(%ebp)
  801dca:	e8 a8 f0 ff ff       	call   800e77 <fd2data>
  801dcf:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dd1:	83 c4 0c             	add    $0xc,%esp
  801dd4:	68 07 04 00 00       	push   $0x407
  801dd9:	50                   	push   %eax
  801dda:	6a 00                	push   $0x0
  801ddc:	e8 c2 ed ff ff       	call   800ba3 <sys_page_alloc>
  801de1:	89 c3                	mov    %eax,%ebx
  801de3:	83 c4 10             	add    $0x10,%esp
  801de6:	85 c0                	test   %eax,%eax
  801de8:	0f 88 82 00 00 00    	js     801e70 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dee:	83 ec 0c             	sub    $0xc,%esp
  801df1:	ff 75 f0             	pushl  -0x10(%ebp)
  801df4:	e8 7e f0 ff ff       	call   800e77 <fd2data>
  801df9:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e00:	50                   	push   %eax
  801e01:	6a 00                	push   $0x0
  801e03:	56                   	push   %esi
  801e04:	6a 00                	push   $0x0
  801e06:	e8 df ed ff ff       	call   800bea <sys_page_map>
  801e0b:	89 c3                	mov    %eax,%ebx
  801e0d:	83 c4 20             	add    $0x20,%esp
  801e10:	85 c0                	test   %eax,%eax
  801e12:	78 4e                	js     801e62 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801e14:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801e19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e1c:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801e1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e21:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801e28:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e2b:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801e2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e30:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e37:	83 ec 0c             	sub    $0xc,%esp
  801e3a:	ff 75 f4             	pushl  -0xc(%ebp)
  801e3d:	e8 21 f0 ff ff       	call   800e63 <fd2num>
  801e42:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e45:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e47:	83 c4 04             	add    $0x4,%esp
  801e4a:	ff 75 f0             	pushl  -0x10(%ebp)
  801e4d:	e8 11 f0 ff ff       	call   800e63 <fd2num>
  801e52:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e55:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e58:	83 c4 10             	add    $0x10,%esp
  801e5b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e60:	eb 2e                	jmp    801e90 <pipe+0x145>
	sys_page_unmap(0, va);
  801e62:	83 ec 08             	sub    $0x8,%esp
  801e65:	56                   	push   %esi
  801e66:	6a 00                	push   $0x0
  801e68:	e8 c3 ed ff ff       	call   800c30 <sys_page_unmap>
  801e6d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e70:	83 ec 08             	sub    $0x8,%esp
  801e73:	ff 75 f0             	pushl  -0x10(%ebp)
  801e76:	6a 00                	push   $0x0
  801e78:	e8 b3 ed ff ff       	call   800c30 <sys_page_unmap>
  801e7d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801e80:	83 ec 08             	sub    $0x8,%esp
  801e83:	ff 75 f4             	pushl  -0xc(%ebp)
  801e86:	6a 00                	push   $0x0
  801e88:	e8 a3 ed ff ff       	call   800c30 <sys_page_unmap>
  801e8d:	83 c4 10             	add    $0x10,%esp
}
  801e90:	89 d8                	mov    %ebx,%eax
  801e92:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e95:	5b                   	pop    %ebx
  801e96:	5e                   	pop    %esi
  801e97:	5d                   	pop    %ebp
  801e98:	c3                   	ret    

00801e99 <pipeisclosed>:
{
  801e99:	f3 0f 1e fb          	endbr32 
  801e9d:	55                   	push   %ebp
  801e9e:	89 e5                	mov    %esp,%ebp
  801ea0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ea3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ea6:	50                   	push   %eax
  801ea7:	ff 75 08             	pushl  0x8(%ebp)
  801eaa:	e8 39 f0 ff ff       	call   800ee8 <fd_lookup>
  801eaf:	83 c4 10             	add    $0x10,%esp
  801eb2:	85 c0                	test   %eax,%eax
  801eb4:	78 18                	js     801ece <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801eb6:	83 ec 0c             	sub    $0xc,%esp
  801eb9:	ff 75 f4             	pushl  -0xc(%ebp)
  801ebc:	e8 b6 ef ff ff       	call   800e77 <fd2data>
  801ec1:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec6:	e8 1f fd ff ff       	call   801bea <_pipeisclosed>
  801ecb:	83 c4 10             	add    $0x10,%esp
}
  801ece:	c9                   	leave  
  801ecf:	c3                   	ret    

00801ed0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801ed0:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801ed4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed9:	c3                   	ret    

00801eda <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801eda:	f3 0f 1e fb          	endbr32 
  801ede:	55                   	push   %ebp
  801edf:	89 e5                	mov    %esp,%ebp
  801ee1:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801ee4:	68 07 29 80 00       	push   $0x802907
  801ee9:	ff 75 0c             	pushl  0xc(%ebp)
  801eec:	e8 70 e8 ff ff       	call   800761 <strcpy>
	return 0;
}
  801ef1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef6:	c9                   	leave  
  801ef7:	c3                   	ret    

00801ef8 <devcons_write>:
{
  801ef8:	f3 0f 1e fb          	endbr32 
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
  801eff:	57                   	push   %edi
  801f00:	56                   	push   %esi
  801f01:	53                   	push   %ebx
  801f02:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801f08:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801f0d:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801f13:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f16:	73 31                	jae    801f49 <devcons_write+0x51>
		m = n - tot;
  801f18:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f1b:	29 f3                	sub    %esi,%ebx
  801f1d:	83 fb 7f             	cmp    $0x7f,%ebx
  801f20:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801f25:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801f28:	83 ec 04             	sub    $0x4,%esp
  801f2b:	53                   	push   %ebx
  801f2c:	89 f0                	mov    %esi,%eax
  801f2e:	03 45 0c             	add    0xc(%ebp),%eax
  801f31:	50                   	push   %eax
  801f32:	57                   	push   %edi
  801f33:	e8 df e9 ff ff       	call   800917 <memmove>
		sys_cputs(buf, m);
  801f38:	83 c4 08             	add    $0x8,%esp
  801f3b:	53                   	push   %ebx
  801f3c:	57                   	push   %edi
  801f3d:	e8 91 eb ff ff       	call   800ad3 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801f42:	01 de                	add    %ebx,%esi
  801f44:	83 c4 10             	add    $0x10,%esp
  801f47:	eb ca                	jmp    801f13 <devcons_write+0x1b>
}
  801f49:	89 f0                	mov    %esi,%eax
  801f4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f4e:	5b                   	pop    %ebx
  801f4f:	5e                   	pop    %esi
  801f50:	5f                   	pop    %edi
  801f51:	5d                   	pop    %ebp
  801f52:	c3                   	ret    

00801f53 <devcons_read>:
{
  801f53:	f3 0f 1e fb          	endbr32 
  801f57:	55                   	push   %ebp
  801f58:	89 e5                	mov    %esp,%ebp
  801f5a:	83 ec 08             	sub    $0x8,%esp
  801f5d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801f62:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f66:	74 21                	je     801f89 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801f68:	e8 88 eb ff ff       	call   800af5 <sys_cgetc>
  801f6d:	85 c0                	test   %eax,%eax
  801f6f:	75 07                	jne    801f78 <devcons_read+0x25>
		sys_yield();
  801f71:	e8 0a ec ff ff       	call   800b80 <sys_yield>
  801f76:	eb f0                	jmp    801f68 <devcons_read+0x15>
	if (c < 0)
  801f78:	78 0f                	js     801f89 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801f7a:	83 f8 04             	cmp    $0x4,%eax
  801f7d:	74 0c                	je     801f8b <devcons_read+0x38>
	*(char*)vbuf = c;
  801f7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f82:	88 02                	mov    %al,(%edx)
	return 1;
  801f84:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801f89:	c9                   	leave  
  801f8a:	c3                   	ret    
		return 0;
  801f8b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f90:	eb f7                	jmp    801f89 <devcons_read+0x36>

00801f92 <cputchar>:
{
  801f92:	f3 0f 1e fb          	endbr32 
  801f96:	55                   	push   %ebp
  801f97:	89 e5                	mov    %esp,%ebp
  801f99:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9f:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801fa2:	6a 01                	push   $0x1
  801fa4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801fa7:	50                   	push   %eax
  801fa8:	e8 26 eb ff ff       	call   800ad3 <sys_cputs>
}
  801fad:	83 c4 10             	add    $0x10,%esp
  801fb0:	c9                   	leave  
  801fb1:	c3                   	ret    

00801fb2 <getchar>:
{
  801fb2:	f3 0f 1e fb          	endbr32 
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
  801fb9:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801fbc:	6a 01                	push   $0x1
  801fbe:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801fc1:	50                   	push   %eax
  801fc2:	6a 00                	push   $0x0
  801fc4:	e8 a7 f1 ff ff       	call   801170 <read>
	if (r < 0)
  801fc9:	83 c4 10             	add    $0x10,%esp
  801fcc:	85 c0                	test   %eax,%eax
  801fce:	78 06                	js     801fd6 <getchar+0x24>
	if (r < 1)
  801fd0:	74 06                	je     801fd8 <getchar+0x26>
	return c;
  801fd2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801fd6:	c9                   	leave  
  801fd7:	c3                   	ret    
		return -E_EOF;
  801fd8:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801fdd:	eb f7                	jmp    801fd6 <getchar+0x24>

00801fdf <iscons>:
{
  801fdf:	f3 0f 1e fb          	endbr32 
  801fe3:	55                   	push   %ebp
  801fe4:	89 e5                	mov    %esp,%ebp
  801fe6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fe9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fec:	50                   	push   %eax
  801fed:	ff 75 08             	pushl  0x8(%ebp)
  801ff0:	e8 f3 ee ff ff       	call   800ee8 <fd_lookup>
  801ff5:	83 c4 10             	add    $0x10,%esp
  801ff8:	85 c0                	test   %eax,%eax
  801ffa:	78 11                	js     80200d <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fff:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802005:	39 10                	cmp    %edx,(%eax)
  802007:	0f 94 c0             	sete   %al
  80200a:	0f b6 c0             	movzbl %al,%eax
}
  80200d:	c9                   	leave  
  80200e:	c3                   	ret    

0080200f <opencons>:
{
  80200f:	f3 0f 1e fb          	endbr32 
  802013:	55                   	push   %ebp
  802014:	89 e5                	mov    %esp,%ebp
  802016:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802019:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80201c:	50                   	push   %eax
  80201d:	e8 70 ee ff ff       	call   800e92 <fd_alloc>
  802022:	83 c4 10             	add    $0x10,%esp
  802025:	85 c0                	test   %eax,%eax
  802027:	78 3a                	js     802063 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802029:	83 ec 04             	sub    $0x4,%esp
  80202c:	68 07 04 00 00       	push   $0x407
  802031:	ff 75 f4             	pushl  -0xc(%ebp)
  802034:	6a 00                	push   $0x0
  802036:	e8 68 eb ff ff       	call   800ba3 <sys_page_alloc>
  80203b:	83 c4 10             	add    $0x10,%esp
  80203e:	85 c0                	test   %eax,%eax
  802040:	78 21                	js     802063 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802042:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802045:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80204b:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80204d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802050:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802057:	83 ec 0c             	sub    $0xc,%esp
  80205a:	50                   	push   %eax
  80205b:	e8 03 ee ff ff       	call   800e63 <fd2num>
  802060:	83 c4 10             	add    $0x10,%esp
}
  802063:	c9                   	leave  
  802064:	c3                   	ret    

00802065 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802065:	f3 0f 1e fb          	endbr32 
  802069:	55                   	push   %ebp
  80206a:	89 e5                	mov    %esp,%ebp
  80206c:	56                   	push   %esi
  80206d:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80206e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802071:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802077:	e8 e1 ea ff ff       	call   800b5d <sys_getenvid>
  80207c:	83 ec 0c             	sub    $0xc,%esp
  80207f:	ff 75 0c             	pushl  0xc(%ebp)
  802082:	ff 75 08             	pushl  0x8(%ebp)
  802085:	56                   	push   %esi
  802086:	50                   	push   %eax
  802087:	68 14 29 80 00       	push   $0x802914
  80208c:	e8 c6 e0 ff ff       	call   800157 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802091:	83 c4 18             	add    $0x18,%esp
  802094:	53                   	push   %ebx
  802095:	ff 75 10             	pushl  0x10(%ebp)
  802098:	e8 65 e0 ff ff       	call   800102 <vcprintf>
	cprintf("\n");
  80209d:	c7 04 24 50 29 80 00 	movl   $0x802950,(%esp)
  8020a4:	e8 ae e0 ff ff       	call   800157 <cprintf>
  8020a9:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8020ac:	cc                   	int3   
  8020ad:	eb fd                	jmp    8020ac <_panic+0x47>

008020af <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8020af:	f3 0f 1e fb          	endbr32 
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
  8020b6:	56                   	push   %esi
  8020b7:	53                   	push   %ebx
  8020b8:	8b 75 08             	mov    0x8(%ebp),%esi
  8020bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020be:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  8020c1:	85 c0                	test   %eax,%eax
  8020c3:	74 3d                	je     802102 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  8020c5:	83 ec 0c             	sub    $0xc,%esp
  8020c8:	50                   	push   %eax
  8020c9:	e8 a1 ec ff ff       	call   800d6f <sys_ipc_recv>
  8020ce:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  8020d1:	85 f6                	test   %esi,%esi
  8020d3:	74 0b                	je     8020e0 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8020d5:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8020db:	8b 52 74             	mov    0x74(%edx),%edx
  8020de:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  8020e0:	85 db                	test   %ebx,%ebx
  8020e2:	74 0b                	je     8020ef <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  8020e4:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8020ea:	8b 52 78             	mov    0x78(%edx),%edx
  8020ed:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  8020ef:	85 c0                	test   %eax,%eax
  8020f1:	78 21                	js     802114 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  8020f3:	a1 08 40 80 00       	mov    0x804008,%eax
  8020f8:	8b 40 70             	mov    0x70(%eax),%eax
}
  8020fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020fe:	5b                   	pop    %ebx
  8020ff:	5e                   	pop    %esi
  802100:	5d                   	pop    %ebp
  802101:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  802102:	83 ec 0c             	sub    $0xc,%esp
  802105:	68 00 00 c0 ee       	push   $0xeec00000
  80210a:	e8 60 ec ff ff       	call   800d6f <sys_ipc_recv>
  80210f:	83 c4 10             	add    $0x10,%esp
  802112:	eb bd                	jmp    8020d1 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  802114:	85 f6                	test   %esi,%esi
  802116:	74 10                	je     802128 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  802118:	85 db                	test   %ebx,%ebx
  80211a:	75 df                	jne    8020fb <ipc_recv+0x4c>
  80211c:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802123:	00 00 00 
  802126:	eb d3                	jmp    8020fb <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  802128:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80212f:	00 00 00 
  802132:	eb e4                	jmp    802118 <ipc_recv+0x69>

00802134 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802134:	f3 0f 1e fb          	endbr32 
  802138:	55                   	push   %ebp
  802139:	89 e5                	mov    %esp,%ebp
  80213b:	57                   	push   %edi
  80213c:	56                   	push   %esi
  80213d:	53                   	push   %ebx
  80213e:	83 ec 0c             	sub    $0xc,%esp
  802141:	8b 7d 08             	mov    0x8(%ebp),%edi
  802144:	8b 75 0c             	mov    0xc(%ebp),%esi
  802147:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  80214a:	85 db                	test   %ebx,%ebx
  80214c:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802151:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  802154:	ff 75 14             	pushl  0x14(%ebp)
  802157:	53                   	push   %ebx
  802158:	56                   	push   %esi
  802159:	57                   	push   %edi
  80215a:	e8 e9 eb ff ff       	call   800d48 <sys_ipc_try_send>
  80215f:	83 c4 10             	add    $0x10,%esp
  802162:	85 c0                	test   %eax,%eax
  802164:	79 1e                	jns    802184 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  802166:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802169:	75 07                	jne    802172 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  80216b:	e8 10 ea ff ff       	call   800b80 <sys_yield>
  802170:	eb e2                	jmp    802154 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  802172:	50                   	push   %eax
  802173:	68 37 29 80 00       	push   $0x802937
  802178:	6a 59                	push   $0x59
  80217a:	68 52 29 80 00       	push   $0x802952
  80217f:	e8 e1 fe ff ff       	call   802065 <_panic>
	}
}
  802184:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802187:	5b                   	pop    %ebx
  802188:	5e                   	pop    %esi
  802189:	5f                   	pop    %edi
  80218a:	5d                   	pop    %ebp
  80218b:	c3                   	ret    

0080218c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80218c:	f3 0f 1e fb          	endbr32 
  802190:	55                   	push   %ebp
  802191:	89 e5                	mov    %esp,%ebp
  802193:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802196:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80219b:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80219e:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8021a4:	8b 52 50             	mov    0x50(%edx),%edx
  8021a7:	39 ca                	cmp    %ecx,%edx
  8021a9:	74 11                	je     8021bc <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8021ab:	83 c0 01             	add    $0x1,%eax
  8021ae:	3d 00 04 00 00       	cmp    $0x400,%eax
  8021b3:	75 e6                	jne    80219b <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8021b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ba:	eb 0b                	jmp    8021c7 <ipc_find_env+0x3b>
			return envs[i].env_id;
  8021bc:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8021bf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8021c4:	8b 40 48             	mov    0x48(%eax),%eax
}
  8021c7:	5d                   	pop    %ebp
  8021c8:	c3                   	ret    

008021c9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8021c9:	f3 0f 1e fb          	endbr32 
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
  8021d0:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8021d3:	89 c2                	mov    %eax,%edx
  8021d5:	c1 ea 16             	shr    $0x16,%edx
  8021d8:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8021df:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8021e4:	f6 c1 01             	test   $0x1,%cl
  8021e7:	74 1c                	je     802205 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8021e9:	c1 e8 0c             	shr    $0xc,%eax
  8021ec:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8021f3:	a8 01                	test   $0x1,%al
  8021f5:	74 0e                	je     802205 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8021f7:	c1 e8 0c             	shr    $0xc,%eax
  8021fa:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802201:	ef 
  802202:	0f b7 d2             	movzwl %dx,%edx
}
  802205:	89 d0                	mov    %edx,%eax
  802207:	5d                   	pop    %ebp
  802208:	c3                   	ret    
  802209:	66 90                	xchg   %ax,%ax
  80220b:	66 90                	xchg   %ax,%ax
  80220d:	66 90                	xchg   %ax,%ax
  80220f:	90                   	nop

00802210 <__udivdi3>:
  802210:	f3 0f 1e fb          	endbr32 
  802214:	55                   	push   %ebp
  802215:	57                   	push   %edi
  802216:	56                   	push   %esi
  802217:	53                   	push   %ebx
  802218:	83 ec 1c             	sub    $0x1c,%esp
  80221b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80221f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802223:	8b 74 24 34          	mov    0x34(%esp),%esi
  802227:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80222b:	85 d2                	test   %edx,%edx
  80222d:	75 19                	jne    802248 <__udivdi3+0x38>
  80222f:	39 f3                	cmp    %esi,%ebx
  802231:	76 4d                	jbe    802280 <__udivdi3+0x70>
  802233:	31 ff                	xor    %edi,%edi
  802235:	89 e8                	mov    %ebp,%eax
  802237:	89 f2                	mov    %esi,%edx
  802239:	f7 f3                	div    %ebx
  80223b:	89 fa                	mov    %edi,%edx
  80223d:	83 c4 1c             	add    $0x1c,%esp
  802240:	5b                   	pop    %ebx
  802241:	5e                   	pop    %esi
  802242:	5f                   	pop    %edi
  802243:	5d                   	pop    %ebp
  802244:	c3                   	ret    
  802245:	8d 76 00             	lea    0x0(%esi),%esi
  802248:	39 f2                	cmp    %esi,%edx
  80224a:	76 14                	jbe    802260 <__udivdi3+0x50>
  80224c:	31 ff                	xor    %edi,%edi
  80224e:	31 c0                	xor    %eax,%eax
  802250:	89 fa                	mov    %edi,%edx
  802252:	83 c4 1c             	add    $0x1c,%esp
  802255:	5b                   	pop    %ebx
  802256:	5e                   	pop    %esi
  802257:	5f                   	pop    %edi
  802258:	5d                   	pop    %ebp
  802259:	c3                   	ret    
  80225a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802260:	0f bd fa             	bsr    %edx,%edi
  802263:	83 f7 1f             	xor    $0x1f,%edi
  802266:	75 48                	jne    8022b0 <__udivdi3+0xa0>
  802268:	39 f2                	cmp    %esi,%edx
  80226a:	72 06                	jb     802272 <__udivdi3+0x62>
  80226c:	31 c0                	xor    %eax,%eax
  80226e:	39 eb                	cmp    %ebp,%ebx
  802270:	77 de                	ja     802250 <__udivdi3+0x40>
  802272:	b8 01 00 00 00       	mov    $0x1,%eax
  802277:	eb d7                	jmp    802250 <__udivdi3+0x40>
  802279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802280:	89 d9                	mov    %ebx,%ecx
  802282:	85 db                	test   %ebx,%ebx
  802284:	75 0b                	jne    802291 <__udivdi3+0x81>
  802286:	b8 01 00 00 00       	mov    $0x1,%eax
  80228b:	31 d2                	xor    %edx,%edx
  80228d:	f7 f3                	div    %ebx
  80228f:	89 c1                	mov    %eax,%ecx
  802291:	31 d2                	xor    %edx,%edx
  802293:	89 f0                	mov    %esi,%eax
  802295:	f7 f1                	div    %ecx
  802297:	89 c6                	mov    %eax,%esi
  802299:	89 e8                	mov    %ebp,%eax
  80229b:	89 f7                	mov    %esi,%edi
  80229d:	f7 f1                	div    %ecx
  80229f:	89 fa                	mov    %edi,%edx
  8022a1:	83 c4 1c             	add    $0x1c,%esp
  8022a4:	5b                   	pop    %ebx
  8022a5:	5e                   	pop    %esi
  8022a6:	5f                   	pop    %edi
  8022a7:	5d                   	pop    %ebp
  8022a8:	c3                   	ret    
  8022a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022b0:	89 f9                	mov    %edi,%ecx
  8022b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8022b7:	29 f8                	sub    %edi,%eax
  8022b9:	d3 e2                	shl    %cl,%edx
  8022bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022bf:	89 c1                	mov    %eax,%ecx
  8022c1:	89 da                	mov    %ebx,%edx
  8022c3:	d3 ea                	shr    %cl,%edx
  8022c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8022c9:	09 d1                	or     %edx,%ecx
  8022cb:	89 f2                	mov    %esi,%edx
  8022cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022d1:	89 f9                	mov    %edi,%ecx
  8022d3:	d3 e3                	shl    %cl,%ebx
  8022d5:	89 c1                	mov    %eax,%ecx
  8022d7:	d3 ea                	shr    %cl,%edx
  8022d9:	89 f9                	mov    %edi,%ecx
  8022db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8022df:	89 eb                	mov    %ebp,%ebx
  8022e1:	d3 e6                	shl    %cl,%esi
  8022e3:	89 c1                	mov    %eax,%ecx
  8022e5:	d3 eb                	shr    %cl,%ebx
  8022e7:	09 de                	or     %ebx,%esi
  8022e9:	89 f0                	mov    %esi,%eax
  8022eb:	f7 74 24 08          	divl   0x8(%esp)
  8022ef:	89 d6                	mov    %edx,%esi
  8022f1:	89 c3                	mov    %eax,%ebx
  8022f3:	f7 64 24 0c          	mull   0xc(%esp)
  8022f7:	39 d6                	cmp    %edx,%esi
  8022f9:	72 15                	jb     802310 <__udivdi3+0x100>
  8022fb:	89 f9                	mov    %edi,%ecx
  8022fd:	d3 e5                	shl    %cl,%ebp
  8022ff:	39 c5                	cmp    %eax,%ebp
  802301:	73 04                	jae    802307 <__udivdi3+0xf7>
  802303:	39 d6                	cmp    %edx,%esi
  802305:	74 09                	je     802310 <__udivdi3+0x100>
  802307:	89 d8                	mov    %ebx,%eax
  802309:	31 ff                	xor    %edi,%edi
  80230b:	e9 40 ff ff ff       	jmp    802250 <__udivdi3+0x40>
  802310:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802313:	31 ff                	xor    %edi,%edi
  802315:	e9 36 ff ff ff       	jmp    802250 <__udivdi3+0x40>
  80231a:	66 90                	xchg   %ax,%ax
  80231c:	66 90                	xchg   %ax,%ax
  80231e:	66 90                	xchg   %ax,%ax

00802320 <__umoddi3>:
  802320:	f3 0f 1e fb          	endbr32 
  802324:	55                   	push   %ebp
  802325:	57                   	push   %edi
  802326:	56                   	push   %esi
  802327:	53                   	push   %ebx
  802328:	83 ec 1c             	sub    $0x1c,%esp
  80232b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80232f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802333:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802337:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80233b:	85 c0                	test   %eax,%eax
  80233d:	75 19                	jne    802358 <__umoddi3+0x38>
  80233f:	39 df                	cmp    %ebx,%edi
  802341:	76 5d                	jbe    8023a0 <__umoddi3+0x80>
  802343:	89 f0                	mov    %esi,%eax
  802345:	89 da                	mov    %ebx,%edx
  802347:	f7 f7                	div    %edi
  802349:	89 d0                	mov    %edx,%eax
  80234b:	31 d2                	xor    %edx,%edx
  80234d:	83 c4 1c             	add    $0x1c,%esp
  802350:	5b                   	pop    %ebx
  802351:	5e                   	pop    %esi
  802352:	5f                   	pop    %edi
  802353:	5d                   	pop    %ebp
  802354:	c3                   	ret    
  802355:	8d 76 00             	lea    0x0(%esi),%esi
  802358:	89 f2                	mov    %esi,%edx
  80235a:	39 d8                	cmp    %ebx,%eax
  80235c:	76 12                	jbe    802370 <__umoddi3+0x50>
  80235e:	89 f0                	mov    %esi,%eax
  802360:	89 da                	mov    %ebx,%edx
  802362:	83 c4 1c             	add    $0x1c,%esp
  802365:	5b                   	pop    %ebx
  802366:	5e                   	pop    %esi
  802367:	5f                   	pop    %edi
  802368:	5d                   	pop    %ebp
  802369:	c3                   	ret    
  80236a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802370:	0f bd e8             	bsr    %eax,%ebp
  802373:	83 f5 1f             	xor    $0x1f,%ebp
  802376:	75 50                	jne    8023c8 <__umoddi3+0xa8>
  802378:	39 d8                	cmp    %ebx,%eax
  80237a:	0f 82 e0 00 00 00    	jb     802460 <__umoddi3+0x140>
  802380:	89 d9                	mov    %ebx,%ecx
  802382:	39 f7                	cmp    %esi,%edi
  802384:	0f 86 d6 00 00 00    	jbe    802460 <__umoddi3+0x140>
  80238a:	89 d0                	mov    %edx,%eax
  80238c:	89 ca                	mov    %ecx,%edx
  80238e:	83 c4 1c             	add    $0x1c,%esp
  802391:	5b                   	pop    %ebx
  802392:	5e                   	pop    %esi
  802393:	5f                   	pop    %edi
  802394:	5d                   	pop    %ebp
  802395:	c3                   	ret    
  802396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80239d:	8d 76 00             	lea    0x0(%esi),%esi
  8023a0:	89 fd                	mov    %edi,%ebp
  8023a2:	85 ff                	test   %edi,%edi
  8023a4:	75 0b                	jne    8023b1 <__umoddi3+0x91>
  8023a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8023ab:	31 d2                	xor    %edx,%edx
  8023ad:	f7 f7                	div    %edi
  8023af:	89 c5                	mov    %eax,%ebp
  8023b1:	89 d8                	mov    %ebx,%eax
  8023b3:	31 d2                	xor    %edx,%edx
  8023b5:	f7 f5                	div    %ebp
  8023b7:	89 f0                	mov    %esi,%eax
  8023b9:	f7 f5                	div    %ebp
  8023bb:	89 d0                	mov    %edx,%eax
  8023bd:	31 d2                	xor    %edx,%edx
  8023bf:	eb 8c                	jmp    80234d <__umoddi3+0x2d>
  8023c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023c8:	89 e9                	mov    %ebp,%ecx
  8023ca:	ba 20 00 00 00       	mov    $0x20,%edx
  8023cf:	29 ea                	sub    %ebp,%edx
  8023d1:	d3 e0                	shl    %cl,%eax
  8023d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023d7:	89 d1                	mov    %edx,%ecx
  8023d9:	89 f8                	mov    %edi,%eax
  8023db:	d3 e8                	shr    %cl,%eax
  8023dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8023e5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8023e9:	09 c1                	or     %eax,%ecx
  8023eb:	89 d8                	mov    %ebx,%eax
  8023ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023f1:	89 e9                	mov    %ebp,%ecx
  8023f3:	d3 e7                	shl    %cl,%edi
  8023f5:	89 d1                	mov    %edx,%ecx
  8023f7:	d3 e8                	shr    %cl,%eax
  8023f9:	89 e9                	mov    %ebp,%ecx
  8023fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023ff:	d3 e3                	shl    %cl,%ebx
  802401:	89 c7                	mov    %eax,%edi
  802403:	89 d1                	mov    %edx,%ecx
  802405:	89 f0                	mov    %esi,%eax
  802407:	d3 e8                	shr    %cl,%eax
  802409:	89 e9                	mov    %ebp,%ecx
  80240b:	89 fa                	mov    %edi,%edx
  80240d:	d3 e6                	shl    %cl,%esi
  80240f:	09 d8                	or     %ebx,%eax
  802411:	f7 74 24 08          	divl   0x8(%esp)
  802415:	89 d1                	mov    %edx,%ecx
  802417:	89 f3                	mov    %esi,%ebx
  802419:	f7 64 24 0c          	mull   0xc(%esp)
  80241d:	89 c6                	mov    %eax,%esi
  80241f:	89 d7                	mov    %edx,%edi
  802421:	39 d1                	cmp    %edx,%ecx
  802423:	72 06                	jb     80242b <__umoddi3+0x10b>
  802425:	75 10                	jne    802437 <__umoddi3+0x117>
  802427:	39 c3                	cmp    %eax,%ebx
  802429:	73 0c                	jae    802437 <__umoddi3+0x117>
  80242b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80242f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802433:	89 d7                	mov    %edx,%edi
  802435:	89 c6                	mov    %eax,%esi
  802437:	89 ca                	mov    %ecx,%edx
  802439:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80243e:	29 f3                	sub    %esi,%ebx
  802440:	19 fa                	sbb    %edi,%edx
  802442:	89 d0                	mov    %edx,%eax
  802444:	d3 e0                	shl    %cl,%eax
  802446:	89 e9                	mov    %ebp,%ecx
  802448:	d3 eb                	shr    %cl,%ebx
  80244a:	d3 ea                	shr    %cl,%edx
  80244c:	09 d8                	or     %ebx,%eax
  80244e:	83 c4 1c             	add    $0x1c,%esp
  802451:	5b                   	pop    %ebx
  802452:	5e                   	pop    %esi
  802453:	5f                   	pop    %edi
  802454:	5d                   	pop    %ebp
  802455:	c3                   	ret    
  802456:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80245d:	8d 76 00             	lea    0x0(%esi),%esi
  802460:	29 fe                	sub    %edi,%esi
  802462:	19 c3                	sbb    %eax,%ebx
  802464:	89 f2                	mov    %esi,%edx
  802466:	89 d9                	mov    %ebx,%ecx
  802468:	e9 1d ff ff ff       	jmp    80238a <__umoddi3+0x6a>
