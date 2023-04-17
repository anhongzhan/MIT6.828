
obj/user/primes.debug:     file format elf32-i386


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
  80002c:	e8 cd 00 00 00       	call   8000fe <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	57                   	push   %edi
  80003b:	56                   	push   %esi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 1c             	sub    $0x1c,%esp
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  800040:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  800043:	83 ec 04             	sub    $0x4,%esp
  800046:	6a 00                	push   $0x0
  800048:	6a 00                	push   $0x0
  80004a:	56                   	push   %esi
  80004b:	e8 53 11 00 00       	call   8011a3 <ipc_recv>
  800050:	89 c3                	mov    %eax,%ebx
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  800052:	a1 04 40 80 00       	mov    0x804004,%eax
  800057:	8b 40 5c             	mov    0x5c(%eax),%eax
  80005a:	83 c4 0c             	add    $0xc,%esp
  80005d:	53                   	push   %ebx
  80005e:	50                   	push   %eax
  80005f:	68 40 23 80 00       	push   $0x802340
  800064:	e8 e4 01 00 00       	call   80024d <cprintf>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  800069:	e8 1c 0f 00 00       	call   800f8a <fork>
  80006e:	89 c7                	mov    %eax,%edi
  800070:	83 c4 10             	add    $0x10,%esp
  800073:	85 c0                	test   %eax,%eax
  800075:	78 07                	js     80007e <primeproc+0x4b>
		panic("fork: %e", id);
	if (id == 0)
  800077:	74 ca                	je     800043 <primeproc+0x10>
		goto top;

	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  800079:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80007c:	eb 20                	jmp    80009e <primeproc+0x6b>
		panic("fork: %e", id);
  80007e:	50                   	push   %eax
  80007f:	68 e5 26 80 00       	push   $0x8026e5
  800084:	6a 1a                	push   $0x1a
  800086:	68 4c 23 80 00       	push   $0x80234c
  80008b:	e8 d6 00 00 00       	call   800166 <_panic>
		if (i % p)
			ipc_send(id, i, 0, 0);
  800090:	6a 00                	push   $0x0
  800092:	6a 00                	push   $0x0
  800094:	51                   	push   %ecx
  800095:	57                   	push   %edi
  800096:	e8 8d 11 00 00       	call   801228 <ipc_send>
  80009b:	83 c4 10             	add    $0x10,%esp
		i = ipc_recv(&envid, 0, 0);
  80009e:	83 ec 04             	sub    $0x4,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	6a 00                	push   $0x0
  8000a5:	56                   	push   %esi
  8000a6:	e8 f8 10 00 00       	call   8011a3 <ipc_recv>
  8000ab:	89 c1                	mov    %eax,%ecx
		if (i % p)
  8000ad:	99                   	cltd   
  8000ae:	f7 fb                	idiv   %ebx
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	85 d2                	test   %edx,%edx
  8000b5:	74 e7                	je     80009e <primeproc+0x6b>
  8000b7:	eb d7                	jmp    800090 <primeproc+0x5d>

008000b9 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  8000b9:	f3 0f 1e fb          	endbr32 
  8000bd:	55                   	push   %ebp
  8000be:	89 e5                	mov    %esp,%ebp
  8000c0:	56                   	push   %esi
  8000c1:	53                   	push   %ebx
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  8000c2:	e8 c3 0e 00 00       	call   800f8a <fork>
  8000c7:	89 c6                	mov    %eax,%esi
  8000c9:	85 c0                	test   %eax,%eax
  8000cb:	78 1a                	js     8000e7 <umain+0x2e>
		panic("fork: %e", id);
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
  8000cd:	bb 02 00 00 00       	mov    $0x2,%ebx
	if (id == 0)
  8000d2:	74 25                	je     8000f9 <umain+0x40>
		ipc_send(id, i, 0, 0);
  8000d4:	6a 00                	push   $0x0
  8000d6:	6a 00                	push   $0x0
  8000d8:	53                   	push   %ebx
  8000d9:	56                   	push   %esi
  8000da:	e8 49 11 00 00       	call   801228 <ipc_send>
	for (i = 2; ; i++)
  8000df:	83 c3 01             	add    $0x1,%ebx
  8000e2:	83 c4 10             	add    $0x10,%esp
  8000e5:	eb ed                	jmp    8000d4 <umain+0x1b>
		panic("fork: %e", id);
  8000e7:	50                   	push   %eax
  8000e8:	68 e5 26 80 00       	push   $0x8026e5
  8000ed:	6a 2d                	push   $0x2d
  8000ef:	68 4c 23 80 00       	push   $0x80234c
  8000f4:	e8 6d 00 00 00       	call   800166 <_panic>
		primeproc();
  8000f9:	e8 35 ff ff ff       	call   800033 <primeproc>

008000fe <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000fe:	f3 0f 1e fb          	endbr32 
  800102:	55                   	push   %ebp
  800103:	89 e5                	mov    %esp,%ebp
  800105:	56                   	push   %esi
  800106:	53                   	push   %ebx
  800107:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80010a:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80010d:	e8 41 0b 00 00       	call   800c53 <sys_getenvid>
  800112:	25 ff 03 00 00       	and    $0x3ff,%eax
  800117:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80011a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80011f:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800124:	85 db                	test   %ebx,%ebx
  800126:	7e 07                	jle    80012f <libmain+0x31>
		binaryname = argv[0];
  800128:	8b 06                	mov    (%esi),%eax
  80012a:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80012f:	83 ec 08             	sub    $0x8,%esp
  800132:	56                   	push   %esi
  800133:	53                   	push   %ebx
  800134:	e8 80 ff ff ff       	call   8000b9 <umain>

	// exit gracefully
	exit();
  800139:	e8 0a 00 00 00       	call   800148 <exit>
}
  80013e:	83 c4 10             	add    $0x10,%esp
  800141:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800144:	5b                   	pop    %ebx
  800145:	5e                   	pop    %esi
  800146:	5d                   	pop    %ebp
  800147:	c3                   	ret    

00800148 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800148:	f3 0f 1e fb          	endbr32 
  80014c:	55                   	push   %ebp
  80014d:	89 e5                	mov    %esp,%ebp
  80014f:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800152:	e8 55 13 00 00       	call   8014ac <close_all>
	sys_env_destroy(0);
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	6a 00                	push   $0x0
  80015c:	e8 ad 0a 00 00       	call   800c0e <sys_env_destroy>
}
  800161:	83 c4 10             	add    $0x10,%esp
  800164:	c9                   	leave  
  800165:	c3                   	ret    

00800166 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800166:	f3 0f 1e fb          	endbr32 
  80016a:	55                   	push   %ebp
  80016b:	89 e5                	mov    %esp,%ebp
  80016d:	56                   	push   %esi
  80016e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80016f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800172:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800178:	e8 d6 0a 00 00       	call   800c53 <sys_getenvid>
  80017d:	83 ec 0c             	sub    $0xc,%esp
  800180:	ff 75 0c             	pushl  0xc(%ebp)
  800183:	ff 75 08             	pushl  0x8(%ebp)
  800186:	56                   	push   %esi
  800187:	50                   	push   %eax
  800188:	68 64 23 80 00       	push   $0x802364
  80018d:	e8 bb 00 00 00       	call   80024d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800192:	83 c4 18             	add    $0x18,%esp
  800195:	53                   	push   %ebx
  800196:	ff 75 10             	pushl  0x10(%ebp)
  800199:	e8 5a 00 00 00       	call   8001f8 <vcprintf>
	cprintf("\n");
  80019e:	c7 04 24 54 27 80 00 	movl   $0x802754,(%esp)
  8001a5:	e8 a3 00 00 00       	call   80024d <cprintf>
  8001aa:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001ad:	cc                   	int3   
  8001ae:	eb fd                	jmp    8001ad <_panic+0x47>

008001b0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001b0:	f3 0f 1e fb          	endbr32 
  8001b4:	55                   	push   %ebp
  8001b5:	89 e5                	mov    %esp,%ebp
  8001b7:	53                   	push   %ebx
  8001b8:	83 ec 04             	sub    $0x4,%esp
  8001bb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001be:	8b 13                	mov    (%ebx),%edx
  8001c0:	8d 42 01             	lea    0x1(%edx),%eax
  8001c3:	89 03                	mov    %eax,(%ebx)
  8001c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001c8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001cc:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001d1:	74 09                	je     8001dc <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001d3:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001da:	c9                   	leave  
  8001db:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001dc:	83 ec 08             	sub    $0x8,%esp
  8001df:	68 ff 00 00 00       	push   $0xff
  8001e4:	8d 43 08             	lea    0x8(%ebx),%eax
  8001e7:	50                   	push   %eax
  8001e8:	e8 dc 09 00 00       	call   800bc9 <sys_cputs>
		b->idx = 0;
  8001ed:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001f3:	83 c4 10             	add    $0x10,%esp
  8001f6:	eb db                	jmp    8001d3 <putch+0x23>

008001f8 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001f8:	f3 0f 1e fb          	endbr32 
  8001fc:	55                   	push   %ebp
  8001fd:	89 e5                	mov    %esp,%ebp
  8001ff:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800205:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80020c:	00 00 00 
	b.cnt = 0;
  80020f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800216:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800219:	ff 75 0c             	pushl  0xc(%ebp)
  80021c:	ff 75 08             	pushl  0x8(%ebp)
  80021f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800225:	50                   	push   %eax
  800226:	68 b0 01 80 00       	push   $0x8001b0
  80022b:	e8 20 01 00 00       	call   800350 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800230:	83 c4 08             	add    $0x8,%esp
  800233:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800239:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80023f:	50                   	push   %eax
  800240:	e8 84 09 00 00       	call   800bc9 <sys_cputs>

	return b.cnt;
}
  800245:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80024b:	c9                   	leave  
  80024c:	c3                   	ret    

0080024d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80024d:	f3 0f 1e fb          	endbr32 
  800251:	55                   	push   %ebp
  800252:	89 e5                	mov    %esp,%ebp
  800254:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800257:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80025a:	50                   	push   %eax
  80025b:	ff 75 08             	pushl  0x8(%ebp)
  80025e:	e8 95 ff ff ff       	call   8001f8 <vcprintf>
	va_end(ap);

	return cnt;
}
  800263:	c9                   	leave  
  800264:	c3                   	ret    

00800265 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800265:	55                   	push   %ebp
  800266:	89 e5                	mov    %esp,%ebp
  800268:	57                   	push   %edi
  800269:	56                   	push   %esi
  80026a:	53                   	push   %ebx
  80026b:	83 ec 1c             	sub    $0x1c,%esp
  80026e:	89 c7                	mov    %eax,%edi
  800270:	89 d6                	mov    %edx,%esi
  800272:	8b 45 08             	mov    0x8(%ebp),%eax
  800275:	8b 55 0c             	mov    0xc(%ebp),%edx
  800278:	89 d1                	mov    %edx,%ecx
  80027a:	89 c2                	mov    %eax,%edx
  80027c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80027f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800282:	8b 45 10             	mov    0x10(%ebp),%eax
  800285:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800288:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80028b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800292:	39 c2                	cmp    %eax,%edx
  800294:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800297:	72 3e                	jb     8002d7 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	ff 75 18             	pushl  0x18(%ebp)
  80029f:	83 eb 01             	sub    $0x1,%ebx
  8002a2:	53                   	push   %ebx
  8002a3:	50                   	push   %eax
  8002a4:	83 ec 08             	sub    $0x8,%esp
  8002a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002aa:	ff 75 e0             	pushl  -0x20(%ebp)
  8002ad:	ff 75 dc             	pushl  -0x24(%ebp)
  8002b0:	ff 75 d8             	pushl  -0x28(%ebp)
  8002b3:	e8 28 1e 00 00       	call   8020e0 <__udivdi3>
  8002b8:	83 c4 18             	add    $0x18,%esp
  8002bb:	52                   	push   %edx
  8002bc:	50                   	push   %eax
  8002bd:	89 f2                	mov    %esi,%edx
  8002bf:	89 f8                	mov    %edi,%eax
  8002c1:	e8 9f ff ff ff       	call   800265 <printnum>
  8002c6:	83 c4 20             	add    $0x20,%esp
  8002c9:	eb 13                	jmp    8002de <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002cb:	83 ec 08             	sub    $0x8,%esp
  8002ce:	56                   	push   %esi
  8002cf:	ff 75 18             	pushl  0x18(%ebp)
  8002d2:	ff d7                	call   *%edi
  8002d4:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002d7:	83 eb 01             	sub    $0x1,%ebx
  8002da:	85 db                	test   %ebx,%ebx
  8002dc:	7f ed                	jg     8002cb <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002de:	83 ec 08             	sub    $0x8,%esp
  8002e1:	56                   	push   %esi
  8002e2:	83 ec 04             	sub    $0x4,%esp
  8002e5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e8:	ff 75 e0             	pushl  -0x20(%ebp)
  8002eb:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ee:	ff 75 d8             	pushl  -0x28(%ebp)
  8002f1:	e8 fa 1e 00 00       	call   8021f0 <__umoddi3>
  8002f6:	83 c4 14             	add    $0x14,%esp
  8002f9:	0f be 80 87 23 80 00 	movsbl 0x802387(%eax),%eax
  800300:	50                   	push   %eax
  800301:	ff d7                	call   *%edi
}
  800303:	83 c4 10             	add    $0x10,%esp
  800306:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800309:	5b                   	pop    %ebx
  80030a:	5e                   	pop    %esi
  80030b:	5f                   	pop    %edi
  80030c:	5d                   	pop    %ebp
  80030d:	c3                   	ret    

0080030e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80030e:	f3 0f 1e fb          	endbr32 
  800312:	55                   	push   %ebp
  800313:	89 e5                	mov    %esp,%ebp
  800315:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800318:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80031c:	8b 10                	mov    (%eax),%edx
  80031e:	3b 50 04             	cmp    0x4(%eax),%edx
  800321:	73 0a                	jae    80032d <sprintputch+0x1f>
		*b->buf++ = ch;
  800323:	8d 4a 01             	lea    0x1(%edx),%ecx
  800326:	89 08                	mov    %ecx,(%eax)
  800328:	8b 45 08             	mov    0x8(%ebp),%eax
  80032b:	88 02                	mov    %al,(%edx)
}
  80032d:	5d                   	pop    %ebp
  80032e:	c3                   	ret    

0080032f <printfmt>:
{
  80032f:	f3 0f 1e fb          	endbr32 
  800333:	55                   	push   %ebp
  800334:	89 e5                	mov    %esp,%ebp
  800336:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800339:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80033c:	50                   	push   %eax
  80033d:	ff 75 10             	pushl  0x10(%ebp)
  800340:	ff 75 0c             	pushl  0xc(%ebp)
  800343:	ff 75 08             	pushl  0x8(%ebp)
  800346:	e8 05 00 00 00       	call   800350 <vprintfmt>
}
  80034b:	83 c4 10             	add    $0x10,%esp
  80034e:	c9                   	leave  
  80034f:	c3                   	ret    

