
obj/user/testpiperace.debug:     file format elf32-i386


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
  80002c:	e8 c1 01 00 00       	call   8001f2 <libmain>
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
  80003a:	56                   	push   %esi
  80003b:	53                   	push   %ebx
  80003c:	83 ec 1c             	sub    $0x1c,%esp
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  80003f:	68 a0 29 80 00       	push   $0x8029a0
  800044:	e8 f8 02 00 00       	call   800341 <cprintf>
	if ((r = pipe(p)) < 0)
  800049:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80004c:	89 04 24             	mov    %eax,(%esp)
  80004f:	e8 34 23 00 00       	call   802388 <pipe>
  800054:	83 c4 10             	add    $0x10,%esp
  800057:	85 c0                	test   %eax,%eax
  800059:	78 59                	js     8000b4 <umain+0x81>
		panic("pipe: %e", r);
	max = 200;
	if ((r = fork()) < 0)
  80005b:	e8 cd 10 00 00       	call   80112d <fork>
  800060:	89 c6                	mov    %eax,%esi
  800062:	85 c0                	test   %eax,%eax
  800064:	78 60                	js     8000c6 <umain+0x93>
		panic("fork: %e", r);
	if (r == 0) {
  800066:	74 70                	je     8000d8 <umain+0xa5>
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
	}
	pid = r;
	cprintf("pid is %d\n", pid);
  800068:	83 ec 08             	sub    $0x8,%esp
  80006b:	56                   	push   %esi
  80006c:	68 f1 29 80 00       	push   $0x8029f1
  800071:	e8 cb 02 00 00       	call   800341 <cprintf>
	va = 0;
	kid = &envs[ENVX(pid)];
  800076:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
	cprintf("kid is %d\n", kid-envs);
  80007c:	83 c4 08             	add    $0x8,%esp
  80007f:	6b c6 7c             	imul   $0x7c,%esi,%eax
  800082:	c1 f8 02             	sar    $0x2,%eax
  800085:	69 c0 df 7b ef bd    	imul   $0xbdef7bdf,%eax,%eax
  80008b:	50                   	push   %eax
  80008c:	68 fc 29 80 00       	push   $0x8029fc
  800091:	e8 ab 02 00 00       	call   800341 <cprintf>
	dup(p[0], 10);
  800096:	83 c4 08             	add    $0x8,%esp
  800099:	6a 0a                	push   $0xa
  80009b:	ff 75 f0             	pushl  -0x10(%ebp)
  80009e:	e8 da 15 00 00       	call   80167d <dup>
	while (kid->env_status == ENV_RUNNABLE)
  8000a3:	83 c4 10             	add    $0x10,%esp
  8000a6:	6b de 7c             	imul   $0x7c,%esi,%ebx
  8000a9:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000af:	e9 92 00 00 00       	jmp    800146 <umain+0x113>
		panic("pipe: %e", r);
  8000b4:	50                   	push   %eax
  8000b5:	68 b9 29 80 00       	push   $0x8029b9
  8000ba:	6a 0d                	push   $0xd
  8000bc:	68 c2 29 80 00       	push   $0x8029c2
  8000c1:	e8 94 01 00 00       	call   80025a <_panic>
		panic("fork: %e", r);
  8000c6:	50                   	push   %eax
  8000c7:	68 25 2e 80 00       	push   $0x802e25
  8000cc:	6a 10                	push   $0x10
  8000ce:	68 c2 29 80 00       	push   $0x8029c2
  8000d3:	e8 82 01 00 00       	call   80025a <_panic>
		close(p[1]);
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	ff 75 f4             	pushl  -0xc(%ebp)
  8000de:	e8 40 15 00 00       	call   801623 <close>
  8000e3:	83 c4 10             	add    $0x10,%esp
  8000e6:	bb c8 00 00 00       	mov    $0xc8,%ebx
  8000eb:	eb 1f                	jmp    80010c <umain+0xd9>
				cprintf("RACE: pipe appears closed\n");
  8000ed:	83 ec 0c             	sub    $0xc,%esp
  8000f0:	68 d6 29 80 00       	push   $0x8029d6
  8000f5:	e8 47 02 00 00       	call   800341 <cprintf>
				exit();
  8000fa:	e8 3d 01 00 00       	call   80023c <exit>
  8000ff:	83 c4 10             	add    $0x10,%esp
			sys_yield();
  800102:	e8 63 0c 00 00       	call   800d6a <sys_yield>
		for (i=0; i<max; i++) {
  800107:	83 eb 01             	sub    $0x1,%ebx
  80010a:	74 14                	je     800120 <umain+0xed>
			if(pipeisclosed(p[0])){
  80010c:	83 ec 0c             	sub    $0xc,%esp
  80010f:	ff 75 f0             	pushl  -0x10(%ebp)
  800112:	e8 bf 23 00 00       	call   8024d6 <pipeisclosed>
  800117:	83 c4 10             	add    $0x10,%esp
  80011a:	85 c0                	test   %eax,%eax
  80011c:	74 e4                	je     800102 <umain+0xcf>
  80011e:	eb cd                	jmp    8000ed <umain+0xba>
		ipc_recv(0,0,0);
  800120:	83 ec 04             	sub    $0x4,%esp
  800123:	6a 00                	push   $0x0
  800125:	6a 00                	push   $0x0
  800127:	6a 00                	push   $0x0
  800129:	e8 18 12 00 00       	call   801346 <ipc_recv>
  80012e:	83 c4 10             	add    $0x10,%esp
  800131:	e9 32 ff ff ff       	jmp    800068 <umain+0x35>
		dup(p[0], 10);
  800136:	83 ec 08             	sub    $0x8,%esp
  800139:	6a 0a                	push   $0xa
  80013b:	ff 75 f0             	pushl  -0x10(%ebp)
  80013e:	e8 3a 15 00 00       	call   80167d <dup>
  800143:	83 c4 10             	add    $0x10,%esp
	while (kid->env_status == ENV_RUNNABLE)
  800146:	8b 43 54             	mov    0x54(%ebx),%eax
  800149:	83 f8 02             	cmp    $0x2,%eax
  80014c:	74 e8                	je     800136 <umain+0x103>

	cprintf("child done with loop\n");
  80014e:	83 ec 0c             	sub    $0xc,%esp
  800151:	68 07 2a 80 00       	push   $0x802a07
  800156:	e8 e6 01 00 00       	call   800341 <cprintf>
	if (pipeisclosed(p[0]))
  80015b:	83 c4 04             	add    $0x4,%esp
  80015e:	ff 75 f0             	pushl  -0x10(%ebp)
  800161:	e8 70 23 00 00       	call   8024d6 <pipeisclosed>
  800166:	83 c4 10             	add    $0x10,%esp
  800169:	85 c0                	test   %eax,%eax
  80016b:	75 48                	jne    8001b5 <umain+0x182>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  80016d:	83 ec 08             	sub    $0x8,%esp
  800170:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800173:	50                   	push   %eax
  800174:	ff 75 f0             	pushl  -0x10(%ebp)
  800177:	e8 69 13 00 00       	call   8014e5 <fd_lookup>
  80017c:	83 c4 10             	add    $0x10,%esp
  80017f:	85 c0                	test   %eax,%eax
  800181:	78 46                	js     8001c9 <umain+0x196>
		panic("cannot look up p[0]: %e", r);
	va = fd2data(fd);
  800183:	83 ec 0c             	sub    $0xc,%esp
  800186:	ff 75 ec             	pushl  -0x14(%ebp)
  800189:	e8 e6 12 00 00       	call   801474 <fd2data>
	if (pageref(va) != 3+1)
  80018e:	89 04 24             	mov    %eax,(%esp)
  800191:	e8 19 1b 00 00       	call   801caf <pageref>
  800196:	83 c4 10             	add    $0x10,%esp
  800199:	83 f8 04             	cmp    $0x4,%eax
  80019c:	74 3d                	je     8001db <umain+0x1a8>
		cprintf("\nchild detected race\n");
  80019e:	83 ec 0c             	sub    $0xc,%esp
  8001a1:	68 35 2a 80 00       	push   $0x802a35
  8001a6:	e8 96 01 00 00       	call   800341 <cprintf>
  8001ab:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("\nrace didn't happen\n", max);
}
  8001ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001b1:	5b                   	pop    %ebx
  8001b2:	5e                   	pop    %esi
  8001b3:	5d                   	pop    %ebp
  8001b4:	c3                   	ret    
		panic("somehow the other end of p[0] got closed!");
  8001b5:	83 ec 04             	sub    $0x4,%esp
  8001b8:	68 60 2a 80 00       	push   $0x802a60
  8001bd:	6a 3a                	push   $0x3a
  8001bf:	68 c2 29 80 00       	push   $0x8029c2
  8001c4:	e8 91 00 00 00       	call   80025a <_panic>
		panic("cannot look up p[0]: %e", r);
  8001c9:	50                   	push   %eax
  8001ca:	68 1d 2a 80 00       	push   $0x802a1d
  8001cf:	6a 3c                	push   $0x3c
  8001d1:	68 c2 29 80 00       	push   $0x8029c2
  8001d6:	e8 7f 00 00 00       	call   80025a <_panic>
		cprintf("\nrace didn't happen\n", max);
  8001db:	83 ec 08             	sub    $0x8,%esp
  8001de:	68 c8 00 00 00       	push   $0xc8
  8001e3:	68 4b 2a 80 00       	push   $0x802a4b
  8001e8:	e8 54 01 00 00       	call   800341 <cprintf>
  8001ed:	83 c4 10             	add    $0x10,%esp
}
  8001f0:	eb bc                	jmp    8001ae <umain+0x17b>

008001f2 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001f2:	f3 0f 1e fb          	endbr32 
  8001f6:	55                   	push   %ebp
  8001f7:	89 e5                	mov    %esp,%ebp
  8001f9:	56                   	push   %esi
  8001fa:	53                   	push   %ebx
  8001fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001fe:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800201:	e8 41 0b 00 00       	call   800d47 <sys_getenvid>
  800206:	25 ff 03 00 00       	and    $0x3ff,%eax
  80020b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80020e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800213:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800218:	85 db                	test   %ebx,%ebx
  80021a:	7e 07                	jle    800223 <libmain+0x31>
		binaryname = argv[0];
  80021c:	8b 06                	mov    (%esi),%eax
  80021e:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800223:	83 ec 08             	sub    $0x8,%esp
  800226:	56                   	push   %esi
  800227:	53                   	push   %ebx
  800228:	e8 06 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80022d:	e8 0a 00 00 00       	call   80023c <exit>
}
  800232:	83 c4 10             	add    $0x10,%esp
  800235:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800238:	5b                   	pop    %ebx
  800239:	5e                   	pop    %esi
  80023a:	5d                   	pop    %ebp
  80023b:	c3                   	ret    

0080023c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80023c:	f3 0f 1e fb          	endbr32 
  800240:	55                   	push   %ebp
  800241:	89 e5                	mov    %esp,%ebp
  800243:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800246:	e8 09 14 00 00       	call   801654 <close_all>
	sys_env_destroy(0);
  80024b:	83 ec 0c             	sub    $0xc,%esp
  80024e:	6a 00                	push   $0x0
  800250:	e8 ad 0a 00 00       	call   800d02 <sys_env_destroy>
}
  800255:	83 c4 10             	add    $0x10,%esp
  800258:	c9                   	leave  
  800259:	c3                   	ret    

0080025a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80025a:	f3 0f 1e fb          	endbr32 
  80025e:	55                   	push   %ebp
  80025f:	89 e5                	mov    %esp,%ebp
  800261:	56                   	push   %esi
  800262:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800263:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800266:	8b 35 00 40 80 00    	mov    0x804000,%esi
  80026c:	e8 d6 0a 00 00       	call   800d47 <sys_getenvid>
  800271:	83 ec 0c             	sub    $0xc,%esp
  800274:	ff 75 0c             	pushl  0xc(%ebp)
  800277:	ff 75 08             	pushl  0x8(%ebp)
  80027a:	56                   	push   %esi
  80027b:	50                   	push   %eax
  80027c:	68 94 2a 80 00       	push   $0x802a94
  800281:	e8 bb 00 00 00       	call   800341 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800286:	83 c4 18             	add    $0x18,%esp
  800289:	53                   	push   %ebx
  80028a:	ff 75 10             	pushl  0x10(%ebp)
  80028d:	e8 5a 00 00 00       	call   8002ec <vcprintf>
	cprintf("\n");
  800292:	c7 04 24 b7 29 80 00 	movl   $0x8029b7,(%esp)
  800299:	e8 a3 00 00 00       	call   800341 <cprintf>
  80029e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002a1:	cc                   	int3   
  8002a2:	eb fd                	jmp    8002a1 <_panic+0x47>

008002a4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002a4:	f3 0f 1e fb          	endbr32 
  8002a8:	55                   	push   %ebp
  8002a9:	89 e5                	mov    %esp,%ebp
  8002ab:	53                   	push   %ebx
  8002ac:	83 ec 04             	sub    $0x4,%esp
  8002af:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002b2:	8b 13                	mov    (%ebx),%edx
  8002b4:	8d 42 01             	lea    0x1(%edx),%eax
  8002b7:	89 03                	mov    %eax,(%ebx)
  8002b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002bc:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002c0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002c5:	74 09                	je     8002d0 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002c7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002ce:	c9                   	leave  
  8002cf:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002d0:	83 ec 08             	sub    $0x8,%esp
  8002d3:	68 ff 00 00 00       	push   $0xff
  8002d8:	8d 43 08             	lea    0x8(%ebx),%eax
  8002db:	50                   	push   %eax
  8002dc:	e8 dc 09 00 00       	call   800cbd <sys_cputs>
		b->idx = 0;
  8002e1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002e7:	83 c4 10             	add    $0x10,%esp
  8002ea:	eb db                	jmp    8002c7 <putch+0x23>

008002ec <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002ec:	f3 0f 1e fb          	endbr32 
  8002f0:	55                   	push   %ebp
  8002f1:	89 e5                	mov    %esp,%ebp
  8002f3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002f9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800300:	00 00 00 
	b.cnt = 0;
  800303:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80030a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80030d:	ff 75 0c             	pushl  0xc(%ebp)
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800319:	50                   	push   %eax
  80031a:	68 a4 02 80 00       	push   $0x8002a4
  80031f:	e8 20 01 00 00       	call   800444 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800324:	83 c4 08             	add    $0x8,%esp
  800327:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80032d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800333:	50                   	push   %eax
  800334:	e8 84 09 00 00       	call   800cbd <sys_cputs>

	return b.cnt;
}
  800339:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80033f:	c9                   	leave  
  800340:	c3                   	ret    

00800341 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800341:	f3 0f 1e fb          	endbr32 
  800345:	55                   	push   %ebp
  800346:	89 e5                	mov    %esp,%ebp
  800348:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80034b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80034e:	50                   	push   %eax
  80034f:	ff 75 08             	pushl  0x8(%ebp)
  800352:	e8 95 ff ff ff       	call   8002ec <vcprintf>
	va_end(ap);

	return cnt;
}
  800357:	c9                   	leave  
  800358:	c3                   	ret    

00800359 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800359:	55                   	push   %ebp
  80035a:	89 e5                	mov    %esp,%ebp
  80035c:	57                   	push   %edi
  80035d:	56                   	push   %esi
  80035e:	53                   	push   %ebx
  80035f:	83 ec 1c             	sub    $0x1c,%esp
  800362:	89 c7                	mov    %eax,%edi
  800364:	89 d6                	mov    %edx,%esi
  800366:	8b 45 08             	mov    0x8(%ebp),%eax
  800369:	8b 55 0c             	mov    0xc(%ebp),%edx
  80036c:	89 d1                	mov    %edx,%ecx
  80036e:	89 c2                	mov    %eax,%edx
  800370:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800373:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800376:	8b 45 10             	mov    0x10(%ebp),%eax
  800379:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80037c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80037f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800386:	39 c2                	cmp    %eax,%edx
  800388:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80038b:	72 3e                	jb     8003cb <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80038d:	83 ec 0c             	sub    $0xc,%esp
  800390:	ff 75 18             	pushl  0x18(%ebp)
  800393:	83 eb 01             	sub    $0x1,%ebx
  800396:	53                   	push   %ebx
  800397:	50                   	push   %eax
  800398:	83 ec 08             	sub    $0x8,%esp
  80039b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80039e:	ff 75 e0             	pushl  -0x20(%ebp)
  8003a1:	ff 75 dc             	pushl  -0x24(%ebp)
  8003a4:	ff 75 d8             	pushl  -0x28(%ebp)
  8003a7:	e8 94 23 00 00       	call   802740 <__udivdi3>
  8003ac:	83 c4 18             	add    $0x18,%esp
  8003af:	52                   	push   %edx
  8003b0:	50                   	push   %eax
  8003b1:	89 f2                	mov    %esi,%edx
  8003b3:	89 f8                	mov    %edi,%eax
  8003b5:	e8 9f ff ff ff       	call   800359 <printnum>
  8003ba:	83 c4 20             	add    $0x20,%esp
  8003bd:	eb 13                	jmp    8003d2 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003bf:	83 ec 08             	sub    $0x8,%esp
  8003c2:	56                   	push   %esi
  8003c3:	ff 75 18             	pushl  0x18(%ebp)
  8003c6:	ff d7                	call   *%edi
  8003c8:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8003cb:	83 eb 01             	sub    $0x1,%ebx
  8003ce:	85 db                	test   %ebx,%ebx
  8003d0:	7f ed                	jg     8003bf <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003d2:	83 ec 08             	sub    $0x8,%esp
  8003d5:	56                   	push   %esi
  8003d6:	83 ec 04             	sub    $0x4,%esp
  8003d9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003dc:	ff 75 e0             	pushl  -0x20(%ebp)
  8003df:	ff 75 dc             	pushl  -0x24(%ebp)
  8003e2:	ff 75 d8             	pushl  -0x28(%ebp)
  8003e5:	e8 66 24 00 00       	call   802850 <__umoddi3>
  8003ea:	83 c4 14             	add    $0x14,%esp
  8003ed:	0f be 80 b7 2a 80 00 	movsbl 0x802ab7(%eax),%eax
  8003f4:	50                   	push   %eax
  8003f5:	ff d7                	call   *%edi
}
  8003f7:	83 c4 10             	add    $0x10,%esp
  8003fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003fd:	5b                   	pop    %ebx
  8003fe:	5e                   	pop    %esi
  8003ff:	5f                   	pop    %edi
  800400:	5d                   	pop    %ebp
  800401:	c3                   	ret    

00800402 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800402:	f3 0f 1e fb          	endbr32 
  800406:	55                   	push   %ebp
  800407:	89 e5                	mov    %esp,%ebp
  800409:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80040c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800410:	8b 10                	mov    (%eax),%edx
  800412:	3b 50 04             	cmp    0x4(%eax),%edx
  800415:	73 0a                	jae    800421 <sprintputch+0x1f>
		*b->buf++ = ch;
  800417:	8d 4a 01             	lea    0x1(%edx),%ecx
  80041a:	89 08                	mov    %ecx,(%eax)
  80041c:	8b 45 08             	mov    0x8(%ebp),%eax
  80041f:	88 02                	mov    %al,(%edx)
}
  800421:	5d                   	pop    %ebp
  800422:	c3                   	ret    

00800423 <printfmt>:
{
  800423:	f3 0f 1e fb          	endbr32 
  800427:	55                   	push   %ebp
  800428:	89 e5                	mov    %esp,%ebp
  80042a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80042d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800430:	50                   	push   %eax
  800431:	ff 75 10             	pushl  0x10(%ebp)
  800434:	ff 75 0c             	pushl  0xc(%ebp)
  800437:	ff 75 08             	pushl  0x8(%ebp)
  80043a:	e8 05 00 00 00       	call   800444 <vprintfmt>
}
  80043f:	83 c4 10             	add    $0x10,%esp
  800442:	c9                   	leave  
  800443:	c3                   	ret    

