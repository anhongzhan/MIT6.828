
obj/user/testfdsharing.debug:     file format elf32-i386


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
  80002c:	e8 9d 01 00 00       	call   8001ce <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char buf[512], buf2[512];

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	57                   	push   %edi
  80003b:	56                   	push   %esi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 14             	sub    $0x14,%esp
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  800040:	6a 00                	push   $0x0
  800042:	68 e0 29 80 00       	push   $0x8029e0
  800047:	e8 78 1a 00 00       	call   801ac4 <open>
  80004c:	89 c3                	mov    %eax,%ebx
  80004e:	83 c4 10             	add    $0x10,%esp
  800051:	85 c0                	test   %eax,%eax
  800053:	0f 88 ff 00 00 00    	js     800158 <umain+0x125>
		panic("open motd: %e", fd);
	seek(fd, 0);
  800059:	83 ec 08             	sub    $0x8,%esp
  80005c:	6a 00                	push   $0x0
  80005e:	50                   	push   %eax
  80005f:	e8 27 17 00 00       	call   80178b <seek>
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  800064:	83 c4 0c             	add    $0xc,%esp
  800067:	68 00 02 00 00       	push   $0x200
  80006c:	68 20 52 80 00       	push   $0x805220
  800071:	53                   	push   %ebx
  800072:	e8 43 16 00 00       	call   8016ba <readn>
  800077:	89 c6                	mov    %eax,%esi
  800079:	83 c4 10             	add    $0x10,%esp
  80007c:	85 c0                	test   %eax,%eax
  80007e:	0f 8e e6 00 00 00    	jle    80016a <umain+0x137>
		panic("readn: %e", n);

	if ((r = fork()) < 0)
  800084:	e8 80 10 00 00       	call   801109 <fork>
  800089:	89 c7                	mov    %eax,%edi
  80008b:	85 c0                	test   %eax,%eax
  80008d:	0f 88 e9 00 00 00    	js     80017c <umain+0x149>
		panic("fork: %e", r);
	if (r == 0) {
  800093:	75 7b                	jne    800110 <umain+0xdd>
		seek(fd, 0);
  800095:	83 ec 08             	sub    $0x8,%esp
  800098:	6a 00                	push   $0x0
  80009a:	53                   	push   %ebx
  80009b:	e8 eb 16 00 00       	call   80178b <seek>
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  8000a0:	c7 04 24 48 2a 80 00 	movl   $0x802a48,(%esp)
  8000a7:	e8 71 02 00 00       	call   80031d <cprintf>
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8000ac:	83 c4 0c             	add    $0xc,%esp
  8000af:	68 00 02 00 00       	push   $0x200
  8000b4:	68 20 50 80 00       	push   $0x805020
  8000b9:	53                   	push   %ebx
  8000ba:	e8 fb 15 00 00       	call   8016ba <readn>
  8000bf:	83 c4 10             	add    $0x10,%esp
  8000c2:	39 c6                	cmp    %eax,%esi
  8000c4:	0f 85 c4 00 00 00    	jne    80018e <umain+0x15b>
			panic("read in parent got %d, read in child got %d", n, n2);
		if (memcmp(buf, buf2, n) != 0)
  8000ca:	83 ec 04             	sub    $0x4,%esp
  8000cd:	56                   	push   %esi
  8000ce:	68 20 50 80 00       	push   $0x805020
  8000d3:	68 20 52 80 00       	push   $0x805220
  8000d8:	e8 80 0a 00 00       	call   800b5d <memcmp>
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	85 c0                	test   %eax,%eax
  8000e2:	0f 85 bc 00 00 00    	jne    8001a4 <umain+0x171>
			panic("read in parent got different bytes from read in child");
		cprintf("read in child succeeded\n");
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	68 12 2a 80 00       	push   $0x802a12
  8000f0:	e8 28 02 00 00       	call   80031d <cprintf>
		seek(fd, 0);
  8000f5:	83 c4 08             	add    $0x8,%esp
  8000f8:	6a 00                	push   $0x0
  8000fa:	53                   	push   %ebx
  8000fb:	e8 8b 16 00 00       	call   80178b <seek>
		close(fd);
  800100:	89 1c 24             	mov    %ebx,(%esp)
  800103:	e8 dd 13 00 00       	call   8014e5 <close>
		exit();
  800108:	e8 0b 01 00 00       	call   800218 <exit>
  80010d:	83 c4 10             	add    $0x10,%esp
	}
	wait(r);
  800110:	83 ec 0c             	sub    $0xc,%esp
  800113:	57                   	push   %edi
  800114:	e8 76 22 00 00       	call   80238f <wait>
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800119:	83 c4 0c             	add    $0xc,%esp
  80011c:	68 00 02 00 00       	push   $0x200
  800121:	68 20 50 80 00       	push   $0x805020
  800126:	53                   	push   %ebx
  800127:	e8 8e 15 00 00       	call   8016ba <readn>
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	39 c6                	cmp    %eax,%esi
  800131:	0f 85 81 00 00 00    	jne    8001b8 <umain+0x185>
		panic("read in parent got %d, then got %d", n, n2);
	cprintf("read in parent succeeded\n");
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	68 2b 2a 80 00       	push   $0x802a2b
  80013f:	e8 d9 01 00 00       	call   80031d <cprintf>
	close(fd);
  800144:	89 1c 24             	mov    %ebx,(%esp)
  800147:	e8 99 13 00 00       	call   8014e5 <close>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  80014c:	cc                   	int3   

	breakpoint();
}
  80014d:	83 c4 10             	add    $0x10,%esp
  800150:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800153:	5b                   	pop    %ebx
  800154:	5e                   	pop    %esi
  800155:	5f                   	pop    %edi
  800156:	5d                   	pop    %ebp
  800157:	c3                   	ret    
		panic("open motd: %e", fd);
  800158:	50                   	push   %eax
  800159:	68 e5 29 80 00       	push   $0x8029e5
  80015e:	6a 0c                	push   $0xc
  800160:	68 f3 29 80 00       	push   $0x8029f3
  800165:	e8 cc 00 00 00       	call   800236 <_panic>
		panic("readn: %e", n);
  80016a:	50                   	push   %eax
  80016b:	68 08 2a 80 00       	push   $0x802a08
  800170:	6a 0f                	push   $0xf
  800172:	68 f3 29 80 00       	push   $0x8029f3
  800177:	e8 ba 00 00 00       	call   800236 <_panic>
		panic("fork: %e", r);
  80017c:	50                   	push   %eax
  80017d:	68 a5 2e 80 00       	push   $0x802ea5
  800182:	6a 12                	push   $0x12
  800184:	68 f3 29 80 00       	push   $0x8029f3
  800189:	e8 a8 00 00 00       	call   800236 <_panic>
			panic("read in parent got %d, read in child got %d", n, n2);
  80018e:	83 ec 0c             	sub    $0xc,%esp
  800191:	50                   	push   %eax
  800192:	56                   	push   %esi
  800193:	68 8c 2a 80 00       	push   $0x802a8c
  800198:	6a 17                	push   $0x17
  80019a:	68 f3 29 80 00       	push   $0x8029f3
  80019f:	e8 92 00 00 00       	call   800236 <_panic>
			panic("read in parent got different bytes from read in child");
  8001a4:	83 ec 04             	sub    $0x4,%esp
  8001a7:	68 b8 2a 80 00       	push   $0x802ab8
  8001ac:	6a 19                	push   $0x19
  8001ae:	68 f3 29 80 00       	push   $0x8029f3
  8001b3:	e8 7e 00 00 00       	call   800236 <_panic>
		panic("read in parent got %d, then got %d", n, n2);
  8001b8:	83 ec 0c             	sub    $0xc,%esp
  8001bb:	50                   	push   %eax
  8001bc:	56                   	push   %esi
  8001bd:	68 f0 2a 80 00       	push   $0x802af0
  8001c2:	6a 21                	push   $0x21
  8001c4:	68 f3 29 80 00       	push   $0x8029f3
  8001c9:	e8 68 00 00 00       	call   800236 <_panic>

008001ce <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001ce:	f3 0f 1e fb          	endbr32 
  8001d2:	55                   	push   %ebp
  8001d3:	89 e5                	mov    %esp,%ebp
  8001d5:	56                   	push   %esi
  8001d6:	53                   	push   %ebx
  8001d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001da:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001dd:	e8 41 0b 00 00       	call   800d23 <sys_getenvid>
  8001e2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001e7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001ea:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001ef:	a3 20 54 80 00       	mov    %eax,0x805420

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001f4:	85 db                	test   %ebx,%ebx
  8001f6:	7e 07                	jle    8001ff <libmain+0x31>
		binaryname = argv[0];
  8001f8:	8b 06                	mov    (%esi),%eax
  8001fa:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  8001ff:	83 ec 08             	sub    $0x8,%esp
  800202:	56                   	push   %esi
  800203:	53                   	push   %ebx
  800204:	e8 2a fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800209:	e8 0a 00 00 00       	call   800218 <exit>
}
  80020e:	83 c4 10             	add    $0x10,%esp
  800211:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800214:	5b                   	pop    %ebx
  800215:	5e                   	pop    %esi
  800216:	5d                   	pop    %ebp
  800217:	c3                   	ret    

00800218 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800218:	f3 0f 1e fb          	endbr32 
  80021c:	55                   	push   %ebp
  80021d:	89 e5                	mov    %esp,%ebp
  80021f:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800222:	e8 ef 12 00 00       	call   801516 <close_all>
	sys_env_destroy(0);
  800227:	83 ec 0c             	sub    $0xc,%esp
  80022a:	6a 00                	push   $0x0
  80022c:	e8 ad 0a 00 00       	call   800cde <sys_env_destroy>
}
  800231:	83 c4 10             	add    $0x10,%esp
  800234:	c9                   	leave  
  800235:	c3                   	ret    

00800236 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800236:	f3 0f 1e fb          	endbr32 
  80023a:	55                   	push   %ebp
  80023b:	89 e5                	mov    %esp,%ebp
  80023d:	56                   	push   %esi
  80023e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80023f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800242:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800248:	e8 d6 0a 00 00       	call   800d23 <sys_getenvid>
  80024d:	83 ec 0c             	sub    $0xc,%esp
  800250:	ff 75 0c             	pushl  0xc(%ebp)
  800253:	ff 75 08             	pushl  0x8(%ebp)
  800256:	56                   	push   %esi
  800257:	50                   	push   %eax
  800258:	68 20 2b 80 00       	push   $0x802b20
  80025d:	e8 bb 00 00 00       	call   80031d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800262:	83 c4 18             	add    $0x18,%esp
  800265:	53                   	push   %ebx
  800266:	ff 75 10             	pushl  0x10(%ebp)
  800269:	e8 5a 00 00 00       	call   8002c8 <vcprintf>
	cprintf("\n");
  80026e:	c7 04 24 c7 30 80 00 	movl   $0x8030c7,(%esp)
  800275:	e8 a3 00 00 00       	call   80031d <cprintf>
  80027a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80027d:	cc                   	int3   
  80027e:	eb fd                	jmp    80027d <_panic+0x47>

00800280 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800280:	f3 0f 1e fb          	endbr32 
  800284:	55                   	push   %ebp
  800285:	89 e5                	mov    %esp,%ebp
  800287:	53                   	push   %ebx
  800288:	83 ec 04             	sub    $0x4,%esp
  80028b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80028e:	8b 13                	mov    (%ebx),%edx
  800290:	8d 42 01             	lea    0x1(%edx),%eax
  800293:	89 03                	mov    %eax,(%ebx)
  800295:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800298:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80029c:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002a1:	74 09                	je     8002ac <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002a3:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002aa:	c9                   	leave  
  8002ab:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002ac:	83 ec 08             	sub    $0x8,%esp
  8002af:	68 ff 00 00 00       	push   $0xff
  8002b4:	8d 43 08             	lea    0x8(%ebx),%eax
  8002b7:	50                   	push   %eax
  8002b8:	e8 dc 09 00 00       	call   800c99 <sys_cputs>
		b->idx = 0;
  8002bd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002c3:	83 c4 10             	add    $0x10,%esp
  8002c6:	eb db                	jmp    8002a3 <putch+0x23>

008002c8 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002c8:	f3 0f 1e fb          	endbr32 
  8002cc:	55                   	push   %ebp
  8002cd:	89 e5                	mov    %esp,%ebp
  8002cf:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002d5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002dc:	00 00 00 
	b.cnt = 0;
  8002df:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002e6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002e9:	ff 75 0c             	pushl  0xc(%ebp)
  8002ec:	ff 75 08             	pushl  0x8(%ebp)
  8002ef:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002f5:	50                   	push   %eax
  8002f6:	68 80 02 80 00       	push   $0x800280
  8002fb:	e8 20 01 00 00       	call   800420 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800300:	83 c4 08             	add    $0x8,%esp
  800303:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800309:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80030f:	50                   	push   %eax
  800310:	e8 84 09 00 00       	call   800c99 <sys_cputs>

	return b.cnt;
}
  800315:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80031b:	c9                   	leave  
  80031c:	c3                   	ret    

0080031d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80031d:	f3 0f 1e fb          	endbr32 
  800321:	55                   	push   %ebp
  800322:	89 e5                	mov    %esp,%ebp
  800324:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800327:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80032a:	50                   	push   %eax
  80032b:	ff 75 08             	pushl  0x8(%ebp)
  80032e:	e8 95 ff ff ff       	call   8002c8 <vcprintf>
	va_end(ap);

	return cnt;
}
  800333:	c9                   	leave  
  800334:	c3                   	ret    

00800335 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800335:	55                   	push   %ebp
  800336:	89 e5                	mov    %esp,%ebp
  800338:	57                   	push   %edi
  800339:	56                   	push   %esi
  80033a:	53                   	push   %ebx
  80033b:	83 ec 1c             	sub    $0x1c,%esp
  80033e:	89 c7                	mov    %eax,%edi
  800340:	89 d6                	mov    %edx,%esi
  800342:	8b 45 08             	mov    0x8(%ebp),%eax
  800345:	8b 55 0c             	mov    0xc(%ebp),%edx
  800348:	89 d1                	mov    %edx,%ecx
  80034a:	89 c2                	mov    %eax,%edx
  80034c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80034f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800352:	8b 45 10             	mov    0x10(%ebp),%eax
  800355:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800358:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80035b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800362:	39 c2                	cmp    %eax,%edx
  800364:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800367:	72 3e                	jb     8003a7 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800369:	83 ec 0c             	sub    $0xc,%esp
  80036c:	ff 75 18             	pushl  0x18(%ebp)
  80036f:	83 eb 01             	sub    $0x1,%ebx
  800372:	53                   	push   %ebx
  800373:	50                   	push   %eax
  800374:	83 ec 08             	sub    $0x8,%esp
  800377:	ff 75 e4             	pushl  -0x1c(%ebp)
  80037a:	ff 75 e0             	pushl  -0x20(%ebp)
  80037d:	ff 75 dc             	pushl  -0x24(%ebp)
  800380:	ff 75 d8             	pushl  -0x28(%ebp)
  800383:	e8 e8 23 00 00       	call   802770 <__udivdi3>
  800388:	83 c4 18             	add    $0x18,%esp
  80038b:	52                   	push   %edx
  80038c:	50                   	push   %eax
  80038d:	89 f2                	mov    %esi,%edx
  80038f:	89 f8                	mov    %edi,%eax
  800391:	e8 9f ff ff ff       	call   800335 <printnum>
  800396:	83 c4 20             	add    $0x20,%esp
  800399:	eb 13                	jmp    8003ae <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80039b:	83 ec 08             	sub    $0x8,%esp
  80039e:	56                   	push   %esi
  80039f:	ff 75 18             	pushl  0x18(%ebp)
  8003a2:	ff d7                	call   *%edi
  8003a4:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8003a7:	83 eb 01             	sub    $0x1,%ebx
  8003aa:	85 db                	test   %ebx,%ebx
  8003ac:	7f ed                	jg     80039b <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003ae:	83 ec 08             	sub    $0x8,%esp
  8003b1:	56                   	push   %esi
  8003b2:	83 ec 04             	sub    $0x4,%esp
  8003b5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003b8:	ff 75 e0             	pushl  -0x20(%ebp)
  8003bb:	ff 75 dc             	pushl  -0x24(%ebp)
  8003be:	ff 75 d8             	pushl  -0x28(%ebp)
  8003c1:	e8 ba 24 00 00       	call   802880 <__umoddi3>
  8003c6:	83 c4 14             	add    $0x14,%esp
  8003c9:	0f be 80 43 2b 80 00 	movsbl 0x802b43(%eax),%eax
  8003d0:	50                   	push   %eax
  8003d1:	ff d7                	call   *%edi
}
  8003d3:	83 c4 10             	add    $0x10,%esp
  8003d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003d9:	5b                   	pop    %ebx
  8003da:	5e                   	pop    %esi
  8003db:	5f                   	pop    %edi
  8003dc:	5d                   	pop    %ebp
  8003dd:	c3                   	ret    

008003de <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003de:	f3 0f 1e fb          	endbr32 
  8003e2:	55                   	push   %ebp
  8003e3:	89 e5                	mov    %esp,%ebp
  8003e5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003e8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003ec:	8b 10                	mov    (%eax),%edx
  8003ee:	3b 50 04             	cmp    0x4(%eax),%edx
  8003f1:	73 0a                	jae    8003fd <sprintputch+0x1f>
		*b->buf++ = ch;
  8003f3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003f6:	89 08                	mov    %ecx,(%eax)
  8003f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fb:	88 02                	mov    %al,(%edx)
}
  8003fd:	5d                   	pop    %ebp
  8003fe:	c3                   	ret    

008003ff <printfmt>:
{
  8003ff:	f3 0f 1e fb          	endbr32 
  800403:	55                   	push   %ebp
  800404:	89 e5                	mov    %esp,%ebp
  800406:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800409:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80040c:	50                   	push   %eax
  80040d:	ff 75 10             	pushl  0x10(%ebp)
  800410:	ff 75 0c             	pushl  0xc(%ebp)
  800413:	ff 75 08             	pushl  0x8(%ebp)
  800416:	e8 05 00 00 00       	call   800420 <vprintfmt>
}
  80041b:	83 c4 10             	add    $0x10,%esp
  80041e:	c9                   	leave  
  80041f:	c3                   	ret    

