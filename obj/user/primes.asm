
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
  80004b:	e8 02 12 00 00       	call   801252 <ipc_recv>
  800050:	89 c3                	mov    %eax,%ebx
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  800052:	a1 08 40 80 00       	mov    0x804008,%eax
  800057:	8b 40 5c             	mov    0x5c(%eax),%eax
  80005a:	83 c4 0c             	add    $0xc,%esp
  80005d:	53                   	push   %ebx
  80005e:	50                   	push   %eax
  80005f:	68 c0 28 80 00       	push   $0x8028c0
  800064:	e8 e4 01 00 00       	call   80024d <cprintf>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  800069:	e8 cb 0f 00 00       	call   801039 <fork>
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
  80007f:	68 65 2c 80 00       	push   $0x802c65
  800084:	6a 1a                	push   $0x1a
  800086:	68 cc 28 80 00       	push   $0x8028cc
  80008b:	e8 d6 00 00 00       	call   800166 <_panic>
		if (i % p)
			ipc_send(id, i, 0, 0);
  800090:	6a 00                	push   $0x0
  800092:	6a 00                	push   $0x0
  800094:	51                   	push   %ecx
  800095:	57                   	push   %edi
  800096:	e8 3c 12 00 00       	call   8012d7 <ipc_send>
  80009b:	83 c4 10             	add    $0x10,%esp
		i = ipc_recv(&envid, 0, 0);
  80009e:	83 ec 04             	sub    $0x4,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	6a 00                	push   $0x0
  8000a5:	56                   	push   %esi
  8000a6:	e8 a7 11 00 00       	call   801252 <ipc_recv>
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
  8000c2:	e8 72 0f 00 00       	call   801039 <fork>
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
  8000da:	e8 f8 11 00 00       	call   8012d7 <ipc_send>
	for (i = 2; ; i++)
  8000df:	83 c3 01             	add    $0x1,%ebx
  8000e2:	83 c4 10             	add    $0x10,%esp
  8000e5:	eb ed                	jmp    8000d4 <umain+0x1b>
		panic("fork: %e", id);
  8000e7:	50                   	push   %eax
  8000e8:	68 65 2c 80 00       	push   $0x802c65
  8000ed:	6a 2d                	push   $0x2d
  8000ef:	68 cc 28 80 00       	push   $0x8028cc
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
  80011f:	a3 08 40 80 00       	mov    %eax,0x804008

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
  800152:	e8 09 14 00 00       	call   801560 <close_all>
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
  800188:	68 e4 28 80 00       	push   $0x8028e4
  80018d:	e8 bb 00 00 00       	call   80024d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800192:	83 c4 18             	add    $0x18,%esp
  800195:	53                   	push   %ebx
  800196:	ff 75 10             	pushl  0x10(%ebp)
  800199:	e8 5a 00 00 00       	call   8001f8 <vcprintf>
	cprintf("\n");
  80019e:	c7 04 24 d4 2c 80 00 	movl   $0x802cd4,(%esp)
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
  8002b3:	e8 98 23 00 00       	call   802650 <__udivdi3>
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
  8002f1:	e8 6a 24 00 00       	call   802760 <__umoddi3>
  8002f6:	83 c4 14             	add    $0x14,%esp
  8002f9:	0f be 80 07 29 80 00 	movsbl 0x802907(%eax),%eax
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
  8003a0:	3e ff 24 85 40 2a 80 	notrack jmp *0x802a40(,%eax,4)
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
  80046d:	8b 14 85 a0 2b 80 00 	mov    0x802ba0(,%eax,4),%edx
  800474:	85 d2                	test   %edx,%edx
  800476:	74 18                	je     800490 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800478:	52                   	push   %edx
  800479:	68 89 2d 80 00       	push   $0x802d89
  80047e:	53                   	push   %ebx
  80047f:	56                   	push   %esi
  800480:	e8 aa fe ff ff       	call   80032f <printfmt>
  800485:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800488:	89 7d 14             	mov    %edi,0x14(%ebp)
  80048b:	e9 66 02 00 00       	jmp    8006f6 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800490:	50                   	push   %eax
  800491:	68 1f 29 80 00       	push   $0x80291f
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
  8004b8:	b8 18 29 80 00       	mov    $0x802918,%eax
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
  800c42:	68 ff 2b 80 00       	push   $0x802bff
  800c47:	6a 23                	push   $0x23
  800c49:	68 1c 2c 80 00       	push   $0x802c1c
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
  800ccf:	68 ff 2b 80 00       	push   $0x802bff
  800cd4:	6a 23                	push   $0x23
  800cd6:	68 1c 2c 80 00       	push   $0x802c1c
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
  800d15:	68 ff 2b 80 00       	push   $0x802bff
  800d1a:	6a 23                	push   $0x23
  800d1c:	68 1c 2c 80 00       	push   $0x802c1c
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
  800d5b:	68 ff 2b 80 00       	push   $0x802bff
  800d60:	6a 23                	push   $0x23
  800d62:	68 1c 2c 80 00       	push   $0x802c1c
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
  800da1:	68 ff 2b 80 00       	push   $0x802bff
  800da6:	6a 23                	push   $0x23
  800da8:	68 1c 2c 80 00       	push   $0x802c1c
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
  800de7:	68 ff 2b 80 00       	push   $0x802bff
  800dec:	6a 23                	push   $0x23
  800dee:	68 1c 2c 80 00       	push   $0x802c1c
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
  800e2d:	68 ff 2b 80 00       	push   $0x802bff
  800e32:	6a 23                	push   $0x23
  800e34:	68 1c 2c 80 00       	push   $0x802c1c
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
  800e99:	68 ff 2b 80 00       	push   $0x802bff
  800e9e:	6a 23                	push   $0x23
  800ea0:	68 1c 2c 80 00       	push   $0x802c1c
  800ea5:	e8 bc f2 ff ff       	call   800166 <_panic>

00800eaa <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800eaa:	f3 0f 1e fb          	endbr32 
  800eae:	55                   	push   %ebp
  800eaf:	89 e5                	mov    %esp,%ebp
  800eb1:	57                   	push   %edi
  800eb2:	56                   	push   %esi
  800eb3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eb4:	ba 00 00 00 00       	mov    $0x0,%edx
  800eb9:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ebe:	89 d1                	mov    %edx,%ecx
  800ec0:	89 d3                	mov    %edx,%ebx
  800ec2:	89 d7                	mov    %edx,%edi
  800ec4:	89 d6                	mov    %edx,%esi
  800ec6:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ec8:	5b                   	pop    %ebx
  800ec9:	5e                   	pop    %esi
  800eca:	5f                   	pop    %edi
  800ecb:	5d                   	pop    %ebp
  800ecc:	c3                   	ret    

00800ecd <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  800ecd:	f3 0f 1e fb          	endbr32 
  800ed1:	55                   	push   %ebp
  800ed2:	89 e5                	mov    %esp,%ebp
  800ed4:	57                   	push   %edi
  800ed5:	56                   	push   %esi
  800ed6:	53                   	push   %ebx
  800ed7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eda:	bb 00 00 00 00       	mov    $0x0,%ebx
  800edf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee5:	b8 0f 00 00 00       	mov    $0xf,%eax
  800eea:	89 df                	mov    %ebx,%edi
  800eec:	89 de                	mov    %ebx,%esi
  800eee:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef0:	85 c0                	test   %eax,%eax
  800ef2:	7f 08                	jg     800efc <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  800ef4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef7:	5b                   	pop    %ebx
  800ef8:	5e                   	pop    %esi
  800ef9:	5f                   	pop    %edi
  800efa:	5d                   	pop    %ebp
  800efb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800efc:	83 ec 0c             	sub    $0xc,%esp
  800eff:	50                   	push   %eax
  800f00:	6a 0f                	push   $0xf
  800f02:	68 ff 2b 80 00       	push   $0x802bff
  800f07:	6a 23                	push   $0x23
  800f09:	68 1c 2c 80 00       	push   $0x802c1c
  800f0e:	e8 53 f2 ff ff       	call   800166 <_panic>

00800f13 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  800f13:	f3 0f 1e fb          	endbr32 
  800f17:	55                   	push   %ebp
  800f18:	89 e5                	mov    %esp,%ebp
  800f1a:	57                   	push   %edi
  800f1b:	56                   	push   %esi
  800f1c:	53                   	push   %ebx
  800f1d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f20:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f25:	8b 55 08             	mov    0x8(%ebp),%edx
  800f28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2b:	b8 10 00 00 00       	mov    $0x10,%eax
  800f30:	89 df                	mov    %ebx,%edi
  800f32:	89 de                	mov    %ebx,%esi
  800f34:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f36:	85 c0                	test   %eax,%eax
  800f38:	7f 08                	jg     800f42 <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  800f3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f3d:	5b                   	pop    %ebx
  800f3e:	5e                   	pop    %esi
  800f3f:	5f                   	pop    %edi
  800f40:	5d                   	pop    %ebp
  800f41:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f42:	83 ec 0c             	sub    $0xc,%esp
  800f45:	50                   	push   %eax
  800f46:	6a 10                	push   $0x10
  800f48:	68 ff 2b 80 00       	push   $0x802bff
  800f4d:	6a 23                	push   $0x23
  800f4f:	68 1c 2c 80 00       	push   $0x802c1c
  800f54:	e8 0d f2 ff ff       	call   800166 <_panic>

00800f59 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f59:	f3 0f 1e fb          	endbr32 
  800f5d:	55                   	push   %ebp
  800f5e:	89 e5                	mov    %esp,%ebp
  800f60:	53                   	push   %ebx
  800f61:	83 ec 04             	sub    $0x4,%esp
  800f64:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800f67:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  800f69:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f6d:	74 74                	je     800fe3 <pgfault+0x8a>
  800f6f:	89 d8                	mov    %ebx,%eax
  800f71:	c1 e8 0c             	shr    $0xc,%eax
  800f74:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f7b:	f6 c4 08             	test   $0x8,%ah
  800f7e:	74 63                	je     800fe3 <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800f80:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  800f86:	83 ec 0c             	sub    $0xc,%esp
  800f89:	6a 05                	push   $0x5
  800f8b:	68 00 f0 7f 00       	push   $0x7ff000
  800f90:	6a 00                	push   $0x0
  800f92:	53                   	push   %ebx
  800f93:	6a 00                	push   $0x0
  800f95:	e8 46 fd ff ff       	call   800ce0 <sys_page_map>
  800f9a:	83 c4 20             	add    $0x20,%esp
  800f9d:	85 c0                	test   %eax,%eax
  800f9f:	78 59                	js     800ffa <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  800fa1:	83 ec 04             	sub    $0x4,%esp
  800fa4:	6a 07                	push   $0x7
  800fa6:	53                   	push   %ebx
  800fa7:	6a 00                	push   $0x0
  800fa9:	e8 eb fc ff ff       	call   800c99 <sys_page_alloc>
  800fae:	83 c4 10             	add    $0x10,%esp
  800fb1:	85 c0                	test   %eax,%eax
  800fb3:	78 5a                	js     80100f <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  800fb5:	83 ec 04             	sub    $0x4,%esp
  800fb8:	68 00 10 00 00       	push   $0x1000
  800fbd:	68 00 f0 7f 00       	push   $0x7ff000
  800fc2:	53                   	push   %ebx
  800fc3:	e8 45 fa ff ff       	call   800a0d <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  800fc8:	83 c4 08             	add    $0x8,%esp
  800fcb:	68 00 f0 7f 00       	push   $0x7ff000
  800fd0:	6a 00                	push   $0x0
  800fd2:	e8 4f fd ff ff       	call   800d26 <sys_page_unmap>
  800fd7:	83 c4 10             	add    $0x10,%esp
  800fda:	85 c0                	test   %eax,%eax
  800fdc:	78 46                	js     801024 <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  800fde:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fe1:	c9                   	leave  
  800fe2:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  800fe3:	83 ec 04             	sub    $0x4,%esp
  800fe6:	68 2a 2c 80 00       	push   $0x802c2a
  800feb:	68 d3 00 00 00       	push   $0xd3
  800ff0:	68 46 2c 80 00       	push   $0x802c46
  800ff5:	e8 6c f1 ff ff       	call   800166 <_panic>
		panic("pgfault: %e\n", r);
  800ffa:	50                   	push   %eax
  800ffb:	68 51 2c 80 00       	push   $0x802c51
  801000:	68 df 00 00 00       	push   $0xdf
  801005:	68 46 2c 80 00       	push   $0x802c46
  80100a:	e8 57 f1 ff ff       	call   800166 <_panic>
		panic("pgfault: %e\n", r);
  80100f:	50                   	push   %eax
  801010:	68 51 2c 80 00       	push   $0x802c51
  801015:	68 e3 00 00 00       	push   $0xe3
  80101a:	68 46 2c 80 00       	push   $0x802c46
  80101f:	e8 42 f1 ff ff       	call   800166 <_panic>
		panic("pgfault: %e\n", r);
  801024:	50                   	push   %eax
  801025:	68 51 2c 80 00       	push   $0x802c51
  80102a:	68 e9 00 00 00       	push   $0xe9
  80102f:	68 46 2c 80 00       	push   $0x802c46
  801034:	e8 2d f1 ff ff       	call   800166 <_panic>

