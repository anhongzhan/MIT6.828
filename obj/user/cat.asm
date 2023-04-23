
obj/user/cat.debug:     file format elf32-i386


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
  80002c:	e8 04 01 00 00       	call   800135 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <cat>:

char buf[8192];

void
cat(int f, char *s)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	56                   	push   %esi
  80003b:	53                   	push   %ebx
  80003c:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  80003f:	83 ec 04             	sub    $0x4,%esp
  800042:	68 00 20 00 00       	push   $0x2000
  800047:	68 20 40 80 00       	push   $0x804020
  80004c:	56                   	push   %esi
  80004d:	e8 4b 12 00 00       	call   80129d <read>
  800052:	89 c3                	mov    %eax,%ebx
  800054:	83 c4 10             	add    $0x10,%esp
  800057:	85 c0                	test   %eax,%eax
  800059:	7e 2f                	jle    80008a <cat+0x57>
		if ((r = write(1, buf, n)) != n)
  80005b:	83 ec 04             	sub    $0x4,%esp
  80005e:	53                   	push   %ebx
  80005f:	68 20 40 80 00       	push   $0x804020
  800064:	6a 01                	push   $0x1
  800066:	e8 08 13 00 00       	call   801373 <write>
  80006b:	83 c4 10             	add    $0x10,%esp
  80006e:	39 c3                	cmp    %eax,%ebx
  800070:	74 cd                	je     80003f <cat+0xc>
			panic("write error copying %s: %e", s, r);
  800072:	83 ec 0c             	sub    $0xc,%esp
  800075:	50                   	push   %eax
  800076:	ff 75 0c             	pushl  0xc(%ebp)
  800079:	68 80 26 80 00       	push   $0x802680
  80007e:	6a 0d                	push   $0xd
  800080:	68 9b 26 80 00       	push   $0x80269b
  800085:	e8 13 01 00 00       	call   80019d <_panic>
	if (n < 0)
  80008a:	78 07                	js     800093 <cat+0x60>
		panic("error reading %s: %e", s, n);
}
  80008c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008f:	5b                   	pop    %ebx
  800090:	5e                   	pop    %esi
  800091:	5d                   	pop    %ebp
  800092:	c3                   	ret    
		panic("error reading %s: %e", s, n);
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	50                   	push   %eax
  800097:	ff 75 0c             	pushl  0xc(%ebp)
  80009a:	68 a6 26 80 00       	push   $0x8026a6
  80009f:	6a 0f                	push   $0xf
  8000a1:	68 9b 26 80 00       	push   $0x80269b
  8000a6:	e8 f2 00 00 00       	call   80019d <_panic>

008000ab <umain>:

void
umain(int argc, char **argv)
{
  8000ab:	f3 0f 1e fb          	endbr32 
  8000af:	55                   	push   %ebp
  8000b0:	89 e5                	mov    %esp,%ebp
  8000b2:	57                   	push   %edi
  8000b3:	56                   	push   %esi
  8000b4:	53                   	push   %ebx
  8000b5:	83 ec 0c             	sub    $0xc,%esp
  8000b8:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int f, i;

	binaryname = "cat";
  8000bb:	c7 05 00 30 80 00 bb 	movl   $0x8026bb,0x803000
  8000c2:	26 80 00 
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  8000c5:	be 01 00 00 00       	mov    $0x1,%esi
	if (argc == 1)
  8000ca:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000ce:	75 31                	jne    800101 <umain+0x56>
		cat(0, "<stdin>");
  8000d0:	83 ec 08             	sub    $0x8,%esp
  8000d3:	68 bf 26 80 00       	push   $0x8026bf
  8000d8:	6a 00                	push   $0x0
  8000da:	e8 54 ff ff ff       	call   800033 <cat>
  8000df:	83 c4 10             	add    $0x10,%esp
			else {
				cat(f, argv[i]);
				close(f);
			}
		}
}
  8000e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000e5:	5b                   	pop    %ebx
  8000e6:	5e                   	pop    %esi
  8000e7:	5f                   	pop    %edi
  8000e8:	5d                   	pop    %ebp
  8000e9:	c3                   	ret    
				printf("can't open %s: %e\n", argv[i], f);
  8000ea:	83 ec 04             	sub    $0x4,%esp
  8000ed:	50                   	push   %eax
  8000ee:	ff 34 b7             	pushl  (%edi,%esi,4)
  8000f1:	68 c7 26 80 00       	push   $0x8026c7
  8000f6:	e8 ee 17 00 00       	call   8018e9 <printf>
  8000fb:	83 c4 10             	add    $0x10,%esp
		for (i = 1; i < argc; i++) {
  8000fe:	83 c6 01             	add    $0x1,%esi
  800101:	3b 75 08             	cmp    0x8(%ebp),%esi
  800104:	7d dc                	jge    8000e2 <umain+0x37>
			f = open(argv[i], O_RDONLY);
  800106:	83 ec 08             	sub    $0x8,%esp
  800109:	6a 00                	push   $0x0
  80010b:	ff 34 b7             	pushl  (%edi,%esi,4)
  80010e:	e8 1f 16 00 00       	call   801732 <open>
  800113:	89 c3                	mov    %eax,%ebx
			if (f < 0)
  800115:	83 c4 10             	add    $0x10,%esp
  800118:	85 c0                	test   %eax,%eax
  80011a:	78 ce                	js     8000ea <umain+0x3f>
				cat(f, argv[i]);
  80011c:	83 ec 08             	sub    $0x8,%esp
  80011f:	ff 34 b7             	pushl  (%edi,%esi,4)
  800122:	50                   	push   %eax
  800123:	e8 0b ff ff ff       	call   800033 <cat>
				close(f);
  800128:	89 1c 24             	mov    %ebx,(%esp)
  80012b:	e8 23 10 00 00       	call   801153 <close>
  800130:	83 c4 10             	add    $0x10,%esp
  800133:	eb c9                	jmp    8000fe <umain+0x53>

00800135 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800135:	f3 0f 1e fb          	endbr32 
  800139:	55                   	push   %ebp
  80013a:	89 e5                	mov    %esp,%ebp
  80013c:	56                   	push   %esi
  80013d:	53                   	push   %ebx
  80013e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800141:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800144:	e8 41 0b 00 00       	call   800c8a <sys_getenvid>
  800149:	25 ff 03 00 00       	and    $0x3ff,%eax
  80014e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800151:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800156:	a3 20 60 80 00       	mov    %eax,0x806020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80015b:	85 db                	test   %ebx,%ebx
  80015d:	7e 07                	jle    800166 <libmain+0x31>
		binaryname = argv[0];
  80015f:	8b 06                	mov    (%esi),%eax
  800161:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800166:	83 ec 08             	sub    $0x8,%esp
  800169:	56                   	push   %esi
  80016a:	53                   	push   %ebx
  80016b:	e8 3b ff ff ff       	call   8000ab <umain>

	// exit gracefully
	exit();
  800170:	e8 0a 00 00 00       	call   80017f <exit>
}
  800175:	83 c4 10             	add    $0x10,%esp
  800178:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80017b:	5b                   	pop    %ebx
  80017c:	5e                   	pop    %esi
  80017d:	5d                   	pop    %ebp
  80017e:	c3                   	ret    

0080017f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80017f:	f3 0f 1e fb          	endbr32 
  800183:	55                   	push   %ebp
  800184:	89 e5                	mov    %esp,%ebp
  800186:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800189:	e8 f6 0f 00 00       	call   801184 <close_all>
	sys_env_destroy(0);
  80018e:	83 ec 0c             	sub    $0xc,%esp
  800191:	6a 00                	push   $0x0
  800193:	e8 ad 0a 00 00       	call   800c45 <sys_env_destroy>
}
  800198:	83 c4 10             	add    $0x10,%esp
  80019b:	c9                   	leave  
  80019c:	c3                   	ret    

0080019d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80019d:	f3 0f 1e fb          	endbr32 
  8001a1:	55                   	push   %ebp
  8001a2:	89 e5                	mov    %esp,%ebp
  8001a4:	56                   	push   %esi
  8001a5:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8001a6:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001a9:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8001af:	e8 d6 0a 00 00       	call   800c8a <sys_getenvid>
  8001b4:	83 ec 0c             	sub    $0xc,%esp
  8001b7:	ff 75 0c             	pushl  0xc(%ebp)
  8001ba:	ff 75 08             	pushl  0x8(%ebp)
  8001bd:	56                   	push   %esi
  8001be:	50                   	push   %eax
  8001bf:	68 e4 26 80 00       	push   $0x8026e4
  8001c4:	e8 bb 00 00 00       	call   800284 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001c9:	83 c4 18             	add    $0x18,%esp
  8001cc:	53                   	push   %ebx
  8001cd:	ff 75 10             	pushl  0x10(%ebp)
  8001d0:	e8 5a 00 00 00       	call   80022f <vcprintf>
	cprintf("\n");
  8001d5:	c7 04 24 6c 2b 80 00 	movl   $0x802b6c,(%esp)
  8001dc:	e8 a3 00 00 00       	call   800284 <cprintf>
  8001e1:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001e4:	cc                   	int3   
  8001e5:	eb fd                	jmp    8001e4 <_panic+0x47>

008001e7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001e7:	f3 0f 1e fb          	endbr32 
  8001eb:	55                   	push   %ebp
  8001ec:	89 e5                	mov    %esp,%ebp
  8001ee:	53                   	push   %ebx
  8001ef:	83 ec 04             	sub    $0x4,%esp
  8001f2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001f5:	8b 13                	mov    (%ebx),%edx
  8001f7:	8d 42 01             	lea    0x1(%edx),%eax
  8001fa:	89 03                	mov    %eax,(%ebx)
  8001fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001ff:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800203:	3d ff 00 00 00       	cmp    $0xff,%eax
  800208:	74 09                	je     800213 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80020a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80020e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800211:	c9                   	leave  
  800212:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800213:	83 ec 08             	sub    $0x8,%esp
  800216:	68 ff 00 00 00       	push   $0xff
  80021b:	8d 43 08             	lea    0x8(%ebx),%eax
  80021e:	50                   	push   %eax
  80021f:	e8 dc 09 00 00       	call   800c00 <sys_cputs>
		b->idx = 0;
  800224:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	eb db                	jmp    80020a <putch+0x23>

0080022f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80022f:	f3 0f 1e fb          	endbr32 
  800233:	55                   	push   %ebp
  800234:	89 e5                	mov    %esp,%ebp
  800236:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80023c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800243:	00 00 00 
	b.cnt = 0;
  800246:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80024d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800250:	ff 75 0c             	pushl  0xc(%ebp)
  800253:	ff 75 08             	pushl  0x8(%ebp)
  800256:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80025c:	50                   	push   %eax
  80025d:	68 e7 01 80 00       	push   $0x8001e7
  800262:	e8 20 01 00 00       	call   800387 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800267:	83 c4 08             	add    $0x8,%esp
  80026a:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800270:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800276:	50                   	push   %eax
  800277:	e8 84 09 00 00       	call   800c00 <sys_cputs>

	return b.cnt;
}
  80027c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800282:	c9                   	leave  
  800283:	c3                   	ret    

00800284 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800284:	f3 0f 1e fb          	endbr32 
  800288:	55                   	push   %ebp
  800289:	89 e5                	mov    %esp,%ebp
  80028b:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80028e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800291:	50                   	push   %eax
  800292:	ff 75 08             	pushl  0x8(%ebp)
  800295:	e8 95 ff ff ff       	call   80022f <vcprintf>
	va_end(ap);

	return cnt;
}
  80029a:	c9                   	leave  
  80029b:	c3                   	ret    

0080029c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80029c:	55                   	push   %ebp
  80029d:	89 e5                	mov    %esp,%ebp
  80029f:	57                   	push   %edi
  8002a0:	56                   	push   %esi
  8002a1:	53                   	push   %ebx
  8002a2:	83 ec 1c             	sub    $0x1c,%esp
  8002a5:	89 c7                	mov    %eax,%edi
  8002a7:	89 d6                	mov    %edx,%esi
  8002a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002af:	89 d1                	mov    %edx,%ecx
  8002b1:	89 c2                	mov    %eax,%edx
  8002b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002b6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002bc:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002c2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8002c9:	39 c2                	cmp    %eax,%edx
  8002cb:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8002ce:	72 3e                	jb     80030e <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	ff 75 18             	pushl  0x18(%ebp)
  8002d6:	83 eb 01             	sub    $0x1,%ebx
  8002d9:	53                   	push   %ebx
  8002da:	50                   	push   %eax
  8002db:	83 ec 08             	sub    $0x8,%esp
  8002de:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e1:	ff 75 e0             	pushl  -0x20(%ebp)
  8002e4:	ff 75 dc             	pushl  -0x24(%ebp)
  8002e7:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ea:	e8 21 21 00 00       	call   802410 <__udivdi3>
  8002ef:	83 c4 18             	add    $0x18,%esp
  8002f2:	52                   	push   %edx
  8002f3:	50                   	push   %eax
  8002f4:	89 f2                	mov    %esi,%edx
  8002f6:	89 f8                	mov    %edi,%eax
  8002f8:	e8 9f ff ff ff       	call   80029c <printnum>
  8002fd:	83 c4 20             	add    $0x20,%esp
  800300:	eb 13                	jmp    800315 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800302:	83 ec 08             	sub    $0x8,%esp
  800305:	56                   	push   %esi
  800306:	ff 75 18             	pushl  0x18(%ebp)
  800309:	ff d7                	call   *%edi
  80030b:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80030e:	83 eb 01             	sub    $0x1,%ebx
  800311:	85 db                	test   %ebx,%ebx
  800313:	7f ed                	jg     800302 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800315:	83 ec 08             	sub    $0x8,%esp
  800318:	56                   	push   %esi
  800319:	83 ec 04             	sub    $0x4,%esp
  80031c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80031f:	ff 75 e0             	pushl  -0x20(%ebp)
  800322:	ff 75 dc             	pushl  -0x24(%ebp)
  800325:	ff 75 d8             	pushl  -0x28(%ebp)
  800328:	e8 f3 21 00 00       	call   802520 <__umoddi3>
  80032d:	83 c4 14             	add    $0x14,%esp
  800330:	0f be 80 07 27 80 00 	movsbl 0x802707(%eax),%eax
  800337:	50                   	push   %eax
  800338:	ff d7                	call   *%edi
}
  80033a:	83 c4 10             	add    $0x10,%esp
  80033d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800340:	5b                   	pop    %ebx
  800341:	5e                   	pop    %esi
  800342:	5f                   	pop    %edi
  800343:	5d                   	pop    %ebp
  800344:	c3                   	ret    

00800345 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800345:	f3 0f 1e fb          	endbr32 
  800349:	55                   	push   %ebp
  80034a:	89 e5                	mov    %esp,%ebp
  80034c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80034f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800353:	8b 10                	mov    (%eax),%edx
  800355:	3b 50 04             	cmp    0x4(%eax),%edx
  800358:	73 0a                	jae    800364 <sprintputch+0x1f>
		*b->buf++ = ch;
  80035a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80035d:	89 08                	mov    %ecx,(%eax)
  80035f:	8b 45 08             	mov    0x8(%ebp),%eax
  800362:	88 02                	mov    %al,(%edx)
}
  800364:	5d                   	pop    %ebp
  800365:	c3                   	ret    

00800366 <printfmt>:
{
  800366:	f3 0f 1e fb          	endbr32 
  80036a:	55                   	push   %ebp
  80036b:	89 e5                	mov    %esp,%ebp
  80036d:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800370:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800373:	50                   	push   %eax
  800374:	ff 75 10             	pushl  0x10(%ebp)
  800377:	ff 75 0c             	pushl  0xc(%ebp)
  80037a:	ff 75 08             	pushl  0x8(%ebp)
  80037d:	e8 05 00 00 00       	call   800387 <vprintfmt>
}
  800382:	83 c4 10             	add    $0x10,%esp
  800385:	c9                   	leave  
  800386:	c3                   	ret    

