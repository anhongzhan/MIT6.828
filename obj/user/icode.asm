
obj/user/icode.debug:     file format elf32-i386


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
  80002c:	e8 07 01 00 00       	call   800138 <libmain>
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
  80003c:	81 ec 1c 02 00 00    	sub    $0x21c,%esp
	int fd, n, r;
	char buf[512+1];

	binaryname = "icode";
  800042:	c7 05 00 40 80 00 60 	movl   $0x802b60,0x804000
  800049:	2b 80 00 

	cprintf("icode startup\n");
  80004c:	68 66 2b 80 00       	push   $0x802b66
  800051:	e8 31 02 00 00       	call   800287 <cprintf>

	cprintf("icode: open /motd\n");
  800056:	c7 04 24 75 2b 80 00 	movl   $0x802b75,(%esp)
  80005d:	e8 25 02 00 00       	call   800287 <cprintf>
	if ((fd = open("/motd", O_RDONLY)) < 0)
  800062:	83 c4 08             	add    $0x8,%esp
  800065:	6a 00                	push   $0x0
  800067:	68 88 2b 80 00       	push   $0x802b88
  80006c:	e8 c4 16 00 00       	call   801735 <open>
  800071:	89 c6                	mov    %eax,%esi
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	85 c0                	test   %eax,%eax
  800078:	78 18                	js     800092 <umain+0x5f>
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
  80007a:	83 ec 0c             	sub    $0xc,%esp
  80007d:	68 b1 2b 80 00       	push   $0x802bb1
  800082:	e8 00 02 00 00       	call   800287 <cprintf>
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	8d 9d f7 fd ff ff    	lea    -0x209(%ebp),%ebx
  800090:	eb 1f                	jmp    8000b1 <umain+0x7e>
		panic("icode: open /motd: %e", fd);
  800092:	50                   	push   %eax
  800093:	68 8e 2b 80 00       	push   $0x802b8e
  800098:	6a 0f                	push   $0xf
  80009a:	68 a4 2b 80 00       	push   $0x802ba4
  80009f:	e8 fc 00 00 00       	call   8001a0 <_panic>
		sys_cputs(buf, n);
  8000a4:	83 ec 08             	sub    $0x8,%esp
  8000a7:	50                   	push   %eax
  8000a8:	53                   	push   %ebx
  8000a9:	e8 55 0b 00 00       	call   800c03 <sys_cputs>
  8000ae:	83 c4 10             	add    $0x10,%esp
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  8000b1:	83 ec 04             	sub    $0x4,%esp
  8000b4:	68 00 02 00 00       	push   $0x200
  8000b9:	53                   	push   %ebx
  8000ba:	56                   	push   %esi
  8000bb:	e8 e0 11 00 00       	call   8012a0 <read>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	85 c0                	test   %eax,%eax
  8000c5:	7f dd                	jg     8000a4 <umain+0x71>

	cprintf("icode: close /motd\n");
  8000c7:	83 ec 0c             	sub    $0xc,%esp
  8000ca:	68 c4 2b 80 00       	push   $0x802bc4
  8000cf:	e8 b3 01 00 00       	call   800287 <cprintf>
	close(fd);
  8000d4:	89 34 24             	mov    %esi,(%esp)
  8000d7:	e8 7a 10 00 00       	call   801156 <close>

	cprintf("icode: spawn /init\n");
  8000dc:	c7 04 24 d8 2b 80 00 	movl   $0x802bd8,(%esp)
  8000e3:	e8 9f 01 00 00       	call   800287 <cprintf>
	if ((r = spawnl("/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8000e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000ef:	68 ec 2b 80 00       	push   $0x802bec
  8000f4:	68 f5 2b 80 00       	push   $0x802bf5
  8000f9:	68 ff 2b 80 00       	push   $0x802bff
  8000fe:	68 fe 2b 80 00       	push   $0x802bfe
  800103:	e8 36 1c 00 00       	call   801d3e <spawnl>
  800108:	83 c4 20             	add    $0x20,%esp
  80010b:	85 c0                	test   %eax,%eax
  80010d:	78 17                	js     800126 <umain+0xf3>
		panic("icode: spawn /init: %e", r);

	cprintf("icode: exiting\n");
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 1b 2c 80 00       	push   $0x802c1b
  800117:	e8 6b 01 00 00       	call   800287 <cprintf>
}
  80011c:	83 c4 10             	add    $0x10,%esp
  80011f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800122:	5b                   	pop    %ebx
  800123:	5e                   	pop    %esi
  800124:	5d                   	pop    %ebp
  800125:	c3                   	ret    
		panic("icode: spawn /init: %e", r);
  800126:	50                   	push   %eax
  800127:	68 04 2c 80 00       	push   $0x802c04
  80012c:	6a 1a                	push   $0x1a
  80012e:	68 a4 2b 80 00       	push   $0x802ba4
  800133:	e8 68 00 00 00       	call   8001a0 <_panic>

00800138 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800138:	f3 0f 1e fb          	endbr32 
  80013c:	55                   	push   %ebp
  80013d:	89 e5                	mov    %esp,%ebp
  80013f:	56                   	push   %esi
  800140:	53                   	push   %ebx
  800141:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800144:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800147:	e8 41 0b 00 00       	call   800c8d <sys_getenvid>
  80014c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800151:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800154:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800159:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80015e:	85 db                	test   %ebx,%ebx
  800160:	7e 07                	jle    800169 <libmain+0x31>
		binaryname = argv[0];
  800162:	8b 06                	mov    (%esi),%eax
  800164:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800169:	83 ec 08             	sub    $0x8,%esp
  80016c:	56                   	push   %esi
  80016d:	53                   	push   %ebx
  80016e:	e8 c0 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800173:	e8 0a 00 00 00       	call   800182 <exit>
}
  800178:	83 c4 10             	add    $0x10,%esp
  80017b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80017e:	5b                   	pop    %ebx
  80017f:	5e                   	pop    %esi
  800180:	5d                   	pop    %ebp
  800181:	c3                   	ret    

00800182 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800182:	f3 0f 1e fb          	endbr32 
  800186:	55                   	push   %ebp
  800187:	89 e5                	mov    %esp,%ebp
  800189:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80018c:	e8 f6 0f 00 00       	call   801187 <close_all>
	sys_env_destroy(0);
  800191:	83 ec 0c             	sub    $0xc,%esp
  800194:	6a 00                	push   $0x0
  800196:	e8 ad 0a 00 00       	call   800c48 <sys_env_destroy>
}
  80019b:	83 c4 10             	add    $0x10,%esp
  80019e:	c9                   	leave  
  80019f:	c3                   	ret    

008001a0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001a0:	f3 0f 1e fb          	endbr32 
  8001a4:	55                   	push   %ebp
  8001a5:	89 e5                	mov    %esp,%ebp
  8001a7:	56                   	push   %esi
  8001a8:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8001a9:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001ac:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8001b2:	e8 d6 0a 00 00       	call   800c8d <sys_getenvid>
  8001b7:	83 ec 0c             	sub    $0xc,%esp
  8001ba:	ff 75 0c             	pushl  0xc(%ebp)
  8001bd:	ff 75 08             	pushl  0x8(%ebp)
  8001c0:	56                   	push   %esi
  8001c1:	50                   	push   %eax
  8001c2:	68 38 2c 80 00       	push   $0x802c38
  8001c7:	e8 bb 00 00 00       	call   800287 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001cc:	83 c4 18             	add    $0x18,%esp
  8001cf:	53                   	push   %ebx
  8001d0:	ff 75 10             	pushl  0x10(%ebp)
  8001d3:	e8 5a 00 00 00       	call   800232 <vcprintf>
	cprintf("\n");
  8001d8:	c7 04 24 67 31 80 00 	movl   $0x803167,(%esp)
  8001df:	e8 a3 00 00 00       	call   800287 <cprintf>
  8001e4:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001e7:	cc                   	int3   
  8001e8:	eb fd                	jmp    8001e7 <_panic+0x47>

008001ea <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001ea:	f3 0f 1e fb          	endbr32 
  8001ee:	55                   	push   %ebp
  8001ef:	89 e5                	mov    %esp,%ebp
  8001f1:	53                   	push   %ebx
  8001f2:	83 ec 04             	sub    $0x4,%esp
  8001f5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001f8:	8b 13                	mov    (%ebx),%edx
  8001fa:	8d 42 01             	lea    0x1(%edx),%eax
  8001fd:	89 03                	mov    %eax,(%ebx)
  8001ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800202:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800206:	3d ff 00 00 00       	cmp    $0xff,%eax
  80020b:	74 09                	je     800216 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80020d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800211:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800214:	c9                   	leave  
  800215:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800216:	83 ec 08             	sub    $0x8,%esp
  800219:	68 ff 00 00 00       	push   $0xff
  80021e:	8d 43 08             	lea    0x8(%ebx),%eax
  800221:	50                   	push   %eax
  800222:	e8 dc 09 00 00       	call   800c03 <sys_cputs>
		b->idx = 0;
  800227:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80022d:	83 c4 10             	add    $0x10,%esp
  800230:	eb db                	jmp    80020d <putch+0x23>

00800232 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800232:	f3 0f 1e fb          	endbr32 
  800236:	55                   	push   %ebp
  800237:	89 e5                	mov    %esp,%ebp
  800239:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80023f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800246:	00 00 00 
	b.cnt = 0;
  800249:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800250:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800253:	ff 75 0c             	pushl  0xc(%ebp)
  800256:	ff 75 08             	pushl  0x8(%ebp)
  800259:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80025f:	50                   	push   %eax
  800260:	68 ea 01 80 00       	push   $0x8001ea
  800265:	e8 20 01 00 00       	call   80038a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80026a:	83 c4 08             	add    $0x8,%esp
  80026d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800273:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800279:	50                   	push   %eax
  80027a:	e8 84 09 00 00       	call   800c03 <sys_cputs>

	return b.cnt;
}
  80027f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800285:	c9                   	leave  
  800286:	c3                   	ret    

00800287 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800287:	f3 0f 1e fb          	endbr32 
  80028b:	55                   	push   %ebp
  80028c:	89 e5                	mov    %esp,%ebp
  80028e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800291:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800294:	50                   	push   %eax
  800295:	ff 75 08             	pushl  0x8(%ebp)
  800298:	e8 95 ff ff ff       	call   800232 <vcprintf>
	va_end(ap);

	return cnt;
}
  80029d:	c9                   	leave  
  80029e:	c3                   	ret    

0080029f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80029f:	55                   	push   %ebp
  8002a0:	89 e5                	mov    %esp,%ebp
  8002a2:	57                   	push   %edi
  8002a3:	56                   	push   %esi
  8002a4:	53                   	push   %ebx
  8002a5:	83 ec 1c             	sub    $0x1c,%esp
  8002a8:	89 c7                	mov    %eax,%edi
  8002aa:	89 d6                	mov    %edx,%esi
  8002ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8002af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b2:	89 d1                	mov    %edx,%ecx
  8002b4:	89 c2                	mov    %eax,%edx
  8002b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002b9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8002bf:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002c5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8002cc:	39 c2                	cmp    %eax,%edx
  8002ce:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8002d1:	72 3e                	jb     800311 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002d3:	83 ec 0c             	sub    $0xc,%esp
  8002d6:	ff 75 18             	pushl  0x18(%ebp)
  8002d9:	83 eb 01             	sub    $0x1,%ebx
  8002dc:	53                   	push   %ebx
  8002dd:	50                   	push   %eax
  8002de:	83 ec 08             	sub    $0x8,%esp
  8002e1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e4:	ff 75 e0             	pushl  -0x20(%ebp)
  8002e7:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ea:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ed:	e8 0e 26 00 00       	call   802900 <__udivdi3>
  8002f2:	83 c4 18             	add    $0x18,%esp
  8002f5:	52                   	push   %edx
  8002f6:	50                   	push   %eax
  8002f7:	89 f2                	mov    %esi,%edx
  8002f9:	89 f8                	mov    %edi,%eax
  8002fb:	e8 9f ff ff ff       	call   80029f <printnum>
  800300:	83 c4 20             	add    $0x20,%esp
  800303:	eb 13                	jmp    800318 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800305:	83 ec 08             	sub    $0x8,%esp
  800308:	56                   	push   %esi
  800309:	ff 75 18             	pushl  0x18(%ebp)
  80030c:	ff d7                	call   *%edi
  80030e:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800311:	83 eb 01             	sub    $0x1,%ebx
  800314:	85 db                	test   %ebx,%ebx
  800316:	7f ed                	jg     800305 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800318:	83 ec 08             	sub    $0x8,%esp
  80031b:	56                   	push   %esi
  80031c:	83 ec 04             	sub    $0x4,%esp
  80031f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800322:	ff 75 e0             	pushl  -0x20(%ebp)
  800325:	ff 75 dc             	pushl  -0x24(%ebp)
  800328:	ff 75 d8             	pushl  -0x28(%ebp)
  80032b:	e8 e0 26 00 00       	call   802a10 <__umoddi3>
  800330:	83 c4 14             	add    $0x14,%esp
  800333:	0f be 80 5b 2c 80 00 	movsbl 0x802c5b(%eax),%eax
  80033a:	50                   	push   %eax
  80033b:	ff d7                	call   *%edi
}
  80033d:	83 c4 10             	add    $0x10,%esp
  800340:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800343:	5b                   	pop    %ebx
  800344:	5e                   	pop    %esi
  800345:	5f                   	pop    %edi
  800346:	5d                   	pop    %ebp
  800347:	c3                   	ret    

00800348 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800348:	f3 0f 1e fb          	endbr32 
  80034c:	55                   	push   %ebp
  80034d:	89 e5                	mov    %esp,%ebp
  80034f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800352:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800356:	8b 10                	mov    (%eax),%edx
  800358:	3b 50 04             	cmp    0x4(%eax),%edx
  80035b:	73 0a                	jae    800367 <sprintputch+0x1f>
		*b->buf++ = ch;
  80035d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800360:	89 08                	mov    %ecx,(%eax)
  800362:	8b 45 08             	mov    0x8(%ebp),%eax
  800365:	88 02                	mov    %al,(%edx)
}
  800367:	5d                   	pop    %ebp
  800368:	c3                   	ret    

00800369 <printfmt>:
{
  800369:	f3 0f 1e fb          	endbr32 
  80036d:	55                   	push   %ebp
  80036e:	89 e5                	mov    %esp,%ebp
  800370:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800373:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800376:	50                   	push   %eax
  800377:	ff 75 10             	pushl  0x10(%ebp)
  80037a:	ff 75 0c             	pushl  0xc(%ebp)
  80037d:	ff 75 08             	pushl  0x8(%ebp)
  800380:	e8 05 00 00 00       	call   80038a <vprintfmt>
}
  800385:	83 c4 10             	add    $0x10,%esp
  800388:	c9                   	leave  
  800389:	c3                   	ret    

0080038a <vprintfmt>:
{
  80038a:	f3 0f 1e fb          	endbr32 
  80038e:	55                   	push   %ebp
  80038f:	89 e5                	mov    %esp,%ebp
  800391:	57                   	push   %edi
  800392:	56                   	push   %esi
  800393:	53                   	push   %ebx
  800394:	83 ec 3c             	sub    $0x3c,%esp
  800397:	8b 75 08             	mov    0x8(%ebp),%esi
  80039a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80039d:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003a0:	e9 8e 03 00 00       	jmp    800733 <vprintfmt+0x3a9>
		padc = ' ';
  8003a5:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8003a9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8003b0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003b7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003be:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003c3:	8d 47 01             	lea    0x1(%edi),%eax
  8003c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003c9:	0f b6 17             	movzbl (%edi),%edx
  8003cc:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003cf:	3c 55                	cmp    $0x55,%al
  8003d1:	0f 87 df 03 00 00    	ja     8007b6 <vprintfmt+0x42c>
  8003d7:	0f b6 c0             	movzbl %al,%eax
  8003da:	3e ff 24 85 a0 2d 80 	notrack jmp *0x802da0(,%eax,4)
  8003e1:	00 
  8003e2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003e5:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8003e9:	eb d8                	jmp    8003c3 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003ee:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8003f2:	eb cf                	jmp    8003c3 <vprintfmt+0x39>
  8003f4:	0f b6 d2             	movzbl %dl,%edx
  8003f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ff:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800402:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800405:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800409:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80040c:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80040f:	83 f9 09             	cmp    $0x9,%ecx
  800412:	77 55                	ja     800469 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800414:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800417:	eb e9                	jmp    800402 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800419:	8b 45 14             	mov    0x14(%ebp),%eax
  80041c:	8b 00                	mov    (%eax),%eax
  80041e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800421:	8b 45 14             	mov    0x14(%ebp),%eax
  800424:	8d 40 04             	lea    0x4(%eax),%eax
  800427:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80042a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80042d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800431:	79 90                	jns    8003c3 <vprintfmt+0x39>
				width = precision, precision = -1;
  800433:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800436:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800439:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800440:	eb 81                	jmp    8003c3 <vprintfmt+0x39>
  800442:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800445:	85 c0                	test   %eax,%eax
  800447:	ba 00 00 00 00       	mov    $0x0,%edx
  80044c:	0f 49 d0             	cmovns %eax,%edx
  80044f:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800452:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800455:	e9 69 ff ff ff       	jmp    8003c3 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80045a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80045d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800464:	e9 5a ff ff ff       	jmp    8003c3 <vprintfmt+0x39>
  800469:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80046c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80046f:	eb bc                	jmp    80042d <vprintfmt+0xa3>
			lflag++;
  800471:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800474:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800477:	e9 47 ff ff ff       	jmp    8003c3 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80047c:	8b 45 14             	mov    0x14(%ebp),%eax
  80047f:	8d 78 04             	lea    0x4(%eax),%edi
  800482:	83 ec 08             	sub    $0x8,%esp
  800485:	53                   	push   %ebx
  800486:	ff 30                	pushl  (%eax)
  800488:	ff d6                	call   *%esi
			break;
  80048a:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80048d:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800490:	e9 9b 02 00 00       	jmp    800730 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800495:	8b 45 14             	mov    0x14(%ebp),%eax
  800498:	8d 78 04             	lea    0x4(%eax),%edi
  80049b:	8b 00                	mov    (%eax),%eax
  80049d:	99                   	cltd   
  80049e:	31 d0                	xor    %edx,%eax
  8004a0:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004a2:	83 f8 0f             	cmp    $0xf,%eax
  8004a5:	7f 23                	jg     8004ca <vprintfmt+0x140>
  8004a7:	8b 14 85 00 2f 80 00 	mov    0x802f00(,%eax,4),%edx
  8004ae:	85 d2                	test   %edx,%edx
  8004b0:	74 18                	je     8004ca <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8004b2:	52                   	push   %edx
  8004b3:	68 35 30 80 00       	push   $0x803035
  8004b8:	53                   	push   %ebx
  8004b9:	56                   	push   %esi
  8004ba:	e8 aa fe ff ff       	call   800369 <printfmt>
  8004bf:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004c2:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004c5:	e9 66 02 00 00       	jmp    800730 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8004ca:	50                   	push   %eax
  8004cb:	68 73 2c 80 00       	push   $0x802c73
  8004d0:	53                   	push   %ebx
  8004d1:	56                   	push   %esi
  8004d2:	e8 92 fe ff ff       	call   800369 <printfmt>
  8004d7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004da:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004dd:	e9 4e 02 00 00       	jmp    800730 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8004e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e5:	83 c0 04             	add    $0x4,%eax
  8004e8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8004eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ee:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8004f0:	85 d2                	test   %edx,%edx
  8004f2:	b8 6c 2c 80 00       	mov    $0x802c6c,%eax
  8004f7:	0f 45 c2             	cmovne %edx,%eax
  8004fa:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004fd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800501:	7e 06                	jle    800509 <vprintfmt+0x17f>
  800503:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800507:	75 0d                	jne    800516 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  800509:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80050c:	89 c7                	mov    %eax,%edi
  80050e:	03 45 e0             	add    -0x20(%ebp),%eax
  800511:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800514:	eb 55                	jmp    80056b <vprintfmt+0x1e1>
  800516:	83 ec 08             	sub    $0x8,%esp
  800519:	ff 75 d8             	pushl  -0x28(%ebp)
  80051c:	ff 75 cc             	pushl  -0x34(%ebp)
  80051f:	e8 46 03 00 00       	call   80086a <strnlen>
  800524:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800527:	29 c2                	sub    %eax,%edx
  800529:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80052c:	83 c4 10             	add    $0x10,%esp
  80052f:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800531:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800535:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800538:	85 ff                	test   %edi,%edi
  80053a:	7e 11                	jle    80054d <vprintfmt+0x1c3>
					putch(padc, putdat);
  80053c:	83 ec 08             	sub    $0x8,%esp
  80053f:	53                   	push   %ebx
  800540:	ff 75 e0             	pushl  -0x20(%ebp)
  800543:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800545:	83 ef 01             	sub    $0x1,%edi
  800548:	83 c4 10             	add    $0x10,%esp
  80054b:	eb eb                	jmp    800538 <vprintfmt+0x1ae>
  80054d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800550:	85 d2                	test   %edx,%edx
  800552:	b8 00 00 00 00       	mov    $0x0,%eax
  800557:	0f 49 c2             	cmovns %edx,%eax
  80055a:	29 c2                	sub    %eax,%edx
  80055c:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80055f:	eb a8                	jmp    800509 <vprintfmt+0x17f>
					putch(ch, putdat);
  800561:	83 ec 08             	sub    $0x8,%esp
  800564:	53                   	push   %ebx
  800565:	52                   	push   %edx
  800566:	ff d6                	call   *%esi
  800568:	83 c4 10             	add    $0x10,%esp
  80056b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80056e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800570:	83 c7 01             	add    $0x1,%edi
  800573:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800577:	0f be d0             	movsbl %al,%edx
  80057a:	85 d2                	test   %edx,%edx
  80057c:	74 4b                	je     8005c9 <vprintfmt+0x23f>
  80057e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800582:	78 06                	js     80058a <vprintfmt+0x200>
  800584:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800588:	78 1e                	js     8005a8 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  80058a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80058e:	74 d1                	je     800561 <vprintfmt+0x1d7>
  800590:	0f be c0             	movsbl %al,%eax
  800593:	83 e8 20             	sub    $0x20,%eax
  800596:	83 f8 5e             	cmp    $0x5e,%eax
  800599:	76 c6                	jbe    800561 <vprintfmt+0x1d7>
					putch('?', putdat);
  80059b:	83 ec 08             	sub    $0x8,%esp
  80059e:	53                   	push   %ebx
  80059f:	6a 3f                	push   $0x3f
  8005a1:	ff d6                	call   *%esi
  8005a3:	83 c4 10             	add    $0x10,%esp
  8005a6:	eb c3                	jmp    80056b <vprintfmt+0x1e1>
  8005a8:	89 cf                	mov    %ecx,%edi
  8005aa:	eb 0e                	jmp    8005ba <vprintfmt+0x230>
				putch(' ', putdat);
  8005ac:	83 ec 08             	sub    $0x8,%esp
  8005af:	53                   	push   %ebx
  8005b0:	6a 20                	push   $0x20
  8005b2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005b4:	83 ef 01             	sub    $0x1,%edi
  8005b7:	83 c4 10             	add    $0x10,%esp
  8005ba:	85 ff                	test   %edi,%edi
  8005bc:	7f ee                	jg     8005ac <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8005be:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005c1:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c4:	e9 67 01 00 00       	jmp    800730 <vprintfmt+0x3a6>
  8005c9:	89 cf                	mov    %ecx,%edi
  8005cb:	eb ed                	jmp    8005ba <vprintfmt+0x230>
	if (lflag >= 2)
  8005cd:	83 f9 01             	cmp    $0x1,%ecx
  8005d0:	7f 1b                	jg     8005ed <vprintfmt+0x263>
	else if (lflag)
  8005d2:	85 c9                	test   %ecx,%ecx
  8005d4:	74 63                	je     800639 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8005d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d9:	8b 00                	mov    (%eax),%eax
  8005db:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005de:	99                   	cltd   
  8005df:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e5:	8d 40 04             	lea    0x4(%eax),%eax
  8005e8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005eb:	eb 17                	jmp    800604 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  8005ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f0:	8b 50 04             	mov    0x4(%eax),%edx
  8005f3:	8b 00                	mov    (%eax),%eax
  8005f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fe:	8d 40 08             	lea    0x8(%eax),%eax
  800601:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800604:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800607:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80060a:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80060f:	85 c9                	test   %ecx,%ecx
  800611:	0f 89 ff 00 00 00    	jns    800716 <vprintfmt+0x38c>
				putch('-', putdat);
  800617:	83 ec 08             	sub    $0x8,%esp
  80061a:	53                   	push   %ebx
  80061b:	6a 2d                	push   $0x2d
  80061d:	ff d6                	call   *%esi
				num = -(long long) num;
  80061f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800622:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800625:	f7 da                	neg    %edx
  800627:	83 d1 00             	adc    $0x0,%ecx
  80062a:	f7 d9                	neg    %ecx
  80062c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80062f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800634:	e9 dd 00 00 00       	jmp    800716 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	8b 00                	mov    (%eax),%eax
  80063e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800641:	99                   	cltd   
  800642:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800645:	8b 45 14             	mov    0x14(%ebp),%eax
  800648:	8d 40 04             	lea    0x4(%eax),%eax
  80064b:	89 45 14             	mov    %eax,0x14(%ebp)
  80064e:	eb b4                	jmp    800604 <vprintfmt+0x27a>
	if (lflag >= 2)
  800650:	83 f9 01             	cmp    $0x1,%ecx
  800653:	7f 1e                	jg     800673 <vprintfmt+0x2e9>
	else if (lflag)
  800655:	85 c9                	test   %ecx,%ecx
  800657:	74 32                	je     80068b <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800659:	8b 45 14             	mov    0x14(%ebp),%eax
  80065c:	8b 10                	mov    (%eax),%edx
  80065e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800663:	8d 40 04             	lea    0x4(%eax),%eax
  800666:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800669:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  80066e:	e9 a3 00 00 00       	jmp    800716 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800673:	8b 45 14             	mov    0x14(%ebp),%eax
  800676:	8b 10                	mov    (%eax),%edx
  800678:	8b 48 04             	mov    0x4(%eax),%ecx
  80067b:	8d 40 08             	lea    0x8(%eax),%eax
  80067e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800681:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800686:	e9 8b 00 00 00       	jmp    800716 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80068b:	8b 45 14             	mov    0x14(%ebp),%eax
  80068e:	8b 10                	mov    (%eax),%edx
  800690:	b9 00 00 00 00       	mov    $0x0,%ecx
  800695:	8d 40 04             	lea    0x4(%eax),%eax
  800698:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80069b:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8006a0:	eb 74                	jmp    800716 <vprintfmt+0x38c>
	if (lflag >= 2)
  8006a2:	83 f9 01             	cmp    $0x1,%ecx
  8006a5:	7f 1b                	jg     8006c2 <vprintfmt+0x338>
	else if (lflag)
  8006a7:	85 c9                	test   %ecx,%ecx
  8006a9:	74 2c                	je     8006d7 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8006ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ae:	8b 10                	mov    (%eax),%edx
  8006b0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b5:	8d 40 04             	lea    0x4(%eax),%eax
  8006b8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006bb:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8006c0:	eb 54                	jmp    800716 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8006c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c5:	8b 10                	mov    (%eax),%edx
  8006c7:	8b 48 04             	mov    0x4(%eax),%ecx
  8006ca:	8d 40 08             	lea    0x8(%eax),%eax
  8006cd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006d0:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  8006d5:	eb 3f                	jmp    800716 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006da:	8b 10                	mov    (%eax),%edx
  8006dc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006e1:	8d 40 04             	lea    0x4(%eax),%eax
  8006e4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006e7:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  8006ec:	eb 28                	jmp    800716 <vprintfmt+0x38c>
			putch('0', putdat);
  8006ee:	83 ec 08             	sub    $0x8,%esp
  8006f1:	53                   	push   %ebx
  8006f2:	6a 30                	push   $0x30
  8006f4:	ff d6                	call   *%esi
			putch('x', putdat);
  8006f6:	83 c4 08             	add    $0x8,%esp
  8006f9:	53                   	push   %ebx
  8006fa:	6a 78                	push   $0x78
  8006fc:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800701:	8b 10                	mov    (%eax),%edx
  800703:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800708:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80070b:	8d 40 04             	lea    0x4(%eax),%eax
  80070e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800711:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800716:	83 ec 0c             	sub    $0xc,%esp
  800719:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80071d:	57                   	push   %edi
  80071e:	ff 75 e0             	pushl  -0x20(%ebp)
  800721:	50                   	push   %eax
  800722:	51                   	push   %ecx
  800723:	52                   	push   %edx
  800724:	89 da                	mov    %ebx,%edx
  800726:	89 f0                	mov    %esi,%eax
  800728:	e8 72 fb ff ff       	call   80029f <printnum>
			break;
  80072d:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800730:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800733:	83 c7 01             	add    $0x1,%edi
  800736:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80073a:	83 f8 25             	cmp    $0x25,%eax
  80073d:	0f 84 62 fc ff ff    	je     8003a5 <vprintfmt+0x1b>
			if (ch == '\0')
  800743:	85 c0                	test   %eax,%eax
  800745:	0f 84 8b 00 00 00    	je     8007d6 <vprintfmt+0x44c>
			putch(ch, putdat);
  80074b:	83 ec 08             	sub    $0x8,%esp
  80074e:	53                   	push   %ebx
  80074f:	50                   	push   %eax
  800750:	ff d6                	call   *%esi
  800752:	83 c4 10             	add    $0x10,%esp
  800755:	eb dc                	jmp    800733 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800757:	83 f9 01             	cmp    $0x1,%ecx
  80075a:	7f 1b                	jg     800777 <vprintfmt+0x3ed>
	else if (lflag)
  80075c:	85 c9                	test   %ecx,%ecx
  80075e:	74 2c                	je     80078c <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800760:	8b 45 14             	mov    0x14(%ebp),%eax
  800763:	8b 10                	mov    (%eax),%edx
  800765:	b9 00 00 00 00       	mov    $0x0,%ecx
  80076a:	8d 40 04             	lea    0x4(%eax),%eax
  80076d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800770:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800775:	eb 9f                	jmp    800716 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800777:	8b 45 14             	mov    0x14(%ebp),%eax
  80077a:	8b 10                	mov    (%eax),%edx
  80077c:	8b 48 04             	mov    0x4(%eax),%ecx
  80077f:	8d 40 08             	lea    0x8(%eax),%eax
  800782:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800785:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  80078a:	eb 8a                	jmp    800716 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80078c:	8b 45 14             	mov    0x14(%ebp),%eax
  80078f:	8b 10                	mov    (%eax),%edx
  800791:	b9 00 00 00 00       	mov    $0x0,%ecx
  800796:	8d 40 04             	lea    0x4(%eax),%eax
  800799:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80079c:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8007a1:	e9 70 ff ff ff       	jmp    800716 <vprintfmt+0x38c>
			putch(ch, putdat);
  8007a6:	83 ec 08             	sub    $0x8,%esp
  8007a9:	53                   	push   %ebx
  8007aa:	6a 25                	push   $0x25
  8007ac:	ff d6                	call   *%esi
			break;
  8007ae:	83 c4 10             	add    $0x10,%esp
  8007b1:	e9 7a ff ff ff       	jmp    800730 <vprintfmt+0x3a6>
			putch('%', putdat);
  8007b6:	83 ec 08             	sub    $0x8,%esp
  8007b9:	53                   	push   %ebx
  8007ba:	6a 25                	push   $0x25
  8007bc:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007be:	83 c4 10             	add    $0x10,%esp
  8007c1:	89 f8                	mov    %edi,%eax
  8007c3:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007c7:	74 05                	je     8007ce <vprintfmt+0x444>
  8007c9:	83 e8 01             	sub    $0x1,%eax
  8007cc:	eb f5                	jmp    8007c3 <vprintfmt+0x439>
  8007ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007d1:	e9 5a ff ff ff       	jmp    800730 <vprintfmt+0x3a6>
}
  8007d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007d9:	5b                   	pop    %ebx
  8007da:	5e                   	pop    %esi
  8007db:	5f                   	pop    %edi
  8007dc:	5d                   	pop    %ebp
  8007dd:	c3                   	ret    

