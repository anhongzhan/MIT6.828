
obj/user/testpiperace2.debug:     file format elf32-i386


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
  80002c:	e8 a3 01 00 00       	call   8001d4 <libmain>
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
  80003a:	57                   	push   %edi
  80003b:	56                   	push   %esi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 28             	sub    $0x28,%esp
	int p[2], r, i;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for pipeisclosed race...\n");
  800040:	68 80 29 80 00       	push   $0x802980
  800045:	e8 d9 02 00 00       	call   800323 <cprintf>
	if ((r = pipe(p)) < 0)
  80004a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80004d:	89 04 24             	mov    %eax,(%esp)
  800050:	e8 bb 21 00 00       	call   802210 <pipe>
  800055:	83 c4 10             	add    $0x10,%esp
  800058:	85 c0                	test   %eax,%eax
  80005a:	78 5b                	js     8000b7 <umain+0x84>
		panic("pipe: %e", r);
	if ((r = fork()) < 0)
  80005c:	e8 ae 10 00 00       	call   80110f <fork>
  800061:	89 c7                	mov    %eax,%edi
  800063:	85 c0                	test   %eax,%eax
  800065:	78 62                	js     8000c9 <umain+0x96>
		panic("fork: %e", r);
	if (r == 0) {
  800067:	74 72                	je     8000db <umain+0xa8>
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  800069:	89 fb                	mov    %edi,%ebx
  80006b:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (kid->env_status == ENV_RUNNABLE)
  800071:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  800074:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80007a:	8b 43 54             	mov    0x54(%ebx),%eax
  80007d:	83 f8 02             	cmp    $0x2,%eax
  800080:	0f 85 d1 00 00 00    	jne    800157 <umain+0x124>
		if (pipeisclosed(p[0]) != 0) {
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	ff 75 e0             	pushl  -0x20(%ebp)
  80008c:	e8 cd 22 00 00       	call   80235e <pipeisclosed>
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	85 c0                	test   %eax,%eax
  800096:	74 e2                	je     80007a <umain+0x47>
			cprintf("\nRACE: pipe appears closed\n");
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	68 f0 29 80 00       	push   $0x8029f0
  8000a0:	e8 7e 02 00 00       	call   800323 <cprintf>
			sys_env_destroy(r);
  8000a5:	89 3c 24             	mov    %edi,(%esp)
  8000a8:	e8 37 0c 00 00       	call   800ce4 <sys_env_destroy>
			exit();
  8000ad:	e8 6c 01 00 00       	call   80021e <exit>
  8000b2:	83 c4 10             	add    $0x10,%esp
  8000b5:	eb c3                	jmp    80007a <umain+0x47>
		panic("pipe: %e", r);
  8000b7:	50                   	push   %eax
  8000b8:	68 ce 29 80 00       	push   $0x8029ce
  8000bd:	6a 0d                	push   $0xd
  8000bf:	68 d7 29 80 00       	push   $0x8029d7
  8000c4:	e8 73 01 00 00       	call   80023c <_panic>
		panic("fork: %e", r);
  8000c9:	50                   	push   %eax
  8000ca:	68 e5 2d 80 00       	push   $0x802de5
  8000cf:	6a 0f                	push   $0xf
  8000d1:	68 d7 29 80 00       	push   $0x8029d7
  8000d6:	e8 61 01 00 00       	call   80023c <_panic>
		close(p[1]);
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000e1:	e8 05 14 00 00       	call   8014eb <close>
  8000e6:	83 c4 10             	add    $0x10,%esp
		for (i = 0; i < 200; i++) {
  8000e9:	89 fb                	mov    %edi,%ebx
			if (i % 10 == 0)
  8000eb:	be 67 66 66 66       	mov    $0x66666667,%esi
  8000f0:	eb 42                	jmp    800134 <umain+0x101>
				cprintf("%d.", i);
  8000f2:	83 ec 08             	sub    $0x8,%esp
  8000f5:	53                   	push   %ebx
  8000f6:	68 ec 29 80 00       	push   $0x8029ec
  8000fb:	e8 23 02 00 00       	call   800323 <cprintf>
  800100:	83 c4 10             	add    $0x10,%esp
			dup(p[0], 10);
  800103:	83 ec 08             	sub    $0x8,%esp
  800106:	6a 0a                	push   $0xa
  800108:	ff 75 e0             	pushl  -0x20(%ebp)
  80010b:	e8 35 14 00 00       	call   801545 <dup>
			sys_yield();
  800110:	e8 37 0c 00 00       	call   800d4c <sys_yield>
			close(10);
  800115:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  80011c:	e8 ca 13 00 00       	call   8014eb <close>
			sys_yield();
  800121:	e8 26 0c 00 00       	call   800d4c <sys_yield>
		for (i = 0; i < 200; i++) {
  800126:	83 c3 01             	add    $0x1,%ebx
  800129:	83 c4 10             	add    $0x10,%esp
  80012c:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
  800132:	74 19                	je     80014d <umain+0x11a>
			if (i % 10 == 0)
  800134:	89 d8                	mov    %ebx,%eax
  800136:	f7 ee                	imul   %esi
  800138:	c1 fa 02             	sar    $0x2,%edx
  80013b:	89 d8                	mov    %ebx,%eax
  80013d:	c1 f8 1f             	sar    $0x1f,%eax
  800140:	29 c2                	sub    %eax,%edx
  800142:	8d 04 92             	lea    (%edx,%edx,4),%eax
  800145:	01 c0                	add    %eax,%eax
  800147:	39 c3                	cmp    %eax,%ebx
  800149:	75 b8                	jne    800103 <umain+0xd0>
  80014b:	eb a5                	jmp    8000f2 <umain+0xbf>
		exit();
  80014d:	e8 cc 00 00 00       	call   80021e <exit>
  800152:	e9 12 ff ff ff       	jmp    800069 <umain+0x36>
		}
	cprintf("child done with loop\n");
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 0c 2a 80 00       	push   $0x802a0c
  80015f:	e8 bf 01 00 00       	call   800323 <cprintf>
	if (pipeisclosed(p[0]))
  800164:	83 c4 04             	add    $0x4,%esp
  800167:	ff 75 e0             	pushl  -0x20(%ebp)
  80016a:	e8 ef 21 00 00       	call   80235e <pipeisclosed>
  80016f:	83 c4 10             	add    $0x10,%esp
  800172:	85 c0                	test   %eax,%eax
  800174:	75 38                	jne    8001ae <umain+0x17b>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  800176:	83 ec 08             	sub    $0x8,%esp
  800179:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80017c:	50                   	push   %eax
  80017d:	ff 75 e0             	pushl  -0x20(%ebp)
  800180:	e8 28 12 00 00       	call   8013ad <fd_lookup>
  800185:	83 c4 10             	add    $0x10,%esp
  800188:	85 c0                	test   %eax,%eax
  80018a:	78 36                	js     8001c2 <umain+0x18f>
		panic("cannot look up p[0]: %e", r);
	(void) fd2data(fd);
  80018c:	83 ec 0c             	sub    $0xc,%esp
  80018f:	ff 75 dc             	pushl  -0x24(%ebp)
  800192:	e8 a5 11 00 00       	call   80133c <fd2data>
	cprintf("race didn't happen\n");
  800197:	c7 04 24 3a 2a 80 00 	movl   $0x802a3a,(%esp)
  80019e:	e8 80 01 00 00       	call   800323 <cprintf>
}
  8001a3:	83 c4 10             	add    $0x10,%esp
  8001a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001a9:	5b                   	pop    %ebx
  8001aa:	5e                   	pop    %esi
  8001ab:	5f                   	pop    %edi
  8001ac:	5d                   	pop    %ebp
  8001ad:	c3                   	ret    
		panic("somehow the other end of p[0] got closed!");
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	68 a4 29 80 00       	push   $0x8029a4
  8001b6:	6a 40                	push   $0x40
  8001b8:	68 d7 29 80 00       	push   $0x8029d7
  8001bd:	e8 7a 00 00 00       	call   80023c <_panic>
		panic("cannot look up p[0]: %e", r);
  8001c2:	50                   	push   %eax
  8001c3:	68 22 2a 80 00       	push   $0x802a22
  8001c8:	6a 42                	push   $0x42
  8001ca:	68 d7 29 80 00       	push   $0x8029d7
  8001cf:	e8 68 00 00 00       	call   80023c <_panic>

008001d4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001d4:	f3 0f 1e fb          	endbr32 
  8001d8:	55                   	push   %ebp
  8001d9:	89 e5                	mov    %esp,%ebp
  8001db:	56                   	push   %esi
  8001dc:	53                   	push   %ebx
  8001dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001e0:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001e3:	e8 41 0b 00 00       	call   800d29 <sys_getenvid>
  8001e8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001ed:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001f0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001f5:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001fa:	85 db                	test   %ebx,%ebx
  8001fc:	7e 07                	jle    800205 <libmain+0x31>
		binaryname = argv[0];
  8001fe:	8b 06                	mov    (%esi),%eax
  800200:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800205:	83 ec 08             	sub    $0x8,%esp
  800208:	56                   	push   %esi
  800209:	53                   	push   %ebx
  80020a:	e8 24 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80020f:	e8 0a 00 00 00       	call   80021e <exit>
}
  800214:	83 c4 10             	add    $0x10,%esp
  800217:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80021a:	5b                   	pop    %ebx
  80021b:	5e                   	pop    %esi
  80021c:	5d                   	pop    %ebp
  80021d:	c3                   	ret    

0080021e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80021e:	f3 0f 1e fb          	endbr32 
  800222:	55                   	push   %ebp
  800223:	89 e5                	mov    %esp,%ebp
  800225:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800228:	e8 ef 12 00 00       	call   80151c <close_all>
	sys_env_destroy(0);
  80022d:	83 ec 0c             	sub    $0xc,%esp
  800230:	6a 00                	push   $0x0
  800232:	e8 ad 0a 00 00       	call   800ce4 <sys_env_destroy>
}
  800237:	83 c4 10             	add    $0x10,%esp
  80023a:	c9                   	leave  
  80023b:	c3                   	ret    

0080023c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80023c:	f3 0f 1e fb          	endbr32 
  800240:	55                   	push   %ebp
  800241:	89 e5                	mov    %esp,%ebp
  800243:	56                   	push   %esi
  800244:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800245:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800248:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80024e:	e8 d6 0a 00 00       	call   800d29 <sys_getenvid>
  800253:	83 ec 0c             	sub    $0xc,%esp
  800256:	ff 75 0c             	pushl  0xc(%ebp)
  800259:	ff 75 08             	pushl  0x8(%ebp)
  80025c:	56                   	push   %esi
  80025d:	50                   	push   %eax
  80025e:	68 58 2a 80 00       	push   $0x802a58
  800263:	e8 bb 00 00 00       	call   800323 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800268:	83 c4 18             	add    $0x18,%esp
  80026b:	53                   	push   %ebx
  80026c:	ff 75 10             	pushl  0x10(%ebp)
  80026f:	e8 5a 00 00 00       	call   8002ce <vcprintf>
	cprintf("\n");
  800274:	c7 04 24 ef 2f 80 00 	movl   $0x802fef,(%esp)
  80027b:	e8 a3 00 00 00       	call   800323 <cprintf>
  800280:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800283:	cc                   	int3   
  800284:	eb fd                	jmp    800283 <_panic+0x47>

00800286 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800286:	f3 0f 1e fb          	endbr32 
  80028a:	55                   	push   %ebp
  80028b:	89 e5                	mov    %esp,%ebp
  80028d:	53                   	push   %ebx
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800294:	8b 13                	mov    (%ebx),%edx
  800296:	8d 42 01             	lea    0x1(%edx),%eax
  800299:	89 03                	mov    %eax,(%ebx)
  80029b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80029e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002a2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002a7:	74 09                	je     8002b2 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002a9:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002b0:	c9                   	leave  
  8002b1:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002b2:	83 ec 08             	sub    $0x8,%esp
  8002b5:	68 ff 00 00 00       	push   $0xff
  8002ba:	8d 43 08             	lea    0x8(%ebx),%eax
  8002bd:	50                   	push   %eax
  8002be:	e8 dc 09 00 00       	call   800c9f <sys_cputs>
		b->idx = 0;
  8002c3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002c9:	83 c4 10             	add    $0x10,%esp
  8002cc:	eb db                	jmp    8002a9 <putch+0x23>

008002ce <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002ce:	f3 0f 1e fb          	endbr32 
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002db:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002e2:	00 00 00 
	b.cnt = 0;
  8002e5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002ec:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002ef:	ff 75 0c             	pushl  0xc(%ebp)
  8002f2:	ff 75 08             	pushl  0x8(%ebp)
  8002f5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002fb:	50                   	push   %eax
  8002fc:	68 86 02 80 00       	push   $0x800286
  800301:	e8 20 01 00 00       	call   800426 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800306:	83 c4 08             	add    $0x8,%esp
  800309:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80030f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800315:	50                   	push   %eax
  800316:	e8 84 09 00 00       	call   800c9f <sys_cputs>

	return b.cnt;
}
  80031b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800321:	c9                   	leave  
  800322:	c3                   	ret    

00800323 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800323:	f3 0f 1e fb          	endbr32 
  800327:	55                   	push   %ebp
  800328:	89 e5                	mov    %esp,%ebp
  80032a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80032d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800330:	50                   	push   %eax
  800331:	ff 75 08             	pushl  0x8(%ebp)
  800334:	e8 95 ff ff ff       	call   8002ce <vcprintf>
	va_end(ap);

	return cnt;
}
  800339:	c9                   	leave  
  80033a:	c3                   	ret    

0080033b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80033b:	55                   	push   %ebp
  80033c:	89 e5                	mov    %esp,%ebp
  80033e:	57                   	push   %edi
  80033f:	56                   	push   %esi
  800340:	53                   	push   %ebx
  800341:	83 ec 1c             	sub    $0x1c,%esp
  800344:	89 c7                	mov    %eax,%edi
  800346:	89 d6                	mov    %edx,%esi
  800348:	8b 45 08             	mov    0x8(%ebp),%eax
  80034b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80034e:	89 d1                	mov    %edx,%ecx
  800350:	89 c2                	mov    %eax,%edx
  800352:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800355:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800358:	8b 45 10             	mov    0x10(%ebp),%eax
  80035b:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80035e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800361:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800368:	39 c2                	cmp    %eax,%edx
  80036a:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80036d:	72 3e                	jb     8003ad <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80036f:	83 ec 0c             	sub    $0xc,%esp
  800372:	ff 75 18             	pushl  0x18(%ebp)
  800375:	83 eb 01             	sub    $0x1,%ebx
  800378:	53                   	push   %ebx
  800379:	50                   	push   %eax
  80037a:	83 ec 08             	sub    $0x8,%esp
  80037d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800380:	ff 75 e0             	pushl  -0x20(%ebp)
  800383:	ff 75 dc             	pushl  -0x24(%ebp)
  800386:	ff 75 d8             	pushl  -0x28(%ebp)
  800389:	e8 92 23 00 00       	call   802720 <__udivdi3>
  80038e:	83 c4 18             	add    $0x18,%esp
  800391:	52                   	push   %edx
  800392:	50                   	push   %eax
  800393:	89 f2                	mov    %esi,%edx
  800395:	89 f8                	mov    %edi,%eax
  800397:	e8 9f ff ff ff       	call   80033b <printnum>
  80039c:	83 c4 20             	add    $0x20,%esp
  80039f:	eb 13                	jmp    8003b4 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003a1:	83 ec 08             	sub    $0x8,%esp
  8003a4:	56                   	push   %esi
  8003a5:	ff 75 18             	pushl  0x18(%ebp)
  8003a8:	ff d7                	call   *%edi
  8003aa:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8003ad:	83 eb 01             	sub    $0x1,%ebx
  8003b0:	85 db                	test   %ebx,%ebx
  8003b2:	7f ed                	jg     8003a1 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003b4:	83 ec 08             	sub    $0x8,%esp
  8003b7:	56                   	push   %esi
  8003b8:	83 ec 04             	sub    $0x4,%esp
  8003bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003be:	ff 75 e0             	pushl  -0x20(%ebp)
  8003c1:	ff 75 dc             	pushl  -0x24(%ebp)
  8003c4:	ff 75 d8             	pushl  -0x28(%ebp)
  8003c7:	e8 64 24 00 00       	call   802830 <__umoddi3>
  8003cc:	83 c4 14             	add    $0x14,%esp
  8003cf:	0f be 80 7b 2a 80 00 	movsbl 0x802a7b(%eax),%eax
  8003d6:	50                   	push   %eax
  8003d7:	ff d7                	call   *%edi
}
  8003d9:	83 c4 10             	add    $0x10,%esp
  8003dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003df:	5b                   	pop    %ebx
  8003e0:	5e                   	pop    %esi
  8003e1:	5f                   	pop    %edi
  8003e2:	5d                   	pop    %ebp
  8003e3:	c3                   	ret    

008003e4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003e4:	f3 0f 1e fb          	endbr32 
  8003e8:	55                   	push   %ebp
  8003e9:	89 e5                	mov    %esp,%ebp
  8003eb:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003ee:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003f2:	8b 10                	mov    (%eax),%edx
  8003f4:	3b 50 04             	cmp    0x4(%eax),%edx
  8003f7:	73 0a                	jae    800403 <sprintputch+0x1f>
		*b->buf++ = ch;
  8003f9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003fc:	89 08                	mov    %ecx,(%eax)
  8003fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800401:	88 02                	mov    %al,(%edx)
}
  800403:	5d                   	pop    %ebp
  800404:	c3                   	ret    

00800405 <printfmt>:
{
  800405:	f3 0f 1e fb          	endbr32 
  800409:	55                   	push   %ebp
  80040a:	89 e5                	mov    %esp,%ebp
  80040c:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80040f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800412:	50                   	push   %eax
  800413:	ff 75 10             	pushl  0x10(%ebp)
  800416:	ff 75 0c             	pushl  0xc(%ebp)
  800419:	ff 75 08             	pushl  0x8(%ebp)
  80041c:	e8 05 00 00 00       	call   800426 <vprintfmt>
}
  800421:	83 c4 10             	add    $0x10,%esp
  800424:	c9                   	leave  
  800425:	c3                   	ret    