00800350 <vprintfmt>:
{
  800350:	f3 0f 1e fb          	endbr32 
  800354:	55                   	push   %ebp
  800355:	89 e5                	mov    %esp,%ebp
  800357:	57                   	push   %edi
  800358:	56                   	push   %esi
  800359:	53                   	push   %ebx
  80035a:	83 ec 3c             	sub    $0x3c,%esp
  80035d:	8b 75 08             	mov    0x8(%ebp),%esi
  800360:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800363:	8b 7d 10             	mov    0x10(%ebp),%edi
  800366:	e9 8e 03 00 00       	jmp    8006f9 <vprintfmt+0x3a9>
		padc = ' ';
  80036b:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80036f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800376:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80037d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800384:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800389:	8d 47 01             	lea    0x1(%edi),%eax
  80038c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80038f:	0f b6 17             	movzbl (%edi),%edx
  800392:	8d 42 dd             	lea    -0x23(%edx),%eax
  800395:	3c 55                	cmp    $0x55,%al
  800397:	0f 87 df 03 00 00    	ja     80077c <vprintfmt+0x42c>
  80039d:	0f b6 c0             	movzbl %al,%eax
  8003a0:	3e ff 24 85 c0 24 80 	notrack jmp *0x8024c0(,%eax,4)
  8003a7:	00 
  8003a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003ab:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8003af:	eb d8                	jmp    800389 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003b1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003b4:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8003b8:	eb cf                	jmp    800389 <vprintfmt+0x39>
  8003ba:	0f b6 d2             	movzbl %dl,%edx
  8003bd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003c8:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003cb:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003cf:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003d2:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003d5:	83 f9 09             	cmp    $0x9,%ecx
  8003d8:	77 55                	ja     80042f <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8003da:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003dd:	eb e9                	jmp    8003c8 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8003df:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e2:	8b 00                	mov    (%eax),%eax
  8003e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ea:	8d 40 04             	lea    0x4(%eax),%eax
  8003ed:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003f7:	79 90                	jns    800389 <vprintfmt+0x39>
				width = precision, precision = -1;
  8003f9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003ff:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800406:	eb 81                	jmp    800389 <vprintfmt+0x39>
  800408:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80040b:	85 c0                	test   %eax,%eax
  80040d:	ba 00 00 00 00       	mov    $0x0,%edx
  800412:	0f 49 d0             	cmovns %eax,%edx
  800415:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800418:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80041b:	e9 69 ff ff ff       	jmp    800389 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800420:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800423:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80042a:	e9 5a ff ff ff       	jmp    800389 <vprintfmt+0x39>
  80042f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800432:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800435:	eb bc                	jmp    8003f3 <vprintfmt+0xa3>
			lflag++;
  800437:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80043a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80043d:	e9 47 ff ff ff       	jmp    800389 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800442:	8b 45 14             	mov    0x14(%ebp),%eax
  800445:	8d 78 04             	lea    0x4(%eax),%edi
  800448:	83 ec 08             	sub    $0x8,%esp
  80044b:	53                   	push   %ebx
  80044c:	ff 30                	pushl  (%eax)
  80044e:	ff d6                	call   *%esi
			break;
  800450:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800453:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800456:	e9 9b 02 00 00       	jmp    8006f6 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80045b:	8b 45 14             	mov    0x14(%ebp),%eax
  80045e:	8d 78 04             	lea    0x4(%eax),%edi
  800461:	8b 00                	mov    (%eax),%eax
  800463:	99                   	cltd   
  800464:	31 d0                	xor    %edx,%eax
  800466:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800468:	83 f8 0f             	cmp    $0xf,%eax
  80046b:	7f 23                	jg     800490 <vprintfmt+0x140>
  80046d:	8b 14 85 20 26 80 00 	mov    0x802620(,%eax,4),%edx
  800474:	85 d2                	test   %edx,%edx
  800476:	74 18                	je     800490 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800478:	52                   	push   %edx
  800479:	68 05 28 80 00       	push   $0x802805
  80047e:	53                   	push   %ebx
  80047f:	56                   	push   %esi
  800480:	e8 aa fe ff ff       	call   80032f <printfmt>
  800485:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800488:	89 7d 14             	mov    %edi,0x14(%ebp)
  80048b:	e9 66 02 00 00       	jmp    8006f6 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800490:	50                   	push   %eax
  800491:	68 9f 23 80 00       	push   $0x80239f
  800496:	53                   	push   %ebx
  800497:	56                   	push   %esi
  800498:	e8 92 fe ff ff       	call   80032f <printfmt>
  80049d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004a0:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004a3:	e9 4e 02 00 00       	jmp    8006f6 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8004a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ab:	83 c0 04             	add    $0x4,%eax
  8004ae:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8004b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b4:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8004b6:	85 d2                	test   %edx,%edx
  8004b8:	b8 98 23 80 00       	mov    $0x802398,%eax
  8004bd:	0f 45 c2             	cmovne %edx,%eax
  8004c0:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004c3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004c7:	7e 06                	jle    8004cf <vprintfmt+0x17f>
  8004c9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004cd:	75 0d                	jne    8004dc <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004cf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004d2:	89 c7                	mov    %eax,%edi
  8004d4:	03 45 e0             	add    -0x20(%ebp),%eax
  8004d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004da:	eb 55                	jmp    800531 <vprintfmt+0x1e1>
  8004dc:	83 ec 08             	sub    $0x8,%esp
  8004df:	ff 75 d8             	pushl  -0x28(%ebp)
  8004e2:	ff 75 cc             	pushl  -0x34(%ebp)
  8004e5:	e8 46 03 00 00       	call   800830 <strnlen>
  8004ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004ed:	29 c2                	sub    %eax,%edx
  8004ef:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004f2:	83 c4 10             	add    $0x10,%esp
  8004f5:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004f7:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004fe:	85 ff                	test   %edi,%edi
  800500:	7e 11                	jle    800513 <vprintfmt+0x1c3>
					putch(padc, putdat);
  800502:	83 ec 08             	sub    $0x8,%esp
  800505:	53                   	push   %ebx
  800506:	ff 75 e0             	pushl  -0x20(%ebp)
  800509:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80050b:	83 ef 01             	sub    $0x1,%edi
  80050e:	83 c4 10             	add    $0x10,%esp
  800511:	eb eb                	jmp    8004fe <vprintfmt+0x1ae>
  800513:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800516:	85 d2                	test   %edx,%edx
  800518:	b8 00 00 00 00       	mov    $0x0,%eax
  80051d:	0f 49 c2             	cmovns %edx,%eax
  800520:	29 c2                	sub    %eax,%edx
  800522:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800525:	eb a8                	jmp    8004cf <vprintfmt+0x17f>
					putch(ch, putdat);
  800527:	83 ec 08             	sub    $0x8,%esp
  80052a:	53                   	push   %ebx
  80052b:	52                   	push   %edx
  80052c:	ff d6                	call   *%esi
  80052e:	83 c4 10             	add    $0x10,%esp
  800531:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800534:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800536:	83 c7 01             	add    $0x1,%edi
  800539:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80053d:	0f be d0             	movsbl %al,%edx
  800540:	85 d2                	test   %edx,%edx
  800542:	74 4b                	je     80058f <vprintfmt+0x23f>
  800544:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800548:	78 06                	js     800550 <vprintfmt+0x200>
  80054a:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80054e:	78 1e                	js     80056e <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800550:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800554:	74 d1                	je     800527 <vprintfmt+0x1d7>
  800556:	0f be c0             	movsbl %al,%eax
  800559:	83 e8 20             	sub    $0x20,%eax
  80055c:	83 f8 5e             	cmp    $0x5e,%eax
  80055f:	76 c6                	jbe    800527 <vprintfmt+0x1d7>
					putch('?', putdat);
  800561:	83 ec 08             	sub    $0x8,%esp
  800564:	53                   	push   %ebx
  800565:	6a 3f                	push   $0x3f
  800567:	ff d6                	call   *%esi
  800569:	83 c4 10             	add    $0x10,%esp
  80056c:	eb c3                	jmp    800531 <vprintfmt+0x1e1>
  80056e:	89 cf                	mov    %ecx,%edi
  800570:	eb 0e                	jmp    800580 <vprintfmt+0x230>
				putch(' ', putdat);
  800572:	83 ec 08             	sub    $0x8,%esp
  800575:	53                   	push   %ebx
  800576:	6a 20                	push   $0x20
  800578:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80057a:	83 ef 01             	sub    $0x1,%edi
  80057d:	83 c4 10             	add    $0x10,%esp
  800580:	85 ff                	test   %edi,%edi
  800582:	7f ee                	jg     800572 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800584:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800587:	89 45 14             	mov    %eax,0x14(%ebp)
  80058a:	e9 67 01 00 00       	jmp    8006f6 <vprintfmt+0x3a6>
  80058f:	89 cf                	mov    %ecx,%edi
  800591:	eb ed                	jmp    800580 <vprintfmt+0x230>
	if (lflag >= 2)
  800593:	83 f9 01             	cmp    $0x1,%ecx
  800596:	7f 1b                	jg     8005b3 <vprintfmt+0x263>
	else if (lflag)
  800598:	85 c9                	test   %ecx,%ecx
  80059a:	74 63                	je     8005ff <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	8b 00                	mov    (%eax),%eax
  8005a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a4:	99                   	cltd   
  8005a5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ab:	8d 40 04             	lea    0x4(%eax),%eax
  8005ae:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b1:	eb 17                	jmp    8005ca <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  8005b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b6:	8b 50 04             	mov    0x4(%eax),%edx
  8005b9:	8b 00                	mov    (%eax),%eax
  8005bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005be:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c4:	8d 40 08             	lea    0x8(%eax),%eax
  8005c7:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005ca:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005cd:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005d0:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8005d5:	85 c9                	test   %ecx,%ecx
  8005d7:	0f 89 ff 00 00 00    	jns    8006dc <vprintfmt+0x38c>
				putch('-', putdat);
  8005dd:	83 ec 08             	sub    $0x8,%esp
  8005e0:	53                   	push   %ebx
  8005e1:	6a 2d                	push   $0x2d
  8005e3:	ff d6                	call   *%esi
				num = -(long long) num;
  8005e5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005e8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005eb:	f7 da                	neg    %edx
  8005ed:	83 d1 00             	adc    $0x0,%ecx
  8005f0:	f7 d9                	neg    %ecx
  8005f2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005f5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005fa:	e9 dd 00 00 00       	jmp    8006dc <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8005ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800602:	8b 00                	mov    (%eax),%eax
  800604:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800607:	99                   	cltd   
  800608:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80060b:	8b 45 14             	mov    0x14(%ebp),%eax
  80060e:	8d 40 04             	lea    0x4(%eax),%eax
  800611:	89 45 14             	mov    %eax,0x14(%ebp)
  800614:	eb b4                	jmp    8005ca <vprintfmt+0x27a>
	if (lflag >= 2)
  800616:	83 f9 01             	cmp    $0x1,%ecx
  800619:	7f 1e                	jg     800639 <vprintfmt+0x2e9>
	else if (lflag)
  80061b:	85 c9                	test   %ecx,%ecx
  80061d:	74 32                	je     800651 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  80061f:	8b 45 14             	mov    0x14(%ebp),%eax
  800622:	8b 10                	mov    (%eax),%edx
  800624:	b9 00 00 00 00       	mov    $0x0,%ecx
  800629:	8d 40 04             	lea    0x4(%eax),%eax
  80062c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80062f:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800634:	e9 a3 00 00 00       	jmp    8006dc <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	8b 10                	mov    (%eax),%edx
  80063e:	8b 48 04             	mov    0x4(%eax),%ecx
  800641:	8d 40 08             	lea    0x8(%eax),%eax
  800644:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800647:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80064c:	e9 8b 00 00 00       	jmp    8006dc <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800651:	8b 45 14             	mov    0x14(%ebp),%eax
  800654:	8b 10                	mov    (%eax),%edx
  800656:	b9 00 00 00 00       	mov    $0x0,%ecx
  80065b:	8d 40 04             	lea    0x4(%eax),%eax
  80065e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800661:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800666:	eb 74                	jmp    8006dc <vprintfmt+0x38c>
	if (lflag >= 2)
  800668:	83 f9 01             	cmp    $0x1,%ecx
  80066b:	7f 1b                	jg     800688 <vprintfmt+0x338>
	else if (lflag)
  80066d:	85 c9                	test   %ecx,%ecx
  80066f:	74 2c                	je     80069d <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800671:	8b 45 14             	mov    0x14(%ebp),%eax
  800674:	8b 10                	mov    (%eax),%edx
  800676:	b9 00 00 00 00       	mov    $0x0,%ecx
  80067b:	8d 40 04             	lea    0x4(%eax),%eax
  80067e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800681:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800686:	eb 54                	jmp    8006dc <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	8b 10                	mov    (%eax),%edx
  80068d:	8b 48 04             	mov    0x4(%eax),%ecx
  800690:	8d 40 08             	lea    0x8(%eax),%eax
  800693:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800696:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80069b:	eb 3f                	jmp    8006dc <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80069d:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a0:	8b 10                	mov    (%eax),%edx
  8006a2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006a7:	8d 40 04             	lea    0x4(%eax),%eax
  8006aa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006ad:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  8006b2:	eb 28                	jmp    8006dc <vprintfmt+0x38c>
			putch('0', putdat);
  8006b4:	83 ec 08             	sub    $0x8,%esp
  8006b7:	53                   	push   %ebx
  8006b8:	6a 30                	push   $0x30
  8006ba:	ff d6                	call   *%esi
			putch('x', putdat);
  8006bc:	83 c4 08             	add    $0x8,%esp
  8006bf:	53                   	push   %ebx
  8006c0:	6a 78                	push   $0x78
  8006c2:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c7:	8b 10                	mov    (%eax),%edx
  8006c9:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006ce:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006d1:	8d 40 04             	lea    0x4(%eax),%eax
  8006d4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006d7:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006dc:	83 ec 0c             	sub    $0xc,%esp
  8006df:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8006e3:	57                   	push   %edi
  8006e4:	ff 75 e0             	pushl  -0x20(%ebp)
  8006e7:	50                   	push   %eax
  8006e8:	51                   	push   %ecx
  8006e9:	52                   	push   %edx
  8006ea:	89 da                	mov    %ebx,%edx
  8006ec:	89 f0                	mov    %esi,%eax
  8006ee:	e8 72 fb ff ff       	call   800265 <printnum>
			break;
  8006f3:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006f9:	83 c7 01             	add    $0x1,%edi
  8006fc:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800700:	83 f8 25             	cmp    $0x25,%eax
  800703:	0f 84 62 fc ff ff    	je     80036b <vprintfmt+0x1b>
			if (ch == '\0')
  800709:	85 c0                	test   %eax,%eax
  80070b:	0f 84 8b 00 00 00    	je     80079c <vprintfmt+0x44c>
			putch(ch, putdat);
  800711:	83 ec 08             	sub    $0x8,%esp
  800714:	53                   	push   %ebx
  800715:	50                   	push   %eax
  800716:	ff d6                	call   *%esi
  800718:	83 c4 10             	add    $0x10,%esp
  80071b:	eb dc                	jmp    8006f9 <vprintfmt+0x3a9>
	if (lflag >= 2)
  80071d:	83 f9 01             	cmp    $0x1,%ecx
  800720:	7f 1b                	jg     80073d <vprintfmt+0x3ed>
	else if (lflag)
  800722:	85 c9                	test   %ecx,%ecx
  800724:	74 2c                	je     800752 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800726:	8b 45 14             	mov    0x14(%ebp),%eax
  800729:	8b 10                	mov    (%eax),%edx
  80072b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800730:	8d 40 04             	lea    0x4(%eax),%eax
  800733:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800736:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80073b:	eb 9f                	jmp    8006dc <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80073d:	8b 45 14             	mov    0x14(%ebp),%eax
  800740:	8b 10                	mov    (%eax),%edx
  800742:	8b 48 04             	mov    0x4(%eax),%ecx
  800745:	8d 40 08             	lea    0x8(%eax),%eax
  800748:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80074b:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800750:	eb 8a                	jmp    8006dc <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800752:	8b 45 14             	mov    0x14(%ebp),%eax
  800755:	8b 10                	mov    (%eax),%edx
  800757:	b9 00 00 00 00       	mov    $0x0,%ecx
  80075c:	8d 40 04             	lea    0x4(%eax),%eax
  80075f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800762:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800767:	e9 70 ff ff ff       	jmp    8006dc <vprintfmt+0x38c>
			putch(ch, putdat);
  80076c:	83 ec 08             	sub    $0x8,%esp
  80076f:	53                   	push   %ebx
  800770:	6a 25                	push   $0x25
  800772:	ff d6                	call   *%esi
			break;
  800774:	83 c4 10             	add    $0x10,%esp
  800777:	e9 7a ff ff ff       	jmp    8006f6 <vprintfmt+0x3a6>
			putch('%', putdat);
  80077c:	83 ec 08             	sub    $0x8,%esp
  80077f:	53                   	push   %ebx
  800780:	6a 25                	push   $0x25
  800782:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800784:	83 c4 10             	add    $0x10,%esp
  800787:	89 f8                	mov    %edi,%eax
  800789:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80078d:	74 05                	je     800794 <vprintfmt+0x444>
  80078f:	83 e8 01             	sub    $0x1,%eax
  800792:	eb f5                	jmp    800789 <vprintfmt+0x439>
  800794:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800797:	e9 5a ff ff ff       	jmp    8006f6 <vprintfmt+0x3a6>
}
  80079c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80079f:	5b                   	pop    %ebx
  8007a0:	5e                   	pop    %esi
  8007a1:	5f                   	pop    %edi
  8007a2:	5d                   	pop    %ebp
  8007a3:	c3                   	ret    

008007a4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007a4:	f3 0f 1e fb          	endbr32 
  8007a8:	55                   	push   %ebp
  8007a9:	89 e5                	mov    %esp,%ebp
  8007ab:	83 ec 18             	sub    $0x18,%esp
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007b7:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007bb:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007c5:	85 c0                	test   %eax,%eax
  8007c7:	74 26                	je     8007ef <vsnprintf+0x4b>
  8007c9:	85 d2                	test   %edx,%edx
  8007cb:	7e 22                	jle    8007ef <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007cd:	ff 75 14             	pushl  0x14(%ebp)
  8007d0:	ff 75 10             	pushl  0x10(%ebp)
  8007d3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007d6:	50                   	push   %eax
  8007d7:	68 0e 03 80 00       	push   $0x80030e
  8007dc:	e8 6f fb ff ff       	call   800350 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007e4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007ea:	83 c4 10             	add    $0x10,%esp
}
  8007ed:	c9                   	leave  
  8007ee:	c3                   	ret    
		return -E_INVAL;
  8007ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007f4:	eb f7                	jmp    8007ed <vsnprintf+0x49>

008007f6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007f6:	f3 0f 1e fb          	endbr32 
  8007fa:	55                   	push   %ebp
  8007fb:	89 e5                	mov    %esp,%ebp
  8007fd:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800800:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800803:	50                   	push   %eax
  800804:	ff 75 10             	pushl  0x10(%ebp)
  800807:	ff 75 0c             	pushl  0xc(%ebp)
  80080a:	ff 75 08             	pushl  0x8(%ebp)
  80080d:	e8 92 ff ff ff       	call   8007a4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800812:	c9                   	leave  
  800813:	c3                   	ret    

00800814 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800814:	f3 0f 1e fb          	endbr32 
  800818:	55                   	push   %ebp
  800819:	89 e5                	mov    %esp,%ebp
  80081b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80081e:	b8 00 00 00 00       	mov    $0x0,%eax
  800823:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800827:	74 05                	je     80082e <strlen+0x1a>
		n++;
  800829:	83 c0 01             	add    $0x1,%eax
  80082c:	eb f5                	jmp    800823 <strlen+0xf>
	return n;
}
  80082e:	5d                   	pop    %ebp
  80082f:	c3                   	ret    

00800830 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800830:	f3 0f 1e fb          	endbr32 
  800834:	55                   	push   %ebp
  800835:	89 e5                	mov    %esp,%ebp
  800837:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80083a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80083d:	b8 00 00 00 00       	mov    $0x0,%eax
  800842:	39 d0                	cmp    %edx,%eax
  800844:	74 0d                	je     800853 <strnlen+0x23>
  800846:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80084a:	74 05                	je     800851 <strnlen+0x21>
		n++;
  80084c:	83 c0 01             	add    $0x1,%eax
  80084f:	eb f1                	jmp    800842 <strnlen+0x12>
  800851:	89 c2                	mov    %eax,%edx
	return n;
}
  800853:	89 d0                	mov    %edx,%eax
  800855:	5d                   	pop    %ebp
  800856:	c3                   	ret    

00800857 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800857:	f3 0f 1e fb          	endbr32 
  80085b:	55                   	push   %ebp
  80085c:	89 e5                	mov    %esp,%ebp
  80085e:	53                   	push   %ebx
  80085f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800862:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800865:	b8 00 00 00 00       	mov    $0x0,%eax
  80086a:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80086e:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800871:	83 c0 01             	add    $0x1,%eax
  800874:	84 d2                	test   %dl,%dl
  800876:	75 f2                	jne    80086a <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800878:	89 c8                	mov    %ecx,%eax
  80087a:	5b                   	pop    %ebx
  80087b:	5d                   	pop    %ebp
  80087c:	c3                   	ret    

0080087d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80087d:	f3 0f 1e fb          	endbr32 
  800881:	55                   	push   %ebp
  800882:	89 e5                	mov    %esp,%ebp
  800884:	53                   	push   %ebx
  800885:	83 ec 10             	sub    $0x10,%esp
  800888:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80088b:	53                   	push   %ebx
  80088c:	e8 83 ff ff ff       	call   800814 <strlen>
  800891:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800894:	ff 75 0c             	pushl  0xc(%ebp)
  800897:	01 d8                	add    %ebx,%eax
  800899:	50                   	push   %eax
  80089a:	e8 b8 ff ff ff       	call   800857 <strcpy>
	return dst;
}
  80089f:	89 d8                	mov    %ebx,%eax
  8008a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008a4:	c9                   	leave  
  8008a5:	c3                   	ret    

008008a6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008a6:	f3 0f 1e fb          	endbr32 
  8008aa:	55                   	push   %ebp
  8008ab:	89 e5                	mov    %esp,%ebp
  8008ad:	56                   	push   %esi
  8008ae:	53                   	push   %ebx
  8008af:	8b 75 08             	mov    0x8(%ebp),%esi
  8008b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b5:	89 f3                	mov    %esi,%ebx
  8008b7:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008ba:	89 f0                	mov    %esi,%eax
  8008bc:	39 d8                	cmp    %ebx,%eax
  8008be:	74 11                	je     8008d1 <strncpy+0x2b>
		*dst++ = *src;
  8008c0:	83 c0 01             	add    $0x1,%eax
  8008c3:	0f b6 0a             	movzbl (%edx),%ecx
  8008c6:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008c9:	80 f9 01             	cmp    $0x1,%cl
  8008cc:	83 da ff             	sbb    $0xffffffff,%edx
  8008cf:	eb eb                	jmp    8008bc <strncpy+0x16>
	}
	return ret;
}
  8008d1:	89 f0                	mov    %esi,%eax
  8008d3:	5b                   	pop    %ebx
  8008d4:	5e                   	pop    %esi
  8008d5:	5d                   	pop    %ebp
  8008d6:	c3                   	ret    

008008d7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008d7:	f3 0f 1e fb          	endbr32 
  8008db:	55                   	push   %ebp
  8008dc:	89 e5                	mov    %esp,%ebp
  8008de:	56                   	push   %esi
  8008df:	53                   	push   %ebx
  8008e0:	8b 75 08             	mov    0x8(%ebp),%esi
  8008e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008e6:	8b 55 10             	mov    0x10(%ebp),%edx
  8008e9:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008eb:	85 d2                	test   %edx,%edx
  8008ed:	74 21                	je     800910 <strlcpy+0x39>
  8008ef:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008f3:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008f5:	39 c2                	cmp    %eax,%edx
  8008f7:	74 14                	je     80090d <strlcpy+0x36>
  8008f9:	0f b6 19             	movzbl (%ecx),%ebx
  8008fc:	84 db                	test   %bl,%bl
  8008fe:	74 0b                	je     80090b <strlcpy+0x34>
			*dst++ = *src++;
  800900:	83 c1 01             	add    $0x1,%ecx
  800903:	83 c2 01             	add    $0x1,%edx
  800906:	88 5a ff             	mov    %bl,-0x1(%edx)
  800909:	eb ea                	jmp    8008f5 <strlcpy+0x1e>
  80090b:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80090d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800910:	29 f0                	sub    %esi,%eax
}
  800912:	5b                   	pop    %ebx
  800913:	5e                   	pop    %esi
  800914:	5d                   	pop    %ebp
  800915:	c3                   	ret    

