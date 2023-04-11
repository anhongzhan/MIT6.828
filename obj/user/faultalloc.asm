
obj/user/faultalloc:     file format elf32-i386


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
  800044:	68 40 11 80 00       	push   $0x801140
  800049:	e8 cb 01 00 00       	call   800219 <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004e:	83 c4 0c             	add    $0xc,%esp
  800051:	6a 07                	push   $0x7
  800053:	89 d8                	mov    %ebx,%eax
  800055:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80005a:	50                   	push   %eax
  80005b:	6a 00                	push   $0x0
  80005d:	e8 03 0c 00 00       	call   800c65 <sys_page_alloc>
  800062:	83 c4 10             	add    $0x10,%esp
  800065:	85 c0                	test   %eax,%eax
  800067:	78 16                	js     80007f <handler+0x4c>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800069:	53                   	push   %ebx
  80006a:	68 8c 11 80 00       	push   $0x80118c
  80006f:	6a 64                	push   $0x64
  800071:	53                   	push   %ebx
  800072:	e8 4b 07 00 00       	call   8007c2 <snprintf>
}
  800077:	83 c4 10             	add    $0x10,%esp
  80007a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80007d:	c9                   	leave  
  80007e:	c3                   	ret    
		panic("allocating at %x in page fault handler: %e", addr, r);
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	50                   	push   %eax
  800083:	53                   	push   %ebx
  800084:	68 60 11 80 00       	push   $0x801160
  800089:	6a 0e                	push   $0xe
  80008b:	68 4a 11 80 00       	push   $0x80114a
  800090:	e8 9d 00 00 00       	call   800132 <_panic>

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
  8000a4:	e8 87 0d 00 00       	call   800e30 <set_pgfault_handler>
	cprintf("%s\n", (char*)0xDeadBeef);
  8000a9:	83 c4 08             	add    $0x8,%esp
  8000ac:	68 ef be ad de       	push   $0xdeadbeef
  8000b1:	68 5c 11 80 00       	push   $0x80115c
  8000b6:	e8 5e 01 00 00       	call   800219 <cprintf>
	cprintf("%s\n", (char*)0xCafeBffe);
  8000bb:	83 c4 08             	add    $0x8,%esp
  8000be:	68 fe bf fe ca       	push   $0xcafebffe
  8000c3:	68 5c 11 80 00       	push   $0x80115c
  8000c8:	e8 4c 01 00 00       	call   800219 <cprintf>
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
  8000e1:	e8 39 0b 00 00       	call   800c1f <sys_getenvid>
  8000e6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000eb:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000ee:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000f3:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000f8:	85 db                	test   %ebx,%ebx
  8000fa:	7e 07                	jle    800103 <libmain+0x31>
		binaryname = argv[0];
  8000fc:	8b 06                	mov    (%esi),%eax
  8000fe:	a3 00 20 80 00       	mov    %eax,0x802000

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
  800123:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  800126:	6a 00                	push   $0x0
  800128:	e8 ad 0a 00 00       	call   800bda <sys_env_destroy>
}
  80012d:	83 c4 10             	add    $0x10,%esp
  800130:	c9                   	leave  
  800131:	c3                   	ret    

00800132 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800132:	f3 0f 1e fb          	endbr32 
  800136:	55                   	push   %ebp
  800137:	89 e5                	mov    %esp,%ebp
  800139:	56                   	push   %esi
  80013a:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80013b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80013e:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800144:	e8 d6 0a 00 00       	call   800c1f <sys_getenvid>
  800149:	83 ec 0c             	sub    $0xc,%esp
  80014c:	ff 75 0c             	pushl  0xc(%ebp)
  80014f:	ff 75 08             	pushl  0x8(%ebp)
  800152:	56                   	push   %esi
  800153:	50                   	push   %eax
  800154:	68 b8 11 80 00       	push   $0x8011b8
  800159:	e8 bb 00 00 00       	call   800219 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80015e:	83 c4 18             	add    $0x18,%esp
  800161:	53                   	push   %ebx
  800162:	ff 75 10             	pushl  0x10(%ebp)
  800165:	e8 5a 00 00 00       	call   8001c4 <vcprintf>
	cprintf("\n");
  80016a:	c7 04 24 5e 11 80 00 	movl   $0x80115e,(%esp)
  800171:	e8 a3 00 00 00       	call   800219 <cprintf>
  800176:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800179:	cc                   	int3   
  80017a:	eb fd                	jmp    800179 <_panic+0x47>

0080017c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80017c:	f3 0f 1e fb          	endbr32 
  800180:	55                   	push   %ebp
  800181:	89 e5                	mov    %esp,%ebp
  800183:	53                   	push   %ebx
  800184:	83 ec 04             	sub    $0x4,%esp
  800187:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80018a:	8b 13                	mov    (%ebx),%edx
  80018c:	8d 42 01             	lea    0x1(%edx),%eax
  80018f:	89 03                	mov    %eax,(%ebx)
  800191:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800194:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800198:	3d ff 00 00 00       	cmp    $0xff,%eax
  80019d:	74 09                	je     8001a8 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80019f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001a6:	c9                   	leave  
  8001a7:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001a8:	83 ec 08             	sub    $0x8,%esp
  8001ab:	68 ff 00 00 00       	push   $0xff
  8001b0:	8d 43 08             	lea    0x8(%ebx),%eax
  8001b3:	50                   	push   %eax
  8001b4:	e8 dc 09 00 00       	call   800b95 <sys_cputs>
		b->idx = 0;
  8001b9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001bf:	83 c4 10             	add    $0x10,%esp
  8001c2:	eb db                	jmp    80019f <putch+0x23>

008001c4 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001c4:	f3 0f 1e fb          	endbr32 
  8001c8:	55                   	push   %ebp
  8001c9:	89 e5                	mov    %esp,%ebp
  8001cb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001d1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001d8:	00 00 00 
	b.cnt = 0;
  8001db:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001e2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001e5:	ff 75 0c             	pushl  0xc(%ebp)
  8001e8:	ff 75 08             	pushl  0x8(%ebp)
  8001eb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001f1:	50                   	push   %eax
  8001f2:	68 7c 01 80 00       	push   $0x80017c
  8001f7:	e8 20 01 00 00       	call   80031c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001fc:	83 c4 08             	add    $0x8,%esp
  8001ff:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800205:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80020b:	50                   	push   %eax
  80020c:	e8 84 09 00 00       	call   800b95 <sys_cputs>

	return b.cnt;
}
  800211:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800217:	c9                   	leave  
  800218:	c3                   	ret    

00800219 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800219:	f3 0f 1e fb          	endbr32 
  80021d:	55                   	push   %ebp
  80021e:	89 e5                	mov    %esp,%ebp
  800220:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800223:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800226:	50                   	push   %eax
  800227:	ff 75 08             	pushl  0x8(%ebp)
  80022a:	e8 95 ff ff ff       	call   8001c4 <vcprintf>
	va_end(ap);

	return cnt;
}
  80022f:	c9                   	leave  
  800230:	c3                   	ret    

00800231 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800231:	55                   	push   %ebp
  800232:	89 e5                	mov    %esp,%ebp
  800234:	57                   	push   %edi
  800235:	56                   	push   %esi
  800236:	53                   	push   %ebx
  800237:	83 ec 1c             	sub    $0x1c,%esp
  80023a:	89 c7                	mov    %eax,%edi
  80023c:	89 d6                	mov    %edx,%esi
  80023e:	8b 45 08             	mov    0x8(%ebp),%eax
  800241:	8b 55 0c             	mov    0xc(%ebp),%edx
  800244:	89 d1                	mov    %edx,%ecx
  800246:	89 c2                	mov    %eax,%edx
  800248:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80024b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80024e:	8b 45 10             	mov    0x10(%ebp),%eax
  800251:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800254:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800257:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80025e:	39 c2                	cmp    %eax,%edx
  800260:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800263:	72 3e                	jb     8002a3 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800265:	83 ec 0c             	sub    $0xc,%esp
  800268:	ff 75 18             	pushl  0x18(%ebp)
  80026b:	83 eb 01             	sub    $0x1,%ebx
  80026e:	53                   	push   %ebx
  80026f:	50                   	push   %eax
  800270:	83 ec 08             	sub    $0x8,%esp
  800273:	ff 75 e4             	pushl  -0x1c(%ebp)
  800276:	ff 75 e0             	pushl  -0x20(%ebp)
  800279:	ff 75 dc             	pushl  -0x24(%ebp)
  80027c:	ff 75 d8             	pushl  -0x28(%ebp)
  80027f:	e8 4c 0c 00 00       	call   800ed0 <__udivdi3>
  800284:	83 c4 18             	add    $0x18,%esp
  800287:	52                   	push   %edx
  800288:	50                   	push   %eax
  800289:	89 f2                	mov    %esi,%edx
  80028b:	89 f8                	mov    %edi,%eax
  80028d:	e8 9f ff ff ff       	call   800231 <printnum>
  800292:	83 c4 20             	add    $0x20,%esp
  800295:	eb 13                	jmp    8002aa <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800297:	83 ec 08             	sub    $0x8,%esp
  80029a:	56                   	push   %esi
  80029b:	ff 75 18             	pushl  0x18(%ebp)
  80029e:	ff d7                	call   *%edi
  8002a0:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002a3:	83 eb 01             	sub    $0x1,%ebx
  8002a6:	85 db                	test   %ebx,%ebx
  8002a8:	7f ed                	jg     800297 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002aa:	83 ec 08             	sub    $0x8,%esp
  8002ad:	56                   	push   %esi
  8002ae:	83 ec 04             	sub    $0x4,%esp
  8002b1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002b4:	ff 75 e0             	pushl  -0x20(%ebp)
  8002b7:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ba:	ff 75 d8             	pushl  -0x28(%ebp)
  8002bd:	e8 1e 0d 00 00       	call   800fe0 <__umoddi3>
  8002c2:	83 c4 14             	add    $0x14,%esp
  8002c5:	0f be 80 db 11 80 00 	movsbl 0x8011db(%eax),%eax
  8002cc:	50                   	push   %eax
  8002cd:	ff d7                	call   *%edi
}
  8002cf:	83 c4 10             	add    $0x10,%esp
  8002d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d5:	5b                   	pop    %ebx
  8002d6:	5e                   	pop    %esi
  8002d7:	5f                   	pop    %edi
  8002d8:	5d                   	pop    %ebp
  8002d9:	c3                   	ret    