00800387 <vprintfmt>:
{
  800387:	f3 0f 1e fb          	endbr32 
  80038b:	55                   	push   %ebp
  80038c:	89 e5                	mov    %esp,%ebp
  80038e:	57                   	push   %edi
  80038f:	56                   	push   %esi
  800390:	53                   	push   %ebx
  800391:	83 ec 3c             	sub    $0x3c,%esp
  800394:	8b 75 08             	mov    0x8(%ebp),%esi
  800397:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80039a:	8b 7d 10             	mov    0x10(%ebp),%edi
  80039d:	e9 8e 03 00 00       	jmp    800730 <vprintfmt+0x3a9>
		padc = ' ';
  8003a2:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8003a6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8003ad:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003b4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003bb:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003c0:	8d 47 01             	lea    0x1(%edi),%eax
  8003c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003c6:	0f b6 17             	movzbl (%edi),%edx
  8003c9:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003cc:	3c 55                	cmp    $0x55,%al
  8003ce:	0f 87 df 03 00 00    	ja     8007b3 <vprintfmt+0x42c>
  8003d4:	0f b6 c0             	movzbl %al,%eax
  8003d7:	3e ff 24 85 40 28 80 	notrack jmp *0x802840(,%eax,4)
  8003de:	00 
  8003df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003e2:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8003e6:	eb d8                	jmp    8003c0 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003eb:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8003ef:	eb cf                	jmp    8003c0 <vprintfmt+0x39>
  8003f1:	0f b6 d2             	movzbl %dl,%edx
  8003f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003fc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003ff:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800402:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800406:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800409:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80040c:	83 f9 09             	cmp    $0x9,%ecx
  80040f:	77 55                	ja     800466 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800411:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800414:	eb e9                	jmp    8003ff <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800416:	8b 45 14             	mov    0x14(%ebp),%eax
  800419:	8b 00                	mov    (%eax),%eax
  80041b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80041e:	8b 45 14             	mov    0x14(%ebp),%eax
  800421:	8d 40 04             	lea    0x4(%eax),%eax
  800424:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800427:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80042a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80042e:	79 90                	jns    8003c0 <vprintfmt+0x39>
				width = precision, precision = -1;
  800430:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800433:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800436:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80043d:	eb 81                	jmp    8003c0 <vprintfmt+0x39>
  80043f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800442:	85 c0                	test   %eax,%eax
  800444:	ba 00 00 00 00       	mov    $0x0,%edx
  800449:	0f 49 d0             	cmovns %eax,%edx
  80044c:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80044f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800452:	e9 69 ff ff ff       	jmp    8003c0 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800457:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80045a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800461:	e9 5a ff ff ff       	jmp    8003c0 <vprintfmt+0x39>
  800466:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800469:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80046c:	eb bc                	jmp    80042a <vprintfmt+0xa3>
			lflag++;
  80046e:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800471:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800474:	e9 47 ff ff ff       	jmp    8003c0 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800479:	8b 45 14             	mov    0x14(%ebp),%eax
  80047c:	8d 78 04             	lea    0x4(%eax),%edi
  80047f:	83 ec 08             	sub    $0x8,%esp
  800482:	53                   	push   %ebx
  800483:	ff 30                	pushl  (%eax)
  800485:	ff d6                	call   *%esi
			break;
  800487:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80048a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80048d:	e9 9b 02 00 00       	jmp    80072d <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800492:	8b 45 14             	mov    0x14(%ebp),%eax
  800495:	8d 78 04             	lea    0x4(%eax),%edi
  800498:	8b 00                	mov    (%eax),%eax
  80049a:	99                   	cltd   
  80049b:	31 d0                	xor    %edx,%eax
  80049d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80049f:	83 f8 0f             	cmp    $0xf,%eax
  8004a2:	7f 23                	jg     8004c7 <vprintfmt+0x140>
  8004a4:	8b 14 85 a0 29 80 00 	mov    0x8029a0(,%eax,4),%edx
  8004ab:	85 d2                	test   %edx,%edx
  8004ad:	74 18                	je     8004c7 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8004af:	52                   	push   %edx
  8004b0:	68 d5 2a 80 00       	push   $0x802ad5
  8004b5:	53                   	push   %ebx
  8004b6:	56                   	push   %esi
  8004b7:	e8 aa fe ff ff       	call   800366 <printfmt>
  8004bc:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004bf:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004c2:	e9 66 02 00 00       	jmp    80072d <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8004c7:	50                   	push   %eax
  8004c8:	68 1f 27 80 00       	push   $0x80271f
  8004cd:	53                   	push   %ebx
  8004ce:	56                   	push   %esi
  8004cf:	e8 92 fe ff ff       	call   800366 <printfmt>
  8004d4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004d7:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004da:	e9 4e 02 00 00       	jmp    80072d <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8004df:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e2:	83 c0 04             	add    $0x4,%eax
  8004e5:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8004e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004eb:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8004ed:	85 d2                	test   %edx,%edx
  8004ef:	b8 18 27 80 00       	mov    $0x802718,%eax
  8004f4:	0f 45 c2             	cmovne %edx,%eax
  8004f7:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004fa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004fe:	7e 06                	jle    800506 <vprintfmt+0x17f>
  800500:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800504:	75 0d                	jne    800513 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  800506:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800509:	89 c7                	mov    %eax,%edi
  80050b:	03 45 e0             	add    -0x20(%ebp),%eax
  80050e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800511:	eb 55                	jmp    800568 <vprintfmt+0x1e1>
  800513:	83 ec 08             	sub    $0x8,%esp
  800516:	ff 75 d8             	pushl  -0x28(%ebp)
  800519:	ff 75 cc             	pushl  -0x34(%ebp)
  80051c:	e8 46 03 00 00       	call   800867 <strnlen>
  800521:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800524:	29 c2                	sub    %eax,%edx
  800526:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800529:	83 c4 10             	add    $0x10,%esp
  80052c:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80052e:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800532:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800535:	85 ff                	test   %edi,%edi
  800537:	7e 11                	jle    80054a <vprintfmt+0x1c3>
					putch(padc, putdat);
  800539:	83 ec 08             	sub    $0x8,%esp
  80053c:	53                   	push   %ebx
  80053d:	ff 75 e0             	pushl  -0x20(%ebp)
  800540:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800542:	83 ef 01             	sub    $0x1,%edi
  800545:	83 c4 10             	add    $0x10,%esp
  800548:	eb eb                	jmp    800535 <vprintfmt+0x1ae>
  80054a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80054d:	85 d2                	test   %edx,%edx
  80054f:	b8 00 00 00 00       	mov    $0x0,%eax
  800554:	0f 49 c2             	cmovns %edx,%eax
  800557:	29 c2                	sub    %eax,%edx
  800559:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80055c:	eb a8                	jmp    800506 <vprintfmt+0x17f>
					putch(ch, putdat);
  80055e:	83 ec 08             	sub    $0x8,%esp
  800561:	53                   	push   %ebx
  800562:	52                   	push   %edx
  800563:	ff d6                	call   *%esi
  800565:	83 c4 10             	add    $0x10,%esp
  800568:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80056b:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80056d:	83 c7 01             	add    $0x1,%edi
  800570:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800574:	0f be d0             	movsbl %al,%edx
  800577:	85 d2                	test   %edx,%edx
  800579:	74 4b                	je     8005c6 <vprintfmt+0x23f>
  80057b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80057f:	78 06                	js     800587 <vprintfmt+0x200>
  800581:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800585:	78 1e                	js     8005a5 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800587:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80058b:	74 d1                	je     80055e <vprintfmt+0x1d7>
  80058d:	0f be c0             	movsbl %al,%eax
  800590:	83 e8 20             	sub    $0x20,%eax
  800593:	83 f8 5e             	cmp    $0x5e,%eax
  800596:	76 c6                	jbe    80055e <vprintfmt+0x1d7>
					putch('?', putdat);
  800598:	83 ec 08             	sub    $0x8,%esp
  80059b:	53                   	push   %ebx
  80059c:	6a 3f                	push   $0x3f
  80059e:	ff d6                	call   *%esi
  8005a0:	83 c4 10             	add    $0x10,%esp
  8005a3:	eb c3                	jmp    800568 <vprintfmt+0x1e1>
  8005a5:	89 cf                	mov    %ecx,%edi
  8005a7:	eb 0e                	jmp    8005b7 <vprintfmt+0x230>
				putch(' ', putdat);
  8005a9:	83 ec 08             	sub    $0x8,%esp
  8005ac:	53                   	push   %ebx
  8005ad:	6a 20                	push   $0x20
  8005af:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005b1:	83 ef 01             	sub    $0x1,%edi
  8005b4:	83 c4 10             	add    $0x10,%esp
  8005b7:	85 ff                	test   %edi,%edi
  8005b9:	7f ee                	jg     8005a9 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8005bb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005be:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c1:	e9 67 01 00 00       	jmp    80072d <vprintfmt+0x3a6>
  8005c6:	89 cf                	mov    %ecx,%edi
  8005c8:	eb ed                	jmp    8005b7 <vprintfmt+0x230>
	if (lflag >= 2)
  8005ca:	83 f9 01             	cmp    $0x1,%ecx
  8005cd:	7f 1b                	jg     8005ea <vprintfmt+0x263>
	else if (lflag)
  8005cf:	85 c9                	test   %ecx,%ecx
  8005d1:	74 63                	je     800636 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8005d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d6:	8b 00                	mov    (%eax),%eax
  8005d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005db:	99                   	cltd   
  8005dc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005df:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e2:	8d 40 04             	lea    0x4(%eax),%eax
  8005e5:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e8:	eb 17                	jmp    800601 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  8005ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ed:	8b 50 04             	mov    0x4(%eax),%edx
  8005f0:	8b 00                	mov    (%eax),%eax
  8005f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fb:	8d 40 08             	lea    0x8(%eax),%eax
  8005fe:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800601:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800604:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800607:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80060c:	85 c9                	test   %ecx,%ecx
  80060e:	0f 89 ff 00 00 00    	jns    800713 <vprintfmt+0x38c>
				putch('-', putdat);
  800614:	83 ec 08             	sub    $0x8,%esp
  800617:	53                   	push   %ebx
  800618:	6a 2d                	push   $0x2d
  80061a:	ff d6                	call   *%esi
				num = -(long long) num;
  80061c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80061f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800622:	f7 da                	neg    %edx
  800624:	83 d1 00             	adc    $0x0,%ecx
  800627:	f7 d9                	neg    %ecx
  800629:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80062c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800631:	e9 dd 00 00 00       	jmp    800713 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  800636:	8b 45 14             	mov    0x14(%ebp),%eax
  800639:	8b 00                	mov    (%eax),%eax
  80063b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80063e:	99                   	cltd   
  80063f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800642:	8b 45 14             	mov    0x14(%ebp),%eax
  800645:	8d 40 04             	lea    0x4(%eax),%eax
  800648:	89 45 14             	mov    %eax,0x14(%ebp)
  80064b:	eb b4                	jmp    800601 <vprintfmt+0x27a>
	if (lflag >= 2)
  80064d:	83 f9 01             	cmp    $0x1,%ecx
  800650:	7f 1e                	jg     800670 <vprintfmt+0x2e9>
	else if (lflag)
  800652:	85 c9                	test   %ecx,%ecx
  800654:	74 32                	je     800688 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800656:	8b 45 14             	mov    0x14(%ebp),%eax
  800659:	8b 10                	mov    (%eax),%edx
  80065b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800660:	8d 40 04             	lea    0x4(%eax),%eax
  800663:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800666:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  80066b:	e9 a3 00 00 00       	jmp    800713 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800670:	8b 45 14             	mov    0x14(%ebp),%eax
  800673:	8b 10                	mov    (%eax),%edx
  800675:	8b 48 04             	mov    0x4(%eax),%ecx
  800678:	8d 40 08             	lea    0x8(%eax),%eax
  80067b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80067e:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800683:	e9 8b 00 00 00       	jmp    800713 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	8b 10                	mov    (%eax),%edx
  80068d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800692:	8d 40 04             	lea    0x4(%eax),%eax
  800695:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800698:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  80069d:	eb 74                	jmp    800713 <vprintfmt+0x38c>
	if (lflag >= 2)
  80069f:	83 f9 01             	cmp    $0x1,%ecx
  8006a2:	7f 1b                	jg     8006bf <vprintfmt+0x338>
	else if (lflag)
  8006a4:	85 c9                	test   %ecx,%ecx
  8006a6:	74 2c                	je     8006d4 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8006a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ab:	8b 10                	mov    (%eax),%edx
  8006ad:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b2:	8d 40 04             	lea    0x4(%eax),%eax
  8006b5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006b8:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8006bd:	eb 54                	jmp    800713 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8006bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c2:	8b 10                	mov    (%eax),%edx
  8006c4:	8b 48 04             	mov    0x4(%eax),%ecx
  8006c7:	8d 40 08             	lea    0x8(%eax),%eax
  8006ca:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006cd:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  8006d2:	eb 3f                	jmp    800713 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d7:	8b 10                	mov    (%eax),%edx
  8006d9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006de:	8d 40 04             	lea    0x4(%eax),%eax
  8006e1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006e4:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  8006e9:	eb 28                	jmp    800713 <vprintfmt+0x38c>
			putch('0', putdat);
  8006eb:	83 ec 08             	sub    $0x8,%esp
  8006ee:	53                   	push   %ebx
  8006ef:	6a 30                	push   $0x30
  8006f1:	ff d6                	call   *%esi
			putch('x', putdat);
  8006f3:	83 c4 08             	add    $0x8,%esp
  8006f6:	53                   	push   %ebx
  8006f7:	6a 78                	push   $0x78
  8006f9:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fe:	8b 10                	mov    (%eax),%edx
  800700:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800705:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800708:	8d 40 04             	lea    0x4(%eax),%eax
  80070b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80070e:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800713:	83 ec 0c             	sub    $0xc,%esp
  800716:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80071a:	57                   	push   %edi
  80071b:	ff 75 e0             	pushl  -0x20(%ebp)
  80071e:	50                   	push   %eax
  80071f:	51                   	push   %ecx
  800720:	52                   	push   %edx
  800721:	89 da                	mov    %ebx,%edx
  800723:	89 f0                	mov    %esi,%eax
  800725:	e8 72 fb ff ff       	call   80029c <printnum>
			break;
  80072a:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80072d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800730:	83 c7 01             	add    $0x1,%edi
  800733:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800737:	83 f8 25             	cmp    $0x25,%eax
  80073a:	0f 84 62 fc ff ff    	je     8003a2 <vprintfmt+0x1b>
			if (ch == '\0')
  800740:	85 c0                	test   %eax,%eax
  800742:	0f 84 8b 00 00 00    	je     8007d3 <vprintfmt+0x44c>
			putch(ch, putdat);
  800748:	83 ec 08             	sub    $0x8,%esp
  80074b:	53                   	push   %ebx
  80074c:	50                   	push   %eax
  80074d:	ff d6                	call   *%esi
  80074f:	83 c4 10             	add    $0x10,%esp
  800752:	eb dc                	jmp    800730 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800754:	83 f9 01             	cmp    $0x1,%ecx
  800757:	7f 1b                	jg     800774 <vprintfmt+0x3ed>
	else if (lflag)
  800759:	85 c9                	test   %ecx,%ecx
  80075b:	74 2c                	je     800789 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  80075d:	8b 45 14             	mov    0x14(%ebp),%eax
  800760:	8b 10                	mov    (%eax),%edx
  800762:	b9 00 00 00 00       	mov    $0x0,%ecx
  800767:	8d 40 04             	lea    0x4(%eax),%eax
  80076a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80076d:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800772:	eb 9f                	jmp    800713 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800774:	8b 45 14             	mov    0x14(%ebp),%eax
  800777:	8b 10                	mov    (%eax),%edx
  800779:	8b 48 04             	mov    0x4(%eax),%ecx
  80077c:	8d 40 08             	lea    0x8(%eax),%eax
  80077f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800782:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800787:	eb 8a                	jmp    800713 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800789:	8b 45 14             	mov    0x14(%ebp),%eax
  80078c:	8b 10                	mov    (%eax),%edx
  80078e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800793:	8d 40 04             	lea    0x4(%eax),%eax
  800796:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800799:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  80079e:	e9 70 ff ff ff       	jmp    800713 <vprintfmt+0x38c>
			putch(ch, putdat);
  8007a3:	83 ec 08             	sub    $0x8,%esp
  8007a6:	53                   	push   %ebx
  8007a7:	6a 25                	push   $0x25
  8007a9:	ff d6                	call   *%esi
			break;
  8007ab:	83 c4 10             	add    $0x10,%esp
  8007ae:	e9 7a ff ff ff       	jmp    80072d <vprintfmt+0x3a6>
			putch('%', putdat);
  8007b3:	83 ec 08             	sub    $0x8,%esp
  8007b6:	53                   	push   %ebx
  8007b7:	6a 25                	push   $0x25
  8007b9:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007bb:	83 c4 10             	add    $0x10,%esp
  8007be:	89 f8                	mov    %edi,%eax
  8007c0:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007c4:	74 05                	je     8007cb <vprintfmt+0x444>
  8007c6:	83 e8 01             	sub    $0x1,%eax
  8007c9:	eb f5                	jmp    8007c0 <vprintfmt+0x439>
  8007cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007ce:	e9 5a ff ff ff       	jmp    80072d <vprintfmt+0x3a6>
}
  8007d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007d6:	5b                   	pop    %ebx
  8007d7:	5e                   	pop    %esi
  8007d8:	5f                   	pop    %edi
  8007d9:	5d                   	pop    %ebp
  8007da:	c3                   	ret    

008007db <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007db:	f3 0f 1e fb          	endbr32 
  8007df:	55                   	push   %ebp
  8007e0:	89 e5                	mov    %esp,%ebp
  8007e2:	83 ec 18             	sub    $0x18,%esp
  8007e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e8:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007ee:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007f2:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007fc:	85 c0                	test   %eax,%eax
  8007fe:	74 26                	je     800826 <vsnprintf+0x4b>
  800800:	85 d2                	test   %edx,%edx
  800802:	7e 22                	jle    800826 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800804:	ff 75 14             	pushl  0x14(%ebp)
  800807:	ff 75 10             	pushl  0x10(%ebp)
  80080a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80080d:	50                   	push   %eax
  80080e:	68 45 03 80 00       	push   $0x800345
  800813:	e8 6f fb ff ff       	call   800387 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800818:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80081b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80081e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800821:	83 c4 10             	add    $0x10,%esp
}
  800824:	c9                   	leave  
  800825:	c3                   	ret    
		return -E_INVAL;
  800826:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80082b:	eb f7                	jmp    800824 <vsnprintf+0x49>

0080082d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80082d:	f3 0f 1e fb          	endbr32 
  800831:	55                   	push   %ebp
  800832:	89 e5                	mov    %esp,%ebp
  800834:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800837:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80083a:	50                   	push   %eax
  80083b:	ff 75 10             	pushl  0x10(%ebp)
  80083e:	ff 75 0c             	pushl  0xc(%ebp)
  800841:	ff 75 08             	pushl  0x8(%ebp)
  800844:	e8 92 ff ff ff       	call   8007db <vsnprintf>
	va_end(ap);

	return rc;
}
  800849:	c9                   	leave  
  80084a:	c3                   	ret    

0080084b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80084b:	f3 0f 1e fb          	endbr32 
  80084f:	55                   	push   %ebp
  800850:	89 e5                	mov    %esp,%ebp
  800852:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800855:	b8 00 00 00 00       	mov    $0x0,%eax
  80085a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80085e:	74 05                	je     800865 <strlen+0x1a>
		n++;
  800860:	83 c0 01             	add    $0x1,%eax
  800863:	eb f5                	jmp    80085a <strlen+0xf>
	return n;
}
  800865:	5d                   	pop    %ebp
  800866:	c3                   	ret    

00800867 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800867:	f3 0f 1e fb          	endbr32 
  80086b:	55                   	push   %ebp
  80086c:	89 e5                	mov    %esp,%ebp
  80086e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800871:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800874:	b8 00 00 00 00       	mov    $0x0,%eax
  800879:	39 d0                	cmp    %edx,%eax
  80087b:	74 0d                	je     80088a <strnlen+0x23>
  80087d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800881:	74 05                	je     800888 <strnlen+0x21>
		n++;
  800883:	83 c0 01             	add    $0x1,%eax
  800886:	eb f1                	jmp    800879 <strnlen+0x12>
  800888:	89 c2                	mov    %eax,%edx
	return n;
}
  80088a:	89 d0                	mov    %edx,%eax
  80088c:	5d                   	pop    %ebp
  80088d:	c3                   	ret    

0080088e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80088e:	f3 0f 1e fb          	endbr32 
  800892:	55                   	push   %ebp
  800893:	89 e5                	mov    %esp,%ebp
  800895:	53                   	push   %ebx
  800896:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800899:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80089c:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a1:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8008a5:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8008a8:	83 c0 01             	add    $0x1,%eax
  8008ab:	84 d2                	test   %dl,%dl
  8008ad:	75 f2                	jne    8008a1 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8008af:	89 c8                	mov    %ecx,%eax
  8008b1:	5b                   	pop    %ebx
  8008b2:	5d                   	pop    %ebp
  8008b3:	c3                   	ret    

008008b4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008b4:	f3 0f 1e fb          	endbr32 
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	53                   	push   %ebx
  8008bc:	83 ec 10             	sub    $0x10,%esp
  8008bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008c2:	53                   	push   %ebx
  8008c3:	e8 83 ff ff ff       	call   80084b <strlen>
  8008c8:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008cb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ce:	01 d8                	add    %ebx,%eax
  8008d0:	50                   	push   %eax
  8008d1:	e8 b8 ff ff ff       	call   80088e <strcpy>
	return dst;
}
  8008d6:	89 d8                	mov    %ebx,%eax
  8008d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008db:	c9                   	leave  
  8008dc:	c3                   	ret    

008008dd <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008dd:	f3 0f 1e fb          	endbr32 
  8008e1:	55                   	push   %ebp
  8008e2:	89 e5                	mov    %esp,%ebp
  8008e4:	56                   	push   %esi
  8008e5:	53                   	push   %ebx
  8008e6:	8b 75 08             	mov    0x8(%ebp),%esi
  8008e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ec:	89 f3                	mov    %esi,%ebx
  8008ee:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008f1:	89 f0                	mov    %esi,%eax
  8008f3:	39 d8                	cmp    %ebx,%eax
  8008f5:	74 11                	je     800908 <strncpy+0x2b>
		*dst++ = *src;
  8008f7:	83 c0 01             	add    $0x1,%eax
  8008fa:	0f b6 0a             	movzbl (%edx),%ecx
  8008fd:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800900:	80 f9 01             	cmp    $0x1,%cl
  800903:	83 da ff             	sbb    $0xffffffff,%edx
  800906:	eb eb                	jmp    8008f3 <strncpy+0x16>
	}
	return ret;
}
  800908:	89 f0                	mov    %esi,%eax
  80090a:	5b                   	pop    %ebx
  80090b:	5e                   	pop    %esi
  80090c:	5d                   	pop    %ebp
  80090d:	c3                   	ret    

0080090e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80090e:	f3 0f 1e fb          	endbr32 
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
  800915:	56                   	push   %esi
  800916:	53                   	push   %ebx
  800917:	8b 75 08             	mov    0x8(%ebp),%esi
  80091a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80091d:	8b 55 10             	mov    0x10(%ebp),%edx
  800920:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800922:	85 d2                	test   %edx,%edx
  800924:	74 21                	je     800947 <strlcpy+0x39>
  800926:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80092a:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80092c:	39 c2                	cmp    %eax,%edx
  80092e:	74 14                	je     800944 <strlcpy+0x36>
  800930:	0f b6 19             	movzbl (%ecx),%ebx
  800933:	84 db                	test   %bl,%bl
  800935:	74 0b                	je     800942 <strlcpy+0x34>
			*dst++ = *src++;
  800937:	83 c1 01             	add    $0x1,%ecx
  80093a:	83 c2 01             	add    $0x1,%edx
  80093d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800940:	eb ea                	jmp    80092c <strlcpy+0x1e>
  800942:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800944:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800947:	29 f0                	sub    %esi,%eax
}
  800949:	5b                   	pop    %ebx
  80094a:	5e                   	pop    %esi
  80094b:	5d                   	pop    %ebp
  80094c:	c3                   	ret    

0080094d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80094d:	f3 0f 1e fb          	endbr32 
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800957:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80095a:	0f b6 01             	movzbl (%ecx),%eax
  80095d:	84 c0                	test   %al,%al
  80095f:	74 0c                	je     80096d <strcmp+0x20>
  800961:	3a 02                	cmp    (%edx),%al
  800963:	75 08                	jne    80096d <strcmp+0x20>
		p++, q++;
  800965:	83 c1 01             	add    $0x1,%ecx
  800968:	83 c2 01             	add    $0x1,%edx
  80096b:	eb ed                	jmp    80095a <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80096d:	0f b6 c0             	movzbl %al,%eax
  800970:	0f b6 12             	movzbl (%edx),%edx
  800973:	29 d0                	sub    %edx,%eax
}
  800975:	5d                   	pop    %ebp
  800976:	c3                   	ret    

00800977 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800977:	f3 0f 1e fb          	endbr32 
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	53                   	push   %ebx
  80097f:	8b 45 08             	mov    0x8(%ebp),%eax
  800982:	8b 55 0c             	mov    0xc(%ebp),%edx
  800985:	89 c3                	mov    %eax,%ebx
  800987:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80098a:	eb 06                	jmp    800992 <strncmp+0x1b>
		n--, p++, q++;
  80098c:	83 c0 01             	add    $0x1,%eax
  80098f:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800992:	39 d8                	cmp    %ebx,%eax
  800994:	74 16                	je     8009ac <strncmp+0x35>
  800996:	0f b6 08             	movzbl (%eax),%ecx
  800999:	84 c9                	test   %cl,%cl
  80099b:	74 04                	je     8009a1 <strncmp+0x2a>
  80099d:	3a 0a                	cmp    (%edx),%cl
  80099f:	74 eb                	je     80098c <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009a1:	0f b6 00             	movzbl (%eax),%eax
  8009a4:	0f b6 12             	movzbl (%edx),%edx
  8009a7:	29 d0                	sub    %edx,%eax
}
  8009a9:	5b                   	pop    %ebx
  8009aa:	5d                   	pop    %ebp
  8009ab:	c3                   	ret    
		return 0;
  8009ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b1:	eb f6                	jmp    8009a9 <strncmp+0x32>

008009b3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009b3:	f3 0f 1e fb          	endbr32 
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bd:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009c1:	0f b6 10             	movzbl (%eax),%edx
  8009c4:	84 d2                	test   %dl,%dl
  8009c6:	74 09                	je     8009d1 <strchr+0x1e>
		if (*s == c)
  8009c8:	38 ca                	cmp    %cl,%dl
  8009ca:	74 0a                	je     8009d6 <strchr+0x23>
	for (; *s; s++)
  8009cc:	83 c0 01             	add    $0x1,%eax
  8009cf:	eb f0                	jmp    8009c1 <strchr+0xe>
			return (char *) s;
	return 0;
  8009d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009d6:	5d                   	pop    %ebp
  8009d7:	c3                   	ret    