00800420 <vprintfmt>:
{
  800420:	f3 0f 1e fb          	endbr32 
  800424:	55                   	push   %ebp
  800425:	89 e5                	mov    %esp,%ebp
  800427:	57                   	push   %edi
  800428:	56                   	push   %esi
  800429:	53                   	push   %ebx
  80042a:	83 ec 3c             	sub    $0x3c,%esp
  80042d:	8b 75 08             	mov    0x8(%ebp),%esi
  800430:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800433:	8b 7d 10             	mov    0x10(%ebp),%edi
  800436:	e9 8e 03 00 00       	jmp    8007c9 <vprintfmt+0x3a9>
		padc = ' ';
  80043b:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80043f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800446:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80044d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800454:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800459:	8d 47 01             	lea    0x1(%edi),%eax
  80045c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80045f:	0f b6 17             	movzbl (%edi),%edx
  800462:	8d 42 dd             	lea    -0x23(%edx),%eax
  800465:	3c 55                	cmp    $0x55,%al
  800467:	0f 87 df 03 00 00    	ja     80084c <vprintfmt+0x42c>
  80046d:	0f b6 c0             	movzbl %al,%eax
  800470:	3e ff 24 85 80 2c 80 	notrack jmp *0x802c80(,%eax,4)
  800477:	00 
  800478:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80047b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80047f:	eb d8                	jmp    800459 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800481:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800484:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800488:	eb cf                	jmp    800459 <vprintfmt+0x39>
  80048a:	0f b6 d2             	movzbl %dl,%edx
  80048d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800490:	b8 00 00 00 00       	mov    $0x0,%eax
  800495:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800498:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80049b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80049f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004a2:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004a5:	83 f9 09             	cmp    $0x9,%ecx
  8004a8:	77 55                	ja     8004ff <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8004aa:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004ad:	eb e9                	jmp    800498 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8004af:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b2:	8b 00                	mov    (%eax),%eax
  8004b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ba:	8d 40 04             	lea    0x4(%eax),%eax
  8004bd:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004c3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004c7:	79 90                	jns    800459 <vprintfmt+0x39>
				width = precision, precision = -1;
  8004c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004cf:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004d6:	eb 81                	jmp    800459 <vprintfmt+0x39>
  8004d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004db:	85 c0                	test   %eax,%eax
  8004dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e2:	0f 49 d0             	cmovns %eax,%edx
  8004e5:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004eb:	e9 69 ff ff ff       	jmp    800459 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8004f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004f3:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8004fa:	e9 5a ff ff ff       	jmp    800459 <vprintfmt+0x39>
  8004ff:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800502:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800505:	eb bc                	jmp    8004c3 <vprintfmt+0xa3>
			lflag++;
  800507:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80050a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80050d:	e9 47 ff ff ff       	jmp    800459 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800512:	8b 45 14             	mov    0x14(%ebp),%eax
  800515:	8d 78 04             	lea    0x4(%eax),%edi
  800518:	83 ec 08             	sub    $0x8,%esp
  80051b:	53                   	push   %ebx
  80051c:	ff 30                	pushl  (%eax)
  80051e:	ff d6                	call   *%esi
			break;
  800520:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800523:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800526:	e9 9b 02 00 00       	jmp    8007c6 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80052b:	8b 45 14             	mov    0x14(%ebp),%eax
  80052e:	8d 78 04             	lea    0x4(%eax),%edi
  800531:	8b 00                	mov    (%eax),%eax
  800533:	99                   	cltd   
  800534:	31 d0                	xor    %edx,%eax
  800536:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800538:	83 f8 0f             	cmp    $0xf,%eax
  80053b:	7f 23                	jg     800560 <vprintfmt+0x140>
  80053d:	8b 14 85 e0 2d 80 00 	mov    0x802de0(,%eax,4),%edx
  800544:	85 d2                	test   %edx,%edx
  800546:	74 18                	je     800560 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800548:	52                   	push   %edx
  800549:	68 a5 2f 80 00       	push   $0x802fa5
  80054e:	53                   	push   %ebx
  80054f:	56                   	push   %esi
  800550:	e8 aa fe ff ff       	call   8003ff <printfmt>
  800555:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800558:	89 7d 14             	mov    %edi,0x14(%ebp)
  80055b:	e9 66 02 00 00       	jmp    8007c6 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800560:	50                   	push   %eax
  800561:	68 5b 2b 80 00       	push   $0x802b5b
  800566:	53                   	push   %ebx
  800567:	56                   	push   %esi
  800568:	e8 92 fe ff ff       	call   8003ff <printfmt>
  80056d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800570:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800573:	e9 4e 02 00 00       	jmp    8007c6 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800578:	8b 45 14             	mov    0x14(%ebp),%eax
  80057b:	83 c0 04             	add    $0x4,%eax
  80057e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800581:	8b 45 14             	mov    0x14(%ebp),%eax
  800584:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800586:	85 d2                	test   %edx,%edx
  800588:	b8 54 2b 80 00       	mov    $0x802b54,%eax
  80058d:	0f 45 c2             	cmovne %edx,%eax
  800590:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800593:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800597:	7e 06                	jle    80059f <vprintfmt+0x17f>
  800599:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80059d:	75 0d                	jne    8005ac <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80059f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005a2:	89 c7                	mov    %eax,%edi
  8005a4:	03 45 e0             	add    -0x20(%ebp),%eax
  8005a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005aa:	eb 55                	jmp    800601 <vprintfmt+0x1e1>
  8005ac:	83 ec 08             	sub    $0x8,%esp
  8005af:	ff 75 d8             	pushl  -0x28(%ebp)
  8005b2:	ff 75 cc             	pushl  -0x34(%ebp)
  8005b5:	e8 46 03 00 00       	call   800900 <strnlen>
  8005ba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005bd:	29 c2                	sub    %eax,%edx
  8005bf:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8005c2:	83 c4 10             	add    $0x10,%esp
  8005c5:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8005c7:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005ce:	85 ff                	test   %edi,%edi
  8005d0:	7e 11                	jle    8005e3 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8005d2:	83 ec 08             	sub    $0x8,%esp
  8005d5:	53                   	push   %ebx
  8005d6:	ff 75 e0             	pushl  -0x20(%ebp)
  8005d9:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005db:	83 ef 01             	sub    $0x1,%edi
  8005de:	83 c4 10             	add    $0x10,%esp
  8005e1:	eb eb                	jmp    8005ce <vprintfmt+0x1ae>
  8005e3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8005e6:	85 d2                	test   %edx,%edx
  8005e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ed:	0f 49 c2             	cmovns %edx,%eax
  8005f0:	29 c2                	sub    %eax,%edx
  8005f2:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8005f5:	eb a8                	jmp    80059f <vprintfmt+0x17f>
					putch(ch, putdat);
  8005f7:	83 ec 08             	sub    $0x8,%esp
  8005fa:	53                   	push   %ebx
  8005fb:	52                   	push   %edx
  8005fc:	ff d6                	call   *%esi
  8005fe:	83 c4 10             	add    $0x10,%esp
  800601:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800604:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800606:	83 c7 01             	add    $0x1,%edi
  800609:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80060d:	0f be d0             	movsbl %al,%edx
  800610:	85 d2                	test   %edx,%edx
  800612:	74 4b                	je     80065f <vprintfmt+0x23f>
  800614:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800618:	78 06                	js     800620 <vprintfmt+0x200>
  80061a:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80061e:	78 1e                	js     80063e <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800620:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800624:	74 d1                	je     8005f7 <vprintfmt+0x1d7>
  800626:	0f be c0             	movsbl %al,%eax
  800629:	83 e8 20             	sub    $0x20,%eax
  80062c:	83 f8 5e             	cmp    $0x5e,%eax
  80062f:	76 c6                	jbe    8005f7 <vprintfmt+0x1d7>
					putch('?', putdat);
  800631:	83 ec 08             	sub    $0x8,%esp
  800634:	53                   	push   %ebx
  800635:	6a 3f                	push   $0x3f
  800637:	ff d6                	call   *%esi
  800639:	83 c4 10             	add    $0x10,%esp
  80063c:	eb c3                	jmp    800601 <vprintfmt+0x1e1>
  80063e:	89 cf                	mov    %ecx,%edi
  800640:	eb 0e                	jmp    800650 <vprintfmt+0x230>
				putch(' ', putdat);
  800642:	83 ec 08             	sub    $0x8,%esp
  800645:	53                   	push   %ebx
  800646:	6a 20                	push   $0x20
  800648:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80064a:	83 ef 01             	sub    $0x1,%edi
  80064d:	83 c4 10             	add    $0x10,%esp
  800650:	85 ff                	test   %edi,%edi
  800652:	7f ee                	jg     800642 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800654:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800657:	89 45 14             	mov    %eax,0x14(%ebp)
  80065a:	e9 67 01 00 00       	jmp    8007c6 <vprintfmt+0x3a6>
  80065f:	89 cf                	mov    %ecx,%edi
  800661:	eb ed                	jmp    800650 <vprintfmt+0x230>
	if (lflag >= 2)
  800663:	83 f9 01             	cmp    $0x1,%ecx
  800666:	7f 1b                	jg     800683 <vprintfmt+0x263>
	else if (lflag)
  800668:	85 c9                	test   %ecx,%ecx
  80066a:	74 63                	je     8006cf <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	8b 00                	mov    (%eax),%eax
  800671:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800674:	99                   	cltd   
  800675:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800678:	8b 45 14             	mov    0x14(%ebp),%eax
  80067b:	8d 40 04             	lea    0x4(%eax),%eax
  80067e:	89 45 14             	mov    %eax,0x14(%ebp)
  800681:	eb 17                	jmp    80069a <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800683:	8b 45 14             	mov    0x14(%ebp),%eax
  800686:	8b 50 04             	mov    0x4(%eax),%edx
  800689:	8b 00                	mov    (%eax),%eax
  80068b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800691:	8b 45 14             	mov    0x14(%ebp),%eax
  800694:	8d 40 08             	lea    0x8(%eax),%eax
  800697:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80069a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80069d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8006a0:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8006a5:	85 c9                	test   %ecx,%ecx
  8006a7:	0f 89 ff 00 00 00    	jns    8007ac <vprintfmt+0x38c>
				putch('-', putdat);
  8006ad:	83 ec 08             	sub    $0x8,%esp
  8006b0:	53                   	push   %ebx
  8006b1:	6a 2d                	push   $0x2d
  8006b3:	ff d6                	call   *%esi
				num = -(long long) num;
  8006b5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006b8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006bb:	f7 da                	neg    %edx
  8006bd:	83 d1 00             	adc    $0x0,%ecx
  8006c0:	f7 d9                	neg    %ecx
  8006c2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006c5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ca:	e9 dd 00 00 00       	jmp    8007ac <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8006cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d7:	99                   	cltd   
  8006d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006db:	8b 45 14             	mov    0x14(%ebp),%eax
  8006de:	8d 40 04             	lea    0x4(%eax),%eax
  8006e1:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e4:	eb b4                	jmp    80069a <vprintfmt+0x27a>
	if (lflag >= 2)
  8006e6:	83 f9 01             	cmp    $0x1,%ecx
  8006e9:	7f 1e                	jg     800709 <vprintfmt+0x2e9>
	else if (lflag)
  8006eb:	85 c9                	test   %ecx,%ecx
  8006ed:	74 32                	je     800721 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8006ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f2:	8b 10                	mov    (%eax),%edx
  8006f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006f9:	8d 40 04             	lea    0x4(%eax),%eax
  8006fc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ff:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800704:	e9 a3 00 00 00       	jmp    8007ac <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800709:	8b 45 14             	mov    0x14(%ebp),%eax
  80070c:	8b 10                	mov    (%eax),%edx
  80070e:	8b 48 04             	mov    0x4(%eax),%ecx
  800711:	8d 40 08             	lea    0x8(%eax),%eax
  800714:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800717:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80071c:	e9 8b 00 00 00       	jmp    8007ac <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800721:	8b 45 14             	mov    0x14(%ebp),%eax
  800724:	8b 10                	mov    (%eax),%edx
  800726:	b9 00 00 00 00       	mov    $0x0,%ecx
  80072b:	8d 40 04             	lea    0x4(%eax),%eax
  80072e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800731:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800736:	eb 74                	jmp    8007ac <vprintfmt+0x38c>
	if (lflag >= 2)
  800738:	83 f9 01             	cmp    $0x1,%ecx
  80073b:	7f 1b                	jg     800758 <vprintfmt+0x338>
	else if (lflag)
  80073d:	85 c9                	test   %ecx,%ecx
  80073f:	74 2c                	je     80076d <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800741:	8b 45 14             	mov    0x14(%ebp),%eax
  800744:	8b 10                	mov    (%eax),%edx
  800746:	b9 00 00 00 00       	mov    $0x0,%ecx
  80074b:	8d 40 04             	lea    0x4(%eax),%eax
  80074e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800751:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800756:	eb 54                	jmp    8007ac <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800758:	8b 45 14             	mov    0x14(%ebp),%eax
  80075b:	8b 10                	mov    (%eax),%edx
  80075d:	8b 48 04             	mov    0x4(%eax),%ecx
  800760:	8d 40 08             	lea    0x8(%eax),%eax
  800763:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800766:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80076b:	eb 3f                	jmp    8007ac <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80076d:	8b 45 14             	mov    0x14(%ebp),%eax
  800770:	8b 10                	mov    (%eax),%edx
  800772:	b9 00 00 00 00       	mov    $0x0,%ecx
  800777:	8d 40 04             	lea    0x4(%eax),%eax
  80077a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80077d:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800782:	eb 28                	jmp    8007ac <vprintfmt+0x38c>
			putch('0', putdat);
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	53                   	push   %ebx
  800788:	6a 30                	push   $0x30
  80078a:	ff d6                	call   *%esi
			putch('x', putdat);
  80078c:	83 c4 08             	add    $0x8,%esp
  80078f:	53                   	push   %ebx
  800790:	6a 78                	push   $0x78
  800792:	ff d6                	call   *%esi
			num = (unsigned long long)
  800794:	8b 45 14             	mov    0x14(%ebp),%eax
  800797:	8b 10                	mov    (%eax),%edx
  800799:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80079e:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007a1:	8d 40 04             	lea    0x4(%eax),%eax
  8007a4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007a7:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007ac:	83 ec 0c             	sub    $0xc,%esp
  8007af:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8007b3:	57                   	push   %edi
  8007b4:	ff 75 e0             	pushl  -0x20(%ebp)
  8007b7:	50                   	push   %eax
  8007b8:	51                   	push   %ecx
  8007b9:	52                   	push   %edx
  8007ba:	89 da                	mov    %ebx,%edx
  8007bc:	89 f0                	mov    %esi,%eax
  8007be:	e8 72 fb ff ff       	call   800335 <printnum>
			break;
  8007c3:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007c9:	83 c7 01             	add    $0x1,%edi
  8007cc:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007d0:	83 f8 25             	cmp    $0x25,%eax
  8007d3:	0f 84 62 fc ff ff    	je     80043b <vprintfmt+0x1b>
			if (ch == '\0')
  8007d9:	85 c0                	test   %eax,%eax
  8007db:	0f 84 8b 00 00 00    	je     80086c <vprintfmt+0x44c>
			putch(ch, putdat);
  8007e1:	83 ec 08             	sub    $0x8,%esp
  8007e4:	53                   	push   %ebx
  8007e5:	50                   	push   %eax
  8007e6:	ff d6                	call   *%esi
  8007e8:	83 c4 10             	add    $0x10,%esp
  8007eb:	eb dc                	jmp    8007c9 <vprintfmt+0x3a9>
	if (lflag >= 2)
  8007ed:	83 f9 01             	cmp    $0x1,%ecx
  8007f0:	7f 1b                	jg     80080d <vprintfmt+0x3ed>
	else if (lflag)
  8007f2:	85 c9                	test   %ecx,%ecx
  8007f4:	74 2c                	je     800822 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8007f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f9:	8b 10                	mov    (%eax),%edx
  8007fb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800800:	8d 40 04             	lea    0x4(%eax),%eax
  800803:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800806:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80080b:	eb 9f                	jmp    8007ac <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80080d:	8b 45 14             	mov    0x14(%ebp),%eax
  800810:	8b 10                	mov    (%eax),%edx
  800812:	8b 48 04             	mov    0x4(%eax),%ecx
  800815:	8d 40 08             	lea    0x8(%eax),%eax
  800818:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80081b:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800820:	eb 8a                	jmp    8007ac <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800822:	8b 45 14             	mov    0x14(%ebp),%eax
  800825:	8b 10                	mov    (%eax),%edx
  800827:	b9 00 00 00 00       	mov    $0x0,%ecx
  80082c:	8d 40 04             	lea    0x4(%eax),%eax
  80082f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800832:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800837:	e9 70 ff ff ff       	jmp    8007ac <vprintfmt+0x38c>
			putch(ch, putdat);
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	53                   	push   %ebx
  800840:	6a 25                	push   $0x25
  800842:	ff d6                	call   *%esi
			break;
  800844:	83 c4 10             	add    $0x10,%esp
  800847:	e9 7a ff ff ff       	jmp    8007c6 <vprintfmt+0x3a6>
			putch('%', putdat);
  80084c:	83 ec 08             	sub    $0x8,%esp
  80084f:	53                   	push   %ebx
  800850:	6a 25                	push   $0x25
  800852:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800854:	83 c4 10             	add    $0x10,%esp
  800857:	89 f8                	mov    %edi,%eax
  800859:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80085d:	74 05                	je     800864 <vprintfmt+0x444>
  80085f:	83 e8 01             	sub    $0x1,%eax
  800862:	eb f5                	jmp    800859 <vprintfmt+0x439>
  800864:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800867:	e9 5a ff ff ff       	jmp    8007c6 <vprintfmt+0x3a6>
}
  80086c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80086f:	5b                   	pop    %ebx
  800870:	5e                   	pop    %esi
  800871:	5f                   	pop    %edi
  800872:	5d                   	pop    %ebp
  800873:	c3                   	ret    

00800874 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800874:	f3 0f 1e fb          	endbr32 
  800878:	55                   	push   %ebp
  800879:	89 e5                	mov    %esp,%ebp
  80087b:	83 ec 18             	sub    $0x18,%esp
  80087e:	8b 45 08             	mov    0x8(%ebp),%eax
  800881:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800884:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800887:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80088b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80088e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800895:	85 c0                	test   %eax,%eax
  800897:	74 26                	je     8008bf <vsnprintf+0x4b>
  800899:	85 d2                	test   %edx,%edx
  80089b:	7e 22                	jle    8008bf <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80089d:	ff 75 14             	pushl  0x14(%ebp)
  8008a0:	ff 75 10             	pushl  0x10(%ebp)
  8008a3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008a6:	50                   	push   %eax
  8008a7:	68 de 03 80 00       	push   $0x8003de
  8008ac:	e8 6f fb ff ff       	call   800420 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008b4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008ba:	83 c4 10             	add    $0x10,%esp
}
  8008bd:	c9                   	leave  
  8008be:	c3                   	ret    
		return -E_INVAL;
  8008bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008c4:	eb f7                	jmp    8008bd <vsnprintf+0x49>

008008c6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008c6:	f3 0f 1e fb          	endbr32 
  8008ca:	55                   	push   %ebp
  8008cb:	89 e5                	mov    %esp,%ebp
  8008cd:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008d0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008d3:	50                   	push   %eax
  8008d4:	ff 75 10             	pushl  0x10(%ebp)
  8008d7:	ff 75 0c             	pushl  0xc(%ebp)
  8008da:	ff 75 08             	pushl  0x8(%ebp)
  8008dd:	e8 92 ff ff ff       	call   800874 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008e2:	c9                   	leave  
  8008e3:	c3                   	ret    

008008e4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008e4:	f3 0f 1e fb          	endbr32 
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008f7:	74 05                	je     8008fe <strlen+0x1a>
		n++;
  8008f9:	83 c0 01             	add    $0x1,%eax
  8008fc:	eb f5                	jmp    8008f3 <strlen+0xf>
	return n;
}
  8008fe:	5d                   	pop    %ebp
  8008ff:	c3                   	ret    

00800900 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800900:	f3 0f 1e fb          	endbr32 
  800904:	55                   	push   %ebp
  800905:	89 e5                	mov    %esp,%ebp
  800907:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80090a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80090d:	b8 00 00 00 00       	mov    $0x0,%eax
  800912:	39 d0                	cmp    %edx,%eax
  800914:	74 0d                	je     800923 <strnlen+0x23>
  800916:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80091a:	74 05                	je     800921 <strnlen+0x21>
		n++;
  80091c:	83 c0 01             	add    $0x1,%eax
  80091f:	eb f1                	jmp    800912 <strnlen+0x12>
  800921:	89 c2                	mov    %eax,%edx
	return n;
}
  800923:	89 d0                	mov    %edx,%eax
  800925:	5d                   	pop    %ebp
  800926:	c3                   	ret    

00800927 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800927:	f3 0f 1e fb          	endbr32 
  80092b:	55                   	push   %ebp
  80092c:	89 e5                	mov    %esp,%ebp
  80092e:	53                   	push   %ebx
  80092f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800932:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800935:	b8 00 00 00 00       	mov    $0x0,%eax
  80093a:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80093e:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800941:	83 c0 01             	add    $0x1,%eax
  800944:	84 d2                	test   %dl,%dl
  800946:	75 f2                	jne    80093a <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800948:	89 c8                	mov    %ecx,%eax
  80094a:	5b                   	pop    %ebx
  80094b:	5d                   	pop    %ebp
  80094c:	c3                   	ret    

0080094d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80094d:	f3 0f 1e fb          	endbr32 
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	53                   	push   %ebx
  800955:	83 ec 10             	sub    $0x10,%esp
  800958:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80095b:	53                   	push   %ebx
  80095c:	e8 83 ff ff ff       	call   8008e4 <strlen>
  800961:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800964:	ff 75 0c             	pushl  0xc(%ebp)
  800967:	01 d8                	add    %ebx,%eax
  800969:	50                   	push   %eax
  80096a:	e8 b8 ff ff ff       	call   800927 <strcpy>
	return dst;
}
  80096f:	89 d8                	mov    %ebx,%eax
  800971:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800974:	c9                   	leave  
  800975:	c3                   	ret    

00800976 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800976:	f3 0f 1e fb          	endbr32 
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
  80097d:	56                   	push   %esi
  80097e:	53                   	push   %ebx
  80097f:	8b 75 08             	mov    0x8(%ebp),%esi
  800982:	8b 55 0c             	mov    0xc(%ebp),%edx
  800985:	89 f3                	mov    %esi,%ebx
  800987:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80098a:	89 f0                	mov    %esi,%eax
  80098c:	39 d8                	cmp    %ebx,%eax
  80098e:	74 11                	je     8009a1 <strncpy+0x2b>
		*dst++ = *src;
  800990:	83 c0 01             	add    $0x1,%eax
  800993:	0f b6 0a             	movzbl (%edx),%ecx
  800996:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800999:	80 f9 01             	cmp    $0x1,%cl
  80099c:	83 da ff             	sbb    $0xffffffff,%edx
  80099f:	eb eb                	jmp    80098c <strncpy+0x16>
	}
	return ret;
}
  8009a1:	89 f0                	mov    %esi,%eax
  8009a3:	5b                   	pop    %ebx
  8009a4:	5e                   	pop    %esi
  8009a5:	5d                   	pop    %ebp
  8009a6:	c3                   	ret    

008009a7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009a7:	f3 0f 1e fb          	endbr32 
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	56                   	push   %esi
  8009af:	53                   	push   %ebx
  8009b0:	8b 75 08             	mov    0x8(%ebp),%esi
  8009b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009b6:	8b 55 10             	mov    0x10(%ebp),%edx
  8009b9:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009bb:	85 d2                	test   %edx,%edx
  8009bd:	74 21                	je     8009e0 <strlcpy+0x39>
  8009bf:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009c3:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009c5:	39 c2                	cmp    %eax,%edx
  8009c7:	74 14                	je     8009dd <strlcpy+0x36>
  8009c9:	0f b6 19             	movzbl (%ecx),%ebx
  8009cc:	84 db                	test   %bl,%bl
  8009ce:	74 0b                	je     8009db <strlcpy+0x34>
			*dst++ = *src++;
  8009d0:	83 c1 01             	add    $0x1,%ecx
  8009d3:	83 c2 01             	add    $0x1,%edx
  8009d6:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009d9:	eb ea                	jmp    8009c5 <strlcpy+0x1e>
  8009db:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009dd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009e0:	29 f0                	sub    %esi,%eax
}
  8009e2:	5b                   	pop    %ebx
  8009e3:	5e                   	pop    %esi
  8009e4:	5d                   	pop    %ebp
  8009e5:	c3                   	ret    

008009e6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009e6:	f3 0f 1e fb          	endbr32 
  8009ea:	55                   	push   %ebp
  8009eb:	89 e5                	mov    %esp,%ebp
  8009ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009f0:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009f3:	0f b6 01             	movzbl (%ecx),%eax
  8009f6:	84 c0                	test   %al,%al
  8009f8:	74 0c                	je     800a06 <strcmp+0x20>
  8009fa:	3a 02                	cmp    (%edx),%al
  8009fc:	75 08                	jne    800a06 <strcmp+0x20>
		p++, q++;
  8009fe:	83 c1 01             	add    $0x1,%ecx
  800a01:	83 c2 01             	add    $0x1,%edx
  800a04:	eb ed                	jmp    8009f3 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a06:	0f b6 c0             	movzbl %al,%eax
  800a09:	0f b6 12             	movzbl (%edx),%edx
  800a0c:	29 d0                	sub    %edx,%eax
}
  800a0e:	5d                   	pop    %ebp
  800a0f:	c3                   	ret    

00800a10 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a10:	f3 0f 1e fb          	endbr32 
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	53                   	push   %ebx
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a1e:	89 c3                	mov    %eax,%ebx
  800a20:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a23:	eb 06                	jmp    800a2b <strncmp+0x1b>
		n--, p++, q++;
  800a25:	83 c0 01             	add    $0x1,%eax
  800a28:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a2b:	39 d8                	cmp    %ebx,%eax
  800a2d:	74 16                	je     800a45 <strncmp+0x35>
  800a2f:	0f b6 08             	movzbl (%eax),%ecx
  800a32:	84 c9                	test   %cl,%cl
  800a34:	74 04                	je     800a3a <strncmp+0x2a>
  800a36:	3a 0a                	cmp    (%edx),%cl
  800a38:	74 eb                	je     800a25 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a3a:	0f b6 00             	movzbl (%eax),%eax
  800a3d:	0f b6 12             	movzbl (%edx),%edx
  800a40:	29 d0                	sub    %edx,%eax
}
  800a42:	5b                   	pop    %ebx
  800a43:	5d                   	pop    %ebp
  800a44:	c3                   	ret    
		return 0;
  800a45:	b8 00 00 00 00       	mov    $0x0,%eax
  800a4a:	eb f6                	jmp    800a42 <strncmp+0x32>

00800a4c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a4c:	f3 0f 1e fb          	endbr32 
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	8b 45 08             	mov    0x8(%ebp),%eax
  800a56:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a5a:	0f b6 10             	movzbl (%eax),%edx
  800a5d:	84 d2                	test   %dl,%dl
  800a5f:	74 09                	je     800a6a <strchr+0x1e>
		if (*s == c)
  800a61:	38 ca                	cmp    %cl,%dl
  800a63:	74 0a                	je     800a6f <strchr+0x23>
	for (; *s; s++)
  800a65:	83 c0 01             	add    $0x1,%eax
  800a68:	eb f0                	jmp    800a5a <strchr+0xe>
			return (char *) s;
	return 0;
  800a6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a6f:	5d                   	pop    %ebp
  800a70:	c3                   	ret    

00800a71 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a71:	f3 0f 1e fb          	endbr32 
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a7f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a82:	38 ca                	cmp    %cl,%dl
  800a84:	74 09                	je     800a8f <strfind+0x1e>
  800a86:	84 d2                	test   %dl,%dl
  800a88:	74 05                	je     800a8f <strfind+0x1e>
	for (; *s; s++)
  800a8a:	83 c0 01             	add    $0x1,%eax
  800a8d:	eb f0                	jmp    800a7f <strfind+0xe>
			break;
	return (char *) s;
}
  800a8f:	5d                   	pop    %ebp
  800a90:	c3                   	ret    

