
obj/user/faultallocbad.debug:     file format elf32-i386


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
  80002c:	e8 8c 00 00 00       	call   8000bd <libmain>
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
  800049:	e8 be 01 00 00       	call   80020c <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004e:	83 c4 0c             	add    $0xc,%esp
  800051:	6a 07                	push   $0x7
  800053:	89 d8                	mov    %ebx,%eax
  800055:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80005a:	50                   	push   %eax
  80005b:	6a 00                	push   $0x0
  80005d:	e8 f6 0b 00 00       	call   800c58 <sys_page_alloc>
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
  800072:	e8 3e 07 00 00       	call   8007b5 <snprintf>
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
  800089:	6a 0f                	push   $0xf
  80008b:	68 2a 20 80 00       	push   $0x80202a
  800090:	e8 90 00 00 00       	call   800125 <_panic>

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
  8000a4:	e8 c0 0d 00 00       	call   800e69 <set_pgfault_handler>
	sys_cputs((char*)0xDEADBEEF, 4);
  8000a9:	83 c4 08             	add    $0x8,%esp
  8000ac:	6a 04                	push   $0x4
  8000ae:	68 ef be ad de       	push   $0xdeadbeef
  8000b3:	e8 d0 0a 00 00       	call   800b88 <sys_cputs>
}
  8000b8:	83 c4 10             	add    $0x10,%esp
  8000bb:	c9                   	leave  
  8000bc:	c3                   	ret    

008000bd <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000bd:	f3 0f 1e fb          	endbr32 
  8000c1:	55                   	push   %ebp
  8000c2:	89 e5                	mov    %esp,%ebp
  8000c4:	56                   	push   %esi
  8000c5:	53                   	push   %ebx
  8000c6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000c9:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000cc:	e8 41 0b 00 00       	call   800c12 <sys_getenvid>
  8000d1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000d6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000d9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000de:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e3:	85 db                	test   %ebx,%ebx
  8000e5:	7e 07                	jle    8000ee <libmain+0x31>
		binaryname = argv[0];
  8000e7:	8b 06                	mov    (%esi),%eax
  8000e9:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000ee:	83 ec 08             	sub    $0x8,%esp
  8000f1:	56                   	push   %esi
  8000f2:	53                   	push   %ebx
  8000f3:	e8 9d ff ff ff       	call   800095 <umain>

	// exit gracefully
	exit();
  8000f8:	e8 0a 00 00 00       	call   800107 <exit>
}
  8000fd:	83 c4 10             	add    $0x10,%esp
  800100:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800103:	5b                   	pop    %ebx
  800104:	5e                   	pop    %esi
  800105:	5d                   	pop    %ebp
  800106:	c3                   	ret    

00800107 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800107:	f3 0f 1e fb          	endbr32 
  80010b:	55                   	push   %ebp
  80010c:	89 e5                	mov    %esp,%ebp
  80010e:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800111:	e8 db 0f 00 00       	call   8010f1 <close_all>
	sys_env_destroy(0);
  800116:	83 ec 0c             	sub    $0xc,%esp
  800119:	6a 00                	push   $0x0
  80011b:	e8 ad 0a 00 00       	call   800bcd <sys_env_destroy>
}
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	c9                   	leave  
  800124:	c3                   	ret    

00800125 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800125:	f3 0f 1e fb          	endbr32 
  800129:	55                   	push   %ebp
  80012a:	89 e5                	mov    %esp,%ebp
  80012c:	56                   	push   %esi
  80012d:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80012e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800131:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800137:	e8 d6 0a 00 00       	call   800c12 <sys_getenvid>
  80013c:	83 ec 0c             	sub    $0xc,%esp
  80013f:	ff 75 0c             	pushl  0xc(%ebp)
  800142:	ff 75 08             	pushl  0x8(%ebp)
  800145:	56                   	push   %esi
  800146:	50                   	push   %eax
  800147:	68 98 20 80 00       	push   $0x802098
  80014c:	e8 bb 00 00 00       	call   80020c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800151:	83 c4 18             	add    $0x18,%esp
  800154:	53                   	push   %ebx
  800155:	ff 75 10             	pushl  0x10(%ebp)
  800158:	e8 5a 00 00 00       	call   8001b7 <vcprintf>
	cprintf("\n");
  80015d:	c7 04 24 63 25 80 00 	movl   $0x802563,(%esp)
  800164:	e8 a3 00 00 00       	call   80020c <cprintf>
  800169:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80016c:	cc                   	int3   
  80016d:	eb fd                	jmp    80016c <_panic+0x47>

0080016f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80016f:	f3 0f 1e fb          	endbr32 
  800173:	55                   	push   %ebp
  800174:	89 e5                	mov    %esp,%ebp
  800176:	53                   	push   %ebx
  800177:	83 ec 04             	sub    $0x4,%esp
  80017a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80017d:	8b 13                	mov    (%ebx),%edx
  80017f:	8d 42 01             	lea    0x1(%edx),%eax
  800182:	89 03                	mov    %eax,(%ebx)
  800184:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800187:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80018b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800190:	74 09                	je     80019b <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800192:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800196:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800199:	c9                   	leave  
  80019a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80019b:	83 ec 08             	sub    $0x8,%esp
  80019e:	68 ff 00 00 00       	push   $0xff
  8001a3:	8d 43 08             	lea    0x8(%ebx),%eax
  8001a6:	50                   	push   %eax
  8001a7:	e8 dc 09 00 00       	call   800b88 <sys_cputs>
		b->idx = 0;
  8001ac:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001b2:	83 c4 10             	add    $0x10,%esp
  8001b5:	eb db                	jmp    800192 <putch+0x23>

008001b7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001b7:	f3 0f 1e fb          	endbr32 
  8001bb:	55                   	push   %ebp
  8001bc:	89 e5                	mov    %esp,%ebp
  8001be:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001c4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001cb:	00 00 00 
	b.cnt = 0;
  8001ce:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001d5:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001d8:	ff 75 0c             	pushl  0xc(%ebp)
  8001db:	ff 75 08             	pushl  0x8(%ebp)
  8001de:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001e4:	50                   	push   %eax
  8001e5:	68 6f 01 80 00       	push   $0x80016f
  8001ea:	e8 20 01 00 00       	call   80030f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001ef:	83 c4 08             	add    $0x8,%esp
  8001f2:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001f8:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001fe:	50                   	push   %eax
  8001ff:	e8 84 09 00 00       	call   800b88 <sys_cputs>

	return b.cnt;
}
  800204:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80020a:	c9                   	leave  
  80020b:	c3                   	ret    

0080020c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80020c:	f3 0f 1e fb          	endbr32 
  800210:	55                   	push   %ebp
  800211:	89 e5                	mov    %esp,%ebp
  800213:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800216:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800219:	50                   	push   %eax
  80021a:	ff 75 08             	pushl  0x8(%ebp)
  80021d:	e8 95 ff ff ff       	call   8001b7 <vcprintf>
	va_end(ap);

	return cnt;
}
  800222:	c9                   	leave  
  800223:	c3                   	ret    

00800224 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800224:	55                   	push   %ebp
  800225:	89 e5                	mov    %esp,%ebp
  800227:	57                   	push   %edi
  800228:	56                   	push   %esi
  800229:	53                   	push   %ebx
  80022a:	83 ec 1c             	sub    $0x1c,%esp
  80022d:	89 c7                	mov    %eax,%edi
  80022f:	89 d6                	mov    %edx,%esi
  800231:	8b 45 08             	mov    0x8(%ebp),%eax
  800234:	8b 55 0c             	mov    0xc(%ebp),%edx
  800237:	89 d1                	mov    %edx,%ecx
  800239:	89 c2                	mov    %eax,%edx
  80023b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80023e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800241:	8b 45 10             	mov    0x10(%ebp),%eax
  800244:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800247:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80024a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800251:	39 c2                	cmp    %eax,%edx
  800253:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800256:	72 3e                	jb     800296 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800258:	83 ec 0c             	sub    $0xc,%esp
  80025b:	ff 75 18             	pushl  0x18(%ebp)
  80025e:	83 eb 01             	sub    $0x1,%ebx
  800261:	53                   	push   %ebx
  800262:	50                   	push   %eax
  800263:	83 ec 08             	sub    $0x8,%esp
  800266:	ff 75 e4             	pushl  -0x1c(%ebp)
  800269:	ff 75 e0             	pushl  -0x20(%ebp)
  80026c:	ff 75 dc             	pushl  -0x24(%ebp)
  80026f:	ff 75 d8             	pushl  -0x28(%ebp)
  800272:	e8 39 1b 00 00       	call   801db0 <__udivdi3>
  800277:	83 c4 18             	add    $0x18,%esp
  80027a:	52                   	push   %edx
  80027b:	50                   	push   %eax
  80027c:	89 f2                	mov    %esi,%edx
  80027e:	89 f8                	mov    %edi,%eax
  800280:	e8 9f ff ff ff       	call   800224 <printnum>
  800285:	83 c4 20             	add    $0x20,%esp
  800288:	eb 13                	jmp    80029d <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	56                   	push   %esi
  80028e:	ff 75 18             	pushl  0x18(%ebp)
  800291:	ff d7                	call   *%edi
  800293:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800296:	83 eb 01             	sub    $0x1,%ebx
  800299:	85 db                	test   %ebx,%ebx
  80029b:	7f ed                	jg     80028a <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80029d:	83 ec 08             	sub    $0x8,%esp
  8002a0:	56                   	push   %esi
  8002a1:	83 ec 04             	sub    $0x4,%esp
  8002a4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a7:	ff 75 e0             	pushl  -0x20(%ebp)
  8002aa:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ad:	ff 75 d8             	pushl  -0x28(%ebp)
  8002b0:	e8 0b 1c 00 00       	call   801ec0 <__umoddi3>
  8002b5:	83 c4 14             	add    $0x14,%esp
  8002b8:	0f be 80 bb 20 80 00 	movsbl 0x8020bb(%eax),%eax
  8002bf:	50                   	push   %eax
  8002c0:	ff d7                	call   *%edi
}
  8002c2:	83 c4 10             	add    $0x10,%esp
  8002c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c8:	5b                   	pop    %ebx
  8002c9:	5e                   	pop    %esi
  8002ca:	5f                   	pop    %edi
  8002cb:	5d                   	pop    %ebp
  8002cc:	c3                   	ret    

008002cd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002cd:	f3 0f 1e fb          	endbr32 
  8002d1:	55                   	push   %ebp
  8002d2:	89 e5                	mov    %esp,%ebp
  8002d4:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002d7:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002db:	8b 10                	mov    (%eax),%edx
  8002dd:	3b 50 04             	cmp    0x4(%eax),%edx
  8002e0:	73 0a                	jae    8002ec <sprintputch+0x1f>
		*b->buf++ = ch;
  8002e2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002e5:	89 08                	mov    %ecx,(%eax)
  8002e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ea:	88 02                	mov    %al,(%edx)
}
  8002ec:	5d                   	pop    %ebp
  8002ed:	c3                   	ret    

008002ee <printfmt>:
{
  8002ee:	f3 0f 1e fb          	endbr32 
  8002f2:	55                   	push   %ebp
  8002f3:	89 e5                	mov    %esp,%ebp
  8002f5:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002f8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002fb:	50                   	push   %eax
  8002fc:	ff 75 10             	pushl  0x10(%ebp)
  8002ff:	ff 75 0c             	pushl  0xc(%ebp)
  800302:	ff 75 08             	pushl  0x8(%ebp)
  800305:	e8 05 00 00 00       	call   80030f <vprintfmt>
}
  80030a:	83 c4 10             	add    $0x10,%esp
  80030d:	c9                   	leave  
  80030e:	c3                   	ret    