008009d8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009d8:	f3 0f 1e fb          	endbr32 
  8009dc:	55                   	push   %ebp
  8009dd:	89 e5                	mov    %esp,%ebp
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009e6:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009e9:	38 ca                	cmp    %cl,%dl
  8009eb:	74 09                	je     8009f6 <strfind+0x1e>
  8009ed:	84 d2                	test   %dl,%dl
  8009ef:	74 05                	je     8009f6 <strfind+0x1e>
	for (; *s; s++)
  8009f1:	83 c0 01             	add    $0x1,%eax
  8009f4:	eb f0                	jmp    8009e6 <strfind+0xe>
			break;
	return (char *) s;
}
  8009f6:	5d                   	pop    %ebp
  8009f7:	c3                   	ret    

008009f8 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009f8:	f3 0f 1e fb          	endbr32 
  8009fc:	55                   	push   %ebp
  8009fd:	89 e5                	mov    %esp,%ebp
  8009ff:	57                   	push   %edi
  800a00:	56                   	push   %esi
  800a01:	53                   	push   %ebx
  800a02:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a05:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a08:	85 c9                	test   %ecx,%ecx
  800a0a:	74 31                	je     800a3d <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a0c:	89 f8                	mov    %edi,%eax
  800a0e:	09 c8                	or     %ecx,%eax
  800a10:	a8 03                	test   $0x3,%al
  800a12:	75 23                	jne    800a37 <memset+0x3f>
		c &= 0xFF;
  800a14:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a18:	89 d3                	mov    %edx,%ebx
  800a1a:	c1 e3 08             	shl    $0x8,%ebx
  800a1d:	89 d0                	mov    %edx,%eax
  800a1f:	c1 e0 18             	shl    $0x18,%eax
  800a22:	89 d6                	mov    %edx,%esi
  800a24:	c1 e6 10             	shl    $0x10,%esi
  800a27:	09 f0                	or     %esi,%eax
  800a29:	09 c2                	or     %eax,%edx
  800a2b:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a2d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a30:	89 d0                	mov    %edx,%eax
  800a32:	fc                   	cld    
  800a33:	f3 ab                	rep stos %eax,%es:(%edi)
  800a35:	eb 06                	jmp    800a3d <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3a:	fc                   	cld    
  800a3b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a3d:	89 f8                	mov    %edi,%eax
  800a3f:	5b                   	pop    %ebx
  800a40:	5e                   	pop    %esi
  800a41:	5f                   	pop    %edi
  800a42:	5d                   	pop    %ebp
  800a43:	c3                   	ret    

00800a44 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a44:	f3 0f 1e fb          	endbr32 
  800a48:	55                   	push   %ebp
  800a49:	89 e5                	mov    %esp,%ebp
  800a4b:	57                   	push   %edi
  800a4c:	56                   	push   %esi
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a53:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a56:	39 c6                	cmp    %eax,%esi
  800a58:	73 32                	jae    800a8c <memmove+0x48>
  800a5a:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a5d:	39 c2                	cmp    %eax,%edx
  800a5f:	76 2b                	jbe    800a8c <memmove+0x48>
		s += n;
		d += n;
  800a61:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a64:	89 fe                	mov    %edi,%esi
  800a66:	09 ce                	or     %ecx,%esi
  800a68:	09 d6                	or     %edx,%esi
  800a6a:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a70:	75 0e                	jne    800a80 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a72:	83 ef 04             	sub    $0x4,%edi
  800a75:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a78:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a7b:	fd                   	std    
  800a7c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a7e:	eb 09                	jmp    800a89 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a80:	83 ef 01             	sub    $0x1,%edi
  800a83:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a86:	fd                   	std    
  800a87:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a89:	fc                   	cld    
  800a8a:	eb 1a                	jmp    800aa6 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a8c:	89 c2                	mov    %eax,%edx
  800a8e:	09 ca                	or     %ecx,%edx
  800a90:	09 f2                	or     %esi,%edx
  800a92:	f6 c2 03             	test   $0x3,%dl
  800a95:	75 0a                	jne    800aa1 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a97:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a9a:	89 c7                	mov    %eax,%edi
  800a9c:	fc                   	cld    
  800a9d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a9f:	eb 05                	jmp    800aa6 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800aa1:	89 c7                	mov    %eax,%edi
  800aa3:	fc                   	cld    
  800aa4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800aa6:	5e                   	pop    %esi
  800aa7:	5f                   	pop    %edi
  800aa8:	5d                   	pop    %ebp
  800aa9:	c3                   	ret    

00800aaa <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aaa:	f3 0f 1e fb          	endbr32 
  800aae:	55                   	push   %ebp
  800aaf:	89 e5                	mov    %esp,%ebp
  800ab1:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ab4:	ff 75 10             	pushl  0x10(%ebp)
  800ab7:	ff 75 0c             	pushl  0xc(%ebp)
  800aba:	ff 75 08             	pushl  0x8(%ebp)
  800abd:	e8 82 ff ff ff       	call   800a44 <memmove>
}
  800ac2:	c9                   	leave  
  800ac3:	c3                   	ret    

00800ac4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ac4:	f3 0f 1e fb          	endbr32 
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
  800acb:	56                   	push   %esi
  800acc:	53                   	push   %ebx
  800acd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ad3:	89 c6                	mov    %eax,%esi
  800ad5:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ad8:	39 f0                	cmp    %esi,%eax
  800ada:	74 1c                	je     800af8 <memcmp+0x34>
		if (*s1 != *s2)
  800adc:	0f b6 08             	movzbl (%eax),%ecx
  800adf:	0f b6 1a             	movzbl (%edx),%ebx
  800ae2:	38 d9                	cmp    %bl,%cl
  800ae4:	75 08                	jne    800aee <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ae6:	83 c0 01             	add    $0x1,%eax
  800ae9:	83 c2 01             	add    $0x1,%edx
  800aec:	eb ea                	jmp    800ad8 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800aee:	0f b6 c1             	movzbl %cl,%eax
  800af1:	0f b6 db             	movzbl %bl,%ebx
  800af4:	29 d8                	sub    %ebx,%eax
  800af6:	eb 05                	jmp    800afd <memcmp+0x39>
	}

	return 0;
  800af8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800afd:	5b                   	pop    %ebx
  800afe:	5e                   	pop    %esi
  800aff:	5d                   	pop    %ebp
  800b00:	c3                   	ret    

00800b01 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b01:	f3 0f 1e fb          	endbr32 
  800b05:	55                   	push   %ebp
  800b06:	89 e5                	mov    %esp,%ebp
  800b08:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b0e:	89 c2                	mov    %eax,%edx
  800b10:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b13:	39 d0                	cmp    %edx,%eax
  800b15:	73 09                	jae    800b20 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b17:	38 08                	cmp    %cl,(%eax)
  800b19:	74 05                	je     800b20 <memfind+0x1f>
	for (; s < ends; s++)
  800b1b:	83 c0 01             	add    $0x1,%eax
  800b1e:	eb f3                	jmp    800b13 <memfind+0x12>
			break;
	return (void *) s;
}
  800b20:	5d                   	pop    %ebp
  800b21:	c3                   	ret    

00800b22 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b22:	f3 0f 1e fb          	endbr32 
  800b26:	55                   	push   %ebp
  800b27:	89 e5                	mov    %esp,%ebp
  800b29:	57                   	push   %edi
  800b2a:	56                   	push   %esi
  800b2b:	53                   	push   %ebx
  800b2c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b2f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b32:	eb 03                	jmp    800b37 <strtol+0x15>
		s++;
  800b34:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b37:	0f b6 01             	movzbl (%ecx),%eax
  800b3a:	3c 20                	cmp    $0x20,%al
  800b3c:	74 f6                	je     800b34 <strtol+0x12>
  800b3e:	3c 09                	cmp    $0x9,%al
  800b40:	74 f2                	je     800b34 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800b42:	3c 2b                	cmp    $0x2b,%al
  800b44:	74 2a                	je     800b70 <strtol+0x4e>
	int neg = 0;
  800b46:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b4b:	3c 2d                	cmp    $0x2d,%al
  800b4d:	74 2b                	je     800b7a <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b4f:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b55:	75 0f                	jne    800b66 <strtol+0x44>
  800b57:	80 39 30             	cmpb   $0x30,(%ecx)
  800b5a:	74 28                	je     800b84 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b5c:	85 db                	test   %ebx,%ebx
  800b5e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b63:	0f 44 d8             	cmove  %eax,%ebx
  800b66:	b8 00 00 00 00       	mov    $0x0,%eax
  800b6b:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b6e:	eb 46                	jmp    800bb6 <strtol+0x94>
		s++;
  800b70:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b73:	bf 00 00 00 00       	mov    $0x0,%edi
  800b78:	eb d5                	jmp    800b4f <strtol+0x2d>
		s++, neg = 1;
  800b7a:	83 c1 01             	add    $0x1,%ecx
  800b7d:	bf 01 00 00 00       	mov    $0x1,%edi
  800b82:	eb cb                	jmp    800b4f <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b84:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b88:	74 0e                	je     800b98 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b8a:	85 db                	test   %ebx,%ebx
  800b8c:	75 d8                	jne    800b66 <strtol+0x44>
		s++, base = 8;
  800b8e:	83 c1 01             	add    $0x1,%ecx
  800b91:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b96:	eb ce                	jmp    800b66 <strtol+0x44>
		s += 2, base = 16;
  800b98:	83 c1 02             	add    $0x2,%ecx
  800b9b:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ba0:	eb c4                	jmp    800b66 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800ba2:	0f be d2             	movsbl %dl,%edx
  800ba5:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ba8:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bab:	7d 3a                	jge    800be7 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800bad:	83 c1 01             	add    $0x1,%ecx
  800bb0:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bb4:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bb6:	0f b6 11             	movzbl (%ecx),%edx
  800bb9:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bbc:	89 f3                	mov    %esi,%ebx
  800bbe:	80 fb 09             	cmp    $0x9,%bl
  800bc1:	76 df                	jbe    800ba2 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800bc3:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bc6:	89 f3                	mov    %esi,%ebx
  800bc8:	80 fb 19             	cmp    $0x19,%bl
  800bcb:	77 08                	ja     800bd5 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800bcd:	0f be d2             	movsbl %dl,%edx
  800bd0:	83 ea 57             	sub    $0x57,%edx
  800bd3:	eb d3                	jmp    800ba8 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800bd5:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bd8:	89 f3                	mov    %esi,%ebx
  800bda:	80 fb 19             	cmp    $0x19,%bl
  800bdd:	77 08                	ja     800be7 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800bdf:	0f be d2             	movsbl %dl,%edx
  800be2:	83 ea 37             	sub    $0x37,%edx
  800be5:	eb c1                	jmp    800ba8 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800be7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800beb:	74 05                	je     800bf2 <strtol+0xd0>
		*endptr = (char *) s;
  800bed:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bf0:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bf2:	89 c2                	mov    %eax,%edx
  800bf4:	f7 da                	neg    %edx
  800bf6:	85 ff                	test   %edi,%edi
  800bf8:	0f 45 c2             	cmovne %edx,%eax
}
  800bfb:	5b                   	pop    %ebx
  800bfc:	5e                   	pop    %esi
  800bfd:	5f                   	pop    %edi
  800bfe:	5d                   	pop    %ebp
  800bff:	c3                   	ret    

00800c00 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c00:	f3 0f 1e fb          	endbr32 
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	57                   	push   %edi
  800c08:	56                   	push   %esi
  800c09:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c0a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c0f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c15:	89 c3                	mov    %eax,%ebx
  800c17:	89 c7                	mov    %eax,%edi
  800c19:	89 c6                	mov    %eax,%esi
  800c1b:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c1d:	5b                   	pop    %ebx
  800c1e:	5e                   	pop    %esi
  800c1f:	5f                   	pop    %edi
  800c20:	5d                   	pop    %ebp
  800c21:	c3                   	ret    

00800c22 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c22:	f3 0f 1e fb          	endbr32 
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
  800c29:	57                   	push   %edi
  800c2a:	56                   	push   %esi
  800c2b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c2c:	ba 00 00 00 00       	mov    $0x0,%edx
  800c31:	b8 01 00 00 00       	mov    $0x1,%eax
  800c36:	89 d1                	mov    %edx,%ecx
  800c38:	89 d3                	mov    %edx,%ebx
  800c3a:	89 d7                	mov    %edx,%edi
  800c3c:	89 d6                	mov    %edx,%esi
  800c3e:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c40:	5b                   	pop    %ebx
  800c41:	5e                   	pop    %esi
  800c42:	5f                   	pop    %edi
  800c43:	5d                   	pop    %ebp
  800c44:	c3                   	ret    

00800c45 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c45:	f3 0f 1e fb          	endbr32 
  800c49:	55                   	push   %ebp
  800c4a:	89 e5                	mov    %esp,%ebp
  800c4c:	57                   	push   %edi
  800c4d:	56                   	push   %esi
  800c4e:	53                   	push   %ebx
  800c4f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c52:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c57:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5a:	b8 03 00 00 00       	mov    $0x3,%eax
  800c5f:	89 cb                	mov    %ecx,%ebx
  800c61:	89 cf                	mov    %ecx,%edi
  800c63:	89 ce                	mov    %ecx,%esi
  800c65:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c67:	85 c0                	test   %eax,%eax
  800c69:	7f 08                	jg     800c73 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c6e:	5b                   	pop    %ebx
  800c6f:	5e                   	pop    %esi
  800c70:	5f                   	pop    %edi
  800c71:	5d                   	pop    %ebp
  800c72:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c73:	83 ec 0c             	sub    $0xc,%esp
  800c76:	50                   	push   %eax
  800c77:	6a 03                	push   $0x3
  800c79:	68 ff 29 80 00       	push   $0x8029ff
  800c7e:	6a 23                	push   $0x23
  800c80:	68 1c 2a 80 00       	push   $0x802a1c
  800c85:	e8 13 f5 ff ff       	call   80019d <_panic>

00800c8a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c8a:	f3 0f 1e fb          	endbr32 
  800c8e:	55                   	push   %ebp
  800c8f:	89 e5                	mov    %esp,%ebp
  800c91:	57                   	push   %edi
  800c92:	56                   	push   %esi
  800c93:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c94:	ba 00 00 00 00       	mov    $0x0,%edx
  800c99:	b8 02 00 00 00       	mov    $0x2,%eax
  800c9e:	89 d1                	mov    %edx,%ecx
  800ca0:	89 d3                	mov    %edx,%ebx
  800ca2:	89 d7                	mov    %edx,%edi
  800ca4:	89 d6                	mov    %edx,%esi
  800ca6:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ca8:	5b                   	pop    %ebx
  800ca9:	5e                   	pop    %esi
  800caa:	5f                   	pop    %edi
  800cab:	5d                   	pop    %ebp
  800cac:	c3                   	ret    

00800cad <sys_yield>:

void
sys_yield(void)
{
  800cad:	f3 0f 1e fb          	endbr32 
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	57                   	push   %edi
  800cb5:	56                   	push   %esi
  800cb6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cb7:	ba 00 00 00 00       	mov    $0x0,%edx
  800cbc:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cc1:	89 d1                	mov    %edx,%ecx
  800cc3:	89 d3                	mov    %edx,%ebx
  800cc5:	89 d7                	mov    %edx,%edi
  800cc7:	89 d6                	mov    %edx,%esi
  800cc9:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ccb:	5b                   	pop    %ebx
  800ccc:	5e                   	pop    %esi
  800ccd:	5f                   	pop    %edi
  800cce:	5d                   	pop    %ebp
  800ccf:	c3                   	ret    

00800cd0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cd0:	f3 0f 1e fb          	endbr32 
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
  800cd7:	57                   	push   %edi
  800cd8:	56                   	push   %esi
  800cd9:	53                   	push   %ebx
  800cda:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cdd:	be 00 00 00 00       	mov    $0x0,%esi
  800ce2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce8:	b8 04 00 00 00       	mov    $0x4,%eax
  800ced:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cf0:	89 f7                	mov    %esi,%edi
  800cf2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf4:	85 c0                	test   %eax,%eax
  800cf6:	7f 08                	jg     800d00 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cfb:	5b                   	pop    %ebx
  800cfc:	5e                   	pop    %esi
  800cfd:	5f                   	pop    %edi
  800cfe:	5d                   	pop    %ebp
  800cff:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d00:	83 ec 0c             	sub    $0xc,%esp
  800d03:	50                   	push   %eax
  800d04:	6a 04                	push   $0x4
  800d06:	68 ff 29 80 00       	push   $0x8029ff
  800d0b:	6a 23                	push   $0x23
  800d0d:	68 1c 2a 80 00       	push   $0x802a1c
  800d12:	e8 86 f4 ff ff       	call   80019d <_panic>

00800d17 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d17:	f3 0f 1e fb          	endbr32 
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
  800d1e:	57                   	push   %edi
  800d1f:	56                   	push   %esi
  800d20:	53                   	push   %ebx
  800d21:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d24:	8b 55 08             	mov    0x8(%ebp),%edx
  800d27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2a:	b8 05 00 00 00       	mov    $0x5,%eax
  800d2f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d32:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d35:	8b 75 18             	mov    0x18(%ebp),%esi
  800d38:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d3a:	85 c0                	test   %eax,%eax
  800d3c:	7f 08                	jg     800d46 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d41:	5b                   	pop    %ebx
  800d42:	5e                   	pop    %esi
  800d43:	5f                   	pop    %edi
  800d44:	5d                   	pop    %ebp
  800d45:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d46:	83 ec 0c             	sub    $0xc,%esp
  800d49:	50                   	push   %eax
  800d4a:	6a 05                	push   $0x5
  800d4c:	68 ff 29 80 00       	push   $0x8029ff
  800d51:	6a 23                	push   $0x23
  800d53:	68 1c 2a 80 00       	push   $0x802a1c
  800d58:	e8 40 f4 ff ff       	call   80019d <_panic>

00800d5d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d5d:	f3 0f 1e fb          	endbr32 
  800d61:	55                   	push   %ebp
  800d62:	89 e5                	mov    %esp,%ebp
  800d64:	57                   	push   %edi
  800d65:	56                   	push   %esi
  800d66:	53                   	push   %ebx
  800d67:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d6a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d75:	b8 06 00 00 00       	mov    $0x6,%eax
  800d7a:	89 df                	mov    %ebx,%edi
  800d7c:	89 de                	mov    %ebx,%esi
  800d7e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d80:	85 c0                	test   %eax,%eax
  800d82:	7f 08                	jg     800d8c <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d84:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d87:	5b                   	pop    %ebx
  800d88:	5e                   	pop    %esi
  800d89:	5f                   	pop    %edi
  800d8a:	5d                   	pop    %ebp
  800d8b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d8c:	83 ec 0c             	sub    $0xc,%esp
  800d8f:	50                   	push   %eax
  800d90:	6a 06                	push   $0x6
  800d92:	68 ff 29 80 00       	push   $0x8029ff
  800d97:	6a 23                	push   $0x23
  800d99:	68 1c 2a 80 00       	push   $0x802a1c
  800d9e:	e8 fa f3 ff ff       	call   80019d <_panic>

00800da3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800da3:	f3 0f 1e fb          	endbr32 
  800da7:	55                   	push   %ebp
  800da8:	89 e5                	mov    %esp,%ebp
  800daa:	57                   	push   %edi
  800dab:	56                   	push   %esi
  800dac:	53                   	push   %ebx
  800dad:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db5:	8b 55 08             	mov    0x8(%ebp),%edx
  800db8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dbb:	b8 08 00 00 00       	mov    $0x8,%eax
  800dc0:	89 df                	mov    %ebx,%edi
  800dc2:	89 de                	mov    %ebx,%esi
  800dc4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc6:	85 c0                	test   %eax,%eax
  800dc8:	7f 08                	jg     800dd2 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dcd:	5b                   	pop    %ebx
  800dce:	5e                   	pop    %esi
  800dcf:	5f                   	pop    %edi
  800dd0:	5d                   	pop    %ebp
  800dd1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd2:	83 ec 0c             	sub    $0xc,%esp
  800dd5:	50                   	push   %eax
  800dd6:	6a 08                	push   $0x8
  800dd8:	68 ff 29 80 00       	push   $0x8029ff
  800ddd:	6a 23                	push   $0x23
  800ddf:	68 1c 2a 80 00       	push   $0x802a1c
  800de4:	e8 b4 f3 ff ff       	call   80019d <_panic>

00800de9 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800de9:	f3 0f 1e fb          	endbr32 
  800ded:	55                   	push   %ebp
  800dee:	89 e5                	mov    %esp,%ebp
  800df0:	57                   	push   %edi
  800df1:	56                   	push   %esi
  800df2:	53                   	push   %ebx
  800df3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dfb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e01:	b8 09 00 00 00       	mov    $0x9,%eax
  800e06:	89 df                	mov    %ebx,%edi
  800e08:	89 de                	mov    %ebx,%esi
  800e0a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e0c:	85 c0                	test   %eax,%eax
  800e0e:	7f 08                	jg     800e18 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e13:	5b                   	pop    %ebx
  800e14:	5e                   	pop    %esi
  800e15:	5f                   	pop    %edi
  800e16:	5d                   	pop    %ebp
  800e17:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e18:	83 ec 0c             	sub    $0xc,%esp
  800e1b:	50                   	push   %eax
  800e1c:	6a 09                	push   $0x9
  800e1e:	68 ff 29 80 00       	push   $0x8029ff
  800e23:	6a 23                	push   $0x23
  800e25:	68 1c 2a 80 00       	push   $0x802a1c
  800e2a:	e8 6e f3 ff ff       	call   80019d <_panic>

00800e2f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e2f:	f3 0f 1e fb          	endbr32 
  800e33:	55                   	push   %ebp
  800e34:	89 e5                	mov    %esp,%ebp
  800e36:	57                   	push   %edi
  800e37:	56                   	push   %esi
  800e38:	53                   	push   %ebx
  800e39:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e3c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e41:	8b 55 08             	mov    0x8(%ebp),%edx
  800e44:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e47:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e4c:	89 df                	mov    %ebx,%edi
  800e4e:	89 de                	mov    %ebx,%esi
  800e50:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e52:	85 c0                	test   %eax,%eax
  800e54:	7f 08                	jg     800e5e <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e56:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e59:	5b                   	pop    %ebx
  800e5a:	5e                   	pop    %esi
  800e5b:	5f                   	pop    %edi
  800e5c:	5d                   	pop    %ebp
  800e5d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5e:	83 ec 0c             	sub    $0xc,%esp
  800e61:	50                   	push   %eax
  800e62:	6a 0a                	push   $0xa
  800e64:	68 ff 29 80 00       	push   $0x8029ff
  800e69:	6a 23                	push   $0x23
  800e6b:	68 1c 2a 80 00       	push   $0x802a1c
  800e70:	e8 28 f3 ff ff       	call   80019d <_panic>

00800e75 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e75:	f3 0f 1e fb          	endbr32 
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
  800e7c:	57                   	push   %edi
  800e7d:	56                   	push   %esi
  800e7e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e85:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e8a:	be 00 00 00 00       	mov    $0x0,%esi
  800e8f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e92:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e95:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e97:	5b                   	pop    %ebx
  800e98:	5e                   	pop    %esi
  800e99:	5f                   	pop    %edi
  800e9a:	5d                   	pop    %ebp
  800e9b:	c3                   	ret    

00800e9c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e9c:	f3 0f 1e fb          	endbr32 
  800ea0:	55                   	push   %ebp
  800ea1:	89 e5                	mov    %esp,%ebp
  800ea3:	57                   	push   %edi
  800ea4:	56                   	push   %esi
  800ea5:	53                   	push   %ebx
  800ea6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eae:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb1:	b8 0d 00 00 00       	mov    $0xd,%eax
  800eb6:	89 cb                	mov    %ecx,%ebx
  800eb8:	89 cf                	mov    %ecx,%edi
  800eba:	89 ce                	mov    %ecx,%esi
  800ebc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ebe:	85 c0                	test   %eax,%eax
  800ec0:	7f 08                	jg     800eca <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ec2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec5:	5b                   	pop    %ebx
  800ec6:	5e                   	pop    %esi
  800ec7:	5f                   	pop    %edi
  800ec8:	5d                   	pop    %ebp
  800ec9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eca:	83 ec 0c             	sub    $0xc,%esp
  800ecd:	50                   	push   %eax
  800ece:	6a 0d                	push   $0xd
  800ed0:	68 ff 29 80 00       	push   $0x8029ff
  800ed5:	6a 23                	push   $0x23
  800ed7:	68 1c 2a 80 00       	push   $0x802a1c
  800edc:	e8 bc f2 ff ff       	call   80019d <_panic>

00800ee1 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800ee1:	f3 0f 1e fb          	endbr32 
  800ee5:	55                   	push   %ebp
  800ee6:	89 e5                	mov    %esp,%ebp
  800ee8:	57                   	push   %edi
  800ee9:	56                   	push   %esi
  800eea:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eeb:	ba 00 00 00 00       	mov    $0x0,%edx
  800ef0:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ef5:	89 d1                	mov    %edx,%ecx
  800ef7:	89 d3                	mov    %edx,%ebx
  800ef9:	89 d7                	mov    %edx,%edi
  800efb:	89 d6                	mov    %edx,%esi
  800efd:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800eff:	5b                   	pop    %ebx
  800f00:	5e                   	pop    %esi
  800f01:	5f                   	pop    %edi
  800f02:	5d                   	pop    %ebp
  800f03:	c3                   	ret    

00800f04 <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  800f04:	f3 0f 1e fb          	endbr32 
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	57                   	push   %edi
  800f0c:	56                   	push   %esi
  800f0d:	53                   	push   %ebx
  800f0e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f11:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f16:	8b 55 08             	mov    0x8(%ebp),%edx
  800f19:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1c:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f21:	89 df                	mov    %ebx,%edi
  800f23:	89 de                	mov    %ebx,%esi
  800f25:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f27:	85 c0                	test   %eax,%eax
  800f29:	7f 08                	jg     800f33 <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  800f2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f2e:	5b                   	pop    %ebx
  800f2f:	5e                   	pop    %esi
  800f30:	5f                   	pop    %edi
  800f31:	5d                   	pop    %ebp
  800f32:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f33:	83 ec 0c             	sub    $0xc,%esp
  800f36:	50                   	push   %eax
  800f37:	6a 0f                	push   $0xf
  800f39:	68 ff 29 80 00       	push   $0x8029ff
  800f3e:	6a 23                	push   $0x23
  800f40:	68 1c 2a 80 00       	push   $0x802a1c
  800f45:	e8 53 f2 ff ff       	call   80019d <_panic>

00800f4a <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  800f4a:	f3 0f 1e fb          	endbr32 
  800f4e:	55                   	push   %ebp
  800f4f:	89 e5                	mov    %esp,%ebp
  800f51:	57                   	push   %edi
  800f52:	56                   	push   %esi
  800f53:	53                   	push   %ebx
  800f54:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f57:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f62:	b8 10 00 00 00       	mov    $0x10,%eax
  800f67:	89 df                	mov    %ebx,%edi
  800f69:	89 de                	mov    %ebx,%esi
  800f6b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f6d:	85 c0                	test   %eax,%eax
  800f6f:	7f 08                	jg     800f79 <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  800f71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f74:	5b                   	pop    %ebx
  800f75:	5e                   	pop    %esi
  800f76:	5f                   	pop    %edi
  800f77:	5d                   	pop    %ebp
  800f78:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f79:	83 ec 0c             	sub    $0xc,%esp
  800f7c:	50                   	push   %eax
  800f7d:	6a 10                	push   $0x10
  800f7f:	68 ff 29 80 00       	push   $0x8029ff
  800f84:	6a 23                	push   $0x23
  800f86:	68 1c 2a 80 00       	push   $0x802a1c
  800f8b:	e8 0d f2 ff ff       	call   80019d <_panic>

00800f90 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f90:	f3 0f 1e fb          	endbr32 
  800f94:	55                   	push   %ebp
  800f95:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	05 00 00 00 30       	add    $0x30000000,%eax
  800f9f:	c1 e8 0c             	shr    $0xc,%eax
}
  800fa2:	5d                   	pop    %ebp
  800fa3:	c3                   	ret    

00800fa4 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fa4:	f3 0f 1e fb          	endbr32 
  800fa8:	55                   	push   %ebp
  800fa9:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800fb3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fb8:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800fbd:	5d                   	pop    %ebp
  800fbe:	c3                   	ret    

00800fbf <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800fbf:	f3 0f 1e fb          	endbr32 
  800fc3:	55                   	push   %ebp
  800fc4:	89 e5                	mov    %esp,%ebp
  800fc6:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fcb:	89 c2                	mov    %eax,%edx
  800fcd:	c1 ea 16             	shr    $0x16,%edx
  800fd0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fd7:	f6 c2 01             	test   $0x1,%dl
  800fda:	74 2d                	je     801009 <fd_alloc+0x4a>
  800fdc:	89 c2                	mov    %eax,%edx
  800fde:	c1 ea 0c             	shr    $0xc,%edx
  800fe1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fe8:	f6 c2 01             	test   $0x1,%dl
  800feb:	74 1c                	je     801009 <fd_alloc+0x4a>
  800fed:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800ff2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800ff7:	75 d2                	jne    800fcb <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801002:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801007:	eb 0a                	jmp    801013 <fd_alloc+0x54>
			*fd_store = fd;
  801009:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80100c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80100e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801013:	5d                   	pop    %ebp
  801014:	c3                   	ret    

00801015 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801015:	f3 0f 1e fb          	endbr32 
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80101f:	83 f8 1f             	cmp    $0x1f,%eax
  801022:	77 30                	ja     801054 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801024:	c1 e0 0c             	shl    $0xc,%eax
  801027:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80102c:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801032:	f6 c2 01             	test   $0x1,%dl
  801035:	74 24                	je     80105b <fd_lookup+0x46>
  801037:	89 c2                	mov    %eax,%edx
  801039:	c1 ea 0c             	shr    $0xc,%edx
  80103c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801043:	f6 c2 01             	test   $0x1,%dl
  801046:	74 1a                	je     801062 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801048:	8b 55 0c             	mov    0xc(%ebp),%edx
  80104b:	89 02                	mov    %eax,(%edx)
	return 0;
  80104d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801052:	5d                   	pop    %ebp
  801053:	c3                   	ret    
		return -E_INVAL;
  801054:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801059:	eb f7                	jmp    801052 <fd_lookup+0x3d>
		return -E_INVAL;
  80105b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801060:	eb f0                	jmp    801052 <fd_lookup+0x3d>
  801062:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801067:	eb e9                	jmp    801052 <fd_lookup+0x3d>

00801069 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801069:	f3 0f 1e fb          	endbr32 
  80106d:	55                   	push   %ebp
  80106e:	89 e5                	mov    %esp,%ebp
  801070:	83 ec 08             	sub    $0x8,%esp
  801073:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801076:	ba 00 00 00 00       	mov    $0x0,%edx
  80107b:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801080:	39 08                	cmp    %ecx,(%eax)
  801082:	74 38                	je     8010bc <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  801084:	83 c2 01             	add    $0x1,%edx
  801087:	8b 04 95 a8 2a 80 00 	mov    0x802aa8(,%edx,4),%eax
  80108e:	85 c0                	test   %eax,%eax
  801090:	75 ee                	jne    801080 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801092:	a1 20 60 80 00       	mov    0x806020,%eax
  801097:	8b 40 48             	mov    0x48(%eax),%eax
  80109a:	83 ec 04             	sub    $0x4,%esp
  80109d:	51                   	push   %ecx
  80109e:	50                   	push   %eax
  80109f:	68 2c 2a 80 00       	push   $0x802a2c
  8010a4:	e8 db f1 ff ff       	call   800284 <cprintf>
	*dev = 0;
  8010a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010b2:	83 c4 10             	add    $0x10,%esp
  8010b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010ba:	c9                   	leave  
  8010bb:	c3                   	ret    
			*dev = devtab[i];
  8010bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010bf:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8010c6:	eb f2                	jmp    8010ba <dev_lookup+0x51>

008010c8 <fd_close>:
{
  8010c8:	f3 0f 1e fb          	endbr32 
  8010cc:	55                   	push   %ebp
  8010cd:	89 e5                	mov    %esp,%ebp
  8010cf:	57                   	push   %edi
  8010d0:	56                   	push   %esi
  8010d1:	53                   	push   %ebx
  8010d2:	83 ec 24             	sub    $0x24,%esp
  8010d5:	8b 75 08             	mov    0x8(%ebp),%esi
  8010d8:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010db:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010de:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010df:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8010e5:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010e8:	50                   	push   %eax
  8010e9:	e8 27 ff ff ff       	call   801015 <fd_lookup>
  8010ee:	89 c3                	mov    %eax,%ebx
  8010f0:	83 c4 10             	add    $0x10,%esp
  8010f3:	85 c0                	test   %eax,%eax
  8010f5:	78 05                	js     8010fc <fd_close+0x34>
	    || fd != fd2)
  8010f7:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8010fa:	74 16                	je     801112 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8010fc:	89 f8                	mov    %edi,%eax
  8010fe:	84 c0                	test   %al,%al
  801100:	b8 00 00 00 00       	mov    $0x0,%eax
  801105:	0f 44 d8             	cmove  %eax,%ebx
}
  801108:	89 d8                	mov    %ebx,%eax
  80110a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80110d:	5b                   	pop    %ebx
  80110e:	5e                   	pop    %esi
  80110f:	5f                   	pop    %edi
  801110:	5d                   	pop    %ebp
  801111:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801112:	83 ec 08             	sub    $0x8,%esp
  801115:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801118:	50                   	push   %eax
  801119:	ff 36                	pushl  (%esi)
  80111b:	e8 49 ff ff ff       	call   801069 <dev_lookup>
  801120:	89 c3                	mov    %eax,%ebx
  801122:	83 c4 10             	add    $0x10,%esp
  801125:	85 c0                	test   %eax,%eax
  801127:	78 1a                	js     801143 <fd_close+0x7b>
		if (dev->dev_close)
  801129:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80112c:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80112f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801134:	85 c0                	test   %eax,%eax
  801136:	74 0b                	je     801143 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801138:	83 ec 0c             	sub    $0xc,%esp
  80113b:	56                   	push   %esi
  80113c:	ff d0                	call   *%eax
  80113e:	89 c3                	mov    %eax,%ebx
  801140:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801143:	83 ec 08             	sub    $0x8,%esp
  801146:	56                   	push   %esi
  801147:	6a 00                	push   $0x0
  801149:	e8 0f fc ff ff       	call   800d5d <sys_page_unmap>
	return r;
  80114e:	83 c4 10             	add    $0x10,%esp
  801151:	eb b5                	jmp    801108 <fd_close+0x40>

00801153 <close>:

int
close(int fdnum)
{
  801153:	f3 0f 1e fb          	endbr32 
  801157:	55                   	push   %ebp
  801158:	89 e5                	mov    %esp,%ebp
  80115a:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80115d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801160:	50                   	push   %eax
  801161:	ff 75 08             	pushl  0x8(%ebp)
  801164:	e8 ac fe ff ff       	call   801015 <fd_lookup>
  801169:	83 c4 10             	add    $0x10,%esp
  80116c:	85 c0                	test   %eax,%eax
  80116e:	79 02                	jns    801172 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801170:	c9                   	leave  
  801171:	c3                   	ret    
		return fd_close(fd, 1);
  801172:	83 ec 08             	sub    $0x8,%esp
  801175:	6a 01                	push   $0x1
  801177:	ff 75 f4             	pushl  -0xc(%ebp)
  80117a:	e8 49 ff ff ff       	call   8010c8 <fd_close>
  80117f:	83 c4 10             	add    $0x10,%esp
  801182:	eb ec                	jmp    801170 <close+0x1d>

00801184 <close_all>:

void
close_all(void)
{
  801184:	f3 0f 1e fb          	endbr32 
  801188:	55                   	push   %ebp
  801189:	89 e5                	mov    %esp,%ebp
  80118b:	53                   	push   %ebx
  80118c:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80118f:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801194:	83 ec 0c             	sub    $0xc,%esp
  801197:	53                   	push   %ebx
  801198:	e8 b6 ff ff ff       	call   801153 <close>
	for (i = 0; i < MAXFD; i++)
  80119d:	83 c3 01             	add    $0x1,%ebx
  8011a0:	83 c4 10             	add    $0x10,%esp
  8011a3:	83 fb 20             	cmp    $0x20,%ebx
  8011a6:	75 ec                	jne    801194 <close_all+0x10>
}
  8011a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011ab:	c9                   	leave  
  8011ac:	c3                   	ret    

008011ad <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011ad:	f3 0f 1e fb          	endbr32 
  8011b1:	55                   	push   %ebp
  8011b2:	89 e5                	mov    %esp,%ebp
  8011b4:	57                   	push   %edi
  8011b5:	56                   	push   %esi
  8011b6:	53                   	push   %ebx
  8011b7:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011ba:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011bd:	50                   	push   %eax
  8011be:	ff 75 08             	pushl  0x8(%ebp)
  8011c1:	e8 4f fe ff ff       	call   801015 <fd_lookup>
  8011c6:	89 c3                	mov    %eax,%ebx
  8011c8:	83 c4 10             	add    $0x10,%esp
  8011cb:	85 c0                	test   %eax,%eax
  8011cd:	0f 88 81 00 00 00    	js     801254 <dup+0xa7>
		return r;
	close(newfdnum);
  8011d3:	83 ec 0c             	sub    $0xc,%esp
  8011d6:	ff 75 0c             	pushl  0xc(%ebp)
  8011d9:	e8 75 ff ff ff       	call   801153 <close>

	newfd = INDEX2FD(newfdnum);
  8011de:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011e1:	c1 e6 0c             	shl    $0xc,%esi
  8011e4:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8011ea:	83 c4 04             	add    $0x4,%esp
  8011ed:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011f0:	e8 af fd ff ff       	call   800fa4 <fd2data>
  8011f5:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8011f7:	89 34 24             	mov    %esi,(%esp)
  8011fa:	e8 a5 fd ff ff       	call   800fa4 <fd2data>
  8011ff:	83 c4 10             	add    $0x10,%esp
  801202:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801204:	89 d8                	mov    %ebx,%eax
  801206:	c1 e8 16             	shr    $0x16,%eax
  801209:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801210:	a8 01                	test   $0x1,%al
  801212:	74 11                	je     801225 <dup+0x78>
  801214:	89 d8                	mov    %ebx,%eax
  801216:	c1 e8 0c             	shr    $0xc,%eax
  801219:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801220:	f6 c2 01             	test   $0x1,%dl
  801223:	75 39                	jne    80125e <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801225:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801228:	89 d0                	mov    %edx,%eax
  80122a:	c1 e8 0c             	shr    $0xc,%eax
  80122d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801234:	83 ec 0c             	sub    $0xc,%esp
  801237:	25 07 0e 00 00       	and    $0xe07,%eax
  80123c:	50                   	push   %eax
  80123d:	56                   	push   %esi
  80123e:	6a 00                	push   $0x0
  801240:	52                   	push   %edx
  801241:	6a 00                	push   $0x0
  801243:	e8 cf fa ff ff       	call   800d17 <sys_page_map>
  801248:	89 c3                	mov    %eax,%ebx
  80124a:	83 c4 20             	add    $0x20,%esp
  80124d:	85 c0                	test   %eax,%eax
  80124f:	78 31                	js     801282 <dup+0xd5>
		goto err;

	return newfdnum;
  801251:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801254:	89 d8                	mov    %ebx,%eax
  801256:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801259:	5b                   	pop    %ebx
  80125a:	5e                   	pop    %esi
  80125b:	5f                   	pop    %edi
  80125c:	5d                   	pop    %ebp
  80125d:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80125e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801265:	83 ec 0c             	sub    $0xc,%esp
  801268:	25 07 0e 00 00       	and    $0xe07,%eax
  80126d:	50                   	push   %eax
  80126e:	57                   	push   %edi
  80126f:	6a 00                	push   $0x0
  801271:	53                   	push   %ebx
  801272:	6a 00                	push   $0x0
  801274:	e8 9e fa ff ff       	call   800d17 <sys_page_map>
  801279:	89 c3                	mov    %eax,%ebx
  80127b:	83 c4 20             	add    $0x20,%esp
  80127e:	85 c0                	test   %eax,%eax
  801280:	79 a3                	jns    801225 <dup+0x78>
	sys_page_unmap(0, newfd);
  801282:	83 ec 08             	sub    $0x8,%esp
  801285:	56                   	push   %esi
  801286:	6a 00                	push   $0x0
  801288:	e8 d0 fa ff ff       	call   800d5d <sys_page_unmap>
	sys_page_unmap(0, nva);
  80128d:	83 c4 08             	add    $0x8,%esp
  801290:	57                   	push   %edi
  801291:	6a 00                	push   $0x0
  801293:	e8 c5 fa ff ff       	call   800d5d <sys_page_unmap>
	return r;
  801298:	83 c4 10             	add    $0x10,%esp
  80129b:	eb b7                	jmp    801254 <dup+0xa7>

0080129d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80129d:	f3 0f 1e fb          	endbr32 
  8012a1:	55                   	push   %ebp
  8012a2:	89 e5                	mov    %esp,%ebp
  8012a4:	53                   	push   %ebx
  8012a5:	83 ec 1c             	sub    $0x1c,%esp
  8012a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012ab:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012ae:	50                   	push   %eax
  8012af:	53                   	push   %ebx
  8012b0:	e8 60 fd ff ff       	call   801015 <fd_lookup>
  8012b5:	83 c4 10             	add    $0x10,%esp
  8012b8:	85 c0                	test   %eax,%eax
  8012ba:	78 3f                	js     8012fb <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012bc:	83 ec 08             	sub    $0x8,%esp
  8012bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012c2:	50                   	push   %eax
  8012c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012c6:	ff 30                	pushl  (%eax)
  8012c8:	e8 9c fd ff ff       	call   801069 <dev_lookup>
  8012cd:	83 c4 10             	add    $0x10,%esp
  8012d0:	85 c0                	test   %eax,%eax
  8012d2:	78 27                	js     8012fb <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012d7:	8b 42 08             	mov    0x8(%edx),%eax
  8012da:	83 e0 03             	and    $0x3,%eax
  8012dd:	83 f8 01             	cmp    $0x1,%eax
  8012e0:	74 1e                	je     801300 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8012e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e5:	8b 40 08             	mov    0x8(%eax),%eax
  8012e8:	85 c0                	test   %eax,%eax
  8012ea:	74 35                	je     801321 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012ec:	83 ec 04             	sub    $0x4,%esp
  8012ef:	ff 75 10             	pushl  0x10(%ebp)
  8012f2:	ff 75 0c             	pushl  0xc(%ebp)
  8012f5:	52                   	push   %edx
  8012f6:	ff d0                	call   *%eax
  8012f8:	83 c4 10             	add    $0x10,%esp
}
  8012fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012fe:	c9                   	leave  
  8012ff:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801300:	a1 20 60 80 00       	mov    0x806020,%eax
  801305:	8b 40 48             	mov    0x48(%eax),%eax
  801308:	83 ec 04             	sub    $0x4,%esp
  80130b:	53                   	push   %ebx
  80130c:	50                   	push   %eax
  80130d:	68 6d 2a 80 00       	push   $0x802a6d
  801312:	e8 6d ef ff ff       	call   800284 <cprintf>
		return -E_INVAL;
  801317:	83 c4 10             	add    $0x10,%esp
  80131a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80131f:	eb da                	jmp    8012fb <read+0x5e>
		return -E_NOT_SUPP;
  801321:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801326:	eb d3                	jmp    8012fb <read+0x5e>

