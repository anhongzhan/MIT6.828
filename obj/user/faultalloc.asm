
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
  800044:	68 a0 25 80 00       	push   $0x8025a0
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
  80006a:	68 ec 25 80 00       	push   $0x8025ec
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
  800084:	68 c0 25 80 00       	push   $0x8025c0
  800089:	6a 0e                	push   $0xe
  80008b:	68 aa 25 80 00       	push   $0x8025aa
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
  8000a4:	e8 84 0e 00 00       	call   800f2d <set_pgfault_handler>
	cprintf("%s\n", (char*)0xDeadBeef);
  8000a9:	83 c4 08             	add    $0x8,%esp
  8000ac:	68 ef be ad de       	push   $0xdeadbeef
  8000b1:	68 bc 25 80 00       	push   $0x8025bc
  8000b6:	e8 66 01 00 00       	call   800221 <cprintf>
	cprintf("%s\n", (char*)0xCafeBffe);
  8000bb:	83 c4 08             	add    $0x8,%esp
  8000be:	68 fe bf fe ca       	push   $0xcafebffe
  8000c3:	68 bc 25 80 00       	push   $0x8025bc
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
  8000f3:	a3 08 40 80 00       	mov    %eax,0x804008

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
  800126:	e8 8f 10 00 00       	call   8011ba <close_all>
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
  80015c:	68 18 26 80 00       	push   $0x802618
  800161:	e8 bb 00 00 00       	call   800221 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800166:	83 c4 18             	add    $0x18,%esp
  800169:	53                   	push   %ebx
  80016a:	ff 75 10             	pushl  0x10(%ebp)
  80016d:	e8 5a 00 00 00       	call   8001cc <vcprintf>
	cprintf("\n");
  800172:	c7 04 24 20 2b 80 00 	movl   $0x802b20,(%esp)
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
  800287:	e8 a4 20 00 00       	call   802330 <__udivdi3>
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
  8002c5:	e8 76 21 00 00       	call   802440 <__umoddi3>
  8002ca:	83 c4 14             	add    $0x14,%esp
  8002cd:	0f be 80 3b 26 80 00 	movsbl 0x80263b(%eax),%eax
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
  800374:	3e ff 24 85 80 27 80 	notrack jmp *0x802780(,%eax,4)
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
  800441:	8b 14 85 e0 28 80 00 	mov    0x8028e0(,%eax,4),%edx
  800448:	85 d2                	test   %edx,%edx
  80044a:	74 18                	je     800464 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80044c:	52                   	push   %edx
  80044d:	68 89 2a 80 00       	push   $0x802a89
  800452:	53                   	push   %ebx
  800453:	56                   	push   %esi
  800454:	e8 aa fe ff ff       	call   800303 <printfmt>
  800459:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80045c:	89 7d 14             	mov    %edi,0x14(%ebp)
  80045f:	e9 66 02 00 00       	jmp    8006ca <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800464:	50                   	push   %eax
  800465:	68 53 26 80 00       	push   $0x802653
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
  80048c:	b8 4c 26 80 00       	mov    $0x80264c,%eax
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
  800c16:	68 3f 29 80 00       	push   $0x80293f
  800c1b:	6a 23                	push   $0x23
  800c1d:	68 5c 29 80 00       	push   $0x80295c
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
  800ca3:	68 3f 29 80 00       	push   $0x80293f
  800ca8:	6a 23                	push   $0x23
  800caa:	68 5c 29 80 00       	push   $0x80295c
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
  800ce9:	68 3f 29 80 00       	push   $0x80293f
  800cee:	6a 23                	push   $0x23
  800cf0:	68 5c 29 80 00       	push   $0x80295c
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
  800d2f:	68 3f 29 80 00       	push   $0x80293f
  800d34:	6a 23                	push   $0x23
  800d36:	68 5c 29 80 00       	push   $0x80295c
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
  800d75:	68 3f 29 80 00       	push   $0x80293f
  800d7a:	6a 23                	push   $0x23
  800d7c:	68 5c 29 80 00       	push   $0x80295c
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
  800dbb:	68 3f 29 80 00       	push   $0x80293f
  800dc0:	6a 23                	push   $0x23
  800dc2:	68 5c 29 80 00       	push   $0x80295c
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
  800e01:	68 3f 29 80 00       	push   $0x80293f
  800e06:	6a 23                	push   $0x23
  800e08:	68 5c 29 80 00       	push   $0x80295c
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
  800e6d:	68 3f 29 80 00       	push   $0x80293f
  800e72:	6a 23                	push   $0x23
  800e74:	68 5c 29 80 00       	push   $0x80295c
  800e79:	e8 bc f2 ff ff       	call   80013a <_panic>

00800e7e <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e7e:	f3 0f 1e fb          	endbr32 
  800e82:	55                   	push   %ebp
  800e83:	89 e5                	mov    %esp,%ebp
  800e85:	57                   	push   %edi
  800e86:	56                   	push   %esi
  800e87:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e88:	ba 00 00 00 00       	mov    $0x0,%edx
  800e8d:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e92:	89 d1                	mov    %edx,%ecx
  800e94:	89 d3                	mov    %edx,%ebx
  800e96:	89 d7                	mov    %edx,%edi
  800e98:	89 d6                	mov    %edx,%esi
  800e9a:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e9c:	5b                   	pop    %ebx
  800e9d:	5e                   	pop    %esi
  800e9e:	5f                   	pop    %edi
  800e9f:	5d                   	pop    %ebp
  800ea0:	c3                   	ret    

00800ea1 <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  800ea1:	f3 0f 1e fb          	endbr32 
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	57                   	push   %edi
  800ea9:	56                   	push   %esi
  800eaa:	53                   	push   %ebx
  800eab:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eae:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb3:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb9:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ebe:	89 df                	mov    %ebx,%edi
  800ec0:	89 de                	mov    %ebx,%esi
  800ec2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ec4:	85 c0                	test   %eax,%eax
  800ec6:	7f 08                	jg     800ed0 <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  800ec8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ecb:	5b                   	pop    %ebx
  800ecc:	5e                   	pop    %esi
  800ecd:	5f                   	pop    %edi
  800ece:	5d                   	pop    %ebp
  800ecf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed0:	83 ec 0c             	sub    $0xc,%esp
  800ed3:	50                   	push   %eax
  800ed4:	6a 0f                	push   $0xf
  800ed6:	68 3f 29 80 00       	push   $0x80293f
  800edb:	6a 23                	push   $0x23
  800edd:	68 5c 29 80 00       	push   $0x80295c
  800ee2:	e8 53 f2 ff ff       	call   80013a <_panic>

00800ee7 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  800ee7:	f3 0f 1e fb          	endbr32 
  800eeb:	55                   	push   %ebp
  800eec:	89 e5                	mov    %esp,%ebp
  800eee:	57                   	push   %edi
  800eef:	56                   	push   %esi
  800ef0:	53                   	push   %ebx
  800ef1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ef4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ef9:	8b 55 08             	mov    0x8(%ebp),%edx
  800efc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eff:	b8 10 00 00 00       	mov    $0x10,%eax
  800f04:	89 df                	mov    %ebx,%edi
  800f06:	89 de                	mov    %ebx,%esi
  800f08:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f0a:	85 c0                	test   %eax,%eax
  800f0c:	7f 08                	jg     800f16 <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  800f0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f11:	5b                   	pop    %ebx
  800f12:	5e                   	pop    %esi
  800f13:	5f                   	pop    %edi
  800f14:	5d                   	pop    %ebp
  800f15:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f16:	83 ec 0c             	sub    $0xc,%esp
  800f19:	50                   	push   %eax
  800f1a:	6a 10                	push   $0x10
  800f1c:	68 3f 29 80 00       	push   $0x80293f
  800f21:	6a 23                	push   $0x23
  800f23:	68 5c 29 80 00       	push   $0x80295c
  800f28:	e8 0d f2 ff ff       	call   80013a <_panic>

00800f2d <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800f2d:	f3 0f 1e fb          	endbr32 
  800f31:	55                   	push   %ebp
  800f32:	89 e5                	mov    %esp,%ebp
  800f34:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800f37:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  800f3e:	74 0a                	je     800f4a <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  800f48:	c9                   	leave  
  800f49:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  800f4a:	83 ec 04             	sub    $0x4,%esp
  800f4d:	6a 07                	push   $0x7
  800f4f:	68 00 f0 bf ee       	push   $0xeebff000
  800f54:	6a 00                	push   $0x0
  800f56:	e8 12 fd ff ff       	call   800c6d <sys_page_alloc>
  800f5b:	83 c4 10             	add    $0x10,%esp
  800f5e:	85 c0                	test   %eax,%eax
  800f60:	78 2a                	js     800f8c <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  800f62:	83 ec 08             	sub    $0x8,%esp
  800f65:	68 a0 0f 80 00       	push   $0x800fa0
  800f6a:	6a 00                	push   $0x0
  800f6c:	e8 5b fe ff ff       	call   800dcc <sys_env_set_pgfault_upcall>
  800f71:	83 c4 10             	add    $0x10,%esp
  800f74:	85 c0                	test   %eax,%eax
  800f76:	79 c8                	jns    800f40 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  800f78:	83 ec 04             	sub    $0x4,%esp
  800f7b:	68 98 29 80 00       	push   $0x802998
  800f80:	6a 25                	push   $0x25
  800f82:	68 d0 29 80 00       	push   $0x8029d0
  800f87:	e8 ae f1 ff ff       	call   80013a <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  800f8c:	83 ec 04             	sub    $0x4,%esp
  800f8f:	68 6c 29 80 00       	push   $0x80296c
  800f94:	6a 22                	push   $0x22
  800f96:	68 d0 29 80 00       	push   $0x8029d0
  800f9b:	e8 9a f1 ff ff       	call   80013a <_panic>

00800fa0 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800fa0:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800fa1:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  800fa6:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800fa8:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  800fab:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  800faf:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  800fb3:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  800fb6:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  800fb8:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  800fbc:	83 c4 08             	add    $0x8,%esp
	popal
  800fbf:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  800fc0:	83 c4 04             	add    $0x4,%esp
	popfl
  800fc3:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  800fc4:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  800fc5:	c3                   	ret    

00800fc6 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fc6:	f3 0f 1e fb          	endbr32 
  800fca:	55                   	push   %ebp
  800fcb:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd0:	05 00 00 00 30       	add    $0x30000000,%eax
  800fd5:	c1 e8 0c             	shr    $0xc,%eax
}
  800fd8:	5d                   	pop    %ebp
  800fd9:	c3                   	ret    

00800fda <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fda:	f3 0f 1e fb          	endbr32 
  800fde:	55                   	push   %ebp
  800fdf:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800fe9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fee:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800ff3:	5d                   	pop    %ebp
  800ff4:	c3                   	ret    

00800ff5 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800ff5:	f3 0f 1e fb          	endbr32 
  800ff9:	55                   	push   %ebp
  800ffa:	89 e5                	mov    %esp,%ebp
  800ffc:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801001:	89 c2                	mov    %eax,%edx
  801003:	c1 ea 16             	shr    $0x16,%edx
  801006:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80100d:	f6 c2 01             	test   $0x1,%dl
  801010:	74 2d                	je     80103f <fd_alloc+0x4a>
  801012:	89 c2                	mov    %eax,%edx
  801014:	c1 ea 0c             	shr    $0xc,%edx
  801017:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80101e:	f6 c2 01             	test   $0x1,%dl
  801021:	74 1c                	je     80103f <fd_alloc+0x4a>
  801023:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801028:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80102d:	75 d2                	jne    801001 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801038:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80103d:	eb 0a                	jmp    801049 <fd_alloc+0x54>
			*fd_store = fd;
  80103f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801042:	89 01                	mov    %eax,(%ecx)
			return 0;
  801044:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801049:	5d                   	pop    %ebp
  80104a:	c3                   	ret    

0080104b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80104b:	f3 0f 1e fb          	endbr32 
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801055:	83 f8 1f             	cmp    $0x1f,%eax
  801058:	77 30                	ja     80108a <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80105a:	c1 e0 0c             	shl    $0xc,%eax
  80105d:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801062:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801068:	f6 c2 01             	test   $0x1,%dl
  80106b:	74 24                	je     801091 <fd_lookup+0x46>
  80106d:	89 c2                	mov    %eax,%edx
  80106f:	c1 ea 0c             	shr    $0xc,%edx
  801072:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801079:	f6 c2 01             	test   $0x1,%dl
  80107c:	74 1a                	je     801098 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80107e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801081:	89 02                	mov    %eax,(%edx)
	return 0;
  801083:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801088:	5d                   	pop    %ebp
  801089:	c3                   	ret    
		return -E_INVAL;
  80108a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80108f:	eb f7                	jmp    801088 <fd_lookup+0x3d>
		return -E_INVAL;
  801091:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801096:	eb f0                	jmp    801088 <fd_lookup+0x3d>
  801098:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80109d:	eb e9                	jmp    801088 <fd_lookup+0x3d>

