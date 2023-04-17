
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
  80003f:	68 40 24 80 00       	push   $0x802440
  800044:	e8 f8 02 00 00       	call   800341 <cprintf>
	if ((r = pipe(p)) < 0)
  800049:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80004c:	89 04 24             	mov    %eax,(%esp)
  80004f:	e8 c8 1d 00 00       	call   801e1c <pipe>
  800054:	83 c4 10             	add    $0x10,%esp
  800057:	85 c0                	test   %eax,%eax
  800059:	78 59                	js     8000b4 <umain+0x81>
		panic("pipe: %e", r);
	max = 200;
	if ((r = fork()) < 0)
  80005b:	e8 1e 10 00 00       	call   80107e <fork>
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
  80006c:	68 91 24 80 00       	push   $0x802491
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
  80008c:	68 9c 24 80 00       	push   $0x80249c
  800091:	e8 ab 02 00 00       	call   800341 <cprintf>
	dup(p[0], 10);
  800096:	83 c4 08             	add    $0x8,%esp
  800099:	6a 0a                	push   $0xa
  80009b:	ff 75 f0             	pushl  -0x10(%ebp)
  80009e:	e8 26 15 00 00       	call   8015c9 <dup>
	while (kid->env_status == ENV_RUNNABLE)
  8000a3:	83 c4 10             	add    $0x10,%esp
  8000a6:	6b de 7c             	imul   $0x7c,%esi,%ebx
  8000a9:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000af:	e9 92 00 00 00       	jmp    800146 <umain+0x113>
		panic("pipe: %e", r);
  8000b4:	50                   	push   %eax
  8000b5:	68 59 24 80 00       	push   $0x802459
  8000ba:	6a 0d                	push   $0xd
  8000bc:	68 62 24 80 00       	push   $0x802462
  8000c1:	e8 94 01 00 00       	call   80025a <_panic>
		panic("fork: %e", r);
  8000c6:	50                   	push   %eax
  8000c7:	68 c5 28 80 00       	push   $0x8028c5
  8000cc:	6a 10                	push   $0x10
  8000ce:	68 62 24 80 00       	push   $0x802462
  8000d3:	e8 82 01 00 00       	call   80025a <_panic>
		close(p[1]);
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	ff 75 f4             	pushl  -0xc(%ebp)
  8000de:	e8 8c 14 00 00       	call   80156f <close>
  8000e3:	83 c4 10             	add    $0x10,%esp
  8000e6:	bb c8 00 00 00       	mov    $0xc8,%ebx
  8000eb:	eb 1f                	jmp    80010c <umain+0xd9>
				cprintf("RACE: pipe appears closed\n");
  8000ed:	83 ec 0c             	sub    $0xc,%esp
  8000f0:	68 76 24 80 00       	push   $0x802476
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
  800112:	e8 53 1e 00 00       	call   801f6a <pipeisclosed>
  800117:	83 c4 10             	add    $0x10,%esp
  80011a:	85 c0                	test   %eax,%eax
  80011c:	74 e4                	je     800102 <umain+0xcf>
  80011e:	eb cd                	jmp    8000ed <umain+0xba>
		ipc_recv(0,0,0);
  800120:	83 ec 04             	sub    $0x4,%esp
  800123:	6a 00                	push   $0x0
  800125:	6a 00                	push   $0x0
  800127:	6a 00                	push   $0x0
  800129:	e8 69 11 00 00       	call   801297 <ipc_recv>
  80012e:	83 c4 10             	add    $0x10,%esp
  800131:	e9 32 ff ff ff       	jmp    800068 <umain+0x35>
		dup(p[0], 10);
  800136:	83 ec 08             	sub    $0x8,%esp
  800139:	6a 0a                	push   $0xa
  80013b:	ff 75 f0             	pushl  -0x10(%ebp)
  80013e:	e8 86 14 00 00       	call   8015c9 <dup>
  800143:	83 c4 10             	add    $0x10,%esp
	while (kid->env_status == ENV_RUNNABLE)
  800146:	8b 43 54             	mov    0x54(%ebx),%eax
  800149:	83 f8 02             	cmp    $0x2,%eax
  80014c:	74 e8                	je     800136 <umain+0x103>

	cprintf("child done with loop\n");
  80014e:	83 ec 0c             	sub    $0xc,%esp
  800151:	68 a7 24 80 00       	push   $0x8024a7
  800156:	e8 e6 01 00 00       	call   800341 <cprintf>
	if (pipeisclosed(p[0]))
  80015b:	83 c4 04             	add    $0x4,%esp
  80015e:	ff 75 f0             	pushl  -0x10(%ebp)
  800161:	e8 04 1e 00 00       	call   801f6a <pipeisclosed>
  800166:	83 c4 10             	add    $0x10,%esp
  800169:	85 c0                	test   %eax,%eax
  80016b:	75 48                	jne    8001b5 <umain+0x182>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  80016d:	83 ec 08             	sub    $0x8,%esp
  800170:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800173:	50                   	push   %eax
  800174:	ff 75 f0             	pushl  -0x10(%ebp)
  800177:	e8 ba 12 00 00       	call   801436 <fd_lookup>
  80017c:	83 c4 10             	add    $0x10,%esp
  80017f:	85 c0                	test   %eax,%eax
  800181:	78 46                	js     8001c9 <umain+0x196>
		panic("cannot look up p[0]: %e", r);
	va = fd2data(fd);
  800183:	83 ec 0c             	sub    $0xc,%esp
  800186:	ff 75 ec             	pushl  -0x14(%ebp)
  800189:	e8 37 12 00 00       	call   8013c5 <fd2data>
	if (pageref(va) != 3+1)
  80018e:	89 04 24             	mov    %eax,(%esp)
  800191:	e8 65 1a 00 00       	call   801bfb <pageref>
  800196:	83 c4 10             	add    $0x10,%esp
  800199:	83 f8 04             	cmp    $0x4,%eax
  80019c:	74 3d                	je     8001db <umain+0x1a8>
		cprintf("\nchild detected race\n");
  80019e:	83 ec 0c             	sub    $0xc,%esp
  8001a1:	68 d5 24 80 00       	push   $0x8024d5
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
  8001b8:	68 00 25 80 00       	push   $0x802500
  8001bd:	6a 3a                	push   $0x3a
  8001bf:	68 62 24 80 00       	push   $0x802462
  8001c4:	e8 91 00 00 00       	call   80025a <_panic>
		panic("cannot look up p[0]: %e", r);
  8001c9:	50                   	push   %eax
  8001ca:	68 bd 24 80 00       	push   $0x8024bd
  8001cf:	6a 3c                	push   $0x3c
  8001d1:	68 62 24 80 00       	push   $0x802462
  8001d6:	e8 7f 00 00 00       	call   80025a <_panic>
		cprintf("\nrace didn't happen\n", max);
  8001db:	83 ec 08             	sub    $0x8,%esp
  8001de:	68 c8 00 00 00       	push   $0xc8
  8001e3:	68 eb 24 80 00       	push   $0x8024eb
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
  800213:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800218:	85 db                	test   %ebx,%ebx
  80021a:	7e 07                	jle    800223 <libmain+0x31>
		binaryname = argv[0];
  80021c:	8b 06                	mov    (%esi),%eax
  80021e:	a3 00 30 80 00       	mov    %eax,0x803000

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
  800246:	e8 55 13 00 00       	call   8015a0 <close_all>
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
  800266:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80026c:	e8 d6 0a 00 00       	call   800d47 <sys_getenvid>
  800271:	83 ec 0c             	sub    $0xc,%esp
  800274:	ff 75 0c             	pushl  0xc(%ebp)
  800277:	ff 75 08             	pushl  0x8(%ebp)
  80027a:	56                   	push   %esi
  80027b:	50                   	push   %eax
  80027c:	68 34 25 80 00       	push   $0x802534
  800281:	e8 bb 00 00 00       	call   800341 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800286:	83 c4 18             	add    $0x18,%esp
  800289:	53                   	push   %ebx
  80028a:	ff 75 10             	pushl  0x10(%ebp)
  80028d:	e8 5a 00 00 00       	call   8002ec <vcprintf>
	cprintf("\n");
  800292:	c7 04 24 57 24 80 00 	movl   $0x802457,(%esp)
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
  8003a7:	e8 24 1e 00 00       	call   8021d0 <__udivdi3>
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
  8003e5:	e8 f6 1e 00 00       	call   8022e0 <__umoddi3>
  8003ea:	83 c4 14             	add    $0x14,%esp
  8003ed:	0f be 80 57 25 80 00 	movsbl 0x802557(%eax),%eax
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
  800494:	3e ff 24 85 a0 26 80 	notrack jmp *0x8026a0(,%eax,4)
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
  800561:	8b 14 85 00 28 80 00 	mov    0x802800(,%eax,4),%edx
  800568:	85 d2                	test   %edx,%edx
  80056a:	74 18                	je     800584 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80056c:	52                   	push   %edx
  80056d:	68 e5 29 80 00       	push   $0x8029e5
  800572:	53                   	push   %ebx
  800573:	56                   	push   %esi
  800574:	e8 aa fe ff ff       	call   800423 <printfmt>
  800579:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80057c:	89 7d 14             	mov    %edi,0x14(%ebp)
  80057f:	e9 66 02 00 00       	jmp    8007ea <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800584:	50                   	push   %eax
  800585:	68 6f 25 80 00       	push   $0x80256f
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
  8005ac:	b8 68 25 80 00       	mov    $0x802568,%eax
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
  800d36:	68 5f 28 80 00       	push   $0x80285f
  800d3b:	6a 23                	push   $0x23
  800d3d:	68 7c 28 80 00       	push   $0x80287c
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
  800dc3:	68 5f 28 80 00       	push   $0x80285f
  800dc8:	6a 23                	push   $0x23
  800dca:	68 7c 28 80 00       	push   $0x80287c
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
  800e09:	68 5f 28 80 00       	push   $0x80285f
  800e0e:	6a 23                	push   $0x23
  800e10:	68 7c 28 80 00       	push   $0x80287c
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
  800e4f:	68 5f 28 80 00       	push   $0x80285f
  800e54:	6a 23                	push   $0x23
  800e56:	68 7c 28 80 00       	push   $0x80287c
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
  800e95:	68 5f 28 80 00       	push   $0x80285f
  800e9a:	6a 23                	push   $0x23
  800e9c:	68 7c 28 80 00       	push   $0x80287c
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
  800edb:	68 5f 28 80 00       	push   $0x80285f
  800ee0:	6a 23                	push   $0x23
  800ee2:	68 7c 28 80 00       	push   $0x80287c
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
  800f21:	68 5f 28 80 00       	push   $0x80285f
  800f26:	6a 23                	push   $0x23
  800f28:	68 7c 28 80 00       	push   $0x80287c
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
  800f8d:	68 5f 28 80 00       	push   $0x80285f
  800f92:	6a 23                	push   $0x23
  800f94:	68 7c 28 80 00       	push   $0x80287c
  800f99:	e8 bc f2 ff ff       	call   80025a <_panic>

00800f9e <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f9e:	f3 0f 1e fb          	endbr32 
  800fa2:	55                   	push   %ebp
  800fa3:	89 e5                	mov    %esp,%ebp
  800fa5:	53                   	push   %ebx
  800fa6:	83 ec 04             	sub    $0x4,%esp
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800fac:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  800fae:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800fb2:	74 74                	je     801028 <pgfault+0x8a>
  800fb4:	89 d8                	mov    %ebx,%eax
  800fb6:	c1 e8 0c             	shr    $0xc,%eax
  800fb9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fc0:	f6 c4 08             	test   $0x8,%ah
  800fc3:	74 63                	je     801028 <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800fc5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  800fcb:	83 ec 0c             	sub    $0xc,%esp
  800fce:	6a 05                	push   $0x5
  800fd0:	68 00 f0 7f 00       	push   $0x7ff000
  800fd5:	6a 00                	push   $0x0
  800fd7:	53                   	push   %ebx
  800fd8:	6a 00                	push   $0x0
  800fda:	e8 f5 fd ff ff       	call   800dd4 <sys_page_map>
  800fdf:	83 c4 20             	add    $0x20,%esp
  800fe2:	85 c0                	test   %eax,%eax
  800fe4:	78 59                	js     80103f <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  800fe6:	83 ec 04             	sub    $0x4,%esp
  800fe9:	6a 07                	push   $0x7
  800feb:	53                   	push   %ebx
  800fec:	6a 00                	push   $0x0
  800fee:	e8 9a fd ff ff       	call   800d8d <sys_page_alloc>
  800ff3:	83 c4 10             	add    $0x10,%esp
  800ff6:	85 c0                	test   %eax,%eax
  800ff8:	78 5a                	js     801054 <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  800ffa:	83 ec 04             	sub    $0x4,%esp
  800ffd:	68 00 10 00 00       	push   $0x1000
  801002:	68 00 f0 7f 00       	push   $0x7ff000
  801007:	53                   	push   %ebx
  801008:	e8 f4 fa ff ff       	call   800b01 <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  80100d:	83 c4 08             	add    $0x8,%esp
  801010:	68 00 f0 7f 00       	push   $0x7ff000
  801015:	6a 00                	push   $0x0
  801017:	e8 fe fd ff ff       	call   800e1a <sys_page_unmap>
  80101c:	83 c4 10             	add    $0x10,%esp
  80101f:	85 c0                	test   %eax,%eax
  801021:	78 46                	js     801069 <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  801023:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801026:	c9                   	leave  
  801027:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  801028:	83 ec 04             	sub    $0x4,%esp
  80102b:	68 8a 28 80 00       	push   $0x80288a
  801030:	68 d3 00 00 00       	push   $0xd3
  801035:	68 a6 28 80 00       	push   $0x8028a6
  80103a:	e8 1b f2 ff ff       	call   80025a <_panic>
		panic("pgfault: %e\n", r);
  80103f:	50                   	push   %eax
  801040:	68 b1 28 80 00       	push   $0x8028b1
  801045:	68 df 00 00 00       	push   $0xdf
  80104a:	68 a6 28 80 00       	push   $0x8028a6
  80104f:	e8 06 f2 ff ff       	call   80025a <_panic>
		panic("pgfault: %e\n", r);
  801054:	50                   	push   %eax
  801055:	68 b1 28 80 00       	push   $0x8028b1
  80105a:	68 e3 00 00 00       	push   $0xe3
  80105f:	68 a6 28 80 00       	push   $0x8028a6
  801064:	e8 f1 f1 ff ff       	call   80025a <_panic>
		panic("pgfault: %e\n", r);
  801069:	50                   	push   %eax
  80106a:	68 b1 28 80 00       	push   $0x8028b1
  80106f:	68 e9 00 00 00       	push   $0xe9
  801074:	68 a6 28 80 00       	push   $0x8028a6
  801079:	e8 dc f1 ff ff       	call   80025a <_panic>