00800444 <vprintfmt>:
{
  800444:	f3 0f 1e fb          	endbr32 
  800448:	55                   	push   %ebp
  800449:	89 e5                	mov    %esp,%ebp
  80044b:	57                   	push   %edi
  80044c:	56                   	push   %esi
  80044d:	53                   	push   %ebx
  80044e:	83 ec 3c             	sub    $0x3c,%esp
  800451:	8b 75 08             	mov    0x8(%ebp),%esi
  800454:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800457:	8b 7d 10             	mov    0x10(%ebp),%edi
  80045a:	e9 8e 03 00 00       	jmp    8007ed <vprintfmt+0x3a9>
		padc = ' ';
  80045f:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800463:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80046a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800471:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800478:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80047d:	8d 47 01             	lea    0x1(%edi),%eax
  800480:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800483:	0f b6 17             	movzbl (%edi),%edx
  800486:	8d 42 dd             	lea    -0x23(%edx),%eax
  800489:	3c 55                	cmp    $0x55,%al
  80048b:	0f 87 df 03 00 00    	ja     800870 <vprintfmt+0x42c>
  800491:	0f b6 c0             	movzbl %al,%eax
  800494:	3e ff 24 85 00 2c 80 	notrack jmp *0x802c00(,%eax,4)
  80049b:	00 
  80049c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80049f:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8004a3:	eb d8                	jmp    80047d <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8004a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004a8:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8004ac:	eb cf                	jmp    80047d <vprintfmt+0x39>
  8004ae:	0f b6 d2             	movzbl %dl,%edx
  8004b1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b9:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8004bc:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004bf:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004c3:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004c6:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004c9:	83 f9 09             	cmp    $0x9,%ecx
  8004cc:	77 55                	ja     800523 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8004ce:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004d1:	eb e9                	jmp    8004bc <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8004d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d6:	8b 00                	mov    (%eax),%eax
  8004d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004db:	8b 45 14             	mov    0x14(%ebp),%eax
  8004de:	8d 40 04             	lea    0x4(%eax),%eax
  8004e1:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004e7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004eb:	79 90                	jns    80047d <vprintfmt+0x39>
				width = precision, precision = -1;
  8004ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004f3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004fa:	eb 81                	jmp    80047d <vprintfmt+0x39>
  8004fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004ff:	85 c0                	test   %eax,%eax
  800501:	ba 00 00 00 00       	mov    $0x0,%edx
  800506:	0f 49 d0             	cmovns %eax,%edx
  800509:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80050c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80050f:	e9 69 ff ff ff       	jmp    80047d <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800514:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800517:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80051e:	e9 5a ff ff ff       	jmp    80047d <vprintfmt+0x39>
  800523:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800526:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800529:	eb bc                	jmp    8004e7 <vprintfmt+0xa3>
			lflag++;
  80052b:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80052e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800531:	e9 47 ff ff ff       	jmp    80047d <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800536:	8b 45 14             	mov    0x14(%ebp),%eax
  800539:	8d 78 04             	lea    0x4(%eax),%edi
  80053c:	83 ec 08             	sub    $0x8,%esp
  80053f:	53                   	push   %ebx
  800540:	ff 30                	pushl  (%eax)
  800542:	ff d6                	call   *%esi
			break;
  800544:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800547:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80054a:	e9 9b 02 00 00       	jmp    8007ea <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80054f:	8b 45 14             	mov    0x14(%ebp),%eax
  800552:	8d 78 04             	lea    0x4(%eax),%edi
  800555:	8b 00                	mov    (%eax),%eax
  800557:	99                   	cltd   
  800558:	31 d0                	xor    %edx,%eax
  80055a:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80055c:	83 f8 0f             	cmp    $0xf,%eax
  80055f:	7f 23                	jg     800584 <vprintfmt+0x140>
  800561:	8b 14 85 60 2d 80 00 	mov    0x802d60(,%eax,4),%edx
  800568:	85 d2                	test   %edx,%edx
  80056a:	74 18                	je     800584 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80056c:	52                   	push   %edx
  80056d:	68 49 2f 80 00       	push   $0x802f49
  800572:	53                   	push   %ebx
  800573:	56                   	push   %esi
  800574:	e8 aa fe ff ff       	call   800423 <printfmt>
  800579:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80057c:	89 7d 14             	mov    %edi,0x14(%ebp)
  80057f:	e9 66 02 00 00       	jmp    8007ea <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800584:	50                   	push   %eax
  800585:	68 cf 2a 80 00       	push   $0x802acf
  80058a:	53                   	push   %ebx
  80058b:	56                   	push   %esi
  80058c:	e8 92 fe ff ff       	call   800423 <printfmt>
  800591:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800594:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800597:	e9 4e 02 00 00       	jmp    8007ea <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	83 c0 04             	add    $0x4,%eax
  8005a2:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8005a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a8:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8005aa:	85 d2                	test   %edx,%edx
  8005ac:	b8 c8 2a 80 00       	mov    $0x802ac8,%eax
  8005b1:	0f 45 c2             	cmovne %edx,%eax
  8005b4:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8005b7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005bb:	7e 06                	jle    8005c3 <vprintfmt+0x17f>
  8005bd:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8005c1:	75 0d                	jne    8005d0 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005c6:	89 c7                	mov    %eax,%edi
  8005c8:	03 45 e0             	add    -0x20(%ebp),%eax
  8005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005ce:	eb 55                	jmp    800625 <vprintfmt+0x1e1>
  8005d0:	83 ec 08             	sub    $0x8,%esp
  8005d3:	ff 75 d8             	pushl  -0x28(%ebp)
  8005d6:	ff 75 cc             	pushl  -0x34(%ebp)
  8005d9:	e8 46 03 00 00       	call   800924 <strnlen>
  8005de:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005e1:	29 c2                	sub    %eax,%edx
  8005e3:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8005e6:	83 c4 10             	add    $0x10,%esp
  8005e9:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8005eb:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8005ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005f2:	85 ff                	test   %edi,%edi
  8005f4:	7e 11                	jle    800607 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8005f6:	83 ec 08             	sub    $0x8,%esp
  8005f9:	53                   	push   %ebx
  8005fa:	ff 75 e0             	pushl  -0x20(%ebp)
  8005fd:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005ff:	83 ef 01             	sub    $0x1,%edi
  800602:	83 c4 10             	add    $0x10,%esp
  800605:	eb eb                	jmp    8005f2 <vprintfmt+0x1ae>
  800607:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80060a:	85 d2                	test   %edx,%edx
  80060c:	b8 00 00 00 00       	mov    $0x0,%eax
  800611:	0f 49 c2             	cmovns %edx,%eax
  800614:	29 c2                	sub    %eax,%edx
  800616:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800619:	eb a8                	jmp    8005c3 <vprintfmt+0x17f>
					putch(ch, putdat);
  80061b:	83 ec 08             	sub    $0x8,%esp
  80061e:	53                   	push   %ebx
  80061f:	52                   	push   %edx
  800620:	ff d6                	call   *%esi
  800622:	83 c4 10             	add    $0x10,%esp
  800625:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800628:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80062a:	83 c7 01             	add    $0x1,%edi
  80062d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800631:	0f be d0             	movsbl %al,%edx
  800634:	85 d2                	test   %edx,%edx
  800636:	74 4b                	je     800683 <vprintfmt+0x23f>
  800638:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80063c:	78 06                	js     800644 <vprintfmt+0x200>
  80063e:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800642:	78 1e                	js     800662 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800644:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800648:	74 d1                	je     80061b <vprintfmt+0x1d7>
  80064a:	0f be c0             	movsbl %al,%eax
  80064d:	83 e8 20             	sub    $0x20,%eax
  800650:	83 f8 5e             	cmp    $0x5e,%eax
  800653:	76 c6                	jbe    80061b <vprintfmt+0x1d7>
					putch('?', putdat);
  800655:	83 ec 08             	sub    $0x8,%esp
  800658:	53                   	push   %ebx
  800659:	6a 3f                	push   $0x3f
  80065b:	ff d6                	call   *%esi
  80065d:	83 c4 10             	add    $0x10,%esp
  800660:	eb c3                	jmp    800625 <vprintfmt+0x1e1>
  800662:	89 cf                	mov    %ecx,%edi
  800664:	eb 0e                	jmp    800674 <vprintfmt+0x230>
				putch(' ', putdat);
  800666:	83 ec 08             	sub    $0x8,%esp
  800669:	53                   	push   %ebx
  80066a:	6a 20                	push   $0x20
  80066c:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80066e:	83 ef 01             	sub    $0x1,%edi
  800671:	83 c4 10             	add    $0x10,%esp
  800674:	85 ff                	test   %edi,%edi
  800676:	7f ee                	jg     800666 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800678:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80067b:	89 45 14             	mov    %eax,0x14(%ebp)
  80067e:	e9 67 01 00 00       	jmp    8007ea <vprintfmt+0x3a6>
  800683:	89 cf                	mov    %ecx,%edi
  800685:	eb ed                	jmp    800674 <vprintfmt+0x230>
	if (lflag >= 2)
  800687:	83 f9 01             	cmp    $0x1,%ecx
  80068a:	7f 1b                	jg     8006a7 <vprintfmt+0x263>
	else if (lflag)
  80068c:	85 c9                	test   %ecx,%ecx
  80068e:	74 63                	je     8006f3 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800690:	8b 45 14             	mov    0x14(%ebp),%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800698:	99                   	cltd   
  800699:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80069c:	8b 45 14             	mov    0x14(%ebp),%eax
  80069f:	8d 40 04             	lea    0x4(%eax),%eax
  8006a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a5:	eb 17                	jmp    8006be <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  8006a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006aa:	8b 50 04             	mov    0x4(%eax),%edx
  8006ad:	8b 00                	mov    (%eax),%eax
  8006af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b8:	8d 40 08             	lea    0x8(%eax),%eax
  8006bb:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8006be:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006c1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8006c4:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8006c9:	85 c9                	test   %ecx,%ecx
  8006cb:	0f 89 ff 00 00 00    	jns    8007d0 <vprintfmt+0x38c>
				putch('-', putdat);
  8006d1:	83 ec 08             	sub    $0x8,%esp
  8006d4:	53                   	push   %ebx
  8006d5:	6a 2d                	push   $0x2d
  8006d7:	ff d6                	call   *%esi
				num = -(long long) num;
  8006d9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006dc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006df:	f7 da                	neg    %edx
  8006e1:	83 d1 00             	adc    $0x0,%ecx
  8006e4:	f7 d9                	neg    %ecx
  8006e6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006e9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ee:	e9 dd 00 00 00       	jmp    8007d0 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8006f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f6:	8b 00                	mov    (%eax),%eax
  8006f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fb:	99                   	cltd   
  8006fc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800702:	8d 40 04             	lea    0x4(%eax),%eax
  800705:	89 45 14             	mov    %eax,0x14(%ebp)
  800708:	eb b4                	jmp    8006be <vprintfmt+0x27a>
	if (lflag >= 2)
  80070a:	83 f9 01             	cmp    $0x1,%ecx
  80070d:	7f 1e                	jg     80072d <vprintfmt+0x2e9>
	else if (lflag)
  80070f:	85 c9                	test   %ecx,%ecx
  800711:	74 32                	je     800745 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800713:	8b 45 14             	mov    0x14(%ebp),%eax
  800716:	8b 10                	mov    (%eax),%edx
  800718:	b9 00 00 00 00       	mov    $0x0,%ecx
  80071d:	8d 40 04             	lea    0x4(%eax),%eax
  800720:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800723:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800728:	e9 a3 00 00 00       	jmp    8007d0 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80072d:	8b 45 14             	mov    0x14(%ebp),%eax
  800730:	8b 10                	mov    (%eax),%edx
  800732:	8b 48 04             	mov    0x4(%eax),%ecx
  800735:	8d 40 08             	lea    0x8(%eax),%eax
  800738:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80073b:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800740:	e9 8b 00 00 00       	jmp    8007d0 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800745:	8b 45 14             	mov    0x14(%ebp),%eax
  800748:	8b 10                	mov    (%eax),%edx
  80074a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80074f:	8d 40 04             	lea    0x4(%eax),%eax
  800752:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800755:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  80075a:	eb 74                	jmp    8007d0 <vprintfmt+0x38c>
	if (lflag >= 2)
  80075c:	83 f9 01             	cmp    $0x1,%ecx
  80075f:	7f 1b                	jg     80077c <vprintfmt+0x338>
	else if (lflag)
  800761:	85 c9                	test   %ecx,%ecx
  800763:	74 2c                	je     800791 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800765:	8b 45 14             	mov    0x14(%ebp),%eax
  800768:	8b 10                	mov    (%eax),%edx
  80076a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80076f:	8d 40 04             	lea    0x4(%eax),%eax
  800772:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800775:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  80077a:	eb 54                	jmp    8007d0 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80077c:	8b 45 14             	mov    0x14(%ebp),%eax
  80077f:	8b 10                	mov    (%eax),%edx
  800781:	8b 48 04             	mov    0x4(%eax),%ecx
  800784:	8d 40 08             	lea    0x8(%eax),%eax
  800787:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80078a:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80078f:	eb 3f                	jmp    8007d0 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800791:	8b 45 14             	mov    0x14(%ebp),%eax
  800794:	8b 10                	mov    (%eax),%edx
  800796:	b9 00 00 00 00       	mov    $0x0,%ecx
  80079b:	8d 40 04             	lea    0x4(%eax),%eax
  80079e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007a1:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  8007a6:	eb 28                	jmp    8007d0 <vprintfmt+0x38c>
			putch('0', putdat);
  8007a8:	83 ec 08             	sub    $0x8,%esp
  8007ab:	53                   	push   %ebx
  8007ac:	6a 30                	push   $0x30
  8007ae:	ff d6                	call   *%esi
			putch('x', putdat);
  8007b0:	83 c4 08             	add    $0x8,%esp
  8007b3:	53                   	push   %ebx
  8007b4:	6a 78                	push   $0x78
  8007b6:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bb:	8b 10                	mov    (%eax),%edx
  8007bd:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8007c2:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007c5:	8d 40 04             	lea    0x4(%eax),%eax
  8007c8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007cb:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007d0:	83 ec 0c             	sub    $0xc,%esp
  8007d3:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8007d7:	57                   	push   %edi
  8007d8:	ff 75 e0             	pushl  -0x20(%ebp)
  8007db:	50                   	push   %eax
  8007dc:	51                   	push   %ecx
  8007dd:	52                   	push   %edx
  8007de:	89 da                	mov    %ebx,%edx
  8007e0:	89 f0                	mov    %esi,%eax
  8007e2:	e8 72 fb ff ff       	call   800359 <printnum>
			break;
  8007e7:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007ed:	83 c7 01             	add    $0x1,%edi
  8007f0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007f4:	83 f8 25             	cmp    $0x25,%eax
  8007f7:	0f 84 62 fc ff ff    	je     80045f <vprintfmt+0x1b>
			if (ch == '\0')
  8007fd:	85 c0                	test   %eax,%eax
  8007ff:	0f 84 8b 00 00 00    	je     800890 <vprintfmt+0x44c>
			putch(ch, putdat);
  800805:	83 ec 08             	sub    $0x8,%esp
  800808:	53                   	push   %ebx
  800809:	50                   	push   %eax
  80080a:	ff d6                	call   *%esi
  80080c:	83 c4 10             	add    $0x10,%esp
  80080f:	eb dc                	jmp    8007ed <vprintfmt+0x3a9>
	if (lflag >= 2)
  800811:	83 f9 01             	cmp    $0x1,%ecx
  800814:	7f 1b                	jg     800831 <vprintfmt+0x3ed>
	else if (lflag)
  800816:	85 c9                	test   %ecx,%ecx
  800818:	74 2c                	je     800846 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  80081a:	8b 45 14             	mov    0x14(%ebp),%eax
  80081d:	8b 10                	mov    (%eax),%edx
  80081f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800824:	8d 40 04             	lea    0x4(%eax),%eax
  800827:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80082a:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80082f:	eb 9f                	jmp    8007d0 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800831:	8b 45 14             	mov    0x14(%ebp),%eax
  800834:	8b 10                	mov    (%eax),%edx
  800836:	8b 48 04             	mov    0x4(%eax),%ecx
  800839:	8d 40 08             	lea    0x8(%eax),%eax
  80083c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80083f:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800844:	eb 8a                	jmp    8007d0 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800846:	8b 45 14             	mov    0x14(%ebp),%eax
  800849:	8b 10                	mov    (%eax),%edx
  80084b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800850:	8d 40 04             	lea    0x4(%eax),%eax
  800853:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800856:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  80085b:	e9 70 ff ff ff       	jmp    8007d0 <vprintfmt+0x38c>
			putch(ch, putdat);
  800860:	83 ec 08             	sub    $0x8,%esp
  800863:	53                   	push   %ebx
  800864:	6a 25                	push   $0x25
  800866:	ff d6                	call   *%esi
			break;
  800868:	83 c4 10             	add    $0x10,%esp
  80086b:	e9 7a ff ff ff       	jmp    8007ea <vprintfmt+0x3a6>
			putch('%', putdat);
  800870:	83 ec 08             	sub    $0x8,%esp
  800873:	53                   	push   %ebx
  800874:	6a 25                	push   $0x25
  800876:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800878:	83 c4 10             	add    $0x10,%esp
  80087b:	89 f8                	mov    %edi,%eax
  80087d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800881:	74 05                	je     800888 <vprintfmt+0x444>
  800883:	83 e8 01             	sub    $0x1,%eax
  800886:	eb f5                	jmp    80087d <vprintfmt+0x439>
  800888:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80088b:	e9 5a ff ff ff       	jmp    8007ea <vprintfmt+0x3a6>
}
  800890:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800893:	5b                   	pop    %ebx
  800894:	5e                   	pop    %esi
  800895:	5f                   	pop    %edi
  800896:	5d                   	pop    %ebp
  800897:	c3                   	ret    

00800898 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800898:	f3 0f 1e fb          	endbr32 
  80089c:	55                   	push   %ebp
  80089d:	89 e5                	mov    %esp,%ebp
  80089f:	83 ec 18             	sub    $0x18,%esp
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008ab:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008af:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008b9:	85 c0                	test   %eax,%eax
  8008bb:	74 26                	je     8008e3 <vsnprintf+0x4b>
  8008bd:	85 d2                	test   %edx,%edx
  8008bf:	7e 22                	jle    8008e3 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008c1:	ff 75 14             	pushl  0x14(%ebp)
  8008c4:	ff 75 10             	pushl  0x10(%ebp)
  8008c7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008ca:	50                   	push   %eax
  8008cb:	68 02 04 80 00       	push   $0x800402
  8008d0:	e8 6f fb ff ff       	call   800444 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008d8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008de:	83 c4 10             	add    $0x10,%esp
}
  8008e1:	c9                   	leave  
  8008e2:	c3                   	ret    
		return -E_INVAL;
  8008e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008e8:	eb f7                	jmp    8008e1 <vsnprintf+0x49>

008008ea <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008ea:	f3 0f 1e fb          	endbr32 
  8008ee:	55                   	push   %ebp
  8008ef:	89 e5                	mov    %esp,%ebp
  8008f1:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008f4:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008f7:	50                   	push   %eax
  8008f8:	ff 75 10             	pushl  0x10(%ebp)
  8008fb:	ff 75 0c             	pushl  0xc(%ebp)
  8008fe:	ff 75 08             	pushl  0x8(%ebp)
  800901:	e8 92 ff ff ff       	call   800898 <vsnprintf>
	va_end(ap);

	return rc;
}
  800906:	c9                   	leave  
  800907:	c3                   	ret    

00800908 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800908:	f3 0f 1e fb          	endbr32 
  80090c:	55                   	push   %ebp
  80090d:	89 e5                	mov    %esp,%ebp
  80090f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800912:	b8 00 00 00 00       	mov    $0x0,%eax
  800917:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80091b:	74 05                	je     800922 <strlen+0x1a>
		n++;
  80091d:	83 c0 01             	add    $0x1,%eax
  800920:	eb f5                	jmp    800917 <strlen+0xf>
	return n;
}
  800922:	5d                   	pop    %ebp
  800923:	c3                   	ret    

00800924 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800924:	f3 0f 1e fb          	endbr32 
  800928:	55                   	push   %ebp
  800929:	89 e5                	mov    %esp,%ebp
  80092b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80092e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800931:	b8 00 00 00 00       	mov    $0x0,%eax
  800936:	39 d0                	cmp    %edx,%eax
  800938:	74 0d                	je     800947 <strnlen+0x23>
  80093a:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80093e:	74 05                	je     800945 <strnlen+0x21>
		n++;
  800940:	83 c0 01             	add    $0x1,%eax
  800943:	eb f1                	jmp    800936 <strnlen+0x12>
  800945:	89 c2                	mov    %eax,%edx
	return n;
}
  800947:	89 d0                	mov    %edx,%eax
  800949:	5d                   	pop    %ebp
  80094a:	c3                   	ret    

0080094b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80094b:	f3 0f 1e fb          	endbr32 
  80094f:	55                   	push   %ebp
  800950:	89 e5                	mov    %esp,%ebp
  800952:	53                   	push   %ebx
  800953:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800956:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800959:	b8 00 00 00 00       	mov    $0x0,%eax
  80095e:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800962:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800965:	83 c0 01             	add    $0x1,%eax
  800968:	84 d2                	test   %dl,%dl
  80096a:	75 f2                	jne    80095e <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  80096c:	89 c8                	mov    %ecx,%eax
  80096e:	5b                   	pop    %ebx
  80096f:	5d                   	pop    %ebp
  800970:	c3                   	ret    

00800971 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800971:	f3 0f 1e fb          	endbr32 
  800975:	55                   	push   %ebp
  800976:	89 e5                	mov    %esp,%ebp
  800978:	53                   	push   %ebx
  800979:	83 ec 10             	sub    $0x10,%esp
  80097c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80097f:	53                   	push   %ebx
  800980:	e8 83 ff ff ff       	call   800908 <strlen>
  800985:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800988:	ff 75 0c             	pushl  0xc(%ebp)
  80098b:	01 d8                	add    %ebx,%eax
  80098d:	50                   	push   %eax
  80098e:	e8 b8 ff ff ff       	call   80094b <strcpy>
	return dst;
}
  800993:	89 d8                	mov    %ebx,%eax
  800995:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800998:	c9                   	leave  
  800999:	c3                   	ret    

0080099a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80099a:	f3 0f 1e fb          	endbr32 
  80099e:	55                   	push   %ebp
  80099f:	89 e5                	mov    %esp,%ebp
  8009a1:	56                   	push   %esi
  8009a2:	53                   	push   %ebx
  8009a3:	8b 75 08             	mov    0x8(%ebp),%esi
  8009a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a9:	89 f3                	mov    %esi,%ebx
  8009ab:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009ae:	89 f0                	mov    %esi,%eax
  8009b0:	39 d8                	cmp    %ebx,%eax
  8009b2:	74 11                	je     8009c5 <strncpy+0x2b>
		*dst++ = *src;
  8009b4:	83 c0 01             	add    $0x1,%eax
  8009b7:	0f b6 0a             	movzbl (%edx),%ecx
  8009ba:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009bd:	80 f9 01             	cmp    $0x1,%cl
  8009c0:	83 da ff             	sbb    $0xffffffff,%edx
  8009c3:	eb eb                	jmp    8009b0 <strncpy+0x16>
	}
	return ret;
}
  8009c5:	89 f0                	mov    %esi,%eax
  8009c7:	5b                   	pop    %ebx
  8009c8:	5e                   	pop    %esi
  8009c9:	5d                   	pop    %ebp
  8009ca:	c3                   	ret    

008009cb <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009cb:	f3 0f 1e fb          	endbr32 
  8009cf:	55                   	push   %ebp
  8009d0:	89 e5                	mov    %esp,%ebp
  8009d2:	56                   	push   %esi
  8009d3:	53                   	push   %ebx
  8009d4:	8b 75 08             	mov    0x8(%ebp),%esi
  8009d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009da:	8b 55 10             	mov    0x10(%ebp),%edx
  8009dd:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009df:	85 d2                	test   %edx,%edx
  8009e1:	74 21                	je     800a04 <strlcpy+0x39>
  8009e3:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009e7:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009e9:	39 c2                	cmp    %eax,%edx
  8009eb:	74 14                	je     800a01 <strlcpy+0x36>
  8009ed:	0f b6 19             	movzbl (%ecx),%ebx
  8009f0:	84 db                	test   %bl,%bl
  8009f2:	74 0b                	je     8009ff <strlcpy+0x34>
			*dst++ = *src++;
  8009f4:	83 c1 01             	add    $0x1,%ecx
  8009f7:	83 c2 01             	add    $0x1,%edx
  8009fa:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009fd:	eb ea                	jmp    8009e9 <strlcpy+0x1e>
  8009ff:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a01:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a04:	29 f0                	sub    %esi,%eax
}
  800a06:	5b                   	pop    %ebx
  800a07:	5e                   	pop    %esi
  800a08:	5d                   	pop    %ebp
  800a09:	c3                   	ret    

00800a0a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a0a:	f3 0f 1e fb          	endbr32 
  800a0e:	55                   	push   %ebp
  800a0f:	89 e5                	mov    %esp,%ebp
  800a11:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a14:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a17:	0f b6 01             	movzbl (%ecx),%eax
  800a1a:	84 c0                	test   %al,%al
  800a1c:	74 0c                	je     800a2a <strcmp+0x20>
  800a1e:	3a 02                	cmp    (%edx),%al
  800a20:	75 08                	jne    800a2a <strcmp+0x20>
		p++, q++;
  800a22:	83 c1 01             	add    $0x1,%ecx
  800a25:	83 c2 01             	add    $0x1,%edx
  800a28:	eb ed                	jmp    800a17 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a2a:	0f b6 c0             	movzbl %al,%eax
  800a2d:	0f b6 12             	movzbl (%edx),%edx
  800a30:	29 d0                	sub    %edx,%eax
}
  800a32:	5d                   	pop    %ebp
  800a33:	c3                   	ret    

00800a34 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a34:	f3 0f 1e fb          	endbr32 
  800a38:	55                   	push   %ebp
  800a39:	89 e5                	mov    %esp,%ebp
  800a3b:	53                   	push   %ebx
  800a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a42:	89 c3                	mov    %eax,%ebx
  800a44:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a47:	eb 06                	jmp    800a4f <strncmp+0x1b>
		n--, p++, q++;
  800a49:	83 c0 01             	add    $0x1,%eax
  800a4c:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a4f:	39 d8                	cmp    %ebx,%eax
  800a51:	74 16                	je     800a69 <strncmp+0x35>
  800a53:	0f b6 08             	movzbl (%eax),%ecx
  800a56:	84 c9                	test   %cl,%cl
  800a58:	74 04                	je     800a5e <strncmp+0x2a>
  800a5a:	3a 0a                	cmp    (%edx),%cl
  800a5c:	74 eb                	je     800a49 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a5e:	0f b6 00             	movzbl (%eax),%eax
  800a61:	0f b6 12             	movzbl (%edx),%edx
  800a64:	29 d0                	sub    %edx,%eax
}
  800a66:	5b                   	pop    %ebx
  800a67:	5d                   	pop    %ebp
  800a68:	c3                   	ret    
		return 0;
  800a69:	b8 00 00 00 00       	mov    $0x0,%eax
  800a6e:	eb f6                	jmp    800a66 <strncmp+0x32>

