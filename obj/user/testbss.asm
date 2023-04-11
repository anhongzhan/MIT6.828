
obj/user/testbss:     file format elf32-i386


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
  80002c:	e8 af 00 00 00       	call   8000e0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t bigarray[ARRAYSIZE];

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	83 ec 14             	sub    $0x14,%esp
	int i;

	cprintf("Making sure bss works right...\n");
  80003d:	68 a0 10 80 00       	push   $0x8010a0
  800042:	e8 e0 01 00 00       	call   800227 <cprintf>
  800047:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < ARRAYSIZE; i++)
  80004a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != 0)
  80004f:	83 3c 85 20 20 80 00 	cmpl   $0x0,0x802020(,%eax,4)
  800056:	00 
  800057:	75 63                	jne    8000bc <umain+0x89>
	for (i = 0; i < ARRAYSIZE; i++)
  800059:	83 c0 01             	add    $0x1,%eax
  80005c:	3d 00 00 10 00       	cmp    $0x100000,%eax
  800061:	75 ec                	jne    80004f <umain+0x1c>
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
  800063:	b8 00 00 00 00       	mov    $0x0,%eax
		bigarray[i] = i;
  800068:	89 04 85 20 20 80 00 	mov    %eax,0x802020(,%eax,4)
	for (i = 0; i < ARRAYSIZE; i++)
  80006f:	83 c0 01             	add    $0x1,%eax
  800072:	3d 00 00 10 00       	cmp    $0x100000,%eax
  800077:	75 ef                	jne    800068 <umain+0x35>
	for (i = 0; i < ARRAYSIZE; i++)
  800079:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != i)
  80007e:	39 04 85 20 20 80 00 	cmp    %eax,0x802020(,%eax,4)
  800085:	75 47                	jne    8000ce <umain+0x9b>
	for (i = 0; i < ARRAYSIZE; i++)
  800087:	83 c0 01             	add    $0x1,%eax
  80008a:	3d 00 00 10 00       	cmp    $0x100000,%eax
  80008f:	75 ed                	jne    80007e <umain+0x4b>
			panic("bigarray[%d] didn't hold its value!\n", i);

	cprintf("Yes, good.  Now doing a wild write off the end...\n");
  800091:	83 ec 0c             	sub    $0xc,%esp
  800094:	68 e8 10 80 00       	push   $0x8010e8
  800099:	e8 89 01 00 00       	call   800227 <cprintf>
	bigarray[ARRAYSIZE+1024] = 0;
  80009e:	c7 05 20 30 c0 00 00 	movl   $0x0,0xc03020
  8000a5:	00 00 00 
	panic("SHOULD HAVE TRAPPED!!!");
  8000a8:	83 c4 0c             	add    $0xc,%esp
  8000ab:	68 47 11 80 00       	push   $0x801147
  8000b0:	6a 1a                	push   $0x1a
  8000b2:	68 38 11 80 00       	push   $0x801138
  8000b7:	e8 84 00 00 00       	call   800140 <_panic>
			panic("bigarray[%d] isn't cleared!\n", i);
  8000bc:	50                   	push   %eax
  8000bd:	68 1b 11 80 00       	push   $0x80111b
  8000c2:	6a 11                	push   $0x11
  8000c4:	68 38 11 80 00       	push   $0x801138
  8000c9:	e8 72 00 00 00       	call   800140 <_panic>
			panic("bigarray[%d] didn't hold its value!\n", i);
  8000ce:	50                   	push   %eax
  8000cf:	68 c0 10 80 00       	push   $0x8010c0
  8000d4:	6a 16                	push   $0x16
  8000d6:	68 38 11 80 00       	push   $0x801138
  8000db:	e8 60 00 00 00       	call   800140 <_panic>

008000e0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e0:	f3 0f 1e fb          	endbr32 
  8000e4:	55                   	push   %ebp
  8000e5:	89 e5                	mov    %esp,%ebp
  8000e7:	56                   	push   %esi
  8000e8:	53                   	push   %ebx
  8000e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000ec:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000ef:	e8 39 0b 00 00       	call   800c2d <sys_getenvid>
  8000f4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000fc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800101:	a3 20 20 c0 00       	mov    %eax,0xc02020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800106:	85 db                	test   %ebx,%ebx
  800108:	7e 07                	jle    800111 <libmain+0x31>
		binaryname = argv[0];
  80010a:	8b 06                	mov    (%esi),%eax
  80010c:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800111:	83 ec 08             	sub    $0x8,%esp
  800114:	56                   	push   %esi
  800115:	53                   	push   %ebx
  800116:	e8 18 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80011b:	e8 0a 00 00 00       	call   80012a <exit>
}
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800126:	5b                   	pop    %ebx
  800127:	5e                   	pop    %esi
  800128:	5d                   	pop    %ebp
  800129:	c3                   	ret    

0080012a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80012a:	f3 0f 1e fb          	endbr32 
  80012e:	55                   	push   %ebp
  80012f:	89 e5                	mov    %esp,%ebp
  800131:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  800134:	6a 00                	push   $0x0
  800136:	e8 ad 0a 00 00       	call   800be8 <sys_env_destroy>
}
  80013b:	83 c4 10             	add    $0x10,%esp
  80013e:	c9                   	leave  
  80013f:	c3                   	ret    

00800140 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800140:	f3 0f 1e fb          	endbr32 
  800144:	55                   	push   %ebp
  800145:	89 e5                	mov    %esp,%ebp
  800147:	56                   	push   %esi
  800148:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800149:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80014c:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800152:	e8 d6 0a 00 00       	call   800c2d <sys_getenvid>
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	ff 75 0c             	pushl  0xc(%ebp)
  80015d:	ff 75 08             	pushl  0x8(%ebp)
  800160:	56                   	push   %esi
  800161:	50                   	push   %eax
  800162:	68 68 11 80 00       	push   $0x801168
  800167:	e8 bb 00 00 00       	call   800227 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80016c:	83 c4 18             	add    $0x18,%esp
  80016f:	53                   	push   %ebx
  800170:	ff 75 10             	pushl  0x10(%ebp)
  800173:	e8 5a 00 00 00       	call   8001d2 <vcprintf>
	cprintf("\n");
  800178:	c7 04 24 36 11 80 00 	movl   $0x801136,(%esp)
  80017f:	e8 a3 00 00 00       	call   800227 <cprintf>
  800184:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800187:	cc                   	int3   
  800188:	eb fd                	jmp    800187 <_panic+0x47>

0080018a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80018a:	f3 0f 1e fb          	endbr32 
  80018e:	55                   	push   %ebp
  80018f:	89 e5                	mov    %esp,%ebp
  800191:	53                   	push   %ebx
  800192:	83 ec 04             	sub    $0x4,%esp
  800195:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800198:	8b 13                	mov    (%ebx),%edx
  80019a:	8d 42 01             	lea    0x1(%edx),%eax
  80019d:	89 03                	mov    %eax,(%ebx)
  80019f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001a2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001a6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001ab:	74 09                	je     8001b6 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001ad:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001b4:	c9                   	leave  
  8001b5:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001b6:	83 ec 08             	sub    $0x8,%esp
  8001b9:	68 ff 00 00 00       	push   $0xff
  8001be:	8d 43 08             	lea    0x8(%ebx),%eax
  8001c1:	50                   	push   %eax
  8001c2:	e8 dc 09 00 00       	call   800ba3 <sys_cputs>
		b->idx = 0;
  8001c7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001cd:	83 c4 10             	add    $0x10,%esp
  8001d0:	eb db                	jmp    8001ad <putch+0x23>

008001d2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001d2:	f3 0f 1e fb          	endbr32 
  8001d6:	55                   	push   %ebp
  8001d7:	89 e5                	mov    %esp,%ebp
  8001d9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001df:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001e6:	00 00 00 
	b.cnt = 0;
  8001e9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001f0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001f3:	ff 75 0c             	pushl  0xc(%ebp)
  8001f6:	ff 75 08             	pushl  0x8(%ebp)
  8001f9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001ff:	50                   	push   %eax
  800200:	68 8a 01 80 00       	push   $0x80018a
  800205:	e8 20 01 00 00       	call   80032a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80020a:	83 c4 08             	add    $0x8,%esp
  80020d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800213:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800219:	50                   	push   %eax
  80021a:	e8 84 09 00 00       	call   800ba3 <sys_cputs>

	return b.cnt;
}
  80021f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800225:	c9                   	leave  
  800226:	c3                   	ret    

00800227 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800227:	f3 0f 1e fb          	endbr32 
  80022b:	55                   	push   %ebp
  80022c:	89 e5                	mov    %esp,%ebp
  80022e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800231:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800234:	50                   	push   %eax
  800235:	ff 75 08             	pushl  0x8(%ebp)
  800238:	e8 95 ff ff ff       	call   8001d2 <vcprintf>
	va_end(ap);

	return cnt;
}
  80023d:	c9                   	leave  
  80023e:	c3                   	ret    

