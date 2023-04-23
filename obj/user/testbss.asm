
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
  80003d:	68 00 25 80 00       	push   $0x802500
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
  800094:	68 48 25 80 00       	push   $0x802548
  800099:	e8 91 01 00 00       	call   80022f <cprintf>
	bigarray[ARRAYSIZE+1024] = 0;
  80009e:	c7 05 20 50 c0 00 00 	movl   $0x0,0xc05020
  8000a5:	00 00 00 
	panic("SHOULD HAVE TRAPPED!!!");
  8000a8:	83 c4 0c             	add    $0xc,%esp
  8000ab:	68 a7 25 80 00       	push   $0x8025a7
  8000b0:	6a 1a                	push   $0x1a
  8000b2:	68 98 25 80 00       	push   $0x802598
  8000b7:	e8 8c 00 00 00       	call   800148 <_panic>
			panic("bigarray[%d] isn't cleared!\n", i);
  8000bc:	50                   	push   %eax
  8000bd:	68 7b 25 80 00       	push   $0x80257b
  8000c2:	6a 11                	push   $0x11
  8000c4:	68 98 25 80 00       	push   $0x802598
  8000c9:	e8 7a 00 00 00       	call   800148 <_panic>
			panic("bigarray[%d] didn't hold its value!\n", i);
  8000ce:	50                   	push   %eax
  8000cf:	68 20 25 80 00       	push   $0x802520
  8000d4:	6a 16                	push   $0x16
  8000d6:	68 98 25 80 00       	push   $0x802598
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
  800134:	e8 f6 0f 00 00       	call   80112f <close_all>
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
  80016a:	68 c8 25 80 00       	push   $0x8025c8
  80016f:	e8 bb 00 00 00       	call   80022f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800174:	83 c4 18             	add    $0x18,%esp
  800177:	53                   	push   %ebx
  800178:	ff 75 10             	pushl  0x10(%ebp)
  80017b:	e8 5a 00 00 00       	call   8001da <vcprintf>
	cprintf("\n");
  800180:	c7 04 24 96 25 80 00 	movl   $0x802596,(%esp)
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
  800295:	e8 06 20 00 00       	call   8022a0 <__udivdi3>
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
  8002d3:	e8 d8 20 00 00       	call   8023b0 <__umoddi3>
  8002d8:	83 c4 14             	add    $0x14,%esp
  8002db:	0f be 80 eb 25 80 00 	movsbl 0x8025eb(%eax),%eax
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
  800382:	3e ff 24 85 20 27 80 	notrack jmp *0x802720(,%eax,4)
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
  80044f:	8b 14 85 80 28 80 00 	mov    0x802880(,%eax,4),%edx
  800456:	85 d2                	test   %edx,%edx
  800458:	74 18                	je     800472 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80045a:	52                   	push   %edx
  80045b:	68 b5 29 80 00       	push   $0x8029b5
  800460:	53                   	push   %ebx
  800461:	56                   	push   %esi
  800462:	e8 aa fe ff ff       	call   800311 <printfmt>
  800467:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80046a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80046d:	e9 66 02 00 00       	jmp    8006d8 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800472:	50                   	push   %eax
  800473:	68 03 26 80 00       	push   $0x802603
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
  80049a:	b8 fc 25 80 00       	mov    $0x8025fc,%eax
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
  800c24:	68 df 28 80 00       	push   $0x8028df
  800c29:	6a 23                	push   $0x23
  800c2b:	68 fc 28 80 00       	push   $0x8028fc
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
  800cb1:	68 df 28 80 00       	push   $0x8028df
  800cb6:	6a 23                	push   $0x23
  800cb8:	68 fc 28 80 00       	push   $0x8028fc
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
  800cf7:	68 df 28 80 00       	push   $0x8028df
  800cfc:	6a 23                	push   $0x23
  800cfe:	68 fc 28 80 00       	push   $0x8028fc
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
  800d3d:	68 df 28 80 00       	push   $0x8028df
  800d42:	6a 23                	push   $0x23
  800d44:	68 fc 28 80 00       	push   $0x8028fc
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
  800d83:	68 df 28 80 00       	push   $0x8028df
  800d88:	6a 23                	push   $0x23
  800d8a:	68 fc 28 80 00       	push   $0x8028fc
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
  800dc9:	68 df 28 80 00       	push   $0x8028df
  800dce:	6a 23                	push   $0x23
  800dd0:	68 fc 28 80 00       	push   $0x8028fc
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
  800e0f:	68 df 28 80 00       	push   $0x8028df
  800e14:	6a 23                	push   $0x23
  800e16:	68 fc 28 80 00       	push   $0x8028fc
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
  800e7b:	68 df 28 80 00       	push   $0x8028df
  800e80:	6a 23                	push   $0x23
  800e82:	68 fc 28 80 00       	push   $0x8028fc
  800e87:	e8 bc f2 ff ff       	call   800148 <_panic>

00800e8c <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e8c:	f3 0f 1e fb          	endbr32 
  800e90:	55                   	push   %ebp
  800e91:	89 e5                	mov    %esp,%ebp
  800e93:	57                   	push   %edi
  800e94:	56                   	push   %esi
  800e95:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e96:	ba 00 00 00 00       	mov    $0x0,%edx
  800e9b:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ea0:	89 d1                	mov    %edx,%ecx
  800ea2:	89 d3                	mov    %edx,%ebx
  800ea4:	89 d7                	mov    %edx,%edi
  800ea6:	89 d6                	mov    %edx,%esi
  800ea8:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800eaa:	5b                   	pop    %ebx
  800eab:	5e                   	pop    %esi
  800eac:	5f                   	pop    %edi
  800ead:	5d                   	pop    %ebp
  800eae:	c3                   	ret    

00800eaf <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  800eaf:	f3 0f 1e fb          	endbr32 
  800eb3:	55                   	push   %ebp
  800eb4:	89 e5                	mov    %esp,%ebp
  800eb6:	57                   	push   %edi
  800eb7:	56                   	push   %esi
  800eb8:	53                   	push   %ebx
  800eb9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ebc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec7:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ecc:	89 df                	mov    %ebx,%edi
  800ece:	89 de                	mov    %ebx,%esi
  800ed0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ed2:	85 c0                	test   %eax,%eax
  800ed4:	7f 08                	jg     800ede <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  800ed6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed9:	5b                   	pop    %ebx
  800eda:	5e                   	pop    %esi
  800edb:	5f                   	pop    %edi
  800edc:	5d                   	pop    %ebp
  800edd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ede:	83 ec 0c             	sub    $0xc,%esp
  800ee1:	50                   	push   %eax
  800ee2:	6a 0f                	push   $0xf
  800ee4:	68 df 28 80 00       	push   $0x8028df
  800ee9:	6a 23                	push   $0x23
  800eeb:	68 fc 28 80 00       	push   $0x8028fc
  800ef0:	e8 53 f2 ff ff       	call   800148 <_panic>

00800ef5 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  800ef5:	f3 0f 1e fb          	endbr32 
  800ef9:	55                   	push   %ebp
  800efa:	89 e5                	mov    %esp,%ebp
  800efc:	57                   	push   %edi
  800efd:	56                   	push   %esi
  800efe:	53                   	push   %ebx
  800eff:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f02:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f07:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f0d:	b8 10 00 00 00       	mov    $0x10,%eax
  800f12:	89 df                	mov    %ebx,%edi
  800f14:	89 de                	mov    %ebx,%esi
  800f16:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f18:	85 c0                	test   %eax,%eax
  800f1a:	7f 08                	jg     800f24 <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  800f1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f1f:	5b                   	pop    %ebx
  800f20:	5e                   	pop    %esi
  800f21:	5f                   	pop    %edi
  800f22:	5d                   	pop    %ebp
  800f23:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f24:	83 ec 0c             	sub    $0xc,%esp
  800f27:	50                   	push   %eax
  800f28:	6a 10                	push   $0x10
  800f2a:	68 df 28 80 00       	push   $0x8028df
  800f2f:	6a 23                	push   $0x23
  800f31:	68 fc 28 80 00       	push   $0x8028fc
  800f36:	e8 0d f2 ff ff       	call   800148 <_panic>

00800f3b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f3b:	f3 0f 1e fb          	endbr32 
  800f3f:	55                   	push   %ebp
  800f40:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f42:	8b 45 08             	mov    0x8(%ebp),%eax
  800f45:	05 00 00 00 30       	add    $0x30000000,%eax
  800f4a:	c1 e8 0c             	shr    $0xc,%eax
}
  800f4d:	5d                   	pop    %ebp
  800f4e:	c3                   	ret    

00800f4f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f4f:	f3 0f 1e fb          	endbr32 
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800f5e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f63:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f68:	5d                   	pop    %ebp
  800f69:	c3                   	ret    

00800f6a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f6a:	f3 0f 1e fb          	endbr32 
  800f6e:	55                   	push   %ebp
  800f6f:	89 e5                	mov    %esp,%ebp
  800f71:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f76:	89 c2                	mov    %eax,%edx
  800f78:	c1 ea 16             	shr    $0x16,%edx
  800f7b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f82:	f6 c2 01             	test   $0x1,%dl
  800f85:	74 2d                	je     800fb4 <fd_alloc+0x4a>
  800f87:	89 c2                	mov    %eax,%edx
  800f89:	c1 ea 0c             	shr    $0xc,%edx
  800f8c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f93:	f6 c2 01             	test   $0x1,%dl
  800f96:	74 1c                	je     800fb4 <fd_alloc+0x4a>
  800f98:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f9d:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800fa2:	75 d2                	jne    800f76 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800fad:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800fb2:	eb 0a                	jmp    800fbe <fd_alloc+0x54>
			*fd_store = fd;
  800fb4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fb7:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fbe:	5d                   	pop    %ebp
  800fbf:	c3                   	ret    

00800fc0 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800fc0:	f3 0f 1e fb          	endbr32 
  800fc4:	55                   	push   %ebp
  800fc5:	89 e5                	mov    %esp,%ebp
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800fca:	83 f8 1f             	cmp    $0x1f,%eax
  800fcd:	77 30                	ja     800fff <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800fcf:	c1 e0 0c             	shl    $0xc,%eax
  800fd2:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800fd7:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800fdd:	f6 c2 01             	test   $0x1,%dl
  800fe0:	74 24                	je     801006 <fd_lookup+0x46>
  800fe2:	89 c2                	mov    %eax,%edx
  800fe4:	c1 ea 0c             	shr    $0xc,%edx
  800fe7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fee:	f6 c2 01             	test   $0x1,%dl
  800ff1:	74 1a                	je     80100d <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800ff3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ff6:	89 02                	mov    %eax,(%edx)
	return 0;
  800ff8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ffd:	5d                   	pop    %ebp
  800ffe:	c3                   	ret    
		return -E_INVAL;
  800fff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801004:	eb f7                	jmp    800ffd <fd_lookup+0x3d>
		return -E_INVAL;
  801006:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80100b:	eb f0                	jmp    800ffd <fd_lookup+0x3d>
  80100d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801012:	eb e9                	jmp    800ffd <fd_lookup+0x3d>

00801014 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801014:	f3 0f 1e fb          	endbr32 
  801018:	55                   	push   %ebp
  801019:	89 e5                	mov    %esp,%ebp
  80101b:	83 ec 08             	sub    $0x8,%esp
  80101e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801021:	ba 00 00 00 00       	mov    $0x0,%edx
  801026:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80102b:	39 08                	cmp    %ecx,(%eax)
  80102d:	74 38                	je     801067 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  80102f:	83 c2 01             	add    $0x1,%edx
  801032:	8b 04 95 88 29 80 00 	mov    0x802988(,%edx,4),%eax
  801039:	85 c0                	test   %eax,%eax
  80103b:	75 ee                	jne    80102b <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80103d:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801042:	8b 40 48             	mov    0x48(%eax),%eax
  801045:	83 ec 04             	sub    $0x4,%esp
  801048:	51                   	push   %ecx
  801049:	50                   	push   %eax
  80104a:	68 0c 29 80 00       	push   $0x80290c
  80104f:	e8 db f1 ff ff       	call   80022f <cprintf>
	*dev = 0;
  801054:	8b 45 0c             	mov    0xc(%ebp),%eax
  801057:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80105d:	83 c4 10             	add    $0x10,%esp
  801060:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801065:	c9                   	leave  
  801066:	c3                   	ret    
			*dev = devtab[i];
  801067:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80106a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80106c:	b8 00 00 00 00       	mov    $0x0,%eax
  801071:	eb f2                	jmp    801065 <dev_lookup+0x51>

