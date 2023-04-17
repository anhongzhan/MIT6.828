
obj/user/faultalloc.debug:     file format elf32-i386


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
  80002c:	e8 a1 00 00 00       	call   8000d2 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	53                   	push   %ebx
  80003b:	83 ec 0c             	sub    $0xc,%esp
	int r;
	void *addr = (void*)utf->utf_fault_va;
  80003e:	8b 45 08             	mov    0x8(%ebp),%eax
  800041:	8b 18                	mov    (%eax),%ebx

	cprintf("fault %x\n", addr);
  800043:	53                   	push   %ebx
  800044:	68 20 20 80 00       	push   $0x802020
  800049:	e8 d3 01 00 00       	call   800221 <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004e:	83 c4 0c             	add    $0xc,%esp
  800051:	6a 07                	push   $0x7
  800053:	89 d8                	mov    %ebx,%eax
  800055:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80005a:	50                   	push   %eax
  80005b:	6a 00                	push   $0x0
  80005d:	e8 0b 0c 00 00       	call   800c6d <sys_page_alloc>
  800062:	83 c4 10             	add    $0x10,%esp
  800065:	85 c0                	test   %eax,%eax
  800067:	78 16                	js     80007f <handler+0x4c>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800069:	53                   	push   %ebx
  80006a:	68 6c 20 80 00       	push   $0x80206c
  80006f:	6a 64                	push   $0x64
  800071:	53                   	push   %ebx
  800072:	e8 53 07 00 00       	call   8007ca <snprintf>
}
  800077:	83 c4 10             	add    $0x10,%esp
  80007a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80007d:	c9                   	leave  
  80007e:	c3                   	ret    
		panic("allocating at %x in page fault handler: %e", addr, r);
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	50                   	push   %eax
  800083:	53                   	push   %ebx
  800084:	68 40 20 80 00       	push   $0x802040
  800089:	6a 0e                	push   $0xe
  80008b:	68 2a 20 80 00       	push   $0x80202a
  800090:	e8 a5 00 00 00       	call   80013a <_panic>

00800095 <umain>:

void
umain(int argc, char **argv)
{
  800095:	f3 0f 1e fb          	endbr32 
  800099:	55                   	push   %ebp
  80009a:	89 e5                	mov    %esp,%ebp
  80009c:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  80009f:	68 33 00 80 00       	push   $0x800033
  8000a4:	e8 d5 0d 00 00       	call   800e7e <set_pgfault_handler>
	cprintf("%s\n", (char*)0xDeadBeef);
  8000a9:	83 c4 08             	add    $0x8,%esp
  8000ac:	68 ef be ad de       	push   $0xdeadbeef
  8000b1:	68 3c 20 80 00       	push   $0x80203c
  8000b6:	e8 66 01 00 00       	call   800221 <cprintf>
	cprintf("%s\n", (char*)0xCafeBffe);
  8000bb:	83 c4 08             	add    $0x8,%esp
  8000be:	68 fe bf fe ca       	push   $0xcafebffe
  8000c3:	68 3c 20 80 00       	push   $0x80203c
  8000c8:	e8 54 01 00 00       	call   800221 <cprintf>
}
  8000cd:	83 c4 10             	add    $0x10,%esp
  8000d0:	c9                   	leave  
  8000d1:	c3                   	ret    

008000d2 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000d2:	f3 0f 1e fb          	endbr32 
  8000d6:	55                   	push   %ebp
  8000d7:	89 e5                	mov    %esp,%ebp
  8000d9:	56                   	push   %esi
  8000da:	53                   	push   %ebx
  8000db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000de:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000e1:	e8 41 0b 00 00       	call   800c27 <sys_getenvid>
  8000e6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000eb:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000ee:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000f3:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000f8:	85 db                	test   %ebx,%ebx
  8000fa:	7e 07                	jle    800103 <libmain+0x31>
		binaryname = argv[0];
  8000fc:	8b 06                	mov    (%esi),%eax
  8000fe:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800103:	83 ec 08             	sub    $0x8,%esp
  800106:	56                   	push   %esi
  800107:	53                   	push   %ebx
  800108:	e8 88 ff ff ff       	call   800095 <umain>

	// exit gracefully
	exit();
  80010d:	e8 0a 00 00 00       	call   80011c <exit>
}
  800112:	83 c4 10             	add    $0x10,%esp
  800115:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800118:	5b                   	pop    %ebx
  800119:	5e                   	pop    %esi
  80011a:	5d                   	pop    %ebp
  80011b:	c3                   	ret    

0080011c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80011c:	f3 0f 1e fb          	endbr32 
  800120:	55                   	push   %ebp
  800121:	89 e5                	mov    %esp,%ebp
  800123:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800126:	e8 db 0f 00 00       	call   801106 <close_all>
	sys_env_destroy(0);
  80012b:	83 ec 0c             	sub    $0xc,%esp
  80012e:	6a 00                	push   $0x0
  800130:	e8 ad 0a 00 00       	call   800be2 <sys_env_destroy>
}
  800135:	83 c4 10             	add    $0x10,%esp
  800138:	c9                   	leave  
  800139:	c3                   	ret    

0080013a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80013a:	f3 0f 1e fb          	endbr32 
  80013e:	55                   	push   %ebp
  80013f:	89 e5                	mov    %esp,%ebp
  800141:	56                   	push   %esi
  800142:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800143:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800146:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80014c:	e8 d6 0a 00 00       	call   800c27 <sys_getenvid>
  800151:	83 ec 0c             	sub    $0xc,%esp
  800154:	ff 75 0c             	pushl  0xc(%ebp)
  800157:	ff 75 08             	pushl  0x8(%ebp)
  80015a:	56                   	push   %esi
  80015b:	50                   	push   %eax
  80015c:	68 98 20 80 00       	push   $0x802098
  800161:	e8 bb 00 00 00       	call   800221 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800166:	83 c4 18             	add    $0x18,%esp
  800169:	53                   	push   %ebx
  80016a:	ff 75 10             	pushl  0x10(%ebp)
  80016d:	e8 5a 00 00 00       	call   8001cc <vcprintf>
	cprintf("\n");
  800172:	c7 04 24 63 25 80 00 	movl   $0x802563,(%esp)
  800179:	e8 a3 00 00 00       	call   800221 <cprintf>
  80017e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800181:	cc                   	int3   
  800182:	eb fd                	jmp    800181 <_panic+0x47>

00800184 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800184:	f3 0f 1e fb          	endbr32 
  800188:	55                   	push   %ebp
  800189:	89 e5                	mov    %esp,%ebp
  80018b:	53                   	push   %ebx
  80018c:	83 ec 04             	sub    $0x4,%esp
  80018f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800192:	8b 13                	mov    (%ebx),%edx
  800194:	8d 42 01             	lea    0x1(%edx),%eax
  800197:	89 03                	mov    %eax,(%ebx)
  800199:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80019c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001a0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001a5:	74 09                	je     8001b0 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001a7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001ae:	c9                   	leave  
  8001af:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001b0:	83 ec 08             	sub    $0x8,%esp
  8001b3:	68 ff 00 00 00       	push   $0xff
  8001b8:	8d 43 08             	lea    0x8(%ebx),%eax
  8001bb:	50                   	push   %eax
  8001bc:	e8 dc 09 00 00       	call   800b9d <sys_cputs>
		b->idx = 0;
  8001c1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001c7:	83 c4 10             	add    $0x10,%esp
  8001ca:	eb db                	jmp    8001a7 <putch+0x23>

008001cc <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001cc:	f3 0f 1e fb          	endbr32 
  8001d0:	55                   	push   %ebp
  8001d1:	89 e5                	mov    %esp,%ebp
  8001d3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001d9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001e0:	00 00 00 
	b.cnt = 0;
  8001e3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001ea:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001ed:	ff 75 0c             	pushl  0xc(%ebp)
  8001f0:	ff 75 08             	pushl  0x8(%ebp)
  8001f3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001f9:	50                   	push   %eax
  8001fa:	68 84 01 80 00       	push   $0x800184
  8001ff:	e8 20 01 00 00       	call   800324 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800204:	83 c4 08             	add    $0x8,%esp
  800207:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80020d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800213:	50                   	push   %eax
  800214:	e8 84 09 00 00       	call   800b9d <sys_cputs>

	return b.cnt;
}
  800219:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80021f:	c9                   	leave  
  800220:	c3                   	ret    

00800221 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800221:	f3 0f 1e fb          	endbr32 
  800225:	55                   	push   %ebp
  800226:	89 e5                	mov    %esp,%ebp
  800228:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80022b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80022e:	50                   	push   %eax
  80022f:	ff 75 08             	pushl  0x8(%ebp)
  800232:	e8 95 ff ff ff       	call   8001cc <vcprintf>
	va_end(ap);

	return cnt;
}
  800237:	c9                   	leave  
  800238:	c3                   	ret    

00800239 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800239:	55                   	push   %ebp
  80023a:	89 e5                	mov    %esp,%ebp
  80023c:	57                   	push   %edi
  80023d:	56                   	push   %esi
  80023e:	53                   	push   %ebx
  80023f:	83 ec 1c             	sub    $0x1c,%esp
  800242:	89 c7                	mov    %eax,%edi
  800244:	89 d6                	mov    %edx,%esi
  800246:	8b 45 08             	mov    0x8(%ebp),%eax
  800249:	8b 55 0c             	mov    0xc(%ebp),%edx
  80024c:	89 d1                	mov    %edx,%ecx
  80024e:	89 c2                	mov    %eax,%edx
  800250:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800253:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800256:	8b 45 10             	mov    0x10(%ebp),%eax
  800259:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80025c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80025f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800266:	39 c2                	cmp    %eax,%edx
  800268:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80026b:	72 3e                	jb     8002ab <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80026d:	83 ec 0c             	sub    $0xc,%esp
  800270:	ff 75 18             	pushl  0x18(%ebp)
  800273:	83 eb 01             	sub    $0x1,%ebx
  800276:	53                   	push   %ebx
  800277:	50                   	push   %eax
  800278:	83 ec 08             	sub    $0x8,%esp
  80027b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027e:	ff 75 e0             	pushl  -0x20(%ebp)
  800281:	ff 75 dc             	pushl  -0x24(%ebp)
  800284:	ff 75 d8             	pushl  -0x28(%ebp)
  800287:	e8 34 1b 00 00       	call   801dc0 <__udivdi3>
  80028c:	83 c4 18             	add    $0x18,%esp
  80028f:	52                   	push   %edx
  800290:	50                   	push   %eax
  800291:	89 f2                	mov    %esi,%edx
  800293:	89 f8                	mov    %edi,%eax
  800295:	e8 9f ff ff ff       	call   800239 <printnum>
  80029a:	83 c4 20             	add    $0x20,%esp
  80029d:	eb 13                	jmp    8002b2 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80029f:	83 ec 08             	sub    $0x8,%esp
  8002a2:	56                   	push   %esi
  8002a3:	ff 75 18             	pushl  0x18(%ebp)
  8002a6:	ff d7                	call   *%edi
  8002a8:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002ab:	83 eb 01             	sub    $0x1,%ebx
  8002ae:	85 db                	test   %ebx,%ebx
  8002b0:	7f ed                	jg     80029f <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002b2:	83 ec 08             	sub    $0x8,%esp
  8002b5:	56                   	push   %esi
  8002b6:	83 ec 04             	sub    $0x4,%esp
  8002b9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8002bf:	ff 75 dc             	pushl  -0x24(%ebp)
  8002c2:	ff 75 d8             	pushl  -0x28(%ebp)
  8002c5:	e8 06 1c 00 00       	call   801ed0 <__umoddi3>
  8002ca:	83 c4 14             	add    $0x14,%esp
  8002cd:	0f be 80 bb 20 80 00 	movsbl 0x8020bb(%eax),%eax
  8002d4:	50                   	push   %eax
  8002d5:	ff d7                	call   *%edi
}
  8002d7:	83 c4 10             	add    $0x10,%esp
  8002da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002dd:	5b                   	pop    %ebx
  8002de:	5e                   	pop    %esi
  8002df:	5f                   	pop    %edi
  8002e0:	5d                   	pop    %ebp
  8002e1:	c3                   	ret    

008002e2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002e2:	f3 0f 1e fb          	endbr32 
  8002e6:	55                   	push   %ebp
  8002e7:	89 e5                	mov    %esp,%ebp
  8002e9:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002ec:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002f0:	8b 10                	mov    (%eax),%edx
  8002f2:	3b 50 04             	cmp    0x4(%eax),%edx
  8002f5:	73 0a                	jae    800301 <sprintputch+0x1f>
		*b->buf++ = ch;
  8002f7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002fa:	89 08                	mov    %ecx,(%eax)
  8002fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ff:	88 02                	mov    %al,(%edx)
}
  800301:	5d                   	pop    %ebp
  800302:	c3                   	ret    

00800303 <printfmt>:
{
  800303:	f3 0f 1e fb          	endbr32 
  800307:	55                   	push   %ebp
  800308:	89 e5                	mov    %esp,%ebp
  80030a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80030d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800310:	50                   	push   %eax
  800311:	ff 75 10             	pushl  0x10(%ebp)
  800314:	ff 75 0c             	pushl  0xc(%ebp)
  800317:	ff 75 08             	pushl  0x8(%ebp)
  80031a:	e8 05 00 00 00       	call   800324 <vprintfmt>
}
  80031f:	83 c4 10             	add    $0x10,%esp
  800322:	c9                   	leave  
  800323:	c3                   	ret    