0080023f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80023f:	55                   	push   %ebp
  800240:	89 e5                	mov    %esp,%ebp
  800242:	57                   	push   %edi
  800243:	56                   	push   %esi
  800244:	53                   	push   %ebx
  800245:	83 ec 1c             	sub    $0x1c,%esp
  800248:	89 c7                	mov    %eax,%edi
  80024a:	89 d6                	mov    %edx,%esi
  80024c:	8b 45 08             	mov    0x8(%ebp),%eax
  80024f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800252:	89 d1                	mov    %edx,%ecx
  800254:	89 c2                	mov    %eax,%edx
  800256:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800259:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80025c:	8b 45 10             	mov    0x10(%ebp),%eax
  80025f:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800262:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800265:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80026c:	39 c2                	cmp    %eax,%edx
  80026e:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800271:	72 3e                	jb     8002b1 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800273:	83 ec 0c             	sub    $0xc,%esp
  800276:	ff 75 18             	pushl  0x18(%ebp)
  800279:	83 eb 01             	sub    $0x1,%ebx
  80027c:	53                   	push   %ebx
  80027d:	50                   	push   %eax
  80027e:	83 ec 08             	sub    $0x8,%esp
  800281:	ff 75 e4             	pushl  -0x1c(%ebp)
  800284:	ff 75 e0             	pushl  -0x20(%ebp)
  800287:	ff 75 dc             	pushl  -0x24(%ebp)
  80028a:	ff 75 d8             	pushl  -0x28(%ebp)
  80028d:	e8 ae 0b 00 00       	call   800e40 <__udivdi3>
  800292:	83 c4 18             	add    $0x18,%esp
  800295:	52                   	push   %edx
  800296:	50                   	push   %eax
  800297:	89 f2                	mov    %esi,%edx
  800299:	89 f8                	mov    %edi,%eax
  80029b:	e8 9f ff ff ff       	call   80023f <printnum>
  8002a0:	83 c4 20             	add    $0x20,%esp
  8002a3:	eb 13                	jmp    8002b8 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002a5:	83 ec 08             	sub    $0x8,%esp
  8002a8:	56                   	push   %esi
  8002a9:	ff 75 18             	pushl  0x18(%ebp)
  8002ac:	ff d7                	call   *%edi
  8002ae:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002b1:	83 eb 01             	sub    $0x1,%ebx
  8002b4:	85 db                	test   %ebx,%ebx
  8002b6:	7f ed                	jg     8002a5 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002b8:	83 ec 08             	sub    $0x8,%esp
  8002bb:	56                   	push   %esi
  8002bc:	83 ec 04             	sub    $0x4,%esp
  8002bf:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c2:	ff 75 e0             	pushl  -0x20(%ebp)
  8002c5:	ff 75 dc             	pushl  -0x24(%ebp)
  8002c8:	ff 75 d8             	pushl  -0x28(%ebp)
  8002cb:	e8 80 0c 00 00       	call   800f50 <__umoddi3>
  8002d0:	83 c4 14             	add    $0x14,%esp
  8002d3:	0f be 80 8b 11 80 00 	movsbl 0x80118b(%eax),%eax
  8002da:	50                   	push   %eax
  8002db:	ff d7                	call   *%edi
}
  8002dd:	83 c4 10             	add    $0x10,%esp
  8002e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e3:	5b                   	pop    %ebx
  8002e4:	5e                   	pop    %esi
  8002e5:	5f                   	pop    %edi
  8002e6:	5d                   	pop    %ebp
  8002e7:	c3                   	ret    

008002e8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002e8:	f3 0f 1e fb          	endbr32 
  8002ec:	55                   	push   %ebp
  8002ed:	89 e5                	mov    %esp,%ebp
  8002ef:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002f2:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002f6:	8b 10                	mov    (%eax),%edx
  8002f8:	3b 50 04             	cmp    0x4(%eax),%edx
  8002fb:	73 0a                	jae    800307 <sprintputch+0x1f>
		*b->buf++ = ch;
  8002fd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800300:	89 08                	mov    %ecx,(%eax)
  800302:	8b 45 08             	mov    0x8(%ebp),%eax
  800305:	88 02                	mov    %al,(%edx)
}
  800307:	5d                   	pop    %ebp
  800308:	c3                   	ret    

00800309 <printfmt>:
{
  800309:	f3 0f 1e fb          	endbr32 
  80030d:	55                   	push   %ebp
  80030e:	89 e5                	mov    %esp,%ebp
  800310:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800313:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800316:	50                   	push   %eax
  800317:	ff 75 10             	pushl  0x10(%ebp)
  80031a:	ff 75 0c             	pushl  0xc(%ebp)
  80031d:	ff 75 08             	pushl  0x8(%ebp)
  800320:	e8 05 00 00 00       	call   80032a <vprintfmt>
}
  800325:	83 c4 10             	add    $0x10,%esp
  800328:	c9                   	leave  
  800329:	c3                   	ret    