0080107e <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80107e:	f3 0f 1e fb          	endbr32 
  801082:	55                   	push   %ebp
  801083:	89 e5                	mov    %esp,%ebp
  801085:	57                   	push   %edi
  801086:	56                   	push   %esi
  801087:	53                   	push   %ebx
  801088:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  80108b:	68 9e 0f 80 00       	push   $0x800f9e
  801090:	e8 a1 10 00 00       	call   802136 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801095:	b8 07 00 00 00       	mov    $0x7,%eax
  80109a:	cd 30                	int    $0x30
  80109c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  80109f:	83 c4 10             	add    $0x10,%esp
  8010a2:	85 c0                	test   %eax,%eax
  8010a4:	78 2d                	js     8010d3 <fork+0x55>
  8010a6:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8010a8:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  8010ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010b1:	0f 85 9b 00 00 00    	jne    801152 <fork+0xd4>
		thisenv = &envs[ENVX(sys_getenvid())];
  8010b7:	e8 8b fc ff ff       	call   800d47 <sys_getenvid>
  8010bc:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010c1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010c4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010c9:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  8010ce:	e9 71 01 00 00       	jmp    801244 <fork+0x1c6>
		panic("sys_exofork: %e", envid);
  8010d3:	50                   	push   %eax
  8010d4:	68 be 28 80 00       	push   $0x8028be
  8010d9:	68 2a 01 00 00       	push   $0x12a
  8010de:	68 a6 28 80 00       	push   $0x8028a6
  8010e3:	e8 72 f1 ff ff       	call   80025a <_panic>
		sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_SYSCALL);
  8010e8:	c1 e6 0c             	shl    $0xc,%esi
  8010eb:	83 ec 0c             	sub    $0xc,%esp
  8010ee:	68 07 0e 00 00       	push   $0xe07
  8010f3:	56                   	push   %esi
  8010f4:	57                   	push   %edi
  8010f5:	56                   	push   %esi
  8010f6:	6a 00                	push   $0x0
  8010f8:	e8 d7 fc ff ff       	call   800dd4 <sys_page_map>
  8010fd:	83 c4 20             	add    $0x20,%esp
  801100:	eb 3e                	jmp    801140 <fork+0xc2>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  801102:	c1 e6 0c             	shl    $0xc,%esi
  801105:	83 ec 0c             	sub    $0xc,%esp
  801108:	68 05 08 00 00       	push   $0x805
  80110d:	56                   	push   %esi
  80110e:	57                   	push   %edi
  80110f:	56                   	push   %esi
  801110:	6a 00                	push   $0x0
  801112:	e8 bd fc ff ff       	call   800dd4 <sys_page_map>
  801117:	83 c4 20             	add    $0x20,%esp
  80111a:	85 c0                	test   %eax,%eax
  80111c:	0f 88 bc 00 00 00    	js     8011de <fork+0x160>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  801122:	83 ec 0c             	sub    $0xc,%esp
  801125:	68 05 08 00 00       	push   $0x805
  80112a:	56                   	push   %esi
  80112b:	6a 00                	push   $0x0
  80112d:	56                   	push   %esi
  80112e:	6a 00                	push   $0x0
  801130:	e8 9f fc ff ff       	call   800dd4 <sys_page_map>
  801135:	83 c4 20             	add    $0x20,%esp
  801138:	85 c0                	test   %eax,%eax
  80113a:	0f 88 b3 00 00 00    	js     8011f3 <fork+0x175>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801140:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801146:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80114c:	0f 84 b6 00 00 00    	je     801208 <fork+0x18a>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  801152:	89 d8                	mov    %ebx,%eax
  801154:	c1 e8 16             	shr    $0x16,%eax
  801157:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80115e:	a8 01                	test   $0x1,%al
  801160:	74 de                	je     801140 <fork+0xc2>
  801162:	89 de                	mov    %ebx,%esi
  801164:	c1 ee 0c             	shr    $0xc,%esi
  801167:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80116e:	a8 01                	test   $0x1,%al
  801170:	74 ce                	je     801140 <fork+0xc2>
  801172:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801179:	a8 04                	test   $0x4,%al
  80117b:	74 c3                	je     801140 <fork+0xc2>
	if ((uvpt[pn] & PTE_SHARE)){
  80117d:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801184:	f6 c4 04             	test   $0x4,%ah
  801187:	0f 85 5b ff ff ff    	jne    8010e8 <fork+0x6a>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  80118d:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801194:	a8 02                	test   $0x2,%al
  801196:	0f 85 66 ff ff ff    	jne    801102 <fork+0x84>
  80119c:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011a3:	f6 c4 08             	test   $0x8,%ah
  8011a6:	0f 85 56 ff ff ff    	jne    801102 <fork+0x84>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  8011ac:	c1 e6 0c             	shl    $0xc,%esi
  8011af:	83 ec 0c             	sub    $0xc,%esp
  8011b2:	6a 05                	push   $0x5
  8011b4:	56                   	push   %esi
  8011b5:	57                   	push   %edi
  8011b6:	56                   	push   %esi
  8011b7:	6a 00                	push   $0x0
  8011b9:	e8 16 fc ff ff       	call   800dd4 <sys_page_map>
  8011be:	83 c4 20             	add    $0x20,%esp
  8011c1:	85 c0                	test   %eax,%eax
  8011c3:	0f 89 77 ff ff ff    	jns    801140 <fork+0xc2>
		panic("duppage: %e\n", r);
  8011c9:	50                   	push   %eax
  8011ca:	68 ce 28 80 00       	push   $0x8028ce
  8011cf:	68 0c 01 00 00       	push   $0x10c
  8011d4:	68 a6 28 80 00       	push   $0x8028a6
  8011d9:	e8 7c f0 ff ff       	call   80025a <_panic>
			panic("duppage: %e\n", r);
  8011de:	50                   	push   %eax
  8011df:	68 ce 28 80 00       	push   $0x8028ce
  8011e4:	68 05 01 00 00       	push   $0x105
  8011e9:	68 a6 28 80 00       	push   $0x8028a6
  8011ee:	e8 67 f0 ff ff       	call   80025a <_panic>
			panic("duppage: %e\n", r);
  8011f3:	50                   	push   %eax
  8011f4:	68 ce 28 80 00       	push   $0x8028ce
  8011f9:	68 09 01 00 00       	push   $0x109
  8011fe:	68 a6 28 80 00       	push   $0x8028a6
  801203:	e8 52 f0 ff ff       	call   80025a <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  801208:	83 ec 04             	sub    $0x4,%esp
  80120b:	6a 07                	push   $0x7
  80120d:	68 00 f0 bf ee       	push   $0xeebff000
  801212:	ff 75 e4             	pushl  -0x1c(%ebp)
  801215:	e8 73 fb ff ff       	call   800d8d <sys_page_alloc>
  80121a:	83 c4 10             	add    $0x10,%esp
  80121d:	85 c0                	test   %eax,%eax
  80121f:	78 2e                	js     80124f <fork+0x1d1>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801221:	83 ec 08             	sub    $0x8,%esp
  801224:	68 a9 21 80 00       	push   $0x8021a9
  801229:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80122c:	57                   	push   %edi
  80122d:	e8 ba fc ff ff       	call   800eec <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801232:	83 c4 08             	add    $0x8,%esp
  801235:	6a 02                	push   $0x2
  801237:	57                   	push   %edi
  801238:	e8 23 fc ff ff       	call   800e60 <sys_env_set_status>
  80123d:	83 c4 10             	add    $0x10,%esp
  801240:	85 c0                	test   %eax,%eax
  801242:	78 20                	js     801264 <fork+0x1e6>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  801244:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801247:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80124a:	5b                   	pop    %ebx
  80124b:	5e                   	pop    %esi
  80124c:	5f                   	pop    %edi
  80124d:	5d                   	pop    %ebp
  80124e:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  80124f:	50                   	push   %eax
  801250:	68 db 28 80 00       	push   $0x8028db
  801255:	68 3e 01 00 00       	push   $0x13e
  80125a:	68 a6 28 80 00       	push   $0x8028a6
  80125f:	e8 f6 ef ff ff       	call   80025a <_panic>
		panic("sys_env_set_status: %e", r);
  801264:	50                   	push   %eax
  801265:	68 ee 28 80 00       	push   $0x8028ee
  80126a:	68 43 01 00 00       	push   $0x143
  80126f:	68 a6 28 80 00       	push   $0x8028a6
  801274:	e8 e1 ef ff ff       	call   80025a <_panic>

00801279 <sfork>:

// Challenge!
int
sfork(void)
{
  801279:	f3 0f 1e fb          	endbr32 
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
  801280:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801283:	68 05 29 80 00       	push   $0x802905
  801288:	68 4c 01 00 00       	push   $0x14c
  80128d:	68 a6 28 80 00       	push   $0x8028a6
  801292:	e8 c3 ef ff ff       	call   80025a <_panic>

00801297 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801297:	f3 0f 1e fb          	endbr32 
  80129b:	55                   	push   %ebp
  80129c:	89 e5                	mov    %esp,%ebp
  80129e:	56                   	push   %esi
  80129f:	53                   	push   %ebx
  8012a0:	8b 75 08             	mov    0x8(%ebp),%esi
  8012a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  8012a9:	85 c0                	test   %eax,%eax
  8012ab:	74 3d                	je     8012ea <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  8012ad:	83 ec 0c             	sub    $0xc,%esp
  8012b0:	50                   	push   %eax
  8012b1:	e8 a3 fc ff ff       	call   800f59 <sys_ipc_recv>
  8012b6:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  8012b9:	85 f6                	test   %esi,%esi
  8012bb:	74 0b                	je     8012c8 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8012bd:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8012c3:	8b 52 74             	mov    0x74(%edx),%edx
  8012c6:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  8012c8:	85 db                	test   %ebx,%ebx
  8012ca:	74 0b                	je     8012d7 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  8012cc:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8012d2:	8b 52 78             	mov    0x78(%edx),%edx
  8012d5:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  8012d7:	85 c0                	test   %eax,%eax
  8012d9:	78 21                	js     8012fc <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  8012db:	a1 04 40 80 00       	mov    0x804004,%eax
  8012e0:	8b 40 70             	mov    0x70(%eax),%eax
}
  8012e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012e6:	5b                   	pop    %ebx
  8012e7:	5e                   	pop    %esi
  8012e8:	5d                   	pop    %ebp
  8012e9:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  8012ea:	83 ec 0c             	sub    $0xc,%esp
  8012ed:	68 00 00 c0 ee       	push   $0xeec00000
  8012f2:	e8 62 fc ff ff       	call   800f59 <sys_ipc_recv>
  8012f7:	83 c4 10             	add    $0x10,%esp
  8012fa:	eb bd                	jmp    8012b9 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  8012fc:	85 f6                	test   %esi,%esi
  8012fe:	74 10                	je     801310 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  801300:	85 db                	test   %ebx,%ebx
  801302:	75 df                	jne    8012e3 <ipc_recv+0x4c>
  801304:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80130b:	00 00 00 
  80130e:	eb d3                	jmp    8012e3 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  801310:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801317:	00 00 00 
  80131a:	eb e4                	jmp    801300 <ipc_recv+0x69>

0080131c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80131c:	f3 0f 1e fb          	endbr32 
  801320:	55                   	push   %ebp
  801321:	89 e5                	mov    %esp,%ebp
  801323:	57                   	push   %edi
  801324:	56                   	push   %esi
  801325:	53                   	push   %ebx
  801326:	83 ec 0c             	sub    $0xc,%esp
  801329:	8b 7d 08             	mov    0x8(%ebp),%edi
  80132c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80132f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  801332:	85 db                	test   %ebx,%ebx
  801334:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801339:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  80133c:	ff 75 14             	pushl  0x14(%ebp)
  80133f:	53                   	push   %ebx
  801340:	56                   	push   %esi
  801341:	57                   	push   %edi
  801342:	e8 eb fb ff ff       	call   800f32 <sys_ipc_try_send>
  801347:	83 c4 10             	add    $0x10,%esp
  80134a:	85 c0                	test   %eax,%eax
  80134c:	79 1e                	jns    80136c <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  80134e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801351:	75 07                	jne    80135a <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  801353:	e8 12 fa ff ff       	call   800d6a <sys_yield>
  801358:	eb e2                	jmp    80133c <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  80135a:	50                   	push   %eax
  80135b:	68 1b 29 80 00       	push   $0x80291b
  801360:	6a 59                	push   $0x59
  801362:	68 36 29 80 00       	push   $0x802936
  801367:	e8 ee ee ff ff       	call   80025a <_panic>
	}
}
  80136c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80136f:	5b                   	pop    %ebx
  801370:	5e                   	pop    %esi
  801371:	5f                   	pop    %edi
  801372:	5d                   	pop    %ebp
  801373:	c3                   	ret    

