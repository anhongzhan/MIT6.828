
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
  800042:	68 60 24 80 00       	push   $0x802460
  800047:	e8 c4 19 00 00       	call   801a10 <open>
  80004c:	89 c3                	mov    %eax,%ebx
  80004e:	83 c4 10             	add    $0x10,%esp
  800051:	85 c0                	test   %eax,%eax
  800053:	0f 88 ff 00 00 00    	js     800158 <umain+0x125>
		panic("open motd: %e", fd);
	seek(fd, 0);
  800059:	83 ec 08             	sub    $0x8,%esp
  80005c:	6a 00                	push   $0x0
  80005e:	50                   	push   %eax
  80005f:	e8 73 16 00 00       	call   8016d7 <seek>
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  800064:	83 c4 0c             	add    $0xc,%esp
  800067:	68 00 02 00 00       	push   $0x200
  80006c:	68 20 42 80 00       	push   $0x804220
  800071:	53                   	push   %ebx
  800072:	e8 8f 15 00 00       	call   801606 <readn>
  800077:	89 c6                	mov    %eax,%esi
  800079:	83 c4 10             	add    $0x10,%esp
  80007c:	85 c0                	test   %eax,%eax
  80007e:	0f 8e e6 00 00 00    	jle    80016a <umain+0x137>
		panic("readn: %e", n);

	if ((r = fork()) < 0)
  800084:	e8 d1 0f 00 00       	call   80105a <fork>
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
  80009b:	e8 37 16 00 00       	call   8016d7 <seek>
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  8000a0:	c7 04 24 c8 24 80 00 	movl   $0x8024c8,(%esp)
  8000a7:	e8 71 02 00 00       	call   80031d <cprintf>
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8000ac:	83 c4 0c             	add    $0xc,%esp
  8000af:	68 00 02 00 00       	push   $0x200
  8000b4:	68 20 40 80 00       	push   $0x804020
  8000b9:	53                   	push   %ebx
  8000ba:	e8 47 15 00 00       	call   801606 <readn>
  8000bf:	83 c4 10             	add    $0x10,%esp
  8000c2:	39 c6                	cmp    %eax,%esi
  8000c4:	0f 85 c4 00 00 00    	jne    80018e <umain+0x15b>
			panic("read in parent got %d, read in child got %d", n, n2);
		if (memcmp(buf, buf2, n) != 0)
  8000ca:	83 ec 04             	sub    $0x4,%esp
  8000cd:	56                   	push   %esi
  8000ce:	68 20 40 80 00       	push   $0x804020
  8000d3:	68 20 42 80 00       	push   $0x804220
  8000d8:	e8 80 0a 00 00       	call   800b5d <memcmp>
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	85 c0                	test   %eax,%eax
  8000e2:	0f 85 bc 00 00 00    	jne    8001a4 <umain+0x171>
			panic("read in parent got different bytes from read in child");
		cprintf("read in child succeeded\n");
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	68 92 24 80 00       	push   $0x802492
  8000f0:	e8 28 02 00 00       	call   80031d <cprintf>
		seek(fd, 0);
  8000f5:	83 c4 08             	add    $0x8,%esp
  8000f8:	6a 00                	push   $0x0
  8000fa:	53                   	push   %ebx
  8000fb:	e8 d7 15 00 00       	call   8016d7 <seek>
		close(fd);
  800100:	89 1c 24             	mov    %ebx,(%esp)
  800103:	e8 29 13 00 00       	call   801431 <close>
		exit();
  800108:	e8 0b 01 00 00       	call   800218 <exit>
  80010d:	83 c4 10             	add    $0x10,%esp
	}
	wait(r);
  800110:	83 ec 0c             	sub    $0xc,%esp
  800113:	57                   	push   %edi
  800114:	e8 0a 1d 00 00       	call   801e23 <wait>
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800119:	83 c4 0c             	add    $0xc,%esp
  80011c:	68 00 02 00 00       	push   $0x200
  800121:	68 20 40 80 00       	push   $0x804020
  800126:	53                   	push   %ebx
  800127:	e8 da 14 00 00       	call   801606 <readn>
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	39 c6                	cmp    %eax,%esi
  800131:	0f 85 81 00 00 00    	jne    8001b8 <umain+0x185>
		panic("read in parent got %d, then got %d", n, n2);
	cprintf("read in parent succeeded\n");
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	68 ab 24 80 00       	push   $0x8024ab
  80013f:	e8 d9 01 00 00       	call   80031d <cprintf>
	close(fd);
  800144:	89 1c 24             	mov    %ebx,(%esp)
  800147:	e8 e5 12 00 00       	call   801431 <close>
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
  800159:	68 65 24 80 00       	push   $0x802465
  80015e:	6a 0c                	push   $0xc
  800160:	68 73 24 80 00       	push   $0x802473
  800165:	e8 cc 00 00 00       	call   800236 <_panic>
		panic("readn: %e", n);
  80016a:	50                   	push   %eax
  80016b:	68 88 24 80 00       	push   $0x802488
  800170:	6a 0f                	push   $0xf
  800172:	68 73 24 80 00       	push   $0x802473
  800177:	e8 ba 00 00 00       	call   800236 <_panic>
		panic("fork: %e", r);
  80017c:	50                   	push   %eax
  80017d:	68 25 29 80 00       	push   $0x802925
  800182:	6a 12                	push   $0x12
  800184:	68 73 24 80 00       	push   $0x802473
  800189:	e8 a8 00 00 00       	call   800236 <_panic>
			panic("read in parent got %d, read in child got %d", n, n2);
  80018e:	83 ec 0c             	sub    $0xc,%esp
  800191:	50                   	push   %eax
  800192:	56                   	push   %esi
  800193:	68 0c 25 80 00       	push   $0x80250c
  800198:	6a 17                	push   $0x17
  80019a:	68 73 24 80 00       	push   $0x802473
  80019f:	e8 92 00 00 00       	call   800236 <_panic>
			panic("read in parent got different bytes from read in child");
  8001a4:	83 ec 04             	sub    $0x4,%esp
  8001a7:	68 38 25 80 00       	push   $0x802538
  8001ac:	6a 19                	push   $0x19
  8001ae:	68 73 24 80 00       	push   $0x802473
  8001b3:	e8 7e 00 00 00       	call   800236 <_panic>
		panic("read in parent got %d, then got %d", n, n2);
  8001b8:	83 ec 0c             	sub    $0xc,%esp
  8001bb:	50                   	push   %eax
  8001bc:	56                   	push   %esi
  8001bd:	68 70 25 80 00       	push   $0x802570
  8001c2:	6a 21                	push   $0x21
  8001c4:	68 73 24 80 00       	push   $0x802473
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
  8001ef:	a3 20 44 80 00       	mov    %eax,0x804420

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001f4:	85 db                	test   %ebx,%ebx
  8001f6:	7e 07                	jle    8001ff <libmain+0x31>
		binaryname = argv[0];
  8001f8:	8b 06                	mov    (%esi),%eax
  8001fa:	a3 00 30 80 00       	mov    %eax,0x803000

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
  800222:	e8 3b 12 00 00       	call   801462 <close_all>
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
  800242:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800248:	e8 d6 0a 00 00       	call   800d23 <sys_getenvid>
  80024d:	83 ec 0c             	sub    $0xc,%esp
  800250:	ff 75 0c             	pushl  0xc(%ebp)
  800253:	ff 75 08             	pushl  0x8(%ebp)
  800256:	56                   	push   %esi
  800257:	50                   	push   %eax
  800258:	68 a0 25 80 00       	push   $0x8025a0
  80025d:	e8 bb 00 00 00       	call   80031d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800262:	83 c4 18             	add    $0x18,%esp
  800265:	53                   	push   %ebx
  800266:	ff 75 10             	pushl  0x10(%ebp)
  800269:	e8 5a 00 00 00       	call   8002c8 <vcprintf>
	cprintf("\n");
  80026e:	c7 04 24 07 2b 80 00 	movl   $0x802b07,(%esp)
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
  800383:	e8 78 1e 00 00       	call   802200 <__udivdi3>
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
  8003c1:	e8 4a 1f 00 00       	call   802310 <__umoddi3>
  8003c6:	83 c4 14             	add    $0x14,%esp
  8003c9:	0f be 80 c3 25 80 00 	movsbl 0x8025c3(%eax),%eax
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
  800470:	3e ff 24 85 00 27 80 	notrack jmp *0x802700(,%eax,4)
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
  80053d:	8b 14 85 60 28 80 00 	mov    0x802860(,%eax,4),%edx
  800544:	85 d2                	test   %edx,%edx
  800546:	74 18                	je     800560 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800548:	52                   	push   %edx
  800549:	68 21 2a 80 00       	push   $0x802a21
  80054e:	53                   	push   %ebx
  80054f:	56                   	push   %esi
  800550:	e8 aa fe ff ff       	call   8003ff <printfmt>
  800555:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800558:	89 7d 14             	mov    %edi,0x14(%ebp)
  80055b:	e9 66 02 00 00       	jmp    8007c6 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800560:	50                   	push   %eax
  800561:	68 db 25 80 00       	push   $0x8025db
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
  800588:	b8 d4 25 80 00       	mov    $0x8025d4,%eax
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
  800d12:	68 bf 28 80 00       	push   $0x8028bf
  800d17:	6a 23                	push   $0x23
  800d19:	68 dc 28 80 00       	push   $0x8028dc
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
  800d9f:	68 bf 28 80 00       	push   $0x8028bf
  800da4:	6a 23                	push   $0x23
  800da6:	68 dc 28 80 00       	push   $0x8028dc
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
  800de5:	68 bf 28 80 00       	push   $0x8028bf
  800dea:	6a 23                	push   $0x23
  800dec:	68 dc 28 80 00       	push   $0x8028dc
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
  800e2b:	68 bf 28 80 00       	push   $0x8028bf
  800e30:	6a 23                	push   $0x23
  800e32:	68 dc 28 80 00       	push   $0x8028dc
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
  800e71:	68 bf 28 80 00       	push   $0x8028bf
  800e76:	6a 23                	push   $0x23
  800e78:	68 dc 28 80 00       	push   $0x8028dc
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
  800eb7:	68 bf 28 80 00       	push   $0x8028bf
  800ebc:	6a 23                	push   $0x23
  800ebe:	68 dc 28 80 00       	push   $0x8028dc
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
  800efd:	68 bf 28 80 00       	push   $0x8028bf
  800f02:	6a 23                	push   $0x23
  800f04:	68 dc 28 80 00       	push   $0x8028dc
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
  800f69:	68 bf 28 80 00       	push   $0x8028bf
  800f6e:	6a 23                	push   $0x23
  800f70:	68 dc 28 80 00       	push   $0x8028dc
  800f75:	e8 bc f2 ff ff       	call   800236 <_panic>

00800f7a <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f7a:	f3 0f 1e fb          	endbr32 
  800f7e:	55                   	push   %ebp
  800f7f:	89 e5                	mov    %esp,%ebp
  800f81:	53                   	push   %ebx
  800f82:	83 ec 04             	sub    $0x4,%esp
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800f88:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  800f8a:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f8e:	74 74                	je     801004 <pgfault+0x8a>
  800f90:	89 d8                	mov    %ebx,%eax
  800f92:	c1 e8 0c             	shr    $0xc,%eax
  800f95:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f9c:	f6 c4 08             	test   $0x8,%ah
  800f9f:	74 63                	je     801004 <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800fa1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  800fa7:	83 ec 0c             	sub    $0xc,%esp
  800faa:	6a 05                	push   $0x5
  800fac:	68 00 f0 7f 00       	push   $0x7ff000
  800fb1:	6a 00                	push   $0x0
  800fb3:	53                   	push   %ebx
  800fb4:	6a 00                	push   $0x0
  800fb6:	e8 f5 fd ff ff       	call   800db0 <sys_page_map>
  800fbb:	83 c4 20             	add    $0x20,%esp
  800fbe:	85 c0                	test   %eax,%eax
  800fc0:	78 59                	js     80101b <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  800fc2:	83 ec 04             	sub    $0x4,%esp
  800fc5:	6a 07                	push   $0x7
  800fc7:	53                   	push   %ebx
  800fc8:	6a 00                	push   $0x0
  800fca:	e8 9a fd ff ff       	call   800d69 <sys_page_alloc>
  800fcf:	83 c4 10             	add    $0x10,%esp
  800fd2:	85 c0                	test   %eax,%eax
  800fd4:	78 5a                	js     801030 <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  800fd6:	83 ec 04             	sub    $0x4,%esp
  800fd9:	68 00 10 00 00       	push   $0x1000
  800fde:	68 00 f0 7f 00       	push   $0x7ff000
  800fe3:	53                   	push   %ebx
  800fe4:	e8 f4 fa ff ff       	call   800add <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  800fe9:	83 c4 08             	add    $0x8,%esp
  800fec:	68 00 f0 7f 00       	push   $0x7ff000
  800ff1:	6a 00                	push   $0x0
  800ff3:	e8 fe fd ff ff       	call   800df6 <sys_page_unmap>
  800ff8:	83 c4 10             	add    $0x10,%esp
  800ffb:	85 c0                	test   %eax,%eax
  800ffd:	78 46                	js     801045 <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  800fff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801002:	c9                   	leave  
  801003:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  801004:	83 ec 04             	sub    $0x4,%esp
  801007:	68 ea 28 80 00       	push   $0x8028ea
  80100c:	68 d3 00 00 00       	push   $0xd3
  801011:	68 06 29 80 00       	push   $0x802906
  801016:	e8 1b f2 ff ff       	call   800236 <_panic>
		panic("pgfault: %e\n", r);
  80101b:	50                   	push   %eax
  80101c:	68 11 29 80 00       	push   $0x802911
  801021:	68 df 00 00 00       	push   $0xdf
  801026:	68 06 29 80 00       	push   $0x802906
  80102b:	e8 06 f2 ff ff       	call   800236 <_panic>
		panic("pgfault: %e\n", r);
  801030:	50                   	push   %eax
  801031:	68 11 29 80 00       	push   $0x802911
  801036:	68 e3 00 00 00       	push   $0xe3
  80103b:	68 06 29 80 00       	push   $0x802906
  801040:	e8 f1 f1 ff ff       	call   800236 <_panic>
		panic("pgfault: %e\n", r);
  801045:	50                   	push   %eax
  801046:	68 11 29 80 00       	push   $0x802911
  80104b:	68 e9 00 00 00       	push   $0xe9
  801050:	68 06 29 80 00       	push   $0x802906
  801055:	e8 dc f1 ff ff       	call   800236 <_panic>