008007de <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007de:	f3 0f 1e fb          	endbr32 
  8007e2:	55                   	push   %ebp
  8007e3:	89 e5                	mov    %esp,%ebp
  8007e5:	83 ec 18             	sub    $0x18,%esp
  8007e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007eb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007f1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007f5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007ff:	85 c0                	test   %eax,%eax
  800801:	74 26                	je     800829 <vsnprintf+0x4b>
  800803:	85 d2                	test   %edx,%edx
  800805:	7e 22                	jle    800829 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800807:	ff 75 14             	pushl  0x14(%ebp)
  80080a:	ff 75 10             	pushl  0x10(%ebp)
  80080d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800810:	50                   	push   %eax
  800811:	68 48 03 80 00       	push   $0x800348
  800816:	e8 6f fb ff ff       	call   80038a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80081b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80081e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800824:	83 c4 10             	add    $0x10,%esp
}
  800827:	c9                   	leave  
  800828:	c3                   	ret    
		return -E_INVAL;
  800829:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80082e:	eb f7                	jmp    800827 <vsnprintf+0x49>

00800830 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800830:	f3 0f 1e fb          	endbr32 
  800834:	55                   	push   %ebp
  800835:	89 e5                	mov    %esp,%ebp
  800837:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80083a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80083d:	50                   	push   %eax
  80083e:	ff 75 10             	pushl  0x10(%ebp)
  800841:	ff 75 0c             	pushl  0xc(%ebp)
  800844:	ff 75 08             	pushl  0x8(%ebp)
  800847:	e8 92 ff ff ff       	call   8007de <vsnprintf>
	va_end(ap);

	return rc;
}
  80084c:	c9                   	leave  
  80084d:	c3                   	ret    

0080084e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80084e:	f3 0f 1e fb          	endbr32 
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
  800855:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800858:	b8 00 00 00 00       	mov    $0x0,%eax
  80085d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800861:	74 05                	je     800868 <strlen+0x1a>
		n++;
  800863:	83 c0 01             	add    $0x1,%eax
  800866:	eb f5                	jmp    80085d <strlen+0xf>
	return n;
}
  800868:	5d                   	pop    %ebp
  800869:	c3                   	ret    

0080086a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80086a:	f3 0f 1e fb          	endbr32 
  80086e:	55                   	push   %ebp
  80086f:	89 e5                	mov    %esp,%ebp
  800871:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800874:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800877:	b8 00 00 00 00       	mov    $0x0,%eax
  80087c:	39 d0                	cmp    %edx,%eax
  80087e:	74 0d                	je     80088d <strnlen+0x23>
  800880:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800884:	74 05                	je     80088b <strnlen+0x21>
		n++;
  800886:	83 c0 01             	add    $0x1,%eax
  800889:	eb f1                	jmp    80087c <strnlen+0x12>
  80088b:	89 c2                	mov    %eax,%edx
	return n;
}
  80088d:	89 d0                	mov    %edx,%eax
  80088f:	5d                   	pop    %ebp
  800890:	c3                   	ret    

00800891 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800891:	f3 0f 1e fb          	endbr32 
  800895:	55                   	push   %ebp
  800896:	89 e5                	mov    %esp,%ebp
  800898:	53                   	push   %ebx
  800899:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80089c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80089f:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a4:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8008a8:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8008ab:	83 c0 01             	add    $0x1,%eax
  8008ae:	84 d2                	test   %dl,%dl
  8008b0:	75 f2                	jne    8008a4 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8008b2:	89 c8                	mov    %ecx,%eax
  8008b4:	5b                   	pop    %ebx
  8008b5:	5d                   	pop    %ebp
  8008b6:	c3                   	ret    

008008b7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008b7:	f3 0f 1e fb          	endbr32 
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	53                   	push   %ebx
  8008bf:	83 ec 10             	sub    $0x10,%esp
  8008c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008c5:	53                   	push   %ebx
  8008c6:	e8 83 ff ff ff       	call   80084e <strlen>
  8008cb:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008ce:	ff 75 0c             	pushl  0xc(%ebp)
  8008d1:	01 d8                	add    %ebx,%eax
  8008d3:	50                   	push   %eax
  8008d4:	e8 b8 ff ff ff       	call   800891 <strcpy>
	return dst;
}
  8008d9:	89 d8                	mov    %ebx,%eax
  8008db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008de:	c9                   	leave  
  8008df:	c3                   	ret    

008008e0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008e0:	f3 0f 1e fb          	endbr32 
  8008e4:	55                   	push   %ebp
  8008e5:	89 e5                	mov    %esp,%ebp
  8008e7:	56                   	push   %esi
  8008e8:	53                   	push   %ebx
  8008e9:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ef:	89 f3                	mov    %esi,%ebx
  8008f1:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008f4:	89 f0                	mov    %esi,%eax
  8008f6:	39 d8                	cmp    %ebx,%eax
  8008f8:	74 11                	je     80090b <strncpy+0x2b>
		*dst++ = *src;
  8008fa:	83 c0 01             	add    $0x1,%eax
  8008fd:	0f b6 0a             	movzbl (%edx),%ecx
  800900:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800903:	80 f9 01             	cmp    $0x1,%cl
  800906:	83 da ff             	sbb    $0xffffffff,%edx
  800909:	eb eb                	jmp    8008f6 <strncpy+0x16>
	}
	return ret;
}
  80090b:	89 f0                	mov    %esi,%eax
  80090d:	5b                   	pop    %ebx
  80090e:	5e                   	pop    %esi
  80090f:	5d                   	pop    %ebp
  800910:	c3                   	ret    

00800911 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800911:	f3 0f 1e fb          	endbr32 
  800915:	55                   	push   %ebp
  800916:	89 e5                	mov    %esp,%ebp
  800918:	56                   	push   %esi
  800919:	53                   	push   %ebx
  80091a:	8b 75 08             	mov    0x8(%ebp),%esi
  80091d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800920:	8b 55 10             	mov    0x10(%ebp),%edx
  800923:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800925:	85 d2                	test   %edx,%edx
  800927:	74 21                	je     80094a <strlcpy+0x39>
  800929:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80092d:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80092f:	39 c2                	cmp    %eax,%edx
  800931:	74 14                	je     800947 <strlcpy+0x36>
  800933:	0f b6 19             	movzbl (%ecx),%ebx
  800936:	84 db                	test   %bl,%bl
  800938:	74 0b                	je     800945 <strlcpy+0x34>
			*dst++ = *src++;
  80093a:	83 c1 01             	add    $0x1,%ecx
  80093d:	83 c2 01             	add    $0x1,%edx
  800940:	88 5a ff             	mov    %bl,-0x1(%edx)
  800943:	eb ea                	jmp    80092f <strlcpy+0x1e>
  800945:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800947:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80094a:	29 f0                	sub    %esi,%eax
}
  80094c:	5b                   	pop    %ebx
  80094d:	5e                   	pop    %esi
  80094e:	5d                   	pop    %ebp
  80094f:	c3                   	ret    

00800950 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800950:	f3 0f 1e fb          	endbr32 
  800954:	55                   	push   %ebp
  800955:	89 e5                	mov    %esp,%ebp
  800957:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80095a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80095d:	0f b6 01             	movzbl (%ecx),%eax
  800960:	84 c0                	test   %al,%al
  800962:	74 0c                	je     800970 <strcmp+0x20>
  800964:	3a 02                	cmp    (%edx),%al
  800966:	75 08                	jne    800970 <strcmp+0x20>
		p++, q++;
  800968:	83 c1 01             	add    $0x1,%ecx
  80096b:	83 c2 01             	add    $0x1,%edx
  80096e:	eb ed                	jmp    80095d <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800970:	0f b6 c0             	movzbl %al,%eax
  800973:	0f b6 12             	movzbl (%edx),%edx
  800976:	29 d0                	sub    %edx,%eax
}
  800978:	5d                   	pop    %ebp
  800979:	c3                   	ret    

0080097a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80097a:	f3 0f 1e fb          	endbr32 
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	53                   	push   %ebx
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	8b 55 0c             	mov    0xc(%ebp),%edx
  800988:	89 c3                	mov    %eax,%ebx
  80098a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80098d:	eb 06                	jmp    800995 <strncmp+0x1b>
		n--, p++, q++;
  80098f:	83 c0 01             	add    $0x1,%eax
  800992:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800995:	39 d8                	cmp    %ebx,%eax
  800997:	74 16                	je     8009af <strncmp+0x35>
  800999:	0f b6 08             	movzbl (%eax),%ecx
  80099c:	84 c9                	test   %cl,%cl
  80099e:	74 04                	je     8009a4 <strncmp+0x2a>
  8009a0:	3a 0a                	cmp    (%edx),%cl
  8009a2:	74 eb                	je     80098f <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009a4:	0f b6 00             	movzbl (%eax),%eax
  8009a7:	0f b6 12             	movzbl (%edx),%edx
  8009aa:	29 d0                	sub    %edx,%eax
}
  8009ac:	5b                   	pop    %ebx
  8009ad:	5d                   	pop    %ebp
  8009ae:	c3                   	ret    
		return 0;
  8009af:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b4:	eb f6                	jmp    8009ac <strncmp+0x32>

008009b6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009b6:	f3 0f 1e fb          	endbr32 
  8009ba:	55                   	push   %ebp
  8009bb:	89 e5                	mov    %esp,%ebp
  8009bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009c4:	0f b6 10             	movzbl (%eax),%edx
  8009c7:	84 d2                	test   %dl,%dl
  8009c9:	74 09                	je     8009d4 <strchr+0x1e>
		if (*s == c)
  8009cb:	38 ca                	cmp    %cl,%dl
  8009cd:	74 0a                	je     8009d9 <strchr+0x23>
	for (; *s; s++)
  8009cf:	83 c0 01             	add    $0x1,%eax
  8009d2:	eb f0                	jmp    8009c4 <strchr+0xe>
			return (char *) s;
	return 0;
  8009d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009d9:	5d                   	pop    %ebp
  8009da:	c3                   	ret    

008009db <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009db:	f3 0f 1e fb          	endbr32 
  8009df:	55                   	push   %ebp
  8009e0:	89 e5                	mov    %esp,%ebp
  8009e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009e9:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009ec:	38 ca                	cmp    %cl,%dl
  8009ee:	74 09                	je     8009f9 <strfind+0x1e>
  8009f0:	84 d2                	test   %dl,%dl
  8009f2:	74 05                	je     8009f9 <strfind+0x1e>
	for (; *s; s++)
  8009f4:	83 c0 01             	add    $0x1,%eax
  8009f7:	eb f0                	jmp    8009e9 <strfind+0xe>
			break;
	return (char *) s;
}
  8009f9:	5d                   	pop    %ebp
  8009fa:	c3                   	ret    

008009fb <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009fb:	f3 0f 1e fb          	endbr32 
  8009ff:	55                   	push   %ebp
  800a00:	89 e5                	mov    %esp,%ebp
  800a02:	57                   	push   %edi
  800a03:	56                   	push   %esi
  800a04:	53                   	push   %ebx
  800a05:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a08:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a0b:	85 c9                	test   %ecx,%ecx
  800a0d:	74 31                	je     800a40 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a0f:	89 f8                	mov    %edi,%eax
  800a11:	09 c8                	or     %ecx,%eax
  800a13:	a8 03                	test   $0x3,%al
  800a15:	75 23                	jne    800a3a <memset+0x3f>
		c &= 0xFF;
  800a17:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a1b:	89 d3                	mov    %edx,%ebx
  800a1d:	c1 e3 08             	shl    $0x8,%ebx
  800a20:	89 d0                	mov    %edx,%eax
  800a22:	c1 e0 18             	shl    $0x18,%eax
  800a25:	89 d6                	mov    %edx,%esi
  800a27:	c1 e6 10             	shl    $0x10,%esi
  800a2a:	09 f0                	or     %esi,%eax
  800a2c:	09 c2                	or     %eax,%edx
  800a2e:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a30:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a33:	89 d0                	mov    %edx,%eax
  800a35:	fc                   	cld    
  800a36:	f3 ab                	rep stos %eax,%es:(%edi)
  800a38:	eb 06                	jmp    800a40 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3d:	fc                   	cld    
  800a3e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a40:	89 f8                	mov    %edi,%eax
  800a42:	5b                   	pop    %ebx
  800a43:	5e                   	pop    %esi
  800a44:	5f                   	pop    %edi
  800a45:	5d                   	pop    %ebp
  800a46:	c3                   	ret    

00800a47 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a47:	f3 0f 1e fb          	endbr32 
  800a4b:	55                   	push   %ebp
  800a4c:	89 e5                	mov    %esp,%ebp
  800a4e:	57                   	push   %edi
  800a4f:	56                   	push   %esi
  800a50:	8b 45 08             	mov    0x8(%ebp),%eax
  800a53:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a56:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a59:	39 c6                	cmp    %eax,%esi
  800a5b:	73 32                	jae    800a8f <memmove+0x48>
  800a5d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a60:	39 c2                	cmp    %eax,%edx
  800a62:	76 2b                	jbe    800a8f <memmove+0x48>
		s += n;
		d += n;
  800a64:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a67:	89 fe                	mov    %edi,%esi
  800a69:	09 ce                	or     %ecx,%esi
  800a6b:	09 d6                	or     %edx,%esi
  800a6d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a73:	75 0e                	jne    800a83 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a75:	83 ef 04             	sub    $0x4,%edi
  800a78:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a7b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a7e:	fd                   	std    
  800a7f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a81:	eb 09                	jmp    800a8c <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a83:	83 ef 01             	sub    $0x1,%edi
  800a86:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a89:	fd                   	std    
  800a8a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a8c:	fc                   	cld    
  800a8d:	eb 1a                	jmp    800aa9 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a8f:	89 c2                	mov    %eax,%edx
  800a91:	09 ca                	or     %ecx,%edx
  800a93:	09 f2                	or     %esi,%edx
  800a95:	f6 c2 03             	test   $0x3,%dl
  800a98:	75 0a                	jne    800aa4 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a9a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a9d:	89 c7                	mov    %eax,%edi
  800a9f:	fc                   	cld    
  800aa0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aa2:	eb 05                	jmp    800aa9 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800aa4:	89 c7                	mov    %eax,%edi
  800aa6:	fc                   	cld    
  800aa7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800aa9:	5e                   	pop    %esi
  800aaa:	5f                   	pop    %edi
  800aab:	5d                   	pop    %ebp
  800aac:	c3                   	ret    

00800aad <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aad:	f3 0f 1e fb          	endbr32 
  800ab1:	55                   	push   %ebp
  800ab2:	89 e5                	mov    %esp,%ebp
  800ab4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ab7:	ff 75 10             	pushl  0x10(%ebp)
  800aba:	ff 75 0c             	pushl  0xc(%ebp)
  800abd:	ff 75 08             	pushl  0x8(%ebp)
  800ac0:	e8 82 ff ff ff       	call   800a47 <memmove>
}
  800ac5:	c9                   	leave  
  800ac6:	c3                   	ret    