00801073 <fd_close>:
{
  801073:	f3 0f 1e fb          	endbr32 
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
  80107a:	57                   	push   %edi
  80107b:	56                   	push   %esi
  80107c:	53                   	push   %ebx
  80107d:	83 ec 24             	sub    $0x24,%esp
  801080:	8b 75 08             	mov    0x8(%ebp),%esi
  801083:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801086:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801089:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80108a:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801090:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801093:	50                   	push   %eax
  801094:	e8 27 ff ff ff       	call   800fc0 <fd_lookup>
  801099:	89 c3                	mov    %eax,%ebx
  80109b:	83 c4 10             	add    $0x10,%esp
  80109e:	85 c0                	test   %eax,%eax
  8010a0:	78 05                	js     8010a7 <fd_close+0x34>
	    || fd != fd2)
  8010a2:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8010a5:	74 16                	je     8010bd <fd_close+0x4a>
		return (must_exist ? r : 0);
  8010a7:	89 f8                	mov    %edi,%eax
  8010a9:	84 c0                	test   %al,%al
  8010ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8010b0:	0f 44 d8             	cmove  %eax,%ebx
}
  8010b3:	89 d8                	mov    %ebx,%eax
  8010b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010b8:	5b                   	pop    %ebx
  8010b9:	5e                   	pop    %esi
  8010ba:	5f                   	pop    %edi
  8010bb:	5d                   	pop    %ebp
  8010bc:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8010bd:	83 ec 08             	sub    $0x8,%esp
  8010c0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8010c3:	50                   	push   %eax
  8010c4:	ff 36                	pushl  (%esi)
  8010c6:	e8 49 ff ff ff       	call   801014 <dev_lookup>
  8010cb:	89 c3                	mov    %eax,%ebx
  8010cd:	83 c4 10             	add    $0x10,%esp
  8010d0:	85 c0                	test   %eax,%eax
  8010d2:	78 1a                	js     8010ee <fd_close+0x7b>
		if (dev->dev_close)
  8010d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010d7:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8010da:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8010df:	85 c0                	test   %eax,%eax
  8010e1:	74 0b                	je     8010ee <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8010e3:	83 ec 0c             	sub    $0xc,%esp
  8010e6:	56                   	push   %esi
  8010e7:	ff d0                	call   *%eax
  8010e9:	89 c3                	mov    %eax,%ebx
  8010eb:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8010ee:	83 ec 08             	sub    $0x8,%esp
  8010f1:	56                   	push   %esi
  8010f2:	6a 00                	push   $0x0
  8010f4:	e8 0f fc ff ff       	call   800d08 <sys_page_unmap>
	return r;
  8010f9:	83 c4 10             	add    $0x10,%esp
  8010fc:	eb b5                	jmp    8010b3 <fd_close+0x40>

008010fe <close>:

int
close(int fdnum)
{
  8010fe:	f3 0f 1e fb          	endbr32 
  801102:	55                   	push   %ebp
  801103:	89 e5                	mov    %esp,%ebp
  801105:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801108:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80110b:	50                   	push   %eax
  80110c:	ff 75 08             	pushl  0x8(%ebp)
  80110f:	e8 ac fe ff ff       	call   800fc0 <fd_lookup>
  801114:	83 c4 10             	add    $0x10,%esp
  801117:	85 c0                	test   %eax,%eax
  801119:	79 02                	jns    80111d <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80111b:	c9                   	leave  
  80111c:	c3                   	ret    
		return fd_close(fd, 1);
  80111d:	83 ec 08             	sub    $0x8,%esp
  801120:	6a 01                	push   $0x1
  801122:	ff 75 f4             	pushl  -0xc(%ebp)
  801125:	e8 49 ff ff ff       	call   801073 <fd_close>
  80112a:	83 c4 10             	add    $0x10,%esp
  80112d:	eb ec                	jmp    80111b <close+0x1d>

0080112f <close_all>:

void
close_all(void)
{
  80112f:	f3 0f 1e fb          	endbr32 
  801133:	55                   	push   %ebp
  801134:	89 e5                	mov    %esp,%ebp
  801136:	53                   	push   %ebx
  801137:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80113a:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80113f:	83 ec 0c             	sub    $0xc,%esp
  801142:	53                   	push   %ebx
  801143:	e8 b6 ff ff ff       	call   8010fe <close>
	for (i = 0; i < MAXFD; i++)
  801148:	83 c3 01             	add    $0x1,%ebx
  80114b:	83 c4 10             	add    $0x10,%esp
  80114e:	83 fb 20             	cmp    $0x20,%ebx
  801151:	75 ec                	jne    80113f <close_all+0x10>
}
  801153:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801156:	c9                   	leave  
  801157:	c3                   	ret    

00801158 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801158:	f3 0f 1e fb          	endbr32 
  80115c:	55                   	push   %ebp
  80115d:	89 e5                	mov    %esp,%ebp
  80115f:	57                   	push   %edi
  801160:	56                   	push   %esi
  801161:	53                   	push   %ebx
  801162:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801165:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801168:	50                   	push   %eax
  801169:	ff 75 08             	pushl  0x8(%ebp)
  80116c:	e8 4f fe ff ff       	call   800fc0 <fd_lookup>
  801171:	89 c3                	mov    %eax,%ebx
  801173:	83 c4 10             	add    $0x10,%esp
  801176:	85 c0                	test   %eax,%eax
  801178:	0f 88 81 00 00 00    	js     8011ff <dup+0xa7>
		return r;
	close(newfdnum);
  80117e:	83 ec 0c             	sub    $0xc,%esp
  801181:	ff 75 0c             	pushl  0xc(%ebp)
  801184:	e8 75 ff ff ff       	call   8010fe <close>

	newfd = INDEX2FD(newfdnum);
  801189:	8b 75 0c             	mov    0xc(%ebp),%esi
  80118c:	c1 e6 0c             	shl    $0xc,%esi
  80118f:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801195:	83 c4 04             	add    $0x4,%esp
  801198:	ff 75 e4             	pushl  -0x1c(%ebp)
  80119b:	e8 af fd ff ff       	call   800f4f <fd2data>
  8011a0:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8011a2:	89 34 24             	mov    %esi,(%esp)
  8011a5:	e8 a5 fd ff ff       	call   800f4f <fd2data>
  8011aa:	83 c4 10             	add    $0x10,%esp
  8011ad:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8011af:	89 d8                	mov    %ebx,%eax
  8011b1:	c1 e8 16             	shr    $0x16,%eax
  8011b4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011bb:	a8 01                	test   $0x1,%al
  8011bd:	74 11                	je     8011d0 <dup+0x78>
  8011bf:	89 d8                	mov    %ebx,%eax
  8011c1:	c1 e8 0c             	shr    $0xc,%eax
  8011c4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011cb:	f6 c2 01             	test   $0x1,%dl
  8011ce:	75 39                	jne    801209 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8011d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011d3:	89 d0                	mov    %edx,%eax
  8011d5:	c1 e8 0c             	shr    $0xc,%eax
  8011d8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011df:	83 ec 0c             	sub    $0xc,%esp
  8011e2:	25 07 0e 00 00       	and    $0xe07,%eax
  8011e7:	50                   	push   %eax
  8011e8:	56                   	push   %esi
  8011e9:	6a 00                	push   $0x0
  8011eb:	52                   	push   %edx
  8011ec:	6a 00                	push   $0x0
  8011ee:	e8 cf fa ff ff       	call   800cc2 <sys_page_map>
  8011f3:	89 c3                	mov    %eax,%ebx
  8011f5:	83 c4 20             	add    $0x20,%esp
  8011f8:	85 c0                	test   %eax,%eax
  8011fa:	78 31                	js     80122d <dup+0xd5>
		goto err;

	return newfdnum;
  8011fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8011ff:	89 d8                	mov    %ebx,%eax
  801201:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801204:	5b                   	pop    %ebx
  801205:	5e                   	pop    %esi
  801206:	5f                   	pop    %edi
  801207:	5d                   	pop    %ebp
  801208:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801209:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801210:	83 ec 0c             	sub    $0xc,%esp
  801213:	25 07 0e 00 00       	and    $0xe07,%eax
  801218:	50                   	push   %eax
  801219:	57                   	push   %edi
  80121a:	6a 00                	push   $0x0
  80121c:	53                   	push   %ebx
  80121d:	6a 00                	push   $0x0
  80121f:	e8 9e fa ff ff       	call   800cc2 <sys_page_map>
  801224:	89 c3                	mov    %eax,%ebx
  801226:	83 c4 20             	add    $0x20,%esp
  801229:	85 c0                	test   %eax,%eax
  80122b:	79 a3                	jns    8011d0 <dup+0x78>
	sys_page_unmap(0, newfd);
  80122d:	83 ec 08             	sub    $0x8,%esp
  801230:	56                   	push   %esi
  801231:	6a 00                	push   $0x0
  801233:	e8 d0 fa ff ff       	call   800d08 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801238:	83 c4 08             	add    $0x8,%esp
  80123b:	57                   	push   %edi
  80123c:	6a 00                	push   $0x0
  80123e:	e8 c5 fa ff ff       	call   800d08 <sys_page_unmap>
	return r;
  801243:	83 c4 10             	add    $0x10,%esp
  801246:	eb b7                	jmp    8011ff <dup+0xa7>

00801248 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801248:	f3 0f 1e fb          	endbr32 
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
  80124f:	53                   	push   %ebx
  801250:	83 ec 1c             	sub    $0x1c,%esp
  801253:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801256:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801259:	50                   	push   %eax
  80125a:	53                   	push   %ebx
  80125b:	e8 60 fd ff ff       	call   800fc0 <fd_lookup>
  801260:	83 c4 10             	add    $0x10,%esp
  801263:	85 c0                	test   %eax,%eax
  801265:	78 3f                	js     8012a6 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801267:	83 ec 08             	sub    $0x8,%esp
  80126a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80126d:	50                   	push   %eax
  80126e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801271:	ff 30                	pushl  (%eax)
  801273:	e8 9c fd ff ff       	call   801014 <dev_lookup>
  801278:	83 c4 10             	add    $0x10,%esp
  80127b:	85 c0                	test   %eax,%eax
  80127d:	78 27                	js     8012a6 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80127f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801282:	8b 42 08             	mov    0x8(%edx),%eax
  801285:	83 e0 03             	and    $0x3,%eax
  801288:	83 f8 01             	cmp    $0x1,%eax
  80128b:	74 1e                	je     8012ab <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80128d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801290:	8b 40 08             	mov    0x8(%eax),%eax
  801293:	85 c0                	test   %eax,%eax
  801295:	74 35                	je     8012cc <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801297:	83 ec 04             	sub    $0x4,%esp
  80129a:	ff 75 10             	pushl  0x10(%ebp)
  80129d:	ff 75 0c             	pushl  0xc(%ebp)
  8012a0:	52                   	push   %edx
  8012a1:	ff d0                	call   *%eax
  8012a3:	83 c4 10             	add    $0x10,%esp
}
  8012a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012a9:	c9                   	leave  
  8012aa:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8012ab:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8012b0:	8b 40 48             	mov    0x48(%eax),%eax
  8012b3:	83 ec 04             	sub    $0x4,%esp
  8012b6:	53                   	push   %ebx
  8012b7:	50                   	push   %eax
  8012b8:	68 4d 29 80 00       	push   $0x80294d
  8012bd:	e8 6d ef ff ff       	call   80022f <cprintf>
		return -E_INVAL;
  8012c2:	83 c4 10             	add    $0x10,%esp
  8012c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012ca:	eb da                	jmp    8012a6 <read+0x5e>
		return -E_NOT_SUPP;
  8012cc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012d1:	eb d3                	jmp    8012a6 <read+0x5e>

008012d3 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8012d3:	f3 0f 1e fb          	endbr32 
  8012d7:	55                   	push   %ebp
  8012d8:	89 e5                	mov    %esp,%ebp
  8012da:	57                   	push   %edi
  8012db:	56                   	push   %esi
  8012dc:	53                   	push   %ebx
  8012dd:	83 ec 0c             	sub    $0xc,%esp
  8012e0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012e3:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8012e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012eb:	eb 02                	jmp    8012ef <readn+0x1c>
  8012ed:	01 c3                	add    %eax,%ebx
  8012ef:	39 f3                	cmp    %esi,%ebx
  8012f1:	73 21                	jae    801314 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012f3:	83 ec 04             	sub    $0x4,%esp
  8012f6:	89 f0                	mov    %esi,%eax
  8012f8:	29 d8                	sub    %ebx,%eax
  8012fa:	50                   	push   %eax
  8012fb:	89 d8                	mov    %ebx,%eax
  8012fd:	03 45 0c             	add    0xc(%ebp),%eax
  801300:	50                   	push   %eax
  801301:	57                   	push   %edi
  801302:	e8 41 ff ff ff       	call   801248 <read>
		if (m < 0)
  801307:	83 c4 10             	add    $0x10,%esp
  80130a:	85 c0                	test   %eax,%eax
  80130c:	78 04                	js     801312 <readn+0x3f>
			return m;
		if (m == 0)
  80130e:	75 dd                	jne    8012ed <readn+0x1a>
  801310:	eb 02                	jmp    801314 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801312:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801314:	89 d8                	mov    %ebx,%eax
  801316:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801319:	5b                   	pop    %ebx
  80131a:	5e                   	pop    %esi
  80131b:	5f                   	pop    %edi
  80131c:	5d                   	pop    %ebp
  80131d:	c3                   	ret    

0080131e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80131e:	f3 0f 1e fb          	endbr32 
  801322:	55                   	push   %ebp
  801323:	89 e5                	mov    %esp,%ebp
  801325:	53                   	push   %ebx
  801326:	83 ec 1c             	sub    $0x1c,%esp
  801329:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80132c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80132f:	50                   	push   %eax
  801330:	53                   	push   %ebx
  801331:	e8 8a fc ff ff       	call   800fc0 <fd_lookup>
  801336:	83 c4 10             	add    $0x10,%esp
  801339:	85 c0                	test   %eax,%eax
  80133b:	78 3a                	js     801377 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80133d:	83 ec 08             	sub    $0x8,%esp
  801340:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801343:	50                   	push   %eax
  801344:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801347:	ff 30                	pushl  (%eax)
  801349:	e8 c6 fc ff ff       	call   801014 <dev_lookup>
  80134e:	83 c4 10             	add    $0x10,%esp
  801351:	85 c0                	test   %eax,%eax
  801353:	78 22                	js     801377 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801355:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801358:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80135c:	74 1e                	je     80137c <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80135e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801361:	8b 52 0c             	mov    0xc(%edx),%edx
  801364:	85 d2                	test   %edx,%edx
  801366:	74 35                	je     80139d <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801368:	83 ec 04             	sub    $0x4,%esp
  80136b:	ff 75 10             	pushl  0x10(%ebp)
  80136e:	ff 75 0c             	pushl  0xc(%ebp)
  801371:	50                   	push   %eax
  801372:	ff d2                	call   *%edx
  801374:	83 c4 10             	add    $0x10,%esp
}
  801377:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80137a:	c9                   	leave  
  80137b:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80137c:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801381:	8b 40 48             	mov    0x48(%eax),%eax
  801384:	83 ec 04             	sub    $0x4,%esp
  801387:	53                   	push   %ebx
  801388:	50                   	push   %eax
  801389:	68 69 29 80 00       	push   $0x802969
  80138e:	e8 9c ee ff ff       	call   80022f <cprintf>
		return -E_INVAL;
  801393:	83 c4 10             	add    $0x10,%esp
  801396:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80139b:	eb da                	jmp    801377 <write+0x59>
		return -E_NOT_SUPP;
  80139d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013a2:	eb d3                	jmp    801377 <write+0x59>

