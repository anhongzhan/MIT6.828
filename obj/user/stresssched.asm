
obj/user/stresssched:     file format elf32-i386


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
  80002c:	e8 b6 00 00 00       	call   8000e7 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

volatile int counter;

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	56                   	push   %esi
  80003b:	53                   	push   %ebx
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();
  80003c:	e8 f3 0b 00 00       	call   800c34 <sys_getenvid>
  800041:	89 c6                	mov    %eax,%esi

	// Fork several environments
	for (i = 0; i < 20; i++)
  800043:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fork() == 0)
  800048:	e8 d8 0e 00 00       	call   800f25 <fork>
  80004d:	85 c0                	test   %eax,%eax
  80004f:	74 0f                	je     800060 <umain+0x2d>
	for (i = 0; i < 20; i++)
  800051:	83 c3 01             	add    $0x1,%ebx
  800054:	83 fb 14             	cmp    $0x14,%ebx
  800057:	75 ef                	jne    800048 <umain+0x15>
			break;
	if (i == 20) {
		sys_yield();
  800059:	e8 f9 0b 00 00       	call   800c57 <sys_yield>
		return;
  80005e:	eb 69                	jmp    8000c9 <umain+0x96>
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  800060:	89 f0                	mov    %esi,%eax
  800062:	25 ff 03 00 00       	and    $0x3ff,%eax
  800067:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80006a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006f:	eb 02                	jmp    800073 <umain+0x40>
		asm volatile("pause");
  800071:	f3 90                	pause  
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  800073:	8b 50 54             	mov    0x54(%eax),%edx
  800076:	85 d2                	test   %edx,%edx
  800078:	75 f7                	jne    800071 <umain+0x3e>
  80007a:	bb 0a 00 00 00       	mov    $0xa,%ebx

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
  80007f:	e8 d3 0b 00 00       	call   800c57 <sys_yield>
  800084:	ba 10 27 00 00       	mov    $0x2710,%edx
		for (j = 0; j < 10000; j++)
			counter++;
  800089:	a1 04 20 80 00       	mov    0x802004,%eax
  80008e:	83 c0 01             	add    $0x1,%eax
  800091:	a3 04 20 80 00       	mov    %eax,0x802004
		for (j = 0; j < 10000; j++)
  800096:	83 ea 01             	sub    $0x1,%edx
  800099:	75 ee                	jne    800089 <umain+0x56>
	for (i = 0; i < 10; i++) {
  80009b:	83 eb 01             	sub    $0x1,%ebx
  80009e:	75 df                	jne    80007f <umain+0x4c>
	}

	if (counter != 10*10000)
  8000a0:	a1 04 20 80 00       	mov    0x802004,%eax
  8000a5:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  8000aa:	75 24                	jne    8000d0 <umain+0x9d>
		panic("ran on two CPUs at once (counter is %d)", counter);

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  8000ac:	a1 08 20 80 00       	mov    0x802008,%eax
  8000b1:	8b 50 5c             	mov    0x5c(%eax),%edx
  8000b4:	8b 40 48             	mov    0x48(%eax),%eax
  8000b7:	83 ec 04             	sub    $0x4,%esp
  8000ba:	52                   	push   %edx
  8000bb:	50                   	push   %eax
  8000bc:	68 5b 14 80 00       	push   $0x80145b
  8000c1:	e8 68 01 00 00       	call   80022e <cprintf>
  8000c6:	83 c4 10             	add    $0x10,%esp

}
  8000c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000cc:	5b                   	pop    %ebx
  8000cd:	5e                   	pop    %esi
  8000ce:	5d                   	pop    %ebp
  8000cf:	c3                   	ret    
		panic("ran on two CPUs at once (counter is %d)", counter);
  8000d0:	a1 04 20 80 00       	mov    0x802004,%eax
  8000d5:	50                   	push   %eax
  8000d6:	68 20 14 80 00       	push   $0x801420
  8000db:	6a 21                	push   $0x21
  8000dd:	68 48 14 80 00       	push   $0x801448
  8000e2:	e8 60 00 00 00       	call   800147 <_panic>

008000e7 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e7:	f3 0f 1e fb          	endbr32 
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	56                   	push   %esi
  8000ef:	53                   	push   %ebx
  8000f0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000f3:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000f6:	e8 39 0b 00 00       	call   800c34 <sys_getenvid>
  8000fb:	25 ff 03 00 00       	and    $0x3ff,%eax
  800100:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800103:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800108:	a3 08 20 80 00       	mov    %eax,0x802008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80010d:	85 db                	test   %ebx,%ebx
  80010f:	7e 07                	jle    800118 <libmain+0x31>
		binaryname = argv[0];
  800111:	8b 06                	mov    (%esi),%eax
  800113:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800118:	83 ec 08             	sub    $0x8,%esp
  80011b:	56                   	push   %esi
  80011c:	53                   	push   %ebx
  80011d:	e8 11 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800122:	e8 0a 00 00 00       	call   800131 <exit>
}
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80012d:	5b                   	pop    %ebx
  80012e:	5e                   	pop    %esi
  80012f:	5d                   	pop    %ebp
  800130:	c3                   	ret    

00800131 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800131:	f3 0f 1e fb          	endbr32 
  800135:	55                   	push   %ebp
  800136:	89 e5                	mov    %esp,%ebp
  800138:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  80013b:	6a 00                	push   $0x0
  80013d:	e8 ad 0a 00 00       	call   800bef <sys_env_destroy>
}
  800142:	83 c4 10             	add    $0x10,%esp
  800145:	c9                   	leave  
  800146:	c3                   	ret    

00800147 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800147:	f3 0f 1e fb          	endbr32 
  80014b:	55                   	push   %ebp
  80014c:	89 e5                	mov    %esp,%ebp
  80014e:	56                   	push   %esi
  80014f:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800150:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800153:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800159:	e8 d6 0a 00 00       	call   800c34 <sys_getenvid>
  80015e:	83 ec 0c             	sub    $0xc,%esp
  800161:	ff 75 0c             	pushl  0xc(%ebp)
  800164:	ff 75 08             	pushl  0x8(%ebp)
  800167:	56                   	push   %esi
  800168:	50                   	push   %eax
  800169:	68 84 14 80 00       	push   $0x801484
  80016e:	e8 bb 00 00 00       	call   80022e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800173:	83 c4 18             	add    $0x18,%esp
  800176:	53                   	push   %ebx
  800177:	ff 75 10             	pushl  0x10(%ebp)
  80017a:	e8 5a 00 00 00       	call   8001d9 <vcprintf>
	cprintf("\n");
  80017f:	c7 04 24 77 14 80 00 	movl   $0x801477,(%esp)
  800186:	e8 a3 00 00 00       	call   80022e <cprintf>
  80018b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80018e:	cc                   	int3   
  80018f:	eb fd                	jmp    80018e <_panic+0x47>

00800191 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800191:	f3 0f 1e fb          	endbr32 
  800195:	55                   	push   %ebp
  800196:	89 e5                	mov    %esp,%ebp
  800198:	53                   	push   %ebx
  800199:	83 ec 04             	sub    $0x4,%esp
  80019c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80019f:	8b 13                	mov    (%ebx),%edx
  8001a1:	8d 42 01             	lea    0x1(%edx),%eax
  8001a4:	89 03                	mov    %eax,(%ebx)
  8001a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001a9:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001ad:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001b2:	74 09                	je     8001bd <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001b4:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001bb:	c9                   	leave  
  8001bc:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001bd:	83 ec 08             	sub    $0x8,%esp
  8001c0:	68 ff 00 00 00       	push   $0xff
  8001c5:	8d 43 08             	lea    0x8(%ebx),%eax
  8001c8:	50                   	push   %eax
  8001c9:	e8 dc 09 00 00       	call   800baa <sys_cputs>
		b->idx = 0;
  8001ce:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001d4:	83 c4 10             	add    $0x10,%esp
  8001d7:	eb db                	jmp    8001b4 <putch+0x23>

008001d9 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001d9:	f3 0f 1e fb          	endbr32 
  8001dd:	55                   	push   %ebp
  8001de:	89 e5                	mov    %esp,%ebp
  8001e0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001e6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001ed:	00 00 00 
	b.cnt = 0;
  8001f0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001f7:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001fa:	ff 75 0c             	pushl  0xc(%ebp)
  8001fd:	ff 75 08             	pushl  0x8(%ebp)
  800200:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800206:	50                   	push   %eax
  800207:	68 91 01 80 00       	push   $0x800191
  80020c:	e8 20 01 00 00       	call   800331 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800211:	83 c4 08             	add    $0x8,%esp
  800214:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80021a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800220:	50                   	push   %eax
  800221:	e8 84 09 00 00       	call   800baa <sys_cputs>

	return b.cnt;
}
  800226:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80022c:	c9                   	leave  
  80022d:	c3                   	ret    

0080022e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80022e:	f3 0f 1e fb          	endbr32 
  800232:	55                   	push   %ebp
  800233:	89 e5                	mov    %esp,%ebp
  800235:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800238:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80023b:	50                   	push   %eax
  80023c:	ff 75 08             	pushl  0x8(%ebp)
  80023f:	e8 95 ff ff ff       	call   8001d9 <vcprintf>
	va_end(ap);

	return cnt;
}
  800244:	c9                   	leave  
  800245:	c3                   	ret    

00800246 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800246:	55                   	push   %ebp
  800247:	89 e5                	mov    %esp,%ebp
  800249:	57                   	push   %edi
  80024a:	56                   	push   %esi
  80024b:	53                   	push   %ebx
  80024c:	83 ec 1c             	sub    $0x1c,%esp
  80024f:	89 c7                	mov    %eax,%edi
  800251:	89 d6                	mov    %edx,%esi
  800253:	8b 45 08             	mov    0x8(%ebp),%eax
  800256:	8b 55 0c             	mov    0xc(%ebp),%edx
  800259:	89 d1                	mov    %edx,%ecx
  80025b:	89 c2                	mov    %eax,%edx
  80025d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800260:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800263:	8b 45 10             	mov    0x10(%ebp),%eax
  800266:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800269:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80026c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800273:	39 c2                	cmp    %eax,%edx
  800275:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800278:	72 3e                	jb     8002b8 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80027a:	83 ec 0c             	sub    $0xc,%esp
  80027d:	ff 75 18             	pushl  0x18(%ebp)
  800280:	83 eb 01             	sub    $0x1,%ebx
  800283:	53                   	push   %ebx
  800284:	50                   	push   %eax
  800285:	83 ec 08             	sub    $0x8,%esp
  800288:	ff 75 e4             	pushl  -0x1c(%ebp)
  80028b:	ff 75 e0             	pushl  -0x20(%ebp)
  80028e:	ff 75 dc             	pushl  -0x24(%ebp)
  800291:	ff 75 d8             	pushl  -0x28(%ebp)
  800294:	e8 17 0f 00 00       	call   8011b0 <__udivdi3>
  800299:	83 c4 18             	add    $0x18,%esp
  80029c:	52                   	push   %edx
  80029d:	50                   	push   %eax
  80029e:	89 f2                	mov    %esi,%edx
  8002a0:	89 f8                	mov    %edi,%eax
  8002a2:	e8 9f ff ff ff       	call   800246 <printnum>
  8002a7:	83 c4 20             	add    $0x20,%esp
  8002aa:	eb 13                	jmp    8002bf <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002ac:	83 ec 08             	sub    $0x8,%esp
  8002af:	56                   	push   %esi
  8002b0:	ff 75 18             	pushl  0x18(%ebp)
  8002b3:	ff d7                	call   *%edi
  8002b5:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002b8:	83 eb 01             	sub    $0x1,%ebx
  8002bb:	85 db                	test   %ebx,%ebx
  8002bd:	7f ed                	jg     8002ac <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002bf:	83 ec 08             	sub    $0x8,%esp
  8002c2:	56                   	push   %esi
  8002c3:	83 ec 04             	sub    $0x4,%esp
  8002c6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c9:	ff 75 e0             	pushl  -0x20(%ebp)
  8002cc:	ff 75 dc             	pushl  -0x24(%ebp)
  8002cf:	ff 75 d8             	pushl  -0x28(%ebp)
  8002d2:	e8 e9 0f 00 00       	call   8012c0 <__umoddi3>
  8002d7:	83 c4 14             	add    $0x14,%esp
  8002da:	0f be 80 a7 14 80 00 	movsbl 0x8014a7(%eax),%eax
  8002e1:	50                   	push   %eax
  8002e2:	ff d7                	call   *%edi
}
  8002e4:	83 c4 10             	add    $0x10,%esp
  8002e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ea:	5b                   	pop    %ebx
  8002eb:	5e                   	pop    %esi
  8002ec:	5f                   	pop    %edi
  8002ed:	5d                   	pop    %ebp
  8002ee:	c3                   	ret    