00800ac7 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ac7:	f3 0f 1e fb          	endbr32 
  800acb:	55                   	push   %ebp
  800acc:	89 e5                	mov    %esp,%ebp
  800ace:	56                   	push   %esi
  800acf:	53                   	push   %ebx
  800ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ad6:	89 c6                	mov    %eax,%esi
  800ad8:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800adb:	39 f0                	cmp    %esi,%eax
  800add:	74 1c                	je     800afb <memcmp+0x34>
		if (*s1 != *s2)
  800adf:	0f b6 08             	movzbl (%eax),%ecx
  800ae2:	0f b6 1a             	movzbl (%edx),%ebx
  800ae5:	38 d9                	cmp    %bl,%cl
  800ae7:	75 08                	jne    800af1 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ae9:	83 c0 01             	add    $0x1,%eax
  800aec:	83 c2 01             	add    $0x1,%edx
  800aef:	eb ea                	jmp    800adb <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800af1:	0f b6 c1             	movzbl %cl,%eax
  800af4:	0f b6 db             	movzbl %bl,%ebx
  800af7:	29 d8                	sub    %ebx,%eax
  800af9:	eb 05                	jmp    800b00 <memcmp+0x39>
	}

	return 0;
  800afb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b00:	5b                   	pop    %ebx
  800b01:	5e                   	pop    %esi
  800b02:	5d                   	pop    %ebp
  800b03:	c3                   	ret    

00800b04 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b04:	f3 0f 1e fb          	endbr32 
  800b08:	55                   	push   %ebp
  800b09:	89 e5                	mov    %esp,%ebp
  800b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b11:	89 c2                	mov    %eax,%edx
  800b13:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b16:	39 d0                	cmp    %edx,%eax
  800b18:	73 09                	jae    800b23 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b1a:	38 08                	cmp    %cl,(%eax)
  800b1c:	74 05                	je     800b23 <memfind+0x1f>
	for (; s < ends; s++)
  800b1e:	83 c0 01             	add    $0x1,%eax
  800b21:	eb f3                	jmp    800b16 <memfind+0x12>
			break;
	return (void *) s;
}
  800b23:	5d                   	pop    %ebp
  800b24:	c3                   	ret    

00800b25 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b25:	f3 0f 1e fb          	endbr32 
  800b29:	55                   	push   %ebp
  800b2a:	89 e5                	mov    %esp,%ebp
  800b2c:	57                   	push   %edi
  800b2d:	56                   	push   %esi
  800b2e:	53                   	push   %ebx
  800b2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b32:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b35:	eb 03                	jmp    800b3a <strtol+0x15>
		s++;
  800b37:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b3a:	0f b6 01             	movzbl (%ecx),%eax
  800b3d:	3c 20                	cmp    $0x20,%al
  800b3f:	74 f6                	je     800b37 <strtol+0x12>
  800b41:	3c 09                	cmp    $0x9,%al
  800b43:	74 f2                	je     800b37 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800b45:	3c 2b                	cmp    $0x2b,%al
  800b47:	74 2a                	je     800b73 <strtol+0x4e>
	int neg = 0;
  800b49:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b4e:	3c 2d                	cmp    $0x2d,%al
  800b50:	74 2b                	je     800b7d <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b52:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b58:	75 0f                	jne    800b69 <strtol+0x44>
  800b5a:	80 39 30             	cmpb   $0x30,(%ecx)
  800b5d:	74 28                	je     800b87 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b5f:	85 db                	test   %ebx,%ebx
  800b61:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b66:	0f 44 d8             	cmove  %eax,%ebx
  800b69:	b8 00 00 00 00       	mov    $0x0,%eax
  800b6e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b71:	eb 46                	jmp    800bb9 <strtol+0x94>
		s++;
  800b73:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b76:	bf 00 00 00 00       	mov    $0x0,%edi
  800b7b:	eb d5                	jmp    800b52 <strtol+0x2d>
		s++, neg = 1;
  800b7d:	83 c1 01             	add    $0x1,%ecx
  800b80:	bf 01 00 00 00       	mov    $0x1,%edi
  800b85:	eb cb                	jmp    800b52 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b87:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b8b:	74 0e                	je     800b9b <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b8d:	85 db                	test   %ebx,%ebx
  800b8f:	75 d8                	jne    800b69 <strtol+0x44>
		s++, base = 8;
  800b91:	83 c1 01             	add    $0x1,%ecx
  800b94:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b99:	eb ce                	jmp    800b69 <strtol+0x44>
		s += 2, base = 16;
  800b9b:	83 c1 02             	add    $0x2,%ecx
  800b9e:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ba3:	eb c4                	jmp    800b69 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800ba5:	0f be d2             	movsbl %dl,%edx
  800ba8:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bab:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bae:	7d 3a                	jge    800bea <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800bb0:	83 c1 01             	add    $0x1,%ecx
  800bb3:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bb7:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bb9:	0f b6 11             	movzbl (%ecx),%edx
  800bbc:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bbf:	89 f3                	mov    %esi,%ebx
  800bc1:	80 fb 09             	cmp    $0x9,%bl
  800bc4:	76 df                	jbe    800ba5 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800bc6:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bc9:	89 f3                	mov    %esi,%ebx
  800bcb:	80 fb 19             	cmp    $0x19,%bl
  800bce:	77 08                	ja     800bd8 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800bd0:	0f be d2             	movsbl %dl,%edx
  800bd3:	83 ea 57             	sub    $0x57,%edx
  800bd6:	eb d3                	jmp    800bab <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800bd8:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bdb:	89 f3                	mov    %esi,%ebx
  800bdd:	80 fb 19             	cmp    $0x19,%bl
  800be0:	77 08                	ja     800bea <strtol+0xc5>
			dig = *s - 'A' + 10;
  800be2:	0f be d2             	movsbl %dl,%edx
  800be5:	83 ea 37             	sub    $0x37,%edx
  800be8:	eb c1                	jmp    800bab <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bee:	74 05                	je     800bf5 <strtol+0xd0>
		*endptr = (char *) s;
  800bf0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bf3:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bf5:	89 c2                	mov    %eax,%edx
  800bf7:	f7 da                	neg    %edx
  800bf9:	85 ff                	test   %edi,%edi
  800bfb:	0f 45 c2             	cmovne %edx,%eax
}
  800bfe:	5b                   	pop    %ebx
  800bff:	5e                   	pop    %esi
  800c00:	5f                   	pop    %edi
  800c01:	5d                   	pop    %ebp
  800c02:	c3                   	ret    

00800c03 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c03:	f3 0f 1e fb          	endbr32 
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	57                   	push   %edi
  800c0b:	56                   	push   %esi
  800c0c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c0d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c12:	8b 55 08             	mov    0x8(%ebp),%edx
  800c15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c18:	89 c3                	mov    %eax,%ebx
  800c1a:	89 c7                	mov    %eax,%edi
  800c1c:	89 c6                	mov    %eax,%esi
  800c1e:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c20:	5b                   	pop    %ebx
  800c21:	5e                   	pop    %esi
  800c22:	5f                   	pop    %edi
  800c23:	5d                   	pop    %ebp
  800c24:	c3                   	ret    

00800c25 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c25:	f3 0f 1e fb          	endbr32 
  800c29:	55                   	push   %ebp
  800c2a:	89 e5                	mov    %esp,%ebp
  800c2c:	57                   	push   %edi
  800c2d:	56                   	push   %esi
  800c2e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c2f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c34:	b8 01 00 00 00       	mov    $0x1,%eax
  800c39:	89 d1                	mov    %edx,%ecx
  800c3b:	89 d3                	mov    %edx,%ebx
  800c3d:	89 d7                	mov    %edx,%edi
  800c3f:	89 d6                	mov    %edx,%esi
  800c41:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c43:	5b                   	pop    %ebx
  800c44:	5e                   	pop    %esi
  800c45:	5f                   	pop    %edi
  800c46:	5d                   	pop    %ebp
  800c47:	c3                   	ret    

00800c48 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c48:	f3 0f 1e fb          	endbr32 
  800c4c:	55                   	push   %ebp
  800c4d:	89 e5                	mov    %esp,%ebp
  800c4f:	57                   	push   %edi
  800c50:	56                   	push   %esi
  800c51:	53                   	push   %ebx
  800c52:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c55:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5d:	b8 03 00 00 00       	mov    $0x3,%eax
  800c62:	89 cb                	mov    %ecx,%ebx
  800c64:	89 cf                	mov    %ecx,%edi
  800c66:	89 ce                	mov    %ecx,%esi
  800c68:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c6a:	85 c0                	test   %eax,%eax
  800c6c:	7f 08                	jg     800c76 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c71:	5b                   	pop    %ebx
  800c72:	5e                   	pop    %esi
  800c73:	5f                   	pop    %edi
  800c74:	5d                   	pop    %ebp
  800c75:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c76:	83 ec 0c             	sub    $0xc,%esp
  800c79:	50                   	push   %eax
  800c7a:	6a 03                	push   $0x3
  800c7c:	68 5f 2f 80 00       	push   $0x802f5f
  800c81:	6a 23                	push   $0x23
  800c83:	68 7c 2f 80 00       	push   $0x802f7c
  800c88:	e8 13 f5 ff ff       	call   8001a0 <_panic>

00800c8d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c8d:	f3 0f 1e fb          	endbr32 
  800c91:	55                   	push   %ebp
  800c92:	89 e5                	mov    %esp,%ebp
  800c94:	57                   	push   %edi
  800c95:	56                   	push   %esi
  800c96:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c97:	ba 00 00 00 00       	mov    $0x0,%edx
  800c9c:	b8 02 00 00 00       	mov    $0x2,%eax
  800ca1:	89 d1                	mov    %edx,%ecx
  800ca3:	89 d3                	mov    %edx,%ebx
  800ca5:	89 d7                	mov    %edx,%edi
  800ca7:	89 d6                	mov    %edx,%esi
  800ca9:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cab:	5b                   	pop    %ebx
  800cac:	5e                   	pop    %esi
  800cad:	5f                   	pop    %edi
  800cae:	5d                   	pop    %ebp
  800caf:	c3                   	ret    

00800cb0 <sys_yield>:

void
sys_yield(void)
{
  800cb0:	f3 0f 1e fb          	endbr32 
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	57                   	push   %edi
  800cb8:	56                   	push   %esi
  800cb9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cba:	ba 00 00 00 00       	mov    $0x0,%edx
  800cbf:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cc4:	89 d1                	mov    %edx,%ecx
  800cc6:	89 d3                	mov    %edx,%ebx
  800cc8:	89 d7                	mov    %edx,%edi
  800cca:	89 d6                	mov    %edx,%esi
  800ccc:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cce:	5b                   	pop    %ebx
  800ccf:	5e                   	pop    %esi
  800cd0:	5f                   	pop    %edi
  800cd1:	5d                   	pop    %ebp
  800cd2:	c3                   	ret    

00800cd3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cd3:	f3 0f 1e fb          	endbr32 
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	57                   	push   %edi
  800cdb:	56                   	push   %esi
  800cdc:	53                   	push   %ebx
  800cdd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ce0:	be 00 00 00 00       	mov    $0x0,%esi
  800ce5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ceb:	b8 04 00 00 00       	mov    $0x4,%eax
  800cf0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cf3:	89 f7                	mov    %esi,%edi
  800cf5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf7:	85 c0                	test   %eax,%eax
  800cf9:	7f 08                	jg     800d03 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cfe:	5b                   	pop    %ebx
  800cff:	5e                   	pop    %esi
  800d00:	5f                   	pop    %edi
  800d01:	5d                   	pop    %ebp
  800d02:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d03:	83 ec 0c             	sub    $0xc,%esp
  800d06:	50                   	push   %eax
  800d07:	6a 04                	push   $0x4
  800d09:	68 5f 2f 80 00       	push   $0x802f5f
  800d0e:	6a 23                	push   $0x23
  800d10:	68 7c 2f 80 00       	push   $0x802f7c
  800d15:	e8 86 f4 ff ff       	call   8001a0 <_panic>

00800d1a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d1a:	f3 0f 1e fb          	endbr32 
  800d1e:	55                   	push   %ebp
  800d1f:	89 e5                	mov    %esp,%ebp
  800d21:	57                   	push   %edi
  800d22:	56                   	push   %esi
  800d23:	53                   	push   %ebx
  800d24:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d27:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2d:	b8 05 00 00 00       	mov    $0x5,%eax
  800d32:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d35:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d38:	8b 75 18             	mov    0x18(%ebp),%esi
  800d3b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d3d:	85 c0                	test   %eax,%eax
  800d3f:	7f 08                	jg     800d49 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d44:	5b                   	pop    %ebx
  800d45:	5e                   	pop    %esi
  800d46:	5f                   	pop    %edi
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d49:	83 ec 0c             	sub    $0xc,%esp
  800d4c:	50                   	push   %eax
  800d4d:	6a 05                	push   $0x5
  800d4f:	68 5f 2f 80 00       	push   $0x802f5f
  800d54:	6a 23                	push   $0x23
  800d56:	68 7c 2f 80 00       	push   $0x802f7c
  800d5b:	e8 40 f4 ff ff       	call   8001a0 <_panic>

00800d60 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d60:	f3 0f 1e fb          	endbr32 
  800d64:	55                   	push   %ebp
  800d65:	89 e5                	mov    %esp,%ebp
  800d67:	57                   	push   %edi
  800d68:	56                   	push   %esi
  800d69:	53                   	push   %ebx
  800d6a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d6d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d72:	8b 55 08             	mov    0x8(%ebp),%edx
  800d75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d78:	b8 06 00 00 00       	mov    $0x6,%eax
  800d7d:	89 df                	mov    %ebx,%edi
  800d7f:	89 de                	mov    %ebx,%esi
  800d81:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d83:	85 c0                	test   %eax,%eax
  800d85:	7f 08                	jg     800d8f <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d8a:	5b                   	pop    %ebx
  800d8b:	5e                   	pop    %esi
  800d8c:	5f                   	pop    %edi
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d8f:	83 ec 0c             	sub    $0xc,%esp
  800d92:	50                   	push   %eax
  800d93:	6a 06                	push   $0x6
  800d95:	68 5f 2f 80 00       	push   $0x802f5f
  800d9a:	6a 23                	push   $0x23
  800d9c:	68 7c 2f 80 00       	push   $0x802f7c
  800da1:	e8 fa f3 ff ff       	call   8001a0 <_panic>

00800da6 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800da6:	f3 0f 1e fb          	endbr32 
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	57                   	push   %edi
  800dae:	56                   	push   %esi
  800daf:	53                   	push   %ebx
  800db0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dbe:	b8 08 00 00 00       	mov    $0x8,%eax
  800dc3:	89 df                	mov    %ebx,%edi
  800dc5:	89 de                	mov    %ebx,%esi
  800dc7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc9:	85 c0                	test   %eax,%eax
  800dcb:	7f 08                	jg     800dd5 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dcd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd0:	5b                   	pop    %ebx
  800dd1:	5e                   	pop    %esi
  800dd2:	5f                   	pop    %edi
  800dd3:	5d                   	pop    %ebp
  800dd4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd5:	83 ec 0c             	sub    $0xc,%esp
  800dd8:	50                   	push   %eax
  800dd9:	6a 08                	push   $0x8
  800ddb:	68 5f 2f 80 00       	push   $0x802f5f
  800de0:	6a 23                	push   $0x23
  800de2:	68 7c 2f 80 00       	push   $0x802f7c
  800de7:	e8 b4 f3 ff ff       	call   8001a0 <_panic>

00800dec <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800dec:	f3 0f 1e fb          	endbr32 
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	57                   	push   %edi
  800df4:	56                   	push   %esi
  800df5:	53                   	push   %ebx
  800df6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dfe:	8b 55 08             	mov    0x8(%ebp),%edx
  800e01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e04:	b8 09 00 00 00       	mov    $0x9,%eax
  800e09:	89 df                	mov    %ebx,%edi
  800e0b:	89 de                	mov    %ebx,%esi
  800e0d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e0f:	85 c0                	test   %eax,%eax
  800e11:	7f 08                	jg     800e1b <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e13:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e16:	5b                   	pop    %ebx
  800e17:	5e                   	pop    %esi
  800e18:	5f                   	pop    %edi
  800e19:	5d                   	pop    %ebp
  800e1a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1b:	83 ec 0c             	sub    $0xc,%esp
  800e1e:	50                   	push   %eax
  800e1f:	6a 09                	push   $0x9
  800e21:	68 5f 2f 80 00       	push   $0x802f5f
  800e26:	6a 23                	push   $0x23
  800e28:	68 7c 2f 80 00       	push   $0x802f7c
  800e2d:	e8 6e f3 ff ff       	call   8001a0 <_panic>

00800e32 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e32:	f3 0f 1e fb          	endbr32 
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	57                   	push   %edi
  800e3a:	56                   	push   %esi
  800e3b:	53                   	push   %ebx
  800e3c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e3f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e44:	8b 55 08             	mov    0x8(%ebp),%edx
  800e47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e4f:	89 df                	mov    %ebx,%edi
  800e51:	89 de                	mov    %ebx,%esi
  800e53:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e55:	85 c0                	test   %eax,%eax
  800e57:	7f 08                	jg     800e61 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e59:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e5c:	5b                   	pop    %ebx
  800e5d:	5e                   	pop    %esi
  800e5e:	5f                   	pop    %edi
  800e5f:	5d                   	pop    %ebp
  800e60:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e61:	83 ec 0c             	sub    $0xc,%esp
  800e64:	50                   	push   %eax
  800e65:	6a 0a                	push   $0xa
  800e67:	68 5f 2f 80 00       	push   $0x802f5f
  800e6c:	6a 23                	push   $0x23
  800e6e:	68 7c 2f 80 00       	push   $0x802f7c
  800e73:	e8 28 f3 ff ff       	call   8001a0 <_panic>

00800e78 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e78:	f3 0f 1e fb          	endbr32 
  800e7c:	55                   	push   %ebp
  800e7d:	89 e5                	mov    %esp,%ebp
  800e7f:	57                   	push   %edi
  800e80:	56                   	push   %esi
  800e81:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e82:	8b 55 08             	mov    0x8(%ebp),%edx
  800e85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e88:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e8d:	be 00 00 00 00       	mov    $0x0,%esi
  800e92:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e95:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e98:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e9a:	5b                   	pop    %ebx
  800e9b:	5e                   	pop    %esi
  800e9c:	5f                   	pop    %edi
  800e9d:	5d                   	pop    %ebp
  800e9e:	c3                   	ret    

00800e9f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e9f:	f3 0f 1e fb          	endbr32 
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	57                   	push   %edi
  800ea7:	56                   	push   %esi
  800ea8:	53                   	push   %ebx
  800ea9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eac:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eb1:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb4:	b8 0d 00 00 00       	mov    $0xd,%eax
  800eb9:	89 cb                	mov    %ecx,%ebx
  800ebb:	89 cf                	mov    %ecx,%edi
  800ebd:	89 ce                	mov    %ecx,%esi
  800ebf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ec1:	85 c0                	test   %eax,%eax
  800ec3:	7f 08                	jg     800ecd <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ec5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec8:	5b                   	pop    %ebx
  800ec9:	5e                   	pop    %esi
  800eca:	5f                   	pop    %edi
  800ecb:	5d                   	pop    %ebp
  800ecc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ecd:	83 ec 0c             	sub    $0xc,%esp
  800ed0:	50                   	push   %eax
  800ed1:	6a 0d                	push   $0xd
  800ed3:	68 5f 2f 80 00       	push   $0x802f5f
  800ed8:	6a 23                	push   $0x23
  800eda:	68 7c 2f 80 00       	push   $0x802f7c
  800edf:	e8 bc f2 ff ff       	call   8001a0 <_panic>

00800ee4 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800ee4:	f3 0f 1e fb          	endbr32 
  800ee8:	55                   	push   %ebp
  800ee9:	89 e5                	mov    %esp,%ebp
  800eeb:	57                   	push   %edi
  800eec:	56                   	push   %esi
  800eed:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eee:	ba 00 00 00 00       	mov    $0x0,%edx
  800ef3:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ef8:	89 d1                	mov    %edx,%ecx
  800efa:	89 d3                	mov    %edx,%ebx
  800efc:	89 d7                	mov    %edx,%edi
  800efe:	89 d6                	mov    %edx,%esi
  800f00:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f02:	5b                   	pop    %ebx
  800f03:	5e                   	pop    %esi
  800f04:	5f                   	pop    %edi
  800f05:	5d                   	pop    %ebp
  800f06:	c3                   	ret    

00800f07 <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  800f07:	f3 0f 1e fb          	endbr32 
  800f0b:	55                   	push   %ebp
  800f0c:	89 e5                	mov    %esp,%ebp
  800f0e:	57                   	push   %edi
  800f0f:	56                   	push   %esi
  800f10:	53                   	push   %ebx
  800f11:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f14:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f19:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1f:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f24:	89 df                	mov    %ebx,%edi
  800f26:	89 de                	mov    %ebx,%esi
  800f28:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f2a:	85 c0                	test   %eax,%eax
  800f2c:	7f 08                	jg     800f36 <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  800f2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f31:	5b                   	pop    %ebx
  800f32:	5e                   	pop    %esi
  800f33:	5f                   	pop    %edi
  800f34:	5d                   	pop    %ebp
  800f35:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f36:	83 ec 0c             	sub    $0xc,%esp
  800f39:	50                   	push   %eax
  800f3a:	6a 0f                	push   $0xf
  800f3c:	68 5f 2f 80 00       	push   $0x802f5f
  800f41:	6a 23                	push   $0x23
  800f43:	68 7c 2f 80 00       	push   $0x802f7c
  800f48:	e8 53 f2 ff ff       	call   8001a0 <_panic>

00800f4d <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  800f4d:	f3 0f 1e fb          	endbr32 
  800f51:	55                   	push   %ebp
  800f52:	89 e5                	mov    %esp,%ebp
  800f54:	57                   	push   %edi
  800f55:	56                   	push   %esi
  800f56:	53                   	push   %ebx
  800f57:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f5a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f65:	b8 10 00 00 00       	mov    $0x10,%eax
  800f6a:	89 df                	mov    %ebx,%edi
  800f6c:	89 de                	mov    %ebx,%esi
  800f6e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f70:	85 c0                	test   %eax,%eax
  800f72:	7f 08                	jg     800f7c <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  800f74:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f77:	5b                   	pop    %ebx
  800f78:	5e                   	pop    %esi
  800f79:	5f                   	pop    %edi
  800f7a:	5d                   	pop    %ebp
  800f7b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f7c:	83 ec 0c             	sub    $0xc,%esp
  800f7f:	50                   	push   %eax
  800f80:	6a 10                	push   $0x10
  800f82:	68 5f 2f 80 00       	push   $0x802f5f
  800f87:	6a 23                	push   $0x23
  800f89:	68 7c 2f 80 00       	push   $0x802f7c
  800f8e:	e8 0d f2 ff ff       	call   8001a0 <_panic>

00800f93 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f93:	f3 0f 1e fb          	endbr32 
  800f97:	55                   	push   %ebp
  800f98:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9d:	05 00 00 00 30       	add    $0x30000000,%eax
  800fa2:	c1 e8 0c             	shr    $0xc,%eax
}
  800fa5:	5d                   	pop    %ebp
  800fa6:	c3                   	ret    

00800fa7 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fa7:	f3 0f 1e fb          	endbr32 
  800fab:	55                   	push   %ebp
  800fac:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800fb6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fbb:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800fc0:	5d                   	pop    %ebp
  800fc1:	c3                   	ret    

00800fc2 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800fc2:	f3 0f 1e fb          	endbr32 
  800fc6:	55                   	push   %ebp
  800fc7:	89 e5                	mov    %esp,%ebp
  800fc9:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fce:	89 c2                	mov    %eax,%edx
  800fd0:	c1 ea 16             	shr    $0x16,%edx
  800fd3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fda:	f6 c2 01             	test   $0x1,%dl
  800fdd:	74 2d                	je     80100c <fd_alloc+0x4a>
  800fdf:	89 c2                	mov    %eax,%edx
  800fe1:	c1 ea 0c             	shr    $0xc,%edx
  800fe4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800feb:	f6 c2 01             	test   $0x1,%dl
  800fee:	74 1c                	je     80100c <fd_alloc+0x4a>
  800ff0:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800ff5:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800ffa:	75 d2                	jne    800fce <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801005:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80100a:	eb 0a                	jmp    801016 <fd_alloc+0x54>
			*fd_store = fd;
  80100c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80100f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801011:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801016:	5d                   	pop    %ebp
  801017:	c3                   	ret    

