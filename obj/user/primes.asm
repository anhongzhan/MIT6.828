
obj/user/primes:     file format elf32-i386


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
  80004b:	e8 d7 10 00 00       	call   801127 <ipc_recv>
  800050:	89 c3                	mov    %eax,%ebx
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  800052:	a1 04 20 80 00       	mov    0x802004,%eax
  800057:	8b 40 5c             	mov    0x5c(%eax),%eax
  80005a:	83 c4 0c             	add    $0xc,%esp
  80005d:	53                   	push   %ebx
  80005e:	50                   	push   %eax
  80005f:	68 40 15 80 00       	push   $0x801540
  800064:	e8 dc 01 00 00       	call   800245 <cprintf>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  800069:	e8 ce 0e 00 00       	call   800f3c <fork>
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
  80007f:	68 2a 18 80 00       	push   $0x80182a
  800084:	6a 1a                	push   $0x1a
  800086:	68 4c 15 80 00       	push   $0x80154c
  80008b:	e8 ce 00 00 00       	call   80015e <_panic>
		if (i % p)
			ipc_send(id, i, 0, 0);
  800090:	6a 00                	push   $0x0
  800092:	6a 00                	push   $0x0
  800094:	51                   	push   %ecx
  800095:	57                   	push   %edi
  800096:	e8 11 11 00 00       	call   8011ac <ipc_send>
  80009b:	83 c4 10             	add    $0x10,%esp
		i = ipc_recv(&envid, 0, 0);
  80009e:	83 ec 04             	sub    $0x4,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	6a 00                	push   $0x0
  8000a5:	56                   	push   %esi
  8000a6:	e8 7c 10 00 00       	call   801127 <ipc_recv>
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
  8000c2:	e8 75 0e 00 00       	call   800f3c <fork>
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
  8000da:	e8 cd 10 00 00       	call   8011ac <ipc_send>
	for (i = 2; ; i++)
  8000df:	83 c3 01             	add    $0x1,%ebx
  8000e2:	83 c4 10             	add    $0x10,%esp
  8000e5:	eb ed                	jmp    8000d4 <umain+0x1b>
		panic("fork: %e", id);
  8000e7:	50                   	push   %eax
  8000e8:	68 2a 18 80 00       	push   $0x80182a
  8000ed:	6a 2d                	push   $0x2d
  8000ef:	68 4c 15 80 00       	push   $0x80154c
  8000f4:	e8 65 00 00 00       	call   80015e <_panic>
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
  80010d:	e8 39 0b 00 00       	call   800c4b <sys_getenvid>
  800112:	25 ff 03 00 00       	and    $0x3ff,%eax
  800117:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80011a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80011f:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800124:	85 db                	test   %ebx,%ebx
  800126:	7e 07                	jle    80012f <libmain+0x31>
		binaryname = argv[0];
  800128:	8b 06                	mov    (%esi),%eax
  80012a:	a3 00 20 80 00       	mov    %eax,0x802000

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
  80014f:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  800152:	6a 00                	push   $0x0
  800154:	e8 ad 0a 00 00       	call   800c06 <sys_env_destroy>
}
  800159:	83 c4 10             	add    $0x10,%esp
  80015c:	c9                   	leave  
  80015d:	c3                   	ret    

0080015e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80015e:	f3 0f 1e fb          	endbr32 
  800162:	55                   	push   %ebp
  800163:	89 e5                	mov    %esp,%ebp
  800165:	56                   	push   %esi
  800166:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800167:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80016a:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800170:	e8 d6 0a 00 00       	call   800c4b <sys_getenvid>
  800175:	83 ec 0c             	sub    $0xc,%esp
  800178:	ff 75 0c             	pushl  0xc(%ebp)
  80017b:	ff 75 08             	pushl  0x8(%ebp)
  80017e:	56                   	push   %esi
  80017f:	50                   	push   %eax
  800180:	68 64 15 80 00       	push   $0x801564
  800185:	e8 bb 00 00 00       	call   800245 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80018a:	83 c4 18             	add    $0x18,%esp
  80018d:	53                   	push   %ebx
  80018e:	ff 75 10             	pushl  0x10(%ebp)
  800191:	e8 5a 00 00 00       	call   8001f0 <vcprintf>
	cprintf("\n");
  800196:	c7 04 24 99 18 80 00 	movl   $0x801899,(%esp)
  80019d:	e8 a3 00 00 00       	call   800245 <cprintf>
  8001a2:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001a5:	cc                   	int3   
  8001a6:	eb fd                	jmp    8001a5 <_panic+0x47>

008001a8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001a8:	f3 0f 1e fb          	endbr32 
  8001ac:	55                   	push   %ebp
  8001ad:	89 e5                	mov    %esp,%ebp
  8001af:	53                   	push   %ebx
  8001b0:	83 ec 04             	sub    $0x4,%esp
  8001b3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001b6:	8b 13                	mov    (%ebx),%edx
  8001b8:	8d 42 01             	lea    0x1(%edx),%eax
  8001bb:	89 03                	mov    %eax,(%ebx)
  8001bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001c0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001c4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001c9:	74 09                	je     8001d4 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001cb:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001d2:	c9                   	leave  
  8001d3:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001d4:	83 ec 08             	sub    $0x8,%esp
  8001d7:	68 ff 00 00 00       	push   $0xff
  8001dc:	8d 43 08             	lea    0x8(%ebx),%eax
  8001df:	50                   	push   %eax
  8001e0:	e8 dc 09 00 00       	call   800bc1 <sys_cputs>
		b->idx = 0;
  8001e5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001eb:	83 c4 10             	add    $0x10,%esp
  8001ee:	eb db                	jmp    8001cb <putch+0x23>

008001f0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001f0:	f3 0f 1e fb          	endbr32 
  8001f4:	55                   	push   %ebp
  8001f5:	89 e5                	mov    %esp,%ebp
  8001f7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001fd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800204:	00 00 00 
	b.cnt = 0;
  800207:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80020e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800211:	ff 75 0c             	pushl  0xc(%ebp)
  800214:	ff 75 08             	pushl  0x8(%ebp)
  800217:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80021d:	50                   	push   %eax
  80021e:	68 a8 01 80 00       	push   $0x8001a8
  800223:	e8 20 01 00 00       	call   800348 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800228:	83 c4 08             	add    $0x8,%esp
  80022b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800231:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800237:	50                   	push   %eax
  800238:	e8 84 09 00 00       	call   800bc1 <sys_cputs>

	return b.cnt;
}
  80023d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800243:	c9                   	leave  
  800244:	c3                   	ret    

00800245 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800245:	f3 0f 1e fb          	endbr32 
  800249:	55                   	push   %ebp
  80024a:	89 e5                	mov    %esp,%ebp
  80024c:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80024f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800252:	50                   	push   %eax
  800253:	ff 75 08             	pushl  0x8(%ebp)
  800256:	e8 95 ff ff ff       	call   8001f0 <vcprintf>
	va_end(ap);

	return cnt;
}
  80025b:	c9                   	leave  
  80025c:	c3                   	ret    

0080025d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80025d:	55                   	push   %ebp
  80025e:	89 e5                	mov    %esp,%ebp
  800260:	57                   	push   %edi
  800261:	56                   	push   %esi
  800262:	53                   	push   %ebx
  800263:	83 ec 1c             	sub    $0x1c,%esp
  800266:	89 c7                	mov    %eax,%edi
  800268:	89 d6                	mov    %edx,%esi
  80026a:	8b 45 08             	mov    0x8(%ebp),%eax
  80026d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800270:	89 d1                	mov    %edx,%ecx
  800272:	89 c2                	mov    %eax,%edx
  800274:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800277:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80027a:	8b 45 10             	mov    0x10(%ebp),%eax
  80027d:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800280:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800283:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80028a:	39 c2                	cmp    %eax,%edx
  80028c:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80028f:	72 3e                	jb     8002cf <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800291:	83 ec 0c             	sub    $0xc,%esp
  800294:	ff 75 18             	pushl  0x18(%ebp)
  800297:	83 eb 01             	sub    $0x1,%ebx
  80029a:	53                   	push   %ebx
  80029b:	50                   	push   %eax
  80029c:	83 ec 08             	sub    $0x8,%esp
  80029f:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a2:	ff 75 e0             	pushl  -0x20(%ebp)
  8002a5:	ff 75 dc             	pushl  -0x24(%ebp)
  8002a8:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ab:	e8 30 10 00 00       	call   8012e0 <__udivdi3>
  8002b0:	83 c4 18             	add    $0x18,%esp
  8002b3:	52                   	push   %edx
  8002b4:	50                   	push   %eax
  8002b5:	89 f2                	mov    %esi,%edx
  8002b7:	89 f8                	mov    %edi,%eax
  8002b9:	e8 9f ff ff ff       	call   80025d <printnum>
  8002be:	83 c4 20             	add    $0x20,%esp
  8002c1:	eb 13                	jmp    8002d6 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002c3:	83 ec 08             	sub    $0x8,%esp
  8002c6:	56                   	push   %esi
  8002c7:	ff 75 18             	pushl  0x18(%ebp)
  8002ca:	ff d7                	call   *%edi
  8002cc:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002cf:	83 eb 01             	sub    $0x1,%ebx
  8002d2:	85 db                	test   %ebx,%ebx
  8002d4:	7f ed                	jg     8002c3 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002d6:	83 ec 08             	sub    $0x8,%esp
  8002d9:	56                   	push   %esi
  8002da:	83 ec 04             	sub    $0x4,%esp
  8002dd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e0:	ff 75 e0             	pushl  -0x20(%ebp)
  8002e3:	ff 75 dc             	pushl  -0x24(%ebp)
  8002e6:	ff 75 d8             	pushl  -0x28(%ebp)
  8002e9:	e8 02 11 00 00       	call   8013f0 <__umoddi3>
  8002ee:	83 c4 14             	add    $0x14,%esp
  8002f1:	0f be 80 87 15 80 00 	movsbl 0x801587(%eax),%eax
  8002f8:	50                   	push   %eax
  8002f9:	ff d7                	call   *%edi
}
  8002fb:	83 c4 10             	add    $0x10,%esp
  8002fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800301:	5b                   	pop    %ebx
  800302:	5e                   	pop    %esi
  800303:	5f                   	pop    %edi
  800304:	5d                   	pop    %ebp
  800305:	c3                   	ret    

00800306 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800306:	f3 0f 1e fb          	endbr32 
  80030a:	55                   	push   %ebp
  80030b:	89 e5                	mov    %esp,%ebp
  80030d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800310:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800314:	8b 10                	mov    (%eax),%edx
  800316:	3b 50 04             	cmp    0x4(%eax),%edx
  800319:	73 0a                	jae    800325 <sprintputch+0x1f>
		*b->buf++ = ch;
  80031b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80031e:	89 08                	mov    %ecx,(%eax)
  800320:	8b 45 08             	mov    0x8(%ebp),%eax
  800323:	88 02                	mov    %al,(%edx)
}
  800325:	5d                   	pop    %ebp
  800326:	c3                   	ret    

00800327 <printfmt>:
{
  800327:	f3 0f 1e fb          	endbr32 
  80032b:	55                   	push   %ebp
  80032c:	89 e5                	mov    %esp,%ebp
  80032e:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800331:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800334:	50                   	push   %eax
  800335:	ff 75 10             	pushl  0x10(%ebp)
  800338:	ff 75 0c             	pushl  0xc(%ebp)
  80033b:	ff 75 08             	pushl  0x8(%ebp)
  80033e:	e8 05 00 00 00       	call   800348 <vprintfmt>
}
  800343:	83 c4 10             	add    $0x10,%esp
  800346:	c9                   	leave  
  800347:	c3                   	ret    