0080105a <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80105a:	f3 0f 1e fb          	endbr32 
  80105e:	55                   	push   %ebp
  80105f:	89 e5                	mov    %esp,%ebp
  801061:	57                   	push   %edi
  801062:	56                   	push   %esi
  801063:	53                   	push   %ebx
  801064:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  801067:	68 7a 0f 80 00       	push   $0x800f7a
  80106c:	e8 9a 0f 00 00       	call   80200b <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801071:	b8 07 00 00 00       	mov    $0x7,%eax
  801076:	cd 30                	int    $0x30
  801078:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  80107b:	83 c4 10             	add    $0x10,%esp
  80107e:	85 c0                	test   %eax,%eax
  801080:	78 2d                	js     8010af <fork+0x55>
  801082:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801084:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  801089:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80108d:	0f 85 9b 00 00 00    	jne    80112e <fork+0xd4>
		thisenv = &envs[ENVX(sys_getenvid())];
  801093:	e8 8b fc ff ff       	call   800d23 <sys_getenvid>
  801098:	25 ff 03 00 00       	and    $0x3ff,%eax
  80109d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010a0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010a5:	a3 20 44 80 00       	mov    %eax,0x804420
		return 0;
  8010aa:	e9 71 01 00 00       	jmp    801220 <fork+0x1c6>
		panic("sys_exofork: %e", envid);
  8010af:	50                   	push   %eax
  8010b0:	68 1e 29 80 00       	push   $0x80291e
  8010b5:	68 2a 01 00 00       	push   $0x12a
  8010ba:	68 06 29 80 00       	push   $0x802906
  8010bf:	e8 72 f1 ff ff       	call   800236 <_panic>
		sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_SYSCALL);
  8010c4:	c1 e6 0c             	shl    $0xc,%esi
  8010c7:	83 ec 0c             	sub    $0xc,%esp
  8010ca:	68 07 0e 00 00       	push   $0xe07
  8010cf:	56                   	push   %esi
  8010d0:	57                   	push   %edi
  8010d1:	56                   	push   %esi
  8010d2:	6a 00                	push   $0x0
  8010d4:	e8 d7 fc ff ff       	call   800db0 <sys_page_map>
  8010d9:	83 c4 20             	add    $0x20,%esp
  8010dc:	eb 3e                	jmp    80111c <fork+0xc2>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  8010de:	c1 e6 0c             	shl    $0xc,%esi
  8010e1:	83 ec 0c             	sub    $0xc,%esp
  8010e4:	68 05 08 00 00       	push   $0x805
  8010e9:	56                   	push   %esi
  8010ea:	57                   	push   %edi
  8010eb:	56                   	push   %esi
  8010ec:	6a 00                	push   $0x0
  8010ee:	e8 bd fc ff ff       	call   800db0 <sys_page_map>
  8010f3:	83 c4 20             	add    $0x20,%esp
  8010f6:	85 c0                	test   %eax,%eax
  8010f8:	0f 88 bc 00 00 00    	js     8011ba <fork+0x160>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  8010fe:	83 ec 0c             	sub    $0xc,%esp
  801101:	68 05 08 00 00       	push   $0x805
  801106:	56                   	push   %esi
  801107:	6a 00                	push   $0x0
  801109:	56                   	push   %esi
  80110a:	6a 00                	push   $0x0
  80110c:	e8 9f fc ff ff       	call   800db0 <sys_page_map>
  801111:	83 c4 20             	add    $0x20,%esp
  801114:	85 c0                	test   %eax,%eax
  801116:	0f 88 b3 00 00 00    	js     8011cf <fork+0x175>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  80111c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801122:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801128:	0f 84 b6 00 00 00    	je     8011e4 <fork+0x18a>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  80112e:	89 d8                	mov    %ebx,%eax
  801130:	c1 e8 16             	shr    $0x16,%eax
  801133:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80113a:	a8 01                	test   $0x1,%al
  80113c:	74 de                	je     80111c <fork+0xc2>
  80113e:	89 de                	mov    %ebx,%esi
  801140:	c1 ee 0c             	shr    $0xc,%esi
  801143:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80114a:	a8 01                	test   $0x1,%al
  80114c:	74 ce                	je     80111c <fork+0xc2>
  80114e:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801155:	a8 04                	test   $0x4,%al
  801157:	74 c3                	je     80111c <fork+0xc2>
	if ((uvpt[pn] & PTE_SHARE)){
  801159:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801160:	f6 c4 04             	test   $0x4,%ah
  801163:	0f 85 5b ff ff ff    	jne    8010c4 <fork+0x6a>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  801169:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801170:	a8 02                	test   $0x2,%al
  801172:	0f 85 66 ff ff ff    	jne    8010de <fork+0x84>
  801178:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80117f:	f6 c4 08             	test   $0x8,%ah
  801182:	0f 85 56 ff ff ff    	jne    8010de <fork+0x84>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  801188:	c1 e6 0c             	shl    $0xc,%esi
  80118b:	83 ec 0c             	sub    $0xc,%esp
  80118e:	6a 05                	push   $0x5
  801190:	56                   	push   %esi
  801191:	57                   	push   %edi
  801192:	56                   	push   %esi
  801193:	6a 00                	push   $0x0
  801195:	e8 16 fc ff ff       	call   800db0 <sys_page_map>
  80119a:	83 c4 20             	add    $0x20,%esp
  80119d:	85 c0                	test   %eax,%eax
  80119f:	0f 89 77 ff ff ff    	jns    80111c <fork+0xc2>
		panic("duppage: %e\n", r);
  8011a5:	50                   	push   %eax
  8011a6:	68 2e 29 80 00       	push   $0x80292e
  8011ab:	68 0c 01 00 00       	push   $0x10c
  8011b0:	68 06 29 80 00       	push   $0x802906
  8011b5:	e8 7c f0 ff ff       	call   800236 <_panic>
			panic("duppage: %e\n", r);
  8011ba:	50                   	push   %eax
  8011bb:	68 2e 29 80 00       	push   $0x80292e
  8011c0:	68 05 01 00 00       	push   $0x105
  8011c5:	68 06 29 80 00       	push   $0x802906
  8011ca:	e8 67 f0 ff ff       	call   800236 <_panic>
			panic("duppage: %e\n", r);
  8011cf:	50                   	push   %eax
  8011d0:	68 2e 29 80 00       	push   $0x80292e
  8011d5:	68 09 01 00 00       	push   $0x109
  8011da:	68 06 29 80 00       	push   $0x802906
  8011df:	e8 52 f0 ff ff       	call   800236 <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  8011e4:	83 ec 04             	sub    $0x4,%esp
  8011e7:	6a 07                	push   $0x7
  8011e9:	68 00 f0 bf ee       	push   $0xeebff000
  8011ee:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011f1:	e8 73 fb ff ff       	call   800d69 <sys_page_alloc>
  8011f6:	83 c4 10             	add    $0x10,%esp
  8011f9:	85 c0                	test   %eax,%eax
  8011fb:	78 2e                	js     80122b <fork+0x1d1>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8011fd:	83 ec 08             	sub    $0x8,%esp
  801200:	68 7e 20 80 00       	push   $0x80207e
  801205:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801208:	57                   	push   %edi
  801209:	e8 ba fc ff ff       	call   800ec8 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80120e:	83 c4 08             	add    $0x8,%esp
  801211:	6a 02                	push   $0x2
  801213:	57                   	push   %edi
  801214:	e8 23 fc ff ff       	call   800e3c <sys_env_set_status>
  801219:	83 c4 10             	add    $0x10,%esp
  80121c:	85 c0                	test   %eax,%eax
  80121e:	78 20                	js     801240 <fork+0x1e6>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  801220:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801223:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801226:	5b                   	pop    %ebx
  801227:	5e                   	pop    %esi
  801228:	5f                   	pop    %edi
  801229:	5d                   	pop    %ebp
  80122a:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  80122b:	50                   	push   %eax
  80122c:	68 3b 29 80 00       	push   $0x80293b
  801231:	68 3e 01 00 00       	push   $0x13e
  801236:	68 06 29 80 00       	push   $0x802906
  80123b:	e8 f6 ef ff ff       	call   800236 <_panic>
		panic("sys_env_set_status: %e", r);
  801240:	50                   	push   %eax
  801241:	68 4e 29 80 00       	push   $0x80294e
  801246:	68 43 01 00 00       	push   $0x143
  80124b:	68 06 29 80 00       	push   $0x802906
  801250:	e8 e1 ef ff ff       	call   800236 <_panic>

00801255 <sfork>:

// Challenge!
int
sfork(void)
{
  801255:	f3 0f 1e fb          	endbr32 
  801259:	55                   	push   %ebp
  80125a:	89 e5                	mov    %esp,%ebp
  80125c:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80125f:	68 65 29 80 00       	push   $0x802965
  801264:	68 4c 01 00 00       	push   $0x14c
  801269:	68 06 29 80 00       	push   $0x802906
  80126e:	e8 c3 ef ff ff       	call   800236 <_panic>

00801273 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801273:	f3 0f 1e fb          	endbr32 
  801277:	55                   	push   %ebp
  801278:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80127a:	8b 45 08             	mov    0x8(%ebp),%eax
  80127d:	05 00 00 00 30       	add    $0x30000000,%eax
  801282:	c1 e8 0c             	shr    $0xc,%eax
}
  801285:	5d                   	pop    %ebp
  801286:	c3                   	ret    

00801287 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801287:	f3 0f 1e fb          	endbr32 
  80128b:	55                   	push   %ebp
  80128c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80128e:	8b 45 08             	mov    0x8(%ebp),%eax
  801291:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801296:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80129b:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012a0:	5d                   	pop    %ebp
  8012a1:	c3                   	ret    

008012a2 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012a2:	f3 0f 1e fb          	endbr32 
  8012a6:	55                   	push   %ebp
  8012a7:	89 e5                	mov    %esp,%ebp
  8012a9:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012ae:	89 c2                	mov    %eax,%edx
  8012b0:	c1 ea 16             	shr    $0x16,%edx
  8012b3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012ba:	f6 c2 01             	test   $0x1,%dl
  8012bd:	74 2d                	je     8012ec <fd_alloc+0x4a>
  8012bf:	89 c2                	mov    %eax,%edx
  8012c1:	c1 ea 0c             	shr    $0xc,%edx
  8012c4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012cb:	f6 c2 01             	test   $0x1,%dl
  8012ce:	74 1c                	je     8012ec <fd_alloc+0x4a>
  8012d0:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8012d5:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012da:	75 d2                	jne    8012ae <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8012e5:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8012ea:	eb 0a                	jmp    8012f6 <fd_alloc+0x54>
			*fd_store = fd;
  8012ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012ef:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012f6:	5d                   	pop    %ebp
  8012f7:	c3                   	ret    

008012f8 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8012f8:	f3 0f 1e fb          	endbr32 
  8012fc:	55                   	push   %ebp
  8012fd:	89 e5                	mov    %esp,%ebp
  8012ff:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801302:	83 f8 1f             	cmp    $0x1f,%eax
  801305:	77 30                	ja     801337 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801307:	c1 e0 0c             	shl    $0xc,%eax
  80130a:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80130f:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801315:	f6 c2 01             	test   $0x1,%dl
  801318:	74 24                	je     80133e <fd_lookup+0x46>
  80131a:	89 c2                	mov    %eax,%edx
  80131c:	c1 ea 0c             	shr    $0xc,%edx
  80131f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801326:	f6 c2 01             	test   $0x1,%dl
  801329:	74 1a                	je     801345 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80132b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80132e:	89 02                	mov    %eax,(%edx)
	return 0;
  801330:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801335:	5d                   	pop    %ebp
  801336:	c3                   	ret    
		return -E_INVAL;
  801337:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80133c:	eb f7                	jmp    801335 <fd_lookup+0x3d>
		return -E_INVAL;
  80133e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801343:	eb f0                	jmp    801335 <fd_lookup+0x3d>
  801345:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80134a:	eb e9                	jmp    801335 <fd_lookup+0x3d>

0080134c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80134c:	f3 0f 1e fb          	endbr32 
  801350:	55                   	push   %ebp
  801351:	89 e5                	mov    %esp,%ebp
  801353:	83 ec 08             	sub    $0x8,%esp
  801356:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801359:	ba f8 29 80 00       	mov    $0x8029f8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80135e:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801363:	39 08                	cmp    %ecx,(%eax)
  801365:	74 33                	je     80139a <dev_lookup+0x4e>
  801367:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80136a:	8b 02                	mov    (%edx),%eax
  80136c:	85 c0                	test   %eax,%eax
  80136e:	75 f3                	jne    801363 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801370:	a1 20 44 80 00       	mov    0x804420,%eax
  801375:	8b 40 48             	mov    0x48(%eax),%eax
  801378:	83 ec 04             	sub    $0x4,%esp
  80137b:	51                   	push   %ecx
  80137c:	50                   	push   %eax
  80137d:	68 7c 29 80 00       	push   $0x80297c
  801382:	e8 96 ef ff ff       	call   80031d <cprintf>
	*dev = 0;
  801387:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801390:	83 c4 10             	add    $0x10,%esp
  801393:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801398:	c9                   	leave  
  801399:	c3                   	ret    
			*dev = devtab[i];
  80139a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80139d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80139f:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a4:	eb f2                	jmp    801398 <dev_lookup+0x4c>

008013a6 <fd_close>:
{
  8013a6:	f3 0f 1e fb          	endbr32 
  8013aa:	55                   	push   %ebp
  8013ab:	89 e5                	mov    %esp,%ebp
  8013ad:	57                   	push   %edi
  8013ae:	56                   	push   %esi
  8013af:	53                   	push   %ebx
  8013b0:	83 ec 24             	sub    $0x24,%esp
  8013b3:	8b 75 08             	mov    0x8(%ebp),%esi
  8013b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013b9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013bc:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013bd:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8013c3:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013c6:	50                   	push   %eax
  8013c7:	e8 2c ff ff ff       	call   8012f8 <fd_lookup>
  8013cc:	89 c3                	mov    %eax,%ebx
  8013ce:	83 c4 10             	add    $0x10,%esp
  8013d1:	85 c0                	test   %eax,%eax
  8013d3:	78 05                	js     8013da <fd_close+0x34>
	    || fd != fd2)
  8013d5:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8013d8:	74 16                	je     8013f0 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8013da:	89 f8                	mov    %edi,%eax
  8013dc:	84 c0                	test   %al,%al
  8013de:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e3:	0f 44 d8             	cmove  %eax,%ebx
}
  8013e6:	89 d8                	mov    %ebx,%eax
  8013e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013eb:	5b                   	pop    %ebx
  8013ec:	5e                   	pop    %esi
  8013ed:	5f                   	pop    %edi
  8013ee:	5d                   	pop    %ebp
  8013ef:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8013f0:	83 ec 08             	sub    $0x8,%esp
  8013f3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8013f6:	50                   	push   %eax
  8013f7:	ff 36                	pushl  (%esi)
  8013f9:	e8 4e ff ff ff       	call   80134c <dev_lookup>
  8013fe:	89 c3                	mov    %eax,%ebx
  801400:	83 c4 10             	add    $0x10,%esp
  801403:	85 c0                	test   %eax,%eax
  801405:	78 1a                	js     801421 <fd_close+0x7b>
		if (dev->dev_close)
  801407:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80140a:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80140d:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801412:	85 c0                	test   %eax,%eax
  801414:	74 0b                	je     801421 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801416:	83 ec 0c             	sub    $0xc,%esp
  801419:	56                   	push   %esi
  80141a:	ff d0                	call   *%eax
  80141c:	89 c3                	mov    %eax,%ebx
  80141e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801421:	83 ec 08             	sub    $0x8,%esp
  801424:	56                   	push   %esi
  801425:	6a 00                	push   $0x0
  801427:	e8 ca f9 ff ff       	call   800df6 <sys_page_unmap>
	return r;
  80142c:	83 c4 10             	add    $0x10,%esp
  80142f:	eb b5                	jmp    8013e6 <fd_close+0x40>