00801018 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801018:	f3 0f 1e fb          	endbr32 
  80101c:	55                   	push   %ebp
  80101d:	89 e5                	mov    %esp,%ebp
  80101f:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801022:	83 f8 1f             	cmp    $0x1f,%eax
  801025:	77 30                	ja     801057 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801027:	c1 e0 0c             	shl    $0xc,%eax
  80102a:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80102f:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801035:	f6 c2 01             	test   $0x1,%dl
  801038:	74 24                	je     80105e <fd_lookup+0x46>
  80103a:	89 c2                	mov    %eax,%edx
  80103c:	c1 ea 0c             	shr    $0xc,%edx
  80103f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801046:	f6 c2 01             	test   $0x1,%dl
  801049:	74 1a                	je     801065 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80104b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80104e:	89 02                	mov    %eax,(%edx)
	return 0;
  801050:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801055:	5d                   	pop    %ebp
  801056:	c3                   	ret    
		return -E_INVAL;
  801057:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80105c:	eb f7                	jmp    801055 <fd_lookup+0x3d>
		return -E_INVAL;
  80105e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801063:	eb f0                	jmp    801055 <fd_lookup+0x3d>
  801065:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80106a:	eb e9                	jmp    801055 <fd_lookup+0x3d>

0080106c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80106c:	f3 0f 1e fb          	endbr32 
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
  801073:	83 ec 08             	sub    $0x8,%esp
  801076:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801079:	ba 00 00 00 00       	mov    $0x0,%edx
  80107e:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801083:	39 08                	cmp    %ecx,(%eax)
  801085:	74 38                	je     8010bf <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  801087:	83 c2 01             	add    $0x1,%edx
  80108a:	8b 04 95 08 30 80 00 	mov    0x803008(,%edx,4),%eax
  801091:	85 c0                	test   %eax,%eax
  801093:	75 ee                	jne    801083 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801095:	a1 08 50 80 00       	mov    0x805008,%eax
  80109a:	8b 40 48             	mov    0x48(%eax),%eax
  80109d:	83 ec 04             	sub    $0x4,%esp
  8010a0:	51                   	push   %ecx
  8010a1:	50                   	push   %eax
  8010a2:	68 8c 2f 80 00       	push   $0x802f8c
  8010a7:	e8 db f1 ff ff       	call   800287 <cprintf>
	*dev = 0;
  8010ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010b5:	83 c4 10             	add    $0x10,%esp
  8010b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010bd:	c9                   	leave  
  8010be:	c3                   	ret    
			*dev = devtab[i];
  8010bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c2:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8010c9:	eb f2                	jmp    8010bd <dev_lookup+0x51>

008010cb <fd_close>:
{
  8010cb:	f3 0f 1e fb          	endbr32 
  8010cf:	55                   	push   %ebp
  8010d0:	89 e5                	mov    %esp,%ebp
  8010d2:	57                   	push   %edi
  8010d3:	56                   	push   %esi
  8010d4:	53                   	push   %ebx
  8010d5:	83 ec 24             	sub    $0x24,%esp
  8010d8:	8b 75 08             	mov    0x8(%ebp),%esi
  8010db:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010de:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010e1:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010e2:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8010e8:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010eb:	50                   	push   %eax
  8010ec:	e8 27 ff ff ff       	call   801018 <fd_lookup>
  8010f1:	89 c3                	mov    %eax,%ebx
  8010f3:	83 c4 10             	add    $0x10,%esp
  8010f6:	85 c0                	test   %eax,%eax
  8010f8:	78 05                	js     8010ff <fd_close+0x34>
	    || fd != fd2)
  8010fa:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8010fd:	74 16                	je     801115 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8010ff:	89 f8                	mov    %edi,%eax
  801101:	84 c0                	test   %al,%al
  801103:	b8 00 00 00 00       	mov    $0x0,%eax
  801108:	0f 44 d8             	cmove  %eax,%ebx
}
  80110b:	89 d8                	mov    %ebx,%eax
  80110d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801110:	5b                   	pop    %ebx
  801111:	5e                   	pop    %esi
  801112:	5f                   	pop    %edi
  801113:	5d                   	pop    %ebp
  801114:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801115:	83 ec 08             	sub    $0x8,%esp
  801118:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80111b:	50                   	push   %eax
  80111c:	ff 36                	pushl  (%esi)
  80111e:	e8 49 ff ff ff       	call   80106c <dev_lookup>
  801123:	89 c3                	mov    %eax,%ebx
  801125:	83 c4 10             	add    $0x10,%esp
  801128:	85 c0                	test   %eax,%eax
  80112a:	78 1a                	js     801146 <fd_close+0x7b>
		if (dev->dev_close)
  80112c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80112f:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801132:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801137:	85 c0                	test   %eax,%eax
  801139:	74 0b                	je     801146 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80113b:	83 ec 0c             	sub    $0xc,%esp
  80113e:	56                   	push   %esi
  80113f:	ff d0                	call   *%eax
  801141:	89 c3                	mov    %eax,%ebx
  801143:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801146:	83 ec 08             	sub    $0x8,%esp
  801149:	56                   	push   %esi
  80114a:	6a 00                	push   $0x0
  80114c:	e8 0f fc ff ff       	call   800d60 <sys_page_unmap>
	return r;
  801151:	83 c4 10             	add    $0x10,%esp
  801154:	eb b5                	jmp    80110b <fd_close+0x40>

00801156 <close>:

int
close(int fdnum)
{
  801156:	f3 0f 1e fb          	endbr32 
  80115a:	55                   	push   %ebp
  80115b:	89 e5                	mov    %esp,%ebp
  80115d:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801160:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801163:	50                   	push   %eax
  801164:	ff 75 08             	pushl  0x8(%ebp)
  801167:	e8 ac fe ff ff       	call   801018 <fd_lookup>
  80116c:	83 c4 10             	add    $0x10,%esp
  80116f:	85 c0                	test   %eax,%eax
  801171:	79 02                	jns    801175 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801173:	c9                   	leave  
  801174:	c3                   	ret    
		return fd_close(fd, 1);
  801175:	83 ec 08             	sub    $0x8,%esp
  801178:	6a 01                	push   $0x1
  80117a:	ff 75 f4             	pushl  -0xc(%ebp)
  80117d:	e8 49 ff ff ff       	call   8010cb <fd_close>
  801182:	83 c4 10             	add    $0x10,%esp
  801185:	eb ec                	jmp    801173 <close+0x1d>

00801187 <close_all>:

void
close_all(void)
{
  801187:	f3 0f 1e fb          	endbr32 
  80118b:	55                   	push   %ebp
  80118c:	89 e5                	mov    %esp,%ebp
  80118e:	53                   	push   %ebx
  80118f:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801192:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801197:	83 ec 0c             	sub    $0xc,%esp
  80119a:	53                   	push   %ebx
  80119b:	e8 b6 ff ff ff       	call   801156 <close>
	for (i = 0; i < MAXFD; i++)
  8011a0:	83 c3 01             	add    $0x1,%ebx
  8011a3:	83 c4 10             	add    $0x10,%esp
  8011a6:	83 fb 20             	cmp    $0x20,%ebx
  8011a9:	75 ec                	jne    801197 <close_all+0x10>
}
  8011ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011ae:	c9                   	leave  
  8011af:	c3                   	ret    

008011b0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011b0:	f3 0f 1e fb          	endbr32 
  8011b4:	55                   	push   %ebp
  8011b5:	89 e5                	mov    %esp,%ebp
  8011b7:	57                   	push   %edi
  8011b8:	56                   	push   %esi
  8011b9:	53                   	push   %ebx
  8011ba:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011bd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011c0:	50                   	push   %eax
  8011c1:	ff 75 08             	pushl  0x8(%ebp)
  8011c4:	e8 4f fe ff ff       	call   801018 <fd_lookup>
  8011c9:	89 c3                	mov    %eax,%ebx
  8011cb:	83 c4 10             	add    $0x10,%esp
  8011ce:	85 c0                	test   %eax,%eax
  8011d0:	0f 88 81 00 00 00    	js     801257 <dup+0xa7>
		return r;
	close(newfdnum);
  8011d6:	83 ec 0c             	sub    $0xc,%esp
  8011d9:	ff 75 0c             	pushl  0xc(%ebp)
  8011dc:	e8 75 ff ff ff       	call   801156 <close>

	newfd = INDEX2FD(newfdnum);
  8011e1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011e4:	c1 e6 0c             	shl    $0xc,%esi
  8011e7:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8011ed:	83 c4 04             	add    $0x4,%esp
  8011f0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011f3:	e8 af fd ff ff       	call   800fa7 <fd2data>
  8011f8:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8011fa:	89 34 24             	mov    %esi,(%esp)
  8011fd:	e8 a5 fd ff ff       	call   800fa7 <fd2data>
  801202:	83 c4 10             	add    $0x10,%esp
  801205:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801207:	89 d8                	mov    %ebx,%eax
  801209:	c1 e8 16             	shr    $0x16,%eax
  80120c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801213:	a8 01                	test   $0x1,%al
  801215:	74 11                	je     801228 <dup+0x78>
  801217:	89 d8                	mov    %ebx,%eax
  801219:	c1 e8 0c             	shr    $0xc,%eax
  80121c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801223:	f6 c2 01             	test   $0x1,%dl
  801226:	75 39                	jne    801261 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801228:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80122b:	89 d0                	mov    %edx,%eax
  80122d:	c1 e8 0c             	shr    $0xc,%eax
  801230:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801237:	83 ec 0c             	sub    $0xc,%esp
  80123a:	25 07 0e 00 00       	and    $0xe07,%eax
  80123f:	50                   	push   %eax
  801240:	56                   	push   %esi
  801241:	6a 00                	push   $0x0
  801243:	52                   	push   %edx
  801244:	6a 00                	push   $0x0
  801246:	e8 cf fa ff ff       	call   800d1a <sys_page_map>
  80124b:	89 c3                	mov    %eax,%ebx
  80124d:	83 c4 20             	add    $0x20,%esp
  801250:	85 c0                	test   %eax,%eax
  801252:	78 31                	js     801285 <dup+0xd5>
		goto err;

	return newfdnum;
  801254:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801257:	89 d8                	mov    %ebx,%eax
  801259:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80125c:	5b                   	pop    %ebx
  80125d:	5e                   	pop    %esi
  80125e:	5f                   	pop    %edi
  80125f:	5d                   	pop    %ebp
  801260:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801261:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801268:	83 ec 0c             	sub    $0xc,%esp
  80126b:	25 07 0e 00 00       	and    $0xe07,%eax
  801270:	50                   	push   %eax
  801271:	57                   	push   %edi
  801272:	6a 00                	push   $0x0
  801274:	53                   	push   %ebx
  801275:	6a 00                	push   $0x0
  801277:	e8 9e fa ff ff       	call   800d1a <sys_page_map>
  80127c:	89 c3                	mov    %eax,%ebx
  80127e:	83 c4 20             	add    $0x20,%esp
  801281:	85 c0                	test   %eax,%eax
  801283:	79 a3                	jns    801228 <dup+0x78>
	sys_page_unmap(0, newfd);
  801285:	83 ec 08             	sub    $0x8,%esp
  801288:	56                   	push   %esi
  801289:	6a 00                	push   $0x0
  80128b:	e8 d0 fa ff ff       	call   800d60 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801290:	83 c4 08             	add    $0x8,%esp
  801293:	57                   	push   %edi
  801294:	6a 00                	push   $0x0
  801296:	e8 c5 fa ff ff       	call   800d60 <sys_page_unmap>
	return r;
  80129b:	83 c4 10             	add    $0x10,%esp
  80129e:	eb b7                	jmp    801257 <dup+0xa7>

008012a0 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012a0:	f3 0f 1e fb          	endbr32 
  8012a4:	55                   	push   %ebp
  8012a5:	89 e5                	mov    %esp,%ebp
  8012a7:	53                   	push   %ebx
  8012a8:	83 ec 1c             	sub    $0x1c,%esp
  8012ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012ae:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012b1:	50                   	push   %eax
  8012b2:	53                   	push   %ebx
  8012b3:	e8 60 fd ff ff       	call   801018 <fd_lookup>
  8012b8:	83 c4 10             	add    $0x10,%esp
  8012bb:	85 c0                	test   %eax,%eax
  8012bd:	78 3f                	js     8012fe <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012bf:	83 ec 08             	sub    $0x8,%esp
  8012c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012c5:	50                   	push   %eax
  8012c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012c9:	ff 30                	pushl  (%eax)
  8012cb:	e8 9c fd ff ff       	call   80106c <dev_lookup>
  8012d0:	83 c4 10             	add    $0x10,%esp
  8012d3:	85 c0                	test   %eax,%eax
  8012d5:	78 27                	js     8012fe <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012da:	8b 42 08             	mov    0x8(%edx),%eax
  8012dd:	83 e0 03             	and    $0x3,%eax
  8012e0:	83 f8 01             	cmp    $0x1,%eax
  8012e3:	74 1e                	je     801303 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8012e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e8:	8b 40 08             	mov    0x8(%eax),%eax
  8012eb:	85 c0                	test   %eax,%eax
  8012ed:	74 35                	je     801324 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012ef:	83 ec 04             	sub    $0x4,%esp
  8012f2:	ff 75 10             	pushl  0x10(%ebp)
  8012f5:	ff 75 0c             	pushl  0xc(%ebp)
  8012f8:	52                   	push   %edx
  8012f9:	ff d0                	call   *%eax
  8012fb:	83 c4 10             	add    $0x10,%esp
}
  8012fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801301:	c9                   	leave  
  801302:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801303:	a1 08 50 80 00       	mov    0x805008,%eax
  801308:	8b 40 48             	mov    0x48(%eax),%eax
  80130b:	83 ec 04             	sub    $0x4,%esp
  80130e:	53                   	push   %ebx
  80130f:	50                   	push   %eax
  801310:	68 cd 2f 80 00       	push   $0x802fcd
  801315:	e8 6d ef ff ff       	call   800287 <cprintf>
		return -E_INVAL;
  80131a:	83 c4 10             	add    $0x10,%esp
  80131d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801322:	eb da                	jmp    8012fe <read+0x5e>
		return -E_NOT_SUPP;
  801324:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801329:	eb d3                	jmp    8012fe <read+0x5e>

0080132b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80132b:	f3 0f 1e fb          	endbr32 
  80132f:	55                   	push   %ebp
  801330:	89 e5                	mov    %esp,%ebp
  801332:	57                   	push   %edi
  801333:	56                   	push   %esi
  801334:	53                   	push   %ebx
  801335:	83 ec 0c             	sub    $0xc,%esp
  801338:	8b 7d 08             	mov    0x8(%ebp),%edi
  80133b:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80133e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801343:	eb 02                	jmp    801347 <readn+0x1c>
  801345:	01 c3                	add    %eax,%ebx
  801347:	39 f3                	cmp    %esi,%ebx
  801349:	73 21                	jae    80136c <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80134b:	83 ec 04             	sub    $0x4,%esp
  80134e:	89 f0                	mov    %esi,%eax
  801350:	29 d8                	sub    %ebx,%eax
  801352:	50                   	push   %eax
  801353:	89 d8                	mov    %ebx,%eax
  801355:	03 45 0c             	add    0xc(%ebp),%eax
  801358:	50                   	push   %eax
  801359:	57                   	push   %edi
  80135a:	e8 41 ff ff ff       	call   8012a0 <read>
		if (m < 0)
  80135f:	83 c4 10             	add    $0x10,%esp
  801362:	85 c0                	test   %eax,%eax
  801364:	78 04                	js     80136a <readn+0x3f>
			return m;
		if (m == 0)
  801366:	75 dd                	jne    801345 <readn+0x1a>
  801368:	eb 02                	jmp    80136c <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80136a:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80136c:	89 d8                	mov    %ebx,%eax
  80136e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801371:	5b                   	pop    %ebx
  801372:	5e                   	pop    %esi
  801373:	5f                   	pop    %edi
  801374:	5d                   	pop    %ebp
  801375:	c3                   	ret    

00801376 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801376:	f3 0f 1e fb          	endbr32 
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
  80137d:	53                   	push   %ebx
  80137e:	83 ec 1c             	sub    $0x1c,%esp
  801381:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801384:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801387:	50                   	push   %eax
  801388:	53                   	push   %ebx
  801389:	e8 8a fc ff ff       	call   801018 <fd_lookup>
  80138e:	83 c4 10             	add    $0x10,%esp
  801391:	85 c0                	test   %eax,%eax
  801393:	78 3a                	js     8013cf <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801395:	83 ec 08             	sub    $0x8,%esp
  801398:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80139b:	50                   	push   %eax
  80139c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80139f:	ff 30                	pushl  (%eax)
  8013a1:	e8 c6 fc ff ff       	call   80106c <dev_lookup>
  8013a6:	83 c4 10             	add    $0x10,%esp
  8013a9:	85 c0                	test   %eax,%eax
  8013ab:	78 22                	js     8013cf <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013b4:	74 1e                	je     8013d4 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b9:	8b 52 0c             	mov    0xc(%edx),%edx
  8013bc:	85 d2                	test   %edx,%edx
  8013be:	74 35                	je     8013f5 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013c0:	83 ec 04             	sub    $0x4,%esp
  8013c3:	ff 75 10             	pushl  0x10(%ebp)
  8013c6:	ff 75 0c             	pushl  0xc(%ebp)
  8013c9:	50                   	push   %eax
  8013ca:	ff d2                	call   *%edx
  8013cc:	83 c4 10             	add    $0x10,%esp
}
  8013cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013d2:	c9                   	leave  
  8013d3:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013d4:	a1 08 50 80 00       	mov    0x805008,%eax
  8013d9:	8b 40 48             	mov    0x48(%eax),%eax
  8013dc:	83 ec 04             	sub    $0x4,%esp
  8013df:	53                   	push   %ebx
  8013e0:	50                   	push   %eax
  8013e1:	68 e9 2f 80 00       	push   $0x802fe9
  8013e6:	e8 9c ee ff ff       	call   800287 <cprintf>
		return -E_INVAL;
  8013eb:	83 c4 10             	add    $0x10,%esp
  8013ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013f3:	eb da                	jmp    8013cf <write+0x59>
		return -E_NOT_SUPP;
  8013f5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013fa:	eb d3                	jmp    8013cf <write+0x59>

008013fc <seek>:

int
seek(int fdnum, off_t offset)
{
  8013fc:	f3 0f 1e fb          	endbr32 
  801400:	55                   	push   %ebp
  801401:	89 e5                	mov    %esp,%ebp
  801403:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801406:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801409:	50                   	push   %eax
  80140a:	ff 75 08             	pushl  0x8(%ebp)
  80140d:	e8 06 fc ff ff       	call   801018 <fd_lookup>
  801412:	83 c4 10             	add    $0x10,%esp
  801415:	85 c0                	test   %eax,%eax
  801417:	78 0e                	js     801427 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801419:	8b 55 0c             	mov    0xc(%ebp),%edx
  80141c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80141f:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801422:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801427:	c9                   	leave  
  801428:	c3                   	ret    

00801429 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801429:	f3 0f 1e fb          	endbr32 
  80142d:	55                   	push   %ebp
  80142e:	89 e5                	mov    %esp,%ebp
  801430:	53                   	push   %ebx
  801431:	83 ec 1c             	sub    $0x1c,%esp
  801434:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801437:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80143a:	50                   	push   %eax
  80143b:	53                   	push   %ebx
  80143c:	e8 d7 fb ff ff       	call   801018 <fd_lookup>
  801441:	83 c4 10             	add    $0x10,%esp
  801444:	85 c0                	test   %eax,%eax
  801446:	78 37                	js     80147f <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801448:	83 ec 08             	sub    $0x8,%esp
  80144b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80144e:	50                   	push   %eax
  80144f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801452:	ff 30                	pushl  (%eax)
  801454:	e8 13 fc ff ff       	call   80106c <dev_lookup>
  801459:	83 c4 10             	add    $0x10,%esp
  80145c:	85 c0                	test   %eax,%eax
  80145e:	78 1f                	js     80147f <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801460:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801463:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801467:	74 1b                	je     801484 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801469:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80146c:	8b 52 18             	mov    0x18(%edx),%edx
  80146f:	85 d2                	test   %edx,%edx
  801471:	74 32                	je     8014a5 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801473:	83 ec 08             	sub    $0x8,%esp
  801476:	ff 75 0c             	pushl  0xc(%ebp)
  801479:	50                   	push   %eax
  80147a:	ff d2                	call   *%edx
  80147c:	83 c4 10             	add    $0x10,%esp
}
  80147f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801482:	c9                   	leave  
  801483:	c3                   	ret    
			thisenv->env_id, fdnum);
  801484:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801489:	8b 40 48             	mov    0x48(%eax),%eax
  80148c:	83 ec 04             	sub    $0x4,%esp
  80148f:	53                   	push   %ebx
  801490:	50                   	push   %eax
  801491:	68 ac 2f 80 00       	push   $0x802fac
  801496:	e8 ec ed ff ff       	call   800287 <cprintf>
		return -E_INVAL;
  80149b:	83 c4 10             	add    $0x10,%esp
  80149e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014a3:	eb da                	jmp    80147f <ftruncate+0x56>
		return -E_NOT_SUPP;
  8014a5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014aa:	eb d3                	jmp    80147f <ftruncate+0x56>

008014ac <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014ac:	f3 0f 1e fb          	endbr32 
  8014b0:	55                   	push   %ebp
  8014b1:	89 e5                	mov    %esp,%ebp
  8014b3:	53                   	push   %ebx
  8014b4:	83 ec 1c             	sub    $0x1c,%esp
  8014b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014ba:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014bd:	50                   	push   %eax
  8014be:	ff 75 08             	pushl  0x8(%ebp)
  8014c1:	e8 52 fb ff ff       	call   801018 <fd_lookup>
  8014c6:	83 c4 10             	add    $0x10,%esp
  8014c9:	85 c0                	test   %eax,%eax
  8014cb:	78 4b                	js     801518 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014cd:	83 ec 08             	sub    $0x8,%esp
  8014d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014d3:	50                   	push   %eax
  8014d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d7:	ff 30                	pushl  (%eax)
  8014d9:	e8 8e fb ff ff       	call   80106c <dev_lookup>
  8014de:	83 c4 10             	add    $0x10,%esp
  8014e1:	85 c0                	test   %eax,%eax
  8014e3:	78 33                	js     801518 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8014e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014e8:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014ec:	74 2f                	je     80151d <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014ee:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014f1:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014f8:	00 00 00 
	stat->st_isdir = 0;
  8014fb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801502:	00 00 00 
	stat->st_dev = dev;
  801505:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80150b:	83 ec 08             	sub    $0x8,%esp
  80150e:	53                   	push   %ebx
  80150f:	ff 75 f0             	pushl  -0x10(%ebp)
  801512:	ff 50 14             	call   *0x14(%eax)
  801515:	83 c4 10             	add    $0x10,%esp
}
  801518:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80151b:	c9                   	leave  
  80151c:	c3                   	ret    
		return -E_NOT_SUPP;
  80151d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801522:	eb f4                	jmp    801518 <fstat+0x6c>

