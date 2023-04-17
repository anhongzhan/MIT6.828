
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
  800048:	e8 26 0f 00 00       	call   800f73 <fork>
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
  800089:	a1 04 40 80 00       	mov    0x804004,%eax
  80008e:	83 c0 01             	add    $0x1,%eax
  800091:	a3 04 40 80 00       	mov    %eax,0x804004
		for (j = 0; j < 10000; j++)
  800096:	83 ea 01             	sub    $0x1,%edx
  800099:	75 ee                	jne    800089 <umain+0x56>
	for (i = 0; i < 10; i++) {
  80009b:	83 eb 01             	sub    $0x1,%ebx
  80009e:	75 df                	jne    80007f <umain+0x4c>
	}

	if (counter != 10*10000)
  8000a0:	a1 04 40 80 00       	mov    0x804004,%eax
  8000a5:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  8000aa:	75 24                	jne    8000d0 <umain+0x9d>
		panic("ran on two CPUs at once (counter is %d)", counter);

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  8000ac:	a1 08 40 80 00       	mov    0x804008,%eax
  8000b1:	8b 50 5c             	mov    0x5c(%eax),%edx
  8000b4:	8b 40 48             	mov    0x48(%eax),%eax
  8000b7:	83 ec 04             	sub    $0x4,%esp
  8000ba:	52                   	push   %edx
  8000bb:	50                   	push   %eax
  8000bc:	68 7b 23 80 00       	push   $0x80237b
  8000c1:	e8 70 01 00 00       	call   800236 <cprintf>
  8000c6:	83 c4 10             	add    $0x10,%esp

}
  8000c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000cc:	5b                   	pop    %ebx
  8000cd:	5e                   	pop    %esi
  8000ce:	5d                   	pop    %ebp
  8000cf:	c3                   	ret    
		panic("ran on two CPUs at once (counter is %d)", counter);
  8000d0:	a1 04 40 80 00       	mov    0x804004,%eax
  8000d5:	50                   	push   %eax
  8000d6:	68 40 23 80 00       	push   $0x802340
  8000db:	6a 21                	push   $0x21
  8000dd:	68 68 23 80 00       	push   $0x802368
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
  800108:	a3 08 40 80 00       	mov    %eax,0x804008

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
  80013b:	e8 3b 12 00 00       	call   80137b <close_all>
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
  800171:	68 a4 23 80 00       	push   $0x8023a4
  800176:	e8 bb 00 00 00       	call   800236 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80017b:	83 c4 18             	add    $0x18,%esp
  80017e:	53                   	push   %ebx
  80017f:	ff 75 10             	pushl  0x10(%ebp)
  800182:	e8 5a 00 00 00       	call   8001e1 <vcprintf>
	cprintf("\n");
  800187:	c7 04 24 97 23 80 00 	movl   $0x802397,(%esp)
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
  80029c:	e8 2f 1e 00 00       	call   8020d0 <__udivdi3>
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
  8002da:	e8 01 1f 00 00       	call   8021e0 <__umoddi3>
  8002df:	83 c4 14             	add    $0x14,%esp
  8002e2:	0f be 80 c7 23 80 00 	movsbl 0x8023c7(%eax),%eax
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
  800389:	3e ff 24 85 00 25 80 	notrack jmp *0x802500(,%eax,4)
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
  800456:	8b 14 85 60 26 80 00 	mov    0x802660(,%eax,4),%edx
  80045d:	85 d2                	test   %edx,%edx
  80045f:	74 18                	je     800479 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800461:	52                   	push   %edx
  800462:	68 21 28 80 00       	push   $0x802821
  800467:	53                   	push   %ebx
  800468:	56                   	push   %esi
  800469:	e8 aa fe ff ff       	call   800318 <printfmt>
  80046e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800471:	89 7d 14             	mov    %edi,0x14(%ebp)
  800474:	e9 66 02 00 00       	jmp    8006df <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800479:	50                   	push   %eax
  80047a:	68 df 23 80 00       	push   $0x8023df
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
  8004a1:	b8 d8 23 80 00       	mov    $0x8023d8,%eax
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
  800c2b:	68 bf 26 80 00       	push   $0x8026bf
  800c30:	6a 23                	push   $0x23
  800c32:	68 dc 26 80 00       	push   $0x8026dc
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
  800cb8:	68 bf 26 80 00       	push   $0x8026bf
  800cbd:	6a 23                	push   $0x23
  800cbf:	68 dc 26 80 00       	push   $0x8026dc
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
  800cfe:	68 bf 26 80 00       	push   $0x8026bf
  800d03:	6a 23                	push   $0x23
  800d05:	68 dc 26 80 00       	push   $0x8026dc
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
  800d44:	68 bf 26 80 00       	push   $0x8026bf
  800d49:	6a 23                	push   $0x23
  800d4b:	68 dc 26 80 00       	push   $0x8026dc
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
  800d8a:	68 bf 26 80 00       	push   $0x8026bf
  800d8f:	6a 23                	push   $0x23
  800d91:	68 dc 26 80 00       	push   $0x8026dc
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
  800dd0:	68 bf 26 80 00       	push   $0x8026bf
  800dd5:	6a 23                	push   $0x23
  800dd7:	68 dc 26 80 00       	push   $0x8026dc
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
  800e16:	68 bf 26 80 00       	push   $0x8026bf
  800e1b:	6a 23                	push   $0x23
  800e1d:	68 dc 26 80 00       	push   $0x8026dc
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
  800e82:	68 bf 26 80 00       	push   $0x8026bf
  800e87:	6a 23                	push   $0x23
  800e89:	68 dc 26 80 00       	push   $0x8026dc
  800e8e:	e8 bc f2 ff ff       	call   80014f <_panic>

00800e93 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800e93:	f3 0f 1e fb          	endbr32 
  800e97:	55                   	push   %ebp
  800e98:	89 e5                	mov    %esp,%ebp
  800e9a:	53                   	push   %ebx
  800e9b:	83 ec 04             	sub    $0x4,%esp
  800e9e:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800ea1:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  800ea3:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800ea7:	74 74                	je     800f1d <pgfault+0x8a>
  800ea9:	89 d8                	mov    %ebx,%eax
  800eab:	c1 e8 0c             	shr    $0xc,%eax
  800eae:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800eb5:	f6 c4 08             	test   $0x8,%ah
  800eb8:	74 63                	je     800f1d <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800eba:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  800ec0:	83 ec 0c             	sub    $0xc,%esp
  800ec3:	6a 05                	push   $0x5
  800ec5:	68 00 f0 7f 00       	push   $0x7ff000
  800eca:	6a 00                	push   $0x0
  800ecc:	53                   	push   %ebx
  800ecd:	6a 00                	push   $0x0
  800ecf:	e8 f5 fd ff ff       	call   800cc9 <sys_page_map>
  800ed4:	83 c4 20             	add    $0x20,%esp
  800ed7:	85 c0                	test   %eax,%eax
  800ed9:	78 59                	js     800f34 <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  800edb:	83 ec 04             	sub    $0x4,%esp
  800ede:	6a 07                	push   $0x7
  800ee0:	53                   	push   %ebx
  800ee1:	6a 00                	push   $0x0
  800ee3:	e8 9a fd ff ff       	call   800c82 <sys_page_alloc>
  800ee8:	83 c4 10             	add    $0x10,%esp
  800eeb:	85 c0                	test   %eax,%eax
  800eed:	78 5a                	js     800f49 <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  800eef:	83 ec 04             	sub    $0x4,%esp
  800ef2:	68 00 10 00 00       	push   $0x1000
  800ef7:	68 00 f0 7f 00       	push   $0x7ff000
  800efc:	53                   	push   %ebx
  800efd:	e8 f4 fa ff ff       	call   8009f6 <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  800f02:	83 c4 08             	add    $0x8,%esp
  800f05:	68 00 f0 7f 00       	push   $0x7ff000
  800f0a:	6a 00                	push   $0x0
  800f0c:	e8 fe fd ff ff       	call   800d0f <sys_page_unmap>
  800f11:	83 c4 10             	add    $0x10,%esp
  800f14:	85 c0                	test   %eax,%eax
  800f16:	78 46                	js     800f5e <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  800f18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f1b:	c9                   	leave  
  800f1c:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  800f1d:	83 ec 04             	sub    $0x4,%esp
  800f20:	68 ea 26 80 00       	push   $0x8026ea
  800f25:	68 d3 00 00 00       	push   $0xd3
  800f2a:	68 06 27 80 00       	push   $0x802706
  800f2f:	e8 1b f2 ff ff       	call   80014f <_panic>
		panic("pgfault: %e\n", r);
  800f34:	50                   	push   %eax
  800f35:	68 11 27 80 00       	push   $0x802711
  800f3a:	68 df 00 00 00       	push   $0xdf
  800f3f:	68 06 27 80 00       	push   $0x802706
  800f44:	e8 06 f2 ff ff       	call   80014f <_panic>
		panic("pgfault: %e\n", r);
  800f49:	50                   	push   %eax
  800f4a:	68 11 27 80 00       	push   $0x802711
  800f4f:	68 e3 00 00 00       	push   $0xe3
  800f54:	68 06 27 80 00       	push   $0x802706
  800f59:	e8 f1 f1 ff ff       	call   80014f <_panic>
		panic("pgfault: %e\n", r);
  800f5e:	50                   	push   %eax
  800f5f:	68 11 27 80 00       	push   $0x802711
  800f64:	68 e9 00 00 00       	push   $0xe9
  800f69:	68 06 27 80 00       	push   $0x802706
  800f6e:	e8 dc f1 ff ff       	call   80014f <_panic>

