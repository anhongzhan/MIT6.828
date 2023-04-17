
obj/user/testbss.debug:     file format elf32-i386


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
  80003d:	68 a0 1f 80 00       	push   $0x801fa0
  800042:	e8 e8 01 00 00       	call   80022f <cprintf>
  800047:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < ARRAYSIZE; i++)
  80004a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != 0)
  80004f:	83 3c 85 20 40 80 00 	cmpl   $0x0,0x804020(,%eax,4)
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
  800068:	89 04 85 20 40 80 00 	mov    %eax,0x804020(,%eax,4)
	for (i = 0; i < ARRAYSIZE; i++)
  80006f:	83 c0 01             	add    $0x1,%eax
  800072:	3d 00 00 10 00       	cmp    $0x100000,%eax
  800077:	75 ef                	jne    800068 <umain+0x35>
	for (i = 0; i < ARRAYSIZE; i++)
  800079:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != i)
  80007e:	39 04 85 20 40 80 00 	cmp    %eax,0x804020(,%eax,4)
  800085:	75 47                	jne    8000ce <umain+0x9b>
	for (i = 0; i < ARRAYSIZE; i++)
  800087:	83 c0 01             	add    $0x1,%eax
  80008a:	3d 00 00 10 00       	cmp    $0x100000,%eax
  80008f:	75 ed                	jne    80007e <umain+0x4b>
			panic("bigarray[%d] didn't hold its value!\n", i);

	cprintf("Yes, good.  Now doing a wild write off the end...\n");
  800091:	83 ec 0c             	sub    $0xc,%esp
  800094:	68 e8 1f 80 00       	push   $0x801fe8
  800099:	e8 91 01 00 00       	call   80022f <cprintf>
	bigarray[ARRAYSIZE+1024] = 0;
  80009e:	c7 05 20 50 c0 00 00 	movl   $0x0,0xc05020
  8000a5:	00 00 00 
	panic("SHOULD HAVE TRAPPED!!!");
  8000a8:	83 c4 0c             	add    $0xc,%esp
  8000ab:	68 47 20 80 00       	push   $0x802047
  8000b0:	6a 1a                	push   $0x1a
  8000b2:	68 38 20 80 00       	push   $0x802038
  8000b7:	e8 8c 00 00 00       	call   800148 <_panic>
			panic("bigarray[%d] isn't cleared!\n", i);
  8000bc:	50                   	push   %eax
  8000bd:	68 1b 20 80 00       	push   $0x80201b
  8000c2:	6a 11                	push   $0x11
  8000c4:	68 38 20 80 00       	push   $0x802038
  8000c9:	e8 7a 00 00 00       	call   800148 <_panic>
			panic("bigarray[%d] didn't hold its value!\n", i);
  8000ce:	50                   	push   %eax
  8000cf:	68 c0 1f 80 00       	push   $0x801fc0
  8000d4:	6a 16                	push   $0x16
  8000d6:	68 38 20 80 00       	push   $0x802038
  8000db:	e8 68 00 00 00       	call   800148 <_panic>

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
  8000ef:	e8 41 0b 00 00       	call   800c35 <sys_getenvid>
  8000f4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000fc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800101:	a3 20 40 c0 00       	mov    %eax,0xc04020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800106:	85 db                	test   %ebx,%ebx
  800108:	7e 07                	jle    800111 <libmain+0x31>
		binaryname = argv[0];
  80010a:	8b 06                	mov    (%esi),%eax
  80010c:	a3 00 30 80 00       	mov    %eax,0x803000

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
  800131:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800134:	e8 42 0f 00 00       	call   80107b <close_all>
	sys_env_destroy(0);
  800139:	83 ec 0c             	sub    $0xc,%esp
  80013c:	6a 00                	push   $0x0
  80013e:	e8 ad 0a 00 00       	call   800bf0 <sys_env_destroy>
}
  800143:	83 c4 10             	add    $0x10,%esp
  800146:	c9                   	leave  
  800147:	c3                   	ret    

00800148 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800148:	f3 0f 1e fb          	endbr32 
  80014c:	55                   	push   %ebp
  80014d:	89 e5                	mov    %esp,%ebp
  80014f:	56                   	push   %esi
  800150:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800151:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800154:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80015a:	e8 d6 0a 00 00       	call   800c35 <sys_getenvid>
  80015f:	83 ec 0c             	sub    $0xc,%esp
  800162:	ff 75 0c             	pushl  0xc(%ebp)
  800165:	ff 75 08             	pushl  0x8(%ebp)
  800168:	56                   	push   %esi
  800169:	50                   	push   %eax
  80016a:	68 68 20 80 00       	push   $0x802068
  80016f:	e8 bb 00 00 00       	call   80022f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800174:	83 c4 18             	add    $0x18,%esp
  800177:	53                   	push   %ebx
  800178:	ff 75 10             	pushl  0x10(%ebp)
  80017b:	e8 5a 00 00 00       	call   8001da <vcprintf>
	cprintf("\n");
  800180:	c7 04 24 36 20 80 00 	movl   $0x802036,(%esp)
  800187:	e8 a3 00 00 00       	call   80022f <cprintf>
  80018c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80018f:	cc                   	int3   
  800190:	eb fd                	jmp    80018f <_panic+0x47>

00800192 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800192:	f3 0f 1e fb          	endbr32 
  800196:	55                   	push   %ebp
  800197:	89 e5                	mov    %esp,%ebp
  800199:	53                   	push   %ebx
  80019a:	83 ec 04             	sub    $0x4,%esp
  80019d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001a0:	8b 13                	mov    (%ebx),%edx
  8001a2:	8d 42 01             	lea    0x1(%edx),%eax
  8001a5:	89 03                	mov    %eax,(%ebx)
  8001a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001aa:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001ae:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001b3:	74 09                	je     8001be <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001b5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001bc:	c9                   	leave  
  8001bd:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001be:	83 ec 08             	sub    $0x8,%esp
  8001c1:	68 ff 00 00 00       	push   $0xff
  8001c6:	8d 43 08             	lea    0x8(%ebx),%eax
  8001c9:	50                   	push   %eax
  8001ca:	e8 dc 09 00 00       	call   800bab <sys_cputs>
		b->idx = 0;
  8001cf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001d5:	83 c4 10             	add    $0x10,%esp
  8001d8:	eb db                	jmp    8001b5 <putch+0x23>

008001da <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001da:	f3 0f 1e fb          	endbr32 
  8001de:	55                   	push   %ebp
  8001df:	89 e5                	mov    %esp,%ebp
  8001e1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001e7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001ee:	00 00 00 
	b.cnt = 0;
  8001f1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001f8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001fb:	ff 75 0c             	pushl  0xc(%ebp)
  8001fe:	ff 75 08             	pushl  0x8(%ebp)
  800201:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800207:	50                   	push   %eax
  800208:	68 92 01 80 00       	push   $0x800192
  80020d:	e8 20 01 00 00       	call   800332 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800212:	83 c4 08             	add    $0x8,%esp
  800215:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80021b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800221:	50                   	push   %eax
  800222:	e8 84 09 00 00       	call   800bab <sys_cputs>

	return b.cnt;
}
  800227:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80022d:	c9                   	leave  
  80022e:	c3                   	ret    

0080022f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80022f:	f3 0f 1e fb          	endbr32 
  800233:	55                   	push   %ebp
  800234:	89 e5                	mov    %esp,%ebp
  800236:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800239:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80023c:	50                   	push   %eax
  80023d:	ff 75 08             	pushl  0x8(%ebp)
  800240:	e8 95 ff ff ff       	call   8001da <vcprintf>
	va_end(ap);

	return cnt;
}
  800245:	c9                   	leave  
  800246:	c3                   	ret    

00800247 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800247:	55                   	push   %ebp
  800248:	89 e5                	mov    %esp,%ebp
  80024a:	57                   	push   %edi
  80024b:	56                   	push   %esi
  80024c:	53                   	push   %ebx
  80024d:	83 ec 1c             	sub    $0x1c,%esp
  800250:	89 c7                	mov    %eax,%edi
  800252:	89 d6                	mov    %edx,%esi
  800254:	8b 45 08             	mov    0x8(%ebp),%eax
  800257:	8b 55 0c             	mov    0xc(%ebp),%edx
  80025a:	89 d1                	mov    %edx,%ecx
  80025c:	89 c2                	mov    %eax,%edx
  80025e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800261:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800264:	8b 45 10             	mov    0x10(%ebp),%eax
  800267:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80026a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80026d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800274:	39 c2                	cmp    %eax,%edx
  800276:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800279:	72 3e                	jb     8002b9 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80027b:	83 ec 0c             	sub    $0xc,%esp
  80027e:	ff 75 18             	pushl  0x18(%ebp)
  800281:	83 eb 01             	sub    $0x1,%ebx
  800284:	53                   	push   %ebx
  800285:	50                   	push   %eax
  800286:	83 ec 08             	sub    $0x8,%esp
  800289:	ff 75 e4             	pushl  -0x1c(%ebp)
  80028c:	ff 75 e0             	pushl  -0x20(%ebp)
  80028f:	ff 75 dc             	pushl  -0x24(%ebp)
  800292:	ff 75 d8             	pushl  -0x28(%ebp)
  800295:	e8 96 1a 00 00       	call   801d30 <__udivdi3>
  80029a:	83 c4 18             	add    $0x18,%esp
  80029d:	52                   	push   %edx
  80029e:	50                   	push   %eax
  80029f:	89 f2                	mov    %esi,%edx
  8002a1:	89 f8                	mov    %edi,%eax
  8002a3:	e8 9f ff ff ff       	call   800247 <printnum>
  8002a8:	83 c4 20             	add    $0x20,%esp
  8002ab:	eb 13                	jmp    8002c0 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002ad:	83 ec 08             	sub    $0x8,%esp
  8002b0:	56                   	push   %esi
  8002b1:	ff 75 18             	pushl  0x18(%ebp)
  8002b4:	ff d7                	call   *%edi
  8002b6:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002b9:	83 eb 01             	sub    $0x1,%ebx
  8002bc:	85 db                	test   %ebx,%ebx
  8002be:	7f ed                	jg     8002ad <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002c0:	83 ec 08             	sub    $0x8,%esp
  8002c3:	56                   	push   %esi
  8002c4:	83 ec 04             	sub    $0x4,%esp
  8002c7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ca:	ff 75 e0             	pushl  -0x20(%ebp)
  8002cd:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d0:	ff 75 d8             	pushl  -0x28(%ebp)
  8002d3:	e8 68 1b 00 00       	call   801e40 <__umoddi3>
  8002d8:	83 c4 14             	add    $0x14,%esp
  8002db:	0f be 80 8b 20 80 00 	movsbl 0x80208b(%eax),%eax
  8002e2:	50                   	push   %eax
  8002e3:	ff d7                	call   *%edi
}
  8002e5:	83 c4 10             	add    $0x10,%esp
  8002e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002eb:	5b                   	pop    %ebx
  8002ec:	5e                   	pop    %esi
  8002ed:	5f                   	pop    %edi
  8002ee:	5d                   	pop    %ebp
  8002ef:	c3                   	ret    

008002f0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002f0:	f3 0f 1e fb          	endbr32 
  8002f4:	55                   	push   %ebp
  8002f5:	89 e5                	mov    %esp,%ebp
  8002f7:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002fa:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002fe:	8b 10                	mov    (%eax),%edx
  800300:	3b 50 04             	cmp    0x4(%eax),%edx
  800303:	73 0a                	jae    80030f <sprintputch+0x1f>
		*b->buf++ = ch;
  800305:	8d 4a 01             	lea    0x1(%edx),%ecx
  800308:	89 08                	mov    %ecx,(%eax)
  80030a:	8b 45 08             	mov    0x8(%ebp),%eax
  80030d:	88 02                	mov    %al,(%edx)
}
  80030f:	5d                   	pop    %ebp
  800310:	c3                   	ret    

00800311 <printfmt>:
{
  800311:	f3 0f 1e fb          	endbr32 
  800315:	55                   	push   %ebp
  800316:	89 e5                	mov    %esp,%ebp
  800318:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80031b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80031e:	50                   	push   %eax
  80031f:	ff 75 10             	pushl  0x10(%ebp)
  800322:	ff 75 0c             	pushl  0xc(%ebp)
  800325:	ff 75 08             	pushl  0x8(%ebp)
  800328:	e8 05 00 00 00       	call   800332 <vprintfmt>
}
  80032d:	83 c4 10             	add    $0x10,%esp
  800330:	c9                   	leave  
  800331:	c3                   	ret    

