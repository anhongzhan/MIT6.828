
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
  800044:	68 80 25 80 00       	push   $0x802580
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
  80006a:	68 cc 25 80 00       	push   $0x8025cc
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
  800084:	68 a0 25 80 00       	push   $0x8025a0
  800089:	6a 0f                	push   $0xf
  80008b:	68 8a 25 80 00       	push   $0x80258a
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
  8000a4:	e8 6f 0e 00 00       	call   800f18 <set_pgfault_handler>
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
  8000de:	a3 08 40 80 00       	mov    %eax,0x804008

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
  800111:	e8 8f 10 00 00       	call   8011a5 <close_all>
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
  800147:	68 f8 25 80 00       	push   $0x8025f8
  80014c:	e8 bb 00 00 00       	call   80020c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800151:	83 c4 18             	add    $0x18,%esp
  800154:	53                   	push   %ebx
  800155:	ff 75 10             	pushl  0x10(%ebp)
  800158:	e8 5a 00 00 00       	call   8001b7 <vcprintf>
	cprintf("\n");
  80015d:	c7 04 24 00 2b 80 00 	movl   $0x802b00,(%esp)
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
  800272:	e8 99 20 00 00       	call   802310 <__udivdi3>
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
  8002b0:	e8 6b 21 00 00       	call   802420 <__umoddi3>
  8002b5:	83 c4 14             	add    $0x14,%esp
  8002b8:	0f be 80 1b 26 80 00 	movsbl 0x80261b(%eax),%eax
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
  80035f:	3e ff 24 85 60 27 80 	notrack jmp *0x802760(,%eax,4)
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
  80042c:	8b 14 85 c0 28 80 00 	mov    0x8028c0(,%eax,4),%edx
  800433:	85 d2                	test   %edx,%edx
  800435:	74 18                	je     80044f <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800437:	52                   	push   %edx
  800438:	68 69 2a 80 00       	push   $0x802a69
  80043d:	53                   	push   %ebx
  80043e:	56                   	push   %esi
  80043f:	e8 aa fe ff ff       	call   8002ee <printfmt>
  800444:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800447:	89 7d 14             	mov    %edi,0x14(%ebp)
  80044a:	e9 66 02 00 00       	jmp    8006b5 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80044f:	50                   	push   %eax
  800450:	68 33 26 80 00       	push   $0x802633
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
  800477:	b8 2c 26 80 00       	mov    $0x80262c,%eax
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
  800c01:	68 1f 29 80 00       	push   $0x80291f
  800c06:	6a 23                	push   $0x23
  800c08:	68 3c 29 80 00       	push   $0x80293c
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
  800c8e:	68 1f 29 80 00       	push   $0x80291f
  800c93:	6a 23                	push   $0x23
  800c95:	68 3c 29 80 00       	push   $0x80293c
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
  800cd4:	68 1f 29 80 00       	push   $0x80291f
  800cd9:	6a 23                	push   $0x23
  800cdb:	68 3c 29 80 00       	push   $0x80293c
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
  800d1a:	68 1f 29 80 00       	push   $0x80291f
  800d1f:	6a 23                	push   $0x23
  800d21:	68 3c 29 80 00       	push   $0x80293c
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
  800d60:	68 1f 29 80 00       	push   $0x80291f
  800d65:	6a 23                	push   $0x23
  800d67:	68 3c 29 80 00       	push   $0x80293c
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
  800da6:	68 1f 29 80 00       	push   $0x80291f
  800dab:	6a 23                	push   $0x23
  800dad:	68 3c 29 80 00       	push   $0x80293c
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
  800dec:	68 1f 29 80 00       	push   $0x80291f
  800df1:	6a 23                	push   $0x23
  800df3:	68 3c 29 80 00       	push   $0x80293c
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
  800e58:	68 1f 29 80 00       	push   $0x80291f
  800e5d:	6a 23                	push   $0x23
  800e5f:	68 3c 29 80 00       	push   $0x80293c
  800e64:	e8 bc f2 ff ff       	call   800125 <_panic>

00800e69 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e69:	f3 0f 1e fb          	endbr32 
  800e6d:	55                   	push   %ebp
  800e6e:	89 e5                	mov    %esp,%ebp
  800e70:	57                   	push   %edi
  800e71:	56                   	push   %esi
  800e72:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e73:	ba 00 00 00 00       	mov    $0x0,%edx
  800e78:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e7d:	89 d1                	mov    %edx,%ecx
  800e7f:	89 d3                	mov    %edx,%ebx
  800e81:	89 d7                	mov    %edx,%edi
  800e83:	89 d6                	mov    %edx,%esi
  800e85:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e87:	5b                   	pop    %ebx
  800e88:	5e                   	pop    %esi
  800e89:	5f                   	pop    %edi
  800e8a:	5d                   	pop    %ebp
  800e8b:	c3                   	ret    

00800e8c <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  800e8c:	f3 0f 1e fb          	endbr32 
  800e90:	55                   	push   %ebp
  800e91:	89 e5                	mov    %esp,%ebp
  800e93:	57                   	push   %edi
  800e94:	56                   	push   %esi
  800e95:	53                   	push   %ebx
  800e96:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e99:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea4:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ea9:	89 df                	mov    %ebx,%edi
  800eab:	89 de                	mov    %ebx,%esi
  800ead:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eaf:	85 c0                	test   %eax,%eax
  800eb1:	7f 08                	jg     800ebb <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  800eb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb6:	5b                   	pop    %ebx
  800eb7:	5e                   	pop    %esi
  800eb8:	5f                   	pop    %edi
  800eb9:	5d                   	pop    %ebp
  800eba:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ebb:	83 ec 0c             	sub    $0xc,%esp
  800ebe:	50                   	push   %eax
  800ebf:	6a 0f                	push   $0xf
  800ec1:	68 1f 29 80 00       	push   $0x80291f
  800ec6:	6a 23                	push   $0x23
  800ec8:	68 3c 29 80 00       	push   $0x80293c
  800ecd:	e8 53 f2 ff ff       	call   800125 <_panic>

00800ed2 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  800ed2:	f3 0f 1e fb          	endbr32 
  800ed6:	55                   	push   %ebp
  800ed7:	89 e5                	mov    %esp,%ebp
  800ed9:	57                   	push   %edi
  800eda:	56                   	push   %esi
  800edb:	53                   	push   %ebx
  800edc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800edf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eea:	b8 10 00 00 00       	mov    $0x10,%eax
  800eef:	89 df                	mov    %ebx,%edi
  800ef1:	89 de                	mov    %ebx,%esi
  800ef3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef5:	85 c0                	test   %eax,%eax
  800ef7:	7f 08                	jg     800f01 <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  800ef9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800efc:	5b                   	pop    %ebx
  800efd:	5e                   	pop    %esi
  800efe:	5f                   	pop    %edi
  800eff:	5d                   	pop    %ebp
  800f00:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f01:	83 ec 0c             	sub    $0xc,%esp
  800f04:	50                   	push   %eax
  800f05:	6a 10                	push   $0x10
  800f07:	68 1f 29 80 00       	push   $0x80291f
  800f0c:	6a 23                	push   $0x23
  800f0e:	68 3c 29 80 00       	push   $0x80293c
  800f13:	e8 0d f2 ff ff       	call   800125 <_panic>

00800f18 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800f18:	f3 0f 1e fb          	endbr32 
  800f1c:	55                   	push   %ebp
  800f1d:	89 e5                	mov    %esp,%ebp
  800f1f:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800f22:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  800f29:	74 0a                	je     800f35 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2e:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  800f33:	c9                   	leave  
  800f34:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  800f35:	83 ec 04             	sub    $0x4,%esp
  800f38:	6a 07                	push   $0x7
  800f3a:	68 00 f0 bf ee       	push   $0xeebff000
  800f3f:	6a 00                	push   $0x0
  800f41:	e8 12 fd ff ff       	call   800c58 <sys_page_alloc>
  800f46:	83 c4 10             	add    $0x10,%esp
  800f49:	85 c0                	test   %eax,%eax
  800f4b:	78 2a                	js     800f77 <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  800f4d:	83 ec 08             	sub    $0x8,%esp
  800f50:	68 8b 0f 80 00       	push   $0x800f8b
  800f55:	6a 00                	push   $0x0
  800f57:	e8 5b fe ff ff       	call   800db7 <sys_env_set_pgfault_upcall>
  800f5c:	83 c4 10             	add    $0x10,%esp
  800f5f:	85 c0                	test   %eax,%eax
  800f61:	79 c8                	jns    800f2b <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  800f63:	83 ec 04             	sub    $0x4,%esp
  800f66:	68 78 29 80 00       	push   $0x802978
  800f6b:	6a 25                	push   $0x25
  800f6d:	68 b0 29 80 00       	push   $0x8029b0
  800f72:	e8 ae f1 ff ff       	call   800125 <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  800f77:	83 ec 04             	sub    $0x4,%esp
  800f7a:	68 4c 29 80 00       	push   $0x80294c
  800f7f:	6a 22                	push   $0x22
  800f81:	68 b0 29 80 00       	push   $0x8029b0
  800f86:	e8 9a f1 ff ff       	call   800125 <_panic>

00800f8b <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800f8b:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800f8c:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  800f91:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800f93:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  800f96:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  800f9a:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  800f9e:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  800fa1:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  800fa3:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  800fa7:	83 c4 08             	add    $0x8,%esp
	popal
  800faa:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  800fab:	83 c4 04             	add    $0x4,%esp
	popfl
  800fae:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  800faf:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  800fb0:	c3                   	ret    

00800fb1 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fb1:	f3 0f 1e fb          	endbr32 
  800fb5:	55                   	push   %ebp
  800fb6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	05 00 00 00 30       	add    $0x30000000,%eax
  800fc0:	c1 e8 0c             	shr    $0xc,%eax
}
  800fc3:	5d                   	pop    %ebp
  800fc4:	c3                   	ret    

00800fc5 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fc5:	f3 0f 1e fb          	endbr32 
  800fc9:	55                   	push   %ebp
  800fca:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcf:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800fd4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fd9:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800fde:	5d                   	pop    %ebp
  800fdf:	c3                   	ret    

00800fe0 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800fe0:	f3 0f 1e fb          	endbr32 
  800fe4:	55                   	push   %ebp
  800fe5:	89 e5                	mov    %esp,%ebp
  800fe7:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fec:	89 c2                	mov    %eax,%edx
  800fee:	c1 ea 16             	shr    $0x16,%edx
  800ff1:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ff8:	f6 c2 01             	test   $0x1,%dl
  800ffb:	74 2d                	je     80102a <fd_alloc+0x4a>
  800ffd:	89 c2                	mov    %eax,%edx
  800fff:	c1 ea 0c             	shr    $0xc,%edx
  801002:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801009:	f6 c2 01             	test   $0x1,%dl
  80100c:	74 1c                	je     80102a <fd_alloc+0x4a>
  80100e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801013:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801018:	75 d2                	jne    800fec <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801023:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801028:	eb 0a                	jmp    801034 <fd_alloc+0x54>
			*fd_store = fd;
  80102a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80102d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80102f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801034:	5d                   	pop    %ebp
  801035:	c3                   	ret    

00801036 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801036:	f3 0f 1e fb          	endbr32 
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801040:	83 f8 1f             	cmp    $0x1f,%eax
  801043:	77 30                	ja     801075 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801045:	c1 e0 0c             	shl    $0xc,%eax
  801048:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80104d:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801053:	f6 c2 01             	test   $0x1,%dl
  801056:	74 24                	je     80107c <fd_lookup+0x46>
  801058:	89 c2                	mov    %eax,%edx
  80105a:	c1 ea 0c             	shr    $0xc,%edx
  80105d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801064:	f6 c2 01             	test   $0x1,%dl
  801067:	74 1a                	je     801083 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801069:	8b 55 0c             	mov    0xc(%ebp),%edx
  80106c:	89 02                	mov    %eax,(%edx)
	return 0;
  80106e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801073:	5d                   	pop    %ebp
  801074:	c3                   	ret    
		return -E_INVAL;
  801075:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80107a:	eb f7                	jmp    801073 <fd_lookup+0x3d>
		return -E_INVAL;
  80107c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801081:	eb f0                	jmp    801073 <fd_lookup+0x3d>
  801083:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801088:	eb e9                	jmp    801073 <fd_lookup+0x3d>

0080108a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80108a:	f3 0f 1e fb          	endbr32 
  80108e:	55                   	push   %ebp
  80108f:	89 e5                	mov    %esp,%ebp
  801091:	83 ec 08             	sub    $0x8,%esp
  801094:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801097:	ba 00 00 00 00       	mov    $0x0,%edx
  80109c:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8010a1:	39 08                	cmp    %ecx,(%eax)
  8010a3:	74 38                	je     8010dd <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  8010a5:	83 c2 01             	add    $0x1,%edx
  8010a8:	8b 04 95 3c 2a 80 00 	mov    0x802a3c(,%edx,4),%eax
  8010af:	85 c0                	test   %eax,%eax
  8010b1:	75 ee                	jne    8010a1 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010b3:	a1 08 40 80 00       	mov    0x804008,%eax
  8010b8:	8b 40 48             	mov    0x48(%eax),%eax
  8010bb:	83 ec 04             	sub    $0x4,%esp
  8010be:	51                   	push   %ecx
  8010bf:	50                   	push   %eax
  8010c0:	68 c0 29 80 00       	push   $0x8029c0
  8010c5:	e8 42 f1 ff ff       	call   80020c <cprintf>
	*dev = 0;
  8010ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010d3:	83 c4 10             	add    $0x10,%esp
  8010d6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010db:	c9                   	leave  
  8010dc:	c3                   	ret    
			*dev = devtab[i];
  8010dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e0:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8010e7:	eb f2                	jmp    8010db <dev_lookup+0x51>