0080030f <vprintfmt>:
{
  80030f:	f3 0f 1e fb          	endbr32 
  800313:	55                   	push   %ebp
  800314:	89 e5                	mov    %esp,%ebp
  800316:	57                   	push   %edi
  800317:	56                   	push   %esi
  800318:	53                   	push   %ebx
  800319:	83 ec 3c             	sub    $0x3c,%esp
  80031c:	8b 75 08             	mov    0x8(%ebp),%esi
  80031f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800322:	8b 7d 10             	mov    0x10(%ebp),%edi
  800325:	e9 8e 03 00 00       	jmp    8006b8 <vprintfmt+0x3a9>
		padc = ' ';
  80032a:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80032e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800335:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80033c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800343:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800348:	8d 47 01             	lea    0x1(%edi),%eax
  80034b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80034e:	0f b6 17             	movzbl (%edi),%edx
  800351:	8d 42 dd             	lea    -0x23(%edx),%eax
  800354:	3c 55                	cmp    $0x55,%al
  800356:	0f 87 df 03 00 00    	ja     80073b <vprintfmt+0x42c>
  80035c:	0f b6 c0             	movzbl %al,%eax
  80035f:	3e ff 24 85 00 22 80 	notrack jmp *0x802200(,%eax,4)
  800366:	00 
  800367:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80036a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80036e:	eb d8                	jmp    800348 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800370:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800373:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800377:	eb cf                	jmp    800348 <vprintfmt+0x39>
  800379:	0f b6 d2             	movzbl %dl,%edx
  80037c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80037f:	b8 00 00 00 00       	mov    $0x0,%eax
  800384:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800387:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80038a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80038e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800391:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800394:	83 f9 09             	cmp    $0x9,%ecx
  800397:	77 55                	ja     8003ee <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800399:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80039c:	eb e9                	jmp    800387 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80039e:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a1:	8b 00                	mov    (%eax),%eax
  8003a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a9:	8d 40 04             	lea    0x4(%eax),%eax
  8003ac:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003af:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003b2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003b6:	79 90                	jns    800348 <vprintfmt+0x39>
				width = precision, precision = -1;
  8003b8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003be:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003c5:	eb 81                	jmp    800348 <vprintfmt+0x39>
  8003c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ca:	85 c0                	test   %eax,%eax
  8003cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d1:	0f 49 d0             	cmovns %eax,%edx
  8003d4:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003da:	e9 69 ff ff ff       	jmp    800348 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003e2:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003e9:	e9 5a ff ff ff       	jmp    800348 <vprintfmt+0x39>
  8003ee:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003f4:	eb bc                	jmp    8003b2 <vprintfmt+0xa3>
			lflag++;
  8003f6:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003fc:	e9 47 ff ff ff       	jmp    800348 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800401:	8b 45 14             	mov    0x14(%ebp),%eax
  800404:	8d 78 04             	lea    0x4(%eax),%edi
  800407:	83 ec 08             	sub    $0x8,%esp
  80040a:	53                   	push   %ebx
  80040b:	ff 30                	pushl  (%eax)
  80040d:	ff d6                	call   *%esi
			break;
  80040f:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800412:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800415:	e9 9b 02 00 00       	jmp    8006b5 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80041a:	8b 45 14             	mov    0x14(%ebp),%eax
  80041d:	8d 78 04             	lea    0x4(%eax),%edi
  800420:	8b 00                	mov    (%eax),%eax
  800422:	99                   	cltd   
  800423:	31 d0                	xor    %edx,%eax
  800425:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800427:	83 f8 0f             	cmp    $0xf,%eax
  80042a:	7f 23                	jg     80044f <vprintfmt+0x140>
  80042c:	8b 14 85 60 23 80 00 	mov    0x802360(,%eax,4),%edx
  800433:	85 d2                	test   %edx,%edx
  800435:	74 18                	je     80044f <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800437:	52                   	push   %edx
  800438:	68 05 25 80 00       	push   $0x802505
  80043d:	53                   	push   %ebx
  80043e:	56                   	push   %esi
  80043f:	e8 aa fe ff ff       	call   8002ee <printfmt>
  800444:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800447:	89 7d 14             	mov    %edi,0x14(%ebp)
  80044a:	e9 66 02 00 00       	jmp    8006b5 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80044f:	50                   	push   %eax
  800450:	68 d3 20 80 00       	push   $0x8020d3
  800455:	53                   	push   %ebx
  800456:	56                   	push   %esi
  800457:	e8 92 fe ff ff       	call   8002ee <printfmt>
  80045c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80045f:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800462:	e9 4e 02 00 00       	jmp    8006b5 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800467:	8b 45 14             	mov    0x14(%ebp),%eax
  80046a:	83 c0 04             	add    $0x4,%eax
  80046d:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800470:	8b 45 14             	mov    0x14(%ebp),%eax
  800473:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800475:	85 d2                	test   %edx,%edx
  800477:	b8 cc 20 80 00       	mov    $0x8020cc,%eax
  80047c:	0f 45 c2             	cmovne %edx,%eax
  80047f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800482:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800486:	7e 06                	jle    80048e <vprintfmt+0x17f>
  800488:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80048c:	75 0d                	jne    80049b <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80048e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800491:	89 c7                	mov    %eax,%edi
  800493:	03 45 e0             	add    -0x20(%ebp),%eax
  800496:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800499:	eb 55                	jmp    8004f0 <vprintfmt+0x1e1>
  80049b:	83 ec 08             	sub    $0x8,%esp
  80049e:	ff 75 d8             	pushl  -0x28(%ebp)
  8004a1:	ff 75 cc             	pushl  -0x34(%ebp)
  8004a4:	e8 46 03 00 00       	call   8007ef <strnlen>
  8004a9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004ac:	29 c2                	sub    %eax,%edx
  8004ae:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004b1:	83 c4 10             	add    $0x10,%esp
  8004b4:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004b6:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004bd:	85 ff                	test   %edi,%edi
  8004bf:	7e 11                	jle    8004d2 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8004c1:	83 ec 08             	sub    $0x8,%esp
  8004c4:	53                   	push   %ebx
  8004c5:	ff 75 e0             	pushl  -0x20(%ebp)
  8004c8:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ca:	83 ef 01             	sub    $0x1,%edi
  8004cd:	83 c4 10             	add    $0x10,%esp
  8004d0:	eb eb                	jmp    8004bd <vprintfmt+0x1ae>
  8004d2:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004d5:	85 d2                	test   %edx,%edx
  8004d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8004dc:	0f 49 c2             	cmovns %edx,%eax
  8004df:	29 c2                	sub    %eax,%edx
  8004e1:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004e4:	eb a8                	jmp    80048e <vprintfmt+0x17f>
					putch(ch, putdat);
  8004e6:	83 ec 08             	sub    $0x8,%esp
  8004e9:	53                   	push   %ebx
  8004ea:	52                   	push   %edx
  8004eb:	ff d6                	call   *%esi
  8004ed:	83 c4 10             	add    $0x10,%esp
  8004f0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004f3:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004f5:	83 c7 01             	add    $0x1,%edi
  8004f8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004fc:	0f be d0             	movsbl %al,%edx
  8004ff:	85 d2                	test   %edx,%edx
  800501:	74 4b                	je     80054e <vprintfmt+0x23f>
  800503:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800507:	78 06                	js     80050f <vprintfmt+0x200>
  800509:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80050d:	78 1e                	js     80052d <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  80050f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800513:	74 d1                	je     8004e6 <vprintfmt+0x1d7>
  800515:	0f be c0             	movsbl %al,%eax
  800518:	83 e8 20             	sub    $0x20,%eax
  80051b:	83 f8 5e             	cmp    $0x5e,%eax
  80051e:	76 c6                	jbe    8004e6 <vprintfmt+0x1d7>
					putch('?', putdat);
  800520:	83 ec 08             	sub    $0x8,%esp
  800523:	53                   	push   %ebx
  800524:	6a 3f                	push   $0x3f
  800526:	ff d6                	call   *%esi
  800528:	83 c4 10             	add    $0x10,%esp
  80052b:	eb c3                	jmp    8004f0 <vprintfmt+0x1e1>
  80052d:	89 cf                	mov    %ecx,%edi
  80052f:	eb 0e                	jmp    80053f <vprintfmt+0x230>
				putch(' ', putdat);
  800531:	83 ec 08             	sub    $0x8,%esp
  800534:	53                   	push   %ebx
  800535:	6a 20                	push   $0x20
  800537:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800539:	83 ef 01             	sub    $0x1,%edi
  80053c:	83 c4 10             	add    $0x10,%esp
  80053f:	85 ff                	test   %edi,%edi
  800541:	7f ee                	jg     800531 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800543:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800546:	89 45 14             	mov    %eax,0x14(%ebp)
  800549:	e9 67 01 00 00       	jmp    8006b5 <vprintfmt+0x3a6>
  80054e:	89 cf                	mov    %ecx,%edi
  800550:	eb ed                	jmp    80053f <vprintfmt+0x230>
	if (lflag >= 2)
  800552:	83 f9 01             	cmp    $0x1,%ecx
  800555:	7f 1b                	jg     800572 <vprintfmt+0x263>
	else if (lflag)
  800557:	85 c9                	test   %ecx,%ecx
  800559:	74 63                	je     8005be <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80055b:	8b 45 14             	mov    0x14(%ebp),%eax
  80055e:	8b 00                	mov    (%eax),%eax
  800560:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800563:	99                   	cltd   
  800564:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800567:	8b 45 14             	mov    0x14(%ebp),%eax
  80056a:	8d 40 04             	lea    0x4(%eax),%eax
  80056d:	89 45 14             	mov    %eax,0x14(%ebp)
  800570:	eb 17                	jmp    800589 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800572:	8b 45 14             	mov    0x14(%ebp),%eax
  800575:	8b 50 04             	mov    0x4(%eax),%edx
  800578:	8b 00                	mov    (%eax),%eax
  80057a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80057d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800580:	8b 45 14             	mov    0x14(%ebp),%eax
  800583:	8d 40 08             	lea    0x8(%eax),%eax
  800586:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800589:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80058c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80058f:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800594:	85 c9                	test   %ecx,%ecx
  800596:	0f 89 ff 00 00 00    	jns    80069b <vprintfmt+0x38c>
				putch('-', putdat);
  80059c:	83 ec 08             	sub    $0x8,%esp
  80059f:	53                   	push   %ebx
  8005a0:	6a 2d                	push   $0x2d
  8005a2:	ff d6                	call   *%esi
				num = -(long long) num;
  8005a4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005a7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005aa:	f7 da                	neg    %edx
  8005ac:	83 d1 00             	adc    $0x0,%ecx
  8005af:	f7 d9                	neg    %ecx
  8005b1:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005b4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005b9:	e9 dd 00 00 00       	jmp    80069b <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8005be:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c1:	8b 00                	mov    (%eax),%eax
  8005c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c6:	99                   	cltd   
  8005c7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cd:	8d 40 04             	lea    0x4(%eax),%eax
  8005d0:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d3:	eb b4                	jmp    800589 <vprintfmt+0x27a>
	if (lflag >= 2)
  8005d5:	83 f9 01             	cmp    $0x1,%ecx
  8005d8:	7f 1e                	jg     8005f8 <vprintfmt+0x2e9>
	else if (lflag)
  8005da:	85 c9                	test   %ecx,%ecx
  8005dc:	74 32                	je     800610 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8005de:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e1:	8b 10                	mov    (%eax),%edx
  8005e3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005e8:	8d 40 04             	lea    0x4(%eax),%eax
  8005eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ee:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8005f3:	e9 a3 00 00 00       	jmp    80069b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fb:	8b 10                	mov    (%eax),%edx
  8005fd:	8b 48 04             	mov    0x4(%eax),%ecx
  800600:	8d 40 08             	lea    0x8(%eax),%eax
  800603:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800606:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80060b:	e9 8b 00 00 00       	jmp    80069b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800610:	8b 45 14             	mov    0x14(%ebp),%eax
  800613:	8b 10                	mov    (%eax),%edx
  800615:	b9 00 00 00 00       	mov    $0x0,%ecx
  80061a:	8d 40 04             	lea    0x4(%eax),%eax
  80061d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800620:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800625:	eb 74                	jmp    80069b <vprintfmt+0x38c>
	if (lflag >= 2)
  800627:	83 f9 01             	cmp    $0x1,%ecx
  80062a:	7f 1b                	jg     800647 <vprintfmt+0x338>
	else if (lflag)
  80062c:	85 c9                	test   %ecx,%ecx
  80062e:	74 2c                	je     80065c <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800630:	8b 45 14             	mov    0x14(%ebp),%eax
  800633:	8b 10                	mov    (%eax),%edx
  800635:	b9 00 00 00 00       	mov    $0x0,%ecx
  80063a:	8d 40 04             	lea    0x4(%eax),%eax
  80063d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800640:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800645:	eb 54                	jmp    80069b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800647:	8b 45 14             	mov    0x14(%ebp),%eax
  80064a:	8b 10                	mov    (%eax),%edx
  80064c:	8b 48 04             	mov    0x4(%eax),%ecx
  80064f:	8d 40 08             	lea    0x8(%eax),%eax
  800652:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800655:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80065a:	eb 3f                	jmp    80069b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8b 10                	mov    (%eax),%edx
  800661:	b9 00 00 00 00       	mov    $0x0,%ecx
  800666:	8d 40 04             	lea    0x4(%eax),%eax
  800669:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80066c:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800671:	eb 28                	jmp    80069b <vprintfmt+0x38c>
			putch('0', putdat);
  800673:	83 ec 08             	sub    $0x8,%esp
  800676:	53                   	push   %ebx
  800677:	6a 30                	push   $0x30
  800679:	ff d6                	call   *%esi
			putch('x', putdat);
  80067b:	83 c4 08             	add    $0x8,%esp
  80067e:	53                   	push   %ebx
  80067f:	6a 78                	push   $0x78
  800681:	ff d6                	call   *%esi
			num = (unsigned long long)
  800683:	8b 45 14             	mov    0x14(%ebp),%eax
  800686:	8b 10                	mov    (%eax),%edx
  800688:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80068d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800690:	8d 40 04             	lea    0x4(%eax),%eax
  800693:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800696:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80069b:	83 ec 0c             	sub    $0xc,%esp
  80069e:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8006a2:	57                   	push   %edi
  8006a3:	ff 75 e0             	pushl  -0x20(%ebp)
  8006a6:	50                   	push   %eax
  8006a7:	51                   	push   %ecx
  8006a8:	52                   	push   %edx
  8006a9:	89 da                	mov    %ebx,%edx
  8006ab:	89 f0                	mov    %esi,%eax
  8006ad:	e8 72 fb ff ff       	call   800224 <printnum>
			break;
  8006b2:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006b5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006b8:	83 c7 01             	add    $0x1,%edi
  8006bb:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006bf:	83 f8 25             	cmp    $0x25,%eax
  8006c2:	0f 84 62 fc ff ff    	je     80032a <vprintfmt+0x1b>
			if (ch == '\0')
  8006c8:	85 c0                	test   %eax,%eax
  8006ca:	0f 84 8b 00 00 00    	je     80075b <vprintfmt+0x44c>
			putch(ch, putdat);
  8006d0:	83 ec 08             	sub    $0x8,%esp
  8006d3:	53                   	push   %ebx
  8006d4:	50                   	push   %eax
  8006d5:	ff d6                	call   *%esi
  8006d7:	83 c4 10             	add    $0x10,%esp
  8006da:	eb dc                	jmp    8006b8 <vprintfmt+0x3a9>
	if (lflag >= 2)
  8006dc:	83 f9 01             	cmp    $0x1,%ecx
  8006df:	7f 1b                	jg     8006fc <vprintfmt+0x3ed>
	else if (lflag)
  8006e1:	85 c9                	test   %ecx,%ecx
  8006e3:	74 2c                	je     800711 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8006e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e8:	8b 10                	mov    (%eax),%edx
  8006ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ef:	8d 40 04             	lea    0x4(%eax),%eax
  8006f2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006f5:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8006fa:	eb 9f                	jmp    80069b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8006fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ff:	8b 10                	mov    (%eax),%edx
  800701:	8b 48 04             	mov    0x4(%eax),%ecx
  800704:	8d 40 08             	lea    0x8(%eax),%eax
  800707:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80070a:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  80070f:	eb 8a                	jmp    80069b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800711:	8b 45 14             	mov    0x14(%ebp),%eax
  800714:	8b 10                	mov    (%eax),%edx
  800716:	b9 00 00 00 00       	mov    $0x0,%ecx
  80071b:	8d 40 04             	lea    0x4(%eax),%eax
  80071e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800721:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800726:	e9 70 ff ff ff       	jmp    80069b <vprintfmt+0x38c>
			putch(ch, putdat);
  80072b:	83 ec 08             	sub    $0x8,%esp
  80072e:	53                   	push   %ebx
  80072f:	6a 25                	push   $0x25
  800731:	ff d6                	call   *%esi
			break;
  800733:	83 c4 10             	add    $0x10,%esp
  800736:	e9 7a ff ff ff       	jmp    8006b5 <vprintfmt+0x3a6>
			putch('%', putdat);
  80073b:	83 ec 08             	sub    $0x8,%esp
  80073e:	53                   	push   %ebx
  80073f:	6a 25                	push   $0x25
  800741:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800743:	83 c4 10             	add    $0x10,%esp
  800746:	89 f8                	mov    %edi,%eax
  800748:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80074c:	74 05                	je     800753 <vprintfmt+0x444>
  80074e:	83 e8 01             	sub    $0x1,%eax
  800751:	eb f5                	jmp    800748 <vprintfmt+0x439>
  800753:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800756:	e9 5a ff ff ff       	jmp    8006b5 <vprintfmt+0x3a6>
}
  80075b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80075e:	5b                   	pop    %ebx
  80075f:	5e                   	pop    %esi
  800760:	5f                   	pop    %edi
  800761:	5d                   	pop    %ebp
  800762:	c3                   	ret    

00800763 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800763:	f3 0f 1e fb          	endbr32 
  800767:	55                   	push   %ebp
  800768:	89 e5                	mov    %esp,%ebp
  80076a:	83 ec 18             	sub    $0x18,%esp
  80076d:	8b 45 08             	mov    0x8(%ebp),%eax
  800770:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800773:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800776:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80077a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80077d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800784:	85 c0                	test   %eax,%eax
  800786:	74 26                	je     8007ae <vsnprintf+0x4b>
  800788:	85 d2                	test   %edx,%edx
  80078a:	7e 22                	jle    8007ae <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80078c:	ff 75 14             	pushl  0x14(%ebp)
  80078f:	ff 75 10             	pushl  0x10(%ebp)
  800792:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800795:	50                   	push   %eax
  800796:	68 cd 02 80 00       	push   $0x8002cd
  80079b:	e8 6f fb ff ff       	call   80030f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007a3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007a9:	83 c4 10             	add    $0x10,%esp
}
  8007ac:	c9                   	leave  
  8007ad:	c3                   	ret    
		return -E_INVAL;
  8007ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007b3:	eb f7                	jmp    8007ac <vsnprintf+0x49>

008007b5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007b5:	f3 0f 1e fb          	endbr32 
  8007b9:	55                   	push   %ebp
  8007ba:	89 e5                	mov    %esp,%ebp
  8007bc:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007bf:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007c2:	50                   	push   %eax
  8007c3:	ff 75 10             	pushl  0x10(%ebp)
  8007c6:	ff 75 0c             	pushl  0xc(%ebp)
  8007c9:	ff 75 08             	pushl  0x8(%ebp)
  8007cc:	e8 92 ff ff ff       	call   800763 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007d1:	c9                   	leave  
  8007d2:	c3                   	ret    

008007d3 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007d3:	f3 0f 1e fb          	endbr32 
  8007d7:	55                   	push   %ebp
  8007d8:	89 e5                	mov    %esp,%ebp
  8007da:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e2:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007e6:	74 05                	je     8007ed <strlen+0x1a>
		n++;
  8007e8:	83 c0 01             	add    $0x1,%eax
  8007eb:	eb f5                	jmp    8007e2 <strlen+0xf>
	return n;
}
  8007ed:	5d                   	pop    %ebp
  8007ee:	c3                   	ret    

008007ef <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007ef:	f3 0f 1e fb          	endbr32 
  8007f3:	55                   	push   %ebp
  8007f4:	89 e5                	mov    %esp,%ebp
  8007f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007f9:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800801:	39 d0                	cmp    %edx,%eax
  800803:	74 0d                	je     800812 <strnlen+0x23>
  800805:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800809:	74 05                	je     800810 <strnlen+0x21>
		n++;
  80080b:	83 c0 01             	add    $0x1,%eax
  80080e:	eb f1                	jmp    800801 <strnlen+0x12>
  800810:	89 c2                	mov    %eax,%edx
	return n;
}
  800812:	89 d0                	mov    %edx,%eax
  800814:	5d                   	pop    %ebp
  800815:	c3                   	ret    

00800816 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800816:	f3 0f 1e fb          	endbr32 
  80081a:	55                   	push   %ebp
  80081b:	89 e5                	mov    %esp,%ebp
  80081d:	53                   	push   %ebx
  80081e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800821:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800824:	b8 00 00 00 00       	mov    $0x0,%eax
  800829:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80082d:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800830:	83 c0 01             	add    $0x1,%eax
  800833:	84 d2                	test   %dl,%dl
  800835:	75 f2                	jne    800829 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800837:	89 c8                	mov    %ecx,%eax
  800839:	5b                   	pop    %ebx
  80083a:	5d                   	pop    %ebp
  80083b:	c3                   	ret    

0080083c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80083c:	f3 0f 1e fb          	endbr32 
  800840:	55                   	push   %ebp
  800841:	89 e5                	mov    %esp,%ebp
  800843:	53                   	push   %ebx
  800844:	83 ec 10             	sub    $0x10,%esp
  800847:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80084a:	53                   	push   %ebx
  80084b:	e8 83 ff ff ff       	call   8007d3 <strlen>
  800850:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800853:	ff 75 0c             	pushl  0xc(%ebp)
  800856:	01 d8                	add    %ebx,%eax
  800858:	50                   	push   %eax
  800859:	e8 b8 ff ff ff       	call   800816 <strcpy>
	return dst;
}
  80085e:	89 d8                	mov    %ebx,%eax
  800860:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800863:	c9                   	leave  
  800864:	c3                   	ret    

00800865 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800865:	f3 0f 1e fb          	endbr32 
  800869:	55                   	push   %ebp
  80086a:	89 e5                	mov    %esp,%ebp
  80086c:	56                   	push   %esi
  80086d:	53                   	push   %ebx
  80086e:	8b 75 08             	mov    0x8(%ebp),%esi
  800871:	8b 55 0c             	mov    0xc(%ebp),%edx
  800874:	89 f3                	mov    %esi,%ebx
  800876:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800879:	89 f0                	mov    %esi,%eax
  80087b:	39 d8                	cmp    %ebx,%eax
  80087d:	74 11                	je     800890 <strncpy+0x2b>
		*dst++ = *src;
  80087f:	83 c0 01             	add    $0x1,%eax
  800882:	0f b6 0a             	movzbl (%edx),%ecx
  800885:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800888:	80 f9 01             	cmp    $0x1,%cl
  80088b:	83 da ff             	sbb    $0xffffffff,%edx
  80088e:	eb eb                	jmp    80087b <strncpy+0x16>
	}
	return ret;
}
  800890:	89 f0                	mov    %esi,%eax
  800892:	5b                   	pop    %ebx
  800893:	5e                   	pop    %esi
  800894:	5d                   	pop    %ebp
  800895:	c3                   	ret    

00800896 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800896:	f3 0f 1e fb          	endbr32 
  80089a:	55                   	push   %ebp
  80089b:	89 e5                	mov    %esp,%ebp
  80089d:	56                   	push   %esi
  80089e:	53                   	push   %ebx
  80089f:	8b 75 08             	mov    0x8(%ebp),%esi
  8008a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008a5:	8b 55 10             	mov    0x10(%ebp),%edx
  8008a8:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008aa:	85 d2                	test   %edx,%edx
  8008ac:	74 21                	je     8008cf <strlcpy+0x39>
  8008ae:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008b2:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008b4:	39 c2                	cmp    %eax,%edx
  8008b6:	74 14                	je     8008cc <strlcpy+0x36>
  8008b8:	0f b6 19             	movzbl (%ecx),%ebx
  8008bb:	84 db                	test   %bl,%bl
  8008bd:	74 0b                	je     8008ca <strlcpy+0x34>
			*dst++ = *src++;
  8008bf:	83 c1 01             	add    $0x1,%ecx
  8008c2:	83 c2 01             	add    $0x1,%edx
  8008c5:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008c8:	eb ea                	jmp    8008b4 <strlcpy+0x1e>
  8008ca:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008cc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008cf:	29 f0                	sub    %esi,%eax
}
  8008d1:	5b                   	pop    %ebx
  8008d2:	5e                   	pop    %esi
  8008d3:	5d                   	pop    %ebp
  8008d4:	c3                   	ret    