00800f73 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800f73:	f3 0f 1e fb          	endbr32 
  800f77:	55                   	push   %ebp
  800f78:	89 e5                	mov    %esp,%ebp
  800f7a:	57                   	push   %edi
  800f7b:	56                   	push   %esi
  800f7c:	53                   	push   %ebx
  800f7d:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  800f80:	68 93 0e 80 00       	push   $0x800e93
  800f85:	e8 47 0f 00 00       	call   801ed1 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f8a:	b8 07 00 00 00       	mov    $0x7,%eax
  800f8f:	cd 30                	int    $0x30
  800f91:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  800f94:	83 c4 10             	add    $0x10,%esp
  800f97:	85 c0                	test   %eax,%eax
  800f99:	78 2d                	js     800fc8 <fork+0x55>
  800f9b:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800f9d:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  800fa2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fa6:	0f 85 9b 00 00 00    	jne    801047 <fork+0xd4>
		thisenv = &envs[ENVX(sys_getenvid())];
  800fac:	e8 8b fc ff ff       	call   800c3c <sys_getenvid>
  800fb1:	25 ff 03 00 00       	and    $0x3ff,%eax
  800fb6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800fb9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800fbe:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  800fc3:	e9 71 01 00 00       	jmp    801139 <fork+0x1c6>
		panic("sys_exofork: %e", envid);
  800fc8:	50                   	push   %eax
  800fc9:	68 1e 27 80 00       	push   $0x80271e
  800fce:	68 2a 01 00 00       	push   $0x12a
  800fd3:	68 06 27 80 00       	push   $0x802706
  800fd8:	e8 72 f1 ff ff       	call   80014f <_panic>
		sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_SYSCALL);
  800fdd:	c1 e6 0c             	shl    $0xc,%esi
  800fe0:	83 ec 0c             	sub    $0xc,%esp
  800fe3:	68 07 0e 00 00       	push   $0xe07
  800fe8:	56                   	push   %esi
  800fe9:	57                   	push   %edi
  800fea:	56                   	push   %esi
  800feb:	6a 00                	push   $0x0
  800fed:	e8 d7 fc ff ff       	call   800cc9 <sys_page_map>
  800ff2:	83 c4 20             	add    $0x20,%esp
  800ff5:	eb 3e                	jmp    801035 <fork+0xc2>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  800ff7:	c1 e6 0c             	shl    $0xc,%esi
  800ffa:	83 ec 0c             	sub    $0xc,%esp
  800ffd:	68 05 08 00 00       	push   $0x805
  801002:	56                   	push   %esi
  801003:	57                   	push   %edi
  801004:	56                   	push   %esi
  801005:	6a 00                	push   $0x0
  801007:	e8 bd fc ff ff       	call   800cc9 <sys_page_map>
  80100c:	83 c4 20             	add    $0x20,%esp
  80100f:	85 c0                	test   %eax,%eax
  801011:	0f 88 bc 00 00 00    	js     8010d3 <fork+0x160>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  801017:	83 ec 0c             	sub    $0xc,%esp
  80101a:	68 05 08 00 00       	push   $0x805
  80101f:	56                   	push   %esi
  801020:	6a 00                	push   $0x0
  801022:	56                   	push   %esi
  801023:	6a 00                	push   $0x0
  801025:	e8 9f fc ff ff       	call   800cc9 <sys_page_map>
  80102a:	83 c4 20             	add    $0x20,%esp
  80102d:	85 c0                	test   %eax,%eax
  80102f:	0f 88 b3 00 00 00    	js     8010e8 <fork+0x175>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801035:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80103b:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801041:	0f 84 b6 00 00 00    	je     8010fd <fork+0x18a>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  801047:	89 d8                	mov    %ebx,%eax
  801049:	c1 e8 16             	shr    $0x16,%eax
  80104c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801053:	a8 01                	test   $0x1,%al
  801055:	74 de                	je     801035 <fork+0xc2>
  801057:	89 de                	mov    %ebx,%esi
  801059:	c1 ee 0c             	shr    $0xc,%esi
  80105c:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801063:	a8 01                	test   $0x1,%al
  801065:	74 ce                	je     801035 <fork+0xc2>
  801067:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80106e:	a8 04                	test   $0x4,%al
  801070:	74 c3                	je     801035 <fork+0xc2>
	if ((uvpt[pn] & PTE_SHARE)){
  801072:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801079:	f6 c4 04             	test   $0x4,%ah
  80107c:	0f 85 5b ff ff ff    	jne    800fdd <fork+0x6a>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  801082:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801089:	a8 02                	test   $0x2,%al
  80108b:	0f 85 66 ff ff ff    	jne    800ff7 <fork+0x84>
  801091:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801098:	f6 c4 08             	test   $0x8,%ah
  80109b:	0f 85 56 ff ff ff    	jne    800ff7 <fork+0x84>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  8010a1:	c1 e6 0c             	shl    $0xc,%esi
  8010a4:	83 ec 0c             	sub    $0xc,%esp
  8010a7:	6a 05                	push   $0x5
  8010a9:	56                   	push   %esi
  8010aa:	57                   	push   %edi
  8010ab:	56                   	push   %esi
  8010ac:	6a 00                	push   $0x0
  8010ae:	e8 16 fc ff ff       	call   800cc9 <sys_page_map>
  8010b3:	83 c4 20             	add    $0x20,%esp
  8010b6:	85 c0                	test   %eax,%eax
  8010b8:	0f 89 77 ff ff ff    	jns    801035 <fork+0xc2>
		panic("duppage: %e\n", r);
  8010be:	50                   	push   %eax
  8010bf:	68 2e 27 80 00       	push   $0x80272e
  8010c4:	68 0c 01 00 00       	push   $0x10c
  8010c9:	68 06 27 80 00       	push   $0x802706
  8010ce:	e8 7c f0 ff ff       	call   80014f <_panic>
			panic("duppage: %e\n", r);
  8010d3:	50                   	push   %eax
  8010d4:	68 2e 27 80 00       	push   $0x80272e
  8010d9:	68 05 01 00 00       	push   $0x105
  8010de:	68 06 27 80 00       	push   $0x802706
  8010e3:	e8 67 f0 ff ff       	call   80014f <_panic>
			panic("duppage: %e\n", r);
  8010e8:	50                   	push   %eax
  8010e9:	68 2e 27 80 00       	push   $0x80272e
  8010ee:	68 09 01 00 00       	push   $0x109
  8010f3:	68 06 27 80 00       	push   $0x802706
  8010f8:	e8 52 f0 ff ff       	call   80014f <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  8010fd:	83 ec 04             	sub    $0x4,%esp
  801100:	6a 07                	push   $0x7
  801102:	68 00 f0 bf ee       	push   $0xeebff000
  801107:	ff 75 e4             	pushl  -0x1c(%ebp)
  80110a:	e8 73 fb ff ff       	call   800c82 <sys_page_alloc>
  80110f:	83 c4 10             	add    $0x10,%esp
  801112:	85 c0                	test   %eax,%eax
  801114:	78 2e                	js     801144 <fork+0x1d1>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801116:	83 ec 08             	sub    $0x8,%esp
  801119:	68 44 1f 80 00       	push   $0x801f44
  80111e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801121:	57                   	push   %edi
  801122:	e8 ba fc ff ff       	call   800de1 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801127:	83 c4 08             	add    $0x8,%esp
  80112a:	6a 02                	push   $0x2
  80112c:	57                   	push   %edi
  80112d:	e8 23 fc ff ff       	call   800d55 <sys_env_set_status>
  801132:	83 c4 10             	add    $0x10,%esp
  801135:	85 c0                	test   %eax,%eax
  801137:	78 20                	js     801159 <fork+0x1e6>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  801139:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80113c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80113f:	5b                   	pop    %ebx
  801140:	5e                   	pop    %esi
  801141:	5f                   	pop    %edi
  801142:	5d                   	pop    %ebp
  801143:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  801144:	50                   	push   %eax
  801145:	68 3b 27 80 00       	push   $0x80273b
  80114a:	68 3e 01 00 00       	push   $0x13e
  80114f:	68 06 27 80 00       	push   $0x802706
  801154:	e8 f6 ef ff ff       	call   80014f <_panic>
		panic("sys_env_set_status: %e", r);
  801159:	50                   	push   %eax
  80115a:	68 4e 27 80 00       	push   $0x80274e
  80115f:	68 43 01 00 00       	push   $0x143
  801164:	68 06 27 80 00       	push   $0x802706
  801169:	e8 e1 ef ff ff       	call   80014f <_panic>

0080116e <sfork>:

// Challenge!
int
sfork(void)
{
  80116e:	f3 0f 1e fb          	endbr32 
  801172:	55                   	push   %ebp
  801173:	89 e5                	mov    %esp,%ebp
  801175:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801178:	68 65 27 80 00       	push   $0x802765
  80117d:	68 4c 01 00 00       	push   $0x14c
  801182:	68 06 27 80 00       	push   $0x802706
  801187:	e8 c3 ef ff ff       	call   80014f <_panic>

0080118c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80118c:	f3 0f 1e fb          	endbr32 
  801190:	55                   	push   %ebp
  801191:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	05 00 00 00 30       	add    $0x30000000,%eax
  80119b:	c1 e8 0c             	shr    $0xc,%eax
}
  80119e:	5d                   	pop    %ebp
  80119f:	c3                   	ret    

008011a0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011a0:	f3 0f 1e fb          	endbr32 
  8011a4:	55                   	push   %ebp
  8011a5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011aa:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8011af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011b4:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011b9:	5d                   	pop    %ebp
  8011ba:	c3                   	ret    

008011bb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011bb:	f3 0f 1e fb          	endbr32 
  8011bf:	55                   	push   %ebp
  8011c0:	89 e5                	mov    %esp,%ebp
  8011c2:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011c7:	89 c2                	mov    %eax,%edx
  8011c9:	c1 ea 16             	shr    $0x16,%edx
  8011cc:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011d3:	f6 c2 01             	test   $0x1,%dl
  8011d6:	74 2d                	je     801205 <fd_alloc+0x4a>
  8011d8:	89 c2                	mov    %eax,%edx
  8011da:	c1 ea 0c             	shr    $0xc,%edx
  8011dd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011e4:	f6 c2 01             	test   $0x1,%dl
  8011e7:	74 1c                	je     801205 <fd_alloc+0x4a>
  8011e9:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8011ee:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011f3:	75 d2                	jne    8011c7 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8011fe:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801203:	eb 0a                	jmp    80120f <fd_alloc+0x54>
			*fd_store = fd;
  801205:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801208:	89 01                	mov    %eax,(%ecx)
			return 0;
  80120a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80120f:	5d                   	pop    %ebp
  801210:	c3                   	ret    

00801211 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801211:	f3 0f 1e fb          	endbr32 
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
  801218:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80121b:	83 f8 1f             	cmp    $0x1f,%eax
  80121e:	77 30                	ja     801250 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801220:	c1 e0 0c             	shl    $0xc,%eax
  801223:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801228:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80122e:	f6 c2 01             	test   $0x1,%dl
  801231:	74 24                	je     801257 <fd_lookup+0x46>
  801233:	89 c2                	mov    %eax,%edx
  801235:	c1 ea 0c             	shr    $0xc,%edx
  801238:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80123f:	f6 c2 01             	test   $0x1,%dl
  801242:	74 1a                	je     80125e <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801244:	8b 55 0c             	mov    0xc(%ebp),%edx
  801247:	89 02                	mov    %eax,(%edx)
	return 0;
  801249:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80124e:	5d                   	pop    %ebp
  80124f:	c3                   	ret    
		return -E_INVAL;
  801250:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801255:	eb f7                	jmp    80124e <fd_lookup+0x3d>
		return -E_INVAL;
  801257:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80125c:	eb f0                	jmp    80124e <fd_lookup+0x3d>
  80125e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801263:	eb e9                	jmp    80124e <fd_lookup+0x3d>

00801265 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801265:	f3 0f 1e fb          	endbr32 
  801269:	55                   	push   %ebp
  80126a:	89 e5                	mov    %esp,%ebp
  80126c:	83 ec 08             	sub    $0x8,%esp
  80126f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801272:	ba f8 27 80 00       	mov    $0x8027f8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801277:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80127c:	39 08                	cmp    %ecx,(%eax)
  80127e:	74 33                	je     8012b3 <dev_lookup+0x4e>
  801280:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801283:	8b 02                	mov    (%edx),%eax
  801285:	85 c0                	test   %eax,%eax
  801287:	75 f3                	jne    80127c <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801289:	a1 08 40 80 00       	mov    0x804008,%eax
  80128e:	8b 40 48             	mov    0x48(%eax),%eax
  801291:	83 ec 04             	sub    $0x4,%esp
  801294:	51                   	push   %ecx
  801295:	50                   	push   %eax
  801296:	68 7c 27 80 00       	push   $0x80277c
  80129b:	e8 96 ef ff ff       	call   800236 <cprintf>
	*dev = 0;
  8012a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8012a9:	83 c4 10             	add    $0x10,%esp
  8012ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012b1:	c9                   	leave  
  8012b2:	c3                   	ret    
			*dev = devtab[i];
  8012b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012b6:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012bd:	eb f2                	jmp    8012b1 <dev_lookup+0x4c>

008012bf <fd_close>:
{
  8012bf:	f3 0f 1e fb          	endbr32 
  8012c3:	55                   	push   %ebp
  8012c4:	89 e5                	mov    %esp,%ebp
  8012c6:	57                   	push   %edi
  8012c7:	56                   	push   %esi
  8012c8:	53                   	push   %ebx
  8012c9:	83 ec 24             	sub    $0x24,%esp
  8012cc:	8b 75 08             	mov    0x8(%ebp),%esi
  8012cf:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012d2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012d5:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012d6:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012dc:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012df:	50                   	push   %eax
  8012e0:	e8 2c ff ff ff       	call   801211 <fd_lookup>
  8012e5:	89 c3                	mov    %eax,%ebx
  8012e7:	83 c4 10             	add    $0x10,%esp
  8012ea:	85 c0                	test   %eax,%eax
  8012ec:	78 05                	js     8012f3 <fd_close+0x34>
	    || fd != fd2)
  8012ee:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012f1:	74 16                	je     801309 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8012f3:	89 f8                	mov    %edi,%eax
  8012f5:	84 c0                	test   %al,%al
  8012f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8012fc:	0f 44 d8             	cmove  %eax,%ebx
}
  8012ff:	89 d8                	mov    %ebx,%eax
  801301:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801304:	5b                   	pop    %ebx
  801305:	5e                   	pop    %esi
  801306:	5f                   	pop    %edi
  801307:	5d                   	pop    %ebp
  801308:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801309:	83 ec 08             	sub    $0x8,%esp
  80130c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80130f:	50                   	push   %eax
  801310:	ff 36                	pushl  (%esi)
  801312:	e8 4e ff ff ff       	call   801265 <dev_lookup>
  801317:	89 c3                	mov    %eax,%ebx
  801319:	83 c4 10             	add    $0x10,%esp
  80131c:	85 c0                	test   %eax,%eax
  80131e:	78 1a                	js     80133a <fd_close+0x7b>
		if (dev->dev_close)
  801320:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801323:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801326:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80132b:	85 c0                	test   %eax,%eax
  80132d:	74 0b                	je     80133a <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80132f:	83 ec 0c             	sub    $0xc,%esp
  801332:	56                   	push   %esi
  801333:	ff d0                	call   *%eax
  801335:	89 c3                	mov    %eax,%ebx
  801337:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80133a:	83 ec 08             	sub    $0x8,%esp
  80133d:	56                   	push   %esi
  80133e:	6a 00                	push   $0x0
  801340:	e8 ca f9 ff ff       	call   800d0f <sys_page_unmap>
	return r;
  801345:	83 c4 10             	add    $0x10,%esp
  801348:	eb b5                	jmp    8012ff <fd_close+0x40>