008010e9 <fd_close>:
{
  8010e9:	f3 0f 1e fb          	endbr32 
  8010ed:	55                   	push   %ebp
  8010ee:	89 e5                	mov    %esp,%ebp
  8010f0:	57                   	push   %edi
  8010f1:	56                   	push   %esi
  8010f2:	53                   	push   %ebx
  8010f3:	83 ec 24             	sub    $0x24,%esp
  8010f6:	8b 75 08             	mov    0x8(%ebp),%esi
  8010f9:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010fc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010ff:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801100:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801106:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801109:	50                   	push   %eax
  80110a:	e8 27 ff ff ff       	call   801036 <fd_lookup>
  80110f:	89 c3                	mov    %eax,%ebx
  801111:	83 c4 10             	add    $0x10,%esp
  801114:	85 c0                	test   %eax,%eax
  801116:	78 05                	js     80111d <fd_close+0x34>
	    || fd != fd2)
  801118:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80111b:	74 16                	je     801133 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80111d:	89 f8                	mov    %edi,%eax
  80111f:	84 c0                	test   %al,%al
  801121:	b8 00 00 00 00       	mov    $0x0,%eax
  801126:	0f 44 d8             	cmove  %eax,%ebx
}
  801129:	89 d8                	mov    %ebx,%eax
  80112b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80112e:	5b                   	pop    %ebx
  80112f:	5e                   	pop    %esi
  801130:	5f                   	pop    %edi
  801131:	5d                   	pop    %ebp
  801132:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801133:	83 ec 08             	sub    $0x8,%esp
  801136:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801139:	50                   	push   %eax
  80113a:	ff 36                	pushl  (%esi)
  80113c:	e8 49 ff ff ff       	call   80108a <dev_lookup>
  801141:	89 c3                	mov    %eax,%ebx
  801143:	83 c4 10             	add    $0x10,%esp
  801146:	85 c0                	test   %eax,%eax
  801148:	78 1a                	js     801164 <fd_close+0x7b>
		if (dev->dev_close)
  80114a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80114d:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801150:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801155:	85 c0                	test   %eax,%eax
  801157:	74 0b                	je     801164 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801159:	83 ec 0c             	sub    $0xc,%esp
  80115c:	56                   	push   %esi
  80115d:	ff d0                	call   *%eax
  80115f:	89 c3                	mov    %eax,%ebx
  801161:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801164:	83 ec 08             	sub    $0x8,%esp
  801167:	56                   	push   %esi
  801168:	6a 00                	push   $0x0
  80116a:	e8 76 fb ff ff       	call   800ce5 <sys_page_unmap>
	return r;
  80116f:	83 c4 10             	add    $0x10,%esp
  801172:	eb b5                	jmp    801129 <fd_close+0x40>

00801174 <close>:

int
close(int fdnum)
{
  801174:	f3 0f 1e fb          	endbr32 
  801178:	55                   	push   %ebp
  801179:	89 e5                	mov    %esp,%ebp
  80117b:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80117e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801181:	50                   	push   %eax
  801182:	ff 75 08             	pushl  0x8(%ebp)
  801185:	e8 ac fe ff ff       	call   801036 <fd_lookup>
  80118a:	83 c4 10             	add    $0x10,%esp
  80118d:	85 c0                	test   %eax,%eax
  80118f:	79 02                	jns    801193 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801191:	c9                   	leave  
  801192:	c3                   	ret    
		return fd_close(fd, 1);
  801193:	83 ec 08             	sub    $0x8,%esp
  801196:	6a 01                	push   $0x1
  801198:	ff 75 f4             	pushl  -0xc(%ebp)
  80119b:	e8 49 ff ff ff       	call   8010e9 <fd_close>
  8011a0:	83 c4 10             	add    $0x10,%esp
  8011a3:	eb ec                	jmp    801191 <close+0x1d>

008011a5 <close_all>:

void
close_all(void)
{
  8011a5:	f3 0f 1e fb          	endbr32 
  8011a9:	55                   	push   %ebp
  8011aa:	89 e5                	mov    %esp,%ebp
  8011ac:	53                   	push   %ebx
  8011ad:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011b0:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011b5:	83 ec 0c             	sub    $0xc,%esp
  8011b8:	53                   	push   %ebx
  8011b9:	e8 b6 ff ff ff       	call   801174 <close>
	for (i = 0; i < MAXFD; i++)
  8011be:	83 c3 01             	add    $0x1,%ebx
  8011c1:	83 c4 10             	add    $0x10,%esp
  8011c4:	83 fb 20             	cmp    $0x20,%ebx
  8011c7:	75 ec                	jne    8011b5 <close_all+0x10>
}
  8011c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011cc:	c9                   	leave  
  8011cd:	c3                   	ret    

008011ce <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011ce:	f3 0f 1e fb          	endbr32 
  8011d2:	55                   	push   %ebp
  8011d3:	89 e5                	mov    %esp,%ebp
  8011d5:	57                   	push   %edi
  8011d6:	56                   	push   %esi
  8011d7:	53                   	push   %ebx
  8011d8:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011db:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011de:	50                   	push   %eax
  8011df:	ff 75 08             	pushl  0x8(%ebp)
  8011e2:	e8 4f fe ff ff       	call   801036 <fd_lookup>
  8011e7:	89 c3                	mov    %eax,%ebx
  8011e9:	83 c4 10             	add    $0x10,%esp
  8011ec:	85 c0                	test   %eax,%eax
  8011ee:	0f 88 81 00 00 00    	js     801275 <dup+0xa7>
		return r;
	close(newfdnum);
  8011f4:	83 ec 0c             	sub    $0xc,%esp
  8011f7:	ff 75 0c             	pushl  0xc(%ebp)
  8011fa:	e8 75 ff ff ff       	call   801174 <close>

	newfd = INDEX2FD(newfdnum);
  8011ff:	8b 75 0c             	mov    0xc(%ebp),%esi
  801202:	c1 e6 0c             	shl    $0xc,%esi
  801205:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80120b:	83 c4 04             	add    $0x4,%esp
  80120e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801211:	e8 af fd ff ff       	call   800fc5 <fd2data>
  801216:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801218:	89 34 24             	mov    %esi,(%esp)
  80121b:	e8 a5 fd ff ff       	call   800fc5 <fd2data>
  801220:	83 c4 10             	add    $0x10,%esp
  801223:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801225:	89 d8                	mov    %ebx,%eax
  801227:	c1 e8 16             	shr    $0x16,%eax
  80122a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801231:	a8 01                	test   $0x1,%al
  801233:	74 11                	je     801246 <dup+0x78>
  801235:	89 d8                	mov    %ebx,%eax
  801237:	c1 e8 0c             	shr    $0xc,%eax
  80123a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801241:	f6 c2 01             	test   $0x1,%dl
  801244:	75 39                	jne    80127f <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801246:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801249:	89 d0                	mov    %edx,%eax
  80124b:	c1 e8 0c             	shr    $0xc,%eax
  80124e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801255:	83 ec 0c             	sub    $0xc,%esp
  801258:	25 07 0e 00 00       	and    $0xe07,%eax
  80125d:	50                   	push   %eax
  80125e:	56                   	push   %esi
  80125f:	6a 00                	push   $0x0
  801261:	52                   	push   %edx
  801262:	6a 00                	push   $0x0
  801264:	e8 36 fa ff ff       	call   800c9f <sys_page_map>
  801269:	89 c3                	mov    %eax,%ebx
  80126b:	83 c4 20             	add    $0x20,%esp
  80126e:	85 c0                	test   %eax,%eax
  801270:	78 31                	js     8012a3 <dup+0xd5>
		goto err;

	return newfdnum;
  801272:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801275:	89 d8                	mov    %ebx,%eax
  801277:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80127a:	5b                   	pop    %ebx
  80127b:	5e                   	pop    %esi
  80127c:	5f                   	pop    %edi
  80127d:	5d                   	pop    %ebp
  80127e:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80127f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801286:	83 ec 0c             	sub    $0xc,%esp
  801289:	25 07 0e 00 00       	and    $0xe07,%eax
  80128e:	50                   	push   %eax
  80128f:	57                   	push   %edi
  801290:	6a 00                	push   $0x0
  801292:	53                   	push   %ebx
  801293:	6a 00                	push   $0x0
  801295:	e8 05 fa ff ff       	call   800c9f <sys_page_map>
  80129a:	89 c3                	mov    %eax,%ebx
  80129c:	83 c4 20             	add    $0x20,%esp
  80129f:	85 c0                	test   %eax,%eax
  8012a1:	79 a3                	jns    801246 <dup+0x78>
	sys_page_unmap(0, newfd);
  8012a3:	83 ec 08             	sub    $0x8,%esp
  8012a6:	56                   	push   %esi
  8012a7:	6a 00                	push   $0x0
  8012a9:	e8 37 fa ff ff       	call   800ce5 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012ae:	83 c4 08             	add    $0x8,%esp
  8012b1:	57                   	push   %edi
  8012b2:	6a 00                	push   $0x0
  8012b4:	e8 2c fa ff ff       	call   800ce5 <sys_page_unmap>
	return r;
  8012b9:	83 c4 10             	add    $0x10,%esp
  8012bc:	eb b7                	jmp    801275 <dup+0xa7>

008012be <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012be:	f3 0f 1e fb          	endbr32 
  8012c2:	55                   	push   %ebp
  8012c3:	89 e5                	mov    %esp,%ebp
  8012c5:	53                   	push   %ebx
  8012c6:	83 ec 1c             	sub    $0x1c,%esp
  8012c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012cc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012cf:	50                   	push   %eax
  8012d0:	53                   	push   %ebx
  8012d1:	e8 60 fd ff ff       	call   801036 <fd_lookup>
  8012d6:	83 c4 10             	add    $0x10,%esp
  8012d9:	85 c0                	test   %eax,%eax
  8012db:	78 3f                	js     80131c <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012dd:	83 ec 08             	sub    $0x8,%esp
  8012e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012e3:	50                   	push   %eax
  8012e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012e7:	ff 30                	pushl  (%eax)
  8012e9:	e8 9c fd ff ff       	call   80108a <dev_lookup>
  8012ee:	83 c4 10             	add    $0x10,%esp
  8012f1:	85 c0                	test   %eax,%eax
  8012f3:	78 27                	js     80131c <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012f8:	8b 42 08             	mov    0x8(%edx),%eax
  8012fb:	83 e0 03             	and    $0x3,%eax
  8012fe:	83 f8 01             	cmp    $0x1,%eax
  801301:	74 1e                	je     801321 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801306:	8b 40 08             	mov    0x8(%eax),%eax
  801309:	85 c0                	test   %eax,%eax
  80130b:	74 35                	je     801342 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80130d:	83 ec 04             	sub    $0x4,%esp
  801310:	ff 75 10             	pushl  0x10(%ebp)
  801313:	ff 75 0c             	pushl  0xc(%ebp)
  801316:	52                   	push   %edx
  801317:	ff d0                	call   *%eax
  801319:	83 c4 10             	add    $0x10,%esp
}
  80131c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80131f:	c9                   	leave  
  801320:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801321:	a1 08 40 80 00       	mov    0x804008,%eax
  801326:	8b 40 48             	mov    0x48(%eax),%eax
  801329:	83 ec 04             	sub    $0x4,%esp
  80132c:	53                   	push   %ebx
  80132d:	50                   	push   %eax
  80132e:	68 01 2a 80 00       	push   $0x802a01
  801333:	e8 d4 ee ff ff       	call   80020c <cprintf>
		return -E_INVAL;
  801338:	83 c4 10             	add    $0x10,%esp
  80133b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801340:	eb da                	jmp    80131c <read+0x5e>
		return -E_NOT_SUPP;
  801342:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801347:	eb d3                	jmp    80131c <read+0x5e>

00801349 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801349:	f3 0f 1e fb          	endbr32 
  80134d:	55                   	push   %ebp
  80134e:	89 e5                	mov    %esp,%ebp
  801350:	57                   	push   %edi
  801351:	56                   	push   %esi
  801352:	53                   	push   %ebx
  801353:	83 ec 0c             	sub    $0xc,%esp
  801356:	8b 7d 08             	mov    0x8(%ebp),%edi
  801359:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80135c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801361:	eb 02                	jmp    801365 <readn+0x1c>
  801363:	01 c3                	add    %eax,%ebx
  801365:	39 f3                	cmp    %esi,%ebx
  801367:	73 21                	jae    80138a <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801369:	83 ec 04             	sub    $0x4,%esp
  80136c:	89 f0                	mov    %esi,%eax
  80136e:	29 d8                	sub    %ebx,%eax
  801370:	50                   	push   %eax
  801371:	89 d8                	mov    %ebx,%eax
  801373:	03 45 0c             	add    0xc(%ebp),%eax
  801376:	50                   	push   %eax
  801377:	57                   	push   %edi
  801378:	e8 41 ff ff ff       	call   8012be <read>
		if (m < 0)
  80137d:	83 c4 10             	add    $0x10,%esp
  801380:	85 c0                	test   %eax,%eax
  801382:	78 04                	js     801388 <readn+0x3f>
			return m;
		if (m == 0)
  801384:	75 dd                	jne    801363 <readn+0x1a>
  801386:	eb 02                	jmp    80138a <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801388:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80138a:	89 d8                	mov    %ebx,%eax
  80138c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80138f:	5b                   	pop    %ebx
  801390:	5e                   	pop    %esi
  801391:	5f                   	pop    %edi
  801392:	5d                   	pop    %ebp
  801393:	c3                   	ret    