00800916 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800916:	f3 0f 1e fb          	endbr32 
  80091a:	55                   	push   %ebp
  80091b:	89 e5                	mov    %esp,%ebp
  80091d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800920:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800923:	0f b6 01             	movzbl (%ecx),%eax
  800926:	84 c0                	test   %al,%al
  800928:	74 0c                	je     800936 <strcmp+0x20>
  80092a:	3a 02                	cmp    (%edx),%al
  80092c:	75 08                	jne    800936 <strcmp+0x20>
		p++, q++;
  80092e:	83 c1 01             	add    $0x1,%ecx
  800931:	83 c2 01             	add    $0x1,%edx
  800934:	eb ed                	jmp    800923 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800936:	0f b6 c0             	movzbl %al,%eax
  800939:	0f b6 12             	movzbl (%edx),%edx
  80093c:	29 d0                	sub    %edx,%eax
}
  80093e:	5d                   	pop    %ebp
  80093f:	c3                   	ret    

00800940 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800940:	f3 0f 1e fb          	endbr32 
  800944:	55                   	push   %ebp
  800945:	89 e5                	mov    %esp,%ebp
  800947:	53                   	push   %ebx
  800948:	8b 45 08             	mov    0x8(%ebp),%eax
  80094b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094e:	89 c3                	mov    %eax,%ebx
  800950:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800953:	eb 06                	jmp    80095b <strncmp+0x1b>
		n--, p++, q++;
  800955:	83 c0 01             	add    $0x1,%eax
  800958:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80095b:	39 d8                	cmp    %ebx,%eax
  80095d:	74 16                	je     800975 <strncmp+0x35>
  80095f:	0f b6 08             	movzbl (%eax),%ecx
  800962:	84 c9                	test   %cl,%cl
  800964:	74 04                	je     80096a <strncmp+0x2a>
  800966:	3a 0a                	cmp    (%edx),%cl
  800968:	74 eb                	je     800955 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80096a:	0f b6 00             	movzbl (%eax),%eax
  80096d:	0f b6 12             	movzbl (%edx),%edx
  800970:	29 d0                	sub    %edx,%eax
}
  800972:	5b                   	pop    %ebx
  800973:	5d                   	pop    %ebp
  800974:	c3                   	ret    
		return 0;
  800975:	b8 00 00 00 00       	mov    $0x0,%eax
  80097a:	eb f6                	jmp    800972 <strncmp+0x32>

0080097c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80097c:	f3 0f 1e fb          	endbr32 
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80098a:	0f b6 10             	movzbl (%eax),%edx
  80098d:	84 d2                	test   %dl,%dl
  80098f:	74 09                	je     80099a <strchr+0x1e>
		if (*s == c)
  800991:	38 ca                	cmp    %cl,%dl
  800993:	74 0a                	je     80099f <strchr+0x23>
	for (; *s; s++)
  800995:	83 c0 01             	add    $0x1,%eax
  800998:	eb f0                	jmp    80098a <strchr+0xe>
			return (char *) s;
	return 0;
  80099a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80099f:	5d                   	pop    %ebp
  8009a0:	c3                   	ret    

008009a1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009a1:	f3 0f 1e fb          	endbr32 
  8009a5:	55                   	push   %ebp
  8009a6:	89 e5                	mov    %esp,%ebp
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009af:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009b2:	38 ca                	cmp    %cl,%dl
  8009b4:	74 09                	je     8009bf <strfind+0x1e>
  8009b6:	84 d2                	test   %dl,%dl
  8009b8:	74 05                	je     8009bf <strfind+0x1e>
	for (; *s; s++)
  8009ba:	83 c0 01             	add    $0x1,%eax
  8009bd:	eb f0                	jmp    8009af <strfind+0xe>
			break;
	return (char *) s;
}
  8009bf:	5d                   	pop    %ebp
  8009c0:	c3                   	ret    

008009c1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009c1:	f3 0f 1e fb          	endbr32 
  8009c5:	55                   	push   %ebp
  8009c6:	89 e5                	mov    %esp,%ebp
  8009c8:	57                   	push   %edi
  8009c9:	56                   	push   %esi
  8009ca:	53                   	push   %ebx
  8009cb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009d1:	85 c9                	test   %ecx,%ecx
  8009d3:	74 31                	je     800a06 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009d5:	89 f8                	mov    %edi,%eax
  8009d7:	09 c8                	or     %ecx,%eax
  8009d9:	a8 03                	test   $0x3,%al
  8009db:	75 23                	jne    800a00 <memset+0x3f>
		c &= 0xFF;
  8009dd:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009e1:	89 d3                	mov    %edx,%ebx
  8009e3:	c1 e3 08             	shl    $0x8,%ebx
  8009e6:	89 d0                	mov    %edx,%eax
  8009e8:	c1 e0 18             	shl    $0x18,%eax
  8009eb:	89 d6                	mov    %edx,%esi
  8009ed:	c1 e6 10             	shl    $0x10,%esi
  8009f0:	09 f0                	or     %esi,%eax
  8009f2:	09 c2                	or     %eax,%edx
  8009f4:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009f6:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009f9:	89 d0                	mov    %edx,%eax
  8009fb:	fc                   	cld    
  8009fc:	f3 ab                	rep stos %eax,%es:(%edi)
  8009fe:	eb 06                	jmp    800a06 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a03:	fc                   	cld    
  800a04:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a06:	89 f8                	mov    %edi,%eax
  800a08:	5b                   	pop    %ebx
  800a09:	5e                   	pop    %esi
  800a0a:	5f                   	pop    %edi
  800a0b:	5d                   	pop    %ebp
  800a0c:	c3                   	ret    

00800a0d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a0d:	f3 0f 1e fb          	endbr32 
  800a11:	55                   	push   %ebp
  800a12:	89 e5                	mov    %esp,%ebp
  800a14:	57                   	push   %edi
  800a15:	56                   	push   %esi
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a1c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a1f:	39 c6                	cmp    %eax,%esi
  800a21:	73 32                	jae    800a55 <memmove+0x48>
  800a23:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a26:	39 c2                	cmp    %eax,%edx
  800a28:	76 2b                	jbe    800a55 <memmove+0x48>
		s += n;
		d += n;
  800a2a:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a2d:	89 fe                	mov    %edi,%esi
  800a2f:	09 ce                	or     %ecx,%esi
  800a31:	09 d6                	or     %edx,%esi
  800a33:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a39:	75 0e                	jne    800a49 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a3b:	83 ef 04             	sub    $0x4,%edi
  800a3e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a41:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a44:	fd                   	std    
  800a45:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a47:	eb 09                	jmp    800a52 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a49:	83 ef 01             	sub    $0x1,%edi
  800a4c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a4f:	fd                   	std    
  800a50:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a52:	fc                   	cld    
  800a53:	eb 1a                	jmp    800a6f <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a55:	89 c2                	mov    %eax,%edx
  800a57:	09 ca                	or     %ecx,%edx
  800a59:	09 f2                	or     %esi,%edx
  800a5b:	f6 c2 03             	test   $0x3,%dl
  800a5e:	75 0a                	jne    800a6a <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a60:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a63:	89 c7                	mov    %eax,%edi
  800a65:	fc                   	cld    
  800a66:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a68:	eb 05                	jmp    800a6f <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800a6a:	89 c7                	mov    %eax,%edi
  800a6c:	fc                   	cld    
  800a6d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a6f:	5e                   	pop    %esi
  800a70:	5f                   	pop    %edi
  800a71:	5d                   	pop    %ebp
  800a72:	c3                   	ret    

00800a73 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a73:	f3 0f 1e fb          	endbr32 
  800a77:	55                   	push   %ebp
  800a78:	89 e5                	mov    %esp,%ebp
  800a7a:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a7d:	ff 75 10             	pushl  0x10(%ebp)
  800a80:	ff 75 0c             	pushl  0xc(%ebp)
  800a83:	ff 75 08             	pushl  0x8(%ebp)
  800a86:	e8 82 ff ff ff       	call   800a0d <memmove>
}
  800a8b:	c9                   	leave  
  800a8c:	c3                   	ret    

00800a8d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a8d:	f3 0f 1e fb          	endbr32 
  800a91:	55                   	push   %ebp
  800a92:	89 e5                	mov    %esp,%ebp
  800a94:	56                   	push   %esi
  800a95:	53                   	push   %ebx
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9c:	89 c6                	mov    %eax,%esi
  800a9e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800aa1:	39 f0                	cmp    %esi,%eax
  800aa3:	74 1c                	je     800ac1 <memcmp+0x34>
		if (*s1 != *s2)
  800aa5:	0f b6 08             	movzbl (%eax),%ecx
  800aa8:	0f b6 1a             	movzbl (%edx),%ebx
  800aab:	38 d9                	cmp    %bl,%cl
  800aad:	75 08                	jne    800ab7 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800aaf:	83 c0 01             	add    $0x1,%eax
  800ab2:	83 c2 01             	add    $0x1,%edx
  800ab5:	eb ea                	jmp    800aa1 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800ab7:	0f b6 c1             	movzbl %cl,%eax
  800aba:	0f b6 db             	movzbl %bl,%ebx
  800abd:	29 d8                	sub    %ebx,%eax
  800abf:	eb 05                	jmp    800ac6 <memcmp+0x39>
	}

	return 0;
  800ac1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ac6:	5b                   	pop    %ebx
  800ac7:	5e                   	pop    %esi
  800ac8:	5d                   	pop    %ebp
  800ac9:	c3                   	ret    

00800aca <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800aca:	f3 0f 1e fb          	endbr32 
  800ace:	55                   	push   %ebp
  800acf:	89 e5                	mov    %esp,%ebp
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ad7:	89 c2                	mov    %eax,%edx
  800ad9:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800adc:	39 d0                	cmp    %edx,%eax
  800ade:	73 09                	jae    800ae9 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ae0:	38 08                	cmp    %cl,(%eax)
  800ae2:	74 05                	je     800ae9 <memfind+0x1f>
	for (; s < ends; s++)
  800ae4:	83 c0 01             	add    $0x1,%eax
  800ae7:	eb f3                	jmp    800adc <memfind+0x12>
			break;
	return (void *) s;
}
  800ae9:	5d                   	pop    %ebp
  800aea:	c3                   	ret    

00800aeb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800aeb:	f3 0f 1e fb          	endbr32 
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
  800af2:	57                   	push   %edi
  800af3:	56                   	push   %esi
  800af4:	53                   	push   %ebx
  800af5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800af8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800afb:	eb 03                	jmp    800b00 <strtol+0x15>
		s++;
  800afd:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b00:	0f b6 01             	movzbl (%ecx),%eax
  800b03:	3c 20                	cmp    $0x20,%al
  800b05:	74 f6                	je     800afd <strtol+0x12>
  800b07:	3c 09                	cmp    $0x9,%al
  800b09:	74 f2                	je     800afd <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800b0b:	3c 2b                	cmp    $0x2b,%al
  800b0d:	74 2a                	je     800b39 <strtol+0x4e>
	int neg = 0;
  800b0f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b14:	3c 2d                	cmp    $0x2d,%al
  800b16:	74 2b                	je     800b43 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b18:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b1e:	75 0f                	jne    800b2f <strtol+0x44>
  800b20:	80 39 30             	cmpb   $0x30,(%ecx)
  800b23:	74 28                	je     800b4d <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b25:	85 db                	test   %ebx,%ebx
  800b27:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b2c:	0f 44 d8             	cmove  %eax,%ebx
  800b2f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b34:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b37:	eb 46                	jmp    800b7f <strtol+0x94>
		s++;
  800b39:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b3c:	bf 00 00 00 00       	mov    $0x0,%edi
  800b41:	eb d5                	jmp    800b18 <strtol+0x2d>
		s++, neg = 1;
  800b43:	83 c1 01             	add    $0x1,%ecx
  800b46:	bf 01 00 00 00       	mov    $0x1,%edi
  800b4b:	eb cb                	jmp    800b18 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b4d:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b51:	74 0e                	je     800b61 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b53:	85 db                	test   %ebx,%ebx
  800b55:	75 d8                	jne    800b2f <strtol+0x44>
		s++, base = 8;
  800b57:	83 c1 01             	add    $0x1,%ecx
  800b5a:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b5f:	eb ce                	jmp    800b2f <strtol+0x44>
		s += 2, base = 16;
  800b61:	83 c1 02             	add    $0x2,%ecx
  800b64:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b69:	eb c4                	jmp    800b2f <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b6b:	0f be d2             	movsbl %dl,%edx
  800b6e:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b71:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b74:	7d 3a                	jge    800bb0 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b76:	83 c1 01             	add    $0x1,%ecx
  800b79:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b7d:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b7f:	0f b6 11             	movzbl (%ecx),%edx
  800b82:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b85:	89 f3                	mov    %esi,%ebx
  800b87:	80 fb 09             	cmp    $0x9,%bl
  800b8a:	76 df                	jbe    800b6b <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b8c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b8f:	89 f3                	mov    %esi,%ebx
  800b91:	80 fb 19             	cmp    $0x19,%bl
  800b94:	77 08                	ja     800b9e <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b96:	0f be d2             	movsbl %dl,%edx
  800b99:	83 ea 57             	sub    $0x57,%edx
  800b9c:	eb d3                	jmp    800b71 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b9e:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ba1:	89 f3                	mov    %esi,%ebx
  800ba3:	80 fb 19             	cmp    $0x19,%bl
  800ba6:	77 08                	ja     800bb0 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ba8:	0f be d2             	movsbl %dl,%edx
  800bab:	83 ea 37             	sub    $0x37,%edx
  800bae:	eb c1                	jmp    800b71 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bb0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb4:	74 05                	je     800bbb <strtol+0xd0>
		*endptr = (char *) s;
  800bb6:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bb9:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bbb:	89 c2                	mov    %eax,%edx
  800bbd:	f7 da                	neg    %edx
  800bbf:	85 ff                	test   %edi,%edi
  800bc1:	0f 45 c2             	cmovne %edx,%eax
}
  800bc4:	5b                   	pop    %ebx
  800bc5:	5e                   	pop    %esi
  800bc6:	5f                   	pop    %edi
  800bc7:	5d                   	pop    %ebp
  800bc8:	c3                   	ret    

00800bc9 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bc9:	f3 0f 1e fb          	endbr32 
  800bcd:	55                   	push   %ebp
  800bce:	89 e5                	mov    %esp,%ebp
  800bd0:	57                   	push   %edi
  800bd1:	56                   	push   %esi
  800bd2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd3:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd8:	8b 55 08             	mov    0x8(%ebp),%edx
  800bdb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bde:	89 c3                	mov    %eax,%ebx
  800be0:	89 c7                	mov    %eax,%edi
  800be2:	89 c6                	mov    %eax,%esi
  800be4:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800be6:	5b                   	pop    %ebx
  800be7:	5e                   	pop    %esi
  800be8:	5f                   	pop    %edi
  800be9:	5d                   	pop    %ebp
  800bea:	c3                   	ret    

00800beb <sys_cgetc>:

int
sys_cgetc(void)
{
  800beb:	f3 0f 1e fb          	endbr32 
  800bef:	55                   	push   %ebp
  800bf0:	89 e5                	mov    %esp,%ebp
  800bf2:	57                   	push   %edi
  800bf3:	56                   	push   %esi
  800bf4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bf5:	ba 00 00 00 00       	mov    $0x0,%edx
  800bfa:	b8 01 00 00 00       	mov    $0x1,%eax
  800bff:	89 d1                	mov    %edx,%ecx
  800c01:	89 d3                	mov    %edx,%ebx
  800c03:	89 d7                	mov    %edx,%edi
  800c05:	89 d6                	mov    %edx,%esi
  800c07:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c09:	5b                   	pop    %ebx
  800c0a:	5e                   	pop    %esi
  800c0b:	5f                   	pop    %edi
  800c0c:	5d                   	pop    %ebp
  800c0d:	c3                   	ret    

00800c0e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c0e:	f3 0f 1e fb          	endbr32 
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	57                   	push   %edi
  800c16:	56                   	push   %esi
  800c17:	53                   	push   %ebx
  800c18:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c1b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c20:	8b 55 08             	mov    0x8(%ebp),%edx
  800c23:	b8 03 00 00 00       	mov    $0x3,%eax
  800c28:	89 cb                	mov    %ecx,%ebx
  800c2a:	89 cf                	mov    %ecx,%edi
  800c2c:	89 ce                	mov    %ecx,%esi
  800c2e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c30:	85 c0                	test   %eax,%eax
  800c32:	7f 08                	jg     800c3c <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c34:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c37:	5b                   	pop    %ebx
  800c38:	5e                   	pop    %esi
  800c39:	5f                   	pop    %edi
  800c3a:	5d                   	pop    %ebp
  800c3b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c3c:	83 ec 0c             	sub    $0xc,%esp
  800c3f:	50                   	push   %eax
  800c40:	6a 03                	push   $0x3
  800c42:	68 7f 26 80 00       	push   $0x80267f
  800c47:	6a 23                	push   $0x23
  800c49:	68 9c 26 80 00       	push   $0x80269c
  800c4e:	e8 13 f5 ff ff       	call   800166 <_panic>

00800c53 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c53:	f3 0f 1e fb          	endbr32 
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	57                   	push   %edi
  800c5b:	56                   	push   %esi
  800c5c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c5d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c62:	b8 02 00 00 00       	mov    $0x2,%eax
  800c67:	89 d1                	mov    %edx,%ecx
  800c69:	89 d3                	mov    %edx,%ebx
  800c6b:	89 d7                	mov    %edx,%edi
  800c6d:	89 d6                	mov    %edx,%esi
  800c6f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c71:	5b                   	pop    %ebx
  800c72:	5e                   	pop    %esi
  800c73:	5f                   	pop    %edi
  800c74:	5d                   	pop    %ebp
  800c75:	c3                   	ret    

00800c76 <sys_yield>:

void
sys_yield(void)
{
  800c76:	f3 0f 1e fb          	endbr32 
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
  800c7d:	57                   	push   %edi
  800c7e:	56                   	push   %esi
  800c7f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c80:	ba 00 00 00 00       	mov    $0x0,%edx
  800c85:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c8a:	89 d1                	mov    %edx,%ecx
  800c8c:	89 d3                	mov    %edx,%ebx
  800c8e:	89 d7                	mov    %edx,%edi
  800c90:	89 d6                	mov    %edx,%esi
  800c92:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c94:	5b                   	pop    %ebx
  800c95:	5e                   	pop    %esi
  800c96:	5f                   	pop    %edi
  800c97:	5d                   	pop    %ebp
  800c98:	c3                   	ret    

00800c99 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c99:	f3 0f 1e fb          	endbr32 
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
  800ca0:	57                   	push   %edi
  800ca1:	56                   	push   %esi
  800ca2:	53                   	push   %ebx
  800ca3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ca6:	be 00 00 00 00       	mov    $0x0,%esi
  800cab:	8b 55 08             	mov    0x8(%ebp),%edx
  800cae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb1:	b8 04 00 00 00       	mov    $0x4,%eax
  800cb6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cb9:	89 f7                	mov    %esi,%edi
  800cbb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cbd:	85 c0                	test   %eax,%eax
  800cbf:	7f 08                	jg     800cc9 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc4:	5b                   	pop    %ebx
  800cc5:	5e                   	pop    %esi
  800cc6:	5f                   	pop    %edi
  800cc7:	5d                   	pop    %ebp
  800cc8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc9:	83 ec 0c             	sub    $0xc,%esp
  800ccc:	50                   	push   %eax
  800ccd:	6a 04                	push   $0x4
  800ccf:	68 7f 26 80 00       	push   $0x80267f
  800cd4:	6a 23                	push   $0x23
  800cd6:	68 9c 26 80 00       	push   $0x80269c
  800cdb:	e8 86 f4 ff ff       	call   800166 <_panic>

00800ce0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ce0:	f3 0f 1e fb          	endbr32 
  800ce4:	55                   	push   %ebp
  800ce5:	89 e5                	mov    %esp,%ebp
  800ce7:	57                   	push   %edi
  800ce8:	56                   	push   %esi
  800ce9:	53                   	push   %ebx
  800cea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ced:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf3:	b8 05 00 00 00       	mov    $0x5,%eax
  800cf8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cfb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cfe:	8b 75 18             	mov    0x18(%ebp),%esi
  800d01:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d03:	85 c0                	test   %eax,%eax
  800d05:	7f 08                	jg     800d0f <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d07:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d0a:	5b                   	pop    %ebx
  800d0b:	5e                   	pop    %esi
  800d0c:	5f                   	pop    %edi
  800d0d:	5d                   	pop    %ebp
  800d0e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0f:	83 ec 0c             	sub    $0xc,%esp
  800d12:	50                   	push   %eax
  800d13:	6a 05                	push   $0x5
  800d15:	68 7f 26 80 00       	push   $0x80267f
  800d1a:	6a 23                	push   $0x23
  800d1c:	68 9c 26 80 00       	push   $0x80269c
  800d21:	e8 40 f4 ff ff       	call   800166 <_panic>

00800d26 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d26:	f3 0f 1e fb          	endbr32 
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	57                   	push   %edi
  800d2e:	56                   	push   %esi
  800d2f:	53                   	push   %ebx
  800d30:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d33:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d38:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3e:	b8 06 00 00 00       	mov    $0x6,%eax
  800d43:	89 df                	mov    %ebx,%edi
  800d45:	89 de                	mov    %ebx,%esi
  800d47:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d49:	85 c0                	test   %eax,%eax
  800d4b:	7f 08                	jg     800d55 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d50:	5b                   	pop    %ebx
  800d51:	5e                   	pop    %esi
  800d52:	5f                   	pop    %edi
  800d53:	5d                   	pop    %ebp
  800d54:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d55:	83 ec 0c             	sub    $0xc,%esp
  800d58:	50                   	push   %eax
  800d59:	6a 06                	push   $0x6
  800d5b:	68 7f 26 80 00       	push   $0x80267f
  800d60:	6a 23                	push   $0x23
  800d62:	68 9c 26 80 00       	push   $0x80269c
  800d67:	e8 fa f3 ff ff       	call   800166 <_panic>

00800d6c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d6c:	f3 0f 1e fb          	endbr32 
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
  800d73:	57                   	push   %edi
  800d74:	56                   	push   %esi
  800d75:	53                   	push   %ebx
  800d76:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d79:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d84:	b8 08 00 00 00       	mov    $0x8,%eax
  800d89:	89 df                	mov    %ebx,%edi
  800d8b:	89 de                	mov    %ebx,%esi
  800d8d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8f:	85 c0                	test   %eax,%eax
  800d91:	7f 08                	jg     800d9b <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d96:	5b                   	pop    %ebx
  800d97:	5e                   	pop    %esi
  800d98:	5f                   	pop    %edi
  800d99:	5d                   	pop    %ebp
  800d9a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9b:	83 ec 0c             	sub    $0xc,%esp
  800d9e:	50                   	push   %eax
  800d9f:	6a 08                	push   $0x8
  800da1:	68 7f 26 80 00       	push   $0x80267f
  800da6:	6a 23                	push   $0x23
  800da8:	68 9c 26 80 00       	push   $0x80269c
  800dad:	e8 b4 f3 ff ff       	call   800166 <_panic>

00800db2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800db2:	f3 0f 1e fb          	endbr32 
  800db6:	55                   	push   %ebp
  800db7:	89 e5                	mov    %esp,%ebp
  800db9:	57                   	push   %edi
  800dba:	56                   	push   %esi
  800dbb:	53                   	push   %ebx
  800dbc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dbf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dca:	b8 09 00 00 00       	mov    $0x9,%eax
  800dcf:	89 df                	mov    %ebx,%edi
  800dd1:	89 de                	mov    %ebx,%esi
  800dd3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd5:	85 c0                	test   %eax,%eax
  800dd7:	7f 08                	jg     800de1 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ddc:	5b                   	pop    %ebx
  800ddd:	5e                   	pop    %esi
  800dde:	5f                   	pop    %edi
  800ddf:	5d                   	pop    %ebp
  800de0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de1:	83 ec 0c             	sub    $0xc,%esp
  800de4:	50                   	push   %eax
  800de5:	6a 09                	push   $0x9
  800de7:	68 7f 26 80 00       	push   $0x80267f
  800dec:	6a 23                	push   $0x23
  800dee:	68 9c 26 80 00       	push   $0x80269c
  800df3:	e8 6e f3 ff ff       	call   800166 <_panic>

00800df8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800df8:	f3 0f 1e fb          	endbr32 
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	57                   	push   %edi
  800e00:	56                   	push   %esi
  800e01:	53                   	push   %ebx
  800e02:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e05:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e10:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e15:	89 df                	mov    %ebx,%edi
  800e17:	89 de                	mov    %ebx,%esi
  800e19:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e1b:	85 c0                	test   %eax,%eax
  800e1d:	7f 08                	jg     800e27 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
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
  800e2b:	6a 0a                	push   $0xa
  800e2d:	68 7f 26 80 00       	push   $0x80267f
  800e32:	6a 23                	push   $0x23
  800e34:	68 9c 26 80 00       	push   $0x80269c
  800e39:	e8 28 f3 ff ff       	call   800166 <_panic>

00800e3e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e3e:	f3 0f 1e fb          	endbr32 
  800e42:	55                   	push   %ebp
  800e43:	89 e5                	mov    %esp,%ebp
  800e45:	57                   	push   %edi
  800e46:	56                   	push   %esi
  800e47:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e48:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4e:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e53:	be 00 00 00 00       	mov    $0x0,%esi
  800e58:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e5b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e5e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e60:	5b                   	pop    %ebx
  800e61:	5e                   	pop    %esi
  800e62:	5f                   	pop    %edi
  800e63:	5d                   	pop    %ebp
  800e64:	c3                   	ret    

00800e65 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e65:	f3 0f 1e fb          	endbr32 
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
  800e6c:	57                   	push   %edi
  800e6d:	56                   	push   %esi
  800e6e:	53                   	push   %ebx
  800e6f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e72:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e77:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7a:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e7f:	89 cb                	mov    %ecx,%ebx
  800e81:	89 cf                	mov    %ecx,%edi
  800e83:	89 ce                	mov    %ecx,%esi
  800e85:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e87:	85 c0                	test   %eax,%eax
  800e89:	7f 08                	jg     800e93 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e8e:	5b                   	pop    %ebx
  800e8f:	5e                   	pop    %esi
  800e90:	5f                   	pop    %edi
  800e91:	5d                   	pop    %ebp
  800e92:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e93:	83 ec 0c             	sub    $0xc,%esp
  800e96:	50                   	push   %eax
  800e97:	6a 0d                	push   $0xd
  800e99:	68 7f 26 80 00       	push   $0x80267f
  800e9e:	6a 23                	push   $0x23
  800ea0:	68 9c 26 80 00       	push   $0x80269c
  800ea5:	e8 bc f2 ff ff       	call   800166 <_panic>

00800eaa <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800eaa:	f3 0f 1e fb          	endbr32 
  800eae:	55                   	push   %ebp
  800eaf:	89 e5                	mov    %esp,%ebp
  800eb1:	53                   	push   %ebx
  800eb2:	83 ec 04             	sub    $0x4,%esp
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800eb8:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  800eba:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800ebe:	74 74                	je     800f34 <pgfault+0x8a>
  800ec0:	89 d8                	mov    %ebx,%eax
  800ec2:	c1 e8 0c             	shr    $0xc,%eax
  800ec5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800ecc:	f6 c4 08             	test   $0x8,%ah
  800ecf:	74 63                	je     800f34 <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800ed1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  800ed7:	83 ec 0c             	sub    $0xc,%esp
  800eda:	6a 05                	push   $0x5
  800edc:	68 00 f0 7f 00       	push   $0x7ff000
  800ee1:	6a 00                	push   $0x0
  800ee3:	53                   	push   %ebx
  800ee4:	6a 00                	push   $0x0
  800ee6:	e8 f5 fd ff ff       	call   800ce0 <sys_page_map>
  800eeb:	83 c4 20             	add    $0x20,%esp
  800eee:	85 c0                	test   %eax,%eax
  800ef0:	78 59                	js     800f4b <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  800ef2:	83 ec 04             	sub    $0x4,%esp
  800ef5:	6a 07                	push   $0x7
  800ef7:	53                   	push   %ebx
  800ef8:	6a 00                	push   $0x0
  800efa:	e8 9a fd ff ff       	call   800c99 <sys_page_alloc>
  800eff:	83 c4 10             	add    $0x10,%esp
  800f02:	85 c0                	test   %eax,%eax
  800f04:	78 5a                	js     800f60 <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  800f06:	83 ec 04             	sub    $0x4,%esp
  800f09:	68 00 10 00 00       	push   $0x1000
  800f0e:	68 00 f0 7f 00       	push   $0x7ff000
  800f13:	53                   	push   %ebx
  800f14:	e8 f4 fa ff ff       	call   800a0d <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  800f19:	83 c4 08             	add    $0x8,%esp
  800f1c:	68 00 f0 7f 00       	push   $0x7ff000
  800f21:	6a 00                	push   $0x0
  800f23:	e8 fe fd ff ff       	call   800d26 <sys_page_unmap>
  800f28:	83 c4 10             	add    $0x10,%esp
  800f2b:	85 c0                	test   %eax,%eax
  800f2d:	78 46                	js     800f75 <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  800f2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f32:	c9                   	leave  
  800f33:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  800f34:	83 ec 04             	sub    $0x4,%esp
  800f37:	68 aa 26 80 00       	push   $0x8026aa
  800f3c:	68 d3 00 00 00       	push   $0xd3
  800f41:	68 c6 26 80 00       	push   $0x8026c6
  800f46:	e8 1b f2 ff ff       	call   800166 <_panic>
		panic("pgfault: %e\n", r);
  800f4b:	50                   	push   %eax
  800f4c:	68 d1 26 80 00       	push   $0x8026d1
  800f51:	68 df 00 00 00       	push   $0xdf
  800f56:	68 c6 26 80 00       	push   $0x8026c6
  800f5b:	e8 06 f2 ff ff       	call   800166 <_panic>
		panic("pgfault: %e\n", r);
  800f60:	50                   	push   %eax
  800f61:	68 d1 26 80 00       	push   $0x8026d1
  800f66:	68 e3 00 00 00       	push   $0xe3
  800f6b:	68 c6 26 80 00       	push   $0x8026c6
  800f70:	e8 f1 f1 ff ff       	call   800166 <_panic>
		panic("pgfault: %e\n", r);
  800f75:	50                   	push   %eax
  800f76:	68 d1 26 80 00       	push   $0x8026d1
  800f7b:	68 e9 00 00 00       	push   $0xe9
  800f80:	68 c6 26 80 00       	push   $0x8026c6
  800f85:	e8 dc f1 ff ff       	call   800166 <_panic>

00800f8a <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800f8a:	f3 0f 1e fb          	endbr32 
  800f8e:	55                   	push   %ebp
  800f8f:	89 e5                	mov    %esp,%ebp
  800f91:	57                   	push   %edi
  800f92:	56                   	push   %esi
  800f93:	53                   	push   %ebx
  800f94:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  800f97:	68 aa 0e 80 00       	push   $0x800eaa
  800f9c:	e8 61 10 00 00       	call   802002 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800fa1:	b8 07 00 00 00       	mov    $0x7,%eax
  800fa6:	cd 30                	int    $0x30
  800fa8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  800fab:	83 c4 10             	add    $0x10,%esp
  800fae:	85 c0                	test   %eax,%eax
  800fb0:	78 2d                	js     800fdf <fork+0x55>
  800fb2:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800fb4:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  800fb9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fbd:	0f 85 9b 00 00 00    	jne    80105e <fork+0xd4>
		thisenv = &envs[ENVX(sys_getenvid())];
  800fc3:	e8 8b fc ff ff       	call   800c53 <sys_getenvid>
  800fc8:	25 ff 03 00 00       	and    $0x3ff,%eax
  800fcd:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800fd0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800fd5:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  800fda:	e9 71 01 00 00       	jmp    801150 <fork+0x1c6>
		panic("sys_exofork: %e", envid);
  800fdf:	50                   	push   %eax
  800fe0:	68 de 26 80 00       	push   $0x8026de
  800fe5:	68 2a 01 00 00       	push   $0x12a
  800fea:	68 c6 26 80 00       	push   $0x8026c6
  800fef:	e8 72 f1 ff ff       	call   800166 <_panic>
		sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_SYSCALL);
  800ff4:	c1 e6 0c             	shl    $0xc,%esi
  800ff7:	83 ec 0c             	sub    $0xc,%esp
  800ffa:	68 07 0e 00 00       	push   $0xe07
  800fff:	56                   	push   %esi
  801000:	57                   	push   %edi
  801001:	56                   	push   %esi
  801002:	6a 00                	push   $0x0
  801004:	e8 d7 fc ff ff       	call   800ce0 <sys_page_map>
  801009:	83 c4 20             	add    $0x20,%esp
  80100c:	eb 3e                	jmp    80104c <fork+0xc2>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  80100e:	c1 e6 0c             	shl    $0xc,%esi
  801011:	83 ec 0c             	sub    $0xc,%esp
  801014:	68 05 08 00 00       	push   $0x805
  801019:	56                   	push   %esi
  80101a:	57                   	push   %edi
  80101b:	56                   	push   %esi
  80101c:	6a 00                	push   $0x0
  80101e:	e8 bd fc ff ff       	call   800ce0 <sys_page_map>
  801023:	83 c4 20             	add    $0x20,%esp
  801026:	85 c0                	test   %eax,%eax
  801028:	0f 88 bc 00 00 00    	js     8010ea <fork+0x160>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  80102e:	83 ec 0c             	sub    $0xc,%esp
  801031:	68 05 08 00 00       	push   $0x805
  801036:	56                   	push   %esi
  801037:	6a 00                	push   $0x0
  801039:	56                   	push   %esi
  80103a:	6a 00                	push   $0x0
  80103c:	e8 9f fc ff ff       	call   800ce0 <sys_page_map>
  801041:	83 c4 20             	add    $0x20,%esp
  801044:	85 c0                	test   %eax,%eax
  801046:	0f 88 b3 00 00 00    	js     8010ff <fork+0x175>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  80104c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801052:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801058:	0f 84 b6 00 00 00    	je     801114 <fork+0x18a>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  80105e:	89 d8                	mov    %ebx,%eax
  801060:	c1 e8 16             	shr    $0x16,%eax
  801063:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80106a:	a8 01                	test   $0x1,%al
  80106c:	74 de                	je     80104c <fork+0xc2>
  80106e:	89 de                	mov    %ebx,%esi
  801070:	c1 ee 0c             	shr    $0xc,%esi
  801073:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80107a:	a8 01                	test   $0x1,%al
  80107c:	74 ce                	je     80104c <fork+0xc2>
  80107e:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801085:	a8 04                	test   $0x4,%al
  801087:	74 c3                	je     80104c <fork+0xc2>
	if ((uvpt[pn] & PTE_SHARE)){
  801089:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801090:	f6 c4 04             	test   $0x4,%ah
  801093:	0f 85 5b ff ff ff    	jne    800ff4 <fork+0x6a>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  801099:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010a0:	a8 02                	test   $0x2,%al
  8010a2:	0f 85 66 ff ff ff    	jne    80100e <fork+0x84>
  8010a8:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010af:	f6 c4 08             	test   $0x8,%ah
  8010b2:	0f 85 56 ff ff ff    	jne    80100e <fork+0x84>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  8010b8:	c1 e6 0c             	shl    $0xc,%esi
  8010bb:	83 ec 0c             	sub    $0xc,%esp
  8010be:	6a 05                	push   $0x5
  8010c0:	56                   	push   %esi
  8010c1:	57                   	push   %edi
  8010c2:	56                   	push   %esi
  8010c3:	6a 00                	push   $0x0
  8010c5:	e8 16 fc ff ff       	call   800ce0 <sys_page_map>
  8010ca:	83 c4 20             	add    $0x20,%esp
  8010cd:	85 c0                	test   %eax,%eax
  8010cf:	0f 89 77 ff ff ff    	jns    80104c <fork+0xc2>
		panic("duppage: %e\n", r);
  8010d5:	50                   	push   %eax
  8010d6:	68 ee 26 80 00       	push   $0x8026ee
  8010db:	68 0c 01 00 00       	push   $0x10c
  8010e0:	68 c6 26 80 00       	push   $0x8026c6
  8010e5:	e8 7c f0 ff ff       	call   800166 <_panic>
			panic("duppage: %e\n", r);
  8010ea:	50                   	push   %eax
  8010eb:	68 ee 26 80 00       	push   $0x8026ee
  8010f0:	68 05 01 00 00       	push   $0x105
  8010f5:	68 c6 26 80 00       	push   $0x8026c6
  8010fa:	e8 67 f0 ff ff       	call   800166 <_panic>
			panic("duppage: %e\n", r);
  8010ff:	50                   	push   %eax
  801100:	68 ee 26 80 00       	push   $0x8026ee
  801105:	68 09 01 00 00       	push   $0x109
  80110a:	68 c6 26 80 00       	push   $0x8026c6
  80110f:	e8 52 f0 ff ff       	call   800166 <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  801114:	83 ec 04             	sub    $0x4,%esp
  801117:	6a 07                	push   $0x7
  801119:	68 00 f0 bf ee       	push   $0xeebff000
  80111e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801121:	e8 73 fb ff ff       	call   800c99 <sys_page_alloc>
  801126:	83 c4 10             	add    $0x10,%esp
  801129:	85 c0                	test   %eax,%eax
  80112b:	78 2e                	js     80115b <fork+0x1d1>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  80112d:	83 ec 08             	sub    $0x8,%esp
  801130:	68 75 20 80 00       	push   $0x802075
  801135:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801138:	57                   	push   %edi
  801139:	e8 ba fc ff ff       	call   800df8 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80113e:	83 c4 08             	add    $0x8,%esp
  801141:	6a 02                	push   $0x2
  801143:	57                   	push   %edi
  801144:	e8 23 fc ff ff       	call   800d6c <sys_env_set_status>
  801149:	83 c4 10             	add    $0x10,%esp
  80114c:	85 c0                	test   %eax,%eax
  80114e:	78 20                	js     801170 <fork+0x1e6>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  801150:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801153:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801156:	5b                   	pop    %ebx
  801157:	5e                   	pop    %esi
  801158:	5f                   	pop    %edi
  801159:	5d                   	pop    %ebp
  80115a:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  80115b:	50                   	push   %eax
  80115c:	68 fb 26 80 00       	push   $0x8026fb
  801161:	68 3e 01 00 00       	push   $0x13e
  801166:	68 c6 26 80 00       	push   $0x8026c6
  80116b:	e8 f6 ef ff ff       	call   800166 <_panic>
		panic("sys_env_set_status: %e", r);
  801170:	50                   	push   %eax
  801171:	68 0e 27 80 00       	push   $0x80270e
  801176:	68 43 01 00 00       	push   $0x143
  80117b:	68 c6 26 80 00       	push   $0x8026c6
  801180:	e8 e1 ef ff ff       	call   800166 <_panic>

00801185 <sfork>:

// Challenge!
int
sfork(void)
{
  801185:	f3 0f 1e fb          	endbr32 
  801189:	55                   	push   %ebp
  80118a:	89 e5                	mov    %esp,%ebp
  80118c:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80118f:	68 25 27 80 00       	push   $0x802725
  801194:	68 4c 01 00 00       	push   $0x14c
  801199:	68 c6 26 80 00       	push   $0x8026c6
  80119e:	e8 c3 ef ff ff       	call   800166 <_panic>

008011a3 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8011a3:	f3 0f 1e fb          	endbr32 
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
  8011aa:	56                   	push   %esi
  8011ab:	53                   	push   %ebx
  8011ac:	8b 75 08             	mov    0x8(%ebp),%esi
  8011af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  8011b5:	85 c0                	test   %eax,%eax
  8011b7:	74 3d                	je     8011f6 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  8011b9:	83 ec 0c             	sub    $0xc,%esp
  8011bc:	50                   	push   %eax
  8011bd:	e8 a3 fc ff ff       	call   800e65 <sys_ipc_recv>
  8011c2:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  8011c5:	85 f6                	test   %esi,%esi
  8011c7:	74 0b                	je     8011d4 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8011c9:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8011cf:	8b 52 74             	mov    0x74(%edx),%edx
  8011d2:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  8011d4:	85 db                	test   %ebx,%ebx
  8011d6:	74 0b                	je     8011e3 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  8011d8:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8011de:	8b 52 78             	mov    0x78(%edx),%edx
  8011e1:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  8011e3:	85 c0                	test   %eax,%eax
  8011e5:	78 21                	js     801208 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  8011e7:	a1 04 40 80 00       	mov    0x804004,%eax
  8011ec:	8b 40 70             	mov    0x70(%eax),%eax
}
  8011ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011f2:	5b                   	pop    %ebx
  8011f3:	5e                   	pop    %esi
  8011f4:	5d                   	pop    %ebp
  8011f5:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  8011f6:	83 ec 0c             	sub    $0xc,%esp
  8011f9:	68 00 00 c0 ee       	push   $0xeec00000
  8011fe:	e8 62 fc ff ff       	call   800e65 <sys_ipc_recv>
  801203:	83 c4 10             	add    $0x10,%esp
  801206:	eb bd                	jmp    8011c5 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  801208:	85 f6                	test   %esi,%esi
  80120a:	74 10                	je     80121c <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  80120c:	85 db                	test   %ebx,%ebx
  80120e:	75 df                	jne    8011ef <ipc_recv+0x4c>
  801210:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801217:	00 00 00 
  80121a:	eb d3                	jmp    8011ef <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  80121c:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801223:	00 00 00 
  801226:	eb e4                	jmp    80120c <ipc_recv+0x69>

00801228 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801228:	f3 0f 1e fb          	endbr32 
  80122c:	55                   	push   %ebp
  80122d:	89 e5                	mov    %esp,%ebp
  80122f:	57                   	push   %edi
  801230:	56                   	push   %esi
  801231:	53                   	push   %ebx
  801232:	83 ec 0c             	sub    $0xc,%esp
  801235:	8b 7d 08             	mov    0x8(%ebp),%edi
  801238:	8b 75 0c             	mov    0xc(%ebp),%esi
  80123b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  80123e:	85 db                	test   %ebx,%ebx
  801240:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801245:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  801248:	ff 75 14             	pushl  0x14(%ebp)
  80124b:	53                   	push   %ebx
  80124c:	56                   	push   %esi
  80124d:	57                   	push   %edi
  80124e:	e8 eb fb ff ff       	call   800e3e <sys_ipc_try_send>
  801253:	83 c4 10             	add    $0x10,%esp
  801256:	85 c0                	test   %eax,%eax
  801258:	79 1e                	jns    801278 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  80125a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80125d:	75 07                	jne    801266 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  80125f:	e8 12 fa ff ff       	call   800c76 <sys_yield>
  801264:	eb e2                	jmp    801248 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  801266:	50                   	push   %eax
  801267:	68 3b 27 80 00       	push   $0x80273b
  80126c:	6a 59                	push   $0x59
  80126e:	68 56 27 80 00       	push   $0x802756
  801273:	e8 ee ee ff ff       	call   800166 <_panic>
	}
}
  801278:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80127b:	5b                   	pop    %ebx
  80127c:	5e                   	pop    %esi
  80127d:	5f                   	pop    %edi
  80127e:	5d                   	pop    %ebp
  80127f:	c3                   	ret    