008008d5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008d5:	f3 0f 1e fb          	endbr32 
  8008d9:	55                   	push   %ebp
  8008da:	89 e5                	mov    %esp,%ebp
  8008dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008df:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008e2:	0f b6 01             	movzbl (%ecx),%eax
  8008e5:	84 c0                	test   %al,%al
  8008e7:	74 0c                	je     8008f5 <strcmp+0x20>
  8008e9:	3a 02                	cmp    (%edx),%al
  8008eb:	75 08                	jne    8008f5 <strcmp+0x20>
		p++, q++;
  8008ed:	83 c1 01             	add    $0x1,%ecx
  8008f0:	83 c2 01             	add    $0x1,%edx
  8008f3:	eb ed                	jmp    8008e2 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008f5:	0f b6 c0             	movzbl %al,%eax
  8008f8:	0f b6 12             	movzbl (%edx),%edx
  8008fb:	29 d0                	sub    %edx,%eax
}
  8008fd:	5d                   	pop    %ebp
  8008fe:	c3                   	ret    

008008ff <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008ff:	f3 0f 1e fb          	endbr32 
  800903:	55                   	push   %ebp
  800904:	89 e5                	mov    %esp,%ebp
  800906:	53                   	push   %ebx
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090d:	89 c3                	mov    %eax,%ebx
  80090f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800912:	eb 06                	jmp    80091a <strncmp+0x1b>
		n--, p++, q++;
  800914:	83 c0 01             	add    $0x1,%eax
  800917:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80091a:	39 d8                	cmp    %ebx,%eax
  80091c:	74 16                	je     800934 <strncmp+0x35>
  80091e:	0f b6 08             	movzbl (%eax),%ecx
  800921:	84 c9                	test   %cl,%cl
  800923:	74 04                	je     800929 <strncmp+0x2a>
  800925:	3a 0a                	cmp    (%edx),%cl
  800927:	74 eb                	je     800914 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800929:	0f b6 00             	movzbl (%eax),%eax
  80092c:	0f b6 12             	movzbl (%edx),%edx
  80092f:	29 d0                	sub    %edx,%eax
}
  800931:	5b                   	pop    %ebx
  800932:	5d                   	pop    %ebp
  800933:	c3                   	ret    
		return 0;
  800934:	b8 00 00 00 00       	mov    $0x0,%eax
  800939:	eb f6                	jmp    800931 <strncmp+0x32>

0080093b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80093b:	f3 0f 1e fb          	endbr32 
  80093f:	55                   	push   %ebp
  800940:	89 e5                	mov    %esp,%ebp
  800942:	8b 45 08             	mov    0x8(%ebp),%eax
  800945:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800949:	0f b6 10             	movzbl (%eax),%edx
  80094c:	84 d2                	test   %dl,%dl
  80094e:	74 09                	je     800959 <strchr+0x1e>
		if (*s == c)
  800950:	38 ca                	cmp    %cl,%dl
  800952:	74 0a                	je     80095e <strchr+0x23>
	for (; *s; s++)
  800954:	83 c0 01             	add    $0x1,%eax
  800957:	eb f0                	jmp    800949 <strchr+0xe>
			return (char *) s;
	return 0;
  800959:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80095e:	5d                   	pop    %ebp
  80095f:	c3                   	ret    

00800960 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800960:	f3 0f 1e fb          	endbr32 
  800964:	55                   	push   %ebp
  800965:	89 e5                	mov    %esp,%ebp
  800967:	8b 45 08             	mov    0x8(%ebp),%eax
  80096a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80096e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800971:	38 ca                	cmp    %cl,%dl
  800973:	74 09                	je     80097e <strfind+0x1e>
  800975:	84 d2                	test   %dl,%dl
  800977:	74 05                	je     80097e <strfind+0x1e>
	for (; *s; s++)
  800979:	83 c0 01             	add    $0x1,%eax
  80097c:	eb f0                	jmp    80096e <strfind+0xe>
			break;
	return (char *) s;
}
  80097e:	5d                   	pop    %ebp
  80097f:	c3                   	ret    

00800980 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800980:	f3 0f 1e fb          	endbr32 
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
  800987:	57                   	push   %edi
  800988:	56                   	push   %esi
  800989:	53                   	push   %ebx
  80098a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80098d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800990:	85 c9                	test   %ecx,%ecx
  800992:	74 31                	je     8009c5 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800994:	89 f8                	mov    %edi,%eax
  800996:	09 c8                	or     %ecx,%eax
  800998:	a8 03                	test   $0x3,%al
  80099a:	75 23                	jne    8009bf <memset+0x3f>
		c &= 0xFF;
  80099c:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009a0:	89 d3                	mov    %edx,%ebx
  8009a2:	c1 e3 08             	shl    $0x8,%ebx
  8009a5:	89 d0                	mov    %edx,%eax
  8009a7:	c1 e0 18             	shl    $0x18,%eax
  8009aa:	89 d6                	mov    %edx,%esi
  8009ac:	c1 e6 10             	shl    $0x10,%esi
  8009af:	09 f0                	or     %esi,%eax
  8009b1:	09 c2                	or     %eax,%edx
  8009b3:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009b5:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009b8:	89 d0                	mov    %edx,%eax
  8009ba:	fc                   	cld    
  8009bb:	f3 ab                	rep stos %eax,%es:(%edi)
  8009bd:	eb 06                	jmp    8009c5 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c2:	fc                   	cld    
  8009c3:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009c5:	89 f8                	mov    %edi,%eax
  8009c7:	5b                   	pop    %ebx
  8009c8:	5e                   	pop    %esi
  8009c9:	5f                   	pop    %edi
  8009ca:	5d                   	pop    %ebp
  8009cb:	c3                   	ret    

008009cc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009cc:	f3 0f 1e fb          	endbr32 
  8009d0:	55                   	push   %ebp
  8009d1:	89 e5                	mov    %esp,%ebp
  8009d3:	57                   	push   %edi
  8009d4:	56                   	push   %esi
  8009d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009db:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009de:	39 c6                	cmp    %eax,%esi
  8009e0:	73 32                	jae    800a14 <memmove+0x48>
  8009e2:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009e5:	39 c2                	cmp    %eax,%edx
  8009e7:	76 2b                	jbe    800a14 <memmove+0x48>
		s += n;
		d += n;
  8009e9:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009ec:	89 fe                	mov    %edi,%esi
  8009ee:	09 ce                	or     %ecx,%esi
  8009f0:	09 d6                	or     %edx,%esi
  8009f2:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009f8:	75 0e                	jne    800a08 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009fa:	83 ef 04             	sub    $0x4,%edi
  8009fd:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a00:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a03:	fd                   	std    
  800a04:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a06:	eb 09                	jmp    800a11 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a08:	83 ef 01             	sub    $0x1,%edi
  800a0b:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a0e:	fd                   	std    
  800a0f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a11:	fc                   	cld    
  800a12:	eb 1a                	jmp    800a2e <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a14:	89 c2                	mov    %eax,%edx
  800a16:	09 ca                	or     %ecx,%edx
  800a18:	09 f2                	or     %esi,%edx
  800a1a:	f6 c2 03             	test   $0x3,%dl
  800a1d:	75 0a                	jne    800a29 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a1f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a22:	89 c7                	mov    %eax,%edi
  800a24:	fc                   	cld    
  800a25:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a27:	eb 05                	jmp    800a2e <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800a29:	89 c7                	mov    %eax,%edi
  800a2b:	fc                   	cld    
  800a2c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a2e:	5e                   	pop    %esi
  800a2f:	5f                   	pop    %edi
  800a30:	5d                   	pop    %ebp
  800a31:	c3                   	ret    

00800a32 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a32:	f3 0f 1e fb          	endbr32 
  800a36:	55                   	push   %ebp
  800a37:	89 e5                	mov    %esp,%ebp
  800a39:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a3c:	ff 75 10             	pushl  0x10(%ebp)
  800a3f:	ff 75 0c             	pushl  0xc(%ebp)
  800a42:	ff 75 08             	pushl  0x8(%ebp)
  800a45:	e8 82 ff ff ff       	call   8009cc <memmove>
}
  800a4a:	c9                   	leave  
  800a4b:	c3                   	ret    

00800a4c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a4c:	f3 0f 1e fb          	endbr32 
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	56                   	push   %esi
  800a54:	53                   	push   %ebx
  800a55:	8b 45 08             	mov    0x8(%ebp),%eax
  800a58:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a5b:	89 c6                	mov    %eax,%esi
  800a5d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a60:	39 f0                	cmp    %esi,%eax
  800a62:	74 1c                	je     800a80 <memcmp+0x34>
		if (*s1 != *s2)
  800a64:	0f b6 08             	movzbl (%eax),%ecx
  800a67:	0f b6 1a             	movzbl (%edx),%ebx
  800a6a:	38 d9                	cmp    %bl,%cl
  800a6c:	75 08                	jne    800a76 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a6e:	83 c0 01             	add    $0x1,%eax
  800a71:	83 c2 01             	add    $0x1,%edx
  800a74:	eb ea                	jmp    800a60 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a76:	0f b6 c1             	movzbl %cl,%eax
  800a79:	0f b6 db             	movzbl %bl,%ebx
  800a7c:	29 d8                	sub    %ebx,%eax
  800a7e:	eb 05                	jmp    800a85 <memcmp+0x39>
	}

	return 0;
  800a80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a85:	5b                   	pop    %ebx
  800a86:	5e                   	pop    %esi
  800a87:	5d                   	pop    %ebp
  800a88:	c3                   	ret    

00800a89 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a89:	f3 0f 1e fb          	endbr32 
  800a8d:	55                   	push   %ebp
  800a8e:	89 e5                	mov    %esp,%ebp
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a96:	89 c2                	mov    %eax,%edx
  800a98:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a9b:	39 d0                	cmp    %edx,%eax
  800a9d:	73 09                	jae    800aa8 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a9f:	38 08                	cmp    %cl,(%eax)
  800aa1:	74 05                	je     800aa8 <memfind+0x1f>
	for (; s < ends; s++)
  800aa3:	83 c0 01             	add    $0x1,%eax
  800aa6:	eb f3                	jmp    800a9b <memfind+0x12>
			break;
	return (void *) s;
}
  800aa8:	5d                   	pop    %ebp
  800aa9:	c3                   	ret    

00800aaa <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800aaa:	f3 0f 1e fb          	endbr32 
  800aae:	55                   	push   %ebp
  800aaf:	89 e5                	mov    %esp,%ebp
  800ab1:	57                   	push   %edi
  800ab2:	56                   	push   %esi
  800ab3:	53                   	push   %ebx
  800ab4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ab7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aba:	eb 03                	jmp    800abf <strtol+0x15>
		s++;
  800abc:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800abf:	0f b6 01             	movzbl (%ecx),%eax
  800ac2:	3c 20                	cmp    $0x20,%al
  800ac4:	74 f6                	je     800abc <strtol+0x12>
  800ac6:	3c 09                	cmp    $0x9,%al
  800ac8:	74 f2                	je     800abc <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800aca:	3c 2b                	cmp    $0x2b,%al
  800acc:	74 2a                	je     800af8 <strtol+0x4e>
	int neg = 0;
  800ace:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ad3:	3c 2d                	cmp    $0x2d,%al
  800ad5:	74 2b                	je     800b02 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ad7:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800add:	75 0f                	jne    800aee <strtol+0x44>
  800adf:	80 39 30             	cmpb   $0x30,(%ecx)
  800ae2:	74 28                	je     800b0c <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ae4:	85 db                	test   %ebx,%ebx
  800ae6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800aeb:	0f 44 d8             	cmove  %eax,%ebx
  800aee:	b8 00 00 00 00       	mov    $0x0,%eax
  800af3:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800af6:	eb 46                	jmp    800b3e <strtol+0x94>
		s++;
  800af8:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800afb:	bf 00 00 00 00       	mov    $0x0,%edi
  800b00:	eb d5                	jmp    800ad7 <strtol+0x2d>
		s++, neg = 1;
  800b02:	83 c1 01             	add    $0x1,%ecx
  800b05:	bf 01 00 00 00       	mov    $0x1,%edi
  800b0a:	eb cb                	jmp    800ad7 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b0c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b10:	74 0e                	je     800b20 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b12:	85 db                	test   %ebx,%ebx
  800b14:	75 d8                	jne    800aee <strtol+0x44>
		s++, base = 8;
  800b16:	83 c1 01             	add    $0x1,%ecx
  800b19:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b1e:	eb ce                	jmp    800aee <strtol+0x44>
		s += 2, base = 16;
  800b20:	83 c1 02             	add    $0x2,%ecx
  800b23:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b28:	eb c4                	jmp    800aee <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b2a:	0f be d2             	movsbl %dl,%edx
  800b2d:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b30:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b33:	7d 3a                	jge    800b6f <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b35:	83 c1 01             	add    $0x1,%ecx
  800b38:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b3c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b3e:	0f b6 11             	movzbl (%ecx),%edx
  800b41:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b44:	89 f3                	mov    %esi,%ebx
  800b46:	80 fb 09             	cmp    $0x9,%bl
  800b49:	76 df                	jbe    800b2a <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b4b:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b4e:	89 f3                	mov    %esi,%ebx
  800b50:	80 fb 19             	cmp    $0x19,%bl
  800b53:	77 08                	ja     800b5d <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b55:	0f be d2             	movsbl %dl,%edx
  800b58:	83 ea 57             	sub    $0x57,%edx
  800b5b:	eb d3                	jmp    800b30 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b5d:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b60:	89 f3                	mov    %esi,%ebx
  800b62:	80 fb 19             	cmp    $0x19,%bl
  800b65:	77 08                	ja     800b6f <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b67:	0f be d2             	movsbl %dl,%edx
  800b6a:	83 ea 37             	sub    $0x37,%edx
  800b6d:	eb c1                	jmp    800b30 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b73:	74 05                	je     800b7a <strtol+0xd0>
		*endptr = (char *) s;
  800b75:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b78:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b7a:	89 c2                	mov    %eax,%edx
  800b7c:	f7 da                	neg    %edx
  800b7e:	85 ff                	test   %edi,%edi
  800b80:	0f 45 c2             	cmovne %edx,%eax
}
  800b83:	5b                   	pop    %ebx
  800b84:	5e                   	pop    %esi
  800b85:	5f                   	pop    %edi
  800b86:	5d                   	pop    %ebp
  800b87:	c3                   	ret    

00800b88 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b88:	f3 0f 1e fb          	endbr32 
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	57                   	push   %edi
  800b90:	56                   	push   %esi
  800b91:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b92:	b8 00 00 00 00       	mov    $0x0,%eax
  800b97:	8b 55 08             	mov    0x8(%ebp),%edx
  800b9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b9d:	89 c3                	mov    %eax,%ebx
  800b9f:	89 c7                	mov    %eax,%edi
  800ba1:	89 c6                	mov    %eax,%esi
  800ba3:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ba5:	5b                   	pop    %ebx
  800ba6:	5e                   	pop    %esi
  800ba7:	5f                   	pop    %edi
  800ba8:	5d                   	pop    %ebp
  800ba9:	c3                   	ret    

00800baa <sys_cgetc>:

int
sys_cgetc(void)
{
  800baa:	f3 0f 1e fb          	endbr32 
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	57                   	push   %edi
  800bb2:	56                   	push   %esi
  800bb3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bb4:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb9:	b8 01 00 00 00       	mov    $0x1,%eax
  800bbe:	89 d1                	mov    %edx,%ecx
  800bc0:	89 d3                	mov    %edx,%ebx
  800bc2:	89 d7                	mov    %edx,%edi
  800bc4:	89 d6                	mov    %edx,%esi
  800bc6:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bc8:	5b                   	pop    %ebx
  800bc9:	5e                   	pop    %esi
  800bca:	5f                   	pop    %edi
  800bcb:	5d                   	pop    %ebp
  800bcc:	c3                   	ret    

00800bcd <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bcd:	f3 0f 1e fb          	endbr32 
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	57                   	push   %edi
  800bd5:	56                   	push   %esi
  800bd6:	53                   	push   %ebx
  800bd7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bda:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bdf:	8b 55 08             	mov    0x8(%ebp),%edx
  800be2:	b8 03 00 00 00       	mov    $0x3,%eax
  800be7:	89 cb                	mov    %ecx,%ebx
  800be9:	89 cf                	mov    %ecx,%edi
  800beb:	89 ce                	mov    %ecx,%esi
  800bed:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bef:	85 c0                	test   %eax,%eax
  800bf1:	7f 08                	jg     800bfb <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bf3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bf6:	5b                   	pop    %ebx
  800bf7:	5e                   	pop    %esi
  800bf8:	5f                   	pop    %edi
  800bf9:	5d                   	pop    %ebp
  800bfa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bfb:	83 ec 0c             	sub    $0xc,%esp
  800bfe:	50                   	push   %eax
  800bff:	6a 03                	push   $0x3
  800c01:	68 bf 23 80 00       	push   $0x8023bf
  800c06:	6a 23                	push   $0x23
  800c08:	68 dc 23 80 00       	push   $0x8023dc
  800c0d:	e8 13 f5 ff ff       	call   800125 <_panic>

00800c12 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c12:	f3 0f 1e fb          	endbr32 
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	57                   	push   %edi
  800c1a:	56                   	push   %esi
  800c1b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c1c:	ba 00 00 00 00       	mov    $0x0,%edx
  800c21:	b8 02 00 00 00       	mov    $0x2,%eax
  800c26:	89 d1                	mov    %edx,%ecx
  800c28:	89 d3                	mov    %edx,%ebx
  800c2a:	89 d7                	mov    %edx,%edi
  800c2c:	89 d6                	mov    %edx,%esi
  800c2e:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c30:	5b                   	pop    %ebx
  800c31:	5e                   	pop    %esi
  800c32:	5f                   	pop    %edi
  800c33:	5d                   	pop    %ebp
  800c34:	c3                   	ret    

00800c35 <sys_yield>:

void
sys_yield(void)
{
  800c35:	f3 0f 1e fb          	endbr32 
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
  800c3c:	57                   	push   %edi
  800c3d:	56                   	push   %esi
  800c3e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c3f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c44:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c49:	89 d1                	mov    %edx,%ecx
  800c4b:	89 d3                	mov    %edx,%ebx
  800c4d:	89 d7                	mov    %edx,%edi
  800c4f:	89 d6                	mov    %edx,%esi
  800c51:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c53:	5b                   	pop    %ebx
  800c54:	5e                   	pop    %esi
  800c55:	5f                   	pop    %edi
  800c56:	5d                   	pop    %ebp
  800c57:	c3                   	ret    

00800c58 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c58:	f3 0f 1e fb          	endbr32 
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	57                   	push   %edi
  800c60:	56                   	push   %esi
  800c61:	53                   	push   %ebx
  800c62:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c65:	be 00 00 00 00       	mov    $0x0,%esi
  800c6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c70:	b8 04 00 00 00       	mov    $0x4,%eax
  800c75:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c78:	89 f7                	mov    %esi,%edi
  800c7a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c7c:	85 c0                	test   %eax,%eax
  800c7e:	7f 08                	jg     800c88 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c83:	5b                   	pop    %ebx
  800c84:	5e                   	pop    %esi
  800c85:	5f                   	pop    %edi
  800c86:	5d                   	pop    %ebp
  800c87:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c88:	83 ec 0c             	sub    $0xc,%esp
  800c8b:	50                   	push   %eax
  800c8c:	6a 04                	push   $0x4
  800c8e:	68 bf 23 80 00       	push   $0x8023bf
  800c93:	6a 23                	push   $0x23
  800c95:	68 dc 23 80 00       	push   $0x8023dc
  800c9a:	e8 86 f4 ff ff       	call   800125 <_panic>

00800c9f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c9f:	f3 0f 1e fb          	endbr32 
  800ca3:	55                   	push   %ebp
  800ca4:	89 e5                	mov    %esp,%ebp
  800ca6:	57                   	push   %edi
  800ca7:	56                   	push   %esi
  800ca8:	53                   	push   %ebx
  800ca9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cac:	8b 55 08             	mov    0x8(%ebp),%edx
  800caf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb2:	b8 05 00 00 00       	mov    $0x5,%eax
  800cb7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cba:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cbd:	8b 75 18             	mov    0x18(%ebp),%esi
  800cc0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc2:	85 c0                	test   %eax,%eax
  800cc4:	7f 08                	jg     800cce <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc9:	5b                   	pop    %ebx
  800cca:	5e                   	pop    %esi
  800ccb:	5f                   	pop    %edi
  800ccc:	5d                   	pop    %ebp
  800ccd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cce:	83 ec 0c             	sub    $0xc,%esp
  800cd1:	50                   	push   %eax
  800cd2:	6a 05                	push   $0x5
  800cd4:	68 bf 23 80 00       	push   $0x8023bf
  800cd9:	6a 23                	push   $0x23
  800cdb:	68 dc 23 80 00       	push   $0x8023dc
  800ce0:	e8 40 f4 ff ff       	call   800125 <_panic>

00800ce5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ce5:	f3 0f 1e fb          	endbr32 
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
  800cec:	57                   	push   %edi
  800ced:	56                   	push   %esi
  800cee:	53                   	push   %ebx
  800cef:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cf7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cfd:	b8 06 00 00 00       	mov    $0x6,%eax
  800d02:	89 df                	mov    %ebx,%edi
  800d04:	89 de                	mov    %ebx,%esi
  800d06:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d08:	85 c0                	test   %eax,%eax
  800d0a:	7f 08                	jg     800d14 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d0f:	5b                   	pop    %ebx
  800d10:	5e                   	pop    %esi
  800d11:	5f                   	pop    %edi
  800d12:	5d                   	pop    %ebp
  800d13:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d14:	83 ec 0c             	sub    $0xc,%esp
  800d17:	50                   	push   %eax
  800d18:	6a 06                	push   $0x6
  800d1a:	68 bf 23 80 00       	push   $0x8023bf
  800d1f:	6a 23                	push   $0x23
  800d21:	68 dc 23 80 00       	push   $0x8023dc
  800d26:	e8 fa f3 ff ff       	call   800125 <_panic>

00800d2b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d2b:	f3 0f 1e fb          	endbr32 
  800d2f:	55                   	push   %ebp
  800d30:	89 e5                	mov    %esp,%ebp
  800d32:	57                   	push   %edi
  800d33:	56                   	push   %esi
  800d34:	53                   	push   %ebx
  800d35:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d38:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d3d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d43:	b8 08 00 00 00       	mov    $0x8,%eax
  800d48:	89 df                	mov    %ebx,%edi
  800d4a:	89 de                	mov    %ebx,%esi
  800d4c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d4e:	85 c0                	test   %eax,%eax
  800d50:	7f 08                	jg     800d5a <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d52:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d55:	5b                   	pop    %ebx
  800d56:	5e                   	pop    %esi
  800d57:	5f                   	pop    %edi
  800d58:	5d                   	pop    %ebp
  800d59:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5a:	83 ec 0c             	sub    $0xc,%esp
  800d5d:	50                   	push   %eax
  800d5e:	6a 08                	push   $0x8
  800d60:	68 bf 23 80 00       	push   $0x8023bf
  800d65:	6a 23                	push   $0x23
  800d67:	68 dc 23 80 00       	push   $0x8023dc
  800d6c:	e8 b4 f3 ff ff       	call   800125 <_panic>

00800d71 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d71:	f3 0f 1e fb          	endbr32 
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
  800d78:	57                   	push   %edi
  800d79:	56                   	push   %esi
  800d7a:	53                   	push   %ebx
  800d7b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d7e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d83:	8b 55 08             	mov    0x8(%ebp),%edx
  800d86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d89:	b8 09 00 00 00       	mov    $0x9,%eax
  800d8e:	89 df                	mov    %ebx,%edi
  800d90:	89 de                	mov    %ebx,%esi
  800d92:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d94:	85 c0                	test   %eax,%eax
  800d96:	7f 08                	jg     800da0 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9b:	5b                   	pop    %ebx
  800d9c:	5e                   	pop    %esi
  800d9d:	5f                   	pop    %edi
  800d9e:	5d                   	pop    %ebp
  800d9f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da0:	83 ec 0c             	sub    $0xc,%esp
  800da3:	50                   	push   %eax
  800da4:	6a 09                	push   $0x9
  800da6:	68 bf 23 80 00       	push   $0x8023bf
  800dab:	6a 23                	push   $0x23
  800dad:	68 dc 23 80 00       	push   $0x8023dc
  800db2:	e8 6e f3 ff ff       	call   800125 <_panic>

00800db7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800db7:	f3 0f 1e fb          	endbr32 
  800dbb:	55                   	push   %ebp
  800dbc:	89 e5                	mov    %esp,%ebp
  800dbe:	57                   	push   %edi
  800dbf:	56                   	push   %esi
  800dc0:	53                   	push   %ebx
  800dc1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dcf:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dd4:	89 df                	mov    %ebx,%edi
  800dd6:	89 de                	mov    %ebx,%esi
  800dd8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dda:	85 c0                	test   %eax,%eax
  800ddc:	7f 08                	jg     800de6 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dde:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de1:	5b                   	pop    %ebx
  800de2:	5e                   	pop    %esi
  800de3:	5f                   	pop    %edi
  800de4:	5d                   	pop    %ebp
  800de5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de6:	83 ec 0c             	sub    $0xc,%esp
  800de9:	50                   	push   %eax
  800dea:	6a 0a                	push   $0xa
  800dec:	68 bf 23 80 00       	push   $0x8023bf
  800df1:	6a 23                	push   $0x23
  800df3:	68 dc 23 80 00       	push   $0x8023dc
  800df8:	e8 28 f3 ff ff       	call   800125 <_panic>

00800dfd <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dfd:	f3 0f 1e fb          	endbr32 
  800e01:	55                   	push   %ebp
  800e02:	89 e5                	mov    %esp,%ebp
  800e04:	57                   	push   %edi
  800e05:	56                   	push   %esi
  800e06:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e07:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0d:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e12:	be 00 00 00 00       	mov    $0x0,%esi
  800e17:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e1a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e1d:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e1f:	5b                   	pop    %ebx
  800e20:	5e                   	pop    %esi
  800e21:	5f                   	pop    %edi
  800e22:	5d                   	pop    %ebp
  800e23:	c3                   	ret    

00800e24 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e24:	f3 0f 1e fb          	endbr32 
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
  800e2b:	57                   	push   %edi
  800e2c:	56                   	push   %esi
  800e2d:	53                   	push   %ebx
  800e2e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e31:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e36:	8b 55 08             	mov    0x8(%ebp),%edx
  800e39:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e3e:	89 cb                	mov    %ecx,%ebx
  800e40:	89 cf                	mov    %ecx,%edi
  800e42:	89 ce                	mov    %ecx,%esi
  800e44:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e46:	85 c0                	test   %eax,%eax
  800e48:	7f 08                	jg     800e52 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e4d:	5b                   	pop    %ebx
  800e4e:	5e                   	pop    %esi
  800e4f:	5f                   	pop    %edi
  800e50:	5d                   	pop    %ebp
  800e51:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e52:	83 ec 0c             	sub    $0xc,%esp
  800e55:	50                   	push   %eax
  800e56:	6a 0d                	push   $0xd
  800e58:	68 bf 23 80 00       	push   $0x8023bf
  800e5d:	6a 23                	push   $0x23
  800e5f:	68 dc 23 80 00       	push   $0x8023dc
  800e64:	e8 bc f2 ff ff       	call   800125 <_panic>

00800e69 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800e69:	f3 0f 1e fb          	endbr32 
  800e6d:	55                   	push   %ebp
  800e6e:	89 e5                	mov    %esp,%ebp
  800e70:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800e73:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  800e7a:	74 0a                	je     800e86 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7f:	a3 08 40 80 00       	mov    %eax,0x804008
}
  800e84:	c9                   	leave  
  800e85:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  800e86:	83 ec 04             	sub    $0x4,%esp
  800e89:	6a 07                	push   $0x7
  800e8b:	68 00 f0 bf ee       	push   $0xeebff000
  800e90:	6a 00                	push   $0x0
  800e92:	e8 c1 fd ff ff       	call   800c58 <sys_page_alloc>
  800e97:	83 c4 10             	add    $0x10,%esp
  800e9a:	85 c0                	test   %eax,%eax
  800e9c:	78 2a                	js     800ec8 <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  800e9e:	83 ec 08             	sub    $0x8,%esp
  800ea1:	68 dc 0e 80 00       	push   $0x800edc
  800ea6:	6a 00                	push   $0x0
  800ea8:	e8 0a ff ff ff       	call   800db7 <sys_env_set_pgfault_upcall>
  800ead:	83 c4 10             	add    $0x10,%esp
  800eb0:	85 c0                	test   %eax,%eax
  800eb2:	79 c8                	jns    800e7c <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  800eb4:	83 ec 04             	sub    $0x4,%esp
  800eb7:	68 18 24 80 00       	push   $0x802418
  800ebc:	6a 25                	push   $0x25
  800ebe:	68 50 24 80 00       	push   $0x802450
  800ec3:	e8 5d f2 ff ff       	call   800125 <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  800ec8:	83 ec 04             	sub    $0x4,%esp
  800ecb:	68 ec 23 80 00       	push   $0x8023ec
  800ed0:	6a 22                	push   $0x22
  800ed2:	68 50 24 80 00       	push   $0x802450
  800ed7:	e8 49 f2 ff ff       	call   800125 <_panic>

00800edc <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800edc:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800edd:	a1 08 40 80 00       	mov    0x804008,%eax
	call *%eax
  800ee2:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800ee4:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  800ee7:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  800eeb:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  800eef:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  800ef2:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  800ef4:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  800ef8:	83 c4 08             	add    $0x8,%esp
	popal
  800efb:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  800efc:	83 c4 04             	add    $0x4,%esp
	popfl
  800eff:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  800f00:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  800f01:	c3                   	ret    

00800f02 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f02:	f3 0f 1e fb          	endbr32 
  800f06:	55                   	push   %ebp
  800f07:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f09:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0c:	05 00 00 00 30       	add    $0x30000000,%eax
  800f11:	c1 e8 0c             	shr    $0xc,%eax
}
  800f14:	5d                   	pop    %ebp
  800f15:	c3                   	ret    

00800f16 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f16:	f3 0f 1e fb          	endbr32 
  800f1a:	55                   	push   %ebp
  800f1b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f20:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800f25:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f2a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f2f:	5d                   	pop    %ebp
  800f30:	c3                   	ret    

00800f31 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f31:	f3 0f 1e fb          	endbr32 
  800f35:	55                   	push   %ebp
  800f36:	89 e5                	mov    %esp,%ebp
  800f38:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f3d:	89 c2                	mov    %eax,%edx
  800f3f:	c1 ea 16             	shr    $0x16,%edx
  800f42:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f49:	f6 c2 01             	test   $0x1,%dl
  800f4c:	74 2d                	je     800f7b <fd_alloc+0x4a>
  800f4e:	89 c2                	mov    %eax,%edx
  800f50:	c1 ea 0c             	shr    $0xc,%edx
  800f53:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f5a:	f6 c2 01             	test   $0x1,%dl
  800f5d:	74 1c                	je     800f7b <fd_alloc+0x4a>
  800f5f:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f64:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f69:	75 d2                	jne    800f3d <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800f74:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f79:	eb 0a                	jmp    800f85 <fd_alloc+0x54>
			*fd_store = fd;
  800f7b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f7e:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f85:	5d                   	pop    %ebp
  800f86:	c3                   	ret    

00800f87 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f87:	f3 0f 1e fb          	endbr32 
  800f8b:	55                   	push   %ebp
  800f8c:	89 e5                	mov    %esp,%ebp
  800f8e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f91:	83 f8 1f             	cmp    $0x1f,%eax
  800f94:	77 30                	ja     800fc6 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f96:	c1 e0 0c             	shl    $0xc,%eax
  800f99:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f9e:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800fa4:	f6 c2 01             	test   $0x1,%dl
  800fa7:	74 24                	je     800fcd <fd_lookup+0x46>
  800fa9:	89 c2                	mov    %eax,%edx
  800fab:	c1 ea 0c             	shr    $0xc,%edx
  800fae:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fb5:	f6 c2 01             	test   $0x1,%dl
  800fb8:	74 1a                	je     800fd4 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800fba:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fbd:	89 02                	mov    %eax,(%edx)
	return 0;
  800fbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fc4:	5d                   	pop    %ebp
  800fc5:	c3                   	ret    
		return -E_INVAL;
  800fc6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fcb:	eb f7                	jmp    800fc4 <fd_lookup+0x3d>
		return -E_INVAL;
  800fcd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fd2:	eb f0                	jmp    800fc4 <fd_lookup+0x3d>
  800fd4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fd9:	eb e9                	jmp    800fc4 <fd_lookup+0x3d>

00800fdb <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800fdb:	f3 0f 1e fb          	endbr32 
  800fdf:	55                   	push   %ebp
  800fe0:	89 e5                	mov    %esp,%ebp
  800fe2:	83 ec 08             	sub    $0x8,%esp
  800fe5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fe8:	ba dc 24 80 00       	mov    $0x8024dc,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800fed:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800ff2:	39 08                	cmp    %ecx,(%eax)
  800ff4:	74 33                	je     801029 <dev_lookup+0x4e>
  800ff6:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800ff9:	8b 02                	mov    (%edx),%eax
  800ffb:	85 c0                	test   %eax,%eax
  800ffd:	75 f3                	jne    800ff2 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800fff:	a1 04 40 80 00       	mov    0x804004,%eax
  801004:	8b 40 48             	mov    0x48(%eax),%eax
  801007:	83 ec 04             	sub    $0x4,%esp
  80100a:	51                   	push   %ecx
  80100b:	50                   	push   %eax
  80100c:	68 60 24 80 00       	push   $0x802460
  801011:	e8 f6 f1 ff ff       	call   80020c <cprintf>
	*dev = 0;
  801016:	8b 45 0c             	mov    0xc(%ebp),%eax
  801019:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80101f:	83 c4 10             	add    $0x10,%esp
  801022:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801027:	c9                   	leave  
  801028:	c3                   	ret    
			*dev = devtab[i];
  801029:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80102c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80102e:	b8 00 00 00 00       	mov    $0x0,%eax
  801033:	eb f2                	jmp    801027 <dev_lookup+0x4c>

00801035 <fd_close>:
{
  801035:	f3 0f 1e fb          	endbr32 
  801039:	55                   	push   %ebp
  80103a:	89 e5                	mov    %esp,%ebp
  80103c:	57                   	push   %edi
  80103d:	56                   	push   %esi
  80103e:	53                   	push   %ebx
  80103f:	83 ec 24             	sub    $0x24,%esp
  801042:	8b 75 08             	mov    0x8(%ebp),%esi
  801045:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801048:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80104b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80104c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801052:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801055:	50                   	push   %eax
  801056:	e8 2c ff ff ff       	call   800f87 <fd_lookup>
  80105b:	89 c3                	mov    %eax,%ebx
  80105d:	83 c4 10             	add    $0x10,%esp
  801060:	85 c0                	test   %eax,%eax
  801062:	78 05                	js     801069 <fd_close+0x34>
	    || fd != fd2)
  801064:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801067:	74 16                	je     80107f <fd_close+0x4a>
		return (must_exist ? r : 0);
  801069:	89 f8                	mov    %edi,%eax
  80106b:	84 c0                	test   %al,%al
  80106d:	b8 00 00 00 00       	mov    $0x0,%eax
  801072:	0f 44 d8             	cmove  %eax,%ebx
}
  801075:	89 d8                	mov    %ebx,%eax
  801077:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80107a:	5b                   	pop    %ebx
  80107b:	5e                   	pop    %esi
  80107c:	5f                   	pop    %edi
  80107d:	5d                   	pop    %ebp
  80107e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80107f:	83 ec 08             	sub    $0x8,%esp
  801082:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801085:	50                   	push   %eax
  801086:	ff 36                	pushl  (%esi)
  801088:	e8 4e ff ff ff       	call   800fdb <dev_lookup>
  80108d:	89 c3                	mov    %eax,%ebx
  80108f:	83 c4 10             	add    $0x10,%esp
  801092:	85 c0                	test   %eax,%eax
  801094:	78 1a                	js     8010b0 <fd_close+0x7b>
		if (dev->dev_close)
  801096:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801099:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80109c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8010a1:	85 c0                	test   %eax,%eax
  8010a3:	74 0b                	je     8010b0 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8010a5:	83 ec 0c             	sub    $0xc,%esp
  8010a8:	56                   	push   %esi
  8010a9:	ff d0                	call   *%eax
  8010ab:	89 c3                	mov    %eax,%ebx
  8010ad:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8010b0:	83 ec 08             	sub    $0x8,%esp
  8010b3:	56                   	push   %esi
  8010b4:	6a 00                	push   $0x0
  8010b6:	e8 2a fc ff ff       	call   800ce5 <sys_page_unmap>
	return r;
  8010bb:	83 c4 10             	add    $0x10,%esp
  8010be:	eb b5                	jmp    801075 <fd_close+0x40>

