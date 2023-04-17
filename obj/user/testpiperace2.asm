
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
  800040:	68 20 24 80 00       	push   $0x802420
  800045:	e8 d9 02 00 00       	call   800323 <cprintf>
	if ((r = pipe(p)) < 0)
  80004a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80004d:	89 04 24             	mov    %eax,(%esp)
  800050:	e8 4f 1c 00 00       	call   801ca4 <pipe>
  800055:	83 c4 10             	add    $0x10,%esp
  800058:	85 c0                	test   %eax,%eax
  80005a:	78 5b                	js     8000b7 <umain+0x84>
		panic("pipe: %e", r);
	if ((r = fork()) < 0)
  80005c:	e8 ff 0f 00 00       	call   801060 <fork>
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
  80008c:	e8 61 1d 00 00       	call   801df2 <pipeisclosed>
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	85 c0                	test   %eax,%eax
  800096:	74 e2                	je     80007a <umain+0x47>
			cprintf("\nRACE: pipe appears closed\n");
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	68 90 24 80 00       	push   $0x802490
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
  8000b8:	68 6e 24 80 00       	push   $0x80246e
  8000bd:	6a 0d                	push   $0xd
  8000bf:	68 77 24 80 00       	push   $0x802477
  8000c4:	e8 73 01 00 00       	call   80023c <_panic>
		panic("fork: %e", r);
  8000c9:	50                   	push   %eax
  8000ca:	68 85 28 80 00       	push   $0x802885
  8000cf:	6a 0f                	push   $0xf
  8000d1:	68 77 24 80 00       	push   $0x802477
  8000d6:	e8 61 01 00 00       	call   80023c <_panic>
		close(p[1]);
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000e1:	e8 51 13 00 00       	call   801437 <close>
  8000e6:	83 c4 10             	add    $0x10,%esp
		for (i = 0; i < 200; i++) {
  8000e9:	89 fb                	mov    %edi,%ebx
			if (i % 10 == 0)
  8000eb:	be 67 66 66 66       	mov    $0x66666667,%esi
  8000f0:	eb 42                	jmp    800134 <umain+0x101>
				cprintf("%d.", i);
  8000f2:	83 ec 08             	sub    $0x8,%esp
  8000f5:	53                   	push   %ebx
  8000f6:	68 8c 24 80 00       	push   $0x80248c
  8000fb:	e8 23 02 00 00       	call   800323 <cprintf>
  800100:	83 c4 10             	add    $0x10,%esp
			dup(p[0], 10);
  800103:	83 ec 08             	sub    $0x8,%esp
  800106:	6a 0a                	push   $0xa
  800108:	ff 75 e0             	pushl  -0x20(%ebp)
  80010b:	e8 81 13 00 00       	call   801491 <dup>
			sys_yield();
  800110:	e8 37 0c 00 00       	call   800d4c <sys_yield>
			close(10);
  800115:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  80011c:	e8 16 13 00 00       	call   801437 <close>
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
  80015a:	68 ac 24 80 00       	push   $0x8024ac
  80015f:	e8 bf 01 00 00       	call   800323 <cprintf>
	if (pipeisclosed(p[0]))
  800164:	83 c4 04             	add    $0x4,%esp
  800167:	ff 75 e0             	pushl  -0x20(%ebp)
  80016a:	e8 83 1c 00 00       	call   801df2 <pipeisclosed>
  80016f:	83 c4 10             	add    $0x10,%esp
  800172:	85 c0                	test   %eax,%eax
  800174:	75 38                	jne    8001ae <umain+0x17b>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  800176:	83 ec 08             	sub    $0x8,%esp
  800179:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80017c:	50                   	push   %eax
  80017d:	ff 75 e0             	pushl  -0x20(%ebp)
  800180:	e8 79 11 00 00       	call   8012fe <fd_lookup>
  800185:	83 c4 10             	add    $0x10,%esp
  800188:	85 c0                	test   %eax,%eax
  80018a:	78 36                	js     8001c2 <umain+0x18f>
		panic("cannot look up p[0]: %e", r);
	(void) fd2data(fd);
  80018c:	83 ec 0c             	sub    $0xc,%esp
  80018f:	ff 75 dc             	pushl  -0x24(%ebp)
  800192:	e8 f6 10 00 00       	call   80128d <fd2data>
	cprintf("race didn't happen\n");
  800197:	c7 04 24 da 24 80 00 	movl   $0x8024da,(%esp)
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
  8001b1:	68 44 24 80 00       	push   $0x802444
  8001b6:	6a 40                	push   $0x40
  8001b8:	68 77 24 80 00       	push   $0x802477
  8001bd:	e8 7a 00 00 00       	call   80023c <_panic>
		panic("cannot look up p[0]: %e", r);
  8001c2:	50                   	push   %eax
  8001c3:	68 c2 24 80 00       	push   $0x8024c2
  8001c8:	6a 42                	push   $0x42
  8001ca:	68 77 24 80 00       	push   $0x802477
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
  8001f5:	a3 04 40 80 00       	mov    %eax,0x804004

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
  800228:	e8 3b 12 00 00       	call   801468 <close_all>
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
  80025e:	68 f8 24 80 00       	push   $0x8024f8
  800263:	e8 bb 00 00 00       	call   800323 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800268:	83 c4 18             	add    $0x18,%esp
  80026b:	53                   	push   %ebx
  80026c:	ff 75 10             	pushl  0x10(%ebp)
  80026f:	e8 5a 00 00 00       	call   8002ce <vcprintf>
	cprintf("\n");
  800274:	c7 04 24 53 2a 80 00 	movl   $0x802a53,(%esp)
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
  800389:	e8 32 1e 00 00       	call   8021c0 <__udivdi3>
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
  8003c7:	e8 04 1f 00 00       	call   8022d0 <__umoddi3>
  8003cc:	83 c4 14             	add    $0x14,%esp
  8003cf:	0f be 80 1b 25 80 00 	movsbl 0x80251b(%eax),%eax
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
  800476:	3e ff 24 85 60 26 80 	notrack jmp *0x802660(,%eax,4)
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
  800543:	8b 14 85 c0 27 80 00 	mov    0x8027c0(,%eax,4),%edx
  80054a:	85 d2                	test   %edx,%edx
  80054c:	74 18                	je     800566 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80054e:	52                   	push   %edx
  80054f:	68 81 29 80 00       	push   $0x802981
  800554:	53                   	push   %ebx
  800555:	56                   	push   %esi
  800556:	e8 aa fe ff ff       	call   800405 <printfmt>
  80055b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80055e:	89 7d 14             	mov    %edi,0x14(%ebp)
  800561:	e9 66 02 00 00       	jmp    8007cc <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800566:	50                   	push   %eax
  800567:	68 33 25 80 00       	push   $0x802533
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
  80058e:	b8 2c 25 80 00       	mov    $0x80252c,%eax
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
  800d18:	68 1f 28 80 00       	push   $0x80281f
  800d1d:	6a 23                	push   $0x23
  800d1f:	68 3c 28 80 00       	push   $0x80283c
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
  800da5:	68 1f 28 80 00       	push   $0x80281f
  800daa:	6a 23                	push   $0x23
  800dac:	68 3c 28 80 00       	push   $0x80283c
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
  800deb:	68 1f 28 80 00       	push   $0x80281f
  800df0:	6a 23                	push   $0x23
  800df2:	68 3c 28 80 00       	push   $0x80283c
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
  800e31:	68 1f 28 80 00       	push   $0x80281f
  800e36:	6a 23                	push   $0x23
  800e38:	68 3c 28 80 00       	push   $0x80283c
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
  800e77:	68 1f 28 80 00       	push   $0x80281f
  800e7c:	6a 23                	push   $0x23
  800e7e:	68 3c 28 80 00       	push   $0x80283c
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
  800ebd:	68 1f 28 80 00       	push   $0x80281f
  800ec2:	6a 23                	push   $0x23
  800ec4:	68 3c 28 80 00       	push   $0x80283c
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
  800f03:	68 1f 28 80 00       	push   $0x80281f
  800f08:	6a 23                	push   $0x23
  800f0a:	68 3c 28 80 00       	push   $0x80283c
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
  800f6f:	68 1f 28 80 00       	push   $0x80281f
  800f74:	6a 23                	push   $0x23
  800f76:	68 3c 28 80 00       	push   $0x80283c
  800f7b:	e8 bc f2 ff ff       	call   80023c <_panic>

00800f80 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f80:	f3 0f 1e fb          	endbr32 
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	53                   	push   %ebx
  800f88:	83 ec 04             	sub    $0x4,%esp
  800f8b:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800f8e:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  800f90:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f94:	74 74                	je     80100a <pgfault+0x8a>
  800f96:	89 d8                	mov    %ebx,%eax
  800f98:	c1 e8 0c             	shr    $0xc,%eax
  800f9b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fa2:	f6 c4 08             	test   $0x8,%ah
  800fa5:	74 63                	je     80100a <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800fa7:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  800fad:	83 ec 0c             	sub    $0xc,%esp
  800fb0:	6a 05                	push   $0x5
  800fb2:	68 00 f0 7f 00       	push   $0x7ff000
  800fb7:	6a 00                	push   $0x0
  800fb9:	53                   	push   %ebx
  800fba:	6a 00                	push   $0x0
  800fbc:	e8 f5 fd ff ff       	call   800db6 <sys_page_map>
  800fc1:	83 c4 20             	add    $0x20,%esp
  800fc4:	85 c0                	test   %eax,%eax
  800fc6:	78 59                	js     801021 <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  800fc8:	83 ec 04             	sub    $0x4,%esp
  800fcb:	6a 07                	push   $0x7
  800fcd:	53                   	push   %ebx
  800fce:	6a 00                	push   $0x0
  800fd0:	e8 9a fd ff ff       	call   800d6f <sys_page_alloc>
  800fd5:	83 c4 10             	add    $0x10,%esp
  800fd8:	85 c0                	test   %eax,%eax
  800fda:	78 5a                	js     801036 <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  800fdc:	83 ec 04             	sub    $0x4,%esp
  800fdf:	68 00 10 00 00       	push   $0x1000
  800fe4:	68 00 f0 7f 00       	push   $0x7ff000
  800fe9:	53                   	push   %ebx
  800fea:	e8 f4 fa ff ff       	call   800ae3 <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  800fef:	83 c4 08             	add    $0x8,%esp
  800ff2:	68 00 f0 7f 00       	push   $0x7ff000
  800ff7:	6a 00                	push   $0x0
  800ff9:	e8 fe fd ff ff       	call   800dfc <sys_page_unmap>
  800ffe:	83 c4 10             	add    $0x10,%esp
  801001:	85 c0                	test   %eax,%eax
  801003:	78 46                	js     80104b <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  801005:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801008:	c9                   	leave  
  801009:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  80100a:	83 ec 04             	sub    $0x4,%esp
  80100d:	68 4a 28 80 00       	push   $0x80284a
  801012:	68 d3 00 00 00       	push   $0xd3
  801017:	68 66 28 80 00       	push   $0x802866
  80101c:	e8 1b f2 ff ff       	call   80023c <_panic>
		panic("pgfault: %e\n", r);
  801021:	50                   	push   %eax
  801022:	68 71 28 80 00       	push   $0x802871
  801027:	68 df 00 00 00       	push   $0xdf
  80102c:	68 66 28 80 00       	push   $0x802866
  801031:	e8 06 f2 ff ff       	call   80023c <_panic>
		panic("pgfault: %e\n", r);
  801036:	50                   	push   %eax
  801037:	68 71 28 80 00       	push   $0x802871
  80103c:	68 e3 00 00 00       	push   $0xe3
  801041:	68 66 28 80 00       	push   $0x802866
  801046:	e8 f1 f1 ff ff       	call   80023c <_panic>
		panic("pgfault: %e\n", r);
  80104b:	50                   	push   %eax
  80104c:	68 71 28 80 00       	push   $0x802871
  801051:	68 e9 00 00 00       	push   $0xe9
  801056:	68 66 28 80 00       	push   $0x802866
  80105b:	e8 dc f1 ff ff       	call   80023c <_panic>

00801060 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801060:	f3 0f 1e fb          	endbr32 
  801064:	55                   	push   %ebp
  801065:	89 e5                	mov    %esp,%ebp
  801067:	57                   	push   %edi
  801068:	56                   	push   %esi
  801069:	53                   	push   %ebx
  80106a:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  80106d:	68 80 0f 80 00       	push   $0x800f80
  801072:	e8 47 0f 00 00       	call   801fbe <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801077:	b8 07 00 00 00       	mov    $0x7,%eax
  80107c:	cd 30                	int    $0x30
  80107e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  801081:	83 c4 10             	add    $0x10,%esp
  801084:	85 c0                	test   %eax,%eax
  801086:	78 2d                	js     8010b5 <fork+0x55>
  801088:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  80108a:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  80108f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801093:	0f 85 9b 00 00 00    	jne    801134 <fork+0xd4>
		thisenv = &envs[ENVX(sys_getenvid())];
  801099:	e8 8b fc ff ff       	call   800d29 <sys_getenvid>
  80109e:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010a3:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010a6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010ab:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  8010b0:	e9 71 01 00 00       	jmp    801226 <fork+0x1c6>
		panic("sys_exofork: %e", envid);
  8010b5:	50                   	push   %eax
  8010b6:	68 7e 28 80 00       	push   $0x80287e
  8010bb:	68 2a 01 00 00       	push   $0x12a
  8010c0:	68 66 28 80 00       	push   $0x802866
  8010c5:	e8 72 f1 ff ff       	call   80023c <_panic>
		sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_SYSCALL);
  8010ca:	c1 e6 0c             	shl    $0xc,%esi
  8010cd:	83 ec 0c             	sub    $0xc,%esp
  8010d0:	68 07 0e 00 00       	push   $0xe07
  8010d5:	56                   	push   %esi
  8010d6:	57                   	push   %edi
  8010d7:	56                   	push   %esi
  8010d8:	6a 00                	push   $0x0
  8010da:	e8 d7 fc ff ff       	call   800db6 <sys_page_map>
  8010df:	83 c4 20             	add    $0x20,%esp
  8010e2:	eb 3e                	jmp    801122 <fork+0xc2>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  8010e4:	c1 e6 0c             	shl    $0xc,%esi
  8010e7:	83 ec 0c             	sub    $0xc,%esp
  8010ea:	68 05 08 00 00       	push   $0x805
  8010ef:	56                   	push   %esi
  8010f0:	57                   	push   %edi
  8010f1:	56                   	push   %esi
  8010f2:	6a 00                	push   $0x0
  8010f4:	e8 bd fc ff ff       	call   800db6 <sys_page_map>
  8010f9:	83 c4 20             	add    $0x20,%esp
  8010fc:	85 c0                	test   %eax,%eax
  8010fe:	0f 88 bc 00 00 00    	js     8011c0 <fork+0x160>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  801104:	83 ec 0c             	sub    $0xc,%esp
  801107:	68 05 08 00 00       	push   $0x805
  80110c:	56                   	push   %esi
  80110d:	6a 00                	push   $0x0
  80110f:	56                   	push   %esi
  801110:	6a 00                	push   $0x0
  801112:	e8 9f fc ff ff       	call   800db6 <sys_page_map>
  801117:	83 c4 20             	add    $0x20,%esp
  80111a:	85 c0                	test   %eax,%eax
  80111c:	0f 88 b3 00 00 00    	js     8011d5 <fork+0x175>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801122:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801128:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80112e:	0f 84 b6 00 00 00    	je     8011ea <fork+0x18a>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  801134:	89 d8                	mov    %ebx,%eax
  801136:	c1 e8 16             	shr    $0x16,%eax
  801139:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801140:	a8 01                	test   $0x1,%al
  801142:	74 de                	je     801122 <fork+0xc2>
  801144:	89 de                	mov    %ebx,%esi
  801146:	c1 ee 0c             	shr    $0xc,%esi
  801149:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801150:	a8 01                	test   $0x1,%al
  801152:	74 ce                	je     801122 <fork+0xc2>
  801154:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80115b:	a8 04                	test   $0x4,%al
  80115d:	74 c3                	je     801122 <fork+0xc2>
	if ((uvpt[pn] & PTE_SHARE)){
  80115f:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801166:	f6 c4 04             	test   $0x4,%ah
  801169:	0f 85 5b ff ff ff    	jne    8010ca <fork+0x6a>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  80116f:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801176:	a8 02                	test   $0x2,%al
  801178:	0f 85 66 ff ff ff    	jne    8010e4 <fork+0x84>
  80117e:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801185:	f6 c4 08             	test   $0x8,%ah
  801188:	0f 85 56 ff ff ff    	jne    8010e4 <fork+0x84>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  80118e:	c1 e6 0c             	shl    $0xc,%esi
  801191:	83 ec 0c             	sub    $0xc,%esp
  801194:	6a 05                	push   $0x5
  801196:	56                   	push   %esi
  801197:	57                   	push   %edi
  801198:	56                   	push   %esi
  801199:	6a 00                	push   $0x0
  80119b:	e8 16 fc ff ff       	call   800db6 <sys_page_map>
  8011a0:	83 c4 20             	add    $0x20,%esp
  8011a3:	85 c0                	test   %eax,%eax
  8011a5:	0f 89 77 ff ff ff    	jns    801122 <fork+0xc2>
		panic("duppage: %e\n", r);
  8011ab:	50                   	push   %eax
  8011ac:	68 8e 28 80 00       	push   $0x80288e
  8011b1:	68 0c 01 00 00       	push   $0x10c
  8011b6:	68 66 28 80 00       	push   $0x802866
  8011bb:	e8 7c f0 ff ff       	call   80023c <_panic>
			panic("duppage: %e\n", r);
  8011c0:	50                   	push   %eax
  8011c1:	68 8e 28 80 00       	push   $0x80288e
  8011c6:	68 05 01 00 00       	push   $0x105
  8011cb:	68 66 28 80 00       	push   $0x802866
  8011d0:	e8 67 f0 ff ff       	call   80023c <_panic>
			panic("duppage: %e\n", r);
  8011d5:	50                   	push   %eax
  8011d6:	68 8e 28 80 00       	push   $0x80288e
  8011db:	68 09 01 00 00       	push   $0x109
  8011e0:	68 66 28 80 00       	push   $0x802866
  8011e5:	e8 52 f0 ff ff       	call   80023c <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  8011ea:	83 ec 04             	sub    $0x4,%esp
  8011ed:	6a 07                	push   $0x7
  8011ef:	68 00 f0 bf ee       	push   $0xeebff000
  8011f4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011f7:	e8 73 fb ff ff       	call   800d6f <sys_page_alloc>
  8011fc:	83 c4 10             	add    $0x10,%esp
  8011ff:	85 c0                	test   %eax,%eax
  801201:	78 2e                	js     801231 <fork+0x1d1>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801203:	83 ec 08             	sub    $0x8,%esp
  801206:	68 31 20 80 00       	push   $0x802031
  80120b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80120e:	57                   	push   %edi
  80120f:	e8 ba fc ff ff       	call   800ece <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801214:	83 c4 08             	add    $0x8,%esp
  801217:	6a 02                	push   $0x2
  801219:	57                   	push   %edi
  80121a:	e8 23 fc ff ff       	call   800e42 <sys_env_set_status>
  80121f:	83 c4 10             	add    $0x10,%esp
  801222:	85 c0                	test   %eax,%eax
  801224:	78 20                	js     801246 <fork+0x1e6>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  801226:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801229:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80122c:	5b                   	pop    %ebx
  80122d:	5e                   	pop    %esi
  80122e:	5f                   	pop    %edi
  80122f:	5d                   	pop    %ebp
  801230:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  801231:	50                   	push   %eax
  801232:	68 9b 28 80 00       	push   $0x80289b
  801237:	68 3e 01 00 00       	push   $0x13e
  80123c:	68 66 28 80 00       	push   $0x802866
  801241:	e8 f6 ef ff ff       	call   80023c <_panic>
		panic("sys_env_set_status: %e", r);
  801246:	50                   	push   %eax
  801247:	68 ae 28 80 00       	push   $0x8028ae
  80124c:	68 43 01 00 00       	push   $0x143
  801251:	68 66 28 80 00       	push   $0x802866
  801256:	e8 e1 ef ff ff       	call   80023c <_panic>

0080125b <sfork>:

// Challenge!
int
sfork(void)
{
  80125b:	f3 0f 1e fb          	endbr32 
  80125f:	55                   	push   %ebp
  801260:	89 e5                	mov    %esp,%ebp
  801262:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801265:	68 c5 28 80 00       	push   $0x8028c5
  80126a:	68 4c 01 00 00       	push   $0x14c
  80126f:	68 66 28 80 00       	push   $0x802866
  801274:	e8 c3 ef ff ff       	call   80023c <_panic>

00801279 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801279:	f3 0f 1e fb          	endbr32 
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801280:	8b 45 08             	mov    0x8(%ebp),%eax
  801283:	05 00 00 00 30       	add    $0x30000000,%eax
  801288:	c1 e8 0c             	shr    $0xc,%eax
}
  80128b:	5d                   	pop    %ebp
  80128c:	c3                   	ret    

0080128d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80128d:	f3 0f 1e fb          	endbr32 
  801291:	55                   	push   %ebp
  801292:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801294:	8b 45 08             	mov    0x8(%ebp),%eax
  801297:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80129c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012a1:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012a6:	5d                   	pop    %ebp
  8012a7:	c3                   	ret    

008012a8 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012a8:	f3 0f 1e fb          	endbr32 
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
  8012af:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012b4:	89 c2                	mov    %eax,%edx
  8012b6:	c1 ea 16             	shr    $0x16,%edx
  8012b9:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012c0:	f6 c2 01             	test   $0x1,%dl
  8012c3:	74 2d                	je     8012f2 <fd_alloc+0x4a>
  8012c5:	89 c2                	mov    %eax,%edx
  8012c7:	c1 ea 0c             	shr    $0xc,%edx
  8012ca:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012d1:	f6 c2 01             	test   $0x1,%dl
  8012d4:	74 1c                	je     8012f2 <fd_alloc+0x4a>
  8012d6:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8012db:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012e0:	75 d2                	jne    8012b4 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8012eb:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8012f0:	eb 0a                	jmp    8012fc <fd_alloc+0x54>
			*fd_store = fd;
  8012f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012f5:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012fc:	5d                   	pop    %ebp
  8012fd:	c3                   	ret    

008012fe <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8012fe:	f3 0f 1e fb          	endbr32 
  801302:	55                   	push   %ebp
  801303:	89 e5                	mov    %esp,%ebp
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801308:	83 f8 1f             	cmp    $0x1f,%eax
  80130b:	77 30                	ja     80133d <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80130d:	c1 e0 0c             	shl    $0xc,%eax
  801310:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801315:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80131b:	f6 c2 01             	test   $0x1,%dl
  80131e:	74 24                	je     801344 <fd_lookup+0x46>
  801320:	89 c2                	mov    %eax,%edx
  801322:	c1 ea 0c             	shr    $0xc,%edx
  801325:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80132c:	f6 c2 01             	test   $0x1,%dl
  80132f:	74 1a                	je     80134b <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801331:	8b 55 0c             	mov    0xc(%ebp),%edx
  801334:	89 02                	mov    %eax,(%edx)
	return 0;
  801336:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80133b:	5d                   	pop    %ebp
  80133c:	c3                   	ret    
		return -E_INVAL;
  80133d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801342:	eb f7                	jmp    80133b <fd_lookup+0x3d>
		return -E_INVAL;
  801344:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801349:	eb f0                	jmp    80133b <fd_lookup+0x3d>
  80134b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801350:	eb e9                	jmp    80133b <fd_lookup+0x3d>

00801352 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801352:	f3 0f 1e fb          	endbr32 
  801356:	55                   	push   %ebp
  801357:	89 e5                	mov    %esp,%ebp
  801359:	83 ec 08             	sub    $0x8,%esp
  80135c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80135f:	ba 58 29 80 00       	mov    $0x802958,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801364:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801369:	39 08                	cmp    %ecx,(%eax)
  80136b:	74 33                	je     8013a0 <dev_lookup+0x4e>
  80136d:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801370:	8b 02                	mov    (%edx),%eax
  801372:	85 c0                	test   %eax,%eax
  801374:	75 f3                	jne    801369 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801376:	a1 04 40 80 00       	mov    0x804004,%eax
  80137b:	8b 40 48             	mov    0x48(%eax),%eax
  80137e:	83 ec 04             	sub    $0x4,%esp
  801381:	51                   	push   %ecx
  801382:	50                   	push   %eax
  801383:	68 dc 28 80 00       	push   $0x8028dc
  801388:	e8 96 ef ff ff       	call   800323 <cprintf>
	*dev = 0;
  80138d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801390:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801396:	83 c4 10             	add    $0x10,%esp
  801399:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80139e:	c9                   	leave  
  80139f:	c3                   	ret    
			*dev = devtab[i];
  8013a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013a3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8013aa:	eb f2                	jmp    80139e <dev_lookup+0x4c>

008013ac <fd_close>:
{
  8013ac:	f3 0f 1e fb          	endbr32 
  8013b0:	55                   	push   %ebp
  8013b1:	89 e5                	mov    %esp,%ebp
  8013b3:	57                   	push   %edi
  8013b4:	56                   	push   %esi
  8013b5:	53                   	push   %ebx
  8013b6:	83 ec 24             	sub    $0x24,%esp
  8013b9:	8b 75 08             	mov    0x8(%ebp),%esi
  8013bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013bf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013c2:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013c3:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8013c9:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013cc:	50                   	push   %eax
  8013cd:	e8 2c ff ff ff       	call   8012fe <fd_lookup>
  8013d2:	89 c3                	mov    %eax,%ebx
  8013d4:	83 c4 10             	add    $0x10,%esp
  8013d7:	85 c0                	test   %eax,%eax
  8013d9:	78 05                	js     8013e0 <fd_close+0x34>
	    || fd != fd2)
  8013db:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8013de:	74 16                	je     8013f6 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8013e0:	89 f8                	mov    %edi,%eax
  8013e2:	84 c0                	test   %al,%al
  8013e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e9:	0f 44 d8             	cmove  %eax,%ebx
}
  8013ec:	89 d8                	mov    %ebx,%eax
  8013ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013f1:	5b                   	pop    %ebx
  8013f2:	5e                   	pop    %esi
  8013f3:	5f                   	pop    %edi
  8013f4:	5d                   	pop    %ebp
  8013f5:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8013f6:	83 ec 08             	sub    $0x8,%esp
  8013f9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8013fc:	50                   	push   %eax
  8013fd:	ff 36                	pushl  (%esi)
  8013ff:	e8 4e ff ff ff       	call   801352 <dev_lookup>
  801404:	89 c3                	mov    %eax,%ebx
  801406:	83 c4 10             	add    $0x10,%esp
  801409:	85 c0                	test   %eax,%eax
  80140b:	78 1a                	js     801427 <fd_close+0x7b>
		if (dev->dev_close)
  80140d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801410:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801413:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801418:	85 c0                	test   %eax,%eax
  80141a:	74 0b                	je     801427 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80141c:	83 ec 0c             	sub    $0xc,%esp
  80141f:	56                   	push   %esi
  801420:	ff d0                	call   *%eax
  801422:	89 c3                	mov    %eax,%ebx
  801424:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801427:	83 ec 08             	sub    $0x8,%esp
  80142a:	56                   	push   %esi
  80142b:	6a 00                	push   $0x0
  80142d:	e8 ca f9 ff ff       	call   800dfc <sys_page_unmap>
	return r;
  801432:	83 c4 10             	add    $0x10,%esp
  801435:	eb b5                	jmp    8013ec <fd_close+0x40>