00800332 <vprintfmt>:
{
  800332:	f3 0f 1e fb          	endbr32 
  800336:	55                   	push   %ebp
  800337:	89 e5                	mov    %esp,%ebp
  800339:	57                   	push   %edi
  80033a:	56                   	push   %esi
  80033b:	53                   	push   %ebx
  80033c:	83 ec 3c             	sub    $0x3c,%esp
  80033f:	8b 75 08             	mov    0x8(%ebp),%esi
  800342:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800345:	8b 7d 10             	mov    0x10(%ebp),%edi
  800348:	e9 8e 03 00 00       	jmp    8006db <vprintfmt+0x3a9>
		padc = ' ';
  80034d:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800351:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800358:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80035f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800366:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80036b:	8d 47 01             	lea    0x1(%edi),%eax
  80036e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800371:	0f b6 17             	movzbl (%edi),%edx
  800374:	8d 42 dd             	lea    -0x23(%edx),%eax
  800377:	3c 55                	cmp    $0x55,%al
  800379:	0f 87 df 03 00 00    	ja     80075e <vprintfmt+0x42c>
  80037f:	0f b6 c0             	movzbl %al,%eax
  800382:	3e ff 24 85 c0 21 80 	notrack jmp *0x8021c0(,%eax,4)
  800389:	00 
  80038a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80038d:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800391:	eb d8                	jmp    80036b <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800393:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800396:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80039a:	eb cf                	jmp    80036b <vprintfmt+0x39>
  80039c:	0f b6 d2             	movzbl %dl,%edx
  80039f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003aa:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003ad:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003b1:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003b4:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003b7:	83 f9 09             	cmp    $0x9,%ecx
  8003ba:	77 55                	ja     800411 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8003bc:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003bf:	eb e9                	jmp    8003aa <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8003c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c4:	8b 00                	mov    (%eax),%eax
  8003c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003cc:	8d 40 04             	lea    0x4(%eax),%eax
  8003cf:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003d5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003d9:	79 90                	jns    80036b <vprintfmt+0x39>
				width = precision, precision = -1;
  8003db:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003de:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003e1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003e8:	eb 81                	jmp    80036b <vprintfmt+0x39>
  8003ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ed:	85 c0                	test   %eax,%eax
  8003ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f4:	0f 49 d0             	cmovns %eax,%edx
  8003f7:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003fa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003fd:	e9 69 ff ff ff       	jmp    80036b <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800402:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800405:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80040c:	e9 5a ff ff ff       	jmp    80036b <vprintfmt+0x39>
  800411:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800414:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800417:	eb bc                	jmp    8003d5 <vprintfmt+0xa3>
			lflag++;
  800419:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80041c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80041f:	e9 47 ff ff ff       	jmp    80036b <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800424:	8b 45 14             	mov    0x14(%ebp),%eax
  800427:	8d 78 04             	lea    0x4(%eax),%edi
  80042a:	83 ec 08             	sub    $0x8,%esp
  80042d:	53                   	push   %ebx
  80042e:	ff 30                	pushl  (%eax)
  800430:	ff d6                	call   *%esi
			break;
  800432:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800435:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800438:	e9 9b 02 00 00       	jmp    8006d8 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80043d:	8b 45 14             	mov    0x14(%ebp),%eax
  800440:	8d 78 04             	lea    0x4(%eax),%edi
  800443:	8b 00                	mov    (%eax),%eax
  800445:	99                   	cltd   
  800446:	31 d0                	xor    %edx,%eax
  800448:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80044a:	83 f8 0f             	cmp    $0xf,%eax
  80044d:	7f 23                	jg     800472 <vprintfmt+0x140>
  80044f:	8b 14 85 20 23 80 00 	mov    0x802320(,%eax,4),%edx
  800456:	85 d2                	test   %edx,%edx
  800458:	74 18                	je     800472 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80045a:	52                   	push   %edx
  80045b:	68 51 24 80 00       	push   $0x802451
  800460:	53                   	push   %ebx
  800461:	56                   	push   %esi
  800462:	e8 aa fe ff ff       	call   800311 <printfmt>
  800467:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80046a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80046d:	e9 66 02 00 00       	jmp    8006d8 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800472:	50                   	push   %eax
  800473:	68 a3 20 80 00       	push   $0x8020a3
  800478:	53                   	push   %ebx
  800479:	56                   	push   %esi
  80047a:	e8 92 fe ff ff       	call   800311 <printfmt>
  80047f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800482:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800485:	e9 4e 02 00 00       	jmp    8006d8 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  80048a:	8b 45 14             	mov    0x14(%ebp),%eax
  80048d:	83 c0 04             	add    $0x4,%eax
  800490:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800493:	8b 45 14             	mov    0x14(%ebp),%eax
  800496:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800498:	85 d2                	test   %edx,%edx
  80049a:	b8 9c 20 80 00       	mov    $0x80209c,%eax
  80049f:	0f 45 c2             	cmovne %edx,%eax
  8004a2:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004a5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004a9:	7e 06                	jle    8004b1 <vprintfmt+0x17f>
  8004ab:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004af:	75 0d                	jne    8004be <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004b4:	89 c7                	mov    %eax,%edi
  8004b6:	03 45 e0             	add    -0x20(%ebp),%eax
  8004b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004bc:	eb 55                	jmp    800513 <vprintfmt+0x1e1>
  8004be:	83 ec 08             	sub    $0x8,%esp
  8004c1:	ff 75 d8             	pushl  -0x28(%ebp)
  8004c4:	ff 75 cc             	pushl  -0x34(%ebp)
  8004c7:	e8 46 03 00 00       	call   800812 <strnlen>
  8004cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004cf:	29 c2                	sub    %eax,%edx
  8004d1:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004d4:	83 c4 10             	add    $0x10,%esp
  8004d7:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004d9:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e0:	85 ff                	test   %edi,%edi
  8004e2:	7e 11                	jle    8004f5 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8004e4:	83 ec 08             	sub    $0x8,%esp
  8004e7:	53                   	push   %ebx
  8004e8:	ff 75 e0             	pushl  -0x20(%ebp)
  8004eb:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ed:	83 ef 01             	sub    $0x1,%edi
  8004f0:	83 c4 10             	add    $0x10,%esp
  8004f3:	eb eb                	jmp    8004e0 <vprintfmt+0x1ae>
  8004f5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004f8:	85 d2                	test   %edx,%edx
  8004fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ff:	0f 49 c2             	cmovns %edx,%eax
  800502:	29 c2                	sub    %eax,%edx
  800504:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800507:	eb a8                	jmp    8004b1 <vprintfmt+0x17f>
					putch(ch, putdat);
  800509:	83 ec 08             	sub    $0x8,%esp
  80050c:	53                   	push   %ebx
  80050d:	52                   	push   %edx
  80050e:	ff d6                	call   *%esi
  800510:	83 c4 10             	add    $0x10,%esp
  800513:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800516:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800518:	83 c7 01             	add    $0x1,%edi
  80051b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80051f:	0f be d0             	movsbl %al,%edx
  800522:	85 d2                	test   %edx,%edx
  800524:	74 4b                	je     800571 <vprintfmt+0x23f>
  800526:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80052a:	78 06                	js     800532 <vprintfmt+0x200>
  80052c:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800530:	78 1e                	js     800550 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800532:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800536:	74 d1                	je     800509 <vprintfmt+0x1d7>
  800538:	0f be c0             	movsbl %al,%eax
  80053b:	83 e8 20             	sub    $0x20,%eax
  80053e:	83 f8 5e             	cmp    $0x5e,%eax
  800541:	76 c6                	jbe    800509 <vprintfmt+0x1d7>
					putch('?', putdat);
  800543:	83 ec 08             	sub    $0x8,%esp
  800546:	53                   	push   %ebx
  800547:	6a 3f                	push   $0x3f
  800549:	ff d6                	call   *%esi
  80054b:	83 c4 10             	add    $0x10,%esp
  80054e:	eb c3                	jmp    800513 <vprintfmt+0x1e1>
  800550:	89 cf                	mov    %ecx,%edi
  800552:	eb 0e                	jmp    800562 <vprintfmt+0x230>
				putch(' ', putdat);
  800554:	83 ec 08             	sub    $0x8,%esp
  800557:	53                   	push   %ebx
  800558:	6a 20                	push   $0x20
  80055a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80055c:	83 ef 01             	sub    $0x1,%edi
  80055f:	83 c4 10             	add    $0x10,%esp
  800562:	85 ff                	test   %edi,%edi
  800564:	7f ee                	jg     800554 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800566:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800569:	89 45 14             	mov    %eax,0x14(%ebp)
  80056c:	e9 67 01 00 00       	jmp    8006d8 <vprintfmt+0x3a6>
  800571:	89 cf                	mov    %ecx,%edi
  800573:	eb ed                	jmp    800562 <vprintfmt+0x230>
	if (lflag >= 2)
  800575:	83 f9 01             	cmp    $0x1,%ecx
  800578:	7f 1b                	jg     800595 <vprintfmt+0x263>
	else if (lflag)
  80057a:	85 c9                	test   %ecx,%ecx
  80057c:	74 63                	je     8005e1 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80057e:	8b 45 14             	mov    0x14(%ebp),%eax
  800581:	8b 00                	mov    (%eax),%eax
  800583:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800586:	99                   	cltd   
  800587:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80058a:	8b 45 14             	mov    0x14(%ebp),%eax
  80058d:	8d 40 04             	lea    0x4(%eax),%eax
  800590:	89 45 14             	mov    %eax,0x14(%ebp)
  800593:	eb 17                	jmp    8005ac <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800595:	8b 45 14             	mov    0x14(%ebp),%eax
  800598:	8b 50 04             	mov    0x4(%eax),%edx
  80059b:	8b 00                	mov    (%eax),%eax
  80059d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a6:	8d 40 08             	lea    0x8(%eax),%eax
  8005a9:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005ac:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005af:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005b2:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8005b7:	85 c9                	test   %ecx,%ecx
  8005b9:	0f 89 ff 00 00 00    	jns    8006be <vprintfmt+0x38c>
				putch('-', putdat);
  8005bf:	83 ec 08             	sub    $0x8,%esp
  8005c2:	53                   	push   %ebx
  8005c3:	6a 2d                	push   $0x2d
  8005c5:	ff d6                	call   *%esi
				num = -(long long) num;
  8005c7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005ca:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005cd:	f7 da                	neg    %edx
  8005cf:	83 d1 00             	adc    $0x0,%ecx
  8005d2:	f7 d9                	neg    %ecx
  8005d4:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005d7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005dc:	e9 dd 00 00 00       	jmp    8006be <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8005e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e4:	8b 00                	mov    (%eax),%eax
  8005e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e9:	99                   	cltd   
  8005ea:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f0:	8d 40 04             	lea    0x4(%eax),%eax
  8005f3:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f6:	eb b4                	jmp    8005ac <vprintfmt+0x27a>
	if (lflag >= 2)
  8005f8:	83 f9 01             	cmp    $0x1,%ecx
  8005fb:	7f 1e                	jg     80061b <vprintfmt+0x2e9>
	else if (lflag)
  8005fd:	85 c9                	test   %ecx,%ecx
  8005ff:	74 32                	je     800633 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800601:	8b 45 14             	mov    0x14(%ebp),%eax
  800604:	8b 10                	mov    (%eax),%edx
  800606:	b9 00 00 00 00       	mov    $0x0,%ecx
  80060b:	8d 40 04             	lea    0x4(%eax),%eax
  80060e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800611:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800616:	e9 a3 00 00 00       	jmp    8006be <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80061b:	8b 45 14             	mov    0x14(%ebp),%eax
  80061e:	8b 10                	mov    (%eax),%edx
  800620:	8b 48 04             	mov    0x4(%eax),%ecx
  800623:	8d 40 08             	lea    0x8(%eax),%eax
  800626:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800629:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80062e:	e9 8b 00 00 00       	jmp    8006be <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800633:	8b 45 14             	mov    0x14(%ebp),%eax
  800636:	8b 10                	mov    (%eax),%edx
  800638:	b9 00 00 00 00       	mov    $0x0,%ecx
  80063d:	8d 40 04             	lea    0x4(%eax),%eax
  800640:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800643:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800648:	eb 74                	jmp    8006be <vprintfmt+0x38c>
	if (lflag >= 2)
  80064a:	83 f9 01             	cmp    $0x1,%ecx
  80064d:	7f 1b                	jg     80066a <vprintfmt+0x338>
	else if (lflag)
  80064f:	85 c9                	test   %ecx,%ecx
  800651:	74 2c                	je     80067f <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800653:	8b 45 14             	mov    0x14(%ebp),%eax
  800656:	8b 10                	mov    (%eax),%edx
  800658:	b9 00 00 00 00       	mov    $0x0,%ecx
  80065d:	8d 40 04             	lea    0x4(%eax),%eax
  800660:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800663:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800668:	eb 54                	jmp    8006be <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80066a:	8b 45 14             	mov    0x14(%ebp),%eax
  80066d:	8b 10                	mov    (%eax),%edx
  80066f:	8b 48 04             	mov    0x4(%eax),%ecx
  800672:	8d 40 08             	lea    0x8(%eax),%eax
  800675:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800678:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80067d:	eb 3f                	jmp    8006be <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80067f:	8b 45 14             	mov    0x14(%ebp),%eax
  800682:	8b 10                	mov    (%eax),%edx
  800684:	b9 00 00 00 00       	mov    $0x0,%ecx
  800689:	8d 40 04             	lea    0x4(%eax),%eax
  80068c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80068f:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800694:	eb 28                	jmp    8006be <vprintfmt+0x38c>
			putch('0', putdat);
  800696:	83 ec 08             	sub    $0x8,%esp
  800699:	53                   	push   %ebx
  80069a:	6a 30                	push   $0x30
  80069c:	ff d6                	call   *%esi
			putch('x', putdat);
  80069e:	83 c4 08             	add    $0x8,%esp
  8006a1:	53                   	push   %ebx
  8006a2:	6a 78                	push   $0x78
  8006a4:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a9:	8b 10                	mov    (%eax),%edx
  8006ab:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006b0:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006b3:	8d 40 04             	lea    0x4(%eax),%eax
  8006b6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b9:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006be:	83 ec 0c             	sub    $0xc,%esp
  8006c1:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8006c5:	57                   	push   %edi
  8006c6:	ff 75 e0             	pushl  -0x20(%ebp)
  8006c9:	50                   	push   %eax
  8006ca:	51                   	push   %ecx
  8006cb:	52                   	push   %edx
  8006cc:	89 da                	mov    %ebx,%edx
  8006ce:	89 f0                	mov    %esi,%eax
  8006d0:	e8 72 fb ff ff       	call   800247 <printnum>
			break;
  8006d5:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006d8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006db:	83 c7 01             	add    $0x1,%edi
  8006de:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006e2:	83 f8 25             	cmp    $0x25,%eax
  8006e5:	0f 84 62 fc ff ff    	je     80034d <vprintfmt+0x1b>
			if (ch == '\0')
  8006eb:	85 c0                	test   %eax,%eax
  8006ed:	0f 84 8b 00 00 00    	je     80077e <vprintfmt+0x44c>
			putch(ch, putdat);
  8006f3:	83 ec 08             	sub    $0x8,%esp
  8006f6:	53                   	push   %ebx
  8006f7:	50                   	push   %eax
  8006f8:	ff d6                	call   *%esi
  8006fa:	83 c4 10             	add    $0x10,%esp
  8006fd:	eb dc                	jmp    8006db <vprintfmt+0x3a9>
	if (lflag >= 2)
  8006ff:	83 f9 01             	cmp    $0x1,%ecx
  800702:	7f 1b                	jg     80071f <vprintfmt+0x3ed>
	else if (lflag)
  800704:	85 c9                	test   %ecx,%ecx
  800706:	74 2c                	je     800734 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800708:	8b 45 14             	mov    0x14(%ebp),%eax
  80070b:	8b 10                	mov    (%eax),%edx
  80070d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800712:	8d 40 04             	lea    0x4(%eax),%eax
  800715:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800718:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80071d:	eb 9f                	jmp    8006be <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80071f:	8b 45 14             	mov    0x14(%ebp),%eax
  800722:	8b 10                	mov    (%eax),%edx
  800724:	8b 48 04             	mov    0x4(%eax),%ecx
  800727:	8d 40 08             	lea    0x8(%eax),%eax
  80072a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80072d:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800732:	eb 8a                	jmp    8006be <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800734:	8b 45 14             	mov    0x14(%ebp),%eax
  800737:	8b 10                	mov    (%eax),%edx
  800739:	b9 00 00 00 00       	mov    $0x0,%ecx
  80073e:	8d 40 04             	lea    0x4(%eax),%eax
  800741:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800744:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800749:	e9 70 ff ff ff       	jmp    8006be <vprintfmt+0x38c>
			putch(ch, putdat);
  80074e:	83 ec 08             	sub    $0x8,%esp
  800751:	53                   	push   %ebx
  800752:	6a 25                	push   $0x25
  800754:	ff d6                	call   *%esi
			break;
  800756:	83 c4 10             	add    $0x10,%esp
  800759:	e9 7a ff ff ff       	jmp    8006d8 <vprintfmt+0x3a6>
			putch('%', putdat);
  80075e:	83 ec 08             	sub    $0x8,%esp
  800761:	53                   	push   %ebx
  800762:	6a 25                	push   $0x25
  800764:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800766:	83 c4 10             	add    $0x10,%esp
  800769:	89 f8                	mov    %edi,%eax
  80076b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80076f:	74 05                	je     800776 <vprintfmt+0x444>
  800771:	83 e8 01             	sub    $0x1,%eax
  800774:	eb f5                	jmp    80076b <vprintfmt+0x439>
  800776:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800779:	e9 5a ff ff ff       	jmp    8006d8 <vprintfmt+0x3a6>
}
  80077e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800781:	5b                   	pop    %ebx
  800782:	5e                   	pop    %esi
  800783:	5f                   	pop    %edi
  800784:	5d                   	pop    %ebp
  800785:	c3                   	ret    

00800786 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800786:	f3 0f 1e fb          	endbr32 
  80078a:	55                   	push   %ebp
  80078b:	89 e5                	mov    %esp,%ebp
  80078d:	83 ec 18             	sub    $0x18,%esp
  800790:	8b 45 08             	mov    0x8(%ebp),%eax
  800793:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800796:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800799:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80079d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007a7:	85 c0                	test   %eax,%eax
  8007a9:	74 26                	je     8007d1 <vsnprintf+0x4b>
  8007ab:	85 d2                	test   %edx,%edx
  8007ad:	7e 22                	jle    8007d1 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007af:	ff 75 14             	pushl  0x14(%ebp)
  8007b2:	ff 75 10             	pushl  0x10(%ebp)
  8007b5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007b8:	50                   	push   %eax
  8007b9:	68 f0 02 80 00       	push   $0x8002f0
  8007be:	e8 6f fb ff ff       	call   800332 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007c6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007cc:	83 c4 10             	add    $0x10,%esp
}
  8007cf:	c9                   	leave  
  8007d0:	c3                   	ret    
		return -E_INVAL;
  8007d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007d6:	eb f7                	jmp    8007cf <vsnprintf+0x49>

008007d8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007d8:	f3 0f 1e fb          	endbr32 
  8007dc:	55                   	push   %ebp
  8007dd:	89 e5                	mov    %esp,%ebp
  8007df:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007e2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007e5:	50                   	push   %eax
  8007e6:	ff 75 10             	pushl  0x10(%ebp)
  8007e9:	ff 75 0c             	pushl  0xc(%ebp)
  8007ec:	ff 75 08             	pushl  0x8(%ebp)
  8007ef:	e8 92 ff ff ff       	call   800786 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007f4:	c9                   	leave  
  8007f5:	c3                   	ret    

008007f6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007f6:	f3 0f 1e fb          	endbr32 
  8007fa:	55                   	push   %ebp
  8007fb:	89 e5                	mov    %esp,%ebp
  8007fd:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800800:	b8 00 00 00 00       	mov    $0x0,%eax
  800805:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800809:	74 05                	je     800810 <strlen+0x1a>
		n++;
  80080b:	83 c0 01             	add    $0x1,%eax
  80080e:	eb f5                	jmp    800805 <strlen+0xf>
	return n;
}
  800810:	5d                   	pop    %ebp
  800811:	c3                   	ret    

00800812 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800812:	f3 0f 1e fb          	endbr32 
  800816:	55                   	push   %ebp
  800817:	89 e5                	mov    %esp,%ebp
  800819:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80081c:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80081f:	b8 00 00 00 00       	mov    $0x0,%eax
  800824:	39 d0                	cmp    %edx,%eax
  800826:	74 0d                	je     800835 <strnlen+0x23>
  800828:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80082c:	74 05                	je     800833 <strnlen+0x21>
		n++;
  80082e:	83 c0 01             	add    $0x1,%eax
  800831:	eb f1                	jmp    800824 <strnlen+0x12>
  800833:	89 c2                	mov    %eax,%edx
	return n;
}
  800835:	89 d0                	mov    %edx,%eax
  800837:	5d                   	pop    %ebp
  800838:	c3                   	ret    

00800839 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800839:	f3 0f 1e fb          	endbr32 
  80083d:	55                   	push   %ebp
  80083e:	89 e5                	mov    %esp,%ebp
  800840:	53                   	push   %ebx
  800841:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800844:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800847:	b8 00 00 00 00       	mov    $0x0,%eax
  80084c:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800850:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800853:	83 c0 01             	add    $0x1,%eax
  800856:	84 d2                	test   %dl,%dl
  800858:	75 f2                	jne    80084c <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  80085a:	89 c8                	mov    %ecx,%eax
  80085c:	5b                   	pop    %ebx
  80085d:	5d                   	pop    %ebp
  80085e:	c3                   	ret    

0080085f <strcat>:

char *
strcat(char *dst, const char *src)
{
  80085f:	f3 0f 1e fb          	endbr32 
  800863:	55                   	push   %ebp
  800864:	89 e5                	mov    %esp,%ebp
  800866:	53                   	push   %ebx
  800867:	83 ec 10             	sub    $0x10,%esp
  80086a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80086d:	53                   	push   %ebx
  80086e:	e8 83 ff ff ff       	call   8007f6 <strlen>
  800873:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800876:	ff 75 0c             	pushl  0xc(%ebp)
  800879:	01 d8                	add    %ebx,%eax
  80087b:	50                   	push   %eax
  80087c:	e8 b8 ff ff ff       	call   800839 <strcpy>
	return dst;
}
  800881:	89 d8                	mov    %ebx,%eax
  800883:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800886:	c9                   	leave  
  800887:	c3                   	ret    

00800888 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800888:	f3 0f 1e fb          	endbr32 
  80088c:	55                   	push   %ebp
  80088d:	89 e5                	mov    %esp,%ebp
  80088f:	56                   	push   %esi
  800890:	53                   	push   %ebx
  800891:	8b 75 08             	mov    0x8(%ebp),%esi
  800894:	8b 55 0c             	mov    0xc(%ebp),%edx
  800897:	89 f3                	mov    %esi,%ebx
  800899:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80089c:	89 f0                	mov    %esi,%eax
  80089e:	39 d8                	cmp    %ebx,%eax
  8008a0:	74 11                	je     8008b3 <strncpy+0x2b>
		*dst++ = *src;
  8008a2:	83 c0 01             	add    $0x1,%eax
  8008a5:	0f b6 0a             	movzbl (%edx),%ecx
  8008a8:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008ab:	80 f9 01             	cmp    $0x1,%cl
  8008ae:	83 da ff             	sbb    $0xffffffff,%edx
  8008b1:	eb eb                	jmp    80089e <strncpy+0x16>
	}
	return ret;
}
  8008b3:	89 f0                	mov    %esi,%eax
  8008b5:	5b                   	pop    %ebx
  8008b6:	5e                   	pop    %esi
  8008b7:	5d                   	pop    %ebp
  8008b8:	c3                   	ret    