008010c0 <close>:

int
close(int fdnum)
{
  8010c0:	f3 0f 1e fb          	endbr32 
  8010c4:	55                   	push   %ebp
  8010c5:	89 e5                	mov    %esp,%ebp
  8010c7:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010cd:	50                   	push   %eax
  8010ce:	ff 75 08             	pushl  0x8(%ebp)
  8010d1:	e8 b1 fe ff ff       	call   800f87 <fd_lookup>
  8010d6:	83 c4 10             	add    $0x10,%esp
  8010d9:	85 c0                	test   %eax,%eax
  8010db:	79 02                	jns    8010df <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8010dd:	c9                   	leave  
  8010de:	c3                   	ret    
		return fd_close(fd, 1);
  8010df:	83 ec 08             	sub    $0x8,%esp
  8010e2:	6a 01                	push   $0x1
  8010e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8010e7:	e8 49 ff ff ff       	call   801035 <fd_close>
  8010ec:	83 c4 10             	add    $0x10,%esp
  8010ef:	eb ec                	jmp    8010dd <close+0x1d>

008010f1 <close_all>:

void
close_all(void)
{
  8010f1:	f3 0f 1e fb          	endbr32 
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
  8010f8:	53                   	push   %ebx
  8010f9:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8010fc:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801101:	83 ec 0c             	sub    $0xc,%esp
  801104:	53                   	push   %ebx
  801105:	e8 b6 ff ff ff       	call   8010c0 <close>
	for (i = 0; i < MAXFD; i++)
  80110a:	83 c3 01             	add    $0x1,%ebx
  80110d:	83 c4 10             	add    $0x10,%esp
  801110:	83 fb 20             	cmp    $0x20,%ebx
  801113:	75 ec                	jne    801101 <close_all+0x10>
}
  801115:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801118:	c9                   	leave  
  801119:	c3                   	ret    

0080111a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80111a:	f3 0f 1e fb          	endbr32 
  80111e:	55                   	push   %ebp
  80111f:	89 e5                	mov    %esp,%ebp
  801121:	57                   	push   %edi
  801122:	56                   	push   %esi
  801123:	53                   	push   %ebx
  801124:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801127:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80112a:	50                   	push   %eax
  80112b:	ff 75 08             	pushl  0x8(%ebp)
  80112e:	e8 54 fe ff ff       	call   800f87 <fd_lookup>
  801133:	89 c3                	mov    %eax,%ebx
  801135:	83 c4 10             	add    $0x10,%esp
  801138:	85 c0                	test   %eax,%eax
  80113a:	0f 88 81 00 00 00    	js     8011c1 <dup+0xa7>
		return r;
	close(newfdnum);
  801140:	83 ec 0c             	sub    $0xc,%esp
  801143:	ff 75 0c             	pushl  0xc(%ebp)
  801146:	e8 75 ff ff ff       	call   8010c0 <close>

	newfd = INDEX2FD(newfdnum);
  80114b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80114e:	c1 e6 0c             	shl    $0xc,%esi
  801151:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801157:	83 c4 04             	add    $0x4,%esp
  80115a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80115d:	e8 b4 fd ff ff       	call   800f16 <fd2data>
  801162:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801164:	89 34 24             	mov    %esi,(%esp)
  801167:	e8 aa fd ff ff       	call   800f16 <fd2data>
  80116c:	83 c4 10             	add    $0x10,%esp
  80116f:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801171:	89 d8                	mov    %ebx,%eax
  801173:	c1 e8 16             	shr    $0x16,%eax
  801176:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80117d:	a8 01                	test   $0x1,%al
  80117f:	74 11                	je     801192 <dup+0x78>
  801181:	89 d8                	mov    %ebx,%eax
  801183:	c1 e8 0c             	shr    $0xc,%eax
  801186:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80118d:	f6 c2 01             	test   $0x1,%dl
  801190:	75 39                	jne    8011cb <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801192:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801195:	89 d0                	mov    %edx,%eax
  801197:	c1 e8 0c             	shr    $0xc,%eax
  80119a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011a1:	83 ec 0c             	sub    $0xc,%esp
  8011a4:	25 07 0e 00 00       	and    $0xe07,%eax
  8011a9:	50                   	push   %eax
  8011aa:	56                   	push   %esi
  8011ab:	6a 00                	push   $0x0
  8011ad:	52                   	push   %edx
  8011ae:	6a 00                	push   $0x0
  8011b0:	e8 ea fa ff ff       	call   800c9f <sys_page_map>
  8011b5:	89 c3                	mov    %eax,%ebx
  8011b7:	83 c4 20             	add    $0x20,%esp
  8011ba:	85 c0                	test   %eax,%eax
  8011bc:	78 31                	js     8011ef <dup+0xd5>
		goto err;

	return newfdnum;
  8011be:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8011c1:	89 d8                	mov    %ebx,%eax
  8011c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011c6:	5b                   	pop    %ebx
  8011c7:	5e                   	pop    %esi
  8011c8:	5f                   	pop    %edi
  8011c9:	5d                   	pop    %ebp
  8011ca:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8011cb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011d2:	83 ec 0c             	sub    $0xc,%esp
  8011d5:	25 07 0e 00 00       	and    $0xe07,%eax
  8011da:	50                   	push   %eax
  8011db:	57                   	push   %edi
  8011dc:	6a 00                	push   $0x0
  8011de:	53                   	push   %ebx
  8011df:	6a 00                	push   $0x0
  8011e1:	e8 b9 fa ff ff       	call   800c9f <sys_page_map>
  8011e6:	89 c3                	mov    %eax,%ebx
  8011e8:	83 c4 20             	add    $0x20,%esp
  8011eb:	85 c0                	test   %eax,%eax
  8011ed:	79 a3                	jns    801192 <dup+0x78>
	sys_page_unmap(0, newfd);
  8011ef:	83 ec 08             	sub    $0x8,%esp
  8011f2:	56                   	push   %esi
  8011f3:	6a 00                	push   $0x0
  8011f5:	e8 eb fa ff ff       	call   800ce5 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8011fa:	83 c4 08             	add    $0x8,%esp
  8011fd:	57                   	push   %edi
  8011fe:	6a 00                	push   $0x0
  801200:	e8 e0 fa ff ff       	call   800ce5 <sys_page_unmap>
	return r;
  801205:	83 c4 10             	add    $0x10,%esp
  801208:	eb b7                	jmp    8011c1 <dup+0xa7>

0080120a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80120a:	f3 0f 1e fb          	endbr32 
  80120e:	55                   	push   %ebp
  80120f:	89 e5                	mov    %esp,%ebp
  801211:	53                   	push   %ebx
  801212:	83 ec 1c             	sub    $0x1c,%esp
  801215:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801218:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80121b:	50                   	push   %eax
  80121c:	53                   	push   %ebx
  80121d:	e8 65 fd ff ff       	call   800f87 <fd_lookup>
  801222:	83 c4 10             	add    $0x10,%esp
  801225:	85 c0                	test   %eax,%eax
  801227:	78 3f                	js     801268 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801229:	83 ec 08             	sub    $0x8,%esp
  80122c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80122f:	50                   	push   %eax
  801230:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801233:	ff 30                	pushl  (%eax)
  801235:	e8 a1 fd ff ff       	call   800fdb <dev_lookup>
  80123a:	83 c4 10             	add    $0x10,%esp
  80123d:	85 c0                	test   %eax,%eax
  80123f:	78 27                	js     801268 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801241:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801244:	8b 42 08             	mov    0x8(%edx),%eax
  801247:	83 e0 03             	and    $0x3,%eax
  80124a:	83 f8 01             	cmp    $0x1,%eax
  80124d:	74 1e                	je     80126d <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80124f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801252:	8b 40 08             	mov    0x8(%eax),%eax
  801255:	85 c0                	test   %eax,%eax
  801257:	74 35                	je     80128e <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801259:	83 ec 04             	sub    $0x4,%esp
  80125c:	ff 75 10             	pushl  0x10(%ebp)
  80125f:	ff 75 0c             	pushl  0xc(%ebp)
  801262:	52                   	push   %edx
  801263:	ff d0                	call   *%eax
  801265:	83 c4 10             	add    $0x10,%esp
}
  801268:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80126b:	c9                   	leave  
  80126c:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80126d:	a1 04 40 80 00       	mov    0x804004,%eax
  801272:	8b 40 48             	mov    0x48(%eax),%eax
  801275:	83 ec 04             	sub    $0x4,%esp
  801278:	53                   	push   %ebx
  801279:	50                   	push   %eax
  80127a:	68 a1 24 80 00       	push   $0x8024a1
  80127f:	e8 88 ef ff ff       	call   80020c <cprintf>
		return -E_INVAL;
  801284:	83 c4 10             	add    $0x10,%esp
  801287:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80128c:	eb da                	jmp    801268 <read+0x5e>
		return -E_NOT_SUPP;
  80128e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801293:	eb d3                	jmp    801268 <read+0x5e>

00801295 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801295:	f3 0f 1e fb          	endbr32 
  801299:	55                   	push   %ebp
  80129a:	89 e5                	mov    %esp,%ebp
  80129c:	57                   	push   %edi
  80129d:	56                   	push   %esi
  80129e:	53                   	push   %ebx
  80129f:	83 ec 0c             	sub    $0xc,%esp
  8012a2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012a5:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8012a8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012ad:	eb 02                	jmp    8012b1 <readn+0x1c>
  8012af:	01 c3                	add    %eax,%ebx
  8012b1:	39 f3                	cmp    %esi,%ebx
  8012b3:	73 21                	jae    8012d6 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012b5:	83 ec 04             	sub    $0x4,%esp
  8012b8:	89 f0                	mov    %esi,%eax
  8012ba:	29 d8                	sub    %ebx,%eax
  8012bc:	50                   	push   %eax
  8012bd:	89 d8                	mov    %ebx,%eax
  8012bf:	03 45 0c             	add    0xc(%ebp),%eax
  8012c2:	50                   	push   %eax
  8012c3:	57                   	push   %edi
  8012c4:	e8 41 ff ff ff       	call   80120a <read>
		if (m < 0)
  8012c9:	83 c4 10             	add    $0x10,%esp
  8012cc:	85 c0                	test   %eax,%eax
  8012ce:	78 04                	js     8012d4 <readn+0x3f>
			return m;
		if (m == 0)
  8012d0:	75 dd                	jne    8012af <readn+0x1a>
  8012d2:	eb 02                	jmp    8012d6 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012d4:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8012d6:	89 d8                	mov    %ebx,%eax
  8012d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012db:	5b                   	pop    %ebx
  8012dc:	5e                   	pop    %esi
  8012dd:	5f                   	pop    %edi
  8012de:	5d                   	pop    %ebp
  8012df:	c3                   	ret    

008012e0 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8012e0:	f3 0f 1e fb          	endbr32 
  8012e4:	55                   	push   %ebp
  8012e5:	89 e5                	mov    %esp,%ebp
  8012e7:	53                   	push   %ebx
  8012e8:	83 ec 1c             	sub    $0x1c,%esp
  8012eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012ee:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012f1:	50                   	push   %eax
  8012f2:	53                   	push   %ebx
  8012f3:	e8 8f fc ff ff       	call   800f87 <fd_lookup>
  8012f8:	83 c4 10             	add    $0x10,%esp
  8012fb:	85 c0                	test   %eax,%eax
  8012fd:	78 3a                	js     801339 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012ff:	83 ec 08             	sub    $0x8,%esp
  801302:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801305:	50                   	push   %eax
  801306:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801309:	ff 30                	pushl  (%eax)
  80130b:	e8 cb fc ff ff       	call   800fdb <dev_lookup>
  801310:	83 c4 10             	add    $0x10,%esp
  801313:	85 c0                	test   %eax,%eax
  801315:	78 22                	js     801339 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801317:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80131a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80131e:	74 1e                	je     80133e <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801320:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801323:	8b 52 0c             	mov    0xc(%edx),%edx
  801326:	85 d2                	test   %edx,%edx
  801328:	74 35                	je     80135f <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80132a:	83 ec 04             	sub    $0x4,%esp
  80132d:	ff 75 10             	pushl  0x10(%ebp)
  801330:	ff 75 0c             	pushl  0xc(%ebp)
  801333:	50                   	push   %eax
  801334:	ff d2                	call   *%edx
  801336:	83 c4 10             	add    $0x10,%esp
}
  801339:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80133c:	c9                   	leave  
  80133d:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80133e:	a1 04 40 80 00       	mov    0x804004,%eax
  801343:	8b 40 48             	mov    0x48(%eax),%eax
  801346:	83 ec 04             	sub    $0x4,%esp
  801349:	53                   	push   %ebx
  80134a:	50                   	push   %eax
  80134b:	68 bd 24 80 00       	push   $0x8024bd
  801350:	e8 b7 ee ff ff       	call   80020c <cprintf>
		return -E_INVAL;
  801355:	83 c4 10             	add    $0x10,%esp
  801358:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80135d:	eb da                	jmp    801339 <write+0x59>
		return -E_NOT_SUPP;
  80135f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801364:	eb d3                	jmp    801339 <write+0x59>

00801366 <seek>:

int
seek(int fdnum, off_t offset)
{
  801366:	f3 0f 1e fb          	endbr32 
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
  80136d:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801370:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801373:	50                   	push   %eax
  801374:	ff 75 08             	pushl  0x8(%ebp)
  801377:	e8 0b fc ff ff       	call   800f87 <fd_lookup>
  80137c:	83 c4 10             	add    $0x10,%esp
  80137f:	85 c0                	test   %eax,%eax
  801381:	78 0e                	js     801391 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801383:	8b 55 0c             	mov    0xc(%ebp),%edx
  801386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801389:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80138c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801391:	c9                   	leave  
  801392:	c3                   	ret    

00801393 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801393:	f3 0f 1e fb          	endbr32 
  801397:	55                   	push   %ebp
  801398:	89 e5                	mov    %esp,%ebp
  80139a:	53                   	push   %ebx
  80139b:	83 ec 1c             	sub    $0x1c,%esp
  80139e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013a4:	50                   	push   %eax
  8013a5:	53                   	push   %ebx
  8013a6:	e8 dc fb ff ff       	call   800f87 <fd_lookup>
  8013ab:	83 c4 10             	add    $0x10,%esp
  8013ae:	85 c0                	test   %eax,%eax
  8013b0:	78 37                	js     8013e9 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013b2:	83 ec 08             	sub    $0x8,%esp
  8013b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013b8:	50                   	push   %eax
  8013b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013bc:	ff 30                	pushl  (%eax)
  8013be:	e8 18 fc ff ff       	call   800fdb <dev_lookup>
  8013c3:	83 c4 10             	add    $0x10,%esp
  8013c6:	85 c0                	test   %eax,%eax
  8013c8:	78 1f                	js     8013e9 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013cd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013d1:	74 1b                	je     8013ee <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8013d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013d6:	8b 52 18             	mov    0x18(%edx),%edx
  8013d9:	85 d2                	test   %edx,%edx
  8013db:	74 32                	je     80140f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8013dd:	83 ec 08             	sub    $0x8,%esp
  8013e0:	ff 75 0c             	pushl  0xc(%ebp)
  8013e3:	50                   	push   %eax
  8013e4:	ff d2                	call   *%edx
  8013e6:	83 c4 10             	add    $0x10,%esp
}
  8013e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ec:	c9                   	leave  
  8013ed:	c3                   	ret    
			thisenv->env_id, fdnum);
  8013ee:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8013f3:	8b 40 48             	mov    0x48(%eax),%eax
  8013f6:	83 ec 04             	sub    $0x4,%esp
  8013f9:	53                   	push   %ebx
  8013fa:	50                   	push   %eax
  8013fb:	68 80 24 80 00       	push   $0x802480
  801400:	e8 07 ee ff ff       	call   80020c <cprintf>
		return -E_INVAL;
  801405:	83 c4 10             	add    $0x10,%esp
  801408:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80140d:	eb da                	jmp    8013e9 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80140f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801414:	eb d3                	jmp    8013e9 <ftruncate+0x56>

00801416 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801416:	f3 0f 1e fb          	endbr32 
  80141a:	55                   	push   %ebp
  80141b:	89 e5                	mov    %esp,%ebp
  80141d:	53                   	push   %ebx
  80141e:	83 ec 1c             	sub    $0x1c,%esp
  801421:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801424:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801427:	50                   	push   %eax
  801428:	ff 75 08             	pushl  0x8(%ebp)
  80142b:	e8 57 fb ff ff       	call   800f87 <fd_lookup>
  801430:	83 c4 10             	add    $0x10,%esp
  801433:	85 c0                	test   %eax,%eax
  801435:	78 4b                	js     801482 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801437:	83 ec 08             	sub    $0x8,%esp
  80143a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80143d:	50                   	push   %eax
  80143e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801441:	ff 30                	pushl  (%eax)
  801443:	e8 93 fb ff ff       	call   800fdb <dev_lookup>
  801448:	83 c4 10             	add    $0x10,%esp
  80144b:	85 c0                	test   %eax,%eax
  80144d:	78 33                	js     801482 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80144f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801452:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801456:	74 2f                	je     801487 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801458:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80145b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801462:	00 00 00 
	stat->st_isdir = 0;
  801465:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80146c:	00 00 00 
	stat->st_dev = dev;
  80146f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801475:	83 ec 08             	sub    $0x8,%esp
  801478:	53                   	push   %ebx
  801479:	ff 75 f0             	pushl  -0x10(%ebp)
  80147c:	ff 50 14             	call   *0x14(%eax)
  80147f:	83 c4 10             	add    $0x10,%esp
}
  801482:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801485:	c9                   	leave  
  801486:	c3                   	ret    
		return -E_NOT_SUPP;
  801487:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80148c:	eb f4                	jmp    801482 <fstat+0x6c>