00801394 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801394:	f3 0f 1e fb          	endbr32 
  801398:	55                   	push   %ebp
  801399:	89 e5                	mov    %esp,%ebp
  80139b:	53                   	push   %ebx
  80139c:	83 ec 1c             	sub    $0x1c,%esp
  80139f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013a2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013a5:	50                   	push   %eax
  8013a6:	53                   	push   %ebx
  8013a7:	e8 8a fc ff ff       	call   801036 <fd_lookup>
  8013ac:	83 c4 10             	add    $0x10,%esp
  8013af:	85 c0                	test   %eax,%eax
  8013b1:	78 3a                	js     8013ed <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013b3:	83 ec 08             	sub    $0x8,%esp
  8013b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013b9:	50                   	push   %eax
  8013ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013bd:	ff 30                	pushl  (%eax)
  8013bf:	e8 c6 fc ff ff       	call   80108a <dev_lookup>
  8013c4:	83 c4 10             	add    $0x10,%esp
  8013c7:	85 c0                	test   %eax,%eax
  8013c9:	78 22                	js     8013ed <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ce:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013d2:	74 1e                	je     8013f2 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013d7:	8b 52 0c             	mov    0xc(%edx),%edx
  8013da:	85 d2                	test   %edx,%edx
  8013dc:	74 35                	je     801413 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013de:	83 ec 04             	sub    $0x4,%esp
  8013e1:	ff 75 10             	pushl  0x10(%ebp)
  8013e4:	ff 75 0c             	pushl  0xc(%ebp)
  8013e7:	50                   	push   %eax
  8013e8:	ff d2                	call   *%edx
  8013ea:	83 c4 10             	add    $0x10,%esp
}
  8013ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013f0:	c9                   	leave  
  8013f1:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013f2:	a1 08 40 80 00       	mov    0x804008,%eax
  8013f7:	8b 40 48             	mov    0x48(%eax),%eax
  8013fa:	83 ec 04             	sub    $0x4,%esp
  8013fd:	53                   	push   %ebx
  8013fe:	50                   	push   %eax
  8013ff:	68 1d 2a 80 00       	push   $0x802a1d
  801404:	e8 03 ee ff ff       	call   80020c <cprintf>
		return -E_INVAL;
  801409:	83 c4 10             	add    $0x10,%esp
  80140c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801411:	eb da                	jmp    8013ed <write+0x59>
		return -E_NOT_SUPP;
  801413:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801418:	eb d3                	jmp    8013ed <write+0x59>

0080141a <seek>:

int
seek(int fdnum, off_t offset)
{
  80141a:	f3 0f 1e fb          	endbr32 
  80141e:	55                   	push   %ebp
  80141f:	89 e5                	mov    %esp,%ebp
  801421:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801424:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801427:	50                   	push   %eax
  801428:	ff 75 08             	pushl  0x8(%ebp)
  80142b:	e8 06 fc ff ff       	call   801036 <fd_lookup>
  801430:	83 c4 10             	add    $0x10,%esp
  801433:	85 c0                	test   %eax,%eax
  801435:	78 0e                	js     801445 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801437:	8b 55 0c             	mov    0xc(%ebp),%edx
  80143a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80143d:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801440:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801445:	c9                   	leave  
  801446:	c3                   	ret    

00801447 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801447:	f3 0f 1e fb          	endbr32 
  80144b:	55                   	push   %ebp
  80144c:	89 e5                	mov    %esp,%ebp
  80144e:	53                   	push   %ebx
  80144f:	83 ec 1c             	sub    $0x1c,%esp
  801452:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801455:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801458:	50                   	push   %eax
  801459:	53                   	push   %ebx
  80145a:	e8 d7 fb ff ff       	call   801036 <fd_lookup>
  80145f:	83 c4 10             	add    $0x10,%esp
  801462:	85 c0                	test   %eax,%eax
  801464:	78 37                	js     80149d <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801466:	83 ec 08             	sub    $0x8,%esp
  801469:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80146c:	50                   	push   %eax
  80146d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801470:	ff 30                	pushl  (%eax)
  801472:	e8 13 fc ff ff       	call   80108a <dev_lookup>
  801477:	83 c4 10             	add    $0x10,%esp
  80147a:	85 c0                	test   %eax,%eax
  80147c:	78 1f                	js     80149d <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80147e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801481:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801485:	74 1b                	je     8014a2 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801487:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80148a:	8b 52 18             	mov    0x18(%edx),%edx
  80148d:	85 d2                	test   %edx,%edx
  80148f:	74 32                	je     8014c3 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801491:	83 ec 08             	sub    $0x8,%esp
  801494:	ff 75 0c             	pushl  0xc(%ebp)
  801497:	50                   	push   %eax
  801498:	ff d2                	call   *%edx
  80149a:	83 c4 10             	add    $0x10,%esp
}
  80149d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014a0:	c9                   	leave  
  8014a1:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014a2:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014a7:	8b 40 48             	mov    0x48(%eax),%eax
  8014aa:	83 ec 04             	sub    $0x4,%esp
  8014ad:	53                   	push   %ebx
  8014ae:	50                   	push   %eax
  8014af:	68 e0 29 80 00       	push   $0x8029e0
  8014b4:	e8 53 ed ff ff       	call   80020c <cprintf>
		return -E_INVAL;
  8014b9:	83 c4 10             	add    $0x10,%esp
  8014bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014c1:	eb da                	jmp    80149d <ftruncate+0x56>
		return -E_NOT_SUPP;
  8014c3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014c8:	eb d3                	jmp    80149d <ftruncate+0x56>

008014ca <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014ca:	f3 0f 1e fb          	endbr32 
  8014ce:	55                   	push   %ebp
  8014cf:	89 e5                	mov    %esp,%ebp
  8014d1:	53                   	push   %ebx
  8014d2:	83 ec 1c             	sub    $0x1c,%esp
  8014d5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014d8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014db:	50                   	push   %eax
  8014dc:	ff 75 08             	pushl  0x8(%ebp)
  8014df:	e8 52 fb ff ff       	call   801036 <fd_lookup>
  8014e4:	83 c4 10             	add    $0x10,%esp
  8014e7:	85 c0                	test   %eax,%eax
  8014e9:	78 4b                	js     801536 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014eb:	83 ec 08             	sub    $0x8,%esp
  8014ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f1:	50                   	push   %eax
  8014f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f5:	ff 30                	pushl  (%eax)
  8014f7:	e8 8e fb ff ff       	call   80108a <dev_lookup>
  8014fc:	83 c4 10             	add    $0x10,%esp
  8014ff:	85 c0                	test   %eax,%eax
  801501:	78 33                	js     801536 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801503:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801506:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80150a:	74 2f                	je     80153b <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80150c:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80150f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801516:	00 00 00 
	stat->st_isdir = 0;
  801519:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801520:	00 00 00 
	stat->st_dev = dev;
  801523:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801529:	83 ec 08             	sub    $0x8,%esp
  80152c:	53                   	push   %ebx
  80152d:	ff 75 f0             	pushl  -0x10(%ebp)
  801530:	ff 50 14             	call   *0x14(%eax)
  801533:	83 c4 10             	add    $0x10,%esp
}
  801536:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801539:	c9                   	leave  
  80153a:	c3                   	ret    
		return -E_NOT_SUPP;
  80153b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801540:	eb f4                	jmp    801536 <fstat+0x6c>

00801542 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801542:	f3 0f 1e fb          	endbr32 
  801546:	55                   	push   %ebp
  801547:	89 e5                	mov    %esp,%ebp
  801549:	56                   	push   %esi
  80154a:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80154b:	83 ec 08             	sub    $0x8,%esp
  80154e:	6a 00                	push   $0x0
  801550:	ff 75 08             	pushl  0x8(%ebp)
  801553:	e8 fb 01 00 00       	call   801753 <open>
  801558:	89 c3                	mov    %eax,%ebx
  80155a:	83 c4 10             	add    $0x10,%esp
  80155d:	85 c0                	test   %eax,%eax
  80155f:	78 1b                	js     80157c <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801561:	83 ec 08             	sub    $0x8,%esp
  801564:	ff 75 0c             	pushl  0xc(%ebp)
  801567:	50                   	push   %eax
  801568:	e8 5d ff ff ff       	call   8014ca <fstat>
  80156d:	89 c6                	mov    %eax,%esi
	close(fd);
  80156f:	89 1c 24             	mov    %ebx,(%esp)
  801572:	e8 fd fb ff ff       	call   801174 <close>
	return r;
  801577:	83 c4 10             	add    $0x10,%esp
  80157a:	89 f3                	mov    %esi,%ebx
}
  80157c:	89 d8                	mov    %ebx,%eax
  80157e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801581:	5b                   	pop    %ebx
  801582:	5e                   	pop    %esi
  801583:	5d                   	pop    %ebp
  801584:	c3                   	ret    

00801585 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
  801588:	56                   	push   %esi
  801589:	53                   	push   %ebx
  80158a:	89 c6                	mov    %eax,%esi
  80158c:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80158e:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801595:	74 27                	je     8015be <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801597:	6a 07                	push   $0x7
  801599:	68 00 50 80 00       	push   $0x805000
  80159e:	56                   	push   %esi
  80159f:	ff 35 00 40 80 00    	pushl  0x804000
  8015a5:	e8 8e 0c 00 00       	call   802238 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015aa:	83 c4 0c             	add    $0xc,%esp
  8015ad:	6a 00                	push   $0x0
  8015af:	53                   	push   %ebx
  8015b0:	6a 00                	push   $0x0
  8015b2:	e8 fc 0b 00 00       	call   8021b3 <ipc_recv>
}
  8015b7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015ba:	5b                   	pop    %ebx
  8015bb:	5e                   	pop    %esi
  8015bc:	5d                   	pop    %ebp
  8015bd:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015be:	83 ec 0c             	sub    $0xc,%esp
  8015c1:	6a 01                	push   $0x1
  8015c3:	e8 c8 0c 00 00       	call   802290 <ipc_find_env>
  8015c8:	a3 00 40 80 00       	mov    %eax,0x804000
  8015cd:	83 c4 10             	add    $0x10,%esp
  8015d0:	eb c5                	jmp    801597 <fsipc+0x12>

008015d2 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015d2:	f3 0f 1e fb          	endbr32 
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
  8015d9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015df:	8b 40 0c             	mov    0xc(%eax),%eax
  8015e2:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8015e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ea:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f4:	b8 02 00 00 00       	mov    $0x2,%eax
  8015f9:	e8 87 ff ff ff       	call   801585 <fsipc>
}
  8015fe:	c9                   	leave  
  8015ff:	c3                   	ret    

00801600 <devfile_flush>:
{
  801600:	f3 0f 1e fb          	endbr32 
  801604:	55                   	push   %ebp
  801605:	89 e5                	mov    %esp,%ebp
  801607:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80160a:	8b 45 08             	mov    0x8(%ebp),%eax
  80160d:	8b 40 0c             	mov    0xc(%eax),%eax
  801610:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801615:	ba 00 00 00 00       	mov    $0x0,%edx
  80161a:	b8 06 00 00 00       	mov    $0x6,%eax
  80161f:	e8 61 ff ff ff       	call   801585 <fsipc>
}
  801624:	c9                   	leave  
  801625:	c3                   	ret    