008008b9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008b9:	f3 0f 1e fb          	endbr32 
  8008bd:	55                   	push   %ebp
  8008be:	89 e5                	mov    %esp,%ebp
  8008c0:	56                   	push   %esi
  8008c1:	53                   	push   %ebx
  8008c2:	8b 75 08             	mov    0x8(%ebp),%esi
  8008c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008c8:	8b 55 10             	mov    0x10(%ebp),%edx
  8008cb:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008cd:	85 d2                	test   %edx,%edx
  8008cf:	74 21                	je     8008f2 <strlcpy+0x39>
  8008d1:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008d5:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008d7:	39 c2                	cmp    %eax,%edx
  8008d9:	74 14                	je     8008ef <strlcpy+0x36>
  8008db:	0f b6 19             	movzbl (%ecx),%ebx
  8008de:	84 db                	test   %bl,%bl
  8008e0:	74 0b                	je     8008ed <strlcpy+0x34>
			*dst++ = *src++;
  8008e2:	83 c1 01             	add    $0x1,%ecx
  8008e5:	83 c2 01             	add    $0x1,%edx
  8008e8:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008eb:	eb ea                	jmp    8008d7 <strlcpy+0x1e>
  8008ed:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008ef:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008f2:	29 f0                	sub    %esi,%eax
}
  8008f4:	5b                   	pop    %ebx
  8008f5:	5e                   	pop    %esi
  8008f6:	5d                   	pop    %ebp
  8008f7:	c3                   	ret    

008008f8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008f8:	f3 0f 1e fb          	endbr32 
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
  8008ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800902:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800905:	0f b6 01             	movzbl (%ecx),%eax
  800908:	84 c0                	test   %al,%al
  80090a:	74 0c                	je     800918 <strcmp+0x20>
  80090c:	3a 02                	cmp    (%edx),%al
  80090e:	75 08                	jne    800918 <strcmp+0x20>
		p++, q++;
  800910:	83 c1 01             	add    $0x1,%ecx
  800913:	83 c2 01             	add    $0x1,%edx
  800916:	eb ed                	jmp    800905 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800918:	0f b6 c0             	movzbl %al,%eax
  80091b:	0f b6 12             	movzbl (%edx),%edx
  80091e:	29 d0                	sub    %edx,%eax
}
  800920:	5d                   	pop    %ebp
  800921:	c3                   	ret    

00800922 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800922:	f3 0f 1e fb          	endbr32 
  800926:	55                   	push   %ebp
  800927:	89 e5                	mov    %esp,%ebp
  800929:	53                   	push   %ebx
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800930:	89 c3                	mov    %eax,%ebx
  800932:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800935:	eb 06                	jmp    80093d <strncmp+0x1b>
		n--, p++, q++;
  800937:	83 c0 01             	add    $0x1,%eax
  80093a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80093d:	39 d8                	cmp    %ebx,%eax
  80093f:	74 16                	je     800957 <strncmp+0x35>
  800941:	0f b6 08             	movzbl (%eax),%ecx
  800944:	84 c9                	test   %cl,%cl
  800946:	74 04                	je     80094c <strncmp+0x2a>
  800948:	3a 0a                	cmp    (%edx),%cl
  80094a:	74 eb                	je     800937 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80094c:	0f b6 00             	movzbl (%eax),%eax
  80094f:	0f b6 12             	movzbl (%edx),%edx
  800952:	29 d0                	sub    %edx,%eax
}
  800954:	5b                   	pop    %ebx
  800955:	5d                   	pop    %ebp
  800956:	c3                   	ret    
		return 0;
  800957:	b8 00 00 00 00       	mov    $0x0,%eax
  80095c:	eb f6                	jmp    800954 <strncmp+0x32>

0080095e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80095e:	f3 0f 1e fb          	endbr32 
  800962:	55                   	push   %ebp
  800963:	89 e5                	mov    %esp,%ebp
  800965:	8b 45 08             	mov    0x8(%ebp),%eax
  800968:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80096c:	0f b6 10             	movzbl (%eax),%edx
  80096f:	84 d2                	test   %dl,%dl
  800971:	74 09                	je     80097c <strchr+0x1e>
		if (*s == c)
  800973:	38 ca                	cmp    %cl,%dl
  800975:	74 0a                	je     800981 <strchr+0x23>
	for (; *s; s++)
  800977:	83 c0 01             	add    $0x1,%eax
  80097a:	eb f0                	jmp    80096c <strchr+0xe>
			return (char *) s;
	return 0;
  80097c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800981:	5d                   	pop    %ebp
  800982:	c3                   	ret    

00800983 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800983:	f3 0f 1e fb          	endbr32 
  800987:	55                   	push   %ebp
  800988:	89 e5                	mov    %esp,%ebp
  80098a:	8b 45 08             	mov    0x8(%ebp),%eax
  80098d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800991:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800994:	38 ca                	cmp    %cl,%dl
  800996:	74 09                	je     8009a1 <strfind+0x1e>
  800998:	84 d2                	test   %dl,%dl
  80099a:	74 05                	je     8009a1 <strfind+0x1e>
	for (; *s; s++)
  80099c:	83 c0 01             	add    $0x1,%eax
  80099f:	eb f0                	jmp    800991 <strfind+0xe>
			break;
	return (char *) s;
}
  8009a1:	5d                   	pop    %ebp
  8009a2:	c3                   	ret    

008009a3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009a3:	f3 0f 1e fb          	endbr32 
  8009a7:	55                   	push   %ebp
  8009a8:	89 e5                	mov    %esp,%ebp
  8009aa:	57                   	push   %edi
  8009ab:	56                   	push   %esi
  8009ac:	53                   	push   %ebx
  8009ad:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009b0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009b3:	85 c9                	test   %ecx,%ecx
  8009b5:	74 31                	je     8009e8 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009b7:	89 f8                	mov    %edi,%eax
  8009b9:	09 c8                	or     %ecx,%eax
  8009bb:	a8 03                	test   $0x3,%al
  8009bd:	75 23                	jne    8009e2 <memset+0x3f>
		c &= 0xFF;
  8009bf:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009c3:	89 d3                	mov    %edx,%ebx
  8009c5:	c1 e3 08             	shl    $0x8,%ebx
  8009c8:	89 d0                	mov    %edx,%eax
  8009ca:	c1 e0 18             	shl    $0x18,%eax
  8009cd:	89 d6                	mov    %edx,%esi
  8009cf:	c1 e6 10             	shl    $0x10,%esi
  8009d2:	09 f0                	or     %esi,%eax
  8009d4:	09 c2                	or     %eax,%edx
  8009d6:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009d8:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009db:	89 d0                	mov    %edx,%eax
  8009dd:	fc                   	cld    
  8009de:	f3 ab                	rep stos %eax,%es:(%edi)
  8009e0:	eb 06                	jmp    8009e8 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e5:	fc                   	cld    
  8009e6:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009e8:	89 f8                	mov    %edi,%eax
  8009ea:	5b                   	pop    %ebx
  8009eb:	5e                   	pop    %esi
  8009ec:	5f                   	pop    %edi
  8009ed:	5d                   	pop    %ebp
  8009ee:	c3                   	ret    

008009ef <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009ef:	f3 0f 1e fb          	endbr32 
  8009f3:	55                   	push   %ebp
  8009f4:	89 e5                	mov    %esp,%ebp
  8009f6:	57                   	push   %edi
  8009f7:	56                   	push   %esi
  8009f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a01:	39 c6                	cmp    %eax,%esi
  800a03:	73 32                	jae    800a37 <memmove+0x48>
  800a05:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a08:	39 c2                	cmp    %eax,%edx
  800a0a:	76 2b                	jbe    800a37 <memmove+0x48>
		s += n;
		d += n;
  800a0c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a0f:	89 fe                	mov    %edi,%esi
  800a11:	09 ce                	or     %ecx,%esi
  800a13:	09 d6                	or     %edx,%esi
  800a15:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a1b:	75 0e                	jne    800a2b <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a1d:	83 ef 04             	sub    $0x4,%edi
  800a20:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a23:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a26:	fd                   	std    
  800a27:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a29:	eb 09                	jmp    800a34 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a2b:	83 ef 01             	sub    $0x1,%edi
  800a2e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a31:	fd                   	std    
  800a32:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a34:	fc                   	cld    
  800a35:	eb 1a                	jmp    800a51 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a37:	89 c2                	mov    %eax,%edx
  800a39:	09 ca                	or     %ecx,%edx
  800a3b:	09 f2                	or     %esi,%edx
  800a3d:	f6 c2 03             	test   $0x3,%dl
  800a40:	75 0a                	jne    800a4c <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a42:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a45:	89 c7                	mov    %eax,%edi
  800a47:	fc                   	cld    
  800a48:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a4a:	eb 05                	jmp    800a51 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800a4c:	89 c7                	mov    %eax,%edi
  800a4e:	fc                   	cld    
  800a4f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a51:	5e                   	pop    %esi
  800a52:	5f                   	pop    %edi
  800a53:	5d                   	pop    %ebp
  800a54:	c3                   	ret    

00800a55 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a55:	f3 0f 1e fb          	endbr32 
  800a59:	55                   	push   %ebp
  800a5a:	89 e5                	mov    %esp,%ebp
  800a5c:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a5f:	ff 75 10             	pushl  0x10(%ebp)
  800a62:	ff 75 0c             	pushl  0xc(%ebp)
  800a65:	ff 75 08             	pushl  0x8(%ebp)
  800a68:	e8 82 ff ff ff       	call   8009ef <memmove>
}
  800a6d:	c9                   	leave  
  800a6e:	c3                   	ret    

00800a6f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a6f:	f3 0f 1e fb          	endbr32 
  800a73:	55                   	push   %ebp
  800a74:	89 e5                	mov    %esp,%ebp
  800a76:	56                   	push   %esi
  800a77:	53                   	push   %ebx
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a7e:	89 c6                	mov    %eax,%esi
  800a80:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a83:	39 f0                	cmp    %esi,%eax
  800a85:	74 1c                	je     800aa3 <memcmp+0x34>
		if (*s1 != *s2)
  800a87:	0f b6 08             	movzbl (%eax),%ecx
  800a8a:	0f b6 1a             	movzbl (%edx),%ebx
  800a8d:	38 d9                	cmp    %bl,%cl
  800a8f:	75 08                	jne    800a99 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a91:	83 c0 01             	add    $0x1,%eax
  800a94:	83 c2 01             	add    $0x1,%edx
  800a97:	eb ea                	jmp    800a83 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a99:	0f b6 c1             	movzbl %cl,%eax
  800a9c:	0f b6 db             	movzbl %bl,%ebx
  800a9f:	29 d8                	sub    %ebx,%eax
  800aa1:	eb 05                	jmp    800aa8 <memcmp+0x39>
	}

	return 0;
  800aa3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aa8:	5b                   	pop    %ebx
  800aa9:	5e                   	pop    %esi
  800aaa:	5d                   	pop    %ebp
  800aab:	c3                   	ret    

00800aac <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800aac:	f3 0f 1e fb          	endbr32 
  800ab0:	55                   	push   %ebp
  800ab1:	89 e5                	mov    %esp,%ebp
  800ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ab9:	89 c2                	mov    %eax,%edx
  800abb:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800abe:	39 d0                	cmp    %edx,%eax
  800ac0:	73 09                	jae    800acb <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ac2:	38 08                	cmp    %cl,(%eax)
  800ac4:	74 05                	je     800acb <memfind+0x1f>
	for (; s < ends; s++)
  800ac6:	83 c0 01             	add    $0x1,%eax
  800ac9:	eb f3                	jmp    800abe <memfind+0x12>
			break;
	return (void *) s;
}
  800acb:	5d                   	pop    %ebp
  800acc:	c3                   	ret    

00800acd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800acd:	f3 0f 1e fb          	endbr32 
  800ad1:	55                   	push   %ebp
  800ad2:	89 e5                	mov    %esp,%ebp
  800ad4:	57                   	push   %edi
  800ad5:	56                   	push   %esi
  800ad6:	53                   	push   %ebx
  800ad7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ada:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800add:	eb 03                	jmp    800ae2 <strtol+0x15>
		s++;
  800adf:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ae2:	0f b6 01             	movzbl (%ecx),%eax
  800ae5:	3c 20                	cmp    $0x20,%al
  800ae7:	74 f6                	je     800adf <strtol+0x12>
  800ae9:	3c 09                	cmp    $0x9,%al
  800aeb:	74 f2                	je     800adf <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800aed:	3c 2b                	cmp    $0x2b,%al
  800aef:	74 2a                	je     800b1b <strtol+0x4e>
	int neg = 0;
  800af1:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800af6:	3c 2d                	cmp    $0x2d,%al
  800af8:	74 2b                	je     800b25 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800afa:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b00:	75 0f                	jne    800b11 <strtol+0x44>
  800b02:	80 39 30             	cmpb   $0x30,(%ecx)
  800b05:	74 28                	je     800b2f <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b07:	85 db                	test   %ebx,%ebx
  800b09:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b0e:	0f 44 d8             	cmove  %eax,%ebx
  800b11:	b8 00 00 00 00       	mov    $0x0,%eax
  800b16:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b19:	eb 46                	jmp    800b61 <strtol+0x94>
		s++;
  800b1b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b1e:	bf 00 00 00 00       	mov    $0x0,%edi
  800b23:	eb d5                	jmp    800afa <strtol+0x2d>
		s++, neg = 1;
  800b25:	83 c1 01             	add    $0x1,%ecx
  800b28:	bf 01 00 00 00       	mov    $0x1,%edi
  800b2d:	eb cb                	jmp    800afa <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b2f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b33:	74 0e                	je     800b43 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b35:	85 db                	test   %ebx,%ebx
  800b37:	75 d8                	jne    800b11 <strtol+0x44>
		s++, base = 8;
  800b39:	83 c1 01             	add    $0x1,%ecx
  800b3c:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b41:	eb ce                	jmp    800b11 <strtol+0x44>
		s += 2, base = 16;
  800b43:	83 c1 02             	add    $0x2,%ecx
  800b46:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b4b:	eb c4                	jmp    800b11 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b4d:	0f be d2             	movsbl %dl,%edx
  800b50:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b53:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b56:	7d 3a                	jge    800b92 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b58:	83 c1 01             	add    $0x1,%ecx
  800b5b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b5f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b61:	0f b6 11             	movzbl (%ecx),%edx
  800b64:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b67:	89 f3                	mov    %esi,%ebx
  800b69:	80 fb 09             	cmp    $0x9,%bl
  800b6c:	76 df                	jbe    800b4d <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b6e:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b71:	89 f3                	mov    %esi,%ebx
  800b73:	80 fb 19             	cmp    $0x19,%bl
  800b76:	77 08                	ja     800b80 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b78:	0f be d2             	movsbl %dl,%edx
  800b7b:	83 ea 57             	sub    $0x57,%edx
  800b7e:	eb d3                	jmp    800b53 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b80:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b83:	89 f3                	mov    %esi,%ebx
  800b85:	80 fb 19             	cmp    $0x19,%bl
  800b88:	77 08                	ja     800b92 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b8a:	0f be d2             	movsbl %dl,%edx
  800b8d:	83 ea 37             	sub    $0x37,%edx
  800b90:	eb c1                	jmp    800b53 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b92:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b96:	74 05                	je     800b9d <strtol+0xd0>
		*endptr = (char *) s;
  800b98:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b9b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b9d:	89 c2                	mov    %eax,%edx
  800b9f:	f7 da                	neg    %edx
  800ba1:	85 ff                	test   %edi,%edi
  800ba3:	0f 45 c2             	cmovne %edx,%eax
}
  800ba6:	5b                   	pop    %ebx
  800ba7:	5e                   	pop    %esi
  800ba8:	5f                   	pop    %edi
  800ba9:	5d                   	pop    %ebp
  800baa:	c3                   	ret    

00800bab <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bab:	f3 0f 1e fb          	endbr32 
  800baf:	55                   	push   %ebp
  800bb0:	89 e5                	mov    %esp,%ebp
  800bb2:	57                   	push   %edi
  800bb3:	56                   	push   %esi
  800bb4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bb5:	b8 00 00 00 00       	mov    $0x0,%eax
  800bba:	8b 55 08             	mov    0x8(%ebp),%edx
  800bbd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc0:	89 c3                	mov    %eax,%ebx
  800bc2:	89 c7                	mov    %eax,%edi
  800bc4:	89 c6                	mov    %eax,%esi
  800bc6:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bc8:	5b                   	pop    %ebx
  800bc9:	5e                   	pop    %esi
  800bca:	5f                   	pop    %edi
  800bcb:	5d                   	pop    %ebp
  800bcc:	c3                   	ret    

00800bcd <sys_cgetc>:

int
sys_cgetc(void)
{
  800bcd:	f3 0f 1e fb          	endbr32 
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	57                   	push   %edi
  800bd5:	56                   	push   %esi
  800bd6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd7:	ba 00 00 00 00       	mov    $0x0,%edx
  800bdc:	b8 01 00 00 00       	mov    $0x1,%eax
  800be1:	89 d1                	mov    %edx,%ecx
  800be3:	89 d3                	mov    %edx,%ebx
  800be5:	89 d7                	mov    %edx,%edi
  800be7:	89 d6                	mov    %edx,%esi
  800be9:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800beb:	5b                   	pop    %ebx
  800bec:	5e                   	pop    %esi
  800bed:	5f                   	pop    %edi
  800bee:	5d                   	pop    %ebp
  800bef:	c3                   	ret    

00800bf0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bf0:	f3 0f 1e fb          	endbr32 
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	57                   	push   %edi
  800bf8:	56                   	push   %esi
  800bf9:	53                   	push   %ebx
  800bfa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bfd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c02:	8b 55 08             	mov    0x8(%ebp),%edx
  800c05:	b8 03 00 00 00       	mov    $0x3,%eax
  800c0a:	89 cb                	mov    %ecx,%ebx
  800c0c:	89 cf                	mov    %ecx,%edi
  800c0e:	89 ce                	mov    %ecx,%esi
  800c10:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c12:	85 c0                	test   %eax,%eax
  800c14:	7f 08                	jg     800c1e <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
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
  800c22:	6a 03                	push   $0x3
  800c24:	68 7f 23 80 00       	push   $0x80237f
  800c29:	6a 23                	push   $0x23
  800c2b:	68 9c 23 80 00       	push   $0x80239c
  800c30:	e8 13 f5 ff ff       	call   800148 <_panic>

00800c35 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c35:	f3 0f 1e fb          	endbr32 
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
  800c3c:	57                   	push   %edi
  800c3d:	56                   	push   %esi
  800c3e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c3f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c44:	b8 02 00 00 00       	mov    $0x2,%eax
  800c49:	89 d1                	mov    %edx,%ecx
  800c4b:	89 d3                	mov    %edx,%ebx
  800c4d:	89 d7                	mov    %edx,%edi
  800c4f:	89 d6                	mov    %edx,%esi
  800c51:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c53:	5b                   	pop    %ebx
  800c54:	5e                   	pop    %esi
  800c55:	5f                   	pop    %edi
  800c56:	5d                   	pop    %ebp
  800c57:	c3                   	ret    

00800c58 <sys_yield>:

void
sys_yield(void)
{
  800c58:	f3 0f 1e fb          	endbr32 
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	57                   	push   %edi
  800c60:	56                   	push   %esi
  800c61:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c62:	ba 00 00 00 00       	mov    $0x0,%edx
  800c67:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c6c:	89 d1                	mov    %edx,%ecx
  800c6e:	89 d3                	mov    %edx,%ebx
  800c70:	89 d7                	mov    %edx,%edi
  800c72:	89 d6                	mov    %edx,%esi
  800c74:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c76:	5b                   	pop    %ebx
  800c77:	5e                   	pop    %esi
  800c78:	5f                   	pop    %edi
  800c79:	5d                   	pop    %ebp
  800c7a:	c3                   	ret    

00800c7b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c7b:	f3 0f 1e fb          	endbr32 
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	57                   	push   %edi
  800c83:	56                   	push   %esi
  800c84:	53                   	push   %ebx
  800c85:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c88:	be 00 00 00 00       	mov    $0x0,%esi
  800c8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c93:	b8 04 00 00 00       	mov    $0x4,%eax
  800c98:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c9b:	89 f7                	mov    %esi,%edi
  800c9d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c9f:	85 c0                	test   %eax,%eax
  800ca1:	7f 08                	jg     800cab <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ca3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca6:	5b                   	pop    %ebx
  800ca7:	5e                   	pop    %esi
  800ca8:	5f                   	pop    %edi
  800ca9:	5d                   	pop    %ebp
  800caa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cab:	83 ec 0c             	sub    $0xc,%esp
  800cae:	50                   	push   %eax
  800caf:	6a 04                	push   $0x4
  800cb1:	68 7f 23 80 00       	push   $0x80237f
  800cb6:	6a 23                	push   $0x23
  800cb8:	68 9c 23 80 00       	push   $0x80239c
  800cbd:	e8 86 f4 ff ff       	call   800148 <_panic>

00800cc2 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cc2:	f3 0f 1e fb          	endbr32 
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
  800cc9:	57                   	push   %edi
  800cca:	56                   	push   %esi
  800ccb:	53                   	push   %ebx
  800ccc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ccf:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd5:	b8 05 00 00 00       	mov    $0x5,%eax
  800cda:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cdd:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ce0:	8b 75 18             	mov    0x18(%ebp),%esi
  800ce3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce5:	85 c0                	test   %eax,%eax
  800ce7:	7f 08                	jg     800cf1 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ce9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cec:	5b                   	pop    %ebx
  800ced:	5e                   	pop    %esi
  800cee:	5f                   	pop    %edi
  800cef:	5d                   	pop    %ebp
  800cf0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf1:	83 ec 0c             	sub    $0xc,%esp
  800cf4:	50                   	push   %eax
  800cf5:	6a 05                	push   $0x5
  800cf7:	68 7f 23 80 00       	push   $0x80237f
  800cfc:	6a 23                	push   $0x23
  800cfe:	68 9c 23 80 00       	push   $0x80239c
  800d03:	e8 40 f4 ff ff       	call   800148 <_panic>

00800d08 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d08:	f3 0f 1e fb          	endbr32 
  800d0c:	55                   	push   %ebp
  800d0d:	89 e5                	mov    %esp,%ebp
  800d0f:	57                   	push   %edi
  800d10:	56                   	push   %esi
  800d11:	53                   	push   %ebx
  800d12:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d15:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d20:	b8 06 00 00 00       	mov    $0x6,%eax
  800d25:	89 df                	mov    %ebx,%edi
  800d27:	89 de                	mov    %ebx,%esi
  800d29:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d2b:	85 c0                	test   %eax,%eax
  800d2d:	7f 08                	jg     800d37 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d32:	5b                   	pop    %ebx
  800d33:	5e                   	pop    %esi
  800d34:	5f                   	pop    %edi
  800d35:	5d                   	pop    %ebp
  800d36:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d37:	83 ec 0c             	sub    $0xc,%esp
  800d3a:	50                   	push   %eax
  800d3b:	6a 06                	push   $0x6
  800d3d:	68 7f 23 80 00       	push   $0x80237f
  800d42:	6a 23                	push   $0x23
  800d44:	68 9c 23 80 00       	push   $0x80239c
  800d49:	e8 fa f3 ff ff       	call   800148 <_panic>

00800d4e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d4e:	f3 0f 1e fb          	endbr32 
  800d52:	55                   	push   %ebp
  800d53:	89 e5                	mov    %esp,%ebp
  800d55:	57                   	push   %edi
  800d56:	56                   	push   %esi
  800d57:	53                   	push   %ebx
  800d58:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d5b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d60:	8b 55 08             	mov    0x8(%ebp),%edx
  800d63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d66:	b8 08 00 00 00       	mov    $0x8,%eax
  800d6b:	89 df                	mov    %ebx,%edi
  800d6d:	89 de                	mov    %ebx,%esi
  800d6f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d71:	85 c0                	test   %eax,%eax
  800d73:	7f 08                	jg     800d7d <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d75:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d78:	5b                   	pop    %ebx
  800d79:	5e                   	pop    %esi
  800d7a:	5f                   	pop    %edi
  800d7b:	5d                   	pop    %ebp
  800d7c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7d:	83 ec 0c             	sub    $0xc,%esp
  800d80:	50                   	push   %eax
  800d81:	6a 08                	push   $0x8
  800d83:	68 7f 23 80 00       	push   $0x80237f
  800d88:	6a 23                	push   $0x23
  800d8a:	68 9c 23 80 00       	push   $0x80239c
  800d8f:	e8 b4 f3 ff ff       	call   800148 <_panic>

00800d94 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d94:	f3 0f 1e fb          	endbr32 
  800d98:	55                   	push   %ebp
  800d99:	89 e5                	mov    %esp,%ebp
  800d9b:	57                   	push   %edi
  800d9c:	56                   	push   %esi
  800d9d:	53                   	push   %ebx
  800d9e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da6:	8b 55 08             	mov    0x8(%ebp),%edx
  800da9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dac:	b8 09 00 00 00       	mov    $0x9,%eax
  800db1:	89 df                	mov    %ebx,%edi
  800db3:	89 de                	mov    %ebx,%esi
  800db5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db7:	85 c0                	test   %eax,%eax
  800db9:	7f 08                	jg     800dc3 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dbe:	5b                   	pop    %ebx
  800dbf:	5e                   	pop    %esi
  800dc0:	5f                   	pop    %edi
  800dc1:	5d                   	pop    %ebp
  800dc2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc3:	83 ec 0c             	sub    $0xc,%esp
  800dc6:	50                   	push   %eax
  800dc7:	6a 09                	push   $0x9
  800dc9:	68 7f 23 80 00       	push   $0x80237f
  800dce:	6a 23                	push   $0x23
  800dd0:	68 9c 23 80 00       	push   $0x80239c
  800dd5:	e8 6e f3 ff ff       	call   800148 <_panic>

00800dda <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dda:	f3 0f 1e fb          	endbr32 
  800dde:	55                   	push   %ebp
  800ddf:	89 e5                	mov    %esp,%ebp
  800de1:	57                   	push   %edi
  800de2:	56                   	push   %esi
  800de3:	53                   	push   %ebx
  800de4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dec:	8b 55 08             	mov    0x8(%ebp),%edx
  800def:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df2:	b8 0a 00 00 00       	mov    $0xa,%eax
  800df7:	89 df                	mov    %ebx,%edi
  800df9:	89 de                	mov    %ebx,%esi
  800dfb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dfd:	85 c0                	test   %eax,%eax
  800dff:	7f 08                	jg     800e09 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e01:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e04:	5b                   	pop    %ebx
  800e05:	5e                   	pop    %esi
  800e06:	5f                   	pop    %edi
  800e07:	5d                   	pop    %ebp
  800e08:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e09:	83 ec 0c             	sub    $0xc,%esp
  800e0c:	50                   	push   %eax
  800e0d:	6a 0a                	push   $0xa
  800e0f:	68 7f 23 80 00       	push   $0x80237f
  800e14:	6a 23                	push   $0x23
  800e16:	68 9c 23 80 00       	push   $0x80239c
  800e1b:	e8 28 f3 ff ff       	call   800148 <_panic>

00800e20 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e20:	f3 0f 1e fb          	endbr32 
  800e24:	55                   	push   %ebp
  800e25:	89 e5                	mov    %esp,%ebp
  800e27:	57                   	push   %edi
  800e28:	56                   	push   %esi
  800e29:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e30:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e35:	be 00 00 00 00       	mov    $0x0,%esi
  800e3a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e3d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e40:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e42:	5b                   	pop    %ebx
  800e43:	5e                   	pop    %esi
  800e44:	5f                   	pop    %edi
  800e45:	5d                   	pop    %ebp
  800e46:	c3                   	ret    

00800e47 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e47:	f3 0f 1e fb          	endbr32 
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	57                   	push   %edi
  800e4f:	56                   	push   %esi
  800e50:	53                   	push   %ebx
  800e51:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e54:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e59:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5c:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e61:	89 cb                	mov    %ecx,%ebx
  800e63:	89 cf                	mov    %ecx,%edi
  800e65:	89 ce                	mov    %ecx,%esi
  800e67:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e69:	85 c0                	test   %eax,%eax
  800e6b:	7f 08                	jg     800e75 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e70:	5b                   	pop    %ebx
  800e71:	5e                   	pop    %esi
  800e72:	5f                   	pop    %edi
  800e73:	5d                   	pop    %ebp
  800e74:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e75:	83 ec 0c             	sub    $0xc,%esp
  800e78:	50                   	push   %eax
  800e79:	6a 0d                	push   $0xd
  800e7b:	68 7f 23 80 00       	push   $0x80237f
  800e80:	6a 23                	push   $0x23
  800e82:	68 9c 23 80 00       	push   $0x80239c
  800e87:	e8 bc f2 ff ff       	call   800148 <_panic>

00800e8c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e8c:	f3 0f 1e fb          	endbr32 
  800e90:	55                   	push   %ebp
  800e91:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	05 00 00 00 30       	add    $0x30000000,%eax
  800e9b:	c1 e8 0c             	shr    $0xc,%eax
}
  800e9e:	5d                   	pop    %ebp
  800e9f:	c3                   	ret    

00800ea0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800ea0:	f3 0f 1e fb          	endbr32 
  800ea4:	55                   	push   %ebp
  800ea5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800eaf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800eb4:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800eb9:	5d                   	pop    %ebp
  800eba:	c3                   	ret    

00800ebb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800ebb:	f3 0f 1e fb          	endbr32 
  800ebf:	55                   	push   %ebp
  800ec0:	89 e5                	mov    %esp,%ebp
  800ec2:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800ec7:	89 c2                	mov    %eax,%edx
  800ec9:	c1 ea 16             	shr    $0x16,%edx
  800ecc:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ed3:	f6 c2 01             	test   $0x1,%dl
  800ed6:	74 2d                	je     800f05 <fd_alloc+0x4a>
  800ed8:	89 c2                	mov    %eax,%edx
  800eda:	c1 ea 0c             	shr    $0xc,%edx
  800edd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ee4:	f6 c2 01             	test   $0x1,%dl
  800ee7:	74 1c                	je     800f05 <fd_alloc+0x4a>
  800ee9:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800eee:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800ef3:	75 d2                	jne    800ec7 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800efe:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f03:	eb 0a                	jmp    800f0f <fd_alloc+0x54>
			*fd_store = fd;
  800f05:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f08:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f0f:	5d                   	pop    %ebp
  800f10:	c3                   	ret    

00800f11 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f11:	f3 0f 1e fb          	endbr32 
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
  800f18:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f1b:	83 f8 1f             	cmp    $0x1f,%eax
  800f1e:	77 30                	ja     800f50 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f20:	c1 e0 0c             	shl    $0xc,%eax
  800f23:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f28:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800f2e:	f6 c2 01             	test   $0x1,%dl
  800f31:	74 24                	je     800f57 <fd_lookup+0x46>
  800f33:	89 c2                	mov    %eax,%edx
  800f35:	c1 ea 0c             	shr    $0xc,%edx
  800f38:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f3f:	f6 c2 01             	test   $0x1,%dl
  800f42:	74 1a                	je     800f5e <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f44:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f47:	89 02                	mov    %eax,(%edx)
	return 0;
  800f49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f4e:	5d                   	pop    %ebp
  800f4f:	c3                   	ret    
		return -E_INVAL;
  800f50:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f55:	eb f7                	jmp    800f4e <fd_lookup+0x3d>
		return -E_INVAL;
  800f57:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f5c:	eb f0                	jmp    800f4e <fd_lookup+0x3d>
  800f5e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f63:	eb e9                	jmp    800f4e <fd_lookup+0x3d>

00800f65 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f65:	f3 0f 1e fb          	endbr32 
  800f69:	55                   	push   %ebp
  800f6a:	89 e5                	mov    %esp,%ebp
  800f6c:	83 ec 08             	sub    $0x8,%esp
  800f6f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f72:	ba 28 24 80 00       	mov    $0x802428,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800f77:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f7c:	39 08                	cmp    %ecx,(%eax)
  800f7e:	74 33                	je     800fb3 <dev_lookup+0x4e>
  800f80:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800f83:	8b 02                	mov    (%edx),%eax
  800f85:	85 c0                	test   %eax,%eax
  800f87:	75 f3                	jne    800f7c <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f89:	a1 20 40 c0 00       	mov    0xc04020,%eax
  800f8e:	8b 40 48             	mov    0x48(%eax),%eax
  800f91:	83 ec 04             	sub    $0x4,%esp
  800f94:	51                   	push   %ecx
  800f95:	50                   	push   %eax
  800f96:	68 ac 23 80 00       	push   $0x8023ac
  800f9b:	e8 8f f2 ff ff       	call   80022f <cprintf>
	*dev = 0;
  800fa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800fa9:	83 c4 10             	add    $0x10,%esp
  800fac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800fb1:	c9                   	leave  
  800fb2:	c3                   	ret    
			*dev = devtab[i];
  800fb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb6:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fb8:	b8 00 00 00 00       	mov    $0x0,%eax
  800fbd:	eb f2                	jmp    800fb1 <dev_lookup+0x4c>

00800fbf <fd_close>:
{
  800fbf:	f3 0f 1e fb          	endbr32 
  800fc3:	55                   	push   %ebp
  800fc4:	89 e5                	mov    %esp,%ebp
  800fc6:	57                   	push   %edi
  800fc7:	56                   	push   %esi
  800fc8:	53                   	push   %ebx
  800fc9:	83 ec 24             	sub    $0x24,%esp
  800fcc:	8b 75 08             	mov    0x8(%ebp),%esi
  800fcf:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fd2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800fd5:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fd6:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800fdc:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fdf:	50                   	push   %eax
  800fe0:	e8 2c ff ff ff       	call   800f11 <fd_lookup>
  800fe5:	89 c3                	mov    %eax,%ebx
  800fe7:	83 c4 10             	add    $0x10,%esp
  800fea:	85 c0                	test   %eax,%eax
  800fec:	78 05                	js     800ff3 <fd_close+0x34>
	    || fd != fd2)
  800fee:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800ff1:	74 16                	je     801009 <fd_close+0x4a>
		return (must_exist ? r : 0);
  800ff3:	89 f8                	mov    %edi,%eax
  800ff5:	84 c0                	test   %al,%al
  800ff7:	b8 00 00 00 00       	mov    $0x0,%eax
  800ffc:	0f 44 d8             	cmove  %eax,%ebx
}
  800fff:	89 d8                	mov    %ebx,%eax
  801001:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801004:	5b                   	pop    %ebx
  801005:	5e                   	pop    %esi
  801006:	5f                   	pop    %edi
  801007:	5d                   	pop    %ebp
  801008:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801009:	83 ec 08             	sub    $0x8,%esp
  80100c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80100f:	50                   	push   %eax
  801010:	ff 36                	pushl  (%esi)
  801012:	e8 4e ff ff ff       	call   800f65 <dev_lookup>
  801017:	89 c3                	mov    %eax,%ebx
  801019:	83 c4 10             	add    $0x10,%esp
  80101c:	85 c0                	test   %eax,%eax
  80101e:	78 1a                	js     80103a <fd_close+0x7b>
		if (dev->dev_close)
  801020:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801023:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801026:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80102b:	85 c0                	test   %eax,%eax
  80102d:	74 0b                	je     80103a <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80102f:	83 ec 0c             	sub    $0xc,%esp
  801032:	56                   	push   %esi
  801033:	ff d0                	call   *%eax
  801035:	89 c3                	mov    %eax,%ebx
  801037:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80103a:	83 ec 08             	sub    $0x8,%esp
  80103d:	56                   	push   %esi
  80103e:	6a 00                	push   $0x0
  801040:	e8 c3 fc ff ff       	call   800d08 <sys_page_unmap>
	return r;
  801045:	83 c4 10             	add    $0x10,%esp
  801048:	eb b5                	jmp    800fff <fd_close+0x40>