00801524 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801524:	f3 0f 1e fb          	endbr32 
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
  80152b:	56                   	push   %esi
  80152c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80152d:	83 ec 08             	sub    $0x8,%esp
  801530:	6a 00                	push   $0x0
  801532:	ff 75 08             	pushl  0x8(%ebp)
  801535:	e8 fb 01 00 00       	call   801735 <open>
  80153a:	89 c3                	mov    %eax,%ebx
  80153c:	83 c4 10             	add    $0x10,%esp
  80153f:	85 c0                	test   %eax,%eax
  801541:	78 1b                	js     80155e <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801543:	83 ec 08             	sub    $0x8,%esp
  801546:	ff 75 0c             	pushl  0xc(%ebp)
  801549:	50                   	push   %eax
  80154a:	e8 5d ff ff ff       	call   8014ac <fstat>
  80154f:	89 c6                	mov    %eax,%esi
	close(fd);
  801551:	89 1c 24             	mov    %ebx,(%esp)
  801554:	e8 fd fb ff ff       	call   801156 <close>
	return r;
  801559:	83 c4 10             	add    $0x10,%esp
  80155c:	89 f3                	mov    %esi,%ebx
}
  80155e:	89 d8                	mov    %ebx,%eax
  801560:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801563:	5b                   	pop    %ebx
  801564:	5e                   	pop    %esi
  801565:	5d                   	pop    %ebp
  801566:	c3                   	ret    

00801567 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801567:	55                   	push   %ebp
  801568:	89 e5                	mov    %esp,%ebp
  80156a:	56                   	push   %esi
  80156b:	53                   	push   %ebx
  80156c:	89 c6                	mov    %eax,%esi
  80156e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801570:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801577:	74 27                	je     8015a0 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801579:	6a 07                	push   $0x7
  80157b:	68 00 60 80 00       	push   $0x806000
  801580:	56                   	push   %esi
  801581:	ff 35 00 50 80 00    	pushl  0x805000
  801587:	e8 9c 12 00 00       	call   802828 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80158c:	83 c4 0c             	add    $0xc,%esp
  80158f:	6a 00                	push   $0x0
  801591:	53                   	push   %ebx
  801592:	6a 00                	push   $0x0
  801594:	e8 0a 12 00 00       	call   8027a3 <ipc_recv>
}
  801599:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80159c:	5b                   	pop    %ebx
  80159d:	5e                   	pop    %esi
  80159e:	5d                   	pop    %ebp
  80159f:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015a0:	83 ec 0c             	sub    $0xc,%esp
  8015a3:	6a 01                	push   $0x1
  8015a5:	e8 d6 12 00 00       	call   802880 <ipc_find_env>
  8015aa:	a3 00 50 80 00       	mov    %eax,0x805000
  8015af:	83 c4 10             	add    $0x10,%esp
  8015b2:	eb c5                	jmp    801579 <fsipc+0x12>

008015b4 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015b4:	f3 0f 1e fb          	endbr32 
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
  8015bb:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015be:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8015c4:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  8015c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015cc:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d6:	b8 02 00 00 00       	mov    $0x2,%eax
  8015db:	e8 87 ff ff ff       	call   801567 <fsipc>
}
  8015e0:	c9                   	leave  
  8015e1:	c3                   	ret    

008015e2 <devfile_flush>:
{
  8015e2:	f3 0f 1e fb          	endbr32 
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
  8015e9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8015f2:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8015f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8015fc:	b8 06 00 00 00       	mov    $0x6,%eax
  801601:	e8 61 ff ff ff       	call   801567 <fsipc>
}
  801606:	c9                   	leave  
  801607:	c3                   	ret    

00801608 <devfile_stat>:
{
  801608:	f3 0f 1e fb          	endbr32 
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
  80160f:	53                   	push   %ebx
  801610:	83 ec 04             	sub    $0x4,%esp
  801613:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801616:	8b 45 08             	mov    0x8(%ebp),%eax
  801619:	8b 40 0c             	mov    0xc(%eax),%eax
  80161c:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801621:	ba 00 00 00 00       	mov    $0x0,%edx
  801626:	b8 05 00 00 00       	mov    $0x5,%eax
  80162b:	e8 37 ff ff ff       	call   801567 <fsipc>
  801630:	85 c0                	test   %eax,%eax
  801632:	78 2c                	js     801660 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801634:	83 ec 08             	sub    $0x8,%esp
  801637:	68 00 60 80 00       	push   $0x806000
  80163c:	53                   	push   %ebx
  80163d:	e8 4f f2 ff ff       	call   800891 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801642:	a1 80 60 80 00       	mov    0x806080,%eax
  801647:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80164d:	a1 84 60 80 00       	mov    0x806084,%eax
  801652:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801658:	83 c4 10             	add    $0x10,%esp
  80165b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801660:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801663:	c9                   	leave  
  801664:	c3                   	ret    

00801665 <devfile_write>:
{
  801665:	f3 0f 1e fb          	endbr32 
  801669:	55                   	push   %ebp
  80166a:	89 e5                	mov    %esp,%ebp
  80166c:	83 ec 0c             	sub    $0xc,%esp
  80166f:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801672:	8b 55 08             	mov    0x8(%ebp),%edx
  801675:	8b 52 0c             	mov    0xc(%edx),%edx
  801678:	89 15 00 60 80 00    	mov    %edx,0x806000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  80167e:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801683:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801688:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  80168b:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801690:	50                   	push   %eax
  801691:	ff 75 0c             	pushl  0xc(%ebp)
  801694:	68 08 60 80 00       	push   $0x806008
  801699:	e8 a9 f3 ff ff       	call   800a47 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  80169e:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a3:	b8 04 00 00 00       	mov    $0x4,%eax
  8016a8:	e8 ba fe ff ff       	call   801567 <fsipc>
}
  8016ad:	c9                   	leave  
  8016ae:	c3                   	ret    

008016af <devfile_read>:
{
  8016af:	f3 0f 1e fb          	endbr32 
  8016b3:	55                   	push   %ebp
  8016b4:	89 e5                	mov    %esp,%ebp
  8016b6:	56                   	push   %esi
  8016b7:	53                   	push   %ebx
  8016b8:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	8b 40 0c             	mov    0xc(%eax),%eax
  8016c1:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  8016c6:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d1:	b8 03 00 00 00       	mov    $0x3,%eax
  8016d6:	e8 8c fe ff ff       	call   801567 <fsipc>
  8016db:	89 c3                	mov    %eax,%ebx
  8016dd:	85 c0                	test   %eax,%eax
  8016df:	78 1f                	js     801700 <devfile_read+0x51>
	assert(r <= n);
  8016e1:	39 f0                	cmp    %esi,%eax
  8016e3:	77 24                	ja     801709 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8016e5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016ea:	7f 33                	jg     80171f <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8016ec:	83 ec 04             	sub    $0x4,%esp
  8016ef:	50                   	push   %eax
  8016f0:	68 00 60 80 00       	push   $0x806000
  8016f5:	ff 75 0c             	pushl  0xc(%ebp)
  8016f8:	e8 4a f3 ff ff       	call   800a47 <memmove>
	return r;
  8016fd:	83 c4 10             	add    $0x10,%esp
}
  801700:	89 d8                	mov    %ebx,%eax
  801702:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801705:	5b                   	pop    %ebx
  801706:	5e                   	pop    %esi
  801707:	5d                   	pop    %ebp
  801708:	c3                   	ret    
	assert(r <= n);
  801709:	68 1c 30 80 00       	push   $0x80301c
  80170e:	68 23 30 80 00       	push   $0x803023
  801713:	6a 7c                	push   $0x7c
  801715:	68 38 30 80 00       	push   $0x803038
  80171a:	e8 81 ea ff ff       	call   8001a0 <_panic>
	assert(r <= PGSIZE);
  80171f:	68 43 30 80 00       	push   $0x803043
  801724:	68 23 30 80 00       	push   $0x803023
  801729:	6a 7d                	push   $0x7d
  80172b:	68 38 30 80 00       	push   $0x803038
  801730:	e8 6b ea ff ff       	call   8001a0 <_panic>

00801735 <open>:
{
  801735:	f3 0f 1e fb          	endbr32 
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
  80173c:	56                   	push   %esi
  80173d:	53                   	push   %ebx
  80173e:	83 ec 1c             	sub    $0x1c,%esp
  801741:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801744:	56                   	push   %esi
  801745:	e8 04 f1 ff ff       	call   80084e <strlen>
  80174a:	83 c4 10             	add    $0x10,%esp
  80174d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801752:	7f 6c                	jg     8017c0 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801754:	83 ec 0c             	sub    $0xc,%esp
  801757:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80175a:	50                   	push   %eax
  80175b:	e8 62 f8 ff ff       	call   800fc2 <fd_alloc>
  801760:	89 c3                	mov    %eax,%ebx
  801762:	83 c4 10             	add    $0x10,%esp
  801765:	85 c0                	test   %eax,%eax
  801767:	78 3c                	js     8017a5 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801769:	83 ec 08             	sub    $0x8,%esp
  80176c:	56                   	push   %esi
  80176d:	68 00 60 80 00       	push   $0x806000
  801772:	e8 1a f1 ff ff       	call   800891 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801777:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177a:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80177f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801782:	b8 01 00 00 00       	mov    $0x1,%eax
  801787:	e8 db fd ff ff       	call   801567 <fsipc>
  80178c:	89 c3                	mov    %eax,%ebx
  80178e:	83 c4 10             	add    $0x10,%esp
  801791:	85 c0                	test   %eax,%eax
  801793:	78 19                	js     8017ae <open+0x79>
	return fd2num(fd);
  801795:	83 ec 0c             	sub    $0xc,%esp
  801798:	ff 75 f4             	pushl  -0xc(%ebp)
  80179b:	e8 f3 f7 ff ff       	call   800f93 <fd2num>
  8017a0:	89 c3                	mov    %eax,%ebx
  8017a2:	83 c4 10             	add    $0x10,%esp
}
  8017a5:	89 d8                	mov    %ebx,%eax
  8017a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017aa:	5b                   	pop    %ebx
  8017ab:	5e                   	pop    %esi
  8017ac:	5d                   	pop    %ebp
  8017ad:	c3                   	ret    
		fd_close(fd, 0);
  8017ae:	83 ec 08             	sub    $0x8,%esp
  8017b1:	6a 00                	push   $0x0
  8017b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8017b6:	e8 10 f9 ff ff       	call   8010cb <fd_close>
		return r;
  8017bb:	83 c4 10             	add    $0x10,%esp
  8017be:	eb e5                	jmp    8017a5 <open+0x70>
		return -E_BAD_PATH;
  8017c0:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017c5:	eb de                	jmp    8017a5 <open+0x70>

008017c7 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017c7:	f3 0f 1e fb          	endbr32 
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
  8017ce:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d6:	b8 08 00 00 00       	mov    $0x8,%eax
  8017db:	e8 87 fd ff ff       	call   801567 <fsipc>
}
  8017e0:	c9                   	leave  
  8017e1:	c3                   	ret    