00801039 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801039:	f3 0f 1e fb          	endbr32 
  80103d:	55                   	push   %ebp
  80103e:	89 e5                	mov    %esp,%ebp
  801040:	57                   	push   %edi
  801041:	56                   	push   %esi
  801042:	53                   	push   %ebx
  801043:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  801046:	68 59 0f 80 00       	push   $0x800f59
  80104b:	e8 1e 15 00 00       	call   80256e <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801050:	b8 07 00 00 00       	mov    $0x7,%eax
  801055:	cd 30                	int    $0x30
  801057:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  80105a:	83 c4 10             	add    $0x10,%esp
  80105d:	85 c0                	test   %eax,%eax
  80105f:	78 2d                	js     80108e <fork+0x55>
  801061:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801063:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  801068:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80106c:	0f 85 9b 00 00 00    	jne    80110d <fork+0xd4>
		thisenv = &envs[ENVX(sys_getenvid())];
  801072:	e8 dc fb ff ff       	call   800c53 <sys_getenvid>
  801077:	25 ff 03 00 00       	and    $0x3ff,%eax
  80107c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80107f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801084:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  801089:	e9 71 01 00 00       	jmp    8011ff <fork+0x1c6>
		panic("sys_exofork: %e", envid);
  80108e:	50                   	push   %eax
  80108f:	68 5e 2c 80 00       	push   $0x802c5e
  801094:	68 2a 01 00 00       	push   $0x12a
  801099:	68 46 2c 80 00       	push   $0x802c46
  80109e:	e8 c3 f0 ff ff       	call   800166 <_panic>
		sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_SYSCALL);
  8010a3:	c1 e6 0c             	shl    $0xc,%esi
  8010a6:	83 ec 0c             	sub    $0xc,%esp
  8010a9:	68 07 0e 00 00       	push   $0xe07
  8010ae:	56                   	push   %esi
  8010af:	57                   	push   %edi
  8010b0:	56                   	push   %esi
  8010b1:	6a 00                	push   $0x0
  8010b3:	e8 28 fc ff ff       	call   800ce0 <sys_page_map>
  8010b8:	83 c4 20             	add    $0x20,%esp
  8010bb:	eb 3e                	jmp    8010fb <fork+0xc2>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  8010bd:	c1 e6 0c             	shl    $0xc,%esi
  8010c0:	83 ec 0c             	sub    $0xc,%esp
  8010c3:	68 05 08 00 00       	push   $0x805
  8010c8:	56                   	push   %esi
  8010c9:	57                   	push   %edi
  8010ca:	56                   	push   %esi
  8010cb:	6a 00                	push   $0x0
  8010cd:	e8 0e fc ff ff       	call   800ce0 <sys_page_map>
  8010d2:	83 c4 20             	add    $0x20,%esp
  8010d5:	85 c0                	test   %eax,%eax
  8010d7:	0f 88 bc 00 00 00    	js     801199 <fork+0x160>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  8010dd:	83 ec 0c             	sub    $0xc,%esp
  8010e0:	68 05 08 00 00       	push   $0x805
  8010e5:	56                   	push   %esi
  8010e6:	6a 00                	push   $0x0
  8010e8:	56                   	push   %esi
  8010e9:	6a 00                	push   $0x0
  8010eb:	e8 f0 fb ff ff       	call   800ce0 <sys_page_map>
  8010f0:	83 c4 20             	add    $0x20,%esp
  8010f3:	85 c0                	test   %eax,%eax
  8010f5:	0f 88 b3 00 00 00    	js     8011ae <fork+0x175>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8010fb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801101:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801107:	0f 84 b6 00 00 00    	je     8011c3 <fork+0x18a>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  80110d:	89 d8                	mov    %ebx,%eax
  80110f:	c1 e8 16             	shr    $0x16,%eax
  801112:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801119:	a8 01                	test   $0x1,%al
  80111b:	74 de                	je     8010fb <fork+0xc2>
  80111d:	89 de                	mov    %ebx,%esi
  80111f:	c1 ee 0c             	shr    $0xc,%esi
  801122:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801129:	a8 01                	test   $0x1,%al
  80112b:	74 ce                	je     8010fb <fork+0xc2>
  80112d:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801134:	a8 04                	test   $0x4,%al
  801136:	74 c3                	je     8010fb <fork+0xc2>
	if ((uvpt[pn] & PTE_SHARE)){
  801138:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80113f:	f6 c4 04             	test   $0x4,%ah
  801142:	0f 85 5b ff ff ff    	jne    8010a3 <fork+0x6a>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  801148:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80114f:	a8 02                	test   $0x2,%al
  801151:	0f 85 66 ff ff ff    	jne    8010bd <fork+0x84>
  801157:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80115e:	f6 c4 08             	test   $0x8,%ah
  801161:	0f 85 56 ff ff ff    	jne    8010bd <fork+0x84>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  801167:	c1 e6 0c             	shl    $0xc,%esi
  80116a:	83 ec 0c             	sub    $0xc,%esp
  80116d:	6a 05                	push   $0x5
  80116f:	56                   	push   %esi
  801170:	57                   	push   %edi
  801171:	56                   	push   %esi
  801172:	6a 00                	push   $0x0
  801174:	e8 67 fb ff ff       	call   800ce0 <sys_page_map>
  801179:	83 c4 20             	add    $0x20,%esp
  80117c:	85 c0                	test   %eax,%eax
  80117e:	0f 89 77 ff ff ff    	jns    8010fb <fork+0xc2>
		panic("duppage: %e\n", r);
  801184:	50                   	push   %eax
  801185:	68 6e 2c 80 00       	push   $0x802c6e
  80118a:	68 0c 01 00 00       	push   $0x10c
  80118f:	68 46 2c 80 00       	push   $0x802c46
  801194:	e8 cd ef ff ff       	call   800166 <_panic>
			panic("duppage: %e\n", r);
  801199:	50                   	push   %eax
  80119a:	68 6e 2c 80 00       	push   $0x802c6e
  80119f:	68 05 01 00 00       	push   $0x105
  8011a4:	68 46 2c 80 00       	push   $0x802c46
  8011a9:	e8 b8 ef ff ff       	call   800166 <_panic>
			panic("duppage: %e\n", r);
  8011ae:	50                   	push   %eax
  8011af:	68 6e 2c 80 00       	push   $0x802c6e
  8011b4:	68 09 01 00 00       	push   $0x109
  8011b9:	68 46 2c 80 00       	push   $0x802c46
  8011be:	e8 a3 ef ff ff       	call   800166 <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  8011c3:	83 ec 04             	sub    $0x4,%esp
  8011c6:	6a 07                	push   $0x7
  8011c8:	68 00 f0 bf ee       	push   $0xeebff000
  8011cd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011d0:	e8 c4 fa ff ff       	call   800c99 <sys_page_alloc>
  8011d5:	83 c4 10             	add    $0x10,%esp
  8011d8:	85 c0                	test   %eax,%eax
  8011da:	78 2e                	js     80120a <fork+0x1d1>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8011dc:	83 ec 08             	sub    $0x8,%esp
  8011df:	68 e1 25 80 00       	push   $0x8025e1
  8011e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8011e7:	57                   	push   %edi
  8011e8:	e8 0b fc ff ff       	call   800df8 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8011ed:	83 c4 08             	add    $0x8,%esp
  8011f0:	6a 02                	push   $0x2
  8011f2:	57                   	push   %edi
  8011f3:	e8 74 fb ff ff       	call   800d6c <sys_env_set_status>
  8011f8:	83 c4 10             	add    $0x10,%esp
  8011fb:	85 c0                	test   %eax,%eax
  8011fd:	78 20                	js     80121f <fork+0x1e6>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  8011ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801202:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801205:	5b                   	pop    %ebx
  801206:	5e                   	pop    %esi
  801207:	5f                   	pop    %edi
  801208:	5d                   	pop    %ebp
  801209:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  80120a:	50                   	push   %eax
  80120b:	68 7b 2c 80 00       	push   $0x802c7b
  801210:	68 3e 01 00 00       	push   $0x13e
  801215:	68 46 2c 80 00       	push   $0x802c46
  80121a:	e8 47 ef ff ff       	call   800166 <_panic>
		panic("sys_env_set_status: %e", r);
  80121f:	50                   	push   %eax
  801220:	68 8e 2c 80 00       	push   $0x802c8e
  801225:	68 43 01 00 00       	push   $0x143
  80122a:	68 46 2c 80 00       	push   $0x802c46
  80122f:	e8 32 ef ff ff       	call   800166 <_panic>

00801234 <sfork>:

// Challenge!
int
sfork(void)
{
  801234:	f3 0f 1e fb          	endbr32 
  801238:	55                   	push   %ebp
  801239:	89 e5                	mov    %esp,%ebp
  80123b:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80123e:	68 a5 2c 80 00       	push   $0x802ca5
  801243:	68 4c 01 00 00       	push   $0x14c
  801248:	68 46 2c 80 00       	push   $0x802c46
  80124d:	e8 14 ef ff ff       	call   800166 <_panic>

00801252 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801252:	f3 0f 1e fb          	endbr32 
  801256:	55                   	push   %ebp
  801257:	89 e5                	mov    %esp,%ebp
  801259:	56                   	push   %esi
  80125a:	53                   	push   %ebx
  80125b:	8b 75 08             	mov    0x8(%ebp),%esi
  80125e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801261:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  801264:	85 c0                	test   %eax,%eax
  801266:	74 3d                	je     8012a5 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  801268:	83 ec 0c             	sub    $0xc,%esp
  80126b:	50                   	push   %eax
  80126c:	e8 f4 fb ff ff       	call   800e65 <sys_ipc_recv>
  801271:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  801274:	85 f6                	test   %esi,%esi
  801276:	74 0b                	je     801283 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801278:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80127e:	8b 52 74             	mov    0x74(%edx),%edx
  801281:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801283:	85 db                	test   %ebx,%ebx
  801285:	74 0b                	je     801292 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  801287:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80128d:	8b 52 78             	mov    0x78(%edx),%edx
  801290:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  801292:	85 c0                	test   %eax,%eax
  801294:	78 21                	js     8012b7 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  801296:	a1 08 40 80 00       	mov    0x804008,%eax
  80129b:	8b 40 70             	mov    0x70(%eax),%eax
}
  80129e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012a1:	5b                   	pop    %ebx
  8012a2:	5e                   	pop    %esi
  8012a3:	5d                   	pop    %ebp
  8012a4:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  8012a5:	83 ec 0c             	sub    $0xc,%esp
  8012a8:	68 00 00 c0 ee       	push   $0xeec00000
  8012ad:	e8 b3 fb ff ff       	call   800e65 <sys_ipc_recv>
  8012b2:	83 c4 10             	add    $0x10,%esp
  8012b5:	eb bd                	jmp    801274 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  8012b7:	85 f6                	test   %esi,%esi
  8012b9:	74 10                	je     8012cb <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  8012bb:	85 db                	test   %ebx,%ebx
  8012bd:	75 df                	jne    80129e <ipc_recv+0x4c>
  8012bf:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8012c6:	00 00 00 
  8012c9:	eb d3                	jmp    80129e <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  8012cb:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8012d2:	00 00 00 
  8012d5:	eb e4                	jmp    8012bb <ipc_recv+0x69>

008012d7 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8012d7:	f3 0f 1e fb          	endbr32 
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	57                   	push   %edi
  8012df:	56                   	push   %esi
  8012e0:	53                   	push   %ebx
  8012e1:	83 ec 0c             	sub    $0xc,%esp
  8012e4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012e7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012ea:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  8012ed:	85 db                	test   %ebx,%ebx
  8012ef:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8012f4:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  8012f7:	ff 75 14             	pushl  0x14(%ebp)
  8012fa:	53                   	push   %ebx
  8012fb:	56                   	push   %esi
  8012fc:	57                   	push   %edi
  8012fd:	e8 3c fb ff ff       	call   800e3e <sys_ipc_try_send>
  801302:	83 c4 10             	add    $0x10,%esp
  801305:	85 c0                	test   %eax,%eax
  801307:	79 1e                	jns    801327 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  801309:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80130c:	75 07                	jne    801315 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  80130e:	e8 63 f9 ff ff       	call   800c76 <sys_yield>
  801313:	eb e2                	jmp    8012f7 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  801315:	50                   	push   %eax
  801316:	68 bb 2c 80 00       	push   $0x802cbb
  80131b:	6a 59                	push   $0x59
  80131d:	68 d6 2c 80 00       	push   $0x802cd6
  801322:	e8 3f ee ff ff       	call   800166 <_panic>
	}
}
  801327:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80132a:	5b                   	pop    %ebx
  80132b:	5e                   	pop    %esi
  80132c:	5f                   	pop    %edi
  80132d:	5d                   	pop    %ebp
  80132e:	c3                   	ret    

0080132f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80132f:	f3 0f 1e fb          	endbr32 
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
  801336:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801339:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80133e:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801341:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801347:	8b 52 50             	mov    0x50(%edx),%edx
  80134a:	39 ca                	cmp    %ecx,%edx
  80134c:	74 11                	je     80135f <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80134e:	83 c0 01             	add    $0x1,%eax
  801351:	3d 00 04 00 00       	cmp    $0x400,%eax
  801356:	75 e6                	jne    80133e <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801358:	b8 00 00 00 00       	mov    $0x0,%eax
  80135d:	eb 0b                	jmp    80136a <ipc_find_env+0x3b>
			return envs[i].env_id;
  80135f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801362:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801367:	8b 40 48             	mov    0x48(%eax),%eax
}
  80136a:	5d                   	pop    %ebp
  80136b:	c3                   	ret    

0080136c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80136c:	f3 0f 1e fb          	endbr32 
  801370:	55                   	push   %ebp
  801371:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801373:	8b 45 08             	mov    0x8(%ebp),%eax
  801376:	05 00 00 00 30       	add    $0x30000000,%eax
  80137b:	c1 e8 0c             	shr    $0xc,%eax
}
  80137e:	5d                   	pop    %ebp
  80137f:	c3                   	ret    

00801380 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801380:	f3 0f 1e fb          	endbr32 
  801384:	55                   	push   %ebp
  801385:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801387:	8b 45 08             	mov    0x8(%ebp),%eax
  80138a:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80138f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801394:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801399:	5d                   	pop    %ebp
  80139a:	c3                   	ret    

0080139b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80139b:	f3 0f 1e fb          	endbr32 
  80139f:	55                   	push   %ebp
  8013a0:	89 e5                	mov    %esp,%ebp
  8013a2:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013a7:	89 c2                	mov    %eax,%edx
  8013a9:	c1 ea 16             	shr    $0x16,%edx
  8013ac:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013b3:	f6 c2 01             	test   $0x1,%dl
  8013b6:	74 2d                	je     8013e5 <fd_alloc+0x4a>
  8013b8:	89 c2                	mov    %eax,%edx
  8013ba:	c1 ea 0c             	shr    $0xc,%edx
  8013bd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013c4:	f6 c2 01             	test   $0x1,%dl
  8013c7:	74 1c                	je     8013e5 <fd_alloc+0x4a>
  8013c9:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8013ce:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8013d3:	75 d2                	jne    8013a7 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8013d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8013de:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8013e3:	eb 0a                	jmp    8013ef <fd_alloc+0x54>
			*fd_store = fd;
  8013e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013e8:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ef:	5d                   	pop    %ebp
  8013f0:	c3                   	ret    

008013f1 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8013f1:	f3 0f 1e fb          	endbr32 
  8013f5:	55                   	push   %ebp
  8013f6:	89 e5                	mov    %esp,%ebp
  8013f8:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8013fb:	83 f8 1f             	cmp    $0x1f,%eax
  8013fe:	77 30                	ja     801430 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801400:	c1 e0 0c             	shl    $0xc,%eax
  801403:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801408:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80140e:	f6 c2 01             	test   $0x1,%dl
  801411:	74 24                	je     801437 <fd_lookup+0x46>
  801413:	89 c2                	mov    %eax,%edx
  801415:	c1 ea 0c             	shr    $0xc,%edx
  801418:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80141f:	f6 c2 01             	test   $0x1,%dl
  801422:	74 1a                	je     80143e <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801424:	8b 55 0c             	mov    0xc(%ebp),%edx
  801427:	89 02                	mov    %eax,(%edx)
	return 0;
  801429:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80142e:	5d                   	pop    %ebp
  80142f:	c3                   	ret    
		return -E_INVAL;
  801430:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801435:	eb f7                	jmp    80142e <fd_lookup+0x3d>
		return -E_INVAL;
  801437:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80143c:	eb f0                	jmp    80142e <fd_lookup+0x3d>
  80143e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801443:	eb e9                	jmp    80142e <fd_lookup+0x3d>