0080148e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80148e:	f3 0f 1e fb          	endbr32 
  801492:	55                   	push   %ebp
  801493:	89 e5                	mov    %esp,%ebp
  801495:	56                   	push   %esi
  801496:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801497:	83 ec 08             	sub    $0x8,%esp
  80149a:	6a 00                	push   $0x0
  80149c:	ff 75 08             	pushl  0x8(%ebp)
  80149f:	e8 fb 01 00 00       	call   80169f <open>
  8014a4:	89 c3                	mov    %eax,%ebx
  8014a6:	83 c4 10             	add    $0x10,%esp
  8014a9:	85 c0                	test   %eax,%eax
  8014ab:	78 1b                	js     8014c8 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8014ad:	83 ec 08             	sub    $0x8,%esp
  8014b0:	ff 75 0c             	pushl  0xc(%ebp)
  8014b3:	50                   	push   %eax
  8014b4:	e8 5d ff ff ff       	call   801416 <fstat>
  8014b9:	89 c6                	mov    %eax,%esi
	close(fd);
  8014bb:	89 1c 24             	mov    %ebx,(%esp)
  8014be:	e8 fd fb ff ff       	call   8010c0 <close>
	return r;
  8014c3:	83 c4 10             	add    $0x10,%esp
  8014c6:	89 f3                	mov    %esi,%ebx
}
  8014c8:	89 d8                	mov    %ebx,%eax
  8014ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014cd:	5b                   	pop    %ebx
  8014ce:	5e                   	pop    %esi
  8014cf:	5d                   	pop    %ebp
  8014d0:	c3                   	ret    

008014d1 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
  8014d4:	56                   	push   %esi
  8014d5:	53                   	push   %ebx
  8014d6:	89 c6                	mov    %eax,%esi
  8014d8:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8014da:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8014e1:	74 27                	je     80150a <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8014e3:	6a 07                	push   $0x7
  8014e5:	68 00 50 80 00       	push   $0x805000
  8014ea:	56                   	push   %esi
  8014eb:	ff 35 00 40 80 00    	pushl  0x804000
  8014f1:	e8 d6 07 00 00       	call   801ccc <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8014f6:	83 c4 0c             	add    $0xc,%esp
  8014f9:	6a 00                	push   $0x0
  8014fb:	53                   	push   %ebx
  8014fc:	6a 00                	push   $0x0
  8014fe:	e8 44 07 00 00       	call   801c47 <ipc_recv>
}
  801503:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801506:	5b                   	pop    %ebx
  801507:	5e                   	pop    %esi
  801508:	5d                   	pop    %ebp
  801509:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80150a:	83 ec 0c             	sub    $0xc,%esp
  80150d:	6a 01                	push   $0x1
  80150f:	e8 10 08 00 00       	call   801d24 <ipc_find_env>
  801514:	a3 00 40 80 00       	mov    %eax,0x804000
  801519:	83 c4 10             	add    $0x10,%esp
  80151c:	eb c5                	jmp    8014e3 <fsipc+0x12>

0080151e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80151e:	f3 0f 1e fb          	endbr32 
  801522:	55                   	push   %ebp
  801523:	89 e5                	mov    %esp,%ebp
  801525:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801528:	8b 45 08             	mov    0x8(%ebp),%eax
  80152b:	8b 40 0c             	mov    0xc(%eax),%eax
  80152e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801533:	8b 45 0c             	mov    0xc(%ebp),%eax
  801536:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80153b:	ba 00 00 00 00       	mov    $0x0,%edx
  801540:	b8 02 00 00 00       	mov    $0x2,%eax
  801545:	e8 87 ff ff ff       	call   8014d1 <fsipc>
}
  80154a:	c9                   	leave  
  80154b:	c3                   	ret    

0080154c <devfile_flush>:
{
  80154c:	f3 0f 1e fb          	endbr32 
  801550:	55                   	push   %ebp
  801551:	89 e5                	mov    %esp,%ebp
  801553:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801556:	8b 45 08             	mov    0x8(%ebp),%eax
  801559:	8b 40 0c             	mov    0xc(%eax),%eax
  80155c:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801561:	ba 00 00 00 00       	mov    $0x0,%edx
  801566:	b8 06 00 00 00       	mov    $0x6,%eax
  80156b:	e8 61 ff ff ff       	call   8014d1 <fsipc>
}
  801570:	c9                   	leave  
  801571:	c3                   	ret    

00801572 <devfile_stat>:
{
  801572:	f3 0f 1e fb          	endbr32 
  801576:	55                   	push   %ebp
  801577:	89 e5                	mov    %esp,%ebp
  801579:	53                   	push   %ebx
  80157a:	83 ec 04             	sub    $0x4,%esp
  80157d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801580:	8b 45 08             	mov    0x8(%ebp),%eax
  801583:	8b 40 0c             	mov    0xc(%eax),%eax
  801586:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80158b:	ba 00 00 00 00       	mov    $0x0,%edx
  801590:	b8 05 00 00 00       	mov    $0x5,%eax
  801595:	e8 37 ff ff ff       	call   8014d1 <fsipc>
  80159a:	85 c0                	test   %eax,%eax
  80159c:	78 2c                	js     8015ca <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80159e:	83 ec 08             	sub    $0x8,%esp
  8015a1:	68 00 50 80 00       	push   $0x805000
  8015a6:	53                   	push   %ebx
  8015a7:	e8 6a f2 ff ff       	call   800816 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8015ac:	a1 80 50 80 00       	mov    0x805080,%eax
  8015b1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8015b7:	a1 84 50 80 00       	mov    0x805084,%eax
  8015bc:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8015c2:	83 c4 10             	add    $0x10,%esp
  8015c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015cd:	c9                   	leave  
  8015ce:	c3                   	ret    

008015cf <devfile_write>:
{
  8015cf:	f3 0f 1e fb          	endbr32 
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
  8015d6:	83 ec 0c             	sub    $0xc,%esp
  8015d9:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8015dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8015df:	8b 52 0c             	mov    0xc(%edx),%edx
  8015e2:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  8015e8:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8015ed:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8015f2:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  8015f5:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  8015fa:	50                   	push   %eax
  8015fb:	ff 75 0c             	pushl  0xc(%ebp)
  8015fe:	68 08 50 80 00       	push   $0x805008
  801603:	e8 c4 f3 ff ff       	call   8009cc <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801608:	ba 00 00 00 00       	mov    $0x0,%edx
  80160d:	b8 04 00 00 00       	mov    $0x4,%eax
  801612:	e8 ba fe ff ff       	call   8014d1 <fsipc>
}
  801617:	c9                   	leave  
  801618:	c3                   	ret    

00801619 <devfile_read>:
{
  801619:	f3 0f 1e fb          	endbr32 
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
  801620:	56                   	push   %esi
  801621:	53                   	push   %ebx
  801622:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801625:	8b 45 08             	mov    0x8(%ebp),%eax
  801628:	8b 40 0c             	mov    0xc(%eax),%eax
  80162b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801630:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801636:	ba 00 00 00 00       	mov    $0x0,%edx
  80163b:	b8 03 00 00 00       	mov    $0x3,%eax
  801640:	e8 8c fe ff ff       	call   8014d1 <fsipc>
  801645:	89 c3                	mov    %eax,%ebx
  801647:	85 c0                	test   %eax,%eax
  801649:	78 1f                	js     80166a <devfile_read+0x51>
	assert(r <= n);
  80164b:	39 f0                	cmp    %esi,%eax
  80164d:	77 24                	ja     801673 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  80164f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801654:	7f 33                	jg     801689 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801656:	83 ec 04             	sub    $0x4,%esp
  801659:	50                   	push   %eax
  80165a:	68 00 50 80 00       	push   $0x805000
  80165f:	ff 75 0c             	pushl  0xc(%ebp)
  801662:	e8 65 f3 ff ff       	call   8009cc <memmove>
	return r;
  801667:	83 c4 10             	add    $0x10,%esp
}
  80166a:	89 d8                	mov    %ebx,%eax
  80166c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80166f:	5b                   	pop    %ebx
  801670:	5e                   	pop    %esi
  801671:	5d                   	pop    %ebp
  801672:	c3                   	ret    
	assert(r <= n);
  801673:	68 ec 24 80 00       	push   $0x8024ec
  801678:	68 f3 24 80 00       	push   $0x8024f3
  80167d:	6a 7c                	push   $0x7c
  80167f:	68 08 25 80 00       	push   $0x802508
  801684:	e8 9c ea ff ff       	call   800125 <_panic>
	assert(r <= PGSIZE);
  801689:	68 13 25 80 00       	push   $0x802513
  80168e:	68 f3 24 80 00       	push   $0x8024f3
  801693:	6a 7d                	push   $0x7d
  801695:	68 08 25 80 00       	push   $0x802508
  80169a:	e8 86 ea ff ff       	call   800125 <_panic>

0080169f <open>:
{
  80169f:	f3 0f 1e fb          	endbr32 
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
  8016a6:	56                   	push   %esi
  8016a7:	53                   	push   %ebx
  8016a8:	83 ec 1c             	sub    $0x1c,%esp
  8016ab:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8016ae:	56                   	push   %esi
  8016af:	e8 1f f1 ff ff       	call   8007d3 <strlen>
  8016b4:	83 c4 10             	add    $0x10,%esp
  8016b7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8016bc:	7f 6c                	jg     80172a <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8016be:	83 ec 0c             	sub    $0xc,%esp
  8016c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016c4:	50                   	push   %eax
  8016c5:	e8 67 f8 ff ff       	call   800f31 <fd_alloc>
  8016ca:	89 c3                	mov    %eax,%ebx
  8016cc:	83 c4 10             	add    $0x10,%esp
  8016cf:	85 c0                	test   %eax,%eax
  8016d1:	78 3c                	js     80170f <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8016d3:	83 ec 08             	sub    $0x8,%esp
  8016d6:	56                   	push   %esi
  8016d7:	68 00 50 80 00       	push   $0x805000
  8016dc:	e8 35 f1 ff ff       	call   800816 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8016e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e4:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8016e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ec:	b8 01 00 00 00       	mov    $0x1,%eax
  8016f1:	e8 db fd ff ff       	call   8014d1 <fsipc>
  8016f6:	89 c3                	mov    %eax,%ebx
  8016f8:	83 c4 10             	add    $0x10,%esp
  8016fb:	85 c0                	test   %eax,%eax
  8016fd:	78 19                	js     801718 <open+0x79>
	return fd2num(fd);
  8016ff:	83 ec 0c             	sub    $0xc,%esp
  801702:	ff 75 f4             	pushl  -0xc(%ebp)
  801705:	e8 f8 f7 ff ff       	call   800f02 <fd2num>
  80170a:	89 c3                	mov    %eax,%ebx
  80170c:	83 c4 10             	add    $0x10,%esp
}
  80170f:	89 d8                	mov    %ebx,%eax
  801711:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801714:	5b                   	pop    %ebx
  801715:	5e                   	pop    %esi
  801716:	5d                   	pop    %ebp
  801717:	c3                   	ret    
		fd_close(fd, 0);
  801718:	83 ec 08             	sub    $0x8,%esp
  80171b:	6a 00                	push   $0x0
  80171d:	ff 75 f4             	pushl  -0xc(%ebp)
  801720:	e8 10 f9 ff ff       	call   801035 <fd_close>
		return r;
  801725:	83 c4 10             	add    $0x10,%esp
  801728:	eb e5                	jmp    80170f <open+0x70>
		return -E_BAD_PATH;
  80172a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80172f:	eb de                	jmp    80170f <open+0x70>

00801731 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801731:	f3 0f 1e fb          	endbr32 
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
  801738:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80173b:	ba 00 00 00 00       	mov    $0x0,%edx
  801740:	b8 08 00 00 00       	mov    $0x8,%eax
  801745:	e8 87 fd ff ff       	call   8014d1 <fsipc>
}
  80174a:	c9                   	leave  
  80174b:	c3                   	ret    

0080174c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80174c:	f3 0f 1e fb          	endbr32 
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	56                   	push   %esi
  801754:	53                   	push   %ebx
  801755:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801758:	83 ec 0c             	sub    $0xc,%esp
  80175b:	ff 75 08             	pushl  0x8(%ebp)
  80175e:	e8 b3 f7 ff ff       	call   800f16 <fd2data>
  801763:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801765:	83 c4 08             	add    $0x8,%esp
  801768:	68 1f 25 80 00       	push   $0x80251f
  80176d:	53                   	push   %ebx
  80176e:	e8 a3 f0 ff ff       	call   800816 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801773:	8b 46 04             	mov    0x4(%esi),%eax
  801776:	2b 06                	sub    (%esi),%eax
  801778:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80177e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801785:	00 00 00 
	stat->st_dev = &devpipe;
  801788:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  80178f:	30 80 00 
	return 0;
}
  801792:	b8 00 00 00 00       	mov    $0x0,%eax
  801797:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80179a:	5b                   	pop    %ebx
  80179b:	5e                   	pop    %esi
  80179c:	5d                   	pop    %ebp
  80179d:	c3                   	ret    

0080179e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80179e:	f3 0f 1e fb          	endbr32 
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
  8017a5:	53                   	push   %ebx
  8017a6:	83 ec 0c             	sub    $0xc,%esp
  8017a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8017ac:	53                   	push   %ebx
  8017ad:	6a 00                	push   $0x0
  8017af:	e8 31 f5 ff ff       	call   800ce5 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8017b4:	89 1c 24             	mov    %ebx,(%esp)
  8017b7:	e8 5a f7 ff ff       	call   800f16 <fd2data>
  8017bc:	83 c4 08             	add    $0x8,%esp
  8017bf:	50                   	push   %eax
  8017c0:	6a 00                	push   $0x0
  8017c2:	e8 1e f5 ff ff       	call   800ce5 <sys_page_unmap>
}
  8017c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ca:	c9                   	leave  
  8017cb:	c3                   	ret    

008017cc <_pipeisclosed>:
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
  8017cf:	57                   	push   %edi
  8017d0:	56                   	push   %esi
  8017d1:	53                   	push   %ebx
  8017d2:	83 ec 1c             	sub    $0x1c,%esp
  8017d5:	89 c7                	mov    %eax,%edi
  8017d7:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8017d9:	a1 04 40 80 00       	mov    0x804004,%eax
  8017de:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8017e1:	83 ec 0c             	sub    $0xc,%esp
  8017e4:	57                   	push   %edi
  8017e5:	e8 77 05 00 00       	call   801d61 <pageref>
  8017ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8017ed:	89 34 24             	mov    %esi,(%esp)
  8017f0:	e8 6c 05 00 00       	call   801d61 <pageref>
		nn = thisenv->env_runs;
  8017f5:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8017fb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8017fe:	83 c4 10             	add    $0x10,%esp
  801801:	39 cb                	cmp    %ecx,%ebx
  801803:	74 1b                	je     801820 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801805:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801808:	75 cf                	jne    8017d9 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80180a:	8b 42 58             	mov    0x58(%edx),%eax
  80180d:	6a 01                	push   $0x1
  80180f:	50                   	push   %eax
  801810:	53                   	push   %ebx
  801811:	68 26 25 80 00       	push   $0x802526
  801816:	e8 f1 e9 ff ff       	call   80020c <cprintf>
  80181b:	83 c4 10             	add    $0x10,%esp
  80181e:	eb b9                	jmp    8017d9 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801820:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801823:	0f 94 c0             	sete   %al
  801826:	0f b6 c0             	movzbl %al,%eax
}
  801829:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80182c:	5b                   	pop    %ebx
  80182d:	5e                   	pop    %esi
  80182e:	5f                   	pop    %edi
  80182f:	5d                   	pop    %ebp
  801830:	c3                   	ret    