008013a4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8013a4:	f3 0f 1e fb          	endbr32 
  8013a8:	55                   	push   %ebp
  8013a9:	89 e5                	mov    %esp,%ebp
  8013ab:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013b1:	50                   	push   %eax
  8013b2:	ff 75 08             	pushl  0x8(%ebp)
  8013b5:	e8 06 fc ff ff       	call   800fc0 <fd_lookup>
  8013ba:	83 c4 10             	add    $0x10,%esp
  8013bd:	85 c0                	test   %eax,%eax
  8013bf:	78 0e                	js     8013cf <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8013c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013c7:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8013ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013cf:	c9                   	leave  
  8013d0:	c3                   	ret    

008013d1 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8013d1:	f3 0f 1e fb          	endbr32 
  8013d5:	55                   	push   %ebp
  8013d6:	89 e5                	mov    %esp,%ebp
  8013d8:	53                   	push   %ebx
  8013d9:	83 ec 1c             	sub    $0x1c,%esp
  8013dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013df:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013e2:	50                   	push   %eax
  8013e3:	53                   	push   %ebx
  8013e4:	e8 d7 fb ff ff       	call   800fc0 <fd_lookup>
  8013e9:	83 c4 10             	add    $0x10,%esp
  8013ec:	85 c0                	test   %eax,%eax
  8013ee:	78 37                	js     801427 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013f0:	83 ec 08             	sub    $0x8,%esp
  8013f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013f6:	50                   	push   %eax
  8013f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013fa:	ff 30                	pushl  (%eax)
  8013fc:	e8 13 fc ff ff       	call   801014 <dev_lookup>
  801401:	83 c4 10             	add    $0x10,%esp
  801404:	85 c0                	test   %eax,%eax
  801406:	78 1f                	js     801427 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801408:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80140b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80140f:	74 1b                	je     80142c <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801411:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801414:	8b 52 18             	mov    0x18(%edx),%edx
  801417:	85 d2                	test   %edx,%edx
  801419:	74 32                	je     80144d <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80141b:	83 ec 08             	sub    $0x8,%esp
  80141e:	ff 75 0c             	pushl  0xc(%ebp)
  801421:	50                   	push   %eax
  801422:	ff d2                	call   *%edx
  801424:	83 c4 10             	add    $0x10,%esp
}
  801427:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80142a:	c9                   	leave  
  80142b:	c3                   	ret    
			thisenv->env_id, fdnum);
  80142c:	a1 20 40 c0 00       	mov    0xc04020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801431:	8b 40 48             	mov    0x48(%eax),%eax
  801434:	83 ec 04             	sub    $0x4,%esp
  801437:	53                   	push   %ebx
  801438:	50                   	push   %eax
  801439:	68 2c 29 80 00       	push   $0x80292c
  80143e:	e8 ec ed ff ff       	call   80022f <cprintf>
		return -E_INVAL;
  801443:	83 c4 10             	add    $0x10,%esp
  801446:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80144b:	eb da                	jmp    801427 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80144d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801452:	eb d3                	jmp    801427 <ftruncate+0x56>

00801454 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801454:	f3 0f 1e fb          	endbr32 
  801458:	55                   	push   %ebp
  801459:	89 e5                	mov    %esp,%ebp
  80145b:	53                   	push   %ebx
  80145c:	83 ec 1c             	sub    $0x1c,%esp
  80145f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801462:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801465:	50                   	push   %eax
  801466:	ff 75 08             	pushl  0x8(%ebp)
  801469:	e8 52 fb ff ff       	call   800fc0 <fd_lookup>
  80146e:	83 c4 10             	add    $0x10,%esp
  801471:	85 c0                	test   %eax,%eax
  801473:	78 4b                	js     8014c0 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801475:	83 ec 08             	sub    $0x8,%esp
  801478:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80147b:	50                   	push   %eax
  80147c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80147f:	ff 30                	pushl  (%eax)
  801481:	e8 8e fb ff ff       	call   801014 <dev_lookup>
  801486:	83 c4 10             	add    $0x10,%esp
  801489:	85 c0                	test   %eax,%eax
  80148b:	78 33                	js     8014c0 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80148d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801490:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801494:	74 2f                	je     8014c5 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801496:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801499:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014a0:	00 00 00 
	stat->st_isdir = 0;
  8014a3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014aa:	00 00 00 
	stat->st_dev = dev;
  8014ad:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014b3:	83 ec 08             	sub    $0x8,%esp
  8014b6:	53                   	push   %ebx
  8014b7:	ff 75 f0             	pushl  -0x10(%ebp)
  8014ba:	ff 50 14             	call   *0x14(%eax)
  8014bd:	83 c4 10             	add    $0x10,%esp
}
  8014c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014c3:	c9                   	leave  
  8014c4:	c3                   	ret    
		return -E_NOT_SUPP;
  8014c5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014ca:	eb f4                	jmp    8014c0 <fstat+0x6c>

008014cc <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8014cc:	f3 0f 1e fb          	endbr32 
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
  8014d3:	56                   	push   %esi
  8014d4:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8014d5:	83 ec 08             	sub    $0x8,%esp
  8014d8:	6a 00                	push   $0x0
  8014da:	ff 75 08             	pushl  0x8(%ebp)
  8014dd:	e8 fb 01 00 00       	call   8016dd <open>
  8014e2:	89 c3                	mov    %eax,%ebx
  8014e4:	83 c4 10             	add    $0x10,%esp
  8014e7:	85 c0                	test   %eax,%eax
  8014e9:	78 1b                	js     801506 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8014eb:	83 ec 08             	sub    $0x8,%esp
  8014ee:	ff 75 0c             	pushl  0xc(%ebp)
  8014f1:	50                   	push   %eax
  8014f2:	e8 5d ff ff ff       	call   801454 <fstat>
  8014f7:	89 c6                	mov    %eax,%esi
	close(fd);
  8014f9:	89 1c 24             	mov    %ebx,(%esp)
  8014fc:	e8 fd fb ff ff       	call   8010fe <close>
	return r;
  801501:	83 c4 10             	add    $0x10,%esp
  801504:	89 f3                	mov    %esi,%ebx
}
  801506:	89 d8                	mov    %ebx,%eax
  801508:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80150b:	5b                   	pop    %ebx
  80150c:	5e                   	pop    %esi
  80150d:	5d                   	pop    %ebp
  80150e:	c3                   	ret    

0080150f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80150f:	55                   	push   %ebp
  801510:	89 e5                	mov    %esp,%ebp
  801512:	56                   	push   %esi
  801513:	53                   	push   %ebx
  801514:	89 c6                	mov    %eax,%esi
  801516:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801518:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80151f:	74 27                	je     801548 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801521:	6a 07                	push   $0x7
  801523:	68 00 50 c0 00       	push   $0xc05000
  801528:	56                   	push   %esi
  801529:	ff 35 00 40 80 00    	pushl  0x804000
  80152f:	e8 8e 0c 00 00       	call   8021c2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801534:	83 c4 0c             	add    $0xc,%esp
  801537:	6a 00                	push   $0x0
  801539:	53                   	push   %ebx
  80153a:	6a 00                	push   $0x0
  80153c:	e8 fc 0b 00 00       	call   80213d <ipc_recv>
}
  801541:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801544:	5b                   	pop    %ebx
  801545:	5e                   	pop    %esi
  801546:	5d                   	pop    %ebp
  801547:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801548:	83 ec 0c             	sub    $0xc,%esp
  80154b:	6a 01                	push   $0x1
  80154d:	e8 c8 0c 00 00       	call   80221a <ipc_find_env>
  801552:	a3 00 40 80 00       	mov    %eax,0x804000
  801557:	83 c4 10             	add    $0x10,%esp
  80155a:	eb c5                	jmp    801521 <fsipc+0x12>

0080155c <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80155c:	f3 0f 1e fb          	endbr32 
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
  801563:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801566:	8b 45 08             	mov    0x8(%ebp),%eax
  801569:	8b 40 0c             	mov    0xc(%eax),%eax
  80156c:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.set_size.req_size = newsize;
  801571:	8b 45 0c             	mov    0xc(%ebp),%eax
  801574:	a3 04 50 c0 00       	mov    %eax,0xc05004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801579:	ba 00 00 00 00       	mov    $0x0,%edx
  80157e:	b8 02 00 00 00       	mov    $0x2,%eax
  801583:	e8 87 ff ff ff       	call   80150f <fsipc>
}
  801588:	c9                   	leave  
  801589:	c3                   	ret    

0080158a <devfile_flush>:
{
  80158a:	f3 0f 1e fb          	endbr32 
  80158e:	55                   	push   %ebp
  80158f:	89 e5                	mov    %esp,%ebp
  801591:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801594:	8b 45 08             	mov    0x8(%ebp),%eax
  801597:	8b 40 0c             	mov    0xc(%eax),%eax
  80159a:	a3 00 50 c0 00       	mov    %eax,0xc05000
	return fsipc(FSREQ_FLUSH, NULL);
  80159f:	ba 00 00 00 00       	mov    $0x0,%edx
  8015a4:	b8 06 00 00 00       	mov    $0x6,%eax
  8015a9:	e8 61 ff ff ff       	call   80150f <fsipc>
}
  8015ae:	c9                   	leave  
  8015af:	c3                   	ret    