00800348 <vprintfmt>:
{
  800348:	f3 0f 1e fb          	endbr32 
  80034c:	55                   	push   %ebp
  80034d:	89 e5                	mov    %esp,%ebp
  80034f:	57                   	push   %edi
  800350:	56                   	push   %esi
  800351:	53                   	push   %ebx
  800352:	83 ec 3c             	sub    $0x3c,%esp
  800355:	8b 75 08             	mov    0x8(%ebp),%esi
  800358:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80035b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80035e:	e9 8e 03 00 00       	jmp    8006f1 <vprintfmt+0x3a9>
		padc = ' ';
  800363:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800367:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80036e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800375:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80037c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800381:	8d 47 01             	lea    0x1(%edi),%eax
  800384:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800387:	0f b6 17             	movzbl (%edi),%edx
  80038a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80038d:	3c 55                	cmp    $0x55,%al
  80038f:	0f 87 df 03 00 00    	ja     800774 <vprintfmt+0x42c>
  800395:	0f b6 c0             	movzbl %al,%eax
  800398:	3e ff 24 85 40 16 80 	notrack jmp *0x801640(,%eax,4)
  80039f:	00 
  8003a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003a3:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8003a7:	eb d8                	jmp    800381 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003a9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003ac:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8003b0:	eb cf                	jmp    800381 <vprintfmt+0x39>
  8003b2:	0f b6 d2             	movzbl %dl,%edx
  8003b5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8003bd:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003c0:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003c3:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003c7:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003ca:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003cd:	83 f9 09             	cmp    $0x9,%ecx
  8003d0:	77 55                	ja     800427 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8003d2:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003d5:	eb e9                	jmp    8003c0 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8003d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003da:	8b 00                	mov    (%eax),%eax
  8003dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003df:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e2:	8d 40 04             	lea    0x4(%eax),%eax
  8003e5:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003eb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003ef:	79 90                	jns    800381 <vprintfmt+0x39>
				width = precision, precision = -1;
  8003f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003fe:	eb 81                	jmp    800381 <vprintfmt+0x39>
  800400:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800403:	85 c0                	test   %eax,%eax
  800405:	ba 00 00 00 00       	mov    $0x0,%edx
  80040a:	0f 49 d0             	cmovns %eax,%edx
  80040d:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800410:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800413:	e9 69 ff ff ff       	jmp    800381 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800418:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80041b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800422:	e9 5a ff ff ff       	jmp    800381 <vprintfmt+0x39>
  800427:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80042a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80042d:	eb bc                	jmp    8003eb <vprintfmt+0xa3>
			lflag++;
  80042f:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800432:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800435:	e9 47 ff ff ff       	jmp    800381 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80043a:	8b 45 14             	mov    0x14(%ebp),%eax
  80043d:	8d 78 04             	lea    0x4(%eax),%edi
  800440:	83 ec 08             	sub    $0x8,%esp
  800443:	53                   	push   %ebx
  800444:	ff 30                	pushl  (%eax)
  800446:	ff d6                	call   *%esi
			break;
  800448:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80044b:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80044e:	e9 9b 02 00 00       	jmp    8006ee <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800453:	8b 45 14             	mov    0x14(%ebp),%eax
  800456:	8d 78 04             	lea    0x4(%eax),%edi
  800459:	8b 00                	mov    (%eax),%eax
  80045b:	99                   	cltd   
  80045c:	31 d0                	xor    %edx,%eax
  80045e:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800460:	83 f8 08             	cmp    $0x8,%eax
  800463:	7f 23                	jg     800488 <vprintfmt+0x140>
  800465:	8b 14 85 a0 17 80 00 	mov    0x8017a0(,%eax,4),%edx
  80046c:	85 d2                	test   %edx,%edx
  80046e:	74 18                	je     800488 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800470:	52                   	push   %edx
  800471:	68 a8 15 80 00       	push   $0x8015a8
  800476:	53                   	push   %ebx
  800477:	56                   	push   %esi
  800478:	e8 aa fe ff ff       	call   800327 <printfmt>
  80047d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800480:	89 7d 14             	mov    %edi,0x14(%ebp)
  800483:	e9 66 02 00 00       	jmp    8006ee <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800488:	50                   	push   %eax
  800489:	68 9f 15 80 00       	push   $0x80159f
  80048e:	53                   	push   %ebx
  80048f:	56                   	push   %esi
  800490:	e8 92 fe ff ff       	call   800327 <printfmt>
  800495:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800498:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80049b:	e9 4e 02 00 00       	jmp    8006ee <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8004a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a3:	83 c0 04             	add    $0x4,%eax
  8004a6:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8004a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ac:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8004ae:	85 d2                	test   %edx,%edx
  8004b0:	b8 98 15 80 00       	mov    $0x801598,%eax
  8004b5:	0f 45 c2             	cmovne %edx,%eax
  8004b8:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004bb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004bf:	7e 06                	jle    8004c7 <vprintfmt+0x17f>
  8004c1:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004c5:	75 0d                	jne    8004d4 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004ca:	89 c7                	mov    %eax,%edi
  8004cc:	03 45 e0             	add    -0x20(%ebp),%eax
  8004cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004d2:	eb 55                	jmp    800529 <vprintfmt+0x1e1>
  8004d4:	83 ec 08             	sub    $0x8,%esp
  8004d7:	ff 75 d8             	pushl  -0x28(%ebp)
  8004da:	ff 75 cc             	pushl  -0x34(%ebp)
  8004dd:	e8 46 03 00 00       	call   800828 <strnlen>
  8004e2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004e5:	29 c2                	sub    %eax,%edx
  8004e7:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004ea:	83 c4 10             	add    $0x10,%esp
  8004ed:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004ef:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f6:	85 ff                	test   %edi,%edi
  8004f8:	7e 11                	jle    80050b <vprintfmt+0x1c3>
					putch(padc, putdat);
  8004fa:	83 ec 08             	sub    $0x8,%esp
  8004fd:	53                   	push   %ebx
  8004fe:	ff 75 e0             	pushl  -0x20(%ebp)
  800501:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800503:	83 ef 01             	sub    $0x1,%edi
  800506:	83 c4 10             	add    $0x10,%esp
  800509:	eb eb                	jmp    8004f6 <vprintfmt+0x1ae>
  80050b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80050e:	85 d2                	test   %edx,%edx
  800510:	b8 00 00 00 00       	mov    $0x0,%eax
  800515:	0f 49 c2             	cmovns %edx,%eax
  800518:	29 c2                	sub    %eax,%edx
  80051a:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80051d:	eb a8                	jmp    8004c7 <vprintfmt+0x17f>
					putch(ch, putdat);
  80051f:	83 ec 08             	sub    $0x8,%esp
  800522:	53                   	push   %ebx
  800523:	52                   	push   %edx
  800524:	ff d6                	call   *%esi
  800526:	83 c4 10             	add    $0x10,%esp
  800529:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80052c:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80052e:	83 c7 01             	add    $0x1,%edi
  800531:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800535:	0f be d0             	movsbl %al,%edx
  800538:	85 d2                	test   %edx,%edx
  80053a:	74 4b                	je     800587 <vprintfmt+0x23f>
  80053c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800540:	78 06                	js     800548 <vprintfmt+0x200>
  800542:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800546:	78 1e                	js     800566 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800548:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80054c:	74 d1                	je     80051f <vprintfmt+0x1d7>
  80054e:	0f be c0             	movsbl %al,%eax
  800551:	83 e8 20             	sub    $0x20,%eax
  800554:	83 f8 5e             	cmp    $0x5e,%eax
  800557:	76 c6                	jbe    80051f <vprintfmt+0x1d7>
					putch('?', putdat);
  800559:	83 ec 08             	sub    $0x8,%esp
  80055c:	53                   	push   %ebx
  80055d:	6a 3f                	push   $0x3f
  80055f:	ff d6                	call   *%esi
  800561:	83 c4 10             	add    $0x10,%esp
  800564:	eb c3                	jmp    800529 <vprintfmt+0x1e1>
  800566:	89 cf                	mov    %ecx,%edi
  800568:	eb 0e                	jmp    800578 <vprintfmt+0x230>
				putch(' ', putdat);
  80056a:	83 ec 08             	sub    $0x8,%esp
  80056d:	53                   	push   %ebx
  80056e:	6a 20                	push   $0x20
  800570:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800572:	83 ef 01             	sub    $0x1,%edi
  800575:	83 c4 10             	add    $0x10,%esp
  800578:	85 ff                	test   %edi,%edi
  80057a:	7f ee                	jg     80056a <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  80057c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80057f:	89 45 14             	mov    %eax,0x14(%ebp)
  800582:	e9 67 01 00 00       	jmp    8006ee <vprintfmt+0x3a6>
  800587:	89 cf                	mov    %ecx,%edi
  800589:	eb ed                	jmp    800578 <vprintfmt+0x230>
	if (lflag >= 2)
  80058b:	83 f9 01             	cmp    $0x1,%ecx
  80058e:	7f 1b                	jg     8005ab <vprintfmt+0x263>
	else if (lflag)
  800590:	85 c9                	test   %ecx,%ecx
  800592:	74 63                	je     8005f7 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800594:	8b 45 14             	mov    0x14(%ebp),%eax
  800597:	8b 00                	mov    (%eax),%eax
  800599:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80059c:	99                   	cltd   
  80059d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a3:	8d 40 04             	lea    0x4(%eax),%eax
  8005a6:	89 45 14             	mov    %eax,0x14(%ebp)
  8005a9:	eb 17                	jmp    8005c2 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  8005ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ae:	8b 50 04             	mov    0x4(%eax),%edx
  8005b1:	8b 00                	mov    (%eax),%eax
  8005b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bc:	8d 40 08             	lea    0x8(%eax),%eax
  8005bf:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005c2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005c5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005c8:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8005cd:	85 c9                	test   %ecx,%ecx
  8005cf:	0f 89 ff 00 00 00    	jns    8006d4 <vprintfmt+0x38c>
				putch('-', putdat);
  8005d5:	83 ec 08             	sub    $0x8,%esp
  8005d8:	53                   	push   %ebx
  8005d9:	6a 2d                	push   $0x2d
  8005db:	ff d6                	call   *%esi
				num = -(long long) num;
  8005dd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005e0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005e3:	f7 da                	neg    %edx
  8005e5:	83 d1 00             	adc    $0x0,%ecx
  8005e8:	f7 d9                	neg    %ecx
  8005ea:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005ed:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f2:	e9 dd 00 00 00       	jmp    8006d4 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8005f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fa:	8b 00                	mov    (%eax),%eax
  8005fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ff:	99                   	cltd   
  800600:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800603:	8b 45 14             	mov    0x14(%ebp),%eax
  800606:	8d 40 04             	lea    0x4(%eax),%eax
  800609:	89 45 14             	mov    %eax,0x14(%ebp)
  80060c:	eb b4                	jmp    8005c2 <vprintfmt+0x27a>
	if (lflag >= 2)
  80060e:	83 f9 01             	cmp    $0x1,%ecx
  800611:	7f 1e                	jg     800631 <vprintfmt+0x2e9>
	else if (lflag)
  800613:	85 c9                	test   %ecx,%ecx
  800615:	74 32                	je     800649 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800617:	8b 45 14             	mov    0x14(%ebp),%eax
  80061a:	8b 10                	mov    (%eax),%edx
  80061c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800621:	8d 40 04             	lea    0x4(%eax),%eax
  800624:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800627:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  80062c:	e9 a3 00 00 00       	jmp    8006d4 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800631:	8b 45 14             	mov    0x14(%ebp),%eax
  800634:	8b 10                	mov    (%eax),%edx
  800636:	8b 48 04             	mov    0x4(%eax),%ecx
  800639:	8d 40 08             	lea    0x8(%eax),%eax
  80063c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80063f:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800644:	e9 8b 00 00 00       	jmp    8006d4 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800649:	8b 45 14             	mov    0x14(%ebp),%eax
  80064c:	8b 10                	mov    (%eax),%edx
  80064e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800653:	8d 40 04             	lea    0x4(%eax),%eax
  800656:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800659:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  80065e:	eb 74                	jmp    8006d4 <vprintfmt+0x38c>
	if (lflag >= 2)
  800660:	83 f9 01             	cmp    $0x1,%ecx
  800663:	7f 1b                	jg     800680 <vprintfmt+0x338>
	else if (lflag)
  800665:	85 c9                	test   %ecx,%ecx
  800667:	74 2c                	je     800695 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800669:	8b 45 14             	mov    0x14(%ebp),%eax
  80066c:	8b 10                	mov    (%eax),%edx
  80066e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800673:	8d 40 04             	lea    0x4(%eax),%eax
  800676:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800679:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  80067e:	eb 54                	jmp    8006d4 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800680:	8b 45 14             	mov    0x14(%ebp),%eax
  800683:	8b 10                	mov    (%eax),%edx
  800685:	8b 48 04             	mov    0x4(%eax),%ecx
  800688:	8d 40 08             	lea    0x8(%eax),%eax
  80068b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80068e:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800693:	eb 3f                	jmp    8006d4 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	8b 10                	mov    (%eax),%edx
  80069a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80069f:	8d 40 04             	lea    0x4(%eax),%eax
  8006a2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006a5:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  8006aa:	eb 28                	jmp    8006d4 <vprintfmt+0x38c>
			putch('0', putdat);
  8006ac:	83 ec 08             	sub    $0x8,%esp
  8006af:	53                   	push   %ebx
  8006b0:	6a 30                	push   $0x30
  8006b2:	ff d6                	call   *%esi
			putch('x', putdat);
  8006b4:	83 c4 08             	add    $0x8,%esp
  8006b7:	53                   	push   %ebx
  8006b8:	6a 78                	push   $0x78
  8006ba:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bf:	8b 10                	mov    (%eax),%edx
  8006c1:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006c6:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006c9:	8d 40 04             	lea    0x4(%eax),%eax
  8006cc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006cf:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006d4:	83 ec 0c             	sub    $0xc,%esp
  8006d7:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8006db:	57                   	push   %edi
  8006dc:	ff 75 e0             	pushl  -0x20(%ebp)
  8006df:	50                   	push   %eax
  8006e0:	51                   	push   %ecx
  8006e1:	52                   	push   %edx
  8006e2:	89 da                	mov    %ebx,%edx
  8006e4:	89 f0                	mov    %esi,%eax
  8006e6:	e8 72 fb ff ff       	call   80025d <printnum>
			break;
  8006eb:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006ee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006f1:	83 c7 01             	add    $0x1,%edi
  8006f4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006f8:	83 f8 25             	cmp    $0x25,%eax
  8006fb:	0f 84 62 fc ff ff    	je     800363 <vprintfmt+0x1b>
			if (ch == '\0')
  800701:	85 c0                	test   %eax,%eax
  800703:	0f 84 8b 00 00 00    	je     800794 <vprintfmt+0x44c>
			putch(ch, putdat);
  800709:	83 ec 08             	sub    $0x8,%esp
  80070c:	53                   	push   %ebx
  80070d:	50                   	push   %eax
  80070e:	ff d6                	call   *%esi
  800710:	83 c4 10             	add    $0x10,%esp
  800713:	eb dc                	jmp    8006f1 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800715:	83 f9 01             	cmp    $0x1,%ecx
  800718:	7f 1b                	jg     800735 <vprintfmt+0x3ed>
	else if (lflag)
  80071a:	85 c9                	test   %ecx,%ecx
  80071c:	74 2c                	je     80074a <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  80071e:	8b 45 14             	mov    0x14(%ebp),%eax
  800721:	8b 10                	mov    (%eax),%edx
  800723:	b9 00 00 00 00       	mov    $0x0,%ecx
  800728:	8d 40 04             	lea    0x4(%eax),%eax
  80072b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80072e:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800733:	eb 9f                	jmp    8006d4 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800735:	8b 45 14             	mov    0x14(%ebp),%eax
  800738:	8b 10                	mov    (%eax),%edx
  80073a:	8b 48 04             	mov    0x4(%eax),%ecx
  80073d:	8d 40 08             	lea    0x8(%eax),%eax
  800740:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800743:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800748:	eb 8a                	jmp    8006d4 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80074a:	8b 45 14             	mov    0x14(%ebp),%eax
  80074d:	8b 10                	mov    (%eax),%edx
  80074f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800754:	8d 40 04             	lea    0x4(%eax),%eax
  800757:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80075a:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  80075f:	e9 70 ff ff ff       	jmp    8006d4 <vprintfmt+0x38c>
			putch(ch, putdat);
  800764:	83 ec 08             	sub    $0x8,%esp
  800767:	53                   	push   %ebx
  800768:	6a 25                	push   $0x25
  80076a:	ff d6                	call   *%esi
			break;
  80076c:	83 c4 10             	add    $0x10,%esp
  80076f:	e9 7a ff ff ff       	jmp    8006ee <vprintfmt+0x3a6>
			putch('%', putdat);
  800774:	83 ec 08             	sub    $0x8,%esp
  800777:	53                   	push   %ebx
  800778:	6a 25                	push   $0x25
  80077a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80077c:	83 c4 10             	add    $0x10,%esp
  80077f:	89 f8                	mov    %edi,%eax
  800781:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800785:	74 05                	je     80078c <vprintfmt+0x444>
  800787:	83 e8 01             	sub    $0x1,%eax
  80078a:	eb f5                	jmp    800781 <vprintfmt+0x439>
  80078c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80078f:	e9 5a ff ff ff       	jmp    8006ee <vprintfmt+0x3a6>
}
  800794:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800797:	5b                   	pop    %ebx
  800798:	5e                   	pop    %esi
  800799:	5f                   	pop    %edi
  80079a:	5d                   	pop    %ebp
  80079b:	c3                   	ret    

