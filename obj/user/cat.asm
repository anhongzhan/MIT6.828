
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
  80004d:	e8 97 11 00 00       	call   8011e9 <read>
  800052:	89 c3                	mov    %eax,%ebx
  800054:	83 c4 10             	add    $0x10,%esp
  800057:	85 c0                	test   %eax,%eax
  800059:	7e 2f                	jle    80008a <cat+0x57>
		if ((r = write(1, buf, n)) != n)
  80005b:	83 ec 04             	sub    $0x4,%esp
  80005e:	53                   	push   %ebx
  80005f:	68 20 40 80 00       	push   $0x804020
  800064:	6a 01                	push   $0x1
  800066:	e8 54 12 00 00       	call   8012bf <write>
  80006b:	83 c4 10             	add    $0x10,%esp
  80006e:	39 c3                	cmp    %eax,%ebx
  800070:	74 cd                	je     80003f <cat+0xc>
			panic("write error copying %s: %e", s, r);
  800072:	83 ec 0c             	sub    $0xc,%esp
  800075:	50                   	push   %eax
  800076:	ff 75 0c             	pushl  0xc(%ebp)
  800079:	68 20 21 80 00       	push   $0x802120
  80007e:	6a 0d                	push   $0xd
  800080:	68 3b 21 80 00       	push   $0x80213b
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
  80009a:	68 46 21 80 00       	push   $0x802146
  80009f:	6a 0f                	push   $0xf
  8000a1:	68 3b 21 80 00       	push   $0x80213b
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
  8000bb:	c7 05 00 30 80 00 5b 	movl   $0x80215b,0x803000
  8000c2:	21 80 00 
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
  8000d3:	68 5f 21 80 00       	push   $0x80215f
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
  8000f1:	68 67 21 80 00       	push   $0x802167
  8000f6:	e8 3a 17 00 00       	call   801835 <printf>
  8000fb:	83 c4 10             	add    $0x10,%esp
		for (i = 1; i < argc; i++) {
  8000fe:	83 c6 01             	add    $0x1,%esi
  800101:	3b 75 08             	cmp    0x8(%ebp),%esi
  800104:	7d dc                	jge    8000e2 <umain+0x37>
			f = open(argv[i], O_RDONLY);
  800106:	83 ec 08             	sub    $0x8,%esp
  800109:	6a 00                	push   $0x0
  80010b:	ff 34 b7             	pushl  (%edi,%esi,4)
  80010e:	e8 6b 15 00 00       	call   80167e <open>
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
  80012b:	e8 6f 0f 00 00       	call   80109f <close>
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
  800189:	e8 42 0f 00 00       	call   8010d0 <close_all>
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
  8001bf:	68 84 21 80 00       	push   $0x802184
  8001c4:	e8 bb 00 00 00       	call   800284 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001c9:	83 c4 18             	add    $0x18,%esp
  8001cc:	53                   	push   %ebx
  8001cd:	ff 75 10             	pushl  0x10(%ebp)
  8001d0:	e8 5a 00 00 00       	call   80022f <vcprintf>
	cprintf("\n");
  8001d5:	c7 04 24 cf 25 80 00 	movl   $0x8025cf,(%esp)
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
  8002ea:	e8 c1 1b 00 00       	call   801eb0 <__udivdi3>
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
  800328:	e8 93 1c 00 00       	call   801fc0 <__umoddi3>
  80032d:	83 c4 14             	add    $0x14,%esp
  800330:	0f be 80 a7 21 80 00 	movsbl 0x8021a7(%eax),%eax
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
  8003d7:	3e ff 24 85 e0 22 80 	notrack jmp *0x8022e0(,%eax,4)
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
  8004a4:	8b 14 85 40 24 80 00 	mov    0x802440(,%eax,4),%edx
  8004ab:	85 d2                	test   %edx,%edx
  8004ad:	74 18                	je     8004c7 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8004af:	52                   	push   %edx
  8004b0:	68 71 25 80 00       	push   $0x802571
  8004b5:	53                   	push   %ebx
  8004b6:	56                   	push   %esi
  8004b7:	e8 aa fe ff ff       	call   800366 <printfmt>
  8004bc:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004bf:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004c2:	e9 66 02 00 00       	jmp    80072d <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8004c7:	50                   	push   %eax
  8004c8:	68 bf 21 80 00       	push   $0x8021bf
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
  8004ef:	b8 b8 21 80 00       	mov    $0x8021b8,%eax
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
  800c79:	68 9f 24 80 00       	push   $0x80249f
  800c7e:	6a 23                	push   $0x23
  800c80:	68 bc 24 80 00       	push   $0x8024bc
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
  800d06:	68 9f 24 80 00       	push   $0x80249f
  800d0b:	6a 23                	push   $0x23
  800d0d:	68 bc 24 80 00       	push   $0x8024bc
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
  800d4c:	68 9f 24 80 00       	push   $0x80249f
  800d51:	6a 23                	push   $0x23
  800d53:	68 bc 24 80 00       	push   $0x8024bc
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
  800d92:	68 9f 24 80 00       	push   $0x80249f
  800d97:	6a 23                	push   $0x23
  800d99:	68 bc 24 80 00       	push   $0x8024bc
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
  800dd8:	68 9f 24 80 00       	push   $0x80249f
  800ddd:	6a 23                	push   $0x23
  800ddf:	68 bc 24 80 00       	push   $0x8024bc
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
  800e1e:	68 9f 24 80 00       	push   $0x80249f
  800e23:	6a 23                	push   $0x23
  800e25:	68 bc 24 80 00       	push   $0x8024bc
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
  800e64:	68 9f 24 80 00       	push   $0x80249f
  800e69:	6a 23                	push   $0x23
  800e6b:	68 bc 24 80 00       	push   $0x8024bc
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
  800ed0:	68 9f 24 80 00       	push   $0x80249f
  800ed5:	6a 23                	push   $0x23
  800ed7:	68 bc 24 80 00       	push   $0x8024bc
  800edc:	e8 bc f2 ff ff       	call   80019d <_panic>

00800ee1 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800ee1:	f3 0f 1e fb          	endbr32 
  800ee5:	55                   	push   %ebp
  800ee6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	05 00 00 00 30       	add    $0x30000000,%eax
  800ef0:	c1 e8 0c             	shr    $0xc,%eax
}
  800ef3:	5d                   	pop    %ebp
  800ef4:	c3                   	ret    

00800ef5 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800ef5:	f3 0f 1e fb          	endbr32 
  800ef9:	55                   	push   %ebp
  800efa:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800efc:	8b 45 08             	mov    0x8(%ebp),%eax
  800eff:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800f04:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f09:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f0e:	5d                   	pop    %ebp
  800f0f:	c3                   	ret    

00800f10 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f10:	f3 0f 1e fb          	endbr32 
  800f14:	55                   	push   %ebp
  800f15:	89 e5                	mov    %esp,%ebp
  800f17:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f1c:	89 c2                	mov    %eax,%edx
  800f1e:	c1 ea 16             	shr    $0x16,%edx
  800f21:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f28:	f6 c2 01             	test   $0x1,%dl
  800f2b:	74 2d                	je     800f5a <fd_alloc+0x4a>
  800f2d:	89 c2                	mov    %eax,%edx
  800f2f:	c1 ea 0c             	shr    $0xc,%edx
  800f32:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f39:	f6 c2 01             	test   $0x1,%dl
  800f3c:	74 1c                	je     800f5a <fd_alloc+0x4a>
  800f3e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f43:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f48:	75 d2                	jne    800f1c <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800f53:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f58:	eb 0a                	jmp    800f64 <fd_alloc+0x54>
			*fd_store = fd;
  800f5a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f5d:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f64:	5d                   	pop    %ebp
  800f65:	c3                   	ret    

00800f66 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f66:	f3 0f 1e fb          	endbr32 
  800f6a:	55                   	push   %ebp
  800f6b:	89 e5                	mov    %esp,%ebp
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f70:	83 f8 1f             	cmp    $0x1f,%eax
  800f73:	77 30                	ja     800fa5 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f75:	c1 e0 0c             	shl    $0xc,%eax
  800f78:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f7d:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800f83:	f6 c2 01             	test   $0x1,%dl
  800f86:	74 24                	je     800fac <fd_lookup+0x46>
  800f88:	89 c2                	mov    %eax,%edx
  800f8a:	c1 ea 0c             	shr    $0xc,%edx
  800f8d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f94:	f6 c2 01             	test   $0x1,%dl
  800f97:	74 1a                	je     800fb3 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f9c:	89 02                	mov    %eax,(%edx)
	return 0;
  800f9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fa3:	5d                   	pop    %ebp
  800fa4:	c3                   	ret    
		return -E_INVAL;
  800fa5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800faa:	eb f7                	jmp    800fa3 <fd_lookup+0x3d>
		return -E_INVAL;
  800fac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fb1:	eb f0                	jmp    800fa3 <fd_lookup+0x3d>
  800fb3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fb8:	eb e9                	jmp    800fa3 <fd_lookup+0x3d>

00800fba <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800fba:	f3 0f 1e fb          	endbr32 
  800fbe:	55                   	push   %ebp
  800fbf:	89 e5                	mov    %esp,%ebp
  800fc1:	83 ec 08             	sub    $0x8,%esp
  800fc4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fc7:	ba 48 25 80 00       	mov    $0x802548,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800fcc:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800fd1:	39 08                	cmp    %ecx,(%eax)
  800fd3:	74 33                	je     801008 <dev_lookup+0x4e>
  800fd5:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800fd8:	8b 02                	mov    (%edx),%eax
  800fda:	85 c0                	test   %eax,%eax
  800fdc:	75 f3                	jne    800fd1 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800fde:	a1 20 60 80 00       	mov    0x806020,%eax
  800fe3:	8b 40 48             	mov    0x48(%eax),%eax
  800fe6:	83 ec 04             	sub    $0x4,%esp
  800fe9:	51                   	push   %ecx
  800fea:	50                   	push   %eax
  800feb:	68 cc 24 80 00       	push   $0x8024cc
  800ff0:	e8 8f f2 ff ff       	call   800284 <cprintf>
	*dev = 0;
  800ff5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800ffe:	83 c4 10             	add    $0x10,%esp
  801001:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801006:	c9                   	leave  
  801007:	c3                   	ret    
			*dev = devtab[i];
  801008:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80100b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80100d:	b8 00 00 00 00       	mov    $0x0,%eax
  801012:	eb f2                	jmp    801006 <dev_lookup+0x4c>