00801445 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801445:	f3 0f 1e fb          	endbr32 
  801449:	55                   	push   %ebp
  80144a:	89 e5                	mov    %esp,%ebp
  80144c:	83 ec 08             	sub    $0x8,%esp
  80144f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801452:	ba 00 00 00 00       	mov    $0x0,%edx
  801457:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80145c:	39 08                	cmp    %ecx,(%eax)
  80145e:	74 38                	je     801498 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  801460:	83 c2 01             	add    $0x1,%edx
  801463:	8b 04 95 5c 2d 80 00 	mov    0x802d5c(,%edx,4),%eax
  80146a:	85 c0                	test   %eax,%eax
  80146c:	75 ee                	jne    80145c <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80146e:	a1 08 40 80 00       	mov    0x804008,%eax
  801473:	8b 40 48             	mov    0x48(%eax),%eax
  801476:	83 ec 04             	sub    $0x4,%esp
  801479:	51                   	push   %ecx
  80147a:	50                   	push   %eax
  80147b:	68 e0 2c 80 00       	push   $0x802ce0
  801480:	e8 c8 ed ff ff       	call   80024d <cprintf>
	*dev = 0;
  801485:	8b 45 0c             	mov    0xc(%ebp),%eax
  801488:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80148e:	83 c4 10             	add    $0x10,%esp
  801491:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801496:	c9                   	leave  
  801497:	c3                   	ret    
			*dev = devtab[i];
  801498:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80149b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80149d:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a2:	eb f2                	jmp    801496 <dev_lookup+0x51>

008014a4 <fd_close>:
{
  8014a4:	f3 0f 1e fb          	endbr32 
  8014a8:	55                   	push   %ebp
  8014a9:	89 e5                	mov    %esp,%ebp
  8014ab:	57                   	push   %edi
  8014ac:	56                   	push   %esi
  8014ad:	53                   	push   %ebx
  8014ae:	83 ec 24             	sub    $0x24,%esp
  8014b1:	8b 75 08             	mov    0x8(%ebp),%esi
  8014b4:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014b7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014ba:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014bb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8014c1:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014c4:	50                   	push   %eax
  8014c5:	e8 27 ff ff ff       	call   8013f1 <fd_lookup>
  8014ca:	89 c3                	mov    %eax,%ebx
  8014cc:	83 c4 10             	add    $0x10,%esp
  8014cf:	85 c0                	test   %eax,%eax
  8014d1:	78 05                	js     8014d8 <fd_close+0x34>
	    || fd != fd2)
  8014d3:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8014d6:	74 16                	je     8014ee <fd_close+0x4a>
		return (must_exist ? r : 0);
  8014d8:	89 f8                	mov    %edi,%eax
  8014da:	84 c0                	test   %al,%al
  8014dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e1:	0f 44 d8             	cmove  %eax,%ebx
}
  8014e4:	89 d8                	mov    %ebx,%eax
  8014e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014e9:	5b                   	pop    %ebx
  8014ea:	5e                   	pop    %esi
  8014eb:	5f                   	pop    %edi
  8014ec:	5d                   	pop    %ebp
  8014ed:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8014ee:	83 ec 08             	sub    $0x8,%esp
  8014f1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8014f4:	50                   	push   %eax
  8014f5:	ff 36                	pushl  (%esi)
  8014f7:	e8 49 ff ff ff       	call   801445 <dev_lookup>
  8014fc:	89 c3                	mov    %eax,%ebx
  8014fe:	83 c4 10             	add    $0x10,%esp
  801501:	85 c0                	test   %eax,%eax
  801503:	78 1a                	js     80151f <fd_close+0x7b>
		if (dev->dev_close)
  801505:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801508:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80150b:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801510:	85 c0                	test   %eax,%eax
  801512:	74 0b                	je     80151f <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801514:	83 ec 0c             	sub    $0xc,%esp
  801517:	56                   	push   %esi
  801518:	ff d0                	call   *%eax
  80151a:	89 c3                	mov    %eax,%ebx
  80151c:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80151f:	83 ec 08             	sub    $0x8,%esp
  801522:	56                   	push   %esi
  801523:	6a 00                	push   $0x0
  801525:	e8 fc f7 ff ff       	call   800d26 <sys_page_unmap>
	return r;
  80152a:	83 c4 10             	add    $0x10,%esp
  80152d:	eb b5                	jmp    8014e4 <fd_close+0x40>

0080152f <close>:

int
close(int fdnum)
{
  80152f:	f3 0f 1e fb          	endbr32 
  801533:	55                   	push   %ebp
  801534:	89 e5                	mov    %esp,%ebp
  801536:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801539:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80153c:	50                   	push   %eax
  80153d:	ff 75 08             	pushl  0x8(%ebp)
  801540:	e8 ac fe ff ff       	call   8013f1 <fd_lookup>
  801545:	83 c4 10             	add    $0x10,%esp
  801548:	85 c0                	test   %eax,%eax
  80154a:	79 02                	jns    80154e <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80154c:	c9                   	leave  
  80154d:	c3                   	ret    
		return fd_close(fd, 1);
  80154e:	83 ec 08             	sub    $0x8,%esp
  801551:	6a 01                	push   $0x1
  801553:	ff 75 f4             	pushl  -0xc(%ebp)
  801556:	e8 49 ff ff ff       	call   8014a4 <fd_close>
  80155b:	83 c4 10             	add    $0x10,%esp
  80155e:	eb ec                	jmp    80154c <close+0x1d>

00801560 <close_all>:

void
close_all(void)
{
  801560:	f3 0f 1e fb          	endbr32 
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
  801567:	53                   	push   %ebx
  801568:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80156b:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801570:	83 ec 0c             	sub    $0xc,%esp
  801573:	53                   	push   %ebx
  801574:	e8 b6 ff ff ff       	call   80152f <close>
	for (i = 0; i < MAXFD; i++)
  801579:	83 c3 01             	add    $0x1,%ebx
  80157c:	83 c4 10             	add    $0x10,%esp
  80157f:	83 fb 20             	cmp    $0x20,%ebx
  801582:	75 ec                	jne    801570 <close_all+0x10>
}
  801584:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801587:	c9                   	leave  
  801588:	c3                   	ret    

00801589 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801589:	f3 0f 1e fb          	endbr32 
  80158d:	55                   	push   %ebp
  80158e:	89 e5                	mov    %esp,%ebp
  801590:	57                   	push   %edi
  801591:	56                   	push   %esi
  801592:	53                   	push   %ebx
  801593:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801596:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801599:	50                   	push   %eax
  80159a:	ff 75 08             	pushl  0x8(%ebp)
  80159d:	e8 4f fe ff ff       	call   8013f1 <fd_lookup>
  8015a2:	89 c3                	mov    %eax,%ebx
  8015a4:	83 c4 10             	add    $0x10,%esp
  8015a7:	85 c0                	test   %eax,%eax
  8015a9:	0f 88 81 00 00 00    	js     801630 <dup+0xa7>
		return r;
	close(newfdnum);
  8015af:	83 ec 0c             	sub    $0xc,%esp
  8015b2:	ff 75 0c             	pushl  0xc(%ebp)
  8015b5:	e8 75 ff ff ff       	call   80152f <close>

	newfd = INDEX2FD(newfdnum);
  8015ba:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015bd:	c1 e6 0c             	shl    $0xc,%esi
  8015c0:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8015c6:	83 c4 04             	add    $0x4,%esp
  8015c9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015cc:	e8 af fd ff ff       	call   801380 <fd2data>
  8015d1:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8015d3:	89 34 24             	mov    %esi,(%esp)
  8015d6:	e8 a5 fd ff ff       	call   801380 <fd2data>
  8015db:	83 c4 10             	add    $0x10,%esp
  8015de:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8015e0:	89 d8                	mov    %ebx,%eax
  8015e2:	c1 e8 16             	shr    $0x16,%eax
  8015e5:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015ec:	a8 01                	test   $0x1,%al
  8015ee:	74 11                	je     801601 <dup+0x78>
  8015f0:	89 d8                	mov    %ebx,%eax
  8015f2:	c1 e8 0c             	shr    $0xc,%eax
  8015f5:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8015fc:	f6 c2 01             	test   $0x1,%dl
  8015ff:	75 39                	jne    80163a <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801601:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801604:	89 d0                	mov    %edx,%eax
  801606:	c1 e8 0c             	shr    $0xc,%eax
  801609:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801610:	83 ec 0c             	sub    $0xc,%esp
  801613:	25 07 0e 00 00       	and    $0xe07,%eax
  801618:	50                   	push   %eax
  801619:	56                   	push   %esi
  80161a:	6a 00                	push   $0x0
  80161c:	52                   	push   %edx
  80161d:	6a 00                	push   $0x0
  80161f:	e8 bc f6 ff ff       	call   800ce0 <sys_page_map>
  801624:	89 c3                	mov    %eax,%ebx
  801626:	83 c4 20             	add    $0x20,%esp
  801629:	85 c0                	test   %eax,%eax
  80162b:	78 31                	js     80165e <dup+0xd5>
		goto err;

	return newfdnum;
  80162d:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801630:	89 d8                	mov    %ebx,%eax
  801632:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801635:	5b                   	pop    %ebx
  801636:	5e                   	pop    %esi
  801637:	5f                   	pop    %edi
  801638:	5d                   	pop    %ebp
  801639:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80163a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801641:	83 ec 0c             	sub    $0xc,%esp
  801644:	25 07 0e 00 00       	and    $0xe07,%eax
  801649:	50                   	push   %eax
  80164a:	57                   	push   %edi
  80164b:	6a 00                	push   $0x0
  80164d:	53                   	push   %ebx
  80164e:	6a 00                	push   $0x0
  801650:	e8 8b f6 ff ff       	call   800ce0 <sys_page_map>
  801655:	89 c3                	mov    %eax,%ebx
  801657:	83 c4 20             	add    $0x20,%esp
  80165a:	85 c0                	test   %eax,%eax
  80165c:	79 a3                	jns    801601 <dup+0x78>
	sys_page_unmap(0, newfd);
  80165e:	83 ec 08             	sub    $0x8,%esp
  801661:	56                   	push   %esi
  801662:	6a 00                	push   $0x0
  801664:	e8 bd f6 ff ff       	call   800d26 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801669:	83 c4 08             	add    $0x8,%esp
  80166c:	57                   	push   %edi
  80166d:	6a 00                	push   $0x0
  80166f:	e8 b2 f6 ff ff       	call   800d26 <sys_page_unmap>
	return r;
  801674:	83 c4 10             	add    $0x10,%esp
  801677:	eb b7                	jmp    801630 <dup+0xa7>

00801679 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801679:	f3 0f 1e fb          	endbr32 
  80167d:	55                   	push   %ebp
  80167e:	89 e5                	mov    %esp,%ebp
  801680:	53                   	push   %ebx
  801681:	83 ec 1c             	sub    $0x1c,%esp
  801684:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801687:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80168a:	50                   	push   %eax
  80168b:	53                   	push   %ebx
  80168c:	e8 60 fd ff ff       	call   8013f1 <fd_lookup>
  801691:	83 c4 10             	add    $0x10,%esp
  801694:	85 c0                	test   %eax,%eax
  801696:	78 3f                	js     8016d7 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801698:	83 ec 08             	sub    $0x8,%esp
  80169b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80169e:	50                   	push   %eax
  80169f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a2:	ff 30                	pushl  (%eax)
  8016a4:	e8 9c fd ff ff       	call   801445 <dev_lookup>
  8016a9:	83 c4 10             	add    $0x10,%esp
  8016ac:	85 c0                	test   %eax,%eax
  8016ae:	78 27                	js     8016d7 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016b3:	8b 42 08             	mov    0x8(%edx),%eax
  8016b6:	83 e0 03             	and    $0x3,%eax
  8016b9:	83 f8 01             	cmp    $0x1,%eax
  8016bc:	74 1e                	je     8016dc <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8016be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c1:	8b 40 08             	mov    0x8(%eax),%eax
  8016c4:	85 c0                	test   %eax,%eax
  8016c6:	74 35                	je     8016fd <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8016c8:	83 ec 04             	sub    $0x4,%esp
  8016cb:	ff 75 10             	pushl  0x10(%ebp)
  8016ce:	ff 75 0c             	pushl  0xc(%ebp)
  8016d1:	52                   	push   %edx
  8016d2:	ff d0                	call   *%eax
  8016d4:	83 c4 10             	add    $0x10,%esp
}
  8016d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016da:	c9                   	leave  
  8016db:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8016dc:	a1 08 40 80 00       	mov    0x804008,%eax
  8016e1:	8b 40 48             	mov    0x48(%eax),%eax
  8016e4:	83 ec 04             	sub    $0x4,%esp
  8016e7:	53                   	push   %ebx
  8016e8:	50                   	push   %eax
  8016e9:	68 21 2d 80 00       	push   $0x802d21
  8016ee:	e8 5a eb ff ff       	call   80024d <cprintf>
		return -E_INVAL;
  8016f3:	83 c4 10             	add    $0x10,%esp
  8016f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016fb:	eb da                	jmp    8016d7 <read+0x5e>
		return -E_NOT_SUPP;
  8016fd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801702:	eb d3                	jmp    8016d7 <read+0x5e>

00801704 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801704:	f3 0f 1e fb          	endbr32 
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
  80170b:	57                   	push   %edi
  80170c:	56                   	push   %esi
  80170d:	53                   	push   %ebx
  80170e:	83 ec 0c             	sub    $0xc,%esp
  801711:	8b 7d 08             	mov    0x8(%ebp),%edi
  801714:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801717:	bb 00 00 00 00       	mov    $0x0,%ebx
  80171c:	eb 02                	jmp    801720 <readn+0x1c>
  80171e:	01 c3                	add    %eax,%ebx
  801720:	39 f3                	cmp    %esi,%ebx
  801722:	73 21                	jae    801745 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801724:	83 ec 04             	sub    $0x4,%esp
  801727:	89 f0                	mov    %esi,%eax
  801729:	29 d8                	sub    %ebx,%eax
  80172b:	50                   	push   %eax
  80172c:	89 d8                	mov    %ebx,%eax
  80172e:	03 45 0c             	add    0xc(%ebp),%eax
  801731:	50                   	push   %eax
  801732:	57                   	push   %edi
  801733:	e8 41 ff ff ff       	call   801679 <read>
		if (m < 0)
  801738:	83 c4 10             	add    $0x10,%esp
  80173b:	85 c0                	test   %eax,%eax
  80173d:	78 04                	js     801743 <readn+0x3f>
			return m;
		if (m == 0)
  80173f:	75 dd                	jne    80171e <readn+0x1a>
  801741:	eb 02                	jmp    801745 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801743:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801745:	89 d8                	mov    %ebx,%eax
  801747:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80174a:	5b                   	pop    %ebx
  80174b:	5e                   	pop    %esi
  80174c:	5f                   	pop    %edi
  80174d:	5d                   	pop    %ebp
  80174e:	c3                   	ret    

