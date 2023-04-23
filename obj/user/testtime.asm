
obj/user/testtime.debug:     file format elf32-i386


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
  80002c:	e8 cb 00 00 00       	call   8000fc <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <sleep>:
#include <inc/lib.h>
#include <inc/x86.h>

void
sleep(int sec)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	53                   	push   %ebx
  80003b:	83 ec 04             	sub    $0x4,%esp
	unsigned now = sys_time_msec();
  80003e:	e8 65 0e 00 00       	call   800ea8 <sys_time_msec>
	unsigned end = now + sec * 1000;
  800043:	69 5d 08 e8 03 00 00 	imul   $0x3e8,0x8(%ebp),%ebx
  80004a:	01 c3                	add    %eax,%ebx

	if ((int)now < 0 && (int)now > -MAXERROR)
  80004c:	85 c0                	test   %eax,%eax
  80004e:	79 05                	jns    800055 <sleep+0x22>
  800050:	83 f8 f1             	cmp    $0xfffffff1,%eax
  800053:	7d 18                	jge    80006d <sleep+0x3a>
		panic("sys_time_msec: %e", (int)now);
	if (end < now)
  800055:	39 d8                	cmp    %ebx,%eax
  800057:	76 2b                	jbe    800084 <sleep+0x51>
		panic("sleep: wrap");
  800059:	83 ec 04             	sub    $0x4,%esp
  80005c:	68 42 25 80 00       	push   $0x802542
  800061:	6a 0d                	push   $0xd
  800063:	68 32 25 80 00       	push   $0x802532
  800068:	e8 f7 00 00 00       	call   800164 <_panic>
		panic("sys_time_msec: %e", (int)now);
  80006d:	50                   	push   %eax
  80006e:	68 20 25 80 00       	push   $0x802520
  800073:	6a 0b                	push   $0xb
  800075:	68 32 25 80 00       	push   $0x802532
  80007a:	e8 e5 00 00 00       	call   800164 <_panic>

	while (sys_time_msec() < end)
		sys_yield();
  80007f:	e8 f0 0b 00 00       	call   800c74 <sys_yield>
	while (sys_time_msec() < end)
  800084:	e8 1f 0e 00 00       	call   800ea8 <sys_time_msec>
  800089:	39 d8                	cmp    %ebx,%eax
  80008b:	72 f2                	jb     80007f <sleep+0x4c>
}
  80008d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800090:	c9                   	leave  
  800091:	c3                   	ret    

00800092 <umain>:

void
umain(int argc, char **argv)
{
  800092:	f3 0f 1e fb          	endbr32 
  800096:	55                   	push   %ebp
  800097:	89 e5                	mov    %esp,%ebp
  800099:	53                   	push   %ebx
  80009a:	83 ec 04             	sub    $0x4,%esp
  80009d:	bb 32 00 00 00       	mov    $0x32,%ebx
	int i;

	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
		sys_yield();
  8000a2:	e8 cd 0b 00 00       	call   800c74 <sys_yield>
	for (i = 0; i < 50; i++)
  8000a7:	83 eb 01             	sub    $0x1,%ebx
  8000aa:	75 f6                	jne    8000a2 <umain+0x10>

	cprintf("starting count down: ");
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	68 4e 25 80 00       	push   $0x80254e
  8000b4:	e8 92 01 00 00       	call   80024b <cprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
	for (i = 5; i >= 0; i--) {
  8000bc:	bb 05 00 00 00       	mov    $0x5,%ebx
		cprintf("%d ", i);
  8000c1:	83 ec 08             	sub    $0x8,%esp
  8000c4:	53                   	push   %ebx
  8000c5:	68 64 25 80 00       	push   $0x802564
  8000ca:	e8 7c 01 00 00       	call   80024b <cprintf>
		sleep(1);
  8000cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000d6:	e8 58 ff ff ff       	call   800033 <sleep>
	for (i = 5; i >= 0; i--) {
  8000db:	83 eb 01             	sub    $0x1,%ebx
  8000de:	83 c4 10             	add    $0x10,%esp
  8000e1:	83 fb ff             	cmp    $0xffffffff,%ebx
  8000e4:	75 db                	jne    8000c1 <umain+0x2f>
	}
	cprintf("\n");
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 0c 2a 80 00       	push   $0x802a0c
  8000ee:	e8 58 01 00 00       	call   80024b <cprintf>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  8000f3:	cc                   	int3   
	breakpoint();
}
  8000f4:	83 c4 10             	add    $0x10,%esp
  8000f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000fa:	c9                   	leave  
  8000fb:	c3                   	ret    

008000fc <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000fc:	f3 0f 1e fb          	endbr32 
  800100:	55                   	push   %ebp
  800101:	89 e5                	mov    %esp,%ebp
  800103:	56                   	push   %esi
  800104:	53                   	push   %ebx
  800105:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800108:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80010b:	e8 41 0b 00 00       	call   800c51 <sys_getenvid>
  800110:	25 ff 03 00 00       	and    $0x3ff,%eax
  800115:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800118:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80011d:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800122:	85 db                	test   %ebx,%ebx
  800124:	7e 07                	jle    80012d <libmain+0x31>
		binaryname = argv[0];
  800126:	8b 06                	mov    (%esi),%eax
  800128:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80012d:	83 ec 08             	sub    $0x8,%esp
  800130:	56                   	push   %esi
  800131:	53                   	push   %ebx
  800132:	e8 5b ff ff ff       	call   800092 <umain>

	// exit gracefully
	exit();
  800137:	e8 0a 00 00 00       	call   800146 <exit>
}
  80013c:	83 c4 10             	add    $0x10,%esp
  80013f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800142:	5b                   	pop    %ebx
  800143:	5e                   	pop    %esi
  800144:	5d                   	pop    %ebp
  800145:	c3                   	ret    

00800146 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800146:	f3 0f 1e fb          	endbr32 
  80014a:	55                   	push   %ebp
  80014b:	89 e5                	mov    %esp,%ebp
  80014d:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800150:	e8 f6 0f 00 00       	call   80114b <close_all>
	sys_env_destroy(0);
  800155:	83 ec 0c             	sub    $0xc,%esp
  800158:	6a 00                	push   $0x0
  80015a:	e8 ad 0a 00 00       	call   800c0c <sys_env_destroy>
}
  80015f:	83 c4 10             	add    $0x10,%esp
  800162:	c9                   	leave  
  800163:	c3                   	ret    

00800164 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800164:	f3 0f 1e fb          	endbr32 
  800168:	55                   	push   %ebp
  800169:	89 e5                	mov    %esp,%ebp
  80016b:	56                   	push   %esi
  80016c:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80016d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800170:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800176:	e8 d6 0a 00 00       	call   800c51 <sys_getenvid>
  80017b:	83 ec 0c             	sub    $0xc,%esp
  80017e:	ff 75 0c             	pushl  0xc(%ebp)
  800181:	ff 75 08             	pushl  0x8(%ebp)
  800184:	56                   	push   %esi
  800185:	50                   	push   %eax
  800186:	68 74 25 80 00       	push   $0x802574
  80018b:	e8 bb 00 00 00       	call   80024b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800190:	83 c4 18             	add    $0x18,%esp
  800193:	53                   	push   %ebx
  800194:	ff 75 10             	pushl  0x10(%ebp)
  800197:	e8 5a 00 00 00       	call   8001f6 <vcprintf>
	cprintf("\n");
  80019c:	c7 04 24 0c 2a 80 00 	movl   $0x802a0c,(%esp)
  8001a3:	e8 a3 00 00 00       	call   80024b <cprintf>
  8001a8:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001ab:	cc                   	int3   
  8001ac:	eb fd                	jmp    8001ab <_panic+0x47>

008001ae <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001ae:	f3 0f 1e fb          	endbr32 
  8001b2:	55                   	push   %ebp
  8001b3:	89 e5                	mov    %esp,%ebp
  8001b5:	53                   	push   %ebx
  8001b6:	83 ec 04             	sub    $0x4,%esp
  8001b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001bc:	8b 13                	mov    (%ebx),%edx
  8001be:	8d 42 01             	lea    0x1(%edx),%eax
  8001c1:	89 03                	mov    %eax,(%ebx)
  8001c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001c6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001ca:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001cf:	74 09                	je     8001da <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001d1:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001d8:	c9                   	leave  
  8001d9:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	68 ff 00 00 00       	push   $0xff
  8001e2:	8d 43 08             	lea    0x8(%ebx),%eax
  8001e5:	50                   	push   %eax
  8001e6:	e8 dc 09 00 00       	call   800bc7 <sys_cputs>
		b->idx = 0;
  8001eb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001f1:	83 c4 10             	add    $0x10,%esp
  8001f4:	eb db                	jmp    8001d1 <putch+0x23>

008001f6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001f6:	f3 0f 1e fb          	endbr32 
  8001fa:	55                   	push   %ebp
  8001fb:	89 e5                	mov    %esp,%ebp
  8001fd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800203:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80020a:	00 00 00 
	b.cnt = 0;
  80020d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800214:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800217:	ff 75 0c             	pushl  0xc(%ebp)
  80021a:	ff 75 08             	pushl  0x8(%ebp)
  80021d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800223:	50                   	push   %eax
  800224:	68 ae 01 80 00       	push   $0x8001ae
  800229:	e8 20 01 00 00       	call   80034e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80022e:	83 c4 08             	add    $0x8,%esp
  800231:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800237:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80023d:	50                   	push   %eax
  80023e:	e8 84 09 00 00       	call   800bc7 <sys_cputs>

	return b.cnt;
}
  800243:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800249:	c9                   	leave  
  80024a:	c3                   	ret    

0080024b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80024b:	f3 0f 1e fb          	endbr32 
  80024f:	55                   	push   %ebp
  800250:	89 e5                	mov    %esp,%ebp
  800252:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800255:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800258:	50                   	push   %eax
  800259:	ff 75 08             	pushl  0x8(%ebp)
  80025c:	e8 95 ff ff ff       	call   8001f6 <vcprintf>
	va_end(ap);

	return cnt;
}
  800261:	c9                   	leave  
  800262:	c3                   	ret    

00800263 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800263:	55                   	push   %ebp
  800264:	89 e5                	mov    %esp,%ebp
  800266:	57                   	push   %edi
  800267:	56                   	push   %esi
  800268:	53                   	push   %ebx
  800269:	83 ec 1c             	sub    $0x1c,%esp
  80026c:	89 c7                	mov    %eax,%edi
  80026e:	89 d6                	mov    %edx,%esi
  800270:	8b 45 08             	mov    0x8(%ebp),%eax
  800273:	8b 55 0c             	mov    0xc(%ebp),%edx
  800276:	89 d1                	mov    %edx,%ecx
  800278:	89 c2                	mov    %eax,%edx
  80027a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80027d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800280:	8b 45 10             	mov    0x10(%ebp),%eax
  800283:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800286:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800289:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800290:	39 c2                	cmp    %eax,%edx
  800292:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800295:	72 3e                	jb     8002d5 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	ff 75 18             	pushl  0x18(%ebp)
  80029d:	83 eb 01             	sub    $0x1,%ebx
  8002a0:	53                   	push   %ebx
  8002a1:	50                   	push   %eax
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a8:	ff 75 e0             	pushl  -0x20(%ebp)
  8002ab:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ae:	ff 75 d8             	pushl  -0x28(%ebp)
  8002b1:	e8 0a 20 00 00       	call   8022c0 <__udivdi3>
  8002b6:	83 c4 18             	add    $0x18,%esp
  8002b9:	52                   	push   %edx
  8002ba:	50                   	push   %eax
  8002bb:	89 f2                	mov    %esi,%edx
  8002bd:	89 f8                	mov    %edi,%eax
  8002bf:	e8 9f ff ff ff       	call   800263 <printnum>
  8002c4:	83 c4 20             	add    $0x20,%esp
  8002c7:	eb 13                	jmp    8002dc <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002c9:	83 ec 08             	sub    $0x8,%esp
  8002cc:	56                   	push   %esi
  8002cd:	ff 75 18             	pushl  0x18(%ebp)
  8002d0:	ff d7                	call   *%edi
  8002d2:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002d5:	83 eb 01             	sub    $0x1,%ebx
  8002d8:	85 db                	test   %ebx,%ebx
  8002da:	7f ed                	jg     8002c9 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002dc:	83 ec 08             	sub    $0x8,%esp
  8002df:	56                   	push   %esi
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e6:	ff 75 e0             	pushl  -0x20(%ebp)
  8002e9:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ec:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ef:	e8 dc 20 00 00       	call   8023d0 <__umoddi3>
  8002f4:	83 c4 14             	add    $0x14,%esp
  8002f7:	0f be 80 97 25 80 00 	movsbl 0x802597(%eax),%eax
  8002fe:	50                   	push   %eax
  8002ff:	ff d7                	call   *%edi
}
  800301:	83 c4 10             	add    $0x10,%esp
  800304:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800307:	5b                   	pop    %ebx
  800308:	5e                   	pop    %esi
  800309:	5f                   	pop    %edi
  80030a:	5d                   	pop    %ebp
  80030b:	c3                   	ret    

0080030c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80030c:	f3 0f 1e fb          	endbr32 
  800310:	55                   	push   %ebp
  800311:	89 e5                	mov    %esp,%ebp
  800313:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800316:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80031a:	8b 10                	mov    (%eax),%edx
  80031c:	3b 50 04             	cmp    0x4(%eax),%edx
  80031f:	73 0a                	jae    80032b <sprintputch+0x1f>
		*b->buf++ = ch;
  800321:	8d 4a 01             	lea    0x1(%edx),%ecx
  800324:	89 08                	mov    %ecx,(%eax)
  800326:	8b 45 08             	mov    0x8(%ebp),%eax
  800329:	88 02                	mov    %al,(%edx)
}
  80032b:	5d                   	pop    %ebp
  80032c:	c3                   	ret    

0080032d <printfmt>:
{
  80032d:	f3 0f 1e fb          	endbr32 
  800331:	55                   	push   %ebp
  800332:	89 e5                	mov    %esp,%ebp
  800334:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800337:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80033a:	50                   	push   %eax
  80033b:	ff 75 10             	pushl  0x10(%ebp)
  80033e:	ff 75 0c             	pushl  0xc(%ebp)
  800341:	ff 75 08             	pushl  0x8(%ebp)
  800344:	e8 05 00 00 00       	call   80034e <vprintfmt>
}
  800349:	83 c4 10             	add    $0x10,%esp
  80034c:	c9                   	leave  
  80034d:	c3                   	ret    