0080134a <close>:

int
close(int fdnum)
{
  80134a:	f3 0f 1e fb          	endbr32 
  80134e:	55                   	push   %ebp
  80134f:	89 e5                	mov    %esp,%ebp
  801351:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801354:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801357:	50                   	push   %eax
  801358:	ff 75 08             	pushl  0x8(%ebp)
  80135b:	e8 b1 fe ff ff       	call   801211 <fd_lookup>
  801360:	83 c4 10             	add    $0x10,%esp
  801363:	85 c0                	test   %eax,%eax
  801365:	79 02                	jns    801369 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801367:	c9                   	leave  
  801368:	c3                   	ret    
		return fd_close(fd, 1);
  801369:	83 ec 08             	sub    $0x8,%esp
  80136c:	6a 01                	push   $0x1
  80136e:	ff 75 f4             	pushl  -0xc(%ebp)
  801371:	e8 49 ff ff ff       	call   8012bf <fd_close>
  801376:	83 c4 10             	add    $0x10,%esp
  801379:	eb ec                	jmp    801367 <close+0x1d>

0080137b <close_all>:

void
close_all(void)
{
  80137b:	f3 0f 1e fb          	endbr32 
  80137f:	55                   	push   %ebp
  801380:	89 e5                	mov    %esp,%ebp
  801382:	53                   	push   %ebx
  801383:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801386:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80138b:	83 ec 0c             	sub    $0xc,%esp
  80138e:	53                   	push   %ebx
  80138f:	e8 b6 ff ff ff       	call   80134a <close>
	for (i = 0; i < MAXFD; i++)
  801394:	83 c3 01             	add    $0x1,%ebx
  801397:	83 c4 10             	add    $0x10,%esp
  80139a:	83 fb 20             	cmp    $0x20,%ebx
  80139d:	75 ec                	jne    80138b <close_all+0x10>
}
  80139f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013a2:	c9                   	leave  
  8013a3:	c3                   	ret    

008013a4 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013a4:	f3 0f 1e fb          	endbr32 
  8013a8:	55                   	push   %ebp
  8013a9:	89 e5                	mov    %esp,%ebp
  8013ab:	57                   	push   %edi
  8013ac:	56                   	push   %esi
  8013ad:	53                   	push   %ebx
  8013ae:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013b1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013b4:	50                   	push   %eax
  8013b5:	ff 75 08             	pushl  0x8(%ebp)
  8013b8:	e8 54 fe ff ff       	call   801211 <fd_lookup>
  8013bd:	89 c3                	mov    %eax,%ebx
  8013bf:	83 c4 10             	add    $0x10,%esp
  8013c2:	85 c0                	test   %eax,%eax
  8013c4:	0f 88 81 00 00 00    	js     80144b <dup+0xa7>
		return r;
	close(newfdnum);
  8013ca:	83 ec 0c             	sub    $0xc,%esp
  8013cd:	ff 75 0c             	pushl  0xc(%ebp)
  8013d0:	e8 75 ff ff ff       	call   80134a <close>

	newfd = INDEX2FD(newfdnum);
  8013d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013d8:	c1 e6 0c             	shl    $0xc,%esi
  8013db:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8013e1:	83 c4 04             	add    $0x4,%esp
  8013e4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013e7:	e8 b4 fd ff ff       	call   8011a0 <fd2data>
  8013ec:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013ee:	89 34 24             	mov    %esi,(%esp)
  8013f1:	e8 aa fd ff ff       	call   8011a0 <fd2data>
  8013f6:	83 c4 10             	add    $0x10,%esp
  8013f9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013fb:	89 d8                	mov    %ebx,%eax
  8013fd:	c1 e8 16             	shr    $0x16,%eax
  801400:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801407:	a8 01                	test   $0x1,%al
  801409:	74 11                	je     80141c <dup+0x78>
  80140b:	89 d8                	mov    %ebx,%eax
  80140d:	c1 e8 0c             	shr    $0xc,%eax
  801410:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801417:	f6 c2 01             	test   $0x1,%dl
  80141a:	75 39                	jne    801455 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80141c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80141f:	89 d0                	mov    %edx,%eax
  801421:	c1 e8 0c             	shr    $0xc,%eax
  801424:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80142b:	83 ec 0c             	sub    $0xc,%esp
  80142e:	25 07 0e 00 00       	and    $0xe07,%eax
  801433:	50                   	push   %eax
  801434:	56                   	push   %esi
  801435:	6a 00                	push   $0x0
  801437:	52                   	push   %edx
  801438:	6a 00                	push   $0x0
  80143a:	e8 8a f8 ff ff       	call   800cc9 <sys_page_map>
  80143f:	89 c3                	mov    %eax,%ebx
  801441:	83 c4 20             	add    $0x20,%esp
  801444:	85 c0                	test   %eax,%eax
  801446:	78 31                	js     801479 <dup+0xd5>
		goto err;

	return newfdnum;
  801448:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80144b:	89 d8                	mov    %ebx,%eax
  80144d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801450:	5b                   	pop    %ebx
  801451:	5e                   	pop    %esi
  801452:	5f                   	pop    %edi
  801453:	5d                   	pop    %ebp
  801454:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801455:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80145c:	83 ec 0c             	sub    $0xc,%esp
  80145f:	25 07 0e 00 00       	and    $0xe07,%eax
  801464:	50                   	push   %eax
  801465:	57                   	push   %edi
  801466:	6a 00                	push   $0x0
  801468:	53                   	push   %ebx
  801469:	6a 00                	push   $0x0
  80146b:	e8 59 f8 ff ff       	call   800cc9 <sys_page_map>
  801470:	89 c3                	mov    %eax,%ebx
  801472:	83 c4 20             	add    $0x20,%esp
  801475:	85 c0                	test   %eax,%eax
  801477:	79 a3                	jns    80141c <dup+0x78>
	sys_page_unmap(0, newfd);
  801479:	83 ec 08             	sub    $0x8,%esp
  80147c:	56                   	push   %esi
  80147d:	6a 00                	push   $0x0
  80147f:	e8 8b f8 ff ff       	call   800d0f <sys_page_unmap>
	sys_page_unmap(0, nva);
  801484:	83 c4 08             	add    $0x8,%esp
  801487:	57                   	push   %edi
  801488:	6a 00                	push   $0x0
  80148a:	e8 80 f8 ff ff       	call   800d0f <sys_page_unmap>
	return r;
  80148f:	83 c4 10             	add    $0x10,%esp
  801492:	eb b7                	jmp    80144b <dup+0xa7>

00801494 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801494:	f3 0f 1e fb          	endbr32 
  801498:	55                   	push   %ebp
  801499:	89 e5                	mov    %esp,%ebp
  80149b:	53                   	push   %ebx
  80149c:	83 ec 1c             	sub    $0x1c,%esp
  80149f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014a2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014a5:	50                   	push   %eax
  8014a6:	53                   	push   %ebx
  8014a7:	e8 65 fd ff ff       	call   801211 <fd_lookup>
  8014ac:	83 c4 10             	add    $0x10,%esp
  8014af:	85 c0                	test   %eax,%eax
  8014b1:	78 3f                	js     8014f2 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014b3:	83 ec 08             	sub    $0x8,%esp
  8014b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014b9:	50                   	push   %eax
  8014ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014bd:	ff 30                	pushl  (%eax)
  8014bf:	e8 a1 fd ff ff       	call   801265 <dev_lookup>
  8014c4:	83 c4 10             	add    $0x10,%esp
  8014c7:	85 c0                	test   %eax,%eax
  8014c9:	78 27                	js     8014f2 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014ce:	8b 42 08             	mov    0x8(%edx),%eax
  8014d1:	83 e0 03             	and    $0x3,%eax
  8014d4:	83 f8 01             	cmp    $0x1,%eax
  8014d7:	74 1e                	je     8014f7 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014dc:	8b 40 08             	mov    0x8(%eax),%eax
  8014df:	85 c0                	test   %eax,%eax
  8014e1:	74 35                	je     801518 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014e3:	83 ec 04             	sub    $0x4,%esp
  8014e6:	ff 75 10             	pushl  0x10(%ebp)
  8014e9:	ff 75 0c             	pushl  0xc(%ebp)
  8014ec:	52                   	push   %edx
  8014ed:	ff d0                	call   *%eax
  8014ef:	83 c4 10             	add    $0x10,%esp
}
  8014f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014f5:	c9                   	leave  
  8014f6:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014f7:	a1 08 40 80 00       	mov    0x804008,%eax
  8014fc:	8b 40 48             	mov    0x48(%eax),%eax
  8014ff:	83 ec 04             	sub    $0x4,%esp
  801502:	53                   	push   %ebx
  801503:	50                   	push   %eax
  801504:	68 bd 27 80 00       	push   $0x8027bd
  801509:	e8 28 ed ff ff       	call   800236 <cprintf>
		return -E_INVAL;
  80150e:	83 c4 10             	add    $0x10,%esp
  801511:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801516:	eb da                	jmp    8014f2 <read+0x5e>
		return -E_NOT_SUPP;
  801518:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80151d:	eb d3                	jmp    8014f2 <read+0x5e>

0080151f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80151f:	f3 0f 1e fb          	endbr32 
  801523:	55                   	push   %ebp
  801524:	89 e5                	mov    %esp,%ebp
  801526:	57                   	push   %edi
  801527:	56                   	push   %esi
  801528:	53                   	push   %ebx
  801529:	83 ec 0c             	sub    $0xc,%esp
  80152c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80152f:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801532:	bb 00 00 00 00       	mov    $0x0,%ebx
  801537:	eb 02                	jmp    80153b <readn+0x1c>
  801539:	01 c3                	add    %eax,%ebx
  80153b:	39 f3                	cmp    %esi,%ebx
  80153d:	73 21                	jae    801560 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80153f:	83 ec 04             	sub    $0x4,%esp
  801542:	89 f0                	mov    %esi,%eax
  801544:	29 d8                	sub    %ebx,%eax
  801546:	50                   	push   %eax
  801547:	89 d8                	mov    %ebx,%eax
  801549:	03 45 0c             	add    0xc(%ebp),%eax
  80154c:	50                   	push   %eax
  80154d:	57                   	push   %edi
  80154e:	e8 41 ff ff ff       	call   801494 <read>
		if (m < 0)
  801553:	83 c4 10             	add    $0x10,%esp
  801556:	85 c0                	test   %eax,%eax
  801558:	78 04                	js     80155e <readn+0x3f>
			return m;
		if (m == 0)
  80155a:	75 dd                	jne    801539 <readn+0x1a>
  80155c:	eb 02                	jmp    801560 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80155e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801560:	89 d8                	mov    %ebx,%eax
  801562:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801565:	5b                   	pop    %ebx
  801566:	5e                   	pop    %esi
  801567:	5f                   	pop    %edi
  801568:	5d                   	pop    %ebp
  801569:	c3                   	ret    