00801280 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801280:	f3 0f 1e fb          	endbr32 
  801284:	55                   	push   %ebp
  801285:	89 e5                	mov    %esp,%ebp
  801287:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80128a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80128f:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801292:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801298:	8b 52 50             	mov    0x50(%edx),%edx
  80129b:	39 ca                	cmp    %ecx,%edx
  80129d:	74 11                	je     8012b0 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80129f:	83 c0 01             	add    $0x1,%eax
  8012a2:	3d 00 04 00 00       	cmp    $0x400,%eax
  8012a7:	75 e6                	jne    80128f <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8012a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ae:	eb 0b                	jmp    8012bb <ipc_find_env+0x3b>
			return envs[i].env_id;
  8012b0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8012b3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012b8:	8b 40 48             	mov    0x48(%eax),%eax
}
  8012bb:	5d                   	pop    %ebp
  8012bc:	c3                   	ret    

008012bd <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012bd:	f3 0f 1e fb          	endbr32 
  8012c1:	55                   	push   %ebp
  8012c2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	05 00 00 00 30       	add    $0x30000000,%eax
  8012cc:	c1 e8 0c             	shr    $0xc,%eax
}
  8012cf:	5d                   	pop    %ebp
  8012d0:	c3                   	ret    

008012d1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012d1:	f3 0f 1e fb          	endbr32 
  8012d5:	55                   	push   %ebp
  8012d6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012db:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8012e0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012e5:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012ea:	5d                   	pop    %ebp
  8012eb:	c3                   	ret    

008012ec <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012ec:	f3 0f 1e fb          	endbr32 
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
  8012f3:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012f8:	89 c2                	mov    %eax,%edx
  8012fa:	c1 ea 16             	shr    $0x16,%edx
  8012fd:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801304:	f6 c2 01             	test   $0x1,%dl
  801307:	74 2d                	je     801336 <fd_alloc+0x4a>
  801309:	89 c2                	mov    %eax,%edx
  80130b:	c1 ea 0c             	shr    $0xc,%edx
  80130e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801315:	f6 c2 01             	test   $0x1,%dl
  801318:	74 1c                	je     801336 <fd_alloc+0x4a>
  80131a:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80131f:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801324:	75 d2                	jne    8012f8 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80132f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801334:	eb 0a                	jmp    801340 <fd_alloc+0x54>
			*fd_store = fd;
  801336:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801339:	89 01                	mov    %eax,(%ecx)
			return 0;
  80133b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801340:	5d                   	pop    %ebp
  801341:	c3                   	ret    

00801342 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801342:	f3 0f 1e fb          	endbr32 
  801346:	55                   	push   %ebp
  801347:	89 e5                	mov    %esp,%ebp
  801349:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80134c:	83 f8 1f             	cmp    $0x1f,%eax
  80134f:	77 30                	ja     801381 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801351:	c1 e0 0c             	shl    $0xc,%eax
  801354:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801359:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80135f:	f6 c2 01             	test   $0x1,%dl
  801362:	74 24                	je     801388 <fd_lookup+0x46>
  801364:	89 c2                	mov    %eax,%edx
  801366:	c1 ea 0c             	shr    $0xc,%edx
  801369:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801370:	f6 c2 01             	test   $0x1,%dl
  801373:	74 1a                	je     80138f <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801375:	8b 55 0c             	mov    0xc(%ebp),%edx
  801378:	89 02                	mov    %eax,(%edx)
	return 0;
  80137a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80137f:	5d                   	pop    %ebp
  801380:	c3                   	ret    
		return -E_INVAL;
  801381:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801386:	eb f7                	jmp    80137f <fd_lookup+0x3d>
		return -E_INVAL;
  801388:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80138d:	eb f0                	jmp    80137f <fd_lookup+0x3d>
  80138f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801394:	eb e9                	jmp    80137f <fd_lookup+0x3d>

00801396 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801396:	f3 0f 1e fb          	endbr32 
  80139a:	55                   	push   %ebp
  80139b:	89 e5                	mov    %esp,%ebp
  80139d:	83 ec 08             	sub    $0x8,%esp
  8013a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013a3:	ba dc 27 80 00       	mov    $0x8027dc,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8013a8:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8013ad:	39 08                	cmp    %ecx,(%eax)
  8013af:	74 33                	je     8013e4 <dev_lookup+0x4e>
  8013b1:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8013b4:	8b 02                	mov    (%edx),%eax
  8013b6:	85 c0                	test   %eax,%eax
  8013b8:	75 f3                	jne    8013ad <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8013ba:	a1 04 40 80 00       	mov    0x804004,%eax
  8013bf:	8b 40 48             	mov    0x48(%eax),%eax
  8013c2:	83 ec 04             	sub    $0x4,%esp
  8013c5:	51                   	push   %ecx
  8013c6:	50                   	push   %eax
  8013c7:	68 60 27 80 00       	push   $0x802760
  8013cc:	e8 7c ee ff ff       	call   80024d <cprintf>
	*dev = 0;
  8013d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013da:	83 c4 10             	add    $0x10,%esp
  8013dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013e2:	c9                   	leave  
  8013e3:	c3                   	ret    
			*dev = devtab[i];
  8013e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013e7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ee:	eb f2                	jmp    8013e2 <dev_lookup+0x4c>

008013f0 <fd_close>:
{
  8013f0:	f3 0f 1e fb          	endbr32 
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
  8013f7:	57                   	push   %edi
  8013f8:	56                   	push   %esi
  8013f9:	53                   	push   %ebx
  8013fa:	83 ec 24             	sub    $0x24,%esp
  8013fd:	8b 75 08             	mov    0x8(%ebp),%esi
  801400:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801403:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801406:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801407:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80140d:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801410:	50                   	push   %eax
  801411:	e8 2c ff ff ff       	call   801342 <fd_lookup>
  801416:	89 c3                	mov    %eax,%ebx
  801418:	83 c4 10             	add    $0x10,%esp
  80141b:	85 c0                	test   %eax,%eax
  80141d:	78 05                	js     801424 <fd_close+0x34>
	    || fd != fd2)
  80141f:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801422:	74 16                	je     80143a <fd_close+0x4a>
		return (must_exist ? r : 0);
  801424:	89 f8                	mov    %edi,%eax
  801426:	84 c0                	test   %al,%al
  801428:	b8 00 00 00 00       	mov    $0x0,%eax
  80142d:	0f 44 d8             	cmove  %eax,%ebx
}
  801430:	89 d8                	mov    %ebx,%eax
  801432:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801435:	5b                   	pop    %ebx
  801436:	5e                   	pop    %esi
  801437:	5f                   	pop    %edi
  801438:	5d                   	pop    %ebp
  801439:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80143a:	83 ec 08             	sub    $0x8,%esp
  80143d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801440:	50                   	push   %eax
  801441:	ff 36                	pushl  (%esi)
  801443:	e8 4e ff ff ff       	call   801396 <dev_lookup>
  801448:	89 c3                	mov    %eax,%ebx
  80144a:	83 c4 10             	add    $0x10,%esp
  80144d:	85 c0                	test   %eax,%eax
  80144f:	78 1a                	js     80146b <fd_close+0x7b>
		if (dev->dev_close)
  801451:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801454:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801457:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80145c:	85 c0                	test   %eax,%eax
  80145e:	74 0b                	je     80146b <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801460:	83 ec 0c             	sub    $0xc,%esp
  801463:	56                   	push   %esi
  801464:	ff d0                	call   *%eax
  801466:	89 c3                	mov    %eax,%ebx
  801468:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80146b:	83 ec 08             	sub    $0x8,%esp
  80146e:	56                   	push   %esi
  80146f:	6a 00                	push   $0x0
  801471:	e8 b0 f8 ff ff       	call   800d26 <sys_page_unmap>
	return r;
  801476:	83 c4 10             	add    $0x10,%esp
  801479:	eb b5                	jmp    801430 <fd_close+0x40>

0080147b <close>:

int
close(int fdnum)
{
  80147b:	f3 0f 1e fb          	endbr32 
  80147f:	55                   	push   %ebp
  801480:	89 e5                	mov    %esp,%ebp
  801482:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801485:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801488:	50                   	push   %eax
  801489:	ff 75 08             	pushl  0x8(%ebp)
  80148c:	e8 b1 fe ff ff       	call   801342 <fd_lookup>
  801491:	83 c4 10             	add    $0x10,%esp
  801494:	85 c0                	test   %eax,%eax
  801496:	79 02                	jns    80149a <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801498:	c9                   	leave  
  801499:	c3                   	ret    
		return fd_close(fd, 1);
  80149a:	83 ec 08             	sub    $0x8,%esp
  80149d:	6a 01                	push   $0x1
  80149f:	ff 75 f4             	pushl  -0xc(%ebp)
  8014a2:	e8 49 ff ff ff       	call   8013f0 <fd_close>
  8014a7:	83 c4 10             	add    $0x10,%esp
  8014aa:	eb ec                	jmp    801498 <close+0x1d>

008014ac <close_all>:

void
close_all(void)
{
  8014ac:	f3 0f 1e fb          	endbr32 
  8014b0:	55                   	push   %ebp
  8014b1:	89 e5                	mov    %esp,%ebp
  8014b3:	53                   	push   %ebx
  8014b4:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8014b7:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8014bc:	83 ec 0c             	sub    $0xc,%esp
  8014bf:	53                   	push   %ebx
  8014c0:	e8 b6 ff ff ff       	call   80147b <close>
	for (i = 0; i < MAXFD; i++)
  8014c5:	83 c3 01             	add    $0x1,%ebx
  8014c8:	83 c4 10             	add    $0x10,%esp
  8014cb:	83 fb 20             	cmp    $0x20,%ebx
  8014ce:	75 ec                	jne    8014bc <close_all+0x10>
}
  8014d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014d3:	c9                   	leave  
  8014d4:	c3                   	ret    

008014d5 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014d5:	f3 0f 1e fb          	endbr32 
  8014d9:	55                   	push   %ebp
  8014da:	89 e5                	mov    %esp,%ebp
  8014dc:	57                   	push   %edi
  8014dd:	56                   	push   %esi
  8014de:	53                   	push   %ebx
  8014df:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8014e2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014e5:	50                   	push   %eax
  8014e6:	ff 75 08             	pushl  0x8(%ebp)
  8014e9:	e8 54 fe ff ff       	call   801342 <fd_lookup>
  8014ee:	89 c3                	mov    %eax,%ebx
  8014f0:	83 c4 10             	add    $0x10,%esp
  8014f3:	85 c0                	test   %eax,%eax
  8014f5:	0f 88 81 00 00 00    	js     80157c <dup+0xa7>
		return r;
	close(newfdnum);
  8014fb:	83 ec 0c             	sub    $0xc,%esp
  8014fe:	ff 75 0c             	pushl  0xc(%ebp)
  801501:	e8 75 ff ff ff       	call   80147b <close>

	newfd = INDEX2FD(newfdnum);
  801506:	8b 75 0c             	mov    0xc(%ebp),%esi
  801509:	c1 e6 0c             	shl    $0xc,%esi
  80150c:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801512:	83 c4 04             	add    $0x4,%esp
  801515:	ff 75 e4             	pushl  -0x1c(%ebp)
  801518:	e8 b4 fd ff ff       	call   8012d1 <fd2data>
  80151d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80151f:	89 34 24             	mov    %esi,(%esp)
  801522:	e8 aa fd ff ff       	call   8012d1 <fd2data>
  801527:	83 c4 10             	add    $0x10,%esp
  80152a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80152c:	89 d8                	mov    %ebx,%eax
  80152e:	c1 e8 16             	shr    $0x16,%eax
  801531:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801538:	a8 01                	test   $0x1,%al
  80153a:	74 11                	je     80154d <dup+0x78>
  80153c:	89 d8                	mov    %ebx,%eax
  80153e:	c1 e8 0c             	shr    $0xc,%eax
  801541:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801548:	f6 c2 01             	test   $0x1,%dl
  80154b:	75 39                	jne    801586 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80154d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801550:	89 d0                	mov    %edx,%eax
  801552:	c1 e8 0c             	shr    $0xc,%eax
  801555:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80155c:	83 ec 0c             	sub    $0xc,%esp
  80155f:	25 07 0e 00 00       	and    $0xe07,%eax
  801564:	50                   	push   %eax
  801565:	56                   	push   %esi
  801566:	6a 00                	push   $0x0
  801568:	52                   	push   %edx
  801569:	6a 00                	push   $0x0
  80156b:	e8 70 f7 ff ff       	call   800ce0 <sys_page_map>
  801570:	89 c3                	mov    %eax,%ebx
  801572:	83 c4 20             	add    $0x20,%esp
  801575:	85 c0                	test   %eax,%eax
  801577:	78 31                	js     8015aa <dup+0xd5>
		goto err;

	return newfdnum;
  801579:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80157c:	89 d8                	mov    %ebx,%eax
  80157e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801581:	5b                   	pop    %ebx
  801582:	5e                   	pop    %esi
  801583:	5f                   	pop    %edi
  801584:	5d                   	pop    %ebp
  801585:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801586:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80158d:	83 ec 0c             	sub    $0xc,%esp
  801590:	25 07 0e 00 00       	and    $0xe07,%eax
  801595:	50                   	push   %eax
  801596:	57                   	push   %edi
  801597:	6a 00                	push   $0x0
  801599:	53                   	push   %ebx
  80159a:	6a 00                	push   $0x0
  80159c:	e8 3f f7 ff ff       	call   800ce0 <sys_page_map>
  8015a1:	89 c3                	mov    %eax,%ebx
  8015a3:	83 c4 20             	add    $0x20,%esp
  8015a6:	85 c0                	test   %eax,%eax
  8015a8:	79 a3                	jns    80154d <dup+0x78>
	sys_page_unmap(0, newfd);
  8015aa:	83 ec 08             	sub    $0x8,%esp
  8015ad:	56                   	push   %esi
  8015ae:	6a 00                	push   $0x0
  8015b0:	e8 71 f7 ff ff       	call   800d26 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8015b5:	83 c4 08             	add    $0x8,%esp
  8015b8:	57                   	push   %edi
  8015b9:	6a 00                	push   $0x0
  8015bb:	e8 66 f7 ff ff       	call   800d26 <sys_page_unmap>
	return r;
  8015c0:	83 c4 10             	add    $0x10,%esp
  8015c3:	eb b7                	jmp    80157c <dup+0xa7>

008015c5 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015c5:	f3 0f 1e fb          	endbr32 
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
  8015cc:	53                   	push   %ebx
  8015cd:	83 ec 1c             	sub    $0x1c,%esp
  8015d0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015d3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015d6:	50                   	push   %eax
  8015d7:	53                   	push   %ebx
  8015d8:	e8 65 fd ff ff       	call   801342 <fd_lookup>
  8015dd:	83 c4 10             	add    $0x10,%esp
  8015e0:	85 c0                	test   %eax,%eax
  8015e2:	78 3f                	js     801623 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015e4:	83 ec 08             	sub    $0x8,%esp
  8015e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ea:	50                   	push   %eax
  8015eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ee:	ff 30                	pushl  (%eax)
  8015f0:	e8 a1 fd ff ff       	call   801396 <dev_lookup>
  8015f5:	83 c4 10             	add    $0x10,%esp
  8015f8:	85 c0                	test   %eax,%eax
  8015fa:	78 27                	js     801623 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015ff:	8b 42 08             	mov    0x8(%edx),%eax
  801602:	83 e0 03             	and    $0x3,%eax
  801605:	83 f8 01             	cmp    $0x1,%eax
  801608:	74 1e                	je     801628 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80160a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80160d:	8b 40 08             	mov    0x8(%eax),%eax
  801610:	85 c0                	test   %eax,%eax
  801612:	74 35                	je     801649 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801614:	83 ec 04             	sub    $0x4,%esp
  801617:	ff 75 10             	pushl  0x10(%ebp)
  80161a:	ff 75 0c             	pushl  0xc(%ebp)
  80161d:	52                   	push   %edx
  80161e:	ff d0                	call   *%eax
  801620:	83 c4 10             	add    $0x10,%esp
}
  801623:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801626:	c9                   	leave  
  801627:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801628:	a1 04 40 80 00       	mov    0x804004,%eax
  80162d:	8b 40 48             	mov    0x48(%eax),%eax
  801630:	83 ec 04             	sub    $0x4,%esp
  801633:	53                   	push   %ebx
  801634:	50                   	push   %eax
  801635:	68 a1 27 80 00       	push   $0x8027a1
  80163a:	e8 0e ec ff ff       	call   80024d <cprintf>
		return -E_INVAL;
  80163f:	83 c4 10             	add    $0x10,%esp
  801642:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801647:	eb da                	jmp    801623 <read+0x5e>
		return -E_NOT_SUPP;
  801649:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80164e:	eb d3                	jmp    801623 <read+0x5e>