0080034e <vprintfmt>:
{
  80034e:	f3 0f 1e fb          	endbr32 
  800352:	55                   	push   %ebp
  800353:	89 e5                	mov    %esp,%ebp
  800355:	57                   	push   %edi
  800356:	56                   	push   %esi
  800357:	53                   	push   %ebx
  800358:	83 ec 3c             	sub    $0x3c,%esp
  80035b:	8b 75 08             	mov    0x8(%ebp),%esi
  80035e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800361:	8b 7d 10             	mov    0x10(%ebp),%edi
  800364:	e9 8e 03 00 00       	jmp    8006f7 <vprintfmt+0x3a9>
		padc = ' ';
  800369:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80036d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800374:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80037b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800382:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800387:	8d 47 01             	lea    0x1(%edi),%eax
  80038a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80038d:	0f b6 17             	movzbl (%edi),%edx
  800390:	8d 42 dd             	lea    -0x23(%edx),%eax
  800393:	3c 55                	cmp    $0x55,%al
  800395:	0f 87 df 03 00 00    	ja     80077a <vprintfmt+0x42c>
  80039b:	0f b6 c0             	movzbl %al,%eax
  80039e:	3e ff 24 85 e0 26 80 	notrack jmp *0x8026e0(,%eax,4)
  8003a5:	00 
  8003a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003a9:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8003ad:	eb d8                	jmp    800387 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003af:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003b2:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8003b6:	eb cf                	jmp    800387 <vprintfmt+0x39>
  8003b8:	0f b6 d2             	movzbl %dl,%edx
  8003bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003be:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c3:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003c6:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003c9:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003cd:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003d0:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003d3:	83 f9 09             	cmp    $0x9,%ecx
  8003d6:	77 55                	ja     80042d <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8003d8:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003db:	eb e9                	jmp    8003c6 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8003dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e0:	8b 00                	mov    (%eax),%eax
  8003e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e8:	8d 40 04             	lea    0x4(%eax),%eax
  8003eb:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003f1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003f5:	79 90                	jns    800387 <vprintfmt+0x39>
				width = precision, precision = -1;
  8003f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003fd:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800404:	eb 81                	jmp    800387 <vprintfmt+0x39>
  800406:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800409:	85 c0                	test   %eax,%eax
  80040b:	ba 00 00 00 00       	mov    $0x0,%edx
  800410:	0f 49 d0             	cmovns %eax,%edx
  800413:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800416:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800419:	e9 69 ff ff ff       	jmp    800387 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80041e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800421:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800428:	e9 5a ff ff ff       	jmp    800387 <vprintfmt+0x39>
  80042d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800430:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800433:	eb bc                	jmp    8003f1 <vprintfmt+0xa3>
			lflag++;
  800435:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800438:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80043b:	e9 47 ff ff ff       	jmp    800387 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800440:	8b 45 14             	mov    0x14(%ebp),%eax
  800443:	8d 78 04             	lea    0x4(%eax),%edi
  800446:	83 ec 08             	sub    $0x8,%esp
  800449:	53                   	push   %ebx
  80044a:	ff 30                	pushl  (%eax)
  80044c:	ff d6                	call   *%esi
			break;
  80044e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800451:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800454:	e9 9b 02 00 00       	jmp    8006f4 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800459:	8b 45 14             	mov    0x14(%ebp),%eax
  80045c:	8d 78 04             	lea    0x4(%eax),%edi
  80045f:	8b 00                	mov    (%eax),%eax
  800461:	99                   	cltd   
  800462:	31 d0                	xor    %edx,%eax
  800464:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800466:	83 f8 0f             	cmp    $0xf,%eax
  800469:	7f 23                	jg     80048e <vprintfmt+0x140>
  80046b:	8b 14 85 40 28 80 00 	mov    0x802840(,%eax,4),%edx
  800472:	85 d2                	test   %edx,%edx
  800474:	74 18                	je     80048e <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800476:	52                   	push   %edx
  800477:	68 75 29 80 00       	push   $0x802975
  80047c:	53                   	push   %ebx
  80047d:	56                   	push   %esi
  80047e:	e8 aa fe ff ff       	call   80032d <printfmt>
  800483:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800486:	89 7d 14             	mov    %edi,0x14(%ebp)
  800489:	e9 66 02 00 00       	jmp    8006f4 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80048e:	50                   	push   %eax
  80048f:	68 af 25 80 00       	push   $0x8025af
  800494:	53                   	push   %ebx
  800495:	56                   	push   %esi
  800496:	e8 92 fe ff ff       	call   80032d <printfmt>
  80049b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80049e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004a1:	e9 4e 02 00 00       	jmp    8006f4 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8004a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a9:	83 c0 04             	add    $0x4,%eax
  8004ac:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8004af:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b2:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8004b4:	85 d2                	test   %edx,%edx
  8004b6:	b8 a8 25 80 00       	mov    $0x8025a8,%eax
  8004bb:	0f 45 c2             	cmovne %edx,%eax
  8004be:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004c1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004c5:	7e 06                	jle    8004cd <vprintfmt+0x17f>
  8004c7:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004cb:	75 0d                	jne    8004da <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004cd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004d0:	89 c7                	mov    %eax,%edi
  8004d2:	03 45 e0             	add    -0x20(%ebp),%eax
  8004d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004d8:	eb 55                	jmp    80052f <vprintfmt+0x1e1>
  8004da:	83 ec 08             	sub    $0x8,%esp
  8004dd:	ff 75 d8             	pushl  -0x28(%ebp)
  8004e0:	ff 75 cc             	pushl  -0x34(%ebp)
  8004e3:	e8 46 03 00 00       	call   80082e <strnlen>
  8004e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004eb:	29 c2                	sub    %eax,%edx
  8004ed:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004f0:	83 c4 10             	add    $0x10,%esp
  8004f3:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004f5:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004fc:	85 ff                	test   %edi,%edi
  8004fe:	7e 11                	jle    800511 <vprintfmt+0x1c3>
					putch(padc, putdat);
  800500:	83 ec 08             	sub    $0x8,%esp
  800503:	53                   	push   %ebx
  800504:	ff 75 e0             	pushl  -0x20(%ebp)
  800507:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800509:	83 ef 01             	sub    $0x1,%edi
  80050c:	83 c4 10             	add    $0x10,%esp
  80050f:	eb eb                	jmp    8004fc <vprintfmt+0x1ae>
  800511:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800514:	85 d2                	test   %edx,%edx
  800516:	b8 00 00 00 00       	mov    $0x0,%eax
  80051b:	0f 49 c2             	cmovns %edx,%eax
  80051e:	29 c2                	sub    %eax,%edx
  800520:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800523:	eb a8                	jmp    8004cd <vprintfmt+0x17f>
					putch(ch, putdat);
  800525:	83 ec 08             	sub    $0x8,%esp
  800528:	53                   	push   %ebx
  800529:	52                   	push   %edx
  80052a:	ff d6                	call   *%esi
  80052c:	83 c4 10             	add    $0x10,%esp
  80052f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800532:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800534:	83 c7 01             	add    $0x1,%edi
  800537:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80053b:	0f be d0             	movsbl %al,%edx
  80053e:	85 d2                	test   %edx,%edx
  800540:	74 4b                	je     80058d <vprintfmt+0x23f>
  800542:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800546:	78 06                	js     80054e <vprintfmt+0x200>
  800548:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80054c:	78 1e                	js     80056c <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  80054e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800552:	74 d1                	je     800525 <vprintfmt+0x1d7>
  800554:	0f be c0             	movsbl %al,%eax
  800557:	83 e8 20             	sub    $0x20,%eax
  80055a:	83 f8 5e             	cmp    $0x5e,%eax
  80055d:	76 c6                	jbe    800525 <vprintfmt+0x1d7>
					putch('?', putdat);
  80055f:	83 ec 08             	sub    $0x8,%esp
  800562:	53                   	push   %ebx
  800563:	6a 3f                	push   $0x3f
  800565:	ff d6                	call   *%esi
  800567:	83 c4 10             	add    $0x10,%esp
  80056a:	eb c3                	jmp    80052f <vprintfmt+0x1e1>
  80056c:	89 cf                	mov    %ecx,%edi
  80056e:	eb 0e                	jmp    80057e <vprintfmt+0x230>
				putch(' ', putdat);
  800570:	83 ec 08             	sub    $0x8,%esp
  800573:	53                   	push   %ebx
  800574:	6a 20                	push   $0x20
  800576:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800578:	83 ef 01             	sub    $0x1,%edi
  80057b:	83 c4 10             	add    $0x10,%esp
  80057e:	85 ff                	test   %edi,%edi
  800580:	7f ee                	jg     800570 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800582:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800585:	89 45 14             	mov    %eax,0x14(%ebp)
  800588:	e9 67 01 00 00       	jmp    8006f4 <vprintfmt+0x3a6>
  80058d:	89 cf                	mov    %ecx,%edi
  80058f:	eb ed                	jmp    80057e <vprintfmt+0x230>
	if (lflag >= 2)
  800591:	83 f9 01             	cmp    $0x1,%ecx
  800594:	7f 1b                	jg     8005b1 <vprintfmt+0x263>
	else if (lflag)
  800596:	85 c9                	test   %ecx,%ecx
  800598:	74 63                	je     8005fd <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80059a:	8b 45 14             	mov    0x14(%ebp),%eax
  80059d:	8b 00                	mov    (%eax),%eax
  80059f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a2:	99                   	cltd   
  8005a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a9:	8d 40 04             	lea    0x4(%eax),%eax
  8005ac:	89 45 14             	mov    %eax,0x14(%ebp)
  8005af:	eb 17                	jmp    8005c8 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  8005b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b4:	8b 50 04             	mov    0x4(%eax),%edx
  8005b7:	8b 00                	mov    (%eax),%eax
  8005b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005bc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c2:	8d 40 08             	lea    0x8(%eax),%eax
  8005c5:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005c8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005cb:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005ce:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8005d3:	85 c9                	test   %ecx,%ecx
  8005d5:	0f 89 ff 00 00 00    	jns    8006da <vprintfmt+0x38c>
				putch('-', putdat);
  8005db:	83 ec 08             	sub    $0x8,%esp
  8005de:	53                   	push   %ebx
  8005df:	6a 2d                	push   $0x2d
  8005e1:	ff d6                	call   *%esi
				num = -(long long) num;
  8005e3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005e6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005e9:	f7 da                	neg    %edx
  8005eb:	83 d1 00             	adc    $0x0,%ecx
  8005ee:	f7 d9                	neg    %ecx
  8005f0:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005f3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f8:	e9 dd 00 00 00       	jmp    8006da <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8005fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800600:	8b 00                	mov    (%eax),%eax
  800602:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800605:	99                   	cltd   
  800606:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800609:	8b 45 14             	mov    0x14(%ebp),%eax
  80060c:	8d 40 04             	lea    0x4(%eax),%eax
  80060f:	89 45 14             	mov    %eax,0x14(%ebp)
  800612:	eb b4                	jmp    8005c8 <vprintfmt+0x27a>
	if (lflag >= 2)
  800614:	83 f9 01             	cmp    $0x1,%ecx
  800617:	7f 1e                	jg     800637 <vprintfmt+0x2e9>
	else if (lflag)
  800619:	85 c9                	test   %ecx,%ecx
  80061b:	74 32                	je     80064f <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  80061d:	8b 45 14             	mov    0x14(%ebp),%eax
  800620:	8b 10                	mov    (%eax),%edx
  800622:	b9 00 00 00 00       	mov    $0x0,%ecx
  800627:	8d 40 04             	lea    0x4(%eax),%eax
  80062a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80062d:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800632:	e9 a3 00 00 00       	jmp    8006da <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800637:	8b 45 14             	mov    0x14(%ebp),%eax
  80063a:	8b 10                	mov    (%eax),%edx
  80063c:	8b 48 04             	mov    0x4(%eax),%ecx
  80063f:	8d 40 08             	lea    0x8(%eax),%eax
  800642:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800645:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80064a:	e9 8b 00 00 00       	jmp    8006da <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80064f:	8b 45 14             	mov    0x14(%ebp),%eax
  800652:	8b 10                	mov    (%eax),%edx
  800654:	b9 00 00 00 00       	mov    $0x0,%ecx
  800659:	8d 40 04             	lea    0x4(%eax),%eax
  80065c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80065f:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800664:	eb 74                	jmp    8006da <vprintfmt+0x38c>
	if (lflag >= 2)
  800666:	83 f9 01             	cmp    $0x1,%ecx
  800669:	7f 1b                	jg     800686 <vprintfmt+0x338>
	else if (lflag)
  80066b:	85 c9                	test   %ecx,%ecx
  80066d:	74 2c                	je     80069b <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  80066f:	8b 45 14             	mov    0x14(%ebp),%eax
  800672:	8b 10                	mov    (%eax),%edx
  800674:	b9 00 00 00 00       	mov    $0x0,%ecx
  800679:	8d 40 04             	lea    0x4(%eax),%eax
  80067c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80067f:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800684:	eb 54                	jmp    8006da <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800686:	8b 45 14             	mov    0x14(%ebp),%eax
  800689:	8b 10                	mov    (%eax),%edx
  80068b:	8b 48 04             	mov    0x4(%eax),%ecx
  80068e:	8d 40 08             	lea    0x8(%eax),%eax
  800691:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800694:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800699:	eb 3f                	jmp    8006da <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80069b:	8b 45 14             	mov    0x14(%ebp),%eax
  80069e:	8b 10                	mov    (%eax),%edx
  8006a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006a5:	8d 40 04             	lea    0x4(%eax),%eax
  8006a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006ab:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  8006b0:	eb 28                	jmp    8006da <vprintfmt+0x38c>
			putch('0', putdat);
  8006b2:	83 ec 08             	sub    $0x8,%esp
  8006b5:	53                   	push   %ebx
  8006b6:	6a 30                	push   $0x30
  8006b8:	ff d6                	call   *%esi
			putch('x', putdat);
  8006ba:	83 c4 08             	add    $0x8,%esp
  8006bd:	53                   	push   %ebx
  8006be:	6a 78                	push   $0x78
  8006c0:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c5:	8b 10                	mov    (%eax),%edx
  8006c7:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006cc:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006cf:	8d 40 04             	lea    0x4(%eax),%eax
  8006d2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006d5:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006da:	83 ec 0c             	sub    $0xc,%esp
  8006dd:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8006e1:	57                   	push   %edi
  8006e2:	ff 75 e0             	pushl  -0x20(%ebp)
  8006e5:	50                   	push   %eax
  8006e6:	51                   	push   %ecx
  8006e7:	52                   	push   %edx
  8006e8:	89 da                	mov    %ebx,%edx
  8006ea:	89 f0                	mov    %esi,%eax
  8006ec:	e8 72 fb ff ff       	call   800263 <printnum>
			break;
  8006f1:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006f7:	83 c7 01             	add    $0x1,%edi
  8006fa:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006fe:	83 f8 25             	cmp    $0x25,%eax
  800701:	0f 84 62 fc ff ff    	je     800369 <vprintfmt+0x1b>
			if (ch == '\0')
  800707:	85 c0                	test   %eax,%eax
  800709:	0f 84 8b 00 00 00    	je     80079a <vprintfmt+0x44c>
			putch(ch, putdat);
  80070f:	83 ec 08             	sub    $0x8,%esp
  800712:	53                   	push   %ebx
  800713:	50                   	push   %eax
  800714:	ff d6                	call   *%esi
  800716:	83 c4 10             	add    $0x10,%esp
  800719:	eb dc                	jmp    8006f7 <vprintfmt+0x3a9>
	if (lflag >= 2)
  80071b:	83 f9 01             	cmp    $0x1,%ecx
  80071e:	7f 1b                	jg     80073b <vprintfmt+0x3ed>
	else if (lflag)
  800720:	85 c9                	test   %ecx,%ecx
  800722:	74 2c                	je     800750 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800724:	8b 45 14             	mov    0x14(%ebp),%eax
  800727:	8b 10                	mov    (%eax),%edx
  800729:	b9 00 00 00 00       	mov    $0x0,%ecx
  80072e:	8d 40 04             	lea    0x4(%eax),%eax
  800731:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800734:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800739:	eb 9f                	jmp    8006da <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80073b:	8b 45 14             	mov    0x14(%ebp),%eax
  80073e:	8b 10                	mov    (%eax),%edx
  800740:	8b 48 04             	mov    0x4(%eax),%ecx
  800743:	8d 40 08             	lea    0x8(%eax),%eax
  800746:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800749:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  80074e:	eb 8a                	jmp    8006da <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800750:	8b 45 14             	mov    0x14(%ebp),%eax
  800753:	8b 10                	mov    (%eax),%edx
  800755:	b9 00 00 00 00       	mov    $0x0,%ecx
  80075a:	8d 40 04             	lea    0x4(%eax),%eax
  80075d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800760:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800765:	e9 70 ff ff ff       	jmp    8006da <vprintfmt+0x38c>
			putch(ch, putdat);
  80076a:	83 ec 08             	sub    $0x8,%esp
  80076d:	53                   	push   %ebx
  80076e:	6a 25                	push   $0x25
  800770:	ff d6                	call   *%esi
			break;
  800772:	83 c4 10             	add    $0x10,%esp
  800775:	e9 7a ff ff ff       	jmp    8006f4 <vprintfmt+0x3a6>
			putch('%', putdat);
  80077a:	83 ec 08             	sub    $0x8,%esp
  80077d:	53                   	push   %ebx
  80077e:	6a 25                	push   $0x25
  800780:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800782:	83 c4 10             	add    $0x10,%esp
  800785:	89 f8                	mov    %edi,%eax
  800787:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80078b:	74 05                	je     800792 <vprintfmt+0x444>
  80078d:	83 e8 01             	sub    $0x1,%eax
  800790:	eb f5                	jmp    800787 <vprintfmt+0x439>
  800792:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800795:	e9 5a ff ff ff       	jmp    8006f4 <vprintfmt+0x3a6>
}
  80079a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80079d:	5b                   	pop    %ebx
  80079e:	5e                   	pop    %esi
  80079f:	5f                   	pop    %edi
  8007a0:	5d                   	pop    %ebp
  8007a1:	c3                   	ret    

008007a2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007a2:	f3 0f 1e fb          	endbr32 
  8007a6:	55                   	push   %ebp
  8007a7:	89 e5                	mov    %esp,%ebp
  8007a9:	83 ec 18             	sub    $0x18,%esp
  8007ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8007af:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007b5:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007b9:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007c3:	85 c0                	test   %eax,%eax
  8007c5:	74 26                	je     8007ed <vsnprintf+0x4b>
  8007c7:	85 d2                	test   %edx,%edx
  8007c9:	7e 22                	jle    8007ed <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007cb:	ff 75 14             	pushl  0x14(%ebp)
  8007ce:	ff 75 10             	pushl  0x10(%ebp)
  8007d1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007d4:	50                   	push   %eax
  8007d5:	68 0c 03 80 00       	push   $0x80030c
  8007da:	e8 6f fb ff ff       	call   80034e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007e2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007e8:	83 c4 10             	add    $0x10,%esp
}
  8007eb:	c9                   	leave  
  8007ec:	c3                   	ret    
		return -E_INVAL;
  8007ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007f2:	eb f7                	jmp    8007eb <vsnprintf+0x49>

008007f4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007f4:	f3 0f 1e fb          	endbr32 
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007fe:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800801:	50                   	push   %eax
  800802:	ff 75 10             	pushl  0x10(%ebp)
  800805:	ff 75 0c             	pushl  0xc(%ebp)
  800808:	ff 75 08             	pushl  0x8(%ebp)
  80080b:	e8 92 ff ff ff       	call   8007a2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800810:	c9                   	leave  
  800811:	c3                   	ret    

00800812 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800812:	f3 0f 1e fb          	endbr32 
  800816:	55                   	push   %ebp
  800817:	89 e5                	mov    %esp,%ebp
  800819:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80081c:	b8 00 00 00 00       	mov    $0x0,%eax
  800821:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800825:	74 05                	je     80082c <strlen+0x1a>
		n++;
  800827:	83 c0 01             	add    $0x1,%eax
  80082a:	eb f5                	jmp    800821 <strlen+0xf>
	return n;
}
  80082c:	5d                   	pop    %ebp
  80082d:	c3                   	ret    

0080082e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80082e:	f3 0f 1e fb          	endbr32 
  800832:	55                   	push   %ebp
  800833:	89 e5                	mov    %esp,%ebp
  800835:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800838:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80083b:	b8 00 00 00 00       	mov    $0x0,%eax
  800840:	39 d0                	cmp    %edx,%eax
  800842:	74 0d                	je     800851 <strnlen+0x23>
  800844:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800848:	74 05                	je     80084f <strnlen+0x21>
		n++;
  80084a:	83 c0 01             	add    $0x1,%eax
  80084d:	eb f1                	jmp    800840 <strnlen+0x12>
  80084f:	89 c2                	mov    %eax,%edx
	return n;
}
  800851:	89 d0                	mov    %edx,%eax
  800853:	5d                   	pop    %ebp
  800854:	c3                   	ret    

00800855 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800855:	f3 0f 1e fb          	endbr32 
  800859:	55                   	push   %ebp
  80085a:	89 e5                	mov    %esp,%ebp
  80085c:	53                   	push   %ebx
  80085d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800860:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800863:	b8 00 00 00 00       	mov    $0x0,%eax
  800868:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80086c:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  80086f:	83 c0 01             	add    $0x1,%eax
  800872:	84 d2                	test   %dl,%dl
  800874:	75 f2                	jne    800868 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800876:	89 c8                	mov    %ecx,%eax
  800878:	5b                   	pop    %ebx
  800879:	5d                   	pop    %ebp
  80087a:	c3                   	ret    

0080087b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80087b:	f3 0f 1e fb          	endbr32 
  80087f:	55                   	push   %ebp
  800880:	89 e5                	mov    %esp,%ebp
  800882:	53                   	push   %ebx
  800883:	83 ec 10             	sub    $0x10,%esp
  800886:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800889:	53                   	push   %ebx
  80088a:	e8 83 ff ff ff       	call   800812 <strlen>
  80088f:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800892:	ff 75 0c             	pushl  0xc(%ebp)
  800895:	01 d8                	add    %ebx,%eax
  800897:	50                   	push   %eax
  800898:	e8 b8 ff ff ff       	call   800855 <strcpy>
	return dst;
}
  80089d:	89 d8                	mov    %ebx,%eax
  80089f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008a2:	c9                   	leave  
  8008a3:	c3                   	ret    

008008a4 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008a4:	f3 0f 1e fb          	endbr32 
  8008a8:	55                   	push   %ebp
  8008a9:	89 e5                	mov    %esp,%ebp
  8008ab:	56                   	push   %esi
  8008ac:	53                   	push   %ebx
  8008ad:	8b 75 08             	mov    0x8(%ebp),%esi
  8008b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b3:	89 f3                	mov    %esi,%ebx
  8008b5:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008b8:	89 f0                	mov    %esi,%eax
  8008ba:	39 d8                	cmp    %ebx,%eax
  8008bc:	74 11                	je     8008cf <strncpy+0x2b>
		*dst++ = *src;
  8008be:	83 c0 01             	add    $0x1,%eax
  8008c1:	0f b6 0a             	movzbl (%edx),%ecx
  8008c4:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008c7:	80 f9 01             	cmp    $0x1,%cl
  8008ca:	83 da ff             	sbb    $0xffffffff,%edx
  8008cd:	eb eb                	jmp    8008ba <strncpy+0x16>
	}
	return ret;
}
  8008cf:	89 f0                	mov    %esi,%eax
  8008d1:	5b                   	pop    %ebx
  8008d2:	5e                   	pop    %esi
  8008d3:	5d                   	pop    %ebp
  8008d4:	c3                   	ret    

008008d5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008d5:	f3 0f 1e fb          	endbr32 
  8008d9:	55                   	push   %ebp
  8008da:	89 e5                	mov    %esp,%ebp
  8008dc:	56                   	push   %esi
  8008dd:	53                   	push   %ebx
  8008de:	8b 75 08             	mov    0x8(%ebp),%esi
  8008e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008e4:	8b 55 10             	mov    0x10(%ebp),%edx
  8008e7:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008e9:	85 d2                	test   %edx,%edx
  8008eb:	74 21                	je     80090e <strlcpy+0x39>
  8008ed:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008f1:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008f3:	39 c2                	cmp    %eax,%edx
  8008f5:	74 14                	je     80090b <strlcpy+0x36>
  8008f7:	0f b6 19             	movzbl (%ecx),%ebx
  8008fa:	84 db                	test   %bl,%bl
  8008fc:	74 0b                	je     800909 <strlcpy+0x34>
			*dst++ = *src++;
  8008fe:	83 c1 01             	add    $0x1,%ecx
  800901:	83 c2 01             	add    $0x1,%edx
  800904:	88 5a ff             	mov    %bl,-0x1(%edx)
  800907:	eb ea                	jmp    8008f3 <strlcpy+0x1e>
  800909:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80090b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80090e:	29 f0                	sub    %esi,%eax
}
  800910:	5b                   	pop    %ebx
  800911:	5e                   	pop    %esi
  800912:	5d                   	pop    %ebp
  800913:	c3                   	ret    

00800914 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800914:	f3 0f 1e fb          	endbr32 
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
  80091b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80091e:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800921:	0f b6 01             	movzbl (%ecx),%eax
  800924:	84 c0                	test   %al,%al
  800926:	74 0c                	je     800934 <strcmp+0x20>
  800928:	3a 02                	cmp    (%edx),%al
  80092a:	75 08                	jne    800934 <strcmp+0x20>
		p++, q++;
  80092c:	83 c1 01             	add    $0x1,%ecx
  80092f:	83 c2 01             	add    $0x1,%edx
  800932:	eb ed                	jmp    800921 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800934:	0f b6 c0             	movzbl %al,%eax
  800937:	0f b6 12             	movzbl (%edx),%edx
  80093a:	29 d0                	sub    %edx,%eax
}
  80093c:	5d                   	pop    %ebp
  80093d:	c3                   	ret    

0080093e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80093e:	f3 0f 1e fb          	endbr32 
  800942:	55                   	push   %ebp
  800943:	89 e5                	mov    %esp,%ebp
  800945:	53                   	push   %ebx
  800946:	8b 45 08             	mov    0x8(%ebp),%eax
  800949:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094c:	89 c3                	mov    %eax,%ebx
  80094e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800951:	eb 06                	jmp    800959 <strncmp+0x1b>
		n--, p++, q++;
  800953:	83 c0 01             	add    $0x1,%eax
  800956:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800959:	39 d8                	cmp    %ebx,%eax
  80095b:	74 16                	je     800973 <strncmp+0x35>
  80095d:	0f b6 08             	movzbl (%eax),%ecx
  800960:	84 c9                	test   %cl,%cl
  800962:	74 04                	je     800968 <strncmp+0x2a>
  800964:	3a 0a                	cmp    (%edx),%cl
  800966:	74 eb                	je     800953 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800968:	0f b6 00             	movzbl (%eax),%eax
  80096b:	0f b6 12             	movzbl (%edx),%edx
  80096e:	29 d0                	sub    %edx,%eax
}
  800970:	5b                   	pop    %ebx
  800971:	5d                   	pop    %ebp
  800972:	c3                   	ret    
		return 0;
  800973:	b8 00 00 00 00       	mov    $0x0,%eax
  800978:	eb f6                	jmp    800970 <strncmp+0x32>