00801328 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801328:	f3 0f 1e fb          	endbr32 
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
  80132f:	57                   	push   %edi
  801330:	56                   	push   %esi
  801331:	53                   	push   %ebx
  801332:	83 ec 0c             	sub    $0xc,%esp
  801335:	8b 7d 08             	mov    0x8(%ebp),%edi
  801338:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80133b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801340:	eb 02                	jmp    801344 <readn+0x1c>
  801342:	01 c3                	add    %eax,%ebx
  801344:	39 f3                	cmp    %esi,%ebx
  801346:	73 21                	jae    801369 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801348:	83 ec 04             	sub    $0x4,%esp
  80134b:	89 f0                	mov    %esi,%eax
  80134d:	29 d8                	sub    %ebx,%eax
  80134f:	50                   	push   %eax
  801350:	89 d8                	mov    %ebx,%eax
  801352:	03 45 0c             	add    0xc(%ebp),%eax
  801355:	50                   	push   %eax
  801356:	57                   	push   %edi
  801357:	e8 41 ff ff ff       	call   80129d <read>
		if (m < 0)
  80135c:	83 c4 10             	add    $0x10,%esp
  80135f:	85 c0                	test   %eax,%eax
  801361:	78 04                	js     801367 <readn+0x3f>
			return m;
		if (m == 0)
  801363:	75 dd                	jne    801342 <readn+0x1a>
  801365:	eb 02                	jmp    801369 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801367:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801369:	89 d8                	mov    %ebx,%eax
  80136b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80136e:	5b                   	pop    %ebx
  80136f:	5e                   	pop    %esi
  801370:	5f                   	pop    %edi
  801371:	5d                   	pop    %ebp
  801372:	c3                   	ret    

00801373 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801373:	f3 0f 1e fb          	endbr32 
  801377:	55                   	push   %ebp
  801378:	89 e5                	mov    %esp,%ebp
  80137a:	53                   	push   %ebx
  80137b:	83 ec 1c             	sub    $0x1c,%esp
  80137e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801381:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801384:	50                   	push   %eax
  801385:	53                   	push   %ebx
  801386:	e8 8a fc ff ff       	call   801015 <fd_lookup>
  80138b:	83 c4 10             	add    $0x10,%esp
  80138e:	85 c0                	test   %eax,%eax
  801390:	78 3a                	js     8013cc <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801392:	83 ec 08             	sub    $0x8,%esp
  801395:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801398:	50                   	push   %eax
  801399:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80139c:	ff 30                	pushl  (%eax)
  80139e:	e8 c6 fc ff ff       	call   801069 <dev_lookup>
  8013a3:	83 c4 10             	add    $0x10,%esp
  8013a6:	85 c0                	test   %eax,%eax
  8013a8:	78 22                	js     8013cc <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ad:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013b1:	74 1e                	je     8013d1 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b6:	8b 52 0c             	mov    0xc(%edx),%edx
  8013b9:	85 d2                	test   %edx,%edx
  8013bb:	74 35                	je     8013f2 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013bd:	83 ec 04             	sub    $0x4,%esp
  8013c0:	ff 75 10             	pushl  0x10(%ebp)
  8013c3:	ff 75 0c             	pushl  0xc(%ebp)
  8013c6:	50                   	push   %eax
  8013c7:	ff d2                	call   *%edx
  8013c9:	83 c4 10             	add    $0x10,%esp
}
  8013cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013cf:	c9                   	leave  
  8013d0:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013d1:	a1 20 60 80 00       	mov    0x806020,%eax
  8013d6:	8b 40 48             	mov    0x48(%eax),%eax
  8013d9:	83 ec 04             	sub    $0x4,%esp
  8013dc:	53                   	push   %ebx
  8013dd:	50                   	push   %eax
  8013de:	68 89 2a 80 00       	push   $0x802a89
  8013e3:	e8 9c ee ff ff       	call   800284 <cprintf>
		return -E_INVAL;
  8013e8:	83 c4 10             	add    $0x10,%esp
  8013eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013f0:	eb da                	jmp    8013cc <write+0x59>
		return -E_NOT_SUPP;
  8013f2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013f7:	eb d3                	jmp    8013cc <write+0x59>

008013f9 <seek>:

int
seek(int fdnum, off_t offset)
{
  8013f9:	f3 0f 1e fb          	endbr32 
  8013fd:	55                   	push   %ebp
  8013fe:	89 e5                	mov    %esp,%ebp
  801400:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801403:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801406:	50                   	push   %eax
  801407:	ff 75 08             	pushl  0x8(%ebp)
  80140a:	e8 06 fc ff ff       	call   801015 <fd_lookup>
  80140f:	83 c4 10             	add    $0x10,%esp
  801412:	85 c0                	test   %eax,%eax
  801414:	78 0e                	js     801424 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801416:	8b 55 0c             	mov    0xc(%ebp),%edx
  801419:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80141c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80141f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801424:	c9                   	leave  
  801425:	c3                   	ret    

00801426 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801426:	f3 0f 1e fb          	endbr32 
  80142a:	55                   	push   %ebp
  80142b:	89 e5                	mov    %esp,%ebp
  80142d:	53                   	push   %ebx
  80142e:	83 ec 1c             	sub    $0x1c,%esp
  801431:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801434:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801437:	50                   	push   %eax
  801438:	53                   	push   %ebx
  801439:	e8 d7 fb ff ff       	call   801015 <fd_lookup>
  80143e:	83 c4 10             	add    $0x10,%esp
  801441:	85 c0                	test   %eax,%eax
  801443:	78 37                	js     80147c <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801445:	83 ec 08             	sub    $0x8,%esp
  801448:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80144b:	50                   	push   %eax
  80144c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80144f:	ff 30                	pushl  (%eax)
  801451:	e8 13 fc ff ff       	call   801069 <dev_lookup>
  801456:	83 c4 10             	add    $0x10,%esp
  801459:	85 c0                	test   %eax,%eax
  80145b:	78 1f                	js     80147c <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80145d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801460:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801464:	74 1b                	je     801481 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801466:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801469:	8b 52 18             	mov    0x18(%edx),%edx
  80146c:	85 d2                	test   %edx,%edx
  80146e:	74 32                	je     8014a2 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801470:	83 ec 08             	sub    $0x8,%esp
  801473:	ff 75 0c             	pushl  0xc(%ebp)
  801476:	50                   	push   %eax
  801477:	ff d2                	call   *%edx
  801479:	83 c4 10             	add    $0x10,%esp
}
  80147c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80147f:	c9                   	leave  
  801480:	c3                   	ret    
			thisenv->env_id, fdnum);
  801481:	a1 20 60 80 00       	mov    0x806020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801486:	8b 40 48             	mov    0x48(%eax),%eax
  801489:	83 ec 04             	sub    $0x4,%esp
  80148c:	53                   	push   %ebx
  80148d:	50                   	push   %eax
  80148e:	68 4c 2a 80 00       	push   $0x802a4c
  801493:	e8 ec ed ff ff       	call   800284 <cprintf>
		return -E_INVAL;
  801498:	83 c4 10             	add    $0x10,%esp
  80149b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014a0:	eb da                	jmp    80147c <ftruncate+0x56>
		return -E_NOT_SUPP;
  8014a2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014a7:	eb d3                	jmp    80147c <ftruncate+0x56>

008014a9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014a9:	f3 0f 1e fb          	endbr32 
  8014ad:	55                   	push   %ebp
  8014ae:	89 e5                	mov    %esp,%ebp
  8014b0:	53                   	push   %ebx
  8014b1:	83 ec 1c             	sub    $0x1c,%esp
  8014b4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014b7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014ba:	50                   	push   %eax
  8014bb:	ff 75 08             	pushl  0x8(%ebp)
  8014be:	e8 52 fb ff ff       	call   801015 <fd_lookup>
  8014c3:	83 c4 10             	add    $0x10,%esp
  8014c6:	85 c0                	test   %eax,%eax
  8014c8:	78 4b                	js     801515 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ca:	83 ec 08             	sub    $0x8,%esp
  8014cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014d0:	50                   	push   %eax
  8014d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d4:	ff 30                	pushl  (%eax)
  8014d6:	e8 8e fb ff ff       	call   801069 <dev_lookup>
  8014db:	83 c4 10             	add    $0x10,%esp
  8014de:	85 c0                	test   %eax,%eax
  8014e0:	78 33                	js     801515 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8014e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014e5:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014e9:	74 2f                	je     80151a <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014eb:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014ee:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014f5:	00 00 00 
	stat->st_isdir = 0;
  8014f8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014ff:	00 00 00 
	stat->st_dev = dev;
  801502:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801508:	83 ec 08             	sub    $0x8,%esp
  80150b:	53                   	push   %ebx
  80150c:	ff 75 f0             	pushl  -0x10(%ebp)
  80150f:	ff 50 14             	call   *0x14(%eax)
  801512:	83 c4 10             	add    $0x10,%esp
}
  801515:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801518:	c9                   	leave  
  801519:	c3                   	ret    
		return -E_NOT_SUPP;
  80151a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80151f:	eb f4                	jmp    801515 <fstat+0x6c>

00801521 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801521:	f3 0f 1e fb          	endbr32 
  801525:	55                   	push   %ebp
  801526:	89 e5                	mov    %esp,%ebp
  801528:	56                   	push   %esi
  801529:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80152a:	83 ec 08             	sub    $0x8,%esp
  80152d:	6a 00                	push   $0x0
  80152f:	ff 75 08             	pushl  0x8(%ebp)
  801532:	e8 fb 01 00 00       	call   801732 <open>
  801537:	89 c3                	mov    %eax,%ebx
  801539:	83 c4 10             	add    $0x10,%esp
  80153c:	85 c0                	test   %eax,%eax
  80153e:	78 1b                	js     80155b <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801540:	83 ec 08             	sub    $0x8,%esp
  801543:	ff 75 0c             	pushl  0xc(%ebp)
  801546:	50                   	push   %eax
  801547:	e8 5d ff ff ff       	call   8014a9 <fstat>
  80154c:	89 c6                	mov    %eax,%esi
	close(fd);
  80154e:	89 1c 24             	mov    %ebx,(%esp)
  801551:	e8 fd fb ff ff       	call   801153 <close>
	return r;
  801556:	83 c4 10             	add    $0x10,%esp
  801559:	89 f3                	mov    %esi,%ebx
}
  80155b:	89 d8                	mov    %ebx,%eax
  80155d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801560:	5b                   	pop    %ebx
  801561:	5e                   	pop    %esi
  801562:	5d                   	pop    %ebp
  801563:	c3                   	ret    

00801564 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
  801567:	56                   	push   %esi
  801568:	53                   	push   %ebx
  801569:	89 c6                	mov    %eax,%esi
  80156b:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80156d:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801574:	74 27                	je     80159d <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801576:	6a 07                	push   $0x7
  801578:	68 00 70 80 00       	push   $0x807000
  80157d:	56                   	push   %esi
  80157e:	ff 35 00 40 80 00    	pushl  0x804000
  801584:	e8 b2 0d 00 00       	call   80233b <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801589:	83 c4 0c             	add    $0xc,%esp
  80158c:	6a 00                	push   $0x0
  80158e:	53                   	push   %ebx
  80158f:	6a 00                	push   $0x0
  801591:	e8 20 0d 00 00       	call   8022b6 <ipc_recv>
}
  801596:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801599:	5b                   	pop    %ebx
  80159a:	5e                   	pop    %esi
  80159b:	5d                   	pop    %ebp
  80159c:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80159d:	83 ec 0c             	sub    $0xc,%esp
  8015a0:	6a 01                	push   $0x1
  8015a2:	e8 ec 0d 00 00       	call   802393 <ipc_find_env>
  8015a7:	a3 00 40 80 00       	mov    %eax,0x804000
  8015ac:	83 c4 10             	add    $0x10,%esp
  8015af:	eb c5                	jmp    801576 <fsipc+0x12>

008015b1 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015b1:	f3 0f 1e fb          	endbr32 
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	8b 40 0c             	mov    0xc(%eax),%eax
  8015c1:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  8015c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c9:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d3:	b8 02 00 00 00       	mov    $0x2,%eax
  8015d8:	e8 87 ff ff ff       	call   801564 <fsipc>
}
  8015dd:	c9                   	leave  
  8015de:	c3                   	ret    

008015df <devfile_flush>:
{
  8015df:	f3 0f 1e fb          	endbr32 
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
  8015e6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8015ef:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  8015f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f9:	b8 06 00 00 00       	mov    $0x6,%eax
  8015fe:	e8 61 ff ff ff       	call   801564 <fsipc>
}
  801603:	c9                   	leave  
  801604:	c3                   	ret    

00801605 <devfile_stat>:
{
  801605:	f3 0f 1e fb          	endbr32 
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
  80160c:	53                   	push   %ebx
  80160d:	83 ec 04             	sub    $0x4,%esp
  801610:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801613:	8b 45 08             	mov    0x8(%ebp),%eax
  801616:	8b 40 0c             	mov    0xc(%eax),%eax
  801619:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80161e:	ba 00 00 00 00       	mov    $0x0,%edx
  801623:	b8 05 00 00 00       	mov    $0x5,%eax
  801628:	e8 37 ff ff ff       	call   801564 <fsipc>
  80162d:	85 c0                	test   %eax,%eax
  80162f:	78 2c                	js     80165d <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801631:	83 ec 08             	sub    $0x8,%esp
  801634:	68 00 70 80 00       	push   $0x807000
  801639:	53                   	push   %ebx
  80163a:	e8 4f f2 ff ff       	call   80088e <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80163f:	a1 80 70 80 00       	mov    0x807080,%eax
  801644:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80164a:	a1 84 70 80 00       	mov    0x807084,%eax
  80164f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801655:	83 c4 10             	add    $0x10,%esp
  801658:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80165d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801660:	c9                   	leave  
  801661:	c3                   	ret    

00801662 <devfile_write>:
{
  801662:	f3 0f 1e fb          	endbr32 
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
  801669:	83 ec 0c             	sub    $0xc,%esp
  80166c:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80166f:	8b 55 08             	mov    0x8(%ebp),%edx
  801672:	8b 52 0c             	mov    0xc(%edx),%edx
  801675:	89 15 00 70 80 00    	mov    %edx,0x807000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  80167b:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801680:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801685:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  801688:	a3 04 70 80 00       	mov    %eax,0x807004
	memmove(fsipcbuf.write.req_buf, buf, n);
  80168d:	50                   	push   %eax
  80168e:	ff 75 0c             	pushl  0xc(%ebp)
  801691:	68 08 70 80 00       	push   $0x807008
  801696:	e8 a9 f3 ff ff       	call   800a44 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  80169b:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a0:	b8 04 00 00 00       	mov    $0x4,%eax
  8016a5:	e8 ba fe ff ff       	call   801564 <fsipc>
}
  8016aa:	c9                   	leave  
  8016ab:	c3                   	ret    

008016ac <devfile_read>:
{
  8016ac:	f3 0f 1e fb          	endbr32 
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
  8016b3:	56                   	push   %esi
  8016b4:	53                   	push   %ebx
  8016b5:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8016be:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  8016c3:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ce:	b8 03 00 00 00       	mov    $0x3,%eax
  8016d3:	e8 8c fe ff ff       	call   801564 <fsipc>
  8016d8:	89 c3                	mov    %eax,%ebx
  8016da:	85 c0                	test   %eax,%eax
  8016dc:	78 1f                	js     8016fd <devfile_read+0x51>
	assert(r <= n);
  8016de:	39 f0                	cmp    %esi,%eax
  8016e0:	77 24                	ja     801706 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8016e2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016e7:	7f 33                	jg     80171c <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8016e9:	83 ec 04             	sub    $0x4,%esp
  8016ec:	50                   	push   %eax
  8016ed:	68 00 70 80 00       	push   $0x807000
  8016f2:	ff 75 0c             	pushl  0xc(%ebp)
  8016f5:	e8 4a f3 ff ff       	call   800a44 <memmove>
	return r;
  8016fa:	83 c4 10             	add    $0x10,%esp
}
  8016fd:	89 d8                	mov    %ebx,%eax
  8016ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801702:	5b                   	pop    %ebx
  801703:	5e                   	pop    %esi
  801704:	5d                   	pop    %ebp
  801705:	c3                   	ret    
	assert(r <= n);
  801706:	68 bc 2a 80 00       	push   $0x802abc
  80170b:	68 c3 2a 80 00       	push   $0x802ac3
  801710:	6a 7c                	push   $0x7c
  801712:	68 d8 2a 80 00       	push   $0x802ad8
  801717:	e8 81 ea ff ff       	call   80019d <_panic>
	assert(r <= PGSIZE);
  80171c:	68 e3 2a 80 00       	push   $0x802ae3
  801721:	68 c3 2a 80 00       	push   $0x802ac3
  801726:	6a 7d                	push   $0x7d
  801728:	68 d8 2a 80 00       	push   $0x802ad8
  80172d:	e8 6b ea ff ff       	call   80019d <_panic>

00801732 <open>:
{
  801732:	f3 0f 1e fb          	endbr32 
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
  801739:	56                   	push   %esi
  80173a:	53                   	push   %ebx
  80173b:	83 ec 1c             	sub    $0x1c,%esp
  80173e:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801741:	56                   	push   %esi
  801742:	e8 04 f1 ff ff       	call   80084b <strlen>
  801747:	83 c4 10             	add    $0x10,%esp
  80174a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80174f:	7f 6c                	jg     8017bd <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801751:	83 ec 0c             	sub    $0xc,%esp
  801754:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801757:	50                   	push   %eax
  801758:	e8 62 f8 ff ff       	call   800fbf <fd_alloc>
  80175d:	89 c3                	mov    %eax,%ebx
  80175f:	83 c4 10             	add    $0x10,%esp
  801762:	85 c0                	test   %eax,%eax
  801764:	78 3c                	js     8017a2 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801766:	83 ec 08             	sub    $0x8,%esp
  801769:	56                   	push   %esi
  80176a:	68 00 70 80 00       	push   $0x807000
  80176f:	e8 1a f1 ff ff       	call   80088e <strcpy>
	fsipcbuf.open.req_omode = mode;
  801774:	8b 45 0c             	mov    0xc(%ebp),%eax
  801777:	a3 00 74 80 00       	mov    %eax,0x807400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80177c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80177f:	b8 01 00 00 00       	mov    $0x1,%eax
  801784:	e8 db fd ff ff       	call   801564 <fsipc>
  801789:	89 c3                	mov    %eax,%ebx
  80178b:	83 c4 10             	add    $0x10,%esp
  80178e:	85 c0                	test   %eax,%eax
  801790:	78 19                	js     8017ab <open+0x79>
	return fd2num(fd);
  801792:	83 ec 0c             	sub    $0xc,%esp
  801795:	ff 75 f4             	pushl  -0xc(%ebp)
  801798:	e8 f3 f7 ff ff       	call   800f90 <fd2num>
  80179d:	89 c3                	mov    %eax,%ebx
  80179f:	83 c4 10             	add    $0x10,%esp
}
  8017a2:	89 d8                	mov    %ebx,%eax
  8017a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017a7:	5b                   	pop    %ebx
  8017a8:	5e                   	pop    %esi
  8017a9:	5d                   	pop    %ebp
  8017aa:	c3                   	ret    
		fd_close(fd, 0);
  8017ab:	83 ec 08             	sub    $0x8,%esp
  8017ae:	6a 00                	push   $0x0
  8017b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8017b3:	e8 10 f9 ff ff       	call   8010c8 <fd_close>
		return r;
  8017b8:	83 c4 10             	add    $0x10,%esp
  8017bb:	eb e5                	jmp    8017a2 <open+0x70>
		return -E_BAD_PATH;
  8017bd:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017c2:	eb de                	jmp    8017a2 <open+0x70>

008017c4 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017c4:	f3 0f 1e fb          	endbr32 
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
  8017cb:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d3:	b8 08 00 00 00       	mov    $0x8,%eax
  8017d8:	e8 87 fd ff ff       	call   801564 <fsipc>
}
  8017dd:	c9                   	leave  
  8017de:	c3                   	ret    