00801650 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801650:	f3 0f 1e fb          	endbr32 
  801654:	55                   	push   %ebp
  801655:	89 e5                	mov    %esp,%ebp
  801657:	57                   	push   %edi
  801658:	56                   	push   %esi
  801659:	53                   	push   %ebx
  80165a:	83 ec 0c             	sub    $0xc,%esp
  80165d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801660:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801663:	bb 00 00 00 00       	mov    $0x0,%ebx
  801668:	eb 02                	jmp    80166c <readn+0x1c>
  80166a:	01 c3                	add    %eax,%ebx
  80166c:	39 f3                	cmp    %esi,%ebx
  80166e:	73 21                	jae    801691 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801670:	83 ec 04             	sub    $0x4,%esp
  801673:	89 f0                	mov    %esi,%eax
  801675:	29 d8                	sub    %ebx,%eax
  801677:	50                   	push   %eax
  801678:	89 d8                	mov    %ebx,%eax
  80167a:	03 45 0c             	add    0xc(%ebp),%eax
  80167d:	50                   	push   %eax
  80167e:	57                   	push   %edi
  80167f:	e8 41 ff ff ff       	call   8015c5 <read>
		if (m < 0)
  801684:	83 c4 10             	add    $0x10,%esp
  801687:	85 c0                	test   %eax,%eax
  801689:	78 04                	js     80168f <readn+0x3f>
			return m;
		if (m == 0)
  80168b:	75 dd                	jne    80166a <readn+0x1a>
  80168d:	eb 02                	jmp    801691 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80168f:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801691:	89 d8                	mov    %ebx,%eax
  801693:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801696:	5b                   	pop    %ebx
  801697:	5e                   	pop    %esi
  801698:	5f                   	pop    %edi
  801699:	5d                   	pop    %ebp
  80169a:	c3                   	ret    

0080169b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80169b:	f3 0f 1e fb          	endbr32 
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
  8016a2:	53                   	push   %ebx
  8016a3:	83 ec 1c             	sub    $0x1c,%esp
  8016a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016a9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016ac:	50                   	push   %eax
  8016ad:	53                   	push   %ebx
  8016ae:	e8 8f fc ff ff       	call   801342 <fd_lookup>
  8016b3:	83 c4 10             	add    $0x10,%esp
  8016b6:	85 c0                	test   %eax,%eax
  8016b8:	78 3a                	js     8016f4 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016ba:	83 ec 08             	sub    $0x8,%esp
  8016bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016c0:	50                   	push   %eax
  8016c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c4:	ff 30                	pushl  (%eax)
  8016c6:	e8 cb fc ff ff       	call   801396 <dev_lookup>
  8016cb:	83 c4 10             	add    $0x10,%esp
  8016ce:	85 c0                	test   %eax,%eax
  8016d0:	78 22                	js     8016f4 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016d9:	74 1e                	je     8016f9 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8016db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016de:	8b 52 0c             	mov    0xc(%edx),%edx
  8016e1:	85 d2                	test   %edx,%edx
  8016e3:	74 35                	je     80171a <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8016e5:	83 ec 04             	sub    $0x4,%esp
  8016e8:	ff 75 10             	pushl  0x10(%ebp)
  8016eb:	ff 75 0c             	pushl  0xc(%ebp)
  8016ee:	50                   	push   %eax
  8016ef:	ff d2                	call   *%edx
  8016f1:	83 c4 10             	add    $0x10,%esp
}
  8016f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016f7:	c9                   	leave  
  8016f8:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016f9:	a1 04 40 80 00       	mov    0x804004,%eax
  8016fe:	8b 40 48             	mov    0x48(%eax),%eax
  801701:	83 ec 04             	sub    $0x4,%esp
  801704:	53                   	push   %ebx
  801705:	50                   	push   %eax
  801706:	68 bd 27 80 00       	push   $0x8027bd
  80170b:	e8 3d eb ff ff       	call   80024d <cprintf>
		return -E_INVAL;
  801710:	83 c4 10             	add    $0x10,%esp
  801713:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801718:	eb da                	jmp    8016f4 <write+0x59>
		return -E_NOT_SUPP;
  80171a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80171f:	eb d3                	jmp    8016f4 <write+0x59>

00801721 <seek>:

int
seek(int fdnum, off_t offset)
{
  801721:	f3 0f 1e fb          	endbr32 
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
  801728:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80172b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80172e:	50                   	push   %eax
  80172f:	ff 75 08             	pushl  0x8(%ebp)
  801732:	e8 0b fc ff ff       	call   801342 <fd_lookup>
  801737:	83 c4 10             	add    $0x10,%esp
  80173a:	85 c0                	test   %eax,%eax
  80173c:	78 0e                	js     80174c <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80173e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801741:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801744:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801747:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80174c:	c9                   	leave  
  80174d:	c3                   	ret    

0080174e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80174e:	f3 0f 1e fb          	endbr32 
  801752:	55                   	push   %ebp
  801753:	89 e5                	mov    %esp,%ebp
  801755:	53                   	push   %ebx
  801756:	83 ec 1c             	sub    $0x1c,%esp
  801759:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80175c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80175f:	50                   	push   %eax
  801760:	53                   	push   %ebx
  801761:	e8 dc fb ff ff       	call   801342 <fd_lookup>
  801766:	83 c4 10             	add    $0x10,%esp
  801769:	85 c0                	test   %eax,%eax
  80176b:	78 37                	js     8017a4 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80176d:	83 ec 08             	sub    $0x8,%esp
  801770:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801773:	50                   	push   %eax
  801774:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801777:	ff 30                	pushl  (%eax)
  801779:	e8 18 fc ff ff       	call   801396 <dev_lookup>
  80177e:	83 c4 10             	add    $0x10,%esp
  801781:	85 c0                	test   %eax,%eax
  801783:	78 1f                	js     8017a4 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801785:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801788:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80178c:	74 1b                	je     8017a9 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80178e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801791:	8b 52 18             	mov    0x18(%edx),%edx
  801794:	85 d2                	test   %edx,%edx
  801796:	74 32                	je     8017ca <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801798:	83 ec 08             	sub    $0x8,%esp
  80179b:	ff 75 0c             	pushl  0xc(%ebp)
  80179e:	50                   	push   %eax
  80179f:	ff d2                	call   *%edx
  8017a1:	83 c4 10             	add    $0x10,%esp
}
  8017a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017a7:	c9                   	leave  
  8017a8:	c3                   	ret    
			thisenv->env_id, fdnum);
  8017a9:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8017ae:	8b 40 48             	mov    0x48(%eax),%eax
  8017b1:	83 ec 04             	sub    $0x4,%esp
  8017b4:	53                   	push   %ebx
  8017b5:	50                   	push   %eax
  8017b6:	68 80 27 80 00       	push   $0x802780
  8017bb:	e8 8d ea ff ff       	call   80024d <cprintf>
		return -E_INVAL;
  8017c0:	83 c4 10             	add    $0x10,%esp
  8017c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017c8:	eb da                	jmp    8017a4 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8017ca:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017cf:	eb d3                	jmp    8017a4 <ftruncate+0x56>

008017d1 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8017d1:	f3 0f 1e fb          	endbr32 
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
  8017d8:	53                   	push   %ebx
  8017d9:	83 ec 1c             	sub    $0x1c,%esp
  8017dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017df:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017e2:	50                   	push   %eax
  8017e3:	ff 75 08             	pushl  0x8(%ebp)
  8017e6:	e8 57 fb ff ff       	call   801342 <fd_lookup>
  8017eb:	83 c4 10             	add    $0x10,%esp
  8017ee:	85 c0                	test   %eax,%eax
  8017f0:	78 4b                	js     80183d <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017f2:	83 ec 08             	sub    $0x8,%esp
  8017f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017f8:	50                   	push   %eax
  8017f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017fc:	ff 30                	pushl  (%eax)
  8017fe:	e8 93 fb ff ff       	call   801396 <dev_lookup>
  801803:	83 c4 10             	add    $0x10,%esp
  801806:	85 c0                	test   %eax,%eax
  801808:	78 33                	js     80183d <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80180a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80180d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801811:	74 2f                	je     801842 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801813:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801816:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80181d:	00 00 00 
	stat->st_isdir = 0;
  801820:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801827:	00 00 00 
	stat->st_dev = dev;
  80182a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801830:	83 ec 08             	sub    $0x8,%esp
  801833:	53                   	push   %ebx
  801834:	ff 75 f0             	pushl  -0x10(%ebp)
  801837:	ff 50 14             	call   *0x14(%eax)
  80183a:	83 c4 10             	add    $0x10,%esp
}
  80183d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801840:	c9                   	leave  
  801841:	c3                   	ret    
		return -E_NOT_SUPP;
  801842:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801847:	eb f4                	jmp    80183d <fstat+0x6c>

00801849 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801849:	f3 0f 1e fb          	endbr32 
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
  801850:	56                   	push   %esi
  801851:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801852:	83 ec 08             	sub    $0x8,%esp
  801855:	6a 00                	push   $0x0
  801857:	ff 75 08             	pushl  0x8(%ebp)
  80185a:	e8 fb 01 00 00       	call   801a5a <open>
  80185f:	89 c3                	mov    %eax,%ebx
  801861:	83 c4 10             	add    $0x10,%esp
  801864:	85 c0                	test   %eax,%eax
  801866:	78 1b                	js     801883 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801868:	83 ec 08             	sub    $0x8,%esp
  80186b:	ff 75 0c             	pushl  0xc(%ebp)
  80186e:	50                   	push   %eax
  80186f:	e8 5d ff ff ff       	call   8017d1 <fstat>
  801874:	89 c6                	mov    %eax,%esi
	close(fd);
  801876:	89 1c 24             	mov    %ebx,(%esp)
  801879:	e8 fd fb ff ff       	call   80147b <close>
	return r;
  80187e:	83 c4 10             	add    $0x10,%esp
  801881:	89 f3                	mov    %esi,%ebx
}
  801883:	89 d8                	mov    %ebx,%eax
  801885:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801888:	5b                   	pop    %ebx
  801889:	5e                   	pop    %esi
  80188a:	5d                   	pop    %ebp
  80188b:	c3                   	ret    

0080188c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
  80188f:	56                   	push   %esi
  801890:	53                   	push   %ebx
  801891:	89 c6                	mov    %eax,%esi
  801893:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801895:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80189c:	74 27                	je     8018c5 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80189e:	6a 07                	push   $0x7
  8018a0:	68 00 50 80 00       	push   $0x805000
  8018a5:	56                   	push   %esi
  8018a6:	ff 35 00 40 80 00    	pushl  0x804000
  8018ac:	e8 77 f9 ff ff       	call   801228 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8018b1:	83 c4 0c             	add    $0xc,%esp
  8018b4:	6a 00                	push   $0x0
  8018b6:	53                   	push   %ebx
  8018b7:	6a 00                	push   $0x0
  8018b9:	e8 e5 f8 ff ff       	call   8011a3 <ipc_recv>
}
  8018be:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018c1:	5b                   	pop    %ebx
  8018c2:	5e                   	pop    %esi
  8018c3:	5d                   	pop    %ebp
  8018c4:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8018c5:	83 ec 0c             	sub    $0xc,%esp
  8018c8:	6a 01                	push   $0x1
  8018ca:	e8 b1 f9 ff ff       	call   801280 <ipc_find_env>
  8018cf:	a3 00 40 80 00       	mov    %eax,0x804000
  8018d4:	83 c4 10             	add    $0x10,%esp
  8018d7:	eb c5                	jmp    80189e <fsipc+0x12>

008018d9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8018d9:	f3 0f 1e fb          	endbr32 
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
  8018e0:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8018e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8018e9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8018ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f1:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8018fb:	b8 02 00 00 00       	mov    $0x2,%eax
  801900:	e8 87 ff ff ff       	call   80188c <fsipc>
}
  801905:	c9                   	leave  
  801906:	c3                   	ret    

00801907 <devfile_flush>:
{
  801907:	f3 0f 1e fb          	endbr32 
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
  80190e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801911:	8b 45 08             	mov    0x8(%ebp),%eax
  801914:	8b 40 0c             	mov    0xc(%eax),%eax
  801917:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80191c:	ba 00 00 00 00       	mov    $0x0,%edx
  801921:	b8 06 00 00 00       	mov    $0x6,%eax
  801926:	e8 61 ff ff ff       	call   80188c <fsipc>
}
  80192b:	c9                   	leave  
  80192c:	c3                   	ret    

0080192d <devfile_stat>:
{
  80192d:	f3 0f 1e fb          	endbr32 
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	53                   	push   %ebx
  801935:	83 ec 04             	sub    $0x4,%esp
  801938:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
  80193e:	8b 40 0c             	mov    0xc(%eax),%eax
  801941:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801946:	ba 00 00 00 00       	mov    $0x0,%edx
  80194b:	b8 05 00 00 00       	mov    $0x5,%eax
  801950:	e8 37 ff ff ff       	call   80188c <fsipc>
  801955:	85 c0                	test   %eax,%eax
  801957:	78 2c                	js     801985 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801959:	83 ec 08             	sub    $0x8,%esp
  80195c:	68 00 50 80 00       	push   $0x805000
  801961:	53                   	push   %ebx
  801962:	e8 f0 ee ff ff       	call   800857 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801967:	a1 80 50 80 00       	mov    0x805080,%eax
  80196c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801972:	a1 84 50 80 00       	mov    0x805084,%eax
  801977:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80197d:	83 c4 10             	add    $0x10,%esp
  801980:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801985:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801988:	c9                   	leave  
  801989:	c3                   	ret    

0080198a <devfile_write>:
{
  80198a:	f3 0f 1e fb          	endbr32 
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
  801991:	83 ec 0c             	sub    $0xc,%esp
  801994:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801997:	8b 55 08             	mov    0x8(%ebp),%edx
  80199a:	8b 52 0c             	mov    0xc(%edx),%edx
  80199d:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  8019a3:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8019a8:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8019ad:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  8019b0:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  8019b5:	50                   	push   %eax
  8019b6:	ff 75 0c             	pushl  0xc(%ebp)
  8019b9:	68 08 50 80 00       	push   $0x805008
  8019be:	e8 4a f0 ff ff       	call   800a0d <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  8019c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c8:	b8 04 00 00 00       	mov    $0x4,%eax
  8019cd:	e8 ba fe ff ff       	call   80188c <fsipc>
}
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <devfile_read>:
{
  8019d4:	f3 0f 1e fb          	endbr32 
  8019d8:	55                   	push   %ebp
  8019d9:	89 e5                	mov    %esp,%ebp
  8019db:	56                   	push   %esi
  8019dc:	53                   	push   %ebx
  8019dd:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8019e6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8019eb:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f6:	b8 03 00 00 00       	mov    $0x3,%eax
  8019fb:	e8 8c fe ff ff       	call   80188c <fsipc>
  801a00:	89 c3                	mov    %eax,%ebx
  801a02:	85 c0                	test   %eax,%eax
  801a04:	78 1f                	js     801a25 <devfile_read+0x51>
	assert(r <= n);
  801a06:	39 f0                	cmp    %esi,%eax
  801a08:	77 24                	ja     801a2e <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801a0a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a0f:	7f 33                	jg     801a44 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a11:	83 ec 04             	sub    $0x4,%esp
  801a14:	50                   	push   %eax
  801a15:	68 00 50 80 00       	push   $0x805000
  801a1a:	ff 75 0c             	pushl  0xc(%ebp)
  801a1d:	e8 eb ef ff ff       	call   800a0d <memmove>
	return r;
  801a22:	83 c4 10             	add    $0x10,%esp
}
  801a25:	89 d8                	mov    %ebx,%eax
  801a27:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a2a:	5b                   	pop    %ebx
  801a2b:	5e                   	pop    %esi
  801a2c:	5d                   	pop    %ebp
  801a2d:	c3                   	ret    
	assert(r <= n);
  801a2e:	68 ec 27 80 00       	push   $0x8027ec
  801a33:	68 f3 27 80 00       	push   $0x8027f3
  801a38:	6a 7c                	push   $0x7c
  801a3a:	68 08 28 80 00       	push   $0x802808
  801a3f:	e8 22 e7 ff ff       	call   800166 <_panic>
	assert(r <= PGSIZE);
  801a44:	68 13 28 80 00       	push   $0x802813
  801a49:	68 f3 27 80 00       	push   $0x8027f3
  801a4e:	6a 7d                	push   $0x7d
  801a50:	68 08 28 80 00       	push   $0x802808
  801a55:	e8 0c e7 ff ff       	call   800166 <_panic>

00801a5a <open>:
{
  801a5a:	f3 0f 1e fb          	endbr32 
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
  801a61:	56                   	push   %esi
  801a62:	53                   	push   %ebx
  801a63:	83 ec 1c             	sub    $0x1c,%esp
  801a66:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a69:	56                   	push   %esi
  801a6a:	e8 a5 ed ff ff       	call   800814 <strlen>
  801a6f:	83 c4 10             	add    $0x10,%esp
  801a72:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a77:	7f 6c                	jg     801ae5 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801a79:	83 ec 0c             	sub    $0xc,%esp
  801a7c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a7f:	50                   	push   %eax
  801a80:	e8 67 f8 ff ff       	call   8012ec <fd_alloc>
  801a85:	89 c3                	mov    %eax,%ebx
  801a87:	83 c4 10             	add    $0x10,%esp
  801a8a:	85 c0                	test   %eax,%eax
  801a8c:	78 3c                	js     801aca <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801a8e:	83 ec 08             	sub    $0x8,%esp
  801a91:	56                   	push   %esi
  801a92:	68 00 50 80 00       	push   $0x805000
  801a97:	e8 bb ed ff ff       	call   800857 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a9f:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801aa4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aa7:	b8 01 00 00 00       	mov    $0x1,%eax
  801aac:	e8 db fd ff ff       	call   80188c <fsipc>
  801ab1:	89 c3                	mov    %eax,%ebx
  801ab3:	83 c4 10             	add    $0x10,%esp
  801ab6:	85 c0                	test   %eax,%eax
  801ab8:	78 19                	js     801ad3 <open+0x79>
	return fd2num(fd);
  801aba:	83 ec 0c             	sub    $0xc,%esp
  801abd:	ff 75 f4             	pushl  -0xc(%ebp)
  801ac0:	e8 f8 f7 ff ff       	call   8012bd <fd2num>
  801ac5:	89 c3                	mov    %eax,%ebx
  801ac7:	83 c4 10             	add    $0x10,%esp
}
  801aca:	89 d8                	mov    %ebx,%eax
  801acc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801acf:	5b                   	pop    %ebx
  801ad0:	5e                   	pop    %esi
  801ad1:	5d                   	pop    %ebp
  801ad2:	c3                   	ret    
		fd_close(fd, 0);
  801ad3:	83 ec 08             	sub    $0x8,%esp
  801ad6:	6a 00                	push   $0x0
  801ad8:	ff 75 f4             	pushl  -0xc(%ebp)
  801adb:	e8 10 f9 ff ff       	call   8013f0 <fd_close>
		return r;
  801ae0:	83 c4 10             	add    $0x10,%esp
  801ae3:	eb e5                	jmp    801aca <open+0x70>
		return -E_BAD_PATH;
  801ae5:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801aea:	eb de                	jmp    801aca <open+0x70>

00801aec <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801aec:	f3 0f 1e fb          	endbr32 
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
  801af3:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801af6:	ba 00 00 00 00       	mov    $0x0,%edx
  801afb:	b8 08 00 00 00       	mov    $0x8,%eax
  801b00:	e8 87 fd ff ff       	call   80188c <fsipc>
}
  801b05:	c9                   	leave  
  801b06:	c3                   	ret    

