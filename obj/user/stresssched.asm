
obj/user/stresssched.debug:     file format elf32-i386


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
  80002c:	e8 b6 00 00 00       	call   8000e7 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

volatile int counter;

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	56                   	push   %esi
  80003b:	53                   	push   %ebx
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();
  80003c:	e8 fb 0b 00 00       	call   800c3c <sys_getenvid>
  800041:	89 c6                	mov    %eax,%esi

	// Fork several environments
	for (i = 0; i < 20; i++)
  800043:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fork() == 0)
  800048:	e8 d5 0f 00 00       	call   801022 <fork>
  80004d:	85 c0                	test   %eax,%eax
  80004f:	74 0f                	je     800060 <umain+0x2d>
	for (i = 0; i < 20; i++)
  800051:	83 c3 01             	add    $0x1,%ebx
  800054:	83 fb 14             	cmp    $0x14,%ebx
  800057:	75 ef                	jne    800048 <umain+0x15>
			break;
	if (i == 20) {
		sys_yield();
  800059:	e8 01 0c 00 00       	call   800c5f <sys_yield>
		return;
  80005e:	eb 69                	jmp    8000c9 <umain+0x96>
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  800060:	89 f0                	mov    %esi,%eax
  800062:	25 ff 03 00 00       	and    $0x3ff,%eax
  800067:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80006a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006f:	eb 02                	jmp    800073 <umain+0x40>
		asm volatile("pause");
  800071:	f3 90                	pause  
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  800073:	8b 50 54             	mov    0x54(%eax),%edx
  800076:	85 d2                	test   %edx,%edx
  800078:	75 f7                	jne    800071 <umain+0x3e>
  80007a:	bb 0a 00 00 00       	mov    $0xa,%ebx

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
  80007f:	e8 db 0b 00 00       	call   800c5f <sys_yield>
  800084:	ba 10 27 00 00       	mov    $0x2710,%edx
		for (j = 0; j < 10000; j++)
			counter++;
  800089:	a1 08 40 80 00       	mov    0x804008,%eax
  80008e:	83 c0 01             	add    $0x1,%eax
  800091:	a3 08 40 80 00       	mov    %eax,0x804008
		for (j = 0; j < 10000; j++)
  800096:	83 ea 01             	sub    $0x1,%edx
  800099:	75 ee                	jne    800089 <umain+0x56>
	for (i = 0; i < 10; i++) {
  80009b:	83 eb 01             	sub    $0x1,%ebx
  80009e:	75 df                	jne    80007f <umain+0x4c>
	}

	if (counter != 10*10000)
  8000a0:	a1 08 40 80 00       	mov    0x804008,%eax
  8000a5:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  8000aa:	75 24                	jne    8000d0 <umain+0x9d>
		panic("ran on two CPUs at once (counter is %d)", counter);

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  8000ac:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8000b1:	8b 50 5c             	mov    0x5c(%eax),%edx
  8000b4:	8b 40 48             	mov    0x48(%eax),%eax
  8000b7:	83 ec 04             	sub    $0x4,%esp
  8000ba:	52                   	push   %edx
  8000bb:	50                   	push   %eax
  8000bc:	68 db 28 80 00       	push   $0x8028db
  8000c1:	e8 70 01 00 00       	call   800236 <cprintf>
  8000c6:	83 c4 10             	add    $0x10,%esp

}
  8000c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000cc:	5b                   	pop    %ebx
  8000cd:	5e                   	pop    %esi
  8000ce:	5d                   	pop    %ebp
  8000cf:	c3                   	ret    
		panic("ran on two CPUs at once (counter is %d)", counter);
  8000d0:	a1 08 40 80 00       	mov    0x804008,%eax
  8000d5:	50                   	push   %eax
  8000d6:	68 a0 28 80 00       	push   $0x8028a0
  8000db:	6a 21                	push   $0x21
  8000dd:	68 c8 28 80 00       	push   $0x8028c8
  8000e2:	e8 68 00 00 00       	call   80014f <_panic>

008000e7 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e7:	f3 0f 1e fb          	endbr32 
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	56                   	push   %esi
  8000ef:	53                   	push   %ebx
  8000f0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000f3:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000f6:	e8 41 0b 00 00       	call   800c3c <sys_getenvid>
  8000fb:	25 ff 03 00 00       	and    $0x3ff,%eax
  800100:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800103:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800108:	a3 0c 40 80 00       	mov    %eax,0x80400c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80010d:	85 db                	test   %ebx,%ebx
  80010f:	7e 07                	jle    800118 <libmain+0x31>
		binaryname = argv[0];
  800111:	8b 06                	mov    (%esi),%eax
  800113:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800118:	83 ec 08             	sub    $0x8,%esp
  80011b:	56                   	push   %esi
  80011c:	53                   	push   %ebx
  80011d:	e8 11 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800122:	e8 0a 00 00 00       	call   800131 <exit>
}
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80012d:	5b                   	pop    %ebx
  80012e:	5e                   	pop    %esi
  80012f:	5d                   	pop    %ebp
  800130:	c3                   	ret    

00800131 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800131:	f3 0f 1e fb          	endbr32 
  800135:	55                   	push   %ebp
  800136:	89 e5                	mov    %esp,%ebp
  800138:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80013b:	e8 ef 12 00 00       	call   80142f <close_all>
	sys_env_destroy(0);
  800140:	83 ec 0c             	sub    $0xc,%esp
  800143:	6a 00                	push   $0x0
  800145:	e8 ad 0a 00 00       	call   800bf7 <sys_env_destroy>
}
  80014a:	83 c4 10             	add    $0x10,%esp
  80014d:	c9                   	leave  
  80014e:	c3                   	ret    

0080014f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80014f:	f3 0f 1e fb          	endbr32 
  800153:	55                   	push   %ebp
  800154:	89 e5                	mov    %esp,%ebp
  800156:	56                   	push   %esi
  800157:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800158:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80015b:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800161:	e8 d6 0a 00 00       	call   800c3c <sys_getenvid>
  800166:	83 ec 0c             	sub    $0xc,%esp
  800169:	ff 75 0c             	pushl  0xc(%ebp)
  80016c:	ff 75 08             	pushl  0x8(%ebp)
  80016f:	56                   	push   %esi
  800170:	50                   	push   %eax
  800171:	68 04 29 80 00       	push   $0x802904
  800176:	e8 bb 00 00 00       	call   800236 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80017b:	83 c4 18             	add    $0x18,%esp
  80017e:	53                   	push   %ebx
  80017f:	ff 75 10             	pushl  0x10(%ebp)
  800182:	e8 5a 00 00 00       	call   8001e1 <vcprintf>
	cprintf("\n");
  800187:	c7 04 24 f7 28 80 00 	movl   $0x8028f7,(%esp)
  80018e:	e8 a3 00 00 00       	call   800236 <cprintf>
  800193:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800196:	cc                   	int3   
  800197:	eb fd                	jmp    800196 <_panic+0x47>

00800199 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800199:	f3 0f 1e fb          	endbr32 
  80019d:	55                   	push   %ebp
  80019e:	89 e5                	mov    %esp,%ebp
  8001a0:	53                   	push   %ebx
  8001a1:	83 ec 04             	sub    $0x4,%esp
  8001a4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001a7:	8b 13                	mov    (%ebx),%edx
  8001a9:	8d 42 01             	lea    0x1(%edx),%eax
  8001ac:	89 03                	mov    %eax,(%ebx)
  8001ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001b1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001b5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001ba:	74 09                	je     8001c5 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001bc:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001c3:	c9                   	leave  
  8001c4:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001c5:	83 ec 08             	sub    $0x8,%esp
  8001c8:	68 ff 00 00 00       	push   $0xff
  8001cd:	8d 43 08             	lea    0x8(%ebx),%eax
  8001d0:	50                   	push   %eax
  8001d1:	e8 dc 09 00 00       	call   800bb2 <sys_cputs>
		b->idx = 0;
  8001d6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001dc:	83 c4 10             	add    $0x10,%esp
  8001df:	eb db                	jmp    8001bc <putch+0x23>

008001e1 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001e1:	f3 0f 1e fb          	endbr32 
  8001e5:	55                   	push   %ebp
  8001e6:	89 e5                	mov    %esp,%ebp
  8001e8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001ee:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001f5:	00 00 00 
	b.cnt = 0;
  8001f8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001ff:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800202:	ff 75 0c             	pushl  0xc(%ebp)
  800205:	ff 75 08             	pushl  0x8(%ebp)
  800208:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80020e:	50                   	push   %eax
  80020f:	68 99 01 80 00       	push   $0x800199
  800214:	e8 20 01 00 00       	call   800339 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800219:	83 c4 08             	add    $0x8,%esp
  80021c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800222:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800228:	50                   	push   %eax
  800229:	e8 84 09 00 00       	call   800bb2 <sys_cputs>

	return b.cnt;
}
  80022e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800234:	c9                   	leave  
  800235:	c3                   	ret    

00800236 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800236:	f3 0f 1e fb          	endbr32 
  80023a:	55                   	push   %ebp
  80023b:	89 e5                	mov    %esp,%ebp
  80023d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800240:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800243:	50                   	push   %eax
  800244:	ff 75 08             	pushl  0x8(%ebp)
  800247:	e8 95 ff ff ff       	call   8001e1 <vcprintf>
	va_end(ap);

	return cnt;
}
  80024c:	c9                   	leave  
  80024d:	c3                   	ret    

0080024e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80024e:	55                   	push   %ebp
  80024f:	89 e5                	mov    %esp,%ebp
  800251:	57                   	push   %edi
  800252:	56                   	push   %esi
  800253:	53                   	push   %ebx
  800254:	83 ec 1c             	sub    $0x1c,%esp
  800257:	89 c7                	mov    %eax,%edi
  800259:	89 d6                	mov    %edx,%esi
  80025b:	8b 45 08             	mov    0x8(%ebp),%eax
  80025e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800261:	89 d1                	mov    %edx,%ecx
  800263:	89 c2                	mov    %eax,%edx
  800265:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800268:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80026b:	8b 45 10             	mov    0x10(%ebp),%eax
  80026e:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800271:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800274:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80027b:	39 c2                	cmp    %eax,%edx
  80027d:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800280:	72 3e                	jb     8002c0 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800282:	83 ec 0c             	sub    $0xc,%esp
  800285:	ff 75 18             	pushl  0x18(%ebp)
  800288:	83 eb 01             	sub    $0x1,%ebx
  80028b:	53                   	push   %ebx
  80028c:	50                   	push   %eax
  80028d:	83 ec 08             	sub    $0x8,%esp
  800290:	ff 75 e4             	pushl  -0x1c(%ebp)
  800293:	ff 75 e0             	pushl  -0x20(%ebp)
  800296:	ff 75 dc             	pushl  -0x24(%ebp)
  800299:	ff 75 d8             	pushl  -0x28(%ebp)
  80029c:	e8 8f 23 00 00       	call   802630 <__udivdi3>
  8002a1:	83 c4 18             	add    $0x18,%esp
  8002a4:	52                   	push   %edx
  8002a5:	50                   	push   %eax
  8002a6:	89 f2                	mov    %esi,%edx
  8002a8:	89 f8                	mov    %edi,%eax
  8002aa:	e8 9f ff ff ff       	call   80024e <printnum>
  8002af:	83 c4 20             	add    $0x20,%esp
  8002b2:	eb 13                	jmp    8002c7 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002b4:	83 ec 08             	sub    $0x8,%esp
  8002b7:	56                   	push   %esi
  8002b8:	ff 75 18             	pushl  0x18(%ebp)
  8002bb:	ff d7                	call   *%edi
  8002bd:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002c0:	83 eb 01             	sub    $0x1,%ebx
  8002c3:	85 db                	test   %ebx,%ebx
  8002c5:	7f ed                	jg     8002b4 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002c7:	83 ec 08             	sub    $0x8,%esp
  8002ca:	56                   	push   %esi
  8002cb:	83 ec 04             	sub    $0x4,%esp
  8002ce:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d1:	ff 75 e0             	pushl  -0x20(%ebp)
  8002d4:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d7:	ff 75 d8             	pushl  -0x28(%ebp)
  8002da:	e8 61 24 00 00       	call   802740 <__umoddi3>
  8002df:	83 c4 14             	add    $0x14,%esp
  8002e2:	0f be 80 27 29 80 00 	movsbl 0x802927(%eax),%eax
  8002e9:	50                   	push   %eax
  8002ea:	ff d7                	call   *%edi
}
  8002ec:	83 c4 10             	add    $0x10,%esp
  8002ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002f2:	5b                   	pop    %ebx
  8002f3:	5e                   	pop    %esi
  8002f4:	5f                   	pop    %edi
  8002f5:	5d                   	pop    %ebp
  8002f6:	c3                   	ret    

008002f7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002f7:	f3 0f 1e fb          	endbr32 
  8002fb:	55                   	push   %ebp
  8002fc:	89 e5                	mov    %esp,%ebp
  8002fe:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800301:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800305:	8b 10                	mov    (%eax),%edx
  800307:	3b 50 04             	cmp    0x4(%eax),%edx
  80030a:	73 0a                	jae    800316 <sprintputch+0x1f>
		*b->buf++ = ch;
  80030c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80030f:	89 08                	mov    %ecx,(%eax)
  800311:	8b 45 08             	mov    0x8(%ebp),%eax
  800314:	88 02                	mov    %al,(%edx)
}
  800316:	5d                   	pop    %ebp
  800317:	c3                   	ret    

00800318 <printfmt>:
{
  800318:	f3 0f 1e fb          	endbr32 
  80031c:	55                   	push   %ebp
  80031d:	89 e5                	mov    %esp,%ebp
  80031f:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800322:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800325:	50                   	push   %eax
  800326:	ff 75 10             	pushl  0x10(%ebp)
  800329:	ff 75 0c             	pushl  0xc(%ebp)
  80032c:	ff 75 08             	pushl  0x8(%ebp)
  80032f:	e8 05 00 00 00       	call   800339 <vprintfmt>
}
  800334:	83 c4 10             	add    $0x10,%esp
  800337:	c9                   	leave  
  800338:	c3                   	ret    