008017e2 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8017e2:	f3 0f 1e fb          	endbr32 
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
  8017e9:	57                   	push   %edi
  8017ea:	56                   	push   %esi
  8017eb:	53                   	push   %ebx
  8017ec:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8017f2:	6a 00                	push   $0x0
  8017f4:	ff 75 08             	pushl  0x8(%ebp)
  8017f7:	e8 39 ff ff ff       	call   801735 <open>
  8017fc:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801802:	83 c4 10             	add    $0x10,%esp
  801805:	85 c0                	test   %eax,%eax
  801807:	0f 88 e7 04 00 00    	js     801cf4 <spawn+0x512>
  80180d:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  80180f:	83 ec 04             	sub    $0x4,%esp
  801812:	68 00 02 00 00       	push   $0x200
  801817:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  80181d:	50                   	push   %eax
  80181e:	52                   	push   %edx
  80181f:	e8 07 fb ff ff       	call   80132b <readn>
  801824:	83 c4 10             	add    $0x10,%esp
  801827:	3d 00 02 00 00       	cmp    $0x200,%eax
  80182c:	75 7e                	jne    8018ac <spawn+0xca>
	    || elf->e_magic != ELF_MAGIC) {
  80182e:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801835:	45 4c 46 
  801838:	75 72                	jne    8018ac <spawn+0xca>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80183a:	b8 07 00 00 00       	mov    $0x7,%eax
  80183f:	cd 30                	int    $0x30
  801841:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801847:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  80184d:	85 c0                	test   %eax,%eax
  80184f:	0f 88 93 04 00 00    	js     801ce8 <spawn+0x506>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801855:	25 ff 03 00 00       	and    $0x3ff,%eax
  80185a:	6b f0 7c             	imul   $0x7c,%eax,%esi
  80185d:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801863:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801869:	b9 11 00 00 00       	mov    $0x11,%ecx
  80186e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801870:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801876:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  80187c:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801881:	be 00 00 00 00       	mov    $0x0,%esi
  801886:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801889:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
	for (argc = 0; argv[argc] != 0; argc++)
  801890:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801893:	85 c0                	test   %eax,%eax
  801895:	74 4d                	je     8018e4 <spawn+0x102>
		string_size += strlen(argv[argc]) + 1;
  801897:	83 ec 0c             	sub    $0xc,%esp
  80189a:	50                   	push   %eax
  80189b:	e8 ae ef ff ff       	call   80084e <strlen>
  8018a0:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  8018a4:	83 c3 01             	add    $0x1,%ebx
  8018a7:	83 c4 10             	add    $0x10,%esp
  8018aa:	eb dd                	jmp    801889 <spawn+0xa7>
		close(fd);
  8018ac:	83 ec 0c             	sub    $0xc,%esp
  8018af:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8018b5:	e8 9c f8 ff ff       	call   801156 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8018ba:	83 c4 0c             	add    $0xc,%esp
  8018bd:	68 7f 45 4c 46       	push   $0x464c457f
  8018c2:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  8018c8:	68 4f 30 80 00       	push   $0x80304f
  8018cd:	e8 b5 e9 ff ff       	call   800287 <cprintf>
		return -E_NOT_EXEC;
  8018d2:	83 c4 10             	add    $0x10,%esp
  8018d5:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  8018dc:	ff ff ff 
  8018df:	e9 10 04 00 00       	jmp    801cf4 <spawn+0x512>
  8018e4:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  8018ea:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8018f0:	bf 00 10 40 00       	mov    $0x401000,%edi
  8018f5:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  8018f7:	89 fa                	mov    %edi,%edx
  8018f9:	83 e2 fc             	and    $0xfffffffc,%edx
  8018fc:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801903:	29 c2                	sub    %eax,%edx
  801905:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80190b:	8d 42 f8             	lea    -0x8(%edx),%eax
  80190e:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801913:	0f 86 fe 03 00 00    	jbe    801d17 <spawn+0x535>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801919:	83 ec 04             	sub    $0x4,%esp
  80191c:	6a 07                	push   $0x7
  80191e:	68 00 00 40 00       	push   $0x400000
  801923:	6a 00                	push   $0x0
  801925:	e8 a9 f3 ff ff       	call   800cd3 <sys_page_alloc>
  80192a:	83 c4 10             	add    $0x10,%esp
  80192d:	85 c0                	test   %eax,%eax
  80192f:	0f 88 e7 03 00 00    	js     801d1c <spawn+0x53a>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801935:	be 00 00 00 00       	mov    $0x0,%esi
  80193a:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801940:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801943:	eb 30                	jmp    801975 <spawn+0x193>
		argv_store[i] = UTEMP2USTACK(string_store);
  801945:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  80194b:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801951:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801954:	83 ec 08             	sub    $0x8,%esp
  801957:	ff 34 b3             	pushl  (%ebx,%esi,4)
  80195a:	57                   	push   %edi
  80195b:	e8 31 ef ff ff       	call   800891 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801960:	83 c4 04             	add    $0x4,%esp
  801963:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801966:	e8 e3 ee ff ff       	call   80084e <strlen>
  80196b:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  80196f:	83 c6 01             	add    $0x1,%esi
  801972:	83 c4 10             	add    $0x10,%esp
  801975:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  80197b:	7f c8                	jg     801945 <spawn+0x163>
	}
	argv_store[argc] = 0;
  80197d:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801983:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801989:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801990:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801996:	0f 85 86 00 00 00    	jne    801a22 <spawn+0x240>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  80199c:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  8019a2:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  8019a8:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  8019ab:	89 c8                	mov    %ecx,%eax
  8019ad:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  8019b3:	89 48 f8             	mov    %ecx,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8019b6:	2d 08 30 80 11       	sub    $0x11803008,%eax
  8019bb:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8019c1:	83 ec 0c             	sub    $0xc,%esp
  8019c4:	6a 07                	push   $0x7
  8019c6:	68 00 d0 bf ee       	push   $0xeebfd000
  8019cb:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8019d1:	68 00 00 40 00       	push   $0x400000
  8019d6:	6a 00                	push   $0x0
  8019d8:	e8 3d f3 ff ff       	call   800d1a <sys_page_map>
  8019dd:	89 c3                	mov    %eax,%ebx
  8019df:	83 c4 20             	add    $0x20,%esp
  8019e2:	85 c0                	test   %eax,%eax
  8019e4:	0f 88 3a 03 00 00    	js     801d24 <spawn+0x542>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8019ea:	83 ec 08             	sub    $0x8,%esp
  8019ed:	68 00 00 40 00       	push   $0x400000
  8019f2:	6a 00                	push   $0x0
  8019f4:	e8 67 f3 ff ff       	call   800d60 <sys_page_unmap>
  8019f9:	89 c3                	mov    %eax,%ebx
  8019fb:	83 c4 10             	add    $0x10,%esp
  8019fe:	85 c0                	test   %eax,%eax
  801a00:	0f 88 1e 03 00 00    	js     801d24 <spawn+0x542>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801a06:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801a0c:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801a13:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  801a1a:	00 00 00 
  801a1d:	e9 4f 01 00 00       	jmp    801b71 <spawn+0x38f>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801a22:	68 c4 30 80 00       	push   $0x8030c4
  801a27:	68 23 30 80 00       	push   $0x803023
  801a2c:	68 f2 00 00 00       	push   $0xf2
  801a31:	68 69 30 80 00       	push   $0x803069
  801a36:	e8 65 e7 ff ff       	call   8001a0 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801a3b:	83 ec 04             	sub    $0x4,%esp
  801a3e:	6a 07                	push   $0x7
  801a40:	68 00 00 40 00       	push   $0x400000
  801a45:	6a 00                	push   $0x0
  801a47:	e8 87 f2 ff ff       	call   800cd3 <sys_page_alloc>
  801a4c:	83 c4 10             	add    $0x10,%esp
  801a4f:	85 c0                	test   %eax,%eax
  801a51:	0f 88 ab 02 00 00    	js     801d02 <spawn+0x520>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801a57:	83 ec 08             	sub    $0x8,%esp
  801a5a:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801a60:	01 f0                	add    %esi,%eax
  801a62:	50                   	push   %eax
  801a63:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801a69:	e8 8e f9 ff ff       	call   8013fc <seek>
  801a6e:	83 c4 10             	add    $0x10,%esp
  801a71:	85 c0                	test   %eax,%eax
  801a73:	0f 88 90 02 00 00    	js     801d09 <spawn+0x527>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801a79:	83 ec 04             	sub    $0x4,%esp
  801a7c:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801a82:	29 f0                	sub    %esi,%eax
  801a84:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a89:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801a8e:	0f 47 c1             	cmova  %ecx,%eax
  801a91:	50                   	push   %eax
  801a92:	68 00 00 40 00       	push   $0x400000
  801a97:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801a9d:	e8 89 f8 ff ff       	call   80132b <readn>
  801aa2:	83 c4 10             	add    $0x10,%esp
  801aa5:	85 c0                	test   %eax,%eax
  801aa7:	0f 88 63 02 00 00    	js     801d10 <spawn+0x52e>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801aad:	83 ec 0c             	sub    $0xc,%esp
  801ab0:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801ab6:	53                   	push   %ebx
  801ab7:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801abd:	68 00 00 40 00       	push   $0x400000
  801ac2:	6a 00                	push   $0x0
  801ac4:	e8 51 f2 ff ff       	call   800d1a <sys_page_map>
  801ac9:	83 c4 20             	add    $0x20,%esp
  801acc:	85 c0                	test   %eax,%eax
  801ace:	78 7c                	js     801b4c <spawn+0x36a>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801ad0:	83 ec 08             	sub    $0x8,%esp
  801ad3:	68 00 00 40 00       	push   $0x400000
  801ad8:	6a 00                	push   $0x0
  801ada:	e8 81 f2 ff ff       	call   800d60 <sys_page_unmap>
  801adf:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801ae2:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801ae8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801aee:	89 fe                	mov    %edi,%esi
  801af0:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801af6:	76 69                	jbe    801b61 <spawn+0x37f>
		if (i >= filesz) {
  801af8:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801afe:	0f 87 37 ff ff ff    	ja     801a3b <spawn+0x259>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801b04:	83 ec 04             	sub    $0x4,%esp
  801b07:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801b0d:	53                   	push   %ebx
  801b0e:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801b14:	e8 ba f1 ff ff       	call   800cd3 <sys_page_alloc>
  801b19:	83 c4 10             	add    $0x10,%esp
  801b1c:	85 c0                	test   %eax,%eax
  801b1e:	79 c2                	jns    801ae2 <spawn+0x300>
  801b20:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801b22:	83 ec 0c             	sub    $0xc,%esp
  801b25:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801b2b:	e8 18 f1 ff ff       	call   800c48 <sys_env_destroy>
	close(fd);
  801b30:	83 c4 04             	add    $0x4,%esp
  801b33:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801b39:	e8 18 f6 ff ff       	call   801156 <close>
	return r;
  801b3e:	83 c4 10             	add    $0x10,%esp
  801b41:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801b47:	e9 a8 01 00 00       	jmp    801cf4 <spawn+0x512>
				panic("spawn: sys_page_map data: %e", r);
  801b4c:	50                   	push   %eax
  801b4d:	68 75 30 80 00       	push   $0x803075
  801b52:	68 25 01 00 00       	push   $0x125
  801b57:	68 69 30 80 00       	push   $0x803069
  801b5c:	e8 3f e6 ff ff       	call   8001a0 <_panic>
  801b61:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801b67:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801b6e:	83 c6 20             	add    $0x20,%esi
  801b71:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801b78:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801b7e:	7e 6d                	jle    801bed <spawn+0x40b>
		if (ph->p_type != ELF_PROG_LOAD)
  801b80:	83 3e 01             	cmpl   $0x1,(%esi)
  801b83:	75 e2                	jne    801b67 <spawn+0x385>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801b85:	8b 46 18             	mov    0x18(%esi),%eax
  801b88:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801b8b:	83 f8 01             	cmp    $0x1,%eax
  801b8e:	19 c0                	sbb    %eax,%eax
  801b90:	83 e0 fe             	and    $0xfffffffe,%eax
  801b93:	83 c0 07             	add    $0x7,%eax
  801b96:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801b9c:	8b 4e 04             	mov    0x4(%esi),%ecx
  801b9f:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801ba5:	8b 56 10             	mov    0x10(%esi),%edx
  801ba8:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801bae:	8b 7e 14             	mov    0x14(%esi),%edi
  801bb1:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  801bb7:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801bba:	89 d8                	mov    %ebx,%eax
  801bbc:	25 ff 0f 00 00       	and    $0xfff,%eax
  801bc1:	74 1a                	je     801bdd <spawn+0x3fb>
		va -= i;
  801bc3:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801bc5:	01 c7                	add    %eax,%edi
  801bc7:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801bcd:	01 c2                	add    %eax,%edx
  801bcf:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  801bd5:	29 c1                	sub    %eax,%ecx
  801bd7:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801bdd:	bf 00 00 00 00       	mov    $0x0,%edi
  801be2:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801be8:	e9 01 ff ff ff       	jmp    801aee <spawn+0x30c>
	close(fd);
  801bed:	83 ec 0c             	sub    $0xc,%esp
  801bf0:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801bf6:	e8 5b f5 ff ff       	call   801156 <close>
  801bfb:	83 c4 10             	add    $0x10,%esp
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	uint32_t addr;
	int r;
	for(addr = 0; addr < USTACKTOP; addr += PGSIZE){
  801bfe:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c03:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  801c09:	eb 0e                	jmp    801c19 <spawn+0x437>
  801c0b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801c11:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801c17:	74 5a                	je     801c73 <spawn+0x491>
		if((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U) && (uvpt[PGNUM(addr)] & PTE_SHARE)){
  801c19:	89 d8                	mov    %ebx,%eax
  801c1b:	c1 e8 16             	shr    $0x16,%eax
  801c1e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801c25:	a8 01                	test   $0x1,%al
  801c27:	74 e2                	je     801c0b <spawn+0x429>
  801c29:	89 d8                	mov    %ebx,%eax
  801c2b:	c1 e8 0c             	shr    $0xc,%eax
  801c2e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801c35:	f6 c2 01             	test   $0x1,%dl
  801c38:	74 d1                	je     801c0b <spawn+0x429>
  801c3a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801c41:	f6 c2 04             	test   $0x4,%dl
  801c44:	74 c5                	je     801c0b <spawn+0x429>
  801c46:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801c4d:	f6 c6 04             	test   $0x4,%dh
  801c50:	74 b9                	je     801c0b <spawn+0x429>
			if(r = sys_page_map(0, (void*)addr, child, (void*)addr, (uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  801c52:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801c59:	83 ec 0c             	sub    $0xc,%esp
  801c5c:	25 07 0e 00 00       	and    $0xe07,%eax
  801c61:	50                   	push   %eax
  801c62:	53                   	push   %ebx
  801c63:	56                   	push   %esi
  801c64:	53                   	push   %ebx
  801c65:	6a 00                	push   $0x0
  801c67:	e8 ae f0 ff ff       	call   800d1a <sys_page_map>
  801c6c:	83 c4 20             	add    $0x20,%esp
  801c6f:	85 c0                	test   %eax,%eax
  801c71:	79 98                	jns    801c0b <spawn+0x429>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801c73:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801c7a:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801c7d:	83 ec 08             	sub    $0x8,%esp
  801c80:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801c86:	50                   	push   %eax
  801c87:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801c8d:	e8 5a f1 ff ff       	call   800dec <sys_env_set_trapframe>
  801c92:	83 c4 10             	add    $0x10,%esp
  801c95:	85 c0                	test   %eax,%eax
  801c97:	78 25                	js     801cbe <spawn+0x4dc>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801c99:	83 ec 08             	sub    $0x8,%esp
  801c9c:	6a 02                	push   $0x2
  801c9e:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801ca4:	e8 fd f0 ff ff       	call   800da6 <sys_env_set_status>
  801ca9:	83 c4 10             	add    $0x10,%esp
  801cac:	85 c0                	test   %eax,%eax
  801cae:	78 23                	js     801cd3 <spawn+0x4f1>
	return child;
  801cb0:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801cb6:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801cbc:	eb 36                	jmp    801cf4 <spawn+0x512>
		panic("sys_env_set_trapframe: %e", r);
  801cbe:	50                   	push   %eax
  801cbf:	68 92 30 80 00       	push   $0x803092
  801cc4:	68 86 00 00 00       	push   $0x86
  801cc9:	68 69 30 80 00       	push   $0x803069
  801cce:	e8 cd e4 ff ff       	call   8001a0 <_panic>
		panic("sys_env_set_status: %e", r);
  801cd3:	50                   	push   %eax
  801cd4:	68 ac 30 80 00       	push   $0x8030ac
  801cd9:	68 89 00 00 00       	push   $0x89
  801cde:	68 69 30 80 00       	push   $0x803069
  801ce3:	e8 b8 e4 ff ff       	call   8001a0 <_panic>
		return r;
  801ce8:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801cee:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  801cf4:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801cfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cfd:	5b                   	pop    %ebx
  801cfe:	5e                   	pop    %esi
  801cff:	5f                   	pop    %edi
  801d00:	5d                   	pop    %ebp
  801d01:	c3                   	ret    
  801d02:	89 c7                	mov    %eax,%edi
  801d04:	e9 19 fe ff ff       	jmp    801b22 <spawn+0x340>
  801d09:	89 c7                	mov    %eax,%edi
  801d0b:	e9 12 fe ff ff       	jmp    801b22 <spawn+0x340>
  801d10:	89 c7                	mov    %eax,%edi
  801d12:	e9 0b fe ff ff       	jmp    801b22 <spawn+0x340>
		return -E_NO_MEM;
  801d17:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(addr = 0; addr < USTACKTOP; addr += PGSIZE){
  801d1c:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801d22:	eb d0                	jmp    801cf4 <spawn+0x512>
	sys_page_unmap(0, UTEMP);
  801d24:	83 ec 08             	sub    $0x8,%esp
  801d27:	68 00 00 40 00       	push   $0x400000
  801d2c:	6a 00                	push   $0x0
  801d2e:	e8 2d f0 ff ff       	call   800d60 <sys_page_unmap>
  801d33:	83 c4 10             	add    $0x10,%esp
  801d36:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801d3c:	eb b6                	jmp    801cf4 <spawn+0x512>

00801d3e <spawnl>:
{
  801d3e:	f3 0f 1e fb          	endbr32 
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
  801d45:	57                   	push   %edi
  801d46:	56                   	push   %esi
  801d47:	53                   	push   %ebx
  801d48:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801d4b:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801d4e:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801d53:	8d 4a 04             	lea    0x4(%edx),%ecx
  801d56:	83 3a 00             	cmpl   $0x0,(%edx)
  801d59:	74 07                	je     801d62 <spawnl+0x24>
		argc++;
  801d5b:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801d5e:	89 ca                	mov    %ecx,%edx
  801d60:	eb f1                	jmp    801d53 <spawnl+0x15>
	const char *argv[argc+2];
  801d62:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  801d69:	89 d1                	mov    %edx,%ecx
  801d6b:	83 e1 f0             	and    $0xfffffff0,%ecx
  801d6e:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801d74:	89 e6                	mov    %esp,%esi
  801d76:	29 d6                	sub    %edx,%esi
  801d78:	89 f2                	mov    %esi,%edx
  801d7a:	39 d4                	cmp    %edx,%esp
  801d7c:	74 10                	je     801d8e <spawnl+0x50>
  801d7e:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  801d84:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  801d8b:	00 
  801d8c:	eb ec                	jmp    801d7a <spawnl+0x3c>
  801d8e:	89 ca                	mov    %ecx,%edx
  801d90:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  801d96:	29 d4                	sub    %edx,%esp
  801d98:	85 d2                	test   %edx,%edx
  801d9a:	74 05                	je     801da1 <spawnl+0x63>
  801d9c:	83 4c 14 fc 00       	orl    $0x0,-0x4(%esp,%edx,1)
  801da1:	8d 74 24 03          	lea    0x3(%esp),%esi
  801da5:	89 f2                	mov    %esi,%edx
  801da7:	c1 ea 02             	shr    $0x2,%edx
  801daa:	83 e6 fc             	and    $0xfffffffc,%esi
  801dad:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801daf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801db2:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801db9:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801dc0:	00 
	va_start(vl, arg0);
  801dc1:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801dc4:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801dc6:	b8 00 00 00 00       	mov    $0x0,%eax
  801dcb:	eb 0b                	jmp    801dd8 <spawnl+0x9a>
		argv[i+1] = va_arg(vl, const char *);
  801dcd:	83 c0 01             	add    $0x1,%eax
  801dd0:	8b 39                	mov    (%ecx),%edi
  801dd2:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801dd5:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801dd8:	39 d0                	cmp    %edx,%eax
  801dda:	75 f1                	jne    801dcd <spawnl+0x8f>
	return spawn(prog, argv);
  801ddc:	83 ec 08             	sub    $0x8,%esp
  801ddf:	56                   	push   %esi
  801de0:	ff 75 08             	pushl  0x8(%ebp)
  801de3:	e8 fa f9 ff ff       	call   8017e2 <spawn>
}
  801de8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801deb:	5b                   	pop    %ebx
  801dec:	5e                   	pop    %esi
  801ded:	5f                   	pop    %edi
  801dee:	5d                   	pop    %ebp
  801def:	c3                   	ret    

00801df0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801df0:	f3 0f 1e fb          	endbr32 
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
  801df7:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801dfa:	68 ea 30 80 00       	push   $0x8030ea
  801dff:	ff 75 0c             	pushl  0xc(%ebp)
  801e02:	e8 8a ea ff ff       	call   800891 <strcpy>
	return 0;
}
  801e07:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0c:	c9                   	leave  
  801e0d:	c3                   	ret    

00801e0e <devsock_close>:
{
  801e0e:	f3 0f 1e fb          	endbr32 
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
  801e15:	53                   	push   %ebx
  801e16:	83 ec 10             	sub    $0x10,%esp
  801e19:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e1c:	53                   	push   %ebx
  801e1d:	e8 9b 0a 00 00       	call   8028bd <pageref>
  801e22:	89 c2                	mov    %eax,%edx
  801e24:	83 c4 10             	add    $0x10,%esp
		return 0;
  801e27:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801e2c:	83 fa 01             	cmp    $0x1,%edx
  801e2f:	74 05                	je     801e36 <devsock_close+0x28>
}
  801e31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e34:	c9                   	leave  
  801e35:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801e36:	83 ec 0c             	sub    $0xc,%esp
  801e39:	ff 73 0c             	pushl  0xc(%ebx)
  801e3c:	e8 e3 02 00 00       	call   802124 <nsipc_close>
  801e41:	83 c4 10             	add    $0x10,%esp
  801e44:	eb eb                	jmp    801e31 <devsock_close+0x23>

00801e46 <devsock_write>:
{
  801e46:	f3 0f 1e fb          	endbr32 
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
  801e4d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e50:	6a 00                	push   $0x0
  801e52:	ff 75 10             	pushl  0x10(%ebp)
  801e55:	ff 75 0c             	pushl  0xc(%ebp)
  801e58:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5b:	ff 70 0c             	pushl  0xc(%eax)
  801e5e:	e8 b5 03 00 00       	call   802218 <nsipc_send>
}
  801e63:	c9                   	leave  
  801e64:	c3                   	ret    

00801e65 <devsock_read>:
{
  801e65:	f3 0f 1e fb          	endbr32 
  801e69:	55                   	push   %ebp
  801e6a:	89 e5                	mov    %esp,%ebp
  801e6c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e6f:	6a 00                	push   $0x0
  801e71:	ff 75 10             	pushl  0x10(%ebp)
  801e74:	ff 75 0c             	pushl  0xc(%ebp)
  801e77:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7a:	ff 70 0c             	pushl  0xc(%eax)
  801e7d:	e8 1f 03 00 00       	call   8021a1 <nsipc_recv>
}
  801e82:	c9                   	leave  
  801e83:	c3                   	ret    

00801e84 <fd2sockid>:
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
  801e87:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801e8a:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e8d:	52                   	push   %edx
  801e8e:	50                   	push   %eax
  801e8f:	e8 84 f1 ff ff       	call   801018 <fd_lookup>
  801e94:	83 c4 10             	add    $0x10,%esp
  801e97:	85 c0                	test   %eax,%eax
  801e99:	78 10                	js     801eab <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9e:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801ea4:	39 08                	cmp    %ecx,(%eax)
  801ea6:	75 05                	jne    801ead <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801ea8:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801eab:	c9                   	leave  
  801eac:	c3                   	ret    
		return -E_NOT_SUPP;
  801ead:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801eb2:	eb f7                	jmp    801eab <fd2sockid+0x27>

00801eb4 <alloc_sockfd>:
{
  801eb4:	55                   	push   %ebp
  801eb5:	89 e5                	mov    %esp,%ebp
  801eb7:	56                   	push   %esi
  801eb8:	53                   	push   %ebx
  801eb9:	83 ec 1c             	sub    $0x1c,%esp
  801ebc:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801ebe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ec1:	50                   	push   %eax
  801ec2:	e8 fb f0 ff ff       	call   800fc2 <fd_alloc>
  801ec7:	89 c3                	mov    %eax,%ebx
  801ec9:	83 c4 10             	add    $0x10,%esp
  801ecc:	85 c0                	test   %eax,%eax
  801ece:	78 43                	js     801f13 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801ed0:	83 ec 04             	sub    $0x4,%esp
  801ed3:	68 07 04 00 00       	push   $0x407
  801ed8:	ff 75 f4             	pushl  -0xc(%ebp)
  801edb:	6a 00                	push   $0x0
  801edd:	e8 f1 ed ff ff       	call   800cd3 <sys_page_alloc>
  801ee2:	89 c3                	mov    %eax,%ebx
  801ee4:	83 c4 10             	add    $0x10,%esp
  801ee7:	85 c0                	test   %eax,%eax
  801ee9:	78 28                	js     801f13 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eee:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801ef4:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801f00:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801f03:	83 ec 0c             	sub    $0xc,%esp
  801f06:	50                   	push   %eax
  801f07:	e8 87 f0 ff ff       	call   800f93 <fd2num>
  801f0c:	89 c3                	mov    %eax,%ebx
  801f0e:	83 c4 10             	add    $0x10,%esp
  801f11:	eb 0c                	jmp    801f1f <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801f13:	83 ec 0c             	sub    $0xc,%esp
  801f16:	56                   	push   %esi
  801f17:	e8 08 02 00 00       	call   802124 <nsipc_close>
		return r;
  801f1c:	83 c4 10             	add    $0x10,%esp
}
  801f1f:	89 d8                	mov    %ebx,%eax
  801f21:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f24:	5b                   	pop    %ebx
  801f25:	5e                   	pop    %esi
  801f26:	5d                   	pop    %ebp
  801f27:	c3                   	ret    

00801f28 <accept>:
{
  801f28:	f3 0f 1e fb          	endbr32 
  801f2c:	55                   	push   %ebp
  801f2d:	89 e5                	mov    %esp,%ebp
  801f2f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f32:	8b 45 08             	mov    0x8(%ebp),%eax
  801f35:	e8 4a ff ff ff       	call   801e84 <fd2sockid>
  801f3a:	85 c0                	test   %eax,%eax
  801f3c:	78 1b                	js     801f59 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f3e:	83 ec 04             	sub    $0x4,%esp
  801f41:	ff 75 10             	pushl  0x10(%ebp)
  801f44:	ff 75 0c             	pushl  0xc(%ebp)
  801f47:	50                   	push   %eax
  801f48:	e8 22 01 00 00       	call   80206f <nsipc_accept>
  801f4d:	83 c4 10             	add    $0x10,%esp
  801f50:	85 c0                	test   %eax,%eax
  801f52:	78 05                	js     801f59 <accept+0x31>
	return alloc_sockfd(r);
  801f54:	e8 5b ff ff ff       	call   801eb4 <alloc_sockfd>
}
  801f59:	c9                   	leave  
  801f5a:	c3                   	ret    

00801f5b <bind>:
{
  801f5b:	f3 0f 1e fb          	endbr32 
  801f5f:	55                   	push   %ebp
  801f60:	89 e5                	mov    %esp,%ebp
  801f62:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f65:	8b 45 08             	mov    0x8(%ebp),%eax
  801f68:	e8 17 ff ff ff       	call   801e84 <fd2sockid>
  801f6d:	85 c0                	test   %eax,%eax
  801f6f:	78 12                	js     801f83 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801f71:	83 ec 04             	sub    $0x4,%esp
  801f74:	ff 75 10             	pushl  0x10(%ebp)
  801f77:	ff 75 0c             	pushl  0xc(%ebp)
  801f7a:	50                   	push   %eax
  801f7b:	e8 45 01 00 00       	call   8020c5 <nsipc_bind>
  801f80:	83 c4 10             	add    $0x10,%esp
}
  801f83:	c9                   	leave  
  801f84:	c3                   	ret    

00801f85 <shutdown>:
{
  801f85:	f3 0f 1e fb          	endbr32 
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
  801f8c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f92:	e8 ed fe ff ff       	call   801e84 <fd2sockid>
  801f97:	85 c0                	test   %eax,%eax
  801f99:	78 0f                	js     801faa <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801f9b:	83 ec 08             	sub    $0x8,%esp
  801f9e:	ff 75 0c             	pushl  0xc(%ebp)
  801fa1:	50                   	push   %eax
  801fa2:	e8 57 01 00 00       	call   8020fe <nsipc_shutdown>
  801fa7:	83 c4 10             	add    $0x10,%esp
}
  801faa:	c9                   	leave  
  801fab:	c3                   	ret    

00801fac <connect>:
{
  801fac:	f3 0f 1e fb          	endbr32 
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
  801fb3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb9:	e8 c6 fe ff ff       	call   801e84 <fd2sockid>
  801fbe:	85 c0                	test   %eax,%eax
  801fc0:	78 12                	js     801fd4 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801fc2:	83 ec 04             	sub    $0x4,%esp
  801fc5:	ff 75 10             	pushl  0x10(%ebp)
  801fc8:	ff 75 0c             	pushl  0xc(%ebp)
  801fcb:	50                   	push   %eax
  801fcc:	e8 71 01 00 00       	call   802142 <nsipc_connect>
  801fd1:	83 c4 10             	add    $0x10,%esp
}
  801fd4:	c9                   	leave  
  801fd5:	c3                   	ret    

00801fd6 <listen>:
{
  801fd6:	f3 0f 1e fb          	endbr32 
  801fda:	55                   	push   %ebp
  801fdb:	89 e5                	mov    %esp,%ebp
  801fdd:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe3:	e8 9c fe ff ff       	call   801e84 <fd2sockid>
  801fe8:	85 c0                	test   %eax,%eax
  801fea:	78 0f                	js     801ffb <listen+0x25>
	return nsipc_listen(r, backlog);
  801fec:	83 ec 08             	sub    $0x8,%esp
  801fef:	ff 75 0c             	pushl  0xc(%ebp)
  801ff2:	50                   	push   %eax
  801ff3:	e8 83 01 00 00       	call   80217b <nsipc_listen>
  801ff8:	83 c4 10             	add    $0x10,%esp
}
  801ffb:	c9                   	leave  
  801ffc:	c3                   	ret    

00801ffd <socket>:

int
socket(int domain, int type, int protocol)
{
  801ffd:	f3 0f 1e fb          	endbr32 
  802001:	55                   	push   %ebp
  802002:	89 e5                	mov    %esp,%ebp
  802004:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802007:	ff 75 10             	pushl  0x10(%ebp)
  80200a:	ff 75 0c             	pushl  0xc(%ebp)
  80200d:	ff 75 08             	pushl  0x8(%ebp)
  802010:	e8 65 02 00 00       	call   80227a <nsipc_socket>
  802015:	83 c4 10             	add    $0x10,%esp
  802018:	85 c0                	test   %eax,%eax
  80201a:	78 05                	js     802021 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  80201c:	e8 93 fe ff ff       	call   801eb4 <alloc_sockfd>
}
  802021:	c9                   	leave  
  802022:	c3                   	ret    

00802023 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
  802026:	53                   	push   %ebx
  802027:	83 ec 04             	sub    $0x4,%esp
  80202a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80202c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802033:	74 26                	je     80205b <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802035:	6a 07                	push   $0x7
  802037:	68 00 70 80 00       	push   $0x807000
  80203c:	53                   	push   %ebx
  80203d:	ff 35 04 50 80 00    	pushl  0x805004
  802043:	e8 e0 07 00 00       	call   802828 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802048:	83 c4 0c             	add    $0xc,%esp
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	e8 4d 07 00 00       	call   8027a3 <ipc_recv>
}
  802056:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802059:	c9                   	leave  
  80205a:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80205b:	83 ec 0c             	sub    $0xc,%esp
  80205e:	6a 02                	push   $0x2
  802060:	e8 1b 08 00 00       	call   802880 <ipc_find_env>
  802065:	a3 04 50 80 00       	mov    %eax,0x805004
  80206a:	83 c4 10             	add    $0x10,%esp
  80206d:	eb c6                	jmp    802035 <nsipc+0x12>

0080206f <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80206f:	f3 0f 1e fb          	endbr32 
  802073:	55                   	push   %ebp
  802074:	89 e5                	mov    %esp,%ebp
  802076:	56                   	push   %esi
  802077:	53                   	push   %ebx
  802078:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80207b:	8b 45 08             	mov    0x8(%ebp),%eax
  80207e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802083:	8b 06                	mov    (%esi),%eax
  802085:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80208a:	b8 01 00 00 00       	mov    $0x1,%eax
  80208f:	e8 8f ff ff ff       	call   802023 <nsipc>
  802094:	89 c3                	mov    %eax,%ebx
  802096:	85 c0                	test   %eax,%eax
  802098:	79 09                	jns    8020a3 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80209a:	89 d8                	mov    %ebx,%eax
  80209c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80209f:	5b                   	pop    %ebx
  8020a0:	5e                   	pop    %esi
  8020a1:	5d                   	pop    %ebp
  8020a2:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8020a3:	83 ec 04             	sub    $0x4,%esp
  8020a6:	ff 35 10 70 80 00    	pushl  0x807010
  8020ac:	68 00 70 80 00       	push   $0x807000
  8020b1:	ff 75 0c             	pushl  0xc(%ebp)
  8020b4:	e8 8e e9 ff ff       	call   800a47 <memmove>
		*addrlen = ret->ret_addrlen;
  8020b9:	a1 10 70 80 00       	mov    0x807010,%eax
  8020be:	89 06                	mov    %eax,(%esi)
  8020c0:	83 c4 10             	add    $0x10,%esp
	return r;
  8020c3:	eb d5                	jmp    80209a <nsipc_accept+0x2b>

008020c5 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8020c5:	f3 0f 1e fb          	endbr32 
  8020c9:	55                   	push   %ebp
  8020ca:	89 e5                	mov    %esp,%ebp
  8020cc:	53                   	push   %ebx
  8020cd:	83 ec 08             	sub    $0x8,%esp
  8020d0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8020d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d6:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8020db:	53                   	push   %ebx
  8020dc:	ff 75 0c             	pushl  0xc(%ebp)
  8020df:	68 04 70 80 00       	push   $0x807004
  8020e4:	e8 5e e9 ff ff       	call   800a47 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8020e9:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8020ef:	b8 02 00 00 00       	mov    $0x2,%eax
  8020f4:	e8 2a ff ff ff       	call   802023 <nsipc>
}
  8020f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020fc:	c9                   	leave  
  8020fd:	c3                   	ret    

008020fe <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8020fe:	f3 0f 1e fb          	endbr32 
  802102:	55                   	push   %ebp
  802103:	89 e5                	mov    %esp,%ebp
  802105:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802108:	8b 45 08             	mov    0x8(%ebp),%eax
  80210b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802110:	8b 45 0c             	mov    0xc(%ebp),%eax
  802113:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802118:	b8 03 00 00 00       	mov    $0x3,%eax
  80211d:	e8 01 ff ff ff       	call   802023 <nsipc>
}
  802122:	c9                   	leave  
  802123:	c3                   	ret    

00802124 <nsipc_close>:

int
nsipc_close(int s)
{
  802124:	f3 0f 1e fb          	endbr32 
  802128:	55                   	push   %ebp
  802129:	89 e5                	mov    %esp,%ebp
  80212b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80212e:	8b 45 08             	mov    0x8(%ebp),%eax
  802131:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802136:	b8 04 00 00 00       	mov    $0x4,%eax
  80213b:	e8 e3 fe ff ff       	call   802023 <nsipc>
}
  802140:	c9                   	leave  
  802141:	c3                   	ret    

00802142 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802142:	f3 0f 1e fb          	endbr32 
  802146:	55                   	push   %ebp
  802147:	89 e5                	mov    %esp,%ebp
  802149:	53                   	push   %ebx
  80214a:	83 ec 08             	sub    $0x8,%esp
  80214d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802150:	8b 45 08             	mov    0x8(%ebp),%eax
  802153:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802158:	53                   	push   %ebx
  802159:	ff 75 0c             	pushl  0xc(%ebp)
  80215c:	68 04 70 80 00       	push   $0x807004
  802161:	e8 e1 e8 ff ff       	call   800a47 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802166:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  80216c:	b8 05 00 00 00       	mov    $0x5,%eax
  802171:	e8 ad fe ff ff       	call   802023 <nsipc>
}
  802176:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802179:	c9                   	leave  
  80217a:	c3                   	ret    

0080217b <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80217b:	f3 0f 1e fb          	endbr32 
  80217f:	55                   	push   %ebp
  802180:	89 e5                	mov    %esp,%ebp
  802182:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802185:	8b 45 08             	mov    0x8(%ebp),%eax
  802188:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80218d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802190:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802195:	b8 06 00 00 00       	mov    $0x6,%eax
  80219a:	e8 84 fe ff ff       	call   802023 <nsipc>
}
  80219f:	c9                   	leave  
  8021a0:	c3                   	ret    

008021a1 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8021a1:	f3 0f 1e fb          	endbr32 
  8021a5:	55                   	push   %ebp
  8021a6:	89 e5                	mov    %esp,%ebp
  8021a8:	56                   	push   %esi
  8021a9:	53                   	push   %ebx
  8021aa:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8021ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b0:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8021b5:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8021bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8021be:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8021c3:	b8 07 00 00 00       	mov    $0x7,%eax
  8021c8:	e8 56 fe ff ff       	call   802023 <nsipc>
  8021cd:	89 c3                	mov    %eax,%ebx
  8021cf:	85 c0                	test   %eax,%eax
  8021d1:	78 26                	js     8021f9 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  8021d3:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  8021d9:	b8 3f 06 00 00       	mov    $0x63f,%eax
  8021de:	0f 4e c6             	cmovle %esi,%eax
  8021e1:	39 c3                	cmp    %eax,%ebx
  8021e3:	7f 1d                	jg     802202 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8021e5:	83 ec 04             	sub    $0x4,%esp
  8021e8:	53                   	push   %ebx
  8021e9:	68 00 70 80 00       	push   $0x807000
  8021ee:	ff 75 0c             	pushl  0xc(%ebp)
  8021f1:	e8 51 e8 ff ff       	call   800a47 <memmove>
  8021f6:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8021f9:	89 d8                	mov    %ebx,%eax
  8021fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021fe:	5b                   	pop    %ebx
  8021ff:	5e                   	pop    %esi
  802200:	5d                   	pop    %ebp
  802201:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802202:	68 f6 30 80 00       	push   $0x8030f6
  802207:	68 23 30 80 00       	push   $0x803023
  80220c:	6a 62                	push   $0x62
  80220e:	68 0b 31 80 00       	push   $0x80310b
  802213:	e8 88 df ff ff       	call   8001a0 <_panic>

00802218 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802218:	f3 0f 1e fb          	endbr32 
  80221c:	55                   	push   %ebp
  80221d:	89 e5                	mov    %esp,%ebp
  80221f:	53                   	push   %ebx
  802220:	83 ec 04             	sub    $0x4,%esp
  802223:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802226:	8b 45 08             	mov    0x8(%ebp),%eax
  802229:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80222e:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802234:	7f 2e                	jg     802264 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802236:	83 ec 04             	sub    $0x4,%esp
  802239:	53                   	push   %ebx
  80223a:	ff 75 0c             	pushl  0xc(%ebp)
  80223d:	68 0c 70 80 00       	push   $0x80700c
  802242:	e8 00 e8 ff ff       	call   800a47 <memmove>
	nsipcbuf.send.req_size = size;
  802247:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80224d:	8b 45 14             	mov    0x14(%ebp),%eax
  802250:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802255:	b8 08 00 00 00       	mov    $0x8,%eax
  80225a:	e8 c4 fd ff ff       	call   802023 <nsipc>
}
  80225f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802262:	c9                   	leave  
  802263:	c3                   	ret    
	assert(size < 1600);
  802264:	68 17 31 80 00       	push   $0x803117
  802269:	68 23 30 80 00       	push   $0x803023
  80226e:	6a 6d                	push   $0x6d
  802270:	68 0b 31 80 00       	push   $0x80310b
  802275:	e8 26 df ff ff       	call   8001a0 <_panic>