0080097a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80097a:	f3 0f 1e fb          	endbr32 
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	8b 45 08             	mov    0x8(%ebp),%eax
  800984:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800988:	0f b6 10             	movzbl (%eax),%edx
  80098b:	84 d2                	test   %dl,%dl
  80098d:	74 09                	je     800998 <strchr+0x1e>
		if (*s == c)
  80098f:	38 ca                	cmp    %cl,%dl
  800991:	74 0a                	je     80099d <strchr+0x23>
	for (; *s; s++)
  800993:	83 c0 01             	add    $0x1,%eax
  800996:	eb f0                	jmp    800988 <strchr+0xe>
			return (char *) s;
	return 0;
  800998:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80099d:	5d                   	pop    %ebp
  80099e:	c3                   	ret    

0080099f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80099f:	f3 0f 1e fb          	endbr32 
  8009a3:	55                   	push   %ebp
  8009a4:	89 e5                	mov    %esp,%ebp
  8009a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009ad:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009b0:	38 ca                	cmp    %cl,%dl
  8009b2:	74 09                	je     8009bd <strfind+0x1e>
  8009b4:	84 d2                	test   %dl,%dl
  8009b6:	74 05                	je     8009bd <strfind+0x1e>
	for (; *s; s++)
  8009b8:	83 c0 01             	add    $0x1,%eax
  8009bb:	eb f0                	jmp    8009ad <strfind+0xe>
			break;
	return (char *) s;
}
  8009bd:	5d                   	pop    %ebp
  8009be:	c3                   	ret    

008009bf <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009bf:	f3 0f 1e fb          	endbr32 
  8009c3:	55                   	push   %ebp
  8009c4:	89 e5                	mov    %esp,%ebp
  8009c6:	57                   	push   %edi
  8009c7:	56                   	push   %esi
  8009c8:	53                   	push   %ebx
  8009c9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009cf:	85 c9                	test   %ecx,%ecx
  8009d1:	74 31                	je     800a04 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009d3:	89 f8                	mov    %edi,%eax
  8009d5:	09 c8                	or     %ecx,%eax
  8009d7:	a8 03                	test   $0x3,%al
  8009d9:	75 23                	jne    8009fe <memset+0x3f>
		c &= 0xFF;
  8009db:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009df:	89 d3                	mov    %edx,%ebx
  8009e1:	c1 e3 08             	shl    $0x8,%ebx
  8009e4:	89 d0                	mov    %edx,%eax
  8009e6:	c1 e0 18             	shl    $0x18,%eax
  8009e9:	89 d6                	mov    %edx,%esi
  8009eb:	c1 e6 10             	shl    $0x10,%esi
  8009ee:	09 f0                	or     %esi,%eax
  8009f0:	09 c2                	or     %eax,%edx
  8009f2:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009f4:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009f7:	89 d0                	mov    %edx,%eax
  8009f9:	fc                   	cld    
  8009fa:	f3 ab                	rep stos %eax,%es:(%edi)
  8009fc:	eb 06                	jmp    800a04 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a01:	fc                   	cld    
  800a02:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a04:	89 f8                	mov    %edi,%eax
  800a06:	5b                   	pop    %ebx
  800a07:	5e                   	pop    %esi
  800a08:	5f                   	pop    %edi
  800a09:	5d                   	pop    %ebp
  800a0a:	c3                   	ret    

00800a0b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a0b:	f3 0f 1e fb          	endbr32 
  800a0f:	55                   	push   %ebp
  800a10:	89 e5                	mov    %esp,%ebp
  800a12:	57                   	push   %edi
  800a13:	56                   	push   %esi
  800a14:	8b 45 08             	mov    0x8(%ebp),%eax
  800a17:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a1a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a1d:	39 c6                	cmp    %eax,%esi
  800a1f:	73 32                	jae    800a53 <memmove+0x48>
  800a21:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a24:	39 c2                	cmp    %eax,%edx
  800a26:	76 2b                	jbe    800a53 <memmove+0x48>
		s += n;
		d += n;
  800a28:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a2b:	89 fe                	mov    %edi,%esi
  800a2d:	09 ce                	or     %ecx,%esi
  800a2f:	09 d6                	or     %edx,%esi
  800a31:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a37:	75 0e                	jne    800a47 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a39:	83 ef 04             	sub    $0x4,%edi
  800a3c:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a3f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a42:	fd                   	std    
  800a43:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a45:	eb 09                	jmp    800a50 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a47:	83 ef 01             	sub    $0x1,%edi
  800a4a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a4d:	fd                   	std    
  800a4e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a50:	fc                   	cld    
  800a51:	eb 1a                	jmp    800a6d <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a53:	89 c2                	mov    %eax,%edx
  800a55:	09 ca                	or     %ecx,%edx
  800a57:	09 f2                	or     %esi,%edx
  800a59:	f6 c2 03             	test   $0x3,%dl
  800a5c:	75 0a                	jne    800a68 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a5e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a61:	89 c7                	mov    %eax,%edi
  800a63:	fc                   	cld    
  800a64:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a66:	eb 05                	jmp    800a6d <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800a68:	89 c7                	mov    %eax,%edi
  800a6a:	fc                   	cld    
  800a6b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a6d:	5e                   	pop    %esi
  800a6e:	5f                   	pop    %edi
  800a6f:	5d                   	pop    %ebp
  800a70:	c3                   	ret    

00800a71 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a71:	f3 0f 1e fb          	endbr32 
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
  800a78:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a7b:	ff 75 10             	pushl  0x10(%ebp)
  800a7e:	ff 75 0c             	pushl  0xc(%ebp)
  800a81:	ff 75 08             	pushl  0x8(%ebp)
  800a84:	e8 82 ff ff ff       	call   800a0b <memmove>
}
  800a89:	c9                   	leave  
  800a8a:	c3                   	ret    

00800a8b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a8b:	f3 0f 1e fb          	endbr32 
  800a8f:	55                   	push   %ebp
  800a90:	89 e5                	mov    %esp,%ebp
  800a92:	56                   	push   %esi
  800a93:	53                   	push   %ebx
  800a94:	8b 45 08             	mov    0x8(%ebp),%eax
  800a97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9a:	89 c6                	mov    %eax,%esi
  800a9c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a9f:	39 f0                	cmp    %esi,%eax
  800aa1:	74 1c                	je     800abf <memcmp+0x34>
		if (*s1 != *s2)
  800aa3:	0f b6 08             	movzbl (%eax),%ecx
  800aa6:	0f b6 1a             	movzbl (%edx),%ebx
  800aa9:	38 d9                	cmp    %bl,%cl
  800aab:	75 08                	jne    800ab5 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800aad:	83 c0 01             	add    $0x1,%eax
  800ab0:	83 c2 01             	add    $0x1,%edx
  800ab3:	eb ea                	jmp    800a9f <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800ab5:	0f b6 c1             	movzbl %cl,%eax
  800ab8:	0f b6 db             	movzbl %bl,%ebx
  800abb:	29 d8                	sub    %ebx,%eax
  800abd:	eb 05                	jmp    800ac4 <memcmp+0x39>
	}

	return 0;
  800abf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ac4:	5b                   	pop    %ebx
  800ac5:	5e                   	pop    %esi
  800ac6:	5d                   	pop    %ebp
  800ac7:	c3                   	ret    

00800ac8 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ac8:	f3 0f 1e fb          	endbr32 
  800acc:	55                   	push   %ebp
  800acd:	89 e5                	mov    %esp,%ebp
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ad5:	89 c2                	mov    %eax,%edx
  800ad7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ada:	39 d0                	cmp    %edx,%eax
  800adc:	73 09                	jae    800ae7 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ade:	38 08                	cmp    %cl,(%eax)
  800ae0:	74 05                	je     800ae7 <memfind+0x1f>
	for (; s < ends; s++)
  800ae2:	83 c0 01             	add    $0x1,%eax
  800ae5:	eb f3                	jmp    800ada <memfind+0x12>
			break;
	return (void *) s;
}
  800ae7:	5d                   	pop    %ebp
  800ae8:	c3                   	ret    

00800ae9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ae9:	f3 0f 1e fb          	endbr32 
  800aed:	55                   	push   %ebp
  800aee:	89 e5                	mov    %esp,%ebp
  800af0:	57                   	push   %edi
  800af1:	56                   	push   %esi
  800af2:	53                   	push   %ebx
  800af3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800af6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800af9:	eb 03                	jmp    800afe <strtol+0x15>
		s++;
  800afb:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800afe:	0f b6 01             	movzbl (%ecx),%eax
  800b01:	3c 20                	cmp    $0x20,%al
  800b03:	74 f6                	je     800afb <strtol+0x12>
  800b05:	3c 09                	cmp    $0x9,%al
  800b07:	74 f2                	je     800afb <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800b09:	3c 2b                	cmp    $0x2b,%al
  800b0b:	74 2a                	je     800b37 <strtol+0x4e>
	int neg = 0;
  800b0d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b12:	3c 2d                	cmp    $0x2d,%al
  800b14:	74 2b                	je     800b41 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b16:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b1c:	75 0f                	jne    800b2d <strtol+0x44>
  800b1e:	80 39 30             	cmpb   $0x30,(%ecx)
  800b21:	74 28                	je     800b4b <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b23:	85 db                	test   %ebx,%ebx
  800b25:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b2a:	0f 44 d8             	cmove  %eax,%ebx
  800b2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b32:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b35:	eb 46                	jmp    800b7d <strtol+0x94>
		s++;
  800b37:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b3a:	bf 00 00 00 00       	mov    $0x0,%edi
  800b3f:	eb d5                	jmp    800b16 <strtol+0x2d>
		s++, neg = 1;
  800b41:	83 c1 01             	add    $0x1,%ecx
  800b44:	bf 01 00 00 00       	mov    $0x1,%edi
  800b49:	eb cb                	jmp    800b16 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b4b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b4f:	74 0e                	je     800b5f <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b51:	85 db                	test   %ebx,%ebx
  800b53:	75 d8                	jne    800b2d <strtol+0x44>
		s++, base = 8;
  800b55:	83 c1 01             	add    $0x1,%ecx
  800b58:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b5d:	eb ce                	jmp    800b2d <strtol+0x44>
		s += 2, base = 16;
  800b5f:	83 c1 02             	add    $0x2,%ecx
  800b62:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b67:	eb c4                	jmp    800b2d <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b69:	0f be d2             	movsbl %dl,%edx
  800b6c:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b6f:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b72:	7d 3a                	jge    800bae <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b74:	83 c1 01             	add    $0x1,%ecx
  800b77:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b7b:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b7d:	0f b6 11             	movzbl (%ecx),%edx
  800b80:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b83:	89 f3                	mov    %esi,%ebx
  800b85:	80 fb 09             	cmp    $0x9,%bl
  800b88:	76 df                	jbe    800b69 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b8a:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b8d:	89 f3                	mov    %esi,%ebx
  800b8f:	80 fb 19             	cmp    $0x19,%bl
  800b92:	77 08                	ja     800b9c <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b94:	0f be d2             	movsbl %dl,%edx
  800b97:	83 ea 57             	sub    $0x57,%edx
  800b9a:	eb d3                	jmp    800b6f <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b9c:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b9f:	89 f3                	mov    %esi,%ebx
  800ba1:	80 fb 19             	cmp    $0x19,%bl
  800ba4:	77 08                	ja     800bae <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ba6:	0f be d2             	movsbl %dl,%edx
  800ba9:	83 ea 37             	sub    $0x37,%edx
  800bac:	eb c1                	jmp    800b6f <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb2:	74 05                	je     800bb9 <strtol+0xd0>
		*endptr = (char *) s;
  800bb4:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bb7:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bb9:	89 c2                	mov    %eax,%edx
  800bbb:	f7 da                	neg    %edx
  800bbd:	85 ff                	test   %edi,%edi
  800bbf:	0f 45 c2             	cmovne %edx,%eax
}
  800bc2:	5b                   	pop    %ebx
  800bc3:	5e                   	pop    %esi
  800bc4:	5f                   	pop    %edi
  800bc5:	5d                   	pop    %ebp
  800bc6:	c3                   	ret    

00800bc7 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bc7:	f3 0f 1e fb          	endbr32 
  800bcb:	55                   	push   %ebp
  800bcc:	89 e5                	mov    %esp,%ebp
  800bce:	57                   	push   %edi
  800bcf:	56                   	push   %esi
  800bd0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd1:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bdc:	89 c3                	mov    %eax,%ebx
  800bde:	89 c7                	mov    %eax,%edi
  800be0:	89 c6                	mov    %eax,%esi
  800be2:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800be4:	5b                   	pop    %ebx
  800be5:	5e                   	pop    %esi
  800be6:	5f                   	pop    %edi
  800be7:	5d                   	pop    %ebp
  800be8:	c3                   	ret    

00800be9 <sys_cgetc>:

int
sys_cgetc(void)
{
  800be9:	f3 0f 1e fb          	endbr32 
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	57                   	push   %edi
  800bf1:	56                   	push   %esi
  800bf2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bf3:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf8:	b8 01 00 00 00       	mov    $0x1,%eax
  800bfd:	89 d1                	mov    %edx,%ecx
  800bff:	89 d3                	mov    %edx,%ebx
  800c01:	89 d7                	mov    %edx,%edi
  800c03:	89 d6                	mov    %edx,%esi
  800c05:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c07:	5b                   	pop    %ebx
  800c08:	5e                   	pop    %esi
  800c09:	5f                   	pop    %edi
  800c0a:	5d                   	pop    %ebp
  800c0b:	c3                   	ret    

00800c0c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c0c:	f3 0f 1e fb          	endbr32 
  800c10:	55                   	push   %ebp
  800c11:	89 e5                	mov    %esp,%ebp
  800c13:	57                   	push   %edi
  800c14:	56                   	push   %esi
  800c15:	53                   	push   %ebx
  800c16:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c19:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c21:	b8 03 00 00 00       	mov    $0x3,%eax
  800c26:	89 cb                	mov    %ecx,%ebx
  800c28:	89 cf                	mov    %ecx,%edi
  800c2a:	89 ce                	mov    %ecx,%esi
  800c2c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c2e:	85 c0                	test   %eax,%eax
  800c30:	7f 08                	jg     800c3a <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c32:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c35:	5b                   	pop    %ebx
  800c36:	5e                   	pop    %esi
  800c37:	5f                   	pop    %edi
  800c38:	5d                   	pop    %ebp
  800c39:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c3a:	83 ec 0c             	sub    $0xc,%esp
  800c3d:	50                   	push   %eax
  800c3e:	6a 03                	push   $0x3
  800c40:	68 9f 28 80 00       	push   $0x80289f
  800c45:	6a 23                	push   $0x23
  800c47:	68 bc 28 80 00       	push   $0x8028bc
  800c4c:	e8 13 f5 ff ff       	call   800164 <_panic>

00800c51 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c51:	f3 0f 1e fb          	endbr32 
  800c55:	55                   	push   %ebp
  800c56:	89 e5                	mov    %esp,%ebp
  800c58:	57                   	push   %edi
  800c59:	56                   	push   %esi
  800c5a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c5b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c60:	b8 02 00 00 00       	mov    $0x2,%eax
  800c65:	89 d1                	mov    %edx,%ecx
  800c67:	89 d3                	mov    %edx,%ebx
  800c69:	89 d7                	mov    %edx,%edi
  800c6b:	89 d6                	mov    %edx,%esi
  800c6d:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c6f:	5b                   	pop    %ebx
  800c70:	5e                   	pop    %esi
  800c71:	5f                   	pop    %edi
  800c72:	5d                   	pop    %ebp
  800c73:	c3                   	ret    

00800c74 <sys_yield>:

void
sys_yield(void)
{
  800c74:	f3 0f 1e fb          	endbr32 
  800c78:	55                   	push   %ebp
  800c79:	89 e5                	mov    %esp,%ebp
  800c7b:	57                   	push   %edi
  800c7c:	56                   	push   %esi
  800c7d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c7e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c83:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c88:	89 d1                	mov    %edx,%ecx
  800c8a:	89 d3                	mov    %edx,%ebx
  800c8c:	89 d7                	mov    %edx,%edi
  800c8e:	89 d6                	mov    %edx,%esi
  800c90:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c92:	5b                   	pop    %ebx
  800c93:	5e                   	pop    %esi
  800c94:	5f                   	pop    %edi
  800c95:	5d                   	pop    %ebp
  800c96:	c3                   	ret    

00800c97 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c97:	f3 0f 1e fb          	endbr32 
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
  800c9e:	57                   	push   %edi
  800c9f:	56                   	push   %esi
  800ca0:	53                   	push   %ebx
  800ca1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ca4:	be 00 00 00 00       	mov    $0x0,%esi
  800ca9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800caf:	b8 04 00 00 00       	mov    $0x4,%eax
  800cb4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cb7:	89 f7                	mov    %esi,%edi
  800cb9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cbb:	85 c0                	test   %eax,%eax
  800cbd:	7f 08                	jg     800cc7 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc2:	5b                   	pop    %ebx
  800cc3:	5e                   	pop    %esi
  800cc4:	5f                   	pop    %edi
  800cc5:	5d                   	pop    %ebp
  800cc6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc7:	83 ec 0c             	sub    $0xc,%esp
  800cca:	50                   	push   %eax
  800ccb:	6a 04                	push   $0x4
  800ccd:	68 9f 28 80 00       	push   $0x80289f
  800cd2:	6a 23                	push   $0x23
  800cd4:	68 bc 28 80 00       	push   $0x8028bc
  800cd9:	e8 86 f4 ff ff       	call   800164 <_panic>

00800cde <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cde:	f3 0f 1e fb          	endbr32 
  800ce2:	55                   	push   %ebp
  800ce3:	89 e5                	mov    %esp,%ebp
  800ce5:	57                   	push   %edi
  800ce6:	56                   	push   %esi
  800ce7:	53                   	push   %ebx
  800ce8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ceb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf1:	b8 05 00 00 00       	mov    $0x5,%eax
  800cf6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cf9:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cfc:	8b 75 18             	mov    0x18(%ebp),%esi
  800cff:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d01:	85 c0                	test   %eax,%eax
  800d03:	7f 08                	jg     800d0d <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d05:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d08:	5b                   	pop    %ebx
  800d09:	5e                   	pop    %esi
  800d0a:	5f                   	pop    %edi
  800d0b:	5d                   	pop    %ebp
  800d0c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0d:	83 ec 0c             	sub    $0xc,%esp
  800d10:	50                   	push   %eax
  800d11:	6a 05                	push   $0x5
  800d13:	68 9f 28 80 00       	push   $0x80289f
  800d18:	6a 23                	push   $0x23
  800d1a:	68 bc 28 80 00       	push   $0x8028bc
  800d1f:	e8 40 f4 ff ff       	call   800164 <_panic>

00800d24 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d24:	f3 0f 1e fb          	endbr32 
  800d28:	55                   	push   %ebp
  800d29:	89 e5                	mov    %esp,%ebp
  800d2b:	57                   	push   %edi
  800d2c:	56                   	push   %esi
  800d2d:	53                   	push   %ebx
  800d2e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d31:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d36:	8b 55 08             	mov    0x8(%ebp),%edx
  800d39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3c:	b8 06 00 00 00       	mov    $0x6,%eax
  800d41:	89 df                	mov    %ebx,%edi
  800d43:	89 de                	mov    %ebx,%esi
  800d45:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d47:	85 c0                	test   %eax,%eax
  800d49:	7f 08                	jg     800d53 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4e:	5b                   	pop    %ebx
  800d4f:	5e                   	pop    %esi
  800d50:	5f                   	pop    %edi
  800d51:	5d                   	pop    %ebp
  800d52:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d53:	83 ec 0c             	sub    $0xc,%esp
  800d56:	50                   	push   %eax
  800d57:	6a 06                	push   $0x6
  800d59:	68 9f 28 80 00       	push   $0x80289f
  800d5e:	6a 23                	push   $0x23
  800d60:	68 bc 28 80 00       	push   $0x8028bc
  800d65:	e8 fa f3 ff ff       	call   800164 <_panic>

00800d6a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d6a:	f3 0f 1e fb          	endbr32 
  800d6e:	55                   	push   %ebp
  800d6f:	89 e5                	mov    %esp,%ebp
  800d71:	57                   	push   %edi
  800d72:	56                   	push   %esi
  800d73:	53                   	push   %ebx
  800d74:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d77:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d82:	b8 08 00 00 00       	mov    $0x8,%eax
  800d87:	89 df                	mov    %ebx,%edi
  800d89:	89 de                	mov    %ebx,%esi
  800d8b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8d:	85 c0                	test   %eax,%eax
  800d8f:	7f 08                	jg     800d99 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  800d9d:	6a 08                	push   $0x8
  800d9f:	68 9f 28 80 00       	push   $0x80289f
  800da4:	6a 23                	push   $0x23
  800da6:	68 bc 28 80 00       	push   $0x8028bc
  800dab:	e8 b4 f3 ff ff       	call   800164 <_panic>

00800db0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800db0:	f3 0f 1e fb          	endbr32 
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	57                   	push   %edi
  800db8:	56                   	push   %esi
  800db9:	53                   	push   %ebx
  800dba:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dbd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc2:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc8:	b8 09 00 00 00       	mov    $0x9,%eax
  800dcd:	89 df                	mov    %ebx,%edi
  800dcf:	89 de                	mov    %ebx,%esi
  800dd1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd3:	85 c0                	test   %eax,%eax
  800dd5:	7f 08                	jg     800ddf <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
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
  800de3:	6a 09                	push   $0x9
  800de5:	68 9f 28 80 00       	push   $0x80289f
  800dea:	6a 23                	push   $0x23
  800dec:	68 bc 28 80 00       	push   $0x8028bc
  800df1:	e8 6e f3 ff ff       	call   800164 <_panic>

00800df6 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
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
  800e0e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e13:	89 df                	mov    %ebx,%edi
  800e15:	89 de                	mov    %ebx,%esi
  800e17:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e19:	85 c0                	test   %eax,%eax
  800e1b:	7f 08                	jg     800e25 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
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
  800e29:	6a 0a                	push   $0xa
  800e2b:	68 9f 28 80 00       	push   $0x80289f
  800e30:	6a 23                	push   $0x23
  800e32:	68 bc 28 80 00       	push   $0x8028bc
  800e37:	e8 28 f3 ff ff       	call   800164 <_panic>

00800e3c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e3c:	f3 0f 1e fb          	endbr32 
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	57                   	push   %edi
  800e44:	56                   	push   %esi
  800e45:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e46:	8b 55 08             	mov    0x8(%ebp),%edx
  800e49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4c:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e51:	be 00 00 00 00       	mov    $0x0,%esi
  800e56:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e59:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e5c:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e5e:	5b                   	pop    %ebx
  800e5f:	5e                   	pop    %esi
  800e60:	5f                   	pop    %edi
  800e61:	5d                   	pop    %ebp
  800e62:	c3                   	ret    

00800e63 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e63:	f3 0f 1e fb          	endbr32 
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	57                   	push   %edi
  800e6b:	56                   	push   %esi
  800e6c:	53                   	push   %ebx
  800e6d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e70:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e75:	8b 55 08             	mov    0x8(%ebp),%edx
  800e78:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e7d:	89 cb                	mov    %ecx,%ebx
  800e7f:	89 cf                	mov    %ecx,%edi
  800e81:	89 ce                	mov    %ecx,%esi
  800e83:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e85:	85 c0                	test   %eax,%eax
  800e87:	7f 08                	jg     800e91 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e89:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e8c:	5b                   	pop    %ebx
  800e8d:	5e                   	pop    %esi
  800e8e:	5f                   	pop    %edi
  800e8f:	5d                   	pop    %ebp
  800e90:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e91:	83 ec 0c             	sub    $0xc,%esp
  800e94:	50                   	push   %eax
  800e95:	6a 0d                	push   $0xd
  800e97:	68 9f 28 80 00       	push   $0x80289f
  800e9c:	6a 23                	push   $0x23
  800e9e:	68 bc 28 80 00       	push   $0x8028bc
  800ea3:	e8 bc f2 ff ff       	call   800164 <_panic>

00800ea8 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800ea8:	f3 0f 1e fb          	endbr32 
  800eac:	55                   	push   %ebp
  800ead:	89 e5                	mov    %esp,%ebp
  800eaf:	57                   	push   %edi
  800eb0:	56                   	push   %esi
  800eb1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eb2:	ba 00 00 00 00       	mov    $0x0,%edx
  800eb7:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ebc:	89 d1                	mov    %edx,%ecx
  800ebe:	89 d3                	mov    %edx,%ebx
  800ec0:	89 d7                	mov    %edx,%edi
  800ec2:	89 d6                	mov    %edx,%esi
  800ec4:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ec6:	5b                   	pop    %ebx
  800ec7:	5e                   	pop    %esi
  800ec8:	5f                   	pop    %edi
  800ec9:	5d                   	pop    %ebp
  800eca:	c3                   	ret    

00800ecb <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  800ecb:	f3 0f 1e fb          	endbr32 
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
  800ed2:	57                   	push   %edi
  800ed3:	56                   	push   %esi
  800ed4:	53                   	push   %ebx
  800ed5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800edd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee3:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ee8:	89 df                	mov    %ebx,%edi
  800eea:	89 de                	mov    %ebx,%esi
  800eec:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eee:	85 c0                	test   %eax,%eax
  800ef0:	7f 08                	jg     800efa <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  800ef2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef5:	5b                   	pop    %ebx
  800ef6:	5e                   	pop    %esi
  800ef7:	5f                   	pop    %edi
  800ef8:	5d                   	pop    %ebp
  800ef9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800efa:	83 ec 0c             	sub    $0xc,%esp
  800efd:	50                   	push   %eax
  800efe:	6a 0f                	push   $0xf
  800f00:	68 9f 28 80 00       	push   $0x80289f
  800f05:	6a 23                	push   $0x23
  800f07:	68 bc 28 80 00       	push   $0x8028bc
  800f0c:	e8 53 f2 ff ff       	call   800164 <_panic>

00800f11 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  800f11:	f3 0f 1e fb          	endbr32 
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
  800f18:	57                   	push   %edi
  800f19:	56                   	push   %esi
  800f1a:	53                   	push   %ebx
  800f1b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f1e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f23:	8b 55 08             	mov    0x8(%ebp),%edx
  800f26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f29:	b8 10 00 00 00       	mov    $0x10,%eax
  800f2e:	89 df                	mov    %ebx,%edi
  800f30:	89 de                	mov    %ebx,%esi
  800f32:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f34:	85 c0                	test   %eax,%eax
  800f36:	7f 08                	jg     800f40 <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  800f38:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f3b:	5b                   	pop    %ebx
  800f3c:	5e                   	pop    %esi
  800f3d:	5f                   	pop    %edi
  800f3e:	5d                   	pop    %ebp
  800f3f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f40:	83 ec 0c             	sub    $0xc,%esp
  800f43:	50                   	push   %eax
  800f44:	6a 10                	push   $0x10
  800f46:	68 9f 28 80 00       	push   $0x80289f
  800f4b:	6a 23                	push   $0x23
  800f4d:	68 bc 28 80 00       	push   $0x8028bc
  800f52:	e8 0d f2 ff ff       	call   800164 <_panic>

00800f57 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f57:	f3 0f 1e fb          	endbr32 
  800f5b:	55                   	push   %ebp
  800f5c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f61:	05 00 00 00 30       	add    $0x30000000,%eax
  800f66:	c1 e8 0c             	shr    $0xc,%eax
}
  800f69:	5d                   	pop    %ebp
  800f6a:	c3                   	ret    

00800f6b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f6b:	f3 0f 1e fb          	endbr32 
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f72:	8b 45 08             	mov    0x8(%ebp),%eax
  800f75:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800f7a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f7f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f84:	5d                   	pop    %ebp
  800f85:	c3                   	ret    

00800f86 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f86:	f3 0f 1e fb          	endbr32 
  800f8a:	55                   	push   %ebp
  800f8b:	89 e5                	mov    %esp,%ebp
  800f8d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f92:	89 c2                	mov    %eax,%edx
  800f94:	c1 ea 16             	shr    $0x16,%edx
  800f97:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f9e:	f6 c2 01             	test   $0x1,%dl
  800fa1:	74 2d                	je     800fd0 <fd_alloc+0x4a>
  800fa3:	89 c2                	mov    %eax,%edx
  800fa5:	c1 ea 0c             	shr    $0xc,%edx
  800fa8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800faf:	f6 c2 01             	test   $0x1,%dl
  800fb2:	74 1c                	je     800fd0 <fd_alloc+0x4a>
  800fb4:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800fb9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800fbe:	75 d2                	jne    800f92 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800fc9:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800fce:	eb 0a                	jmp    800fda <fd_alloc+0x54>
			*fd_store = fd;
  800fd0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fd3:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fda:	5d                   	pop    %ebp
  800fdb:	c3                   	ret    

00800fdc <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800fdc:	f3 0f 1e fb          	endbr32 
  800fe0:	55                   	push   %ebp
  800fe1:	89 e5                	mov    %esp,%ebp
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800fe6:	83 f8 1f             	cmp    $0x1f,%eax
  800fe9:	77 30                	ja     80101b <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800feb:	c1 e0 0c             	shl    $0xc,%eax
  800fee:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800ff3:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800ff9:	f6 c2 01             	test   $0x1,%dl
  800ffc:	74 24                	je     801022 <fd_lookup+0x46>
  800ffe:	89 c2                	mov    %eax,%edx
  801000:	c1 ea 0c             	shr    $0xc,%edx
  801003:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80100a:	f6 c2 01             	test   $0x1,%dl
  80100d:	74 1a                	je     801029 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80100f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801012:	89 02                	mov    %eax,(%edx)
	return 0;
  801014:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801019:	5d                   	pop    %ebp
  80101a:	c3                   	ret    
		return -E_INVAL;
  80101b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801020:	eb f7                	jmp    801019 <fd_lookup+0x3d>
		return -E_INVAL;
  801022:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801027:	eb f0                	jmp    801019 <fd_lookup+0x3d>
  801029:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80102e:	eb e9                	jmp    801019 <fd_lookup+0x3d>

00801030 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801030:	f3 0f 1e fb          	endbr32 
  801034:	55                   	push   %ebp
  801035:	89 e5                	mov    %esp,%ebp
  801037:	83 ec 08             	sub    $0x8,%esp
  80103a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80103d:	ba 00 00 00 00       	mov    $0x0,%edx
  801042:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801047:	39 08                	cmp    %ecx,(%eax)
  801049:	74 38                	je     801083 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  80104b:	83 c2 01             	add    $0x1,%edx
  80104e:	8b 04 95 48 29 80 00 	mov    0x802948(,%edx,4),%eax
  801055:	85 c0                	test   %eax,%eax
  801057:	75 ee                	jne    801047 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801059:	a1 08 40 80 00       	mov    0x804008,%eax
  80105e:	8b 40 48             	mov    0x48(%eax),%eax
  801061:	83 ec 04             	sub    $0x4,%esp
  801064:	51                   	push   %ecx
  801065:	50                   	push   %eax
  801066:	68 cc 28 80 00       	push   $0x8028cc
  80106b:	e8 db f1 ff ff       	call   80024b <cprintf>
	*dev = 0;
  801070:	8b 45 0c             	mov    0xc(%ebp),%eax
  801073:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801079:	83 c4 10             	add    $0x10,%esp
  80107c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801081:	c9                   	leave  
  801082:	c3                   	ret    
			*dev = devtab[i];
  801083:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801086:	89 01                	mov    %eax,(%ecx)
			return 0;
  801088:	b8 00 00 00 00       	mov    $0x0,%eax
  80108d:	eb f2                	jmp    801081 <dev_lookup+0x51>

0080108f <fd_close>:
{
  80108f:	f3 0f 1e fb          	endbr32 
  801093:	55                   	push   %ebp
  801094:	89 e5                	mov    %esp,%ebp
  801096:	57                   	push   %edi
  801097:	56                   	push   %esi
  801098:	53                   	push   %ebx
  801099:	83 ec 24             	sub    $0x24,%esp
  80109c:	8b 75 08             	mov    0x8(%ebp),%esi
  80109f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010a2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010a5:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010a6:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8010ac:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010af:	50                   	push   %eax
  8010b0:	e8 27 ff ff ff       	call   800fdc <fd_lookup>
  8010b5:	89 c3                	mov    %eax,%ebx
  8010b7:	83 c4 10             	add    $0x10,%esp
  8010ba:	85 c0                	test   %eax,%eax
  8010bc:	78 05                	js     8010c3 <fd_close+0x34>
	    || fd != fd2)
  8010be:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8010c1:	74 16                	je     8010d9 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8010c3:	89 f8                	mov    %edi,%eax
  8010c5:	84 c0                	test   %al,%al
  8010c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8010cc:	0f 44 d8             	cmove  %eax,%ebx
}
  8010cf:	89 d8                	mov    %ebx,%eax
  8010d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010d4:	5b                   	pop    %ebx
  8010d5:	5e                   	pop    %esi
  8010d6:	5f                   	pop    %edi
  8010d7:	5d                   	pop    %ebp
  8010d8:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8010d9:	83 ec 08             	sub    $0x8,%esp
  8010dc:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8010df:	50                   	push   %eax
  8010e0:	ff 36                	pushl  (%esi)
  8010e2:	e8 49 ff ff ff       	call   801030 <dev_lookup>
  8010e7:	89 c3                	mov    %eax,%ebx
  8010e9:	83 c4 10             	add    $0x10,%esp
  8010ec:	85 c0                	test   %eax,%eax
  8010ee:	78 1a                	js     80110a <fd_close+0x7b>
		if (dev->dev_close)
  8010f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010f3:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8010f6:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8010fb:	85 c0                	test   %eax,%eax
  8010fd:	74 0b                	je     80110a <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8010ff:	83 ec 0c             	sub    $0xc,%esp
  801102:	56                   	push   %esi
  801103:	ff d0                	call   *%eax
  801105:	89 c3                	mov    %eax,%ebx
  801107:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80110a:	83 ec 08             	sub    $0x8,%esp
  80110d:	56                   	push   %esi
  80110e:	6a 00                	push   $0x0
  801110:	e8 0f fc ff ff       	call   800d24 <sys_page_unmap>
	return r;
  801115:	83 c4 10             	add    $0x10,%esp
  801118:	eb b5                	jmp    8010cf <fd_close+0x40>

0080111a <close>:

int
close(int fdnum)
{
  80111a:	f3 0f 1e fb          	endbr32 
  80111e:	55                   	push   %ebp
  80111f:	89 e5                	mov    %esp,%ebp
  801121:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801124:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801127:	50                   	push   %eax
  801128:	ff 75 08             	pushl  0x8(%ebp)
  80112b:	e8 ac fe ff ff       	call   800fdc <fd_lookup>
  801130:	83 c4 10             	add    $0x10,%esp
  801133:	85 c0                	test   %eax,%eax
  801135:	79 02                	jns    801139 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801137:	c9                   	leave  
  801138:	c3                   	ret    
		return fd_close(fd, 1);
  801139:	83 ec 08             	sub    $0x8,%esp
  80113c:	6a 01                	push   $0x1
  80113e:	ff 75 f4             	pushl  -0xc(%ebp)
  801141:	e8 49 ff ff ff       	call   80108f <fd_close>
  801146:	83 c4 10             	add    $0x10,%esp
  801149:	eb ec                	jmp    801137 <close+0x1d>

0080114b <close_all>:

void
close_all(void)
{
  80114b:	f3 0f 1e fb          	endbr32 
  80114f:	55                   	push   %ebp
  801150:	89 e5                	mov    %esp,%ebp
  801152:	53                   	push   %ebx
  801153:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801156:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80115b:	83 ec 0c             	sub    $0xc,%esp
  80115e:	53                   	push   %ebx
  80115f:	e8 b6 ff ff ff       	call   80111a <close>
	for (i = 0; i < MAXFD; i++)
  801164:	83 c3 01             	add    $0x1,%ebx
  801167:	83 c4 10             	add    $0x10,%esp
  80116a:	83 fb 20             	cmp    $0x20,%ebx
  80116d:	75 ec                	jne    80115b <close_all+0x10>
}
  80116f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801172:	c9                   	leave  
  801173:	c3                   	ret    

00801174 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801174:	f3 0f 1e fb          	endbr32 
  801178:	55                   	push   %ebp
  801179:	89 e5                	mov    %esp,%ebp
  80117b:	57                   	push   %edi
  80117c:	56                   	push   %esi
  80117d:	53                   	push   %ebx
  80117e:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801181:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801184:	50                   	push   %eax
  801185:	ff 75 08             	pushl  0x8(%ebp)
  801188:	e8 4f fe ff ff       	call   800fdc <fd_lookup>
  80118d:	89 c3                	mov    %eax,%ebx
  80118f:	83 c4 10             	add    $0x10,%esp
  801192:	85 c0                	test   %eax,%eax
  801194:	0f 88 81 00 00 00    	js     80121b <dup+0xa7>
		return r;
	close(newfdnum);
  80119a:	83 ec 0c             	sub    $0xc,%esp
  80119d:	ff 75 0c             	pushl  0xc(%ebp)
  8011a0:	e8 75 ff ff ff       	call   80111a <close>

	newfd = INDEX2FD(newfdnum);
  8011a5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011a8:	c1 e6 0c             	shl    $0xc,%esi
  8011ab:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8011b1:	83 c4 04             	add    $0x4,%esp
  8011b4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011b7:	e8 af fd ff ff       	call   800f6b <fd2data>
  8011bc:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8011be:	89 34 24             	mov    %esi,(%esp)
  8011c1:	e8 a5 fd ff ff       	call   800f6b <fd2data>
  8011c6:	83 c4 10             	add    $0x10,%esp
  8011c9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8011cb:	89 d8                	mov    %ebx,%eax
  8011cd:	c1 e8 16             	shr    $0x16,%eax
  8011d0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011d7:	a8 01                	test   $0x1,%al
  8011d9:	74 11                	je     8011ec <dup+0x78>
  8011db:	89 d8                	mov    %ebx,%eax
  8011dd:	c1 e8 0c             	shr    $0xc,%eax
  8011e0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011e7:	f6 c2 01             	test   $0x1,%dl
  8011ea:	75 39                	jne    801225 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8011ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011ef:	89 d0                	mov    %edx,%eax
  8011f1:	c1 e8 0c             	shr    $0xc,%eax
  8011f4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011fb:	83 ec 0c             	sub    $0xc,%esp
  8011fe:	25 07 0e 00 00       	and    $0xe07,%eax
  801203:	50                   	push   %eax
  801204:	56                   	push   %esi
  801205:	6a 00                	push   $0x0
  801207:	52                   	push   %edx
  801208:	6a 00                	push   $0x0
  80120a:	e8 cf fa ff ff       	call   800cde <sys_page_map>
  80120f:	89 c3                	mov    %eax,%ebx
  801211:	83 c4 20             	add    $0x20,%esp
  801214:	85 c0                	test   %eax,%eax
  801216:	78 31                	js     801249 <dup+0xd5>
		goto err;

	return newfdnum;
  801218:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80121b:	89 d8                	mov    %ebx,%eax
  80121d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801220:	5b                   	pop    %ebx
  801221:	5e                   	pop    %esi
  801222:	5f                   	pop    %edi
  801223:	5d                   	pop    %ebp
  801224:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801225:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80122c:	83 ec 0c             	sub    $0xc,%esp
  80122f:	25 07 0e 00 00       	and    $0xe07,%eax
  801234:	50                   	push   %eax
  801235:	57                   	push   %edi
  801236:	6a 00                	push   $0x0
  801238:	53                   	push   %ebx
  801239:	6a 00                	push   $0x0
  80123b:	e8 9e fa ff ff       	call   800cde <sys_page_map>
  801240:	89 c3                	mov    %eax,%ebx
  801242:	83 c4 20             	add    $0x20,%esp
  801245:	85 c0                	test   %eax,%eax
  801247:	79 a3                	jns    8011ec <dup+0x78>
	sys_page_unmap(0, newfd);
  801249:	83 ec 08             	sub    $0x8,%esp
  80124c:	56                   	push   %esi
  80124d:	6a 00                	push   $0x0
  80124f:	e8 d0 fa ff ff       	call   800d24 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801254:	83 c4 08             	add    $0x8,%esp
  801257:	57                   	push   %edi
  801258:	6a 00                	push   $0x0
  80125a:	e8 c5 fa ff ff       	call   800d24 <sys_page_unmap>
	return r;
  80125f:	83 c4 10             	add    $0x10,%esp
  801262:	eb b7                	jmp    80121b <dup+0xa7>

00801264 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801264:	f3 0f 1e fb          	endbr32 
  801268:	55                   	push   %ebp
  801269:	89 e5                	mov    %esp,%ebp
  80126b:	53                   	push   %ebx
  80126c:	83 ec 1c             	sub    $0x1c,%esp
  80126f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801272:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801275:	50                   	push   %eax
  801276:	53                   	push   %ebx
  801277:	e8 60 fd ff ff       	call   800fdc <fd_lookup>
  80127c:	83 c4 10             	add    $0x10,%esp
  80127f:	85 c0                	test   %eax,%eax
  801281:	78 3f                	js     8012c2 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801283:	83 ec 08             	sub    $0x8,%esp
  801286:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801289:	50                   	push   %eax
  80128a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80128d:	ff 30                	pushl  (%eax)
  80128f:	e8 9c fd ff ff       	call   801030 <dev_lookup>
  801294:	83 c4 10             	add    $0x10,%esp
  801297:	85 c0                	test   %eax,%eax
  801299:	78 27                	js     8012c2 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80129b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80129e:	8b 42 08             	mov    0x8(%edx),%eax
  8012a1:	83 e0 03             	and    $0x3,%eax
  8012a4:	83 f8 01             	cmp    $0x1,%eax
  8012a7:	74 1e                	je     8012c7 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8012a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ac:	8b 40 08             	mov    0x8(%eax),%eax
  8012af:	85 c0                	test   %eax,%eax
  8012b1:	74 35                	je     8012e8 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012b3:	83 ec 04             	sub    $0x4,%esp
  8012b6:	ff 75 10             	pushl  0x10(%ebp)
  8012b9:	ff 75 0c             	pushl  0xc(%ebp)
  8012bc:	52                   	push   %edx
  8012bd:	ff d0                	call   *%eax
  8012bf:	83 c4 10             	add    $0x10,%esp
}
  8012c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012c5:	c9                   	leave  
  8012c6:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8012c7:	a1 08 40 80 00       	mov    0x804008,%eax
  8012cc:	8b 40 48             	mov    0x48(%eax),%eax
  8012cf:	83 ec 04             	sub    $0x4,%esp
  8012d2:	53                   	push   %ebx
  8012d3:	50                   	push   %eax
  8012d4:	68 0d 29 80 00       	push   $0x80290d
  8012d9:	e8 6d ef ff ff       	call   80024b <cprintf>
		return -E_INVAL;
  8012de:	83 c4 10             	add    $0x10,%esp
  8012e1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012e6:	eb da                	jmp    8012c2 <read+0x5e>
		return -E_NOT_SUPP;
  8012e8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012ed:	eb d3                	jmp    8012c2 <read+0x5e>