0080079c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80079c:	f3 0f 1e fb          	endbr32 
  8007a0:	55                   	push   %ebp
  8007a1:	89 e5                	mov    %esp,%ebp
  8007a3:	83 ec 18             	sub    $0x18,%esp
  8007a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a9:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007af:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007b3:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007bd:	85 c0                	test   %eax,%eax
  8007bf:	74 26                	je     8007e7 <vsnprintf+0x4b>
  8007c1:	85 d2                	test   %edx,%edx
  8007c3:	7e 22                	jle    8007e7 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007c5:	ff 75 14             	pushl  0x14(%ebp)
  8007c8:	ff 75 10             	pushl  0x10(%ebp)
  8007cb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007ce:	50                   	push   %eax
  8007cf:	68 06 03 80 00       	push   $0x800306
  8007d4:	e8 6f fb ff ff       	call   800348 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007dc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007e2:	83 c4 10             	add    $0x10,%esp
}
  8007e5:	c9                   	leave  
  8007e6:	c3                   	ret    
		return -E_INVAL;
  8007e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007ec:	eb f7                	jmp    8007e5 <vsnprintf+0x49>

008007ee <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007ee:	f3 0f 1e fb          	endbr32 
  8007f2:	55                   	push   %ebp
  8007f3:	89 e5                	mov    %esp,%ebp
  8007f5:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007f8:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007fb:	50                   	push   %eax
  8007fc:	ff 75 10             	pushl  0x10(%ebp)
  8007ff:	ff 75 0c             	pushl  0xc(%ebp)
  800802:	ff 75 08             	pushl  0x8(%ebp)
  800805:	e8 92 ff ff ff       	call   80079c <vsnprintf>
	va_end(ap);

	return rc;
}
  80080a:	c9                   	leave  
  80080b:	c3                   	ret    

0080080c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80080c:	f3 0f 1e fb          	endbr32 
  800810:	55                   	push   %ebp
  800811:	89 e5                	mov    %esp,%ebp
  800813:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800816:	b8 00 00 00 00       	mov    $0x0,%eax
  80081b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80081f:	74 05                	je     800826 <strlen+0x1a>
		n++;
  800821:	83 c0 01             	add    $0x1,%eax
  800824:	eb f5                	jmp    80081b <strlen+0xf>
	return n;
}
  800826:	5d                   	pop    %ebp
  800827:	c3                   	ret    

00800828 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800828:	f3 0f 1e fb          	endbr32 
  80082c:	55                   	push   %ebp
  80082d:	89 e5                	mov    %esp,%ebp
  80082f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800832:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800835:	b8 00 00 00 00       	mov    $0x0,%eax
  80083a:	39 d0                	cmp    %edx,%eax
  80083c:	74 0d                	je     80084b <strnlen+0x23>
  80083e:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800842:	74 05                	je     800849 <strnlen+0x21>
		n++;
  800844:	83 c0 01             	add    $0x1,%eax
  800847:	eb f1                	jmp    80083a <strnlen+0x12>
  800849:	89 c2                	mov    %eax,%edx
	return n;
}
  80084b:	89 d0                	mov    %edx,%eax
  80084d:	5d                   	pop    %ebp
  80084e:	c3                   	ret    

0080084f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80084f:	f3 0f 1e fb          	endbr32 
  800853:	55                   	push   %ebp
  800854:	89 e5                	mov    %esp,%ebp
  800856:	53                   	push   %ebx
  800857:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80085a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80085d:	b8 00 00 00 00       	mov    $0x0,%eax
  800862:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800866:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800869:	83 c0 01             	add    $0x1,%eax
  80086c:	84 d2                	test   %dl,%dl
  80086e:	75 f2                	jne    800862 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800870:	89 c8                	mov    %ecx,%eax
  800872:	5b                   	pop    %ebx
  800873:	5d                   	pop    %ebp
  800874:	c3                   	ret    

00800875 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800875:	f3 0f 1e fb          	endbr32 
  800879:	55                   	push   %ebp
  80087a:	89 e5                	mov    %esp,%ebp
  80087c:	53                   	push   %ebx
  80087d:	83 ec 10             	sub    $0x10,%esp
  800880:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800883:	53                   	push   %ebx
  800884:	e8 83 ff ff ff       	call   80080c <strlen>
  800889:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80088c:	ff 75 0c             	pushl  0xc(%ebp)
  80088f:	01 d8                	add    %ebx,%eax
  800891:	50                   	push   %eax
  800892:	e8 b8 ff ff ff       	call   80084f <strcpy>
	return dst;
}
  800897:	89 d8                	mov    %ebx,%eax
  800899:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80089c:	c9                   	leave  
  80089d:	c3                   	ret    

0080089e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80089e:	f3 0f 1e fb          	endbr32 
  8008a2:	55                   	push   %ebp
  8008a3:	89 e5                	mov    %esp,%ebp
  8008a5:	56                   	push   %esi
  8008a6:	53                   	push   %ebx
  8008a7:	8b 75 08             	mov    0x8(%ebp),%esi
  8008aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ad:	89 f3                	mov    %esi,%ebx
  8008af:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008b2:	89 f0                	mov    %esi,%eax
  8008b4:	39 d8                	cmp    %ebx,%eax
  8008b6:	74 11                	je     8008c9 <strncpy+0x2b>
		*dst++ = *src;
  8008b8:	83 c0 01             	add    $0x1,%eax
  8008bb:	0f b6 0a             	movzbl (%edx),%ecx
  8008be:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008c1:	80 f9 01             	cmp    $0x1,%cl
  8008c4:	83 da ff             	sbb    $0xffffffff,%edx
  8008c7:	eb eb                	jmp    8008b4 <strncpy+0x16>
	}
	return ret;
}
  8008c9:	89 f0                	mov    %esi,%eax
  8008cb:	5b                   	pop    %ebx
  8008cc:	5e                   	pop    %esi
  8008cd:	5d                   	pop    %ebp
  8008ce:	c3                   	ret    

008008cf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008cf:	f3 0f 1e fb          	endbr32 
  8008d3:	55                   	push   %ebp
  8008d4:	89 e5                	mov    %esp,%ebp
  8008d6:	56                   	push   %esi
  8008d7:	53                   	push   %ebx
  8008d8:	8b 75 08             	mov    0x8(%ebp),%esi
  8008db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008de:	8b 55 10             	mov    0x10(%ebp),%edx
  8008e1:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008e3:	85 d2                	test   %edx,%edx
  8008e5:	74 21                	je     800908 <strlcpy+0x39>
  8008e7:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008eb:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008ed:	39 c2                	cmp    %eax,%edx
  8008ef:	74 14                	je     800905 <strlcpy+0x36>
  8008f1:	0f b6 19             	movzbl (%ecx),%ebx
  8008f4:	84 db                	test   %bl,%bl
  8008f6:	74 0b                	je     800903 <strlcpy+0x34>
			*dst++ = *src++;
  8008f8:	83 c1 01             	add    $0x1,%ecx
  8008fb:	83 c2 01             	add    $0x1,%edx
  8008fe:	88 5a ff             	mov    %bl,-0x1(%edx)
  800901:	eb ea                	jmp    8008ed <strlcpy+0x1e>
  800903:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800905:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800908:	29 f0                	sub    %esi,%eax
}
  80090a:	5b                   	pop    %ebx
  80090b:	5e                   	pop    %esi
  80090c:	5d                   	pop    %ebp
  80090d:	c3                   	ret    