0080109f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80109f:	f3 0f 1e fb          	endbr32 
  8010a3:	55                   	push   %ebp
  8010a4:	89 e5                	mov    %esp,%ebp
  8010a6:	83 ec 08             	sub    $0x8,%esp
  8010a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8010ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8010b1:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8010b6:	39 08                	cmp    %ecx,(%eax)
  8010b8:	74 38                	je     8010f2 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  8010ba:	83 c2 01             	add    $0x1,%edx
  8010bd:	8b 04 95 5c 2a 80 00 	mov    0x802a5c(,%edx,4),%eax
  8010c4:	85 c0                	test   %eax,%eax
  8010c6:	75 ee                	jne    8010b6 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010c8:	a1 08 40 80 00       	mov    0x804008,%eax
  8010cd:	8b 40 48             	mov    0x48(%eax),%eax
  8010d0:	83 ec 04             	sub    $0x4,%esp
  8010d3:	51                   	push   %ecx
  8010d4:	50                   	push   %eax
  8010d5:	68 e0 29 80 00       	push   $0x8029e0
  8010da:	e8 42 f1 ff ff       	call   800221 <cprintf>
	*dev = 0;
  8010df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010e8:	83 c4 10             	add    $0x10,%esp
  8010eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010f0:	c9                   	leave  
  8010f1:	c3                   	ret    
			*dev = devtab[i];
  8010f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f5:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8010fc:	eb f2                	jmp    8010f0 <dev_lookup+0x51>

008010fe <fd_close>:
{
  8010fe:	f3 0f 1e fb          	endbr32 
  801102:	55                   	push   %ebp
  801103:	89 e5                	mov    %esp,%ebp
  801105:	57                   	push   %edi
  801106:	56                   	push   %esi
  801107:	53                   	push   %ebx
  801108:	83 ec 24             	sub    $0x24,%esp
  80110b:	8b 75 08             	mov    0x8(%ebp),%esi
  80110e:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801111:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801114:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801115:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80111b:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80111e:	50                   	push   %eax
  80111f:	e8 27 ff ff ff       	call   80104b <fd_lookup>
  801124:	89 c3                	mov    %eax,%ebx
  801126:	83 c4 10             	add    $0x10,%esp
  801129:	85 c0                	test   %eax,%eax
  80112b:	78 05                	js     801132 <fd_close+0x34>
	    || fd != fd2)
  80112d:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801130:	74 16                	je     801148 <fd_close+0x4a>
		return (must_exist ? r : 0);
  801132:	89 f8                	mov    %edi,%eax
  801134:	84 c0                	test   %al,%al
  801136:	b8 00 00 00 00       	mov    $0x0,%eax
  80113b:	0f 44 d8             	cmove  %eax,%ebx
}
  80113e:	89 d8                	mov    %ebx,%eax
  801140:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801143:	5b                   	pop    %ebx
  801144:	5e                   	pop    %esi
  801145:	5f                   	pop    %edi
  801146:	5d                   	pop    %ebp
  801147:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801148:	83 ec 08             	sub    $0x8,%esp
  80114b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80114e:	50                   	push   %eax
  80114f:	ff 36                	pushl  (%esi)
  801151:	e8 49 ff ff ff       	call   80109f <dev_lookup>
  801156:	89 c3                	mov    %eax,%ebx
  801158:	83 c4 10             	add    $0x10,%esp
  80115b:	85 c0                	test   %eax,%eax
  80115d:	78 1a                	js     801179 <fd_close+0x7b>
		if (dev->dev_close)
  80115f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801162:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801165:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80116a:	85 c0                	test   %eax,%eax
  80116c:	74 0b                	je     801179 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80116e:	83 ec 0c             	sub    $0xc,%esp
  801171:	56                   	push   %esi
  801172:	ff d0                	call   *%eax
  801174:	89 c3                	mov    %eax,%ebx
  801176:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801179:	83 ec 08             	sub    $0x8,%esp
  80117c:	56                   	push   %esi
  80117d:	6a 00                	push   $0x0
  80117f:	e8 76 fb ff ff       	call   800cfa <sys_page_unmap>
	return r;
  801184:	83 c4 10             	add    $0x10,%esp
  801187:	eb b5                	jmp    80113e <fd_close+0x40>

00801189 <close>:

int
close(int fdnum)
{
  801189:	f3 0f 1e fb          	endbr32 
  80118d:	55                   	push   %ebp
  80118e:	89 e5                	mov    %esp,%ebp
  801190:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801193:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801196:	50                   	push   %eax
  801197:	ff 75 08             	pushl  0x8(%ebp)
  80119a:	e8 ac fe ff ff       	call   80104b <fd_lookup>
  80119f:	83 c4 10             	add    $0x10,%esp
  8011a2:	85 c0                	test   %eax,%eax
  8011a4:	79 02                	jns    8011a8 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8011a6:	c9                   	leave  
  8011a7:	c3                   	ret    
		return fd_close(fd, 1);
  8011a8:	83 ec 08             	sub    $0x8,%esp
  8011ab:	6a 01                	push   $0x1
  8011ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8011b0:	e8 49 ff ff ff       	call   8010fe <fd_close>
  8011b5:	83 c4 10             	add    $0x10,%esp
  8011b8:	eb ec                	jmp    8011a6 <close+0x1d>

008011ba <close_all>:

void
close_all(void)
{
  8011ba:	f3 0f 1e fb          	endbr32 
  8011be:	55                   	push   %ebp
  8011bf:	89 e5                	mov    %esp,%ebp
  8011c1:	53                   	push   %ebx
  8011c2:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011c5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011ca:	83 ec 0c             	sub    $0xc,%esp
  8011cd:	53                   	push   %ebx
  8011ce:	e8 b6 ff ff ff       	call   801189 <close>
	for (i = 0; i < MAXFD; i++)
  8011d3:	83 c3 01             	add    $0x1,%ebx
  8011d6:	83 c4 10             	add    $0x10,%esp
  8011d9:	83 fb 20             	cmp    $0x20,%ebx
  8011dc:	75 ec                	jne    8011ca <close_all+0x10>
}
  8011de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011e1:	c9                   	leave  
  8011e2:	c3                   	ret    

008011e3 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011e3:	f3 0f 1e fb          	endbr32 
  8011e7:	55                   	push   %ebp
  8011e8:	89 e5                	mov    %esp,%ebp
  8011ea:	57                   	push   %edi
  8011eb:	56                   	push   %esi
  8011ec:	53                   	push   %ebx
  8011ed:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011f0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011f3:	50                   	push   %eax
  8011f4:	ff 75 08             	pushl  0x8(%ebp)
  8011f7:	e8 4f fe ff ff       	call   80104b <fd_lookup>
  8011fc:	89 c3                	mov    %eax,%ebx
  8011fe:	83 c4 10             	add    $0x10,%esp
  801201:	85 c0                	test   %eax,%eax
  801203:	0f 88 81 00 00 00    	js     80128a <dup+0xa7>
		return r;
	close(newfdnum);
  801209:	83 ec 0c             	sub    $0xc,%esp
  80120c:	ff 75 0c             	pushl  0xc(%ebp)
  80120f:	e8 75 ff ff ff       	call   801189 <close>

	newfd = INDEX2FD(newfdnum);
  801214:	8b 75 0c             	mov    0xc(%ebp),%esi
  801217:	c1 e6 0c             	shl    $0xc,%esi
  80121a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801220:	83 c4 04             	add    $0x4,%esp
  801223:	ff 75 e4             	pushl  -0x1c(%ebp)
  801226:	e8 af fd ff ff       	call   800fda <fd2data>
  80122b:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80122d:	89 34 24             	mov    %esi,(%esp)
  801230:	e8 a5 fd ff ff       	call   800fda <fd2data>
  801235:	83 c4 10             	add    $0x10,%esp
  801238:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80123a:	89 d8                	mov    %ebx,%eax
  80123c:	c1 e8 16             	shr    $0x16,%eax
  80123f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801246:	a8 01                	test   $0x1,%al
  801248:	74 11                	je     80125b <dup+0x78>
  80124a:	89 d8                	mov    %ebx,%eax
  80124c:	c1 e8 0c             	shr    $0xc,%eax
  80124f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801256:	f6 c2 01             	test   $0x1,%dl
  801259:	75 39                	jne    801294 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80125b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80125e:	89 d0                	mov    %edx,%eax
  801260:	c1 e8 0c             	shr    $0xc,%eax
  801263:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80126a:	83 ec 0c             	sub    $0xc,%esp
  80126d:	25 07 0e 00 00       	and    $0xe07,%eax
  801272:	50                   	push   %eax
  801273:	56                   	push   %esi
  801274:	6a 00                	push   $0x0
  801276:	52                   	push   %edx
  801277:	6a 00                	push   $0x0
  801279:	e8 36 fa ff ff       	call   800cb4 <sys_page_map>
  80127e:	89 c3                	mov    %eax,%ebx
  801280:	83 c4 20             	add    $0x20,%esp
  801283:	85 c0                	test   %eax,%eax
  801285:	78 31                	js     8012b8 <dup+0xd5>
		goto err;

	return newfdnum;
  801287:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80128a:	89 d8                	mov    %ebx,%eax
  80128c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80128f:	5b                   	pop    %ebx
  801290:	5e                   	pop    %esi
  801291:	5f                   	pop    %edi
  801292:	5d                   	pop    %ebp
  801293:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801294:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80129b:	83 ec 0c             	sub    $0xc,%esp
  80129e:	25 07 0e 00 00       	and    $0xe07,%eax
  8012a3:	50                   	push   %eax
  8012a4:	57                   	push   %edi
  8012a5:	6a 00                	push   $0x0
  8012a7:	53                   	push   %ebx
  8012a8:	6a 00                	push   $0x0
  8012aa:	e8 05 fa ff ff       	call   800cb4 <sys_page_map>
  8012af:	89 c3                	mov    %eax,%ebx
  8012b1:	83 c4 20             	add    $0x20,%esp
  8012b4:	85 c0                	test   %eax,%eax
  8012b6:	79 a3                	jns    80125b <dup+0x78>
	sys_page_unmap(0, newfd);
  8012b8:	83 ec 08             	sub    $0x8,%esp
  8012bb:	56                   	push   %esi
  8012bc:	6a 00                	push   $0x0
  8012be:	e8 37 fa ff ff       	call   800cfa <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012c3:	83 c4 08             	add    $0x8,%esp
  8012c6:	57                   	push   %edi
  8012c7:	6a 00                	push   $0x0
  8012c9:	e8 2c fa ff ff       	call   800cfa <sys_page_unmap>
	return r;
  8012ce:	83 c4 10             	add    $0x10,%esp
  8012d1:	eb b7                	jmp    80128a <dup+0xa7>

008012d3 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012d3:	f3 0f 1e fb          	endbr32 
  8012d7:	55                   	push   %ebp
  8012d8:	89 e5                	mov    %esp,%ebp
  8012da:	53                   	push   %ebx
  8012db:	83 ec 1c             	sub    $0x1c,%esp
  8012de:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012e1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012e4:	50                   	push   %eax
  8012e5:	53                   	push   %ebx
  8012e6:	e8 60 fd ff ff       	call   80104b <fd_lookup>
  8012eb:	83 c4 10             	add    $0x10,%esp
  8012ee:	85 c0                	test   %eax,%eax
  8012f0:	78 3f                	js     801331 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012f2:	83 ec 08             	sub    $0x8,%esp
  8012f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012f8:	50                   	push   %eax
  8012f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012fc:	ff 30                	pushl  (%eax)
  8012fe:	e8 9c fd ff ff       	call   80109f <dev_lookup>
  801303:	83 c4 10             	add    $0x10,%esp
  801306:	85 c0                	test   %eax,%eax
  801308:	78 27                	js     801331 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80130a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80130d:	8b 42 08             	mov    0x8(%edx),%eax
  801310:	83 e0 03             	and    $0x3,%eax
  801313:	83 f8 01             	cmp    $0x1,%eax
  801316:	74 1e                	je     801336 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801318:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80131b:	8b 40 08             	mov    0x8(%eax),%eax
  80131e:	85 c0                	test   %eax,%eax
  801320:	74 35                	je     801357 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801322:	83 ec 04             	sub    $0x4,%esp
  801325:	ff 75 10             	pushl  0x10(%ebp)
  801328:	ff 75 0c             	pushl  0xc(%ebp)
  80132b:	52                   	push   %edx
  80132c:	ff d0                	call   *%eax
  80132e:	83 c4 10             	add    $0x10,%esp
}
  801331:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801334:	c9                   	leave  
  801335:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801336:	a1 08 40 80 00       	mov    0x804008,%eax
  80133b:	8b 40 48             	mov    0x48(%eax),%eax
  80133e:	83 ec 04             	sub    $0x4,%esp
  801341:	53                   	push   %ebx
  801342:	50                   	push   %eax
  801343:	68 21 2a 80 00       	push   $0x802a21
  801348:	e8 d4 ee ff ff       	call   800221 <cprintf>
		return -E_INVAL;
  80134d:	83 c4 10             	add    $0x10,%esp
  801350:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801355:	eb da                	jmp    801331 <read+0x5e>
		return -E_NOT_SUPP;
  801357:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80135c:	eb d3                	jmp    801331 <read+0x5e>