00800426 <vprintfmt>:
{
  800426:	f3 0f 1e fb          	endbr32 
  80042a:	55                   	push   %ebp
  80042b:	89 e5                	mov    %esp,%ebp
  80042d:	57                   	push   %edi
  80042e:	56                   	push   %esi
  80042f:	53                   	push   %ebx
  800430:	83 ec 3c             	sub    $0x3c,%esp
  800433:	8b 75 08             	mov    0x8(%ebp),%esi
  800436:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800439:	8b 7d 10             	mov    0x10(%ebp),%edi
  80043c:	e9 8e 03 00 00       	jmp    8007cf <vprintfmt+0x3a9>
		padc = ' ';
  800441:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800445:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80044c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800453:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80045a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80045f:	8d 47 01             	lea    0x1(%edi),%eax
  800462:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800465:	0f b6 17             	movzbl (%edi),%edx
  800468:	8d 42 dd             	lea    -0x23(%edx),%eax
  80046b:	3c 55                	cmp    $0x55,%al
  80046d:	0f 87 df 03 00 00    	ja     800852 <vprintfmt+0x42c>
  800473:	0f b6 c0             	movzbl %al,%eax
  800476:	3e ff 24 85 c0 2b 80 	notrack jmp *0x802bc0(,%eax,4)
  80047d:	00 
  80047e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800481:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800485:	eb d8                	jmp    80045f <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800487:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80048a:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80048e:	eb cf                	jmp    80045f <vprintfmt+0x39>
  800490:	0f b6 d2             	movzbl %dl,%edx
  800493:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800496:	b8 00 00 00 00       	mov    $0x0,%eax
  80049b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80049e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004a1:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004a5:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004a8:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004ab:	83 f9 09             	cmp    $0x9,%ecx
  8004ae:	77 55                	ja     800505 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8004b0:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004b3:	eb e9                	jmp    80049e <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8004b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b8:	8b 00                	mov    (%eax),%eax
  8004ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c0:	8d 40 04             	lea    0x4(%eax),%eax
  8004c3:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004c9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004cd:	79 90                	jns    80045f <vprintfmt+0x39>
				width = precision, precision = -1;
  8004cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004d5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004dc:	eb 81                	jmp    80045f <vprintfmt+0x39>
  8004de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e1:	85 c0                	test   %eax,%eax
  8004e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e8:	0f 49 d0             	cmovns %eax,%edx
  8004eb:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004ee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004f1:	e9 69 ff ff ff       	jmp    80045f <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8004f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004f9:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800500:	e9 5a ff ff ff       	jmp    80045f <vprintfmt+0x39>
  800505:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800508:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80050b:	eb bc                	jmp    8004c9 <vprintfmt+0xa3>
			lflag++;
  80050d:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800510:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800513:	e9 47 ff ff ff       	jmp    80045f <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800518:	8b 45 14             	mov    0x14(%ebp),%eax
  80051b:	8d 78 04             	lea    0x4(%eax),%edi
  80051e:	83 ec 08             	sub    $0x8,%esp
  800521:	53                   	push   %ebx
  800522:	ff 30                	pushl  (%eax)
  800524:	ff d6                	call   *%esi
			break;
  800526:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800529:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80052c:	e9 9b 02 00 00       	jmp    8007cc <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800531:	8b 45 14             	mov    0x14(%ebp),%eax
  800534:	8d 78 04             	lea    0x4(%eax),%edi
  800537:	8b 00                	mov    (%eax),%eax
  800539:	99                   	cltd   
  80053a:	31 d0                	xor    %edx,%eax
  80053c:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80053e:	83 f8 0f             	cmp    $0xf,%eax
  800541:	7f 23                	jg     800566 <vprintfmt+0x140>
  800543:	8b 14 85 20 2d 80 00 	mov    0x802d20(,%eax,4),%edx
  80054a:	85 d2                	test   %edx,%edx
  80054c:	74 18                	je     800566 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80054e:	52                   	push   %edx
  80054f:	68 e5 2e 80 00       	push   $0x802ee5
  800554:	53                   	push   %ebx
  800555:	56                   	push   %esi
  800556:	e8 aa fe ff ff       	call   800405 <printfmt>
  80055b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80055e:	89 7d 14             	mov    %edi,0x14(%ebp)
  800561:	e9 66 02 00 00       	jmp    8007cc <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800566:	50                   	push   %eax
  800567:	68 93 2a 80 00       	push   $0x802a93
  80056c:	53                   	push   %ebx
  80056d:	56                   	push   %esi
  80056e:	e8 92 fe ff ff       	call   800405 <printfmt>
  800573:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800576:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800579:	e9 4e 02 00 00       	jmp    8007cc <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  80057e:	8b 45 14             	mov    0x14(%ebp),%eax
  800581:	83 c0 04             	add    $0x4,%eax
  800584:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800587:	8b 45 14             	mov    0x14(%ebp),%eax
  80058a:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80058c:	85 d2                	test   %edx,%edx
  80058e:	b8 8c 2a 80 00       	mov    $0x802a8c,%eax
  800593:	0f 45 c2             	cmovne %edx,%eax
  800596:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800599:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80059d:	7e 06                	jle    8005a5 <vprintfmt+0x17f>
  80059f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8005a3:	75 0d                	jne    8005b2 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005a8:	89 c7                	mov    %eax,%edi
  8005aa:	03 45 e0             	add    -0x20(%ebp),%eax
  8005ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005b0:	eb 55                	jmp    800607 <vprintfmt+0x1e1>
  8005b2:	83 ec 08             	sub    $0x8,%esp
  8005b5:	ff 75 d8             	pushl  -0x28(%ebp)
  8005b8:	ff 75 cc             	pushl  -0x34(%ebp)
  8005bb:	e8 46 03 00 00       	call   800906 <strnlen>
  8005c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005c3:	29 c2                	sub    %eax,%edx
  8005c5:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8005c8:	83 c4 10             	add    $0x10,%esp
  8005cb:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8005cd:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8005d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005d4:	85 ff                	test   %edi,%edi
  8005d6:	7e 11                	jle    8005e9 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8005d8:	83 ec 08             	sub    $0x8,%esp
  8005db:	53                   	push   %ebx
  8005dc:	ff 75 e0             	pushl  -0x20(%ebp)
  8005df:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005e1:	83 ef 01             	sub    $0x1,%edi
  8005e4:	83 c4 10             	add    $0x10,%esp
  8005e7:	eb eb                	jmp    8005d4 <vprintfmt+0x1ae>
  8005e9:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8005ec:	85 d2                	test   %edx,%edx
  8005ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8005f3:	0f 49 c2             	cmovns %edx,%eax
  8005f6:	29 c2                	sub    %eax,%edx
  8005f8:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8005fb:	eb a8                	jmp    8005a5 <vprintfmt+0x17f>
					putch(ch, putdat);
  8005fd:	83 ec 08             	sub    $0x8,%esp
  800600:	53                   	push   %ebx
  800601:	52                   	push   %edx
  800602:	ff d6                	call   *%esi
  800604:	83 c4 10             	add    $0x10,%esp
  800607:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80060a:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80060c:	83 c7 01             	add    $0x1,%edi
  80060f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800613:	0f be d0             	movsbl %al,%edx
  800616:	85 d2                	test   %edx,%edx
  800618:	74 4b                	je     800665 <vprintfmt+0x23f>
  80061a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80061e:	78 06                	js     800626 <vprintfmt+0x200>
  800620:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800624:	78 1e                	js     800644 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800626:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80062a:	74 d1                	je     8005fd <vprintfmt+0x1d7>
  80062c:	0f be c0             	movsbl %al,%eax
  80062f:	83 e8 20             	sub    $0x20,%eax
  800632:	83 f8 5e             	cmp    $0x5e,%eax
  800635:	76 c6                	jbe    8005fd <vprintfmt+0x1d7>
					putch('?', putdat);
  800637:	83 ec 08             	sub    $0x8,%esp
  80063a:	53                   	push   %ebx
  80063b:	6a 3f                	push   $0x3f
  80063d:	ff d6                	call   *%esi
  80063f:	83 c4 10             	add    $0x10,%esp
  800642:	eb c3                	jmp    800607 <vprintfmt+0x1e1>
  800644:	89 cf                	mov    %ecx,%edi
  800646:	eb 0e                	jmp    800656 <vprintfmt+0x230>
				putch(' ', putdat);
  800648:	83 ec 08             	sub    $0x8,%esp
  80064b:	53                   	push   %ebx
  80064c:	6a 20                	push   $0x20
  80064e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800650:	83 ef 01             	sub    $0x1,%edi
  800653:	83 c4 10             	add    $0x10,%esp
  800656:	85 ff                	test   %edi,%edi
  800658:	7f ee                	jg     800648 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  80065a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80065d:	89 45 14             	mov    %eax,0x14(%ebp)
  800660:	e9 67 01 00 00       	jmp    8007cc <vprintfmt+0x3a6>
  800665:	89 cf                	mov    %ecx,%edi
  800667:	eb ed                	jmp    800656 <vprintfmt+0x230>
	if (lflag >= 2)
  800669:	83 f9 01             	cmp    $0x1,%ecx
  80066c:	7f 1b                	jg     800689 <vprintfmt+0x263>
	else if (lflag)
  80066e:	85 c9                	test   %ecx,%ecx
  800670:	74 63                	je     8006d5 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800672:	8b 45 14             	mov    0x14(%ebp),%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067a:	99                   	cltd   
  80067b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067e:	8b 45 14             	mov    0x14(%ebp),%eax
  800681:	8d 40 04             	lea    0x4(%eax),%eax
  800684:	89 45 14             	mov    %eax,0x14(%ebp)
  800687:	eb 17                	jmp    8006a0 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800689:	8b 45 14             	mov    0x14(%ebp),%eax
  80068c:	8b 50 04             	mov    0x4(%eax),%edx
  80068f:	8b 00                	mov    (%eax),%eax
  800691:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800694:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800697:	8b 45 14             	mov    0x14(%ebp),%eax
  80069a:	8d 40 08             	lea    0x8(%eax),%eax
  80069d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8006a0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006a3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8006a6:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8006ab:	85 c9                	test   %ecx,%ecx
  8006ad:	0f 89 ff 00 00 00    	jns    8007b2 <vprintfmt+0x38c>
				putch('-', putdat);
  8006b3:	83 ec 08             	sub    $0x8,%esp
  8006b6:	53                   	push   %ebx
  8006b7:	6a 2d                	push   $0x2d
  8006b9:	ff d6                	call   *%esi
				num = -(long long) num;
  8006bb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006be:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006c1:	f7 da                	neg    %edx
  8006c3:	83 d1 00             	adc    $0x0,%ecx
  8006c6:	f7 d9                	neg    %ecx
  8006c8:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006cb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006d0:	e9 dd 00 00 00       	jmp    8007b2 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8006d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006dd:	99                   	cltd   
  8006de:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e4:	8d 40 04             	lea    0x4(%eax),%eax
  8006e7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ea:	eb b4                	jmp    8006a0 <vprintfmt+0x27a>
	if (lflag >= 2)
  8006ec:	83 f9 01             	cmp    $0x1,%ecx
  8006ef:	7f 1e                	jg     80070f <vprintfmt+0x2e9>
	else if (lflag)
  8006f1:	85 c9                	test   %ecx,%ecx
  8006f3:	74 32                	je     800727 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8006f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f8:	8b 10                	mov    (%eax),%edx
  8006fa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ff:	8d 40 04             	lea    0x4(%eax),%eax
  800702:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800705:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  80070a:	e9 a3 00 00 00       	jmp    8007b2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80070f:	8b 45 14             	mov    0x14(%ebp),%eax
  800712:	8b 10                	mov    (%eax),%edx
  800714:	8b 48 04             	mov    0x4(%eax),%ecx
  800717:	8d 40 08             	lea    0x8(%eax),%eax
  80071a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80071d:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800722:	e9 8b 00 00 00       	jmp    8007b2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800727:	8b 45 14             	mov    0x14(%ebp),%eax
  80072a:	8b 10                	mov    (%eax),%edx
  80072c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800731:	8d 40 04             	lea    0x4(%eax),%eax
  800734:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800737:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  80073c:	eb 74                	jmp    8007b2 <vprintfmt+0x38c>
	if (lflag >= 2)
  80073e:	83 f9 01             	cmp    $0x1,%ecx
  800741:	7f 1b                	jg     80075e <vprintfmt+0x338>
	else if (lflag)
  800743:	85 c9                	test   %ecx,%ecx
  800745:	74 2c                	je     800773 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800747:	8b 45 14             	mov    0x14(%ebp),%eax
  80074a:	8b 10                	mov    (%eax),%edx
  80074c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800751:	8d 40 04             	lea    0x4(%eax),%eax
  800754:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800757:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  80075c:	eb 54                	jmp    8007b2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80075e:	8b 45 14             	mov    0x14(%ebp),%eax
  800761:	8b 10                	mov    (%eax),%edx
  800763:	8b 48 04             	mov    0x4(%eax),%ecx
  800766:	8d 40 08             	lea    0x8(%eax),%eax
  800769:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80076c:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800771:	eb 3f                	jmp    8007b2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800773:	8b 45 14             	mov    0x14(%ebp),%eax
  800776:	8b 10                	mov    (%eax),%edx
  800778:	b9 00 00 00 00       	mov    $0x0,%ecx
  80077d:	8d 40 04             	lea    0x4(%eax),%eax
  800780:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800783:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800788:	eb 28                	jmp    8007b2 <vprintfmt+0x38c>
			putch('0', putdat);
  80078a:	83 ec 08             	sub    $0x8,%esp
  80078d:	53                   	push   %ebx
  80078e:	6a 30                	push   $0x30
  800790:	ff d6                	call   *%esi
			putch('x', putdat);
  800792:	83 c4 08             	add    $0x8,%esp
  800795:	53                   	push   %ebx
  800796:	6a 78                	push   $0x78
  800798:	ff d6                	call   *%esi
			num = (unsigned long long)
  80079a:	8b 45 14             	mov    0x14(%ebp),%eax
  80079d:	8b 10                	mov    (%eax),%edx
  80079f:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8007a4:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007a7:	8d 40 04             	lea    0x4(%eax),%eax
  8007aa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ad:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007b2:	83 ec 0c             	sub    $0xc,%esp
  8007b5:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8007b9:	57                   	push   %edi
  8007ba:	ff 75 e0             	pushl  -0x20(%ebp)
  8007bd:	50                   	push   %eax
  8007be:	51                   	push   %ecx
  8007bf:	52                   	push   %edx
  8007c0:	89 da                	mov    %ebx,%edx
  8007c2:	89 f0                	mov    %esi,%eax
  8007c4:	e8 72 fb ff ff       	call   80033b <printnum>
			break;
  8007c9:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007cc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007cf:	83 c7 01             	add    $0x1,%edi
  8007d2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007d6:	83 f8 25             	cmp    $0x25,%eax
  8007d9:	0f 84 62 fc ff ff    	je     800441 <vprintfmt+0x1b>
			if (ch == '\0')
  8007df:	85 c0                	test   %eax,%eax
  8007e1:	0f 84 8b 00 00 00    	je     800872 <vprintfmt+0x44c>
			putch(ch, putdat);
  8007e7:	83 ec 08             	sub    $0x8,%esp
  8007ea:	53                   	push   %ebx
  8007eb:	50                   	push   %eax
  8007ec:	ff d6                	call   *%esi
  8007ee:	83 c4 10             	add    $0x10,%esp
  8007f1:	eb dc                	jmp    8007cf <vprintfmt+0x3a9>
	if (lflag >= 2)
  8007f3:	83 f9 01             	cmp    $0x1,%ecx
  8007f6:	7f 1b                	jg     800813 <vprintfmt+0x3ed>
	else if (lflag)
  8007f8:	85 c9                	test   %ecx,%ecx
  8007fa:	74 2c                	je     800828 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8007fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ff:	8b 10                	mov    (%eax),%edx
  800801:	b9 00 00 00 00       	mov    $0x0,%ecx
  800806:	8d 40 04             	lea    0x4(%eax),%eax
  800809:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80080c:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800811:	eb 9f                	jmp    8007b2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800813:	8b 45 14             	mov    0x14(%ebp),%eax
  800816:	8b 10                	mov    (%eax),%edx
  800818:	8b 48 04             	mov    0x4(%eax),%ecx
  80081b:	8d 40 08             	lea    0x8(%eax),%eax
  80081e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800821:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800826:	eb 8a                	jmp    8007b2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800828:	8b 45 14             	mov    0x14(%ebp),%eax
  80082b:	8b 10                	mov    (%eax),%edx
  80082d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800832:	8d 40 04             	lea    0x4(%eax),%eax
  800835:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800838:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  80083d:	e9 70 ff ff ff       	jmp    8007b2 <vprintfmt+0x38c>
			putch(ch, putdat);
  800842:	83 ec 08             	sub    $0x8,%esp
  800845:	53                   	push   %ebx
  800846:	6a 25                	push   $0x25
  800848:	ff d6                	call   *%esi
			break;
  80084a:	83 c4 10             	add    $0x10,%esp
  80084d:	e9 7a ff ff ff       	jmp    8007cc <vprintfmt+0x3a6>
			putch('%', putdat);
  800852:	83 ec 08             	sub    $0x8,%esp
  800855:	53                   	push   %ebx
  800856:	6a 25                	push   $0x25
  800858:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80085a:	83 c4 10             	add    $0x10,%esp
  80085d:	89 f8                	mov    %edi,%eax
  80085f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800863:	74 05                	je     80086a <vprintfmt+0x444>
  800865:	83 e8 01             	sub    $0x1,%eax
  800868:	eb f5                	jmp    80085f <vprintfmt+0x439>
  80086a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80086d:	e9 5a ff ff ff       	jmp    8007cc <vprintfmt+0x3a6>
}
  800872:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800875:	5b                   	pop    %ebx
  800876:	5e                   	pop    %esi
  800877:	5f                   	pop    %edi
  800878:	5d                   	pop    %ebp
  800879:	c3                   	ret    

0080087a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80087a:	f3 0f 1e fb          	endbr32 
  80087e:	55                   	push   %ebp
  80087f:	89 e5                	mov    %esp,%ebp
  800881:	83 ec 18             	sub    $0x18,%esp
  800884:	8b 45 08             	mov    0x8(%ebp),%eax
  800887:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80088a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80088d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800891:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800894:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80089b:	85 c0                	test   %eax,%eax
  80089d:	74 26                	je     8008c5 <vsnprintf+0x4b>
  80089f:	85 d2                	test   %edx,%edx
  8008a1:	7e 22                	jle    8008c5 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008a3:	ff 75 14             	pushl  0x14(%ebp)
  8008a6:	ff 75 10             	pushl  0x10(%ebp)
  8008a9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008ac:	50                   	push   %eax
  8008ad:	68 e4 03 80 00       	push   $0x8003e4
  8008b2:	e8 6f fb ff ff       	call   800426 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008ba:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008c0:	83 c4 10             	add    $0x10,%esp
}
  8008c3:	c9                   	leave  
  8008c4:	c3                   	ret    
		return -E_INVAL;
  8008c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008ca:	eb f7                	jmp    8008c3 <vsnprintf+0x49>

008008cc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008cc:	f3 0f 1e fb          	endbr32 
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
  8008d3:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008d6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008d9:	50                   	push   %eax
  8008da:	ff 75 10             	pushl  0x10(%ebp)
  8008dd:	ff 75 0c             	pushl  0xc(%ebp)
  8008e0:	ff 75 08             	pushl  0x8(%ebp)
  8008e3:	e8 92 ff ff ff       	call   80087a <vsnprintf>
	va_end(ap);

	return rc;
}
  8008e8:	c9                   	leave  
  8008e9:	c3                   	ret    

008008ea <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008ea:	f3 0f 1e fb          	endbr32 
  8008ee:	55                   	push   %ebp
  8008ef:	89 e5                	mov    %esp,%ebp
  8008f1:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f9:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008fd:	74 05                	je     800904 <strlen+0x1a>
		n++;
  8008ff:	83 c0 01             	add    $0x1,%eax
  800902:	eb f5                	jmp    8008f9 <strlen+0xf>
	return n;
}
  800904:	5d                   	pop    %ebp
  800905:	c3                   	ret    

00800906 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800906:	f3 0f 1e fb          	endbr32 
  80090a:	55                   	push   %ebp
  80090b:	89 e5                	mov    %esp,%ebp
  80090d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800910:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800913:	b8 00 00 00 00       	mov    $0x0,%eax
  800918:	39 d0                	cmp    %edx,%eax
  80091a:	74 0d                	je     800929 <strnlen+0x23>
  80091c:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800920:	74 05                	je     800927 <strnlen+0x21>
		n++;
  800922:	83 c0 01             	add    $0x1,%eax
  800925:	eb f1                	jmp    800918 <strnlen+0x12>
  800927:	89 c2                	mov    %eax,%edx
	return n;
}
  800929:	89 d0                	mov    %edx,%eax
  80092b:	5d                   	pop    %ebp
  80092c:	c3                   	ret    

0080092d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80092d:	f3 0f 1e fb          	endbr32 
  800931:	55                   	push   %ebp
  800932:	89 e5                	mov    %esp,%ebp
  800934:	53                   	push   %ebx
  800935:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800938:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80093b:	b8 00 00 00 00       	mov    $0x0,%eax
  800940:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800944:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800947:	83 c0 01             	add    $0x1,%eax
  80094a:	84 d2                	test   %dl,%dl
  80094c:	75 f2                	jne    800940 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  80094e:	89 c8                	mov    %ecx,%eax
  800950:	5b                   	pop    %ebx
  800951:	5d                   	pop    %ebp
  800952:	c3                   	ret    

00800953 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800953:	f3 0f 1e fb          	endbr32 
  800957:	55                   	push   %ebp
  800958:	89 e5                	mov    %esp,%ebp
  80095a:	53                   	push   %ebx
  80095b:	83 ec 10             	sub    $0x10,%esp
  80095e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800961:	53                   	push   %ebx
  800962:	e8 83 ff ff ff       	call   8008ea <strlen>
  800967:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80096a:	ff 75 0c             	pushl  0xc(%ebp)
  80096d:	01 d8                	add    %ebx,%eax
  80096f:	50                   	push   %eax
  800970:	e8 b8 ff ff ff       	call   80092d <strcpy>
	return dst;
}
  800975:	89 d8                	mov    %ebx,%eax
  800977:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80097a:	c9                   	leave  
  80097b:	c3                   	ret    

0080097c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80097c:	f3 0f 1e fb          	endbr32 
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	56                   	push   %esi
  800984:	53                   	push   %ebx
  800985:	8b 75 08             	mov    0x8(%ebp),%esi
  800988:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098b:	89 f3                	mov    %esi,%ebx
  80098d:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800990:	89 f0                	mov    %esi,%eax
  800992:	39 d8                	cmp    %ebx,%eax
  800994:	74 11                	je     8009a7 <strncpy+0x2b>
		*dst++ = *src;
  800996:	83 c0 01             	add    $0x1,%eax
  800999:	0f b6 0a             	movzbl (%edx),%ecx
  80099c:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80099f:	80 f9 01             	cmp    $0x1,%cl
  8009a2:	83 da ff             	sbb    $0xffffffff,%edx
  8009a5:	eb eb                	jmp    800992 <strncpy+0x16>
	}
	return ret;
}
  8009a7:	89 f0                	mov    %esi,%eax
  8009a9:	5b                   	pop    %ebx
  8009aa:	5e                   	pop    %esi
  8009ab:	5d                   	pop    %ebp
  8009ac:	c3                   	ret    

008009ad <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009ad:	f3 0f 1e fb          	endbr32 
  8009b1:	55                   	push   %ebp
  8009b2:	89 e5                	mov    %esp,%ebp
  8009b4:	56                   	push   %esi
  8009b5:	53                   	push   %ebx
  8009b6:	8b 75 08             	mov    0x8(%ebp),%esi
  8009b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009bc:	8b 55 10             	mov    0x10(%ebp),%edx
  8009bf:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009c1:	85 d2                	test   %edx,%edx
  8009c3:	74 21                	je     8009e6 <strlcpy+0x39>
  8009c5:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009c9:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009cb:	39 c2                	cmp    %eax,%edx
  8009cd:	74 14                	je     8009e3 <strlcpy+0x36>
  8009cf:	0f b6 19             	movzbl (%ecx),%ebx
  8009d2:	84 db                	test   %bl,%bl
  8009d4:	74 0b                	je     8009e1 <strlcpy+0x34>
			*dst++ = *src++;
  8009d6:	83 c1 01             	add    $0x1,%ecx
  8009d9:	83 c2 01             	add    $0x1,%edx
  8009dc:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009df:	eb ea                	jmp    8009cb <strlcpy+0x1e>
  8009e1:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009e3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009e6:	29 f0                	sub    %esi,%eax
}
  8009e8:	5b                   	pop    %ebx
  8009e9:	5e                   	pop    %esi
  8009ea:	5d                   	pop    %ebp
  8009eb:	c3                   	ret    

008009ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009ec:	f3 0f 1e fb          	endbr32 
  8009f0:	55                   	push   %ebp
  8009f1:	89 e5                	mov    %esp,%ebp
  8009f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009f6:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009f9:	0f b6 01             	movzbl (%ecx),%eax
  8009fc:	84 c0                	test   %al,%al
  8009fe:	74 0c                	je     800a0c <strcmp+0x20>
  800a00:	3a 02                	cmp    (%edx),%al
  800a02:	75 08                	jne    800a0c <strcmp+0x20>
		p++, q++;
  800a04:	83 c1 01             	add    $0x1,%ecx
  800a07:	83 c2 01             	add    $0x1,%edx
  800a0a:	eb ed                	jmp    8009f9 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a0c:	0f b6 c0             	movzbl %al,%eax
  800a0f:	0f b6 12             	movzbl (%edx),%edx
  800a12:	29 d0                	sub    %edx,%eax
}
  800a14:	5d                   	pop    %ebp
  800a15:	c3                   	ret    

00800a16 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a16:	f3 0f 1e fb          	endbr32 
  800a1a:	55                   	push   %ebp
  800a1b:	89 e5                	mov    %esp,%ebp
  800a1d:	53                   	push   %ebx
  800a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a21:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a24:	89 c3                	mov    %eax,%ebx
  800a26:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a29:	eb 06                	jmp    800a31 <strncmp+0x1b>
		n--, p++, q++;
  800a2b:	83 c0 01             	add    $0x1,%eax
  800a2e:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a31:	39 d8                	cmp    %ebx,%eax
  800a33:	74 16                	je     800a4b <strncmp+0x35>
  800a35:	0f b6 08             	movzbl (%eax),%ecx
  800a38:	84 c9                	test   %cl,%cl
  800a3a:	74 04                	je     800a40 <strncmp+0x2a>
  800a3c:	3a 0a                	cmp    (%edx),%cl
  800a3e:	74 eb                	je     800a2b <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a40:	0f b6 00             	movzbl (%eax),%eax
  800a43:	0f b6 12             	movzbl (%edx),%edx
  800a46:	29 d0                	sub    %edx,%eax
}
  800a48:	5b                   	pop    %ebx
  800a49:	5d                   	pop    %ebp
  800a4a:	c3                   	ret    
		return 0;
  800a4b:	b8 00 00 00 00       	mov    $0x0,%eax
  800a50:	eb f6                	jmp    800a48 <strncmp+0x32>

00800a52 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a52:	f3 0f 1e fb          	endbr32 
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a60:	0f b6 10             	movzbl (%eax),%edx
  800a63:	84 d2                	test   %dl,%dl
  800a65:	74 09                	je     800a70 <strchr+0x1e>
		if (*s == c)
  800a67:	38 ca                	cmp    %cl,%dl
  800a69:	74 0a                	je     800a75 <strchr+0x23>
	for (; *s; s++)
  800a6b:	83 c0 01             	add    $0x1,%eax
  800a6e:	eb f0                	jmp    800a60 <strchr+0xe>
			return (char *) s;
	return 0;
  800a70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a75:	5d                   	pop    %ebp
  800a76:	c3                   	ret    