0080156a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80156a:	f3 0f 1e fb          	endbr32 
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
  801571:	53                   	push   %ebx
  801572:	83 ec 1c             	sub    $0x1c,%esp
  801575:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801578:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80157b:	50                   	push   %eax
  80157c:	53                   	push   %ebx
  80157d:	e8 8f fc ff ff       	call   801211 <fd_lookup>
  801582:	83 c4 10             	add    $0x10,%esp
  801585:	85 c0                	test   %eax,%eax
  801587:	78 3a                	js     8015c3 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801589:	83 ec 08             	sub    $0x8,%esp
  80158c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80158f:	50                   	push   %eax
  801590:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801593:	ff 30                	pushl  (%eax)
  801595:	e8 cb fc ff ff       	call   801265 <dev_lookup>
  80159a:	83 c4 10             	add    $0x10,%esp
  80159d:	85 c0                	test   %eax,%eax
  80159f:	78 22                	js     8015c3 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a4:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015a8:	74 1e                	je     8015c8 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015ad:	8b 52 0c             	mov    0xc(%edx),%edx
  8015b0:	85 d2                	test   %edx,%edx
  8015b2:	74 35                	je     8015e9 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015b4:	83 ec 04             	sub    $0x4,%esp
  8015b7:	ff 75 10             	pushl  0x10(%ebp)
  8015ba:	ff 75 0c             	pushl  0xc(%ebp)
  8015bd:	50                   	push   %eax
  8015be:	ff d2                	call   *%edx
  8015c0:	83 c4 10             	add    $0x10,%esp
}
  8015c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015c6:	c9                   	leave  
  8015c7:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015c8:	a1 08 40 80 00       	mov    0x804008,%eax
  8015cd:	8b 40 48             	mov    0x48(%eax),%eax
  8015d0:	83 ec 04             	sub    $0x4,%esp
  8015d3:	53                   	push   %ebx
  8015d4:	50                   	push   %eax
  8015d5:	68 d9 27 80 00       	push   $0x8027d9
  8015da:	e8 57 ec ff ff       	call   800236 <cprintf>
		return -E_INVAL;
  8015df:	83 c4 10             	add    $0x10,%esp
  8015e2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015e7:	eb da                	jmp    8015c3 <write+0x59>
		return -E_NOT_SUPP;
  8015e9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015ee:	eb d3                	jmp    8015c3 <write+0x59>

008015f0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8015f0:	f3 0f 1e fb          	endbr32 
  8015f4:	55                   	push   %ebp
  8015f5:	89 e5                	mov    %esp,%ebp
  8015f7:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015fd:	50                   	push   %eax
  8015fe:	ff 75 08             	pushl  0x8(%ebp)
  801601:	e8 0b fc ff ff       	call   801211 <fd_lookup>
  801606:	83 c4 10             	add    $0x10,%esp
  801609:	85 c0                	test   %eax,%eax
  80160b:	78 0e                	js     80161b <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80160d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801613:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801616:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80161b:	c9                   	leave  
  80161c:	c3                   	ret    

0080161d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80161d:	f3 0f 1e fb          	endbr32 
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
  801624:	53                   	push   %ebx
  801625:	83 ec 1c             	sub    $0x1c,%esp
  801628:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80162b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80162e:	50                   	push   %eax
  80162f:	53                   	push   %ebx
  801630:	e8 dc fb ff ff       	call   801211 <fd_lookup>
  801635:	83 c4 10             	add    $0x10,%esp
  801638:	85 c0                	test   %eax,%eax
  80163a:	78 37                	js     801673 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80163c:	83 ec 08             	sub    $0x8,%esp
  80163f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801642:	50                   	push   %eax
  801643:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801646:	ff 30                	pushl  (%eax)
  801648:	e8 18 fc ff ff       	call   801265 <dev_lookup>
  80164d:	83 c4 10             	add    $0x10,%esp
  801650:	85 c0                	test   %eax,%eax
  801652:	78 1f                	js     801673 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801654:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801657:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80165b:	74 1b                	je     801678 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80165d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801660:	8b 52 18             	mov    0x18(%edx),%edx
  801663:	85 d2                	test   %edx,%edx
  801665:	74 32                	je     801699 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801667:	83 ec 08             	sub    $0x8,%esp
  80166a:	ff 75 0c             	pushl  0xc(%ebp)
  80166d:	50                   	push   %eax
  80166e:	ff d2                	call   *%edx
  801670:	83 c4 10             	add    $0x10,%esp
}
  801673:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801676:	c9                   	leave  
  801677:	c3                   	ret    
			thisenv->env_id, fdnum);
  801678:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80167d:	8b 40 48             	mov    0x48(%eax),%eax
  801680:	83 ec 04             	sub    $0x4,%esp
  801683:	53                   	push   %ebx
  801684:	50                   	push   %eax
  801685:	68 9c 27 80 00       	push   $0x80279c
  80168a:	e8 a7 eb ff ff       	call   800236 <cprintf>
		return -E_INVAL;
  80168f:	83 c4 10             	add    $0x10,%esp
  801692:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801697:	eb da                	jmp    801673 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801699:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80169e:	eb d3                	jmp    801673 <ftruncate+0x56>

008016a0 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016a0:	f3 0f 1e fb          	endbr32 
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
  8016a7:	53                   	push   %ebx
  8016a8:	83 ec 1c             	sub    $0x1c,%esp
  8016ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016ae:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016b1:	50                   	push   %eax
  8016b2:	ff 75 08             	pushl  0x8(%ebp)
  8016b5:	e8 57 fb ff ff       	call   801211 <fd_lookup>
  8016ba:	83 c4 10             	add    $0x10,%esp
  8016bd:	85 c0                	test   %eax,%eax
  8016bf:	78 4b                	js     80170c <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016c1:	83 ec 08             	sub    $0x8,%esp
  8016c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016c7:	50                   	push   %eax
  8016c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016cb:	ff 30                	pushl  (%eax)
  8016cd:	e8 93 fb ff ff       	call   801265 <dev_lookup>
  8016d2:	83 c4 10             	add    $0x10,%esp
  8016d5:	85 c0                	test   %eax,%eax
  8016d7:	78 33                	js     80170c <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8016d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016dc:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016e0:	74 2f                	je     801711 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016e2:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016e5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016ec:	00 00 00 
	stat->st_isdir = 0;
  8016ef:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016f6:	00 00 00 
	stat->st_dev = dev;
  8016f9:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016ff:	83 ec 08             	sub    $0x8,%esp
  801702:	53                   	push   %ebx
  801703:	ff 75 f0             	pushl  -0x10(%ebp)
  801706:	ff 50 14             	call   *0x14(%eax)
  801709:	83 c4 10             	add    $0x10,%esp
}
  80170c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80170f:	c9                   	leave  
  801710:	c3                   	ret    
		return -E_NOT_SUPP;
  801711:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801716:	eb f4                	jmp    80170c <fstat+0x6c>

00801718 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801718:	f3 0f 1e fb          	endbr32 
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
  80171f:	56                   	push   %esi
  801720:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801721:	83 ec 08             	sub    $0x8,%esp
  801724:	6a 00                	push   $0x0
  801726:	ff 75 08             	pushl  0x8(%ebp)
  801729:	e8 fb 01 00 00       	call   801929 <open>
  80172e:	89 c3                	mov    %eax,%ebx
  801730:	83 c4 10             	add    $0x10,%esp
  801733:	85 c0                	test   %eax,%eax
  801735:	78 1b                	js     801752 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801737:	83 ec 08             	sub    $0x8,%esp
  80173a:	ff 75 0c             	pushl  0xc(%ebp)
  80173d:	50                   	push   %eax
  80173e:	e8 5d ff ff ff       	call   8016a0 <fstat>
  801743:	89 c6                	mov    %eax,%esi
	close(fd);
  801745:	89 1c 24             	mov    %ebx,(%esp)
  801748:	e8 fd fb ff ff       	call   80134a <close>
	return r;
  80174d:	83 c4 10             	add    $0x10,%esp
  801750:	89 f3                	mov    %esi,%ebx
}
  801752:	89 d8                	mov    %ebx,%eax
  801754:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801757:	5b                   	pop    %ebx
  801758:	5e                   	pop    %esi
  801759:	5d                   	pop    %ebp
  80175a:	c3                   	ret    

0080175b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80175b:	55                   	push   %ebp
  80175c:	89 e5                	mov    %esp,%ebp
  80175e:	56                   	push   %esi
  80175f:	53                   	push   %ebx
  801760:	89 c6                	mov    %eax,%esi
  801762:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801764:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80176b:	74 27                	je     801794 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80176d:	6a 07                	push   $0x7
  80176f:	68 00 50 80 00       	push   $0x805000
  801774:	56                   	push   %esi
  801775:	ff 35 00 40 80 00    	pushl  0x804000
  80177b:	e8 6f 08 00 00       	call   801fef <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801780:	83 c4 0c             	add    $0xc,%esp
  801783:	6a 00                	push   $0x0
  801785:	53                   	push   %ebx
  801786:	6a 00                	push   $0x0
  801788:	e8 dd 07 00 00       	call   801f6a <ipc_recv>
}
  80178d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801790:	5b                   	pop    %ebx
  801791:	5e                   	pop    %esi
  801792:	5d                   	pop    %ebp
  801793:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801794:	83 ec 0c             	sub    $0xc,%esp
  801797:	6a 01                	push   $0x1
  801799:	e8 a9 08 00 00       	call   802047 <ipc_find_env>
  80179e:	a3 00 40 80 00       	mov    %eax,0x804000
  8017a3:	83 c4 10             	add    $0x10,%esp
  8017a6:	eb c5                	jmp    80176d <fsipc+0x12>

008017a8 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017a8:	f3 0f 1e fb          	endbr32 
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
  8017af:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8017b8:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8017bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c0:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ca:	b8 02 00 00 00       	mov    $0x2,%eax
  8017cf:	e8 87 ff ff ff       	call   80175b <fsipc>
}
  8017d4:	c9                   	leave  
  8017d5:	c3                   	ret    

008017d6 <devfile_flush>:
{
  8017d6:	f3 0f 1e fb          	endbr32 
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
  8017dd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8017e6:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f0:	b8 06 00 00 00       	mov    $0x6,%eax
  8017f5:	e8 61 ff ff ff       	call   80175b <fsipc>
}
  8017fa:	c9                   	leave  
  8017fb:	c3                   	ret    