008012ef <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8012ef:	f3 0f 1e fb          	endbr32 
  8012f3:	55                   	push   %ebp
  8012f4:	89 e5                	mov    %esp,%ebp
  8012f6:	57                   	push   %edi
  8012f7:	56                   	push   %esi
  8012f8:	53                   	push   %ebx
  8012f9:	83 ec 0c             	sub    $0xc,%esp
  8012fc:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012ff:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801302:	bb 00 00 00 00       	mov    $0x0,%ebx
  801307:	eb 02                	jmp    80130b <readn+0x1c>
  801309:	01 c3                	add    %eax,%ebx
  80130b:	39 f3                	cmp    %esi,%ebx
  80130d:	73 21                	jae    801330 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80130f:	83 ec 04             	sub    $0x4,%esp
  801312:	89 f0                	mov    %esi,%eax
  801314:	29 d8                	sub    %ebx,%eax
  801316:	50                   	push   %eax
  801317:	89 d8                	mov    %ebx,%eax
  801319:	03 45 0c             	add    0xc(%ebp),%eax
  80131c:	50                   	push   %eax
  80131d:	57                   	push   %edi
  80131e:	e8 41 ff ff ff       	call   801264 <read>
		if (m < 0)
  801323:	83 c4 10             	add    $0x10,%esp
  801326:	85 c0                	test   %eax,%eax
  801328:	78 04                	js     80132e <readn+0x3f>
			return m;
		if (m == 0)
  80132a:	75 dd                	jne    801309 <readn+0x1a>
  80132c:	eb 02                	jmp    801330 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80132e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801330:	89 d8                	mov    %ebx,%eax
  801332:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801335:	5b                   	pop    %ebx
  801336:	5e                   	pop    %esi
  801337:	5f                   	pop    %edi
  801338:	5d                   	pop    %ebp
  801339:	c3                   	ret    

0080133a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80133a:	f3 0f 1e fb          	endbr32 
  80133e:	55                   	push   %ebp
  80133f:	89 e5                	mov    %esp,%ebp
  801341:	53                   	push   %ebx
  801342:	83 ec 1c             	sub    $0x1c,%esp
  801345:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801348:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80134b:	50                   	push   %eax
  80134c:	53                   	push   %ebx
  80134d:	e8 8a fc ff ff       	call   800fdc <fd_lookup>
  801352:	83 c4 10             	add    $0x10,%esp
  801355:	85 c0                	test   %eax,%eax
  801357:	78 3a                	js     801393 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801359:	83 ec 08             	sub    $0x8,%esp
  80135c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80135f:	50                   	push   %eax
  801360:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801363:	ff 30                	pushl  (%eax)
  801365:	e8 c6 fc ff ff       	call   801030 <dev_lookup>
  80136a:	83 c4 10             	add    $0x10,%esp
  80136d:	85 c0                	test   %eax,%eax
  80136f:	78 22                	js     801393 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801371:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801374:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801378:	74 1e                	je     801398 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80137a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80137d:	8b 52 0c             	mov    0xc(%edx),%edx
  801380:	85 d2                	test   %edx,%edx
  801382:	74 35                	je     8013b9 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801384:	83 ec 04             	sub    $0x4,%esp
  801387:	ff 75 10             	pushl  0x10(%ebp)
  80138a:	ff 75 0c             	pushl  0xc(%ebp)
  80138d:	50                   	push   %eax
  80138e:	ff d2                	call   *%edx
  801390:	83 c4 10             	add    $0x10,%esp
}
  801393:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801396:	c9                   	leave  
  801397:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801398:	a1 08 40 80 00       	mov    0x804008,%eax
  80139d:	8b 40 48             	mov    0x48(%eax),%eax
  8013a0:	83 ec 04             	sub    $0x4,%esp
  8013a3:	53                   	push   %ebx
  8013a4:	50                   	push   %eax
  8013a5:	68 29 29 80 00       	push   $0x802929
  8013aa:	e8 9c ee ff ff       	call   80024b <cprintf>
		return -E_INVAL;
  8013af:	83 c4 10             	add    $0x10,%esp
  8013b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013b7:	eb da                	jmp    801393 <write+0x59>
		return -E_NOT_SUPP;
  8013b9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013be:	eb d3                	jmp    801393 <write+0x59>

008013c0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8013c0:	f3 0f 1e fb          	endbr32 
  8013c4:	55                   	push   %ebp
  8013c5:	89 e5                	mov    %esp,%ebp
  8013c7:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013cd:	50                   	push   %eax
  8013ce:	ff 75 08             	pushl  0x8(%ebp)
  8013d1:	e8 06 fc ff ff       	call   800fdc <fd_lookup>
  8013d6:	83 c4 10             	add    $0x10,%esp
  8013d9:	85 c0                	test   %eax,%eax
  8013db:	78 0e                	js     8013eb <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8013dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013e3:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8013e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013eb:	c9                   	leave  
  8013ec:	c3                   	ret    

008013ed <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8013ed:	f3 0f 1e fb          	endbr32 
  8013f1:	55                   	push   %ebp
  8013f2:	89 e5                	mov    %esp,%ebp
  8013f4:	53                   	push   %ebx
  8013f5:	83 ec 1c             	sub    $0x1c,%esp
  8013f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013fb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013fe:	50                   	push   %eax
  8013ff:	53                   	push   %ebx
  801400:	e8 d7 fb ff ff       	call   800fdc <fd_lookup>
  801405:	83 c4 10             	add    $0x10,%esp
  801408:	85 c0                	test   %eax,%eax
  80140a:	78 37                	js     801443 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80140c:	83 ec 08             	sub    $0x8,%esp
  80140f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801412:	50                   	push   %eax
  801413:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801416:	ff 30                	pushl  (%eax)
  801418:	e8 13 fc ff ff       	call   801030 <dev_lookup>
  80141d:	83 c4 10             	add    $0x10,%esp
  801420:	85 c0                	test   %eax,%eax
  801422:	78 1f                	js     801443 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801424:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801427:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80142b:	74 1b                	je     801448 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80142d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801430:	8b 52 18             	mov    0x18(%edx),%edx
  801433:	85 d2                	test   %edx,%edx
  801435:	74 32                	je     801469 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801437:	83 ec 08             	sub    $0x8,%esp
  80143a:	ff 75 0c             	pushl  0xc(%ebp)
  80143d:	50                   	push   %eax
  80143e:	ff d2                	call   *%edx
  801440:	83 c4 10             	add    $0x10,%esp
}
  801443:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801446:	c9                   	leave  
  801447:	c3                   	ret    
			thisenv->env_id, fdnum);
  801448:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80144d:	8b 40 48             	mov    0x48(%eax),%eax
  801450:	83 ec 04             	sub    $0x4,%esp
  801453:	53                   	push   %ebx
  801454:	50                   	push   %eax
  801455:	68 ec 28 80 00       	push   $0x8028ec
  80145a:	e8 ec ed ff ff       	call   80024b <cprintf>
		return -E_INVAL;
  80145f:	83 c4 10             	add    $0x10,%esp
  801462:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801467:	eb da                	jmp    801443 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801469:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80146e:	eb d3                	jmp    801443 <ftruncate+0x56>

00801470 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801470:	f3 0f 1e fb          	endbr32 
  801474:	55                   	push   %ebp
  801475:	89 e5                	mov    %esp,%ebp
  801477:	53                   	push   %ebx
  801478:	83 ec 1c             	sub    $0x1c,%esp
  80147b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80147e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801481:	50                   	push   %eax
  801482:	ff 75 08             	pushl  0x8(%ebp)
  801485:	e8 52 fb ff ff       	call   800fdc <fd_lookup>
  80148a:	83 c4 10             	add    $0x10,%esp
  80148d:	85 c0                	test   %eax,%eax
  80148f:	78 4b                	js     8014dc <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801491:	83 ec 08             	sub    $0x8,%esp
  801494:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801497:	50                   	push   %eax
  801498:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80149b:	ff 30                	pushl  (%eax)
  80149d:	e8 8e fb ff ff       	call   801030 <dev_lookup>
  8014a2:	83 c4 10             	add    $0x10,%esp
  8014a5:	85 c0                	test   %eax,%eax
  8014a7:	78 33                	js     8014dc <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8014a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ac:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014b0:	74 2f                	je     8014e1 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014b2:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014b5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014bc:	00 00 00 
	stat->st_isdir = 0;
  8014bf:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014c6:	00 00 00 
	stat->st_dev = dev;
  8014c9:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014cf:	83 ec 08             	sub    $0x8,%esp
  8014d2:	53                   	push   %ebx
  8014d3:	ff 75 f0             	pushl  -0x10(%ebp)
  8014d6:	ff 50 14             	call   *0x14(%eax)
  8014d9:	83 c4 10             	add    $0x10,%esp
}
  8014dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014df:	c9                   	leave  
  8014e0:	c3                   	ret    
		return -E_NOT_SUPP;
  8014e1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014e6:	eb f4                	jmp    8014dc <fstat+0x6c>

008014e8 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8014e8:	f3 0f 1e fb          	endbr32 
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
  8014ef:	56                   	push   %esi
  8014f0:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8014f1:	83 ec 08             	sub    $0x8,%esp
  8014f4:	6a 00                	push   $0x0
  8014f6:	ff 75 08             	pushl  0x8(%ebp)
  8014f9:	e8 fb 01 00 00       	call   8016f9 <open>
  8014fe:	89 c3                	mov    %eax,%ebx
  801500:	83 c4 10             	add    $0x10,%esp
  801503:	85 c0                	test   %eax,%eax
  801505:	78 1b                	js     801522 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801507:	83 ec 08             	sub    $0x8,%esp
  80150a:	ff 75 0c             	pushl  0xc(%ebp)
  80150d:	50                   	push   %eax
  80150e:	e8 5d ff ff ff       	call   801470 <fstat>
  801513:	89 c6                	mov    %eax,%esi
	close(fd);
  801515:	89 1c 24             	mov    %ebx,(%esp)
  801518:	e8 fd fb ff ff       	call   80111a <close>
	return r;
  80151d:	83 c4 10             	add    $0x10,%esp
  801520:	89 f3                	mov    %esi,%ebx
}
  801522:	89 d8                	mov    %ebx,%eax
  801524:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801527:	5b                   	pop    %ebx
  801528:	5e                   	pop    %esi
  801529:	5d                   	pop    %ebp
  80152a:	c3                   	ret    

0080152b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80152b:	55                   	push   %ebp
  80152c:	89 e5                	mov    %esp,%ebp
  80152e:	56                   	push   %esi
  80152f:	53                   	push   %ebx
  801530:	89 c6                	mov    %eax,%esi
  801532:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801534:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80153b:	74 27                	je     801564 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80153d:	6a 07                	push   $0x7
  80153f:	68 00 50 80 00       	push   $0x805000
  801544:	56                   	push   %esi
  801545:	ff 35 00 40 80 00    	pushl  0x804000
  80154b:	e8 8e 0c 00 00       	call   8021de <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801550:	83 c4 0c             	add    $0xc,%esp
  801553:	6a 00                	push   $0x0
  801555:	53                   	push   %ebx
  801556:	6a 00                	push   $0x0
  801558:	e8 fc 0b 00 00       	call   802159 <ipc_recv>
}
  80155d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801560:	5b                   	pop    %ebx
  801561:	5e                   	pop    %esi
  801562:	5d                   	pop    %ebp
  801563:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801564:	83 ec 0c             	sub    $0xc,%esp
  801567:	6a 01                	push   $0x1
  801569:	e8 c8 0c 00 00       	call   802236 <ipc_find_env>
  80156e:	a3 00 40 80 00       	mov    %eax,0x804000
  801573:	83 c4 10             	add    $0x10,%esp
  801576:	eb c5                	jmp    80153d <fsipc+0x12>

00801578 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801578:	f3 0f 1e fb          	endbr32 
  80157c:	55                   	push   %ebp
  80157d:	89 e5                	mov    %esp,%ebp
  80157f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801582:	8b 45 08             	mov    0x8(%ebp),%eax
  801585:	8b 40 0c             	mov    0xc(%eax),%eax
  801588:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80158d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801590:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801595:	ba 00 00 00 00       	mov    $0x0,%edx
  80159a:	b8 02 00 00 00       	mov    $0x2,%eax
  80159f:	e8 87 ff ff ff       	call   80152b <fsipc>
}
  8015a4:	c9                   	leave  
  8015a5:	c3                   	ret    

008015a6 <devfile_flush>:
{
  8015a6:	f3 0f 1e fb          	endbr32 
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
  8015ad:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8015b6:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c0:	b8 06 00 00 00       	mov    $0x6,%eax
  8015c5:	e8 61 ff ff ff       	call   80152b <fsipc>
}
  8015ca:	c9                   	leave  
  8015cb:	c3                   	ret    

008015cc <devfile_stat>:
{
  8015cc:	f3 0f 1e fb          	endbr32 
  8015d0:	55                   	push   %ebp
  8015d1:	89 e5                	mov    %esp,%ebp
  8015d3:	53                   	push   %ebx
  8015d4:	83 ec 04             	sub    $0x4,%esp
  8015d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015da:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8015e0:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ea:	b8 05 00 00 00       	mov    $0x5,%eax
  8015ef:	e8 37 ff ff ff       	call   80152b <fsipc>
  8015f4:	85 c0                	test   %eax,%eax
  8015f6:	78 2c                	js     801624 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8015f8:	83 ec 08             	sub    $0x8,%esp
  8015fb:	68 00 50 80 00       	push   $0x805000
  801600:	53                   	push   %ebx
  801601:	e8 4f f2 ff ff       	call   800855 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801606:	a1 80 50 80 00       	mov    0x805080,%eax
  80160b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801611:	a1 84 50 80 00       	mov    0x805084,%eax
  801616:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80161c:	83 c4 10             	add    $0x10,%esp
  80161f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801624:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801627:	c9                   	leave  
  801628:	c3                   	ret    

00801629 <devfile_write>:
{
  801629:	f3 0f 1e fb          	endbr32 
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
  801630:	83 ec 0c             	sub    $0xc,%esp
  801633:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801636:	8b 55 08             	mov    0x8(%ebp),%edx
  801639:	8b 52 0c             	mov    0xc(%edx),%edx
  80163c:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801642:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801647:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80164c:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  80164f:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801654:	50                   	push   %eax
  801655:	ff 75 0c             	pushl  0xc(%ebp)
  801658:	68 08 50 80 00       	push   $0x805008
  80165d:	e8 a9 f3 ff ff       	call   800a0b <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801662:	ba 00 00 00 00       	mov    $0x0,%edx
  801667:	b8 04 00 00 00       	mov    $0x4,%eax
  80166c:	e8 ba fe ff ff       	call   80152b <fsipc>
}
  801671:	c9                   	leave  
  801672:	c3                   	ret    

00801673 <devfile_read>:
{
  801673:	f3 0f 1e fb          	endbr32 
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
  80167a:	56                   	push   %esi
  80167b:	53                   	push   %ebx
  80167c:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80167f:	8b 45 08             	mov    0x8(%ebp),%eax
  801682:	8b 40 0c             	mov    0xc(%eax),%eax
  801685:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80168a:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801690:	ba 00 00 00 00       	mov    $0x0,%edx
  801695:	b8 03 00 00 00       	mov    $0x3,%eax
  80169a:	e8 8c fe ff ff       	call   80152b <fsipc>
  80169f:	89 c3                	mov    %eax,%ebx
  8016a1:	85 c0                	test   %eax,%eax
  8016a3:	78 1f                	js     8016c4 <devfile_read+0x51>
	assert(r <= n);
  8016a5:	39 f0                	cmp    %esi,%eax
  8016a7:	77 24                	ja     8016cd <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8016a9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016ae:	7f 33                	jg     8016e3 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8016b0:	83 ec 04             	sub    $0x4,%esp
  8016b3:	50                   	push   %eax
  8016b4:	68 00 50 80 00       	push   $0x805000
  8016b9:	ff 75 0c             	pushl  0xc(%ebp)
  8016bc:	e8 4a f3 ff ff       	call   800a0b <memmove>
	return r;
  8016c1:	83 c4 10             	add    $0x10,%esp
}
  8016c4:	89 d8                	mov    %ebx,%eax
  8016c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016c9:	5b                   	pop    %ebx
  8016ca:	5e                   	pop    %esi
  8016cb:	5d                   	pop    %ebp
  8016cc:	c3                   	ret    
	assert(r <= n);
  8016cd:	68 5c 29 80 00       	push   $0x80295c
  8016d2:	68 63 29 80 00       	push   $0x802963
  8016d7:	6a 7c                	push   $0x7c
  8016d9:	68 78 29 80 00       	push   $0x802978
  8016de:	e8 81 ea ff ff       	call   800164 <_panic>
	assert(r <= PGSIZE);
  8016e3:	68 83 29 80 00       	push   $0x802983
  8016e8:	68 63 29 80 00       	push   $0x802963
  8016ed:	6a 7d                	push   $0x7d
  8016ef:	68 78 29 80 00       	push   $0x802978
  8016f4:	e8 6b ea ff ff       	call   800164 <_panic>

008016f9 <open>:
{
  8016f9:	f3 0f 1e fb          	endbr32 
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
  801700:	56                   	push   %esi
  801701:	53                   	push   %ebx
  801702:	83 ec 1c             	sub    $0x1c,%esp
  801705:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801708:	56                   	push   %esi
  801709:	e8 04 f1 ff ff       	call   800812 <strlen>
  80170e:	83 c4 10             	add    $0x10,%esp
  801711:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801716:	7f 6c                	jg     801784 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801718:	83 ec 0c             	sub    $0xc,%esp
  80171b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80171e:	50                   	push   %eax
  80171f:	e8 62 f8 ff ff       	call   800f86 <fd_alloc>
  801724:	89 c3                	mov    %eax,%ebx
  801726:	83 c4 10             	add    $0x10,%esp
  801729:	85 c0                	test   %eax,%eax
  80172b:	78 3c                	js     801769 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  80172d:	83 ec 08             	sub    $0x8,%esp
  801730:	56                   	push   %esi
  801731:	68 00 50 80 00       	push   $0x805000
  801736:	e8 1a f1 ff ff       	call   800855 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80173b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80173e:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801743:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801746:	b8 01 00 00 00       	mov    $0x1,%eax
  80174b:	e8 db fd ff ff       	call   80152b <fsipc>
  801750:	89 c3                	mov    %eax,%ebx
  801752:	83 c4 10             	add    $0x10,%esp
  801755:	85 c0                	test   %eax,%eax
  801757:	78 19                	js     801772 <open+0x79>
	return fd2num(fd);
  801759:	83 ec 0c             	sub    $0xc,%esp
  80175c:	ff 75 f4             	pushl  -0xc(%ebp)
  80175f:	e8 f3 f7 ff ff       	call   800f57 <fd2num>
  801764:	89 c3                	mov    %eax,%ebx
  801766:	83 c4 10             	add    $0x10,%esp
}
  801769:	89 d8                	mov    %ebx,%eax
  80176b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80176e:	5b                   	pop    %ebx
  80176f:	5e                   	pop    %esi
  801770:	5d                   	pop    %ebp
  801771:	c3                   	ret    
		fd_close(fd, 0);
  801772:	83 ec 08             	sub    $0x8,%esp
  801775:	6a 00                	push   $0x0
  801777:	ff 75 f4             	pushl  -0xc(%ebp)
  80177a:	e8 10 f9 ff ff       	call   80108f <fd_close>
		return r;
  80177f:	83 c4 10             	add    $0x10,%esp
  801782:	eb e5                	jmp    801769 <open+0x70>
		return -E_BAD_PATH;
  801784:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801789:	eb de                	jmp    801769 <open+0x70>

0080178b <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80178b:	f3 0f 1e fb          	endbr32 
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
  801792:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801795:	ba 00 00 00 00       	mov    $0x0,%edx
  80179a:	b8 08 00 00 00       	mov    $0x8,%eax
  80179f:	e8 87 fd ff ff       	call   80152b <fsipc>
}
  8017a4:	c9                   	leave  
  8017a5:	c3                   	ret    