00800a77 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a77:	f3 0f 1e fb          	endbr32 
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
  800a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a81:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a85:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a88:	38 ca                	cmp    %cl,%dl
  800a8a:	74 09                	je     800a95 <strfind+0x1e>
  800a8c:	84 d2                	test   %dl,%dl
  800a8e:	74 05                	je     800a95 <strfind+0x1e>
	for (; *s; s++)
  800a90:	83 c0 01             	add    $0x1,%eax
  800a93:	eb f0                	jmp    800a85 <strfind+0xe>
			break;
	return (char *) s;
}
  800a95:	5d                   	pop    %ebp
  800a96:	c3                   	ret    

00800a97 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a97:	f3 0f 1e fb          	endbr32 
  800a9b:	55                   	push   %ebp
  800a9c:	89 e5                	mov    %esp,%ebp
  800a9e:	57                   	push   %edi
  800a9f:	56                   	push   %esi
  800aa0:	53                   	push   %ebx
  800aa1:	8b 7d 08             	mov    0x8(%ebp),%edi
  800aa4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800aa7:	85 c9                	test   %ecx,%ecx
  800aa9:	74 31                	je     800adc <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800aab:	89 f8                	mov    %edi,%eax
  800aad:	09 c8                	or     %ecx,%eax
  800aaf:	a8 03                	test   $0x3,%al
  800ab1:	75 23                	jne    800ad6 <memset+0x3f>
		c &= 0xFF;
  800ab3:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ab7:	89 d3                	mov    %edx,%ebx
  800ab9:	c1 e3 08             	shl    $0x8,%ebx
  800abc:	89 d0                	mov    %edx,%eax
  800abe:	c1 e0 18             	shl    $0x18,%eax
  800ac1:	89 d6                	mov    %edx,%esi
  800ac3:	c1 e6 10             	shl    $0x10,%esi
  800ac6:	09 f0                	or     %esi,%eax
  800ac8:	09 c2                	or     %eax,%edx
  800aca:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800acc:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800acf:	89 d0                	mov    %edx,%eax
  800ad1:	fc                   	cld    
  800ad2:	f3 ab                	rep stos %eax,%es:(%edi)
  800ad4:	eb 06                	jmp    800adc <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad9:	fc                   	cld    
  800ada:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800adc:	89 f8                	mov    %edi,%eax
  800ade:	5b                   	pop    %ebx
  800adf:	5e                   	pop    %esi
  800ae0:	5f                   	pop    %edi
  800ae1:	5d                   	pop    %ebp
  800ae2:	c3                   	ret    

00800ae3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ae3:	f3 0f 1e fb          	endbr32 
  800ae7:	55                   	push   %ebp
  800ae8:	89 e5                	mov    %esp,%ebp
  800aea:	57                   	push   %edi
  800aeb:	56                   	push   %esi
  800aec:	8b 45 08             	mov    0x8(%ebp),%eax
  800aef:	8b 75 0c             	mov    0xc(%ebp),%esi
  800af2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800af5:	39 c6                	cmp    %eax,%esi
  800af7:	73 32                	jae    800b2b <memmove+0x48>
  800af9:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800afc:	39 c2                	cmp    %eax,%edx
  800afe:	76 2b                	jbe    800b2b <memmove+0x48>
		s += n;
		d += n;
  800b00:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b03:	89 fe                	mov    %edi,%esi
  800b05:	09 ce                	or     %ecx,%esi
  800b07:	09 d6                	or     %edx,%esi
  800b09:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b0f:	75 0e                	jne    800b1f <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b11:	83 ef 04             	sub    $0x4,%edi
  800b14:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b17:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b1a:	fd                   	std    
  800b1b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b1d:	eb 09                	jmp    800b28 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b1f:	83 ef 01             	sub    $0x1,%edi
  800b22:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b25:	fd                   	std    
  800b26:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b28:	fc                   	cld    
  800b29:	eb 1a                	jmp    800b45 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b2b:	89 c2                	mov    %eax,%edx
  800b2d:	09 ca                	or     %ecx,%edx
  800b2f:	09 f2                	or     %esi,%edx
  800b31:	f6 c2 03             	test   $0x3,%dl
  800b34:	75 0a                	jne    800b40 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b36:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b39:	89 c7                	mov    %eax,%edi
  800b3b:	fc                   	cld    
  800b3c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b3e:	eb 05                	jmp    800b45 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800b40:	89 c7                	mov    %eax,%edi
  800b42:	fc                   	cld    
  800b43:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b45:	5e                   	pop    %esi
  800b46:	5f                   	pop    %edi
  800b47:	5d                   	pop    %ebp
  800b48:	c3                   	ret    

00800b49 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b49:	f3 0f 1e fb          	endbr32 
  800b4d:	55                   	push   %ebp
  800b4e:	89 e5                	mov    %esp,%ebp
  800b50:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b53:	ff 75 10             	pushl  0x10(%ebp)
  800b56:	ff 75 0c             	pushl  0xc(%ebp)
  800b59:	ff 75 08             	pushl  0x8(%ebp)
  800b5c:	e8 82 ff ff ff       	call   800ae3 <memmove>
}
  800b61:	c9                   	leave  
  800b62:	c3                   	ret    

00800b63 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b63:	f3 0f 1e fb          	endbr32 
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
  800b6a:	56                   	push   %esi
  800b6b:	53                   	push   %ebx
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b72:	89 c6                	mov    %eax,%esi
  800b74:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b77:	39 f0                	cmp    %esi,%eax
  800b79:	74 1c                	je     800b97 <memcmp+0x34>
		if (*s1 != *s2)
  800b7b:	0f b6 08             	movzbl (%eax),%ecx
  800b7e:	0f b6 1a             	movzbl (%edx),%ebx
  800b81:	38 d9                	cmp    %bl,%cl
  800b83:	75 08                	jne    800b8d <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b85:	83 c0 01             	add    $0x1,%eax
  800b88:	83 c2 01             	add    $0x1,%edx
  800b8b:	eb ea                	jmp    800b77 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800b8d:	0f b6 c1             	movzbl %cl,%eax
  800b90:	0f b6 db             	movzbl %bl,%ebx
  800b93:	29 d8                	sub    %ebx,%eax
  800b95:	eb 05                	jmp    800b9c <memcmp+0x39>
	}

	return 0;
  800b97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b9c:	5b                   	pop    %ebx
  800b9d:	5e                   	pop    %esi
  800b9e:	5d                   	pop    %ebp
  800b9f:	c3                   	ret    

00800ba0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ba0:	f3 0f 1e fb          	endbr32 
  800ba4:	55                   	push   %ebp
  800ba5:	89 e5                	mov    %esp,%ebp
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bad:	89 c2                	mov    %eax,%edx
  800baf:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bb2:	39 d0                	cmp    %edx,%eax
  800bb4:	73 09                	jae    800bbf <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bb6:	38 08                	cmp    %cl,(%eax)
  800bb8:	74 05                	je     800bbf <memfind+0x1f>
	for (; s < ends; s++)
  800bba:	83 c0 01             	add    $0x1,%eax
  800bbd:	eb f3                	jmp    800bb2 <memfind+0x12>
			break;
	return (void *) s;
}
  800bbf:	5d                   	pop    %ebp
  800bc0:	c3                   	ret    

00800bc1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bc1:	f3 0f 1e fb          	endbr32 
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	57                   	push   %edi
  800bc9:	56                   	push   %esi
  800bca:	53                   	push   %ebx
  800bcb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bce:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bd1:	eb 03                	jmp    800bd6 <strtol+0x15>
		s++;
  800bd3:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bd6:	0f b6 01             	movzbl (%ecx),%eax
  800bd9:	3c 20                	cmp    $0x20,%al
  800bdb:	74 f6                	je     800bd3 <strtol+0x12>
  800bdd:	3c 09                	cmp    $0x9,%al
  800bdf:	74 f2                	je     800bd3 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800be1:	3c 2b                	cmp    $0x2b,%al
  800be3:	74 2a                	je     800c0f <strtol+0x4e>
	int neg = 0;
  800be5:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bea:	3c 2d                	cmp    $0x2d,%al
  800bec:	74 2b                	je     800c19 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bee:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bf4:	75 0f                	jne    800c05 <strtol+0x44>
  800bf6:	80 39 30             	cmpb   $0x30,(%ecx)
  800bf9:	74 28                	je     800c23 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bfb:	85 db                	test   %ebx,%ebx
  800bfd:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c02:	0f 44 d8             	cmove  %eax,%ebx
  800c05:	b8 00 00 00 00       	mov    $0x0,%eax
  800c0a:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c0d:	eb 46                	jmp    800c55 <strtol+0x94>
		s++;
  800c0f:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c12:	bf 00 00 00 00       	mov    $0x0,%edi
  800c17:	eb d5                	jmp    800bee <strtol+0x2d>
		s++, neg = 1;
  800c19:	83 c1 01             	add    $0x1,%ecx
  800c1c:	bf 01 00 00 00       	mov    $0x1,%edi
  800c21:	eb cb                	jmp    800bee <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c23:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c27:	74 0e                	je     800c37 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c29:	85 db                	test   %ebx,%ebx
  800c2b:	75 d8                	jne    800c05 <strtol+0x44>
		s++, base = 8;
  800c2d:	83 c1 01             	add    $0x1,%ecx
  800c30:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c35:	eb ce                	jmp    800c05 <strtol+0x44>
		s += 2, base = 16;
  800c37:	83 c1 02             	add    $0x2,%ecx
  800c3a:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c3f:	eb c4                	jmp    800c05 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800c41:	0f be d2             	movsbl %dl,%edx
  800c44:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c47:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c4a:	7d 3a                	jge    800c86 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c4c:	83 c1 01             	add    $0x1,%ecx
  800c4f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c53:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c55:	0f b6 11             	movzbl (%ecx),%edx
  800c58:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c5b:	89 f3                	mov    %esi,%ebx
  800c5d:	80 fb 09             	cmp    $0x9,%bl
  800c60:	76 df                	jbe    800c41 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800c62:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c65:	89 f3                	mov    %esi,%ebx
  800c67:	80 fb 19             	cmp    $0x19,%bl
  800c6a:	77 08                	ja     800c74 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c6c:	0f be d2             	movsbl %dl,%edx
  800c6f:	83 ea 57             	sub    $0x57,%edx
  800c72:	eb d3                	jmp    800c47 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800c74:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c77:	89 f3                	mov    %esi,%ebx
  800c79:	80 fb 19             	cmp    $0x19,%bl
  800c7c:	77 08                	ja     800c86 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c7e:	0f be d2             	movsbl %dl,%edx
  800c81:	83 ea 37             	sub    $0x37,%edx
  800c84:	eb c1                	jmp    800c47 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c86:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c8a:	74 05                	je     800c91 <strtol+0xd0>
		*endptr = (char *) s;
  800c8c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c8f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c91:	89 c2                	mov    %eax,%edx
  800c93:	f7 da                	neg    %edx
  800c95:	85 ff                	test   %edi,%edi
  800c97:	0f 45 c2             	cmovne %edx,%eax
}
  800c9a:	5b                   	pop    %ebx
  800c9b:	5e                   	pop    %esi
  800c9c:	5f                   	pop    %edi
  800c9d:	5d                   	pop    %ebp
  800c9e:	c3                   	ret    

00800c9f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c9f:	f3 0f 1e fb          	endbr32 
  800ca3:	55                   	push   %ebp
  800ca4:	89 e5                	mov    %esp,%ebp
  800ca6:	57                   	push   %edi
  800ca7:	56                   	push   %esi
  800ca8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ca9:	b8 00 00 00 00       	mov    $0x0,%eax
  800cae:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb4:	89 c3                	mov    %eax,%ebx
  800cb6:	89 c7                	mov    %eax,%edi
  800cb8:	89 c6                	mov    %eax,%esi
  800cba:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cbc:	5b                   	pop    %ebx
  800cbd:	5e                   	pop    %esi
  800cbe:	5f                   	pop    %edi
  800cbf:	5d                   	pop    %ebp
  800cc0:	c3                   	ret    

00800cc1 <sys_cgetc>:

int
sys_cgetc(void)
{
  800cc1:	f3 0f 1e fb          	endbr32 
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	57                   	push   %edi
  800cc9:	56                   	push   %esi
  800cca:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ccb:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd0:	b8 01 00 00 00       	mov    $0x1,%eax
  800cd5:	89 d1                	mov    %edx,%ecx
  800cd7:	89 d3                	mov    %edx,%ebx
  800cd9:	89 d7                	mov    %edx,%edi
  800cdb:	89 d6                	mov    %edx,%esi
  800cdd:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cdf:	5b                   	pop    %ebx
  800ce0:	5e                   	pop    %esi
  800ce1:	5f                   	pop    %edi
  800ce2:	5d                   	pop    %ebp
  800ce3:	c3                   	ret    

00800ce4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ce4:	f3 0f 1e fb          	endbr32 
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	57                   	push   %edi
  800cec:	56                   	push   %esi
  800ced:	53                   	push   %ebx
  800cee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cf6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf9:	b8 03 00 00 00       	mov    $0x3,%eax
  800cfe:	89 cb                	mov    %ecx,%ebx
  800d00:	89 cf                	mov    %ecx,%edi
  800d02:	89 ce                	mov    %ecx,%esi
  800d04:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d06:	85 c0                	test   %eax,%eax
  800d08:	7f 08                	jg     800d12 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d0d:	5b                   	pop    %ebx
  800d0e:	5e                   	pop    %esi
  800d0f:	5f                   	pop    %edi
  800d10:	5d                   	pop    %ebp
  800d11:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d12:	83 ec 0c             	sub    $0xc,%esp
  800d15:	50                   	push   %eax
  800d16:	6a 03                	push   $0x3
  800d18:	68 7f 2d 80 00       	push   $0x802d7f
  800d1d:	6a 23                	push   $0x23
  800d1f:	68 9c 2d 80 00       	push   $0x802d9c
  800d24:	e8 13 f5 ff ff       	call   80023c <_panic>

00800d29 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d29:	f3 0f 1e fb          	endbr32 
  800d2d:	55                   	push   %ebp
  800d2e:	89 e5                	mov    %esp,%ebp
  800d30:	57                   	push   %edi
  800d31:	56                   	push   %esi
  800d32:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d33:	ba 00 00 00 00       	mov    $0x0,%edx
  800d38:	b8 02 00 00 00       	mov    $0x2,%eax
  800d3d:	89 d1                	mov    %edx,%ecx
  800d3f:	89 d3                	mov    %edx,%ebx
  800d41:	89 d7                	mov    %edx,%edi
  800d43:	89 d6                	mov    %edx,%esi
  800d45:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d47:	5b                   	pop    %ebx
  800d48:	5e                   	pop    %esi
  800d49:	5f                   	pop    %edi
  800d4a:	5d                   	pop    %ebp
  800d4b:	c3                   	ret    

00800d4c <sys_yield>:

void
sys_yield(void)
{
  800d4c:	f3 0f 1e fb          	endbr32 
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	57                   	push   %edi
  800d54:	56                   	push   %esi
  800d55:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d56:	ba 00 00 00 00       	mov    $0x0,%edx
  800d5b:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d60:	89 d1                	mov    %edx,%ecx
  800d62:	89 d3                	mov    %edx,%ebx
  800d64:	89 d7                	mov    %edx,%edi
  800d66:	89 d6                	mov    %edx,%esi
  800d68:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d6a:	5b                   	pop    %ebx
  800d6b:	5e                   	pop    %esi
  800d6c:	5f                   	pop    %edi
  800d6d:	5d                   	pop    %ebp
  800d6e:	c3                   	ret    

00800d6f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d6f:	f3 0f 1e fb          	endbr32 
  800d73:	55                   	push   %ebp
  800d74:	89 e5                	mov    %esp,%ebp
  800d76:	57                   	push   %edi
  800d77:	56                   	push   %esi
  800d78:	53                   	push   %ebx
  800d79:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d7c:	be 00 00 00 00       	mov    $0x0,%esi
  800d81:	8b 55 08             	mov    0x8(%ebp),%edx
  800d84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d87:	b8 04 00 00 00       	mov    $0x4,%eax
  800d8c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d8f:	89 f7                	mov    %esi,%edi
  800d91:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d93:	85 c0                	test   %eax,%eax
  800d95:	7f 08                	jg     800d9f <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d97:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9a:	5b                   	pop    %ebx
  800d9b:	5e                   	pop    %esi
  800d9c:	5f                   	pop    %edi
  800d9d:	5d                   	pop    %ebp
  800d9e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9f:	83 ec 0c             	sub    $0xc,%esp
  800da2:	50                   	push   %eax
  800da3:	6a 04                	push   $0x4
  800da5:	68 7f 2d 80 00       	push   $0x802d7f
  800daa:	6a 23                	push   $0x23
  800dac:	68 9c 2d 80 00       	push   $0x802d9c
  800db1:	e8 86 f4 ff ff       	call   80023c <_panic>

00800db6 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800db6:	f3 0f 1e fb          	endbr32 
  800dba:	55                   	push   %ebp
  800dbb:	89 e5                	mov    %esp,%ebp
  800dbd:	57                   	push   %edi
  800dbe:	56                   	push   %esi
  800dbf:	53                   	push   %ebx
  800dc0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc9:	b8 05 00 00 00       	mov    $0x5,%eax
  800dce:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dd1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dd4:	8b 75 18             	mov    0x18(%ebp),%esi
  800dd7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd9:	85 c0                	test   %eax,%eax
  800ddb:	7f 08                	jg     800de5 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ddd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de0:	5b                   	pop    %ebx
  800de1:	5e                   	pop    %esi
  800de2:	5f                   	pop    %edi
  800de3:	5d                   	pop    %ebp
  800de4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de5:	83 ec 0c             	sub    $0xc,%esp
  800de8:	50                   	push   %eax
  800de9:	6a 05                	push   $0x5
  800deb:	68 7f 2d 80 00       	push   $0x802d7f
  800df0:	6a 23                	push   $0x23
  800df2:	68 9c 2d 80 00       	push   $0x802d9c
  800df7:	e8 40 f4 ff ff       	call   80023c <_panic>

00800dfc <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dfc:	f3 0f 1e fb          	endbr32 
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	57                   	push   %edi
  800e04:	56                   	push   %esi
  800e05:	53                   	push   %ebx
  800e06:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e09:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e0e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e14:	b8 06 00 00 00       	mov    $0x6,%eax
  800e19:	89 df                	mov    %ebx,%edi
  800e1b:	89 de                	mov    %ebx,%esi
  800e1d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e1f:	85 c0                	test   %eax,%eax
  800e21:	7f 08                	jg     800e2b <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e23:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e26:	5b                   	pop    %ebx
  800e27:	5e                   	pop    %esi
  800e28:	5f                   	pop    %edi
  800e29:	5d                   	pop    %ebp
  800e2a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e2b:	83 ec 0c             	sub    $0xc,%esp
  800e2e:	50                   	push   %eax
  800e2f:	6a 06                	push   $0x6
  800e31:	68 7f 2d 80 00       	push   $0x802d7f
  800e36:	6a 23                	push   $0x23
  800e38:	68 9c 2d 80 00       	push   $0x802d9c
  800e3d:	e8 fa f3 ff ff       	call   80023c <_panic>

00800e42 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e42:	f3 0f 1e fb          	endbr32 
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	57                   	push   %edi
  800e4a:	56                   	push   %esi
  800e4b:	53                   	push   %ebx
  800e4c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e4f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e54:	8b 55 08             	mov    0x8(%ebp),%edx
  800e57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5a:	b8 08 00 00 00       	mov    $0x8,%eax
  800e5f:	89 df                	mov    %ebx,%edi
  800e61:	89 de                	mov    %ebx,%esi
  800e63:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e65:	85 c0                	test   %eax,%eax
  800e67:	7f 08                	jg     800e71 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e69:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e6c:	5b                   	pop    %ebx
  800e6d:	5e                   	pop    %esi
  800e6e:	5f                   	pop    %edi
  800e6f:	5d                   	pop    %ebp
  800e70:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e71:	83 ec 0c             	sub    $0xc,%esp
  800e74:	50                   	push   %eax
  800e75:	6a 08                	push   $0x8
  800e77:	68 7f 2d 80 00       	push   $0x802d7f
  800e7c:	6a 23                	push   $0x23
  800e7e:	68 9c 2d 80 00       	push   $0x802d9c
  800e83:	e8 b4 f3 ff ff       	call   80023c <_panic>

00800e88 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e88:	f3 0f 1e fb          	endbr32 
  800e8c:	55                   	push   %ebp
  800e8d:	89 e5                	mov    %esp,%ebp
  800e8f:	57                   	push   %edi
  800e90:	56                   	push   %esi
  800e91:	53                   	push   %ebx
  800e92:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e95:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea0:	b8 09 00 00 00       	mov    $0x9,%eax
  800ea5:	89 df                	mov    %ebx,%edi
  800ea7:	89 de                	mov    %ebx,%esi
  800ea9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eab:	85 c0                	test   %eax,%eax
  800ead:	7f 08                	jg     800eb7 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800eaf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb2:	5b                   	pop    %ebx
  800eb3:	5e                   	pop    %esi
  800eb4:	5f                   	pop    %edi
  800eb5:	5d                   	pop    %ebp
  800eb6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb7:	83 ec 0c             	sub    $0xc,%esp
  800eba:	50                   	push   %eax
  800ebb:	6a 09                	push   $0x9
  800ebd:	68 7f 2d 80 00       	push   $0x802d7f
  800ec2:	6a 23                	push   $0x23
  800ec4:	68 9c 2d 80 00       	push   $0x802d9c
  800ec9:	e8 6e f3 ff ff       	call   80023c <_panic>

00800ece <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ece:	f3 0f 1e fb          	endbr32 
  800ed2:	55                   	push   %ebp
  800ed3:	89 e5                	mov    %esp,%ebp
  800ed5:	57                   	push   %edi
  800ed6:	56                   	push   %esi
  800ed7:	53                   	push   %ebx
  800ed8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800edb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eeb:	89 df                	mov    %ebx,%edi
  800eed:	89 de                	mov    %ebx,%esi
  800eef:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef1:	85 c0                	test   %eax,%eax
  800ef3:	7f 08                	jg     800efd <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ef5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef8:	5b                   	pop    %ebx
  800ef9:	5e                   	pop    %esi
  800efa:	5f                   	pop    %edi
  800efb:	5d                   	pop    %ebp
  800efc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800efd:	83 ec 0c             	sub    $0xc,%esp
  800f00:	50                   	push   %eax
  800f01:	6a 0a                	push   $0xa
  800f03:	68 7f 2d 80 00       	push   $0x802d7f
  800f08:	6a 23                	push   $0x23
  800f0a:	68 9c 2d 80 00       	push   $0x802d9c
  800f0f:	e8 28 f3 ff ff       	call   80023c <_panic>

00800f14 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f14:	f3 0f 1e fb          	endbr32 
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	57                   	push   %edi
  800f1c:	56                   	push   %esi
  800f1d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f24:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f29:	be 00 00 00 00       	mov    $0x0,%esi
  800f2e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f31:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f34:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f36:	5b                   	pop    %ebx
  800f37:	5e                   	pop    %esi
  800f38:	5f                   	pop    %edi
  800f39:	5d                   	pop    %ebp
  800f3a:	c3                   	ret    

00800f3b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f3b:	f3 0f 1e fb          	endbr32 
  800f3f:	55                   	push   %ebp
  800f40:	89 e5                	mov    %esp,%ebp
  800f42:	57                   	push   %edi
  800f43:	56                   	push   %esi
  800f44:	53                   	push   %ebx
  800f45:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f48:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f50:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f55:	89 cb                	mov    %ecx,%ebx
  800f57:	89 cf                	mov    %ecx,%edi
  800f59:	89 ce                	mov    %ecx,%esi
  800f5b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f5d:	85 c0                	test   %eax,%eax
  800f5f:	7f 08                	jg     800f69 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f64:	5b                   	pop    %ebx
  800f65:	5e                   	pop    %esi
  800f66:	5f                   	pop    %edi
  800f67:	5d                   	pop    %ebp
  800f68:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f69:	83 ec 0c             	sub    $0xc,%esp
  800f6c:	50                   	push   %eax
  800f6d:	6a 0d                	push   $0xd
  800f6f:	68 7f 2d 80 00       	push   $0x802d7f
  800f74:	6a 23                	push   $0x23
  800f76:	68 9c 2d 80 00       	push   $0x802d9c
  800f7b:	e8 bc f2 ff ff       	call   80023c <_panic>

00800f80 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f80:	f3 0f 1e fb          	endbr32 
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	57                   	push   %edi
  800f88:	56                   	push   %esi
  800f89:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800f8f:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f94:	89 d1                	mov    %edx,%ecx
  800f96:	89 d3                	mov    %edx,%ebx
  800f98:	89 d7                	mov    %edx,%edi
  800f9a:	89 d6                	mov    %edx,%esi
  800f9c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f9e:	5b                   	pop    %ebx
  800f9f:	5e                   	pop    %esi
  800fa0:	5f                   	pop    %edi
  800fa1:	5d                   	pop    %ebp
  800fa2:	c3                   	ret    

00800fa3 <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  800fa3:	f3 0f 1e fb          	endbr32 
  800fa7:	55                   	push   %ebp
  800fa8:	89 e5                	mov    %esp,%ebp
  800faa:	57                   	push   %edi
  800fab:	56                   	push   %esi
  800fac:	53                   	push   %ebx
  800fad:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fb0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fbb:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fc0:	89 df                	mov    %ebx,%edi
  800fc2:	89 de                	mov    %ebx,%esi
  800fc4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fc6:	85 c0                	test   %eax,%eax
  800fc8:	7f 08                	jg     800fd2 <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  800fca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fcd:	5b                   	pop    %ebx
  800fce:	5e                   	pop    %esi
  800fcf:	5f                   	pop    %edi
  800fd0:	5d                   	pop    %ebp
  800fd1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd2:	83 ec 0c             	sub    $0xc,%esp
  800fd5:	50                   	push   %eax
  800fd6:	6a 0f                	push   $0xf
  800fd8:	68 7f 2d 80 00       	push   $0x802d7f
  800fdd:	6a 23                	push   $0x23
  800fdf:	68 9c 2d 80 00       	push   $0x802d9c
  800fe4:	e8 53 f2 ff ff       	call   80023c <_panic>

00800fe9 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  800fe9:	f3 0f 1e fb          	endbr32 
  800fed:	55                   	push   %ebp
  800fee:	89 e5                	mov    %esp,%ebp
  800ff0:	57                   	push   %edi
  800ff1:	56                   	push   %esi
  800ff2:	53                   	push   %ebx
  800ff3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ff6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ffb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ffe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801001:	b8 10 00 00 00       	mov    $0x10,%eax
  801006:	89 df                	mov    %ebx,%edi
  801008:	89 de                	mov    %ebx,%esi
  80100a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80100c:	85 c0                	test   %eax,%eax
  80100e:	7f 08                	jg     801018 <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  801010:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801013:	5b                   	pop    %ebx
  801014:	5e                   	pop    %esi
  801015:	5f                   	pop    %edi
  801016:	5d                   	pop    %ebp
  801017:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801018:	83 ec 0c             	sub    $0xc,%esp
  80101b:	50                   	push   %eax
  80101c:	6a 10                	push   $0x10
  80101e:	68 7f 2d 80 00       	push   $0x802d7f
  801023:	6a 23                	push   $0x23
  801025:	68 9c 2d 80 00       	push   $0x802d9c
  80102a:	e8 0d f2 ff ff       	call   80023c <_panic>

0080102f <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80102f:	f3 0f 1e fb          	endbr32 
  801033:	55                   	push   %ebp
  801034:	89 e5                	mov    %esp,%ebp
  801036:	53                   	push   %ebx
  801037:	83 ec 04             	sub    $0x4,%esp
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80103d:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  80103f:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801043:	74 74                	je     8010b9 <pgfault+0x8a>
  801045:	89 d8                	mov    %ebx,%eax
  801047:	c1 e8 0c             	shr    $0xc,%eax
  80104a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801051:	f6 c4 08             	test   $0x8,%ah
  801054:	74 63                	je     8010b9 <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  801056:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  80105c:	83 ec 0c             	sub    $0xc,%esp
  80105f:	6a 05                	push   $0x5
  801061:	68 00 f0 7f 00       	push   $0x7ff000
  801066:	6a 00                	push   $0x0
  801068:	53                   	push   %ebx
  801069:	6a 00                	push   $0x0
  80106b:	e8 46 fd ff ff       	call   800db6 <sys_page_map>
  801070:	83 c4 20             	add    $0x20,%esp
  801073:	85 c0                	test   %eax,%eax
  801075:	78 59                	js     8010d0 <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  801077:	83 ec 04             	sub    $0x4,%esp
  80107a:	6a 07                	push   $0x7
  80107c:	53                   	push   %ebx
  80107d:	6a 00                	push   $0x0
  80107f:	e8 eb fc ff ff       	call   800d6f <sys_page_alloc>
  801084:	83 c4 10             	add    $0x10,%esp
  801087:	85 c0                	test   %eax,%eax
  801089:	78 5a                	js     8010e5 <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  80108b:	83 ec 04             	sub    $0x4,%esp
  80108e:	68 00 10 00 00       	push   $0x1000
  801093:	68 00 f0 7f 00       	push   $0x7ff000
  801098:	53                   	push   %ebx
  801099:	e8 45 fa ff ff       	call   800ae3 <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  80109e:	83 c4 08             	add    $0x8,%esp
  8010a1:	68 00 f0 7f 00       	push   $0x7ff000
  8010a6:	6a 00                	push   $0x0
  8010a8:	e8 4f fd ff ff       	call   800dfc <sys_page_unmap>
  8010ad:	83 c4 10             	add    $0x10,%esp
  8010b0:	85 c0                	test   %eax,%eax
  8010b2:	78 46                	js     8010fa <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  8010b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010b7:	c9                   	leave  
  8010b8:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  8010b9:	83 ec 04             	sub    $0x4,%esp
  8010bc:	68 aa 2d 80 00       	push   $0x802daa
  8010c1:	68 d3 00 00 00       	push   $0xd3
  8010c6:	68 c6 2d 80 00       	push   $0x802dc6
  8010cb:	e8 6c f1 ff ff       	call   80023c <_panic>
		panic("pgfault: %e\n", r);
  8010d0:	50                   	push   %eax
  8010d1:	68 d1 2d 80 00       	push   $0x802dd1
  8010d6:	68 df 00 00 00       	push   $0xdf
  8010db:	68 c6 2d 80 00       	push   $0x802dc6
  8010e0:	e8 57 f1 ff ff       	call   80023c <_panic>
		panic("pgfault: %e\n", r);
  8010e5:	50                   	push   %eax
  8010e6:	68 d1 2d 80 00       	push   $0x802dd1
  8010eb:	68 e3 00 00 00       	push   $0xe3
  8010f0:	68 c6 2d 80 00       	push   $0x802dc6
  8010f5:	e8 42 f1 ff ff       	call   80023c <_panic>
		panic("pgfault: %e\n", r);
  8010fa:	50                   	push   %eax
  8010fb:	68 d1 2d 80 00       	push   $0x802dd1
  801100:	68 e9 00 00 00       	push   $0xe9
  801105:	68 c6 2d 80 00       	push   $0x802dc6
  80110a:	e8 2d f1 ff ff       	call   80023c <_panic>

0080110f <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80110f:	f3 0f 1e fb          	endbr32 
  801113:	55                   	push   %ebp
  801114:	89 e5                	mov    %esp,%ebp
  801116:	57                   	push   %edi
  801117:	56                   	push   %esi
  801118:	53                   	push   %ebx
  801119:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  80111c:	68 2f 10 80 00       	push   $0x80102f
  801121:	e8 04 14 00 00       	call   80252a <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801126:	b8 07 00 00 00       	mov    $0x7,%eax
  80112b:	cd 30                	int    $0x30
  80112d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  801130:	83 c4 10             	add    $0x10,%esp
  801133:	85 c0                	test   %eax,%eax
  801135:	78 2d                	js     801164 <fork+0x55>
  801137:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801139:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  80113e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801142:	0f 85 9b 00 00 00    	jne    8011e3 <fork+0xd4>
		thisenv = &envs[ENVX(sys_getenvid())];
  801148:	e8 dc fb ff ff       	call   800d29 <sys_getenvid>
  80114d:	25 ff 03 00 00       	and    $0x3ff,%eax
  801152:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801155:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80115a:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  80115f:	e9 71 01 00 00       	jmp    8012d5 <fork+0x1c6>
		panic("sys_exofork: %e", envid);
  801164:	50                   	push   %eax
  801165:	68 de 2d 80 00       	push   $0x802dde
  80116a:	68 2a 01 00 00       	push   $0x12a
  80116f:	68 c6 2d 80 00       	push   $0x802dc6
  801174:	e8 c3 f0 ff ff       	call   80023c <_panic>
		sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_SYSCALL);
  801179:	c1 e6 0c             	shl    $0xc,%esi
  80117c:	83 ec 0c             	sub    $0xc,%esp
  80117f:	68 07 0e 00 00       	push   $0xe07
  801184:	56                   	push   %esi
  801185:	57                   	push   %edi
  801186:	56                   	push   %esi
  801187:	6a 00                	push   $0x0
  801189:	e8 28 fc ff ff       	call   800db6 <sys_page_map>
  80118e:	83 c4 20             	add    $0x20,%esp
  801191:	eb 3e                	jmp    8011d1 <fork+0xc2>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  801193:	c1 e6 0c             	shl    $0xc,%esi
  801196:	83 ec 0c             	sub    $0xc,%esp
  801199:	68 05 08 00 00       	push   $0x805
  80119e:	56                   	push   %esi
  80119f:	57                   	push   %edi
  8011a0:	56                   	push   %esi
  8011a1:	6a 00                	push   $0x0
  8011a3:	e8 0e fc ff ff       	call   800db6 <sys_page_map>
  8011a8:	83 c4 20             	add    $0x20,%esp
  8011ab:	85 c0                	test   %eax,%eax
  8011ad:	0f 88 bc 00 00 00    	js     80126f <fork+0x160>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  8011b3:	83 ec 0c             	sub    $0xc,%esp
  8011b6:	68 05 08 00 00       	push   $0x805
  8011bb:	56                   	push   %esi
  8011bc:	6a 00                	push   $0x0
  8011be:	56                   	push   %esi
  8011bf:	6a 00                	push   $0x0
  8011c1:	e8 f0 fb ff ff       	call   800db6 <sys_page_map>
  8011c6:	83 c4 20             	add    $0x20,%esp
  8011c9:	85 c0                	test   %eax,%eax
  8011cb:	0f 88 b3 00 00 00    	js     801284 <fork+0x175>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8011d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8011d7:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8011dd:	0f 84 b6 00 00 00    	je     801299 <fork+0x18a>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  8011e3:	89 d8                	mov    %ebx,%eax
  8011e5:	c1 e8 16             	shr    $0x16,%eax
  8011e8:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011ef:	a8 01                	test   $0x1,%al
  8011f1:	74 de                	je     8011d1 <fork+0xc2>
  8011f3:	89 de                	mov    %ebx,%esi
  8011f5:	c1 ee 0c             	shr    $0xc,%esi
  8011f8:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011ff:	a8 01                	test   $0x1,%al
  801201:	74 ce                	je     8011d1 <fork+0xc2>
  801203:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80120a:	a8 04                	test   $0x4,%al
  80120c:	74 c3                	je     8011d1 <fork+0xc2>
	if ((uvpt[pn] & PTE_SHARE)){
  80120e:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801215:	f6 c4 04             	test   $0x4,%ah
  801218:	0f 85 5b ff ff ff    	jne    801179 <fork+0x6a>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  80121e:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801225:	a8 02                	test   $0x2,%al
  801227:	0f 85 66 ff ff ff    	jne    801193 <fork+0x84>
  80122d:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801234:	f6 c4 08             	test   $0x8,%ah
  801237:	0f 85 56 ff ff ff    	jne    801193 <fork+0x84>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  80123d:	c1 e6 0c             	shl    $0xc,%esi
  801240:	83 ec 0c             	sub    $0xc,%esp
  801243:	6a 05                	push   $0x5
  801245:	56                   	push   %esi
  801246:	57                   	push   %edi
  801247:	56                   	push   %esi
  801248:	6a 00                	push   $0x0
  80124a:	e8 67 fb ff ff       	call   800db6 <sys_page_map>
  80124f:	83 c4 20             	add    $0x20,%esp
  801252:	85 c0                	test   %eax,%eax
  801254:	0f 89 77 ff ff ff    	jns    8011d1 <fork+0xc2>
		panic("duppage: %e\n", r);
  80125a:	50                   	push   %eax
  80125b:	68 ee 2d 80 00       	push   $0x802dee
  801260:	68 0c 01 00 00       	push   $0x10c
  801265:	68 c6 2d 80 00       	push   $0x802dc6
  80126a:	e8 cd ef ff ff       	call   80023c <_panic>
			panic("duppage: %e\n", r);
  80126f:	50                   	push   %eax
  801270:	68 ee 2d 80 00       	push   $0x802dee
  801275:	68 05 01 00 00       	push   $0x105
  80127a:	68 c6 2d 80 00       	push   $0x802dc6
  80127f:	e8 b8 ef ff ff       	call   80023c <_panic>
			panic("duppage: %e\n", r);
  801284:	50                   	push   %eax
  801285:	68 ee 2d 80 00       	push   $0x802dee
  80128a:	68 09 01 00 00       	push   $0x109
  80128f:	68 c6 2d 80 00       	push   $0x802dc6
  801294:	e8 a3 ef ff ff       	call   80023c <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  801299:	83 ec 04             	sub    $0x4,%esp
  80129c:	6a 07                	push   $0x7
  80129e:	68 00 f0 bf ee       	push   $0xeebff000
  8012a3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012a6:	e8 c4 fa ff ff       	call   800d6f <sys_page_alloc>
  8012ab:	83 c4 10             	add    $0x10,%esp
  8012ae:	85 c0                	test   %eax,%eax
  8012b0:	78 2e                	js     8012e0 <fork+0x1d1>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8012b2:	83 ec 08             	sub    $0x8,%esp
  8012b5:	68 9d 25 80 00       	push   $0x80259d
  8012ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8012bd:	57                   	push   %edi
  8012be:	e8 0b fc ff ff       	call   800ece <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8012c3:	83 c4 08             	add    $0x8,%esp
  8012c6:	6a 02                	push   $0x2
  8012c8:	57                   	push   %edi
  8012c9:	e8 74 fb ff ff       	call   800e42 <sys_env_set_status>
  8012ce:	83 c4 10             	add    $0x10,%esp
  8012d1:	85 c0                	test   %eax,%eax
  8012d3:	78 20                	js     8012f5 <fork+0x1e6>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  8012d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012db:	5b                   	pop    %ebx
  8012dc:	5e                   	pop    %esi
  8012dd:	5f                   	pop    %edi
  8012de:	5d                   	pop    %ebp
  8012df:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  8012e0:	50                   	push   %eax
  8012e1:	68 fb 2d 80 00       	push   $0x802dfb
  8012e6:	68 3e 01 00 00       	push   $0x13e
  8012eb:	68 c6 2d 80 00       	push   $0x802dc6
  8012f0:	e8 47 ef ff ff       	call   80023c <_panic>
		panic("sys_env_set_status: %e", r);
  8012f5:	50                   	push   %eax
  8012f6:	68 0e 2e 80 00       	push   $0x802e0e
  8012fb:	68 43 01 00 00       	push   $0x143
  801300:	68 c6 2d 80 00       	push   $0x802dc6
  801305:	e8 32 ef ff ff       	call   80023c <_panic>

0080130a <sfork>:

// Challenge!
int
sfork(void)
{
  80130a:	f3 0f 1e fb          	endbr32 
  80130e:	55                   	push   %ebp
  80130f:	89 e5                	mov    %esp,%ebp
  801311:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801314:	68 25 2e 80 00       	push   $0x802e25
  801319:	68 4c 01 00 00       	push   $0x14c
  80131e:	68 c6 2d 80 00       	push   $0x802dc6
  801323:	e8 14 ef ff ff       	call   80023c <_panic>

00801328 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801328:	f3 0f 1e fb          	endbr32 
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80132f:	8b 45 08             	mov    0x8(%ebp),%eax
  801332:	05 00 00 00 30       	add    $0x30000000,%eax
  801337:	c1 e8 0c             	shr    $0xc,%eax
}
  80133a:	5d                   	pop    %ebp
  80133b:	c3                   	ret    

0080133c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80133c:	f3 0f 1e fb          	endbr32 
  801340:	55                   	push   %ebp
  801341:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801343:	8b 45 08             	mov    0x8(%ebp),%eax
  801346:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80134b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801350:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801355:	5d                   	pop    %ebp
  801356:	c3                   	ret    

00801357 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801357:	f3 0f 1e fb          	endbr32 
  80135b:	55                   	push   %ebp
  80135c:	89 e5                	mov    %esp,%ebp
  80135e:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801363:	89 c2                	mov    %eax,%edx
  801365:	c1 ea 16             	shr    $0x16,%edx
  801368:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80136f:	f6 c2 01             	test   $0x1,%dl
  801372:	74 2d                	je     8013a1 <fd_alloc+0x4a>
  801374:	89 c2                	mov    %eax,%edx
  801376:	c1 ea 0c             	shr    $0xc,%edx
  801379:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801380:	f6 c2 01             	test   $0x1,%dl
  801383:	74 1c                	je     8013a1 <fd_alloc+0x4a>
  801385:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80138a:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80138f:	75 d2                	jne    801363 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801391:	8b 45 08             	mov    0x8(%ebp),%eax
  801394:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80139a:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80139f:	eb 0a                	jmp    8013ab <fd_alloc+0x54>
			*fd_store = fd;
  8013a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013a4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ab:	5d                   	pop    %ebp
  8013ac:	c3                   	ret    

008013ad <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8013ad:	f3 0f 1e fb          	endbr32 
  8013b1:	55                   	push   %ebp
  8013b2:	89 e5                	mov    %esp,%ebp
  8013b4:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8013b7:	83 f8 1f             	cmp    $0x1f,%eax
  8013ba:	77 30                	ja     8013ec <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8013bc:	c1 e0 0c             	shl    $0xc,%eax
  8013bf:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8013c4:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8013ca:	f6 c2 01             	test   $0x1,%dl
  8013cd:	74 24                	je     8013f3 <fd_lookup+0x46>
  8013cf:	89 c2                	mov    %eax,%edx
  8013d1:	c1 ea 0c             	shr    $0xc,%edx
  8013d4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013db:	f6 c2 01             	test   $0x1,%dl
  8013de:	74 1a                	je     8013fa <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8013e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e3:	89 02                	mov    %eax,(%edx)
	return 0;
  8013e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ea:	5d                   	pop    %ebp
  8013eb:	c3                   	ret    
		return -E_INVAL;
  8013ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013f1:	eb f7                	jmp    8013ea <fd_lookup+0x3d>
		return -E_INVAL;
  8013f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013f8:	eb f0                	jmp    8013ea <fd_lookup+0x3d>
  8013fa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013ff:	eb e9                	jmp    8013ea <fd_lookup+0x3d>

00801401 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801401:	f3 0f 1e fb          	endbr32 
  801405:	55                   	push   %ebp
  801406:	89 e5                	mov    %esp,%ebp
  801408:	83 ec 08             	sub    $0x8,%esp
  80140b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80140e:	ba 00 00 00 00       	mov    $0x0,%edx
  801413:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801418:	39 08                	cmp    %ecx,(%eax)
  80141a:	74 38                	je     801454 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  80141c:	83 c2 01             	add    $0x1,%edx
  80141f:	8b 04 95 b8 2e 80 00 	mov    0x802eb8(,%edx,4),%eax
  801426:	85 c0                	test   %eax,%eax
  801428:	75 ee                	jne    801418 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80142a:	a1 08 40 80 00       	mov    0x804008,%eax
  80142f:	8b 40 48             	mov    0x48(%eax),%eax
  801432:	83 ec 04             	sub    $0x4,%esp
  801435:	51                   	push   %ecx
  801436:	50                   	push   %eax
  801437:	68 3c 2e 80 00       	push   $0x802e3c
  80143c:	e8 e2 ee ff ff       	call   800323 <cprintf>
	*dev = 0;
  801441:	8b 45 0c             	mov    0xc(%ebp),%eax
  801444:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80144a:	83 c4 10             	add    $0x10,%esp
  80144d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801452:	c9                   	leave  
  801453:	c3                   	ret    
			*dev = devtab[i];
  801454:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801457:	89 01                	mov    %eax,(%ecx)
			return 0;
  801459:	b8 00 00 00 00       	mov    $0x0,%eax
  80145e:	eb f2                	jmp    801452 <dev_lookup+0x51>

00801460 <fd_close>:
{
  801460:	f3 0f 1e fb          	endbr32 
  801464:	55                   	push   %ebp
  801465:	89 e5                	mov    %esp,%ebp
  801467:	57                   	push   %edi
  801468:	56                   	push   %esi
  801469:	53                   	push   %ebx
  80146a:	83 ec 24             	sub    $0x24,%esp
  80146d:	8b 75 08             	mov    0x8(%ebp),%esi
  801470:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801473:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801476:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801477:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80147d:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801480:	50                   	push   %eax
  801481:	e8 27 ff ff ff       	call   8013ad <fd_lookup>
  801486:	89 c3                	mov    %eax,%ebx
  801488:	83 c4 10             	add    $0x10,%esp
  80148b:	85 c0                	test   %eax,%eax
  80148d:	78 05                	js     801494 <fd_close+0x34>
	    || fd != fd2)
  80148f:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801492:	74 16                	je     8014aa <fd_close+0x4a>
		return (must_exist ? r : 0);
  801494:	89 f8                	mov    %edi,%eax
  801496:	84 c0                	test   %al,%al
  801498:	b8 00 00 00 00       	mov    $0x0,%eax
  80149d:	0f 44 d8             	cmove  %eax,%ebx
}
  8014a0:	89 d8                	mov    %ebx,%eax
  8014a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014a5:	5b                   	pop    %ebx
  8014a6:	5e                   	pop    %esi
  8014a7:	5f                   	pop    %edi
  8014a8:	5d                   	pop    %ebp
  8014a9:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8014aa:	83 ec 08             	sub    $0x8,%esp
  8014ad:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8014b0:	50                   	push   %eax
  8014b1:	ff 36                	pushl  (%esi)
  8014b3:	e8 49 ff ff ff       	call   801401 <dev_lookup>
  8014b8:	89 c3                	mov    %eax,%ebx
  8014ba:	83 c4 10             	add    $0x10,%esp
  8014bd:	85 c0                	test   %eax,%eax
  8014bf:	78 1a                	js     8014db <fd_close+0x7b>
		if (dev->dev_close)
  8014c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014c4:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8014c7:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8014cc:	85 c0                	test   %eax,%eax
  8014ce:	74 0b                	je     8014db <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8014d0:	83 ec 0c             	sub    $0xc,%esp
  8014d3:	56                   	push   %esi
  8014d4:	ff d0                	call   *%eax
  8014d6:	89 c3                	mov    %eax,%ebx
  8014d8:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8014db:	83 ec 08             	sub    $0x8,%esp
  8014de:	56                   	push   %esi
  8014df:	6a 00                	push   $0x0
  8014e1:	e8 16 f9 ff ff       	call   800dfc <sys_page_unmap>
	return r;
  8014e6:	83 c4 10             	add    $0x10,%esp
  8014e9:	eb b5                	jmp    8014a0 <fd_close+0x40>

008014eb <close>:

int
close(int fdnum)
{
  8014eb:	f3 0f 1e fb          	endbr32 
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
  8014f2:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f8:	50                   	push   %eax
  8014f9:	ff 75 08             	pushl  0x8(%ebp)
  8014fc:	e8 ac fe ff ff       	call   8013ad <fd_lookup>
  801501:	83 c4 10             	add    $0x10,%esp
  801504:	85 c0                	test   %eax,%eax
  801506:	79 02                	jns    80150a <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801508:	c9                   	leave  
  801509:	c3                   	ret    
		return fd_close(fd, 1);
  80150a:	83 ec 08             	sub    $0x8,%esp
  80150d:	6a 01                	push   $0x1
  80150f:	ff 75 f4             	pushl  -0xc(%ebp)
  801512:	e8 49 ff ff ff       	call   801460 <fd_close>
  801517:	83 c4 10             	add    $0x10,%esp
  80151a:	eb ec                	jmp    801508 <close+0x1d>

0080151c <close_all>:

void
close_all(void)
{
  80151c:	f3 0f 1e fb          	endbr32 
  801520:	55                   	push   %ebp
  801521:	89 e5                	mov    %esp,%ebp
  801523:	53                   	push   %ebx
  801524:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801527:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80152c:	83 ec 0c             	sub    $0xc,%esp
  80152f:	53                   	push   %ebx
  801530:	e8 b6 ff ff ff       	call   8014eb <close>
	for (i = 0; i < MAXFD; i++)
  801535:	83 c3 01             	add    $0x1,%ebx
  801538:	83 c4 10             	add    $0x10,%esp
  80153b:	83 fb 20             	cmp    $0x20,%ebx
  80153e:	75 ec                	jne    80152c <close_all+0x10>
}
  801540:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801543:	c9                   	leave  
  801544:	c3                   	ret    

00801545 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801545:	f3 0f 1e fb          	endbr32 
  801549:	55                   	push   %ebp
  80154a:	89 e5                	mov    %esp,%ebp
  80154c:	57                   	push   %edi
  80154d:	56                   	push   %esi
  80154e:	53                   	push   %ebx
  80154f:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801552:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801555:	50                   	push   %eax
  801556:	ff 75 08             	pushl  0x8(%ebp)
  801559:	e8 4f fe ff ff       	call   8013ad <fd_lookup>
  80155e:	89 c3                	mov    %eax,%ebx
  801560:	83 c4 10             	add    $0x10,%esp
  801563:	85 c0                	test   %eax,%eax
  801565:	0f 88 81 00 00 00    	js     8015ec <dup+0xa7>
		return r;
	close(newfdnum);
  80156b:	83 ec 0c             	sub    $0xc,%esp
  80156e:	ff 75 0c             	pushl  0xc(%ebp)
  801571:	e8 75 ff ff ff       	call   8014eb <close>

	newfd = INDEX2FD(newfdnum);
  801576:	8b 75 0c             	mov    0xc(%ebp),%esi
  801579:	c1 e6 0c             	shl    $0xc,%esi
  80157c:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801582:	83 c4 04             	add    $0x4,%esp
  801585:	ff 75 e4             	pushl  -0x1c(%ebp)
  801588:	e8 af fd ff ff       	call   80133c <fd2data>
  80158d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80158f:	89 34 24             	mov    %esi,(%esp)
  801592:	e8 a5 fd ff ff       	call   80133c <fd2data>
  801597:	83 c4 10             	add    $0x10,%esp
  80159a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80159c:	89 d8                	mov    %ebx,%eax
  80159e:	c1 e8 16             	shr    $0x16,%eax
  8015a1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015a8:	a8 01                	test   $0x1,%al
  8015aa:	74 11                	je     8015bd <dup+0x78>
  8015ac:	89 d8                	mov    %ebx,%eax
  8015ae:	c1 e8 0c             	shr    $0xc,%eax
  8015b1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8015b8:	f6 c2 01             	test   $0x1,%dl
  8015bb:	75 39                	jne    8015f6 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015bd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015c0:	89 d0                	mov    %edx,%eax
  8015c2:	c1 e8 0c             	shr    $0xc,%eax
  8015c5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015cc:	83 ec 0c             	sub    $0xc,%esp
  8015cf:	25 07 0e 00 00       	and    $0xe07,%eax
  8015d4:	50                   	push   %eax
  8015d5:	56                   	push   %esi
  8015d6:	6a 00                	push   $0x0
  8015d8:	52                   	push   %edx
  8015d9:	6a 00                	push   $0x0
  8015db:	e8 d6 f7 ff ff       	call   800db6 <sys_page_map>
  8015e0:	89 c3                	mov    %eax,%ebx
  8015e2:	83 c4 20             	add    $0x20,%esp
  8015e5:	85 c0                	test   %eax,%eax
  8015e7:	78 31                	js     80161a <dup+0xd5>
		goto err;

	return newfdnum;
  8015e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8015ec:	89 d8                	mov    %ebx,%eax
  8015ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015f1:	5b                   	pop    %ebx
  8015f2:	5e                   	pop    %esi
  8015f3:	5f                   	pop    %edi
  8015f4:	5d                   	pop    %ebp
  8015f5:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015f6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015fd:	83 ec 0c             	sub    $0xc,%esp
  801600:	25 07 0e 00 00       	and    $0xe07,%eax
  801605:	50                   	push   %eax
  801606:	57                   	push   %edi
  801607:	6a 00                	push   $0x0
  801609:	53                   	push   %ebx
  80160a:	6a 00                	push   $0x0
  80160c:	e8 a5 f7 ff ff       	call   800db6 <sys_page_map>
  801611:	89 c3                	mov    %eax,%ebx
  801613:	83 c4 20             	add    $0x20,%esp
  801616:	85 c0                	test   %eax,%eax
  801618:	79 a3                	jns    8015bd <dup+0x78>
	sys_page_unmap(0, newfd);
  80161a:	83 ec 08             	sub    $0x8,%esp
  80161d:	56                   	push   %esi
  80161e:	6a 00                	push   $0x0
  801620:	e8 d7 f7 ff ff       	call   800dfc <sys_page_unmap>
	sys_page_unmap(0, nva);
  801625:	83 c4 08             	add    $0x8,%esp
  801628:	57                   	push   %edi
  801629:	6a 00                	push   $0x0
  80162b:	e8 cc f7 ff ff       	call   800dfc <sys_page_unmap>
	return r;
  801630:	83 c4 10             	add    $0x10,%esp
  801633:	eb b7                	jmp    8015ec <dup+0xa7>

00801635 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801635:	f3 0f 1e fb          	endbr32 
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
  80163c:	53                   	push   %ebx
  80163d:	83 ec 1c             	sub    $0x1c,%esp
  801640:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801643:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801646:	50                   	push   %eax
  801647:	53                   	push   %ebx
  801648:	e8 60 fd ff ff       	call   8013ad <fd_lookup>
  80164d:	83 c4 10             	add    $0x10,%esp
  801650:	85 c0                	test   %eax,%eax
  801652:	78 3f                	js     801693 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801654:	83 ec 08             	sub    $0x8,%esp
  801657:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80165a:	50                   	push   %eax
  80165b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80165e:	ff 30                	pushl  (%eax)
  801660:	e8 9c fd ff ff       	call   801401 <dev_lookup>
  801665:	83 c4 10             	add    $0x10,%esp
  801668:	85 c0                	test   %eax,%eax
  80166a:	78 27                	js     801693 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80166c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80166f:	8b 42 08             	mov    0x8(%edx),%eax
  801672:	83 e0 03             	and    $0x3,%eax
  801675:	83 f8 01             	cmp    $0x1,%eax
  801678:	74 1e                	je     801698 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80167a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167d:	8b 40 08             	mov    0x8(%eax),%eax
  801680:	85 c0                	test   %eax,%eax
  801682:	74 35                	je     8016b9 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801684:	83 ec 04             	sub    $0x4,%esp
  801687:	ff 75 10             	pushl  0x10(%ebp)
  80168a:	ff 75 0c             	pushl  0xc(%ebp)
  80168d:	52                   	push   %edx
  80168e:	ff d0                	call   *%eax
  801690:	83 c4 10             	add    $0x10,%esp
}
  801693:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801696:	c9                   	leave  
  801697:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801698:	a1 08 40 80 00       	mov    0x804008,%eax
  80169d:	8b 40 48             	mov    0x48(%eax),%eax
  8016a0:	83 ec 04             	sub    $0x4,%esp
  8016a3:	53                   	push   %ebx
  8016a4:	50                   	push   %eax
  8016a5:	68 7d 2e 80 00       	push   $0x802e7d
  8016aa:	e8 74 ec ff ff       	call   800323 <cprintf>
		return -E_INVAL;
  8016af:	83 c4 10             	add    $0x10,%esp
  8016b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016b7:	eb da                	jmp    801693 <read+0x5e>
		return -E_NOT_SUPP;
  8016b9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016be:	eb d3                	jmp    801693 <read+0x5e>

008016c0 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8016c0:	f3 0f 1e fb          	endbr32 
  8016c4:	55                   	push   %ebp
  8016c5:	89 e5                	mov    %esp,%ebp
  8016c7:	57                   	push   %edi
  8016c8:	56                   	push   %esi
  8016c9:	53                   	push   %ebx
  8016ca:	83 ec 0c             	sub    $0xc,%esp
  8016cd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016d0:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016d8:	eb 02                	jmp    8016dc <readn+0x1c>
  8016da:	01 c3                	add    %eax,%ebx
  8016dc:	39 f3                	cmp    %esi,%ebx
  8016de:	73 21                	jae    801701 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016e0:	83 ec 04             	sub    $0x4,%esp
  8016e3:	89 f0                	mov    %esi,%eax
  8016e5:	29 d8                	sub    %ebx,%eax
  8016e7:	50                   	push   %eax
  8016e8:	89 d8                	mov    %ebx,%eax
  8016ea:	03 45 0c             	add    0xc(%ebp),%eax
  8016ed:	50                   	push   %eax
  8016ee:	57                   	push   %edi
  8016ef:	e8 41 ff ff ff       	call   801635 <read>
		if (m < 0)
  8016f4:	83 c4 10             	add    $0x10,%esp
  8016f7:	85 c0                	test   %eax,%eax
  8016f9:	78 04                	js     8016ff <readn+0x3f>
			return m;
		if (m == 0)
  8016fb:	75 dd                	jne    8016da <readn+0x1a>
  8016fd:	eb 02                	jmp    801701 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016ff:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801701:	89 d8                	mov    %ebx,%eax
  801703:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801706:	5b                   	pop    %ebx
  801707:	5e                   	pop    %esi
  801708:	5f                   	pop    %edi
  801709:	5d                   	pop    %ebp
  80170a:	c3                   	ret    

0080170b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80170b:	f3 0f 1e fb          	endbr32 
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
  801712:	53                   	push   %ebx
  801713:	83 ec 1c             	sub    $0x1c,%esp
  801716:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801719:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80171c:	50                   	push   %eax
  80171d:	53                   	push   %ebx
  80171e:	e8 8a fc ff ff       	call   8013ad <fd_lookup>
  801723:	83 c4 10             	add    $0x10,%esp
  801726:	85 c0                	test   %eax,%eax
  801728:	78 3a                	js     801764 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80172a:	83 ec 08             	sub    $0x8,%esp
  80172d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801730:	50                   	push   %eax
  801731:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801734:	ff 30                	pushl  (%eax)
  801736:	e8 c6 fc ff ff       	call   801401 <dev_lookup>
  80173b:	83 c4 10             	add    $0x10,%esp
  80173e:	85 c0                	test   %eax,%eax
  801740:	78 22                	js     801764 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801742:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801745:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801749:	74 1e                	je     801769 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80174b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80174e:	8b 52 0c             	mov    0xc(%edx),%edx
  801751:	85 d2                	test   %edx,%edx
  801753:	74 35                	je     80178a <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801755:	83 ec 04             	sub    $0x4,%esp
  801758:	ff 75 10             	pushl  0x10(%ebp)
  80175b:	ff 75 0c             	pushl  0xc(%ebp)
  80175e:	50                   	push   %eax
  80175f:	ff d2                	call   *%edx
  801761:	83 c4 10             	add    $0x10,%esp
}
  801764:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801767:	c9                   	leave  
  801768:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801769:	a1 08 40 80 00       	mov    0x804008,%eax
  80176e:	8b 40 48             	mov    0x48(%eax),%eax
  801771:	83 ec 04             	sub    $0x4,%esp
  801774:	53                   	push   %ebx
  801775:	50                   	push   %eax
  801776:	68 99 2e 80 00       	push   $0x802e99
  80177b:	e8 a3 eb ff ff       	call   800323 <cprintf>
		return -E_INVAL;
  801780:	83 c4 10             	add    $0x10,%esp
  801783:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801788:	eb da                	jmp    801764 <write+0x59>
		return -E_NOT_SUPP;
  80178a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80178f:	eb d3                	jmp    801764 <write+0x59>