00801431 <close>:

int
close(int fdnum)
{
  801431:	f3 0f 1e fb          	endbr32 
  801435:	55                   	push   %ebp
  801436:	89 e5                	mov    %esp,%ebp
  801438:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80143b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80143e:	50                   	push   %eax
  80143f:	ff 75 08             	pushl  0x8(%ebp)
  801442:	e8 b1 fe ff ff       	call   8012f8 <fd_lookup>
  801447:	83 c4 10             	add    $0x10,%esp
  80144a:	85 c0                	test   %eax,%eax
  80144c:	79 02                	jns    801450 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80144e:	c9                   	leave  
  80144f:	c3                   	ret    
		return fd_close(fd, 1);
  801450:	83 ec 08             	sub    $0x8,%esp
  801453:	6a 01                	push   $0x1
  801455:	ff 75 f4             	pushl  -0xc(%ebp)
  801458:	e8 49 ff ff ff       	call   8013a6 <fd_close>
  80145d:	83 c4 10             	add    $0x10,%esp
  801460:	eb ec                	jmp    80144e <close+0x1d>

00801462 <close_all>:

void
close_all(void)
{
  801462:	f3 0f 1e fb          	endbr32 
  801466:	55                   	push   %ebp
  801467:	89 e5                	mov    %esp,%ebp
  801469:	53                   	push   %ebx
  80146a:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80146d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801472:	83 ec 0c             	sub    $0xc,%esp
  801475:	53                   	push   %ebx
  801476:	e8 b6 ff ff ff       	call   801431 <close>
	for (i = 0; i < MAXFD; i++)
  80147b:	83 c3 01             	add    $0x1,%ebx
  80147e:	83 c4 10             	add    $0x10,%esp
  801481:	83 fb 20             	cmp    $0x20,%ebx
  801484:	75 ec                	jne    801472 <close_all+0x10>
}
  801486:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801489:	c9                   	leave  
  80148a:	c3                   	ret    

0080148b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80148b:	f3 0f 1e fb          	endbr32 
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
  801492:	57                   	push   %edi
  801493:	56                   	push   %esi
  801494:	53                   	push   %ebx
  801495:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801498:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80149b:	50                   	push   %eax
  80149c:	ff 75 08             	pushl  0x8(%ebp)
  80149f:	e8 54 fe ff ff       	call   8012f8 <fd_lookup>
  8014a4:	89 c3                	mov    %eax,%ebx
  8014a6:	83 c4 10             	add    $0x10,%esp
  8014a9:	85 c0                	test   %eax,%eax
  8014ab:	0f 88 81 00 00 00    	js     801532 <dup+0xa7>
		return r;
	close(newfdnum);
  8014b1:	83 ec 0c             	sub    $0xc,%esp
  8014b4:	ff 75 0c             	pushl  0xc(%ebp)
  8014b7:	e8 75 ff ff ff       	call   801431 <close>

	newfd = INDEX2FD(newfdnum);
  8014bc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014bf:	c1 e6 0c             	shl    $0xc,%esi
  8014c2:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8014c8:	83 c4 04             	add    $0x4,%esp
  8014cb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014ce:	e8 b4 fd ff ff       	call   801287 <fd2data>
  8014d3:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8014d5:	89 34 24             	mov    %esi,(%esp)
  8014d8:	e8 aa fd ff ff       	call   801287 <fd2data>
  8014dd:	83 c4 10             	add    $0x10,%esp
  8014e0:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8014e2:	89 d8                	mov    %ebx,%eax
  8014e4:	c1 e8 16             	shr    $0x16,%eax
  8014e7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014ee:	a8 01                	test   $0x1,%al
  8014f0:	74 11                	je     801503 <dup+0x78>
  8014f2:	89 d8                	mov    %ebx,%eax
  8014f4:	c1 e8 0c             	shr    $0xc,%eax
  8014f7:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014fe:	f6 c2 01             	test   $0x1,%dl
  801501:	75 39                	jne    80153c <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801503:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801506:	89 d0                	mov    %edx,%eax
  801508:	c1 e8 0c             	shr    $0xc,%eax
  80150b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801512:	83 ec 0c             	sub    $0xc,%esp
  801515:	25 07 0e 00 00       	and    $0xe07,%eax
  80151a:	50                   	push   %eax
  80151b:	56                   	push   %esi
  80151c:	6a 00                	push   $0x0
  80151e:	52                   	push   %edx
  80151f:	6a 00                	push   $0x0
  801521:	e8 8a f8 ff ff       	call   800db0 <sys_page_map>
  801526:	89 c3                	mov    %eax,%ebx
  801528:	83 c4 20             	add    $0x20,%esp
  80152b:	85 c0                	test   %eax,%eax
  80152d:	78 31                	js     801560 <dup+0xd5>
		goto err;

	return newfdnum;
  80152f:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801532:	89 d8                	mov    %ebx,%eax
  801534:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801537:	5b                   	pop    %ebx
  801538:	5e                   	pop    %esi
  801539:	5f                   	pop    %edi
  80153a:	5d                   	pop    %ebp
  80153b:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80153c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801543:	83 ec 0c             	sub    $0xc,%esp
  801546:	25 07 0e 00 00       	and    $0xe07,%eax
  80154b:	50                   	push   %eax
  80154c:	57                   	push   %edi
  80154d:	6a 00                	push   $0x0
  80154f:	53                   	push   %ebx
  801550:	6a 00                	push   $0x0
  801552:	e8 59 f8 ff ff       	call   800db0 <sys_page_map>
  801557:	89 c3                	mov    %eax,%ebx
  801559:	83 c4 20             	add    $0x20,%esp
  80155c:	85 c0                	test   %eax,%eax
  80155e:	79 a3                	jns    801503 <dup+0x78>
	sys_page_unmap(0, newfd);
  801560:	83 ec 08             	sub    $0x8,%esp
  801563:	56                   	push   %esi
  801564:	6a 00                	push   $0x0
  801566:	e8 8b f8 ff ff       	call   800df6 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80156b:	83 c4 08             	add    $0x8,%esp
  80156e:	57                   	push   %edi
  80156f:	6a 00                	push   $0x0
  801571:	e8 80 f8 ff ff       	call   800df6 <sys_page_unmap>
	return r;
  801576:	83 c4 10             	add    $0x10,%esp
  801579:	eb b7                	jmp    801532 <dup+0xa7>

0080157b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80157b:	f3 0f 1e fb          	endbr32 
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
  801582:	53                   	push   %ebx
  801583:	83 ec 1c             	sub    $0x1c,%esp
  801586:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801589:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80158c:	50                   	push   %eax
  80158d:	53                   	push   %ebx
  80158e:	e8 65 fd ff ff       	call   8012f8 <fd_lookup>
  801593:	83 c4 10             	add    $0x10,%esp
  801596:	85 c0                	test   %eax,%eax
  801598:	78 3f                	js     8015d9 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80159a:	83 ec 08             	sub    $0x8,%esp
  80159d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015a0:	50                   	push   %eax
  8015a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a4:	ff 30                	pushl  (%eax)
  8015a6:	e8 a1 fd ff ff       	call   80134c <dev_lookup>
  8015ab:	83 c4 10             	add    $0x10,%esp
  8015ae:	85 c0                	test   %eax,%eax
  8015b0:	78 27                	js     8015d9 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015b5:	8b 42 08             	mov    0x8(%edx),%eax
  8015b8:	83 e0 03             	and    $0x3,%eax
  8015bb:	83 f8 01             	cmp    $0x1,%eax
  8015be:	74 1e                	je     8015de <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8015c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c3:	8b 40 08             	mov    0x8(%eax),%eax
  8015c6:	85 c0                	test   %eax,%eax
  8015c8:	74 35                	je     8015ff <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8015ca:	83 ec 04             	sub    $0x4,%esp
  8015cd:	ff 75 10             	pushl  0x10(%ebp)
  8015d0:	ff 75 0c             	pushl  0xc(%ebp)
  8015d3:	52                   	push   %edx
  8015d4:	ff d0                	call   *%eax
  8015d6:	83 c4 10             	add    $0x10,%esp
}
  8015d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015dc:	c9                   	leave  
  8015dd:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8015de:	a1 20 44 80 00       	mov    0x804420,%eax
  8015e3:	8b 40 48             	mov    0x48(%eax),%eax
  8015e6:	83 ec 04             	sub    $0x4,%esp
  8015e9:	53                   	push   %ebx
  8015ea:	50                   	push   %eax
  8015eb:	68 bd 29 80 00       	push   $0x8029bd
  8015f0:	e8 28 ed ff ff       	call   80031d <cprintf>
		return -E_INVAL;
  8015f5:	83 c4 10             	add    $0x10,%esp
  8015f8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015fd:	eb da                	jmp    8015d9 <read+0x5e>
		return -E_NOT_SUPP;
  8015ff:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801604:	eb d3                	jmp    8015d9 <read+0x5e>