008017fc <devfile_stat>:
{
  8017fc:	f3 0f 1e fb          	endbr32 
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	53                   	push   %ebx
  801804:	83 ec 04             	sub    $0x4,%esp
  801807:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80180a:	8b 45 08             	mov    0x8(%ebp),%eax
  80180d:	8b 40 0c             	mov    0xc(%eax),%eax
  801810:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801815:	ba 00 00 00 00       	mov    $0x0,%edx
  80181a:	b8 05 00 00 00       	mov    $0x5,%eax
  80181f:	e8 37 ff ff ff       	call   80175b <fsipc>
  801824:	85 c0                	test   %eax,%eax
  801826:	78 2c                	js     801854 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801828:	83 ec 08             	sub    $0x8,%esp
  80182b:	68 00 50 80 00       	push   $0x805000
  801830:	53                   	push   %ebx
  801831:	e8 0a f0 ff ff       	call   800840 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801836:	a1 80 50 80 00       	mov    0x805080,%eax
  80183b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801841:	a1 84 50 80 00       	mov    0x805084,%eax
  801846:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80184c:	83 c4 10             	add    $0x10,%esp
  80184f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801854:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801857:	c9                   	leave  
  801858:	c3                   	ret    

00801859 <devfile_write>:
{
  801859:	f3 0f 1e fb          	endbr32 
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
  801860:	83 ec 0c             	sub    $0xc,%esp
  801863:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801866:	8b 55 08             	mov    0x8(%ebp),%edx
  801869:	8b 52 0c             	mov    0xc(%edx),%edx
  80186c:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801872:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801877:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80187c:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  80187f:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801884:	50                   	push   %eax
  801885:	ff 75 0c             	pushl  0xc(%ebp)
  801888:	68 08 50 80 00       	push   $0x805008
  80188d:	e8 64 f1 ff ff       	call   8009f6 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801892:	ba 00 00 00 00       	mov    $0x0,%edx
  801897:	b8 04 00 00 00       	mov    $0x4,%eax
  80189c:	e8 ba fe ff ff       	call   80175b <fsipc>
}
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    

008018a3 <devfile_read>:
{
  8018a3:	f3 0f 1e fb          	endbr32 
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
  8018aa:	56                   	push   %esi
  8018ab:	53                   	push   %ebx
  8018ac:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018af:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8018b5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018ba:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8018c5:	b8 03 00 00 00       	mov    $0x3,%eax
  8018ca:	e8 8c fe ff ff       	call   80175b <fsipc>
  8018cf:	89 c3                	mov    %eax,%ebx
  8018d1:	85 c0                	test   %eax,%eax
  8018d3:	78 1f                	js     8018f4 <devfile_read+0x51>
	assert(r <= n);
  8018d5:	39 f0                	cmp    %esi,%eax
  8018d7:	77 24                	ja     8018fd <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8018d9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018de:	7f 33                	jg     801913 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018e0:	83 ec 04             	sub    $0x4,%esp
  8018e3:	50                   	push   %eax
  8018e4:	68 00 50 80 00       	push   $0x805000
  8018e9:	ff 75 0c             	pushl  0xc(%ebp)
  8018ec:	e8 05 f1 ff ff       	call   8009f6 <memmove>
	return r;
  8018f1:	83 c4 10             	add    $0x10,%esp
}
  8018f4:	89 d8                	mov    %ebx,%eax
  8018f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018f9:	5b                   	pop    %ebx
  8018fa:	5e                   	pop    %esi
  8018fb:	5d                   	pop    %ebp
  8018fc:	c3                   	ret    
	assert(r <= n);
  8018fd:	68 08 28 80 00       	push   $0x802808
  801902:	68 0f 28 80 00       	push   $0x80280f
  801907:	6a 7c                	push   $0x7c
  801909:	68 24 28 80 00       	push   $0x802824
  80190e:	e8 3c e8 ff ff       	call   80014f <_panic>
	assert(r <= PGSIZE);
  801913:	68 2f 28 80 00       	push   $0x80282f
  801918:	68 0f 28 80 00       	push   $0x80280f
  80191d:	6a 7d                	push   $0x7d
  80191f:	68 24 28 80 00       	push   $0x802824
  801924:	e8 26 e8 ff ff       	call   80014f <_panic>

00801929 <open>:
{
  801929:	f3 0f 1e fb          	endbr32 
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
  801930:	56                   	push   %esi
  801931:	53                   	push   %ebx
  801932:	83 ec 1c             	sub    $0x1c,%esp
  801935:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801938:	56                   	push   %esi
  801939:	e8 bf ee ff ff       	call   8007fd <strlen>
  80193e:	83 c4 10             	add    $0x10,%esp
  801941:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801946:	7f 6c                	jg     8019b4 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801948:	83 ec 0c             	sub    $0xc,%esp
  80194b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80194e:	50                   	push   %eax
  80194f:	e8 67 f8 ff ff       	call   8011bb <fd_alloc>
  801954:	89 c3                	mov    %eax,%ebx
  801956:	83 c4 10             	add    $0x10,%esp
  801959:	85 c0                	test   %eax,%eax
  80195b:	78 3c                	js     801999 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  80195d:	83 ec 08             	sub    $0x8,%esp
  801960:	56                   	push   %esi
  801961:	68 00 50 80 00       	push   $0x805000
  801966:	e8 d5 ee ff ff       	call   800840 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80196b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196e:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801973:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801976:	b8 01 00 00 00       	mov    $0x1,%eax
  80197b:	e8 db fd ff ff       	call   80175b <fsipc>
  801980:	89 c3                	mov    %eax,%ebx
  801982:	83 c4 10             	add    $0x10,%esp
  801985:	85 c0                	test   %eax,%eax
  801987:	78 19                	js     8019a2 <open+0x79>
	return fd2num(fd);
  801989:	83 ec 0c             	sub    $0xc,%esp
  80198c:	ff 75 f4             	pushl  -0xc(%ebp)
  80198f:	e8 f8 f7 ff ff       	call   80118c <fd2num>
  801994:	89 c3                	mov    %eax,%ebx
  801996:	83 c4 10             	add    $0x10,%esp
}
  801999:	89 d8                	mov    %ebx,%eax
  80199b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80199e:	5b                   	pop    %ebx
  80199f:	5e                   	pop    %esi
  8019a0:	5d                   	pop    %ebp
  8019a1:	c3                   	ret    
		fd_close(fd, 0);
  8019a2:	83 ec 08             	sub    $0x8,%esp
  8019a5:	6a 00                	push   $0x0
  8019a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8019aa:	e8 10 f9 ff ff       	call   8012bf <fd_close>
		return r;
  8019af:	83 c4 10             	add    $0x10,%esp
  8019b2:	eb e5                	jmp    801999 <open+0x70>
		return -E_BAD_PATH;
  8019b4:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8019b9:	eb de                	jmp    801999 <open+0x70>

008019bb <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019bb:	f3 0f 1e fb          	endbr32 
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
  8019c2:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ca:	b8 08 00 00 00       	mov    $0x8,%eax
  8019cf:	e8 87 fd ff ff       	call   80175b <fsipc>
}
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8019d6:	f3 0f 1e fb          	endbr32 
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
  8019dd:	56                   	push   %esi
  8019de:	53                   	push   %ebx
  8019df:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8019e2:	83 ec 0c             	sub    $0xc,%esp
  8019e5:	ff 75 08             	pushl  0x8(%ebp)
  8019e8:	e8 b3 f7 ff ff       	call   8011a0 <fd2data>
  8019ed:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8019ef:	83 c4 08             	add    $0x8,%esp
  8019f2:	68 3b 28 80 00       	push   $0x80283b
  8019f7:	53                   	push   %ebx
  8019f8:	e8 43 ee ff ff       	call   800840 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8019fd:	8b 46 04             	mov    0x4(%esi),%eax
  801a00:	2b 06                	sub    (%esi),%eax
  801a02:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801a08:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a0f:	00 00 00 
	stat->st_dev = &devpipe;
  801a12:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801a19:	30 80 00 
	return 0;
}
  801a1c:	b8 00 00 00 00       	mov    $0x0,%eax
  801a21:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a24:	5b                   	pop    %ebx
  801a25:	5e                   	pop    %esi
  801a26:	5d                   	pop    %ebp
  801a27:	c3                   	ret    

00801a28 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801a28:	f3 0f 1e fb          	endbr32 
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
  801a2f:	53                   	push   %ebx
  801a30:	83 ec 0c             	sub    $0xc,%esp
  801a33:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801a36:	53                   	push   %ebx
  801a37:	6a 00                	push   $0x0
  801a39:	e8 d1 f2 ff ff       	call   800d0f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801a3e:	89 1c 24             	mov    %ebx,(%esp)
  801a41:	e8 5a f7 ff ff       	call   8011a0 <fd2data>
  801a46:	83 c4 08             	add    $0x8,%esp
  801a49:	50                   	push   %eax
  801a4a:	6a 00                	push   $0x0
  801a4c:	e8 be f2 ff ff       	call   800d0f <sys_page_unmap>
}
  801a51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <_pipeisclosed>:
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
  801a59:	57                   	push   %edi
  801a5a:	56                   	push   %esi
  801a5b:	53                   	push   %ebx
  801a5c:	83 ec 1c             	sub    $0x1c,%esp
  801a5f:	89 c7                	mov    %eax,%edi
  801a61:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801a63:	a1 08 40 80 00       	mov    0x804008,%eax
  801a68:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801a6b:	83 ec 0c             	sub    $0xc,%esp
  801a6e:	57                   	push   %edi
  801a6f:	e8 10 06 00 00       	call   802084 <pageref>
  801a74:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a77:	89 34 24             	mov    %esi,(%esp)
  801a7a:	e8 05 06 00 00       	call   802084 <pageref>
		nn = thisenv->env_runs;
  801a7f:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801a85:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801a88:	83 c4 10             	add    $0x10,%esp
  801a8b:	39 cb                	cmp    %ecx,%ebx
  801a8d:	74 1b                	je     801aaa <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801a8f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a92:	75 cf                	jne    801a63 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801a94:	8b 42 58             	mov    0x58(%edx),%eax
  801a97:	6a 01                	push   $0x1
  801a99:	50                   	push   %eax
  801a9a:	53                   	push   %ebx
  801a9b:	68 42 28 80 00       	push   $0x802842
  801aa0:	e8 91 e7 ff ff       	call   800236 <cprintf>
  801aa5:	83 c4 10             	add    $0x10,%esp
  801aa8:	eb b9                	jmp    801a63 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801aaa:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801aad:	0f 94 c0             	sete   %al
  801ab0:	0f b6 c0             	movzbl %al,%eax
}
  801ab3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ab6:	5b                   	pop    %ebx
  801ab7:	5e                   	pop    %esi
  801ab8:	5f                   	pop    %edi
  801ab9:	5d                   	pop    %ebp
  801aba:	c3                   	ret    