00801791 <seek>:

int
seek(int fdnum, off_t offset)
{
  801791:	f3 0f 1e fb          	endbr32 
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
  801798:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80179b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80179e:	50                   	push   %eax
  80179f:	ff 75 08             	pushl  0x8(%ebp)
  8017a2:	e8 06 fc ff ff       	call   8013ad <fd_lookup>
  8017a7:	83 c4 10             	add    $0x10,%esp
  8017aa:	85 c0                	test   %eax,%eax
  8017ac:	78 0e                	js     8017bc <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8017ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b4:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8017b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017bc:	c9                   	leave  
  8017bd:	c3                   	ret    

008017be <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8017be:	f3 0f 1e fb          	endbr32 
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
  8017c5:	53                   	push   %ebx
  8017c6:	83 ec 1c             	sub    $0x1c,%esp
  8017c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017cc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017cf:	50                   	push   %eax
  8017d0:	53                   	push   %ebx
  8017d1:	e8 d7 fb ff ff       	call   8013ad <fd_lookup>
  8017d6:	83 c4 10             	add    $0x10,%esp
  8017d9:	85 c0                	test   %eax,%eax
  8017db:	78 37                	js     801814 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017dd:	83 ec 08             	sub    $0x8,%esp
  8017e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017e3:	50                   	push   %eax
  8017e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e7:	ff 30                	pushl  (%eax)
  8017e9:	e8 13 fc ff ff       	call   801401 <dev_lookup>
  8017ee:	83 c4 10             	add    $0x10,%esp
  8017f1:	85 c0                	test   %eax,%eax
  8017f3:	78 1f                	js     801814 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017fc:	74 1b                	je     801819 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8017fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801801:	8b 52 18             	mov    0x18(%edx),%edx
  801804:	85 d2                	test   %edx,%edx
  801806:	74 32                	je     80183a <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801808:	83 ec 08             	sub    $0x8,%esp
  80180b:	ff 75 0c             	pushl  0xc(%ebp)
  80180e:	50                   	push   %eax
  80180f:	ff d2                	call   *%edx
  801811:	83 c4 10             	add    $0x10,%esp
}
  801814:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801817:	c9                   	leave  
  801818:	c3                   	ret    
			thisenv->env_id, fdnum);
  801819:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80181e:	8b 40 48             	mov    0x48(%eax),%eax
  801821:	83 ec 04             	sub    $0x4,%esp
  801824:	53                   	push   %ebx
  801825:	50                   	push   %eax
  801826:	68 5c 2e 80 00       	push   $0x802e5c
  80182b:	e8 f3 ea ff ff       	call   800323 <cprintf>
		return -E_INVAL;
  801830:	83 c4 10             	add    $0x10,%esp
  801833:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801838:	eb da                	jmp    801814 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80183a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80183f:	eb d3                	jmp    801814 <ftruncate+0x56>

00801841 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801841:	f3 0f 1e fb          	endbr32 
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
  801848:	53                   	push   %ebx
  801849:	83 ec 1c             	sub    $0x1c,%esp
  80184c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80184f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801852:	50                   	push   %eax
  801853:	ff 75 08             	pushl  0x8(%ebp)
  801856:	e8 52 fb ff ff       	call   8013ad <fd_lookup>
  80185b:	83 c4 10             	add    $0x10,%esp
  80185e:	85 c0                	test   %eax,%eax
  801860:	78 4b                	js     8018ad <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801862:	83 ec 08             	sub    $0x8,%esp
  801865:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801868:	50                   	push   %eax
  801869:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80186c:	ff 30                	pushl  (%eax)
  80186e:	e8 8e fb ff ff       	call   801401 <dev_lookup>
  801873:	83 c4 10             	add    $0x10,%esp
  801876:	85 c0                	test   %eax,%eax
  801878:	78 33                	js     8018ad <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80187a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80187d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801881:	74 2f                	je     8018b2 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801883:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801886:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80188d:	00 00 00 
	stat->st_isdir = 0;
  801890:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801897:	00 00 00 
	stat->st_dev = dev;
  80189a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018a0:	83 ec 08             	sub    $0x8,%esp
  8018a3:	53                   	push   %ebx
  8018a4:	ff 75 f0             	pushl  -0x10(%ebp)
  8018a7:	ff 50 14             	call   *0x14(%eax)
  8018aa:	83 c4 10             	add    $0x10,%esp
}
  8018ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    
		return -E_NOT_SUPP;
  8018b2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018b7:	eb f4                	jmp    8018ad <fstat+0x6c>

008018b9 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8018b9:	f3 0f 1e fb          	endbr32 
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
  8018c0:	56                   	push   %esi
  8018c1:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018c2:	83 ec 08             	sub    $0x8,%esp
  8018c5:	6a 00                	push   $0x0
  8018c7:	ff 75 08             	pushl  0x8(%ebp)
  8018ca:	e8 fb 01 00 00       	call   801aca <open>
  8018cf:	89 c3                	mov    %eax,%ebx
  8018d1:	83 c4 10             	add    $0x10,%esp
  8018d4:	85 c0                	test   %eax,%eax
  8018d6:	78 1b                	js     8018f3 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8018d8:	83 ec 08             	sub    $0x8,%esp
  8018db:	ff 75 0c             	pushl  0xc(%ebp)
  8018de:	50                   	push   %eax
  8018df:	e8 5d ff ff ff       	call   801841 <fstat>
  8018e4:	89 c6                	mov    %eax,%esi
	close(fd);
  8018e6:	89 1c 24             	mov    %ebx,(%esp)
  8018e9:	e8 fd fb ff ff       	call   8014eb <close>
	return r;
  8018ee:	83 c4 10             	add    $0x10,%esp
  8018f1:	89 f3                	mov    %esi,%ebx
}
  8018f3:	89 d8                	mov    %ebx,%eax
  8018f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018f8:	5b                   	pop    %ebx
  8018f9:	5e                   	pop    %esi
  8018fa:	5d                   	pop    %ebp
  8018fb:	c3                   	ret    

008018fc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
  8018ff:	56                   	push   %esi
  801900:	53                   	push   %ebx
  801901:	89 c6                	mov    %eax,%esi
  801903:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801905:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80190c:	74 27                	je     801935 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80190e:	6a 07                	push   $0x7
  801910:	68 00 50 80 00       	push   $0x805000
  801915:	56                   	push   %esi
  801916:	ff 35 00 40 80 00    	pushl  0x804000
  80191c:	e8 27 0d 00 00       	call   802648 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801921:	83 c4 0c             	add    $0xc,%esp
  801924:	6a 00                	push   $0x0
  801926:	53                   	push   %ebx
  801927:	6a 00                	push   $0x0
  801929:	e8 95 0c 00 00       	call   8025c3 <ipc_recv>
}
  80192e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801931:	5b                   	pop    %ebx
  801932:	5e                   	pop    %esi
  801933:	5d                   	pop    %ebp
  801934:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801935:	83 ec 0c             	sub    $0xc,%esp
  801938:	6a 01                	push   $0x1
  80193a:	e8 61 0d 00 00       	call   8026a0 <ipc_find_env>
  80193f:	a3 00 40 80 00       	mov    %eax,0x804000
  801944:	83 c4 10             	add    $0x10,%esp
  801947:	eb c5                	jmp    80190e <fsipc+0x12>

00801949 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801949:	f3 0f 1e fb          	endbr32 
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
  801950:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	8b 40 0c             	mov    0xc(%eax),%eax
  801959:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80195e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801961:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801966:	ba 00 00 00 00       	mov    $0x0,%edx
  80196b:	b8 02 00 00 00       	mov    $0x2,%eax
  801970:	e8 87 ff ff ff       	call   8018fc <fsipc>
}
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <devfile_flush>:
{
  801977:	f3 0f 1e fb          	endbr32 
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
  80197e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801981:	8b 45 08             	mov    0x8(%ebp),%eax
  801984:	8b 40 0c             	mov    0xc(%eax),%eax
  801987:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80198c:	ba 00 00 00 00       	mov    $0x0,%edx
  801991:	b8 06 00 00 00       	mov    $0x6,%eax
  801996:	e8 61 ff ff ff       	call   8018fc <fsipc>
}
  80199b:	c9                   	leave  
  80199c:	c3                   	ret    