00800324 <vprintfmt>:
{
  800324:	f3 0f 1e fb          	endbr32 
  800328:	55                   	push   %ebp
  800329:	89 e5                	mov    %esp,%ebp
  80032b:	57                   	push   %edi
  80032c:	56                   	push   %esi
  80032d:	53                   	push   %ebx
  80032e:	83 ec 3c             	sub    $0x3c,%esp
  800331:	8b 75 08             	mov    0x8(%ebp),%esi
  800334:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800337:	8b 7d 10             	mov    0x10(%ebp),%edi
  80033a:	e9 8e 03 00 00       	jmp    8006cd <vprintfmt+0x3a9>
		padc = ' ';
  80033f:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800343:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80034a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800351:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800358:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80035d:	8d 47 01             	lea    0x1(%edi),%eax
  800360:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800363:	0f b6 17             	movzbl (%edi),%edx
  800366:	8d 42 dd             	lea    -0x23(%edx),%eax
  800369:	3c 55                	cmp    $0x55,%al
  80036b:	0f 87 df 03 00 00    	ja     800750 <vprintfmt+0x42c>
  800371:	0f b6 c0             	movzbl %al,%eax
  800374:	3e ff 24 85 00 22 80 	notrack jmp *0x802200(,%eax,4)
  80037b:	00 
  80037c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80037f:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800383:	eb d8                	jmp    80035d <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800385:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800388:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80038c:	eb cf                	jmp    80035d <vprintfmt+0x39>
  80038e:	0f b6 d2             	movzbl %dl,%edx
  800391:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800394:	b8 00 00 00 00       	mov    $0x0,%eax
  800399:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80039c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80039f:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003a3:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003a6:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003a9:	83 f9 09             	cmp    $0x9,%ecx
  8003ac:	77 55                	ja     800403 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8003ae:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003b1:	eb e9                	jmp    80039c <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8003b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b6:	8b 00                	mov    (%eax),%eax
  8003b8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003be:	8d 40 04             	lea    0x4(%eax),%eax
  8003c1:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003c7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003cb:	79 90                	jns    80035d <vprintfmt+0x39>
				width = precision, precision = -1;
  8003cd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003d3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003da:	eb 81                	jmp    80035d <vprintfmt+0x39>
  8003dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003df:	85 c0                	test   %eax,%eax
  8003e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8003e6:	0f 49 d0             	cmovns %eax,%edx
  8003e9:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003ef:	e9 69 ff ff ff       	jmp    80035d <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003f7:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003fe:	e9 5a ff ff ff       	jmp    80035d <vprintfmt+0x39>
  800403:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800406:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800409:	eb bc                	jmp    8003c7 <vprintfmt+0xa3>
			lflag++;
  80040b:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80040e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800411:	e9 47 ff ff ff       	jmp    80035d <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800416:	8b 45 14             	mov    0x14(%ebp),%eax
  800419:	8d 78 04             	lea    0x4(%eax),%edi
  80041c:	83 ec 08             	sub    $0x8,%esp
  80041f:	53                   	push   %ebx
  800420:	ff 30                	pushl  (%eax)
  800422:	ff d6                	call   *%esi
			break;
  800424:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800427:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80042a:	e9 9b 02 00 00       	jmp    8006ca <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80042f:	8b 45 14             	mov    0x14(%ebp),%eax
  800432:	8d 78 04             	lea    0x4(%eax),%edi
  800435:	8b 00                	mov    (%eax),%eax
  800437:	99                   	cltd   
  800438:	31 d0                	xor    %edx,%eax
  80043a:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80043c:	83 f8 0f             	cmp    $0xf,%eax
  80043f:	7f 23                	jg     800464 <vprintfmt+0x140>
  800441:	8b 14 85 60 23 80 00 	mov    0x802360(,%eax,4),%edx
  800448:	85 d2                	test   %edx,%edx
  80044a:	74 18                	je     800464 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80044c:	52                   	push   %edx
  80044d:	68 05 25 80 00       	push   $0x802505
  800452:	53                   	push   %ebx
  800453:	56                   	push   %esi
  800454:	e8 aa fe ff ff       	call   800303 <printfmt>
  800459:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80045c:	89 7d 14             	mov    %edi,0x14(%ebp)
  80045f:	e9 66 02 00 00       	jmp    8006ca <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800464:	50                   	push   %eax
  800465:	68 d3 20 80 00       	push   $0x8020d3
  80046a:	53                   	push   %ebx
  80046b:	56                   	push   %esi
  80046c:	e8 92 fe ff ff       	call   800303 <printfmt>
  800471:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800474:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800477:	e9 4e 02 00 00       	jmp    8006ca <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  80047c:	8b 45 14             	mov    0x14(%ebp),%eax
  80047f:	83 c0 04             	add    $0x4,%eax
  800482:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800485:	8b 45 14             	mov    0x14(%ebp),%eax
  800488:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80048a:	85 d2                	test   %edx,%edx
  80048c:	b8 cc 20 80 00       	mov    $0x8020cc,%eax
  800491:	0f 45 c2             	cmovne %edx,%eax
  800494:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800497:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80049b:	7e 06                	jle    8004a3 <vprintfmt+0x17f>
  80049d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004a1:	75 0d                	jne    8004b0 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004a6:	89 c7                	mov    %eax,%edi
  8004a8:	03 45 e0             	add    -0x20(%ebp),%eax
  8004ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004ae:	eb 55                	jmp    800505 <vprintfmt+0x1e1>
  8004b0:	83 ec 08             	sub    $0x8,%esp
  8004b3:	ff 75 d8             	pushl  -0x28(%ebp)
  8004b6:	ff 75 cc             	pushl  -0x34(%ebp)
  8004b9:	e8 46 03 00 00       	call   800804 <strnlen>
  8004be:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004c1:	29 c2                	sub    %eax,%edx
  8004c3:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004c6:	83 c4 10             	add    $0x10,%esp
  8004c9:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004cb:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d2:	85 ff                	test   %edi,%edi
  8004d4:	7e 11                	jle    8004e7 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8004d6:	83 ec 08             	sub    $0x8,%esp
  8004d9:	53                   	push   %ebx
  8004da:	ff 75 e0             	pushl  -0x20(%ebp)
  8004dd:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004df:	83 ef 01             	sub    $0x1,%edi
  8004e2:	83 c4 10             	add    $0x10,%esp
  8004e5:	eb eb                	jmp    8004d2 <vprintfmt+0x1ae>
  8004e7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004ea:	85 d2                	test   %edx,%edx
  8004ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f1:	0f 49 c2             	cmovns %edx,%eax
  8004f4:	29 c2                	sub    %eax,%edx
  8004f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004f9:	eb a8                	jmp    8004a3 <vprintfmt+0x17f>
					putch(ch, putdat);
  8004fb:	83 ec 08             	sub    $0x8,%esp
  8004fe:	53                   	push   %ebx
  8004ff:	52                   	push   %edx
  800500:	ff d6                	call   *%esi
  800502:	83 c4 10             	add    $0x10,%esp
  800505:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800508:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80050a:	83 c7 01             	add    $0x1,%edi
  80050d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800511:	0f be d0             	movsbl %al,%edx
  800514:	85 d2                	test   %edx,%edx
  800516:	74 4b                	je     800563 <vprintfmt+0x23f>
  800518:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80051c:	78 06                	js     800524 <vprintfmt+0x200>
  80051e:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800522:	78 1e                	js     800542 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800524:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800528:	74 d1                	je     8004fb <vprintfmt+0x1d7>
  80052a:	0f be c0             	movsbl %al,%eax
  80052d:	83 e8 20             	sub    $0x20,%eax
  800530:	83 f8 5e             	cmp    $0x5e,%eax
  800533:	76 c6                	jbe    8004fb <vprintfmt+0x1d7>
					putch('?', putdat);
  800535:	83 ec 08             	sub    $0x8,%esp
  800538:	53                   	push   %ebx
  800539:	6a 3f                	push   $0x3f
  80053b:	ff d6                	call   *%esi
  80053d:	83 c4 10             	add    $0x10,%esp
  800540:	eb c3                	jmp    800505 <vprintfmt+0x1e1>
  800542:	89 cf                	mov    %ecx,%edi
  800544:	eb 0e                	jmp    800554 <vprintfmt+0x230>
				putch(' ', putdat);
  800546:	83 ec 08             	sub    $0x8,%esp
  800549:	53                   	push   %ebx
  80054a:	6a 20                	push   $0x20
  80054c:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80054e:	83 ef 01             	sub    $0x1,%edi
  800551:	83 c4 10             	add    $0x10,%esp
  800554:	85 ff                	test   %edi,%edi
  800556:	7f ee                	jg     800546 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800558:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80055b:	89 45 14             	mov    %eax,0x14(%ebp)
  80055e:	e9 67 01 00 00       	jmp    8006ca <vprintfmt+0x3a6>
  800563:	89 cf                	mov    %ecx,%edi
  800565:	eb ed                	jmp    800554 <vprintfmt+0x230>
	if (lflag >= 2)
  800567:	83 f9 01             	cmp    $0x1,%ecx
  80056a:	7f 1b                	jg     800587 <vprintfmt+0x263>
	else if (lflag)
  80056c:	85 c9                	test   %ecx,%ecx
  80056e:	74 63                	je     8005d3 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800570:	8b 45 14             	mov    0x14(%ebp),%eax
  800573:	8b 00                	mov    (%eax),%eax
  800575:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800578:	99                   	cltd   
  800579:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	8d 40 04             	lea    0x4(%eax),%eax
  800582:	89 45 14             	mov    %eax,0x14(%ebp)
  800585:	eb 17                	jmp    80059e <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800587:	8b 45 14             	mov    0x14(%ebp),%eax
  80058a:	8b 50 04             	mov    0x4(%eax),%edx
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800592:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800595:	8b 45 14             	mov    0x14(%ebp),%eax
  800598:	8d 40 08             	lea    0x8(%eax),%eax
  80059b:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80059e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005a1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005a4:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8005a9:	85 c9                	test   %ecx,%ecx
  8005ab:	0f 89 ff 00 00 00    	jns    8006b0 <vprintfmt+0x38c>
				putch('-', putdat);
  8005b1:	83 ec 08             	sub    $0x8,%esp
  8005b4:	53                   	push   %ebx
  8005b5:	6a 2d                	push   $0x2d
  8005b7:	ff d6                	call   *%esi
				num = -(long long) num;
  8005b9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005bc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005bf:	f7 da                	neg    %edx
  8005c1:	83 d1 00             	adc    $0x0,%ecx
  8005c4:	f7 d9                	neg    %ecx
  8005c6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005c9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ce:	e9 dd 00 00 00       	jmp    8006b0 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8005d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d6:	8b 00                	mov    (%eax),%eax
  8005d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005db:	99                   	cltd   
  8005dc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005df:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e2:	8d 40 04             	lea    0x4(%eax),%eax
  8005e5:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e8:	eb b4                	jmp    80059e <vprintfmt+0x27a>
	if (lflag >= 2)
  8005ea:	83 f9 01             	cmp    $0x1,%ecx
  8005ed:	7f 1e                	jg     80060d <vprintfmt+0x2e9>
	else if (lflag)
  8005ef:	85 c9                	test   %ecx,%ecx
  8005f1:	74 32                	je     800625 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8005f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f6:	8b 10                	mov    (%eax),%edx
  8005f8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005fd:	8d 40 04             	lea    0x4(%eax),%eax
  800600:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800603:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800608:	e9 a3 00 00 00       	jmp    8006b0 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80060d:	8b 45 14             	mov    0x14(%ebp),%eax
  800610:	8b 10                	mov    (%eax),%edx
  800612:	8b 48 04             	mov    0x4(%eax),%ecx
  800615:	8d 40 08             	lea    0x8(%eax),%eax
  800618:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80061b:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800620:	e9 8b 00 00 00       	jmp    8006b0 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800625:	8b 45 14             	mov    0x14(%ebp),%eax
  800628:	8b 10                	mov    (%eax),%edx
  80062a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80062f:	8d 40 04             	lea    0x4(%eax),%eax
  800632:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800635:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  80063a:	eb 74                	jmp    8006b0 <vprintfmt+0x38c>
	if (lflag >= 2)
  80063c:	83 f9 01             	cmp    $0x1,%ecx
  80063f:	7f 1b                	jg     80065c <vprintfmt+0x338>
	else if (lflag)
  800641:	85 c9                	test   %ecx,%ecx
  800643:	74 2c                	je     800671 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800645:	8b 45 14             	mov    0x14(%ebp),%eax
  800648:	8b 10                	mov    (%eax),%edx
  80064a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80064f:	8d 40 04             	lea    0x4(%eax),%eax
  800652:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800655:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  80065a:	eb 54                	jmp    8006b0 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8b 10                	mov    (%eax),%edx
  800661:	8b 48 04             	mov    0x4(%eax),%ecx
  800664:	8d 40 08             	lea    0x8(%eax),%eax
  800667:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80066a:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80066f:	eb 3f                	jmp    8006b0 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800671:	8b 45 14             	mov    0x14(%ebp),%eax
  800674:	8b 10                	mov    (%eax),%edx
  800676:	b9 00 00 00 00       	mov    $0x0,%ecx
  80067b:	8d 40 04             	lea    0x4(%eax),%eax
  80067e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800681:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800686:	eb 28                	jmp    8006b0 <vprintfmt+0x38c>
			putch('0', putdat);
  800688:	83 ec 08             	sub    $0x8,%esp
  80068b:	53                   	push   %ebx
  80068c:	6a 30                	push   $0x30
  80068e:	ff d6                	call   *%esi
			putch('x', putdat);
  800690:	83 c4 08             	add    $0x8,%esp
  800693:	53                   	push   %ebx
  800694:	6a 78                	push   $0x78
  800696:	ff d6                	call   *%esi
			num = (unsigned long long)
  800698:	8b 45 14             	mov    0x14(%ebp),%eax
  80069b:	8b 10                	mov    (%eax),%edx
  80069d:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006a2:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006a5:	8d 40 04             	lea    0x4(%eax),%eax
  8006a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ab:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006b0:	83 ec 0c             	sub    $0xc,%esp
  8006b3:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8006b7:	57                   	push   %edi
  8006b8:	ff 75 e0             	pushl  -0x20(%ebp)
  8006bb:	50                   	push   %eax
  8006bc:	51                   	push   %ecx
  8006bd:	52                   	push   %edx
  8006be:	89 da                	mov    %ebx,%edx
  8006c0:	89 f0                	mov    %esi,%eax
  8006c2:	e8 72 fb ff ff       	call   800239 <printnum>
			break;
  8006c7:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006cd:	83 c7 01             	add    $0x1,%edi
  8006d0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006d4:	83 f8 25             	cmp    $0x25,%eax
  8006d7:	0f 84 62 fc ff ff    	je     80033f <vprintfmt+0x1b>
			if (ch == '\0')
  8006dd:	85 c0                	test   %eax,%eax
  8006df:	0f 84 8b 00 00 00    	je     800770 <vprintfmt+0x44c>
			putch(ch, putdat);
  8006e5:	83 ec 08             	sub    $0x8,%esp
  8006e8:	53                   	push   %ebx
  8006e9:	50                   	push   %eax
  8006ea:	ff d6                	call   *%esi
  8006ec:	83 c4 10             	add    $0x10,%esp
  8006ef:	eb dc                	jmp    8006cd <vprintfmt+0x3a9>
	if (lflag >= 2)
  8006f1:	83 f9 01             	cmp    $0x1,%ecx
  8006f4:	7f 1b                	jg     800711 <vprintfmt+0x3ed>
	else if (lflag)
  8006f6:	85 c9                	test   %ecx,%ecx
  8006f8:	74 2c                	je     800726 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8006fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fd:	8b 10                	mov    (%eax),%edx
  8006ff:	b9 00 00 00 00       	mov    $0x0,%ecx
  800704:	8d 40 04             	lea    0x4(%eax),%eax
  800707:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80070a:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80070f:	eb 9f                	jmp    8006b0 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800711:	8b 45 14             	mov    0x14(%ebp),%eax
  800714:	8b 10                	mov    (%eax),%edx
  800716:	8b 48 04             	mov    0x4(%eax),%ecx
  800719:	8d 40 08             	lea    0x8(%eax),%eax
  80071c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80071f:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800724:	eb 8a                	jmp    8006b0 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800726:	8b 45 14             	mov    0x14(%ebp),%eax
  800729:	8b 10                	mov    (%eax),%edx
  80072b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800730:	8d 40 04             	lea    0x4(%eax),%eax
  800733:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800736:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  80073b:	e9 70 ff ff ff       	jmp    8006b0 <vprintfmt+0x38c>
			putch(ch, putdat);
  800740:	83 ec 08             	sub    $0x8,%esp
  800743:	53                   	push   %ebx
  800744:	6a 25                	push   $0x25
  800746:	ff d6                	call   *%esi
			break;
  800748:	83 c4 10             	add    $0x10,%esp
  80074b:	e9 7a ff ff ff       	jmp    8006ca <vprintfmt+0x3a6>
			putch('%', putdat);
  800750:	83 ec 08             	sub    $0x8,%esp
  800753:	53                   	push   %ebx
  800754:	6a 25                	push   $0x25
  800756:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800758:	83 c4 10             	add    $0x10,%esp
  80075b:	89 f8                	mov    %edi,%eax
  80075d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800761:	74 05                	je     800768 <vprintfmt+0x444>
  800763:	83 e8 01             	sub    $0x1,%eax
  800766:	eb f5                	jmp    80075d <vprintfmt+0x439>
  800768:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80076b:	e9 5a ff ff ff       	jmp    8006ca <vprintfmt+0x3a6>
}
  800770:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800773:	5b                   	pop    %ebx
  800774:	5e                   	pop    %esi
  800775:	5f                   	pop    %edi
  800776:	5d                   	pop    %ebp
  800777:	c3                   	ret    

00800778 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800778:	f3 0f 1e fb          	endbr32 
  80077c:	55                   	push   %ebp
  80077d:	89 e5                	mov    %esp,%ebp
  80077f:	83 ec 18             	sub    $0x18,%esp
  800782:	8b 45 08             	mov    0x8(%ebp),%eax
  800785:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800788:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80078b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80078f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800792:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800799:	85 c0                	test   %eax,%eax
  80079b:	74 26                	je     8007c3 <vsnprintf+0x4b>
  80079d:	85 d2                	test   %edx,%edx
  80079f:	7e 22                	jle    8007c3 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007a1:	ff 75 14             	pushl  0x14(%ebp)
  8007a4:	ff 75 10             	pushl  0x10(%ebp)
  8007a7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007aa:	50                   	push   %eax
  8007ab:	68 e2 02 80 00       	push   $0x8002e2
  8007b0:	e8 6f fb ff ff       	call   800324 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007b8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007be:	83 c4 10             	add    $0x10,%esp
}
  8007c1:	c9                   	leave  
  8007c2:	c3                   	ret    
		return -E_INVAL;
  8007c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007c8:	eb f7                	jmp    8007c1 <vsnprintf+0x49>

008007ca <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007ca:	f3 0f 1e fb          	endbr32 
  8007ce:	55                   	push   %ebp
  8007cf:	89 e5                	mov    %esp,%ebp
  8007d1:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007d4:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007d7:	50                   	push   %eax
  8007d8:	ff 75 10             	pushl  0x10(%ebp)
  8007db:	ff 75 0c             	pushl  0xc(%ebp)
  8007de:	ff 75 08             	pushl  0x8(%ebp)
  8007e1:	e8 92 ff ff ff       	call   800778 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007e6:	c9                   	leave  
  8007e7:	c3                   	ret    

008007e8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007e8:	f3 0f 1e fb          	endbr32 
  8007ec:	55                   	push   %ebp
  8007ed:	89 e5                	mov    %esp,%ebp
  8007ef:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f7:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007fb:	74 05                	je     800802 <strlen+0x1a>
		n++;
  8007fd:	83 c0 01             	add    $0x1,%eax
  800800:	eb f5                	jmp    8007f7 <strlen+0xf>
	return n;
}
  800802:	5d                   	pop    %ebp
  800803:	c3                   	ret    

00800804 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800804:	f3 0f 1e fb          	endbr32 
  800808:	55                   	push   %ebp
  800809:	89 e5                	mov    %esp,%ebp
  80080b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80080e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800811:	b8 00 00 00 00       	mov    $0x0,%eax
  800816:	39 d0                	cmp    %edx,%eax
  800818:	74 0d                	je     800827 <strnlen+0x23>
  80081a:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80081e:	74 05                	je     800825 <strnlen+0x21>
		n++;
  800820:	83 c0 01             	add    $0x1,%eax
  800823:	eb f1                	jmp    800816 <strnlen+0x12>
  800825:	89 c2                	mov    %eax,%edx
	return n;
}
  800827:	89 d0                	mov    %edx,%eax
  800829:	5d                   	pop    %ebp
  80082a:	c3                   	ret    

0080082b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80082b:	f3 0f 1e fb          	endbr32 
  80082f:	55                   	push   %ebp
  800830:	89 e5                	mov    %esp,%ebp
  800832:	53                   	push   %ebx
  800833:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800836:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800839:	b8 00 00 00 00       	mov    $0x0,%eax
  80083e:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800842:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800845:	83 c0 01             	add    $0x1,%eax
  800848:	84 d2                	test   %dl,%dl
  80084a:	75 f2                	jne    80083e <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  80084c:	89 c8                	mov    %ecx,%eax
  80084e:	5b                   	pop    %ebx
  80084f:	5d                   	pop    %ebp
  800850:	c3                   	ret    

00800851 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800851:	f3 0f 1e fb          	endbr32 
  800855:	55                   	push   %ebp
  800856:	89 e5                	mov    %esp,%ebp
  800858:	53                   	push   %ebx
  800859:	83 ec 10             	sub    $0x10,%esp
  80085c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80085f:	53                   	push   %ebx
  800860:	e8 83 ff ff ff       	call   8007e8 <strlen>
  800865:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800868:	ff 75 0c             	pushl  0xc(%ebp)
  80086b:	01 d8                	add    %ebx,%eax
  80086d:	50                   	push   %eax
  80086e:	e8 b8 ff ff ff       	call   80082b <strcpy>
	return dst;
}
  800873:	89 d8                	mov    %ebx,%eax
  800875:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800878:	c9                   	leave  
  800879:	c3                   	ret    

0080087a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80087a:	f3 0f 1e fb          	endbr32 
  80087e:	55                   	push   %ebp
  80087f:	89 e5                	mov    %esp,%ebp
  800881:	56                   	push   %esi
  800882:	53                   	push   %ebx
  800883:	8b 75 08             	mov    0x8(%ebp),%esi
  800886:	8b 55 0c             	mov    0xc(%ebp),%edx
  800889:	89 f3                	mov    %esi,%ebx
  80088b:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80088e:	89 f0                	mov    %esi,%eax
  800890:	39 d8                	cmp    %ebx,%eax
  800892:	74 11                	je     8008a5 <strncpy+0x2b>
		*dst++ = *src;
  800894:	83 c0 01             	add    $0x1,%eax
  800897:	0f b6 0a             	movzbl (%edx),%ecx
  80089a:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80089d:	80 f9 01             	cmp    $0x1,%cl
  8008a0:	83 da ff             	sbb    $0xffffffff,%edx
  8008a3:	eb eb                	jmp    800890 <strncpy+0x16>
	}
	return ret;
}
  8008a5:	89 f0                	mov    %esi,%eax
  8008a7:	5b                   	pop    %ebx
  8008a8:	5e                   	pop    %esi
  8008a9:	5d                   	pop    %ebp
  8008aa:	c3                   	ret    