008015b0 <devfile_stat>:
{
  8015b0:	f3 0f 1e fb          	endbr32 
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
  8015b7:	53                   	push   %ebx
  8015b8:	83 ec 04             	sub    $0x4,%esp
  8015bb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015be:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8015c4:	a3 00 50 c0 00       	mov    %eax,0xc05000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ce:	b8 05 00 00 00       	mov    $0x5,%eax
  8015d3:	e8 37 ff ff ff       	call   80150f <fsipc>
  8015d8:	85 c0                	test   %eax,%eax
  8015da:	78 2c                	js     801608 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8015dc:	83 ec 08             	sub    $0x8,%esp
  8015df:	68 00 50 c0 00       	push   $0xc05000
  8015e4:	53                   	push   %ebx
  8015e5:	e8 4f f2 ff ff       	call   800839 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8015ea:	a1 80 50 c0 00       	mov    0xc05080,%eax
  8015ef:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8015f5:	a1 84 50 c0 00       	mov    0xc05084,%eax
  8015fa:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801600:	83 c4 10             	add    $0x10,%esp
  801603:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801608:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80160b:	c9                   	leave  
  80160c:	c3                   	ret    

0080160d <devfile_write>:
{
  80160d:	f3 0f 1e fb          	endbr32 
  801611:	55                   	push   %ebp
  801612:	89 e5                	mov    %esp,%ebp
  801614:	83 ec 0c             	sub    $0xc,%esp
  801617:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80161a:	8b 55 08             	mov    0x8(%ebp),%edx
  80161d:	8b 52 0c             	mov    0xc(%edx),%edx
  801620:	89 15 00 50 c0 00    	mov    %edx,0xc05000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801626:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80162b:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801630:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  801633:	a3 04 50 c0 00       	mov    %eax,0xc05004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801638:	50                   	push   %eax
  801639:	ff 75 0c             	pushl  0xc(%ebp)
  80163c:	68 08 50 c0 00       	push   $0xc05008
  801641:	e8 a9 f3 ff ff       	call   8009ef <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801646:	ba 00 00 00 00       	mov    $0x0,%edx
  80164b:	b8 04 00 00 00       	mov    $0x4,%eax
  801650:	e8 ba fe ff ff       	call   80150f <fsipc>
}
  801655:	c9                   	leave  
  801656:	c3                   	ret    

00801657 <devfile_read>:
{
  801657:	f3 0f 1e fb          	endbr32 
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
  80165e:	56                   	push   %esi
  80165f:	53                   	push   %ebx
  801660:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801663:	8b 45 08             	mov    0x8(%ebp),%eax
  801666:	8b 40 0c             	mov    0xc(%eax),%eax
  801669:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.read.req_n = n;
  80166e:	89 35 04 50 c0 00    	mov    %esi,0xc05004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801674:	ba 00 00 00 00       	mov    $0x0,%edx
  801679:	b8 03 00 00 00       	mov    $0x3,%eax
  80167e:	e8 8c fe ff ff       	call   80150f <fsipc>
  801683:	89 c3                	mov    %eax,%ebx
  801685:	85 c0                	test   %eax,%eax
  801687:	78 1f                	js     8016a8 <devfile_read+0x51>
	assert(r <= n);
  801689:	39 f0                	cmp    %esi,%eax
  80168b:	77 24                	ja     8016b1 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  80168d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801692:	7f 33                	jg     8016c7 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801694:	83 ec 04             	sub    $0x4,%esp
  801697:	50                   	push   %eax
  801698:	68 00 50 c0 00       	push   $0xc05000
  80169d:	ff 75 0c             	pushl  0xc(%ebp)
  8016a0:	e8 4a f3 ff ff       	call   8009ef <memmove>
	return r;
  8016a5:	83 c4 10             	add    $0x10,%esp
}
  8016a8:	89 d8                	mov    %ebx,%eax
  8016aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016ad:	5b                   	pop    %ebx
  8016ae:	5e                   	pop    %esi
  8016af:	5d                   	pop    %ebp
  8016b0:	c3                   	ret    
	assert(r <= n);
  8016b1:	68 9c 29 80 00       	push   $0x80299c
  8016b6:	68 a3 29 80 00       	push   $0x8029a3
  8016bb:	6a 7c                	push   $0x7c
  8016bd:	68 b8 29 80 00       	push   $0x8029b8
  8016c2:	e8 81 ea ff ff       	call   800148 <_panic>
	assert(r <= PGSIZE);
  8016c7:	68 c3 29 80 00       	push   $0x8029c3
  8016cc:	68 a3 29 80 00       	push   $0x8029a3
  8016d1:	6a 7d                	push   $0x7d
  8016d3:	68 b8 29 80 00       	push   $0x8029b8
  8016d8:	e8 6b ea ff ff       	call   800148 <_panic>

008016dd <open>:
{
  8016dd:	f3 0f 1e fb          	endbr32 
  8016e1:	55                   	push   %ebp
  8016e2:	89 e5                	mov    %esp,%ebp
  8016e4:	56                   	push   %esi
  8016e5:	53                   	push   %ebx
  8016e6:	83 ec 1c             	sub    $0x1c,%esp
  8016e9:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8016ec:	56                   	push   %esi
  8016ed:	e8 04 f1 ff ff       	call   8007f6 <strlen>
  8016f2:	83 c4 10             	add    $0x10,%esp
  8016f5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8016fa:	7f 6c                	jg     801768 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8016fc:	83 ec 0c             	sub    $0xc,%esp
  8016ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801702:	50                   	push   %eax
  801703:	e8 62 f8 ff ff       	call   800f6a <fd_alloc>
  801708:	89 c3                	mov    %eax,%ebx
  80170a:	83 c4 10             	add    $0x10,%esp
  80170d:	85 c0                	test   %eax,%eax
  80170f:	78 3c                	js     80174d <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801711:	83 ec 08             	sub    $0x8,%esp
  801714:	56                   	push   %esi
  801715:	68 00 50 c0 00       	push   $0xc05000
  80171a:	e8 1a f1 ff ff       	call   800839 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80171f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801722:	a3 00 54 c0 00       	mov    %eax,0xc05400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801727:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80172a:	b8 01 00 00 00       	mov    $0x1,%eax
  80172f:	e8 db fd ff ff       	call   80150f <fsipc>
  801734:	89 c3                	mov    %eax,%ebx
  801736:	83 c4 10             	add    $0x10,%esp
  801739:	85 c0                	test   %eax,%eax
  80173b:	78 19                	js     801756 <open+0x79>
	return fd2num(fd);
  80173d:	83 ec 0c             	sub    $0xc,%esp
  801740:	ff 75 f4             	pushl  -0xc(%ebp)
  801743:	e8 f3 f7 ff ff       	call   800f3b <fd2num>
  801748:	89 c3                	mov    %eax,%ebx
  80174a:	83 c4 10             	add    $0x10,%esp
}
  80174d:	89 d8                	mov    %ebx,%eax
  80174f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801752:	5b                   	pop    %ebx
  801753:	5e                   	pop    %esi
  801754:	5d                   	pop    %ebp
  801755:	c3                   	ret    
		fd_close(fd, 0);
  801756:	83 ec 08             	sub    $0x8,%esp
  801759:	6a 00                	push   $0x0
  80175b:	ff 75 f4             	pushl  -0xc(%ebp)
  80175e:	e8 10 f9 ff ff       	call   801073 <fd_close>
		return r;
  801763:	83 c4 10             	add    $0x10,%esp
  801766:	eb e5                	jmp    80174d <open+0x70>
		return -E_BAD_PATH;
  801768:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80176d:	eb de                	jmp    80174d <open+0x70>

0080176f <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80176f:	f3 0f 1e fb          	endbr32 
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801779:	ba 00 00 00 00       	mov    $0x0,%edx
  80177e:	b8 08 00 00 00       	mov    $0x8,%eax
  801783:	e8 87 fd ff ff       	call   80150f <fsipc>
}
  801788:	c9                   	leave  
  801789:	c3                   	ret    

0080178a <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80178a:	f3 0f 1e fb          	endbr32 
  80178e:	55                   	push   %ebp
  80178f:	89 e5                	mov    %esp,%ebp
  801791:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801794:	68 cf 29 80 00       	push   $0x8029cf
  801799:	ff 75 0c             	pushl  0xc(%ebp)
  80179c:	e8 98 f0 ff ff       	call   800839 <strcpy>
	return 0;
}
  8017a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a6:	c9                   	leave  
  8017a7:	c3                   	ret    

008017a8 <devsock_close>:
{
  8017a8:	f3 0f 1e fb          	endbr32 
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
  8017af:	53                   	push   %ebx
  8017b0:	83 ec 10             	sub    $0x10,%esp
  8017b3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8017b6:	53                   	push   %ebx
  8017b7:	e8 9b 0a 00 00       	call   802257 <pageref>
  8017bc:	89 c2                	mov    %eax,%edx
  8017be:	83 c4 10             	add    $0x10,%esp
		return 0;
  8017c1:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  8017c6:	83 fa 01             	cmp    $0x1,%edx
  8017c9:	74 05                	je     8017d0 <devsock_close+0x28>
}
  8017cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ce:	c9                   	leave  
  8017cf:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8017d0:	83 ec 0c             	sub    $0xc,%esp
  8017d3:	ff 73 0c             	pushl  0xc(%ebx)
  8017d6:	e8 e3 02 00 00       	call   801abe <nsipc_close>
  8017db:	83 c4 10             	add    $0x10,%esp
  8017de:	eb eb                	jmp    8017cb <devsock_close+0x23>

008017e0 <devsock_write>:
{
  8017e0:	f3 0f 1e fb          	endbr32 
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
  8017e7:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8017ea:	6a 00                	push   $0x0
  8017ec:	ff 75 10             	pushl  0x10(%ebp)
  8017ef:	ff 75 0c             	pushl  0xc(%ebp)
  8017f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f5:	ff 70 0c             	pushl  0xc(%eax)
  8017f8:	e8 b5 03 00 00       	call   801bb2 <nsipc_send>
}
  8017fd:	c9                   	leave  
  8017fe:	c3                   	ret    

008017ff <devsock_read>:
{
  8017ff:	f3 0f 1e fb          	endbr32 
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
  801806:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801809:	6a 00                	push   $0x0
  80180b:	ff 75 10             	pushl  0x10(%ebp)
  80180e:	ff 75 0c             	pushl  0xc(%ebp)
  801811:	8b 45 08             	mov    0x8(%ebp),%eax
  801814:	ff 70 0c             	pushl  0xc(%eax)
  801817:	e8 1f 03 00 00       	call   801b3b <nsipc_recv>
}
  80181c:	c9                   	leave  
  80181d:	c3                   	ret    

0080181e <fd2sockid>:
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
  801821:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801824:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801827:	52                   	push   %edx
  801828:	50                   	push   %eax
  801829:	e8 92 f7 ff ff       	call   800fc0 <fd_lookup>
  80182e:	83 c4 10             	add    $0x10,%esp
  801831:	85 c0                	test   %eax,%eax
  801833:	78 10                	js     801845 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801835:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801838:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80183e:	39 08                	cmp    %ecx,(%eax)
  801840:	75 05                	jne    801847 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801842:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801845:	c9                   	leave  
  801846:	c3                   	ret    
		return -E_NOT_SUPP;
  801847:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80184c:	eb f7                	jmp    801845 <fd2sockid+0x27>

0080184e <alloc_sockfd>:
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
  801851:	56                   	push   %esi
  801852:	53                   	push   %ebx
  801853:	83 ec 1c             	sub    $0x1c,%esp
  801856:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801858:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80185b:	50                   	push   %eax
  80185c:	e8 09 f7 ff ff       	call   800f6a <fd_alloc>
  801861:	89 c3                	mov    %eax,%ebx
  801863:	83 c4 10             	add    $0x10,%esp
  801866:	85 c0                	test   %eax,%eax
  801868:	78 43                	js     8018ad <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80186a:	83 ec 04             	sub    $0x4,%esp
  80186d:	68 07 04 00 00       	push   $0x407
  801872:	ff 75 f4             	pushl  -0xc(%ebp)
  801875:	6a 00                	push   $0x0
  801877:	e8 ff f3 ff ff       	call   800c7b <sys_page_alloc>
  80187c:	89 c3                	mov    %eax,%ebx
  80187e:	83 c4 10             	add    $0x10,%esp
  801881:	85 c0                	test   %eax,%eax
  801883:	78 28                	js     8018ad <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801888:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80188e:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801893:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80189a:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80189d:	83 ec 0c             	sub    $0xc,%esp
  8018a0:	50                   	push   %eax
  8018a1:	e8 95 f6 ff ff       	call   800f3b <fd2num>
  8018a6:	89 c3                	mov    %eax,%ebx
  8018a8:	83 c4 10             	add    $0x10,%esp
  8018ab:	eb 0c                	jmp    8018b9 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8018ad:	83 ec 0c             	sub    $0xc,%esp
  8018b0:	56                   	push   %esi
  8018b1:	e8 08 02 00 00       	call   801abe <nsipc_close>
		return r;
  8018b6:	83 c4 10             	add    $0x10,%esp
}
  8018b9:	89 d8                	mov    %ebx,%eax
  8018bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018be:	5b                   	pop    %ebx
  8018bf:	5e                   	pop    %esi
  8018c0:	5d                   	pop    %ebp
  8018c1:	c3                   	ret    

008018c2 <accept>:
{
  8018c2:	f3 0f 1e fb          	endbr32 
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
  8018c9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8018cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cf:	e8 4a ff ff ff       	call   80181e <fd2sockid>
  8018d4:	85 c0                	test   %eax,%eax
  8018d6:	78 1b                	js     8018f3 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8018d8:	83 ec 04             	sub    $0x4,%esp
  8018db:	ff 75 10             	pushl  0x10(%ebp)
  8018de:	ff 75 0c             	pushl  0xc(%ebp)
  8018e1:	50                   	push   %eax
  8018e2:	e8 22 01 00 00       	call   801a09 <nsipc_accept>
  8018e7:	83 c4 10             	add    $0x10,%esp
  8018ea:	85 c0                	test   %eax,%eax
  8018ec:	78 05                	js     8018f3 <accept+0x31>
	return alloc_sockfd(r);
  8018ee:	e8 5b ff ff ff       	call   80184e <alloc_sockfd>
}
  8018f3:	c9                   	leave  
  8018f4:	c3                   	ret    

008018f5 <bind>:
{
  8018f5:	f3 0f 1e fb          	endbr32 
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
  8018fc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8018ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801902:	e8 17 ff ff ff       	call   80181e <fd2sockid>
  801907:	85 c0                	test   %eax,%eax
  801909:	78 12                	js     80191d <bind+0x28>
	return nsipc_bind(r, name, namelen);
  80190b:	83 ec 04             	sub    $0x4,%esp
  80190e:	ff 75 10             	pushl  0x10(%ebp)
  801911:	ff 75 0c             	pushl  0xc(%ebp)
  801914:	50                   	push   %eax
  801915:	e8 45 01 00 00       	call   801a5f <nsipc_bind>
  80191a:	83 c4 10             	add    $0x10,%esp
}
  80191d:	c9                   	leave  
  80191e:	c3                   	ret    

0080191f <shutdown>:
{
  80191f:	f3 0f 1e fb          	endbr32 
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
  801926:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801929:	8b 45 08             	mov    0x8(%ebp),%eax
  80192c:	e8 ed fe ff ff       	call   80181e <fd2sockid>
  801931:	85 c0                	test   %eax,%eax
  801933:	78 0f                	js     801944 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801935:	83 ec 08             	sub    $0x8,%esp
  801938:	ff 75 0c             	pushl  0xc(%ebp)
  80193b:	50                   	push   %eax
  80193c:	e8 57 01 00 00       	call   801a98 <nsipc_shutdown>
  801941:	83 c4 10             	add    $0x10,%esp
}
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <connect>:
{
  801946:	f3 0f 1e fb          	endbr32 
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801950:	8b 45 08             	mov    0x8(%ebp),%eax
  801953:	e8 c6 fe ff ff       	call   80181e <fd2sockid>
  801958:	85 c0                	test   %eax,%eax
  80195a:	78 12                	js     80196e <connect+0x28>
	return nsipc_connect(r, name, namelen);
  80195c:	83 ec 04             	sub    $0x4,%esp
  80195f:	ff 75 10             	pushl  0x10(%ebp)
  801962:	ff 75 0c             	pushl  0xc(%ebp)
  801965:	50                   	push   %eax
  801966:	e8 71 01 00 00       	call   801adc <nsipc_connect>
  80196b:	83 c4 10             	add    $0x10,%esp
}
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <listen>:
{
  801970:	f3 0f 1e fb          	endbr32 
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
  801977:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80197a:	8b 45 08             	mov    0x8(%ebp),%eax
  80197d:	e8 9c fe ff ff       	call   80181e <fd2sockid>
  801982:	85 c0                	test   %eax,%eax
  801984:	78 0f                	js     801995 <listen+0x25>
	return nsipc_listen(r, backlog);
  801986:	83 ec 08             	sub    $0x8,%esp
  801989:	ff 75 0c             	pushl  0xc(%ebp)
  80198c:	50                   	push   %eax
  80198d:	e8 83 01 00 00       	call   801b15 <nsipc_listen>
  801992:	83 c4 10             	add    $0x10,%esp
}
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <socket>:

int
socket(int domain, int type, int protocol)
{
  801997:	f3 0f 1e fb          	endbr32 
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
  80199e:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8019a1:	ff 75 10             	pushl  0x10(%ebp)
  8019a4:	ff 75 0c             	pushl  0xc(%ebp)
  8019a7:	ff 75 08             	pushl  0x8(%ebp)
  8019aa:	e8 65 02 00 00       	call   801c14 <nsipc_socket>
  8019af:	83 c4 10             	add    $0x10,%esp
  8019b2:	85 c0                	test   %eax,%eax
  8019b4:	78 05                	js     8019bb <socket+0x24>
		return r;
	return alloc_sockfd(r);
  8019b6:	e8 93 fe ff ff       	call   80184e <alloc_sockfd>
}
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    

008019bd <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
  8019c0:	53                   	push   %ebx
  8019c1:	83 ec 04             	sub    $0x4,%esp
  8019c4:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8019c6:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8019cd:	74 26                	je     8019f5 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8019cf:	6a 07                	push   $0x7
  8019d1:	68 00 60 c0 00       	push   $0xc06000
  8019d6:	53                   	push   %ebx
  8019d7:	ff 35 04 40 80 00    	pushl  0x804004
  8019dd:	e8 e0 07 00 00       	call   8021c2 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8019e2:	83 c4 0c             	add    $0xc,%esp
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	e8 4d 07 00 00       	call   80213d <ipc_recv>
}
  8019f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8019f5:	83 ec 0c             	sub    $0xc,%esp
  8019f8:	6a 02                	push   $0x2
  8019fa:	e8 1b 08 00 00       	call   80221a <ipc_find_env>
  8019ff:	a3 04 40 80 00       	mov    %eax,0x804004
  801a04:	83 c4 10             	add    $0x10,%esp
  801a07:	eb c6                	jmp    8019cf <nsipc+0x12>

00801a09 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a09:	f3 0f 1e fb          	endbr32 
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
  801a10:	56                   	push   %esi
  801a11:	53                   	push   %ebx
  801a12:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a15:	8b 45 08             	mov    0x8(%ebp),%eax
  801a18:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a1d:	8b 06                	mov    (%esi),%eax
  801a1f:	a3 04 60 c0 00       	mov    %eax,0xc06004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a24:	b8 01 00 00 00       	mov    $0x1,%eax
  801a29:	e8 8f ff ff ff       	call   8019bd <nsipc>
  801a2e:	89 c3                	mov    %eax,%ebx
  801a30:	85 c0                	test   %eax,%eax
  801a32:	79 09                	jns    801a3d <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801a34:	89 d8                	mov    %ebx,%eax
  801a36:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a39:	5b                   	pop    %ebx
  801a3a:	5e                   	pop    %esi
  801a3b:	5d                   	pop    %ebp
  801a3c:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801a3d:	83 ec 04             	sub    $0x4,%esp
  801a40:	ff 35 10 60 c0 00    	pushl  0xc06010
  801a46:	68 00 60 c0 00       	push   $0xc06000
  801a4b:	ff 75 0c             	pushl  0xc(%ebp)
  801a4e:	e8 9c ef ff ff       	call   8009ef <memmove>
		*addrlen = ret->ret_addrlen;
  801a53:	a1 10 60 c0 00       	mov    0xc06010,%eax
  801a58:	89 06                	mov    %eax,(%esi)
  801a5a:	83 c4 10             	add    $0x10,%esp
	return r;
  801a5d:	eb d5                	jmp    801a34 <nsipc_accept+0x2b>

00801a5f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801a5f:	f3 0f 1e fb          	endbr32 
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
  801a66:	53                   	push   %ebx
  801a67:	83 ec 08             	sub    $0x8,%esp
  801a6a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a70:	a3 00 60 c0 00       	mov    %eax,0xc06000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801a75:	53                   	push   %ebx
  801a76:	ff 75 0c             	pushl  0xc(%ebp)
  801a79:	68 04 60 c0 00       	push   $0xc06004
  801a7e:	e8 6c ef ff ff       	call   8009ef <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801a83:	89 1d 14 60 c0 00    	mov    %ebx,0xc06014
	return nsipc(NSREQ_BIND);
  801a89:	b8 02 00 00 00       	mov    $0x2,%eax
  801a8e:	e8 2a ff ff ff       	call   8019bd <nsipc>
}
  801a93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a96:	c9                   	leave  
  801a97:	c3                   	ret    

00801a98 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801a98:	f3 0f 1e fb          	endbr32 
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
  801a9f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.shutdown.req_how = how;
  801aaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aad:	a3 04 60 c0 00       	mov    %eax,0xc06004
	return nsipc(NSREQ_SHUTDOWN);
  801ab2:	b8 03 00 00 00       	mov    $0x3,%eax
  801ab7:	e8 01 ff ff ff       	call   8019bd <nsipc>
}
  801abc:	c9                   	leave  
  801abd:	c3                   	ret    

00801abe <nsipc_close>:

int
nsipc_close(int s)
{
  801abe:	f3 0f 1e fb          	endbr32 
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
  801ac5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  801acb:	a3 00 60 c0 00       	mov    %eax,0xc06000
	return nsipc(NSREQ_CLOSE);
  801ad0:	b8 04 00 00 00       	mov    $0x4,%eax
  801ad5:	e8 e3 fe ff ff       	call   8019bd <nsipc>
}
  801ada:	c9                   	leave  
  801adb:	c3                   	ret    

00801adc <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801adc:	f3 0f 1e fb          	endbr32 
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
  801ae3:	53                   	push   %ebx
  801ae4:	83 ec 08             	sub    $0x8,%esp
  801ae7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801aea:	8b 45 08             	mov    0x8(%ebp),%eax
  801aed:	a3 00 60 c0 00       	mov    %eax,0xc06000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801af2:	53                   	push   %ebx
  801af3:	ff 75 0c             	pushl  0xc(%ebp)
  801af6:	68 04 60 c0 00       	push   $0xc06004
  801afb:	e8 ef ee ff ff       	call   8009ef <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b00:	89 1d 14 60 c0 00    	mov    %ebx,0xc06014
	return nsipc(NSREQ_CONNECT);
  801b06:	b8 05 00 00 00       	mov    $0x5,%eax
  801b0b:	e8 ad fe ff ff       	call   8019bd <nsipc>
}
  801b10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b13:	c9                   	leave  
  801b14:	c3                   	ret    

00801b15 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b15:	f3 0f 1e fb          	endbr32 
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
  801b1c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b22:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.listen.req_backlog = backlog;
  801b27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2a:	a3 04 60 c0 00       	mov    %eax,0xc06004
	return nsipc(NSREQ_LISTEN);
  801b2f:	b8 06 00 00 00       	mov    $0x6,%eax
  801b34:	e8 84 fe ff ff       	call   8019bd <nsipc>
}
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801b3b:	f3 0f 1e fb          	endbr32 
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
  801b42:	56                   	push   %esi
  801b43:	53                   	push   %ebx
  801b44:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801b47:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4a:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.recv.req_len = len;
  801b4f:	89 35 04 60 c0 00    	mov    %esi,0xc06004
	nsipcbuf.recv.req_flags = flags;
  801b55:	8b 45 14             	mov    0x14(%ebp),%eax
  801b58:	a3 08 60 c0 00       	mov    %eax,0xc06008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801b5d:	b8 07 00 00 00       	mov    $0x7,%eax
  801b62:	e8 56 fe ff ff       	call   8019bd <nsipc>
  801b67:	89 c3                	mov    %eax,%ebx
  801b69:	85 c0                	test   %eax,%eax
  801b6b:	78 26                	js     801b93 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801b6d:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801b73:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801b78:	0f 4e c6             	cmovle %esi,%eax
  801b7b:	39 c3                	cmp    %eax,%ebx
  801b7d:	7f 1d                	jg     801b9c <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801b7f:	83 ec 04             	sub    $0x4,%esp
  801b82:	53                   	push   %ebx
  801b83:	68 00 60 c0 00       	push   $0xc06000
  801b88:	ff 75 0c             	pushl  0xc(%ebp)
  801b8b:	e8 5f ee ff ff       	call   8009ef <memmove>
  801b90:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801b93:	89 d8                	mov    %ebx,%eax
  801b95:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b98:	5b                   	pop    %ebx
  801b99:	5e                   	pop    %esi
  801b9a:	5d                   	pop    %ebp
  801b9b:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801b9c:	68 db 29 80 00       	push   $0x8029db
  801ba1:	68 a3 29 80 00       	push   $0x8029a3
  801ba6:	6a 62                	push   $0x62
  801ba8:	68 f0 29 80 00       	push   $0x8029f0
  801bad:	e8 96 e5 ff ff       	call   800148 <_panic>

00801bb2 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801bb2:	f3 0f 1e fb          	endbr32 
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
  801bb9:	53                   	push   %ebx
  801bba:	83 ec 04             	sub    $0x4,%esp
  801bbd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc3:	a3 00 60 c0 00       	mov    %eax,0xc06000
	assert(size < 1600);
  801bc8:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801bce:	7f 2e                	jg     801bfe <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801bd0:	83 ec 04             	sub    $0x4,%esp
  801bd3:	53                   	push   %ebx
  801bd4:	ff 75 0c             	pushl  0xc(%ebp)
  801bd7:	68 0c 60 c0 00       	push   $0xc0600c
  801bdc:	e8 0e ee ff ff       	call   8009ef <memmove>
	nsipcbuf.send.req_size = size;
  801be1:	89 1d 04 60 c0 00    	mov    %ebx,0xc06004
	nsipcbuf.send.req_flags = flags;
  801be7:	8b 45 14             	mov    0x14(%ebp),%eax
  801bea:	a3 08 60 c0 00       	mov    %eax,0xc06008
	return nsipc(NSREQ_SEND);
  801bef:	b8 08 00 00 00       	mov    $0x8,%eax
  801bf4:	e8 c4 fd ff ff       	call   8019bd <nsipc>
}
  801bf9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    
	assert(size < 1600);
  801bfe:	68 fc 29 80 00       	push   $0x8029fc
  801c03:	68 a3 29 80 00       	push   $0x8029a3
  801c08:	6a 6d                	push   $0x6d
  801c0a:	68 f0 29 80 00       	push   $0x8029f0
  801c0f:	e8 34 e5 ff ff       	call   800148 <_panic>

00801c14 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c14:	f3 0f 1e fb          	endbr32 
  801c18:	55                   	push   %ebp
  801c19:	89 e5                	mov    %esp,%ebp
  801c1b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c21:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.socket.req_type = type;
  801c26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c29:	a3 04 60 c0 00       	mov    %eax,0xc06004
	nsipcbuf.socket.req_protocol = protocol;
  801c2e:	8b 45 10             	mov    0x10(%ebp),%eax
  801c31:	a3 08 60 c0 00       	mov    %eax,0xc06008
	return nsipc(NSREQ_SOCKET);
  801c36:	b8 09 00 00 00       	mov    $0x9,%eax
  801c3b:	e8 7d fd ff ff       	call   8019bd <nsipc>
}
  801c40:	c9                   	leave  
  801c41:	c3                   	ret    

00801c42 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c42:	f3 0f 1e fb          	endbr32 
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
  801c49:	56                   	push   %esi
  801c4a:	53                   	push   %ebx
  801c4b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c4e:	83 ec 0c             	sub    $0xc,%esp
  801c51:	ff 75 08             	pushl  0x8(%ebp)
  801c54:	e8 f6 f2 ff ff       	call   800f4f <fd2data>
  801c59:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c5b:	83 c4 08             	add    $0x8,%esp
  801c5e:	68 08 2a 80 00       	push   $0x802a08
  801c63:	53                   	push   %ebx
  801c64:	e8 d0 eb ff ff       	call   800839 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c69:	8b 46 04             	mov    0x4(%esi),%eax
  801c6c:	2b 06                	sub    (%esi),%eax
  801c6e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c74:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c7b:	00 00 00 
	stat->st_dev = &devpipe;
  801c7e:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801c85:	30 80 00 
	return 0;
}
  801c88:	b8 00 00 00 00       	mov    $0x0,%eax
  801c8d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c90:	5b                   	pop    %ebx
  801c91:	5e                   	pop    %esi
  801c92:	5d                   	pop    %ebp
  801c93:	c3                   	ret    