0080174f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80174f:	f3 0f 1e fb          	endbr32 
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
  801756:	53                   	push   %ebx
  801757:	83 ec 1c             	sub    $0x1c,%esp
  80175a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80175d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801760:	50                   	push   %eax
  801761:	53                   	push   %ebx
  801762:	e8 8a fc ff ff       	call   8013f1 <fd_lookup>
  801767:	83 c4 10             	add    $0x10,%esp
  80176a:	85 c0                	test   %eax,%eax
  80176c:	78 3a                	js     8017a8 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80176e:	83 ec 08             	sub    $0x8,%esp
  801771:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801774:	50                   	push   %eax
  801775:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801778:	ff 30                	pushl  (%eax)
  80177a:	e8 c6 fc ff ff       	call   801445 <dev_lookup>
  80177f:	83 c4 10             	add    $0x10,%esp
  801782:	85 c0                	test   %eax,%eax
  801784:	78 22                	js     8017a8 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801786:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801789:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80178d:	74 1e                	je     8017ad <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80178f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801792:	8b 52 0c             	mov    0xc(%edx),%edx
  801795:	85 d2                	test   %edx,%edx
  801797:	74 35                	je     8017ce <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801799:	83 ec 04             	sub    $0x4,%esp
  80179c:	ff 75 10             	pushl  0x10(%ebp)
  80179f:	ff 75 0c             	pushl  0xc(%ebp)
  8017a2:	50                   	push   %eax
  8017a3:	ff d2                	call   *%edx
  8017a5:	83 c4 10             	add    $0x10,%esp
}
  8017a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ab:	c9                   	leave  
  8017ac:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017ad:	a1 08 40 80 00       	mov    0x804008,%eax
  8017b2:	8b 40 48             	mov    0x48(%eax),%eax
  8017b5:	83 ec 04             	sub    $0x4,%esp
  8017b8:	53                   	push   %ebx
  8017b9:	50                   	push   %eax
  8017ba:	68 3d 2d 80 00       	push   $0x802d3d
  8017bf:	e8 89 ea ff ff       	call   80024d <cprintf>
		return -E_INVAL;
  8017c4:	83 c4 10             	add    $0x10,%esp
  8017c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017cc:	eb da                	jmp    8017a8 <write+0x59>
		return -E_NOT_SUPP;
  8017ce:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017d3:	eb d3                	jmp    8017a8 <write+0x59>

008017d5 <seek>:

int
seek(int fdnum, off_t offset)
{
  8017d5:	f3 0f 1e fb          	endbr32 
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
  8017dc:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017e2:	50                   	push   %eax
  8017e3:	ff 75 08             	pushl  0x8(%ebp)
  8017e6:	e8 06 fc ff ff       	call   8013f1 <fd_lookup>
  8017eb:	83 c4 10             	add    $0x10,%esp
  8017ee:	85 c0                	test   %eax,%eax
  8017f0:	78 0e                	js     801800 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8017f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f8:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8017fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801800:	c9                   	leave  
  801801:	c3                   	ret    

00801802 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801802:	f3 0f 1e fb          	endbr32 
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	53                   	push   %ebx
  80180a:	83 ec 1c             	sub    $0x1c,%esp
  80180d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801810:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801813:	50                   	push   %eax
  801814:	53                   	push   %ebx
  801815:	e8 d7 fb ff ff       	call   8013f1 <fd_lookup>
  80181a:	83 c4 10             	add    $0x10,%esp
  80181d:	85 c0                	test   %eax,%eax
  80181f:	78 37                	js     801858 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801821:	83 ec 08             	sub    $0x8,%esp
  801824:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801827:	50                   	push   %eax
  801828:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80182b:	ff 30                	pushl  (%eax)
  80182d:	e8 13 fc ff ff       	call   801445 <dev_lookup>
  801832:	83 c4 10             	add    $0x10,%esp
  801835:	85 c0                	test   %eax,%eax
  801837:	78 1f                	js     801858 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801839:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80183c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801840:	74 1b                	je     80185d <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801842:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801845:	8b 52 18             	mov    0x18(%edx),%edx
  801848:	85 d2                	test   %edx,%edx
  80184a:	74 32                	je     80187e <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80184c:	83 ec 08             	sub    $0x8,%esp
  80184f:	ff 75 0c             	pushl  0xc(%ebp)
  801852:	50                   	push   %eax
  801853:	ff d2                	call   *%edx
  801855:	83 c4 10             	add    $0x10,%esp
}
  801858:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    
			thisenv->env_id, fdnum);
  80185d:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801862:	8b 40 48             	mov    0x48(%eax),%eax
  801865:	83 ec 04             	sub    $0x4,%esp
  801868:	53                   	push   %ebx
  801869:	50                   	push   %eax
  80186a:	68 00 2d 80 00       	push   $0x802d00
  80186f:	e8 d9 e9 ff ff       	call   80024d <cprintf>
		return -E_INVAL;
  801874:	83 c4 10             	add    $0x10,%esp
  801877:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80187c:	eb da                	jmp    801858 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80187e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801883:	eb d3                	jmp    801858 <ftruncate+0x56>

00801885 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801885:	f3 0f 1e fb          	endbr32 
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
  80188c:	53                   	push   %ebx
  80188d:	83 ec 1c             	sub    $0x1c,%esp
  801890:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801893:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801896:	50                   	push   %eax
  801897:	ff 75 08             	pushl  0x8(%ebp)
  80189a:	e8 52 fb ff ff       	call   8013f1 <fd_lookup>
  80189f:	83 c4 10             	add    $0x10,%esp
  8018a2:	85 c0                	test   %eax,%eax
  8018a4:	78 4b                	js     8018f1 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018a6:	83 ec 08             	sub    $0x8,%esp
  8018a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ac:	50                   	push   %eax
  8018ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b0:	ff 30                	pushl  (%eax)
  8018b2:	e8 8e fb ff ff       	call   801445 <dev_lookup>
  8018b7:	83 c4 10             	add    $0x10,%esp
  8018ba:	85 c0                	test   %eax,%eax
  8018bc:	78 33                	js     8018f1 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8018be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c1:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018c5:	74 2f                	je     8018f6 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018c7:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018ca:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8018d1:	00 00 00 
	stat->st_isdir = 0;
  8018d4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018db:	00 00 00 
	stat->st_dev = dev;
  8018de:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018e4:	83 ec 08             	sub    $0x8,%esp
  8018e7:	53                   	push   %ebx
  8018e8:	ff 75 f0             	pushl  -0x10(%ebp)
  8018eb:	ff 50 14             	call   *0x14(%eax)
  8018ee:	83 c4 10             	add    $0x10,%esp
}
  8018f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018f4:	c9                   	leave  
  8018f5:	c3                   	ret    
		return -E_NOT_SUPP;
  8018f6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018fb:	eb f4                	jmp    8018f1 <fstat+0x6c>

008018fd <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8018fd:	f3 0f 1e fb          	endbr32 
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
  801904:	56                   	push   %esi
  801905:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801906:	83 ec 08             	sub    $0x8,%esp
  801909:	6a 00                	push   $0x0
  80190b:	ff 75 08             	pushl  0x8(%ebp)
  80190e:	e8 fb 01 00 00       	call   801b0e <open>
  801913:	89 c3                	mov    %eax,%ebx
  801915:	83 c4 10             	add    $0x10,%esp
  801918:	85 c0                	test   %eax,%eax
  80191a:	78 1b                	js     801937 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80191c:	83 ec 08             	sub    $0x8,%esp
  80191f:	ff 75 0c             	pushl  0xc(%ebp)
  801922:	50                   	push   %eax
  801923:	e8 5d ff ff ff       	call   801885 <fstat>
  801928:	89 c6                	mov    %eax,%esi
	close(fd);
  80192a:	89 1c 24             	mov    %ebx,(%esp)
  80192d:	e8 fd fb ff ff       	call   80152f <close>
	return r;
  801932:	83 c4 10             	add    $0x10,%esp
  801935:	89 f3                	mov    %esi,%ebx
}
  801937:	89 d8                	mov    %ebx,%eax
  801939:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80193c:	5b                   	pop    %ebx
  80193d:	5e                   	pop    %esi
  80193e:	5d                   	pop    %ebp
  80193f:	c3                   	ret    

00801940 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
  801943:	56                   	push   %esi
  801944:	53                   	push   %ebx
  801945:	89 c6                	mov    %eax,%esi
  801947:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801949:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801950:	74 27                	je     801979 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801952:	6a 07                	push   $0x7
  801954:	68 00 50 80 00       	push   $0x805000
  801959:	56                   	push   %esi
  80195a:	ff 35 00 40 80 00    	pushl  0x804000
  801960:	e8 72 f9 ff ff       	call   8012d7 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801965:	83 c4 0c             	add    $0xc,%esp
  801968:	6a 00                	push   $0x0
  80196a:	53                   	push   %ebx
  80196b:	6a 00                	push   $0x0
  80196d:	e8 e0 f8 ff ff       	call   801252 <ipc_recv>
}
  801972:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801975:	5b                   	pop    %ebx
  801976:	5e                   	pop    %esi
  801977:	5d                   	pop    %ebp
  801978:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801979:	83 ec 0c             	sub    $0xc,%esp
  80197c:	6a 01                	push   $0x1
  80197e:	e8 ac f9 ff ff       	call   80132f <ipc_find_env>
  801983:	a3 00 40 80 00       	mov    %eax,0x804000
  801988:	83 c4 10             	add    $0x10,%esp
  80198b:	eb c5                	jmp    801952 <fsipc+0x12>

0080198d <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80198d:	f3 0f 1e fb          	endbr32 
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
  801994:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801997:	8b 45 08             	mov    0x8(%ebp),%eax
  80199a:	8b 40 0c             	mov    0xc(%eax),%eax
  80199d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8019a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a5:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8019aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8019af:	b8 02 00 00 00       	mov    $0x2,%eax
  8019b4:	e8 87 ff ff ff       	call   801940 <fsipc>
}
  8019b9:	c9                   	leave  
  8019ba:	c3                   	ret    

008019bb <devfile_flush>:
{
  8019bb:	f3 0f 1e fb          	endbr32 
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
  8019c2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8019cb:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8019d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d5:	b8 06 00 00 00       	mov    $0x6,%eax
  8019da:	e8 61 ff ff ff       	call   801940 <fsipc>
}
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    

008019e1 <devfile_stat>:
{
  8019e1:	f3 0f 1e fb          	endbr32 
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
  8019e8:	53                   	push   %ebx
  8019e9:	83 ec 04             	sub    $0x4,%esp
  8019ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8019ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8019f5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8019fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ff:	b8 05 00 00 00       	mov    $0x5,%eax
  801a04:	e8 37 ff ff ff       	call   801940 <fsipc>
  801a09:	85 c0                	test   %eax,%eax
  801a0b:	78 2c                	js     801a39 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a0d:	83 ec 08             	sub    $0x8,%esp
  801a10:	68 00 50 80 00       	push   $0x805000
  801a15:	53                   	push   %ebx
  801a16:	e8 3c ee ff ff       	call   800857 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a1b:	a1 80 50 80 00       	mov    0x805080,%eax
  801a20:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a26:	a1 84 50 80 00       	mov    0x805084,%eax
  801a2b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a31:	83 c4 10             	add    $0x10,%esp
  801a34:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a3c:	c9                   	leave  
  801a3d:	c3                   	ret    

00801a3e <devfile_write>:
{
  801a3e:	f3 0f 1e fb          	endbr32 
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
  801a45:	83 ec 0c             	sub    $0xc,%esp
  801a48:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a4b:	8b 55 08             	mov    0x8(%ebp),%edx
  801a4e:	8b 52 0c             	mov    0xc(%edx),%edx
  801a51:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801a57:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801a5c:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801a61:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  801a64:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801a69:	50                   	push   %eax
  801a6a:	ff 75 0c             	pushl  0xc(%ebp)
  801a6d:	68 08 50 80 00       	push   $0x805008
  801a72:	e8 96 ef ff ff       	call   800a0d <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801a77:	ba 00 00 00 00       	mov    $0x0,%edx
  801a7c:	b8 04 00 00 00       	mov    $0x4,%eax
  801a81:	e8 ba fe ff ff       	call   801940 <fsipc>
}
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <devfile_read>:
{
  801a88:	f3 0f 1e fb          	endbr32 
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
  801a8f:	56                   	push   %esi
  801a90:	53                   	push   %ebx
  801a91:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a94:	8b 45 08             	mov    0x8(%ebp),%eax
  801a97:	8b 40 0c             	mov    0xc(%eax),%eax
  801a9a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a9f:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801aa5:	ba 00 00 00 00       	mov    $0x0,%edx
  801aaa:	b8 03 00 00 00       	mov    $0x3,%eax
  801aaf:	e8 8c fe ff ff       	call   801940 <fsipc>
  801ab4:	89 c3                	mov    %eax,%ebx
  801ab6:	85 c0                	test   %eax,%eax
  801ab8:	78 1f                	js     801ad9 <devfile_read+0x51>
	assert(r <= n);
  801aba:	39 f0                	cmp    %esi,%eax
  801abc:	77 24                	ja     801ae2 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801abe:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ac3:	7f 33                	jg     801af8 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801ac5:	83 ec 04             	sub    $0x4,%esp
  801ac8:	50                   	push   %eax
  801ac9:	68 00 50 80 00       	push   $0x805000
  801ace:	ff 75 0c             	pushl  0xc(%ebp)
  801ad1:	e8 37 ef ff ff       	call   800a0d <memmove>
	return r;
  801ad6:	83 c4 10             	add    $0x10,%esp
}
  801ad9:	89 d8                	mov    %ebx,%eax
  801adb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ade:	5b                   	pop    %ebx
  801adf:	5e                   	pop    %esi
  801ae0:	5d                   	pop    %ebp
  801ae1:	c3                   	ret    
	assert(r <= n);
  801ae2:	68 70 2d 80 00       	push   $0x802d70
  801ae7:	68 77 2d 80 00       	push   $0x802d77
  801aec:	6a 7c                	push   $0x7c
  801aee:	68 8c 2d 80 00       	push   $0x802d8c
  801af3:	e8 6e e6 ff ff       	call   800166 <_panic>
	assert(r <= PGSIZE);
  801af8:	68 97 2d 80 00       	push   $0x802d97
  801afd:	68 77 2d 80 00       	push   $0x802d77
  801b02:	6a 7d                	push   $0x7d
  801b04:	68 8c 2d 80 00       	push   $0x802d8c
  801b09:	e8 58 e6 ff ff       	call   800166 <_panic>

00801b0e <open>:
{
  801b0e:	f3 0f 1e fb          	endbr32 
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
  801b15:	56                   	push   %esi
  801b16:	53                   	push   %ebx
  801b17:	83 ec 1c             	sub    $0x1c,%esp
  801b1a:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b1d:	56                   	push   %esi
  801b1e:	e8 f1 ec ff ff       	call   800814 <strlen>
  801b23:	83 c4 10             	add    $0x10,%esp
  801b26:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b2b:	7f 6c                	jg     801b99 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801b2d:	83 ec 0c             	sub    $0xc,%esp
  801b30:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b33:	50                   	push   %eax
  801b34:	e8 62 f8 ff ff       	call   80139b <fd_alloc>
  801b39:	89 c3                	mov    %eax,%ebx
  801b3b:	83 c4 10             	add    $0x10,%esp
  801b3e:	85 c0                	test   %eax,%eax
  801b40:	78 3c                	js     801b7e <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801b42:	83 ec 08             	sub    $0x8,%esp
  801b45:	56                   	push   %esi
  801b46:	68 00 50 80 00       	push   $0x805000
  801b4b:	e8 07 ed ff ff       	call   800857 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b53:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b5b:	b8 01 00 00 00       	mov    $0x1,%eax
  801b60:	e8 db fd ff ff       	call   801940 <fsipc>
  801b65:	89 c3                	mov    %eax,%ebx
  801b67:	83 c4 10             	add    $0x10,%esp
  801b6a:	85 c0                	test   %eax,%eax
  801b6c:	78 19                	js     801b87 <open+0x79>
	return fd2num(fd);
  801b6e:	83 ec 0c             	sub    $0xc,%esp
  801b71:	ff 75 f4             	pushl  -0xc(%ebp)
  801b74:	e8 f3 f7 ff ff       	call   80136c <fd2num>
  801b79:	89 c3                	mov    %eax,%ebx
  801b7b:	83 c4 10             	add    $0x10,%esp
}
  801b7e:	89 d8                	mov    %ebx,%eax
  801b80:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b83:	5b                   	pop    %ebx
  801b84:	5e                   	pop    %esi
  801b85:	5d                   	pop    %ebp
  801b86:	c3                   	ret    
		fd_close(fd, 0);
  801b87:	83 ec 08             	sub    $0x8,%esp
  801b8a:	6a 00                	push   $0x0
  801b8c:	ff 75 f4             	pushl  -0xc(%ebp)
  801b8f:	e8 10 f9 ff ff       	call   8014a4 <fd_close>
		return r;
  801b94:	83 c4 10             	add    $0x10,%esp
  801b97:	eb e5                	jmp    801b7e <open+0x70>
		return -E_BAD_PATH;
  801b99:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b9e:	eb de                	jmp    801b7e <open+0x70>

00801ba0 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801ba0:	f3 0f 1e fb          	endbr32 
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
  801ba7:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801baa:	ba 00 00 00 00       	mov    $0x0,%edx
  801baf:	b8 08 00 00 00       	mov    $0x8,%eax
  801bb4:	e8 87 fd ff ff       	call   801940 <fsipc>
}
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801bbb:	f3 0f 1e fb          	endbr32 
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
  801bc2:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801bc5:	68 a3 2d 80 00       	push   $0x802da3
  801bca:	ff 75 0c             	pushl  0xc(%ebp)
  801bcd:	e8 85 ec ff ff       	call   800857 <strcpy>
	return 0;
}
  801bd2:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    