00801606 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801606:	f3 0f 1e fb          	endbr32 
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
  80160d:	57                   	push   %edi
  80160e:	56                   	push   %esi
  80160f:	53                   	push   %ebx
  801610:	83 ec 0c             	sub    $0xc,%esp
  801613:	8b 7d 08             	mov    0x8(%ebp),%edi
  801616:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801619:	bb 00 00 00 00       	mov    $0x0,%ebx
  80161e:	eb 02                	jmp    801622 <readn+0x1c>
  801620:	01 c3                	add    %eax,%ebx
  801622:	39 f3                	cmp    %esi,%ebx
  801624:	73 21                	jae    801647 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801626:	83 ec 04             	sub    $0x4,%esp
  801629:	89 f0                	mov    %esi,%eax
  80162b:	29 d8                	sub    %ebx,%eax
  80162d:	50                   	push   %eax
  80162e:	89 d8                	mov    %ebx,%eax
  801630:	03 45 0c             	add    0xc(%ebp),%eax
  801633:	50                   	push   %eax
  801634:	57                   	push   %edi
  801635:	e8 41 ff ff ff       	call   80157b <read>
		if (m < 0)
  80163a:	83 c4 10             	add    $0x10,%esp
  80163d:	85 c0                	test   %eax,%eax
  80163f:	78 04                	js     801645 <readn+0x3f>
			return m;
		if (m == 0)
  801641:	75 dd                	jne    801620 <readn+0x1a>
  801643:	eb 02                	jmp    801647 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801645:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801647:	89 d8                	mov    %ebx,%eax
  801649:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80164c:	5b                   	pop    %ebx
  80164d:	5e                   	pop    %esi
  80164e:	5f                   	pop    %edi
  80164f:	5d                   	pop    %ebp
  801650:	c3                   	ret    

00801651 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801651:	f3 0f 1e fb          	endbr32 
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
  801658:	53                   	push   %ebx
  801659:	83 ec 1c             	sub    $0x1c,%esp
  80165c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80165f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801662:	50                   	push   %eax
  801663:	53                   	push   %ebx
  801664:	e8 8f fc ff ff       	call   8012f8 <fd_lookup>
  801669:	83 c4 10             	add    $0x10,%esp
  80166c:	85 c0                	test   %eax,%eax
  80166e:	78 3a                	js     8016aa <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801670:	83 ec 08             	sub    $0x8,%esp
  801673:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801676:	50                   	push   %eax
  801677:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167a:	ff 30                	pushl  (%eax)
  80167c:	e8 cb fc ff ff       	call   80134c <dev_lookup>
  801681:	83 c4 10             	add    $0x10,%esp
  801684:	85 c0                	test   %eax,%eax
  801686:	78 22                	js     8016aa <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801688:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80168b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80168f:	74 1e                	je     8016af <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801691:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801694:	8b 52 0c             	mov    0xc(%edx),%edx
  801697:	85 d2                	test   %edx,%edx
  801699:	74 35                	je     8016d0 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80169b:	83 ec 04             	sub    $0x4,%esp
  80169e:	ff 75 10             	pushl  0x10(%ebp)
  8016a1:	ff 75 0c             	pushl  0xc(%ebp)
  8016a4:	50                   	push   %eax
  8016a5:	ff d2                	call   *%edx
  8016a7:	83 c4 10             	add    $0x10,%esp
}
  8016aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016ad:	c9                   	leave  
  8016ae:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016af:	a1 20 44 80 00       	mov    0x804420,%eax
  8016b4:	8b 40 48             	mov    0x48(%eax),%eax
  8016b7:	83 ec 04             	sub    $0x4,%esp
  8016ba:	53                   	push   %ebx
  8016bb:	50                   	push   %eax
  8016bc:	68 d9 29 80 00       	push   $0x8029d9
  8016c1:	e8 57 ec ff ff       	call   80031d <cprintf>
		return -E_INVAL;
  8016c6:	83 c4 10             	add    $0x10,%esp
  8016c9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016ce:	eb da                	jmp    8016aa <write+0x59>
		return -E_NOT_SUPP;
  8016d0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016d5:	eb d3                	jmp    8016aa <write+0x59>

008016d7 <seek>:

int
seek(int fdnum, off_t offset)
{
  8016d7:	f3 0f 1e fb          	endbr32 
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
  8016de:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016e4:	50                   	push   %eax
  8016e5:	ff 75 08             	pushl  0x8(%ebp)
  8016e8:	e8 0b fc ff ff       	call   8012f8 <fd_lookup>
  8016ed:	83 c4 10             	add    $0x10,%esp
  8016f0:	85 c0                	test   %eax,%eax
  8016f2:	78 0e                	js     801702 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8016f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016fa:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8016fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801702:	c9                   	leave  
  801703:	c3                   	ret    

00801704 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801704:	f3 0f 1e fb          	endbr32 
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
  80170b:	53                   	push   %ebx
  80170c:	83 ec 1c             	sub    $0x1c,%esp
  80170f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801712:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801715:	50                   	push   %eax
  801716:	53                   	push   %ebx
  801717:	e8 dc fb ff ff       	call   8012f8 <fd_lookup>
  80171c:	83 c4 10             	add    $0x10,%esp
  80171f:	85 c0                	test   %eax,%eax
  801721:	78 37                	js     80175a <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801723:	83 ec 08             	sub    $0x8,%esp
  801726:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801729:	50                   	push   %eax
  80172a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80172d:	ff 30                	pushl  (%eax)
  80172f:	e8 18 fc ff ff       	call   80134c <dev_lookup>
  801734:	83 c4 10             	add    $0x10,%esp
  801737:	85 c0                	test   %eax,%eax
  801739:	78 1f                	js     80175a <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80173b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80173e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801742:	74 1b                	je     80175f <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801744:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801747:	8b 52 18             	mov    0x18(%edx),%edx
  80174a:	85 d2                	test   %edx,%edx
  80174c:	74 32                	je     801780 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80174e:	83 ec 08             	sub    $0x8,%esp
  801751:	ff 75 0c             	pushl  0xc(%ebp)
  801754:	50                   	push   %eax
  801755:	ff d2                	call   *%edx
  801757:	83 c4 10             	add    $0x10,%esp
}
  80175a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80175d:	c9                   	leave  
  80175e:	c3                   	ret    
			thisenv->env_id, fdnum);
  80175f:	a1 20 44 80 00       	mov    0x804420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801764:	8b 40 48             	mov    0x48(%eax),%eax
  801767:	83 ec 04             	sub    $0x4,%esp
  80176a:	53                   	push   %ebx
  80176b:	50                   	push   %eax
  80176c:	68 9c 29 80 00       	push   $0x80299c
  801771:	e8 a7 eb ff ff       	call   80031d <cprintf>
		return -E_INVAL;
  801776:	83 c4 10             	add    $0x10,%esp
  801779:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80177e:	eb da                	jmp    80175a <ftruncate+0x56>
		return -E_NOT_SUPP;
  801780:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801785:	eb d3                	jmp    80175a <ftruncate+0x56>

00801787 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801787:	f3 0f 1e fb          	endbr32 
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
  80178e:	53                   	push   %ebx
  80178f:	83 ec 1c             	sub    $0x1c,%esp
  801792:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801795:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801798:	50                   	push   %eax
  801799:	ff 75 08             	pushl  0x8(%ebp)
  80179c:	e8 57 fb ff ff       	call   8012f8 <fd_lookup>
  8017a1:	83 c4 10             	add    $0x10,%esp
  8017a4:	85 c0                	test   %eax,%eax
  8017a6:	78 4b                	js     8017f3 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017a8:	83 ec 08             	sub    $0x8,%esp
  8017ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ae:	50                   	push   %eax
  8017af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b2:	ff 30                	pushl  (%eax)
  8017b4:	e8 93 fb ff ff       	call   80134c <dev_lookup>
  8017b9:	83 c4 10             	add    $0x10,%esp
  8017bc:	85 c0                	test   %eax,%eax
  8017be:	78 33                	js     8017f3 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8017c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8017c7:	74 2f                	je     8017f8 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017c9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017cc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017d3:	00 00 00 
	stat->st_isdir = 0;
  8017d6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017dd:	00 00 00 
	stat->st_dev = dev;
  8017e0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8017e6:	83 ec 08             	sub    $0x8,%esp
  8017e9:	53                   	push   %ebx
  8017ea:	ff 75 f0             	pushl  -0x10(%ebp)
  8017ed:	ff 50 14             	call   *0x14(%eax)
  8017f0:	83 c4 10             	add    $0x10,%esp
}
  8017f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    
		return -E_NOT_SUPP;
  8017f8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017fd:	eb f4                	jmp    8017f3 <fstat+0x6c>

008017ff <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8017ff:	f3 0f 1e fb          	endbr32 
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
  801806:	56                   	push   %esi
  801807:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801808:	83 ec 08             	sub    $0x8,%esp
  80180b:	6a 00                	push   $0x0
  80180d:	ff 75 08             	pushl  0x8(%ebp)
  801810:	e8 fb 01 00 00       	call   801a10 <open>
  801815:	89 c3                	mov    %eax,%ebx
  801817:	83 c4 10             	add    $0x10,%esp
  80181a:	85 c0                	test   %eax,%eax
  80181c:	78 1b                	js     801839 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80181e:	83 ec 08             	sub    $0x8,%esp
  801821:	ff 75 0c             	pushl  0xc(%ebp)
  801824:	50                   	push   %eax
  801825:	e8 5d ff ff ff       	call   801787 <fstat>
  80182a:	89 c6                	mov    %eax,%esi
	close(fd);
  80182c:	89 1c 24             	mov    %ebx,(%esp)
  80182f:	e8 fd fb ff ff       	call   801431 <close>
	return r;
  801834:	83 c4 10             	add    $0x10,%esp
  801837:	89 f3                	mov    %esi,%ebx
}
  801839:	89 d8                	mov    %ebx,%eax
  80183b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80183e:	5b                   	pop    %ebx
  80183f:	5e                   	pop    %esi
  801840:	5d                   	pop    %ebp
  801841:	c3                   	ret    

00801842 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
  801845:	56                   	push   %esi
  801846:	53                   	push   %ebx
  801847:	89 c6                	mov    %eax,%esi
  801849:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80184b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801852:	74 27                	je     80187b <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801854:	6a 07                	push   $0x7
  801856:	68 00 50 80 00       	push   $0x805000
  80185b:	56                   	push   %esi
  80185c:	ff 35 00 40 80 00    	pushl  0x804000
  801862:	e8 c2 08 00 00       	call   802129 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801867:	83 c4 0c             	add    $0xc,%esp
  80186a:	6a 00                	push   $0x0
  80186c:	53                   	push   %ebx
  80186d:	6a 00                	push   $0x0
  80186f:	e8 30 08 00 00       	call   8020a4 <ipc_recv>
}
  801874:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801877:	5b                   	pop    %ebx
  801878:	5e                   	pop    %esi
  801879:	5d                   	pop    %ebp
  80187a:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80187b:	83 ec 0c             	sub    $0xc,%esp
  80187e:	6a 01                	push   $0x1
  801880:	e8 fc 08 00 00       	call   802181 <ipc_find_env>
  801885:	a3 00 40 80 00       	mov    %eax,0x804000
  80188a:	83 c4 10             	add    $0x10,%esp
  80188d:	eb c5                	jmp    801854 <fsipc+0x12>

0080188f <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80188f:	f3 0f 1e fb          	endbr32 
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
  801896:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801899:	8b 45 08             	mov    0x8(%ebp),%eax
  80189c:	8b 40 0c             	mov    0xc(%eax),%eax
  80189f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8018a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a7:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b1:	b8 02 00 00 00       	mov    $0x2,%eax
  8018b6:	e8 87 ff ff ff       	call   801842 <fsipc>
}
  8018bb:	c9                   	leave  
  8018bc:	c3                   	ret    