00801437 <close>:

int
close(int fdnum)
{
  801437:	f3 0f 1e fb          	endbr32 
  80143b:	55                   	push   %ebp
  80143c:	89 e5                	mov    %esp,%ebp
  80143e:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801441:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801444:	50                   	push   %eax
  801445:	ff 75 08             	pushl  0x8(%ebp)
  801448:	e8 b1 fe ff ff       	call   8012fe <fd_lookup>
  80144d:	83 c4 10             	add    $0x10,%esp
  801450:	85 c0                	test   %eax,%eax
  801452:	79 02                	jns    801456 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801454:	c9                   	leave  
  801455:	c3                   	ret    
		return fd_close(fd, 1);
  801456:	83 ec 08             	sub    $0x8,%esp
  801459:	6a 01                	push   $0x1
  80145b:	ff 75 f4             	pushl  -0xc(%ebp)
  80145e:	e8 49 ff ff ff       	call   8013ac <fd_close>
  801463:	83 c4 10             	add    $0x10,%esp
  801466:	eb ec                	jmp    801454 <close+0x1d>

00801468 <close_all>:

void
close_all(void)
{
  801468:	f3 0f 1e fb          	endbr32 
  80146c:	55                   	push   %ebp
  80146d:	89 e5                	mov    %esp,%ebp
  80146f:	53                   	push   %ebx
  801470:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801473:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801478:	83 ec 0c             	sub    $0xc,%esp
  80147b:	53                   	push   %ebx
  80147c:	e8 b6 ff ff ff       	call   801437 <close>
	for (i = 0; i < MAXFD; i++)
  801481:	83 c3 01             	add    $0x1,%ebx
  801484:	83 c4 10             	add    $0x10,%esp
  801487:	83 fb 20             	cmp    $0x20,%ebx
  80148a:	75 ec                	jne    801478 <close_all+0x10>
}
  80148c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80148f:	c9                   	leave  
  801490:	c3                   	ret    

00801491 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801491:	f3 0f 1e fb          	endbr32 
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
  801498:	57                   	push   %edi
  801499:	56                   	push   %esi
  80149a:	53                   	push   %ebx
  80149b:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80149e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014a1:	50                   	push   %eax
  8014a2:	ff 75 08             	pushl  0x8(%ebp)
  8014a5:	e8 54 fe ff ff       	call   8012fe <fd_lookup>
  8014aa:	89 c3                	mov    %eax,%ebx
  8014ac:	83 c4 10             	add    $0x10,%esp
  8014af:	85 c0                	test   %eax,%eax
  8014b1:	0f 88 81 00 00 00    	js     801538 <dup+0xa7>
		return r;
	close(newfdnum);
  8014b7:	83 ec 0c             	sub    $0xc,%esp
  8014ba:	ff 75 0c             	pushl  0xc(%ebp)
  8014bd:	e8 75 ff ff ff       	call   801437 <close>

	newfd = INDEX2FD(newfdnum);
  8014c2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014c5:	c1 e6 0c             	shl    $0xc,%esi
  8014c8:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8014ce:	83 c4 04             	add    $0x4,%esp
  8014d1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014d4:	e8 b4 fd ff ff       	call   80128d <fd2data>
  8014d9:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8014db:	89 34 24             	mov    %esi,(%esp)
  8014de:	e8 aa fd ff ff       	call   80128d <fd2data>
  8014e3:	83 c4 10             	add    $0x10,%esp
  8014e6:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8014e8:	89 d8                	mov    %ebx,%eax
  8014ea:	c1 e8 16             	shr    $0x16,%eax
  8014ed:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014f4:	a8 01                	test   $0x1,%al
  8014f6:	74 11                	je     801509 <dup+0x78>
  8014f8:	89 d8                	mov    %ebx,%eax
  8014fa:	c1 e8 0c             	shr    $0xc,%eax
  8014fd:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801504:	f6 c2 01             	test   $0x1,%dl
  801507:	75 39                	jne    801542 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801509:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80150c:	89 d0                	mov    %edx,%eax
  80150e:	c1 e8 0c             	shr    $0xc,%eax
  801511:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801518:	83 ec 0c             	sub    $0xc,%esp
  80151b:	25 07 0e 00 00       	and    $0xe07,%eax
  801520:	50                   	push   %eax
  801521:	56                   	push   %esi
  801522:	6a 00                	push   $0x0
  801524:	52                   	push   %edx
  801525:	6a 00                	push   $0x0
  801527:	e8 8a f8 ff ff       	call   800db6 <sys_page_map>
  80152c:	89 c3                	mov    %eax,%ebx
  80152e:	83 c4 20             	add    $0x20,%esp
  801531:	85 c0                	test   %eax,%eax
  801533:	78 31                	js     801566 <dup+0xd5>
		goto err;

	return newfdnum;
  801535:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801538:	89 d8                	mov    %ebx,%eax
  80153a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80153d:	5b                   	pop    %ebx
  80153e:	5e                   	pop    %esi
  80153f:	5f                   	pop    %edi
  801540:	5d                   	pop    %ebp
  801541:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801542:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801549:	83 ec 0c             	sub    $0xc,%esp
  80154c:	25 07 0e 00 00       	and    $0xe07,%eax
  801551:	50                   	push   %eax
  801552:	57                   	push   %edi
  801553:	6a 00                	push   $0x0
  801555:	53                   	push   %ebx
  801556:	6a 00                	push   $0x0
  801558:	e8 59 f8 ff ff       	call   800db6 <sys_page_map>
  80155d:	89 c3                	mov    %eax,%ebx
  80155f:	83 c4 20             	add    $0x20,%esp
  801562:	85 c0                	test   %eax,%eax
  801564:	79 a3                	jns    801509 <dup+0x78>
	sys_page_unmap(0, newfd);
  801566:	83 ec 08             	sub    $0x8,%esp
  801569:	56                   	push   %esi
  80156a:	6a 00                	push   $0x0
  80156c:	e8 8b f8 ff ff       	call   800dfc <sys_page_unmap>
	sys_page_unmap(0, nva);
  801571:	83 c4 08             	add    $0x8,%esp
  801574:	57                   	push   %edi
  801575:	6a 00                	push   $0x0
  801577:	e8 80 f8 ff ff       	call   800dfc <sys_page_unmap>
	return r;
  80157c:	83 c4 10             	add    $0x10,%esp
  80157f:	eb b7                	jmp    801538 <dup+0xa7>

00801581 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801581:	f3 0f 1e fb          	endbr32 
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
  801588:	53                   	push   %ebx
  801589:	83 ec 1c             	sub    $0x1c,%esp
  80158c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80158f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801592:	50                   	push   %eax
  801593:	53                   	push   %ebx
  801594:	e8 65 fd ff ff       	call   8012fe <fd_lookup>
  801599:	83 c4 10             	add    $0x10,%esp
  80159c:	85 c0                	test   %eax,%eax
  80159e:	78 3f                	js     8015df <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015a0:	83 ec 08             	sub    $0x8,%esp
  8015a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015a6:	50                   	push   %eax
  8015a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015aa:	ff 30                	pushl  (%eax)
  8015ac:	e8 a1 fd ff ff       	call   801352 <dev_lookup>
  8015b1:	83 c4 10             	add    $0x10,%esp
  8015b4:	85 c0                	test   %eax,%eax
  8015b6:	78 27                	js     8015df <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015bb:	8b 42 08             	mov    0x8(%edx),%eax
  8015be:	83 e0 03             	and    $0x3,%eax
  8015c1:	83 f8 01             	cmp    $0x1,%eax
  8015c4:	74 1e                	je     8015e4 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8015c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c9:	8b 40 08             	mov    0x8(%eax),%eax
  8015cc:	85 c0                	test   %eax,%eax
  8015ce:	74 35                	je     801605 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8015d0:	83 ec 04             	sub    $0x4,%esp
  8015d3:	ff 75 10             	pushl  0x10(%ebp)
  8015d6:	ff 75 0c             	pushl  0xc(%ebp)
  8015d9:	52                   	push   %edx
  8015da:	ff d0                	call   *%eax
  8015dc:	83 c4 10             	add    $0x10,%esp
}
  8015df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015e2:	c9                   	leave  
  8015e3:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8015e4:	a1 04 40 80 00       	mov    0x804004,%eax
  8015e9:	8b 40 48             	mov    0x48(%eax),%eax
  8015ec:	83 ec 04             	sub    $0x4,%esp
  8015ef:	53                   	push   %ebx
  8015f0:	50                   	push   %eax
  8015f1:	68 1d 29 80 00       	push   $0x80291d
  8015f6:	e8 28 ed ff ff       	call   800323 <cprintf>
		return -E_INVAL;
  8015fb:	83 c4 10             	add    $0x10,%esp
  8015fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801603:	eb da                	jmp    8015df <read+0x5e>
		return -E_NOT_SUPP;
  801605:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80160a:	eb d3                	jmp    8015df <read+0x5e>