008002ef <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002ef:	f3 0f 1e fb          	endbr32 
  8002f3:	55                   	push   %ebp
  8002f4:	89 e5                	mov    %esp,%ebp
  8002f6:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002f9:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002fd:	8b 10                	mov    (%eax),%edx
  8002ff:	3b 50 04             	cmp    0x4(%eax),%edx
  800302:	73 0a                	jae    80030e <sprintputch+0x1f>
		*b->buf++ = ch;
  800304:	8d 4a 01             	lea    0x1(%edx),%ecx
  800307:	89 08                	mov    %ecx,(%eax)
  800309:	8b 45 08             	mov    0x8(%ebp),%eax
  80030c:	88 02                	mov    %al,(%edx)
}
  80030e:	5d                   	pop    %ebp
  80030f:	c3                   	ret    

00800310 <printfmt>:
{
  800310:	f3 0f 1e fb          	endbr32 
  800314:	55                   	push   %ebp
  800315:	89 e5                	mov    %esp,%ebp
  800317:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80031a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80031d:	50                   	push   %eax
  80031e:	ff 75 10             	pushl  0x10(%ebp)
  800321:	ff 75 0c             	pushl  0xc(%ebp)
  800324:	ff 75 08             	pushl  0x8(%ebp)
  800327:	e8 05 00 00 00       	call   800331 <vprintfmt>
}
  80032c:	83 c4 10             	add    $0x10,%esp
  80032f:	c9                   	leave  
  800330:	c3                   	ret    

00800331 <vprintfmt>:
{
  800331:	f3 0f 1e fb          	endbr32 
  800335:	55                   	push   %ebp
  800336:	89 e5                	mov    %esp,%ebp
  800338:	57                   	push   %edi
  800339:	56                   	push   %esi
  80033a:	53                   	push   %ebx
  80033b:	83 ec 3c             	sub    $0x3c,%esp
  80033e:	8b 75 08             	mov    0x8(%ebp),%esi
  800341:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800344:	8b 7d 10             	mov    0x10(%ebp),%edi
  800347:	e9 8e 03 00 00       	jmp    8006da <vprintfmt+0x3a9>
		padc = ' ';
  80034c:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800350:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800357:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80035e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800365:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80036a:	8d 47 01             	lea    0x1(%edi),%eax
  80036d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800370:	0f b6 17             	movzbl (%edi),%edx
  800373:	8d 42 dd             	lea    -0x23(%edx),%eax
  800376:	3c 55                	cmp    $0x55,%al
  800378:	0f 87 df 03 00 00    	ja     80075d <vprintfmt+0x42c>
  80037e:	0f b6 c0             	movzbl %al,%eax
  800381:	3e ff 24 85 60 15 80 	notrack jmp *0x801560(,%eax,4)
  800388:	00 
  800389:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80038c:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800390:	eb d8                	jmp    80036a <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800392:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800395:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800399:	eb cf                	jmp    80036a <vprintfmt+0x39>
  80039b:	0f b6 d2             	movzbl %dl,%edx
  80039e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003a9:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003ac:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003b0:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003b3:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003b6:	83 f9 09             	cmp    $0x9,%ecx
  8003b9:	77 55                	ja     800410 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8003bb:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003be:	eb e9                	jmp    8003a9 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8003c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c3:	8b 00                	mov    (%eax),%eax
  8003c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003cb:	8d 40 04             	lea    0x4(%eax),%eax
  8003ce:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003d4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003d8:	79 90                	jns    80036a <vprintfmt+0x39>
				width = precision, precision = -1;
  8003da:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003e0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003e7:	eb 81                	jmp    80036a <vprintfmt+0x39>
  8003e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ec:	85 c0                	test   %eax,%eax
  8003ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f3:	0f 49 d0             	cmovns %eax,%edx
  8003f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003fc:	e9 69 ff ff ff       	jmp    80036a <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800401:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800404:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80040b:	e9 5a ff ff ff       	jmp    80036a <vprintfmt+0x39>
  800410:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800413:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800416:	eb bc                	jmp    8003d4 <vprintfmt+0xa3>
			lflag++;
  800418:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80041b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80041e:	e9 47 ff ff ff       	jmp    80036a <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800423:	8b 45 14             	mov    0x14(%ebp),%eax
  800426:	8d 78 04             	lea    0x4(%eax),%edi
  800429:	83 ec 08             	sub    $0x8,%esp
  80042c:	53                   	push   %ebx
  80042d:	ff 30                	pushl  (%eax)
  80042f:	ff d6                	call   *%esi
			break;
  800431:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800434:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800437:	e9 9b 02 00 00       	jmp    8006d7 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80043c:	8b 45 14             	mov    0x14(%ebp),%eax
  80043f:	8d 78 04             	lea    0x4(%eax),%edi
  800442:	8b 00                	mov    (%eax),%eax
  800444:	99                   	cltd   
  800445:	31 d0                	xor    %edx,%eax
  800447:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800449:	83 f8 08             	cmp    $0x8,%eax
  80044c:	7f 23                	jg     800471 <vprintfmt+0x140>
  80044e:	8b 14 85 c0 16 80 00 	mov    0x8016c0(,%eax,4),%edx
  800455:	85 d2                	test   %edx,%edx
  800457:	74 18                	je     800471 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800459:	52                   	push   %edx
  80045a:	68 c8 14 80 00       	push   $0x8014c8
  80045f:	53                   	push   %ebx
  800460:	56                   	push   %esi
  800461:	e8 aa fe ff ff       	call   800310 <printfmt>
  800466:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800469:	89 7d 14             	mov    %edi,0x14(%ebp)
  80046c:	e9 66 02 00 00       	jmp    8006d7 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800471:	50                   	push   %eax
  800472:	68 bf 14 80 00       	push   $0x8014bf
  800477:	53                   	push   %ebx
  800478:	56                   	push   %esi
  800479:	e8 92 fe ff ff       	call   800310 <printfmt>
  80047e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800481:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800484:	e9 4e 02 00 00       	jmp    8006d7 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800489:	8b 45 14             	mov    0x14(%ebp),%eax
  80048c:	83 c0 04             	add    $0x4,%eax
  80048f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800492:	8b 45 14             	mov    0x14(%ebp),%eax
  800495:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800497:	85 d2                	test   %edx,%edx
  800499:	b8 b8 14 80 00       	mov    $0x8014b8,%eax
  80049e:	0f 45 c2             	cmovne %edx,%eax
  8004a1:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004a4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004a8:	7e 06                	jle    8004b0 <vprintfmt+0x17f>
  8004aa:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004ae:	75 0d                	jne    8004bd <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004b3:	89 c7                	mov    %eax,%edi
  8004b5:	03 45 e0             	add    -0x20(%ebp),%eax
  8004b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004bb:	eb 55                	jmp    800512 <vprintfmt+0x1e1>
  8004bd:	83 ec 08             	sub    $0x8,%esp
  8004c0:	ff 75 d8             	pushl  -0x28(%ebp)
  8004c3:	ff 75 cc             	pushl  -0x34(%ebp)
  8004c6:	e8 46 03 00 00       	call   800811 <strnlen>
  8004cb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004ce:	29 c2                	sub    %eax,%edx
  8004d0:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004d3:	83 c4 10             	add    $0x10,%esp
  8004d6:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004d8:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004df:	85 ff                	test   %edi,%edi
  8004e1:	7e 11                	jle    8004f4 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8004e3:	83 ec 08             	sub    $0x8,%esp
  8004e6:	53                   	push   %ebx
  8004e7:	ff 75 e0             	pushl  -0x20(%ebp)
  8004ea:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ec:	83 ef 01             	sub    $0x1,%edi
  8004ef:	83 c4 10             	add    $0x10,%esp
  8004f2:	eb eb                	jmp    8004df <vprintfmt+0x1ae>
  8004f4:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004f7:	85 d2                	test   %edx,%edx
  8004f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004fe:	0f 49 c2             	cmovns %edx,%eax
  800501:	29 c2                	sub    %eax,%edx
  800503:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800506:	eb a8                	jmp    8004b0 <vprintfmt+0x17f>
					putch(ch, putdat);
  800508:	83 ec 08             	sub    $0x8,%esp
  80050b:	53                   	push   %ebx
  80050c:	52                   	push   %edx
  80050d:	ff d6                	call   *%esi
  80050f:	83 c4 10             	add    $0x10,%esp
  800512:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800515:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800517:	83 c7 01             	add    $0x1,%edi
  80051a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80051e:	0f be d0             	movsbl %al,%edx
  800521:	85 d2                	test   %edx,%edx
  800523:	74 4b                	je     800570 <vprintfmt+0x23f>
  800525:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800529:	78 06                	js     800531 <vprintfmt+0x200>
  80052b:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80052f:	78 1e                	js     80054f <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800531:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800535:	74 d1                	je     800508 <vprintfmt+0x1d7>
  800537:	0f be c0             	movsbl %al,%eax
  80053a:	83 e8 20             	sub    $0x20,%eax
  80053d:	83 f8 5e             	cmp    $0x5e,%eax
  800540:	76 c6                	jbe    800508 <vprintfmt+0x1d7>
					putch('?', putdat);
  800542:	83 ec 08             	sub    $0x8,%esp
  800545:	53                   	push   %ebx
  800546:	6a 3f                	push   $0x3f
  800548:	ff d6                	call   *%esi
  80054a:	83 c4 10             	add    $0x10,%esp
  80054d:	eb c3                	jmp    800512 <vprintfmt+0x1e1>
  80054f:	89 cf                	mov    %ecx,%edi
  800551:	eb 0e                	jmp    800561 <vprintfmt+0x230>
				putch(' ', putdat);
  800553:	83 ec 08             	sub    $0x8,%esp
  800556:	53                   	push   %ebx
  800557:	6a 20                	push   $0x20
  800559:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80055b:	83 ef 01             	sub    $0x1,%edi
  80055e:	83 c4 10             	add    $0x10,%esp
  800561:	85 ff                	test   %edi,%edi
  800563:	7f ee                	jg     800553 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800565:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800568:	89 45 14             	mov    %eax,0x14(%ebp)
  80056b:	e9 67 01 00 00       	jmp    8006d7 <vprintfmt+0x3a6>
  800570:	89 cf                	mov    %ecx,%edi
  800572:	eb ed                	jmp    800561 <vprintfmt+0x230>
	if (lflag >= 2)
  800574:	83 f9 01             	cmp    $0x1,%ecx
  800577:	7f 1b                	jg     800594 <vprintfmt+0x263>
	else if (lflag)
  800579:	85 c9                	test   %ecx,%ecx
  80057b:	74 63                	je     8005e0 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80057d:	8b 45 14             	mov    0x14(%ebp),%eax
  800580:	8b 00                	mov    (%eax),%eax
  800582:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800585:	99                   	cltd   
  800586:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800589:	8b 45 14             	mov    0x14(%ebp),%eax
  80058c:	8d 40 04             	lea    0x4(%eax),%eax
  80058f:	89 45 14             	mov    %eax,0x14(%ebp)
  800592:	eb 17                	jmp    8005ab <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800594:	8b 45 14             	mov    0x14(%ebp),%eax
  800597:	8b 50 04             	mov    0x4(%eax),%edx
  80059a:	8b 00                	mov    (%eax),%eax
  80059c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80059f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a5:	8d 40 08             	lea    0x8(%eax),%eax
  8005a8:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005ab:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005ae:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005b1:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8005b6:	85 c9                	test   %ecx,%ecx
  8005b8:	0f 89 ff 00 00 00    	jns    8006bd <vprintfmt+0x38c>
				putch('-', putdat);
  8005be:	83 ec 08             	sub    $0x8,%esp
  8005c1:	53                   	push   %ebx
  8005c2:	6a 2d                	push   $0x2d
  8005c4:	ff d6                	call   *%esi
				num = -(long long) num;
  8005c6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005c9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005cc:	f7 da                	neg    %edx
  8005ce:	83 d1 00             	adc    $0x0,%ecx
  8005d1:	f7 d9                	neg    %ecx
  8005d3:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005d6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005db:	e9 dd 00 00 00       	jmp    8006bd <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8005e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e3:	8b 00                	mov    (%eax),%eax
  8005e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e8:	99                   	cltd   
  8005e9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ef:	8d 40 04             	lea    0x4(%eax),%eax
  8005f2:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f5:	eb b4                	jmp    8005ab <vprintfmt+0x27a>
	if (lflag >= 2)
  8005f7:	83 f9 01             	cmp    $0x1,%ecx
  8005fa:	7f 1e                	jg     80061a <vprintfmt+0x2e9>
	else if (lflag)
  8005fc:	85 c9                	test   %ecx,%ecx
  8005fe:	74 32                	je     800632 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800600:	8b 45 14             	mov    0x14(%ebp),%eax
  800603:	8b 10                	mov    (%eax),%edx
  800605:	b9 00 00 00 00       	mov    $0x0,%ecx
  80060a:	8d 40 04             	lea    0x4(%eax),%eax
  80060d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800610:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800615:	e9 a3 00 00 00       	jmp    8006bd <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	8b 10                	mov    (%eax),%edx
  80061f:	8b 48 04             	mov    0x4(%eax),%ecx
  800622:	8d 40 08             	lea    0x8(%eax),%eax
  800625:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800628:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80062d:	e9 8b 00 00 00       	jmp    8006bd <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800632:	8b 45 14             	mov    0x14(%ebp),%eax
  800635:	8b 10                	mov    (%eax),%edx
  800637:	b9 00 00 00 00       	mov    $0x0,%ecx
  80063c:	8d 40 04             	lea    0x4(%eax),%eax
  80063f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800642:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800647:	eb 74                	jmp    8006bd <vprintfmt+0x38c>
	if (lflag >= 2)
  800649:	83 f9 01             	cmp    $0x1,%ecx
  80064c:	7f 1b                	jg     800669 <vprintfmt+0x338>
	else if (lflag)
  80064e:	85 c9                	test   %ecx,%ecx
  800650:	74 2c                	je     80067e <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800652:	8b 45 14             	mov    0x14(%ebp),%eax
  800655:	8b 10                	mov    (%eax),%edx
  800657:	b9 00 00 00 00       	mov    $0x0,%ecx
  80065c:	8d 40 04             	lea    0x4(%eax),%eax
  80065f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800662:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800667:	eb 54                	jmp    8006bd <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800669:	8b 45 14             	mov    0x14(%ebp),%eax
  80066c:	8b 10                	mov    (%eax),%edx
  80066e:	8b 48 04             	mov    0x4(%eax),%ecx
  800671:	8d 40 08             	lea    0x8(%eax),%eax
  800674:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800677:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80067c:	eb 3f                	jmp    8006bd <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80067e:	8b 45 14             	mov    0x14(%ebp),%eax
  800681:	8b 10                	mov    (%eax),%edx
  800683:	b9 00 00 00 00       	mov    $0x0,%ecx
  800688:	8d 40 04             	lea    0x4(%eax),%eax
  80068b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80068e:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800693:	eb 28                	jmp    8006bd <vprintfmt+0x38c>
			putch('0', putdat);
  800695:	83 ec 08             	sub    $0x8,%esp
  800698:	53                   	push   %ebx
  800699:	6a 30                	push   $0x30
  80069b:	ff d6                	call   *%esi
			putch('x', putdat);
  80069d:	83 c4 08             	add    $0x8,%esp
  8006a0:	53                   	push   %ebx
  8006a1:	6a 78                	push   $0x78
  8006a3:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a8:	8b 10                	mov    (%eax),%edx
  8006aa:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006af:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006b2:	8d 40 04             	lea    0x4(%eax),%eax
  8006b5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b8:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006bd:	83 ec 0c             	sub    $0xc,%esp
  8006c0:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8006c4:	57                   	push   %edi
  8006c5:	ff 75 e0             	pushl  -0x20(%ebp)
  8006c8:	50                   	push   %eax
  8006c9:	51                   	push   %ecx
  8006ca:	52                   	push   %edx
  8006cb:	89 da                	mov    %ebx,%edx
  8006cd:	89 f0                	mov    %esi,%eax
  8006cf:	e8 72 fb ff ff       	call   800246 <printnum>
			break;
  8006d4:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006da:	83 c7 01             	add    $0x1,%edi
  8006dd:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006e1:	83 f8 25             	cmp    $0x25,%eax
  8006e4:	0f 84 62 fc ff ff    	je     80034c <vprintfmt+0x1b>
			if (ch == '\0')
  8006ea:	85 c0                	test   %eax,%eax
  8006ec:	0f 84 8b 00 00 00    	je     80077d <vprintfmt+0x44c>
			putch(ch, putdat);
  8006f2:	83 ec 08             	sub    $0x8,%esp
  8006f5:	53                   	push   %ebx
  8006f6:	50                   	push   %eax
  8006f7:	ff d6                	call   *%esi
  8006f9:	83 c4 10             	add    $0x10,%esp
  8006fc:	eb dc                	jmp    8006da <vprintfmt+0x3a9>
	if (lflag >= 2)
  8006fe:	83 f9 01             	cmp    $0x1,%ecx
  800701:	7f 1b                	jg     80071e <vprintfmt+0x3ed>
	else if (lflag)
  800703:	85 c9                	test   %ecx,%ecx
  800705:	74 2c                	je     800733 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800707:	8b 45 14             	mov    0x14(%ebp),%eax
  80070a:	8b 10                	mov    (%eax),%edx
  80070c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800711:	8d 40 04             	lea    0x4(%eax),%eax
  800714:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800717:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80071c:	eb 9f                	jmp    8006bd <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80071e:	8b 45 14             	mov    0x14(%ebp),%eax
  800721:	8b 10                	mov    (%eax),%edx
  800723:	8b 48 04             	mov    0x4(%eax),%ecx
  800726:	8d 40 08             	lea    0x8(%eax),%eax
  800729:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80072c:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800731:	eb 8a                	jmp    8006bd <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800733:	8b 45 14             	mov    0x14(%ebp),%eax
  800736:	8b 10                	mov    (%eax),%edx
  800738:	b9 00 00 00 00       	mov    $0x0,%ecx
  80073d:	8d 40 04             	lea    0x4(%eax),%eax
  800740:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800743:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800748:	e9 70 ff ff ff       	jmp    8006bd <vprintfmt+0x38c>
			putch(ch, putdat);
  80074d:	83 ec 08             	sub    $0x8,%esp
  800750:	53                   	push   %ebx
  800751:	6a 25                	push   $0x25
  800753:	ff d6                	call   *%esi
			break;
  800755:	83 c4 10             	add    $0x10,%esp
  800758:	e9 7a ff ff ff       	jmp    8006d7 <vprintfmt+0x3a6>
			putch('%', putdat);
  80075d:	83 ec 08             	sub    $0x8,%esp
  800760:	53                   	push   %ebx
  800761:	6a 25                	push   $0x25
  800763:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800765:	83 c4 10             	add    $0x10,%esp
  800768:	89 f8                	mov    %edi,%eax
  80076a:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80076e:	74 05                	je     800775 <vprintfmt+0x444>
  800770:	83 e8 01             	sub    $0x1,%eax
  800773:	eb f5                	jmp    80076a <vprintfmt+0x439>
  800775:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800778:	e9 5a ff ff ff       	jmp    8006d7 <vprintfmt+0x3a6>
}
  80077d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800780:	5b                   	pop    %ebx
  800781:	5e                   	pop    %esi
  800782:	5f                   	pop    %edi
  800783:	5d                   	pop    %ebp
  800784:	c3                   	ret    