00801c94 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c94:	f3 0f 1e fb          	endbr32 
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	53                   	push   %ebx
  801c9c:	83 ec 0c             	sub    $0xc,%esp
  801c9f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ca2:	53                   	push   %ebx
  801ca3:	6a 00                	push   $0x0
  801ca5:	e8 5e f0 ff ff       	call   800d08 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801caa:	89 1c 24             	mov    %ebx,(%esp)
  801cad:	e8 9d f2 ff ff       	call   800f4f <fd2data>
  801cb2:	83 c4 08             	add    $0x8,%esp
  801cb5:	50                   	push   %eax
  801cb6:	6a 00                	push   $0x0
  801cb8:	e8 4b f0 ff ff       	call   800d08 <sys_page_unmap>
}
  801cbd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <_pipeisclosed>:
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
  801cc5:	57                   	push   %edi
  801cc6:	56                   	push   %esi
  801cc7:	53                   	push   %ebx
  801cc8:	83 ec 1c             	sub    $0x1c,%esp
  801ccb:	89 c7                	mov    %eax,%edi
  801ccd:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801ccf:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801cd4:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801cd7:	83 ec 0c             	sub    $0xc,%esp
  801cda:	57                   	push   %edi
  801cdb:	e8 77 05 00 00       	call   802257 <pageref>
  801ce0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ce3:	89 34 24             	mov    %esi,(%esp)
  801ce6:	e8 6c 05 00 00       	call   802257 <pageref>
		nn = thisenv->env_runs;
  801ceb:	8b 15 20 40 c0 00    	mov    0xc04020,%edx
  801cf1:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801cf4:	83 c4 10             	add    $0x10,%esp
  801cf7:	39 cb                	cmp    %ecx,%ebx
  801cf9:	74 1b                	je     801d16 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801cfb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cfe:	75 cf                	jne    801ccf <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d00:	8b 42 58             	mov    0x58(%edx),%eax
  801d03:	6a 01                	push   $0x1
  801d05:	50                   	push   %eax
  801d06:	53                   	push   %ebx
  801d07:	68 0f 2a 80 00       	push   $0x802a0f
  801d0c:	e8 1e e5 ff ff       	call   80022f <cprintf>
  801d11:	83 c4 10             	add    $0x10,%esp
  801d14:	eb b9                	jmp    801ccf <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d16:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d19:	0f 94 c0             	sete   %al
  801d1c:	0f b6 c0             	movzbl %al,%eax
}
  801d1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d22:	5b                   	pop    %ebx
  801d23:	5e                   	pop    %esi
  801d24:	5f                   	pop    %edi
  801d25:	5d                   	pop    %ebp
  801d26:	c3                   	ret    

00801d27 <devpipe_write>:
{
  801d27:	f3 0f 1e fb          	endbr32 
  801d2b:	55                   	push   %ebp
  801d2c:	89 e5                	mov    %esp,%ebp
  801d2e:	57                   	push   %edi
  801d2f:	56                   	push   %esi
  801d30:	53                   	push   %ebx
  801d31:	83 ec 28             	sub    $0x28,%esp
  801d34:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d37:	56                   	push   %esi
  801d38:	e8 12 f2 ff ff       	call   800f4f <fd2data>
  801d3d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d3f:	83 c4 10             	add    $0x10,%esp
  801d42:	bf 00 00 00 00       	mov    $0x0,%edi
  801d47:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d4a:	74 4f                	je     801d9b <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d4c:	8b 43 04             	mov    0x4(%ebx),%eax
  801d4f:	8b 0b                	mov    (%ebx),%ecx
  801d51:	8d 51 20             	lea    0x20(%ecx),%edx
  801d54:	39 d0                	cmp    %edx,%eax
  801d56:	72 14                	jb     801d6c <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801d58:	89 da                	mov    %ebx,%edx
  801d5a:	89 f0                	mov    %esi,%eax
  801d5c:	e8 61 ff ff ff       	call   801cc2 <_pipeisclosed>
  801d61:	85 c0                	test   %eax,%eax
  801d63:	75 3b                	jne    801da0 <devpipe_write+0x79>
			sys_yield();
  801d65:	e8 ee ee ff ff       	call   800c58 <sys_yield>
  801d6a:	eb e0                	jmp    801d4c <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d6f:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d73:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d76:	89 c2                	mov    %eax,%edx
  801d78:	c1 fa 1f             	sar    $0x1f,%edx
  801d7b:	89 d1                	mov    %edx,%ecx
  801d7d:	c1 e9 1b             	shr    $0x1b,%ecx
  801d80:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d83:	83 e2 1f             	and    $0x1f,%edx
  801d86:	29 ca                	sub    %ecx,%edx
  801d88:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d8c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d90:	83 c0 01             	add    $0x1,%eax
  801d93:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d96:	83 c7 01             	add    $0x1,%edi
  801d99:	eb ac                	jmp    801d47 <devpipe_write+0x20>
	return i;
  801d9b:	8b 45 10             	mov    0x10(%ebp),%eax
  801d9e:	eb 05                	jmp    801da5 <devpipe_write+0x7e>
				return 0;
  801da0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801da8:	5b                   	pop    %ebx
  801da9:	5e                   	pop    %esi
  801daa:	5f                   	pop    %edi
  801dab:	5d                   	pop    %ebp
  801dac:	c3                   	ret    

00801dad <devpipe_read>:
{
  801dad:	f3 0f 1e fb          	endbr32 
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
  801db4:	57                   	push   %edi
  801db5:	56                   	push   %esi
  801db6:	53                   	push   %ebx
  801db7:	83 ec 18             	sub    $0x18,%esp
  801dba:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801dbd:	57                   	push   %edi
  801dbe:	e8 8c f1 ff ff       	call   800f4f <fd2data>
  801dc3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dc5:	83 c4 10             	add    $0x10,%esp
  801dc8:	be 00 00 00 00       	mov    $0x0,%esi
  801dcd:	3b 75 10             	cmp    0x10(%ebp),%esi
  801dd0:	75 14                	jne    801de6 <devpipe_read+0x39>
	return i;
  801dd2:	8b 45 10             	mov    0x10(%ebp),%eax
  801dd5:	eb 02                	jmp    801dd9 <devpipe_read+0x2c>
				return i;
  801dd7:	89 f0                	mov    %esi,%eax
}
  801dd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ddc:	5b                   	pop    %ebx
  801ddd:	5e                   	pop    %esi
  801dde:	5f                   	pop    %edi
  801ddf:	5d                   	pop    %ebp
  801de0:	c3                   	ret    
			sys_yield();
  801de1:	e8 72 ee ff ff       	call   800c58 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801de6:	8b 03                	mov    (%ebx),%eax
  801de8:	3b 43 04             	cmp    0x4(%ebx),%eax
  801deb:	75 18                	jne    801e05 <devpipe_read+0x58>
			if (i > 0)
  801ded:	85 f6                	test   %esi,%esi
  801def:	75 e6                	jne    801dd7 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801df1:	89 da                	mov    %ebx,%edx
  801df3:	89 f8                	mov    %edi,%eax
  801df5:	e8 c8 fe ff ff       	call   801cc2 <_pipeisclosed>
  801dfa:	85 c0                	test   %eax,%eax
  801dfc:	74 e3                	je     801de1 <devpipe_read+0x34>
				return 0;
  801dfe:	b8 00 00 00 00       	mov    $0x0,%eax
  801e03:	eb d4                	jmp    801dd9 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e05:	99                   	cltd   
  801e06:	c1 ea 1b             	shr    $0x1b,%edx
  801e09:	01 d0                	add    %edx,%eax
  801e0b:	83 e0 1f             	and    $0x1f,%eax
  801e0e:	29 d0                	sub    %edx,%eax
  801e10:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e18:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e1b:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e1e:	83 c6 01             	add    $0x1,%esi
  801e21:	eb aa                	jmp    801dcd <devpipe_read+0x20>

00801e23 <pipe>:
{
  801e23:	f3 0f 1e fb          	endbr32 
  801e27:	55                   	push   %ebp
  801e28:	89 e5                	mov    %esp,%ebp
  801e2a:	56                   	push   %esi
  801e2b:	53                   	push   %ebx
  801e2c:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e2f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e32:	50                   	push   %eax
  801e33:	e8 32 f1 ff ff       	call   800f6a <fd_alloc>
  801e38:	89 c3                	mov    %eax,%ebx
  801e3a:	83 c4 10             	add    $0x10,%esp
  801e3d:	85 c0                	test   %eax,%eax
  801e3f:	0f 88 23 01 00 00    	js     801f68 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e45:	83 ec 04             	sub    $0x4,%esp
  801e48:	68 07 04 00 00       	push   $0x407
  801e4d:	ff 75 f4             	pushl  -0xc(%ebp)
  801e50:	6a 00                	push   $0x0
  801e52:	e8 24 ee ff ff       	call   800c7b <sys_page_alloc>
  801e57:	89 c3                	mov    %eax,%ebx
  801e59:	83 c4 10             	add    $0x10,%esp
  801e5c:	85 c0                	test   %eax,%eax
  801e5e:	0f 88 04 01 00 00    	js     801f68 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801e64:	83 ec 0c             	sub    $0xc,%esp
  801e67:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e6a:	50                   	push   %eax
  801e6b:	e8 fa f0 ff ff       	call   800f6a <fd_alloc>
  801e70:	89 c3                	mov    %eax,%ebx
  801e72:	83 c4 10             	add    $0x10,%esp
  801e75:	85 c0                	test   %eax,%eax
  801e77:	0f 88 db 00 00 00    	js     801f58 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e7d:	83 ec 04             	sub    $0x4,%esp
  801e80:	68 07 04 00 00       	push   $0x407
  801e85:	ff 75 f0             	pushl  -0x10(%ebp)
  801e88:	6a 00                	push   $0x0
  801e8a:	e8 ec ed ff ff       	call   800c7b <sys_page_alloc>
  801e8f:	89 c3                	mov    %eax,%ebx
  801e91:	83 c4 10             	add    $0x10,%esp
  801e94:	85 c0                	test   %eax,%eax
  801e96:	0f 88 bc 00 00 00    	js     801f58 <pipe+0x135>
	va = fd2data(fd0);
  801e9c:	83 ec 0c             	sub    $0xc,%esp
  801e9f:	ff 75 f4             	pushl  -0xc(%ebp)
  801ea2:	e8 a8 f0 ff ff       	call   800f4f <fd2data>
  801ea7:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ea9:	83 c4 0c             	add    $0xc,%esp
  801eac:	68 07 04 00 00       	push   $0x407
  801eb1:	50                   	push   %eax
  801eb2:	6a 00                	push   $0x0
  801eb4:	e8 c2 ed ff ff       	call   800c7b <sys_page_alloc>
  801eb9:	89 c3                	mov    %eax,%ebx
  801ebb:	83 c4 10             	add    $0x10,%esp
  801ebe:	85 c0                	test   %eax,%eax
  801ec0:	0f 88 82 00 00 00    	js     801f48 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ec6:	83 ec 0c             	sub    $0xc,%esp
  801ec9:	ff 75 f0             	pushl  -0x10(%ebp)
  801ecc:	e8 7e f0 ff ff       	call   800f4f <fd2data>
  801ed1:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ed8:	50                   	push   %eax
  801ed9:	6a 00                	push   $0x0
  801edb:	56                   	push   %esi
  801edc:	6a 00                	push   $0x0
  801ede:	e8 df ed ff ff       	call   800cc2 <sys_page_map>
  801ee3:	89 c3                	mov    %eax,%ebx
  801ee5:	83 c4 20             	add    $0x20,%esp
  801ee8:	85 c0                	test   %eax,%eax
  801eea:	78 4e                	js     801f3a <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801eec:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801ef1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef4:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801ef6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef9:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f00:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f03:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f08:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f0f:	83 ec 0c             	sub    $0xc,%esp
  801f12:	ff 75 f4             	pushl  -0xc(%ebp)
  801f15:	e8 21 f0 ff ff       	call   800f3b <fd2num>
  801f1a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f1d:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f1f:	83 c4 04             	add    $0x4,%esp
  801f22:	ff 75 f0             	pushl  -0x10(%ebp)
  801f25:	e8 11 f0 ff ff       	call   800f3b <fd2num>
  801f2a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f2d:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f30:	83 c4 10             	add    $0x10,%esp
  801f33:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f38:	eb 2e                	jmp    801f68 <pipe+0x145>
	sys_page_unmap(0, va);
  801f3a:	83 ec 08             	sub    $0x8,%esp
  801f3d:	56                   	push   %esi
  801f3e:	6a 00                	push   $0x0
  801f40:	e8 c3 ed ff ff       	call   800d08 <sys_page_unmap>
  801f45:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f48:	83 ec 08             	sub    $0x8,%esp
  801f4b:	ff 75 f0             	pushl  -0x10(%ebp)
  801f4e:	6a 00                	push   $0x0
  801f50:	e8 b3 ed ff ff       	call   800d08 <sys_page_unmap>
  801f55:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f58:	83 ec 08             	sub    $0x8,%esp
  801f5b:	ff 75 f4             	pushl  -0xc(%ebp)
  801f5e:	6a 00                	push   $0x0
  801f60:	e8 a3 ed ff ff       	call   800d08 <sys_page_unmap>
  801f65:	83 c4 10             	add    $0x10,%esp
}
  801f68:	89 d8                	mov    %ebx,%eax
  801f6a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f6d:	5b                   	pop    %ebx
  801f6e:	5e                   	pop    %esi
  801f6f:	5d                   	pop    %ebp
  801f70:	c3                   	ret    

00801f71 <pipeisclosed>:
{
  801f71:	f3 0f 1e fb          	endbr32 
  801f75:	55                   	push   %ebp
  801f76:	89 e5                	mov    %esp,%ebp
  801f78:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f7b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f7e:	50                   	push   %eax
  801f7f:	ff 75 08             	pushl  0x8(%ebp)
  801f82:	e8 39 f0 ff ff       	call   800fc0 <fd_lookup>
  801f87:	83 c4 10             	add    $0x10,%esp
  801f8a:	85 c0                	test   %eax,%eax
  801f8c:	78 18                	js     801fa6 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801f8e:	83 ec 0c             	sub    $0xc,%esp
  801f91:	ff 75 f4             	pushl  -0xc(%ebp)
  801f94:	e8 b6 ef ff ff       	call   800f4f <fd2data>
  801f99:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801f9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9e:	e8 1f fd ff ff       	call   801cc2 <_pipeisclosed>
  801fa3:	83 c4 10             	add    $0x10,%esp
}
  801fa6:	c9                   	leave  
  801fa7:	c3                   	ret    

00801fa8 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801fa8:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801fac:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb1:	c3                   	ret    

00801fb2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801fb2:	f3 0f 1e fb          	endbr32 
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
  801fb9:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801fbc:	68 27 2a 80 00       	push   $0x802a27
  801fc1:	ff 75 0c             	pushl  0xc(%ebp)
  801fc4:	e8 70 e8 ff ff       	call   800839 <strcpy>
	return 0;
}
  801fc9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fce:	c9                   	leave  
  801fcf:	c3                   	ret    