0080199d <devfile_stat>:
{
  80199d:	f3 0f 1e fb          	endbr32 
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
  8019a4:	53                   	push   %ebx
  8019a5:	83 ec 04             	sub    $0x4,%esp
  8019a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8019ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8019b1:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8019b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8019bb:	b8 05 00 00 00       	mov    $0x5,%eax
  8019c0:	e8 37 ff ff ff       	call   8018fc <fsipc>
  8019c5:	85 c0                	test   %eax,%eax
  8019c7:	78 2c                	js     8019f5 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019c9:	83 ec 08             	sub    $0x8,%esp
  8019cc:	68 00 50 80 00       	push   $0x805000
  8019d1:	53                   	push   %ebx
  8019d2:	e8 56 ef ff ff       	call   80092d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019d7:	a1 80 50 80 00       	mov    0x805080,%eax
  8019dc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019e2:	a1 84 50 80 00       	mov    0x805084,%eax
  8019e7:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8019ed:	83 c4 10             	add    $0x10,%esp
  8019f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <devfile_write>:
{
  8019fa:	f3 0f 1e fb          	endbr32 
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
  801a01:	83 ec 0c             	sub    $0xc,%esp
  801a04:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a07:	8b 55 08             	mov    0x8(%ebp),%edx
  801a0a:	8b 52 0c             	mov    0xc(%edx),%edx
  801a0d:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801a13:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801a18:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801a1d:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  801a20:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801a25:	50                   	push   %eax
  801a26:	ff 75 0c             	pushl  0xc(%ebp)
  801a29:	68 08 50 80 00       	push   $0x805008
  801a2e:	e8 b0 f0 ff ff       	call   800ae3 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801a33:	ba 00 00 00 00       	mov    $0x0,%edx
  801a38:	b8 04 00 00 00       	mov    $0x4,%eax
  801a3d:	e8 ba fe ff ff       	call   8018fc <fsipc>
}
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <devfile_read>:
{
  801a44:	f3 0f 1e fb          	endbr32 
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
  801a4b:	56                   	push   %esi
  801a4c:	53                   	push   %ebx
  801a4d:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	8b 40 0c             	mov    0xc(%eax),%eax
  801a56:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a5b:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a61:	ba 00 00 00 00       	mov    $0x0,%edx
  801a66:	b8 03 00 00 00       	mov    $0x3,%eax
  801a6b:	e8 8c fe ff ff       	call   8018fc <fsipc>
  801a70:	89 c3                	mov    %eax,%ebx
  801a72:	85 c0                	test   %eax,%eax
  801a74:	78 1f                	js     801a95 <devfile_read+0x51>
	assert(r <= n);
  801a76:	39 f0                	cmp    %esi,%eax
  801a78:	77 24                	ja     801a9e <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801a7a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a7f:	7f 33                	jg     801ab4 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a81:	83 ec 04             	sub    $0x4,%esp
  801a84:	50                   	push   %eax
  801a85:	68 00 50 80 00       	push   $0x805000
  801a8a:	ff 75 0c             	pushl  0xc(%ebp)
  801a8d:	e8 51 f0 ff ff       	call   800ae3 <memmove>
	return r;
  801a92:	83 c4 10             	add    $0x10,%esp
}
  801a95:	89 d8                	mov    %ebx,%eax
  801a97:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a9a:	5b                   	pop    %ebx
  801a9b:	5e                   	pop    %esi
  801a9c:	5d                   	pop    %ebp
  801a9d:	c3                   	ret    
	assert(r <= n);
  801a9e:	68 cc 2e 80 00       	push   $0x802ecc
  801aa3:	68 d3 2e 80 00       	push   $0x802ed3
  801aa8:	6a 7c                	push   $0x7c
  801aaa:	68 e8 2e 80 00       	push   $0x802ee8
  801aaf:	e8 88 e7 ff ff       	call   80023c <_panic>
	assert(r <= PGSIZE);
  801ab4:	68 f3 2e 80 00       	push   $0x802ef3
  801ab9:	68 d3 2e 80 00       	push   $0x802ed3
  801abe:	6a 7d                	push   $0x7d
  801ac0:	68 e8 2e 80 00       	push   $0x802ee8
  801ac5:	e8 72 e7 ff ff       	call   80023c <_panic>

00801aca <open>:
{
  801aca:	f3 0f 1e fb          	endbr32 
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
  801ad1:	56                   	push   %esi
  801ad2:	53                   	push   %ebx
  801ad3:	83 ec 1c             	sub    $0x1c,%esp
  801ad6:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801ad9:	56                   	push   %esi
  801ada:	e8 0b ee ff ff       	call   8008ea <strlen>
  801adf:	83 c4 10             	add    $0x10,%esp
  801ae2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ae7:	7f 6c                	jg     801b55 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801ae9:	83 ec 0c             	sub    $0xc,%esp
  801aec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aef:	50                   	push   %eax
  801af0:	e8 62 f8 ff ff       	call   801357 <fd_alloc>
  801af5:	89 c3                	mov    %eax,%ebx
  801af7:	83 c4 10             	add    $0x10,%esp
  801afa:	85 c0                	test   %eax,%eax
  801afc:	78 3c                	js     801b3a <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801afe:	83 ec 08             	sub    $0x8,%esp
  801b01:	56                   	push   %esi
  801b02:	68 00 50 80 00       	push   $0x805000
  801b07:	e8 21 ee ff ff       	call   80092d <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b0f:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b17:	b8 01 00 00 00       	mov    $0x1,%eax
  801b1c:	e8 db fd ff ff       	call   8018fc <fsipc>
  801b21:	89 c3                	mov    %eax,%ebx
  801b23:	83 c4 10             	add    $0x10,%esp
  801b26:	85 c0                	test   %eax,%eax
  801b28:	78 19                	js     801b43 <open+0x79>
	return fd2num(fd);
  801b2a:	83 ec 0c             	sub    $0xc,%esp
  801b2d:	ff 75 f4             	pushl  -0xc(%ebp)
  801b30:	e8 f3 f7 ff ff       	call   801328 <fd2num>
  801b35:	89 c3                	mov    %eax,%ebx
  801b37:	83 c4 10             	add    $0x10,%esp
}
  801b3a:	89 d8                	mov    %ebx,%eax
  801b3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b3f:	5b                   	pop    %ebx
  801b40:	5e                   	pop    %esi
  801b41:	5d                   	pop    %ebp
  801b42:	c3                   	ret    
		fd_close(fd, 0);
  801b43:	83 ec 08             	sub    $0x8,%esp
  801b46:	6a 00                	push   $0x0
  801b48:	ff 75 f4             	pushl  -0xc(%ebp)
  801b4b:	e8 10 f9 ff ff       	call   801460 <fd_close>
		return r;
  801b50:	83 c4 10             	add    $0x10,%esp
  801b53:	eb e5                	jmp    801b3a <open+0x70>
		return -E_BAD_PATH;
  801b55:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b5a:	eb de                	jmp    801b3a <open+0x70>

00801b5c <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b5c:	f3 0f 1e fb          	endbr32 
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
  801b63:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b66:	ba 00 00 00 00       	mov    $0x0,%edx
  801b6b:	b8 08 00 00 00       	mov    $0x8,%eax
  801b70:	e8 87 fd ff ff       	call   8018fc <fsipc>
}
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801b77:	f3 0f 1e fb          	endbr32 
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
  801b7e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801b81:	68 ff 2e 80 00       	push   $0x802eff
  801b86:	ff 75 0c             	pushl  0xc(%ebp)
  801b89:	e8 9f ed ff ff       	call   80092d <strcpy>
	return 0;
}
  801b8e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b93:	c9                   	leave  
  801b94:	c3                   	ret    

00801b95 <devsock_close>:
{
  801b95:	f3 0f 1e fb          	endbr32 
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
  801b9c:	53                   	push   %ebx
  801b9d:	83 ec 10             	sub    $0x10,%esp
  801ba0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801ba3:	53                   	push   %ebx
  801ba4:	e8 34 0b 00 00       	call   8026dd <pageref>
  801ba9:	89 c2                	mov    %eax,%edx
  801bab:	83 c4 10             	add    $0x10,%esp
		return 0;
  801bae:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801bb3:	83 fa 01             	cmp    $0x1,%edx
  801bb6:	74 05                	je     801bbd <devsock_close+0x28>
}
  801bb8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801bbd:	83 ec 0c             	sub    $0xc,%esp
  801bc0:	ff 73 0c             	pushl  0xc(%ebx)
  801bc3:	e8 e3 02 00 00       	call   801eab <nsipc_close>
  801bc8:	83 c4 10             	add    $0x10,%esp
  801bcb:	eb eb                	jmp    801bb8 <devsock_close+0x23>

00801bcd <devsock_write>:
{
  801bcd:	f3 0f 1e fb          	endbr32 
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
  801bd4:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801bd7:	6a 00                	push   $0x0
  801bd9:	ff 75 10             	pushl  0x10(%ebp)
  801bdc:	ff 75 0c             	pushl  0xc(%ebp)
  801bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801be2:	ff 70 0c             	pushl  0xc(%eax)
  801be5:	e8 b5 03 00 00       	call   801f9f <nsipc_send>
}
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <devsock_read>:
{
  801bec:	f3 0f 1e fb          	endbr32 
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
  801bf3:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801bf6:	6a 00                	push   $0x0
  801bf8:	ff 75 10             	pushl  0x10(%ebp)
  801bfb:	ff 75 0c             	pushl  0xc(%ebp)
  801bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801c01:	ff 70 0c             	pushl  0xc(%eax)
  801c04:	e8 1f 03 00 00       	call   801f28 <nsipc_recv>
}
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    

00801c0b <fd2sockid>:
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
  801c0e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801c11:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801c14:	52                   	push   %edx
  801c15:	50                   	push   %eax
  801c16:	e8 92 f7 ff ff       	call   8013ad <fd_lookup>
  801c1b:	83 c4 10             	add    $0x10,%esp
  801c1e:	85 c0                	test   %eax,%eax
  801c20:	78 10                	js     801c32 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c25:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801c2b:	39 08                	cmp    %ecx,(%eax)
  801c2d:	75 05                	jne    801c34 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801c2f:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    
		return -E_NOT_SUPP;
  801c34:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c39:	eb f7                	jmp    801c32 <fd2sockid+0x27>

00801c3b <alloc_sockfd>:
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
  801c3e:	56                   	push   %esi
  801c3f:	53                   	push   %ebx
  801c40:	83 ec 1c             	sub    $0x1c,%esp
  801c43:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801c45:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c48:	50                   	push   %eax
  801c49:	e8 09 f7 ff ff       	call   801357 <fd_alloc>
  801c4e:	89 c3                	mov    %eax,%ebx
  801c50:	83 c4 10             	add    $0x10,%esp
  801c53:	85 c0                	test   %eax,%eax
  801c55:	78 43                	js     801c9a <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801c57:	83 ec 04             	sub    $0x4,%esp
  801c5a:	68 07 04 00 00       	push   $0x407
  801c5f:	ff 75 f4             	pushl  -0xc(%ebp)
  801c62:	6a 00                	push   $0x0
  801c64:	e8 06 f1 ff ff       	call   800d6f <sys_page_alloc>
  801c69:	89 c3                	mov    %eax,%ebx
  801c6b:	83 c4 10             	add    $0x10,%esp
  801c6e:	85 c0                	test   %eax,%eax
  801c70:	78 28                	js     801c9a <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c75:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c7b:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c80:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801c87:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801c8a:	83 ec 0c             	sub    $0xc,%esp
  801c8d:	50                   	push   %eax
  801c8e:	e8 95 f6 ff ff       	call   801328 <fd2num>
  801c93:	89 c3                	mov    %eax,%ebx
  801c95:	83 c4 10             	add    $0x10,%esp
  801c98:	eb 0c                	jmp    801ca6 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801c9a:	83 ec 0c             	sub    $0xc,%esp
  801c9d:	56                   	push   %esi
  801c9e:	e8 08 02 00 00       	call   801eab <nsipc_close>
		return r;
  801ca3:	83 c4 10             	add    $0x10,%esp
}
  801ca6:	89 d8                	mov    %ebx,%eax
  801ca8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cab:	5b                   	pop    %ebx
  801cac:	5e                   	pop    %esi
  801cad:	5d                   	pop    %ebp
  801cae:	c3                   	ret    

00801caf <accept>:
{
  801caf:	f3 0f 1e fb          	endbr32 
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
  801cb6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbc:	e8 4a ff ff ff       	call   801c0b <fd2sockid>
  801cc1:	85 c0                	test   %eax,%eax
  801cc3:	78 1b                	js     801ce0 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801cc5:	83 ec 04             	sub    $0x4,%esp
  801cc8:	ff 75 10             	pushl  0x10(%ebp)
  801ccb:	ff 75 0c             	pushl  0xc(%ebp)
  801cce:	50                   	push   %eax
  801ccf:	e8 22 01 00 00       	call   801df6 <nsipc_accept>
  801cd4:	83 c4 10             	add    $0x10,%esp
  801cd7:	85 c0                	test   %eax,%eax
  801cd9:	78 05                	js     801ce0 <accept+0x31>
	return alloc_sockfd(r);
  801cdb:	e8 5b ff ff ff       	call   801c3b <alloc_sockfd>
}
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <bind>:
{
  801ce2:	f3 0f 1e fb          	endbr32 
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
  801ce9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cec:	8b 45 08             	mov    0x8(%ebp),%eax
  801cef:	e8 17 ff ff ff       	call   801c0b <fd2sockid>
  801cf4:	85 c0                	test   %eax,%eax
  801cf6:	78 12                	js     801d0a <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801cf8:	83 ec 04             	sub    $0x4,%esp
  801cfb:	ff 75 10             	pushl  0x10(%ebp)
  801cfe:	ff 75 0c             	pushl  0xc(%ebp)
  801d01:	50                   	push   %eax
  801d02:	e8 45 01 00 00       	call   801e4c <nsipc_bind>
  801d07:	83 c4 10             	add    $0x10,%esp
}
  801d0a:	c9                   	leave  
  801d0b:	c3                   	ret    

00801d0c <shutdown>:
{
  801d0c:	f3 0f 1e fb          	endbr32 
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
  801d13:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d16:	8b 45 08             	mov    0x8(%ebp),%eax
  801d19:	e8 ed fe ff ff       	call   801c0b <fd2sockid>
  801d1e:	85 c0                	test   %eax,%eax
  801d20:	78 0f                	js     801d31 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801d22:	83 ec 08             	sub    $0x8,%esp
  801d25:	ff 75 0c             	pushl  0xc(%ebp)
  801d28:	50                   	push   %eax
  801d29:	e8 57 01 00 00       	call   801e85 <nsipc_shutdown>
  801d2e:	83 c4 10             	add    $0x10,%esp
}
  801d31:	c9                   	leave  
  801d32:	c3                   	ret    

00801d33 <connect>:
{
  801d33:	f3 0f 1e fb          	endbr32 
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
  801d3a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d40:	e8 c6 fe ff ff       	call   801c0b <fd2sockid>
  801d45:	85 c0                	test   %eax,%eax
  801d47:	78 12                	js     801d5b <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801d49:	83 ec 04             	sub    $0x4,%esp
  801d4c:	ff 75 10             	pushl  0x10(%ebp)
  801d4f:	ff 75 0c             	pushl  0xc(%ebp)
  801d52:	50                   	push   %eax
  801d53:	e8 71 01 00 00       	call   801ec9 <nsipc_connect>
  801d58:	83 c4 10             	add    $0x10,%esp
}
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <listen>:
{
  801d5d:	f3 0f 1e fb          	endbr32 
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
  801d64:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d67:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6a:	e8 9c fe ff ff       	call   801c0b <fd2sockid>
  801d6f:	85 c0                	test   %eax,%eax
  801d71:	78 0f                	js     801d82 <listen+0x25>
	return nsipc_listen(r, backlog);
  801d73:	83 ec 08             	sub    $0x8,%esp
  801d76:	ff 75 0c             	pushl  0xc(%ebp)
  801d79:	50                   	push   %eax
  801d7a:	e8 83 01 00 00       	call   801f02 <nsipc_listen>
  801d7f:	83 c4 10             	add    $0x10,%esp
}
  801d82:	c9                   	leave  
  801d83:	c3                   	ret    

00801d84 <socket>:

int
socket(int domain, int type, int protocol)
{
  801d84:	f3 0f 1e fb          	endbr32 
  801d88:	55                   	push   %ebp
  801d89:	89 e5                	mov    %esp,%ebp
  801d8b:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801d8e:	ff 75 10             	pushl  0x10(%ebp)
  801d91:	ff 75 0c             	pushl  0xc(%ebp)
  801d94:	ff 75 08             	pushl  0x8(%ebp)
  801d97:	e8 65 02 00 00       	call   802001 <nsipc_socket>
  801d9c:	83 c4 10             	add    $0x10,%esp
  801d9f:	85 c0                	test   %eax,%eax
  801da1:	78 05                	js     801da8 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801da3:	e8 93 fe ff ff       	call   801c3b <alloc_sockfd>
}
  801da8:	c9                   	leave  
  801da9:	c3                   	ret    

00801daa <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
  801dad:	53                   	push   %ebx
  801dae:	83 ec 04             	sub    $0x4,%esp
  801db1:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801db3:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801dba:	74 26                	je     801de2 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801dbc:	6a 07                	push   $0x7
  801dbe:	68 00 60 80 00       	push   $0x806000
  801dc3:	53                   	push   %ebx
  801dc4:	ff 35 04 40 80 00    	pushl  0x804004
  801dca:	e8 79 08 00 00       	call   802648 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801dcf:	83 c4 0c             	add    $0xc,%esp
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	e8 e6 07 00 00       	call   8025c3 <ipc_recv>
}
  801ddd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801de0:	c9                   	leave  
  801de1:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801de2:	83 ec 0c             	sub    $0xc,%esp
  801de5:	6a 02                	push   $0x2
  801de7:	e8 b4 08 00 00       	call   8026a0 <ipc_find_env>
  801dec:	a3 04 40 80 00       	mov    %eax,0x804004
  801df1:	83 c4 10             	add    $0x10,%esp
  801df4:	eb c6                	jmp    801dbc <nsipc+0x12>

00801df6 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801df6:	f3 0f 1e fb          	endbr32 
  801dfa:	55                   	push   %ebp
  801dfb:	89 e5                	mov    %esp,%ebp
  801dfd:	56                   	push   %esi
  801dfe:	53                   	push   %ebx
  801dff:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801e02:	8b 45 08             	mov    0x8(%ebp),%eax
  801e05:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801e0a:	8b 06                	mov    (%esi),%eax
  801e0c:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801e11:	b8 01 00 00 00       	mov    $0x1,%eax
  801e16:	e8 8f ff ff ff       	call   801daa <nsipc>
  801e1b:	89 c3                	mov    %eax,%ebx
  801e1d:	85 c0                	test   %eax,%eax
  801e1f:	79 09                	jns    801e2a <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801e21:	89 d8                	mov    %ebx,%eax
  801e23:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e26:	5b                   	pop    %ebx
  801e27:	5e                   	pop    %esi
  801e28:	5d                   	pop    %ebp
  801e29:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801e2a:	83 ec 04             	sub    $0x4,%esp
  801e2d:	ff 35 10 60 80 00    	pushl  0x806010
  801e33:	68 00 60 80 00       	push   $0x806000
  801e38:	ff 75 0c             	pushl  0xc(%ebp)
  801e3b:	e8 a3 ec ff ff       	call   800ae3 <memmove>
		*addrlen = ret->ret_addrlen;
  801e40:	a1 10 60 80 00       	mov    0x806010,%eax
  801e45:	89 06                	mov    %eax,(%esi)
  801e47:	83 c4 10             	add    $0x10,%esp
	return r;
  801e4a:	eb d5                	jmp    801e21 <nsipc_accept+0x2b>

00801e4c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e4c:	f3 0f 1e fb          	endbr32 
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
  801e53:	53                   	push   %ebx
  801e54:	83 ec 08             	sub    $0x8,%esp
  801e57:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801e62:	53                   	push   %ebx
  801e63:	ff 75 0c             	pushl  0xc(%ebp)
  801e66:	68 04 60 80 00       	push   $0x806004
  801e6b:	e8 73 ec ff ff       	call   800ae3 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801e70:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801e76:	b8 02 00 00 00       	mov    $0x2,%eax
  801e7b:	e8 2a ff ff ff       	call   801daa <nsipc>
}
  801e80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e83:	c9                   	leave  
  801e84:	c3                   	ret    

00801e85 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801e85:	f3 0f 1e fb          	endbr32 
  801e89:	55                   	push   %ebp
  801e8a:	89 e5                	mov    %esp,%ebp
  801e8c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e92:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801e97:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e9a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801e9f:	b8 03 00 00 00       	mov    $0x3,%eax
  801ea4:	e8 01 ff ff ff       	call   801daa <nsipc>
}
  801ea9:	c9                   	leave  
  801eaa:	c3                   	ret    

00801eab <nsipc_close>:

int
nsipc_close(int s)
{
  801eab:	f3 0f 1e fb          	endbr32 
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
  801eb2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb8:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801ebd:	b8 04 00 00 00       	mov    $0x4,%eax
  801ec2:	e8 e3 fe ff ff       	call   801daa <nsipc>
}
  801ec7:	c9                   	leave  
  801ec8:	c3                   	ret    

00801ec9 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ec9:	f3 0f 1e fb          	endbr32 
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
  801ed0:	53                   	push   %ebx
  801ed1:	83 ec 08             	sub    $0x8,%esp
  801ed4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eda:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801edf:	53                   	push   %ebx
  801ee0:	ff 75 0c             	pushl  0xc(%ebp)
  801ee3:	68 04 60 80 00       	push   $0x806004
  801ee8:	e8 f6 eb ff ff       	call   800ae3 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801eed:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801ef3:	b8 05 00 00 00       	mov    $0x5,%eax
  801ef8:	e8 ad fe ff ff       	call   801daa <nsipc>
}
  801efd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f00:	c9                   	leave  
  801f01:	c3                   	ret    

00801f02 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801f02:	f3 0f 1e fb          	endbr32 
  801f06:	55                   	push   %ebp
  801f07:	89 e5                	mov    %esp,%ebp
  801f09:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801f14:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f17:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801f1c:	b8 06 00 00 00       	mov    $0x6,%eax
  801f21:	e8 84 fe ff ff       	call   801daa <nsipc>
}
  801f26:	c9                   	leave  
  801f27:	c3                   	ret    

00801f28 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801f28:	f3 0f 1e fb          	endbr32 
  801f2c:	55                   	push   %ebp
  801f2d:	89 e5                	mov    %esp,%ebp
  801f2f:	56                   	push   %esi
  801f30:	53                   	push   %ebx
  801f31:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801f34:	8b 45 08             	mov    0x8(%ebp),%eax
  801f37:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801f3c:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801f42:	8b 45 14             	mov    0x14(%ebp),%eax
  801f45:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801f4a:	b8 07 00 00 00       	mov    $0x7,%eax
  801f4f:	e8 56 fe ff ff       	call   801daa <nsipc>
  801f54:	89 c3                	mov    %eax,%ebx
  801f56:	85 c0                	test   %eax,%eax
  801f58:	78 26                	js     801f80 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801f5a:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801f60:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801f65:	0f 4e c6             	cmovle %esi,%eax
  801f68:	39 c3                	cmp    %eax,%ebx
  801f6a:	7f 1d                	jg     801f89 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801f6c:	83 ec 04             	sub    $0x4,%esp
  801f6f:	53                   	push   %ebx
  801f70:	68 00 60 80 00       	push   $0x806000
  801f75:	ff 75 0c             	pushl  0xc(%ebp)
  801f78:	e8 66 eb ff ff       	call   800ae3 <memmove>
  801f7d:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801f80:	89 d8                	mov    %ebx,%eax
  801f82:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f85:	5b                   	pop    %ebx
  801f86:	5e                   	pop    %esi
  801f87:	5d                   	pop    %ebp
  801f88:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801f89:	68 0b 2f 80 00       	push   $0x802f0b
  801f8e:	68 d3 2e 80 00       	push   $0x802ed3
  801f93:	6a 62                	push   $0x62
  801f95:	68 20 2f 80 00       	push   $0x802f20
  801f9a:	e8 9d e2 ff ff       	call   80023c <_panic>