00800a70 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a70:	f3 0f 1e fb          	endbr32 
  800a74:	55                   	push   %ebp
  800a75:	89 e5                	mov    %esp,%ebp
  800a77:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a7e:	0f b6 10             	movzbl (%eax),%edx
  800a81:	84 d2                	test   %dl,%dl
  800a83:	74 09                	je     800a8e <strchr+0x1e>
		if (*s == c)
  800a85:	38 ca                	cmp    %cl,%dl
  800a87:	74 0a                	je     800a93 <strchr+0x23>
	for (; *s; s++)
  800a89:	83 c0 01             	add    $0x1,%eax
  800a8c:	eb f0                	jmp    800a7e <strchr+0xe>
			return (char *) s;
	return 0;
  800a8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a93:	5d                   	pop    %ebp
  800a94:	c3                   	ret    

00800a95 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a95:	f3 0f 1e fb          	endbr32 
  800a99:	55                   	push   %ebp
  800a9a:	89 e5                	mov    %esp,%ebp
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aa3:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800aa6:	38 ca                	cmp    %cl,%dl
  800aa8:	74 09                	je     800ab3 <strfind+0x1e>
  800aaa:	84 d2                	test   %dl,%dl
  800aac:	74 05                	je     800ab3 <strfind+0x1e>
	for (; *s; s++)
  800aae:	83 c0 01             	add    $0x1,%eax
  800ab1:	eb f0                	jmp    800aa3 <strfind+0xe>
			break;
	return (char *) s;
}
  800ab3:	5d                   	pop    %ebp
  800ab4:	c3                   	ret    

00800ab5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ab5:	f3 0f 1e fb          	endbr32 
  800ab9:	55                   	push   %ebp
  800aba:	89 e5                	mov    %esp,%ebp
  800abc:	57                   	push   %edi
  800abd:	56                   	push   %esi
  800abe:	53                   	push   %ebx
  800abf:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ac2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ac5:	85 c9                	test   %ecx,%ecx
  800ac7:	74 31                	je     800afa <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ac9:	89 f8                	mov    %edi,%eax
  800acb:	09 c8                	or     %ecx,%eax
  800acd:	a8 03                	test   $0x3,%al
  800acf:	75 23                	jne    800af4 <memset+0x3f>
		c &= 0xFF;
  800ad1:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ad5:	89 d3                	mov    %edx,%ebx
  800ad7:	c1 e3 08             	shl    $0x8,%ebx
  800ada:	89 d0                	mov    %edx,%eax
  800adc:	c1 e0 18             	shl    $0x18,%eax
  800adf:	89 d6                	mov    %edx,%esi
  800ae1:	c1 e6 10             	shl    $0x10,%esi
  800ae4:	09 f0                	or     %esi,%eax
  800ae6:	09 c2                	or     %eax,%edx
  800ae8:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800aea:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800aed:	89 d0                	mov    %edx,%eax
  800aef:	fc                   	cld    
  800af0:	f3 ab                	rep stos %eax,%es:(%edi)
  800af2:	eb 06                	jmp    800afa <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800af4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af7:	fc                   	cld    
  800af8:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800afa:	89 f8                	mov    %edi,%eax
  800afc:	5b                   	pop    %ebx
  800afd:	5e                   	pop    %esi
  800afe:	5f                   	pop    %edi
  800aff:	5d                   	pop    %ebp
  800b00:	c3                   	ret    

00800b01 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b01:	f3 0f 1e fb          	endbr32 
  800b05:	55                   	push   %ebp
  800b06:	89 e5                	mov    %esp,%ebp
  800b08:	57                   	push   %edi
  800b09:	56                   	push   %esi
  800b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b10:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b13:	39 c6                	cmp    %eax,%esi
  800b15:	73 32                	jae    800b49 <memmove+0x48>
  800b17:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b1a:	39 c2                	cmp    %eax,%edx
  800b1c:	76 2b                	jbe    800b49 <memmove+0x48>
		s += n;
		d += n;
  800b1e:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b21:	89 fe                	mov    %edi,%esi
  800b23:	09 ce                	or     %ecx,%esi
  800b25:	09 d6                	or     %edx,%esi
  800b27:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b2d:	75 0e                	jne    800b3d <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b2f:	83 ef 04             	sub    $0x4,%edi
  800b32:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b35:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b38:	fd                   	std    
  800b39:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b3b:	eb 09                	jmp    800b46 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b3d:	83 ef 01             	sub    $0x1,%edi
  800b40:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b43:	fd                   	std    
  800b44:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b46:	fc                   	cld    
  800b47:	eb 1a                	jmp    800b63 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b49:	89 c2                	mov    %eax,%edx
  800b4b:	09 ca                	or     %ecx,%edx
  800b4d:	09 f2                	or     %esi,%edx
  800b4f:	f6 c2 03             	test   $0x3,%dl
  800b52:	75 0a                	jne    800b5e <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b54:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b57:	89 c7                	mov    %eax,%edi
  800b59:	fc                   	cld    
  800b5a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b5c:	eb 05                	jmp    800b63 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800b5e:	89 c7                	mov    %eax,%edi
  800b60:	fc                   	cld    
  800b61:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b63:	5e                   	pop    %esi
  800b64:	5f                   	pop    %edi
  800b65:	5d                   	pop    %ebp
  800b66:	c3                   	ret    

00800b67 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b67:	f3 0f 1e fb          	endbr32 
  800b6b:	55                   	push   %ebp
  800b6c:	89 e5                	mov    %esp,%ebp
  800b6e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b71:	ff 75 10             	pushl  0x10(%ebp)
  800b74:	ff 75 0c             	pushl  0xc(%ebp)
  800b77:	ff 75 08             	pushl  0x8(%ebp)
  800b7a:	e8 82 ff ff ff       	call   800b01 <memmove>
}
  800b7f:	c9                   	leave  
  800b80:	c3                   	ret    

00800b81 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b81:	f3 0f 1e fb          	endbr32 
  800b85:	55                   	push   %ebp
  800b86:	89 e5                	mov    %esp,%ebp
  800b88:	56                   	push   %esi
  800b89:	53                   	push   %ebx
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b90:	89 c6                	mov    %eax,%esi
  800b92:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b95:	39 f0                	cmp    %esi,%eax
  800b97:	74 1c                	je     800bb5 <memcmp+0x34>
		if (*s1 != *s2)
  800b99:	0f b6 08             	movzbl (%eax),%ecx
  800b9c:	0f b6 1a             	movzbl (%edx),%ebx
  800b9f:	38 d9                	cmp    %bl,%cl
  800ba1:	75 08                	jne    800bab <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ba3:	83 c0 01             	add    $0x1,%eax
  800ba6:	83 c2 01             	add    $0x1,%edx
  800ba9:	eb ea                	jmp    800b95 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800bab:	0f b6 c1             	movzbl %cl,%eax
  800bae:	0f b6 db             	movzbl %bl,%ebx
  800bb1:	29 d8                	sub    %ebx,%eax
  800bb3:	eb 05                	jmp    800bba <memcmp+0x39>
	}

	return 0;
  800bb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bba:	5b                   	pop    %ebx
  800bbb:	5e                   	pop    %esi
  800bbc:	5d                   	pop    %ebp
  800bbd:	c3                   	ret    

00800bbe <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bbe:	f3 0f 1e fb          	endbr32 
  800bc2:	55                   	push   %ebp
  800bc3:	89 e5                	mov    %esp,%ebp
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bcb:	89 c2                	mov    %eax,%edx
  800bcd:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bd0:	39 d0                	cmp    %edx,%eax
  800bd2:	73 09                	jae    800bdd <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bd4:	38 08                	cmp    %cl,(%eax)
  800bd6:	74 05                	je     800bdd <memfind+0x1f>
	for (; s < ends; s++)
  800bd8:	83 c0 01             	add    $0x1,%eax
  800bdb:	eb f3                	jmp    800bd0 <memfind+0x12>
			break;
	return (void *) s;
}
  800bdd:	5d                   	pop    %ebp
  800bde:	c3                   	ret    

00800bdf <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bdf:	f3 0f 1e fb          	endbr32 
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
  800be6:	57                   	push   %edi
  800be7:	56                   	push   %esi
  800be8:	53                   	push   %ebx
  800be9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bec:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bef:	eb 03                	jmp    800bf4 <strtol+0x15>
		s++;
  800bf1:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bf4:	0f b6 01             	movzbl (%ecx),%eax
  800bf7:	3c 20                	cmp    $0x20,%al
  800bf9:	74 f6                	je     800bf1 <strtol+0x12>
  800bfb:	3c 09                	cmp    $0x9,%al
  800bfd:	74 f2                	je     800bf1 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800bff:	3c 2b                	cmp    $0x2b,%al
  800c01:	74 2a                	je     800c2d <strtol+0x4e>
	int neg = 0;
  800c03:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c08:	3c 2d                	cmp    $0x2d,%al
  800c0a:	74 2b                	je     800c37 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c0c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c12:	75 0f                	jne    800c23 <strtol+0x44>
  800c14:	80 39 30             	cmpb   $0x30,(%ecx)
  800c17:	74 28                	je     800c41 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c19:	85 db                	test   %ebx,%ebx
  800c1b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c20:	0f 44 d8             	cmove  %eax,%ebx
  800c23:	b8 00 00 00 00       	mov    $0x0,%eax
  800c28:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c2b:	eb 46                	jmp    800c73 <strtol+0x94>
		s++;
  800c2d:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c30:	bf 00 00 00 00       	mov    $0x0,%edi
  800c35:	eb d5                	jmp    800c0c <strtol+0x2d>
		s++, neg = 1;
  800c37:	83 c1 01             	add    $0x1,%ecx
  800c3a:	bf 01 00 00 00       	mov    $0x1,%edi
  800c3f:	eb cb                	jmp    800c0c <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c41:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c45:	74 0e                	je     800c55 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c47:	85 db                	test   %ebx,%ebx
  800c49:	75 d8                	jne    800c23 <strtol+0x44>
		s++, base = 8;
  800c4b:	83 c1 01             	add    $0x1,%ecx
  800c4e:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c53:	eb ce                	jmp    800c23 <strtol+0x44>
		s += 2, base = 16;
  800c55:	83 c1 02             	add    $0x2,%ecx
  800c58:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c5d:	eb c4                	jmp    800c23 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800c5f:	0f be d2             	movsbl %dl,%edx
  800c62:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c65:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c68:	7d 3a                	jge    800ca4 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c6a:	83 c1 01             	add    $0x1,%ecx
  800c6d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c71:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c73:	0f b6 11             	movzbl (%ecx),%edx
  800c76:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c79:	89 f3                	mov    %esi,%ebx
  800c7b:	80 fb 09             	cmp    $0x9,%bl
  800c7e:	76 df                	jbe    800c5f <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800c80:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c83:	89 f3                	mov    %esi,%ebx
  800c85:	80 fb 19             	cmp    $0x19,%bl
  800c88:	77 08                	ja     800c92 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c8a:	0f be d2             	movsbl %dl,%edx
  800c8d:	83 ea 57             	sub    $0x57,%edx
  800c90:	eb d3                	jmp    800c65 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800c92:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c95:	89 f3                	mov    %esi,%ebx
  800c97:	80 fb 19             	cmp    $0x19,%bl
  800c9a:	77 08                	ja     800ca4 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c9c:	0f be d2             	movsbl %dl,%edx
  800c9f:	83 ea 37             	sub    $0x37,%edx
  800ca2:	eb c1                	jmp    800c65 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ca4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ca8:	74 05                	je     800caf <strtol+0xd0>
		*endptr = (char *) s;
  800caa:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cad:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800caf:	89 c2                	mov    %eax,%edx
  800cb1:	f7 da                	neg    %edx
  800cb3:	85 ff                	test   %edi,%edi
  800cb5:	0f 45 c2             	cmovne %edx,%eax
}
  800cb8:	5b                   	pop    %ebx
  800cb9:	5e                   	pop    %esi
  800cba:	5f                   	pop    %edi
  800cbb:	5d                   	pop    %ebp
  800cbc:	c3                   	ret    

00800cbd <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cbd:	f3 0f 1e fb          	endbr32 
  800cc1:	55                   	push   %ebp
  800cc2:	89 e5                	mov    %esp,%ebp
  800cc4:	57                   	push   %edi
  800cc5:	56                   	push   %esi
  800cc6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cc7:	b8 00 00 00 00       	mov    $0x0,%eax
  800ccc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd2:	89 c3                	mov    %eax,%ebx
  800cd4:	89 c7                	mov    %eax,%edi
  800cd6:	89 c6                	mov    %eax,%esi
  800cd8:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cda:	5b                   	pop    %ebx
  800cdb:	5e                   	pop    %esi
  800cdc:	5f                   	pop    %edi
  800cdd:	5d                   	pop    %ebp
  800cde:	c3                   	ret    

00800cdf <sys_cgetc>:

int
sys_cgetc(void)
{
  800cdf:	f3 0f 1e fb          	endbr32 
  800ce3:	55                   	push   %ebp
  800ce4:	89 e5                	mov    %esp,%ebp
  800ce6:	57                   	push   %edi
  800ce7:	56                   	push   %esi
  800ce8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ce9:	ba 00 00 00 00       	mov    $0x0,%edx
  800cee:	b8 01 00 00 00       	mov    $0x1,%eax
  800cf3:	89 d1                	mov    %edx,%ecx
  800cf5:	89 d3                	mov    %edx,%ebx
  800cf7:	89 d7                	mov    %edx,%edi
  800cf9:	89 d6                	mov    %edx,%esi
  800cfb:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cfd:	5b                   	pop    %ebx
  800cfe:	5e                   	pop    %esi
  800cff:	5f                   	pop    %edi
  800d00:	5d                   	pop    %ebp
  800d01:	c3                   	ret    

00800d02 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d02:	f3 0f 1e fb          	endbr32 
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	57                   	push   %edi
  800d0a:	56                   	push   %esi
  800d0b:	53                   	push   %ebx
  800d0c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d0f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d14:	8b 55 08             	mov    0x8(%ebp),%edx
  800d17:	b8 03 00 00 00       	mov    $0x3,%eax
  800d1c:	89 cb                	mov    %ecx,%ebx
  800d1e:	89 cf                	mov    %ecx,%edi
  800d20:	89 ce                	mov    %ecx,%esi
  800d22:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d24:	85 c0                	test   %eax,%eax
  800d26:	7f 08                	jg     800d30 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d28:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2b:	5b                   	pop    %ebx
  800d2c:	5e                   	pop    %esi
  800d2d:	5f                   	pop    %edi
  800d2e:	5d                   	pop    %ebp
  800d2f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d30:	83 ec 0c             	sub    $0xc,%esp
  800d33:	50                   	push   %eax
  800d34:	6a 03                	push   $0x3
  800d36:	68 bf 2d 80 00       	push   $0x802dbf
  800d3b:	6a 23                	push   $0x23
  800d3d:	68 dc 2d 80 00       	push   $0x802ddc
  800d42:	e8 13 f5 ff ff       	call   80025a <_panic>

00800d47 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d47:	f3 0f 1e fb          	endbr32 
  800d4b:	55                   	push   %ebp
  800d4c:	89 e5                	mov    %esp,%ebp
  800d4e:	57                   	push   %edi
  800d4f:	56                   	push   %esi
  800d50:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d51:	ba 00 00 00 00       	mov    $0x0,%edx
  800d56:	b8 02 00 00 00       	mov    $0x2,%eax
  800d5b:	89 d1                	mov    %edx,%ecx
  800d5d:	89 d3                	mov    %edx,%ebx
  800d5f:	89 d7                	mov    %edx,%edi
  800d61:	89 d6                	mov    %edx,%esi
  800d63:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d65:	5b                   	pop    %ebx
  800d66:	5e                   	pop    %esi
  800d67:	5f                   	pop    %edi
  800d68:	5d                   	pop    %ebp
  800d69:	c3                   	ret    

00800d6a <sys_yield>:

void
sys_yield(void)
{
  800d6a:	f3 0f 1e fb          	endbr32 
  800d6e:	55                   	push   %ebp
  800d6f:	89 e5                	mov    %esp,%ebp
  800d71:	57                   	push   %edi
  800d72:	56                   	push   %esi
  800d73:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d74:	ba 00 00 00 00       	mov    $0x0,%edx
  800d79:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d7e:	89 d1                	mov    %edx,%ecx
  800d80:	89 d3                	mov    %edx,%ebx
  800d82:	89 d7                	mov    %edx,%edi
  800d84:	89 d6                	mov    %edx,%esi
  800d86:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d88:	5b                   	pop    %ebx
  800d89:	5e                   	pop    %esi
  800d8a:	5f                   	pop    %edi
  800d8b:	5d                   	pop    %ebp
  800d8c:	c3                   	ret    

00800d8d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d8d:	f3 0f 1e fb          	endbr32 
  800d91:	55                   	push   %ebp
  800d92:	89 e5                	mov    %esp,%ebp
  800d94:	57                   	push   %edi
  800d95:	56                   	push   %esi
  800d96:	53                   	push   %ebx
  800d97:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d9a:	be 00 00 00 00       	mov    $0x0,%esi
  800d9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800da2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da5:	b8 04 00 00 00       	mov    $0x4,%eax
  800daa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dad:	89 f7                	mov    %esi,%edi
  800daf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db1:	85 c0                	test   %eax,%eax
  800db3:	7f 08                	jg     800dbd <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800db5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db8:	5b                   	pop    %ebx
  800db9:	5e                   	pop    %esi
  800dba:	5f                   	pop    %edi
  800dbb:	5d                   	pop    %ebp
  800dbc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dbd:	83 ec 0c             	sub    $0xc,%esp
  800dc0:	50                   	push   %eax
  800dc1:	6a 04                	push   $0x4
  800dc3:	68 bf 2d 80 00       	push   $0x802dbf
  800dc8:	6a 23                	push   $0x23
  800dca:	68 dc 2d 80 00       	push   $0x802ddc
  800dcf:	e8 86 f4 ff ff       	call   80025a <_panic>

00800dd4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dd4:	f3 0f 1e fb          	endbr32 
  800dd8:	55                   	push   %ebp
  800dd9:	89 e5                	mov    %esp,%ebp
  800ddb:	57                   	push   %edi
  800ddc:	56                   	push   %esi
  800ddd:	53                   	push   %ebx
  800dde:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de1:	8b 55 08             	mov    0x8(%ebp),%edx
  800de4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de7:	b8 05 00 00 00       	mov    $0x5,%eax
  800dec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800def:	8b 7d 14             	mov    0x14(%ebp),%edi
  800df2:	8b 75 18             	mov    0x18(%ebp),%esi
  800df5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df7:	85 c0                	test   %eax,%eax
  800df9:	7f 08                	jg     800e03 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dfe:	5b                   	pop    %ebx
  800dff:	5e                   	pop    %esi
  800e00:	5f                   	pop    %edi
  800e01:	5d                   	pop    %ebp
  800e02:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e03:	83 ec 0c             	sub    $0xc,%esp
  800e06:	50                   	push   %eax
  800e07:	6a 05                	push   $0x5
  800e09:	68 bf 2d 80 00       	push   $0x802dbf
  800e0e:	6a 23                	push   $0x23
  800e10:	68 dc 2d 80 00       	push   $0x802ddc
  800e15:	e8 40 f4 ff ff       	call   80025a <_panic>

00800e1a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e1a:	f3 0f 1e fb          	endbr32 
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	57                   	push   %edi
  800e22:	56                   	push   %esi
  800e23:	53                   	push   %ebx
  800e24:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e27:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e32:	b8 06 00 00 00       	mov    $0x6,%eax
  800e37:	89 df                	mov    %ebx,%edi
  800e39:	89 de                	mov    %ebx,%esi
  800e3b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e3d:	85 c0                	test   %eax,%eax
  800e3f:	7f 08                	jg     800e49 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e44:	5b                   	pop    %ebx
  800e45:	5e                   	pop    %esi
  800e46:	5f                   	pop    %edi
  800e47:	5d                   	pop    %ebp
  800e48:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e49:	83 ec 0c             	sub    $0xc,%esp
  800e4c:	50                   	push   %eax
  800e4d:	6a 06                	push   $0x6
  800e4f:	68 bf 2d 80 00       	push   $0x802dbf
  800e54:	6a 23                	push   $0x23
  800e56:	68 dc 2d 80 00       	push   $0x802ddc
  800e5b:	e8 fa f3 ff ff       	call   80025a <_panic>

00800e60 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e60:	f3 0f 1e fb          	endbr32 
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
  800e67:	57                   	push   %edi
  800e68:	56                   	push   %esi
  800e69:	53                   	push   %ebx
  800e6a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e6d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e72:	8b 55 08             	mov    0x8(%ebp),%edx
  800e75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e78:	b8 08 00 00 00       	mov    $0x8,%eax
  800e7d:	89 df                	mov    %ebx,%edi
  800e7f:	89 de                	mov    %ebx,%esi
  800e81:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e83:	85 c0                	test   %eax,%eax
  800e85:	7f 08                	jg     800e8f <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e8a:	5b                   	pop    %ebx
  800e8b:	5e                   	pop    %esi
  800e8c:	5f                   	pop    %edi
  800e8d:	5d                   	pop    %ebp
  800e8e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8f:	83 ec 0c             	sub    $0xc,%esp
  800e92:	50                   	push   %eax
  800e93:	6a 08                	push   $0x8
  800e95:	68 bf 2d 80 00       	push   $0x802dbf
  800e9a:	6a 23                	push   $0x23
  800e9c:	68 dc 2d 80 00       	push   $0x802ddc
  800ea1:	e8 b4 f3 ff ff       	call   80025a <_panic>

00800ea6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ea6:	f3 0f 1e fb          	endbr32 
  800eaa:	55                   	push   %ebp
  800eab:	89 e5                	mov    %esp,%ebp
  800ead:	57                   	push   %edi
  800eae:	56                   	push   %esi
  800eaf:	53                   	push   %ebx
  800eb0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eb3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ebe:	b8 09 00 00 00       	mov    $0x9,%eax
  800ec3:	89 df                	mov    %ebx,%edi
  800ec5:	89 de                	mov    %ebx,%esi
  800ec7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ec9:	85 c0                	test   %eax,%eax
  800ecb:	7f 08                	jg     800ed5 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ecd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed0:	5b                   	pop    %ebx
  800ed1:	5e                   	pop    %esi
  800ed2:	5f                   	pop    %edi
  800ed3:	5d                   	pop    %ebp
  800ed4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed5:	83 ec 0c             	sub    $0xc,%esp
  800ed8:	50                   	push   %eax
  800ed9:	6a 09                	push   $0x9
  800edb:	68 bf 2d 80 00       	push   $0x802dbf
  800ee0:	6a 23                	push   $0x23
  800ee2:	68 dc 2d 80 00       	push   $0x802ddc
  800ee7:	e8 6e f3 ff ff       	call   80025a <_panic>

00800eec <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800eec:	f3 0f 1e fb          	endbr32 
  800ef0:	55                   	push   %ebp
  800ef1:	89 e5                	mov    %esp,%ebp
  800ef3:	57                   	push   %edi
  800ef4:	56                   	push   %esi
  800ef5:	53                   	push   %ebx
  800ef6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ef9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800efe:	8b 55 08             	mov    0x8(%ebp),%edx
  800f01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f04:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f09:	89 df                	mov    %ebx,%edi
  800f0b:	89 de                	mov    %ebx,%esi
  800f0d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f0f:	85 c0                	test   %eax,%eax
  800f11:	7f 08                	jg     800f1b <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f13:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f16:	5b                   	pop    %ebx
  800f17:	5e                   	pop    %esi
  800f18:	5f                   	pop    %edi
  800f19:	5d                   	pop    %ebp
  800f1a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1b:	83 ec 0c             	sub    $0xc,%esp
  800f1e:	50                   	push   %eax
  800f1f:	6a 0a                	push   $0xa
  800f21:	68 bf 2d 80 00       	push   $0x802dbf
  800f26:	6a 23                	push   $0x23
  800f28:	68 dc 2d 80 00       	push   $0x802ddc
  800f2d:	e8 28 f3 ff ff       	call   80025a <_panic>

00800f32 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f32:	f3 0f 1e fb          	endbr32 
  800f36:	55                   	push   %ebp
  800f37:	89 e5                	mov    %esp,%ebp
  800f39:	57                   	push   %edi
  800f3a:	56                   	push   %esi
  800f3b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f42:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f47:	be 00 00 00 00       	mov    $0x0,%esi
  800f4c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f4f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f52:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f54:	5b                   	pop    %ebx
  800f55:	5e                   	pop    %esi
  800f56:	5f                   	pop    %edi
  800f57:	5d                   	pop    %ebp
  800f58:	c3                   	ret    

00800f59 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f59:	f3 0f 1e fb          	endbr32 
  800f5d:	55                   	push   %ebp
  800f5e:	89 e5                	mov    %esp,%ebp
  800f60:	57                   	push   %edi
  800f61:	56                   	push   %esi
  800f62:	53                   	push   %ebx
  800f63:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f66:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6e:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f73:	89 cb                	mov    %ecx,%ebx
  800f75:	89 cf                	mov    %ecx,%edi
  800f77:	89 ce                	mov    %ecx,%esi
  800f79:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f7b:	85 c0                	test   %eax,%eax
  800f7d:	7f 08                	jg     800f87 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f82:	5b                   	pop    %ebx
  800f83:	5e                   	pop    %esi
  800f84:	5f                   	pop    %edi
  800f85:	5d                   	pop    %ebp
  800f86:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f87:	83 ec 0c             	sub    $0xc,%esp
  800f8a:	50                   	push   %eax
  800f8b:	6a 0d                	push   $0xd
  800f8d:	68 bf 2d 80 00       	push   $0x802dbf
  800f92:	6a 23                	push   $0x23
  800f94:	68 dc 2d 80 00       	push   $0x802ddc
  800f99:	e8 bc f2 ff ff       	call   80025a <_panic>

00800f9e <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f9e:	f3 0f 1e fb          	endbr32 
  800fa2:	55                   	push   %ebp
  800fa3:	89 e5                	mov    %esp,%ebp
  800fa5:	57                   	push   %edi
  800fa6:	56                   	push   %esi
  800fa7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fa8:	ba 00 00 00 00       	mov    $0x0,%edx
  800fad:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fb2:	89 d1                	mov    %edx,%ecx
  800fb4:	89 d3                	mov    %edx,%ebx
  800fb6:	89 d7                	mov    %edx,%edi
  800fb8:	89 d6                	mov    %edx,%esi
  800fba:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fbc:	5b                   	pop    %ebx
  800fbd:	5e                   	pop    %esi
  800fbe:	5f                   	pop    %edi
  800fbf:	5d                   	pop    %ebp
  800fc0:	c3                   	ret    

00800fc1 <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  800fc1:	f3 0f 1e fb          	endbr32 
  800fc5:	55                   	push   %ebp
  800fc6:	89 e5                	mov    %esp,%ebp
  800fc8:	57                   	push   %edi
  800fc9:	56                   	push   %esi
  800fca:	53                   	push   %ebx
  800fcb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fce:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd9:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fde:	89 df                	mov    %ebx,%edi
  800fe0:	89 de                	mov    %ebx,%esi
  800fe2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fe4:	85 c0                	test   %eax,%eax
  800fe6:	7f 08                	jg     800ff0 <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  800fe8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800feb:	5b                   	pop    %ebx
  800fec:	5e                   	pop    %esi
  800fed:	5f                   	pop    %edi
  800fee:	5d                   	pop    %ebp
  800fef:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff0:	83 ec 0c             	sub    $0xc,%esp
  800ff3:	50                   	push   %eax
  800ff4:	6a 0f                	push   $0xf
  800ff6:	68 bf 2d 80 00       	push   $0x802dbf
  800ffb:	6a 23                	push   $0x23
  800ffd:	68 dc 2d 80 00       	push   $0x802ddc
  801002:	e8 53 f2 ff ff       	call   80025a <_panic>

00801007 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  801007:	f3 0f 1e fb          	endbr32 
  80100b:	55                   	push   %ebp
  80100c:	89 e5                	mov    %esp,%ebp
  80100e:	57                   	push   %edi
  80100f:	56                   	push   %esi
  801010:	53                   	push   %ebx
  801011:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801014:	bb 00 00 00 00       	mov    $0x0,%ebx
  801019:	8b 55 08             	mov    0x8(%ebp),%edx
  80101c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80101f:	b8 10 00 00 00       	mov    $0x10,%eax
  801024:	89 df                	mov    %ebx,%edi
  801026:	89 de                	mov    %ebx,%esi
  801028:	cd 30                	int    $0x30
	if(check && ret > 0)
  80102a:	85 c0                	test   %eax,%eax
  80102c:	7f 08                	jg     801036 <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  80102e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801031:	5b                   	pop    %ebx
  801032:	5e                   	pop    %esi
  801033:	5f                   	pop    %edi
  801034:	5d                   	pop    %ebp
  801035:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801036:	83 ec 0c             	sub    $0xc,%esp
  801039:	50                   	push   %eax
  80103a:	6a 10                	push   $0x10
  80103c:	68 bf 2d 80 00       	push   $0x802dbf
  801041:	6a 23                	push   $0x23
  801043:	68 dc 2d 80 00       	push   $0x802ddc
  801048:	e8 0d f2 ff ff       	call   80025a <_panic>

0080104d <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80104d:	f3 0f 1e fb          	endbr32 
  801051:	55                   	push   %ebp
  801052:	89 e5                	mov    %esp,%ebp
  801054:	53                   	push   %ebx
  801055:	83 ec 04             	sub    $0x4,%esp
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80105b:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  80105d:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801061:	74 74                	je     8010d7 <pgfault+0x8a>
  801063:	89 d8                	mov    %ebx,%eax
  801065:	c1 e8 0c             	shr    $0xc,%eax
  801068:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80106f:	f6 c4 08             	test   $0x8,%ah
  801072:	74 63                	je     8010d7 <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  801074:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  80107a:	83 ec 0c             	sub    $0xc,%esp
  80107d:	6a 05                	push   $0x5
  80107f:	68 00 f0 7f 00       	push   $0x7ff000
  801084:	6a 00                	push   $0x0
  801086:	53                   	push   %ebx
  801087:	6a 00                	push   $0x0
  801089:	e8 46 fd ff ff       	call   800dd4 <sys_page_map>
  80108e:	83 c4 20             	add    $0x20,%esp
  801091:	85 c0                	test   %eax,%eax
  801093:	78 59                	js     8010ee <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  801095:	83 ec 04             	sub    $0x4,%esp
  801098:	6a 07                	push   $0x7
  80109a:	53                   	push   %ebx
  80109b:	6a 00                	push   $0x0
  80109d:	e8 eb fc ff ff       	call   800d8d <sys_page_alloc>
  8010a2:	83 c4 10             	add    $0x10,%esp
  8010a5:	85 c0                	test   %eax,%eax
  8010a7:	78 5a                	js     801103 <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  8010a9:	83 ec 04             	sub    $0x4,%esp
  8010ac:	68 00 10 00 00       	push   $0x1000
  8010b1:	68 00 f0 7f 00       	push   $0x7ff000
  8010b6:	53                   	push   %ebx
  8010b7:	e8 45 fa ff ff       	call   800b01 <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  8010bc:	83 c4 08             	add    $0x8,%esp
  8010bf:	68 00 f0 7f 00       	push   $0x7ff000
  8010c4:	6a 00                	push   $0x0
  8010c6:	e8 4f fd ff ff       	call   800e1a <sys_page_unmap>
  8010cb:	83 c4 10             	add    $0x10,%esp
  8010ce:	85 c0                	test   %eax,%eax
  8010d0:	78 46                	js     801118 <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  8010d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010d5:	c9                   	leave  
  8010d6:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  8010d7:	83 ec 04             	sub    $0x4,%esp
  8010da:	68 ea 2d 80 00       	push   $0x802dea
  8010df:	68 d3 00 00 00       	push   $0xd3
  8010e4:	68 06 2e 80 00       	push   $0x802e06
  8010e9:	e8 6c f1 ff ff       	call   80025a <_panic>
		panic("pgfault: %e\n", r);
  8010ee:	50                   	push   %eax
  8010ef:	68 11 2e 80 00       	push   $0x802e11
  8010f4:	68 df 00 00 00       	push   $0xdf
  8010f9:	68 06 2e 80 00       	push   $0x802e06
  8010fe:	e8 57 f1 ff ff       	call   80025a <_panic>
		panic("pgfault: %e\n", r);
  801103:	50                   	push   %eax
  801104:	68 11 2e 80 00       	push   $0x802e11
  801109:	68 e3 00 00 00       	push   $0xe3
  80110e:	68 06 2e 80 00       	push   $0x802e06
  801113:	e8 42 f1 ff ff       	call   80025a <_panic>
		panic("pgfault: %e\n", r);
  801118:	50                   	push   %eax
  801119:	68 11 2e 80 00       	push   $0x802e11
  80111e:	68 e9 00 00 00       	push   $0xe9
  801123:	68 06 2e 80 00       	push   $0x802e06
  801128:	e8 2d f1 ff ff       	call   80025a <_panic>

0080112d <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80112d:	f3 0f 1e fb          	endbr32 
  801131:	55                   	push   %ebp
  801132:	89 e5                	mov    %esp,%ebp
  801134:	57                   	push   %edi
  801135:	56                   	push   %esi
  801136:	53                   	push   %ebx
  801137:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  80113a:	68 4d 10 80 00       	push   $0x80104d
  80113f:	e8 5e 15 00 00       	call   8026a2 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801144:	b8 07 00 00 00       	mov    $0x7,%eax
  801149:	cd 30                	int    $0x30
  80114b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  80114e:	83 c4 10             	add    $0x10,%esp
  801151:	85 c0                	test   %eax,%eax
  801153:	78 2d                	js     801182 <fork+0x55>
  801155:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801157:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  80115c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801160:	0f 85 9b 00 00 00    	jne    801201 <fork+0xd4>
		thisenv = &envs[ENVX(sys_getenvid())];
  801166:	e8 dc fb ff ff       	call   800d47 <sys_getenvid>
  80116b:	25 ff 03 00 00       	and    $0x3ff,%eax
  801170:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801173:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801178:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  80117d:	e9 71 01 00 00       	jmp    8012f3 <fork+0x1c6>
		panic("sys_exofork: %e", envid);
  801182:	50                   	push   %eax
  801183:	68 1e 2e 80 00       	push   $0x802e1e
  801188:	68 2a 01 00 00       	push   $0x12a
  80118d:	68 06 2e 80 00       	push   $0x802e06
  801192:	e8 c3 f0 ff ff       	call   80025a <_panic>
		sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_SYSCALL);
  801197:	c1 e6 0c             	shl    $0xc,%esi
  80119a:	83 ec 0c             	sub    $0xc,%esp
  80119d:	68 07 0e 00 00       	push   $0xe07
  8011a2:	56                   	push   %esi
  8011a3:	57                   	push   %edi
  8011a4:	56                   	push   %esi
  8011a5:	6a 00                	push   $0x0
  8011a7:	e8 28 fc ff ff       	call   800dd4 <sys_page_map>
  8011ac:	83 c4 20             	add    $0x20,%esp
  8011af:	eb 3e                	jmp    8011ef <fork+0xc2>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  8011b1:	c1 e6 0c             	shl    $0xc,%esi
  8011b4:	83 ec 0c             	sub    $0xc,%esp
  8011b7:	68 05 08 00 00       	push   $0x805
  8011bc:	56                   	push   %esi
  8011bd:	57                   	push   %edi
  8011be:	56                   	push   %esi
  8011bf:	6a 00                	push   $0x0
  8011c1:	e8 0e fc ff ff       	call   800dd4 <sys_page_map>
  8011c6:	83 c4 20             	add    $0x20,%esp
  8011c9:	85 c0                	test   %eax,%eax
  8011cb:	0f 88 bc 00 00 00    	js     80128d <fork+0x160>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  8011d1:	83 ec 0c             	sub    $0xc,%esp
  8011d4:	68 05 08 00 00       	push   $0x805
  8011d9:	56                   	push   %esi
  8011da:	6a 00                	push   $0x0
  8011dc:	56                   	push   %esi
  8011dd:	6a 00                	push   $0x0
  8011df:	e8 f0 fb ff ff       	call   800dd4 <sys_page_map>
  8011e4:	83 c4 20             	add    $0x20,%esp
  8011e7:	85 c0                	test   %eax,%eax
  8011e9:	0f 88 b3 00 00 00    	js     8012a2 <fork+0x175>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8011ef:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8011f5:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8011fb:	0f 84 b6 00 00 00    	je     8012b7 <fork+0x18a>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  801201:	89 d8                	mov    %ebx,%eax
  801203:	c1 e8 16             	shr    $0x16,%eax
  801206:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80120d:	a8 01                	test   $0x1,%al
  80120f:	74 de                	je     8011ef <fork+0xc2>
  801211:	89 de                	mov    %ebx,%esi
  801213:	c1 ee 0c             	shr    $0xc,%esi
  801216:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80121d:	a8 01                	test   $0x1,%al
  80121f:	74 ce                	je     8011ef <fork+0xc2>
  801221:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801228:	a8 04                	test   $0x4,%al
  80122a:	74 c3                	je     8011ef <fork+0xc2>
	if ((uvpt[pn] & PTE_SHARE)){
  80122c:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801233:	f6 c4 04             	test   $0x4,%ah
  801236:	0f 85 5b ff ff ff    	jne    801197 <fork+0x6a>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  80123c:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801243:	a8 02                	test   $0x2,%al
  801245:	0f 85 66 ff ff ff    	jne    8011b1 <fork+0x84>
  80124b:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801252:	f6 c4 08             	test   $0x8,%ah
  801255:	0f 85 56 ff ff ff    	jne    8011b1 <fork+0x84>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  80125b:	c1 e6 0c             	shl    $0xc,%esi
  80125e:	83 ec 0c             	sub    $0xc,%esp
  801261:	6a 05                	push   $0x5
  801263:	56                   	push   %esi
  801264:	57                   	push   %edi
  801265:	56                   	push   %esi
  801266:	6a 00                	push   $0x0
  801268:	e8 67 fb ff ff       	call   800dd4 <sys_page_map>
  80126d:	83 c4 20             	add    $0x20,%esp
  801270:	85 c0                	test   %eax,%eax
  801272:	0f 89 77 ff ff ff    	jns    8011ef <fork+0xc2>
		panic("duppage: %e\n", r);
  801278:	50                   	push   %eax
  801279:	68 2e 2e 80 00       	push   $0x802e2e
  80127e:	68 0c 01 00 00       	push   $0x10c
  801283:	68 06 2e 80 00       	push   $0x802e06
  801288:	e8 cd ef ff ff       	call   80025a <_panic>
			panic("duppage: %e\n", r);
  80128d:	50                   	push   %eax
  80128e:	68 2e 2e 80 00       	push   $0x802e2e
  801293:	68 05 01 00 00       	push   $0x105
  801298:	68 06 2e 80 00       	push   $0x802e06
  80129d:	e8 b8 ef ff ff       	call   80025a <_panic>
			panic("duppage: %e\n", r);
  8012a2:	50                   	push   %eax
  8012a3:	68 2e 2e 80 00       	push   $0x802e2e
  8012a8:	68 09 01 00 00       	push   $0x109
  8012ad:	68 06 2e 80 00       	push   $0x802e06
  8012b2:	e8 a3 ef ff ff       	call   80025a <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  8012b7:	83 ec 04             	sub    $0x4,%esp
  8012ba:	6a 07                	push   $0x7
  8012bc:	68 00 f0 bf ee       	push   $0xeebff000
  8012c1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012c4:	e8 c4 fa ff ff       	call   800d8d <sys_page_alloc>
  8012c9:	83 c4 10             	add    $0x10,%esp
  8012cc:	85 c0                	test   %eax,%eax
  8012ce:	78 2e                	js     8012fe <fork+0x1d1>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8012d0:	83 ec 08             	sub    $0x8,%esp
  8012d3:	68 15 27 80 00       	push   $0x802715
  8012d8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8012db:	57                   	push   %edi
  8012dc:	e8 0b fc ff ff       	call   800eec <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8012e1:	83 c4 08             	add    $0x8,%esp
  8012e4:	6a 02                	push   $0x2
  8012e6:	57                   	push   %edi
  8012e7:	e8 74 fb ff ff       	call   800e60 <sys_env_set_status>
  8012ec:	83 c4 10             	add    $0x10,%esp
  8012ef:	85 c0                	test   %eax,%eax
  8012f1:	78 20                	js     801313 <fork+0x1e6>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  8012f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012f9:	5b                   	pop    %ebx
  8012fa:	5e                   	pop    %esi
  8012fb:	5f                   	pop    %edi
  8012fc:	5d                   	pop    %ebp
  8012fd:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  8012fe:	50                   	push   %eax
  8012ff:	68 3b 2e 80 00       	push   $0x802e3b
  801304:	68 3e 01 00 00       	push   $0x13e
  801309:	68 06 2e 80 00       	push   $0x802e06
  80130e:	e8 47 ef ff ff       	call   80025a <_panic>
		panic("sys_env_set_status: %e", r);
  801313:	50                   	push   %eax
  801314:	68 4e 2e 80 00       	push   $0x802e4e
  801319:	68 43 01 00 00       	push   $0x143
  80131e:	68 06 2e 80 00       	push   $0x802e06
  801323:	e8 32 ef ff ff       	call   80025a <_panic>

00801328 <sfork>:

// Challenge!
int
sfork(void)
{
  801328:	f3 0f 1e fb          	endbr32 
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
  80132f:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801332:	68 65 2e 80 00       	push   $0x802e65
  801337:	68 4c 01 00 00       	push   $0x14c
  80133c:	68 06 2e 80 00       	push   $0x802e06
  801341:	e8 14 ef ff ff       	call   80025a <_panic>

00801346 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801346:	f3 0f 1e fb          	endbr32 
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
  80134d:	56                   	push   %esi
  80134e:	53                   	push   %ebx
  80134f:	8b 75 08             	mov    0x8(%ebp),%esi
  801352:	8b 45 0c             	mov    0xc(%ebp),%eax
  801355:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  801358:	85 c0                	test   %eax,%eax
  80135a:	74 3d                	je     801399 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  80135c:	83 ec 0c             	sub    $0xc,%esp
  80135f:	50                   	push   %eax
  801360:	e8 f4 fb ff ff       	call   800f59 <sys_ipc_recv>
  801365:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  801368:	85 f6                	test   %esi,%esi
  80136a:	74 0b                	je     801377 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  80136c:	8b 15 08 50 80 00    	mov    0x805008,%edx
  801372:	8b 52 74             	mov    0x74(%edx),%edx
  801375:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801377:	85 db                	test   %ebx,%ebx
  801379:	74 0b                	je     801386 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  80137b:	8b 15 08 50 80 00    	mov    0x805008,%edx
  801381:	8b 52 78             	mov    0x78(%edx),%edx
  801384:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  801386:	85 c0                	test   %eax,%eax
  801388:	78 21                	js     8013ab <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  80138a:	a1 08 50 80 00       	mov    0x805008,%eax
  80138f:	8b 40 70             	mov    0x70(%eax),%eax
}
  801392:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801395:	5b                   	pop    %ebx
  801396:	5e                   	pop    %esi
  801397:	5d                   	pop    %ebp
  801398:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  801399:	83 ec 0c             	sub    $0xc,%esp
  80139c:	68 00 00 c0 ee       	push   $0xeec00000
  8013a1:	e8 b3 fb ff ff       	call   800f59 <sys_ipc_recv>
  8013a6:	83 c4 10             	add    $0x10,%esp
  8013a9:	eb bd                	jmp    801368 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  8013ab:	85 f6                	test   %esi,%esi
  8013ad:	74 10                	je     8013bf <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  8013af:	85 db                	test   %ebx,%ebx
  8013b1:	75 df                	jne    801392 <ipc_recv+0x4c>
  8013b3:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8013ba:	00 00 00 
  8013bd:	eb d3                	jmp    801392 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  8013bf:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8013c6:	00 00 00 
  8013c9:	eb e4                	jmp    8013af <ipc_recv+0x69>

008013cb <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8013cb:	f3 0f 1e fb          	endbr32 
  8013cf:	55                   	push   %ebp
  8013d0:	89 e5                	mov    %esp,%ebp
  8013d2:	57                   	push   %edi
  8013d3:	56                   	push   %esi
  8013d4:	53                   	push   %ebx
  8013d5:	83 ec 0c             	sub    $0xc,%esp
  8013d8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013db:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013de:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  8013e1:	85 db                	test   %ebx,%ebx
  8013e3:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8013e8:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  8013eb:	ff 75 14             	pushl  0x14(%ebp)
  8013ee:	53                   	push   %ebx
  8013ef:	56                   	push   %esi
  8013f0:	57                   	push   %edi
  8013f1:	e8 3c fb ff ff       	call   800f32 <sys_ipc_try_send>
  8013f6:	83 c4 10             	add    $0x10,%esp
  8013f9:	85 c0                	test   %eax,%eax
  8013fb:	79 1e                	jns    80141b <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  8013fd:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801400:	75 07                	jne    801409 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  801402:	e8 63 f9 ff ff       	call   800d6a <sys_yield>
  801407:	eb e2                	jmp    8013eb <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  801409:	50                   	push   %eax
  80140a:	68 7b 2e 80 00       	push   $0x802e7b
  80140f:	6a 59                	push   $0x59
  801411:	68 96 2e 80 00       	push   $0x802e96
  801416:	e8 3f ee ff ff       	call   80025a <_panic>
	}
}
  80141b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80141e:	5b                   	pop    %ebx
  80141f:	5e                   	pop    %esi
  801420:	5f                   	pop    %edi
  801421:	5d                   	pop    %ebp
  801422:	c3                   	ret    

00801423 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801423:	f3 0f 1e fb          	endbr32 
  801427:	55                   	push   %ebp
  801428:	89 e5                	mov    %esp,%ebp
  80142a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80142d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801432:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801435:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80143b:	8b 52 50             	mov    0x50(%edx),%edx
  80143e:	39 ca                	cmp    %ecx,%edx
  801440:	74 11                	je     801453 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801442:	83 c0 01             	add    $0x1,%eax
  801445:	3d 00 04 00 00       	cmp    $0x400,%eax
  80144a:	75 e6                	jne    801432 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  80144c:	b8 00 00 00 00       	mov    $0x0,%eax
  801451:	eb 0b                	jmp    80145e <ipc_find_env+0x3b>
			return envs[i].env_id;
  801453:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801456:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80145b:	8b 40 48             	mov    0x48(%eax),%eax
}
  80145e:	5d                   	pop    %ebp
  80145f:	c3                   	ret    

00801460 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801460:	f3 0f 1e fb          	endbr32 
  801464:	55                   	push   %ebp
  801465:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801467:	8b 45 08             	mov    0x8(%ebp),%eax
  80146a:	05 00 00 00 30       	add    $0x30000000,%eax
  80146f:	c1 e8 0c             	shr    $0xc,%eax
}
  801472:	5d                   	pop    %ebp
  801473:	c3                   	ret    