00801bd9 <devsock_close>:
{
  801bd9:	f3 0f 1e fb          	endbr32 
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
  801be0:	53                   	push   %ebx
  801be1:	83 ec 10             	sub    $0x10,%esp
  801be4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801be7:	53                   	push   %ebx
  801be8:	e8 1a 0a 00 00       	call   802607 <pageref>
  801bed:	89 c2                	mov    %eax,%edx
  801bef:	83 c4 10             	add    $0x10,%esp
		return 0;
  801bf2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801bf7:	83 fa 01             	cmp    $0x1,%edx
  801bfa:	74 05                	je     801c01 <devsock_close+0x28>
}
  801bfc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bff:	c9                   	leave  
  801c00:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801c01:	83 ec 0c             	sub    $0xc,%esp
  801c04:	ff 73 0c             	pushl  0xc(%ebx)
  801c07:	e8 e3 02 00 00       	call   801eef <nsipc_close>
  801c0c:	83 c4 10             	add    $0x10,%esp
  801c0f:	eb eb                	jmp    801bfc <devsock_close+0x23>

00801c11 <devsock_write>:
{
  801c11:	f3 0f 1e fb          	endbr32 
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
  801c18:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801c1b:	6a 00                	push   $0x0
  801c1d:	ff 75 10             	pushl  0x10(%ebp)
  801c20:	ff 75 0c             	pushl  0xc(%ebp)
  801c23:	8b 45 08             	mov    0x8(%ebp),%eax
  801c26:	ff 70 0c             	pushl  0xc(%eax)
  801c29:	e8 b5 03 00 00       	call   801fe3 <nsipc_send>
}
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <devsock_read>:
{
  801c30:	f3 0f 1e fb          	endbr32 
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
  801c37:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801c3a:	6a 00                	push   $0x0
  801c3c:	ff 75 10             	pushl  0x10(%ebp)
  801c3f:	ff 75 0c             	pushl  0xc(%ebp)
  801c42:	8b 45 08             	mov    0x8(%ebp),%eax
  801c45:	ff 70 0c             	pushl  0xc(%eax)
  801c48:	e8 1f 03 00 00       	call   801f6c <nsipc_recv>
}
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <fd2sockid>:
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
  801c52:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801c55:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801c58:	52                   	push   %edx
  801c59:	50                   	push   %eax
  801c5a:	e8 92 f7 ff ff       	call   8013f1 <fd_lookup>
  801c5f:	83 c4 10             	add    $0x10,%esp
  801c62:	85 c0                	test   %eax,%eax
  801c64:	78 10                	js     801c76 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c69:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801c6f:	39 08                	cmp    %ecx,(%eax)
  801c71:	75 05                	jne    801c78 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801c73:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    
		return -E_NOT_SUPP;
  801c78:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c7d:	eb f7                	jmp    801c76 <fd2sockid+0x27>

00801c7f <alloc_sockfd>:
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
  801c82:	56                   	push   %esi
  801c83:	53                   	push   %ebx
  801c84:	83 ec 1c             	sub    $0x1c,%esp
  801c87:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801c89:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c8c:	50                   	push   %eax
  801c8d:	e8 09 f7 ff ff       	call   80139b <fd_alloc>
  801c92:	89 c3                	mov    %eax,%ebx
  801c94:	83 c4 10             	add    $0x10,%esp
  801c97:	85 c0                	test   %eax,%eax
  801c99:	78 43                	js     801cde <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801c9b:	83 ec 04             	sub    $0x4,%esp
  801c9e:	68 07 04 00 00       	push   $0x407
  801ca3:	ff 75 f4             	pushl  -0xc(%ebp)
  801ca6:	6a 00                	push   $0x0
  801ca8:	e8 ec ef ff ff       	call   800c99 <sys_page_alloc>
  801cad:	89 c3                	mov    %eax,%ebx
  801caf:	83 c4 10             	add    $0x10,%esp
  801cb2:	85 c0                	test   %eax,%eax
  801cb4:	78 28                	js     801cde <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb9:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801cbf:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801ccb:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801cce:	83 ec 0c             	sub    $0xc,%esp
  801cd1:	50                   	push   %eax
  801cd2:	e8 95 f6 ff ff       	call   80136c <fd2num>
  801cd7:	89 c3                	mov    %eax,%ebx
  801cd9:	83 c4 10             	add    $0x10,%esp
  801cdc:	eb 0c                	jmp    801cea <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801cde:	83 ec 0c             	sub    $0xc,%esp
  801ce1:	56                   	push   %esi
  801ce2:	e8 08 02 00 00       	call   801eef <nsipc_close>
		return r;
  801ce7:	83 c4 10             	add    $0x10,%esp
}
  801cea:	89 d8                	mov    %ebx,%eax
  801cec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cef:	5b                   	pop    %ebx
  801cf0:	5e                   	pop    %esi
  801cf1:	5d                   	pop    %ebp
  801cf2:	c3                   	ret    

00801cf3 <accept>:
{
  801cf3:	f3 0f 1e fb          	endbr32 
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
  801cfa:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801d00:	e8 4a ff ff ff       	call   801c4f <fd2sockid>
  801d05:	85 c0                	test   %eax,%eax
  801d07:	78 1b                	js     801d24 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801d09:	83 ec 04             	sub    $0x4,%esp
  801d0c:	ff 75 10             	pushl  0x10(%ebp)
  801d0f:	ff 75 0c             	pushl  0xc(%ebp)
  801d12:	50                   	push   %eax
  801d13:	e8 22 01 00 00       	call   801e3a <nsipc_accept>
  801d18:	83 c4 10             	add    $0x10,%esp
  801d1b:	85 c0                	test   %eax,%eax
  801d1d:	78 05                	js     801d24 <accept+0x31>
	return alloc_sockfd(r);
  801d1f:	e8 5b ff ff ff       	call   801c7f <alloc_sockfd>
}
  801d24:	c9                   	leave  
  801d25:	c3                   	ret    

00801d26 <bind>:
{
  801d26:	f3 0f 1e fb          	endbr32 
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
  801d2d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d30:	8b 45 08             	mov    0x8(%ebp),%eax
  801d33:	e8 17 ff ff ff       	call   801c4f <fd2sockid>
  801d38:	85 c0                	test   %eax,%eax
  801d3a:	78 12                	js     801d4e <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801d3c:	83 ec 04             	sub    $0x4,%esp
  801d3f:	ff 75 10             	pushl  0x10(%ebp)
  801d42:	ff 75 0c             	pushl  0xc(%ebp)
  801d45:	50                   	push   %eax
  801d46:	e8 45 01 00 00       	call   801e90 <nsipc_bind>
  801d4b:	83 c4 10             	add    $0x10,%esp
}
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <shutdown>:
{
  801d50:	f3 0f 1e fb          	endbr32 
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
  801d57:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5d:	e8 ed fe ff ff       	call   801c4f <fd2sockid>
  801d62:	85 c0                	test   %eax,%eax
  801d64:	78 0f                	js     801d75 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801d66:	83 ec 08             	sub    $0x8,%esp
  801d69:	ff 75 0c             	pushl  0xc(%ebp)
  801d6c:	50                   	push   %eax
  801d6d:	e8 57 01 00 00       	call   801ec9 <nsipc_shutdown>
  801d72:	83 c4 10             	add    $0x10,%esp
}
  801d75:	c9                   	leave  
  801d76:	c3                   	ret    

00801d77 <connect>:
{
  801d77:	f3 0f 1e fb          	endbr32 
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
  801d7e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d81:	8b 45 08             	mov    0x8(%ebp),%eax
  801d84:	e8 c6 fe ff ff       	call   801c4f <fd2sockid>
  801d89:	85 c0                	test   %eax,%eax
  801d8b:	78 12                	js     801d9f <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801d8d:	83 ec 04             	sub    $0x4,%esp
  801d90:	ff 75 10             	pushl  0x10(%ebp)
  801d93:	ff 75 0c             	pushl  0xc(%ebp)
  801d96:	50                   	push   %eax
  801d97:	e8 71 01 00 00       	call   801f0d <nsipc_connect>
  801d9c:	83 c4 10             	add    $0x10,%esp
}
  801d9f:	c9                   	leave  
  801da0:	c3                   	ret    

00801da1 <listen>:
{
  801da1:	f3 0f 1e fb          	endbr32 
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
  801da8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801dab:	8b 45 08             	mov    0x8(%ebp),%eax
  801dae:	e8 9c fe ff ff       	call   801c4f <fd2sockid>
  801db3:	85 c0                	test   %eax,%eax
  801db5:	78 0f                	js     801dc6 <listen+0x25>
	return nsipc_listen(r, backlog);
  801db7:	83 ec 08             	sub    $0x8,%esp
  801dba:	ff 75 0c             	pushl  0xc(%ebp)
  801dbd:	50                   	push   %eax
  801dbe:	e8 83 01 00 00       	call   801f46 <nsipc_listen>
  801dc3:	83 c4 10             	add    $0x10,%esp
}
  801dc6:	c9                   	leave  
  801dc7:	c3                   	ret    

00801dc8 <socket>:

int
socket(int domain, int type, int protocol)
{
  801dc8:	f3 0f 1e fb          	endbr32 
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
  801dcf:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801dd2:	ff 75 10             	pushl  0x10(%ebp)
  801dd5:	ff 75 0c             	pushl  0xc(%ebp)
  801dd8:	ff 75 08             	pushl  0x8(%ebp)
  801ddb:	e8 65 02 00 00       	call   802045 <nsipc_socket>
  801de0:	83 c4 10             	add    $0x10,%esp
  801de3:	85 c0                	test   %eax,%eax
  801de5:	78 05                	js     801dec <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801de7:	e8 93 fe ff ff       	call   801c7f <alloc_sockfd>
}
  801dec:	c9                   	leave  
  801ded:	c3                   	ret    

00801dee <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
  801df1:	53                   	push   %ebx
  801df2:	83 ec 04             	sub    $0x4,%esp
  801df5:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801df7:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801dfe:	74 26                	je     801e26 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801e00:	6a 07                	push   $0x7
  801e02:	68 00 60 80 00       	push   $0x806000
  801e07:	53                   	push   %ebx
  801e08:	ff 35 04 40 80 00    	pushl  0x804004
  801e0e:	e8 c4 f4 ff ff       	call   8012d7 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801e13:	83 c4 0c             	add    $0xc,%esp
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	e8 31 f4 ff ff       	call   801252 <ipc_recv>
}
  801e21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e24:	c9                   	leave  
  801e25:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801e26:	83 ec 0c             	sub    $0xc,%esp
  801e29:	6a 02                	push   $0x2
  801e2b:	e8 ff f4 ff ff       	call   80132f <ipc_find_env>
  801e30:	a3 04 40 80 00       	mov    %eax,0x804004
  801e35:	83 c4 10             	add    $0x10,%esp
  801e38:	eb c6                	jmp    801e00 <nsipc+0x12>

00801e3a <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e3a:	f3 0f 1e fb          	endbr32 
  801e3e:	55                   	push   %ebp
  801e3f:	89 e5                	mov    %esp,%ebp
  801e41:	56                   	push   %esi
  801e42:	53                   	push   %ebx
  801e43:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801e46:	8b 45 08             	mov    0x8(%ebp),%eax
  801e49:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801e4e:	8b 06                	mov    (%esi),%eax
  801e50:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801e55:	b8 01 00 00 00       	mov    $0x1,%eax
  801e5a:	e8 8f ff ff ff       	call   801dee <nsipc>
  801e5f:	89 c3                	mov    %eax,%ebx
  801e61:	85 c0                	test   %eax,%eax
  801e63:	79 09                	jns    801e6e <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801e65:	89 d8                	mov    %ebx,%eax
  801e67:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e6a:	5b                   	pop    %ebx
  801e6b:	5e                   	pop    %esi
  801e6c:	5d                   	pop    %ebp
  801e6d:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801e6e:	83 ec 04             	sub    $0x4,%esp
  801e71:	ff 35 10 60 80 00    	pushl  0x806010
  801e77:	68 00 60 80 00       	push   $0x806000
  801e7c:	ff 75 0c             	pushl  0xc(%ebp)
  801e7f:	e8 89 eb ff ff       	call   800a0d <memmove>
		*addrlen = ret->ret_addrlen;
  801e84:	a1 10 60 80 00       	mov    0x806010,%eax
  801e89:	89 06                	mov    %eax,(%esi)
  801e8b:	83 c4 10             	add    $0x10,%esp
	return r;
  801e8e:	eb d5                	jmp    801e65 <nsipc_accept+0x2b>

00801e90 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e90:	f3 0f 1e fb          	endbr32 
  801e94:	55                   	push   %ebp
  801e95:	89 e5                	mov    %esp,%ebp
  801e97:	53                   	push   %ebx
  801e98:	83 ec 08             	sub    $0x8,%esp
  801e9b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea1:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801ea6:	53                   	push   %ebx
  801ea7:	ff 75 0c             	pushl  0xc(%ebp)
  801eaa:	68 04 60 80 00       	push   $0x806004
  801eaf:	e8 59 eb ff ff       	call   800a0d <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801eb4:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801eba:	b8 02 00 00 00       	mov    $0x2,%eax
  801ebf:	e8 2a ff ff ff       	call   801dee <nsipc>
}
  801ec4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ec7:	c9                   	leave  
  801ec8:	c3                   	ret    