00800785 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800785:	f3 0f 1e fb          	endbr32 
  800789:	55                   	push   %ebp
  80078a:	89 e5                	mov    %esp,%ebp
  80078c:	83 ec 18             	sub    $0x18,%esp
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800795:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800798:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80079c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80079f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007a6:	85 c0                	test   %eax,%eax
  8007a8:	74 26                	je     8007d0 <vsnprintf+0x4b>
  8007aa:	85 d2                	test   %edx,%edx
  8007ac:	7e 22                	jle    8007d0 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007ae:	ff 75 14             	pushl  0x14(%ebp)
  8007b1:	ff 75 10             	pushl  0x10(%ebp)
  8007b4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007b7:	50                   	push   %eax
  8007b8:	68 ef 02 80 00       	push   $0x8002ef
  8007bd:	e8 6f fb ff ff       	call   800331 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007c5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007cb:	83 c4 10             	add    $0x10,%esp
}
  8007ce:	c9                   	leave  
  8007cf:	c3                   	ret    
		return -E_INVAL;
  8007d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007d5:	eb f7                	jmp    8007ce <vsnprintf+0x49>

008007d7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007d7:	f3 0f 1e fb          	endbr32 
  8007db:	55                   	push   %ebp
  8007dc:	89 e5                	mov    %esp,%ebp
  8007de:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007e1:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007e4:	50                   	push   %eax
  8007e5:	ff 75 10             	pushl  0x10(%ebp)
  8007e8:	ff 75 0c             	pushl  0xc(%ebp)
  8007eb:	ff 75 08             	pushl  0x8(%ebp)
  8007ee:	e8 92 ff ff ff       	call   800785 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007f3:	c9                   	leave  
  8007f4:	c3                   	ret    

008007f5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007f5:	f3 0f 1e fb          	endbr32 
  8007f9:	55                   	push   %ebp
  8007fa:	89 e5                	mov    %esp,%ebp
  8007fc:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800804:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800808:	74 05                	je     80080f <strlen+0x1a>
		n++;
  80080a:	83 c0 01             	add    $0x1,%eax
  80080d:	eb f5                	jmp    800804 <strlen+0xf>
	return n;
}
  80080f:	5d                   	pop    %ebp
  800810:	c3                   	ret    

00800811 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800811:	f3 0f 1e fb          	endbr32 
  800815:	55                   	push   %ebp
  800816:	89 e5                	mov    %esp,%ebp
  800818:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80081b:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80081e:	b8 00 00 00 00       	mov    $0x0,%eax
  800823:	39 d0                	cmp    %edx,%eax
  800825:	74 0d                	je     800834 <strnlen+0x23>
  800827:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80082b:	74 05                	je     800832 <strnlen+0x21>
		n++;
  80082d:	83 c0 01             	add    $0x1,%eax
  800830:	eb f1                	jmp    800823 <strnlen+0x12>
  800832:	89 c2                	mov    %eax,%edx
	return n;
}
  800834:	89 d0                	mov    %edx,%eax
  800836:	5d                   	pop    %ebp
  800837:	c3                   	ret    