008017df <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  8017df:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8017e3:	7f 01                	jg     8017e6 <writebuf+0x7>
  8017e5:	c3                   	ret    
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
  8017e9:	53                   	push   %ebx
  8017ea:	83 ec 08             	sub    $0x8,%esp
  8017ed:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  8017ef:	ff 70 04             	pushl  0x4(%eax)
  8017f2:	8d 40 10             	lea    0x10(%eax),%eax
  8017f5:	50                   	push   %eax
  8017f6:	ff 33                	pushl  (%ebx)
  8017f8:	e8 76 fb ff ff       	call   801373 <write>
		if (result > 0)
  8017fd:	83 c4 10             	add    $0x10,%esp
  801800:	85 c0                	test   %eax,%eax
  801802:	7e 03                	jle    801807 <writebuf+0x28>
			b->result += result;
  801804:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801807:	39 43 04             	cmp    %eax,0x4(%ebx)
  80180a:	74 0d                	je     801819 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  80180c:	85 c0                	test   %eax,%eax
  80180e:	ba 00 00 00 00       	mov    $0x0,%edx
  801813:	0f 4f c2             	cmovg  %edx,%eax
  801816:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801819:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80181c:	c9                   	leave  
  80181d:	c3                   	ret    

0080181e <putch>:

static void
putch(int ch, void *thunk)
{
  80181e:	f3 0f 1e fb          	endbr32 
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
  801825:	53                   	push   %ebx
  801826:	83 ec 04             	sub    $0x4,%esp
  801829:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  80182c:	8b 53 04             	mov    0x4(%ebx),%edx
  80182f:	8d 42 01             	lea    0x1(%edx),%eax
  801832:	89 43 04             	mov    %eax,0x4(%ebx)
  801835:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801838:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  80183c:	3d 00 01 00 00       	cmp    $0x100,%eax
  801841:	74 06                	je     801849 <putch+0x2b>
		writebuf(b);
		b->idx = 0;
	}
}
  801843:	83 c4 04             	add    $0x4,%esp
  801846:	5b                   	pop    %ebx
  801847:	5d                   	pop    %ebp
  801848:	c3                   	ret    
		writebuf(b);
  801849:	89 d8                	mov    %ebx,%eax
  80184b:	e8 8f ff ff ff       	call   8017df <writebuf>
		b->idx = 0;
  801850:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801857:	eb ea                	jmp    801843 <putch+0x25>

00801859 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801859:	f3 0f 1e fb          	endbr32 
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
  801860:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801866:	8b 45 08             	mov    0x8(%ebp),%eax
  801869:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  80186f:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801876:	00 00 00 
	b.result = 0;
  801879:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801880:	00 00 00 
	b.error = 1;
  801883:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  80188a:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  80188d:	ff 75 10             	pushl  0x10(%ebp)
  801890:	ff 75 0c             	pushl  0xc(%ebp)
  801893:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801899:	50                   	push   %eax
  80189a:	68 1e 18 80 00       	push   $0x80181e
  80189f:	e8 e3 ea ff ff       	call   800387 <vprintfmt>
	if (b.idx > 0)
  8018a4:	83 c4 10             	add    $0x10,%esp
  8018a7:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  8018ae:	7f 11                	jg     8018c1 <vfprintf+0x68>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  8018b0:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8018b6:	85 c0                	test   %eax,%eax
  8018b8:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    
		writebuf(&b);
  8018c1:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8018c7:	e8 13 ff ff ff       	call   8017df <writebuf>
  8018cc:	eb e2                	jmp    8018b0 <vfprintf+0x57>

008018ce <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8018ce:	f3 0f 1e fb          	endbr32 
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
  8018d5:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8018d8:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  8018db:	50                   	push   %eax
  8018dc:	ff 75 0c             	pushl  0xc(%ebp)
  8018df:	ff 75 08             	pushl  0x8(%ebp)
  8018e2:	e8 72 ff ff ff       	call   801859 <vfprintf>
	va_end(ap);

	return cnt;
}
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

008018e9 <printf>:

int
printf(const char *fmt, ...)
{
  8018e9:	f3 0f 1e fb          	endbr32 
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
  8018f0:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8018f3:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  8018f6:	50                   	push   %eax
  8018f7:	ff 75 08             	pushl  0x8(%ebp)
  8018fa:	6a 01                	push   $0x1
  8018fc:	e8 58 ff ff ff       	call   801859 <vfprintf>
	va_end(ap);

	return cnt;
}
  801901:	c9                   	leave  
  801902:	c3                   	ret    

00801903 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801903:	f3 0f 1e fb          	endbr32 
  801907:	55                   	push   %ebp
  801908:	89 e5                	mov    %esp,%ebp
  80190a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80190d:	68 ef 2a 80 00       	push   $0x802aef
  801912:	ff 75 0c             	pushl  0xc(%ebp)
  801915:	e8 74 ef ff ff       	call   80088e <strcpy>
	return 0;
}
  80191a:	b8 00 00 00 00       	mov    $0x0,%eax
  80191f:	c9                   	leave  
  801920:	c3                   	ret    

00801921 <devsock_close>:
{
  801921:	f3 0f 1e fb          	endbr32 
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
  801928:	53                   	push   %ebx
  801929:	83 ec 10             	sub    $0x10,%esp
  80192c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80192f:	53                   	push   %ebx
  801930:	e8 9b 0a 00 00       	call   8023d0 <pageref>
  801935:	89 c2                	mov    %eax,%edx
  801937:	83 c4 10             	add    $0x10,%esp
		return 0;
  80193a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  80193f:	83 fa 01             	cmp    $0x1,%edx
  801942:	74 05                	je     801949 <devsock_close+0x28>
}
  801944:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801947:	c9                   	leave  
  801948:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801949:	83 ec 0c             	sub    $0xc,%esp
  80194c:	ff 73 0c             	pushl  0xc(%ebx)
  80194f:	e8 e3 02 00 00       	call   801c37 <nsipc_close>
  801954:	83 c4 10             	add    $0x10,%esp
  801957:	eb eb                	jmp    801944 <devsock_close+0x23>

00801959 <devsock_write>:
{
  801959:	f3 0f 1e fb          	endbr32 
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
  801960:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801963:	6a 00                	push   $0x0
  801965:	ff 75 10             	pushl  0x10(%ebp)
  801968:	ff 75 0c             	pushl  0xc(%ebp)
  80196b:	8b 45 08             	mov    0x8(%ebp),%eax
  80196e:	ff 70 0c             	pushl  0xc(%eax)
  801971:	e8 b5 03 00 00       	call   801d2b <nsipc_send>
}
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <devsock_read>:
{
  801978:	f3 0f 1e fb          	endbr32 
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
  80197f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801982:	6a 00                	push   $0x0
  801984:	ff 75 10             	pushl  0x10(%ebp)
  801987:	ff 75 0c             	pushl  0xc(%ebp)
  80198a:	8b 45 08             	mov    0x8(%ebp),%eax
  80198d:	ff 70 0c             	pushl  0xc(%eax)
  801990:	e8 1f 03 00 00       	call   801cb4 <nsipc_recv>
}
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <fd2sockid>:
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
  80199a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80199d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8019a0:	52                   	push   %edx
  8019a1:	50                   	push   %eax
  8019a2:	e8 6e f6 ff ff       	call   801015 <fd_lookup>
  8019a7:	83 c4 10             	add    $0x10,%esp
  8019aa:	85 c0                	test   %eax,%eax
  8019ac:	78 10                	js     8019be <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8019ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b1:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8019b7:	39 08                	cmp    %ecx,(%eax)
  8019b9:	75 05                	jne    8019c0 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8019bb:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    
		return -E_NOT_SUPP;
  8019c0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019c5:	eb f7                	jmp    8019be <fd2sockid+0x27>

008019c7 <alloc_sockfd>:
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
  8019ca:	56                   	push   %esi
  8019cb:	53                   	push   %ebx
  8019cc:	83 ec 1c             	sub    $0x1c,%esp
  8019cf:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8019d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019d4:	50                   	push   %eax
  8019d5:	e8 e5 f5 ff ff       	call   800fbf <fd_alloc>
  8019da:	89 c3                	mov    %eax,%ebx
  8019dc:	83 c4 10             	add    $0x10,%esp
  8019df:	85 c0                	test   %eax,%eax
  8019e1:	78 43                	js     801a26 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8019e3:	83 ec 04             	sub    $0x4,%esp
  8019e6:	68 07 04 00 00       	push   $0x407
  8019eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8019ee:	6a 00                	push   $0x0
  8019f0:	e8 db f2 ff ff       	call   800cd0 <sys_page_alloc>
  8019f5:	89 c3                	mov    %eax,%ebx
  8019f7:	83 c4 10             	add    $0x10,%esp
  8019fa:	85 c0                	test   %eax,%eax
  8019fc:	78 28                	js     801a26 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8019fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a01:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a07:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a0c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801a13:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801a16:	83 ec 0c             	sub    $0xc,%esp
  801a19:	50                   	push   %eax
  801a1a:	e8 71 f5 ff ff       	call   800f90 <fd2num>
  801a1f:	89 c3                	mov    %eax,%ebx
  801a21:	83 c4 10             	add    $0x10,%esp
  801a24:	eb 0c                	jmp    801a32 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801a26:	83 ec 0c             	sub    $0xc,%esp
  801a29:	56                   	push   %esi
  801a2a:	e8 08 02 00 00       	call   801c37 <nsipc_close>
		return r;
  801a2f:	83 c4 10             	add    $0x10,%esp
}
  801a32:	89 d8                	mov    %ebx,%eax
  801a34:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a37:	5b                   	pop    %ebx
  801a38:	5e                   	pop    %esi
  801a39:	5d                   	pop    %ebp
  801a3a:	c3                   	ret    

00801a3b <accept>:
{
  801a3b:	f3 0f 1e fb          	endbr32 
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
  801a42:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a45:	8b 45 08             	mov    0x8(%ebp),%eax
  801a48:	e8 4a ff ff ff       	call   801997 <fd2sockid>
  801a4d:	85 c0                	test   %eax,%eax
  801a4f:	78 1b                	js     801a6c <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a51:	83 ec 04             	sub    $0x4,%esp
  801a54:	ff 75 10             	pushl  0x10(%ebp)
  801a57:	ff 75 0c             	pushl  0xc(%ebp)
  801a5a:	50                   	push   %eax
  801a5b:	e8 22 01 00 00       	call   801b82 <nsipc_accept>
  801a60:	83 c4 10             	add    $0x10,%esp
  801a63:	85 c0                	test   %eax,%eax
  801a65:	78 05                	js     801a6c <accept+0x31>
	return alloc_sockfd(r);
  801a67:	e8 5b ff ff ff       	call   8019c7 <alloc_sockfd>
}
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <bind>:
{
  801a6e:	f3 0f 1e fb          	endbr32 
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
  801a75:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a78:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7b:	e8 17 ff ff ff       	call   801997 <fd2sockid>
  801a80:	85 c0                	test   %eax,%eax
  801a82:	78 12                	js     801a96 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801a84:	83 ec 04             	sub    $0x4,%esp
  801a87:	ff 75 10             	pushl  0x10(%ebp)
  801a8a:	ff 75 0c             	pushl  0xc(%ebp)
  801a8d:	50                   	push   %eax
  801a8e:	e8 45 01 00 00       	call   801bd8 <nsipc_bind>
  801a93:	83 c4 10             	add    $0x10,%esp
}
  801a96:	c9                   	leave  
  801a97:	c3                   	ret    

00801a98 <shutdown>:
{
  801a98:	f3 0f 1e fb          	endbr32 
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
  801a9f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	e8 ed fe ff ff       	call   801997 <fd2sockid>
  801aaa:	85 c0                	test   %eax,%eax
  801aac:	78 0f                	js     801abd <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801aae:	83 ec 08             	sub    $0x8,%esp
  801ab1:	ff 75 0c             	pushl  0xc(%ebp)
  801ab4:	50                   	push   %eax
  801ab5:	e8 57 01 00 00       	call   801c11 <nsipc_shutdown>
  801aba:	83 c4 10             	add    $0x10,%esp
}
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <connect>:
{
  801abf:	f3 0f 1e fb          	endbr32 
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
  801ac6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  801acc:	e8 c6 fe ff ff       	call   801997 <fd2sockid>
  801ad1:	85 c0                	test   %eax,%eax
  801ad3:	78 12                	js     801ae7 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801ad5:	83 ec 04             	sub    $0x4,%esp
  801ad8:	ff 75 10             	pushl  0x10(%ebp)
  801adb:	ff 75 0c             	pushl  0xc(%ebp)
  801ade:	50                   	push   %eax
  801adf:	e8 71 01 00 00       	call   801c55 <nsipc_connect>
  801ae4:	83 c4 10             	add    $0x10,%esp
}
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    

00801ae9 <listen>:
{
  801ae9:	f3 0f 1e fb          	endbr32 
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
  801af0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801af3:	8b 45 08             	mov    0x8(%ebp),%eax
  801af6:	e8 9c fe ff ff       	call   801997 <fd2sockid>
  801afb:	85 c0                	test   %eax,%eax
  801afd:	78 0f                	js     801b0e <listen+0x25>
	return nsipc_listen(r, backlog);
  801aff:	83 ec 08             	sub    $0x8,%esp
  801b02:	ff 75 0c             	pushl  0xc(%ebp)
  801b05:	50                   	push   %eax
  801b06:	e8 83 01 00 00       	call   801c8e <nsipc_listen>
  801b0b:	83 c4 10             	add    $0x10,%esp
}
  801b0e:	c9                   	leave  
  801b0f:	c3                   	ret    

00801b10 <socket>:

int
socket(int domain, int type, int protocol)
{
  801b10:	f3 0f 1e fb          	endbr32 
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
  801b17:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b1a:	ff 75 10             	pushl  0x10(%ebp)
  801b1d:	ff 75 0c             	pushl  0xc(%ebp)
  801b20:	ff 75 08             	pushl  0x8(%ebp)
  801b23:	e8 65 02 00 00       	call   801d8d <nsipc_socket>
  801b28:	83 c4 10             	add    $0x10,%esp
  801b2b:	85 c0                	test   %eax,%eax
  801b2d:	78 05                	js     801b34 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801b2f:	e8 93 fe ff ff       	call   8019c7 <alloc_sockfd>
}
  801b34:	c9                   	leave  
  801b35:	c3                   	ret    

00801b36 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
  801b39:	53                   	push   %ebx
  801b3a:	83 ec 04             	sub    $0x4,%esp
  801b3d:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b3f:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801b46:	74 26                	je     801b6e <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b48:	6a 07                	push   $0x7
  801b4a:	68 00 80 80 00       	push   $0x808000
  801b4f:	53                   	push   %ebx
  801b50:	ff 35 04 40 80 00    	pushl  0x804004
  801b56:	e8 e0 07 00 00       	call   80233b <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b5b:	83 c4 0c             	add    $0xc,%esp
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	e8 4d 07 00 00       	call   8022b6 <ipc_recv>
}
  801b69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801b6e:	83 ec 0c             	sub    $0xc,%esp
  801b71:	6a 02                	push   $0x2
  801b73:	e8 1b 08 00 00       	call   802393 <ipc_find_env>
  801b78:	a3 04 40 80 00       	mov    %eax,0x804004
  801b7d:	83 c4 10             	add    $0x10,%esp
  801b80:	eb c6                	jmp    801b48 <nsipc+0x12>

00801b82 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b82:	f3 0f 1e fb          	endbr32 
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
  801b89:	56                   	push   %esi
  801b8a:	53                   	push   %ebx
  801b8b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b91:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b96:	8b 06                	mov    (%esi),%eax
  801b98:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b9d:	b8 01 00 00 00       	mov    $0x1,%eax
  801ba2:	e8 8f ff ff ff       	call   801b36 <nsipc>
  801ba7:	89 c3                	mov    %eax,%ebx
  801ba9:	85 c0                	test   %eax,%eax
  801bab:	79 09                	jns    801bb6 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801bad:	89 d8                	mov    %ebx,%eax
  801baf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bb2:	5b                   	pop    %ebx
  801bb3:	5e                   	pop    %esi
  801bb4:	5d                   	pop    %ebp
  801bb5:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801bb6:	83 ec 04             	sub    $0x4,%esp
  801bb9:	ff 35 10 80 80 00    	pushl  0x808010
  801bbf:	68 00 80 80 00       	push   $0x808000
  801bc4:	ff 75 0c             	pushl  0xc(%ebp)
  801bc7:	e8 78 ee ff ff       	call   800a44 <memmove>
		*addrlen = ret->ret_addrlen;
  801bcc:	a1 10 80 80 00       	mov    0x808010,%eax
  801bd1:	89 06                	mov    %eax,(%esi)
  801bd3:	83 c4 10             	add    $0x10,%esp
	return r;
  801bd6:	eb d5                	jmp    801bad <nsipc_accept+0x2b>

00801bd8 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801bd8:	f3 0f 1e fb          	endbr32 
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
  801bdf:	53                   	push   %ebx
  801be0:	83 ec 08             	sub    $0x8,%esp
  801be3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801be6:	8b 45 08             	mov    0x8(%ebp),%eax
  801be9:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801bee:	53                   	push   %ebx
  801bef:	ff 75 0c             	pushl  0xc(%ebp)
  801bf2:	68 04 80 80 00       	push   $0x808004
  801bf7:	e8 48 ee ff ff       	call   800a44 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801bfc:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  801c02:	b8 02 00 00 00       	mov    $0x2,%eax
  801c07:	e8 2a ff ff ff       	call   801b36 <nsipc>
}
  801c0c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    

00801c11 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c11:	f3 0f 1e fb          	endbr32 
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
  801c18:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1e:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  801c23:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c26:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  801c2b:	b8 03 00 00 00       	mov    $0x3,%eax
  801c30:	e8 01 ff ff ff       	call   801b36 <nsipc>
}
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    

00801c37 <nsipc_close>:

int
nsipc_close(int s)
{
  801c37:	f3 0f 1e fb          	endbr32 
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
  801c3e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c41:	8b 45 08             	mov    0x8(%ebp),%eax
  801c44:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  801c49:	b8 04 00 00 00       	mov    $0x4,%eax
  801c4e:	e8 e3 fe ff ff       	call   801b36 <nsipc>
}
  801c53:	c9                   	leave  
  801c54:	c3                   	ret    

00801c55 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c55:	f3 0f 1e fb          	endbr32 
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
  801c5c:	53                   	push   %ebx
  801c5d:	83 ec 08             	sub    $0x8,%esp
  801c60:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c63:	8b 45 08             	mov    0x8(%ebp),%eax
  801c66:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c6b:	53                   	push   %ebx
  801c6c:	ff 75 0c             	pushl  0xc(%ebp)
  801c6f:	68 04 80 80 00       	push   $0x808004
  801c74:	e8 cb ed ff ff       	call   800a44 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c79:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  801c7f:	b8 05 00 00 00       	mov    $0x5,%eax
  801c84:	e8 ad fe ff ff       	call   801b36 <nsipc>
}
  801c89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c8c:	c9                   	leave  
  801c8d:	c3                   	ret    

00801c8e <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c8e:	f3 0f 1e fb          	endbr32 
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
  801c95:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c98:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9b:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  801ca0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca3:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  801ca8:	b8 06 00 00 00       	mov    $0x6,%eax
  801cad:	e8 84 fe ff ff       	call   801b36 <nsipc>
}
  801cb2:	c9                   	leave  
  801cb3:	c3                   	ret    

00801cb4 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801cb4:	f3 0f 1e fb          	endbr32 
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
  801cbb:	56                   	push   %esi
  801cbc:	53                   	push   %ebx
  801cbd:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc3:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  801cc8:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  801cce:	8b 45 14             	mov    0x14(%ebp),%eax
  801cd1:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801cd6:	b8 07 00 00 00       	mov    $0x7,%eax
  801cdb:	e8 56 fe ff ff       	call   801b36 <nsipc>
  801ce0:	89 c3                	mov    %eax,%ebx
  801ce2:	85 c0                	test   %eax,%eax
  801ce4:	78 26                	js     801d0c <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801ce6:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801cec:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801cf1:	0f 4e c6             	cmovle %esi,%eax
  801cf4:	39 c3                	cmp    %eax,%ebx
  801cf6:	7f 1d                	jg     801d15 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801cf8:	83 ec 04             	sub    $0x4,%esp
  801cfb:	53                   	push   %ebx
  801cfc:	68 00 80 80 00       	push   $0x808000
  801d01:	ff 75 0c             	pushl  0xc(%ebp)
  801d04:	e8 3b ed ff ff       	call   800a44 <memmove>
  801d09:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801d0c:	89 d8                	mov    %ebx,%eax
  801d0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d11:	5b                   	pop    %ebx
  801d12:	5e                   	pop    %esi
  801d13:	5d                   	pop    %ebp
  801d14:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801d15:	68 fb 2a 80 00       	push   $0x802afb
  801d1a:	68 c3 2a 80 00       	push   $0x802ac3
  801d1f:	6a 62                	push   $0x62
  801d21:	68 10 2b 80 00       	push   $0x802b10
  801d26:	e8 72 e4 ff ff       	call   80019d <_panic>

00801d2b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d2b:	f3 0f 1e fb          	endbr32 
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
  801d32:	53                   	push   %ebx
  801d33:	83 ec 04             	sub    $0x4,%esp
  801d36:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d39:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3c:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  801d41:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d47:	7f 2e                	jg     801d77 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d49:	83 ec 04             	sub    $0x4,%esp
  801d4c:	53                   	push   %ebx
  801d4d:	ff 75 0c             	pushl  0xc(%ebp)
  801d50:	68 0c 80 80 00       	push   $0x80800c
  801d55:	e8 ea ec ff ff       	call   800a44 <memmove>
	nsipcbuf.send.req_size = size;
  801d5a:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  801d60:	8b 45 14             	mov    0x14(%ebp),%eax
  801d63:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  801d68:	b8 08 00 00 00       	mov    $0x8,%eax
  801d6d:	e8 c4 fd ff ff       	call   801b36 <nsipc>
}
  801d72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d75:	c9                   	leave  
  801d76:	c3                   	ret    
	assert(size < 1600);
  801d77:	68 1c 2b 80 00       	push   $0x802b1c
  801d7c:	68 c3 2a 80 00       	push   $0x802ac3
  801d81:	6a 6d                	push   $0x6d
  801d83:	68 10 2b 80 00       	push   $0x802b10
  801d88:	e8 10 e4 ff ff       	call   80019d <_panic>