008002da <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002da:	f3 0f 1e fb          	endbr32 
  8002de:	55                   	push   %ebp
  8002df:	89 e5                	mov    %esp,%ebp
  8002e1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002e4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002e8:	8b 10                	mov    (%eax),%edx
  8002ea:	3b 50 04             	cmp    0x4(%eax),%edx
  8002ed:	73 0a                	jae    8002f9 <sprintputch+0x1f>
		*b->buf++ = ch;
  8002ef:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002f2:	89 08                	mov    %ecx,(%eax)
  8002f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f7:	88 02                	mov    %al,(%edx)
}
  8002f9:	5d                   	pop    %ebp
  8002fa:	c3                   	ret    

008002fb <printfmt>:
{
  8002fb:	f3 0f 1e fb          	endbr32 
  8002ff:	55                   	push   %ebp
  800300:	89 e5                	mov    %esp,%ebp
  800302:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800305:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800308:	50                   	push   %eax
  800309:	ff 75 10             	pushl  0x10(%ebp)
  80030c:	ff 75 0c             	pushl  0xc(%ebp)
  80030f:	ff 75 08             	pushl  0x8(%ebp)
  800312:	e8 05 00 00 00       	call   80031c <vprintfmt>
}
  800317:	83 c4 10             	add    $0x10,%esp
  80031a:	c9                   	leave  
  80031b:	c3                   	ret    