00800339 <vprintfmt>:
{
  800339:	f3 0f 1e fb          	endbr32 
  80033d:	55                   	push   %ebp
  80033e:	89 e5                	mov    %esp,%ebp
  800340:	57                   	push   %edi
  800341:	56                   	push   %esi
  800342:	53                   	push   %ebx
  800343:	83 ec 3c             	sub    $0x3c,%esp
  800346:	8b 75 08             	mov    0x8(%ebp),%esi
  800349:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80034c:	8b 7d 10             	mov    0x10(%ebp),%edi
  80034f:	e9 8e 03 00 00       	jmp    8006e2 <vprintfmt+0x3a9>
		padc = ' ';
  800354:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800358:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80035f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800366:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80036d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800372:	8d 47 01             	lea    0x1(%edi),%eax
  800375:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800378:	0f b6 17             	movzbl (%edi),%edx
  80037b:	8d 42 dd             	lea    -0x23(%edx),%eax
  80037e:	3c 55                	cmp    $0x55,%al
  800380:	0f 87 df 03 00 00    	ja     800765 <vprintfmt+0x42c>
  800386:	0f b6 c0             	movzbl %al,%eax
  800389:	3e ff 24 85 60 2a 80 	notrack jmp *0x802a60(,%eax,4)
  800390:	00 
  800391:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800394:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800398:	eb d8                	jmp    800372 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80039a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80039d:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8003a1:	eb cf                	jmp    800372 <vprintfmt+0x39>
  8003a3:	0f b6 d2             	movzbl %dl,%edx
  8003a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ae:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003b1:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003b4:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003b8:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003bb:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003be:	83 f9 09             	cmp    $0x9,%ecx
  8003c1:	77 55                	ja     800418 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8003c3:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003c6:	eb e9                	jmp    8003b1 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8003c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003cb:	8b 00                	mov    (%eax),%eax
  8003cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d3:	8d 40 04             	lea    0x4(%eax),%eax
  8003d6:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003e0:	79 90                	jns    800372 <vprintfmt+0x39>
				width = precision, precision = -1;
  8003e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003e8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003ef:	eb 81                	jmp    800372 <vprintfmt+0x39>
  8003f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003f4:	85 c0                	test   %eax,%eax
  8003f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8003fb:	0f 49 d0             	cmovns %eax,%edx
  8003fe:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800401:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800404:	e9 69 ff ff ff       	jmp    800372 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800409:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80040c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800413:	e9 5a ff ff ff       	jmp    800372 <vprintfmt+0x39>
  800418:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80041b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80041e:	eb bc                	jmp    8003dc <vprintfmt+0xa3>
			lflag++;
  800420:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800423:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800426:	e9 47 ff ff ff       	jmp    800372 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80042b:	8b 45 14             	mov    0x14(%ebp),%eax
  80042e:	8d 78 04             	lea    0x4(%eax),%edi
  800431:	83 ec 08             	sub    $0x8,%esp
  800434:	53                   	push   %ebx
  800435:	ff 30                	pushl  (%eax)
  800437:	ff d6                	call   *%esi
			break;
  800439:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80043c:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80043f:	e9 9b 02 00 00       	jmp    8006df <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800444:	8b 45 14             	mov    0x14(%ebp),%eax
  800447:	8d 78 04             	lea    0x4(%eax),%edi
  80044a:	8b 00                	mov    (%eax),%eax
  80044c:	99                   	cltd   
  80044d:	31 d0                	xor    %edx,%eax
  80044f:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800451:	83 f8 0f             	cmp    $0xf,%eax
  800454:	7f 23                	jg     800479 <vprintfmt+0x140>
  800456:	8b 14 85 c0 2b 80 00 	mov    0x802bc0(,%eax,4),%edx
  80045d:	85 d2                	test   %edx,%edx
  80045f:	74 18                	je     800479 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800461:	52                   	push   %edx
  800462:	68 85 2d 80 00       	push   $0x802d85
  800467:	53                   	push   %ebx
  800468:	56                   	push   %esi
  800469:	e8 aa fe ff ff       	call   800318 <printfmt>
  80046e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800471:	89 7d 14             	mov    %edi,0x14(%ebp)
  800474:	e9 66 02 00 00       	jmp    8006df <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800479:	50                   	push   %eax
  80047a:	68 3f 29 80 00       	push   $0x80293f
  80047f:	53                   	push   %ebx
  800480:	56                   	push   %esi
  800481:	e8 92 fe ff ff       	call   800318 <printfmt>
  800486:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800489:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80048c:	e9 4e 02 00 00       	jmp    8006df <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800491:	8b 45 14             	mov    0x14(%ebp),%eax
  800494:	83 c0 04             	add    $0x4,%eax
  800497:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80049a:	8b 45 14             	mov    0x14(%ebp),%eax
  80049d:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80049f:	85 d2                	test   %edx,%edx
  8004a1:	b8 38 29 80 00       	mov    $0x802938,%eax
  8004a6:	0f 45 c2             	cmovne %edx,%eax
  8004a9:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004ac:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004b0:	7e 06                	jle    8004b8 <vprintfmt+0x17f>
  8004b2:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004b6:	75 0d                	jne    8004c5 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004bb:	89 c7                	mov    %eax,%edi
  8004bd:	03 45 e0             	add    -0x20(%ebp),%eax
  8004c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004c3:	eb 55                	jmp    80051a <vprintfmt+0x1e1>
  8004c5:	83 ec 08             	sub    $0x8,%esp
  8004c8:	ff 75 d8             	pushl  -0x28(%ebp)
  8004cb:	ff 75 cc             	pushl  -0x34(%ebp)
  8004ce:	e8 46 03 00 00       	call   800819 <strnlen>
  8004d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004d6:	29 c2                	sub    %eax,%edx
  8004d8:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004db:	83 c4 10             	add    $0x10,%esp
  8004de:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004e0:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e7:	85 ff                	test   %edi,%edi
  8004e9:	7e 11                	jle    8004fc <vprintfmt+0x1c3>
					putch(padc, putdat);
  8004eb:	83 ec 08             	sub    $0x8,%esp
  8004ee:	53                   	push   %ebx
  8004ef:	ff 75 e0             	pushl  -0x20(%ebp)
  8004f2:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f4:	83 ef 01             	sub    $0x1,%edi
  8004f7:	83 c4 10             	add    $0x10,%esp
  8004fa:	eb eb                	jmp    8004e7 <vprintfmt+0x1ae>
  8004fc:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004ff:	85 d2                	test   %edx,%edx
  800501:	b8 00 00 00 00       	mov    $0x0,%eax
  800506:	0f 49 c2             	cmovns %edx,%eax
  800509:	29 c2                	sub    %eax,%edx
  80050b:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80050e:	eb a8                	jmp    8004b8 <vprintfmt+0x17f>
					putch(ch, putdat);
  800510:	83 ec 08             	sub    $0x8,%esp
  800513:	53                   	push   %ebx
  800514:	52                   	push   %edx
  800515:	ff d6                	call   *%esi
  800517:	83 c4 10             	add    $0x10,%esp
  80051a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80051d:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80051f:	83 c7 01             	add    $0x1,%edi
  800522:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800526:	0f be d0             	movsbl %al,%edx
  800529:	85 d2                	test   %edx,%edx
  80052b:	74 4b                	je     800578 <vprintfmt+0x23f>
  80052d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800531:	78 06                	js     800539 <vprintfmt+0x200>
  800533:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800537:	78 1e                	js     800557 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800539:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80053d:	74 d1                	je     800510 <vprintfmt+0x1d7>
  80053f:	0f be c0             	movsbl %al,%eax
  800542:	83 e8 20             	sub    $0x20,%eax
  800545:	83 f8 5e             	cmp    $0x5e,%eax
  800548:	76 c6                	jbe    800510 <vprintfmt+0x1d7>
					putch('?', putdat);
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	53                   	push   %ebx
  80054e:	6a 3f                	push   $0x3f
  800550:	ff d6                	call   *%esi
  800552:	83 c4 10             	add    $0x10,%esp
  800555:	eb c3                	jmp    80051a <vprintfmt+0x1e1>
  800557:	89 cf                	mov    %ecx,%edi
  800559:	eb 0e                	jmp    800569 <vprintfmt+0x230>
				putch(' ', putdat);
  80055b:	83 ec 08             	sub    $0x8,%esp
  80055e:	53                   	push   %ebx
  80055f:	6a 20                	push   $0x20
  800561:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800563:	83 ef 01             	sub    $0x1,%edi
  800566:	83 c4 10             	add    $0x10,%esp
  800569:	85 ff                	test   %edi,%edi
  80056b:	7f ee                	jg     80055b <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  80056d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800570:	89 45 14             	mov    %eax,0x14(%ebp)
  800573:	e9 67 01 00 00       	jmp    8006df <vprintfmt+0x3a6>
  800578:	89 cf                	mov    %ecx,%edi
  80057a:	eb ed                	jmp    800569 <vprintfmt+0x230>
	if (lflag >= 2)
  80057c:	83 f9 01             	cmp    $0x1,%ecx
  80057f:	7f 1b                	jg     80059c <vprintfmt+0x263>
	else if (lflag)
  800581:	85 c9                	test   %ecx,%ecx
  800583:	74 63                	je     8005e8 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800585:	8b 45 14             	mov    0x14(%ebp),%eax
  800588:	8b 00                	mov    (%eax),%eax
  80058a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80058d:	99                   	cltd   
  80058e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800591:	8b 45 14             	mov    0x14(%ebp),%eax
  800594:	8d 40 04             	lea    0x4(%eax),%eax
  800597:	89 45 14             	mov    %eax,0x14(%ebp)
  80059a:	eb 17                	jmp    8005b3 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	8b 50 04             	mov    0x4(%eax),%edx
  8005a2:	8b 00                	mov    (%eax),%eax
  8005a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ad:	8d 40 08             	lea    0x8(%eax),%eax
  8005b0:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005b3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005b6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005b9:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8005be:	85 c9                	test   %ecx,%ecx
  8005c0:	0f 89 ff 00 00 00    	jns    8006c5 <vprintfmt+0x38c>
				putch('-', putdat);
  8005c6:	83 ec 08             	sub    $0x8,%esp
  8005c9:	53                   	push   %ebx
  8005ca:	6a 2d                	push   $0x2d
  8005cc:	ff d6                	call   *%esi
				num = -(long long) num;
  8005ce:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005d1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005d4:	f7 da                	neg    %edx
  8005d6:	83 d1 00             	adc    $0x0,%ecx
  8005d9:	f7 d9                	neg    %ecx
  8005db:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005de:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005e3:	e9 dd 00 00 00       	jmp    8006c5 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8005e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005eb:	8b 00                	mov    (%eax),%eax
  8005ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f0:	99                   	cltd   
  8005f1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f7:	8d 40 04             	lea    0x4(%eax),%eax
  8005fa:	89 45 14             	mov    %eax,0x14(%ebp)
  8005fd:	eb b4                	jmp    8005b3 <vprintfmt+0x27a>
	if (lflag >= 2)
  8005ff:	83 f9 01             	cmp    $0x1,%ecx
  800602:	7f 1e                	jg     800622 <vprintfmt+0x2e9>
	else if (lflag)
  800604:	85 c9                	test   %ecx,%ecx
  800606:	74 32                	je     80063a <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800608:	8b 45 14             	mov    0x14(%ebp),%eax
  80060b:	8b 10                	mov    (%eax),%edx
  80060d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800612:	8d 40 04             	lea    0x4(%eax),%eax
  800615:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800618:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  80061d:	e9 a3 00 00 00       	jmp    8006c5 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800622:	8b 45 14             	mov    0x14(%ebp),%eax
  800625:	8b 10                	mov    (%eax),%edx
  800627:	8b 48 04             	mov    0x4(%eax),%ecx
  80062a:	8d 40 08             	lea    0x8(%eax),%eax
  80062d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800630:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800635:	e9 8b 00 00 00       	jmp    8006c5 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80063a:	8b 45 14             	mov    0x14(%ebp),%eax
  80063d:	8b 10                	mov    (%eax),%edx
  80063f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800644:	8d 40 04             	lea    0x4(%eax),%eax
  800647:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80064a:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  80064f:	eb 74                	jmp    8006c5 <vprintfmt+0x38c>
	if (lflag >= 2)
  800651:	83 f9 01             	cmp    $0x1,%ecx
  800654:	7f 1b                	jg     800671 <vprintfmt+0x338>
	else if (lflag)
  800656:	85 c9                	test   %ecx,%ecx
  800658:	74 2c                	je     800686 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  80065a:	8b 45 14             	mov    0x14(%ebp),%eax
  80065d:	8b 10                	mov    (%eax),%edx
  80065f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800664:	8d 40 04             	lea    0x4(%eax),%eax
  800667:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80066a:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  80066f:	eb 54                	jmp    8006c5 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800671:	8b 45 14             	mov    0x14(%ebp),%eax
  800674:	8b 10                	mov    (%eax),%edx
  800676:	8b 48 04             	mov    0x4(%eax),%ecx
  800679:	8d 40 08             	lea    0x8(%eax),%eax
  80067c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80067f:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800684:	eb 3f                	jmp    8006c5 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800686:	8b 45 14             	mov    0x14(%ebp),%eax
  800689:	8b 10                	mov    (%eax),%edx
  80068b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800690:	8d 40 04             	lea    0x4(%eax),%eax
  800693:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800696:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  80069b:	eb 28                	jmp    8006c5 <vprintfmt+0x38c>
			putch('0', putdat);
  80069d:	83 ec 08             	sub    $0x8,%esp
  8006a0:	53                   	push   %ebx
  8006a1:	6a 30                	push   $0x30
  8006a3:	ff d6                	call   *%esi
			putch('x', putdat);
  8006a5:	83 c4 08             	add    $0x8,%esp
  8006a8:	53                   	push   %ebx
  8006a9:	6a 78                	push   $0x78
  8006ab:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b0:	8b 10                	mov    (%eax),%edx
  8006b2:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006b7:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006ba:	8d 40 04             	lea    0x4(%eax),%eax
  8006bd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006c0:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006c5:	83 ec 0c             	sub    $0xc,%esp
  8006c8:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8006cc:	57                   	push   %edi
  8006cd:	ff 75 e0             	pushl  -0x20(%ebp)
  8006d0:	50                   	push   %eax
  8006d1:	51                   	push   %ecx
  8006d2:	52                   	push   %edx
  8006d3:	89 da                	mov    %ebx,%edx
  8006d5:	89 f0                	mov    %esi,%eax
  8006d7:	e8 72 fb ff ff       	call   80024e <printnum>
			break;
  8006dc:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006e2:	83 c7 01             	add    $0x1,%edi
  8006e5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006e9:	83 f8 25             	cmp    $0x25,%eax
  8006ec:	0f 84 62 fc ff ff    	je     800354 <vprintfmt+0x1b>
			if (ch == '\0')
  8006f2:	85 c0                	test   %eax,%eax
  8006f4:	0f 84 8b 00 00 00    	je     800785 <vprintfmt+0x44c>
			putch(ch, putdat);
  8006fa:	83 ec 08             	sub    $0x8,%esp
  8006fd:	53                   	push   %ebx
  8006fe:	50                   	push   %eax
  8006ff:	ff d6                	call   *%esi
  800701:	83 c4 10             	add    $0x10,%esp
  800704:	eb dc                	jmp    8006e2 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800706:	83 f9 01             	cmp    $0x1,%ecx
  800709:	7f 1b                	jg     800726 <vprintfmt+0x3ed>
	else if (lflag)
  80070b:	85 c9                	test   %ecx,%ecx
  80070d:	74 2c                	je     80073b <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  80070f:	8b 45 14             	mov    0x14(%ebp),%eax
  800712:	8b 10                	mov    (%eax),%edx
  800714:	b9 00 00 00 00       	mov    $0x0,%ecx
  800719:	8d 40 04             	lea    0x4(%eax),%eax
  80071c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80071f:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800724:	eb 9f                	jmp    8006c5 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800726:	8b 45 14             	mov    0x14(%ebp),%eax
  800729:	8b 10                	mov    (%eax),%edx
  80072b:	8b 48 04             	mov    0x4(%eax),%ecx
  80072e:	8d 40 08             	lea    0x8(%eax),%eax
  800731:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800734:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800739:	eb 8a                	jmp    8006c5 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80073b:	8b 45 14             	mov    0x14(%ebp),%eax
  80073e:	8b 10                	mov    (%eax),%edx
  800740:	b9 00 00 00 00       	mov    $0x0,%ecx
  800745:	8d 40 04             	lea    0x4(%eax),%eax
  800748:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80074b:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800750:	e9 70 ff ff ff       	jmp    8006c5 <vprintfmt+0x38c>
			putch(ch, putdat);
  800755:	83 ec 08             	sub    $0x8,%esp
  800758:	53                   	push   %ebx
  800759:	6a 25                	push   $0x25
  80075b:	ff d6                	call   *%esi
			break;
  80075d:	83 c4 10             	add    $0x10,%esp
  800760:	e9 7a ff ff ff       	jmp    8006df <vprintfmt+0x3a6>
			putch('%', putdat);
  800765:	83 ec 08             	sub    $0x8,%esp
  800768:	53                   	push   %ebx
  800769:	6a 25                	push   $0x25
  80076b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80076d:	83 c4 10             	add    $0x10,%esp
  800770:	89 f8                	mov    %edi,%eax
  800772:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800776:	74 05                	je     80077d <vprintfmt+0x444>
  800778:	83 e8 01             	sub    $0x1,%eax
  80077b:	eb f5                	jmp    800772 <vprintfmt+0x439>
  80077d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800780:	e9 5a ff ff ff       	jmp    8006df <vprintfmt+0x3a6>
}
  800785:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800788:	5b                   	pop    %ebx
  800789:	5e                   	pop    %esi
  80078a:	5f                   	pop    %edi
  80078b:	5d                   	pop    %ebp
  80078c:	c3                   	ret    

0080078d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80078d:	f3 0f 1e fb          	endbr32 
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
  800794:	83 ec 18             	sub    $0x18,%esp
  800797:	8b 45 08             	mov    0x8(%ebp),%eax
  80079a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80079d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007a0:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007a4:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007ae:	85 c0                	test   %eax,%eax
  8007b0:	74 26                	je     8007d8 <vsnprintf+0x4b>
  8007b2:	85 d2                	test   %edx,%edx
  8007b4:	7e 22                	jle    8007d8 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007b6:	ff 75 14             	pushl  0x14(%ebp)
  8007b9:	ff 75 10             	pushl  0x10(%ebp)
  8007bc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007bf:	50                   	push   %eax
  8007c0:	68 f7 02 80 00       	push   $0x8002f7
  8007c5:	e8 6f fb ff ff       	call   800339 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007cd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007d3:	83 c4 10             	add    $0x10,%esp
}
  8007d6:	c9                   	leave  
  8007d7:	c3                   	ret    
		return -E_INVAL;
  8007d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007dd:	eb f7                	jmp    8007d6 <vsnprintf+0x49>

008007df <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007df:	f3 0f 1e fb          	endbr32 
  8007e3:	55                   	push   %ebp
  8007e4:	89 e5                	mov    %esp,%ebp
  8007e6:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007e9:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007ec:	50                   	push   %eax
  8007ed:	ff 75 10             	pushl  0x10(%ebp)
  8007f0:	ff 75 0c             	pushl  0xc(%ebp)
  8007f3:	ff 75 08             	pushl  0x8(%ebp)
  8007f6:	e8 92 ff ff ff       	call   80078d <vsnprintf>
	va_end(ap);

	return rc;
}
  8007fb:	c9                   	leave  
  8007fc:	c3                   	ret    

008007fd <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007fd:	f3 0f 1e fb          	endbr32 
  800801:	55                   	push   %ebp
  800802:	89 e5                	mov    %esp,%ebp
  800804:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800807:	b8 00 00 00 00       	mov    $0x0,%eax
  80080c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800810:	74 05                	je     800817 <strlen+0x1a>
		n++;
  800812:	83 c0 01             	add    $0x1,%eax
  800815:	eb f5                	jmp    80080c <strlen+0xf>
	return n;
}
  800817:	5d                   	pop    %ebp
  800818:	c3                   	ret    

00800819 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800819:	f3 0f 1e fb          	endbr32 
  80081d:	55                   	push   %ebp
  80081e:	89 e5                	mov    %esp,%ebp
  800820:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800823:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800826:	b8 00 00 00 00       	mov    $0x0,%eax
  80082b:	39 d0                	cmp    %edx,%eax
  80082d:	74 0d                	je     80083c <strnlen+0x23>
  80082f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800833:	74 05                	je     80083a <strnlen+0x21>
		n++;
  800835:	83 c0 01             	add    $0x1,%eax
  800838:	eb f1                	jmp    80082b <strnlen+0x12>
  80083a:	89 c2                	mov    %eax,%edx
	return n;
}
  80083c:	89 d0                	mov    %edx,%eax
  80083e:	5d                   	pop    %ebp
  80083f:	c3                   	ret    

00800840 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800840:	f3 0f 1e fb          	endbr32 
  800844:	55                   	push   %ebp
  800845:	89 e5                	mov    %esp,%ebp
  800847:	53                   	push   %ebx
  800848:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80084b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80084e:	b8 00 00 00 00       	mov    $0x0,%eax
  800853:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800857:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  80085a:	83 c0 01             	add    $0x1,%eax
  80085d:	84 d2                	test   %dl,%dl
  80085f:	75 f2                	jne    800853 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800861:	89 c8                	mov    %ecx,%eax
  800863:	5b                   	pop    %ebx
  800864:	5d                   	pop    %ebp
  800865:	c3                   	ret    

00800866 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800866:	f3 0f 1e fb          	endbr32 
  80086a:	55                   	push   %ebp
  80086b:	89 e5                	mov    %esp,%ebp
  80086d:	53                   	push   %ebx
  80086e:	83 ec 10             	sub    $0x10,%esp
  800871:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800874:	53                   	push   %ebx
  800875:	e8 83 ff ff ff       	call   8007fd <strlen>
  80087a:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80087d:	ff 75 0c             	pushl  0xc(%ebp)
  800880:	01 d8                	add    %ebx,%eax
  800882:	50                   	push   %eax
  800883:	e8 b8 ff ff ff       	call   800840 <strcpy>
	return dst;
}
  800888:	89 d8                	mov    %ebx,%eax
  80088a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80088d:	c9                   	leave  
  80088e:	c3                   	ret    

0080088f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80088f:	f3 0f 1e fb          	endbr32 
  800893:	55                   	push   %ebp
  800894:	89 e5                	mov    %esp,%ebp
  800896:	56                   	push   %esi
  800897:	53                   	push   %ebx
  800898:	8b 75 08             	mov    0x8(%ebp),%esi
  80089b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80089e:	89 f3                	mov    %esi,%ebx
  8008a0:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008a3:	89 f0                	mov    %esi,%eax
  8008a5:	39 d8                	cmp    %ebx,%eax
  8008a7:	74 11                	je     8008ba <strncpy+0x2b>
		*dst++ = *src;
  8008a9:	83 c0 01             	add    $0x1,%eax
  8008ac:	0f b6 0a             	movzbl (%edx),%ecx
  8008af:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008b2:	80 f9 01             	cmp    $0x1,%cl
  8008b5:	83 da ff             	sbb    $0xffffffff,%edx
  8008b8:	eb eb                	jmp    8008a5 <strncpy+0x16>
	}
	return ret;
}
  8008ba:	89 f0                	mov    %esi,%eax
  8008bc:	5b                   	pop    %ebx
  8008bd:	5e                   	pop    %esi
  8008be:	5d                   	pop    %ebp
  8008bf:	c3                   	ret    

008008c0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008c0:	f3 0f 1e fb          	endbr32 
  8008c4:	55                   	push   %ebp
  8008c5:	89 e5                	mov    %esp,%ebp
  8008c7:	56                   	push   %esi
  8008c8:	53                   	push   %ebx
  8008c9:	8b 75 08             	mov    0x8(%ebp),%esi
  8008cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008cf:	8b 55 10             	mov    0x10(%ebp),%edx
  8008d2:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008d4:	85 d2                	test   %edx,%edx
  8008d6:	74 21                	je     8008f9 <strlcpy+0x39>
  8008d8:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008dc:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008de:	39 c2                	cmp    %eax,%edx
  8008e0:	74 14                	je     8008f6 <strlcpy+0x36>
  8008e2:	0f b6 19             	movzbl (%ecx),%ebx
  8008e5:	84 db                	test   %bl,%bl
  8008e7:	74 0b                	je     8008f4 <strlcpy+0x34>
			*dst++ = *src++;
  8008e9:	83 c1 01             	add    $0x1,%ecx
  8008ec:	83 c2 01             	add    $0x1,%edx
  8008ef:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008f2:	eb ea                	jmp    8008de <strlcpy+0x1e>
  8008f4:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008f6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008f9:	29 f0                	sub    %esi,%eax
}
  8008fb:	5b                   	pop    %ebx
  8008fc:	5e                   	pop    %esi
  8008fd:	5d                   	pop    %ebp
  8008fe:	c3                   	ret    

008008ff <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008ff:	f3 0f 1e fb          	endbr32 
  800903:	55                   	push   %ebp
  800904:	89 e5                	mov    %esp,%ebp
  800906:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800909:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80090c:	0f b6 01             	movzbl (%ecx),%eax
  80090f:	84 c0                	test   %al,%al
  800911:	74 0c                	je     80091f <strcmp+0x20>
  800913:	3a 02                	cmp    (%edx),%al
  800915:	75 08                	jne    80091f <strcmp+0x20>
		p++, q++;
  800917:	83 c1 01             	add    $0x1,%ecx
  80091a:	83 c2 01             	add    $0x1,%edx
  80091d:	eb ed                	jmp    80090c <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80091f:	0f b6 c0             	movzbl %al,%eax
  800922:	0f b6 12             	movzbl (%edx),%edx
  800925:	29 d0                	sub    %edx,%eax
}
  800927:	5d                   	pop    %ebp
  800928:	c3                   	ret    

00800929 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800929:	f3 0f 1e fb          	endbr32 
  80092d:	55                   	push   %ebp
  80092e:	89 e5                	mov    %esp,%ebp
  800930:	53                   	push   %ebx
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	8b 55 0c             	mov    0xc(%ebp),%edx
  800937:	89 c3                	mov    %eax,%ebx
  800939:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80093c:	eb 06                	jmp    800944 <strncmp+0x1b>
		n--, p++, q++;
  80093e:	83 c0 01             	add    $0x1,%eax
  800941:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800944:	39 d8                	cmp    %ebx,%eax
  800946:	74 16                	je     80095e <strncmp+0x35>
  800948:	0f b6 08             	movzbl (%eax),%ecx
  80094b:	84 c9                	test   %cl,%cl
  80094d:	74 04                	je     800953 <strncmp+0x2a>
  80094f:	3a 0a                	cmp    (%edx),%cl
  800951:	74 eb                	je     80093e <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800953:	0f b6 00             	movzbl (%eax),%eax
  800956:	0f b6 12             	movzbl (%edx),%edx
  800959:	29 d0                	sub    %edx,%eax
}
  80095b:	5b                   	pop    %ebx
  80095c:	5d                   	pop    %ebp
  80095d:	c3                   	ret    
		return 0;
  80095e:	b8 00 00 00 00       	mov    $0x0,%eax
  800963:	eb f6                	jmp    80095b <strncmp+0x32>

00800965 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800965:	f3 0f 1e fb          	endbr32 
  800969:	55                   	push   %ebp
  80096a:	89 e5                	mov    %esp,%ebp
  80096c:	8b 45 08             	mov    0x8(%ebp),%eax
  80096f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800973:	0f b6 10             	movzbl (%eax),%edx
  800976:	84 d2                	test   %dl,%dl
  800978:	74 09                	je     800983 <strchr+0x1e>
		if (*s == c)
  80097a:	38 ca                	cmp    %cl,%dl
  80097c:	74 0a                	je     800988 <strchr+0x23>
	for (; *s; s++)
  80097e:	83 c0 01             	add    $0x1,%eax
  800981:	eb f0                	jmp    800973 <strchr+0xe>
			return (char *) s;
	return 0;
  800983:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800988:	5d                   	pop    %ebp
  800989:	c3                   	ret    

0080098a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80098a:	f3 0f 1e fb          	endbr32 
  80098e:	55                   	push   %ebp
  80098f:	89 e5                	mov    %esp,%ebp
  800991:	8b 45 08             	mov    0x8(%ebp),%eax
  800994:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800998:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80099b:	38 ca                	cmp    %cl,%dl
  80099d:	74 09                	je     8009a8 <strfind+0x1e>
  80099f:	84 d2                	test   %dl,%dl
  8009a1:	74 05                	je     8009a8 <strfind+0x1e>
	for (; *s; s++)
  8009a3:	83 c0 01             	add    $0x1,%eax
  8009a6:	eb f0                	jmp    800998 <strfind+0xe>
			break;
	return (char *) s;
}
  8009a8:	5d                   	pop    %ebp
  8009a9:	c3                   	ret    

008009aa <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009aa:	f3 0f 1e fb          	endbr32 
  8009ae:	55                   	push   %ebp
  8009af:	89 e5                	mov    %esp,%ebp
  8009b1:	57                   	push   %edi
  8009b2:	56                   	push   %esi
  8009b3:	53                   	push   %ebx
  8009b4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009ba:	85 c9                	test   %ecx,%ecx
  8009bc:	74 31                	je     8009ef <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009be:	89 f8                	mov    %edi,%eax
  8009c0:	09 c8                	or     %ecx,%eax
  8009c2:	a8 03                	test   $0x3,%al
  8009c4:	75 23                	jne    8009e9 <memset+0x3f>
		c &= 0xFF;
  8009c6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009ca:	89 d3                	mov    %edx,%ebx
  8009cc:	c1 e3 08             	shl    $0x8,%ebx
  8009cf:	89 d0                	mov    %edx,%eax
  8009d1:	c1 e0 18             	shl    $0x18,%eax
  8009d4:	89 d6                	mov    %edx,%esi
  8009d6:	c1 e6 10             	shl    $0x10,%esi
  8009d9:	09 f0                	or     %esi,%eax
  8009db:	09 c2                	or     %eax,%edx
  8009dd:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009df:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009e2:	89 d0                	mov    %edx,%eax
  8009e4:	fc                   	cld    
  8009e5:	f3 ab                	rep stos %eax,%es:(%edi)
  8009e7:	eb 06                	jmp    8009ef <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ec:	fc                   	cld    
  8009ed:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009ef:	89 f8                	mov    %edi,%eax
  8009f1:	5b                   	pop    %ebx
  8009f2:	5e                   	pop    %esi
  8009f3:	5f                   	pop    %edi
  8009f4:	5d                   	pop    %ebp
  8009f5:	c3                   	ret    