00801474 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801474:	f3 0f 1e fb          	endbr32 
  801478:	55                   	push   %ebp
  801479:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80147b:	8b 45 08             	mov    0x8(%ebp),%eax
  80147e:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801483:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801488:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80148d:	5d                   	pop    %ebp
  80148e:	c3                   	ret    

0080148f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80148f:	f3 0f 1e fb          	endbr32 
  801493:	55                   	push   %ebp
  801494:	89 e5                	mov    %esp,%ebp
  801496:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80149b:	89 c2                	mov    %eax,%edx
  80149d:	c1 ea 16             	shr    $0x16,%edx
  8014a0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8014a7:	f6 c2 01             	test   $0x1,%dl
  8014aa:	74 2d                	je     8014d9 <fd_alloc+0x4a>
  8014ac:	89 c2                	mov    %eax,%edx
  8014ae:	c1 ea 0c             	shr    $0xc,%edx
  8014b1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014b8:	f6 c2 01             	test   $0x1,%dl
  8014bb:	74 1c                	je     8014d9 <fd_alloc+0x4a>
  8014bd:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8014c2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8014c7:	75 d2                	jne    80149b <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8014c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8014d2:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8014d7:	eb 0a                	jmp    8014e3 <fd_alloc+0x54>
			*fd_store = fd;
  8014d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014dc:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014e3:	5d                   	pop    %ebp
  8014e4:	c3                   	ret    

008014e5 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8014e5:	f3 0f 1e fb          	endbr32 
  8014e9:	55                   	push   %ebp
  8014ea:	89 e5                	mov    %esp,%ebp
  8014ec:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8014ef:	83 f8 1f             	cmp    $0x1f,%eax
  8014f2:	77 30                	ja     801524 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8014f4:	c1 e0 0c             	shl    $0xc,%eax
  8014f7:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8014fc:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801502:	f6 c2 01             	test   $0x1,%dl
  801505:	74 24                	je     80152b <fd_lookup+0x46>
  801507:	89 c2                	mov    %eax,%edx
  801509:	c1 ea 0c             	shr    $0xc,%edx
  80150c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801513:	f6 c2 01             	test   $0x1,%dl
  801516:	74 1a                	je     801532 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801518:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151b:	89 02                	mov    %eax,(%edx)
	return 0;
  80151d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801522:	5d                   	pop    %ebp
  801523:	c3                   	ret    
		return -E_INVAL;
  801524:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801529:	eb f7                	jmp    801522 <fd_lookup+0x3d>
		return -E_INVAL;
  80152b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801530:	eb f0                	jmp    801522 <fd_lookup+0x3d>
  801532:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801537:	eb e9                	jmp    801522 <fd_lookup+0x3d>

00801539 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801539:	f3 0f 1e fb          	endbr32 
  80153d:	55                   	push   %ebp
  80153e:	89 e5                	mov    %esp,%ebp
  801540:	83 ec 08             	sub    $0x8,%esp
  801543:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801546:	ba 00 00 00 00       	mov    $0x0,%edx
  80154b:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801550:	39 08                	cmp    %ecx,(%eax)
  801552:	74 38                	je     80158c <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  801554:	83 c2 01             	add    $0x1,%edx
  801557:	8b 04 95 1c 2f 80 00 	mov    0x802f1c(,%edx,4),%eax
  80155e:	85 c0                	test   %eax,%eax
  801560:	75 ee                	jne    801550 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801562:	a1 08 50 80 00       	mov    0x805008,%eax
  801567:	8b 40 48             	mov    0x48(%eax),%eax
  80156a:	83 ec 04             	sub    $0x4,%esp
  80156d:	51                   	push   %ecx
  80156e:	50                   	push   %eax
  80156f:	68 a0 2e 80 00       	push   $0x802ea0
  801574:	e8 c8 ed ff ff       	call   800341 <cprintf>
	*dev = 0;
  801579:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801582:	83 c4 10             	add    $0x10,%esp
  801585:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80158a:	c9                   	leave  
  80158b:	c3                   	ret    
			*dev = devtab[i];
  80158c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80158f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801591:	b8 00 00 00 00       	mov    $0x0,%eax
  801596:	eb f2                	jmp    80158a <dev_lookup+0x51>

00801598 <fd_close>:
{
  801598:	f3 0f 1e fb          	endbr32 
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
  80159f:	57                   	push   %edi
  8015a0:	56                   	push   %esi
  8015a1:	53                   	push   %ebx
  8015a2:	83 ec 24             	sub    $0x24,%esp
  8015a5:	8b 75 08             	mov    0x8(%ebp),%esi
  8015a8:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015ab:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015ae:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015af:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8015b5:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015b8:	50                   	push   %eax
  8015b9:	e8 27 ff ff ff       	call   8014e5 <fd_lookup>
  8015be:	89 c3                	mov    %eax,%ebx
  8015c0:	83 c4 10             	add    $0x10,%esp
  8015c3:	85 c0                	test   %eax,%eax
  8015c5:	78 05                	js     8015cc <fd_close+0x34>
	    || fd != fd2)
  8015c7:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8015ca:	74 16                	je     8015e2 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8015cc:	89 f8                	mov    %edi,%eax
  8015ce:	84 c0                	test   %al,%al
  8015d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d5:	0f 44 d8             	cmove  %eax,%ebx
}
  8015d8:	89 d8                	mov    %ebx,%eax
  8015da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015dd:	5b                   	pop    %ebx
  8015de:	5e                   	pop    %esi
  8015df:	5f                   	pop    %edi
  8015e0:	5d                   	pop    %ebp
  8015e1:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8015e2:	83 ec 08             	sub    $0x8,%esp
  8015e5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8015e8:	50                   	push   %eax
  8015e9:	ff 36                	pushl  (%esi)
  8015eb:	e8 49 ff ff ff       	call   801539 <dev_lookup>
  8015f0:	89 c3                	mov    %eax,%ebx
  8015f2:	83 c4 10             	add    $0x10,%esp
  8015f5:	85 c0                	test   %eax,%eax
  8015f7:	78 1a                	js     801613 <fd_close+0x7b>
		if (dev->dev_close)
  8015f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015fc:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8015ff:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801604:	85 c0                	test   %eax,%eax
  801606:	74 0b                	je     801613 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801608:	83 ec 0c             	sub    $0xc,%esp
  80160b:	56                   	push   %esi
  80160c:	ff d0                	call   *%eax
  80160e:	89 c3                	mov    %eax,%ebx
  801610:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801613:	83 ec 08             	sub    $0x8,%esp
  801616:	56                   	push   %esi
  801617:	6a 00                	push   $0x0
  801619:	e8 fc f7 ff ff       	call   800e1a <sys_page_unmap>
	return r;
  80161e:	83 c4 10             	add    $0x10,%esp
  801621:	eb b5                	jmp    8015d8 <fd_close+0x40>

00801623 <close>:

int
close(int fdnum)
{
  801623:	f3 0f 1e fb          	endbr32 
  801627:	55                   	push   %ebp
  801628:	89 e5                	mov    %esp,%ebp
  80162a:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80162d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801630:	50                   	push   %eax
  801631:	ff 75 08             	pushl  0x8(%ebp)
  801634:	e8 ac fe ff ff       	call   8014e5 <fd_lookup>
  801639:	83 c4 10             	add    $0x10,%esp
  80163c:	85 c0                	test   %eax,%eax
  80163e:	79 02                	jns    801642 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801640:	c9                   	leave  
  801641:	c3                   	ret    
		return fd_close(fd, 1);
  801642:	83 ec 08             	sub    $0x8,%esp
  801645:	6a 01                	push   $0x1
  801647:	ff 75 f4             	pushl  -0xc(%ebp)
  80164a:	e8 49 ff ff ff       	call   801598 <fd_close>
  80164f:	83 c4 10             	add    $0x10,%esp
  801652:	eb ec                	jmp    801640 <close+0x1d>

00801654 <close_all>:

void
close_all(void)
{
  801654:	f3 0f 1e fb          	endbr32 
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
  80165b:	53                   	push   %ebx
  80165c:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80165f:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801664:	83 ec 0c             	sub    $0xc,%esp
  801667:	53                   	push   %ebx
  801668:	e8 b6 ff ff ff       	call   801623 <close>
	for (i = 0; i < MAXFD; i++)
  80166d:	83 c3 01             	add    $0x1,%ebx
  801670:	83 c4 10             	add    $0x10,%esp
  801673:	83 fb 20             	cmp    $0x20,%ebx
  801676:	75 ec                	jne    801664 <close_all+0x10>
}
  801678:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80167b:	c9                   	leave  
  80167c:	c3                   	ret    

0080167d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80167d:	f3 0f 1e fb          	endbr32 
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
  801684:	57                   	push   %edi
  801685:	56                   	push   %esi
  801686:	53                   	push   %ebx
  801687:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80168a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80168d:	50                   	push   %eax
  80168e:	ff 75 08             	pushl  0x8(%ebp)
  801691:	e8 4f fe ff ff       	call   8014e5 <fd_lookup>
  801696:	89 c3                	mov    %eax,%ebx
  801698:	83 c4 10             	add    $0x10,%esp
  80169b:	85 c0                	test   %eax,%eax
  80169d:	0f 88 81 00 00 00    	js     801724 <dup+0xa7>
		return r;
	close(newfdnum);
  8016a3:	83 ec 0c             	sub    $0xc,%esp
  8016a6:	ff 75 0c             	pushl  0xc(%ebp)
  8016a9:	e8 75 ff ff ff       	call   801623 <close>

	newfd = INDEX2FD(newfdnum);
  8016ae:	8b 75 0c             	mov    0xc(%ebp),%esi
  8016b1:	c1 e6 0c             	shl    $0xc,%esi
  8016b4:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8016ba:	83 c4 04             	add    $0x4,%esp
  8016bd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016c0:	e8 af fd ff ff       	call   801474 <fd2data>
  8016c5:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8016c7:	89 34 24             	mov    %esi,(%esp)
  8016ca:	e8 a5 fd ff ff       	call   801474 <fd2data>
  8016cf:	83 c4 10             	add    $0x10,%esp
  8016d2:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8016d4:	89 d8                	mov    %ebx,%eax
  8016d6:	c1 e8 16             	shr    $0x16,%eax
  8016d9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016e0:	a8 01                	test   $0x1,%al
  8016e2:	74 11                	je     8016f5 <dup+0x78>
  8016e4:	89 d8                	mov    %ebx,%eax
  8016e6:	c1 e8 0c             	shr    $0xc,%eax
  8016e9:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8016f0:	f6 c2 01             	test   $0x1,%dl
  8016f3:	75 39                	jne    80172e <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016f5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016f8:	89 d0                	mov    %edx,%eax
  8016fa:	c1 e8 0c             	shr    $0xc,%eax
  8016fd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801704:	83 ec 0c             	sub    $0xc,%esp
  801707:	25 07 0e 00 00       	and    $0xe07,%eax
  80170c:	50                   	push   %eax
  80170d:	56                   	push   %esi
  80170e:	6a 00                	push   $0x0
  801710:	52                   	push   %edx
  801711:	6a 00                	push   $0x0
  801713:	e8 bc f6 ff ff       	call   800dd4 <sys_page_map>
  801718:	89 c3                	mov    %eax,%ebx
  80171a:	83 c4 20             	add    $0x20,%esp
  80171d:	85 c0                	test   %eax,%eax
  80171f:	78 31                	js     801752 <dup+0xd5>
		goto err;

	return newfdnum;
  801721:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801724:	89 d8                	mov    %ebx,%eax
  801726:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801729:	5b                   	pop    %ebx
  80172a:	5e                   	pop    %esi
  80172b:	5f                   	pop    %edi
  80172c:	5d                   	pop    %ebp
  80172d:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80172e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801735:	83 ec 0c             	sub    $0xc,%esp
  801738:	25 07 0e 00 00       	and    $0xe07,%eax
  80173d:	50                   	push   %eax
  80173e:	57                   	push   %edi
  80173f:	6a 00                	push   $0x0
  801741:	53                   	push   %ebx
  801742:	6a 00                	push   $0x0
  801744:	e8 8b f6 ff ff       	call   800dd4 <sys_page_map>
  801749:	89 c3                	mov    %eax,%ebx
  80174b:	83 c4 20             	add    $0x20,%esp
  80174e:	85 c0                	test   %eax,%eax
  801750:	79 a3                	jns    8016f5 <dup+0x78>
	sys_page_unmap(0, newfd);
  801752:	83 ec 08             	sub    $0x8,%esp
  801755:	56                   	push   %esi
  801756:	6a 00                	push   $0x0
  801758:	e8 bd f6 ff ff       	call   800e1a <sys_page_unmap>
	sys_page_unmap(0, nva);
  80175d:	83 c4 08             	add    $0x8,%esp
  801760:	57                   	push   %edi
  801761:	6a 00                	push   $0x0
  801763:	e8 b2 f6 ff ff       	call   800e1a <sys_page_unmap>
	return r;
  801768:	83 c4 10             	add    $0x10,%esp
  80176b:	eb b7                	jmp    801724 <dup+0xa7>

0080176d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80176d:	f3 0f 1e fb          	endbr32 
  801771:	55                   	push   %ebp
  801772:	89 e5                	mov    %esp,%ebp
  801774:	53                   	push   %ebx
  801775:	83 ec 1c             	sub    $0x1c,%esp
  801778:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80177b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80177e:	50                   	push   %eax
  80177f:	53                   	push   %ebx
  801780:	e8 60 fd ff ff       	call   8014e5 <fd_lookup>
  801785:	83 c4 10             	add    $0x10,%esp
  801788:	85 c0                	test   %eax,%eax
  80178a:	78 3f                	js     8017cb <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80178c:	83 ec 08             	sub    $0x8,%esp
  80178f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801792:	50                   	push   %eax
  801793:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801796:	ff 30                	pushl  (%eax)
  801798:	e8 9c fd ff ff       	call   801539 <dev_lookup>
  80179d:	83 c4 10             	add    $0x10,%esp
  8017a0:	85 c0                	test   %eax,%eax
  8017a2:	78 27                	js     8017cb <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8017a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017a7:	8b 42 08             	mov    0x8(%edx),%eax
  8017aa:	83 e0 03             	and    $0x3,%eax
  8017ad:	83 f8 01             	cmp    $0x1,%eax
  8017b0:	74 1e                	je     8017d0 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8017b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b5:	8b 40 08             	mov    0x8(%eax),%eax
  8017b8:	85 c0                	test   %eax,%eax
  8017ba:	74 35                	je     8017f1 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8017bc:	83 ec 04             	sub    $0x4,%esp
  8017bf:	ff 75 10             	pushl  0x10(%ebp)
  8017c2:	ff 75 0c             	pushl  0xc(%ebp)
  8017c5:	52                   	push   %edx
  8017c6:	ff d0                	call   *%eax
  8017c8:	83 c4 10             	add    $0x10,%esp
}
  8017cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ce:	c9                   	leave  
  8017cf:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8017d0:	a1 08 50 80 00       	mov    0x805008,%eax
  8017d5:	8b 40 48             	mov    0x48(%eax),%eax
  8017d8:	83 ec 04             	sub    $0x4,%esp
  8017db:	53                   	push   %ebx
  8017dc:	50                   	push   %eax
  8017dd:	68 e1 2e 80 00       	push   $0x802ee1
  8017e2:	e8 5a eb ff ff       	call   800341 <cprintf>
		return -E_INVAL;
  8017e7:	83 c4 10             	add    $0x10,%esp
  8017ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017ef:	eb da                	jmp    8017cb <read+0x5e>
		return -E_NOT_SUPP;
  8017f1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017f6:	eb d3                	jmp    8017cb <read+0x5e>

008017f8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8017f8:	f3 0f 1e fb          	endbr32 
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
  8017ff:	57                   	push   %edi
  801800:	56                   	push   %esi
  801801:	53                   	push   %ebx
  801802:	83 ec 0c             	sub    $0xc,%esp
  801805:	8b 7d 08             	mov    0x8(%ebp),%edi
  801808:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80180b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801810:	eb 02                	jmp    801814 <readn+0x1c>
  801812:	01 c3                	add    %eax,%ebx
  801814:	39 f3                	cmp    %esi,%ebx
  801816:	73 21                	jae    801839 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801818:	83 ec 04             	sub    $0x4,%esp
  80181b:	89 f0                	mov    %esi,%eax
  80181d:	29 d8                	sub    %ebx,%eax
  80181f:	50                   	push   %eax
  801820:	89 d8                	mov    %ebx,%eax
  801822:	03 45 0c             	add    0xc(%ebp),%eax
  801825:	50                   	push   %eax
  801826:	57                   	push   %edi
  801827:	e8 41 ff ff ff       	call   80176d <read>
		if (m < 0)
  80182c:	83 c4 10             	add    $0x10,%esp
  80182f:	85 c0                	test   %eax,%eax
  801831:	78 04                	js     801837 <readn+0x3f>
			return m;
		if (m == 0)
  801833:	75 dd                	jne    801812 <readn+0x1a>
  801835:	eb 02                	jmp    801839 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801837:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801839:	89 d8                	mov    %ebx,%eax
  80183b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80183e:	5b                   	pop    %ebx
  80183f:	5e                   	pop    %esi
  801840:	5f                   	pop    %edi
  801841:	5d                   	pop    %ebp
  801842:	c3                   	ret    

00801843 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801843:	f3 0f 1e fb          	endbr32 
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
  80184a:	53                   	push   %ebx
  80184b:	83 ec 1c             	sub    $0x1c,%esp
  80184e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801851:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801854:	50                   	push   %eax
  801855:	53                   	push   %ebx
  801856:	e8 8a fc ff ff       	call   8014e5 <fd_lookup>
  80185b:	83 c4 10             	add    $0x10,%esp
  80185e:	85 c0                	test   %eax,%eax
  801860:	78 3a                	js     80189c <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801862:	83 ec 08             	sub    $0x8,%esp
  801865:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801868:	50                   	push   %eax
  801869:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80186c:	ff 30                	pushl  (%eax)
  80186e:	e8 c6 fc ff ff       	call   801539 <dev_lookup>
  801873:	83 c4 10             	add    $0x10,%esp
  801876:	85 c0                	test   %eax,%eax
  801878:	78 22                	js     80189c <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80187a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80187d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801881:	74 1e                	je     8018a1 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801883:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801886:	8b 52 0c             	mov    0xc(%edx),%edx
  801889:	85 d2                	test   %edx,%edx
  80188b:	74 35                	je     8018c2 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80188d:	83 ec 04             	sub    $0x4,%esp
  801890:	ff 75 10             	pushl  0x10(%ebp)
  801893:	ff 75 0c             	pushl  0xc(%ebp)
  801896:	50                   	push   %eax
  801897:	ff d2                	call   *%edx
  801899:	83 c4 10             	add    $0x10,%esp
}
  80189c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80189f:	c9                   	leave  
  8018a0:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8018a1:	a1 08 50 80 00       	mov    0x805008,%eax
  8018a6:	8b 40 48             	mov    0x48(%eax),%eax
  8018a9:	83 ec 04             	sub    $0x4,%esp
  8018ac:	53                   	push   %ebx
  8018ad:	50                   	push   %eax
  8018ae:	68 fd 2e 80 00       	push   $0x802efd
  8018b3:	e8 89 ea ff ff       	call   800341 <cprintf>
		return -E_INVAL;
  8018b8:	83 c4 10             	add    $0x10,%esp
  8018bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018c0:	eb da                	jmp    80189c <write+0x59>
		return -E_NOT_SUPP;
  8018c2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018c7:	eb d3                	jmp    80189c <write+0x59>

008018c9 <seek>:

int
seek(int fdnum, off_t offset)
{
  8018c9:	f3 0f 1e fb          	endbr32 
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
  8018d0:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018d6:	50                   	push   %eax
  8018d7:	ff 75 08             	pushl  0x8(%ebp)
  8018da:	e8 06 fc ff ff       	call   8014e5 <fd_lookup>
  8018df:	83 c4 10             	add    $0x10,%esp
  8018e2:	85 c0                	test   %eax,%eax
  8018e4:	78 0e                	js     8018f4 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8018e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ec:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8018ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018f4:	c9                   	leave  
  8018f5:	c3                   	ret    

008018f6 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8018f6:	f3 0f 1e fb          	endbr32 
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
  8018fd:	53                   	push   %ebx
  8018fe:	83 ec 1c             	sub    $0x1c,%esp
  801901:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801904:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801907:	50                   	push   %eax
  801908:	53                   	push   %ebx
  801909:	e8 d7 fb ff ff       	call   8014e5 <fd_lookup>
  80190e:	83 c4 10             	add    $0x10,%esp
  801911:	85 c0                	test   %eax,%eax
  801913:	78 37                	js     80194c <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801915:	83 ec 08             	sub    $0x8,%esp
  801918:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80191b:	50                   	push   %eax
  80191c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80191f:	ff 30                	pushl  (%eax)
  801921:	e8 13 fc ff ff       	call   801539 <dev_lookup>
  801926:	83 c4 10             	add    $0x10,%esp
  801929:	85 c0                	test   %eax,%eax
  80192b:	78 1f                	js     80194c <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80192d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801930:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801934:	74 1b                	je     801951 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801936:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801939:	8b 52 18             	mov    0x18(%edx),%edx
  80193c:	85 d2                	test   %edx,%edx
  80193e:	74 32                	je     801972 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801940:	83 ec 08             	sub    $0x8,%esp
  801943:	ff 75 0c             	pushl  0xc(%ebp)
  801946:	50                   	push   %eax
  801947:	ff d2                	call   *%edx
  801949:	83 c4 10             	add    $0x10,%esp
}
  80194c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80194f:	c9                   	leave  
  801950:	c3                   	ret    
			thisenv->env_id, fdnum);
  801951:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801956:	8b 40 48             	mov    0x48(%eax),%eax
  801959:	83 ec 04             	sub    $0x4,%esp
  80195c:	53                   	push   %ebx
  80195d:	50                   	push   %eax
  80195e:	68 c0 2e 80 00       	push   $0x802ec0
  801963:	e8 d9 e9 ff ff       	call   800341 <cprintf>
		return -E_INVAL;
  801968:	83 c4 10             	add    $0x10,%esp
  80196b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801970:	eb da                	jmp    80194c <ftruncate+0x56>
		return -E_NOT_SUPP;
  801972:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801977:	eb d3                	jmp    80194c <ftruncate+0x56>

00801979 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801979:	f3 0f 1e fb          	endbr32 
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
  801980:	53                   	push   %ebx
  801981:	83 ec 1c             	sub    $0x1c,%esp
  801984:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801987:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80198a:	50                   	push   %eax
  80198b:	ff 75 08             	pushl  0x8(%ebp)
  80198e:	e8 52 fb ff ff       	call   8014e5 <fd_lookup>
  801993:	83 c4 10             	add    $0x10,%esp
  801996:	85 c0                	test   %eax,%eax
  801998:	78 4b                	js     8019e5 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80199a:	83 ec 08             	sub    $0x8,%esp
  80199d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019a0:	50                   	push   %eax
  8019a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a4:	ff 30                	pushl  (%eax)
  8019a6:	e8 8e fb ff ff       	call   801539 <dev_lookup>
  8019ab:	83 c4 10             	add    $0x10,%esp
  8019ae:	85 c0                	test   %eax,%eax
  8019b0:	78 33                	js     8019e5 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8019b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b5:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8019b9:	74 2f                	je     8019ea <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8019bb:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8019be:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8019c5:	00 00 00 
	stat->st_isdir = 0;
  8019c8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019cf:	00 00 00 
	stat->st_dev = dev;
  8019d2:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8019d8:	83 ec 08             	sub    $0x8,%esp
  8019db:	53                   	push   %ebx
  8019dc:	ff 75 f0             	pushl  -0x10(%ebp)
  8019df:	ff 50 14             	call   *0x14(%eax)
  8019e2:	83 c4 10             	add    $0x10,%esp
}
  8019e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    
		return -E_NOT_SUPP;
  8019ea:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019ef:	eb f4                	jmp    8019e5 <fstat+0x6c>