00801f9f <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801f9f:	f3 0f 1e fb          	endbr32 
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
  801fa6:	53                   	push   %ebx
  801fa7:	83 ec 04             	sub    $0x4,%esp
  801faa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801fad:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb0:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801fb5:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801fbb:	7f 2e                	jg     801feb <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801fbd:	83 ec 04             	sub    $0x4,%esp
  801fc0:	53                   	push   %ebx
  801fc1:	ff 75 0c             	pushl  0xc(%ebp)
  801fc4:	68 0c 60 80 00       	push   $0x80600c
  801fc9:	e8 15 eb ff ff       	call   800ae3 <memmove>
	nsipcbuf.send.req_size = size;
  801fce:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801fd4:	8b 45 14             	mov    0x14(%ebp),%eax
  801fd7:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801fdc:	b8 08 00 00 00       	mov    $0x8,%eax
  801fe1:	e8 c4 fd ff ff       	call   801daa <nsipc>
}
  801fe6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fe9:	c9                   	leave  
  801fea:	c3                   	ret    
	assert(size < 1600);
  801feb:	68 2c 2f 80 00       	push   $0x802f2c
  801ff0:	68 d3 2e 80 00       	push   $0x802ed3
  801ff5:	6a 6d                	push   $0x6d
  801ff7:	68 20 2f 80 00       	push   $0x802f20
  801ffc:	e8 3b e2 ff ff       	call   80023c <_panic>

00802001 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802001:	f3 0f 1e fb          	endbr32 
  802005:	55                   	push   %ebp
  802006:	89 e5                	mov    %esp,%ebp
  802008:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80200b:	8b 45 08             	mov    0x8(%ebp),%eax
  80200e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802013:	8b 45 0c             	mov    0xc(%ebp),%eax
  802016:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80201b:	8b 45 10             	mov    0x10(%ebp),%eax
  80201e:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802023:	b8 09 00 00 00       	mov    $0x9,%eax
  802028:	e8 7d fd ff ff       	call   801daa <nsipc>
}
  80202d:	c9                   	leave  
  80202e:	c3                   	ret    

0080202f <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80202f:	f3 0f 1e fb          	endbr32 
  802033:	55                   	push   %ebp
  802034:	89 e5                	mov    %esp,%ebp
  802036:	56                   	push   %esi
  802037:	53                   	push   %ebx
  802038:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80203b:	83 ec 0c             	sub    $0xc,%esp
  80203e:	ff 75 08             	pushl  0x8(%ebp)
  802041:	e8 f6 f2 ff ff       	call   80133c <fd2data>
  802046:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802048:	83 c4 08             	add    $0x8,%esp
  80204b:	68 38 2f 80 00       	push   $0x802f38
  802050:	53                   	push   %ebx
  802051:	e8 d7 e8 ff ff       	call   80092d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802056:	8b 46 04             	mov    0x4(%esi),%eax
  802059:	2b 06                	sub    (%esi),%eax
  80205b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802061:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802068:	00 00 00 
	stat->st_dev = &devpipe;
  80206b:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  802072:	30 80 00 
	return 0;
}
  802075:	b8 00 00 00 00       	mov    $0x0,%eax
  80207a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80207d:	5b                   	pop    %ebx
  80207e:	5e                   	pop    %esi
  80207f:	5d                   	pop    %ebp
  802080:	c3                   	ret    

00802081 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802081:	f3 0f 1e fb          	endbr32 
  802085:	55                   	push   %ebp
  802086:	89 e5                	mov    %esp,%ebp
  802088:	53                   	push   %ebx
  802089:	83 ec 0c             	sub    $0xc,%esp
  80208c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80208f:	53                   	push   %ebx
  802090:	6a 00                	push   $0x0
  802092:	e8 65 ed ff ff       	call   800dfc <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802097:	89 1c 24             	mov    %ebx,(%esp)
  80209a:	e8 9d f2 ff ff       	call   80133c <fd2data>
  80209f:	83 c4 08             	add    $0x8,%esp
  8020a2:	50                   	push   %eax
  8020a3:	6a 00                	push   $0x0
  8020a5:	e8 52 ed ff ff       	call   800dfc <sys_page_unmap>
}
  8020aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020ad:	c9                   	leave  
  8020ae:	c3                   	ret    

008020af <_pipeisclosed>:
{
  8020af:	55                   	push   %ebp
  8020b0:	89 e5                	mov    %esp,%ebp
  8020b2:	57                   	push   %edi
  8020b3:	56                   	push   %esi
  8020b4:	53                   	push   %ebx
  8020b5:	83 ec 1c             	sub    $0x1c,%esp
  8020b8:	89 c7                	mov    %eax,%edi
  8020ba:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8020bc:	a1 08 40 80 00       	mov    0x804008,%eax
  8020c1:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8020c4:	83 ec 0c             	sub    $0xc,%esp
  8020c7:	57                   	push   %edi
  8020c8:	e8 10 06 00 00       	call   8026dd <pageref>
  8020cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8020d0:	89 34 24             	mov    %esi,(%esp)
  8020d3:	e8 05 06 00 00       	call   8026dd <pageref>
		nn = thisenv->env_runs;
  8020d8:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8020de:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8020e1:	83 c4 10             	add    $0x10,%esp
  8020e4:	39 cb                	cmp    %ecx,%ebx
  8020e6:	74 1b                	je     802103 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8020e8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8020eb:	75 cf                	jne    8020bc <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8020ed:	8b 42 58             	mov    0x58(%edx),%eax
  8020f0:	6a 01                	push   $0x1
  8020f2:	50                   	push   %eax
  8020f3:	53                   	push   %ebx
  8020f4:	68 3f 2f 80 00       	push   $0x802f3f
  8020f9:	e8 25 e2 ff ff       	call   800323 <cprintf>
  8020fe:	83 c4 10             	add    $0x10,%esp
  802101:	eb b9                	jmp    8020bc <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802103:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802106:	0f 94 c0             	sete   %al
  802109:	0f b6 c0             	movzbl %al,%eax
}
  80210c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80210f:	5b                   	pop    %ebx
  802110:	5e                   	pop    %esi
  802111:	5f                   	pop    %edi
  802112:	5d                   	pop    %ebp
  802113:	c3                   	ret    

00802114 <devpipe_write>:
{
  802114:	f3 0f 1e fb          	endbr32 
  802118:	55                   	push   %ebp
  802119:	89 e5                	mov    %esp,%ebp
  80211b:	57                   	push   %edi
  80211c:	56                   	push   %esi
  80211d:	53                   	push   %ebx
  80211e:	83 ec 28             	sub    $0x28,%esp
  802121:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802124:	56                   	push   %esi
  802125:	e8 12 f2 ff ff       	call   80133c <fd2data>
  80212a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80212c:	83 c4 10             	add    $0x10,%esp
  80212f:	bf 00 00 00 00       	mov    $0x0,%edi
  802134:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802137:	74 4f                	je     802188 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802139:	8b 43 04             	mov    0x4(%ebx),%eax
  80213c:	8b 0b                	mov    (%ebx),%ecx
  80213e:	8d 51 20             	lea    0x20(%ecx),%edx
  802141:	39 d0                	cmp    %edx,%eax
  802143:	72 14                	jb     802159 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  802145:	89 da                	mov    %ebx,%edx
  802147:	89 f0                	mov    %esi,%eax
  802149:	e8 61 ff ff ff       	call   8020af <_pipeisclosed>
  80214e:	85 c0                	test   %eax,%eax
  802150:	75 3b                	jne    80218d <devpipe_write+0x79>
			sys_yield();
  802152:	e8 f5 eb ff ff       	call   800d4c <sys_yield>
  802157:	eb e0                	jmp    802139 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802159:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80215c:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802160:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802163:	89 c2                	mov    %eax,%edx
  802165:	c1 fa 1f             	sar    $0x1f,%edx
  802168:	89 d1                	mov    %edx,%ecx
  80216a:	c1 e9 1b             	shr    $0x1b,%ecx
  80216d:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802170:	83 e2 1f             	and    $0x1f,%edx
  802173:	29 ca                	sub    %ecx,%edx
  802175:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802179:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80217d:	83 c0 01             	add    $0x1,%eax
  802180:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802183:	83 c7 01             	add    $0x1,%edi
  802186:	eb ac                	jmp    802134 <devpipe_write+0x20>
	return i;
  802188:	8b 45 10             	mov    0x10(%ebp),%eax
  80218b:	eb 05                	jmp    802192 <devpipe_write+0x7e>
				return 0;
  80218d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802192:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802195:	5b                   	pop    %ebx
  802196:	5e                   	pop    %esi
  802197:	5f                   	pop    %edi
  802198:	5d                   	pop    %ebp
  802199:	c3                   	ret    

0080219a <devpipe_read>:
{
  80219a:	f3 0f 1e fb          	endbr32 
  80219e:	55                   	push   %ebp
  80219f:	89 e5                	mov    %esp,%ebp
  8021a1:	57                   	push   %edi
  8021a2:	56                   	push   %esi
  8021a3:	53                   	push   %ebx
  8021a4:	83 ec 18             	sub    $0x18,%esp
  8021a7:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8021aa:	57                   	push   %edi
  8021ab:	e8 8c f1 ff ff       	call   80133c <fd2data>
  8021b0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8021b2:	83 c4 10             	add    $0x10,%esp
  8021b5:	be 00 00 00 00       	mov    $0x0,%esi
  8021ba:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021bd:	75 14                	jne    8021d3 <devpipe_read+0x39>
	return i;
  8021bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8021c2:	eb 02                	jmp    8021c6 <devpipe_read+0x2c>
				return i;
  8021c4:	89 f0                	mov    %esi,%eax
}
  8021c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021c9:	5b                   	pop    %ebx
  8021ca:	5e                   	pop    %esi
  8021cb:	5f                   	pop    %edi
  8021cc:	5d                   	pop    %ebp
  8021cd:	c3                   	ret    
			sys_yield();
  8021ce:	e8 79 eb ff ff       	call   800d4c <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8021d3:	8b 03                	mov    (%ebx),%eax
  8021d5:	3b 43 04             	cmp    0x4(%ebx),%eax
  8021d8:	75 18                	jne    8021f2 <devpipe_read+0x58>
			if (i > 0)
  8021da:	85 f6                	test   %esi,%esi
  8021dc:	75 e6                	jne    8021c4 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8021de:	89 da                	mov    %ebx,%edx
  8021e0:	89 f8                	mov    %edi,%eax
  8021e2:	e8 c8 fe ff ff       	call   8020af <_pipeisclosed>
  8021e7:	85 c0                	test   %eax,%eax
  8021e9:	74 e3                	je     8021ce <devpipe_read+0x34>
				return 0;
  8021eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f0:	eb d4                	jmp    8021c6 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8021f2:	99                   	cltd   
  8021f3:	c1 ea 1b             	shr    $0x1b,%edx
  8021f6:	01 d0                	add    %edx,%eax
  8021f8:	83 e0 1f             	and    $0x1f,%eax
  8021fb:	29 d0                	sub    %edx,%eax
  8021fd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802202:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802205:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802208:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80220b:	83 c6 01             	add    $0x1,%esi
  80220e:	eb aa                	jmp    8021ba <devpipe_read+0x20>

00802210 <pipe>:
{
  802210:	f3 0f 1e fb          	endbr32 
  802214:	55                   	push   %ebp
  802215:	89 e5                	mov    %esp,%ebp
  802217:	56                   	push   %esi
  802218:	53                   	push   %ebx
  802219:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80221c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80221f:	50                   	push   %eax
  802220:	e8 32 f1 ff ff       	call   801357 <fd_alloc>
  802225:	89 c3                	mov    %eax,%ebx
  802227:	83 c4 10             	add    $0x10,%esp
  80222a:	85 c0                	test   %eax,%eax
  80222c:	0f 88 23 01 00 00    	js     802355 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802232:	83 ec 04             	sub    $0x4,%esp
  802235:	68 07 04 00 00       	push   $0x407
  80223a:	ff 75 f4             	pushl  -0xc(%ebp)
  80223d:	6a 00                	push   $0x0
  80223f:	e8 2b eb ff ff       	call   800d6f <sys_page_alloc>
  802244:	89 c3                	mov    %eax,%ebx
  802246:	83 c4 10             	add    $0x10,%esp
  802249:	85 c0                	test   %eax,%eax
  80224b:	0f 88 04 01 00 00    	js     802355 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  802251:	83 ec 0c             	sub    $0xc,%esp
  802254:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802257:	50                   	push   %eax
  802258:	e8 fa f0 ff ff       	call   801357 <fd_alloc>
  80225d:	89 c3                	mov    %eax,%ebx
  80225f:	83 c4 10             	add    $0x10,%esp
  802262:	85 c0                	test   %eax,%eax
  802264:	0f 88 db 00 00 00    	js     802345 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80226a:	83 ec 04             	sub    $0x4,%esp
  80226d:	68 07 04 00 00       	push   $0x407
  802272:	ff 75 f0             	pushl  -0x10(%ebp)
  802275:	6a 00                	push   $0x0
  802277:	e8 f3 ea ff ff       	call   800d6f <sys_page_alloc>
  80227c:	89 c3                	mov    %eax,%ebx
  80227e:	83 c4 10             	add    $0x10,%esp
  802281:	85 c0                	test   %eax,%eax
  802283:	0f 88 bc 00 00 00    	js     802345 <pipe+0x135>
	va = fd2data(fd0);
  802289:	83 ec 0c             	sub    $0xc,%esp
  80228c:	ff 75 f4             	pushl  -0xc(%ebp)
  80228f:	e8 a8 f0 ff ff       	call   80133c <fd2data>
  802294:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802296:	83 c4 0c             	add    $0xc,%esp
  802299:	68 07 04 00 00       	push   $0x407
  80229e:	50                   	push   %eax
  80229f:	6a 00                	push   $0x0
  8022a1:	e8 c9 ea ff ff       	call   800d6f <sys_page_alloc>
  8022a6:	89 c3                	mov    %eax,%ebx
  8022a8:	83 c4 10             	add    $0x10,%esp
  8022ab:	85 c0                	test   %eax,%eax
  8022ad:	0f 88 82 00 00 00    	js     802335 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022b3:	83 ec 0c             	sub    $0xc,%esp
  8022b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8022b9:	e8 7e f0 ff ff       	call   80133c <fd2data>
  8022be:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8022c5:	50                   	push   %eax
  8022c6:	6a 00                	push   $0x0
  8022c8:	56                   	push   %esi
  8022c9:	6a 00                	push   $0x0
  8022cb:	e8 e6 ea ff ff       	call   800db6 <sys_page_map>
  8022d0:	89 c3                	mov    %eax,%ebx
  8022d2:	83 c4 20             	add    $0x20,%esp
  8022d5:	85 c0                	test   %eax,%eax
  8022d7:	78 4e                	js     802327 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8022d9:	a1 3c 30 80 00       	mov    0x80303c,%eax
  8022de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e1:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8022e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e6:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8022ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022f0:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8022f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8022fc:	83 ec 0c             	sub    $0xc,%esp
  8022ff:	ff 75 f4             	pushl  -0xc(%ebp)
  802302:	e8 21 f0 ff ff       	call   801328 <fd2num>
  802307:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80230a:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80230c:	83 c4 04             	add    $0x4,%esp
  80230f:	ff 75 f0             	pushl  -0x10(%ebp)
  802312:	e8 11 f0 ff ff       	call   801328 <fd2num>
  802317:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80231a:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80231d:	83 c4 10             	add    $0x10,%esp
  802320:	bb 00 00 00 00       	mov    $0x0,%ebx
  802325:	eb 2e                	jmp    802355 <pipe+0x145>
	sys_page_unmap(0, va);
  802327:	83 ec 08             	sub    $0x8,%esp
  80232a:	56                   	push   %esi
  80232b:	6a 00                	push   $0x0
  80232d:	e8 ca ea ff ff       	call   800dfc <sys_page_unmap>
  802332:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802335:	83 ec 08             	sub    $0x8,%esp
  802338:	ff 75 f0             	pushl  -0x10(%ebp)
  80233b:	6a 00                	push   $0x0
  80233d:	e8 ba ea ff ff       	call   800dfc <sys_page_unmap>
  802342:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802345:	83 ec 08             	sub    $0x8,%esp
  802348:	ff 75 f4             	pushl  -0xc(%ebp)
  80234b:	6a 00                	push   $0x0
  80234d:	e8 aa ea ff ff       	call   800dfc <sys_page_unmap>
  802352:	83 c4 10             	add    $0x10,%esp
}
  802355:	89 d8                	mov    %ebx,%eax
  802357:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80235a:	5b                   	pop    %ebx
  80235b:	5e                   	pop    %esi
  80235c:	5d                   	pop    %ebp
  80235d:	c3                   	ret    

0080235e <pipeisclosed>:
{
  80235e:	f3 0f 1e fb          	endbr32 
  802362:	55                   	push   %ebp
  802363:	89 e5                	mov    %esp,%ebp
  802365:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802368:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80236b:	50                   	push   %eax
  80236c:	ff 75 08             	pushl  0x8(%ebp)
  80236f:	e8 39 f0 ff ff       	call   8013ad <fd_lookup>
  802374:	83 c4 10             	add    $0x10,%esp
  802377:	85 c0                	test   %eax,%eax
  802379:	78 18                	js     802393 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  80237b:	83 ec 0c             	sub    $0xc,%esp
  80237e:	ff 75 f4             	pushl  -0xc(%ebp)
  802381:	e8 b6 ef ff ff       	call   80133c <fd2data>
  802386:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238b:	e8 1f fd ff ff       	call   8020af <_pipeisclosed>
  802390:	83 c4 10             	add    $0x10,%esp
}
  802393:	c9                   	leave  
  802394:	c3                   	ret    

00802395 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802395:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  802399:	b8 00 00 00 00       	mov    $0x0,%eax
  80239e:	c3                   	ret    

0080239f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80239f:	f3 0f 1e fb          	endbr32 
  8023a3:	55                   	push   %ebp
  8023a4:	89 e5                	mov    %esp,%ebp
  8023a6:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8023a9:	68 57 2f 80 00       	push   $0x802f57
  8023ae:	ff 75 0c             	pushl  0xc(%ebp)
  8023b1:	e8 77 e5 ff ff       	call   80092d <strcpy>
	return 0;
}
  8023b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023bb:	c9                   	leave  
  8023bc:	c3                   	ret    

008023bd <devcons_write>:
{
  8023bd:	f3 0f 1e fb          	endbr32 
  8023c1:	55                   	push   %ebp
  8023c2:	89 e5                	mov    %esp,%ebp
  8023c4:	57                   	push   %edi
  8023c5:	56                   	push   %esi
  8023c6:	53                   	push   %ebx
  8023c7:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8023cd:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8023d2:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8023d8:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023db:	73 31                	jae    80240e <devcons_write+0x51>
		m = n - tot;
  8023dd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8023e0:	29 f3                	sub    %esi,%ebx
  8023e2:	83 fb 7f             	cmp    $0x7f,%ebx
  8023e5:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8023ea:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8023ed:	83 ec 04             	sub    $0x4,%esp
  8023f0:	53                   	push   %ebx
  8023f1:	89 f0                	mov    %esi,%eax
  8023f3:	03 45 0c             	add    0xc(%ebp),%eax
  8023f6:	50                   	push   %eax
  8023f7:	57                   	push   %edi
  8023f8:	e8 e6 e6 ff ff       	call   800ae3 <memmove>
		sys_cputs(buf, m);
  8023fd:	83 c4 08             	add    $0x8,%esp
  802400:	53                   	push   %ebx
  802401:	57                   	push   %edi
  802402:	e8 98 e8 ff ff       	call   800c9f <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802407:	01 de                	add    %ebx,%esi
  802409:	83 c4 10             	add    $0x10,%esp
  80240c:	eb ca                	jmp    8023d8 <devcons_write+0x1b>
}
  80240e:	89 f0                	mov    %esi,%eax
  802410:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802413:	5b                   	pop    %ebx
  802414:	5e                   	pop    %esi
  802415:	5f                   	pop    %edi
  802416:	5d                   	pop    %ebp
  802417:	c3                   	ret    