0080135e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80135e:	f3 0f 1e fb          	endbr32 
  801362:	55                   	push   %ebp
  801363:	89 e5                	mov    %esp,%ebp
  801365:	57                   	push   %edi
  801366:	56                   	push   %esi
  801367:	53                   	push   %ebx
  801368:	83 ec 0c             	sub    $0xc,%esp
  80136b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80136e:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801371:	bb 00 00 00 00       	mov    $0x0,%ebx
  801376:	eb 02                	jmp    80137a <readn+0x1c>
  801378:	01 c3                	add    %eax,%ebx
  80137a:	39 f3                	cmp    %esi,%ebx
  80137c:	73 21                	jae    80139f <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80137e:	83 ec 04             	sub    $0x4,%esp
  801381:	89 f0                	mov    %esi,%eax
  801383:	29 d8                	sub    %ebx,%eax
  801385:	50                   	push   %eax
  801386:	89 d8                	mov    %ebx,%eax
  801388:	03 45 0c             	add    0xc(%ebp),%eax
  80138b:	50                   	push   %eax
  80138c:	57                   	push   %edi
  80138d:	e8 41 ff ff ff       	call   8012d3 <read>
		if (m < 0)
  801392:	83 c4 10             	add    $0x10,%esp
  801395:	85 c0                	test   %eax,%eax
  801397:	78 04                	js     80139d <readn+0x3f>
			return m;
		if (m == 0)
  801399:	75 dd                	jne    801378 <readn+0x1a>
  80139b:	eb 02                	jmp    80139f <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80139d:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80139f:	89 d8                	mov    %ebx,%eax
  8013a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013a4:	5b                   	pop    %ebx
  8013a5:	5e                   	pop    %esi
  8013a6:	5f                   	pop    %edi
  8013a7:	5d                   	pop    %ebp
  8013a8:	c3                   	ret    

008013a9 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013a9:	f3 0f 1e fb          	endbr32 
  8013ad:	55                   	push   %ebp
  8013ae:	89 e5                	mov    %esp,%ebp
  8013b0:	53                   	push   %ebx
  8013b1:	83 ec 1c             	sub    $0x1c,%esp
  8013b4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013b7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013ba:	50                   	push   %eax
  8013bb:	53                   	push   %ebx
  8013bc:	e8 8a fc ff ff       	call   80104b <fd_lookup>
  8013c1:	83 c4 10             	add    $0x10,%esp
  8013c4:	85 c0                	test   %eax,%eax
  8013c6:	78 3a                	js     801402 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013c8:	83 ec 08             	sub    $0x8,%esp
  8013cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ce:	50                   	push   %eax
  8013cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d2:	ff 30                	pushl  (%eax)
  8013d4:	e8 c6 fc ff ff       	call   80109f <dev_lookup>
  8013d9:	83 c4 10             	add    $0x10,%esp
  8013dc:	85 c0                	test   %eax,%eax
  8013de:	78 22                	js     801402 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013e3:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013e7:	74 1e                	je     801407 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013ec:	8b 52 0c             	mov    0xc(%edx),%edx
  8013ef:	85 d2                	test   %edx,%edx
  8013f1:	74 35                	je     801428 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013f3:	83 ec 04             	sub    $0x4,%esp
  8013f6:	ff 75 10             	pushl  0x10(%ebp)
  8013f9:	ff 75 0c             	pushl  0xc(%ebp)
  8013fc:	50                   	push   %eax
  8013fd:	ff d2                	call   *%edx
  8013ff:	83 c4 10             	add    $0x10,%esp
}
  801402:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801405:	c9                   	leave  
  801406:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801407:	a1 08 40 80 00       	mov    0x804008,%eax
  80140c:	8b 40 48             	mov    0x48(%eax),%eax
  80140f:	83 ec 04             	sub    $0x4,%esp
  801412:	53                   	push   %ebx
  801413:	50                   	push   %eax
  801414:	68 3d 2a 80 00       	push   $0x802a3d
  801419:	e8 03 ee ff ff       	call   800221 <cprintf>
		return -E_INVAL;
  80141e:	83 c4 10             	add    $0x10,%esp
  801421:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801426:	eb da                	jmp    801402 <write+0x59>
		return -E_NOT_SUPP;
  801428:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80142d:	eb d3                	jmp    801402 <write+0x59>

0080142f <seek>:

int
seek(int fdnum, off_t offset)
{
  80142f:	f3 0f 1e fb          	endbr32 
  801433:	55                   	push   %ebp
  801434:	89 e5                	mov    %esp,%ebp
  801436:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801439:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80143c:	50                   	push   %eax
  80143d:	ff 75 08             	pushl  0x8(%ebp)
  801440:	e8 06 fc ff ff       	call   80104b <fd_lookup>
  801445:	83 c4 10             	add    $0x10,%esp
  801448:	85 c0                	test   %eax,%eax
  80144a:	78 0e                	js     80145a <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80144c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80144f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801452:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801455:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80145a:	c9                   	leave  
  80145b:	c3                   	ret    

0080145c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80145c:	f3 0f 1e fb          	endbr32 
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	53                   	push   %ebx
  801464:	83 ec 1c             	sub    $0x1c,%esp
  801467:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80146a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80146d:	50                   	push   %eax
  80146e:	53                   	push   %ebx
  80146f:	e8 d7 fb ff ff       	call   80104b <fd_lookup>
  801474:	83 c4 10             	add    $0x10,%esp
  801477:	85 c0                	test   %eax,%eax
  801479:	78 37                	js     8014b2 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80147b:	83 ec 08             	sub    $0x8,%esp
  80147e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801481:	50                   	push   %eax
  801482:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801485:	ff 30                	pushl  (%eax)
  801487:	e8 13 fc ff ff       	call   80109f <dev_lookup>
  80148c:	83 c4 10             	add    $0x10,%esp
  80148f:	85 c0                	test   %eax,%eax
  801491:	78 1f                	js     8014b2 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801493:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801496:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80149a:	74 1b                	je     8014b7 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80149c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80149f:	8b 52 18             	mov    0x18(%edx),%edx
  8014a2:	85 d2                	test   %edx,%edx
  8014a4:	74 32                	je     8014d8 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014a6:	83 ec 08             	sub    $0x8,%esp
  8014a9:	ff 75 0c             	pushl  0xc(%ebp)
  8014ac:	50                   	push   %eax
  8014ad:	ff d2                	call   *%edx
  8014af:	83 c4 10             	add    $0x10,%esp
}
  8014b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014b5:	c9                   	leave  
  8014b6:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014b7:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014bc:	8b 40 48             	mov    0x48(%eax),%eax
  8014bf:	83 ec 04             	sub    $0x4,%esp
  8014c2:	53                   	push   %ebx
  8014c3:	50                   	push   %eax
  8014c4:	68 00 2a 80 00       	push   $0x802a00
  8014c9:	e8 53 ed ff ff       	call   800221 <cprintf>
		return -E_INVAL;
  8014ce:	83 c4 10             	add    $0x10,%esp
  8014d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014d6:	eb da                	jmp    8014b2 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8014d8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014dd:	eb d3                	jmp    8014b2 <ftruncate+0x56>

008014df <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014df:	f3 0f 1e fb          	endbr32 
  8014e3:	55                   	push   %ebp
  8014e4:	89 e5                	mov    %esp,%ebp
  8014e6:	53                   	push   %ebx
  8014e7:	83 ec 1c             	sub    $0x1c,%esp
  8014ea:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014ed:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014f0:	50                   	push   %eax
  8014f1:	ff 75 08             	pushl  0x8(%ebp)
  8014f4:	e8 52 fb ff ff       	call   80104b <fd_lookup>
  8014f9:	83 c4 10             	add    $0x10,%esp
  8014fc:	85 c0                	test   %eax,%eax
  8014fe:	78 4b                	js     80154b <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801500:	83 ec 08             	sub    $0x8,%esp
  801503:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801506:	50                   	push   %eax
  801507:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150a:	ff 30                	pushl  (%eax)
  80150c:	e8 8e fb ff ff       	call   80109f <dev_lookup>
  801511:	83 c4 10             	add    $0x10,%esp
  801514:	85 c0                	test   %eax,%eax
  801516:	78 33                	js     80154b <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80151b:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80151f:	74 2f                	je     801550 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801521:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801524:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80152b:	00 00 00 
	stat->st_isdir = 0;
  80152e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801535:	00 00 00 
	stat->st_dev = dev;
  801538:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80153e:	83 ec 08             	sub    $0x8,%esp
  801541:	53                   	push   %ebx
  801542:	ff 75 f0             	pushl  -0x10(%ebp)
  801545:	ff 50 14             	call   *0x14(%eax)
  801548:	83 c4 10             	add    $0x10,%esp
}
  80154b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80154e:	c9                   	leave  
  80154f:	c3                   	ret    
		return -E_NOT_SUPP;
  801550:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801555:	eb f4                	jmp    80154b <fstat+0x6c>

00801557 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801557:	f3 0f 1e fb          	endbr32 
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
  80155e:	56                   	push   %esi
  80155f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801560:	83 ec 08             	sub    $0x8,%esp
  801563:	6a 00                	push   $0x0
  801565:	ff 75 08             	pushl  0x8(%ebp)
  801568:	e8 fb 01 00 00       	call   801768 <open>
  80156d:	89 c3                	mov    %eax,%ebx
  80156f:	83 c4 10             	add    $0x10,%esp
  801572:	85 c0                	test   %eax,%eax
  801574:	78 1b                	js     801591 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801576:	83 ec 08             	sub    $0x8,%esp
  801579:	ff 75 0c             	pushl  0xc(%ebp)
  80157c:	50                   	push   %eax
  80157d:	e8 5d ff ff ff       	call   8014df <fstat>
  801582:	89 c6                	mov    %eax,%esi
	close(fd);
  801584:	89 1c 24             	mov    %ebx,(%esp)
  801587:	e8 fd fb ff ff       	call   801189 <close>
	return r;
  80158c:	83 c4 10             	add    $0x10,%esp
  80158f:	89 f3                	mov    %esi,%ebx
}
  801591:	89 d8                	mov    %ebx,%eax
  801593:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801596:	5b                   	pop    %ebx
  801597:	5e                   	pop    %esi
  801598:	5d                   	pop    %ebp
  801599:	c3                   	ret    

0080159a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80159a:	55                   	push   %ebp
  80159b:	89 e5                	mov    %esp,%ebp
  80159d:	56                   	push   %esi
  80159e:	53                   	push   %ebx
  80159f:	89 c6                	mov    %eax,%esi
  8015a1:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015a3:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015aa:	74 27                	je     8015d3 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015ac:	6a 07                	push   $0x7
  8015ae:	68 00 50 80 00       	push   $0x805000
  8015b3:	56                   	push   %esi
  8015b4:	ff 35 00 40 80 00    	pushl  0x804000
  8015ba:	e8 8e 0c 00 00       	call   80224d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015bf:	83 c4 0c             	add    $0xc,%esp
  8015c2:	6a 00                	push   $0x0
  8015c4:	53                   	push   %ebx
  8015c5:	6a 00                	push   $0x0
  8015c7:	e8 fc 0b 00 00       	call   8021c8 <ipc_recv>
}
  8015cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015cf:	5b                   	pop    %ebx
  8015d0:	5e                   	pop    %esi
  8015d1:	5d                   	pop    %ebp
  8015d2:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015d3:	83 ec 0c             	sub    $0xc,%esp
  8015d6:	6a 01                	push   $0x1
  8015d8:	e8 c8 0c 00 00       	call   8022a5 <ipc_find_env>
  8015dd:	a3 00 40 80 00       	mov    %eax,0x804000
  8015e2:	83 c4 10             	add    $0x10,%esp
  8015e5:	eb c5                	jmp    8015ac <fsipc+0x12>

008015e7 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015e7:	f3 0f 1e fb          	endbr32 
  8015eb:	55                   	push   %ebp
  8015ec:	89 e5                	mov    %esp,%ebp
  8015ee:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8015f7:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8015fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ff:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801604:	ba 00 00 00 00       	mov    $0x0,%edx
  801609:	b8 02 00 00 00       	mov    $0x2,%eax
  80160e:	e8 87 ff ff ff       	call   80159a <fsipc>
}
  801613:	c9                   	leave  
  801614:	c3                   	ret    

00801615 <devfile_flush>:
{
  801615:	f3 0f 1e fb          	endbr32 
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
  80161c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80161f:	8b 45 08             	mov    0x8(%ebp),%eax
  801622:	8b 40 0c             	mov    0xc(%eax),%eax
  801625:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80162a:	ba 00 00 00 00       	mov    $0x0,%edx
  80162f:	b8 06 00 00 00       	mov    $0x6,%eax
  801634:	e8 61 ff ff ff       	call   80159a <fsipc>
}
  801639:	c9                   	leave  
  80163a:	c3                   	ret    