00801014 <fd_close>:
{
  801014:	f3 0f 1e fb          	endbr32 
  801018:	55                   	push   %ebp
  801019:	89 e5                	mov    %esp,%ebp
  80101b:	57                   	push   %edi
  80101c:	56                   	push   %esi
  80101d:	53                   	push   %ebx
  80101e:	83 ec 24             	sub    $0x24,%esp
  801021:	8b 75 08             	mov    0x8(%ebp),%esi
  801024:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801027:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80102a:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80102b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801031:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801034:	50                   	push   %eax
  801035:	e8 2c ff ff ff       	call   800f66 <fd_lookup>
  80103a:	89 c3                	mov    %eax,%ebx
  80103c:	83 c4 10             	add    $0x10,%esp
  80103f:	85 c0                	test   %eax,%eax
  801041:	78 05                	js     801048 <fd_close+0x34>
	    || fd != fd2)
  801043:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801046:	74 16                	je     80105e <fd_close+0x4a>
		return (must_exist ? r : 0);
  801048:	89 f8                	mov    %edi,%eax
  80104a:	84 c0                	test   %al,%al
  80104c:	b8 00 00 00 00       	mov    $0x0,%eax
  801051:	0f 44 d8             	cmove  %eax,%ebx
}
  801054:	89 d8                	mov    %ebx,%eax
  801056:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801059:	5b                   	pop    %ebx
  80105a:	5e                   	pop    %esi
  80105b:	5f                   	pop    %edi
  80105c:	5d                   	pop    %ebp
  80105d:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80105e:	83 ec 08             	sub    $0x8,%esp
  801061:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801064:	50                   	push   %eax
  801065:	ff 36                	pushl  (%esi)
  801067:	e8 4e ff ff ff       	call   800fba <dev_lookup>
  80106c:	89 c3                	mov    %eax,%ebx
  80106e:	83 c4 10             	add    $0x10,%esp
  801071:	85 c0                	test   %eax,%eax
  801073:	78 1a                	js     80108f <fd_close+0x7b>
		if (dev->dev_close)
  801075:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801078:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80107b:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801080:	85 c0                	test   %eax,%eax
  801082:	74 0b                	je     80108f <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801084:	83 ec 0c             	sub    $0xc,%esp
  801087:	56                   	push   %esi
  801088:	ff d0                	call   *%eax
  80108a:	89 c3                	mov    %eax,%ebx
  80108c:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80108f:	83 ec 08             	sub    $0x8,%esp
  801092:	56                   	push   %esi
  801093:	6a 00                	push   $0x0
  801095:	e8 c3 fc ff ff       	call   800d5d <sys_page_unmap>
	return r;
  80109a:	83 c4 10             	add    $0x10,%esp
  80109d:	eb b5                	jmp    801054 <fd_close+0x40>

0080109f <close>:

int
close(int fdnum)
{
  80109f:	f3 0f 1e fb          	endbr32 
  8010a3:	55                   	push   %ebp
  8010a4:	89 e5                	mov    %esp,%ebp
  8010a6:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010ac:	50                   	push   %eax
  8010ad:	ff 75 08             	pushl  0x8(%ebp)
  8010b0:	e8 b1 fe ff ff       	call   800f66 <fd_lookup>
  8010b5:	83 c4 10             	add    $0x10,%esp
  8010b8:	85 c0                	test   %eax,%eax
  8010ba:	79 02                	jns    8010be <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8010bc:	c9                   	leave  
  8010bd:	c3                   	ret    
		return fd_close(fd, 1);
  8010be:	83 ec 08             	sub    $0x8,%esp
  8010c1:	6a 01                	push   $0x1
  8010c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8010c6:	e8 49 ff ff ff       	call   801014 <fd_close>
  8010cb:	83 c4 10             	add    $0x10,%esp
  8010ce:	eb ec                	jmp    8010bc <close+0x1d>

008010d0 <close_all>:

void
close_all(void)
{
  8010d0:	f3 0f 1e fb          	endbr32 
  8010d4:	55                   	push   %ebp
  8010d5:	89 e5                	mov    %esp,%ebp
  8010d7:	53                   	push   %ebx
  8010d8:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8010db:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8010e0:	83 ec 0c             	sub    $0xc,%esp
  8010e3:	53                   	push   %ebx
  8010e4:	e8 b6 ff ff ff       	call   80109f <close>
	for (i = 0; i < MAXFD; i++)
  8010e9:	83 c3 01             	add    $0x1,%ebx
  8010ec:	83 c4 10             	add    $0x10,%esp
  8010ef:	83 fb 20             	cmp    $0x20,%ebx
  8010f2:	75 ec                	jne    8010e0 <close_all+0x10>
}
  8010f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010f7:	c9                   	leave  
  8010f8:	c3                   	ret    

008010f9 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8010f9:	f3 0f 1e fb          	endbr32 
  8010fd:	55                   	push   %ebp
  8010fe:	89 e5                	mov    %esp,%ebp
  801100:	57                   	push   %edi
  801101:	56                   	push   %esi
  801102:	53                   	push   %ebx
  801103:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801106:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801109:	50                   	push   %eax
  80110a:	ff 75 08             	pushl  0x8(%ebp)
  80110d:	e8 54 fe ff ff       	call   800f66 <fd_lookup>
  801112:	89 c3                	mov    %eax,%ebx
  801114:	83 c4 10             	add    $0x10,%esp
  801117:	85 c0                	test   %eax,%eax
  801119:	0f 88 81 00 00 00    	js     8011a0 <dup+0xa7>
		return r;
	close(newfdnum);
  80111f:	83 ec 0c             	sub    $0xc,%esp
  801122:	ff 75 0c             	pushl  0xc(%ebp)
  801125:	e8 75 ff ff ff       	call   80109f <close>

	newfd = INDEX2FD(newfdnum);
  80112a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80112d:	c1 e6 0c             	shl    $0xc,%esi
  801130:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801136:	83 c4 04             	add    $0x4,%esp
  801139:	ff 75 e4             	pushl  -0x1c(%ebp)
  80113c:	e8 b4 fd ff ff       	call   800ef5 <fd2data>
  801141:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801143:	89 34 24             	mov    %esi,(%esp)
  801146:	e8 aa fd ff ff       	call   800ef5 <fd2data>
  80114b:	83 c4 10             	add    $0x10,%esp
  80114e:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801150:	89 d8                	mov    %ebx,%eax
  801152:	c1 e8 16             	shr    $0x16,%eax
  801155:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80115c:	a8 01                	test   $0x1,%al
  80115e:	74 11                	je     801171 <dup+0x78>
  801160:	89 d8                	mov    %ebx,%eax
  801162:	c1 e8 0c             	shr    $0xc,%eax
  801165:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80116c:	f6 c2 01             	test   $0x1,%dl
  80116f:	75 39                	jne    8011aa <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801171:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801174:	89 d0                	mov    %edx,%eax
  801176:	c1 e8 0c             	shr    $0xc,%eax
  801179:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801180:	83 ec 0c             	sub    $0xc,%esp
  801183:	25 07 0e 00 00       	and    $0xe07,%eax
  801188:	50                   	push   %eax
  801189:	56                   	push   %esi
  80118a:	6a 00                	push   $0x0
  80118c:	52                   	push   %edx
  80118d:	6a 00                	push   $0x0
  80118f:	e8 83 fb ff ff       	call   800d17 <sys_page_map>
  801194:	89 c3                	mov    %eax,%ebx
  801196:	83 c4 20             	add    $0x20,%esp
  801199:	85 c0                	test   %eax,%eax
  80119b:	78 31                	js     8011ce <dup+0xd5>
		goto err;

	return newfdnum;
  80119d:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8011a0:	89 d8                	mov    %ebx,%eax
  8011a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011a5:	5b                   	pop    %ebx
  8011a6:	5e                   	pop    %esi
  8011a7:	5f                   	pop    %edi
  8011a8:	5d                   	pop    %ebp
  8011a9:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8011aa:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011b1:	83 ec 0c             	sub    $0xc,%esp
  8011b4:	25 07 0e 00 00       	and    $0xe07,%eax
  8011b9:	50                   	push   %eax
  8011ba:	57                   	push   %edi
  8011bb:	6a 00                	push   $0x0
  8011bd:	53                   	push   %ebx
  8011be:	6a 00                	push   $0x0
  8011c0:	e8 52 fb ff ff       	call   800d17 <sys_page_map>
  8011c5:	89 c3                	mov    %eax,%ebx
  8011c7:	83 c4 20             	add    $0x20,%esp
  8011ca:	85 c0                	test   %eax,%eax
  8011cc:	79 a3                	jns    801171 <dup+0x78>
	sys_page_unmap(0, newfd);
  8011ce:	83 ec 08             	sub    $0x8,%esp
  8011d1:	56                   	push   %esi
  8011d2:	6a 00                	push   $0x0
  8011d4:	e8 84 fb ff ff       	call   800d5d <sys_page_unmap>
	sys_page_unmap(0, nva);
  8011d9:	83 c4 08             	add    $0x8,%esp
  8011dc:	57                   	push   %edi
  8011dd:	6a 00                	push   $0x0
  8011df:	e8 79 fb ff ff       	call   800d5d <sys_page_unmap>
	return r;
  8011e4:	83 c4 10             	add    $0x10,%esp
  8011e7:	eb b7                	jmp    8011a0 <dup+0xa7>

008011e9 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8011e9:	f3 0f 1e fb          	endbr32 
  8011ed:	55                   	push   %ebp
  8011ee:	89 e5                	mov    %esp,%ebp
  8011f0:	53                   	push   %ebx
  8011f1:	83 ec 1c             	sub    $0x1c,%esp
  8011f4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011f7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011fa:	50                   	push   %eax
  8011fb:	53                   	push   %ebx
  8011fc:	e8 65 fd ff ff       	call   800f66 <fd_lookup>
  801201:	83 c4 10             	add    $0x10,%esp
  801204:	85 c0                	test   %eax,%eax
  801206:	78 3f                	js     801247 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801208:	83 ec 08             	sub    $0x8,%esp
  80120b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80120e:	50                   	push   %eax
  80120f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801212:	ff 30                	pushl  (%eax)
  801214:	e8 a1 fd ff ff       	call   800fba <dev_lookup>
  801219:	83 c4 10             	add    $0x10,%esp
  80121c:	85 c0                	test   %eax,%eax
  80121e:	78 27                	js     801247 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801220:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801223:	8b 42 08             	mov    0x8(%edx),%eax
  801226:	83 e0 03             	and    $0x3,%eax
  801229:	83 f8 01             	cmp    $0x1,%eax
  80122c:	74 1e                	je     80124c <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80122e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801231:	8b 40 08             	mov    0x8(%eax),%eax
  801234:	85 c0                	test   %eax,%eax
  801236:	74 35                	je     80126d <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801238:	83 ec 04             	sub    $0x4,%esp
  80123b:	ff 75 10             	pushl  0x10(%ebp)
  80123e:	ff 75 0c             	pushl  0xc(%ebp)
  801241:	52                   	push   %edx
  801242:	ff d0                	call   *%eax
  801244:	83 c4 10             	add    $0x10,%esp
}
  801247:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80124a:	c9                   	leave  
  80124b:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80124c:	a1 20 60 80 00       	mov    0x806020,%eax
  801251:	8b 40 48             	mov    0x48(%eax),%eax
  801254:	83 ec 04             	sub    $0x4,%esp
  801257:	53                   	push   %ebx
  801258:	50                   	push   %eax
  801259:	68 0d 25 80 00       	push   $0x80250d
  80125e:	e8 21 f0 ff ff       	call   800284 <cprintf>
		return -E_INVAL;
  801263:	83 c4 10             	add    $0x10,%esp
  801266:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80126b:	eb da                	jmp    801247 <read+0x5e>
		return -E_NOT_SUPP;
  80126d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801272:	eb d3                	jmp    801247 <read+0x5e>