0080160c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80160c:	f3 0f 1e fb          	endbr32 
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
  801613:	57                   	push   %edi
  801614:	56                   	push   %esi
  801615:	53                   	push   %ebx
  801616:	83 ec 0c             	sub    $0xc,%esp
  801619:	8b 7d 08             	mov    0x8(%ebp),%edi
  80161c:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80161f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801624:	eb 02                	jmp    801628 <readn+0x1c>
  801626:	01 c3                	add    %eax,%ebx
  801628:	39 f3                	cmp    %esi,%ebx
  80162a:	73 21                	jae    80164d <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80162c:	83 ec 04             	sub    $0x4,%esp
  80162f:	89 f0                	mov    %esi,%eax
  801631:	29 d8                	sub    %ebx,%eax
  801633:	50                   	push   %eax
  801634:	89 d8                	mov    %ebx,%eax
  801636:	03 45 0c             	add    0xc(%ebp),%eax
  801639:	50                   	push   %eax
  80163a:	57                   	push   %edi
  80163b:	e8 41 ff ff ff       	call   801581 <read>
		if (m < 0)
  801640:	83 c4 10             	add    $0x10,%esp
  801643:	85 c0                	test   %eax,%eax
  801645:	78 04                	js     80164b <readn+0x3f>
			return m;
		if (m == 0)
  801647:	75 dd                	jne    801626 <readn+0x1a>
  801649:	eb 02                	jmp    80164d <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80164b:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80164d:	89 d8                	mov    %ebx,%eax
  80164f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801652:	5b                   	pop    %ebx
  801653:	5e                   	pop    %esi
  801654:	5f                   	pop    %edi
  801655:	5d                   	pop    %ebp
  801656:	c3                   	ret    