00801626 <devfile_stat>:
{
  801626:	f3 0f 1e fb          	endbr32 
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
  80162d:	53                   	push   %ebx
  80162e:	83 ec 04             	sub    $0x4,%esp
  801631:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801634:	8b 45 08             	mov    0x8(%ebp),%eax
  801637:	8b 40 0c             	mov    0xc(%eax),%eax
  80163a:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80163f:	ba 00 00 00 00       	mov    $0x0,%edx
  801644:	b8 05 00 00 00       	mov    $0x5,%eax
  801649:	e8 37 ff ff ff       	call   801585 <fsipc>
  80164e:	85 c0                	test   %eax,%eax
  801650:	78 2c                	js     80167e <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801652:	83 ec 08             	sub    $0x8,%esp
  801655:	68 00 50 80 00       	push   $0x805000
  80165a:	53                   	push   %ebx
  80165b:	e8 b6 f1 ff ff       	call   800816 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801660:	a1 80 50 80 00       	mov    0x805080,%eax
  801665:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80166b:	a1 84 50 80 00       	mov    0x805084,%eax
  801670:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801676:	83 c4 10             	add    $0x10,%esp
  801679:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80167e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801681:	c9                   	leave  
  801682:	c3                   	ret    

00801683 <devfile_write>:
{
  801683:	f3 0f 1e fb          	endbr32 
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
  80168a:	83 ec 0c             	sub    $0xc,%esp
  80168d:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801690:	8b 55 08             	mov    0x8(%ebp),%edx
  801693:	8b 52 0c             	mov    0xc(%edx),%edx
  801696:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  80169c:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8016a1:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8016a6:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  8016a9:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  8016ae:	50                   	push   %eax
  8016af:	ff 75 0c             	pushl  0xc(%ebp)
  8016b2:	68 08 50 80 00       	push   $0x805008
  8016b7:	e8 10 f3 ff ff       	call   8009cc <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  8016bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c1:	b8 04 00 00 00       	mov    $0x4,%eax
  8016c6:	e8 ba fe ff ff       	call   801585 <fsipc>
}
  8016cb:	c9                   	leave  
  8016cc:	c3                   	ret    

008016cd <devfile_read>:
{
  8016cd:	f3 0f 1e fb          	endbr32 
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
  8016d4:	56                   	push   %esi
  8016d5:	53                   	push   %ebx
  8016d6:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8016df:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016e4:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ef:	b8 03 00 00 00       	mov    $0x3,%eax
  8016f4:	e8 8c fe ff ff       	call   801585 <fsipc>
  8016f9:	89 c3                	mov    %eax,%ebx
  8016fb:	85 c0                	test   %eax,%eax
  8016fd:	78 1f                	js     80171e <devfile_read+0x51>
	assert(r <= n);
  8016ff:	39 f0                	cmp    %esi,%eax
  801701:	77 24                	ja     801727 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801703:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801708:	7f 33                	jg     80173d <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80170a:	83 ec 04             	sub    $0x4,%esp
  80170d:	50                   	push   %eax
  80170e:	68 00 50 80 00       	push   $0x805000
  801713:	ff 75 0c             	pushl  0xc(%ebp)
  801716:	e8 b1 f2 ff ff       	call   8009cc <memmove>
	return r;
  80171b:	83 c4 10             	add    $0x10,%esp
}
  80171e:	89 d8                	mov    %ebx,%eax
  801720:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801723:	5b                   	pop    %ebx
  801724:	5e                   	pop    %esi
  801725:	5d                   	pop    %ebp
  801726:	c3                   	ret    
	assert(r <= n);
  801727:	68 50 2a 80 00       	push   $0x802a50
  80172c:	68 57 2a 80 00       	push   $0x802a57
  801731:	6a 7c                	push   $0x7c
  801733:	68 6c 2a 80 00       	push   $0x802a6c
  801738:	e8 e8 e9 ff ff       	call   800125 <_panic>
	assert(r <= PGSIZE);
  80173d:	68 77 2a 80 00       	push   $0x802a77
  801742:	68 57 2a 80 00       	push   $0x802a57
  801747:	6a 7d                	push   $0x7d
  801749:	68 6c 2a 80 00       	push   $0x802a6c
  80174e:	e8 d2 e9 ff ff       	call   800125 <_panic>

00801753 <open>:
{
  801753:	f3 0f 1e fb          	endbr32 
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
  80175a:	56                   	push   %esi
  80175b:	53                   	push   %ebx
  80175c:	83 ec 1c             	sub    $0x1c,%esp
  80175f:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801762:	56                   	push   %esi
  801763:	e8 6b f0 ff ff       	call   8007d3 <strlen>
  801768:	83 c4 10             	add    $0x10,%esp
  80176b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801770:	7f 6c                	jg     8017de <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801772:	83 ec 0c             	sub    $0xc,%esp
  801775:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801778:	50                   	push   %eax
  801779:	e8 62 f8 ff ff       	call   800fe0 <fd_alloc>
  80177e:	89 c3                	mov    %eax,%ebx
  801780:	83 c4 10             	add    $0x10,%esp
  801783:	85 c0                	test   %eax,%eax
  801785:	78 3c                	js     8017c3 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801787:	83 ec 08             	sub    $0x8,%esp
  80178a:	56                   	push   %esi
  80178b:	68 00 50 80 00       	push   $0x805000
  801790:	e8 81 f0 ff ff       	call   800816 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801795:	8b 45 0c             	mov    0xc(%ebp),%eax
  801798:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80179d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017a0:	b8 01 00 00 00       	mov    $0x1,%eax
  8017a5:	e8 db fd ff ff       	call   801585 <fsipc>
  8017aa:	89 c3                	mov    %eax,%ebx
  8017ac:	83 c4 10             	add    $0x10,%esp
  8017af:	85 c0                	test   %eax,%eax
  8017b1:	78 19                	js     8017cc <open+0x79>
	return fd2num(fd);
  8017b3:	83 ec 0c             	sub    $0xc,%esp
  8017b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8017b9:	e8 f3 f7 ff ff       	call   800fb1 <fd2num>
  8017be:	89 c3                	mov    %eax,%ebx
  8017c0:	83 c4 10             	add    $0x10,%esp
}
  8017c3:	89 d8                	mov    %ebx,%eax
  8017c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017c8:	5b                   	pop    %ebx
  8017c9:	5e                   	pop    %esi
  8017ca:	5d                   	pop    %ebp
  8017cb:	c3                   	ret    
		fd_close(fd, 0);
  8017cc:	83 ec 08             	sub    $0x8,%esp
  8017cf:	6a 00                	push   $0x0
  8017d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8017d4:	e8 10 f9 ff ff       	call   8010e9 <fd_close>
		return r;
  8017d9:	83 c4 10             	add    $0x10,%esp
  8017dc:	eb e5                	jmp    8017c3 <open+0x70>
		return -E_BAD_PATH;
  8017de:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017e3:	eb de                	jmp    8017c3 <open+0x70>

008017e5 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017e5:	f3 0f 1e fb          	endbr32 
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
  8017ec:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f4:	b8 08 00 00 00       	mov    $0x8,%eax
  8017f9:	e8 87 fd ff ff       	call   801585 <fsipc>
}
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    

00801800 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801800:	f3 0f 1e fb          	endbr32 
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
  801807:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80180a:	68 83 2a 80 00       	push   $0x802a83
  80180f:	ff 75 0c             	pushl  0xc(%ebp)
  801812:	e8 ff ef ff ff       	call   800816 <strcpy>
	return 0;
}
  801817:	b8 00 00 00 00       	mov    $0x0,%eax
  80181c:	c9                   	leave  
  80181d:	c3                   	ret    

0080181e <devsock_close>:
{
  80181e:	f3 0f 1e fb          	endbr32 
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
  801825:	53                   	push   %ebx
  801826:	83 ec 10             	sub    $0x10,%esp
  801829:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80182c:	53                   	push   %ebx
  80182d:	e8 9b 0a 00 00       	call   8022cd <pageref>
  801832:	89 c2                	mov    %eax,%edx
  801834:	83 c4 10             	add    $0x10,%esp
		return 0;
  801837:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  80183c:	83 fa 01             	cmp    $0x1,%edx
  80183f:	74 05                	je     801846 <devsock_close+0x28>
}
  801841:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801844:	c9                   	leave  
  801845:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801846:	83 ec 0c             	sub    $0xc,%esp
  801849:	ff 73 0c             	pushl  0xc(%ebx)
  80184c:	e8 e3 02 00 00       	call   801b34 <nsipc_close>
  801851:	83 c4 10             	add    $0x10,%esp
  801854:	eb eb                	jmp    801841 <devsock_close+0x23>

00801856 <devsock_write>:
{
  801856:	f3 0f 1e fb          	endbr32 
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
  80185d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801860:	6a 00                	push   $0x0
  801862:	ff 75 10             	pushl  0x10(%ebp)
  801865:	ff 75 0c             	pushl  0xc(%ebp)
  801868:	8b 45 08             	mov    0x8(%ebp),%eax
  80186b:	ff 70 0c             	pushl  0xc(%eax)
  80186e:	e8 b5 03 00 00       	call   801c28 <nsipc_send>
}
  801873:	c9                   	leave  
  801874:	c3                   	ret    

00801875 <devsock_read>:
{
  801875:	f3 0f 1e fb          	endbr32 
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
  80187c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80187f:	6a 00                	push   $0x0
  801881:	ff 75 10             	pushl  0x10(%ebp)
  801884:	ff 75 0c             	pushl  0xc(%ebp)
  801887:	8b 45 08             	mov    0x8(%ebp),%eax
  80188a:	ff 70 0c             	pushl  0xc(%eax)
  80188d:	e8 1f 03 00 00       	call   801bb1 <nsipc_recv>
}
  801892:	c9                   	leave  
  801893:	c3                   	ret    

00801894 <fd2sockid>:
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
  801897:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80189a:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80189d:	52                   	push   %edx
  80189e:	50                   	push   %eax
  80189f:	e8 92 f7 ff ff       	call   801036 <fd_lookup>
  8018a4:	83 c4 10             	add    $0x10,%esp
  8018a7:	85 c0                	test   %eax,%eax
  8018a9:	78 10                	js     8018bb <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8018ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ae:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8018b4:	39 08                	cmp    %ecx,(%eax)
  8018b6:	75 05                	jne    8018bd <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8018b8:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8018bb:	c9                   	leave  
  8018bc:	c3                   	ret    
		return -E_NOT_SUPP;
  8018bd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018c2:	eb f7                	jmp    8018bb <fd2sockid+0x27>

008018c4 <alloc_sockfd>:
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
  8018c7:	56                   	push   %esi
  8018c8:	53                   	push   %ebx
  8018c9:	83 ec 1c             	sub    $0x1c,%esp
  8018cc:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8018ce:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018d1:	50                   	push   %eax
  8018d2:	e8 09 f7 ff ff       	call   800fe0 <fd_alloc>
  8018d7:	89 c3                	mov    %eax,%ebx
  8018d9:	83 c4 10             	add    $0x10,%esp
  8018dc:	85 c0                	test   %eax,%eax
  8018de:	78 43                	js     801923 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8018e0:	83 ec 04             	sub    $0x4,%esp
  8018e3:	68 07 04 00 00       	push   $0x407
  8018e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8018eb:	6a 00                	push   $0x0
  8018ed:	e8 66 f3 ff ff       	call   800c58 <sys_page_alloc>
  8018f2:	89 c3                	mov    %eax,%ebx
  8018f4:	83 c4 10             	add    $0x10,%esp
  8018f7:	85 c0                	test   %eax,%eax
  8018f9:	78 28                	js     801923 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8018fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018fe:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801904:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801906:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801909:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801910:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801913:	83 ec 0c             	sub    $0xc,%esp
  801916:	50                   	push   %eax
  801917:	e8 95 f6 ff ff       	call   800fb1 <fd2num>
  80191c:	89 c3                	mov    %eax,%ebx
  80191e:	83 c4 10             	add    $0x10,%esp
  801921:	eb 0c                	jmp    80192f <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801923:	83 ec 0c             	sub    $0xc,%esp
  801926:	56                   	push   %esi
  801927:	e8 08 02 00 00       	call   801b34 <nsipc_close>
		return r;
  80192c:	83 c4 10             	add    $0x10,%esp
}
  80192f:	89 d8                	mov    %ebx,%eax
  801931:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801934:	5b                   	pop    %ebx
  801935:	5e                   	pop    %esi
  801936:	5d                   	pop    %ebp
  801937:	c3                   	ret    

00801938 <accept>:
{
  801938:	f3 0f 1e fb          	endbr32 
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
  80193f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801942:	8b 45 08             	mov    0x8(%ebp),%eax
  801945:	e8 4a ff ff ff       	call   801894 <fd2sockid>
  80194a:	85 c0                	test   %eax,%eax
  80194c:	78 1b                	js     801969 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80194e:	83 ec 04             	sub    $0x4,%esp
  801951:	ff 75 10             	pushl  0x10(%ebp)
  801954:	ff 75 0c             	pushl  0xc(%ebp)
  801957:	50                   	push   %eax
  801958:	e8 22 01 00 00       	call   801a7f <nsipc_accept>
  80195d:	83 c4 10             	add    $0x10,%esp
  801960:	85 c0                	test   %eax,%eax
  801962:	78 05                	js     801969 <accept+0x31>
	return alloc_sockfd(r);
  801964:	e8 5b ff ff ff       	call   8018c4 <alloc_sockfd>
}
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <bind>:
{
  80196b:	f3 0f 1e fb          	endbr32 
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
  801972:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801975:	8b 45 08             	mov    0x8(%ebp),%eax
  801978:	e8 17 ff ff ff       	call   801894 <fd2sockid>
  80197d:	85 c0                	test   %eax,%eax
  80197f:	78 12                	js     801993 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801981:	83 ec 04             	sub    $0x4,%esp
  801984:	ff 75 10             	pushl  0x10(%ebp)
  801987:	ff 75 0c             	pushl  0xc(%ebp)
  80198a:	50                   	push   %eax
  80198b:	e8 45 01 00 00       	call   801ad5 <nsipc_bind>
  801990:	83 c4 10             	add    $0x10,%esp
}
  801993:	c9                   	leave  
  801994:	c3                   	ret    

00801995 <shutdown>:
{
  801995:	f3 0f 1e fb          	endbr32 
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
  80199c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80199f:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a2:	e8 ed fe ff ff       	call   801894 <fd2sockid>
  8019a7:	85 c0                	test   %eax,%eax
  8019a9:	78 0f                	js     8019ba <shutdown+0x25>
	return nsipc_shutdown(r, how);
  8019ab:	83 ec 08             	sub    $0x8,%esp
  8019ae:	ff 75 0c             	pushl  0xc(%ebp)
  8019b1:	50                   	push   %eax
  8019b2:	e8 57 01 00 00       	call   801b0e <nsipc_shutdown>
  8019b7:	83 c4 10             	add    $0x10,%esp
}
  8019ba:	c9                   	leave  
  8019bb:	c3                   	ret    