0080031c <vprintfmt>:
{
  80031c:	f3 0f 1e fb          	endbr32 
  800320:	55                   	push   %ebp
  800321:	89 e5                	mov    %esp,%ebp
  800323:	57                   	push   %edi
  800324:	56                   	push   %esi
  800325:	53                   	push   %ebx
  800326:	83 ec 3c             	sub    $0x3c,%esp
  800329:	8b 75 08             	mov    0x8(%ebp),%esi
  80032c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80032f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800332:	e9 8e 03 00 00       	jmp    8006c5 <vprintfmt+0x3a9>
		padc = ' ';
  800337:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80033b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800342:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800349:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800350:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800355:	8d 47 01             	lea    0x1(%edi),%eax
  800358:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80035b:	0f b6 17             	movzbl (%edi),%edx
  80035e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800361:	3c 55                	cmp    $0x55,%al
  800363:	0f 87 df 03 00 00    	ja     800748 <vprintfmt+0x42c>
  800369:	0f b6 c0             	movzbl %al,%eax
  80036c:	3e ff 24 85 a0 12 80 	notrack jmp *0x8012a0(,%eax,4)
  800373:	00 
  800374:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800377:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80037b:	eb d8                	jmp    800355 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80037d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800380:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800384:	eb cf                	jmp    800355 <vprintfmt+0x39>
  800386:	0f b6 d2             	movzbl %dl,%edx
  800389:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80038c:	b8 00 00 00 00       	mov    $0x0,%eax
  800391:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800394:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800397:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80039b:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80039e:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003a1:	83 f9 09             	cmp    $0x9,%ecx
  8003a4:	77 55                	ja     8003fb <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8003a6:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003a9:	eb e9                	jmp    800394 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8003ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ae:	8b 00                	mov    (%eax),%eax
  8003b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b6:	8d 40 04             	lea    0x4(%eax),%eax
  8003b9:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003bc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003bf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003c3:	79 90                	jns    800355 <vprintfmt+0x39>
				width = precision, precision = -1;
  8003c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003cb:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003d2:	eb 81                	jmp    800355 <vprintfmt+0x39>
  8003d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d7:	85 c0                	test   %eax,%eax
  8003d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8003de:	0f 49 d0             	cmovns %eax,%edx
  8003e1:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003e7:	e9 69 ff ff ff       	jmp    800355 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003ec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003ef:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003f6:	e9 5a ff ff ff       	jmp    800355 <vprintfmt+0x39>
  8003fb:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800401:	eb bc                	jmp    8003bf <vprintfmt+0xa3>
			lflag++;
  800403:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800406:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800409:	e9 47 ff ff ff       	jmp    800355 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80040e:	8b 45 14             	mov    0x14(%ebp),%eax
  800411:	8d 78 04             	lea    0x4(%eax),%edi
  800414:	83 ec 08             	sub    $0x8,%esp
  800417:	53                   	push   %ebx
  800418:	ff 30                	pushl  (%eax)
  80041a:	ff d6                	call   *%esi
			break;
  80041c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80041f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800422:	e9 9b 02 00 00       	jmp    8006c2 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800427:	8b 45 14             	mov    0x14(%ebp),%eax
  80042a:	8d 78 04             	lea    0x4(%eax),%edi
  80042d:	8b 00                	mov    (%eax),%eax
  80042f:	99                   	cltd   
  800430:	31 d0                	xor    %edx,%eax
  800432:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800434:	83 f8 08             	cmp    $0x8,%eax
  800437:	7f 23                	jg     80045c <vprintfmt+0x140>
  800439:	8b 14 85 00 14 80 00 	mov    0x801400(,%eax,4),%edx
  800440:	85 d2                	test   %edx,%edx
  800442:	74 18                	je     80045c <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800444:	52                   	push   %edx
  800445:	68 fc 11 80 00       	push   $0x8011fc
  80044a:	53                   	push   %ebx
  80044b:	56                   	push   %esi
  80044c:	e8 aa fe ff ff       	call   8002fb <printfmt>
  800451:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800454:	89 7d 14             	mov    %edi,0x14(%ebp)
  800457:	e9 66 02 00 00       	jmp    8006c2 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80045c:	50                   	push   %eax
  80045d:	68 f3 11 80 00       	push   $0x8011f3
  800462:	53                   	push   %ebx
  800463:	56                   	push   %esi
  800464:	e8 92 fe ff ff       	call   8002fb <printfmt>
  800469:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80046c:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80046f:	e9 4e 02 00 00       	jmp    8006c2 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800474:	8b 45 14             	mov    0x14(%ebp),%eax
  800477:	83 c0 04             	add    $0x4,%eax
  80047a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80047d:	8b 45 14             	mov    0x14(%ebp),%eax
  800480:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800482:	85 d2                	test   %edx,%edx
  800484:	b8 ec 11 80 00       	mov    $0x8011ec,%eax
  800489:	0f 45 c2             	cmovne %edx,%eax
  80048c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80048f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800493:	7e 06                	jle    80049b <vprintfmt+0x17f>
  800495:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800499:	75 0d                	jne    8004a8 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80049b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80049e:	89 c7                	mov    %eax,%edi
  8004a0:	03 45 e0             	add    -0x20(%ebp),%eax
  8004a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004a6:	eb 55                	jmp    8004fd <vprintfmt+0x1e1>
  8004a8:	83 ec 08             	sub    $0x8,%esp
  8004ab:	ff 75 d8             	pushl  -0x28(%ebp)
  8004ae:	ff 75 cc             	pushl  -0x34(%ebp)
  8004b1:	e8 46 03 00 00       	call   8007fc <strnlen>
  8004b6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004b9:	29 c2                	sub    %eax,%edx
  8004bb:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004be:	83 c4 10             	add    $0x10,%esp
  8004c1:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004c3:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ca:	85 ff                	test   %edi,%edi
  8004cc:	7e 11                	jle    8004df <vprintfmt+0x1c3>
					putch(padc, putdat);
  8004ce:	83 ec 08             	sub    $0x8,%esp
  8004d1:	53                   	push   %ebx
  8004d2:	ff 75 e0             	pushl  -0x20(%ebp)
  8004d5:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d7:	83 ef 01             	sub    $0x1,%edi
  8004da:	83 c4 10             	add    $0x10,%esp
  8004dd:	eb eb                	jmp    8004ca <vprintfmt+0x1ae>
  8004df:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004e2:	85 d2                	test   %edx,%edx
  8004e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e9:	0f 49 c2             	cmovns %edx,%eax
  8004ec:	29 c2                	sub    %eax,%edx
  8004ee:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004f1:	eb a8                	jmp    80049b <vprintfmt+0x17f>
					putch(ch, putdat);
  8004f3:	83 ec 08             	sub    $0x8,%esp
  8004f6:	53                   	push   %ebx
  8004f7:	52                   	push   %edx
  8004f8:	ff d6                	call   *%esi
  8004fa:	83 c4 10             	add    $0x10,%esp
  8004fd:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800500:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800502:	83 c7 01             	add    $0x1,%edi
  800505:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800509:	0f be d0             	movsbl %al,%edx
  80050c:	85 d2                	test   %edx,%edx
  80050e:	74 4b                	je     80055b <vprintfmt+0x23f>
  800510:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800514:	78 06                	js     80051c <vprintfmt+0x200>
  800516:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80051a:	78 1e                	js     80053a <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  80051c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800520:	74 d1                	je     8004f3 <vprintfmt+0x1d7>
  800522:	0f be c0             	movsbl %al,%eax
  800525:	83 e8 20             	sub    $0x20,%eax
  800528:	83 f8 5e             	cmp    $0x5e,%eax
  80052b:	76 c6                	jbe    8004f3 <vprintfmt+0x1d7>
					putch('?', putdat);
  80052d:	83 ec 08             	sub    $0x8,%esp
  800530:	53                   	push   %ebx
  800531:	6a 3f                	push   $0x3f
  800533:	ff d6                	call   *%esi
  800535:	83 c4 10             	add    $0x10,%esp
  800538:	eb c3                	jmp    8004fd <vprintfmt+0x1e1>
  80053a:	89 cf                	mov    %ecx,%edi
  80053c:	eb 0e                	jmp    80054c <vprintfmt+0x230>
				putch(' ', putdat);
  80053e:	83 ec 08             	sub    $0x8,%esp
  800541:	53                   	push   %ebx
  800542:	6a 20                	push   $0x20
  800544:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800546:	83 ef 01             	sub    $0x1,%edi
  800549:	83 c4 10             	add    $0x10,%esp
  80054c:	85 ff                	test   %edi,%edi
  80054e:	7f ee                	jg     80053e <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800550:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800553:	89 45 14             	mov    %eax,0x14(%ebp)
  800556:	e9 67 01 00 00       	jmp    8006c2 <vprintfmt+0x3a6>
  80055b:	89 cf                	mov    %ecx,%edi
  80055d:	eb ed                	jmp    80054c <vprintfmt+0x230>
	if (lflag >= 2)
  80055f:	83 f9 01             	cmp    $0x1,%ecx
  800562:	7f 1b                	jg     80057f <vprintfmt+0x263>
	else if (lflag)
  800564:	85 c9                	test   %ecx,%ecx
  800566:	74 63                	je     8005cb <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800568:	8b 45 14             	mov    0x14(%ebp),%eax
  80056b:	8b 00                	mov    (%eax),%eax
  80056d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800570:	99                   	cltd   
  800571:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800574:	8b 45 14             	mov    0x14(%ebp),%eax
  800577:	8d 40 04             	lea    0x4(%eax),%eax
  80057a:	89 45 14             	mov    %eax,0x14(%ebp)
  80057d:	eb 17                	jmp    800596 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  80057f:	8b 45 14             	mov    0x14(%ebp),%eax
  800582:	8b 50 04             	mov    0x4(%eax),%edx
  800585:	8b 00                	mov    (%eax),%eax
  800587:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80058a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80058d:	8b 45 14             	mov    0x14(%ebp),%eax
  800590:	8d 40 08             	lea    0x8(%eax),%eax
  800593:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800596:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800599:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80059c:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8005a1:	85 c9                	test   %ecx,%ecx
  8005a3:	0f 89 ff 00 00 00    	jns    8006a8 <vprintfmt+0x38c>
				putch('-', putdat);
  8005a9:	83 ec 08             	sub    $0x8,%esp
  8005ac:	53                   	push   %ebx
  8005ad:	6a 2d                	push   $0x2d
  8005af:	ff d6                	call   *%esi
				num = -(long long) num;
  8005b1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005b4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005b7:	f7 da                	neg    %edx
  8005b9:	83 d1 00             	adc    $0x0,%ecx
  8005bc:	f7 d9                	neg    %ecx
  8005be:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005c1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005c6:	e9 dd 00 00 00       	jmp    8006a8 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8005cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ce:	8b 00                	mov    (%eax),%eax
  8005d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d3:	99                   	cltd   
  8005d4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005da:	8d 40 04             	lea    0x4(%eax),%eax
  8005dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e0:	eb b4                	jmp    800596 <vprintfmt+0x27a>
	if (lflag >= 2)
  8005e2:	83 f9 01             	cmp    $0x1,%ecx
  8005e5:	7f 1e                	jg     800605 <vprintfmt+0x2e9>
	else if (lflag)
  8005e7:	85 c9                	test   %ecx,%ecx
  8005e9:	74 32                	je     80061d <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8005eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ee:	8b 10                	mov    (%eax),%edx
  8005f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005f5:	8d 40 04             	lea    0x4(%eax),%eax
  8005f8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005fb:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800600:	e9 a3 00 00 00       	jmp    8006a8 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800605:	8b 45 14             	mov    0x14(%ebp),%eax
  800608:	8b 10                	mov    (%eax),%edx
  80060a:	8b 48 04             	mov    0x4(%eax),%ecx
  80060d:	8d 40 08             	lea    0x8(%eax),%eax
  800610:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800613:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800618:	e9 8b 00 00 00       	jmp    8006a8 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80061d:	8b 45 14             	mov    0x14(%ebp),%eax
  800620:	8b 10                	mov    (%eax),%edx
  800622:	b9 00 00 00 00       	mov    $0x0,%ecx
  800627:	8d 40 04             	lea    0x4(%eax),%eax
  80062a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80062d:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800632:	eb 74                	jmp    8006a8 <vprintfmt+0x38c>
	if (lflag >= 2)
  800634:	83 f9 01             	cmp    $0x1,%ecx
  800637:	7f 1b                	jg     800654 <vprintfmt+0x338>
	else if (lflag)
  800639:	85 c9                	test   %ecx,%ecx
  80063b:	74 2c                	je     800669 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  80063d:	8b 45 14             	mov    0x14(%ebp),%eax
  800640:	8b 10                	mov    (%eax),%edx
  800642:	b9 00 00 00 00       	mov    $0x0,%ecx
  800647:	8d 40 04             	lea    0x4(%eax),%eax
  80064a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80064d:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800652:	eb 54                	jmp    8006a8 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800654:	8b 45 14             	mov    0x14(%ebp),%eax
  800657:	8b 10                	mov    (%eax),%edx
  800659:	8b 48 04             	mov    0x4(%eax),%ecx
  80065c:	8d 40 08             	lea    0x8(%eax),%eax
  80065f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800662:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800667:	eb 3f                	jmp    8006a8 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800669:	8b 45 14             	mov    0x14(%ebp),%eax
  80066c:	8b 10                	mov    (%eax),%edx
  80066e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800673:	8d 40 04             	lea    0x4(%eax),%eax
  800676:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800679:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  80067e:	eb 28                	jmp    8006a8 <vprintfmt+0x38c>
			putch('0', putdat);
  800680:	83 ec 08             	sub    $0x8,%esp
  800683:	53                   	push   %ebx
  800684:	6a 30                	push   $0x30
  800686:	ff d6                	call   *%esi
			putch('x', putdat);
  800688:	83 c4 08             	add    $0x8,%esp
  80068b:	53                   	push   %ebx
  80068c:	6a 78                	push   $0x78
  80068e:	ff d6                	call   *%esi
			num = (unsigned long long)
  800690:	8b 45 14             	mov    0x14(%ebp),%eax
  800693:	8b 10                	mov    (%eax),%edx
  800695:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80069a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80069d:	8d 40 04             	lea    0x4(%eax),%eax
  8006a0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a3:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006a8:	83 ec 0c             	sub    $0xc,%esp
  8006ab:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8006af:	57                   	push   %edi
  8006b0:	ff 75 e0             	pushl  -0x20(%ebp)
  8006b3:	50                   	push   %eax
  8006b4:	51                   	push   %ecx
  8006b5:	52                   	push   %edx
  8006b6:	89 da                	mov    %ebx,%edx
  8006b8:	89 f0                	mov    %esi,%eax
  8006ba:	e8 72 fb ff ff       	call   800231 <printnum>
			break;
  8006bf:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006c5:	83 c7 01             	add    $0x1,%edi
  8006c8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006cc:	83 f8 25             	cmp    $0x25,%eax
  8006cf:	0f 84 62 fc ff ff    	je     800337 <vprintfmt+0x1b>
			if (ch == '\0')
  8006d5:	85 c0                	test   %eax,%eax
  8006d7:	0f 84 8b 00 00 00    	je     800768 <vprintfmt+0x44c>
			putch(ch, putdat);
  8006dd:	83 ec 08             	sub    $0x8,%esp
  8006e0:	53                   	push   %ebx
  8006e1:	50                   	push   %eax
  8006e2:	ff d6                	call   *%esi
  8006e4:	83 c4 10             	add    $0x10,%esp
  8006e7:	eb dc                	jmp    8006c5 <vprintfmt+0x3a9>
	if (lflag >= 2)
  8006e9:	83 f9 01             	cmp    $0x1,%ecx
  8006ec:	7f 1b                	jg     800709 <vprintfmt+0x3ed>
	else if (lflag)
  8006ee:	85 c9                	test   %ecx,%ecx
  8006f0:	74 2c                	je     80071e <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8006f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f5:	8b 10                	mov    (%eax),%edx
  8006f7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006fc:	8d 40 04             	lea    0x4(%eax),%eax
  8006ff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800702:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800707:	eb 9f                	jmp    8006a8 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800709:	8b 45 14             	mov    0x14(%ebp),%eax
  80070c:	8b 10                	mov    (%eax),%edx
  80070e:	8b 48 04             	mov    0x4(%eax),%ecx
  800711:	8d 40 08             	lea    0x8(%eax),%eax
  800714:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800717:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  80071c:	eb 8a                	jmp    8006a8 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80071e:	8b 45 14             	mov    0x14(%ebp),%eax
  800721:	8b 10                	mov    (%eax),%edx
  800723:	b9 00 00 00 00       	mov    $0x0,%ecx
  800728:	8d 40 04             	lea    0x4(%eax),%eax
  80072b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80072e:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800733:	e9 70 ff ff ff       	jmp    8006a8 <vprintfmt+0x38c>
			putch(ch, putdat);
  800738:	83 ec 08             	sub    $0x8,%esp
  80073b:	53                   	push   %ebx
  80073c:	6a 25                	push   $0x25
  80073e:	ff d6                	call   *%esi
			break;
  800740:	83 c4 10             	add    $0x10,%esp
  800743:	e9 7a ff ff ff       	jmp    8006c2 <vprintfmt+0x3a6>
			putch('%', putdat);
  800748:	83 ec 08             	sub    $0x8,%esp
  80074b:	53                   	push   %ebx
  80074c:	6a 25                	push   $0x25
  80074e:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800750:	83 c4 10             	add    $0x10,%esp
  800753:	89 f8                	mov    %edi,%eax
  800755:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800759:	74 05                	je     800760 <vprintfmt+0x444>
  80075b:	83 e8 01             	sub    $0x1,%eax
  80075e:	eb f5                	jmp    800755 <vprintfmt+0x439>
  800760:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800763:	e9 5a ff ff ff       	jmp    8006c2 <vprintfmt+0x3a6>
}
  800768:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80076b:	5b                   	pop    %ebx
  80076c:	5e                   	pop    %esi
  80076d:	5f                   	pop    %edi
  80076e:	5d                   	pop    %ebp
  80076f:	c3                   	ret    