00801274 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801274:	f3 0f 1e fb          	endbr32 
  801278:	55                   	push   %ebp
  801279:	89 e5                	mov    %esp,%ebp
  80127b:	57                   	push   %edi
  80127c:	56                   	push   %esi
  80127d:	53                   	push   %ebx
  80127e:	83 ec 0c             	sub    $0xc,%esp
  801281:	8b 7d 08             	mov    0x8(%ebp),%edi
  801284:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801287:	bb 00 00 00 00       	mov    $0x0,%ebx
  80128c:	eb 02                	jmp    801290 <readn+0x1c>
  80128e:	01 c3                	add    %eax,%ebx
  801290:	39 f3                	cmp    %esi,%ebx
  801292:	73 21                	jae    8012b5 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801294:	83 ec 04             	sub    $0x4,%esp
  801297:	89 f0                	mov    %esi,%eax
  801299:	29 d8                	sub    %ebx,%eax
  80129b:	50                   	push   %eax
  80129c:	89 d8                	mov    %ebx,%eax
  80129e:	03 45 0c             	add    0xc(%ebp),%eax
  8012a1:	50                   	push   %eax
  8012a2:	57                   	push   %edi
  8012a3:	e8 41 ff ff ff       	call   8011e9 <read>
		if (m < 0)
  8012a8:	83 c4 10             	add    $0x10,%esp
  8012ab:	85 c0                	test   %eax,%eax
  8012ad:	78 04                	js     8012b3 <readn+0x3f>
			return m;
		if (m == 0)
  8012af:	75 dd                	jne    80128e <readn+0x1a>
  8012b1:	eb 02                	jmp    8012b5 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012b3:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8012b5:	89 d8                	mov    %ebx,%eax
  8012b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012ba:	5b                   	pop    %ebx
  8012bb:	5e                   	pop    %esi
  8012bc:	5f                   	pop    %edi
  8012bd:	5d                   	pop    %ebp
  8012be:	c3                   	ret    

008012bf <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8012bf:	f3 0f 1e fb          	endbr32 
  8012c3:	55                   	push   %ebp
  8012c4:	89 e5                	mov    %esp,%ebp
  8012c6:	53                   	push   %ebx
  8012c7:	83 ec 1c             	sub    $0x1c,%esp
  8012ca:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012d0:	50                   	push   %eax
  8012d1:	53                   	push   %ebx
  8012d2:	e8 8f fc ff ff       	call   800f66 <fd_lookup>
  8012d7:	83 c4 10             	add    $0x10,%esp
  8012da:	85 c0                	test   %eax,%eax
  8012dc:	78 3a                	js     801318 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012de:	83 ec 08             	sub    $0x8,%esp
  8012e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012e4:	50                   	push   %eax
  8012e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012e8:	ff 30                	pushl  (%eax)
  8012ea:	e8 cb fc ff ff       	call   800fba <dev_lookup>
  8012ef:	83 c4 10             	add    $0x10,%esp
  8012f2:	85 c0                	test   %eax,%eax
  8012f4:	78 22                	js     801318 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012f9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012fd:	74 1e                	je     80131d <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8012ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801302:	8b 52 0c             	mov    0xc(%edx),%edx
  801305:	85 d2                	test   %edx,%edx
  801307:	74 35                	je     80133e <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801309:	83 ec 04             	sub    $0x4,%esp
  80130c:	ff 75 10             	pushl  0x10(%ebp)
  80130f:	ff 75 0c             	pushl  0xc(%ebp)
  801312:	50                   	push   %eax
  801313:	ff d2                	call   *%edx
  801315:	83 c4 10             	add    $0x10,%esp
}
  801318:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80131b:	c9                   	leave  
  80131c:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80131d:	a1 20 60 80 00       	mov    0x806020,%eax
  801322:	8b 40 48             	mov    0x48(%eax),%eax
  801325:	83 ec 04             	sub    $0x4,%esp
  801328:	53                   	push   %ebx
  801329:	50                   	push   %eax
  80132a:	68 29 25 80 00       	push   $0x802529
  80132f:	e8 50 ef ff ff       	call   800284 <cprintf>
		return -E_INVAL;
  801334:	83 c4 10             	add    $0x10,%esp
  801337:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80133c:	eb da                	jmp    801318 <write+0x59>
		return -E_NOT_SUPP;
  80133e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801343:	eb d3                	jmp    801318 <write+0x59>

00801345 <seek>:

int
seek(int fdnum, off_t offset)
{
  801345:	f3 0f 1e fb          	endbr32 
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
  80134c:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80134f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801352:	50                   	push   %eax
  801353:	ff 75 08             	pushl  0x8(%ebp)
  801356:	e8 0b fc ff ff       	call   800f66 <fd_lookup>
  80135b:	83 c4 10             	add    $0x10,%esp
  80135e:	85 c0                	test   %eax,%eax
  801360:	78 0e                	js     801370 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801362:	8b 55 0c             	mov    0xc(%ebp),%edx
  801365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801368:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80136b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801370:	c9                   	leave  
  801371:	c3                   	ret    

00801372 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801372:	f3 0f 1e fb          	endbr32 
  801376:	55                   	push   %ebp
  801377:	89 e5                	mov    %esp,%ebp
  801379:	53                   	push   %ebx
  80137a:	83 ec 1c             	sub    $0x1c,%esp
  80137d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801380:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801383:	50                   	push   %eax
  801384:	53                   	push   %ebx
  801385:	e8 dc fb ff ff       	call   800f66 <fd_lookup>
  80138a:	83 c4 10             	add    $0x10,%esp
  80138d:	85 c0                	test   %eax,%eax
  80138f:	78 37                	js     8013c8 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801391:	83 ec 08             	sub    $0x8,%esp
  801394:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801397:	50                   	push   %eax
  801398:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80139b:	ff 30                	pushl  (%eax)
  80139d:	e8 18 fc ff ff       	call   800fba <dev_lookup>
  8013a2:	83 c4 10             	add    $0x10,%esp
  8013a5:	85 c0                	test   %eax,%eax
  8013a7:	78 1f                	js     8013c8 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ac:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013b0:	74 1b                	je     8013cd <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8013b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b5:	8b 52 18             	mov    0x18(%edx),%edx
  8013b8:	85 d2                	test   %edx,%edx
  8013ba:	74 32                	je     8013ee <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8013bc:	83 ec 08             	sub    $0x8,%esp
  8013bf:	ff 75 0c             	pushl  0xc(%ebp)
  8013c2:	50                   	push   %eax
  8013c3:	ff d2                	call   *%edx
  8013c5:	83 c4 10             	add    $0x10,%esp
}
  8013c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013cb:	c9                   	leave  
  8013cc:	c3                   	ret    
			thisenv->env_id, fdnum);
  8013cd:	a1 20 60 80 00       	mov    0x806020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8013d2:	8b 40 48             	mov    0x48(%eax),%eax
  8013d5:	83 ec 04             	sub    $0x4,%esp
  8013d8:	53                   	push   %ebx
  8013d9:	50                   	push   %eax
  8013da:	68 ec 24 80 00       	push   $0x8024ec
  8013df:	e8 a0 ee ff ff       	call   800284 <cprintf>
		return -E_INVAL;
  8013e4:	83 c4 10             	add    $0x10,%esp
  8013e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013ec:	eb da                	jmp    8013c8 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8013ee:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013f3:	eb d3                	jmp    8013c8 <ftruncate+0x56>

008013f5 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8013f5:	f3 0f 1e fb          	endbr32 
  8013f9:	55                   	push   %ebp
  8013fa:	89 e5                	mov    %esp,%ebp
  8013fc:	53                   	push   %ebx
  8013fd:	83 ec 1c             	sub    $0x1c,%esp
  801400:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801403:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801406:	50                   	push   %eax
  801407:	ff 75 08             	pushl  0x8(%ebp)
  80140a:	e8 57 fb ff ff       	call   800f66 <fd_lookup>
  80140f:	83 c4 10             	add    $0x10,%esp
  801412:	85 c0                	test   %eax,%eax
  801414:	78 4b                	js     801461 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801416:	83 ec 08             	sub    $0x8,%esp
  801419:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80141c:	50                   	push   %eax
  80141d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801420:	ff 30                	pushl  (%eax)
  801422:	e8 93 fb ff ff       	call   800fba <dev_lookup>
  801427:	83 c4 10             	add    $0x10,%esp
  80142a:	85 c0                	test   %eax,%eax
  80142c:	78 33                	js     801461 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80142e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801431:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801435:	74 2f                	je     801466 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801437:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80143a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801441:	00 00 00 
	stat->st_isdir = 0;
  801444:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80144b:	00 00 00 
	stat->st_dev = dev;
  80144e:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801454:	83 ec 08             	sub    $0x8,%esp
  801457:	53                   	push   %ebx
  801458:	ff 75 f0             	pushl  -0x10(%ebp)
  80145b:	ff 50 14             	call   *0x14(%eax)
  80145e:	83 c4 10             	add    $0x10,%esp
}
  801461:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801464:	c9                   	leave  
  801465:	c3                   	ret    
		return -E_NOT_SUPP;
  801466:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80146b:	eb f4                	jmp    801461 <fstat+0x6c>

0080146d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80146d:	f3 0f 1e fb          	endbr32 
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
  801474:	56                   	push   %esi
  801475:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801476:	83 ec 08             	sub    $0x8,%esp
  801479:	6a 00                	push   $0x0
  80147b:	ff 75 08             	pushl  0x8(%ebp)
  80147e:	e8 fb 01 00 00       	call   80167e <open>
  801483:	89 c3                	mov    %eax,%ebx
  801485:	83 c4 10             	add    $0x10,%esp
  801488:	85 c0                	test   %eax,%eax
  80148a:	78 1b                	js     8014a7 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80148c:	83 ec 08             	sub    $0x8,%esp
  80148f:	ff 75 0c             	pushl  0xc(%ebp)
  801492:	50                   	push   %eax
  801493:	e8 5d ff ff ff       	call   8013f5 <fstat>
  801498:	89 c6                	mov    %eax,%esi
	close(fd);
  80149a:	89 1c 24             	mov    %ebx,(%esp)
  80149d:	e8 fd fb ff ff       	call   80109f <close>
	return r;
  8014a2:	83 c4 10             	add    $0x10,%esp
  8014a5:	89 f3                	mov    %esi,%ebx
}
  8014a7:	89 d8                	mov    %ebx,%eax
  8014a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014ac:	5b                   	pop    %ebx
  8014ad:	5e                   	pop    %esi
  8014ae:	5d                   	pop    %ebp
  8014af:	c3                   	ret    

008014b0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8014b0:	55                   	push   %ebp
  8014b1:	89 e5                	mov    %esp,%ebp
  8014b3:	56                   	push   %esi
  8014b4:	53                   	push   %ebx
  8014b5:	89 c6                	mov    %eax,%esi
  8014b7:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8014b9:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8014c0:	74 27                	je     8014e9 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8014c2:	6a 07                	push   $0x7
  8014c4:	68 00 70 80 00       	push   $0x807000
  8014c9:	56                   	push   %esi
  8014ca:	ff 35 00 40 80 00    	pushl  0x804000
  8014d0:	e8 fa 08 00 00       	call   801dcf <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8014d5:	83 c4 0c             	add    $0xc,%esp
  8014d8:	6a 00                	push   $0x0
  8014da:	53                   	push   %ebx
  8014db:	6a 00                	push   $0x0
  8014dd:	e8 68 08 00 00       	call   801d4a <ipc_recv>
}
  8014e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014e5:	5b                   	pop    %ebx
  8014e6:	5e                   	pop    %esi
  8014e7:	5d                   	pop    %ebp
  8014e8:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8014e9:	83 ec 0c             	sub    $0xc,%esp
  8014ec:	6a 01                	push   $0x1
  8014ee:	e8 34 09 00 00       	call   801e27 <ipc_find_env>
  8014f3:	a3 00 40 80 00       	mov    %eax,0x804000
  8014f8:	83 c4 10             	add    $0x10,%esp
  8014fb:	eb c5                	jmp    8014c2 <fsipc+0x12>