008017a6 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8017a6:	f3 0f 1e fb          	endbr32 
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
  8017ad:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8017b0:	68 8f 29 80 00       	push   $0x80298f
  8017b5:	ff 75 0c             	pushl  0xc(%ebp)
  8017b8:	e8 98 f0 ff ff       	call   800855 <strcpy>
	return 0;
}
  8017bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c2:	c9                   	leave  
  8017c3:	c3                   	ret    

008017c4 <devsock_close>:
{
  8017c4:	f3 0f 1e fb          	endbr32 
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
  8017cb:	53                   	push   %ebx
  8017cc:	83 ec 10             	sub    $0x10,%esp
  8017cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8017d2:	53                   	push   %ebx
  8017d3:	e8 9b 0a 00 00       	call   802273 <pageref>
  8017d8:	89 c2                	mov    %eax,%edx
  8017da:	83 c4 10             	add    $0x10,%esp
		return 0;
  8017dd:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  8017e2:	83 fa 01             	cmp    $0x1,%edx
  8017e5:	74 05                	je     8017ec <devsock_close+0x28>
}
  8017e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ea:	c9                   	leave  
  8017eb:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8017ec:	83 ec 0c             	sub    $0xc,%esp
  8017ef:	ff 73 0c             	pushl  0xc(%ebx)
  8017f2:	e8 e3 02 00 00       	call   801ada <nsipc_close>
  8017f7:	83 c4 10             	add    $0x10,%esp
  8017fa:	eb eb                	jmp    8017e7 <devsock_close+0x23>

008017fc <devsock_write>:
{
  8017fc:	f3 0f 1e fb          	endbr32 
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801806:	6a 00                	push   $0x0
  801808:	ff 75 10             	pushl  0x10(%ebp)
  80180b:	ff 75 0c             	pushl  0xc(%ebp)
  80180e:	8b 45 08             	mov    0x8(%ebp),%eax
  801811:	ff 70 0c             	pushl  0xc(%eax)
  801814:	e8 b5 03 00 00       	call   801bce <nsipc_send>
}
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <devsock_read>:
{
  80181b:	f3 0f 1e fb          	endbr32 
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
  801822:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801825:	6a 00                	push   $0x0
  801827:	ff 75 10             	pushl  0x10(%ebp)
  80182a:	ff 75 0c             	pushl  0xc(%ebp)
  80182d:	8b 45 08             	mov    0x8(%ebp),%eax
  801830:	ff 70 0c             	pushl  0xc(%eax)
  801833:	e8 1f 03 00 00       	call   801b57 <nsipc_recv>
}
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <fd2sockid>:
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
  80183d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801840:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801843:	52                   	push   %edx
  801844:	50                   	push   %eax
  801845:	e8 92 f7 ff ff       	call   800fdc <fd_lookup>
  80184a:	83 c4 10             	add    $0x10,%esp
  80184d:	85 c0                	test   %eax,%eax
  80184f:	78 10                	js     801861 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801854:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80185a:	39 08                	cmp    %ecx,(%eax)
  80185c:	75 05                	jne    801863 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80185e:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801861:	c9                   	leave  
  801862:	c3                   	ret    
		return -E_NOT_SUPP;
  801863:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801868:	eb f7                	jmp    801861 <fd2sockid+0x27>

0080186a <alloc_sockfd>:
{
  80186a:	55                   	push   %ebp
  80186b:	89 e5                	mov    %esp,%ebp
  80186d:	56                   	push   %esi
  80186e:	53                   	push   %ebx
  80186f:	83 ec 1c             	sub    $0x1c,%esp
  801872:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801874:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801877:	50                   	push   %eax
  801878:	e8 09 f7 ff ff       	call   800f86 <fd_alloc>
  80187d:	89 c3                	mov    %eax,%ebx
  80187f:	83 c4 10             	add    $0x10,%esp
  801882:	85 c0                	test   %eax,%eax
  801884:	78 43                	js     8018c9 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801886:	83 ec 04             	sub    $0x4,%esp
  801889:	68 07 04 00 00       	push   $0x407
  80188e:	ff 75 f4             	pushl  -0xc(%ebp)
  801891:	6a 00                	push   $0x0
  801893:	e8 ff f3 ff ff       	call   800c97 <sys_page_alloc>
  801898:	89 c3                	mov    %eax,%ebx
  80189a:	83 c4 10             	add    $0x10,%esp
  80189d:	85 c0                	test   %eax,%eax
  80189f:	78 28                	js     8018c9 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8018a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a4:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018aa:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8018ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018af:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8018b6:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8018b9:	83 ec 0c             	sub    $0xc,%esp
  8018bc:	50                   	push   %eax
  8018bd:	e8 95 f6 ff ff       	call   800f57 <fd2num>
  8018c2:	89 c3                	mov    %eax,%ebx
  8018c4:	83 c4 10             	add    $0x10,%esp
  8018c7:	eb 0c                	jmp    8018d5 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8018c9:	83 ec 0c             	sub    $0xc,%esp
  8018cc:	56                   	push   %esi
  8018cd:	e8 08 02 00 00       	call   801ada <nsipc_close>
		return r;
  8018d2:	83 c4 10             	add    $0x10,%esp
}
  8018d5:	89 d8                	mov    %ebx,%eax
  8018d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018da:	5b                   	pop    %ebx
  8018db:	5e                   	pop    %esi
  8018dc:	5d                   	pop    %ebp
  8018dd:	c3                   	ret    

008018de <accept>:
{
  8018de:	f3 0f 1e fb          	endbr32 
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
  8018e5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8018e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018eb:	e8 4a ff ff ff       	call   80183a <fd2sockid>
  8018f0:	85 c0                	test   %eax,%eax
  8018f2:	78 1b                	js     80190f <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8018f4:	83 ec 04             	sub    $0x4,%esp
  8018f7:	ff 75 10             	pushl  0x10(%ebp)
  8018fa:	ff 75 0c             	pushl  0xc(%ebp)
  8018fd:	50                   	push   %eax
  8018fe:	e8 22 01 00 00       	call   801a25 <nsipc_accept>
  801903:	83 c4 10             	add    $0x10,%esp
  801906:	85 c0                	test   %eax,%eax
  801908:	78 05                	js     80190f <accept+0x31>
	return alloc_sockfd(r);
  80190a:	e8 5b ff ff ff       	call   80186a <alloc_sockfd>
}
  80190f:	c9                   	leave  
  801910:	c3                   	ret    

00801911 <bind>:
{
  801911:	f3 0f 1e fb          	endbr32 
  801915:	55                   	push   %ebp
  801916:	89 e5                	mov    %esp,%ebp
  801918:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80191b:	8b 45 08             	mov    0x8(%ebp),%eax
  80191e:	e8 17 ff ff ff       	call   80183a <fd2sockid>
  801923:	85 c0                	test   %eax,%eax
  801925:	78 12                	js     801939 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801927:	83 ec 04             	sub    $0x4,%esp
  80192a:	ff 75 10             	pushl  0x10(%ebp)
  80192d:	ff 75 0c             	pushl  0xc(%ebp)
  801930:	50                   	push   %eax
  801931:	e8 45 01 00 00       	call   801a7b <nsipc_bind>
  801936:	83 c4 10             	add    $0x10,%esp
}
  801939:	c9                   	leave  
  80193a:	c3                   	ret    

0080193b <shutdown>:
{
  80193b:	f3 0f 1e fb          	endbr32 
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
  801942:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801945:	8b 45 08             	mov    0x8(%ebp),%eax
  801948:	e8 ed fe ff ff       	call   80183a <fd2sockid>
  80194d:	85 c0                	test   %eax,%eax
  80194f:	78 0f                	js     801960 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801951:	83 ec 08             	sub    $0x8,%esp
  801954:	ff 75 0c             	pushl  0xc(%ebp)
  801957:	50                   	push   %eax
  801958:	e8 57 01 00 00       	call   801ab4 <nsipc_shutdown>
  80195d:	83 c4 10             	add    $0x10,%esp
}
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <connect>:
{
  801962:	f3 0f 1e fb          	endbr32 
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
  801969:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80196c:	8b 45 08             	mov    0x8(%ebp),%eax
  80196f:	e8 c6 fe ff ff       	call   80183a <fd2sockid>
  801974:	85 c0                	test   %eax,%eax
  801976:	78 12                	js     80198a <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801978:	83 ec 04             	sub    $0x4,%esp
  80197b:	ff 75 10             	pushl  0x10(%ebp)
  80197e:	ff 75 0c             	pushl  0xc(%ebp)
  801981:	50                   	push   %eax
  801982:	e8 71 01 00 00       	call   801af8 <nsipc_connect>
  801987:	83 c4 10             	add    $0x10,%esp
}
  80198a:	c9                   	leave  
  80198b:	c3                   	ret    

0080198c <listen>:
{
  80198c:	f3 0f 1e fb          	endbr32 
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
  801993:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801996:	8b 45 08             	mov    0x8(%ebp),%eax
  801999:	e8 9c fe ff ff       	call   80183a <fd2sockid>
  80199e:	85 c0                	test   %eax,%eax
  8019a0:	78 0f                	js     8019b1 <listen+0x25>
	return nsipc_listen(r, backlog);
  8019a2:	83 ec 08             	sub    $0x8,%esp
  8019a5:	ff 75 0c             	pushl  0xc(%ebp)
  8019a8:	50                   	push   %eax
  8019a9:	e8 83 01 00 00       	call   801b31 <nsipc_listen>
  8019ae:	83 c4 10             	add    $0x10,%esp
}
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    

008019b3 <socket>:

int
socket(int domain, int type, int protocol)
{
  8019b3:	f3 0f 1e fb          	endbr32 
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
  8019ba:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8019bd:	ff 75 10             	pushl  0x10(%ebp)
  8019c0:	ff 75 0c             	pushl  0xc(%ebp)
  8019c3:	ff 75 08             	pushl  0x8(%ebp)
  8019c6:	e8 65 02 00 00       	call   801c30 <nsipc_socket>
  8019cb:	83 c4 10             	add    $0x10,%esp
  8019ce:	85 c0                	test   %eax,%eax
  8019d0:	78 05                	js     8019d7 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  8019d2:	e8 93 fe ff ff       	call   80186a <alloc_sockfd>
}
  8019d7:	c9                   	leave  
  8019d8:	c3                   	ret    

008019d9 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
  8019dc:	53                   	push   %ebx
  8019dd:	83 ec 04             	sub    $0x4,%esp
  8019e0:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8019e2:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8019e9:	74 26                	je     801a11 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8019eb:	6a 07                	push   $0x7
  8019ed:	68 00 60 80 00       	push   $0x806000
  8019f2:	53                   	push   %ebx
  8019f3:	ff 35 04 40 80 00    	pushl  0x804004
  8019f9:	e8 e0 07 00 00       	call   8021de <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8019fe:	83 c4 0c             	add    $0xc,%esp
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	e8 4d 07 00 00       	call   802159 <ipc_recv>
}
  801a0c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a11:	83 ec 0c             	sub    $0xc,%esp
  801a14:	6a 02                	push   $0x2
  801a16:	e8 1b 08 00 00       	call   802236 <ipc_find_env>
  801a1b:	a3 04 40 80 00       	mov    %eax,0x804004
  801a20:	83 c4 10             	add    $0x10,%esp
  801a23:	eb c6                	jmp    8019eb <nsipc+0x12>

00801a25 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a25:	f3 0f 1e fb          	endbr32 
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
  801a2c:	56                   	push   %esi
  801a2d:	53                   	push   %ebx
  801a2e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a31:	8b 45 08             	mov    0x8(%ebp),%eax
  801a34:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a39:	8b 06                	mov    (%esi),%eax
  801a3b:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a40:	b8 01 00 00 00       	mov    $0x1,%eax
  801a45:	e8 8f ff ff ff       	call   8019d9 <nsipc>
  801a4a:	89 c3                	mov    %eax,%ebx
  801a4c:	85 c0                	test   %eax,%eax
  801a4e:	79 09                	jns    801a59 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801a50:	89 d8                	mov    %ebx,%eax
  801a52:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a55:	5b                   	pop    %ebx
  801a56:	5e                   	pop    %esi
  801a57:	5d                   	pop    %ebp
  801a58:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801a59:	83 ec 04             	sub    $0x4,%esp
  801a5c:	ff 35 10 60 80 00    	pushl  0x806010
  801a62:	68 00 60 80 00       	push   $0x806000
  801a67:	ff 75 0c             	pushl  0xc(%ebp)
  801a6a:	e8 9c ef ff ff       	call   800a0b <memmove>
		*addrlen = ret->ret_addrlen;
  801a6f:	a1 10 60 80 00       	mov    0x806010,%eax
  801a74:	89 06                	mov    %eax,(%esi)
  801a76:	83 c4 10             	add    $0x10,%esp
	return r;
  801a79:	eb d5                	jmp    801a50 <nsipc_accept+0x2b>

00801a7b <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801a7b:	f3 0f 1e fb          	endbr32 
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
  801a82:	53                   	push   %ebx
  801a83:	83 ec 08             	sub    $0x8,%esp
  801a86:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801a91:	53                   	push   %ebx
  801a92:	ff 75 0c             	pushl  0xc(%ebp)
  801a95:	68 04 60 80 00       	push   $0x806004
  801a9a:	e8 6c ef ff ff       	call   800a0b <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801a9f:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801aa5:	b8 02 00 00 00       	mov    $0x2,%eax
  801aaa:	e8 2a ff ff ff       	call   8019d9 <nsipc>
}
  801aaf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    

00801ab4 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801ab4:	f3 0f 1e fb          	endbr32 
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
  801abb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801abe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac1:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801ac6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac9:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801ace:	b8 03 00 00 00       	mov    $0x3,%eax
  801ad3:	e8 01 ff ff ff       	call   8019d9 <nsipc>
}
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

00801ada <nsipc_close>:

int
nsipc_close(int s)
{
  801ada:	f3 0f 1e fb          	endbr32 
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
  801ae1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae7:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801aec:	b8 04 00 00 00       	mov    $0x4,%eax
  801af1:	e8 e3 fe ff ff       	call   8019d9 <nsipc>
}
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801af8:	f3 0f 1e fb          	endbr32 
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
  801aff:	53                   	push   %ebx
  801b00:	83 ec 08             	sub    $0x8,%esp
  801b03:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b06:	8b 45 08             	mov    0x8(%ebp),%eax
  801b09:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b0e:	53                   	push   %ebx
  801b0f:	ff 75 0c             	pushl  0xc(%ebp)
  801b12:	68 04 60 80 00       	push   $0x806004
  801b17:	e8 ef ee ff ff       	call   800a0b <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b1c:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b22:	b8 05 00 00 00       	mov    $0x5,%eax
  801b27:	e8 ad fe ff ff       	call   8019d9 <nsipc>
}
  801b2c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b31:	f3 0f 1e fb          	endbr32 
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
  801b38:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b43:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b46:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801b4b:	b8 06 00 00 00       	mov    $0x6,%eax
  801b50:	e8 84 fe ff ff       	call   8019d9 <nsipc>
}
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801b57:	f3 0f 1e fb          	endbr32 
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
  801b5e:	56                   	push   %esi
  801b5f:	53                   	push   %ebx
  801b60:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801b63:	8b 45 08             	mov    0x8(%ebp),%eax
  801b66:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801b6b:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801b71:	8b 45 14             	mov    0x14(%ebp),%eax
  801b74:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801b79:	b8 07 00 00 00       	mov    $0x7,%eax
  801b7e:	e8 56 fe ff ff       	call   8019d9 <nsipc>
  801b83:	89 c3                	mov    %eax,%ebx
  801b85:	85 c0                	test   %eax,%eax
  801b87:	78 26                	js     801baf <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801b89:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801b8f:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801b94:	0f 4e c6             	cmovle %esi,%eax
  801b97:	39 c3                	cmp    %eax,%ebx
  801b99:	7f 1d                	jg     801bb8 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801b9b:	83 ec 04             	sub    $0x4,%esp
  801b9e:	53                   	push   %ebx
  801b9f:	68 00 60 80 00       	push   $0x806000
  801ba4:	ff 75 0c             	pushl  0xc(%ebp)
  801ba7:	e8 5f ee ff ff       	call   800a0b <memmove>
  801bac:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801baf:	89 d8                	mov    %ebx,%eax
  801bb1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bb4:	5b                   	pop    %ebx
  801bb5:	5e                   	pop    %esi
  801bb6:	5d                   	pop    %ebp
  801bb7:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801bb8:	68 9b 29 80 00       	push   $0x80299b
  801bbd:	68 63 29 80 00       	push   $0x802963
  801bc2:	6a 62                	push   $0x62
  801bc4:	68 b0 29 80 00       	push   $0x8029b0
  801bc9:	e8 96 e5 ff ff       	call   800164 <_panic>

00801bce <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801bce:	f3 0f 1e fb          	endbr32 
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
  801bd5:	53                   	push   %ebx
  801bd6:	83 ec 04             	sub    $0x4,%esp
  801bd9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdf:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801be4:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801bea:	7f 2e                	jg     801c1a <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801bec:	83 ec 04             	sub    $0x4,%esp
  801bef:	53                   	push   %ebx
  801bf0:	ff 75 0c             	pushl  0xc(%ebp)
  801bf3:	68 0c 60 80 00       	push   $0x80600c
  801bf8:	e8 0e ee ff ff       	call   800a0b <memmove>
	nsipcbuf.send.req_size = size;
  801bfd:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c03:	8b 45 14             	mov    0x14(%ebp),%eax
  801c06:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c0b:	b8 08 00 00 00       	mov    $0x8,%eax
  801c10:	e8 c4 fd ff ff       	call   8019d9 <nsipc>
}
  801c15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c18:	c9                   	leave  
  801c19:	c3                   	ret    
	assert(size < 1600);
  801c1a:	68 bc 29 80 00       	push   $0x8029bc
  801c1f:	68 63 29 80 00       	push   $0x802963
  801c24:	6a 6d                	push   $0x6d
  801c26:	68 b0 29 80 00       	push   $0x8029b0
  801c2b:	e8 34 e5 ff ff       	call   800164 <_panic>

00801c30 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c30:	f3 0f 1e fb          	endbr32 
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
  801c37:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c42:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c45:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c4a:	8b 45 10             	mov    0x10(%ebp),%eax
  801c4d:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c52:	b8 09 00 00 00       	mov    $0x9,%eax
  801c57:	e8 7d fd ff ff       	call   8019d9 <nsipc>
}
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c5e:	f3 0f 1e fb          	endbr32 
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
  801c65:	56                   	push   %esi
  801c66:	53                   	push   %ebx
  801c67:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c6a:	83 ec 0c             	sub    $0xc,%esp
  801c6d:	ff 75 08             	pushl  0x8(%ebp)
  801c70:	e8 f6 f2 ff ff       	call   800f6b <fd2data>
  801c75:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c77:	83 c4 08             	add    $0x8,%esp
  801c7a:	68 c8 29 80 00       	push   $0x8029c8
  801c7f:	53                   	push   %ebx
  801c80:	e8 d0 eb ff ff       	call   800855 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c85:	8b 46 04             	mov    0x4(%esi),%eax
  801c88:	2b 06                	sub    (%esi),%eax
  801c8a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c90:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c97:	00 00 00 
	stat->st_dev = &devpipe;
  801c9a:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801ca1:	30 80 00 
	return 0;
}
  801ca4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ca9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cac:	5b                   	pop    %ebx
  801cad:	5e                   	pop    %esi
  801cae:	5d                   	pop    %ebp
  801caf:	c3                   	ret    