0080227a <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80227a:	f3 0f 1e fb          	endbr32 
  80227e:	55                   	push   %ebp
  80227f:	89 e5                	mov    %esp,%ebp
  802281:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802284:	8b 45 08             	mov    0x8(%ebp),%eax
  802287:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80228c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80228f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802294:	8b 45 10             	mov    0x10(%ebp),%eax
  802297:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80229c:	b8 09 00 00 00       	mov    $0x9,%eax
  8022a1:	e8 7d fd ff ff       	call   802023 <nsipc>
}
  8022a6:	c9                   	leave  
  8022a7:	c3                   	ret    

008022a8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8022a8:	f3 0f 1e fb          	endbr32 
  8022ac:	55                   	push   %ebp
  8022ad:	89 e5                	mov    %esp,%ebp
  8022af:	56                   	push   %esi
  8022b0:	53                   	push   %ebx
  8022b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8022b4:	83 ec 0c             	sub    $0xc,%esp
  8022b7:	ff 75 08             	pushl  0x8(%ebp)
  8022ba:	e8 e8 ec ff ff       	call   800fa7 <fd2data>
  8022bf:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8022c1:	83 c4 08             	add    $0x8,%esp
  8022c4:	68 23 31 80 00       	push   $0x803123
  8022c9:	53                   	push   %ebx
  8022ca:	e8 c2 e5 ff ff       	call   800891 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8022cf:	8b 46 04             	mov    0x4(%esi),%eax
  8022d2:	2b 06                	sub    (%esi),%eax
  8022d4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8022da:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8022e1:	00 00 00 
	stat->st_dev = &devpipe;
  8022e4:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8022eb:	40 80 00 
	return 0;
}
  8022ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022f6:	5b                   	pop    %ebx
  8022f7:	5e                   	pop    %esi
  8022f8:	5d                   	pop    %ebp
  8022f9:	c3                   	ret    

008022fa <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8022fa:	f3 0f 1e fb          	endbr32 
  8022fe:	55                   	push   %ebp
  8022ff:	89 e5                	mov    %esp,%ebp
  802301:	53                   	push   %ebx
  802302:	83 ec 0c             	sub    $0xc,%esp
  802305:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802308:	53                   	push   %ebx
  802309:	6a 00                	push   $0x0
  80230b:	e8 50 ea ff ff       	call   800d60 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802310:	89 1c 24             	mov    %ebx,(%esp)
  802313:	e8 8f ec ff ff       	call   800fa7 <fd2data>
  802318:	83 c4 08             	add    $0x8,%esp
  80231b:	50                   	push   %eax
  80231c:	6a 00                	push   $0x0
  80231e:	e8 3d ea ff ff       	call   800d60 <sys_page_unmap>
}
  802323:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802326:	c9                   	leave  
  802327:	c3                   	ret    

00802328 <_pipeisclosed>:
{
  802328:	55                   	push   %ebp
  802329:	89 e5                	mov    %esp,%ebp
  80232b:	57                   	push   %edi
  80232c:	56                   	push   %esi
  80232d:	53                   	push   %ebx
  80232e:	83 ec 1c             	sub    $0x1c,%esp
  802331:	89 c7                	mov    %eax,%edi
  802333:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802335:	a1 08 50 80 00       	mov    0x805008,%eax
  80233a:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80233d:	83 ec 0c             	sub    $0xc,%esp
  802340:	57                   	push   %edi
  802341:	e8 77 05 00 00       	call   8028bd <pageref>
  802346:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802349:	89 34 24             	mov    %esi,(%esp)
  80234c:	e8 6c 05 00 00       	call   8028bd <pageref>
		nn = thisenv->env_runs;
  802351:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802357:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80235a:	83 c4 10             	add    $0x10,%esp
  80235d:	39 cb                	cmp    %ecx,%ebx
  80235f:	74 1b                	je     80237c <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802361:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802364:	75 cf                	jne    802335 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802366:	8b 42 58             	mov    0x58(%edx),%eax
  802369:	6a 01                	push   $0x1
  80236b:	50                   	push   %eax
  80236c:	53                   	push   %ebx
  80236d:	68 2a 31 80 00       	push   $0x80312a
  802372:	e8 10 df ff ff       	call   800287 <cprintf>
  802377:	83 c4 10             	add    $0x10,%esp
  80237a:	eb b9                	jmp    802335 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80237c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80237f:	0f 94 c0             	sete   %al
  802382:	0f b6 c0             	movzbl %al,%eax
}
  802385:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802388:	5b                   	pop    %ebx
  802389:	5e                   	pop    %esi
  80238a:	5f                   	pop    %edi
  80238b:	5d                   	pop    %ebp
  80238c:	c3                   	ret    

0080238d <devpipe_write>:
{
  80238d:	f3 0f 1e fb          	endbr32 
  802391:	55                   	push   %ebp
  802392:	89 e5                	mov    %esp,%ebp
  802394:	57                   	push   %edi
  802395:	56                   	push   %esi
  802396:	53                   	push   %ebx
  802397:	83 ec 28             	sub    $0x28,%esp
  80239a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80239d:	56                   	push   %esi
  80239e:	e8 04 ec ff ff       	call   800fa7 <fd2data>
  8023a3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8023a5:	83 c4 10             	add    $0x10,%esp
  8023a8:	bf 00 00 00 00       	mov    $0x0,%edi
  8023ad:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8023b0:	74 4f                	je     802401 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8023b2:	8b 43 04             	mov    0x4(%ebx),%eax
  8023b5:	8b 0b                	mov    (%ebx),%ecx
  8023b7:	8d 51 20             	lea    0x20(%ecx),%edx
  8023ba:	39 d0                	cmp    %edx,%eax
  8023bc:	72 14                	jb     8023d2 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8023be:	89 da                	mov    %ebx,%edx
  8023c0:	89 f0                	mov    %esi,%eax
  8023c2:	e8 61 ff ff ff       	call   802328 <_pipeisclosed>
  8023c7:	85 c0                	test   %eax,%eax
  8023c9:	75 3b                	jne    802406 <devpipe_write+0x79>
			sys_yield();
  8023cb:	e8 e0 e8 ff ff       	call   800cb0 <sys_yield>
  8023d0:	eb e0                	jmp    8023b2 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8023d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023d5:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8023d9:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8023dc:	89 c2                	mov    %eax,%edx
  8023de:	c1 fa 1f             	sar    $0x1f,%edx
  8023e1:	89 d1                	mov    %edx,%ecx
  8023e3:	c1 e9 1b             	shr    $0x1b,%ecx
  8023e6:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8023e9:	83 e2 1f             	and    $0x1f,%edx
  8023ec:	29 ca                	sub    %ecx,%edx
  8023ee:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8023f2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8023f6:	83 c0 01             	add    $0x1,%eax
  8023f9:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8023fc:	83 c7 01             	add    $0x1,%edi
  8023ff:	eb ac                	jmp    8023ad <devpipe_write+0x20>
	return i;
  802401:	8b 45 10             	mov    0x10(%ebp),%eax
  802404:	eb 05                	jmp    80240b <devpipe_write+0x7e>
				return 0;
  802406:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80240b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80240e:	5b                   	pop    %ebx
  80240f:	5e                   	pop    %esi
  802410:	5f                   	pop    %edi
  802411:	5d                   	pop    %ebp
  802412:	c3                   	ret    

00802413 <devpipe_read>:
{
  802413:	f3 0f 1e fb          	endbr32 
  802417:	55                   	push   %ebp
  802418:	89 e5                	mov    %esp,%ebp
  80241a:	57                   	push   %edi
  80241b:	56                   	push   %esi
  80241c:	53                   	push   %ebx
  80241d:	83 ec 18             	sub    $0x18,%esp
  802420:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802423:	57                   	push   %edi
  802424:	e8 7e eb ff ff       	call   800fa7 <fd2data>
  802429:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80242b:	83 c4 10             	add    $0x10,%esp
  80242e:	be 00 00 00 00       	mov    $0x0,%esi
  802433:	3b 75 10             	cmp    0x10(%ebp),%esi
  802436:	75 14                	jne    80244c <devpipe_read+0x39>
	return i;
  802438:	8b 45 10             	mov    0x10(%ebp),%eax
  80243b:	eb 02                	jmp    80243f <devpipe_read+0x2c>
				return i;
  80243d:	89 f0                	mov    %esi,%eax
}
  80243f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802442:	5b                   	pop    %ebx
  802443:	5e                   	pop    %esi
  802444:	5f                   	pop    %edi
  802445:	5d                   	pop    %ebp
  802446:	c3                   	ret    
			sys_yield();
  802447:	e8 64 e8 ff ff       	call   800cb0 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80244c:	8b 03                	mov    (%ebx),%eax
  80244e:	3b 43 04             	cmp    0x4(%ebx),%eax
  802451:	75 18                	jne    80246b <devpipe_read+0x58>
			if (i > 0)
  802453:	85 f6                	test   %esi,%esi
  802455:	75 e6                	jne    80243d <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  802457:	89 da                	mov    %ebx,%edx
  802459:	89 f8                	mov    %edi,%eax
  80245b:	e8 c8 fe ff ff       	call   802328 <_pipeisclosed>
  802460:	85 c0                	test   %eax,%eax
  802462:	74 e3                	je     802447 <devpipe_read+0x34>
				return 0;
  802464:	b8 00 00 00 00       	mov    $0x0,%eax
  802469:	eb d4                	jmp    80243f <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80246b:	99                   	cltd   
  80246c:	c1 ea 1b             	shr    $0x1b,%edx
  80246f:	01 d0                	add    %edx,%eax
  802471:	83 e0 1f             	and    $0x1f,%eax
  802474:	29 d0                	sub    %edx,%eax
  802476:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80247b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80247e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802481:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802484:	83 c6 01             	add    $0x1,%esi
  802487:	eb aa                	jmp    802433 <devpipe_read+0x20>

00802489 <pipe>:
{
  802489:	f3 0f 1e fb          	endbr32 
  80248d:	55                   	push   %ebp
  80248e:	89 e5                	mov    %esp,%ebp
  802490:	56                   	push   %esi
  802491:	53                   	push   %ebx
  802492:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802495:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802498:	50                   	push   %eax
  802499:	e8 24 eb ff ff       	call   800fc2 <fd_alloc>
  80249e:	89 c3                	mov    %eax,%ebx
  8024a0:	83 c4 10             	add    $0x10,%esp
  8024a3:	85 c0                	test   %eax,%eax
  8024a5:	0f 88 23 01 00 00    	js     8025ce <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024ab:	83 ec 04             	sub    $0x4,%esp
  8024ae:	68 07 04 00 00       	push   $0x407
  8024b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8024b6:	6a 00                	push   $0x0
  8024b8:	e8 16 e8 ff ff       	call   800cd3 <sys_page_alloc>
  8024bd:	89 c3                	mov    %eax,%ebx
  8024bf:	83 c4 10             	add    $0x10,%esp
  8024c2:	85 c0                	test   %eax,%eax
  8024c4:	0f 88 04 01 00 00    	js     8025ce <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  8024ca:	83 ec 0c             	sub    $0xc,%esp
  8024cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8024d0:	50                   	push   %eax
  8024d1:	e8 ec ea ff ff       	call   800fc2 <fd_alloc>
  8024d6:	89 c3                	mov    %eax,%ebx
  8024d8:	83 c4 10             	add    $0x10,%esp
  8024db:	85 c0                	test   %eax,%eax
  8024dd:	0f 88 db 00 00 00    	js     8025be <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024e3:	83 ec 04             	sub    $0x4,%esp
  8024e6:	68 07 04 00 00       	push   $0x407
  8024eb:	ff 75 f0             	pushl  -0x10(%ebp)
  8024ee:	6a 00                	push   $0x0
  8024f0:	e8 de e7 ff ff       	call   800cd3 <sys_page_alloc>
  8024f5:	89 c3                	mov    %eax,%ebx
  8024f7:	83 c4 10             	add    $0x10,%esp
  8024fa:	85 c0                	test   %eax,%eax
  8024fc:	0f 88 bc 00 00 00    	js     8025be <pipe+0x135>
	va = fd2data(fd0);
  802502:	83 ec 0c             	sub    $0xc,%esp
  802505:	ff 75 f4             	pushl  -0xc(%ebp)
  802508:	e8 9a ea ff ff       	call   800fa7 <fd2data>
  80250d:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80250f:	83 c4 0c             	add    $0xc,%esp
  802512:	68 07 04 00 00       	push   $0x407
  802517:	50                   	push   %eax
  802518:	6a 00                	push   $0x0
  80251a:	e8 b4 e7 ff ff       	call   800cd3 <sys_page_alloc>
  80251f:	89 c3                	mov    %eax,%ebx
  802521:	83 c4 10             	add    $0x10,%esp
  802524:	85 c0                	test   %eax,%eax
  802526:	0f 88 82 00 00 00    	js     8025ae <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80252c:	83 ec 0c             	sub    $0xc,%esp
  80252f:	ff 75 f0             	pushl  -0x10(%ebp)
  802532:	e8 70 ea ff ff       	call   800fa7 <fd2data>
  802537:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80253e:	50                   	push   %eax
  80253f:	6a 00                	push   $0x0
  802541:	56                   	push   %esi
  802542:	6a 00                	push   $0x0
  802544:	e8 d1 e7 ff ff       	call   800d1a <sys_page_map>
  802549:	89 c3                	mov    %eax,%ebx
  80254b:	83 c4 20             	add    $0x20,%esp
  80254e:	85 c0                	test   %eax,%eax
  802550:	78 4e                	js     8025a0 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  802552:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802557:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80255a:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80255c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80255f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802566:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802569:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80256b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80256e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802575:	83 ec 0c             	sub    $0xc,%esp
  802578:	ff 75 f4             	pushl  -0xc(%ebp)
  80257b:	e8 13 ea ff ff       	call   800f93 <fd2num>
  802580:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802583:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802585:	83 c4 04             	add    $0x4,%esp
  802588:	ff 75 f0             	pushl  -0x10(%ebp)
  80258b:	e8 03 ea ff ff       	call   800f93 <fd2num>
  802590:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802593:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802596:	83 c4 10             	add    $0x10,%esp
  802599:	bb 00 00 00 00       	mov    $0x0,%ebx
  80259e:	eb 2e                	jmp    8025ce <pipe+0x145>
	sys_page_unmap(0, va);
  8025a0:	83 ec 08             	sub    $0x8,%esp
  8025a3:	56                   	push   %esi
  8025a4:	6a 00                	push   $0x0
  8025a6:	e8 b5 e7 ff ff       	call   800d60 <sys_page_unmap>
  8025ab:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8025ae:	83 ec 08             	sub    $0x8,%esp
  8025b1:	ff 75 f0             	pushl  -0x10(%ebp)
  8025b4:	6a 00                	push   $0x0
  8025b6:	e8 a5 e7 ff ff       	call   800d60 <sys_page_unmap>
  8025bb:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8025be:	83 ec 08             	sub    $0x8,%esp
  8025c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8025c4:	6a 00                	push   $0x0
  8025c6:	e8 95 e7 ff ff       	call   800d60 <sys_page_unmap>
  8025cb:	83 c4 10             	add    $0x10,%esp
}
  8025ce:	89 d8                	mov    %ebx,%eax
  8025d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025d3:	5b                   	pop    %ebx
  8025d4:	5e                   	pop    %esi
  8025d5:	5d                   	pop    %ebp
  8025d6:	c3                   	ret    

008025d7 <pipeisclosed>:
{
  8025d7:	f3 0f 1e fb          	endbr32 
  8025db:	55                   	push   %ebp
  8025dc:	89 e5                	mov    %esp,%ebp
  8025de:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025e4:	50                   	push   %eax
  8025e5:	ff 75 08             	pushl  0x8(%ebp)
  8025e8:	e8 2b ea ff ff       	call   801018 <fd_lookup>
  8025ed:	83 c4 10             	add    $0x10,%esp
  8025f0:	85 c0                	test   %eax,%eax
  8025f2:	78 18                	js     80260c <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  8025f4:	83 ec 0c             	sub    $0xc,%esp
  8025f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8025fa:	e8 a8 e9 ff ff       	call   800fa7 <fd2data>
  8025ff:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802604:	e8 1f fd ff ff       	call   802328 <_pipeisclosed>
  802609:	83 c4 10             	add    $0x10,%esp
}
  80260c:	c9                   	leave  
  80260d:	c3                   	ret    

0080260e <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80260e:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  802612:	b8 00 00 00 00       	mov    $0x0,%eax
  802617:	c3                   	ret    

00802618 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802618:	f3 0f 1e fb          	endbr32 
  80261c:	55                   	push   %ebp
  80261d:	89 e5                	mov    %esp,%ebp
  80261f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802622:	68 42 31 80 00       	push   $0x803142
  802627:	ff 75 0c             	pushl  0xc(%ebp)
  80262a:	e8 62 e2 ff ff       	call   800891 <strcpy>
	return 0;
}
  80262f:	b8 00 00 00 00       	mov    $0x0,%eax
  802634:	c9                   	leave  
  802635:	c3                   	ret    

00802636 <devcons_write>:
{
  802636:	f3 0f 1e fb          	endbr32 
  80263a:	55                   	push   %ebp
  80263b:	89 e5                	mov    %esp,%ebp
  80263d:	57                   	push   %edi
  80263e:	56                   	push   %esi
  80263f:	53                   	push   %ebx
  802640:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802646:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80264b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802651:	3b 75 10             	cmp    0x10(%ebp),%esi
  802654:	73 31                	jae    802687 <devcons_write+0x51>
		m = n - tot;
  802656:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802659:	29 f3                	sub    %esi,%ebx
  80265b:	83 fb 7f             	cmp    $0x7f,%ebx
  80265e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802663:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802666:	83 ec 04             	sub    $0x4,%esp
  802669:	53                   	push   %ebx
  80266a:	89 f0                	mov    %esi,%eax
  80266c:	03 45 0c             	add    0xc(%ebp),%eax
  80266f:	50                   	push   %eax
  802670:	57                   	push   %edi
  802671:	e8 d1 e3 ff ff       	call   800a47 <memmove>
		sys_cputs(buf, m);
  802676:	83 c4 08             	add    $0x8,%esp
  802679:	53                   	push   %ebx
  80267a:	57                   	push   %edi
  80267b:	e8 83 e5 ff ff       	call   800c03 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802680:	01 de                	add    %ebx,%esi
  802682:	83 c4 10             	add    $0x10,%esp
  802685:	eb ca                	jmp    802651 <devcons_write+0x1b>
}
  802687:	89 f0                	mov    %esi,%eax
  802689:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80268c:	5b                   	pop    %ebx
  80268d:	5e                   	pop    %esi
  80268e:	5f                   	pop    %edi
  80268f:	5d                   	pop    %ebp
  802690:	c3                   	ret    