00800a91 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a91:	f3 0f 1e fb          	endbr32 
  800a95:	55                   	push   %ebp
  800a96:	89 e5                	mov    %esp,%ebp
  800a98:	57                   	push   %edi
  800a99:	56                   	push   %esi
  800a9a:	53                   	push   %ebx
  800a9b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a9e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800aa1:	85 c9                	test   %ecx,%ecx
  800aa3:	74 31                	je     800ad6 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800aa5:	89 f8                	mov    %edi,%eax
  800aa7:	09 c8                	or     %ecx,%eax
  800aa9:	a8 03                	test   $0x3,%al
  800aab:	75 23                	jne    800ad0 <memset+0x3f>
		c &= 0xFF;
  800aad:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ab1:	89 d3                	mov    %edx,%ebx
  800ab3:	c1 e3 08             	shl    $0x8,%ebx
  800ab6:	89 d0                	mov    %edx,%eax
  800ab8:	c1 e0 18             	shl    $0x18,%eax
  800abb:	89 d6                	mov    %edx,%esi
  800abd:	c1 e6 10             	shl    $0x10,%esi
  800ac0:	09 f0                	or     %esi,%eax
  800ac2:	09 c2                	or     %eax,%edx
  800ac4:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ac6:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ac9:	89 d0                	mov    %edx,%eax
  800acb:	fc                   	cld    
  800acc:	f3 ab                	rep stos %eax,%es:(%edi)
  800ace:	eb 06                	jmp    800ad6 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ad0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad3:	fc                   	cld    
  800ad4:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ad6:	89 f8                	mov    %edi,%eax
  800ad8:	5b                   	pop    %ebx
  800ad9:	5e                   	pop    %esi
  800ada:	5f                   	pop    %edi
  800adb:	5d                   	pop    %ebp
  800adc:	c3                   	ret    

00800add <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800add:	f3 0f 1e fb          	endbr32 
  800ae1:	55                   	push   %ebp
  800ae2:	89 e5                	mov    %esp,%ebp
  800ae4:	57                   	push   %edi
  800ae5:	56                   	push   %esi
  800ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aec:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800aef:	39 c6                	cmp    %eax,%esi
  800af1:	73 32                	jae    800b25 <memmove+0x48>
  800af3:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800af6:	39 c2                	cmp    %eax,%edx
  800af8:	76 2b                	jbe    800b25 <memmove+0x48>
		s += n;
		d += n;
  800afa:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800afd:	89 fe                	mov    %edi,%esi
  800aff:	09 ce                	or     %ecx,%esi
  800b01:	09 d6                	or     %edx,%esi
  800b03:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b09:	75 0e                	jne    800b19 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b0b:	83 ef 04             	sub    $0x4,%edi
  800b0e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b11:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b14:	fd                   	std    
  800b15:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b17:	eb 09                	jmp    800b22 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b19:	83 ef 01             	sub    $0x1,%edi
  800b1c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b1f:	fd                   	std    
  800b20:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b22:	fc                   	cld    
  800b23:	eb 1a                	jmp    800b3f <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b25:	89 c2                	mov    %eax,%edx
  800b27:	09 ca                	or     %ecx,%edx
  800b29:	09 f2                	or     %esi,%edx
  800b2b:	f6 c2 03             	test   $0x3,%dl
  800b2e:	75 0a                	jne    800b3a <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b30:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b33:	89 c7                	mov    %eax,%edi
  800b35:	fc                   	cld    
  800b36:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b38:	eb 05                	jmp    800b3f <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800b3a:	89 c7                	mov    %eax,%edi
  800b3c:	fc                   	cld    
  800b3d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b3f:	5e                   	pop    %esi
  800b40:	5f                   	pop    %edi
  800b41:	5d                   	pop    %ebp
  800b42:	c3                   	ret    

00800b43 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b43:	f3 0f 1e fb          	endbr32 
  800b47:	55                   	push   %ebp
  800b48:	89 e5                	mov    %esp,%ebp
  800b4a:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b4d:	ff 75 10             	pushl  0x10(%ebp)
  800b50:	ff 75 0c             	pushl  0xc(%ebp)
  800b53:	ff 75 08             	pushl  0x8(%ebp)
  800b56:	e8 82 ff ff ff       	call   800add <memmove>
}
  800b5b:	c9                   	leave  
  800b5c:	c3                   	ret    

00800b5d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b5d:	f3 0f 1e fb          	endbr32 
  800b61:	55                   	push   %ebp
  800b62:	89 e5                	mov    %esp,%ebp
  800b64:	56                   	push   %esi
  800b65:	53                   	push   %ebx
  800b66:	8b 45 08             	mov    0x8(%ebp),%eax
  800b69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b6c:	89 c6                	mov    %eax,%esi
  800b6e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b71:	39 f0                	cmp    %esi,%eax
  800b73:	74 1c                	je     800b91 <memcmp+0x34>
		if (*s1 != *s2)
  800b75:	0f b6 08             	movzbl (%eax),%ecx
  800b78:	0f b6 1a             	movzbl (%edx),%ebx
  800b7b:	38 d9                	cmp    %bl,%cl
  800b7d:	75 08                	jne    800b87 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b7f:	83 c0 01             	add    $0x1,%eax
  800b82:	83 c2 01             	add    $0x1,%edx
  800b85:	eb ea                	jmp    800b71 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800b87:	0f b6 c1             	movzbl %cl,%eax
  800b8a:	0f b6 db             	movzbl %bl,%ebx
  800b8d:	29 d8                	sub    %ebx,%eax
  800b8f:	eb 05                	jmp    800b96 <memcmp+0x39>
	}

	return 0;
  800b91:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b96:	5b                   	pop    %ebx
  800b97:	5e                   	pop    %esi
  800b98:	5d                   	pop    %ebp
  800b99:	c3                   	ret    

00800b9a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b9a:	f3 0f 1e fb          	endbr32 
  800b9e:	55                   	push   %ebp
  800b9f:	89 e5                	mov    %esp,%ebp
  800ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ba7:	89 c2                	mov    %eax,%edx
  800ba9:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bac:	39 d0                	cmp    %edx,%eax
  800bae:	73 09                	jae    800bb9 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bb0:	38 08                	cmp    %cl,(%eax)
  800bb2:	74 05                	je     800bb9 <memfind+0x1f>
	for (; s < ends; s++)
  800bb4:	83 c0 01             	add    $0x1,%eax
  800bb7:	eb f3                	jmp    800bac <memfind+0x12>
			break;
	return (void *) s;
}
  800bb9:	5d                   	pop    %ebp
  800bba:	c3                   	ret    

00800bbb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bbb:	f3 0f 1e fb          	endbr32 
  800bbf:	55                   	push   %ebp
  800bc0:	89 e5                	mov    %esp,%ebp
  800bc2:	57                   	push   %edi
  800bc3:	56                   	push   %esi
  800bc4:	53                   	push   %ebx
  800bc5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bc8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bcb:	eb 03                	jmp    800bd0 <strtol+0x15>
		s++;
  800bcd:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bd0:	0f b6 01             	movzbl (%ecx),%eax
  800bd3:	3c 20                	cmp    $0x20,%al
  800bd5:	74 f6                	je     800bcd <strtol+0x12>
  800bd7:	3c 09                	cmp    $0x9,%al
  800bd9:	74 f2                	je     800bcd <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800bdb:	3c 2b                	cmp    $0x2b,%al
  800bdd:	74 2a                	je     800c09 <strtol+0x4e>
	int neg = 0;
  800bdf:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800be4:	3c 2d                	cmp    $0x2d,%al
  800be6:	74 2b                	je     800c13 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800be8:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bee:	75 0f                	jne    800bff <strtol+0x44>
  800bf0:	80 39 30             	cmpb   $0x30,(%ecx)
  800bf3:	74 28                	je     800c1d <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bf5:	85 db                	test   %ebx,%ebx
  800bf7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bfc:	0f 44 d8             	cmove  %eax,%ebx
  800bff:	b8 00 00 00 00       	mov    $0x0,%eax
  800c04:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c07:	eb 46                	jmp    800c4f <strtol+0x94>
		s++;
  800c09:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c0c:	bf 00 00 00 00       	mov    $0x0,%edi
  800c11:	eb d5                	jmp    800be8 <strtol+0x2d>
		s++, neg = 1;
  800c13:	83 c1 01             	add    $0x1,%ecx
  800c16:	bf 01 00 00 00       	mov    $0x1,%edi
  800c1b:	eb cb                	jmp    800be8 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c1d:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c21:	74 0e                	je     800c31 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c23:	85 db                	test   %ebx,%ebx
  800c25:	75 d8                	jne    800bff <strtol+0x44>
		s++, base = 8;
  800c27:	83 c1 01             	add    $0x1,%ecx
  800c2a:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c2f:	eb ce                	jmp    800bff <strtol+0x44>
		s += 2, base = 16;
  800c31:	83 c1 02             	add    $0x2,%ecx
  800c34:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c39:	eb c4                	jmp    800bff <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800c3b:	0f be d2             	movsbl %dl,%edx
  800c3e:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c41:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c44:	7d 3a                	jge    800c80 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c46:	83 c1 01             	add    $0x1,%ecx
  800c49:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c4d:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c4f:	0f b6 11             	movzbl (%ecx),%edx
  800c52:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c55:	89 f3                	mov    %esi,%ebx
  800c57:	80 fb 09             	cmp    $0x9,%bl
  800c5a:	76 df                	jbe    800c3b <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800c5c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c5f:	89 f3                	mov    %esi,%ebx
  800c61:	80 fb 19             	cmp    $0x19,%bl
  800c64:	77 08                	ja     800c6e <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c66:	0f be d2             	movsbl %dl,%edx
  800c69:	83 ea 57             	sub    $0x57,%edx
  800c6c:	eb d3                	jmp    800c41 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800c6e:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c71:	89 f3                	mov    %esi,%ebx
  800c73:	80 fb 19             	cmp    $0x19,%bl
  800c76:	77 08                	ja     800c80 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c78:	0f be d2             	movsbl %dl,%edx
  800c7b:	83 ea 37             	sub    $0x37,%edx
  800c7e:	eb c1                	jmp    800c41 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c80:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c84:	74 05                	je     800c8b <strtol+0xd0>
		*endptr = (char *) s;
  800c86:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c89:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c8b:	89 c2                	mov    %eax,%edx
  800c8d:	f7 da                	neg    %edx
  800c8f:	85 ff                	test   %edi,%edi
  800c91:	0f 45 c2             	cmovne %edx,%eax
}
  800c94:	5b                   	pop    %ebx
  800c95:	5e                   	pop    %esi
  800c96:	5f                   	pop    %edi
  800c97:	5d                   	pop    %ebp
  800c98:	c3                   	ret    

00800c99 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c99:	f3 0f 1e fb          	endbr32 
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
  800ca0:	57                   	push   %edi
  800ca1:	56                   	push   %esi
  800ca2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ca3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cae:	89 c3                	mov    %eax,%ebx
  800cb0:	89 c7                	mov    %eax,%edi
  800cb2:	89 c6                	mov    %eax,%esi
  800cb4:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cb6:	5b                   	pop    %ebx
  800cb7:	5e                   	pop    %esi
  800cb8:	5f                   	pop    %edi
  800cb9:	5d                   	pop    %ebp
  800cba:	c3                   	ret    

00800cbb <sys_cgetc>:

int
sys_cgetc(void)
{
  800cbb:	f3 0f 1e fb          	endbr32 
  800cbf:	55                   	push   %ebp
  800cc0:	89 e5                	mov    %esp,%ebp
  800cc2:	57                   	push   %edi
  800cc3:	56                   	push   %esi
  800cc4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cc5:	ba 00 00 00 00       	mov    $0x0,%edx
  800cca:	b8 01 00 00 00       	mov    $0x1,%eax
  800ccf:	89 d1                	mov    %edx,%ecx
  800cd1:	89 d3                	mov    %edx,%ebx
  800cd3:	89 d7                	mov    %edx,%edi
  800cd5:	89 d6                	mov    %edx,%esi
  800cd7:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cd9:	5b                   	pop    %ebx
  800cda:	5e                   	pop    %esi
  800cdb:	5f                   	pop    %edi
  800cdc:	5d                   	pop    %ebp
  800cdd:	c3                   	ret    

00800cde <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cde:	f3 0f 1e fb          	endbr32 
  800ce2:	55                   	push   %ebp
  800ce3:	89 e5                	mov    %esp,%ebp
  800ce5:	57                   	push   %edi
  800ce6:	56                   	push   %esi
  800ce7:	53                   	push   %ebx
  800ce8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ceb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cf0:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf3:	b8 03 00 00 00       	mov    $0x3,%eax
  800cf8:	89 cb                	mov    %ecx,%ebx
  800cfa:	89 cf                	mov    %ecx,%edi
  800cfc:	89 ce                	mov    %ecx,%esi
  800cfe:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d00:	85 c0                	test   %eax,%eax
  800d02:	7f 08                	jg     800d0c <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d04:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d07:	5b                   	pop    %ebx
  800d08:	5e                   	pop    %esi
  800d09:	5f                   	pop    %edi
  800d0a:	5d                   	pop    %ebp
  800d0b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0c:	83 ec 0c             	sub    $0xc,%esp
  800d0f:	50                   	push   %eax
  800d10:	6a 03                	push   $0x3
  800d12:	68 3f 2e 80 00       	push   $0x802e3f
  800d17:	6a 23                	push   $0x23
  800d19:	68 5c 2e 80 00       	push   $0x802e5c
  800d1e:	e8 13 f5 ff ff       	call   800236 <_panic>

00800d23 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d23:	f3 0f 1e fb          	endbr32 
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	57                   	push   %edi
  800d2b:	56                   	push   %esi
  800d2c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d32:	b8 02 00 00 00       	mov    $0x2,%eax
  800d37:	89 d1                	mov    %edx,%ecx
  800d39:	89 d3                	mov    %edx,%ebx
  800d3b:	89 d7                	mov    %edx,%edi
  800d3d:	89 d6                	mov    %edx,%esi
  800d3f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d41:	5b                   	pop    %ebx
  800d42:	5e                   	pop    %esi
  800d43:	5f                   	pop    %edi
  800d44:	5d                   	pop    %ebp
  800d45:	c3                   	ret    

00800d46 <sys_yield>:

void
sys_yield(void)
{
  800d46:	f3 0f 1e fb          	endbr32 
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	57                   	push   %edi
  800d4e:	56                   	push   %esi
  800d4f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d50:	ba 00 00 00 00       	mov    $0x0,%edx
  800d55:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d5a:	89 d1                	mov    %edx,%ecx
  800d5c:	89 d3                	mov    %edx,%ebx
  800d5e:	89 d7                	mov    %edx,%edi
  800d60:	89 d6                	mov    %edx,%esi
  800d62:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d64:	5b                   	pop    %ebx
  800d65:	5e                   	pop    %esi
  800d66:	5f                   	pop    %edi
  800d67:	5d                   	pop    %ebp
  800d68:	c3                   	ret    

00800d69 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d69:	f3 0f 1e fb          	endbr32 
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
  800d70:	57                   	push   %edi
  800d71:	56                   	push   %esi
  800d72:	53                   	push   %ebx
  800d73:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d76:	be 00 00 00 00       	mov    $0x0,%esi
  800d7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d81:	b8 04 00 00 00       	mov    $0x4,%eax
  800d86:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d89:	89 f7                	mov    %esi,%edi
  800d8b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8d:	85 c0                	test   %eax,%eax
  800d8f:	7f 08                	jg     800d99 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d94:	5b                   	pop    %ebx
  800d95:	5e                   	pop    %esi
  800d96:	5f                   	pop    %edi
  800d97:	5d                   	pop    %ebp
  800d98:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d99:	83 ec 0c             	sub    $0xc,%esp
  800d9c:	50                   	push   %eax
  800d9d:	6a 04                	push   $0x4
  800d9f:	68 3f 2e 80 00       	push   $0x802e3f
  800da4:	6a 23                	push   $0x23
  800da6:	68 5c 2e 80 00       	push   $0x802e5c
  800dab:	e8 86 f4 ff ff       	call   800236 <_panic>

00800db0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800db0:	f3 0f 1e fb          	endbr32 
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	57                   	push   %edi
  800db8:	56                   	push   %esi
  800db9:	53                   	push   %ebx
  800dba:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dbd:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc3:	b8 05 00 00 00       	mov    $0x5,%eax
  800dc8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dcb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dce:	8b 75 18             	mov    0x18(%ebp),%esi
  800dd1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd3:	85 c0                	test   %eax,%eax
  800dd5:	7f 08                	jg     800ddf <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dda:	5b                   	pop    %ebx
  800ddb:	5e                   	pop    %esi
  800ddc:	5f                   	pop    %edi
  800ddd:	5d                   	pop    %ebp
  800dde:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ddf:	83 ec 0c             	sub    $0xc,%esp
  800de2:	50                   	push   %eax
  800de3:	6a 05                	push   $0x5
  800de5:	68 3f 2e 80 00       	push   $0x802e3f
  800dea:	6a 23                	push   $0x23
  800dec:	68 5c 2e 80 00       	push   $0x802e5c
  800df1:	e8 40 f4 ff ff       	call   800236 <_panic>

00800df6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800df6:	f3 0f 1e fb          	endbr32 
  800dfa:	55                   	push   %ebp
  800dfb:	89 e5                	mov    %esp,%ebp
  800dfd:	57                   	push   %edi
  800dfe:	56                   	push   %esi
  800dff:	53                   	push   %ebx
  800e00:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e03:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e08:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0e:	b8 06 00 00 00       	mov    $0x6,%eax
  800e13:	89 df                	mov    %ebx,%edi
  800e15:	89 de                	mov    %ebx,%esi
  800e17:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e19:	85 c0                	test   %eax,%eax
  800e1b:	7f 08                	jg     800e25 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e20:	5b                   	pop    %ebx
  800e21:	5e                   	pop    %esi
  800e22:	5f                   	pop    %edi
  800e23:	5d                   	pop    %ebp
  800e24:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e25:	83 ec 0c             	sub    $0xc,%esp
  800e28:	50                   	push   %eax
  800e29:	6a 06                	push   $0x6
  800e2b:	68 3f 2e 80 00       	push   $0x802e3f
  800e30:	6a 23                	push   $0x23
  800e32:	68 5c 2e 80 00       	push   $0x802e5c
  800e37:	e8 fa f3 ff ff       	call   800236 <_panic>

00800e3c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e3c:	f3 0f 1e fb          	endbr32 
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	57                   	push   %edi
  800e44:	56                   	push   %esi
  800e45:	53                   	push   %ebx
  800e46:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e49:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e4e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e51:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e54:	b8 08 00 00 00       	mov    $0x8,%eax
  800e59:	89 df                	mov    %ebx,%edi
  800e5b:	89 de                	mov    %ebx,%esi
  800e5d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e5f:	85 c0                	test   %eax,%eax
  800e61:	7f 08                	jg     800e6b <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e63:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e66:	5b                   	pop    %ebx
  800e67:	5e                   	pop    %esi
  800e68:	5f                   	pop    %edi
  800e69:	5d                   	pop    %ebp
  800e6a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e6b:	83 ec 0c             	sub    $0xc,%esp
  800e6e:	50                   	push   %eax
  800e6f:	6a 08                	push   $0x8
  800e71:	68 3f 2e 80 00       	push   $0x802e3f
  800e76:	6a 23                	push   $0x23
  800e78:	68 5c 2e 80 00       	push   $0x802e5c
  800e7d:	e8 b4 f3 ff ff       	call   800236 <_panic>

00800e82 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e82:	f3 0f 1e fb          	endbr32 
  800e86:	55                   	push   %ebp
  800e87:	89 e5                	mov    %esp,%ebp
  800e89:	57                   	push   %edi
  800e8a:	56                   	push   %esi
  800e8b:	53                   	push   %ebx
  800e8c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e8f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e94:	8b 55 08             	mov    0x8(%ebp),%edx
  800e97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9a:	b8 09 00 00 00       	mov    $0x9,%eax
  800e9f:	89 df                	mov    %ebx,%edi
  800ea1:	89 de                	mov    %ebx,%esi
  800ea3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea5:	85 c0                	test   %eax,%eax
  800ea7:	7f 08                	jg     800eb1 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ea9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eac:	5b                   	pop    %ebx
  800ead:	5e                   	pop    %esi
  800eae:	5f                   	pop    %edi
  800eaf:	5d                   	pop    %ebp
  800eb0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb1:	83 ec 0c             	sub    $0xc,%esp
  800eb4:	50                   	push   %eax
  800eb5:	6a 09                	push   $0x9
  800eb7:	68 3f 2e 80 00       	push   $0x802e3f
  800ebc:	6a 23                	push   $0x23
  800ebe:	68 5c 2e 80 00       	push   $0x802e5c
  800ec3:	e8 6e f3 ff ff       	call   800236 <_panic>

00800ec8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ec8:	f3 0f 1e fb          	endbr32 
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	57                   	push   %edi
  800ed0:	56                   	push   %esi
  800ed1:	53                   	push   %ebx
  800ed2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eda:	8b 55 08             	mov    0x8(%ebp),%edx
  800edd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ee5:	89 df                	mov    %ebx,%edi
  800ee7:	89 de                	mov    %ebx,%esi
  800ee9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eeb:	85 c0                	test   %eax,%eax
  800eed:	7f 08                	jg     800ef7 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800eef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef2:	5b                   	pop    %ebx
  800ef3:	5e                   	pop    %esi
  800ef4:	5f                   	pop    %edi
  800ef5:	5d                   	pop    %ebp
  800ef6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef7:	83 ec 0c             	sub    $0xc,%esp
  800efa:	50                   	push   %eax
  800efb:	6a 0a                	push   $0xa
  800efd:	68 3f 2e 80 00       	push   $0x802e3f
  800f02:	6a 23                	push   $0x23
  800f04:	68 5c 2e 80 00       	push   $0x802e5c
  800f09:	e8 28 f3 ff ff       	call   800236 <_panic>

00800f0e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f0e:	f3 0f 1e fb          	endbr32 
  800f12:	55                   	push   %ebp
  800f13:	89 e5                	mov    %esp,%ebp
  800f15:	57                   	push   %edi
  800f16:	56                   	push   %esi
  800f17:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f18:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1e:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f23:	be 00 00 00 00       	mov    $0x0,%esi
  800f28:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f2b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f2e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f30:	5b                   	pop    %ebx
  800f31:	5e                   	pop    %esi
  800f32:	5f                   	pop    %edi
  800f33:	5d                   	pop    %ebp
  800f34:	c3                   	ret    

00800f35 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f35:	f3 0f 1e fb          	endbr32 
  800f39:	55                   	push   %ebp
  800f3a:	89 e5                	mov    %esp,%ebp
  800f3c:	57                   	push   %edi
  800f3d:	56                   	push   %esi
  800f3e:	53                   	push   %ebx
  800f3f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f42:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f47:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4a:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f4f:	89 cb                	mov    %ecx,%ebx
  800f51:	89 cf                	mov    %ecx,%edi
  800f53:	89 ce                	mov    %ecx,%esi
  800f55:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f57:	85 c0                	test   %eax,%eax
  800f59:	7f 08                	jg     800f63 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f5e:	5b                   	pop    %ebx
  800f5f:	5e                   	pop    %esi
  800f60:	5f                   	pop    %edi
  800f61:	5d                   	pop    %ebp
  800f62:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f63:	83 ec 0c             	sub    $0xc,%esp
  800f66:	50                   	push   %eax
  800f67:	6a 0d                	push   $0xd
  800f69:	68 3f 2e 80 00       	push   $0x802e3f
  800f6e:	6a 23                	push   $0x23
  800f70:	68 5c 2e 80 00       	push   $0x802e5c
  800f75:	e8 bc f2 ff ff       	call   800236 <_panic>

00800f7a <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f7a:	f3 0f 1e fb          	endbr32 
  800f7e:	55                   	push   %ebp
  800f7f:	89 e5                	mov    %esp,%ebp
  800f81:	57                   	push   %edi
  800f82:	56                   	push   %esi
  800f83:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f84:	ba 00 00 00 00       	mov    $0x0,%edx
  800f89:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f8e:	89 d1                	mov    %edx,%ecx
  800f90:	89 d3                	mov    %edx,%ebx
  800f92:	89 d7                	mov    %edx,%edi
  800f94:	89 d6                	mov    %edx,%esi
  800f96:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f98:	5b                   	pop    %ebx
  800f99:	5e                   	pop    %esi
  800f9a:	5f                   	pop    %edi
  800f9b:	5d                   	pop    %ebp
  800f9c:	c3                   	ret    

00800f9d <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  800f9d:	f3 0f 1e fb          	endbr32 
  800fa1:	55                   	push   %ebp
  800fa2:	89 e5                	mov    %esp,%ebp
  800fa4:	57                   	push   %edi
  800fa5:	56                   	push   %esi
  800fa6:	53                   	push   %ebx
  800fa7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800faa:	bb 00 00 00 00       	mov    $0x0,%ebx
  800faf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb5:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fba:	89 df                	mov    %ebx,%edi
  800fbc:	89 de                	mov    %ebx,%esi
  800fbe:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fc0:	85 c0                	test   %eax,%eax
  800fc2:	7f 08                	jg     800fcc <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  800fc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc7:	5b                   	pop    %ebx
  800fc8:	5e                   	pop    %esi
  800fc9:	5f                   	pop    %edi
  800fca:	5d                   	pop    %ebp
  800fcb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fcc:	83 ec 0c             	sub    $0xc,%esp
  800fcf:	50                   	push   %eax
  800fd0:	6a 0f                	push   $0xf
  800fd2:	68 3f 2e 80 00       	push   $0x802e3f
  800fd7:	6a 23                	push   $0x23
  800fd9:	68 5c 2e 80 00       	push   $0x802e5c
  800fde:	e8 53 f2 ff ff       	call   800236 <_panic>

00800fe3 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  800fe3:	f3 0f 1e fb          	endbr32 
  800fe7:	55                   	push   %ebp
  800fe8:	89 e5                	mov    %esp,%ebp
  800fea:	57                   	push   %edi
  800feb:	56                   	push   %esi
  800fec:	53                   	push   %ebx
  800fed:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ff0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ffb:	b8 10 00 00 00       	mov    $0x10,%eax
  801000:	89 df                	mov    %ebx,%edi
  801002:	89 de                	mov    %ebx,%esi
  801004:	cd 30                	int    $0x30
	if(check && ret > 0)
  801006:	85 c0                	test   %eax,%eax
  801008:	7f 08                	jg     801012 <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  80100a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80100d:	5b                   	pop    %ebx
  80100e:	5e                   	pop    %esi
  80100f:	5f                   	pop    %edi
  801010:	5d                   	pop    %ebp
  801011:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801012:	83 ec 0c             	sub    $0xc,%esp
  801015:	50                   	push   %eax
  801016:	6a 10                	push   $0x10
  801018:	68 3f 2e 80 00       	push   $0x802e3f
  80101d:	6a 23                	push   $0x23
  80101f:	68 5c 2e 80 00       	push   $0x802e5c
  801024:	e8 0d f2 ff ff       	call   800236 <_panic>

00801029 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801029:	f3 0f 1e fb          	endbr32 
  80102d:	55                   	push   %ebp
  80102e:	89 e5                	mov    %esp,%ebp
  801030:	53                   	push   %ebx
  801031:	83 ec 04             	sub    $0x4,%esp
  801034:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  801037:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  801039:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  80103d:	74 74                	je     8010b3 <pgfault+0x8a>
  80103f:	89 d8                	mov    %ebx,%eax
  801041:	c1 e8 0c             	shr    $0xc,%eax
  801044:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80104b:	f6 c4 08             	test   $0x8,%ah
  80104e:	74 63                	je     8010b3 <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  801050:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  801056:	83 ec 0c             	sub    $0xc,%esp
  801059:	6a 05                	push   $0x5
  80105b:	68 00 f0 7f 00       	push   $0x7ff000
  801060:	6a 00                	push   $0x0
  801062:	53                   	push   %ebx
  801063:	6a 00                	push   $0x0
  801065:	e8 46 fd ff ff       	call   800db0 <sys_page_map>
  80106a:	83 c4 20             	add    $0x20,%esp
  80106d:	85 c0                	test   %eax,%eax
  80106f:	78 59                	js     8010ca <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  801071:	83 ec 04             	sub    $0x4,%esp
  801074:	6a 07                	push   $0x7
  801076:	53                   	push   %ebx
  801077:	6a 00                	push   $0x0
  801079:	e8 eb fc ff ff       	call   800d69 <sys_page_alloc>
  80107e:	83 c4 10             	add    $0x10,%esp
  801081:	85 c0                	test   %eax,%eax
  801083:	78 5a                	js     8010df <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  801085:	83 ec 04             	sub    $0x4,%esp
  801088:	68 00 10 00 00       	push   $0x1000
  80108d:	68 00 f0 7f 00       	push   $0x7ff000
  801092:	53                   	push   %ebx
  801093:	e8 45 fa ff ff       	call   800add <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  801098:	83 c4 08             	add    $0x8,%esp
  80109b:	68 00 f0 7f 00       	push   $0x7ff000
  8010a0:	6a 00                	push   $0x0
  8010a2:	e8 4f fd ff ff       	call   800df6 <sys_page_unmap>
  8010a7:	83 c4 10             	add    $0x10,%esp
  8010aa:	85 c0                	test   %eax,%eax
  8010ac:	78 46                	js     8010f4 <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  8010ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010b1:	c9                   	leave  
  8010b2:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  8010b3:	83 ec 04             	sub    $0x4,%esp
  8010b6:	68 6a 2e 80 00       	push   $0x802e6a
  8010bb:	68 d3 00 00 00       	push   $0xd3
  8010c0:	68 86 2e 80 00       	push   $0x802e86
  8010c5:	e8 6c f1 ff ff       	call   800236 <_panic>
		panic("pgfault: %e\n", r);
  8010ca:	50                   	push   %eax
  8010cb:	68 91 2e 80 00       	push   $0x802e91
  8010d0:	68 df 00 00 00       	push   $0xdf
  8010d5:	68 86 2e 80 00       	push   $0x802e86
  8010da:	e8 57 f1 ff ff       	call   800236 <_panic>
		panic("pgfault: %e\n", r);
  8010df:	50                   	push   %eax
  8010e0:	68 91 2e 80 00       	push   $0x802e91
  8010e5:	68 e3 00 00 00       	push   $0xe3
  8010ea:	68 86 2e 80 00       	push   $0x802e86
  8010ef:	e8 42 f1 ff ff       	call   800236 <_panic>
		panic("pgfault: %e\n", r);
  8010f4:	50                   	push   %eax
  8010f5:	68 91 2e 80 00       	push   $0x802e91
  8010fa:	68 e9 00 00 00       	push   $0xe9
  8010ff:	68 86 2e 80 00       	push   $0x802e86
  801104:	e8 2d f1 ff ff       	call   800236 <_panic>

00801109 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801109:	f3 0f 1e fb          	endbr32 
  80110d:	55                   	push   %ebp
  80110e:	89 e5                	mov    %esp,%ebp
  801110:	57                   	push   %edi
  801111:	56                   	push   %esi
  801112:	53                   	push   %ebx
  801113:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  801116:	68 29 10 80 00       	push   $0x801029
  80111b:	e8 57 14 00 00       	call   802577 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801120:	b8 07 00 00 00       	mov    $0x7,%eax
  801125:	cd 30                	int    $0x30
  801127:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  80112a:	83 c4 10             	add    $0x10,%esp
  80112d:	85 c0                	test   %eax,%eax
  80112f:	78 2d                	js     80115e <fork+0x55>
  801131:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801133:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  801138:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80113c:	0f 85 9b 00 00 00    	jne    8011dd <fork+0xd4>
		thisenv = &envs[ENVX(sys_getenvid())];
  801142:	e8 dc fb ff ff       	call   800d23 <sys_getenvid>
  801147:	25 ff 03 00 00       	and    $0x3ff,%eax
  80114c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80114f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801154:	a3 20 54 80 00       	mov    %eax,0x805420
		return 0;
  801159:	e9 71 01 00 00       	jmp    8012cf <fork+0x1c6>
		panic("sys_exofork: %e", envid);
  80115e:	50                   	push   %eax
  80115f:	68 9e 2e 80 00       	push   $0x802e9e
  801164:	68 2a 01 00 00       	push   $0x12a
  801169:	68 86 2e 80 00       	push   $0x802e86
  80116e:	e8 c3 f0 ff ff       	call   800236 <_panic>
		sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_SYSCALL);
  801173:	c1 e6 0c             	shl    $0xc,%esi
  801176:	83 ec 0c             	sub    $0xc,%esp
  801179:	68 07 0e 00 00       	push   $0xe07
  80117e:	56                   	push   %esi
  80117f:	57                   	push   %edi
  801180:	56                   	push   %esi
  801181:	6a 00                	push   $0x0
  801183:	e8 28 fc ff ff       	call   800db0 <sys_page_map>
  801188:	83 c4 20             	add    $0x20,%esp
  80118b:	eb 3e                	jmp    8011cb <fork+0xc2>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  80118d:	c1 e6 0c             	shl    $0xc,%esi
  801190:	83 ec 0c             	sub    $0xc,%esp
  801193:	68 05 08 00 00       	push   $0x805
  801198:	56                   	push   %esi
  801199:	57                   	push   %edi
  80119a:	56                   	push   %esi
  80119b:	6a 00                	push   $0x0
  80119d:	e8 0e fc ff ff       	call   800db0 <sys_page_map>
  8011a2:	83 c4 20             	add    $0x20,%esp
  8011a5:	85 c0                	test   %eax,%eax
  8011a7:	0f 88 bc 00 00 00    	js     801269 <fork+0x160>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  8011ad:	83 ec 0c             	sub    $0xc,%esp
  8011b0:	68 05 08 00 00       	push   $0x805
  8011b5:	56                   	push   %esi
  8011b6:	6a 00                	push   $0x0
  8011b8:	56                   	push   %esi
  8011b9:	6a 00                	push   $0x0
  8011bb:	e8 f0 fb ff ff       	call   800db0 <sys_page_map>
  8011c0:	83 c4 20             	add    $0x20,%esp
  8011c3:	85 c0                	test   %eax,%eax
  8011c5:	0f 88 b3 00 00 00    	js     80127e <fork+0x175>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8011cb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8011d1:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8011d7:	0f 84 b6 00 00 00    	je     801293 <fork+0x18a>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  8011dd:	89 d8                	mov    %ebx,%eax
  8011df:	c1 e8 16             	shr    $0x16,%eax
  8011e2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011e9:	a8 01                	test   $0x1,%al
  8011eb:	74 de                	je     8011cb <fork+0xc2>
  8011ed:	89 de                	mov    %ebx,%esi
  8011ef:	c1 ee 0c             	shr    $0xc,%esi
  8011f2:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011f9:	a8 01                	test   $0x1,%al
  8011fb:	74 ce                	je     8011cb <fork+0xc2>
  8011fd:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801204:	a8 04                	test   $0x4,%al
  801206:	74 c3                	je     8011cb <fork+0xc2>
	if ((uvpt[pn] & PTE_SHARE)){
  801208:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80120f:	f6 c4 04             	test   $0x4,%ah
  801212:	0f 85 5b ff ff ff    	jne    801173 <fork+0x6a>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  801218:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80121f:	a8 02                	test   $0x2,%al
  801221:	0f 85 66 ff ff ff    	jne    80118d <fork+0x84>
  801227:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80122e:	f6 c4 08             	test   $0x8,%ah
  801231:	0f 85 56 ff ff ff    	jne    80118d <fork+0x84>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  801237:	c1 e6 0c             	shl    $0xc,%esi
  80123a:	83 ec 0c             	sub    $0xc,%esp
  80123d:	6a 05                	push   $0x5
  80123f:	56                   	push   %esi
  801240:	57                   	push   %edi
  801241:	56                   	push   %esi
  801242:	6a 00                	push   $0x0
  801244:	e8 67 fb ff ff       	call   800db0 <sys_page_map>
  801249:	83 c4 20             	add    $0x20,%esp
  80124c:	85 c0                	test   %eax,%eax
  80124e:	0f 89 77 ff ff ff    	jns    8011cb <fork+0xc2>
		panic("duppage: %e\n", r);
  801254:	50                   	push   %eax
  801255:	68 ae 2e 80 00       	push   $0x802eae
  80125a:	68 0c 01 00 00       	push   $0x10c
  80125f:	68 86 2e 80 00       	push   $0x802e86
  801264:	e8 cd ef ff ff       	call   800236 <_panic>
			panic("duppage: %e\n", r);
  801269:	50                   	push   %eax
  80126a:	68 ae 2e 80 00       	push   $0x802eae
  80126f:	68 05 01 00 00       	push   $0x105
  801274:	68 86 2e 80 00       	push   $0x802e86
  801279:	e8 b8 ef ff ff       	call   800236 <_panic>
			panic("duppage: %e\n", r);
  80127e:	50                   	push   %eax
  80127f:	68 ae 2e 80 00       	push   $0x802eae
  801284:	68 09 01 00 00       	push   $0x109
  801289:	68 86 2e 80 00       	push   $0x802e86
  80128e:	e8 a3 ef ff ff       	call   800236 <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  801293:	83 ec 04             	sub    $0x4,%esp
  801296:	6a 07                	push   $0x7
  801298:	68 00 f0 bf ee       	push   $0xeebff000
  80129d:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012a0:	e8 c4 fa ff ff       	call   800d69 <sys_page_alloc>
  8012a5:	83 c4 10             	add    $0x10,%esp
  8012a8:	85 c0                	test   %eax,%eax
  8012aa:	78 2e                	js     8012da <fork+0x1d1>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8012ac:	83 ec 08             	sub    $0x8,%esp
  8012af:	68 ea 25 80 00       	push   $0x8025ea
  8012b4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8012b7:	57                   	push   %edi
  8012b8:	e8 0b fc ff ff       	call   800ec8 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8012bd:	83 c4 08             	add    $0x8,%esp
  8012c0:	6a 02                	push   $0x2
  8012c2:	57                   	push   %edi
  8012c3:	e8 74 fb ff ff       	call   800e3c <sys_env_set_status>
  8012c8:	83 c4 10             	add    $0x10,%esp
  8012cb:	85 c0                	test   %eax,%eax
  8012cd:	78 20                	js     8012ef <fork+0x1e6>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  8012cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012d5:	5b                   	pop    %ebx
  8012d6:	5e                   	pop    %esi
  8012d7:	5f                   	pop    %edi
  8012d8:	5d                   	pop    %ebp
  8012d9:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  8012da:	50                   	push   %eax
  8012db:	68 bb 2e 80 00       	push   $0x802ebb
  8012e0:	68 3e 01 00 00       	push   $0x13e
  8012e5:	68 86 2e 80 00       	push   $0x802e86
  8012ea:	e8 47 ef ff ff       	call   800236 <_panic>
		panic("sys_env_set_status: %e", r);
  8012ef:	50                   	push   %eax
  8012f0:	68 ce 2e 80 00       	push   $0x802ece
  8012f5:	68 43 01 00 00       	push   $0x143
  8012fa:	68 86 2e 80 00       	push   $0x802e86
  8012ff:	e8 32 ef ff ff       	call   800236 <_panic>

00801304 <sfork>:

// Challenge!
int
sfork(void)
{
  801304:	f3 0f 1e fb          	endbr32 
  801308:	55                   	push   %ebp
  801309:	89 e5                	mov    %esp,%ebp
  80130b:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80130e:	68 e5 2e 80 00       	push   $0x802ee5
  801313:	68 4c 01 00 00       	push   $0x14c
  801318:	68 86 2e 80 00       	push   $0x802e86
  80131d:	e8 14 ef ff ff       	call   800236 <_panic>

00801322 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801322:	f3 0f 1e fb          	endbr32 
  801326:	55                   	push   %ebp
  801327:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	05 00 00 00 30       	add    $0x30000000,%eax
  801331:	c1 e8 0c             	shr    $0xc,%eax
}
  801334:	5d                   	pop    %ebp
  801335:	c3                   	ret    

00801336 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801336:	f3 0f 1e fb          	endbr32 
  80133a:	55                   	push   %ebp
  80133b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80133d:	8b 45 08             	mov    0x8(%ebp),%eax
  801340:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801345:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80134a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80134f:	5d                   	pop    %ebp
  801350:	c3                   	ret    

00801351 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801351:	f3 0f 1e fb          	endbr32 
  801355:	55                   	push   %ebp
  801356:	89 e5                	mov    %esp,%ebp
  801358:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80135d:	89 c2                	mov    %eax,%edx
  80135f:	c1 ea 16             	shr    $0x16,%edx
  801362:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801369:	f6 c2 01             	test   $0x1,%dl
  80136c:	74 2d                	je     80139b <fd_alloc+0x4a>
  80136e:	89 c2                	mov    %eax,%edx
  801370:	c1 ea 0c             	shr    $0xc,%edx
  801373:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80137a:	f6 c2 01             	test   $0x1,%dl
  80137d:	74 1c                	je     80139b <fd_alloc+0x4a>
  80137f:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801384:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801389:	75 d2                	jne    80135d <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80138b:	8b 45 08             	mov    0x8(%ebp),%eax
  80138e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801394:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801399:	eb 0a                	jmp    8013a5 <fd_alloc+0x54>
			*fd_store = fd;
  80139b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80139e:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013a5:	5d                   	pop    %ebp
  8013a6:	c3                   	ret    

008013a7 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8013a7:	f3 0f 1e fb          	endbr32 
  8013ab:	55                   	push   %ebp
  8013ac:	89 e5                	mov    %esp,%ebp
  8013ae:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8013b1:	83 f8 1f             	cmp    $0x1f,%eax
  8013b4:	77 30                	ja     8013e6 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8013b6:	c1 e0 0c             	shl    $0xc,%eax
  8013b9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8013be:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8013c4:	f6 c2 01             	test   $0x1,%dl
  8013c7:	74 24                	je     8013ed <fd_lookup+0x46>
  8013c9:	89 c2                	mov    %eax,%edx
  8013cb:	c1 ea 0c             	shr    $0xc,%edx
  8013ce:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013d5:	f6 c2 01             	test   $0x1,%dl
  8013d8:	74 1a                	je     8013f4 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8013da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013dd:	89 02                	mov    %eax,(%edx)
	return 0;
  8013df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013e4:	5d                   	pop    %ebp
  8013e5:	c3                   	ret    
		return -E_INVAL;
  8013e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013eb:	eb f7                	jmp    8013e4 <fd_lookup+0x3d>
		return -E_INVAL;
  8013ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013f2:	eb f0                	jmp    8013e4 <fd_lookup+0x3d>
  8013f4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013f9:	eb e9                	jmp    8013e4 <fd_lookup+0x3d>

008013fb <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013fb:	f3 0f 1e fb          	endbr32 
  8013ff:	55                   	push   %ebp
  801400:	89 e5                	mov    %esp,%ebp
  801402:	83 ec 08             	sub    $0x8,%esp
  801405:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801408:	ba 00 00 00 00       	mov    $0x0,%edx
  80140d:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801412:	39 08                	cmp    %ecx,(%eax)
  801414:	74 38                	je     80144e <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  801416:	83 c2 01             	add    $0x1,%edx
  801419:	8b 04 95 78 2f 80 00 	mov    0x802f78(,%edx,4),%eax
  801420:	85 c0                	test   %eax,%eax
  801422:	75 ee                	jne    801412 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801424:	a1 20 54 80 00       	mov    0x805420,%eax
  801429:	8b 40 48             	mov    0x48(%eax),%eax
  80142c:	83 ec 04             	sub    $0x4,%esp
  80142f:	51                   	push   %ecx
  801430:	50                   	push   %eax
  801431:	68 fc 2e 80 00       	push   $0x802efc
  801436:	e8 e2 ee ff ff       	call   80031d <cprintf>
	*dev = 0;
  80143b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801444:	83 c4 10             	add    $0x10,%esp
  801447:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80144c:	c9                   	leave  
  80144d:	c3                   	ret    
			*dev = devtab[i];
  80144e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801451:	89 01                	mov    %eax,(%ecx)
			return 0;
  801453:	b8 00 00 00 00       	mov    $0x0,%eax
  801458:	eb f2                	jmp    80144c <dev_lookup+0x51>

0080145a <fd_close>:
{
  80145a:	f3 0f 1e fb          	endbr32 
  80145e:	55                   	push   %ebp
  80145f:	89 e5                	mov    %esp,%ebp
  801461:	57                   	push   %edi
  801462:	56                   	push   %esi
  801463:	53                   	push   %ebx
  801464:	83 ec 24             	sub    $0x24,%esp
  801467:	8b 75 08             	mov    0x8(%ebp),%esi
  80146a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80146d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801470:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801471:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801477:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80147a:	50                   	push   %eax
  80147b:	e8 27 ff ff ff       	call   8013a7 <fd_lookup>
  801480:	89 c3                	mov    %eax,%ebx
  801482:	83 c4 10             	add    $0x10,%esp
  801485:	85 c0                	test   %eax,%eax
  801487:	78 05                	js     80148e <fd_close+0x34>
	    || fd != fd2)
  801489:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80148c:	74 16                	je     8014a4 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80148e:	89 f8                	mov    %edi,%eax
  801490:	84 c0                	test   %al,%al
  801492:	b8 00 00 00 00       	mov    $0x0,%eax
  801497:	0f 44 d8             	cmove  %eax,%ebx
}
  80149a:	89 d8                	mov    %ebx,%eax
  80149c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80149f:	5b                   	pop    %ebx
  8014a0:	5e                   	pop    %esi
  8014a1:	5f                   	pop    %edi
  8014a2:	5d                   	pop    %ebp
  8014a3:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8014a4:	83 ec 08             	sub    $0x8,%esp
  8014a7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8014aa:	50                   	push   %eax
  8014ab:	ff 36                	pushl  (%esi)
  8014ad:	e8 49 ff ff ff       	call   8013fb <dev_lookup>
  8014b2:	89 c3                	mov    %eax,%ebx
  8014b4:	83 c4 10             	add    $0x10,%esp
  8014b7:	85 c0                	test   %eax,%eax
  8014b9:	78 1a                	js     8014d5 <fd_close+0x7b>
		if (dev->dev_close)
  8014bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014be:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8014c1:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8014c6:	85 c0                	test   %eax,%eax
  8014c8:	74 0b                	je     8014d5 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8014ca:	83 ec 0c             	sub    $0xc,%esp
  8014cd:	56                   	push   %esi
  8014ce:	ff d0                	call   *%eax
  8014d0:	89 c3                	mov    %eax,%ebx
  8014d2:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8014d5:	83 ec 08             	sub    $0x8,%esp
  8014d8:	56                   	push   %esi
  8014d9:	6a 00                	push   $0x0
  8014db:	e8 16 f9 ff ff       	call   800df6 <sys_page_unmap>
	return r;
  8014e0:	83 c4 10             	add    $0x10,%esp
  8014e3:	eb b5                	jmp    80149a <fd_close+0x40>

008014e5 <close>:

int
close(int fdnum)
{
  8014e5:	f3 0f 1e fb          	endbr32 
  8014e9:	55                   	push   %ebp
  8014ea:	89 e5                	mov    %esp,%ebp
  8014ec:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f2:	50                   	push   %eax
  8014f3:	ff 75 08             	pushl  0x8(%ebp)
  8014f6:	e8 ac fe ff ff       	call   8013a7 <fd_lookup>
  8014fb:	83 c4 10             	add    $0x10,%esp
  8014fe:	85 c0                	test   %eax,%eax
  801500:	79 02                	jns    801504 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801502:	c9                   	leave  
  801503:	c3                   	ret    
		return fd_close(fd, 1);
  801504:	83 ec 08             	sub    $0x8,%esp
  801507:	6a 01                	push   $0x1
  801509:	ff 75 f4             	pushl  -0xc(%ebp)
  80150c:	e8 49 ff ff ff       	call   80145a <fd_close>
  801511:	83 c4 10             	add    $0x10,%esp
  801514:	eb ec                	jmp    801502 <close+0x1d>

00801516 <close_all>:

void
close_all(void)
{
  801516:	f3 0f 1e fb          	endbr32 
  80151a:	55                   	push   %ebp
  80151b:	89 e5                	mov    %esp,%ebp
  80151d:	53                   	push   %ebx
  80151e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801521:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801526:	83 ec 0c             	sub    $0xc,%esp
  801529:	53                   	push   %ebx
  80152a:	e8 b6 ff ff ff       	call   8014e5 <close>
	for (i = 0; i < MAXFD; i++)
  80152f:	83 c3 01             	add    $0x1,%ebx
  801532:	83 c4 10             	add    $0x10,%esp
  801535:	83 fb 20             	cmp    $0x20,%ebx
  801538:	75 ec                	jne    801526 <close_all+0x10>
}
  80153a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80153d:	c9                   	leave  
  80153e:	c3                   	ret    

0080153f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80153f:	f3 0f 1e fb          	endbr32 
  801543:	55                   	push   %ebp
  801544:	89 e5                	mov    %esp,%ebp
  801546:	57                   	push   %edi
  801547:	56                   	push   %esi
  801548:	53                   	push   %ebx
  801549:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80154c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80154f:	50                   	push   %eax
  801550:	ff 75 08             	pushl  0x8(%ebp)
  801553:	e8 4f fe ff ff       	call   8013a7 <fd_lookup>
  801558:	89 c3                	mov    %eax,%ebx
  80155a:	83 c4 10             	add    $0x10,%esp
  80155d:	85 c0                	test   %eax,%eax
  80155f:	0f 88 81 00 00 00    	js     8015e6 <dup+0xa7>
		return r;
	close(newfdnum);
  801565:	83 ec 0c             	sub    $0xc,%esp
  801568:	ff 75 0c             	pushl  0xc(%ebp)
  80156b:	e8 75 ff ff ff       	call   8014e5 <close>

	newfd = INDEX2FD(newfdnum);
  801570:	8b 75 0c             	mov    0xc(%ebp),%esi
  801573:	c1 e6 0c             	shl    $0xc,%esi
  801576:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80157c:	83 c4 04             	add    $0x4,%esp
  80157f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801582:	e8 af fd ff ff       	call   801336 <fd2data>
  801587:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801589:	89 34 24             	mov    %esi,(%esp)
  80158c:	e8 a5 fd ff ff       	call   801336 <fd2data>
  801591:	83 c4 10             	add    $0x10,%esp
  801594:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801596:	89 d8                	mov    %ebx,%eax
  801598:	c1 e8 16             	shr    $0x16,%eax
  80159b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015a2:	a8 01                	test   $0x1,%al
  8015a4:	74 11                	je     8015b7 <dup+0x78>
  8015a6:	89 d8                	mov    %ebx,%eax
  8015a8:	c1 e8 0c             	shr    $0xc,%eax
  8015ab:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8015b2:	f6 c2 01             	test   $0x1,%dl
  8015b5:	75 39                	jne    8015f0 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015ba:	89 d0                	mov    %edx,%eax
  8015bc:	c1 e8 0c             	shr    $0xc,%eax
  8015bf:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015c6:	83 ec 0c             	sub    $0xc,%esp
  8015c9:	25 07 0e 00 00       	and    $0xe07,%eax
  8015ce:	50                   	push   %eax
  8015cf:	56                   	push   %esi
  8015d0:	6a 00                	push   $0x0
  8015d2:	52                   	push   %edx
  8015d3:	6a 00                	push   $0x0
  8015d5:	e8 d6 f7 ff ff       	call   800db0 <sys_page_map>
  8015da:	89 c3                	mov    %eax,%ebx
  8015dc:	83 c4 20             	add    $0x20,%esp
  8015df:	85 c0                	test   %eax,%eax
  8015e1:	78 31                	js     801614 <dup+0xd5>
		goto err;

	return newfdnum;
  8015e3:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8015e6:	89 d8                	mov    %ebx,%eax
  8015e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015eb:	5b                   	pop    %ebx
  8015ec:	5e                   	pop    %esi
  8015ed:	5f                   	pop    %edi
  8015ee:	5d                   	pop    %ebp
  8015ef:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015f0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015f7:	83 ec 0c             	sub    $0xc,%esp
  8015fa:	25 07 0e 00 00       	and    $0xe07,%eax
  8015ff:	50                   	push   %eax
  801600:	57                   	push   %edi
  801601:	6a 00                	push   $0x0
  801603:	53                   	push   %ebx
  801604:	6a 00                	push   $0x0
  801606:	e8 a5 f7 ff ff       	call   800db0 <sys_page_map>
  80160b:	89 c3                	mov    %eax,%ebx
  80160d:	83 c4 20             	add    $0x20,%esp
  801610:	85 c0                	test   %eax,%eax
  801612:	79 a3                	jns    8015b7 <dup+0x78>
	sys_page_unmap(0, newfd);
  801614:	83 ec 08             	sub    $0x8,%esp
  801617:	56                   	push   %esi
  801618:	6a 00                	push   $0x0
  80161a:	e8 d7 f7 ff ff       	call   800df6 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80161f:	83 c4 08             	add    $0x8,%esp
  801622:	57                   	push   %edi
  801623:	6a 00                	push   $0x0
  801625:	e8 cc f7 ff ff       	call   800df6 <sys_page_unmap>
	return r;
  80162a:	83 c4 10             	add    $0x10,%esp
  80162d:	eb b7                	jmp    8015e6 <dup+0xa7>

0080162f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80162f:	f3 0f 1e fb          	endbr32 
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	53                   	push   %ebx
  801637:	83 ec 1c             	sub    $0x1c,%esp
  80163a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80163d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801640:	50                   	push   %eax
  801641:	53                   	push   %ebx
  801642:	e8 60 fd ff ff       	call   8013a7 <fd_lookup>
  801647:	83 c4 10             	add    $0x10,%esp
  80164a:	85 c0                	test   %eax,%eax
  80164c:	78 3f                	js     80168d <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80164e:	83 ec 08             	sub    $0x8,%esp
  801651:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801654:	50                   	push   %eax
  801655:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801658:	ff 30                	pushl  (%eax)
  80165a:	e8 9c fd ff ff       	call   8013fb <dev_lookup>
  80165f:	83 c4 10             	add    $0x10,%esp
  801662:	85 c0                	test   %eax,%eax
  801664:	78 27                	js     80168d <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801666:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801669:	8b 42 08             	mov    0x8(%edx),%eax
  80166c:	83 e0 03             	and    $0x3,%eax
  80166f:	83 f8 01             	cmp    $0x1,%eax
  801672:	74 1e                	je     801692 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801677:	8b 40 08             	mov    0x8(%eax),%eax
  80167a:	85 c0                	test   %eax,%eax
  80167c:	74 35                	je     8016b3 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80167e:	83 ec 04             	sub    $0x4,%esp
  801681:	ff 75 10             	pushl  0x10(%ebp)
  801684:	ff 75 0c             	pushl  0xc(%ebp)
  801687:	52                   	push   %edx
  801688:	ff d0                	call   *%eax
  80168a:	83 c4 10             	add    $0x10,%esp
}
  80168d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801690:	c9                   	leave  
  801691:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801692:	a1 20 54 80 00       	mov    0x805420,%eax
  801697:	8b 40 48             	mov    0x48(%eax),%eax
  80169a:	83 ec 04             	sub    $0x4,%esp
  80169d:	53                   	push   %ebx
  80169e:	50                   	push   %eax
  80169f:	68 3d 2f 80 00       	push   $0x802f3d
  8016a4:	e8 74 ec ff ff       	call   80031d <cprintf>
		return -E_INVAL;
  8016a9:	83 c4 10             	add    $0x10,%esp
  8016ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016b1:	eb da                	jmp    80168d <read+0x5e>
		return -E_NOT_SUPP;
  8016b3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016b8:	eb d3                	jmp    80168d <read+0x5e>

008016ba <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8016ba:	f3 0f 1e fb          	endbr32 
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
  8016c1:	57                   	push   %edi
  8016c2:	56                   	push   %esi
  8016c3:	53                   	push   %ebx
  8016c4:	83 ec 0c             	sub    $0xc,%esp
  8016c7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016ca:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016cd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016d2:	eb 02                	jmp    8016d6 <readn+0x1c>
  8016d4:	01 c3                	add    %eax,%ebx
  8016d6:	39 f3                	cmp    %esi,%ebx
  8016d8:	73 21                	jae    8016fb <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016da:	83 ec 04             	sub    $0x4,%esp
  8016dd:	89 f0                	mov    %esi,%eax
  8016df:	29 d8                	sub    %ebx,%eax
  8016e1:	50                   	push   %eax
  8016e2:	89 d8                	mov    %ebx,%eax
  8016e4:	03 45 0c             	add    0xc(%ebp),%eax
  8016e7:	50                   	push   %eax
  8016e8:	57                   	push   %edi
  8016e9:	e8 41 ff ff ff       	call   80162f <read>
		if (m < 0)
  8016ee:	83 c4 10             	add    $0x10,%esp
  8016f1:	85 c0                	test   %eax,%eax
  8016f3:	78 04                	js     8016f9 <readn+0x3f>
			return m;
		if (m == 0)
  8016f5:	75 dd                	jne    8016d4 <readn+0x1a>
  8016f7:	eb 02                	jmp    8016fb <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016f9:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8016fb:	89 d8                	mov    %ebx,%eax
  8016fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801700:	5b                   	pop    %ebx
  801701:	5e                   	pop    %esi
  801702:	5f                   	pop    %edi
  801703:	5d                   	pop    %ebp
  801704:	c3                   	ret    

00801705 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801705:	f3 0f 1e fb          	endbr32 
  801709:	55                   	push   %ebp
  80170a:	89 e5                	mov    %esp,%ebp
  80170c:	53                   	push   %ebx
  80170d:	83 ec 1c             	sub    $0x1c,%esp
  801710:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801713:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801716:	50                   	push   %eax
  801717:	53                   	push   %ebx
  801718:	e8 8a fc ff ff       	call   8013a7 <fd_lookup>
  80171d:	83 c4 10             	add    $0x10,%esp
  801720:	85 c0                	test   %eax,%eax
  801722:	78 3a                	js     80175e <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801724:	83 ec 08             	sub    $0x8,%esp
  801727:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80172a:	50                   	push   %eax
  80172b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80172e:	ff 30                	pushl  (%eax)
  801730:	e8 c6 fc ff ff       	call   8013fb <dev_lookup>
  801735:	83 c4 10             	add    $0x10,%esp
  801738:	85 c0                	test   %eax,%eax
  80173a:	78 22                	js     80175e <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80173c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80173f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801743:	74 1e                	je     801763 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801745:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801748:	8b 52 0c             	mov    0xc(%edx),%edx
  80174b:	85 d2                	test   %edx,%edx
  80174d:	74 35                	je     801784 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80174f:	83 ec 04             	sub    $0x4,%esp
  801752:	ff 75 10             	pushl  0x10(%ebp)
  801755:	ff 75 0c             	pushl  0xc(%ebp)
  801758:	50                   	push   %eax
  801759:	ff d2                	call   *%edx
  80175b:	83 c4 10             	add    $0x10,%esp
}
  80175e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801761:	c9                   	leave  
  801762:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801763:	a1 20 54 80 00       	mov    0x805420,%eax
  801768:	8b 40 48             	mov    0x48(%eax),%eax
  80176b:	83 ec 04             	sub    $0x4,%esp
  80176e:	53                   	push   %ebx
  80176f:	50                   	push   %eax
  801770:	68 59 2f 80 00       	push   $0x802f59
  801775:	e8 a3 eb ff ff       	call   80031d <cprintf>
		return -E_INVAL;
  80177a:	83 c4 10             	add    $0x10,%esp
  80177d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801782:	eb da                	jmp    80175e <write+0x59>
		return -E_NOT_SUPP;
  801784:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801789:	eb d3                	jmp    80175e <write+0x59>