00800770 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800770:	f3 0f 1e fb          	endbr32 
  800774:	55                   	push   %ebp
  800775:	89 e5                	mov    %esp,%ebp
  800777:	83 ec 18             	sub    $0x18,%esp
  80077a:	8b 45 08             	mov    0x8(%ebp),%eax
  80077d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800780:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800783:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800787:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80078a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800791:	85 c0                	test   %eax,%eax
  800793:	74 26                	je     8007bb <vsnprintf+0x4b>
  800795:	85 d2                	test   %edx,%edx
  800797:	7e 22                	jle    8007bb <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800799:	ff 75 14             	pushl  0x14(%ebp)
  80079c:	ff 75 10             	pushl  0x10(%ebp)
  80079f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007a2:	50                   	push   %eax
  8007a3:	68 da 02 80 00       	push   $0x8002da
  8007a8:	e8 6f fb ff ff       	call   80031c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007b0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007b6:	83 c4 10             	add    $0x10,%esp
}
  8007b9:	c9                   	leave  
  8007ba:	c3                   	ret    
		return -E_INVAL;
  8007bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007c0:	eb f7                	jmp    8007b9 <vsnprintf+0x49>

008007c2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007c2:	f3 0f 1e fb          	endbr32 
  8007c6:	55                   	push   %ebp
  8007c7:	89 e5                	mov    %esp,%ebp
  8007c9:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007cc:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007cf:	50                   	push   %eax
  8007d0:	ff 75 10             	pushl  0x10(%ebp)
  8007d3:	ff 75 0c             	pushl  0xc(%ebp)
  8007d6:	ff 75 08             	pushl  0x8(%ebp)
  8007d9:	e8 92 ff ff ff       	call   800770 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007de:	c9                   	leave  
  8007df:	c3                   	ret    

008007e0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007e0:	f3 0f 1e fb          	endbr32 
  8007e4:	55                   	push   %ebp
  8007e5:	89 e5                	mov    %esp,%ebp
  8007e7:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ef:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007f3:	74 05                	je     8007fa <strlen+0x1a>
		n++;
  8007f5:	83 c0 01             	add    $0x1,%eax
  8007f8:	eb f5                	jmp    8007ef <strlen+0xf>
	return n;
}
  8007fa:	5d                   	pop    %ebp
  8007fb:	c3                   	ret    

008007fc <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007fc:	f3 0f 1e fb          	endbr32 
  800800:	55                   	push   %ebp
  800801:	89 e5                	mov    %esp,%ebp
  800803:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800806:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800809:	b8 00 00 00 00       	mov    $0x0,%eax
  80080e:	39 d0                	cmp    %edx,%eax
  800810:	74 0d                	je     80081f <strnlen+0x23>
  800812:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800816:	74 05                	je     80081d <strnlen+0x21>
		n++;
  800818:	83 c0 01             	add    $0x1,%eax
  80081b:	eb f1                	jmp    80080e <strnlen+0x12>
  80081d:	89 c2                	mov    %eax,%edx
	return n;
}
  80081f:	89 d0                	mov    %edx,%eax
  800821:	5d                   	pop    %ebp
  800822:	c3                   	ret    

00800823 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800823:	f3 0f 1e fb          	endbr32 
  800827:	55                   	push   %ebp
  800828:	89 e5                	mov    %esp,%ebp
  80082a:	53                   	push   %ebx
  80082b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80082e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800831:	b8 00 00 00 00       	mov    $0x0,%eax
  800836:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80083a:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  80083d:	83 c0 01             	add    $0x1,%eax
  800840:	84 d2                	test   %dl,%dl
  800842:	75 f2                	jne    800836 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800844:	89 c8                	mov    %ecx,%eax
  800846:	5b                   	pop    %ebx
  800847:	5d                   	pop    %ebp
  800848:	c3                   	ret    

00800849 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800849:	f3 0f 1e fb          	endbr32 
  80084d:	55                   	push   %ebp
  80084e:	89 e5                	mov    %esp,%ebp
  800850:	53                   	push   %ebx
  800851:	83 ec 10             	sub    $0x10,%esp
  800854:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800857:	53                   	push   %ebx
  800858:	e8 83 ff ff ff       	call   8007e0 <strlen>
  80085d:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800860:	ff 75 0c             	pushl  0xc(%ebp)
  800863:	01 d8                	add    %ebx,%eax
  800865:	50                   	push   %eax
  800866:	e8 b8 ff ff ff       	call   800823 <strcpy>
	return dst;
}
  80086b:	89 d8                	mov    %ebx,%eax
  80086d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800870:	c9                   	leave  
  800871:	c3                   	ret    

00800872 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800872:	f3 0f 1e fb          	endbr32 
  800876:	55                   	push   %ebp
  800877:	89 e5                	mov    %esp,%ebp
  800879:	56                   	push   %esi
  80087a:	53                   	push   %ebx
  80087b:	8b 75 08             	mov    0x8(%ebp),%esi
  80087e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800881:	89 f3                	mov    %esi,%ebx
  800883:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800886:	89 f0                	mov    %esi,%eax
  800888:	39 d8                	cmp    %ebx,%eax
  80088a:	74 11                	je     80089d <strncpy+0x2b>
		*dst++ = *src;
  80088c:	83 c0 01             	add    $0x1,%eax
  80088f:	0f b6 0a             	movzbl (%edx),%ecx
  800892:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800895:	80 f9 01             	cmp    $0x1,%cl
  800898:	83 da ff             	sbb    $0xffffffff,%edx
  80089b:	eb eb                	jmp    800888 <strncpy+0x16>
	}
	return ret;
}
  80089d:	89 f0                	mov    %esi,%eax
  80089f:	5b                   	pop    %ebx
  8008a0:	5e                   	pop    %esi
  8008a1:	5d                   	pop    %ebp
  8008a2:	c3                   	ret    

008008a3 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008a3:	f3 0f 1e fb          	endbr32 
  8008a7:	55                   	push   %ebp
  8008a8:	89 e5                	mov    %esp,%ebp
  8008aa:	56                   	push   %esi
  8008ab:	53                   	push   %ebx
  8008ac:	8b 75 08             	mov    0x8(%ebp),%esi
  8008af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008b2:	8b 55 10             	mov    0x10(%ebp),%edx
  8008b5:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008b7:	85 d2                	test   %edx,%edx
  8008b9:	74 21                	je     8008dc <strlcpy+0x39>
  8008bb:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008bf:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008c1:	39 c2                	cmp    %eax,%edx
  8008c3:	74 14                	je     8008d9 <strlcpy+0x36>
  8008c5:	0f b6 19             	movzbl (%ecx),%ebx
  8008c8:	84 db                	test   %bl,%bl
  8008ca:	74 0b                	je     8008d7 <strlcpy+0x34>
			*dst++ = *src++;
  8008cc:	83 c1 01             	add    $0x1,%ecx
  8008cf:	83 c2 01             	add    $0x1,%edx
  8008d2:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008d5:	eb ea                	jmp    8008c1 <strlcpy+0x1e>
  8008d7:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008d9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008dc:	29 f0                	sub    %esi,%eax
}
  8008de:	5b                   	pop    %ebx
  8008df:	5e                   	pop    %esi
  8008e0:	5d                   	pop    %ebp
  8008e1:	c3                   	ret    

008008e2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008e2:	f3 0f 1e fb          	endbr32 
  8008e6:	55                   	push   %ebp
  8008e7:	89 e5                	mov    %esp,%ebp
  8008e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ec:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008ef:	0f b6 01             	movzbl (%ecx),%eax
  8008f2:	84 c0                	test   %al,%al
  8008f4:	74 0c                	je     800902 <strcmp+0x20>
  8008f6:	3a 02                	cmp    (%edx),%al
  8008f8:	75 08                	jne    800902 <strcmp+0x20>
		p++, q++;
  8008fa:	83 c1 01             	add    $0x1,%ecx
  8008fd:	83 c2 01             	add    $0x1,%edx
  800900:	eb ed                	jmp    8008ef <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800902:	0f b6 c0             	movzbl %al,%eax
  800905:	0f b6 12             	movzbl (%edx),%edx
  800908:	29 d0                	sub    %edx,%eax
}
  80090a:	5d                   	pop    %ebp
  80090b:	c3                   	ret    

0080090c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80090c:	f3 0f 1e fb          	endbr32 
  800910:	55                   	push   %ebp
  800911:	89 e5                	mov    %esp,%ebp
  800913:	53                   	push   %ebx
  800914:	8b 45 08             	mov    0x8(%ebp),%eax
  800917:	8b 55 0c             	mov    0xc(%ebp),%edx
  80091a:	89 c3                	mov    %eax,%ebx
  80091c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80091f:	eb 06                	jmp    800927 <strncmp+0x1b>
		n--, p++, q++;
  800921:	83 c0 01             	add    $0x1,%eax
  800924:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800927:	39 d8                	cmp    %ebx,%eax
  800929:	74 16                	je     800941 <strncmp+0x35>
  80092b:	0f b6 08             	movzbl (%eax),%ecx
  80092e:	84 c9                	test   %cl,%cl
  800930:	74 04                	je     800936 <strncmp+0x2a>
  800932:	3a 0a                	cmp    (%edx),%cl
  800934:	74 eb                	je     800921 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800936:	0f b6 00             	movzbl (%eax),%eax
  800939:	0f b6 12             	movzbl (%edx),%edx
  80093c:	29 d0                	sub    %edx,%eax
}
  80093e:	5b                   	pop    %ebx
  80093f:	5d                   	pop    %ebp
  800940:	c3                   	ret    
		return 0;
  800941:	b8 00 00 00 00       	mov    $0x0,%eax
  800946:	eb f6                	jmp    80093e <strncmp+0x32>

00800948 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800948:	f3 0f 1e fb          	endbr32 
  80094c:	55                   	push   %ebp
  80094d:	89 e5                	mov    %esp,%ebp
  80094f:	8b 45 08             	mov    0x8(%ebp),%eax
  800952:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800956:	0f b6 10             	movzbl (%eax),%edx
  800959:	84 d2                	test   %dl,%dl
  80095b:	74 09                	je     800966 <strchr+0x1e>
		if (*s == c)
  80095d:	38 ca                	cmp    %cl,%dl
  80095f:	74 0a                	je     80096b <strchr+0x23>
	for (; *s; s++)
  800961:	83 c0 01             	add    $0x1,%eax
  800964:	eb f0                	jmp    800956 <strchr+0xe>
			return (char *) s;
	return 0;
  800966:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80096b:	5d                   	pop    %ebp
  80096c:	c3                   	ret    