00801831 <devpipe_write>:
{
  801831:	f3 0f 1e fb          	endbr32 
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
  801838:	57                   	push   %edi
  801839:	56                   	push   %esi
  80183a:	53                   	push   %ebx
  80183b:	83 ec 28             	sub    $0x28,%esp
  80183e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801841:	56                   	push   %esi
  801842:	e8 cf f6 ff ff       	call   800f16 <fd2data>
  801847:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801849:	83 c4 10             	add    $0x10,%esp
  80184c:	bf 00 00 00 00       	mov    $0x0,%edi
  801851:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801854:	74 4f                	je     8018a5 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801856:	8b 43 04             	mov    0x4(%ebx),%eax
  801859:	8b 0b                	mov    (%ebx),%ecx
  80185b:	8d 51 20             	lea    0x20(%ecx),%edx
  80185e:	39 d0                	cmp    %edx,%eax
  801860:	72 14                	jb     801876 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801862:	89 da                	mov    %ebx,%edx
  801864:	89 f0                	mov    %esi,%eax
  801866:	e8 61 ff ff ff       	call   8017cc <_pipeisclosed>
  80186b:	85 c0                	test   %eax,%eax
  80186d:	75 3b                	jne    8018aa <devpipe_write+0x79>
			sys_yield();
  80186f:	e8 c1 f3 ff ff       	call   800c35 <sys_yield>
  801874:	eb e0                	jmp    801856 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801876:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801879:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80187d:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801880:	89 c2                	mov    %eax,%edx
  801882:	c1 fa 1f             	sar    $0x1f,%edx
  801885:	89 d1                	mov    %edx,%ecx
  801887:	c1 e9 1b             	shr    $0x1b,%ecx
  80188a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80188d:	83 e2 1f             	and    $0x1f,%edx
  801890:	29 ca                	sub    %ecx,%edx
  801892:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801896:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80189a:	83 c0 01             	add    $0x1,%eax
  80189d:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8018a0:	83 c7 01             	add    $0x1,%edi
  8018a3:	eb ac                	jmp    801851 <devpipe_write+0x20>
	return i;
  8018a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a8:	eb 05                	jmp    8018af <devpipe_write+0x7e>
				return 0;
  8018aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018af:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018b2:	5b                   	pop    %ebx
  8018b3:	5e                   	pop    %esi
  8018b4:	5f                   	pop    %edi
  8018b5:	5d                   	pop    %ebp
  8018b6:	c3                   	ret    

008018b7 <devpipe_read>:
{
  8018b7:	f3 0f 1e fb          	endbr32 
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
  8018be:	57                   	push   %edi
  8018bf:	56                   	push   %esi
  8018c0:	53                   	push   %ebx
  8018c1:	83 ec 18             	sub    $0x18,%esp
  8018c4:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8018c7:	57                   	push   %edi
  8018c8:	e8 49 f6 ff ff       	call   800f16 <fd2data>
  8018cd:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8018cf:	83 c4 10             	add    $0x10,%esp
  8018d2:	be 00 00 00 00       	mov    $0x0,%esi
  8018d7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8018da:	75 14                	jne    8018f0 <devpipe_read+0x39>
	return i;
  8018dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8018df:	eb 02                	jmp    8018e3 <devpipe_read+0x2c>
				return i;
  8018e1:	89 f0                	mov    %esi,%eax
}
  8018e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018e6:	5b                   	pop    %ebx
  8018e7:	5e                   	pop    %esi
  8018e8:	5f                   	pop    %edi
  8018e9:	5d                   	pop    %ebp
  8018ea:	c3                   	ret    
			sys_yield();
  8018eb:	e8 45 f3 ff ff       	call   800c35 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8018f0:	8b 03                	mov    (%ebx),%eax
  8018f2:	3b 43 04             	cmp    0x4(%ebx),%eax
  8018f5:	75 18                	jne    80190f <devpipe_read+0x58>
			if (i > 0)
  8018f7:	85 f6                	test   %esi,%esi
  8018f9:	75 e6                	jne    8018e1 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8018fb:	89 da                	mov    %ebx,%edx
  8018fd:	89 f8                	mov    %edi,%eax
  8018ff:	e8 c8 fe ff ff       	call   8017cc <_pipeisclosed>
  801904:	85 c0                	test   %eax,%eax
  801906:	74 e3                	je     8018eb <devpipe_read+0x34>
				return 0;
  801908:	b8 00 00 00 00       	mov    $0x0,%eax
  80190d:	eb d4                	jmp    8018e3 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80190f:	99                   	cltd   
  801910:	c1 ea 1b             	shr    $0x1b,%edx
  801913:	01 d0                	add    %edx,%eax
  801915:	83 e0 1f             	and    $0x1f,%eax
  801918:	29 d0                	sub    %edx,%eax
  80191a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80191f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801922:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801925:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801928:	83 c6 01             	add    $0x1,%esi
  80192b:	eb aa                	jmp    8018d7 <devpipe_read+0x20>

0080192d <pipe>:
{
  80192d:	f3 0f 1e fb          	endbr32 
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	56                   	push   %esi
  801935:	53                   	push   %ebx
  801936:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801939:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80193c:	50                   	push   %eax
  80193d:	e8 ef f5 ff ff       	call   800f31 <fd_alloc>
  801942:	89 c3                	mov    %eax,%ebx
  801944:	83 c4 10             	add    $0x10,%esp
  801947:	85 c0                	test   %eax,%eax
  801949:	0f 88 23 01 00 00    	js     801a72 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80194f:	83 ec 04             	sub    $0x4,%esp
  801952:	68 07 04 00 00       	push   $0x407
  801957:	ff 75 f4             	pushl  -0xc(%ebp)
  80195a:	6a 00                	push   $0x0
  80195c:	e8 f7 f2 ff ff       	call   800c58 <sys_page_alloc>
  801961:	89 c3                	mov    %eax,%ebx
  801963:	83 c4 10             	add    $0x10,%esp
  801966:	85 c0                	test   %eax,%eax
  801968:	0f 88 04 01 00 00    	js     801a72 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  80196e:	83 ec 0c             	sub    $0xc,%esp
  801971:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801974:	50                   	push   %eax
  801975:	e8 b7 f5 ff ff       	call   800f31 <fd_alloc>
  80197a:	89 c3                	mov    %eax,%ebx
  80197c:	83 c4 10             	add    $0x10,%esp
  80197f:	85 c0                	test   %eax,%eax
  801981:	0f 88 db 00 00 00    	js     801a62 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801987:	83 ec 04             	sub    $0x4,%esp
  80198a:	68 07 04 00 00       	push   $0x407
  80198f:	ff 75 f0             	pushl  -0x10(%ebp)
  801992:	6a 00                	push   $0x0
  801994:	e8 bf f2 ff ff       	call   800c58 <sys_page_alloc>
  801999:	89 c3                	mov    %eax,%ebx
  80199b:	83 c4 10             	add    $0x10,%esp
  80199e:	85 c0                	test   %eax,%eax
  8019a0:	0f 88 bc 00 00 00    	js     801a62 <pipe+0x135>
	va = fd2data(fd0);
  8019a6:	83 ec 0c             	sub    $0xc,%esp
  8019a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8019ac:	e8 65 f5 ff ff       	call   800f16 <fd2data>
  8019b1:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019b3:	83 c4 0c             	add    $0xc,%esp
  8019b6:	68 07 04 00 00       	push   $0x407
  8019bb:	50                   	push   %eax
  8019bc:	6a 00                	push   $0x0
  8019be:	e8 95 f2 ff ff       	call   800c58 <sys_page_alloc>
  8019c3:	89 c3                	mov    %eax,%ebx
  8019c5:	83 c4 10             	add    $0x10,%esp
  8019c8:	85 c0                	test   %eax,%eax
  8019ca:	0f 88 82 00 00 00    	js     801a52 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019d0:	83 ec 0c             	sub    $0xc,%esp
  8019d3:	ff 75 f0             	pushl  -0x10(%ebp)
  8019d6:	e8 3b f5 ff ff       	call   800f16 <fd2data>
  8019db:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8019e2:	50                   	push   %eax
  8019e3:	6a 00                	push   $0x0
  8019e5:	56                   	push   %esi
  8019e6:	6a 00                	push   $0x0
  8019e8:	e8 b2 f2 ff ff       	call   800c9f <sys_page_map>
  8019ed:	89 c3                	mov    %eax,%ebx
  8019ef:	83 c4 20             	add    $0x20,%esp
  8019f2:	85 c0                	test   %eax,%eax
  8019f4:	78 4e                	js     801a44 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8019f6:	a1 20 30 80 00       	mov    0x803020,%eax
  8019fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019fe:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801a00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a03:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801a0a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a0d:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a12:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801a19:	83 ec 0c             	sub    $0xc,%esp
  801a1c:	ff 75 f4             	pushl  -0xc(%ebp)
  801a1f:	e8 de f4 ff ff       	call   800f02 <fd2num>
  801a24:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a27:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801a29:	83 c4 04             	add    $0x4,%esp
  801a2c:	ff 75 f0             	pushl  -0x10(%ebp)
  801a2f:	e8 ce f4 ff ff       	call   800f02 <fd2num>
  801a34:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a37:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801a3a:	83 c4 10             	add    $0x10,%esp
  801a3d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a42:	eb 2e                	jmp    801a72 <pipe+0x145>
	sys_page_unmap(0, va);
  801a44:	83 ec 08             	sub    $0x8,%esp
  801a47:	56                   	push   %esi
  801a48:	6a 00                	push   $0x0
  801a4a:	e8 96 f2 ff ff       	call   800ce5 <sys_page_unmap>
  801a4f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801a52:	83 ec 08             	sub    $0x8,%esp
  801a55:	ff 75 f0             	pushl  -0x10(%ebp)
  801a58:	6a 00                	push   $0x0
  801a5a:	e8 86 f2 ff ff       	call   800ce5 <sys_page_unmap>
  801a5f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801a62:	83 ec 08             	sub    $0x8,%esp
  801a65:	ff 75 f4             	pushl  -0xc(%ebp)
  801a68:	6a 00                	push   $0x0
  801a6a:	e8 76 f2 ff ff       	call   800ce5 <sys_page_unmap>
  801a6f:	83 c4 10             	add    $0x10,%esp
}
  801a72:	89 d8                	mov    %ebx,%eax
  801a74:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a77:	5b                   	pop    %ebx
  801a78:	5e                   	pop    %esi
  801a79:	5d                   	pop    %ebp
  801a7a:	c3                   	ret    

00801a7b <pipeisclosed>:
{
  801a7b:	f3 0f 1e fb          	endbr32 
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
  801a82:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a85:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a88:	50                   	push   %eax
  801a89:	ff 75 08             	pushl  0x8(%ebp)
  801a8c:	e8 f6 f4 ff ff       	call   800f87 <fd_lookup>
  801a91:	83 c4 10             	add    $0x10,%esp
  801a94:	85 c0                	test   %eax,%eax
  801a96:	78 18                	js     801ab0 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801a98:	83 ec 0c             	sub    $0xc,%esp
  801a9b:	ff 75 f4             	pushl  -0xc(%ebp)
  801a9e:	e8 73 f4 ff ff       	call   800f16 <fd2data>
  801aa3:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa8:	e8 1f fd ff ff       	call   8017cc <_pipeisclosed>
  801aad:	83 c4 10             	add    $0x10,%esp
}
  801ab0:	c9                   	leave  
  801ab1:	c3                   	ret    

00801ab2 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801ab2:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801ab6:	b8 00 00 00 00       	mov    $0x0,%eax
  801abb:	c3                   	ret    

00801abc <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801abc:	f3 0f 1e fb          	endbr32 
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
  801ac3:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801ac6:	68 3e 25 80 00       	push   $0x80253e
  801acb:	ff 75 0c             	pushl  0xc(%ebp)
  801ace:	e8 43 ed ff ff       	call   800816 <strcpy>
	return 0;
}
  801ad3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

00801ada <devcons_write>:
{
  801ada:	f3 0f 1e fb          	endbr32 
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
  801ae1:	57                   	push   %edi
  801ae2:	56                   	push   %esi
  801ae3:	53                   	push   %ebx
  801ae4:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801aea:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801aef:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801af5:	3b 75 10             	cmp    0x10(%ebp),%esi
  801af8:	73 31                	jae    801b2b <devcons_write+0x51>
		m = n - tot;
  801afa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801afd:	29 f3                	sub    %esi,%ebx
  801aff:	83 fb 7f             	cmp    $0x7f,%ebx
  801b02:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801b07:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801b0a:	83 ec 04             	sub    $0x4,%esp
  801b0d:	53                   	push   %ebx
  801b0e:	89 f0                	mov    %esi,%eax
  801b10:	03 45 0c             	add    0xc(%ebp),%eax
  801b13:	50                   	push   %eax
  801b14:	57                   	push   %edi
  801b15:	e8 b2 ee ff ff       	call   8009cc <memmove>
		sys_cputs(buf, m);
  801b1a:	83 c4 08             	add    $0x8,%esp
  801b1d:	53                   	push   %ebx
  801b1e:	57                   	push   %edi
  801b1f:	e8 64 f0 ff ff       	call   800b88 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801b24:	01 de                	add    %ebx,%esi
  801b26:	83 c4 10             	add    $0x10,%esp
  801b29:	eb ca                	jmp    801af5 <devcons_write+0x1b>
}
  801b2b:	89 f0                	mov    %esi,%eax
  801b2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b30:	5b                   	pop    %ebx
  801b31:	5e                   	pop    %esi
  801b32:	5f                   	pop    %edi
  801b33:	5d                   	pop    %ebp
  801b34:	c3                   	ret    

00801b35 <devcons_read>:
{
  801b35:	f3 0f 1e fb          	endbr32 
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
  801b3c:	83 ec 08             	sub    $0x8,%esp
  801b3f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801b44:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b48:	74 21                	je     801b6b <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801b4a:	e8 5b f0 ff ff       	call   800baa <sys_cgetc>
  801b4f:	85 c0                	test   %eax,%eax
  801b51:	75 07                	jne    801b5a <devcons_read+0x25>
		sys_yield();
  801b53:	e8 dd f0 ff ff       	call   800c35 <sys_yield>
  801b58:	eb f0                	jmp    801b4a <devcons_read+0x15>
	if (c < 0)
  801b5a:	78 0f                	js     801b6b <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801b5c:	83 f8 04             	cmp    $0x4,%eax
  801b5f:	74 0c                	je     801b6d <devcons_read+0x38>
	*(char*)vbuf = c;
  801b61:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b64:	88 02                	mov    %al,(%edx)
	return 1;
  801b66:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b6b:	c9                   	leave  
  801b6c:	c3                   	ret    
		return 0;
  801b6d:	b8 00 00 00 00       	mov    $0x0,%eax
  801b72:	eb f7                	jmp    801b6b <devcons_read+0x36>

00801b74 <cputchar>:
{
  801b74:	f3 0f 1e fb          	endbr32 
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
  801b7b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b81:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801b84:	6a 01                	push   $0x1
  801b86:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801b89:	50                   	push   %eax
  801b8a:	e8 f9 ef ff ff       	call   800b88 <sys_cputs>
}
  801b8f:	83 c4 10             	add    $0x10,%esp
  801b92:	c9                   	leave  
  801b93:	c3                   	ret    

00801b94 <getchar>:
{
  801b94:	f3 0f 1e fb          	endbr32 
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
  801b9b:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801b9e:	6a 01                	push   $0x1
  801ba0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ba3:	50                   	push   %eax
  801ba4:	6a 00                	push   $0x0
  801ba6:	e8 5f f6 ff ff       	call   80120a <read>
	if (r < 0)
  801bab:	83 c4 10             	add    $0x10,%esp
  801bae:	85 c0                	test   %eax,%eax
  801bb0:	78 06                	js     801bb8 <getchar+0x24>
	if (r < 1)
  801bb2:	74 06                	je     801bba <getchar+0x26>
	return c;
  801bb4:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801bb8:	c9                   	leave  
  801bb9:	c3                   	ret    
		return -E_EOF;
  801bba:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801bbf:	eb f7                	jmp    801bb8 <getchar+0x24>

00801bc1 <iscons>:
{
  801bc1:	f3 0f 1e fb          	endbr32 
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
  801bc8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bcb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bce:	50                   	push   %eax
  801bcf:	ff 75 08             	pushl  0x8(%ebp)
  801bd2:	e8 b0 f3 ff ff       	call   800f87 <fd_lookup>
  801bd7:	83 c4 10             	add    $0x10,%esp
  801bda:	85 c0                	test   %eax,%eax
  801bdc:	78 11                	js     801bef <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be1:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801be7:	39 10                	cmp    %edx,(%eax)
  801be9:	0f 94 c0             	sete   %al
  801bec:	0f b6 c0             	movzbl %al,%eax
}
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <opencons>:
{
  801bf1:	f3 0f 1e fb          	endbr32 
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
  801bf8:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801bfb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bfe:	50                   	push   %eax
  801bff:	e8 2d f3 ff ff       	call   800f31 <fd_alloc>
  801c04:	83 c4 10             	add    $0x10,%esp
  801c07:	85 c0                	test   %eax,%eax
  801c09:	78 3a                	js     801c45 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801c0b:	83 ec 04             	sub    $0x4,%esp
  801c0e:	68 07 04 00 00       	push   $0x407
  801c13:	ff 75 f4             	pushl  -0xc(%ebp)
  801c16:	6a 00                	push   $0x0
  801c18:	e8 3b f0 ff ff       	call   800c58 <sys_page_alloc>
  801c1d:	83 c4 10             	add    $0x10,%esp
  801c20:	85 c0                	test   %eax,%eax
  801c22:	78 21                	js     801c45 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c27:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c2d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c32:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801c39:	83 ec 0c             	sub    $0xc,%esp
  801c3c:	50                   	push   %eax
  801c3d:	e8 c0 f2 ff ff       	call   800f02 <fd2num>
  801c42:	83 c4 10             	add    $0x10,%esp
}
  801c45:	c9                   	leave  
  801c46:	c3                   	ret    

00801c47 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801c47:	f3 0f 1e fb          	endbr32 
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
  801c4e:	56                   	push   %esi
  801c4f:	53                   	push   %ebx
  801c50:	8b 75 08             	mov    0x8(%ebp),%esi
  801c53:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c56:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  801c59:	85 c0                	test   %eax,%eax
  801c5b:	74 3d                	je     801c9a <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  801c5d:	83 ec 0c             	sub    $0xc,%esp
  801c60:	50                   	push   %eax
  801c61:	e8 be f1 ff ff       	call   800e24 <sys_ipc_recv>
  801c66:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  801c69:	85 f6                	test   %esi,%esi
  801c6b:	74 0b                	je     801c78 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801c6d:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c73:	8b 52 74             	mov    0x74(%edx),%edx
  801c76:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801c78:	85 db                	test   %ebx,%ebx
  801c7a:	74 0b                	je     801c87 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  801c7c:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c82:	8b 52 78             	mov    0x78(%edx),%edx
  801c85:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  801c87:	85 c0                	test   %eax,%eax
  801c89:	78 21                	js     801cac <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  801c8b:	a1 04 40 80 00       	mov    0x804004,%eax
  801c90:	8b 40 70             	mov    0x70(%eax),%eax
}
  801c93:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c96:	5b                   	pop    %ebx
  801c97:	5e                   	pop    %esi
  801c98:	5d                   	pop    %ebp
  801c99:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  801c9a:	83 ec 0c             	sub    $0xc,%esp
  801c9d:	68 00 00 c0 ee       	push   $0xeec00000
  801ca2:	e8 7d f1 ff ff       	call   800e24 <sys_ipc_recv>
  801ca7:	83 c4 10             	add    $0x10,%esp
  801caa:	eb bd                	jmp    801c69 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  801cac:	85 f6                	test   %esi,%esi
  801cae:	74 10                	je     801cc0 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  801cb0:	85 db                	test   %ebx,%ebx
  801cb2:	75 df                	jne    801c93 <ipc_recv+0x4c>
  801cb4:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801cbb:	00 00 00 
  801cbe:	eb d3                	jmp    801c93 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  801cc0:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801cc7:	00 00 00 
  801cca:	eb e4                	jmp    801cb0 <ipc_recv+0x69>

00801ccc <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801ccc:	f3 0f 1e fb          	endbr32 
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	57                   	push   %edi
  801cd4:	56                   	push   %esi
  801cd5:	53                   	push   %ebx
  801cd6:	83 ec 0c             	sub    $0xc,%esp
  801cd9:	8b 7d 08             	mov    0x8(%ebp),%edi
  801cdc:	8b 75 0c             	mov    0xc(%ebp),%esi
  801cdf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  801ce2:	85 db                	test   %ebx,%ebx
  801ce4:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801ce9:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  801cec:	ff 75 14             	pushl  0x14(%ebp)
  801cef:	53                   	push   %ebx
  801cf0:	56                   	push   %esi
  801cf1:	57                   	push   %edi
  801cf2:	e8 06 f1 ff ff       	call   800dfd <sys_ipc_try_send>
  801cf7:	83 c4 10             	add    $0x10,%esp
  801cfa:	85 c0                	test   %eax,%eax
  801cfc:	79 1e                	jns    801d1c <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  801cfe:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801d01:	75 07                	jne    801d0a <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  801d03:	e8 2d ef ff ff       	call   800c35 <sys_yield>
  801d08:	eb e2                	jmp    801cec <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  801d0a:	50                   	push   %eax
  801d0b:	68 4a 25 80 00       	push   $0x80254a
  801d10:	6a 59                	push   $0x59
  801d12:	68 65 25 80 00       	push   $0x802565
  801d17:	e8 09 e4 ff ff       	call   800125 <_panic>
	}
}
  801d1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d1f:	5b                   	pop    %ebx
  801d20:	5e                   	pop    %esi
  801d21:	5f                   	pop    %edi
  801d22:	5d                   	pop    %ebp
  801d23:	c3                   	ret    