008019bc <connect>:
{
  8019bc:	f3 0f 1e fb          	endbr32 
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
  8019c3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	e8 c6 fe ff ff       	call   801894 <fd2sockid>
  8019ce:	85 c0                	test   %eax,%eax
  8019d0:	78 12                	js     8019e4 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  8019d2:	83 ec 04             	sub    $0x4,%esp
  8019d5:	ff 75 10             	pushl  0x10(%ebp)
  8019d8:	ff 75 0c             	pushl  0xc(%ebp)
  8019db:	50                   	push   %eax
  8019dc:	e8 71 01 00 00       	call   801b52 <nsipc_connect>
  8019e1:	83 c4 10             	add    $0x10,%esp
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <listen>:
{
  8019e6:	f3 0f 1e fb          	endbr32 
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
  8019ed:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f3:	e8 9c fe ff ff       	call   801894 <fd2sockid>
  8019f8:	85 c0                	test   %eax,%eax
  8019fa:	78 0f                	js     801a0b <listen+0x25>
	return nsipc_listen(r, backlog);
  8019fc:	83 ec 08             	sub    $0x8,%esp
  8019ff:	ff 75 0c             	pushl  0xc(%ebp)
  801a02:	50                   	push   %eax
  801a03:	e8 83 01 00 00       	call   801b8b <nsipc_listen>
  801a08:	83 c4 10             	add    $0x10,%esp
}
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <socket>:

int
socket(int domain, int type, int protocol)
{
  801a0d:	f3 0f 1e fb          	endbr32 
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
  801a14:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a17:	ff 75 10             	pushl  0x10(%ebp)
  801a1a:	ff 75 0c             	pushl  0xc(%ebp)
  801a1d:	ff 75 08             	pushl  0x8(%ebp)
  801a20:	e8 65 02 00 00       	call   801c8a <nsipc_socket>
  801a25:	83 c4 10             	add    $0x10,%esp
  801a28:	85 c0                	test   %eax,%eax
  801a2a:	78 05                	js     801a31 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801a2c:	e8 93 fe ff ff       	call   8018c4 <alloc_sockfd>
}
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    

00801a33 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
  801a36:	53                   	push   %ebx
  801a37:	83 ec 04             	sub    $0x4,%esp
  801a3a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a3c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a43:	74 26                	je     801a6b <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a45:	6a 07                	push   $0x7
  801a47:	68 00 60 80 00       	push   $0x806000
  801a4c:	53                   	push   %ebx
  801a4d:	ff 35 04 40 80 00    	pushl  0x804004
  801a53:	e8 e0 07 00 00       	call   802238 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a58:	83 c4 0c             	add    $0xc,%esp
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	e8 4d 07 00 00       	call   8021b3 <ipc_recv>
}
  801a66:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a69:	c9                   	leave  
  801a6a:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a6b:	83 ec 0c             	sub    $0xc,%esp
  801a6e:	6a 02                	push   $0x2
  801a70:	e8 1b 08 00 00       	call   802290 <ipc_find_env>
  801a75:	a3 04 40 80 00       	mov    %eax,0x804004
  801a7a:	83 c4 10             	add    $0x10,%esp
  801a7d:	eb c6                	jmp    801a45 <nsipc+0x12>

00801a7f <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a7f:	f3 0f 1e fb          	endbr32 
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
  801a86:	56                   	push   %esi
  801a87:	53                   	push   %ebx
  801a88:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a93:	8b 06                	mov    (%esi),%eax
  801a95:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a9a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a9f:	e8 8f ff ff ff       	call   801a33 <nsipc>
  801aa4:	89 c3                	mov    %eax,%ebx
  801aa6:	85 c0                	test   %eax,%eax
  801aa8:	79 09                	jns    801ab3 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801aaa:	89 d8                	mov    %ebx,%eax
  801aac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aaf:	5b                   	pop    %ebx
  801ab0:	5e                   	pop    %esi
  801ab1:	5d                   	pop    %ebp
  801ab2:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ab3:	83 ec 04             	sub    $0x4,%esp
  801ab6:	ff 35 10 60 80 00    	pushl  0x806010
  801abc:	68 00 60 80 00       	push   $0x806000
  801ac1:	ff 75 0c             	pushl  0xc(%ebp)
  801ac4:	e8 03 ef ff ff       	call   8009cc <memmove>
		*addrlen = ret->ret_addrlen;
  801ac9:	a1 10 60 80 00       	mov    0x806010,%eax
  801ace:	89 06                	mov    %eax,(%esi)
  801ad0:	83 c4 10             	add    $0x10,%esp
	return r;
  801ad3:	eb d5                	jmp    801aaa <nsipc_accept+0x2b>

00801ad5 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ad5:	f3 0f 1e fb          	endbr32 
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
  801adc:	53                   	push   %ebx
  801add:	83 ec 08             	sub    $0x8,%esp
  801ae0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae6:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801aeb:	53                   	push   %ebx
  801aec:	ff 75 0c             	pushl  0xc(%ebp)
  801aef:	68 04 60 80 00       	push   $0x806004
  801af4:	e8 d3 ee ff ff       	call   8009cc <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801af9:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801aff:	b8 02 00 00 00       	mov    $0x2,%eax
  801b04:	e8 2a ff ff ff       	call   801a33 <nsipc>
}
  801b09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    

00801b0e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b0e:	f3 0f 1e fb          	endbr32 
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
  801b15:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b18:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b20:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b23:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b28:	b8 03 00 00 00       	mov    $0x3,%eax
  801b2d:	e8 01 ff ff ff       	call   801a33 <nsipc>
}
  801b32:	c9                   	leave  
  801b33:	c3                   	ret    

00801b34 <nsipc_close>:

int
nsipc_close(int s)
{
  801b34:	f3 0f 1e fb          	endbr32 
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
  801b3b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b41:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b46:	b8 04 00 00 00       	mov    $0x4,%eax
  801b4b:	e8 e3 fe ff ff       	call   801a33 <nsipc>
}
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b52:	f3 0f 1e fb          	endbr32 
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
  801b59:	53                   	push   %ebx
  801b5a:	83 ec 08             	sub    $0x8,%esp
  801b5d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b60:	8b 45 08             	mov    0x8(%ebp),%eax
  801b63:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b68:	53                   	push   %ebx
  801b69:	ff 75 0c             	pushl  0xc(%ebp)
  801b6c:	68 04 60 80 00       	push   $0x806004
  801b71:	e8 56 ee ff ff       	call   8009cc <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b76:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b7c:	b8 05 00 00 00       	mov    $0x5,%eax
  801b81:	e8 ad fe ff ff       	call   801a33 <nsipc>
}
  801b86:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b89:	c9                   	leave  
  801b8a:	c3                   	ret    

00801b8b <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b8b:	f3 0f 1e fb          	endbr32 
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
  801b92:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b95:	8b 45 08             	mov    0x8(%ebp),%eax
  801b98:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ba0:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801ba5:	b8 06 00 00 00       	mov    $0x6,%eax
  801baa:	e8 84 fe ff ff       	call   801a33 <nsipc>
}
  801baf:	c9                   	leave  
  801bb0:	c3                   	ret    

00801bb1 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801bb1:	f3 0f 1e fb          	endbr32 
  801bb5:	55                   	push   %ebp
  801bb6:	89 e5                	mov    %esp,%ebp
  801bb8:	56                   	push   %esi
  801bb9:	53                   	push   %ebx
  801bba:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801bc5:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801bcb:	8b 45 14             	mov    0x14(%ebp),%eax
  801bce:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801bd3:	b8 07 00 00 00       	mov    $0x7,%eax
  801bd8:	e8 56 fe ff ff       	call   801a33 <nsipc>
  801bdd:	89 c3                	mov    %eax,%ebx
  801bdf:	85 c0                	test   %eax,%eax
  801be1:	78 26                	js     801c09 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801be3:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801be9:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801bee:	0f 4e c6             	cmovle %esi,%eax
  801bf1:	39 c3                	cmp    %eax,%ebx
  801bf3:	7f 1d                	jg     801c12 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801bf5:	83 ec 04             	sub    $0x4,%esp
  801bf8:	53                   	push   %ebx
  801bf9:	68 00 60 80 00       	push   $0x806000
  801bfe:	ff 75 0c             	pushl  0xc(%ebp)
  801c01:	e8 c6 ed ff ff       	call   8009cc <memmove>
  801c06:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c09:	89 d8                	mov    %ebx,%eax
  801c0b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c0e:	5b                   	pop    %ebx
  801c0f:	5e                   	pop    %esi
  801c10:	5d                   	pop    %ebp
  801c11:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c12:	68 8f 2a 80 00       	push   $0x802a8f
  801c17:	68 57 2a 80 00       	push   $0x802a57
  801c1c:	6a 62                	push   $0x62
  801c1e:	68 a4 2a 80 00       	push   $0x802aa4
  801c23:	e8 fd e4 ff ff       	call   800125 <_panic>

00801c28 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c28:	f3 0f 1e fb          	endbr32 
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
  801c2f:	53                   	push   %ebx
  801c30:	83 ec 04             	sub    $0x4,%esp
  801c33:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c36:	8b 45 08             	mov    0x8(%ebp),%eax
  801c39:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c3e:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c44:	7f 2e                	jg     801c74 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c46:	83 ec 04             	sub    $0x4,%esp
  801c49:	53                   	push   %ebx
  801c4a:	ff 75 0c             	pushl  0xc(%ebp)
  801c4d:	68 0c 60 80 00       	push   $0x80600c
  801c52:	e8 75 ed ff ff       	call   8009cc <memmove>
	nsipcbuf.send.req_size = size;
  801c57:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c5d:	8b 45 14             	mov    0x14(%ebp),%eax
  801c60:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c65:	b8 08 00 00 00       	mov    $0x8,%eax
  801c6a:	e8 c4 fd ff ff       	call   801a33 <nsipc>
}
  801c6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c72:	c9                   	leave  
  801c73:	c3                   	ret    
	assert(size < 1600);
  801c74:	68 b0 2a 80 00       	push   $0x802ab0
  801c79:	68 57 2a 80 00       	push   $0x802a57
  801c7e:	6a 6d                	push   $0x6d
  801c80:	68 a4 2a 80 00       	push   $0x802aa4
  801c85:	e8 9b e4 ff ff       	call   800125 <_panic>

00801c8a <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c8a:	f3 0f 1e fb          	endbr32 
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
  801c91:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c94:	8b 45 08             	mov    0x8(%ebp),%eax
  801c97:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c9f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801ca4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ca7:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801cac:	b8 09 00 00 00       	mov    $0x9,%eax
  801cb1:	e8 7d fd ff ff       	call   801a33 <nsipc>
}
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801cb8:	f3 0f 1e fb          	endbr32 
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
  801cbf:	56                   	push   %esi
  801cc0:	53                   	push   %ebx
  801cc1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cc4:	83 ec 0c             	sub    $0xc,%esp
  801cc7:	ff 75 08             	pushl  0x8(%ebp)
  801cca:	e8 f6 f2 ff ff       	call   800fc5 <fd2data>
  801ccf:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801cd1:	83 c4 08             	add    $0x8,%esp
  801cd4:	68 bc 2a 80 00       	push   $0x802abc
  801cd9:	53                   	push   %ebx
  801cda:	e8 37 eb ff ff       	call   800816 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cdf:	8b 46 04             	mov    0x4(%esi),%eax
  801ce2:	2b 06                	sub    (%esi),%eax
  801ce4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801cea:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cf1:	00 00 00 
	stat->st_dev = &devpipe;
  801cf4:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801cfb:	30 80 00 
	return 0;
}
  801cfe:	b8 00 00 00 00       	mov    $0x0,%eax
  801d03:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d06:	5b                   	pop    %ebx
  801d07:	5e                   	pop    %esi
  801d08:	5d                   	pop    %ebp
  801d09:	c3                   	ret    

00801d0a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d0a:	f3 0f 1e fb          	endbr32 
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
  801d11:	53                   	push   %ebx
  801d12:	83 ec 0c             	sub    $0xc,%esp
  801d15:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d18:	53                   	push   %ebx
  801d19:	6a 00                	push   $0x0
  801d1b:	e8 c5 ef ff ff       	call   800ce5 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d20:	89 1c 24             	mov    %ebx,(%esp)
  801d23:	e8 9d f2 ff ff       	call   800fc5 <fd2data>
  801d28:	83 c4 08             	add    $0x8,%esp
  801d2b:	50                   	push   %eax
  801d2c:	6a 00                	push   $0x0
  801d2e:	e8 b2 ef ff ff       	call   800ce5 <sys_page_unmap>
}
  801d33:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d36:	c9                   	leave  
  801d37:	c3                   	ret    