008009f6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009f6:	f3 0f 1e fb          	endbr32 
  8009fa:	55                   	push   %ebp
  8009fb:	89 e5                	mov    %esp,%ebp
  8009fd:	57                   	push   %edi
  8009fe:	56                   	push   %esi
  8009ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800a02:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a05:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a08:	39 c6                	cmp    %eax,%esi
  800a0a:	73 32                	jae    800a3e <memmove+0x48>
  800a0c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a0f:	39 c2                	cmp    %eax,%edx
  800a11:	76 2b                	jbe    800a3e <memmove+0x48>
		s += n;
		d += n;
  800a13:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a16:	89 fe                	mov    %edi,%esi
  800a18:	09 ce                	or     %ecx,%esi
  800a1a:	09 d6                	or     %edx,%esi
  800a1c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a22:	75 0e                	jne    800a32 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a24:	83 ef 04             	sub    $0x4,%edi
  800a27:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a2a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a2d:	fd                   	std    
  800a2e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a30:	eb 09                	jmp    800a3b <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a32:	83 ef 01             	sub    $0x1,%edi
  800a35:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a38:	fd                   	std    
  800a39:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a3b:	fc                   	cld    
  800a3c:	eb 1a                	jmp    800a58 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a3e:	89 c2                	mov    %eax,%edx
  800a40:	09 ca                	or     %ecx,%edx
  800a42:	09 f2                	or     %esi,%edx
  800a44:	f6 c2 03             	test   $0x3,%dl
  800a47:	75 0a                	jne    800a53 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a49:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a4c:	89 c7                	mov    %eax,%edi
  800a4e:	fc                   	cld    
  800a4f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a51:	eb 05                	jmp    800a58 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800a53:	89 c7                	mov    %eax,%edi
  800a55:	fc                   	cld    
  800a56:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a58:	5e                   	pop    %esi
  800a59:	5f                   	pop    %edi
  800a5a:	5d                   	pop    %ebp
  800a5b:	c3                   	ret    

00800a5c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a5c:	f3 0f 1e fb          	endbr32 
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
  800a63:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a66:	ff 75 10             	pushl  0x10(%ebp)
  800a69:	ff 75 0c             	pushl  0xc(%ebp)
  800a6c:	ff 75 08             	pushl  0x8(%ebp)
  800a6f:	e8 82 ff ff ff       	call   8009f6 <memmove>
}
  800a74:	c9                   	leave  
  800a75:	c3                   	ret    

00800a76 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a76:	f3 0f 1e fb          	endbr32 
  800a7a:	55                   	push   %ebp
  800a7b:	89 e5                	mov    %esp,%ebp
  800a7d:	56                   	push   %esi
  800a7e:	53                   	push   %ebx
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a85:	89 c6                	mov    %eax,%esi
  800a87:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a8a:	39 f0                	cmp    %esi,%eax
  800a8c:	74 1c                	je     800aaa <memcmp+0x34>
		if (*s1 != *s2)
  800a8e:	0f b6 08             	movzbl (%eax),%ecx
  800a91:	0f b6 1a             	movzbl (%edx),%ebx
  800a94:	38 d9                	cmp    %bl,%cl
  800a96:	75 08                	jne    800aa0 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a98:	83 c0 01             	add    $0x1,%eax
  800a9b:	83 c2 01             	add    $0x1,%edx
  800a9e:	eb ea                	jmp    800a8a <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800aa0:	0f b6 c1             	movzbl %cl,%eax
  800aa3:	0f b6 db             	movzbl %bl,%ebx
  800aa6:	29 d8                	sub    %ebx,%eax
  800aa8:	eb 05                	jmp    800aaf <memcmp+0x39>
	}

	return 0;
  800aaa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aaf:	5b                   	pop    %ebx
  800ab0:	5e                   	pop    %esi
  800ab1:	5d                   	pop    %ebp
  800ab2:	c3                   	ret    

00800ab3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ab3:	f3 0f 1e fb          	endbr32 
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
  800aba:	8b 45 08             	mov    0x8(%ebp),%eax
  800abd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ac0:	89 c2                	mov    %eax,%edx
  800ac2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ac5:	39 d0                	cmp    %edx,%eax
  800ac7:	73 09                	jae    800ad2 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ac9:	38 08                	cmp    %cl,(%eax)
  800acb:	74 05                	je     800ad2 <memfind+0x1f>
	for (; s < ends; s++)
  800acd:	83 c0 01             	add    $0x1,%eax
  800ad0:	eb f3                	jmp    800ac5 <memfind+0x12>
			break;
	return (void *) s;
}
  800ad2:	5d                   	pop    %ebp
  800ad3:	c3                   	ret    

00800ad4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ad4:	f3 0f 1e fb          	endbr32 
  800ad8:	55                   	push   %ebp
  800ad9:	89 e5                	mov    %esp,%ebp
  800adb:	57                   	push   %edi
  800adc:	56                   	push   %esi
  800add:	53                   	push   %ebx
  800ade:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ae1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ae4:	eb 03                	jmp    800ae9 <strtol+0x15>
		s++;
  800ae6:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ae9:	0f b6 01             	movzbl (%ecx),%eax
  800aec:	3c 20                	cmp    $0x20,%al
  800aee:	74 f6                	je     800ae6 <strtol+0x12>
  800af0:	3c 09                	cmp    $0x9,%al
  800af2:	74 f2                	je     800ae6 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800af4:	3c 2b                	cmp    $0x2b,%al
  800af6:	74 2a                	je     800b22 <strtol+0x4e>
	int neg = 0;
  800af8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800afd:	3c 2d                	cmp    $0x2d,%al
  800aff:	74 2b                	je     800b2c <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b01:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b07:	75 0f                	jne    800b18 <strtol+0x44>
  800b09:	80 39 30             	cmpb   $0x30,(%ecx)
  800b0c:	74 28                	je     800b36 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b0e:	85 db                	test   %ebx,%ebx
  800b10:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b15:	0f 44 d8             	cmove  %eax,%ebx
  800b18:	b8 00 00 00 00       	mov    $0x0,%eax
  800b1d:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b20:	eb 46                	jmp    800b68 <strtol+0x94>
		s++;
  800b22:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b25:	bf 00 00 00 00       	mov    $0x0,%edi
  800b2a:	eb d5                	jmp    800b01 <strtol+0x2d>
		s++, neg = 1;
  800b2c:	83 c1 01             	add    $0x1,%ecx
  800b2f:	bf 01 00 00 00       	mov    $0x1,%edi
  800b34:	eb cb                	jmp    800b01 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b36:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b3a:	74 0e                	je     800b4a <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b3c:	85 db                	test   %ebx,%ebx
  800b3e:	75 d8                	jne    800b18 <strtol+0x44>
		s++, base = 8;
  800b40:	83 c1 01             	add    $0x1,%ecx
  800b43:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b48:	eb ce                	jmp    800b18 <strtol+0x44>
		s += 2, base = 16;
  800b4a:	83 c1 02             	add    $0x2,%ecx
  800b4d:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b52:	eb c4                	jmp    800b18 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b54:	0f be d2             	movsbl %dl,%edx
  800b57:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b5a:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b5d:	7d 3a                	jge    800b99 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b5f:	83 c1 01             	add    $0x1,%ecx
  800b62:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b66:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b68:	0f b6 11             	movzbl (%ecx),%edx
  800b6b:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b6e:	89 f3                	mov    %esi,%ebx
  800b70:	80 fb 09             	cmp    $0x9,%bl
  800b73:	76 df                	jbe    800b54 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b75:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b78:	89 f3                	mov    %esi,%ebx
  800b7a:	80 fb 19             	cmp    $0x19,%bl
  800b7d:	77 08                	ja     800b87 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b7f:	0f be d2             	movsbl %dl,%edx
  800b82:	83 ea 57             	sub    $0x57,%edx
  800b85:	eb d3                	jmp    800b5a <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b87:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b8a:	89 f3                	mov    %esi,%ebx
  800b8c:	80 fb 19             	cmp    $0x19,%bl
  800b8f:	77 08                	ja     800b99 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b91:	0f be d2             	movsbl %dl,%edx
  800b94:	83 ea 37             	sub    $0x37,%edx
  800b97:	eb c1                	jmp    800b5a <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b99:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b9d:	74 05                	je     800ba4 <strtol+0xd0>
		*endptr = (char *) s;
  800b9f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ba2:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ba4:	89 c2                	mov    %eax,%edx
  800ba6:	f7 da                	neg    %edx
  800ba8:	85 ff                	test   %edi,%edi
  800baa:	0f 45 c2             	cmovne %edx,%eax
}
  800bad:	5b                   	pop    %ebx
  800bae:	5e                   	pop    %esi
  800baf:	5f                   	pop    %edi
  800bb0:	5d                   	pop    %ebp
  800bb1:	c3                   	ret    

00800bb2 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bb2:	f3 0f 1e fb          	endbr32 
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	57                   	push   %edi
  800bba:	56                   	push   %esi
  800bbb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bbc:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc7:	89 c3                	mov    %eax,%ebx
  800bc9:	89 c7                	mov    %eax,%edi
  800bcb:	89 c6                	mov    %eax,%esi
  800bcd:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bcf:	5b                   	pop    %ebx
  800bd0:	5e                   	pop    %esi
  800bd1:	5f                   	pop    %edi
  800bd2:	5d                   	pop    %ebp
  800bd3:	c3                   	ret    

00800bd4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800bd4:	f3 0f 1e fb          	endbr32 
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	57                   	push   %edi
  800bdc:	56                   	push   %esi
  800bdd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bde:	ba 00 00 00 00       	mov    $0x0,%edx
  800be3:	b8 01 00 00 00       	mov    $0x1,%eax
  800be8:	89 d1                	mov    %edx,%ecx
  800bea:	89 d3                	mov    %edx,%ebx
  800bec:	89 d7                	mov    %edx,%edi
  800bee:	89 d6                	mov    %edx,%esi
  800bf0:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bf2:	5b                   	pop    %ebx
  800bf3:	5e                   	pop    %esi
  800bf4:	5f                   	pop    %edi
  800bf5:	5d                   	pop    %ebp
  800bf6:	c3                   	ret    

00800bf7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bf7:	f3 0f 1e fb          	endbr32 
  800bfb:	55                   	push   %ebp
  800bfc:	89 e5                	mov    %esp,%ebp
  800bfe:	57                   	push   %edi
  800bff:	56                   	push   %esi
  800c00:	53                   	push   %ebx
  800c01:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c04:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c09:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0c:	b8 03 00 00 00       	mov    $0x3,%eax
  800c11:	89 cb                	mov    %ecx,%ebx
  800c13:	89 cf                	mov    %ecx,%edi
  800c15:	89 ce                	mov    %ecx,%esi
  800c17:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c19:	85 c0                	test   %eax,%eax
  800c1b:	7f 08                	jg     800c25 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c20:	5b                   	pop    %ebx
  800c21:	5e                   	pop    %esi
  800c22:	5f                   	pop    %edi
  800c23:	5d                   	pop    %ebp
  800c24:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c25:	83 ec 0c             	sub    $0xc,%esp
  800c28:	50                   	push   %eax
  800c29:	6a 03                	push   $0x3
  800c2b:	68 1f 2c 80 00       	push   $0x802c1f
  800c30:	6a 23                	push   $0x23
  800c32:	68 3c 2c 80 00       	push   $0x802c3c
  800c37:	e8 13 f5 ff ff       	call   80014f <_panic>

00800c3c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c3c:	f3 0f 1e fb          	endbr32 
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	57                   	push   %edi
  800c44:	56                   	push   %esi
  800c45:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c46:	ba 00 00 00 00       	mov    $0x0,%edx
  800c4b:	b8 02 00 00 00       	mov    $0x2,%eax
  800c50:	89 d1                	mov    %edx,%ecx
  800c52:	89 d3                	mov    %edx,%ebx
  800c54:	89 d7                	mov    %edx,%edi
  800c56:	89 d6                	mov    %edx,%esi
  800c58:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c5a:	5b                   	pop    %ebx
  800c5b:	5e                   	pop    %esi
  800c5c:	5f                   	pop    %edi
  800c5d:	5d                   	pop    %ebp
  800c5e:	c3                   	ret    

00800c5f <sys_yield>:

void
sys_yield(void)
{
  800c5f:	f3 0f 1e fb          	endbr32 
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	57                   	push   %edi
  800c67:	56                   	push   %esi
  800c68:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c69:	ba 00 00 00 00       	mov    $0x0,%edx
  800c6e:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c73:	89 d1                	mov    %edx,%ecx
  800c75:	89 d3                	mov    %edx,%ebx
  800c77:	89 d7                	mov    %edx,%edi
  800c79:	89 d6                	mov    %edx,%esi
  800c7b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c7d:	5b                   	pop    %ebx
  800c7e:	5e                   	pop    %esi
  800c7f:	5f                   	pop    %edi
  800c80:	5d                   	pop    %ebp
  800c81:	c3                   	ret    

00800c82 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c82:	f3 0f 1e fb          	endbr32 
  800c86:	55                   	push   %ebp
  800c87:	89 e5                	mov    %esp,%ebp
  800c89:	57                   	push   %edi
  800c8a:	56                   	push   %esi
  800c8b:	53                   	push   %ebx
  800c8c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c8f:	be 00 00 00 00       	mov    $0x0,%esi
  800c94:	8b 55 08             	mov    0x8(%ebp),%edx
  800c97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9a:	b8 04 00 00 00       	mov    $0x4,%eax
  800c9f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ca2:	89 f7                	mov    %esi,%edi
  800ca4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ca6:	85 c0                	test   %eax,%eax
  800ca8:	7f 08                	jg     800cb2 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800caa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cad:	5b                   	pop    %ebx
  800cae:	5e                   	pop    %esi
  800caf:	5f                   	pop    %edi
  800cb0:	5d                   	pop    %ebp
  800cb1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb2:	83 ec 0c             	sub    $0xc,%esp
  800cb5:	50                   	push   %eax
  800cb6:	6a 04                	push   $0x4
  800cb8:	68 1f 2c 80 00       	push   $0x802c1f
  800cbd:	6a 23                	push   $0x23
  800cbf:	68 3c 2c 80 00       	push   $0x802c3c
  800cc4:	e8 86 f4 ff ff       	call   80014f <_panic>

00800cc9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cc9:	f3 0f 1e fb          	endbr32 
  800ccd:	55                   	push   %ebp
  800cce:	89 e5                	mov    %esp,%ebp
  800cd0:	57                   	push   %edi
  800cd1:	56                   	push   %esi
  800cd2:	53                   	push   %ebx
  800cd3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cdc:	b8 05 00 00 00       	mov    $0x5,%eax
  800ce1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ce4:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ce7:	8b 75 18             	mov    0x18(%ebp),%esi
  800cea:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cec:	85 c0                	test   %eax,%eax
  800cee:	7f 08                	jg     800cf8 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf3:	5b                   	pop    %ebx
  800cf4:	5e                   	pop    %esi
  800cf5:	5f                   	pop    %edi
  800cf6:	5d                   	pop    %ebp
  800cf7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf8:	83 ec 0c             	sub    $0xc,%esp
  800cfb:	50                   	push   %eax
  800cfc:	6a 05                	push   $0x5
  800cfe:	68 1f 2c 80 00       	push   $0x802c1f
  800d03:	6a 23                	push   $0x23
  800d05:	68 3c 2c 80 00       	push   $0x802c3c
  800d0a:	e8 40 f4 ff ff       	call   80014f <_panic>

00800d0f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d0f:	f3 0f 1e fb          	endbr32 
  800d13:	55                   	push   %ebp
  800d14:	89 e5                	mov    %esp,%ebp
  800d16:	57                   	push   %edi
  800d17:	56                   	push   %esi
  800d18:	53                   	push   %ebx
  800d19:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d1c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d21:	8b 55 08             	mov    0x8(%ebp),%edx
  800d24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d27:	b8 06 00 00 00       	mov    $0x6,%eax
  800d2c:	89 df                	mov    %ebx,%edi
  800d2e:	89 de                	mov    %ebx,%esi
  800d30:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d32:	85 c0                	test   %eax,%eax
  800d34:	7f 08                	jg     800d3e <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d36:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d39:	5b                   	pop    %ebx
  800d3a:	5e                   	pop    %esi
  800d3b:	5f                   	pop    %edi
  800d3c:	5d                   	pop    %ebp
  800d3d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3e:	83 ec 0c             	sub    $0xc,%esp
  800d41:	50                   	push   %eax
  800d42:	6a 06                	push   $0x6
  800d44:	68 1f 2c 80 00       	push   $0x802c1f
  800d49:	6a 23                	push   $0x23
  800d4b:	68 3c 2c 80 00       	push   $0x802c3c
  800d50:	e8 fa f3 ff ff       	call   80014f <_panic>

00800d55 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d55:	f3 0f 1e fb          	endbr32 
  800d59:	55                   	push   %ebp
  800d5a:	89 e5                	mov    %esp,%ebp
  800d5c:	57                   	push   %edi
  800d5d:	56                   	push   %esi
  800d5e:	53                   	push   %ebx
  800d5f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d62:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d67:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6d:	b8 08 00 00 00       	mov    $0x8,%eax
  800d72:	89 df                	mov    %ebx,%edi
  800d74:	89 de                	mov    %ebx,%esi
  800d76:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d78:	85 c0                	test   %eax,%eax
  800d7a:	7f 08                	jg     800d84 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7f:	5b                   	pop    %ebx
  800d80:	5e                   	pop    %esi
  800d81:	5f                   	pop    %edi
  800d82:	5d                   	pop    %ebp
  800d83:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d84:	83 ec 0c             	sub    $0xc,%esp
  800d87:	50                   	push   %eax
  800d88:	6a 08                	push   $0x8
  800d8a:	68 1f 2c 80 00       	push   $0x802c1f
  800d8f:	6a 23                	push   $0x23
  800d91:	68 3c 2c 80 00       	push   $0x802c3c
  800d96:	e8 b4 f3 ff ff       	call   80014f <_panic>

00800d9b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d9b:	f3 0f 1e fb          	endbr32 
  800d9f:	55                   	push   %ebp
  800da0:	89 e5                	mov    %esp,%ebp
  800da2:	57                   	push   %edi
  800da3:	56                   	push   %esi
  800da4:	53                   	push   %ebx
  800da5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dad:	8b 55 08             	mov    0x8(%ebp),%edx
  800db0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db3:	b8 09 00 00 00       	mov    $0x9,%eax
  800db8:	89 df                	mov    %ebx,%edi
  800dba:	89 de                	mov    %ebx,%esi
  800dbc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dbe:	85 c0                	test   %eax,%eax
  800dc0:	7f 08                	jg     800dca <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc5:	5b                   	pop    %ebx
  800dc6:	5e                   	pop    %esi
  800dc7:	5f                   	pop    %edi
  800dc8:	5d                   	pop    %ebp
  800dc9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dca:	83 ec 0c             	sub    $0xc,%esp
  800dcd:	50                   	push   %eax
  800dce:	6a 09                	push   $0x9
  800dd0:	68 1f 2c 80 00       	push   $0x802c1f
  800dd5:	6a 23                	push   $0x23
  800dd7:	68 3c 2c 80 00       	push   $0x802c3c
  800ddc:	e8 6e f3 ff ff       	call   80014f <_panic>

00800de1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800de1:	f3 0f 1e fb          	endbr32 
  800de5:	55                   	push   %ebp
  800de6:	89 e5                	mov    %esp,%ebp
  800de8:	57                   	push   %edi
  800de9:	56                   	push   %esi
  800dea:	53                   	push   %ebx
  800deb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dee:	bb 00 00 00 00       	mov    $0x0,%ebx
  800df3:	8b 55 08             	mov    0x8(%ebp),%edx
  800df6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dfe:	89 df                	mov    %ebx,%edi
  800e00:	89 de                	mov    %ebx,%esi
  800e02:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e04:	85 c0                	test   %eax,%eax
  800e06:	7f 08                	jg     800e10 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e08:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e0b:	5b                   	pop    %ebx
  800e0c:	5e                   	pop    %esi
  800e0d:	5f                   	pop    %edi
  800e0e:	5d                   	pop    %ebp
  800e0f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e10:	83 ec 0c             	sub    $0xc,%esp
  800e13:	50                   	push   %eax
  800e14:	6a 0a                	push   $0xa
  800e16:	68 1f 2c 80 00       	push   $0x802c1f
  800e1b:	6a 23                	push   $0x23
  800e1d:	68 3c 2c 80 00       	push   $0x802c3c
  800e22:	e8 28 f3 ff ff       	call   80014f <_panic>

00800e27 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e27:	f3 0f 1e fb          	endbr32 
  800e2b:	55                   	push   %ebp
  800e2c:	89 e5                	mov    %esp,%ebp
  800e2e:	57                   	push   %edi
  800e2f:	56                   	push   %esi
  800e30:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e31:	8b 55 08             	mov    0x8(%ebp),%edx
  800e34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e37:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e3c:	be 00 00 00 00       	mov    $0x0,%esi
  800e41:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e44:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e47:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e49:	5b                   	pop    %ebx
  800e4a:	5e                   	pop    %esi
  800e4b:	5f                   	pop    %edi
  800e4c:	5d                   	pop    %ebp
  800e4d:	c3                   	ret    

00800e4e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e4e:	f3 0f 1e fb          	endbr32 
  800e52:	55                   	push   %ebp
  800e53:	89 e5                	mov    %esp,%ebp
  800e55:	57                   	push   %edi
  800e56:	56                   	push   %esi
  800e57:	53                   	push   %ebx
  800e58:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e5b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e60:	8b 55 08             	mov    0x8(%ebp),%edx
  800e63:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e68:	89 cb                	mov    %ecx,%ebx
  800e6a:	89 cf                	mov    %ecx,%edi
  800e6c:	89 ce                	mov    %ecx,%esi
  800e6e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e70:	85 c0                	test   %eax,%eax
  800e72:	7f 08                	jg     800e7c <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e74:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e77:	5b                   	pop    %ebx
  800e78:	5e                   	pop    %esi
  800e79:	5f                   	pop    %edi
  800e7a:	5d                   	pop    %ebp
  800e7b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7c:	83 ec 0c             	sub    $0xc,%esp
  800e7f:	50                   	push   %eax
  800e80:	6a 0d                	push   $0xd
  800e82:	68 1f 2c 80 00       	push   $0x802c1f
  800e87:	6a 23                	push   $0x23
  800e89:	68 3c 2c 80 00       	push   $0x802c3c
  800e8e:	e8 bc f2 ff ff       	call   80014f <_panic>

00800e93 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e93:	f3 0f 1e fb          	endbr32 
  800e97:	55                   	push   %ebp
  800e98:	89 e5                	mov    %esp,%ebp
  800e9a:	57                   	push   %edi
  800e9b:	56                   	push   %esi
  800e9c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e9d:	ba 00 00 00 00       	mov    $0x0,%edx
  800ea2:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ea7:	89 d1                	mov    %edx,%ecx
  800ea9:	89 d3                	mov    %edx,%ebx
  800eab:	89 d7                	mov    %edx,%edi
  800ead:	89 d6                	mov    %edx,%esi
  800eaf:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800eb1:	5b                   	pop    %ebx
  800eb2:	5e                   	pop    %esi
  800eb3:	5f                   	pop    %edi
  800eb4:	5d                   	pop    %ebp
  800eb5:	c3                   	ret    

00800eb6 <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  800eb6:	f3 0f 1e fb          	endbr32 
  800eba:	55                   	push   %ebp
  800ebb:	89 e5                	mov    %esp,%ebp
  800ebd:	57                   	push   %edi
  800ebe:	56                   	push   %esi
  800ebf:	53                   	push   %ebx
  800ec0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ece:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ed3:	89 df                	mov    %ebx,%edi
  800ed5:	89 de                	mov    %ebx,%esi
  800ed7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ed9:	85 c0                	test   %eax,%eax
  800edb:	7f 08                	jg     800ee5 <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  800edd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee0:	5b                   	pop    %ebx
  800ee1:	5e                   	pop    %esi
  800ee2:	5f                   	pop    %edi
  800ee3:	5d                   	pop    %ebp
  800ee4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee5:	83 ec 0c             	sub    $0xc,%esp
  800ee8:	50                   	push   %eax
  800ee9:	6a 0f                	push   $0xf
  800eeb:	68 1f 2c 80 00       	push   $0x802c1f
  800ef0:	6a 23                	push   $0x23
  800ef2:	68 3c 2c 80 00       	push   $0x802c3c
  800ef7:	e8 53 f2 ff ff       	call   80014f <_panic>

00800efc <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  800efc:	f3 0f 1e fb          	endbr32 
  800f00:	55                   	push   %ebp
  800f01:	89 e5                	mov    %esp,%ebp
  800f03:	57                   	push   %edi
  800f04:	56                   	push   %esi
  800f05:	53                   	push   %ebx
  800f06:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f09:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f0e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f14:	b8 10 00 00 00       	mov    $0x10,%eax
  800f19:	89 df                	mov    %ebx,%edi
  800f1b:	89 de                	mov    %ebx,%esi
  800f1d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f1f:	85 c0                	test   %eax,%eax
  800f21:	7f 08                	jg     800f2b <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  800f23:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f26:	5b                   	pop    %ebx
  800f27:	5e                   	pop    %esi
  800f28:	5f                   	pop    %edi
  800f29:	5d                   	pop    %ebp
  800f2a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2b:	83 ec 0c             	sub    $0xc,%esp
  800f2e:	50                   	push   %eax
  800f2f:	6a 10                	push   $0x10
  800f31:	68 1f 2c 80 00       	push   $0x802c1f
  800f36:	6a 23                	push   $0x23
  800f38:	68 3c 2c 80 00       	push   $0x802c3c
  800f3d:	e8 0d f2 ff ff       	call   80014f <_panic>

00800f42 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f42:	f3 0f 1e fb          	endbr32 
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	53                   	push   %ebx
  800f4a:	83 ec 04             	sub    $0x4,%esp
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800f50:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  800f52:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f56:	74 74                	je     800fcc <pgfault+0x8a>
  800f58:	89 d8                	mov    %ebx,%eax
  800f5a:	c1 e8 0c             	shr    $0xc,%eax
  800f5d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f64:	f6 c4 08             	test   $0x8,%ah
  800f67:	74 63                	je     800fcc <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800f69:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  800f6f:	83 ec 0c             	sub    $0xc,%esp
  800f72:	6a 05                	push   $0x5
  800f74:	68 00 f0 7f 00       	push   $0x7ff000
  800f79:	6a 00                	push   $0x0
  800f7b:	53                   	push   %ebx
  800f7c:	6a 00                	push   $0x0
  800f7e:	e8 46 fd ff ff       	call   800cc9 <sys_page_map>
  800f83:	83 c4 20             	add    $0x20,%esp
  800f86:	85 c0                	test   %eax,%eax
  800f88:	78 59                	js     800fe3 <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  800f8a:	83 ec 04             	sub    $0x4,%esp
  800f8d:	6a 07                	push   $0x7
  800f8f:	53                   	push   %ebx
  800f90:	6a 00                	push   $0x0
  800f92:	e8 eb fc ff ff       	call   800c82 <sys_page_alloc>
  800f97:	83 c4 10             	add    $0x10,%esp
  800f9a:	85 c0                	test   %eax,%eax
  800f9c:	78 5a                	js     800ff8 <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  800f9e:	83 ec 04             	sub    $0x4,%esp
  800fa1:	68 00 10 00 00       	push   $0x1000
  800fa6:	68 00 f0 7f 00       	push   $0x7ff000
  800fab:	53                   	push   %ebx
  800fac:	e8 45 fa ff ff       	call   8009f6 <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  800fb1:	83 c4 08             	add    $0x8,%esp
  800fb4:	68 00 f0 7f 00       	push   $0x7ff000
  800fb9:	6a 00                	push   $0x0
  800fbb:	e8 4f fd ff ff       	call   800d0f <sys_page_unmap>
  800fc0:	83 c4 10             	add    $0x10,%esp
  800fc3:	85 c0                	test   %eax,%eax
  800fc5:	78 46                	js     80100d <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  800fc7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fca:	c9                   	leave  
  800fcb:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  800fcc:	83 ec 04             	sub    $0x4,%esp
  800fcf:	68 4a 2c 80 00       	push   $0x802c4a
  800fd4:	68 d3 00 00 00       	push   $0xd3
  800fd9:	68 66 2c 80 00       	push   $0x802c66
  800fde:	e8 6c f1 ff ff       	call   80014f <_panic>
		panic("pgfault: %e\n", r);
  800fe3:	50                   	push   %eax
  800fe4:	68 71 2c 80 00       	push   $0x802c71
  800fe9:	68 df 00 00 00       	push   $0xdf
  800fee:	68 66 2c 80 00       	push   $0x802c66
  800ff3:	e8 57 f1 ff ff       	call   80014f <_panic>
		panic("pgfault: %e\n", r);
  800ff8:	50                   	push   %eax
  800ff9:	68 71 2c 80 00       	push   $0x802c71
  800ffe:	68 e3 00 00 00       	push   $0xe3
  801003:	68 66 2c 80 00       	push   $0x802c66
  801008:	e8 42 f1 ff ff       	call   80014f <_panic>
		panic("pgfault: %e\n", r);
  80100d:	50                   	push   %eax
  80100e:	68 71 2c 80 00       	push   $0x802c71
  801013:	68 e9 00 00 00       	push   $0xe9
  801018:	68 66 2c 80 00       	push   $0x802c66
  80101d:	e8 2d f1 ff ff       	call   80014f <_panic>

00801022 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801022:	f3 0f 1e fb          	endbr32 
  801026:	55                   	push   %ebp
  801027:	89 e5                	mov    %esp,%ebp
  801029:	57                   	push   %edi
  80102a:	56                   	push   %esi
  80102b:	53                   	push   %ebx
  80102c:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  80102f:	68 42 0f 80 00       	push   $0x800f42
  801034:	e8 04 14 00 00       	call   80243d <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801039:	b8 07 00 00 00       	mov    $0x7,%eax
  80103e:	cd 30                	int    $0x30
  801040:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  801043:	83 c4 10             	add    $0x10,%esp
  801046:	85 c0                	test   %eax,%eax
  801048:	78 2d                	js     801077 <fork+0x55>
  80104a:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  80104c:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  801051:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801055:	0f 85 9b 00 00 00    	jne    8010f6 <fork+0xd4>
		thisenv = &envs[ENVX(sys_getenvid())];
  80105b:	e8 dc fb ff ff       	call   800c3c <sys_getenvid>
  801060:	25 ff 03 00 00       	and    $0x3ff,%eax
  801065:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801068:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80106d:	a3 0c 40 80 00       	mov    %eax,0x80400c
		return 0;
  801072:	e9 71 01 00 00       	jmp    8011e8 <fork+0x1c6>
		panic("sys_exofork: %e", envid);
  801077:	50                   	push   %eax
  801078:	68 7e 2c 80 00       	push   $0x802c7e
  80107d:	68 2a 01 00 00       	push   $0x12a
  801082:	68 66 2c 80 00       	push   $0x802c66
  801087:	e8 c3 f0 ff ff       	call   80014f <_panic>
		sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_SYSCALL);
  80108c:	c1 e6 0c             	shl    $0xc,%esi
  80108f:	83 ec 0c             	sub    $0xc,%esp
  801092:	68 07 0e 00 00       	push   $0xe07
  801097:	56                   	push   %esi
  801098:	57                   	push   %edi
  801099:	56                   	push   %esi
  80109a:	6a 00                	push   $0x0
  80109c:	e8 28 fc ff ff       	call   800cc9 <sys_page_map>
  8010a1:	83 c4 20             	add    $0x20,%esp
  8010a4:	eb 3e                	jmp    8010e4 <fork+0xc2>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  8010a6:	c1 e6 0c             	shl    $0xc,%esi
  8010a9:	83 ec 0c             	sub    $0xc,%esp
  8010ac:	68 05 08 00 00       	push   $0x805
  8010b1:	56                   	push   %esi
  8010b2:	57                   	push   %edi
  8010b3:	56                   	push   %esi
  8010b4:	6a 00                	push   $0x0
  8010b6:	e8 0e fc ff ff       	call   800cc9 <sys_page_map>
  8010bb:	83 c4 20             	add    $0x20,%esp
  8010be:	85 c0                	test   %eax,%eax
  8010c0:	0f 88 bc 00 00 00    	js     801182 <fork+0x160>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  8010c6:	83 ec 0c             	sub    $0xc,%esp
  8010c9:	68 05 08 00 00       	push   $0x805
  8010ce:	56                   	push   %esi
  8010cf:	6a 00                	push   $0x0
  8010d1:	56                   	push   %esi
  8010d2:	6a 00                	push   $0x0
  8010d4:	e8 f0 fb ff ff       	call   800cc9 <sys_page_map>
  8010d9:	83 c4 20             	add    $0x20,%esp
  8010dc:	85 c0                	test   %eax,%eax
  8010de:	0f 88 b3 00 00 00    	js     801197 <fork+0x175>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8010e4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8010ea:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8010f0:	0f 84 b6 00 00 00    	je     8011ac <fork+0x18a>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  8010f6:	89 d8                	mov    %ebx,%eax
  8010f8:	c1 e8 16             	shr    $0x16,%eax
  8010fb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801102:	a8 01                	test   $0x1,%al
  801104:	74 de                	je     8010e4 <fork+0xc2>
  801106:	89 de                	mov    %ebx,%esi
  801108:	c1 ee 0c             	shr    $0xc,%esi
  80110b:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801112:	a8 01                	test   $0x1,%al
  801114:	74 ce                	je     8010e4 <fork+0xc2>
  801116:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80111d:	a8 04                	test   $0x4,%al
  80111f:	74 c3                	je     8010e4 <fork+0xc2>
	if ((uvpt[pn] & PTE_SHARE)){
  801121:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801128:	f6 c4 04             	test   $0x4,%ah
  80112b:	0f 85 5b ff ff ff    	jne    80108c <fork+0x6a>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  801131:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801138:	a8 02                	test   $0x2,%al
  80113a:	0f 85 66 ff ff ff    	jne    8010a6 <fork+0x84>
  801140:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801147:	f6 c4 08             	test   $0x8,%ah
  80114a:	0f 85 56 ff ff ff    	jne    8010a6 <fork+0x84>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  801150:	c1 e6 0c             	shl    $0xc,%esi
  801153:	83 ec 0c             	sub    $0xc,%esp
  801156:	6a 05                	push   $0x5
  801158:	56                   	push   %esi
  801159:	57                   	push   %edi
  80115a:	56                   	push   %esi
  80115b:	6a 00                	push   $0x0
  80115d:	e8 67 fb ff ff       	call   800cc9 <sys_page_map>
  801162:	83 c4 20             	add    $0x20,%esp
  801165:	85 c0                	test   %eax,%eax
  801167:	0f 89 77 ff ff ff    	jns    8010e4 <fork+0xc2>
		panic("duppage: %e\n", r);
  80116d:	50                   	push   %eax
  80116e:	68 8e 2c 80 00       	push   $0x802c8e
  801173:	68 0c 01 00 00       	push   $0x10c
  801178:	68 66 2c 80 00       	push   $0x802c66
  80117d:	e8 cd ef ff ff       	call   80014f <_panic>
			panic("duppage: %e\n", r);
  801182:	50                   	push   %eax
  801183:	68 8e 2c 80 00       	push   $0x802c8e
  801188:	68 05 01 00 00       	push   $0x105
  80118d:	68 66 2c 80 00       	push   $0x802c66
  801192:	e8 b8 ef ff ff       	call   80014f <_panic>
			panic("duppage: %e\n", r);
  801197:	50                   	push   %eax
  801198:	68 8e 2c 80 00       	push   $0x802c8e
  80119d:	68 09 01 00 00       	push   $0x109
  8011a2:	68 66 2c 80 00       	push   $0x802c66
  8011a7:	e8 a3 ef ff ff       	call   80014f <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  8011ac:	83 ec 04             	sub    $0x4,%esp
  8011af:	6a 07                	push   $0x7
  8011b1:	68 00 f0 bf ee       	push   $0xeebff000
  8011b6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011b9:	e8 c4 fa ff ff       	call   800c82 <sys_page_alloc>
  8011be:	83 c4 10             	add    $0x10,%esp
  8011c1:	85 c0                	test   %eax,%eax
  8011c3:	78 2e                	js     8011f3 <fork+0x1d1>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8011c5:	83 ec 08             	sub    $0x8,%esp
  8011c8:	68 b0 24 80 00       	push   $0x8024b0
  8011cd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8011d0:	57                   	push   %edi
  8011d1:	e8 0b fc ff ff       	call   800de1 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8011d6:	83 c4 08             	add    $0x8,%esp
  8011d9:	6a 02                	push   $0x2
  8011db:	57                   	push   %edi
  8011dc:	e8 74 fb ff ff       	call   800d55 <sys_env_set_status>
  8011e1:	83 c4 10             	add    $0x10,%esp
  8011e4:	85 c0                	test   %eax,%eax
  8011e6:	78 20                	js     801208 <fork+0x1e6>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  8011e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011ee:	5b                   	pop    %ebx
  8011ef:	5e                   	pop    %esi
  8011f0:	5f                   	pop    %edi
  8011f1:	5d                   	pop    %ebp
  8011f2:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  8011f3:	50                   	push   %eax
  8011f4:	68 9b 2c 80 00       	push   $0x802c9b
  8011f9:	68 3e 01 00 00       	push   $0x13e
  8011fe:	68 66 2c 80 00       	push   $0x802c66
  801203:	e8 47 ef ff ff       	call   80014f <_panic>
		panic("sys_env_set_status: %e", r);
  801208:	50                   	push   %eax
  801209:	68 ae 2c 80 00       	push   $0x802cae
  80120e:	68 43 01 00 00       	push   $0x143
  801213:	68 66 2c 80 00       	push   $0x802c66
  801218:	e8 32 ef ff ff       	call   80014f <_panic>

0080121d <sfork>:

// Challenge!
int
sfork(void)
{
  80121d:	f3 0f 1e fb          	endbr32 
  801221:	55                   	push   %ebp
  801222:	89 e5                	mov    %esp,%ebp
  801224:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801227:	68 c5 2c 80 00       	push   $0x802cc5
  80122c:	68 4c 01 00 00       	push   $0x14c
  801231:	68 66 2c 80 00       	push   $0x802c66
  801236:	e8 14 ef ff ff       	call   80014f <_panic>

0080123b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80123b:	f3 0f 1e fb          	endbr32 
  80123f:	55                   	push   %ebp
  801240:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801242:	8b 45 08             	mov    0x8(%ebp),%eax
  801245:	05 00 00 00 30       	add    $0x30000000,%eax
  80124a:	c1 e8 0c             	shr    $0xc,%eax
}
  80124d:	5d                   	pop    %ebp
  80124e:	c3                   	ret    

0080124f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80124f:	f3 0f 1e fb          	endbr32 
  801253:	55                   	push   %ebp
  801254:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801256:	8b 45 08             	mov    0x8(%ebp),%eax
  801259:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80125e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801263:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801268:	5d                   	pop    %ebp
  801269:	c3                   	ret    

0080126a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80126a:	f3 0f 1e fb          	endbr32 
  80126e:	55                   	push   %ebp
  80126f:	89 e5                	mov    %esp,%ebp
  801271:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801276:	89 c2                	mov    %eax,%edx
  801278:	c1 ea 16             	shr    $0x16,%edx
  80127b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801282:	f6 c2 01             	test   $0x1,%dl
  801285:	74 2d                	je     8012b4 <fd_alloc+0x4a>
  801287:	89 c2                	mov    %eax,%edx
  801289:	c1 ea 0c             	shr    $0xc,%edx
  80128c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801293:	f6 c2 01             	test   $0x1,%dl
  801296:	74 1c                	je     8012b4 <fd_alloc+0x4a>
  801298:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80129d:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012a2:	75 d2                	jne    801276 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8012ad:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8012b2:	eb 0a                	jmp    8012be <fd_alloc+0x54>
			*fd_store = fd;
  8012b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012b7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012be:	5d                   	pop    %ebp
  8012bf:	c3                   	ret    

008012c0 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8012c0:	f3 0f 1e fb          	endbr32 
  8012c4:	55                   	push   %ebp
  8012c5:	89 e5                	mov    %esp,%ebp
  8012c7:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8012ca:	83 f8 1f             	cmp    $0x1f,%eax
  8012cd:	77 30                	ja     8012ff <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8012cf:	c1 e0 0c             	shl    $0xc,%eax
  8012d2:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8012d7:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8012dd:	f6 c2 01             	test   $0x1,%dl
  8012e0:	74 24                	je     801306 <fd_lookup+0x46>
  8012e2:	89 c2                	mov    %eax,%edx
  8012e4:	c1 ea 0c             	shr    $0xc,%edx
  8012e7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012ee:	f6 c2 01             	test   $0x1,%dl
  8012f1:	74 1a                	je     80130d <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f6:	89 02                	mov    %eax,(%edx)
	return 0;
  8012f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012fd:	5d                   	pop    %ebp
  8012fe:	c3                   	ret    
		return -E_INVAL;
  8012ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801304:	eb f7                	jmp    8012fd <fd_lookup+0x3d>
		return -E_INVAL;
  801306:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80130b:	eb f0                	jmp    8012fd <fd_lookup+0x3d>
  80130d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801312:	eb e9                	jmp    8012fd <fd_lookup+0x3d>

00801314 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801314:	f3 0f 1e fb          	endbr32 
  801318:	55                   	push   %ebp
  801319:	89 e5                	mov    %esp,%ebp
  80131b:	83 ec 08             	sub    $0x8,%esp
  80131e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801321:	ba 00 00 00 00       	mov    $0x0,%edx
  801326:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80132b:	39 08                	cmp    %ecx,(%eax)
  80132d:	74 38                	je     801367 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  80132f:	83 c2 01             	add    $0x1,%edx
  801332:	8b 04 95 58 2d 80 00 	mov    0x802d58(,%edx,4),%eax
  801339:	85 c0                	test   %eax,%eax
  80133b:	75 ee                	jne    80132b <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80133d:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801342:	8b 40 48             	mov    0x48(%eax),%eax
  801345:	83 ec 04             	sub    $0x4,%esp
  801348:	51                   	push   %ecx
  801349:	50                   	push   %eax
  80134a:	68 dc 2c 80 00       	push   $0x802cdc
  80134f:	e8 e2 ee ff ff       	call   800236 <cprintf>
	*dev = 0;
  801354:	8b 45 0c             	mov    0xc(%ebp),%eax
  801357:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80135d:	83 c4 10             	add    $0x10,%esp
  801360:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801365:	c9                   	leave  
  801366:	c3                   	ret    
			*dev = devtab[i];
  801367:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80136a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80136c:	b8 00 00 00 00       	mov    $0x0,%eax
  801371:	eb f2                	jmp    801365 <dev_lookup+0x51>

00801373 <fd_close>:
{
  801373:	f3 0f 1e fb          	endbr32 
  801377:	55                   	push   %ebp
  801378:	89 e5                	mov    %esp,%ebp
  80137a:	57                   	push   %edi
  80137b:	56                   	push   %esi
  80137c:	53                   	push   %ebx
  80137d:	83 ec 24             	sub    $0x24,%esp
  801380:	8b 75 08             	mov    0x8(%ebp),%esi
  801383:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801386:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801389:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80138a:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801390:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801393:	50                   	push   %eax
  801394:	e8 27 ff ff ff       	call   8012c0 <fd_lookup>
  801399:	89 c3                	mov    %eax,%ebx
  80139b:	83 c4 10             	add    $0x10,%esp
  80139e:	85 c0                	test   %eax,%eax
  8013a0:	78 05                	js     8013a7 <fd_close+0x34>
	    || fd != fd2)
  8013a2:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8013a5:	74 16                	je     8013bd <fd_close+0x4a>
		return (must_exist ? r : 0);
  8013a7:	89 f8                	mov    %edi,%eax
  8013a9:	84 c0                	test   %al,%al
  8013ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b0:	0f 44 d8             	cmove  %eax,%ebx
}
  8013b3:	89 d8                	mov    %ebx,%eax
  8013b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013b8:	5b                   	pop    %ebx
  8013b9:	5e                   	pop    %esi
  8013ba:	5f                   	pop    %edi
  8013bb:	5d                   	pop    %ebp
  8013bc:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8013bd:	83 ec 08             	sub    $0x8,%esp
  8013c0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8013c3:	50                   	push   %eax
  8013c4:	ff 36                	pushl  (%esi)
  8013c6:	e8 49 ff ff ff       	call   801314 <dev_lookup>
  8013cb:	89 c3                	mov    %eax,%ebx
  8013cd:	83 c4 10             	add    $0x10,%esp
  8013d0:	85 c0                	test   %eax,%eax
  8013d2:	78 1a                	js     8013ee <fd_close+0x7b>
		if (dev->dev_close)
  8013d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013d7:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8013da:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8013df:	85 c0                	test   %eax,%eax
  8013e1:	74 0b                	je     8013ee <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8013e3:	83 ec 0c             	sub    $0xc,%esp
  8013e6:	56                   	push   %esi
  8013e7:	ff d0                	call   *%eax
  8013e9:	89 c3                	mov    %eax,%ebx
  8013eb:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8013ee:	83 ec 08             	sub    $0x8,%esp
  8013f1:	56                   	push   %esi
  8013f2:	6a 00                	push   $0x0
  8013f4:	e8 16 f9 ff ff       	call   800d0f <sys_page_unmap>
	return r;
  8013f9:	83 c4 10             	add    $0x10,%esp
  8013fc:	eb b5                	jmp    8013b3 <fd_close+0x40>

008013fe <close>:

int
close(int fdnum)
{
  8013fe:	f3 0f 1e fb          	endbr32 
  801402:	55                   	push   %ebp
  801403:	89 e5                	mov    %esp,%ebp
  801405:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801408:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80140b:	50                   	push   %eax
  80140c:	ff 75 08             	pushl  0x8(%ebp)
  80140f:	e8 ac fe ff ff       	call   8012c0 <fd_lookup>
  801414:	83 c4 10             	add    $0x10,%esp
  801417:	85 c0                	test   %eax,%eax
  801419:	79 02                	jns    80141d <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80141b:	c9                   	leave  
  80141c:	c3                   	ret    
		return fd_close(fd, 1);
  80141d:	83 ec 08             	sub    $0x8,%esp
  801420:	6a 01                	push   $0x1
  801422:	ff 75 f4             	pushl  -0xc(%ebp)
  801425:	e8 49 ff ff ff       	call   801373 <fd_close>
  80142a:	83 c4 10             	add    $0x10,%esp
  80142d:	eb ec                	jmp    80141b <close+0x1d>

0080142f <close_all>:

void
close_all(void)
{
  80142f:	f3 0f 1e fb          	endbr32 
  801433:	55                   	push   %ebp
  801434:	89 e5                	mov    %esp,%ebp
  801436:	53                   	push   %ebx
  801437:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80143a:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80143f:	83 ec 0c             	sub    $0xc,%esp
  801442:	53                   	push   %ebx
  801443:	e8 b6 ff ff ff       	call   8013fe <close>
	for (i = 0; i < MAXFD; i++)
  801448:	83 c3 01             	add    $0x1,%ebx
  80144b:	83 c4 10             	add    $0x10,%esp
  80144e:	83 fb 20             	cmp    $0x20,%ebx
  801451:	75 ec                	jne    80143f <close_all+0x10>
}
  801453:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801456:	c9                   	leave  
  801457:	c3                   	ret    

00801458 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801458:	f3 0f 1e fb          	endbr32 
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
  80145f:	57                   	push   %edi
  801460:	56                   	push   %esi
  801461:	53                   	push   %ebx
  801462:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801465:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801468:	50                   	push   %eax
  801469:	ff 75 08             	pushl  0x8(%ebp)
  80146c:	e8 4f fe ff ff       	call   8012c0 <fd_lookup>
  801471:	89 c3                	mov    %eax,%ebx
  801473:	83 c4 10             	add    $0x10,%esp
  801476:	85 c0                	test   %eax,%eax
  801478:	0f 88 81 00 00 00    	js     8014ff <dup+0xa7>
		return r;
	close(newfdnum);
  80147e:	83 ec 0c             	sub    $0xc,%esp
  801481:	ff 75 0c             	pushl  0xc(%ebp)
  801484:	e8 75 ff ff ff       	call   8013fe <close>

	newfd = INDEX2FD(newfdnum);
  801489:	8b 75 0c             	mov    0xc(%ebp),%esi
  80148c:	c1 e6 0c             	shl    $0xc,%esi
  80148f:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801495:	83 c4 04             	add    $0x4,%esp
  801498:	ff 75 e4             	pushl  -0x1c(%ebp)
  80149b:	e8 af fd ff ff       	call   80124f <fd2data>
  8014a0:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8014a2:	89 34 24             	mov    %esi,(%esp)
  8014a5:	e8 a5 fd ff ff       	call   80124f <fd2data>
  8014aa:	83 c4 10             	add    $0x10,%esp
  8014ad:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8014af:	89 d8                	mov    %ebx,%eax
  8014b1:	c1 e8 16             	shr    $0x16,%eax
  8014b4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014bb:	a8 01                	test   $0x1,%al
  8014bd:	74 11                	je     8014d0 <dup+0x78>
  8014bf:	89 d8                	mov    %ebx,%eax
  8014c1:	c1 e8 0c             	shr    $0xc,%eax
  8014c4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014cb:	f6 c2 01             	test   $0x1,%dl
  8014ce:	75 39                	jne    801509 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8014d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014d3:	89 d0                	mov    %edx,%eax
  8014d5:	c1 e8 0c             	shr    $0xc,%eax
  8014d8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014df:	83 ec 0c             	sub    $0xc,%esp
  8014e2:	25 07 0e 00 00       	and    $0xe07,%eax
  8014e7:	50                   	push   %eax
  8014e8:	56                   	push   %esi
  8014e9:	6a 00                	push   $0x0
  8014eb:	52                   	push   %edx
  8014ec:	6a 00                	push   $0x0
  8014ee:	e8 d6 f7 ff ff       	call   800cc9 <sys_page_map>
  8014f3:	89 c3                	mov    %eax,%ebx
  8014f5:	83 c4 20             	add    $0x20,%esp
  8014f8:	85 c0                	test   %eax,%eax
  8014fa:	78 31                	js     80152d <dup+0xd5>
		goto err;

	return newfdnum;
  8014fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8014ff:	89 d8                	mov    %ebx,%eax
  801501:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801504:	5b                   	pop    %ebx
  801505:	5e                   	pop    %esi
  801506:	5f                   	pop    %edi
  801507:	5d                   	pop    %ebp
  801508:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801509:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801510:	83 ec 0c             	sub    $0xc,%esp
  801513:	25 07 0e 00 00       	and    $0xe07,%eax
  801518:	50                   	push   %eax
  801519:	57                   	push   %edi
  80151a:	6a 00                	push   $0x0
  80151c:	53                   	push   %ebx
  80151d:	6a 00                	push   $0x0
  80151f:	e8 a5 f7 ff ff       	call   800cc9 <sys_page_map>
  801524:	89 c3                	mov    %eax,%ebx
  801526:	83 c4 20             	add    $0x20,%esp
  801529:	85 c0                	test   %eax,%eax
  80152b:	79 a3                	jns    8014d0 <dup+0x78>
	sys_page_unmap(0, newfd);
  80152d:	83 ec 08             	sub    $0x8,%esp
  801530:	56                   	push   %esi
  801531:	6a 00                	push   $0x0
  801533:	e8 d7 f7 ff ff       	call   800d0f <sys_page_unmap>
	sys_page_unmap(0, nva);
  801538:	83 c4 08             	add    $0x8,%esp
  80153b:	57                   	push   %edi
  80153c:	6a 00                	push   $0x0
  80153e:	e8 cc f7 ff ff       	call   800d0f <sys_page_unmap>
	return r;
  801543:	83 c4 10             	add    $0x10,%esp
  801546:	eb b7                	jmp    8014ff <dup+0xa7>

00801548 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801548:	f3 0f 1e fb          	endbr32 
  80154c:	55                   	push   %ebp
  80154d:	89 e5                	mov    %esp,%ebp
  80154f:	53                   	push   %ebx
  801550:	83 ec 1c             	sub    $0x1c,%esp
  801553:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801556:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801559:	50                   	push   %eax
  80155a:	53                   	push   %ebx
  80155b:	e8 60 fd ff ff       	call   8012c0 <fd_lookup>
  801560:	83 c4 10             	add    $0x10,%esp
  801563:	85 c0                	test   %eax,%eax
  801565:	78 3f                	js     8015a6 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801567:	83 ec 08             	sub    $0x8,%esp
  80156a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80156d:	50                   	push   %eax
  80156e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801571:	ff 30                	pushl  (%eax)
  801573:	e8 9c fd ff ff       	call   801314 <dev_lookup>
  801578:	83 c4 10             	add    $0x10,%esp
  80157b:	85 c0                	test   %eax,%eax
  80157d:	78 27                	js     8015a6 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80157f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801582:	8b 42 08             	mov    0x8(%edx),%eax
  801585:	83 e0 03             	and    $0x3,%eax
  801588:	83 f8 01             	cmp    $0x1,%eax
  80158b:	74 1e                	je     8015ab <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80158d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801590:	8b 40 08             	mov    0x8(%eax),%eax
  801593:	85 c0                	test   %eax,%eax
  801595:	74 35                	je     8015cc <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801597:	83 ec 04             	sub    $0x4,%esp
  80159a:	ff 75 10             	pushl  0x10(%ebp)
  80159d:	ff 75 0c             	pushl  0xc(%ebp)
  8015a0:	52                   	push   %edx
  8015a1:	ff d0                	call   *%eax
  8015a3:	83 c4 10             	add    $0x10,%esp
}
  8015a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015a9:	c9                   	leave  
  8015aa:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8015ab:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8015b0:	8b 40 48             	mov    0x48(%eax),%eax
  8015b3:	83 ec 04             	sub    $0x4,%esp
  8015b6:	53                   	push   %ebx
  8015b7:	50                   	push   %eax
  8015b8:	68 1d 2d 80 00       	push   $0x802d1d
  8015bd:	e8 74 ec ff ff       	call   800236 <cprintf>
		return -E_INVAL;
  8015c2:	83 c4 10             	add    $0x10,%esp
  8015c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015ca:	eb da                	jmp    8015a6 <read+0x5e>
		return -E_NOT_SUPP;
  8015cc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015d1:	eb d3                	jmp    8015a6 <read+0x5e>

008015d3 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8015d3:	f3 0f 1e fb          	endbr32 
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
  8015da:	57                   	push   %edi
  8015db:	56                   	push   %esi
  8015dc:	53                   	push   %ebx
  8015dd:	83 ec 0c             	sub    $0xc,%esp
  8015e0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015e3:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015eb:	eb 02                	jmp    8015ef <readn+0x1c>
  8015ed:	01 c3                	add    %eax,%ebx
  8015ef:	39 f3                	cmp    %esi,%ebx
  8015f1:	73 21                	jae    801614 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015f3:	83 ec 04             	sub    $0x4,%esp
  8015f6:	89 f0                	mov    %esi,%eax
  8015f8:	29 d8                	sub    %ebx,%eax
  8015fa:	50                   	push   %eax
  8015fb:	89 d8                	mov    %ebx,%eax
  8015fd:	03 45 0c             	add    0xc(%ebp),%eax
  801600:	50                   	push   %eax
  801601:	57                   	push   %edi
  801602:	e8 41 ff ff ff       	call   801548 <read>
		if (m < 0)
  801607:	83 c4 10             	add    $0x10,%esp
  80160a:	85 c0                	test   %eax,%eax
  80160c:	78 04                	js     801612 <readn+0x3f>
			return m;
		if (m == 0)
  80160e:	75 dd                	jne    8015ed <readn+0x1a>
  801610:	eb 02                	jmp    801614 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801612:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801614:	89 d8                	mov    %ebx,%eax
  801616:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801619:	5b                   	pop    %ebx
  80161a:	5e                   	pop    %esi
  80161b:	5f                   	pop    %edi
  80161c:	5d                   	pop    %ebp
  80161d:	c3                   	ret    

0080161e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80161e:	f3 0f 1e fb          	endbr32 
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
  801625:	53                   	push   %ebx
  801626:	83 ec 1c             	sub    $0x1c,%esp
  801629:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80162c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80162f:	50                   	push   %eax
  801630:	53                   	push   %ebx
  801631:	e8 8a fc ff ff       	call   8012c0 <fd_lookup>
  801636:	83 c4 10             	add    $0x10,%esp
  801639:	85 c0                	test   %eax,%eax
  80163b:	78 3a                	js     801677 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80163d:	83 ec 08             	sub    $0x8,%esp
  801640:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801643:	50                   	push   %eax
  801644:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801647:	ff 30                	pushl  (%eax)
  801649:	e8 c6 fc ff ff       	call   801314 <dev_lookup>
  80164e:	83 c4 10             	add    $0x10,%esp
  801651:	85 c0                	test   %eax,%eax
  801653:	78 22                	js     801677 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801655:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801658:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80165c:	74 1e                	je     80167c <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80165e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801661:	8b 52 0c             	mov    0xc(%edx),%edx
  801664:	85 d2                	test   %edx,%edx
  801666:	74 35                	je     80169d <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801668:	83 ec 04             	sub    $0x4,%esp
  80166b:	ff 75 10             	pushl  0x10(%ebp)
  80166e:	ff 75 0c             	pushl  0xc(%ebp)
  801671:	50                   	push   %eax
  801672:	ff d2                	call   *%edx
  801674:	83 c4 10             	add    $0x10,%esp
}
  801677:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80167a:	c9                   	leave  
  80167b:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80167c:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801681:	8b 40 48             	mov    0x48(%eax),%eax
  801684:	83 ec 04             	sub    $0x4,%esp
  801687:	53                   	push   %ebx
  801688:	50                   	push   %eax
  801689:	68 39 2d 80 00       	push   $0x802d39
  80168e:	e8 a3 eb ff ff       	call   800236 <cprintf>
		return -E_INVAL;
  801693:	83 c4 10             	add    $0x10,%esp
  801696:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80169b:	eb da                	jmp    801677 <write+0x59>
		return -E_NOT_SUPP;
  80169d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016a2:	eb d3                	jmp    801677 <write+0x59>

008016a4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8016a4:	f3 0f 1e fb          	endbr32 
  8016a8:	55                   	push   %ebp
  8016a9:	89 e5                	mov    %esp,%ebp
  8016ab:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016b1:	50                   	push   %eax
  8016b2:	ff 75 08             	pushl  0x8(%ebp)
  8016b5:	e8 06 fc ff ff       	call   8012c0 <fd_lookup>
  8016ba:	83 c4 10             	add    $0x10,%esp
  8016bd:	85 c0                	test   %eax,%eax
  8016bf:	78 0e                	js     8016cf <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8016c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c7:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8016ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016cf:	c9                   	leave  
  8016d0:	c3                   	ret    

008016d1 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8016d1:	f3 0f 1e fb          	endbr32 
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
  8016d8:	53                   	push   %ebx
  8016d9:	83 ec 1c             	sub    $0x1c,%esp
  8016dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016df:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016e2:	50                   	push   %eax
  8016e3:	53                   	push   %ebx
  8016e4:	e8 d7 fb ff ff       	call   8012c0 <fd_lookup>
  8016e9:	83 c4 10             	add    $0x10,%esp
  8016ec:	85 c0                	test   %eax,%eax
  8016ee:	78 37                	js     801727 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016f0:	83 ec 08             	sub    $0x8,%esp
  8016f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016f6:	50                   	push   %eax
  8016f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016fa:	ff 30                	pushl  (%eax)
  8016fc:	e8 13 fc ff ff       	call   801314 <dev_lookup>
  801701:	83 c4 10             	add    $0x10,%esp
  801704:	85 c0                	test   %eax,%eax
  801706:	78 1f                	js     801727 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801708:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80170b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80170f:	74 1b                	je     80172c <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801711:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801714:	8b 52 18             	mov    0x18(%edx),%edx
  801717:	85 d2                	test   %edx,%edx
  801719:	74 32                	je     80174d <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80171b:	83 ec 08             	sub    $0x8,%esp
  80171e:	ff 75 0c             	pushl  0xc(%ebp)
  801721:	50                   	push   %eax
  801722:	ff d2                	call   *%edx
  801724:	83 c4 10             	add    $0x10,%esp
}
  801727:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80172a:	c9                   	leave  
  80172b:	c3                   	ret    
			thisenv->env_id, fdnum);
  80172c:	a1 0c 40 80 00       	mov    0x80400c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801731:	8b 40 48             	mov    0x48(%eax),%eax
  801734:	83 ec 04             	sub    $0x4,%esp
  801737:	53                   	push   %ebx
  801738:	50                   	push   %eax
  801739:	68 fc 2c 80 00       	push   $0x802cfc
  80173e:	e8 f3 ea ff ff       	call   800236 <cprintf>
		return -E_INVAL;
  801743:	83 c4 10             	add    $0x10,%esp
  801746:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80174b:	eb da                	jmp    801727 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80174d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801752:	eb d3                	jmp    801727 <ftruncate+0x56>

00801754 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801754:	f3 0f 1e fb          	endbr32 
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
  80175b:	53                   	push   %ebx
  80175c:	83 ec 1c             	sub    $0x1c,%esp
  80175f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801762:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801765:	50                   	push   %eax
  801766:	ff 75 08             	pushl  0x8(%ebp)
  801769:	e8 52 fb ff ff       	call   8012c0 <fd_lookup>
  80176e:	83 c4 10             	add    $0x10,%esp
  801771:	85 c0                	test   %eax,%eax
  801773:	78 4b                	js     8017c0 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801775:	83 ec 08             	sub    $0x8,%esp
  801778:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80177b:	50                   	push   %eax
  80177c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80177f:	ff 30                	pushl  (%eax)
  801781:	e8 8e fb ff ff       	call   801314 <dev_lookup>
  801786:	83 c4 10             	add    $0x10,%esp
  801789:	85 c0                	test   %eax,%eax
  80178b:	78 33                	js     8017c0 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80178d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801790:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801794:	74 2f                	je     8017c5 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801796:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801799:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017a0:	00 00 00 
	stat->st_isdir = 0;
  8017a3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017aa:	00 00 00 
	stat->st_dev = dev;
  8017ad:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8017b3:	83 ec 08             	sub    $0x8,%esp
  8017b6:	53                   	push   %ebx
  8017b7:	ff 75 f0             	pushl  -0x10(%ebp)
  8017ba:	ff 50 14             	call   *0x14(%eax)
  8017bd:	83 c4 10             	add    $0x10,%esp
}
  8017c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017c3:	c9                   	leave  
  8017c4:	c3                   	ret    
		return -E_NOT_SUPP;
  8017c5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017ca:	eb f4                	jmp    8017c0 <fstat+0x6c>

008017cc <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8017cc:	f3 0f 1e fb          	endbr32 
  8017d0:	55                   	push   %ebp
  8017d1:	89 e5                	mov    %esp,%ebp
  8017d3:	56                   	push   %esi
  8017d4:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8017d5:	83 ec 08             	sub    $0x8,%esp
  8017d8:	6a 00                	push   $0x0
  8017da:	ff 75 08             	pushl  0x8(%ebp)
  8017dd:	e8 fb 01 00 00       	call   8019dd <open>
  8017e2:	89 c3                	mov    %eax,%ebx
  8017e4:	83 c4 10             	add    $0x10,%esp
  8017e7:	85 c0                	test   %eax,%eax
  8017e9:	78 1b                	js     801806 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8017eb:	83 ec 08             	sub    $0x8,%esp
  8017ee:	ff 75 0c             	pushl  0xc(%ebp)
  8017f1:	50                   	push   %eax
  8017f2:	e8 5d ff ff ff       	call   801754 <fstat>
  8017f7:	89 c6                	mov    %eax,%esi
	close(fd);
  8017f9:	89 1c 24             	mov    %ebx,(%esp)
  8017fc:	e8 fd fb ff ff       	call   8013fe <close>
	return r;
  801801:	83 c4 10             	add    $0x10,%esp
  801804:	89 f3                	mov    %esi,%ebx
}
  801806:	89 d8                	mov    %ebx,%eax
  801808:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80180b:	5b                   	pop    %ebx
  80180c:	5e                   	pop    %esi
  80180d:	5d                   	pop    %ebp
  80180e:	c3                   	ret    

0080180f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80180f:	55                   	push   %ebp
  801810:	89 e5                	mov    %esp,%ebp
  801812:	56                   	push   %esi
  801813:	53                   	push   %ebx
  801814:	89 c6                	mov    %eax,%esi
  801816:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801818:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80181f:	74 27                	je     801848 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801821:	6a 07                	push   $0x7
  801823:	68 00 50 80 00       	push   $0x805000
  801828:	56                   	push   %esi
  801829:	ff 35 00 40 80 00    	pushl  0x804000
  80182f:	e8 27 0d 00 00       	call   80255b <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801834:	83 c4 0c             	add    $0xc,%esp
  801837:	6a 00                	push   $0x0
  801839:	53                   	push   %ebx
  80183a:	6a 00                	push   $0x0
  80183c:	e8 95 0c 00 00       	call   8024d6 <ipc_recv>
}
  801841:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801844:	5b                   	pop    %ebx
  801845:	5e                   	pop    %esi
  801846:	5d                   	pop    %ebp
  801847:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801848:	83 ec 0c             	sub    $0xc,%esp
  80184b:	6a 01                	push   $0x1
  80184d:	e8 61 0d 00 00       	call   8025b3 <ipc_find_env>
  801852:	a3 00 40 80 00       	mov    %eax,0x804000
  801857:	83 c4 10             	add    $0x10,%esp
  80185a:	eb c5                	jmp    801821 <fsipc+0x12>

0080185c <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80185c:	f3 0f 1e fb          	endbr32 
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
  801863:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801866:	8b 45 08             	mov    0x8(%ebp),%eax
  801869:	8b 40 0c             	mov    0xc(%eax),%eax
  80186c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801871:	8b 45 0c             	mov    0xc(%ebp),%eax
  801874:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801879:	ba 00 00 00 00       	mov    $0x0,%edx
  80187e:	b8 02 00 00 00       	mov    $0x2,%eax
  801883:	e8 87 ff ff ff       	call   80180f <fsipc>
}
  801888:	c9                   	leave  
  801889:	c3                   	ret    

0080188a <devfile_flush>:
{
  80188a:	f3 0f 1e fb          	endbr32 
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
  801891:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801894:	8b 45 08             	mov    0x8(%ebp),%eax
  801897:	8b 40 0c             	mov    0xc(%eax),%eax
  80189a:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80189f:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a4:	b8 06 00 00 00       	mov    $0x6,%eax
  8018a9:	e8 61 ff ff ff       	call   80180f <fsipc>
}
  8018ae:	c9                   	leave  
  8018af:	c3                   	ret    