00801374 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801374:	f3 0f 1e fb          	endbr32 
  801378:	55                   	push   %ebp
  801379:	89 e5                	mov    %esp,%ebp
  80137b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80137e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801383:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801386:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80138c:	8b 52 50             	mov    0x50(%edx),%edx
  80138f:	39 ca                	cmp    %ecx,%edx
  801391:	74 11                	je     8013a4 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801393:	83 c0 01             	add    $0x1,%eax
  801396:	3d 00 04 00 00       	cmp    $0x400,%eax
  80139b:	75 e6                	jne    801383 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  80139d:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a2:	eb 0b                	jmp    8013af <ipc_find_env+0x3b>
			return envs[i].env_id;
  8013a4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8013a7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013ac:	8b 40 48             	mov    0x48(%eax),%eax
}
  8013af:	5d                   	pop    %ebp
  8013b0:	c3                   	ret    

008013b1 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8013b1:	f3 0f 1e fb          	endbr32 
  8013b5:	55                   	push   %ebp
  8013b6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	05 00 00 00 30       	add    $0x30000000,%eax
  8013c0:	c1 e8 0c             	shr    $0xc,%eax
}
  8013c3:	5d                   	pop    %ebp
  8013c4:	c3                   	ret    

008013c5 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013c5:	f3 0f 1e fb          	endbr32 
  8013c9:	55                   	push   %ebp
  8013ca:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cf:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8013d4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013d9:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8013de:	5d                   	pop    %ebp
  8013df:	c3                   	ret    

008013e0 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013e0:	f3 0f 1e fb          	endbr32 
  8013e4:	55                   	push   %ebp
  8013e5:	89 e5                	mov    %esp,%ebp
  8013e7:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013ec:	89 c2                	mov    %eax,%edx
  8013ee:	c1 ea 16             	shr    $0x16,%edx
  8013f1:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013f8:	f6 c2 01             	test   $0x1,%dl
  8013fb:	74 2d                	je     80142a <fd_alloc+0x4a>
  8013fd:	89 c2                	mov    %eax,%edx
  8013ff:	c1 ea 0c             	shr    $0xc,%edx
  801402:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801409:	f6 c2 01             	test   $0x1,%dl
  80140c:	74 1c                	je     80142a <fd_alloc+0x4a>
  80140e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801413:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801418:	75 d2                	jne    8013ec <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801423:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801428:	eb 0a                	jmp    801434 <fd_alloc+0x54>
			*fd_store = fd;
  80142a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80142d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80142f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801434:	5d                   	pop    %ebp
  801435:	c3                   	ret    

00801436 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801436:	f3 0f 1e fb          	endbr32 
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801440:	83 f8 1f             	cmp    $0x1f,%eax
  801443:	77 30                	ja     801475 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801445:	c1 e0 0c             	shl    $0xc,%eax
  801448:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80144d:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801453:	f6 c2 01             	test   $0x1,%dl
  801456:	74 24                	je     80147c <fd_lookup+0x46>
  801458:	89 c2                	mov    %eax,%edx
  80145a:	c1 ea 0c             	shr    $0xc,%edx
  80145d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801464:	f6 c2 01             	test   $0x1,%dl
  801467:	74 1a                	je     801483 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801469:	8b 55 0c             	mov    0xc(%ebp),%edx
  80146c:	89 02                	mov    %eax,(%edx)
	return 0;
  80146e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801473:	5d                   	pop    %ebp
  801474:	c3                   	ret    
		return -E_INVAL;
  801475:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80147a:	eb f7                	jmp    801473 <fd_lookup+0x3d>
		return -E_INVAL;
  80147c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801481:	eb f0                	jmp    801473 <fd_lookup+0x3d>
  801483:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801488:	eb e9                	jmp    801473 <fd_lookup+0x3d>

0080148a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80148a:	f3 0f 1e fb          	endbr32 
  80148e:	55                   	push   %ebp
  80148f:	89 e5                	mov    %esp,%ebp
  801491:	83 ec 08             	sub    $0x8,%esp
  801494:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801497:	ba bc 29 80 00       	mov    $0x8029bc,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80149c:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8014a1:	39 08                	cmp    %ecx,(%eax)
  8014a3:	74 33                	je     8014d8 <dev_lookup+0x4e>
  8014a5:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8014a8:	8b 02                	mov    (%edx),%eax
  8014aa:	85 c0                	test   %eax,%eax
  8014ac:	75 f3                	jne    8014a1 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8014ae:	a1 04 40 80 00       	mov    0x804004,%eax
  8014b3:	8b 40 48             	mov    0x48(%eax),%eax
  8014b6:	83 ec 04             	sub    $0x4,%esp
  8014b9:	51                   	push   %ecx
  8014ba:	50                   	push   %eax
  8014bb:	68 40 29 80 00       	push   $0x802940
  8014c0:	e8 7c ee ff ff       	call   800341 <cprintf>
	*dev = 0;
  8014c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8014ce:	83 c4 10             	add    $0x10,%esp
  8014d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014d6:	c9                   	leave  
  8014d7:	c3                   	ret    
			*dev = devtab[i];
  8014d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014db:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e2:	eb f2                	jmp    8014d6 <dev_lookup+0x4c>

008014e4 <fd_close>:
{
  8014e4:	f3 0f 1e fb          	endbr32 
  8014e8:	55                   	push   %ebp
  8014e9:	89 e5                	mov    %esp,%ebp
  8014eb:	57                   	push   %edi
  8014ec:	56                   	push   %esi
  8014ed:	53                   	push   %ebx
  8014ee:	83 ec 24             	sub    $0x24,%esp
  8014f1:	8b 75 08             	mov    0x8(%ebp),%esi
  8014f4:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014f7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014fa:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014fb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801501:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801504:	50                   	push   %eax
  801505:	e8 2c ff ff ff       	call   801436 <fd_lookup>
  80150a:	89 c3                	mov    %eax,%ebx
  80150c:	83 c4 10             	add    $0x10,%esp
  80150f:	85 c0                	test   %eax,%eax
  801511:	78 05                	js     801518 <fd_close+0x34>
	    || fd != fd2)
  801513:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801516:	74 16                	je     80152e <fd_close+0x4a>
		return (must_exist ? r : 0);
  801518:	89 f8                	mov    %edi,%eax
  80151a:	84 c0                	test   %al,%al
  80151c:	b8 00 00 00 00       	mov    $0x0,%eax
  801521:	0f 44 d8             	cmove  %eax,%ebx
}
  801524:	89 d8                	mov    %ebx,%eax
  801526:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801529:	5b                   	pop    %ebx
  80152a:	5e                   	pop    %esi
  80152b:	5f                   	pop    %edi
  80152c:	5d                   	pop    %ebp
  80152d:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80152e:	83 ec 08             	sub    $0x8,%esp
  801531:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801534:	50                   	push   %eax
  801535:	ff 36                	pushl  (%esi)
  801537:	e8 4e ff ff ff       	call   80148a <dev_lookup>
  80153c:	89 c3                	mov    %eax,%ebx
  80153e:	83 c4 10             	add    $0x10,%esp
  801541:	85 c0                	test   %eax,%eax
  801543:	78 1a                	js     80155f <fd_close+0x7b>
		if (dev->dev_close)
  801545:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801548:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80154b:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801550:	85 c0                	test   %eax,%eax
  801552:	74 0b                	je     80155f <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801554:	83 ec 0c             	sub    $0xc,%esp
  801557:	56                   	push   %esi
  801558:	ff d0                	call   *%eax
  80155a:	89 c3                	mov    %eax,%ebx
  80155c:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80155f:	83 ec 08             	sub    $0x8,%esp
  801562:	56                   	push   %esi
  801563:	6a 00                	push   $0x0
  801565:	e8 b0 f8 ff ff       	call   800e1a <sys_page_unmap>
	return r;
  80156a:	83 c4 10             	add    $0x10,%esp
  80156d:	eb b5                	jmp    801524 <fd_close+0x40>

0080156f <close>:

int
close(int fdnum)
{
  80156f:	f3 0f 1e fb          	endbr32 
  801573:	55                   	push   %ebp
  801574:	89 e5                	mov    %esp,%ebp
  801576:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801579:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80157c:	50                   	push   %eax
  80157d:	ff 75 08             	pushl  0x8(%ebp)
  801580:	e8 b1 fe ff ff       	call   801436 <fd_lookup>
  801585:	83 c4 10             	add    $0x10,%esp
  801588:	85 c0                	test   %eax,%eax
  80158a:	79 02                	jns    80158e <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80158c:	c9                   	leave  
  80158d:	c3                   	ret    
		return fd_close(fd, 1);
  80158e:	83 ec 08             	sub    $0x8,%esp
  801591:	6a 01                	push   $0x1
  801593:	ff 75 f4             	pushl  -0xc(%ebp)
  801596:	e8 49 ff ff ff       	call   8014e4 <fd_close>
  80159b:	83 c4 10             	add    $0x10,%esp
  80159e:	eb ec                	jmp    80158c <close+0x1d>

008015a0 <close_all>:

void
close_all(void)
{
  8015a0:	f3 0f 1e fb          	endbr32 
  8015a4:	55                   	push   %ebp
  8015a5:	89 e5                	mov    %esp,%ebp
  8015a7:	53                   	push   %ebx
  8015a8:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8015ab:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8015b0:	83 ec 0c             	sub    $0xc,%esp
  8015b3:	53                   	push   %ebx
  8015b4:	e8 b6 ff ff ff       	call   80156f <close>
	for (i = 0; i < MAXFD; i++)
  8015b9:	83 c3 01             	add    $0x1,%ebx
  8015bc:	83 c4 10             	add    $0x10,%esp
  8015bf:	83 fb 20             	cmp    $0x20,%ebx
  8015c2:	75 ec                	jne    8015b0 <close_all+0x10>
}
  8015c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015c7:	c9                   	leave  
  8015c8:	c3                   	ret    

008015c9 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015c9:	f3 0f 1e fb          	endbr32 
  8015cd:	55                   	push   %ebp
  8015ce:	89 e5                	mov    %esp,%ebp
  8015d0:	57                   	push   %edi
  8015d1:	56                   	push   %esi
  8015d2:	53                   	push   %ebx
  8015d3:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015d6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015d9:	50                   	push   %eax
  8015da:	ff 75 08             	pushl  0x8(%ebp)
  8015dd:	e8 54 fe ff ff       	call   801436 <fd_lookup>
  8015e2:	89 c3                	mov    %eax,%ebx
  8015e4:	83 c4 10             	add    $0x10,%esp
  8015e7:	85 c0                	test   %eax,%eax
  8015e9:	0f 88 81 00 00 00    	js     801670 <dup+0xa7>
		return r;
	close(newfdnum);
  8015ef:	83 ec 0c             	sub    $0xc,%esp
  8015f2:	ff 75 0c             	pushl  0xc(%ebp)
  8015f5:	e8 75 ff ff ff       	call   80156f <close>

	newfd = INDEX2FD(newfdnum);
  8015fa:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015fd:	c1 e6 0c             	shl    $0xc,%esi
  801600:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801606:	83 c4 04             	add    $0x4,%esp
  801609:	ff 75 e4             	pushl  -0x1c(%ebp)
  80160c:	e8 b4 fd ff ff       	call   8013c5 <fd2data>
  801611:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801613:	89 34 24             	mov    %esi,(%esp)
  801616:	e8 aa fd ff ff       	call   8013c5 <fd2data>
  80161b:	83 c4 10             	add    $0x10,%esp
  80161e:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801620:	89 d8                	mov    %ebx,%eax
  801622:	c1 e8 16             	shr    $0x16,%eax
  801625:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80162c:	a8 01                	test   $0x1,%al
  80162e:	74 11                	je     801641 <dup+0x78>
  801630:	89 d8                	mov    %ebx,%eax
  801632:	c1 e8 0c             	shr    $0xc,%eax
  801635:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80163c:	f6 c2 01             	test   $0x1,%dl
  80163f:	75 39                	jne    80167a <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801641:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801644:	89 d0                	mov    %edx,%eax
  801646:	c1 e8 0c             	shr    $0xc,%eax
  801649:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801650:	83 ec 0c             	sub    $0xc,%esp
  801653:	25 07 0e 00 00       	and    $0xe07,%eax
  801658:	50                   	push   %eax
  801659:	56                   	push   %esi
  80165a:	6a 00                	push   $0x0
  80165c:	52                   	push   %edx
  80165d:	6a 00                	push   $0x0
  80165f:	e8 70 f7 ff ff       	call   800dd4 <sys_page_map>
  801664:	89 c3                	mov    %eax,%ebx
  801666:	83 c4 20             	add    $0x20,%esp
  801669:	85 c0                	test   %eax,%eax
  80166b:	78 31                	js     80169e <dup+0xd5>
		goto err;

	return newfdnum;
  80166d:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801670:	89 d8                	mov    %ebx,%eax
  801672:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801675:	5b                   	pop    %ebx
  801676:	5e                   	pop    %esi
  801677:	5f                   	pop    %edi
  801678:	5d                   	pop    %ebp
  801679:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80167a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801681:	83 ec 0c             	sub    $0xc,%esp
  801684:	25 07 0e 00 00       	and    $0xe07,%eax
  801689:	50                   	push   %eax
  80168a:	57                   	push   %edi
  80168b:	6a 00                	push   $0x0
  80168d:	53                   	push   %ebx
  80168e:	6a 00                	push   $0x0
  801690:	e8 3f f7 ff ff       	call   800dd4 <sys_page_map>
  801695:	89 c3                	mov    %eax,%ebx
  801697:	83 c4 20             	add    $0x20,%esp
  80169a:	85 c0                	test   %eax,%eax
  80169c:	79 a3                	jns    801641 <dup+0x78>
	sys_page_unmap(0, newfd);
  80169e:	83 ec 08             	sub    $0x8,%esp
  8016a1:	56                   	push   %esi
  8016a2:	6a 00                	push   $0x0
  8016a4:	e8 71 f7 ff ff       	call   800e1a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8016a9:	83 c4 08             	add    $0x8,%esp
  8016ac:	57                   	push   %edi
  8016ad:	6a 00                	push   $0x0
  8016af:	e8 66 f7 ff ff       	call   800e1a <sys_page_unmap>
	return r;
  8016b4:	83 c4 10             	add    $0x10,%esp
  8016b7:	eb b7                	jmp    801670 <dup+0xa7>

008016b9 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016b9:	f3 0f 1e fb          	endbr32 
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
  8016c0:	53                   	push   %ebx
  8016c1:	83 ec 1c             	sub    $0x1c,%esp
  8016c4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016c7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016ca:	50                   	push   %eax
  8016cb:	53                   	push   %ebx
  8016cc:	e8 65 fd ff ff       	call   801436 <fd_lookup>
  8016d1:	83 c4 10             	add    $0x10,%esp
  8016d4:	85 c0                	test   %eax,%eax
  8016d6:	78 3f                	js     801717 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016d8:	83 ec 08             	sub    $0x8,%esp
  8016db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016de:	50                   	push   %eax
  8016df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e2:	ff 30                	pushl  (%eax)
  8016e4:	e8 a1 fd ff ff       	call   80148a <dev_lookup>
  8016e9:	83 c4 10             	add    $0x10,%esp
  8016ec:	85 c0                	test   %eax,%eax
  8016ee:	78 27                	js     801717 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016f3:	8b 42 08             	mov    0x8(%edx),%eax
  8016f6:	83 e0 03             	and    $0x3,%eax
  8016f9:	83 f8 01             	cmp    $0x1,%eax
  8016fc:	74 1e                	je     80171c <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8016fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801701:	8b 40 08             	mov    0x8(%eax),%eax
  801704:	85 c0                	test   %eax,%eax
  801706:	74 35                	je     80173d <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801708:	83 ec 04             	sub    $0x4,%esp
  80170b:	ff 75 10             	pushl  0x10(%ebp)
  80170e:	ff 75 0c             	pushl  0xc(%ebp)
  801711:	52                   	push   %edx
  801712:	ff d0                	call   *%eax
  801714:	83 c4 10             	add    $0x10,%esp
}
  801717:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80171a:	c9                   	leave  
  80171b:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80171c:	a1 04 40 80 00       	mov    0x804004,%eax
  801721:	8b 40 48             	mov    0x48(%eax),%eax
  801724:	83 ec 04             	sub    $0x4,%esp
  801727:	53                   	push   %ebx
  801728:	50                   	push   %eax
  801729:	68 81 29 80 00       	push   $0x802981
  80172e:	e8 0e ec ff ff       	call   800341 <cprintf>
		return -E_INVAL;
  801733:	83 c4 10             	add    $0x10,%esp
  801736:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80173b:	eb da                	jmp    801717 <read+0x5e>
		return -E_NOT_SUPP;
  80173d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801742:	eb d3                	jmp    801717 <read+0x5e>

00801744 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801744:	f3 0f 1e fb          	endbr32 
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
  80174b:	57                   	push   %edi
  80174c:	56                   	push   %esi
  80174d:	53                   	push   %ebx
  80174e:	83 ec 0c             	sub    $0xc,%esp
  801751:	8b 7d 08             	mov    0x8(%ebp),%edi
  801754:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801757:	bb 00 00 00 00       	mov    $0x0,%ebx
  80175c:	eb 02                	jmp    801760 <readn+0x1c>
  80175e:	01 c3                	add    %eax,%ebx
  801760:	39 f3                	cmp    %esi,%ebx
  801762:	73 21                	jae    801785 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801764:	83 ec 04             	sub    $0x4,%esp
  801767:	89 f0                	mov    %esi,%eax
  801769:	29 d8                	sub    %ebx,%eax
  80176b:	50                   	push   %eax
  80176c:	89 d8                	mov    %ebx,%eax
  80176e:	03 45 0c             	add    0xc(%ebp),%eax
  801771:	50                   	push   %eax
  801772:	57                   	push   %edi
  801773:	e8 41 ff ff ff       	call   8016b9 <read>
		if (m < 0)
  801778:	83 c4 10             	add    $0x10,%esp
  80177b:	85 c0                	test   %eax,%eax
  80177d:	78 04                	js     801783 <readn+0x3f>
			return m;
		if (m == 0)
  80177f:	75 dd                	jne    80175e <readn+0x1a>
  801781:	eb 02                	jmp    801785 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801783:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801785:	89 d8                	mov    %ebx,%eax
  801787:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80178a:	5b                   	pop    %ebx
  80178b:	5e                   	pop    %esi
  80178c:	5f                   	pop    %edi
  80178d:	5d                   	pop    %ebp
  80178e:	c3                   	ret    

0080178f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80178f:	f3 0f 1e fb          	endbr32 
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
  801796:	53                   	push   %ebx
  801797:	83 ec 1c             	sub    $0x1c,%esp
  80179a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80179d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017a0:	50                   	push   %eax
  8017a1:	53                   	push   %ebx
  8017a2:	e8 8f fc ff ff       	call   801436 <fd_lookup>
  8017a7:	83 c4 10             	add    $0x10,%esp
  8017aa:	85 c0                	test   %eax,%eax
  8017ac:	78 3a                	js     8017e8 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017ae:	83 ec 08             	sub    $0x8,%esp
  8017b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017b4:	50                   	push   %eax
  8017b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b8:	ff 30                	pushl  (%eax)
  8017ba:	e8 cb fc ff ff       	call   80148a <dev_lookup>
  8017bf:	83 c4 10             	add    $0x10,%esp
  8017c2:	85 c0                	test   %eax,%eax
  8017c4:	78 22                	js     8017e8 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017cd:	74 1e                	je     8017ed <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8017cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d2:	8b 52 0c             	mov    0xc(%edx),%edx
  8017d5:	85 d2                	test   %edx,%edx
  8017d7:	74 35                	je     80180e <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017d9:	83 ec 04             	sub    $0x4,%esp
  8017dc:	ff 75 10             	pushl  0x10(%ebp)
  8017df:	ff 75 0c             	pushl  0xc(%ebp)
  8017e2:	50                   	push   %eax
  8017e3:	ff d2                	call   *%edx
  8017e5:	83 c4 10             	add    $0x10,%esp
}
  8017e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017eb:	c9                   	leave  
  8017ec:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017ed:	a1 04 40 80 00       	mov    0x804004,%eax
  8017f2:	8b 40 48             	mov    0x48(%eax),%eax
  8017f5:	83 ec 04             	sub    $0x4,%esp
  8017f8:	53                   	push   %ebx
  8017f9:	50                   	push   %eax
  8017fa:	68 9d 29 80 00       	push   $0x80299d
  8017ff:	e8 3d eb ff ff       	call   800341 <cprintf>
		return -E_INVAL;
  801804:	83 c4 10             	add    $0x10,%esp
  801807:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80180c:	eb da                	jmp    8017e8 <write+0x59>
		return -E_NOT_SUPP;
  80180e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801813:	eb d3                	jmp    8017e8 <write+0x59>

00801815 <seek>:

int
seek(int fdnum, off_t offset)
{
  801815:	f3 0f 1e fb          	endbr32 
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
  80181c:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80181f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801822:	50                   	push   %eax
  801823:	ff 75 08             	pushl  0x8(%ebp)
  801826:	e8 0b fc ff ff       	call   801436 <fd_lookup>
  80182b:	83 c4 10             	add    $0x10,%esp
  80182e:	85 c0                	test   %eax,%eax
  801830:	78 0e                	js     801840 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801832:	8b 55 0c             	mov    0xc(%ebp),%edx
  801835:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801838:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80183b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801840:	c9                   	leave  
  801841:	c3                   	ret    

00801842 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801842:	f3 0f 1e fb          	endbr32 
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
  801849:	53                   	push   %ebx
  80184a:	83 ec 1c             	sub    $0x1c,%esp
  80184d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801850:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801853:	50                   	push   %eax
  801854:	53                   	push   %ebx
  801855:	e8 dc fb ff ff       	call   801436 <fd_lookup>
  80185a:	83 c4 10             	add    $0x10,%esp
  80185d:	85 c0                	test   %eax,%eax
  80185f:	78 37                	js     801898 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801861:	83 ec 08             	sub    $0x8,%esp
  801864:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801867:	50                   	push   %eax
  801868:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80186b:	ff 30                	pushl  (%eax)
  80186d:	e8 18 fc ff ff       	call   80148a <dev_lookup>
  801872:	83 c4 10             	add    $0x10,%esp
  801875:	85 c0                	test   %eax,%eax
  801877:	78 1f                	js     801898 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801879:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80187c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801880:	74 1b                	je     80189d <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801882:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801885:	8b 52 18             	mov    0x18(%edx),%edx
  801888:	85 d2                	test   %edx,%edx
  80188a:	74 32                	je     8018be <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80188c:	83 ec 08             	sub    $0x8,%esp
  80188f:	ff 75 0c             	pushl  0xc(%ebp)
  801892:	50                   	push   %eax
  801893:	ff d2                	call   *%edx
  801895:	83 c4 10             	add    $0x10,%esp
}
  801898:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80189b:	c9                   	leave  
  80189c:	c3                   	ret    
			thisenv->env_id, fdnum);
  80189d:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8018a2:	8b 40 48             	mov    0x48(%eax),%eax
  8018a5:	83 ec 04             	sub    $0x4,%esp
  8018a8:	53                   	push   %ebx
  8018a9:	50                   	push   %eax
  8018aa:	68 60 29 80 00       	push   $0x802960
  8018af:	e8 8d ea ff ff       	call   800341 <cprintf>
		return -E_INVAL;
  8018b4:	83 c4 10             	add    $0x10,%esp
  8018b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018bc:	eb da                	jmp    801898 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8018be:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018c3:	eb d3                	jmp    801898 <ftruncate+0x56>

008018c5 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018c5:	f3 0f 1e fb          	endbr32 
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
  8018cc:	53                   	push   %ebx
  8018cd:	83 ec 1c             	sub    $0x1c,%esp
  8018d0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018d3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018d6:	50                   	push   %eax
  8018d7:	ff 75 08             	pushl  0x8(%ebp)
  8018da:	e8 57 fb ff ff       	call   801436 <fd_lookup>
  8018df:	83 c4 10             	add    $0x10,%esp
  8018e2:	85 c0                	test   %eax,%eax
  8018e4:	78 4b                	js     801931 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018e6:	83 ec 08             	sub    $0x8,%esp
  8018e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ec:	50                   	push   %eax
  8018ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018f0:	ff 30                	pushl  (%eax)
  8018f2:	e8 93 fb ff ff       	call   80148a <dev_lookup>
  8018f7:	83 c4 10             	add    $0x10,%esp
  8018fa:	85 c0                	test   %eax,%eax
  8018fc:	78 33                	js     801931 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8018fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801901:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801905:	74 2f                	je     801936 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801907:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80190a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801911:	00 00 00 
	stat->st_isdir = 0;
  801914:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80191b:	00 00 00 
	stat->st_dev = dev;
  80191e:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801924:	83 ec 08             	sub    $0x8,%esp
  801927:	53                   	push   %ebx
  801928:	ff 75 f0             	pushl  -0x10(%ebp)
  80192b:	ff 50 14             	call   *0x14(%eax)
  80192e:	83 c4 10             	add    $0x10,%esp
}
  801931:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801934:	c9                   	leave  
  801935:	c3                   	ret    
		return -E_NOT_SUPP;
  801936:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80193b:	eb f4                	jmp    801931 <fstat+0x6c>