0080178b <seek>:

int
seek(int fdnum, off_t offset)
{
  80178b:	f3 0f 1e fb          	endbr32 
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
  801792:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801795:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801798:	50                   	push   %eax
  801799:	ff 75 08             	pushl  0x8(%ebp)
  80179c:	e8 06 fc ff ff       	call   8013a7 <fd_lookup>
  8017a1:	83 c4 10             	add    $0x10,%esp
  8017a4:	85 c0                	test   %eax,%eax
  8017a6:	78 0e                	js     8017b6 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8017a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ae:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8017b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017b6:	c9                   	leave  
  8017b7:	c3                   	ret    

008017b8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8017b8:	f3 0f 1e fb          	endbr32 
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
  8017bf:	53                   	push   %ebx
  8017c0:	83 ec 1c             	sub    $0x1c,%esp
  8017c3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017c6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017c9:	50                   	push   %eax
  8017ca:	53                   	push   %ebx
  8017cb:	e8 d7 fb ff ff       	call   8013a7 <fd_lookup>
  8017d0:	83 c4 10             	add    $0x10,%esp
  8017d3:	85 c0                	test   %eax,%eax
  8017d5:	78 37                	js     80180e <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017d7:	83 ec 08             	sub    $0x8,%esp
  8017da:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017dd:	50                   	push   %eax
  8017de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e1:	ff 30                	pushl  (%eax)
  8017e3:	e8 13 fc ff ff       	call   8013fb <dev_lookup>
  8017e8:	83 c4 10             	add    $0x10,%esp
  8017eb:	85 c0                	test   %eax,%eax
  8017ed:	78 1f                	js     80180e <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017f6:	74 1b                	je     801813 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8017f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017fb:	8b 52 18             	mov    0x18(%edx),%edx
  8017fe:	85 d2                	test   %edx,%edx
  801800:	74 32                	je     801834 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801802:	83 ec 08             	sub    $0x8,%esp
  801805:	ff 75 0c             	pushl  0xc(%ebp)
  801808:	50                   	push   %eax
  801809:	ff d2                	call   *%edx
  80180b:	83 c4 10             	add    $0x10,%esp
}
  80180e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801811:	c9                   	leave  
  801812:	c3                   	ret    
			thisenv->env_id, fdnum);
  801813:	a1 20 54 80 00       	mov    0x805420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801818:	8b 40 48             	mov    0x48(%eax),%eax
  80181b:	83 ec 04             	sub    $0x4,%esp
  80181e:	53                   	push   %ebx
  80181f:	50                   	push   %eax
  801820:	68 1c 2f 80 00       	push   $0x802f1c
  801825:	e8 f3 ea ff ff       	call   80031d <cprintf>
		return -E_INVAL;
  80182a:	83 c4 10             	add    $0x10,%esp
  80182d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801832:	eb da                	jmp    80180e <ftruncate+0x56>
		return -E_NOT_SUPP;
  801834:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801839:	eb d3                	jmp    80180e <ftruncate+0x56>

0080183b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80183b:	f3 0f 1e fb          	endbr32 
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
  801842:	53                   	push   %ebx
  801843:	83 ec 1c             	sub    $0x1c,%esp
  801846:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801849:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80184c:	50                   	push   %eax
  80184d:	ff 75 08             	pushl  0x8(%ebp)
  801850:	e8 52 fb ff ff       	call   8013a7 <fd_lookup>
  801855:	83 c4 10             	add    $0x10,%esp
  801858:	85 c0                	test   %eax,%eax
  80185a:	78 4b                	js     8018a7 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80185c:	83 ec 08             	sub    $0x8,%esp
  80185f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801862:	50                   	push   %eax
  801863:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801866:	ff 30                	pushl  (%eax)
  801868:	e8 8e fb ff ff       	call   8013fb <dev_lookup>
  80186d:	83 c4 10             	add    $0x10,%esp
  801870:	85 c0                	test   %eax,%eax
  801872:	78 33                	js     8018a7 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801877:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80187b:	74 2f                	je     8018ac <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80187d:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801880:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801887:	00 00 00 
	stat->st_isdir = 0;
  80188a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801891:	00 00 00 
	stat->st_dev = dev;
  801894:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80189a:	83 ec 08             	sub    $0x8,%esp
  80189d:	53                   	push   %ebx
  80189e:	ff 75 f0             	pushl  -0x10(%ebp)
  8018a1:	ff 50 14             	call   *0x14(%eax)
  8018a4:	83 c4 10             	add    $0x10,%esp
}
  8018a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018aa:	c9                   	leave  
  8018ab:	c3                   	ret    
		return -E_NOT_SUPP;
  8018ac:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018b1:	eb f4                	jmp    8018a7 <fstat+0x6c>

008018b3 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8018b3:	f3 0f 1e fb          	endbr32 
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	56                   	push   %esi
  8018bb:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018bc:	83 ec 08             	sub    $0x8,%esp
  8018bf:	6a 00                	push   $0x0
  8018c1:	ff 75 08             	pushl  0x8(%ebp)
  8018c4:	e8 fb 01 00 00       	call   801ac4 <open>
  8018c9:	89 c3                	mov    %eax,%ebx
  8018cb:	83 c4 10             	add    $0x10,%esp
  8018ce:	85 c0                	test   %eax,%eax
  8018d0:	78 1b                	js     8018ed <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8018d2:	83 ec 08             	sub    $0x8,%esp
  8018d5:	ff 75 0c             	pushl  0xc(%ebp)
  8018d8:	50                   	push   %eax
  8018d9:	e8 5d ff ff ff       	call   80183b <fstat>
  8018de:	89 c6                	mov    %eax,%esi
	close(fd);
  8018e0:	89 1c 24             	mov    %ebx,(%esp)
  8018e3:	e8 fd fb ff ff       	call   8014e5 <close>
	return r;
  8018e8:	83 c4 10             	add    $0x10,%esp
  8018eb:	89 f3                	mov    %esi,%ebx
}
  8018ed:	89 d8                	mov    %ebx,%eax
  8018ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018f2:	5b                   	pop    %ebx
  8018f3:	5e                   	pop    %esi
  8018f4:	5d                   	pop    %ebp
  8018f5:	c3                   	ret    

008018f6 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
  8018f9:	56                   	push   %esi
  8018fa:	53                   	push   %ebx
  8018fb:	89 c6                	mov    %eax,%esi
  8018fd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8018ff:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801906:	74 27                	je     80192f <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801908:	6a 07                	push   $0x7
  80190a:	68 00 60 80 00       	push   $0x806000
  80190f:	56                   	push   %esi
  801910:	ff 35 00 50 80 00    	pushl  0x805000
  801916:	e8 7a 0d 00 00       	call   802695 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80191b:	83 c4 0c             	add    $0xc,%esp
  80191e:	6a 00                	push   $0x0
  801920:	53                   	push   %ebx
  801921:	6a 00                	push   $0x0
  801923:	e8 e8 0c 00 00       	call   802610 <ipc_recv>
}
  801928:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80192b:	5b                   	pop    %ebx
  80192c:	5e                   	pop    %esi
  80192d:	5d                   	pop    %ebp
  80192e:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80192f:	83 ec 0c             	sub    $0xc,%esp
  801932:	6a 01                	push   $0x1
  801934:	e8 b4 0d 00 00       	call   8026ed <ipc_find_env>
  801939:	a3 00 50 80 00       	mov    %eax,0x805000
  80193e:	83 c4 10             	add    $0x10,%esp
  801941:	eb c5                	jmp    801908 <fsipc+0x12>

00801943 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801943:	f3 0f 1e fb          	endbr32 
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
  80194a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80194d:	8b 45 08             	mov    0x8(%ebp),%eax
  801950:	8b 40 0c             	mov    0xc(%eax),%eax
  801953:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801958:	8b 45 0c             	mov    0xc(%ebp),%eax
  80195b:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801960:	ba 00 00 00 00       	mov    $0x0,%edx
  801965:	b8 02 00 00 00       	mov    $0x2,%eax
  80196a:	e8 87 ff ff ff       	call   8018f6 <fsipc>
}
  80196f:	c9                   	leave  
  801970:	c3                   	ret    