008018b0 <devfile_stat>:
{
  8018b0:	f3 0f 1e fb          	endbr32 
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
  8018b7:	53                   	push   %ebx
  8018b8:	83 ec 04             	sub    $0x4,%esp
  8018bb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8018be:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8018c4:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8018c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ce:	b8 05 00 00 00       	mov    $0x5,%eax
  8018d3:	e8 37 ff ff ff       	call   80180f <fsipc>
  8018d8:	85 c0                	test   %eax,%eax
  8018da:	78 2c                	js     801908 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8018dc:	83 ec 08             	sub    $0x8,%esp
  8018df:	68 00 50 80 00       	push   $0x805000
  8018e4:	53                   	push   %ebx
  8018e5:	e8 56 ef ff ff       	call   800840 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8018ea:	a1 80 50 80 00       	mov    0x805080,%eax
  8018ef:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8018f5:	a1 84 50 80 00       	mov    0x805084,%eax
  8018fa:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801900:	83 c4 10             	add    $0x10,%esp
  801903:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801908:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80190b:	c9                   	leave  
  80190c:	c3                   	ret    

0080190d <devfile_write>:
{
  80190d:	f3 0f 1e fb          	endbr32 
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
  801914:	83 ec 0c             	sub    $0xc,%esp
  801917:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80191a:	8b 55 08             	mov    0x8(%ebp),%edx
  80191d:	8b 52 0c             	mov    0xc(%edx),%edx
  801920:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801926:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80192b:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801930:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  801933:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801938:	50                   	push   %eax
  801939:	ff 75 0c             	pushl  0xc(%ebp)
  80193c:	68 08 50 80 00       	push   $0x805008
  801941:	e8 b0 f0 ff ff       	call   8009f6 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801946:	ba 00 00 00 00       	mov    $0x0,%edx
  80194b:	b8 04 00 00 00       	mov    $0x4,%eax
  801950:	e8 ba fe ff ff       	call   80180f <fsipc>
}
  801955:	c9                   	leave  
  801956:	c3                   	ret    

00801957 <devfile_read>:
{
  801957:	f3 0f 1e fb          	endbr32 
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
  80195e:	56                   	push   %esi
  80195f:	53                   	push   %ebx
  801960:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801963:	8b 45 08             	mov    0x8(%ebp),%eax
  801966:	8b 40 0c             	mov    0xc(%eax),%eax
  801969:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80196e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801974:	ba 00 00 00 00       	mov    $0x0,%edx
  801979:	b8 03 00 00 00       	mov    $0x3,%eax
  80197e:	e8 8c fe ff ff       	call   80180f <fsipc>
  801983:	89 c3                	mov    %eax,%ebx
  801985:	85 c0                	test   %eax,%eax
  801987:	78 1f                	js     8019a8 <devfile_read+0x51>
	assert(r <= n);
  801989:	39 f0                	cmp    %esi,%eax
  80198b:	77 24                	ja     8019b1 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  80198d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801992:	7f 33                	jg     8019c7 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801994:	83 ec 04             	sub    $0x4,%esp
  801997:	50                   	push   %eax
  801998:	68 00 50 80 00       	push   $0x805000
  80199d:	ff 75 0c             	pushl  0xc(%ebp)
  8019a0:	e8 51 f0 ff ff       	call   8009f6 <memmove>
	return r;
  8019a5:	83 c4 10             	add    $0x10,%esp
}
  8019a8:	89 d8                	mov    %ebx,%eax
  8019aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ad:	5b                   	pop    %ebx
  8019ae:	5e                   	pop    %esi
  8019af:	5d                   	pop    %ebp
  8019b0:	c3                   	ret    
	assert(r <= n);
  8019b1:	68 6c 2d 80 00       	push   $0x802d6c
  8019b6:	68 73 2d 80 00       	push   $0x802d73
  8019bb:	6a 7c                	push   $0x7c
  8019bd:	68 88 2d 80 00       	push   $0x802d88
  8019c2:	e8 88 e7 ff ff       	call   80014f <_panic>
	assert(r <= PGSIZE);
  8019c7:	68 93 2d 80 00       	push   $0x802d93
  8019cc:	68 73 2d 80 00       	push   $0x802d73
  8019d1:	6a 7d                	push   $0x7d
  8019d3:	68 88 2d 80 00       	push   $0x802d88
  8019d8:	e8 72 e7 ff ff       	call   80014f <_panic>

008019dd <open>:
{
  8019dd:	f3 0f 1e fb          	endbr32 
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
  8019e4:	56                   	push   %esi
  8019e5:	53                   	push   %ebx
  8019e6:	83 ec 1c             	sub    $0x1c,%esp
  8019e9:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8019ec:	56                   	push   %esi
  8019ed:	e8 0b ee ff ff       	call   8007fd <strlen>
  8019f2:	83 c4 10             	add    $0x10,%esp
  8019f5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8019fa:	7f 6c                	jg     801a68 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8019fc:	83 ec 0c             	sub    $0xc,%esp
  8019ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a02:	50                   	push   %eax
  801a03:	e8 62 f8 ff ff       	call   80126a <fd_alloc>
  801a08:	89 c3                	mov    %eax,%ebx
  801a0a:	83 c4 10             	add    $0x10,%esp
  801a0d:	85 c0                	test   %eax,%eax
  801a0f:	78 3c                	js     801a4d <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801a11:	83 ec 08             	sub    $0x8,%esp
  801a14:	56                   	push   %esi
  801a15:	68 00 50 80 00       	push   $0x805000
  801a1a:	e8 21 ee ff ff       	call   800840 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a22:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a2a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a2f:	e8 db fd ff ff       	call   80180f <fsipc>
  801a34:	89 c3                	mov    %eax,%ebx
  801a36:	83 c4 10             	add    $0x10,%esp
  801a39:	85 c0                	test   %eax,%eax
  801a3b:	78 19                	js     801a56 <open+0x79>
	return fd2num(fd);
  801a3d:	83 ec 0c             	sub    $0xc,%esp
  801a40:	ff 75 f4             	pushl  -0xc(%ebp)
  801a43:	e8 f3 f7 ff ff       	call   80123b <fd2num>
  801a48:	89 c3                	mov    %eax,%ebx
  801a4a:	83 c4 10             	add    $0x10,%esp
}
  801a4d:	89 d8                	mov    %ebx,%eax
  801a4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a52:	5b                   	pop    %ebx
  801a53:	5e                   	pop    %esi
  801a54:	5d                   	pop    %ebp
  801a55:	c3                   	ret    
		fd_close(fd, 0);
  801a56:	83 ec 08             	sub    $0x8,%esp
  801a59:	6a 00                	push   $0x0
  801a5b:	ff 75 f4             	pushl  -0xc(%ebp)
  801a5e:	e8 10 f9 ff ff       	call   801373 <fd_close>
		return r;
  801a63:	83 c4 10             	add    $0x10,%esp
  801a66:	eb e5                	jmp    801a4d <open+0x70>
		return -E_BAD_PATH;
  801a68:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a6d:	eb de                	jmp    801a4d <open+0x70>

00801a6f <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a6f:	f3 0f 1e fb          	endbr32 
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
  801a76:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a79:	ba 00 00 00 00       	mov    $0x0,%edx
  801a7e:	b8 08 00 00 00       	mov    $0x8,%eax
  801a83:	e8 87 fd ff ff       	call   80180f <fsipc>
}
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    

00801a8a <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801a8a:	f3 0f 1e fb          	endbr32 
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
  801a91:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801a94:	68 9f 2d 80 00       	push   $0x802d9f
  801a99:	ff 75 0c             	pushl  0xc(%ebp)
  801a9c:	e8 9f ed ff ff       	call   800840 <strcpy>
	return 0;
}
  801aa1:	b8 00 00 00 00       	mov    $0x0,%eax
  801aa6:	c9                   	leave  
  801aa7:	c3                   	ret    

00801aa8 <devsock_close>:
{
  801aa8:	f3 0f 1e fb          	endbr32 
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
  801aaf:	53                   	push   %ebx
  801ab0:	83 ec 10             	sub    $0x10,%esp
  801ab3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801ab6:	53                   	push   %ebx
  801ab7:	e8 34 0b 00 00       	call   8025f0 <pageref>
  801abc:	89 c2                	mov    %eax,%edx
  801abe:	83 c4 10             	add    $0x10,%esp
		return 0;
  801ac1:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801ac6:	83 fa 01             	cmp    $0x1,%edx
  801ac9:	74 05                	je     801ad0 <devsock_close+0x28>
}
  801acb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801ad0:	83 ec 0c             	sub    $0xc,%esp
  801ad3:	ff 73 0c             	pushl  0xc(%ebx)
  801ad6:	e8 e3 02 00 00       	call   801dbe <nsipc_close>
  801adb:	83 c4 10             	add    $0x10,%esp
  801ade:	eb eb                	jmp    801acb <devsock_close+0x23>

00801ae0 <devsock_write>:
{
  801ae0:	f3 0f 1e fb          	endbr32 
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
  801ae7:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801aea:	6a 00                	push   $0x0
  801aec:	ff 75 10             	pushl  0x10(%ebp)
  801aef:	ff 75 0c             	pushl  0xc(%ebp)
  801af2:	8b 45 08             	mov    0x8(%ebp),%eax
  801af5:	ff 70 0c             	pushl  0xc(%eax)
  801af8:	e8 b5 03 00 00       	call   801eb2 <nsipc_send>
}
  801afd:	c9                   	leave  
  801afe:	c3                   	ret    

00801aff <devsock_read>:
{
  801aff:	f3 0f 1e fb          	endbr32 
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
  801b06:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801b09:	6a 00                	push   $0x0
  801b0b:	ff 75 10             	pushl  0x10(%ebp)
  801b0e:	ff 75 0c             	pushl  0xc(%ebp)
  801b11:	8b 45 08             	mov    0x8(%ebp),%eax
  801b14:	ff 70 0c             	pushl  0xc(%eax)
  801b17:	e8 1f 03 00 00       	call   801e3b <nsipc_recv>
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <fd2sockid>:
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
  801b21:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801b24:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801b27:	52                   	push   %edx
  801b28:	50                   	push   %eax
  801b29:	e8 92 f7 ff ff       	call   8012c0 <fd_lookup>
  801b2e:	83 c4 10             	add    $0x10,%esp
  801b31:	85 c0                	test   %eax,%eax
  801b33:	78 10                	js     801b45 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b38:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801b3e:	39 08                	cmp    %ecx,(%eax)
  801b40:	75 05                	jne    801b47 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801b42:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801b45:	c9                   	leave  
  801b46:	c3                   	ret    
		return -E_NOT_SUPP;
  801b47:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b4c:	eb f7                	jmp    801b45 <fd2sockid+0x27>

00801b4e <alloc_sockfd>:
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	56                   	push   %esi
  801b52:	53                   	push   %ebx
  801b53:	83 ec 1c             	sub    $0x1c,%esp
  801b56:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801b58:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b5b:	50                   	push   %eax
  801b5c:	e8 09 f7 ff ff       	call   80126a <fd_alloc>
  801b61:	89 c3                	mov    %eax,%ebx
  801b63:	83 c4 10             	add    $0x10,%esp
  801b66:	85 c0                	test   %eax,%eax
  801b68:	78 43                	js     801bad <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801b6a:	83 ec 04             	sub    $0x4,%esp
  801b6d:	68 07 04 00 00       	push   $0x407
  801b72:	ff 75 f4             	pushl  -0xc(%ebp)
  801b75:	6a 00                	push   $0x0
  801b77:	e8 06 f1 ff ff       	call   800c82 <sys_page_alloc>
  801b7c:	89 c3                	mov    %eax,%ebx
  801b7e:	83 c4 10             	add    $0x10,%esp
  801b81:	85 c0                	test   %eax,%eax
  801b83:	78 28                	js     801bad <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b88:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b8e:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b93:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801b9a:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801b9d:	83 ec 0c             	sub    $0xc,%esp
  801ba0:	50                   	push   %eax
  801ba1:	e8 95 f6 ff ff       	call   80123b <fd2num>
  801ba6:	89 c3                	mov    %eax,%ebx
  801ba8:	83 c4 10             	add    $0x10,%esp
  801bab:	eb 0c                	jmp    801bb9 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801bad:	83 ec 0c             	sub    $0xc,%esp
  801bb0:	56                   	push   %esi
  801bb1:	e8 08 02 00 00       	call   801dbe <nsipc_close>
		return r;
  801bb6:	83 c4 10             	add    $0x10,%esp
}
  801bb9:	89 d8                	mov    %ebx,%eax
  801bbb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bbe:	5b                   	pop    %ebx
  801bbf:	5e                   	pop    %esi
  801bc0:	5d                   	pop    %ebp
  801bc1:	c3                   	ret    

00801bc2 <accept>:
{
  801bc2:	f3 0f 1e fb          	endbr32 
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
  801bc9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcf:	e8 4a ff ff ff       	call   801b1e <fd2sockid>
  801bd4:	85 c0                	test   %eax,%eax
  801bd6:	78 1b                	js     801bf3 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801bd8:	83 ec 04             	sub    $0x4,%esp
  801bdb:	ff 75 10             	pushl  0x10(%ebp)
  801bde:	ff 75 0c             	pushl  0xc(%ebp)
  801be1:	50                   	push   %eax
  801be2:	e8 22 01 00 00       	call   801d09 <nsipc_accept>
  801be7:	83 c4 10             	add    $0x10,%esp
  801bea:	85 c0                	test   %eax,%eax
  801bec:	78 05                	js     801bf3 <accept+0x31>
	return alloc_sockfd(r);
  801bee:	e8 5b ff ff ff       	call   801b4e <alloc_sockfd>
}
  801bf3:	c9                   	leave  
  801bf4:	c3                   	ret    

00801bf5 <bind>:
{
  801bf5:	f3 0f 1e fb          	endbr32 
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
  801bfc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bff:	8b 45 08             	mov    0x8(%ebp),%eax
  801c02:	e8 17 ff ff ff       	call   801b1e <fd2sockid>
  801c07:	85 c0                	test   %eax,%eax
  801c09:	78 12                	js     801c1d <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801c0b:	83 ec 04             	sub    $0x4,%esp
  801c0e:	ff 75 10             	pushl  0x10(%ebp)
  801c11:	ff 75 0c             	pushl  0xc(%ebp)
  801c14:	50                   	push   %eax
  801c15:	e8 45 01 00 00       	call   801d5f <nsipc_bind>
  801c1a:	83 c4 10             	add    $0x10,%esp
}
  801c1d:	c9                   	leave  
  801c1e:	c3                   	ret    

00801c1f <shutdown>:
{
  801c1f:	f3 0f 1e fb          	endbr32 
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
  801c26:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c29:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2c:	e8 ed fe ff ff       	call   801b1e <fd2sockid>
  801c31:	85 c0                	test   %eax,%eax
  801c33:	78 0f                	js     801c44 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801c35:	83 ec 08             	sub    $0x8,%esp
  801c38:	ff 75 0c             	pushl  0xc(%ebp)
  801c3b:	50                   	push   %eax
  801c3c:	e8 57 01 00 00       	call   801d98 <nsipc_shutdown>
  801c41:	83 c4 10             	add    $0x10,%esp
}
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <connect>:
{
  801c46:	f3 0f 1e fb          	endbr32 
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
  801c4d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c50:	8b 45 08             	mov    0x8(%ebp),%eax
  801c53:	e8 c6 fe ff ff       	call   801b1e <fd2sockid>
  801c58:	85 c0                	test   %eax,%eax
  801c5a:	78 12                	js     801c6e <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801c5c:	83 ec 04             	sub    $0x4,%esp
  801c5f:	ff 75 10             	pushl  0x10(%ebp)
  801c62:	ff 75 0c             	pushl  0xc(%ebp)
  801c65:	50                   	push   %eax
  801c66:	e8 71 01 00 00       	call   801ddc <nsipc_connect>
  801c6b:	83 c4 10             	add    $0x10,%esp
}
  801c6e:	c9                   	leave  
  801c6f:	c3                   	ret    

00801c70 <listen>:
{
  801c70:	f3 0f 1e fb          	endbr32 
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
  801c77:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7d:	e8 9c fe ff ff       	call   801b1e <fd2sockid>
  801c82:	85 c0                	test   %eax,%eax
  801c84:	78 0f                	js     801c95 <listen+0x25>
	return nsipc_listen(r, backlog);
  801c86:	83 ec 08             	sub    $0x8,%esp
  801c89:	ff 75 0c             	pushl  0xc(%ebp)
  801c8c:	50                   	push   %eax
  801c8d:	e8 83 01 00 00       	call   801e15 <nsipc_listen>
  801c92:	83 c4 10             	add    $0x10,%esp
}
  801c95:	c9                   	leave  
  801c96:	c3                   	ret    

00801c97 <socket>:

int
socket(int domain, int type, int protocol)
{
  801c97:	f3 0f 1e fb          	endbr32 
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
  801c9e:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ca1:	ff 75 10             	pushl  0x10(%ebp)
  801ca4:	ff 75 0c             	pushl  0xc(%ebp)
  801ca7:	ff 75 08             	pushl  0x8(%ebp)
  801caa:	e8 65 02 00 00       	call   801f14 <nsipc_socket>
  801caf:	83 c4 10             	add    $0x10,%esp
  801cb2:	85 c0                	test   %eax,%eax
  801cb4:	78 05                	js     801cbb <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801cb6:	e8 93 fe ff ff       	call   801b4e <alloc_sockfd>
}
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    

00801cbd <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
  801cc0:	53                   	push   %ebx
  801cc1:	83 ec 04             	sub    $0x4,%esp
  801cc4:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801cc6:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801ccd:	74 26                	je     801cf5 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ccf:	6a 07                	push   $0x7
  801cd1:	68 00 60 80 00       	push   $0x806000
  801cd6:	53                   	push   %ebx
  801cd7:	ff 35 04 40 80 00    	pushl  0x804004
  801cdd:	e8 79 08 00 00       	call   80255b <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ce2:	83 c4 0c             	add    $0xc,%esp
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	e8 e6 07 00 00       	call   8024d6 <ipc_recv>
}
  801cf0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cf3:	c9                   	leave  
  801cf4:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801cf5:	83 ec 0c             	sub    $0xc,%esp
  801cf8:	6a 02                	push   $0x2
  801cfa:	e8 b4 08 00 00       	call   8025b3 <ipc_find_env>
  801cff:	a3 04 40 80 00       	mov    %eax,0x804004
  801d04:	83 c4 10             	add    $0x10,%esp
  801d07:	eb c6                	jmp    801ccf <nsipc+0x12>

00801d09 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801d09:	f3 0f 1e fb          	endbr32 
  801d0d:	55                   	push   %ebp
  801d0e:	89 e5                	mov    %esp,%ebp
  801d10:	56                   	push   %esi
  801d11:	53                   	push   %ebx
  801d12:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801d15:	8b 45 08             	mov    0x8(%ebp),%eax
  801d18:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801d1d:	8b 06                	mov    (%esi),%eax
  801d1f:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801d24:	b8 01 00 00 00       	mov    $0x1,%eax
  801d29:	e8 8f ff ff ff       	call   801cbd <nsipc>
  801d2e:	89 c3                	mov    %eax,%ebx
  801d30:	85 c0                	test   %eax,%eax
  801d32:	79 09                	jns    801d3d <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801d34:	89 d8                	mov    %ebx,%eax
  801d36:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d39:	5b                   	pop    %ebx
  801d3a:	5e                   	pop    %esi
  801d3b:	5d                   	pop    %ebp
  801d3c:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801d3d:	83 ec 04             	sub    $0x4,%esp
  801d40:	ff 35 10 60 80 00    	pushl  0x806010
  801d46:	68 00 60 80 00       	push   $0x806000
  801d4b:	ff 75 0c             	pushl  0xc(%ebp)
  801d4e:	e8 a3 ec ff ff       	call   8009f6 <memmove>
		*addrlen = ret->ret_addrlen;
  801d53:	a1 10 60 80 00       	mov    0x806010,%eax
  801d58:	89 06                	mov    %eax,(%esi)
  801d5a:	83 c4 10             	add    $0x10,%esp
	return r;
  801d5d:	eb d5                	jmp    801d34 <nsipc_accept+0x2b>

00801d5f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801d5f:	f3 0f 1e fb          	endbr32 
  801d63:	55                   	push   %ebp
  801d64:	89 e5                	mov    %esp,%ebp
  801d66:	53                   	push   %ebx
  801d67:	83 ec 08             	sub    $0x8,%esp
  801d6a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d70:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801d75:	53                   	push   %ebx
  801d76:	ff 75 0c             	pushl  0xc(%ebp)
  801d79:	68 04 60 80 00       	push   $0x806004
  801d7e:	e8 73 ec ff ff       	call   8009f6 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801d83:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801d89:	b8 02 00 00 00       	mov    $0x2,%eax
  801d8e:	e8 2a ff ff ff       	call   801cbd <nsipc>
}
  801d93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801d98:	f3 0f 1e fb          	endbr32 
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
  801d9f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801da2:	8b 45 08             	mov    0x8(%ebp),%eax
  801da5:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801daa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dad:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801db2:	b8 03 00 00 00       	mov    $0x3,%eax
  801db7:	e8 01 ff ff ff       	call   801cbd <nsipc>
}
  801dbc:	c9                   	leave  
  801dbd:	c3                   	ret    

00801dbe <nsipc_close>:

int
nsipc_close(int s)
{
  801dbe:	f3 0f 1e fb          	endbr32 
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
  801dc5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcb:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801dd0:	b8 04 00 00 00       	mov    $0x4,%eax
  801dd5:	e8 e3 fe ff ff       	call   801cbd <nsipc>
}
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    

00801ddc <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ddc:	f3 0f 1e fb          	endbr32 
  801de0:	55                   	push   %ebp
  801de1:	89 e5                	mov    %esp,%ebp
  801de3:	53                   	push   %ebx
  801de4:	83 ec 08             	sub    $0x8,%esp
  801de7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801dea:	8b 45 08             	mov    0x8(%ebp),%eax
  801ded:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801df2:	53                   	push   %ebx
  801df3:	ff 75 0c             	pushl  0xc(%ebp)
  801df6:	68 04 60 80 00       	push   $0x806004
  801dfb:	e8 f6 eb ff ff       	call   8009f6 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801e00:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801e06:	b8 05 00 00 00       	mov    $0x5,%eax
  801e0b:	e8 ad fe ff ff       	call   801cbd <nsipc>
}
  801e10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e13:	c9                   	leave  
  801e14:	c3                   	ret    

00801e15 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801e15:	f3 0f 1e fb          	endbr32 
  801e19:	55                   	push   %ebp
  801e1a:	89 e5                	mov    %esp,%ebp
  801e1c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e22:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801e27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e2a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801e2f:	b8 06 00 00 00       	mov    $0x6,%eax
  801e34:	e8 84 fe ff ff       	call   801cbd <nsipc>
}
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    

00801e3b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801e3b:	f3 0f 1e fb          	endbr32 
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
  801e42:	56                   	push   %esi
  801e43:	53                   	push   %ebx
  801e44:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801e47:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801e4f:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801e55:	8b 45 14             	mov    0x14(%ebp),%eax
  801e58:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801e5d:	b8 07 00 00 00       	mov    $0x7,%eax
  801e62:	e8 56 fe ff ff       	call   801cbd <nsipc>
  801e67:	89 c3                	mov    %eax,%ebx
  801e69:	85 c0                	test   %eax,%eax
  801e6b:	78 26                	js     801e93 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801e6d:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801e73:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801e78:	0f 4e c6             	cmovle %esi,%eax
  801e7b:	39 c3                	cmp    %eax,%ebx
  801e7d:	7f 1d                	jg     801e9c <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801e7f:	83 ec 04             	sub    $0x4,%esp
  801e82:	53                   	push   %ebx
  801e83:	68 00 60 80 00       	push   $0x806000
  801e88:	ff 75 0c             	pushl  0xc(%ebp)
  801e8b:	e8 66 eb ff ff       	call   8009f6 <memmove>
  801e90:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801e93:	89 d8                	mov    %ebx,%eax
  801e95:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e98:	5b                   	pop    %ebx
  801e99:	5e                   	pop    %esi
  801e9a:	5d                   	pop    %ebp
  801e9b:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801e9c:	68 ab 2d 80 00       	push   $0x802dab
  801ea1:	68 73 2d 80 00       	push   $0x802d73
  801ea6:	6a 62                	push   $0x62
  801ea8:	68 c0 2d 80 00       	push   $0x802dc0
  801ead:	e8 9d e2 ff ff       	call   80014f <_panic>