00801657 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801657:	f3 0f 1e fb          	endbr32 
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
  80165e:	53                   	push   %ebx
  80165f:	83 ec 1c             	sub    $0x1c,%esp
  801662:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801665:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801668:	50                   	push   %eax
  801669:	53                   	push   %ebx
  80166a:	e8 8f fc ff ff       	call   8012fe <fd_lookup>
  80166f:	83 c4 10             	add    $0x10,%esp
  801672:	85 c0                	test   %eax,%eax
  801674:	78 3a                	js     8016b0 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801676:	83 ec 08             	sub    $0x8,%esp
  801679:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80167c:	50                   	push   %eax
  80167d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801680:	ff 30                	pushl  (%eax)
  801682:	e8 cb fc ff ff       	call   801352 <dev_lookup>
  801687:	83 c4 10             	add    $0x10,%esp
  80168a:	85 c0                	test   %eax,%eax
  80168c:	78 22                	js     8016b0 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80168e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801691:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801695:	74 1e                	je     8016b5 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801697:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80169a:	8b 52 0c             	mov    0xc(%edx),%edx
  80169d:	85 d2                	test   %edx,%edx
  80169f:	74 35                	je     8016d6 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8016a1:	83 ec 04             	sub    $0x4,%esp
  8016a4:	ff 75 10             	pushl  0x10(%ebp)
  8016a7:	ff 75 0c             	pushl  0xc(%ebp)
  8016aa:	50                   	push   %eax
  8016ab:	ff d2                	call   *%edx
  8016ad:	83 c4 10             	add    $0x10,%esp
}
  8016b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016b3:	c9                   	leave  
  8016b4:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016b5:	a1 04 40 80 00       	mov    0x804004,%eax
  8016ba:	8b 40 48             	mov    0x48(%eax),%eax
  8016bd:	83 ec 04             	sub    $0x4,%esp
  8016c0:	53                   	push   %ebx
  8016c1:	50                   	push   %eax
  8016c2:	68 39 29 80 00       	push   $0x802939
  8016c7:	e8 57 ec ff ff       	call   800323 <cprintf>
		return -E_INVAL;
  8016cc:	83 c4 10             	add    $0x10,%esp
  8016cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016d4:	eb da                	jmp    8016b0 <write+0x59>
		return -E_NOT_SUPP;
  8016d6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016db:	eb d3                	jmp    8016b0 <write+0x59>

008016dd <seek>:

int
seek(int fdnum, off_t offset)
{
  8016dd:	f3 0f 1e fb          	endbr32 
  8016e1:	55                   	push   %ebp
  8016e2:	89 e5                	mov    %esp,%ebp
  8016e4:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016ea:	50                   	push   %eax
  8016eb:	ff 75 08             	pushl  0x8(%ebp)
  8016ee:	e8 0b fc ff ff       	call   8012fe <fd_lookup>
  8016f3:	83 c4 10             	add    $0x10,%esp
  8016f6:	85 c0                	test   %eax,%eax
  8016f8:	78 0e                	js     801708 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8016fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801700:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801703:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801708:	c9                   	leave  
  801709:	c3                   	ret    

0080170a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80170a:	f3 0f 1e fb          	endbr32 
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
  801711:	53                   	push   %ebx
  801712:	83 ec 1c             	sub    $0x1c,%esp
  801715:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801718:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80171b:	50                   	push   %eax
  80171c:	53                   	push   %ebx
  80171d:	e8 dc fb ff ff       	call   8012fe <fd_lookup>
  801722:	83 c4 10             	add    $0x10,%esp
  801725:	85 c0                	test   %eax,%eax
  801727:	78 37                	js     801760 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801729:	83 ec 08             	sub    $0x8,%esp
  80172c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80172f:	50                   	push   %eax
  801730:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801733:	ff 30                	pushl  (%eax)
  801735:	e8 18 fc ff ff       	call   801352 <dev_lookup>
  80173a:	83 c4 10             	add    $0x10,%esp
  80173d:	85 c0                	test   %eax,%eax
  80173f:	78 1f                	js     801760 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801741:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801744:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801748:	74 1b                	je     801765 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80174a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80174d:	8b 52 18             	mov    0x18(%edx),%edx
  801750:	85 d2                	test   %edx,%edx
  801752:	74 32                	je     801786 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801754:	83 ec 08             	sub    $0x8,%esp
  801757:	ff 75 0c             	pushl  0xc(%ebp)
  80175a:	50                   	push   %eax
  80175b:	ff d2                	call   *%edx
  80175d:	83 c4 10             	add    $0x10,%esp
}
  801760:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801763:	c9                   	leave  
  801764:	c3                   	ret    
			thisenv->env_id, fdnum);
  801765:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80176a:	8b 40 48             	mov    0x48(%eax),%eax
  80176d:	83 ec 04             	sub    $0x4,%esp
  801770:	53                   	push   %ebx
  801771:	50                   	push   %eax
  801772:	68 fc 28 80 00       	push   $0x8028fc
  801777:	e8 a7 eb ff ff       	call   800323 <cprintf>
		return -E_INVAL;
  80177c:	83 c4 10             	add    $0x10,%esp
  80177f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801784:	eb da                	jmp    801760 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801786:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80178b:	eb d3                	jmp    801760 <ftruncate+0x56>

0080178d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80178d:	f3 0f 1e fb          	endbr32 
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
  801794:	53                   	push   %ebx
  801795:	83 ec 1c             	sub    $0x1c,%esp
  801798:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80179b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80179e:	50                   	push   %eax
  80179f:	ff 75 08             	pushl  0x8(%ebp)
  8017a2:	e8 57 fb ff ff       	call   8012fe <fd_lookup>
  8017a7:	83 c4 10             	add    $0x10,%esp
  8017aa:	85 c0                	test   %eax,%eax
  8017ac:	78 4b                	js     8017f9 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017ae:	83 ec 08             	sub    $0x8,%esp
  8017b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017b4:	50                   	push   %eax
  8017b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b8:	ff 30                	pushl  (%eax)
  8017ba:	e8 93 fb ff ff       	call   801352 <dev_lookup>
  8017bf:	83 c4 10             	add    $0x10,%esp
  8017c2:	85 c0                	test   %eax,%eax
  8017c4:	78 33                	js     8017f9 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8017c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c9:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8017cd:	74 2f                	je     8017fe <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017cf:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017d2:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017d9:	00 00 00 
	stat->st_isdir = 0;
  8017dc:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017e3:	00 00 00 
	stat->st_dev = dev;
  8017e6:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8017ec:	83 ec 08             	sub    $0x8,%esp
  8017ef:	53                   	push   %ebx
  8017f0:	ff 75 f0             	pushl  -0x10(%ebp)
  8017f3:	ff 50 14             	call   *0x14(%eax)
  8017f6:	83 c4 10             	add    $0x10,%esp
}
  8017f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    
		return -E_NOT_SUPP;
  8017fe:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801803:	eb f4                	jmp    8017f9 <fstat+0x6c>

00801805 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801805:	f3 0f 1e fb          	endbr32 
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
  80180c:	56                   	push   %esi
  80180d:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80180e:	83 ec 08             	sub    $0x8,%esp
  801811:	6a 00                	push   $0x0
  801813:	ff 75 08             	pushl  0x8(%ebp)
  801816:	e8 fb 01 00 00       	call   801a16 <open>
  80181b:	89 c3                	mov    %eax,%ebx
  80181d:	83 c4 10             	add    $0x10,%esp
  801820:	85 c0                	test   %eax,%eax
  801822:	78 1b                	js     80183f <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801824:	83 ec 08             	sub    $0x8,%esp
  801827:	ff 75 0c             	pushl  0xc(%ebp)
  80182a:	50                   	push   %eax
  80182b:	e8 5d ff ff ff       	call   80178d <fstat>
  801830:	89 c6                	mov    %eax,%esi
	close(fd);
  801832:	89 1c 24             	mov    %ebx,(%esp)
  801835:	e8 fd fb ff ff       	call   801437 <close>
	return r;
  80183a:	83 c4 10             	add    $0x10,%esp
  80183d:	89 f3                	mov    %esi,%ebx
}
  80183f:	89 d8                	mov    %ebx,%eax
  801841:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801844:	5b                   	pop    %ebx
  801845:	5e                   	pop    %esi
  801846:	5d                   	pop    %ebp
  801847:	c3                   	ret    

00801848 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
  80184b:	56                   	push   %esi
  80184c:	53                   	push   %ebx
  80184d:	89 c6                	mov    %eax,%esi
  80184f:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801851:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801858:	74 27                	je     801881 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80185a:	6a 07                	push   $0x7
  80185c:	68 00 50 80 00       	push   $0x805000
  801861:	56                   	push   %esi
  801862:	ff 35 00 40 80 00    	pushl  0x804000
  801868:	e8 6f 08 00 00       	call   8020dc <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80186d:	83 c4 0c             	add    $0xc,%esp
  801870:	6a 00                	push   $0x0
  801872:	53                   	push   %ebx
  801873:	6a 00                	push   $0x0
  801875:	e8 dd 07 00 00       	call   802057 <ipc_recv>
}
  80187a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80187d:	5b                   	pop    %ebx
  80187e:	5e                   	pop    %esi
  80187f:	5d                   	pop    %ebp
  801880:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801881:	83 ec 0c             	sub    $0xc,%esp
  801884:	6a 01                	push   $0x1
  801886:	e8 a9 08 00 00       	call   802134 <ipc_find_env>
  80188b:	a3 00 40 80 00       	mov    %eax,0x804000
  801890:	83 c4 10             	add    $0x10,%esp
  801893:	eb c5                	jmp    80185a <fsipc+0x12>

00801895 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801895:	f3 0f 1e fb          	endbr32 
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
  80189c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80189f:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8018a5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8018aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ad:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b7:	b8 02 00 00 00       	mov    $0x2,%eax
  8018bc:	e8 87 ff ff ff       	call   801848 <fsipc>
}
  8018c1:	c9                   	leave  
  8018c2:	c3                   	ret    

008018c3 <devfile_flush>:
{
  8018c3:	f3 0f 1e fb          	endbr32 
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
  8018ca:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8018d3:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8018d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8018dd:	b8 06 00 00 00       	mov    $0x6,%eax
  8018e2:	e8 61 ff ff ff       	call   801848 <fsipc>
}
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