00801d24 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801d24:	f3 0f 1e fb          	endbr32 
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
  801d2b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801d2e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801d33:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801d36:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801d3c:	8b 52 50             	mov    0x50(%edx),%edx
  801d3f:	39 ca                	cmp    %ecx,%edx
  801d41:	74 11                	je     801d54 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801d43:	83 c0 01             	add    $0x1,%eax
  801d46:	3d 00 04 00 00       	cmp    $0x400,%eax
  801d4b:	75 e6                	jne    801d33 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801d4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d52:	eb 0b                	jmp    801d5f <ipc_find_env+0x3b>
			return envs[i].env_id;
  801d54:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801d57:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801d5c:	8b 40 48             	mov    0x48(%eax),%eax
}
  801d5f:	5d                   	pop    %ebp
  801d60:	c3                   	ret    

00801d61 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801d61:	f3 0f 1e fb          	endbr32 
  801d65:	55                   	push   %ebp
  801d66:	89 e5                	mov    %esp,%ebp
  801d68:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801d6b:	89 c2                	mov    %eax,%edx
  801d6d:	c1 ea 16             	shr    $0x16,%edx
  801d70:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801d77:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801d7c:	f6 c1 01             	test   $0x1,%cl
  801d7f:	74 1c                	je     801d9d <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801d81:	c1 e8 0c             	shr    $0xc,%eax
  801d84:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801d8b:	a8 01                	test   $0x1,%al
  801d8d:	74 0e                	je     801d9d <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801d8f:	c1 e8 0c             	shr    $0xc,%eax
  801d92:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801d99:	ef 
  801d9a:	0f b7 d2             	movzwl %dx,%edx
}
  801d9d:	89 d0                	mov    %edx,%eax
  801d9f:	5d                   	pop    %ebp
  801da0:	c3                   	ret    
  801da1:	66 90                	xchg   %ax,%ax
  801da3:	66 90                	xchg   %ax,%ax
  801da5:	66 90                	xchg   %ax,%ax
  801da7:	66 90                	xchg   %ax,%ax
  801da9:	66 90                	xchg   %ax,%ax
  801dab:	66 90                	xchg   %ax,%ax
  801dad:	66 90                	xchg   %ax,%ax
  801daf:	90                   	nop

00801db0 <__udivdi3>:
  801db0:	f3 0f 1e fb          	endbr32 
  801db4:	55                   	push   %ebp
  801db5:	57                   	push   %edi
  801db6:	56                   	push   %esi
  801db7:	53                   	push   %ebx
  801db8:	83 ec 1c             	sub    $0x1c,%esp
  801dbb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801dbf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801dc3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801dc7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801dcb:	85 d2                	test   %edx,%edx
  801dcd:	75 19                	jne    801de8 <__udivdi3+0x38>
  801dcf:	39 f3                	cmp    %esi,%ebx
  801dd1:	76 4d                	jbe    801e20 <__udivdi3+0x70>
  801dd3:	31 ff                	xor    %edi,%edi
  801dd5:	89 e8                	mov    %ebp,%eax
  801dd7:	89 f2                	mov    %esi,%edx
  801dd9:	f7 f3                	div    %ebx
  801ddb:	89 fa                	mov    %edi,%edx
  801ddd:	83 c4 1c             	add    $0x1c,%esp
  801de0:	5b                   	pop    %ebx
  801de1:	5e                   	pop    %esi
  801de2:	5f                   	pop    %edi
  801de3:	5d                   	pop    %ebp
  801de4:	c3                   	ret    
  801de5:	8d 76 00             	lea    0x0(%esi),%esi
  801de8:	39 f2                	cmp    %esi,%edx
  801dea:	76 14                	jbe    801e00 <__udivdi3+0x50>
  801dec:	31 ff                	xor    %edi,%edi
  801dee:	31 c0                	xor    %eax,%eax
  801df0:	89 fa                	mov    %edi,%edx
  801df2:	83 c4 1c             	add    $0x1c,%esp
  801df5:	5b                   	pop    %ebx
  801df6:	5e                   	pop    %esi
  801df7:	5f                   	pop    %edi
  801df8:	5d                   	pop    %ebp
  801df9:	c3                   	ret    
  801dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801e00:	0f bd fa             	bsr    %edx,%edi
  801e03:	83 f7 1f             	xor    $0x1f,%edi
  801e06:	75 48                	jne    801e50 <__udivdi3+0xa0>
  801e08:	39 f2                	cmp    %esi,%edx
  801e0a:	72 06                	jb     801e12 <__udivdi3+0x62>
  801e0c:	31 c0                	xor    %eax,%eax
  801e0e:	39 eb                	cmp    %ebp,%ebx
  801e10:	77 de                	ja     801df0 <__udivdi3+0x40>
  801e12:	b8 01 00 00 00       	mov    $0x1,%eax
  801e17:	eb d7                	jmp    801df0 <__udivdi3+0x40>
  801e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e20:	89 d9                	mov    %ebx,%ecx
  801e22:	85 db                	test   %ebx,%ebx
  801e24:	75 0b                	jne    801e31 <__udivdi3+0x81>
  801e26:	b8 01 00 00 00       	mov    $0x1,%eax
  801e2b:	31 d2                	xor    %edx,%edx
  801e2d:	f7 f3                	div    %ebx
  801e2f:	89 c1                	mov    %eax,%ecx
  801e31:	31 d2                	xor    %edx,%edx
  801e33:	89 f0                	mov    %esi,%eax
  801e35:	f7 f1                	div    %ecx
  801e37:	89 c6                	mov    %eax,%esi
  801e39:	89 e8                	mov    %ebp,%eax
  801e3b:	89 f7                	mov    %esi,%edi
  801e3d:	f7 f1                	div    %ecx
  801e3f:	89 fa                	mov    %edi,%edx
  801e41:	83 c4 1c             	add    $0x1c,%esp
  801e44:	5b                   	pop    %ebx
  801e45:	5e                   	pop    %esi
  801e46:	5f                   	pop    %edi
  801e47:	5d                   	pop    %ebp
  801e48:	c3                   	ret    
  801e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e50:	89 f9                	mov    %edi,%ecx
  801e52:	b8 20 00 00 00       	mov    $0x20,%eax
  801e57:	29 f8                	sub    %edi,%eax
  801e59:	d3 e2                	shl    %cl,%edx
  801e5b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e5f:	89 c1                	mov    %eax,%ecx
  801e61:	89 da                	mov    %ebx,%edx
  801e63:	d3 ea                	shr    %cl,%edx
  801e65:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801e69:	09 d1                	or     %edx,%ecx
  801e6b:	89 f2                	mov    %esi,%edx
  801e6d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e71:	89 f9                	mov    %edi,%ecx
  801e73:	d3 e3                	shl    %cl,%ebx
  801e75:	89 c1                	mov    %eax,%ecx
  801e77:	d3 ea                	shr    %cl,%edx
  801e79:	89 f9                	mov    %edi,%ecx
  801e7b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801e7f:	89 eb                	mov    %ebp,%ebx
  801e81:	d3 e6                	shl    %cl,%esi
  801e83:	89 c1                	mov    %eax,%ecx
  801e85:	d3 eb                	shr    %cl,%ebx
  801e87:	09 de                	or     %ebx,%esi
  801e89:	89 f0                	mov    %esi,%eax
  801e8b:	f7 74 24 08          	divl   0x8(%esp)
  801e8f:	89 d6                	mov    %edx,%esi
  801e91:	89 c3                	mov    %eax,%ebx
  801e93:	f7 64 24 0c          	mull   0xc(%esp)
  801e97:	39 d6                	cmp    %edx,%esi
  801e99:	72 15                	jb     801eb0 <__udivdi3+0x100>
  801e9b:	89 f9                	mov    %edi,%ecx
  801e9d:	d3 e5                	shl    %cl,%ebp
  801e9f:	39 c5                	cmp    %eax,%ebp
  801ea1:	73 04                	jae    801ea7 <__udivdi3+0xf7>
  801ea3:	39 d6                	cmp    %edx,%esi
  801ea5:	74 09                	je     801eb0 <__udivdi3+0x100>
  801ea7:	89 d8                	mov    %ebx,%eax
  801ea9:	31 ff                	xor    %edi,%edi
  801eab:	e9 40 ff ff ff       	jmp    801df0 <__udivdi3+0x40>
  801eb0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801eb3:	31 ff                	xor    %edi,%edi
  801eb5:	e9 36 ff ff ff       	jmp    801df0 <__udivdi3+0x40>
  801eba:	66 90                	xchg   %ax,%ax
  801ebc:	66 90                	xchg   %ax,%ax
  801ebe:	66 90                	xchg   %ax,%ax

00801ec0 <__umoddi3>:
  801ec0:	f3 0f 1e fb          	endbr32 
  801ec4:	55                   	push   %ebp
  801ec5:	57                   	push   %edi
  801ec6:	56                   	push   %esi
  801ec7:	53                   	push   %ebx
  801ec8:	83 ec 1c             	sub    $0x1c,%esp
  801ecb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ecf:	8b 74 24 30          	mov    0x30(%esp),%esi
  801ed3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801ed7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801edb:	85 c0                	test   %eax,%eax
  801edd:	75 19                	jne    801ef8 <__umoddi3+0x38>
  801edf:	39 df                	cmp    %ebx,%edi
  801ee1:	76 5d                	jbe    801f40 <__umoddi3+0x80>
  801ee3:	89 f0                	mov    %esi,%eax
  801ee5:	89 da                	mov    %ebx,%edx
  801ee7:	f7 f7                	div    %edi
  801ee9:	89 d0                	mov    %edx,%eax
  801eeb:	31 d2                	xor    %edx,%edx
  801eed:	83 c4 1c             	add    $0x1c,%esp
  801ef0:	5b                   	pop    %ebx
  801ef1:	5e                   	pop    %esi
  801ef2:	5f                   	pop    %edi
  801ef3:	5d                   	pop    %ebp
  801ef4:	c3                   	ret    
  801ef5:	8d 76 00             	lea    0x0(%esi),%esi
  801ef8:	89 f2                	mov    %esi,%edx
  801efa:	39 d8                	cmp    %ebx,%eax
  801efc:	76 12                	jbe    801f10 <__umoddi3+0x50>
  801efe:	89 f0                	mov    %esi,%eax
  801f00:	89 da                	mov    %ebx,%edx
  801f02:	83 c4 1c             	add    $0x1c,%esp
  801f05:	5b                   	pop    %ebx
  801f06:	5e                   	pop    %esi
  801f07:	5f                   	pop    %edi
  801f08:	5d                   	pop    %ebp
  801f09:	c3                   	ret    
  801f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801f10:	0f bd e8             	bsr    %eax,%ebp
  801f13:	83 f5 1f             	xor    $0x1f,%ebp
  801f16:	75 50                	jne    801f68 <__umoddi3+0xa8>
  801f18:	39 d8                	cmp    %ebx,%eax
  801f1a:	0f 82 e0 00 00 00    	jb     802000 <__umoddi3+0x140>
  801f20:	89 d9                	mov    %ebx,%ecx
  801f22:	39 f7                	cmp    %esi,%edi
  801f24:	0f 86 d6 00 00 00    	jbe    802000 <__umoddi3+0x140>
  801f2a:	89 d0                	mov    %edx,%eax
  801f2c:	89 ca                	mov    %ecx,%edx
  801f2e:	83 c4 1c             	add    $0x1c,%esp
  801f31:	5b                   	pop    %ebx
  801f32:	5e                   	pop    %esi
  801f33:	5f                   	pop    %edi
  801f34:	5d                   	pop    %ebp
  801f35:	c3                   	ret    
  801f36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f3d:	8d 76 00             	lea    0x0(%esi),%esi
  801f40:	89 fd                	mov    %edi,%ebp
  801f42:	85 ff                	test   %edi,%edi
  801f44:	75 0b                	jne    801f51 <__umoddi3+0x91>
  801f46:	b8 01 00 00 00       	mov    $0x1,%eax
  801f4b:	31 d2                	xor    %edx,%edx
  801f4d:	f7 f7                	div    %edi
  801f4f:	89 c5                	mov    %eax,%ebp
  801f51:	89 d8                	mov    %ebx,%eax
  801f53:	31 d2                	xor    %edx,%edx
  801f55:	f7 f5                	div    %ebp
  801f57:	89 f0                	mov    %esi,%eax
  801f59:	f7 f5                	div    %ebp
  801f5b:	89 d0                	mov    %edx,%eax
  801f5d:	31 d2                	xor    %edx,%edx
  801f5f:	eb 8c                	jmp    801eed <__umoddi3+0x2d>
  801f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f68:	89 e9                	mov    %ebp,%ecx
  801f6a:	ba 20 00 00 00       	mov    $0x20,%edx
  801f6f:	29 ea                	sub    %ebp,%edx
  801f71:	d3 e0                	shl    %cl,%eax
  801f73:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f77:	89 d1                	mov    %edx,%ecx
  801f79:	89 f8                	mov    %edi,%eax
  801f7b:	d3 e8                	shr    %cl,%eax
  801f7d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801f81:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f85:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f89:	09 c1                	or     %eax,%ecx
  801f8b:	89 d8                	mov    %ebx,%eax
  801f8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f91:	89 e9                	mov    %ebp,%ecx
  801f93:	d3 e7                	shl    %cl,%edi
  801f95:	89 d1                	mov    %edx,%ecx
  801f97:	d3 e8                	shr    %cl,%eax
  801f99:	89 e9                	mov    %ebp,%ecx
  801f9b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801f9f:	d3 e3                	shl    %cl,%ebx
  801fa1:	89 c7                	mov    %eax,%edi
  801fa3:	89 d1                	mov    %edx,%ecx
  801fa5:	89 f0                	mov    %esi,%eax
  801fa7:	d3 e8                	shr    %cl,%eax
  801fa9:	89 e9                	mov    %ebp,%ecx
  801fab:	89 fa                	mov    %edi,%edx
  801fad:	d3 e6                	shl    %cl,%esi
  801faf:	09 d8                	or     %ebx,%eax
  801fb1:	f7 74 24 08          	divl   0x8(%esp)
  801fb5:	89 d1                	mov    %edx,%ecx
  801fb7:	89 f3                	mov    %esi,%ebx
  801fb9:	f7 64 24 0c          	mull   0xc(%esp)
  801fbd:	89 c6                	mov    %eax,%esi
  801fbf:	89 d7                	mov    %edx,%edi
  801fc1:	39 d1                	cmp    %edx,%ecx
  801fc3:	72 06                	jb     801fcb <__umoddi3+0x10b>
  801fc5:	75 10                	jne    801fd7 <__umoddi3+0x117>
  801fc7:	39 c3                	cmp    %eax,%ebx
  801fc9:	73 0c                	jae    801fd7 <__umoddi3+0x117>
  801fcb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  801fcf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801fd3:	89 d7                	mov    %edx,%edi
  801fd5:	89 c6                	mov    %eax,%esi
  801fd7:	89 ca                	mov    %ecx,%edx
  801fd9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801fde:	29 f3                	sub    %esi,%ebx
  801fe0:	19 fa                	sbb    %edi,%edx
  801fe2:	89 d0                	mov    %edx,%eax
  801fe4:	d3 e0                	shl    %cl,%eax
  801fe6:	89 e9                	mov    %ebp,%ecx
  801fe8:	d3 eb                	shr    %cl,%ebx
  801fea:	d3 ea                	shr    %cl,%edx
  801fec:	09 d8                	or     %ebx,%eax
  801fee:	83 c4 1c             	add    $0x1c,%esp
  801ff1:	5b                   	pop    %ebx
  801ff2:	5e                   	pop    %esi
  801ff3:	5f                   	pop    %edi
  801ff4:	5d                   	pop    %ebp
  801ff5:	c3                   	ret    
  801ff6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ffd:	8d 76 00             	lea    0x0(%esi),%esi
  802000:	29 fe                	sub    %edi,%esi
  802002:	19 c3                	sbb    %eax,%ebx
  802004:	89 f2                	mov    %esi,%edx
  802006:	89 d9                	mov    %ebx,%ecx
  802008:	e9 1d ff ff ff       	jmp    801f2a <__umoddi3+0x6a>