0080163b <devfile_stat>:
{
  80163b:	f3 0f 1e fb          	endbr32 
  80163f:	55                   	push   %ebp
  801640:	89 e5                	mov    %esp,%ebp
  801642:	53                   	push   %ebx
  801643:	83 ec 04             	sub    $0x4,%esp
  801646:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801649:	8b 45 08             	mov    0x8(%ebp),%eax
  80164c:	8b 40 0c             	mov    0xc(%eax),%eax
  80164f:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801654:	ba 00 00 00 00       	mov    $0x0,%edx
  801659:	b8 05 00 00 00       	mov    $0x5,%eax
  80165e:	e8 37 ff ff ff       	call   80159a <fsipc>
  801663:	85 c0                	test   %eax,%eax
  801665:	78 2c                	js     801693 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801667:	83 ec 08             	sub    $0x8,%esp
  80166a:	68 00 50 80 00       	push   $0x805000
  80166f:	53                   	push   %ebx
  801670:	e8 b6 f1 ff ff       	call   80082b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801675:	a1 80 50 80 00       	mov    0x805080,%eax
  80167a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801680:	a1 84 50 80 00       	mov    0x805084,%eax
  801685:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80168b:	83 c4 10             	add    $0x10,%esp
  80168e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801693:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801696:	c9                   	leave  
  801697:	c3                   	ret    

00801698 <devfile_write>:
{
  801698:	f3 0f 1e fb          	endbr32 
  80169c:	55                   	push   %ebp
  80169d:	89 e5                	mov    %esp,%ebp
  80169f:	83 ec 0c             	sub    $0xc,%esp
  8016a2:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8016a8:	8b 52 0c             	mov    0xc(%edx),%edx
  8016ab:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  8016b1:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8016b6:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8016bb:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  8016be:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  8016c3:	50                   	push   %eax
  8016c4:	ff 75 0c             	pushl  0xc(%ebp)
  8016c7:	68 08 50 80 00       	push   $0x805008
  8016cc:	e8 10 f3 ff ff       	call   8009e1 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  8016d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d6:	b8 04 00 00 00       	mov    $0x4,%eax
  8016db:	e8 ba fe ff ff       	call   80159a <fsipc>
}
  8016e0:	c9                   	leave  
  8016e1:	c3                   	ret    

008016e2 <devfile_read>:
{
  8016e2:	f3 0f 1e fb          	endbr32 
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
  8016e9:	56                   	push   %esi
  8016ea:	53                   	push   %ebx
  8016eb:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8016f4:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016f9:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016ff:	ba 00 00 00 00       	mov    $0x0,%edx
  801704:	b8 03 00 00 00       	mov    $0x3,%eax
  801709:	e8 8c fe ff ff       	call   80159a <fsipc>
  80170e:	89 c3                	mov    %eax,%ebx
  801710:	85 c0                	test   %eax,%eax
  801712:	78 1f                	js     801733 <devfile_read+0x51>
	assert(r <= n);
  801714:	39 f0                	cmp    %esi,%eax
  801716:	77 24                	ja     80173c <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801718:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80171d:	7f 33                	jg     801752 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80171f:	83 ec 04             	sub    $0x4,%esp
  801722:	50                   	push   %eax
  801723:	68 00 50 80 00       	push   $0x805000
  801728:	ff 75 0c             	pushl  0xc(%ebp)
  80172b:	e8 b1 f2 ff ff       	call   8009e1 <memmove>
	return r;
  801730:	83 c4 10             	add    $0x10,%esp
}
  801733:	89 d8                	mov    %ebx,%eax
  801735:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801738:	5b                   	pop    %ebx
  801739:	5e                   	pop    %esi
  80173a:	5d                   	pop    %ebp
  80173b:	c3                   	ret    
	assert(r <= n);
  80173c:	68 70 2a 80 00       	push   $0x802a70
  801741:	68 77 2a 80 00       	push   $0x802a77
  801746:	6a 7c                	push   $0x7c
  801748:	68 8c 2a 80 00       	push   $0x802a8c
  80174d:	e8 e8 e9 ff ff       	call   80013a <_panic>
	assert(r <= PGSIZE);
  801752:	68 97 2a 80 00       	push   $0x802a97
  801757:	68 77 2a 80 00       	push   $0x802a77
  80175c:	6a 7d                	push   $0x7d
  80175e:	68 8c 2a 80 00       	push   $0x802a8c
  801763:	e8 d2 e9 ff ff       	call   80013a <_panic>

00801768 <open>:
{
  801768:	f3 0f 1e fb          	endbr32 
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
  80176f:	56                   	push   %esi
  801770:	53                   	push   %ebx
  801771:	83 ec 1c             	sub    $0x1c,%esp
  801774:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801777:	56                   	push   %esi
  801778:	e8 6b f0 ff ff       	call   8007e8 <strlen>
  80177d:	83 c4 10             	add    $0x10,%esp
  801780:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801785:	7f 6c                	jg     8017f3 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801787:	83 ec 0c             	sub    $0xc,%esp
  80178a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80178d:	50                   	push   %eax
  80178e:	e8 62 f8 ff ff       	call   800ff5 <fd_alloc>
  801793:	89 c3                	mov    %eax,%ebx
  801795:	83 c4 10             	add    $0x10,%esp
  801798:	85 c0                	test   %eax,%eax
  80179a:	78 3c                	js     8017d8 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  80179c:	83 ec 08             	sub    $0x8,%esp
  80179f:	56                   	push   %esi
  8017a0:	68 00 50 80 00       	push   $0x805000
  8017a5:	e8 81 f0 ff ff       	call   80082b <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ad:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017b5:	b8 01 00 00 00       	mov    $0x1,%eax
  8017ba:	e8 db fd ff ff       	call   80159a <fsipc>
  8017bf:	89 c3                	mov    %eax,%ebx
  8017c1:	83 c4 10             	add    $0x10,%esp
  8017c4:	85 c0                	test   %eax,%eax
  8017c6:	78 19                	js     8017e1 <open+0x79>
	return fd2num(fd);
  8017c8:	83 ec 0c             	sub    $0xc,%esp
  8017cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8017ce:	e8 f3 f7 ff ff       	call   800fc6 <fd2num>
  8017d3:	89 c3                	mov    %eax,%ebx
  8017d5:	83 c4 10             	add    $0x10,%esp
}
  8017d8:	89 d8                	mov    %ebx,%eax
  8017da:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017dd:	5b                   	pop    %ebx
  8017de:	5e                   	pop    %esi
  8017df:	5d                   	pop    %ebp
  8017e0:	c3                   	ret    
		fd_close(fd, 0);
  8017e1:	83 ec 08             	sub    $0x8,%esp
  8017e4:	6a 00                	push   $0x0
  8017e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8017e9:	e8 10 f9 ff ff       	call   8010fe <fd_close>
		return r;
  8017ee:	83 c4 10             	add    $0x10,%esp
  8017f1:	eb e5                	jmp    8017d8 <open+0x70>
		return -E_BAD_PATH;
  8017f3:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017f8:	eb de                	jmp    8017d8 <open+0x70>

008017fa <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017fa:	f3 0f 1e fb          	endbr32 
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
  801801:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801804:	ba 00 00 00 00       	mov    $0x0,%edx
  801809:	b8 08 00 00 00       	mov    $0x8,%eax
  80180e:	e8 87 fd ff ff       	call   80159a <fsipc>
}
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801815:	f3 0f 1e fb          	endbr32 
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
  80181c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80181f:	68 a3 2a 80 00       	push   $0x802aa3
  801824:	ff 75 0c             	pushl  0xc(%ebp)
  801827:	e8 ff ef ff ff       	call   80082b <strcpy>
	return 0;
}
  80182c:	b8 00 00 00 00       	mov    $0x0,%eax
  801831:	c9                   	leave  
  801832:	c3                   	ret    

00801833 <devsock_close>:
{
  801833:	f3 0f 1e fb          	endbr32 
  801837:	55                   	push   %ebp
  801838:	89 e5                	mov    %esp,%ebp
  80183a:	53                   	push   %ebx
  80183b:	83 ec 10             	sub    $0x10,%esp
  80183e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801841:	53                   	push   %ebx
  801842:	e8 9b 0a 00 00       	call   8022e2 <pageref>
  801847:	89 c2                	mov    %eax,%edx
  801849:	83 c4 10             	add    $0x10,%esp
		return 0;
  80184c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801851:	83 fa 01             	cmp    $0x1,%edx
  801854:	74 05                	je     80185b <devsock_close+0x28>
}
  801856:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801859:	c9                   	leave  
  80185a:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80185b:	83 ec 0c             	sub    $0xc,%esp
  80185e:	ff 73 0c             	pushl  0xc(%ebx)
  801861:	e8 e3 02 00 00       	call   801b49 <nsipc_close>
  801866:	83 c4 10             	add    $0x10,%esp
  801869:	eb eb                	jmp    801856 <devsock_close+0x23>

0080186b <devsock_write>:
{
  80186b:	f3 0f 1e fb          	endbr32 
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
  801872:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801875:	6a 00                	push   $0x0
  801877:	ff 75 10             	pushl  0x10(%ebp)
  80187a:	ff 75 0c             	pushl  0xc(%ebp)
  80187d:	8b 45 08             	mov    0x8(%ebp),%eax
  801880:	ff 70 0c             	pushl  0xc(%eax)
  801883:	e8 b5 03 00 00       	call   801c3d <nsipc_send>
}
  801888:	c9                   	leave  
  801889:	c3                   	ret    

0080188a <devsock_read>:
{
  80188a:	f3 0f 1e fb          	endbr32 
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
  801891:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801894:	6a 00                	push   $0x0
  801896:	ff 75 10             	pushl  0x10(%ebp)
  801899:	ff 75 0c             	pushl  0xc(%ebp)
  80189c:	8b 45 08             	mov    0x8(%ebp),%eax
  80189f:	ff 70 0c             	pushl  0xc(%eax)
  8018a2:	e8 1f 03 00 00       	call   801bc6 <nsipc_recv>
}
  8018a7:	c9                   	leave  
  8018a8:	c3                   	ret    

008018a9 <fd2sockid>:
{
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
  8018ac:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8018af:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8018b2:	52                   	push   %edx
  8018b3:	50                   	push   %eax
  8018b4:	e8 92 f7 ff ff       	call   80104b <fd_lookup>
  8018b9:	83 c4 10             	add    $0x10,%esp
  8018bc:	85 c0                	test   %eax,%eax
  8018be:	78 10                	js     8018d0 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8018c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c3:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8018c9:	39 08                	cmp    %ecx,(%eax)
  8018cb:	75 05                	jne    8018d2 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8018cd:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8018d0:	c9                   	leave  
  8018d1:	c3                   	ret    
		return -E_NOT_SUPP;
  8018d2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018d7:	eb f7                	jmp    8018d0 <fd2sockid+0x27>

008018d9 <alloc_sockfd>:
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
  8018dc:	56                   	push   %esi
  8018dd:	53                   	push   %ebx
  8018de:	83 ec 1c             	sub    $0x1c,%esp
  8018e1:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8018e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018e6:	50                   	push   %eax
  8018e7:	e8 09 f7 ff ff       	call   800ff5 <fd_alloc>
  8018ec:	89 c3                	mov    %eax,%ebx
  8018ee:	83 c4 10             	add    $0x10,%esp
  8018f1:	85 c0                	test   %eax,%eax
  8018f3:	78 43                	js     801938 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8018f5:	83 ec 04             	sub    $0x4,%esp
  8018f8:	68 07 04 00 00       	push   $0x407
  8018fd:	ff 75 f4             	pushl  -0xc(%ebp)
  801900:	6a 00                	push   $0x0
  801902:	e8 66 f3 ff ff       	call   800c6d <sys_page_alloc>
  801907:	89 c3                	mov    %eax,%ebx
  801909:	83 c4 10             	add    $0x10,%esp
  80190c:	85 c0                	test   %eax,%eax
  80190e:	78 28                	js     801938 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801910:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801913:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801919:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80191b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801925:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801928:	83 ec 0c             	sub    $0xc,%esp
  80192b:	50                   	push   %eax
  80192c:	e8 95 f6 ff ff       	call   800fc6 <fd2num>
  801931:	89 c3                	mov    %eax,%ebx
  801933:	83 c4 10             	add    $0x10,%esp
  801936:	eb 0c                	jmp    801944 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801938:	83 ec 0c             	sub    $0xc,%esp
  80193b:	56                   	push   %esi
  80193c:	e8 08 02 00 00       	call   801b49 <nsipc_close>
		return r;
  801941:	83 c4 10             	add    $0x10,%esp
}
  801944:	89 d8                	mov    %ebx,%eax
  801946:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801949:	5b                   	pop    %ebx
  80194a:	5e                   	pop    %esi
  80194b:	5d                   	pop    %ebp
  80194c:	c3                   	ret    

0080194d <accept>:
{
  80194d:	f3 0f 1e fb          	endbr32 
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
  801954:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801957:	8b 45 08             	mov    0x8(%ebp),%eax
  80195a:	e8 4a ff ff ff       	call   8018a9 <fd2sockid>
  80195f:	85 c0                	test   %eax,%eax
  801961:	78 1b                	js     80197e <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801963:	83 ec 04             	sub    $0x4,%esp
  801966:	ff 75 10             	pushl  0x10(%ebp)
  801969:	ff 75 0c             	pushl  0xc(%ebp)
  80196c:	50                   	push   %eax
  80196d:	e8 22 01 00 00       	call   801a94 <nsipc_accept>
  801972:	83 c4 10             	add    $0x10,%esp
  801975:	85 c0                	test   %eax,%eax
  801977:	78 05                	js     80197e <accept+0x31>
	return alloc_sockfd(r);
  801979:	e8 5b ff ff ff       	call   8018d9 <alloc_sockfd>
}
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <bind>:
{
  801980:	f3 0f 1e fb          	endbr32 
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
  801987:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80198a:	8b 45 08             	mov    0x8(%ebp),%eax
  80198d:	e8 17 ff ff ff       	call   8018a9 <fd2sockid>
  801992:	85 c0                	test   %eax,%eax
  801994:	78 12                	js     8019a8 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801996:	83 ec 04             	sub    $0x4,%esp
  801999:	ff 75 10             	pushl  0x10(%ebp)
  80199c:	ff 75 0c             	pushl  0xc(%ebp)
  80199f:	50                   	push   %eax
  8019a0:	e8 45 01 00 00       	call   801aea <nsipc_bind>
  8019a5:	83 c4 10             	add    $0x10,%esp
}
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <shutdown>:
{
  8019aa:	f3 0f 1e fb          	endbr32 
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
  8019b1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b7:	e8 ed fe ff ff       	call   8018a9 <fd2sockid>
  8019bc:	85 c0                	test   %eax,%eax
  8019be:	78 0f                	js     8019cf <shutdown+0x25>
	return nsipc_shutdown(r, how);
  8019c0:	83 ec 08             	sub    $0x8,%esp
  8019c3:	ff 75 0c             	pushl  0xc(%ebp)
  8019c6:	50                   	push   %eax
  8019c7:	e8 57 01 00 00       	call   801b23 <nsipc_shutdown>
  8019cc:	83 c4 10             	add    $0x10,%esp
}
  8019cf:	c9                   	leave  
  8019d0:	c3                   	ret    