008018e9 <devfile_stat>:
{
  8018e9:	f3 0f 1e fb          	endbr32 
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
  8018f0:	53                   	push   %ebx
  8018f1:	83 ec 04             	sub    $0x4,%esp
  8018f4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8018f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8018fd:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801902:	ba 00 00 00 00       	mov    $0x0,%edx
  801907:	b8 05 00 00 00       	mov    $0x5,%eax
  80190c:	e8 37 ff ff ff       	call   801848 <fsipc>
  801911:	85 c0                	test   %eax,%eax
  801913:	78 2c                	js     801941 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801915:	83 ec 08             	sub    $0x8,%esp
  801918:	68 00 50 80 00       	push   $0x805000
  80191d:	53                   	push   %ebx
  80191e:	e8 0a f0 ff ff       	call   80092d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801923:	a1 80 50 80 00       	mov    0x805080,%eax
  801928:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80192e:	a1 84 50 80 00       	mov    0x805084,%eax
  801933:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801939:	83 c4 10             	add    $0x10,%esp
  80193c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801941:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <devfile_write>:
{
  801946:	f3 0f 1e fb          	endbr32 
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	83 ec 0c             	sub    $0xc,%esp
  801950:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801953:	8b 55 08             	mov    0x8(%ebp),%edx
  801956:	8b 52 0c             	mov    0xc(%edx),%edx
  801959:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  80195f:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801964:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801969:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  80196c:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801971:	50                   	push   %eax
  801972:	ff 75 0c             	pushl  0xc(%ebp)
  801975:	68 08 50 80 00       	push   $0x805008
  80197a:	e8 64 f1 ff ff       	call   800ae3 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  80197f:	ba 00 00 00 00       	mov    $0x0,%edx
  801984:	b8 04 00 00 00       	mov    $0x4,%eax
  801989:	e8 ba fe ff ff       	call   801848 <fsipc>
}
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <devfile_read>:
{
  801990:	f3 0f 1e fb          	endbr32 
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
  801997:	56                   	push   %esi
  801998:	53                   	push   %ebx
  801999:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	8b 40 0c             	mov    0xc(%eax),%eax
  8019a2:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8019a7:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b2:	b8 03 00 00 00       	mov    $0x3,%eax
  8019b7:	e8 8c fe ff ff       	call   801848 <fsipc>
  8019bc:	89 c3                	mov    %eax,%ebx
  8019be:	85 c0                	test   %eax,%eax
  8019c0:	78 1f                	js     8019e1 <devfile_read+0x51>
	assert(r <= n);
  8019c2:	39 f0                	cmp    %esi,%eax
  8019c4:	77 24                	ja     8019ea <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8019c6:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019cb:	7f 33                	jg     801a00 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019cd:	83 ec 04             	sub    $0x4,%esp
  8019d0:	50                   	push   %eax
  8019d1:	68 00 50 80 00       	push   $0x805000
  8019d6:	ff 75 0c             	pushl  0xc(%ebp)
  8019d9:	e8 05 f1 ff ff       	call   800ae3 <memmove>
	return r;
  8019de:	83 c4 10             	add    $0x10,%esp
}
  8019e1:	89 d8                	mov    %ebx,%eax
  8019e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019e6:	5b                   	pop    %ebx
  8019e7:	5e                   	pop    %esi
  8019e8:	5d                   	pop    %ebp
  8019e9:	c3                   	ret    
	assert(r <= n);
  8019ea:	68 68 29 80 00       	push   $0x802968
  8019ef:	68 6f 29 80 00       	push   $0x80296f
  8019f4:	6a 7c                	push   $0x7c
  8019f6:	68 84 29 80 00       	push   $0x802984
  8019fb:	e8 3c e8 ff ff       	call   80023c <_panic>
	assert(r <= PGSIZE);
  801a00:	68 8f 29 80 00       	push   $0x80298f
  801a05:	68 6f 29 80 00       	push   $0x80296f
  801a0a:	6a 7d                	push   $0x7d
  801a0c:	68 84 29 80 00       	push   $0x802984
  801a11:	e8 26 e8 ff ff       	call   80023c <_panic>

00801a16 <open>:
{
  801a16:	f3 0f 1e fb          	endbr32 
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
  801a1d:	56                   	push   %esi
  801a1e:	53                   	push   %ebx
  801a1f:	83 ec 1c             	sub    $0x1c,%esp
  801a22:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a25:	56                   	push   %esi
  801a26:	e8 bf ee ff ff       	call   8008ea <strlen>
  801a2b:	83 c4 10             	add    $0x10,%esp
  801a2e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a33:	7f 6c                	jg     801aa1 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801a35:	83 ec 0c             	sub    $0xc,%esp
  801a38:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a3b:	50                   	push   %eax
  801a3c:	e8 67 f8 ff ff       	call   8012a8 <fd_alloc>
  801a41:	89 c3                	mov    %eax,%ebx
  801a43:	83 c4 10             	add    $0x10,%esp
  801a46:	85 c0                	test   %eax,%eax
  801a48:	78 3c                	js     801a86 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801a4a:	83 ec 08             	sub    $0x8,%esp
  801a4d:	56                   	push   %esi
  801a4e:	68 00 50 80 00       	push   $0x805000
  801a53:	e8 d5 ee ff ff       	call   80092d <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a5b:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a63:	b8 01 00 00 00       	mov    $0x1,%eax
  801a68:	e8 db fd ff ff       	call   801848 <fsipc>
  801a6d:	89 c3                	mov    %eax,%ebx
  801a6f:	83 c4 10             	add    $0x10,%esp
  801a72:	85 c0                	test   %eax,%eax
  801a74:	78 19                	js     801a8f <open+0x79>
	return fd2num(fd);
  801a76:	83 ec 0c             	sub    $0xc,%esp
  801a79:	ff 75 f4             	pushl  -0xc(%ebp)
  801a7c:	e8 f8 f7 ff ff       	call   801279 <fd2num>
  801a81:	89 c3                	mov    %eax,%ebx
  801a83:	83 c4 10             	add    $0x10,%esp
}
  801a86:	89 d8                	mov    %ebx,%eax
  801a88:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a8b:	5b                   	pop    %ebx
  801a8c:	5e                   	pop    %esi
  801a8d:	5d                   	pop    %ebp
  801a8e:	c3                   	ret    
		fd_close(fd, 0);
  801a8f:	83 ec 08             	sub    $0x8,%esp
  801a92:	6a 00                	push   $0x0
  801a94:	ff 75 f4             	pushl  -0xc(%ebp)
  801a97:	e8 10 f9 ff ff       	call   8013ac <fd_close>
		return r;
  801a9c:	83 c4 10             	add    $0x10,%esp
  801a9f:	eb e5                	jmp    801a86 <open+0x70>
		return -E_BAD_PATH;
  801aa1:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801aa6:	eb de                	jmp    801a86 <open+0x70>

00801aa8 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801aa8:	f3 0f 1e fb          	endbr32 
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
  801aaf:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ab2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab7:	b8 08 00 00 00       	mov    $0x8,%eax
  801abc:	e8 87 fd ff ff       	call   801848 <fsipc>
}
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ac3:	f3 0f 1e fb          	endbr32 
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
  801aca:	56                   	push   %esi
  801acb:	53                   	push   %ebx
  801acc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801acf:	83 ec 0c             	sub    $0xc,%esp
  801ad2:	ff 75 08             	pushl  0x8(%ebp)
  801ad5:	e8 b3 f7 ff ff       	call   80128d <fd2data>
  801ada:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801adc:	83 c4 08             	add    $0x8,%esp
  801adf:	68 9b 29 80 00       	push   $0x80299b
  801ae4:	53                   	push   %ebx
  801ae5:	e8 43 ee ff ff       	call   80092d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801aea:	8b 46 04             	mov    0x4(%esi),%eax
  801aed:	2b 06                	sub    (%esi),%eax
  801aef:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801af5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801afc:	00 00 00 
	stat->st_dev = &devpipe;
  801aff:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801b06:	30 80 00 
	return 0;
}
  801b09:	b8 00 00 00 00       	mov    $0x0,%eax
  801b0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b11:	5b                   	pop    %ebx
  801b12:	5e                   	pop    %esi
  801b13:	5d                   	pop    %ebp
  801b14:	c3                   	ret    

00801b15 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b15:	f3 0f 1e fb          	endbr32 
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
  801b1c:	53                   	push   %ebx
  801b1d:	83 ec 0c             	sub    $0xc,%esp
  801b20:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b23:	53                   	push   %ebx
  801b24:	6a 00                	push   $0x0
  801b26:	e8 d1 f2 ff ff       	call   800dfc <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b2b:	89 1c 24             	mov    %ebx,(%esp)
  801b2e:	e8 5a f7 ff ff       	call   80128d <fd2data>
  801b33:	83 c4 08             	add    $0x8,%esp
  801b36:	50                   	push   %eax
  801b37:	6a 00                	push   $0x0
  801b39:	e8 be f2 ff ff       	call   800dfc <sys_page_unmap>
}
  801b3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b41:	c9                   	leave  
  801b42:	c3                   	ret    

00801b43 <_pipeisclosed>:
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
  801b46:	57                   	push   %edi
  801b47:	56                   	push   %esi
  801b48:	53                   	push   %ebx
  801b49:	83 ec 1c             	sub    $0x1c,%esp
  801b4c:	89 c7                	mov    %eax,%edi
  801b4e:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b50:	a1 04 40 80 00       	mov    0x804004,%eax
  801b55:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b58:	83 ec 0c             	sub    $0xc,%esp
  801b5b:	57                   	push   %edi
  801b5c:	e8 10 06 00 00       	call   802171 <pageref>
  801b61:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b64:	89 34 24             	mov    %esi,(%esp)
  801b67:	e8 05 06 00 00       	call   802171 <pageref>
		nn = thisenv->env_runs;
  801b6c:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b72:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b75:	83 c4 10             	add    $0x10,%esp
  801b78:	39 cb                	cmp    %ecx,%ebx
  801b7a:	74 1b                	je     801b97 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b7c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b7f:	75 cf                	jne    801b50 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b81:	8b 42 58             	mov    0x58(%edx),%eax
  801b84:	6a 01                	push   $0x1
  801b86:	50                   	push   %eax
  801b87:	53                   	push   %ebx
  801b88:	68 a2 29 80 00       	push   $0x8029a2
  801b8d:	e8 91 e7 ff ff       	call   800323 <cprintf>
  801b92:	83 c4 10             	add    $0x10,%esp
  801b95:	eb b9                	jmp    801b50 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801b97:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b9a:	0f 94 c0             	sete   %al
  801b9d:	0f b6 c0             	movzbl %al,%eax
}
  801ba0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ba3:	5b                   	pop    %ebx
  801ba4:	5e                   	pop    %esi
  801ba5:	5f                   	pop    %edi
  801ba6:	5d                   	pop    %ebp
  801ba7:	c3                   	ret    