0080104a <close>:

int
close(int fdnum)
{
  80104a:	f3 0f 1e fb          	endbr32 
  80104e:	55                   	push   %ebp
  80104f:	89 e5                	mov    %esp,%ebp
  801051:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801054:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801057:	50                   	push   %eax
  801058:	ff 75 08             	pushl  0x8(%ebp)
  80105b:	e8 b1 fe ff ff       	call   800f11 <fd_lookup>
  801060:	83 c4 10             	add    $0x10,%esp
  801063:	85 c0                	test   %eax,%eax
  801065:	79 02                	jns    801069 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801067:	c9                   	leave  
  801068:	c3                   	ret    
		return fd_close(fd, 1);
  801069:	83 ec 08             	sub    $0x8,%esp
  80106c:	6a 01                	push   $0x1
  80106e:	ff 75 f4             	pushl  -0xc(%ebp)
  801071:	e8 49 ff ff ff       	call   800fbf <fd_close>
  801076:	83 c4 10             	add    $0x10,%esp
  801079:	eb ec                	jmp    801067 <close+0x1d>

0080107b <close_all>:

void
close_all(void)
{
  80107b:	f3 0f 1e fb          	endbr32 
  80107f:	55                   	push   %ebp
  801080:	89 e5                	mov    %esp,%ebp
  801082:	53                   	push   %ebx
  801083:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801086:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80108b:	83 ec 0c             	sub    $0xc,%esp
  80108e:	53                   	push   %ebx
  80108f:	e8 b6 ff ff ff       	call   80104a <close>
	for (i = 0; i < MAXFD; i++)
  801094:	83 c3 01             	add    $0x1,%ebx
  801097:	83 c4 10             	add    $0x10,%esp
  80109a:	83 fb 20             	cmp    $0x20,%ebx
  80109d:	75 ec                	jne    80108b <close_all+0x10>
}
  80109f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010a2:	c9                   	leave  
  8010a3:	c3                   	ret    

008010a4 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8010a4:	f3 0f 1e fb          	endbr32 
  8010a8:	55                   	push   %ebp
  8010a9:	89 e5                	mov    %esp,%ebp
  8010ab:	57                   	push   %edi
  8010ac:	56                   	push   %esi
  8010ad:	53                   	push   %ebx
  8010ae:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8010b1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010b4:	50                   	push   %eax
  8010b5:	ff 75 08             	pushl  0x8(%ebp)
  8010b8:	e8 54 fe ff ff       	call   800f11 <fd_lookup>
  8010bd:	89 c3                	mov    %eax,%ebx
  8010bf:	83 c4 10             	add    $0x10,%esp
  8010c2:	85 c0                	test   %eax,%eax
  8010c4:	0f 88 81 00 00 00    	js     80114b <dup+0xa7>
		return r;
	close(newfdnum);
  8010ca:	83 ec 0c             	sub    $0xc,%esp
  8010cd:	ff 75 0c             	pushl  0xc(%ebp)
  8010d0:	e8 75 ff ff ff       	call   80104a <close>

	newfd = INDEX2FD(newfdnum);
  8010d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010d8:	c1 e6 0c             	shl    $0xc,%esi
  8010db:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8010e1:	83 c4 04             	add    $0x4,%esp
  8010e4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010e7:	e8 b4 fd ff ff       	call   800ea0 <fd2data>
  8010ec:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8010ee:	89 34 24             	mov    %esi,(%esp)
  8010f1:	e8 aa fd ff ff       	call   800ea0 <fd2data>
  8010f6:	83 c4 10             	add    $0x10,%esp
  8010f9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8010fb:	89 d8                	mov    %ebx,%eax
  8010fd:	c1 e8 16             	shr    $0x16,%eax
  801100:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801107:	a8 01                	test   $0x1,%al
  801109:	74 11                	je     80111c <dup+0x78>
  80110b:	89 d8                	mov    %ebx,%eax
  80110d:	c1 e8 0c             	shr    $0xc,%eax
  801110:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801117:	f6 c2 01             	test   $0x1,%dl
  80111a:	75 39                	jne    801155 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80111c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80111f:	89 d0                	mov    %edx,%eax
  801121:	c1 e8 0c             	shr    $0xc,%eax
  801124:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80112b:	83 ec 0c             	sub    $0xc,%esp
  80112e:	25 07 0e 00 00       	and    $0xe07,%eax
  801133:	50                   	push   %eax
  801134:	56                   	push   %esi
  801135:	6a 00                	push   $0x0
  801137:	52                   	push   %edx
  801138:	6a 00                	push   $0x0
  80113a:	e8 83 fb ff ff       	call   800cc2 <sys_page_map>
  80113f:	89 c3                	mov    %eax,%ebx
  801141:	83 c4 20             	add    $0x20,%esp
  801144:	85 c0                	test   %eax,%eax
  801146:	78 31                	js     801179 <dup+0xd5>
		goto err;

	return newfdnum;
  801148:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80114b:	89 d8                	mov    %ebx,%eax
  80114d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801150:	5b                   	pop    %ebx
  801151:	5e                   	pop    %esi
  801152:	5f                   	pop    %edi
  801153:	5d                   	pop    %ebp
  801154:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801155:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80115c:	83 ec 0c             	sub    $0xc,%esp
  80115f:	25 07 0e 00 00       	and    $0xe07,%eax
  801164:	50                   	push   %eax
  801165:	57                   	push   %edi
  801166:	6a 00                	push   $0x0
  801168:	53                   	push   %ebx
  801169:	6a 00                	push   $0x0
  80116b:	e8 52 fb ff ff       	call   800cc2 <sys_page_map>
  801170:	89 c3                	mov    %eax,%ebx
  801172:	83 c4 20             	add    $0x20,%esp
  801175:	85 c0                	test   %eax,%eax
  801177:	79 a3                	jns    80111c <dup+0x78>
	sys_page_unmap(0, newfd);
  801179:	83 ec 08             	sub    $0x8,%esp
  80117c:	56                   	push   %esi
  80117d:	6a 00                	push   $0x0
  80117f:	e8 84 fb ff ff       	call   800d08 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801184:	83 c4 08             	add    $0x8,%esp
  801187:	57                   	push   %edi
  801188:	6a 00                	push   $0x0
  80118a:	e8 79 fb ff ff       	call   800d08 <sys_page_unmap>
	return r;
  80118f:	83 c4 10             	add    $0x10,%esp
  801192:	eb b7                	jmp    80114b <dup+0xa7>

00801194 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801194:	f3 0f 1e fb          	endbr32 
  801198:	55                   	push   %ebp
  801199:	89 e5                	mov    %esp,%ebp
  80119b:	53                   	push   %ebx
  80119c:	83 ec 1c             	sub    $0x1c,%esp
  80119f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011a2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011a5:	50                   	push   %eax
  8011a6:	53                   	push   %ebx
  8011a7:	e8 65 fd ff ff       	call   800f11 <fd_lookup>
  8011ac:	83 c4 10             	add    $0x10,%esp
  8011af:	85 c0                	test   %eax,%eax
  8011b1:	78 3f                	js     8011f2 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011b3:	83 ec 08             	sub    $0x8,%esp
  8011b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011b9:	50                   	push   %eax
  8011ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011bd:	ff 30                	pushl  (%eax)
  8011bf:	e8 a1 fd ff ff       	call   800f65 <dev_lookup>
  8011c4:	83 c4 10             	add    $0x10,%esp
  8011c7:	85 c0                	test   %eax,%eax
  8011c9:	78 27                	js     8011f2 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8011cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011ce:	8b 42 08             	mov    0x8(%edx),%eax
  8011d1:	83 e0 03             	and    $0x3,%eax
  8011d4:	83 f8 01             	cmp    $0x1,%eax
  8011d7:	74 1e                	je     8011f7 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8011d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011dc:	8b 40 08             	mov    0x8(%eax),%eax
  8011df:	85 c0                	test   %eax,%eax
  8011e1:	74 35                	je     801218 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8011e3:	83 ec 04             	sub    $0x4,%esp
  8011e6:	ff 75 10             	pushl  0x10(%ebp)
  8011e9:	ff 75 0c             	pushl  0xc(%ebp)
  8011ec:	52                   	push   %edx
  8011ed:	ff d0                	call   *%eax
  8011ef:	83 c4 10             	add    $0x10,%esp
}
  8011f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011f5:	c9                   	leave  
  8011f6:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8011f7:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8011fc:	8b 40 48             	mov    0x48(%eax),%eax
  8011ff:	83 ec 04             	sub    $0x4,%esp
  801202:	53                   	push   %ebx
  801203:	50                   	push   %eax
  801204:	68 ed 23 80 00       	push   $0x8023ed
  801209:	e8 21 f0 ff ff       	call   80022f <cprintf>
		return -E_INVAL;
  80120e:	83 c4 10             	add    $0x10,%esp
  801211:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801216:	eb da                	jmp    8011f2 <read+0x5e>
		return -E_NOT_SUPP;
  801218:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80121d:	eb d3                	jmp    8011f2 <read+0x5e>

0080121f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80121f:	f3 0f 1e fb          	endbr32 
  801223:	55                   	push   %ebp
  801224:	89 e5                	mov    %esp,%ebp
  801226:	57                   	push   %edi
  801227:	56                   	push   %esi
  801228:	53                   	push   %ebx
  801229:	83 ec 0c             	sub    $0xc,%esp
  80122c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80122f:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801232:	bb 00 00 00 00       	mov    $0x0,%ebx
  801237:	eb 02                	jmp    80123b <readn+0x1c>
  801239:	01 c3                	add    %eax,%ebx
  80123b:	39 f3                	cmp    %esi,%ebx
  80123d:	73 21                	jae    801260 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80123f:	83 ec 04             	sub    $0x4,%esp
  801242:	89 f0                	mov    %esi,%eax
  801244:	29 d8                	sub    %ebx,%eax
  801246:	50                   	push   %eax
  801247:	89 d8                	mov    %ebx,%eax
  801249:	03 45 0c             	add    0xc(%ebp),%eax
  80124c:	50                   	push   %eax
  80124d:	57                   	push   %edi
  80124e:	e8 41 ff ff ff       	call   801194 <read>
		if (m < 0)
  801253:	83 c4 10             	add    $0x10,%esp
  801256:	85 c0                	test   %eax,%eax
  801258:	78 04                	js     80125e <readn+0x3f>
			return m;
		if (m == 0)
  80125a:	75 dd                	jne    801239 <readn+0x1a>
  80125c:	eb 02                	jmp    801260 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80125e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801260:	89 d8                	mov    %ebx,%eax
  801262:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801265:	5b                   	pop    %ebx
  801266:	5e                   	pop    %esi
  801267:	5f                   	pop    %edi
  801268:	5d                   	pop    %ebp
  801269:	c3                   	ret    

0080126a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80126a:	f3 0f 1e fb          	endbr32 
  80126e:	55                   	push   %ebp
  80126f:	89 e5                	mov    %esp,%ebp
  801271:	53                   	push   %ebx
  801272:	83 ec 1c             	sub    $0x1c,%esp
  801275:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801278:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80127b:	50                   	push   %eax
  80127c:	53                   	push   %ebx
  80127d:	e8 8f fc ff ff       	call   800f11 <fd_lookup>
  801282:	83 c4 10             	add    $0x10,%esp
  801285:	85 c0                	test   %eax,%eax
  801287:	78 3a                	js     8012c3 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801289:	83 ec 08             	sub    $0x8,%esp
  80128c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80128f:	50                   	push   %eax
  801290:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801293:	ff 30                	pushl  (%eax)
  801295:	e8 cb fc ff ff       	call   800f65 <dev_lookup>
  80129a:	83 c4 10             	add    $0x10,%esp
  80129d:	85 c0                	test   %eax,%eax
  80129f:	78 22                	js     8012c3 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012a4:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012a8:	74 1e                	je     8012c8 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8012aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012ad:	8b 52 0c             	mov    0xc(%edx),%edx
  8012b0:	85 d2                	test   %edx,%edx
  8012b2:	74 35                	je     8012e9 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8012b4:	83 ec 04             	sub    $0x4,%esp
  8012b7:	ff 75 10             	pushl  0x10(%ebp)
  8012ba:	ff 75 0c             	pushl  0xc(%ebp)
  8012bd:	50                   	push   %eax
  8012be:	ff d2                	call   *%edx
  8012c0:	83 c4 10             	add    $0x10,%esp
}
  8012c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012c6:	c9                   	leave  
  8012c7:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8012c8:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8012cd:	8b 40 48             	mov    0x48(%eax),%eax
  8012d0:	83 ec 04             	sub    $0x4,%esp
  8012d3:	53                   	push   %ebx
  8012d4:	50                   	push   %eax
  8012d5:	68 09 24 80 00       	push   $0x802409
  8012da:	e8 50 ef ff ff       	call   80022f <cprintf>
		return -E_INVAL;
  8012df:	83 c4 10             	add    $0x10,%esp
  8012e2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012e7:	eb da                	jmp    8012c3 <write+0x59>
		return -E_NOT_SUPP;
  8012e9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012ee:	eb d3                	jmp    8012c3 <write+0x59>

008012f0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8012f0:	f3 0f 1e fb          	endbr32 
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
  8012f7:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012fd:	50                   	push   %eax
  8012fe:	ff 75 08             	pushl  0x8(%ebp)
  801301:	e8 0b fc ff ff       	call   800f11 <fd_lookup>
  801306:	83 c4 10             	add    $0x10,%esp
  801309:	85 c0                	test   %eax,%eax
  80130b:	78 0e                	js     80131b <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80130d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801310:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801313:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801316:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80131b:	c9                   	leave  
  80131c:	c3                   	ret    

0080131d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80131d:	f3 0f 1e fb          	endbr32 
  801321:	55                   	push   %ebp
  801322:	89 e5                	mov    %esp,%ebp
  801324:	53                   	push   %ebx
  801325:	83 ec 1c             	sub    $0x1c,%esp
  801328:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80132b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80132e:	50                   	push   %eax
  80132f:	53                   	push   %ebx
  801330:	e8 dc fb ff ff       	call   800f11 <fd_lookup>
  801335:	83 c4 10             	add    $0x10,%esp
  801338:	85 c0                	test   %eax,%eax
  80133a:	78 37                	js     801373 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80133c:	83 ec 08             	sub    $0x8,%esp
  80133f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801342:	50                   	push   %eax
  801343:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801346:	ff 30                	pushl  (%eax)
  801348:	e8 18 fc ff ff       	call   800f65 <dev_lookup>
  80134d:	83 c4 10             	add    $0x10,%esp
  801350:	85 c0                	test   %eax,%eax
  801352:	78 1f                	js     801373 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801354:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801357:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80135b:	74 1b                	je     801378 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80135d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801360:	8b 52 18             	mov    0x18(%edx),%edx
  801363:	85 d2                	test   %edx,%edx
  801365:	74 32                	je     801399 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801367:	83 ec 08             	sub    $0x8,%esp
  80136a:	ff 75 0c             	pushl  0xc(%ebp)
  80136d:	50                   	push   %eax
  80136e:	ff d2                	call   *%edx
  801370:	83 c4 10             	add    $0x10,%esp
}
  801373:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801376:	c9                   	leave  
  801377:	c3                   	ret    
			thisenv->env_id, fdnum);
  801378:	a1 20 40 c0 00       	mov    0xc04020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80137d:	8b 40 48             	mov    0x48(%eax),%eax
  801380:	83 ec 04             	sub    $0x4,%esp
  801383:	53                   	push   %ebx
  801384:	50                   	push   %eax
  801385:	68 cc 23 80 00       	push   $0x8023cc
  80138a:	e8 a0 ee ff ff       	call   80022f <cprintf>
		return -E_INVAL;
  80138f:	83 c4 10             	add    $0x10,%esp
  801392:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801397:	eb da                	jmp    801373 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801399:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80139e:	eb d3                	jmp    801373 <ftruncate+0x56>

008013a0 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8013a0:	f3 0f 1e fb          	endbr32 
  8013a4:	55                   	push   %ebp
  8013a5:	89 e5                	mov    %esp,%ebp
  8013a7:	53                   	push   %ebx
  8013a8:	83 ec 1c             	sub    $0x1c,%esp
  8013ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013ae:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013b1:	50                   	push   %eax
  8013b2:	ff 75 08             	pushl  0x8(%ebp)
  8013b5:	e8 57 fb ff ff       	call   800f11 <fd_lookup>
  8013ba:	83 c4 10             	add    $0x10,%esp
  8013bd:	85 c0                	test   %eax,%eax
  8013bf:	78 4b                	js     80140c <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013c1:	83 ec 08             	sub    $0x8,%esp
  8013c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013c7:	50                   	push   %eax
  8013c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013cb:	ff 30                	pushl  (%eax)
  8013cd:	e8 93 fb ff ff       	call   800f65 <dev_lookup>
  8013d2:	83 c4 10             	add    $0x10,%esp
  8013d5:	85 c0                	test   %eax,%eax
  8013d7:	78 33                	js     80140c <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8013d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013dc:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8013e0:	74 2f                	je     801411 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8013e2:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8013e5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8013ec:	00 00 00 
	stat->st_isdir = 0;
  8013ef:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8013f6:	00 00 00 
	stat->st_dev = dev;
  8013f9:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8013ff:	83 ec 08             	sub    $0x8,%esp
  801402:	53                   	push   %ebx
  801403:	ff 75 f0             	pushl  -0x10(%ebp)
  801406:	ff 50 14             	call   *0x14(%eax)
  801409:	83 c4 10             	add    $0x10,%esp
}
  80140c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80140f:	c9                   	leave  
  801410:	c3                   	ret    
		return -E_NOT_SUPP;
  801411:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801416:	eb f4                	jmp    80140c <fstat+0x6c>