0080193d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80193d:	f3 0f 1e fb          	endbr32 
  801941:	55                   	push   %ebp
  801942:	89 e5                	mov    %esp,%ebp
  801944:	56                   	push   %esi
  801945:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801946:	83 ec 08             	sub    $0x8,%esp
  801949:	6a 00                	push   $0x0
  80194b:	ff 75 08             	pushl  0x8(%ebp)
  80194e:	e8 fb 01 00 00       	call   801b4e <open>
  801953:	89 c3                	mov    %eax,%ebx
  801955:	83 c4 10             	add    $0x10,%esp
  801958:	85 c0                	test   %eax,%eax
  80195a:	78 1b                	js     801977 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80195c:	83 ec 08             	sub    $0x8,%esp
  80195f:	ff 75 0c             	pushl  0xc(%ebp)
  801962:	50                   	push   %eax
  801963:	e8 5d ff ff ff       	call   8018c5 <fstat>
  801968:	89 c6                	mov    %eax,%esi
	close(fd);
  80196a:	89 1c 24             	mov    %ebx,(%esp)
  80196d:	e8 fd fb ff ff       	call   80156f <close>
	return r;
  801972:	83 c4 10             	add    $0x10,%esp
  801975:	89 f3                	mov    %esi,%ebx
}
  801977:	89 d8                	mov    %ebx,%eax
  801979:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80197c:	5b                   	pop    %ebx
  80197d:	5e                   	pop    %esi
  80197e:	5d                   	pop    %ebp
  80197f:	c3                   	ret    

00801980 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
  801983:	56                   	push   %esi
  801984:	53                   	push   %ebx
  801985:	89 c6                	mov    %eax,%esi
  801987:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801989:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801990:	74 27                	je     8019b9 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801992:	6a 07                	push   $0x7
  801994:	68 00 50 80 00       	push   $0x805000
  801999:	56                   	push   %esi
  80199a:	ff 35 00 40 80 00    	pushl  0x804000
  8019a0:	e8 77 f9 ff ff       	call   80131c <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8019a5:	83 c4 0c             	add    $0xc,%esp
  8019a8:	6a 00                	push   $0x0
  8019aa:	53                   	push   %ebx
  8019ab:	6a 00                	push   $0x0
  8019ad:	e8 e5 f8 ff ff       	call   801297 <ipc_recv>
}
  8019b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019b5:	5b                   	pop    %ebx
  8019b6:	5e                   	pop    %esi
  8019b7:	5d                   	pop    %ebp
  8019b8:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8019b9:	83 ec 0c             	sub    $0xc,%esp
  8019bc:	6a 01                	push   $0x1
  8019be:	e8 b1 f9 ff ff       	call   801374 <ipc_find_env>
  8019c3:	a3 00 40 80 00       	mov    %eax,0x804000
  8019c8:	83 c4 10             	add    $0x10,%esp
  8019cb:	eb c5                	jmp    801992 <fsipc+0x12>

008019cd <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8019cd:	f3 0f 1e fb          	endbr32 
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
  8019d4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8019d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019da:	8b 40 0c             	mov    0xc(%eax),%eax
  8019dd:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8019e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e5:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8019ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ef:	b8 02 00 00 00       	mov    $0x2,%eax
  8019f4:	e8 87 ff ff ff       	call   801980 <fsipc>
}
  8019f9:	c9                   	leave  
  8019fa:	c3                   	ret    

008019fb <devfile_flush>:
{
  8019fb:	f3 0f 1e fb          	endbr32 
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
  801a02:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a05:	8b 45 08             	mov    0x8(%ebp),%eax
  801a08:	8b 40 0c             	mov    0xc(%eax),%eax
  801a0b:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801a10:	ba 00 00 00 00       	mov    $0x0,%edx
  801a15:	b8 06 00 00 00       	mov    $0x6,%eax
  801a1a:	e8 61 ff ff ff       	call   801980 <fsipc>
}
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    

00801a21 <devfile_stat>:
{
  801a21:	f3 0f 1e fb          	endbr32 
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
  801a28:	53                   	push   %ebx
  801a29:	83 ec 04             	sub    $0x4,%esp
  801a2c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	8b 40 0c             	mov    0xc(%eax),%eax
  801a35:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a3a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a3f:	b8 05 00 00 00       	mov    $0x5,%eax
  801a44:	e8 37 ff ff ff       	call   801980 <fsipc>
  801a49:	85 c0                	test   %eax,%eax
  801a4b:	78 2c                	js     801a79 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a4d:	83 ec 08             	sub    $0x8,%esp
  801a50:	68 00 50 80 00       	push   $0x805000
  801a55:	53                   	push   %ebx
  801a56:	e8 f0 ee ff ff       	call   80094b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a5b:	a1 80 50 80 00       	mov    0x805080,%eax
  801a60:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a66:	a1 84 50 80 00       	mov    0x805084,%eax
  801a6b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a71:	83 c4 10             	add    $0x10,%esp
  801a74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a79:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <devfile_write>:
{
  801a7e:	f3 0f 1e fb          	endbr32 
  801a82:	55                   	push   %ebp
  801a83:	89 e5                	mov    %esp,%ebp
  801a85:	83 ec 0c             	sub    $0xc,%esp
  801a88:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a8b:	8b 55 08             	mov    0x8(%ebp),%edx
  801a8e:	8b 52 0c             	mov    0xc(%edx),%edx
  801a91:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801a97:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801a9c:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801aa1:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  801aa4:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801aa9:	50                   	push   %eax
  801aaa:	ff 75 0c             	pushl  0xc(%ebp)
  801aad:	68 08 50 80 00       	push   $0x805008
  801ab2:	e8 4a f0 ff ff       	call   800b01 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801ab7:	ba 00 00 00 00       	mov    $0x0,%edx
  801abc:	b8 04 00 00 00       	mov    $0x4,%eax
  801ac1:	e8 ba fe ff ff       	call   801980 <fsipc>
}
  801ac6:	c9                   	leave  
  801ac7:	c3                   	ret    

00801ac8 <devfile_read>:
{
  801ac8:	f3 0f 1e fb          	endbr32 
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
  801acf:	56                   	push   %esi
  801ad0:	53                   	push   %ebx
  801ad1:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad7:	8b 40 0c             	mov    0xc(%eax),%eax
  801ada:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801adf:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801ae5:	ba 00 00 00 00       	mov    $0x0,%edx
  801aea:	b8 03 00 00 00       	mov    $0x3,%eax
  801aef:	e8 8c fe ff ff       	call   801980 <fsipc>
  801af4:	89 c3                	mov    %eax,%ebx
  801af6:	85 c0                	test   %eax,%eax
  801af8:	78 1f                	js     801b19 <devfile_read+0x51>
	assert(r <= n);
  801afa:	39 f0                	cmp    %esi,%eax
  801afc:	77 24                	ja     801b22 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801afe:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b03:	7f 33                	jg     801b38 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b05:	83 ec 04             	sub    $0x4,%esp
  801b08:	50                   	push   %eax
  801b09:	68 00 50 80 00       	push   $0x805000
  801b0e:	ff 75 0c             	pushl  0xc(%ebp)
  801b11:	e8 eb ef ff ff       	call   800b01 <memmove>
	return r;
  801b16:	83 c4 10             	add    $0x10,%esp
}
  801b19:	89 d8                	mov    %ebx,%eax
  801b1b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b1e:	5b                   	pop    %ebx
  801b1f:	5e                   	pop    %esi
  801b20:	5d                   	pop    %ebp
  801b21:	c3                   	ret    
	assert(r <= n);
  801b22:	68 cc 29 80 00       	push   $0x8029cc
  801b27:	68 d3 29 80 00       	push   $0x8029d3
  801b2c:	6a 7c                	push   $0x7c
  801b2e:	68 e8 29 80 00       	push   $0x8029e8
  801b33:	e8 22 e7 ff ff       	call   80025a <_panic>
	assert(r <= PGSIZE);
  801b38:	68 f3 29 80 00       	push   $0x8029f3
  801b3d:	68 d3 29 80 00       	push   $0x8029d3
  801b42:	6a 7d                	push   $0x7d
  801b44:	68 e8 29 80 00       	push   $0x8029e8
  801b49:	e8 0c e7 ff ff       	call   80025a <_panic>

00801b4e <open>:
{
  801b4e:	f3 0f 1e fb          	endbr32 
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
  801b55:	56                   	push   %esi
  801b56:	53                   	push   %ebx
  801b57:	83 ec 1c             	sub    $0x1c,%esp
  801b5a:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b5d:	56                   	push   %esi
  801b5e:	e8 a5 ed ff ff       	call   800908 <strlen>
  801b63:	83 c4 10             	add    $0x10,%esp
  801b66:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b6b:	7f 6c                	jg     801bd9 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801b6d:	83 ec 0c             	sub    $0xc,%esp
  801b70:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b73:	50                   	push   %eax
  801b74:	e8 67 f8 ff ff       	call   8013e0 <fd_alloc>
  801b79:	89 c3                	mov    %eax,%ebx
  801b7b:	83 c4 10             	add    $0x10,%esp
  801b7e:	85 c0                	test   %eax,%eax
  801b80:	78 3c                	js     801bbe <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801b82:	83 ec 08             	sub    $0x8,%esp
  801b85:	56                   	push   %esi
  801b86:	68 00 50 80 00       	push   $0x805000
  801b8b:	e8 bb ed ff ff       	call   80094b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b90:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b93:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b9b:	b8 01 00 00 00       	mov    $0x1,%eax
  801ba0:	e8 db fd ff ff       	call   801980 <fsipc>
  801ba5:	89 c3                	mov    %eax,%ebx
  801ba7:	83 c4 10             	add    $0x10,%esp
  801baa:	85 c0                	test   %eax,%eax
  801bac:	78 19                	js     801bc7 <open+0x79>
	return fd2num(fd);
  801bae:	83 ec 0c             	sub    $0xc,%esp
  801bb1:	ff 75 f4             	pushl  -0xc(%ebp)
  801bb4:	e8 f8 f7 ff ff       	call   8013b1 <fd2num>
  801bb9:	89 c3                	mov    %eax,%ebx
  801bbb:	83 c4 10             	add    $0x10,%esp
}
  801bbe:	89 d8                	mov    %ebx,%eax
  801bc0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bc3:	5b                   	pop    %ebx
  801bc4:	5e                   	pop    %esi
  801bc5:	5d                   	pop    %ebp
  801bc6:	c3                   	ret    
		fd_close(fd, 0);
  801bc7:	83 ec 08             	sub    $0x8,%esp
  801bca:	6a 00                	push   $0x0
  801bcc:	ff 75 f4             	pushl  -0xc(%ebp)
  801bcf:	e8 10 f9 ff ff       	call   8014e4 <fd_close>
		return r;
  801bd4:	83 c4 10             	add    $0x10,%esp
  801bd7:	eb e5                	jmp    801bbe <open+0x70>
		return -E_BAD_PATH;
  801bd9:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801bde:	eb de                	jmp    801bbe <open+0x70>

00801be0 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801be0:	f3 0f 1e fb          	endbr32 
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
  801be7:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801bea:	ba 00 00 00 00       	mov    $0x0,%edx
  801bef:	b8 08 00 00 00       	mov    $0x8,%eax
  801bf4:	e8 87 fd ff ff       	call   801980 <fsipc>
}
  801bf9:	c9                   	leave  
  801bfa:	c3                   	ret    

00801bfb <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801bfb:	f3 0f 1e fb          	endbr32 
  801bff:	55                   	push   %ebp
  801c00:	89 e5                	mov    %esp,%ebp
  801c02:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c05:	89 c2                	mov    %eax,%edx
  801c07:	c1 ea 16             	shr    $0x16,%edx
  801c0a:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801c11:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801c16:	f6 c1 01             	test   $0x1,%cl
  801c19:	74 1c                	je     801c37 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801c1b:	c1 e8 0c             	shr    $0xc,%eax
  801c1e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801c25:	a8 01                	test   $0x1,%al
  801c27:	74 0e                	je     801c37 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801c29:	c1 e8 0c             	shr    $0xc,%eax
  801c2c:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801c33:	ef 
  801c34:	0f b7 d2             	movzwl %dx,%edx
}
  801c37:	89 d0                	mov    %edx,%eax
  801c39:	5d                   	pop    %ebp
  801c3a:	c3                   	ret    