008018bd <devfile_flush>:
{
  8018bd:	f3 0f 1e fb          	endbr32 
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8018cd:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8018d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d7:	b8 06 00 00 00       	mov    $0x6,%eax
  8018dc:	e8 61 ff ff ff       	call   801842 <fsipc>
}
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <devfile_stat>:
{
  8018e3:	f3 0f 1e fb          	endbr32 
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
  8018ea:	53                   	push   %ebx
  8018eb:	83 ec 04             	sub    $0x4,%esp
  8018ee:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8018f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8018f7:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8018fc:	ba 00 00 00 00       	mov    $0x0,%edx
  801901:	b8 05 00 00 00       	mov    $0x5,%eax
  801906:	e8 37 ff ff ff       	call   801842 <fsipc>
  80190b:	85 c0                	test   %eax,%eax
  80190d:	78 2c                	js     80193b <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80190f:	83 ec 08             	sub    $0x8,%esp
  801912:	68 00 50 80 00       	push   $0x805000
  801917:	53                   	push   %ebx
  801918:	e8 0a f0 ff ff       	call   800927 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80191d:	a1 80 50 80 00       	mov    0x805080,%eax
  801922:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801928:	a1 84 50 80 00       	mov    0x805084,%eax
  80192d:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801933:	83 c4 10             	add    $0x10,%esp
  801936:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80193b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <devfile_write>:
{
  801940:	f3 0f 1e fb          	endbr32 
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
  801947:	83 ec 0c             	sub    $0xc,%esp
  80194a:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80194d:	8b 55 08             	mov    0x8(%ebp),%edx
  801950:	8b 52 0c             	mov    0xc(%edx),%edx
  801953:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801959:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80195e:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801963:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  801966:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  80196b:	50                   	push   %eax
  80196c:	ff 75 0c             	pushl  0xc(%ebp)
  80196f:	68 08 50 80 00       	push   $0x805008
  801974:	e8 64 f1 ff ff       	call   800add <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801979:	ba 00 00 00 00       	mov    $0x0,%edx
  80197e:	b8 04 00 00 00       	mov    $0x4,%eax
  801983:	e8 ba fe ff ff       	call   801842 <fsipc>
}
  801988:	c9                   	leave  
  801989:	c3                   	ret    

0080198a <devfile_read>:
{
  80198a:	f3 0f 1e fb          	endbr32 
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
  801991:	56                   	push   %esi
  801992:	53                   	push   %ebx
  801993:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801996:	8b 45 08             	mov    0x8(%ebp),%eax
  801999:	8b 40 0c             	mov    0xc(%eax),%eax
  80199c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8019a1:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ac:	b8 03 00 00 00       	mov    $0x3,%eax
  8019b1:	e8 8c fe ff ff       	call   801842 <fsipc>
  8019b6:	89 c3                	mov    %eax,%ebx
  8019b8:	85 c0                	test   %eax,%eax
  8019ba:	78 1f                	js     8019db <devfile_read+0x51>
	assert(r <= n);
  8019bc:	39 f0                	cmp    %esi,%eax
  8019be:	77 24                	ja     8019e4 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8019c0:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019c5:	7f 33                	jg     8019fa <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019c7:	83 ec 04             	sub    $0x4,%esp
  8019ca:	50                   	push   %eax
  8019cb:	68 00 50 80 00       	push   $0x805000
  8019d0:	ff 75 0c             	pushl  0xc(%ebp)
  8019d3:	e8 05 f1 ff ff       	call   800add <memmove>
	return r;
  8019d8:	83 c4 10             	add    $0x10,%esp
}
  8019db:	89 d8                	mov    %ebx,%eax
  8019dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019e0:	5b                   	pop    %ebx
  8019e1:	5e                   	pop    %esi
  8019e2:	5d                   	pop    %ebp
  8019e3:	c3                   	ret    
	assert(r <= n);
  8019e4:	68 08 2a 80 00       	push   $0x802a08
  8019e9:	68 0f 2a 80 00       	push   $0x802a0f
  8019ee:	6a 7c                	push   $0x7c
  8019f0:	68 24 2a 80 00       	push   $0x802a24
  8019f5:	e8 3c e8 ff ff       	call   800236 <_panic>
	assert(r <= PGSIZE);
  8019fa:	68 2f 2a 80 00       	push   $0x802a2f
  8019ff:	68 0f 2a 80 00       	push   $0x802a0f
  801a04:	6a 7d                	push   $0x7d
  801a06:	68 24 2a 80 00       	push   $0x802a24
  801a0b:	e8 26 e8 ff ff       	call   800236 <_panic>

00801a10 <open>:
{
  801a10:	f3 0f 1e fb          	endbr32 
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
  801a17:	56                   	push   %esi
  801a18:	53                   	push   %ebx
  801a19:	83 ec 1c             	sub    $0x1c,%esp
  801a1c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a1f:	56                   	push   %esi
  801a20:	e8 bf ee ff ff       	call   8008e4 <strlen>
  801a25:	83 c4 10             	add    $0x10,%esp
  801a28:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a2d:	7f 6c                	jg     801a9b <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801a2f:	83 ec 0c             	sub    $0xc,%esp
  801a32:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a35:	50                   	push   %eax
  801a36:	e8 67 f8 ff ff       	call   8012a2 <fd_alloc>
  801a3b:	89 c3                	mov    %eax,%ebx
  801a3d:	83 c4 10             	add    $0x10,%esp
  801a40:	85 c0                	test   %eax,%eax
  801a42:	78 3c                	js     801a80 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801a44:	83 ec 08             	sub    $0x8,%esp
  801a47:	56                   	push   %esi
  801a48:	68 00 50 80 00       	push   $0x805000
  801a4d:	e8 d5 ee ff ff       	call   800927 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a52:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a55:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a5d:	b8 01 00 00 00       	mov    $0x1,%eax
  801a62:	e8 db fd ff ff       	call   801842 <fsipc>
  801a67:	89 c3                	mov    %eax,%ebx
  801a69:	83 c4 10             	add    $0x10,%esp
  801a6c:	85 c0                	test   %eax,%eax
  801a6e:	78 19                	js     801a89 <open+0x79>
	return fd2num(fd);
  801a70:	83 ec 0c             	sub    $0xc,%esp
  801a73:	ff 75 f4             	pushl  -0xc(%ebp)
  801a76:	e8 f8 f7 ff ff       	call   801273 <fd2num>
  801a7b:	89 c3                	mov    %eax,%ebx
  801a7d:	83 c4 10             	add    $0x10,%esp
}
  801a80:	89 d8                	mov    %ebx,%eax
  801a82:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a85:	5b                   	pop    %ebx
  801a86:	5e                   	pop    %esi
  801a87:	5d                   	pop    %ebp
  801a88:	c3                   	ret    
		fd_close(fd, 0);
  801a89:	83 ec 08             	sub    $0x8,%esp
  801a8c:	6a 00                	push   $0x0
  801a8e:	ff 75 f4             	pushl  -0xc(%ebp)
  801a91:	e8 10 f9 ff ff       	call   8013a6 <fd_close>
		return r;
  801a96:	83 c4 10             	add    $0x10,%esp
  801a99:	eb e5                	jmp    801a80 <open+0x70>
		return -E_BAD_PATH;
  801a9b:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801aa0:	eb de                	jmp    801a80 <open+0x70>

00801aa2 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801aa2:	f3 0f 1e fb          	endbr32 
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
  801aa9:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801aac:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab1:	b8 08 00 00 00       	mov    $0x8,%eax
  801ab6:	e8 87 fd ff ff       	call   801842 <fsipc>
}
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    

00801abd <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801abd:	f3 0f 1e fb          	endbr32 
  801ac1:	55                   	push   %ebp
  801ac2:	89 e5                	mov    %esp,%ebp
  801ac4:	56                   	push   %esi
  801ac5:	53                   	push   %ebx
  801ac6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ac9:	83 ec 0c             	sub    $0xc,%esp
  801acc:	ff 75 08             	pushl  0x8(%ebp)
  801acf:	e8 b3 f7 ff ff       	call   801287 <fd2data>
  801ad4:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ad6:	83 c4 08             	add    $0x8,%esp
  801ad9:	68 3b 2a 80 00       	push   $0x802a3b
  801ade:	53                   	push   %ebx
  801adf:	e8 43 ee ff ff       	call   800927 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ae4:	8b 46 04             	mov    0x4(%esi),%eax
  801ae7:	2b 06                	sub    (%esi),%eax
  801ae9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801aef:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801af6:	00 00 00 
	stat->st_dev = &devpipe;
  801af9:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801b00:	30 80 00 
	return 0;
}
  801b03:	b8 00 00 00 00       	mov    $0x0,%eax
  801b08:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b0b:	5b                   	pop    %ebx
  801b0c:	5e                   	pop    %esi
  801b0d:	5d                   	pop    %ebp
  801b0e:	c3                   	ret    

00801b0f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b0f:	f3 0f 1e fb          	endbr32 
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
  801b16:	53                   	push   %ebx
  801b17:	83 ec 0c             	sub    $0xc,%esp
  801b1a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b1d:	53                   	push   %ebx
  801b1e:	6a 00                	push   $0x0
  801b20:	e8 d1 f2 ff ff       	call   800df6 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b25:	89 1c 24             	mov    %ebx,(%esp)
  801b28:	e8 5a f7 ff ff       	call   801287 <fd2data>
  801b2d:	83 c4 08             	add    $0x8,%esp
  801b30:	50                   	push   %eax
  801b31:	6a 00                	push   $0x0
  801b33:	e8 be f2 ff ff       	call   800df6 <sys_page_unmap>
}
  801b38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <_pipeisclosed>:
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
  801b40:	57                   	push   %edi
  801b41:	56                   	push   %esi
  801b42:	53                   	push   %ebx
  801b43:	83 ec 1c             	sub    $0x1c,%esp
  801b46:	89 c7                	mov    %eax,%edi
  801b48:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b4a:	a1 20 44 80 00       	mov    0x804420,%eax
  801b4f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b52:	83 ec 0c             	sub    $0xc,%esp
  801b55:	57                   	push   %edi
  801b56:	e8 63 06 00 00       	call   8021be <pageref>
  801b5b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b5e:	89 34 24             	mov    %esi,(%esp)
  801b61:	e8 58 06 00 00       	call   8021be <pageref>
		nn = thisenv->env_runs;
  801b66:	8b 15 20 44 80 00    	mov    0x804420,%edx
  801b6c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b6f:	83 c4 10             	add    $0x10,%esp
  801b72:	39 cb                	cmp    %ecx,%ebx
  801b74:	74 1b                	je     801b91 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b76:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b79:	75 cf                	jne    801b4a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b7b:	8b 42 58             	mov    0x58(%edx),%eax
  801b7e:	6a 01                	push   $0x1
  801b80:	50                   	push   %eax
  801b81:	53                   	push   %ebx
  801b82:	68 42 2a 80 00       	push   $0x802a42
  801b87:	e8 91 e7 ff ff       	call   80031d <cprintf>
  801b8c:	83 c4 10             	add    $0x10,%esp
  801b8f:	eb b9                	jmp    801b4a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801b91:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b94:	0f 94 c0             	sete   %al
  801b97:	0f b6 c0             	movzbl %al,%eax
}
  801b9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b9d:	5b                   	pop    %ebx
  801b9e:	5e                   	pop    %esi
  801b9f:	5f                   	pop    %edi
  801ba0:	5d                   	pop    %ebp
  801ba1:	c3                   	ret    