008014fd <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8014fd:	f3 0f 1e fb          	endbr32 
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
  801504:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
  80150a:	8b 40 0c             	mov    0xc(%eax),%eax
  80150d:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  801512:	8b 45 0c             	mov    0xc(%ebp),%eax
  801515:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80151a:	ba 00 00 00 00       	mov    $0x0,%edx
  80151f:	b8 02 00 00 00       	mov    $0x2,%eax
  801524:	e8 87 ff ff ff       	call   8014b0 <fsipc>
}
  801529:	c9                   	leave  
  80152a:	c3                   	ret    

0080152b <devfile_flush>:
{
  80152b:	f3 0f 1e fb          	endbr32 
  80152f:	55                   	push   %ebp
  801530:	89 e5                	mov    %esp,%ebp
  801532:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801535:	8b 45 08             	mov    0x8(%ebp),%eax
  801538:	8b 40 0c             	mov    0xc(%eax),%eax
  80153b:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  801540:	ba 00 00 00 00       	mov    $0x0,%edx
  801545:	b8 06 00 00 00       	mov    $0x6,%eax
  80154a:	e8 61 ff ff ff       	call   8014b0 <fsipc>
}
  80154f:	c9                   	leave  
  801550:	c3                   	ret    

00801551 <devfile_stat>:
{
  801551:	f3 0f 1e fb          	endbr32 
  801555:	55                   	push   %ebp
  801556:	89 e5                	mov    %esp,%ebp
  801558:	53                   	push   %ebx
  801559:	83 ec 04             	sub    $0x4,%esp
  80155c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80155f:	8b 45 08             	mov    0x8(%ebp),%eax
  801562:	8b 40 0c             	mov    0xc(%eax),%eax
  801565:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80156a:	ba 00 00 00 00       	mov    $0x0,%edx
  80156f:	b8 05 00 00 00       	mov    $0x5,%eax
  801574:	e8 37 ff ff ff       	call   8014b0 <fsipc>
  801579:	85 c0                	test   %eax,%eax
  80157b:	78 2c                	js     8015a9 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80157d:	83 ec 08             	sub    $0x8,%esp
  801580:	68 00 70 80 00       	push   $0x807000
  801585:	53                   	push   %ebx
  801586:	e8 03 f3 ff ff       	call   80088e <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80158b:	a1 80 70 80 00       	mov    0x807080,%eax
  801590:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801596:	a1 84 70 80 00       	mov    0x807084,%eax
  80159b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8015a1:	83 c4 10             	add    $0x10,%esp
  8015a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ac:	c9                   	leave  
  8015ad:	c3                   	ret    

008015ae <devfile_write>:
{
  8015ae:	f3 0f 1e fb          	endbr32 
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
  8015b5:	83 ec 0c             	sub    $0xc,%esp
  8015b8:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8015bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8015be:	8b 52 0c             	mov    0xc(%edx),%edx
  8015c1:	89 15 00 70 80 00    	mov    %edx,0x807000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  8015c7:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8015cc:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8015d1:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  8015d4:	a3 04 70 80 00       	mov    %eax,0x807004
	memmove(fsipcbuf.write.req_buf, buf, n);
  8015d9:	50                   	push   %eax
  8015da:	ff 75 0c             	pushl  0xc(%ebp)
  8015dd:	68 08 70 80 00       	push   $0x807008
  8015e2:	e8 5d f4 ff ff       	call   800a44 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  8015e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ec:	b8 04 00 00 00       	mov    $0x4,%eax
  8015f1:	e8 ba fe ff ff       	call   8014b0 <fsipc>
}
  8015f6:	c9                   	leave  
  8015f7:	c3                   	ret    

008015f8 <devfile_read>:
{
  8015f8:	f3 0f 1e fb          	endbr32 
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
  8015ff:	56                   	push   %esi
  801600:	53                   	push   %ebx
  801601:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801604:	8b 45 08             	mov    0x8(%ebp),%eax
  801607:	8b 40 0c             	mov    0xc(%eax),%eax
  80160a:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  80160f:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801615:	ba 00 00 00 00       	mov    $0x0,%edx
  80161a:	b8 03 00 00 00       	mov    $0x3,%eax
  80161f:	e8 8c fe ff ff       	call   8014b0 <fsipc>
  801624:	89 c3                	mov    %eax,%ebx
  801626:	85 c0                	test   %eax,%eax
  801628:	78 1f                	js     801649 <devfile_read+0x51>
	assert(r <= n);
  80162a:	39 f0                	cmp    %esi,%eax
  80162c:	77 24                	ja     801652 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  80162e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801633:	7f 33                	jg     801668 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801635:	83 ec 04             	sub    $0x4,%esp
  801638:	50                   	push   %eax
  801639:	68 00 70 80 00       	push   $0x807000
  80163e:	ff 75 0c             	pushl  0xc(%ebp)
  801641:	e8 fe f3 ff ff       	call   800a44 <memmove>
	return r;
  801646:	83 c4 10             	add    $0x10,%esp
}
  801649:	89 d8                	mov    %ebx,%eax
  80164b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80164e:	5b                   	pop    %ebx
  80164f:	5e                   	pop    %esi
  801650:	5d                   	pop    %ebp
  801651:	c3                   	ret    
	assert(r <= n);
  801652:	68 58 25 80 00       	push   $0x802558
  801657:	68 5f 25 80 00       	push   $0x80255f
  80165c:	6a 7c                	push   $0x7c
  80165e:	68 74 25 80 00       	push   $0x802574
  801663:	e8 35 eb ff ff       	call   80019d <_panic>
	assert(r <= PGSIZE);
  801668:	68 7f 25 80 00       	push   $0x80257f
  80166d:	68 5f 25 80 00       	push   $0x80255f
  801672:	6a 7d                	push   $0x7d
  801674:	68 74 25 80 00       	push   $0x802574
  801679:	e8 1f eb ff ff       	call   80019d <_panic>

0080167e <open>:
{
  80167e:	f3 0f 1e fb          	endbr32 
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
  801685:	56                   	push   %esi
  801686:	53                   	push   %ebx
  801687:	83 ec 1c             	sub    $0x1c,%esp
  80168a:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80168d:	56                   	push   %esi
  80168e:	e8 b8 f1 ff ff       	call   80084b <strlen>
  801693:	83 c4 10             	add    $0x10,%esp
  801696:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80169b:	7f 6c                	jg     801709 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  80169d:	83 ec 0c             	sub    $0xc,%esp
  8016a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016a3:	50                   	push   %eax
  8016a4:	e8 67 f8 ff ff       	call   800f10 <fd_alloc>
  8016a9:	89 c3                	mov    %eax,%ebx
  8016ab:	83 c4 10             	add    $0x10,%esp
  8016ae:	85 c0                	test   %eax,%eax
  8016b0:	78 3c                	js     8016ee <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8016b2:	83 ec 08             	sub    $0x8,%esp
  8016b5:	56                   	push   %esi
  8016b6:	68 00 70 80 00       	push   $0x807000
  8016bb:	e8 ce f1 ff ff       	call   80088e <strcpy>
	fsipcbuf.open.req_omode = mode;
  8016c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c3:	a3 00 74 80 00       	mov    %eax,0x807400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8016c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016cb:	b8 01 00 00 00       	mov    $0x1,%eax
  8016d0:	e8 db fd ff ff       	call   8014b0 <fsipc>
  8016d5:	89 c3                	mov    %eax,%ebx
  8016d7:	83 c4 10             	add    $0x10,%esp
  8016da:	85 c0                	test   %eax,%eax
  8016dc:	78 19                	js     8016f7 <open+0x79>
	return fd2num(fd);
  8016de:	83 ec 0c             	sub    $0xc,%esp
  8016e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8016e4:	e8 f8 f7 ff ff       	call   800ee1 <fd2num>
  8016e9:	89 c3                	mov    %eax,%ebx
  8016eb:	83 c4 10             	add    $0x10,%esp
}
  8016ee:	89 d8                	mov    %ebx,%eax
  8016f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016f3:	5b                   	pop    %ebx
  8016f4:	5e                   	pop    %esi
  8016f5:	5d                   	pop    %ebp
  8016f6:	c3                   	ret    
		fd_close(fd, 0);
  8016f7:	83 ec 08             	sub    $0x8,%esp
  8016fa:	6a 00                	push   $0x0
  8016fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8016ff:	e8 10 f9 ff ff       	call   801014 <fd_close>
		return r;
  801704:	83 c4 10             	add    $0x10,%esp
  801707:	eb e5                	jmp    8016ee <open+0x70>
		return -E_BAD_PATH;
  801709:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80170e:	eb de                	jmp    8016ee <open+0x70>

00801710 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801710:	f3 0f 1e fb          	endbr32 
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
  801717:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80171a:	ba 00 00 00 00       	mov    $0x0,%edx
  80171f:	b8 08 00 00 00       	mov    $0x8,%eax
  801724:	e8 87 fd ff ff       	call   8014b0 <fsipc>
}
  801729:	c9                   	leave  
  80172a:	c3                   	ret    

0080172b <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  80172b:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  80172f:	7f 01                	jg     801732 <writebuf+0x7>
  801731:	c3                   	ret    
{
  801732:	55                   	push   %ebp
  801733:	89 e5                	mov    %esp,%ebp
  801735:	53                   	push   %ebx
  801736:	83 ec 08             	sub    $0x8,%esp
  801739:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  80173b:	ff 70 04             	pushl  0x4(%eax)
  80173e:	8d 40 10             	lea    0x10(%eax),%eax
  801741:	50                   	push   %eax
  801742:	ff 33                	pushl  (%ebx)
  801744:	e8 76 fb ff ff       	call   8012bf <write>
		if (result > 0)
  801749:	83 c4 10             	add    $0x10,%esp
  80174c:	85 c0                	test   %eax,%eax
  80174e:	7e 03                	jle    801753 <writebuf+0x28>
			b->result += result;
  801750:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801753:	39 43 04             	cmp    %eax,0x4(%ebx)
  801756:	74 0d                	je     801765 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801758:	85 c0                	test   %eax,%eax
  80175a:	ba 00 00 00 00       	mov    $0x0,%edx
  80175f:	0f 4f c2             	cmovg  %edx,%eax
  801762:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801765:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801768:	c9                   	leave  
  801769:	c3                   	ret    

0080176a <putch>:

static void
putch(int ch, void *thunk)
{
  80176a:	f3 0f 1e fb          	endbr32 
  80176e:	55                   	push   %ebp
  80176f:	89 e5                	mov    %esp,%ebp
  801771:	53                   	push   %ebx
  801772:	83 ec 04             	sub    $0x4,%esp
  801775:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801778:	8b 53 04             	mov    0x4(%ebx),%edx
  80177b:	8d 42 01             	lea    0x1(%edx),%eax
  80177e:	89 43 04             	mov    %eax,0x4(%ebx)
  801781:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801784:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801788:	3d 00 01 00 00       	cmp    $0x100,%eax
  80178d:	74 06                	je     801795 <putch+0x2b>
		writebuf(b);
		b->idx = 0;
	}
}
  80178f:	83 c4 04             	add    $0x4,%esp
  801792:	5b                   	pop    %ebx
  801793:	5d                   	pop    %ebp
  801794:	c3                   	ret    
		writebuf(b);
  801795:	89 d8                	mov    %ebx,%eax
  801797:	e8 8f ff ff ff       	call   80172b <writebuf>
		b->idx = 0;
  80179c:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8017a3:	eb ea                	jmp    80178f <putch+0x25>