00802418 <devcons_read>:
{
  802418:	f3 0f 1e fb          	endbr32 
  80241c:	55                   	push   %ebp
  80241d:	89 e5                	mov    %esp,%ebp
  80241f:	83 ec 08             	sub    $0x8,%esp
  802422:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802427:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80242b:	74 21                	je     80244e <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  80242d:	e8 8f e8 ff ff       	call   800cc1 <sys_cgetc>
  802432:	85 c0                	test   %eax,%eax
  802434:	75 07                	jne    80243d <devcons_read+0x25>
		sys_yield();
  802436:	e8 11 e9 ff ff       	call   800d4c <sys_yield>
  80243b:	eb f0                	jmp    80242d <devcons_read+0x15>
	if (c < 0)
  80243d:	78 0f                	js     80244e <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  80243f:	83 f8 04             	cmp    $0x4,%eax
  802442:	74 0c                	je     802450 <devcons_read+0x38>
	*(char*)vbuf = c;
  802444:	8b 55 0c             	mov    0xc(%ebp),%edx
  802447:	88 02                	mov    %al,(%edx)
	return 1;
  802449:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80244e:	c9                   	leave  
  80244f:	c3                   	ret    
		return 0;
  802450:	b8 00 00 00 00       	mov    $0x0,%eax
  802455:	eb f7                	jmp    80244e <devcons_read+0x36>

00802457 <cputchar>:
{
  802457:	f3 0f 1e fb          	endbr32 
  80245b:	55                   	push   %ebp
  80245c:	89 e5                	mov    %esp,%ebp
  80245e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802461:	8b 45 08             	mov    0x8(%ebp),%eax
  802464:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802467:	6a 01                	push   $0x1
  802469:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80246c:	50                   	push   %eax
  80246d:	e8 2d e8 ff ff       	call   800c9f <sys_cputs>
}
  802472:	83 c4 10             	add    $0x10,%esp
  802475:	c9                   	leave  
  802476:	c3                   	ret    

00802477 <getchar>:
{
  802477:	f3 0f 1e fb          	endbr32 
  80247b:	55                   	push   %ebp
  80247c:	89 e5                	mov    %esp,%ebp
  80247e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802481:	6a 01                	push   $0x1
  802483:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802486:	50                   	push   %eax
  802487:	6a 00                	push   $0x0
  802489:	e8 a7 f1 ff ff       	call   801635 <read>
	if (r < 0)
  80248e:	83 c4 10             	add    $0x10,%esp
  802491:	85 c0                	test   %eax,%eax
  802493:	78 06                	js     80249b <getchar+0x24>
	if (r < 1)
  802495:	74 06                	je     80249d <getchar+0x26>
	return c;
  802497:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80249b:	c9                   	leave  
  80249c:	c3                   	ret    
		return -E_EOF;
  80249d:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8024a2:	eb f7                	jmp    80249b <getchar+0x24>

008024a4 <iscons>:
{
  8024a4:	f3 0f 1e fb          	endbr32 
  8024a8:	55                   	push   %ebp
  8024a9:	89 e5                	mov    %esp,%ebp
  8024ab:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024b1:	50                   	push   %eax
  8024b2:	ff 75 08             	pushl  0x8(%ebp)
  8024b5:	e8 f3 ee ff ff       	call   8013ad <fd_lookup>
  8024ba:	83 c4 10             	add    $0x10,%esp
  8024bd:	85 c0                	test   %eax,%eax
  8024bf:	78 11                	js     8024d2 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8024c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c4:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8024ca:	39 10                	cmp    %edx,(%eax)
  8024cc:	0f 94 c0             	sete   %al
  8024cf:	0f b6 c0             	movzbl %al,%eax
}
  8024d2:	c9                   	leave  
  8024d3:	c3                   	ret    

008024d4 <opencons>:
{
  8024d4:	f3 0f 1e fb          	endbr32 
  8024d8:	55                   	push   %ebp
  8024d9:	89 e5                	mov    %esp,%ebp
  8024db:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8024de:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024e1:	50                   	push   %eax
  8024e2:	e8 70 ee ff ff       	call   801357 <fd_alloc>
  8024e7:	83 c4 10             	add    $0x10,%esp
  8024ea:	85 c0                	test   %eax,%eax
  8024ec:	78 3a                	js     802528 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8024ee:	83 ec 04             	sub    $0x4,%esp
  8024f1:	68 07 04 00 00       	push   $0x407
  8024f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8024f9:	6a 00                	push   $0x0
  8024fb:	e8 6f e8 ff ff       	call   800d6f <sys_page_alloc>
  802500:	83 c4 10             	add    $0x10,%esp
  802503:	85 c0                	test   %eax,%eax
  802505:	78 21                	js     802528 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250a:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802510:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802512:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802515:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80251c:	83 ec 0c             	sub    $0xc,%esp
  80251f:	50                   	push   %eax
  802520:	e8 03 ee ff ff       	call   801328 <fd2num>
  802525:	83 c4 10             	add    $0x10,%esp
}
  802528:	c9                   	leave  
  802529:	c3                   	ret    

0080252a <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80252a:	f3 0f 1e fb          	endbr32 
  80252e:	55                   	push   %ebp
  80252f:	89 e5                	mov    %esp,%ebp
  802531:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802534:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  80253b:	74 0a                	je     802547 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80253d:	8b 45 08             	mov    0x8(%ebp),%eax
  802540:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802545:	c9                   	leave  
  802546:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  802547:	83 ec 04             	sub    $0x4,%esp
  80254a:	6a 07                	push   $0x7
  80254c:	68 00 f0 bf ee       	push   $0xeebff000
  802551:	6a 00                	push   $0x0
  802553:	e8 17 e8 ff ff       	call   800d6f <sys_page_alloc>
  802558:	83 c4 10             	add    $0x10,%esp
  80255b:	85 c0                	test   %eax,%eax
  80255d:	78 2a                	js     802589 <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  80255f:	83 ec 08             	sub    $0x8,%esp
  802562:	68 9d 25 80 00       	push   $0x80259d
  802567:	6a 00                	push   $0x0
  802569:	e8 60 e9 ff ff       	call   800ece <sys_env_set_pgfault_upcall>
  80256e:	83 c4 10             	add    $0x10,%esp
  802571:	85 c0                	test   %eax,%eax
  802573:	79 c8                	jns    80253d <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  802575:	83 ec 04             	sub    $0x4,%esp
  802578:	68 90 2f 80 00       	push   $0x802f90
  80257d:	6a 25                	push   $0x25
  80257f:	68 c8 2f 80 00       	push   $0x802fc8
  802584:	e8 b3 dc ff ff       	call   80023c <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  802589:	83 ec 04             	sub    $0x4,%esp
  80258c:	68 64 2f 80 00       	push   $0x802f64
  802591:	6a 22                	push   $0x22
  802593:	68 c8 2f 80 00       	push   $0x802fc8
  802598:	e8 9f dc ff ff       	call   80023c <_panic>

0080259d <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80259d:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80259e:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  8025a3:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8025a5:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  8025a8:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  8025ac:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  8025b0:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8025b3:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  8025b5:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  8025b9:	83 c4 08             	add    $0x8,%esp
	popal
  8025bc:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  8025bd:	83 c4 04             	add    $0x4,%esp
	popfl
  8025c0:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  8025c1:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  8025c2:	c3                   	ret    

008025c3 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8025c3:	f3 0f 1e fb          	endbr32 
  8025c7:	55                   	push   %ebp
  8025c8:	89 e5                	mov    %esp,%ebp
  8025ca:	56                   	push   %esi
  8025cb:	53                   	push   %ebx
  8025cc:	8b 75 08             	mov    0x8(%ebp),%esi
  8025cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  8025d5:	85 c0                	test   %eax,%eax
  8025d7:	74 3d                	je     802616 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  8025d9:	83 ec 0c             	sub    $0xc,%esp
  8025dc:	50                   	push   %eax
  8025dd:	e8 59 e9 ff ff       	call   800f3b <sys_ipc_recv>
  8025e2:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  8025e5:	85 f6                	test   %esi,%esi
  8025e7:	74 0b                	je     8025f4 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8025e9:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8025ef:	8b 52 74             	mov    0x74(%edx),%edx
  8025f2:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  8025f4:	85 db                	test   %ebx,%ebx
  8025f6:	74 0b                	je     802603 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  8025f8:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8025fe:	8b 52 78             	mov    0x78(%edx),%edx
  802601:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  802603:	85 c0                	test   %eax,%eax
  802605:	78 21                	js     802628 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  802607:	a1 08 40 80 00       	mov    0x804008,%eax
  80260c:	8b 40 70             	mov    0x70(%eax),%eax
}
  80260f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802612:	5b                   	pop    %ebx
  802613:	5e                   	pop    %esi
  802614:	5d                   	pop    %ebp
  802615:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  802616:	83 ec 0c             	sub    $0xc,%esp
  802619:	68 00 00 c0 ee       	push   $0xeec00000
  80261e:	e8 18 e9 ff ff       	call   800f3b <sys_ipc_recv>
  802623:	83 c4 10             	add    $0x10,%esp
  802626:	eb bd                	jmp    8025e5 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  802628:	85 f6                	test   %esi,%esi
  80262a:	74 10                	je     80263c <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  80262c:	85 db                	test   %ebx,%ebx
  80262e:	75 df                	jne    80260f <ipc_recv+0x4c>
  802630:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802637:	00 00 00 
  80263a:	eb d3                	jmp    80260f <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  80263c:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802643:	00 00 00 
  802646:	eb e4                	jmp    80262c <ipc_recv+0x69>

00802648 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802648:	f3 0f 1e fb          	endbr32 
  80264c:	55                   	push   %ebp
  80264d:	89 e5                	mov    %esp,%ebp
  80264f:	57                   	push   %edi
  802650:	56                   	push   %esi
  802651:	53                   	push   %ebx
  802652:	83 ec 0c             	sub    $0xc,%esp
  802655:	8b 7d 08             	mov    0x8(%ebp),%edi
  802658:	8b 75 0c             	mov    0xc(%ebp),%esi
  80265b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  80265e:	85 db                	test   %ebx,%ebx
  802660:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802665:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  802668:	ff 75 14             	pushl  0x14(%ebp)
  80266b:	53                   	push   %ebx
  80266c:	56                   	push   %esi
  80266d:	57                   	push   %edi
  80266e:	e8 a1 e8 ff ff       	call   800f14 <sys_ipc_try_send>
  802673:	83 c4 10             	add    $0x10,%esp
  802676:	85 c0                	test   %eax,%eax
  802678:	79 1e                	jns    802698 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  80267a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80267d:	75 07                	jne    802686 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  80267f:	e8 c8 e6 ff ff       	call   800d4c <sys_yield>
  802684:	eb e2                	jmp    802668 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  802686:	50                   	push   %eax
  802687:	68 d6 2f 80 00       	push   $0x802fd6
  80268c:	6a 59                	push   $0x59
  80268e:	68 f1 2f 80 00       	push   $0x802ff1
  802693:	e8 a4 db ff ff       	call   80023c <_panic>
	}
}
  802698:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80269b:	5b                   	pop    %ebx
  80269c:	5e                   	pop    %esi
  80269d:	5f                   	pop    %edi
  80269e:	5d                   	pop    %ebp
  80269f:	c3                   	ret    

008026a0 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8026a0:	f3 0f 1e fb          	endbr32 
  8026a4:	55                   	push   %ebp
  8026a5:	89 e5                	mov    %esp,%ebp
  8026a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8026aa:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8026af:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8026b2:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8026b8:	8b 52 50             	mov    0x50(%edx),%edx
  8026bb:	39 ca                	cmp    %ecx,%edx
  8026bd:	74 11                	je     8026d0 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8026bf:	83 c0 01             	add    $0x1,%eax
  8026c2:	3d 00 04 00 00       	cmp    $0x400,%eax
  8026c7:	75 e6                	jne    8026af <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8026c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ce:	eb 0b                	jmp    8026db <ipc_find_env+0x3b>
			return envs[i].env_id;
  8026d0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8026d3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8026d8:	8b 40 48             	mov    0x48(%eax),%eax
}
  8026db:	5d                   	pop    %ebp
  8026dc:	c3                   	ret    

008026dd <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8026dd:	f3 0f 1e fb          	endbr32 
  8026e1:	55                   	push   %ebp
  8026e2:	89 e5                	mov    %esp,%ebp
  8026e4:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8026e7:	89 c2                	mov    %eax,%edx
  8026e9:	c1 ea 16             	shr    $0x16,%edx
  8026ec:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8026f3:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8026f8:	f6 c1 01             	test   $0x1,%cl
  8026fb:	74 1c                	je     802719 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8026fd:	c1 e8 0c             	shr    $0xc,%eax
  802700:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802707:	a8 01                	test   $0x1,%al
  802709:	74 0e                	je     802719 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80270b:	c1 e8 0c             	shr    $0xc,%eax
  80270e:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802715:	ef 
  802716:	0f b7 d2             	movzwl %dx,%edx
}
  802719:	89 d0                	mov    %edx,%eax
  80271b:	5d                   	pop    %ebp
  80271c:	c3                   	ret    
  80271d:	66 90                	xchg   %ax,%ax
  80271f:	90                   	nop

00802720 <__udivdi3>:
  802720:	f3 0f 1e fb          	endbr32 
  802724:	55                   	push   %ebp
  802725:	57                   	push   %edi
  802726:	56                   	push   %esi
  802727:	53                   	push   %ebx
  802728:	83 ec 1c             	sub    $0x1c,%esp
  80272b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80272f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802733:	8b 74 24 34          	mov    0x34(%esp),%esi
  802737:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80273b:	85 d2                	test   %edx,%edx
  80273d:	75 19                	jne    802758 <__udivdi3+0x38>
  80273f:	39 f3                	cmp    %esi,%ebx
  802741:	76 4d                	jbe    802790 <__udivdi3+0x70>
  802743:	31 ff                	xor    %edi,%edi
  802745:	89 e8                	mov    %ebp,%eax
  802747:	89 f2                	mov    %esi,%edx
  802749:	f7 f3                	div    %ebx
  80274b:	89 fa                	mov    %edi,%edx
  80274d:	83 c4 1c             	add    $0x1c,%esp
  802750:	5b                   	pop    %ebx
  802751:	5e                   	pop    %esi
  802752:	5f                   	pop    %edi
  802753:	5d                   	pop    %ebp
  802754:	c3                   	ret    
  802755:	8d 76 00             	lea    0x0(%esi),%esi
  802758:	39 f2                	cmp    %esi,%edx
  80275a:	76 14                	jbe    802770 <__udivdi3+0x50>
  80275c:	31 ff                	xor    %edi,%edi
  80275e:	31 c0                	xor    %eax,%eax
  802760:	89 fa                	mov    %edi,%edx
  802762:	83 c4 1c             	add    $0x1c,%esp
  802765:	5b                   	pop    %ebx
  802766:	5e                   	pop    %esi
  802767:	5f                   	pop    %edi
  802768:	5d                   	pop    %ebp
  802769:	c3                   	ret    
  80276a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802770:	0f bd fa             	bsr    %edx,%edi
  802773:	83 f7 1f             	xor    $0x1f,%edi
  802776:	75 48                	jne    8027c0 <__udivdi3+0xa0>
  802778:	39 f2                	cmp    %esi,%edx
  80277a:	72 06                	jb     802782 <__udivdi3+0x62>
  80277c:	31 c0                	xor    %eax,%eax
  80277e:	39 eb                	cmp    %ebp,%ebx
  802780:	77 de                	ja     802760 <__udivdi3+0x40>
  802782:	b8 01 00 00 00       	mov    $0x1,%eax
  802787:	eb d7                	jmp    802760 <__udivdi3+0x40>
  802789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802790:	89 d9                	mov    %ebx,%ecx
  802792:	85 db                	test   %ebx,%ebx
  802794:	75 0b                	jne    8027a1 <__udivdi3+0x81>
  802796:	b8 01 00 00 00       	mov    $0x1,%eax
  80279b:	31 d2                	xor    %edx,%edx
  80279d:	f7 f3                	div    %ebx
  80279f:	89 c1                	mov    %eax,%ecx
  8027a1:	31 d2                	xor    %edx,%edx
  8027a3:	89 f0                	mov    %esi,%eax
  8027a5:	f7 f1                	div    %ecx
  8027a7:	89 c6                	mov    %eax,%esi
  8027a9:	89 e8                	mov    %ebp,%eax
  8027ab:	89 f7                	mov    %esi,%edi
  8027ad:	f7 f1                	div    %ecx
  8027af:	89 fa                	mov    %edi,%edx
  8027b1:	83 c4 1c             	add    $0x1c,%esp
  8027b4:	5b                   	pop    %ebx
  8027b5:	5e                   	pop    %esi
  8027b6:	5f                   	pop    %edi
  8027b7:	5d                   	pop    %ebp
  8027b8:	c3                   	ret    
  8027b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027c0:	89 f9                	mov    %edi,%ecx
  8027c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8027c7:	29 f8                	sub    %edi,%eax
  8027c9:	d3 e2                	shl    %cl,%edx
  8027cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8027cf:	89 c1                	mov    %eax,%ecx
  8027d1:	89 da                	mov    %ebx,%edx
  8027d3:	d3 ea                	shr    %cl,%edx
  8027d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8027d9:	09 d1                	or     %edx,%ecx
  8027db:	89 f2                	mov    %esi,%edx
  8027dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027e1:	89 f9                	mov    %edi,%ecx
  8027e3:	d3 e3                	shl    %cl,%ebx
  8027e5:	89 c1                	mov    %eax,%ecx
  8027e7:	d3 ea                	shr    %cl,%edx
  8027e9:	89 f9                	mov    %edi,%ecx
  8027eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8027ef:	89 eb                	mov    %ebp,%ebx
  8027f1:	d3 e6                	shl    %cl,%esi
  8027f3:	89 c1                	mov    %eax,%ecx
  8027f5:	d3 eb                	shr    %cl,%ebx
  8027f7:	09 de                	or     %ebx,%esi
  8027f9:	89 f0                	mov    %esi,%eax
  8027fb:	f7 74 24 08          	divl   0x8(%esp)
  8027ff:	89 d6                	mov    %edx,%esi
  802801:	89 c3                	mov    %eax,%ebx
  802803:	f7 64 24 0c          	mull   0xc(%esp)
  802807:	39 d6                	cmp    %edx,%esi
  802809:	72 15                	jb     802820 <__udivdi3+0x100>
  80280b:	89 f9                	mov    %edi,%ecx
  80280d:	d3 e5                	shl    %cl,%ebp
  80280f:	39 c5                	cmp    %eax,%ebp
  802811:	73 04                	jae    802817 <__udivdi3+0xf7>
  802813:	39 d6                	cmp    %edx,%esi
  802815:	74 09                	je     802820 <__udivdi3+0x100>
  802817:	89 d8                	mov    %ebx,%eax
  802819:	31 ff                	xor    %edi,%edi
  80281b:	e9 40 ff ff ff       	jmp    802760 <__udivdi3+0x40>
  802820:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802823:	31 ff                	xor    %edi,%edi
  802825:	e9 36 ff ff ff       	jmp    802760 <__udivdi3+0x40>
  80282a:	66 90                	xchg   %ax,%ax
  80282c:	66 90                	xchg   %ax,%ax
  80282e:	66 90                	xchg   %ax,%ax

00802830 <__umoddi3>:
  802830:	f3 0f 1e fb          	endbr32 
  802834:	55                   	push   %ebp
  802835:	57                   	push   %edi
  802836:	56                   	push   %esi
  802837:	53                   	push   %ebx
  802838:	83 ec 1c             	sub    $0x1c,%esp
  80283b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80283f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802843:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802847:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80284b:	85 c0                	test   %eax,%eax
  80284d:	75 19                	jne    802868 <__umoddi3+0x38>
  80284f:	39 df                	cmp    %ebx,%edi
  802851:	76 5d                	jbe    8028b0 <__umoddi3+0x80>
  802853:	89 f0                	mov    %esi,%eax
  802855:	89 da                	mov    %ebx,%edx
  802857:	f7 f7                	div    %edi
  802859:	89 d0                	mov    %edx,%eax
  80285b:	31 d2                	xor    %edx,%edx
  80285d:	83 c4 1c             	add    $0x1c,%esp
  802860:	5b                   	pop    %ebx
  802861:	5e                   	pop    %esi
  802862:	5f                   	pop    %edi
  802863:	5d                   	pop    %ebp
  802864:	c3                   	ret    
  802865:	8d 76 00             	lea    0x0(%esi),%esi
  802868:	89 f2                	mov    %esi,%edx
  80286a:	39 d8                	cmp    %ebx,%eax
  80286c:	76 12                	jbe    802880 <__umoddi3+0x50>
  80286e:	89 f0                	mov    %esi,%eax
  802870:	89 da                	mov    %ebx,%edx
  802872:	83 c4 1c             	add    $0x1c,%esp
  802875:	5b                   	pop    %ebx
  802876:	5e                   	pop    %esi
  802877:	5f                   	pop    %edi
  802878:	5d                   	pop    %ebp
  802879:	c3                   	ret    
  80287a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802880:	0f bd e8             	bsr    %eax,%ebp
  802883:	83 f5 1f             	xor    $0x1f,%ebp
  802886:	75 50                	jne    8028d8 <__umoddi3+0xa8>
  802888:	39 d8                	cmp    %ebx,%eax
  80288a:	0f 82 e0 00 00 00    	jb     802970 <__umoddi3+0x140>
  802890:	89 d9                	mov    %ebx,%ecx
  802892:	39 f7                	cmp    %esi,%edi
  802894:	0f 86 d6 00 00 00    	jbe    802970 <__umoddi3+0x140>
  80289a:	89 d0                	mov    %edx,%eax
  80289c:	89 ca                	mov    %ecx,%edx
  80289e:	83 c4 1c             	add    $0x1c,%esp
  8028a1:	5b                   	pop    %ebx
  8028a2:	5e                   	pop    %esi
  8028a3:	5f                   	pop    %edi
  8028a4:	5d                   	pop    %ebp
  8028a5:	c3                   	ret    
  8028a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028ad:	8d 76 00             	lea    0x0(%esi),%esi
  8028b0:	89 fd                	mov    %edi,%ebp
  8028b2:	85 ff                	test   %edi,%edi
  8028b4:	75 0b                	jne    8028c1 <__umoddi3+0x91>
  8028b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8028bb:	31 d2                	xor    %edx,%edx
  8028bd:	f7 f7                	div    %edi
  8028bf:	89 c5                	mov    %eax,%ebp
  8028c1:	89 d8                	mov    %ebx,%eax
  8028c3:	31 d2                	xor    %edx,%edx
  8028c5:	f7 f5                	div    %ebp
  8028c7:	89 f0                	mov    %esi,%eax
  8028c9:	f7 f5                	div    %ebp
  8028cb:	89 d0                	mov    %edx,%eax
  8028cd:	31 d2                	xor    %edx,%edx
  8028cf:	eb 8c                	jmp    80285d <__umoddi3+0x2d>
  8028d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028d8:	89 e9                	mov    %ebp,%ecx
  8028da:	ba 20 00 00 00       	mov    $0x20,%edx
  8028df:	29 ea                	sub    %ebp,%edx
  8028e1:	d3 e0                	shl    %cl,%eax
  8028e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8028e7:	89 d1                	mov    %edx,%ecx
  8028e9:	89 f8                	mov    %edi,%eax
  8028eb:	d3 e8                	shr    %cl,%eax
  8028ed:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8028f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8028f5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8028f9:	09 c1                	or     %eax,%ecx
  8028fb:	89 d8                	mov    %ebx,%eax
  8028fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802901:	89 e9                	mov    %ebp,%ecx
  802903:	d3 e7                	shl    %cl,%edi
  802905:	89 d1                	mov    %edx,%ecx
  802907:	d3 e8                	shr    %cl,%eax
  802909:	89 e9                	mov    %ebp,%ecx
  80290b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80290f:	d3 e3                	shl    %cl,%ebx
  802911:	89 c7                	mov    %eax,%edi
  802913:	89 d1                	mov    %edx,%ecx
  802915:	89 f0                	mov    %esi,%eax
  802917:	d3 e8                	shr    %cl,%eax
  802919:	89 e9                	mov    %ebp,%ecx
  80291b:	89 fa                	mov    %edi,%edx
  80291d:	d3 e6                	shl    %cl,%esi
  80291f:	09 d8                	or     %ebx,%eax
  802921:	f7 74 24 08          	divl   0x8(%esp)
  802925:	89 d1                	mov    %edx,%ecx
  802927:	89 f3                	mov    %esi,%ebx
  802929:	f7 64 24 0c          	mull   0xc(%esp)
  80292d:	89 c6                	mov    %eax,%esi
  80292f:	89 d7                	mov    %edx,%edi
  802931:	39 d1                	cmp    %edx,%ecx
  802933:	72 06                	jb     80293b <__umoddi3+0x10b>
  802935:	75 10                	jne    802947 <__umoddi3+0x117>
  802937:	39 c3                	cmp    %eax,%ebx
  802939:	73 0c                	jae    802947 <__umoddi3+0x117>
  80293b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80293f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802943:	89 d7                	mov    %edx,%edi
  802945:	89 c6                	mov    %eax,%esi
  802947:	89 ca                	mov    %ecx,%edx
  802949:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80294e:	29 f3                	sub    %esi,%ebx
  802950:	19 fa                	sbb    %edi,%edx
  802952:	89 d0                	mov    %edx,%eax
  802954:	d3 e0                	shl    %cl,%eax
  802956:	89 e9                	mov    %ebp,%ecx
  802958:	d3 eb                	shr    %cl,%ebx
  80295a:	d3 ea                	shr    %cl,%edx
  80295c:	09 d8                	or     %ebx,%eax
  80295e:	83 c4 1c             	add    $0x1c,%esp
  802961:	5b                   	pop    %ebx
  802962:	5e                   	pop    %esi
  802963:	5f                   	pop    %edi
  802964:	5d                   	pop    %ebp
  802965:	c3                   	ret    
  802966:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80296d:	8d 76 00             	lea    0x0(%esi),%esi
  802970:	29 fe                	sub    %edi,%esi
  802972:	19 c3                	sbb    %eax,%ebx
  802974:	89 f2                	mov    %esi,%edx
  802976:	89 d9                	mov    %ebx,%ecx
  802978:	e9 1d ff ff ff       	jmp    80289a <__umoddi3+0x6a>