008019f1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8019f1:	f3 0f 1e fb          	endbr32 
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
  8019f8:	56                   	push   %esi
  8019f9:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8019fa:	83 ec 08             	sub    $0x8,%esp
  8019fd:	6a 00                	push   $0x0
  8019ff:	ff 75 08             	pushl  0x8(%ebp)
  801a02:	e8 fb 01 00 00       	call   801c02 <open>
  801a07:	89 c3                	mov    %eax,%ebx
  801a09:	83 c4 10             	add    $0x10,%esp
  801a0c:	85 c0                	test   %eax,%eax
  801a0e:	78 1b                	js     801a2b <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801a10:	83 ec 08             	sub    $0x8,%esp
  801a13:	ff 75 0c             	pushl  0xc(%ebp)
  801a16:	50                   	push   %eax
  801a17:	e8 5d ff ff ff       	call   801979 <fstat>
  801a1c:	89 c6                	mov    %eax,%esi
	close(fd);
  801a1e:	89 1c 24             	mov    %ebx,(%esp)
  801a21:	e8 fd fb ff ff       	call   801623 <close>
	return r;
  801a26:	83 c4 10             	add    $0x10,%esp
  801a29:	89 f3                	mov    %esi,%ebx
}
  801a2b:	89 d8                	mov    %ebx,%eax
  801a2d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a30:	5b                   	pop    %ebx
  801a31:	5e                   	pop    %esi
  801a32:	5d                   	pop    %ebp
  801a33:	c3                   	ret    

00801a34 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
  801a37:	56                   	push   %esi
  801a38:	53                   	push   %ebx
  801a39:	89 c6                	mov    %eax,%esi
  801a3b:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801a3d:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801a44:	74 27                	je     801a6d <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a46:	6a 07                	push   $0x7
  801a48:	68 00 60 80 00       	push   $0x806000
  801a4d:	56                   	push   %esi
  801a4e:	ff 35 00 50 80 00    	pushl  0x805000
  801a54:	e8 72 f9 ff ff       	call   8013cb <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a59:	83 c4 0c             	add    $0xc,%esp
  801a5c:	6a 00                	push   $0x0
  801a5e:	53                   	push   %ebx
  801a5f:	6a 00                	push   $0x0
  801a61:	e8 e0 f8 ff ff       	call   801346 <ipc_recv>
}
  801a66:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a69:	5b                   	pop    %ebx
  801a6a:	5e                   	pop    %esi
  801a6b:	5d                   	pop    %ebp
  801a6c:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a6d:	83 ec 0c             	sub    $0xc,%esp
  801a70:	6a 01                	push   $0x1
  801a72:	e8 ac f9 ff ff       	call   801423 <ipc_find_env>
  801a77:	a3 00 50 80 00       	mov    %eax,0x805000
  801a7c:	83 c4 10             	add    $0x10,%esp
  801a7f:	eb c5                	jmp    801a46 <fsipc+0x12>

00801a81 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a81:	f3 0f 1e fb          	endbr32 
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
  801a88:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8e:	8b 40 0c             	mov    0xc(%eax),%eax
  801a91:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801a96:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a99:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a9e:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa3:	b8 02 00 00 00       	mov    $0x2,%eax
  801aa8:	e8 87 ff ff ff       	call   801a34 <fsipc>
}
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <devfile_flush>:
{
  801aaf:	f3 0f 1e fb          	endbr32 
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
  801ab6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  801abc:	8b 40 0c             	mov    0xc(%eax),%eax
  801abf:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801ac4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac9:	b8 06 00 00 00       	mov    $0x6,%eax
  801ace:	e8 61 ff ff ff       	call   801a34 <fsipc>
}
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <devfile_stat>:
{
  801ad5:	f3 0f 1e fb          	endbr32 
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
  801adc:	53                   	push   %ebx
  801add:	83 ec 04             	sub    $0x4,%esp
  801ae0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae6:	8b 40 0c             	mov    0xc(%eax),%eax
  801ae9:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801aee:	ba 00 00 00 00       	mov    $0x0,%edx
  801af3:	b8 05 00 00 00       	mov    $0x5,%eax
  801af8:	e8 37 ff ff ff       	call   801a34 <fsipc>
  801afd:	85 c0                	test   %eax,%eax
  801aff:	78 2c                	js     801b2d <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b01:	83 ec 08             	sub    $0x8,%esp
  801b04:	68 00 60 80 00       	push   $0x806000
  801b09:	53                   	push   %ebx
  801b0a:	e8 3c ee ff ff       	call   80094b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b0f:	a1 80 60 80 00       	mov    0x806080,%eax
  801b14:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b1a:	a1 84 60 80 00       	mov    0x806084,%eax
  801b1f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b25:	83 c4 10             	add    $0x10,%esp
  801b28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b2d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <devfile_write>:
{
  801b32:	f3 0f 1e fb          	endbr32 
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
  801b39:	83 ec 0c             	sub    $0xc,%esp
  801b3c:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801b3f:	8b 55 08             	mov    0x8(%ebp),%edx
  801b42:	8b 52 0c             	mov    0xc(%edx),%edx
  801b45:	89 15 00 60 80 00    	mov    %edx,0x806000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801b4b:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801b50:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801b55:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  801b58:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801b5d:	50                   	push   %eax
  801b5e:	ff 75 0c             	pushl  0xc(%ebp)
  801b61:	68 08 60 80 00       	push   $0x806008
  801b66:	e8 96 ef ff ff       	call   800b01 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801b6b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b70:	b8 04 00 00 00       	mov    $0x4,%eax
  801b75:	e8 ba fe ff ff       	call   801a34 <fsipc>
}
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <devfile_read>:
{
  801b7c:	f3 0f 1e fb          	endbr32 
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
  801b83:	56                   	push   %esi
  801b84:	53                   	push   %ebx
  801b85:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b88:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8b:	8b 40 0c             	mov    0xc(%eax),%eax
  801b8e:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801b93:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b99:	ba 00 00 00 00       	mov    $0x0,%edx
  801b9e:	b8 03 00 00 00       	mov    $0x3,%eax
  801ba3:	e8 8c fe ff ff       	call   801a34 <fsipc>
  801ba8:	89 c3                	mov    %eax,%ebx
  801baa:	85 c0                	test   %eax,%eax
  801bac:	78 1f                	js     801bcd <devfile_read+0x51>
	assert(r <= n);
  801bae:	39 f0                	cmp    %esi,%eax
  801bb0:	77 24                	ja     801bd6 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801bb2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bb7:	7f 33                	jg     801bec <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801bb9:	83 ec 04             	sub    $0x4,%esp
  801bbc:	50                   	push   %eax
  801bbd:	68 00 60 80 00       	push   $0x806000
  801bc2:	ff 75 0c             	pushl  0xc(%ebp)
  801bc5:	e8 37 ef ff ff       	call   800b01 <memmove>
	return r;
  801bca:	83 c4 10             	add    $0x10,%esp
}
  801bcd:	89 d8                	mov    %ebx,%eax
  801bcf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bd2:	5b                   	pop    %ebx
  801bd3:	5e                   	pop    %esi
  801bd4:	5d                   	pop    %ebp
  801bd5:	c3                   	ret    
	assert(r <= n);
  801bd6:	68 30 2f 80 00       	push   $0x802f30
  801bdb:	68 37 2f 80 00       	push   $0x802f37
  801be0:	6a 7c                	push   $0x7c
  801be2:	68 4c 2f 80 00       	push   $0x802f4c
  801be7:	e8 6e e6 ff ff       	call   80025a <_panic>
	assert(r <= PGSIZE);
  801bec:	68 57 2f 80 00       	push   $0x802f57
  801bf1:	68 37 2f 80 00       	push   $0x802f37
  801bf6:	6a 7d                	push   $0x7d
  801bf8:	68 4c 2f 80 00       	push   $0x802f4c
  801bfd:	e8 58 e6 ff ff       	call   80025a <_panic>

00801c02 <open>:
{
  801c02:	f3 0f 1e fb          	endbr32 
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
  801c09:	56                   	push   %esi
  801c0a:	53                   	push   %ebx
  801c0b:	83 ec 1c             	sub    $0x1c,%esp
  801c0e:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801c11:	56                   	push   %esi
  801c12:	e8 f1 ec ff ff       	call   800908 <strlen>
  801c17:	83 c4 10             	add    $0x10,%esp
  801c1a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c1f:	7f 6c                	jg     801c8d <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801c21:	83 ec 0c             	sub    $0xc,%esp
  801c24:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c27:	50                   	push   %eax
  801c28:	e8 62 f8 ff ff       	call   80148f <fd_alloc>
  801c2d:	89 c3                	mov    %eax,%ebx
  801c2f:	83 c4 10             	add    $0x10,%esp
  801c32:	85 c0                	test   %eax,%eax
  801c34:	78 3c                	js     801c72 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801c36:	83 ec 08             	sub    $0x8,%esp
  801c39:	56                   	push   %esi
  801c3a:	68 00 60 80 00       	push   $0x806000
  801c3f:	e8 07 ed ff ff       	call   80094b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c44:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c47:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c4f:	b8 01 00 00 00       	mov    $0x1,%eax
  801c54:	e8 db fd ff ff       	call   801a34 <fsipc>
  801c59:	89 c3                	mov    %eax,%ebx
  801c5b:	83 c4 10             	add    $0x10,%esp
  801c5e:	85 c0                	test   %eax,%eax
  801c60:	78 19                	js     801c7b <open+0x79>
	return fd2num(fd);
  801c62:	83 ec 0c             	sub    $0xc,%esp
  801c65:	ff 75 f4             	pushl  -0xc(%ebp)
  801c68:	e8 f3 f7 ff ff       	call   801460 <fd2num>
  801c6d:	89 c3                	mov    %eax,%ebx
  801c6f:	83 c4 10             	add    $0x10,%esp
}
  801c72:	89 d8                	mov    %ebx,%eax
  801c74:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c77:	5b                   	pop    %ebx
  801c78:	5e                   	pop    %esi
  801c79:	5d                   	pop    %ebp
  801c7a:	c3                   	ret    
		fd_close(fd, 0);
  801c7b:	83 ec 08             	sub    $0x8,%esp
  801c7e:	6a 00                	push   $0x0
  801c80:	ff 75 f4             	pushl  -0xc(%ebp)
  801c83:	e8 10 f9 ff ff       	call   801598 <fd_close>
		return r;
  801c88:	83 c4 10             	add    $0x10,%esp
  801c8b:	eb e5                	jmp    801c72 <open+0x70>
		return -E_BAD_PATH;
  801c8d:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801c92:	eb de                	jmp    801c72 <open+0x70>

00801c94 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c94:	f3 0f 1e fb          	endbr32 
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c9e:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca3:	b8 08 00 00 00       	mov    $0x8,%eax
  801ca8:	e8 87 fd ff ff       	call   801a34 <fsipc>
}
  801cad:	c9                   	leave  
  801cae:	c3                   	ret    

00801caf <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801caf:	f3 0f 1e fb          	endbr32 
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
  801cb6:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801cb9:	89 c2                	mov    %eax,%edx
  801cbb:	c1 ea 16             	shr    $0x16,%edx
  801cbe:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801cc5:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801cca:	f6 c1 01             	test   $0x1,%cl
  801ccd:	74 1c                	je     801ceb <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801ccf:	c1 e8 0c             	shr    $0xc,%eax
  801cd2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801cd9:	a8 01                	test   $0x1,%al
  801cdb:	74 0e                	je     801ceb <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801cdd:	c1 e8 0c             	shr    $0xc,%eax
  801ce0:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801ce7:	ef 
  801ce8:	0f b7 d2             	movzwl %dx,%edx
}
  801ceb:	89 d0                	mov    %edx,%eax
  801ced:	5d                   	pop    %ebp
  801cee:	c3                   	ret    

00801cef <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801cef:	f3 0f 1e fb          	endbr32 
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
  801cf6:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801cf9:	68 63 2f 80 00       	push   $0x802f63
  801cfe:	ff 75 0c             	pushl  0xc(%ebp)
  801d01:	e8 45 ec ff ff       	call   80094b <strcpy>
	return 0;
}
  801d06:	b8 00 00 00 00       	mov    $0x0,%eax
  801d0b:	c9                   	leave  
  801d0c:	c3                   	ret    

00801d0d <devsock_close>:
{
  801d0d:	f3 0f 1e fb          	endbr32 
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
  801d14:	53                   	push   %ebx
  801d15:	83 ec 10             	sub    $0x10,%esp
  801d18:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801d1b:	53                   	push   %ebx
  801d1c:	e8 8e ff ff ff       	call   801caf <pageref>
  801d21:	89 c2                	mov    %eax,%edx
  801d23:	83 c4 10             	add    $0x10,%esp
		return 0;
  801d26:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801d2b:	83 fa 01             	cmp    $0x1,%edx
  801d2e:	74 05                	je     801d35 <devsock_close+0x28>
}
  801d30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d33:	c9                   	leave  
  801d34:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801d35:	83 ec 0c             	sub    $0xc,%esp
  801d38:	ff 73 0c             	pushl  0xc(%ebx)
  801d3b:	e8 e3 02 00 00       	call   802023 <nsipc_close>
  801d40:	83 c4 10             	add    $0x10,%esp
  801d43:	eb eb                	jmp    801d30 <devsock_close+0x23>

00801d45 <devsock_write>:
{
  801d45:	f3 0f 1e fb          	endbr32 
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
  801d4c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801d4f:	6a 00                	push   $0x0
  801d51:	ff 75 10             	pushl  0x10(%ebp)
  801d54:	ff 75 0c             	pushl  0xc(%ebp)
  801d57:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5a:	ff 70 0c             	pushl  0xc(%eax)
  801d5d:	e8 b5 03 00 00       	call   802117 <nsipc_send>
}
  801d62:	c9                   	leave  
  801d63:	c3                   	ret    

00801d64 <devsock_read>:
{
  801d64:	f3 0f 1e fb          	endbr32 
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
  801d6b:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801d6e:	6a 00                	push   $0x0
  801d70:	ff 75 10             	pushl  0x10(%ebp)
  801d73:	ff 75 0c             	pushl  0xc(%ebp)
  801d76:	8b 45 08             	mov    0x8(%ebp),%eax
  801d79:	ff 70 0c             	pushl  0xc(%eax)
  801d7c:	e8 1f 03 00 00       	call   8020a0 <nsipc_recv>
}
  801d81:	c9                   	leave  
  801d82:	c3                   	ret    

00801d83 <fd2sockid>:
{
  801d83:	55                   	push   %ebp
  801d84:	89 e5                	mov    %esp,%ebp
  801d86:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801d89:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d8c:	52                   	push   %edx
  801d8d:	50                   	push   %eax
  801d8e:	e8 52 f7 ff ff       	call   8014e5 <fd_lookup>
  801d93:	83 c4 10             	add    $0x10,%esp
  801d96:	85 c0                	test   %eax,%eax
  801d98:	78 10                	js     801daa <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9d:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801da3:	39 08                	cmp    %ecx,(%eax)
  801da5:	75 05                	jne    801dac <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801da7:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801daa:	c9                   	leave  
  801dab:	c3                   	ret    
		return -E_NOT_SUPP;
  801dac:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801db1:	eb f7                	jmp    801daa <fd2sockid+0x27>

00801db3 <alloc_sockfd>:
{
  801db3:	55                   	push   %ebp
  801db4:	89 e5                	mov    %esp,%ebp
  801db6:	56                   	push   %esi
  801db7:	53                   	push   %ebx
  801db8:	83 ec 1c             	sub    $0x1c,%esp
  801dbb:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801dbd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dc0:	50                   	push   %eax
  801dc1:	e8 c9 f6 ff ff       	call   80148f <fd_alloc>
  801dc6:	89 c3                	mov    %eax,%ebx
  801dc8:	83 c4 10             	add    $0x10,%esp
  801dcb:	85 c0                	test   %eax,%eax
  801dcd:	78 43                	js     801e12 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801dcf:	83 ec 04             	sub    $0x4,%esp
  801dd2:	68 07 04 00 00       	push   $0x407
  801dd7:	ff 75 f4             	pushl  -0xc(%ebp)
  801dda:	6a 00                	push   $0x0
  801ddc:	e8 ac ef ff ff       	call   800d8d <sys_page_alloc>
  801de1:	89 c3                	mov    %eax,%ebx
  801de3:	83 c4 10             	add    $0x10,%esp
  801de6:	85 c0                	test   %eax,%eax
  801de8:	78 28                	js     801e12 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ded:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801df3:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801dff:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801e02:	83 ec 0c             	sub    $0xc,%esp
  801e05:	50                   	push   %eax
  801e06:	e8 55 f6 ff ff       	call   801460 <fd2num>
  801e0b:	89 c3                	mov    %eax,%ebx
  801e0d:	83 c4 10             	add    $0x10,%esp
  801e10:	eb 0c                	jmp    801e1e <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801e12:	83 ec 0c             	sub    $0xc,%esp
  801e15:	56                   	push   %esi
  801e16:	e8 08 02 00 00       	call   802023 <nsipc_close>
		return r;
  801e1b:	83 c4 10             	add    $0x10,%esp
}
  801e1e:	89 d8                	mov    %ebx,%eax
  801e20:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e23:	5b                   	pop    %ebx
  801e24:	5e                   	pop    %esi
  801e25:	5d                   	pop    %ebp
  801e26:	c3                   	ret    

00801e27 <accept>:
{
  801e27:	f3 0f 1e fb          	endbr32 
  801e2b:	55                   	push   %ebp
  801e2c:	89 e5                	mov    %esp,%ebp
  801e2e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e31:	8b 45 08             	mov    0x8(%ebp),%eax
  801e34:	e8 4a ff ff ff       	call   801d83 <fd2sockid>
  801e39:	85 c0                	test   %eax,%eax
  801e3b:	78 1b                	js     801e58 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e3d:	83 ec 04             	sub    $0x4,%esp
  801e40:	ff 75 10             	pushl  0x10(%ebp)
  801e43:	ff 75 0c             	pushl  0xc(%ebp)
  801e46:	50                   	push   %eax
  801e47:	e8 22 01 00 00       	call   801f6e <nsipc_accept>
  801e4c:	83 c4 10             	add    $0x10,%esp
  801e4f:	85 c0                	test   %eax,%eax
  801e51:	78 05                	js     801e58 <accept+0x31>
	return alloc_sockfd(r);
  801e53:	e8 5b ff ff ff       	call   801db3 <alloc_sockfd>
}
  801e58:	c9                   	leave  
  801e59:	c3                   	ret    

00801e5a <bind>:
{
  801e5a:	f3 0f 1e fb          	endbr32 
  801e5e:	55                   	push   %ebp
  801e5f:	89 e5                	mov    %esp,%ebp
  801e61:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e64:	8b 45 08             	mov    0x8(%ebp),%eax
  801e67:	e8 17 ff ff ff       	call   801d83 <fd2sockid>
  801e6c:	85 c0                	test   %eax,%eax
  801e6e:	78 12                	js     801e82 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801e70:	83 ec 04             	sub    $0x4,%esp
  801e73:	ff 75 10             	pushl  0x10(%ebp)
  801e76:	ff 75 0c             	pushl  0xc(%ebp)
  801e79:	50                   	push   %eax
  801e7a:	e8 45 01 00 00       	call   801fc4 <nsipc_bind>
  801e7f:	83 c4 10             	add    $0x10,%esp
}
  801e82:	c9                   	leave  
  801e83:	c3                   	ret    

00801e84 <shutdown>:
{
  801e84:	f3 0f 1e fb          	endbr32 
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
  801e8b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e91:	e8 ed fe ff ff       	call   801d83 <fd2sockid>
  801e96:	85 c0                	test   %eax,%eax
  801e98:	78 0f                	js     801ea9 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801e9a:	83 ec 08             	sub    $0x8,%esp
  801e9d:	ff 75 0c             	pushl  0xc(%ebp)
  801ea0:	50                   	push   %eax
  801ea1:	e8 57 01 00 00       	call   801ffd <nsipc_shutdown>
  801ea6:	83 c4 10             	add    $0x10,%esp
}
  801ea9:	c9                   	leave  
  801eaa:	c3                   	ret    

00801eab <connect>:
{
  801eab:	f3 0f 1e fb          	endbr32 
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
  801eb2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb8:	e8 c6 fe ff ff       	call   801d83 <fd2sockid>
  801ebd:	85 c0                	test   %eax,%eax
  801ebf:	78 12                	js     801ed3 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801ec1:	83 ec 04             	sub    $0x4,%esp
  801ec4:	ff 75 10             	pushl  0x10(%ebp)
  801ec7:	ff 75 0c             	pushl  0xc(%ebp)
  801eca:	50                   	push   %eax
  801ecb:	e8 71 01 00 00       	call   802041 <nsipc_connect>
  801ed0:	83 c4 10             	add    $0x10,%esp
}
  801ed3:	c9                   	leave  
  801ed4:	c3                   	ret    

00801ed5 <listen>:
{
  801ed5:	f3 0f 1e fb          	endbr32 
  801ed9:	55                   	push   %ebp
  801eda:	89 e5                	mov    %esp,%ebp
  801edc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801edf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee2:	e8 9c fe ff ff       	call   801d83 <fd2sockid>
  801ee7:	85 c0                	test   %eax,%eax
  801ee9:	78 0f                	js     801efa <listen+0x25>
	return nsipc_listen(r, backlog);
  801eeb:	83 ec 08             	sub    $0x8,%esp
  801eee:	ff 75 0c             	pushl  0xc(%ebp)
  801ef1:	50                   	push   %eax
  801ef2:	e8 83 01 00 00       	call   80207a <nsipc_listen>
  801ef7:	83 c4 10             	add    $0x10,%esp
}
  801efa:	c9                   	leave  
  801efb:	c3                   	ret    

00801efc <socket>:

int
socket(int domain, int type, int protocol)
{
  801efc:	f3 0f 1e fb          	endbr32 
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
  801f03:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801f06:	ff 75 10             	pushl  0x10(%ebp)
  801f09:	ff 75 0c             	pushl  0xc(%ebp)
  801f0c:	ff 75 08             	pushl  0x8(%ebp)
  801f0f:	e8 65 02 00 00       	call   802179 <nsipc_socket>
  801f14:	83 c4 10             	add    $0x10,%esp
  801f17:	85 c0                	test   %eax,%eax
  801f19:	78 05                	js     801f20 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801f1b:	e8 93 fe ff ff       	call   801db3 <alloc_sockfd>
}
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    

00801f22 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801f22:	55                   	push   %ebp
  801f23:	89 e5                	mov    %esp,%ebp
  801f25:	53                   	push   %ebx
  801f26:	83 ec 04             	sub    $0x4,%esp
  801f29:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801f2b:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801f32:	74 26                	je     801f5a <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801f34:	6a 07                	push   $0x7
  801f36:	68 00 70 80 00       	push   $0x807000
  801f3b:	53                   	push   %ebx
  801f3c:	ff 35 04 50 80 00    	pushl  0x805004
  801f42:	e8 84 f4 ff ff       	call   8013cb <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801f47:	83 c4 0c             	add    $0xc,%esp
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	e8 f1 f3 ff ff       	call   801346 <ipc_recv>
}
  801f55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f58:	c9                   	leave  
  801f59:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f5a:	83 ec 0c             	sub    $0xc,%esp
  801f5d:	6a 02                	push   $0x2
  801f5f:	e8 bf f4 ff ff       	call   801423 <ipc_find_env>
  801f64:	a3 04 50 80 00       	mov    %eax,0x805004
  801f69:	83 c4 10             	add    $0x10,%esp
  801f6c:	eb c6                	jmp    801f34 <nsipc+0x12>