008008ab <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008ab:	f3 0f 1e fb          	endbr32 
  8008af:	55                   	push   %ebp
  8008b0:	89 e5                	mov    %esp,%ebp
  8008b2:	56                   	push   %esi
  8008b3:	53                   	push   %ebx
  8008b4:	8b 75 08             	mov    0x8(%ebp),%esi
  8008b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008ba:	8b 55 10             	mov    0x10(%ebp),%edx
  8008bd:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008bf:	85 d2                	test   %edx,%edx
  8008c1:	74 21                	je     8008e4 <strlcpy+0x39>
  8008c3:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008c7:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008c9:	39 c2                	cmp    %eax,%edx
  8008cb:	74 14                	je     8008e1 <strlcpy+0x36>
  8008cd:	0f b6 19             	movzbl (%ecx),%ebx
  8008d0:	84 db                	test   %bl,%bl
  8008d2:	74 0b                	je     8008df <strlcpy+0x34>
			*dst++ = *src++;
  8008d4:	83 c1 01             	add    $0x1,%ecx
  8008d7:	83 c2 01             	add    $0x1,%edx
  8008da:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008dd:	eb ea                	jmp    8008c9 <strlcpy+0x1e>
  8008df:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008e1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008e4:	29 f0                	sub    %esi,%eax
}
  8008e6:	5b                   	pop    %ebx
  8008e7:	5e                   	pop    %esi
  8008e8:	5d                   	pop    %ebp
  8008e9:	c3                   	ret    

008008ea <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008ea:	f3 0f 1e fb          	endbr32 
  8008ee:	55                   	push   %ebp
  8008ef:	89 e5                	mov    %esp,%ebp
  8008f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008f4:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008f7:	0f b6 01             	movzbl (%ecx),%eax
  8008fa:	84 c0                	test   %al,%al
  8008fc:	74 0c                	je     80090a <strcmp+0x20>
  8008fe:	3a 02                	cmp    (%edx),%al
  800900:	75 08                	jne    80090a <strcmp+0x20>
		p++, q++;
  800902:	83 c1 01             	add    $0x1,%ecx
  800905:	83 c2 01             	add    $0x1,%edx
  800908:	eb ed                	jmp    8008f7 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80090a:	0f b6 c0             	movzbl %al,%eax
  80090d:	0f b6 12             	movzbl (%edx),%edx
  800910:	29 d0                	sub    %edx,%eax
}
  800912:	5d                   	pop    %ebp
  800913:	c3                   	ret    

00800914 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800914:	f3 0f 1e fb          	endbr32 
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
  80091b:	53                   	push   %ebx
  80091c:	8b 45 08             	mov    0x8(%ebp),%eax
  80091f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800922:	89 c3                	mov    %eax,%ebx
  800924:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800927:	eb 06                	jmp    80092f <strncmp+0x1b>
		n--, p++, q++;
  800929:	83 c0 01             	add    $0x1,%eax
  80092c:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80092f:	39 d8                	cmp    %ebx,%eax
  800931:	74 16                	je     800949 <strncmp+0x35>
  800933:	0f b6 08             	movzbl (%eax),%ecx
  800936:	84 c9                	test   %cl,%cl
  800938:	74 04                	je     80093e <strncmp+0x2a>
  80093a:	3a 0a                	cmp    (%edx),%cl
  80093c:	74 eb                	je     800929 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80093e:	0f b6 00             	movzbl (%eax),%eax
  800941:	0f b6 12             	movzbl (%edx),%edx
  800944:	29 d0                	sub    %edx,%eax
}
  800946:	5b                   	pop    %ebx
  800947:	5d                   	pop    %ebp
  800948:	c3                   	ret    
		return 0;
  800949:	b8 00 00 00 00       	mov    $0x0,%eax
  80094e:	eb f6                	jmp    800946 <strncmp+0x32>

00800950 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800950:	f3 0f 1e fb          	endbr32 
  800954:	55                   	push   %ebp
  800955:	89 e5                	mov    %esp,%ebp
  800957:	8b 45 08             	mov    0x8(%ebp),%eax
  80095a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80095e:	0f b6 10             	movzbl (%eax),%edx
  800961:	84 d2                	test   %dl,%dl
  800963:	74 09                	je     80096e <strchr+0x1e>
		if (*s == c)
  800965:	38 ca                	cmp    %cl,%dl
  800967:	74 0a                	je     800973 <strchr+0x23>
	for (; *s; s++)
  800969:	83 c0 01             	add    $0x1,%eax
  80096c:	eb f0                	jmp    80095e <strchr+0xe>
			return (char *) s;
	return 0;
  80096e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800973:	5d                   	pop    %ebp
  800974:	c3                   	ret    

00800975 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800975:	f3 0f 1e fb          	endbr32 
  800979:	55                   	push   %ebp
  80097a:	89 e5                	mov    %esp,%ebp
  80097c:	8b 45 08             	mov    0x8(%ebp),%eax
  80097f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800983:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800986:	38 ca                	cmp    %cl,%dl
  800988:	74 09                	je     800993 <strfind+0x1e>
  80098a:	84 d2                	test   %dl,%dl
  80098c:	74 05                	je     800993 <strfind+0x1e>
	for (; *s; s++)
  80098e:	83 c0 01             	add    $0x1,%eax
  800991:	eb f0                	jmp    800983 <strfind+0xe>
			break;
	return (char *) s;
}
  800993:	5d                   	pop    %ebp
  800994:	c3                   	ret    

00800995 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800995:	f3 0f 1e fb          	endbr32 
  800999:	55                   	push   %ebp
  80099a:	89 e5                	mov    %esp,%ebp
  80099c:	57                   	push   %edi
  80099d:	56                   	push   %esi
  80099e:	53                   	push   %ebx
  80099f:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009a2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009a5:	85 c9                	test   %ecx,%ecx
  8009a7:	74 31                	je     8009da <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009a9:	89 f8                	mov    %edi,%eax
  8009ab:	09 c8                	or     %ecx,%eax
  8009ad:	a8 03                	test   $0x3,%al
  8009af:	75 23                	jne    8009d4 <memset+0x3f>
		c &= 0xFF;
  8009b1:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009b5:	89 d3                	mov    %edx,%ebx
  8009b7:	c1 e3 08             	shl    $0x8,%ebx
  8009ba:	89 d0                	mov    %edx,%eax
  8009bc:	c1 e0 18             	shl    $0x18,%eax
  8009bf:	89 d6                	mov    %edx,%esi
  8009c1:	c1 e6 10             	shl    $0x10,%esi
  8009c4:	09 f0                	or     %esi,%eax
  8009c6:	09 c2                	or     %eax,%edx
  8009c8:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009ca:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009cd:	89 d0                	mov    %edx,%eax
  8009cf:	fc                   	cld    
  8009d0:	f3 ab                	rep stos %eax,%es:(%edi)
  8009d2:	eb 06                	jmp    8009da <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d7:	fc                   	cld    
  8009d8:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009da:	89 f8                	mov    %edi,%eax
  8009dc:	5b                   	pop    %ebx
  8009dd:	5e                   	pop    %esi
  8009de:	5f                   	pop    %edi
  8009df:	5d                   	pop    %ebp
  8009e0:	c3                   	ret    

008009e1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009e1:	f3 0f 1e fb          	endbr32 
  8009e5:	55                   	push   %ebp
  8009e6:	89 e5                	mov    %esp,%ebp
  8009e8:	57                   	push   %edi
  8009e9:	56                   	push   %esi
  8009ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ed:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009f0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009f3:	39 c6                	cmp    %eax,%esi
  8009f5:	73 32                	jae    800a29 <memmove+0x48>
  8009f7:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009fa:	39 c2                	cmp    %eax,%edx
  8009fc:	76 2b                	jbe    800a29 <memmove+0x48>
		s += n;
		d += n;
  8009fe:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a01:	89 fe                	mov    %edi,%esi
  800a03:	09 ce                	or     %ecx,%esi
  800a05:	09 d6                	or     %edx,%esi
  800a07:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a0d:	75 0e                	jne    800a1d <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a0f:	83 ef 04             	sub    $0x4,%edi
  800a12:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a15:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a18:	fd                   	std    
  800a19:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a1b:	eb 09                	jmp    800a26 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a1d:	83 ef 01             	sub    $0x1,%edi
  800a20:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a23:	fd                   	std    
  800a24:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a26:	fc                   	cld    
  800a27:	eb 1a                	jmp    800a43 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a29:	89 c2                	mov    %eax,%edx
  800a2b:	09 ca                	or     %ecx,%edx
  800a2d:	09 f2                	or     %esi,%edx
  800a2f:	f6 c2 03             	test   $0x3,%dl
  800a32:	75 0a                	jne    800a3e <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a34:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a37:	89 c7                	mov    %eax,%edi
  800a39:	fc                   	cld    
  800a3a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a3c:	eb 05                	jmp    800a43 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800a3e:	89 c7                	mov    %eax,%edi
  800a40:	fc                   	cld    
  800a41:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a43:	5e                   	pop    %esi
  800a44:	5f                   	pop    %edi
  800a45:	5d                   	pop    %ebp
  800a46:	c3                   	ret    

00800a47 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a47:	f3 0f 1e fb          	endbr32 
  800a4b:	55                   	push   %ebp
  800a4c:	89 e5                	mov    %esp,%ebp
  800a4e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a51:	ff 75 10             	pushl  0x10(%ebp)
  800a54:	ff 75 0c             	pushl  0xc(%ebp)
  800a57:	ff 75 08             	pushl  0x8(%ebp)
  800a5a:	e8 82 ff ff ff       	call   8009e1 <memmove>
}
  800a5f:	c9                   	leave  
  800a60:	c3                   	ret    

00800a61 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a61:	f3 0f 1e fb          	endbr32 
  800a65:	55                   	push   %ebp
  800a66:	89 e5                	mov    %esp,%ebp
  800a68:	56                   	push   %esi
  800a69:	53                   	push   %ebx
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a70:	89 c6                	mov    %eax,%esi
  800a72:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a75:	39 f0                	cmp    %esi,%eax
  800a77:	74 1c                	je     800a95 <memcmp+0x34>
		if (*s1 != *s2)
  800a79:	0f b6 08             	movzbl (%eax),%ecx
  800a7c:	0f b6 1a             	movzbl (%edx),%ebx
  800a7f:	38 d9                	cmp    %bl,%cl
  800a81:	75 08                	jne    800a8b <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a83:	83 c0 01             	add    $0x1,%eax
  800a86:	83 c2 01             	add    $0x1,%edx
  800a89:	eb ea                	jmp    800a75 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a8b:	0f b6 c1             	movzbl %cl,%eax
  800a8e:	0f b6 db             	movzbl %bl,%ebx
  800a91:	29 d8                	sub    %ebx,%eax
  800a93:	eb 05                	jmp    800a9a <memcmp+0x39>
	}

	return 0;
  800a95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a9a:	5b                   	pop    %ebx
  800a9b:	5e                   	pop    %esi
  800a9c:	5d                   	pop    %ebp
  800a9d:	c3                   	ret    

00800a9e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a9e:	f3 0f 1e fb          	endbr32 
  800aa2:	55                   	push   %ebp
  800aa3:	89 e5                	mov    %esp,%ebp
  800aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800aab:	89 c2                	mov    %eax,%edx
  800aad:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ab0:	39 d0                	cmp    %edx,%eax
  800ab2:	73 09                	jae    800abd <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ab4:	38 08                	cmp    %cl,(%eax)
  800ab6:	74 05                	je     800abd <memfind+0x1f>
	for (; s < ends; s++)
  800ab8:	83 c0 01             	add    $0x1,%eax
  800abb:	eb f3                	jmp    800ab0 <memfind+0x12>
			break;
	return (void *) s;
}
  800abd:	5d                   	pop    %ebp
  800abe:	c3                   	ret    

00800abf <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800abf:	f3 0f 1e fb          	endbr32 
  800ac3:	55                   	push   %ebp
  800ac4:	89 e5                	mov    %esp,%ebp
  800ac6:	57                   	push   %edi
  800ac7:	56                   	push   %esi
  800ac8:	53                   	push   %ebx
  800ac9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800acc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800acf:	eb 03                	jmp    800ad4 <strtol+0x15>
		s++;
  800ad1:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ad4:	0f b6 01             	movzbl (%ecx),%eax
  800ad7:	3c 20                	cmp    $0x20,%al
  800ad9:	74 f6                	je     800ad1 <strtol+0x12>
  800adb:	3c 09                	cmp    $0x9,%al
  800add:	74 f2                	je     800ad1 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800adf:	3c 2b                	cmp    $0x2b,%al
  800ae1:	74 2a                	je     800b0d <strtol+0x4e>
	int neg = 0;
  800ae3:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ae8:	3c 2d                	cmp    $0x2d,%al
  800aea:	74 2b                	je     800b17 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800aec:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800af2:	75 0f                	jne    800b03 <strtol+0x44>
  800af4:	80 39 30             	cmpb   $0x30,(%ecx)
  800af7:	74 28                	je     800b21 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800af9:	85 db                	test   %ebx,%ebx
  800afb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b00:	0f 44 d8             	cmove  %eax,%ebx
  800b03:	b8 00 00 00 00       	mov    $0x0,%eax
  800b08:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b0b:	eb 46                	jmp    800b53 <strtol+0x94>
		s++;
  800b0d:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b10:	bf 00 00 00 00       	mov    $0x0,%edi
  800b15:	eb d5                	jmp    800aec <strtol+0x2d>
		s++, neg = 1;
  800b17:	83 c1 01             	add    $0x1,%ecx
  800b1a:	bf 01 00 00 00       	mov    $0x1,%edi
  800b1f:	eb cb                	jmp    800aec <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b21:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b25:	74 0e                	je     800b35 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b27:	85 db                	test   %ebx,%ebx
  800b29:	75 d8                	jne    800b03 <strtol+0x44>
		s++, base = 8;
  800b2b:	83 c1 01             	add    $0x1,%ecx
  800b2e:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b33:	eb ce                	jmp    800b03 <strtol+0x44>
		s += 2, base = 16;
  800b35:	83 c1 02             	add    $0x2,%ecx
  800b38:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b3d:	eb c4                	jmp    800b03 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b3f:	0f be d2             	movsbl %dl,%edx
  800b42:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b45:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b48:	7d 3a                	jge    800b84 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b4a:	83 c1 01             	add    $0x1,%ecx
  800b4d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b51:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b53:	0f b6 11             	movzbl (%ecx),%edx
  800b56:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b59:	89 f3                	mov    %esi,%ebx
  800b5b:	80 fb 09             	cmp    $0x9,%bl
  800b5e:	76 df                	jbe    800b3f <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b60:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b63:	89 f3                	mov    %esi,%ebx
  800b65:	80 fb 19             	cmp    $0x19,%bl
  800b68:	77 08                	ja     800b72 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b6a:	0f be d2             	movsbl %dl,%edx
  800b6d:	83 ea 57             	sub    $0x57,%edx
  800b70:	eb d3                	jmp    800b45 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b72:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b75:	89 f3                	mov    %esi,%ebx
  800b77:	80 fb 19             	cmp    $0x19,%bl
  800b7a:	77 08                	ja     800b84 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b7c:	0f be d2             	movsbl %dl,%edx
  800b7f:	83 ea 37             	sub    $0x37,%edx
  800b82:	eb c1                	jmp    800b45 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b84:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b88:	74 05                	je     800b8f <strtol+0xd0>
		*endptr = (char *) s;
  800b8a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b8d:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b8f:	89 c2                	mov    %eax,%edx
  800b91:	f7 da                	neg    %edx
  800b93:	85 ff                	test   %edi,%edi
  800b95:	0f 45 c2             	cmovne %edx,%eax
}
  800b98:	5b                   	pop    %ebx
  800b99:	5e                   	pop    %esi
  800b9a:	5f                   	pop    %edi
  800b9b:	5d                   	pop    %ebp
  800b9c:	c3                   	ret    

00800b9d <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b9d:	f3 0f 1e fb          	endbr32 
  800ba1:	55                   	push   %ebp
  800ba2:	89 e5                	mov    %esp,%ebp
  800ba4:	57                   	push   %edi
  800ba5:	56                   	push   %esi
  800ba6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ba7:	b8 00 00 00 00       	mov    $0x0,%eax
  800bac:	8b 55 08             	mov    0x8(%ebp),%edx
  800baf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bb2:	89 c3                	mov    %eax,%ebx
  800bb4:	89 c7                	mov    %eax,%edi
  800bb6:	89 c6                	mov    %eax,%esi
  800bb8:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bba:	5b                   	pop    %ebx
  800bbb:	5e                   	pop    %esi
  800bbc:	5f                   	pop    %edi
  800bbd:	5d                   	pop    %ebp
  800bbe:	c3                   	ret    

00800bbf <sys_cgetc>:

int
sys_cgetc(void)
{
  800bbf:	f3 0f 1e fb          	endbr32 
  800bc3:	55                   	push   %ebp
  800bc4:	89 e5                	mov    %esp,%ebp
  800bc6:	57                   	push   %edi
  800bc7:	56                   	push   %esi
  800bc8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bc9:	ba 00 00 00 00       	mov    $0x0,%edx
  800bce:	b8 01 00 00 00       	mov    $0x1,%eax
  800bd3:	89 d1                	mov    %edx,%ecx
  800bd5:	89 d3                	mov    %edx,%ebx
  800bd7:	89 d7                	mov    %edx,%edi
  800bd9:	89 d6                	mov    %edx,%esi
  800bdb:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bdd:	5b                   	pop    %ebx
  800bde:	5e                   	pop    %esi
  800bdf:	5f                   	pop    %edi
  800be0:	5d                   	pop    %ebp
  800be1:	c3                   	ret    

00800be2 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800be2:	f3 0f 1e fb          	endbr32 
  800be6:	55                   	push   %ebp
  800be7:	89 e5                	mov    %esp,%ebp
  800be9:	57                   	push   %edi
  800bea:	56                   	push   %esi
  800beb:	53                   	push   %ebx
  800bec:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bef:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bf4:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf7:	b8 03 00 00 00       	mov    $0x3,%eax
  800bfc:	89 cb                	mov    %ecx,%ebx
  800bfe:	89 cf                	mov    %ecx,%edi
  800c00:	89 ce                	mov    %ecx,%esi
  800c02:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c04:	85 c0                	test   %eax,%eax
  800c06:	7f 08                	jg     800c10 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c08:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c0b:	5b                   	pop    %ebx
  800c0c:	5e                   	pop    %esi
  800c0d:	5f                   	pop    %edi
  800c0e:	5d                   	pop    %ebp
  800c0f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c10:	83 ec 0c             	sub    $0xc,%esp
  800c13:	50                   	push   %eax
  800c14:	6a 03                	push   $0x3
  800c16:	68 bf 23 80 00       	push   $0x8023bf
  800c1b:	6a 23                	push   $0x23
  800c1d:	68 dc 23 80 00       	push   $0x8023dc
  800c22:	e8 13 f5 ff ff       	call   80013a <_panic>

00800c27 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c27:	f3 0f 1e fb          	endbr32 
  800c2b:	55                   	push   %ebp
  800c2c:	89 e5                	mov    %esp,%ebp
  800c2e:	57                   	push   %edi
  800c2f:	56                   	push   %esi
  800c30:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c31:	ba 00 00 00 00       	mov    $0x0,%edx
  800c36:	b8 02 00 00 00       	mov    $0x2,%eax
  800c3b:	89 d1                	mov    %edx,%ecx
  800c3d:	89 d3                	mov    %edx,%ebx
  800c3f:	89 d7                	mov    %edx,%edi
  800c41:	89 d6                	mov    %edx,%esi
  800c43:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c45:	5b                   	pop    %ebx
  800c46:	5e                   	pop    %esi
  800c47:	5f                   	pop    %edi
  800c48:	5d                   	pop    %ebp
  800c49:	c3                   	ret    

00800c4a <sys_yield>:

void
sys_yield(void)
{
  800c4a:	f3 0f 1e fb          	endbr32 
  800c4e:	55                   	push   %ebp
  800c4f:	89 e5                	mov    %esp,%ebp
  800c51:	57                   	push   %edi
  800c52:	56                   	push   %esi
  800c53:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c54:	ba 00 00 00 00       	mov    $0x0,%edx
  800c59:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c5e:	89 d1                	mov    %edx,%ecx
  800c60:	89 d3                	mov    %edx,%ebx
  800c62:	89 d7                	mov    %edx,%edi
  800c64:	89 d6                	mov    %edx,%esi
  800c66:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c68:	5b                   	pop    %ebx
  800c69:	5e                   	pop    %esi
  800c6a:	5f                   	pop    %edi
  800c6b:	5d                   	pop    %ebp
  800c6c:	c3                   	ret    

00800c6d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c6d:	f3 0f 1e fb          	endbr32 
  800c71:	55                   	push   %ebp
  800c72:	89 e5                	mov    %esp,%ebp
  800c74:	57                   	push   %edi
  800c75:	56                   	push   %esi
  800c76:	53                   	push   %ebx
  800c77:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c7a:	be 00 00 00 00       	mov    $0x0,%esi
  800c7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c85:	b8 04 00 00 00       	mov    $0x4,%eax
  800c8a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c8d:	89 f7                	mov    %esi,%edi
  800c8f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c91:	85 c0                	test   %eax,%eax
  800c93:	7f 08                	jg     800c9d <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c95:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c98:	5b                   	pop    %ebx
  800c99:	5e                   	pop    %esi
  800c9a:	5f                   	pop    %edi
  800c9b:	5d                   	pop    %ebp
  800c9c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c9d:	83 ec 0c             	sub    $0xc,%esp
  800ca0:	50                   	push   %eax
  800ca1:	6a 04                	push   $0x4
  800ca3:	68 bf 23 80 00       	push   $0x8023bf
  800ca8:	6a 23                	push   $0x23
  800caa:	68 dc 23 80 00       	push   $0x8023dc
  800caf:	e8 86 f4 ff ff       	call   80013a <_panic>

00800cb4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cb4:	f3 0f 1e fb          	endbr32 
  800cb8:	55                   	push   %ebp
  800cb9:	89 e5                	mov    %esp,%ebp
  800cbb:	57                   	push   %edi
  800cbc:	56                   	push   %esi
  800cbd:	53                   	push   %ebx
  800cbe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc7:	b8 05 00 00 00       	mov    $0x5,%eax
  800ccc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ccf:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cd2:	8b 75 18             	mov    0x18(%ebp),%esi
  800cd5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cd7:	85 c0                	test   %eax,%eax
  800cd9:	7f 08                	jg     800ce3 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cde:	5b                   	pop    %ebx
  800cdf:	5e                   	pop    %esi
  800ce0:	5f                   	pop    %edi
  800ce1:	5d                   	pop    %ebp
  800ce2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce3:	83 ec 0c             	sub    $0xc,%esp
  800ce6:	50                   	push   %eax
  800ce7:	6a 05                	push   $0x5
  800ce9:	68 bf 23 80 00       	push   $0x8023bf
  800cee:	6a 23                	push   $0x23
  800cf0:	68 dc 23 80 00       	push   $0x8023dc
  800cf5:	e8 40 f4 ff ff       	call   80013a <_panic>

00800cfa <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cfa:	f3 0f 1e fb          	endbr32 
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	57                   	push   %edi
  800d02:	56                   	push   %esi
  800d03:	53                   	push   %ebx
  800d04:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d07:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d12:	b8 06 00 00 00       	mov    $0x6,%eax
  800d17:	89 df                	mov    %ebx,%edi
  800d19:	89 de                	mov    %ebx,%esi
  800d1b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d1d:	85 c0                	test   %eax,%eax
  800d1f:	7f 08                	jg     800d29 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d24:	5b                   	pop    %ebx
  800d25:	5e                   	pop    %esi
  800d26:	5f                   	pop    %edi
  800d27:	5d                   	pop    %ebp
  800d28:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d29:	83 ec 0c             	sub    $0xc,%esp
  800d2c:	50                   	push   %eax
  800d2d:	6a 06                	push   $0x6
  800d2f:	68 bf 23 80 00       	push   $0x8023bf
  800d34:	6a 23                	push   $0x23
  800d36:	68 dc 23 80 00       	push   $0x8023dc
  800d3b:	e8 fa f3 ff ff       	call   80013a <_panic>

00800d40 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d40:	f3 0f 1e fb          	endbr32 
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
  800d47:	57                   	push   %edi
  800d48:	56                   	push   %esi
  800d49:	53                   	push   %ebx
  800d4a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d4d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d52:	8b 55 08             	mov    0x8(%ebp),%edx
  800d55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d58:	b8 08 00 00 00       	mov    $0x8,%eax
  800d5d:	89 df                	mov    %ebx,%edi
  800d5f:	89 de                	mov    %ebx,%esi
  800d61:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d63:	85 c0                	test   %eax,%eax
  800d65:	7f 08                	jg     800d6f <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6a:	5b                   	pop    %ebx
  800d6b:	5e                   	pop    %esi
  800d6c:	5f                   	pop    %edi
  800d6d:	5d                   	pop    %ebp
  800d6e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6f:	83 ec 0c             	sub    $0xc,%esp
  800d72:	50                   	push   %eax
  800d73:	6a 08                	push   $0x8
  800d75:	68 bf 23 80 00       	push   $0x8023bf
  800d7a:	6a 23                	push   $0x23
  800d7c:	68 dc 23 80 00       	push   $0x8023dc
  800d81:	e8 b4 f3 ff ff       	call   80013a <_panic>

00800d86 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d86:	f3 0f 1e fb          	endbr32 
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	57                   	push   %edi
  800d8e:	56                   	push   %esi
  800d8f:	53                   	push   %ebx
  800d90:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d93:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d98:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9e:	b8 09 00 00 00       	mov    $0x9,%eax
  800da3:	89 df                	mov    %ebx,%edi
  800da5:	89 de                	mov    %ebx,%esi
  800da7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da9:	85 c0                	test   %eax,%eax
  800dab:	7f 08                	jg     800db5 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db0:	5b                   	pop    %ebx
  800db1:	5e                   	pop    %esi
  800db2:	5f                   	pop    %edi
  800db3:	5d                   	pop    %ebp
  800db4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db5:	83 ec 0c             	sub    $0xc,%esp
  800db8:	50                   	push   %eax
  800db9:	6a 09                	push   $0x9
  800dbb:	68 bf 23 80 00       	push   $0x8023bf
  800dc0:	6a 23                	push   $0x23
  800dc2:	68 dc 23 80 00       	push   $0x8023dc
  800dc7:	e8 6e f3 ff ff       	call   80013a <_panic>

00800dcc <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dcc:	f3 0f 1e fb          	endbr32 
  800dd0:	55                   	push   %ebp
  800dd1:	89 e5                	mov    %esp,%ebp
  800dd3:	57                   	push   %edi
  800dd4:	56                   	push   %esi
  800dd5:	53                   	push   %ebx
  800dd6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dde:	8b 55 08             	mov    0x8(%ebp),%edx
  800de1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de4:	b8 0a 00 00 00       	mov    $0xa,%eax
  800de9:	89 df                	mov    %ebx,%edi
  800deb:	89 de                	mov    %ebx,%esi
  800ded:	cd 30                	int    $0x30
	if(check && ret > 0)
  800def:	85 c0                	test   %eax,%eax
  800df1:	7f 08                	jg     800dfb <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800df3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df6:	5b                   	pop    %ebx
  800df7:	5e                   	pop    %esi
  800df8:	5f                   	pop    %edi
  800df9:	5d                   	pop    %ebp
  800dfa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dfb:	83 ec 0c             	sub    $0xc,%esp
  800dfe:	50                   	push   %eax
  800dff:	6a 0a                	push   $0xa
  800e01:	68 bf 23 80 00       	push   $0x8023bf
  800e06:	6a 23                	push   $0x23
  800e08:	68 dc 23 80 00       	push   $0x8023dc
  800e0d:	e8 28 f3 ff ff       	call   80013a <_panic>

00800e12 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e12:	f3 0f 1e fb          	endbr32 
  800e16:	55                   	push   %ebp
  800e17:	89 e5                	mov    %esp,%ebp
  800e19:	57                   	push   %edi
  800e1a:	56                   	push   %esi
  800e1b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e22:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e27:	be 00 00 00 00       	mov    $0x0,%esi
  800e2c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e2f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e32:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e34:	5b                   	pop    %ebx
  800e35:	5e                   	pop    %esi
  800e36:	5f                   	pop    %edi
  800e37:	5d                   	pop    %ebp
  800e38:	c3                   	ret    

00800e39 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e39:	f3 0f 1e fb          	endbr32 
  800e3d:	55                   	push   %ebp
  800e3e:	89 e5                	mov    %esp,%ebp
  800e40:	57                   	push   %edi
  800e41:	56                   	push   %esi
  800e42:	53                   	push   %ebx
  800e43:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e46:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4e:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e53:	89 cb                	mov    %ecx,%ebx
  800e55:	89 cf                	mov    %ecx,%edi
  800e57:	89 ce                	mov    %ecx,%esi
  800e59:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e5b:	85 c0                	test   %eax,%eax
  800e5d:	7f 08                	jg     800e67 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e62:	5b                   	pop    %ebx
  800e63:	5e                   	pop    %esi
  800e64:	5f                   	pop    %edi
  800e65:	5d                   	pop    %ebp
  800e66:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e67:	83 ec 0c             	sub    $0xc,%esp
  800e6a:	50                   	push   %eax
  800e6b:	6a 0d                	push   $0xd
  800e6d:	68 bf 23 80 00       	push   $0x8023bf
  800e72:	6a 23                	push   $0x23
  800e74:	68 dc 23 80 00       	push   $0x8023dc
  800e79:	e8 bc f2 ff ff       	call   80013a <_panic>

00800e7e <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800e7e:	f3 0f 1e fb          	endbr32 
  800e82:	55                   	push   %ebp
  800e83:	89 e5                	mov    %esp,%ebp
  800e85:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800e88:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  800e8f:	74 0a                	je     800e9b <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	a3 08 40 80 00       	mov    %eax,0x804008
}
  800e99:	c9                   	leave  
  800e9a:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  800e9b:	83 ec 04             	sub    $0x4,%esp
  800e9e:	6a 07                	push   $0x7
  800ea0:	68 00 f0 bf ee       	push   $0xeebff000
  800ea5:	6a 00                	push   $0x0
  800ea7:	e8 c1 fd ff ff       	call   800c6d <sys_page_alloc>
  800eac:	83 c4 10             	add    $0x10,%esp
  800eaf:	85 c0                	test   %eax,%eax
  800eb1:	78 2a                	js     800edd <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  800eb3:	83 ec 08             	sub    $0x8,%esp
  800eb6:	68 f1 0e 80 00       	push   $0x800ef1
  800ebb:	6a 00                	push   $0x0
  800ebd:	e8 0a ff ff ff       	call   800dcc <sys_env_set_pgfault_upcall>
  800ec2:	83 c4 10             	add    $0x10,%esp
  800ec5:	85 c0                	test   %eax,%eax
  800ec7:	79 c8                	jns    800e91 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  800ec9:	83 ec 04             	sub    $0x4,%esp
  800ecc:	68 18 24 80 00       	push   $0x802418
  800ed1:	6a 25                	push   $0x25
  800ed3:	68 50 24 80 00       	push   $0x802450
  800ed8:	e8 5d f2 ff ff       	call   80013a <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  800edd:	83 ec 04             	sub    $0x4,%esp
  800ee0:	68 ec 23 80 00       	push   $0x8023ec
  800ee5:	6a 22                	push   $0x22
  800ee7:	68 50 24 80 00       	push   $0x802450
  800eec:	e8 49 f2 ff ff       	call   80013a <_panic>

00800ef1 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800ef1:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800ef2:	a1 08 40 80 00       	mov    0x804008,%eax
	call *%eax
  800ef7:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800ef9:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  800efc:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  800f00:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  800f04:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  800f07:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  800f09:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  800f0d:	83 c4 08             	add    $0x8,%esp
	popal
  800f10:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  800f11:	83 c4 04             	add    $0x4,%esp
	popfl
  800f14:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  800f15:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  800f16:	c3                   	ret    

00800f17 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f17:	f3 0f 1e fb          	endbr32 
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f21:	05 00 00 00 30       	add    $0x30000000,%eax
  800f26:	c1 e8 0c             	shr    $0xc,%eax
}
  800f29:	5d                   	pop    %ebp
  800f2a:	c3                   	ret    

00800f2b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f2b:	f3 0f 1e fb          	endbr32 
  800f2f:	55                   	push   %ebp
  800f30:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800f3a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f3f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f44:	5d                   	pop    %ebp
  800f45:	c3                   	ret    

00800f46 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f46:	f3 0f 1e fb          	endbr32 
  800f4a:	55                   	push   %ebp
  800f4b:	89 e5                	mov    %esp,%ebp
  800f4d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f52:	89 c2                	mov    %eax,%edx
  800f54:	c1 ea 16             	shr    $0x16,%edx
  800f57:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f5e:	f6 c2 01             	test   $0x1,%dl
  800f61:	74 2d                	je     800f90 <fd_alloc+0x4a>
  800f63:	89 c2                	mov    %eax,%edx
  800f65:	c1 ea 0c             	shr    $0xc,%edx
  800f68:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f6f:	f6 c2 01             	test   $0x1,%dl
  800f72:	74 1c                	je     800f90 <fd_alloc+0x4a>
  800f74:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f79:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f7e:	75 d2                	jne    800f52 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800f89:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f8e:	eb 0a                	jmp    800f9a <fd_alloc+0x54>
			*fd_store = fd;
  800f90:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f93:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f9a:	5d                   	pop    %ebp
  800f9b:	c3                   	ret    

00800f9c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f9c:	f3 0f 1e fb          	endbr32 
  800fa0:	55                   	push   %ebp
  800fa1:	89 e5                	mov    %esp,%ebp
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800fa6:	83 f8 1f             	cmp    $0x1f,%eax
  800fa9:	77 30                	ja     800fdb <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800fab:	c1 e0 0c             	shl    $0xc,%eax
  800fae:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800fb3:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800fb9:	f6 c2 01             	test   $0x1,%dl
  800fbc:	74 24                	je     800fe2 <fd_lookup+0x46>
  800fbe:	89 c2                	mov    %eax,%edx
  800fc0:	c1 ea 0c             	shr    $0xc,%edx
  800fc3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fca:	f6 c2 01             	test   $0x1,%dl
  800fcd:	74 1a                	je     800fe9 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800fcf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fd2:	89 02                	mov    %eax,(%edx)
	return 0;
  800fd4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fd9:	5d                   	pop    %ebp
  800fda:	c3                   	ret    
		return -E_INVAL;
  800fdb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fe0:	eb f7                	jmp    800fd9 <fd_lookup+0x3d>
		return -E_INVAL;
  800fe2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fe7:	eb f0                	jmp    800fd9 <fd_lookup+0x3d>
  800fe9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fee:	eb e9                	jmp    800fd9 <fd_lookup+0x3d>

00800ff0 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800ff0:	f3 0f 1e fb          	endbr32 
  800ff4:	55                   	push   %ebp
  800ff5:	89 e5                	mov    %esp,%ebp
  800ff7:	83 ec 08             	sub    $0x8,%esp
  800ffa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ffd:	ba dc 24 80 00       	mov    $0x8024dc,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801002:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801007:	39 08                	cmp    %ecx,(%eax)
  801009:	74 33                	je     80103e <dev_lookup+0x4e>
  80100b:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80100e:	8b 02                	mov    (%edx),%eax
  801010:	85 c0                	test   %eax,%eax
  801012:	75 f3                	jne    801007 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801014:	a1 04 40 80 00       	mov    0x804004,%eax
  801019:	8b 40 48             	mov    0x48(%eax),%eax
  80101c:	83 ec 04             	sub    $0x4,%esp
  80101f:	51                   	push   %ecx
  801020:	50                   	push   %eax
  801021:	68 60 24 80 00       	push   $0x802460
  801026:	e8 f6 f1 ff ff       	call   800221 <cprintf>
	*dev = 0;
  80102b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801034:	83 c4 10             	add    $0x10,%esp
  801037:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80103c:	c9                   	leave  
  80103d:	c3                   	ret    
			*dev = devtab[i];
  80103e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801041:	89 01                	mov    %eax,(%ecx)
			return 0;
  801043:	b8 00 00 00 00       	mov    $0x0,%eax
  801048:	eb f2                	jmp    80103c <dev_lookup+0x4c>