00801fd0 <devcons_write>:
{
  801fd0:	f3 0f 1e fb          	endbr32 
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
  801fd7:	57                   	push   %edi
  801fd8:	56                   	push   %esi
  801fd9:	53                   	push   %ebx
  801fda:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fe0:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fe5:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801feb:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fee:	73 31                	jae    802021 <devcons_write+0x51>
		m = n - tot;
  801ff0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801ff3:	29 f3                	sub    %esi,%ebx
  801ff5:	83 fb 7f             	cmp    $0x7f,%ebx
  801ff8:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801ffd:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802000:	83 ec 04             	sub    $0x4,%esp
  802003:	53                   	push   %ebx
  802004:	89 f0                	mov    %esi,%eax
  802006:	03 45 0c             	add    0xc(%ebp),%eax
  802009:	50                   	push   %eax
  80200a:	57                   	push   %edi
  80200b:	e8 df e9 ff ff       	call   8009ef <memmove>
		sys_cputs(buf, m);
  802010:	83 c4 08             	add    $0x8,%esp
  802013:	53                   	push   %ebx
  802014:	57                   	push   %edi
  802015:	e8 91 eb ff ff       	call   800bab <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80201a:	01 de                	add    %ebx,%esi
  80201c:	83 c4 10             	add    $0x10,%esp
  80201f:	eb ca                	jmp    801feb <devcons_write+0x1b>
}
  802021:	89 f0                	mov    %esi,%eax
  802023:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802026:	5b                   	pop    %ebx
  802027:	5e                   	pop    %esi
  802028:	5f                   	pop    %edi
  802029:	5d                   	pop    %ebp
  80202a:	c3                   	ret    

0080202b <devcons_read>:
{
  80202b:	f3 0f 1e fb          	endbr32 
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
  802032:	83 ec 08             	sub    $0x8,%esp
  802035:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80203a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80203e:	74 21                	je     802061 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802040:	e8 88 eb ff ff       	call   800bcd <sys_cgetc>
  802045:	85 c0                	test   %eax,%eax
  802047:	75 07                	jne    802050 <devcons_read+0x25>
		sys_yield();
  802049:	e8 0a ec ff ff       	call   800c58 <sys_yield>
  80204e:	eb f0                	jmp    802040 <devcons_read+0x15>
	if (c < 0)
  802050:	78 0f                	js     802061 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  802052:	83 f8 04             	cmp    $0x4,%eax
  802055:	74 0c                	je     802063 <devcons_read+0x38>
	*(char*)vbuf = c;
  802057:	8b 55 0c             	mov    0xc(%ebp),%edx
  80205a:	88 02                	mov    %al,(%edx)
	return 1;
  80205c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802061:	c9                   	leave  
  802062:	c3                   	ret    
		return 0;
  802063:	b8 00 00 00 00       	mov    $0x0,%eax
  802068:	eb f7                	jmp    802061 <devcons_read+0x36>

0080206a <cputchar>:
{
  80206a:	f3 0f 1e fb          	endbr32 
  80206e:	55                   	push   %ebp
  80206f:	89 e5                	mov    %esp,%ebp
  802071:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802074:	8b 45 08             	mov    0x8(%ebp),%eax
  802077:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80207a:	6a 01                	push   $0x1
  80207c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80207f:	50                   	push   %eax
  802080:	e8 26 eb ff ff       	call   800bab <sys_cputs>
}
  802085:	83 c4 10             	add    $0x10,%esp
  802088:	c9                   	leave  
  802089:	c3                   	ret    

0080208a <getchar>:
{
  80208a:	f3 0f 1e fb          	endbr32 
  80208e:	55                   	push   %ebp
  80208f:	89 e5                	mov    %esp,%ebp
  802091:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802094:	6a 01                	push   $0x1
  802096:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802099:	50                   	push   %eax
  80209a:	6a 00                	push   $0x0
  80209c:	e8 a7 f1 ff ff       	call   801248 <read>
	if (r < 0)
  8020a1:	83 c4 10             	add    $0x10,%esp
  8020a4:	85 c0                	test   %eax,%eax
  8020a6:	78 06                	js     8020ae <getchar+0x24>
	if (r < 1)
  8020a8:	74 06                	je     8020b0 <getchar+0x26>
	return c;
  8020aa:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020ae:	c9                   	leave  
  8020af:	c3                   	ret    
		return -E_EOF;
  8020b0:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020b5:	eb f7                	jmp    8020ae <getchar+0x24>

008020b7 <iscons>:
{
  8020b7:	f3 0f 1e fb          	endbr32 
  8020bb:	55                   	push   %ebp
  8020bc:	89 e5                	mov    %esp,%ebp
  8020be:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020c4:	50                   	push   %eax
  8020c5:	ff 75 08             	pushl  0x8(%ebp)
  8020c8:	e8 f3 ee ff ff       	call   800fc0 <fd_lookup>
  8020cd:	83 c4 10             	add    $0x10,%esp
  8020d0:	85 c0                	test   %eax,%eax
  8020d2:	78 11                	js     8020e5 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8020d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d7:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020dd:	39 10                	cmp    %edx,(%eax)
  8020df:	0f 94 c0             	sete   %al
  8020e2:	0f b6 c0             	movzbl %al,%eax
}
  8020e5:	c9                   	leave  
  8020e6:	c3                   	ret    

008020e7 <opencons>:
{
  8020e7:	f3 0f 1e fb          	endbr32 
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
  8020ee:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020f4:	50                   	push   %eax
  8020f5:	e8 70 ee ff ff       	call   800f6a <fd_alloc>
  8020fa:	83 c4 10             	add    $0x10,%esp
  8020fd:	85 c0                	test   %eax,%eax
  8020ff:	78 3a                	js     80213b <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802101:	83 ec 04             	sub    $0x4,%esp
  802104:	68 07 04 00 00       	push   $0x407
  802109:	ff 75 f4             	pushl  -0xc(%ebp)
  80210c:	6a 00                	push   $0x0
  80210e:	e8 68 eb ff ff       	call   800c7b <sys_page_alloc>
  802113:	83 c4 10             	add    $0x10,%esp
  802116:	85 c0                	test   %eax,%eax
  802118:	78 21                	js     80213b <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80211a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211d:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802123:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802125:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802128:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80212f:	83 ec 0c             	sub    $0xc,%esp
  802132:	50                   	push   %eax
  802133:	e8 03 ee ff ff       	call   800f3b <fd2num>
  802138:	83 c4 10             	add    $0x10,%esp
}
  80213b:	c9                   	leave  
  80213c:	c3                   	ret    

0080213d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80213d:	f3 0f 1e fb          	endbr32 
  802141:	55                   	push   %ebp
  802142:	89 e5                	mov    %esp,%ebp
  802144:	56                   	push   %esi
  802145:	53                   	push   %ebx
  802146:	8b 75 08             	mov    0x8(%ebp),%esi
  802149:	8b 45 0c             	mov    0xc(%ebp),%eax
  80214c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  80214f:	85 c0                	test   %eax,%eax
  802151:	74 3d                	je     802190 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  802153:	83 ec 0c             	sub    $0xc,%esp
  802156:	50                   	push   %eax
  802157:	e8 eb ec ff ff       	call   800e47 <sys_ipc_recv>
  80215c:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  80215f:	85 f6                	test   %esi,%esi
  802161:	74 0b                	je     80216e <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  802163:	8b 15 20 40 c0 00    	mov    0xc04020,%edx
  802169:	8b 52 74             	mov    0x74(%edx),%edx
  80216c:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  80216e:	85 db                	test   %ebx,%ebx
  802170:	74 0b                	je     80217d <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  802172:	8b 15 20 40 c0 00    	mov    0xc04020,%edx
  802178:	8b 52 78             	mov    0x78(%edx),%edx
  80217b:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  80217d:	85 c0                	test   %eax,%eax
  80217f:	78 21                	js     8021a2 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  802181:	a1 20 40 c0 00       	mov    0xc04020,%eax
  802186:	8b 40 70             	mov    0x70(%eax),%eax
}
  802189:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80218c:	5b                   	pop    %ebx
  80218d:	5e                   	pop    %esi
  80218e:	5d                   	pop    %ebp
  80218f:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  802190:	83 ec 0c             	sub    $0xc,%esp
  802193:	68 00 00 c0 ee       	push   $0xeec00000
  802198:	e8 aa ec ff ff       	call   800e47 <sys_ipc_recv>
  80219d:	83 c4 10             	add    $0x10,%esp
  8021a0:	eb bd                	jmp    80215f <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  8021a2:	85 f6                	test   %esi,%esi
  8021a4:	74 10                	je     8021b6 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  8021a6:	85 db                	test   %ebx,%ebx
  8021a8:	75 df                	jne    802189 <ipc_recv+0x4c>
  8021aa:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8021b1:	00 00 00 
  8021b4:	eb d3                	jmp    802189 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  8021b6:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8021bd:	00 00 00 
  8021c0:	eb e4                	jmp    8021a6 <ipc_recv+0x69>

008021c2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8021c2:	f3 0f 1e fb          	endbr32 
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
  8021c9:	57                   	push   %edi
  8021ca:	56                   	push   %esi
  8021cb:	53                   	push   %ebx
  8021cc:	83 ec 0c             	sub    $0xc,%esp
  8021cf:	8b 7d 08             	mov    0x8(%ebp),%edi
  8021d2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8021d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  8021d8:	85 db                	test   %ebx,%ebx
  8021da:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8021df:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  8021e2:	ff 75 14             	pushl  0x14(%ebp)
  8021e5:	53                   	push   %ebx
  8021e6:	56                   	push   %esi
  8021e7:	57                   	push   %edi
  8021e8:	e8 33 ec ff ff       	call   800e20 <sys_ipc_try_send>
  8021ed:	83 c4 10             	add    $0x10,%esp
  8021f0:	85 c0                	test   %eax,%eax
  8021f2:	79 1e                	jns    802212 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  8021f4:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8021f7:	75 07                	jne    802200 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  8021f9:	e8 5a ea ff ff       	call   800c58 <sys_yield>
  8021fe:	eb e2                	jmp    8021e2 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  802200:	50                   	push   %eax
  802201:	68 33 2a 80 00       	push   $0x802a33
  802206:	6a 59                	push   $0x59
  802208:	68 4e 2a 80 00       	push   $0x802a4e
  80220d:	e8 36 df ff ff       	call   800148 <_panic>
	}
}
  802212:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802215:	5b                   	pop    %ebx
  802216:	5e                   	pop    %esi
  802217:	5f                   	pop    %edi
  802218:	5d                   	pop    %ebp
  802219:	c3                   	ret    

0080221a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80221a:	f3 0f 1e fb          	endbr32 
  80221e:	55                   	push   %ebp
  80221f:	89 e5                	mov    %esp,%ebp
  802221:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802224:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802229:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80222c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802232:	8b 52 50             	mov    0x50(%edx),%edx
  802235:	39 ca                	cmp    %ecx,%edx
  802237:	74 11                	je     80224a <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802239:	83 c0 01             	add    $0x1,%eax
  80223c:	3d 00 04 00 00       	cmp    $0x400,%eax
  802241:	75 e6                	jne    802229 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802243:	b8 00 00 00 00       	mov    $0x0,%eax
  802248:	eb 0b                	jmp    802255 <ipc_find_env+0x3b>
			return envs[i].env_id;
  80224a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80224d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802252:	8b 40 48             	mov    0x48(%eax),%eax
}
  802255:	5d                   	pop    %ebp
  802256:	c3                   	ret    

00802257 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802257:	f3 0f 1e fb          	endbr32 
  80225b:	55                   	push   %ebp
  80225c:	89 e5                	mov    %esp,%ebp
  80225e:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802261:	89 c2                	mov    %eax,%edx
  802263:	c1 ea 16             	shr    $0x16,%edx
  802266:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80226d:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802272:	f6 c1 01             	test   $0x1,%cl
  802275:	74 1c                	je     802293 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802277:	c1 e8 0c             	shr    $0xc,%eax
  80227a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802281:	a8 01                	test   $0x1,%al
  802283:	74 0e                	je     802293 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802285:	c1 e8 0c             	shr    $0xc,%eax
  802288:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80228f:	ef 
  802290:	0f b7 d2             	movzwl %dx,%edx
}
  802293:	89 d0                	mov    %edx,%eax
  802295:	5d                   	pop    %ebp
  802296:	c3                   	ret    
  802297:	66 90                	xchg   %ax,%ax
  802299:	66 90                	xchg   %ax,%ax
  80229b:	66 90                	xchg   %ax,%ax
  80229d:	66 90                	xchg   %ax,%ax
  80229f:	90                   	nop