00801ba8 <devpipe_write>:
{
  801ba8:	f3 0f 1e fb          	endbr32 
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
  801baf:	57                   	push   %edi
  801bb0:	56                   	push   %esi
  801bb1:	53                   	push   %ebx
  801bb2:	83 ec 28             	sub    $0x28,%esp
  801bb5:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801bb8:	56                   	push   %esi
  801bb9:	e8 cf f6 ff ff       	call   80128d <fd2data>
  801bbe:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801bc0:	83 c4 10             	add    $0x10,%esp
  801bc3:	bf 00 00 00 00       	mov    $0x0,%edi
  801bc8:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801bcb:	74 4f                	je     801c1c <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801bcd:	8b 43 04             	mov    0x4(%ebx),%eax
  801bd0:	8b 0b                	mov    (%ebx),%ecx
  801bd2:	8d 51 20             	lea    0x20(%ecx),%edx
  801bd5:	39 d0                	cmp    %edx,%eax
  801bd7:	72 14                	jb     801bed <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801bd9:	89 da                	mov    %ebx,%edx
  801bdb:	89 f0                	mov    %esi,%eax
  801bdd:	e8 61 ff ff ff       	call   801b43 <_pipeisclosed>
  801be2:	85 c0                	test   %eax,%eax
  801be4:	75 3b                	jne    801c21 <devpipe_write+0x79>
			sys_yield();
  801be6:	e8 61 f1 ff ff       	call   800d4c <sys_yield>
  801beb:	eb e0                	jmp    801bcd <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801bed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bf0:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801bf4:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801bf7:	89 c2                	mov    %eax,%edx
  801bf9:	c1 fa 1f             	sar    $0x1f,%edx
  801bfc:	89 d1                	mov    %edx,%ecx
  801bfe:	c1 e9 1b             	shr    $0x1b,%ecx
  801c01:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c04:	83 e2 1f             	and    $0x1f,%edx
  801c07:	29 ca                	sub    %ecx,%edx
  801c09:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c0d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c11:	83 c0 01             	add    $0x1,%eax
  801c14:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c17:	83 c7 01             	add    $0x1,%edi
  801c1a:	eb ac                	jmp    801bc8 <devpipe_write+0x20>
	return i;
  801c1c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c1f:	eb 05                	jmp    801c26 <devpipe_write+0x7e>
				return 0;
  801c21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c26:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c29:	5b                   	pop    %ebx
  801c2a:	5e                   	pop    %esi
  801c2b:	5f                   	pop    %edi
  801c2c:	5d                   	pop    %ebp
  801c2d:	c3                   	ret    

00801c2e <devpipe_read>:
{
  801c2e:	f3 0f 1e fb          	endbr32 
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
  801c35:	57                   	push   %edi
  801c36:	56                   	push   %esi
  801c37:	53                   	push   %ebx
  801c38:	83 ec 18             	sub    $0x18,%esp
  801c3b:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c3e:	57                   	push   %edi
  801c3f:	e8 49 f6 ff ff       	call   80128d <fd2data>
  801c44:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c46:	83 c4 10             	add    $0x10,%esp
  801c49:	be 00 00 00 00       	mov    $0x0,%esi
  801c4e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c51:	75 14                	jne    801c67 <devpipe_read+0x39>
	return i;
  801c53:	8b 45 10             	mov    0x10(%ebp),%eax
  801c56:	eb 02                	jmp    801c5a <devpipe_read+0x2c>
				return i;
  801c58:	89 f0                	mov    %esi,%eax
}
  801c5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c5d:	5b                   	pop    %ebx
  801c5e:	5e                   	pop    %esi
  801c5f:	5f                   	pop    %edi
  801c60:	5d                   	pop    %ebp
  801c61:	c3                   	ret    
			sys_yield();
  801c62:	e8 e5 f0 ff ff       	call   800d4c <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801c67:	8b 03                	mov    (%ebx),%eax
  801c69:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c6c:	75 18                	jne    801c86 <devpipe_read+0x58>
			if (i > 0)
  801c6e:	85 f6                	test   %esi,%esi
  801c70:	75 e6                	jne    801c58 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801c72:	89 da                	mov    %ebx,%edx
  801c74:	89 f8                	mov    %edi,%eax
  801c76:	e8 c8 fe ff ff       	call   801b43 <_pipeisclosed>
  801c7b:	85 c0                	test   %eax,%eax
  801c7d:	74 e3                	je     801c62 <devpipe_read+0x34>
				return 0;
  801c7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c84:	eb d4                	jmp    801c5a <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c86:	99                   	cltd   
  801c87:	c1 ea 1b             	shr    $0x1b,%edx
  801c8a:	01 d0                	add    %edx,%eax
  801c8c:	83 e0 1f             	and    $0x1f,%eax
  801c8f:	29 d0                	sub    %edx,%eax
  801c91:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801c96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c99:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801c9c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801c9f:	83 c6 01             	add    $0x1,%esi
  801ca2:	eb aa                	jmp    801c4e <devpipe_read+0x20>

00801ca4 <pipe>:
{
  801ca4:	f3 0f 1e fb          	endbr32 
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
  801cab:	56                   	push   %esi
  801cac:	53                   	push   %ebx
  801cad:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801cb0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cb3:	50                   	push   %eax
  801cb4:	e8 ef f5 ff ff       	call   8012a8 <fd_alloc>
  801cb9:	89 c3                	mov    %eax,%ebx
  801cbb:	83 c4 10             	add    $0x10,%esp
  801cbe:	85 c0                	test   %eax,%eax
  801cc0:	0f 88 23 01 00 00    	js     801de9 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cc6:	83 ec 04             	sub    $0x4,%esp
  801cc9:	68 07 04 00 00       	push   $0x407
  801cce:	ff 75 f4             	pushl  -0xc(%ebp)
  801cd1:	6a 00                	push   $0x0
  801cd3:	e8 97 f0 ff ff       	call   800d6f <sys_page_alloc>
  801cd8:	89 c3                	mov    %eax,%ebx
  801cda:	83 c4 10             	add    $0x10,%esp
  801cdd:	85 c0                	test   %eax,%eax
  801cdf:	0f 88 04 01 00 00    	js     801de9 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801ce5:	83 ec 0c             	sub    $0xc,%esp
  801ce8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ceb:	50                   	push   %eax
  801cec:	e8 b7 f5 ff ff       	call   8012a8 <fd_alloc>
  801cf1:	89 c3                	mov    %eax,%ebx
  801cf3:	83 c4 10             	add    $0x10,%esp
  801cf6:	85 c0                	test   %eax,%eax
  801cf8:	0f 88 db 00 00 00    	js     801dd9 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cfe:	83 ec 04             	sub    $0x4,%esp
  801d01:	68 07 04 00 00       	push   $0x407
  801d06:	ff 75 f0             	pushl  -0x10(%ebp)
  801d09:	6a 00                	push   $0x0
  801d0b:	e8 5f f0 ff ff       	call   800d6f <sys_page_alloc>
  801d10:	89 c3                	mov    %eax,%ebx
  801d12:	83 c4 10             	add    $0x10,%esp
  801d15:	85 c0                	test   %eax,%eax
  801d17:	0f 88 bc 00 00 00    	js     801dd9 <pipe+0x135>
	va = fd2data(fd0);
  801d1d:	83 ec 0c             	sub    $0xc,%esp
  801d20:	ff 75 f4             	pushl  -0xc(%ebp)
  801d23:	e8 65 f5 ff ff       	call   80128d <fd2data>
  801d28:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d2a:	83 c4 0c             	add    $0xc,%esp
  801d2d:	68 07 04 00 00       	push   $0x407
  801d32:	50                   	push   %eax
  801d33:	6a 00                	push   $0x0
  801d35:	e8 35 f0 ff ff       	call   800d6f <sys_page_alloc>
  801d3a:	89 c3                	mov    %eax,%ebx
  801d3c:	83 c4 10             	add    $0x10,%esp
  801d3f:	85 c0                	test   %eax,%eax
  801d41:	0f 88 82 00 00 00    	js     801dc9 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d47:	83 ec 0c             	sub    $0xc,%esp
  801d4a:	ff 75 f0             	pushl  -0x10(%ebp)
  801d4d:	e8 3b f5 ff ff       	call   80128d <fd2data>
  801d52:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d59:	50                   	push   %eax
  801d5a:	6a 00                	push   $0x0
  801d5c:	56                   	push   %esi
  801d5d:	6a 00                	push   $0x0
  801d5f:	e8 52 f0 ff ff       	call   800db6 <sys_page_map>
  801d64:	89 c3                	mov    %eax,%ebx
  801d66:	83 c4 20             	add    $0x20,%esp
  801d69:	85 c0                	test   %eax,%eax
  801d6b:	78 4e                	js     801dbb <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801d6d:	a1 20 30 80 00       	mov    0x803020,%eax
  801d72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d75:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801d77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d7a:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801d81:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d84:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d89:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801d90:	83 ec 0c             	sub    $0xc,%esp
  801d93:	ff 75 f4             	pushl  -0xc(%ebp)
  801d96:	e8 de f4 ff ff       	call   801279 <fd2num>
  801d9b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d9e:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801da0:	83 c4 04             	add    $0x4,%esp
  801da3:	ff 75 f0             	pushl  -0x10(%ebp)
  801da6:	e8 ce f4 ff ff       	call   801279 <fd2num>
  801dab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dae:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801db1:	83 c4 10             	add    $0x10,%esp
  801db4:	bb 00 00 00 00       	mov    $0x0,%ebx
  801db9:	eb 2e                	jmp    801de9 <pipe+0x145>
	sys_page_unmap(0, va);
  801dbb:	83 ec 08             	sub    $0x8,%esp
  801dbe:	56                   	push   %esi
  801dbf:	6a 00                	push   $0x0
  801dc1:	e8 36 f0 ff ff       	call   800dfc <sys_page_unmap>
  801dc6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801dc9:	83 ec 08             	sub    $0x8,%esp
  801dcc:	ff 75 f0             	pushl  -0x10(%ebp)
  801dcf:	6a 00                	push   $0x0
  801dd1:	e8 26 f0 ff ff       	call   800dfc <sys_page_unmap>
  801dd6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801dd9:	83 ec 08             	sub    $0x8,%esp
  801ddc:	ff 75 f4             	pushl  -0xc(%ebp)
  801ddf:	6a 00                	push   $0x0
  801de1:	e8 16 f0 ff ff       	call   800dfc <sys_page_unmap>
  801de6:	83 c4 10             	add    $0x10,%esp
}
  801de9:	89 d8                	mov    %ebx,%eax
  801deb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dee:	5b                   	pop    %ebx
  801def:	5e                   	pop    %esi
  801df0:	5d                   	pop    %ebp
  801df1:	c3                   	ret    

00801df2 <pipeisclosed>:
{
  801df2:	f3 0f 1e fb          	endbr32 
  801df6:	55                   	push   %ebp
  801df7:	89 e5                	mov    %esp,%ebp
  801df9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801dfc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dff:	50                   	push   %eax
  801e00:	ff 75 08             	pushl  0x8(%ebp)
  801e03:	e8 f6 f4 ff ff       	call   8012fe <fd_lookup>
  801e08:	83 c4 10             	add    $0x10,%esp
  801e0b:	85 c0                	test   %eax,%eax
  801e0d:	78 18                	js     801e27 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801e0f:	83 ec 0c             	sub    $0xc,%esp
  801e12:	ff 75 f4             	pushl  -0xc(%ebp)
  801e15:	e8 73 f4 ff ff       	call   80128d <fd2data>
  801e1a:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1f:	e8 1f fd ff ff       	call   801b43 <_pipeisclosed>
  801e24:	83 c4 10             	add    $0x10,%esp
}
  801e27:	c9                   	leave  
  801e28:	c3                   	ret    

00801e29 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801e29:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801e2d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e32:	c3                   	ret    

00801e33 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e33:	f3 0f 1e fb          	endbr32 
  801e37:	55                   	push   %ebp
  801e38:	89 e5                	mov    %esp,%ebp
  801e3a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801e3d:	68 ba 29 80 00       	push   $0x8029ba
  801e42:	ff 75 0c             	pushl  0xc(%ebp)
  801e45:	e8 e3 ea ff ff       	call   80092d <strcpy>
	return 0;
}
  801e4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e4f:	c9                   	leave  
  801e50:	c3                   	ret    

00801e51 <devcons_write>:
{
  801e51:	f3 0f 1e fb          	endbr32 
  801e55:	55                   	push   %ebp
  801e56:	89 e5                	mov    %esp,%ebp
  801e58:	57                   	push   %edi
  801e59:	56                   	push   %esi
  801e5a:	53                   	push   %ebx
  801e5b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801e61:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801e66:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801e6c:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e6f:	73 31                	jae    801ea2 <devcons_write+0x51>
		m = n - tot;
  801e71:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e74:	29 f3                	sub    %esi,%ebx
  801e76:	83 fb 7f             	cmp    $0x7f,%ebx
  801e79:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801e7e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801e81:	83 ec 04             	sub    $0x4,%esp
  801e84:	53                   	push   %ebx
  801e85:	89 f0                	mov    %esi,%eax
  801e87:	03 45 0c             	add    0xc(%ebp),%eax
  801e8a:	50                   	push   %eax
  801e8b:	57                   	push   %edi
  801e8c:	e8 52 ec ff ff       	call   800ae3 <memmove>
		sys_cputs(buf, m);
  801e91:	83 c4 08             	add    $0x8,%esp
  801e94:	53                   	push   %ebx
  801e95:	57                   	push   %edi
  801e96:	e8 04 ee ff ff       	call   800c9f <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801e9b:	01 de                	add    %ebx,%esi
  801e9d:	83 c4 10             	add    $0x10,%esp
  801ea0:	eb ca                	jmp    801e6c <devcons_write+0x1b>
}
  801ea2:	89 f0                	mov    %esi,%eax
  801ea4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ea7:	5b                   	pop    %ebx
  801ea8:	5e                   	pop    %esi
  801ea9:	5f                   	pop    %edi
  801eaa:	5d                   	pop    %ebp
  801eab:	c3                   	ret    