0080032a <vprintfmt>:
{
  80032a:	f3 0f 1e fb          	endbr32 
  80032e:	55                   	push   %ebp
  80032f:	89 e5                	mov    %esp,%ebp
  800331:	57                   	push   %edi
  800332:	56                   	push   %esi
  800333:	53                   	push   %ebx
  800334:	83 ec 3c             	sub    $0x3c,%esp
  800337:	8b 75 08             	mov    0x8(%ebp),%esi
  80033a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80033d:	8b 7d 10             	mov    0x10(%ebp),%edi
  800340:	e9 8e 03 00 00       	jmp    8006d3 <vprintfmt+0x3a9>
		padc = ' ';
  800345:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800349:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800350:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800357:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80035e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800363:	8d 47 01             	lea    0x1(%edi),%eax
  800366:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800369:	0f b6 17             	movzbl (%edi),%edx
  80036c:	8d 42 dd             	lea    -0x23(%edx),%eax
  80036f:	3c 55                	cmp    $0x55,%al
  800371:	0f 87 df 03 00 00    	ja     800756 <vprintfmt+0x42c>
  800377:	0f b6 c0             	movzbl %al,%eax
  80037a:	3e ff 24 85 60 12 80 	notrack jmp *0x801260(,%eax,4)
  800381:	00 
  800382:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800385:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800389:	eb d8                	jmp    800363 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80038b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80038e:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800392:	eb cf                	jmp    800363 <vprintfmt+0x39>
  800394:	0f b6 d2             	movzbl %dl,%edx
  800397:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80039a:	b8 00 00 00 00       	mov    $0x0,%eax
  80039f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003a2:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003a5:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003a9:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003ac:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003af:	83 f9 09             	cmp    $0x9,%ecx
  8003b2:	77 55                	ja     800409 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8003b4:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003b7:	eb e9                	jmp    8003a2 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8003b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003bc:	8b 00                	mov    (%eax),%eax
  8003be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c4:	8d 40 04             	lea    0x4(%eax),%eax
  8003c7:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003cd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003d1:	79 90                	jns    800363 <vprintfmt+0x39>
				width = precision, precision = -1;
  8003d3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003d9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003e0:	eb 81                	jmp    800363 <vprintfmt+0x39>
  8003e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003e5:	85 c0                	test   %eax,%eax
  8003e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ec:	0f 49 d0             	cmovns %eax,%edx
  8003ef:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003f5:	e9 69 ff ff ff       	jmp    800363 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003fa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003fd:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800404:	e9 5a ff ff ff       	jmp    800363 <vprintfmt+0x39>
  800409:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80040c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80040f:	eb bc                	jmp    8003cd <vprintfmt+0xa3>
			lflag++;
  800411:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800414:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800417:	e9 47 ff ff ff       	jmp    800363 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80041c:	8b 45 14             	mov    0x14(%ebp),%eax
  80041f:	8d 78 04             	lea    0x4(%eax),%edi
  800422:	83 ec 08             	sub    $0x8,%esp
  800425:	53                   	push   %ebx
  800426:	ff 30                	pushl  (%eax)
  800428:	ff d6                	call   *%esi
			break;
  80042a:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80042d:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800430:	e9 9b 02 00 00       	jmp    8006d0 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800435:	8b 45 14             	mov    0x14(%ebp),%eax
  800438:	8d 78 04             	lea    0x4(%eax),%edi
  80043b:	8b 00                	mov    (%eax),%eax
  80043d:	99                   	cltd   
  80043e:	31 d0                	xor    %edx,%eax
  800440:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800442:	83 f8 08             	cmp    $0x8,%eax
  800445:	7f 23                	jg     80046a <vprintfmt+0x140>
  800447:	8b 14 85 c0 13 80 00 	mov    0x8013c0(,%eax,4),%edx
  80044e:	85 d2                	test   %edx,%edx
  800450:	74 18                	je     80046a <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800452:	52                   	push   %edx
  800453:	68 ac 11 80 00       	push   $0x8011ac
  800458:	53                   	push   %ebx
  800459:	56                   	push   %esi
  80045a:	e8 aa fe ff ff       	call   800309 <printfmt>
  80045f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800462:	89 7d 14             	mov    %edi,0x14(%ebp)
  800465:	e9 66 02 00 00       	jmp    8006d0 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80046a:	50                   	push   %eax
  80046b:	68 a3 11 80 00       	push   $0x8011a3
  800470:	53                   	push   %ebx
  800471:	56                   	push   %esi
  800472:	e8 92 fe ff ff       	call   800309 <printfmt>
  800477:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80047a:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80047d:	e9 4e 02 00 00       	jmp    8006d0 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800482:	8b 45 14             	mov    0x14(%ebp),%eax
  800485:	83 c0 04             	add    $0x4,%eax
  800488:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80048b:	8b 45 14             	mov    0x14(%ebp),%eax
  80048e:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800490:	85 d2                	test   %edx,%edx
  800492:	b8 9c 11 80 00       	mov    $0x80119c,%eax
  800497:	0f 45 c2             	cmovne %edx,%eax
  80049a:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80049d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004a1:	7e 06                	jle    8004a9 <vprintfmt+0x17f>
  8004a3:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004a7:	75 0d                	jne    8004b6 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004ac:	89 c7                	mov    %eax,%edi
  8004ae:	03 45 e0             	add    -0x20(%ebp),%eax
  8004b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004b4:	eb 55                	jmp    80050b <vprintfmt+0x1e1>
  8004b6:	83 ec 08             	sub    $0x8,%esp
  8004b9:	ff 75 d8             	pushl  -0x28(%ebp)
  8004bc:	ff 75 cc             	pushl  -0x34(%ebp)
  8004bf:	e8 46 03 00 00       	call   80080a <strnlen>
  8004c4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004c7:	29 c2                	sub    %eax,%edx
  8004c9:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004cc:	83 c4 10             	add    $0x10,%esp
  8004cf:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004d1:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d8:	85 ff                	test   %edi,%edi
  8004da:	7e 11                	jle    8004ed <vprintfmt+0x1c3>
					putch(padc, putdat);
  8004dc:	83 ec 08             	sub    $0x8,%esp
  8004df:	53                   	push   %ebx
  8004e0:	ff 75 e0             	pushl  -0x20(%ebp)
  8004e3:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e5:	83 ef 01             	sub    $0x1,%edi
  8004e8:	83 c4 10             	add    $0x10,%esp
  8004eb:	eb eb                	jmp    8004d8 <vprintfmt+0x1ae>
  8004ed:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004f0:	85 d2                	test   %edx,%edx
  8004f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f7:	0f 49 c2             	cmovns %edx,%eax
  8004fa:	29 c2                	sub    %eax,%edx
  8004fc:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004ff:	eb a8                	jmp    8004a9 <vprintfmt+0x17f>
					putch(ch, putdat);
  800501:	83 ec 08             	sub    $0x8,%esp
  800504:	53                   	push   %ebx
  800505:	52                   	push   %edx
  800506:	ff d6                	call   *%esi
  800508:	83 c4 10             	add    $0x10,%esp
  80050b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80050e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800510:	83 c7 01             	add    $0x1,%edi
  800513:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800517:	0f be d0             	movsbl %al,%edx
  80051a:	85 d2                	test   %edx,%edx
  80051c:	74 4b                	je     800569 <vprintfmt+0x23f>
  80051e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800522:	78 06                	js     80052a <vprintfmt+0x200>
  800524:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800528:	78 1e                	js     800548 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  80052a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80052e:	74 d1                	je     800501 <vprintfmt+0x1d7>
  800530:	0f be c0             	movsbl %al,%eax
  800533:	83 e8 20             	sub    $0x20,%eax
  800536:	83 f8 5e             	cmp    $0x5e,%eax
  800539:	76 c6                	jbe    800501 <vprintfmt+0x1d7>
					putch('?', putdat);
  80053b:	83 ec 08             	sub    $0x8,%esp
  80053e:	53                   	push   %ebx
  80053f:	6a 3f                	push   $0x3f
  800541:	ff d6                	call   *%esi
  800543:	83 c4 10             	add    $0x10,%esp
  800546:	eb c3                	jmp    80050b <vprintfmt+0x1e1>
  800548:	89 cf                	mov    %ecx,%edi
  80054a:	eb 0e                	jmp    80055a <vprintfmt+0x230>
				putch(' ', putdat);
  80054c:	83 ec 08             	sub    $0x8,%esp
  80054f:	53                   	push   %ebx
  800550:	6a 20                	push   $0x20
  800552:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800554:	83 ef 01             	sub    $0x1,%edi
  800557:	83 c4 10             	add    $0x10,%esp
  80055a:	85 ff                	test   %edi,%edi
  80055c:	7f ee                	jg     80054c <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  80055e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800561:	89 45 14             	mov    %eax,0x14(%ebp)
  800564:	e9 67 01 00 00       	jmp    8006d0 <vprintfmt+0x3a6>
  800569:	89 cf                	mov    %ecx,%edi
  80056b:	eb ed                	jmp    80055a <vprintfmt+0x230>
	if (lflag >= 2)
  80056d:	83 f9 01             	cmp    $0x1,%ecx
  800570:	7f 1b                	jg     80058d <vprintfmt+0x263>
	else if (lflag)
  800572:	85 c9                	test   %ecx,%ecx
  800574:	74 63                	je     8005d9 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800576:	8b 45 14             	mov    0x14(%ebp),%eax
  800579:	8b 00                	mov    (%eax),%eax
  80057b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80057e:	99                   	cltd   
  80057f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800582:	8b 45 14             	mov    0x14(%ebp),%eax
  800585:	8d 40 04             	lea    0x4(%eax),%eax
  800588:	89 45 14             	mov    %eax,0x14(%ebp)
  80058b:	eb 17                	jmp    8005a4 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  80058d:	8b 45 14             	mov    0x14(%ebp),%eax
  800590:	8b 50 04             	mov    0x4(%eax),%edx
  800593:	8b 00                	mov    (%eax),%eax
  800595:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800598:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80059b:	8b 45 14             	mov    0x14(%ebp),%eax
  80059e:	8d 40 08             	lea    0x8(%eax),%eax
  8005a1:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005a4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005a7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005aa:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8005af:	85 c9                	test   %ecx,%ecx
  8005b1:	0f 89 ff 00 00 00    	jns    8006b6 <vprintfmt+0x38c>
				putch('-', putdat);
  8005b7:	83 ec 08             	sub    $0x8,%esp
  8005ba:	53                   	push   %ebx
  8005bb:	6a 2d                	push   $0x2d
  8005bd:	ff d6                	call   *%esi
				num = -(long long) num;
  8005bf:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005c2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005c5:	f7 da                	neg    %edx
  8005c7:	83 d1 00             	adc    $0x0,%ecx
  8005ca:	f7 d9                	neg    %ecx
  8005cc:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005cf:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d4:	e9 dd 00 00 00       	jmp    8006b6 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8005d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dc:	8b 00                	mov    (%eax),%eax
  8005de:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e1:	99                   	cltd   
  8005e2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e8:	8d 40 04             	lea    0x4(%eax),%eax
  8005eb:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ee:	eb b4                	jmp    8005a4 <vprintfmt+0x27a>
	if (lflag >= 2)
  8005f0:	83 f9 01             	cmp    $0x1,%ecx
  8005f3:	7f 1e                	jg     800613 <vprintfmt+0x2e9>
	else if (lflag)
  8005f5:	85 c9                	test   %ecx,%ecx
  8005f7:	74 32                	je     80062b <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8005f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fc:	8b 10                	mov    (%eax),%edx
  8005fe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800603:	8d 40 04             	lea    0x4(%eax),%eax
  800606:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800609:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  80060e:	e9 a3 00 00 00       	jmp    8006b6 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800613:	8b 45 14             	mov    0x14(%ebp),%eax
  800616:	8b 10                	mov    (%eax),%edx
  800618:	8b 48 04             	mov    0x4(%eax),%ecx
  80061b:	8d 40 08             	lea    0x8(%eax),%eax
  80061e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800621:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800626:	e9 8b 00 00 00       	jmp    8006b6 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80062b:	8b 45 14             	mov    0x14(%ebp),%eax
  80062e:	8b 10                	mov    (%eax),%edx
  800630:	b9 00 00 00 00       	mov    $0x0,%ecx
  800635:	8d 40 04             	lea    0x4(%eax),%eax
  800638:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80063b:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800640:	eb 74                	jmp    8006b6 <vprintfmt+0x38c>
	if (lflag >= 2)
  800642:	83 f9 01             	cmp    $0x1,%ecx
  800645:	7f 1b                	jg     800662 <vprintfmt+0x338>
	else if (lflag)
  800647:	85 c9                	test   %ecx,%ecx
  800649:	74 2c                	je     800677 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  80064b:	8b 45 14             	mov    0x14(%ebp),%eax
  80064e:	8b 10                	mov    (%eax),%edx
  800650:	b9 00 00 00 00       	mov    $0x0,%ecx
  800655:	8d 40 04             	lea    0x4(%eax),%eax
  800658:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80065b:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800660:	eb 54                	jmp    8006b6 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800662:	8b 45 14             	mov    0x14(%ebp),%eax
  800665:	8b 10                	mov    (%eax),%edx
  800667:	8b 48 04             	mov    0x4(%eax),%ecx
  80066a:	8d 40 08             	lea    0x8(%eax),%eax
  80066d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800670:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800675:	eb 3f                	jmp    8006b6 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800677:	8b 45 14             	mov    0x14(%ebp),%eax
  80067a:	8b 10                	mov    (%eax),%edx
  80067c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800681:	8d 40 04             	lea    0x4(%eax),%eax
  800684:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800687:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  80068c:	eb 28                	jmp    8006b6 <vprintfmt+0x38c>
			putch('0', putdat);
  80068e:	83 ec 08             	sub    $0x8,%esp
  800691:	53                   	push   %ebx
  800692:	6a 30                	push   $0x30
  800694:	ff d6                	call   *%esi
			putch('x', putdat);
  800696:	83 c4 08             	add    $0x8,%esp
  800699:	53                   	push   %ebx
  80069a:	6a 78                	push   $0x78
  80069c:	ff d6                	call   *%esi
			num = (unsigned long long)
  80069e:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a1:	8b 10                	mov    (%eax),%edx
  8006a3:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006a8:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006ab:	8d 40 04             	lea    0x4(%eax),%eax
  8006ae:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b1:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006b6:	83 ec 0c             	sub    $0xc,%esp
  8006b9:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8006bd:	57                   	push   %edi
  8006be:	ff 75 e0             	pushl  -0x20(%ebp)
  8006c1:	50                   	push   %eax
  8006c2:	51                   	push   %ecx
  8006c3:	52                   	push   %edx
  8006c4:	89 da                	mov    %ebx,%edx
  8006c6:	89 f0                	mov    %esi,%eax
  8006c8:	e8 72 fb ff ff       	call   80023f <printnum>
			break;
  8006cd:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006d3:	83 c7 01             	add    $0x1,%edi
  8006d6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006da:	83 f8 25             	cmp    $0x25,%eax
  8006dd:	0f 84 62 fc ff ff    	je     800345 <vprintfmt+0x1b>
			if (ch == '\0')
  8006e3:	85 c0                	test   %eax,%eax
  8006e5:	0f 84 8b 00 00 00    	je     800776 <vprintfmt+0x44c>
			putch(ch, putdat);
  8006eb:	83 ec 08             	sub    $0x8,%esp
  8006ee:	53                   	push   %ebx
  8006ef:	50                   	push   %eax
  8006f0:	ff d6                	call   *%esi
  8006f2:	83 c4 10             	add    $0x10,%esp
  8006f5:	eb dc                	jmp    8006d3 <vprintfmt+0x3a9>
	if (lflag >= 2)
  8006f7:	83 f9 01             	cmp    $0x1,%ecx
  8006fa:	7f 1b                	jg     800717 <vprintfmt+0x3ed>
	else if (lflag)
  8006fc:	85 c9                	test   %ecx,%ecx
  8006fe:	74 2c                	je     80072c <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800700:	8b 45 14             	mov    0x14(%ebp),%eax
  800703:	8b 10                	mov    (%eax),%edx
  800705:	b9 00 00 00 00       	mov    $0x0,%ecx
  80070a:	8d 40 04             	lea    0x4(%eax),%eax
  80070d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800710:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800715:	eb 9f                	jmp    8006b6 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800717:	8b 45 14             	mov    0x14(%ebp),%eax
  80071a:	8b 10                	mov    (%eax),%edx
  80071c:	8b 48 04             	mov    0x4(%eax),%ecx
  80071f:	8d 40 08             	lea    0x8(%eax),%eax
  800722:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800725:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  80072a:	eb 8a                	jmp    8006b6 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80072c:	8b 45 14             	mov    0x14(%ebp),%eax
  80072f:	8b 10                	mov    (%eax),%edx
  800731:	b9 00 00 00 00       	mov    $0x0,%ecx
  800736:	8d 40 04             	lea    0x4(%eax),%eax
  800739:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80073c:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800741:	e9 70 ff ff ff       	jmp    8006b6 <vprintfmt+0x38c>
			putch(ch, putdat);
  800746:	83 ec 08             	sub    $0x8,%esp
  800749:	53                   	push   %ebx
  80074a:	6a 25                	push   $0x25
  80074c:	ff d6                	call   *%esi
			break;
  80074e:	83 c4 10             	add    $0x10,%esp
  800751:	e9 7a ff ff ff       	jmp    8006d0 <vprintfmt+0x3a6>
			putch('%', putdat);
  800756:	83 ec 08             	sub    $0x8,%esp
  800759:	53                   	push   %ebx
  80075a:	6a 25                	push   $0x25
  80075c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80075e:	83 c4 10             	add    $0x10,%esp
  800761:	89 f8                	mov    %edi,%eax
  800763:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800767:	74 05                	je     80076e <vprintfmt+0x444>
  800769:	83 e8 01             	sub    $0x1,%eax
  80076c:	eb f5                	jmp    800763 <vprintfmt+0x439>
  80076e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800771:	e9 5a ff ff ff       	jmp    8006d0 <vprintfmt+0x3a6>
}
  800776:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800779:	5b                   	pop    %ebx
  80077a:	5e                   	pop    %esi
  80077b:	5f                   	pop    %edi
  80077c:	5d                   	pop    %ebp
  80077d:	c3                   	ret    