008019d1 <connect>:
{
  8019d1:	f3 0f 1e fb          	endbr32 
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
  8019d8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019db:	8b 45 08             	mov    0x8(%ebp),%eax
  8019de:	e8 c6 fe ff ff       	call   8018a9 <fd2sockid>
  8019e3:	85 c0                	test   %eax,%eax
  8019e5:	78 12                	js     8019f9 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  8019e7:	83 ec 04             	sub    $0x4,%esp
  8019ea:	ff 75 10             	pushl  0x10(%ebp)
  8019ed:	ff 75 0c             	pushl  0xc(%ebp)
  8019f0:	50                   	push   %eax
  8019f1:	e8 71 01 00 00       	call   801b67 <nsipc_connect>
  8019f6:	83 c4 10             	add    $0x10,%esp
}
  8019f9:	c9                   	leave  
  8019fa:	c3                   	ret    

008019fb <listen>:
{
  8019fb:	f3 0f 1e fb          	endbr32 
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
  801a02:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a05:	8b 45 08             	mov    0x8(%ebp),%eax
  801a08:	e8 9c fe ff ff       	call   8018a9 <fd2sockid>
  801a0d:	85 c0                	test   %eax,%eax
  801a0f:	78 0f                	js     801a20 <listen+0x25>
	return nsipc_listen(r, backlog);
  801a11:	83 ec 08             	sub    $0x8,%esp
  801a14:	ff 75 0c             	pushl  0xc(%ebp)
  801a17:	50                   	push   %eax
  801a18:	e8 83 01 00 00       	call   801ba0 <nsipc_listen>
  801a1d:	83 c4 10             	add    $0x10,%esp
}
  801a20:	c9                   	leave  
  801a21:	c3                   	ret    

00801a22 <socket>:

int
socket(int domain, int type, int protocol)
{
  801a22:	f3 0f 1e fb          	endbr32 
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
  801a29:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a2c:	ff 75 10             	pushl  0x10(%ebp)
  801a2f:	ff 75 0c             	pushl  0xc(%ebp)
  801a32:	ff 75 08             	pushl  0x8(%ebp)
  801a35:	e8 65 02 00 00       	call   801c9f <nsipc_socket>
  801a3a:	83 c4 10             	add    $0x10,%esp
  801a3d:	85 c0                	test   %eax,%eax
  801a3f:	78 05                	js     801a46 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801a41:	e8 93 fe ff ff       	call   8018d9 <alloc_sockfd>
}
  801a46:	c9                   	leave  
  801a47:	c3                   	ret    

00801a48 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
  801a4b:	53                   	push   %ebx
  801a4c:	83 ec 04             	sub    $0x4,%esp
  801a4f:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a51:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a58:	74 26                	je     801a80 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a5a:	6a 07                	push   $0x7
  801a5c:	68 00 60 80 00       	push   $0x806000
  801a61:	53                   	push   %ebx
  801a62:	ff 35 04 40 80 00    	pushl  0x804004
  801a68:	e8 e0 07 00 00       	call   80224d <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a6d:	83 c4 0c             	add    $0xc,%esp
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	e8 4d 07 00 00       	call   8021c8 <ipc_recv>
}
  801a7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a7e:	c9                   	leave  
  801a7f:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a80:	83 ec 0c             	sub    $0xc,%esp
  801a83:	6a 02                	push   $0x2
  801a85:	e8 1b 08 00 00       	call   8022a5 <ipc_find_env>
  801a8a:	a3 04 40 80 00       	mov    %eax,0x804004
  801a8f:	83 c4 10             	add    $0x10,%esp
  801a92:	eb c6                	jmp    801a5a <nsipc+0x12>

00801a94 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a94:	f3 0f 1e fb          	endbr32 
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
  801a9b:	56                   	push   %esi
  801a9c:	53                   	push   %ebx
  801a9d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801aa8:	8b 06                	mov    (%esi),%eax
  801aaa:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801aaf:	b8 01 00 00 00       	mov    $0x1,%eax
  801ab4:	e8 8f ff ff ff       	call   801a48 <nsipc>
  801ab9:	89 c3                	mov    %eax,%ebx
  801abb:	85 c0                	test   %eax,%eax
  801abd:	79 09                	jns    801ac8 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801abf:	89 d8                	mov    %ebx,%eax
  801ac1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ac4:	5b                   	pop    %ebx
  801ac5:	5e                   	pop    %esi
  801ac6:	5d                   	pop    %ebp
  801ac7:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ac8:	83 ec 04             	sub    $0x4,%esp
  801acb:	ff 35 10 60 80 00    	pushl  0x806010
  801ad1:	68 00 60 80 00       	push   $0x806000
  801ad6:	ff 75 0c             	pushl  0xc(%ebp)
  801ad9:	e8 03 ef ff ff       	call   8009e1 <memmove>
		*addrlen = ret->ret_addrlen;
  801ade:	a1 10 60 80 00       	mov    0x806010,%eax
  801ae3:	89 06                	mov    %eax,(%esi)
  801ae5:	83 c4 10             	add    $0x10,%esp
	return r;
  801ae8:	eb d5                	jmp    801abf <nsipc_accept+0x2b>

00801aea <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801aea:	f3 0f 1e fb          	endbr32 
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
  801af1:	53                   	push   %ebx
  801af2:	83 ec 08             	sub    $0x8,%esp
  801af5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801af8:	8b 45 08             	mov    0x8(%ebp),%eax
  801afb:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b00:	53                   	push   %ebx
  801b01:	ff 75 0c             	pushl  0xc(%ebp)
  801b04:	68 04 60 80 00       	push   $0x806004
  801b09:	e8 d3 ee ff ff       	call   8009e1 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b0e:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b14:	b8 02 00 00 00       	mov    $0x2,%eax
  801b19:	e8 2a ff ff ff       	call   801a48 <nsipc>
}
  801b1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b21:	c9                   	leave  
  801b22:	c3                   	ret    

00801b23 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b23:	f3 0f 1e fb          	endbr32 
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
  801b2a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b30:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b38:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b3d:	b8 03 00 00 00       	mov    $0x3,%eax
  801b42:	e8 01 ff ff ff       	call   801a48 <nsipc>
}
  801b47:	c9                   	leave  
  801b48:	c3                   	ret    

00801b49 <nsipc_close>:

int
nsipc_close(int s)
{
  801b49:	f3 0f 1e fb          	endbr32 
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
  801b50:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b53:	8b 45 08             	mov    0x8(%ebp),%eax
  801b56:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b5b:	b8 04 00 00 00       	mov    $0x4,%eax
  801b60:	e8 e3 fe ff ff       	call   801a48 <nsipc>
}
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b67:	f3 0f 1e fb          	endbr32 
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
  801b6e:	53                   	push   %ebx
  801b6f:	83 ec 08             	sub    $0x8,%esp
  801b72:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b75:	8b 45 08             	mov    0x8(%ebp),%eax
  801b78:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b7d:	53                   	push   %ebx
  801b7e:	ff 75 0c             	pushl  0xc(%ebp)
  801b81:	68 04 60 80 00       	push   $0x806004
  801b86:	e8 56 ee ff ff       	call   8009e1 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b8b:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b91:	b8 05 00 00 00       	mov    $0x5,%eax
  801b96:	e8 ad fe ff ff       	call   801a48 <nsipc>
}
  801b9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    

00801ba0 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801ba0:	f3 0f 1e fb          	endbr32 
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
  801ba7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801baa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bad:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb5:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801bba:	b8 06 00 00 00       	mov    $0x6,%eax
  801bbf:	e8 84 fe ff ff       	call   801a48 <nsipc>
}
  801bc4:	c9                   	leave  
  801bc5:	c3                   	ret    

00801bc6 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801bc6:	f3 0f 1e fb          	endbr32 
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
  801bcd:	56                   	push   %esi
  801bce:	53                   	push   %ebx
  801bcf:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd5:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801bda:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801be0:	8b 45 14             	mov    0x14(%ebp),%eax
  801be3:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801be8:	b8 07 00 00 00       	mov    $0x7,%eax
  801bed:	e8 56 fe ff ff       	call   801a48 <nsipc>
  801bf2:	89 c3                	mov    %eax,%ebx
  801bf4:	85 c0                	test   %eax,%eax
  801bf6:	78 26                	js     801c1e <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801bf8:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801bfe:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801c03:	0f 4e c6             	cmovle %esi,%eax
  801c06:	39 c3                	cmp    %eax,%ebx
  801c08:	7f 1d                	jg     801c27 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c0a:	83 ec 04             	sub    $0x4,%esp
  801c0d:	53                   	push   %ebx
  801c0e:	68 00 60 80 00       	push   $0x806000
  801c13:	ff 75 0c             	pushl  0xc(%ebp)
  801c16:	e8 c6 ed ff ff       	call   8009e1 <memmove>
  801c1b:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c1e:	89 d8                	mov    %ebx,%eax
  801c20:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c23:	5b                   	pop    %ebx
  801c24:	5e                   	pop    %esi
  801c25:	5d                   	pop    %ebp
  801c26:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c27:	68 af 2a 80 00       	push   $0x802aaf
  801c2c:	68 77 2a 80 00       	push   $0x802a77
  801c31:	6a 62                	push   $0x62
  801c33:	68 c4 2a 80 00       	push   $0x802ac4
  801c38:	e8 fd e4 ff ff       	call   80013a <_panic>

00801c3d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c3d:	f3 0f 1e fb          	endbr32 
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
  801c44:	53                   	push   %ebx
  801c45:	83 ec 04             	sub    $0x4,%esp
  801c48:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4e:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c53:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c59:	7f 2e                	jg     801c89 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c5b:	83 ec 04             	sub    $0x4,%esp
  801c5e:	53                   	push   %ebx
  801c5f:	ff 75 0c             	pushl  0xc(%ebp)
  801c62:	68 0c 60 80 00       	push   $0x80600c
  801c67:	e8 75 ed ff ff       	call   8009e1 <memmove>
	nsipcbuf.send.req_size = size;
  801c6c:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c72:	8b 45 14             	mov    0x14(%ebp),%eax
  801c75:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c7a:	b8 08 00 00 00       	mov    $0x8,%eax
  801c7f:	e8 c4 fd ff ff       	call   801a48 <nsipc>
}
  801c84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    
	assert(size < 1600);
  801c89:	68 d0 2a 80 00       	push   $0x802ad0
  801c8e:	68 77 2a 80 00       	push   $0x802a77
  801c93:	6a 6d                	push   $0x6d
  801c95:	68 c4 2a 80 00       	push   $0x802ac4
  801c9a:	e8 9b e4 ff ff       	call   80013a <_panic>

00801c9f <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c9f:	f3 0f 1e fb          	endbr32 
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
  801ca6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cac:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801cb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb4:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801cb9:	8b 45 10             	mov    0x10(%ebp),%eax
  801cbc:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801cc1:	b8 09 00 00 00       	mov    $0x9,%eax
  801cc6:	e8 7d fd ff ff       	call   801a48 <nsipc>
}
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ccd:	f3 0f 1e fb          	endbr32 
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
  801cd4:	56                   	push   %esi
  801cd5:	53                   	push   %ebx
  801cd6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cd9:	83 ec 0c             	sub    $0xc,%esp
  801cdc:	ff 75 08             	pushl  0x8(%ebp)
  801cdf:	e8 f6 f2 ff ff       	call   800fda <fd2data>
  801ce4:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ce6:	83 c4 08             	add    $0x8,%esp
  801ce9:	68 dc 2a 80 00       	push   $0x802adc
  801cee:	53                   	push   %ebx
  801cef:	e8 37 eb ff ff       	call   80082b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cf4:	8b 46 04             	mov    0x4(%esi),%eax
  801cf7:	2b 06                	sub    (%esi),%eax
  801cf9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801cff:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d06:	00 00 00 
	stat->st_dev = &devpipe;
  801d09:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d10:	30 80 00 
	return 0;
}
  801d13:	b8 00 00 00 00       	mov    $0x0,%eax
  801d18:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d1b:	5b                   	pop    %ebx
  801d1c:	5e                   	pop    %esi
  801d1d:	5d                   	pop    %ebp
  801d1e:	c3                   	ret    

00801d1f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d1f:	f3 0f 1e fb          	endbr32 
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
  801d26:	53                   	push   %ebx
  801d27:	83 ec 0c             	sub    $0xc,%esp
  801d2a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d2d:	53                   	push   %ebx
  801d2e:	6a 00                	push   $0x0
  801d30:	e8 c5 ef ff ff       	call   800cfa <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d35:	89 1c 24             	mov    %ebx,(%esp)
  801d38:	e8 9d f2 ff ff       	call   800fda <fd2data>
  801d3d:	83 c4 08             	add    $0x8,%esp
  801d40:	50                   	push   %eax
  801d41:	6a 00                	push   $0x0
  801d43:	e8 b2 ef ff ff       	call   800cfa <sys_page_unmap>
}
  801d48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d4b:	c9                   	leave  
  801d4c:	c3                   	ret    