00801eac <devcons_read>:
{
  801eac:	f3 0f 1e fb          	endbr32 
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
  801eb3:	83 ec 08             	sub    $0x8,%esp
  801eb6:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801ebb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ebf:	74 21                	je     801ee2 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801ec1:	e8 fb ed ff ff       	call   800cc1 <sys_cgetc>
  801ec6:	85 c0                	test   %eax,%eax
  801ec8:	75 07                	jne    801ed1 <devcons_read+0x25>
		sys_yield();
  801eca:	e8 7d ee ff ff       	call   800d4c <sys_yield>
  801ecf:	eb f0                	jmp    801ec1 <devcons_read+0x15>
	if (c < 0)
  801ed1:	78 0f                	js     801ee2 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801ed3:	83 f8 04             	cmp    $0x4,%eax
  801ed6:	74 0c                	je     801ee4 <devcons_read+0x38>
	*(char*)vbuf = c;
  801ed8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801edb:	88 02                	mov    %al,(%edx)
	return 1;
  801edd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ee2:	c9                   	leave  
  801ee3:	c3                   	ret    
		return 0;
  801ee4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee9:	eb f7                	jmp    801ee2 <devcons_read+0x36>

00801eeb <cputchar>:
{
  801eeb:	f3 0f 1e fb          	endbr32 
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
  801ef2:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef8:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801efb:	6a 01                	push   $0x1
  801efd:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f00:	50                   	push   %eax
  801f01:	e8 99 ed ff ff       	call   800c9f <sys_cputs>
}
  801f06:	83 c4 10             	add    $0x10,%esp
  801f09:	c9                   	leave  
  801f0a:	c3                   	ret    

00801f0b <getchar>:
{
  801f0b:	f3 0f 1e fb          	endbr32 
  801f0f:	55                   	push   %ebp
  801f10:	89 e5                	mov    %esp,%ebp
  801f12:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801f15:	6a 01                	push   $0x1
  801f17:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f1a:	50                   	push   %eax
  801f1b:	6a 00                	push   $0x0
  801f1d:	e8 5f f6 ff ff       	call   801581 <read>
	if (r < 0)
  801f22:	83 c4 10             	add    $0x10,%esp
  801f25:	85 c0                	test   %eax,%eax
  801f27:	78 06                	js     801f2f <getchar+0x24>
	if (r < 1)
  801f29:	74 06                	je     801f31 <getchar+0x26>
	return c;
  801f2b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801f2f:	c9                   	leave  
  801f30:	c3                   	ret    
		return -E_EOF;
  801f31:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801f36:	eb f7                	jmp    801f2f <getchar+0x24>

00801f38 <iscons>:
{
  801f38:	f3 0f 1e fb          	endbr32 
  801f3c:	55                   	push   %ebp
  801f3d:	89 e5                	mov    %esp,%ebp
  801f3f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f42:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f45:	50                   	push   %eax
  801f46:	ff 75 08             	pushl  0x8(%ebp)
  801f49:	e8 b0 f3 ff ff       	call   8012fe <fd_lookup>
  801f4e:	83 c4 10             	add    $0x10,%esp
  801f51:	85 c0                	test   %eax,%eax
  801f53:	78 11                	js     801f66 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f58:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f5e:	39 10                	cmp    %edx,(%eax)
  801f60:	0f 94 c0             	sete   %al
  801f63:	0f b6 c0             	movzbl %al,%eax
}
  801f66:	c9                   	leave  
  801f67:	c3                   	ret    

00801f68 <opencons>:
{
  801f68:	f3 0f 1e fb          	endbr32 
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
  801f6f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801f72:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f75:	50                   	push   %eax
  801f76:	e8 2d f3 ff ff       	call   8012a8 <fd_alloc>
  801f7b:	83 c4 10             	add    $0x10,%esp
  801f7e:	85 c0                	test   %eax,%eax
  801f80:	78 3a                	js     801fbc <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f82:	83 ec 04             	sub    $0x4,%esp
  801f85:	68 07 04 00 00       	push   $0x407
  801f8a:	ff 75 f4             	pushl  -0xc(%ebp)
  801f8d:	6a 00                	push   $0x0
  801f8f:	e8 db ed ff ff       	call   800d6f <sys_page_alloc>
  801f94:	83 c4 10             	add    $0x10,%esp
  801f97:	85 c0                	test   %eax,%eax
  801f99:	78 21                	js     801fbc <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801f9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9e:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801fa4:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801fb0:	83 ec 0c             	sub    $0xc,%esp
  801fb3:	50                   	push   %eax
  801fb4:	e8 c0 f2 ff ff       	call   801279 <fd2num>
  801fb9:	83 c4 10             	add    $0x10,%esp
}
  801fbc:	c9                   	leave  
  801fbd:	c3                   	ret    

00801fbe <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801fbe:	f3 0f 1e fb          	endbr32 
  801fc2:	55                   	push   %ebp
  801fc3:	89 e5                	mov    %esp,%ebp
  801fc5:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801fc8:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801fcf:	74 0a                	je     801fdb <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd4:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801fd9:	c9                   	leave  
  801fda:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  801fdb:	83 ec 04             	sub    $0x4,%esp
  801fde:	6a 07                	push   $0x7
  801fe0:	68 00 f0 bf ee       	push   $0xeebff000
  801fe5:	6a 00                	push   $0x0
  801fe7:	e8 83 ed ff ff       	call   800d6f <sys_page_alloc>
  801fec:	83 c4 10             	add    $0x10,%esp
  801fef:	85 c0                	test   %eax,%eax
  801ff1:	78 2a                	js     80201d <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  801ff3:	83 ec 08             	sub    $0x8,%esp
  801ff6:	68 31 20 80 00       	push   $0x802031
  801ffb:	6a 00                	push   $0x0
  801ffd:	e8 cc ee ff ff       	call   800ece <sys_env_set_pgfault_upcall>
  802002:	83 c4 10             	add    $0x10,%esp
  802005:	85 c0                	test   %eax,%eax
  802007:	79 c8                	jns    801fd1 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  802009:	83 ec 04             	sub    $0x4,%esp
  80200c:	68 f4 29 80 00       	push   $0x8029f4
  802011:	6a 25                	push   $0x25
  802013:	68 2c 2a 80 00       	push   $0x802a2c
  802018:	e8 1f e2 ff ff       	call   80023c <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  80201d:	83 ec 04             	sub    $0x4,%esp
  802020:	68 c8 29 80 00       	push   $0x8029c8
  802025:	6a 22                	push   $0x22
  802027:	68 2c 2a 80 00       	push   $0x802a2c
  80202c:	e8 0b e2 ff ff       	call   80023c <_panic>

00802031 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802031:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802032:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  802037:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802039:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  80203c:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  802040:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  802044:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802047:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  802049:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  80204d:	83 c4 08             	add    $0x8,%esp
	popal
  802050:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  802051:	83 c4 04             	add    $0x4,%esp
	popfl
  802054:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  802055:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  802056:	c3                   	ret    

00802057 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802057:	f3 0f 1e fb          	endbr32 
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
  80205e:	56                   	push   %esi
  80205f:	53                   	push   %ebx
  802060:	8b 75 08             	mov    0x8(%ebp),%esi
  802063:	8b 45 0c             	mov    0xc(%ebp),%eax
  802066:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  802069:	85 c0                	test   %eax,%eax
  80206b:	74 3d                	je     8020aa <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  80206d:	83 ec 0c             	sub    $0xc,%esp
  802070:	50                   	push   %eax
  802071:	e8 c5 ee ff ff       	call   800f3b <sys_ipc_recv>
  802076:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  802079:	85 f6                	test   %esi,%esi
  80207b:	74 0b                	je     802088 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  80207d:	8b 15 04 40 80 00    	mov    0x804004,%edx
  802083:	8b 52 74             	mov    0x74(%edx),%edx
  802086:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  802088:	85 db                	test   %ebx,%ebx
  80208a:	74 0b                	je     802097 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  80208c:	8b 15 04 40 80 00    	mov    0x804004,%edx
  802092:	8b 52 78             	mov    0x78(%edx),%edx
  802095:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  802097:	85 c0                	test   %eax,%eax
  802099:	78 21                	js     8020bc <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  80209b:	a1 04 40 80 00       	mov    0x804004,%eax
  8020a0:	8b 40 70             	mov    0x70(%eax),%eax
}
  8020a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020a6:	5b                   	pop    %ebx
  8020a7:	5e                   	pop    %esi
  8020a8:	5d                   	pop    %ebp
  8020a9:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  8020aa:	83 ec 0c             	sub    $0xc,%esp
  8020ad:	68 00 00 c0 ee       	push   $0xeec00000
  8020b2:	e8 84 ee ff ff       	call   800f3b <sys_ipc_recv>
  8020b7:	83 c4 10             	add    $0x10,%esp
  8020ba:	eb bd                	jmp    802079 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  8020bc:	85 f6                	test   %esi,%esi
  8020be:	74 10                	je     8020d0 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  8020c0:	85 db                	test   %ebx,%ebx
  8020c2:	75 df                	jne    8020a3 <ipc_recv+0x4c>
  8020c4:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8020cb:	00 00 00 
  8020ce:	eb d3                	jmp    8020a3 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  8020d0:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8020d7:	00 00 00 
  8020da:	eb e4                	jmp    8020c0 <ipc_recv+0x69>

008020dc <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8020dc:	f3 0f 1e fb          	endbr32 
  8020e0:	55                   	push   %ebp
  8020e1:	89 e5                	mov    %esp,%ebp
  8020e3:	57                   	push   %edi
  8020e4:	56                   	push   %esi
  8020e5:	53                   	push   %ebx
  8020e6:	83 ec 0c             	sub    $0xc,%esp
  8020e9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8020ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  8020ef:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  8020f2:	85 db                	test   %ebx,%ebx
  8020f4:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8020f9:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  8020fc:	ff 75 14             	pushl  0x14(%ebp)
  8020ff:	53                   	push   %ebx
  802100:	56                   	push   %esi
  802101:	57                   	push   %edi
  802102:	e8 0d ee ff ff       	call   800f14 <sys_ipc_try_send>
  802107:	83 c4 10             	add    $0x10,%esp
  80210a:	85 c0                	test   %eax,%eax
  80210c:	79 1e                	jns    80212c <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  80210e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802111:	75 07                	jne    80211a <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  802113:	e8 34 ec ff ff       	call   800d4c <sys_yield>
  802118:	eb e2                	jmp    8020fc <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  80211a:	50                   	push   %eax
  80211b:	68 3a 2a 80 00       	push   $0x802a3a
  802120:	6a 59                	push   $0x59
  802122:	68 55 2a 80 00       	push   $0x802a55
  802127:	e8 10 e1 ff ff       	call   80023c <_panic>
	}
}
  80212c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80212f:	5b                   	pop    %ebx
  802130:	5e                   	pop    %esi
  802131:	5f                   	pop    %edi
  802132:	5d                   	pop    %ebp
  802133:	c3                   	ret    

00802134 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802134:	f3 0f 1e fb          	endbr32 
  802138:	55                   	push   %ebp
  802139:	89 e5                	mov    %esp,%ebp
  80213b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80213e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802143:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802146:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80214c:	8b 52 50             	mov    0x50(%edx),%edx
  80214f:	39 ca                	cmp    %ecx,%edx
  802151:	74 11                	je     802164 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802153:	83 c0 01             	add    $0x1,%eax
  802156:	3d 00 04 00 00       	cmp    $0x400,%eax
  80215b:	75 e6                	jne    802143 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  80215d:	b8 00 00 00 00       	mov    $0x0,%eax
  802162:	eb 0b                	jmp    80216f <ipc_find_env+0x3b>
			return envs[i].env_id;
  802164:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802167:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80216c:	8b 40 48             	mov    0x48(%eax),%eax
}
  80216f:	5d                   	pop    %ebp
  802170:	c3                   	ret    

00802171 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802171:	f3 0f 1e fb          	endbr32 
  802175:	55                   	push   %ebp
  802176:	89 e5                	mov    %esp,%ebp
  802178:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80217b:	89 c2                	mov    %eax,%edx
  80217d:	c1 ea 16             	shr    $0x16,%edx
  802180:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802187:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  80218c:	f6 c1 01             	test   $0x1,%cl
  80218f:	74 1c                	je     8021ad <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802191:	c1 e8 0c             	shr    $0xc,%eax
  802194:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80219b:	a8 01                	test   $0x1,%al
  80219d:	74 0e                	je     8021ad <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80219f:	c1 e8 0c             	shr    $0xc,%eax
  8021a2:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8021a9:	ef 
  8021aa:	0f b7 d2             	movzwl %dx,%edx
}
  8021ad:	89 d0                	mov    %edx,%eax
  8021af:	5d                   	pop    %ebp
  8021b0:	c3                   	ret    
  8021b1:	66 90                	xchg   %ax,%ax
  8021b3:	66 90                	xchg   %ax,%ax
  8021b5:	66 90                	xchg   %ax,%ax
  8021b7:	66 90                	xchg   %ax,%ax
  8021b9:	66 90                	xchg   %ax,%ax
  8021bb:	66 90                	xchg   %ax,%ax
  8021bd:	66 90                	xchg   %ax,%ax
  8021bf:	90                   	nop