0080077e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80077e:	f3 0f 1e fb          	endbr32 
  800782:	55                   	push   %ebp
  800783:	89 e5                	mov    %esp,%ebp
  800785:	83 ec 18             	sub    $0x18,%esp
  800788:	8b 45 08             	mov    0x8(%ebp),%eax
  80078b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80078e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800791:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800795:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800798:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80079f:	85 c0                	test   %eax,%eax
  8007a1:	74 26                	je     8007c9 <vsnprintf+0x4b>
  8007a3:	85 d2                	test   %edx,%edx
  8007a5:	7e 22                	jle    8007c9 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007a7:	ff 75 14             	pushl  0x14(%ebp)
  8007aa:	ff 75 10             	pushl  0x10(%ebp)
  8007ad:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007b0:	50                   	push   %eax
  8007b1:	68 e8 02 80 00       	push   $0x8002e8
  8007b6:	e8 6f fb ff ff       	call   80032a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007be:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007c4:	83 c4 10             	add    $0x10,%esp
}
  8007c7:	c9                   	leave  
  8007c8:	c3                   	ret    
		return -E_INVAL;
  8007c9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007ce:	eb f7                	jmp    8007c7 <vsnprintf+0x49>

008007d0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007d0:	f3 0f 1e fb          	endbr32 
  8007d4:	55                   	push   %ebp
  8007d5:	89 e5                	mov    %esp,%ebp
  8007d7:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007da:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007dd:	50                   	push   %eax
  8007de:	ff 75 10             	pushl  0x10(%ebp)
  8007e1:	ff 75 0c             	pushl  0xc(%ebp)
  8007e4:	ff 75 08             	pushl  0x8(%ebp)
  8007e7:	e8 92 ff ff ff       	call   80077e <vsnprintf>
	va_end(ap);

	return rc;
}
  8007ec:	c9                   	leave  
  8007ed:	c3                   	ret    

008007ee <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007ee:	f3 0f 1e fb          	endbr32 
  8007f2:	55                   	push   %ebp
  8007f3:	89 e5                	mov    %esp,%ebp
  8007f5:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8007fd:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800801:	74 05                	je     800808 <strlen+0x1a>
		n++;
  800803:	83 c0 01             	add    $0x1,%eax
  800806:	eb f5                	jmp    8007fd <strlen+0xf>
	return n;
}
  800808:	5d                   	pop    %ebp
  800809:	c3                   	ret    

0080080a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80080a:	f3 0f 1e fb          	endbr32 
  80080e:	55                   	push   %ebp
  80080f:	89 e5                	mov    %esp,%ebp
  800811:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800814:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800817:	b8 00 00 00 00       	mov    $0x0,%eax
  80081c:	39 d0                	cmp    %edx,%eax
  80081e:	74 0d                	je     80082d <strnlen+0x23>
  800820:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800824:	74 05                	je     80082b <strnlen+0x21>
		n++;
  800826:	83 c0 01             	add    $0x1,%eax
  800829:	eb f1                	jmp    80081c <strnlen+0x12>
  80082b:	89 c2                	mov    %eax,%edx
	return n;
}
  80082d:	89 d0                	mov    %edx,%eax
  80082f:	5d                   	pop    %ebp
  800830:	c3                   	ret    

00800831 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800831:	f3 0f 1e fb          	endbr32 
  800835:	55                   	push   %ebp
  800836:	89 e5                	mov    %esp,%ebp
  800838:	53                   	push   %ebx
  800839:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80083c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80083f:	b8 00 00 00 00       	mov    $0x0,%eax
  800844:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800848:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  80084b:	83 c0 01             	add    $0x1,%eax
  80084e:	84 d2                	test   %dl,%dl
  800850:	75 f2                	jne    800844 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800852:	89 c8                	mov    %ecx,%eax
  800854:	5b                   	pop    %ebx
  800855:	5d                   	pop    %ebp
  800856:	c3                   	ret    

00800857 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800857:	f3 0f 1e fb          	endbr32 
  80085b:	55                   	push   %ebp
  80085c:	89 e5                	mov    %esp,%ebp
  80085e:	53                   	push   %ebx
  80085f:	83 ec 10             	sub    $0x10,%esp
  800862:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800865:	53                   	push   %ebx
  800866:	e8 83 ff ff ff       	call   8007ee <strlen>
  80086b:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80086e:	ff 75 0c             	pushl  0xc(%ebp)
  800871:	01 d8                	add    %ebx,%eax
  800873:	50                   	push   %eax
  800874:	e8 b8 ff ff ff       	call   800831 <strcpy>
	return dst;
}
  800879:	89 d8                	mov    %ebx,%eax
  80087b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80087e:	c9                   	leave  
  80087f:	c3                   	ret    

00800880 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800880:	f3 0f 1e fb          	endbr32 
  800884:	55                   	push   %ebp
  800885:	89 e5                	mov    %esp,%ebp
  800887:	56                   	push   %esi
  800888:	53                   	push   %ebx
  800889:	8b 75 08             	mov    0x8(%ebp),%esi
  80088c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80088f:	89 f3                	mov    %esi,%ebx
  800891:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800894:	89 f0                	mov    %esi,%eax
  800896:	39 d8                	cmp    %ebx,%eax
  800898:	74 11                	je     8008ab <strncpy+0x2b>
		*dst++ = *src;
  80089a:	83 c0 01             	add    $0x1,%eax
  80089d:	0f b6 0a             	movzbl (%edx),%ecx
  8008a0:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008a3:	80 f9 01             	cmp    $0x1,%cl
  8008a6:	83 da ff             	sbb    $0xffffffff,%edx
  8008a9:	eb eb                	jmp    800896 <strncpy+0x16>
	}
	return ret;
}
  8008ab:	89 f0                	mov    %esi,%eax
  8008ad:	5b                   	pop    %ebx
  8008ae:	5e                   	pop    %esi
  8008af:	5d                   	pop    %ebp
  8008b0:	c3                   	ret    

008008b1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008b1:	f3 0f 1e fb          	endbr32 
  8008b5:	55                   	push   %ebp
  8008b6:	89 e5                	mov    %esp,%ebp
  8008b8:	56                   	push   %esi
  8008b9:	53                   	push   %ebx
  8008ba:	8b 75 08             	mov    0x8(%ebp),%esi
  8008bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008c0:	8b 55 10             	mov    0x10(%ebp),%edx
  8008c3:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008c5:	85 d2                	test   %edx,%edx
  8008c7:	74 21                	je     8008ea <strlcpy+0x39>
  8008c9:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008cd:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008cf:	39 c2                	cmp    %eax,%edx
  8008d1:	74 14                	je     8008e7 <strlcpy+0x36>
  8008d3:	0f b6 19             	movzbl (%ecx),%ebx
  8008d6:	84 db                	test   %bl,%bl
  8008d8:	74 0b                	je     8008e5 <strlcpy+0x34>
			*dst++ = *src++;
  8008da:	83 c1 01             	add    $0x1,%ecx
  8008dd:	83 c2 01             	add    $0x1,%edx
  8008e0:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008e3:	eb ea                	jmp    8008cf <strlcpy+0x1e>
  8008e5:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008e7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008ea:	29 f0                	sub    %esi,%eax
}
  8008ec:	5b                   	pop    %ebx
  8008ed:	5e                   	pop    %esi
  8008ee:	5d                   	pop    %ebp
  8008ef:	c3                   	ret    

008008f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008f0:	f3 0f 1e fb          	endbr32 
  8008f4:	55                   	push   %ebp
  8008f5:	89 e5                	mov    %esp,%ebp
  8008f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008fa:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008fd:	0f b6 01             	movzbl (%ecx),%eax
  800900:	84 c0                	test   %al,%al
  800902:	74 0c                	je     800910 <strcmp+0x20>
  800904:	3a 02                	cmp    (%edx),%al
  800906:	75 08                	jne    800910 <strcmp+0x20>
		p++, q++;
  800908:	83 c1 01             	add    $0x1,%ecx
  80090b:	83 c2 01             	add    $0x1,%edx
  80090e:	eb ed                	jmp    8008fd <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800910:	0f b6 c0             	movzbl %al,%eax
  800913:	0f b6 12             	movzbl (%edx),%edx
  800916:	29 d0                	sub    %edx,%eax
}
  800918:	5d                   	pop    %ebp
  800919:	c3                   	ret    