00801d4d <_pipeisclosed>:
{
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
  801d50:	57                   	push   %edi
  801d51:	56                   	push   %esi
  801d52:	53                   	push   %ebx
  801d53:	83 ec 1c             	sub    $0x1c,%esp
  801d56:	89 c7                	mov    %eax,%edi
  801d58:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d5a:	a1 08 40 80 00       	mov    0x804008,%eax
  801d5f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d62:	83 ec 0c             	sub    $0xc,%esp
  801d65:	57                   	push   %edi
  801d66:	e8 77 05 00 00       	call   8022e2 <pageref>
  801d6b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d6e:	89 34 24             	mov    %esi,(%esp)
  801d71:	e8 6c 05 00 00       	call   8022e2 <pageref>
		nn = thisenv->env_runs;
  801d76:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d7c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d7f:	83 c4 10             	add    $0x10,%esp
  801d82:	39 cb                	cmp    %ecx,%ebx
  801d84:	74 1b                	je     801da1 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d86:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d89:	75 cf                	jne    801d5a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d8b:	8b 42 58             	mov    0x58(%edx),%eax
  801d8e:	6a 01                	push   $0x1
  801d90:	50                   	push   %eax
  801d91:	53                   	push   %ebx
  801d92:	68 e3 2a 80 00       	push   $0x802ae3
  801d97:	e8 85 e4 ff ff       	call   800221 <cprintf>
  801d9c:	83 c4 10             	add    $0x10,%esp
  801d9f:	eb b9                	jmp    801d5a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801da1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801da4:	0f 94 c0             	sete   %al
  801da7:	0f b6 c0             	movzbl %al,%eax
}
  801daa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dad:	5b                   	pop    %ebx
  801dae:	5e                   	pop    %esi
  801daf:	5f                   	pop    %edi
  801db0:	5d                   	pop    %ebp
  801db1:	c3                   	ret    

00801db2 <devpipe_write>:
{
  801db2:	f3 0f 1e fb          	endbr32 
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
  801db9:	57                   	push   %edi
  801dba:	56                   	push   %esi
  801dbb:	53                   	push   %ebx
  801dbc:	83 ec 28             	sub    $0x28,%esp
  801dbf:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801dc2:	56                   	push   %esi
  801dc3:	e8 12 f2 ff ff       	call   800fda <fd2data>
  801dc8:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dca:	83 c4 10             	add    $0x10,%esp
  801dcd:	bf 00 00 00 00       	mov    $0x0,%edi
  801dd2:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801dd5:	74 4f                	je     801e26 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801dd7:	8b 43 04             	mov    0x4(%ebx),%eax
  801dda:	8b 0b                	mov    (%ebx),%ecx
  801ddc:	8d 51 20             	lea    0x20(%ecx),%edx
  801ddf:	39 d0                	cmp    %edx,%eax
  801de1:	72 14                	jb     801df7 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801de3:	89 da                	mov    %ebx,%edx
  801de5:	89 f0                	mov    %esi,%eax
  801de7:	e8 61 ff ff ff       	call   801d4d <_pipeisclosed>
  801dec:	85 c0                	test   %eax,%eax
  801dee:	75 3b                	jne    801e2b <devpipe_write+0x79>
			sys_yield();
  801df0:	e8 55 ee ff ff       	call   800c4a <sys_yield>
  801df5:	eb e0                	jmp    801dd7 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801df7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dfa:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801dfe:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e01:	89 c2                	mov    %eax,%edx
  801e03:	c1 fa 1f             	sar    $0x1f,%edx
  801e06:	89 d1                	mov    %edx,%ecx
  801e08:	c1 e9 1b             	shr    $0x1b,%ecx
  801e0b:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e0e:	83 e2 1f             	and    $0x1f,%edx
  801e11:	29 ca                	sub    %ecx,%edx
  801e13:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e17:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e1b:	83 c0 01             	add    $0x1,%eax
  801e1e:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e21:	83 c7 01             	add    $0x1,%edi
  801e24:	eb ac                	jmp    801dd2 <devpipe_write+0x20>
	return i;
  801e26:	8b 45 10             	mov    0x10(%ebp),%eax
  801e29:	eb 05                	jmp    801e30 <devpipe_write+0x7e>
				return 0;
  801e2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e33:	5b                   	pop    %ebx
  801e34:	5e                   	pop    %esi
  801e35:	5f                   	pop    %edi
  801e36:	5d                   	pop    %ebp
  801e37:	c3                   	ret    

00801e38 <devpipe_read>:
{
  801e38:	f3 0f 1e fb          	endbr32 
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
  801e3f:	57                   	push   %edi
  801e40:	56                   	push   %esi
  801e41:	53                   	push   %ebx
  801e42:	83 ec 18             	sub    $0x18,%esp
  801e45:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e48:	57                   	push   %edi
  801e49:	e8 8c f1 ff ff       	call   800fda <fd2data>
  801e4e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e50:	83 c4 10             	add    $0x10,%esp
  801e53:	be 00 00 00 00       	mov    $0x0,%esi
  801e58:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e5b:	75 14                	jne    801e71 <devpipe_read+0x39>
	return i;
  801e5d:	8b 45 10             	mov    0x10(%ebp),%eax
  801e60:	eb 02                	jmp    801e64 <devpipe_read+0x2c>
				return i;
  801e62:	89 f0                	mov    %esi,%eax
}
  801e64:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e67:	5b                   	pop    %ebx
  801e68:	5e                   	pop    %esi
  801e69:	5f                   	pop    %edi
  801e6a:	5d                   	pop    %ebp
  801e6b:	c3                   	ret    
			sys_yield();
  801e6c:	e8 d9 ed ff ff       	call   800c4a <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e71:	8b 03                	mov    (%ebx),%eax
  801e73:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e76:	75 18                	jne    801e90 <devpipe_read+0x58>
			if (i > 0)
  801e78:	85 f6                	test   %esi,%esi
  801e7a:	75 e6                	jne    801e62 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801e7c:	89 da                	mov    %ebx,%edx
  801e7e:	89 f8                	mov    %edi,%eax
  801e80:	e8 c8 fe ff ff       	call   801d4d <_pipeisclosed>
  801e85:	85 c0                	test   %eax,%eax
  801e87:	74 e3                	je     801e6c <devpipe_read+0x34>
				return 0;
  801e89:	b8 00 00 00 00       	mov    $0x0,%eax
  801e8e:	eb d4                	jmp    801e64 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e90:	99                   	cltd   
  801e91:	c1 ea 1b             	shr    $0x1b,%edx
  801e94:	01 d0                	add    %edx,%eax
  801e96:	83 e0 1f             	and    $0x1f,%eax
  801e99:	29 d0                	sub    %edx,%eax
  801e9b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ea0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ea3:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801ea6:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801ea9:	83 c6 01             	add    $0x1,%esi
  801eac:	eb aa                	jmp    801e58 <devpipe_read+0x20>

00801eae <pipe>:
{
  801eae:	f3 0f 1e fb          	endbr32 
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
  801eb5:	56                   	push   %esi
  801eb6:	53                   	push   %ebx
  801eb7:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801eba:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ebd:	50                   	push   %eax
  801ebe:	e8 32 f1 ff ff       	call   800ff5 <fd_alloc>
  801ec3:	89 c3                	mov    %eax,%ebx
  801ec5:	83 c4 10             	add    $0x10,%esp
  801ec8:	85 c0                	test   %eax,%eax
  801eca:	0f 88 23 01 00 00    	js     801ff3 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ed0:	83 ec 04             	sub    $0x4,%esp
  801ed3:	68 07 04 00 00       	push   $0x407
  801ed8:	ff 75 f4             	pushl  -0xc(%ebp)
  801edb:	6a 00                	push   $0x0
  801edd:	e8 8b ed ff ff       	call   800c6d <sys_page_alloc>
  801ee2:	89 c3                	mov    %eax,%ebx
  801ee4:	83 c4 10             	add    $0x10,%esp
  801ee7:	85 c0                	test   %eax,%eax
  801ee9:	0f 88 04 01 00 00    	js     801ff3 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801eef:	83 ec 0c             	sub    $0xc,%esp
  801ef2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ef5:	50                   	push   %eax
  801ef6:	e8 fa f0 ff ff       	call   800ff5 <fd_alloc>
  801efb:	89 c3                	mov    %eax,%ebx
  801efd:	83 c4 10             	add    $0x10,%esp
  801f00:	85 c0                	test   %eax,%eax
  801f02:	0f 88 db 00 00 00    	js     801fe3 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f08:	83 ec 04             	sub    $0x4,%esp
  801f0b:	68 07 04 00 00       	push   $0x407
  801f10:	ff 75 f0             	pushl  -0x10(%ebp)
  801f13:	6a 00                	push   $0x0
  801f15:	e8 53 ed ff ff       	call   800c6d <sys_page_alloc>
  801f1a:	89 c3                	mov    %eax,%ebx
  801f1c:	83 c4 10             	add    $0x10,%esp
  801f1f:	85 c0                	test   %eax,%eax
  801f21:	0f 88 bc 00 00 00    	js     801fe3 <pipe+0x135>
	va = fd2data(fd0);
  801f27:	83 ec 0c             	sub    $0xc,%esp
  801f2a:	ff 75 f4             	pushl  -0xc(%ebp)
  801f2d:	e8 a8 f0 ff ff       	call   800fda <fd2data>
  801f32:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f34:	83 c4 0c             	add    $0xc,%esp
  801f37:	68 07 04 00 00       	push   $0x407
  801f3c:	50                   	push   %eax
  801f3d:	6a 00                	push   $0x0
  801f3f:	e8 29 ed ff ff       	call   800c6d <sys_page_alloc>
  801f44:	89 c3                	mov    %eax,%ebx
  801f46:	83 c4 10             	add    $0x10,%esp
  801f49:	85 c0                	test   %eax,%eax
  801f4b:	0f 88 82 00 00 00    	js     801fd3 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f51:	83 ec 0c             	sub    $0xc,%esp
  801f54:	ff 75 f0             	pushl  -0x10(%ebp)
  801f57:	e8 7e f0 ff ff       	call   800fda <fd2data>
  801f5c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f63:	50                   	push   %eax
  801f64:	6a 00                	push   $0x0
  801f66:	56                   	push   %esi
  801f67:	6a 00                	push   $0x0
  801f69:	e8 46 ed ff ff       	call   800cb4 <sys_page_map>
  801f6e:	89 c3                	mov    %eax,%ebx
  801f70:	83 c4 20             	add    $0x20,%esp
  801f73:	85 c0                	test   %eax,%eax
  801f75:	78 4e                	js     801fc5 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801f77:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f7f:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f84:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f8b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f8e:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f93:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f9a:	83 ec 0c             	sub    $0xc,%esp
  801f9d:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa0:	e8 21 f0 ff ff       	call   800fc6 <fd2num>
  801fa5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fa8:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801faa:	83 c4 04             	add    $0x4,%esp
  801fad:	ff 75 f0             	pushl  -0x10(%ebp)
  801fb0:	e8 11 f0 ff ff       	call   800fc6 <fd2num>
  801fb5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fb8:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801fbb:	83 c4 10             	add    $0x10,%esp
  801fbe:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fc3:	eb 2e                	jmp    801ff3 <pipe+0x145>
	sys_page_unmap(0, va);
  801fc5:	83 ec 08             	sub    $0x8,%esp
  801fc8:	56                   	push   %esi
  801fc9:	6a 00                	push   $0x0
  801fcb:	e8 2a ed ff ff       	call   800cfa <sys_page_unmap>
  801fd0:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801fd3:	83 ec 08             	sub    $0x8,%esp
  801fd6:	ff 75 f0             	pushl  -0x10(%ebp)
  801fd9:	6a 00                	push   $0x0
  801fdb:	e8 1a ed ff ff       	call   800cfa <sys_page_unmap>
  801fe0:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801fe3:	83 ec 08             	sub    $0x8,%esp
  801fe6:	ff 75 f4             	pushl  -0xc(%ebp)
  801fe9:	6a 00                	push   $0x0
  801feb:	e8 0a ed ff ff       	call   800cfa <sys_page_unmap>
  801ff0:	83 c4 10             	add    $0x10,%esp
}
  801ff3:	89 d8                	mov    %ebx,%eax
  801ff5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ff8:	5b                   	pop    %ebx
  801ff9:	5e                   	pop    %esi
  801ffa:	5d                   	pop    %ebp
  801ffb:	c3                   	ret    

00801ffc <pipeisclosed>:
{
  801ffc:	f3 0f 1e fb          	endbr32 
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
  802003:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802006:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802009:	50                   	push   %eax
  80200a:	ff 75 08             	pushl  0x8(%ebp)
  80200d:	e8 39 f0 ff ff       	call   80104b <fd_lookup>
  802012:	83 c4 10             	add    $0x10,%esp
  802015:	85 c0                	test   %eax,%eax
  802017:	78 18                	js     802031 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802019:	83 ec 0c             	sub    $0xc,%esp
  80201c:	ff 75 f4             	pushl  -0xc(%ebp)
  80201f:	e8 b6 ef ff ff       	call   800fda <fd2data>
  802024:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802026:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802029:	e8 1f fd ff ff       	call   801d4d <_pipeisclosed>
  80202e:	83 c4 10             	add    $0x10,%esp
}
  802031:	c9                   	leave  
  802032:	c3                   	ret    

00802033 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802033:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  802037:	b8 00 00 00 00       	mov    $0x0,%eax
  80203c:	c3                   	ret    

0080203d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80203d:	f3 0f 1e fb          	endbr32 
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
  802044:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802047:	68 fb 2a 80 00       	push   $0x802afb
  80204c:	ff 75 0c             	pushl  0xc(%ebp)
  80204f:	e8 d7 e7 ff ff       	call   80082b <strcpy>
	return 0;
}
  802054:	b8 00 00 00 00       	mov    $0x0,%eax
  802059:	c9                   	leave  
  80205a:	c3                   	ret    