0080090e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80090e:	f3 0f 1e fb          	endbr32 
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
  800915:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800918:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80091b:	0f b6 01             	movzbl (%ecx),%eax
  80091e:	84 c0                	test   %al,%al
  800920:	74 0c                	je     80092e <strcmp+0x20>
  800922:	3a 02                	cmp    (%edx),%al
  800924:	75 08                	jne    80092e <strcmp+0x20>
		p++, q++;
  800926:	83 c1 01             	add    $0x1,%ecx
  800929:	83 c2 01             	add    $0x1,%edx
  80092c:	eb ed                	jmp    80091b <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80092e:	0f b6 c0             	movzbl %al,%eax
  800931:	0f b6 12             	movzbl (%edx),%edx
  800934:	29 d0                	sub    %edx,%eax
}
  800936:	5d                   	pop    %ebp
  800937:	c3                   	ret    

00800938 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800938:	f3 0f 1e fb          	endbr32 
  80093c:	55                   	push   %ebp
  80093d:	89 e5                	mov    %esp,%ebp
  80093f:	53                   	push   %ebx
  800940:	8b 45 08             	mov    0x8(%ebp),%eax
  800943:	8b 55 0c             	mov    0xc(%ebp),%edx
  800946:	89 c3                	mov    %eax,%ebx
  800948:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80094b:	eb 06                	jmp    800953 <strncmp+0x1b>
		n--, p++, q++;
  80094d:	83 c0 01             	add    $0x1,%eax
  800950:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800953:	39 d8                	cmp    %ebx,%eax
  800955:	74 16                	je     80096d <strncmp+0x35>
  800957:	0f b6 08             	movzbl (%eax),%ecx
  80095a:	84 c9                	test   %cl,%cl
  80095c:	74 04                	je     800962 <strncmp+0x2a>
  80095e:	3a 0a                	cmp    (%edx),%cl
  800960:	74 eb                	je     80094d <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800962:	0f b6 00             	movzbl (%eax),%eax
  800965:	0f b6 12             	movzbl (%edx),%edx
  800968:	29 d0                	sub    %edx,%eax
}
  80096a:	5b                   	pop    %ebx
  80096b:	5d                   	pop    %ebp
  80096c:	c3                   	ret    
		return 0;
  80096d:	b8 00 00 00 00       	mov    $0x0,%eax
  800972:	eb f6                	jmp    80096a <strncmp+0x32>

00800974 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800974:	f3 0f 1e fb          	endbr32 
  800978:	55                   	push   %ebp
  800979:	89 e5                	mov    %esp,%ebp
  80097b:	8b 45 08             	mov    0x8(%ebp),%eax
  80097e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800982:	0f b6 10             	movzbl (%eax),%edx
  800985:	84 d2                	test   %dl,%dl
  800987:	74 09                	je     800992 <strchr+0x1e>
		if (*s == c)
  800989:	38 ca                	cmp    %cl,%dl
  80098b:	74 0a                	je     800997 <strchr+0x23>
	for (; *s; s++)
  80098d:	83 c0 01             	add    $0x1,%eax
  800990:	eb f0                	jmp    800982 <strchr+0xe>
			return (char *) s;
	return 0;
  800992:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800997:	5d                   	pop    %ebp
  800998:	c3                   	ret    

00800999 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800999:	f3 0f 1e fb          	endbr32 
  80099d:	55                   	push   %ebp
  80099e:	89 e5                	mov    %esp,%ebp
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009a7:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009aa:	38 ca                	cmp    %cl,%dl
  8009ac:	74 09                	je     8009b7 <strfind+0x1e>
  8009ae:	84 d2                	test   %dl,%dl
  8009b0:	74 05                	je     8009b7 <strfind+0x1e>
	for (; *s; s++)
  8009b2:	83 c0 01             	add    $0x1,%eax
  8009b5:	eb f0                	jmp    8009a7 <strfind+0xe>
			break;
	return (char *) s;
}
  8009b7:	5d                   	pop    %ebp
  8009b8:	c3                   	ret    

008009b9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009b9:	f3 0f 1e fb          	endbr32 
  8009bd:	55                   	push   %ebp
  8009be:	89 e5                	mov    %esp,%ebp
  8009c0:	57                   	push   %edi
  8009c1:	56                   	push   %esi
  8009c2:	53                   	push   %ebx
  8009c3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009c9:	85 c9                	test   %ecx,%ecx
  8009cb:	74 31                	je     8009fe <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009cd:	89 f8                	mov    %edi,%eax
  8009cf:	09 c8                	or     %ecx,%eax
  8009d1:	a8 03                	test   $0x3,%al
  8009d3:	75 23                	jne    8009f8 <memset+0x3f>
		c &= 0xFF;
  8009d5:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009d9:	89 d3                	mov    %edx,%ebx
  8009db:	c1 e3 08             	shl    $0x8,%ebx
  8009de:	89 d0                	mov    %edx,%eax
  8009e0:	c1 e0 18             	shl    $0x18,%eax
  8009e3:	89 d6                	mov    %edx,%esi
  8009e5:	c1 e6 10             	shl    $0x10,%esi
  8009e8:	09 f0                	or     %esi,%eax
  8009ea:	09 c2                	or     %eax,%edx
  8009ec:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009ee:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009f1:	89 d0                	mov    %edx,%eax
  8009f3:	fc                   	cld    
  8009f4:	f3 ab                	rep stos %eax,%es:(%edi)
  8009f6:	eb 06                	jmp    8009fe <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fb:	fc                   	cld    
  8009fc:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009fe:	89 f8                	mov    %edi,%eax
  800a00:	5b                   	pop    %ebx
  800a01:	5e                   	pop    %esi
  800a02:	5f                   	pop    %edi
  800a03:	5d                   	pop    %ebp
  800a04:	c3                   	ret    

00800a05 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a05:	f3 0f 1e fb          	endbr32 
  800a09:	55                   	push   %ebp
  800a0a:	89 e5                	mov    %esp,%ebp
  800a0c:	57                   	push   %edi
  800a0d:	56                   	push   %esi
  800a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a11:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a14:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a17:	39 c6                	cmp    %eax,%esi
  800a19:	73 32                	jae    800a4d <memmove+0x48>
  800a1b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a1e:	39 c2                	cmp    %eax,%edx
  800a20:	76 2b                	jbe    800a4d <memmove+0x48>
		s += n;
		d += n;
  800a22:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a25:	89 fe                	mov    %edi,%esi
  800a27:	09 ce                	or     %ecx,%esi
  800a29:	09 d6                	or     %edx,%esi
  800a2b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a31:	75 0e                	jne    800a41 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a33:	83 ef 04             	sub    $0x4,%edi
  800a36:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a39:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a3c:	fd                   	std    
  800a3d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a3f:	eb 09                	jmp    800a4a <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a41:	83 ef 01             	sub    $0x1,%edi
  800a44:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a47:	fd                   	std    
  800a48:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a4a:	fc                   	cld    
  800a4b:	eb 1a                	jmp    800a67 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a4d:	89 c2                	mov    %eax,%edx
  800a4f:	09 ca                	or     %ecx,%edx
  800a51:	09 f2                	or     %esi,%edx
  800a53:	f6 c2 03             	test   $0x3,%dl
  800a56:	75 0a                	jne    800a62 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a58:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a5b:	89 c7                	mov    %eax,%edi
  800a5d:	fc                   	cld    
  800a5e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a60:	eb 05                	jmp    800a67 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800a62:	89 c7                	mov    %eax,%edi
  800a64:	fc                   	cld    
  800a65:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a67:	5e                   	pop    %esi
  800a68:	5f                   	pop    %edi
  800a69:	5d                   	pop    %ebp
  800a6a:	c3                   	ret    

00800a6b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a6b:	f3 0f 1e fb          	endbr32 
  800a6f:	55                   	push   %ebp
  800a70:	89 e5                	mov    %esp,%ebp
  800a72:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a75:	ff 75 10             	pushl  0x10(%ebp)
  800a78:	ff 75 0c             	pushl  0xc(%ebp)
  800a7b:	ff 75 08             	pushl  0x8(%ebp)
  800a7e:	e8 82 ff ff ff       	call   800a05 <memmove>
}
  800a83:	c9                   	leave  
  800a84:	c3                   	ret    

00800a85 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a85:	f3 0f 1e fb          	endbr32 
  800a89:	55                   	push   %ebp
  800a8a:	89 e5                	mov    %esp,%ebp
  800a8c:	56                   	push   %esi
  800a8d:	53                   	push   %ebx
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a94:	89 c6                	mov    %eax,%esi
  800a96:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a99:	39 f0                	cmp    %esi,%eax
  800a9b:	74 1c                	je     800ab9 <memcmp+0x34>
		if (*s1 != *s2)
  800a9d:	0f b6 08             	movzbl (%eax),%ecx
  800aa0:	0f b6 1a             	movzbl (%edx),%ebx
  800aa3:	38 d9                	cmp    %bl,%cl
  800aa5:	75 08                	jne    800aaf <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800aa7:	83 c0 01             	add    $0x1,%eax
  800aaa:	83 c2 01             	add    $0x1,%edx
  800aad:	eb ea                	jmp    800a99 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800aaf:	0f b6 c1             	movzbl %cl,%eax
  800ab2:	0f b6 db             	movzbl %bl,%ebx
  800ab5:	29 d8                	sub    %ebx,%eax
  800ab7:	eb 05                	jmp    800abe <memcmp+0x39>
	}

	return 0;
  800ab9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800abe:	5b                   	pop    %ebx
  800abf:	5e                   	pop    %esi
  800ac0:	5d                   	pop    %ebp
  800ac1:	c3                   	ret    

00800ac2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ac2:	f3 0f 1e fb          	endbr32 
  800ac6:	55                   	push   %ebp
  800ac7:	89 e5                	mov    %esp,%ebp
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800acf:	89 c2                	mov    %eax,%edx
  800ad1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ad4:	39 d0                	cmp    %edx,%eax
  800ad6:	73 09                	jae    800ae1 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ad8:	38 08                	cmp    %cl,(%eax)
  800ada:	74 05                	je     800ae1 <memfind+0x1f>
	for (; s < ends; s++)
  800adc:	83 c0 01             	add    $0x1,%eax
  800adf:	eb f3                	jmp    800ad4 <memfind+0x12>
			break;
	return (void *) s;
}
  800ae1:	5d                   	pop    %ebp
  800ae2:	c3                   	ret    