00800838 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800838:	f3 0f 1e fb          	endbr32 
  80083c:	55                   	push   %ebp
  80083d:	89 e5                	mov    %esp,%ebp
  80083f:	53                   	push   %ebx
  800840:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800843:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800846:	b8 00 00 00 00       	mov    $0x0,%eax
  80084b:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80084f:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800852:	83 c0 01             	add    $0x1,%eax
  800855:	84 d2                	test   %dl,%dl
  800857:	75 f2                	jne    80084b <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800859:	89 c8                	mov    %ecx,%eax
  80085b:	5b                   	pop    %ebx
  80085c:	5d                   	pop    %ebp
  80085d:	c3                   	ret    

0080085e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80085e:	f3 0f 1e fb          	endbr32 
  800862:	55                   	push   %ebp
  800863:	89 e5                	mov    %esp,%ebp
  800865:	53                   	push   %ebx
  800866:	83 ec 10             	sub    $0x10,%esp
  800869:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80086c:	53                   	push   %ebx
  80086d:	e8 83 ff ff ff       	call   8007f5 <strlen>
  800872:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800875:	ff 75 0c             	pushl  0xc(%ebp)
  800878:	01 d8                	add    %ebx,%eax
  80087a:	50                   	push   %eax
  80087b:	e8 b8 ff ff ff       	call   800838 <strcpy>
	return dst;
}
  800880:	89 d8                	mov    %ebx,%eax
  800882:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800885:	c9                   	leave  
  800886:	c3                   	ret    

00800887 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800887:	f3 0f 1e fb          	endbr32 
  80088b:	55                   	push   %ebp
  80088c:	89 e5                	mov    %esp,%ebp
  80088e:	56                   	push   %esi
  80088f:	53                   	push   %ebx
  800890:	8b 75 08             	mov    0x8(%ebp),%esi
  800893:	8b 55 0c             	mov    0xc(%ebp),%edx
  800896:	89 f3                	mov    %esi,%ebx
  800898:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80089b:	89 f0                	mov    %esi,%eax
  80089d:	39 d8                	cmp    %ebx,%eax
  80089f:	74 11                	je     8008b2 <strncpy+0x2b>
		*dst++ = *src;
  8008a1:	83 c0 01             	add    $0x1,%eax
  8008a4:	0f b6 0a             	movzbl (%edx),%ecx
  8008a7:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008aa:	80 f9 01             	cmp    $0x1,%cl
  8008ad:	83 da ff             	sbb    $0xffffffff,%edx
  8008b0:	eb eb                	jmp    80089d <strncpy+0x16>
	}
	return ret;
}
  8008b2:	89 f0                	mov    %esi,%eax
  8008b4:	5b                   	pop    %ebx
  8008b5:	5e                   	pop    %esi
  8008b6:	5d                   	pop    %ebp
  8008b7:	c3                   	ret    

008008b8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008b8:	f3 0f 1e fb          	endbr32 
  8008bc:	55                   	push   %ebp
  8008bd:	89 e5                	mov    %esp,%ebp
  8008bf:	56                   	push   %esi
  8008c0:	53                   	push   %ebx
  8008c1:	8b 75 08             	mov    0x8(%ebp),%esi
  8008c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008c7:	8b 55 10             	mov    0x10(%ebp),%edx
  8008ca:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008cc:	85 d2                	test   %edx,%edx
  8008ce:	74 21                	je     8008f1 <strlcpy+0x39>
  8008d0:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008d4:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008d6:	39 c2                	cmp    %eax,%edx
  8008d8:	74 14                	je     8008ee <strlcpy+0x36>
  8008da:	0f b6 19             	movzbl (%ecx),%ebx
  8008dd:	84 db                	test   %bl,%bl
  8008df:	74 0b                	je     8008ec <strlcpy+0x34>
			*dst++ = *src++;
  8008e1:	83 c1 01             	add    $0x1,%ecx
  8008e4:	83 c2 01             	add    $0x1,%edx
  8008e7:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008ea:	eb ea                	jmp    8008d6 <strlcpy+0x1e>
  8008ec:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008ee:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008f1:	29 f0                	sub    %esi,%eax
}
  8008f3:	5b                   	pop    %ebx
  8008f4:	5e                   	pop    %esi
  8008f5:	5d                   	pop    %ebp
  8008f6:	c3                   	ret    

008008f7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008f7:	f3 0f 1e fb          	endbr32 
  8008fb:	55                   	push   %ebp
  8008fc:	89 e5                	mov    %esp,%ebp
  8008fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800901:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800904:	0f b6 01             	movzbl (%ecx),%eax
  800907:	84 c0                	test   %al,%al
  800909:	74 0c                	je     800917 <strcmp+0x20>
  80090b:	3a 02                	cmp    (%edx),%al
  80090d:	75 08                	jne    800917 <strcmp+0x20>
		p++, q++;
  80090f:	83 c1 01             	add    $0x1,%ecx
  800912:	83 c2 01             	add    $0x1,%edx
  800915:	eb ed                	jmp    800904 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800917:	0f b6 c0             	movzbl %al,%eax
  80091a:	0f b6 12             	movzbl (%edx),%edx
  80091d:	29 d0                	sub    %edx,%eax
}
  80091f:	5d                   	pop    %ebp
  800920:	c3                   	ret    

00800921 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800921:	f3 0f 1e fb          	endbr32 
  800925:	55                   	push   %ebp
  800926:	89 e5                	mov    %esp,%ebp
  800928:	53                   	push   %ebx
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80092f:	89 c3                	mov    %eax,%ebx
  800931:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800934:	eb 06                	jmp    80093c <strncmp+0x1b>
		n--, p++, q++;
  800936:	83 c0 01             	add    $0x1,%eax
  800939:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80093c:	39 d8                	cmp    %ebx,%eax
  80093e:	74 16                	je     800956 <strncmp+0x35>
  800940:	0f b6 08             	movzbl (%eax),%ecx
  800943:	84 c9                	test   %cl,%cl
  800945:	74 04                	je     80094b <strncmp+0x2a>
  800947:	3a 0a                	cmp    (%edx),%cl
  800949:	74 eb                	je     800936 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80094b:	0f b6 00             	movzbl (%eax),%eax
  80094e:	0f b6 12             	movzbl (%edx),%edx
  800951:	29 d0                	sub    %edx,%eax
}
  800953:	5b                   	pop    %ebx
  800954:	5d                   	pop    %ebp
  800955:	c3                   	ret    
		return 0;
  800956:	b8 00 00 00 00       	mov    $0x0,%eax
  80095b:	eb f6                	jmp    800953 <strncmp+0x32>

0080095d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80095d:	f3 0f 1e fb          	endbr32 
  800961:	55                   	push   %ebp
  800962:	89 e5                	mov    %esp,%ebp
  800964:	8b 45 08             	mov    0x8(%ebp),%eax
  800967:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80096b:	0f b6 10             	movzbl (%eax),%edx
  80096e:	84 d2                	test   %dl,%dl
  800970:	74 09                	je     80097b <strchr+0x1e>
		if (*s == c)
  800972:	38 ca                	cmp    %cl,%dl
  800974:	74 0a                	je     800980 <strchr+0x23>
	for (; *s; s++)
  800976:	83 c0 01             	add    $0x1,%eax
  800979:	eb f0                	jmp    80096b <strchr+0xe>
			return (char *) s;
	return 0;
  80097b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800980:	5d                   	pop    %ebp
  800981:	c3                   	ret    

00800982 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800982:	f3 0f 1e fb          	endbr32 
  800986:	55                   	push   %ebp
  800987:	89 e5                	mov    %esp,%ebp
  800989:	8b 45 08             	mov    0x8(%ebp),%eax
  80098c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800990:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800993:	38 ca                	cmp    %cl,%dl
  800995:	74 09                	je     8009a0 <strfind+0x1e>
  800997:	84 d2                	test   %dl,%dl
  800999:	74 05                	je     8009a0 <strfind+0x1e>
	for (; *s; s++)
  80099b:	83 c0 01             	add    $0x1,%eax
  80099e:	eb f0                	jmp    800990 <strfind+0xe>
			break;
	return (char *) s;
}
  8009a0:	5d                   	pop    %ebp
  8009a1:	c3                   	ret    

008009a2 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009a2:	f3 0f 1e fb          	endbr32 
  8009a6:	55                   	push   %ebp
  8009a7:	89 e5                	mov    %esp,%ebp
  8009a9:	57                   	push   %edi
  8009aa:	56                   	push   %esi
  8009ab:	53                   	push   %ebx
  8009ac:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009af:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009b2:	85 c9                	test   %ecx,%ecx
  8009b4:	74 31                	je     8009e7 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009b6:	89 f8                	mov    %edi,%eax
  8009b8:	09 c8                	or     %ecx,%eax
  8009ba:	a8 03                	test   $0x3,%al
  8009bc:	75 23                	jne    8009e1 <memset+0x3f>
		c &= 0xFF;
  8009be:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009c2:	89 d3                	mov    %edx,%ebx
  8009c4:	c1 e3 08             	shl    $0x8,%ebx
  8009c7:	89 d0                	mov    %edx,%eax
  8009c9:	c1 e0 18             	shl    $0x18,%eax
  8009cc:	89 d6                	mov    %edx,%esi
  8009ce:	c1 e6 10             	shl    $0x10,%esi
  8009d1:	09 f0                	or     %esi,%eax
  8009d3:	09 c2                	or     %eax,%edx
  8009d5:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009d7:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009da:	89 d0                	mov    %edx,%eax
  8009dc:	fc                   	cld    
  8009dd:	f3 ab                	rep stos %eax,%es:(%edi)
  8009df:	eb 06                	jmp    8009e7 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e4:	fc                   	cld    
  8009e5:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009e7:	89 f8                	mov    %edi,%eax
  8009e9:	5b                   	pop    %ebx
  8009ea:	5e                   	pop    %esi
  8009eb:	5f                   	pop    %edi
  8009ec:	5d                   	pop    %ebp
  8009ed:	c3                   	ret    

008009ee <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009ee:	f3 0f 1e fb          	endbr32 
  8009f2:	55                   	push   %ebp
  8009f3:	89 e5                	mov    %esp,%ebp
  8009f5:	57                   	push   %edi
  8009f6:	56                   	push   %esi
  8009f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fa:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009fd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a00:	39 c6                	cmp    %eax,%esi
  800a02:	73 32                	jae    800a36 <memmove+0x48>
  800a04:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a07:	39 c2                	cmp    %eax,%edx
  800a09:	76 2b                	jbe    800a36 <memmove+0x48>
		s += n;
		d += n;
  800a0b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a0e:	89 fe                	mov    %edi,%esi
  800a10:	09 ce                	or     %ecx,%esi
  800a12:	09 d6                	or     %edx,%esi
  800a14:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a1a:	75 0e                	jne    800a2a <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a1c:	83 ef 04             	sub    $0x4,%edi
  800a1f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a22:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a25:	fd                   	std    
  800a26:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a28:	eb 09                	jmp    800a33 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a2a:	83 ef 01             	sub    $0x1,%edi
  800a2d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a30:	fd                   	std    
  800a31:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a33:	fc                   	cld    
  800a34:	eb 1a                	jmp    800a50 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a36:	89 c2                	mov    %eax,%edx
  800a38:	09 ca                	or     %ecx,%edx
  800a3a:	09 f2                	or     %esi,%edx
  800a3c:	f6 c2 03             	test   $0x3,%dl
  800a3f:	75 0a                	jne    800a4b <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a41:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a44:	89 c7                	mov    %eax,%edi
  800a46:	fc                   	cld    
  800a47:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a49:	eb 05                	jmp    800a50 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800a4b:	89 c7                	mov    %eax,%edi
  800a4d:	fc                   	cld    
  800a4e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a50:	5e                   	pop    %esi
  800a51:	5f                   	pop    %edi
  800a52:	5d                   	pop    %ebp
  800a53:	c3                   	ret    