0080096d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80096d:	f3 0f 1e fb          	endbr32 
  800971:	55                   	push   %ebp
  800972:	89 e5                	mov    %esp,%ebp
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80097b:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80097e:	38 ca                	cmp    %cl,%dl
  800980:	74 09                	je     80098b <strfind+0x1e>
  800982:	84 d2                	test   %dl,%dl
  800984:	74 05                	je     80098b <strfind+0x1e>
	for (; *s; s++)
  800986:	83 c0 01             	add    $0x1,%eax
  800989:	eb f0                	jmp    80097b <strfind+0xe>
			break;
	return (char *) s;
}
  80098b:	5d                   	pop    %ebp
  80098c:	c3                   	ret    

0080098d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80098d:	f3 0f 1e fb          	endbr32 
  800991:	55                   	push   %ebp
  800992:	89 e5                	mov    %esp,%ebp
  800994:	57                   	push   %edi
  800995:	56                   	push   %esi
  800996:	53                   	push   %ebx
  800997:	8b 7d 08             	mov    0x8(%ebp),%edi
  80099a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80099d:	85 c9                	test   %ecx,%ecx
  80099f:	74 31                	je     8009d2 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009a1:	89 f8                	mov    %edi,%eax
  8009a3:	09 c8                	or     %ecx,%eax
  8009a5:	a8 03                	test   $0x3,%al
  8009a7:	75 23                	jne    8009cc <memset+0x3f>
		c &= 0xFF;
  8009a9:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009ad:	89 d3                	mov    %edx,%ebx
  8009af:	c1 e3 08             	shl    $0x8,%ebx
  8009b2:	89 d0                	mov    %edx,%eax
  8009b4:	c1 e0 18             	shl    $0x18,%eax
  8009b7:	89 d6                	mov    %edx,%esi
  8009b9:	c1 e6 10             	shl    $0x10,%esi
  8009bc:	09 f0                	or     %esi,%eax
  8009be:	09 c2                	or     %eax,%edx
  8009c0:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009c2:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009c5:	89 d0                	mov    %edx,%eax
  8009c7:	fc                   	cld    
  8009c8:	f3 ab                	rep stos %eax,%es:(%edi)
  8009ca:	eb 06                	jmp    8009d2 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cf:	fc                   	cld    
  8009d0:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009d2:	89 f8                	mov    %edi,%eax
  8009d4:	5b                   	pop    %ebx
  8009d5:	5e                   	pop    %esi
  8009d6:	5f                   	pop    %edi
  8009d7:	5d                   	pop    %ebp
  8009d8:	c3                   	ret    

008009d9 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009d9:	f3 0f 1e fb          	endbr32 
  8009dd:	55                   	push   %ebp
  8009de:	89 e5                	mov    %esp,%ebp
  8009e0:	57                   	push   %edi
  8009e1:	56                   	push   %esi
  8009e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009eb:	39 c6                	cmp    %eax,%esi
  8009ed:	73 32                	jae    800a21 <memmove+0x48>
  8009ef:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009f2:	39 c2                	cmp    %eax,%edx
  8009f4:	76 2b                	jbe    800a21 <memmove+0x48>
		s += n;
		d += n;
  8009f6:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009f9:	89 fe                	mov    %edi,%esi
  8009fb:	09 ce                	or     %ecx,%esi
  8009fd:	09 d6                	or     %edx,%esi
  8009ff:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a05:	75 0e                	jne    800a15 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a07:	83 ef 04             	sub    $0x4,%edi
  800a0a:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a0d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a10:	fd                   	std    
  800a11:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a13:	eb 09                	jmp    800a1e <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a15:	83 ef 01             	sub    $0x1,%edi
  800a18:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a1b:	fd                   	std    
  800a1c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a1e:	fc                   	cld    
  800a1f:	eb 1a                	jmp    800a3b <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a21:	89 c2                	mov    %eax,%edx
  800a23:	09 ca                	or     %ecx,%edx
  800a25:	09 f2                	or     %esi,%edx
  800a27:	f6 c2 03             	test   $0x3,%dl
  800a2a:	75 0a                	jne    800a36 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a2c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a2f:	89 c7                	mov    %eax,%edi
  800a31:	fc                   	cld    
  800a32:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a34:	eb 05                	jmp    800a3b <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800a36:	89 c7                	mov    %eax,%edi
  800a38:	fc                   	cld    
  800a39:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a3b:	5e                   	pop    %esi
  800a3c:	5f                   	pop    %edi
  800a3d:	5d                   	pop    %ebp
  800a3e:	c3                   	ret    

00800a3f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a3f:	f3 0f 1e fb          	endbr32 
  800a43:	55                   	push   %ebp
  800a44:	89 e5                	mov    %esp,%ebp
  800a46:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a49:	ff 75 10             	pushl  0x10(%ebp)
  800a4c:	ff 75 0c             	pushl  0xc(%ebp)
  800a4f:	ff 75 08             	pushl  0x8(%ebp)
  800a52:	e8 82 ff ff ff       	call   8009d9 <memmove>
}
  800a57:	c9                   	leave  
  800a58:	c3                   	ret    

00800a59 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a59:	f3 0f 1e fb          	endbr32 
  800a5d:	55                   	push   %ebp
  800a5e:	89 e5                	mov    %esp,%ebp
  800a60:	56                   	push   %esi
  800a61:	53                   	push   %ebx
  800a62:	8b 45 08             	mov    0x8(%ebp),%eax
  800a65:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a68:	89 c6                	mov    %eax,%esi
  800a6a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a6d:	39 f0                	cmp    %esi,%eax
  800a6f:	74 1c                	je     800a8d <memcmp+0x34>
		if (*s1 != *s2)
  800a71:	0f b6 08             	movzbl (%eax),%ecx
  800a74:	0f b6 1a             	movzbl (%edx),%ebx
  800a77:	38 d9                	cmp    %bl,%cl
  800a79:	75 08                	jne    800a83 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a7b:	83 c0 01             	add    $0x1,%eax
  800a7e:	83 c2 01             	add    $0x1,%edx
  800a81:	eb ea                	jmp    800a6d <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a83:	0f b6 c1             	movzbl %cl,%eax
  800a86:	0f b6 db             	movzbl %bl,%ebx
  800a89:	29 d8                	sub    %ebx,%eax
  800a8b:	eb 05                	jmp    800a92 <memcmp+0x39>
	}

	return 0;
  800a8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a92:	5b                   	pop    %ebx
  800a93:	5e                   	pop    %esi
  800a94:	5d                   	pop    %ebp
  800a95:	c3                   	ret    

00800a96 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a96:	f3 0f 1e fb          	endbr32 
  800a9a:	55                   	push   %ebp
  800a9b:	89 e5                	mov    %esp,%ebp
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800aa3:	89 c2                	mov    %eax,%edx
  800aa5:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800aa8:	39 d0                	cmp    %edx,%eax
  800aaa:	73 09                	jae    800ab5 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800aac:	38 08                	cmp    %cl,(%eax)
  800aae:	74 05                	je     800ab5 <memfind+0x1f>
	for (; s < ends; s++)
  800ab0:	83 c0 01             	add    $0x1,%eax
  800ab3:	eb f3                	jmp    800aa8 <memfind+0x12>
			break;
	return (void *) s;
}
  800ab5:	5d                   	pop    %ebp
  800ab6:	c3                   	ret    

00800ab7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ab7:	f3 0f 1e fb          	endbr32 
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
  800abe:	57                   	push   %edi
  800abf:	56                   	push   %esi
  800ac0:	53                   	push   %ebx
  800ac1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ac4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ac7:	eb 03                	jmp    800acc <strtol+0x15>
		s++;
  800ac9:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800acc:	0f b6 01             	movzbl (%ecx),%eax
  800acf:	3c 20                	cmp    $0x20,%al
  800ad1:	74 f6                	je     800ac9 <strtol+0x12>
  800ad3:	3c 09                	cmp    $0x9,%al
  800ad5:	74 f2                	je     800ac9 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800ad7:	3c 2b                	cmp    $0x2b,%al
  800ad9:	74 2a                	je     800b05 <strtol+0x4e>
	int neg = 0;
  800adb:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ae0:	3c 2d                	cmp    $0x2d,%al
  800ae2:	74 2b                	je     800b0f <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ae4:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800aea:	75 0f                	jne    800afb <strtol+0x44>
  800aec:	80 39 30             	cmpb   $0x30,(%ecx)
  800aef:	74 28                	je     800b19 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800af1:	85 db                	test   %ebx,%ebx
  800af3:	b8 0a 00 00 00       	mov    $0xa,%eax
  800af8:	0f 44 d8             	cmove  %eax,%ebx
  800afb:	b8 00 00 00 00       	mov    $0x0,%eax
  800b00:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b03:	eb 46                	jmp    800b4b <strtol+0x94>
		s++;
  800b05:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b08:	bf 00 00 00 00       	mov    $0x0,%edi
  800b0d:	eb d5                	jmp    800ae4 <strtol+0x2d>
		s++, neg = 1;
  800b0f:	83 c1 01             	add    $0x1,%ecx
  800b12:	bf 01 00 00 00       	mov    $0x1,%edi
  800b17:	eb cb                	jmp    800ae4 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b19:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b1d:	74 0e                	je     800b2d <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b1f:	85 db                	test   %ebx,%ebx
  800b21:	75 d8                	jne    800afb <strtol+0x44>
		s++, base = 8;
  800b23:	83 c1 01             	add    $0x1,%ecx
  800b26:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b2b:	eb ce                	jmp    800afb <strtol+0x44>
		s += 2, base = 16;
  800b2d:	83 c1 02             	add    $0x2,%ecx
  800b30:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b35:	eb c4                	jmp    800afb <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b37:	0f be d2             	movsbl %dl,%edx
  800b3a:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b3d:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b40:	7d 3a                	jge    800b7c <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b42:	83 c1 01             	add    $0x1,%ecx
  800b45:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b49:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b4b:	0f b6 11             	movzbl (%ecx),%edx
  800b4e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b51:	89 f3                	mov    %esi,%ebx
  800b53:	80 fb 09             	cmp    $0x9,%bl
  800b56:	76 df                	jbe    800b37 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b58:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b5b:	89 f3                	mov    %esi,%ebx
  800b5d:	80 fb 19             	cmp    $0x19,%bl
  800b60:	77 08                	ja     800b6a <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b62:	0f be d2             	movsbl %dl,%edx
  800b65:	83 ea 57             	sub    $0x57,%edx
  800b68:	eb d3                	jmp    800b3d <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b6a:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b6d:	89 f3                	mov    %esi,%ebx
  800b6f:	80 fb 19             	cmp    $0x19,%bl
  800b72:	77 08                	ja     800b7c <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b74:	0f be d2             	movsbl %dl,%edx
  800b77:	83 ea 37             	sub    $0x37,%edx
  800b7a:	eb c1                	jmp    800b3d <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b7c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b80:	74 05                	je     800b87 <strtol+0xd0>
		*endptr = (char *) s;
  800b82:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b85:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b87:	89 c2                	mov    %eax,%edx
  800b89:	f7 da                	neg    %edx
  800b8b:	85 ff                	test   %edi,%edi
  800b8d:	0f 45 c2             	cmovne %edx,%eax
}
  800b90:	5b                   	pop    %ebx
  800b91:	5e                   	pop    %esi
  800b92:	5f                   	pop    %edi
  800b93:	5d                   	pop    %ebp
  800b94:	c3                   	ret    