00801c3b <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c3b:	f3 0f 1e fb          	endbr32 
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
  801c42:	56                   	push   %esi
  801c43:	53                   	push   %ebx
  801c44:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c47:	83 ec 0c             	sub    $0xc,%esp
  801c4a:	ff 75 08             	pushl  0x8(%ebp)
  801c4d:	e8 73 f7 ff ff       	call   8013c5 <fd2data>
  801c52:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c54:	83 c4 08             	add    $0x8,%esp
  801c57:	68 ff 29 80 00       	push   $0x8029ff
  801c5c:	53                   	push   %ebx
  801c5d:	e8 e9 ec ff ff       	call   80094b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c62:	8b 46 04             	mov    0x4(%esi),%eax
  801c65:	2b 06                	sub    (%esi),%eax
  801c67:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c6d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c74:	00 00 00 
	stat->st_dev = &devpipe;
  801c77:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801c7e:	30 80 00 
	return 0;
}
  801c81:	b8 00 00 00 00       	mov    $0x0,%eax
  801c86:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c89:	5b                   	pop    %ebx
  801c8a:	5e                   	pop    %esi
  801c8b:	5d                   	pop    %ebp
  801c8c:	c3                   	ret    

00801c8d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c8d:	f3 0f 1e fb          	endbr32 
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
  801c94:	53                   	push   %ebx
  801c95:	83 ec 0c             	sub    $0xc,%esp
  801c98:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c9b:	53                   	push   %ebx
  801c9c:	6a 00                	push   $0x0
  801c9e:	e8 77 f1 ff ff       	call   800e1a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ca3:	89 1c 24             	mov    %ebx,(%esp)
  801ca6:	e8 1a f7 ff ff       	call   8013c5 <fd2data>
  801cab:	83 c4 08             	add    $0x8,%esp
  801cae:	50                   	push   %eax
  801caf:	6a 00                	push   $0x0
  801cb1:	e8 64 f1 ff ff       	call   800e1a <sys_page_unmap>
}
  801cb6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cb9:	c9                   	leave  
  801cba:	c3                   	ret    

00801cbb <_pipeisclosed>:
{
  801cbb:	55                   	push   %ebp
  801cbc:	89 e5                	mov    %esp,%ebp
  801cbe:	57                   	push   %edi
  801cbf:	56                   	push   %esi
  801cc0:	53                   	push   %ebx
  801cc1:	83 ec 1c             	sub    $0x1c,%esp
  801cc4:	89 c7                	mov    %eax,%edi
  801cc6:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801cc8:	a1 04 40 80 00       	mov    0x804004,%eax
  801ccd:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801cd0:	83 ec 0c             	sub    $0xc,%esp
  801cd3:	57                   	push   %edi
  801cd4:	e8 22 ff ff ff       	call   801bfb <pageref>
  801cd9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cdc:	89 34 24             	mov    %esi,(%esp)
  801cdf:	e8 17 ff ff ff       	call   801bfb <pageref>
		nn = thisenv->env_runs;
  801ce4:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801cea:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801ced:	83 c4 10             	add    $0x10,%esp
  801cf0:	39 cb                	cmp    %ecx,%ebx
  801cf2:	74 1b                	je     801d0f <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801cf4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cf7:	75 cf                	jne    801cc8 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801cf9:	8b 42 58             	mov    0x58(%edx),%eax
  801cfc:	6a 01                	push   $0x1
  801cfe:	50                   	push   %eax
  801cff:	53                   	push   %ebx
  801d00:	68 06 2a 80 00       	push   $0x802a06
  801d05:	e8 37 e6 ff ff       	call   800341 <cprintf>
  801d0a:	83 c4 10             	add    $0x10,%esp
  801d0d:	eb b9                	jmp    801cc8 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d0f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d12:	0f 94 c0             	sete   %al
  801d15:	0f b6 c0             	movzbl %al,%eax
}
  801d18:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d1b:	5b                   	pop    %ebx
  801d1c:	5e                   	pop    %esi
  801d1d:	5f                   	pop    %edi
  801d1e:	5d                   	pop    %ebp
  801d1f:	c3                   	ret    

00801d20 <devpipe_write>:
{
  801d20:	f3 0f 1e fb          	endbr32 
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
  801d27:	57                   	push   %edi
  801d28:	56                   	push   %esi
  801d29:	53                   	push   %ebx
  801d2a:	83 ec 28             	sub    $0x28,%esp
  801d2d:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d30:	56                   	push   %esi
  801d31:	e8 8f f6 ff ff       	call   8013c5 <fd2data>
  801d36:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d38:	83 c4 10             	add    $0x10,%esp
  801d3b:	bf 00 00 00 00       	mov    $0x0,%edi
  801d40:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d43:	74 4f                	je     801d94 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d45:	8b 43 04             	mov    0x4(%ebx),%eax
  801d48:	8b 0b                	mov    (%ebx),%ecx
  801d4a:	8d 51 20             	lea    0x20(%ecx),%edx
  801d4d:	39 d0                	cmp    %edx,%eax
  801d4f:	72 14                	jb     801d65 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801d51:	89 da                	mov    %ebx,%edx
  801d53:	89 f0                	mov    %esi,%eax
  801d55:	e8 61 ff ff ff       	call   801cbb <_pipeisclosed>
  801d5a:	85 c0                	test   %eax,%eax
  801d5c:	75 3b                	jne    801d99 <devpipe_write+0x79>
			sys_yield();
  801d5e:	e8 07 f0 ff ff       	call   800d6a <sys_yield>
  801d63:	eb e0                	jmp    801d45 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d68:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d6c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d6f:	89 c2                	mov    %eax,%edx
  801d71:	c1 fa 1f             	sar    $0x1f,%edx
  801d74:	89 d1                	mov    %edx,%ecx
  801d76:	c1 e9 1b             	shr    $0x1b,%ecx
  801d79:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d7c:	83 e2 1f             	and    $0x1f,%edx
  801d7f:	29 ca                	sub    %ecx,%edx
  801d81:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d85:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d89:	83 c0 01             	add    $0x1,%eax
  801d8c:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d8f:	83 c7 01             	add    $0x1,%edi
  801d92:	eb ac                	jmp    801d40 <devpipe_write+0x20>
	return i;
  801d94:	8b 45 10             	mov    0x10(%ebp),%eax
  801d97:	eb 05                	jmp    801d9e <devpipe_write+0x7e>
				return 0;
  801d99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801da1:	5b                   	pop    %ebx
  801da2:	5e                   	pop    %esi
  801da3:	5f                   	pop    %edi
  801da4:	5d                   	pop    %ebp
  801da5:	c3                   	ret    

00801da6 <devpipe_read>:
{
  801da6:	f3 0f 1e fb          	endbr32 
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
  801dad:	57                   	push   %edi
  801dae:	56                   	push   %esi
  801daf:	53                   	push   %ebx
  801db0:	83 ec 18             	sub    $0x18,%esp
  801db3:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801db6:	57                   	push   %edi
  801db7:	e8 09 f6 ff ff       	call   8013c5 <fd2data>
  801dbc:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dbe:	83 c4 10             	add    $0x10,%esp
  801dc1:	be 00 00 00 00       	mov    $0x0,%esi
  801dc6:	3b 75 10             	cmp    0x10(%ebp),%esi
  801dc9:	75 14                	jne    801ddf <devpipe_read+0x39>
	return i;
  801dcb:	8b 45 10             	mov    0x10(%ebp),%eax
  801dce:	eb 02                	jmp    801dd2 <devpipe_read+0x2c>
				return i;
  801dd0:	89 f0                	mov    %esi,%eax
}
  801dd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dd5:	5b                   	pop    %ebx
  801dd6:	5e                   	pop    %esi
  801dd7:	5f                   	pop    %edi
  801dd8:	5d                   	pop    %ebp
  801dd9:	c3                   	ret    
			sys_yield();
  801dda:	e8 8b ef ff ff       	call   800d6a <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801ddf:	8b 03                	mov    (%ebx),%eax
  801de1:	3b 43 04             	cmp    0x4(%ebx),%eax
  801de4:	75 18                	jne    801dfe <devpipe_read+0x58>
			if (i > 0)
  801de6:	85 f6                	test   %esi,%esi
  801de8:	75 e6                	jne    801dd0 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801dea:	89 da                	mov    %ebx,%edx
  801dec:	89 f8                	mov    %edi,%eax
  801dee:	e8 c8 fe ff ff       	call   801cbb <_pipeisclosed>
  801df3:	85 c0                	test   %eax,%eax
  801df5:	74 e3                	je     801dda <devpipe_read+0x34>
				return 0;
  801df7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dfc:	eb d4                	jmp    801dd2 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801dfe:	99                   	cltd   
  801dff:	c1 ea 1b             	shr    $0x1b,%edx
  801e02:	01 d0                	add    %edx,%eax
  801e04:	83 e0 1f             	and    $0x1f,%eax
  801e07:	29 d0                	sub    %edx,%eax
  801e09:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e11:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e14:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e17:	83 c6 01             	add    $0x1,%esi
  801e1a:	eb aa                	jmp    801dc6 <devpipe_read+0x20>

00801e1c <pipe>:
{
  801e1c:	f3 0f 1e fb          	endbr32 
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
  801e23:	56                   	push   %esi
  801e24:	53                   	push   %ebx
  801e25:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e28:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e2b:	50                   	push   %eax
  801e2c:	e8 af f5 ff ff       	call   8013e0 <fd_alloc>
  801e31:	89 c3                	mov    %eax,%ebx
  801e33:	83 c4 10             	add    $0x10,%esp
  801e36:	85 c0                	test   %eax,%eax
  801e38:	0f 88 23 01 00 00    	js     801f61 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e3e:	83 ec 04             	sub    $0x4,%esp
  801e41:	68 07 04 00 00       	push   $0x407
  801e46:	ff 75 f4             	pushl  -0xc(%ebp)
  801e49:	6a 00                	push   $0x0
  801e4b:	e8 3d ef ff ff       	call   800d8d <sys_page_alloc>
  801e50:	89 c3                	mov    %eax,%ebx
  801e52:	83 c4 10             	add    $0x10,%esp
  801e55:	85 c0                	test   %eax,%eax
  801e57:	0f 88 04 01 00 00    	js     801f61 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801e5d:	83 ec 0c             	sub    $0xc,%esp
  801e60:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e63:	50                   	push   %eax
  801e64:	e8 77 f5 ff ff       	call   8013e0 <fd_alloc>
  801e69:	89 c3                	mov    %eax,%ebx
  801e6b:	83 c4 10             	add    $0x10,%esp
  801e6e:	85 c0                	test   %eax,%eax
  801e70:	0f 88 db 00 00 00    	js     801f51 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e76:	83 ec 04             	sub    $0x4,%esp
  801e79:	68 07 04 00 00       	push   $0x407
  801e7e:	ff 75 f0             	pushl  -0x10(%ebp)
  801e81:	6a 00                	push   $0x0
  801e83:	e8 05 ef ff ff       	call   800d8d <sys_page_alloc>
  801e88:	89 c3                	mov    %eax,%ebx
  801e8a:	83 c4 10             	add    $0x10,%esp
  801e8d:	85 c0                	test   %eax,%eax
  801e8f:	0f 88 bc 00 00 00    	js     801f51 <pipe+0x135>
	va = fd2data(fd0);
  801e95:	83 ec 0c             	sub    $0xc,%esp
  801e98:	ff 75 f4             	pushl  -0xc(%ebp)
  801e9b:	e8 25 f5 ff ff       	call   8013c5 <fd2data>
  801ea0:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ea2:	83 c4 0c             	add    $0xc,%esp
  801ea5:	68 07 04 00 00       	push   $0x407
  801eaa:	50                   	push   %eax
  801eab:	6a 00                	push   $0x0
  801ead:	e8 db ee ff ff       	call   800d8d <sys_page_alloc>
  801eb2:	89 c3                	mov    %eax,%ebx
  801eb4:	83 c4 10             	add    $0x10,%esp
  801eb7:	85 c0                	test   %eax,%eax
  801eb9:	0f 88 82 00 00 00    	js     801f41 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ebf:	83 ec 0c             	sub    $0xc,%esp
  801ec2:	ff 75 f0             	pushl  -0x10(%ebp)
  801ec5:	e8 fb f4 ff ff       	call   8013c5 <fd2data>
  801eca:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ed1:	50                   	push   %eax
  801ed2:	6a 00                	push   $0x0
  801ed4:	56                   	push   %esi
  801ed5:	6a 00                	push   $0x0
  801ed7:	e8 f8 ee ff ff       	call   800dd4 <sys_page_map>
  801edc:	89 c3                	mov    %eax,%ebx
  801ede:	83 c4 20             	add    $0x20,%esp
  801ee1:	85 c0                	test   %eax,%eax
  801ee3:	78 4e                	js     801f33 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801ee5:	a1 20 30 80 00       	mov    0x803020,%eax
  801eea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eed:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801eef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801ef9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801efc:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801efe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f01:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f08:	83 ec 0c             	sub    $0xc,%esp
  801f0b:	ff 75 f4             	pushl  -0xc(%ebp)
  801f0e:	e8 9e f4 ff ff       	call   8013b1 <fd2num>
  801f13:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f16:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f18:	83 c4 04             	add    $0x4,%esp
  801f1b:	ff 75 f0             	pushl  -0x10(%ebp)
  801f1e:	e8 8e f4 ff ff       	call   8013b1 <fd2num>
  801f23:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f26:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f29:	83 c4 10             	add    $0x10,%esp
  801f2c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f31:	eb 2e                	jmp    801f61 <pipe+0x145>
	sys_page_unmap(0, va);
  801f33:	83 ec 08             	sub    $0x8,%esp
  801f36:	56                   	push   %esi
  801f37:	6a 00                	push   $0x0
  801f39:	e8 dc ee ff ff       	call   800e1a <sys_page_unmap>
  801f3e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f41:	83 ec 08             	sub    $0x8,%esp
  801f44:	ff 75 f0             	pushl  -0x10(%ebp)
  801f47:	6a 00                	push   $0x0
  801f49:	e8 cc ee ff ff       	call   800e1a <sys_page_unmap>
  801f4e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f51:	83 ec 08             	sub    $0x8,%esp
  801f54:	ff 75 f4             	pushl  -0xc(%ebp)
  801f57:	6a 00                	push   $0x0
  801f59:	e8 bc ee ff ff       	call   800e1a <sys_page_unmap>
  801f5e:	83 c4 10             	add    $0x10,%esp
}
  801f61:	89 d8                	mov    %ebx,%eax
  801f63:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f66:	5b                   	pop    %ebx
  801f67:	5e                   	pop    %esi
  801f68:	5d                   	pop    %ebp
  801f69:	c3                   	ret    

00801f6a <pipeisclosed>:
{
  801f6a:	f3 0f 1e fb          	endbr32 
  801f6e:	55                   	push   %ebp
  801f6f:	89 e5                	mov    %esp,%ebp
  801f71:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f74:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f77:	50                   	push   %eax
  801f78:	ff 75 08             	pushl  0x8(%ebp)
  801f7b:	e8 b6 f4 ff ff       	call   801436 <fd_lookup>
  801f80:	83 c4 10             	add    $0x10,%esp
  801f83:	85 c0                	test   %eax,%eax
  801f85:	78 18                	js     801f9f <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801f87:	83 ec 0c             	sub    $0xc,%esp
  801f8a:	ff 75 f4             	pushl  -0xc(%ebp)
  801f8d:	e8 33 f4 ff ff       	call   8013c5 <fd2data>
  801f92:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f97:	e8 1f fd ff ff       	call   801cbb <_pipeisclosed>
  801f9c:	83 c4 10             	add    $0x10,%esp
}
  801f9f:	c9                   	leave  
  801fa0:	c3                   	ret    

00801fa1 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801fa1:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801fa5:	b8 00 00 00 00       	mov    $0x0,%eax
  801faa:	c3                   	ret    

00801fab <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801fab:	f3 0f 1e fb          	endbr32 
  801faf:	55                   	push   %ebp
  801fb0:	89 e5                	mov    %esp,%ebp
  801fb2:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801fb5:	68 1e 2a 80 00       	push   $0x802a1e
  801fba:	ff 75 0c             	pushl  0xc(%ebp)
  801fbd:	e8 89 e9 ff ff       	call   80094b <strcpy>
	return 0;
}
  801fc2:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    