00801418 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801418:	f3 0f 1e fb          	endbr32 
  80141c:	55                   	push   %ebp
  80141d:	89 e5                	mov    %esp,%ebp
  80141f:	56                   	push   %esi
  801420:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801421:	83 ec 08             	sub    $0x8,%esp
  801424:	6a 00                	push   $0x0
  801426:	ff 75 08             	pushl  0x8(%ebp)
  801429:	e8 fb 01 00 00       	call   801629 <open>
  80142e:	89 c3                	mov    %eax,%ebx
  801430:	83 c4 10             	add    $0x10,%esp
  801433:	85 c0                	test   %eax,%eax
  801435:	78 1b                	js     801452 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801437:	83 ec 08             	sub    $0x8,%esp
  80143a:	ff 75 0c             	pushl  0xc(%ebp)
  80143d:	50                   	push   %eax
  80143e:	e8 5d ff ff ff       	call   8013a0 <fstat>
  801443:	89 c6                	mov    %eax,%esi
	close(fd);
  801445:	89 1c 24             	mov    %ebx,(%esp)
  801448:	e8 fd fb ff ff       	call   80104a <close>
	return r;
  80144d:	83 c4 10             	add    $0x10,%esp
  801450:	89 f3                	mov    %esi,%ebx
}
  801452:	89 d8                	mov    %ebx,%eax
  801454:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801457:	5b                   	pop    %ebx
  801458:	5e                   	pop    %esi
  801459:	5d                   	pop    %ebp
  80145a:	c3                   	ret    

0080145b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80145b:	55                   	push   %ebp
  80145c:	89 e5                	mov    %esp,%ebp
  80145e:	56                   	push   %esi
  80145f:	53                   	push   %ebx
  801460:	89 c6                	mov    %eax,%esi
  801462:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801464:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80146b:	74 27                	je     801494 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80146d:	6a 07                	push   $0x7
  80146f:	68 00 50 c0 00       	push   $0xc05000
  801474:	56                   	push   %esi
  801475:	ff 35 00 40 80 00    	pushl  0x804000
  80147b:	e8 d6 07 00 00       	call   801c56 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801480:	83 c4 0c             	add    $0xc,%esp
  801483:	6a 00                	push   $0x0
  801485:	53                   	push   %ebx
  801486:	6a 00                	push   $0x0
  801488:	e8 44 07 00 00       	call   801bd1 <ipc_recv>
}
  80148d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801490:	5b                   	pop    %ebx
  801491:	5e                   	pop    %esi
  801492:	5d                   	pop    %ebp
  801493:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801494:	83 ec 0c             	sub    $0xc,%esp
  801497:	6a 01                	push   $0x1
  801499:	e8 10 08 00 00       	call   801cae <ipc_find_env>
  80149e:	a3 00 40 80 00       	mov    %eax,0x804000
  8014a3:	83 c4 10             	add    $0x10,%esp
  8014a6:	eb c5                	jmp    80146d <fsipc+0x12>

008014a8 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8014a8:	f3 0f 1e fb          	endbr32 
  8014ac:	55                   	push   %ebp
  8014ad:	89 e5                	mov    %esp,%ebp
  8014af:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8014b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8014b8:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.set_size.req_size = newsize;
  8014bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c0:	a3 04 50 c0 00       	mov    %eax,0xc05004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8014c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ca:	b8 02 00 00 00       	mov    $0x2,%eax
  8014cf:	e8 87 ff ff ff       	call   80145b <fsipc>
}
  8014d4:	c9                   	leave  
  8014d5:	c3                   	ret    

008014d6 <devfile_flush>:
{
  8014d6:	f3 0f 1e fb          	endbr32 
  8014da:	55                   	push   %ebp
  8014db:	89 e5                	mov    %esp,%ebp
  8014dd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8014e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8014e6:	a3 00 50 c0 00       	mov    %eax,0xc05000
	return fsipc(FSREQ_FLUSH, NULL);
  8014eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8014f0:	b8 06 00 00 00       	mov    $0x6,%eax
  8014f5:	e8 61 ff ff ff       	call   80145b <fsipc>
}
  8014fa:	c9                   	leave  
  8014fb:	c3                   	ret    

008014fc <devfile_stat>:
{
  8014fc:	f3 0f 1e fb          	endbr32 
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
  801503:	53                   	push   %ebx
  801504:	83 ec 04             	sub    $0x4,%esp
  801507:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80150a:	8b 45 08             	mov    0x8(%ebp),%eax
  80150d:	8b 40 0c             	mov    0xc(%eax),%eax
  801510:	a3 00 50 c0 00       	mov    %eax,0xc05000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801515:	ba 00 00 00 00       	mov    $0x0,%edx
  80151a:	b8 05 00 00 00       	mov    $0x5,%eax
  80151f:	e8 37 ff ff ff       	call   80145b <fsipc>
  801524:	85 c0                	test   %eax,%eax
  801526:	78 2c                	js     801554 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801528:	83 ec 08             	sub    $0x8,%esp
  80152b:	68 00 50 c0 00       	push   $0xc05000
  801530:	53                   	push   %ebx
  801531:	e8 03 f3 ff ff       	call   800839 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801536:	a1 80 50 c0 00       	mov    0xc05080,%eax
  80153b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801541:	a1 84 50 c0 00       	mov    0xc05084,%eax
  801546:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80154c:	83 c4 10             	add    $0x10,%esp
  80154f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801554:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801557:	c9                   	leave  
  801558:	c3                   	ret    

00801559 <devfile_write>:
{
  801559:	f3 0f 1e fb          	endbr32 
  80155d:	55                   	push   %ebp
  80155e:	89 e5                	mov    %esp,%ebp
  801560:	83 ec 0c             	sub    $0xc,%esp
  801563:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801566:	8b 55 08             	mov    0x8(%ebp),%edx
  801569:	8b 52 0c             	mov    0xc(%edx),%edx
  80156c:	89 15 00 50 c0 00    	mov    %edx,0xc05000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801572:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801577:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80157c:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  80157f:	a3 04 50 c0 00       	mov    %eax,0xc05004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801584:	50                   	push   %eax
  801585:	ff 75 0c             	pushl  0xc(%ebp)
  801588:	68 08 50 c0 00       	push   $0xc05008
  80158d:	e8 5d f4 ff ff       	call   8009ef <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801592:	ba 00 00 00 00       	mov    $0x0,%edx
  801597:	b8 04 00 00 00       	mov    $0x4,%eax
  80159c:	e8 ba fe ff ff       	call   80145b <fsipc>
}
  8015a1:	c9                   	leave  
  8015a2:	c3                   	ret    

008015a3 <devfile_read>:
{
  8015a3:	f3 0f 1e fb          	endbr32 
  8015a7:	55                   	push   %ebp
  8015a8:	89 e5                	mov    %esp,%ebp
  8015aa:	56                   	push   %esi
  8015ab:	53                   	push   %ebx
  8015ac:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8015af:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8015b5:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.read.req_n = n;
  8015ba:	89 35 04 50 c0 00    	mov    %esi,0xc05004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8015c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c5:	b8 03 00 00 00       	mov    $0x3,%eax
  8015ca:	e8 8c fe ff ff       	call   80145b <fsipc>
  8015cf:	89 c3                	mov    %eax,%ebx
  8015d1:	85 c0                	test   %eax,%eax
  8015d3:	78 1f                	js     8015f4 <devfile_read+0x51>
	assert(r <= n);
  8015d5:	39 f0                	cmp    %esi,%eax
  8015d7:	77 24                	ja     8015fd <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8015d9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8015de:	7f 33                	jg     801613 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8015e0:	83 ec 04             	sub    $0x4,%esp
  8015e3:	50                   	push   %eax
  8015e4:	68 00 50 c0 00       	push   $0xc05000
  8015e9:	ff 75 0c             	pushl  0xc(%ebp)
  8015ec:	e8 fe f3 ff ff       	call   8009ef <memmove>
	return r;
  8015f1:	83 c4 10             	add    $0x10,%esp
}
  8015f4:	89 d8                	mov    %ebx,%eax
  8015f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015f9:	5b                   	pop    %ebx
  8015fa:	5e                   	pop    %esi
  8015fb:	5d                   	pop    %ebp
  8015fc:	c3                   	ret    
	assert(r <= n);
  8015fd:	68 38 24 80 00       	push   $0x802438
  801602:	68 3f 24 80 00       	push   $0x80243f
  801607:	6a 7c                	push   $0x7c
  801609:	68 54 24 80 00       	push   $0x802454
  80160e:	e8 35 eb ff ff       	call   800148 <_panic>
	assert(r <= PGSIZE);
  801613:	68 5f 24 80 00       	push   $0x80245f
  801618:	68 3f 24 80 00       	push   $0x80243f
  80161d:	6a 7d                	push   $0x7d
  80161f:	68 54 24 80 00       	push   $0x802454
  801624:	e8 1f eb ff ff       	call   800148 <_panic>

00801629 <open>:
{
  801629:	f3 0f 1e fb          	endbr32 
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
  801630:	56                   	push   %esi
  801631:	53                   	push   %ebx
  801632:	83 ec 1c             	sub    $0x1c,%esp
  801635:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801638:	56                   	push   %esi
  801639:	e8 b8 f1 ff ff       	call   8007f6 <strlen>
  80163e:	83 c4 10             	add    $0x10,%esp
  801641:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801646:	7f 6c                	jg     8016b4 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801648:	83 ec 0c             	sub    $0xc,%esp
  80164b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80164e:	50                   	push   %eax
  80164f:	e8 67 f8 ff ff       	call   800ebb <fd_alloc>
  801654:	89 c3                	mov    %eax,%ebx
  801656:	83 c4 10             	add    $0x10,%esp
  801659:	85 c0                	test   %eax,%eax
  80165b:	78 3c                	js     801699 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  80165d:	83 ec 08             	sub    $0x8,%esp
  801660:	56                   	push   %esi
  801661:	68 00 50 c0 00       	push   $0xc05000
  801666:	e8 ce f1 ff ff       	call   800839 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80166b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166e:	a3 00 54 c0 00       	mov    %eax,0xc05400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801673:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801676:	b8 01 00 00 00       	mov    $0x1,%eax
  80167b:	e8 db fd ff ff       	call   80145b <fsipc>
  801680:	89 c3                	mov    %eax,%ebx
  801682:	83 c4 10             	add    $0x10,%esp
  801685:	85 c0                	test   %eax,%eax
  801687:	78 19                	js     8016a2 <open+0x79>
	return fd2num(fd);
  801689:	83 ec 0c             	sub    $0xc,%esp
  80168c:	ff 75 f4             	pushl  -0xc(%ebp)
  80168f:	e8 f8 f7 ff ff       	call   800e8c <fd2num>
  801694:	89 c3                	mov    %eax,%ebx
  801696:	83 c4 10             	add    $0x10,%esp
}
  801699:	89 d8                	mov    %ebx,%eax
  80169b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80169e:	5b                   	pop    %ebx
  80169f:	5e                   	pop    %esi
  8016a0:	5d                   	pop    %ebp
  8016a1:	c3                   	ret    
		fd_close(fd, 0);
  8016a2:	83 ec 08             	sub    $0x8,%esp
  8016a5:	6a 00                	push   $0x0
  8016a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8016aa:	e8 10 f9 ff ff       	call   800fbf <fd_close>
		return r;
  8016af:	83 c4 10             	add    $0x10,%esp
  8016b2:	eb e5                	jmp    801699 <open+0x70>
		return -E_BAD_PATH;
  8016b4:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8016b9:	eb de                	jmp    801699 <open+0x70>

008016bb <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8016bb:	f3 0f 1e fb          	endbr32 
  8016bf:	55                   	push   %ebp
  8016c0:	89 e5                	mov    %esp,%ebp
  8016c2:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8016c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ca:	b8 08 00 00 00       	mov    $0x8,%eax
  8016cf:	e8 87 fd ff ff       	call   80145b <fsipc>
}
  8016d4:	c9                   	leave  
  8016d5:	c3                   	ret    

008016d6 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8016d6:	f3 0f 1e fb          	endbr32 
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
  8016dd:	56                   	push   %esi
  8016de:	53                   	push   %ebx
  8016df:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8016e2:	83 ec 0c             	sub    $0xc,%esp
  8016e5:	ff 75 08             	pushl  0x8(%ebp)
  8016e8:	e8 b3 f7 ff ff       	call   800ea0 <fd2data>
  8016ed:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8016ef:	83 c4 08             	add    $0x8,%esp
  8016f2:	68 6b 24 80 00       	push   $0x80246b
  8016f7:	53                   	push   %ebx
  8016f8:	e8 3c f1 ff ff       	call   800839 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8016fd:	8b 46 04             	mov    0x4(%esi),%eax
  801700:	2b 06                	sub    (%esi),%eax
  801702:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801708:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80170f:	00 00 00 
	stat->st_dev = &devpipe;
  801712:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801719:	30 80 00 
	return 0;
}
  80171c:	b8 00 00 00 00       	mov    $0x0,%eax
  801721:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801724:	5b                   	pop    %ebx
  801725:	5e                   	pop    %esi
  801726:	5d                   	pop    %ebp
  801727:	c3                   	ret    

00801728 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801728:	f3 0f 1e fb          	endbr32 
  80172c:	55                   	push   %ebp
  80172d:	89 e5                	mov    %esp,%ebp
  80172f:	53                   	push   %ebx
  801730:	83 ec 0c             	sub    $0xc,%esp
  801733:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801736:	53                   	push   %ebx
  801737:	6a 00                	push   $0x0
  801739:	e8 ca f5 ff ff       	call   800d08 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80173e:	89 1c 24             	mov    %ebx,(%esp)
  801741:	e8 5a f7 ff ff       	call   800ea0 <fd2data>
  801746:	83 c4 08             	add    $0x8,%esp
  801749:	50                   	push   %eax
  80174a:	6a 00                	push   $0x0
  80174c:	e8 b7 f5 ff ff       	call   800d08 <sys_page_unmap>
}
  801751:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801754:	c9                   	leave  
  801755:	c3                   	ret    

00801756 <_pipeisclosed>:
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
  801759:	57                   	push   %edi
  80175a:	56                   	push   %esi
  80175b:	53                   	push   %ebx
  80175c:	83 ec 1c             	sub    $0x1c,%esp
  80175f:	89 c7                	mov    %eax,%edi
  801761:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801763:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801768:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80176b:	83 ec 0c             	sub    $0xc,%esp
  80176e:	57                   	push   %edi
  80176f:	e8 77 05 00 00       	call   801ceb <pageref>
  801774:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801777:	89 34 24             	mov    %esi,(%esp)
  80177a:	e8 6c 05 00 00       	call   801ceb <pageref>
		nn = thisenv->env_runs;
  80177f:	8b 15 20 40 c0 00    	mov    0xc04020,%edx
  801785:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801788:	83 c4 10             	add    $0x10,%esp
  80178b:	39 cb                	cmp    %ecx,%ebx
  80178d:	74 1b                	je     8017aa <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80178f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801792:	75 cf                	jne    801763 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801794:	8b 42 58             	mov    0x58(%edx),%eax
  801797:	6a 01                	push   $0x1
  801799:	50                   	push   %eax
  80179a:	53                   	push   %ebx
  80179b:	68 72 24 80 00       	push   $0x802472
  8017a0:	e8 8a ea ff ff       	call   80022f <cprintf>
  8017a5:	83 c4 10             	add    $0x10,%esp
  8017a8:	eb b9                	jmp    801763 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8017aa:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8017ad:	0f 94 c0             	sete   %al
  8017b0:	0f b6 c0             	movzbl %al,%eax
}
  8017b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017b6:	5b                   	pop    %ebx
  8017b7:	5e                   	pop    %esi
  8017b8:	5f                   	pop    %edi
  8017b9:	5d                   	pop    %ebp
  8017ba:	c3                   	ret    