00801b07 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b07:	f3 0f 1e fb          	endbr32 
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
  801b0e:	56                   	push   %esi
  801b0f:	53                   	push   %ebx
  801b10:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b13:	83 ec 0c             	sub    $0xc,%esp
  801b16:	ff 75 08             	pushl  0x8(%ebp)
  801b19:	e8 b3 f7 ff ff       	call   8012d1 <fd2data>
  801b1e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b20:	83 c4 08             	add    $0x8,%esp
  801b23:	68 1f 28 80 00       	push   $0x80281f
  801b28:	53                   	push   %ebx
  801b29:	e8 29 ed ff ff       	call   800857 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b2e:	8b 46 04             	mov    0x4(%esi),%eax
  801b31:	2b 06                	sub    (%esi),%eax
  801b33:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b39:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b40:	00 00 00 
	stat->st_dev = &devpipe;
  801b43:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801b4a:	30 80 00 
	return 0;
}
  801b4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801b52:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b55:	5b                   	pop    %ebx
  801b56:	5e                   	pop    %esi
  801b57:	5d                   	pop    %ebp
  801b58:	c3                   	ret    

00801b59 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b59:	f3 0f 1e fb          	endbr32 
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
  801b60:	53                   	push   %ebx
  801b61:	83 ec 0c             	sub    $0xc,%esp
  801b64:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b67:	53                   	push   %ebx
  801b68:	6a 00                	push   $0x0
  801b6a:	e8 b7 f1 ff ff       	call   800d26 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b6f:	89 1c 24             	mov    %ebx,(%esp)
  801b72:	e8 5a f7 ff ff       	call   8012d1 <fd2data>
  801b77:	83 c4 08             	add    $0x8,%esp
  801b7a:	50                   	push   %eax
  801b7b:	6a 00                	push   $0x0
  801b7d:	e8 a4 f1 ff ff       	call   800d26 <sys_page_unmap>
}
  801b82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b85:	c9                   	leave  
  801b86:	c3                   	ret    

00801b87 <_pipeisclosed>:
{
  801b87:	55                   	push   %ebp
  801b88:	89 e5                	mov    %esp,%ebp
  801b8a:	57                   	push   %edi
  801b8b:	56                   	push   %esi
  801b8c:	53                   	push   %ebx
  801b8d:	83 ec 1c             	sub    $0x1c,%esp
  801b90:	89 c7                	mov    %eax,%edi
  801b92:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b94:	a1 04 40 80 00       	mov    0x804004,%eax
  801b99:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b9c:	83 ec 0c             	sub    $0xc,%esp
  801b9f:	57                   	push   %edi
  801ba0:	e8 f6 04 00 00       	call   80209b <pageref>
  801ba5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ba8:	89 34 24             	mov    %esi,(%esp)
  801bab:	e8 eb 04 00 00       	call   80209b <pageref>
		nn = thisenv->env_runs;
  801bb0:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801bb6:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801bb9:	83 c4 10             	add    $0x10,%esp
  801bbc:	39 cb                	cmp    %ecx,%ebx
  801bbe:	74 1b                	je     801bdb <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801bc0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bc3:	75 cf                	jne    801b94 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801bc5:	8b 42 58             	mov    0x58(%edx),%eax
  801bc8:	6a 01                	push   $0x1
  801bca:	50                   	push   %eax
  801bcb:	53                   	push   %ebx
  801bcc:	68 26 28 80 00       	push   $0x802826
  801bd1:	e8 77 e6 ff ff       	call   80024d <cprintf>
  801bd6:	83 c4 10             	add    $0x10,%esp
  801bd9:	eb b9                	jmp    801b94 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801bdb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bde:	0f 94 c0             	sete   %al
  801be1:	0f b6 c0             	movzbl %al,%eax
}
  801be4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801be7:	5b                   	pop    %ebx
  801be8:	5e                   	pop    %esi
  801be9:	5f                   	pop    %edi
  801bea:	5d                   	pop    %ebp
  801beb:	c3                   	ret    

00801bec <devpipe_write>:
{
  801bec:	f3 0f 1e fb          	endbr32 
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
  801bf3:	57                   	push   %edi
  801bf4:	56                   	push   %esi
  801bf5:	53                   	push   %ebx
  801bf6:	83 ec 28             	sub    $0x28,%esp
  801bf9:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801bfc:	56                   	push   %esi
  801bfd:	e8 cf f6 ff ff       	call   8012d1 <fd2data>
  801c02:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c04:	83 c4 10             	add    $0x10,%esp
  801c07:	bf 00 00 00 00       	mov    $0x0,%edi
  801c0c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c0f:	74 4f                	je     801c60 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c11:	8b 43 04             	mov    0x4(%ebx),%eax
  801c14:	8b 0b                	mov    (%ebx),%ecx
  801c16:	8d 51 20             	lea    0x20(%ecx),%edx
  801c19:	39 d0                	cmp    %edx,%eax
  801c1b:	72 14                	jb     801c31 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801c1d:	89 da                	mov    %ebx,%edx
  801c1f:	89 f0                	mov    %esi,%eax
  801c21:	e8 61 ff ff ff       	call   801b87 <_pipeisclosed>
  801c26:	85 c0                	test   %eax,%eax
  801c28:	75 3b                	jne    801c65 <devpipe_write+0x79>
			sys_yield();
  801c2a:	e8 47 f0 ff ff       	call   800c76 <sys_yield>
  801c2f:	eb e0                	jmp    801c11 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c34:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c38:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c3b:	89 c2                	mov    %eax,%edx
  801c3d:	c1 fa 1f             	sar    $0x1f,%edx
  801c40:	89 d1                	mov    %edx,%ecx
  801c42:	c1 e9 1b             	shr    $0x1b,%ecx
  801c45:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c48:	83 e2 1f             	and    $0x1f,%edx
  801c4b:	29 ca                	sub    %ecx,%edx
  801c4d:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c51:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c55:	83 c0 01             	add    $0x1,%eax
  801c58:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c5b:	83 c7 01             	add    $0x1,%edi
  801c5e:	eb ac                	jmp    801c0c <devpipe_write+0x20>
	return i;
  801c60:	8b 45 10             	mov    0x10(%ebp),%eax
  801c63:	eb 05                	jmp    801c6a <devpipe_write+0x7e>
				return 0;
  801c65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c6d:	5b                   	pop    %ebx
  801c6e:	5e                   	pop    %esi
  801c6f:	5f                   	pop    %edi
  801c70:	5d                   	pop    %ebp
  801c71:	c3                   	ret    

00801c72 <devpipe_read>:
{
  801c72:	f3 0f 1e fb          	endbr32 
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
  801c79:	57                   	push   %edi
  801c7a:	56                   	push   %esi
  801c7b:	53                   	push   %ebx
  801c7c:	83 ec 18             	sub    $0x18,%esp
  801c7f:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c82:	57                   	push   %edi
  801c83:	e8 49 f6 ff ff       	call   8012d1 <fd2data>
  801c88:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c8a:	83 c4 10             	add    $0x10,%esp
  801c8d:	be 00 00 00 00       	mov    $0x0,%esi
  801c92:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c95:	75 14                	jne    801cab <devpipe_read+0x39>
	return i;
  801c97:	8b 45 10             	mov    0x10(%ebp),%eax
  801c9a:	eb 02                	jmp    801c9e <devpipe_read+0x2c>
				return i;
  801c9c:	89 f0                	mov    %esi,%eax
}
  801c9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ca1:	5b                   	pop    %ebx
  801ca2:	5e                   	pop    %esi
  801ca3:	5f                   	pop    %edi
  801ca4:	5d                   	pop    %ebp
  801ca5:	c3                   	ret    
			sys_yield();
  801ca6:	e8 cb ef ff ff       	call   800c76 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801cab:	8b 03                	mov    (%ebx),%eax
  801cad:	3b 43 04             	cmp    0x4(%ebx),%eax
  801cb0:	75 18                	jne    801cca <devpipe_read+0x58>
			if (i > 0)
  801cb2:	85 f6                	test   %esi,%esi
  801cb4:	75 e6                	jne    801c9c <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801cb6:	89 da                	mov    %ebx,%edx
  801cb8:	89 f8                	mov    %edi,%eax
  801cba:	e8 c8 fe ff ff       	call   801b87 <_pipeisclosed>
  801cbf:	85 c0                	test   %eax,%eax
  801cc1:	74 e3                	je     801ca6 <devpipe_read+0x34>
				return 0;
  801cc3:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc8:	eb d4                	jmp    801c9e <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801cca:	99                   	cltd   
  801ccb:	c1 ea 1b             	shr    $0x1b,%edx
  801cce:	01 d0                	add    %edx,%eax
  801cd0:	83 e0 1f             	and    $0x1f,%eax
  801cd3:	29 d0                	sub    %edx,%eax
  801cd5:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801cda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cdd:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801ce0:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801ce3:	83 c6 01             	add    $0x1,%esi
  801ce6:	eb aa                	jmp    801c92 <devpipe_read+0x20>

00801ce8 <pipe>:
{
  801ce8:	f3 0f 1e fb          	endbr32 
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
  801cef:	56                   	push   %esi
  801cf0:	53                   	push   %ebx
  801cf1:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801cf4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cf7:	50                   	push   %eax
  801cf8:	e8 ef f5 ff ff       	call   8012ec <fd_alloc>
  801cfd:	89 c3                	mov    %eax,%ebx
  801cff:	83 c4 10             	add    $0x10,%esp
  801d02:	85 c0                	test   %eax,%eax
  801d04:	0f 88 23 01 00 00    	js     801e2d <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d0a:	83 ec 04             	sub    $0x4,%esp
  801d0d:	68 07 04 00 00       	push   $0x407
  801d12:	ff 75 f4             	pushl  -0xc(%ebp)
  801d15:	6a 00                	push   $0x0
  801d17:	e8 7d ef ff ff       	call   800c99 <sys_page_alloc>
  801d1c:	89 c3                	mov    %eax,%ebx
  801d1e:	83 c4 10             	add    $0x10,%esp
  801d21:	85 c0                	test   %eax,%eax
  801d23:	0f 88 04 01 00 00    	js     801e2d <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801d29:	83 ec 0c             	sub    $0xc,%esp
  801d2c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d2f:	50                   	push   %eax
  801d30:	e8 b7 f5 ff ff       	call   8012ec <fd_alloc>
  801d35:	89 c3                	mov    %eax,%ebx
  801d37:	83 c4 10             	add    $0x10,%esp
  801d3a:	85 c0                	test   %eax,%eax
  801d3c:	0f 88 db 00 00 00    	js     801e1d <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d42:	83 ec 04             	sub    $0x4,%esp
  801d45:	68 07 04 00 00       	push   $0x407
  801d4a:	ff 75 f0             	pushl  -0x10(%ebp)
  801d4d:	6a 00                	push   $0x0
  801d4f:	e8 45 ef ff ff       	call   800c99 <sys_page_alloc>
  801d54:	89 c3                	mov    %eax,%ebx
  801d56:	83 c4 10             	add    $0x10,%esp
  801d59:	85 c0                	test   %eax,%eax
  801d5b:	0f 88 bc 00 00 00    	js     801e1d <pipe+0x135>
	va = fd2data(fd0);
  801d61:	83 ec 0c             	sub    $0xc,%esp
  801d64:	ff 75 f4             	pushl  -0xc(%ebp)
  801d67:	e8 65 f5 ff ff       	call   8012d1 <fd2data>
  801d6c:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d6e:	83 c4 0c             	add    $0xc,%esp
  801d71:	68 07 04 00 00       	push   $0x407
  801d76:	50                   	push   %eax
  801d77:	6a 00                	push   $0x0
  801d79:	e8 1b ef ff ff       	call   800c99 <sys_page_alloc>
  801d7e:	89 c3                	mov    %eax,%ebx
  801d80:	83 c4 10             	add    $0x10,%esp
  801d83:	85 c0                	test   %eax,%eax
  801d85:	0f 88 82 00 00 00    	js     801e0d <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d8b:	83 ec 0c             	sub    $0xc,%esp
  801d8e:	ff 75 f0             	pushl  -0x10(%ebp)
  801d91:	e8 3b f5 ff ff       	call   8012d1 <fd2data>
  801d96:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d9d:	50                   	push   %eax
  801d9e:	6a 00                	push   $0x0
  801da0:	56                   	push   %esi
  801da1:	6a 00                	push   $0x0
  801da3:	e8 38 ef ff ff       	call   800ce0 <sys_page_map>
  801da8:	89 c3                	mov    %eax,%ebx
  801daa:	83 c4 20             	add    $0x20,%esp
  801dad:	85 c0                	test   %eax,%eax
  801daf:	78 4e                	js     801dff <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801db1:	a1 20 30 80 00       	mov    0x803020,%eax
  801db6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801db9:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801dbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dbe:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801dc5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dc8:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801dca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dcd:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801dd4:	83 ec 0c             	sub    $0xc,%esp
  801dd7:	ff 75 f4             	pushl  -0xc(%ebp)
  801dda:	e8 de f4 ff ff       	call   8012bd <fd2num>
  801ddf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801de2:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801de4:	83 c4 04             	add    $0x4,%esp
  801de7:	ff 75 f0             	pushl  -0x10(%ebp)
  801dea:	e8 ce f4 ff ff       	call   8012bd <fd2num>
  801def:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801df2:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801df5:	83 c4 10             	add    $0x10,%esp
  801df8:	bb 00 00 00 00       	mov    $0x0,%ebx
  801dfd:	eb 2e                	jmp    801e2d <pipe+0x145>
	sys_page_unmap(0, va);
  801dff:	83 ec 08             	sub    $0x8,%esp
  801e02:	56                   	push   %esi
  801e03:	6a 00                	push   $0x0
  801e05:	e8 1c ef ff ff       	call   800d26 <sys_page_unmap>
  801e0a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e0d:	83 ec 08             	sub    $0x8,%esp
  801e10:	ff 75 f0             	pushl  -0x10(%ebp)
  801e13:	6a 00                	push   $0x0
  801e15:	e8 0c ef ff ff       	call   800d26 <sys_page_unmap>
  801e1a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801e1d:	83 ec 08             	sub    $0x8,%esp
  801e20:	ff 75 f4             	pushl  -0xc(%ebp)
  801e23:	6a 00                	push   $0x0
  801e25:	e8 fc ee ff ff       	call   800d26 <sys_page_unmap>
  801e2a:	83 c4 10             	add    $0x10,%esp
}
  801e2d:	89 d8                	mov    %ebx,%eax
  801e2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e32:	5b                   	pop    %ebx
  801e33:	5e                   	pop    %esi
  801e34:	5d                   	pop    %ebp
  801e35:	c3                   	ret    

00801e36 <pipeisclosed>:
{
  801e36:	f3 0f 1e fb          	endbr32 
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
  801e3d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e40:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e43:	50                   	push   %eax
  801e44:	ff 75 08             	pushl  0x8(%ebp)
  801e47:	e8 f6 f4 ff ff       	call   801342 <fd_lookup>
  801e4c:	83 c4 10             	add    $0x10,%esp
  801e4f:	85 c0                	test   %eax,%eax
  801e51:	78 18                	js     801e6b <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801e53:	83 ec 0c             	sub    $0xc,%esp
  801e56:	ff 75 f4             	pushl  -0xc(%ebp)
  801e59:	e8 73 f4 ff ff       	call   8012d1 <fd2data>
  801e5e:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e63:	e8 1f fd ff ff       	call   801b87 <_pipeisclosed>
  801e68:	83 c4 10             	add    $0x10,%esp
}
  801e6b:	c9                   	leave  
  801e6c:	c3                   	ret    

00801e6d <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801e6d:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801e71:	b8 00 00 00 00       	mov    $0x0,%eax
  801e76:	c3                   	ret    

00801e77 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e77:	f3 0f 1e fb          	endbr32 
  801e7b:	55                   	push   %ebp
  801e7c:	89 e5                	mov    %esp,%ebp
  801e7e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801e81:	68 3e 28 80 00       	push   $0x80283e
  801e86:	ff 75 0c             	pushl  0xc(%ebp)
  801e89:	e8 c9 e9 ff ff       	call   800857 <strcpy>
	return 0;
}
  801e8e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e93:	c9                   	leave  
  801e94:	c3                   	ret    

00801e95 <devcons_write>:
{
  801e95:	f3 0f 1e fb          	endbr32 
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
  801e9c:	57                   	push   %edi
  801e9d:	56                   	push   %esi
  801e9e:	53                   	push   %ebx
  801e9f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801ea5:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801eaa:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801eb0:	3b 75 10             	cmp    0x10(%ebp),%esi
  801eb3:	73 31                	jae    801ee6 <devcons_write+0x51>
		m = n - tot;
  801eb5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801eb8:	29 f3                	sub    %esi,%ebx
  801eba:	83 fb 7f             	cmp    $0x7f,%ebx
  801ebd:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801ec2:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801ec5:	83 ec 04             	sub    $0x4,%esp
  801ec8:	53                   	push   %ebx
  801ec9:	89 f0                	mov    %esi,%eax
  801ecb:	03 45 0c             	add    0xc(%ebp),%eax
  801ece:	50                   	push   %eax
  801ecf:	57                   	push   %edi
  801ed0:	e8 38 eb ff ff       	call   800a0d <memmove>
		sys_cputs(buf, m);
  801ed5:	83 c4 08             	add    $0x8,%esp
  801ed8:	53                   	push   %ebx
  801ed9:	57                   	push   %edi
  801eda:	e8 ea ec ff ff       	call   800bc9 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801edf:	01 de                	add    %ebx,%esi
  801ee1:	83 c4 10             	add    $0x10,%esp
  801ee4:	eb ca                	jmp    801eb0 <devcons_write+0x1b>
}
  801ee6:	89 f0                	mov    %esi,%eax
  801ee8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801eeb:	5b                   	pop    %ebx
  801eec:	5e                   	pop    %esi
  801eed:	5f                   	pop    %edi
  801eee:	5d                   	pop    %ebp
  801eef:	c3                   	ret    