00801d38 <_pipeisclosed>:
{
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
  801d3b:	57                   	push   %edi
  801d3c:	56                   	push   %esi
  801d3d:	53                   	push   %ebx
  801d3e:	83 ec 1c             	sub    $0x1c,%esp
  801d41:	89 c7                	mov    %eax,%edi
  801d43:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d45:	a1 08 40 80 00       	mov    0x804008,%eax
  801d4a:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d4d:	83 ec 0c             	sub    $0xc,%esp
  801d50:	57                   	push   %edi
  801d51:	e8 77 05 00 00       	call   8022cd <pageref>
  801d56:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d59:	89 34 24             	mov    %esi,(%esp)
  801d5c:	e8 6c 05 00 00       	call   8022cd <pageref>
		nn = thisenv->env_runs;
  801d61:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d67:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d6a:	83 c4 10             	add    $0x10,%esp
  801d6d:	39 cb                	cmp    %ecx,%ebx
  801d6f:	74 1b                	je     801d8c <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d71:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d74:	75 cf                	jne    801d45 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d76:	8b 42 58             	mov    0x58(%edx),%eax
  801d79:	6a 01                	push   $0x1
  801d7b:	50                   	push   %eax
  801d7c:	53                   	push   %ebx
  801d7d:	68 c3 2a 80 00       	push   $0x802ac3
  801d82:	e8 85 e4 ff ff       	call   80020c <cprintf>
  801d87:	83 c4 10             	add    $0x10,%esp
  801d8a:	eb b9                	jmp    801d45 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d8c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d8f:	0f 94 c0             	sete   %al
  801d92:	0f b6 c0             	movzbl %al,%eax
}
  801d95:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d98:	5b                   	pop    %ebx
  801d99:	5e                   	pop    %esi
  801d9a:	5f                   	pop    %edi
  801d9b:	5d                   	pop    %ebp
  801d9c:	c3                   	ret    

00801d9d <devpipe_write>:
{
  801d9d:	f3 0f 1e fb          	endbr32 
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
  801da4:	57                   	push   %edi
  801da5:	56                   	push   %esi
  801da6:	53                   	push   %ebx
  801da7:	83 ec 28             	sub    $0x28,%esp
  801daa:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801dad:	56                   	push   %esi
  801dae:	e8 12 f2 ff ff       	call   800fc5 <fd2data>
  801db3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801db5:	83 c4 10             	add    $0x10,%esp
  801db8:	bf 00 00 00 00       	mov    $0x0,%edi
  801dbd:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801dc0:	74 4f                	je     801e11 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801dc2:	8b 43 04             	mov    0x4(%ebx),%eax
  801dc5:	8b 0b                	mov    (%ebx),%ecx
  801dc7:	8d 51 20             	lea    0x20(%ecx),%edx
  801dca:	39 d0                	cmp    %edx,%eax
  801dcc:	72 14                	jb     801de2 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801dce:	89 da                	mov    %ebx,%edx
  801dd0:	89 f0                	mov    %esi,%eax
  801dd2:	e8 61 ff ff ff       	call   801d38 <_pipeisclosed>
  801dd7:	85 c0                	test   %eax,%eax
  801dd9:	75 3b                	jne    801e16 <devpipe_write+0x79>
			sys_yield();
  801ddb:	e8 55 ee ff ff       	call   800c35 <sys_yield>
  801de0:	eb e0                	jmp    801dc2 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801de2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801de5:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801de9:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801dec:	89 c2                	mov    %eax,%edx
  801dee:	c1 fa 1f             	sar    $0x1f,%edx
  801df1:	89 d1                	mov    %edx,%ecx
  801df3:	c1 e9 1b             	shr    $0x1b,%ecx
  801df6:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801df9:	83 e2 1f             	and    $0x1f,%edx
  801dfc:	29 ca                	sub    %ecx,%edx
  801dfe:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e02:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e06:	83 c0 01             	add    $0x1,%eax
  801e09:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e0c:	83 c7 01             	add    $0x1,%edi
  801e0f:	eb ac                	jmp    801dbd <devpipe_write+0x20>
	return i;
  801e11:	8b 45 10             	mov    0x10(%ebp),%eax
  801e14:	eb 05                	jmp    801e1b <devpipe_write+0x7e>
				return 0;
  801e16:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e1e:	5b                   	pop    %ebx
  801e1f:	5e                   	pop    %esi
  801e20:	5f                   	pop    %edi
  801e21:	5d                   	pop    %ebp
  801e22:	c3                   	ret    

00801e23 <devpipe_read>:
{
  801e23:	f3 0f 1e fb          	endbr32 
  801e27:	55                   	push   %ebp
  801e28:	89 e5                	mov    %esp,%ebp
  801e2a:	57                   	push   %edi
  801e2b:	56                   	push   %esi
  801e2c:	53                   	push   %ebx
  801e2d:	83 ec 18             	sub    $0x18,%esp
  801e30:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e33:	57                   	push   %edi
  801e34:	e8 8c f1 ff ff       	call   800fc5 <fd2data>
  801e39:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e3b:	83 c4 10             	add    $0x10,%esp
  801e3e:	be 00 00 00 00       	mov    $0x0,%esi
  801e43:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e46:	75 14                	jne    801e5c <devpipe_read+0x39>
	return i;
  801e48:	8b 45 10             	mov    0x10(%ebp),%eax
  801e4b:	eb 02                	jmp    801e4f <devpipe_read+0x2c>
				return i;
  801e4d:	89 f0                	mov    %esi,%eax
}
  801e4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e52:	5b                   	pop    %ebx
  801e53:	5e                   	pop    %esi
  801e54:	5f                   	pop    %edi
  801e55:	5d                   	pop    %ebp
  801e56:	c3                   	ret    
			sys_yield();
  801e57:	e8 d9 ed ff ff       	call   800c35 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e5c:	8b 03                	mov    (%ebx),%eax
  801e5e:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e61:	75 18                	jne    801e7b <devpipe_read+0x58>
			if (i > 0)
  801e63:	85 f6                	test   %esi,%esi
  801e65:	75 e6                	jne    801e4d <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801e67:	89 da                	mov    %ebx,%edx
  801e69:	89 f8                	mov    %edi,%eax
  801e6b:	e8 c8 fe ff ff       	call   801d38 <_pipeisclosed>
  801e70:	85 c0                	test   %eax,%eax
  801e72:	74 e3                	je     801e57 <devpipe_read+0x34>
				return 0;
  801e74:	b8 00 00 00 00       	mov    $0x0,%eax
  801e79:	eb d4                	jmp    801e4f <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e7b:	99                   	cltd   
  801e7c:	c1 ea 1b             	shr    $0x1b,%edx
  801e7f:	01 d0                	add    %edx,%eax
  801e81:	83 e0 1f             	and    $0x1f,%eax
  801e84:	29 d0                	sub    %edx,%eax
  801e86:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e8e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e91:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e94:	83 c6 01             	add    $0x1,%esi
  801e97:	eb aa                	jmp    801e43 <devpipe_read+0x20>

00801e99 <pipe>:
{
  801e99:	f3 0f 1e fb          	endbr32 
  801e9d:	55                   	push   %ebp
  801e9e:	89 e5                	mov    %esp,%ebp
  801ea0:	56                   	push   %esi
  801ea1:	53                   	push   %ebx
  801ea2:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ea5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ea8:	50                   	push   %eax
  801ea9:	e8 32 f1 ff ff       	call   800fe0 <fd_alloc>
  801eae:	89 c3                	mov    %eax,%ebx
  801eb0:	83 c4 10             	add    $0x10,%esp
  801eb3:	85 c0                	test   %eax,%eax
  801eb5:	0f 88 23 01 00 00    	js     801fde <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ebb:	83 ec 04             	sub    $0x4,%esp
  801ebe:	68 07 04 00 00       	push   $0x407
  801ec3:	ff 75 f4             	pushl  -0xc(%ebp)
  801ec6:	6a 00                	push   $0x0
  801ec8:	e8 8b ed ff ff       	call   800c58 <sys_page_alloc>
  801ecd:	89 c3                	mov    %eax,%ebx
  801ecf:	83 c4 10             	add    $0x10,%esp
  801ed2:	85 c0                	test   %eax,%eax
  801ed4:	0f 88 04 01 00 00    	js     801fde <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801eda:	83 ec 0c             	sub    $0xc,%esp
  801edd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ee0:	50                   	push   %eax
  801ee1:	e8 fa f0 ff ff       	call   800fe0 <fd_alloc>
  801ee6:	89 c3                	mov    %eax,%ebx
  801ee8:	83 c4 10             	add    $0x10,%esp
  801eeb:	85 c0                	test   %eax,%eax
  801eed:	0f 88 db 00 00 00    	js     801fce <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ef3:	83 ec 04             	sub    $0x4,%esp
  801ef6:	68 07 04 00 00       	push   $0x407
  801efb:	ff 75 f0             	pushl  -0x10(%ebp)
  801efe:	6a 00                	push   $0x0
  801f00:	e8 53 ed ff ff       	call   800c58 <sys_page_alloc>
  801f05:	89 c3                	mov    %eax,%ebx
  801f07:	83 c4 10             	add    $0x10,%esp
  801f0a:	85 c0                	test   %eax,%eax
  801f0c:	0f 88 bc 00 00 00    	js     801fce <pipe+0x135>
	va = fd2data(fd0);
  801f12:	83 ec 0c             	sub    $0xc,%esp
  801f15:	ff 75 f4             	pushl  -0xc(%ebp)
  801f18:	e8 a8 f0 ff ff       	call   800fc5 <fd2data>
  801f1d:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f1f:	83 c4 0c             	add    $0xc,%esp
  801f22:	68 07 04 00 00       	push   $0x407
  801f27:	50                   	push   %eax
  801f28:	6a 00                	push   $0x0
  801f2a:	e8 29 ed ff ff       	call   800c58 <sys_page_alloc>
  801f2f:	89 c3                	mov    %eax,%ebx
  801f31:	83 c4 10             	add    $0x10,%esp
  801f34:	85 c0                	test   %eax,%eax
  801f36:	0f 88 82 00 00 00    	js     801fbe <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f3c:	83 ec 0c             	sub    $0xc,%esp
  801f3f:	ff 75 f0             	pushl  -0x10(%ebp)
  801f42:	e8 7e f0 ff ff       	call   800fc5 <fd2data>
  801f47:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f4e:	50                   	push   %eax
  801f4f:	6a 00                	push   $0x0
  801f51:	56                   	push   %esi
  801f52:	6a 00                	push   $0x0
  801f54:	e8 46 ed ff ff       	call   800c9f <sys_page_map>
  801f59:	89 c3                	mov    %eax,%ebx
  801f5b:	83 c4 20             	add    $0x20,%esp
  801f5e:	85 c0                	test   %eax,%eax
  801f60:	78 4e                	js     801fb0 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801f62:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f6a:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f6f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f76:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f79:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f7e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f85:	83 ec 0c             	sub    $0xc,%esp
  801f88:	ff 75 f4             	pushl  -0xc(%ebp)
  801f8b:	e8 21 f0 ff ff       	call   800fb1 <fd2num>
  801f90:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f93:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f95:	83 c4 04             	add    $0x4,%esp
  801f98:	ff 75 f0             	pushl  -0x10(%ebp)
  801f9b:	e8 11 f0 ff ff       	call   800fb1 <fd2num>
  801fa0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fa3:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801fa6:	83 c4 10             	add    $0x10,%esp
  801fa9:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fae:	eb 2e                	jmp    801fde <pipe+0x145>
	sys_page_unmap(0, va);
  801fb0:	83 ec 08             	sub    $0x8,%esp
  801fb3:	56                   	push   %esi
  801fb4:	6a 00                	push   $0x0
  801fb6:	e8 2a ed ff ff       	call   800ce5 <sys_page_unmap>
  801fbb:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801fbe:	83 ec 08             	sub    $0x8,%esp
  801fc1:	ff 75 f0             	pushl  -0x10(%ebp)
  801fc4:	6a 00                	push   $0x0
  801fc6:	e8 1a ed ff ff       	call   800ce5 <sys_page_unmap>
  801fcb:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801fce:	83 ec 08             	sub    $0x8,%esp
  801fd1:	ff 75 f4             	pushl  -0xc(%ebp)
  801fd4:	6a 00                	push   $0x0
  801fd6:	e8 0a ed ff ff       	call   800ce5 <sys_page_unmap>
  801fdb:	83 c4 10             	add    $0x10,%esp
}
  801fde:	89 d8                	mov    %ebx,%eax
  801fe0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fe3:	5b                   	pop    %ebx
  801fe4:	5e                   	pop    %esi
  801fe5:	5d                   	pop    %ebp
  801fe6:	c3                   	ret    

00801fe7 <pipeisclosed>:
{
  801fe7:	f3 0f 1e fb          	endbr32 
  801feb:	55                   	push   %ebp
  801fec:	89 e5                	mov    %esp,%ebp
  801fee:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ff1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ff4:	50                   	push   %eax
  801ff5:	ff 75 08             	pushl  0x8(%ebp)
  801ff8:	e8 39 f0 ff ff       	call   801036 <fd_lookup>
  801ffd:	83 c4 10             	add    $0x10,%esp
  802000:	85 c0                	test   %eax,%eax
  802002:	78 18                	js     80201c <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802004:	83 ec 0c             	sub    $0xc,%esp
  802007:	ff 75 f4             	pushl  -0xc(%ebp)
  80200a:	e8 b6 ef ff ff       	call   800fc5 <fd2data>
  80200f:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802014:	e8 1f fd ff ff       	call   801d38 <_pipeisclosed>
  802019:	83 c4 10             	add    $0x10,%esp
}
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    

0080201e <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80201e:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  802022:	b8 00 00 00 00       	mov    $0x0,%eax
  802027:	c3                   	ret    

00802028 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802028:	f3 0f 1e fb          	endbr32 
  80202c:	55                   	push   %ebp
  80202d:	89 e5                	mov    %esp,%ebp
  80202f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802032:	68 db 2a 80 00       	push   $0x802adb
  802037:	ff 75 0c             	pushl  0xc(%ebp)
  80203a:	e8 d7 e7 ff ff       	call   800816 <strcpy>
	return 0;
}
  80203f:	b8 00 00 00 00       	mov    $0x0,%eax
  802044:	c9                   	leave  
  802045:	c3                   	ret    