008017a5 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8017a5:	f3 0f 1e fb          	endbr32 
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
  8017ac:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  8017b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b5:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8017bb:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8017c2:	00 00 00 
	b.result = 0;
  8017c5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8017cc:	00 00 00 
	b.error = 1;
  8017cf:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8017d6:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8017d9:	ff 75 10             	pushl  0x10(%ebp)
  8017dc:	ff 75 0c             	pushl  0xc(%ebp)
  8017df:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8017e5:	50                   	push   %eax
  8017e6:	68 6a 17 80 00       	push   $0x80176a
  8017eb:	e8 97 eb ff ff       	call   800387 <vprintfmt>
	if (b.idx > 0)
  8017f0:	83 c4 10             	add    $0x10,%esp
  8017f3:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  8017fa:	7f 11                	jg     80180d <vfprintf+0x68>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  8017fc:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801802:	85 c0                	test   %eax,%eax
  801804:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  80180b:	c9                   	leave  
  80180c:	c3                   	ret    
		writebuf(&b);
  80180d:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801813:	e8 13 ff ff ff       	call   80172b <writebuf>
  801818:	eb e2                	jmp    8017fc <vfprintf+0x57>

0080181a <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  80181a:	f3 0f 1e fb          	endbr32 
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
  801821:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801824:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801827:	50                   	push   %eax
  801828:	ff 75 0c             	pushl  0xc(%ebp)
  80182b:	ff 75 08             	pushl  0x8(%ebp)
  80182e:	e8 72 ff ff ff       	call   8017a5 <vfprintf>
	va_end(ap);

	return cnt;
}
  801833:	c9                   	leave  
  801834:	c3                   	ret    

00801835 <printf>:

int
printf(const char *fmt, ...)
{
  801835:	f3 0f 1e fb          	endbr32 
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
  80183c:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80183f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801842:	50                   	push   %eax
  801843:	ff 75 08             	pushl  0x8(%ebp)
  801846:	6a 01                	push   $0x1
  801848:	e8 58 ff ff ff       	call   8017a5 <vfprintf>
	va_end(ap);

	return cnt;
}
  80184d:	c9                   	leave  
  80184e:	c3                   	ret    

0080184f <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80184f:	f3 0f 1e fb          	endbr32 
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
  801856:	56                   	push   %esi
  801857:	53                   	push   %ebx
  801858:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80185b:	83 ec 0c             	sub    $0xc,%esp
  80185e:	ff 75 08             	pushl  0x8(%ebp)
  801861:	e8 8f f6 ff ff       	call   800ef5 <fd2data>
  801866:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801868:	83 c4 08             	add    $0x8,%esp
  80186b:	68 8b 25 80 00       	push   $0x80258b
  801870:	53                   	push   %ebx
  801871:	e8 18 f0 ff ff       	call   80088e <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801876:	8b 46 04             	mov    0x4(%esi),%eax
  801879:	2b 06                	sub    (%esi),%eax
  80187b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801881:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801888:	00 00 00 
	stat->st_dev = &devpipe;
  80188b:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801892:	30 80 00 
	return 0;
}
  801895:	b8 00 00 00 00       	mov    $0x0,%eax
  80189a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80189d:	5b                   	pop    %ebx
  80189e:	5e                   	pop    %esi
  80189f:	5d                   	pop    %ebp
  8018a0:	c3                   	ret    

008018a1 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8018a1:	f3 0f 1e fb          	endbr32 
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
  8018a8:	53                   	push   %ebx
  8018a9:	83 ec 0c             	sub    $0xc,%esp
  8018ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8018af:	53                   	push   %ebx
  8018b0:	6a 00                	push   $0x0
  8018b2:	e8 a6 f4 ff ff       	call   800d5d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8018b7:	89 1c 24             	mov    %ebx,(%esp)
  8018ba:	e8 36 f6 ff ff       	call   800ef5 <fd2data>
  8018bf:	83 c4 08             	add    $0x8,%esp
  8018c2:	50                   	push   %eax
  8018c3:	6a 00                	push   $0x0
  8018c5:	e8 93 f4 ff ff       	call   800d5d <sys_page_unmap>
}
  8018ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018cd:	c9                   	leave  
  8018ce:	c3                   	ret    

008018cf <_pipeisclosed>:
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
  8018d2:	57                   	push   %edi
  8018d3:	56                   	push   %esi
  8018d4:	53                   	push   %ebx
  8018d5:	83 ec 1c             	sub    $0x1c,%esp
  8018d8:	89 c7                	mov    %eax,%edi
  8018da:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8018dc:	a1 20 60 80 00       	mov    0x806020,%eax
  8018e1:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8018e4:	83 ec 0c             	sub    $0xc,%esp
  8018e7:	57                   	push   %edi
  8018e8:	e8 77 05 00 00       	call   801e64 <pageref>
  8018ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8018f0:	89 34 24             	mov    %esi,(%esp)
  8018f3:	e8 6c 05 00 00       	call   801e64 <pageref>
		nn = thisenv->env_runs;
  8018f8:	8b 15 20 60 80 00    	mov    0x806020,%edx
  8018fe:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801901:	83 c4 10             	add    $0x10,%esp
  801904:	39 cb                	cmp    %ecx,%ebx
  801906:	74 1b                	je     801923 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801908:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80190b:	75 cf                	jne    8018dc <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80190d:	8b 42 58             	mov    0x58(%edx),%eax
  801910:	6a 01                	push   $0x1
  801912:	50                   	push   %eax
  801913:	53                   	push   %ebx
  801914:	68 92 25 80 00       	push   $0x802592
  801919:	e8 66 e9 ff ff       	call   800284 <cprintf>
  80191e:	83 c4 10             	add    $0x10,%esp
  801921:	eb b9                	jmp    8018dc <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801923:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801926:	0f 94 c0             	sete   %al
  801929:	0f b6 c0             	movzbl %al,%eax
}
  80192c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80192f:	5b                   	pop    %ebx
  801930:	5e                   	pop    %esi
  801931:	5f                   	pop    %edi
  801932:	5d                   	pop    %ebp
  801933:	c3                   	ret    