00801fc9 <devcons_write>:
{
  801fc9:	f3 0f 1e fb          	endbr32 
  801fcd:	55                   	push   %ebp
  801fce:	89 e5                	mov    %esp,%ebp
  801fd0:	57                   	push   %edi
  801fd1:	56                   	push   %esi
  801fd2:	53                   	push   %ebx
  801fd3:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fd9:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fde:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801fe4:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fe7:	73 31                	jae    80201a <devcons_write+0x51>
		m = n - tot;
  801fe9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801fec:	29 f3                	sub    %esi,%ebx
  801fee:	83 fb 7f             	cmp    $0x7f,%ebx
  801ff1:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801ff6:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801ff9:	83 ec 04             	sub    $0x4,%esp
  801ffc:	53                   	push   %ebx
  801ffd:	89 f0                	mov    %esi,%eax
  801fff:	03 45 0c             	add    0xc(%ebp),%eax
  802002:	50                   	push   %eax
  802003:	57                   	push   %edi
  802004:	e8 f8 ea ff ff       	call   800b01 <memmove>
		sys_cputs(buf, m);
  802009:	83 c4 08             	add    $0x8,%esp
  80200c:	53                   	push   %ebx
  80200d:	57                   	push   %edi
  80200e:	e8 aa ec ff ff       	call   800cbd <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802013:	01 de                	add    %ebx,%esi
  802015:	83 c4 10             	add    $0x10,%esp
  802018:	eb ca                	jmp    801fe4 <devcons_write+0x1b>
}
  80201a:	89 f0                	mov    %esi,%eax
  80201c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80201f:	5b                   	pop    %ebx
  802020:	5e                   	pop    %esi
  802021:	5f                   	pop    %edi
  802022:	5d                   	pop    %ebp
  802023:	c3                   	ret    