008021c0 <__udivdi3>:
  8021c0:	f3 0f 1e fb          	endbr32 
  8021c4:	55                   	push   %ebp
  8021c5:	57                   	push   %edi
  8021c6:	56                   	push   %esi
  8021c7:	53                   	push   %ebx
  8021c8:	83 ec 1c             	sub    $0x1c,%esp
  8021cb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8021cf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8021d3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021d7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8021db:	85 d2                	test   %edx,%edx
  8021dd:	75 19                	jne    8021f8 <__udivdi3+0x38>
  8021df:	39 f3                	cmp    %esi,%ebx
  8021e1:	76 4d                	jbe    802230 <__udivdi3+0x70>
  8021e3:	31 ff                	xor    %edi,%edi
  8021e5:	89 e8                	mov    %ebp,%eax
  8021e7:	89 f2                	mov    %esi,%edx
  8021e9:	f7 f3                	div    %ebx
  8021eb:	89 fa                	mov    %edi,%edx
  8021ed:	83 c4 1c             	add    $0x1c,%esp
  8021f0:	5b                   	pop    %ebx
  8021f1:	5e                   	pop    %esi
  8021f2:	5f                   	pop    %edi
  8021f3:	5d                   	pop    %ebp
  8021f4:	c3                   	ret    
  8021f5:	8d 76 00             	lea    0x0(%esi),%esi
  8021f8:	39 f2                	cmp    %esi,%edx
  8021fa:	76 14                	jbe    802210 <__udivdi3+0x50>
  8021fc:	31 ff                	xor    %edi,%edi
  8021fe:	31 c0                	xor    %eax,%eax
  802200:	89 fa                	mov    %edi,%edx
  802202:	83 c4 1c             	add    $0x1c,%esp
  802205:	5b                   	pop    %ebx
  802206:	5e                   	pop    %esi
  802207:	5f                   	pop    %edi
  802208:	5d                   	pop    %ebp
  802209:	c3                   	ret    
  80220a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802210:	0f bd fa             	bsr    %edx,%edi
  802213:	83 f7 1f             	xor    $0x1f,%edi
  802216:	75 48                	jne    802260 <__udivdi3+0xa0>
  802218:	39 f2                	cmp    %esi,%edx
  80221a:	72 06                	jb     802222 <__udivdi3+0x62>
  80221c:	31 c0                	xor    %eax,%eax
  80221e:	39 eb                	cmp    %ebp,%ebx
  802220:	77 de                	ja     802200 <__udivdi3+0x40>
  802222:	b8 01 00 00 00       	mov    $0x1,%eax
  802227:	eb d7                	jmp    802200 <__udivdi3+0x40>
  802229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802230:	89 d9                	mov    %ebx,%ecx
  802232:	85 db                	test   %ebx,%ebx
  802234:	75 0b                	jne    802241 <__udivdi3+0x81>
  802236:	b8 01 00 00 00       	mov    $0x1,%eax
  80223b:	31 d2                	xor    %edx,%edx
  80223d:	f7 f3                	div    %ebx
  80223f:	89 c1                	mov    %eax,%ecx
  802241:	31 d2                	xor    %edx,%edx
  802243:	89 f0                	mov    %esi,%eax
  802245:	f7 f1                	div    %ecx
  802247:	89 c6                	mov    %eax,%esi
  802249:	89 e8                	mov    %ebp,%eax
  80224b:	89 f7                	mov    %esi,%edi
  80224d:	f7 f1                	div    %ecx
  80224f:	89 fa                	mov    %edi,%edx
  802251:	83 c4 1c             	add    $0x1c,%esp
  802254:	5b                   	pop    %ebx
  802255:	5e                   	pop    %esi
  802256:	5f                   	pop    %edi
  802257:	5d                   	pop    %ebp
  802258:	c3                   	ret    
  802259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802260:	89 f9                	mov    %edi,%ecx
  802262:	b8 20 00 00 00       	mov    $0x20,%eax
  802267:	29 f8                	sub    %edi,%eax
  802269:	d3 e2                	shl    %cl,%edx
  80226b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80226f:	89 c1                	mov    %eax,%ecx
  802271:	89 da                	mov    %ebx,%edx
  802273:	d3 ea                	shr    %cl,%edx
  802275:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802279:	09 d1                	or     %edx,%ecx
  80227b:	89 f2                	mov    %esi,%edx
  80227d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802281:	89 f9                	mov    %edi,%ecx
  802283:	d3 e3                	shl    %cl,%ebx
  802285:	89 c1                	mov    %eax,%ecx
  802287:	d3 ea                	shr    %cl,%edx
  802289:	89 f9                	mov    %edi,%ecx
  80228b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80228f:	89 eb                	mov    %ebp,%ebx
  802291:	d3 e6                	shl    %cl,%esi
  802293:	89 c1                	mov    %eax,%ecx
  802295:	d3 eb                	shr    %cl,%ebx
  802297:	09 de                	or     %ebx,%esi
  802299:	89 f0                	mov    %esi,%eax
  80229b:	f7 74 24 08          	divl   0x8(%esp)
  80229f:	89 d6                	mov    %edx,%esi
  8022a1:	89 c3                	mov    %eax,%ebx
  8022a3:	f7 64 24 0c          	mull   0xc(%esp)
  8022a7:	39 d6                	cmp    %edx,%esi
  8022a9:	72 15                	jb     8022c0 <__udivdi3+0x100>
  8022ab:	89 f9                	mov    %edi,%ecx
  8022ad:	d3 e5                	shl    %cl,%ebp
  8022af:	39 c5                	cmp    %eax,%ebp
  8022b1:	73 04                	jae    8022b7 <__udivdi3+0xf7>
  8022b3:	39 d6                	cmp    %edx,%esi
  8022b5:	74 09                	je     8022c0 <__udivdi3+0x100>
  8022b7:	89 d8                	mov    %ebx,%eax
  8022b9:	31 ff                	xor    %edi,%edi
  8022bb:	e9 40 ff ff ff       	jmp    802200 <__udivdi3+0x40>
  8022c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8022c3:	31 ff                	xor    %edi,%edi
  8022c5:	e9 36 ff ff ff       	jmp    802200 <__udivdi3+0x40>
  8022ca:	66 90                	xchg   %ax,%ax
  8022cc:	66 90                	xchg   %ax,%ax
  8022ce:	66 90                	xchg   %ax,%ax

008022d0 <__umoddi3>:
  8022d0:	f3 0f 1e fb          	endbr32 
  8022d4:	55                   	push   %ebp
  8022d5:	57                   	push   %edi
  8022d6:	56                   	push   %esi
  8022d7:	53                   	push   %ebx
  8022d8:	83 ec 1c             	sub    $0x1c,%esp
  8022db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8022df:	8b 74 24 30          	mov    0x30(%esp),%esi
  8022e3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8022e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022eb:	85 c0                	test   %eax,%eax
  8022ed:	75 19                	jne    802308 <__umoddi3+0x38>
  8022ef:	39 df                	cmp    %ebx,%edi
  8022f1:	76 5d                	jbe    802350 <__umoddi3+0x80>
  8022f3:	89 f0                	mov    %esi,%eax
  8022f5:	89 da                	mov    %ebx,%edx
  8022f7:	f7 f7                	div    %edi
  8022f9:	89 d0                	mov    %edx,%eax
  8022fb:	31 d2                	xor    %edx,%edx
  8022fd:	83 c4 1c             	add    $0x1c,%esp
  802300:	5b                   	pop    %ebx
  802301:	5e                   	pop    %esi
  802302:	5f                   	pop    %edi
  802303:	5d                   	pop    %ebp
  802304:	c3                   	ret    
  802305:	8d 76 00             	lea    0x0(%esi),%esi
  802308:	89 f2                	mov    %esi,%edx
  80230a:	39 d8                	cmp    %ebx,%eax
  80230c:	76 12                	jbe    802320 <__umoddi3+0x50>
  80230e:	89 f0                	mov    %esi,%eax
  802310:	89 da                	mov    %ebx,%edx
  802312:	83 c4 1c             	add    $0x1c,%esp
  802315:	5b                   	pop    %ebx
  802316:	5e                   	pop    %esi
  802317:	5f                   	pop    %edi
  802318:	5d                   	pop    %ebp
  802319:	c3                   	ret    
  80231a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802320:	0f bd e8             	bsr    %eax,%ebp
  802323:	83 f5 1f             	xor    $0x1f,%ebp
  802326:	75 50                	jne    802378 <__umoddi3+0xa8>
  802328:	39 d8                	cmp    %ebx,%eax
  80232a:	0f 82 e0 00 00 00    	jb     802410 <__umoddi3+0x140>
  802330:	89 d9                	mov    %ebx,%ecx
  802332:	39 f7                	cmp    %esi,%edi
  802334:	0f 86 d6 00 00 00    	jbe    802410 <__umoddi3+0x140>
  80233a:	89 d0                	mov    %edx,%eax
  80233c:	89 ca                	mov    %ecx,%edx
  80233e:	83 c4 1c             	add    $0x1c,%esp
  802341:	5b                   	pop    %ebx
  802342:	5e                   	pop    %esi
  802343:	5f                   	pop    %edi
  802344:	5d                   	pop    %ebp
  802345:	c3                   	ret    
  802346:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80234d:	8d 76 00             	lea    0x0(%esi),%esi
  802350:	89 fd                	mov    %edi,%ebp
  802352:	85 ff                	test   %edi,%edi
  802354:	75 0b                	jne    802361 <__umoddi3+0x91>
  802356:	b8 01 00 00 00       	mov    $0x1,%eax
  80235b:	31 d2                	xor    %edx,%edx
  80235d:	f7 f7                	div    %edi
  80235f:	89 c5                	mov    %eax,%ebp
  802361:	89 d8                	mov    %ebx,%eax
  802363:	31 d2                	xor    %edx,%edx
  802365:	f7 f5                	div    %ebp
  802367:	89 f0                	mov    %esi,%eax
  802369:	f7 f5                	div    %ebp
  80236b:	89 d0                	mov    %edx,%eax
  80236d:	31 d2                	xor    %edx,%edx
  80236f:	eb 8c                	jmp    8022fd <__umoddi3+0x2d>
  802371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802378:	89 e9                	mov    %ebp,%ecx
  80237a:	ba 20 00 00 00       	mov    $0x20,%edx
  80237f:	29 ea                	sub    %ebp,%edx
  802381:	d3 e0                	shl    %cl,%eax
  802383:	89 44 24 08          	mov    %eax,0x8(%esp)
  802387:	89 d1                	mov    %edx,%ecx
  802389:	89 f8                	mov    %edi,%eax
  80238b:	d3 e8                	shr    %cl,%eax
  80238d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802391:	89 54 24 04          	mov    %edx,0x4(%esp)
  802395:	8b 54 24 04          	mov    0x4(%esp),%edx
  802399:	09 c1                	or     %eax,%ecx
  80239b:	89 d8                	mov    %ebx,%eax
  80239d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023a1:	89 e9                	mov    %ebp,%ecx
  8023a3:	d3 e7                	shl    %cl,%edi
  8023a5:	89 d1                	mov    %edx,%ecx
  8023a7:	d3 e8                	shr    %cl,%eax
  8023a9:	89 e9                	mov    %ebp,%ecx
  8023ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023af:	d3 e3                	shl    %cl,%ebx
  8023b1:	89 c7                	mov    %eax,%edi
  8023b3:	89 d1                	mov    %edx,%ecx
  8023b5:	89 f0                	mov    %esi,%eax
  8023b7:	d3 e8                	shr    %cl,%eax
  8023b9:	89 e9                	mov    %ebp,%ecx
  8023bb:	89 fa                	mov    %edi,%edx
  8023bd:	d3 e6                	shl    %cl,%esi
  8023bf:	09 d8                	or     %ebx,%eax
  8023c1:	f7 74 24 08          	divl   0x8(%esp)
  8023c5:	89 d1                	mov    %edx,%ecx
  8023c7:	89 f3                	mov    %esi,%ebx
  8023c9:	f7 64 24 0c          	mull   0xc(%esp)
  8023cd:	89 c6                	mov    %eax,%esi
  8023cf:	89 d7                	mov    %edx,%edi
  8023d1:	39 d1                	cmp    %edx,%ecx
  8023d3:	72 06                	jb     8023db <__umoddi3+0x10b>
  8023d5:	75 10                	jne    8023e7 <__umoddi3+0x117>
  8023d7:	39 c3                	cmp    %eax,%ebx
  8023d9:	73 0c                	jae    8023e7 <__umoddi3+0x117>
  8023db:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8023df:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8023e3:	89 d7                	mov    %edx,%edi
  8023e5:	89 c6                	mov    %eax,%esi
  8023e7:	89 ca                	mov    %ecx,%edx
  8023e9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8023ee:	29 f3                	sub    %esi,%ebx
  8023f0:	19 fa                	sbb    %edi,%edx
  8023f2:	89 d0                	mov    %edx,%eax
  8023f4:	d3 e0                	shl    %cl,%eax
  8023f6:	89 e9                	mov    %ebp,%ecx
  8023f8:	d3 eb                	shr    %cl,%ebx
  8023fa:	d3 ea                	shr    %cl,%edx
  8023fc:	09 d8                	or     %ebx,%eax
  8023fe:	83 c4 1c             	add    $0x1c,%esp
  802401:	5b                   	pop    %ebx
  802402:	5e                   	pop    %esi
  802403:	5f                   	pop    %edi
  802404:	5d                   	pop    %ebp
  802405:	c3                   	ret    
  802406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80240d:	8d 76 00             	lea    0x0(%esi),%esi
  802410:	29 fe                	sub    %edi,%esi
  802412:	19 c3                	sbb    %eax,%ebx
  802414:	89 f2                	mov    %esi,%edx
  802416:	89 d9                	mov    %ebx,%ecx
  802418:	e9 1d ff ff ff       	jmp    80233a <__umoddi3+0x6a>