00801f6e <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f6e:	f3 0f 1e fb          	endbr32 
  801f72:	55                   	push   %ebp
  801f73:	89 e5                	mov    %esp,%ebp
  801f75:	56                   	push   %esi
  801f76:	53                   	push   %ebx
  801f77:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801f82:	8b 06                	mov    (%esi),%eax
  801f84:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801f89:	b8 01 00 00 00       	mov    $0x1,%eax
  801f8e:	e8 8f ff ff ff       	call   801f22 <nsipc>
  801f93:	89 c3                	mov    %eax,%ebx
  801f95:	85 c0                	test   %eax,%eax
  801f97:	79 09                	jns    801fa2 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801f99:	89 d8                	mov    %ebx,%eax
  801f9b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f9e:	5b                   	pop    %ebx
  801f9f:	5e                   	pop    %esi
  801fa0:	5d                   	pop    %ebp
  801fa1:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801fa2:	83 ec 04             	sub    $0x4,%esp
  801fa5:	ff 35 10 70 80 00    	pushl  0x807010
  801fab:	68 00 70 80 00       	push   $0x807000
  801fb0:	ff 75 0c             	pushl  0xc(%ebp)
  801fb3:	e8 49 eb ff ff       	call   800b01 <memmove>
		*addrlen = ret->ret_addrlen;
  801fb8:	a1 10 70 80 00       	mov    0x807010,%eax
  801fbd:	89 06                	mov    %eax,(%esi)
  801fbf:	83 c4 10             	add    $0x10,%esp
	return r;
  801fc2:	eb d5                	jmp    801f99 <nsipc_accept+0x2b>

00801fc4 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801fc4:	f3 0f 1e fb          	endbr32 
  801fc8:	55                   	push   %ebp
  801fc9:	89 e5                	mov    %esp,%ebp
  801fcb:	53                   	push   %ebx
  801fcc:	83 ec 08             	sub    $0x8,%esp
  801fcf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd5:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801fda:	53                   	push   %ebx
  801fdb:	ff 75 0c             	pushl  0xc(%ebp)
  801fde:	68 04 70 80 00       	push   $0x807004
  801fe3:	e8 19 eb ff ff       	call   800b01 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801fe8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  801fee:	b8 02 00 00 00       	mov    $0x2,%eax
  801ff3:	e8 2a ff ff ff       	call   801f22 <nsipc>
}
  801ff8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ffb:	c9                   	leave  
  801ffc:	c3                   	ret    

00801ffd <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801ffd:	f3 0f 1e fb          	endbr32 
  802001:	55                   	push   %ebp
  802002:	89 e5                	mov    %esp,%ebp
  802004:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802007:	8b 45 08             	mov    0x8(%ebp),%eax
  80200a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80200f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802012:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802017:	b8 03 00 00 00       	mov    $0x3,%eax
  80201c:	e8 01 ff ff ff       	call   801f22 <nsipc>
}
  802021:	c9                   	leave  
  802022:	c3                   	ret    

00802023 <nsipc_close>:

int
nsipc_close(int s)
{
  802023:	f3 0f 1e fb          	endbr32 
  802027:	55                   	push   %ebp
  802028:	89 e5                	mov    %esp,%ebp
  80202a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80202d:	8b 45 08             	mov    0x8(%ebp),%eax
  802030:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802035:	b8 04 00 00 00       	mov    $0x4,%eax
  80203a:	e8 e3 fe ff ff       	call   801f22 <nsipc>
}
  80203f:	c9                   	leave  
  802040:	c3                   	ret    

00802041 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802041:	f3 0f 1e fb          	endbr32 
  802045:	55                   	push   %ebp
  802046:	89 e5                	mov    %esp,%ebp
  802048:	53                   	push   %ebx
  802049:	83 ec 08             	sub    $0x8,%esp
  80204c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80204f:	8b 45 08             	mov    0x8(%ebp),%eax
  802052:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802057:	53                   	push   %ebx
  802058:	ff 75 0c             	pushl  0xc(%ebp)
  80205b:	68 04 70 80 00       	push   $0x807004
  802060:	e8 9c ea ff ff       	call   800b01 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802065:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  80206b:	b8 05 00 00 00       	mov    $0x5,%eax
  802070:	e8 ad fe ff ff       	call   801f22 <nsipc>
}
  802075:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802078:	c9                   	leave  
  802079:	c3                   	ret    

0080207a <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80207a:	f3 0f 1e fb          	endbr32 
  80207e:	55                   	push   %ebp
  80207f:	89 e5                	mov    %esp,%ebp
  802081:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802084:	8b 45 08             	mov    0x8(%ebp),%eax
  802087:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80208c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80208f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802094:	b8 06 00 00 00       	mov    $0x6,%eax
  802099:	e8 84 fe ff ff       	call   801f22 <nsipc>
}
  80209e:	c9                   	leave  
  80209f:	c3                   	ret    

008020a0 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8020a0:	f3 0f 1e fb          	endbr32 
  8020a4:	55                   	push   %ebp
  8020a5:	89 e5                	mov    %esp,%ebp
  8020a7:	56                   	push   %esi
  8020a8:	53                   	push   %ebx
  8020a9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8020ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8020af:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8020b4:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8020ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8020bd:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8020c2:	b8 07 00 00 00       	mov    $0x7,%eax
  8020c7:	e8 56 fe ff ff       	call   801f22 <nsipc>
  8020cc:	89 c3                	mov    %eax,%ebx
  8020ce:	85 c0                	test   %eax,%eax
  8020d0:	78 26                	js     8020f8 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  8020d2:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  8020d8:	b8 3f 06 00 00       	mov    $0x63f,%eax
  8020dd:	0f 4e c6             	cmovle %esi,%eax
  8020e0:	39 c3                	cmp    %eax,%ebx
  8020e2:	7f 1d                	jg     802101 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8020e4:	83 ec 04             	sub    $0x4,%esp
  8020e7:	53                   	push   %ebx
  8020e8:	68 00 70 80 00       	push   $0x807000
  8020ed:	ff 75 0c             	pushl  0xc(%ebp)
  8020f0:	e8 0c ea ff ff       	call   800b01 <memmove>
  8020f5:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8020f8:	89 d8                	mov    %ebx,%eax
  8020fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020fd:	5b                   	pop    %ebx
  8020fe:	5e                   	pop    %esi
  8020ff:	5d                   	pop    %ebp
  802100:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802101:	68 6f 2f 80 00       	push   $0x802f6f
  802106:	68 37 2f 80 00       	push   $0x802f37
  80210b:	6a 62                	push   $0x62
  80210d:	68 84 2f 80 00       	push   $0x802f84
  802112:	e8 43 e1 ff ff       	call   80025a <_panic>

00802117 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802117:	f3 0f 1e fb          	endbr32 
  80211b:	55                   	push   %ebp
  80211c:	89 e5                	mov    %esp,%ebp
  80211e:	53                   	push   %ebx
  80211f:	83 ec 04             	sub    $0x4,%esp
  802122:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802125:	8b 45 08             	mov    0x8(%ebp),%eax
  802128:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80212d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802133:	7f 2e                	jg     802163 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802135:	83 ec 04             	sub    $0x4,%esp
  802138:	53                   	push   %ebx
  802139:	ff 75 0c             	pushl  0xc(%ebp)
  80213c:	68 0c 70 80 00       	push   $0x80700c
  802141:	e8 bb e9 ff ff       	call   800b01 <memmove>
	nsipcbuf.send.req_size = size;
  802146:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80214c:	8b 45 14             	mov    0x14(%ebp),%eax
  80214f:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802154:	b8 08 00 00 00       	mov    $0x8,%eax
  802159:	e8 c4 fd ff ff       	call   801f22 <nsipc>
}
  80215e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802161:	c9                   	leave  
  802162:	c3                   	ret    
	assert(size < 1600);
  802163:	68 90 2f 80 00       	push   $0x802f90
  802168:	68 37 2f 80 00       	push   $0x802f37
  80216d:	6a 6d                	push   $0x6d
  80216f:	68 84 2f 80 00       	push   $0x802f84
  802174:	e8 e1 e0 ff ff       	call   80025a <_panic>

00802179 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802179:	f3 0f 1e fb          	endbr32 
  80217d:	55                   	push   %ebp
  80217e:	89 e5                	mov    %esp,%ebp
  802180:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802183:	8b 45 08             	mov    0x8(%ebp),%eax
  802186:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80218b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80218e:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802193:	8b 45 10             	mov    0x10(%ebp),%eax
  802196:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80219b:	b8 09 00 00 00       	mov    $0x9,%eax
  8021a0:	e8 7d fd ff ff       	call   801f22 <nsipc>
}
  8021a5:	c9                   	leave  
  8021a6:	c3                   	ret    

008021a7 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8021a7:	f3 0f 1e fb          	endbr32 
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
  8021ae:	56                   	push   %esi
  8021af:	53                   	push   %ebx
  8021b0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8021b3:	83 ec 0c             	sub    $0xc,%esp
  8021b6:	ff 75 08             	pushl  0x8(%ebp)
  8021b9:	e8 b6 f2 ff ff       	call   801474 <fd2data>
  8021be:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8021c0:	83 c4 08             	add    $0x8,%esp
  8021c3:	68 9c 2f 80 00       	push   $0x802f9c
  8021c8:	53                   	push   %ebx
  8021c9:	e8 7d e7 ff ff       	call   80094b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8021ce:	8b 46 04             	mov    0x4(%esi),%eax
  8021d1:	2b 06                	sub    (%esi),%eax
  8021d3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8021d9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8021e0:	00 00 00 
	stat->st_dev = &devpipe;
  8021e3:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8021ea:	40 80 00 
	return 0;
}
  8021ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021f5:	5b                   	pop    %ebx
  8021f6:	5e                   	pop    %esi
  8021f7:	5d                   	pop    %ebp
  8021f8:	c3                   	ret    

008021f9 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8021f9:	f3 0f 1e fb          	endbr32 
  8021fd:	55                   	push   %ebp
  8021fe:	89 e5                	mov    %esp,%ebp
  802200:	53                   	push   %ebx
  802201:	83 ec 0c             	sub    $0xc,%esp
  802204:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802207:	53                   	push   %ebx
  802208:	6a 00                	push   $0x0
  80220a:	e8 0b ec ff ff       	call   800e1a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80220f:	89 1c 24             	mov    %ebx,(%esp)
  802212:	e8 5d f2 ff ff       	call   801474 <fd2data>
  802217:	83 c4 08             	add    $0x8,%esp
  80221a:	50                   	push   %eax
  80221b:	6a 00                	push   $0x0
  80221d:	e8 f8 eb ff ff       	call   800e1a <sys_page_unmap>
}
  802222:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802225:	c9                   	leave  
  802226:	c3                   	ret    

00802227 <_pipeisclosed>:
{
  802227:	55                   	push   %ebp
  802228:	89 e5                	mov    %esp,%ebp
  80222a:	57                   	push   %edi
  80222b:	56                   	push   %esi
  80222c:	53                   	push   %ebx
  80222d:	83 ec 1c             	sub    $0x1c,%esp
  802230:	89 c7                	mov    %eax,%edi
  802232:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802234:	a1 08 50 80 00       	mov    0x805008,%eax
  802239:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80223c:	83 ec 0c             	sub    $0xc,%esp
  80223f:	57                   	push   %edi
  802240:	e8 6a fa ff ff       	call   801caf <pageref>
  802245:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802248:	89 34 24             	mov    %esi,(%esp)
  80224b:	e8 5f fa ff ff       	call   801caf <pageref>
		nn = thisenv->env_runs;
  802250:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802256:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802259:	83 c4 10             	add    $0x10,%esp
  80225c:	39 cb                	cmp    %ecx,%ebx
  80225e:	74 1b                	je     80227b <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802260:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802263:	75 cf                	jne    802234 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802265:	8b 42 58             	mov    0x58(%edx),%eax
  802268:	6a 01                	push   $0x1
  80226a:	50                   	push   %eax
  80226b:	53                   	push   %ebx
  80226c:	68 a3 2f 80 00       	push   $0x802fa3
  802271:	e8 cb e0 ff ff       	call   800341 <cprintf>
  802276:	83 c4 10             	add    $0x10,%esp
  802279:	eb b9                	jmp    802234 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80227b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80227e:	0f 94 c0             	sete   %al
  802281:	0f b6 c0             	movzbl %al,%eax
}
  802284:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802287:	5b                   	pop    %ebx
  802288:	5e                   	pop    %esi
  802289:	5f                   	pop    %edi
  80228a:	5d                   	pop    %ebp
  80228b:	c3                   	ret    

0080228c <devpipe_write>:
{
  80228c:	f3 0f 1e fb          	endbr32 
  802290:	55                   	push   %ebp
  802291:	89 e5                	mov    %esp,%ebp
  802293:	57                   	push   %edi
  802294:	56                   	push   %esi
  802295:	53                   	push   %ebx
  802296:	83 ec 28             	sub    $0x28,%esp
  802299:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80229c:	56                   	push   %esi
  80229d:	e8 d2 f1 ff ff       	call   801474 <fd2data>
  8022a2:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8022a4:	83 c4 10             	add    $0x10,%esp
  8022a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8022ac:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8022af:	74 4f                	je     802300 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8022b1:	8b 43 04             	mov    0x4(%ebx),%eax
  8022b4:	8b 0b                	mov    (%ebx),%ecx
  8022b6:	8d 51 20             	lea    0x20(%ecx),%edx
  8022b9:	39 d0                	cmp    %edx,%eax
  8022bb:	72 14                	jb     8022d1 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8022bd:	89 da                	mov    %ebx,%edx
  8022bf:	89 f0                	mov    %esi,%eax
  8022c1:	e8 61 ff ff ff       	call   802227 <_pipeisclosed>
  8022c6:	85 c0                	test   %eax,%eax
  8022c8:	75 3b                	jne    802305 <devpipe_write+0x79>
			sys_yield();
  8022ca:	e8 9b ea ff ff       	call   800d6a <sys_yield>
  8022cf:	eb e0                	jmp    8022b1 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8022d1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022d4:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8022d8:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8022db:	89 c2                	mov    %eax,%edx
  8022dd:	c1 fa 1f             	sar    $0x1f,%edx
  8022e0:	89 d1                	mov    %edx,%ecx
  8022e2:	c1 e9 1b             	shr    $0x1b,%ecx
  8022e5:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8022e8:	83 e2 1f             	and    $0x1f,%edx
  8022eb:	29 ca                	sub    %ecx,%edx
  8022ed:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8022f1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8022f5:	83 c0 01             	add    $0x1,%eax
  8022f8:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8022fb:	83 c7 01             	add    $0x1,%edi
  8022fe:	eb ac                	jmp    8022ac <devpipe_write+0x20>
	return i;
  802300:	8b 45 10             	mov    0x10(%ebp),%eax
  802303:	eb 05                	jmp    80230a <devpipe_write+0x7e>
				return 0;
  802305:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80230a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80230d:	5b                   	pop    %ebx
  80230e:	5e                   	pop    %esi
  80230f:	5f                   	pop    %edi
  802310:	5d                   	pop    %ebp
  802311:	c3                   	ret    

00802312 <devpipe_read>:
{
  802312:	f3 0f 1e fb          	endbr32 
  802316:	55                   	push   %ebp
  802317:	89 e5                	mov    %esp,%ebp
  802319:	57                   	push   %edi
  80231a:	56                   	push   %esi
  80231b:	53                   	push   %ebx
  80231c:	83 ec 18             	sub    $0x18,%esp
  80231f:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802322:	57                   	push   %edi
  802323:	e8 4c f1 ff ff       	call   801474 <fd2data>
  802328:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80232a:	83 c4 10             	add    $0x10,%esp
  80232d:	be 00 00 00 00       	mov    $0x0,%esi
  802332:	3b 75 10             	cmp    0x10(%ebp),%esi
  802335:	75 14                	jne    80234b <devpipe_read+0x39>
	return i;
  802337:	8b 45 10             	mov    0x10(%ebp),%eax
  80233a:	eb 02                	jmp    80233e <devpipe_read+0x2c>
				return i;
  80233c:	89 f0                	mov    %esi,%eax
}
  80233e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802341:	5b                   	pop    %ebx
  802342:	5e                   	pop    %esi
  802343:	5f                   	pop    %edi
  802344:	5d                   	pop    %ebp
  802345:	c3                   	ret    
			sys_yield();
  802346:	e8 1f ea ff ff       	call   800d6a <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80234b:	8b 03                	mov    (%ebx),%eax
  80234d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802350:	75 18                	jne    80236a <devpipe_read+0x58>
			if (i > 0)
  802352:	85 f6                	test   %esi,%esi
  802354:	75 e6                	jne    80233c <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  802356:	89 da                	mov    %ebx,%edx
  802358:	89 f8                	mov    %edi,%eax
  80235a:	e8 c8 fe ff ff       	call   802227 <_pipeisclosed>
  80235f:	85 c0                	test   %eax,%eax
  802361:	74 e3                	je     802346 <devpipe_read+0x34>
				return 0;
  802363:	b8 00 00 00 00       	mov    $0x0,%eax
  802368:	eb d4                	jmp    80233e <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80236a:	99                   	cltd   
  80236b:	c1 ea 1b             	shr    $0x1b,%edx
  80236e:	01 d0                	add    %edx,%eax
  802370:	83 e0 1f             	and    $0x1f,%eax
  802373:	29 d0                	sub    %edx,%eax
  802375:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80237a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80237d:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802380:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802383:	83 c6 01             	add    $0x1,%esi
  802386:	eb aa                	jmp    802332 <devpipe_read+0x20>

00802388 <pipe>:
{
  802388:	f3 0f 1e fb          	endbr32 
  80238c:	55                   	push   %ebp
  80238d:	89 e5                	mov    %esp,%ebp
  80238f:	56                   	push   %esi
  802390:	53                   	push   %ebx
  802391:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802394:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802397:	50                   	push   %eax
  802398:	e8 f2 f0 ff ff       	call   80148f <fd_alloc>
  80239d:	89 c3                	mov    %eax,%ebx
  80239f:	83 c4 10             	add    $0x10,%esp
  8023a2:	85 c0                	test   %eax,%eax
  8023a4:	0f 88 23 01 00 00    	js     8024cd <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023aa:	83 ec 04             	sub    $0x4,%esp
  8023ad:	68 07 04 00 00       	push   $0x407
  8023b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8023b5:	6a 00                	push   $0x0
  8023b7:	e8 d1 e9 ff ff       	call   800d8d <sys_page_alloc>
  8023bc:	89 c3                	mov    %eax,%ebx
  8023be:	83 c4 10             	add    $0x10,%esp
  8023c1:	85 c0                	test   %eax,%eax
  8023c3:	0f 88 04 01 00 00    	js     8024cd <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  8023c9:	83 ec 0c             	sub    $0xc,%esp
  8023cc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8023cf:	50                   	push   %eax
  8023d0:	e8 ba f0 ff ff       	call   80148f <fd_alloc>
  8023d5:	89 c3                	mov    %eax,%ebx
  8023d7:	83 c4 10             	add    $0x10,%esp
  8023da:	85 c0                	test   %eax,%eax
  8023dc:	0f 88 db 00 00 00    	js     8024bd <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023e2:	83 ec 04             	sub    $0x4,%esp
  8023e5:	68 07 04 00 00       	push   $0x407
  8023ea:	ff 75 f0             	pushl  -0x10(%ebp)
  8023ed:	6a 00                	push   $0x0
  8023ef:	e8 99 e9 ff ff       	call   800d8d <sys_page_alloc>
  8023f4:	89 c3                	mov    %eax,%ebx
  8023f6:	83 c4 10             	add    $0x10,%esp
  8023f9:	85 c0                	test   %eax,%eax
  8023fb:	0f 88 bc 00 00 00    	js     8024bd <pipe+0x135>
	va = fd2data(fd0);
  802401:	83 ec 0c             	sub    $0xc,%esp
  802404:	ff 75 f4             	pushl  -0xc(%ebp)
  802407:	e8 68 f0 ff ff       	call   801474 <fd2data>
  80240c:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80240e:	83 c4 0c             	add    $0xc,%esp
  802411:	68 07 04 00 00       	push   $0x407
  802416:	50                   	push   %eax
  802417:	6a 00                	push   $0x0
  802419:	e8 6f e9 ff ff       	call   800d8d <sys_page_alloc>
  80241e:	89 c3                	mov    %eax,%ebx
  802420:	83 c4 10             	add    $0x10,%esp
  802423:	85 c0                	test   %eax,%eax
  802425:	0f 88 82 00 00 00    	js     8024ad <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80242b:	83 ec 0c             	sub    $0xc,%esp
  80242e:	ff 75 f0             	pushl  -0x10(%ebp)
  802431:	e8 3e f0 ff ff       	call   801474 <fd2data>
  802436:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80243d:	50                   	push   %eax
  80243e:	6a 00                	push   $0x0
  802440:	56                   	push   %esi
  802441:	6a 00                	push   $0x0
  802443:	e8 8c e9 ff ff       	call   800dd4 <sys_page_map>
  802448:	89 c3                	mov    %eax,%ebx
  80244a:	83 c4 20             	add    $0x20,%esp
  80244d:	85 c0                	test   %eax,%eax
  80244f:	78 4e                	js     80249f <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  802451:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802456:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802459:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80245b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80245e:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802465:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802468:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80246a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802474:	83 ec 0c             	sub    $0xc,%esp
  802477:	ff 75 f4             	pushl  -0xc(%ebp)
  80247a:	e8 e1 ef ff ff       	call   801460 <fd2num>
  80247f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802482:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802484:	83 c4 04             	add    $0x4,%esp
  802487:	ff 75 f0             	pushl  -0x10(%ebp)
  80248a:	e8 d1 ef ff ff       	call   801460 <fd2num>
  80248f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802492:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802495:	83 c4 10             	add    $0x10,%esp
  802498:	bb 00 00 00 00       	mov    $0x0,%ebx
  80249d:	eb 2e                	jmp    8024cd <pipe+0x145>
	sys_page_unmap(0, va);
  80249f:	83 ec 08             	sub    $0x8,%esp
  8024a2:	56                   	push   %esi
  8024a3:	6a 00                	push   $0x0
  8024a5:	e8 70 e9 ff ff       	call   800e1a <sys_page_unmap>
  8024aa:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8024ad:	83 ec 08             	sub    $0x8,%esp
  8024b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8024b3:	6a 00                	push   $0x0
  8024b5:	e8 60 e9 ff ff       	call   800e1a <sys_page_unmap>
  8024ba:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8024bd:	83 ec 08             	sub    $0x8,%esp
  8024c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8024c3:	6a 00                	push   $0x0
  8024c5:	e8 50 e9 ff ff       	call   800e1a <sys_page_unmap>
  8024ca:	83 c4 10             	add    $0x10,%esp
}
  8024cd:	89 d8                	mov    %ebx,%eax
  8024cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024d2:	5b                   	pop    %ebx
  8024d3:	5e                   	pop    %esi
  8024d4:	5d                   	pop    %ebp
  8024d5:	c3                   	ret    

008024d6 <pipeisclosed>:
{
  8024d6:	f3 0f 1e fb          	endbr32 
  8024da:	55                   	push   %ebp
  8024db:	89 e5                	mov    %esp,%ebp
  8024dd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024e3:	50                   	push   %eax
  8024e4:	ff 75 08             	pushl  0x8(%ebp)
  8024e7:	e8 f9 ef ff ff       	call   8014e5 <fd_lookup>
  8024ec:	83 c4 10             	add    $0x10,%esp
  8024ef:	85 c0                	test   %eax,%eax
  8024f1:	78 18                	js     80250b <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  8024f3:	83 ec 0c             	sub    $0xc,%esp
  8024f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8024f9:	e8 76 ef ff ff       	call   801474 <fd2data>
  8024fe:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802503:	e8 1f fd ff ff       	call   802227 <_pipeisclosed>
  802508:	83 c4 10             	add    $0x10,%esp
}
  80250b:	c9                   	leave  
  80250c:	c3                   	ret    

0080250d <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80250d:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  802511:	b8 00 00 00 00       	mov    $0x0,%eax
  802516:	c3                   	ret    

00802517 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802517:	f3 0f 1e fb          	endbr32 
  80251b:	55                   	push   %ebp
  80251c:	89 e5                	mov    %esp,%ebp
  80251e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802521:	68 bb 2f 80 00       	push   $0x802fbb
  802526:	ff 75 0c             	pushl  0xc(%ebp)
  802529:	e8 1d e4 ff ff       	call   80094b <strcpy>
	return 0;
}
  80252e:	b8 00 00 00 00       	mov    $0x0,%eax
  802533:	c9                   	leave  
  802534:	c3                   	ret    