008022a0 <__udivdi3>:
  8022a0:	f3 0f 1e fb          	endbr32 
  8022a4:	55                   	push   %ebp
  8022a5:	57                   	push   %edi
  8022a6:	56                   	push   %esi
  8022a7:	53                   	push   %ebx
  8022a8:	83 ec 1c             	sub    $0x1c,%esp
  8022ab:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8022af:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8022b3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022b7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8022bb:	85 d2                	test   %edx,%edx
  8022bd:	75 19                	jne    8022d8 <__udivdi3+0x38>
  8022bf:	39 f3                	cmp    %esi,%ebx
  8022c1:	76 4d                	jbe    802310 <__udivdi3+0x70>
  8022c3:	31 ff                	xor    %edi,%edi
  8022c5:	89 e8                	mov    %ebp,%eax
  8022c7:	89 f2                	mov    %esi,%edx
  8022c9:	f7 f3                	div    %ebx
  8022cb:	89 fa                	mov    %edi,%edx
  8022cd:	83 c4 1c             	add    $0x1c,%esp
  8022d0:	5b                   	pop    %ebx
  8022d1:	5e                   	pop    %esi
  8022d2:	5f                   	pop    %edi
  8022d3:	5d                   	pop    %ebp
  8022d4:	c3                   	ret    
  8022d5:	8d 76 00             	lea    0x0(%esi),%esi
  8022d8:	39 f2                	cmp    %esi,%edx
  8022da:	76 14                	jbe    8022f0 <__udivdi3+0x50>
  8022dc:	31 ff                	xor    %edi,%edi
  8022de:	31 c0                	xor    %eax,%eax
  8022e0:	89 fa                	mov    %edi,%edx
  8022e2:	83 c4 1c             	add    $0x1c,%esp
  8022e5:	5b                   	pop    %ebx
  8022e6:	5e                   	pop    %esi
  8022e7:	5f                   	pop    %edi
  8022e8:	5d                   	pop    %ebp
  8022e9:	c3                   	ret    
  8022ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8022f0:	0f bd fa             	bsr    %edx,%edi
  8022f3:	83 f7 1f             	xor    $0x1f,%edi
  8022f6:	75 48                	jne    802340 <__udivdi3+0xa0>
  8022f8:	39 f2                	cmp    %esi,%edx
  8022fa:	72 06                	jb     802302 <__udivdi3+0x62>
  8022fc:	31 c0                	xor    %eax,%eax
  8022fe:	39 eb                	cmp    %ebp,%ebx
  802300:	77 de                	ja     8022e0 <__udivdi3+0x40>
  802302:	b8 01 00 00 00       	mov    $0x1,%eax
  802307:	eb d7                	jmp    8022e0 <__udivdi3+0x40>
  802309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802310:	89 d9                	mov    %ebx,%ecx
  802312:	85 db                	test   %ebx,%ebx
  802314:	75 0b                	jne    802321 <__udivdi3+0x81>
  802316:	b8 01 00 00 00       	mov    $0x1,%eax
  80231b:	31 d2                	xor    %edx,%edx
  80231d:	f7 f3                	div    %ebx
  80231f:	89 c1                	mov    %eax,%ecx
  802321:	31 d2                	xor    %edx,%edx
  802323:	89 f0                	mov    %esi,%eax
  802325:	f7 f1                	div    %ecx
  802327:	89 c6                	mov    %eax,%esi
  802329:	89 e8                	mov    %ebp,%eax
  80232b:	89 f7                	mov    %esi,%edi
  80232d:	f7 f1                	div    %ecx
  80232f:	89 fa                	mov    %edi,%edx
  802331:	83 c4 1c             	add    $0x1c,%esp
  802334:	5b                   	pop    %ebx
  802335:	5e                   	pop    %esi
  802336:	5f                   	pop    %edi
  802337:	5d                   	pop    %ebp
  802338:	c3                   	ret    
  802339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802340:	89 f9                	mov    %edi,%ecx
  802342:	b8 20 00 00 00       	mov    $0x20,%eax
  802347:	29 f8                	sub    %edi,%eax
  802349:	d3 e2                	shl    %cl,%edx
  80234b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80234f:	89 c1                	mov    %eax,%ecx
  802351:	89 da                	mov    %ebx,%edx
  802353:	d3 ea                	shr    %cl,%edx
  802355:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802359:	09 d1                	or     %edx,%ecx
  80235b:	89 f2                	mov    %esi,%edx
  80235d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802361:	89 f9                	mov    %edi,%ecx
  802363:	d3 e3                	shl    %cl,%ebx
  802365:	89 c1                	mov    %eax,%ecx
  802367:	d3 ea                	shr    %cl,%edx
  802369:	89 f9                	mov    %edi,%ecx
  80236b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80236f:	89 eb                	mov    %ebp,%ebx
  802371:	d3 e6                	shl    %cl,%esi
  802373:	89 c1                	mov    %eax,%ecx
  802375:	d3 eb                	shr    %cl,%ebx
  802377:	09 de                	or     %ebx,%esi
  802379:	89 f0                	mov    %esi,%eax
  80237b:	f7 74 24 08          	divl   0x8(%esp)
  80237f:	89 d6                	mov    %edx,%esi
  802381:	89 c3                	mov    %eax,%ebx
  802383:	f7 64 24 0c          	mull   0xc(%esp)
  802387:	39 d6                	cmp    %edx,%esi
  802389:	72 15                	jb     8023a0 <__udivdi3+0x100>
  80238b:	89 f9                	mov    %edi,%ecx
  80238d:	d3 e5                	shl    %cl,%ebp
  80238f:	39 c5                	cmp    %eax,%ebp
  802391:	73 04                	jae    802397 <__udivdi3+0xf7>
  802393:	39 d6                	cmp    %edx,%esi
  802395:	74 09                	je     8023a0 <__udivdi3+0x100>
  802397:	89 d8                	mov    %ebx,%eax
  802399:	31 ff                	xor    %edi,%edi
  80239b:	e9 40 ff ff ff       	jmp    8022e0 <__udivdi3+0x40>
  8023a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023a3:	31 ff                	xor    %edi,%edi
  8023a5:	e9 36 ff ff ff       	jmp    8022e0 <__udivdi3+0x40>
  8023aa:	66 90                	xchg   %ax,%ax
  8023ac:	66 90                	xchg   %ax,%ax
  8023ae:	66 90                	xchg   %ax,%ax

008023b0 <__umoddi3>:
  8023b0:	f3 0f 1e fb          	endbr32 
  8023b4:	55                   	push   %ebp
  8023b5:	57                   	push   %edi
  8023b6:	56                   	push   %esi
  8023b7:	53                   	push   %ebx
  8023b8:	83 ec 1c             	sub    $0x1c,%esp
  8023bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8023bf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8023c3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8023c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023cb:	85 c0                	test   %eax,%eax
  8023cd:	75 19                	jne    8023e8 <__umoddi3+0x38>
  8023cf:	39 df                	cmp    %ebx,%edi
  8023d1:	76 5d                	jbe    802430 <__umoddi3+0x80>
  8023d3:	89 f0                	mov    %esi,%eax
  8023d5:	89 da                	mov    %ebx,%edx
  8023d7:	f7 f7                	div    %edi
  8023d9:	89 d0                	mov    %edx,%eax
  8023db:	31 d2                	xor    %edx,%edx
  8023dd:	83 c4 1c             	add    $0x1c,%esp
  8023e0:	5b                   	pop    %ebx
  8023e1:	5e                   	pop    %esi
  8023e2:	5f                   	pop    %edi
  8023e3:	5d                   	pop    %ebp
  8023e4:	c3                   	ret    
  8023e5:	8d 76 00             	lea    0x0(%esi),%esi
  8023e8:	89 f2                	mov    %esi,%edx
  8023ea:	39 d8                	cmp    %ebx,%eax
  8023ec:	76 12                	jbe    802400 <__umoddi3+0x50>
  8023ee:	89 f0                	mov    %esi,%eax
  8023f0:	89 da                	mov    %ebx,%edx
  8023f2:	83 c4 1c             	add    $0x1c,%esp
  8023f5:	5b                   	pop    %ebx
  8023f6:	5e                   	pop    %esi
  8023f7:	5f                   	pop    %edi
  8023f8:	5d                   	pop    %ebp
  8023f9:	c3                   	ret    
  8023fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802400:	0f bd e8             	bsr    %eax,%ebp
  802403:	83 f5 1f             	xor    $0x1f,%ebp
  802406:	75 50                	jne    802458 <__umoddi3+0xa8>
  802408:	39 d8                	cmp    %ebx,%eax
  80240a:	0f 82 e0 00 00 00    	jb     8024f0 <__umoddi3+0x140>
  802410:	89 d9                	mov    %ebx,%ecx
  802412:	39 f7                	cmp    %esi,%edi
  802414:	0f 86 d6 00 00 00    	jbe    8024f0 <__umoddi3+0x140>
  80241a:	89 d0                	mov    %edx,%eax
  80241c:	89 ca                	mov    %ecx,%edx
  80241e:	83 c4 1c             	add    $0x1c,%esp
  802421:	5b                   	pop    %ebx
  802422:	5e                   	pop    %esi
  802423:	5f                   	pop    %edi
  802424:	5d                   	pop    %ebp
  802425:	c3                   	ret    
  802426:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80242d:	8d 76 00             	lea    0x0(%esi),%esi
  802430:	89 fd                	mov    %edi,%ebp
  802432:	85 ff                	test   %edi,%edi
  802434:	75 0b                	jne    802441 <__umoddi3+0x91>
  802436:	b8 01 00 00 00       	mov    $0x1,%eax
  80243b:	31 d2                	xor    %edx,%edx
  80243d:	f7 f7                	div    %edi
  80243f:	89 c5                	mov    %eax,%ebp
  802441:	89 d8                	mov    %ebx,%eax
  802443:	31 d2                	xor    %edx,%edx
  802445:	f7 f5                	div    %ebp
  802447:	89 f0                	mov    %esi,%eax
  802449:	f7 f5                	div    %ebp
  80244b:	89 d0                	mov    %edx,%eax
  80244d:	31 d2                	xor    %edx,%edx
  80244f:	eb 8c                	jmp    8023dd <__umoddi3+0x2d>
  802451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802458:	89 e9                	mov    %ebp,%ecx
  80245a:	ba 20 00 00 00       	mov    $0x20,%edx
  80245f:	29 ea                	sub    %ebp,%edx
  802461:	d3 e0                	shl    %cl,%eax
  802463:	89 44 24 08          	mov    %eax,0x8(%esp)
  802467:	89 d1                	mov    %edx,%ecx
  802469:	89 f8                	mov    %edi,%eax
  80246b:	d3 e8                	shr    %cl,%eax
  80246d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802471:	89 54 24 04          	mov    %edx,0x4(%esp)
  802475:	8b 54 24 04          	mov    0x4(%esp),%edx
  802479:	09 c1                	or     %eax,%ecx
  80247b:	89 d8                	mov    %ebx,%eax
  80247d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802481:	89 e9                	mov    %ebp,%ecx
  802483:	d3 e7                	shl    %cl,%edi
  802485:	89 d1                	mov    %edx,%ecx
  802487:	d3 e8                	shr    %cl,%eax
  802489:	89 e9                	mov    %ebp,%ecx
  80248b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80248f:	d3 e3                	shl    %cl,%ebx
  802491:	89 c7                	mov    %eax,%edi
  802493:	89 d1                	mov    %edx,%ecx
  802495:	89 f0                	mov    %esi,%eax
  802497:	d3 e8                	shr    %cl,%eax
  802499:	89 e9                	mov    %ebp,%ecx
  80249b:	89 fa                	mov    %edi,%edx
  80249d:	d3 e6                	shl    %cl,%esi
  80249f:	09 d8                	or     %ebx,%eax
  8024a1:	f7 74 24 08          	divl   0x8(%esp)
  8024a5:	89 d1                	mov    %edx,%ecx
  8024a7:	89 f3                	mov    %esi,%ebx
  8024a9:	f7 64 24 0c          	mull   0xc(%esp)
  8024ad:	89 c6                	mov    %eax,%esi
  8024af:	89 d7                	mov    %edx,%edi
  8024b1:	39 d1                	cmp    %edx,%ecx
  8024b3:	72 06                	jb     8024bb <__umoddi3+0x10b>
  8024b5:	75 10                	jne    8024c7 <__umoddi3+0x117>
  8024b7:	39 c3                	cmp    %eax,%ebx
  8024b9:	73 0c                	jae    8024c7 <__umoddi3+0x117>
  8024bb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8024bf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8024c3:	89 d7                	mov    %edx,%edi
  8024c5:	89 c6                	mov    %eax,%esi
  8024c7:	89 ca                	mov    %ecx,%edx
  8024c9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024ce:	29 f3                	sub    %esi,%ebx
  8024d0:	19 fa                	sbb    %edi,%edx
  8024d2:	89 d0                	mov    %edx,%eax
  8024d4:	d3 e0                	shl    %cl,%eax
  8024d6:	89 e9                	mov    %ebp,%ecx
  8024d8:	d3 eb                	shr    %cl,%ebx
  8024da:	d3 ea                	shr    %cl,%edx
  8024dc:	09 d8                	or     %ebx,%eax
  8024de:	83 c4 1c             	add    $0x1c,%esp
  8024e1:	5b                   	pop    %ebx
  8024e2:	5e                   	pop    %esi
  8024e3:	5f                   	pop    %edi
  8024e4:	5d                   	pop    %ebp
  8024e5:	c3                   	ret    
  8024e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024ed:	8d 76 00             	lea    0x0(%esi),%esi
  8024f0:	29 fe                	sub    %edi,%esi
  8024f2:	19 c3                	sbb    %eax,%ebx
  8024f4:	89 f2                	mov    %esi,%edx
  8024f6:	89 d9                	mov    %ebx,%ecx
  8024f8:	e9 1d ff ff ff       	jmp    80241a <__umoddi3+0x6a>