00800ae3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ae3:	f3 0f 1e fb          	endbr32 
  800ae7:	55                   	push   %ebp
  800ae8:	89 e5                	mov    %esp,%ebp
  800aea:	57                   	push   %edi
  800aeb:	56                   	push   %esi
  800aec:	53                   	push   %ebx
  800aed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800af0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800af3:	eb 03                	jmp    800af8 <strtol+0x15>
		s++;
  800af5:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800af8:	0f b6 01             	movzbl (%ecx),%eax
  800afb:	3c 20                	cmp    $0x20,%al
  800afd:	74 f6                	je     800af5 <strtol+0x12>
  800aff:	3c 09                	cmp    $0x9,%al
  800b01:	74 f2                	je     800af5 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800b03:	3c 2b                	cmp    $0x2b,%al
  800b05:	74 2a                	je     800b31 <strtol+0x4e>
	int neg = 0;
  800b07:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b0c:	3c 2d                	cmp    $0x2d,%al
  800b0e:	74 2b                	je     800b3b <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b10:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b16:	75 0f                	jne    800b27 <strtol+0x44>
  800b18:	80 39 30             	cmpb   $0x30,(%ecx)
  800b1b:	74 28                	je     800b45 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b1d:	85 db                	test   %ebx,%ebx
  800b1f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b24:	0f 44 d8             	cmove  %eax,%ebx
  800b27:	b8 00 00 00 00       	mov    $0x0,%eax
  800b2c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b2f:	eb 46                	jmp    800b77 <strtol+0x94>
		s++;
  800b31:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b34:	bf 00 00 00 00       	mov    $0x0,%edi
  800b39:	eb d5                	jmp    800b10 <strtol+0x2d>
		s++, neg = 1;
  800b3b:	83 c1 01             	add    $0x1,%ecx
  800b3e:	bf 01 00 00 00       	mov    $0x1,%edi
  800b43:	eb cb                	jmp    800b10 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b45:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b49:	74 0e                	je     800b59 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b4b:	85 db                	test   %ebx,%ebx
  800b4d:	75 d8                	jne    800b27 <strtol+0x44>
		s++, base = 8;
  800b4f:	83 c1 01             	add    $0x1,%ecx
  800b52:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b57:	eb ce                	jmp    800b27 <strtol+0x44>
		s += 2, base = 16;
  800b59:	83 c1 02             	add    $0x2,%ecx
  800b5c:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b61:	eb c4                	jmp    800b27 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b63:	0f be d2             	movsbl %dl,%edx
  800b66:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b69:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b6c:	7d 3a                	jge    800ba8 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b6e:	83 c1 01             	add    $0x1,%ecx
  800b71:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b75:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b77:	0f b6 11             	movzbl (%ecx),%edx
  800b7a:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b7d:	89 f3                	mov    %esi,%ebx
  800b7f:	80 fb 09             	cmp    $0x9,%bl
  800b82:	76 df                	jbe    800b63 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b84:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b87:	89 f3                	mov    %esi,%ebx
  800b89:	80 fb 19             	cmp    $0x19,%bl
  800b8c:	77 08                	ja     800b96 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b8e:	0f be d2             	movsbl %dl,%edx
  800b91:	83 ea 57             	sub    $0x57,%edx
  800b94:	eb d3                	jmp    800b69 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b96:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b99:	89 f3                	mov    %esi,%ebx
  800b9b:	80 fb 19             	cmp    $0x19,%bl
  800b9e:	77 08                	ja     800ba8 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ba0:	0f be d2             	movsbl %dl,%edx
  800ba3:	83 ea 37             	sub    $0x37,%edx
  800ba6:	eb c1                	jmp    800b69 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ba8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bac:	74 05                	je     800bb3 <strtol+0xd0>
		*endptr = (char *) s;
  800bae:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bb1:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bb3:	89 c2                	mov    %eax,%edx
  800bb5:	f7 da                	neg    %edx
  800bb7:	85 ff                	test   %edi,%edi
  800bb9:	0f 45 c2             	cmovne %edx,%eax
}
  800bbc:	5b                   	pop    %ebx
  800bbd:	5e                   	pop    %esi
  800bbe:	5f                   	pop    %edi
  800bbf:	5d                   	pop    %ebp
  800bc0:	c3                   	ret    

00800bc1 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bc1:	f3 0f 1e fb          	endbr32 
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	57                   	push   %edi
  800bc9:	56                   	push   %esi
  800bca:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bcb:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd0:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bd6:	89 c3                	mov    %eax,%ebx
  800bd8:	89 c7                	mov    %eax,%edi
  800bda:	89 c6                	mov    %eax,%esi
  800bdc:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bde:	5b                   	pop    %ebx
  800bdf:	5e                   	pop    %esi
  800be0:	5f                   	pop    %edi
  800be1:	5d                   	pop    %ebp
  800be2:	c3                   	ret    

00800be3 <sys_cgetc>:

int
sys_cgetc(void)
{
  800be3:	f3 0f 1e fb          	endbr32 
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	57                   	push   %edi
  800beb:	56                   	push   %esi
  800bec:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bed:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf2:	b8 01 00 00 00       	mov    $0x1,%eax
  800bf7:	89 d1                	mov    %edx,%ecx
  800bf9:	89 d3                	mov    %edx,%ebx
  800bfb:	89 d7                	mov    %edx,%edi
  800bfd:	89 d6                	mov    %edx,%esi
  800bff:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c01:	5b                   	pop    %ebx
  800c02:	5e                   	pop    %esi
  800c03:	5f                   	pop    %edi
  800c04:	5d                   	pop    %ebp
  800c05:	c3                   	ret    

00800c06 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c06:	f3 0f 1e fb          	endbr32 
  800c0a:	55                   	push   %ebp
  800c0b:	89 e5                	mov    %esp,%ebp
  800c0d:	57                   	push   %edi
  800c0e:	56                   	push   %esi
  800c0f:	53                   	push   %ebx
  800c10:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c13:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c18:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1b:	b8 03 00 00 00       	mov    $0x3,%eax
  800c20:	89 cb                	mov    %ecx,%ebx
  800c22:	89 cf                	mov    %ecx,%edi
  800c24:	89 ce                	mov    %ecx,%esi
  800c26:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c28:	85 c0                	test   %eax,%eax
  800c2a:	7f 08                	jg     800c34 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c2f:	5b                   	pop    %ebx
  800c30:	5e                   	pop    %esi
  800c31:	5f                   	pop    %edi
  800c32:	5d                   	pop    %ebp
  800c33:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c34:	83 ec 0c             	sub    $0xc,%esp
  800c37:	50                   	push   %eax
  800c38:	6a 03                	push   $0x3
  800c3a:	68 c4 17 80 00       	push   $0x8017c4
  800c3f:	6a 23                	push   $0x23
  800c41:	68 e1 17 80 00       	push   $0x8017e1
  800c46:	e8 13 f5 ff ff       	call   80015e <_panic>

00800c4b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c4b:	f3 0f 1e fb          	endbr32 
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	57                   	push   %edi
  800c53:	56                   	push   %esi
  800c54:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c55:	ba 00 00 00 00       	mov    $0x0,%edx
  800c5a:	b8 02 00 00 00       	mov    $0x2,%eax
  800c5f:	89 d1                	mov    %edx,%ecx
  800c61:	89 d3                	mov    %edx,%ebx
  800c63:	89 d7                	mov    %edx,%edi
  800c65:	89 d6                	mov    %edx,%esi
  800c67:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c69:	5b                   	pop    %ebx
  800c6a:	5e                   	pop    %esi
  800c6b:	5f                   	pop    %edi
  800c6c:	5d                   	pop    %ebp
  800c6d:	c3                   	ret    

00800c6e <sys_yield>:

void
sys_yield(void)
{
  800c6e:	f3 0f 1e fb          	endbr32 
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
  800c75:	57                   	push   %edi
  800c76:	56                   	push   %esi
  800c77:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c78:	ba 00 00 00 00       	mov    $0x0,%edx
  800c7d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c82:	89 d1                	mov    %edx,%ecx
  800c84:	89 d3                	mov    %edx,%ebx
  800c86:	89 d7                	mov    %edx,%edi
  800c88:	89 d6                	mov    %edx,%esi
  800c8a:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c8c:	5b                   	pop    %ebx
  800c8d:	5e                   	pop    %esi
  800c8e:	5f                   	pop    %edi
  800c8f:	5d                   	pop    %ebp
  800c90:	c3                   	ret    

00800c91 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c91:	f3 0f 1e fb          	endbr32 
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	57                   	push   %edi
  800c99:	56                   	push   %esi
  800c9a:	53                   	push   %ebx
  800c9b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c9e:	be 00 00 00 00       	mov    $0x0,%esi
  800ca3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca9:	b8 04 00 00 00       	mov    $0x4,%eax
  800cae:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cb1:	89 f7                	mov    %esi,%edi
  800cb3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cb5:	85 c0                	test   %eax,%eax
  800cb7:	7f 08                	jg     800cc1 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cbc:	5b                   	pop    %ebx
  800cbd:	5e                   	pop    %esi
  800cbe:	5f                   	pop    %edi
  800cbf:	5d                   	pop    %ebp
  800cc0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc1:	83 ec 0c             	sub    $0xc,%esp
  800cc4:	50                   	push   %eax
  800cc5:	6a 04                	push   $0x4
  800cc7:	68 c4 17 80 00       	push   $0x8017c4
  800ccc:	6a 23                	push   $0x23
  800cce:	68 e1 17 80 00       	push   $0x8017e1
  800cd3:	e8 86 f4 ff ff       	call   80015e <_panic>

00800cd8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cd8:	f3 0f 1e fb          	endbr32 
  800cdc:	55                   	push   %ebp
  800cdd:	89 e5                	mov    %esp,%ebp
  800cdf:	57                   	push   %edi
  800ce0:	56                   	push   %esi
  800ce1:	53                   	push   %ebx
  800ce2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ce5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ceb:	b8 05 00 00 00       	mov    $0x5,%eax
  800cf0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cf3:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cf6:	8b 75 18             	mov    0x18(%ebp),%esi
  800cf9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cfb:	85 c0                	test   %eax,%eax
  800cfd:	7f 08                	jg     800d07 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d02:	5b                   	pop    %ebx
  800d03:	5e                   	pop    %esi
  800d04:	5f                   	pop    %edi
  800d05:	5d                   	pop    %ebp
  800d06:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d07:	83 ec 0c             	sub    $0xc,%esp
  800d0a:	50                   	push   %eax
  800d0b:	6a 05                	push   $0x5
  800d0d:	68 c4 17 80 00       	push   $0x8017c4
  800d12:	6a 23                	push   $0x23
  800d14:	68 e1 17 80 00       	push   $0x8017e1
  800d19:	e8 40 f4 ff ff       	call   80015e <_panic>

00800d1e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d1e:	f3 0f 1e fb          	endbr32 
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
  800d25:	57                   	push   %edi
  800d26:	56                   	push   %esi
  800d27:	53                   	push   %ebx
  800d28:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d2b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d30:	8b 55 08             	mov    0x8(%ebp),%edx
  800d33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d36:	b8 06 00 00 00       	mov    $0x6,%eax
  800d3b:	89 df                	mov    %ebx,%edi
  800d3d:	89 de                	mov    %ebx,%esi
  800d3f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d41:	85 c0                	test   %eax,%eax
  800d43:	7f 08                	jg     800d4d <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d45:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d48:	5b                   	pop    %ebx
  800d49:	5e                   	pop    %esi
  800d4a:	5f                   	pop    %edi
  800d4b:	5d                   	pop    %ebp
  800d4c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d4d:	83 ec 0c             	sub    $0xc,%esp
  800d50:	50                   	push   %eax
  800d51:	6a 06                	push   $0x6
  800d53:	68 c4 17 80 00       	push   $0x8017c4
  800d58:	6a 23                	push   $0x23
  800d5a:	68 e1 17 80 00       	push   $0x8017e1
  800d5f:	e8 fa f3 ff ff       	call   80015e <_panic>

00800d64 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d64:	f3 0f 1e fb          	endbr32 
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
  800d6b:	57                   	push   %edi
  800d6c:	56                   	push   %esi
  800d6d:	53                   	push   %ebx
  800d6e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d71:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d76:	8b 55 08             	mov    0x8(%ebp),%edx
  800d79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7c:	b8 08 00 00 00       	mov    $0x8,%eax
  800d81:	89 df                	mov    %ebx,%edi
  800d83:	89 de                	mov    %ebx,%esi
  800d85:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d87:	85 c0                	test   %eax,%eax
  800d89:	7f 08                	jg     800d93 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d8e:	5b                   	pop    %ebx
  800d8f:	5e                   	pop    %esi
  800d90:	5f                   	pop    %edi
  800d91:	5d                   	pop    %ebp
  800d92:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d93:	83 ec 0c             	sub    $0xc,%esp
  800d96:	50                   	push   %eax
  800d97:	6a 08                	push   $0x8
  800d99:	68 c4 17 80 00       	push   $0x8017c4
  800d9e:	6a 23                	push   $0x23
  800da0:	68 e1 17 80 00       	push   $0x8017e1
  800da5:	e8 b4 f3 ff ff       	call   80015e <_panic>

00800daa <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800daa:	f3 0f 1e fb          	endbr32 
  800dae:	55                   	push   %ebp
  800daf:	89 e5                	mov    %esp,%ebp
  800db1:	57                   	push   %edi
  800db2:	56                   	push   %esi
  800db3:	53                   	push   %ebx
  800db4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dbc:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc2:	b8 09 00 00 00       	mov    $0x9,%eax
  800dc7:	89 df                	mov    %ebx,%edi
  800dc9:	89 de                	mov    %ebx,%esi
  800dcb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dcd:	85 c0                	test   %eax,%eax
  800dcf:	7f 08                	jg     800dd9 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd4:	5b                   	pop    %ebx
  800dd5:	5e                   	pop    %esi
  800dd6:	5f                   	pop    %edi
  800dd7:	5d                   	pop    %ebp
  800dd8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd9:	83 ec 0c             	sub    $0xc,%esp
  800ddc:	50                   	push   %eax
  800ddd:	6a 09                	push   $0x9
  800ddf:	68 c4 17 80 00       	push   $0x8017c4
  800de4:	6a 23                	push   $0x23
  800de6:	68 e1 17 80 00       	push   $0x8017e1
  800deb:	e8 6e f3 ff ff       	call   80015e <_panic>

00800df0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800df0:	f3 0f 1e fb          	endbr32 
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
  800df7:	57                   	push   %edi
  800df8:	56                   	push   %esi
  800df9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dfa:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e00:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e05:	be 00 00 00 00       	mov    $0x0,%esi
  800e0a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e0d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e10:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e12:	5b                   	pop    %ebx
  800e13:	5e                   	pop    %esi
  800e14:	5f                   	pop    %edi
  800e15:	5d                   	pop    %ebp
  800e16:	c3                   	ret    

00800e17 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e17:	f3 0f 1e fb          	endbr32 
  800e1b:	55                   	push   %ebp
  800e1c:	89 e5                	mov    %esp,%ebp
  800e1e:	57                   	push   %edi
  800e1f:	56                   	push   %esi
  800e20:	53                   	push   %ebx
  800e21:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e24:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e29:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2c:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e31:	89 cb                	mov    %ecx,%ebx
  800e33:	89 cf                	mov    %ecx,%edi
  800e35:	89 ce                	mov    %ecx,%esi
  800e37:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e39:	85 c0                	test   %eax,%eax
  800e3b:	7f 08                	jg     800e45 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e40:	5b                   	pop    %ebx
  800e41:	5e                   	pop    %esi
  800e42:	5f                   	pop    %edi
  800e43:	5d                   	pop    %ebp
  800e44:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e45:	83 ec 0c             	sub    $0xc,%esp
  800e48:	50                   	push   %eax
  800e49:	6a 0c                	push   $0xc
  800e4b:	68 c4 17 80 00       	push   $0x8017c4
  800e50:	6a 23                	push   $0x23
  800e52:	68 e1 17 80 00       	push   $0x8017e1
  800e57:	e8 02 f3 ff ff       	call   80015e <_panic>

00800e5c <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800e5c:	f3 0f 1e fb          	endbr32 
  800e60:	55                   	push   %ebp
  800e61:	89 e5                	mov    %esp,%ebp
  800e63:	53                   	push   %ebx
  800e64:	83 ec 04             	sub    $0x4,%esp
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800e6a:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  800e6c:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800e70:	74 74                	je     800ee6 <pgfault+0x8a>
  800e72:	89 d8                	mov    %ebx,%eax
  800e74:	c1 e8 0c             	shr    $0xc,%eax
  800e77:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800e7e:	f6 c4 08             	test   $0x8,%ah
  800e81:	74 63                	je     800ee6 <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800e83:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  800e89:	83 ec 0c             	sub    $0xc,%esp
  800e8c:	6a 05                	push   $0x5
  800e8e:	68 00 f0 7f 00       	push   $0x7ff000
  800e93:	6a 00                	push   $0x0
  800e95:	53                   	push   %ebx
  800e96:	6a 00                	push   $0x0
  800e98:	e8 3b fe ff ff       	call   800cd8 <sys_page_map>
  800e9d:	83 c4 20             	add    $0x20,%esp
  800ea0:	85 c0                	test   %eax,%eax
  800ea2:	78 59                	js     800efd <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  800ea4:	83 ec 04             	sub    $0x4,%esp
  800ea7:	6a 07                	push   $0x7
  800ea9:	53                   	push   %ebx
  800eaa:	6a 00                	push   $0x0
  800eac:	e8 e0 fd ff ff       	call   800c91 <sys_page_alloc>
  800eb1:	83 c4 10             	add    $0x10,%esp
  800eb4:	85 c0                	test   %eax,%eax
  800eb6:	78 5a                	js     800f12 <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  800eb8:	83 ec 04             	sub    $0x4,%esp
  800ebb:	68 00 10 00 00       	push   $0x1000
  800ec0:	68 00 f0 7f 00       	push   $0x7ff000
  800ec5:	53                   	push   %ebx
  800ec6:	e8 3a fb ff ff       	call   800a05 <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  800ecb:	83 c4 08             	add    $0x8,%esp
  800ece:	68 00 f0 7f 00       	push   $0x7ff000
  800ed3:	6a 00                	push   $0x0
  800ed5:	e8 44 fe ff ff       	call   800d1e <sys_page_unmap>
  800eda:	83 c4 10             	add    $0x10,%esp
  800edd:	85 c0                	test   %eax,%eax
  800edf:	78 46                	js     800f27 <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  800ee1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ee4:	c9                   	leave  
  800ee5:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  800ee6:	83 ec 04             	sub    $0x4,%esp
  800ee9:	68 ef 17 80 00       	push   $0x8017ef
  800eee:	68 d3 00 00 00       	push   $0xd3
  800ef3:	68 0b 18 80 00       	push   $0x80180b
  800ef8:	e8 61 f2 ff ff       	call   80015e <_panic>
		panic("pgfault: %e\n", r);
  800efd:	50                   	push   %eax
  800efe:	68 16 18 80 00       	push   $0x801816
  800f03:	68 df 00 00 00       	push   $0xdf
  800f08:	68 0b 18 80 00       	push   $0x80180b
  800f0d:	e8 4c f2 ff ff       	call   80015e <_panic>
		panic("pgfault: %e\n", r);
  800f12:	50                   	push   %eax
  800f13:	68 16 18 80 00       	push   $0x801816
  800f18:	68 e3 00 00 00       	push   $0xe3
  800f1d:	68 0b 18 80 00       	push   $0x80180b
  800f22:	e8 37 f2 ff ff       	call   80015e <_panic>
		panic("pgfault: %e\n", r);
  800f27:	50                   	push   %eax
  800f28:	68 16 18 80 00       	push   $0x801816
  800f2d:	68 e9 00 00 00       	push   $0xe9
  800f32:	68 0b 18 80 00       	push   $0x80180b
  800f37:	e8 22 f2 ff ff       	call   80015e <_panic>

00800f3c <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800f3c:	f3 0f 1e fb          	endbr32 
  800f40:	55                   	push   %ebp
  800f41:	89 e5                	mov    %esp,%ebp
  800f43:	57                   	push   %edi
  800f44:	56                   	push   %esi
  800f45:	53                   	push   %ebx
  800f46:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  800f49:	68 5c 0e 80 00       	push   $0x800e5c
  800f4e:	e8 ee 02 00 00       	call   801241 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f53:	b8 07 00 00 00       	mov    $0x7,%eax
  800f58:	cd 30                	int    $0x30
  800f5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  800f5d:	83 c4 10             	add    $0x10,%esp
  800f60:	85 c0                	test   %eax,%eax
  800f62:	78 2d                	js     800f91 <fork+0x55>
  800f64:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800f66:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  800f6b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f6f:	0f 85 81 00 00 00    	jne    800ff6 <fork+0xba>
		thisenv = &envs[ENVX(sys_getenvid())];
  800f75:	e8 d1 fc ff ff       	call   800c4b <sys_getenvid>
  800f7a:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f7f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f82:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f87:	a3 04 20 80 00       	mov    %eax,0x802004
		return 0;
  800f8c:	e9 43 01 00 00       	jmp    8010d4 <fork+0x198>
		panic("sys_exofork: %e", envid);
  800f91:	50                   	push   %eax
  800f92:	68 23 18 80 00       	push   $0x801823
  800f97:	68 26 01 00 00       	push   $0x126
  800f9c:	68 0b 18 80 00       	push   $0x80180b
  800fa1:	e8 b8 f1 ff ff       	call   80015e <_panic>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  800fa6:	c1 e6 0c             	shl    $0xc,%esi
  800fa9:	83 ec 0c             	sub    $0xc,%esp
  800fac:	68 05 08 00 00       	push   $0x805
  800fb1:	56                   	push   %esi
  800fb2:	57                   	push   %edi
  800fb3:	56                   	push   %esi
  800fb4:	6a 00                	push   $0x0
  800fb6:	e8 1d fd ff ff       	call   800cd8 <sys_page_map>
  800fbb:	83 c4 20             	add    $0x20,%esp
  800fbe:	85 c0                	test   %eax,%eax
  800fc0:	0f 88 a8 00 00 00    	js     80106e <fork+0x132>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  800fc6:	83 ec 0c             	sub    $0xc,%esp
  800fc9:	68 05 08 00 00       	push   $0x805
  800fce:	56                   	push   %esi
  800fcf:	6a 00                	push   $0x0
  800fd1:	56                   	push   %esi
  800fd2:	6a 00                	push   $0x0
  800fd4:	e8 ff fc ff ff       	call   800cd8 <sys_page_map>
  800fd9:	83 c4 20             	add    $0x20,%esp
  800fdc:	85 c0                	test   %eax,%eax
  800fde:	0f 88 9f 00 00 00    	js     801083 <fork+0x147>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800fe4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800fea:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  800ff0:	0f 84 a2 00 00 00    	je     801098 <fork+0x15c>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  800ff6:	89 d8                	mov    %ebx,%eax
  800ff8:	c1 e8 16             	shr    $0x16,%eax
  800ffb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801002:	a8 01                	test   $0x1,%al
  801004:	74 de                	je     800fe4 <fork+0xa8>
  801006:	89 de                	mov    %ebx,%esi
  801008:	c1 ee 0c             	shr    $0xc,%esi
  80100b:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801012:	a8 01                	test   $0x1,%al
  801014:	74 ce                	je     800fe4 <fork+0xa8>
  801016:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80101d:	a8 04                	test   $0x4,%al
  80101f:	74 c3                	je     800fe4 <fork+0xa8>
	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  801021:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801028:	a8 02                	test   $0x2,%al
  80102a:	0f 85 76 ff ff ff    	jne    800fa6 <fork+0x6a>
  801030:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801037:	f6 c4 08             	test   $0x8,%ah
  80103a:	0f 85 66 ff ff ff    	jne    800fa6 <fork+0x6a>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  801040:	c1 e6 0c             	shl    $0xc,%esi
  801043:	83 ec 0c             	sub    $0xc,%esp
  801046:	6a 05                	push   $0x5
  801048:	56                   	push   %esi
  801049:	57                   	push   %edi
  80104a:	56                   	push   %esi
  80104b:	6a 00                	push   $0x0
  80104d:	e8 86 fc ff ff       	call   800cd8 <sys_page_map>
  801052:	83 c4 20             	add    $0x20,%esp
  801055:	85 c0                	test   %eax,%eax
  801057:	79 8b                	jns    800fe4 <fork+0xa8>
		panic("duppage: %e\n", r);
  801059:	50                   	push   %eax
  80105a:	68 33 18 80 00       	push   $0x801833
  80105f:	68 08 01 00 00       	push   $0x108
  801064:	68 0b 18 80 00       	push   $0x80180b
  801069:	e8 f0 f0 ff ff       	call   80015e <_panic>
			panic("duppage: %e\n", r);
  80106e:	50                   	push   %eax
  80106f:	68 33 18 80 00       	push   $0x801833
  801074:	68 01 01 00 00       	push   $0x101
  801079:	68 0b 18 80 00       	push   $0x80180b
  80107e:	e8 db f0 ff ff       	call   80015e <_panic>
			panic("duppage: %e\n", r);
  801083:	50                   	push   %eax
  801084:	68 33 18 80 00       	push   $0x801833
  801089:	68 05 01 00 00       	push   $0x105
  80108e:	68 0b 18 80 00       	push   $0x80180b
  801093:	e8 c6 f0 ff ff       	call   80015e <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  801098:	83 ec 04             	sub    $0x4,%esp
  80109b:	6a 07                	push   $0x7
  80109d:	68 00 f0 bf ee       	push   $0xeebff000
  8010a2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010a5:	e8 e7 fb ff ff       	call   800c91 <sys_page_alloc>
  8010aa:	83 c4 10             	add    $0x10,%esp
  8010ad:	85 c0                	test   %eax,%eax
  8010af:	78 2e                	js     8010df <fork+0x1a3>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8010b1:	83 ec 08             	sub    $0x8,%esp
  8010b4:	68 b4 12 80 00       	push   $0x8012b4
  8010b9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8010bc:	57                   	push   %edi
  8010bd:	e8 e8 fc ff ff       	call   800daa <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8010c2:	83 c4 08             	add    $0x8,%esp
  8010c5:	6a 02                	push   $0x2
  8010c7:	57                   	push   %edi
  8010c8:	e8 97 fc ff ff       	call   800d64 <sys_env_set_status>
  8010cd:	83 c4 10             	add    $0x10,%esp
  8010d0:	85 c0                	test   %eax,%eax
  8010d2:	78 20                	js     8010f4 <fork+0x1b8>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  8010d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8010d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010da:	5b                   	pop    %ebx
  8010db:	5e                   	pop    %esi
  8010dc:	5f                   	pop    %edi
  8010dd:	5d                   	pop    %ebp
  8010de:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  8010df:	50                   	push   %eax
  8010e0:	68 40 18 80 00       	push   $0x801840
  8010e5:	68 3a 01 00 00       	push   $0x13a
  8010ea:	68 0b 18 80 00       	push   $0x80180b
  8010ef:	e8 6a f0 ff ff       	call   80015e <_panic>
		panic("sys_env_set_status: %e", r);
  8010f4:	50                   	push   %eax
  8010f5:	68 53 18 80 00       	push   $0x801853
  8010fa:	68 3f 01 00 00       	push   $0x13f
  8010ff:	68 0b 18 80 00       	push   $0x80180b
  801104:	e8 55 f0 ff ff       	call   80015e <_panic>

00801109 <sfork>:

// Challenge!
int
sfork(void)
{
  801109:	f3 0f 1e fb          	endbr32 
  80110d:	55                   	push   %ebp
  80110e:	89 e5                	mov    %esp,%ebp
  801110:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801113:	68 6a 18 80 00       	push   $0x80186a
  801118:	68 48 01 00 00       	push   $0x148
  80111d:	68 0b 18 80 00       	push   $0x80180b
  801122:	e8 37 f0 ff ff       	call   80015e <_panic>

00801127 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801127:	f3 0f 1e fb          	endbr32 
  80112b:	55                   	push   %ebp
  80112c:	89 e5                	mov    %esp,%ebp
  80112e:	56                   	push   %esi
  80112f:	53                   	push   %ebx
  801130:	8b 75 08             	mov    0x8(%ebp),%esi
  801133:	8b 45 0c             	mov    0xc(%ebp),%eax
  801136:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  801139:	85 c0                	test   %eax,%eax
  80113b:	74 3d                	je     80117a <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  80113d:	83 ec 0c             	sub    $0xc,%esp
  801140:	50                   	push   %eax
  801141:	e8 d1 fc ff ff       	call   800e17 <sys_ipc_recv>
  801146:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  801149:	85 f6                	test   %esi,%esi
  80114b:	74 0b                	je     801158 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  80114d:	8b 15 04 20 80 00    	mov    0x802004,%edx
  801153:	8b 52 74             	mov    0x74(%edx),%edx
  801156:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801158:	85 db                	test   %ebx,%ebx
  80115a:	74 0b                	je     801167 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  80115c:	8b 15 04 20 80 00    	mov    0x802004,%edx
  801162:	8b 52 78             	mov    0x78(%edx),%edx
  801165:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  801167:	85 c0                	test   %eax,%eax
  801169:	78 21                	js     80118c <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  80116b:	a1 04 20 80 00       	mov    0x802004,%eax
  801170:	8b 40 70             	mov    0x70(%eax),%eax
}
  801173:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801176:	5b                   	pop    %ebx
  801177:	5e                   	pop    %esi
  801178:	5d                   	pop    %ebp
  801179:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  80117a:	83 ec 0c             	sub    $0xc,%esp
  80117d:	68 00 00 c0 ee       	push   $0xeec00000
  801182:	e8 90 fc ff ff       	call   800e17 <sys_ipc_recv>
  801187:	83 c4 10             	add    $0x10,%esp
  80118a:	eb bd                	jmp    801149 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  80118c:	85 f6                	test   %esi,%esi
  80118e:	74 10                	je     8011a0 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  801190:	85 db                	test   %ebx,%ebx
  801192:	75 df                	jne    801173 <ipc_recv+0x4c>
  801194:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80119b:	00 00 00 
  80119e:	eb d3                	jmp    801173 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  8011a0:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8011a7:	00 00 00 
  8011aa:	eb e4                	jmp    801190 <ipc_recv+0x69>

008011ac <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8011ac:	f3 0f 1e fb          	endbr32 
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
  8011b3:	57                   	push   %edi
  8011b4:	56                   	push   %esi
  8011b5:	53                   	push   %ebx
  8011b6:	83 ec 0c             	sub    $0xc,%esp
  8011b9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011bc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011bf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  8011c2:	85 db                	test   %ebx,%ebx
  8011c4:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8011c9:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  8011cc:	ff 75 14             	pushl  0x14(%ebp)
  8011cf:	53                   	push   %ebx
  8011d0:	56                   	push   %esi
  8011d1:	57                   	push   %edi
  8011d2:	e8 19 fc ff ff       	call   800df0 <sys_ipc_try_send>
  8011d7:	83 c4 10             	add    $0x10,%esp
  8011da:	85 c0                	test   %eax,%eax
  8011dc:	79 1e                	jns    8011fc <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  8011de:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8011e1:	75 07                	jne    8011ea <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  8011e3:	e8 86 fa ff ff       	call   800c6e <sys_yield>
  8011e8:	eb e2                	jmp    8011cc <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  8011ea:	50                   	push   %eax
  8011eb:	68 80 18 80 00       	push   $0x801880
  8011f0:	6a 59                	push   $0x59
  8011f2:	68 9b 18 80 00       	push   $0x80189b
  8011f7:	e8 62 ef ff ff       	call   80015e <_panic>
	}


}
  8011fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011ff:	5b                   	pop    %ebx
  801200:	5e                   	pop    %esi
  801201:	5f                   	pop    %edi
  801202:	5d                   	pop    %ebp
  801203:	c3                   	ret    