00801ba2 <devpipe_write>:
{
  801ba2:	f3 0f 1e fb          	endbr32 
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
  801ba9:	57                   	push   %edi
  801baa:	56                   	push   %esi
  801bab:	53                   	push   %ebx
  801bac:	83 ec 28             	sub    $0x28,%esp
  801baf:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801bb2:	56                   	push   %esi
  801bb3:	e8 cf f6 ff ff       	call   801287 <fd2data>
  801bb8:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801bba:	83 c4 10             	add    $0x10,%esp
  801bbd:	bf 00 00 00 00       	mov    $0x0,%edi
  801bc2:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801bc5:	74 4f                	je     801c16 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801bc7:	8b 43 04             	mov    0x4(%ebx),%eax
  801bca:	8b 0b                	mov    (%ebx),%ecx
  801bcc:	8d 51 20             	lea    0x20(%ecx),%edx
  801bcf:	39 d0                	cmp    %edx,%eax
  801bd1:	72 14                	jb     801be7 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801bd3:	89 da                	mov    %ebx,%edx
  801bd5:	89 f0                	mov    %esi,%eax
  801bd7:	e8 61 ff ff ff       	call   801b3d <_pipeisclosed>
  801bdc:	85 c0                	test   %eax,%eax
  801bde:	75 3b                	jne    801c1b <devpipe_write+0x79>
			sys_yield();
  801be0:	e8 61 f1 ff ff       	call   800d46 <sys_yield>
  801be5:	eb e0                	jmp    801bc7 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801be7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bea:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801bee:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801bf1:	89 c2                	mov    %eax,%edx
  801bf3:	c1 fa 1f             	sar    $0x1f,%edx
  801bf6:	89 d1                	mov    %edx,%ecx
  801bf8:	c1 e9 1b             	shr    $0x1b,%ecx
  801bfb:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801bfe:	83 e2 1f             	and    $0x1f,%edx
  801c01:	29 ca                	sub    %ecx,%edx
  801c03:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c07:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c0b:	83 c0 01             	add    $0x1,%eax
  801c0e:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c11:	83 c7 01             	add    $0x1,%edi
  801c14:	eb ac                	jmp    801bc2 <devpipe_write+0x20>
	return i;
  801c16:	8b 45 10             	mov    0x10(%ebp),%eax
  801c19:	eb 05                	jmp    801c20 <devpipe_write+0x7e>
				return 0;
  801c1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c23:	5b                   	pop    %ebx
  801c24:	5e                   	pop    %esi
  801c25:	5f                   	pop    %edi
  801c26:	5d                   	pop    %ebp
  801c27:	c3                   	ret    

00801c28 <devpipe_read>:
{
  801c28:	f3 0f 1e fb          	endbr32 
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
  801c2f:	57                   	push   %edi
  801c30:	56                   	push   %esi
  801c31:	53                   	push   %ebx
  801c32:	83 ec 18             	sub    $0x18,%esp
  801c35:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c38:	57                   	push   %edi
  801c39:	e8 49 f6 ff ff       	call   801287 <fd2data>
  801c3e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c40:	83 c4 10             	add    $0x10,%esp
  801c43:	be 00 00 00 00       	mov    $0x0,%esi
  801c48:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c4b:	75 14                	jne    801c61 <devpipe_read+0x39>
	return i;
  801c4d:	8b 45 10             	mov    0x10(%ebp),%eax
  801c50:	eb 02                	jmp    801c54 <devpipe_read+0x2c>
				return i;
  801c52:	89 f0                	mov    %esi,%eax
}
  801c54:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c57:	5b                   	pop    %ebx
  801c58:	5e                   	pop    %esi
  801c59:	5f                   	pop    %edi
  801c5a:	5d                   	pop    %ebp
  801c5b:	c3                   	ret    
			sys_yield();
  801c5c:	e8 e5 f0 ff ff       	call   800d46 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801c61:	8b 03                	mov    (%ebx),%eax
  801c63:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c66:	75 18                	jne    801c80 <devpipe_read+0x58>
			if (i > 0)
  801c68:	85 f6                	test   %esi,%esi
  801c6a:	75 e6                	jne    801c52 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801c6c:	89 da                	mov    %ebx,%edx
  801c6e:	89 f8                	mov    %edi,%eax
  801c70:	e8 c8 fe ff ff       	call   801b3d <_pipeisclosed>
  801c75:	85 c0                	test   %eax,%eax
  801c77:	74 e3                	je     801c5c <devpipe_read+0x34>
				return 0;
  801c79:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7e:	eb d4                	jmp    801c54 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c80:	99                   	cltd   
  801c81:	c1 ea 1b             	shr    $0x1b,%edx
  801c84:	01 d0                	add    %edx,%eax
  801c86:	83 e0 1f             	and    $0x1f,%eax
  801c89:	29 d0                	sub    %edx,%eax
  801c8b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801c90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c93:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801c96:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801c99:	83 c6 01             	add    $0x1,%esi
  801c9c:	eb aa                	jmp    801c48 <devpipe_read+0x20>

00801c9e <pipe>:
{
  801c9e:	f3 0f 1e fb          	endbr32 
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
  801ca5:	56                   	push   %esi
  801ca6:	53                   	push   %ebx
  801ca7:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801caa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cad:	50                   	push   %eax
  801cae:	e8 ef f5 ff ff       	call   8012a2 <fd_alloc>
  801cb3:	89 c3                	mov    %eax,%ebx
  801cb5:	83 c4 10             	add    $0x10,%esp
  801cb8:	85 c0                	test   %eax,%eax
  801cba:	0f 88 23 01 00 00    	js     801de3 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cc0:	83 ec 04             	sub    $0x4,%esp
  801cc3:	68 07 04 00 00       	push   $0x407
  801cc8:	ff 75 f4             	pushl  -0xc(%ebp)
  801ccb:	6a 00                	push   $0x0
  801ccd:	e8 97 f0 ff ff       	call   800d69 <sys_page_alloc>
  801cd2:	89 c3                	mov    %eax,%ebx
  801cd4:	83 c4 10             	add    $0x10,%esp
  801cd7:	85 c0                	test   %eax,%eax
  801cd9:	0f 88 04 01 00 00    	js     801de3 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801cdf:	83 ec 0c             	sub    $0xc,%esp
  801ce2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ce5:	50                   	push   %eax
  801ce6:	e8 b7 f5 ff ff       	call   8012a2 <fd_alloc>
  801ceb:	89 c3                	mov    %eax,%ebx
  801ced:	83 c4 10             	add    $0x10,%esp
  801cf0:	85 c0                	test   %eax,%eax
  801cf2:	0f 88 db 00 00 00    	js     801dd3 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cf8:	83 ec 04             	sub    $0x4,%esp
  801cfb:	68 07 04 00 00       	push   $0x407
  801d00:	ff 75 f0             	pushl  -0x10(%ebp)
  801d03:	6a 00                	push   $0x0
  801d05:	e8 5f f0 ff ff       	call   800d69 <sys_page_alloc>
  801d0a:	89 c3                	mov    %eax,%ebx
  801d0c:	83 c4 10             	add    $0x10,%esp
  801d0f:	85 c0                	test   %eax,%eax
  801d11:	0f 88 bc 00 00 00    	js     801dd3 <pipe+0x135>
	va = fd2data(fd0);
  801d17:	83 ec 0c             	sub    $0xc,%esp
  801d1a:	ff 75 f4             	pushl  -0xc(%ebp)
  801d1d:	e8 65 f5 ff ff       	call   801287 <fd2data>
  801d22:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d24:	83 c4 0c             	add    $0xc,%esp
  801d27:	68 07 04 00 00       	push   $0x407
  801d2c:	50                   	push   %eax
  801d2d:	6a 00                	push   $0x0
  801d2f:	e8 35 f0 ff ff       	call   800d69 <sys_page_alloc>
  801d34:	89 c3                	mov    %eax,%ebx
  801d36:	83 c4 10             	add    $0x10,%esp
  801d39:	85 c0                	test   %eax,%eax
  801d3b:	0f 88 82 00 00 00    	js     801dc3 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d41:	83 ec 0c             	sub    $0xc,%esp
  801d44:	ff 75 f0             	pushl  -0x10(%ebp)
  801d47:	e8 3b f5 ff ff       	call   801287 <fd2data>
  801d4c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d53:	50                   	push   %eax
  801d54:	6a 00                	push   $0x0
  801d56:	56                   	push   %esi
  801d57:	6a 00                	push   $0x0
  801d59:	e8 52 f0 ff ff       	call   800db0 <sys_page_map>
  801d5e:	89 c3                	mov    %eax,%ebx
  801d60:	83 c4 20             	add    $0x20,%esp
  801d63:	85 c0                	test   %eax,%eax
  801d65:	78 4e                	js     801db5 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801d67:	a1 20 30 80 00       	mov    0x803020,%eax
  801d6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d6f:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801d71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d74:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801d7b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d7e:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801d80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d83:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801d8a:	83 ec 0c             	sub    $0xc,%esp
  801d8d:	ff 75 f4             	pushl  -0xc(%ebp)
  801d90:	e8 de f4 ff ff       	call   801273 <fd2num>
  801d95:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d98:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d9a:	83 c4 04             	add    $0x4,%esp
  801d9d:	ff 75 f0             	pushl  -0x10(%ebp)
  801da0:	e8 ce f4 ff ff       	call   801273 <fd2num>
  801da5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801da8:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801dab:	83 c4 10             	add    $0x10,%esp
  801dae:	bb 00 00 00 00       	mov    $0x0,%ebx
  801db3:	eb 2e                	jmp    801de3 <pipe+0x145>
	sys_page_unmap(0, va);
  801db5:	83 ec 08             	sub    $0x8,%esp
  801db8:	56                   	push   %esi
  801db9:	6a 00                	push   $0x0
  801dbb:	e8 36 f0 ff ff       	call   800df6 <sys_page_unmap>
  801dc0:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801dc3:	83 ec 08             	sub    $0x8,%esp
  801dc6:	ff 75 f0             	pushl  -0x10(%ebp)
  801dc9:	6a 00                	push   $0x0
  801dcb:	e8 26 f0 ff ff       	call   800df6 <sys_page_unmap>
  801dd0:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801dd3:	83 ec 08             	sub    $0x8,%esp
  801dd6:	ff 75 f4             	pushl  -0xc(%ebp)
  801dd9:	6a 00                	push   $0x0
  801ddb:	e8 16 f0 ff ff       	call   800df6 <sys_page_unmap>
  801de0:	83 c4 10             	add    $0x10,%esp
}
  801de3:	89 d8                	mov    %ebx,%eax
  801de5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801de8:	5b                   	pop    %ebx
  801de9:	5e                   	pop    %esi
  801dea:	5d                   	pop    %ebp
  801deb:	c3                   	ret    

00801dec <pipeisclosed>:
{
  801dec:	f3 0f 1e fb          	endbr32 
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
  801df3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801df6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801df9:	50                   	push   %eax
  801dfa:	ff 75 08             	pushl  0x8(%ebp)
  801dfd:	e8 f6 f4 ff ff       	call   8012f8 <fd_lookup>
  801e02:	83 c4 10             	add    $0x10,%esp
  801e05:	85 c0                	test   %eax,%eax
  801e07:	78 18                	js     801e21 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801e09:	83 ec 0c             	sub    $0xc,%esp
  801e0c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e0f:	e8 73 f4 ff ff       	call   801287 <fd2data>
  801e14:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e19:	e8 1f fd ff ff       	call   801b3d <_pipeisclosed>
  801e1e:	83 c4 10             	add    $0x10,%esp
}
  801e21:	c9                   	leave  
  801e22:	c3                   	ret    

00801e23 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  801e23:	f3 0f 1e fb          	endbr32 
  801e27:	55                   	push   %ebp
  801e28:	89 e5                	mov    %esp,%ebp
  801e2a:	56                   	push   %esi
  801e2b:	53                   	push   %ebx
  801e2c:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  801e2f:	85 f6                	test   %esi,%esi
  801e31:	74 13                	je     801e46 <wait+0x23>
	e = &envs[ENVX(envid)];
  801e33:	89 f3                	mov    %esi,%ebx
  801e35:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801e3b:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  801e3e:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  801e44:	eb 1b                	jmp    801e61 <wait+0x3e>
	assert(envid != 0);
  801e46:	68 5a 2a 80 00       	push   $0x802a5a
  801e4b:	68 0f 2a 80 00       	push   $0x802a0f
  801e50:	6a 09                	push   $0x9
  801e52:	68 65 2a 80 00       	push   $0x802a65
  801e57:	e8 da e3 ff ff       	call   800236 <_panic>
		sys_yield();
  801e5c:	e8 e5 ee ff ff       	call   800d46 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801e61:	8b 43 48             	mov    0x48(%ebx),%eax
  801e64:	39 f0                	cmp    %esi,%eax
  801e66:	75 07                	jne    801e6f <wait+0x4c>
  801e68:	8b 43 54             	mov    0x54(%ebx),%eax
  801e6b:	85 c0                	test   %eax,%eax
  801e6d:	75 ed                	jne    801e5c <wait+0x39>
}
  801e6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e72:	5b                   	pop    %ebx
  801e73:	5e                   	pop    %esi
  801e74:	5d                   	pop    %ebp
  801e75:	c3                   	ret    

00801e76 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801e76:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801e7a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7f:	c3                   	ret    

00801e80 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e80:	f3 0f 1e fb          	endbr32 
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
  801e87:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801e8a:	68 70 2a 80 00       	push   $0x802a70
  801e8f:	ff 75 0c             	pushl  0xc(%ebp)
  801e92:	e8 90 ea ff ff       	call   800927 <strcpy>
	return 0;
}
  801e97:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9c:	c9                   	leave  
  801e9d:	c3                   	ret    

00801e9e <devcons_write>:
{
  801e9e:	f3 0f 1e fb          	endbr32 
  801ea2:	55                   	push   %ebp
  801ea3:	89 e5                	mov    %esp,%ebp
  801ea5:	57                   	push   %edi
  801ea6:	56                   	push   %esi
  801ea7:	53                   	push   %ebx
  801ea8:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801eae:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801eb3:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801eb9:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ebc:	73 31                	jae    801eef <devcons_write+0x51>
		m = n - tot;
  801ebe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801ec1:	29 f3                	sub    %esi,%ebx
  801ec3:	83 fb 7f             	cmp    $0x7f,%ebx
  801ec6:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801ecb:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801ece:	83 ec 04             	sub    $0x4,%esp
  801ed1:	53                   	push   %ebx
  801ed2:	89 f0                	mov    %esi,%eax
  801ed4:	03 45 0c             	add    0xc(%ebp),%eax
  801ed7:	50                   	push   %eax
  801ed8:	57                   	push   %edi
  801ed9:	e8 ff eb ff ff       	call   800add <memmove>
		sys_cputs(buf, m);
  801ede:	83 c4 08             	add    $0x8,%esp
  801ee1:	53                   	push   %ebx
  801ee2:	57                   	push   %edi
  801ee3:	e8 b1 ed ff ff       	call   800c99 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801ee8:	01 de                	add    %ebx,%esi
  801eea:	83 c4 10             	add    $0x10,%esp
  801eed:	eb ca                	jmp    801eb9 <devcons_write+0x1b>
}
  801eef:	89 f0                	mov    %esi,%eax
  801ef1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ef4:	5b                   	pop    %ebx
  801ef5:	5e                   	pop    %esi
  801ef6:	5f                   	pop    %edi
  801ef7:	5d                   	pop    %ebp
  801ef8:	c3                   	ret    