00801ec9 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801ec9:	f3 0f 1e fb          	endbr32 
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
  801ed0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801edb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ede:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801ee3:	b8 03 00 00 00       	mov    $0x3,%eax
  801ee8:	e8 01 ff ff ff       	call   801dee <nsipc>
}
  801eed:	c9                   	leave  
  801eee:	c3                   	ret    

00801eef <nsipc_close>:

int
nsipc_close(int s)
{
  801eef:	f3 0f 1e fb          	endbr32 
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
  801ef6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  801efc:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801f01:	b8 04 00 00 00       	mov    $0x4,%eax
  801f06:	e8 e3 fe ff ff       	call   801dee <nsipc>
}
  801f0b:	c9                   	leave  
  801f0c:	c3                   	ret    

00801f0d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801f0d:	f3 0f 1e fb          	endbr32 
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
  801f14:	53                   	push   %ebx
  801f15:	83 ec 08             	sub    $0x8,%esp
  801f18:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801f23:	53                   	push   %ebx
  801f24:	ff 75 0c             	pushl  0xc(%ebp)
  801f27:	68 04 60 80 00       	push   $0x806004
  801f2c:	e8 dc ea ff ff       	call   800a0d <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801f31:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801f37:	b8 05 00 00 00       	mov    $0x5,%eax
  801f3c:	e8 ad fe ff ff       	call   801dee <nsipc>
}
  801f41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f44:	c9                   	leave  
  801f45:	c3                   	ret    

00801f46 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801f46:	f3 0f 1e fb          	endbr32 
  801f4a:	55                   	push   %ebp
  801f4b:	89 e5                	mov    %esp,%ebp
  801f4d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801f50:	8b 45 08             	mov    0x8(%ebp),%eax
  801f53:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801f58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f5b:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801f60:	b8 06 00 00 00       	mov    $0x6,%eax
  801f65:	e8 84 fe ff ff       	call   801dee <nsipc>
}
  801f6a:	c9                   	leave  
  801f6b:	c3                   	ret    

00801f6c <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801f6c:	f3 0f 1e fb          	endbr32 
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
  801f73:	56                   	push   %esi
  801f74:	53                   	push   %ebx
  801f75:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801f78:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801f80:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801f86:	8b 45 14             	mov    0x14(%ebp),%eax
  801f89:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801f8e:	b8 07 00 00 00       	mov    $0x7,%eax
  801f93:	e8 56 fe ff ff       	call   801dee <nsipc>
  801f98:	89 c3                	mov    %eax,%ebx
  801f9a:	85 c0                	test   %eax,%eax
  801f9c:	78 26                	js     801fc4 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801f9e:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801fa4:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801fa9:	0f 4e c6             	cmovle %esi,%eax
  801fac:	39 c3                	cmp    %eax,%ebx
  801fae:	7f 1d                	jg     801fcd <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801fb0:	83 ec 04             	sub    $0x4,%esp
  801fb3:	53                   	push   %ebx
  801fb4:	68 00 60 80 00       	push   $0x806000
  801fb9:	ff 75 0c             	pushl  0xc(%ebp)
  801fbc:	e8 4c ea ff ff       	call   800a0d <memmove>
  801fc1:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801fc4:	89 d8                	mov    %ebx,%eax
  801fc6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fc9:	5b                   	pop    %ebx
  801fca:	5e                   	pop    %esi
  801fcb:	5d                   	pop    %ebp
  801fcc:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801fcd:	68 af 2d 80 00       	push   $0x802daf
  801fd2:	68 77 2d 80 00       	push   $0x802d77
  801fd7:	6a 62                	push   $0x62
  801fd9:	68 c4 2d 80 00       	push   $0x802dc4
  801fde:	e8 83 e1 ff ff       	call   800166 <_panic>

00801fe3 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801fe3:	f3 0f 1e fb          	endbr32 
  801fe7:	55                   	push   %ebp
  801fe8:	89 e5                	mov    %esp,%ebp
  801fea:	53                   	push   %ebx
  801feb:	83 ec 04             	sub    $0x4,%esp
  801fee:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff4:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801ff9:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801fff:	7f 2e                	jg     80202f <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802001:	83 ec 04             	sub    $0x4,%esp
  802004:	53                   	push   %ebx
  802005:	ff 75 0c             	pushl  0xc(%ebp)
  802008:	68 0c 60 80 00       	push   $0x80600c
  80200d:	e8 fb e9 ff ff       	call   800a0d <memmove>
	nsipcbuf.send.req_size = size;
  802012:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802018:	8b 45 14             	mov    0x14(%ebp),%eax
  80201b:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  802020:	b8 08 00 00 00       	mov    $0x8,%eax
  802025:	e8 c4 fd ff ff       	call   801dee <nsipc>
}
  80202a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80202d:	c9                   	leave  
  80202e:	c3                   	ret    
	assert(size < 1600);
  80202f:	68 d0 2d 80 00       	push   $0x802dd0
  802034:	68 77 2d 80 00       	push   $0x802d77
  802039:	6a 6d                	push   $0x6d
  80203b:	68 c4 2d 80 00       	push   $0x802dc4
  802040:	e8 21 e1 ff ff       	call   800166 <_panic>

00802045 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802045:	f3 0f 1e fb          	endbr32 
  802049:	55                   	push   %ebp
  80204a:	89 e5                	mov    %esp,%ebp
  80204c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80204f:	8b 45 08             	mov    0x8(%ebp),%eax
  802052:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802057:	8b 45 0c             	mov    0xc(%ebp),%eax
  80205a:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80205f:	8b 45 10             	mov    0x10(%ebp),%eax
  802062:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802067:	b8 09 00 00 00       	mov    $0x9,%eax
  80206c:	e8 7d fd ff ff       	call   801dee <nsipc>
}
  802071:	c9                   	leave  
  802072:	c3                   	ret    

00802073 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802073:	f3 0f 1e fb          	endbr32 
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
  80207a:	56                   	push   %esi
  80207b:	53                   	push   %ebx
  80207c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80207f:	83 ec 0c             	sub    $0xc,%esp
  802082:	ff 75 08             	pushl  0x8(%ebp)
  802085:	e8 f6 f2 ff ff       	call   801380 <fd2data>
  80208a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80208c:	83 c4 08             	add    $0x8,%esp
  80208f:	68 dc 2d 80 00       	push   $0x802ddc
  802094:	53                   	push   %ebx
  802095:	e8 bd e7 ff ff       	call   800857 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80209a:	8b 46 04             	mov    0x4(%esi),%eax
  80209d:	2b 06                	sub    (%esi),%eax
  80209f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8020a5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8020ac:	00 00 00 
	stat->st_dev = &devpipe;
  8020af:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  8020b6:	30 80 00 
	return 0;
}
  8020b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020be:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020c1:	5b                   	pop    %ebx
  8020c2:	5e                   	pop    %esi
  8020c3:	5d                   	pop    %ebp
  8020c4:	c3                   	ret    

008020c5 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8020c5:	f3 0f 1e fb          	endbr32 
  8020c9:	55                   	push   %ebp
  8020ca:	89 e5                	mov    %esp,%ebp
  8020cc:	53                   	push   %ebx
  8020cd:	83 ec 0c             	sub    $0xc,%esp
  8020d0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8020d3:	53                   	push   %ebx
  8020d4:	6a 00                	push   $0x0
  8020d6:	e8 4b ec ff ff       	call   800d26 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8020db:	89 1c 24             	mov    %ebx,(%esp)
  8020de:	e8 9d f2 ff ff       	call   801380 <fd2data>
  8020e3:	83 c4 08             	add    $0x8,%esp
  8020e6:	50                   	push   %eax
  8020e7:	6a 00                	push   $0x0
  8020e9:	e8 38 ec ff ff       	call   800d26 <sys_page_unmap>
}
  8020ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020f1:	c9                   	leave  
  8020f2:	c3                   	ret    

008020f3 <_pipeisclosed>:
{
  8020f3:	55                   	push   %ebp
  8020f4:	89 e5                	mov    %esp,%ebp
  8020f6:	57                   	push   %edi
  8020f7:	56                   	push   %esi
  8020f8:	53                   	push   %ebx
  8020f9:	83 ec 1c             	sub    $0x1c,%esp
  8020fc:	89 c7                	mov    %eax,%edi
  8020fe:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802100:	a1 08 40 80 00       	mov    0x804008,%eax
  802105:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802108:	83 ec 0c             	sub    $0xc,%esp
  80210b:	57                   	push   %edi
  80210c:	e8 f6 04 00 00       	call   802607 <pageref>
  802111:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802114:	89 34 24             	mov    %esi,(%esp)
  802117:	e8 eb 04 00 00       	call   802607 <pageref>
		nn = thisenv->env_runs;
  80211c:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802122:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802125:	83 c4 10             	add    $0x10,%esp
  802128:	39 cb                	cmp    %ecx,%ebx
  80212a:	74 1b                	je     802147 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80212c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80212f:	75 cf                	jne    802100 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802131:	8b 42 58             	mov    0x58(%edx),%eax
  802134:	6a 01                	push   $0x1
  802136:	50                   	push   %eax
  802137:	53                   	push   %ebx
  802138:	68 e3 2d 80 00       	push   $0x802de3
  80213d:	e8 0b e1 ff ff       	call   80024d <cprintf>
  802142:	83 c4 10             	add    $0x10,%esp
  802145:	eb b9                	jmp    802100 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802147:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80214a:	0f 94 c0             	sete   %al
  80214d:	0f b6 c0             	movzbl %al,%eax
}
  802150:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802153:	5b                   	pop    %ebx
  802154:	5e                   	pop    %esi
  802155:	5f                   	pop    %edi
  802156:	5d                   	pop    %ebp
  802157:	c3                   	ret    