0080205b <devcons_write>:
{
  80205b:	f3 0f 1e fb          	endbr32 
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
  802062:	57                   	push   %edi
  802063:	56                   	push   %esi
  802064:	53                   	push   %ebx
  802065:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80206b:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802070:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802076:	3b 75 10             	cmp    0x10(%ebp),%esi
  802079:	73 31                	jae    8020ac <devcons_write+0x51>
		m = n - tot;
  80207b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80207e:	29 f3                	sub    %esi,%ebx
  802080:	83 fb 7f             	cmp    $0x7f,%ebx
  802083:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802088:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80208b:	83 ec 04             	sub    $0x4,%esp
  80208e:	53                   	push   %ebx
  80208f:	89 f0                	mov    %esi,%eax
  802091:	03 45 0c             	add    0xc(%ebp),%eax
  802094:	50                   	push   %eax
  802095:	57                   	push   %edi
  802096:	e8 46 e9 ff ff       	call   8009e1 <memmove>
		sys_cputs(buf, m);
  80209b:	83 c4 08             	add    $0x8,%esp
  80209e:	53                   	push   %ebx
  80209f:	57                   	push   %edi
  8020a0:	e8 f8 ea ff ff       	call   800b9d <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8020a5:	01 de                	add    %ebx,%esi
  8020a7:	83 c4 10             	add    $0x10,%esp
  8020aa:	eb ca                	jmp    802076 <devcons_write+0x1b>
}
  8020ac:	89 f0                	mov    %esi,%eax
  8020ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020b1:	5b                   	pop    %ebx
  8020b2:	5e                   	pop    %esi
  8020b3:	5f                   	pop    %edi
  8020b4:	5d                   	pop    %ebp
  8020b5:	c3                   	ret    

008020b6 <devcons_read>:
{
  8020b6:	f3 0f 1e fb          	endbr32 
  8020ba:	55                   	push   %ebp
  8020bb:	89 e5                	mov    %esp,%ebp
  8020bd:	83 ec 08             	sub    $0x8,%esp
  8020c0:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8020c5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020c9:	74 21                	je     8020ec <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8020cb:	e8 ef ea ff ff       	call   800bbf <sys_cgetc>
  8020d0:	85 c0                	test   %eax,%eax
  8020d2:	75 07                	jne    8020db <devcons_read+0x25>
		sys_yield();
  8020d4:	e8 71 eb ff ff       	call   800c4a <sys_yield>
  8020d9:	eb f0                	jmp    8020cb <devcons_read+0x15>
	if (c < 0)
  8020db:	78 0f                	js     8020ec <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8020dd:	83 f8 04             	cmp    $0x4,%eax
  8020e0:	74 0c                	je     8020ee <devcons_read+0x38>
	*(char*)vbuf = c;
  8020e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e5:	88 02                	mov    %al,(%edx)
	return 1;
  8020e7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020ec:	c9                   	leave  
  8020ed:	c3                   	ret    
		return 0;
  8020ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f3:	eb f7                	jmp    8020ec <devcons_read+0x36>

008020f5 <cputchar>:
{
  8020f5:	f3 0f 1e fb          	endbr32 
  8020f9:	55                   	push   %ebp
  8020fa:	89 e5                	mov    %esp,%ebp
  8020fc:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802102:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802105:	6a 01                	push   $0x1
  802107:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80210a:	50                   	push   %eax
  80210b:	e8 8d ea ff ff       	call   800b9d <sys_cputs>
}
  802110:	83 c4 10             	add    $0x10,%esp
  802113:	c9                   	leave  
  802114:	c3                   	ret    

00802115 <getchar>:
{
  802115:	f3 0f 1e fb          	endbr32 
  802119:	55                   	push   %ebp
  80211a:	89 e5                	mov    %esp,%ebp
  80211c:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80211f:	6a 01                	push   $0x1
  802121:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802124:	50                   	push   %eax
  802125:	6a 00                	push   $0x0
  802127:	e8 a7 f1 ff ff       	call   8012d3 <read>
	if (r < 0)
  80212c:	83 c4 10             	add    $0x10,%esp
  80212f:	85 c0                	test   %eax,%eax
  802131:	78 06                	js     802139 <getchar+0x24>
	if (r < 1)
  802133:	74 06                	je     80213b <getchar+0x26>
	return c;
  802135:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802139:	c9                   	leave  
  80213a:	c3                   	ret    
		return -E_EOF;
  80213b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802140:	eb f7                	jmp    802139 <getchar+0x24>

00802142 <iscons>:
{
  802142:	f3 0f 1e fb          	endbr32 
  802146:	55                   	push   %ebp
  802147:	89 e5                	mov    %esp,%ebp
  802149:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80214c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80214f:	50                   	push   %eax
  802150:	ff 75 08             	pushl  0x8(%ebp)
  802153:	e8 f3 ee ff ff       	call   80104b <fd_lookup>
  802158:	83 c4 10             	add    $0x10,%esp
  80215b:	85 c0                	test   %eax,%eax
  80215d:	78 11                	js     802170 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80215f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802162:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802168:	39 10                	cmp    %edx,(%eax)
  80216a:	0f 94 c0             	sete   %al
  80216d:	0f b6 c0             	movzbl %al,%eax
}
  802170:	c9                   	leave  
  802171:	c3                   	ret    

00802172 <opencons>:
{
  802172:	f3 0f 1e fb          	endbr32 
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
  802179:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80217c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80217f:	50                   	push   %eax
  802180:	e8 70 ee ff ff       	call   800ff5 <fd_alloc>
  802185:	83 c4 10             	add    $0x10,%esp
  802188:	85 c0                	test   %eax,%eax
  80218a:	78 3a                	js     8021c6 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80218c:	83 ec 04             	sub    $0x4,%esp
  80218f:	68 07 04 00 00       	push   $0x407
  802194:	ff 75 f4             	pushl  -0xc(%ebp)
  802197:	6a 00                	push   $0x0
  802199:	e8 cf ea ff ff       	call   800c6d <sys_page_alloc>
  80219e:	83 c4 10             	add    $0x10,%esp
  8021a1:	85 c0                	test   %eax,%eax
  8021a3:	78 21                	js     8021c6 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8021a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a8:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021ae:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8021b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8021ba:	83 ec 0c             	sub    $0xc,%esp
  8021bd:	50                   	push   %eax
  8021be:	e8 03 ee ff ff       	call   800fc6 <fd2num>
  8021c3:	83 c4 10             	add    $0x10,%esp
}
  8021c6:	c9                   	leave  
  8021c7:	c3                   	ret    

008021c8 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021c8:	f3 0f 1e fb          	endbr32 
  8021cc:	55                   	push   %ebp
  8021cd:	89 e5                	mov    %esp,%ebp
  8021cf:	56                   	push   %esi
  8021d0:	53                   	push   %ebx
  8021d1:	8b 75 08             	mov    0x8(%ebp),%esi
  8021d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  8021da:	85 c0                	test   %eax,%eax
  8021dc:	74 3d                	je     80221b <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  8021de:	83 ec 0c             	sub    $0xc,%esp
  8021e1:	50                   	push   %eax
  8021e2:	e8 52 ec ff ff       	call   800e39 <sys_ipc_recv>
  8021e7:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  8021ea:	85 f6                	test   %esi,%esi
  8021ec:	74 0b                	je     8021f9 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8021ee:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8021f4:	8b 52 74             	mov    0x74(%edx),%edx
  8021f7:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  8021f9:	85 db                	test   %ebx,%ebx
  8021fb:	74 0b                	je     802208 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  8021fd:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802203:	8b 52 78             	mov    0x78(%edx),%edx
  802206:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  802208:	85 c0                	test   %eax,%eax
  80220a:	78 21                	js     80222d <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  80220c:	a1 08 40 80 00       	mov    0x804008,%eax
  802211:	8b 40 70             	mov    0x70(%eax),%eax
}
  802214:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802217:	5b                   	pop    %ebx
  802218:	5e                   	pop    %esi
  802219:	5d                   	pop    %ebp
  80221a:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  80221b:	83 ec 0c             	sub    $0xc,%esp
  80221e:	68 00 00 c0 ee       	push   $0xeec00000
  802223:	e8 11 ec ff ff       	call   800e39 <sys_ipc_recv>
  802228:	83 c4 10             	add    $0x10,%esp
  80222b:	eb bd                	jmp    8021ea <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  80222d:	85 f6                	test   %esi,%esi
  80222f:	74 10                	je     802241 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  802231:	85 db                	test   %ebx,%ebx
  802233:	75 df                	jne    802214 <ipc_recv+0x4c>
  802235:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80223c:	00 00 00 
  80223f:	eb d3                	jmp    802214 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  802241:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802248:	00 00 00 
  80224b:	eb e4                	jmp    802231 <ipc_recv+0x69>

0080224d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80224d:	f3 0f 1e fb          	endbr32 
  802251:	55                   	push   %ebp
  802252:	89 e5                	mov    %esp,%ebp
  802254:	57                   	push   %edi
  802255:	56                   	push   %esi
  802256:	53                   	push   %ebx
  802257:	83 ec 0c             	sub    $0xc,%esp
  80225a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80225d:	8b 75 0c             	mov    0xc(%ebp),%esi
  802260:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  802263:	85 db                	test   %ebx,%ebx
  802265:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80226a:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  80226d:	ff 75 14             	pushl  0x14(%ebp)
  802270:	53                   	push   %ebx
  802271:	56                   	push   %esi
  802272:	57                   	push   %edi
  802273:	e8 9a eb ff ff       	call   800e12 <sys_ipc_try_send>
  802278:	83 c4 10             	add    $0x10,%esp
  80227b:	85 c0                	test   %eax,%eax
  80227d:	79 1e                	jns    80229d <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  80227f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802282:	75 07                	jne    80228b <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  802284:	e8 c1 e9 ff ff       	call   800c4a <sys_yield>
  802289:	eb e2                	jmp    80226d <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  80228b:	50                   	push   %eax
  80228c:	68 07 2b 80 00       	push   $0x802b07
  802291:	6a 59                	push   $0x59
  802293:	68 22 2b 80 00       	push   $0x802b22
  802298:	e8 9d de ff ff       	call   80013a <_panic>
	}
}
  80229d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022a0:	5b                   	pop    %ebx
  8022a1:	5e                   	pop    %esi
  8022a2:	5f                   	pop    %edi
  8022a3:	5d                   	pop    %ebp
  8022a4:	c3                   	ret    

008022a5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022a5:	f3 0f 1e fb          	endbr32 
  8022a9:	55                   	push   %ebp
  8022aa:	89 e5                	mov    %esp,%ebp
  8022ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022af:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022b4:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8022b7:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022bd:	8b 52 50             	mov    0x50(%edx),%edx
  8022c0:	39 ca                	cmp    %ecx,%edx
  8022c2:	74 11                	je     8022d5 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8022c4:	83 c0 01             	add    $0x1,%eax
  8022c7:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022cc:	75 e6                	jne    8022b4 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8022ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d3:	eb 0b                	jmp    8022e0 <ipc_find_env+0x3b>
			return envs[i].env_id;
  8022d5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8022d8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022dd:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022e0:	5d                   	pop    %ebp
  8022e1:	c3                   	ret    

008022e2 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022e2:	f3 0f 1e fb          	endbr32 
  8022e6:	55                   	push   %ebp
  8022e7:	89 e5                	mov    %esp,%ebp
  8022e9:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022ec:	89 c2                	mov    %eax,%edx
  8022ee:	c1 ea 16             	shr    $0x16,%edx
  8022f1:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8022f8:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8022fd:	f6 c1 01             	test   $0x1,%cl
  802300:	74 1c                	je     80231e <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802302:	c1 e8 0c             	shr    $0xc,%eax
  802305:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80230c:	a8 01                	test   $0x1,%al
  80230e:	74 0e                	je     80231e <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802310:	c1 e8 0c             	shr    $0xc,%eax
  802313:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80231a:	ef 
  80231b:	0f b7 d2             	movzwl %dx,%edx
}
  80231e:	89 d0                	mov    %edx,%eax
  802320:	5d                   	pop    %ebp
  802321:	c3                   	ret    
  802322:	66 90                	xchg   %ax,%ax
  802324:	66 90                	xchg   %ax,%ax
  802326:	66 90                	xchg   %ax,%ax
  802328:	66 90                	xchg   %ax,%ax
  80232a:	66 90                	xchg   %ax,%ax
  80232c:	66 90                	xchg   %ax,%ax
  80232e:	66 90                	xchg   %ax,%ax