00801d8d <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d8d:	f3 0f 1e fb          	endbr32 
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
  801d94:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d97:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9a:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  801d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da2:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  801da7:	8b 45 10             	mov    0x10(%ebp),%eax
  801daa:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  801daf:	b8 09 00 00 00       	mov    $0x9,%eax
  801db4:	e8 7d fd ff ff       	call   801b36 <nsipc>
}
  801db9:	c9                   	leave  
  801dba:	c3                   	ret    

00801dbb <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801dbb:	f3 0f 1e fb          	endbr32 
  801dbf:	55                   	push   %ebp
  801dc0:	89 e5                	mov    %esp,%ebp
  801dc2:	56                   	push   %esi
  801dc3:	53                   	push   %ebx
  801dc4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801dc7:	83 ec 0c             	sub    $0xc,%esp
  801dca:	ff 75 08             	pushl  0x8(%ebp)
  801dcd:	e8 d2 f1 ff ff       	call   800fa4 <fd2data>
  801dd2:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801dd4:	83 c4 08             	add    $0x8,%esp
  801dd7:	68 28 2b 80 00       	push   $0x802b28
  801ddc:	53                   	push   %ebx
  801ddd:	e8 ac ea ff ff       	call   80088e <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801de2:	8b 46 04             	mov    0x4(%esi),%eax
  801de5:	2b 06                	sub    (%esi),%eax
  801de7:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801ded:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801df4:	00 00 00 
	stat->st_dev = &devpipe;
  801df7:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801dfe:	30 80 00 
	return 0;
}
  801e01:	b8 00 00 00 00       	mov    $0x0,%eax
  801e06:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e09:	5b                   	pop    %ebx
  801e0a:	5e                   	pop    %esi
  801e0b:	5d                   	pop    %ebp
  801e0c:	c3                   	ret    

00801e0d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e0d:	f3 0f 1e fb          	endbr32 
  801e11:	55                   	push   %ebp
  801e12:	89 e5                	mov    %esp,%ebp
  801e14:	53                   	push   %ebx
  801e15:	83 ec 0c             	sub    $0xc,%esp
  801e18:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e1b:	53                   	push   %ebx
  801e1c:	6a 00                	push   $0x0
  801e1e:	e8 3a ef ff ff       	call   800d5d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e23:	89 1c 24             	mov    %ebx,(%esp)
  801e26:	e8 79 f1 ff ff       	call   800fa4 <fd2data>
  801e2b:	83 c4 08             	add    $0x8,%esp
  801e2e:	50                   	push   %eax
  801e2f:	6a 00                	push   $0x0
  801e31:	e8 27 ef ff ff       	call   800d5d <sys_page_unmap>
}
  801e36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    

00801e3b <_pipeisclosed>:
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
  801e3e:	57                   	push   %edi
  801e3f:	56                   	push   %esi
  801e40:	53                   	push   %ebx
  801e41:	83 ec 1c             	sub    $0x1c,%esp
  801e44:	89 c7                	mov    %eax,%edi
  801e46:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801e48:	a1 20 60 80 00       	mov    0x806020,%eax
  801e4d:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e50:	83 ec 0c             	sub    $0xc,%esp
  801e53:	57                   	push   %edi
  801e54:	e8 77 05 00 00       	call   8023d0 <pageref>
  801e59:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e5c:	89 34 24             	mov    %esi,(%esp)
  801e5f:	e8 6c 05 00 00       	call   8023d0 <pageref>
		nn = thisenv->env_runs;
  801e64:	8b 15 20 60 80 00    	mov    0x806020,%edx
  801e6a:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e6d:	83 c4 10             	add    $0x10,%esp
  801e70:	39 cb                	cmp    %ecx,%ebx
  801e72:	74 1b                	je     801e8f <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801e74:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e77:	75 cf                	jne    801e48 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e79:	8b 42 58             	mov    0x58(%edx),%eax
  801e7c:	6a 01                	push   $0x1
  801e7e:	50                   	push   %eax
  801e7f:	53                   	push   %ebx
  801e80:	68 2f 2b 80 00       	push   $0x802b2f
  801e85:	e8 fa e3 ff ff       	call   800284 <cprintf>
  801e8a:	83 c4 10             	add    $0x10,%esp
  801e8d:	eb b9                	jmp    801e48 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e8f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e92:	0f 94 c0             	sete   %al
  801e95:	0f b6 c0             	movzbl %al,%eax
}
  801e98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e9b:	5b                   	pop    %ebx
  801e9c:	5e                   	pop    %esi
  801e9d:	5f                   	pop    %edi
  801e9e:	5d                   	pop    %ebp
  801e9f:	c3                   	ret    

00801ea0 <devpipe_write>:
{
  801ea0:	f3 0f 1e fb          	endbr32 
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
  801ea7:	57                   	push   %edi
  801ea8:	56                   	push   %esi
  801ea9:	53                   	push   %ebx
  801eaa:	83 ec 28             	sub    $0x28,%esp
  801ead:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801eb0:	56                   	push   %esi
  801eb1:	e8 ee f0 ff ff       	call   800fa4 <fd2data>
  801eb6:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801eb8:	83 c4 10             	add    $0x10,%esp
  801ebb:	bf 00 00 00 00       	mov    $0x0,%edi
  801ec0:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ec3:	74 4f                	je     801f14 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ec5:	8b 43 04             	mov    0x4(%ebx),%eax
  801ec8:	8b 0b                	mov    (%ebx),%ecx
  801eca:	8d 51 20             	lea    0x20(%ecx),%edx
  801ecd:	39 d0                	cmp    %edx,%eax
  801ecf:	72 14                	jb     801ee5 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801ed1:	89 da                	mov    %ebx,%edx
  801ed3:	89 f0                	mov    %esi,%eax
  801ed5:	e8 61 ff ff ff       	call   801e3b <_pipeisclosed>
  801eda:	85 c0                	test   %eax,%eax
  801edc:	75 3b                	jne    801f19 <devpipe_write+0x79>
			sys_yield();
  801ede:	e8 ca ed ff ff       	call   800cad <sys_yield>
  801ee3:	eb e0                	jmp    801ec5 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ee5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ee8:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801eec:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801eef:	89 c2                	mov    %eax,%edx
  801ef1:	c1 fa 1f             	sar    $0x1f,%edx
  801ef4:	89 d1                	mov    %edx,%ecx
  801ef6:	c1 e9 1b             	shr    $0x1b,%ecx
  801ef9:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801efc:	83 e2 1f             	and    $0x1f,%edx
  801eff:	29 ca                	sub    %ecx,%edx
  801f01:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801f05:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801f09:	83 c0 01             	add    $0x1,%eax
  801f0c:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801f0f:	83 c7 01             	add    $0x1,%edi
  801f12:	eb ac                	jmp    801ec0 <devpipe_write+0x20>
	return i;
  801f14:	8b 45 10             	mov    0x10(%ebp),%eax
  801f17:	eb 05                	jmp    801f1e <devpipe_write+0x7e>
				return 0;
  801f19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f21:	5b                   	pop    %ebx
  801f22:	5e                   	pop    %esi
  801f23:	5f                   	pop    %edi
  801f24:	5d                   	pop    %ebp
  801f25:	c3                   	ret    

00801f26 <devpipe_read>:
{
  801f26:	f3 0f 1e fb          	endbr32 
  801f2a:	55                   	push   %ebp
  801f2b:	89 e5                	mov    %esp,%ebp
  801f2d:	57                   	push   %edi
  801f2e:	56                   	push   %esi
  801f2f:	53                   	push   %ebx
  801f30:	83 ec 18             	sub    $0x18,%esp
  801f33:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801f36:	57                   	push   %edi
  801f37:	e8 68 f0 ff ff       	call   800fa4 <fd2data>
  801f3c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f3e:	83 c4 10             	add    $0x10,%esp
  801f41:	be 00 00 00 00       	mov    $0x0,%esi
  801f46:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f49:	75 14                	jne    801f5f <devpipe_read+0x39>
	return i;
  801f4b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f4e:	eb 02                	jmp    801f52 <devpipe_read+0x2c>
				return i;
  801f50:	89 f0                	mov    %esi,%eax
}
  801f52:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f55:	5b                   	pop    %ebx
  801f56:	5e                   	pop    %esi
  801f57:	5f                   	pop    %edi
  801f58:	5d                   	pop    %ebp
  801f59:	c3                   	ret    
			sys_yield();
  801f5a:	e8 4e ed ff ff       	call   800cad <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801f5f:	8b 03                	mov    (%ebx),%eax
  801f61:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f64:	75 18                	jne    801f7e <devpipe_read+0x58>
			if (i > 0)
  801f66:	85 f6                	test   %esi,%esi
  801f68:	75 e6                	jne    801f50 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801f6a:	89 da                	mov    %ebx,%edx
  801f6c:	89 f8                	mov    %edi,%eax
  801f6e:	e8 c8 fe ff ff       	call   801e3b <_pipeisclosed>
  801f73:	85 c0                	test   %eax,%eax
  801f75:	74 e3                	je     801f5a <devpipe_read+0x34>
				return 0;
  801f77:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7c:	eb d4                	jmp    801f52 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f7e:	99                   	cltd   
  801f7f:	c1 ea 1b             	shr    $0x1b,%edx
  801f82:	01 d0                	add    %edx,%eax
  801f84:	83 e0 1f             	and    $0x1f,%eax
  801f87:	29 d0                	sub    %edx,%eax
  801f89:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f91:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f94:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f97:	83 c6 01             	add    $0x1,%esi
  801f9a:	eb aa                	jmp    801f46 <devpipe_read+0x20>

00801f9c <pipe>:
{
  801f9c:	f3 0f 1e fb          	endbr32 
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
  801fa3:	56                   	push   %esi
  801fa4:	53                   	push   %ebx
  801fa5:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801fa8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fab:	50                   	push   %eax
  801fac:	e8 0e f0 ff ff       	call   800fbf <fd_alloc>
  801fb1:	89 c3                	mov    %eax,%ebx
  801fb3:	83 c4 10             	add    $0x10,%esp
  801fb6:	85 c0                	test   %eax,%eax
  801fb8:	0f 88 23 01 00 00    	js     8020e1 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fbe:	83 ec 04             	sub    $0x4,%esp
  801fc1:	68 07 04 00 00       	push   $0x407
  801fc6:	ff 75 f4             	pushl  -0xc(%ebp)
  801fc9:	6a 00                	push   $0x0
  801fcb:	e8 00 ed ff ff       	call   800cd0 <sys_page_alloc>
  801fd0:	89 c3                	mov    %eax,%ebx
  801fd2:	83 c4 10             	add    $0x10,%esp
  801fd5:	85 c0                	test   %eax,%eax
  801fd7:	0f 88 04 01 00 00    	js     8020e1 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801fdd:	83 ec 0c             	sub    $0xc,%esp
  801fe0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801fe3:	50                   	push   %eax
  801fe4:	e8 d6 ef ff ff       	call   800fbf <fd_alloc>
  801fe9:	89 c3                	mov    %eax,%ebx
  801feb:	83 c4 10             	add    $0x10,%esp
  801fee:	85 c0                	test   %eax,%eax
  801ff0:	0f 88 db 00 00 00    	js     8020d1 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ff6:	83 ec 04             	sub    $0x4,%esp
  801ff9:	68 07 04 00 00       	push   $0x407
  801ffe:	ff 75 f0             	pushl  -0x10(%ebp)
  802001:	6a 00                	push   $0x0
  802003:	e8 c8 ec ff ff       	call   800cd0 <sys_page_alloc>
  802008:	89 c3                	mov    %eax,%ebx
  80200a:	83 c4 10             	add    $0x10,%esp
  80200d:	85 c0                	test   %eax,%eax
  80200f:	0f 88 bc 00 00 00    	js     8020d1 <pipe+0x135>
	va = fd2data(fd0);
  802015:	83 ec 0c             	sub    $0xc,%esp
  802018:	ff 75 f4             	pushl  -0xc(%ebp)
  80201b:	e8 84 ef ff ff       	call   800fa4 <fd2data>
  802020:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802022:	83 c4 0c             	add    $0xc,%esp
  802025:	68 07 04 00 00       	push   $0x407
  80202a:	50                   	push   %eax
  80202b:	6a 00                	push   $0x0
  80202d:	e8 9e ec ff ff       	call   800cd0 <sys_page_alloc>
  802032:	89 c3                	mov    %eax,%ebx
  802034:	83 c4 10             	add    $0x10,%esp
  802037:	85 c0                	test   %eax,%eax
  802039:	0f 88 82 00 00 00    	js     8020c1 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80203f:	83 ec 0c             	sub    $0xc,%esp
  802042:	ff 75 f0             	pushl  -0x10(%ebp)
  802045:	e8 5a ef ff ff       	call   800fa4 <fd2data>
  80204a:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802051:	50                   	push   %eax
  802052:	6a 00                	push   $0x0
  802054:	56                   	push   %esi
  802055:	6a 00                	push   $0x0
  802057:	e8 bb ec ff ff       	call   800d17 <sys_page_map>
  80205c:	89 c3                	mov    %eax,%ebx
  80205e:	83 c4 20             	add    $0x20,%esp
  802061:	85 c0                	test   %eax,%eax
  802063:	78 4e                	js     8020b3 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  802065:	a1 3c 30 80 00       	mov    0x80303c,%eax
  80206a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80206d:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80206f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802072:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802079:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80207c:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80207e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802081:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802088:	83 ec 0c             	sub    $0xc,%esp
  80208b:	ff 75 f4             	pushl  -0xc(%ebp)
  80208e:	e8 fd ee ff ff       	call   800f90 <fd2num>
  802093:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802096:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802098:	83 c4 04             	add    $0x4,%esp
  80209b:	ff 75 f0             	pushl  -0x10(%ebp)
  80209e:	e8 ed ee ff ff       	call   800f90 <fd2num>
  8020a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020a6:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8020a9:	83 c4 10             	add    $0x10,%esp
  8020ac:	bb 00 00 00 00       	mov    $0x0,%ebx
  8020b1:	eb 2e                	jmp    8020e1 <pipe+0x145>
	sys_page_unmap(0, va);
  8020b3:	83 ec 08             	sub    $0x8,%esp
  8020b6:	56                   	push   %esi
  8020b7:	6a 00                	push   $0x0
  8020b9:	e8 9f ec ff ff       	call   800d5d <sys_page_unmap>
  8020be:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8020c1:	83 ec 08             	sub    $0x8,%esp
  8020c4:	ff 75 f0             	pushl  -0x10(%ebp)
  8020c7:	6a 00                	push   $0x0
  8020c9:	e8 8f ec ff ff       	call   800d5d <sys_page_unmap>
  8020ce:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8020d1:	83 ec 08             	sub    $0x8,%esp
  8020d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8020d7:	6a 00                	push   $0x0
  8020d9:	e8 7f ec ff ff       	call   800d5d <sys_page_unmap>
  8020de:	83 c4 10             	add    $0x10,%esp
}
  8020e1:	89 d8                	mov    %ebx,%eax
  8020e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020e6:	5b                   	pop    %ebx
  8020e7:	5e                   	pop    %esi
  8020e8:	5d                   	pop    %ebp
  8020e9:	c3                   	ret    

008020ea <pipeisclosed>:
{
  8020ea:	f3 0f 1e fb          	endbr32 
  8020ee:	55                   	push   %ebp
  8020ef:	89 e5                	mov    %esp,%ebp
  8020f1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020f7:	50                   	push   %eax
  8020f8:	ff 75 08             	pushl  0x8(%ebp)
  8020fb:	e8 15 ef ff ff       	call   801015 <fd_lookup>
  802100:	83 c4 10             	add    $0x10,%esp
  802103:	85 c0                	test   %eax,%eax
  802105:	78 18                	js     80211f <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802107:	83 ec 0c             	sub    $0xc,%esp
  80210a:	ff 75 f4             	pushl  -0xc(%ebp)
  80210d:	e8 92 ee ff ff       	call   800fa4 <fd2data>
  802112:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802114:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802117:	e8 1f fd ff ff       	call   801e3b <_pipeisclosed>
  80211c:	83 c4 10             	add    $0x10,%esp
}
  80211f:	c9                   	leave  
  802120:	c3                   	ret    

00802121 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802121:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  802125:	b8 00 00 00 00       	mov    $0x0,%eax
  80212a:	c3                   	ret    

0080212b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80212b:	f3 0f 1e fb          	endbr32 
  80212f:	55                   	push   %ebp
  802130:	89 e5                	mov    %esp,%ebp
  802132:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802135:	68 47 2b 80 00       	push   $0x802b47
  80213a:	ff 75 0c             	pushl  0xc(%ebp)
  80213d:	e8 4c e7 ff ff       	call   80088e <strcpy>
	return 0;
}
  802142:	b8 00 00 00 00       	mov    $0x0,%eax
  802147:	c9                   	leave  
  802148:	c3                   	ret    

00802149 <devcons_write>:
{
  802149:	f3 0f 1e fb          	endbr32 
  80214d:	55                   	push   %ebp
  80214e:	89 e5                	mov    %esp,%ebp
  802150:	57                   	push   %edi
  802151:	56                   	push   %esi
  802152:	53                   	push   %ebx
  802153:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802159:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80215e:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802164:	3b 75 10             	cmp    0x10(%ebp),%esi
  802167:	73 31                	jae    80219a <devcons_write+0x51>
		m = n - tot;
  802169:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80216c:	29 f3                	sub    %esi,%ebx
  80216e:	83 fb 7f             	cmp    $0x7f,%ebx
  802171:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802176:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802179:	83 ec 04             	sub    $0x4,%esp
  80217c:	53                   	push   %ebx
  80217d:	89 f0                	mov    %esi,%eax
  80217f:	03 45 0c             	add    0xc(%ebp),%eax
  802182:	50                   	push   %eax
  802183:	57                   	push   %edi
  802184:	e8 bb e8 ff ff       	call   800a44 <memmove>
		sys_cputs(buf, m);
  802189:	83 c4 08             	add    $0x8,%esp
  80218c:	53                   	push   %ebx
  80218d:	57                   	push   %edi
  80218e:	e8 6d ea ff ff       	call   800c00 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802193:	01 de                	add    %ebx,%esi
  802195:	83 c4 10             	add    $0x10,%esp
  802198:	eb ca                	jmp    802164 <devcons_write+0x1b>
}
  80219a:	89 f0                	mov    %esi,%eax
  80219c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80219f:	5b                   	pop    %ebx
  8021a0:	5e                   	pop    %esi
  8021a1:	5f                   	pop    %edi
  8021a2:	5d                   	pop    %ebp
  8021a3:	c3                   	ret    