0080091a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80091a:	f3 0f 1e fb          	endbr32 
  80091e:	55                   	push   %ebp
  80091f:	89 e5                	mov    %esp,%ebp
  800921:	53                   	push   %ebx
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	8b 55 0c             	mov    0xc(%ebp),%edx
  800928:	89 c3                	mov    %eax,%ebx
  80092a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80092d:	eb 06                	jmp    800935 <strncmp+0x1b>
		n--, p++, q++;
  80092f:	83 c0 01             	add    $0x1,%eax
  800932:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800935:	39 d8                	cmp    %ebx,%eax
  800937:	74 16                	je     80094f <strncmp+0x35>
  800939:	0f b6 08             	movzbl (%eax),%ecx
  80093c:	84 c9                	test   %cl,%cl
  80093e:	74 04                	je     800944 <strncmp+0x2a>
  800940:	3a 0a                	cmp    (%edx),%cl
  800942:	74 eb                	je     80092f <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800944:	0f b6 00             	movzbl (%eax),%eax
  800947:	0f b6 12             	movzbl (%edx),%edx
  80094a:	29 d0                	sub    %edx,%eax
}
  80094c:	5b                   	pop    %ebx
  80094d:	5d                   	pop    %ebp
  80094e:	c3                   	ret    
		return 0;
  80094f:	b8 00 00 00 00       	mov    $0x0,%eax
  800954:	eb f6                	jmp    80094c <strncmp+0x32>

00800956 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800956:	f3 0f 1e fb          	endbr32 
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	8b 45 08             	mov    0x8(%ebp),%eax
  800960:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800964:	0f b6 10             	movzbl (%eax),%edx
  800967:	84 d2                	test   %dl,%dl
  800969:	74 09                	je     800974 <strchr+0x1e>
		if (*s == c)
  80096b:	38 ca                	cmp    %cl,%dl
  80096d:	74 0a                	je     800979 <strchr+0x23>
	for (; *s; s++)
  80096f:	83 c0 01             	add    $0x1,%eax
  800972:	eb f0                	jmp    800964 <strchr+0xe>
			return (char *) s;
	return 0;
  800974:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800979:	5d                   	pop    %ebp
  80097a:	c3                   	ret    

0080097b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80097b:	f3 0f 1e fb          	endbr32 
  80097f:	55                   	push   %ebp
  800980:	89 e5                	mov    %esp,%ebp
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800989:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80098c:	38 ca                	cmp    %cl,%dl
  80098e:	74 09                	je     800999 <strfind+0x1e>
  800990:	84 d2                	test   %dl,%dl
  800992:	74 05                	je     800999 <strfind+0x1e>
	for (; *s; s++)
  800994:	83 c0 01             	add    $0x1,%eax
  800997:	eb f0                	jmp    800989 <strfind+0xe>
			break;
	return (char *) s;
}
  800999:	5d                   	pop    %ebp
  80099a:	c3                   	ret    

0080099b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80099b:	f3 0f 1e fb          	endbr32 
  80099f:	55                   	push   %ebp
  8009a0:	89 e5                	mov    %esp,%ebp
  8009a2:	57                   	push   %edi
  8009a3:	56                   	push   %esi
  8009a4:	53                   	push   %ebx
  8009a5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009ab:	85 c9                	test   %ecx,%ecx
  8009ad:	74 31                	je     8009e0 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009af:	89 f8                	mov    %edi,%eax
  8009b1:	09 c8                	or     %ecx,%eax
  8009b3:	a8 03                	test   $0x3,%al
  8009b5:	75 23                	jne    8009da <memset+0x3f>
		c &= 0xFF;
  8009b7:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009bb:	89 d3                	mov    %edx,%ebx
  8009bd:	c1 e3 08             	shl    $0x8,%ebx
  8009c0:	89 d0                	mov    %edx,%eax
  8009c2:	c1 e0 18             	shl    $0x18,%eax
  8009c5:	89 d6                	mov    %edx,%esi
  8009c7:	c1 e6 10             	shl    $0x10,%esi
  8009ca:	09 f0                	or     %esi,%eax
  8009cc:	09 c2                	or     %eax,%edx
  8009ce:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009d0:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009d3:	89 d0                	mov    %edx,%eax
  8009d5:	fc                   	cld    
  8009d6:	f3 ab                	rep stos %eax,%es:(%edi)
  8009d8:	eb 06                	jmp    8009e0 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009dd:	fc                   	cld    
  8009de:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009e0:	89 f8                	mov    %edi,%eax
  8009e2:	5b                   	pop    %ebx
  8009e3:	5e                   	pop    %esi
  8009e4:	5f                   	pop    %edi
  8009e5:	5d                   	pop    %ebp
  8009e6:	c3                   	ret    

008009e7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009e7:	f3 0f 1e fb          	endbr32 
  8009eb:	55                   	push   %ebp
  8009ec:	89 e5                	mov    %esp,%ebp
  8009ee:	57                   	push   %edi
  8009ef:	56                   	push   %esi
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009f9:	39 c6                	cmp    %eax,%esi
  8009fb:	73 32                	jae    800a2f <memmove+0x48>
  8009fd:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a00:	39 c2                	cmp    %eax,%edx
  800a02:	76 2b                	jbe    800a2f <memmove+0x48>
		s += n;
		d += n;
  800a04:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a07:	89 fe                	mov    %edi,%esi
  800a09:	09 ce                	or     %ecx,%esi
  800a0b:	09 d6                	or     %edx,%esi
  800a0d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a13:	75 0e                	jne    800a23 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a15:	83 ef 04             	sub    $0x4,%edi
  800a18:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a1b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a1e:	fd                   	std    
  800a1f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a21:	eb 09                	jmp    800a2c <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a23:	83 ef 01             	sub    $0x1,%edi
  800a26:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a29:	fd                   	std    
  800a2a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a2c:	fc                   	cld    
  800a2d:	eb 1a                	jmp    800a49 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a2f:	89 c2                	mov    %eax,%edx
  800a31:	09 ca                	or     %ecx,%edx
  800a33:	09 f2                	or     %esi,%edx
  800a35:	f6 c2 03             	test   $0x3,%dl
  800a38:	75 0a                	jne    800a44 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a3a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a3d:	89 c7                	mov    %eax,%edi
  800a3f:	fc                   	cld    
  800a40:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a42:	eb 05                	jmp    800a49 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800a44:	89 c7                	mov    %eax,%edi
  800a46:	fc                   	cld    
  800a47:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a49:	5e                   	pop    %esi
  800a4a:	5f                   	pop    %edi
  800a4b:	5d                   	pop    %ebp
  800a4c:	c3                   	ret    

00800a4d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a4d:	f3 0f 1e fb          	endbr32 
  800a51:	55                   	push   %ebp
  800a52:	89 e5                	mov    %esp,%ebp
  800a54:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a57:	ff 75 10             	pushl  0x10(%ebp)
  800a5a:	ff 75 0c             	pushl  0xc(%ebp)
  800a5d:	ff 75 08             	pushl  0x8(%ebp)
  800a60:	e8 82 ff ff ff       	call   8009e7 <memmove>
}
  800a65:	c9                   	leave  
  800a66:	c3                   	ret    

00800a67 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a67:	f3 0f 1e fb          	endbr32 
  800a6b:	55                   	push   %ebp
  800a6c:	89 e5                	mov    %esp,%ebp
  800a6e:	56                   	push   %esi
  800a6f:	53                   	push   %ebx
  800a70:	8b 45 08             	mov    0x8(%ebp),%eax
  800a73:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a76:	89 c6                	mov    %eax,%esi
  800a78:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a7b:	39 f0                	cmp    %esi,%eax
  800a7d:	74 1c                	je     800a9b <memcmp+0x34>
		if (*s1 != *s2)
  800a7f:	0f b6 08             	movzbl (%eax),%ecx
  800a82:	0f b6 1a             	movzbl (%edx),%ebx
  800a85:	38 d9                	cmp    %bl,%cl
  800a87:	75 08                	jne    800a91 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a89:	83 c0 01             	add    $0x1,%eax
  800a8c:	83 c2 01             	add    $0x1,%edx
  800a8f:	eb ea                	jmp    800a7b <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a91:	0f b6 c1             	movzbl %cl,%eax
  800a94:	0f b6 db             	movzbl %bl,%ebx
  800a97:	29 d8                	sub    %ebx,%eax
  800a99:	eb 05                	jmp    800aa0 <memcmp+0x39>
	}

	return 0;
  800a9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aa0:	5b                   	pop    %ebx
  800aa1:	5e                   	pop    %esi
  800aa2:	5d                   	pop    %ebp
  800aa3:	c3                   	ret    

00800aa4 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800aa4:	f3 0f 1e fb          	endbr32 
  800aa8:	55                   	push   %ebp
  800aa9:	89 e5                	mov    %esp,%ebp
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ab1:	89 c2                	mov    %eax,%edx
  800ab3:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ab6:	39 d0                	cmp    %edx,%eax
  800ab8:	73 09                	jae    800ac3 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800aba:	38 08                	cmp    %cl,(%eax)
  800abc:	74 05                	je     800ac3 <memfind+0x1f>
	for (; s < ends; s++)
  800abe:	83 c0 01             	add    $0x1,%eax
  800ac1:	eb f3                	jmp    800ab6 <memfind+0x12>
			break;
	return (void *) s;
}
  800ac3:	5d                   	pop    %ebp
  800ac4:	c3                   	ret    