00802330 <__udivdi3>:
  802330:	f3 0f 1e fb          	endbr32 
  802334:	55                   	push   %ebp
  802335:	57                   	push   %edi
  802336:	56                   	push   %esi
  802337:	53                   	push   %ebx
  802338:	83 ec 1c             	sub    $0x1c,%esp
  80233b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80233f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802343:	8b 74 24 34          	mov    0x34(%esp),%esi
  802347:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80234b:	85 d2                	test   %edx,%edx
  80234d:	75 19                	jne    802368 <__udivdi3+0x38>
  80234f:	39 f3                	cmp    %esi,%ebx
  802351:	76 4d                	jbe    8023a0 <__udivdi3+0x70>
  802353:	31 ff                	xor    %edi,%edi
  802355:	89 e8                	mov    %ebp,%eax
  802357:	89 f2                	mov    %esi,%edx
  802359:	f7 f3                	div    %ebx
  80235b:	89 fa                	mov    %edi,%edx
  80235d:	83 c4 1c             	add    $0x1c,%esp
  802360:	5b                   	pop    %ebx
  802361:	5e                   	pop    %esi
  802362:	5f                   	pop    %edi
  802363:	5d                   	pop    %ebp
  802364:	c3                   	ret    
  802365:	8d 76 00             	lea    0x0(%esi),%esi
  802368:	39 f2                	cmp    %esi,%edx
  80236a:	76 14                	jbe    802380 <__udivdi3+0x50>
  80236c:	31 ff                	xor    %edi,%edi
  80236e:	31 c0                	xor    %eax,%eax
  802370:	89 fa                	mov    %edi,%edx
  802372:	83 c4 1c             	add    $0x1c,%esp
  802375:	5b                   	pop    %ebx
  802376:	5e                   	pop    %esi
  802377:	5f                   	pop    %edi
  802378:	5d                   	pop    %ebp
  802379:	c3                   	ret    
  80237a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802380:	0f bd fa             	bsr    %edx,%edi
  802383:	83 f7 1f             	xor    $0x1f,%edi
  802386:	75 48                	jne    8023d0 <__udivdi3+0xa0>
  802388:	39 f2                	cmp    %esi,%edx
  80238a:	72 06                	jb     802392 <__udivdi3+0x62>
  80238c:	31 c0                	xor    %eax,%eax
  80238e:	39 eb                	cmp    %ebp,%ebx
  802390:	77 de                	ja     802370 <__udivdi3+0x40>
  802392:	b8 01 00 00 00       	mov    $0x1,%eax
  802397:	eb d7                	jmp    802370 <__udivdi3+0x40>
  802399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023a0:	89 d9                	mov    %ebx,%ecx
  8023a2:	85 db                	test   %ebx,%ebx
  8023a4:	75 0b                	jne    8023b1 <__udivdi3+0x81>
  8023a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8023ab:	31 d2                	xor    %edx,%edx
  8023ad:	f7 f3                	div    %ebx
  8023af:	89 c1                	mov    %eax,%ecx
  8023b1:	31 d2                	xor    %edx,%edx
  8023b3:	89 f0                	mov    %esi,%eax
  8023b5:	f7 f1                	div    %ecx
  8023b7:	89 c6                	mov    %eax,%esi
  8023b9:	89 e8                	mov    %ebp,%eax
  8023bb:	89 f7                	mov    %esi,%edi
  8023bd:	f7 f1                	div    %ecx
  8023bf:	89 fa                	mov    %edi,%edx
  8023c1:	83 c4 1c             	add    $0x1c,%esp
  8023c4:	5b                   	pop    %ebx
  8023c5:	5e                   	pop    %esi
  8023c6:	5f                   	pop    %edi
  8023c7:	5d                   	pop    %ebp
  8023c8:	c3                   	ret    
  8023c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023d0:	89 f9                	mov    %edi,%ecx
  8023d2:	b8 20 00 00 00       	mov    $0x20,%eax
  8023d7:	29 f8                	sub    %edi,%eax
  8023d9:	d3 e2                	shl    %cl,%edx
  8023db:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023df:	89 c1                	mov    %eax,%ecx
  8023e1:	89 da                	mov    %ebx,%edx
  8023e3:	d3 ea                	shr    %cl,%edx
  8023e5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023e9:	09 d1                	or     %edx,%ecx
  8023eb:	89 f2                	mov    %esi,%edx
  8023ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023f1:	89 f9                	mov    %edi,%ecx
  8023f3:	d3 e3                	shl    %cl,%ebx
  8023f5:	89 c1                	mov    %eax,%ecx
  8023f7:	d3 ea                	shr    %cl,%edx
  8023f9:	89 f9                	mov    %edi,%ecx
  8023fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8023ff:	89 eb                	mov    %ebp,%ebx
  802401:	d3 e6                	shl    %cl,%esi
  802403:	89 c1                	mov    %eax,%ecx
  802405:	d3 eb                	shr    %cl,%ebx
  802407:	09 de                	or     %ebx,%esi
  802409:	89 f0                	mov    %esi,%eax
  80240b:	f7 74 24 08          	divl   0x8(%esp)
  80240f:	89 d6                	mov    %edx,%esi
  802411:	89 c3                	mov    %eax,%ebx
  802413:	f7 64 24 0c          	mull   0xc(%esp)
  802417:	39 d6                	cmp    %edx,%esi
  802419:	72 15                	jb     802430 <__udivdi3+0x100>
  80241b:	89 f9                	mov    %edi,%ecx
  80241d:	d3 e5                	shl    %cl,%ebp
  80241f:	39 c5                	cmp    %eax,%ebp
  802421:	73 04                	jae    802427 <__udivdi3+0xf7>
  802423:	39 d6                	cmp    %edx,%esi
  802425:	74 09                	je     802430 <__udivdi3+0x100>
  802427:	89 d8                	mov    %ebx,%eax
  802429:	31 ff                	xor    %edi,%edi
  80242b:	e9 40 ff ff ff       	jmp    802370 <__udivdi3+0x40>
  802430:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802433:	31 ff                	xor    %edi,%edi
  802435:	e9 36 ff ff ff       	jmp    802370 <__udivdi3+0x40>
  80243a:	66 90                	xchg   %ax,%ax
  80243c:	66 90                	xchg   %ax,%ax
  80243e:	66 90                	xchg   %ax,%ax

00802440 <__umoddi3>:
  802440:	f3 0f 1e fb          	endbr32 
  802444:	55                   	push   %ebp
  802445:	57                   	push   %edi
  802446:	56                   	push   %esi
  802447:	53                   	push   %ebx
  802448:	83 ec 1c             	sub    $0x1c,%esp
  80244b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80244f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802453:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802457:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80245b:	85 c0                	test   %eax,%eax
  80245d:	75 19                	jne    802478 <__umoddi3+0x38>
  80245f:	39 df                	cmp    %ebx,%edi
  802461:	76 5d                	jbe    8024c0 <__umoddi3+0x80>
  802463:	89 f0                	mov    %esi,%eax
  802465:	89 da                	mov    %ebx,%edx
  802467:	f7 f7                	div    %edi
  802469:	89 d0                	mov    %edx,%eax
  80246b:	31 d2                	xor    %edx,%edx
  80246d:	83 c4 1c             	add    $0x1c,%esp
  802470:	5b                   	pop    %ebx
  802471:	5e                   	pop    %esi
  802472:	5f                   	pop    %edi
  802473:	5d                   	pop    %ebp
  802474:	c3                   	ret    
  802475:	8d 76 00             	lea    0x0(%esi),%esi
  802478:	89 f2                	mov    %esi,%edx
  80247a:	39 d8                	cmp    %ebx,%eax
  80247c:	76 12                	jbe    802490 <__umoddi3+0x50>
  80247e:	89 f0                	mov    %esi,%eax
  802480:	89 da                	mov    %ebx,%edx
  802482:	83 c4 1c             	add    $0x1c,%esp
  802485:	5b                   	pop    %ebx
  802486:	5e                   	pop    %esi
  802487:	5f                   	pop    %edi
  802488:	5d                   	pop    %ebp
  802489:	c3                   	ret    
  80248a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802490:	0f bd e8             	bsr    %eax,%ebp
  802493:	83 f5 1f             	xor    $0x1f,%ebp
  802496:	75 50                	jne    8024e8 <__umoddi3+0xa8>
  802498:	39 d8                	cmp    %ebx,%eax
  80249a:	0f 82 e0 00 00 00    	jb     802580 <__umoddi3+0x140>
  8024a0:	89 d9                	mov    %ebx,%ecx
  8024a2:	39 f7                	cmp    %esi,%edi
  8024a4:	0f 86 d6 00 00 00    	jbe    802580 <__umoddi3+0x140>
  8024aa:	89 d0                	mov    %edx,%eax
  8024ac:	89 ca                	mov    %ecx,%edx
  8024ae:	83 c4 1c             	add    $0x1c,%esp
  8024b1:	5b                   	pop    %ebx
  8024b2:	5e                   	pop    %esi
  8024b3:	5f                   	pop    %edi
  8024b4:	5d                   	pop    %ebp
  8024b5:	c3                   	ret    
  8024b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024bd:	8d 76 00             	lea    0x0(%esi),%esi
  8024c0:	89 fd                	mov    %edi,%ebp
  8024c2:	85 ff                	test   %edi,%edi
  8024c4:	75 0b                	jne    8024d1 <__umoddi3+0x91>
  8024c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8024cb:	31 d2                	xor    %edx,%edx
  8024cd:	f7 f7                	div    %edi
  8024cf:	89 c5                	mov    %eax,%ebp
  8024d1:	89 d8                	mov    %ebx,%eax
  8024d3:	31 d2                	xor    %edx,%edx
  8024d5:	f7 f5                	div    %ebp
  8024d7:	89 f0                	mov    %esi,%eax
  8024d9:	f7 f5                	div    %ebp
  8024db:	89 d0                	mov    %edx,%eax
  8024dd:	31 d2                	xor    %edx,%edx
  8024df:	eb 8c                	jmp    80246d <__umoddi3+0x2d>
  8024e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024e8:	89 e9                	mov    %ebp,%ecx
  8024ea:	ba 20 00 00 00       	mov    $0x20,%edx
  8024ef:	29 ea                	sub    %ebp,%edx
  8024f1:	d3 e0                	shl    %cl,%eax
  8024f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024f7:	89 d1                	mov    %edx,%ecx
  8024f9:	89 f8                	mov    %edi,%eax
  8024fb:	d3 e8                	shr    %cl,%eax
  8024fd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802501:	89 54 24 04          	mov    %edx,0x4(%esp)
  802505:	8b 54 24 04          	mov    0x4(%esp),%edx
  802509:	09 c1                	or     %eax,%ecx
  80250b:	89 d8                	mov    %ebx,%eax
  80250d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802511:	89 e9                	mov    %ebp,%ecx
  802513:	d3 e7                	shl    %cl,%edi
  802515:	89 d1                	mov    %edx,%ecx
  802517:	d3 e8                	shr    %cl,%eax
  802519:	89 e9                	mov    %ebp,%ecx
  80251b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80251f:	d3 e3                	shl    %cl,%ebx
  802521:	89 c7                	mov    %eax,%edi
  802523:	89 d1                	mov    %edx,%ecx
  802525:	89 f0                	mov    %esi,%eax
  802527:	d3 e8                	shr    %cl,%eax
  802529:	89 e9                	mov    %ebp,%ecx
  80252b:	89 fa                	mov    %edi,%edx
  80252d:	d3 e6                	shl    %cl,%esi
  80252f:	09 d8                	or     %ebx,%eax
  802531:	f7 74 24 08          	divl   0x8(%esp)
  802535:	89 d1                	mov    %edx,%ecx
  802537:	89 f3                	mov    %esi,%ebx
  802539:	f7 64 24 0c          	mull   0xc(%esp)
  80253d:	89 c6                	mov    %eax,%esi
  80253f:	89 d7                	mov    %edx,%edi
  802541:	39 d1                	cmp    %edx,%ecx
  802543:	72 06                	jb     80254b <__umoddi3+0x10b>
  802545:	75 10                	jne    802557 <__umoddi3+0x117>
  802547:	39 c3                	cmp    %eax,%ebx
  802549:	73 0c                	jae    802557 <__umoddi3+0x117>
  80254b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80254f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802553:	89 d7                	mov    %edx,%edi
  802555:	89 c6                	mov    %eax,%esi
  802557:	89 ca                	mov    %ecx,%edx
  802559:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80255e:	29 f3                	sub    %esi,%ebx
  802560:	19 fa                	sbb    %edi,%edx
  802562:	89 d0                	mov    %edx,%eax
  802564:	d3 e0                	shl    %cl,%eax
  802566:	89 e9                	mov    %ebp,%ecx
  802568:	d3 eb                	shr    %cl,%ebx
  80256a:	d3 ea                	shr    %cl,%edx
  80256c:	09 d8                	or     %ebx,%eax
  80256e:	83 c4 1c             	add    $0x1c,%esp
  802571:	5b                   	pop    %ebx
  802572:	5e                   	pop    %esi
  802573:	5f                   	pop    %edi
  802574:	5d                   	pop    %ebp
  802575:	c3                   	ret    
  802576:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80257d:	8d 76 00             	lea    0x0(%esi),%esi
  802580:	29 fe                	sub    %edi,%esi
  802582:	19 c3                	sbb    %eax,%ebx
  802584:	89 f2                	mov    %esi,%edx
  802586:	89 d9                	mov    %ebx,%ecx
  802588:	e9 1d ff ff ff       	jmp    8024aa <__umoddi3+0x6a>