008021a4 <devcons_read>:
{
  8021a4:	f3 0f 1e fb          	endbr32 
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
  8021ab:	83 ec 08             	sub    $0x8,%esp
  8021ae:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8021b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021b7:	74 21                	je     8021da <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8021b9:	e8 64 ea ff ff       	call   800c22 <sys_cgetc>
  8021be:	85 c0                	test   %eax,%eax
  8021c0:	75 07                	jne    8021c9 <devcons_read+0x25>
		sys_yield();
  8021c2:	e8 e6 ea ff ff       	call   800cad <sys_yield>
  8021c7:	eb f0                	jmp    8021b9 <devcons_read+0x15>
	if (c < 0)
  8021c9:	78 0f                	js     8021da <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8021cb:	83 f8 04             	cmp    $0x4,%eax
  8021ce:	74 0c                	je     8021dc <devcons_read+0x38>
	*(char*)vbuf = c;
  8021d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d3:	88 02                	mov    %al,(%edx)
	return 1;
  8021d5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8021da:	c9                   	leave  
  8021db:	c3                   	ret    
		return 0;
  8021dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e1:	eb f7                	jmp    8021da <devcons_read+0x36>

008021e3 <cputchar>:
{
  8021e3:	f3 0f 1e fb          	endbr32 
  8021e7:	55                   	push   %ebp
  8021e8:	89 e5                	mov    %esp,%ebp
  8021ea:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8021ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f0:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8021f3:	6a 01                	push   $0x1
  8021f5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021f8:	50                   	push   %eax
  8021f9:	e8 02 ea ff ff       	call   800c00 <sys_cputs>
}
  8021fe:	83 c4 10             	add    $0x10,%esp
  802201:	c9                   	leave  
  802202:	c3                   	ret    

00802203 <getchar>:
{
  802203:	f3 0f 1e fb          	endbr32 
  802207:	55                   	push   %ebp
  802208:	89 e5                	mov    %esp,%ebp
  80220a:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80220d:	6a 01                	push   $0x1
  80220f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802212:	50                   	push   %eax
  802213:	6a 00                	push   $0x0
  802215:	e8 83 f0 ff ff       	call   80129d <read>
	if (r < 0)
  80221a:	83 c4 10             	add    $0x10,%esp
  80221d:	85 c0                	test   %eax,%eax
  80221f:	78 06                	js     802227 <getchar+0x24>
	if (r < 1)
  802221:	74 06                	je     802229 <getchar+0x26>
	return c;
  802223:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802227:	c9                   	leave  
  802228:	c3                   	ret    
		return -E_EOF;
  802229:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80222e:	eb f7                	jmp    802227 <getchar+0x24>

00802230 <iscons>:
{
  802230:	f3 0f 1e fb          	endbr32 
  802234:	55                   	push   %ebp
  802235:	89 e5                	mov    %esp,%ebp
  802237:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80223a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80223d:	50                   	push   %eax
  80223e:	ff 75 08             	pushl  0x8(%ebp)
  802241:	e8 cf ed ff ff       	call   801015 <fd_lookup>
  802246:	83 c4 10             	add    $0x10,%esp
  802249:	85 c0                	test   %eax,%eax
  80224b:	78 11                	js     80225e <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80224d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802250:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802256:	39 10                	cmp    %edx,(%eax)
  802258:	0f 94 c0             	sete   %al
  80225b:	0f b6 c0             	movzbl %al,%eax
}
  80225e:	c9                   	leave  
  80225f:	c3                   	ret    

00802260 <opencons>:
{
  802260:	f3 0f 1e fb          	endbr32 
  802264:	55                   	push   %ebp
  802265:	89 e5                	mov    %esp,%ebp
  802267:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80226a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80226d:	50                   	push   %eax
  80226e:	e8 4c ed ff ff       	call   800fbf <fd_alloc>
  802273:	83 c4 10             	add    $0x10,%esp
  802276:	85 c0                	test   %eax,%eax
  802278:	78 3a                	js     8022b4 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80227a:	83 ec 04             	sub    $0x4,%esp
  80227d:	68 07 04 00 00       	push   $0x407
  802282:	ff 75 f4             	pushl  -0xc(%ebp)
  802285:	6a 00                	push   $0x0
  802287:	e8 44 ea ff ff       	call   800cd0 <sys_page_alloc>
  80228c:	83 c4 10             	add    $0x10,%esp
  80228f:	85 c0                	test   %eax,%eax
  802291:	78 21                	js     8022b4 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802293:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802296:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80229c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80229e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8022a8:	83 ec 0c             	sub    $0xc,%esp
  8022ab:	50                   	push   %eax
  8022ac:	e8 df ec ff ff       	call   800f90 <fd2num>
  8022b1:	83 c4 10             	add    $0x10,%esp
}
  8022b4:	c9                   	leave  
  8022b5:	c3                   	ret    

008022b6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8022b6:	f3 0f 1e fb          	endbr32 
  8022ba:	55                   	push   %ebp
  8022bb:	89 e5                	mov    %esp,%ebp
  8022bd:	56                   	push   %esi
  8022be:	53                   	push   %ebx
  8022bf:	8b 75 08             	mov    0x8(%ebp),%esi
  8022c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  8022c8:	85 c0                	test   %eax,%eax
  8022ca:	74 3d                	je     802309 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  8022cc:	83 ec 0c             	sub    $0xc,%esp
  8022cf:	50                   	push   %eax
  8022d0:	e8 c7 eb ff ff       	call   800e9c <sys_ipc_recv>
  8022d5:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  8022d8:	85 f6                	test   %esi,%esi
  8022da:	74 0b                	je     8022e7 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8022dc:	8b 15 20 60 80 00    	mov    0x806020,%edx
  8022e2:	8b 52 74             	mov    0x74(%edx),%edx
  8022e5:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  8022e7:	85 db                	test   %ebx,%ebx
  8022e9:	74 0b                	je     8022f6 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  8022eb:	8b 15 20 60 80 00    	mov    0x806020,%edx
  8022f1:	8b 52 78             	mov    0x78(%edx),%edx
  8022f4:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  8022f6:	85 c0                	test   %eax,%eax
  8022f8:	78 21                	js     80231b <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  8022fa:	a1 20 60 80 00       	mov    0x806020,%eax
  8022ff:	8b 40 70             	mov    0x70(%eax),%eax
}
  802302:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802305:	5b                   	pop    %ebx
  802306:	5e                   	pop    %esi
  802307:	5d                   	pop    %ebp
  802308:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  802309:	83 ec 0c             	sub    $0xc,%esp
  80230c:	68 00 00 c0 ee       	push   $0xeec00000
  802311:	e8 86 eb ff ff       	call   800e9c <sys_ipc_recv>
  802316:	83 c4 10             	add    $0x10,%esp
  802319:	eb bd                	jmp    8022d8 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  80231b:	85 f6                	test   %esi,%esi
  80231d:	74 10                	je     80232f <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  80231f:	85 db                	test   %ebx,%ebx
  802321:	75 df                	jne    802302 <ipc_recv+0x4c>
  802323:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80232a:	00 00 00 
  80232d:	eb d3                	jmp    802302 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  80232f:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802336:	00 00 00 
  802339:	eb e4                	jmp    80231f <ipc_recv+0x69>

0080233b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80233b:	f3 0f 1e fb          	endbr32 
  80233f:	55                   	push   %ebp
  802340:	89 e5                	mov    %esp,%ebp
  802342:	57                   	push   %edi
  802343:	56                   	push   %esi
  802344:	53                   	push   %ebx
  802345:	83 ec 0c             	sub    $0xc,%esp
  802348:	8b 7d 08             	mov    0x8(%ebp),%edi
  80234b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80234e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  802351:	85 db                	test   %ebx,%ebx
  802353:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802358:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  80235b:	ff 75 14             	pushl  0x14(%ebp)
  80235e:	53                   	push   %ebx
  80235f:	56                   	push   %esi
  802360:	57                   	push   %edi
  802361:	e8 0f eb ff ff       	call   800e75 <sys_ipc_try_send>
  802366:	83 c4 10             	add    $0x10,%esp
  802369:	85 c0                	test   %eax,%eax
  80236b:	79 1e                	jns    80238b <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  80236d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802370:	75 07                	jne    802379 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  802372:	e8 36 e9 ff ff       	call   800cad <sys_yield>
  802377:	eb e2                	jmp    80235b <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  802379:	50                   	push   %eax
  80237a:	68 53 2b 80 00       	push   $0x802b53
  80237f:	6a 59                	push   $0x59
  802381:	68 6e 2b 80 00       	push   $0x802b6e
  802386:	e8 12 de ff ff       	call   80019d <_panic>
	}
}
  80238b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80238e:	5b                   	pop    %ebx
  80238f:	5e                   	pop    %esi
  802390:	5f                   	pop    %edi
  802391:	5d                   	pop    %ebp
  802392:	c3                   	ret    

00802393 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802393:	f3 0f 1e fb          	endbr32 
  802397:	55                   	push   %ebp
  802398:	89 e5                	mov    %esp,%ebp
  80239a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80239d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8023a2:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8023a5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8023ab:	8b 52 50             	mov    0x50(%edx),%edx
  8023ae:	39 ca                	cmp    %ecx,%edx
  8023b0:	74 11                	je     8023c3 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8023b2:	83 c0 01             	add    $0x1,%eax
  8023b5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8023ba:	75 e6                	jne    8023a2 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8023bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c1:	eb 0b                	jmp    8023ce <ipc_find_env+0x3b>
			return envs[i].env_id;
  8023c3:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8023c6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8023cb:	8b 40 48             	mov    0x48(%eax),%eax
}
  8023ce:	5d                   	pop    %ebp
  8023cf:	c3                   	ret    

008023d0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023d0:	f3 0f 1e fb          	endbr32 
  8023d4:	55                   	push   %ebp
  8023d5:	89 e5                	mov    %esp,%ebp
  8023d7:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023da:	89 c2                	mov    %eax,%edx
  8023dc:	c1 ea 16             	shr    $0x16,%edx
  8023df:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8023e6:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8023eb:	f6 c1 01             	test   $0x1,%cl
  8023ee:	74 1c                	je     80240c <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8023f0:	c1 e8 0c             	shr    $0xc,%eax
  8023f3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8023fa:	a8 01                	test   $0x1,%al
  8023fc:	74 0e                	je     80240c <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023fe:	c1 e8 0c             	shr    $0xc,%eax
  802401:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802408:	ef 
  802409:	0f b7 d2             	movzwl %dx,%edx
}
  80240c:	89 d0                	mov    %edx,%eax
  80240e:	5d                   	pop    %ebp
  80240f:	c3                   	ret    

00802410 <__udivdi3>:
  802410:	f3 0f 1e fb          	endbr32 
  802414:	55                   	push   %ebp
  802415:	57                   	push   %edi
  802416:	56                   	push   %esi
  802417:	53                   	push   %ebx
  802418:	83 ec 1c             	sub    $0x1c,%esp
  80241b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80241f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802423:	8b 74 24 34          	mov    0x34(%esp),%esi
  802427:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80242b:	85 d2                	test   %edx,%edx
  80242d:	75 19                	jne    802448 <__udivdi3+0x38>
  80242f:	39 f3                	cmp    %esi,%ebx
  802431:	76 4d                	jbe    802480 <__udivdi3+0x70>
  802433:	31 ff                	xor    %edi,%edi
  802435:	89 e8                	mov    %ebp,%eax
  802437:	89 f2                	mov    %esi,%edx
  802439:	f7 f3                	div    %ebx
  80243b:	89 fa                	mov    %edi,%edx
  80243d:	83 c4 1c             	add    $0x1c,%esp
  802440:	5b                   	pop    %ebx
  802441:	5e                   	pop    %esi
  802442:	5f                   	pop    %edi
  802443:	5d                   	pop    %ebp
  802444:	c3                   	ret    
  802445:	8d 76 00             	lea    0x0(%esi),%esi
  802448:	39 f2                	cmp    %esi,%edx
  80244a:	76 14                	jbe    802460 <__udivdi3+0x50>
  80244c:	31 ff                	xor    %edi,%edi
  80244e:	31 c0                	xor    %eax,%eax
  802450:	89 fa                	mov    %edi,%edx
  802452:	83 c4 1c             	add    $0x1c,%esp
  802455:	5b                   	pop    %ebx
  802456:	5e                   	pop    %esi
  802457:	5f                   	pop    %edi
  802458:	5d                   	pop    %ebp
  802459:	c3                   	ret    
  80245a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802460:	0f bd fa             	bsr    %edx,%edi
  802463:	83 f7 1f             	xor    $0x1f,%edi
  802466:	75 48                	jne    8024b0 <__udivdi3+0xa0>
  802468:	39 f2                	cmp    %esi,%edx
  80246a:	72 06                	jb     802472 <__udivdi3+0x62>
  80246c:	31 c0                	xor    %eax,%eax
  80246e:	39 eb                	cmp    %ebp,%ebx
  802470:	77 de                	ja     802450 <__udivdi3+0x40>
  802472:	b8 01 00 00 00       	mov    $0x1,%eax
  802477:	eb d7                	jmp    802450 <__udivdi3+0x40>
  802479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802480:	89 d9                	mov    %ebx,%ecx
  802482:	85 db                	test   %ebx,%ebx
  802484:	75 0b                	jne    802491 <__udivdi3+0x81>
  802486:	b8 01 00 00 00       	mov    $0x1,%eax
  80248b:	31 d2                	xor    %edx,%edx
  80248d:	f7 f3                	div    %ebx
  80248f:	89 c1                	mov    %eax,%ecx
  802491:	31 d2                	xor    %edx,%edx
  802493:	89 f0                	mov    %esi,%eax
  802495:	f7 f1                	div    %ecx
  802497:	89 c6                	mov    %eax,%esi
  802499:	89 e8                	mov    %ebp,%eax
  80249b:	89 f7                	mov    %esi,%edi
  80249d:	f7 f1                	div    %ecx
  80249f:	89 fa                	mov    %edi,%edx
  8024a1:	83 c4 1c             	add    $0x1c,%esp
  8024a4:	5b                   	pop    %ebx
  8024a5:	5e                   	pop    %esi
  8024a6:	5f                   	pop    %edi
  8024a7:	5d                   	pop    %ebp
  8024a8:	c3                   	ret    
  8024a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024b0:	89 f9                	mov    %edi,%ecx
  8024b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8024b7:	29 f8                	sub    %edi,%eax
  8024b9:	d3 e2                	shl    %cl,%edx
  8024bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8024bf:	89 c1                	mov    %eax,%ecx
  8024c1:	89 da                	mov    %ebx,%edx
  8024c3:	d3 ea                	shr    %cl,%edx
  8024c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024c9:	09 d1                	or     %edx,%ecx
  8024cb:	89 f2                	mov    %esi,%edx
  8024cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024d1:	89 f9                	mov    %edi,%ecx
  8024d3:	d3 e3                	shl    %cl,%ebx
  8024d5:	89 c1                	mov    %eax,%ecx
  8024d7:	d3 ea                	shr    %cl,%edx
  8024d9:	89 f9                	mov    %edi,%ecx
  8024db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8024df:	89 eb                	mov    %ebp,%ebx
  8024e1:	d3 e6                	shl    %cl,%esi
  8024e3:	89 c1                	mov    %eax,%ecx
  8024e5:	d3 eb                	shr    %cl,%ebx
  8024e7:	09 de                	or     %ebx,%esi
  8024e9:	89 f0                	mov    %esi,%eax
  8024eb:	f7 74 24 08          	divl   0x8(%esp)
  8024ef:	89 d6                	mov    %edx,%esi
  8024f1:	89 c3                	mov    %eax,%ebx
  8024f3:	f7 64 24 0c          	mull   0xc(%esp)
  8024f7:	39 d6                	cmp    %edx,%esi
  8024f9:	72 15                	jb     802510 <__udivdi3+0x100>
  8024fb:	89 f9                	mov    %edi,%ecx
  8024fd:	d3 e5                	shl    %cl,%ebp
  8024ff:	39 c5                	cmp    %eax,%ebp
  802501:	73 04                	jae    802507 <__udivdi3+0xf7>
  802503:	39 d6                	cmp    %edx,%esi
  802505:	74 09                	je     802510 <__udivdi3+0x100>
  802507:	89 d8                	mov    %ebx,%eax
  802509:	31 ff                	xor    %edi,%edi
  80250b:	e9 40 ff ff ff       	jmp    802450 <__udivdi3+0x40>
  802510:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802513:	31 ff                	xor    %edi,%edi
  802515:	e9 36 ff ff ff       	jmp    802450 <__udivdi3+0x40>
  80251a:	66 90                	xchg   %ax,%ax
  80251c:	66 90                	xchg   %ax,%ax
  80251e:	66 90                	xchg   %ax,%ax

00802520 <__umoddi3>:
  802520:	f3 0f 1e fb          	endbr32 
  802524:	55                   	push   %ebp
  802525:	57                   	push   %edi
  802526:	56                   	push   %esi
  802527:	53                   	push   %ebx
  802528:	83 ec 1c             	sub    $0x1c,%esp
  80252b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80252f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802533:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802537:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80253b:	85 c0                	test   %eax,%eax
  80253d:	75 19                	jne    802558 <__umoddi3+0x38>
  80253f:	39 df                	cmp    %ebx,%edi
  802541:	76 5d                	jbe    8025a0 <__umoddi3+0x80>
  802543:	89 f0                	mov    %esi,%eax
  802545:	89 da                	mov    %ebx,%edx
  802547:	f7 f7                	div    %edi
  802549:	89 d0                	mov    %edx,%eax
  80254b:	31 d2                	xor    %edx,%edx
  80254d:	83 c4 1c             	add    $0x1c,%esp
  802550:	5b                   	pop    %ebx
  802551:	5e                   	pop    %esi
  802552:	5f                   	pop    %edi
  802553:	5d                   	pop    %ebp
  802554:	c3                   	ret    
  802555:	8d 76 00             	lea    0x0(%esi),%esi
  802558:	89 f2                	mov    %esi,%edx
  80255a:	39 d8                	cmp    %ebx,%eax
  80255c:	76 12                	jbe    802570 <__umoddi3+0x50>
  80255e:	89 f0                	mov    %esi,%eax
  802560:	89 da                	mov    %ebx,%edx
  802562:	83 c4 1c             	add    $0x1c,%esp
  802565:	5b                   	pop    %ebx
  802566:	5e                   	pop    %esi
  802567:	5f                   	pop    %edi
  802568:	5d                   	pop    %ebp
  802569:	c3                   	ret    
  80256a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802570:	0f bd e8             	bsr    %eax,%ebp
  802573:	83 f5 1f             	xor    $0x1f,%ebp
  802576:	75 50                	jne    8025c8 <__umoddi3+0xa8>
  802578:	39 d8                	cmp    %ebx,%eax
  80257a:	0f 82 e0 00 00 00    	jb     802660 <__umoddi3+0x140>
  802580:	89 d9                	mov    %ebx,%ecx
  802582:	39 f7                	cmp    %esi,%edi
  802584:	0f 86 d6 00 00 00    	jbe    802660 <__umoddi3+0x140>
  80258a:	89 d0                	mov    %edx,%eax
  80258c:	89 ca                	mov    %ecx,%edx
  80258e:	83 c4 1c             	add    $0x1c,%esp
  802591:	5b                   	pop    %ebx
  802592:	5e                   	pop    %esi
  802593:	5f                   	pop    %edi
  802594:	5d                   	pop    %ebp
  802595:	c3                   	ret    
  802596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80259d:	8d 76 00             	lea    0x0(%esi),%esi
  8025a0:	89 fd                	mov    %edi,%ebp
  8025a2:	85 ff                	test   %edi,%edi
  8025a4:	75 0b                	jne    8025b1 <__umoddi3+0x91>
  8025a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8025ab:	31 d2                	xor    %edx,%edx
  8025ad:	f7 f7                	div    %edi
  8025af:	89 c5                	mov    %eax,%ebp
  8025b1:	89 d8                	mov    %ebx,%eax
  8025b3:	31 d2                	xor    %edx,%edx
  8025b5:	f7 f5                	div    %ebp
  8025b7:	89 f0                	mov    %esi,%eax
  8025b9:	f7 f5                	div    %ebp
  8025bb:	89 d0                	mov    %edx,%eax
  8025bd:	31 d2                	xor    %edx,%edx
  8025bf:	eb 8c                	jmp    80254d <__umoddi3+0x2d>
  8025c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025c8:	89 e9                	mov    %ebp,%ecx
  8025ca:	ba 20 00 00 00       	mov    $0x20,%edx
  8025cf:	29 ea                	sub    %ebp,%edx
  8025d1:	d3 e0                	shl    %cl,%eax
  8025d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025d7:	89 d1                	mov    %edx,%ecx
  8025d9:	89 f8                	mov    %edi,%eax
  8025db:	d3 e8                	shr    %cl,%eax
  8025dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8025e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8025e5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8025e9:	09 c1                	or     %eax,%ecx
  8025eb:	89 d8                	mov    %ebx,%eax
  8025ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025f1:	89 e9                	mov    %ebp,%ecx
  8025f3:	d3 e7                	shl    %cl,%edi
  8025f5:	89 d1                	mov    %edx,%ecx
  8025f7:	d3 e8                	shr    %cl,%eax
  8025f9:	89 e9                	mov    %ebp,%ecx
  8025fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025ff:	d3 e3                	shl    %cl,%ebx
  802601:	89 c7                	mov    %eax,%edi
  802603:	89 d1                	mov    %edx,%ecx
  802605:	89 f0                	mov    %esi,%eax
  802607:	d3 e8                	shr    %cl,%eax
  802609:	89 e9                	mov    %ebp,%ecx
  80260b:	89 fa                	mov    %edi,%edx
  80260d:	d3 e6                	shl    %cl,%esi
  80260f:	09 d8                	or     %ebx,%eax
  802611:	f7 74 24 08          	divl   0x8(%esp)
  802615:	89 d1                	mov    %edx,%ecx
  802617:	89 f3                	mov    %esi,%ebx
  802619:	f7 64 24 0c          	mull   0xc(%esp)
  80261d:	89 c6                	mov    %eax,%esi
  80261f:	89 d7                	mov    %edx,%edi
  802621:	39 d1                	cmp    %edx,%ecx
  802623:	72 06                	jb     80262b <__umoddi3+0x10b>
  802625:	75 10                	jne    802637 <__umoddi3+0x117>
  802627:	39 c3                	cmp    %eax,%ebx
  802629:	73 0c                	jae    802637 <__umoddi3+0x117>
  80262b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80262f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802633:	89 d7                	mov    %edx,%edi
  802635:	89 c6                	mov    %eax,%esi
  802637:	89 ca                	mov    %ecx,%edx
  802639:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80263e:	29 f3                	sub    %esi,%ebx
  802640:	19 fa                	sbb    %edi,%edx
  802642:	89 d0                	mov    %edx,%eax
  802644:	d3 e0                	shl    %cl,%eax
  802646:	89 e9                	mov    %ebp,%ecx
  802648:	d3 eb                	shr    %cl,%ebx
  80264a:	d3 ea                	shr    %cl,%edx
  80264c:	09 d8                	or     %ebx,%eax
  80264e:	83 c4 1c             	add    $0x1c,%esp
  802651:	5b                   	pop    %ebx
  802652:	5e                   	pop    %esi
  802653:	5f                   	pop    %edi
  802654:	5d                   	pop    %ebp
  802655:	c3                   	ret    
  802656:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80265d:	8d 76 00             	lea    0x0(%esi),%esi
  802660:	29 fe                	sub    %edi,%esi
  802662:	19 c3                	sbb    %eax,%ebx
  802664:	89 f2                	mov    %esi,%edx
  802666:	89 d9                	mov    %ebx,%ecx
  802668:	e9 1d ff ff ff       	jmp    80258a <__umoddi3+0x6a>