00800b95 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b95:	f3 0f 1e fb          	endbr32 
  800b99:	55                   	push   %ebp
  800b9a:	89 e5                	mov    %esp,%ebp
  800b9c:	57                   	push   %edi
  800b9d:	56                   	push   %esi
  800b9e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b9f:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800baa:	89 c3                	mov    %eax,%ebx
  800bac:	89 c7                	mov    %eax,%edi
  800bae:	89 c6                	mov    %eax,%esi
  800bb0:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bb2:	5b                   	pop    %ebx
  800bb3:	5e                   	pop    %esi
  800bb4:	5f                   	pop    %edi
  800bb5:	5d                   	pop    %ebp
  800bb6:	c3                   	ret    

00800bb7 <sys_cgetc>:

int
sys_cgetc(void)
{
  800bb7:	f3 0f 1e fb          	endbr32 
  800bbb:	55                   	push   %ebp
  800bbc:	89 e5                	mov    %esp,%ebp
  800bbe:	57                   	push   %edi
  800bbf:	56                   	push   %esi
  800bc0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bc1:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc6:	b8 01 00 00 00       	mov    $0x1,%eax
  800bcb:	89 d1                	mov    %edx,%ecx
  800bcd:	89 d3                	mov    %edx,%ebx
  800bcf:	89 d7                	mov    %edx,%edi
  800bd1:	89 d6                	mov    %edx,%esi
  800bd3:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bd5:	5b                   	pop    %ebx
  800bd6:	5e                   	pop    %esi
  800bd7:	5f                   	pop    %edi
  800bd8:	5d                   	pop    %ebp
  800bd9:	c3                   	ret    

00800bda <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bda:	f3 0f 1e fb          	endbr32 
  800bde:	55                   	push   %ebp
  800bdf:	89 e5                	mov    %esp,%ebp
  800be1:	57                   	push   %edi
  800be2:	56                   	push   %esi
  800be3:	53                   	push   %ebx
  800be4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800be7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bec:	8b 55 08             	mov    0x8(%ebp),%edx
  800bef:	b8 03 00 00 00       	mov    $0x3,%eax
  800bf4:	89 cb                	mov    %ecx,%ebx
  800bf6:	89 cf                	mov    %ecx,%edi
  800bf8:	89 ce                	mov    %ecx,%esi
  800bfa:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bfc:	85 c0                	test   %eax,%eax
  800bfe:	7f 08                	jg     800c08 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c03:	5b                   	pop    %ebx
  800c04:	5e                   	pop    %esi
  800c05:	5f                   	pop    %edi
  800c06:	5d                   	pop    %ebp
  800c07:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c08:	83 ec 0c             	sub    $0xc,%esp
  800c0b:	50                   	push   %eax
  800c0c:	6a 03                	push   $0x3
  800c0e:	68 24 14 80 00       	push   $0x801424
  800c13:	6a 23                	push   $0x23
  800c15:	68 41 14 80 00       	push   $0x801441
  800c1a:	e8 13 f5 ff ff       	call   800132 <_panic>

00800c1f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c1f:	f3 0f 1e fb          	endbr32 
  800c23:	55                   	push   %ebp
  800c24:	89 e5                	mov    %esp,%ebp
  800c26:	57                   	push   %edi
  800c27:	56                   	push   %esi
  800c28:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c29:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2e:	b8 02 00 00 00       	mov    $0x2,%eax
  800c33:	89 d1                	mov    %edx,%ecx
  800c35:	89 d3                	mov    %edx,%ebx
  800c37:	89 d7                	mov    %edx,%edi
  800c39:	89 d6                	mov    %edx,%esi
  800c3b:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c3d:	5b                   	pop    %ebx
  800c3e:	5e                   	pop    %esi
  800c3f:	5f                   	pop    %edi
  800c40:	5d                   	pop    %ebp
  800c41:	c3                   	ret    

00800c42 <sys_yield>:

void
sys_yield(void)
{
  800c42:	f3 0f 1e fb          	endbr32 
  800c46:	55                   	push   %ebp
  800c47:	89 e5                	mov    %esp,%ebp
  800c49:	57                   	push   %edi
  800c4a:	56                   	push   %esi
  800c4b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c4c:	ba 00 00 00 00       	mov    $0x0,%edx
  800c51:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c56:	89 d1                	mov    %edx,%ecx
  800c58:	89 d3                	mov    %edx,%ebx
  800c5a:	89 d7                	mov    %edx,%edi
  800c5c:	89 d6                	mov    %edx,%esi
  800c5e:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c60:	5b                   	pop    %ebx
  800c61:	5e                   	pop    %esi
  800c62:	5f                   	pop    %edi
  800c63:	5d                   	pop    %ebp
  800c64:	c3                   	ret    

00800c65 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c65:	f3 0f 1e fb          	endbr32 
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	57                   	push   %edi
  800c6d:	56                   	push   %esi
  800c6e:	53                   	push   %ebx
  800c6f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c72:	be 00 00 00 00       	mov    $0x0,%esi
  800c77:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c7d:	b8 04 00 00 00       	mov    $0x4,%eax
  800c82:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c85:	89 f7                	mov    %esi,%edi
  800c87:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c89:	85 c0                	test   %eax,%eax
  800c8b:	7f 08                	jg     800c95 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c90:	5b                   	pop    %ebx
  800c91:	5e                   	pop    %esi
  800c92:	5f                   	pop    %edi
  800c93:	5d                   	pop    %ebp
  800c94:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c95:	83 ec 0c             	sub    $0xc,%esp
  800c98:	50                   	push   %eax
  800c99:	6a 04                	push   $0x4
  800c9b:	68 24 14 80 00       	push   $0x801424
  800ca0:	6a 23                	push   $0x23
  800ca2:	68 41 14 80 00       	push   $0x801441
  800ca7:	e8 86 f4 ff ff       	call   800132 <_panic>

00800cac <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cac:	f3 0f 1e fb          	endbr32 
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	57                   	push   %edi
  800cb4:	56                   	push   %esi
  800cb5:	53                   	push   %ebx
  800cb6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cbf:	b8 05 00 00 00       	mov    $0x5,%eax
  800cc4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cc7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cca:	8b 75 18             	mov    0x18(%ebp),%esi
  800ccd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ccf:	85 c0                	test   %eax,%eax
  800cd1:	7f 08                	jg     800cdb <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd6:	5b                   	pop    %ebx
  800cd7:	5e                   	pop    %esi
  800cd8:	5f                   	pop    %edi
  800cd9:	5d                   	pop    %ebp
  800cda:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cdb:	83 ec 0c             	sub    $0xc,%esp
  800cde:	50                   	push   %eax
  800cdf:	6a 05                	push   $0x5
  800ce1:	68 24 14 80 00       	push   $0x801424
  800ce6:	6a 23                	push   $0x23
  800ce8:	68 41 14 80 00       	push   $0x801441
  800ced:	e8 40 f4 ff ff       	call   800132 <_panic>

00800cf2 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cf2:	f3 0f 1e fb          	endbr32 
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
  800cf9:	57                   	push   %edi
  800cfa:	56                   	push   %esi
  800cfb:	53                   	push   %ebx
  800cfc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cff:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d04:	8b 55 08             	mov    0x8(%ebp),%edx
  800d07:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d0a:	b8 06 00 00 00       	mov    $0x6,%eax
  800d0f:	89 df                	mov    %ebx,%edi
  800d11:	89 de                	mov    %ebx,%esi
  800d13:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d15:	85 c0                	test   %eax,%eax
  800d17:	7f 08                	jg     800d21 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d1c:	5b                   	pop    %ebx
  800d1d:	5e                   	pop    %esi
  800d1e:	5f                   	pop    %edi
  800d1f:	5d                   	pop    %ebp
  800d20:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d21:	83 ec 0c             	sub    $0xc,%esp
  800d24:	50                   	push   %eax
  800d25:	6a 06                	push   $0x6
  800d27:	68 24 14 80 00       	push   $0x801424
  800d2c:	6a 23                	push   $0x23
  800d2e:	68 41 14 80 00       	push   $0x801441
  800d33:	e8 fa f3 ff ff       	call   800132 <_panic>

00800d38 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d38:	f3 0f 1e fb          	endbr32 
  800d3c:	55                   	push   %ebp
  800d3d:	89 e5                	mov    %esp,%ebp
  800d3f:	57                   	push   %edi
  800d40:	56                   	push   %esi
  800d41:	53                   	push   %ebx
  800d42:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d45:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d50:	b8 08 00 00 00       	mov    $0x8,%eax
  800d55:	89 df                	mov    %ebx,%edi
  800d57:	89 de                	mov    %ebx,%esi
  800d59:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d5b:	85 c0                	test   %eax,%eax
  800d5d:	7f 08                	jg     800d67 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d62:	5b                   	pop    %ebx
  800d63:	5e                   	pop    %esi
  800d64:	5f                   	pop    %edi
  800d65:	5d                   	pop    %ebp
  800d66:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d67:	83 ec 0c             	sub    $0xc,%esp
  800d6a:	50                   	push   %eax
  800d6b:	6a 08                	push   $0x8
  800d6d:	68 24 14 80 00       	push   $0x801424
  800d72:	6a 23                	push   $0x23
  800d74:	68 41 14 80 00       	push   $0x801441
  800d79:	e8 b4 f3 ff ff       	call   800132 <_panic>

00800d7e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d7e:	f3 0f 1e fb          	endbr32 
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	57                   	push   %edi
  800d86:	56                   	push   %esi
  800d87:	53                   	push   %ebx
  800d88:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d90:	8b 55 08             	mov    0x8(%ebp),%edx
  800d93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d96:	b8 09 00 00 00       	mov    $0x9,%eax
  800d9b:	89 df                	mov    %ebx,%edi
  800d9d:	89 de                	mov    %ebx,%esi
  800d9f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da1:	85 c0                	test   %eax,%eax
  800da3:	7f 08                	jg     800dad <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800da5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da8:	5b                   	pop    %ebx
  800da9:	5e                   	pop    %esi
  800daa:	5f                   	pop    %edi
  800dab:	5d                   	pop    %ebp
  800dac:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dad:	83 ec 0c             	sub    $0xc,%esp
  800db0:	50                   	push   %eax
  800db1:	6a 09                	push   $0x9
  800db3:	68 24 14 80 00       	push   $0x801424
  800db8:	6a 23                	push   $0x23
  800dba:	68 41 14 80 00       	push   $0x801441
  800dbf:	e8 6e f3 ff ff       	call   800132 <_panic>

00800dc4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dc4:	f3 0f 1e fb          	endbr32 
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
  800dcb:	57                   	push   %edi
  800dcc:	56                   	push   %esi
  800dcd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dce:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd4:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dd9:	be 00 00 00 00       	mov    $0x0,%esi
  800dde:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800de1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800de4:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800de6:	5b                   	pop    %ebx
  800de7:	5e                   	pop    %esi
  800de8:	5f                   	pop    %edi
  800de9:	5d                   	pop    %ebp
  800dea:	c3                   	ret    

00800deb <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800deb:	f3 0f 1e fb          	endbr32 
  800def:	55                   	push   %ebp
  800df0:	89 e5                	mov    %esp,%ebp
  800df2:	57                   	push   %edi
  800df3:	56                   	push   %esi
  800df4:	53                   	push   %ebx
  800df5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dfd:	8b 55 08             	mov    0x8(%ebp),%edx
  800e00:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e05:	89 cb                	mov    %ecx,%ebx
  800e07:	89 cf                	mov    %ecx,%edi
  800e09:	89 ce                	mov    %ecx,%esi
  800e0b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e0d:	85 c0                	test   %eax,%eax
  800e0f:	7f 08                	jg     800e19 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e14:	5b                   	pop    %ebx
  800e15:	5e                   	pop    %esi
  800e16:	5f                   	pop    %edi
  800e17:	5d                   	pop    %ebp
  800e18:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e19:	83 ec 0c             	sub    $0xc,%esp
  800e1c:	50                   	push   %eax
  800e1d:	6a 0c                	push   $0xc
  800e1f:	68 24 14 80 00       	push   $0x801424
  800e24:	6a 23                	push   $0x23
  800e26:	68 41 14 80 00       	push   $0x801441
  800e2b:	e8 02 f3 ff ff       	call   800132 <_panic>

00800e30 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800e30:	f3 0f 1e fb          	endbr32 
  800e34:	55                   	push   %ebp
  800e35:	89 e5                	mov    %esp,%ebp
  800e37:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800e3a:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  800e41:	74 0a                	je     800e4d <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800e43:	8b 45 08             	mov    0x8(%ebp),%eax
  800e46:	a3 08 20 80 00       	mov    %eax,0x802008
}
  800e4b:	c9                   	leave  
  800e4c:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  800e4d:	83 ec 04             	sub    $0x4,%esp
  800e50:	6a 07                	push   $0x7
  800e52:	68 00 f0 bf ee       	push   $0xeebff000
  800e57:	6a 00                	push   $0x0
  800e59:	e8 07 fe ff ff       	call   800c65 <sys_page_alloc>
  800e5e:	83 c4 10             	add    $0x10,%esp
  800e61:	85 c0                	test   %eax,%eax
  800e63:	78 2a                	js     800e8f <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  800e65:	83 ec 08             	sub    $0x8,%esp
  800e68:	68 a3 0e 80 00       	push   $0x800ea3
  800e6d:	6a 00                	push   $0x0
  800e6f:	e8 0a ff ff ff       	call   800d7e <sys_env_set_pgfault_upcall>
  800e74:	83 c4 10             	add    $0x10,%esp
  800e77:	85 c0                	test   %eax,%eax
  800e79:	79 c8                	jns    800e43 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  800e7b:	83 ec 04             	sub    $0x4,%esp
  800e7e:	68 7c 14 80 00       	push   $0x80147c
  800e83:	6a 25                	push   $0x25
  800e85:	68 b4 14 80 00       	push   $0x8014b4
  800e8a:	e8 a3 f2 ff ff       	call   800132 <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  800e8f:	83 ec 04             	sub    $0x4,%esp
  800e92:	68 50 14 80 00       	push   $0x801450
  800e97:	6a 22                	push   $0x22
  800e99:	68 b4 14 80 00       	push   $0x8014b4
  800e9e:	e8 8f f2 ff ff       	call   800132 <_panic>

00800ea3 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800ea3:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800ea4:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  800ea9:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800eab:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  800eae:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  800eb2:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  800eb6:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  800eb9:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  800ebb:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  800ebf:	83 c4 08             	add    $0x8,%esp
	popal
  800ec2:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  800ec3:	83 c4 04             	add    $0x4,%esp
	popfl
  800ec6:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  800ec7:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  800ec8:	c3                   	ret    
  800ec9:	66 90                	xchg   %ax,%ax
  800ecb:	66 90                	xchg   %ax,%ax
  800ecd:	66 90                	xchg   %ax,%ax
  800ecf:	90                   	nop

00800ed0 <__udivdi3>:
  800ed0:	f3 0f 1e fb          	endbr32 
  800ed4:	55                   	push   %ebp
  800ed5:	57                   	push   %edi
  800ed6:	56                   	push   %esi
  800ed7:	53                   	push   %ebx
  800ed8:	83 ec 1c             	sub    $0x1c,%esp
  800edb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800edf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800ee3:	8b 74 24 34          	mov    0x34(%esp),%esi
  800ee7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800eeb:	85 d2                	test   %edx,%edx
  800eed:	75 19                	jne    800f08 <__udivdi3+0x38>
  800eef:	39 f3                	cmp    %esi,%ebx
  800ef1:	76 4d                	jbe    800f40 <__udivdi3+0x70>
  800ef3:	31 ff                	xor    %edi,%edi
  800ef5:	89 e8                	mov    %ebp,%eax
  800ef7:	89 f2                	mov    %esi,%edx
  800ef9:	f7 f3                	div    %ebx
  800efb:	89 fa                	mov    %edi,%edx
  800efd:	83 c4 1c             	add    $0x1c,%esp
  800f00:	5b                   	pop    %ebx
  800f01:	5e                   	pop    %esi
  800f02:	5f                   	pop    %edi
  800f03:	5d                   	pop    %ebp
  800f04:	c3                   	ret    
  800f05:	8d 76 00             	lea    0x0(%esi),%esi
  800f08:	39 f2                	cmp    %esi,%edx
  800f0a:	76 14                	jbe    800f20 <__udivdi3+0x50>
  800f0c:	31 ff                	xor    %edi,%edi
  800f0e:	31 c0                	xor    %eax,%eax
  800f10:	89 fa                	mov    %edi,%edx
  800f12:	83 c4 1c             	add    $0x1c,%esp
  800f15:	5b                   	pop    %ebx
  800f16:	5e                   	pop    %esi
  800f17:	5f                   	pop    %edi
  800f18:	5d                   	pop    %ebp
  800f19:	c3                   	ret    
  800f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800f20:	0f bd fa             	bsr    %edx,%edi
  800f23:	83 f7 1f             	xor    $0x1f,%edi
  800f26:	75 48                	jne    800f70 <__udivdi3+0xa0>
  800f28:	39 f2                	cmp    %esi,%edx
  800f2a:	72 06                	jb     800f32 <__udivdi3+0x62>
  800f2c:	31 c0                	xor    %eax,%eax
  800f2e:	39 eb                	cmp    %ebp,%ebx
  800f30:	77 de                	ja     800f10 <__udivdi3+0x40>
  800f32:	b8 01 00 00 00       	mov    $0x1,%eax
  800f37:	eb d7                	jmp    800f10 <__udivdi3+0x40>
  800f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f40:	89 d9                	mov    %ebx,%ecx
  800f42:	85 db                	test   %ebx,%ebx
  800f44:	75 0b                	jne    800f51 <__udivdi3+0x81>
  800f46:	b8 01 00 00 00       	mov    $0x1,%eax
  800f4b:	31 d2                	xor    %edx,%edx
  800f4d:	f7 f3                	div    %ebx
  800f4f:	89 c1                	mov    %eax,%ecx
  800f51:	31 d2                	xor    %edx,%edx
  800f53:	89 f0                	mov    %esi,%eax
  800f55:	f7 f1                	div    %ecx
  800f57:	89 c6                	mov    %eax,%esi
  800f59:	89 e8                	mov    %ebp,%eax
  800f5b:	89 f7                	mov    %esi,%edi
  800f5d:	f7 f1                	div    %ecx
  800f5f:	89 fa                	mov    %edi,%edx
  800f61:	83 c4 1c             	add    $0x1c,%esp
  800f64:	5b                   	pop    %ebx
  800f65:	5e                   	pop    %esi
  800f66:	5f                   	pop    %edi
  800f67:	5d                   	pop    %ebp
  800f68:	c3                   	ret    
  800f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f70:	89 f9                	mov    %edi,%ecx
  800f72:	b8 20 00 00 00       	mov    $0x20,%eax
  800f77:	29 f8                	sub    %edi,%eax
  800f79:	d3 e2                	shl    %cl,%edx
  800f7b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800f7f:	89 c1                	mov    %eax,%ecx
  800f81:	89 da                	mov    %ebx,%edx
  800f83:	d3 ea                	shr    %cl,%edx
  800f85:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800f89:	09 d1                	or     %edx,%ecx
  800f8b:	89 f2                	mov    %esi,%edx
  800f8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800f91:	89 f9                	mov    %edi,%ecx
  800f93:	d3 e3                	shl    %cl,%ebx
  800f95:	89 c1                	mov    %eax,%ecx
  800f97:	d3 ea                	shr    %cl,%edx
  800f99:	89 f9                	mov    %edi,%ecx
  800f9b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800f9f:	89 eb                	mov    %ebp,%ebx
  800fa1:	d3 e6                	shl    %cl,%esi
  800fa3:	89 c1                	mov    %eax,%ecx
  800fa5:	d3 eb                	shr    %cl,%ebx
  800fa7:	09 de                	or     %ebx,%esi
  800fa9:	89 f0                	mov    %esi,%eax
  800fab:	f7 74 24 08          	divl   0x8(%esp)
  800faf:	89 d6                	mov    %edx,%esi
  800fb1:	89 c3                	mov    %eax,%ebx
  800fb3:	f7 64 24 0c          	mull   0xc(%esp)
  800fb7:	39 d6                	cmp    %edx,%esi
  800fb9:	72 15                	jb     800fd0 <__udivdi3+0x100>
  800fbb:	89 f9                	mov    %edi,%ecx
  800fbd:	d3 e5                	shl    %cl,%ebp
  800fbf:	39 c5                	cmp    %eax,%ebp
  800fc1:	73 04                	jae    800fc7 <__udivdi3+0xf7>
  800fc3:	39 d6                	cmp    %edx,%esi
  800fc5:	74 09                	je     800fd0 <__udivdi3+0x100>
  800fc7:	89 d8                	mov    %ebx,%eax
  800fc9:	31 ff                	xor    %edi,%edi
  800fcb:	e9 40 ff ff ff       	jmp    800f10 <__udivdi3+0x40>
  800fd0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800fd3:	31 ff                	xor    %edi,%edi
  800fd5:	e9 36 ff ff ff       	jmp    800f10 <__udivdi3+0x40>
  800fda:	66 90                	xchg   %ax,%ax
  800fdc:	66 90                	xchg   %ax,%ax
  800fde:	66 90                	xchg   %ax,%ax

00800fe0 <__umoddi3>:
  800fe0:	f3 0f 1e fb          	endbr32 
  800fe4:	55                   	push   %ebp
  800fe5:	57                   	push   %edi
  800fe6:	56                   	push   %esi
  800fe7:	53                   	push   %ebx
  800fe8:	83 ec 1c             	sub    $0x1c,%esp
  800feb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800fef:	8b 74 24 30          	mov    0x30(%esp),%esi
  800ff3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800ff7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800ffb:	85 c0                	test   %eax,%eax
  800ffd:	75 19                	jne    801018 <__umoddi3+0x38>
  800fff:	39 df                	cmp    %ebx,%edi
  801001:	76 5d                	jbe    801060 <__umoddi3+0x80>
  801003:	89 f0                	mov    %esi,%eax
  801005:	89 da                	mov    %ebx,%edx
  801007:	f7 f7                	div    %edi
  801009:	89 d0                	mov    %edx,%eax
  80100b:	31 d2                	xor    %edx,%edx
  80100d:	83 c4 1c             	add    $0x1c,%esp
  801010:	5b                   	pop    %ebx
  801011:	5e                   	pop    %esi
  801012:	5f                   	pop    %edi
  801013:	5d                   	pop    %ebp
  801014:	c3                   	ret    
  801015:	8d 76 00             	lea    0x0(%esi),%esi
  801018:	89 f2                	mov    %esi,%edx
  80101a:	39 d8                	cmp    %ebx,%eax
  80101c:	76 12                	jbe    801030 <__umoddi3+0x50>
  80101e:	89 f0                	mov    %esi,%eax
  801020:	89 da                	mov    %ebx,%edx
  801022:	83 c4 1c             	add    $0x1c,%esp
  801025:	5b                   	pop    %ebx
  801026:	5e                   	pop    %esi
  801027:	5f                   	pop    %edi
  801028:	5d                   	pop    %ebp
  801029:	c3                   	ret    
  80102a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801030:	0f bd e8             	bsr    %eax,%ebp
  801033:	83 f5 1f             	xor    $0x1f,%ebp
  801036:	75 50                	jne    801088 <__umoddi3+0xa8>
  801038:	39 d8                	cmp    %ebx,%eax
  80103a:	0f 82 e0 00 00 00    	jb     801120 <__umoddi3+0x140>
  801040:	89 d9                	mov    %ebx,%ecx
  801042:	39 f7                	cmp    %esi,%edi
  801044:	0f 86 d6 00 00 00    	jbe    801120 <__umoddi3+0x140>
  80104a:	89 d0                	mov    %edx,%eax
  80104c:	89 ca                	mov    %ecx,%edx
  80104e:	83 c4 1c             	add    $0x1c,%esp
  801051:	5b                   	pop    %ebx
  801052:	5e                   	pop    %esi
  801053:	5f                   	pop    %edi
  801054:	5d                   	pop    %ebp
  801055:	c3                   	ret    
  801056:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80105d:	8d 76 00             	lea    0x0(%esi),%esi
  801060:	89 fd                	mov    %edi,%ebp
  801062:	85 ff                	test   %edi,%edi
  801064:	75 0b                	jne    801071 <__umoddi3+0x91>
  801066:	b8 01 00 00 00       	mov    $0x1,%eax
  80106b:	31 d2                	xor    %edx,%edx
  80106d:	f7 f7                	div    %edi
  80106f:	89 c5                	mov    %eax,%ebp
  801071:	89 d8                	mov    %ebx,%eax
  801073:	31 d2                	xor    %edx,%edx
  801075:	f7 f5                	div    %ebp
  801077:	89 f0                	mov    %esi,%eax
  801079:	f7 f5                	div    %ebp
  80107b:	89 d0                	mov    %edx,%eax
  80107d:	31 d2                	xor    %edx,%edx
  80107f:	eb 8c                	jmp    80100d <__umoddi3+0x2d>
  801081:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801088:	89 e9                	mov    %ebp,%ecx
  80108a:	ba 20 00 00 00       	mov    $0x20,%edx
  80108f:	29 ea                	sub    %ebp,%edx
  801091:	d3 e0                	shl    %cl,%eax
  801093:	89 44 24 08          	mov    %eax,0x8(%esp)
  801097:	89 d1                	mov    %edx,%ecx
  801099:	89 f8                	mov    %edi,%eax
  80109b:	d3 e8                	shr    %cl,%eax
  80109d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8010a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8010a5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8010a9:	09 c1                	or     %eax,%ecx
  8010ab:	89 d8                	mov    %ebx,%eax
  8010ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8010b1:	89 e9                	mov    %ebp,%ecx
  8010b3:	d3 e7                	shl    %cl,%edi
  8010b5:	89 d1                	mov    %edx,%ecx
  8010b7:	d3 e8                	shr    %cl,%eax
  8010b9:	89 e9                	mov    %ebp,%ecx
  8010bb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8010bf:	d3 e3                	shl    %cl,%ebx
  8010c1:	89 c7                	mov    %eax,%edi
  8010c3:	89 d1                	mov    %edx,%ecx
  8010c5:	89 f0                	mov    %esi,%eax
  8010c7:	d3 e8                	shr    %cl,%eax
  8010c9:	89 e9                	mov    %ebp,%ecx
  8010cb:	89 fa                	mov    %edi,%edx
  8010cd:	d3 e6                	shl    %cl,%esi
  8010cf:	09 d8                	or     %ebx,%eax
  8010d1:	f7 74 24 08          	divl   0x8(%esp)
  8010d5:	89 d1                	mov    %edx,%ecx
  8010d7:	89 f3                	mov    %esi,%ebx
  8010d9:	f7 64 24 0c          	mull   0xc(%esp)
  8010dd:	89 c6                	mov    %eax,%esi
  8010df:	89 d7                	mov    %edx,%edi
  8010e1:	39 d1                	cmp    %edx,%ecx
  8010e3:	72 06                	jb     8010eb <__umoddi3+0x10b>
  8010e5:	75 10                	jne    8010f7 <__umoddi3+0x117>
  8010e7:	39 c3                	cmp    %eax,%ebx
  8010e9:	73 0c                	jae    8010f7 <__umoddi3+0x117>
  8010eb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8010ef:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8010f3:	89 d7                	mov    %edx,%edi
  8010f5:	89 c6                	mov    %eax,%esi
  8010f7:	89 ca                	mov    %ecx,%edx
  8010f9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8010fe:	29 f3                	sub    %esi,%ebx
  801100:	19 fa                	sbb    %edi,%edx
  801102:	89 d0                	mov    %edx,%eax
  801104:	d3 e0                	shl    %cl,%eax
  801106:	89 e9                	mov    %ebp,%ecx
  801108:	d3 eb                	shr    %cl,%ebx
  80110a:	d3 ea                	shr    %cl,%edx
  80110c:	09 d8                	or     %ebx,%eax
  80110e:	83 c4 1c             	add    $0x1c,%esp
  801111:	5b                   	pop    %ebx
  801112:	5e                   	pop    %esi
  801113:	5f                   	pop    %edi
  801114:	5d                   	pop    %ebp
  801115:	c3                   	ret    
  801116:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80111d:	8d 76 00             	lea    0x0(%esi),%esi
  801120:	29 fe                	sub    %edi,%esi
  801122:	19 c3                	sbb    %eax,%ebx
  801124:	89 f2                	mov    %esi,%edx
  801126:	89 d9                	mov    %ebx,%ecx
  801128:	e9 1d ff ff ff       	jmp    80104a <__umoddi3+0x6a>