00802691 <devcons_read>:
{
  802691:	f3 0f 1e fb          	endbr32 
  802695:	55                   	push   %ebp
  802696:	89 e5                	mov    %esp,%ebp
  802698:	83 ec 08             	sub    $0x8,%esp
  80269b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8026a0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8026a4:	74 21                	je     8026c7 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8026a6:	e8 7a e5 ff ff       	call   800c25 <sys_cgetc>
  8026ab:	85 c0                	test   %eax,%eax
  8026ad:	75 07                	jne    8026b6 <devcons_read+0x25>
		sys_yield();
  8026af:	e8 fc e5 ff ff       	call   800cb0 <sys_yield>
  8026b4:	eb f0                	jmp    8026a6 <devcons_read+0x15>
	if (c < 0)
  8026b6:	78 0f                	js     8026c7 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8026b8:	83 f8 04             	cmp    $0x4,%eax
  8026bb:	74 0c                	je     8026c9 <devcons_read+0x38>
	*(char*)vbuf = c;
  8026bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026c0:	88 02                	mov    %al,(%edx)
	return 1;
  8026c2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8026c7:	c9                   	leave  
  8026c8:	c3                   	ret    
		return 0;
  8026c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ce:	eb f7                	jmp    8026c7 <devcons_read+0x36>

008026d0 <cputchar>:
{
  8026d0:	f3 0f 1e fb          	endbr32 
  8026d4:	55                   	push   %ebp
  8026d5:	89 e5                	mov    %esp,%ebp
  8026d7:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8026da:	8b 45 08             	mov    0x8(%ebp),%eax
  8026dd:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8026e0:	6a 01                	push   $0x1
  8026e2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026e5:	50                   	push   %eax
  8026e6:	e8 18 e5 ff ff       	call   800c03 <sys_cputs>
}
  8026eb:	83 c4 10             	add    $0x10,%esp
  8026ee:	c9                   	leave  
  8026ef:	c3                   	ret    

008026f0 <getchar>:
{
  8026f0:	f3 0f 1e fb          	endbr32 
  8026f4:	55                   	push   %ebp
  8026f5:	89 e5                	mov    %esp,%ebp
  8026f7:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8026fa:	6a 01                	push   $0x1
  8026fc:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026ff:	50                   	push   %eax
  802700:	6a 00                	push   $0x0
  802702:	e8 99 eb ff ff       	call   8012a0 <read>
	if (r < 0)
  802707:	83 c4 10             	add    $0x10,%esp
  80270a:	85 c0                	test   %eax,%eax
  80270c:	78 06                	js     802714 <getchar+0x24>
	if (r < 1)
  80270e:	74 06                	je     802716 <getchar+0x26>
	return c;
  802710:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802714:	c9                   	leave  
  802715:	c3                   	ret    
		return -E_EOF;
  802716:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80271b:	eb f7                	jmp    802714 <getchar+0x24>

0080271d <iscons>:
{
  80271d:	f3 0f 1e fb          	endbr32 
  802721:	55                   	push   %ebp
  802722:	89 e5                	mov    %esp,%ebp
  802724:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802727:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80272a:	50                   	push   %eax
  80272b:	ff 75 08             	pushl  0x8(%ebp)
  80272e:	e8 e5 e8 ff ff       	call   801018 <fd_lookup>
  802733:	83 c4 10             	add    $0x10,%esp
  802736:	85 c0                	test   %eax,%eax
  802738:	78 11                	js     80274b <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80273a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273d:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802743:	39 10                	cmp    %edx,(%eax)
  802745:	0f 94 c0             	sete   %al
  802748:	0f b6 c0             	movzbl %al,%eax
}
  80274b:	c9                   	leave  
  80274c:	c3                   	ret    

0080274d <opencons>:
{
  80274d:	f3 0f 1e fb          	endbr32 
  802751:	55                   	push   %ebp
  802752:	89 e5                	mov    %esp,%ebp
  802754:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802757:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80275a:	50                   	push   %eax
  80275b:	e8 62 e8 ff ff       	call   800fc2 <fd_alloc>
  802760:	83 c4 10             	add    $0x10,%esp
  802763:	85 c0                	test   %eax,%eax
  802765:	78 3a                	js     8027a1 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802767:	83 ec 04             	sub    $0x4,%esp
  80276a:	68 07 04 00 00       	push   $0x407
  80276f:	ff 75 f4             	pushl  -0xc(%ebp)
  802772:	6a 00                	push   $0x0
  802774:	e8 5a e5 ff ff       	call   800cd3 <sys_page_alloc>
  802779:	83 c4 10             	add    $0x10,%esp
  80277c:	85 c0                	test   %eax,%eax
  80277e:	78 21                	js     8027a1 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802783:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802789:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80278b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802795:	83 ec 0c             	sub    $0xc,%esp
  802798:	50                   	push   %eax
  802799:	e8 f5 e7 ff ff       	call   800f93 <fd2num>
  80279e:	83 c4 10             	add    $0x10,%esp
}
  8027a1:	c9                   	leave  
  8027a2:	c3                   	ret    

008027a3 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8027a3:	f3 0f 1e fb          	endbr32 
  8027a7:	55                   	push   %ebp
  8027a8:	89 e5                	mov    %esp,%ebp
  8027aa:	56                   	push   %esi
  8027ab:	53                   	push   %ebx
  8027ac:	8b 75 08             	mov    0x8(%ebp),%esi
  8027af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027b2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  8027b5:	85 c0                	test   %eax,%eax
  8027b7:	74 3d                	je     8027f6 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  8027b9:	83 ec 0c             	sub    $0xc,%esp
  8027bc:	50                   	push   %eax
  8027bd:	e8 dd e6 ff ff       	call   800e9f <sys_ipc_recv>
  8027c2:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  8027c5:	85 f6                	test   %esi,%esi
  8027c7:	74 0b                	je     8027d4 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8027c9:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8027cf:	8b 52 74             	mov    0x74(%edx),%edx
  8027d2:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  8027d4:	85 db                	test   %ebx,%ebx
  8027d6:	74 0b                	je     8027e3 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  8027d8:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8027de:	8b 52 78             	mov    0x78(%edx),%edx
  8027e1:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  8027e3:	85 c0                	test   %eax,%eax
  8027e5:	78 21                	js     802808 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  8027e7:	a1 08 50 80 00       	mov    0x805008,%eax
  8027ec:	8b 40 70             	mov    0x70(%eax),%eax
}
  8027ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027f2:	5b                   	pop    %ebx
  8027f3:	5e                   	pop    %esi
  8027f4:	5d                   	pop    %ebp
  8027f5:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  8027f6:	83 ec 0c             	sub    $0xc,%esp
  8027f9:	68 00 00 c0 ee       	push   $0xeec00000
  8027fe:	e8 9c e6 ff ff       	call   800e9f <sys_ipc_recv>
  802803:	83 c4 10             	add    $0x10,%esp
  802806:	eb bd                	jmp    8027c5 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  802808:	85 f6                	test   %esi,%esi
  80280a:	74 10                	je     80281c <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  80280c:	85 db                	test   %ebx,%ebx
  80280e:	75 df                	jne    8027ef <ipc_recv+0x4c>
  802810:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802817:	00 00 00 
  80281a:	eb d3                	jmp    8027ef <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  80281c:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802823:	00 00 00 
  802826:	eb e4                	jmp    80280c <ipc_recv+0x69>

00802828 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802828:	f3 0f 1e fb          	endbr32 
  80282c:	55                   	push   %ebp
  80282d:	89 e5                	mov    %esp,%ebp
  80282f:	57                   	push   %edi
  802830:	56                   	push   %esi
  802831:	53                   	push   %ebx
  802832:	83 ec 0c             	sub    $0xc,%esp
  802835:	8b 7d 08             	mov    0x8(%ebp),%edi
  802838:	8b 75 0c             	mov    0xc(%ebp),%esi
  80283b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  80283e:	85 db                	test   %ebx,%ebx
  802840:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802845:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  802848:	ff 75 14             	pushl  0x14(%ebp)
  80284b:	53                   	push   %ebx
  80284c:	56                   	push   %esi
  80284d:	57                   	push   %edi
  80284e:	e8 25 e6 ff ff       	call   800e78 <sys_ipc_try_send>
  802853:	83 c4 10             	add    $0x10,%esp
  802856:	85 c0                	test   %eax,%eax
  802858:	79 1e                	jns    802878 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  80285a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80285d:	75 07                	jne    802866 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  80285f:	e8 4c e4 ff ff       	call   800cb0 <sys_yield>
  802864:	eb e2                	jmp    802848 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  802866:	50                   	push   %eax
  802867:	68 4e 31 80 00       	push   $0x80314e
  80286c:	6a 59                	push   $0x59
  80286e:	68 69 31 80 00       	push   $0x803169
  802873:	e8 28 d9 ff ff       	call   8001a0 <_panic>
	}
}
  802878:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80287b:	5b                   	pop    %ebx
  80287c:	5e                   	pop    %esi
  80287d:	5f                   	pop    %edi
  80287e:	5d                   	pop    %ebp
  80287f:	c3                   	ret    

00802880 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802880:	f3 0f 1e fb          	endbr32 
  802884:	55                   	push   %ebp
  802885:	89 e5                	mov    %esp,%ebp
  802887:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80288a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80288f:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802892:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802898:	8b 52 50             	mov    0x50(%edx),%edx
  80289b:	39 ca                	cmp    %ecx,%edx
  80289d:	74 11                	je     8028b0 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80289f:	83 c0 01             	add    $0x1,%eax
  8028a2:	3d 00 04 00 00       	cmp    $0x400,%eax
  8028a7:	75 e6                	jne    80288f <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8028a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ae:	eb 0b                	jmp    8028bb <ipc_find_env+0x3b>
			return envs[i].env_id;
  8028b0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8028b3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8028b8:	8b 40 48             	mov    0x48(%eax),%eax
}
  8028bb:	5d                   	pop    %ebp
  8028bc:	c3                   	ret    

008028bd <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8028bd:	f3 0f 1e fb          	endbr32 
  8028c1:	55                   	push   %ebp
  8028c2:	89 e5                	mov    %esp,%ebp
  8028c4:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8028c7:	89 c2                	mov    %eax,%edx
  8028c9:	c1 ea 16             	shr    $0x16,%edx
  8028cc:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8028d3:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8028d8:	f6 c1 01             	test   $0x1,%cl
  8028db:	74 1c                	je     8028f9 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8028dd:	c1 e8 0c             	shr    $0xc,%eax
  8028e0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8028e7:	a8 01                	test   $0x1,%al
  8028e9:	74 0e                	je     8028f9 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8028eb:	c1 e8 0c             	shr    $0xc,%eax
  8028ee:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8028f5:	ef 
  8028f6:	0f b7 d2             	movzwl %dx,%edx
}
  8028f9:	89 d0                	mov    %edx,%eax
  8028fb:	5d                   	pop    %ebp
  8028fc:	c3                   	ret    
  8028fd:	66 90                	xchg   %ax,%ax
  8028ff:	90                   	nop

00802900 <__udivdi3>:
  802900:	f3 0f 1e fb          	endbr32 
  802904:	55                   	push   %ebp
  802905:	57                   	push   %edi
  802906:	56                   	push   %esi
  802907:	53                   	push   %ebx
  802908:	83 ec 1c             	sub    $0x1c,%esp
  80290b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80290f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802913:	8b 74 24 34          	mov    0x34(%esp),%esi
  802917:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80291b:	85 d2                	test   %edx,%edx
  80291d:	75 19                	jne    802938 <__udivdi3+0x38>
  80291f:	39 f3                	cmp    %esi,%ebx
  802921:	76 4d                	jbe    802970 <__udivdi3+0x70>
  802923:	31 ff                	xor    %edi,%edi
  802925:	89 e8                	mov    %ebp,%eax
  802927:	89 f2                	mov    %esi,%edx
  802929:	f7 f3                	div    %ebx
  80292b:	89 fa                	mov    %edi,%edx
  80292d:	83 c4 1c             	add    $0x1c,%esp
  802930:	5b                   	pop    %ebx
  802931:	5e                   	pop    %esi
  802932:	5f                   	pop    %edi
  802933:	5d                   	pop    %ebp
  802934:	c3                   	ret    
  802935:	8d 76 00             	lea    0x0(%esi),%esi
  802938:	39 f2                	cmp    %esi,%edx
  80293a:	76 14                	jbe    802950 <__udivdi3+0x50>
  80293c:	31 ff                	xor    %edi,%edi
  80293e:	31 c0                	xor    %eax,%eax
  802940:	89 fa                	mov    %edi,%edx
  802942:	83 c4 1c             	add    $0x1c,%esp
  802945:	5b                   	pop    %ebx
  802946:	5e                   	pop    %esi
  802947:	5f                   	pop    %edi
  802948:	5d                   	pop    %ebp
  802949:	c3                   	ret    
  80294a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802950:	0f bd fa             	bsr    %edx,%edi
  802953:	83 f7 1f             	xor    $0x1f,%edi
  802956:	75 48                	jne    8029a0 <__udivdi3+0xa0>
  802958:	39 f2                	cmp    %esi,%edx
  80295a:	72 06                	jb     802962 <__udivdi3+0x62>
  80295c:	31 c0                	xor    %eax,%eax
  80295e:	39 eb                	cmp    %ebp,%ebx
  802960:	77 de                	ja     802940 <__udivdi3+0x40>
  802962:	b8 01 00 00 00       	mov    $0x1,%eax
  802967:	eb d7                	jmp    802940 <__udivdi3+0x40>
  802969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802970:	89 d9                	mov    %ebx,%ecx
  802972:	85 db                	test   %ebx,%ebx
  802974:	75 0b                	jne    802981 <__udivdi3+0x81>
  802976:	b8 01 00 00 00       	mov    $0x1,%eax
  80297b:	31 d2                	xor    %edx,%edx
  80297d:	f7 f3                	div    %ebx
  80297f:	89 c1                	mov    %eax,%ecx
  802981:	31 d2                	xor    %edx,%edx
  802983:	89 f0                	mov    %esi,%eax
  802985:	f7 f1                	div    %ecx
  802987:	89 c6                	mov    %eax,%esi
  802989:	89 e8                	mov    %ebp,%eax
  80298b:	89 f7                	mov    %esi,%edi
  80298d:	f7 f1                	div    %ecx
  80298f:	89 fa                	mov    %edi,%edx
  802991:	83 c4 1c             	add    $0x1c,%esp
  802994:	5b                   	pop    %ebx
  802995:	5e                   	pop    %esi
  802996:	5f                   	pop    %edi
  802997:	5d                   	pop    %ebp
  802998:	c3                   	ret    
  802999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029a0:	89 f9                	mov    %edi,%ecx
  8029a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8029a7:	29 f8                	sub    %edi,%eax
  8029a9:	d3 e2                	shl    %cl,%edx
  8029ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8029af:	89 c1                	mov    %eax,%ecx
  8029b1:	89 da                	mov    %ebx,%edx
  8029b3:	d3 ea                	shr    %cl,%edx
  8029b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8029b9:	09 d1                	or     %edx,%ecx
  8029bb:	89 f2                	mov    %esi,%edx
  8029bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8029c1:	89 f9                	mov    %edi,%ecx
  8029c3:	d3 e3                	shl    %cl,%ebx
  8029c5:	89 c1                	mov    %eax,%ecx
  8029c7:	d3 ea                	shr    %cl,%edx
  8029c9:	89 f9                	mov    %edi,%ecx
  8029cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8029cf:	89 eb                	mov    %ebp,%ebx
  8029d1:	d3 e6                	shl    %cl,%esi
  8029d3:	89 c1                	mov    %eax,%ecx
  8029d5:	d3 eb                	shr    %cl,%ebx
  8029d7:	09 de                	or     %ebx,%esi
  8029d9:	89 f0                	mov    %esi,%eax
  8029db:	f7 74 24 08          	divl   0x8(%esp)
  8029df:	89 d6                	mov    %edx,%esi
  8029e1:	89 c3                	mov    %eax,%ebx
  8029e3:	f7 64 24 0c          	mull   0xc(%esp)
  8029e7:	39 d6                	cmp    %edx,%esi
  8029e9:	72 15                	jb     802a00 <__udivdi3+0x100>
  8029eb:	89 f9                	mov    %edi,%ecx
  8029ed:	d3 e5                	shl    %cl,%ebp
  8029ef:	39 c5                	cmp    %eax,%ebp
  8029f1:	73 04                	jae    8029f7 <__udivdi3+0xf7>
  8029f3:	39 d6                	cmp    %edx,%esi
  8029f5:	74 09                	je     802a00 <__udivdi3+0x100>
  8029f7:	89 d8                	mov    %ebx,%eax
  8029f9:	31 ff                	xor    %edi,%edi
  8029fb:	e9 40 ff ff ff       	jmp    802940 <__udivdi3+0x40>
  802a00:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a03:	31 ff                	xor    %edi,%edi
  802a05:	e9 36 ff ff ff       	jmp    802940 <__udivdi3+0x40>
  802a0a:	66 90                	xchg   %ax,%ax
  802a0c:	66 90                	xchg   %ax,%ax
  802a0e:	66 90                	xchg   %ax,%ax

00802a10 <__umoddi3>:
  802a10:	f3 0f 1e fb          	endbr32 
  802a14:	55                   	push   %ebp
  802a15:	57                   	push   %edi
  802a16:	56                   	push   %esi
  802a17:	53                   	push   %ebx
  802a18:	83 ec 1c             	sub    $0x1c,%esp
  802a1b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a1f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802a23:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802a27:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a2b:	85 c0                	test   %eax,%eax
  802a2d:	75 19                	jne    802a48 <__umoddi3+0x38>
  802a2f:	39 df                	cmp    %ebx,%edi
  802a31:	76 5d                	jbe    802a90 <__umoddi3+0x80>
  802a33:	89 f0                	mov    %esi,%eax
  802a35:	89 da                	mov    %ebx,%edx
  802a37:	f7 f7                	div    %edi
  802a39:	89 d0                	mov    %edx,%eax
  802a3b:	31 d2                	xor    %edx,%edx
  802a3d:	83 c4 1c             	add    $0x1c,%esp
  802a40:	5b                   	pop    %ebx
  802a41:	5e                   	pop    %esi
  802a42:	5f                   	pop    %edi
  802a43:	5d                   	pop    %ebp
  802a44:	c3                   	ret    
  802a45:	8d 76 00             	lea    0x0(%esi),%esi
  802a48:	89 f2                	mov    %esi,%edx
  802a4a:	39 d8                	cmp    %ebx,%eax
  802a4c:	76 12                	jbe    802a60 <__umoddi3+0x50>
  802a4e:	89 f0                	mov    %esi,%eax
  802a50:	89 da                	mov    %ebx,%edx
  802a52:	83 c4 1c             	add    $0x1c,%esp
  802a55:	5b                   	pop    %ebx
  802a56:	5e                   	pop    %esi
  802a57:	5f                   	pop    %edi
  802a58:	5d                   	pop    %ebp
  802a59:	c3                   	ret    
  802a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a60:	0f bd e8             	bsr    %eax,%ebp
  802a63:	83 f5 1f             	xor    $0x1f,%ebp
  802a66:	75 50                	jne    802ab8 <__umoddi3+0xa8>
  802a68:	39 d8                	cmp    %ebx,%eax
  802a6a:	0f 82 e0 00 00 00    	jb     802b50 <__umoddi3+0x140>
  802a70:	89 d9                	mov    %ebx,%ecx
  802a72:	39 f7                	cmp    %esi,%edi
  802a74:	0f 86 d6 00 00 00    	jbe    802b50 <__umoddi3+0x140>
  802a7a:	89 d0                	mov    %edx,%eax
  802a7c:	89 ca                	mov    %ecx,%edx
  802a7e:	83 c4 1c             	add    $0x1c,%esp
  802a81:	5b                   	pop    %ebx
  802a82:	5e                   	pop    %esi
  802a83:	5f                   	pop    %edi
  802a84:	5d                   	pop    %ebp
  802a85:	c3                   	ret    
  802a86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a8d:	8d 76 00             	lea    0x0(%esi),%esi
  802a90:	89 fd                	mov    %edi,%ebp
  802a92:	85 ff                	test   %edi,%edi
  802a94:	75 0b                	jne    802aa1 <__umoddi3+0x91>
  802a96:	b8 01 00 00 00       	mov    $0x1,%eax
  802a9b:	31 d2                	xor    %edx,%edx
  802a9d:	f7 f7                	div    %edi
  802a9f:	89 c5                	mov    %eax,%ebp
  802aa1:	89 d8                	mov    %ebx,%eax
  802aa3:	31 d2                	xor    %edx,%edx
  802aa5:	f7 f5                	div    %ebp
  802aa7:	89 f0                	mov    %esi,%eax
  802aa9:	f7 f5                	div    %ebp
  802aab:	89 d0                	mov    %edx,%eax
  802aad:	31 d2                	xor    %edx,%edx
  802aaf:	eb 8c                	jmp    802a3d <__umoddi3+0x2d>
  802ab1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ab8:	89 e9                	mov    %ebp,%ecx
  802aba:	ba 20 00 00 00       	mov    $0x20,%edx
  802abf:	29 ea                	sub    %ebp,%edx
  802ac1:	d3 e0                	shl    %cl,%eax
  802ac3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ac7:	89 d1                	mov    %edx,%ecx
  802ac9:	89 f8                	mov    %edi,%eax
  802acb:	d3 e8                	shr    %cl,%eax
  802acd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802ad1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802ad5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802ad9:	09 c1                	or     %eax,%ecx
  802adb:	89 d8                	mov    %ebx,%eax
  802add:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ae1:	89 e9                	mov    %ebp,%ecx
  802ae3:	d3 e7                	shl    %cl,%edi
  802ae5:	89 d1                	mov    %edx,%ecx
  802ae7:	d3 e8                	shr    %cl,%eax
  802ae9:	89 e9                	mov    %ebp,%ecx
  802aeb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802aef:	d3 e3                	shl    %cl,%ebx
  802af1:	89 c7                	mov    %eax,%edi
  802af3:	89 d1                	mov    %edx,%ecx
  802af5:	89 f0                	mov    %esi,%eax
  802af7:	d3 e8                	shr    %cl,%eax
  802af9:	89 e9                	mov    %ebp,%ecx
  802afb:	89 fa                	mov    %edi,%edx
  802afd:	d3 e6                	shl    %cl,%esi
  802aff:	09 d8                	or     %ebx,%eax
  802b01:	f7 74 24 08          	divl   0x8(%esp)
  802b05:	89 d1                	mov    %edx,%ecx
  802b07:	89 f3                	mov    %esi,%ebx
  802b09:	f7 64 24 0c          	mull   0xc(%esp)
  802b0d:	89 c6                	mov    %eax,%esi
  802b0f:	89 d7                	mov    %edx,%edi
  802b11:	39 d1                	cmp    %edx,%ecx
  802b13:	72 06                	jb     802b1b <__umoddi3+0x10b>
  802b15:	75 10                	jne    802b27 <__umoddi3+0x117>
  802b17:	39 c3                	cmp    %eax,%ebx
  802b19:	73 0c                	jae    802b27 <__umoddi3+0x117>
  802b1b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802b1f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802b23:	89 d7                	mov    %edx,%edi
  802b25:	89 c6                	mov    %eax,%esi
  802b27:	89 ca                	mov    %ecx,%edx
  802b29:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802b2e:	29 f3                	sub    %esi,%ebx
  802b30:	19 fa                	sbb    %edi,%edx
  802b32:	89 d0                	mov    %edx,%eax
  802b34:	d3 e0                	shl    %cl,%eax
  802b36:	89 e9                	mov    %ebp,%ecx
  802b38:	d3 eb                	shr    %cl,%ebx
  802b3a:	d3 ea                	shr    %cl,%edx
  802b3c:	09 d8                	or     %ebx,%eax
  802b3e:	83 c4 1c             	add    $0x1c,%esp
  802b41:	5b                   	pop    %ebx
  802b42:	5e                   	pop    %esi
  802b43:	5f                   	pop    %edi
  802b44:	5d                   	pop    %ebp
  802b45:	c3                   	ret    
  802b46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b4d:	8d 76 00             	lea    0x0(%esi),%esi
  802b50:	29 fe                	sub    %edi,%esi
  802b52:	19 c3                	sbb    %eax,%ebx
  802b54:	89 f2                	mov    %esi,%edx
  802b56:	89 d9                	mov    %ebx,%ecx
  802b58:	e9 1d ff ff ff       	jmp    802a7a <__umoddi3+0x6a>