00802024 <devcons_read>:
{
  802024:	f3 0f 1e fb          	endbr32 
  802028:	55                   	push   %ebp
  802029:	89 e5                	mov    %esp,%ebp
  80202b:	83 ec 08             	sub    $0x8,%esp
  80202e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802033:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802037:	74 21                	je     80205a <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802039:	e8 a1 ec ff ff       	call   800cdf <sys_cgetc>
  80203e:	85 c0                	test   %eax,%eax
  802040:	75 07                	jne    802049 <devcons_read+0x25>
		sys_yield();
  802042:	e8 23 ed ff ff       	call   800d6a <sys_yield>
  802047:	eb f0                	jmp    802039 <devcons_read+0x15>
	if (c < 0)
  802049:	78 0f                	js     80205a <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  80204b:	83 f8 04             	cmp    $0x4,%eax
  80204e:	74 0c                	je     80205c <devcons_read+0x38>
	*(char*)vbuf = c;
  802050:	8b 55 0c             	mov    0xc(%ebp),%edx
  802053:	88 02                	mov    %al,(%edx)
	return 1;
  802055:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80205a:	c9                   	leave  
  80205b:	c3                   	ret    
		return 0;
  80205c:	b8 00 00 00 00       	mov    $0x0,%eax
  802061:	eb f7                	jmp    80205a <devcons_read+0x36>

00802063 <cputchar>:
{
  802063:	f3 0f 1e fb          	endbr32 
  802067:	55                   	push   %ebp
  802068:	89 e5                	mov    %esp,%ebp
  80206a:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80206d:	8b 45 08             	mov    0x8(%ebp),%eax
  802070:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802073:	6a 01                	push   $0x1
  802075:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802078:	50                   	push   %eax
  802079:	e8 3f ec ff ff       	call   800cbd <sys_cputs>
}
  80207e:	83 c4 10             	add    $0x10,%esp
  802081:	c9                   	leave  
  802082:	c3                   	ret    

00802083 <getchar>:
{
  802083:	f3 0f 1e fb          	endbr32 
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
  80208a:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80208d:	6a 01                	push   $0x1
  80208f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802092:	50                   	push   %eax
  802093:	6a 00                	push   $0x0
  802095:	e8 1f f6 ff ff       	call   8016b9 <read>
	if (r < 0)
  80209a:	83 c4 10             	add    $0x10,%esp
  80209d:	85 c0                	test   %eax,%eax
  80209f:	78 06                	js     8020a7 <getchar+0x24>
	if (r < 1)
  8020a1:	74 06                	je     8020a9 <getchar+0x26>
	return c;
  8020a3:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020a7:	c9                   	leave  
  8020a8:	c3                   	ret    
		return -E_EOF;
  8020a9:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020ae:	eb f7                	jmp    8020a7 <getchar+0x24>

008020b0 <iscons>:
{
  8020b0:	f3 0f 1e fb          	endbr32 
  8020b4:	55                   	push   %ebp
  8020b5:	89 e5                	mov    %esp,%ebp
  8020b7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020bd:	50                   	push   %eax
  8020be:	ff 75 08             	pushl  0x8(%ebp)
  8020c1:	e8 70 f3 ff ff       	call   801436 <fd_lookup>
  8020c6:	83 c4 10             	add    $0x10,%esp
  8020c9:	85 c0                	test   %eax,%eax
  8020cb:	78 11                	js     8020de <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8020cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d0:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020d6:	39 10                	cmp    %edx,(%eax)
  8020d8:	0f 94 c0             	sete   %al
  8020db:	0f b6 c0             	movzbl %al,%eax
}
  8020de:	c9                   	leave  
  8020df:	c3                   	ret    

008020e0 <opencons>:
{
  8020e0:	f3 0f 1e fb          	endbr32 
  8020e4:	55                   	push   %ebp
  8020e5:	89 e5                	mov    %esp,%ebp
  8020e7:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020ed:	50                   	push   %eax
  8020ee:	e8 ed f2 ff ff       	call   8013e0 <fd_alloc>
  8020f3:	83 c4 10             	add    $0x10,%esp
  8020f6:	85 c0                	test   %eax,%eax
  8020f8:	78 3a                	js     802134 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020fa:	83 ec 04             	sub    $0x4,%esp
  8020fd:	68 07 04 00 00       	push   $0x407
  802102:	ff 75 f4             	pushl  -0xc(%ebp)
  802105:	6a 00                	push   $0x0
  802107:	e8 81 ec ff ff       	call   800d8d <sys_page_alloc>
  80210c:	83 c4 10             	add    $0x10,%esp
  80210f:	85 c0                	test   %eax,%eax
  802111:	78 21                	js     802134 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802116:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80211c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80211e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802121:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802128:	83 ec 0c             	sub    $0xc,%esp
  80212b:	50                   	push   %eax
  80212c:	e8 80 f2 ff ff       	call   8013b1 <fd2num>
  802131:	83 c4 10             	add    $0x10,%esp
}
  802134:	c9                   	leave  
  802135:	c3                   	ret    

00802136 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802136:	f3 0f 1e fb          	endbr32 
  80213a:	55                   	push   %ebp
  80213b:	89 e5                	mov    %esp,%ebp
  80213d:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802140:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  802147:	74 0a                	je     802153 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802149:	8b 45 08             	mov    0x8(%ebp),%eax
  80214c:	a3 00 60 80 00       	mov    %eax,0x806000
}
  802151:	c9                   	leave  
  802152:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  802153:	83 ec 04             	sub    $0x4,%esp
  802156:	6a 07                	push   $0x7
  802158:	68 00 f0 bf ee       	push   $0xeebff000
  80215d:	6a 00                	push   $0x0
  80215f:	e8 29 ec ff ff       	call   800d8d <sys_page_alloc>
  802164:	83 c4 10             	add    $0x10,%esp
  802167:	85 c0                	test   %eax,%eax
  802169:	78 2a                	js     802195 <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  80216b:	83 ec 08             	sub    $0x8,%esp
  80216e:	68 a9 21 80 00       	push   $0x8021a9
  802173:	6a 00                	push   $0x0
  802175:	e8 72 ed ff ff       	call   800eec <sys_env_set_pgfault_upcall>
  80217a:	83 c4 10             	add    $0x10,%esp
  80217d:	85 c0                	test   %eax,%eax
  80217f:	79 c8                	jns    802149 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  802181:	83 ec 04             	sub    $0x4,%esp
  802184:	68 58 2a 80 00       	push   $0x802a58
  802189:	6a 25                	push   $0x25
  80218b:	68 90 2a 80 00       	push   $0x802a90
  802190:	e8 c5 e0 ff ff       	call   80025a <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  802195:	83 ec 04             	sub    $0x4,%esp
  802198:	68 2c 2a 80 00       	push   $0x802a2c
  80219d:	6a 22                	push   $0x22
  80219f:	68 90 2a 80 00       	push   $0x802a90
  8021a4:	e8 b1 e0 ff ff       	call   80025a <_panic>

008021a9 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8021a9:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8021aa:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  8021af:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8021b1:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  8021b4:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  8021b8:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  8021bc:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8021bf:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  8021c1:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  8021c5:	83 c4 08             	add    $0x8,%esp
	popal
  8021c8:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  8021c9:	83 c4 04             	add    $0x4,%esp
	popfl
  8021cc:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  8021cd:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  8021ce:	c3                   	ret    
  8021cf:	90                   	nop

008021d0 <__udivdi3>:
  8021d0:	f3 0f 1e fb          	endbr32 
  8021d4:	55                   	push   %ebp
  8021d5:	57                   	push   %edi
  8021d6:	56                   	push   %esi
  8021d7:	53                   	push   %ebx
  8021d8:	83 ec 1c             	sub    $0x1c,%esp
  8021db:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8021df:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8021e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021e7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8021eb:	85 d2                	test   %edx,%edx
  8021ed:	75 19                	jne    802208 <__udivdi3+0x38>
  8021ef:	39 f3                	cmp    %esi,%ebx
  8021f1:	76 4d                	jbe    802240 <__udivdi3+0x70>
  8021f3:	31 ff                	xor    %edi,%edi
  8021f5:	89 e8                	mov    %ebp,%eax
  8021f7:	89 f2                	mov    %esi,%edx
  8021f9:	f7 f3                	div    %ebx
  8021fb:	89 fa                	mov    %edi,%edx
  8021fd:	83 c4 1c             	add    $0x1c,%esp
  802200:	5b                   	pop    %ebx
  802201:	5e                   	pop    %esi
  802202:	5f                   	pop    %edi
  802203:	5d                   	pop    %ebp
  802204:	c3                   	ret    
  802205:	8d 76 00             	lea    0x0(%esi),%esi
  802208:	39 f2                	cmp    %esi,%edx
  80220a:	76 14                	jbe    802220 <__udivdi3+0x50>
  80220c:	31 ff                	xor    %edi,%edi
  80220e:	31 c0                	xor    %eax,%eax
  802210:	89 fa                	mov    %edi,%edx
  802212:	83 c4 1c             	add    $0x1c,%esp
  802215:	5b                   	pop    %ebx
  802216:	5e                   	pop    %esi
  802217:	5f                   	pop    %edi
  802218:	5d                   	pop    %ebp
  802219:	c3                   	ret    
  80221a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802220:	0f bd fa             	bsr    %edx,%edi
  802223:	83 f7 1f             	xor    $0x1f,%edi
  802226:	75 48                	jne    802270 <__udivdi3+0xa0>
  802228:	39 f2                	cmp    %esi,%edx
  80222a:	72 06                	jb     802232 <__udivdi3+0x62>
  80222c:	31 c0                	xor    %eax,%eax
  80222e:	39 eb                	cmp    %ebp,%ebx
  802230:	77 de                	ja     802210 <__udivdi3+0x40>
  802232:	b8 01 00 00 00       	mov    $0x1,%eax
  802237:	eb d7                	jmp    802210 <__udivdi3+0x40>
  802239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802240:	89 d9                	mov    %ebx,%ecx
  802242:	85 db                	test   %ebx,%ebx
  802244:	75 0b                	jne    802251 <__udivdi3+0x81>
  802246:	b8 01 00 00 00       	mov    $0x1,%eax
  80224b:	31 d2                	xor    %edx,%edx
  80224d:	f7 f3                	div    %ebx
  80224f:	89 c1                	mov    %eax,%ecx
  802251:	31 d2                	xor    %edx,%edx
  802253:	89 f0                	mov    %esi,%eax
  802255:	f7 f1                	div    %ecx
  802257:	89 c6                	mov    %eax,%esi
  802259:	89 e8                	mov    %ebp,%eax
  80225b:	89 f7                	mov    %esi,%edi
  80225d:	f7 f1                	div    %ecx
  80225f:	89 fa                	mov    %edi,%edx
  802261:	83 c4 1c             	add    $0x1c,%esp
  802264:	5b                   	pop    %ebx
  802265:	5e                   	pop    %esi
  802266:	5f                   	pop    %edi
  802267:	5d                   	pop    %ebp
  802268:	c3                   	ret    
  802269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802270:	89 f9                	mov    %edi,%ecx
  802272:	b8 20 00 00 00       	mov    $0x20,%eax
  802277:	29 f8                	sub    %edi,%eax
  802279:	d3 e2                	shl    %cl,%edx
  80227b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80227f:	89 c1                	mov    %eax,%ecx
  802281:	89 da                	mov    %ebx,%edx
  802283:	d3 ea                	shr    %cl,%edx
  802285:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802289:	09 d1                	or     %edx,%ecx
  80228b:	89 f2                	mov    %esi,%edx
  80228d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802291:	89 f9                	mov    %edi,%ecx
  802293:	d3 e3                	shl    %cl,%ebx
  802295:	89 c1                	mov    %eax,%ecx
  802297:	d3 ea                	shr    %cl,%edx
  802299:	89 f9                	mov    %edi,%ecx
  80229b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80229f:	89 eb                	mov    %ebp,%ebx
  8022a1:	d3 e6                	shl    %cl,%esi
  8022a3:	89 c1                	mov    %eax,%ecx
  8022a5:	d3 eb                	shr    %cl,%ebx
  8022a7:	09 de                	or     %ebx,%esi
  8022a9:	89 f0                	mov    %esi,%eax
  8022ab:	f7 74 24 08          	divl   0x8(%esp)
  8022af:	89 d6                	mov    %edx,%esi
  8022b1:	89 c3                	mov    %eax,%ebx
  8022b3:	f7 64 24 0c          	mull   0xc(%esp)
  8022b7:	39 d6                	cmp    %edx,%esi
  8022b9:	72 15                	jb     8022d0 <__udivdi3+0x100>
  8022bb:	89 f9                	mov    %edi,%ecx
  8022bd:	d3 e5                	shl    %cl,%ebp
  8022bf:	39 c5                	cmp    %eax,%ebp
  8022c1:	73 04                	jae    8022c7 <__udivdi3+0xf7>
  8022c3:	39 d6                	cmp    %edx,%esi
  8022c5:	74 09                	je     8022d0 <__udivdi3+0x100>
  8022c7:	89 d8                	mov    %ebx,%eax
  8022c9:	31 ff                	xor    %edi,%edi
  8022cb:	e9 40 ff ff ff       	jmp    802210 <__udivdi3+0x40>
  8022d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8022d3:	31 ff                	xor    %edi,%edi
  8022d5:	e9 36 ff ff ff       	jmp    802210 <__udivdi3+0x40>
  8022da:	66 90                	xchg   %ax,%ax
  8022dc:	66 90                	xchg   %ax,%ax
  8022de:	66 90                	xchg   %ax,%ax

008022e0 <__umoddi3>:
  8022e0:	f3 0f 1e fb          	endbr32 
  8022e4:	55                   	push   %ebp
  8022e5:	57                   	push   %edi
  8022e6:	56                   	push   %esi
  8022e7:	53                   	push   %ebx
  8022e8:	83 ec 1c             	sub    $0x1c,%esp
  8022eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8022ef:	8b 74 24 30          	mov    0x30(%esp),%esi
  8022f3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8022f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022fb:	85 c0                	test   %eax,%eax
  8022fd:	75 19                	jne    802318 <__umoddi3+0x38>
  8022ff:	39 df                	cmp    %ebx,%edi
  802301:	76 5d                	jbe    802360 <__umoddi3+0x80>
  802303:	89 f0                	mov    %esi,%eax
  802305:	89 da                	mov    %ebx,%edx
  802307:	f7 f7                	div    %edi
  802309:	89 d0                	mov    %edx,%eax
  80230b:	31 d2                	xor    %edx,%edx
  80230d:	83 c4 1c             	add    $0x1c,%esp
  802310:	5b                   	pop    %ebx
  802311:	5e                   	pop    %esi
  802312:	5f                   	pop    %edi
  802313:	5d                   	pop    %ebp
  802314:	c3                   	ret    
  802315:	8d 76 00             	lea    0x0(%esi),%esi
  802318:	89 f2                	mov    %esi,%edx
  80231a:	39 d8                	cmp    %ebx,%eax
  80231c:	76 12                	jbe    802330 <__umoddi3+0x50>
  80231e:	89 f0                	mov    %esi,%eax
  802320:	89 da                	mov    %ebx,%edx
  802322:	83 c4 1c             	add    $0x1c,%esp
  802325:	5b                   	pop    %ebx
  802326:	5e                   	pop    %esi
  802327:	5f                   	pop    %edi
  802328:	5d                   	pop    %ebp
  802329:	c3                   	ret    
  80232a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802330:	0f bd e8             	bsr    %eax,%ebp
  802333:	83 f5 1f             	xor    $0x1f,%ebp
  802336:	75 50                	jne    802388 <__umoddi3+0xa8>
  802338:	39 d8                	cmp    %ebx,%eax
  80233a:	0f 82 e0 00 00 00    	jb     802420 <__umoddi3+0x140>
  802340:	89 d9                	mov    %ebx,%ecx
  802342:	39 f7                	cmp    %esi,%edi
  802344:	0f 86 d6 00 00 00    	jbe    802420 <__umoddi3+0x140>
  80234a:	89 d0                	mov    %edx,%eax
  80234c:	89 ca                	mov    %ecx,%edx
  80234e:	83 c4 1c             	add    $0x1c,%esp
  802351:	5b                   	pop    %ebx
  802352:	5e                   	pop    %esi
  802353:	5f                   	pop    %edi
  802354:	5d                   	pop    %ebp
  802355:	c3                   	ret    
  802356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80235d:	8d 76 00             	lea    0x0(%esi),%esi
  802360:	89 fd                	mov    %edi,%ebp
  802362:	85 ff                	test   %edi,%edi
  802364:	75 0b                	jne    802371 <__umoddi3+0x91>
  802366:	b8 01 00 00 00       	mov    $0x1,%eax
  80236b:	31 d2                	xor    %edx,%edx
  80236d:	f7 f7                	div    %edi
  80236f:	89 c5                	mov    %eax,%ebp
  802371:	89 d8                	mov    %ebx,%eax
  802373:	31 d2                	xor    %edx,%edx
  802375:	f7 f5                	div    %ebp
  802377:	89 f0                	mov    %esi,%eax
  802379:	f7 f5                	div    %ebp
  80237b:	89 d0                	mov    %edx,%eax
  80237d:	31 d2                	xor    %edx,%edx
  80237f:	eb 8c                	jmp    80230d <__umoddi3+0x2d>
  802381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802388:	89 e9                	mov    %ebp,%ecx
  80238a:	ba 20 00 00 00       	mov    $0x20,%edx
  80238f:	29 ea                	sub    %ebp,%edx
  802391:	d3 e0                	shl    %cl,%eax
  802393:	89 44 24 08          	mov    %eax,0x8(%esp)
  802397:	89 d1                	mov    %edx,%ecx
  802399:	89 f8                	mov    %edi,%eax
  80239b:	d3 e8                	shr    %cl,%eax
  80239d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8023a5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8023a9:	09 c1                	or     %eax,%ecx
  8023ab:	89 d8                	mov    %ebx,%eax
  8023ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023b1:	89 e9                	mov    %ebp,%ecx
  8023b3:	d3 e7                	shl    %cl,%edi
  8023b5:	89 d1                	mov    %edx,%ecx
  8023b7:	d3 e8                	shr    %cl,%eax
  8023b9:	89 e9                	mov    %ebp,%ecx
  8023bb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023bf:	d3 e3                	shl    %cl,%ebx
  8023c1:	89 c7                	mov    %eax,%edi
  8023c3:	89 d1                	mov    %edx,%ecx
  8023c5:	89 f0                	mov    %esi,%eax
  8023c7:	d3 e8                	shr    %cl,%eax
  8023c9:	89 e9                	mov    %ebp,%ecx
  8023cb:	89 fa                	mov    %edi,%edx
  8023cd:	d3 e6                	shl    %cl,%esi
  8023cf:	09 d8                	or     %ebx,%eax
  8023d1:	f7 74 24 08          	divl   0x8(%esp)
  8023d5:	89 d1                	mov    %edx,%ecx
  8023d7:	89 f3                	mov    %esi,%ebx
  8023d9:	f7 64 24 0c          	mull   0xc(%esp)
  8023dd:	89 c6                	mov    %eax,%esi
  8023df:	89 d7                	mov    %edx,%edi
  8023e1:	39 d1                	cmp    %edx,%ecx
  8023e3:	72 06                	jb     8023eb <__umoddi3+0x10b>
  8023e5:	75 10                	jne    8023f7 <__umoddi3+0x117>
  8023e7:	39 c3                	cmp    %eax,%ebx
  8023e9:	73 0c                	jae    8023f7 <__umoddi3+0x117>
  8023eb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8023ef:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8023f3:	89 d7                	mov    %edx,%edi
  8023f5:	89 c6                	mov    %eax,%esi
  8023f7:	89 ca                	mov    %ecx,%edx
  8023f9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8023fe:	29 f3                	sub    %esi,%ebx
  802400:	19 fa                	sbb    %edi,%edx
  802402:	89 d0                	mov    %edx,%eax
  802404:	d3 e0                	shl    %cl,%eax
  802406:	89 e9                	mov    %ebp,%ecx
  802408:	d3 eb                	shr    %cl,%ebx
  80240a:	d3 ea                	shr    %cl,%edx
  80240c:	09 d8                	or     %ebx,%eax
  80240e:	83 c4 1c             	add    $0x1c,%esp
  802411:	5b                   	pop    %ebx
  802412:	5e                   	pop    %esi
  802413:	5f                   	pop    %edi
  802414:	5d                   	pop    %ebp
  802415:	c3                   	ret    
  802416:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80241d:	8d 76 00             	lea    0x0(%esi),%esi
  802420:	29 fe                	sub    %edi,%esi
  802422:	19 c3                	sbb    %eax,%ebx
  802424:	89 f2                	mov    %esi,%edx
  802426:	89 d9                	mov    %ebx,%ecx
  802428:	e9 1d ff ff ff       	jmp    80234a <__umoddi3+0x6a>