00801934 <devpipe_write>:
{
  801934:	f3 0f 1e fb          	endbr32 
  801938:	55                   	push   %ebp
  801939:	89 e5                	mov    %esp,%ebp
  80193b:	57                   	push   %edi
  80193c:	56                   	push   %esi
  80193d:	53                   	push   %ebx
  80193e:	83 ec 28             	sub    $0x28,%esp
  801941:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801944:	56                   	push   %esi
  801945:	e8 ab f5 ff ff       	call   800ef5 <fd2data>
  80194a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80194c:	83 c4 10             	add    $0x10,%esp
  80194f:	bf 00 00 00 00       	mov    $0x0,%edi
  801954:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801957:	74 4f                	je     8019a8 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801959:	8b 43 04             	mov    0x4(%ebx),%eax
  80195c:	8b 0b                	mov    (%ebx),%ecx
  80195e:	8d 51 20             	lea    0x20(%ecx),%edx
  801961:	39 d0                	cmp    %edx,%eax
  801963:	72 14                	jb     801979 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801965:	89 da                	mov    %ebx,%edx
  801967:	89 f0                	mov    %esi,%eax
  801969:	e8 61 ff ff ff       	call   8018cf <_pipeisclosed>
  80196e:	85 c0                	test   %eax,%eax
  801970:	75 3b                	jne    8019ad <devpipe_write+0x79>
			sys_yield();
  801972:	e8 36 f3 ff ff       	call   800cad <sys_yield>
  801977:	eb e0                	jmp    801959 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801979:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80197c:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801980:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801983:	89 c2                	mov    %eax,%edx
  801985:	c1 fa 1f             	sar    $0x1f,%edx
  801988:	89 d1                	mov    %edx,%ecx
  80198a:	c1 e9 1b             	shr    $0x1b,%ecx
  80198d:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801990:	83 e2 1f             	and    $0x1f,%edx
  801993:	29 ca                	sub    %ecx,%edx
  801995:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801999:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80199d:	83 c0 01             	add    $0x1,%eax
  8019a0:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8019a3:	83 c7 01             	add    $0x1,%edi
  8019a6:	eb ac                	jmp    801954 <devpipe_write+0x20>
	return i;
  8019a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ab:	eb 05                	jmp    8019b2 <devpipe_write+0x7e>
				return 0;
  8019ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019b5:	5b                   	pop    %ebx
  8019b6:	5e                   	pop    %esi
  8019b7:	5f                   	pop    %edi
  8019b8:	5d                   	pop    %ebp
  8019b9:	c3                   	ret    

008019ba <devpipe_read>:
{
  8019ba:	f3 0f 1e fb          	endbr32 
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
  8019c1:	57                   	push   %edi
  8019c2:	56                   	push   %esi
  8019c3:	53                   	push   %ebx
  8019c4:	83 ec 18             	sub    $0x18,%esp
  8019c7:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8019ca:	57                   	push   %edi
  8019cb:	e8 25 f5 ff ff       	call   800ef5 <fd2data>
  8019d0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8019d2:	83 c4 10             	add    $0x10,%esp
  8019d5:	be 00 00 00 00       	mov    $0x0,%esi
  8019da:	3b 75 10             	cmp    0x10(%ebp),%esi
  8019dd:	75 14                	jne    8019f3 <devpipe_read+0x39>
	return i;
  8019df:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e2:	eb 02                	jmp    8019e6 <devpipe_read+0x2c>
				return i;
  8019e4:	89 f0                	mov    %esi,%eax
}
  8019e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019e9:	5b                   	pop    %ebx
  8019ea:	5e                   	pop    %esi
  8019eb:	5f                   	pop    %edi
  8019ec:	5d                   	pop    %ebp
  8019ed:	c3                   	ret    
			sys_yield();
  8019ee:	e8 ba f2 ff ff       	call   800cad <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8019f3:	8b 03                	mov    (%ebx),%eax
  8019f5:	3b 43 04             	cmp    0x4(%ebx),%eax
  8019f8:	75 18                	jne    801a12 <devpipe_read+0x58>
			if (i > 0)
  8019fa:	85 f6                	test   %esi,%esi
  8019fc:	75 e6                	jne    8019e4 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8019fe:	89 da                	mov    %ebx,%edx
  801a00:	89 f8                	mov    %edi,%eax
  801a02:	e8 c8 fe ff ff       	call   8018cf <_pipeisclosed>
  801a07:	85 c0                	test   %eax,%eax
  801a09:	74 e3                	je     8019ee <devpipe_read+0x34>
				return 0;
  801a0b:	b8 00 00 00 00       	mov    $0x0,%eax
  801a10:	eb d4                	jmp    8019e6 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801a12:	99                   	cltd   
  801a13:	c1 ea 1b             	shr    $0x1b,%edx
  801a16:	01 d0                	add    %edx,%eax
  801a18:	83 e0 1f             	and    $0x1f,%eax
  801a1b:	29 d0                	sub    %edx,%eax
  801a1d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801a22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a25:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801a28:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801a2b:	83 c6 01             	add    $0x1,%esi
  801a2e:	eb aa                	jmp    8019da <devpipe_read+0x20>

00801a30 <pipe>:
{
  801a30:	f3 0f 1e fb          	endbr32 
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
  801a37:	56                   	push   %esi
  801a38:	53                   	push   %ebx
  801a39:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801a3c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a3f:	50                   	push   %eax
  801a40:	e8 cb f4 ff ff       	call   800f10 <fd_alloc>
  801a45:	89 c3                	mov    %eax,%ebx
  801a47:	83 c4 10             	add    $0x10,%esp
  801a4a:	85 c0                	test   %eax,%eax
  801a4c:	0f 88 23 01 00 00    	js     801b75 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a52:	83 ec 04             	sub    $0x4,%esp
  801a55:	68 07 04 00 00       	push   $0x407
  801a5a:	ff 75 f4             	pushl  -0xc(%ebp)
  801a5d:	6a 00                	push   $0x0
  801a5f:	e8 6c f2 ff ff       	call   800cd0 <sys_page_alloc>
  801a64:	89 c3                	mov    %eax,%ebx
  801a66:	83 c4 10             	add    $0x10,%esp
  801a69:	85 c0                	test   %eax,%eax
  801a6b:	0f 88 04 01 00 00    	js     801b75 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801a71:	83 ec 0c             	sub    $0xc,%esp
  801a74:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a77:	50                   	push   %eax
  801a78:	e8 93 f4 ff ff       	call   800f10 <fd_alloc>
  801a7d:	89 c3                	mov    %eax,%ebx
  801a7f:	83 c4 10             	add    $0x10,%esp
  801a82:	85 c0                	test   %eax,%eax
  801a84:	0f 88 db 00 00 00    	js     801b65 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a8a:	83 ec 04             	sub    $0x4,%esp
  801a8d:	68 07 04 00 00       	push   $0x407
  801a92:	ff 75 f0             	pushl  -0x10(%ebp)
  801a95:	6a 00                	push   $0x0
  801a97:	e8 34 f2 ff ff       	call   800cd0 <sys_page_alloc>
  801a9c:	89 c3                	mov    %eax,%ebx
  801a9e:	83 c4 10             	add    $0x10,%esp
  801aa1:	85 c0                	test   %eax,%eax
  801aa3:	0f 88 bc 00 00 00    	js     801b65 <pipe+0x135>
	va = fd2data(fd0);
  801aa9:	83 ec 0c             	sub    $0xc,%esp
  801aac:	ff 75 f4             	pushl  -0xc(%ebp)
  801aaf:	e8 41 f4 ff ff       	call   800ef5 <fd2data>
  801ab4:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ab6:	83 c4 0c             	add    $0xc,%esp
  801ab9:	68 07 04 00 00       	push   $0x407
  801abe:	50                   	push   %eax
  801abf:	6a 00                	push   $0x0
  801ac1:	e8 0a f2 ff ff       	call   800cd0 <sys_page_alloc>
  801ac6:	89 c3                	mov    %eax,%ebx
  801ac8:	83 c4 10             	add    $0x10,%esp
  801acb:	85 c0                	test   %eax,%eax
  801acd:	0f 88 82 00 00 00    	js     801b55 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ad3:	83 ec 0c             	sub    $0xc,%esp
  801ad6:	ff 75 f0             	pushl  -0x10(%ebp)
  801ad9:	e8 17 f4 ff ff       	call   800ef5 <fd2data>
  801ade:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ae5:	50                   	push   %eax
  801ae6:	6a 00                	push   $0x0
  801ae8:	56                   	push   %esi
  801ae9:	6a 00                	push   $0x0
  801aeb:	e8 27 f2 ff ff       	call   800d17 <sys_page_map>
  801af0:	89 c3                	mov    %eax,%ebx
  801af2:	83 c4 20             	add    $0x20,%esp
  801af5:	85 c0                	test   %eax,%eax
  801af7:	78 4e                	js     801b47 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801af9:	a1 20 30 80 00       	mov    0x803020,%eax
  801afe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b01:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801b03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b06:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801b0d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b10:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b15:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801b1c:	83 ec 0c             	sub    $0xc,%esp
  801b1f:	ff 75 f4             	pushl  -0xc(%ebp)
  801b22:	e8 ba f3 ff ff       	call   800ee1 <fd2num>
  801b27:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b2a:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801b2c:	83 c4 04             	add    $0x4,%esp
  801b2f:	ff 75 f0             	pushl  -0x10(%ebp)
  801b32:	e8 aa f3 ff ff       	call   800ee1 <fd2num>
  801b37:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b3a:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801b3d:	83 c4 10             	add    $0x10,%esp
  801b40:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b45:	eb 2e                	jmp    801b75 <pipe+0x145>
	sys_page_unmap(0, va);
  801b47:	83 ec 08             	sub    $0x8,%esp
  801b4a:	56                   	push   %esi
  801b4b:	6a 00                	push   $0x0
  801b4d:	e8 0b f2 ff ff       	call   800d5d <sys_page_unmap>
  801b52:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801b55:	83 ec 08             	sub    $0x8,%esp
  801b58:	ff 75 f0             	pushl  -0x10(%ebp)
  801b5b:	6a 00                	push   $0x0
  801b5d:	e8 fb f1 ff ff       	call   800d5d <sys_page_unmap>
  801b62:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801b65:	83 ec 08             	sub    $0x8,%esp
  801b68:	ff 75 f4             	pushl  -0xc(%ebp)
  801b6b:	6a 00                	push   $0x0
  801b6d:	e8 eb f1 ff ff       	call   800d5d <sys_page_unmap>
  801b72:	83 c4 10             	add    $0x10,%esp
}
  801b75:	89 d8                	mov    %ebx,%eax
  801b77:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b7a:	5b                   	pop    %ebx
  801b7b:	5e                   	pop    %esi
  801b7c:	5d                   	pop    %ebp
  801b7d:	c3                   	ret    

00801b7e <pipeisclosed>:
{
  801b7e:	f3 0f 1e fb          	endbr32 
  801b82:	55                   	push   %ebp
  801b83:	89 e5                	mov    %esp,%ebp
  801b85:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b88:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b8b:	50                   	push   %eax
  801b8c:	ff 75 08             	pushl  0x8(%ebp)
  801b8f:	e8 d2 f3 ff ff       	call   800f66 <fd_lookup>
  801b94:	83 c4 10             	add    $0x10,%esp
  801b97:	85 c0                	test   %eax,%eax
  801b99:	78 18                	js     801bb3 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801b9b:	83 ec 0c             	sub    $0xc,%esp
  801b9e:	ff 75 f4             	pushl  -0xc(%ebp)
  801ba1:	e8 4f f3 ff ff       	call   800ef5 <fd2data>
  801ba6:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bab:	e8 1f fd ff ff       	call   8018cf <_pipeisclosed>
  801bb0:	83 c4 10             	add    $0x10,%esp
}
  801bb3:	c9                   	leave  
  801bb4:	c3                   	ret    

00801bb5 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801bb5:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801bb9:	b8 00 00 00 00       	mov    $0x0,%eax
  801bbe:	c3                   	ret    

00801bbf <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801bbf:	f3 0f 1e fb          	endbr32 
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
  801bc6:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801bc9:	68 aa 25 80 00       	push   $0x8025aa
  801bce:	ff 75 0c             	pushl  0xc(%ebp)
  801bd1:	e8 b8 ec ff ff       	call   80088e <strcpy>
	return 0;
}
  801bd6:	b8 00 00 00 00       	mov    $0x0,%eax
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <devcons_write>:
{
  801bdd:	f3 0f 1e fb          	endbr32 
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
  801be4:	57                   	push   %edi
  801be5:	56                   	push   %esi
  801be6:	53                   	push   %ebx
  801be7:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801bed:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801bf2:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801bf8:	3b 75 10             	cmp    0x10(%ebp),%esi
  801bfb:	73 31                	jae    801c2e <devcons_write+0x51>
		m = n - tot;
  801bfd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801c00:	29 f3                	sub    %esi,%ebx
  801c02:	83 fb 7f             	cmp    $0x7f,%ebx
  801c05:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801c0a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801c0d:	83 ec 04             	sub    $0x4,%esp
  801c10:	53                   	push   %ebx
  801c11:	89 f0                	mov    %esi,%eax
  801c13:	03 45 0c             	add    0xc(%ebp),%eax
  801c16:	50                   	push   %eax
  801c17:	57                   	push   %edi
  801c18:	e8 27 ee ff ff       	call   800a44 <memmove>
		sys_cputs(buf, m);
  801c1d:	83 c4 08             	add    $0x8,%esp
  801c20:	53                   	push   %ebx
  801c21:	57                   	push   %edi
  801c22:	e8 d9 ef ff ff       	call   800c00 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801c27:	01 de                	add    %ebx,%esi
  801c29:	83 c4 10             	add    $0x10,%esp
  801c2c:	eb ca                	jmp    801bf8 <devcons_write+0x1b>
}
  801c2e:	89 f0                	mov    %esi,%eax
  801c30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c33:	5b                   	pop    %ebx
  801c34:	5e                   	pop    %esi
  801c35:	5f                   	pop    %edi
  801c36:	5d                   	pop    %ebp
  801c37:	c3                   	ret    