00802046 <devcons_write>:
{
  802046:	f3 0f 1e fb          	endbr32 
  80204a:	55                   	push   %ebp
  80204b:	89 e5                	mov    %esp,%ebp
  80204d:	57                   	push   %edi
  80204e:	56                   	push   %esi
  80204f:	53                   	push   %ebx
  802050:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802056:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80205b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802061:	3b 75 10             	cmp    0x10(%ebp),%esi
  802064:	73 31                	jae    802097 <devcons_write+0x51>
		m = n - tot;
  802066:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802069:	29 f3                	sub    %esi,%ebx
  80206b:	83 fb 7f             	cmp    $0x7f,%ebx
  80206e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802073:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802076:	83 ec 04             	sub    $0x4,%esp
  802079:	53                   	push   %ebx
  80207a:	89 f0                	mov    %esi,%eax
  80207c:	03 45 0c             	add    0xc(%ebp),%eax
  80207f:	50                   	push   %eax
  802080:	57                   	push   %edi
  802081:	e8 46 e9 ff ff       	call   8009cc <memmove>
		sys_cputs(buf, m);
  802086:	83 c4 08             	add    $0x8,%esp
  802089:	53                   	push   %ebx
  80208a:	57                   	push   %edi
  80208b:	e8 f8 ea ff ff       	call   800b88 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802090:	01 de                	add    %ebx,%esi
  802092:	83 c4 10             	add    $0x10,%esp
  802095:	eb ca                	jmp    802061 <devcons_write+0x1b>
}
  802097:	89 f0                	mov    %esi,%eax
  802099:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80209c:	5b                   	pop    %ebx
  80209d:	5e                   	pop    %esi
  80209e:	5f                   	pop    %edi
  80209f:	5d                   	pop    %ebp
  8020a0:	c3                   	ret    

008020a1 <devcons_read>:
{
  8020a1:	f3 0f 1e fb          	endbr32 
  8020a5:	55                   	push   %ebp
  8020a6:	89 e5                	mov    %esp,%ebp
  8020a8:	83 ec 08             	sub    $0x8,%esp
  8020ab:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8020b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020b4:	74 21                	je     8020d7 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8020b6:	e8 ef ea ff ff       	call   800baa <sys_cgetc>
  8020bb:	85 c0                	test   %eax,%eax
  8020bd:	75 07                	jne    8020c6 <devcons_read+0x25>
		sys_yield();
  8020bf:	e8 71 eb ff ff       	call   800c35 <sys_yield>
  8020c4:	eb f0                	jmp    8020b6 <devcons_read+0x15>
	if (c < 0)
  8020c6:	78 0f                	js     8020d7 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8020c8:	83 f8 04             	cmp    $0x4,%eax
  8020cb:	74 0c                	je     8020d9 <devcons_read+0x38>
	*(char*)vbuf = c;
  8020cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d0:	88 02                	mov    %al,(%edx)
	return 1;
  8020d2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020d7:	c9                   	leave  
  8020d8:	c3                   	ret    
		return 0;
  8020d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020de:	eb f7                	jmp    8020d7 <devcons_read+0x36>

008020e0 <cputchar>:
{
  8020e0:	f3 0f 1e fb          	endbr32 
  8020e4:	55                   	push   %ebp
  8020e5:	89 e5                	mov    %esp,%ebp
  8020e7:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ed:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020f0:	6a 01                	push   $0x1
  8020f2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020f5:	50                   	push   %eax
  8020f6:	e8 8d ea ff ff       	call   800b88 <sys_cputs>
}
  8020fb:	83 c4 10             	add    $0x10,%esp
  8020fe:	c9                   	leave  
  8020ff:	c3                   	ret    

00802100 <getchar>:
{
  802100:	f3 0f 1e fb          	endbr32 
  802104:	55                   	push   %ebp
  802105:	89 e5                	mov    %esp,%ebp
  802107:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80210a:	6a 01                	push   $0x1
  80210c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80210f:	50                   	push   %eax
  802110:	6a 00                	push   $0x0
  802112:	e8 a7 f1 ff ff       	call   8012be <read>
	if (r < 0)
  802117:	83 c4 10             	add    $0x10,%esp
  80211a:	85 c0                	test   %eax,%eax
  80211c:	78 06                	js     802124 <getchar+0x24>
	if (r < 1)
  80211e:	74 06                	je     802126 <getchar+0x26>
	return c;
  802120:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802124:	c9                   	leave  
  802125:	c3                   	ret    
		return -E_EOF;
  802126:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80212b:	eb f7                	jmp    802124 <getchar+0x24>

0080212d <iscons>:
{
  80212d:	f3 0f 1e fb          	endbr32 
  802131:	55                   	push   %ebp
  802132:	89 e5                	mov    %esp,%ebp
  802134:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802137:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80213a:	50                   	push   %eax
  80213b:	ff 75 08             	pushl  0x8(%ebp)
  80213e:	e8 f3 ee ff ff       	call   801036 <fd_lookup>
  802143:	83 c4 10             	add    $0x10,%esp
  802146:	85 c0                	test   %eax,%eax
  802148:	78 11                	js     80215b <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80214a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214d:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802153:	39 10                	cmp    %edx,(%eax)
  802155:	0f 94 c0             	sete   %al
  802158:	0f b6 c0             	movzbl %al,%eax
}
  80215b:	c9                   	leave  
  80215c:	c3                   	ret    

0080215d <opencons>:
{
  80215d:	f3 0f 1e fb          	endbr32 
  802161:	55                   	push   %ebp
  802162:	89 e5                	mov    %esp,%ebp
  802164:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802167:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80216a:	50                   	push   %eax
  80216b:	e8 70 ee ff ff       	call   800fe0 <fd_alloc>
  802170:	83 c4 10             	add    $0x10,%esp
  802173:	85 c0                	test   %eax,%eax
  802175:	78 3a                	js     8021b1 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802177:	83 ec 04             	sub    $0x4,%esp
  80217a:	68 07 04 00 00       	push   $0x407
  80217f:	ff 75 f4             	pushl  -0xc(%ebp)
  802182:	6a 00                	push   $0x0
  802184:	e8 cf ea ff ff       	call   800c58 <sys_page_alloc>
  802189:	83 c4 10             	add    $0x10,%esp
  80218c:	85 c0                	test   %eax,%eax
  80218e:	78 21                	js     8021b1 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802190:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802193:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802199:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80219b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8021a5:	83 ec 0c             	sub    $0xc,%esp
  8021a8:	50                   	push   %eax
  8021a9:	e8 03 ee ff ff       	call   800fb1 <fd2num>
  8021ae:	83 c4 10             	add    $0x10,%esp
}
  8021b1:	c9                   	leave  
  8021b2:	c3                   	ret    

008021b3 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021b3:	f3 0f 1e fb          	endbr32 
  8021b7:	55                   	push   %ebp
  8021b8:	89 e5                	mov    %esp,%ebp
  8021ba:	56                   	push   %esi
  8021bb:	53                   	push   %ebx
  8021bc:	8b 75 08             	mov    0x8(%ebp),%esi
  8021bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  8021c5:	85 c0                	test   %eax,%eax
  8021c7:	74 3d                	je     802206 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  8021c9:	83 ec 0c             	sub    $0xc,%esp
  8021cc:	50                   	push   %eax
  8021cd:	e8 52 ec ff ff       	call   800e24 <sys_ipc_recv>
  8021d2:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  8021d5:	85 f6                	test   %esi,%esi
  8021d7:	74 0b                	je     8021e4 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8021d9:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8021df:	8b 52 74             	mov    0x74(%edx),%edx
  8021e2:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  8021e4:	85 db                	test   %ebx,%ebx
  8021e6:	74 0b                	je     8021f3 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  8021e8:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8021ee:	8b 52 78             	mov    0x78(%edx),%edx
  8021f1:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  8021f3:	85 c0                	test   %eax,%eax
  8021f5:	78 21                	js     802218 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  8021f7:	a1 08 40 80 00       	mov    0x804008,%eax
  8021fc:	8b 40 70             	mov    0x70(%eax),%eax
}
  8021ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802202:	5b                   	pop    %ebx
  802203:	5e                   	pop    %esi
  802204:	5d                   	pop    %ebp
  802205:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  802206:	83 ec 0c             	sub    $0xc,%esp
  802209:	68 00 00 c0 ee       	push   $0xeec00000
  80220e:	e8 11 ec ff ff       	call   800e24 <sys_ipc_recv>
  802213:	83 c4 10             	add    $0x10,%esp
  802216:	eb bd                	jmp    8021d5 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  802218:	85 f6                	test   %esi,%esi
  80221a:	74 10                	je     80222c <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  80221c:	85 db                	test   %ebx,%ebx
  80221e:	75 df                	jne    8021ff <ipc_recv+0x4c>
  802220:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802227:	00 00 00 
  80222a:	eb d3                	jmp    8021ff <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  80222c:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802233:	00 00 00 
  802236:	eb e4                	jmp    80221c <ipc_recv+0x69>

00802238 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802238:	f3 0f 1e fb          	endbr32 
  80223c:	55                   	push   %ebp
  80223d:	89 e5                	mov    %esp,%ebp
  80223f:	57                   	push   %edi
  802240:	56                   	push   %esi
  802241:	53                   	push   %ebx
  802242:	83 ec 0c             	sub    $0xc,%esp
  802245:	8b 7d 08             	mov    0x8(%ebp),%edi
  802248:	8b 75 0c             	mov    0xc(%ebp),%esi
  80224b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  80224e:	85 db                	test   %ebx,%ebx
  802250:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802255:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  802258:	ff 75 14             	pushl  0x14(%ebp)
  80225b:	53                   	push   %ebx
  80225c:	56                   	push   %esi
  80225d:	57                   	push   %edi
  80225e:	e8 9a eb ff ff       	call   800dfd <sys_ipc_try_send>
  802263:	83 c4 10             	add    $0x10,%esp
  802266:	85 c0                	test   %eax,%eax
  802268:	79 1e                	jns    802288 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  80226a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80226d:	75 07                	jne    802276 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  80226f:	e8 c1 e9 ff ff       	call   800c35 <sys_yield>
  802274:	eb e2                	jmp    802258 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  802276:	50                   	push   %eax
  802277:	68 e7 2a 80 00       	push   $0x802ae7
  80227c:	6a 59                	push   $0x59
  80227e:	68 02 2b 80 00       	push   $0x802b02
  802283:	e8 9d de ff ff       	call   800125 <_panic>
	}
}
  802288:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80228b:	5b                   	pop    %ebx
  80228c:	5e                   	pop    %esi
  80228d:	5f                   	pop    %edi
  80228e:	5d                   	pop    %ebp
  80228f:	c3                   	ret    

00802290 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802290:	f3 0f 1e fb          	endbr32 
  802294:	55                   	push   %ebp
  802295:	89 e5                	mov    %esp,%ebp
  802297:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80229a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80229f:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8022a2:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022a8:	8b 52 50             	mov    0x50(%edx),%edx
  8022ab:	39 ca                	cmp    %ecx,%edx
  8022ad:	74 11                	je     8022c0 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8022af:	83 c0 01             	add    $0x1,%eax
  8022b2:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022b7:	75 e6                	jne    80229f <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8022b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8022be:	eb 0b                	jmp    8022cb <ipc_find_env+0x3b>
			return envs[i].env_id;
  8022c0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8022c3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022c8:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022cb:	5d                   	pop    %ebp
  8022cc:	c3                   	ret    

008022cd <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022cd:	f3 0f 1e fb          	endbr32 
  8022d1:	55                   	push   %ebp
  8022d2:	89 e5                	mov    %esp,%ebp
  8022d4:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022d7:	89 c2                	mov    %eax,%edx
  8022d9:	c1 ea 16             	shr    $0x16,%edx
  8022dc:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8022e3:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8022e8:	f6 c1 01             	test   $0x1,%cl
  8022eb:	74 1c                	je     802309 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8022ed:	c1 e8 0c             	shr    $0xc,%eax
  8022f0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8022f7:	a8 01                	test   $0x1,%al
  8022f9:	74 0e                	je     802309 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022fb:	c1 e8 0c             	shr    $0xc,%eax
  8022fe:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802305:	ef 
  802306:	0f b7 d2             	movzwl %dx,%edx
}
  802309:	89 d0                	mov    %edx,%eax
  80230b:	5d                   	pop    %ebp
  80230c:	c3                   	ret    
  80230d:	66 90                	xchg   %ax,%ax
  80230f:	90                   	nop