00801204 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801204:	f3 0f 1e fb          	endbr32 
  801208:	55                   	push   %ebp
  801209:	89 e5                	mov    %esp,%ebp
  80120b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80120e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801213:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801216:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80121c:	8b 52 50             	mov    0x50(%edx),%edx
  80121f:	39 ca                	cmp    %ecx,%edx
  801221:	74 11                	je     801234 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801223:	83 c0 01             	add    $0x1,%eax
  801226:	3d 00 04 00 00       	cmp    $0x400,%eax
  80122b:	75 e6                	jne    801213 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  80122d:	b8 00 00 00 00       	mov    $0x0,%eax
  801232:	eb 0b                	jmp    80123f <ipc_find_env+0x3b>
			return envs[i].env_id;
  801234:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801237:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80123c:	8b 40 48             	mov    0x48(%eax),%eax
}
  80123f:	5d                   	pop    %ebp
  801240:	c3                   	ret    

00801241 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801241:	f3 0f 1e fb          	endbr32 
  801245:	55                   	push   %ebp
  801246:	89 e5                	mov    %esp,%ebp
  801248:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80124b:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  801252:	74 0a                	je     80125e <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801254:	8b 45 08             	mov    0x8(%ebp),%eax
  801257:	a3 08 20 80 00       	mov    %eax,0x802008
}
  80125c:	c9                   	leave  
  80125d:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  80125e:	83 ec 04             	sub    $0x4,%esp
  801261:	6a 07                	push   $0x7
  801263:	68 00 f0 bf ee       	push   $0xeebff000
  801268:	6a 00                	push   $0x0
  80126a:	e8 22 fa ff ff       	call   800c91 <sys_page_alloc>
  80126f:	83 c4 10             	add    $0x10,%esp
  801272:	85 c0                	test   %eax,%eax
  801274:	78 2a                	js     8012a0 <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  801276:	83 ec 08             	sub    $0x8,%esp
  801279:	68 b4 12 80 00       	push   $0x8012b4
  80127e:	6a 00                	push   $0x0
  801280:	e8 25 fb ff ff       	call   800daa <sys_env_set_pgfault_upcall>
  801285:	83 c4 10             	add    $0x10,%esp
  801288:	85 c0                	test   %eax,%eax
  80128a:	79 c8                	jns    801254 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  80128c:	83 ec 04             	sub    $0x4,%esp
  80128f:	68 d4 18 80 00       	push   $0x8018d4
  801294:	6a 25                	push   $0x25
  801296:	68 0c 19 80 00       	push   $0x80190c
  80129b:	e8 be ee ff ff       	call   80015e <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  8012a0:	83 ec 04             	sub    $0x4,%esp
  8012a3:	68 a8 18 80 00       	push   $0x8018a8
  8012a8:	6a 22                	push   $0x22
  8012aa:	68 0c 19 80 00       	push   $0x80190c
  8012af:	e8 aa ee ff ff       	call   80015e <_panic>

008012b4 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8012b4:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8012b5:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  8012ba:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8012bc:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  8012bf:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  8012c3:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  8012c7:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8012ca:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  8012cc:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  8012d0:	83 c4 08             	add    $0x8,%esp
	popal
  8012d3:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  8012d4:	83 c4 04             	add    $0x4,%esp
	popfl
  8012d7:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  8012d8:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  8012d9:	c3                   	ret    
  8012da:	66 90                	xchg   %ax,%ax
  8012dc:	66 90                	xchg   %ax,%ax
  8012de:	66 90                	xchg   %ax,%ax