00800ac5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ac5:	f3 0f 1e fb          	endbr32 
  800ac9:	55                   	push   %ebp
  800aca:	89 e5                	mov    %esp,%ebp
  800acc:	57                   	push   %edi
  800acd:	56                   	push   %esi
  800ace:	53                   	push   %ebx
  800acf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ad2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ad5:	eb 03                	jmp    800ada <strtol+0x15>
		s++;
  800ad7:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ada:	0f b6 01             	movzbl (%ecx),%eax
  800add:	3c 20                	cmp    $0x20,%al
  800adf:	74 f6                	je     800ad7 <strtol+0x12>
  800ae1:	3c 09                	cmp    $0x9,%al
  800ae3:	74 f2                	je     800ad7 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800ae5:	3c 2b                	cmp    $0x2b,%al
  800ae7:	74 2a                	je     800b13 <strtol+0x4e>
	int neg = 0;
  800ae9:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800aee:	3c 2d                	cmp    $0x2d,%al
  800af0:	74 2b                	je     800b1d <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800af2:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800af8:	75 0f                	jne    800b09 <strtol+0x44>
  800afa:	80 39 30             	cmpb   $0x30,(%ecx)
  800afd:	74 28                	je     800b27 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800aff:	85 db                	test   %ebx,%ebx
  800b01:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b06:	0f 44 d8             	cmove  %eax,%ebx
  800b09:	b8 00 00 00 00       	mov    $0x0,%eax
  800b0e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b11:	eb 46                	jmp    800b59 <strtol+0x94>
		s++;
  800b13:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b16:	bf 00 00 00 00       	mov    $0x0,%edi
  800b1b:	eb d5                	jmp    800af2 <strtol+0x2d>
		s++, neg = 1;
  800b1d:	83 c1 01             	add    $0x1,%ecx
  800b20:	bf 01 00 00 00       	mov    $0x1,%edi
  800b25:	eb cb                	jmp    800af2 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b27:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b2b:	74 0e                	je     800b3b <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b2d:	85 db                	test   %ebx,%ebx
  800b2f:	75 d8                	jne    800b09 <strtol+0x44>
		s++, base = 8;
  800b31:	83 c1 01             	add    $0x1,%ecx
  800b34:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b39:	eb ce                	jmp    800b09 <strtol+0x44>
		s += 2, base = 16;
  800b3b:	83 c1 02             	add    $0x2,%ecx
  800b3e:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b43:	eb c4                	jmp    800b09 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b45:	0f be d2             	movsbl %dl,%edx
  800b48:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b4b:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b4e:	7d 3a                	jge    800b8a <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b50:	83 c1 01             	add    $0x1,%ecx
  800b53:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b57:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b59:	0f b6 11             	movzbl (%ecx),%edx
  800b5c:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b5f:	89 f3                	mov    %esi,%ebx
  800b61:	80 fb 09             	cmp    $0x9,%bl
  800b64:	76 df                	jbe    800b45 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b66:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b69:	89 f3                	mov    %esi,%ebx
  800b6b:	80 fb 19             	cmp    $0x19,%bl
  800b6e:	77 08                	ja     800b78 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b70:	0f be d2             	movsbl %dl,%edx
  800b73:	83 ea 57             	sub    $0x57,%edx
  800b76:	eb d3                	jmp    800b4b <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b78:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b7b:	89 f3                	mov    %esi,%ebx
  800b7d:	80 fb 19             	cmp    $0x19,%bl
  800b80:	77 08                	ja     800b8a <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b82:	0f be d2             	movsbl %dl,%edx
  800b85:	83 ea 37             	sub    $0x37,%edx
  800b88:	eb c1                	jmp    800b4b <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b8a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b8e:	74 05                	je     800b95 <strtol+0xd0>
		*endptr = (char *) s;
  800b90:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b93:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b95:	89 c2                	mov    %eax,%edx
  800b97:	f7 da                	neg    %edx
  800b99:	85 ff                	test   %edi,%edi
  800b9b:	0f 45 c2             	cmovne %edx,%eax
}
  800b9e:	5b                   	pop    %ebx
  800b9f:	5e                   	pop    %esi
  800ba0:	5f                   	pop    %edi
  800ba1:	5d                   	pop    %ebp
  800ba2:	c3                   	ret    

00800ba3 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ba3:	f3 0f 1e fb          	endbr32 
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	57                   	push   %edi
  800bab:	56                   	push   %esi
  800bac:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bad:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb2:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bb8:	89 c3                	mov    %eax,%ebx
  800bba:	89 c7                	mov    %eax,%edi
  800bbc:	89 c6                	mov    %eax,%esi
  800bbe:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bc0:	5b                   	pop    %ebx
  800bc1:	5e                   	pop    %esi
  800bc2:	5f                   	pop    %edi
  800bc3:	5d                   	pop    %ebp
  800bc4:	c3                   	ret    

00800bc5 <sys_cgetc>:

int
sys_cgetc(void)
{
  800bc5:	f3 0f 1e fb          	endbr32 
  800bc9:	55                   	push   %ebp
  800bca:	89 e5                	mov    %esp,%ebp
  800bcc:	57                   	push   %edi
  800bcd:	56                   	push   %esi
  800bce:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bcf:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd4:	b8 01 00 00 00       	mov    $0x1,%eax
  800bd9:	89 d1                	mov    %edx,%ecx
  800bdb:	89 d3                	mov    %edx,%ebx
  800bdd:	89 d7                	mov    %edx,%edi
  800bdf:	89 d6                	mov    %edx,%esi
  800be1:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800be3:	5b                   	pop    %ebx
  800be4:	5e                   	pop    %esi
  800be5:	5f                   	pop    %edi
  800be6:	5d                   	pop    %ebp
  800be7:	c3                   	ret    

00800be8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800be8:	f3 0f 1e fb          	endbr32 
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	57                   	push   %edi
  800bf0:	56                   	push   %esi
  800bf1:	53                   	push   %ebx
  800bf2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bf5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bfa:	8b 55 08             	mov    0x8(%ebp),%edx
  800bfd:	b8 03 00 00 00       	mov    $0x3,%eax
  800c02:	89 cb                	mov    %ecx,%ebx
  800c04:	89 cf                	mov    %ecx,%edi
  800c06:	89 ce                	mov    %ecx,%esi
  800c08:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c0a:	85 c0                	test   %eax,%eax
  800c0c:	7f 08                	jg     800c16 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c11:	5b                   	pop    %ebx
  800c12:	5e                   	pop    %esi
  800c13:	5f                   	pop    %edi
  800c14:	5d                   	pop    %ebp
  800c15:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c16:	83 ec 0c             	sub    $0xc,%esp
  800c19:	50                   	push   %eax
  800c1a:	6a 03                	push   $0x3
  800c1c:	68 e4 13 80 00       	push   $0x8013e4
  800c21:	6a 23                	push   $0x23
  800c23:	68 01 14 80 00       	push   $0x801401
  800c28:	e8 13 f5 ff ff       	call   800140 <_panic>

00800c2d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c2d:	f3 0f 1e fb          	endbr32 
  800c31:	55                   	push   %ebp
  800c32:	89 e5                	mov    %esp,%ebp
  800c34:	57                   	push   %edi
  800c35:	56                   	push   %esi
  800c36:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c37:	ba 00 00 00 00       	mov    $0x0,%edx
  800c3c:	b8 02 00 00 00       	mov    $0x2,%eax
  800c41:	89 d1                	mov    %edx,%ecx
  800c43:	89 d3                	mov    %edx,%ebx
  800c45:	89 d7                	mov    %edx,%edi
  800c47:	89 d6                	mov    %edx,%esi
  800c49:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c4b:	5b                   	pop    %ebx
  800c4c:	5e                   	pop    %esi
  800c4d:	5f                   	pop    %edi
  800c4e:	5d                   	pop    %ebp
  800c4f:	c3                   	ret    

00800c50 <sys_yield>:

void
sys_yield(void)
{
  800c50:	f3 0f 1e fb          	endbr32 
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	57                   	push   %edi
  800c58:	56                   	push   %esi
  800c59:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c5a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c5f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c64:	89 d1                	mov    %edx,%ecx
  800c66:	89 d3                	mov    %edx,%ebx
  800c68:	89 d7                	mov    %edx,%edi
  800c6a:	89 d6                	mov    %edx,%esi
  800c6c:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c6e:	5b                   	pop    %ebx
  800c6f:	5e                   	pop    %esi
  800c70:	5f                   	pop    %edi
  800c71:	5d                   	pop    %ebp
  800c72:	c3                   	ret    

00800c73 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c73:	f3 0f 1e fb          	endbr32 
  800c77:	55                   	push   %ebp
  800c78:	89 e5                	mov    %esp,%ebp
  800c7a:	57                   	push   %edi
  800c7b:	56                   	push   %esi
  800c7c:	53                   	push   %ebx
  800c7d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c80:	be 00 00 00 00       	mov    $0x0,%esi
  800c85:	8b 55 08             	mov    0x8(%ebp),%edx
  800c88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c8b:	b8 04 00 00 00       	mov    $0x4,%eax
  800c90:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c93:	89 f7                	mov    %esi,%edi
  800c95:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c97:	85 c0                	test   %eax,%eax
  800c99:	7f 08                	jg     800ca3 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c9e:	5b                   	pop    %ebx
  800c9f:	5e                   	pop    %esi
  800ca0:	5f                   	pop    %edi
  800ca1:	5d                   	pop    %ebp
  800ca2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ca3:	83 ec 0c             	sub    $0xc,%esp
  800ca6:	50                   	push   %eax
  800ca7:	6a 04                	push   $0x4
  800ca9:	68 e4 13 80 00       	push   $0x8013e4
  800cae:	6a 23                	push   $0x23
  800cb0:	68 01 14 80 00       	push   $0x801401
  800cb5:	e8 86 f4 ff ff       	call   800140 <_panic>

00800cba <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cba:	f3 0f 1e fb          	endbr32 
  800cbe:	55                   	push   %ebp
  800cbf:	89 e5                	mov    %esp,%ebp
  800cc1:	57                   	push   %edi
  800cc2:	56                   	push   %esi
  800cc3:	53                   	push   %ebx
  800cc4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cc7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ccd:	b8 05 00 00 00       	mov    $0x5,%eax
  800cd2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cd5:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cd8:	8b 75 18             	mov    0x18(%ebp),%esi
  800cdb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cdd:	85 c0                	test   %eax,%eax
  800cdf:	7f 08                	jg     800ce9 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ce1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce4:	5b                   	pop    %ebx
  800ce5:	5e                   	pop    %esi
  800ce6:	5f                   	pop    %edi
  800ce7:	5d                   	pop    %ebp
  800ce8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce9:	83 ec 0c             	sub    $0xc,%esp
  800cec:	50                   	push   %eax
  800ced:	6a 05                	push   $0x5
  800cef:	68 e4 13 80 00       	push   $0x8013e4
  800cf4:	6a 23                	push   $0x23
  800cf6:	68 01 14 80 00       	push   $0x801401
  800cfb:	e8 40 f4 ff ff       	call   800140 <_panic>

00800d00 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d00:	f3 0f 1e fb          	endbr32 
  800d04:	55                   	push   %ebp
  800d05:	89 e5                	mov    %esp,%ebp
  800d07:	57                   	push   %edi
  800d08:	56                   	push   %esi
  800d09:	53                   	push   %ebx
  800d0a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d0d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d12:	8b 55 08             	mov    0x8(%ebp),%edx
  800d15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d18:	b8 06 00 00 00       	mov    $0x6,%eax
  800d1d:	89 df                	mov    %ebx,%edi
  800d1f:	89 de                	mov    %ebx,%esi
  800d21:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d23:	85 c0                	test   %eax,%eax
  800d25:	7f 08                	jg     800d2f <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d27:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2a:	5b                   	pop    %ebx
  800d2b:	5e                   	pop    %esi
  800d2c:	5f                   	pop    %edi
  800d2d:	5d                   	pop    %ebp
  800d2e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d2f:	83 ec 0c             	sub    $0xc,%esp
  800d32:	50                   	push   %eax
  800d33:	6a 06                	push   $0x6
  800d35:	68 e4 13 80 00       	push   $0x8013e4
  800d3a:	6a 23                	push   $0x23
  800d3c:	68 01 14 80 00       	push   $0x801401
  800d41:	e8 fa f3 ff ff       	call   800140 <_panic>

00800d46 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d46:	f3 0f 1e fb          	endbr32 
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	57                   	push   %edi
  800d4e:	56                   	push   %esi
  800d4f:	53                   	push   %ebx
  800d50:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d53:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d58:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5e:	b8 08 00 00 00       	mov    $0x8,%eax
  800d63:	89 df                	mov    %ebx,%edi
  800d65:	89 de                	mov    %ebx,%esi
  800d67:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d69:	85 c0                	test   %eax,%eax
  800d6b:	7f 08                	jg     800d75 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d70:	5b                   	pop    %ebx
  800d71:	5e                   	pop    %esi
  800d72:	5f                   	pop    %edi
  800d73:	5d                   	pop    %ebp
  800d74:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d75:	83 ec 0c             	sub    $0xc,%esp
  800d78:	50                   	push   %eax
  800d79:	6a 08                	push   $0x8
  800d7b:	68 e4 13 80 00       	push   $0x8013e4
  800d80:	6a 23                	push   $0x23
  800d82:	68 01 14 80 00       	push   $0x801401
  800d87:	e8 b4 f3 ff ff       	call   800140 <_panic>

00800d8c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d8c:	f3 0f 1e fb          	endbr32 
  800d90:	55                   	push   %ebp
  800d91:	89 e5                	mov    %esp,%ebp
  800d93:	57                   	push   %edi
  800d94:	56                   	push   %esi
  800d95:	53                   	push   %ebx
  800d96:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d99:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800da1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da4:	b8 09 00 00 00       	mov    $0x9,%eax
  800da9:	89 df                	mov    %ebx,%edi
  800dab:	89 de                	mov    %ebx,%esi
  800dad:	cd 30                	int    $0x30
	if(check && ret > 0)
  800daf:	85 c0                	test   %eax,%eax
  800db1:	7f 08                	jg     800dbb <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800db3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db6:	5b                   	pop    %ebx
  800db7:	5e                   	pop    %esi
  800db8:	5f                   	pop    %edi
  800db9:	5d                   	pop    %ebp
  800dba:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dbb:	83 ec 0c             	sub    $0xc,%esp
  800dbe:	50                   	push   %eax
  800dbf:	6a 09                	push   $0x9
  800dc1:	68 e4 13 80 00       	push   $0x8013e4
  800dc6:	6a 23                	push   $0x23
  800dc8:	68 01 14 80 00       	push   $0x801401
  800dcd:	e8 6e f3 ff ff       	call   800140 <_panic>

00800dd2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dd2:	f3 0f 1e fb          	endbr32 
  800dd6:	55                   	push   %ebp
  800dd7:	89 e5                	mov    %esp,%ebp
  800dd9:	57                   	push   %edi
  800dda:	56                   	push   %esi
  800ddb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ddc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de2:	b8 0b 00 00 00       	mov    $0xb,%eax
  800de7:	be 00 00 00 00       	mov    $0x0,%esi
  800dec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800def:	8b 7d 14             	mov    0x14(%ebp),%edi
  800df2:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800df4:	5b                   	pop    %ebx
  800df5:	5e                   	pop    %esi
  800df6:	5f                   	pop    %edi
  800df7:	5d                   	pop    %ebp
  800df8:	c3                   	ret    

00800df9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800df9:	f3 0f 1e fb          	endbr32 
  800dfd:	55                   	push   %ebp
  800dfe:	89 e5                	mov    %esp,%ebp
  800e00:	57                   	push   %edi
  800e01:	56                   	push   %esi
  800e02:	53                   	push   %ebx
  800e03:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e06:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0e:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e13:	89 cb                	mov    %ecx,%ebx
  800e15:	89 cf                	mov    %ecx,%edi
  800e17:	89 ce                	mov    %ecx,%esi
  800e19:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e1b:	85 c0                	test   %eax,%eax
  800e1d:	7f 08                	jg     800e27 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e22:	5b                   	pop    %ebx
  800e23:	5e                   	pop    %esi
  800e24:	5f                   	pop    %edi
  800e25:	5d                   	pop    %ebp
  800e26:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e27:	83 ec 0c             	sub    $0xc,%esp
  800e2a:	50                   	push   %eax
  800e2b:	6a 0c                	push   $0xc
  800e2d:	68 e4 13 80 00       	push   $0x8013e4
  800e32:	6a 23                	push   $0x23
  800e34:	68 01 14 80 00       	push   $0x801401
  800e39:	e8 02 f3 ff ff       	call   800140 <_panic>
  800e3e:	66 90                	xchg   %ax,%ax

00800e40 <__udivdi3>:
  800e40:	f3 0f 1e fb          	endbr32 
  800e44:	55                   	push   %ebp
  800e45:	57                   	push   %edi
  800e46:	56                   	push   %esi
  800e47:	53                   	push   %ebx
  800e48:	83 ec 1c             	sub    $0x1c,%esp
  800e4b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800e4f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800e53:	8b 74 24 34          	mov    0x34(%esp),%esi
  800e57:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800e5b:	85 d2                	test   %edx,%edx
  800e5d:	75 19                	jne    800e78 <__udivdi3+0x38>
  800e5f:	39 f3                	cmp    %esi,%ebx
  800e61:	76 4d                	jbe    800eb0 <__udivdi3+0x70>
  800e63:	31 ff                	xor    %edi,%edi
  800e65:	89 e8                	mov    %ebp,%eax
  800e67:	89 f2                	mov    %esi,%edx
  800e69:	f7 f3                	div    %ebx
  800e6b:	89 fa                	mov    %edi,%edx
  800e6d:	83 c4 1c             	add    $0x1c,%esp
  800e70:	5b                   	pop    %ebx
  800e71:	5e                   	pop    %esi
  800e72:	5f                   	pop    %edi
  800e73:	5d                   	pop    %ebp
  800e74:	c3                   	ret    
  800e75:	8d 76 00             	lea    0x0(%esi),%esi
  800e78:	39 f2                	cmp    %esi,%edx
  800e7a:	76 14                	jbe    800e90 <__udivdi3+0x50>
  800e7c:	31 ff                	xor    %edi,%edi
  800e7e:	31 c0                	xor    %eax,%eax
  800e80:	89 fa                	mov    %edi,%edx
  800e82:	83 c4 1c             	add    $0x1c,%esp
  800e85:	5b                   	pop    %ebx
  800e86:	5e                   	pop    %esi
  800e87:	5f                   	pop    %edi
  800e88:	5d                   	pop    %ebp
  800e89:	c3                   	ret    
  800e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800e90:	0f bd fa             	bsr    %edx,%edi
  800e93:	83 f7 1f             	xor    $0x1f,%edi
  800e96:	75 48                	jne    800ee0 <__udivdi3+0xa0>
  800e98:	39 f2                	cmp    %esi,%edx
  800e9a:	72 06                	jb     800ea2 <__udivdi3+0x62>
  800e9c:	31 c0                	xor    %eax,%eax
  800e9e:	39 eb                	cmp    %ebp,%ebx
  800ea0:	77 de                	ja     800e80 <__udivdi3+0x40>
  800ea2:	b8 01 00 00 00       	mov    $0x1,%eax
  800ea7:	eb d7                	jmp    800e80 <__udivdi3+0x40>
  800ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800eb0:	89 d9                	mov    %ebx,%ecx
  800eb2:	85 db                	test   %ebx,%ebx
  800eb4:	75 0b                	jne    800ec1 <__udivdi3+0x81>
  800eb6:	b8 01 00 00 00       	mov    $0x1,%eax
  800ebb:	31 d2                	xor    %edx,%edx
  800ebd:	f7 f3                	div    %ebx
  800ebf:	89 c1                	mov    %eax,%ecx
  800ec1:	31 d2                	xor    %edx,%edx
  800ec3:	89 f0                	mov    %esi,%eax
  800ec5:	f7 f1                	div    %ecx
  800ec7:	89 c6                	mov    %eax,%esi
  800ec9:	89 e8                	mov    %ebp,%eax
  800ecb:	89 f7                	mov    %esi,%edi
  800ecd:	f7 f1                	div    %ecx
  800ecf:	89 fa                	mov    %edi,%edx
  800ed1:	83 c4 1c             	add    $0x1c,%esp
  800ed4:	5b                   	pop    %ebx
  800ed5:	5e                   	pop    %esi
  800ed6:	5f                   	pop    %edi
  800ed7:	5d                   	pop    %ebp
  800ed8:	c3                   	ret    
  800ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ee0:	89 f9                	mov    %edi,%ecx
  800ee2:	b8 20 00 00 00       	mov    $0x20,%eax
  800ee7:	29 f8                	sub    %edi,%eax
  800ee9:	d3 e2                	shl    %cl,%edx
  800eeb:	89 54 24 08          	mov    %edx,0x8(%esp)
  800eef:	89 c1                	mov    %eax,%ecx
  800ef1:	89 da                	mov    %ebx,%edx
  800ef3:	d3 ea                	shr    %cl,%edx
  800ef5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800ef9:	09 d1                	or     %edx,%ecx
  800efb:	89 f2                	mov    %esi,%edx
  800efd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800f01:	89 f9                	mov    %edi,%ecx
  800f03:	d3 e3                	shl    %cl,%ebx
  800f05:	89 c1                	mov    %eax,%ecx
  800f07:	d3 ea                	shr    %cl,%edx
  800f09:	89 f9                	mov    %edi,%ecx
  800f0b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800f0f:	89 eb                	mov    %ebp,%ebx
  800f11:	d3 e6                	shl    %cl,%esi
  800f13:	89 c1                	mov    %eax,%ecx
  800f15:	d3 eb                	shr    %cl,%ebx
  800f17:	09 de                	or     %ebx,%esi
  800f19:	89 f0                	mov    %esi,%eax
  800f1b:	f7 74 24 08          	divl   0x8(%esp)
  800f1f:	89 d6                	mov    %edx,%esi
  800f21:	89 c3                	mov    %eax,%ebx
  800f23:	f7 64 24 0c          	mull   0xc(%esp)
  800f27:	39 d6                	cmp    %edx,%esi
  800f29:	72 15                	jb     800f40 <__udivdi3+0x100>
  800f2b:	89 f9                	mov    %edi,%ecx
  800f2d:	d3 e5                	shl    %cl,%ebp
  800f2f:	39 c5                	cmp    %eax,%ebp
  800f31:	73 04                	jae    800f37 <__udivdi3+0xf7>
  800f33:	39 d6                	cmp    %edx,%esi
  800f35:	74 09                	je     800f40 <__udivdi3+0x100>
  800f37:	89 d8                	mov    %ebx,%eax
  800f39:	31 ff                	xor    %edi,%edi
  800f3b:	e9 40 ff ff ff       	jmp    800e80 <__udivdi3+0x40>
  800f40:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800f43:	31 ff                	xor    %edi,%edi
  800f45:	e9 36 ff ff ff       	jmp    800e80 <__udivdi3+0x40>
  800f4a:	66 90                	xchg   %ax,%ax
  800f4c:	66 90                	xchg   %ax,%ax
  800f4e:	66 90                	xchg   %ax,%ax

00800f50 <__umoddi3>:
  800f50:	f3 0f 1e fb          	endbr32 
  800f54:	55                   	push   %ebp
  800f55:	57                   	push   %edi
  800f56:	56                   	push   %esi
  800f57:	53                   	push   %ebx
  800f58:	83 ec 1c             	sub    $0x1c,%esp
  800f5b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800f5f:	8b 74 24 30          	mov    0x30(%esp),%esi
  800f63:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800f67:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800f6b:	85 c0                	test   %eax,%eax
  800f6d:	75 19                	jne    800f88 <__umoddi3+0x38>
  800f6f:	39 df                	cmp    %ebx,%edi
  800f71:	76 5d                	jbe    800fd0 <__umoddi3+0x80>
  800f73:	89 f0                	mov    %esi,%eax
  800f75:	89 da                	mov    %ebx,%edx
  800f77:	f7 f7                	div    %edi
  800f79:	89 d0                	mov    %edx,%eax
  800f7b:	31 d2                	xor    %edx,%edx
  800f7d:	83 c4 1c             	add    $0x1c,%esp
  800f80:	5b                   	pop    %ebx
  800f81:	5e                   	pop    %esi
  800f82:	5f                   	pop    %edi
  800f83:	5d                   	pop    %ebp
  800f84:	c3                   	ret    
  800f85:	8d 76 00             	lea    0x0(%esi),%esi
  800f88:	89 f2                	mov    %esi,%edx
  800f8a:	39 d8                	cmp    %ebx,%eax
  800f8c:	76 12                	jbe    800fa0 <__umoddi3+0x50>
  800f8e:	89 f0                	mov    %esi,%eax
  800f90:	89 da                	mov    %ebx,%edx
  800f92:	83 c4 1c             	add    $0x1c,%esp
  800f95:	5b                   	pop    %ebx
  800f96:	5e                   	pop    %esi
  800f97:	5f                   	pop    %edi
  800f98:	5d                   	pop    %ebp
  800f99:	c3                   	ret    
  800f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800fa0:	0f bd e8             	bsr    %eax,%ebp
  800fa3:	83 f5 1f             	xor    $0x1f,%ebp
  800fa6:	75 50                	jne    800ff8 <__umoddi3+0xa8>
  800fa8:	39 d8                	cmp    %ebx,%eax
  800faa:	0f 82 e0 00 00 00    	jb     801090 <__umoddi3+0x140>
  800fb0:	89 d9                	mov    %ebx,%ecx
  800fb2:	39 f7                	cmp    %esi,%edi
  800fb4:	0f 86 d6 00 00 00    	jbe    801090 <__umoddi3+0x140>
  800fba:	89 d0                	mov    %edx,%eax
  800fbc:	89 ca                	mov    %ecx,%edx
  800fbe:	83 c4 1c             	add    $0x1c,%esp
  800fc1:	5b                   	pop    %ebx
  800fc2:	5e                   	pop    %esi
  800fc3:	5f                   	pop    %edi
  800fc4:	5d                   	pop    %ebp
  800fc5:	c3                   	ret    
  800fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fcd:	8d 76 00             	lea    0x0(%esi),%esi
  800fd0:	89 fd                	mov    %edi,%ebp
  800fd2:	85 ff                	test   %edi,%edi
  800fd4:	75 0b                	jne    800fe1 <__umoddi3+0x91>
  800fd6:	b8 01 00 00 00       	mov    $0x1,%eax
  800fdb:	31 d2                	xor    %edx,%edx
  800fdd:	f7 f7                	div    %edi
  800fdf:	89 c5                	mov    %eax,%ebp
  800fe1:	89 d8                	mov    %ebx,%eax
  800fe3:	31 d2                	xor    %edx,%edx
  800fe5:	f7 f5                	div    %ebp
  800fe7:	89 f0                	mov    %esi,%eax
  800fe9:	f7 f5                	div    %ebp
  800feb:	89 d0                	mov    %edx,%eax
  800fed:	31 d2                	xor    %edx,%edx
  800fef:	eb 8c                	jmp    800f7d <__umoddi3+0x2d>
  800ff1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ff8:	89 e9                	mov    %ebp,%ecx
  800ffa:	ba 20 00 00 00       	mov    $0x20,%edx
  800fff:	29 ea                	sub    %ebp,%edx
  801001:	d3 e0                	shl    %cl,%eax
  801003:	89 44 24 08          	mov    %eax,0x8(%esp)
  801007:	89 d1                	mov    %edx,%ecx
  801009:	89 f8                	mov    %edi,%eax
  80100b:	d3 e8                	shr    %cl,%eax
  80100d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801011:	89 54 24 04          	mov    %edx,0x4(%esp)
  801015:	8b 54 24 04          	mov    0x4(%esp),%edx
  801019:	09 c1                	or     %eax,%ecx
  80101b:	89 d8                	mov    %ebx,%eax
  80101d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801021:	89 e9                	mov    %ebp,%ecx
  801023:	d3 e7                	shl    %cl,%edi
  801025:	89 d1                	mov    %edx,%ecx
  801027:	d3 e8                	shr    %cl,%eax
  801029:	89 e9                	mov    %ebp,%ecx
  80102b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80102f:	d3 e3                	shl    %cl,%ebx
  801031:	89 c7                	mov    %eax,%edi
  801033:	89 d1                	mov    %edx,%ecx
  801035:	89 f0                	mov    %esi,%eax
  801037:	d3 e8                	shr    %cl,%eax
  801039:	89 e9                	mov    %ebp,%ecx
  80103b:	89 fa                	mov    %edi,%edx
  80103d:	d3 e6                	shl    %cl,%esi
  80103f:	09 d8                	or     %ebx,%eax
  801041:	f7 74 24 08          	divl   0x8(%esp)
  801045:	89 d1                	mov    %edx,%ecx
  801047:	89 f3                	mov    %esi,%ebx
  801049:	f7 64 24 0c          	mull   0xc(%esp)
  80104d:	89 c6                	mov    %eax,%esi
  80104f:	89 d7                	mov    %edx,%edi
  801051:	39 d1                	cmp    %edx,%ecx
  801053:	72 06                	jb     80105b <__umoddi3+0x10b>
  801055:	75 10                	jne    801067 <__umoddi3+0x117>
  801057:	39 c3                	cmp    %eax,%ebx
  801059:	73 0c                	jae    801067 <__umoddi3+0x117>
  80105b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80105f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801063:	89 d7                	mov    %edx,%edi
  801065:	89 c6                	mov    %eax,%esi
  801067:	89 ca                	mov    %ecx,%edx
  801069:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80106e:	29 f3                	sub    %esi,%ebx
  801070:	19 fa                	sbb    %edi,%edx
  801072:	89 d0                	mov    %edx,%eax
  801074:	d3 e0                	shl    %cl,%eax
  801076:	89 e9                	mov    %ebp,%ecx
  801078:	d3 eb                	shr    %cl,%ebx
  80107a:	d3 ea                	shr    %cl,%edx
  80107c:	09 d8                	or     %ebx,%eax
  80107e:	83 c4 1c             	add    $0x1c,%esp
  801081:	5b                   	pop    %ebx
  801082:	5e                   	pop    %esi
  801083:	5f                   	pop    %edi
  801084:	5d                   	pop    %ebp
  801085:	c3                   	ret    
  801086:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80108d:	8d 76 00             	lea    0x0(%esi),%esi
  801090:	29 fe                	sub    %edi,%esi
  801092:	19 c3                	sbb    %eax,%ebx
  801094:	89 f2                	mov    %esi,%edx
  801096:	89 d9                	mov    %ebx,%ecx
  801098:	e9 1d ff ff ff       	jmp    800fba <__umoddi3+0x6a>