008017bb <devpipe_write>:
{
  8017bb:	f3 0f 1e fb          	endbr32 
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
  8017c2:	57                   	push   %edi
  8017c3:	56                   	push   %esi
  8017c4:	53                   	push   %ebx
  8017c5:	83 ec 28             	sub    $0x28,%esp
  8017c8:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8017cb:	56                   	push   %esi
  8017cc:	e8 cf f6 ff ff       	call   800ea0 <fd2data>
  8017d1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8017d3:	83 c4 10             	add    $0x10,%esp
  8017d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8017db:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8017de:	74 4f                	je     80182f <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8017e0:	8b 43 04             	mov    0x4(%ebx),%eax
  8017e3:	8b 0b                	mov    (%ebx),%ecx
  8017e5:	8d 51 20             	lea    0x20(%ecx),%edx
  8017e8:	39 d0                	cmp    %edx,%eax
  8017ea:	72 14                	jb     801800 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8017ec:	89 da                	mov    %ebx,%edx
  8017ee:	89 f0                	mov    %esi,%eax
  8017f0:	e8 61 ff ff ff       	call   801756 <_pipeisclosed>
  8017f5:	85 c0                	test   %eax,%eax
  8017f7:	75 3b                	jne    801834 <devpipe_write+0x79>
			sys_yield();
  8017f9:	e8 5a f4 ff ff       	call   800c58 <sys_yield>
  8017fe:	eb e0                	jmp    8017e0 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801800:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801803:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801807:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80180a:	89 c2                	mov    %eax,%edx
  80180c:	c1 fa 1f             	sar    $0x1f,%edx
  80180f:	89 d1                	mov    %edx,%ecx
  801811:	c1 e9 1b             	shr    $0x1b,%ecx
  801814:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801817:	83 e2 1f             	and    $0x1f,%edx
  80181a:	29 ca                	sub    %ecx,%edx
  80181c:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801820:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801824:	83 c0 01             	add    $0x1,%eax
  801827:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80182a:	83 c7 01             	add    $0x1,%edi
  80182d:	eb ac                	jmp    8017db <devpipe_write+0x20>
	return i;
  80182f:	8b 45 10             	mov    0x10(%ebp),%eax
  801832:	eb 05                	jmp    801839 <devpipe_write+0x7e>
				return 0;
  801834:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801839:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80183c:	5b                   	pop    %ebx
  80183d:	5e                   	pop    %esi
  80183e:	5f                   	pop    %edi
  80183f:	5d                   	pop    %ebp
  801840:	c3                   	ret    

00801841 <devpipe_read>:
{
  801841:	f3 0f 1e fb          	endbr32 
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
  801848:	57                   	push   %edi
  801849:	56                   	push   %esi
  80184a:	53                   	push   %ebx
  80184b:	83 ec 18             	sub    $0x18,%esp
  80184e:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801851:	57                   	push   %edi
  801852:	e8 49 f6 ff ff       	call   800ea0 <fd2data>
  801857:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801859:	83 c4 10             	add    $0x10,%esp
  80185c:	be 00 00 00 00       	mov    $0x0,%esi
  801861:	3b 75 10             	cmp    0x10(%ebp),%esi
  801864:	75 14                	jne    80187a <devpipe_read+0x39>
	return i;
  801866:	8b 45 10             	mov    0x10(%ebp),%eax
  801869:	eb 02                	jmp    80186d <devpipe_read+0x2c>
				return i;
  80186b:	89 f0                	mov    %esi,%eax
}
  80186d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801870:	5b                   	pop    %ebx
  801871:	5e                   	pop    %esi
  801872:	5f                   	pop    %edi
  801873:	5d                   	pop    %ebp
  801874:	c3                   	ret    
			sys_yield();
  801875:	e8 de f3 ff ff       	call   800c58 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80187a:	8b 03                	mov    (%ebx),%eax
  80187c:	3b 43 04             	cmp    0x4(%ebx),%eax
  80187f:	75 18                	jne    801899 <devpipe_read+0x58>
			if (i > 0)
  801881:	85 f6                	test   %esi,%esi
  801883:	75 e6                	jne    80186b <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801885:	89 da                	mov    %ebx,%edx
  801887:	89 f8                	mov    %edi,%eax
  801889:	e8 c8 fe ff ff       	call   801756 <_pipeisclosed>
  80188e:	85 c0                	test   %eax,%eax
  801890:	74 e3                	je     801875 <devpipe_read+0x34>
				return 0;
  801892:	b8 00 00 00 00       	mov    $0x0,%eax
  801897:	eb d4                	jmp    80186d <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801899:	99                   	cltd   
  80189a:	c1 ea 1b             	shr    $0x1b,%edx
  80189d:	01 d0                	add    %edx,%eax
  80189f:	83 e0 1f             	and    $0x1f,%eax
  8018a2:	29 d0                	sub    %edx,%eax
  8018a4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8018a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018ac:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8018af:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8018b2:	83 c6 01             	add    $0x1,%esi
  8018b5:	eb aa                	jmp    801861 <devpipe_read+0x20>

008018b7 <pipe>:
{
  8018b7:	f3 0f 1e fb          	endbr32 
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
  8018be:	56                   	push   %esi
  8018bf:	53                   	push   %ebx
  8018c0:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8018c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018c6:	50                   	push   %eax
  8018c7:	e8 ef f5 ff ff       	call   800ebb <fd_alloc>
  8018cc:	89 c3                	mov    %eax,%ebx
  8018ce:	83 c4 10             	add    $0x10,%esp
  8018d1:	85 c0                	test   %eax,%eax
  8018d3:	0f 88 23 01 00 00    	js     8019fc <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018d9:	83 ec 04             	sub    $0x4,%esp
  8018dc:	68 07 04 00 00       	push   $0x407
  8018e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8018e4:	6a 00                	push   $0x0
  8018e6:	e8 90 f3 ff ff       	call   800c7b <sys_page_alloc>
  8018eb:	89 c3                	mov    %eax,%ebx
  8018ed:	83 c4 10             	add    $0x10,%esp
  8018f0:	85 c0                	test   %eax,%eax
  8018f2:	0f 88 04 01 00 00    	js     8019fc <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  8018f8:	83 ec 0c             	sub    $0xc,%esp
  8018fb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018fe:	50                   	push   %eax
  8018ff:	e8 b7 f5 ff ff       	call   800ebb <fd_alloc>
  801904:	89 c3                	mov    %eax,%ebx
  801906:	83 c4 10             	add    $0x10,%esp
  801909:	85 c0                	test   %eax,%eax
  80190b:	0f 88 db 00 00 00    	js     8019ec <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801911:	83 ec 04             	sub    $0x4,%esp
  801914:	68 07 04 00 00       	push   $0x407
  801919:	ff 75 f0             	pushl  -0x10(%ebp)
  80191c:	6a 00                	push   $0x0
  80191e:	e8 58 f3 ff ff       	call   800c7b <sys_page_alloc>
  801923:	89 c3                	mov    %eax,%ebx
  801925:	83 c4 10             	add    $0x10,%esp
  801928:	85 c0                	test   %eax,%eax
  80192a:	0f 88 bc 00 00 00    	js     8019ec <pipe+0x135>
	va = fd2data(fd0);
  801930:	83 ec 0c             	sub    $0xc,%esp
  801933:	ff 75 f4             	pushl  -0xc(%ebp)
  801936:	e8 65 f5 ff ff       	call   800ea0 <fd2data>
  80193b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80193d:	83 c4 0c             	add    $0xc,%esp
  801940:	68 07 04 00 00       	push   $0x407
  801945:	50                   	push   %eax
  801946:	6a 00                	push   $0x0
  801948:	e8 2e f3 ff ff       	call   800c7b <sys_page_alloc>
  80194d:	89 c3                	mov    %eax,%ebx
  80194f:	83 c4 10             	add    $0x10,%esp
  801952:	85 c0                	test   %eax,%eax
  801954:	0f 88 82 00 00 00    	js     8019dc <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80195a:	83 ec 0c             	sub    $0xc,%esp
  80195d:	ff 75 f0             	pushl  -0x10(%ebp)
  801960:	e8 3b f5 ff ff       	call   800ea0 <fd2data>
  801965:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80196c:	50                   	push   %eax
  80196d:	6a 00                	push   $0x0
  80196f:	56                   	push   %esi
  801970:	6a 00                	push   $0x0
  801972:	e8 4b f3 ff ff       	call   800cc2 <sys_page_map>
  801977:	89 c3                	mov    %eax,%ebx
  801979:	83 c4 20             	add    $0x20,%esp
  80197c:	85 c0                	test   %eax,%eax
  80197e:	78 4e                	js     8019ce <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801980:	a1 20 30 80 00       	mov    0x803020,%eax
  801985:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801988:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80198a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80198d:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801994:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801997:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801999:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80199c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8019a3:	83 ec 0c             	sub    $0xc,%esp
  8019a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8019a9:	e8 de f4 ff ff       	call   800e8c <fd2num>
  8019ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019b1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8019b3:	83 c4 04             	add    $0x4,%esp
  8019b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8019b9:	e8 ce f4 ff ff       	call   800e8c <fd2num>
  8019be:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019c1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8019c4:	83 c4 10             	add    $0x10,%esp
  8019c7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019cc:	eb 2e                	jmp    8019fc <pipe+0x145>
	sys_page_unmap(0, va);
  8019ce:	83 ec 08             	sub    $0x8,%esp
  8019d1:	56                   	push   %esi
  8019d2:	6a 00                	push   $0x0
  8019d4:	e8 2f f3 ff ff       	call   800d08 <sys_page_unmap>
  8019d9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8019dc:	83 ec 08             	sub    $0x8,%esp
  8019df:	ff 75 f0             	pushl  -0x10(%ebp)
  8019e2:	6a 00                	push   $0x0
  8019e4:	e8 1f f3 ff ff       	call   800d08 <sys_page_unmap>
  8019e9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8019ec:	83 ec 08             	sub    $0x8,%esp
  8019ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8019f2:	6a 00                	push   $0x0
  8019f4:	e8 0f f3 ff ff       	call   800d08 <sys_page_unmap>
  8019f9:	83 c4 10             	add    $0x10,%esp
}
  8019fc:	89 d8                	mov    %ebx,%eax
  8019fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a01:	5b                   	pop    %ebx
  801a02:	5e                   	pop    %esi
  801a03:	5d                   	pop    %ebp
  801a04:	c3                   	ret    

00801a05 <pipeisclosed>:
{
  801a05:	f3 0f 1e fb          	endbr32 
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
  801a0c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a0f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a12:	50                   	push   %eax
  801a13:	ff 75 08             	pushl  0x8(%ebp)
  801a16:	e8 f6 f4 ff ff       	call   800f11 <fd_lookup>
  801a1b:	83 c4 10             	add    $0x10,%esp
  801a1e:	85 c0                	test   %eax,%eax
  801a20:	78 18                	js     801a3a <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801a22:	83 ec 0c             	sub    $0xc,%esp
  801a25:	ff 75 f4             	pushl  -0xc(%ebp)
  801a28:	e8 73 f4 ff ff       	call   800ea0 <fd2data>
  801a2d:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a32:	e8 1f fd ff ff       	call   801756 <_pipeisclosed>
  801a37:	83 c4 10             	add    $0x10,%esp
}
  801a3a:	c9                   	leave  
  801a3b:	c3                   	ret    

00801a3c <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801a3c:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801a40:	b8 00 00 00 00       	mov    $0x0,%eax
  801a45:	c3                   	ret    

00801a46 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801a46:	f3 0f 1e fb          	endbr32 
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
  801a4d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801a50:	68 8a 24 80 00       	push   $0x80248a
  801a55:	ff 75 0c             	pushl  0xc(%ebp)
  801a58:	e8 dc ed ff ff       	call   800839 <strcpy>
	return 0;
}
  801a5d:	b8 00 00 00 00       	mov    $0x0,%eax
  801a62:	c9                   	leave  
  801a63:	c3                   	ret    

00801a64 <devcons_write>:
{
  801a64:	f3 0f 1e fb          	endbr32 
  801a68:	55                   	push   %ebp
  801a69:	89 e5                	mov    %esp,%ebp
  801a6b:	57                   	push   %edi
  801a6c:	56                   	push   %esi
  801a6d:	53                   	push   %ebx
  801a6e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801a74:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801a79:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801a7f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801a82:	73 31                	jae    801ab5 <devcons_write+0x51>
		m = n - tot;
  801a84:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801a87:	29 f3                	sub    %esi,%ebx
  801a89:	83 fb 7f             	cmp    $0x7f,%ebx
  801a8c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801a91:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801a94:	83 ec 04             	sub    $0x4,%esp
  801a97:	53                   	push   %ebx
  801a98:	89 f0                	mov    %esi,%eax
  801a9a:	03 45 0c             	add    0xc(%ebp),%eax
  801a9d:	50                   	push   %eax
  801a9e:	57                   	push   %edi
  801a9f:	e8 4b ef ff ff       	call   8009ef <memmove>
		sys_cputs(buf, m);
  801aa4:	83 c4 08             	add    $0x8,%esp
  801aa7:	53                   	push   %ebx
  801aa8:	57                   	push   %edi
  801aa9:	e8 fd f0 ff ff       	call   800bab <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801aae:	01 de                	add    %ebx,%esi
  801ab0:	83 c4 10             	add    $0x10,%esp
  801ab3:	eb ca                	jmp    801a7f <devcons_write+0x1b>
}
  801ab5:	89 f0                	mov    %esi,%eax
  801ab7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801aba:	5b                   	pop    %ebx
  801abb:	5e                   	pop    %esi
  801abc:	5f                   	pop    %edi
  801abd:	5d                   	pop    %ebp
  801abe:	c3                   	ret    

00801abf <devcons_read>:
{
  801abf:	f3 0f 1e fb          	endbr32 
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
  801ac6:	83 ec 08             	sub    $0x8,%esp
  801ac9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801ace:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ad2:	74 21                	je     801af5 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801ad4:	e8 f4 f0 ff ff       	call   800bcd <sys_cgetc>
  801ad9:	85 c0                	test   %eax,%eax
  801adb:	75 07                	jne    801ae4 <devcons_read+0x25>
		sys_yield();
  801add:	e8 76 f1 ff ff       	call   800c58 <sys_yield>
  801ae2:	eb f0                	jmp    801ad4 <devcons_read+0x15>
	if (c < 0)
  801ae4:	78 0f                	js     801af5 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801ae6:	83 f8 04             	cmp    $0x4,%eax
  801ae9:	74 0c                	je     801af7 <devcons_read+0x38>
	*(char*)vbuf = c;
  801aeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aee:	88 02                	mov    %al,(%edx)
	return 1;
  801af0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    
		return 0;
  801af7:	b8 00 00 00 00       	mov    $0x0,%eax
  801afc:	eb f7                	jmp    801af5 <devcons_read+0x36>

00801afe <cputchar>:
{
  801afe:	f3 0f 1e fb          	endbr32 
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
  801b05:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801b08:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0b:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801b0e:	6a 01                	push   $0x1
  801b10:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801b13:	50                   	push   %eax
  801b14:	e8 92 f0 ff ff       	call   800bab <sys_cputs>
}
  801b19:	83 c4 10             	add    $0x10,%esp
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <getchar>:
{
  801b1e:	f3 0f 1e fb          	endbr32 
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
  801b25:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801b28:	6a 01                	push   $0x1
  801b2a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801b2d:	50                   	push   %eax
  801b2e:	6a 00                	push   $0x0
  801b30:	e8 5f f6 ff ff       	call   801194 <read>
	if (r < 0)
  801b35:	83 c4 10             	add    $0x10,%esp
  801b38:	85 c0                	test   %eax,%eax
  801b3a:	78 06                	js     801b42 <getchar+0x24>
	if (r < 1)
  801b3c:	74 06                	je     801b44 <getchar+0x26>
	return c;
  801b3e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    
		return -E_EOF;
  801b44:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801b49:	eb f7                	jmp    801b42 <getchar+0x24>

00801b4b <iscons>:
{
  801b4b:	f3 0f 1e fb          	endbr32 
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
  801b52:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b55:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b58:	50                   	push   %eax
  801b59:	ff 75 08             	pushl  0x8(%ebp)
  801b5c:	e8 b0 f3 ff ff       	call   800f11 <fd_lookup>
  801b61:	83 c4 10             	add    $0x10,%esp
  801b64:	85 c0                	test   %eax,%eax
  801b66:	78 11                	js     801b79 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b6b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801b71:	39 10                	cmp    %edx,(%eax)
  801b73:	0f 94 c0             	sete   %al
  801b76:	0f b6 c0             	movzbl %al,%eax
}
  801b79:	c9                   	leave  
  801b7a:	c3                   	ret    

00801b7b <opencons>:
{
  801b7b:	f3 0f 1e fb          	endbr32 
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
  801b82:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801b85:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b88:	50                   	push   %eax
  801b89:	e8 2d f3 ff ff       	call   800ebb <fd_alloc>
  801b8e:	83 c4 10             	add    $0x10,%esp
  801b91:	85 c0                	test   %eax,%eax
  801b93:	78 3a                	js     801bcf <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801b95:	83 ec 04             	sub    $0x4,%esp
  801b98:	68 07 04 00 00       	push   $0x407
  801b9d:	ff 75 f4             	pushl  -0xc(%ebp)
  801ba0:	6a 00                	push   $0x0
  801ba2:	e8 d4 f0 ff ff       	call   800c7b <sys_page_alloc>
  801ba7:	83 c4 10             	add    $0x10,%esp
  801baa:	85 c0                	test   %eax,%eax
  801bac:	78 21                	js     801bcf <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb1:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801bb7:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bbc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801bc3:	83 ec 0c             	sub    $0xc,%esp
  801bc6:	50                   	push   %eax
  801bc7:	e8 c0 f2 ff ff       	call   800e8c <fd2num>
  801bcc:	83 c4 10             	add    $0x10,%esp
}
  801bcf:	c9                   	leave  
  801bd0:	c3                   	ret    

00801bd1 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801bd1:	f3 0f 1e fb          	endbr32 
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
  801bd8:	56                   	push   %esi
  801bd9:	53                   	push   %ebx
  801bda:	8b 75 08             	mov    0x8(%ebp),%esi
  801bdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  801be3:	85 c0                	test   %eax,%eax
  801be5:	74 3d                	je     801c24 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  801be7:	83 ec 0c             	sub    $0xc,%esp
  801bea:	50                   	push   %eax
  801beb:	e8 57 f2 ff ff       	call   800e47 <sys_ipc_recv>
  801bf0:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  801bf3:	85 f6                	test   %esi,%esi
  801bf5:	74 0b                	je     801c02 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801bf7:	8b 15 20 40 c0 00    	mov    0xc04020,%edx
  801bfd:	8b 52 74             	mov    0x74(%edx),%edx
  801c00:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801c02:	85 db                	test   %ebx,%ebx
  801c04:	74 0b                	je     801c11 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  801c06:	8b 15 20 40 c0 00    	mov    0xc04020,%edx
  801c0c:	8b 52 78             	mov    0x78(%edx),%edx
  801c0f:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  801c11:	85 c0                	test   %eax,%eax
  801c13:	78 21                	js     801c36 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  801c15:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801c1a:	8b 40 70             	mov    0x70(%eax),%eax
}
  801c1d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c20:	5b                   	pop    %ebx
  801c21:	5e                   	pop    %esi
  801c22:	5d                   	pop    %ebp
  801c23:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  801c24:	83 ec 0c             	sub    $0xc,%esp
  801c27:	68 00 00 c0 ee       	push   $0xeec00000
  801c2c:	e8 16 f2 ff ff       	call   800e47 <sys_ipc_recv>
  801c31:	83 c4 10             	add    $0x10,%esp
  801c34:	eb bd                	jmp    801bf3 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  801c36:	85 f6                	test   %esi,%esi
  801c38:	74 10                	je     801c4a <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  801c3a:	85 db                	test   %ebx,%ebx
  801c3c:	75 df                	jne    801c1d <ipc_recv+0x4c>
  801c3e:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801c45:	00 00 00 
  801c48:	eb d3                	jmp    801c1d <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  801c4a:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801c51:	00 00 00 
  801c54:	eb e4                	jmp    801c3a <ipc_recv+0x69>

00801c56 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801c56:	f3 0f 1e fb          	endbr32 
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
  801c5d:	57                   	push   %edi
  801c5e:	56                   	push   %esi
  801c5f:	53                   	push   %ebx
  801c60:	83 ec 0c             	sub    $0xc,%esp
  801c63:	8b 7d 08             	mov    0x8(%ebp),%edi
  801c66:	8b 75 0c             	mov    0xc(%ebp),%esi
  801c69:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  801c6c:	85 db                	test   %ebx,%ebx
  801c6e:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801c73:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  801c76:	ff 75 14             	pushl  0x14(%ebp)
  801c79:	53                   	push   %ebx
  801c7a:	56                   	push   %esi
  801c7b:	57                   	push   %edi
  801c7c:	e8 9f f1 ff ff       	call   800e20 <sys_ipc_try_send>
  801c81:	83 c4 10             	add    $0x10,%esp
  801c84:	85 c0                	test   %eax,%eax
  801c86:	79 1e                	jns    801ca6 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  801c88:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801c8b:	75 07                	jne    801c94 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  801c8d:	e8 c6 ef ff ff       	call   800c58 <sys_yield>
  801c92:	eb e2                	jmp    801c76 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  801c94:	50                   	push   %eax
  801c95:	68 96 24 80 00       	push   $0x802496
  801c9a:	6a 59                	push   $0x59
  801c9c:	68 b1 24 80 00       	push   $0x8024b1
  801ca1:	e8 a2 e4 ff ff       	call   800148 <_panic>
	}
}
  801ca6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ca9:	5b                   	pop    %ebx
  801caa:	5e                   	pop    %esi
  801cab:	5f                   	pop    %edi
  801cac:	5d                   	pop    %ebp
  801cad:	c3                   	ret    