00801ef9 <devcons_read>:
{
  801ef9:	f3 0f 1e fb          	endbr32 
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
  801f00:	83 ec 08             	sub    $0x8,%esp
  801f03:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801f08:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f0c:	74 21                	je     801f2f <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801f0e:	e8 a8 ed ff ff       	call   800cbb <sys_cgetc>
  801f13:	85 c0                	test   %eax,%eax
  801f15:	75 07                	jne    801f1e <devcons_read+0x25>
		sys_yield();
  801f17:	e8 2a ee ff ff       	call   800d46 <sys_yield>
  801f1c:	eb f0                	jmp    801f0e <devcons_read+0x15>
	if (c < 0)
  801f1e:	78 0f                	js     801f2f <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801f20:	83 f8 04             	cmp    $0x4,%eax
  801f23:	74 0c                	je     801f31 <devcons_read+0x38>
	*(char*)vbuf = c;
  801f25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f28:	88 02                	mov    %al,(%edx)
	return 1;
  801f2a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801f2f:	c9                   	leave  
  801f30:	c3                   	ret    
		return 0;
  801f31:	b8 00 00 00 00       	mov    $0x0,%eax
  801f36:	eb f7                	jmp    801f2f <devcons_read+0x36>

00801f38 <cputchar>:
{
  801f38:	f3 0f 1e fb          	endbr32 
  801f3c:	55                   	push   %ebp
  801f3d:	89 e5                	mov    %esp,%ebp
  801f3f:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f42:	8b 45 08             	mov    0x8(%ebp),%eax
  801f45:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801f48:	6a 01                	push   $0x1
  801f4a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f4d:	50                   	push   %eax
  801f4e:	e8 46 ed ff ff       	call   800c99 <sys_cputs>
}
  801f53:	83 c4 10             	add    $0x10,%esp
  801f56:	c9                   	leave  
  801f57:	c3                   	ret    

00801f58 <getchar>:
{
  801f58:	f3 0f 1e fb          	endbr32 
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
  801f5f:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801f62:	6a 01                	push   $0x1
  801f64:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f67:	50                   	push   %eax
  801f68:	6a 00                	push   $0x0
  801f6a:	e8 0c f6 ff ff       	call   80157b <read>
	if (r < 0)
  801f6f:	83 c4 10             	add    $0x10,%esp
  801f72:	85 c0                	test   %eax,%eax
  801f74:	78 06                	js     801f7c <getchar+0x24>
	if (r < 1)
  801f76:	74 06                	je     801f7e <getchar+0x26>
	return c;
  801f78:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801f7c:	c9                   	leave  
  801f7d:	c3                   	ret    
		return -E_EOF;
  801f7e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801f83:	eb f7                	jmp    801f7c <getchar+0x24>

00801f85 <iscons>:
{
  801f85:	f3 0f 1e fb          	endbr32 
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
  801f8c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f8f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f92:	50                   	push   %eax
  801f93:	ff 75 08             	pushl  0x8(%ebp)
  801f96:	e8 5d f3 ff ff       	call   8012f8 <fd_lookup>
  801f9b:	83 c4 10             	add    $0x10,%esp
  801f9e:	85 c0                	test   %eax,%eax
  801fa0:	78 11                	js     801fb3 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa5:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801fab:	39 10                	cmp    %edx,(%eax)
  801fad:	0f 94 c0             	sete   %al
  801fb0:	0f b6 c0             	movzbl %al,%eax
}
  801fb3:	c9                   	leave  
  801fb4:	c3                   	ret    

00801fb5 <opencons>:
{
  801fb5:	f3 0f 1e fb          	endbr32 
  801fb9:	55                   	push   %ebp
  801fba:	89 e5                	mov    %esp,%ebp
  801fbc:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801fbf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fc2:	50                   	push   %eax
  801fc3:	e8 da f2 ff ff       	call   8012a2 <fd_alloc>
  801fc8:	83 c4 10             	add    $0x10,%esp
  801fcb:	85 c0                	test   %eax,%eax
  801fcd:	78 3a                	js     802009 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801fcf:	83 ec 04             	sub    $0x4,%esp
  801fd2:	68 07 04 00 00       	push   $0x407
  801fd7:	ff 75 f4             	pushl  -0xc(%ebp)
  801fda:	6a 00                	push   $0x0
  801fdc:	e8 88 ed ff ff       	call   800d69 <sys_page_alloc>
  801fe1:	83 c4 10             	add    $0x10,%esp
  801fe4:	85 c0                	test   %eax,%eax
  801fe6:	78 21                	js     802009 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801feb:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ff1:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801ffd:	83 ec 0c             	sub    $0xc,%esp
  802000:	50                   	push   %eax
  802001:	e8 6d f2 ff ff       	call   801273 <fd2num>
  802006:	83 c4 10             	add    $0x10,%esp
}
  802009:	c9                   	leave  
  80200a:	c3                   	ret    

0080200b <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80200b:	f3 0f 1e fb          	endbr32 
  80200f:	55                   	push   %ebp
  802010:	89 e5                	mov    %esp,%ebp
  802012:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802015:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80201c:	74 0a                	je     802028 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80201e:	8b 45 08             	mov    0x8(%ebp),%eax
  802021:	a3 00 60 80 00       	mov    %eax,0x806000
}
  802026:	c9                   	leave  
  802027:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  802028:	83 ec 04             	sub    $0x4,%esp
  80202b:	6a 07                	push   $0x7
  80202d:	68 00 f0 bf ee       	push   $0xeebff000
  802032:	6a 00                	push   $0x0
  802034:	e8 30 ed ff ff       	call   800d69 <sys_page_alloc>
  802039:	83 c4 10             	add    $0x10,%esp
  80203c:	85 c0                	test   %eax,%eax
  80203e:	78 2a                	js     80206a <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  802040:	83 ec 08             	sub    $0x8,%esp
  802043:	68 7e 20 80 00       	push   $0x80207e
  802048:	6a 00                	push   $0x0
  80204a:	e8 79 ee ff ff       	call   800ec8 <sys_env_set_pgfault_upcall>
  80204f:	83 c4 10             	add    $0x10,%esp
  802052:	85 c0                	test   %eax,%eax
  802054:	79 c8                	jns    80201e <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  802056:	83 ec 04             	sub    $0x4,%esp
  802059:	68 a8 2a 80 00       	push   $0x802aa8
  80205e:	6a 25                	push   $0x25
  802060:	68 e0 2a 80 00       	push   $0x802ae0
  802065:	e8 cc e1 ff ff       	call   800236 <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  80206a:	83 ec 04             	sub    $0x4,%esp
  80206d:	68 7c 2a 80 00       	push   $0x802a7c
  802072:	6a 22                	push   $0x22
  802074:	68 e0 2a 80 00       	push   $0x802ae0
  802079:	e8 b8 e1 ff ff       	call   800236 <_panic>

0080207e <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80207e:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80207f:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  802084:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802086:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  802089:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  80208d:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  802091:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802094:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  802096:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  80209a:	83 c4 08             	add    $0x8,%esp
	popal
  80209d:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  80209e:	83 c4 04             	add    $0x4,%esp
	popfl
  8020a1:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  8020a2:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  8020a3:	c3                   	ret    

008020a4 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8020a4:	f3 0f 1e fb          	endbr32 
  8020a8:	55                   	push   %ebp
  8020a9:	89 e5                	mov    %esp,%ebp
  8020ab:	56                   	push   %esi
  8020ac:	53                   	push   %ebx
  8020ad:	8b 75 08             	mov    0x8(%ebp),%esi
  8020b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  8020b6:	85 c0                	test   %eax,%eax
  8020b8:	74 3d                	je     8020f7 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  8020ba:	83 ec 0c             	sub    $0xc,%esp
  8020bd:	50                   	push   %eax
  8020be:	e8 72 ee ff ff       	call   800f35 <sys_ipc_recv>
  8020c3:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  8020c6:	85 f6                	test   %esi,%esi
  8020c8:	74 0b                	je     8020d5 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8020ca:	8b 15 20 44 80 00    	mov    0x804420,%edx
  8020d0:	8b 52 74             	mov    0x74(%edx),%edx
  8020d3:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  8020d5:	85 db                	test   %ebx,%ebx
  8020d7:	74 0b                	je     8020e4 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  8020d9:	8b 15 20 44 80 00    	mov    0x804420,%edx
  8020df:	8b 52 78             	mov    0x78(%edx),%edx
  8020e2:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  8020e4:	85 c0                	test   %eax,%eax
  8020e6:	78 21                	js     802109 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  8020e8:	a1 20 44 80 00       	mov    0x804420,%eax
  8020ed:	8b 40 70             	mov    0x70(%eax),%eax
}
  8020f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020f3:	5b                   	pop    %ebx
  8020f4:	5e                   	pop    %esi
  8020f5:	5d                   	pop    %ebp
  8020f6:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  8020f7:	83 ec 0c             	sub    $0xc,%esp
  8020fa:	68 00 00 c0 ee       	push   $0xeec00000
  8020ff:	e8 31 ee ff ff       	call   800f35 <sys_ipc_recv>
  802104:	83 c4 10             	add    $0x10,%esp
  802107:	eb bd                	jmp    8020c6 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  802109:	85 f6                	test   %esi,%esi
  80210b:	74 10                	je     80211d <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  80210d:	85 db                	test   %ebx,%ebx
  80210f:	75 df                	jne    8020f0 <ipc_recv+0x4c>
  802111:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802118:	00 00 00 
  80211b:	eb d3                	jmp    8020f0 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  80211d:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802124:	00 00 00 
  802127:	eb e4                	jmp    80210d <ipc_recv+0x69>

00802129 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802129:	f3 0f 1e fb          	endbr32 
  80212d:	55                   	push   %ebp
  80212e:	89 e5                	mov    %esp,%ebp
  802130:	57                   	push   %edi
  802131:	56                   	push   %esi
  802132:	53                   	push   %ebx
  802133:	83 ec 0c             	sub    $0xc,%esp
  802136:	8b 7d 08             	mov    0x8(%ebp),%edi
  802139:	8b 75 0c             	mov    0xc(%ebp),%esi
  80213c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  80213f:	85 db                	test   %ebx,%ebx
  802141:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802146:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  802149:	ff 75 14             	pushl  0x14(%ebp)
  80214c:	53                   	push   %ebx
  80214d:	56                   	push   %esi
  80214e:	57                   	push   %edi
  80214f:	e8 ba ed ff ff       	call   800f0e <sys_ipc_try_send>
  802154:	83 c4 10             	add    $0x10,%esp
  802157:	85 c0                	test   %eax,%eax
  802159:	79 1e                	jns    802179 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  80215b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80215e:	75 07                	jne    802167 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  802160:	e8 e1 eb ff ff       	call   800d46 <sys_yield>
  802165:	eb e2                	jmp    802149 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  802167:	50                   	push   %eax
  802168:	68 ee 2a 80 00       	push   $0x802aee
  80216d:	6a 59                	push   $0x59
  80216f:	68 09 2b 80 00       	push   $0x802b09
  802174:	e8 bd e0 ff ff       	call   800236 <_panic>
	}
}
  802179:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80217c:	5b                   	pop    %ebx
  80217d:	5e                   	pop    %esi
  80217e:	5f                   	pop    %edi
  80217f:	5d                   	pop    %ebp
  802180:	c3                   	ret    

00802181 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802181:	f3 0f 1e fb          	endbr32 
  802185:	55                   	push   %ebp
  802186:	89 e5                	mov    %esp,%ebp
  802188:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80218b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802190:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802193:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802199:	8b 52 50             	mov    0x50(%edx),%edx
  80219c:	39 ca                	cmp    %ecx,%edx
  80219e:	74 11                	je     8021b1 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8021a0:	83 c0 01             	add    $0x1,%eax
  8021a3:	3d 00 04 00 00       	cmp    $0x400,%eax
  8021a8:	75 e6                	jne    802190 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8021aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8021af:	eb 0b                	jmp    8021bc <ipc_find_env+0x3b>
			return envs[i].env_id;
  8021b1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8021b4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8021b9:	8b 40 48             	mov    0x48(%eax),%eax
}
  8021bc:	5d                   	pop    %ebp
  8021bd:	c3                   	ret    

008021be <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8021be:	f3 0f 1e fb          	endbr32 
  8021c2:	55                   	push   %ebp
  8021c3:	89 e5                	mov    %esp,%ebp
  8021c5:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8021c8:	89 c2                	mov    %eax,%edx
  8021ca:	c1 ea 16             	shr    $0x16,%edx
  8021cd:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8021d4:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8021d9:	f6 c1 01             	test   $0x1,%cl
  8021dc:	74 1c                	je     8021fa <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8021de:	c1 e8 0c             	shr    $0xc,%eax
  8021e1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8021e8:	a8 01                	test   $0x1,%al
  8021ea:	74 0e                	je     8021fa <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8021ec:	c1 e8 0c             	shr    $0xc,%eax
  8021ef:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8021f6:	ef 
  8021f7:	0f b7 d2             	movzwl %dx,%edx
}
  8021fa:	89 d0                	mov    %edx,%eax
  8021fc:	5d                   	pop    %ebp
  8021fd:	c3                   	ret    
  8021fe:	66 90                	xchg   %ax,%ax