00801971 <devfile_flush>:
{
  801971:	f3 0f 1e fb          	endbr32 
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
  801978:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80197b:	8b 45 08             	mov    0x8(%ebp),%eax
  80197e:	8b 40 0c             	mov    0xc(%eax),%eax
  801981:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801986:	ba 00 00 00 00       	mov    $0x0,%edx
  80198b:	b8 06 00 00 00       	mov    $0x6,%eax
  801990:	e8 61 ff ff ff       	call   8018f6 <fsipc>
}
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <devfile_stat>:
{
  801997:	f3 0f 1e fb          	endbr32 
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
  80199e:	53                   	push   %ebx
  80199f:	83 ec 04             	sub    $0x4,%esp
  8019a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8019a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8019ab:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8019b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b5:	b8 05 00 00 00       	mov    $0x5,%eax
  8019ba:	e8 37 ff ff ff       	call   8018f6 <fsipc>
  8019bf:	85 c0                	test   %eax,%eax
  8019c1:	78 2c                	js     8019ef <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019c3:	83 ec 08             	sub    $0x8,%esp
  8019c6:	68 00 60 80 00       	push   $0x806000
  8019cb:	53                   	push   %ebx
  8019cc:	e8 56 ef ff ff       	call   800927 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019d1:	a1 80 60 80 00       	mov    0x806080,%eax
  8019d6:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019dc:	a1 84 60 80 00       	mov    0x806084,%eax
  8019e1:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8019e7:	83 c4 10             	add    $0x10,%esp
  8019ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    

008019f4 <devfile_write>:
{
  8019f4:	f3 0f 1e fb          	endbr32 
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
  8019fb:	83 ec 0c             	sub    $0xc,%esp
  8019fe:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a01:	8b 55 08             	mov    0x8(%ebp),%edx
  801a04:	8b 52 0c             	mov    0xc(%edx),%edx
  801a07:	89 15 00 60 80 00    	mov    %edx,0x806000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801a0d:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801a12:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801a17:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  801a1a:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801a1f:	50                   	push   %eax
  801a20:	ff 75 0c             	pushl  0xc(%ebp)
  801a23:	68 08 60 80 00       	push   $0x806008
  801a28:	e8 b0 f0 ff ff       	call   800add <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801a2d:	ba 00 00 00 00       	mov    $0x0,%edx
  801a32:	b8 04 00 00 00       	mov    $0x4,%eax
  801a37:	e8 ba fe ff ff       	call   8018f6 <fsipc>
}
  801a3c:	c9                   	leave  
  801a3d:	c3                   	ret    

00801a3e <devfile_read>:
{
  801a3e:	f3 0f 1e fb          	endbr32 
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
  801a45:	56                   	push   %esi
  801a46:	53                   	push   %ebx
  801a47:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4d:	8b 40 0c             	mov    0xc(%eax),%eax
  801a50:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801a55:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a5b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a60:	b8 03 00 00 00       	mov    $0x3,%eax
  801a65:	e8 8c fe ff ff       	call   8018f6 <fsipc>
  801a6a:	89 c3                	mov    %eax,%ebx
  801a6c:	85 c0                	test   %eax,%eax
  801a6e:	78 1f                	js     801a8f <devfile_read+0x51>
	assert(r <= n);
  801a70:	39 f0                	cmp    %esi,%eax
  801a72:	77 24                	ja     801a98 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801a74:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a79:	7f 33                	jg     801aae <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a7b:	83 ec 04             	sub    $0x4,%esp
  801a7e:	50                   	push   %eax
  801a7f:	68 00 60 80 00       	push   $0x806000
  801a84:	ff 75 0c             	pushl  0xc(%ebp)
  801a87:	e8 51 f0 ff ff       	call   800add <memmove>
	return r;
  801a8c:	83 c4 10             	add    $0x10,%esp
}
  801a8f:	89 d8                	mov    %ebx,%eax
  801a91:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a94:	5b                   	pop    %ebx
  801a95:	5e                   	pop    %esi
  801a96:	5d                   	pop    %ebp
  801a97:	c3                   	ret    
	assert(r <= n);
  801a98:	68 8c 2f 80 00       	push   $0x802f8c
  801a9d:	68 93 2f 80 00       	push   $0x802f93
  801aa2:	6a 7c                	push   $0x7c
  801aa4:	68 a8 2f 80 00       	push   $0x802fa8
  801aa9:	e8 88 e7 ff ff       	call   800236 <_panic>
	assert(r <= PGSIZE);
  801aae:	68 b3 2f 80 00       	push   $0x802fb3
  801ab3:	68 93 2f 80 00       	push   $0x802f93
  801ab8:	6a 7d                	push   $0x7d
  801aba:	68 a8 2f 80 00       	push   $0x802fa8
  801abf:	e8 72 e7 ff ff       	call   800236 <_panic>

00801ac4 <open>:
{
  801ac4:	f3 0f 1e fb          	endbr32 
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
  801acb:	56                   	push   %esi
  801acc:	53                   	push   %ebx
  801acd:	83 ec 1c             	sub    $0x1c,%esp
  801ad0:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801ad3:	56                   	push   %esi
  801ad4:	e8 0b ee ff ff       	call   8008e4 <strlen>
  801ad9:	83 c4 10             	add    $0x10,%esp
  801adc:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ae1:	7f 6c                	jg     801b4f <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801ae3:	83 ec 0c             	sub    $0xc,%esp
  801ae6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ae9:	50                   	push   %eax
  801aea:	e8 62 f8 ff ff       	call   801351 <fd_alloc>
  801aef:	89 c3                	mov    %eax,%ebx
  801af1:	83 c4 10             	add    $0x10,%esp
  801af4:	85 c0                	test   %eax,%eax
  801af6:	78 3c                	js     801b34 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801af8:	83 ec 08             	sub    $0x8,%esp
  801afb:	56                   	push   %esi
  801afc:	68 00 60 80 00       	push   $0x806000
  801b01:	e8 21 ee ff ff       	call   800927 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b06:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b09:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b11:	b8 01 00 00 00       	mov    $0x1,%eax
  801b16:	e8 db fd ff ff       	call   8018f6 <fsipc>
  801b1b:	89 c3                	mov    %eax,%ebx
  801b1d:	83 c4 10             	add    $0x10,%esp
  801b20:	85 c0                	test   %eax,%eax
  801b22:	78 19                	js     801b3d <open+0x79>
	return fd2num(fd);
  801b24:	83 ec 0c             	sub    $0xc,%esp
  801b27:	ff 75 f4             	pushl  -0xc(%ebp)
  801b2a:	e8 f3 f7 ff ff       	call   801322 <fd2num>
  801b2f:	89 c3                	mov    %eax,%ebx
  801b31:	83 c4 10             	add    $0x10,%esp
}
  801b34:	89 d8                	mov    %ebx,%eax
  801b36:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b39:	5b                   	pop    %ebx
  801b3a:	5e                   	pop    %esi
  801b3b:	5d                   	pop    %ebp
  801b3c:	c3                   	ret    
		fd_close(fd, 0);
  801b3d:	83 ec 08             	sub    $0x8,%esp
  801b40:	6a 00                	push   $0x0
  801b42:	ff 75 f4             	pushl  -0xc(%ebp)
  801b45:	e8 10 f9 ff ff       	call   80145a <fd_close>
		return r;
  801b4a:	83 c4 10             	add    $0x10,%esp
  801b4d:	eb e5                	jmp    801b34 <open+0x70>
		return -E_BAD_PATH;
  801b4f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b54:	eb de                	jmp    801b34 <open+0x70>

00801b56 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b56:	f3 0f 1e fb          	endbr32 
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
  801b5d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b60:	ba 00 00 00 00       	mov    $0x0,%edx
  801b65:	b8 08 00 00 00       	mov    $0x8,%eax
  801b6a:	e8 87 fd ff ff       	call   8018f6 <fsipc>
}
  801b6f:	c9                   	leave  
  801b70:	c3                   	ret    

00801b71 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801b71:	f3 0f 1e fb          	endbr32 
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
  801b78:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801b7b:	68 bf 2f 80 00       	push   $0x802fbf
  801b80:	ff 75 0c             	pushl  0xc(%ebp)
  801b83:	e8 9f ed ff ff       	call   800927 <strcpy>
	return 0;
}
  801b88:	b8 00 00 00 00       	mov    $0x0,%eax
  801b8d:	c9                   	leave  
  801b8e:	c3                   	ret    

00801b8f <devsock_close>:
{
  801b8f:	f3 0f 1e fb          	endbr32 
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
  801b96:	53                   	push   %ebx
  801b97:	83 ec 10             	sub    $0x10,%esp
  801b9a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801b9d:	53                   	push   %ebx
  801b9e:	e8 87 0b 00 00       	call   80272a <pageref>
  801ba3:	89 c2                	mov    %eax,%edx
  801ba5:	83 c4 10             	add    $0x10,%esp
		return 0;
  801ba8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801bad:	83 fa 01             	cmp    $0x1,%edx
  801bb0:	74 05                	je     801bb7 <devsock_close+0x28>
}
  801bb2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bb5:	c9                   	leave  
  801bb6:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801bb7:	83 ec 0c             	sub    $0xc,%esp
  801bba:	ff 73 0c             	pushl  0xc(%ebx)
  801bbd:	e8 e3 02 00 00       	call   801ea5 <nsipc_close>
  801bc2:	83 c4 10             	add    $0x10,%esp
  801bc5:	eb eb                	jmp    801bb2 <devsock_close+0x23>

00801bc7 <devsock_write>:
{
  801bc7:	f3 0f 1e fb          	endbr32 
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
  801bce:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801bd1:	6a 00                	push   $0x0
  801bd3:	ff 75 10             	pushl  0x10(%ebp)
  801bd6:	ff 75 0c             	pushl  0xc(%ebp)
  801bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdc:	ff 70 0c             	pushl  0xc(%eax)
  801bdf:	e8 b5 03 00 00       	call   801f99 <nsipc_send>
}
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    

00801be6 <devsock_read>:
{
  801be6:	f3 0f 1e fb          	endbr32 
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
  801bed:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801bf0:	6a 00                	push   $0x0
  801bf2:	ff 75 10             	pushl  0x10(%ebp)
  801bf5:	ff 75 0c             	pushl  0xc(%ebp)
  801bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfb:	ff 70 0c             	pushl  0xc(%eax)
  801bfe:	e8 1f 03 00 00       	call   801f22 <nsipc_recv>
}
  801c03:	c9                   	leave  
  801c04:	c3                   	ret    

00801c05 <fd2sockid>:
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
  801c08:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801c0b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801c0e:	52                   	push   %edx
  801c0f:	50                   	push   %eax
  801c10:	e8 92 f7 ff ff       	call   8013a7 <fd_lookup>
  801c15:	83 c4 10             	add    $0x10,%esp
  801c18:	85 c0                	test   %eax,%eax
  801c1a:	78 10                	js     801c2c <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c1f:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801c25:	39 08                	cmp    %ecx,(%eax)
  801c27:	75 05                	jne    801c2e <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801c29:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801c2c:	c9                   	leave  
  801c2d:	c3                   	ret    
		return -E_NOT_SUPP;
  801c2e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c33:	eb f7                	jmp    801c2c <fd2sockid+0x27>

00801c35 <alloc_sockfd>:
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
  801c38:	56                   	push   %esi
  801c39:	53                   	push   %ebx
  801c3a:	83 ec 1c             	sub    $0x1c,%esp
  801c3d:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801c3f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c42:	50                   	push   %eax
  801c43:	e8 09 f7 ff ff       	call   801351 <fd_alloc>
  801c48:	89 c3                	mov    %eax,%ebx
  801c4a:	83 c4 10             	add    $0x10,%esp
  801c4d:	85 c0                	test   %eax,%eax
  801c4f:	78 43                	js     801c94 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801c51:	83 ec 04             	sub    $0x4,%esp
  801c54:	68 07 04 00 00       	push   $0x407
  801c59:	ff 75 f4             	pushl  -0xc(%ebp)
  801c5c:	6a 00                	push   $0x0
  801c5e:	e8 06 f1 ff ff       	call   800d69 <sys_page_alloc>
  801c63:	89 c3                	mov    %eax,%ebx
  801c65:	83 c4 10             	add    $0x10,%esp
  801c68:	85 c0                	test   %eax,%eax
  801c6a:	78 28                	js     801c94 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c6f:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801c75:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c7a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801c81:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801c84:	83 ec 0c             	sub    $0xc,%esp
  801c87:	50                   	push   %eax
  801c88:	e8 95 f6 ff ff       	call   801322 <fd2num>
  801c8d:	89 c3                	mov    %eax,%ebx
  801c8f:	83 c4 10             	add    $0x10,%esp
  801c92:	eb 0c                	jmp    801ca0 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801c94:	83 ec 0c             	sub    $0xc,%esp
  801c97:	56                   	push   %esi
  801c98:	e8 08 02 00 00       	call   801ea5 <nsipc_close>
		return r;
  801c9d:	83 c4 10             	add    $0x10,%esp
}
  801ca0:	89 d8                	mov    %ebx,%eax
  801ca2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ca5:	5b                   	pop    %ebx
  801ca6:	5e                   	pop    %esi
  801ca7:	5d                   	pop    %ebp
  801ca8:	c3                   	ret    

00801ca9 <accept>:
{
  801ca9:	f3 0f 1e fb          	endbr32 
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
  801cb0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb6:	e8 4a ff ff ff       	call   801c05 <fd2sockid>
  801cbb:	85 c0                	test   %eax,%eax
  801cbd:	78 1b                	js     801cda <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801cbf:	83 ec 04             	sub    $0x4,%esp
  801cc2:	ff 75 10             	pushl  0x10(%ebp)
  801cc5:	ff 75 0c             	pushl  0xc(%ebp)
  801cc8:	50                   	push   %eax
  801cc9:	e8 22 01 00 00       	call   801df0 <nsipc_accept>
  801cce:	83 c4 10             	add    $0x10,%esp
  801cd1:	85 c0                	test   %eax,%eax
  801cd3:	78 05                	js     801cda <accept+0x31>
	return alloc_sockfd(r);
  801cd5:	e8 5b ff ff ff       	call   801c35 <alloc_sockfd>
}
  801cda:	c9                   	leave  
  801cdb:	c3                   	ret    

00801cdc <bind>:
{
  801cdc:	f3 0f 1e fb          	endbr32 
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
  801ce3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce9:	e8 17 ff ff ff       	call   801c05 <fd2sockid>
  801cee:	85 c0                	test   %eax,%eax
  801cf0:	78 12                	js     801d04 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801cf2:	83 ec 04             	sub    $0x4,%esp
  801cf5:	ff 75 10             	pushl  0x10(%ebp)
  801cf8:	ff 75 0c             	pushl  0xc(%ebp)
  801cfb:	50                   	push   %eax
  801cfc:	e8 45 01 00 00       	call   801e46 <nsipc_bind>
  801d01:	83 c4 10             	add    $0x10,%esp
}
  801d04:	c9                   	leave  
  801d05:	c3                   	ret    

00801d06 <shutdown>:
{
  801d06:	f3 0f 1e fb          	endbr32 
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
  801d0d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d10:	8b 45 08             	mov    0x8(%ebp),%eax
  801d13:	e8 ed fe ff ff       	call   801c05 <fd2sockid>
  801d18:	85 c0                	test   %eax,%eax
  801d1a:	78 0f                	js     801d2b <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801d1c:	83 ec 08             	sub    $0x8,%esp
  801d1f:	ff 75 0c             	pushl  0xc(%ebp)
  801d22:	50                   	push   %eax
  801d23:	e8 57 01 00 00       	call   801e7f <nsipc_shutdown>
  801d28:	83 c4 10             	add    $0x10,%esp
}
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <connect>:
{
  801d2d:	f3 0f 1e fb          	endbr32 
  801d31:	55                   	push   %ebp
  801d32:	89 e5                	mov    %esp,%ebp
  801d34:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d37:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3a:	e8 c6 fe ff ff       	call   801c05 <fd2sockid>
  801d3f:	85 c0                	test   %eax,%eax
  801d41:	78 12                	js     801d55 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801d43:	83 ec 04             	sub    $0x4,%esp
  801d46:	ff 75 10             	pushl  0x10(%ebp)
  801d49:	ff 75 0c             	pushl  0xc(%ebp)
  801d4c:	50                   	push   %eax
  801d4d:	e8 71 01 00 00       	call   801ec3 <nsipc_connect>
  801d52:	83 c4 10             	add    $0x10,%esp
}
  801d55:	c9                   	leave  
  801d56:	c3                   	ret    

00801d57 <listen>:
{
  801d57:	f3 0f 1e fb          	endbr32 
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
  801d5e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d61:	8b 45 08             	mov    0x8(%ebp),%eax
  801d64:	e8 9c fe ff ff       	call   801c05 <fd2sockid>
  801d69:	85 c0                	test   %eax,%eax
  801d6b:	78 0f                	js     801d7c <listen+0x25>
	return nsipc_listen(r, backlog);
  801d6d:	83 ec 08             	sub    $0x8,%esp
  801d70:	ff 75 0c             	pushl  0xc(%ebp)
  801d73:	50                   	push   %eax
  801d74:	e8 83 01 00 00       	call   801efc <nsipc_listen>
  801d79:	83 c4 10             	add    $0x10,%esp
}
  801d7c:	c9                   	leave  
  801d7d:	c3                   	ret    

00801d7e <socket>:

int
socket(int domain, int type, int protocol)
{
  801d7e:	f3 0f 1e fb          	endbr32 
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
  801d85:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801d88:	ff 75 10             	pushl  0x10(%ebp)
  801d8b:	ff 75 0c             	pushl  0xc(%ebp)
  801d8e:	ff 75 08             	pushl  0x8(%ebp)
  801d91:	e8 65 02 00 00       	call   801ffb <nsipc_socket>
  801d96:	83 c4 10             	add    $0x10,%esp
  801d99:	85 c0                	test   %eax,%eax
  801d9b:	78 05                	js     801da2 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801d9d:	e8 93 fe ff ff       	call   801c35 <alloc_sockfd>
}
  801da2:	c9                   	leave  
  801da3:	c3                   	ret    

00801da4 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
  801da7:	53                   	push   %ebx
  801da8:	83 ec 04             	sub    $0x4,%esp
  801dab:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801dad:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801db4:	74 26                	je     801ddc <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801db6:	6a 07                	push   $0x7
  801db8:	68 00 70 80 00       	push   $0x807000
  801dbd:	53                   	push   %ebx
  801dbe:	ff 35 04 50 80 00    	pushl  0x805004
  801dc4:	e8 cc 08 00 00       	call   802695 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801dc9:	83 c4 0c             	add    $0xc,%esp
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	e8 39 08 00 00       	call   802610 <ipc_recv>
}
  801dd7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801ddc:	83 ec 0c             	sub    $0xc,%esp
  801ddf:	6a 02                	push   $0x2
  801de1:	e8 07 09 00 00       	call   8026ed <ipc_find_env>
  801de6:	a3 04 50 80 00       	mov    %eax,0x805004
  801deb:	83 c4 10             	add    $0x10,%esp
  801dee:	eb c6                	jmp    801db6 <nsipc+0x12>

00801df0 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801df0:	f3 0f 1e fb          	endbr32 
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
  801df7:	56                   	push   %esi
  801df8:	53                   	push   %ebx
  801df9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dff:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801e04:	8b 06                	mov    (%esi),%eax
  801e06:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801e0b:	b8 01 00 00 00       	mov    $0x1,%eax
  801e10:	e8 8f ff ff ff       	call   801da4 <nsipc>
  801e15:	89 c3                	mov    %eax,%ebx
  801e17:	85 c0                	test   %eax,%eax
  801e19:	79 09                	jns    801e24 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801e1b:	89 d8                	mov    %ebx,%eax
  801e1d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e20:	5b                   	pop    %ebx
  801e21:	5e                   	pop    %esi
  801e22:	5d                   	pop    %ebp
  801e23:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801e24:	83 ec 04             	sub    $0x4,%esp
  801e27:	ff 35 10 70 80 00    	pushl  0x807010
  801e2d:	68 00 70 80 00       	push   $0x807000
  801e32:	ff 75 0c             	pushl  0xc(%ebp)
  801e35:	e8 a3 ec ff ff       	call   800add <memmove>
		*addrlen = ret->ret_addrlen;
  801e3a:	a1 10 70 80 00       	mov    0x807010,%eax
  801e3f:	89 06                	mov    %eax,(%esi)
  801e41:	83 c4 10             	add    $0x10,%esp
	return r;
  801e44:	eb d5                	jmp    801e1b <nsipc_accept+0x2b>

00801e46 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e46:	f3 0f 1e fb          	endbr32 
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
  801e4d:	53                   	push   %ebx
  801e4e:	83 ec 08             	sub    $0x8,%esp
  801e51:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801e54:	8b 45 08             	mov    0x8(%ebp),%eax
  801e57:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801e5c:	53                   	push   %ebx
  801e5d:	ff 75 0c             	pushl  0xc(%ebp)
  801e60:	68 04 70 80 00       	push   $0x807004
  801e65:	e8 73 ec ff ff       	call   800add <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801e6a:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  801e70:	b8 02 00 00 00       	mov    $0x2,%eax
  801e75:	e8 2a ff ff ff       	call   801da4 <nsipc>
}
  801e7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e7d:	c9                   	leave  
  801e7e:	c3                   	ret    

00801e7f <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801e7f:	f3 0f 1e fb          	endbr32 
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
  801e86:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801e89:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8c:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  801e91:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e94:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  801e99:	b8 03 00 00 00       	mov    $0x3,%eax
  801e9e:	e8 01 ff ff ff       	call   801da4 <nsipc>
}
  801ea3:	c9                   	leave  
  801ea4:	c3                   	ret    

00801ea5 <nsipc_close>:

int
nsipc_close(int s)
{
  801ea5:	f3 0f 1e fb          	endbr32 
  801ea9:	55                   	push   %ebp
  801eaa:	89 e5                	mov    %esp,%ebp
  801eac:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb2:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  801eb7:	b8 04 00 00 00       	mov    $0x4,%eax
  801ebc:	e8 e3 fe ff ff       	call   801da4 <nsipc>
}
  801ec1:	c9                   	leave  
  801ec2:	c3                   	ret    

00801ec3 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ec3:	f3 0f 1e fb          	endbr32 
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
  801eca:	53                   	push   %ebx
  801ecb:	83 ec 08             	sub    $0x8,%esp
  801ece:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed4:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801ed9:	53                   	push   %ebx
  801eda:	ff 75 0c             	pushl  0xc(%ebp)
  801edd:	68 04 70 80 00       	push   $0x807004
  801ee2:	e8 f6 eb ff ff       	call   800add <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801ee7:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  801eed:	b8 05 00 00 00       	mov    $0x5,%eax
  801ef2:	e8 ad fe ff ff       	call   801da4 <nsipc>
}
  801ef7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801efa:	c9                   	leave  
  801efb:	c3                   	ret    

00801efc <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801efc:	f3 0f 1e fb          	endbr32 
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
  801f03:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801f06:	8b 45 08             	mov    0x8(%ebp),%eax
  801f09:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  801f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f11:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  801f16:	b8 06 00 00 00       	mov    $0x6,%eax
  801f1b:	e8 84 fe ff ff       	call   801da4 <nsipc>
}
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    

00801f22 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801f22:	f3 0f 1e fb          	endbr32 
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
  801f29:	56                   	push   %esi
  801f2a:	53                   	push   %ebx
  801f2b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f31:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  801f36:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  801f3c:	8b 45 14             	mov    0x14(%ebp),%eax
  801f3f:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801f44:	b8 07 00 00 00       	mov    $0x7,%eax
  801f49:	e8 56 fe ff ff       	call   801da4 <nsipc>
  801f4e:	89 c3                	mov    %eax,%ebx
  801f50:	85 c0                	test   %eax,%eax
  801f52:	78 26                	js     801f7a <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801f54:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801f5a:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801f5f:	0f 4e c6             	cmovle %esi,%eax
  801f62:	39 c3                	cmp    %eax,%ebx
  801f64:	7f 1d                	jg     801f83 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801f66:	83 ec 04             	sub    $0x4,%esp
  801f69:	53                   	push   %ebx
  801f6a:	68 00 70 80 00       	push   $0x807000
  801f6f:	ff 75 0c             	pushl  0xc(%ebp)
  801f72:	e8 66 eb ff ff       	call   800add <memmove>
  801f77:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801f7a:	89 d8                	mov    %ebx,%eax
  801f7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f7f:	5b                   	pop    %ebx
  801f80:	5e                   	pop    %esi
  801f81:	5d                   	pop    %ebp
  801f82:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801f83:	68 cb 2f 80 00       	push   $0x802fcb
  801f88:	68 93 2f 80 00       	push   $0x802f93
  801f8d:	6a 62                	push   $0x62
  801f8f:	68 e0 2f 80 00       	push   $0x802fe0
  801f94:	e8 9d e2 ff ff       	call   800236 <_panic>

00801f99 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801f99:	f3 0f 1e fb          	endbr32 
  801f9d:	55                   	push   %ebp
  801f9e:	89 e5                	mov    %esp,%ebp
  801fa0:	53                   	push   %ebx
  801fa1:	83 ec 04             	sub    $0x4,%esp
  801fa4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801faa:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  801faf:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801fb5:	7f 2e                	jg     801fe5 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801fb7:	83 ec 04             	sub    $0x4,%esp
  801fba:	53                   	push   %ebx
  801fbb:	ff 75 0c             	pushl  0xc(%ebp)
  801fbe:	68 0c 70 80 00       	push   $0x80700c
  801fc3:	e8 15 eb ff ff       	call   800add <memmove>
	nsipcbuf.send.req_size = size;
  801fc8:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  801fce:	8b 45 14             	mov    0x14(%ebp),%eax
  801fd1:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  801fd6:	b8 08 00 00 00       	mov    $0x8,%eax
  801fdb:	e8 c4 fd ff ff       	call   801da4 <nsipc>
}
  801fe0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fe3:	c9                   	leave  
  801fe4:	c3                   	ret    
	assert(size < 1600);
  801fe5:	68 ec 2f 80 00       	push   $0x802fec
  801fea:	68 93 2f 80 00       	push   $0x802f93
  801fef:	6a 6d                	push   $0x6d
  801ff1:	68 e0 2f 80 00       	push   $0x802fe0
  801ff6:	e8 3b e2 ff ff       	call   800236 <_panic>