00800a54 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a54:	f3 0f 1e fb          	endbr32 
  800a58:	55                   	push   %ebp
  800a59:	89 e5                	mov    %esp,%ebp
  800a5b:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a5e:	ff 75 10             	pushl  0x10(%ebp)
  800a61:	ff 75 0c             	pushl  0xc(%ebp)
  800a64:	ff 75 08             	pushl  0x8(%ebp)
  800a67:	e8 82 ff ff ff       	call   8009ee <memmove>
}
  800a6c:	c9                   	leave  
  800a6d:	c3                   	ret    

00800a6e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a6e:	f3 0f 1e fb          	endbr32 
  800a72:	55                   	push   %ebp
  800a73:	89 e5                	mov    %esp,%ebp
  800a75:	56                   	push   %esi
  800a76:	53                   	push   %ebx
  800a77:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a7d:	89 c6                	mov    %eax,%esi
  800a7f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a82:	39 f0                	cmp    %esi,%eax
  800a84:	74 1c                	je     800aa2 <memcmp+0x34>
		if (*s1 != *s2)
  800a86:	0f b6 08             	movzbl (%eax),%ecx
  800a89:	0f b6 1a             	movzbl (%edx),%ebx
  800a8c:	38 d9                	cmp    %bl,%cl
  800a8e:	75 08                	jne    800a98 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a90:	83 c0 01             	add    $0x1,%eax
  800a93:	83 c2 01             	add    $0x1,%edx
  800a96:	eb ea                	jmp    800a82 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a98:	0f b6 c1             	movzbl %cl,%eax
  800a9b:	0f b6 db             	movzbl %bl,%ebx
  800a9e:	29 d8                	sub    %ebx,%eax
  800aa0:	eb 05                	jmp    800aa7 <memcmp+0x39>
	}

	return 0;
  800aa2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aa7:	5b                   	pop    %ebx
  800aa8:	5e                   	pop    %esi
  800aa9:	5d                   	pop    %ebp
  800aaa:	c3                   	ret    

00800aab <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800aab:	f3 0f 1e fb          	endbr32 
  800aaf:	55                   	push   %ebp
  800ab0:	89 e5                	mov    %esp,%ebp
  800ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ab8:	89 c2                	mov    %eax,%edx
  800aba:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800abd:	39 d0                	cmp    %edx,%eax
  800abf:	73 09                	jae    800aca <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ac1:	38 08                	cmp    %cl,(%eax)
  800ac3:	74 05                	je     800aca <memfind+0x1f>
	for (; s < ends; s++)
  800ac5:	83 c0 01             	add    $0x1,%eax
  800ac8:	eb f3                	jmp    800abd <memfind+0x12>
			break;
	return (void *) s;
}
  800aca:	5d                   	pop    %ebp
  800acb:	c3                   	ret    

00800acc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800acc:	f3 0f 1e fb          	endbr32 
  800ad0:	55                   	push   %ebp
  800ad1:	89 e5                	mov    %esp,%ebp
  800ad3:	57                   	push   %edi
  800ad4:	56                   	push   %esi
  800ad5:	53                   	push   %ebx
  800ad6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ad9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800adc:	eb 03                	jmp    800ae1 <strtol+0x15>
		s++;
  800ade:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ae1:	0f b6 01             	movzbl (%ecx),%eax
  800ae4:	3c 20                	cmp    $0x20,%al
  800ae6:	74 f6                	je     800ade <strtol+0x12>
  800ae8:	3c 09                	cmp    $0x9,%al
  800aea:	74 f2                	je     800ade <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800aec:	3c 2b                	cmp    $0x2b,%al
  800aee:	74 2a                	je     800b1a <strtol+0x4e>
	int neg = 0;
  800af0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800af5:	3c 2d                	cmp    $0x2d,%al
  800af7:	74 2b                	je     800b24 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800af9:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800aff:	75 0f                	jne    800b10 <strtol+0x44>
  800b01:	80 39 30             	cmpb   $0x30,(%ecx)
  800b04:	74 28                	je     800b2e <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b06:	85 db                	test   %ebx,%ebx
  800b08:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b0d:	0f 44 d8             	cmove  %eax,%ebx
  800b10:	b8 00 00 00 00       	mov    $0x0,%eax
  800b15:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b18:	eb 46                	jmp    800b60 <strtol+0x94>
		s++;
  800b1a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b1d:	bf 00 00 00 00       	mov    $0x0,%edi
  800b22:	eb d5                	jmp    800af9 <strtol+0x2d>
		s++, neg = 1;
  800b24:	83 c1 01             	add    $0x1,%ecx
  800b27:	bf 01 00 00 00       	mov    $0x1,%edi
  800b2c:	eb cb                	jmp    800af9 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b2e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b32:	74 0e                	je     800b42 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b34:	85 db                	test   %ebx,%ebx
  800b36:	75 d8                	jne    800b10 <strtol+0x44>
		s++, base = 8;
  800b38:	83 c1 01             	add    $0x1,%ecx
  800b3b:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b40:	eb ce                	jmp    800b10 <strtol+0x44>
		s += 2, base = 16;
  800b42:	83 c1 02             	add    $0x2,%ecx
  800b45:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b4a:	eb c4                	jmp    800b10 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b4c:	0f be d2             	movsbl %dl,%edx
  800b4f:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b52:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b55:	7d 3a                	jge    800b91 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b57:	83 c1 01             	add    $0x1,%ecx
  800b5a:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b5e:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b60:	0f b6 11             	movzbl (%ecx),%edx
  800b63:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b66:	89 f3                	mov    %esi,%ebx
  800b68:	80 fb 09             	cmp    $0x9,%bl
  800b6b:	76 df                	jbe    800b4c <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b6d:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b70:	89 f3                	mov    %esi,%ebx
  800b72:	80 fb 19             	cmp    $0x19,%bl
  800b75:	77 08                	ja     800b7f <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b77:	0f be d2             	movsbl %dl,%edx
  800b7a:	83 ea 57             	sub    $0x57,%edx
  800b7d:	eb d3                	jmp    800b52 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b7f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b82:	89 f3                	mov    %esi,%ebx
  800b84:	80 fb 19             	cmp    $0x19,%bl
  800b87:	77 08                	ja     800b91 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b89:	0f be d2             	movsbl %dl,%edx
  800b8c:	83 ea 37             	sub    $0x37,%edx
  800b8f:	eb c1                	jmp    800b52 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b91:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b95:	74 05                	je     800b9c <strtol+0xd0>
		*endptr = (char *) s;
  800b97:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b9a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b9c:	89 c2                	mov    %eax,%edx
  800b9e:	f7 da                	neg    %edx
  800ba0:	85 ff                	test   %edi,%edi
  800ba2:	0f 45 c2             	cmovne %edx,%eax
}
  800ba5:	5b                   	pop    %ebx
  800ba6:	5e                   	pop    %esi
  800ba7:	5f                   	pop    %edi
  800ba8:	5d                   	pop    %ebp
  800ba9:	c3                   	ret    

00800baa <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800baa:	f3 0f 1e fb          	endbr32 
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	57                   	push   %edi
  800bb2:	56                   	push   %esi
  800bb3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bb4:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bbf:	89 c3                	mov    %eax,%ebx
  800bc1:	89 c7                	mov    %eax,%edi
  800bc3:	89 c6                	mov    %eax,%esi
  800bc5:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bc7:	5b                   	pop    %ebx
  800bc8:	5e                   	pop    %esi
  800bc9:	5f                   	pop    %edi
  800bca:	5d                   	pop    %ebp
  800bcb:	c3                   	ret    

00800bcc <sys_cgetc>:

int
sys_cgetc(void)
{
  800bcc:	f3 0f 1e fb          	endbr32 
  800bd0:	55                   	push   %ebp
  800bd1:	89 e5                	mov    %esp,%ebp
  800bd3:	57                   	push   %edi
  800bd4:	56                   	push   %esi
  800bd5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd6:	ba 00 00 00 00       	mov    $0x0,%edx
  800bdb:	b8 01 00 00 00       	mov    $0x1,%eax
  800be0:	89 d1                	mov    %edx,%ecx
  800be2:	89 d3                	mov    %edx,%ebx
  800be4:	89 d7                	mov    %edx,%edi
  800be6:	89 d6                	mov    %edx,%esi
  800be8:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bea:	5b                   	pop    %ebx
  800beb:	5e                   	pop    %esi
  800bec:	5f                   	pop    %edi
  800bed:	5d                   	pop    %ebp
  800bee:	c3                   	ret    

00800bef <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bef:	f3 0f 1e fb          	endbr32 
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	57                   	push   %edi
  800bf7:	56                   	push   %esi
  800bf8:	53                   	push   %ebx
  800bf9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bfc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c01:	8b 55 08             	mov    0x8(%ebp),%edx
  800c04:	b8 03 00 00 00       	mov    $0x3,%eax
  800c09:	89 cb                	mov    %ecx,%ebx
  800c0b:	89 cf                	mov    %ecx,%edi
  800c0d:	89 ce                	mov    %ecx,%esi
  800c0f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c11:	85 c0                	test   %eax,%eax
  800c13:	7f 08                	jg     800c1d <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c15:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c18:	5b                   	pop    %ebx
  800c19:	5e                   	pop    %esi
  800c1a:	5f                   	pop    %edi
  800c1b:	5d                   	pop    %ebp
  800c1c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c1d:	83 ec 0c             	sub    $0xc,%esp
  800c20:	50                   	push   %eax
  800c21:	6a 03                	push   $0x3
  800c23:	68 e4 16 80 00       	push   $0x8016e4
  800c28:	6a 23                	push   $0x23
  800c2a:	68 01 17 80 00       	push   $0x801701
  800c2f:	e8 13 f5 ff ff       	call   800147 <_panic>

00800c34 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c34:	f3 0f 1e fb          	endbr32 
  800c38:	55                   	push   %ebp
  800c39:	89 e5                	mov    %esp,%ebp
  800c3b:	57                   	push   %edi
  800c3c:	56                   	push   %esi
  800c3d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c3e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c43:	b8 02 00 00 00       	mov    $0x2,%eax
  800c48:	89 d1                	mov    %edx,%ecx
  800c4a:	89 d3                	mov    %edx,%ebx
  800c4c:	89 d7                	mov    %edx,%edi
  800c4e:	89 d6                	mov    %edx,%esi
  800c50:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c52:	5b                   	pop    %ebx
  800c53:	5e                   	pop    %esi
  800c54:	5f                   	pop    %edi
  800c55:	5d                   	pop    %ebp
  800c56:	c3                   	ret    

00800c57 <sys_yield>:

void
sys_yield(void)
{
  800c57:	f3 0f 1e fb          	endbr32 
  800c5b:	55                   	push   %ebp
  800c5c:	89 e5                	mov    %esp,%ebp
  800c5e:	57                   	push   %edi
  800c5f:	56                   	push   %esi
  800c60:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c61:	ba 00 00 00 00       	mov    $0x0,%edx
  800c66:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c6b:	89 d1                	mov    %edx,%ecx
  800c6d:	89 d3                	mov    %edx,%ebx
  800c6f:	89 d7                	mov    %edx,%edi
  800c71:	89 d6                	mov    %edx,%esi
  800c73:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c75:	5b                   	pop    %ebx
  800c76:	5e                   	pop    %esi
  800c77:	5f                   	pop    %edi
  800c78:	5d                   	pop    %ebp
  800c79:	c3                   	ret    

00800c7a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c7a:	f3 0f 1e fb          	endbr32 
  800c7e:	55                   	push   %ebp
  800c7f:	89 e5                	mov    %esp,%ebp
  800c81:	57                   	push   %edi
  800c82:	56                   	push   %esi
  800c83:	53                   	push   %ebx
  800c84:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c87:	be 00 00 00 00       	mov    $0x0,%esi
  800c8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c92:	b8 04 00 00 00       	mov    $0x4,%eax
  800c97:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c9a:	89 f7                	mov    %esi,%edi
  800c9c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c9e:	85 c0                	test   %eax,%eax
  800ca0:	7f 08                	jg     800caa <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800cae:	6a 04                	push   $0x4
  800cb0:	68 e4 16 80 00       	push   $0x8016e4
  800cb5:	6a 23                	push   $0x23
  800cb7:	68 01 17 80 00       	push   $0x801701
  800cbc:	e8 86 f4 ff ff       	call   800147 <_panic>

00800cc1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cc1:	f3 0f 1e fb          	endbr32 
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	57                   	push   %edi
  800cc9:	56                   	push   %esi
  800cca:	53                   	push   %ebx
  800ccb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cce:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd4:	b8 05 00 00 00       	mov    $0x5,%eax
  800cd9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cdc:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cdf:	8b 75 18             	mov    0x18(%ebp),%esi
  800ce2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce4:	85 c0                	test   %eax,%eax
  800ce6:	7f 08                	jg     800cf0 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  800cf4:	6a 05                	push   $0x5
  800cf6:	68 e4 16 80 00       	push   $0x8016e4
  800cfb:	6a 23                	push   $0x23
  800cfd:	68 01 17 80 00       	push   $0x801701
  800d02:	e8 40 f4 ff ff       	call   800147 <_panic>

00800d07 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
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
  800d1f:	b8 06 00 00 00       	mov    $0x6,%eax
  800d24:	89 df                	mov    %ebx,%edi
  800d26:	89 de                	mov    %ebx,%esi
  800d28:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d2a:	85 c0                	test   %eax,%eax
  800d2c:	7f 08                	jg     800d36 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  800d3a:	6a 06                	push   $0x6
  800d3c:	68 e4 16 80 00       	push   $0x8016e4
  800d41:	6a 23                	push   $0x23
  800d43:	68 01 17 80 00       	push   $0x801701
  800d48:	e8 fa f3 ff ff       	call   800147 <_panic>

00800d4d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d4d:	f3 0f 1e fb          	endbr32 
  800d51:	55                   	push   %ebp
  800d52:	89 e5                	mov    %esp,%ebp
  800d54:	57                   	push   %edi
  800d55:	56                   	push   %esi
  800d56:	53                   	push   %ebx
  800d57:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d5a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d65:	b8 08 00 00 00       	mov    $0x8,%eax
  800d6a:	89 df                	mov    %ebx,%edi
  800d6c:	89 de                	mov    %ebx,%esi
  800d6e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d70:	85 c0                	test   %eax,%eax
  800d72:	7f 08                	jg     800d7c <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d74:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d77:	5b                   	pop    %ebx
  800d78:	5e                   	pop    %esi
  800d79:	5f                   	pop    %edi
  800d7a:	5d                   	pop    %ebp
  800d7b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7c:	83 ec 0c             	sub    $0xc,%esp
  800d7f:	50                   	push   %eax
  800d80:	6a 08                	push   $0x8
  800d82:	68 e4 16 80 00       	push   $0x8016e4
  800d87:	6a 23                	push   $0x23
  800d89:	68 01 17 80 00       	push   $0x801701
  800d8e:	e8 b4 f3 ff ff       	call   800147 <_panic>

00800d93 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d93:	f3 0f 1e fb          	endbr32 
  800d97:	55                   	push   %ebp
  800d98:	89 e5                	mov    %esp,%ebp
  800d9a:	57                   	push   %edi
  800d9b:	56                   	push   %esi
  800d9c:	53                   	push   %ebx
  800d9d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da5:	8b 55 08             	mov    0x8(%ebp),%edx
  800da8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dab:	b8 09 00 00 00       	mov    $0x9,%eax
  800db0:	89 df                	mov    %ebx,%edi
  800db2:	89 de                	mov    %ebx,%esi
  800db4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db6:	85 c0                	test   %eax,%eax
  800db8:	7f 08                	jg     800dc2 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dbd:	5b                   	pop    %ebx
  800dbe:	5e                   	pop    %esi
  800dbf:	5f                   	pop    %edi
  800dc0:	5d                   	pop    %ebp
  800dc1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc2:	83 ec 0c             	sub    $0xc,%esp
  800dc5:	50                   	push   %eax
  800dc6:	6a 09                	push   $0x9
  800dc8:	68 e4 16 80 00       	push   $0x8016e4
  800dcd:	6a 23                	push   $0x23
  800dcf:	68 01 17 80 00       	push   $0x801701
  800dd4:	e8 6e f3 ff ff       	call   800147 <_panic>

00800dd9 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dd9:	f3 0f 1e fb          	endbr32 
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	57                   	push   %edi
  800de1:	56                   	push   %esi
  800de2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800de3:	8b 55 08             	mov    0x8(%ebp),%edx
  800de6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de9:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dee:	be 00 00 00 00       	mov    $0x0,%esi
  800df3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800df6:	8b 7d 14             	mov    0x14(%ebp),%edi
  800df9:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800dfb:	5b                   	pop    %ebx
  800dfc:	5e                   	pop    %esi
  800dfd:	5f                   	pop    %edi
  800dfe:	5d                   	pop    %ebp
  800dff:	c3                   	ret    

00800e00 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e00:	f3 0f 1e fb          	endbr32 
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	57                   	push   %edi
  800e08:	56                   	push   %esi
  800e09:	53                   	push   %ebx
  800e0a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e0d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e12:	8b 55 08             	mov    0x8(%ebp),%edx
  800e15:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e1a:	89 cb                	mov    %ecx,%ebx
  800e1c:	89 cf                	mov    %ecx,%edi
  800e1e:	89 ce                	mov    %ecx,%esi
  800e20:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e22:	85 c0                	test   %eax,%eax
  800e24:	7f 08                	jg     800e2e <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e26:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e29:	5b                   	pop    %ebx
  800e2a:	5e                   	pop    %esi
  800e2b:	5f                   	pop    %edi
  800e2c:	5d                   	pop    %ebp
  800e2d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e2e:	83 ec 0c             	sub    $0xc,%esp
  800e31:	50                   	push   %eax
  800e32:	6a 0c                	push   $0xc
  800e34:	68 e4 16 80 00       	push   $0x8016e4
  800e39:	6a 23                	push   $0x23
  800e3b:	68 01 17 80 00       	push   $0x801701
  800e40:	e8 02 f3 ff ff       	call   800147 <_panic>

00800e45 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800e45:	f3 0f 1e fb          	endbr32 
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
  800e4c:	53                   	push   %ebx
  800e4d:	83 ec 04             	sub    $0x4,%esp
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800e53:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  800e55:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800e59:	74 74                	je     800ecf <pgfault+0x8a>
  800e5b:	89 d8                	mov    %ebx,%eax
  800e5d:	c1 e8 0c             	shr    $0xc,%eax
  800e60:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800e67:	f6 c4 08             	test   $0x8,%ah
  800e6a:	74 63                	je     800ecf <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800e6c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  800e72:	83 ec 0c             	sub    $0xc,%esp
  800e75:	6a 05                	push   $0x5
  800e77:	68 00 f0 7f 00       	push   $0x7ff000
  800e7c:	6a 00                	push   $0x0
  800e7e:	53                   	push   %ebx
  800e7f:	6a 00                	push   $0x0
  800e81:	e8 3b fe ff ff       	call   800cc1 <sys_page_map>
  800e86:	83 c4 20             	add    $0x20,%esp
  800e89:	85 c0                	test   %eax,%eax
  800e8b:	78 59                	js     800ee6 <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  800e8d:	83 ec 04             	sub    $0x4,%esp
  800e90:	6a 07                	push   $0x7
  800e92:	53                   	push   %ebx
  800e93:	6a 00                	push   $0x0
  800e95:	e8 e0 fd ff ff       	call   800c7a <sys_page_alloc>
  800e9a:	83 c4 10             	add    $0x10,%esp
  800e9d:	85 c0                	test   %eax,%eax
  800e9f:	78 5a                	js     800efb <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  800ea1:	83 ec 04             	sub    $0x4,%esp
  800ea4:	68 00 10 00 00       	push   $0x1000
  800ea9:	68 00 f0 7f 00       	push   $0x7ff000
  800eae:	53                   	push   %ebx
  800eaf:	e8 3a fb ff ff       	call   8009ee <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  800eb4:	83 c4 08             	add    $0x8,%esp
  800eb7:	68 00 f0 7f 00       	push   $0x7ff000
  800ebc:	6a 00                	push   $0x0
  800ebe:	e8 44 fe ff ff       	call   800d07 <sys_page_unmap>
  800ec3:	83 c4 10             	add    $0x10,%esp
  800ec6:	85 c0                	test   %eax,%eax
  800ec8:	78 46                	js     800f10 <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  800eca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ecd:	c9                   	leave  
  800ece:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  800ecf:	83 ec 04             	sub    $0x4,%esp
  800ed2:	68 0f 17 80 00       	push   $0x80170f
  800ed7:	68 d3 00 00 00       	push   $0xd3
  800edc:	68 2b 17 80 00       	push   $0x80172b
  800ee1:	e8 61 f2 ff ff       	call   800147 <_panic>
		panic("pgfault: %e\n", r);
  800ee6:	50                   	push   %eax
  800ee7:	68 36 17 80 00       	push   $0x801736
  800eec:	68 df 00 00 00       	push   $0xdf
  800ef1:	68 2b 17 80 00       	push   $0x80172b
  800ef6:	e8 4c f2 ff ff       	call   800147 <_panic>
		panic("pgfault: %e\n", r);
  800efb:	50                   	push   %eax
  800efc:	68 36 17 80 00       	push   $0x801736
  800f01:	68 e3 00 00 00       	push   $0xe3
  800f06:	68 2b 17 80 00       	push   $0x80172b
  800f0b:	e8 37 f2 ff ff       	call   800147 <_panic>
		panic("pgfault: %e\n", r);
  800f10:	50                   	push   %eax
  800f11:	68 36 17 80 00       	push   $0x801736
  800f16:	68 e9 00 00 00       	push   $0xe9
  800f1b:	68 2b 17 80 00       	push   $0x80172b
  800f20:	e8 22 f2 ff ff       	call   800147 <_panic>

00800f25 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800f25:	f3 0f 1e fb          	endbr32 
  800f29:	55                   	push   %ebp
  800f2a:	89 e5                	mov    %esp,%ebp
  800f2c:	57                   	push   %edi
  800f2d:	56                   	push   %esi
  800f2e:	53                   	push   %ebx
  800f2f:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  800f32:	68 45 0e 80 00       	push   $0x800e45
  800f37:	e8 d4 01 00 00       	call   801110 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f3c:	b8 07 00 00 00       	mov    $0x7,%eax
  800f41:	cd 30                	int    $0x30
  800f43:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  800f46:	83 c4 10             	add    $0x10,%esp
  800f49:	85 c0                	test   %eax,%eax
  800f4b:	78 2d                	js     800f7a <fork+0x55>
  800f4d:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800f4f:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  800f54:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f58:	0f 85 81 00 00 00    	jne    800fdf <fork+0xba>
		thisenv = &envs[ENVX(sys_getenvid())];
  800f5e:	e8 d1 fc ff ff       	call   800c34 <sys_getenvid>
  800f63:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f68:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f6b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f70:	a3 08 20 80 00       	mov    %eax,0x802008
		return 0;
  800f75:	e9 43 01 00 00       	jmp    8010bd <fork+0x198>
		panic("sys_exofork: %e", envid);
  800f7a:	50                   	push   %eax
  800f7b:	68 43 17 80 00       	push   $0x801743
  800f80:	68 26 01 00 00       	push   $0x126
  800f85:	68 2b 17 80 00       	push   $0x80172b
  800f8a:	e8 b8 f1 ff ff       	call   800147 <_panic>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  800f8f:	c1 e6 0c             	shl    $0xc,%esi
  800f92:	83 ec 0c             	sub    $0xc,%esp
  800f95:	68 05 08 00 00       	push   $0x805
  800f9a:	56                   	push   %esi
  800f9b:	57                   	push   %edi
  800f9c:	56                   	push   %esi
  800f9d:	6a 00                	push   $0x0
  800f9f:	e8 1d fd ff ff       	call   800cc1 <sys_page_map>
  800fa4:	83 c4 20             	add    $0x20,%esp
  800fa7:	85 c0                	test   %eax,%eax
  800fa9:	0f 88 a8 00 00 00    	js     801057 <fork+0x132>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  800faf:	83 ec 0c             	sub    $0xc,%esp
  800fb2:	68 05 08 00 00       	push   $0x805
  800fb7:	56                   	push   %esi
  800fb8:	6a 00                	push   $0x0
  800fba:	56                   	push   %esi
  800fbb:	6a 00                	push   $0x0
  800fbd:	e8 ff fc ff ff       	call   800cc1 <sys_page_map>
  800fc2:	83 c4 20             	add    $0x20,%esp
  800fc5:	85 c0                	test   %eax,%eax
  800fc7:	0f 88 9f 00 00 00    	js     80106c <fork+0x147>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800fcd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800fd3:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  800fd9:	0f 84 a2 00 00 00    	je     801081 <fork+0x15c>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  800fdf:	89 d8                	mov    %ebx,%eax
  800fe1:	c1 e8 16             	shr    $0x16,%eax
  800fe4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800feb:	a8 01                	test   $0x1,%al
  800fed:	74 de                	je     800fcd <fork+0xa8>
  800fef:	89 de                	mov    %ebx,%esi
  800ff1:	c1 ee 0c             	shr    $0xc,%esi
  800ff4:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  800ffb:	a8 01                	test   $0x1,%al
  800ffd:	74 ce                	je     800fcd <fork+0xa8>
  800fff:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801006:	a8 04                	test   $0x4,%al
  801008:	74 c3                	je     800fcd <fork+0xa8>
	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  80100a:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801011:	a8 02                	test   $0x2,%al
  801013:	0f 85 76 ff ff ff    	jne    800f8f <fork+0x6a>
  801019:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801020:	f6 c4 08             	test   $0x8,%ah
  801023:	0f 85 66 ff ff ff    	jne    800f8f <fork+0x6a>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  801029:	c1 e6 0c             	shl    $0xc,%esi
  80102c:	83 ec 0c             	sub    $0xc,%esp
  80102f:	6a 05                	push   $0x5
  801031:	56                   	push   %esi
  801032:	57                   	push   %edi
  801033:	56                   	push   %esi
  801034:	6a 00                	push   $0x0
  801036:	e8 86 fc ff ff       	call   800cc1 <sys_page_map>
  80103b:	83 c4 20             	add    $0x20,%esp
  80103e:	85 c0                	test   %eax,%eax
  801040:	79 8b                	jns    800fcd <fork+0xa8>
		panic("duppage: %e\n", r);
  801042:	50                   	push   %eax
  801043:	68 53 17 80 00       	push   $0x801753
  801048:	68 08 01 00 00       	push   $0x108
  80104d:	68 2b 17 80 00       	push   $0x80172b
  801052:	e8 f0 f0 ff ff       	call   800147 <_panic>
			panic("duppage: %e\n", r);
  801057:	50                   	push   %eax
  801058:	68 53 17 80 00       	push   $0x801753
  80105d:	68 01 01 00 00       	push   $0x101
  801062:	68 2b 17 80 00       	push   $0x80172b
  801067:	e8 db f0 ff ff       	call   800147 <_panic>
			panic("duppage: %e\n", r);
  80106c:	50                   	push   %eax
  80106d:	68 53 17 80 00       	push   $0x801753
  801072:	68 05 01 00 00       	push   $0x105
  801077:	68 2b 17 80 00       	push   $0x80172b
  80107c:	e8 c6 f0 ff ff       	call   800147 <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  801081:	83 ec 04             	sub    $0x4,%esp
  801084:	6a 07                	push   $0x7
  801086:	68 00 f0 bf ee       	push   $0xeebff000
  80108b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80108e:	e8 e7 fb ff ff       	call   800c7a <sys_page_alloc>
  801093:	83 c4 10             	add    $0x10,%esp
  801096:	85 c0                	test   %eax,%eax
  801098:	78 2e                	js     8010c8 <fork+0x1a3>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  80109a:	83 ec 08             	sub    $0x8,%esp
  80109d:	68 83 11 80 00       	push   $0x801183
  8010a2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8010a5:	57                   	push   %edi
  8010a6:	e8 e8 fc ff ff       	call   800d93 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8010ab:	83 c4 08             	add    $0x8,%esp
  8010ae:	6a 02                	push   $0x2
  8010b0:	57                   	push   %edi
  8010b1:	e8 97 fc ff ff       	call   800d4d <sys_env_set_status>
  8010b6:	83 c4 10             	add    $0x10,%esp
  8010b9:	85 c0                	test   %eax,%eax
  8010bb:	78 20                	js     8010dd <fork+0x1b8>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  8010bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8010c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010c3:	5b                   	pop    %ebx
  8010c4:	5e                   	pop    %esi
  8010c5:	5f                   	pop    %edi
  8010c6:	5d                   	pop    %ebp
  8010c7:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  8010c8:	50                   	push   %eax
  8010c9:	68 60 17 80 00       	push   $0x801760
  8010ce:	68 3a 01 00 00       	push   $0x13a
  8010d3:	68 2b 17 80 00       	push   $0x80172b
  8010d8:	e8 6a f0 ff ff       	call   800147 <_panic>
		panic("sys_env_set_status: %e", r);
  8010dd:	50                   	push   %eax
  8010de:	68 73 17 80 00       	push   $0x801773
  8010e3:	68 3f 01 00 00       	push   $0x13f
  8010e8:	68 2b 17 80 00       	push   $0x80172b
  8010ed:	e8 55 f0 ff ff       	call   800147 <_panic>

008010f2 <sfork>:

// Challenge!
int
sfork(void)
{
  8010f2:	f3 0f 1e fb          	endbr32 
  8010f6:	55                   	push   %ebp
  8010f7:	89 e5                	mov    %esp,%ebp
  8010f9:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8010fc:	68 8a 17 80 00       	push   $0x80178a
  801101:	68 48 01 00 00       	push   $0x148
  801106:	68 2b 17 80 00       	push   $0x80172b
  80110b:	e8 37 f0 ff ff       	call   800147 <_panic>

00801110 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801110:	f3 0f 1e fb          	endbr32 
  801114:	55                   	push   %ebp
  801115:	89 e5                	mov    %esp,%ebp
  801117:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80111a:	83 3d 0c 20 80 00 00 	cmpl   $0x0,0x80200c
  801121:	74 0a                	je     80112d <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	a3 0c 20 80 00       	mov    %eax,0x80200c
}
  80112b:	c9                   	leave  
  80112c:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  80112d:	83 ec 04             	sub    $0x4,%esp
  801130:	6a 07                	push   $0x7
  801132:	68 00 f0 bf ee       	push   $0xeebff000
  801137:	6a 00                	push   $0x0
  801139:	e8 3c fb ff ff       	call   800c7a <sys_page_alloc>
  80113e:	83 c4 10             	add    $0x10,%esp
  801141:	85 c0                	test   %eax,%eax
  801143:	78 2a                	js     80116f <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  801145:	83 ec 08             	sub    $0x8,%esp
  801148:	68 83 11 80 00       	push   $0x801183
  80114d:	6a 00                	push   $0x0
  80114f:	e8 3f fc ff ff       	call   800d93 <sys_env_set_pgfault_upcall>
  801154:	83 c4 10             	add    $0x10,%esp
  801157:	85 c0                	test   %eax,%eax
  801159:	79 c8                	jns    801123 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  80115b:	83 ec 04             	sub    $0x4,%esp
  80115e:	68 cc 17 80 00       	push   $0x8017cc
  801163:	6a 25                	push   $0x25
  801165:	68 04 18 80 00       	push   $0x801804
  80116a:	e8 d8 ef ff ff       	call   800147 <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  80116f:	83 ec 04             	sub    $0x4,%esp
  801172:	68 a0 17 80 00       	push   $0x8017a0
  801177:	6a 22                	push   $0x22
  801179:	68 04 18 80 00       	push   $0x801804
  80117e:	e8 c4 ef ff ff       	call   800147 <_panic>

00801183 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801183:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801184:	a1 0c 20 80 00       	mov    0x80200c,%eax
	call *%eax
  801189:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80118b:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  80118e:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  801192:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  801196:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  801199:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  80119b:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  80119f:	83 c4 08             	add    $0x8,%esp
	popal
  8011a2:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  8011a3:	83 c4 04             	add    $0x4,%esp
	popfl
  8011a6:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  8011a7:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  8011a8:	c3                   	ret    
  8011a9:	66 90                	xchg   %ax,%ax
  8011ab:	66 90                	xchg   %ax,%ax
  8011ad:	66 90                	xchg   %ax,%ax
  8011af:	90                   	nop

008011b0 <__udivdi3>:
  8011b0:	f3 0f 1e fb          	endbr32 
  8011b4:	55                   	push   %ebp
  8011b5:	57                   	push   %edi
  8011b6:	56                   	push   %esi
  8011b7:	53                   	push   %ebx
  8011b8:	83 ec 1c             	sub    $0x1c,%esp
  8011bb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8011bf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8011c3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8011c7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8011cb:	85 d2                	test   %edx,%edx
  8011cd:	75 19                	jne    8011e8 <__udivdi3+0x38>
  8011cf:	39 f3                	cmp    %esi,%ebx
  8011d1:	76 4d                	jbe    801220 <__udivdi3+0x70>
  8011d3:	31 ff                	xor    %edi,%edi
  8011d5:	89 e8                	mov    %ebp,%eax
  8011d7:	89 f2                	mov    %esi,%edx
  8011d9:	f7 f3                	div    %ebx
  8011db:	89 fa                	mov    %edi,%edx
  8011dd:	83 c4 1c             	add    $0x1c,%esp
  8011e0:	5b                   	pop    %ebx
  8011e1:	5e                   	pop    %esi
  8011e2:	5f                   	pop    %edi
  8011e3:	5d                   	pop    %ebp
  8011e4:	c3                   	ret    
  8011e5:	8d 76 00             	lea    0x0(%esi),%esi
  8011e8:	39 f2                	cmp    %esi,%edx
  8011ea:	76 14                	jbe    801200 <__udivdi3+0x50>
  8011ec:	31 ff                	xor    %edi,%edi
  8011ee:	31 c0                	xor    %eax,%eax
  8011f0:	89 fa                	mov    %edi,%edx
  8011f2:	83 c4 1c             	add    $0x1c,%esp
  8011f5:	5b                   	pop    %ebx
  8011f6:	5e                   	pop    %esi
  8011f7:	5f                   	pop    %edi
  8011f8:	5d                   	pop    %ebp
  8011f9:	c3                   	ret    
  8011fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801200:	0f bd fa             	bsr    %edx,%edi
  801203:	83 f7 1f             	xor    $0x1f,%edi
  801206:	75 48                	jne    801250 <__udivdi3+0xa0>
  801208:	39 f2                	cmp    %esi,%edx
  80120a:	72 06                	jb     801212 <__udivdi3+0x62>
  80120c:	31 c0                	xor    %eax,%eax
  80120e:	39 eb                	cmp    %ebp,%ebx
  801210:	77 de                	ja     8011f0 <__udivdi3+0x40>
  801212:	b8 01 00 00 00       	mov    $0x1,%eax
  801217:	eb d7                	jmp    8011f0 <__udivdi3+0x40>
  801219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801220:	89 d9                	mov    %ebx,%ecx
  801222:	85 db                	test   %ebx,%ebx
  801224:	75 0b                	jne    801231 <__udivdi3+0x81>
  801226:	b8 01 00 00 00       	mov    $0x1,%eax
  80122b:	31 d2                	xor    %edx,%edx
  80122d:	f7 f3                	div    %ebx
  80122f:	89 c1                	mov    %eax,%ecx
  801231:	31 d2                	xor    %edx,%edx
  801233:	89 f0                	mov    %esi,%eax
  801235:	f7 f1                	div    %ecx
  801237:	89 c6                	mov    %eax,%esi
  801239:	89 e8                	mov    %ebp,%eax
  80123b:	89 f7                	mov    %esi,%edi
  80123d:	f7 f1                	div    %ecx
  80123f:	89 fa                	mov    %edi,%edx
  801241:	83 c4 1c             	add    $0x1c,%esp
  801244:	5b                   	pop    %ebx
  801245:	5e                   	pop    %esi
  801246:	5f                   	pop    %edi
  801247:	5d                   	pop    %ebp
  801248:	c3                   	ret    
  801249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801250:	89 f9                	mov    %edi,%ecx
  801252:	b8 20 00 00 00       	mov    $0x20,%eax
  801257:	29 f8                	sub    %edi,%eax
  801259:	d3 e2                	shl    %cl,%edx
  80125b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80125f:	89 c1                	mov    %eax,%ecx
  801261:	89 da                	mov    %ebx,%edx
  801263:	d3 ea                	shr    %cl,%edx
  801265:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801269:	09 d1                	or     %edx,%ecx
  80126b:	89 f2                	mov    %esi,%edx
  80126d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801271:	89 f9                	mov    %edi,%ecx
  801273:	d3 e3                	shl    %cl,%ebx
  801275:	89 c1                	mov    %eax,%ecx
  801277:	d3 ea                	shr    %cl,%edx
  801279:	89 f9                	mov    %edi,%ecx
  80127b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80127f:	89 eb                	mov    %ebp,%ebx
  801281:	d3 e6                	shl    %cl,%esi
  801283:	89 c1                	mov    %eax,%ecx
  801285:	d3 eb                	shr    %cl,%ebx
  801287:	09 de                	or     %ebx,%esi
  801289:	89 f0                	mov    %esi,%eax
  80128b:	f7 74 24 08          	divl   0x8(%esp)
  80128f:	89 d6                	mov    %edx,%esi
  801291:	89 c3                	mov    %eax,%ebx
  801293:	f7 64 24 0c          	mull   0xc(%esp)
  801297:	39 d6                	cmp    %edx,%esi
  801299:	72 15                	jb     8012b0 <__udivdi3+0x100>
  80129b:	89 f9                	mov    %edi,%ecx
  80129d:	d3 e5                	shl    %cl,%ebp
  80129f:	39 c5                	cmp    %eax,%ebp
  8012a1:	73 04                	jae    8012a7 <__udivdi3+0xf7>
  8012a3:	39 d6                	cmp    %edx,%esi
  8012a5:	74 09                	je     8012b0 <__udivdi3+0x100>
  8012a7:	89 d8                	mov    %ebx,%eax
  8012a9:	31 ff                	xor    %edi,%edi
  8012ab:	e9 40 ff ff ff       	jmp    8011f0 <__udivdi3+0x40>
  8012b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8012b3:	31 ff                	xor    %edi,%edi
  8012b5:	e9 36 ff ff ff       	jmp    8011f0 <__udivdi3+0x40>
  8012ba:	66 90                	xchg   %ax,%ax
  8012bc:	66 90                	xchg   %ax,%ax
  8012be:	66 90                	xchg   %ax,%ax

008012c0 <__umoddi3>:
  8012c0:	f3 0f 1e fb          	endbr32 
  8012c4:	55                   	push   %ebp
  8012c5:	57                   	push   %edi
  8012c6:	56                   	push   %esi
  8012c7:	53                   	push   %ebx
  8012c8:	83 ec 1c             	sub    $0x1c,%esp
  8012cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8012cf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8012d3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8012d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8012db:	85 c0                	test   %eax,%eax
  8012dd:	75 19                	jne    8012f8 <__umoddi3+0x38>
  8012df:	39 df                	cmp    %ebx,%edi
  8012e1:	76 5d                	jbe    801340 <__umoddi3+0x80>
  8012e3:	89 f0                	mov    %esi,%eax
  8012e5:	89 da                	mov    %ebx,%edx
  8012e7:	f7 f7                	div    %edi
  8012e9:	89 d0                	mov    %edx,%eax
  8012eb:	31 d2                	xor    %edx,%edx
  8012ed:	83 c4 1c             	add    $0x1c,%esp
  8012f0:	5b                   	pop    %ebx
  8012f1:	5e                   	pop    %esi
  8012f2:	5f                   	pop    %edi
  8012f3:	5d                   	pop    %ebp
  8012f4:	c3                   	ret    
  8012f5:	8d 76 00             	lea    0x0(%esi),%esi
  8012f8:	89 f2                	mov    %esi,%edx
  8012fa:	39 d8                	cmp    %ebx,%eax
  8012fc:	76 12                	jbe    801310 <__umoddi3+0x50>
  8012fe:	89 f0                	mov    %esi,%eax
  801300:	89 da                	mov    %ebx,%edx
  801302:	83 c4 1c             	add    $0x1c,%esp
  801305:	5b                   	pop    %ebx
  801306:	5e                   	pop    %esi
  801307:	5f                   	pop    %edi
  801308:	5d                   	pop    %ebp
  801309:	c3                   	ret    
  80130a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801310:	0f bd e8             	bsr    %eax,%ebp
  801313:	83 f5 1f             	xor    $0x1f,%ebp
  801316:	75 50                	jne    801368 <__umoddi3+0xa8>
  801318:	39 d8                	cmp    %ebx,%eax
  80131a:	0f 82 e0 00 00 00    	jb     801400 <__umoddi3+0x140>
  801320:	89 d9                	mov    %ebx,%ecx
  801322:	39 f7                	cmp    %esi,%edi
  801324:	0f 86 d6 00 00 00    	jbe    801400 <__umoddi3+0x140>
  80132a:	89 d0                	mov    %edx,%eax
  80132c:	89 ca                	mov    %ecx,%edx
  80132e:	83 c4 1c             	add    $0x1c,%esp
  801331:	5b                   	pop    %ebx
  801332:	5e                   	pop    %esi
  801333:	5f                   	pop    %edi
  801334:	5d                   	pop    %ebp
  801335:	c3                   	ret    
  801336:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80133d:	8d 76 00             	lea    0x0(%esi),%esi
  801340:	89 fd                	mov    %edi,%ebp
  801342:	85 ff                	test   %edi,%edi
  801344:	75 0b                	jne    801351 <__umoddi3+0x91>
  801346:	b8 01 00 00 00       	mov    $0x1,%eax
  80134b:	31 d2                	xor    %edx,%edx
  80134d:	f7 f7                	div    %edi
  80134f:	89 c5                	mov    %eax,%ebp
  801351:	89 d8                	mov    %ebx,%eax
  801353:	31 d2                	xor    %edx,%edx
  801355:	f7 f5                	div    %ebp
  801357:	89 f0                	mov    %esi,%eax
  801359:	f7 f5                	div    %ebp
  80135b:	89 d0                	mov    %edx,%eax
  80135d:	31 d2                	xor    %edx,%edx
  80135f:	eb 8c                	jmp    8012ed <__umoddi3+0x2d>
  801361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801368:	89 e9                	mov    %ebp,%ecx
  80136a:	ba 20 00 00 00       	mov    $0x20,%edx
  80136f:	29 ea                	sub    %ebp,%edx
  801371:	d3 e0                	shl    %cl,%eax
  801373:	89 44 24 08          	mov    %eax,0x8(%esp)
  801377:	89 d1                	mov    %edx,%ecx
  801379:	89 f8                	mov    %edi,%eax
  80137b:	d3 e8                	shr    %cl,%eax
  80137d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801381:	89 54 24 04          	mov    %edx,0x4(%esp)
  801385:	8b 54 24 04          	mov    0x4(%esp),%edx
  801389:	09 c1                	or     %eax,%ecx
  80138b:	89 d8                	mov    %ebx,%eax
  80138d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801391:	89 e9                	mov    %ebp,%ecx
  801393:	d3 e7                	shl    %cl,%edi
  801395:	89 d1                	mov    %edx,%ecx
  801397:	d3 e8                	shr    %cl,%eax
  801399:	89 e9                	mov    %ebp,%ecx
  80139b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80139f:	d3 e3                	shl    %cl,%ebx
  8013a1:	89 c7                	mov    %eax,%edi
  8013a3:	89 d1                	mov    %edx,%ecx
  8013a5:	89 f0                	mov    %esi,%eax
  8013a7:	d3 e8                	shr    %cl,%eax
  8013a9:	89 e9                	mov    %ebp,%ecx
  8013ab:	89 fa                	mov    %edi,%edx
  8013ad:	d3 e6                	shl    %cl,%esi
  8013af:	09 d8                	or     %ebx,%eax
  8013b1:	f7 74 24 08          	divl   0x8(%esp)
  8013b5:	89 d1                	mov    %edx,%ecx
  8013b7:	89 f3                	mov    %esi,%ebx
  8013b9:	f7 64 24 0c          	mull   0xc(%esp)
  8013bd:	89 c6                	mov    %eax,%esi
  8013bf:	89 d7                	mov    %edx,%edi
  8013c1:	39 d1                	cmp    %edx,%ecx
  8013c3:	72 06                	jb     8013cb <__umoddi3+0x10b>
  8013c5:	75 10                	jne    8013d7 <__umoddi3+0x117>
  8013c7:	39 c3                	cmp    %eax,%ebx
  8013c9:	73 0c                	jae    8013d7 <__umoddi3+0x117>
  8013cb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8013cf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8013d3:	89 d7                	mov    %edx,%edi
  8013d5:	89 c6                	mov    %eax,%esi
  8013d7:	89 ca                	mov    %ecx,%edx
  8013d9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8013de:	29 f3                	sub    %esi,%ebx
  8013e0:	19 fa                	sbb    %edi,%edx
  8013e2:	89 d0                	mov    %edx,%eax
  8013e4:	d3 e0                	shl    %cl,%eax
  8013e6:	89 e9                	mov    %ebp,%ecx
  8013e8:	d3 eb                	shr    %cl,%ebx
  8013ea:	d3 ea                	shr    %cl,%edx
  8013ec:	09 d8                	or     %ebx,%eax
  8013ee:	83 c4 1c             	add    $0x1c,%esp
  8013f1:	5b                   	pop    %ebx
  8013f2:	5e                   	pop    %esi
  8013f3:	5f                   	pop    %edi
  8013f4:	5d                   	pop    %ebp
  8013f5:	c3                   	ret    
  8013f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8013fd:	8d 76 00             	lea    0x0(%esi),%esi
  801400:	29 fe                	sub    %edi,%esi
  801402:	19 c3                	sbb    %eax,%ebx
  801404:	89 f2                	mov    %esi,%edx
  801406:	89 d9                	mov    %ebx,%ecx
  801408:	e9 1d ff ff ff       	jmp    80132a <__umoddi3+0x6a>