00802200 <__udivdi3>:
  802200:	f3 0f 1e fb          	endbr32 
  802204:	55                   	push   %ebp
  802205:	57                   	push   %edi
  802206:	56                   	push   %esi
  802207:	53                   	push   %ebx
  802208:	83 ec 1c             	sub    $0x1c,%esp
  80220b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80220f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802213:	8b 74 24 34          	mov    0x34(%esp),%esi
  802217:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80221b:	85 d2                	test   %edx,%edx
  80221d:	75 19                	jne    802238 <__udivdi3+0x38>
  80221f:	39 f3                	cmp    %esi,%ebx
  802221:	76 4d                	jbe    802270 <__udivdi3+0x70>
  802223:	31 ff                	xor    %edi,%edi
  802225:	89 e8                	mov    %ebp,%eax
  802227:	89 f2                	mov    %esi,%edx
  802229:	f7 f3                	div    %ebx
  80222b:	89 fa                	mov    %edi,%edx
  80222d:	83 c4 1c             	add    $0x1c,%esp
  802230:	5b                   	pop    %ebx
  802231:	5e                   	pop    %esi
  802232:	5f                   	pop    %edi
  802233:	5d                   	pop    %ebp
  802234:	c3                   	ret    
  802235:	8d 76 00             	lea    0x0(%esi),%esi
  802238:	39 f2                	cmp    %esi,%edx
  80223a:	76 14                	jbe    802250 <__udivdi3+0x50>
  80223c:	31 ff                	xor    %edi,%edi
  80223e:	31 c0                	xor    %eax,%eax
  802240:	89 fa                	mov    %edi,%edx
  802242:	83 c4 1c             	add    $0x1c,%esp
  802245:	5b                   	pop    %ebx
  802246:	5e                   	pop    %esi
  802247:	5f                   	pop    %edi
  802248:	5d                   	pop    %ebp
  802249:	c3                   	ret    
  80224a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802250:	0f bd fa             	bsr    %edx,%edi
  802253:	83 f7 1f             	xor    $0x1f,%edi
  802256:	75 48                	jne    8022a0 <__udivdi3+0xa0>
  802258:	39 f2                	cmp    %esi,%edx
  80225a:	72 06                	jb     802262 <__udivdi3+0x62>
  80225c:	31 c0                	xor    %eax,%eax
  80225e:	39 eb                	cmp    %ebp,%ebx
  802260:	77 de                	ja     802240 <__udivdi3+0x40>
  802262:	b8 01 00 00 00       	mov    $0x1,%eax
  802267:	eb d7                	jmp    802240 <__udivdi3+0x40>
  802269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802270:	89 d9                	mov    %ebx,%ecx
  802272:	85 db                	test   %ebx,%ebx
  802274:	75 0b                	jne    802281 <__udivdi3+0x81>
  802276:	b8 01 00 00 00       	mov    $0x1,%eax
  80227b:	31 d2                	xor    %edx,%edx
  80227d:	f7 f3                	div    %ebx
  80227f:	89 c1                	mov    %eax,%ecx
  802281:	31 d2                	xor    %edx,%edx
  802283:	89 f0                	mov    %esi,%eax
  802285:	f7 f1                	div    %ecx
  802287:	89 c6                	mov    %eax,%esi
  802289:	89 e8                	mov    %ebp,%eax
  80228b:	89 f7                	mov    %esi,%edi
  80228d:	f7 f1                	div    %ecx
  80228f:	89 fa                	mov    %edi,%edx
  802291:	83 c4 1c             	add    $0x1c,%esp
  802294:	5b                   	pop    %ebx
  802295:	5e                   	pop    %esi
  802296:	5f                   	pop    %edi
  802297:	5d                   	pop    %ebp
  802298:	c3                   	ret    
  802299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022a0:	89 f9                	mov    %edi,%ecx
  8022a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8022a7:	29 f8                	sub    %edi,%eax
  8022a9:	d3 e2                	shl    %cl,%edx
  8022ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022af:	89 c1                	mov    %eax,%ecx
  8022b1:	89 da                	mov    %ebx,%edx
  8022b3:	d3 ea                	shr    %cl,%edx
  8022b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8022b9:	09 d1                	or     %edx,%ecx
  8022bb:	89 f2                	mov    %esi,%edx
  8022bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022c1:	89 f9                	mov    %edi,%ecx
  8022c3:	d3 e3                	shl    %cl,%ebx
  8022c5:	89 c1                	mov    %eax,%ecx
  8022c7:	d3 ea                	shr    %cl,%edx
  8022c9:	89 f9                	mov    %edi,%ecx
  8022cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8022cf:	89 eb                	mov    %ebp,%ebx
  8022d1:	d3 e6                	shl    %cl,%esi
  8022d3:	89 c1                	mov    %eax,%ecx
  8022d5:	d3 eb                	shr    %cl,%ebx
  8022d7:	09 de                	or     %ebx,%esi
  8022d9:	89 f0                	mov    %esi,%eax
  8022db:	f7 74 24 08          	divl   0x8(%esp)
  8022df:	89 d6                	mov    %edx,%esi
  8022e1:	89 c3                	mov    %eax,%ebx
  8022e3:	f7 64 24 0c          	mull   0xc(%esp)
  8022e7:	39 d6                	cmp    %edx,%esi
  8022e9:	72 15                	jb     802300 <__udivdi3+0x100>
  8022eb:	89 f9                	mov    %edi,%ecx
  8022ed:	d3 e5                	shl    %cl,%ebp
  8022ef:	39 c5                	cmp    %eax,%ebp
  8022f1:	73 04                	jae    8022f7 <__udivdi3+0xf7>
  8022f3:	39 d6                	cmp    %edx,%esi
  8022f5:	74 09                	je     802300 <__udivdi3+0x100>
  8022f7:	89 d8                	mov    %ebx,%eax
  8022f9:	31 ff                	xor    %edi,%edi
  8022fb:	e9 40 ff ff ff       	jmp    802240 <__udivdi3+0x40>
  802300:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802303:	31 ff                	xor    %edi,%edi
  802305:	e9 36 ff ff ff       	jmp    802240 <__udivdi3+0x40>
  80230a:	66 90                	xchg   %ax,%ax
  80230c:	66 90                	xchg   %ax,%ax
  80230e:	66 90                	xchg   %ax,%ax

00802310 <__umoddi3>:
  802310:	f3 0f 1e fb          	endbr32 
  802314:	55                   	push   %ebp
  802315:	57                   	push   %edi
  802316:	56                   	push   %esi
  802317:	53                   	push   %ebx
  802318:	83 ec 1c             	sub    $0x1c,%esp
  80231b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80231f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802323:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802327:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80232b:	85 c0                	test   %eax,%eax
  80232d:	75 19                	jne    802348 <__umoddi3+0x38>
  80232f:	39 df                	cmp    %ebx,%edi
  802331:	76 5d                	jbe    802390 <__umoddi3+0x80>
  802333:	89 f0                	mov    %esi,%eax
  802335:	89 da                	mov    %ebx,%edx
  802337:	f7 f7                	div    %edi
  802339:	89 d0                	mov    %edx,%eax
  80233b:	31 d2                	xor    %edx,%edx
  80233d:	83 c4 1c             	add    $0x1c,%esp
  802340:	5b                   	pop    %ebx
  802341:	5e                   	pop    %esi
  802342:	5f                   	pop    %edi
  802343:	5d                   	pop    %ebp
  802344:	c3                   	ret    
  802345:	8d 76 00             	lea    0x0(%esi),%esi
  802348:	89 f2                	mov    %esi,%edx
  80234a:	39 d8                	cmp    %ebx,%eax
  80234c:	76 12                	jbe    802360 <__umoddi3+0x50>
  80234e:	89 f0                	mov    %esi,%eax
  802350:	89 da                	mov    %ebx,%edx
  802352:	83 c4 1c             	add    $0x1c,%esp
  802355:	5b                   	pop    %ebx
  802356:	5e                   	pop    %esi
  802357:	5f                   	pop    %edi
  802358:	5d                   	pop    %ebp
  802359:	c3                   	ret    
  80235a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802360:	0f bd e8             	bsr    %eax,%ebp
  802363:	83 f5 1f             	xor    $0x1f,%ebp
  802366:	75 50                	jne    8023b8 <__umoddi3+0xa8>
  802368:	39 d8                	cmp    %ebx,%eax
  80236a:	0f 82 e0 00 00 00    	jb     802450 <__umoddi3+0x140>
  802370:	89 d9                	mov    %ebx,%ecx
  802372:	39 f7                	cmp    %esi,%edi
  802374:	0f 86 d6 00 00 00    	jbe    802450 <__umoddi3+0x140>
  80237a:	89 d0                	mov    %edx,%eax
  80237c:	89 ca                	mov    %ecx,%edx
  80237e:	83 c4 1c             	add    $0x1c,%esp
  802381:	5b                   	pop    %ebx
  802382:	5e                   	pop    %esi
  802383:	5f                   	pop    %edi
  802384:	5d                   	pop    %ebp
  802385:	c3                   	ret    
  802386:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80238d:	8d 76 00             	lea    0x0(%esi),%esi
  802390:	89 fd                	mov    %edi,%ebp
  802392:	85 ff                	test   %edi,%edi
  802394:	75 0b                	jne    8023a1 <__umoddi3+0x91>
  802396:	b8 01 00 00 00       	mov    $0x1,%eax
  80239b:	31 d2                	xor    %edx,%edx
  80239d:	f7 f7                	div    %edi
  80239f:	89 c5                	mov    %eax,%ebp
  8023a1:	89 d8                	mov    %ebx,%eax
  8023a3:	31 d2                	xor    %edx,%edx
  8023a5:	f7 f5                	div    %ebp
  8023a7:	89 f0                	mov    %esi,%eax
  8023a9:	f7 f5                	div    %ebp
  8023ab:	89 d0                	mov    %edx,%eax
  8023ad:	31 d2                	xor    %edx,%edx
  8023af:	eb 8c                	jmp    80233d <__umoddi3+0x2d>
  8023b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023b8:	89 e9                	mov    %ebp,%ecx
  8023ba:	ba 20 00 00 00       	mov    $0x20,%edx
  8023bf:	29 ea                	sub    %ebp,%edx
  8023c1:	d3 e0                	shl    %cl,%eax
  8023c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023c7:	89 d1                	mov    %edx,%ecx
  8023c9:	89 f8                	mov    %edi,%eax
  8023cb:	d3 e8                	shr    %cl,%eax
  8023cd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8023d5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8023d9:	09 c1                	or     %eax,%ecx
  8023db:	89 d8                	mov    %ebx,%eax
  8023dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023e1:	89 e9                	mov    %ebp,%ecx
  8023e3:	d3 e7                	shl    %cl,%edi
  8023e5:	89 d1                	mov    %edx,%ecx
  8023e7:	d3 e8                	shr    %cl,%eax
  8023e9:	89 e9                	mov    %ebp,%ecx
  8023eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023ef:	d3 e3                	shl    %cl,%ebx
  8023f1:	89 c7                	mov    %eax,%edi
  8023f3:	89 d1                	mov    %edx,%ecx
  8023f5:	89 f0                	mov    %esi,%eax
  8023f7:	d3 e8                	shr    %cl,%eax
  8023f9:	89 e9                	mov    %ebp,%ecx
  8023fb:	89 fa                	mov    %edi,%edx
  8023fd:	d3 e6                	shl    %cl,%esi
  8023ff:	09 d8                	or     %ebx,%eax
  802401:	f7 74 24 08          	divl   0x8(%esp)
  802405:	89 d1                	mov    %edx,%ecx
  802407:	89 f3                	mov    %esi,%ebx
  802409:	f7 64 24 0c          	mull   0xc(%esp)
  80240d:	89 c6                	mov    %eax,%esi
  80240f:	89 d7                	mov    %edx,%edi
  802411:	39 d1                	cmp    %edx,%ecx
  802413:	72 06                	jb     80241b <__umoddi3+0x10b>
  802415:	75 10                	jne    802427 <__umoddi3+0x117>
  802417:	39 c3                	cmp    %eax,%ebx
  802419:	73 0c                	jae    802427 <__umoddi3+0x117>
  80241b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80241f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802423:	89 d7                	mov    %edx,%edi
  802425:	89 c6                	mov    %eax,%esi
  802427:	89 ca                	mov    %ecx,%edx
  802429:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80242e:	29 f3                	sub    %esi,%ebx
  802430:	19 fa                	sbb    %edi,%edx
  802432:	89 d0                	mov    %edx,%eax
  802434:	d3 e0                	shl    %cl,%eax
  802436:	89 e9                	mov    %ebp,%ecx
  802438:	d3 eb                	shr    %cl,%ebx
  80243a:	d3 ea                	shr    %cl,%edx
  80243c:	09 d8                	or     %ebx,%eax
  80243e:	83 c4 1c             	add    $0x1c,%esp
  802441:	5b                   	pop    %ebx
  802442:	5e                   	pop    %esi
  802443:	5f                   	pop    %edi
  802444:	5d                   	pop    %ebp
  802445:	c3                   	ret    
  802446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80244d:	8d 76 00             	lea    0x0(%esi),%esi
  802450:	29 fe                	sub    %edi,%esi
  802452:	19 c3                	sbb    %eax,%ebx
  802454:	89 f2                	mov    %esi,%edx
  802456:	89 d9                	mov    %ebx,%ecx
  802458:	e9 1d ff ff ff       	jmp    80237a <__umoddi3+0x6a>