00802158 <devpipe_write>:
{
  802158:	f3 0f 1e fb          	endbr32 
  80215c:	55                   	push   %ebp
  80215d:	89 e5                	mov    %esp,%ebp
  80215f:	57                   	push   %edi
  802160:	56                   	push   %esi
  802161:	53                   	push   %ebx
  802162:	83 ec 28             	sub    $0x28,%esp
  802165:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802168:	56                   	push   %esi
  802169:	e8 12 f2 ff ff       	call   801380 <fd2data>
  80216e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802170:	83 c4 10             	add    $0x10,%esp
  802173:	bf 00 00 00 00       	mov    $0x0,%edi
  802178:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80217b:	74 4f                	je     8021cc <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80217d:	8b 43 04             	mov    0x4(%ebx),%eax
  802180:	8b 0b                	mov    (%ebx),%ecx
  802182:	8d 51 20             	lea    0x20(%ecx),%edx
  802185:	39 d0                	cmp    %edx,%eax
  802187:	72 14                	jb     80219d <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  802189:	89 da                	mov    %ebx,%edx
  80218b:	89 f0                	mov    %esi,%eax
  80218d:	e8 61 ff ff ff       	call   8020f3 <_pipeisclosed>
  802192:	85 c0                	test   %eax,%eax
  802194:	75 3b                	jne    8021d1 <devpipe_write+0x79>
			sys_yield();
  802196:	e8 db ea ff ff       	call   800c76 <sys_yield>
  80219b:	eb e0                	jmp    80217d <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80219d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021a0:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8021a4:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8021a7:	89 c2                	mov    %eax,%edx
  8021a9:	c1 fa 1f             	sar    $0x1f,%edx
  8021ac:	89 d1                	mov    %edx,%ecx
  8021ae:	c1 e9 1b             	shr    $0x1b,%ecx
  8021b1:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8021b4:	83 e2 1f             	and    $0x1f,%edx
  8021b7:	29 ca                	sub    %ecx,%edx
  8021b9:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8021bd:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8021c1:	83 c0 01             	add    $0x1,%eax
  8021c4:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8021c7:	83 c7 01             	add    $0x1,%edi
  8021ca:	eb ac                	jmp    802178 <devpipe_write+0x20>
	return i;
  8021cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8021cf:	eb 05                	jmp    8021d6 <devpipe_write+0x7e>
				return 0;
  8021d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021d9:	5b                   	pop    %ebx
  8021da:	5e                   	pop    %esi
  8021db:	5f                   	pop    %edi
  8021dc:	5d                   	pop    %ebp
  8021dd:	c3                   	ret    

008021de <devpipe_read>:
{
  8021de:	f3 0f 1e fb          	endbr32 
  8021e2:	55                   	push   %ebp
  8021e3:	89 e5                	mov    %esp,%ebp
  8021e5:	57                   	push   %edi
  8021e6:	56                   	push   %esi
  8021e7:	53                   	push   %ebx
  8021e8:	83 ec 18             	sub    $0x18,%esp
  8021eb:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8021ee:	57                   	push   %edi
  8021ef:	e8 8c f1 ff ff       	call   801380 <fd2data>
  8021f4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8021f6:	83 c4 10             	add    $0x10,%esp
  8021f9:	be 00 00 00 00       	mov    $0x0,%esi
  8021fe:	3b 75 10             	cmp    0x10(%ebp),%esi
  802201:	75 14                	jne    802217 <devpipe_read+0x39>
	return i;
  802203:	8b 45 10             	mov    0x10(%ebp),%eax
  802206:	eb 02                	jmp    80220a <devpipe_read+0x2c>
				return i;
  802208:	89 f0                	mov    %esi,%eax
}
  80220a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80220d:	5b                   	pop    %ebx
  80220e:	5e                   	pop    %esi
  80220f:	5f                   	pop    %edi
  802210:	5d                   	pop    %ebp
  802211:	c3                   	ret    
			sys_yield();
  802212:	e8 5f ea ff ff       	call   800c76 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802217:	8b 03                	mov    (%ebx),%eax
  802219:	3b 43 04             	cmp    0x4(%ebx),%eax
  80221c:	75 18                	jne    802236 <devpipe_read+0x58>
			if (i > 0)
  80221e:	85 f6                	test   %esi,%esi
  802220:	75 e6                	jne    802208 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  802222:	89 da                	mov    %ebx,%edx
  802224:	89 f8                	mov    %edi,%eax
  802226:	e8 c8 fe ff ff       	call   8020f3 <_pipeisclosed>
  80222b:	85 c0                	test   %eax,%eax
  80222d:	74 e3                	je     802212 <devpipe_read+0x34>
				return 0;
  80222f:	b8 00 00 00 00       	mov    $0x0,%eax
  802234:	eb d4                	jmp    80220a <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802236:	99                   	cltd   
  802237:	c1 ea 1b             	shr    $0x1b,%edx
  80223a:	01 d0                	add    %edx,%eax
  80223c:	83 e0 1f             	and    $0x1f,%eax
  80223f:	29 d0                	sub    %edx,%eax
  802241:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802246:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802249:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80224c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80224f:	83 c6 01             	add    $0x1,%esi
  802252:	eb aa                	jmp    8021fe <devpipe_read+0x20>

00802254 <pipe>:
{
  802254:	f3 0f 1e fb          	endbr32 
  802258:	55                   	push   %ebp
  802259:	89 e5                	mov    %esp,%ebp
  80225b:	56                   	push   %esi
  80225c:	53                   	push   %ebx
  80225d:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802260:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802263:	50                   	push   %eax
  802264:	e8 32 f1 ff ff       	call   80139b <fd_alloc>
  802269:	89 c3                	mov    %eax,%ebx
  80226b:	83 c4 10             	add    $0x10,%esp
  80226e:	85 c0                	test   %eax,%eax
  802270:	0f 88 23 01 00 00    	js     802399 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802276:	83 ec 04             	sub    $0x4,%esp
  802279:	68 07 04 00 00       	push   $0x407
  80227e:	ff 75 f4             	pushl  -0xc(%ebp)
  802281:	6a 00                	push   $0x0
  802283:	e8 11 ea ff ff       	call   800c99 <sys_page_alloc>
  802288:	89 c3                	mov    %eax,%ebx
  80228a:	83 c4 10             	add    $0x10,%esp
  80228d:	85 c0                	test   %eax,%eax
  80228f:	0f 88 04 01 00 00    	js     802399 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  802295:	83 ec 0c             	sub    $0xc,%esp
  802298:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80229b:	50                   	push   %eax
  80229c:	e8 fa f0 ff ff       	call   80139b <fd_alloc>
  8022a1:	89 c3                	mov    %eax,%ebx
  8022a3:	83 c4 10             	add    $0x10,%esp
  8022a6:	85 c0                	test   %eax,%eax
  8022a8:	0f 88 db 00 00 00    	js     802389 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022ae:	83 ec 04             	sub    $0x4,%esp
  8022b1:	68 07 04 00 00       	push   $0x407
  8022b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8022b9:	6a 00                	push   $0x0
  8022bb:	e8 d9 e9 ff ff       	call   800c99 <sys_page_alloc>
  8022c0:	89 c3                	mov    %eax,%ebx
  8022c2:	83 c4 10             	add    $0x10,%esp
  8022c5:	85 c0                	test   %eax,%eax
  8022c7:	0f 88 bc 00 00 00    	js     802389 <pipe+0x135>
	va = fd2data(fd0);
  8022cd:	83 ec 0c             	sub    $0xc,%esp
  8022d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8022d3:	e8 a8 f0 ff ff       	call   801380 <fd2data>
  8022d8:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022da:	83 c4 0c             	add    $0xc,%esp
  8022dd:	68 07 04 00 00       	push   $0x407
  8022e2:	50                   	push   %eax
  8022e3:	6a 00                	push   $0x0
  8022e5:	e8 af e9 ff ff       	call   800c99 <sys_page_alloc>
  8022ea:	89 c3                	mov    %eax,%ebx
  8022ec:	83 c4 10             	add    $0x10,%esp
  8022ef:	85 c0                	test   %eax,%eax
  8022f1:	0f 88 82 00 00 00    	js     802379 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022f7:	83 ec 0c             	sub    $0xc,%esp
  8022fa:	ff 75 f0             	pushl  -0x10(%ebp)
  8022fd:	e8 7e f0 ff ff       	call   801380 <fd2data>
  802302:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802309:	50                   	push   %eax
  80230a:	6a 00                	push   $0x0
  80230c:	56                   	push   %esi
  80230d:	6a 00                	push   $0x0
  80230f:	e8 cc e9 ff ff       	call   800ce0 <sys_page_map>
  802314:	89 c3                	mov    %eax,%ebx
  802316:	83 c4 20             	add    $0x20,%esp
  802319:	85 c0                	test   %eax,%eax
  80231b:	78 4e                	js     80236b <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  80231d:	a1 3c 30 80 00       	mov    0x80303c,%eax
  802322:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802325:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802327:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80232a:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802331:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802334:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802336:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802339:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802340:	83 ec 0c             	sub    $0xc,%esp
  802343:	ff 75 f4             	pushl  -0xc(%ebp)
  802346:	e8 21 f0 ff ff       	call   80136c <fd2num>
  80234b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80234e:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802350:	83 c4 04             	add    $0x4,%esp
  802353:	ff 75 f0             	pushl  -0x10(%ebp)
  802356:	e8 11 f0 ff ff       	call   80136c <fd2num>
  80235b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80235e:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802361:	83 c4 10             	add    $0x10,%esp
  802364:	bb 00 00 00 00       	mov    $0x0,%ebx
  802369:	eb 2e                	jmp    802399 <pipe+0x145>
	sys_page_unmap(0, va);
  80236b:	83 ec 08             	sub    $0x8,%esp
  80236e:	56                   	push   %esi
  80236f:	6a 00                	push   $0x0
  802371:	e8 b0 e9 ff ff       	call   800d26 <sys_page_unmap>
  802376:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802379:	83 ec 08             	sub    $0x8,%esp
  80237c:	ff 75 f0             	pushl  -0x10(%ebp)
  80237f:	6a 00                	push   $0x0
  802381:	e8 a0 e9 ff ff       	call   800d26 <sys_page_unmap>
  802386:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802389:	83 ec 08             	sub    $0x8,%esp
  80238c:	ff 75 f4             	pushl  -0xc(%ebp)
  80238f:	6a 00                	push   $0x0
  802391:	e8 90 e9 ff ff       	call   800d26 <sys_page_unmap>
  802396:	83 c4 10             	add    $0x10,%esp
}
  802399:	89 d8                	mov    %ebx,%eax
  80239b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80239e:	5b                   	pop    %ebx
  80239f:	5e                   	pop    %esi
  8023a0:	5d                   	pop    %ebp
  8023a1:	c3                   	ret    

008023a2 <pipeisclosed>:
{
  8023a2:	f3 0f 1e fb          	endbr32 
  8023a6:	55                   	push   %ebp
  8023a7:	89 e5                	mov    %esp,%ebp
  8023a9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023af:	50                   	push   %eax
  8023b0:	ff 75 08             	pushl  0x8(%ebp)
  8023b3:	e8 39 f0 ff ff       	call   8013f1 <fd_lookup>
  8023b8:	83 c4 10             	add    $0x10,%esp
  8023bb:	85 c0                	test   %eax,%eax
  8023bd:	78 18                	js     8023d7 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  8023bf:	83 ec 0c             	sub    $0xc,%esp
  8023c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8023c5:	e8 b6 ef ff ff       	call   801380 <fd2data>
  8023ca:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  8023cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cf:	e8 1f fd ff ff       	call   8020f3 <_pipeisclosed>
  8023d4:	83 c4 10             	add    $0x10,%esp
}
  8023d7:	c9                   	leave  
  8023d8:	c3                   	ret    

008023d9 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8023d9:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8023dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e2:	c3                   	ret    

008023e3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8023e3:	f3 0f 1e fb          	endbr32 
  8023e7:	55                   	push   %ebp
  8023e8:	89 e5                	mov    %esp,%ebp
  8023ea:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8023ed:	68 fb 2d 80 00       	push   $0x802dfb
  8023f2:	ff 75 0c             	pushl  0xc(%ebp)
  8023f5:	e8 5d e4 ff ff       	call   800857 <strcpy>
	return 0;
}
  8023fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ff:	c9                   	leave  
  802400:	c3                   	ret    

00802401 <devcons_write>:
{
  802401:	f3 0f 1e fb          	endbr32 
  802405:	55                   	push   %ebp
  802406:	89 e5                	mov    %esp,%ebp
  802408:	57                   	push   %edi
  802409:	56                   	push   %esi
  80240a:	53                   	push   %ebx
  80240b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802411:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802416:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80241c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80241f:	73 31                	jae    802452 <devcons_write+0x51>
		m = n - tot;
  802421:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802424:	29 f3                	sub    %esi,%ebx
  802426:	83 fb 7f             	cmp    $0x7f,%ebx
  802429:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80242e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802431:	83 ec 04             	sub    $0x4,%esp
  802434:	53                   	push   %ebx
  802435:	89 f0                	mov    %esi,%eax
  802437:	03 45 0c             	add    0xc(%ebp),%eax
  80243a:	50                   	push   %eax
  80243b:	57                   	push   %edi
  80243c:	e8 cc e5 ff ff       	call   800a0d <memmove>
		sys_cputs(buf, m);
  802441:	83 c4 08             	add    $0x8,%esp
  802444:	53                   	push   %ebx
  802445:	57                   	push   %edi
  802446:	e8 7e e7 ff ff       	call   800bc9 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80244b:	01 de                	add    %ebx,%esi
  80244d:	83 c4 10             	add    $0x10,%esp
  802450:	eb ca                	jmp    80241c <devcons_write+0x1b>
}
  802452:	89 f0                	mov    %esi,%eax
  802454:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802457:	5b                   	pop    %ebx
  802458:	5e                   	pop    %esi
  802459:	5f                   	pop    %edi
  80245a:	5d                   	pop    %ebp
  80245b:	c3                   	ret    