00801abb <devpipe_write>:
{
  801abb:	f3 0f 1e fb          	endbr32 
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
  801ac2:	57                   	push   %edi
  801ac3:	56                   	push   %esi
  801ac4:	53                   	push   %ebx
  801ac5:	83 ec 28             	sub    $0x28,%esp
  801ac8:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801acb:	56                   	push   %esi
  801acc:	e8 cf f6 ff ff       	call   8011a0 <fd2data>
  801ad1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ad3:	83 c4 10             	add    $0x10,%esp
  801ad6:	bf 00 00 00 00       	mov    $0x0,%edi
  801adb:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ade:	74 4f                	je     801b2f <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ae0:	8b 43 04             	mov    0x4(%ebx),%eax
  801ae3:	8b 0b                	mov    (%ebx),%ecx
  801ae5:	8d 51 20             	lea    0x20(%ecx),%edx
  801ae8:	39 d0                	cmp    %edx,%eax
  801aea:	72 14                	jb     801b00 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801aec:	89 da                	mov    %ebx,%edx
  801aee:	89 f0                	mov    %esi,%eax
  801af0:	e8 61 ff ff ff       	call   801a56 <_pipeisclosed>
  801af5:	85 c0                	test   %eax,%eax
  801af7:	75 3b                	jne    801b34 <devpipe_write+0x79>
			sys_yield();
  801af9:	e8 61 f1 ff ff       	call   800c5f <sys_yield>
  801afe:	eb e0                	jmp    801ae0 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801b00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b03:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801b07:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801b0a:	89 c2                	mov    %eax,%edx
  801b0c:	c1 fa 1f             	sar    $0x1f,%edx
  801b0f:	89 d1                	mov    %edx,%ecx
  801b11:	c1 e9 1b             	shr    $0x1b,%ecx
  801b14:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801b17:	83 e2 1f             	and    $0x1f,%edx
  801b1a:	29 ca                	sub    %ecx,%edx
  801b1c:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801b20:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801b24:	83 c0 01             	add    $0x1,%eax
  801b27:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801b2a:	83 c7 01             	add    $0x1,%edi
  801b2d:	eb ac                	jmp    801adb <devpipe_write+0x20>
	return i;
  801b2f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b32:	eb 05                	jmp    801b39 <devpipe_write+0x7e>
				return 0;
  801b34:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b3c:	5b                   	pop    %ebx
  801b3d:	5e                   	pop    %esi
  801b3e:	5f                   	pop    %edi
  801b3f:	5d                   	pop    %ebp
  801b40:	c3                   	ret    

00801b41 <devpipe_read>:
{
  801b41:	f3 0f 1e fb          	endbr32 
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
  801b48:	57                   	push   %edi
  801b49:	56                   	push   %esi
  801b4a:	53                   	push   %ebx
  801b4b:	83 ec 18             	sub    $0x18,%esp
  801b4e:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801b51:	57                   	push   %edi
  801b52:	e8 49 f6 ff ff       	call   8011a0 <fd2data>
  801b57:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b59:	83 c4 10             	add    $0x10,%esp
  801b5c:	be 00 00 00 00       	mov    $0x0,%esi
  801b61:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b64:	75 14                	jne    801b7a <devpipe_read+0x39>
	return i;
  801b66:	8b 45 10             	mov    0x10(%ebp),%eax
  801b69:	eb 02                	jmp    801b6d <devpipe_read+0x2c>
				return i;
  801b6b:	89 f0                	mov    %esi,%eax
}
  801b6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b70:	5b                   	pop    %ebx
  801b71:	5e                   	pop    %esi
  801b72:	5f                   	pop    %edi
  801b73:	5d                   	pop    %ebp
  801b74:	c3                   	ret    
			sys_yield();
  801b75:	e8 e5 f0 ff ff       	call   800c5f <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801b7a:	8b 03                	mov    (%ebx),%eax
  801b7c:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b7f:	75 18                	jne    801b99 <devpipe_read+0x58>
			if (i > 0)
  801b81:	85 f6                	test   %esi,%esi
  801b83:	75 e6                	jne    801b6b <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801b85:	89 da                	mov    %ebx,%edx
  801b87:	89 f8                	mov    %edi,%eax
  801b89:	e8 c8 fe ff ff       	call   801a56 <_pipeisclosed>
  801b8e:	85 c0                	test   %eax,%eax
  801b90:	74 e3                	je     801b75 <devpipe_read+0x34>
				return 0;
  801b92:	b8 00 00 00 00       	mov    $0x0,%eax
  801b97:	eb d4                	jmp    801b6d <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801b99:	99                   	cltd   
  801b9a:	c1 ea 1b             	shr    $0x1b,%edx
  801b9d:	01 d0                	add    %edx,%eax
  801b9f:	83 e0 1f             	and    $0x1f,%eax
  801ba2:	29 d0                	sub    %edx,%eax
  801ba4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ba9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bac:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801baf:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801bb2:	83 c6 01             	add    $0x1,%esi
  801bb5:	eb aa                	jmp    801b61 <devpipe_read+0x20>

00801bb7 <pipe>:
{
  801bb7:	f3 0f 1e fb          	endbr32 
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
  801bbe:	56                   	push   %esi
  801bbf:	53                   	push   %ebx
  801bc0:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801bc3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bc6:	50                   	push   %eax
  801bc7:	e8 ef f5 ff ff       	call   8011bb <fd_alloc>
  801bcc:	89 c3                	mov    %eax,%ebx
  801bce:	83 c4 10             	add    $0x10,%esp
  801bd1:	85 c0                	test   %eax,%eax
  801bd3:	0f 88 23 01 00 00    	js     801cfc <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bd9:	83 ec 04             	sub    $0x4,%esp
  801bdc:	68 07 04 00 00       	push   $0x407
  801be1:	ff 75 f4             	pushl  -0xc(%ebp)
  801be4:	6a 00                	push   $0x0
  801be6:	e8 97 f0 ff ff       	call   800c82 <sys_page_alloc>
  801beb:	89 c3                	mov    %eax,%ebx
  801bed:	83 c4 10             	add    $0x10,%esp
  801bf0:	85 c0                	test   %eax,%eax
  801bf2:	0f 88 04 01 00 00    	js     801cfc <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801bf8:	83 ec 0c             	sub    $0xc,%esp
  801bfb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bfe:	50                   	push   %eax
  801bff:	e8 b7 f5 ff ff       	call   8011bb <fd_alloc>
  801c04:	89 c3                	mov    %eax,%ebx
  801c06:	83 c4 10             	add    $0x10,%esp
  801c09:	85 c0                	test   %eax,%eax
  801c0b:	0f 88 db 00 00 00    	js     801cec <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c11:	83 ec 04             	sub    $0x4,%esp
  801c14:	68 07 04 00 00       	push   $0x407
  801c19:	ff 75 f0             	pushl  -0x10(%ebp)
  801c1c:	6a 00                	push   $0x0
  801c1e:	e8 5f f0 ff ff       	call   800c82 <sys_page_alloc>
  801c23:	89 c3                	mov    %eax,%ebx
  801c25:	83 c4 10             	add    $0x10,%esp
  801c28:	85 c0                	test   %eax,%eax
  801c2a:	0f 88 bc 00 00 00    	js     801cec <pipe+0x135>
	va = fd2data(fd0);
  801c30:	83 ec 0c             	sub    $0xc,%esp
  801c33:	ff 75 f4             	pushl  -0xc(%ebp)
  801c36:	e8 65 f5 ff ff       	call   8011a0 <fd2data>
  801c3b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c3d:	83 c4 0c             	add    $0xc,%esp
  801c40:	68 07 04 00 00       	push   $0x407
  801c45:	50                   	push   %eax
  801c46:	6a 00                	push   $0x0
  801c48:	e8 35 f0 ff ff       	call   800c82 <sys_page_alloc>
  801c4d:	89 c3                	mov    %eax,%ebx
  801c4f:	83 c4 10             	add    $0x10,%esp
  801c52:	85 c0                	test   %eax,%eax
  801c54:	0f 88 82 00 00 00    	js     801cdc <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c5a:	83 ec 0c             	sub    $0xc,%esp
  801c5d:	ff 75 f0             	pushl  -0x10(%ebp)
  801c60:	e8 3b f5 ff ff       	call   8011a0 <fd2data>
  801c65:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801c6c:	50                   	push   %eax
  801c6d:	6a 00                	push   $0x0
  801c6f:	56                   	push   %esi
  801c70:	6a 00                	push   $0x0
  801c72:	e8 52 f0 ff ff       	call   800cc9 <sys_page_map>
  801c77:	89 c3                	mov    %eax,%ebx
  801c79:	83 c4 20             	add    $0x20,%esp
  801c7c:	85 c0                	test   %eax,%eax
  801c7e:	78 4e                	js     801cce <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801c80:	a1 20 30 80 00       	mov    0x803020,%eax
  801c85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c88:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801c8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c8d:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801c94:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c97:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801c99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c9c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801ca3:	83 ec 0c             	sub    $0xc,%esp
  801ca6:	ff 75 f4             	pushl  -0xc(%ebp)
  801ca9:	e8 de f4 ff ff       	call   80118c <fd2num>
  801cae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cb1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801cb3:	83 c4 04             	add    $0x4,%esp
  801cb6:	ff 75 f0             	pushl  -0x10(%ebp)
  801cb9:	e8 ce f4 ff ff       	call   80118c <fd2num>
  801cbe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cc1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801cc4:	83 c4 10             	add    $0x10,%esp
  801cc7:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ccc:	eb 2e                	jmp    801cfc <pipe+0x145>
	sys_page_unmap(0, va);
  801cce:	83 ec 08             	sub    $0x8,%esp
  801cd1:	56                   	push   %esi
  801cd2:	6a 00                	push   $0x0
  801cd4:	e8 36 f0 ff ff       	call   800d0f <sys_page_unmap>
  801cd9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801cdc:	83 ec 08             	sub    $0x8,%esp
  801cdf:	ff 75 f0             	pushl  -0x10(%ebp)
  801ce2:	6a 00                	push   $0x0
  801ce4:	e8 26 f0 ff ff       	call   800d0f <sys_page_unmap>
  801ce9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801cec:	83 ec 08             	sub    $0x8,%esp
  801cef:	ff 75 f4             	pushl  -0xc(%ebp)
  801cf2:	6a 00                	push   $0x0
  801cf4:	e8 16 f0 ff ff       	call   800d0f <sys_page_unmap>
  801cf9:	83 c4 10             	add    $0x10,%esp
}
  801cfc:	89 d8                	mov    %ebx,%eax
  801cfe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d01:	5b                   	pop    %ebx
  801d02:	5e                   	pop    %esi
  801d03:	5d                   	pop    %ebp
  801d04:	c3                   	ret    

00801d05 <pipeisclosed>:
{
  801d05:	f3 0f 1e fb          	endbr32 
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
  801d0c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d0f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d12:	50                   	push   %eax
  801d13:	ff 75 08             	pushl  0x8(%ebp)
  801d16:	e8 f6 f4 ff ff       	call   801211 <fd_lookup>
  801d1b:	83 c4 10             	add    $0x10,%esp
  801d1e:	85 c0                	test   %eax,%eax
  801d20:	78 18                	js     801d3a <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801d22:	83 ec 0c             	sub    $0xc,%esp
  801d25:	ff 75 f4             	pushl  -0xc(%ebp)
  801d28:	e8 73 f4 ff ff       	call   8011a0 <fd2data>
  801d2d:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d32:	e8 1f fd ff ff       	call   801a56 <_pipeisclosed>
  801d37:	83 c4 10             	add    $0x10,%esp
}
  801d3a:	c9                   	leave  
  801d3b:	c3                   	ret    

00801d3c <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801d3c:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801d40:	b8 00 00 00 00       	mov    $0x0,%eax
  801d45:	c3                   	ret    

00801d46 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801d46:	f3 0f 1e fb          	endbr32 
  801d4a:	55                   	push   %ebp
  801d4b:	89 e5                	mov    %esp,%ebp
  801d4d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801d50:	68 5a 28 80 00       	push   $0x80285a
  801d55:	ff 75 0c             	pushl  0xc(%ebp)
  801d58:	e8 e3 ea ff ff       	call   800840 <strcpy>
	return 0;
}
  801d5d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d62:	c9                   	leave  
  801d63:	c3                   	ret    

00801d64 <devcons_write>:
{
  801d64:	f3 0f 1e fb          	endbr32 
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
  801d6b:	57                   	push   %edi
  801d6c:	56                   	push   %esi
  801d6d:	53                   	push   %ebx
  801d6e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801d74:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801d79:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801d7f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d82:	73 31                	jae    801db5 <devcons_write+0x51>
		m = n - tot;
  801d84:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d87:	29 f3                	sub    %esi,%ebx
  801d89:	83 fb 7f             	cmp    $0x7f,%ebx
  801d8c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801d91:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801d94:	83 ec 04             	sub    $0x4,%esp
  801d97:	53                   	push   %ebx
  801d98:	89 f0                	mov    %esi,%eax
  801d9a:	03 45 0c             	add    0xc(%ebp),%eax
  801d9d:	50                   	push   %eax
  801d9e:	57                   	push   %edi
  801d9f:	e8 52 ec ff ff       	call   8009f6 <memmove>
		sys_cputs(buf, m);
  801da4:	83 c4 08             	add    $0x8,%esp
  801da7:	53                   	push   %ebx
  801da8:	57                   	push   %edi
  801da9:	e8 04 ee ff ff       	call   800bb2 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801dae:	01 de                	add    %ebx,%esi
  801db0:	83 c4 10             	add    $0x10,%esp
  801db3:	eb ca                	jmp    801d7f <devcons_write+0x1b>
}
  801db5:	89 f0                	mov    %esi,%eax
  801db7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dba:	5b                   	pop    %ebx
  801dbb:	5e                   	pop    %esi
  801dbc:	5f                   	pop    %edi
  801dbd:	5d                   	pop    %ebp
  801dbe:	c3                   	ret    