0080104a <fd_close>:
{
  80104a:	f3 0f 1e fb          	endbr32 
  80104e:	55                   	push   %ebp
  80104f:	89 e5                	mov    %esp,%ebp
  801051:	57                   	push   %edi
  801052:	56                   	push   %esi
  801053:	53                   	push   %ebx
  801054:	83 ec 24             	sub    $0x24,%esp
  801057:	8b 75 08             	mov    0x8(%ebp),%esi
  80105a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80105d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801060:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801061:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801067:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80106a:	50                   	push   %eax
  80106b:	e8 2c ff ff ff       	call   800f9c <fd_lookup>
  801070:	89 c3                	mov    %eax,%ebx
  801072:	83 c4 10             	add    $0x10,%esp
  801075:	85 c0                	test   %eax,%eax
  801077:	78 05                	js     80107e <fd_close+0x34>
	    || fd != fd2)
  801079:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80107c:	74 16                	je     801094 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80107e:	89 f8                	mov    %edi,%eax
  801080:	84 c0                	test   %al,%al
  801082:	b8 00 00 00 00       	mov    $0x0,%eax
  801087:	0f 44 d8             	cmove  %eax,%ebx
}
  80108a:	89 d8                	mov    %ebx,%eax
  80108c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80108f:	5b                   	pop    %ebx
  801090:	5e                   	pop    %esi
  801091:	5f                   	pop    %edi
  801092:	5d                   	pop    %ebp
  801093:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801094:	83 ec 08             	sub    $0x8,%esp
  801097:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80109a:	50                   	push   %eax
  80109b:	ff 36                	pushl  (%esi)
  80109d:	e8 4e ff ff ff       	call   800ff0 <dev_lookup>
  8010a2:	89 c3                	mov    %eax,%ebx
  8010a4:	83 c4 10             	add    $0x10,%esp
  8010a7:	85 c0                	test   %eax,%eax
  8010a9:	78 1a                	js     8010c5 <fd_close+0x7b>
		if (dev->dev_close)
  8010ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010ae:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8010b1:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8010b6:	85 c0                	test   %eax,%eax
  8010b8:	74 0b                	je     8010c5 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8010ba:	83 ec 0c             	sub    $0xc,%esp
  8010bd:	56                   	push   %esi
  8010be:	ff d0                	call   *%eax
  8010c0:	89 c3                	mov    %eax,%ebx
  8010c2:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8010c5:	83 ec 08             	sub    $0x8,%esp
  8010c8:	56                   	push   %esi
  8010c9:	6a 00                	push   $0x0
  8010cb:	e8 2a fc ff ff       	call   800cfa <sys_page_unmap>
	return r;
  8010d0:	83 c4 10             	add    $0x10,%esp
  8010d3:	eb b5                	jmp    80108a <fd_close+0x40>

008010d5 <close>:

int
close(int fdnum)
{
  8010d5:	f3 0f 1e fb          	endbr32 
  8010d9:	55                   	push   %ebp
  8010da:	89 e5                	mov    %esp,%ebp
  8010dc:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010e2:	50                   	push   %eax
  8010e3:	ff 75 08             	pushl  0x8(%ebp)
  8010e6:	e8 b1 fe ff ff       	call   800f9c <fd_lookup>
  8010eb:	83 c4 10             	add    $0x10,%esp
  8010ee:	85 c0                	test   %eax,%eax
  8010f0:	79 02                	jns    8010f4 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8010f2:	c9                   	leave  
  8010f3:	c3                   	ret    
		return fd_close(fd, 1);
  8010f4:	83 ec 08             	sub    $0x8,%esp
  8010f7:	6a 01                	push   $0x1
  8010f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8010fc:	e8 49 ff ff ff       	call   80104a <fd_close>
  801101:	83 c4 10             	add    $0x10,%esp
  801104:	eb ec                	jmp    8010f2 <close+0x1d>

00801106 <close_all>:

void
close_all(void)
{
  801106:	f3 0f 1e fb          	endbr32 
  80110a:	55                   	push   %ebp
  80110b:	89 e5                	mov    %esp,%ebp
  80110d:	53                   	push   %ebx
  80110e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801111:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801116:	83 ec 0c             	sub    $0xc,%esp
  801119:	53                   	push   %ebx
  80111a:	e8 b6 ff ff ff       	call   8010d5 <close>
	for (i = 0; i < MAXFD; i++)
  80111f:	83 c3 01             	add    $0x1,%ebx
  801122:	83 c4 10             	add    $0x10,%esp
  801125:	83 fb 20             	cmp    $0x20,%ebx
  801128:	75 ec                	jne    801116 <close_all+0x10>
}
  80112a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80112d:	c9                   	leave  
  80112e:	c3                   	ret    

0080112f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80112f:	f3 0f 1e fb          	endbr32 
  801133:	55                   	push   %ebp
  801134:	89 e5                	mov    %esp,%ebp
  801136:	57                   	push   %edi
  801137:	56                   	push   %esi
  801138:	53                   	push   %ebx
  801139:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80113c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80113f:	50                   	push   %eax
  801140:	ff 75 08             	pushl  0x8(%ebp)
  801143:	e8 54 fe ff ff       	call   800f9c <fd_lookup>
  801148:	89 c3                	mov    %eax,%ebx
  80114a:	83 c4 10             	add    $0x10,%esp
  80114d:	85 c0                	test   %eax,%eax
  80114f:	0f 88 81 00 00 00    	js     8011d6 <dup+0xa7>
		return r;
	close(newfdnum);
  801155:	83 ec 0c             	sub    $0xc,%esp
  801158:	ff 75 0c             	pushl  0xc(%ebp)
  80115b:	e8 75 ff ff ff       	call   8010d5 <close>

	newfd = INDEX2FD(newfdnum);
  801160:	8b 75 0c             	mov    0xc(%ebp),%esi
  801163:	c1 e6 0c             	shl    $0xc,%esi
  801166:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80116c:	83 c4 04             	add    $0x4,%esp
  80116f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801172:	e8 b4 fd ff ff       	call   800f2b <fd2data>
  801177:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801179:	89 34 24             	mov    %esi,(%esp)
  80117c:	e8 aa fd ff ff       	call   800f2b <fd2data>
  801181:	83 c4 10             	add    $0x10,%esp
  801184:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801186:	89 d8                	mov    %ebx,%eax
  801188:	c1 e8 16             	shr    $0x16,%eax
  80118b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801192:	a8 01                	test   $0x1,%al
  801194:	74 11                	je     8011a7 <dup+0x78>
  801196:	89 d8                	mov    %ebx,%eax
  801198:	c1 e8 0c             	shr    $0xc,%eax
  80119b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011a2:	f6 c2 01             	test   $0x1,%dl
  8011a5:	75 39                	jne    8011e0 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8011a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011aa:	89 d0                	mov    %edx,%eax
  8011ac:	c1 e8 0c             	shr    $0xc,%eax
  8011af:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011b6:	83 ec 0c             	sub    $0xc,%esp
  8011b9:	25 07 0e 00 00       	and    $0xe07,%eax
  8011be:	50                   	push   %eax
  8011bf:	56                   	push   %esi
  8011c0:	6a 00                	push   $0x0
  8011c2:	52                   	push   %edx
  8011c3:	6a 00                	push   $0x0
  8011c5:	e8 ea fa ff ff       	call   800cb4 <sys_page_map>
  8011ca:	89 c3                	mov    %eax,%ebx
  8011cc:	83 c4 20             	add    $0x20,%esp
  8011cf:	85 c0                	test   %eax,%eax
  8011d1:	78 31                	js     801204 <dup+0xd5>
		goto err;

	return newfdnum;
  8011d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8011d6:	89 d8                	mov    %ebx,%eax
  8011d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011db:	5b                   	pop    %ebx
  8011dc:	5e                   	pop    %esi
  8011dd:	5f                   	pop    %edi
  8011de:	5d                   	pop    %ebp
  8011df:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8011e0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011e7:	83 ec 0c             	sub    $0xc,%esp
  8011ea:	25 07 0e 00 00       	and    $0xe07,%eax
  8011ef:	50                   	push   %eax
  8011f0:	57                   	push   %edi
  8011f1:	6a 00                	push   $0x0
  8011f3:	53                   	push   %ebx
  8011f4:	6a 00                	push   $0x0
  8011f6:	e8 b9 fa ff ff       	call   800cb4 <sys_page_map>
  8011fb:	89 c3                	mov    %eax,%ebx
  8011fd:	83 c4 20             	add    $0x20,%esp
  801200:	85 c0                	test   %eax,%eax
  801202:	79 a3                	jns    8011a7 <dup+0x78>
	sys_page_unmap(0, newfd);
  801204:	83 ec 08             	sub    $0x8,%esp
  801207:	56                   	push   %esi
  801208:	6a 00                	push   $0x0
  80120a:	e8 eb fa ff ff       	call   800cfa <sys_page_unmap>
	sys_page_unmap(0, nva);
  80120f:	83 c4 08             	add    $0x8,%esp
  801212:	57                   	push   %edi
  801213:	6a 00                	push   $0x0
  801215:	e8 e0 fa ff ff       	call   800cfa <sys_page_unmap>
	return r;
  80121a:	83 c4 10             	add    $0x10,%esp
  80121d:	eb b7                	jmp    8011d6 <dup+0xa7>

0080121f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80121f:	f3 0f 1e fb          	endbr32 
  801223:	55                   	push   %ebp
  801224:	89 e5                	mov    %esp,%ebp
  801226:	53                   	push   %ebx
  801227:	83 ec 1c             	sub    $0x1c,%esp
  80122a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80122d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801230:	50                   	push   %eax
  801231:	53                   	push   %ebx
  801232:	e8 65 fd ff ff       	call   800f9c <fd_lookup>
  801237:	83 c4 10             	add    $0x10,%esp
  80123a:	85 c0                	test   %eax,%eax
  80123c:	78 3f                	js     80127d <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80123e:	83 ec 08             	sub    $0x8,%esp
  801241:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801244:	50                   	push   %eax
  801245:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801248:	ff 30                	pushl  (%eax)
  80124a:	e8 a1 fd ff ff       	call   800ff0 <dev_lookup>
  80124f:	83 c4 10             	add    $0x10,%esp
  801252:	85 c0                	test   %eax,%eax
  801254:	78 27                	js     80127d <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801256:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801259:	8b 42 08             	mov    0x8(%edx),%eax
  80125c:	83 e0 03             	and    $0x3,%eax
  80125f:	83 f8 01             	cmp    $0x1,%eax
  801262:	74 1e                	je     801282 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801264:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801267:	8b 40 08             	mov    0x8(%eax),%eax
  80126a:	85 c0                	test   %eax,%eax
  80126c:	74 35                	je     8012a3 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80126e:	83 ec 04             	sub    $0x4,%esp
  801271:	ff 75 10             	pushl  0x10(%ebp)
  801274:	ff 75 0c             	pushl  0xc(%ebp)
  801277:	52                   	push   %edx
  801278:	ff d0                	call   *%eax
  80127a:	83 c4 10             	add    $0x10,%esp
}
  80127d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801280:	c9                   	leave  
  801281:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801282:	a1 04 40 80 00       	mov    0x804004,%eax
  801287:	8b 40 48             	mov    0x48(%eax),%eax
  80128a:	83 ec 04             	sub    $0x4,%esp
  80128d:	53                   	push   %ebx
  80128e:	50                   	push   %eax
  80128f:	68 a1 24 80 00       	push   $0x8024a1
  801294:	e8 88 ef ff ff       	call   800221 <cprintf>
		return -E_INVAL;
  801299:	83 c4 10             	add    $0x10,%esp
  80129c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012a1:	eb da                	jmp    80127d <read+0x5e>
		return -E_NOT_SUPP;
  8012a3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012a8:	eb d3                	jmp    80127d <read+0x5e>

008012aa <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8012aa:	f3 0f 1e fb          	endbr32 
  8012ae:	55                   	push   %ebp
  8012af:	89 e5                	mov    %esp,%ebp
  8012b1:	57                   	push   %edi
  8012b2:	56                   	push   %esi
  8012b3:	53                   	push   %ebx
  8012b4:	83 ec 0c             	sub    $0xc,%esp
  8012b7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012ba:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8012bd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012c2:	eb 02                	jmp    8012c6 <readn+0x1c>
  8012c4:	01 c3                	add    %eax,%ebx
  8012c6:	39 f3                	cmp    %esi,%ebx
  8012c8:	73 21                	jae    8012eb <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012ca:	83 ec 04             	sub    $0x4,%esp
  8012cd:	89 f0                	mov    %esi,%eax
  8012cf:	29 d8                	sub    %ebx,%eax
  8012d1:	50                   	push   %eax
  8012d2:	89 d8                	mov    %ebx,%eax
  8012d4:	03 45 0c             	add    0xc(%ebp),%eax
  8012d7:	50                   	push   %eax
  8012d8:	57                   	push   %edi
  8012d9:	e8 41 ff ff ff       	call   80121f <read>
		if (m < 0)
  8012de:	83 c4 10             	add    $0x10,%esp
  8012e1:	85 c0                	test   %eax,%eax
  8012e3:	78 04                	js     8012e9 <readn+0x3f>
			return m;
		if (m == 0)
  8012e5:	75 dd                	jne    8012c4 <readn+0x1a>
  8012e7:	eb 02                	jmp    8012eb <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012e9:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8012eb:	89 d8                	mov    %ebx,%eax
  8012ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012f0:	5b                   	pop    %ebx
  8012f1:	5e                   	pop    %esi
  8012f2:	5f                   	pop    %edi
  8012f3:	5d                   	pop    %ebp
  8012f4:	c3                   	ret    

008012f5 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8012f5:	f3 0f 1e fb          	endbr32 
  8012f9:	55                   	push   %ebp
  8012fa:	89 e5                	mov    %esp,%ebp
  8012fc:	53                   	push   %ebx
  8012fd:	83 ec 1c             	sub    $0x1c,%esp
  801300:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801303:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801306:	50                   	push   %eax
  801307:	53                   	push   %ebx
  801308:	e8 8f fc ff ff       	call   800f9c <fd_lookup>
  80130d:	83 c4 10             	add    $0x10,%esp
  801310:	85 c0                	test   %eax,%eax
  801312:	78 3a                	js     80134e <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801314:	83 ec 08             	sub    $0x8,%esp
  801317:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80131a:	50                   	push   %eax
  80131b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80131e:	ff 30                	pushl  (%eax)
  801320:	e8 cb fc ff ff       	call   800ff0 <dev_lookup>
  801325:	83 c4 10             	add    $0x10,%esp
  801328:	85 c0                	test   %eax,%eax
  80132a:	78 22                	js     80134e <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80132c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80132f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801333:	74 1e                	je     801353 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801335:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801338:	8b 52 0c             	mov    0xc(%edx),%edx
  80133b:	85 d2                	test   %edx,%edx
  80133d:	74 35                	je     801374 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80133f:	83 ec 04             	sub    $0x4,%esp
  801342:	ff 75 10             	pushl  0x10(%ebp)
  801345:	ff 75 0c             	pushl  0xc(%ebp)
  801348:	50                   	push   %eax
  801349:	ff d2                	call   *%edx
  80134b:	83 c4 10             	add    $0x10,%esp
}
  80134e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801351:	c9                   	leave  
  801352:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801353:	a1 04 40 80 00       	mov    0x804004,%eax
  801358:	8b 40 48             	mov    0x48(%eax),%eax
  80135b:	83 ec 04             	sub    $0x4,%esp
  80135e:	53                   	push   %ebx
  80135f:	50                   	push   %eax
  801360:	68 bd 24 80 00       	push   $0x8024bd
  801365:	e8 b7 ee ff ff       	call   800221 <cprintf>
		return -E_INVAL;
  80136a:	83 c4 10             	add    $0x10,%esp
  80136d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801372:	eb da                	jmp    80134e <write+0x59>
		return -E_NOT_SUPP;
  801374:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801379:	eb d3                	jmp    80134e <write+0x59>

0080137b <seek>:

int
seek(int fdnum, off_t offset)
{
  80137b:	f3 0f 1e fb          	endbr32 
  80137f:	55                   	push   %ebp
  801380:	89 e5                	mov    %esp,%ebp
  801382:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801385:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801388:	50                   	push   %eax
  801389:	ff 75 08             	pushl  0x8(%ebp)
  80138c:	e8 0b fc ff ff       	call   800f9c <fd_lookup>
  801391:	83 c4 10             	add    $0x10,%esp
  801394:	85 c0                	test   %eax,%eax
  801396:	78 0e                	js     8013a6 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801398:	8b 55 0c             	mov    0xc(%ebp),%edx
  80139b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80139e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8013a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013a6:	c9                   	leave  
  8013a7:	c3                   	ret    

008013a8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8013a8:	f3 0f 1e fb          	endbr32 
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
  8013af:	53                   	push   %ebx
  8013b0:	83 ec 1c             	sub    $0x1c,%esp
  8013b3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013b6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013b9:	50                   	push   %eax
  8013ba:	53                   	push   %ebx
  8013bb:	e8 dc fb ff ff       	call   800f9c <fd_lookup>
  8013c0:	83 c4 10             	add    $0x10,%esp
  8013c3:	85 c0                	test   %eax,%eax
  8013c5:	78 37                	js     8013fe <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013c7:	83 ec 08             	sub    $0x8,%esp
  8013ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013cd:	50                   	push   %eax
  8013ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d1:	ff 30                	pushl  (%eax)
  8013d3:	e8 18 fc ff ff       	call   800ff0 <dev_lookup>
  8013d8:	83 c4 10             	add    $0x10,%esp
  8013db:	85 c0                	test   %eax,%eax
  8013dd:	78 1f                	js     8013fe <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013e2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013e6:	74 1b                	je     801403 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8013e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013eb:	8b 52 18             	mov    0x18(%edx),%edx
  8013ee:	85 d2                	test   %edx,%edx
  8013f0:	74 32                	je     801424 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8013f2:	83 ec 08             	sub    $0x8,%esp
  8013f5:	ff 75 0c             	pushl  0xc(%ebp)
  8013f8:	50                   	push   %eax
  8013f9:	ff d2                	call   *%edx
  8013fb:	83 c4 10             	add    $0x10,%esp
}
  8013fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801401:	c9                   	leave  
  801402:	c3                   	ret    
			thisenv->env_id, fdnum);
  801403:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801408:	8b 40 48             	mov    0x48(%eax),%eax
  80140b:	83 ec 04             	sub    $0x4,%esp
  80140e:	53                   	push   %ebx
  80140f:	50                   	push   %eax
  801410:	68 80 24 80 00       	push   $0x802480
  801415:	e8 07 ee ff ff       	call   800221 <cprintf>
		return -E_INVAL;
  80141a:	83 c4 10             	add    $0x10,%esp
  80141d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801422:	eb da                	jmp    8013fe <ftruncate+0x56>
		return -E_NOT_SUPP;
  801424:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801429:	eb d3                	jmp    8013fe <ftruncate+0x56>