00801cae <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801cae:	f3 0f 1e fb          	endbr32 
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
  801cb5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801cb8:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801cbd:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801cc0:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801cc6:	8b 52 50             	mov    0x50(%edx),%edx
  801cc9:	39 ca                	cmp    %ecx,%edx
  801ccb:	74 11                	je     801cde <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801ccd:	83 c0 01             	add    $0x1,%eax
  801cd0:	3d 00 04 00 00       	cmp    $0x400,%eax
  801cd5:	75 e6                	jne    801cbd <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801cd7:	b8 00 00 00 00       	mov    $0x0,%eax
  801cdc:	eb 0b                	jmp    801ce9 <ipc_find_env+0x3b>
			return envs[i].env_id;
  801cde:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801ce1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801ce6:	8b 40 48             	mov    0x48(%eax),%eax
}
  801ce9:	5d                   	pop    %ebp
  801cea:	c3                   	ret    

00801ceb <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801ceb:	f3 0f 1e fb          	endbr32 
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
  801cf2:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801cf5:	89 c2                	mov    %eax,%edx
  801cf7:	c1 ea 16             	shr    $0x16,%edx
  801cfa:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801d01:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801d06:	f6 c1 01             	test   $0x1,%cl
  801d09:	74 1c                	je     801d27 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801d0b:	c1 e8 0c             	shr    $0xc,%eax
  801d0e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801d15:	a8 01                	test   $0x1,%al
  801d17:	74 0e                	je     801d27 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801d19:	c1 e8 0c             	shr    $0xc,%eax
  801d1c:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801d23:	ef 
  801d24:	0f b7 d2             	movzwl %dx,%edx
}
  801d27:	89 d0                	mov    %edx,%eax
  801d29:	5d                   	pop    %ebp
  801d2a:	c3                   	ret    
  801d2b:	66 90                	xchg   %ax,%ax
  801d2d:	66 90                	xchg   %ax,%ax
  801d2f:	90                   	nop

00801d30 <__udivdi3>:
  801d30:	f3 0f 1e fb          	endbr32 
  801d34:	55                   	push   %ebp
  801d35:	57                   	push   %edi
  801d36:	56                   	push   %esi
  801d37:	53                   	push   %ebx
  801d38:	83 ec 1c             	sub    $0x1c,%esp
  801d3b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801d3f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801d43:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d47:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801d4b:	85 d2                	test   %edx,%edx
  801d4d:	75 19                	jne    801d68 <__udivdi3+0x38>
  801d4f:	39 f3                	cmp    %esi,%ebx
  801d51:	76 4d                	jbe    801da0 <__udivdi3+0x70>
  801d53:	31 ff                	xor    %edi,%edi
  801d55:	89 e8                	mov    %ebp,%eax
  801d57:	89 f2                	mov    %esi,%edx
  801d59:	f7 f3                	div    %ebx
  801d5b:	89 fa                	mov    %edi,%edx
  801d5d:	83 c4 1c             	add    $0x1c,%esp
  801d60:	5b                   	pop    %ebx
  801d61:	5e                   	pop    %esi
  801d62:	5f                   	pop    %edi
  801d63:	5d                   	pop    %ebp
  801d64:	c3                   	ret    
  801d65:	8d 76 00             	lea    0x0(%esi),%esi
  801d68:	39 f2                	cmp    %esi,%edx
  801d6a:	76 14                	jbe    801d80 <__udivdi3+0x50>
  801d6c:	31 ff                	xor    %edi,%edi
  801d6e:	31 c0                	xor    %eax,%eax
  801d70:	89 fa                	mov    %edi,%edx
  801d72:	83 c4 1c             	add    $0x1c,%esp
  801d75:	5b                   	pop    %ebx
  801d76:	5e                   	pop    %esi
  801d77:	5f                   	pop    %edi
  801d78:	5d                   	pop    %ebp
  801d79:	c3                   	ret    
  801d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801d80:	0f bd fa             	bsr    %edx,%edi
  801d83:	83 f7 1f             	xor    $0x1f,%edi
  801d86:	75 48                	jne    801dd0 <__udivdi3+0xa0>
  801d88:	39 f2                	cmp    %esi,%edx
  801d8a:	72 06                	jb     801d92 <__udivdi3+0x62>
  801d8c:	31 c0                	xor    %eax,%eax
  801d8e:	39 eb                	cmp    %ebp,%ebx
  801d90:	77 de                	ja     801d70 <__udivdi3+0x40>
  801d92:	b8 01 00 00 00       	mov    $0x1,%eax
  801d97:	eb d7                	jmp    801d70 <__udivdi3+0x40>
  801d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801da0:	89 d9                	mov    %ebx,%ecx
  801da2:	85 db                	test   %ebx,%ebx
  801da4:	75 0b                	jne    801db1 <__udivdi3+0x81>
  801da6:	b8 01 00 00 00       	mov    $0x1,%eax
  801dab:	31 d2                	xor    %edx,%edx
  801dad:	f7 f3                	div    %ebx
  801daf:	89 c1                	mov    %eax,%ecx
  801db1:	31 d2                	xor    %edx,%edx
  801db3:	89 f0                	mov    %esi,%eax
  801db5:	f7 f1                	div    %ecx
  801db7:	89 c6                	mov    %eax,%esi
  801db9:	89 e8                	mov    %ebp,%eax
  801dbb:	89 f7                	mov    %esi,%edi
  801dbd:	f7 f1                	div    %ecx
  801dbf:	89 fa                	mov    %edi,%edx
  801dc1:	83 c4 1c             	add    $0x1c,%esp
  801dc4:	5b                   	pop    %ebx
  801dc5:	5e                   	pop    %esi
  801dc6:	5f                   	pop    %edi
  801dc7:	5d                   	pop    %ebp
  801dc8:	c3                   	ret    
  801dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801dd0:	89 f9                	mov    %edi,%ecx
  801dd2:	b8 20 00 00 00       	mov    $0x20,%eax
  801dd7:	29 f8                	sub    %edi,%eax
  801dd9:	d3 e2                	shl    %cl,%edx
  801ddb:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ddf:	89 c1                	mov    %eax,%ecx
  801de1:	89 da                	mov    %ebx,%edx
  801de3:	d3 ea                	shr    %cl,%edx
  801de5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801de9:	09 d1                	or     %edx,%ecx
  801deb:	89 f2                	mov    %esi,%edx
  801ded:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801df1:	89 f9                	mov    %edi,%ecx
  801df3:	d3 e3                	shl    %cl,%ebx
  801df5:	89 c1                	mov    %eax,%ecx
  801df7:	d3 ea                	shr    %cl,%edx
  801df9:	89 f9                	mov    %edi,%ecx
  801dfb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801dff:	89 eb                	mov    %ebp,%ebx
  801e01:	d3 e6                	shl    %cl,%esi
  801e03:	89 c1                	mov    %eax,%ecx
  801e05:	d3 eb                	shr    %cl,%ebx
  801e07:	09 de                	or     %ebx,%esi
  801e09:	89 f0                	mov    %esi,%eax
  801e0b:	f7 74 24 08          	divl   0x8(%esp)
  801e0f:	89 d6                	mov    %edx,%esi
  801e11:	89 c3                	mov    %eax,%ebx
  801e13:	f7 64 24 0c          	mull   0xc(%esp)
  801e17:	39 d6                	cmp    %edx,%esi
  801e19:	72 15                	jb     801e30 <__udivdi3+0x100>
  801e1b:	89 f9                	mov    %edi,%ecx
  801e1d:	d3 e5                	shl    %cl,%ebp
  801e1f:	39 c5                	cmp    %eax,%ebp
  801e21:	73 04                	jae    801e27 <__udivdi3+0xf7>
  801e23:	39 d6                	cmp    %edx,%esi
  801e25:	74 09                	je     801e30 <__udivdi3+0x100>
  801e27:	89 d8                	mov    %ebx,%eax
  801e29:	31 ff                	xor    %edi,%edi
  801e2b:	e9 40 ff ff ff       	jmp    801d70 <__udivdi3+0x40>
  801e30:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e33:	31 ff                	xor    %edi,%edi
  801e35:	e9 36 ff ff ff       	jmp    801d70 <__udivdi3+0x40>
  801e3a:	66 90                	xchg   %ax,%ax
  801e3c:	66 90                	xchg   %ax,%ax
  801e3e:	66 90                	xchg   %ax,%ax

00801e40 <__umoddi3>:
  801e40:	f3 0f 1e fb          	endbr32 
  801e44:	55                   	push   %ebp
  801e45:	57                   	push   %edi
  801e46:	56                   	push   %esi
  801e47:	53                   	push   %ebx
  801e48:	83 ec 1c             	sub    $0x1c,%esp
  801e4b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e4f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801e53:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801e57:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e5b:	85 c0                	test   %eax,%eax
  801e5d:	75 19                	jne    801e78 <__umoddi3+0x38>
  801e5f:	39 df                	cmp    %ebx,%edi
  801e61:	76 5d                	jbe    801ec0 <__umoddi3+0x80>
  801e63:	89 f0                	mov    %esi,%eax
  801e65:	89 da                	mov    %ebx,%edx
  801e67:	f7 f7                	div    %edi
  801e69:	89 d0                	mov    %edx,%eax
  801e6b:	31 d2                	xor    %edx,%edx
  801e6d:	83 c4 1c             	add    $0x1c,%esp
  801e70:	5b                   	pop    %ebx
  801e71:	5e                   	pop    %esi
  801e72:	5f                   	pop    %edi
  801e73:	5d                   	pop    %ebp
  801e74:	c3                   	ret    
  801e75:	8d 76 00             	lea    0x0(%esi),%esi
  801e78:	89 f2                	mov    %esi,%edx
  801e7a:	39 d8                	cmp    %ebx,%eax
  801e7c:	76 12                	jbe    801e90 <__umoddi3+0x50>
  801e7e:	89 f0                	mov    %esi,%eax
  801e80:	89 da                	mov    %ebx,%edx
  801e82:	83 c4 1c             	add    $0x1c,%esp
  801e85:	5b                   	pop    %ebx
  801e86:	5e                   	pop    %esi
  801e87:	5f                   	pop    %edi
  801e88:	5d                   	pop    %ebp
  801e89:	c3                   	ret    
  801e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801e90:	0f bd e8             	bsr    %eax,%ebp
  801e93:	83 f5 1f             	xor    $0x1f,%ebp
  801e96:	75 50                	jne    801ee8 <__umoddi3+0xa8>
  801e98:	39 d8                	cmp    %ebx,%eax
  801e9a:	0f 82 e0 00 00 00    	jb     801f80 <__umoddi3+0x140>
  801ea0:	89 d9                	mov    %ebx,%ecx
  801ea2:	39 f7                	cmp    %esi,%edi
  801ea4:	0f 86 d6 00 00 00    	jbe    801f80 <__umoddi3+0x140>
  801eaa:	89 d0                	mov    %edx,%eax
  801eac:	89 ca                	mov    %ecx,%edx
  801eae:	83 c4 1c             	add    $0x1c,%esp
  801eb1:	5b                   	pop    %ebx
  801eb2:	5e                   	pop    %esi
  801eb3:	5f                   	pop    %edi
  801eb4:	5d                   	pop    %ebp
  801eb5:	c3                   	ret    
  801eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ebd:	8d 76 00             	lea    0x0(%esi),%esi
  801ec0:	89 fd                	mov    %edi,%ebp
  801ec2:	85 ff                	test   %edi,%edi
  801ec4:	75 0b                	jne    801ed1 <__umoddi3+0x91>
  801ec6:	b8 01 00 00 00       	mov    $0x1,%eax
  801ecb:	31 d2                	xor    %edx,%edx
  801ecd:	f7 f7                	div    %edi
  801ecf:	89 c5                	mov    %eax,%ebp
  801ed1:	89 d8                	mov    %ebx,%eax
  801ed3:	31 d2                	xor    %edx,%edx
  801ed5:	f7 f5                	div    %ebp
  801ed7:	89 f0                	mov    %esi,%eax
  801ed9:	f7 f5                	div    %ebp
  801edb:	89 d0                	mov    %edx,%eax
  801edd:	31 d2                	xor    %edx,%edx
  801edf:	eb 8c                	jmp    801e6d <__umoddi3+0x2d>
  801ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ee8:	89 e9                	mov    %ebp,%ecx
  801eea:	ba 20 00 00 00       	mov    $0x20,%edx
  801eef:	29 ea                	sub    %ebp,%edx
  801ef1:	d3 e0                	shl    %cl,%eax
  801ef3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ef7:	89 d1                	mov    %edx,%ecx
  801ef9:	89 f8                	mov    %edi,%eax
  801efb:	d3 e8                	shr    %cl,%eax
  801efd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801f01:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f05:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f09:	09 c1                	or     %eax,%ecx
  801f0b:	89 d8                	mov    %ebx,%eax
  801f0d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f11:	89 e9                	mov    %ebp,%ecx
  801f13:	d3 e7                	shl    %cl,%edi
  801f15:	89 d1                	mov    %edx,%ecx
  801f17:	d3 e8                	shr    %cl,%eax
  801f19:	89 e9                	mov    %ebp,%ecx
  801f1b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801f1f:	d3 e3                	shl    %cl,%ebx
  801f21:	89 c7                	mov    %eax,%edi
  801f23:	89 d1                	mov    %edx,%ecx
  801f25:	89 f0                	mov    %esi,%eax
  801f27:	d3 e8                	shr    %cl,%eax
  801f29:	89 e9                	mov    %ebp,%ecx
  801f2b:	89 fa                	mov    %edi,%edx
  801f2d:	d3 e6                	shl    %cl,%esi
  801f2f:	09 d8                	or     %ebx,%eax
  801f31:	f7 74 24 08          	divl   0x8(%esp)
  801f35:	89 d1                	mov    %edx,%ecx
  801f37:	89 f3                	mov    %esi,%ebx
  801f39:	f7 64 24 0c          	mull   0xc(%esp)
  801f3d:	89 c6                	mov    %eax,%esi
  801f3f:	89 d7                	mov    %edx,%edi
  801f41:	39 d1                	cmp    %edx,%ecx
  801f43:	72 06                	jb     801f4b <__umoddi3+0x10b>
  801f45:	75 10                	jne    801f57 <__umoddi3+0x117>
  801f47:	39 c3                	cmp    %eax,%ebx
  801f49:	73 0c                	jae    801f57 <__umoddi3+0x117>
  801f4b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  801f4f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801f53:	89 d7                	mov    %edx,%edi
  801f55:	89 c6                	mov    %eax,%esi
  801f57:	89 ca                	mov    %ecx,%edx
  801f59:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801f5e:	29 f3                	sub    %esi,%ebx
  801f60:	19 fa                	sbb    %edi,%edx
  801f62:	89 d0                	mov    %edx,%eax
  801f64:	d3 e0                	shl    %cl,%eax
  801f66:	89 e9                	mov    %ebp,%ecx
  801f68:	d3 eb                	shr    %cl,%ebx
  801f6a:	d3 ea                	shr    %cl,%edx
  801f6c:	09 d8                	or     %ebx,%eax
  801f6e:	83 c4 1c             	add    $0x1c,%esp
  801f71:	5b                   	pop    %ebx
  801f72:	5e                   	pop    %esi
  801f73:	5f                   	pop    %edi
  801f74:	5d                   	pop    %ebp
  801f75:	c3                   	ret    
  801f76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f7d:	8d 76 00             	lea    0x0(%esi),%esi
  801f80:	29 fe                	sub    %edi,%esi
  801f82:	19 c3                	sbb    %eax,%ebx
  801f84:	89 f2                	mov    %esi,%edx
  801f86:	89 d9                	mov    %ebx,%ecx
  801f88:	e9 1d ff ff ff       	jmp    801eaa <__umoddi3+0x6a>