00801dbf <devcons_read>:
{
  801dbf:	f3 0f 1e fb          	endbr32 
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
  801dc6:	83 ec 08             	sub    $0x8,%esp
  801dc9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801dce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801dd2:	74 21                	je     801df5 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801dd4:	e8 fb ed ff ff       	call   800bd4 <sys_cgetc>
  801dd9:	85 c0                	test   %eax,%eax
  801ddb:	75 07                	jne    801de4 <devcons_read+0x25>
		sys_yield();
  801ddd:	e8 7d ee ff ff       	call   800c5f <sys_yield>
  801de2:	eb f0                	jmp    801dd4 <devcons_read+0x15>
	if (c < 0)
  801de4:	78 0f                	js     801df5 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801de6:	83 f8 04             	cmp    $0x4,%eax
  801de9:	74 0c                	je     801df7 <devcons_read+0x38>
	*(char*)vbuf = c;
  801deb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dee:	88 02                	mov    %al,(%edx)
	return 1;
  801df0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801df5:	c9                   	leave  
  801df6:	c3                   	ret    
		return 0;
  801df7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dfc:	eb f7                	jmp    801df5 <devcons_read+0x36>

00801dfe <cputchar>:
{
  801dfe:	f3 0f 1e fb          	endbr32 
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
  801e05:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801e08:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0b:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801e0e:	6a 01                	push   $0x1
  801e10:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e13:	50                   	push   %eax
  801e14:	e8 99 ed ff ff       	call   800bb2 <sys_cputs>
}
  801e19:	83 c4 10             	add    $0x10,%esp
  801e1c:	c9                   	leave  
  801e1d:	c3                   	ret    

00801e1e <getchar>:
{
  801e1e:	f3 0f 1e fb          	endbr32 
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
  801e25:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801e28:	6a 01                	push   $0x1
  801e2a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e2d:	50                   	push   %eax
  801e2e:	6a 00                	push   $0x0
  801e30:	e8 5f f6 ff ff       	call   801494 <read>
	if (r < 0)
  801e35:	83 c4 10             	add    $0x10,%esp
  801e38:	85 c0                	test   %eax,%eax
  801e3a:	78 06                	js     801e42 <getchar+0x24>
	if (r < 1)
  801e3c:	74 06                	je     801e44 <getchar+0x26>
	return c;
  801e3e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801e42:	c9                   	leave  
  801e43:	c3                   	ret    
		return -E_EOF;
  801e44:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801e49:	eb f7                	jmp    801e42 <getchar+0x24>

00801e4b <iscons>:
{
  801e4b:	f3 0f 1e fb          	endbr32 
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
  801e52:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e55:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e58:	50                   	push   %eax
  801e59:	ff 75 08             	pushl  0x8(%ebp)
  801e5c:	e8 b0 f3 ff ff       	call   801211 <fd_lookup>
  801e61:	83 c4 10             	add    $0x10,%esp
  801e64:	85 c0                	test   %eax,%eax
  801e66:	78 11                	js     801e79 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e71:	39 10                	cmp    %edx,(%eax)
  801e73:	0f 94 c0             	sete   %al
  801e76:	0f b6 c0             	movzbl %al,%eax
}
  801e79:	c9                   	leave  
  801e7a:	c3                   	ret    

00801e7b <opencons>:
{
  801e7b:	f3 0f 1e fb          	endbr32 
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
  801e82:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801e85:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e88:	50                   	push   %eax
  801e89:	e8 2d f3 ff ff       	call   8011bb <fd_alloc>
  801e8e:	83 c4 10             	add    $0x10,%esp
  801e91:	85 c0                	test   %eax,%eax
  801e93:	78 3a                	js     801ecf <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e95:	83 ec 04             	sub    $0x4,%esp
  801e98:	68 07 04 00 00       	push   $0x407
  801e9d:	ff 75 f4             	pushl  -0xc(%ebp)
  801ea0:	6a 00                	push   $0x0
  801ea2:	e8 db ed ff ff       	call   800c82 <sys_page_alloc>
  801ea7:	83 c4 10             	add    $0x10,%esp
  801eaa:	85 c0                	test   %eax,%eax
  801eac:	78 21                	js     801ecf <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb1:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801eb7:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801ec3:	83 ec 0c             	sub    $0xc,%esp
  801ec6:	50                   	push   %eax
  801ec7:	e8 c0 f2 ff ff       	call   80118c <fd2num>
  801ecc:	83 c4 10             	add    $0x10,%esp
}
  801ecf:	c9                   	leave  
  801ed0:	c3                   	ret    

00801ed1 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801ed1:	f3 0f 1e fb          	endbr32 
  801ed5:	55                   	push   %ebp
  801ed6:	89 e5                	mov    %esp,%ebp
  801ed8:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801edb:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801ee2:	74 0a                	je     801eee <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee7:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801eec:	c9                   	leave  
  801eed:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  801eee:	83 ec 04             	sub    $0x4,%esp
  801ef1:	6a 07                	push   $0x7
  801ef3:	68 00 f0 bf ee       	push   $0xeebff000
  801ef8:	6a 00                	push   $0x0
  801efa:	e8 83 ed ff ff       	call   800c82 <sys_page_alloc>
  801eff:	83 c4 10             	add    $0x10,%esp
  801f02:	85 c0                	test   %eax,%eax
  801f04:	78 2a                	js     801f30 <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  801f06:	83 ec 08             	sub    $0x8,%esp
  801f09:	68 44 1f 80 00       	push   $0x801f44
  801f0e:	6a 00                	push   $0x0
  801f10:	e8 cc ee ff ff       	call   800de1 <sys_env_set_pgfault_upcall>
  801f15:	83 c4 10             	add    $0x10,%esp
  801f18:	85 c0                	test   %eax,%eax
  801f1a:	79 c8                	jns    801ee4 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  801f1c:	83 ec 04             	sub    $0x4,%esp
  801f1f:	68 94 28 80 00       	push   $0x802894
  801f24:	6a 25                	push   $0x25
  801f26:	68 cc 28 80 00       	push   $0x8028cc
  801f2b:	e8 1f e2 ff ff       	call   80014f <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  801f30:	83 ec 04             	sub    $0x4,%esp
  801f33:	68 68 28 80 00       	push   $0x802868
  801f38:	6a 22                	push   $0x22
  801f3a:	68 cc 28 80 00       	push   $0x8028cc
  801f3f:	e8 0b e2 ff ff       	call   80014f <_panic>

00801f44 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801f44:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801f45:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  801f4a:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801f4c:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  801f4f:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  801f53:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  801f57:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  801f5a:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  801f5c:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  801f60:	83 c4 08             	add    $0x8,%esp
	popal
  801f63:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  801f64:	83 c4 04             	add    $0x4,%esp
	popfl
  801f67:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  801f68:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  801f69:	c3                   	ret    

00801f6a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f6a:	f3 0f 1e fb          	endbr32 
  801f6e:	55                   	push   %ebp
  801f6f:	89 e5                	mov    %esp,%ebp
  801f71:	56                   	push   %esi
  801f72:	53                   	push   %ebx
  801f73:	8b 75 08             	mov    0x8(%ebp),%esi
  801f76:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f79:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  801f7c:	85 c0                	test   %eax,%eax
  801f7e:	74 3d                	je     801fbd <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  801f80:	83 ec 0c             	sub    $0xc,%esp
  801f83:	50                   	push   %eax
  801f84:	e8 c5 ee ff ff       	call   800e4e <sys_ipc_recv>
  801f89:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  801f8c:	85 f6                	test   %esi,%esi
  801f8e:	74 0b                	je     801f9b <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801f90:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f96:	8b 52 74             	mov    0x74(%edx),%edx
  801f99:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801f9b:	85 db                	test   %ebx,%ebx
  801f9d:	74 0b                	je     801faa <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  801f9f:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801fa5:	8b 52 78             	mov    0x78(%edx),%edx
  801fa8:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  801faa:	85 c0                	test   %eax,%eax
  801fac:	78 21                	js     801fcf <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  801fae:	a1 08 40 80 00       	mov    0x804008,%eax
  801fb3:	8b 40 70             	mov    0x70(%eax),%eax
}
  801fb6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fb9:	5b                   	pop    %ebx
  801fba:	5e                   	pop    %esi
  801fbb:	5d                   	pop    %ebp
  801fbc:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  801fbd:	83 ec 0c             	sub    $0xc,%esp
  801fc0:	68 00 00 c0 ee       	push   $0xeec00000
  801fc5:	e8 84 ee ff ff       	call   800e4e <sys_ipc_recv>
  801fca:	83 c4 10             	add    $0x10,%esp
  801fcd:	eb bd                	jmp    801f8c <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  801fcf:	85 f6                	test   %esi,%esi
  801fd1:	74 10                	je     801fe3 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  801fd3:	85 db                	test   %ebx,%ebx
  801fd5:	75 df                	jne    801fb6 <ipc_recv+0x4c>
  801fd7:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801fde:	00 00 00 
  801fe1:	eb d3                	jmp    801fb6 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  801fe3:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801fea:	00 00 00 
  801fed:	eb e4                	jmp    801fd3 <ipc_recv+0x69>

00801fef <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801fef:	f3 0f 1e fb          	endbr32 
  801ff3:	55                   	push   %ebp
  801ff4:	89 e5                	mov    %esp,%ebp
  801ff6:	57                   	push   %edi
  801ff7:	56                   	push   %esi
  801ff8:	53                   	push   %ebx
  801ff9:	83 ec 0c             	sub    $0xc,%esp
  801ffc:	8b 7d 08             	mov    0x8(%ebp),%edi
  801fff:	8b 75 0c             	mov    0xc(%ebp),%esi
  802002:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  802005:	85 db                	test   %ebx,%ebx
  802007:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80200c:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  80200f:	ff 75 14             	pushl  0x14(%ebp)
  802012:	53                   	push   %ebx
  802013:	56                   	push   %esi
  802014:	57                   	push   %edi
  802015:	e8 0d ee ff ff       	call   800e27 <sys_ipc_try_send>
  80201a:	83 c4 10             	add    $0x10,%esp
  80201d:	85 c0                	test   %eax,%eax
  80201f:	79 1e                	jns    80203f <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  802021:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802024:	75 07                	jne    80202d <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  802026:	e8 34 ec ff ff       	call   800c5f <sys_yield>
  80202b:	eb e2                	jmp    80200f <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  80202d:	50                   	push   %eax
  80202e:	68 da 28 80 00       	push   $0x8028da
  802033:	6a 59                	push   $0x59
  802035:	68 f5 28 80 00       	push   $0x8028f5
  80203a:	e8 10 e1 ff ff       	call   80014f <_panic>
	}
}
  80203f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802042:	5b                   	pop    %ebx
  802043:	5e                   	pop    %esi
  802044:	5f                   	pop    %edi
  802045:	5d                   	pop    %ebp
  802046:	c3                   	ret    

00802047 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802047:	f3 0f 1e fb          	endbr32 
  80204b:	55                   	push   %ebp
  80204c:	89 e5                	mov    %esp,%ebp
  80204e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802051:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802056:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802059:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80205f:	8b 52 50             	mov    0x50(%edx),%edx
  802062:	39 ca                	cmp    %ecx,%edx
  802064:	74 11                	je     802077 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802066:	83 c0 01             	add    $0x1,%eax
  802069:	3d 00 04 00 00       	cmp    $0x400,%eax
  80206e:	75 e6                	jne    802056 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802070:	b8 00 00 00 00       	mov    $0x0,%eax
  802075:	eb 0b                	jmp    802082 <ipc_find_env+0x3b>
			return envs[i].env_id;
  802077:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80207a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80207f:	8b 40 48             	mov    0x48(%eax),%eax
}
  802082:	5d                   	pop    %ebp
  802083:	c3                   	ret    

00802084 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802084:	f3 0f 1e fb          	endbr32 
  802088:	55                   	push   %ebp
  802089:	89 e5                	mov    %esp,%ebp
  80208b:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80208e:	89 c2                	mov    %eax,%edx
  802090:	c1 ea 16             	shr    $0x16,%edx
  802093:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80209a:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  80209f:	f6 c1 01             	test   $0x1,%cl
  8020a2:	74 1c                	je     8020c0 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8020a4:	c1 e8 0c             	shr    $0xc,%eax
  8020a7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8020ae:	a8 01                	test   $0x1,%al
  8020b0:	74 0e                	je     8020c0 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020b2:	c1 e8 0c             	shr    $0xc,%eax
  8020b5:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8020bc:	ef 
  8020bd:	0f b7 d2             	movzwl %dx,%edx
}
  8020c0:	89 d0                	mov    %edx,%eax
  8020c2:	5d                   	pop    %ebp
  8020c3:	c3                   	ret    
  8020c4:	66 90                	xchg   %ax,%ax
  8020c6:	66 90                	xchg   %ax,%ax
  8020c8:	66 90                	xchg   %ax,%ax
  8020ca:	66 90                	xchg   %ax,%ax
  8020cc:	66 90                	xchg   %ax,%ax
  8020ce:	66 90                	xchg   %ax,%ax