0080142b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80142b:	f3 0f 1e fb          	endbr32 
  80142f:	55                   	push   %ebp
  801430:	89 e5                	mov    %esp,%ebp
  801432:	53                   	push   %ebx
  801433:	83 ec 1c             	sub    $0x1c,%esp
  801436:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801439:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80143c:	50                   	push   %eax
  80143d:	ff 75 08             	pushl  0x8(%ebp)
  801440:	e8 57 fb ff ff       	call   800f9c <fd_lookup>
  801445:	83 c4 10             	add    $0x10,%esp
  801448:	85 c0                	test   %eax,%eax
  80144a:	78 4b                	js     801497 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80144c:	83 ec 08             	sub    $0x8,%esp
  80144f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801452:	50                   	push   %eax
  801453:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801456:	ff 30                	pushl  (%eax)
  801458:	e8 93 fb ff ff       	call   800ff0 <dev_lookup>
  80145d:	83 c4 10             	add    $0x10,%esp
  801460:	85 c0                	test   %eax,%eax
  801462:	78 33                	js     801497 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801467:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80146b:	74 2f                	je     80149c <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80146d:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801470:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801477:	00 00 00 
	stat->st_isdir = 0;
  80147a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801481:	00 00 00 
	stat->st_dev = dev;
  801484:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80148a:	83 ec 08             	sub    $0x8,%esp
  80148d:	53                   	push   %ebx
  80148e:	ff 75 f0             	pushl  -0x10(%ebp)
  801491:	ff 50 14             	call   *0x14(%eax)
  801494:	83 c4 10             	add    $0x10,%esp
}
  801497:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80149a:	c9                   	leave  
  80149b:	c3                   	ret    
		return -E_NOT_SUPP;
  80149c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014a1:	eb f4                	jmp    801497 <fstat+0x6c>

008014a3 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8014a3:	f3 0f 1e fb          	endbr32 
  8014a7:	55                   	push   %ebp
  8014a8:	89 e5                	mov    %esp,%ebp
  8014aa:	56                   	push   %esi
  8014ab:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8014ac:	83 ec 08             	sub    $0x8,%esp
  8014af:	6a 00                	push   $0x0
  8014b1:	ff 75 08             	pushl  0x8(%ebp)
  8014b4:	e8 fb 01 00 00       	call   8016b4 <open>
  8014b9:	89 c3                	mov    %eax,%ebx
  8014bb:	83 c4 10             	add    $0x10,%esp
  8014be:	85 c0                	test   %eax,%eax
  8014c0:	78 1b                	js     8014dd <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8014c2:	83 ec 08             	sub    $0x8,%esp
  8014c5:	ff 75 0c             	pushl  0xc(%ebp)
  8014c8:	50                   	push   %eax
  8014c9:	e8 5d ff ff ff       	call   80142b <fstat>
  8014ce:	89 c6                	mov    %eax,%esi
	close(fd);
  8014d0:	89 1c 24             	mov    %ebx,(%esp)
  8014d3:	e8 fd fb ff ff       	call   8010d5 <close>
	return r;
  8014d8:	83 c4 10             	add    $0x10,%esp
  8014db:	89 f3                	mov    %esi,%ebx
}
  8014dd:	89 d8                	mov    %ebx,%eax
  8014df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014e2:	5b                   	pop    %ebx
  8014e3:	5e                   	pop    %esi
  8014e4:	5d                   	pop    %ebp
  8014e5:	c3                   	ret    

008014e6 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
  8014e9:	56                   	push   %esi
  8014ea:	53                   	push   %ebx
  8014eb:	89 c6                	mov    %eax,%esi
  8014ed:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8014ef:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8014f6:	74 27                	je     80151f <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8014f8:	6a 07                	push   $0x7
  8014fa:	68 00 50 80 00       	push   $0x805000
  8014ff:	56                   	push   %esi
  801500:	ff 35 00 40 80 00    	pushl  0x804000
  801506:	e8 d6 07 00 00       	call   801ce1 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80150b:	83 c4 0c             	add    $0xc,%esp
  80150e:	6a 00                	push   $0x0
  801510:	53                   	push   %ebx
  801511:	6a 00                	push   $0x0
  801513:	e8 44 07 00 00       	call   801c5c <ipc_recv>
}
  801518:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80151b:	5b                   	pop    %ebx
  80151c:	5e                   	pop    %esi
  80151d:	5d                   	pop    %ebp
  80151e:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80151f:	83 ec 0c             	sub    $0xc,%esp
  801522:	6a 01                	push   $0x1
  801524:	e8 10 08 00 00       	call   801d39 <ipc_find_env>
  801529:	a3 00 40 80 00       	mov    %eax,0x804000
  80152e:	83 c4 10             	add    $0x10,%esp
  801531:	eb c5                	jmp    8014f8 <fsipc+0x12>

00801533 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801533:	f3 0f 1e fb          	endbr32 
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
  80153a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80153d:	8b 45 08             	mov    0x8(%ebp),%eax
  801540:	8b 40 0c             	mov    0xc(%eax),%eax
  801543:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801548:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154b:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801550:	ba 00 00 00 00       	mov    $0x0,%edx
  801555:	b8 02 00 00 00       	mov    $0x2,%eax
  80155a:	e8 87 ff ff ff       	call   8014e6 <fsipc>
}
  80155f:	c9                   	leave  
  801560:	c3                   	ret    

00801561 <devfile_flush>:
{
  801561:	f3 0f 1e fb          	endbr32 
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
  801568:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	8b 40 0c             	mov    0xc(%eax),%eax
  801571:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801576:	ba 00 00 00 00       	mov    $0x0,%edx
  80157b:	b8 06 00 00 00       	mov    $0x6,%eax
  801580:	e8 61 ff ff ff       	call   8014e6 <fsipc>
}
  801585:	c9                   	leave  
  801586:	c3                   	ret    

00801587 <devfile_stat>:
{
  801587:	f3 0f 1e fb          	endbr32 
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
  80158e:	53                   	push   %ebx
  80158f:	83 ec 04             	sub    $0x4,%esp
  801592:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801595:	8b 45 08             	mov    0x8(%ebp),%eax
  801598:	8b 40 0c             	mov    0xc(%eax),%eax
  80159b:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8015a5:	b8 05 00 00 00       	mov    $0x5,%eax
  8015aa:	e8 37 ff ff ff       	call   8014e6 <fsipc>
  8015af:	85 c0                	test   %eax,%eax
  8015b1:	78 2c                	js     8015df <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8015b3:	83 ec 08             	sub    $0x8,%esp
  8015b6:	68 00 50 80 00       	push   $0x805000
  8015bb:	53                   	push   %ebx
  8015bc:	e8 6a f2 ff ff       	call   80082b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8015c1:	a1 80 50 80 00       	mov    0x805080,%eax
  8015c6:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8015cc:	a1 84 50 80 00       	mov    0x805084,%eax
  8015d1:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8015d7:	83 c4 10             	add    $0x10,%esp
  8015da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015e2:	c9                   	leave  
  8015e3:	c3                   	ret    

008015e4 <devfile_write>:
{
  8015e4:	f3 0f 1e fb          	endbr32 
  8015e8:	55                   	push   %ebp
  8015e9:	89 e5                	mov    %esp,%ebp
  8015eb:	83 ec 0c             	sub    $0xc,%esp
  8015ee:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8015f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8015f4:	8b 52 0c             	mov    0xc(%edx),%edx
  8015f7:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  8015fd:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801602:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801607:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  80160a:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  80160f:	50                   	push   %eax
  801610:	ff 75 0c             	pushl  0xc(%ebp)
  801613:	68 08 50 80 00       	push   $0x805008
  801618:	e8 c4 f3 ff ff       	call   8009e1 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  80161d:	ba 00 00 00 00       	mov    $0x0,%edx
  801622:	b8 04 00 00 00       	mov    $0x4,%eax
  801627:	e8 ba fe ff ff       	call   8014e6 <fsipc>
}
  80162c:	c9                   	leave  
  80162d:	c3                   	ret    

0080162e <devfile_read>:
{
  80162e:	f3 0f 1e fb          	endbr32 
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
  801635:	56                   	push   %esi
  801636:	53                   	push   %ebx
  801637:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80163a:	8b 45 08             	mov    0x8(%ebp),%eax
  80163d:	8b 40 0c             	mov    0xc(%eax),%eax
  801640:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801645:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80164b:	ba 00 00 00 00       	mov    $0x0,%edx
  801650:	b8 03 00 00 00       	mov    $0x3,%eax
  801655:	e8 8c fe ff ff       	call   8014e6 <fsipc>
  80165a:	89 c3                	mov    %eax,%ebx
  80165c:	85 c0                	test   %eax,%eax
  80165e:	78 1f                	js     80167f <devfile_read+0x51>
	assert(r <= n);
  801660:	39 f0                	cmp    %esi,%eax
  801662:	77 24                	ja     801688 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801664:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801669:	7f 33                	jg     80169e <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80166b:	83 ec 04             	sub    $0x4,%esp
  80166e:	50                   	push   %eax
  80166f:	68 00 50 80 00       	push   $0x805000
  801674:	ff 75 0c             	pushl  0xc(%ebp)
  801677:	e8 65 f3 ff ff       	call   8009e1 <memmove>
	return r;
  80167c:	83 c4 10             	add    $0x10,%esp
}
  80167f:	89 d8                	mov    %ebx,%eax
  801681:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801684:	5b                   	pop    %ebx
  801685:	5e                   	pop    %esi
  801686:	5d                   	pop    %ebp
  801687:	c3                   	ret    
	assert(r <= n);
  801688:	68 ec 24 80 00       	push   $0x8024ec
  80168d:	68 f3 24 80 00       	push   $0x8024f3
  801692:	6a 7c                	push   $0x7c
  801694:	68 08 25 80 00       	push   $0x802508
  801699:	e8 9c ea ff ff       	call   80013a <_panic>
	assert(r <= PGSIZE);
  80169e:	68 13 25 80 00       	push   $0x802513
  8016a3:	68 f3 24 80 00       	push   $0x8024f3
  8016a8:	6a 7d                	push   $0x7d
  8016aa:	68 08 25 80 00       	push   $0x802508
  8016af:	e8 86 ea ff ff       	call   80013a <_panic>

008016b4 <open>:
{
  8016b4:	f3 0f 1e fb          	endbr32 
  8016b8:	55                   	push   %ebp
  8016b9:	89 e5                	mov    %esp,%ebp
  8016bb:	56                   	push   %esi
  8016bc:	53                   	push   %ebx
  8016bd:	83 ec 1c             	sub    $0x1c,%esp
  8016c0:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8016c3:	56                   	push   %esi
  8016c4:	e8 1f f1 ff ff       	call   8007e8 <strlen>
  8016c9:	83 c4 10             	add    $0x10,%esp
  8016cc:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8016d1:	7f 6c                	jg     80173f <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8016d3:	83 ec 0c             	sub    $0xc,%esp
  8016d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016d9:	50                   	push   %eax
  8016da:	e8 67 f8 ff ff       	call   800f46 <fd_alloc>
  8016df:	89 c3                	mov    %eax,%ebx
  8016e1:	83 c4 10             	add    $0x10,%esp
  8016e4:	85 c0                	test   %eax,%eax
  8016e6:	78 3c                	js     801724 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8016e8:	83 ec 08             	sub    $0x8,%esp
  8016eb:	56                   	push   %esi
  8016ec:	68 00 50 80 00       	push   $0x805000
  8016f1:	e8 35 f1 ff ff       	call   80082b <strcpy>
	fsipcbuf.open.req_omode = mode;
  8016f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f9:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8016fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801701:	b8 01 00 00 00       	mov    $0x1,%eax
  801706:	e8 db fd ff ff       	call   8014e6 <fsipc>
  80170b:	89 c3                	mov    %eax,%ebx
  80170d:	83 c4 10             	add    $0x10,%esp
  801710:	85 c0                	test   %eax,%eax
  801712:	78 19                	js     80172d <open+0x79>
	return fd2num(fd);
  801714:	83 ec 0c             	sub    $0xc,%esp
  801717:	ff 75 f4             	pushl  -0xc(%ebp)
  80171a:	e8 f8 f7 ff ff       	call   800f17 <fd2num>
  80171f:	89 c3                	mov    %eax,%ebx
  801721:	83 c4 10             	add    $0x10,%esp
}
  801724:	89 d8                	mov    %ebx,%eax
  801726:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801729:	5b                   	pop    %ebx
  80172a:	5e                   	pop    %esi
  80172b:	5d                   	pop    %ebp
  80172c:	c3                   	ret    
		fd_close(fd, 0);
  80172d:	83 ec 08             	sub    $0x8,%esp
  801730:	6a 00                	push   $0x0
  801732:	ff 75 f4             	pushl  -0xc(%ebp)
  801735:	e8 10 f9 ff ff       	call   80104a <fd_close>
		return r;
  80173a:	83 c4 10             	add    $0x10,%esp
  80173d:	eb e5                	jmp    801724 <open+0x70>
		return -E_BAD_PATH;
  80173f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801744:	eb de                	jmp    801724 <open+0x70>

00801746 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801746:	f3 0f 1e fb          	endbr32 
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
  80174d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801750:	ba 00 00 00 00       	mov    $0x0,%edx
  801755:	b8 08 00 00 00       	mov    $0x8,%eax
  80175a:	e8 87 fd ff ff       	call   8014e6 <fsipc>
}
  80175f:	c9                   	leave  
  801760:	c3                   	ret    

00801761 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801761:	f3 0f 1e fb          	endbr32 
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
  801768:	56                   	push   %esi
  801769:	53                   	push   %ebx
  80176a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80176d:	83 ec 0c             	sub    $0xc,%esp
  801770:	ff 75 08             	pushl  0x8(%ebp)
  801773:	e8 b3 f7 ff ff       	call   800f2b <fd2data>
  801778:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80177a:	83 c4 08             	add    $0x8,%esp
  80177d:	68 1f 25 80 00       	push   $0x80251f
  801782:	53                   	push   %ebx
  801783:	e8 a3 f0 ff ff       	call   80082b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801788:	8b 46 04             	mov    0x4(%esi),%eax
  80178b:	2b 06                	sub    (%esi),%eax
  80178d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801793:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80179a:	00 00 00 
	stat->st_dev = &devpipe;
  80179d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8017a4:	30 80 00 
	return 0;
}
  8017a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017af:	5b                   	pop    %ebx
  8017b0:	5e                   	pop    %esi
  8017b1:	5d                   	pop    %ebp
  8017b2:	c3                   	ret    

008017b3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8017b3:	f3 0f 1e fb          	endbr32 
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
  8017ba:	53                   	push   %ebx
  8017bb:	83 ec 0c             	sub    $0xc,%esp
  8017be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8017c1:	53                   	push   %ebx
  8017c2:	6a 00                	push   $0x0
  8017c4:	e8 31 f5 ff ff       	call   800cfa <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8017c9:	89 1c 24             	mov    %ebx,(%esp)
  8017cc:	e8 5a f7 ff ff       	call   800f2b <fd2data>
  8017d1:	83 c4 08             	add    $0x8,%esp
  8017d4:	50                   	push   %eax
  8017d5:	6a 00                	push   $0x0
  8017d7:	e8 1e f5 ff ff       	call   800cfa <sys_page_unmap>
}
  8017dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017df:	c9                   	leave  
  8017e0:	c3                   	ret    

008017e1 <_pipeisclosed>:
{
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
  8017e4:	57                   	push   %edi
  8017e5:	56                   	push   %esi
  8017e6:	53                   	push   %ebx
  8017e7:	83 ec 1c             	sub    $0x1c,%esp
  8017ea:	89 c7                	mov    %eax,%edi
  8017ec:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8017ee:	a1 04 40 80 00       	mov    0x804004,%eax
  8017f3:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8017f6:	83 ec 0c             	sub    $0xc,%esp
  8017f9:	57                   	push   %edi
  8017fa:	e8 77 05 00 00       	call   801d76 <pageref>
  8017ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801802:	89 34 24             	mov    %esi,(%esp)
  801805:	e8 6c 05 00 00       	call   801d76 <pageref>
		nn = thisenv->env_runs;
  80180a:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801810:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801813:	83 c4 10             	add    $0x10,%esp
  801816:	39 cb                	cmp    %ecx,%ebx
  801818:	74 1b                	je     801835 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80181a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80181d:	75 cf                	jne    8017ee <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80181f:	8b 42 58             	mov    0x58(%edx),%eax
  801822:	6a 01                	push   $0x1
  801824:	50                   	push   %eax
  801825:	53                   	push   %ebx
  801826:	68 26 25 80 00       	push   $0x802526
  80182b:	e8 f1 e9 ff ff       	call   800221 <cprintf>
  801830:	83 c4 10             	add    $0x10,%esp
  801833:	eb b9                	jmp    8017ee <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801835:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801838:	0f 94 c0             	sete   %al
  80183b:	0f b6 c0             	movzbl %al,%eax
}
  80183e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801841:	5b                   	pop    %ebx
  801842:	5e                   	pop    %esi
  801843:	5f                   	pop    %edi
  801844:	5d                   	pop    %ebp
  801845:	c3                   	ret    