00801eb2 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801eb2:	f3 0f 1e fb          	endbr32 
  801eb6:	55                   	push   %ebp
  801eb7:	89 e5                	mov    %esp,%ebp
  801eb9:	53                   	push   %ebx
  801eba:	83 ec 04             	sub    $0x4,%esp
  801ebd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec3:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801ec8:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801ece:	7f 2e                	jg     801efe <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801ed0:	83 ec 04             	sub    $0x4,%esp
  801ed3:	53                   	push   %ebx
  801ed4:	ff 75 0c             	pushl  0xc(%ebp)
  801ed7:	68 0c 60 80 00       	push   $0x80600c
  801edc:	e8 15 eb ff ff       	call   8009f6 <memmove>
	nsipcbuf.send.req_size = size;
  801ee1:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801ee7:	8b 45 14             	mov    0x14(%ebp),%eax
  801eea:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801eef:	b8 08 00 00 00       	mov    $0x8,%eax
  801ef4:	e8 c4 fd ff ff       	call   801cbd <nsipc>
}
  801ef9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801efc:	c9                   	leave  
  801efd:	c3                   	ret    
	assert(size < 1600);
  801efe:	68 cc 2d 80 00       	push   $0x802dcc
  801f03:	68 73 2d 80 00       	push   $0x802d73
  801f08:	6a 6d                	push   $0x6d
  801f0a:	68 c0 2d 80 00       	push   $0x802dc0
  801f0f:	e8 3b e2 ff ff       	call   80014f <_panic>

00801f14 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801f14:	f3 0f 1e fb          	endbr32 
  801f18:	55                   	push   %ebp
  801f19:	89 e5                	mov    %esp,%ebp
  801f1b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f21:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801f26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f29:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801f2e:	8b 45 10             	mov    0x10(%ebp),%eax
  801f31:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801f36:	b8 09 00 00 00       	mov    $0x9,%eax
  801f3b:	e8 7d fd ff ff       	call   801cbd <nsipc>
}
  801f40:	c9                   	leave  
  801f41:	c3                   	ret    

00801f42 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801f42:	f3 0f 1e fb          	endbr32 
  801f46:	55                   	push   %ebp
  801f47:	89 e5                	mov    %esp,%ebp
  801f49:	56                   	push   %esi
  801f4a:	53                   	push   %ebx
  801f4b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801f4e:	83 ec 0c             	sub    $0xc,%esp
  801f51:	ff 75 08             	pushl  0x8(%ebp)
  801f54:	e8 f6 f2 ff ff       	call   80124f <fd2data>
  801f59:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801f5b:	83 c4 08             	add    $0x8,%esp
  801f5e:	68 d8 2d 80 00       	push   $0x802dd8
  801f63:	53                   	push   %ebx
  801f64:	e8 d7 e8 ff ff       	call   800840 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801f69:	8b 46 04             	mov    0x4(%esi),%eax
  801f6c:	2b 06                	sub    (%esi),%eax
  801f6e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801f74:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801f7b:	00 00 00 
	stat->st_dev = &devpipe;
  801f7e:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801f85:	30 80 00 
	return 0;
}
  801f88:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f90:	5b                   	pop    %ebx
  801f91:	5e                   	pop    %esi
  801f92:	5d                   	pop    %ebp
  801f93:	c3                   	ret    

00801f94 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801f94:	f3 0f 1e fb          	endbr32 
  801f98:	55                   	push   %ebp
  801f99:	89 e5                	mov    %esp,%ebp
  801f9b:	53                   	push   %ebx
  801f9c:	83 ec 0c             	sub    $0xc,%esp
  801f9f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801fa2:	53                   	push   %ebx
  801fa3:	6a 00                	push   $0x0
  801fa5:	e8 65 ed ff ff       	call   800d0f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801faa:	89 1c 24             	mov    %ebx,(%esp)
  801fad:	e8 9d f2 ff ff       	call   80124f <fd2data>
  801fb2:	83 c4 08             	add    $0x8,%esp
  801fb5:	50                   	push   %eax
  801fb6:	6a 00                	push   $0x0
  801fb8:	e8 52 ed ff ff       	call   800d0f <sys_page_unmap>
}
  801fbd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fc0:	c9                   	leave  
  801fc1:	c3                   	ret    

00801fc2 <_pipeisclosed>:
{
  801fc2:	55                   	push   %ebp
  801fc3:	89 e5                	mov    %esp,%ebp
  801fc5:	57                   	push   %edi
  801fc6:	56                   	push   %esi
  801fc7:	53                   	push   %ebx
  801fc8:	83 ec 1c             	sub    $0x1c,%esp
  801fcb:	89 c7                	mov    %eax,%edi
  801fcd:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801fcf:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801fd4:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801fd7:	83 ec 0c             	sub    $0xc,%esp
  801fda:	57                   	push   %edi
  801fdb:	e8 10 06 00 00       	call   8025f0 <pageref>
  801fe0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801fe3:	89 34 24             	mov    %esi,(%esp)
  801fe6:	e8 05 06 00 00       	call   8025f0 <pageref>
		nn = thisenv->env_runs;
  801feb:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  801ff1:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801ff4:	83 c4 10             	add    $0x10,%esp
  801ff7:	39 cb                	cmp    %ecx,%ebx
  801ff9:	74 1b                	je     802016 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801ffb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ffe:	75 cf                	jne    801fcf <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802000:	8b 42 58             	mov    0x58(%edx),%eax
  802003:	6a 01                	push   $0x1
  802005:	50                   	push   %eax
  802006:	53                   	push   %ebx
  802007:	68 df 2d 80 00       	push   $0x802ddf
  80200c:	e8 25 e2 ff ff       	call   800236 <cprintf>
  802011:	83 c4 10             	add    $0x10,%esp
  802014:	eb b9                	jmp    801fcf <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802016:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802019:	0f 94 c0             	sete   %al
  80201c:	0f b6 c0             	movzbl %al,%eax
}
  80201f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802022:	5b                   	pop    %ebx
  802023:	5e                   	pop    %esi
  802024:	5f                   	pop    %edi
  802025:	5d                   	pop    %ebp
  802026:	c3                   	ret    

00802027 <devpipe_write>:
{
  802027:	f3 0f 1e fb          	endbr32 
  80202b:	55                   	push   %ebp
  80202c:	89 e5                	mov    %esp,%ebp
  80202e:	57                   	push   %edi
  80202f:	56                   	push   %esi
  802030:	53                   	push   %ebx
  802031:	83 ec 28             	sub    $0x28,%esp
  802034:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802037:	56                   	push   %esi
  802038:	e8 12 f2 ff ff       	call   80124f <fd2data>
  80203d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80203f:	83 c4 10             	add    $0x10,%esp
  802042:	bf 00 00 00 00       	mov    $0x0,%edi
  802047:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80204a:	74 4f                	je     80209b <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80204c:	8b 43 04             	mov    0x4(%ebx),%eax
  80204f:	8b 0b                	mov    (%ebx),%ecx
  802051:	8d 51 20             	lea    0x20(%ecx),%edx
  802054:	39 d0                	cmp    %edx,%eax
  802056:	72 14                	jb     80206c <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  802058:	89 da                	mov    %ebx,%edx
  80205a:	89 f0                	mov    %esi,%eax
  80205c:	e8 61 ff ff ff       	call   801fc2 <_pipeisclosed>
  802061:	85 c0                	test   %eax,%eax
  802063:	75 3b                	jne    8020a0 <devpipe_write+0x79>
			sys_yield();
  802065:	e8 f5 eb ff ff       	call   800c5f <sys_yield>
  80206a:	eb e0                	jmp    80204c <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80206c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80206f:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802073:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802076:	89 c2                	mov    %eax,%edx
  802078:	c1 fa 1f             	sar    $0x1f,%edx
  80207b:	89 d1                	mov    %edx,%ecx
  80207d:	c1 e9 1b             	shr    $0x1b,%ecx
  802080:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802083:	83 e2 1f             	and    $0x1f,%edx
  802086:	29 ca                	sub    %ecx,%edx
  802088:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80208c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802090:	83 c0 01             	add    $0x1,%eax
  802093:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802096:	83 c7 01             	add    $0x1,%edi
  802099:	eb ac                	jmp    802047 <devpipe_write+0x20>
	return i;
  80209b:	8b 45 10             	mov    0x10(%ebp),%eax
  80209e:	eb 05                	jmp    8020a5 <devpipe_write+0x7e>
				return 0;
  8020a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020a8:	5b                   	pop    %ebx
  8020a9:	5e                   	pop    %esi
  8020aa:	5f                   	pop    %edi
  8020ab:	5d                   	pop    %ebp
  8020ac:	c3                   	ret    

008020ad <devpipe_read>:
{
  8020ad:	f3 0f 1e fb          	endbr32 
  8020b1:	55                   	push   %ebp
  8020b2:	89 e5                	mov    %esp,%ebp
  8020b4:	57                   	push   %edi
  8020b5:	56                   	push   %esi
  8020b6:	53                   	push   %ebx
  8020b7:	83 ec 18             	sub    $0x18,%esp
  8020ba:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8020bd:	57                   	push   %edi
  8020be:	e8 8c f1 ff ff       	call   80124f <fd2data>
  8020c3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8020c5:	83 c4 10             	add    $0x10,%esp
  8020c8:	be 00 00 00 00       	mov    $0x0,%esi
  8020cd:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020d0:	75 14                	jne    8020e6 <devpipe_read+0x39>
	return i;
  8020d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8020d5:	eb 02                	jmp    8020d9 <devpipe_read+0x2c>
				return i;
  8020d7:	89 f0                	mov    %esi,%eax
}
  8020d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020dc:	5b                   	pop    %ebx
  8020dd:	5e                   	pop    %esi
  8020de:	5f                   	pop    %edi
  8020df:	5d                   	pop    %ebp
  8020e0:	c3                   	ret    
			sys_yield();
  8020e1:	e8 79 eb ff ff       	call   800c5f <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8020e6:	8b 03                	mov    (%ebx),%eax
  8020e8:	3b 43 04             	cmp    0x4(%ebx),%eax
  8020eb:	75 18                	jne    802105 <devpipe_read+0x58>
			if (i > 0)
  8020ed:	85 f6                	test   %esi,%esi
  8020ef:	75 e6                	jne    8020d7 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8020f1:	89 da                	mov    %ebx,%edx
  8020f3:	89 f8                	mov    %edi,%eax
  8020f5:	e8 c8 fe ff ff       	call   801fc2 <_pipeisclosed>
  8020fa:	85 c0                	test   %eax,%eax
  8020fc:	74 e3                	je     8020e1 <devpipe_read+0x34>
				return 0;
  8020fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802103:	eb d4                	jmp    8020d9 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802105:	99                   	cltd   
  802106:	c1 ea 1b             	shr    $0x1b,%edx
  802109:	01 d0                	add    %edx,%eax
  80210b:	83 e0 1f             	and    $0x1f,%eax
  80210e:	29 d0                	sub    %edx,%eax
  802110:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802115:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802118:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80211b:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80211e:	83 c6 01             	add    $0x1,%esi
  802121:	eb aa                	jmp    8020cd <devpipe_read+0x20>

00802123 <pipe>:
{
  802123:	f3 0f 1e fb          	endbr32 
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
  80212a:	56                   	push   %esi
  80212b:	53                   	push   %ebx
  80212c:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80212f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802132:	50                   	push   %eax
  802133:	e8 32 f1 ff ff       	call   80126a <fd_alloc>
  802138:	89 c3                	mov    %eax,%ebx
  80213a:	83 c4 10             	add    $0x10,%esp
  80213d:	85 c0                	test   %eax,%eax
  80213f:	0f 88 23 01 00 00    	js     802268 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802145:	83 ec 04             	sub    $0x4,%esp
  802148:	68 07 04 00 00       	push   $0x407
  80214d:	ff 75 f4             	pushl  -0xc(%ebp)
  802150:	6a 00                	push   $0x0
  802152:	e8 2b eb ff ff       	call   800c82 <sys_page_alloc>
  802157:	89 c3                	mov    %eax,%ebx
  802159:	83 c4 10             	add    $0x10,%esp
  80215c:	85 c0                	test   %eax,%eax
  80215e:	0f 88 04 01 00 00    	js     802268 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  802164:	83 ec 0c             	sub    $0xc,%esp
  802167:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80216a:	50                   	push   %eax
  80216b:	e8 fa f0 ff ff       	call   80126a <fd_alloc>
  802170:	89 c3                	mov    %eax,%ebx
  802172:	83 c4 10             	add    $0x10,%esp
  802175:	85 c0                	test   %eax,%eax
  802177:	0f 88 db 00 00 00    	js     802258 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80217d:	83 ec 04             	sub    $0x4,%esp
  802180:	68 07 04 00 00       	push   $0x407
  802185:	ff 75 f0             	pushl  -0x10(%ebp)
  802188:	6a 00                	push   $0x0
  80218a:	e8 f3 ea ff ff       	call   800c82 <sys_page_alloc>
  80218f:	89 c3                	mov    %eax,%ebx
  802191:	83 c4 10             	add    $0x10,%esp
  802194:	85 c0                	test   %eax,%eax
  802196:	0f 88 bc 00 00 00    	js     802258 <pipe+0x135>
	va = fd2data(fd0);
  80219c:	83 ec 0c             	sub    $0xc,%esp
  80219f:	ff 75 f4             	pushl  -0xc(%ebp)
  8021a2:	e8 a8 f0 ff ff       	call   80124f <fd2data>
  8021a7:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021a9:	83 c4 0c             	add    $0xc,%esp
  8021ac:	68 07 04 00 00       	push   $0x407
  8021b1:	50                   	push   %eax
  8021b2:	6a 00                	push   $0x0
  8021b4:	e8 c9 ea ff ff       	call   800c82 <sys_page_alloc>
  8021b9:	89 c3                	mov    %eax,%ebx
  8021bb:	83 c4 10             	add    $0x10,%esp
  8021be:	85 c0                	test   %eax,%eax
  8021c0:	0f 88 82 00 00 00    	js     802248 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021c6:	83 ec 0c             	sub    $0xc,%esp
  8021c9:	ff 75 f0             	pushl  -0x10(%ebp)
  8021cc:	e8 7e f0 ff ff       	call   80124f <fd2data>
  8021d1:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8021d8:	50                   	push   %eax
  8021d9:	6a 00                	push   $0x0
  8021db:	56                   	push   %esi
  8021dc:	6a 00                	push   $0x0
  8021de:	e8 e6 ea ff ff       	call   800cc9 <sys_page_map>
  8021e3:	89 c3                	mov    %eax,%ebx
  8021e5:	83 c4 20             	add    $0x20,%esp
  8021e8:	85 c0                	test   %eax,%eax
  8021ea:	78 4e                	js     80223a <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8021ec:	a1 3c 30 80 00       	mov    0x80303c,%eax
  8021f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021f4:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8021f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021f9:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802200:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802203:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802205:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802208:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80220f:	83 ec 0c             	sub    $0xc,%esp
  802212:	ff 75 f4             	pushl  -0xc(%ebp)
  802215:	e8 21 f0 ff ff       	call   80123b <fd2num>
  80221a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80221d:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80221f:	83 c4 04             	add    $0x4,%esp
  802222:	ff 75 f0             	pushl  -0x10(%ebp)
  802225:	e8 11 f0 ff ff       	call   80123b <fd2num>
  80222a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80222d:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802230:	83 c4 10             	add    $0x10,%esp
  802233:	bb 00 00 00 00       	mov    $0x0,%ebx
  802238:	eb 2e                	jmp    802268 <pipe+0x145>
	sys_page_unmap(0, va);
  80223a:	83 ec 08             	sub    $0x8,%esp
  80223d:	56                   	push   %esi
  80223e:	6a 00                	push   $0x0
  802240:	e8 ca ea ff ff       	call   800d0f <sys_page_unmap>
  802245:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802248:	83 ec 08             	sub    $0x8,%esp
  80224b:	ff 75 f0             	pushl  -0x10(%ebp)
  80224e:	6a 00                	push   $0x0
  802250:	e8 ba ea ff ff       	call   800d0f <sys_page_unmap>
  802255:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802258:	83 ec 08             	sub    $0x8,%esp
  80225b:	ff 75 f4             	pushl  -0xc(%ebp)
  80225e:	6a 00                	push   $0x0
  802260:	e8 aa ea ff ff       	call   800d0f <sys_page_unmap>
  802265:	83 c4 10             	add    $0x10,%esp
}
  802268:	89 d8                	mov    %ebx,%eax
  80226a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80226d:	5b                   	pop    %ebx
  80226e:	5e                   	pop    %esi
  80226f:	5d                   	pop    %ebp
  802270:	c3                   	ret    

00802271 <pipeisclosed>:
{
  802271:	f3 0f 1e fb          	endbr32 
  802275:	55                   	push   %ebp
  802276:	89 e5                	mov    %esp,%ebp
  802278:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80227b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80227e:	50                   	push   %eax
  80227f:	ff 75 08             	pushl  0x8(%ebp)
  802282:	e8 39 f0 ff ff       	call   8012c0 <fd_lookup>
  802287:	83 c4 10             	add    $0x10,%esp
  80228a:	85 c0                	test   %eax,%eax
  80228c:	78 18                	js     8022a6 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  80228e:	83 ec 0c             	sub    $0xc,%esp
  802291:	ff 75 f4             	pushl  -0xc(%ebp)
  802294:	e8 b6 ef ff ff       	call   80124f <fd2data>
  802299:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  80229b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229e:	e8 1f fd ff ff       	call   801fc2 <_pipeisclosed>
  8022a3:	83 c4 10             	add    $0x10,%esp
}
  8022a6:	c9                   	leave  
  8022a7:	c3                   	ret    

008022a8 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8022a8:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8022ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b1:	c3                   	ret    

008022b2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8022b2:	f3 0f 1e fb          	endbr32 
  8022b6:	55                   	push   %ebp
  8022b7:	89 e5                	mov    %esp,%ebp
  8022b9:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8022bc:	68 f7 2d 80 00       	push   $0x802df7
  8022c1:	ff 75 0c             	pushl  0xc(%ebp)
  8022c4:	e8 77 e5 ff ff       	call   800840 <strcpy>
	return 0;
}
  8022c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ce:	c9                   	leave  
  8022cf:	c3                   	ret    

008022d0 <devcons_write>:
{
  8022d0:	f3 0f 1e fb          	endbr32 
  8022d4:	55                   	push   %ebp
  8022d5:	89 e5                	mov    %esp,%ebp
  8022d7:	57                   	push   %edi
  8022d8:	56                   	push   %esi
  8022d9:	53                   	push   %ebx
  8022da:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8022e0:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8022e5:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8022eb:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022ee:	73 31                	jae    802321 <devcons_write+0x51>
		m = n - tot;
  8022f0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8022f3:	29 f3                	sub    %esi,%ebx
  8022f5:	83 fb 7f             	cmp    $0x7f,%ebx
  8022f8:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8022fd:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802300:	83 ec 04             	sub    $0x4,%esp
  802303:	53                   	push   %ebx
  802304:	89 f0                	mov    %esi,%eax
  802306:	03 45 0c             	add    0xc(%ebp),%eax
  802309:	50                   	push   %eax
  80230a:	57                   	push   %edi
  80230b:	e8 e6 e6 ff ff       	call   8009f6 <memmove>
		sys_cputs(buf, m);
  802310:	83 c4 08             	add    $0x8,%esp
  802313:	53                   	push   %ebx
  802314:	57                   	push   %edi
  802315:	e8 98 e8 ff ff       	call   800bb2 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80231a:	01 de                	add    %ebx,%esi
  80231c:	83 c4 10             	add    $0x10,%esp
  80231f:	eb ca                	jmp    8022eb <devcons_write+0x1b>
}
  802321:	89 f0                	mov    %esi,%eax
  802323:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802326:	5b                   	pop    %ebx
  802327:	5e                   	pop    %esi
  802328:	5f                   	pop    %edi
  802329:	5d                   	pop    %ebp
  80232a:	c3                   	ret    