008020d0 <__udivdi3>:
  8020d0:	f3 0f 1e fb          	endbr32 
  8020d4:	55                   	push   %ebp
  8020d5:	57                   	push   %edi
  8020d6:	56                   	push   %esi
  8020d7:	53                   	push   %ebx
  8020d8:	83 ec 1c             	sub    $0x1c,%esp
  8020db:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8020df:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8020e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8020e7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8020eb:	85 d2                	test   %edx,%edx
  8020ed:	75 19                	jne    802108 <__udivdi3+0x38>
  8020ef:	39 f3                	cmp    %esi,%ebx
  8020f1:	76 4d                	jbe    802140 <__udivdi3+0x70>
  8020f3:	31 ff                	xor    %edi,%edi
  8020f5:	89 e8                	mov    %ebp,%eax
  8020f7:	89 f2                	mov    %esi,%edx
  8020f9:	f7 f3                	div    %ebx
  8020fb:	89 fa                	mov    %edi,%edx
  8020fd:	83 c4 1c             	add    $0x1c,%esp
  802100:	5b                   	pop    %ebx
  802101:	5e                   	pop    %esi
  802102:	5f                   	pop    %edi
  802103:	5d                   	pop    %ebp
  802104:	c3                   	ret    
  802105:	8d 76 00             	lea    0x0(%esi),%esi
  802108:	39 f2                	cmp    %esi,%edx
  80210a:	76 14                	jbe    802120 <__udivdi3+0x50>
  80210c:	31 ff                	xor    %edi,%edi
  80210e:	31 c0                	xor    %eax,%eax
  802110:	89 fa                	mov    %edi,%edx
  802112:	83 c4 1c             	add    $0x1c,%esp
  802115:	5b                   	pop    %ebx
  802116:	5e                   	pop    %esi
  802117:	5f                   	pop    %edi
  802118:	5d                   	pop    %ebp
  802119:	c3                   	ret    
  80211a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802120:	0f bd fa             	bsr    %edx,%edi
  802123:	83 f7 1f             	xor    $0x1f,%edi
  802126:	75 48                	jne    802170 <__udivdi3+0xa0>
  802128:	39 f2                	cmp    %esi,%edx
  80212a:	72 06                	jb     802132 <__udivdi3+0x62>
  80212c:	31 c0                	xor    %eax,%eax
  80212e:	39 eb                	cmp    %ebp,%ebx
  802130:	77 de                	ja     802110 <__udivdi3+0x40>
  802132:	b8 01 00 00 00       	mov    $0x1,%eax
  802137:	eb d7                	jmp    802110 <__udivdi3+0x40>
  802139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802140:	89 d9                	mov    %ebx,%ecx
  802142:	85 db                	test   %ebx,%ebx
  802144:	75 0b                	jne    802151 <__udivdi3+0x81>
  802146:	b8 01 00 00 00       	mov    $0x1,%eax
  80214b:	31 d2                	xor    %edx,%edx
  80214d:	f7 f3                	div    %ebx
  80214f:	89 c1                	mov    %eax,%ecx
  802151:	31 d2                	xor    %edx,%edx
  802153:	89 f0                	mov    %esi,%eax
  802155:	f7 f1                	div    %ecx
  802157:	89 c6                	mov    %eax,%esi
  802159:	89 e8                	mov    %ebp,%eax
  80215b:	89 f7                	mov    %esi,%edi
  80215d:	f7 f1                	div    %ecx
  80215f:	89 fa                	mov    %edi,%edx
  802161:	83 c4 1c             	add    $0x1c,%esp
  802164:	5b                   	pop    %ebx
  802165:	5e                   	pop    %esi
  802166:	5f                   	pop    %edi
  802167:	5d                   	pop    %ebp
  802168:	c3                   	ret    
  802169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802170:	89 f9                	mov    %edi,%ecx
  802172:	b8 20 00 00 00       	mov    $0x20,%eax
  802177:	29 f8                	sub    %edi,%eax
  802179:	d3 e2                	shl    %cl,%edx
  80217b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80217f:	89 c1                	mov    %eax,%ecx
  802181:	89 da                	mov    %ebx,%edx
  802183:	d3 ea                	shr    %cl,%edx
  802185:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802189:	09 d1                	or     %edx,%ecx
  80218b:	89 f2                	mov    %esi,%edx
  80218d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802191:	89 f9                	mov    %edi,%ecx
  802193:	d3 e3                	shl    %cl,%ebx
  802195:	89 c1                	mov    %eax,%ecx
  802197:	d3 ea                	shr    %cl,%edx
  802199:	89 f9                	mov    %edi,%ecx
  80219b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80219f:	89 eb                	mov    %ebp,%ebx
  8021a1:	d3 e6                	shl    %cl,%esi
  8021a3:	89 c1                	mov    %eax,%ecx
  8021a5:	d3 eb                	shr    %cl,%ebx
  8021a7:	09 de                	or     %ebx,%esi
  8021a9:	89 f0                	mov    %esi,%eax
  8021ab:	f7 74 24 08          	divl   0x8(%esp)
  8021af:	89 d6                	mov    %edx,%esi
  8021b1:	89 c3                	mov    %eax,%ebx
  8021b3:	f7 64 24 0c          	mull   0xc(%esp)
  8021b7:	39 d6                	cmp    %edx,%esi
  8021b9:	72 15                	jb     8021d0 <__udivdi3+0x100>
  8021bb:	89 f9                	mov    %edi,%ecx
  8021bd:	d3 e5                	shl    %cl,%ebp
  8021bf:	39 c5                	cmp    %eax,%ebp
  8021c1:	73 04                	jae    8021c7 <__udivdi3+0xf7>
  8021c3:	39 d6                	cmp    %edx,%esi
  8021c5:	74 09                	je     8021d0 <__udivdi3+0x100>
  8021c7:	89 d8                	mov    %ebx,%eax
  8021c9:	31 ff                	xor    %edi,%edi
  8021cb:	e9 40 ff ff ff       	jmp    802110 <__udivdi3+0x40>
  8021d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021d3:	31 ff                	xor    %edi,%edi
  8021d5:	e9 36 ff ff ff       	jmp    802110 <__udivdi3+0x40>
  8021da:	66 90                	xchg   %ax,%ax
  8021dc:	66 90                	xchg   %ax,%ax
  8021de:	66 90                	xchg   %ax,%ax

008021e0 <__umoddi3>:
  8021e0:	f3 0f 1e fb          	endbr32 
  8021e4:	55                   	push   %ebp
  8021e5:	57                   	push   %edi
  8021e6:	56                   	push   %esi
  8021e7:	53                   	push   %ebx
  8021e8:	83 ec 1c             	sub    $0x1c,%esp
  8021eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8021ef:	8b 74 24 30          	mov    0x30(%esp),%esi
  8021f3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8021f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021fb:	85 c0                	test   %eax,%eax
  8021fd:	75 19                	jne    802218 <__umoddi3+0x38>
  8021ff:	39 df                	cmp    %ebx,%edi
  802201:	76 5d                	jbe    802260 <__umoddi3+0x80>
  802203:	89 f0                	mov    %esi,%eax
  802205:	89 da                	mov    %ebx,%edx
  802207:	f7 f7                	div    %edi
  802209:	89 d0                	mov    %edx,%eax
  80220b:	31 d2                	xor    %edx,%edx
  80220d:	83 c4 1c             	add    $0x1c,%esp
  802210:	5b                   	pop    %ebx
  802211:	5e                   	pop    %esi
  802212:	5f                   	pop    %edi
  802213:	5d                   	pop    %ebp
  802214:	c3                   	ret    
  802215:	8d 76 00             	lea    0x0(%esi),%esi
  802218:	89 f2                	mov    %esi,%edx
  80221a:	39 d8                	cmp    %ebx,%eax
  80221c:	76 12                	jbe    802230 <__umoddi3+0x50>
  80221e:	89 f0                	mov    %esi,%eax
  802220:	89 da                	mov    %ebx,%edx
  802222:	83 c4 1c             	add    $0x1c,%esp
  802225:	5b                   	pop    %ebx
  802226:	5e                   	pop    %esi
  802227:	5f                   	pop    %edi
  802228:	5d                   	pop    %ebp
  802229:	c3                   	ret    
  80222a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802230:	0f bd e8             	bsr    %eax,%ebp
  802233:	83 f5 1f             	xor    $0x1f,%ebp
  802236:	75 50                	jne    802288 <__umoddi3+0xa8>
  802238:	39 d8                	cmp    %ebx,%eax
  80223a:	0f 82 e0 00 00 00    	jb     802320 <__umoddi3+0x140>
  802240:	89 d9                	mov    %ebx,%ecx
  802242:	39 f7                	cmp    %esi,%edi
  802244:	0f 86 d6 00 00 00    	jbe    802320 <__umoddi3+0x140>
  80224a:	89 d0                	mov    %edx,%eax
  80224c:	89 ca                	mov    %ecx,%edx
  80224e:	83 c4 1c             	add    $0x1c,%esp
  802251:	5b                   	pop    %ebx
  802252:	5e                   	pop    %esi
  802253:	5f                   	pop    %edi
  802254:	5d                   	pop    %ebp
  802255:	c3                   	ret    
  802256:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80225d:	8d 76 00             	lea    0x0(%esi),%esi
  802260:	89 fd                	mov    %edi,%ebp
  802262:	85 ff                	test   %edi,%edi
  802264:	75 0b                	jne    802271 <__umoddi3+0x91>
  802266:	b8 01 00 00 00       	mov    $0x1,%eax
  80226b:	31 d2                	xor    %edx,%edx
  80226d:	f7 f7                	div    %edi
  80226f:	89 c5                	mov    %eax,%ebp
  802271:	89 d8                	mov    %ebx,%eax
  802273:	31 d2                	xor    %edx,%edx
  802275:	f7 f5                	div    %ebp
  802277:	89 f0                	mov    %esi,%eax
  802279:	f7 f5                	div    %ebp
  80227b:	89 d0                	mov    %edx,%eax
  80227d:	31 d2                	xor    %edx,%edx
  80227f:	eb 8c                	jmp    80220d <__umoddi3+0x2d>
  802281:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802288:	89 e9                	mov    %ebp,%ecx
  80228a:	ba 20 00 00 00       	mov    $0x20,%edx
  80228f:	29 ea                	sub    %ebp,%edx
  802291:	d3 e0                	shl    %cl,%eax
  802293:	89 44 24 08          	mov    %eax,0x8(%esp)
  802297:	89 d1                	mov    %edx,%ecx
  802299:	89 f8                	mov    %edi,%eax
  80229b:	d3 e8                	shr    %cl,%eax
  80229d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8022a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022a5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8022a9:	09 c1                	or     %eax,%ecx
  8022ab:	89 d8                	mov    %ebx,%eax
  8022ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022b1:	89 e9                	mov    %ebp,%ecx
  8022b3:	d3 e7                	shl    %cl,%edi
  8022b5:	89 d1                	mov    %edx,%ecx
  8022b7:	d3 e8                	shr    %cl,%eax
  8022b9:	89 e9                	mov    %ebp,%ecx
  8022bb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8022bf:	d3 e3                	shl    %cl,%ebx
  8022c1:	89 c7                	mov    %eax,%edi
  8022c3:	89 d1                	mov    %edx,%ecx
  8022c5:	89 f0                	mov    %esi,%eax
  8022c7:	d3 e8                	shr    %cl,%eax
  8022c9:	89 e9                	mov    %ebp,%ecx
  8022cb:	89 fa                	mov    %edi,%edx
  8022cd:	d3 e6                	shl    %cl,%esi
  8022cf:	09 d8                	or     %ebx,%eax
  8022d1:	f7 74 24 08          	divl   0x8(%esp)
  8022d5:	89 d1                	mov    %edx,%ecx
  8022d7:	89 f3                	mov    %esi,%ebx
  8022d9:	f7 64 24 0c          	mull   0xc(%esp)
  8022dd:	89 c6                	mov    %eax,%esi
  8022df:	89 d7                	mov    %edx,%edi
  8022e1:	39 d1                	cmp    %edx,%ecx
  8022e3:	72 06                	jb     8022eb <__umoddi3+0x10b>
  8022e5:	75 10                	jne    8022f7 <__umoddi3+0x117>
  8022e7:	39 c3                	cmp    %eax,%ebx
  8022e9:	73 0c                	jae    8022f7 <__umoddi3+0x117>
  8022eb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8022ef:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8022f3:	89 d7                	mov    %edx,%edi
  8022f5:	89 c6                	mov    %eax,%esi
  8022f7:	89 ca                	mov    %ecx,%edx
  8022f9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8022fe:	29 f3                	sub    %esi,%ebx
  802300:	19 fa                	sbb    %edi,%edx
  802302:	89 d0                	mov    %edx,%eax
  802304:	d3 e0                	shl    %cl,%eax
  802306:	89 e9                	mov    %ebp,%ecx
  802308:	d3 eb                	shr    %cl,%ebx
  80230a:	d3 ea                	shr    %cl,%edx
  80230c:	09 d8                	or     %ebx,%eax
  80230e:	83 c4 1c             	add    $0x1c,%esp
  802311:	5b                   	pop    %ebx
  802312:	5e                   	pop    %esi
  802313:	5f                   	pop    %edi
  802314:	5d                   	pop    %ebp
  802315:	c3                   	ret    
  802316:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80231d:	8d 76 00             	lea    0x0(%esi),%esi
  802320:	29 fe                	sub    %edi,%esi
  802322:	19 c3                	sbb    %eax,%ebx
  802324:	89 f2                	mov    %esi,%edx
  802326:	89 d9                	mov    %ebx,%ecx
  802328:	e9 1d ff ff ff       	jmp    80224a <__umoddi3+0x6a>