00801846 <devpipe_write>:
{
  801846:	f3 0f 1e fb          	endbr32 
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
  80184d:	57                   	push   %edi
  80184e:	56                   	push   %esi
  80184f:	53                   	push   %ebx
  801850:	83 ec 28             	sub    $0x28,%esp
  801853:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801856:	56                   	push   %esi
  801857:	e8 cf f6 ff ff       	call   800f2b <fd2data>
  80185c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80185e:	83 c4 10             	add    $0x10,%esp
  801861:	bf 00 00 00 00       	mov    $0x0,%edi
  801866:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801869:	74 4f                	je     8018ba <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80186b:	8b 43 04             	mov    0x4(%ebx),%eax
  80186e:	8b 0b                	mov    (%ebx),%ecx
  801870:	8d 51 20             	lea    0x20(%ecx),%edx
  801873:	39 d0                	cmp    %edx,%eax
  801875:	72 14                	jb     80188b <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801877:	89 da                	mov    %ebx,%edx
  801879:	89 f0                	mov    %esi,%eax
  80187b:	e8 61 ff ff ff       	call   8017e1 <_pipeisclosed>
  801880:	85 c0                	test   %eax,%eax
  801882:	75 3b                	jne    8018bf <devpipe_write+0x79>
			sys_yield();
  801884:	e8 c1 f3 ff ff       	call   800c4a <sys_yield>
  801889:	eb e0                	jmp    80186b <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80188b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80188e:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801892:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801895:	89 c2                	mov    %eax,%edx
  801897:	c1 fa 1f             	sar    $0x1f,%edx
  80189a:	89 d1                	mov    %edx,%ecx
  80189c:	c1 e9 1b             	shr    $0x1b,%ecx
  80189f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8018a2:	83 e2 1f             	and    $0x1f,%edx
  8018a5:	29 ca                	sub    %ecx,%edx
  8018a7:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8018ab:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8018af:	83 c0 01             	add    $0x1,%eax
  8018b2:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8018b5:	83 c7 01             	add    $0x1,%edi
  8018b8:	eb ac                	jmp    801866 <devpipe_write+0x20>
	return i;
  8018ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8018bd:	eb 05                	jmp    8018c4 <devpipe_write+0x7e>
				return 0;
  8018bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018c7:	5b                   	pop    %ebx
  8018c8:	5e                   	pop    %esi
  8018c9:	5f                   	pop    %edi
  8018ca:	5d                   	pop    %ebp
  8018cb:	c3                   	ret    

008018cc <devpipe_read>:
{
  8018cc:	f3 0f 1e fb          	endbr32 
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
  8018d3:	57                   	push   %edi
  8018d4:	56                   	push   %esi
  8018d5:	53                   	push   %ebx
  8018d6:	83 ec 18             	sub    $0x18,%esp
  8018d9:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8018dc:	57                   	push   %edi
  8018dd:	e8 49 f6 ff ff       	call   800f2b <fd2data>
  8018e2:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8018e4:	83 c4 10             	add    $0x10,%esp
  8018e7:	be 00 00 00 00       	mov    $0x0,%esi
  8018ec:	3b 75 10             	cmp    0x10(%ebp),%esi
  8018ef:	75 14                	jne    801905 <devpipe_read+0x39>
	return i;
  8018f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f4:	eb 02                	jmp    8018f8 <devpipe_read+0x2c>
				return i;
  8018f6:	89 f0                	mov    %esi,%eax
}
  8018f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018fb:	5b                   	pop    %ebx
  8018fc:	5e                   	pop    %esi
  8018fd:	5f                   	pop    %edi
  8018fe:	5d                   	pop    %ebp
  8018ff:	c3                   	ret    
			sys_yield();
  801900:	e8 45 f3 ff ff       	call   800c4a <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801905:	8b 03                	mov    (%ebx),%eax
  801907:	3b 43 04             	cmp    0x4(%ebx),%eax
  80190a:	75 18                	jne    801924 <devpipe_read+0x58>
			if (i > 0)
  80190c:	85 f6                	test   %esi,%esi
  80190e:	75 e6                	jne    8018f6 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801910:	89 da                	mov    %ebx,%edx
  801912:	89 f8                	mov    %edi,%eax
  801914:	e8 c8 fe ff ff       	call   8017e1 <_pipeisclosed>
  801919:	85 c0                	test   %eax,%eax
  80191b:	74 e3                	je     801900 <devpipe_read+0x34>
				return 0;
  80191d:	b8 00 00 00 00       	mov    $0x0,%eax
  801922:	eb d4                	jmp    8018f8 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801924:	99                   	cltd   
  801925:	c1 ea 1b             	shr    $0x1b,%edx
  801928:	01 d0                	add    %edx,%eax
  80192a:	83 e0 1f             	and    $0x1f,%eax
  80192d:	29 d0                	sub    %edx,%eax
  80192f:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801934:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801937:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80193a:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80193d:	83 c6 01             	add    $0x1,%esi
  801940:	eb aa                	jmp    8018ec <devpipe_read+0x20>

00801942 <pipe>:
{
  801942:	f3 0f 1e fb          	endbr32 
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
  801949:	56                   	push   %esi
  80194a:	53                   	push   %ebx
  80194b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80194e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801951:	50                   	push   %eax
  801952:	e8 ef f5 ff ff       	call   800f46 <fd_alloc>
  801957:	89 c3                	mov    %eax,%ebx
  801959:	83 c4 10             	add    $0x10,%esp
  80195c:	85 c0                	test   %eax,%eax
  80195e:	0f 88 23 01 00 00    	js     801a87 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801964:	83 ec 04             	sub    $0x4,%esp
  801967:	68 07 04 00 00       	push   $0x407
  80196c:	ff 75 f4             	pushl  -0xc(%ebp)
  80196f:	6a 00                	push   $0x0
  801971:	e8 f7 f2 ff ff       	call   800c6d <sys_page_alloc>
  801976:	89 c3                	mov    %eax,%ebx
  801978:	83 c4 10             	add    $0x10,%esp
  80197b:	85 c0                	test   %eax,%eax
  80197d:	0f 88 04 01 00 00    	js     801a87 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801983:	83 ec 0c             	sub    $0xc,%esp
  801986:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801989:	50                   	push   %eax
  80198a:	e8 b7 f5 ff ff       	call   800f46 <fd_alloc>
  80198f:	89 c3                	mov    %eax,%ebx
  801991:	83 c4 10             	add    $0x10,%esp
  801994:	85 c0                	test   %eax,%eax
  801996:	0f 88 db 00 00 00    	js     801a77 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80199c:	83 ec 04             	sub    $0x4,%esp
  80199f:	68 07 04 00 00       	push   $0x407
  8019a4:	ff 75 f0             	pushl  -0x10(%ebp)
  8019a7:	6a 00                	push   $0x0
  8019a9:	e8 bf f2 ff ff       	call   800c6d <sys_page_alloc>
  8019ae:	89 c3                	mov    %eax,%ebx
  8019b0:	83 c4 10             	add    $0x10,%esp
  8019b3:	85 c0                	test   %eax,%eax
  8019b5:	0f 88 bc 00 00 00    	js     801a77 <pipe+0x135>
	va = fd2data(fd0);
  8019bb:	83 ec 0c             	sub    $0xc,%esp
  8019be:	ff 75 f4             	pushl  -0xc(%ebp)
  8019c1:	e8 65 f5 ff ff       	call   800f2b <fd2data>
  8019c6:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019c8:	83 c4 0c             	add    $0xc,%esp
  8019cb:	68 07 04 00 00       	push   $0x407
  8019d0:	50                   	push   %eax
  8019d1:	6a 00                	push   $0x0
  8019d3:	e8 95 f2 ff ff       	call   800c6d <sys_page_alloc>
  8019d8:	89 c3                	mov    %eax,%ebx
  8019da:	83 c4 10             	add    $0x10,%esp
  8019dd:	85 c0                	test   %eax,%eax
  8019df:	0f 88 82 00 00 00    	js     801a67 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019e5:	83 ec 0c             	sub    $0xc,%esp
  8019e8:	ff 75 f0             	pushl  -0x10(%ebp)
  8019eb:	e8 3b f5 ff ff       	call   800f2b <fd2data>
  8019f0:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8019f7:	50                   	push   %eax
  8019f8:	6a 00                	push   $0x0
  8019fa:	56                   	push   %esi
  8019fb:	6a 00                	push   $0x0
  8019fd:	e8 b2 f2 ff ff       	call   800cb4 <sys_page_map>
  801a02:	89 c3                	mov    %eax,%ebx
  801a04:	83 c4 20             	add    $0x20,%esp
  801a07:	85 c0                	test   %eax,%eax
  801a09:	78 4e                	js     801a59 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801a0b:	a1 20 30 80 00       	mov    0x803020,%eax
  801a10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a13:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801a15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a18:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801a1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a22:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801a24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a27:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801a2e:	83 ec 0c             	sub    $0xc,%esp
  801a31:	ff 75 f4             	pushl  -0xc(%ebp)
  801a34:	e8 de f4 ff ff       	call   800f17 <fd2num>
  801a39:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a3c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801a3e:	83 c4 04             	add    $0x4,%esp
  801a41:	ff 75 f0             	pushl  -0x10(%ebp)
  801a44:	e8 ce f4 ff ff       	call   800f17 <fd2num>
  801a49:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a4c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801a4f:	83 c4 10             	add    $0x10,%esp
  801a52:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a57:	eb 2e                	jmp    801a87 <pipe+0x145>
	sys_page_unmap(0, va);
  801a59:	83 ec 08             	sub    $0x8,%esp
  801a5c:	56                   	push   %esi
  801a5d:	6a 00                	push   $0x0
  801a5f:	e8 96 f2 ff ff       	call   800cfa <sys_page_unmap>
  801a64:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801a67:	83 ec 08             	sub    $0x8,%esp
  801a6a:	ff 75 f0             	pushl  -0x10(%ebp)
  801a6d:	6a 00                	push   $0x0
  801a6f:	e8 86 f2 ff ff       	call   800cfa <sys_page_unmap>
  801a74:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801a77:	83 ec 08             	sub    $0x8,%esp
  801a7a:	ff 75 f4             	pushl  -0xc(%ebp)
  801a7d:	6a 00                	push   $0x0
  801a7f:	e8 76 f2 ff ff       	call   800cfa <sys_page_unmap>
  801a84:	83 c4 10             	add    $0x10,%esp
}
  801a87:	89 d8                	mov    %ebx,%eax
  801a89:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a8c:	5b                   	pop    %ebx
  801a8d:	5e                   	pop    %esi
  801a8e:	5d                   	pop    %ebp
  801a8f:	c3                   	ret    

00801a90 <pipeisclosed>:
{
  801a90:	f3 0f 1e fb          	endbr32 
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
  801a97:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a9a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a9d:	50                   	push   %eax
  801a9e:	ff 75 08             	pushl  0x8(%ebp)
  801aa1:	e8 f6 f4 ff ff       	call   800f9c <fd_lookup>
  801aa6:	83 c4 10             	add    $0x10,%esp
  801aa9:	85 c0                	test   %eax,%eax
  801aab:	78 18                	js     801ac5 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801aad:	83 ec 0c             	sub    $0xc,%esp
  801ab0:	ff 75 f4             	pushl  -0xc(%ebp)
  801ab3:	e8 73 f4 ff ff       	call   800f2b <fd2data>
  801ab8:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801abd:	e8 1f fd ff ff       	call   8017e1 <_pipeisclosed>
  801ac2:	83 c4 10             	add    $0x10,%esp
}
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801ac7:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801acb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad0:	c3                   	ret    

00801ad1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801ad1:	f3 0f 1e fb          	endbr32 
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
  801ad8:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801adb:	68 3e 25 80 00       	push   $0x80253e
  801ae0:	ff 75 0c             	pushl  0xc(%ebp)
  801ae3:	e8 43 ed ff ff       	call   80082b <strcpy>
	return 0;
}
  801ae8:	b8 00 00 00 00       	mov    $0x0,%eax
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <devcons_write>:
{
  801aef:	f3 0f 1e fb          	endbr32 
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
  801af6:	57                   	push   %edi
  801af7:	56                   	push   %esi
  801af8:	53                   	push   %ebx
  801af9:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801aff:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801b04:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801b0a:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b0d:	73 31                	jae    801b40 <devcons_write+0x51>
		m = n - tot;
  801b0f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801b12:	29 f3                	sub    %esi,%ebx
  801b14:	83 fb 7f             	cmp    $0x7f,%ebx
  801b17:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801b1c:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801b1f:	83 ec 04             	sub    $0x4,%esp
  801b22:	53                   	push   %ebx
  801b23:	89 f0                	mov    %esi,%eax
  801b25:	03 45 0c             	add    0xc(%ebp),%eax
  801b28:	50                   	push   %eax
  801b29:	57                   	push   %edi
  801b2a:	e8 b2 ee ff ff       	call   8009e1 <memmove>
		sys_cputs(buf, m);
  801b2f:	83 c4 08             	add    $0x8,%esp
  801b32:	53                   	push   %ebx
  801b33:	57                   	push   %edi
  801b34:	e8 64 f0 ff ff       	call   800b9d <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801b39:	01 de                	add    %ebx,%esi
  801b3b:	83 c4 10             	add    $0x10,%esp
  801b3e:	eb ca                	jmp    801b0a <devcons_write+0x1b>
}
  801b40:	89 f0                	mov    %esi,%eax
  801b42:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b45:	5b                   	pop    %ebx
  801b46:	5e                   	pop    %esi
  801b47:	5f                   	pop    %edi
  801b48:	5d                   	pop    %ebp
  801b49:	c3                   	ret    

00801b4a <devcons_read>:
{
  801b4a:	f3 0f 1e fb          	endbr32 
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	83 ec 08             	sub    $0x8,%esp
  801b54:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801b59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b5d:	74 21                	je     801b80 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801b5f:	e8 5b f0 ff ff       	call   800bbf <sys_cgetc>
  801b64:	85 c0                	test   %eax,%eax
  801b66:	75 07                	jne    801b6f <devcons_read+0x25>
		sys_yield();
  801b68:	e8 dd f0 ff ff       	call   800c4a <sys_yield>
  801b6d:	eb f0                	jmp    801b5f <devcons_read+0x15>
	if (c < 0)
  801b6f:	78 0f                	js     801b80 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801b71:	83 f8 04             	cmp    $0x4,%eax
  801b74:	74 0c                	je     801b82 <devcons_read+0x38>
	*(char*)vbuf = c;
  801b76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b79:	88 02                	mov    %al,(%edx)
	return 1;
  801b7b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b80:	c9                   	leave  
  801b81:	c3                   	ret    
		return 0;
  801b82:	b8 00 00 00 00       	mov    $0x0,%eax
  801b87:	eb f7                	jmp    801b80 <devcons_read+0x36>

00801b89 <cputchar>:
{
  801b89:	f3 0f 1e fb          	endbr32 
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
  801b90:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801b93:	8b 45 08             	mov    0x8(%ebp),%eax
  801b96:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801b99:	6a 01                	push   $0x1
  801b9b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801b9e:	50                   	push   %eax
  801b9f:	e8 f9 ef ff ff       	call   800b9d <sys_cputs>
}
  801ba4:	83 c4 10             	add    $0x10,%esp
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    

00801ba9 <getchar>:
{
  801ba9:	f3 0f 1e fb          	endbr32 
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
  801bb0:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801bb3:	6a 01                	push   $0x1
  801bb5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801bb8:	50                   	push   %eax
  801bb9:	6a 00                	push   $0x0
  801bbb:	e8 5f f6 ff ff       	call   80121f <read>
	if (r < 0)
  801bc0:	83 c4 10             	add    $0x10,%esp
  801bc3:	85 c0                	test   %eax,%eax
  801bc5:	78 06                	js     801bcd <getchar+0x24>
	if (r < 1)
  801bc7:	74 06                	je     801bcf <getchar+0x26>
	return c;
  801bc9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    
		return -E_EOF;
  801bcf:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801bd4:	eb f7                	jmp    801bcd <getchar+0x24>

00801bd6 <iscons>:
{
  801bd6:	f3 0f 1e fb          	endbr32 
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
  801bdd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801be0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801be3:	50                   	push   %eax
  801be4:	ff 75 08             	pushl  0x8(%ebp)
  801be7:	e8 b0 f3 ff ff       	call   800f9c <fd_lookup>
  801bec:	83 c4 10             	add    $0x10,%esp
  801bef:	85 c0                	test   %eax,%eax
  801bf1:	78 11                	js     801c04 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf6:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801bfc:	39 10                	cmp    %edx,(%eax)
  801bfe:	0f 94 c0             	sete   %al
  801c01:	0f b6 c0             	movzbl %al,%eax
}
  801c04:	c9                   	leave  
  801c05:	c3                   	ret    

00801c06 <opencons>:
{
  801c06:	f3 0f 1e fb          	endbr32 
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
  801c0d:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801c10:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c13:	50                   	push   %eax
  801c14:	e8 2d f3 ff ff       	call   800f46 <fd_alloc>
  801c19:	83 c4 10             	add    $0x10,%esp
  801c1c:	85 c0                	test   %eax,%eax
  801c1e:	78 3a                	js     801c5a <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801c20:	83 ec 04             	sub    $0x4,%esp
  801c23:	68 07 04 00 00       	push   $0x407
  801c28:	ff 75 f4             	pushl  -0xc(%ebp)
  801c2b:	6a 00                	push   $0x0
  801c2d:	e8 3b f0 ff ff       	call   800c6d <sys_page_alloc>
  801c32:	83 c4 10             	add    $0x10,%esp
  801c35:	85 c0                	test   %eax,%eax
  801c37:	78 21                	js     801c5a <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c3c:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c42:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c47:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801c4e:	83 ec 0c             	sub    $0xc,%esp
  801c51:	50                   	push   %eax
  801c52:	e8 c0 f2 ff ff       	call   800f17 <fd2num>
  801c57:	83 c4 10             	add    $0x10,%esp
}
  801c5a:	c9                   	leave  
  801c5b:	c3                   	ret    

00801c5c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801c5c:	f3 0f 1e fb          	endbr32 
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
  801c63:	56                   	push   %esi
  801c64:	53                   	push   %ebx
  801c65:	8b 75 08             	mov    0x8(%ebp),%esi
  801c68:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c6b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  801c6e:	85 c0                	test   %eax,%eax
  801c70:	74 3d                	je     801caf <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  801c72:	83 ec 0c             	sub    $0xc,%esp
  801c75:	50                   	push   %eax
  801c76:	e8 be f1 ff ff       	call   800e39 <sys_ipc_recv>
  801c7b:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  801c7e:	85 f6                	test   %esi,%esi
  801c80:	74 0b                	je     801c8d <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801c82:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c88:	8b 52 74             	mov    0x74(%edx),%edx
  801c8b:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801c8d:	85 db                	test   %ebx,%ebx
  801c8f:	74 0b                	je     801c9c <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  801c91:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c97:	8b 52 78             	mov    0x78(%edx),%edx
  801c9a:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  801c9c:	85 c0                	test   %eax,%eax
  801c9e:	78 21                	js     801cc1 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  801ca0:	a1 04 40 80 00       	mov    0x804004,%eax
  801ca5:	8b 40 70             	mov    0x70(%eax),%eax
}
  801ca8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cab:	5b                   	pop    %ebx
  801cac:	5e                   	pop    %esi
  801cad:	5d                   	pop    %ebp
  801cae:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  801caf:	83 ec 0c             	sub    $0xc,%esp
  801cb2:	68 00 00 c0 ee       	push   $0xeec00000
  801cb7:	e8 7d f1 ff ff       	call   800e39 <sys_ipc_recv>
  801cbc:	83 c4 10             	add    $0x10,%esp
  801cbf:	eb bd                	jmp    801c7e <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  801cc1:	85 f6                	test   %esi,%esi
  801cc3:	74 10                	je     801cd5 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  801cc5:	85 db                	test   %ebx,%ebx
  801cc7:	75 df                	jne    801ca8 <ipc_recv+0x4c>
  801cc9:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801cd0:	00 00 00 
  801cd3:	eb d3                	jmp    801ca8 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  801cd5:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801cdc:	00 00 00 
  801cdf:	eb e4                	jmp    801cc5 <ipc_recv+0x69>

00801ce1 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801ce1:	f3 0f 1e fb          	endbr32 
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
  801ce8:	57                   	push   %edi
  801ce9:	56                   	push   %esi
  801cea:	53                   	push   %ebx
  801ceb:	83 ec 0c             	sub    $0xc,%esp
  801cee:	8b 7d 08             	mov    0x8(%ebp),%edi
  801cf1:	8b 75 0c             	mov    0xc(%ebp),%esi
  801cf4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  801cf7:	85 db                	test   %ebx,%ebx
  801cf9:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801cfe:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  801d01:	ff 75 14             	pushl  0x14(%ebp)
  801d04:	53                   	push   %ebx
  801d05:	56                   	push   %esi
  801d06:	57                   	push   %edi
  801d07:	e8 06 f1 ff ff       	call   800e12 <sys_ipc_try_send>
  801d0c:	83 c4 10             	add    $0x10,%esp
  801d0f:	85 c0                	test   %eax,%eax
  801d11:	79 1e                	jns    801d31 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  801d13:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801d16:	75 07                	jne    801d1f <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  801d18:	e8 2d ef ff ff       	call   800c4a <sys_yield>
  801d1d:	eb e2                	jmp    801d01 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  801d1f:	50                   	push   %eax
  801d20:	68 4a 25 80 00       	push   $0x80254a
  801d25:	6a 59                	push   $0x59
  801d27:	68 65 25 80 00       	push   $0x802565
  801d2c:	e8 09 e4 ff ff       	call   80013a <_panic>
	}
}
  801d31:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d34:	5b                   	pop    %ebx
  801d35:	5e                   	pop    %esi
  801d36:	5f                   	pop    %edi
  801d37:	5d                   	pop    %ebp
  801d38:	c3                   	ret    