00801cb0 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801cb0:	f3 0f 1e fb          	endbr32 
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
  801cb7:	53                   	push   %ebx
  801cb8:	83 ec 0c             	sub    $0xc,%esp
  801cbb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801cbe:	53                   	push   %ebx
  801cbf:	6a 00                	push   $0x0
  801cc1:	e8 5e f0 ff ff       	call   800d24 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801cc6:	89 1c 24             	mov    %ebx,(%esp)
  801cc9:	e8 9d f2 ff ff       	call   800f6b <fd2data>
  801cce:	83 c4 08             	add    $0x8,%esp
  801cd1:	50                   	push   %eax
  801cd2:	6a 00                	push   $0x0
  801cd4:	e8 4b f0 ff ff       	call   800d24 <sys_page_unmap>
}
  801cd9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <_pipeisclosed>:
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
  801ce1:	57                   	push   %edi
  801ce2:	56                   	push   %esi
  801ce3:	53                   	push   %ebx
  801ce4:	83 ec 1c             	sub    $0x1c,%esp
  801ce7:	89 c7                	mov    %eax,%edi
  801ce9:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801ceb:	a1 08 40 80 00       	mov    0x804008,%eax
  801cf0:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801cf3:	83 ec 0c             	sub    $0xc,%esp
  801cf6:	57                   	push   %edi
  801cf7:	e8 77 05 00 00       	call   802273 <pageref>
  801cfc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cff:	89 34 24             	mov    %esi,(%esp)
  801d02:	e8 6c 05 00 00       	call   802273 <pageref>
		nn = thisenv->env_runs;
  801d07:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d0d:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d10:	83 c4 10             	add    $0x10,%esp
  801d13:	39 cb                	cmp    %ecx,%ebx
  801d15:	74 1b                	je     801d32 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d17:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d1a:	75 cf                	jne    801ceb <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d1c:	8b 42 58             	mov    0x58(%edx),%eax
  801d1f:	6a 01                	push   $0x1
  801d21:	50                   	push   %eax
  801d22:	53                   	push   %ebx
  801d23:	68 cf 29 80 00       	push   $0x8029cf
  801d28:	e8 1e e5 ff ff       	call   80024b <cprintf>
  801d2d:	83 c4 10             	add    $0x10,%esp
  801d30:	eb b9                	jmp    801ceb <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d32:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d35:	0f 94 c0             	sete   %al
  801d38:	0f b6 c0             	movzbl %al,%eax
}
  801d3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d3e:	5b                   	pop    %ebx
  801d3f:	5e                   	pop    %esi
  801d40:	5f                   	pop    %edi
  801d41:	5d                   	pop    %ebp
  801d42:	c3                   	ret    

00801d43 <devpipe_write>:
{
  801d43:	f3 0f 1e fb          	endbr32 
  801d47:	55                   	push   %ebp
  801d48:	89 e5                	mov    %esp,%ebp
  801d4a:	57                   	push   %edi
  801d4b:	56                   	push   %esi
  801d4c:	53                   	push   %ebx
  801d4d:	83 ec 28             	sub    $0x28,%esp
  801d50:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d53:	56                   	push   %esi
  801d54:	e8 12 f2 ff ff       	call   800f6b <fd2data>
  801d59:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d5b:	83 c4 10             	add    $0x10,%esp
  801d5e:	bf 00 00 00 00       	mov    $0x0,%edi
  801d63:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d66:	74 4f                	je     801db7 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d68:	8b 43 04             	mov    0x4(%ebx),%eax
  801d6b:	8b 0b                	mov    (%ebx),%ecx
  801d6d:	8d 51 20             	lea    0x20(%ecx),%edx
  801d70:	39 d0                	cmp    %edx,%eax
  801d72:	72 14                	jb     801d88 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801d74:	89 da                	mov    %ebx,%edx
  801d76:	89 f0                	mov    %esi,%eax
  801d78:	e8 61 ff ff ff       	call   801cde <_pipeisclosed>
  801d7d:	85 c0                	test   %eax,%eax
  801d7f:	75 3b                	jne    801dbc <devpipe_write+0x79>
			sys_yield();
  801d81:	e8 ee ee ff ff       	call   800c74 <sys_yield>
  801d86:	eb e0                	jmp    801d68 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d8b:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d8f:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d92:	89 c2                	mov    %eax,%edx
  801d94:	c1 fa 1f             	sar    $0x1f,%edx
  801d97:	89 d1                	mov    %edx,%ecx
  801d99:	c1 e9 1b             	shr    $0x1b,%ecx
  801d9c:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d9f:	83 e2 1f             	and    $0x1f,%edx
  801da2:	29 ca                	sub    %ecx,%edx
  801da4:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801da8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801dac:	83 c0 01             	add    $0x1,%eax
  801daf:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801db2:	83 c7 01             	add    $0x1,%edi
  801db5:	eb ac                	jmp    801d63 <devpipe_write+0x20>
	return i;
  801db7:	8b 45 10             	mov    0x10(%ebp),%eax
  801dba:	eb 05                	jmp    801dc1 <devpipe_write+0x7e>
				return 0;
  801dbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dc4:	5b                   	pop    %ebx
  801dc5:	5e                   	pop    %esi
  801dc6:	5f                   	pop    %edi
  801dc7:	5d                   	pop    %ebp
  801dc8:	c3                   	ret    

00801dc9 <devpipe_read>:
{
  801dc9:	f3 0f 1e fb          	endbr32 
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
  801dd0:	57                   	push   %edi
  801dd1:	56                   	push   %esi
  801dd2:	53                   	push   %ebx
  801dd3:	83 ec 18             	sub    $0x18,%esp
  801dd6:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801dd9:	57                   	push   %edi
  801dda:	e8 8c f1 ff ff       	call   800f6b <fd2data>
  801ddf:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801de1:	83 c4 10             	add    $0x10,%esp
  801de4:	be 00 00 00 00       	mov    $0x0,%esi
  801de9:	3b 75 10             	cmp    0x10(%ebp),%esi
  801dec:	75 14                	jne    801e02 <devpipe_read+0x39>
	return i;
  801dee:	8b 45 10             	mov    0x10(%ebp),%eax
  801df1:	eb 02                	jmp    801df5 <devpipe_read+0x2c>
				return i;
  801df3:	89 f0                	mov    %esi,%eax
}
  801df5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801df8:	5b                   	pop    %ebx
  801df9:	5e                   	pop    %esi
  801dfa:	5f                   	pop    %edi
  801dfb:	5d                   	pop    %ebp
  801dfc:	c3                   	ret    
			sys_yield();
  801dfd:	e8 72 ee ff ff       	call   800c74 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e02:	8b 03                	mov    (%ebx),%eax
  801e04:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e07:	75 18                	jne    801e21 <devpipe_read+0x58>
			if (i > 0)
  801e09:	85 f6                	test   %esi,%esi
  801e0b:	75 e6                	jne    801df3 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801e0d:	89 da                	mov    %ebx,%edx
  801e0f:	89 f8                	mov    %edi,%eax
  801e11:	e8 c8 fe ff ff       	call   801cde <_pipeisclosed>
  801e16:	85 c0                	test   %eax,%eax
  801e18:	74 e3                	je     801dfd <devpipe_read+0x34>
				return 0;
  801e1a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e1f:	eb d4                	jmp    801df5 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e21:	99                   	cltd   
  801e22:	c1 ea 1b             	shr    $0x1b,%edx
  801e25:	01 d0                	add    %edx,%eax
  801e27:	83 e0 1f             	and    $0x1f,%eax
  801e2a:	29 d0                	sub    %edx,%eax
  801e2c:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e34:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e37:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e3a:	83 c6 01             	add    $0x1,%esi
  801e3d:	eb aa                	jmp    801de9 <devpipe_read+0x20>

00801e3f <pipe>:
{
  801e3f:	f3 0f 1e fb          	endbr32 
  801e43:	55                   	push   %ebp
  801e44:	89 e5                	mov    %esp,%ebp
  801e46:	56                   	push   %esi
  801e47:	53                   	push   %ebx
  801e48:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e4b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e4e:	50                   	push   %eax
  801e4f:	e8 32 f1 ff ff       	call   800f86 <fd_alloc>
  801e54:	89 c3                	mov    %eax,%ebx
  801e56:	83 c4 10             	add    $0x10,%esp
  801e59:	85 c0                	test   %eax,%eax
  801e5b:	0f 88 23 01 00 00    	js     801f84 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e61:	83 ec 04             	sub    $0x4,%esp
  801e64:	68 07 04 00 00       	push   $0x407
  801e69:	ff 75 f4             	pushl  -0xc(%ebp)
  801e6c:	6a 00                	push   $0x0
  801e6e:	e8 24 ee ff ff       	call   800c97 <sys_page_alloc>
  801e73:	89 c3                	mov    %eax,%ebx
  801e75:	83 c4 10             	add    $0x10,%esp
  801e78:	85 c0                	test   %eax,%eax
  801e7a:	0f 88 04 01 00 00    	js     801f84 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801e80:	83 ec 0c             	sub    $0xc,%esp
  801e83:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e86:	50                   	push   %eax
  801e87:	e8 fa f0 ff ff       	call   800f86 <fd_alloc>
  801e8c:	89 c3                	mov    %eax,%ebx
  801e8e:	83 c4 10             	add    $0x10,%esp
  801e91:	85 c0                	test   %eax,%eax
  801e93:	0f 88 db 00 00 00    	js     801f74 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e99:	83 ec 04             	sub    $0x4,%esp
  801e9c:	68 07 04 00 00       	push   $0x407
  801ea1:	ff 75 f0             	pushl  -0x10(%ebp)
  801ea4:	6a 00                	push   $0x0
  801ea6:	e8 ec ed ff ff       	call   800c97 <sys_page_alloc>
  801eab:	89 c3                	mov    %eax,%ebx
  801ead:	83 c4 10             	add    $0x10,%esp
  801eb0:	85 c0                	test   %eax,%eax
  801eb2:	0f 88 bc 00 00 00    	js     801f74 <pipe+0x135>
	va = fd2data(fd0);
  801eb8:	83 ec 0c             	sub    $0xc,%esp
  801ebb:	ff 75 f4             	pushl  -0xc(%ebp)
  801ebe:	e8 a8 f0 ff ff       	call   800f6b <fd2data>
  801ec3:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ec5:	83 c4 0c             	add    $0xc,%esp
  801ec8:	68 07 04 00 00       	push   $0x407
  801ecd:	50                   	push   %eax
  801ece:	6a 00                	push   $0x0
  801ed0:	e8 c2 ed ff ff       	call   800c97 <sys_page_alloc>
  801ed5:	89 c3                	mov    %eax,%ebx
  801ed7:	83 c4 10             	add    $0x10,%esp
  801eda:	85 c0                	test   %eax,%eax
  801edc:	0f 88 82 00 00 00    	js     801f64 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ee2:	83 ec 0c             	sub    $0xc,%esp
  801ee5:	ff 75 f0             	pushl  -0x10(%ebp)
  801ee8:	e8 7e f0 ff ff       	call   800f6b <fd2data>
  801eed:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ef4:	50                   	push   %eax
  801ef5:	6a 00                	push   $0x0
  801ef7:	56                   	push   %esi
  801ef8:	6a 00                	push   $0x0
  801efa:	e8 df ed ff ff       	call   800cde <sys_page_map>
  801eff:	89 c3                	mov    %eax,%ebx
  801f01:	83 c4 20             	add    $0x20,%esp
  801f04:	85 c0                	test   %eax,%eax
  801f06:	78 4e                	js     801f56 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801f08:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f10:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f15:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f1c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f1f:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f24:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f2b:	83 ec 0c             	sub    $0xc,%esp
  801f2e:	ff 75 f4             	pushl  -0xc(%ebp)
  801f31:	e8 21 f0 ff ff       	call   800f57 <fd2num>
  801f36:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f39:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f3b:	83 c4 04             	add    $0x4,%esp
  801f3e:	ff 75 f0             	pushl  -0x10(%ebp)
  801f41:	e8 11 f0 ff ff       	call   800f57 <fd2num>
  801f46:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f49:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f4c:	83 c4 10             	add    $0x10,%esp
  801f4f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f54:	eb 2e                	jmp    801f84 <pipe+0x145>
	sys_page_unmap(0, va);
  801f56:	83 ec 08             	sub    $0x8,%esp
  801f59:	56                   	push   %esi
  801f5a:	6a 00                	push   $0x0
  801f5c:	e8 c3 ed ff ff       	call   800d24 <sys_page_unmap>
  801f61:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f64:	83 ec 08             	sub    $0x8,%esp
  801f67:	ff 75 f0             	pushl  -0x10(%ebp)
  801f6a:	6a 00                	push   $0x0
  801f6c:	e8 b3 ed ff ff       	call   800d24 <sys_page_unmap>
  801f71:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f74:	83 ec 08             	sub    $0x8,%esp
  801f77:	ff 75 f4             	pushl  -0xc(%ebp)
  801f7a:	6a 00                	push   $0x0
  801f7c:	e8 a3 ed ff ff       	call   800d24 <sys_page_unmap>
  801f81:	83 c4 10             	add    $0x10,%esp
}
  801f84:	89 d8                	mov    %ebx,%eax
  801f86:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f89:	5b                   	pop    %ebx
  801f8a:	5e                   	pop    %esi
  801f8b:	5d                   	pop    %ebp
  801f8c:	c3                   	ret    

00801f8d <pipeisclosed>:
{
  801f8d:	f3 0f 1e fb          	endbr32 
  801f91:	55                   	push   %ebp
  801f92:	89 e5                	mov    %esp,%ebp
  801f94:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f97:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f9a:	50                   	push   %eax
  801f9b:	ff 75 08             	pushl  0x8(%ebp)
  801f9e:	e8 39 f0 ff ff       	call   800fdc <fd_lookup>
  801fa3:	83 c4 10             	add    $0x10,%esp
  801fa6:	85 c0                	test   %eax,%eax
  801fa8:	78 18                	js     801fc2 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801faa:	83 ec 0c             	sub    $0xc,%esp
  801fad:	ff 75 f4             	pushl  -0xc(%ebp)
  801fb0:	e8 b6 ef ff ff       	call   800f6b <fd2data>
  801fb5:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fba:	e8 1f fd ff ff       	call   801cde <_pipeisclosed>
  801fbf:	83 c4 10             	add    $0x10,%esp
}
  801fc2:	c9                   	leave  
  801fc3:	c3                   	ret    

00801fc4 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801fc4:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801fc8:	b8 00 00 00 00       	mov    $0x0,%eax
  801fcd:	c3                   	ret    

00801fce <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801fce:	f3 0f 1e fb          	endbr32 
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
  801fd5:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801fd8:	68 e7 29 80 00       	push   $0x8029e7
  801fdd:	ff 75 0c             	pushl  0xc(%ebp)
  801fe0:	e8 70 e8 ff ff       	call   800855 <strcpy>
	return 0;
}
  801fe5:	b8 00 00 00 00       	mov    $0x0,%eax
  801fea:	c9                   	leave  
  801feb:	c3                   	ret    

00801fec <devcons_write>:
{
  801fec:	f3 0f 1e fb          	endbr32 
  801ff0:	55                   	push   %ebp
  801ff1:	89 e5                	mov    %esp,%ebp
  801ff3:	57                   	push   %edi
  801ff4:	56                   	push   %esi
  801ff5:	53                   	push   %ebx
  801ff6:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801ffc:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802001:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802007:	3b 75 10             	cmp    0x10(%ebp),%esi
  80200a:	73 31                	jae    80203d <devcons_write+0x51>
		m = n - tot;
  80200c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80200f:	29 f3                	sub    %esi,%ebx
  802011:	83 fb 7f             	cmp    $0x7f,%ebx
  802014:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802019:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80201c:	83 ec 04             	sub    $0x4,%esp
  80201f:	53                   	push   %ebx
  802020:	89 f0                	mov    %esi,%eax
  802022:	03 45 0c             	add    0xc(%ebp),%eax
  802025:	50                   	push   %eax
  802026:	57                   	push   %edi
  802027:	e8 df e9 ff ff       	call   800a0b <memmove>
		sys_cputs(buf, m);
  80202c:	83 c4 08             	add    $0x8,%esp
  80202f:	53                   	push   %ebx
  802030:	57                   	push   %edi
  802031:	e8 91 eb ff ff       	call   800bc7 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802036:	01 de                	add    %ebx,%esi
  802038:	83 c4 10             	add    $0x10,%esp
  80203b:	eb ca                	jmp    802007 <devcons_write+0x1b>
}
  80203d:	89 f0                	mov    %esi,%eax
  80203f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802042:	5b                   	pop    %ebx
  802043:	5e                   	pop    %esi
  802044:	5f                   	pop    %edi
  802045:	5d                   	pop    %ebp
  802046:	c3                   	ret    