00801c38 <devcons_read>:
{
  801c38:	f3 0f 1e fb          	endbr32 
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
  801c3f:	83 ec 08             	sub    $0x8,%esp
  801c42:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801c47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c4b:	74 21                	je     801c6e <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801c4d:	e8 d0 ef ff ff       	call   800c22 <sys_cgetc>
  801c52:	85 c0                	test   %eax,%eax
  801c54:	75 07                	jne    801c5d <devcons_read+0x25>
		sys_yield();
  801c56:	e8 52 f0 ff ff       	call   800cad <sys_yield>
  801c5b:	eb f0                	jmp    801c4d <devcons_read+0x15>
	if (c < 0)
  801c5d:	78 0f                	js     801c6e <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801c5f:	83 f8 04             	cmp    $0x4,%eax
  801c62:	74 0c                	je     801c70 <devcons_read+0x38>
	*(char*)vbuf = c;
  801c64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c67:	88 02                	mov    %al,(%edx)
	return 1;
  801c69:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801c6e:	c9                   	leave  
  801c6f:	c3                   	ret    
		return 0;
  801c70:	b8 00 00 00 00       	mov    $0x0,%eax
  801c75:	eb f7                	jmp    801c6e <devcons_read+0x36>

00801c77 <cputchar>:
{
  801c77:	f3 0f 1e fb          	endbr32 
  801c7b:	55                   	push   %ebp
  801c7c:	89 e5                	mov    %esp,%ebp
  801c7e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801c81:	8b 45 08             	mov    0x8(%ebp),%eax
  801c84:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801c87:	6a 01                	push   $0x1
  801c89:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801c8c:	50                   	push   %eax
  801c8d:	e8 6e ef ff ff       	call   800c00 <sys_cputs>
}
  801c92:	83 c4 10             	add    $0x10,%esp
  801c95:	c9                   	leave  
  801c96:	c3                   	ret    

00801c97 <getchar>:
{
  801c97:	f3 0f 1e fb          	endbr32 
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
  801c9e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801ca1:	6a 01                	push   $0x1
  801ca3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ca6:	50                   	push   %eax
  801ca7:	6a 00                	push   $0x0
  801ca9:	e8 3b f5 ff ff       	call   8011e9 <read>
	if (r < 0)
  801cae:	83 c4 10             	add    $0x10,%esp
  801cb1:	85 c0                	test   %eax,%eax
  801cb3:	78 06                	js     801cbb <getchar+0x24>
	if (r < 1)
  801cb5:	74 06                	je     801cbd <getchar+0x26>
	return c;
  801cb7:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    
		return -E_EOF;
  801cbd:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801cc2:	eb f7                	jmp    801cbb <getchar+0x24>

00801cc4 <iscons>:
{
  801cc4:	f3 0f 1e fb          	endbr32 
  801cc8:	55                   	push   %ebp
  801cc9:	89 e5                	mov    %esp,%ebp
  801ccb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801cce:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cd1:	50                   	push   %eax
  801cd2:	ff 75 08             	pushl  0x8(%ebp)
  801cd5:	e8 8c f2 ff ff       	call   800f66 <fd_lookup>
  801cda:	83 c4 10             	add    $0x10,%esp
  801cdd:	85 c0                	test   %eax,%eax
  801cdf:	78 11                	js     801cf2 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801cea:	39 10                	cmp    %edx,(%eax)
  801cec:	0f 94 c0             	sete   %al
  801cef:	0f b6 c0             	movzbl %al,%eax
}
  801cf2:	c9                   	leave  
  801cf3:	c3                   	ret    

00801cf4 <opencons>:
{
  801cf4:	f3 0f 1e fb          	endbr32 
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
  801cfb:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801cfe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d01:	50                   	push   %eax
  801d02:	e8 09 f2 ff ff       	call   800f10 <fd_alloc>
  801d07:	83 c4 10             	add    $0x10,%esp
  801d0a:	85 c0                	test   %eax,%eax
  801d0c:	78 3a                	js     801d48 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801d0e:	83 ec 04             	sub    $0x4,%esp
  801d11:	68 07 04 00 00       	push   $0x407
  801d16:	ff 75 f4             	pushl  -0xc(%ebp)
  801d19:	6a 00                	push   $0x0
  801d1b:	e8 b0 ef ff ff       	call   800cd0 <sys_page_alloc>
  801d20:	83 c4 10             	add    $0x10,%esp
  801d23:	85 c0                	test   %eax,%eax
  801d25:	78 21                	js     801d48 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801d27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d2a:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801d30:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d35:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801d3c:	83 ec 0c             	sub    $0xc,%esp
  801d3f:	50                   	push   %eax
  801d40:	e8 9c f1 ff ff       	call   800ee1 <fd2num>
  801d45:	83 c4 10             	add    $0x10,%esp
}
  801d48:	c9                   	leave  
  801d49:	c3                   	ret    

00801d4a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801d4a:	f3 0f 1e fb          	endbr32 
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
  801d51:	56                   	push   %esi
  801d52:	53                   	push   %ebx
  801d53:	8b 75 08             	mov    0x8(%ebp),%esi
  801d56:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d59:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  801d5c:	85 c0                	test   %eax,%eax
  801d5e:	74 3d                	je     801d9d <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  801d60:	83 ec 0c             	sub    $0xc,%esp
  801d63:	50                   	push   %eax
  801d64:	e8 33 f1 ff ff       	call   800e9c <sys_ipc_recv>
  801d69:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  801d6c:	85 f6                	test   %esi,%esi
  801d6e:	74 0b                	je     801d7b <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801d70:	8b 15 20 60 80 00    	mov    0x806020,%edx
  801d76:	8b 52 74             	mov    0x74(%edx),%edx
  801d79:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801d7b:	85 db                	test   %ebx,%ebx
  801d7d:	74 0b                	je     801d8a <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  801d7f:	8b 15 20 60 80 00    	mov    0x806020,%edx
  801d85:	8b 52 78             	mov    0x78(%edx),%edx
  801d88:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  801d8a:	85 c0                	test   %eax,%eax
  801d8c:	78 21                	js     801daf <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  801d8e:	a1 20 60 80 00       	mov    0x806020,%eax
  801d93:	8b 40 70             	mov    0x70(%eax),%eax
}
  801d96:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d99:	5b                   	pop    %ebx
  801d9a:	5e                   	pop    %esi
  801d9b:	5d                   	pop    %ebp
  801d9c:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  801d9d:	83 ec 0c             	sub    $0xc,%esp
  801da0:	68 00 00 c0 ee       	push   $0xeec00000
  801da5:	e8 f2 f0 ff ff       	call   800e9c <sys_ipc_recv>
  801daa:	83 c4 10             	add    $0x10,%esp
  801dad:	eb bd                	jmp    801d6c <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  801daf:	85 f6                	test   %esi,%esi
  801db1:	74 10                	je     801dc3 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  801db3:	85 db                	test   %ebx,%ebx
  801db5:	75 df                	jne    801d96 <ipc_recv+0x4c>
  801db7:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801dbe:	00 00 00 
  801dc1:	eb d3                	jmp    801d96 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  801dc3:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801dca:	00 00 00 
  801dcd:	eb e4                	jmp    801db3 <ipc_recv+0x69>

00801dcf <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801dcf:	f3 0f 1e fb          	endbr32 
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
  801dd6:	57                   	push   %edi
  801dd7:	56                   	push   %esi
  801dd8:	53                   	push   %ebx
  801dd9:	83 ec 0c             	sub    $0xc,%esp
  801ddc:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ddf:	8b 75 0c             	mov    0xc(%ebp),%esi
  801de2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  801de5:	85 db                	test   %ebx,%ebx
  801de7:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801dec:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  801def:	ff 75 14             	pushl  0x14(%ebp)
  801df2:	53                   	push   %ebx
  801df3:	56                   	push   %esi
  801df4:	57                   	push   %edi
  801df5:	e8 7b f0 ff ff       	call   800e75 <sys_ipc_try_send>
  801dfa:	83 c4 10             	add    $0x10,%esp
  801dfd:	85 c0                	test   %eax,%eax
  801dff:	79 1e                	jns    801e1f <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  801e01:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801e04:	75 07                	jne    801e0d <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  801e06:	e8 a2 ee ff ff       	call   800cad <sys_yield>
  801e0b:	eb e2                	jmp    801def <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  801e0d:	50                   	push   %eax
  801e0e:	68 b6 25 80 00       	push   $0x8025b6
  801e13:	6a 59                	push   $0x59
  801e15:	68 d1 25 80 00       	push   $0x8025d1
  801e1a:	e8 7e e3 ff ff       	call   80019d <_panic>
	}
}
  801e1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e22:	5b                   	pop    %ebx
  801e23:	5e                   	pop    %esi
  801e24:	5f                   	pop    %edi
  801e25:	5d                   	pop    %ebp
  801e26:	c3                   	ret    

00801e27 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801e27:	f3 0f 1e fb          	endbr32 
  801e2b:	55                   	push   %ebp
  801e2c:	89 e5                	mov    %esp,%ebp
  801e2e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801e31:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801e36:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801e39:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801e3f:	8b 52 50             	mov    0x50(%edx),%edx
  801e42:	39 ca                	cmp    %ecx,%edx
  801e44:	74 11                	je     801e57 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801e46:	83 c0 01             	add    $0x1,%eax
  801e49:	3d 00 04 00 00       	cmp    $0x400,%eax
  801e4e:	75 e6                	jne    801e36 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801e50:	b8 00 00 00 00       	mov    $0x0,%eax
  801e55:	eb 0b                	jmp    801e62 <ipc_find_env+0x3b>
			return envs[i].env_id;
  801e57:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801e5a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801e5f:	8b 40 48             	mov    0x48(%eax),%eax
}
  801e62:	5d                   	pop    %ebp
  801e63:	c3                   	ret    

00801e64 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801e64:	f3 0f 1e fb          	endbr32 
  801e68:	55                   	push   %ebp
  801e69:	89 e5                	mov    %esp,%ebp
  801e6b:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801e6e:	89 c2                	mov    %eax,%edx
  801e70:	c1 ea 16             	shr    $0x16,%edx
  801e73:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801e7a:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801e7f:	f6 c1 01             	test   $0x1,%cl
  801e82:	74 1c                	je     801ea0 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801e84:	c1 e8 0c             	shr    $0xc,%eax
  801e87:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801e8e:	a8 01                	test   $0x1,%al
  801e90:	74 0e                	je     801ea0 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801e92:	c1 e8 0c             	shr    $0xc,%eax
  801e95:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801e9c:	ef 
  801e9d:	0f b7 d2             	movzwl %dx,%edx
}
  801ea0:	89 d0                	mov    %edx,%eax
  801ea2:	5d                   	pop    %ebp
  801ea3:	c3                   	ret    
  801ea4:	66 90                	xchg   %ax,%ax
  801ea6:	66 90                	xchg   %ax,%ax
  801ea8:	66 90                	xchg   %ax,%ax
  801eaa:	66 90                	xchg   %ax,%ax
  801eac:	66 90                	xchg   %ax,%ax
  801eae:	66 90                	xchg   %ax,%ax