00801d39 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801d39:	f3 0f 1e fb          	endbr32 
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
  801d40:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801d43:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801d48:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801d4b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801d51:	8b 52 50             	mov    0x50(%edx),%edx
  801d54:	39 ca                	cmp    %ecx,%edx
  801d56:	74 11                	je     801d69 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801d58:	83 c0 01             	add    $0x1,%eax
  801d5b:	3d 00 04 00 00       	cmp    $0x400,%eax
  801d60:	75 e6                	jne    801d48 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801d62:	b8 00 00 00 00       	mov    $0x0,%eax
  801d67:	eb 0b                	jmp    801d74 <ipc_find_env+0x3b>
			return envs[i].env_id;
  801d69:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801d6c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801d71:	8b 40 48             	mov    0x48(%eax),%eax
}
  801d74:	5d                   	pop    %ebp
  801d75:	c3                   	ret    

00801d76 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801d76:	f3 0f 1e fb          	endbr32 
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
  801d7d:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801d80:	89 c2                	mov    %eax,%edx
  801d82:	c1 ea 16             	shr    $0x16,%edx
  801d85:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801d8c:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801d91:	f6 c1 01             	test   $0x1,%cl
  801d94:	74 1c                	je     801db2 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801d96:	c1 e8 0c             	shr    $0xc,%eax
  801d99:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801da0:	a8 01                	test   $0x1,%al
  801da2:	74 0e                	je     801db2 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801da4:	c1 e8 0c             	shr    $0xc,%eax
  801da7:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801dae:	ef 
  801daf:	0f b7 d2             	movzwl %dx,%edx
}
  801db2:	89 d0                	mov    %edx,%eax
  801db4:	5d                   	pop    %ebp
  801db5:	c3                   	ret    
  801db6:	66 90                	xchg   %ax,%ax
  801db8:	66 90                	xchg   %ax,%ax
  801dba:	66 90                	xchg   %ax,%ax
  801dbc:	66 90                	xchg   %ax,%ax
  801dbe:	66 90                	xchg   %ax,%ax

00801dc0 <__udivdi3>:
  801dc0:	f3 0f 1e fb          	endbr32 
  801dc4:	55                   	push   %ebp
  801dc5:	57                   	push   %edi
  801dc6:	56                   	push   %esi
  801dc7:	53                   	push   %ebx
  801dc8:	83 ec 1c             	sub    $0x1c,%esp
  801dcb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801dcf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801dd3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801dd7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801ddb:	85 d2                	test   %edx,%edx
  801ddd:	75 19                	jne    801df8 <__udivdi3+0x38>
  801ddf:	39 f3                	cmp    %esi,%ebx
  801de1:	76 4d                	jbe    801e30 <__udivdi3+0x70>
  801de3:	31 ff                	xor    %edi,%edi
  801de5:	89 e8                	mov    %ebp,%eax
  801de7:	89 f2                	mov    %esi,%edx
  801de9:	f7 f3                	div    %ebx
  801deb:	89 fa                	mov    %edi,%edx
  801ded:	83 c4 1c             	add    $0x1c,%esp
  801df0:	5b                   	pop    %ebx
  801df1:	5e                   	pop    %esi
  801df2:	5f                   	pop    %edi
  801df3:	5d                   	pop    %ebp
  801df4:	c3                   	ret    
  801df5:	8d 76 00             	lea    0x0(%esi),%esi
  801df8:	39 f2                	cmp    %esi,%edx
  801dfa:	76 14                	jbe    801e10 <__udivdi3+0x50>
  801dfc:	31 ff                	xor    %edi,%edi
  801dfe:	31 c0                	xor    %eax,%eax
  801e00:	89 fa                	mov    %edi,%edx
  801e02:	83 c4 1c             	add    $0x1c,%esp
  801e05:	5b                   	pop    %ebx
  801e06:	5e                   	pop    %esi
  801e07:	5f                   	pop    %edi
  801e08:	5d                   	pop    %ebp
  801e09:	c3                   	ret    
  801e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801e10:	0f bd fa             	bsr    %edx,%edi
  801e13:	83 f7 1f             	xor    $0x1f,%edi
  801e16:	75 48                	jne    801e60 <__udivdi3+0xa0>
  801e18:	39 f2                	cmp    %esi,%edx
  801e1a:	72 06                	jb     801e22 <__udivdi3+0x62>
  801e1c:	31 c0                	xor    %eax,%eax
  801e1e:	39 eb                	cmp    %ebp,%ebx
  801e20:	77 de                	ja     801e00 <__udivdi3+0x40>
  801e22:	b8 01 00 00 00       	mov    $0x1,%eax
  801e27:	eb d7                	jmp    801e00 <__udivdi3+0x40>
  801e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e30:	89 d9                	mov    %ebx,%ecx
  801e32:	85 db                	test   %ebx,%ebx
  801e34:	75 0b                	jne    801e41 <__udivdi3+0x81>
  801e36:	b8 01 00 00 00       	mov    $0x1,%eax
  801e3b:	31 d2                	xor    %edx,%edx
  801e3d:	f7 f3                	div    %ebx
  801e3f:	89 c1                	mov    %eax,%ecx
  801e41:	31 d2                	xor    %edx,%edx
  801e43:	89 f0                	mov    %esi,%eax
  801e45:	f7 f1                	div    %ecx
  801e47:	89 c6                	mov    %eax,%esi
  801e49:	89 e8                	mov    %ebp,%eax
  801e4b:	89 f7                	mov    %esi,%edi
  801e4d:	f7 f1                	div    %ecx
  801e4f:	89 fa                	mov    %edi,%edx
  801e51:	83 c4 1c             	add    $0x1c,%esp
  801e54:	5b                   	pop    %ebx
  801e55:	5e                   	pop    %esi
  801e56:	5f                   	pop    %edi
  801e57:	5d                   	pop    %ebp
  801e58:	c3                   	ret    
  801e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e60:	89 f9                	mov    %edi,%ecx
  801e62:	b8 20 00 00 00       	mov    $0x20,%eax
  801e67:	29 f8                	sub    %edi,%eax
  801e69:	d3 e2                	shl    %cl,%edx
  801e6b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e6f:	89 c1                	mov    %eax,%ecx
  801e71:	89 da                	mov    %ebx,%edx
  801e73:	d3 ea                	shr    %cl,%edx
  801e75:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801e79:	09 d1                	or     %edx,%ecx
  801e7b:	89 f2                	mov    %esi,%edx
  801e7d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e81:	89 f9                	mov    %edi,%ecx
  801e83:	d3 e3                	shl    %cl,%ebx
  801e85:	89 c1                	mov    %eax,%ecx
  801e87:	d3 ea                	shr    %cl,%edx
  801e89:	89 f9                	mov    %edi,%ecx
  801e8b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801e8f:	89 eb                	mov    %ebp,%ebx
  801e91:	d3 e6                	shl    %cl,%esi
  801e93:	89 c1                	mov    %eax,%ecx
  801e95:	d3 eb                	shr    %cl,%ebx
  801e97:	09 de                	or     %ebx,%esi
  801e99:	89 f0                	mov    %esi,%eax
  801e9b:	f7 74 24 08          	divl   0x8(%esp)
  801e9f:	89 d6                	mov    %edx,%esi
  801ea1:	89 c3                	mov    %eax,%ebx
  801ea3:	f7 64 24 0c          	mull   0xc(%esp)
  801ea7:	39 d6                	cmp    %edx,%esi
  801ea9:	72 15                	jb     801ec0 <__udivdi3+0x100>
  801eab:	89 f9                	mov    %edi,%ecx
  801ead:	d3 e5                	shl    %cl,%ebp
  801eaf:	39 c5                	cmp    %eax,%ebp
  801eb1:	73 04                	jae    801eb7 <__udivdi3+0xf7>
  801eb3:	39 d6                	cmp    %edx,%esi
  801eb5:	74 09                	je     801ec0 <__udivdi3+0x100>
  801eb7:	89 d8                	mov    %ebx,%eax
  801eb9:	31 ff                	xor    %edi,%edi
  801ebb:	e9 40 ff ff ff       	jmp    801e00 <__udivdi3+0x40>
  801ec0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ec3:	31 ff                	xor    %edi,%edi
  801ec5:	e9 36 ff ff ff       	jmp    801e00 <__udivdi3+0x40>
  801eca:	66 90                	xchg   %ax,%ax
  801ecc:	66 90                	xchg   %ax,%ax
  801ece:	66 90                	xchg   %ax,%ax

00801ed0 <__umoddi3>:
  801ed0:	f3 0f 1e fb          	endbr32 
  801ed4:	55                   	push   %ebp
  801ed5:	57                   	push   %edi
  801ed6:	56                   	push   %esi
  801ed7:	53                   	push   %ebx
  801ed8:	83 ec 1c             	sub    $0x1c,%esp
  801edb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801edf:	8b 74 24 30          	mov    0x30(%esp),%esi
  801ee3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801ee7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801eeb:	85 c0                	test   %eax,%eax
  801eed:	75 19                	jne    801f08 <__umoddi3+0x38>
  801eef:	39 df                	cmp    %ebx,%edi
  801ef1:	76 5d                	jbe    801f50 <__umoddi3+0x80>
  801ef3:	89 f0                	mov    %esi,%eax
  801ef5:	89 da                	mov    %ebx,%edx
  801ef7:	f7 f7                	div    %edi
  801ef9:	89 d0                	mov    %edx,%eax
  801efb:	31 d2                	xor    %edx,%edx
  801efd:	83 c4 1c             	add    $0x1c,%esp
  801f00:	5b                   	pop    %ebx
  801f01:	5e                   	pop    %esi
  801f02:	5f                   	pop    %edi
  801f03:	5d                   	pop    %ebp
  801f04:	c3                   	ret    
  801f05:	8d 76 00             	lea    0x0(%esi),%esi
  801f08:	89 f2                	mov    %esi,%edx
  801f0a:	39 d8                	cmp    %ebx,%eax
  801f0c:	76 12                	jbe    801f20 <__umoddi3+0x50>
  801f0e:	89 f0                	mov    %esi,%eax
  801f10:	89 da                	mov    %ebx,%edx
  801f12:	83 c4 1c             	add    $0x1c,%esp
  801f15:	5b                   	pop    %ebx
  801f16:	5e                   	pop    %esi
  801f17:	5f                   	pop    %edi
  801f18:	5d                   	pop    %ebp
  801f19:	c3                   	ret    
  801f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801f20:	0f bd e8             	bsr    %eax,%ebp
  801f23:	83 f5 1f             	xor    $0x1f,%ebp
  801f26:	75 50                	jne    801f78 <__umoddi3+0xa8>
  801f28:	39 d8                	cmp    %ebx,%eax
  801f2a:	0f 82 e0 00 00 00    	jb     802010 <__umoddi3+0x140>
  801f30:	89 d9                	mov    %ebx,%ecx
  801f32:	39 f7                	cmp    %esi,%edi
  801f34:	0f 86 d6 00 00 00    	jbe    802010 <__umoddi3+0x140>
  801f3a:	89 d0                	mov    %edx,%eax
  801f3c:	89 ca                	mov    %ecx,%edx
  801f3e:	83 c4 1c             	add    $0x1c,%esp
  801f41:	5b                   	pop    %ebx
  801f42:	5e                   	pop    %esi
  801f43:	5f                   	pop    %edi
  801f44:	5d                   	pop    %ebp
  801f45:	c3                   	ret    
  801f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f4d:	8d 76 00             	lea    0x0(%esi),%esi
  801f50:	89 fd                	mov    %edi,%ebp
  801f52:	85 ff                	test   %edi,%edi
  801f54:	75 0b                	jne    801f61 <__umoddi3+0x91>
  801f56:	b8 01 00 00 00       	mov    $0x1,%eax
  801f5b:	31 d2                	xor    %edx,%edx
  801f5d:	f7 f7                	div    %edi
  801f5f:	89 c5                	mov    %eax,%ebp
  801f61:	89 d8                	mov    %ebx,%eax
  801f63:	31 d2                	xor    %edx,%edx
  801f65:	f7 f5                	div    %ebp
  801f67:	89 f0                	mov    %esi,%eax
  801f69:	f7 f5                	div    %ebp
  801f6b:	89 d0                	mov    %edx,%eax
  801f6d:	31 d2                	xor    %edx,%edx
  801f6f:	eb 8c                	jmp    801efd <__umoddi3+0x2d>
  801f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f78:	89 e9                	mov    %ebp,%ecx
  801f7a:	ba 20 00 00 00       	mov    $0x20,%edx
  801f7f:	29 ea                	sub    %ebp,%edx
  801f81:	d3 e0                	shl    %cl,%eax
  801f83:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f87:	89 d1                	mov    %edx,%ecx
  801f89:	89 f8                	mov    %edi,%eax
  801f8b:	d3 e8                	shr    %cl,%eax
  801f8d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801f91:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f95:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f99:	09 c1                	or     %eax,%ecx
  801f9b:	89 d8                	mov    %ebx,%eax
  801f9d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fa1:	89 e9                	mov    %ebp,%ecx
  801fa3:	d3 e7                	shl    %cl,%edi
  801fa5:	89 d1                	mov    %edx,%ecx
  801fa7:	d3 e8                	shr    %cl,%eax
  801fa9:	89 e9                	mov    %ebp,%ecx
  801fab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801faf:	d3 e3                	shl    %cl,%ebx
  801fb1:	89 c7                	mov    %eax,%edi
  801fb3:	89 d1                	mov    %edx,%ecx
  801fb5:	89 f0                	mov    %esi,%eax
  801fb7:	d3 e8                	shr    %cl,%eax
  801fb9:	89 e9                	mov    %ebp,%ecx
  801fbb:	89 fa                	mov    %edi,%edx
  801fbd:	d3 e6                	shl    %cl,%esi
  801fbf:	09 d8                	or     %ebx,%eax
  801fc1:	f7 74 24 08          	divl   0x8(%esp)
  801fc5:	89 d1                	mov    %edx,%ecx
  801fc7:	89 f3                	mov    %esi,%ebx
  801fc9:	f7 64 24 0c          	mull   0xc(%esp)
  801fcd:	89 c6                	mov    %eax,%esi
  801fcf:	89 d7                	mov    %edx,%edi
  801fd1:	39 d1                	cmp    %edx,%ecx
  801fd3:	72 06                	jb     801fdb <__umoddi3+0x10b>
  801fd5:	75 10                	jne    801fe7 <__umoddi3+0x117>
  801fd7:	39 c3                	cmp    %eax,%ebx
  801fd9:	73 0c                	jae    801fe7 <__umoddi3+0x117>
  801fdb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  801fdf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801fe3:	89 d7                	mov    %edx,%edi
  801fe5:	89 c6                	mov    %eax,%esi
  801fe7:	89 ca                	mov    %ecx,%edx
  801fe9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801fee:	29 f3                	sub    %esi,%ebx
  801ff0:	19 fa                	sbb    %edi,%edx
  801ff2:	89 d0                	mov    %edx,%eax
  801ff4:	d3 e0                	shl    %cl,%eax
  801ff6:	89 e9                	mov    %ebp,%ecx
  801ff8:	d3 eb                	shr    %cl,%ebx
  801ffa:	d3 ea                	shr    %cl,%edx
  801ffc:	09 d8                	or     %ebx,%eax
  801ffe:	83 c4 1c             	add    $0x1c,%esp
  802001:	5b                   	pop    %ebx
  802002:	5e                   	pop    %esi
  802003:	5f                   	pop    %edi
  802004:	5d                   	pop    %ebp
  802005:	c3                   	ret    
  802006:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80200d:	8d 76 00             	lea    0x0(%esi),%esi
  802010:	29 fe                	sub    %edi,%esi
  802012:	19 c3                	sbb    %eax,%ebx
  802014:	89 f2                	mov    %esi,%edx
  802016:	89 d9                	mov    %ebx,%ecx
  802018:	e9 1d ff ff ff       	jmp    801f3a <__umoddi3+0x6a>