00802047 <devcons_read>:
{
  802047:	f3 0f 1e fb          	endbr32 
  80204b:	55                   	push   %ebp
  80204c:	89 e5                	mov    %esp,%ebp
  80204e:	83 ec 08             	sub    $0x8,%esp
  802051:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802056:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80205a:	74 21                	je     80207d <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  80205c:	e8 88 eb ff ff       	call   800be9 <sys_cgetc>
  802061:	85 c0                	test   %eax,%eax
  802063:	75 07                	jne    80206c <devcons_read+0x25>
		sys_yield();
  802065:	e8 0a ec ff ff       	call   800c74 <sys_yield>
  80206a:	eb f0                	jmp    80205c <devcons_read+0x15>
	if (c < 0)
  80206c:	78 0f                	js     80207d <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  80206e:	83 f8 04             	cmp    $0x4,%eax
  802071:	74 0c                	je     80207f <devcons_read+0x38>
	*(char*)vbuf = c;
  802073:	8b 55 0c             	mov    0xc(%ebp),%edx
  802076:	88 02                	mov    %al,(%edx)
	return 1;
  802078:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80207d:	c9                   	leave  
  80207e:	c3                   	ret    
		return 0;
  80207f:	b8 00 00 00 00       	mov    $0x0,%eax
  802084:	eb f7                	jmp    80207d <devcons_read+0x36>

00802086 <cputchar>:
{
  802086:	f3 0f 1e fb          	endbr32 
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
  80208d:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802090:	8b 45 08             	mov    0x8(%ebp),%eax
  802093:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802096:	6a 01                	push   $0x1
  802098:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80209b:	50                   	push   %eax
  80209c:	e8 26 eb ff ff       	call   800bc7 <sys_cputs>
}
  8020a1:	83 c4 10             	add    $0x10,%esp
  8020a4:	c9                   	leave  
  8020a5:	c3                   	ret    

008020a6 <getchar>:
{
  8020a6:	f3 0f 1e fb          	endbr32 
  8020aa:	55                   	push   %ebp
  8020ab:	89 e5                	mov    %esp,%ebp
  8020ad:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020b0:	6a 01                	push   $0x1
  8020b2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020b5:	50                   	push   %eax
  8020b6:	6a 00                	push   $0x0
  8020b8:	e8 a7 f1 ff ff       	call   801264 <read>
	if (r < 0)
  8020bd:	83 c4 10             	add    $0x10,%esp
  8020c0:	85 c0                	test   %eax,%eax
  8020c2:	78 06                	js     8020ca <getchar+0x24>
	if (r < 1)
  8020c4:	74 06                	je     8020cc <getchar+0x26>
	return c;
  8020c6:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020ca:	c9                   	leave  
  8020cb:	c3                   	ret    
		return -E_EOF;
  8020cc:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020d1:	eb f7                	jmp    8020ca <getchar+0x24>

008020d3 <iscons>:
{
  8020d3:	f3 0f 1e fb          	endbr32 
  8020d7:	55                   	push   %ebp
  8020d8:	89 e5                	mov    %esp,%ebp
  8020da:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020e0:	50                   	push   %eax
  8020e1:	ff 75 08             	pushl  0x8(%ebp)
  8020e4:	e8 f3 ee ff ff       	call   800fdc <fd_lookup>
  8020e9:	83 c4 10             	add    $0x10,%esp
  8020ec:	85 c0                	test   %eax,%eax
  8020ee:	78 11                	js     802101 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8020f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f3:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020f9:	39 10                	cmp    %edx,(%eax)
  8020fb:	0f 94 c0             	sete   %al
  8020fe:	0f b6 c0             	movzbl %al,%eax
}
  802101:	c9                   	leave  
  802102:	c3                   	ret    

00802103 <opencons>:
{
  802103:	f3 0f 1e fb          	endbr32 
  802107:	55                   	push   %ebp
  802108:	89 e5                	mov    %esp,%ebp
  80210a:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80210d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802110:	50                   	push   %eax
  802111:	e8 70 ee ff ff       	call   800f86 <fd_alloc>
  802116:	83 c4 10             	add    $0x10,%esp
  802119:	85 c0                	test   %eax,%eax
  80211b:	78 3a                	js     802157 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80211d:	83 ec 04             	sub    $0x4,%esp
  802120:	68 07 04 00 00       	push   $0x407
  802125:	ff 75 f4             	pushl  -0xc(%ebp)
  802128:	6a 00                	push   $0x0
  80212a:	e8 68 eb ff ff       	call   800c97 <sys_page_alloc>
  80212f:	83 c4 10             	add    $0x10,%esp
  802132:	85 c0                	test   %eax,%eax
  802134:	78 21                	js     802157 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802136:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802139:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80213f:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802141:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802144:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80214b:	83 ec 0c             	sub    $0xc,%esp
  80214e:	50                   	push   %eax
  80214f:	e8 03 ee ff ff       	call   800f57 <fd2num>
  802154:	83 c4 10             	add    $0x10,%esp
}
  802157:	c9                   	leave  
  802158:	c3                   	ret    

00802159 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802159:	f3 0f 1e fb          	endbr32 
  80215d:	55                   	push   %ebp
  80215e:	89 e5                	mov    %esp,%ebp
  802160:	56                   	push   %esi
  802161:	53                   	push   %ebx
  802162:	8b 75 08             	mov    0x8(%ebp),%esi
  802165:	8b 45 0c             	mov    0xc(%ebp),%eax
  802168:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  80216b:	85 c0                	test   %eax,%eax
  80216d:	74 3d                	je     8021ac <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  80216f:	83 ec 0c             	sub    $0xc,%esp
  802172:	50                   	push   %eax
  802173:	e8 eb ec ff ff       	call   800e63 <sys_ipc_recv>
  802178:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  80217b:	85 f6                	test   %esi,%esi
  80217d:	74 0b                	je     80218a <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  80217f:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802185:	8b 52 74             	mov    0x74(%edx),%edx
  802188:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  80218a:	85 db                	test   %ebx,%ebx
  80218c:	74 0b                	je     802199 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  80218e:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802194:	8b 52 78             	mov    0x78(%edx),%edx
  802197:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  802199:	85 c0                	test   %eax,%eax
  80219b:	78 21                	js     8021be <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  80219d:	a1 08 40 80 00       	mov    0x804008,%eax
  8021a2:	8b 40 70             	mov    0x70(%eax),%eax
}
  8021a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021a8:	5b                   	pop    %ebx
  8021a9:	5e                   	pop    %esi
  8021aa:	5d                   	pop    %ebp
  8021ab:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  8021ac:	83 ec 0c             	sub    $0xc,%esp
  8021af:	68 00 00 c0 ee       	push   $0xeec00000
  8021b4:	e8 aa ec ff ff       	call   800e63 <sys_ipc_recv>
  8021b9:	83 c4 10             	add    $0x10,%esp
  8021bc:	eb bd                	jmp    80217b <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  8021be:	85 f6                	test   %esi,%esi
  8021c0:	74 10                	je     8021d2 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  8021c2:	85 db                	test   %ebx,%ebx
  8021c4:	75 df                	jne    8021a5 <ipc_recv+0x4c>
  8021c6:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8021cd:	00 00 00 
  8021d0:	eb d3                	jmp    8021a5 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  8021d2:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8021d9:	00 00 00 
  8021dc:	eb e4                	jmp    8021c2 <ipc_recv+0x69>

008021de <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8021de:	f3 0f 1e fb          	endbr32 
  8021e2:	55                   	push   %ebp
  8021e3:	89 e5                	mov    %esp,%ebp
  8021e5:	57                   	push   %edi
  8021e6:	56                   	push   %esi
  8021e7:	53                   	push   %ebx
  8021e8:	83 ec 0c             	sub    $0xc,%esp
  8021eb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8021ee:	8b 75 0c             	mov    0xc(%ebp),%esi
  8021f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  8021f4:	85 db                	test   %ebx,%ebx
  8021f6:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8021fb:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  8021fe:	ff 75 14             	pushl  0x14(%ebp)
  802201:	53                   	push   %ebx
  802202:	56                   	push   %esi
  802203:	57                   	push   %edi
  802204:	e8 33 ec ff ff       	call   800e3c <sys_ipc_try_send>
  802209:	83 c4 10             	add    $0x10,%esp
  80220c:	85 c0                	test   %eax,%eax
  80220e:	79 1e                	jns    80222e <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  802210:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802213:	75 07                	jne    80221c <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  802215:	e8 5a ea ff ff       	call   800c74 <sys_yield>
  80221a:	eb e2                	jmp    8021fe <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  80221c:	50                   	push   %eax
  80221d:	68 f3 29 80 00       	push   $0x8029f3
  802222:	6a 59                	push   $0x59
  802224:	68 0e 2a 80 00       	push   $0x802a0e
  802229:	e8 36 df ff ff       	call   800164 <_panic>
	}
}
  80222e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802231:	5b                   	pop    %ebx
  802232:	5e                   	pop    %esi
  802233:	5f                   	pop    %edi
  802234:	5d                   	pop    %ebp
  802235:	c3                   	ret    

00802236 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802236:	f3 0f 1e fb          	endbr32 
  80223a:	55                   	push   %ebp
  80223b:	89 e5                	mov    %esp,%ebp
  80223d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802240:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802245:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802248:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80224e:	8b 52 50             	mov    0x50(%edx),%edx
  802251:	39 ca                	cmp    %ecx,%edx
  802253:	74 11                	je     802266 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802255:	83 c0 01             	add    $0x1,%eax
  802258:	3d 00 04 00 00       	cmp    $0x400,%eax
  80225d:	75 e6                	jne    802245 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  80225f:	b8 00 00 00 00       	mov    $0x0,%eax
  802264:	eb 0b                	jmp    802271 <ipc_find_env+0x3b>
			return envs[i].env_id;
  802266:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802269:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80226e:	8b 40 48             	mov    0x48(%eax),%eax
}
  802271:	5d                   	pop    %ebp
  802272:	c3                   	ret    

00802273 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802273:	f3 0f 1e fb          	endbr32 
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
  80227a:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80227d:	89 c2                	mov    %eax,%edx
  80227f:	c1 ea 16             	shr    $0x16,%edx
  802282:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802289:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  80228e:	f6 c1 01             	test   $0x1,%cl
  802291:	74 1c                	je     8022af <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802293:	c1 e8 0c             	shr    $0xc,%eax
  802296:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80229d:	a8 01                	test   $0x1,%al
  80229f:	74 0e                	je     8022af <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022a1:	c1 e8 0c             	shr    $0xc,%eax
  8022a4:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8022ab:	ef 
  8022ac:	0f b7 d2             	movzwl %dx,%edx
}
  8022af:	89 d0                	mov    %edx,%eax
  8022b1:	5d                   	pop    %ebp
  8022b2:	c3                   	ret    
  8022b3:	66 90                	xchg   %ax,%ax
  8022b5:	66 90                	xchg   %ax,%ax
  8022b7:	66 90                	xchg   %ax,%ax
  8022b9:	66 90                	xchg   %ax,%ax
  8022bb:	66 90                	xchg   %ax,%ax
  8022bd:	66 90                	xchg   %ax,%ax
  8022bf:	90                   	nop

008022c0 <__udivdi3>:
  8022c0:	f3 0f 1e fb          	endbr32 
  8022c4:	55                   	push   %ebp
  8022c5:	57                   	push   %edi
  8022c6:	56                   	push   %esi
  8022c7:	53                   	push   %ebx
  8022c8:	83 ec 1c             	sub    $0x1c,%esp
  8022cb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8022cf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8022d3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022d7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8022db:	85 d2                	test   %edx,%edx
  8022dd:	75 19                	jne    8022f8 <__udivdi3+0x38>
  8022df:	39 f3                	cmp    %esi,%ebx
  8022e1:	76 4d                	jbe    802330 <__udivdi3+0x70>
  8022e3:	31 ff                	xor    %edi,%edi
  8022e5:	89 e8                	mov    %ebp,%eax
  8022e7:	89 f2                	mov    %esi,%edx
  8022e9:	f7 f3                	div    %ebx
  8022eb:	89 fa                	mov    %edi,%edx
  8022ed:	83 c4 1c             	add    $0x1c,%esp
  8022f0:	5b                   	pop    %ebx
  8022f1:	5e                   	pop    %esi
  8022f2:	5f                   	pop    %edi
  8022f3:	5d                   	pop    %ebp
  8022f4:	c3                   	ret    
  8022f5:	8d 76 00             	lea    0x0(%esi),%esi
  8022f8:	39 f2                	cmp    %esi,%edx
  8022fa:	76 14                	jbe    802310 <__udivdi3+0x50>
  8022fc:	31 ff                	xor    %edi,%edi
  8022fe:	31 c0                	xor    %eax,%eax
  802300:	89 fa                	mov    %edi,%edx
  802302:	83 c4 1c             	add    $0x1c,%esp
  802305:	5b                   	pop    %ebx
  802306:	5e                   	pop    %esi
  802307:	5f                   	pop    %edi
  802308:	5d                   	pop    %ebp
  802309:	c3                   	ret    
  80230a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802310:	0f bd fa             	bsr    %edx,%edi
  802313:	83 f7 1f             	xor    $0x1f,%edi
  802316:	75 48                	jne    802360 <__udivdi3+0xa0>
  802318:	39 f2                	cmp    %esi,%edx
  80231a:	72 06                	jb     802322 <__udivdi3+0x62>
  80231c:	31 c0                	xor    %eax,%eax
  80231e:	39 eb                	cmp    %ebp,%ebx
  802320:	77 de                	ja     802300 <__udivdi3+0x40>
  802322:	b8 01 00 00 00       	mov    $0x1,%eax
  802327:	eb d7                	jmp    802300 <__udivdi3+0x40>
  802329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802330:	89 d9                	mov    %ebx,%ecx
  802332:	85 db                	test   %ebx,%ebx
  802334:	75 0b                	jne    802341 <__udivdi3+0x81>
  802336:	b8 01 00 00 00       	mov    $0x1,%eax
  80233b:	31 d2                	xor    %edx,%edx
  80233d:	f7 f3                	div    %ebx
  80233f:	89 c1                	mov    %eax,%ecx
  802341:	31 d2                	xor    %edx,%edx
  802343:	89 f0                	mov    %esi,%eax
  802345:	f7 f1                	div    %ecx
  802347:	89 c6                	mov    %eax,%esi
  802349:	89 e8                	mov    %ebp,%eax
  80234b:	89 f7                	mov    %esi,%edi
  80234d:	f7 f1                	div    %ecx
  80234f:	89 fa                	mov    %edi,%edx
  802351:	83 c4 1c             	add    $0x1c,%esp
  802354:	5b                   	pop    %ebx
  802355:	5e                   	pop    %esi
  802356:	5f                   	pop    %edi
  802357:	5d                   	pop    %ebp
  802358:	c3                   	ret    
  802359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802360:	89 f9                	mov    %edi,%ecx
  802362:	b8 20 00 00 00       	mov    $0x20,%eax
  802367:	29 f8                	sub    %edi,%eax
  802369:	d3 e2                	shl    %cl,%edx
  80236b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80236f:	89 c1                	mov    %eax,%ecx
  802371:	89 da                	mov    %ebx,%edx
  802373:	d3 ea                	shr    %cl,%edx
  802375:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802379:	09 d1                	or     %edx,%ecx
  80237b:	89 f2                	mov    %esi,%edx
  80237d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802381:	89 f9                	mov    %edi,%ecx
  802383:	d3 e3                	shl    %cl,%ebx
  802385:	89 c1                	mov    %eax,%ecx
  802387:	d3 ea                	shr    %cl,%edx
  802389:	89 f9                	mov    %edi,%ecx
  80238b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80238f:	89 eb                	mov    %ebp,%ebx
  802391:	d3 e6                	shl    %cl,%esi
  802393:	89 c1                	mov    %eax,%ecx
  802395:	d3 eb                	shr    %cl,%ebx
  802397:	09 de                	or     %ebx,%esi
  802399:	89 f0                	mov    %esi,%eax
  80239b:	f7 74 24 08          	divl   0x8(%esp)
  80239f:	89 d6                	mov    %edx,%esi
  8023a1:	89 c3                	mov    %eax,%ebx
  8023a3:	f7 64 24 0c          	mull   0xc(%esp)
  8023a7:	39 d6                	cmp    %edx,%esi
  8023a9:	72 15                	jb     8023c0 <__udivdi3+0x100>
  8023ab:	89 f9                	mov    %edi,%ecx
  8023ad:	d3 e5                	shl    %cl,%ebp
  8023af:	39 c5                	cmp    %eax,%ebp
  8023b1:	73 04                	jae    8023b7 <__udivdi3+0xf7>
  8023b3:	39 d6                	cmp    %edx,%esi
  8023b5:	74 09                	je     8023c0 <__udivdi3+0x100>
  8023b7:	89 d8                	mov    %ebx,%eax
  8023b9:	31 ff                	xor    %edi,%edi
  8023bb:	e9 40 ff ff ff       	jmp    802300 <__udivdi3+0x40>
  8023c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023c3:	31 ff                	xor    %edi,%edi
  8023c5:	e9 36 ff ff ff       	jmp    802300 <__udivdi3+0x40>
  8023ca:	66 90                	xchg   %ax,%ax
  8023cc:	66 90                	xchg   %ax,%ax
  8023ce:	66 90                	xchg   %ax,%ax

008023d0 <__umoddi3>:
  8023d0:	f3 0f 1e fb          	endbr32 
  8023d4:	55                   	push   %ebp
  8023d5:	57                   	push   %edi
  8023d6:	56                   	push   %esi
  8023d7:	53                   	push   %ebx
  8023d8:	83 ec 1c             	sub    $0x1c,%esp
  8023db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8023df:	8b 74 24 30          	mov    0x30(%esp),%esi
  8023e3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8023e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023eb:	85 c0                	test   %eax,%eax
  8023ed:	75 19                	jne    802408 <__umoddi3+0x38>
  8023ef:	39 df                	cmp    %ebx,%edi
  8023f1:	76 5d                	jbe    802450 <__umoddi3+0x80>
  8023f3:	89 f0                	mov    %esi,%eax
  8023f5:	89 da                	mov    %ebx,%edx
  8023f7:	f7 f7                	div    %edi
  8023f9:	89 d0                	mov    %edx,%eax
  8023fb:	31 d2                	xor    %edx,%edx
  8023fd:	83 c4 1c             	add    $0x1c,%esp
  802400:	5b                   	pop    %ebx
  802401:	5e                   	pop    %esi
  802402:	5f                   	pop    %edi
  802403:	5d                   	pop    %ebp
  802404:	c3                   	ret    
  802405:	8d 76 00             	lea    0x0(%esi),%esi
  802408:	89 f2                	mov    %esi,%edx
  80240a:	39 d8                	cmp    %ebx,%eax
  80240c:	76 12                	jbe    802420 <__umoddi3+0x50>
  80240e:	89 f0                	mov    %esi,%eax
  802410:	89 da                	mov    %ebx,%edx
  802412:	83 c4 1c             	add    $0x1c,%esp
  802415:	5b                   	pop    %ebx
  802416:	5e                   	pop    %esi
  802417:	5f                   	pop    %edi
  802418:	5d                   	pop    %ebp
  802419:	c3                   	ret    
  80241a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802420:	0f bd e8             	bsr    %eax,%ebp
  802423:	83 f5 1f             	xor    $0x1f,%ebp
  802426:	75 50                	jne    802478 <__umoddi3+0xa8>
  802428:	39 d8                	cmp    %ebx,%eax
  80242a:	0f 82 e0 00 00 00    	jb     802510 <__umoddi3+0x140>
  802430:	89 d9                	mov    %ebx,%ecx
  802432:	39 f7                	cmp    %esi,%edi
  802434:	0f 86 d6 00 00 00    	jbe    802510 <__umoddi3+0x140>
  80243a:	89 d0                	mov    %edx,%eax
  80243c:	89 ca                	mov    %ecx,%edx
  80243e:	83 c4 1c             	add    $0x1c,%esp
  802441:	5b                   	pop    %ebx
  802442:	5e                   	pop    %esi
  802443:	5f                   	pop    %edi
  802444:	5d                   	pop    %ebp
  802445:	c3                   	ret    
  802446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80244d:	8d 76 00             	lea    0x0(%esi),%esi
  802450:	89 fd                	mov    %edi,%ebp
  802452:	85 ff                	test   %edi,%edi
  802454:	75 0b                	jne    802461 <__umoddi3+0x91>
  802456:	b8 01 00 00 00       	mov    $0x1,%eax
  80245b:	31 d2                	xor    %edx,%edx
  80245d:	f7 f7                	div    %edi
  80245f:	89 c5                	mov    %eax,%ebp
  802461:	89 d8                	mov    %ebx,%eax
  802463:	31 d2                	xor    %edx,%edx
  802465:	f7 f5                	div    %ebp
  802467:	89 f0                	mov    %esi,%eax
  802469:	f7 f5                	div    %ebp
  80246b:	89 d0                	mov    %edx,%eax
  80246d:	31 d2                	xor    %edx,%edx
  80246f:	eb 8c                	jmp    8023fd <__umoddi3+0x2d>
  802471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802478:	89 e9                	mov    %ebp,%ecx
  80247a:	ba 20 00 00 00       	mov    $0x20,%edx
  80247f:	29 ea                	sub    %ebp,%edx
  802481:	d3 e0                	shl    %cl,%eax
  802483:	89 44 24 08          	mov    %eax,0x8(%esp)
  802487:	89 d1                	mov    %edx,%ecx
  802489:	89 f8                	mov    %edi,%eax
  80248b:	d3 e8                	shr    %cl,%eax
  80248d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802491:	89 54 24 04          	mov    %edx,0x4(%esp)
  802495:	8b 54 24 04          	mov    0x4(%esp),%edx
  802499:	09 c1                	or     %eax,%ecx
  80249b:	89 d8                	mov    %ebx,%eax
  80249d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024a1:	89 e9                	mov    %ebp,%ecx
  8024a3:	d3 e7                	shl    %cl,%edi
  8024a5:	89 d1                	mov    %edx,%ecx
  8024a7:	d3 e8                	shr    %cl,%eax
  8024a9:	89 e9                	mov    %ebp,%ecx
  8024ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024af:	d3 e3                	shl    %cl,%ebx
  8024b1:	89 c7                	mov    %eax,%edi
  8024b3:	89 d1                	mov    %edx,%ecx
  8024b5:	89 f0                	mov    %esi,%eax
  8024b7:	d3 e8                	shr    %cl,%eax
  8024b9:	89 e9                	mov    %ebp,%ecx
  8024bb:	89 fa                	mov    %edi,%edx
  8024bd:	d3 e6                	shl    %cl,%esi
  8024bf:	09 d8                	or     %ebx,%eax
  8024c1:	f7 74 24 08          	divl   0x8(%esp)
  8024c5:	89 d1                	mov    %edx,%ecx
  8024c7:	89 f3                	mov    %esi,%ebx
  8024c9:	f7 64 24 0c          	mull   0xc(%esp)
  8024cd:	89 c6                	mov    %eax,%esi
  8024cf:	89 d7                	mov    %edx,%edi
  8024d1:	39 d1                	cmp    %edx,%ecx
  8024d3:	72 06                	jb     8024db <__umoddi3+0x10b>
  8024d5:	75 10                	jne    8024e7 <__umoddi3+0x117>
  8024d7:	39 c3                	cmp    %eax,%ebx
  8024d9:	73 0c                	jae    8024e7 <__umoddi3+0x117>
  8024db:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8024df:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8024e3:	89 d7                	mov    %edx,%edi
  8024e5:	89 c6                	mov    %eax,%esi
  8024e7:	89 ca                	mov    %ecx,%edx
  8024e9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024ee:	29 f3                	sub    %esi,%ebx
  8024f0:	19 fa                	sbb    %edi,%edx
  8024f2:	89 d0                	mov    %edx,%eax
  8024f4:	d3 e0                	shl    %cl,%eax
  8024f6:	89 e9                	mov    %ebp,%ecx
  8024f8:	d3 eb                	shr    %cl,%ebx
  8024fa:	d3 ea                	shr    %cl,%edx
  8024fc:	09 d8                	or     %ebx,%eax
  8024fe:	83 c4 1c             	add    $0x1c,%esp
  802501:	5b                   	pop    %ebx
  802502:	5e                   	pop    %esi
  802503:	5f                   	pop    %edi
  802504:	5d                   	pop    %ebp
  802505:	c3                   	ret    
  802506:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80250d:	8d 76 00             	lea    0x0(%esi),%esi
  802510:	29 fe                	sub    %edi,%esi
  802512:	19 c3                	sbb    %eax,%ebx
  802514:	89 f2                	mov    %esi,%edx
  802516:	89 d9                	mov    %ebx,%ecx
  802518:	e9 1d ff ff ff       	jmp    80243a <__umoddi3+0x6a>