00802535 <devcons_write>:
{
  802535:	f3 0f 1e fb          	endbr32 
  802539:	55                   	push   %ebp
  80253a:	89 e5                	mov    %esp,%ebp
  80253c:	57                   	push   %edi
  80253d:	56                   	push   %esi
  80253e:	53                   	push   %ebx
  80253f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802545:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80254a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802550:	3b 75 10             	cmp    0x10(%ebp),%esi
  802553:	73 31                	jae    802586 <devcons_write+0x51>
		m = n - tot;
  802555:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802558:	29 f3                	sub    %esi,%ebx
  80255a:	83 fb 7f             	cmp    $0x7f,%ebx
  80255d:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802562:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802565:	83 ec 04             	sub    $0x4,%esp
  802568:	53                   	push   %ebx
  802569:	89 f0                	mov    %esi,%eax
  80256b:	03 45 0c             	add    0xc(%ebp),%eax
  80256e:	50                   	push   %eax
  80256f:	57                   	push   %edi
  802570:	e8 8c e5 ff ff       	call   800b01 <memmove>
		sys_cputs(buf, m);
  802575:	83 c4 08             	add    $0x8,%esp
  802578:	53                   	push   %ebx
  802579:	57                   	push   %edi
  80257a:	e8 3e e7 ff ff       	call   800cbd <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80257f:	01 de                	add    %ebx,%esi
  802581:	83 c4 10             	add    $0x10,%esp
  802584:	eb ca                	jmp    802550 <devcons_write+0x1b>
}
  802586:	89 f0                	mov    %esi,%eax
  802588:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80258b:	5b                   	pop    %ebx
  80258c:	5e                   	pop    %esi
  80258d:	5f                   	pop    %edi
  80258e:	5d                   	pop    %ebp
  80258f:	c3                   	ret    

00802590 <devcons_read>:
{
  802590:	f3 0f 1e fb          	endbr32 
  802594:	55                   	push   %ebp
  802595:	89 e5                	mov    %esp,%ebp
  802597:	83 ec 08             	sub    $0x8,%esp
  80259a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80259f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025a3:	74 21                	je     8025c6 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8025a5:	e8 35 e7 ff ff       	call   800cdf <sys_cgetc>
  8025aa:	85 c0                	test   %eax,%eax
  8025ac:	75 07                	jne    8025b5 <devcons_read+0x25>
		sys_yield();
  8025ae:	e8 b7 e7 ff ff       	call   800d6a <sys_yield>
  8025b3:	eb f0                	jmp    8025a5 <devcons_read+0x15>
	if (c < 0)
  8025b5:	78 0f                	js     8025c6 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8025b7:	83 f8 04             	cmp    $0x4,%eax
  8025ba:	74 0c                	je     8025c8 <devcons_read+0x38>
	*(char*)vbuf = c;
  8025bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025bf:	88 02                	mov    %al,(%edx)
	return 1;
  8025c1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8025c6:	c9                   	leave  
  8025c7:	c3                   	ret    
		return 0;
  8025c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025cd:	eb f7                	jmp    8025c6 <devcons_read+0x36>

008025cf <cputchar>:
{
  8025cf:	f3 0f 1e fb          	endbr32 
  8025d3:	55                   	push   %ebp
  8025d4:	89 e5                	mov    %esp,%ebp
  8025d6:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8025d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025dc:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8025df:	6a 01                	push   $0x1
  8025e1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025e4:	50                   	push   %eax
  8025e5:	e8 d3 e6 ff ff       	call   800cbd <sys_cputs>
}
  8025ea:	83 c4 10             	add    $0x10,%esp
  8025ed:	c9                   	leave  
  8025ee:	c3                   	ret    

008025ef <getchar>:
{
  8025ef:	f3 0f 1e fb          	endbr32 
  8025f3:	55                   	push   %ebp
  8025f4:	89 e5                	mov    %esp,%ebp
  8025f6:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8025f9:	6a 01                	push   $0x1
  8025fb:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025fe:	50                   	push   %eax
  8025ff:	6a 00                	push   $0x0
  802601:	e8 67 f1 ff ff       	call   80176d <read>
	if (r < 0)
  802606:	83 c4 10             	add    $0x10,%esp
  802609:	85 c0                	test   %eax,%eax
  80260b:	78 06                	js     802613 <getchar+0x24>
	if (r < 1)
  80260d:	74 06                	je     802615 <getchar+0x26>
	return c;
  80260f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802613:	c9                   	leave  
  802614:	c3                   	ret    
		return -E_EOF;
  802615:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80261a:	eb f7                	jmp    802613 <getchar+0x24>

0080261c <iscons>:
{
  80261c:	f3 0f 1e fb          	endbr32 
  802620:	55                   	push   %ebp
  802621:	89 e5                	mov    %esp,%ebp
  802623:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802626:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802629:	50                   	push   %eax
  80262a:	ff 75 08             	pushl  0x8(%ebp)
  80262d:	e8 b3 ee ff ff       	call   8014e5 <fd_lookup>
  802632:	83 c4 10             	add    $0x10,%esp
  802635:	85 c0                	test   %eax,%eax
  802637:	78 11                	js     80264a <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  802639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263c:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802642:	39 10                	cmp    %edx,(%eax)
  802644:	0f 94 c0             	sete   %al
  802647:	0f b6 c0             	movzbl %al,%eax
}
  80264a:	c9                   	leave  
  80264b:	c3                   	ret    

0080264c <opencons>:
{
  80264c:	f3 0f 1e fb          	endbr32 
  802650:	55                   	push   %ebp
  802651:	89 e5                	mov    %esp,%ebp
  802653:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802656:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802659:	50                   	push   %eax
  80265a:	e8 30 ee ff ff       	call   80148f <fd_alloc>
  80265f:	83 c4 10             	add    $0x10,%esp
  802662:	85 c0                	test   %eax,%eax
  802664:	78 3a                	js     8026a0 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802666:	83 ec 04             	sub    $0x4,%esp
  802669:	68 07 04 00 00       	push   $0x407
  80266e:	ff 75 f4             	pushl  -0xc(%ebp)
  802671:	6a 00                	push   $0x0
  802673:	e8 15 e7 ff ff       	call   800d8d <sys_page_alloc>
  802678:	83 c4 10             	add    $0x10,%esp
  80267b:	85 c0                	test   %eax,%eax
  80267d:	78 21                	js     8026a0 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80267f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802682:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802688:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80268a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802694:	83 ec 0c             	sub    $0xc,%esp
  802697:	50                   	push   %eax
  802698:	e8 c3 ed ff ff       	call   801460 <fd2num>
  80269d:	83 c4 10             	add    $0x10,%esp
}
  8026a0:	c9                   	leave  
  8026a1:	c3                   	ret    

008026a2 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8026a2:	f3 0f 1e fb          	endbr32 
  8026a6:	55                   	push   %ebp
  8026a7:	89 e5                	mov    %esp,%ebp
  8026a9:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8026ac:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8026b3:	74 0a                	je     8026bf <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8026b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b8:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8026bd:	c9                   	leave  
  8026be:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  8026bf:	83 ec 04             	sub    $0x4,%esp
  8026c2:	6a 07                	push   $0x7
  8026c4:	68 00 f0 bf ee       	push   $0xeebff000
  8026c9:	6a 00                	push   $0x0
  8026cb:	e8 bd e6 ff ff       	call   800d8d <sys_page_alloc>
  8026d0:	83 c4 10             	add    $0x10,%esp
  8026d3:	85 c0                	test   %eax,%eax
  8026d5:	78 2a                	js     802701 <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  8026d7:	83 ec 08             	sub    $0x8,%esp
  8026da:	68 15 27 80 00       	push   $0x802715
  8026df:	6a 00                	push   $0x0
  8026e1:	e8 06 e8 ff ff       	call   800eec <sys_env_set_pgfault_upcall>
  8026e6:	83 c4 10             	add    $0x10,%esp
  8026e9:	85 c0                	test   %eax,%eax
  8026eb:	79 c8                	jns    8026b5 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  8026ed:	83 ec 04             	sub    $0x4,%esp
  8026f0:	68 f4 2f 80 00       	push   $0x802ff4
  8026f5:	6a 25                	push   $0x25
  8026f7:	68 2c 30 80 00       	push   $0x80302c
  8026fc:	e8 59 db ff ff       	call   80025a <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  802701:	83 ec 04             	sub    $0x4,%esp
  802704:	68 c8 2f 80 00       	push   $0x802fc8
  802709:	6a 22                	push   $0x22
  80270b:	68 2c 30 80 00       	push   $0x80302c
  802710:	e8 45 db ff ff       	call   80025a <_panic>

00802715 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802715:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802716:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  80271b:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80271d:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  802720:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  802724:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  802728:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80272b:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  80272d:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  802731:	83 c4 08             	add    $0x8,%esp
	popal
  802734:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  802735:	83 c4 04             	add    $0x4,%esp
	popfl
  802738:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  802739:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  80273a:	c3                   	ret    
  80273b:	66 90                	xchg   %ax,%ax
  80273d:	66 90                	xchg   %ax,%ax
  80273f:	90                   	nop

00802740 <__udivdi3>:
  802740:	f3 0f 1e fb          	endbr32 
  802744:	55                   	push   %ebp
  802745:	57                   	push   %edi
  802746:	56                   	push   %esi
  802747:	53                   	push   %ebx
  802748:	83 ec 1c             	sub    $0x1c,%esp
  80274b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80274f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802753:	8b 74 24 34          	mov    0x34(%esp),%esi
  802757:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80275b:	85 d2                	test   %edx,%edx
  80275d:	75 19                	jne    802778 <__udivdi3+0x38>
  80275f:	39 f3                	cmp    %esi,%ebx
  802761:	76 4d                	jbe    8027b0 <__udivdi3+0x70>
  802763:	31 ff                	xor    %edi,%edi
  802765:	89 e8                	mov    %ebp,%eax
  802767:	89 f2                	mov    %esi,%edx
  802769:	f7 f3                	div    %ebx
  80276b:	89 fa                	mov    %edi,%edx
  80276d:	83 c4 1c             	add    $0x1c,%esp
  802770:	5b                   	pop    %ebx
  802771:	5e                   	pop    %esi
  802772:	5f                   	pop    %edi
  802773:	5d                   	pop    %ebp
  802774:	c3                   	ret    
  802775:	8d 76 00             	lea    0x0(%esi),%esi
  802778:	39 f2                	cmp    %esi,%edx
  80277a:	76 14                	jbe    802790 <__udivdi3+0x50>
  80277c:	31 ff                	xor    %edi,%edi
  80277e:	31 c0                	xor    %eax,%eax
  802780:	89 fa                	mov    %edi,%edx
  802782:	83 c4 1c             	add    $0x1c,%esp
  802785:	5b                   	pop    %ebx
  802786:	5e                   	pop    %esi
  802787:	5f                   	pop    %edi
  802788:	5d                   	pop    %ebp
  802789:	c3                   	ret    
  80278a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802790:	0f bd fa             	bsr    %edx,%edi
  802793:	83 f7 1f             	xor    $0x1f,%edi
  802796:	75 48                	jne    8027e0 <__udivdi3+0xa0>
  802798:	39 f2                	cmp    %esi,%edx
  80279a:	72 06                	jb     8027a2 <__udivdi3+0x62>
  80279c:	31 c0                	xor    %eax,%eax
  80279e:	39 eb                	cmp    %ebp,%ebx
  8027a0:	77 de                	ja     802780 <__udivdi3+0x40>
  8027a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8027a7:	eb d7                	jmp    802780 <__udivdi3+0x40>
  8027a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027b0:	89 d9                	mov    %ebx,%ecx
  8027b2:	85 db                	test   %ebx,%ebx
  8027b4:	75 0b                	jne    8027c1 <__udivdi3+0x81>
  8027b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8027bb:	31 d2                	xor    %edx,%edx
  8027bd:	f7 f3                	div    %ebx
  8027bf:	89 c1                	mov    %eax,%ecx
  8027c1:	31 d2                	xor    %edx,%edx
  8027c3:	89 f0                	mov    %esi,%eax
  8027c5:	f7 f1                	div    %ecx
  8027c7:	89 c6                	mov    %eax,%esi
  8027c9:	89 e8                	mov    %ebp,%eax
  8027cb:	89 f7                	mov    %esi,%edi
  8027cd:	f7 f1                	div    %ecx
  8027cf:	89 fa                	mov    %edi,%edx
  8027d1:	83 c4 1c             	add    $0x1c,%esp
  8027d4:	5b                   	pop    %ebx
  8027d5:	5e                   	pop    %esi
  8027d6:	5f                   	pop    %edi
  8027d7:	5d                   	pop    %ebp
  8027d8:	c3                   	ret    
  8027d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027e0:	89 f9                	mov    %edi,%ecx
  8027e2:	b8 20 00 00 00       	mov    $0x20,%eax
  8027e7:	29 f8                	sub    %edi,%eax
  8027e9:	d3 e2                	shl    %cl,%edx
  8027eb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8027ef:	89 c1                	mov    %eax,%ecx
  8027f1:	89 da                	mov    %ebx,%edx
  8027f3:	d3 ea                	shr    %cl,%edx
  8027f5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8027f9:	09 d1                	or     %edx,%ecx
  8027fb:	89 f2                	mov    %esi,%edx
  8027fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802801:	89 f9                	mov    %edi,%ecx
  802803:	d3 e3                	shl    %cl,%ebx
  802805:	89 c1                	mov    %eax,%ecx
  802807:	d3 ea                	shr    %cl,%edx
  802809:	89 f9                	mov    %edi,%ecx
  80280b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80280f:	89 eb                	mov    %ebp,%ebx
  802811:	d3 e6                	shl    %cl,%esi
  802813:	89 c1                	mov    %eax,%ecx
  802815:	d3 eb                	shr    %cl,%ebx
  802817:	09 de                	or     %ebx,%esi
  802819:	89 f0                	mov    %esi,%eax
  80281b:	f7 74 24 08          	divl   0x8(%esp)
  80281f:	89 d6                	mov    %edx,%esi
  802821:	89 c3                	mov    %eax,%ebx
  802823:	f7 64 24 0c          	mull   0xc(%esp)
  802827:	39 d6                	cmp    %edx,%esi
  802829:	72 15                	jb     802840 <__udivdi3+0x100>
  80282b:	89 f9                	mov    %edi,%ecx
  80282d:	d3 e5                	shl    %cl,%ebp
  80282f:	39 c5                	cmp    %eax,%ebp
  802831:	73 04                	jae    802837 <__udivdi3+0xf7>
  802833:	39 d6                	cmp    %edx,%esi
  802835:	74 09                	je     802840 <__udivdi3+0x100>
  802837:	89 d8                	mov    %ebx,%eax
  802839:	31 ff                	xor    %edi,%edi
  80283b:	e9 40 ff ff ff       	jmp    802780 <__udivdi3+0x40>
  802840:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802843:	31 ff                	xor    %edi,%edi
  802845:	e9 36 ff ff ff       	jmp    802780 <__udivdi3+0x40>
  80284a:	66 90                	xchg   %ax,%ax
  80284c:	66 90                	xchg   %ax,%ax
  80284e:	66 90                	xchg   %ax,%ax

00802850 <__umoddi3>:
  802850:	f3 0f 1e fb          	endbr32 
  802854:	55                   	push   %ebp
  802855:	57                   	push   %edi
  802856:	56                   	push   %esi
  802857:	53                   	push   %ebx
  802858:	83 ec 1c             	sub    $0x1c,%esp
  80285b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80285f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802863:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802867:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80286b:	85 c0                	test   %eax,%eax
  80286d:	75 19                	jne    802888 <__umoddi3+0x38>
  80286f:	39 df                	cmp    %ebx,%edi
  802871:	76 5d                	jbe    8028d0 <__umoddi3+0x80>
  802873:	89 f0                	mov    %esi,%eax
  802875:	89 da                	mov    %ebx,%edx
  802877:	f7 f7                	div    %edi
  802879:	89 d0                	mov    %edx,%eax
  80287b:	31 d2                	xor    %edx,%edx
  80287d:	83 c4 1c             	add    $0x1c,%esp
  802880:	5b                   	pop    %ebx
  802881:	5e                   	pop    %esi
  802882:	5f                   	pop    %edi
  802883:	5d                   	pop    %ebp
  802884:	c3                   	ret    
  802885:	8d 76 00             	lea    0x0(%esi),%esi
  802888:	89 f2                	mov    %esi,%edx
  80288a:	39 d8                	cmp    %ebx,%eax
  80288c:	76 12                	jbe    8028a0 <__umoddi3+0x50>
  80288e:	89 f0                	mov    %esi,%eax
  802890:	89 da                	mov    %ebx,%edx
  802892:	83 c4 1c             	add    $0x1c,%esp
  802895:	5b                   	pop    %ebx
  802896:	5e                   	pop    %esi
  802897:	5f                   	pop    %edi
  802898:	5d                   	pop    %ebp
  802899:	c3                   	ret    
  80289a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8028a0:	0f bd e8             	bsr    %eax,%ebp
  8028a3:	83 f5 1f             	xor    $0x1f,%ebp
  8028a6:	75 50                	jne    8028f8 <__umoddi3+0xa8>
  8028a8:	39 d8                	cmp    %ebx,%eax
  8028aa:	0f 82 e0 00 00 00    	jb     802990 <__umoddi3+0x140>
  8028b0:	89 d9                	mov    %ebx,%ecx
  8028b2:	39 f7                	cmp    %esi,%edi
  8028b4:	0f 86 d6 00 00 00    	jbe    802990 <__umoddi3+0x140>
  8028ba:	89 d0                	mov    %edx,%eax
  8028bc:	89 ca                	mov    %ecx,%edx
  8028be:	83 c4 1c             	add    $0x1c,%esp
  8028c1:	5b                   	pop    %ebx
  8028c2:	5e                   	pop    %esi
  8028c3:	5f                   	pop    %edi
  8028c4:	5d                   	pop    %ebp
  8028c5:	c3                   	ret    
  8028c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028cd:	8d 76 00             	lea    0x0(%esi),%esi
  8028d0:	89 fd                	mov    %edi,%ebp
  8028d2:	85 ff                	test   %edi,%edi
  8028d4:	75 0b                	jne    8028e1 <__umoddi3+0x91>
  8028d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8028db:	31 d2                	xor    %edx,%edx
  8028dd:	f7 f7                	div    %edi
  8028df:	89 c5                	mov    %eax,%ebp
  8028e1:	89 d8                	mov    %ebx,%eax
  8028e3:	31 d2                	xor    %edx,%edx
  8028e5:	f7 f5                	div    %ebp
  8028e7:	89 f0                	mov    %esi,%eax
  8028e9:	f7 f5                	div    %ebp
  8028eb:	89 d0                	mov    %edx,%eax
  8028ed:	31 d2                	xor    %edx,%edx
  8028ef:	eb 8c                	jmp    80287d <__umoddi3+0x2d>
  8028f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028f8:	89 e9                	mov    %ebp,%ecx
  8028fa:	ba 20 00 00 00       	mov    $0x20,%edx
  8028ff:	29 ea                	sub    %ebp,%edx
  802901:	d3 e0                	shl    %cl,%eax
  802903:	89 44 24 08          	mov    %eax,0x8(%esp)
  802907:	89 d1                	mov    %edx,%ecx
  802909:	89 f8                	mov    %edi,%eax
  80290b:	d3 e8                	shr    %cl,%eax
  80290d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802911:	89 54 24 04          	mov    %edx,0x4(%esp)
  802915:	8b 54 24 04          	mov    0x4(%esp),%edx
  802919:	09 c1                	or     %eax,%ecx
  80291b:	89 d8                	mov    %ebx,%eax
  80291d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802921:	89 e9                	mov    %ebp,%ecx
  802923:	d3 e7                	shl    %cl,%edi
  802925:	89 d1                	mov    %edx,%ecx
  802927:	d3 e8                	shr    %cl,%eax
  802929:	89 e9                	mov    %ebp,%ecx
  80292b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80292f:	d3 e3                	shl    %cl,%ebx
  802931:	89 c7                	mov    %eax,%edi
  802933:	89 d1                	mov    %edx,%ecx
  802935:	89 f0                	mov    %esi,%eax
  802937:	d3 e8                	shr    %cl,%eax
  802939:	89 e9                	mov    %ebp,%ecx
  80293b:	89 fa                	mov    %edi,%edx
  80293d:	d3 e6                	shl    %cl,%esi
  80293f:	09 d8                	or     %ebx,%eax
  802941:	f7 74 24 08          	divl   0x8(%esp)
  802945:	89 d1                	mov    %edx,%ecx
  802947:	89 f3                	mov    %esi,%ebx
  802949:	f7 64 24 0c          	mull   0xc(%esp)
  80294d:	89 c6                	mov    %eax,%esi
  80294f:	89 d7                	mov    %edx,%edi
  802951:	39 d1                	cmp    %edx,%ecx
  802953:	72 06                	jb     80295b <__umoddi3+0x10b>
  802955:	75 10                	jne    802967 <__umoddi3+0x117>
  802957:	39 c3                	cmp    %eax,%ebx
  802959:	73 0c                	jae    802967 <__umoddi3+0x117>
  80295b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80295f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802963:	89 d7                	mov    %edx,%edi
  802965:	89 c6                	mov    %eax,%esi
  802967:	89 ca                	mov    %ecx,%edx
  802969:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80296e:	29 f3                	sub    %esi,%ebx
  802970:	19 fa                	sbb    %edi,%edx
  802972:	89 d0                	mov    %edx,%eax
  802974:	d3 e0                	shl    %cl,%eax
  802976:	89 e9                	mov    %ebp,%ecx
  802978:	d3 eb                	shr    %cl,%ebx
  80297a:	d3 ea                	shr    %cl,%edx
  80297c:	09 d8                	or     %ebx,%eax
  80297e:	83 c4 1c             	add    $0x1c,%esp
  802981:	5b                   	pop    %ebx
  802982:	5e                   	pop    %esi
  802983:	5f                   	pop    %edi
  802984:	5d                   	pop    %ebp
  802985:	c3                   	ret    
  802986:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80298d:	8d 76 00             	lea    0x0(%esi),%esi
  802990:	29 fe                	sub    %edi,%esi
  802992:	19 c3                	sbb    %eax,%ebx
  802994:	89 f2                	mov    %esi,%edx
  802996:	89 d9                	mov    %ebx,%ecx
  802998:	e9 1d ff ff ff       	jmp    8028ba <__umoddi3+0x6a>