0080245c <devcons_read>:
{
  80245c:	f3 0f 1e fb          	endbr32 
  802460:	55                   	push   %ebp
  802461:	89 e5                	mov    %esp,%ebp
  802463:	83 ec 08             	sub    $0x8,%esp
  802466:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80246b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80246f:	74 21                	je     802492 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802471:	e8 75 e7 ff ff       	call   800beb <sys_cgetc>
  802476:	85 c0                	test   %eax,%eax
  802478:	75 07                	jne    802481 <devcons_read+0x25>
		sys_yield();
  80247a:	e8 f7 e7 ff ff       	call   800c76 <sys_yield>
  80247f:	eb f0                	jmp    802471 <devcons_read+0x15>
	if (c < 0)
  802481:	78 0f                	js     802492 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  802483:	83 f8 04             	cmp    $0x4,%eax
  802486:	74 0c                	je     802494 <devcons_read+0x38>
	*(char*)vbuf = c;
  802488:	8b 55 0c             	mov    0xc(%ebp),%edx
  80248b:	88 02                	mov    %al,(%edx)
	return 1;
  80248d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802492:	c9                   	leave  
  802493:	c3                   	ret    
		return 0;
  802494:	b8 00 00 00 00       	mov    $0x0,%eax
  802499:	eb f7                	jmp    802492 <devcons_read+0x36>

0080249b <cputchar>:
{
  80249b:	f3 0f 1e fb          	endbr32 
  80249f:	55                   	push   %ebp
  8024a0:	89 e5                	mov    %esp,%ebp
  8024a2:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8024a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a8:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8024ab:	6a 01                	push   $0x1
  8024ad:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024b0:	50                   	push   %eax
  8024b1:	e8 13 e7 ff ff       	call   800bc9 <sys_cputs>
}
  8024b6:	83 c4 10             	add    $0x10,%esp
  8024b9:	c9                   	leave  
  8024ba:	c3                   	ret    

008024bb <getchar>:
{
  8024bb:	f3 0f 1e fb          	endbr32 
  8024bf:	55                   	push   %ebp
  8024c0:	89 e5                	mov    %esp,%ebp
  8024c2:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8024c5:	6a 01                	push   $0x1
  8024c7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024ca:	50                   	push   %eax
  8024cb:	6a 00                	push   $0x0
  8024cd:	e8 a7 f1 ff ff       	call   801679 <read>
	if (r < 0)
  8024d2:	83 c4 10             	add    $0x10,%esp
  8024d5:	85 c0                	test   %eax,%eax
  8024d7:	78 06                	js     8024df <getchar+0x24>
	if (r < 1)
  8024d9:	74 06                	je     8024e1 <getchar+0x26>
	return c;
  8024db:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8024df:	c9                   	leave  
  8024e0:	c3                   	ret    
		return -E_EOF;
  8024e1:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8024e6:	eb f7                	jmp    8024df <getchar+0x24>

008024e8 <iscons>:
{
  8024e8:	f3 0f 1e fb          	endbr32 
  8024ec:	55                   	push   %ebp
  8024ed:	89 e5                	mov    %esp,%ebp
  8024ef:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024f5:	50                   	push   %eax
  8024f6:	ff 75 08             	pushl  0x8(%ebp)
  8024f9:	e8 f3 ee ff ff       	call   8013f1 <fd_lookup>
  8024fe:	83 c4 10             	add    $0x10,%esp
  802501:	85 c0                	test   %eax,%eax
  802503:	78 11                	js     802516 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  802505:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802508:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80250e:	39 10                	cmp    %edx,(%eax)
  802510:	0f 94 c0             	sete   %al
  802513:	0f b6 c0             	movzbl %al,%eax
}
  802516:	c9                   	leave  
  802517:	c3                   	ret    

00802518 <opencons>:
{
  802518:	f3 0f 1e fb          	endbr32 
  80251c:	55                   	push   %ebp
  80251d:	89 e5                	mov    %esp,%ebp
  80251f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802522:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802525:	50                   	push   %eax
  802526:	e8 70 ee ff ff       	call   80139b <fd_alloc>
  80252b:	83 c4 10             	add    $0x10,%esp
  80252e:	85 c0                	test   %eax,%eax
  802530:	78 3a                	js     80256c <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802532:	83 ec 04             	sub    $0x4,%esp
  802535:	68 07 04 00 00       	push   $0x407
  80253a:	ff 75 f4             	pushl  -0xc(%ebp)
  80253d:	6a 00                	push   $0x0
  80253f:	e8 55 e7 ff ff       	call   800c99 <sys_page_alloc>
  802544:	83 c4 10             	add    $0x10,%esp
  802547:	85 c0                	test   %eax,%eax
  802549:	78 21                	js     80256c <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80254b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254e:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802554:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802559:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802560:	83 ec 0c             	sub    $0xc,%esp
  802563:	50                   	push   %eax
  802564:	e8 03 ee ff ff       	call   80136c <fd2num>
  802569:	83 c4 10             	add    $0x10,%esp
}
  80256c:	c9                   	leave  
  80256d:	c3                   	ret    

0080256e <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80256e:	f3 0f 1e fb          	endbr32 
  802572:	55                   	push   %ebp
  802573:	89 e5                	mov    %esp,%ebp
  802575:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802578:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  80257f:	74 0a                	je     80258b <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802581:	8b 45 08             	mov    0x8(%ebp),%eax
  802584:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802589:	c9                   	leave  
  80258a:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  80258b:	83 ec 04             	sub    $0x4,%esp
  80258e:	6a 07                	push   $0x7
  802590:	68 00 f0 bf ee       	push   $0xeebff000
  802595:	6a 00                	push   $0x0
  802597:	e8 fd e6 ff ff       	call   800c99 <sys_page_alloc>
  80259c:	83 c4 10             	add    $0x10,%esp
  80259f:	85 c0                	test   %eax,%eax
  8025a1:	78 2a                	js     8025cd <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  8025a3:	83 ec 08             	sub    $0x8,%esp
  8025a6:	68 e1 25 80 00       	push   $0x8025e1
  8025ab:	6a 00                	push   $0x0
  8025ad:	e8 46 e8 ff ff       	call   800df8 <sys_env_set_pgfault_upcall>
  8025b2:	83 c4 10             	add    $0x10,%esp
  8025b5:	85 c0                	test   %eax,%eax
  8025b7:	79 c8                	jns    802581 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  8025b9:	83 ec 04             	sub    $0x4,%esp
  8025bc:	68 34 2e 80 00       	push   $0x802e34
  8025c1:	6a 25                	push   $0x25
  8025c3:	68 6c 2e 80 00       	push   $0x802e6c
  8025c8:	e8 99 db ff ff       	call   800166 <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  8025cd:	83 ec 04             	sub    $0x4,%esp
  8025d0:	68 08 2e 80 00       	push   $0x802e08
  8025d5:	6a 22                	push   $0x22
  8025d7:	68 6c 2e 80 00       	push   $0x802e6c
  8025dc:	e8 85 db ff ff       	call   800166 <_panic>

008025e1 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8025e1:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8025e2:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  8025e7:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8025e9:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  8025ec:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  8025f0:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  8025f4:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8025f7:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  8025f9:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  8025fd:	83 c4 08             	add    $0x8,%esp
	popal
  802600:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  802601:	83 c4 04             	add    $0x4,%esp
	popfl
  802604:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  802605:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  802606:	c3                   	ret    

00802607 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802607:	f3 0f 1e fb          	endbr32 
  80260b:	55                   	push   %ebp
  80260c:	89 e5                	mov    %esp,%ebp
  80260e:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802611:	89 c2                	mov    %eax,%edx
  802613:	c1 ea 16             	shr    $0x16,%edx
  802616:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80261d:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802622:	f6 c1 01             	test   $0x1,%cl
  802625:	74 1c                	je     802643 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802627:	c1 e8 0c             	shr    $0xc,%eax
  80262a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802631:	a8 01                	test   $0x1,%al
  802633:	74 0e                	je     802643 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802635:	c1 e8 0c             	shr    $0xc,%eax
  802638:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80263f:	ef 
  802640:	0f b7 d2             	movzwl %dx,%edx
}
  802643:	89 d0                	mov    %edx,%eax
  802645:	5d                   	pop    %ebp
  802646:	c3                   	ret    
  802647:	66 90                	xchg   %ax,%ax
  802649:	66 90                	xchg   %ax,%ax
  80264b:	66 90                	xchg   %ax,%ax
  80264d:	66 90                	xchg   %ax,%ax
  80264f:	90                   	nop

00802650 <__udivdi3>:
  802650:	f3 0f 1e fb          	endbr32 
  802654:	55                   	push   %ebp
  802655:	57                   	push   %edi
  802656:	56                   	push   %esi
  802657:	53                   	push   %ebx
  802658:	83 ec 1c             	sub    $0x1c,%esp
  80265b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80265f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802663:	8b 74 24 34          	mov    0x34(%esp),%esi
  802667:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80266b:	85 d2                	test   %edx,%edx
  80266d:	75 19                	jne    802688 <__udivdi3+0x38>
  80266f:	39 f3                	cmp    %esi,%ebx
  802671:	76 4d                	jbe    8026c0 <__udivdi3+0x70>
  802673:	31 ff                	xor    %edi,%edi
  802675:	89 e8                	mov    %ebp,%eax
  802677:	89 f2                	mov    %esi,%edx
  802679:	f7 f3                	div    %ebx
  80267b:	89 fa                	mov    %edi,%edx
  80267d:	83 c4 1c             	add    $0x1c,%esp
  802680:	5b                   	pop    %ebx
  802681:	5e                   	pop    %esi
  802682:	5f                   	pop    %edi
  802683:	5d                   	pop    %ebp
  802684:	c3                   	ret    
  802685:	8d 76 00             	lea    0x0(%esi),%esi
  802688:	39 f2                	cmp    %esi,%edx
  80268a:	76 14                	jbe    8026a0 <__udivdi3+0x50>
  80268c:	31 ff                	xor    %edi,%edi
  80268e:	31 c0                	xor    %eax,%eax
  802690:	89 fa                	mov    %edi,%edx
  802692:	83 c4 1c             	add    $0x1c,%esp
  802695:	5b                   	pop    %ebx
  802696:	5e                   	pop    %esi
  802697:	5f                   	pop    %edi
  802698:	5d                   	pop    %ebp
  802699:	c3                   	ret    
  80269a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8026a0:	0f bd fa             	bsr    %edx,%edi
  8026a3:	83 f7 1f             	xor    $0x1f,%edi
  8026a6:	75 48                	jne    8026f0 <__udivdi3+0xa0>
  8026a8:	39 f2                	cmp    %esi,%edx
  8026aa:	72 06                	jb     8026b2 <__udivdi3+0x62>
  8026ac:	31 c0                	xor    %eax,%eax
  8026ae:	39 eb                	cmp    %ebp,%ebx
  8026b0:	77 de                	ja     802690 <__udivdi3+0x40>
  8026b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8026b7:	eb d7                	jmp    802690 <__udivdi3+0x40>
  8026b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026c0:	89 d9                	mov    %ebx,%ecx
  8026c2:	85 db                	test   %ebx,%ebx
  8026c4:	75 0b                	jne    8026d1 <__udivdi3+0x81>
  8026c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8026cb:	31 d2                	xor    %edx,%edx
  8026cd:	f7 f3                	div    %ebx
  8026cf:	89 c1                	mov    %eax,%ecx
  8026d1:	31 d2                	xor    %edx,%edx
  8026d3:	89 f0                	mov    %esi,%eax
  8026d5:	f7 f1                	div    %ecx
  8026d7:	89 c6                	mov    %eax,%esi
  8026d9:	89 e8                	mov    %ebp,%eax
  8026db:	89 f7                	mov    %esi,%edi
  8026dd:	f7 f1                	div    %ecx
  8026df:	89 fa                	mov    %edi,%edx
  8026e1:	83 c4 1c             	add    $0x1c,%esp
  8026e4:	5b                   	pop    %ebx
  8026e5:	5e                   	pop    %esi
  8026e6:	5f                   	pop    %edi
  8026e7:	5d                   	pop    %ebp
  8026e8:	c3                   	ret    
  8026e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026f0:	89 f9                	mov    %edi,%ecx
  8026f2:	b8 20 00 00 00       	mov    $0x20,%eax
  8026f7:	29 f8                	sub    %edi,%eax
  8026f9:	d3 e2                	shl    %cl,%edx
  8026fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8026ff:	89 c1                	mov    %eax,%ecx
  802701:	89 da                	mov    %ebx,%edx
  802703:	d3 ea                	shr    %cl,%edx
  802705:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802709:	09 d1                	or     %edx,%ecx
  80270b:	89 f2                	mov    %esi,%edx
  80270d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802711:	89 f9                	mov    %edi,%ecx
  802713:	d3 e3                	shl    %cl,%ebx
  802715:	89 c1                	mov    %eax,%ecx
  802717:	d3 ea                	shr    %cl,%edx
  802719:	89 f9                	mov    %edi,%ecx
  80271b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80271f:	89 eb                	mov    %ebp,%ebx
  802721:	d3 e6                	shl    %cl,%esi
  802723:	89 c1                	mov    %eax,%ecx
  802725:	d3 eb                	shr    %cl,%ebx
  802727:	09 de                	or     %ebx,%esi
  802729:	89 f0                	mov    %esi,%eax
  80272b:	f7 74 24 08          	divl   0x8(%esp)
  80272f:	89 d6                	mov    %edx,%esi
  802731:	89 c3                	mov    %eax,%ebx
  802733:	f7 64 24 0c          	mull   0xc(%esp)
  802737:	39 d6                	cmp    %edx,%esi
  802739:	72 15                	jb     802750 <__udivdi3+0x100>
  80273b:	89 f9                	mov    %edi,%ecx
  80273d:	d3 e5                	shl    %cl,%ebp
  80273f:	39 c5                	cmp    %eax,%ebp
  802741:	73 04                	jae    802747 <__udivdi3+0xf7>
  802743:	39 d6                	cmp    %edx,%esi
  802745:	74 09                	je     802750 <__udivdi3+0x100>
  802747:	89 d8                	mov    %ebx,%eax
  802749:	31 ff                	xor    %edi,%edi
  80274b:	e9 40 ff ff ff       	jmp    802690 <__udivdi3+0x40>
  802750:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802753:	31 ff                	xor    %edi,%edi
  802755:	e9 36 ff ff ff       	jmp    802690 <__udivdi3+0x40>
  80275a:	66 90                	xchg   %ax,%ax
  80275c:	66 90                	xchg   %ax,%ax
  80275e:	66 90                	xchg   %ax,%ax

00802760 <__umoddi3>:
  802760:	f3 0f 1e fb          	endbr32 
  802764:	55                   	push   %ebp
  802765:	57                   	push   %edi
  802766:	56                   	push   %esi
  802767:	53                   	push   %ebx
  802768:	83 ec 1c             	sub    $0x1c,%esp
  80276b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80276f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802773:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802777:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80277b:	85 c0                	test   %eax,%eax
  80277d:	75 19                	jne    802798 <__umoddi3+0x38>
  80277f:	39 df                	cmp    %ebx,%edi
  802781:	76 5d                	jbe    8027e0 <__umoddi3+0x80>
  802783:	89 f0                	mov    %esi,%eax
  802785:	89 da                	mov    %ebx,%edx
  802787:	f7 f7                	div    %edi
  802789:	89 d0                	mov    %edx,%eax
  80278b:	31 d2                	xor    %edx,%edx
  80278d:	83 c4 1c             	add    $0x1c,%esp
  802790:	5b                   	pop    %ebx
  802791:	5e                   	pop    %esi
  802792:	5f                   	pop    %edi
  802793:	5d                   	pop    %ebp
  802794:	c3                   	ret    
  802795:	8d 76 00             	lea    0x0(%esi),%esi
  802798:	89 f2                	mov    %esi,%edx
  80279a:	39 d8                	cmp    %ebx,%eax
  80279c:	76 12                	jbe    8027b0 <__umoddi3+0x50>
  80279e:	89 f0                	mov    %esi,%eax
  8027a0:	89 da                	mov    %ebx,%edx
  8027a2:	83 c4 1c             	add    $0x1c,%esp
  8027a5:	5b                   	pop    %ebx
  8027a6:	5e                   	pop    %esi
  8027a7:	5f                   	pop    %edi
  8027a8:	5d                   	pop    %ebp
  8027a9:	c3                   	ret    
  8027aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8027b0:	0f bd e8             	bsr    %eax,%ebp
  8027b3:	83 f5 1f             	xor    $0x1f,%ebp
  8027b6:	75 50                	jne    802808 <__umoddi3+0xa8>
  8027b8:	39 d8                	cmp    %ebx,%eax
  8027ba:	0f 82 e0 00 00 00    	jb     8028a0 <__umoddi3+0x140>
  8027c0:	89 d9                	mov    %ebx,%ecx
  8027c2:	39 f7                	cmp    %esi,%edi
  8027c4:	0f 86 d6 00 00 00    	jbe    8028a0 <__umoddi3+0x140>
  8027ca:	89 d0                	mov    %edx,%eax
  8027cc:	89 ca                	mov    %ecx,%edx
  8027ce:	83 c4 1c             	add    $0x1c,%esp
  8027d1:	5b                   	pop    %ebx
  8027d2:	5e                   	pop    %esi
  8027d3:	5f                   	pop    %edi
  8027d4:	5d                   	pop    %ebp
  8027d5:	c3                   	ret    
  8027d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027dd:	8d 76 00             	lea    0x0(%esi),%esi
  8027e0:	89 fd                	mov    %edi,%ebp
  8027e2:	85 ff                	test   %edi,%edi
  8027e4:	75 0b                	jne    8027f1 <__umoddi3+0x91>
  8027e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8027eb:	31 d2                	xor    %edx,%edx
  8027ed:	f7 f7                	div    %edi
  8027ef:	89 c5                	mov    %eax,%ebp
  8027f1:	89 d8                	mov    %ebx,%eax
  8027f3:	31 d2                	xor    %edx,%edx
  8027f5:	f7 f5                	div    %ebp
  8027f7:	89 f0                	mov    %esi,%eax
  8027f9:	f7 f5                	div    %ebp
  8027fb:	89 d0                	mov    %edx,%eax
  8027fd:	31 d2                	xor    %edx,%edx
  8027ff:	eb 8c                	jmp    80278d <__umoddi3+0x2d>
  802801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802808:	89 e9                	mov    %ebp,%ecx
  80280a:	ba 20 00 00 00       	mov    $0x20,%edx
  80280f:	29 ea                	sub    %ebp,%edx
  802811:	d3 e0                	shl    %cl,%eax
  802813:	89 44 24 08          	mov    %eax,0x8(%esp)
  802817:	89 d1                	mov    %edx,%ecx
  802819:	89 f8                	mov    %edi,%eax
  80281b:	d3 e8                	shr    %cl,%eax
  80281d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802821:	89 54 24 04          	mov    %edx,0x4(%esp)
  802825:	8b 54 24 04          	mov    0x4(%esp),%edx
  802829:	09 c1                	or     %eax,%ecx
  80282b:	89 d8                	mov    %ebx,%eax
  80282d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802831:	89 e9                	mov    %ebp,%ecx
  802833:	d3 e7                	shl    %cl,%edi
  802835:	89 d1                	mov    %edx,%ecx
  802837:	d3 e8                	shr    %cl,%eax
  802839:	89 e9                	mov    %ebp,%ecx
  80283b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80283f:	d3 e3                	shl    %cl,%ebx
  802841:	89 c7                	mov    %eax,%edi
  802843:	89 d1                	mov    %edx,%ecx
  802845:	89 f0                	mov    %esi,%eax
  802847:	d3 e8                	shr    %cl,%eax
  802849:	89 e9                	mov    %ebp,%ecx
  80284b:	89 fa                	mov    %edi,%edx
  80284d:	d3 e6                	shl    %cl,%esi
  80284f:	09 d8                	or     %ebx,%eax
  802851:	f7 74 24 08          	divl   0x8(%esp)
  802855:	89 d1                	mov    %edx,%ecx
  802857:	89 f3                	mov    %esi,%ebx
  802859:	f7 64 24 0c          	mull   0xc(%esp)
  80285d:	89 c6                	mov    %eax,%esi
  80285f:	89 d7                	mov    %edx,%edi
  802861:	39 d1                	cmp    %edx,%ecx
  802863:	72 06                	jb     80286b <__umoddi3+0x10b>
  802865:	75 10                	jne    802877 <__umoddi3+0x117>
  802867:	39 c3                	cmp    %eax,%ebx
  802869:	73 0c                	jae    802877 <__umoddi3+0x117>
  80286b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80286f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802873:	89 d7                	mov    %edx,%edi
  802875:	89 c6                	mov    %eax,%esi
  802877:	89 ca                	mov    %ecx,%edx
  802879:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80287e:	29 f3                	sub    %esi,%ebx
  802880:	19 fa                	sbb    %edi,%edx
  802882:	89 d0                	mov    %edx,%eax
  802884:	d3 e0                	shl    %cl,%eax
  802886:	89 e9                	mov    %ebp,%ecx
  802888:	d3 eb                	shr    %cl,%ebx
  80288a:	d3 ea                	shr    %cl,%edx
  80288c:	09 d8                	or     %ebx,%eax
  80288e:	83 c4 1c             	add    $0x1c,%esp
  802891:	5b                   	pop    %ebx
  802892:	5e                   	pop    %esi
  802893:	5f                   	pop    %edi
  802894:	5d                   	pop    %ebp
  802895:	c3                   	ret    
  802896:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80289d:	8d 76 00             	lea    0x0(%esi),%esi
  8028a0:	29 fe                	sub    %edi,%esi
  8028a2:	19 c3                	sbb    %eax,%ebx
  8028a4:	89 f2                	mov    %esi,%edx
  8028a6:	89 d9                	mov    %ebx,%ecx
  8028a8:	e9 1d ff ff ff       	jmp    8027ca <__umoddi3+0x6a>