00801ef0 <devcons_read>:
{
  801ef0:	f3 0f 1e fb          	endbr32 
  801ef4:	55                   	push   %ebp
  801ef5:	89 e5                	mov    %esp,%ebp
  801ef7:	83 ec 08             	sub    $0x8,%esp
  801efa:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801eff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f03:	74 21                	je     801f26 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801f05:	e8 e1 ec ff ff       	call   800beb <sys_cgetc>
  801f0a:	85 c0                	test   %eax,%eax
  801f0c:	75 07                	jne    801f15 <devcons_read+0x25>
		sys_yield();
  801f0e:	e8 63 ed ff ff       	call   800c76 <sys_yield>
  801f13:	eb f0                	jmp    801f05 <devcons_read+0x15>
	if (c < 0)
  801f15:	78 0f                	js     801f26 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801f17:	83 f8 04             	cmp    $0x4,%eax
  801f1a:	74 0c                	je     801f28 <devcons_read+0x38>
	*(char*)vbuf = c;
  801f1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f1f:	88 02                	mov    %al,(%edx)
	return 1;
  801f21:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801f26:	c9                   	leave  
  801f27:	c3                   	ret    
		return 0;
  801f28:	b8 00 00 00 00       	mov    $0x0,%eax
  801f2d:	eb f7                	jmp    801f26 <devcons_read+0x36>

00801f2f <cputchar>:
{
  801f2f:	f3 0f 1e fb          	endbr32 
  801f33:	55                   	push   %ebp
  801f34:	89 e5                	mov    %esp,%ebp
  801f36:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f39:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3c:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801f3f:	6a 01                	push   $0x1
  801f41:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f44:	50                   	push   %eax
  801f45:	e8 7f ec ff ff       	call   800bc9 <sys_cputs>
}
  801f4a:	83 c4 10             	add    $0x10,%esp
  801f4d:	c9                   	leave  
  801f4e:	c3                   	ret    

00801f4f <getchar>:
{
  801f4f:	f3 0f 1e fb          	endbr32 
  801f53:	55                   	push   %ebp
  801f54:	89 e5                	mov    %esp,%ebp
  801f56:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801f59:	6a 01                	push   $0x1
  801f5b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f5e:	50                   	push   %eax
  801f5f:	6a 00                	push   $0x0
  801f61:	e8 5f f6 ff ff       	call   8015c5 <read>
	if (r < 0)
  801f66:	83 c4 10             	add    $0x10,%esp
  801f69:	85 c0                	test   %eax,%eax
  801f6b:	78 06                	js     801f73 <getchar+0x24>
	if (r < 1)
  801f6d:	74 06                	je     801f75 <getchar+0x26>
	return c;
  801f6f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801f73:	c9                   	leave  
  801f74:	c3                   	ret    
		return -E_EOF;
  801f75:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801f7a:	eb f7                	jmp    801f73 <getchar+0x24>

00801f7c <iscons>:
{
  801f7c:	f3 0f 1e fb          	endbr32 
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
  801f83:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f86:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f89:	50                   	push   %eax
  801f8a:	ff 75 08             	pushl  0x8(%ebp)
  801f8d:	e8 b0 f3 ff ff       	call   801342 <fd_lookup>
  801f92:	83 c4 10             	add    $0x10,%esp
  801f95:	85 c0                	test   %eax,%eax
  801f97:	78 11                	js     801faa <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9c:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801fa2:	39 10                	cmp    %edx,(%eax)
  801fa4:	0f 94 c0             	sete   %al
  801fa7:	0f b6 c0             	movzbl %al,%eax
}
  801faa:	c9                   	leave  
  801fab:	c3                   	ret    

00801fac <opencons>:
{
  801fac:	f3 0f 1e fb          	endbr32 
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
  801fb3:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801fb6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fb9:	50                   	push   %eax
  801fba:	e8 2d f3 ff ff       	call   8012ec <fd_alloc>
  801fbf:	83 c4 10             	add    $0x10,%esp
  801fc2:	85 c0                	test   %eax,%eax
  801fc4:	78 3a                	js     802000 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801fc6:	83 ec 04             	sub    $0x4,%esp
  801fc9:	68 07 04 00 00       	push   $0x407
  801fce:	ff 75 f4             	pushl  -0xc(%ebp)
  801fd1:	6a 00                	push   $0x0
  801fd3:	e8 c1 ec ff ff       	call   800c99 <sys_page_alloc>
  801fd8:	83 c4 10             	add    $0x10,%esp
  801fdb:	85 c0                	test   %eax,%eax
  801fdd:	78 21                	js     802000 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe2:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801fe8:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fed:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801ff4:	83 ec 0c             	sub    $0xc,%esp
  801ff7:	50                   	push   %eax
  801ff8:	e8 c0 f2 ff ff       	call   8012bd <fd2num>
  801ffd:	83 c4 10             	add    $0x10,%esp
}
  802000:	c9                   	leave  
  802001:	c3                   	ret    

00802002 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802002:	f3 0f 1e fb          	endbr32 
  802006:	55                   	push   %ebp
  802007:	89 e5                	mov    %esp,%ebp
  802009:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80200c:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  802013:	74 0a                	je     80201f <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802015:	8b 45 08             	mov    0x8(%ebp),%eax
  802018:	a3 00 60 80 00       	mov    %eax,0x806000
}
  80201d:	c9                   	leave  
  80201e:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  80201f:	83 ec 04             	sub    $0x4,%esp
  802022:	6a 07                	push   $0x7
  802024:	68 00 f0 bf ee       	push   $0xeebff000
  802029:	6a 00                	push   $0x0
  80202b:	e8 69 ec ff ff       	call   800c99 <sys_page_alloc>
  802030:	83 c4 10             	add    $0x10,%esp
  802033:	85 c0                	test   %eax,%eax
  802035:	78 2a                	js     802061 <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  802037:	83 ec 08             	sub    $0x8,%esp
  80203a:	68 75 20 80 00       	push   $0x802075
  80203f:	6a 00                	push   $0x0
  802041:	e8 b2 ed ff ff       	call   800df8 <sys_env_set_pgfault_upcall>
  802046:	83 c4 10             	add    $0x10,%esp
  802049:	85 c0                	test   %eax,%eax
  80204b:	79 c8                	jns    802015 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  80204d:	83 ec 04             	sub    $0x4,%esp
  802050:	68 78 28 80 00       	push   $0x802878
  802055:	6a 25                	push   $0x25
  802057:	68 b0 28 80 00       	push   $0x8028b0
  80205c:	e8 05 e1 ff ff       	call   800166 <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  802061:	83 ec 04             	sub    $0x4,%esp
  802064:	68 4c 28 80 00       	push   $0x80284c
  802069:	6a 22                	push   $0x22
  80206b:	68 b0 28 80 00       	push   $0x8028b0
  802070:	e8 f1 e0 ff ff       	call   800166 <_panic>

00802075 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802075:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802076:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  80207b:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80207d:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  802080:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  802084:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  802088:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80208b:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  80208d:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  802091:	83 c4 08             	add    $0x8,%esp
	popal
  802094:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  802095:	83 c4 04             	add    $0x4,%esp
	popfl
  802098:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  802099:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  80209a:	c3                   	ret    

0080209b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80209b:	f3 0f 1e fb          	endbr32 
  80209f:	55                   	push   %ebp
  8020a0:	89 e5                	mov    %esp,%ebp
  8020a2:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8020a5:	89 c2                	mov    %eax,%edx
  8020a7:	c1 ea 16             	shr    $0x16,%edx
  8020aa:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8020b1:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8020b6:	f6 c1 01             	test   $0x1,%cl
  8020b9:	74 1c                	je     8020d7 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8020bb:	c1 e8 0c             	shr    $0xc,%eax
  8020be:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8020c5:	a8 01                	test   $0x1,%al
  8020c7:	74 0e                	je     8020d7 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020c9:	c1 e8 0c             	shr    $0xc,%eax
  8020cc:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8020d3:	ef 
  8020d4:	0f b7 d2             	movzwl %dx,%edx
}
  8020d7:	89 d0                	mov    %edx,%eax
  8020d9:	5d                   	pop    %ebp
  8020da:	c3                   	ret    
  8020db:	66 90                	xchg   %ax,%ax
  8020dd:	66 90                	xchg   %ax,%ax
  8020df:	90                   	nop

008020e0 <__udivdi3>:
  8020e0:	f3 0f 1e fb          	endbr32 
  8020e4:	55                   	push   %ebp
  8020e5:	57                   	push   %edi
  8020e6:	56                   	push   %esi
  8020e7:	53                   	push   %ebx
  8020e8:	83 ec 1c             	sub    $0x1c,%esp
  8020eb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8020ef:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8020f3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8020f7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8020fb:	85 d2                	test   %edx,%edx
  8020fd:	75 19                	jne    802118 <__udivdi3+0x38>
  8020ff:	39 f3                	cmp    %esi,%ebx
  802101:	76 4d                	jbe    802150 <__udivdi3+0x70>
  802103:	31 ff                	xor    %edi,%edi
  802105:	89 e8                	mov    %ebp,%eax
  802107:	89 f2                	mov    %esi,%edx
  802109:	f7 f3                	div    %ebx
  80210b:	89 fa                	mov    %edi,%edx
  80210d:	83 c4 1c             	add    $0x1c,%esp
  802110:	5b                   	pop    %ebx
  802111:	5e                   	pop    %esi
  802112:	5f                   	pop    %edi
  802113:	5d                   	pop    %ebp
  802114:	c3                   	ret    
  802115:	8d 76 00             	lea    0x0(%esi),%esi
  802118:	39 f2                	cmp    %esi,%edx
  80211a:	76 14                	jbe    802130 <__udivdi3+0x50>
  80211c:	31 ff                	xor    %edi,%edi
  80211e:	31 c0                	xor    %eax,%eax
  802120:	89 fa                	mov    %edi,%edx
  802122:	83 c4 1c             	add    $0x1c,%esp
  802125:	5b                   	pop    %ebx
  802126:	5e                   	pop    %esi
  802127:	5f                   	pop    %edi
  802128:	5d                   	pop    %ebp
  802129:	c3                   	ret    
  80212a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802130:	0f bd fa             	bsr    %edx,%edi
  802133:	83 f7 1f             	xor    $0x1f,%edi
  802136:	75 48                	jne    802180 <__udivdi3+0xa0>
  802138:	39 f2                	cmp    %esi,%edx
  80213a:	72 06                	jb     802142 <__udivdi3+0x62>
  80213c:	31 c0                	xor    %eax,%eax
  80213e:	39 eb                	cmp    %ebp,%ebx
  802140:	77 de                	ja     802120 <__udivdi3+0x40>
  802142:	b8 01 00 00 00       	mov    $0x1,%eax
  802147:	eb d7                	jmp    802120 <__udivdi3+0x40>
  802149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802150:	89 d9                	mov    %ebx,%ecx
  802152:	85 db                	test   %ebx,%ebx
  802154:	75 0b                	jne    802161 <__udivdi3+0x81>
  802156:	b8 01 00 00 00       	mov    $0x1,%eax
  80215b:	31 d2                	xor    %edx,%edx
  80215d:	f7 f3                	div    %ebx
  80215f:	89 c1                	mov    %eax,%ecx
  802161:	31 d2                	xor    %edx,%edx
  802163:	89 f0                	mov    %esi,%eax
  802165:	f7 f1                	div    %ecx
  802167:	89 c6                	mov    %eax,%esi
  802169:	89 e8                	mov    %ebp,%eax
  80216b:	89 f7                	mov    %esi,%edi
  80216d:	f7 f1                	div    %ecx
  80216f:	89 fa                	mov    %edi,%edx
  802171:	83 c4 1c             	add    $0x1c,%esp
  802174:	5b                   	pop    %ebx
  802175:	5e                   	pop    %esi
  802176:	5f                   	pop    %edi
  802177:	5d                   	pop    %ebp
  802178:	c3                   	ret    
  802179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802180:	89 f9                	mov    %edi,%ecx
  802182:	b8 20 00 00 00       	mov    $0x20,%eax
  802187:	29 f8                	sub    %edi,%eax
  802189:	d3 e2                	shl    %cl,%edx
  80218b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80218f:	89 c1                	mov    %eax,%ecx
  802191:	89 da                	mov    %ebx,%edx
  802193:	d3 ea                	shr    %cl,%edx
  802195:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802199:	09 d1                	or     %edx,%ecx
  80219b:	89 f2                	mov    %esi,%edx
  80219d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021a1:	89 f9                	mov    %edi,%ecx
  8021a3:	d3 e3                	shl    %cl,%ebx
  8021a5:	89 c1                	mov    %eax,%ecx
  8021a7:	d3 ea                	shr    %cl,%edx
  8021a9:	89 f9                	mov    %edi,%ecx
  8021ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8021af:	89 eb                	mov    %ebp,%ebx
  8021b1:	d3 e6                	shl    %cl,%esi
  8021b3:	89 c1                	mov    %eax,%ecx
  8021b5:	d3 eb                	shr    %cl,%ebx
  8021b7:	09 de                	or     %ebx,%esi
  8021b9:	89 f0                	mov    %esi,%eax
  8021bb:	f7 74 24 08          	divl   0x8(%esp)
  8021bf:	89 d6                	mov    %edx,%esi
  8021c1:	89 c3                	mov    %eax,%ebx
  8021c3:	f7 64 24 0c          	mull   0xc(%esp)
  8021c7:	39 d6                	cmp    %edx,%esi
  8021c9:	72 15                	jb     8021e0 <__udivdi3+0x100>
  8021cb:	89 f9                	mov    %edi,%ecx
  8021cd:	d3 e5                	shl    %cl,%ebp
  8021cf:	39 c5                	cmp    %eax,%ebp
  8021d1:	73 04                	jae    8021d7 <__udivdi3+0xf7>
  8021d3:	39 d6                	cmp    %edx,%esi
  8021d5:	74 09                	je     8021e0 <__udivdi3+0x100>
  8021d7:	89 d8                	mov    %ebx,%eax
  8021d9:	31 ff                	xor    %edi,%edi
  8021db:	e9 40 ff ff ff       	jmp    802120 <__udivdi3+0x40>
  8021e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021e3:	31 ff                	xor    %edi,%edi
  8021e5:	e9 36 ff ff ff       	jmp    802120 <__udivdi3+0x40>
  8021ea:	66 90                	xchg   %ax,%ax
  8021ec:	66 90                	xchg   %ax,%ax
  8021ee:	66 90                	xchg   %ax,%ax

008021f0 <__umoddi3>:
  8021f0:	f3 0f 1e fb          	endbr32 
  8021f4:	55                   	push   %ebp
  8021f5:	57                   	push   %edi
  8021f6:	56                   	push   %esi
  8021f7:	53                   	push   %ebx
  8021f8:	83 ec 1c             	sub    $0x1c,%esp
  8021fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8021ff:	8b 74 24 30          	mov    0x30(%esp),%esi
  802203:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802207:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80220b:	85 c0                	test   %eax,%eax
  80220d:	75 19                	jne    802228 <__umoddi3+0x38>
  80220f:	39 df                	cmp    %ebx,%edi
  802211:	76 5d                	jbe    802270 <__umoddi3+0x80>
  802213:	89 f0                	mov    %esi,%eax
  802215:	89 da                	mov    %ebx,%edx
  802217:	f7 f7                	div    %edi
  802219:	89 d0                	mov    %edx,%eax
  80221b:	31 d2                	xor    %edx,%edx
  80221d:	83 c4 1c             	add    $0x1c,%esp
  802220:	5b                   	pop    %ebx
  802221:	5e                   	pop    %esi
  802222:	5f                   	pop    %edi
  802223:	5d                   	pop    %ebp
  802224:	c3                   	ret    
  802225:	8d 76 00             	lea    0x0(%esi),%esi
  802228:	89 f2                	mov    %esi,%edx
  80222a:	39 d8                	cmp    %ebx,%eax
  80222c:	76 12                	jbe    802240 <__umoddi3+0x50>
  80222e:	89 f0                	mov    %esi,%eax
  802230:	89 da                	mov    %ebx,%edx
  802232:	83 c4 1c             	add    $0x1c,%esp
  802235:	5b                   	pop    %ebx
  802236:	5e                   	pop    %esi
  802237:	5f                   	pop    %edi
  802238:	5d                   	pop    %ebp
  802239:	c3                   	ret    
  80223a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802240:	0f bd e8             	bsr    %eax,%ebp
  802243:	83 f5 1f             	xor    $0x1f,%ebp
  802246:	75 50                	jne    802298 <__umoddi3+0xa8>
  802248:	39 d8                	cmp    %ebx,%eax
  80224a:	0f 82 e0 00 00 00    	jb     802330 <__umoddi3+0x140>
  802250:	89 d9                	mov    %ebx,%ecx
  802252:	39 f7                	cmp    %esi,%edi
  802254:	0f 86 d6 00 00 00    	jbe    802330 <__umoddi3+0x140>
  80225a:	89 d0                	mov    %edx,%eax
  80225c:	89 ca                	mov    %ecx,%edx
  80225e:	83 c4 1c             	add    $0x1c,%esp
  802261:	5b                   	pop    %ebx
  802262:	5e                   	pop    %esi
  802263:	5f                   	pop    %edi
  802264:	5d                   	pop    %ebp
  802265:	c3                   	ret    
  802266:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80226d:	8d 76 00             	lea    0x0(%esi),%esi
  802270:	89 fd                	mov    %edi,%ebp
  802272:	85 ff                	test   %edi,%edi
  802274:	75 0b                	jne    802281 <__umoddi3+0x91>
  802276:	b8 01 00 00 00       	mov    $0x1,%eax
  80227b:	31 d2                	xor    %edx,%edx
  80227d:	f7 f7                	div    %edi
  80227f:	89 c5                	mov    %eax,%ebp
  802281:	89 d8                	mov    %ebx,%eax
  802283:	31 d2                	xor    %edx,%edx
  802285:	f7 f5                	div    %ebp
  802287:	89 f0                	mov    %esi,%eax
  802289:	f7 f5                	div    %ebp
  80228b:	89 d0                	mov    %edx,%eax
  80228d:	31 d2                	xor    %edx,%edx
  80228f:	eb 8c                	jmp    80221d <__umoddi3+0x2d>
  802291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802298:	89 e9                	mov    %ebp,%ecx
  80229a:	ba 20 00 00 00       	mov    $0x20,%edx
  80229f:	29 ea                	sub    %ebp,%edx
  8022a1:	d3 e0                	shl    %cl,%eax
  8022a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022a7:	89 d1                	mov    %edx,%ecx
  8022a9:	89 f8                	mov    %edi,%eax
  8022ab:	d3 e8                	shr    %cl,%eax
  8022ad:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8022b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022b5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8022b9:	09 c1                	or     %eax,%ecx
  8022bb:	89 d8                	mov    %ebx,%eax
  8022bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022c1:	89 e9                	mov    %ebp,%ecx
  8022c3:	d3 e7                	shl    %cl,%edi
  8022c5:	89 d1                	mov    %edx,%ecx
  8022c7:	d3 e8                	shr    %cl,%eax
  8022c9:	89 e9                	mov    %ebp,%ecx
  8022cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8022cf:	d3 e3                	shl    %cl,%ebx
  8022d1:	89 c7                	mov    %eax,%edi
  8022d3:	89 d1                	mov    %edx,%ecx
  8022d5:	89 f0                	mov    %esi,%eax
  8022d7:	d3 e8                	shr    %cl,%eax
  8022d9:	89 e9                	mov    %ebp,%ecx
  8022db:	89 fa                	mov    %edi,%edx
  8022dd:	d3 e6                	shl    %cl,%esi
  8022df:	09 d8                	or     %ebx,%eax
  8022e1:	f7 74 24 08          	divl   0x8(%esp)
  8022e5:	89 d1                	mov    %edx,%ecx
  8022e7:	89 f3                	mov    %esi,%ebx
  8022e9:	f7 64 24 0c          	mull   0xc(%esp)
  8022ed:	89 c6                	mov    %eax,%esi
  8022ef:	89 d7                	mov    %edx,%edi
  8022f1:	39 d1                	cmp    %edx,%ecx
  8022f3:	72 06                	jb     8022fb <__umoddi3+0x10b>
  8022f5:	75 10                	jne    802307 <__umoddi3+0x117>
  8022f7:	39 c3                	cmp    %eax,%ebx
  8022f9:	73 0c                	jae    802307 <__umoddi3+0x117>
  8022fb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8022ff:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802303:	89 d7                	mov    %edx,%edi
  802305:	89 c6                	mov    %eax,%esi
  802307:	89 ca                	mov    %ecx,%edx
  802309:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80230e:	29 f3                	sub    %esi,%ebx
  802310:	19 fa                	sbb    %edi,%edx
  802312:	89 d0                	mov    %edx,%eax
  802314:	d3 e0                	shl    %cl,%eax
  802316:	89 e9                	mov    %ebp,%ecx
  802318:	d3 eb                	shr    %cl,%ebx
  80231a:	d3 ea                	shr    %cl,%edx
  80231c:	09 d8                	or     %ebx,%eax
  80231e:	83 c4 1c             	add    $0x1c,%esp
  802321:	5b                   	pop    %ebx
  802322:	5e                   	pop    %esi
  802323:	5f                   	pop    %edi
  802324:	5d                   	pop    %ebp
  802325:	c3                   	ret    
  802326:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80232d:	8d 76 00             	lea    0x0(%esi),%esi
  802330:	29 fe                	sub    %edi,%esi
  802332:	19 c3                	sbb    %eax,%ebx
  802334:	89 f2                	mov    %esi,%edx
  802336:	89 d9                	mov    %ebx,%ecx
  802338:	e9 1d ff ff ff       	jmp    80225a <__umoddi3+0x6a>