00801ffb <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801ffb:	f3 0f 1e fb          	endbr32 
  801fff:	55                   	push   %ebp
  802000:	89 e5                	mov    %esp,%ebp
  802002:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802005:	8b 45 08             	mov    0x8(%ebp),%eax
  802008:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80200d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802010:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802015:	8b 45 10             	mov    0x10(%ebp),%eax
  802018:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80201d:	b8 09 00 00 00       	mov    $0x9,%eax
  802022:	e8 7d fd ff ff       	call   801da4 <nsipc>
}
  802027:	c9                   	leave  
  802028:	c3                   	ret    

00802029 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802029:	f3 0f 1e fb          	endbr32 
  80202d:	55                   	push   %ebp
  80202e:	89 e5                	mov    %esp,%ebp
  802030:	56                   	push   %esi
  802031:	53                   	push   %ebx
  802032:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802035:	83 ec 0c             	sub    $0xc,%esp
  802038:	ff 75 08             	pushl  0x8(%ebp)
  80203b:	e8 f6 f2 ff ff       	call   801336 <fd2data>
  802040:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802042:	83 c4 08             	add    $0x8,%esp
  802045:	68 f8 2f 80 00       	push   $0x802ff8
  80204a:	53                   	push   %ebx
  80204b:	e8 d7 e8 ff ff       	call   800927 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802050:	8b 46 04             	mov    0x4(%esi),%eax
  802053:	2b 06                	sub    (%esi),%eax
  802055:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80205b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802062:	00 00 00 
	stat->st_dev = &devpipe;
  802065:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80206c:	40 80 00 
	return 0;
}
  80206f:	b8 00 00 00 00       	mov    $0x0,%eax
  802074:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802077:	5b                   	pop    %ebx
  802078:	5e                   	pop    %esi
  802079:	5d                   	pop    %ebp
  80207a:	c3                   	ret    

0080207b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80207b:	f3 0f 1e fb          	endbr32 
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
  802082:	53                   	push   %ebx
  802083:	83 ec 0c             	sub    $0xc,%esp
  802086:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802089:	53                   	push   %ebx
  80208a:	6a 00                	push   $0x0
  80208c:	e8 65 ed ff ff       	call   800df6 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802091:	89 1c 24             	mov    %ebx,(%esp)
  802094:	e8 9d f2 ff ff       	call   801336 <fd2data>
  802099:	83 c4 08             	add    $0x8,%esp
  80209c:	50                   	push   %eax
  80209d:	6a 00                	push   $0x0
  80209f:	e8 52 ed ff ff       	call   800df6 <sys_page_unmap>
}
  8020a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020a7:	c9                   	leave  
  8020a8:	c3                   	ret    

008020a9 <_pipeisclosed>:
{
  8020a9:	55                   	push   %ebp
  8020aa:	89 e5                	mov    %esp,%ebp
  8020ac:	57                   	push   %edi
  8020ad:	56                   	push   %esi
  8020ae:	53                   	push   %ebx
  8020af:	83 ec 1c             	sub    $0x1c,%esp
  8020b2:	89 c7                	mov    %eax,%edi
  8020b4:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8020b6:	a1 20 54 80 00       	mov    0x805420,%eax
  8020bb:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8020be:	83 ec 0c             	sub    $0xc,%esp
  8020c1:	57                   	push   %edi
  8020c2:	e8 63 06 00 00       	call   80272a <pageref>
  8020c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8020ca:	89 34 24             	mov    %esi,(%esp)
  8020cd:	e8 58 06 00 00       	call   80272a <pageref>
		nn = thisenv->env_runs;
  8020d2:	8b 15 20 54 80 00    	mov    0x805420,%edx
  8020d8:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8020db:	83 c4 10             	add    $0x10,%esp
  8020de:	39 cb                	cmp    %ecx,%ebx
  8020e0:	74 1b                	je     8020fd <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8020e2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8020e5:	75 cf                	jne    8020b6 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8020e7:	8b 42 58             	mov    0x58(%edx),%eax
  8020ea:	6a 01                	push   $0x1
  8020ec:	50                   	push   %eax
  8020ed:	53                   	push   %ebx
  8020ee:	68 ff 2f 80 00       	push   $0x802fff
  8020f3:	e8 25 e2 ff ff       	call   80031d <cprintf>
  8020f8:	83 c4 10             	add    $0x10,%esp
  8020fb:	eb b9                	jmp    8020b6 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8020fd:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802100:	0f 94 c0             	sete   %al
  802103:	0f b6 c0             	movzbl %al,%eax
}
  802106:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802109:	5b                   	pop    %ebx
  80210a:	5e                   	pop    %esi
  80210b:	5f                   	pop    %edi
  80210c:	5d                   	pop    %ebp
  80210d:	c3                   	ret    

0080210e <devpipe_write>:
{
  80210e:	f3 0f 1e fb          	endbr32 
  802112:	55                   	push   %ebp
  802113:	89 e5                	mov    %esp,%ebp
  802115:	57                   	push   %edi
  802116:	56                   	push   %esi
  802117:	53                   	push   %ebx
  802118:	83 ec 28             	sub    $0x28,%esp
  80211b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80211e:	56                   	push   %esi
  80211f:	e8 12 f2 ff ff       	call   801336 <fd2data>
  802124:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802126:	83 c4 10             	add    $0x10,%esp
  802129:	bf 00 00 00 00       	mov    $0x0,%edi
  80212e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802131:	74 4f                	je     802182 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802133:	8b 43 04             	mov    0x4(%ebx),%eax
  802136:	8b 0b                	mov    (%ebx),%ecx
  802138:	8d 51 20             	lea    0x20(%ecx),%edx
  80213b:	39 d0                	cmp    %edx,%eax
  80213d:	72 14                	jb     802153 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  80213f:	89 da                	mov    %ebx,%edx
  802141:	89 f0                	mov    %esi,%eax
  802143:	e8 61 ff ff ff       	call   8020a9 <_pipeisclosed>
  802148:	85 c0                	test   %eax,%eax
  80214a:	75 3b                	jne    802187 <devpipe_write+0x79>
			sys_yield();
  80214c:	e8 f5 eb ff ff       	call   800d46 <sys_yield>
  802151:	eb e0                	jmp    802133 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802153:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802156:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80215a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80215d:	89 c2                	mov    %eax,%edx
  80215f:	c1 fa 1f             	sar    $0x1f,%edx
  802162:	89 d1                	mov    %edx,%ecx
  802164:	c1 e9 1b             	shr    $0x1b,%ecx
  802167:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80216a:	83 e2 1f             	and    $0x1f,%edx
  80216d:	29 ca                	sub    %ecx,%edx
  80216f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802173:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802177:	83 c0 01             	add    $0x1,%eax
  80217a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80217d:	83 c7 01             	add    $0x1,%edi
  802180:	eb ac                	jmp    80212e <devpipe_write+0x20>
	return i;
  802182:	8b 45 10             	mov    0x10(%ebp),%eax
  802185:	eb 05                	jmp    80218c <devpipe_write+0x7e>
				return 0;
  802187:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80218c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80218f:	5b                   	pop    %ebx
  802190:	5e                   	pop    %esi
  802191:	5f                   	pop    %edi
  802192:	5d                   	pop    %ebp
  802193:	c3                   	ret    

00802194 <devpipe_read>:
{
  802194:	f3 0f 1e fb          	endbr32 
  802198:	55                   	push   %ebp
  802199:	89 e5                	mov    %esp,%ebp
  80219b:	57                   	push   %edi
  80219c:	56                   	push   %esi
  80219d:	53                   	push   %ebx
  80219e:	83 ec 18             	sub    $0x18,%esp
  8021a1:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8021a4:	57                   	push   %edi
  8021a5:	e8 8c f1 ff ff       	call   801336 <fd2data>
  8021aa:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8021ac:	83 c4 10             	add    $0x10,%esp
  8021af:	be 00 00 00 00       	mov    $0x0,%esi
  8021b4:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021b7:	75 14                	jne    8021cd <devpipe_read+0x39>
	return i;
  8021b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8021bc:	eb 02                	jmp    8021c0 <devpipe_read+0x2c>
				return i;
  8021be:	89 f0                	mov    %esi,%eax
}
  8021c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021c3:	5b                   	pop    %ebx
  8021c4:	5e                   	pop    %esi
  8021c5:	5f                   	pop    %edi
  8021c6:	5d                   	pop    %ebp
  8021c7:	c3                   	ret    
			sys_yield();
  8021c8:	e8 79 eb ff ff       	call   800d46 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8021cd:	8b 03                	mov    (%ebx),%eax
  8021cf:	3b 43 04             	cmp    0x4(%ebx),%eax
  8021d2:	75 18                	jne    8021ec <devpipe_read+0x58>
			if (i > 0)
  8021d4:	85 f6                	test   %esi,%esi
  8021d6:	75 e6                	jne    8021be <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8021d8:	89 da                	mov    %ebx,%edx
  8021da:	89 f8                	mov    %edi,%eax
  8021dc:	e8 c8 fe ff ff       	call   8020a9 <_pipeisclosed>
  8021e1:	85 c0                	test   %eax,%eax
  8021e3:	74 e3                	je     8021c8 <devpipe_read+0x34>
				return 0;
  8021e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ea:	eb d4                	jmp    8021c0 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8021ec:	99                   	cltd   
  8021ed:	c1 ea 1b             	shr    $0x1b,%edx
  8021f0:	01 d0                	add    %edx,%eax
  8021f2:	83 e0 1f             	and    $0x1f,%eax
  8021f5:	29 d0                	sub    %edx,%eax
  8021f7:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8021fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021ff:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802202:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802205:	83 c6 01             	add    $0x1,%esi
  802208:	eb aa                	jmp    8021b4 <devpipe_read+0x20>

0080220a <pipe>:
{
  80220a:	f3 0f 1e fb          	endbr32 
  80220e:	55                   	push   %ebp
  80220f:	89 e5                	mov    %esp,%ebp
  802211:	56                   	push   %esi
  802212:	53                   	push   %ebx
  802213:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802216:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802219:	50                   	push   %eax
  80221a:	e8 32 f1 ff ff       	call   801351 <fd_alloc>
  80221f:	89 c3                	mov    %eax,%ebx
  802221:	83 c4 10             	add    $0x10,%esp
  802224:	85 c0                	test   %eax,%eax
  802226:	0f 88 23 01 00 00    	js     80234f <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80222c:	83 ec 04             	sub    $0x4,%esp
  80222f:	68 07 04 00 00       	push   $0x407
  802234:	ff 75 f4             	pushl  -0xc(%ebp)
  802237:	6a 00                	push   $0x0
  802239:	e8 2b eb ff ff       	call   800d69 <sys_page_alloc>
  80223e:	89 c3                	mov    %eax,%ebx
  802240:	83 c4 10             	add    $0x10,%esp
  802243:	85 c0                	test   %eax,%eax
  802245:	0f 88 04 01 00 00    	js     80234f <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  80224b:	83 ec 0c             	sub    $0xc,%esp
  80224e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802251:	50                   	push   %eax
  802252:	e8 fa f0 ff ff       	call   801351 <fd_alloc>
  802257:	89 c3                	mov    %eax,%ebx
  802259:	83 c4 10             	add    $0x10,%esp
  80225c:	85 c0                	test   %eax,%eax
  80225e:	0f 88 db 00 00 00    	js     80233f <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802264:	83 ec 04             	sub    $0x4,%esp
  802267:	68 07 04 00 00       	push   $0x407
  80226c:	ff 75 f0             	pushl  -0x10(%ebp)
  80226f:	6a 00                	push   $0x0
  802271:	e8 f3 ea ff ff       	call   800d69 <sys_page_alloc>
  802276:	89 c3                	mov    %eax,%ebx
  802278:	83 c4 10             	add    $0x10,%esp
  80227b:	85 c0                	test   %eax,%eax
  80227d:	0f 88 bc 00 00 00    	js     80233f <pipe+0x135>
	va = fd2data(fd0);
  802283:	83 ec 0c             	sub    $0xc,%esp
  802286:	ff 75 f4             	pushl  -0xc(%ebp)
  802289:	e8 a8 f0 ff ff       	call   801336 <fd2data>
  80228e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802290:	83 c4 0c             	add    $0xc,%esp
  802293:	68 07 04 00 00       	push   $0x407
  802298:	50                   	push   %eax
  802299:	6a 00                	push   $0x0
  80229b:	e8 c9 ea ff ff       	call   800d69 <sys_page_alloc>
  8022a0:	89 c3                	mov    %eax,%ebx
  8022a2:	83 c4 10             	add    $0x10,%esp
  8022a5:	85 c0                	test   %eax,%eax
  8022a7:	0f 88 82 00 00 00    	js     80232f <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022ad:	83 ec 0c             	sub    $0xc,%esp
  8022b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8022b3:	e8 7e f0 ff ff       	call   801336 <fd2data>
  8022b8:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8022bf:	50                   	push   %eax
  8022c0:	6a 00                	push   $0x0
  8022c2:	56                   	push   %esi
  8022c3:	6a 00                	push   $0x0
  8022c5:	e8 e6 ea ff ff       	call   800db0 <sys_page_map>
  8022ca:	89 c3                	mov    %eax,%ebx
  8022cc:	83 c4 20             	add    $0x20,%esp
  8022cf:	85 c0                	test   %eax,%eax
  8022d1:	78 4e                	js     802321 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8022d3:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8022d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022db:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8022dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e0:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8022e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022ea:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8022ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ef:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8022f6:	83 ec 0c             	sub    $0xc,%esp
  8022f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8022fc:	e8 21 f0 ff ff       	call   801322 <fd2num>
  802301:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802304:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802306:	83 c4 04             	add    $0x4,%esp
  802309:	ff 75 f0             	pushl  -0x10(%ebp)
  80230c:	e8 11 f0 ff ff       	call   801322 <fd2num>
  802311:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802314:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802317:	83 c4 10             	add    $0x10,%esp
  80231a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80231f:	eb 2e                	jmp    80234f <pipe+0x145>
	sys_page_unmap(0, va);
  802321:	83 ec 08             	sub    $0x8,%esp
  802324:	56                   	push   %esi
  802325:	6a 00                	push   $0x0
  802327:	e8 ca ea ff ff       	call   800df6 <sys_page_unmap>
  80232c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80232f:	83 ec 08             	sub    $0x8,%esp
  802332:	ff 75 f0             	pushl  -0x10(%ebp)
  802335:	6a 00                	push   $0x0
  802337:	e8 ba ea ff ff       	call   800df6 <sys_page_unmap>
  80233c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80233f:	83 ec 08             	sub    $0x8,%esp
  802342:	ff 75 f4             	pushl  -0xc(%ebp)
  802345:	6a 00                	push   $0x0
  802347:	e8 aa ea ff ff       	call   800df6 <sys_page_unmap>
  80234c:	83 c4 10             	add    $0x10,%esp
}
  80234f:	89 d8                	mov    %ebx,%eax
  802351:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802354:	5b                   	pop    %ebx
  802355:	5e                   	pop    %esi
  802356:	5d                   	pop    %ebp
  802357:	c3                   	ret    

00802358 <pipeisclosed>:
{
  802358:	f3 0f 1e fb          	endbr32 
  80235c:	55                   	push   %ebp
  80235d:	89 e5                	mov    %esp,%ebp
  80235f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802362:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802365:	50                   	push   %eax
  802366:	ff 75 08             	pushl  0x8(%ebp)
  802369:	e8 39 f0 ff ff       	call   8013a7 <fd_lookup>
  80236e:	83 c4 10             	add    $0x10,%esp
  802371:	85 c0                	test   %eax,%eax
  802373:	78 18                	js     80238d <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802375:	83 ec 0c             	sub    $0xc,%esp
  802378:	ff 75 f4             	pushl  -0xc(%ebp)
  80237b:	e8 b6 ef ff ff       	call   801336 <fd2data>
  802380:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802385:	e8 1f fd ff ff       	call   8020a9 <_pipeisclosed>
  80238a:	83 c4 10             	add    $0x10,%esp
}
  80238d:	c9                   	leave  
  80238e:	c3                   	ret    

0080238f <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80238f:	f3 0f 1e fb          	endbr32 
  802393:	55                   	push   %ebp
  802394:	89 e5                	mov    %esp,%ebp
  802396:	56                   	push   %esi
  802397:	53                   	push   %ebx
  802398:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  80239b:	85 f6                	test   %esi,%esi
  80239d:	74 13                	je     8023b2 <wait+0x23>
	e = &envs[ENVX(envid)];
  80239f:	89 f3                	mov    %esi,%ebx
  8023a1:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8023a7:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  8023aa:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8023b0:	eb 1b                	jmp    8023cd <wait+0x3e>
	assert(envid != 0);
  8023b2:	68 17 30 80 00       	push   $0x803017
  8023b7:	68 93 2f 80 00       	push   $0x802f93
  8023bc:	6a 09                	push   $0x9
  8023be:	68 22 30 80 00       	push   $0x803022
  8023c3:	e8 6e de ff ff       	call   800236 <_panic>
		sys_yield();
  8023c8:	e8 79 e9 ff ff       	call   800d46 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8023cd:	8b 43 48             	mov    0x48(%ebx),%eax
  8023d0:	39 f0                	cmp    %esi,%eax
  8023d2:	75 07                	jne    8023db <wait+0x4c>
  8023d4:	8b 43 54             	mov    0x54(%ebx),%eax
  8023d7:	85 c0                	test   %eax,%eax
  8023d9:	75 ed                	jne    8023c8 <wait+0x39>
}
  8023db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023de:	5b                   	pop    %ebx
  8023df:	5e                   	pop    %esi
  8023e0:	5d                   	pop    %ebp
  8023e1:	c3                   	ret    

008023e2 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8023e2:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8023e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023eb:	c3                   	ret    

008023ec <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8023ec:	f3 0f 1e fb          	endbr32 
  8023f0:	55                   	push   %ebp
  8023f1:	89 e5                	mov    %esp,%ebp
  8023f3:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8023f6:	68 2d 30 80 00       	push   $0x80302d
  8023fb:	ff 75 0c             	pushl  0xc(%ebp)
  8023fe:	e8 24 e5 ff ff       	call   800927 <strcpy>
	return 0;
}
  802403:	b8 00 00 00 00       	mov    $0x0,%eax
  802408:	c9                   	leave  
  802409:	c3                   	ret    

0080240a <devcons_write>:
{
  80240a:	f3 0f 1e fb          	endbr32 
  80240e:	55                   	push   %ebp
  80240f:	89 e5                	mov    %esp,%ebp
  802411:	57                   	push   %edi
  802412:	56                   	push   %esi
  802413:	53                   	push   %ebx
  802414:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80241a:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80241f:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802425:	3b 75 10             	cmp    0x10(%ebp),%esi
  802428:	73 31                	jae    80245b <devcons_write+0x51>
		m = n - tot;
  80242a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80242d:	29 f3                	sub    %esi,%ebx
  80242f:	83 fb 7f             	cmp    $0x7f,%ebx
  802432:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802437:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80243a:	83 ec 04             	sub    $0x4,%esp
  80243d:	53                   	push   %ebx
  80243e:	89 f0                	mov    %esi,%eax
  802440:	03 45 0c             	add    0xc(%ebp),%eax
  802443:	50                   	push   %eax
  802444:	57                   	push   %edi
  802445:	e8 93 e6 ff ff       	call   800add <memmove>
		sys_cputs(buf, m);
  80244a:	83 c4 08             	add    $0x8,%esp
  80244d:	53                   	push   %ebx
  80244e:	57                   	push   %edi
  80244f:	e8 45 e8 ff ff       	call   800c99 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802454:	01 de                	add    %ebx,%esi
  802456:	83 c4 10             	add    $0x10,%esp
  802459:	eb ca                	jmp    802425 <devcons_write+0x1b>
}
  80245b:	89 f0                	mov    %esi,%eax
  80245d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802460:	5b                   	pop    %ebx
  802461:	5e                   	pop    %esi
  802462:	5f                   	pop    %edi
  802463:	5d                   	pop    %ebp
  802464:	c3                   	ret    