0080232b <devcons_read>:
{
  80232b:	f3 0f 1e fb          	endbr32 
  80232f:	55                   	push   %ebp
  802330:	89 e5                	mov    %esp,%ebp
  802332:	83 ec 08             	sub    $0x8,%esp
  802335:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80233a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80233e:	74 21                	je     802361 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802340:	e8 8f e8 ff ff       	call   800bd4 <sys_cgetc>
  802345:	85 c0                	test   %eax,%eax
  802347:	75 07                	jne    802350 <devcons_read+0x25>
		sys_yield();
  802349:	e8 11 e9 ff ff       	call   800c5f <sys_yield>
  80234e:	eb f0                	jmp    802340 <devcons_read+0x15>
	if (c < 0)
  802350:	78 0f                	js     802361 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  802352:	83 f8 04             	cmp    $0x4,%eax
  802355:	74 0c                	je     802363 <devcons_read+0x38>
	*(char*)vbuf = c;
  802357:	8b 55 0c             	mov    0xc(%ebp),%edx
  80235a:	88 02                	mov    %al,(%edx)
	return 1;
  80235c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802361:	c9                   	leave  
  802362:	c3                   	ret    
		return 0;
  802363:	b8 00 00 00 00       	mov    $0x0,%eax
  802368:	eb f7                	jmp    802361 <devcons_read+0x36>

0080236a <cputchar>:
{
  80236a:	f3 0f 1e fb          	endbr32 
  80236e:	55                   	push   %ebp
  80236f:	89 e5                	mov    %esp,%ebp
  802371:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802374:	8b 45 08             	mov    0x8(%ebp),%eax
  802377:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80237a:	6a 01                	push   $0x1
  80237c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80237f:	50                   	push   %eax
  802380:	e8 2d e8 ff ff       	call   800bb2 <sys_cputs>
}
  802385:	83 c4 10             	add    $0x10,%esp
  802388:	c9                   	leave  
  802389:	c3                   	ret    

0080238a <getchar>:
{
  80238a:	f3 0f 1e fb          	endbr32 
  80238e:	55                   	push   %ebp
  80238f:	89 e5                	mov    %esp,%ebp
  802391:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802394:	6a 01                	push   $0x1
  802396:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802399:	50                   	push   %eax
  80239a:	6a 00                	push   $0x0
  80239c:	e8 a7 f1 ff ff       	call   801548 <read>
	if (r < 0)
  8023a1:	83 c4 10             	add    $0x10,%esp
  8023a4:	85 c0                	test   %eax,%eax
  8023a6:	78 06                	js     8023ae <getchar+0x24>
	if (r < 1)
  8023a8:	74 06                	je     8023b0 <getchar+0x26>
	return c;
  8023aa:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8023ae:	c9                   	leave  
  8023af:	c3                   	ret    
		return -E_EOF;
  8023b0:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8023b5:	eb f7                	jmp    8023ae <getchar+0x24>

008023b7 <iscons>:
{
  8023b7:	f3 0f 1e fb          	endbr32 
  8023bb:	55                   	push   %ebp
  8023bc:	89 e5                	mov    %esp,%ebp
  8023be:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023c4:	50                   	push   %eax
  8023c5:	ff 75 08             	pushl  0x8(%ebp)
  8023c8:	e8 f3 ee ff ff       	call   8012c0 <fd_lookup>
  8023cd:	83 c4 10             	add    $0x10,%esp
  8023d0:	85 c0                	test   %eax,%eax
  8023d2:	78 11                	js     8023e5 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8023d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d7:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8023dd:	39 10                	cmp    %edx,(%eax)
  8023df:	0f 94 c0             	sete   %al
  8023e2:	0f b6 c0             	movzbl %al,%eax
}
  8023e5:	c9                   	leave  
  8023e6:	c3                   	ret    

008023e7 <opencons>:
{
  8023e7:	f3 0f 1e fb          	endbr32 
  8023eb:	55                   	push   %ebp
  8023ec:	89 e5                	mov    %esp,%ebp
  8023ee:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8023f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023f4:	50                   	push   %eax
  8023f5:	e8 70 ee ff ff       	call   80126a <fd_alloc>
  8023fa:	83 c4 10             	add    $0x10,%esp
  8023fd:	85 c0                	test   %eax,%eax
  8023ff:	78 3a                	js     80243b <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802401:	83 ec 04             	sub    $0x4,%esp
  802404:	68 07 04 00 00       	push   $0x407
  802409:	ff 75 f4             	pushl  -0xc(%ebp)
  80240c:	6a 00                	push   $0x0
  80240e:	e8 6f e8 ff ff       	call   800c82 <sys_page_alloc>
  802413:	83 c4 10             	add    $0x10,%esp
  802416:	85 c0                	test   %eax,%eax
  802418:	78 21                	js     80243b <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80241a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241d:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802423:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802425:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802428:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80242f:	83 ec 0c             	sub    $0xc,%esp
  802432:	50                   	push   %eax
  802433:	e8 03 ee ff ff       	call   80123b <fd2num>
  802438:	83 c4 10             	add    $0x10,%esp
}
  80243b:	c9                   	leave  
  80243c:	c3                   	ret    

0080243d <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80243d:	f3 0f 1e fb          	endbr32 
  802441:	55                   	push   %ebp
  802442:	89 e5                	mov    %esp,%ebp
  802444:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802447:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  80244e:	74 0a                	je     80245a <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802450:	8b 45 08             	mov    0x8(%ebp),%eax
  802453:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802458:	c9                   	leave  
  802459:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  80245a:	83 ec 04             	sub    $0x4,%esp
  80245d:	6a 07                	push   $0x7
  80245f:	68 00 f0 bf ee       	push   $0xeebff000
  802464:	6a 00                	push   $0x0
  802466:	e8 17 e8 ff ff       	call   800c82 <sys_page_alloc>
  80246b:	83 c4 10             	add    $0x10,%esp
  80246e:	85 c0                	test   %eax,%eax
  802470:	78 2a                	js     80249c <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  802472:	83 ec 08             	sub    $0x8,%esp
  802475:	68 b0 24 80 00       	push   $0x8024b0
  80247a:	6a 00                	push   $0x0
  80247c:	e8 60 e9 ff ff       	call   800de1 <sys_env_set_pgfault_upcall>
  802481:	83 c4 10             	add    $0x10,%esp
  802484:	85 c0                	test   %eax,%eax
  802486:	79 c8                	jns    802450 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  802488:	83 ec 04             	sub    $0x4,%esp
  80248b:	68 30 2e 80 00       	push   $0x802e30
  802490:	6a 25                	push   $0x25
  802492:	68 68 2e 80 00       	push   $0x802e68
  802497:	e8 b3 dc ff ff       	call   80014f <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  80249c:	83 ec 04             	sub    $0x4,%esp
  80249f:	68 04 2e 80 00       	push   $0x802e04
  8024a4:	6a 22                	push   $0x22
  8024a6:	68 68 2e 80 00       	push   $0x802e68
  8024ab:	e8 9f dc ff ff       	call   80014f <_panic>

008024b0 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8024b0:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8024b1:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  8024b6:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8024b8:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  8024bb:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  8024bf:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  8024c3:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8024c6:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  8024c8:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  8024cc:	83 c4 08             	add    $0x8,%esp
	popal
  8024cf:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  8024d0:	83 c4 04             	add    $0x4,%esp
	popfl
  8024d3:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  8024d4:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  8024d5:	c3                   	ret    

008024d6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8024d6:	f3 0f 1e fb          	endbr32 
  8024da:	55                   	push   %ebp
  8024db:	89 e5                	mov    %esp,%ebp
  8024dd:	56                   	push   %esi
  8024de:	53                   	push   %ebx
  8024df:	8b 75 08             	mov    0x8(%ebp),%esi
  8024e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024e5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  8024e8:	85 c0                	test   %eax,%eax
  8024ea:	74 3d                	je     802529 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  8024ec:	83 ec 0c             	sub    $0xc,%esp
  8024ef:	50                   	push   %eax
  8024f0:	e8 59 e9 ff ff       	call   800e4e <sys_ipc_recv>
  8024f5:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  8024f8:	85 f6                	test   %esi,%esi
  8024fa:	74 0b                	je     802507 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8024fc:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  802502:	8b 52 74             	mov    0x74(%edx),%edx
  802505:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  802507:	85 db                	test   %ebx,%ebx
  802509:	74 0b                	je     802516 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  80250b:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  802511:	8b 52 78             	mov    0x78(%edx),%edx
  802514:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  802516:	85 c0                	test   %eax,%eax
  802518:	78 21                	js     80253b <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  80251a:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80251f:	8b 40 70             	mov    0x70(%eax),%eax
}
  802522:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802525:	5b                   	pop    %ebx
  802526:	5e                   	pop    %esi
  802527:	5d                   	pop    %ebp
  802528:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  802529:	83 ec 0c             	sub    $0xc,%esp
  80252c:	68 00 00 c0 ee       	push   $0xeec00000
  802531:	e8 18 e9 ff ff       	call   800e4e <sys_ipc_recv>
  802536:	83 c4 10             	add    $0x10,%esp
  802539:	eb bd                	jmp    8024f8 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  80253b:	85 f6                	test   %esi,%esi
  80253d:	74 10                	je     80254f <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  80253f:	85 db                	test   %ebx,%ebx
  802541:	75 df                	jne    802522 <ipc_recv+0x4c>
  802543:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80254a:	00 00 00 
  80254d:	eb d3                	jmp    802522 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  80254f:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802556:	00 00 00 
  802559:	eb e4                	jmp    80253f <ipc_recv+0x69>

0080255b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80255b:	f3 0f 1e fb          	endbr32 
  80255f:	55                   	push   %ebp
  802560:	89 e5                	mov    %esp,%ebp
  802562:	57                   	push   %edi
  802563:	56                   	push   %esi
  802564:	53                   	push   %ebx
  802565:	83 ec 0c             	sub    $0xc,%esp
  802568:	8b 7d 08             	mov    0x8(%ebp),%edi
  80256b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80256e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  802571:	85 db                	test   %ebx,%ebx
  802573:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802578:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  80257b:	ff 75 14             	pushl  0x14(%ebp)
  80257e:	53                   	push   %ebx
  80257f:	56                   	push   %esi
  802580:	57                   	push   %edi
  802581:	e8 a1 e8 ff ff       	call   800e27 <sys_ipc_try_send>
  802586:	83 c4 10             	add    $0x10,%esp
  802589:	85 c0                	test   %eax,%eax
  80258b:	79 1e                	jns    8025ab <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  80258d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802590:	75 07                	jne    802599 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  802592:	e8 c8 e6 ff ff       	call   800c5f <sys_yield>
  802597:	eb e2                	jmp    80257b <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  802599:	50                   	push   %eax
  80259a:	68 76 2e 80 00       	push   $0x802e76
  80259f:	6a 59                	push   $0x59
  8025a1:	68 91 2e 80 00       	push   $0x802e91
  8025a6:	e8 a4 db ff ff       	call   80014f <_panic>
	}
}
  8025ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025ae:	5b                   	pop    %ebx
  8025af:	5e                   	pop    %esi
  8025b0:	5f                   	pop    %edi
  8025b1:	5d                   	pop    %ebp
  8025b2:	c3                   	ret    

008025b3 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8025b3:	f3 0f 1e fb          	endbr32 
  8025b7:	55                   	push   %ebp
  8025b8:	89 e5                	mov    %esp,%ebp
  8025ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8025bd:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8025c2:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8025c5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8025cb:	8b 52 50             	mov    0x50(%edx),%edx
  8025ce:	39 ca                	cmp    %ecx,%edx
  8025d0:	74 11                	je     8025e3 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8025d2:	83 c0 01             	add    $0x1,%eax
  8025d5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8025da:	75 e6                	jne    8025c2 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8025dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e1:	eb 0b                	jmp    8025ee <ipc_find_env+0x3b>
			return envs[i].env_id;
  8025e3:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8025e6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8025eb:	8b 40 48             	mov    0x48(%eax),%eax
}
  8025ee:	5d                   	pop    %ebp
  8025ef:	c3                   	ret    

008025f0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8025f0:	f3 0f 1e fb          	endbr32 
  8025f4:	55                   	push   %ebp
  8025f5:	89 e5                	mov    %esp,%ebp
  8025f7:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8025fa:	89 c2                	mov    %eax,%edx
  8025fc:	c1 ea 16             	shr    $0x16,%edx
  8025ff:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802606:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  80260b:	f6 c1 01             	test   $0x1,%cl
  80260e:	74 1c                	je     80262c <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802610:	c1 e8 0c             	shr    $0xc,%eax
  802613:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80261a:	a8 01                	test   $0x1,%al
  80261c:	74 0e                	je     80262c <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80261e:	c1 e8 0c             	shr    $0xc,%eax
  802621:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802628:	ef 
  802629:	0f b7 d2             	movzwl %dx,%edx
}
  80262c:	89 d0                	mov    %edx,%eax
  80262e:	5d                   	pop    %ebp
  80262f:	c3                   	ret    

00802630 <__udivdi3>:
  802630:	f3 0f 1e fb          	endbr32 
  802634:	55                   	push   %ebp
  802635:	57                   	push   %edi
  802636:	56                   	push   %esi
  802637:	53                   	push   %ebx
  802638:	83 ec 1c             	sub    $0x1c,%esp
  80263b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80263f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802643:	8b 74 24 34          	mov    0x34(%esp),%esi
  802647:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80264b:	85 d2                	test   %edx,%edx
  80264d:	75 19                	jne    802668 <__udivdi3+0x38>
  80264f:	39 f3                	cmp    %esi,%ebx
  802651:	76 4d                	jbe    8026a0 <__udivdi3+0x70>
  802653:	31 ff                	xor    %edi,%edi
  802655:	89 e8                	mov    %ebp,%eax
  802657:	89 f2                	mov    %esi,%edx
  802659:	f7 f3                	div    %ebx
  80265b:	89 fa                	mov    %edi,%edx
  80265d:	83 c4 1c             	add    $0x1c,%esp
  802660:	5b                   	pop    %ebx
  802661:	5e                   	pop    %esi
  802662:	5f                   	pop    %edi
  802663:	5d                   	pop    %ebp
  802664:	c3                   	ret    
  802665:	8d 76 00             	lea    0x0(%esi),%esi
  802668:	39 f2                	cmp    %esi,%edx
  80266a:	76 14                	jbe    802680 <__udivdi3+0x50>
  80266c:	31 ff                	xor    %edi,%edi
  80266e:	31 c0                	xor    %eax,%eax
  802670:	89 fa                	mov    %edi,%edx
  802672:	83 c4 1c             	add    $0x1c,%esp
  802675:	5b                   	pop    %ebx
  802676:	5e                   	pop    %esi
  802677:	5f                   	pop    %edi
  802678:	5d                   	pop    %ebp
  802679:	c3                   	ret    
  80267a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802680:	0f bd fa             	bsr    %edx,%edi
  802683:	83 f7 1f             	xor    $0x1f,%edi
  802686:	75 48                	jne    8026d0 <__udivdi3+0xa0>
  802688:	39 f2                	cmp    %esi,%edx
  80268a:	72 06                	jb     802692 <__udivdi3+0x62>
  80268c:	31 c0                	xor    %eax,%eax
  80268e:	39 eb                	cmp    %ebp,%ebx
  802690:	77 de                	ja     802670 <__udivdi3+0x40>
  802692:	b8 01 00 00 00       	mov    $0x1,%eax
  802697:	eb d7                	jmp    802670 <__udivdi3+0x40>
  802699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026a0:	89 d9                	mov    %ebx,%ecx
  8026a2:	85 db                	test   %ebx,%ebx
  8026a4:	75 0b                	jne    8026b1 <__udivdi3+0x81>
  8026a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8026ab:	31 d2                	xor    %edx,%edx
  8026ad:	f7 f3                	div    %ebx
  8026af:	89 c1                	mov    %eax,%ecx
  8026b1:	31 d2                	xor    %edx,%edx
  8026b3:	89 f0                	mov    %esi,%eax
  8026b5:	f7 f1                	div    %ecx
  8026b7:	89 c6                	mov    %eax,%esi
  8026b9:	89 e8                	mov    %ebp,%eax
  8026bb:	89 f7                	mov    %esi,%edi
  8026bd:	f7 f1                	div    %ecx
  8026bf:	89 fa                	mov    %edi,%edx
  8026c1:	83 c4 1c             	add    $0x1c,%esp
  8026c4:	5b                   	pop    %ebx
  8026c5:	5e                   	pop    %esi
  8026c6:	5f                   	pop    %edi
  8026c7:	5d                   	pop    %ebp
  8026c8:	c3                   	ret    
  8026c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026d0:	89 f9                	mov    %edi,%ecx
  8026d2:	b8 20 00 00 00       	mov    $0x20,%eax
  8026d7:	29 f8                	sub    %edi,%eax
  8026d9:	d3 e2                	shl    %cl,%edx
  8026db:	89 54 24 08          	mov    %edx,0x8(%esp)
  8026df:	89 c1                	mov    %eax,%ecx
  8026e1:	89 da                	mov    %ebx,%edx
  8026e3:	d3 ea                	shr    %cl,%edx
  8026e5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8026e9:	09 d1                	or     %edx,%ecx
  8026eb:	89 f2                	mov    %esi,%edx
  8026ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026f1:	89 f9                	mov    %edi,%ecx
  8026f3:	d3 e3                	shl    %cl,%ebx
  8026f5:	89 c1                	mov    %eax,%ecx
  8026f7:	d3 ea                	shr    %cl,%edx
  8026f9:	89 f9                	mov    %edi,%ecx
  8026fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8026ff:	89 eb                	mov    %ebp,%ebx
  802701:	d3 e6                	shl    %cl,%esi
  802703:	89 c1                	mov    %eax,%ecx
  802705:	d3 eb                	shr    %cl,%ebx
  802707:	09 de                	or     %ebx,%esi
  802709:	89 f0                	mov    %esi,%eax
  80270b:	f7 74 24 08          	divl   0x8(%esp)
  80270f:	89 d6                	mov    %edx,%esi
  802711:	89 c3                	mov    %eax,%ebx
  802713:	f7 64 24 0c          	mull   0xc(%esp)
  802717:	39 d6                	cmp    %edx,%esi
  802719:	72 15                	jb     802730 <__udivdi3+0x100>
  80271b:	89 f9                	mov    %edi,%ecx
  80271d:	d3 e5                	shl    %cl,%ebp
  80271f:	39 c5                	cmp    %eax,%ebp
  802721:	73 04                	jae    802727 <__udivdi3+0xf7>
  802723:	39 d6                	cmp    %edx,%esi
  802725:	74 09                	je     802730 <__udivdi3+0x100>
  802727:	89 d8                	mov    %ebx,%eax
  802729:	31 ff                	xor    %edi,%edi
  80272b:	e9 40 ff ff ff       	jmp    802670 <__udivdi3+0x40>
  802730:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802733:	31 ff                	xor    %edi,%edi
  802735:	e9 36 ff ff ff       	jmp    802670 <__udivdi3+0x40>
  80273a:	66 90                	xchg   %ax,%ax
  80273c:	66 90                	xchg   %ax,%ax
  80273e:	66 90                	xchg   %ax,%ax

00802740 <__umoddi3>:
  802740:	f3 0f 1e fb          	endbr32 
  802744:	55                   	push   %ebp
  802745:	57                   	push   %edi
  802746:	56                   	push   %esi
  802747:	53                   	push   %ebx
  802748:	83 ec 1c             	sub    $0x1c,%esp
  80274b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80274f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802753:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802757:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80275b:	85 c0                	test   %eax,%eax
  80275d:	75 19                	jne    802778 <__umoddi3+0x38>
  80275f:	39 df                	cmp    %ebx,%edi
  802761:	76 5d                	jbe    8027c0 <__umoddi3+0x80>
  802763:	89 f0                	mov    %esi,%eax
  802765:	89 da                	mov    %ebx,%edx
  802767:	f7 f7                	div    %edi
  802769:	89 d0                	mov    %edx,%eax
  80276b:	31 d2                	xor    %edx,%edx
  80276d:	83 c4 1c             	add    $0x1c,%esp
  802770:	5b                   	pop    %ebx
  802771:	5e                   	pop    %esi
  802772:	5f                   	pop    %edi
  802773:	5d                   	pop    %ebp
  802774:	c3                   	ret    
  802775:	8d 76 00             	lea    0x0(%esi),%esi
  802778:	89 f2                	mov    %esi,%edx
  80277a:	39 d8                	cmp    %ebx,%eax
  80277c:	76 12                	jbe    802790 <__umoddi3+0x50>
  80277e:	89 f0                	mov    %esi,%eax
  802780:	89 da                	mov    %ebx,%edx
  802782:	83 c4 1c             	add    $0x1c,%esp
  802785:	5b                   	pop    %ebx
  802786:	5e                   	pop    %esi
  802787:	5f                   	pop    %edi
  802788:	5d                   	pop    %ebp
  802789:	c3                   	ret    
  80278a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802790:	0f bd e8             	bsr    %eax,%ebp
  802793:	83 f5 1f             	xor    $0x1f,%ebp
  802796:	75 50                	jne    8027e8 <__umoddi3+0xa8>
  802798:	39 d8                	cmp    %ebx,%eax
  80279a:	0f 82 e0 00 00 00    	jb     802880 <__umoddi3+0x140>
  8027a0:	89 d9                	mov    %ebx,%ecx
  8027a2:	39 f7                	cmp    %esi,%edi
  8027a4:	0f 86 d6 00 00 00    	jbe    802880 <__umoddi3+0x140>
  8027aa:	89 d0                	mov    %edx,%eax
  8027ac:	89 ca                	mov    %ecx,%edx
  8027ae:	83 c4 1c             	add    $0x1c,%esp
  8027b1:	5b                   	pop    %ebx
  8027b2:	5e                   	pop    %esi
  8027b3:	5f                   	pop    %edi
  8027b4:	5d                   	pop    %ebp
  8027b5:	c3                   	ret    
  8027b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027bd:	8d 76 00             	lea    0x0(%esi),%esi
  8027c0:	89 fd                	mov    %edi,%ebp
  8027c2:	85 ff                	test   %edi,%edi
  8027c4:	75 0b                	jne    8027d1 <__umoddi3+0x91>
  8027c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8027cb:	31 d2                	xor    %edx,%edx
  8027cd:	f7 f7                	div    %edi
  8027cf:	89 c5                	mov    %eax,%ebp
  8027d1:	89 d8                	mov    %ebx,%eax
  8027d3:	31 d2                	xor    %edx,%edx
  8027d5:	f7 f5                	div    %ebp
  8027d7:	89 f0                	mov    %esi,%eax
  8027d9:	f7 f5                	div    %ebp
  8027db:	89 d0                	mov    %edx,%eax
  8027dd:	31 d2                	xor    %edx,%edx
  8027df:	eb 8c                	jmp    80276d <__umoddi3+0x2d>
  8027e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027e8:	89 e9                	mov    %ebp,%ecx
  8027ea:	ba 20 00 00 00       	mov    $0x20,%edx
  8027ef:	29 ea                	sub    %ebp,%edx
  8027f1:	d3 e0                	shl    %cl,%eax
  8027f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027f7:	89 d1                	mov    %edx,%ecx
  8027f9:	89 f8                	mov    %edi,%eax
  8027fb:	d3 e8                	shr    %cl,%eax
  8027fd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802801:	89 54 24 04          	mov    %edx,0x4(%esp)
  802805:	8b 54 24 04          	mov    0x4(%esp),%edx
  802809:	09 c1                	or     %eax,%ecx
  80280b:	89 d8                	mov    %ebx,%eax
  80280d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802811:	89 e9                	mov    %ebp,%ecx
  802813:	d3 e7                	shl    %cl,%edi
  802815:	89 d1                	mov    %edx,%ecx
  802817:	d3 e8                	shr    %cl,%eax
  802819:	89 e9                	mov    %ebp,%ecx
  80281b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80281f:	d3 e3                	shl    %cl,%ebx
  802821:	89 c7                	mov    %eax,%edi
  802823:	89 d1                	mov    %edx,%ecx
  802825:	89 f0                	mov    %esi,%eax
  802827:	d3 e8                	shr    %cl,%eax
  802829:	89 e9                	mov    %ebp,%ecx
  80282b:	89 fa                	mov    %edi,%edx
  80282d:	d3 e6                	shl    %cl,%esi
  80282f:	09 d8                	or     %ebx,%eax
  802831:	f7 74 24 08          	divl   0x8(%esp)
  802835:	89 d1                	mov    %edx,%ecx
  802837:	89 f3                	mov    %esi,%ebx
  802839:	f7 64 24 0c          	mull   0xc(%esp)
  80283d:	89 c6                	mov    %eax,%esi
  80283f:	89 d7                	mov    %edx,%edi
  802841:	39 d1                	cmp    %edx,%ecx
  802843:	72 06                	jb     80284b <__umoddi3+0x10b>
  802845:	75 10                	jne    802857 <__umoddi3+0x117>
  802847:	39 c3                	cmp    %eax,%ebx
  802849:	73 0c                	jae    802857 <__umoddi3+0x117>
  80284b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80284f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802853:	89 d7                	mov    %edx,%edi
  802855:	89 c6                	mov    %eax,%esi
  802857:	89 ca                	mov    %ecx,%edx
  802859:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80285e:	29 f3                	sub    %esi,%ebx
  802860:	19 fa                	sbb    %edi,%edx
  802862:	89 d0                	mov    %edx,%eax
  802864:	d3 e0                	shl    %cl,%eax
  802866:	89 e9                	mov    %ebp,%ecx
  802868:	d3 eb                	shr    %cl,%ebx
  80286a:	d3 ea                	shr    %cl,%edx
  80286c:	09 d8                	or     %ebx,%eax
  80286e:	83 c4 1c             	add    $0x1c,%esp
  802871:	5b                   	pop    %ebx
  802872:	5e                   	pop    %esi
  802873:	5f                   	pop    %edi
  802874:	5d                   	pop    %ebp
  802875:	c3                   	ret    
  802876:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80287d:	8d 76 00             	lea    0x0(%esi),%esi
  802880:	29 fe                	sub    %edi,%esi
  802882:	19 c3                	sbb    %eax,%ebx
  802884:	89 f2                	mov    %esi,%edx
  802886:	89 d9                	mov    %ebx,%ecx
  802888:	e9 1d ff ff ff       	jmp    8027aa <__umoddi3+0x6a>