008012e0 <__udivdi3>:
  8012e0:	f3 0f 1e fb          	endbr32 
  8012e4:	55                   	push   %ebp
  8012e5:	57                   	push   %edi
  8012e6:	56                   	push   %esi
  8012e7:	53                   	push   %ebx
  8012e8:	83 ec 1c             	sub    $0x1c,%esp
  8012eb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8012ef:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8012f3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8012f7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8012fb:	85 d2                	test   %edx,%edx
  8012fd:	75 19                	jne    801318 <__udivdi3+0x38>
  8012ff:	39 f3                	cmp    %esi,%ebx
  801301:	76 4d                	jbe    801350 <__udivdi3+0x70>
  801303:	31 ff                	xor    %edi,%edi
  801305:	89 e8                	mov    %ebp,%eax
  801307:	89 f2                	mov    %esi,%edx
  801309:	f7 f3                	div    %ebx
  80130b:	89 fa                	mov    %edi,%edx
  80130d:	83 c4 1c             	add    $0x1c,%esp
  801310:	5b                   	pop    %ebx
  801311:	5e                   	pop    %esi
  801312:	5f                   	pop    %edi
  801313:	5d                   	pop    %ebp
  801314:	c3                   	ret    
  801315:	8d 76 00             	lea    0x0(%esi),%esi
  801318:	39 f2                	cmp    %esi,%edx
  80131a:	76 14                	jbe    801330 <__udivdi3+0x50>
  80131c:	31 ff                	xor    %edi,%edi
  80131e:	31 c0                	xor    %eax,%eax
  801320:	89 fa                	mov    %edi,%edx
  801322:	83 c4 1c             	add    $0x1c,%esp
  801325:	5b                   	pop    %ebx
  801326:	5e                   	pop    %esi
  801327:	5f                   	pop    %edi
  801328:	5d                   	pop    %ebp
  801329:	c3                   	ret    
  80132a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801330:	0f bd fa             	bsr    %edx,%edi
  801333:	83 f7 1f             	xor    $0x1f,%edi
  801336:	75 48                	jne    801380 <__udivdi3+0xa0>
  801338:	39 f2                	cmp    %esi,%edx
  80133a:	72 06                	jb     801342 <__udivdi3+0x62>
  80133c:	31 c0                	xor    %eax,%eax
  80133e:	39 eb                	cmp    %ebp,%ebx
  801340:	77 de                	ja     801320 <__udivdi3+0x40>
  801342:	b8 01 00 00 00       	mov    $0x1,%eax
  801347:	eb d7                	jmp    801320 <__udivdi3+0x40>
  801349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801350:	89 d9                	mov    %ebx,%ecx
  801352:	85 db                	test   %ebx,%ebx
  801354:	75 0b                	jne    801361 <__udivdi3+0x81>
  801356:	b8 01 00 00 00       	mov    $0x1,%eax
  80135b:	31 d2                	xor    %edx,%edx
  80135d:	f7 f3                	div    %ebx
  80135f:	89 c1                	mov    %eax,%ecx
  801361:	31 d2                	xor    %edx,%edx
  801363:	89 f0                	mov    %esi,%eax
  801365:	f7 f1                	div    %ecx
  801367:	89 c6                	mov    %eax,%esi
  801369:	89 e8                	mov    %ebp,%eax
  80136b:	89 f7                	mov    %esi,%edi
  80136d:	f7 f1                	div    %ecx
  80136f:	89 fa                	mov    %edi,%edx
  801371:	83 c4 1c             	add    $0x1c,%esp
  801374:	5b                   	pop    %ebx
  801375:	5e                   	pop    %esi
  801376:	5f                   	pop    %edi
  801377:	5d                   	pop    %ebp
  801378:	c3                   	ret    
  801379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801380:	89 f9                	mov    %edi,%ecx
  801382:	b8 20 00 00 00       	mov    $0x20,%eax
  801387:	29 f8                	sub    %edi,%eax
  801389:	d3 e2                	shl    %cl,%edx
  80138b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80138f:	89 c1                	mov    %eax,%ecx
  801391:	89 da                	mov    %ebx,%edx
  801393:	d3 ea                	shr    %cl,%edx
  801395:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801399:	09 d1                	or     %edx,%ecx
  80139b:	89 f2                	mov    %esi,%edx
  80139d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013a1:	89 f9                	mov    %edi,%ecx
  8013a3:	d3 e3                	shl    %cl,%ebx
  8013a5:	89 c1                	mov    %eax,%ecx
  8013a7:	d3 ea                	shr    %cl,%edx
  8013a9:	89 f9                	mov    %edi,%ecx
  8013ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8013af:	89 eb                	mov    %ebp,%ebx
  8013b1:	d3 e6                	shl    %cl,%esi
  8013b3:	89 c1                	mov    %eax,%ecx
  8013b5:	d3 eb                	shr    %cl,%ebx
  8013b7:	09 de                	or     %ebx,%esi
  8013b9:	89 f0                	mov    %esi,%eax
  8013bb:	f7 74 24 08          	divl   0x8(%esp)
  8013bf:	89 d6                	mov    %edx,%esi
  8013c1:	89 c3                	mov    %eax,%ebx
  8013c3:	f7 64 24 0c          	mull   0xc(%esp)
  8013c7:	39 d6                	cmp    %edx,%esi
  8013c9:	72 15                	jb     8013e0 <__udivdi3+0x100>
  8013cb:	89 f9                	mov    %edi,%ecx
  8013cd:	d3 e5                	shl    %cl,%ebp
  8013cf:	39 c5                	cmp    %eax,%ebp
  8013d1:	73 04                	jae    8013d7 <__udivdi3+0xf7>
  8013d3:	39 d6                	cmp    %edx,%esi
  8013d5:	74 09                	je     8013e0 <__udivdi3+0x100>
  8013d7:	89 d8                	mov    %ebx,%eax
  8013d9:	31 ff                	xor    %edi,%edi
  8013db:	e9 40 ff ff ff       	jmp    801320 <__udivdi3+0x40>
  8013e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8013e3:	31 ff                	xor    %edi,%edi
  8013e5:	e9 36 ff ff ff       	jmp    801320 <__udivdi3+0x40>
  8013ea:	66 90                	xchg   %ax,%ax
  8013ec:	66 90                	xchg   %ax,%ax
  8013ee:	66 90                	xchg   %ax,%ax

008013f0 <__umoddi3>:
  8013f0:	f3 0f 1e fb          	endbr32 
  8013f4:	55                   	push   %ebp
  8013f5:	57                   	push   %edi
  8013f6:	56                   	push   %esi
  8013f7:	53                   	push   %ebx
  8013f8:	83 ec 1c             	sub    $0x1c,%esp
  8013fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8013ff:	8b 74 24 30          	mov    0x30(%esp),%esi
  801403:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801407:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80140b:	85 c0                	test   %eax,%eax
  80140d:	75 19                	jne    801428 <__umoddi3+0x38>
  80140f:	39 df                	cmp    %ebx,%edi
  801411:	76 5d                	jbe    801470 <__umoddi3+0x80>
  801413:	89 f0                	mov    %esi,%eax
  801415:	89 da                	mov    %ebx,%edx
  801417:	f7 f7                	div    %edi
  801419:	89 d0                	mov    %edx,%eax
  80141b:	31 d2                	xor    %edx,%edx
  80141d:	83 c4 1c             	add    $0x1c,%esp
  801420:	5b                   	pop    %ebx
  801421:	5e                   	pop    %esi
  801422:	5f                   	pop    %edi
  801423:	5d                   	pop    %ebp
  801424:	c3                   	ret    
  801425:	8d 76 00             	lea    0x0(%esi),%esi
  801428:	89 f2                	mov    %esi,%edx
  80142a:	39 d8                	cmp    %ebx,%eax
  80142c:	76 12                	jbe    801440 <__umoddi3+0x50>
  80142e:	89 f0                	mov    %esi,%eax
  801430:	89 da                	mov    %ebx,%edx
  801432:	83 c4 1c             	add    $0x1c,%esp
  801435:	5b                   	pop    %ebx
  801436:	5e                   	pop    %esi
  801437:	5f                   	pop    %edi
  801438:	5d                   	pop    %ebp
  801439:	c3                   	ret    
  80143a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801440:	0f bd e8             	bsr    %eax,%ebp
  801443:	83 f5 1f             	xor    $0x1f,%ebp
  801446:	75 50                	jne    801498 <__umoddi3+0xa8>
  801448:	39 d8                	cmp    %ebx,%eax
  80144a:	0f 82 e0 00 00 00    	jb     801530 <__umoddi3+0x140>
  801450:	89 d9                	mov    %ebx,%ecx
  801452:	39 f7                	cmp    %esi,%edi
  801454:	0f 86 d6 00 00 00    	jbe    801530 <__umoddi3+0x140>
  80145a:	89 d0                	mov    %edx,%eax
  80145c:	89 ca                	mov    %ecx,%edx
  80145e:	83 c4 1c             	add    $0x1c,%esp
  801461:	5b                   	pop    %ebx
  801462:	5e                   	pop    %esi
  801463:	5f                   	pop    %edi
  801464:	5d                   	pop    %ebp
  801465:	c3                   	ret    
  801466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80146d:	8d 76 00             	lea    0x0(%esi),%esi
  801470:	89 fd                	mov    %edi,%ebp
  801472:	85 ff                	test   %edi,%edi
  801474:	75 0b                	jne    801481 <__umoddi3+0x91>
  801476:	b8 01 00 00 00       	mov    $0x1,%eax
  80147b:	31 d2                	xor    %edx,%edx
  80147d:	f7 f7                	div    %edi
  80147f:	89 c5                	mov    %eax,%ebp
  801481:	89 d8                	mov    %ebx,%eax
  801483:	31 d2                	xor    %edx,%edx
  801485:	f7 f5                	div    %ebp
  801487:	89 f0                	mov    %esi,%eax
  801489:	f7 f5                	div    %ebp
  80148b:	89 d0                	mov    %edx,%eax
  80148d:	31 d2                	xor    %edx,%edx
  80148f:	eb 8c                	jmp    80141d <__umoddi3+0x2d>
  801491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801498:	89 e9                	mov    %ebp,%ecx
  80149a:	ba 20 00 00 00       	mov    $0x20,%edx
  80149f:	29 ea                	sub    %ebp,%edx
  8014a1:	d3 e0                	shl    %cl,%eax
  8014a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014a7:	89 d1                	mov    %edx,%ecx
  8014a9:	89 f8                	mov    %edi,%eax
  8014ab:	d3 e8                	shr    %cl,%eax
  8014ad:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8014b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8014b5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8014b9:	09 c1                	or     %eax,%ecx
  8014bb:	89 d8                	mov    %ebx,%eax
  8014bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014c1:	89 e9                	mov    %ebp,%ecx
  8014c3:	d3 e7                	shl    %cl,%edi
  8014c5:	89 d1                	mov    %edx,%ecx
  8014c7:	d3 e8                	shr    %cl,%eax
  8014c9:	89 e9                	mov    %ebp,%ecx
  8014cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8014cf:	d3 e3                	shl    %cl,%ebx
  8014d1:	89 c7                	mov    %eax,%edi
  8014d3:	89 d1                	mov    %edx,%ecx
  8014d5:	89 f0                	mov    %esi,%eax
  8014d7:	d3 e8                	shr    %cl,%eax
  8014d9:	89 e9                	mov    %ebp,%ecx
  8014db:	89 fa                	mov    %edi,%edx
  8014dd:	d3 e6                	shl    %cl,%esi
  8014df:	09 d8                	or     %ebx,%eax
  8014e1:	f7 74 24 08          	divl   0x8(%esp)
  8014e5:	89 d1                	mov    %edx,%ecx
  8014e7:	89 f3                	mov    %esi,%ebx
  8014e9:	f7 64 24 0c          	mull   0xc(%esp)
  8014ed:	89 c6                	mov    %eax,%esi
  8014ef:	89 d7                	mov    %edx,%edi
  8014f1:	39 d1                	cmp    %edx,%ecx
  8014f3:	72 06                	jb     8014fb <__umoddi3+0x10b>
  8014f5:	75 10                	jne    801507 <__umoddi3+0x117>
  8014f7:	39 c3                	cmp    %eax,%ebx
  8014f9:	73 0c                	jae    801507 <__umoddi3+0x117>
  8014fb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8014ff:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801503:	89 d7                	mov    %edx,%edi
  801505:	89 c6                	mov    %eax,%esi
  801507:	89 ca                	mov    %ecx,%edx
  801509:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80150e:	29 f3                	sub    %esi,%ebx
  801510:	19 fa                	sbb    %edi,%edx
  801512:	89 d0                	mov    %edx,%eax
  801514:	d3 e0                	shl    %cl,%eax
  801516:	89 e9                	mov    %ebp,%ecx
  801518:	d3 eb                	shr    %cl,%ebx
  80151a:	d3 ea                	shr    %cl,%edx
  80151c:	09 d8                	or     %ebx,%eax
  80151e:	83 c4 1c             	add    $0x1c,%esp
  801521:	5b                   	pop    %ebx
  801522:	5e                   	pop    %esi
  801523:	5f                   	pop    %edi
  801524:	5d                   	pop    %ebp
  801525:	c3                   	ret    
  801526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80152d:	8d 76 00             	lea    0x0(%esi),%esi
  801530:	29 fe                	sub    %edi,%esi
  801532:	19 c3                	sbb    %eax,%ebx
  801534:	89 f2                	mov    %esi,%edx
  801536:	89 d9                	mov    %ebx,%ecx
  801538:	e9 1d ff ff ff       	jmp    80145a <__umoddi3+0x6a>