00802465 <devcons_read>:
{
  802465:	f3 0f 1e fb          	endbr32 
  802469:	55                   	push   %ebp
  80246a:	89 e5                	mov    %esp,%ebp
  80246c:	83 ec 08             	sub    $0x8,%esp
  80246f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802474:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802478:	74 21                	je     80249b <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  80247a:	e8 3c e8 ff ff       	call   800cbb <sys_cgetc>
  80247f:	85 c0                	test   %eax,%eax
  802481:	75 07                	jne    80248a <devcons_read+0x25>
		sys_yield();
  802483:	e8 be e8 ff ff       	call   800d46 <sys_yield>
  802488:	eb f0                	jmp    80247a <devcons_read+0x15>
	if (c < 0)
  80248a:	78 0f                	js     80249b <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  80248c:	83 f8 04             	cmp    $0x4,%eax
  80248f:	74 0c                	je     80249d <devcons_read+0x38>
	*(char*)vbuf = c;
  802491:	8b 55 0c             	mov    0xc(%ebp),%edx
  802494:	88 02                	mov    %al,(%edx)
	return 1;
  802496:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80249b:	c9                   	leave  
  80249c:	c3                   	ret    
		return 0;
  80249d:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a2:	eb f7                	jmp    80249b <devcons_read+0x36>

008024a4 <cputchar>:
{
  8024a4:	f3 0f 1e fb          	endbr32 
  8024a8:	55                   	push   %ebp
  8024a9:	89 e5                	mov    %esp,%ebp
  8024ab:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8024ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b1:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8024b4:	6a 01                	push   $0x1
  8024b6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024b9:	50                   	push   %eax
  8024ba:	e8 da e7 ff ff       	call   800c99 <sys_cputs>
}
  8024bf:	83 c4 10             	add    $0x10,%esp
  8024c2:	c9                   	leave  
  8024c3:	c3                   	ret    

008024c4 <getchar>:
{
  8024c4:	f3 0f 1e fb          	endbr32 
  8024c8:	55                   	push   %ebp
  8024c9:	89 e5                	mov    %esp,%ebp
  8024cb:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8024ce:	6a 01                	push   $0x1
  8024d0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024d3:	50                   	push   %eax
  8024d4:	6a 00                	push   $0x0
  8024d6:	e8 54 f1 ff ff       	call   80162f <read>
	if (r < 0)
  8024db:	83 c4 10             	add    $0x10,%esp
  8024de:	85 c0                	test   %eax,%eax
  8024e0:	78 06                	js     8024e8 <getchar+0x24>
	if (r < 1)
  8024e2:	74 06                	je     8024ea <getchar+0x26>
	return c;
  8024e4:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8024e8:	c9                   	leave  
  8024e9:	c3                   	ret    
		return -E_EOF;
  8024ea:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8024ef:	eb f7                	jmp    8024e8 <getchar+0x24>

008024f1 <iscons>:
{
  8024f1:	f3 0f 1e fb          	endbr32 
  8024f5:	55                   	push   %ebp
  8024f6:	89 e5                	mov    %esp,%ebp
  8024f8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024fe:	50                   	push   %eax
  8024ff:	ff 75 08             	pushl  0x8(%ebp)
  802502:	e8 a0 ee ff ff       	call   8013a7 <fd_lookup>
  802507:	83 c4 10             	add    $0x10,%esp
  80250a:	85 c0                	test   %eax,%eax
  80250c:	78 11                	js     80251f <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80250e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802511:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802517:	39 10                	cmp    %edx,(%eax)
  802519:	0f 94 c0             	sete   %al
  80251c:	0f b6 c0             	movzbl %al,%eax
}
  80251f:	c9                   	leave  
  802520:	c3                   	ret    

00802521 <opencons>:
{
  802521:	f3 0f 1e fb          	endbr32 
  802525:	55                   	push   %ebp
  802526:	89 e5                	mov    %esp,%ebp
  802528:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80252b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80252e:	50                   	push   %eax
  80252f:	e8 1d ee ff ff       	call   801351 <fd_alloc>
  802534:	83 c4 10             	add    $0x10,%esp
  802537:	85 c0                	test   %eax,%eax
  802539:	78 3a                	js     802575 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80253b:	83 ec 04             	sub    $0x4,%esp
  80253e:	68 07 04 00 00       	push   $0x407
  802543:	ff 75 f4             	pushl  -0xc(%ebp)
  802546:	6a 00                	push   $0x0
  802548:	e8 1c e8 ff ff       	call   800d69 <sys_page_alloc>
  80254d:	83 c4 10             	add    $0x10,%esp
  802550:	85 c0                	test   %eax,%eax
  802552:	78 21                	js     802575 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802554:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802557:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80255d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80255f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802562:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802569:	83 ec 0c             	sub    $0xc,%esp
  80256c:	50                   	push   %eax
  80256d:	e8 b0 ed ff ff       	call   801322 <fd2num>
  802572:	83 c4 10             	add    $0x10,%esp
}
  802575:	c9                   	leave  
  802576:	c3                   	ret    

00802577 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802577:	f3 0f 1e fb          	endbr32 
  80257b:	55                   	push   %ebp
  80257c:	89 e5                	mov    %esp,%ebp
  80257e:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802581:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802588:	74 0a                	je     802594 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80258a:	8b 45 08             	mov    0x8(%ebp),%eax
  80258d:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802592:	c9                   	leave  
  802593:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  802594:	83 ec 04             	sub    $0x4,%esp
  802597:	6a 07                	push   $0x7
  802599:	68 00 f0 bf ee       	push   $0xeebff000
  80259e:	6a 00                	push   $0x0
  8025a0:	e8 c4 e7 ff ff       	call   800d69 <sys_page_alloc>
  8025a5:	83 c4 10             	add    $0x10,%esp
  8025a8:	85 c0                	test   %eax,%eax
  8025aa:	78 2a                	js     8025d6 <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  8025ac:	83 ec 08             	sub    $0x8,%esp
  8025af:	68 ea 25 80 00       	push   $0x8025ea
  8025b4:	6a 00                	push   $0x0
  8025b6:	e8 0d e9 ff ff       	call   800ec8 <sys_env_set_pgfault_upcall>
  8025bb:	83 c4 10             	add    $0x10,%esp
  8025be:	85 c0                	test   %eax,%eax
  8025c0:	79 c8                	jns    80258a <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  8025c2:	83 ec 04             	sub    $0x4,%esp
  8025c5:	68 68 30 80 00       	push   $0x803068
  8025ca:	6a 25                	push   $0x25
  8025cc:	68 a0 30 80 00       	push   $0x8030a0
  8025d1:	e8 60 dc ff ff       	call   800236 <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  8025d6:	83 ec 04             	sub    $0x4,%esp
  8025d9:	68 3c 30 80 00       	push   $0x80303c
  8025de:	6a 22                	push   $0x22
  8025e0:	68 a0 30 80 00       	push   $0x8030a0
  8025e5:	e8 4c dc ff ff       	call   800236 <_panic>

008025ea <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8025ea:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8025eb:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8025f0:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8025f2:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  8025f5:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  8025f9:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  8025fd:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802600:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  802602:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  802606:	83 c4 08             	add    $0x8,%esp
	popal
  802609:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  80260a:	83 c4 04             	add    $0x4,%esp
	popfl
  80260d:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  80260e:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  80260f:	c3                   	ret    

00802610 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802610:	f3 0f 1e fb          	endbr32 
  802614:	55                   	push   %ebp
  802615:	89 e5                	mov    %esp,%ebp
  802617:	56                   	push   %esi
  802618:	53                   	push   %ebx
  802619:	8b 75 08             	mov    0x8(%ebp),%esi
  80261c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80261f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  802622:	85 c0                	test   %eax,%eax
  802624:	74 3d                	je     802663 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  802626:	83 ec 0c             	sub    $0xc,%esp
  802629:	50                   	push   %eax
  80262a:	e8 06 e9 ff ff       	call   800f35 <sys_ipc_recv>
  80262f:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  802632:	85 f6                	test   %esi,%esi
  802634:	74 0b                	je     802641 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  802636:	8b 15 20 54 80 00    	mov    0x805420,%edx
  80263c:	8b 52 74             	mov    0x74(%edx),%edx
  80263f:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  802641:	85 db                	test   %ebx,%ebx
  802643:	74 0b                	je     802650 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  802645:	8b 15 20 54 80 00    	mov    0x805420,%edx
  80264b:	8b 52 78             	mov    0x78(%edx),%edx
  80264e:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  802650:	85 c0                	test   %eax,%eax
  802652:	78 21                	js     802675 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  802654:	a1 20 54 80 00       	mov    0x805420,%eax
  802659:	8b 40 70             	mov    0x70(%eax),%eax
}
  80265c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80265f:	5b                   	pop    %ebx
  802660:	5e                   	pop    %esi
  802661:	5d                   	pop    %ebp
  802662:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  802663:	83 ec 0c             	sub    $0xc,%esp
  802666:	68 00 00 c0 ee       	push   $0xeec00000
  80266b:	e8 c5 e8 ff ff       	call   800f35 <sys_ipc_recv>
  802670:	83 c4 10             	add    $0x10,%esp
  802673:	eb bd                	jmp    802632 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  802675:	85 f6                	test   %esi,%esi
  802677:	74 10                	je     802689 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  802679:	85 db                	test   %ebx,%ebx
  80267b:	75 df                	jne    80265c <ipc_recv+0x4c>
  80267d:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802684:	00 00 00 
  802687:	eb d3                	jmp    80265c <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  802689:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802690:	00 00 00 
  802693:	eb e4                	jmp    802679 <ipc_recv+0x69>

00802695 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802695:	f3 0f 1e fb          	endbr32 
  802699:	55                   	push   %ebp
  80269a:	89 e5                	mov    %esp,%ebp
  80269c:	57                   	push   %edi
  80269d:	56                   	push   %esi
  80269e:	53                   	push   %ebx
  80269f:	83 ec 0c             	sub    $0xc,%esp
  8026a2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8026a5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8026a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  8026ab:	85 db                	test   %ebx,%ebx
  8026ad:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8026b2:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  8026b5:	ff 75 14             	pushl  0x14(%ebp)
  8026b8:	53                   	push   %ebx
  8026b9:	56                   	push   %esi
  8026ba:	57                   	push   %edi
  8026bb:	e8 4e e8 ff ff       	call   800f0e <sys_ipc_try_send>
  8026c0:	83 c4 10             	add    $0x10,%esp
  8026c3:	85 c0                	test   %eax,%eax
  8026c5:	79 1e                	jns    8026e5 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  8026c7:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8026ca:	75 07                	jne    8026d3 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  8026cc:	e8 75 e6 ff ff       	call   800d46 <sys_yield>
  8026d1:	eb e2                	jmp    8026b5 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  8026d3:	50                   	push   %eax
  8026d4:	68 ae 30 80 00       	push   $0x8030ae
  8026d9:	6a 59                	push   $0x59
  8026db:	68 c9 30 80 00       	push   $0x8030c9
  8026e0:	e8 51 db ff ff       	call   800236 <_panic>
	}
}
  8026e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026e8:	5b                   	pop    %ebx
  8026e9:	5e                   	pop    %esi
  8026ea:	5f                   	pop    %edi
  8026eb:	5d                   	pop    %ebp
  8026ec:	c3                   	ret    

008026ed <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8026ed:	f3 0f 1e fb          	endbr32 
  8026f1:	55                   	push   %ebp
  8026f2:	89 e5                	mov    %esp,%ebp
  8026f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8026f7:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8026fc:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8026ff:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802705:	8b 52 50             	mov    0x50(%edx),%edx
  802708:	39 ca                	cmp    %ecx,%edx
  80270a:	74 11                	je     80271d <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80270c:	83 c0 01             	add    $0x1,%eax
  80270f:	3d 00 04 00 00       	cmp    $0x400,%eax
  802714:	75 e6                	jne    8026fc <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802716:	b8 00 00 00 00       	mov    $0x0,%eax
  80271b:	eb 0b                	jmp    802728 <ipc_find_env+0x3b>
			return envs[i].env_id;
  80271d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802720:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802725:	8b 40 48             	mov    0x48(%eax),%eax
}
  802728:	5d                   	pop    %ebp
  802729:	c3                   	ret    

0080272a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80272a:	f3 0f 1e fb          	endbr32 
  80272e:	55                   	push   %ebp
  80272f:	89 e5                	mov    %esp,%ebp
  802731:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802734:	89 c2                	mov    %eax,%edx
  802736:	c1 ea 16             	shr    $0x16,%edx
  802739:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802740:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802745:	f6 c1 01             	test   $0x1,%cl
  802748:	74 1c                	je     802766 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  80274a:	c1 e8 0c             	shr    $0xc,%eax
  80274d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802754:	a8 01                	test   $0x1,%al
  802756:	74 0e                	je     802766 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802758:	c1 e8 0c             	shr    $0xc,%eax
  80275b:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802762:	ef 
  802763:	0f b7 d2             	movzwl %dx,%edx
}
  802766:	89 d0                	mov    %edx,%eax
  802768:	5d                   	pop    %ebp
  802769:	c3                   	ret    
  80276a:	66 90                	xchg   %ax,%ax
  80276c:	66 90                	xchg   %ax,%ax
  80276e:	66 90                	xchg   %ax,%ax

00802770 <__udivdi3>:
  802770:	f3 0f 1e fb          	endbr32 
  802774:	55                   	push   %ebp
  802775:	57                   	push   %edi
  802776:	56                   	push   %esi
  802777:	53                   	push   %ebx
  802778:	83 ec 1c             	sub    $0x1c,%esp
  80277b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80277f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802783:	8b 74 24 34          	mov    0x34(%esp),%esi
  802787:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80278b:	85 d2                	test   %edx,%edx
  80278d:	75 19                	jne    8027a8 <__udivdi3+0x38>
  80278f:	39 f3                	cmp    %esi,%ebx
  802791:	76 4d                	jbe    8027e0 <__udivdi3+0x70>
  802793:	31 ff                	xor    %edi,%edi
  802795:	89 e8                	mov    %ebp,%eax
  802797:	89 f2                	mov    %esi,%edx
  802799:	f7 f3                	div    %ebx
  80279b:	89 fa                	mov    %edi,%edx
  80279d:	83 c4 1c             	add    $0x1c,%esp
  8027a0:	5b                   	pop    %ebx
  8027a1:	5e                   	pop    %esi
  8027a2:	5f                   	pop    %edi
  8027a3:	5d                   	pop    %ebp
  8027a4:	c3                   	ret    
  8027a5:	8d 76 00             	lea    0x0(%esi),%esi
  8027a8:	39 f2                	cmp    %esi,%edx
  8027aa:	76 14                	jbe    8027c0 <__udivdi3+0x50>
  8027ac:	31 ff                	xor    %edi,%edi
  8027ae:	31 c0                	xor    %eax,%eax
  8027b0:	89 fa                	mov    %edi,%edx
  8027b2:	83 c4 1c             	add    $0x1c,%esp
  8027b5:	5b                   	pop    %ebx
  8027b6:	5e                   	pop    %esi
  8027b7:	5f                   	pop    %edi
  8027b8:	5d                   	pop    %ebp
  8027b9:	c3                   	ret    
  8027ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8027c0:	0f bd fa             	bsr    %edx,%edi
  8027c3:	83 f7 1f             	xor    $0x1f,%edi
  8027c6:	75 48                	jne    802810 <__udivdi3+0xa0>
  8027c8:	39 f2                	cmp    %esi,%edx
  8027ca:	72 06                	jb     8027d2 <__udivdi3+0x62>
  8027cc:	31 c0                	xor    %eax,%eax
  8027ce:	39 eb                	cmp    %ebp,%ebx
  8027d0:	77 de                	ja     8027b0 <__udivdi3+0x40>
  8027d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8027d7:	eb d7                	jmp    8027b0 <__udivdi3+0x40>
  8027d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027e0:	89 d9                	mov    %ebx,%ecx
  8027e2:	85 db                	test   %ebx,%ebx
  8027e4:	75 0b                	jne    8027f1 <__udivdi3+0x81>
  8027e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8027eb:	31 d2                	xor    %edx,%edx
  8027ed:	f7 f3                	div    %ebx
  8027ef:	89 c1                	mov    %eax,%ecx
  8027f1:	31 d2                	xor    %edx,%edx
  8027f3:	89 f0                	mov    %esi,%eax
  8027f5:	f7 f1                	div    %ecx
  8027f7:	89 c6                	mov    %eax,%esi
  8027f9:	89 e8                	mov    %ebp,%eax
  8027fb:	89 f7                	mov    %esi,%edi
  8027fd:	f7 f1                	div    %ecx
  8027ff:	89 fa                	mov    %edi,%edx
  802801:	83 c4 1c             	add    $0x1c,%esp
  802804:	5b                   	pop    %ebx
  802805:	5e                   	pop    %esi
  802806:	5f                   	pop    %edi
  802807:	5d                   	pop    %ebp
  802808:	c3                   	ret    
  802809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802810:	89 f9                	mov    %edi,%ecx
  802812:	b8 20 00 00 00       	mov    $0x20,%eax
  802817:	29 f8                	sub    %edi,%eax
  802819:	d3 e2                	shl    %cl,%edx
  80281b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80281f:	89 c1                	mov    %eax,%ecx
  802821:	89 da                	mov    %ebx,%edx
  802823:	d3 ea                	shr    %cl,%edx
  802825:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802829:	09 d1                	or     %edx,%ecx
  80282b:	89 f2                	mov    %esi,%edx
  80282d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802831:	89 f9                	mov    %edi,%ecx
  802833:	d3 e3                	shl    %cl,%ebx
  802835:	89 c1                	mov    %eax,%ecx
  802837:	d3 ea                	shr    %cl,%edx
  802839:	89 f9                	mov    %edi,%ecx
  80283b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80283f:	89 eb                	mov    %ebp,%ebx
  802841:	d3 e6                	shl    %cl,%esi
  802843:	89 c1                	mov    %eax,%ecx
  802845:	d3 eb                	shr    %cl,%ebx
  802847:	09 de                	or     %ebx,%esi
  802849:	89 f0                	mov    %esi,%eax
  80284b:	f7 74 24 08          	divl   0x8(%esp)
  80284f:	89 d6                	mov    %edx,%esi
  802851:	89 c3                	mov    %eax,%ebx
  802853:	f7 64 24 0c          	mull   0xc(%esp)
  802857:	39 d6                	cmp    %edx,%esi
  802859:	72 15                	jb     802870 <__udivdi3+0x100>
  80285b:	89 f9                	mov    %edi,%ecx
  80285d:	d3 e5                	shl    %cl,%ebp
  80285f:	39 c5                	cmp    %eax,%ebp
  802861:	73 04                	jae    802867 <__udivdi3+0xf7>
  802863:	39 d6                	cmp    %edx,%esi
  802865:	74 09                	je     802870 <__udivdi3+0x100>
  802867:	89 d8                	mov    %ebx,%eax
  802869:	31 ff                	xor    %edi,%edi
  80286b:	e9 40 ff ff ff       	jmp    8027b0 <__udivdi3+0x40>
  802870:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802873:	31 ff                	xor    %edi,%edi
  802875:	e9 36 ff ff ff       	jmp    8027b0 <__udivdi3+0x40>
  80287a:	66 90                	xchg   %ax,%ax
  80287c:	66 90                	xchg   %ax,%ax
  80287e:	66 90                	xchg   %ax,%ax

00802880 <__umoddi3>:
  802880:	f3 0f 1e fb          	endbr32 
  802884:	55                   	push   %ebp
  802885:	57                   	push   %edi
  802886:	56                   	push   %esi
  802887:	53                   	push   %ebx
  802888:	83 ec 1c             	sub    $0x1c,%esp
  80288b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80288f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802893:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802897:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80289b:	85 c0                	test   %eax,%eax
  80289d:	75 19                	jne    8028b8 <__umoddi3+0x38>
  80289f:	39 df                	cmp    %ebx,%edi
  8028a1:	76 5d                	jbe    802900 <__umoddi3+0x80>
  8028a3:	89 f0                	mov    %esi,%eax
  8028a5:	89 da                	mov    %ebx,%edx
  8028a7:	f7 f7                	div    %edi
  8028a9:	89 d0                	mov    %edx,%eax
  8028ab:	31 d2                	xor    %edx,%edx
  8028ad:	83 c4 1c             	add    $0x1c,%esp
  8028b0:	5b                   	pop    %ebx
  8028b1:	5e                   	pop    %esi
  8028b2:	5f                   	pop    %edi
  8028b3:	5d                   	pop    %ebp
  8028b4:	c3                   	ret    
  8028b5:	8d 76 00             	lea    0x0(%esi),%esi
  8028b8:	89 f2                	mov    %esi,%edx
  8028ba:	39 d8                	cmp    %ebx,%eax
  8028bc:	76 12                	jbe    8028d0 <__umoddi3+0x50>
  8028be:	89 f0                	mov    %esi,%eax
  8028c0:	89 da                	mov    %ebx,%edx
  8028c2:	83 c4 1c             	add    $0x1c,%esp
  8028c5:	5b                   	pop    %ebx
  8028c6:	5e                   	pop    %esi
  8028c7:	5f                   	pop    %edi
  8028c8:	5d                   	pop    %ebp
  8028c9:	c3                   	ret    
  8028ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8028d0:	0f bd e8             	bsr    %eax,%ebp
  8028d3:	83 f5 1f             	xor    $0x1f,%ebp
  8028d6:	75 50                	jne    802928 <__umoddi3+0xa8>
  8028d8:	39 d8                	cmp    %ebx,%eax
  8028da:	0f 82 e0 00 00 00    	jb     8029c0 <__umoddi3+0x140>
  8028e0:	89 d9                	mov    %ebx,%ecx
  8028e2:	39 f7                	cmp    %esi,%edi
  8028e4:	0f 86 d6 00 00 00    	jbe    8029c0 <__umoddi3+0x140>
  8028ea:	89 d0                	mov    %edx,%eax
  8028ec:	89 ca                	mov    %ecx,%edx
  8028ee:	83 c4 1c             	add    $0x1c,%esp
  8028f1:	5b                   	pop    %ebx
  8028f2:	5e                   	pop    %esi
  8028f3:	5f                   	pop    %edi
  8028f4:	5d                   	pop    %ebp
  8028f5:	c3                   	ret    
  8028f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028fd:	8d 76 00             	lea    0x0(%esi),%esi
  802900:	89 fd                	mov    %edi,%ebp
  802902:	85 ff                	test   %edi,%edi
  802904:	75 0b                	jne    802911 <__umoddi3+0x91>
  802906:	b8 01 00 00 00       	mov    $0x1,%eax
  80290b:	31 d2                	xor    %edx,%edx
  80290d:	f7 f7                	div    %edi
  80290f:	89 c5                	mov    %eax,%ebp
  802911:	89 d8                	mov    %ebx,%eax
  802913:	31 d2                	xor    %edx,%edx
  802915:	f7 f5                	div    %ebp
  802917:	89 f0                	mov    %esi,%eax
  802919:	f7 f5                	div    %ebp
  80291b:	89 d0                	mov    %edx,%eax
  80291d:	31 d2                	xor    %edx,%edx
  80291f:	eb 8c                	jmp    8028ad <__umoddi3+0x2d>
  802921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802928:	89 e9                	mov    %ebp,%ecx
  80292a:	ba 20 00 00 00       	mov    $0x20,%edx
  80292f:	29 ea                	sub    %ebp,%edx
  802931:	d3 e0                	shl    %cl,%eax
  802933:	89 44 24 08          	mov    %eax,0x8(%esp)
  802937:	89 d1                	mov    %edx,%ecx
  802939:	89 f8                	mov    %edi,%eax
  80293b:	d3 e8                	shr    %cl,%eax
  80293d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802941:	89 54 24 04          	mov    %edx,0x4(%esp)
  802945:	8b 54 24 04          	mov    0x4(%esp),%edx
  802949:	09 c1                	or     %eax,%ecx
  80294b:	89 d8                	mov    %ebx,%eax
  80294d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802951:	89 e9                	mov    %ebp,%ecx
  802953:	d3 e7                	shl    %cl,%edi
  802955:	89 d1                	mov    %edx,%ecx
  802957:	d3 e8                	shr    %cl,%eax
  802959:	89 e9                	mov    %ebp,%ecx
  80295b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80295f:	d3 e3                	shl    %cl,%ebx
  802961:	89 c7                	mov    %eax,%edi
  802963:	89 d1                	mov    %edx,%ecx
  802965:	89 f0                	mov    %esi,%eax
  802967:	d3 e8                	shr    %cl,%eax
  802969:	89 e9                	mov    %ebp,%ecx
  80296b:	89 fa                	mov    %edi,%edx
  80296d:	d3 e6                	shl    %cl,%esi
  80296f:	09 d8                	or     %ebx,%eax
  802971:	f7 74 24 08          	divl   0x8(%esp)
  802975:	89 d1                	mov    %edx,%ecx
  802977:	89 f3                	mov    %esi,%ebx
  802979:	f7 64 24 0c          	mull   0xc(%esp)
  80297d:	89 c6                	mov    %eax,%esi
  80297f:	89 d7                	mov    %edx,%edi
  802981:	39 d1                	cmp    %edx,%ecx
  802983:	72 06                	jb     80298b <__umoddi3+0x10b>
  802985:	75 10                	jne    802997 <__umoddi3+0x117>
  802987:	39 c3                	cmp    %eax,%ebx
  802989:	73 0c                	jae    802997 <__umoddi3+0x117>
  80298b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80298f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802993:	89 d7                	mov    %edx,%edi
  802995:	89 c6                	mov    %eax,%esi
  802997:	89 ca                	mov    %ecx,%edx
  802999:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80299e:	29 f3                	sub    %esi,%ebx
  8029a0:	19 fa                	sbb    %edi,%edx
  8029a2:	89 d0                	mov    %edx,%eax
  8029a4:	d3 e0                	shl    %cl,%eax
  8029a6:	89 e9                	mov    %ebp,%ecx
  8029a8:	d3 eb                	shr    %cl,%ebx
  8029aa:	d3 ea                	shr    %cl,%edx
  8029ac:	09 d8                	or     %ebx,%eax
  8029ae:	83 c4 1c             	add    $0x1c,%esp
  8029b1:	5b                   	pop    %ebx
  8029b2:	5e                   	pop    %esi
  8029b3:	5f                   	pop    %edi
  8029b4:	5d                   	pop    %ebp
  8029b5:	c3                   	ret    
  8029b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029bd:	8d 76 00             	lea    0x0(%esi),%esi
  8029c0:	29 fe                	sub    %edi,%esi
  8029c2:	19 c3                	sbb    %eax,%ebx
  8029c4:	89 f2                	mov    %esi,%edx
  8029c6:	89 d9                	mov    %ebx,%ecx
  8029c8:	e9 1d ff ff ff       	jmp    8028ea <__umoddi3+0x6a>