00802310 <__udivdi3>:
  802310:	f3 0f 1e fb          	endbr32 
  802314:	55                   	push   %ebp
  802315:	57                   	push   %edi
  802316:	56                   	push   %esi
  802317:	53                   	push   %ebx
  802318:	83 ec 1c             	sub    $0x1c,%esp
  80231b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80231f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802323:	8b 74 24 34          	mov    0x34(%esp),%esi
  802327:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80232b:	85 d2                	test   %edx,%edx
  80232d:	75 19                	jne    802348 <__udivdi3+0x38>
  80232f:	39 f3                	cmp    %esi,%ebx
  802331:	76 4d                	jbe    802380 <__udivdi3+0x70>
  802333:	31 ff                	xor    %edi,%edi
  802335:	89 e8                	mov    %ebp,%eax
  802337:	89 f2                	mov    %esi,%edx
  802339:	f7 f3                	div    %ebx
  80233b:	89 fa                	mov    %edi,%edx
  80233d:	83 c4 1c             	add    $0x1c,%esp
  802340:	5b                   	pop    %ebx
  802341:	5e                   	pop    %esi
  802342:	5f                   	pop    %edi
  802343:	5d                   	pop    %ebp
  802344:	c3                   	ret    
  802345:	8d 76 00             	lea    0x0(%esi),%esi
  802348:	39 f2                	cmp    %esi,%edx
  80234a:	76 14                	jbe    802360 <__udivdi3+0x50>
  80234c:	31 ff                	xor    %edi,%edi
  80234e:	31 c0                	xor    %eax,%eax
  802350:	89 fa                	mov    %edi,%edx
  802352:	83 c4 1c             	add    $0x1c,%esp
  802355:	5b                   	pop    %ebx
  802356:	5e                   	pop    %esi
  802357:	5f                   	pop    %edi
  802358:	5d                   	pop    %ebp
  802359:	c3                   	ret    
  80235a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802360:	0f bd fa             	bsr    %edx,%edi
  802363:	83 f7 1f             	xor    $0x1f,%edi
  802366:	75 48                	jne    8023b0 <__udivdi3+0xa0>
  802368:	39 f2                	cmp    %esi,%edx
  80236a:	72 06                	jb     802372 <__udivdi3+0x62>
  80236c:	31 c0                	xor    %eax,%eax
  80236e:	39 eb                	cmp    %ebp,%ebx
  802370:	77 de                	ja     802350 <__udivdi3+0x40>
  802372:	b8 01 00 00 00       	mov    $0x1,%eax
  802377:	eb d7                	jmp    802350 <__udivdi3+0x40>
  802379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802380:	89 d9                	mov    %ebx,%ecx
  802382:	85 db                	test   %ebx,%ebx
  802384:	75 0b                	jne    802391 <__udivdi3+0x81>
  802386:	b8 01 00 00 00       	mov    $0x1,%eax
  80238b:	31 d2                	xor    %edx,%edx
  80238d:	f7 f3                	div    %ebx
  80238f:	89 c1                	mov    %eax,%ecx
  802391:	31 d2                	xor    %edx,%edx
  802393:	89 f0                	mov    %esi,%eax
  802395:	f7 f1                	div    %ecx
  802397:	89 c6                	mov    %eax,%esi
  802399:	89 e8                	mov    %ebp,%eax
  80239b:	89 f7                	mov    %esi,%edi
  80239d:	f7 f1                	div    %ecx
  80239f:	89 fa                	mov    %edi,%edx
  8023a1:	83 c4 1c             	add    $0x1c,%esp
  8023a4:	5b                   	pop    %ebx
  8023a5:	5e                   	pop    %esi
  8023a6:	5f                   	pop    %edi
  8023a7:	5d                   	pop    %ebp
  8023a8:	c3                   	ret    
  8023a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023b0:	89 f9                	mov    %edi,%ecx
  8023b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8023b7:	29 f8                	sub    %edi,%eax
  8023b9:	d3 e2                	shl    %cl,%edx
  8023bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023bf:	89 c1                	mov    %eax,%ecx
  8023c1:	89 da                	mov    %ebx,%edx
  8023c3:	d3 ea                	shr    %cl,%edx
  8023c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023c9:	09 d1                	or     %edx,%ecx
  8023cb:	89 f2                	mov    %esi,%edx
  8023cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023d1:	89 f9                	mov    %edi,%ecx
  8023d3:	d3 e3                	shl    %cl,%ebx
  8023d5:	89 c1                	mov    %eax,%ecx
  8023d7:	d3 ea                	shr    %cl,%edx
  8023d9:	89 f9                	mov    %edi,%ecx
  8023db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8023df:	89 eb                	mov    %ebp,%ebx
  8023e1:	d3 e6                	shl    %cl,%esi
  8023e3:	89 c1                	mov    %eax,%ecx
  8023e5:	d3 eb                	shr    %cl,%ebx
  8023e7:	09 de                	or     %ebx,%esi
  8023e9:	89 f0                	mov    %esi,%eax
  8023eb:	f7 74 24 08          	divl   0x8(%esp)
  8023ef:	89 d6                	mov    %edx,%esi
  8023f1:	89 c3                	mov    %eax,%ebx
  8023f3:	f7 64 24 0c          	mull   0xc(%esp)
  8023f7:	39 d6                	cmp    %edx,%esi
  8023f9:	72 15                	jb     802410 <__udivdi3+0x100>
  8023fb:	89 f9                	mov    %edi,%ecx
  8023fd:	d3 e5                	shl    %cl,%ebp
  8023ff:	39 c5                	cmp    %eax,%ebp
  802401:	73 04                	jae    802407 <__udivdi3+0xf7>
  802403:	39 d6                	cmp    %edx,%esi
  802405:	74 09                	je     802410 <__udivdi3+0x100>
  802407:	89 d8                	mov    %ebx,%eax
  802409:	31 ff                	xor    %edi,%edi
  80240b:	e9 40 ff ff ff       	jmp    802350 <__udivdi3+0x40>
  802410:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802413:	31 ff                	xor    %edi,%edi
  802415:	e9 36 ff ff ff       	jmp    802350 <__udivdi3+0x40>
  80241a:	66 90                	xchg   %ax,%ax
  80241c:	66 90                	xchg   %ax,%ax
  80241e:	66 90                	xchg   %ax,%ax

00802420 <__umoddi3>:
  802420:	f3 0f 1e fb          	endbr32 
  802424:	55                   	push   %ebp
  802425:	57                   	push   %edi
  802426:	56                   	push   %esi
  802427:	53                   	push   %ebx
  802428:	83 ec 1c             	sub    $0x1c,%esp
  80242b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80242f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802433:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802437:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80243b:	85 c0                	test   %eax,%eax
  80243d:	75 19                	jne    802458 <__umoddi3+0x38>
  80243f:	39 df                	cmp    %ebx,%edi
  802441:	76 5d                	jbe    8024a0 <__umoddi3+0x80>
  802443:	89 f0                	mov    %esi,%eax
  802445:	89 da                	mov    %ebx,%edx
  802447:	f7 f7                	div    %edi
  802449:	89 d0                	mov    %edx,%eax
  80244b:	31 d2                	xor    %edx,%edx
  80244d:	83 c4 1c             	add    $0x1c,%esp
  802450:	5b                   	pop    %ebx
  802451:	5e                   	pop    %esi
  802452:	5f                   	pop    %edi
  802453:	5d                   	pop    %ebp
  802454:	c3                   	ret    
  802455:	8d 76 00             	lea    0x0(%esi),%esi
  802458:	89 f2                	mov    %esi,%edx
  80245a:	39 d8                	cmp    %ebx,%eax
  80245c:	76 12                	jbe    802470 <__umoddi3+0x50>
  80245e:	89 f0                	mov    %esi,%eax
  802460:	89 da                	mov    %ebx,%edx
  802462:	83 c4 1c             	add    $0x1c,%esp
  802465:	5b                   	pop    %ebx
  802466:	5e                   	pop    %esi
  802467:	5f                   	pop    %edi
  802468:	5d                   	pop    %ebp
  802469:	c3                   	ret    
  80246a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802470:	0f bd e8             	bsr    %eax,%ebp
  802473:	83 f5 1f             	xor    $0x1f,%ebp
  802476:	75 50                	jne    8024c8 <__umoddi3+0xa8>
  802478:	39 d8                	cmp    %ebx,%eax
  80247a:	0f 82 e0 00 00 00    	jb     802560 <__umoddi3+0x140>
  802480:	89 d9                	mov    %ebx,%ecx
  802482:	39 f7                	cmp    %esi,%edi
  802484:	0f 86 d6 00 00 00    	jbe    802560 <__umoddi3+0x140>
  80248a:	89 d0                	mov    %edx,%eax
  80248c:	89 ca                	mov    %ecx,%edx
  80248e:	83 c4 1c             	add    $0x1c,%esp
  802491:	5b                   	pop    %ebx
  802492:	5e                   	pop    %esi
  802493:	5f                   	pop    %edi
  802494:	5d                   	pop    %ebp
  802495:	c3                   	ret    
  802496:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80249d:	8d 76 00             	lea    0x0(%esi),%esi
  8024a0:	89 fd                	mov    %edi,%ebp
  8024a2:	85 ff                	test   %edi,%edi
  8024a4:	75 0b                	jne    8024b1 <__umoddi3+0x91>
  8024a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8024ab:	31 d2                	xor    %edx,%edx
  8024ad:	f7 f7                	div    %edi
  8024af:	89 c5                	mov    %eax,%ebp
  8024b1:	89 d8                	mov    %ebx,%eax
  8024b3:	31 d2                	xor    %edx,%edx
  8024b5:	f7 f5                	div    %ebp
  8024b7:	89 f0                	mov    %esi,%eax
  8024b9:	f7 f5                	div    %ebp
  8024bb:	89 d0                	mov    %edx,%eax
  8024bd:	31 d2                	xor    %edx,%edx
  8024bf:	eb 8c                	jmp    80244d <__umoddi3+0x2d>
  8024c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024c8:	89 e9                	mov    %ebp,%ecx
  8024ca:	ba 20 00 00 00       	mov    $0x20,%edx
  8024cf:	29 ea                	sub    %ebp,%edx
  8024d1:	d3 e0                	shl    %cl,%eax
  8024d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024d7:	89 d1                	mov    %edx,%ecx
  8024d9:	89 f8                	mov    %edi,%eax
  8024db:	d3 e8                	shr    %cl,%eax
  8024dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024e5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024e9:	09 c1                	or     %eax,%ecx
  8024eb:	89 d8                	mov    %ebx,%eax
  8024ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024f1:	89 e9                	mov    %ebp,%ecx
  8024f3:	d3 e7                	shl    %cl,%edi
  8024f5:	89 d1                	mov    %edx,%ecx
  8024f7:	d3 e8                	shr    %cl,%eax
  8024f9:	89 e9                	mov    %ebp,%ecx
  8024fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024ff:	d3 e3                	shl    %cl,%ebx
  802501:	89 c7                	mov    %eax,%edi
  802503:	89 d1                	mov    %edx,%ecx
  802505:	89 f0                	mov    %esi,%eax
  802507:	d3 e8                	shr    %cl,%eax
  802509:	89 e9                	mov    %ebp,%ecx
  80250b:	89 fa                	mov    %edi,%edx
  80250d:	d3 e6                	shl    %cl,%esi
  80250f:	09 d8                	or     %ebx,%eax
  802511:	f7 74 24 08          	divl   0x8(%esp)
  802515:	89 d1                	mov    %edx,%ecx
  802517:	89 f3                	mov    %esi,%ebx
  802519:	f7 64 24 0c          	mull   0xc(%esp)
  80251d:	89 c6                	mov    %eax,%esi
  80251f:	89 d7                	mov    %edx,%edi
  802521:	39 d1                	cmp    %edx,%ecx
  802523:	72 06                	jb     80252b <__umoddi3+0x10b>
  802525:	75 10                	jne    802537 <__umoddi3+0x117>
  802527:	39 c3                	cmp    %eax,%ebx
  802529:	73 0c                	jae    802537 <__umoddi3+0x117>
  80252b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80252f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802533:	89 d7                	mov    %edx,%edi
  802535:	89 c6                	mov    %eax,%esi
  802537:	89 ca                	mov    %ecx,%edx
  802539:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80253e:	29 f3                	sub    %esi,%ebx
  802540:	19 fa                	sbb    %edi,%edx
  802542:	89 d0                	mov    %edx,%eax
  802544:	d3 e0                	shl    %cl,%eax
  802546:	89 e9                	mov    %ebp,%ecx
  802548:	d3 eb                	shr    %cl,%ebx
  80254a:	d3 ea                	shr    %cl,%edx
  80254c:	09 d8                	or     %ebx,%eax
  80254e:	83 c4 1c             	add    $0x1c,%esp
  802551:	5b                   	pop    %ebx
  802552:	5e                   	pop    %esi
  802553:	5f                   	pop    %edi
  802554:	5d                   	pop    %ebp
  802555:	c3                   	ret    
  802556:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80255d:	8d 76 00             	lea    0x0(%esi),%esi
  802560:	29 fe                	sub    %edi,%esi
  802562:	19 c3                	sbb    %eax,%ebx
  802564:	89 f2                	mov    %esi,%edx
  802566:	89 d9                	mov    %ebx,%ecx
  802568:	e9 1d ff ff ff       	jmp    80248a <__umoddi3+0x6a>