00801eb0 <__udivdi3>:
  801eb0:	f3 0f 1e fb          	endbr32 
  801eb4:	55                   	push   %ebp
  801eb5:	57                   	push   %edi
  801eb6:	56                   	push   %esi
  801eb7:	53                   	push   %ebx
  801eb8:	83 ec 1c             	sub    $0x1c,%esp
  801ebb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801ebf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801ec3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ec7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801ecb:	85 d2                	test   %edx,%edx
  801ecd:	75 19                	jne    801ee8 <__udivdi3+0x38>
  801ecf:	39 f3                	cmp    %esi,%ebx
  801ed1:	76 4d                	jbe    801f20 <__udivdi3+0x70>
  801ed3:	31 ff                	xor    %edi,%edi
  801ed5:	89 e8                	mov    %ebp,%eax
  801ed7:	89 f2                	mov    %esi,%edx
  801ed9:	f7 f3                	div    %ebx
  801edb:	89 fa                	mov    %edi,%edx
  801edd:	83 c4 1c             	add    $0x1c,%esp
  801ee0:	5b                   	pop    %ebx
  801ee1:	5e                   	pop    %esi
  801ee2:	5f                   	pop    %edi
  801ee3:	5d                   	pop    %ebp
  801ee4:	c3                   	ret    
  801ee5:	8d 76 00             	lea    0x0(%esi),%esi
  801ee8:	39 f2                	cmp    %esi,%edx
  801eea:	76 14                	jbe    801f00 <__udivdi3+0x50>
  801eec:	31 ff                	xor    %edi,%edi
  801eee:	31 c0                	xor    %eax,%eax
  801ef0:	89 fa                	mov    %edi,%edx
  801ef2:	83 c4 1c             	add    $0x1c,%esp
  801ef5:	5b                   	pop    %ebx
  801ef6:	5e                   	pop    %esi
  801ef7:	5f                   	pop    %edi
  801ef8:	5d                   	pop    %ebp
  801ef9:	c3                   	ret    
  801efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801f00:	0f bd fa             	bsr    %edx,%edi
  801f03:	83 f7 1f             	xor    $0x1f,%edi
  801f06:	75 48                	jne    801f50 <__udivdi3+0xa0>
  801f08:	39 f2                	cmp    %esi,%edx
  801f0a:	72 06                	jb     801f12 <__udivdi3+0x62>
  801f0c:	31 c0                	xor    %eax,%eax
  801f0e:	39 eb                	cmp    %ebp,%ebx
  801f10:	77 de                	ja     801ef0 <__udivdi3+0x40>
  801f12:	b8 01 00 00 00       	mov    $0x1,%eax
  801f17:	eb d7                	jmp    801ef0 <__udivdi3+0x40>
  801f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f20:	89 d9                	mov    %ebx,%ecx
  801f22:	85 db                	test   %ebx,%ebx
  801f24:	75 0b                	jne    801f31 <__udivdi3+0x81>
  801f26:	b8 01 00 00 00       	mov    $0x1,%eax
  801f2b:	31 d2                	xor    %edx,%edx
  801f2d:	f7 f3                	div    %ebx
  801f2f:	89 c1                	mov    %eax,%ecx
  801f31:	31 d2                	xor    %edx,%edx
  801f33:	89 f0                	mov    %esi,%eax
  801f35:	f7 f1                	div    %ecx
  801f37:	89 c6                	mov    %eax,%esi
  801f39:	89 e8                	mov    %ebp,%eax
  801f3b:	89 f7                	mov    %esi,%edi
  801f3d:	f7 f1                	div    %ecx
  801f3f:	89 fa                	mov    %edi,%edx
  801f41:	83 c4 1c             	add    $0x1c,%esp
  801f44:	5b                   	pop    %ebx
  801f45:	5e                   	pop    %esi
  801f46:	5f                   	pop    %edi
  801f47:	5d                   	pop    %ebp
  801f48:	c3                   	ret    
  801f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f50:	89 f9                	mov    %edi,%ecx
  801f52:	b8 20 00 00 00       	mov    $0x20,%eax
  801f57:	29 f8                	sub    %edi,%eax
  801f59:	d3 e2                	shl    %cl,%edx
  801f5b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f5f:	89 c1                	mov    %eax,%ecx
  801f61:	89 da                	mov    %ebx,%edx
  801f63:	d3 ea                	shr    %cl,%edx
  801f65:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801f69:	09 d1                	or     %edx,%ecx
  801f6b:	89 f2                	mov    %esi,%edx
  801f6d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f71:	89 f9                	mov    %edi,%ecx
  801f73:	d3 e3                	shl    %cl,%ebx
  801f75:	89 c1                	mov    %eax,%ecx
  801f77:	d3 ea                	shr    %cl,%edx
  801f79:	89 f9                	mov    %edi,%ecx
  801f7b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801f7f:	89 eb                	mov    %ebp,%ebx
  801f81:	d3 e6                	shl    %cl,%esi
  801f83:	89 c1                	mov    %eax,%ecx
  801f85:	d3 eb                	shr    %cl,%ebx
  801f87:	09 de                	or     %ebx,%esi
  801f89:	89 f0                	mov    %esi,%eax
  801f8b:	f7 74 24 08          	divl   0x8(%esp)
  801f8f:	89 d6                	mov    %edx,%esi
  801f91:	89 c3                	mov    %eax,%ebx
  801f93:	f7 64 24 0c          	mull   0xc(%esp)
  801f97:	39 d6                	cmp    %edx,%esi
  801f99:	72 15                	jb     801fb0 <__udivdi3+0x100>
  801f9b:	89 f9                	mov    %edi,%ecx
  801f9d:	d3 e5                	shl    %cl,%ebp
  801f9f:	39 c5                	cmp    %eax,%ebp
  801fa1:	73 04                	jae    801fa7 <__udivdi3+0xf7>
  801fa3:	39 d6                	cmp    %edx,%esi
  801fa5:	74 09                	je     801fb0 <__udivdi3+0x100>
  801fa7:	89 d8                	mov    %ebx,%eax
  801fa9:	31 ff                	xor    %edi,%edi
  801fab:	e9 40 ff ff ff       	jmp    801ef0 <__udivdi3+0x40>
  801fb0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801fb3:	31 ff                	xor    %edi,%edi
  801fb5:	e9 36 ff ff ff       	jmp    801ef0 <__udivdi3+0x40>
  801fba:	66 90                	xchg   %ax,%ax
  801fbc:	66 90                	xchg   %ax,%ax
  801fbe:	66 90                	xchg   %ax,%ax

00801fc0 <__umoddi3>:
  801fc0:	f3 0f 1e fb          	endbr32 
  801fc4:	55                   	push   %ebp
  801fc5:	57                   	push   %edi
  801fc6:	56                   	push   %esi
  801fc7:	53                   	push   %ebx
  801fc8:	83 ec 1c             	sub    $0x1c,%esp
  801fcb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801fcf:	8b 74 24 30          	mov    0x30(%esp),%esi
  801fd3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801fd7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801fdb:	85 c0                	test   %eax,%eax
  801fdd:	75 19                	jne    801ff8 <__umoddi3+0x38>
  801fdf:	39 df                	cmp    %ebx,%edi
  801fe1:	76 5d                	jbe    802040 <__umoddi3+0x80>
  801fe3:	89 f0                	mov    %esi,%eax
  801fe5:	89 da                	mov    %ebx,%edx
  801fe7:	f7 f7                	div    %edi
  801fe9:	89 d0                	mov    %edx,%eax
  801feb:	31 d2                	xor    %edx,%edx
  801fed:	83 c4 1c             	add    $0x1c,%esp
  801ff0:	5b                   	pop    %ebx
  801ff1:	5e                   	pop    %esi
  801ff2:	5f                   	pop    %edi
  801ff3:	5d                   	pop    %ebp
  801ff4:	c3                   	ret    
  801ff5:	8d 76 00             	lea    0x0(%esi),%esi
  801ff8:	89 f2                	mov    %esi,%edx
  801ffa:	39 d8                	cmp    %ebx,%eax
  801ffc:	76 12                	jbe    802010 <__umoddi3+0x50>
  801ffe:	89 f0                	mov    %esi,%eax
  802000:	89 da                	mov    %ebx,%edx
  802002:	83 c4 1c             	add    $0x1c,%esp
  802005:	5b                   	pop    %ebx
  802006:	5e                   	pop    %esi
  802007:	5f                   	pop    %edi
  802008:	5d                   	pop    %ebp
  802009:	c3                   	ret    
  80200a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802010:	0f bd e8             	bsr    %eax,%ebp
  802013:	83 f5 1f             	xor    $0x1f,%ebp
  802016:	75 50                	jne    802068 <__umoddi3+0xa8>
  802018:	39 d8                	cmp    %ebx,%eax
  80201a:	0f 82 e0 00 00 00    	jb     802100 <__umoddi3+0x140>
  802020:	89 d9                	mov    %ebx,%ecx
  802022:	39 f7                	cmp    %esi,%edi
  802024:	0f 86 d6 00 00 00    	jbe    802100 <__umoddi3+0x140>
  80202a:	89 d0                	mov    %edx,%eax
  80202c:	89 ca                	mov    %ecx,%edx
  80202e:	83 c4 1c             	add    $0x1c,%esp
  802031:	5b                   	pop    %ebx
  802032:	5e                   	pop    %esi
  802033:	5f                   	pop    %edi
  802034:	5d                   	pop    %ebp
  802035:	c3                   	ret    
  802036:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80203d:	8d 76 00             	lea    0x0(%esi),%esi
  802040:	89 fd                	mov    %edi,%ebp
  802042:	85 ff                	test   %edi,%edi
  802044:	75 0b                	jne    802051 <__umoddi3+0x91>
  802046:	b8 01 00 00 00       	mov    $0x1,%eax
  80204b:	31 d2                	xor    %edx,%edx
  80204d:	f7 f7                	div    %edi
  80204f:	89 c5                	mov    %eax,%ebp
  802051:	89 d8                	mov    %ebx,%eax
  802053:	31 d2                	xor    %edx,%edx
  802055:	f7 f5                	div    %ebp
  802057:	89 f0                	mov    %esi,%eax
  802059:	f7 f5                	div    %ebp
  80205b:	89 d0                	mov    %edx,%eax
  80205d:	31 d2                	xor    %edx,%edx
  80205f:	eb 8c                	jmp    801fed <__umoddi3+0x2d>
  802061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802068:	89 e9                	mov    %ebp,%ecx
  80206a:	ba 20 00 00 00       	mov    $0x20,%edx
  80206f:	29 ea                	sub    %ebp,%edx
  802071:	d3 e0                	shl    %cl,%eax
  802073:	89 44 24 08          	mov    %eax,0x8(%esp)
  802077:	89 d1                	mov    %edx,%ecx
  802079:	89 f8                	mov    %edi,%eax
  80207b:	d3 e8                	shr    %cl,%eax
  80207d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802081:	89 54 24 04          	mov    %edx,0x4(%esp)
  802085:	8b 54 24 04          	mov    0x4(%esp),%edx
  802089:	09 c1                	or     %eax,%ecx
  80208b:	89 d8                	mov    %ebx,%eax
  80208d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802091:	89 e9                	mov    %ebp,%ecx
  802093:	d3 e7                	shl    %cl,%edi
  802095:	89 d1                	mov    %edx,%ecx
  802097:	d3 e8                	shr    %cl,%eax
  802099:	89 e9                	mov    %ebp,%ecx
  80209b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80209f:	d3 e3                	shl    %cl,%ebx
  8020a1:	89 c7                	mov    %eax,%edi
  8020a3:	89 d1                	mov    %edx,%ecx
  8020a5:	89 f0                	mov    %esi,%eax
  8020a7:	d3 e8                	shr    %cl,%eax
  8020a9:	89 e9                	mov    %ebp,%ecx
  8020ab:	89 fa                	mov    %edi,%edx
  8020ad:	d3 e6                	shl    %cl,%esi
  8020af:	09 d8                	or     %ebx,%eax
  8020b1:	f7 74 24 08          	divl   0x8(%esp)
  8020b5:	89 d1                	mov    %edx,%ecx
  8020b7:	89 f3                	mov    %esi,%ebx
  8020b9:	f7 64 24 0c          	mull   0xc(%esp)
  8020bd:	89 c6                	mov    %eax,%esi
  8020bf:	89 d7                	mov    %edx,%edi
  8020c1:	39 d1                	cmp    %edx,%ecx
  8020c3:	72 06                	jb     8020cb <__umoddi3+0x10b>
  8020c5:	75 10                	jne    8020d7 <__umoddi3+0x117>
  8020c7:	39 c3                	cmp    %eax,%ebx
  8020c9:	73 0c                	jae    8020d7 <__umoddi3+0x117>
  8020cb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8020cf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8020d3:	89 d7                	mov    %edx,%edi
  8020d5:	89 c6                	mov    %eax,%esi
  8020d7:	89 ca                	mov    %ecx,%edx
  8020d9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8020de:	29 f3                	sub    %esi,%ebx
  8020e0:	19 fa                	sbb    %edi,%edx
  8020e2:	89 d0                	mov    %edx,%eax
  8020e4:	d3 e0                	shl    %cl,%eax
  8020e6:	89 e9                	mov    %ebp,%ecx
  8020e8:	d3 eb                	shr    %cl,%ebx
  8020ea:	d3 ea                	shr    %cl,%edx
  8020ec:	09 d8                	or     %ebx,%eax
  8020ee:	83 c4 1c             	add    $0x1c,%esp
  8020f1:	5b                   	pop    %ebx
  8020f2:	5e                   	pop    %esi
  8020f3:	5f                   	pop    %edi
  8020f4:	5d                   	pop    %ebp
  8020f5:	c3                   	ret    
  8020f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8020fd:	8d 76 00             	lea    0x0(%esi),%esi
  802100:	29 fe                	sub    %edi,%esi
  802102:	19 c3                	sbb    %eax,%ebx
  802104:	89 f2                	mov    %esi,%edx
  802106:	89 d9                	mov    %ebx,%ecx
  802108:	e9 1d ff ff ff       	jmp    80202a <__umoddi3+0x6a>
