
obj/user/testpteshare.debug:     file format elf32-i386


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
  80002c:	e8 6b 01 00 00       	call   80019c <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <childofspawn>:
	breakpoint();
}

void
childofspawn(void)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	83 ec 10             	sub    $0x10,%esp
	strcpy(VA, msg2);
  80003d:	ff 35 00 40 80 00    	pushl  0x804000
  800043:	68 00 00 00 a0       	push   $0xa0000000
  800048:	e8 a8 08 00 00       	call   8008f5 <strcpy>
	exit();
  80004d:	e8 94 01 00 00       	call   8001e6 <exit>
}
  800052:	83 c4 10             	add    $0x10,%esp
  800055:	c9                   	leave  
  800056:	c3                   	ret    

00800057 <umain>:
{
  800057:	f3 0f 1e fb          	endbr32 
  80005b:	55                   	push   %ebp
  80005c:	89 e5                	mov    %esp,%ebp
  80005e:	53                   	push   %ebx
  80005f:	83 ec 04             	sub    $0x4,%esp
	if (argc != 0)
  800062:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800066:	0f 85 d0 00 00 00    	jne    80013c <umain+0xe5>
	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80006c:	83 ec 04             	sub    $0x4,%esp
  80006f:	68 07 04 00 00       	push   $0x407
  800074:	68 00 00 00 a0       	push   $0xa0000000
  800079:	6a 00                	push   $0x0
  80007b:	e8 b7 0c 00 00       	call   800d37 <sys_page_alloc>
  800080:	83 c4 10             	add    $0x10,%esp
  800083:	85 c0                	test   %eax,%eax
  800085:	0f 88 bb 00 00 00    	js     800146 <umain+0xef>
	if ((r = fork()) < 0)
  80008b:	e8 98 0f 00 00       	call   801028 <fork>
  800090:	89 c3                	mov    %eax,%ebx
  800092:	85 c0                	test   %eax,%eax
  800094:	0f 88 be 00 00 00    	js     800158 <umain+0x101>
	if (r == 0) {
  80009a:	0f 84 ca 00 00 00    	je     80016a <umain+0x113>
	wait(r);
  8000a0:	83 ec 0c             	sub    $0xc,%esp
  8000a3:	53                   	push   %ebx
  8000a4:	e8 56 23 00 00       	call   8023ff <wait>
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  8000a9:	83 c4 08             	add    $0x8,%esp
  8000ac:	ff 35 04 40 80 00    	pushl  0x804004
  8000b2:	68 00 00 00 a0       	push   $0xa0000000
  8000b7:	e8 f8 08 00 00       	call   8009b4 <strcmp>
  8000bc:	83 c4 08             	add    $0x8,%esp
  8000bf:	85 c0                	test   %eax,%eax
  8000c1:	b8 40 2a 80 00       	mov    $0x802a40,%eax
  8000c6:	ba 46 2a 80 00       	mov    $0x802a46,%edx
  8000cb:	0f 45 c2             	cmovne %edx,%eax
  8000ce:	50                   	push   %eax
  8000cf:	68 73 2a 80 00       	push   $0x802a73
  8000d4:	e8 12 02 00 00       	call   8002eb <cprintf>
	if ((r = spawnl("/testpteshare", "testpteshare", "arg", 0)) < 0)
  8000d9:	6a 00                	push   $0x0
  8000db:	68 8e 2a 80 00       	push   $0x802a8e
  8000e0:	68 93 2a 80 00       	push   $0x802a93
  8000e5:	68 92 2a 80 00       	push   $0x802a92
  8000ea:	e8 f8 1e 00 00       	call   801fe7 <spawnl>
  8000ef:	83 c4 20             	add    $0x20,%esp
  8000f2:	85 c0                	test   %eax,%eax
  8000f4:	0f 88 90 00 00 00    	js     80018a <umain+0x133>
	wait(r);
  8000fa:	83 ec 0c             	sub    $0xc,%esp
  8000fd:	50                   	push   %eax
  8000fe:	e8 fc 22 00 00       	call   8023ff <wait>
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  800103:	83 c4 08             	add    $0x8,%esp
  800106:	ff 35 00 40 80 00    	pushl  0x804000
  80010c:	68 00 00 00 a0       	push   $0xa0000000
  800111:	e8 9e 08 00 00       	call   8009b4 <strcmp>
  800116:	83 c4 08             	add    $0x8,%esp
  800119:	85 c0                	test   %eax,%eax
  80011b:	b8 40 2a 80 00       	mov    $0x802a40,%eax
  800120:	ba 46 2a 80 00       	mov    $0x802a46,%edx
  800125:	0f 45 c2             	cmovne %edx,%eax
  800128:	50                   	push   %eax
  800129:	68 aa 2a 80 00       	push   $0x802aaa
  80012e:	e8 b8 01 00 00       	call   8002eb <cprintf>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  800133:	cc                   	int3   
}
  800134:	83 c4 10             	add    $0x10,%esp
  800137:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80013a:	c9                   	leave  
  80013b:	c3                   	ret    
		childofspawn();
  80013c:	e8 f2 fe ff ff       	call   800033 <childofspawn>
  800141:	e9 26 ff ff ff       	jmp    80006c <umain+0x15>
		panic("sys_page_alloc: %e", r);
  800146:	50                   	push   %eax
  800147:	68 4c 2a 80 00       	push   $0x802a4c
  80014c:	6a 13                	push   $0x13
  80014e:	68 5f 2a 80 00       	push   $0x802a5f
  800153:	e8 ac 00 00 00       	call   800204 <_panic>
		panic("fork: %e", r);
  800158:	50                   	push   %eax
  800159:	68 85 2e 80 00       	push   $0x802e85
  80015e:	6a 17                	push   $0x17
  800160:	68 5f 2a 80 00       	push   $0x802a5f
  800165:	e8 9a 00 00 00       	call   800204 <_panic>
		strcpy(VA, msg);
  80016a:	83 ec 08             	sub    $0x8,%esp
  80016d:	ff 35 04 40 80 00    	pushl  0x804004
  800173:	68 00 00 00 a0       	push   $0xa0000000
  800178:	e8 78 07 00 00       	call   8008f5 <strcpy>
		exit();
  80017d:	e8 64 00 00 00       	call   8001e6 <exit>
  800182:	83 c4 10             	add    $0x10,%esp
  800185:	e9 16 ff ff ff       	jmp    8000a0 <umain+0x49>
		panic("spawn: %e", r);
  80018a:	50                   	push   %eax
  80018b:	68 a0 2a 80 00       	push   $0x802aa0
  800190:	6a 21                	push   $0x21
  800192:	68 5f 2a 80 00       	push   $0x802a5f
  800197:	e8 68 00 00 00       	call   800204 <_panic>

0080019c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80019c:	f3 0f 1e fb          	endbr32 
  8001a0:	55                   	push   %ebp
  8001a1:	89 e5                	mov    %esp,%ebp
  8001a3:	56                   	push   %esi
  8001a4:	53                   	push   %ebx
  8001a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001a8:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001ab:	e8 41 0b 00 00       	call   800cf1 <sys_getenvid>
  8001b0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001b5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001b8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001bd:	a3 04 50 80 00       	mov    %eax,0x805004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001c2:	85 db                	test   %ebx,%ebx
  8001c4:	7e 07                	jle    8001cd <libmain+0x31>
		binaryname = argv[0];
  8001c6:	8b 06                	mov    (%esi),%eax
  8001c8:	a3 08 40 80 00       	mov    %eax,0x804008

	// call user main routine
	umain(argc, argv);
  8001cd:	83 ec 08             	sub    $0x8,%esp
  8001d0:	56                   	push   %esi
  8001d1:	53                   	push   %ebx
  8001d2:	e8 80 fe ff ff       	call   800057 <umain>

	// exit gracefully
	exit();
  8001d7:	e8 0a 00 00 00       	call   8001e6 <exit>
}
  8001dc:	83 c4 10             	add    $0x10,%esp
  8001df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001e2:	5b                   	pop    %ebx
  8001e3:	5e                   	pop    %esi
  8001e4:	5d                   	pop    %ebp
  8001e5:	c3                   	ret    

008001e6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001e6:	f3 0f 1e fb          	endbr32 
  8001ea:	55                   	push   %ebp
  8001eb:	89 e5                	mov    %esp,%ebp
  8001ed:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8001f0:	e8 3b 12 00 00       	call   801430 <close_all>
	sys_env_destroy(0);
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	6a 00                	push   $0x0
  8001fa:	e8 ad 0a 00 00       	call   800cac <sys_env_destroy>
}
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	c9                   	leave  
  800203:	c3                   	ret    

00800204 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800204:	f3 0f 1e fb          	endbr32 
  800208:	55                   	push   %ebp
  800209:	89 e5                	mov    %esp,%ebp
  80020b:	56                   	push   %esi
  80020c:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80020d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800210:	8b 35 08 40 80 00    	mov    0x804008,%esi
  800216:	e8 d6 0a 00 00       	call   800cf1 <sys_getenvid>
  80021b:	83 ec 0c             	sub    $0xc,%esp
  80021e:	ff 75 0c             	pushl  0xc(%ebp)
  800221:	ff 75 08             	pushl  0x8(%ebp)
  800224:	56                   	push   %esi
  800225:	50                   	push   %eax
  800226:	68 f0 2a 80 00       	push   $0x802af0
  80022b:	e8 bb 00 00 00       	call   8002eb <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800230:	83 c4 18             	add    $0x18,%esp
  800233:	53                   	push   %ebx
  800234:	ff 75 10             	pushl  0x10(%ebp)
  800237:	e8 5a 00 00 00       	call   800296 <vcprintf>
	cprintf("\n");
  80023c:	c7 04 24 d7 30 80 00 	movl   $0x8030d7,(%esp)
  800243:	e8 a3 00 00 00       	call   8002eb <cprintf>
  800248:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80024b:	cc                   	int3   
  80024c:	eb fd                	jmp    80024b <_panic+0x47>

0080024e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80024e:	f3 0f 1e fb          	endbr32 
  800252:	55                   	push   %ebp
  800253:	89 e5                	mov    %esp,%ebp
  800255:	53                   	push   %ebx
  800256:	83 ec 04             	sub    $0x4,%esp
  800259:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80025c:	8b 13                	mov    (%ebx),%edx
  80025e:	8d 42 01             	lea    0x1(%edx),%eax
  800261:	89 03                	mov    %eax,(%ebx)
  800263:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800266:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80026a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80026f:	74 09                	je     80027a <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800271:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800275:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800278:	c9                   	leave  
  800279:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80027a:	83 ec 08             	sub    $0x8,%esp
  80027d:	68 ff 00 00 00       	push   $0xff
  800282:	8d 43 08             	lea    0x8(%ebx),%eax
  800285:	50                   	push   %eax
  800286:	e8 dc 09 00 00       	call   800c67 <sys_cputs>
		b->idx = 0;
  80028b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800291:	83 c4 10             	add    $0x10,%esp
  800294:	eb db                	jmp    800271 <putch+0x23>

00800296 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800296:	f3 0f 1e fb          	endbr32 
  80029a:	55                   	push   %ebp
  80029b:	89 e5                	mov    %esp,%ebp
  80029d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002a3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002aa:	00 00 00 
	b.cnt = 0;
  8002ad:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002b4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002b7:	ff 75 0c             	pushl  0xc(%ebp)
  8002ba:	ff 75 08             	pushl  0x8(%ebp)
  8002bd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002c3:	50                   	push   %eax
  8002c4:	68 4e 02 80 00       	push   $0x80024e
  8002c9:	e8 20 01 00 00       	call   8003ee <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002ce:	83 c4 08             	add    $0x8,%esp
  8002d1:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002d7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002dd:	50                   	push   %eax
  8002de:	e8 84 09 00 00       	call   800c67 <sys_cputs>

	return b.cnt;
}
  8002e3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002e9:	c9                   	leave  
  8002ea:	c3                   	ret    

008002eb <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002eb:	f3 0f 1e fb          	endbr32 
  8002ef:	55                   	push   %ebp
  8002f0:	89 e5                	mov    %esp,%ebp
  8002f2:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002f5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002f8:	50                   	push   %eax
  8002f9:	ff 75 08             	pushl  0x8(%ebp)
  8002fc:	e8 95 ff ff ff       	call   800296 <vcprintf>
	va_end(ap);

	return cnt;
}
  800301:	c9                   	leave  
  800302:	c3                   	ret    

00800303 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800303:	55                   	push   %ebp
  800304:	89 e5                	mov    %esp,%ebp
  800306:	57                   	push   %edi
  800307:	56                   	push   %esi
  800308:	53                   	push   %ebx
  800309:	83 ec 1c             	sub    $0x1c,%esp
  80030c:	89 c7                	mov    %eax,%edi
  80030e:	89 d6                	mov    %edx,%esi
  800310:	8b 45 08             	mov    0x8(%ebp),%eax
  800313:	8b 55 0c             	mov    0xc(%ebp),%edx
  800316:	89 d1                	mov    %edx,%ecx
  800318:	89 c2                	mov    %eax,%edx
  80031a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80031d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800320:	8b 45 10             	mov    0x10(%ebp),%eax
  800323:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800326:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800329:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800330:	39 c2                	cmp    %eax,%edx
  800332:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800335:	72 3e                	jb     800375 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800337:	83 ec 0c             	sub    $0xc,%esp
  80033a:	ff 75 18             	pushl  0x18(%ebp)
  80033d:	83 eb 01             	sub    $0x1,%ebx
  800340:	53                   	push   %ebx
  800341:	50                   	push   %eax
  800342:	83 ec 08             	sub    $0x8,%esp
  800345:	ff 75 e4             	pushl  -0x1c(%ebp)
  800348:	ff 75 e0             	pushl  -0x20(%ebp)
  80034b:	ff 75 dc             	pushl  -0x24(%ebp)
  80034e:	ff 75 d8             	pushl  -0x28(%ebp)
  800351:	e8 8a 24 00 00       	call   8027e0 <__udivdi3>
  800356:	83 c4 18             	add    $0x18,%esp
  800359:	52                   	push   %edx
  80035a:	50                   	push   %eax
  80035b:	89 f2                	mov    %esi,%edx
  80035d:	89 f8                	mov    %edi,%eax
  80035f:	e8 9f ff ff ff       	call   800303 <printnum>
  800364:	83 c4 20             	add    $0x20,%esp
  800367:	eb 13                	jmp    80037c <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800369:	83 ec 08             	sub    $0x8,%esp
  80036c:	56                   	push   %esi
  80036d:	ff 75 18             	pushl  0x18(%ebp)
  800370:	ff d7                	call   *%edi
  800372:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800375:	83 eb 01             	sub    $0x1,%ebx
  800378:	85 db                	test   %ebx,%ebx
  80037a:	7f ed                	jg     800369 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80037c:	83 ec 08             	sub    $0x8,%esp
  80037f:	56                   	push   %esi
  800380:	83 ec 04             	sub    $0x4,%esp
  800383:	ff 75 e4             	pushl  -0x1c(%ebp)
  800386:	ff 75 e0             	pushl  -0x20(%ebp)
  800389:	ff 75 dc             	pushl  -0x24(%ebp)
  80038c:	ff 75 d8             	pushl  -0x28(%ebp)
  80038f:	e8 5c 25 00 00       	call   8028f0 <__umoddi3>
  800394:	83 c4 14             	add    $0x14,%esp
  800397:	0f be 80 13 2b 80 00 	movsbl 0x802b13(%eax),%eax
  80039e:	50                   	push   %eax
  80039f:	ff d7                	call   *%edi
}
  8003a1:	83 c4 10             	add    $0x10,%esp
  8003a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003a7:	5b                   	pop    %ebx
  8003a8:	5e                   	pop    %esi
  8003a9:	5f                   	pop    %edi
  8003aa:	5d                   	pop    %ebp
  8003ab:	c3                   	ret    

008003ac <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003ac:	f3 0f 1e fb          	endbr32 
  8003b0:	55                   	push   %ebp
  8003b1:	89 e5                	mov    %esp,%ebp
  8003b3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003b6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003ba:	8b 10                	mov    (%eax),%edx
  8003bc:	3b 50 04             	cmp    0x4(%eax),%edx
  8003bf:	73 0a                	jae    8003cb <sprintputch+0x1f>
		*b->buf++ = ch;
  8003c1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003c4:	89 08                	mov    %ecx,(%eax)
  8003c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c9:	88 02                	mov    %al,(%edx)
}
  8003cb:	5d                   	pop    %ebp
  8003cc:	c3                   	ret    

008003cd <printfmt>:
{
  8003cd:	f3 0f 1e fb          	endbr32 
  8003d1:	55                   	push   %ebp
  8003d2:	89 e5                	mov    %esp,%ebp
  8003d4:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003d7:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003da:	50                   	push   %eax
  8003db:	ff 75 10             	pushl  0x10(%ebp)
  8003de:	ff 75 0c             	pushl  0xc(%ebp)
  8003e1:	ff 75 08             	pushl  0x8(%ebp)
  8003e4:	e8 05 00 00 00       	call   8003ee <vprintfmt>
}
  8003e9:	83 c4 10             	add    $0x10,%esp
  8003ec:	c9                   	leave  
  8003ed:	c3                   	ret    

008003ee <vprintfmt>:
{
  8003ee:	f3 0f 1e fb          	endbr32 
  8003f2:	55                   	push   %ebp
  8003f3:	89 e5                	mov    %esp,%ebp
  8003f5:	57                   	push   %edi
  8003f6:	56                   	push   %esi
  8003f7:	53                   	push   %ebx
  8003f8:	83 ec 3c             	sub    $0x3c,%esp
  8003fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8003fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800401:	8b 7d 10             	mov    0x10(%ebp),%edi
  800404:	e9 8e 03 00 00       	jmp    800797 <vprintfmt+0x3a9>
		padc = ' ';
  800409:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80040d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800414:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80041b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800422:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800427:	8d 47 01             	lea    0x1(%edi),%eax
  80042a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80042d:	0f b6 17             	movzbl (%edi),%edx
  800430:	8d 42 dd             	lea    -0x23(%edx),%eax
  800433:	3c 55                	cmp    $0x55,%al
  800435:	0f 87 df 03 00 00    	ja     80081a <vprintfmt+0x42c>
  80043b:	0f b6 c0             	movzbl %al,%eax
  80043e:	3e ff 24 85 60 2c 80 	notrack jmp *0x802c60(,%eax,4)
  800445:	00 
  800446:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800449:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80044d:	eb d8                	jmp    800427 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80044f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800452:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800456:	eb cf                	jmp    800427 <vprintfmt+0x39>
  800458:	0f b6 d2             	movzbl %dl,%edx
  80045b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80045e:	b8 00 00 00 00       	mov    $0x0,%eax
  800463:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800466:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800469:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80046d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800470:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800473:	83 f9 09             	cmp    $0x9,%ecx
  800476:	77 55                	ja     8004cd <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800478:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80047b:	eb e9                	jmp    800466 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80047d:	8b 45 14             	mov    0x14(%ebp),%eax
  800480:	8b 00                	mov    (%eax),%eax
  800482:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800485:	8b 45 14             	mov    0x14(%ebp),%eax
  800488:	8d 40 04             	lea    0x4(%eax),%eax
  80048b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80048e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800491:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800495:	79 90                	jns    800427 <vprintfmt+0x39>
				width = precision, precision = -1;
  800497:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80049a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80049d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004a4:	eb 81                	jmp    800427 <vprintfmt+0x39>
  8004a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004a9:	85 c0                	test   %eax,%eax
  8004ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8004b0:	0f 49 d0             	cmovns %eax,%edx
  8004b3:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004b6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004b9:	e9 69 ff ff ff       	jmp    800427 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8004be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004c1:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8004c8:	e9 5a ff ff ff       	jmp    800427 <vprintfmt+0x39>
  8004cd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004d3:	eb bc                	jmp    800491 <vprintfmt+0xa3>
			lflag++;
  8004d5:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004d8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004db:	e9 47 ff ff ff       	jmp    800427 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8004e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e3:	8d 78 04             	lea    0x4(%eax),%edi
  8004e6:	83 ec 08             	sub    $0x8,%esp
  8004e9:	53                   	push   %ebx
  8004ea:	ff 30                	pushl  (%eax)
  8004ec:	ff d6                	call   *%esi
			break;
  8004ee:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004f1:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004f4:	e9 9b 02 00 00       	jmp    800794 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8004f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fc:	8d 78 04             	lea    0x4(%eax),%edi
  8004ff:	8b 00                	mov    (%eax),%eax
  800501:	99                   	cltd   
  800502:	31 d0                	xor    %edx,%eax
  800504:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800506:	83 f8 0f             	cmp    $0xf,%eax
  800509:	7f 23                	jg     80052e <vprintfmt+0x140>
  80050b:	8b 14 85 c0 2d 80 00 	mov    0x802dc0(,%eax,4),%edx
  800512:	85 d2                	test   %edx,%edx
  800514:	74 18                	je     80052e <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800516:	52                   	push   %edx
  800517:	68 6d 2f 80 00       	push   $0x802f6d
  80051c:	53                   	push   %ebx
  80051d:	56                   	push   %esi
  80051e:	e8 aa fe ff ff       	call   8003cd <printfmt>
  800523:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800526:	89 7d 14             	mov    %edi,0x14(%ebp)
  800529:	e9 66 02 00 00       	jmp    800794 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80052e:	50                   	push   %eax
  80052f:	68 2b 2b 80 00       	push   $0x802b2b
  800534:	53                   	push   %ebx
  800535:	56                   	push   %esi
  800536:	e8 92 fe ff ff       	call   8003cd <printfmt>
  80053b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80053e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800541:	e9 4e 02 00 00       	jmp    800794 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800546:	8b 45 14             	mov    0x14(%ebp),%eax
  800549:	83 c0 04             	add    $0x4,%eax
  80054c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80054f:	8b 45 14             	mov    0x14(%ebp),%eax
  800552:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800554:	85 d2                	test   %edx,%edx
  800556:	b8 24 2b 80 00       	mov    $0x802b24,%eax
  80055b:	0f 45 c2             	cmovne %edx,%eax
  80055e:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800561:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800565:	7e 06                	jle    80056d <vprintfmt+0x17f>
  800567:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80056b:	75 0d                	jne    80057a <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80056d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800570:	89 c7                	mov    %eax,%edi
  800572:	03 45 e0             	add    -0x20(%ebp),%eax
  800575:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800578:	eb 55                	jmp    8005cf <vprintfmt+0x1e1>
  80057a:	83 ec 08             	sub    $0x8,%esp
  80057d:	ff 75 d8             	pushl  -0x28(%ebp)
  800580:	ff 75 cc             	pushl  -0x34(%ebp)
  800583:	e8 46 03 00 00       	call   8008ce <strnlen>
  800588:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80058b:	29 c2                	sub    %eax,%edx
  80058d:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800590:	83 c4 10             	add    $0x10,%esp
  800593:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800595:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800599:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80059c:	85 ff                	test   %edi,%edi
  80059e:	7e 11                	jle    8005b1 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8005a0:	83 ec 08             	sub    $0x8,%esp
  8005a3:	53                   	push   %ebx
  8005a4:	ff 75 e0             	pushl  -0x20(%ebp)
  8005a7:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a9:	83 ef 01             	sub    $0x1,%edi
  8005ac:	83 c4 10             	add    $0x10,%esp
  8005af:	eb eb                	jmp    80059c <vprintfmt+0x1ae>
  8005b1:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8005b4:	85 d2                	test   %edx,%edx
  8005b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8005bb:	0f 49 c2             	cmovns %edx,%eax
  8005be:	29 c2                	sub    %eax,%edx
  8005c0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8005c3:	eb a8                	jmp    80056d <vprintfmt+0x17f>
					putch(ch, putdat);
  8005c5:	83 ec 08             	sub    $0x8,%esp
  8005c8:	53                   	push   %ebx
  8005c9:	52                   	push   %edx
  8005ca:	ff d6                	call   *%esi
  8005cc:	83 c4 10             	add    $0x10,%esp
  8005cf:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005d2:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005d4:	83 c7 01             	add    $0x1,%edi
  8005d7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005db:	0f be d0             	movsbl %al,%edx
  8005de:	85 d2                	test   %edx,%edx
  8005e0:	74 4b                	je     80062d <vprintfmt+0x23f>
  8005e2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005e6:	78 06                	js     8005ee <vprintfmt+0x200>
  8005e8:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005ec:	78 1e                	js     80060c <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8005ee:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005f2:	74 d1                	je     8005c5 <vprintfmt+0x1d7>
  8005f4:	0f be c0             	movsbl %al,%eax
  8005f7:	83 e8 20             	sub    $0x20,%eax
  8005fa:	83 f8 5e             	cmp    $0x5e,%eax
  8005fd:	76 c6                	jbe    8005c5 <vprintfmt+0x1d7>
					putch('?', putdat);
  8005ff:	83 ec 08             	sub    $0x8,%esp
  800602:	53                   	push   %ebx
  800603:	6a 3f                	push   $0x3f
  800605:	ff d6                	call   *%esi
  800607:	83 c4 10             	add    $0x10,%esp
  80060a:	eb c3                	jmp    8005cf <vprintfmt+0x1e1>
  80060c:	89 cf                	mov    %ecx,%edi
  80060e:	eb 0e                	jmp    80061e <vprintfmt+0x230>
				putch(' ', putdat);
  800610:	83 ec 08             	sub    $0x8,%esp
  800613:	53                   	push   %ebx
  800614:	6a 20                	push   $0x20
  800616:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800618:	83 ef 01             	sub    $0x1,%edi
  80061b:	83 c4 10             	add    $0x10,%esp
  80061e:	85 ff                	test   %edi,%edi
  800620:	7f ee                	jg     800610 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800622:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800625:	89 45 14             	mov    %eax,0x14(%ebp)
  800628:	e9 67 01 00 00       	jmp    800794 <vprintfmt+0x3a6>
  80062d:	89 cf                	mov    %ecx,%edi
  80062f:	eb ed                	jmp    80061e <vprintfmt+0x230>
	if (lflag >= 2)
  800631:	83 f9 01             	cmp    $0x1,%ecx
  800634:	7f 1b                	jg     800651 <vprintfmt+0x263>
	else if (lflag)
  800636:	85 c9                	test   %ecx,%ecx
  800638:	74 63                	je     80069d <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80063a:	8b 45 14             	mov    0x14(%ebp),%eax
  80063d:	8b 00                	mov    (%eax),%eax
  80063f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800642:	99                   	cltd   
  800643:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800646:	8b 45 14             	mov    0x14(%ebp),%eax
  800649:	8d 40 04             	lea    0x4(%eax),%eax
  80064c:	89 45 14             	mov    %eax,0x14(%ebp)
  80064f:	eb 17                	jmp    800668 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800651:	8b 45 14             	mov    0x14(%ebp),%eax
  800654:	8b 50 04             	mov    0x4(%eax),%edx
  800657:	8b 00                	mov    (%eax),%eax
  800659:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80065f:	8b 45 14             	mov    0x14(%ebp),%eax
  800662:	8d 40 08             	lea    0x8(%eax),%eax
  800665:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800668:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80066b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80066e:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800673:	85 c9                	test   %ecx,%ecx
  800675:	0f 89 ff 00 00 00    	jns    80077a <vprintfmt+0x38c>
				putch('-', putdat);
  80067b:	83 ec 08             	sub    $0x8,%esp
  80067e:	53                   	push   %ebx
  80067f:	6a 2d                	push   $0x2d
  800681:	ff d6                	call   *%esi
				num = -(long long) num;
  800683:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800686:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800689:	f7 da                	neg    %edx
  80068b:	83 d1 00             	adc    $0x0,%ecx
  80068e:	f7 d9                	neg    %ecx
  800690:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800693:	b8 0a 00 00 00       	mov    $0xa,%eax
  800698:	e9 dd 00 00 00       	jmp    80077a <vprintfmt+0x38c>
		return va_arg(*ap, int);
  80069d:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a0:	8b 00                	mov    (%eax),%eax
  8006a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a5:	99                   	cltd   
  8006a6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ac:	8d 40 04             	lea    0x4(%eax),%eax
  8006af:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b2:	eb b4                	jmp    800668 <vprintfmt+0x27a>
	if (lflag >= 2)
  8006b4:	83 f9 01             	cmp    $0x1,%ecx
  8006b7:	7f 1e                	jg     8006d7 <vprintfmt+0x2e9>
	else if (lflag)
  8006b9:	85 c9                	test   %ecx,%ecx
  8006bb:	74 32                	je     8006ef <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8006bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c0:	8b 10                	mov    (%eax),%edx
  8006c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006c7:	8d 40 04             	lea    0x4(%eax),%eax
  8006ca:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006cd:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8006d2:	e9 a3 00 00 00       	jmp    80077a <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8006d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006da:	8b 10                	mov    (%eax),%edx
  8006dc:	8b 48 04             	mov    0x4(%eax),%ecx
  8006df:	8d 40 08             	lea    0x8(%eax),%eax
  8006e2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006e5:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8006ea:	e9 8b 00 00 00       	jmp    80077a <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f2:	8b 10                	mov    (%eax),%edx
  8006f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006f9:	8d 40 04             	lea    0x4(%eax),%eax
  8006fc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ff:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800704:	eb 74                	jmp    80077a <vprintfmt+0x38c>
	if (lflag >= 2)
  800706:	83 f9 01             	cmp    $0x1,%ecx
  800709:	7f 1b                	jg     800726 <vprintfmt+0x338>
	else if (lflag)
  80070b:	85 c9                	test   %ecx,%ecx
  80070d:	74 2c                	je     80073b <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  80070f:	8b 45 14             	mov    0x14(%ebp),%eax
  800712:	8b 10                	mov    (%eax),%edx
  800714:	b9 00 00 00 00       	mov    $0x0,%ecx
  800719:	8d 40 04             	lea    0x4(%eax),%eax
  80071c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80071f:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800724:	eb 54                	jmp    80077a <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800726:	8b 45 14             	mov    0x14(%ebp),%eax
  800729:	8b 10                	mov    (%eax),%edx
  80072b:	8b 48 04             	mov    0x4(%eax),%ecx
  80072e:	8d 40 08             	lea    0x8(%eax),%eax
  800731:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800734:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800739:	eb 3f                	jmp    80077a <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80073b:	8b 45 14             	mov    0x14(%ebp),%eax
  80073e:	8b 10                	mov    (%eax),%edx
  800740:	b9 00 00 00 00       	mov    $0x0,%ecx
  800745:	8d 40 04             	lea    0x4(%eax),%eax
  800748:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80074b:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800750:	eb 28                	jmp    80077a <vprintfmt+0x38c>
			putch('0', putdat);
  800752:	83 ec 08             	sub    $0x8,%esp
  800755:	53                   	push   %ebx
  800756:	6a 30                	push   $0x30
  800758:	ff d6                	call   *%esi
			putch('x', putdat);
  80075a:	83 c4 08             	add    $0x8,%esp
  80075d:	53                   	push   %ebx
  80075e:	6a 78                	push   $0x78
  800760:	ff d6                	call   *%esi
			num = (unsigned long long)
  800762:	8b 45 14             	mov    0x14(%ebp),%eax
  800765:	8b 10                	mov    (%eax),%edx
  800767:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80076c:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80076f:	8d 40 04             	lea    0x4(%eax),%eax
  800772:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800775:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80077a:	83 ec 0c             	sub    $0xc,%esp
  80077d:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800781:	57                   	push   %edi
  800782:	ff 75 e0             	pushl  -0x20(%ebp)
  800785:	50                   	push   %eax
  800786:	51                   	push   %ecx
  800787:	52                   	push   %edx
  800788:	89 da                	mov    %ebx,%edx
  80078a:	89 f0                	mov    %esi,%eax
  80078c:	e8 72 fb ff ff       	call   800303 <printnum>
			break;
  800791:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800794:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800797:	83 c7 01             	add    $0x1,%edi
  80079a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80079e:	83 f8 25             	cmp    $0x25,%eax
  8007a1:	0f 84 62 fc ff ff    	je     800409 <vprintfmt+0x1b>
			if (ch == '\0')
  8007a7:	85 c0                	test   %eax,%eax
  8007a9:	0f 84 8b 00 00 00    	je     80083a <vprintfmt+0x44c>
			putch(ch, putdat);
  8007af:	83 ec 08             	sub    $0x8,%esp
  8007b2:	53                   	push   %ebx
  8007b3:	50                   	push   %eax
  8007b4:	ff d6                	call   *%esi
  8007b6:	83 c4 10             	add    $0x10,%esp
  8007b9:	eb dc                	jmp    800797 <vprintfmt+0x3a9>
	if (lflag >= 2)
  8007bb:	83 f9 01             	cmp    $0x1,%ecx
  8007be:	7f 1b                	jg     8007db <vprintfmt+0x3ed>
	else if (lflag)
  8007c0:	85 c9                	test   %ecx,%ecx
  8007c2:	74 2c                	je     8007f0 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8007c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c7:	8b 10                	mov    (%eax),%edx
  8007c9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007ce:	8d 40 04             	lea    0x4(%eax),%eax
  8007d1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d4:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8007d9:	eb 9f                	jmp    80077a <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8007db:	8b 45 14             	mov    0x14(%ebp),%eax
  8007de:	8b 10                	mov    (%eax),%edx
  8007e0:	8b 48 04             	mov    0x4(%eax),%ecx
  8007e3:	8d 40 08             	lea    0x8(%eax),%eax
  8007e6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e9:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8007ee:	eb 8a                	jmp    80077a <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8007f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f3:	8b 10                	mov    (%eax),%edx
  8007f5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007fa:	8d 40 04             	lea    0x4(%eax),%eax
  8007fd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800800:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800805:	e9 70 ff ff ff       	jmp    80077a <vprintfmt+0x38c>
			putch(ch, putdat);
  80080a:	83 ec 08             	sub    $0x8,%esp
  80080d:	53                   	push   %ebx
  80080e:	6a 25                	push   $0x25
  800810:	ff d6                	call   *%esi
			break;
  800812:	83 c4 10             	add    $0x10,%esp
  800815:	e9 7a ff ff ff       	jmp    800794 <vprintfmt+0x3a6>
			putch('%', putdat);
  80081a:	83 ec 08             	sub    $0x8,%esp
  80081d:	53                   	push   %ebx
  80081e:	6a 25                	push   $0x25
  800820:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800822:	83 c4 10             	add    $0x10,%esp
  800825:	89 f8                	mov    %edi,%eax
  800827:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80082b:	74 05                	je     800832 <vprintfmt+0x444>
  80082d:	83 e8 01             	sub    $0x1,%eax
  800830:	eb f5                	jmp    800827 <vprintfmt+0x439>
  800832:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800835:	e9 5a ff ff ff       	jmp    800794 <vprintfmt+0x3a6>
}
  80083a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80083d:	5b                   	pop    %ebx
  80083e:	5e                   	pop    %esi
  80083f:	5f                   	pop    %edi
  800840:	5d                   	pop    %ebp
  800841:	c3                   	ret    

00800842 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800842:	f3 0f 1e fb          	endbr32 
  800846:	55                   	push   %ebp
  800847:	89 e5                	mov    %esp,%ebp
  800849:	83 ec 18             	sub    $0x18,%esp
  80084c:	8b 45 08             	mov    0x8(%ebp),%eax
  80084f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800852:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800855:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800859:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80085c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800863:	85 c0                	test   %eax,%eax
  800865:	74 26                	je     80088d <vsnprintf+0x4b>
  800867:	85 d2                	test   %edx,%edx
  800869:	7e 22                	jle    80088d <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80086b:	ff 75 14             	pushl  0x14(%ebp)
  80086e:	ff 75 10             	pushl  0x10(%ebp)
  800871:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800874:	50                   	push   %eax
  800875:	68 ac 03 80 00       	push   $0x8003ac
  80087a:	e8 6f fb ff ff       	call   8003ee <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80087f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800882:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800888:	83 c4 10             	add    $0x10,%esp
}
  80088b:	c9                   	leave  
  80088c:	c3                   	ret    
		return -E_INVAL;
  80088d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800892:	eb f7                	jmp    80088b <vsnprintf+0x49>

00800894 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800894:	f3 0f 1e fb          	endbr32 
  800898:	55                   	push   %ebp
  800899:	89 e5                	mov    %esp,%ebp
  80089b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80089e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008a1:	50                   	push   %eax
  8008a2:	ff 75 10             	pushl  0x10(%ebp)
  8008a5:	ff 75 0c             	pushl  0xc(%ebp)
  8008a8:	ff 75 08             	pushl  0x8(%ebp)
  8008ab:	e8 92 ff ff ff       	call   800842 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008b0:	c9                   	leave  
  8008b1:	c3                   	ret    

008008b2 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008b2:	f3 0f 1e fb          	endbr32 
  8008b6:	55                   	push   %ebp
  8008b7:	89 e5                	mov    %esp,%ebp
  8008b9:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c1:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008c5:	74 05                	je     8008cc <strlen+0x1a>
		n++;
  8008c7:	83 c0 01             	add    $0x1,%eax
  8008ca:	eb f5                	jmp    8008c1 <strlen+0xf>
	return n;
}
  8008cc:	5d                   	pop    %ebp
  8008cd:	c3                   	ret    

008008ce <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008ce:	f3 0f 1e fb          	endbr32 
  8008d2:	55                   	push   %ebp
  8008d3:	89 e5                	mov    %esp,%ebp
  8008d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008d8:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008db:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e0:	39 d0                	cmp    %edx,%eax
  8008e2:	74 0d                	je     8008f1 <strnlen+0x23>
  8008e4:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008e8:	74 05                	je     8008ef <strnlen+0x21>
		n++;
  8008ea:	83 c0 01             	add    $0x1,%eax
  8008ed:	eb f1                	jmp    8008e0 <strnlen+0x12>
  8008ef:	89 c2                	mov    %eax,%edx
	return n;
}
  8008f1:	89 d0                	mov    %edx,%eax
  8008f3:	5d                   	pop    %ebp
  8008f4:	c3                   	ret    

008008f5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008f5:	f3 0f 1e fb          	endbr32 
  8008f9:	55                   	push   %ebp
  8008fa:	89 e5                	mov    %esp,%ebp
  8008fc:	53                   	push   %ebx
  8008fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800900:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800903:	b8 00 00 00 00       	mov    $0x0,%eax
  800908:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80090c:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  80090f:	83 c0 01             	add    $0x1,%eax
  800912:	84 d2                	test   %dl,%dl
  800914:	75 f2                	jne    800908 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800916:	89 c8                	mov    %ecx,%eax
  800918:	5b                   	pop    %ebx
  800919:	5d                   	pop    %ebp
  80091a:	c3                   	ret    

0080091b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80091b:	f3 0f 1e fb          	endbr32 
  80091f:	55                   	push   %ebp
  800920:	89 e5                	mov    %esp,%ebp
  800922:	53                   	push   %ebx
  800923:	83 ec 10             	sub    $0x10,%esp
  800926:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800929:	53                   	push   %ebx
  80092a:	e8 83 ff ff ff       	call   8008b2 <strlen>
  80092f:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800932:	ff 75 0c             	pushl  0xc(%ebp)
  800935:	01 d8                	add    %ebx,%eax
  800937:	50                   	push   %eax
  800938:	e8 b8 ff ff ff       	call   8008f5 <strcpy>
	return dst;
}
  80093d:	89 d8                	mov    %ebx,%eax
  80093f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800942:	c9                   	leave  
  800943:	c3                   	ret    

00800944 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800944:	f3 0f 1e fb          	endbr32 
  800948:	55                   	push   %ebp
  800949:	89 e5                	mov    %esp,%ebp
  80094b:	56                   	push   %esi
  80094c:	53                   	push   %ebx
  80094d:	8b 75 08             	mov    0x8(%ebp),%esi
  800950:	8b 55 0c             	mov    0xc(%ebp),%edx
  800953:	89 f3                	mov    %esi,%ebx
  800955:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800958:	89 f0                	mov    %esi,%eax
  80095a:	39 d8                	cmp    %ebx,%eax
  80095c:	74 11                	je     80096f <strncpy+0x2b>
		*dst++ = *src;
  80095e:	83 c0 01             	add    $0x1,%eax
  800961:	0f b6 0a             	movzbl (%edx),%ecx
  800964:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800967:	80 f9 01             	cmp    $0x1,%cl
  80096a:	83 da ff             	sbb    $0xffffffff,%edx
  80096d:	eb eb                	jmp    80095a <strncpy+0x16>
	}
	return ret;
}
  80096f:	89 f0                	mov    %esi,%eax
  800971:	5b                   	pop    %ebx
  800972:	5e                   	pop    %esi
  800973:	5d                   	pop    %ebp
  800974:	c3                   	ret    

00800975 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800975:	f3 0f 1e fb          	endbr32 
  800979:	55                   	push   %ebp
  80097a:	89 e5                	mov    %esp,%ebp
  80097c:	56                   	push   %esi
  80097d:	53                   	push   %ebx
  80097e:	8b 75 08             	mov    0x8(%ebp),%esi
  800981:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800984:	8b 55 10             	mov    0x10(%ebp),%edx
  800987:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800989:	85 d2                	test   %edx,%edx
  80098b:	74 21                	je     8009ae <strlcpy+0x39>
  80098d:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800991:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800993:	39 c2                	cmp    %eax,%edx
  800995:	74 14                	je     8009ab <strlcpy+0x36>
  800997:	0f b6 19             	movzbl (%ecx),%ebx
  80099a:	84 db                	test   %bl,%bl
  80099c:	74 0b                	je     8009a9 <strlcpy+0x34>
			*dst++ = *src++;
  80099e:	83 c1 01             	add    $0x1,%ecx
  8009a1:	83 c2 01             	add    $0x1,%edx
  8009a4:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009a7:	eb ea                	jmp    800993 <strlcpy+0x1e>
  8009a9:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009ab:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009ae:	29 f0                	sub    %esi,%eax
}
  8009b0:	5b                   	pop    %ebx
  8009b1:	5e                   	pop    %esi
  8009b2:	5d                   	pop    %ebp
  8009b3:	c3                   	ret    

008009b4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009b4:	f3 0f 1e fb          	endbr32 
  8009b8:	55                   	push   %ebp
  8009b9:	89 e5                	mov    %esp,%ebp
  8009bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009be:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009c1:	0f b6 01             	movzbl (%ecx),%eax
  8009c4:	84 c0                	test   %al,%al
  8009c6:	74 0c                	je     8009d4 <strcmp+0x20>
  8009c8:	3a 02                	cmp    (%edx),%al
  8009ca:	75 08                	jne    8009d4 <strcmp+0x20>
		p++, q++;
  8009cc:	83 c1 01             	add    $0x1,%ecx
  8009cf:	83 c2 01             	add    $0x1,%edx
  8009d2:	eb ed                	jmp    8009c1 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009d4:	0f b6 c0             	movzbl %al,%eax
  8009d7:	0f b6 12             	movzbl (%edx),%edx
  8009da:	29 d0                	sub    %edx,%eax
}
  8009dc:	5d                   	pop    %ebp
  8009dd:	c3                   	ret    

008009de <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009de:	f3 0f 1e fb          	endbr32 
  8009e2:	55                   	push   %ebp
  8009e3:	89 e5                	mov    %esp,%ebp
  8009e5:	53                   	push   %ebx
  8009e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ec:	89 c3                	mov    %eax,%ebx
  8009ee:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009f1:	eb 06                	jmp    8009f9 <strncmp+0x1b>
		n--, p++, q++;
  8009f3:	83 c0 01             	add    $0x1,%eax
  8009f6:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009f9:	39 d8                	cmp    %ebx,%eax
  8009fb:	74 16                	je     800a13 <strncmp+0x35>
  8009fd:	0f b6 08             	movzbl (%eax),%ecx
  800a00:	84 c9                	test   %cl,%cl
  800a02:	74 04                	je     800a08 <strncmp+0x2a>
  800a04:	3a 0a                	cmp    (%edx),%cl
  800a06:	74 eb                	je     8009f3 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a08:	0f b6 00             	movzbl (%eax),%eax
  800a0b:	0f b6 12             	movzbl (%edx),%edx
  800a0e:	29 d0                	sub    %edx,%eax
}
  800a10:	5b                   	pop    %ebx
  800a11:	5d                   	pop    %ebp
  800a12:	c3                   	ret    
		return 0;
  800a13:	b8 00 00 00 00       	mov    $0x0,%eax
  800a18:	eb f6                	jmp    800a10 <strncmp+0x32>

00800a1a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a1a:	f3 0f 1e fb          	endbr32 
  800a1e:	55                   	push   %ebp
  800a1f:	89 e5                	mov    %esp,%ebp
  800a21:	8b 45 08             	mov    0x8(%ebp),%eax
  800a24:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a28:	0f b6 10             	movzbl (%eax),%edx
  800a2b:	84 d2                	test   %dl,%dl
  800a2d:	74 09                	je     800a38 <strchr+0x1e>
		if (*s == c)
  800a2f:	38 ca                	cmp    %cl,%dl
  800a31:	74 0a                	je     800a3d <strchr+0x23>
	for (; *s; s++)
  800a33:	83 c0 01             	add    $0x1,%eax
  800a36:	eb f0                	jmp    800a28 <strchr+0xe>
			return (char *) s;
	return 0;
  800a38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a3d:	5d                   	pop    %ebp
  800a3e:	c3                   	ret    

00800a3f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a3f:	f3 0f 1e fb          	endbr32 
  800a43:	55                   	push   %ebp
  800a44:	89 e5                	mov    %esp,%ebp
  800a46:	8b 45 08             	mov    0x8(%ebp),%eax
  800a49:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a4d:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a50:	38 ca                	cmp    %cl,%dl
  800a52:	74 09                	je     800a5d <strfind+0x1e>
  800a54:	84 d2                	test   %dl,%dl
  800a56:	74 05                	je     800a5d <strfind+0x1e>
	for (; *s; s++)
  800a58:	83 c0 01             	add    $0x1,%eax
  800a5b:	eb f0                	jmp    800a4d <strfind+0xe>
			break;
	return (char *) s;
}
  800a5d:	5d                   	pop    %ebp
  800a5e:	c3                   	ret    

00800a5f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a5f:	f3 0f 1e fb          	endbr32 
  800a63:	55                   	push   %ebp
  800a64:	89 e5                	mov    %esp,%ebp
  800a66:	57                   	push   %edi
  800a67:	56                   	push   %esi
  800a68:	53                   	push   %ebx
  800a69:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a6c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a6f:	85 c9                	test   %ecx,%ecx
  800a71:	74 31                	je     800aa4 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a73:	89 f8                	mov    %edi,%eax
  800a75:	09 c8                	or     %ecx,%eax
  800a77:	a8 03                	test   $0x3,%al
  800a79:	75 23                	jne    800a9e <memset+0x3f>
		c &= 0xFF;
  800a7b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a7f:	89 d3                	mov    %edx,%ebx
  800a81:	c1 e3 08             	shl    $0x8,%ebx
  800a84:	89 d0                	mov    %edx,%eax
  800a86:	c1 e0 18             	shl    $0x18,%eax
  800a89:	89 d6                	mov    %edx,%esi
  800a8b:	c1 e6 10             	shl    $0x10,%esi
  800a8e:	09 f0                	or     %esi,%eax
  800a90:	09 c2                	or     %eax,%edx
  800a92:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a94:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a97:	89 d0                	mov    %edx,%eax
  800a99:	fc                   	cld    
  800a9a:	f3 ab                	rep stos %eax,%es:(%edi)
  800a9c:	eb 06                	jmp    800aa4 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa1:	fc                   	cld    
  800aa2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800aa4:	89 f8                	mov    %edi,%eax
  800aa6:	5b                   	pop    %ebx
  800aa7:	5e                   	pop    %esi
  800aa8:	5f                   	pop    %edi
  800aa9:	5d                   	pop    %ebp
  800aaa:	c3                   	ret    

00800aab <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800aab:	f3 0f 1e fb          	endbr32 
  800aaf:	55                   	push   %ebp
  800ab0:	89 e5                	mov    %esp,%ebp
  800ab2:	57                   	push   %edi
  800ab3:	56                   	push   %esi
  800ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aba:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800abd:	39 c6                	cmp    %eax,%esi
  800abf:	73 32                	jae    800af3 <memmove+0x48>
  800ac1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ac4:	39 c2                	cmp    %eax,%edx
  800ac6:	76 2b                	jbe    800af3 <memmove+0x48>
		s += n;
		d += n;
  800ac8:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800acb:	89 fe                	mov    %edi,%esi
  800acd:	09 ce                	or     %ecx,%esi
  800acf:	09 d6                	or     %edx,%esi
  800ad1:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ad7:	75 0e                	jne    800ae7 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ad9:	83 ef 04             	sub    $0x4,%edi
  800adc:	8d 72 fc             	lea    -0x4(%edx),%esi
  800adf:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ae2:	fd                   	std    
  800ae3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ae5:	eb 09                	jmp    800af0 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ae7:	83 ef 01             	sub    $0x1,%edi
  800aea:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800aed:	fd                   	std    
  800aee:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800af0:	fc                   	cld    
  800af1:	eb 1a                	jmp    800b0d <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800af3:	89 c2                	mov    %eax,%edx
  800af5:	09 ca                	or     %ecx,%edx
  800af7:	09 f2                	or     %esi,%edx
  800af9:	f6 c2 03             	test   $0x3,%dl
  800afc:	75 0a                	jne    800b08 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800afe:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b01:	89 c7                	mov    %eax,%edi
  800b03:	fc                   	cld    
  800b04:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b06:	eb 05                	jmp    800b0d <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800b08:	89 c7                	mov    %eax,%edi
  800b0a:	fc                   	cld    
  800b0b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b0d:	5e                   	pop    %esi
  800b0e:	5f                   	pop    %edi
  800b0f:	5d                   	pop    %ebp
  800b10:	c3                   	ret    

00800b11 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b11:	f3 0f 1e fb          	endbr32 
  800b15:	55                   	push   %ebp
  800b16:	89 e5                	mov    %esp,%ebp
  800b18:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b1b:	ff 75 10             	pushl  0x10(%ebp)
  800b1e:	ff 75 0c             	pushl  0xc(%ebp)
  800b21:	ff 75 08             	pushl  0x8(%ebp)
  800b24:	e8 82 ff ff ff       	call   800aab <memmove>
}
  800b29:	c9                   	leave  
  800b2a:	c3                   	ret    

00800b2b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b2b:	f3 0f 1e fb          	endbr32 
  800b2f:	55                   	push   %ebp
  800b30:	89 e5                	mov    %esp,%ebp
  800b32:	56                   	push   %esi
  800b33:	53                   	push   %ebx
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3a:	89 c6                	mov    %eax,%esi
  800b3c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b3f:	39 f0                	cmp    %esi,%eax
  800b41:	74 1c                	je     800b5f <memcmp+0x34>
		if (*s1 != *s2)
  800b43:	0f b6 08             	movzbl (%eax),%ecx
  800b46:	0f b6 1a             	movzbl (%edx),%ebx
  800b49:	38 d9                	cmp    %bl,%cl
  800b4b:	75 08                	jne    800b55 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b4d:	83 c0 01             	add    $0x1,%eax
  800b50:	83 c2 01             	add    $0x1,%edx
  800b53:	eb ea                	jmp    800b3f <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800b55:	0f b6 c1             	movzbl %cl,%eax
  800b58:	0f b6 db             	movzbl %bl,%ebx
  800b5b:	29 d8                	sub    %ebx,%eax
  800b5d:	eb 05                	jmp    800b64 <memcmp+0x39>
	}

	return 0;
  800b5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b64:	5b                   	pop    %ebx
  800b65:	5e                   	pop    %esi
  800b66:	5d                   	pop    %ebp
  800b67:	c3                   	ret    

00800b68 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b68:	f3 0f 1e fb          	endbr32 
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b75:	89 c2                	mov    %eax,%edx
  800b77:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b7a:	39 d0                	cmp    %edx,%eax
  800b7c:	73 09                	jae    800b87 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b7e:	38 08                	cmp    %cl,(%eax)
  800b80:	74 05                	je     800b87 <memfind+0x1f>
	for (; s < ends; s++)
  800b82:	83 c0 01             	add    $0x1,%eax
  800b85:	eb f3                	jmp    800b7a <memfind+0x12>
			break;
	return (void *) s;
}
  800b87:	5d                   	pop    %ebp
  800b88:	c3                   	ret    

00800b89 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b89:	f3 0f 1e fb          	endbr32 
  800b8d:	55                   	push   %ebp
  800b8e:	89 e5                	mov    %esp,%ebp
  800b90:	57                   	push   %edi
  800b91:	56                   	push   %esi
  800b92:	53                   	push   %ebx
  800b93:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b96:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b99:	eb 03                	jmp    800b9e <strtol+0x15>
		s++;
  800b9b:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b9e:	0f b6 01             	movzbl (%ecx),%eax
  800ba1:	3c 20                	cmp    $0x20,%al
  800ba3:	74 f6                	je     800b9b <strtol+0x12>
  800ba5:	3c 09                	cmp    $0x9,%al
  800ba7:	74 f2                	je     800b9b <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800ba9:	3c 2b                	cmp    $0x2b,%al
  800bab:	74 2a                	je     800bd7 <strtol+0x4e>
	int neg = 0;
  800bad:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bb2:	3c 2d                	cmp    $0x2d,%al
  800bb4:	74 2b                	je     800be1 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bb6:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bbc:	75 0f                	jne    800bcd <strtol+0x44>
  800bbe:	80 39 30             	cmpb   $0x30,(%ecx)
  800bc1:	74 28                	je     800beb <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bc3:	85 db                	test   %ebx,%ebx
  800bc5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bca:	0f 44 d8             	cmove  %eax,%ebx
  800bcd:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd2:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bd5:	eb 46                	jmp    800c1d <strtol+0x94>
		s++;
  800bd7:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bda:	bf 00 00 00 00       	mov    $0x0,%edi
  800bdf:	eb d5                	jmp    800bb6 <strtol+0x2d>
		s++, neg = 1;
  800be1:	83 c1 01             	add    $0x1,%ecx
  800be4:	bf 01 00 00 00       	mov    $0x1,%edi
  800be9:	eb cb                	jmp    800bb6 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800beb:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bef:	74 0e                	je     800bff <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800bf1:	85 db                	test   %ebx,%ebx
  800bf3:	75 d8                	jne    800bcd <strtol+0x44>
		s++, base = 8;
  800bf5:	83 c1 01             	add    $0x1,%ecx
  800bf8:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bfd:	eb ce                	jmp    800bcd <strtol+0x44>
		s += 2, base = 16;
  800bff:	83 c1 02             	add    $0x2,%ecx
  800c02:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c07:	eb c4                	jmp    800bcd <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800c09:	0f be d2             	movsbl %dl,%edx
  800c0c:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c0f:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c12:	7d 3a                	jge    800c4e <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c14:	83 c1 01             	add    $0x1,%ecx
  800c17:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c1b:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c1d:	0f b6 11             	movzbl (%ecx),%edx
  800c20:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c23:	89 f3                	mov    %esi,%ebx
  800c25:	80 fb 09             	cmp    $0x9,%bl
  800c28:	76 df                	jbe    800c09 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800c2a:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c2d:	89 f3                	mov    %esi,%ebx
  800c2f:	80 fb 19             	cmp    $0x19,%bl
  800c32:	77 08                	ja     800c3c <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c34:	0f be d2             	movsbl %dl,%edx
  800c37:	83 ea 57             	sub    $0x57,%edx
  800c3a:	eb d3                	jmp    800c0f <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800c3c:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c3f:	89 f3                	mov    %esi,%ebx
  800c41:	80 fb 19             	cmp    $0x19,%bl
  800c44:	77 08                	ja     800c4e <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c46:	0f be d2             	movsbl %dl,%edx
  800c49:	83 ea 37             	sub    $0x37,%edx
  800c4c:	eb c1                	jmp    800c0f <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c4e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c52:	74 05                	je     800c59 <strtol+0xd0>
		*endptr = (char *) s;
  800c54:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c57:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c59:	89 c2                	mov    %eax,%edx
  800c5b:	f7 da                	neg    %edx
  800c5d:	85 ff                	test   %edi,%edi
  800c5f:	0f 45 c2             	cmovne %edx,%eax
}
  800c62:	5b                   	pop    %ebx
  800c63:	5e                   	pop    %esi
  800c64:	5f                   	pop    %edi
  800c65:	5d                   	pop    %ebp
  800c66:	c3                   	ret    

00800c67 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c67:	f3 0f 1e fb          	endbr32 
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	57                   	push   %edi
  800c6f:	56                   	push   %esi
  800c70:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c71:	b8 00 00 00 00       	mov    $0x0,%eax
  800c76:	8b 55 08             	mov    0x8(%ebp),%edx
  800c79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c7c:	89 c3                	mov    %eax,%ebx
  800c7e:	89 c7                	mov    %eax,%edi
  800c80:	89 c6                	mov    %eax,%esi
  800c82:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c84:	5b                   	pop    %ebx
  800c85:	5e                   	pop    %esi
  800c86:	5f                   	pop    %edi
  800c87:	5d                   	pop    %ebp
  800c88:	c3                   	ret    

00800c89 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c89:	f3 0f 1e fb          	endbr32 
  800c8d:	55                   	push   %ebp
  800c8e:	89 e5                	mov    %esp,%ebp
  800c90:	57                   	push   %edi
  800c91:	56                   	push   %esi
  800c92:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c93:	ba 00 00 00 00       	mov    $0x0,%edx
  800c98:	b8 01 00 00 00       	mov    $0x1,%eax
  800c9d:	89 d1                	mov    %edx,%ecx
  800c9f:	89 d3                	mov    %edx,%ebx
  800ca1:	89 d7                	mov    %edx,%edi
  800ca3:	89 d6                	mov    %edx,%esi
  800ca5:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ca7:	5b                   	pop    %ebx
  800ca8:	5e                   	pop    %esi
  800ca9:	5f                   	pop    %edi
  800caa:	5d                   	pop    %ebp
  800cab:	c3                   	ret    

00800cac <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cac:	f3 0f 1e fb          	endbr32 
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	57                   	push   %edi
  800cb4:	56                   	push   %esi
  800cb5:	53                   	push   %ebx
  800cb6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc1:	b8 03 00 00 00       	mov    $0x3,%eax
  800cc6:	89 cb                	mov    %ecx,%ebx
  800cc8:	89 cf                	mov    %ecx,%edi
  800cca:	89 ce                	mov    %ecx,%esi
  800ccc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cce:	85 c0                	test   %eax,%eax
  800cd0:	7f 08                	jg     800cda <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd5:	5b                   	pop    %ebx
  800cd6:	5e                   	pop    %esi
  800cd7:	5f                   	pop    %edi
  800cd8:	5d                   	pop    %ebp
  800cd9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cda:	83 ec 0c             	sub    $0xc,%esp
  800cdd:	50                   	push   %eax
  800cde:	6a 03                	push   $0x3
  800ce0:	68 1f 2e 80 00       	push   $0x802e1f
  800ce5:	6a 23                	push   $0x23
  800ce7:	68 3c 2e 80 00       	push   $0x802e3c
  800cec:	e8 13 f5 ff ff       	call   800204 <_panic>

00800cf1 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cf1:	f3 0f 1e fb          	endbr32 
  800cf5:	55                   	push   %ebp
  800cf6:	89 e5                	mov    %esp,%ebp
  800cf8:	57                   	push   %edi
  800cf9:	56                   	push   %esi
  800cfa:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cfb:	ba 00 00 00 00       	mov    $0x0,%edx
  800d00:	b8 02 00 00 00       	mov    $0x2,%eax
  800d05:	89 d1                	mov    %edx,%ecx
  800d07:	89 d3                	mov    %edx,%ebx
  800d09:	89 d7                	mov    %edx,%edi
  800d0b:	89 d6                	mov    %edx,%esi
  800d0d:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d0f:	5b                   	pop    %ebx
  800d10:	5e                   	pop    %esi
  800d11:	5f                   	pop    %edi
  800d12:	5d                   	pop    %ebp
  800d13:	c3                   	ret    

00800d14 <sys_yield>:

void
sys_yield(void)
{
  800d14:	f3 0f 1e fb          	endbr32 
  800d18:	55                   	push   %ebp
  800d19:	89 e5                	mov    %esp,%ebp
  800d1b:	57                   	push   %edi
  800d1c:	56                   	push   %esi
  800d1d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d1e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d23:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d28:	89 d1                	mov    %edx,%ecx
  800d2a:	89 d3                	mov    %edx,%ebx
  800d2c:	89 d7                	mov    %edx,%edi
  800d2e:	89 d6                	mov    %edx,%esi
  800d30:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d32:	5b                   	pop    %ebx
  800d33:	5e                   	pop    %esi
  800d34:	5f                   	pop    %edi
  800d35:	5d                   	pop    %ebp
  800d36:	c3                   	ret    

00800d37 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d37:	f3 0f 1e fb          	endbr32 
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
  800d3e:	57                   	push   %edi
  800d3f:	56                   	push   %esi
  800d40:	53                   	push   %ebx
  800d41:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d44:	be 00 00 00 00       	mov    $0x0,%esi
  800d49:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4f:	b8 04 00 00 00       	mov    $0x4,%eax
  800d54:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d57:	89 f7                	mov    %esi,%edi
  800d59:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d5b:	85 c0                	test   %eax,%eax
  800d5d:	7f 08                	jg     800d67 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800d6b:	6a 04                	push   $0x4
  800d6d:	68 1f 2e 80 00       	push   $0x802e1f
  800d72:	6a 23                	push   $0x23
  800d74:	68 3c 2e 80 00       	push   $0x802e3c
  800d79:	e8 86 f4 ff ff       	call   800204 <_panic>

00800d7e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d7e:	f3 0f 1e fb          	endbr32 
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	57                   	push   %edi
  800d86:	56                   	push   %esi
  800d87:	53                   	push   %ebx
  800d88:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d91:	b8 05 00 00 00       	mov    $0x5,%eax
  800d96:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d99:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d9c:	8b 75 18             	mov    0x18(%ebp),%esi
  800d9f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da1:	85 c0                	test   %eax,%eax
  800da3:	7f 08                	jg     800dad <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  800db1:	6a 05                	push   $0x5
  800db3:	68 1f 2e 80 00       	push   $0x802e1f
  800db8:	6a 23                	push   $0x23
  800dba:	68 3c 2e 80 00       	push   $0x802e3c
  800dbf:	e8 40 f4 ff ff       	call   800204 <_panic>

00800dc4 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dc4:	f3 0f 1e fb          	endbr32 
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
  800dcb:	57                   	push   %edi
  800dcc:	56                   	push   %esi
  800dcd:	53                   	push   %ebx
  800dce:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ddc:	b8 06 00 00 00       	mov    $0x6,%eax
  800de1:	89 df                	mov    %ebx,%edi
  800de3:	89 de                	mov    %ebx,%esi
  800de5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de7:	85 c0                	test   %eax,%eax
  800de9:	7f 08                	jg     800df3 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800deb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dee:	5b                   	pop    %ebx
  800def:	5e                   	pop    %esi
  800df0:	5f                   	pop    %edi
  800df1:	5d                   	pop    %ebp
  800df2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df3:	83 ec 0c             	sub    $0xc,%esp
  800df6:	50                   	push   %eax
  800df7:	6a 06                	push   $0x6
  800df9:	68 1f 2e 80 00       	push   $0x802e1f
  800dfe:	6a 23                	push   $0x23
  800e00:	68 3c 2e 80 00       	push   $0x802e3c
  800e05:	e8 fa f3 ff ff       	call   800204 <_panic>

00800e0a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e0a:	f3 0f 1e fb          	endbr32 
  800e0e:	55                   	push   %ebp
  800e0f:	89 e5                	mov    %esp,%ebp
  800e11:	57                   	push   %edi
  800e12:	56                   	push   %esi
  800e13:	53                   	push   %ebx
  800e14:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e17:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e22:	b8 08 00 00 00       	mov    $0x8,%eax
  800e27:	89 df                	mov    %ebx,%edi
  800e29:	89 de                	mov    %ebx,%esi
  800e2b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e2d:	85 c0                	test   %eax,%eax
  800e2f:	7f 08                	jg     800e39 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e31:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e34:	5b                   	pop    %ebx
  800e35:	5e                   	pop    %esi
  800e36:	5f                   	pop    %edi
  800e37:	5d                   	pop    %ebp
  800e38:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e39:	83 ec 0c             	sub    $0xc,%esp
  800e3c:	50                   	push   %eax
  800e3d:	6a 08                	push   $0x8
  800e3f:	68 1f 2e 80 00       	push   $0x802e1f
  800e44:	6a 23                	push   $0x23
  800e46:	68 3c 2e 80 00       	push   $0x802e3c
  800e4b:	e8 b4 f3 ff ff       	call   800204 <_panic>

00800e50 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e50:	f3 0f 1e fb          	endbr32 
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	57                   	push   %edi
  800e58:	56                   	push   %esi
  800e59:	53                   	push   %ebx
  800e5a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e5d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e62:	8b 55 08             	mov    0x8(%ebp),%edx
  800e65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e68:	b8 09 00 00 00       	mov    $0x9,%eax
  800e6d:	89 df                	mov    %ebx,%edi
  800e6f:	89 de                	mov    %ebx,%esi
  800e71:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e73:	85 c0                	test   %eax,%eax
  800e75:	7f 08                	jg     800e7f <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e7a:	5b                   	pop    %ebx
  800e7b:	5e                   	pop    %esi
  800e7c:	5f                   	pop    %edi
  800e7d:	5d                   	pop    %ebp
  800e7e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7f:	83 ec 0c             	sub    $0xc,%esp
  800e82:	50                   	push   %eax
  800e83:	6a 09                	push   $0x9
  800e85:	68 1f 2e 80 00       	push   $0x802e1f
  800e8a:	6a 23                	push   $0x23
  800e8c:	68 3c 2e 80 00       	push   $0x802e3c
  800e91:	e8 6e f3 ff ff       	call   800204 <_panic>

00800e96 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e96:	f3 0f 1e fb          	endbr32 
  800e9a:	55                   	push   %ebp
  800e9b:	89 e5                	mov    %esp,%ebp
  800e9d:	57                   	push   %edi
  800e9e:	56                   	push   %esi
  800e9f:	53                   	push   %ebx
  800ea0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea8:	8b 55 08             	mov    0x8(%ebp),%edx
  800eab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eae:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eb3:	89 df                	mov    %ebx,%edi
  800eb5:	89 de                	mov    %ebx,%esi
  800eb7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb9:	85 c0                	test   %eax,%eax
  800ebb:	7f 08                	jg     800ec5 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ebd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec0:	5b                   	pop    %ebx
  800ec1:	5e                   	pop    %esi
  800ec2:	5f                   	pop    %edi
  800ec3:	5d                   	pop    %ebp
  800ec4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec5:	83 ec 0c             	sub    $0xc,%esp
  800ec8:	50                   	push   %eax
  800ec9:	6a 0a                	push   $0xa
  800ecb:	68 1f 2e 80 00       	push   $0x802e1f
  800ed0:	6a 23                	push   $0x23
  800ed2:	68 3c 2e 80 00       	push   $0x802e3c
  800ed7:	e8 28 f3 ff ff       	call   800204 <_panic>

00800edc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800edc:	f3 0f 1e fb          	endbr32 
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
  800ee3:	57                   	push   %edi
  800ee4:	56                   	push   %esi
  800ee5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eec:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ef1:	be 00 00 00 00       	mov    $0x0,%esi
  800ef6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ef9:	8b 7d 14             	mov    0x14(%ebp),%edi
  800efc:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800efe:	5b                   	pop    %ebx
  800eff:	5e                   	pop    %esi
  800f00:	5f                   	pop    %edi
  800f01:	5d                   	pop    %ebp
  800f02:	c3                   	ret    

00800f03 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f03:	f3 0f 1e fb          	endbr32 
  800f07:	55                   	push   %ebp
  800f08:	89 e5                	mov    %esp,%ebp
  800f0a:	57                   	push   %edi
  800f0b:	56                   	push   %esi
  800f0c:	53                   	push   %ebx
  800f0d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f10:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f15:	8b 55 08             	mov    0x8(%ebp),%edx
  800f18:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f1d:	89 cb                	mov    %ecx,%ebx
  800f1f:	89 cf                	mov    %ecx,%edi
  800f21:	89 ce                	mov    %ecx,%esi
  800f23:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f25:	85 c0                	test   %eax,%eax
  800f27:	7f 08                	jg     800f31 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f2c:	5b                   	pop    %ebx
  800f2d:	5e                   	pop    %esi
  800f2e:	5f                   	pop    %edi
  800f2f:	5d                   	pop    %ebp
  800f30:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f31:	83 ec 0c             	sub    $0xc,%esp
  800f34:	50                   	push   %eax
  800f35:	6a 0d                	push   $0xd
  800f37:	68 1f 2e 80 00       	push   $0x802e1f
  800f3c:	6a 23                	push   $0x23
  800f3e:	68 3c 2e 80 00       	push   $0x802e3c
  800f43:	e8 bc f2 ff ff       	call   800204 <_panic>

00800f48 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f48:	f3 0f 1e fb          	endbr32 
  800f4c:	55                   	push   %ebp
  800f4d:	89 e5                	mov    %esp,%ebp
  800f4f:	53                   	push   %ebx
  800f50:	83 ec 04             	sub    $0x4,%esp
  800f53:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800f56:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  800f58:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f5c:	74 74                	je     800fd2 <pgfault+0x8a>
  800f5e:	89 d8                	mov    %ebx,%eax
  800f60:	c1 e8 0c             	shr    $0xc,%eax
  800f63:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f6a:	f6 c4 08             	test   $0x8,%ah
  800f6d:	74 63                	je     800fd2 <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800f6f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  800f75:	83 ec 0c             	sub    $0xc,%esp
  800f78:	6a 05                	push   $0x5
  800f7a:	68 00 f0 7f 00       	push   $0x7ff000
  800f7f:	6a 00                	push   $0x0
  800f81:	53                   	push   %ebx
  800f82:	6a 00                	push   $0x0
  800f84:	e8 f5 fd ff ff       	call   800d7e <sys_page_map>
  800f89:	83 c4 20             	add    $0x20,%esp
  800f8c:	85 c0                	test   %eax,%eax
  800f8e:	78 59                	js     800fe9 <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  800f90:	83 ec 04             	sub    $0x4,%esp
  800f93:	6a 07                	push   $0x7
  800f95:	53                   	push   %ebx
  800f96:	6a 00                	push   $0x0
  800f98:	e8 9a fd ff ff       	call   800d37 <sys_page_alloc>
  800f9d:	83 c4 10             	add    $0x10,%esp
  800fa0:	85 c0                	test   %eax,%eax
  800fa2:	78 5a                	js     800ffe <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  800fa4:	83 ec 04             	sub    $0x4,%esp
  800fa7:	68 00 10 00 00       	push   $0x1000
  800fac:	68 00 f0 7f 00       	push   $0x7ff000
  800fb1:	53                   	push   %ebx
  800fb2:	e8 f4 fa ff ff       	call   800aab <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  800fb7:	83 c4 08             	add    $0x8,%esp
  800fba:	68 00 f0 7f 00       	push   $0x7ff000
  800fbf:	6a 00                	push   $0x0
  800fc1:	e8 fe fd ff ff       	call   800dc4 <sys_page_unmap>
  800fc6:	83 c4 10             	add    $0x10,%esp
  800fc9:	85 c0                	test   %eax,%eax
  800fcb:	78 46                	js     801013 <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  800fcd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fd0:	c9                   	leave  
  800fd1:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  800fd2:	83 ec 04             	sub    $0x4,%esp
  800fd5:	68 4a 2e 80 00       	push   $0x802e4a
  800fda:	68 d3 00 00 00       	push   $0xd3
  800fdf:	68 66 2e 80 00       	push   $0x802e66
  800fe4:	e8 1b f2 ff ff       	call   800204 <_panic>
		panic("pgfault: %e\n", r);
  800fe9:	50                   	push   %eax
  800fea:	68 71 2e 80 00       	push   $0x802e71
  800fef:	68 df 00 00 00       	push   $0xdf
  800ff4:	68 66 2e 80 00       	push   $0x802e66
  800ff9:	e8 06 f2 ff ff       	call   800204 <_panic>
		panic("pgfault: %e\n", r);
  800ffe:	50                   	push   %eax
  800fff:	68 71 2e 80 00       	push   $0x802e71
  801004:	68 e3 00 00 00       	push   $0xe3
  801009:	68 66 2e 80 00       	push   $0x802e66
  80100e:	e8 f1 f1 ff ff       	call   800204 <_panic>
		panic("pgfault: %e\n", r);
  801013:	50                   	push   %eax
  801014:	68 71 2e 80 00       	push   $0x802e71
  801019:	68 e9 00 00 00       	push   $0xe9
  80101e:	68 66 2e 80 00       	push   $0x802e66
  801023:	e8 dc f1 ff ff       	call   800204 <_panic>

00801028 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801028:	f3 0f 1e fb          	endbr32 
  80102c:	55                   	push   %ebp
  80102d:	89 e5                	mov    %esp,%ebp
  80102f:	57                   	push   %edi
  801030:	56                   	push   %esi
  801031:	53                   	push   %ebx
  801032:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  801035:	68 48 0f 80 00       	push   $0x800f48
  80103a:	e8 a8 15 00 00       	call   8025e7 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80103f:	b8 07 00 00 00       	mov    $0x7,%eax
  801044:	cd 30                	int    $0x30
  801046:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  801049:	83 c4 10             	add    $0x10,%esp
  80104c:	85 c0                	test   %eax,%eax
  80104e:	78 2d                	js     80107d <fork+0x55>
  801050:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801052:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  801057:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80105b:	0f 85 9b 00 00 00    	jne    8010fc <fork+0xd4>
		thisenv = &envs[ENVX(sys_getenvid())];
  801061:	e8 8b fc ff ff       	call   800cf1 <sys_getenvid>
  801066:	25 ff 03 00 00       	and    $0x3ff,%eax
  80106b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80106e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801073:	a3 04 50 80 00       	mov    %eax,0x805004
		return 0;
  801078:	e9 71 01 00 00       	jmp    8011ee <fork+0x1c6>
		panic("sys_exofork: %e", envid);
  80107d:	50                   	push   %eax
  80107e:	68 7e 2e 80 00       	push   $0x802e7e
  801083:	68 2a 01 00 00       	push   $0x12a
  801088:	68 66 2e 80 00       	push   $0x802e66
  80108d:	e8 72 f1 ff ff       	call   800204 <_panic>
		sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_SYSCALL);
  801092:	c1 e6 0c             	shl    $0xc,%esi
  801095:	83 ec 0c             	sub    $0xc,%esp
  801098:	68 07 0e 00 00       	push   $0xe07
  80109d:	56                   	push   %esi
  80109e:	57                   	push   %edi
  80109f:	56                   	push   %esi
  8010a0:	6a 00                	push   $0x0
  8010a2:	e8 d7 fc ff ff       	call   800d7e <sys_page_map>
  8010a7:	83 c4 20             	add    $0x20,%esp
  8010aa:	eb 3e                	jmp    8010ea <fork+0xc2>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  8010ac:	c1 e6 0c             	shl    $0xc,%esi
  8010af:	83 ec 0c             	sub    $0xc,%esp
  8010b2:	68 05 08 00 00       	push   $0x805
  8010b7:	56                   	push   %esi
  8010b8:	57                   	push   %edi
  8010b9:	56                   	push   %esi
  8010ba:	6a 00                	push   $0x0
  8010bc:	e8 bd fc ff ff       	call   800d7e <sys_page_map>
  8010c1:	83 c4 20             	add    $0x20,%esp
  8010c4:	85 c0                	test   %eax,%eax
  8010c6:	0f 88 bc 00 00 00    	js     801188 <fork+0x160>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  8010cc:	83 ec 0c             	sub    $0xc,%esp
  8010cf:	68 05 08 00 00       	push   $0x805
  8010d4:	56                   	push   %esi
  8010d5:	6a 00                	push   $0x0
  8010d7:	56                   	push   %esi
  8010d8:	6a 00                	push   $0x0
  8010da:	e8 9f fc ff ff       	call   800d7e <sys_page_map>
  8010df:	83 c4 20             	add    $0x20,%esp
  8010e2:	85 c0                	test   %eax,%eax
  8010e4:	0f 88 b3 00 00 00    	js     80119d <fork+0x175>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8010ea:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8010f0:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8010f6:	0f 84 b6 00 00 00    	je     8011b2 <fork+0x18a>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  8010fc:	89 d8                	mov    %ebx,%eax
  8010fe:	c1 e8 16             	shr    $0x16,%eax
  801101:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801108:	a8 01                	test   $0x1,%al
  80110a:	74 de                	je     8010ea <fork+0xc2>
  80110c:	89 de                	mov    %ebx,%esi
  80110e:	c1 ee 0c             	shr    $0xc,%esi
  801111:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801118:	a8 01                	test   $0x1,%al
  80111a:	74 ce                	je     8010ea <fork+0xc2>
  80111c:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801123:	a8 04                	test   $0x4,%al
  801125:	74 c3                	je     8010ea <fork+0xc2>
	if ((uvpt[pn] & PTE_SHARE)){
  801127:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80112e:	f6 c4 04             	test   $0x4,%ah
  801131:	0f 85 5b ff ff ff    	jne    801092 <fork+0x6a>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  801137:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80113e:	a8 02                	test   $0x2,%al
  801140:	0f 85 66 ff ff ff    	jne    8010ac <fork+0x84>
  801146:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80114d:	f6 c4 08             	test   $0x8,%ah
  801150:	0f 85 56 ff ff ff    	jne    8010ac <fork+0x84>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  801156:	c1 e6 0c             	shl    $0xc,%esi
  801159:	83 ec 0c             	sub    $0xc,%esp
  80115c:	6a 05                	push   $0x5
  80115e:	56                   	push   %esi
  80115f:	57                   	push   %edi
  801160:	56                   	push   %esi
  801161:	6a 00                	push   $0x0
  801163:	e8 16 fc ff ff       	call   800d7e <sys_page_map>
  801168:	83 c4 20             	add    $0x20,%esp
  80116b:	85 c0                	test   %eax,%eax
  80116d:	0f 89 77 ff ff ff    	jns    8010ea <fork+0xc2>
		panic("duppage: %e\n", r);
  801173:	50                   	push   %eax
  801174:	68 8e 2e 80 00       	push   $0x802e8e
  801179:	68 0c 01 00 00       	push   $0x10c
  80117e:	68 66 2e 80 00       	push   $0x802e66
  801183:	e8 7c f0 ff ff       	call   800204 <_panic>
			panic("duppage: %e\n", r);
  801188:	50                   	push   %eax
  801189:	68 8e 2e 80 00       	push   $0x802e8e
  80118e:	68 05 01 00 00       	push   $0x105
  801193:	68 66 2e 80 00       	push   $0x802e66
  801198:	e8 67 f0 ff ff       	call   800204 <_panic>
			panic("duppage: %e\n", r);
  80119d:	50                   	push   %eax
  80119e:	68 8e 2e 80 00       	push   $0x802e8e
  8011a3:	68 09 01 00 00       	push   $0x109
  8011a8:	68 66 2e 80 00       	push   $0x802e66
  8011ad:	e8 52 f0 ff ff       	call   800204 <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  8011b2:	83 ec 04             	sub    $0x4,%esp
  8011b5:	6a 07                	push   $0x7
  8011b7:	68 00 f0 bf ee       	push   $0xeebff000
  8011bc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011bf:	e8 73 fb ff ff       	call   800d37 <sys_page_alloc>
  8011c4:	83 c4 10             	add    $0x10,%esp
  8011c7:	85 c0                	test   %eax,%eax
  8011c9:	78 2e                	js     8011f9 <fork+0x1d1>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8011cb:	83 ec 08             	sub    $0x8,%esp
  8011ce:	68 5a 26 80 00       	push   $0x80265a
  8011d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8011d6:	57                   	push   %edi
  8011d7:	e8 ba fc ff ff       	call   800e96 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8011dc:	83 c4 08             	add    $0x8,%esp
  8011df:	6a 02                	push   $0x2
  8011e1:	57                   	push   %edi
  8011e2:	e8 23 fc ff ff       	call   800e0a <sys_env_set_status>
  8011e7:	83 c4 10             	add    $0x10,%esp
  8011ea:	85 c0                	test   %eax,%eax
  8011ec:	78 20                	js     80120e <fork+0x1e6>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  8011ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011f4:	5b                   	pop    %ebx
  8011f5:	5e                   	pop    %esi
  8011f6:	5f                   	pop    %edi
  8011f7:	5d                   	pop    %ebp
  8011f8:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  8011f9:	50                   	push   %eax
  8011fa:	68 4c 2a 80 00       	push   $0x802a4c
  8011ff:	68 3e 01 00 00       	push   $0x13e
  801204:	68 66 2e 80 00       	push   $0x802e66
  801209:	e8 f6 ef ff ff       	call   800204 <_panic>
		panic("sys_env_set_status: %e", r);
  80120e:	50                   	push   %eax
  80120f:	68 9b 2e 80 00       	push   $0x802e9b
  801214:	68 43 01 00 00       	push   $0x143
  801219:	68 66 2e 80 00       	push   $0x802e66
  80121e:	e8 e1 ef ff ff       	call   800204 <_panic>

00801223 <sfork>:

// Challenge!
int
sfork(void)
{
  801223:	f3 0f 1e fb          	endbr32 
  801227:	55                   	push   %ebp
  801228:	89 e5                	mov    %esp,%ebp
  80122a:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80122d:	68 b2 2e 80 00       	push   $0x802eb2
  801232:	68 4c 01 00 00       	push   $0x14c
  801237:	68 66 2e 80 00       	push   $0x802e66
  80123c:	e8 c3 ef ff ff       	call   800204 <_panic>

00801241 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801241:	f3 0f 1e fb          	endbr32 
  801245:	55                   	push   %ebp
  801246:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801248:	8b 45 08             	mov    0x8(%ebp),%eax
  80124b:	05 00 00 00 30       	add    $0x30000000,%eax
  801250:	c1 e8 0c             	shr    $0xc,%eax
}
  801253:	5d                   	pop    %ebp
  801254:	c3                   	ret    

00801255 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801255:	f3 0f 1e fb          	endbr32 
  801259:	55                   	push   %ebp
  80125a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
  80125f:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801264:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801269:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80126e:	5d                   	pop    %ebp
  80126f:	c3                   	ret    

00801270 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801270:	f3 0f 1e fb          	endbr32 
  801274:	55                   	push   %ebp
  801275:	89 e5                	mov    %esp,%ebp
  801277:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80127c:	89 c2                	mov    %eax,%edx
  80127e:	c1 ea 16             	shr    $0x16,%edx
  801281:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801288:	f6 c2 01             	test   $0x1,%dl
  80128b:	74 2d                	je     8012ba <fd_alloc+0x4a>
  80128d:	89 c2                	mov    %eax,%edx
  80128f:	c1 ea 0c             	shr    $0xc,%edx
  801292:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801299:	f6 c2 01             	test   $0x1,%dl
  80129c:	74 1c                	je     8012ba <fd_alloc+0x4a>
  80129e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8012a3:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012a8:	75 d2                	jne    80127c <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8012b3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8012b8:	eb 0a                	jmp    8012c4 <fd_alloc+0x54>
			*fd_store = fd;
  8012ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012bd:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012c4:	5d                   	pop    %ebp
  8012c5:	c3                   	ret    

008012c6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8012c6:	f3 0f 1e fb          	endbr32 
  8012ca:	55                   	push   %ebp
  8012cb:	89 e5                	mov    %esp,%ebp
  8012cd:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8012d0:	83 f8 1f             	cmp    $0x1f,%eax
  8012d3:	77 30                	ja     801305 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8012d5:	c1 e0 0c             	shl    $0xc,%eax
  8012d8:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8012dd:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8012e3:	f6 c2 01             	test   $0x1,%dl
  8012e6:	74 24                	je     80130c <fd_lookup+0x46>
  8012e8:	89 c2                	mov    %eax,%edx
  8012ea:	c1 ea 0c             	shr    $0xc,%edx
  8012ed:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012f4:	f6 c2 01             	test   $0x1,%dl
  8012f7:	74 1a                	je     801313 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012fc:	89 02                	mov    %eax,(%edx)
	return 0;
  8012fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801303:	5d                   	pop    %ebp
  801304:	c3                   	ret    
		return -E_INVAL;
  801305:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80130a:	eb f7                	jmp    801303 <fd_lookup+0x3d>
		return -E_INVAL;
  80130c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801311:	eb f0                	jmp    801303 <fd_lookup+0x3d>
  801313:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801318:	eb e9                	jmp    801303 <fd_lookup+0x3d>

0080131a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80131a:	f3 0f 1e fb          	endbr32 
  80131e:	55                   	push   %ebp
  80131f:	89 e5                	mov    %esp,%ebp
  801321:	83 ec 08             	sub    $0x8,%esp
  801324:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801327:	ba 44 2f 80 00       	mov    $0x802f44,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80132c:	b8 0c 40 80 00       	mov    $0x80400c,%eax
		if (devtab[i]->dev_id == dev_id) {
  801331:	39 08                	cmp    %ecx,(%eax)
  801333:	74 33                	je     801368 <dev_lookup+0x4e>
  801335:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801338:	8b 02                	mov    (%edx),%eax
  80133a:	85 c0                	test   %eax,%eax
  80133c:	75 f3                	jne    801331 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80133e:	a1 04 50 80 00       	mov    0x805004,%eax
  801343:	8b 40 48             	mov    0x48(%eax),%eax
  801346:	83 ec 04             	sub    $0x4,%esp
  801349:	51                   	push   %ecx
  80134a:	50                   	push   %eax
  80134b:	68 c8 2e 80 00       	push   $0x802ec8
  801350:	e8 96 ef ff ff       	call   8002eb <cprintf>
	*dev = 0;
  801355:	8b 45 0c             	mov    0xc(%ebp),%eax
  801358:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80135e:	83 c4 10             	add    $0x10,%esp
  801361:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801366:	c9                   	leave  
  801367:	c3                   	ret    
			*dev = devtab[i];
  801368:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80136b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80136d:	b8 00 00 00 00       	mov    $0x0,%eax
  801372:	eb f2                	jmp    801366 <dev_lookup+0x4c>

00801374 <fd_close>:
{
  801374:	f3 0f 1e fb          	endbr32 
  801378:	55                   	push   %ebp
  801379:	89 e5                	mov    %esp,%ebp
  80137b:	57                   	push   %edi
  80137c:	56                   	push   %esi
  80137d:	53                   	push   %ebx
  80137e:	83 ec 24             	sub    $0x24,%esp
  801381:	8b 75 08             	mov    0x8(%ebp),%esi
  801384:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801387:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80138a:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80138b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801391:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801394:	50                   	push   %eax
  801395:	e8 2c ff ff ff       	call   8012c6 <fd_lookup>
  80139a:	89 c3                	mov    %eax,%ebx
  80139c:	83 c4 10             	add    $0x10,%esp
  80139f:	85 c0                	test   %eax,%eax
  8013a1:	78 05                	js     8013a8 <fd_close+0x34>
	    || fd != fd2)
  8013a3:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8013a6:	74 16                	je     8013be <fd_close+0x4a>
		return (must_exist ? r : 0);
  8013a8:	89 f8                	mov    %edi,%eax
  8013aa:	84 c0                	test   %al,%al
  8013ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b1:	0f 44 d8             	cmove  %eax,%ebx
}
  8013b4:	89 d8                	mov    %ebx,%eax
  8013b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013b9:	5b                   	pop    %ebx
  8013ba:	5e                   	pop    %esi
  8013bb:	5f                   	pop    %edi
  8013bc:	5d                   	pop    %ebp
  8013bd:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8013be:	83 ec 08             	sub    $0x8,%esp
  8013c1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8013c4:	50                   	push   %eax
  8013c5:	ff 36                	pushl  (%esi)
  8013c7:	e8 4e ff ff ff       	call   80131a <dev_lookup>
  8013cc:	89 c3                	mov    %eax,%ebx
  8013ce:	83 c4 10             	add    $0x10,%esp
  8013d1:	85 c0                	test   %eax,%eax
  8013d3:	78 1a                	js     8013ef <fd_close+0x7b>
		if (dev->dev_close)
  8013d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013d8:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8013db:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8013e0:	85 c0                	test   %eax,%eax
  8013e2:	74 0b                	je     8013ef <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8013e4:	83 ec 0c             	sub    $0xc,%esp
  8013e7:	56                   	push   %esi
  8013e8:	ff d0                	call   *%eax
  8013ea:	89 c3                	mov    %eax,%ebx
  8013ec:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8013ef:	83 ec 08             	sub    $0x8,%esp
  8013f2:	56                   	push   %esi
  8013f3:	6a 00                	push   $0x0
  8013f5:	e8 ca f9 ff ff       	call   800dc4 <sys_page_unmap>
	return r;
  8013fa:	83 c4 10             	add    $0x10,%esp
  8013fd:	eb b5                	jmp    8013b4 <fd_close+0x40>

008013ff <close>:

int
close(int fdnum)
{
  8013ff:	f3 0f 1e fb          	endbr32 
  801403:	55                   	push   %ebp
  801404:	89 e5                	mov    %esp,%ebp
  801406:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801409:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80140c:	50                   	push   %eax
  80140d:	ff 75 08             	pushl  0x8(%ebp)
  801410:	e8 b1 fe ff ff       	call   8012c6 <fd_lookup>
  801415:	83 c4 10             	add    $0x10,%esp
  801418:	85 c0                	test   %eax,%eax
  80141a:	79 02                	jns    80141e <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80141c:	c9                   	leave  
  80141d:	c3                   	ret    
		return fd_close(fd, 1);
  80141e:	83 ec 08             	sub    $0x8,%esp
  801421:	6a 01                	push   $0x1
  801423:	ff 75 f4             	pushl  -0xc(%ebp)
  801426:	e8 49 ff ff ff       	call   801374 <fd_close>
  80142b:	83 c4 10             	add    $0x10,%esp
  80142e:	eb ec                	jmp    80141c <close+0x1d>

00801430 <close_all>:

void
close_all(void)
{
  801430:	f3 0f 1e fb          	endbr32 
  801434:	55                   	push   %ebp
  801435:	89 e5                	mov    %esp,%ebp
  801437:	53                   	push   %ebx
  801438:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80143b:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801440:	83 ec 0c             	sub    $0xc,%esp
  801443:	53                   	push   %ebx
  801444:	e8 b6 ff ff ff       	call   8013ff <close>
	for (i = 0; i < MAXFD; i++)
  801449:	83 c3 01             	add    $0x1,%ebx
  80144c:	83 c4 10             	add    $0x10,%esp
  80144f:	83 fb 20             	cmp    $0x20,%ebx
  801452:	75 ec                	jne    801440 <close_all+0x10>
}
  801454:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801457:	c9                   	leave  
  801458:	c3                   	ret    

00801459 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801459:	f3 0f 1e fb          	endbr32 
  80145d:	55                   	push   %ebp
  80145e:	89 e5                	mov    %esp,%ebp
  801460:	57                   	push   %edi
  801461:	56                   	push   %esi
  801462:	53                   	push   %ebx
  801463:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801466:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801469:	50                   	push   %eax
  80146a:	ff 75 08             	pushl  0x8(%ebp)
  80146d:	e8 54 fe ff ff       	call   8012c6 <fd_lookup>
  801472:	89 c3                	mov    %eax,%ebx
  801474:	83 c4 10             	add    $0x10,%esp
  801477:	85 c0                	test   %eax,%eax
  801479:	0f 88 81 00 00 00    	js     801500 <dup+0xa7>
		return r;
	close(newfdnum);
  80147f:	83 ec 0c             	sub    $0xc,%esp
  801482:	ff 75 0c             	pushl  0xc(%ebp)
  801485:	e8 75 ff ff ff       	call   8013ff <close>

	newfd = INDEX2FD(newfdnum);
  80148a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80148d:	c1 e6 0c             	shl    $0xc,%esi
  801490:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801496:	83 c4 04             	add    $0x4,%esp
  801499:	ff 75 e4             	pushl  -0x1c(%ebp)
  80149c:	e8 b4 fd ff ff       	call   801255 <fd2data>
  8014a1:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8014a3:	89 34 24             	mov    %esi,(%esp)
  8014a6:	e8 aa fd ff ff       	call   801255 <fd2data>
  8014ab:	83 c4 10             	add    $0x10,%esp
  8014ae:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8014b0:	89 d8                	mov    %ebx,%eax
  8014b2:	c1 e8 16             	shr    $0x16,%eax
  8014b5:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014bc:	a8 01                	test   $0x1,%al
  8014be:	74 11                	je     8014d1 <dup+0x78>
  8014c0:	89 d8                	mov    %ebx,%eax
  8014c2:	c1 e8 0c             	shr    $0xc,%eax
  8014c5:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014cc:	f6 c2 01             	test   $0x1,%dl
  8014cf:	75 39                	jne    80150a <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8014d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014d4:	89 d0                	mov    %edx,%eax
  8014d6:	c1 e8 0c             	shr    $0xc,%eax
  8014d9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014e0:	83 ec 0c             	sub    $0xc,%esp
  8014e3:	25 07 0e 00 00       	and    $0xe07,%eax
  8014e8:	50                   	push   %eax
  8014e9:	56                   	push   %esi
  8014ea:	6a 00                	push   $0x0
  8014ec:	52                   	push   %edx
  8014ed:	6a 00                	push   $0x0
  8014ef:	e8 8a f8 ff ff       	call   800d7e <sys_page_map>
  8014f4:	89 c3                	mov    %eax,%ebx
  8014f6:	83 c4 20             	add    $0x20,%esp
  8014f9:	85 c0                	test   %eax,%eax
  8014fb:	78 31                	js     80152e <dup+0xd5>
		goto err;

	return newfdnum;
  8014fd:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801500:	89 d8                	mov    %ebx,%eax
  801502:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801505:	5b                   	pop    %ebx
  801506:	5e                   	pop    %esi
  801507:	5f                   	pop    %edi
  801508:	5d                   	pop    %ebp
  801509:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80150a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801511:	83 ec 0c             	sub    $0xc,%esp
  801514:	25 07 0e 00 00       	and    $0xe07,%eax
  801519:	50                   	push   %eax
  80151a:	57                   	push   %edi
  80151b:	6a 00                	push   $0x0
  80151d:	53                   	push   %ebx
  80151e:	6a 00                	push   $0x0
  801520:	e8 59 f8 ff ff       	call   800d7e <sys_page_map>
  801525:	89 c3                	mov    %eax,%ebx
  801527:	83 c4 20             	add    $0x20,%esp
  80152a:	85 c0                	test   %eax,%eax
  80152c:	79 a3                	jns    8014d1 <dup+0x78>
	sys_page_unmap(0, newfd);
  80152e:	83 ec 08             	sub    $0x8,%esp
  801531:	56                   	push   %esi
  801532:	6a 00                	push   $0x0
  801534:	e8 8b f8 ff ff       	call   800dc4 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801539:	83 c4 08             	add    $0x8,%esp
  80153c:	57                   	push   %edi
  80153d:	6a 00                	push   $0x0
  80153f:	e8 80 f8 ff ff       	call   800dc4 <sys_page_unmap>
	return r;
  801544:	83 c4 10             	add    $0x10,%esp
  801547:	eb b7                	jmp    801500 <dup+0xa7>

00801549 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801549:	f3 0f 1e fb          	endbr32 
  80154d:	55                   	push   %ebp
  80154e:	89 e5                	mov    %esp,%ebp
  801550:	53                   	push   %ebx
  801551:	83 ec 1c             	sub    $0x1c,%esp
  801554:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801557:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80155a:	50                   	push   %eax
  80155b:	53                   	push   %ebx
  80155c:	e8 65 fd ff ff       	call   8012c6 <fd_lookup>
  801561:	83 c4 10             	add    $0x10,%esp
  801564:	85 c0                	test   %eax,%eax
  801566:	78 3f                	js     8015a7 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801568:	83 ec 08             	sub    $0x8,%esp
  80156b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80156e:	50                   	push   %eax
  80156f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801572:	ff 30                	pushl  (%eax)
  801574:	e8 a1 fd ff ff       	call   80131a <dev_lookup>
  801579:	83 c4 10             	add    $0x10,%esp
  80157c:	85 c0                	test   %eax,%eax
  80157e:	78 27                	js     8015a7 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801580:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801583:	8b 42 08             	mov    0x8(%edx),%eax
  801586:	83 e0 03             	and    $0x3,%eax
  801589:	83 f8 01             	cmp    $0x1,%eax
  80158c:	74 1e                	je     8015ac <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80158e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801591:	8b 40 08             	mov    0x8(%eax),%eax
  801594:	85 c0                	test   %eax,%eax
  801596:	74 35                	je     8015cd <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801598:	83 ec 04             	sub    $0x4,%esp
  80159b:	ff 75 10             	pushl  0x10(%ebp)
  80159e:	ff 75 0c             	pushl  0xc(%ebp)
  8015a1:	52                   	push   %edx
  8015a2:	ff d0                	call   *%eax
  8015a4:	83 c4 10             	add    $0x10,%esp
}
  8015a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015aa:	c9                   	leave  
  8015ab:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8015ac:	a1 04 50 80 00       	mov    0x805004,%eax
  8015b1:	8b 40 48             	mov    0x48(%eax),%eax
  8015b4:	83 ec 04             	sub    $0x4,%esp
  8015b7:	53                   	push   %ebx
  8015b8:	50                   	push   %eax
  8015b9:	68 09 2f 80 00       	push   $0x802f09
  8015be:	e8 28 ed ff ff       	call   8002eb <cprintf>
		return -E_INVAL;
  8015c3:	83 c4 10             	add    $0x10,%esp
  8015c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015cb:	eb da                	jmp    8015a7 <read+0x5e>
		return -E_NOT_SUPP;
  8015cd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015d2:	eb d3                	jmp    8015a7 <read+0x5e>

008015d4 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8015d4:	f3 0f 1e fb          	endbr32 
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
  8015db:	57                   	push   %edi
  8015dc:	56                   	push   %esi
  8015dd:	53                   	push   %ebx
  8015de:	83 ec 0c             	sub    $0xc,%esp
  8015e1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015e4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015e7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015ec:	eb 02                	jmp    8015f0 <readn+0x1c>
  8015ee:	01 c3                	add    %eax,%ebx
  8015f0:	39 f3                	cmp    %esi,%ebx
  8015f2:	73 21                	jae    801615 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015f4:	83 ec 04             	sub    $0x4,%esp
  8015f7:	89 f0                	mov    %esi,%eax
  8015f9:	29 d8                	sub    %ebx,%eax
  8015fb:	50                   	push   %eax
  8015fc:	89 d8                	mov    %ebx,%eax
  8015fe:	03 45 0c             	add    0xc(%ebp),%eax
  801601:	50                   	push   %eax
  801602:	57                   	push   %edi
  801603:	e8 41 ff ff ff       	call   801549 <read>
		if (m < 0)
  801608:	83 c4 10             	add    $0x10,%esp
  80160b:	85 c0                	test   %eax,%eax
  80160d:	78 04                	js     801613 <readn+0x3f>
			return m;
		if (m == 0)
  80160f:	75 dd                	jne    8015ee <readn+0x1a>
  801611:	eb 02                	jmp    801615 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801613:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801615:	89 d8                	mov    %ebx,%eax
  801617:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80161a:	5b                   	pop    %ebx
  80161b:	5e                   	pop    %esi
  80161c:	5f                   	pop    %edi
  80161d:	5d                   	pop    %ebp
  80161e:	c3                   	ret    

0080161f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80161f:	f3 0f 1e fb          	endbr32 
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
  801626:	53                   	push   %ebx
  801627:	83 ec 1c             	sub    $0x1c,%esp
  80162a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80162d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801630:	50                   	push   %eax
  801631:	53                   	push   %ebx
  801632:	e8 8f fc ff ff       	call   8012c6 <fd_lookup>
  801637:	83 c4 10             	add    $0x10,%esp
  80163a:	85 c0                	test   %eax,%eax
  80163c:	78 3a                	js     801678 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80163e:	83 ec 08             	sub    $0x8,%esp
  801641:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801644:	50                   	push   %eax
  801645:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801648:	ff 30                	pushl  (%eax)
  80164a:	e8 cb fc ff ff       	call   80131a <dev_lookup>
  80164f:	83 c4 10             	add    $0x10,%esp
  801652:	85 c0                	test   %eax,%eax
  801654:	78 22                	js     801678 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801656:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801659:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80165d:	74 1e                	je     80167d <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80165f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801662:	8b 52 0c             	mov    0xc(%edx),%edx
  801665:	85 d2                	test   %edx,%edx
  801667:	74 35                	je     80169e <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801669:	83 ec 04             	sub    $0x4,%esp
  80166c:	ff 75 10             	pushl  0x10(%ebp)
  80166f:	ff 75 0c             	pushl  0xc(%ebp)
  801672:	50                   	push   %eax
  801673:	ff d2                	call   *%edx
  801675:	83 c4 10             	add    $0x10,%esp
}
  801678:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80167b:	c9                   	leave  
  80167c:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80167d:	a1 04 50 80 00       	mov    0x805004,%eax
  801682:	8b 40 48             	mov    0x48(%eax),%eax
  801685:	83 ec 04             	sub    $0x4,%esp
  801688:	53                   	push   %ebx
  801689:	50                   	push   %eax
  80168a:	68 25 2f 80 00       	push   $0x802f25
  80168f:	e8 57 ec ff ff       	call   8002eb <cprintf>
		return -E_INVAL;
  801694:	83 c4 10             	add    $0x10,%esp
  801697:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80169c:	eb da                	jmp    801678 <write+0x59>
		return -E_NOT_SUPP;
  80169e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016a3:	eb d3                	jmp    801678 <write+0x59>

008016a5 <seek>:

int
seek(int fdnum, off_t offset)
{
  8016a5:	f3 0f 1e fb          	endbr32 
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
  8016ac:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016af:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016b2:	50                   	push   %eax
  8016b3:	ff 75 08             	pushl  0x8(%ebp)
  8016b6:	e8 0b fc ff ff       	call   8012c6 <fd_lookup>
  8016bb:	83 c4 10             	add    $0x10,%esp
  8016be:	85 c0                	test   %eax,%eax
  8016c0:	78 0e                	js     8016d0 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8016c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c8:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8016cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016d0:	c9                   	leave  
  8016d1:	c3                   	ret    

008016d2 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8016d2:	f3 0f 1e fb          	endbr32 
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
  8016d9:	53                   	push   %ebx
  8016da:	83 ec 1c             	sub    $0x1c,%esp
  8016dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016e3:	50                   	push   %eax
  8016e4:	53                   	push   %ebx
  8016e5:	e8 dc fb ff ff       	call   8012c6 <fd_lookup>
  8016ea:	83 c4 10             	add    $0x10,%esp
  8016ed:	85 c0                	test   %eax,%eax
  8016ef:	78 37                	js     801728 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016f1:	83 ec 08             	sub    $0x8,%esp
  8016f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016f7:	50                   	push   %eax
  8016f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016fb:	ff 30                	pushl  (%eax)
  8016fd:	e8 18 fc ff ff       	call   80131a <dev_lookup>
  801702:	83 c4 10             	add    $0x10,%esp
  801705:	85 c0                	test   %eax,%eax
  801707:	78 1f                	js     801728 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801709:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80170c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801710:	74 1b                	je     80172d <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801712:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801715:	8b 52 18             	mov    0x18(%edx),%edx
  801718:	85 d2                	test   %edx,%edx
  80171a:	74 32                	je     80174e <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80171c:	83 ec 08             	sub    $0x8,%esp
  80171f:	ff 75 0c             	pushl  0xc(%ebp)
  801722:	50                   	push   %eax
  801723:	ff d2                	call   *%edx
  801725:	83 c4 10             	add    $0x10,%esp
}
  801728:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80172b:	c9                   	leave  
  80172c:	c3                   	ret    
			thisenv->env_id, fdnum);
  80172d:	a1 04 50 80 00       	mov    0x805004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801732:	8b 40 48             	mov    0x48(%eax),%eax
  801735:	83 ec 04             	sub    $0x4,%esp
  801738:	53                   	push   %ebx
  801739:	50                   	push   %eax
  80173a:	68 e8 2e 80 00       	push   $0x802ee8
  80173f:	e8 a7 eb ff ff       	call   8002eb <cprintf>
		return -E_INVAL;
  801744:	83 c4 10             	add    $0x10,%esp
  801747:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80174c:	eb da                	jmp    801728 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80174e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801753:	eb d3                	jmp    801728 <ftruncate+0x56>

00801755 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801755:	f3 0f 1e fb          	endbr32 
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
  80175c:	53                   	push   %ebx
  80175d:	83 ec 1c             	sub    $0x1c,%esp
  801760:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801763:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801766:	50                   	push   %eax
  801767:	ff 75 08             	pushl  0x8(%ebp)
  80176a:	e8 57 fb ff ff       	call   8012c6 <fd_lookup>
  80176f:	83 c4 10             	add    $0x10,%esp
  801772:	85 c0                	test   %eax,%eax
  801774:	78 4b                	js     8017c1 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801776:	83 ec 08             	sub    $0x8,%esp
  801779:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80177c:	50                   	push   %eax
  80177d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801780:	ff 30                	pushl  (%eax)
  801782:	e8 93 fb ff ff       	call   80131a <dev_lookup>
  801787:	83 c4 10             	add    $0x10,%esp
  80178a:	85 c0                	test   %eax,%eax
  80178c:	78 33                	js     8017c1 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80178e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801791:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801795:	74 2f                	je     8017c6 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801797:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80179a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017a1:	00 00 00 
	stat->st_isdir = 0;
  8017a4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017ab:	00 00 00 
	stat->st_dev = dev;
  8017ae:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8017b4:	83 ec 08             	sub    $0x8,%esp
  8017b7:	53                   	push   %ebx
  8017b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8017bb:	ff 50 14             	call   *0x14(%eax)
  8017be:	83 c4 10             	add    $0x10,%esp
}
  8017c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017c4:	c9                   	leave  
  8017c5:	c3                   	ret    
		return -E_NOT_SUPP;
  8017c6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017cb:	eb f4                	jmp    8017c1 <fstat+0x6c>

008017cd <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8017cd:	f3 0f 1e fb          	endbr32 
  8017d1:	55                   	push   %ebp
  8017d2:	89 e5                	mov    %esp,%ebp
  8017d4:	56                   	push   %esi
  8017d5:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8017d6:	83 ec 08             	sub    $0x8,%esp
  8017d9:	6a 00                	push   $0x0
  8017db:	ff 75 08             	pushl  0x8(%ebp)
  8017de:	e8 fb 01 00 00       	call   8019de <open>
  8017e3:	89 c3                	mov    %eax,%ebx
  8017e5:	83 c4 10             	add    $0x10,%esp
  8017e8:	85 c0                	test   %eax,%eax
  8017ea:	78 1b                	js     801807 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8017ec:	83 ec 08             	sub    $0x8,%esp
  8017ef:	ff 75 0c             	pushl  0xc(%ebp)
  8017f2:	50                   	push   %eax
  8017f3:	e8 5d ff ff ff       	call   801755 <fstat>
  8017f8:	89 c6                	mov    %eax,%esi
	close(fd);
  8017fa:	89 1c 24             	mov    %ebx,(%esp)
  8017fd:	e8 fd fb ff ff       	call   8013ff <close>
	return r;
  801802:	83 c4 10             	add    $0x10,%esp
  801805:	89 f3                	mov    %esi,%ebx
}
  801807:	89 d8                	mov    %ebx,%eax
  801809:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80180c:	5b                   	pop    %ebx
  80180d:	5e                   	pop    %esi
  80180e:	5d                   	pop    %ebp
  80180f:	c3                   	ret    

00801810 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
  801813:	56                   	push   %esi
  801814:	53                   	push   %ebx
  801815:	89 c6                	mov    %eax,%esi
  801817:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801819:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801820:	74 27                	je     801849 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801822:	6a 07                	push   $0x7
  801824:	68 00 60 80 00       	push   $0x806000
  801829:	56                   	push   %esi
  80182a:	ff 35 00 50 80 00    	pushl  0x805000
  801830:	e8 d0 0e 00 00       	call   802705 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801835:	83 c4 0c             	add    $0xc,%esp
  801838:	6a 00                	push   $0x0
  80183a:	53                   	push   %ebx
  80183b:	6a 00                	push   $0x0
  80183d:	e8 3e 0e 00 00       	call   802680 <ipc_recv>
}
  801842:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801845:	5b                   	pop    %ebx
  801846:	5e                   	pop    %esi
  801847:	5d                   	pop    %ebp
  801848:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801849:	83 ec 0c             	sub    $0xc,%esp
  80184c:	6a 01                	push   $0x1
  80184e:	e8 0a 0f 00 00       	call   80275d <ipc_find_env>
  801853:	a3 00 50 80 00       	mov    %eax,0x805000
  801858:	83 c4 10             	add    $0x10,%esp
  80185b:	eb c5                	jmp    801822 <fsipc+0x12>

0080185d <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80185d:	f3 0f 1e fb          	endbr32 
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
  801864:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801867:	8b 45 08             	mov    0x8(%ebp),%eax
  80186a:	8b 40 0c             	mov    0xc(%eax),%eax
  80186d:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801872:	8b 45 0c             	mov    0xc(%ebp),%eax
  801875:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80187a:	ba 00 00 00 00       	mov    $0x0,%edx
  80187f:	b8 02 00 00 00       	mov    $0x2,%eax
  801884:	e8 87 ff ff ff       	call   801810 <fsipc>
}
  801889:	c9                   	leave  
  80188a:	c3                   	ret    

0080188b <devfile_flush>:
{
  80188b:	f3 0f 1e fb          	endbr32 
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
  801892:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801895:	8b 45 08             	mov    0x8(%ebp),%eax
  801898:	8b 40 0c             	mov    0xc(%eax),%eax
  80189b:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8018a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a5:	b8 06 00 00 00       	mov    $0x6,%eax
  8018aa:	e8 61 ff ff ff       	call   801810 <fsipc>
}
  8018af:	c9                   	leave  
  8018b0:	c3                   	ret    

008018b1 <devfile_stat>:
{
  8018b1:	f3 0f 1e fb          	endbr32 
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
  8018b8:	53                   	push   %ebx
  8018b9:	83 ec 04             	sub    $0x4,%esp
  8018bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8018bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8018c5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8018ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8018cf:	b8 05 00 00 00       	mov    $0x5,%eax
  8018d4:	e8 37 ff ff ff       	call   801810 <fsipc>
  8018d9:	85 c0                	test   %eax,%eax
  8018db:	78 2c                	js     801909 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8018dd:	83 ec 08             	sub    $0x8,%esp
  8018e0:	68 00 60 80 00       	push   $0x806000
  8018e5:	53                   	push   %ebx
  8018e6:	e8 0a f0 ff ff       	call   8008f5 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8018eb:	a1 80 60 80 00       	mov    0x806080,%eax
  8018f0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8018f6:	a1 84 60 80 00       	mov    0x806084,%eax
  8018fb:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801901:	83 c4 10             	add    $0x10,%esp
  801904:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801909:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    

0080190e <devfile_write>:
{
  80190e:	f3 0f 1e fb          	endbr32 
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
  801915:	83 ec 0c             	sub    $0xc,%esp
  801918:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80191b:	8b 55 08             	mov    0x8(%ebp),%edx
  80191e:	8b 52 0c             	mov    0xc(%edx),%edx
  801921:	89 15 00 60 80 00    	mov    %edx,0x806000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801927:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80192c:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801931:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  801934:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801939:	50                   	push   %eax
  80193a:	ff 75 0c             	pushl  0xc(%ebp)
  80193d:	68 08 60 80 00       	push   $0x806008
  801942:	e8 64 f1 ff ff       	call   800aab <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801947:	ba 00 00 00 00       	mov    $0x0,%edx
  80194c:	b8 04 00 00 00       	mov    $0x4,%eax
  801951:	e8 ba fe ff ff       	call   801810 <fsipc>
}
  801956:	c9                   	leave  
  801957:	c3                   	ret    

00801958 <devfile_read>:
{
  801958:	f3 0f 1e fb          	endbr32 
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	56                   	push   %esi
  801960:	53                   	push   %ebx
  801961:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801964:	8b 45 08             	mov    0x8(%ebp),%eax
  801967:	8b 40 0c             	mov    0xc(%eax),%eax
  80196a:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  80196f:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801975:	ba 00 00 00 00       	mov    $0x0,%edx
  80197a:	b8 03 00 00 00       	mov    $0x3,%eax
  80197f:	e8 8c fe ff ff       	call   801810 <fsipc>
  801984:	89 c3                	mov    %eax,%ebx
  801986:	85 c0                	test   %eax,%eax
  801988:	78 1f                	js     8019a9 <devfile_read+0x51>
	assert(r <= n);
  80198a:	39 f0                	cmp    %esi,%eax
  80198c:	77 24                	ja     8019b2 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  80198e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801993:	7f 33                	jg     8019c8 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801995:	83 ec 04             	sub    $0x4,%esp
  801998:	50                   	push   %eax
  801999:	68 00 60 80 00       	push   $0x806000
  80199e:	ff 75 0c             	pushl  0xc(%ebp)
  8019a1:	e8 05 f1 ff ff       	call   800aab <memmove>
	return r;
  8019a6:	83 c4 10             	add    $0x10,%esp
}
  8019a9:	89 d8                	mov    %ebx,%eax
  8019ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ae:	5b                   	pop    %ebx
  8019af:	5e                   	pop    %esi
  8019b0:	5d                   	pop    %ebp
  8019b1:	c3                   	ret    
	assert(r <= n);
  8019b2:	68 54 2f 80 00       	push   $0x802f54
  8019b7:	68 5b 2f 80 00       	push   $0x802f5b
  8019bc:	6a 7c                	push   $0x7c
  8019be:	68 70 2f 80 00       	push   $0x802f70
  8019c3:	e8 3c e8 ff ff       	call   800204 <_panic>
	assert(r <= PGSIZE);
  8019c8:	68 7b 2f 80 00       	push   $0x802f7b
  8019cd:	68 5b 2f 80 00       	push   $0x802f5b
  8019d2:	6a 7d                	push   $0x7d
  8019d4:	68 70 2f 80 00       	push   $0x802f70
  8019d9:	e8 26 e8 ff ff       	call   800204 <_panic>

008019de <open>:
{
  8019de:	f3 0f 1e fb          	endbr32 
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
  8019e5:	56                   	push   %esi
  8019e6:	53                   	push   %ebx
  8019e7:	83 ec 1c             	sub    $0x1c,%esp
  8019ea:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8019ed:	56                   	push   %esi
  8019ee:	e8 bf ee ff ff       	call   8008b2 <strlen>
  8019f3:	83 c4 10             	add    $0x10,%esp
  8019f6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8019fb:	7f 6c                	jg     801a69 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8019fd:	83 ec 0c             	sub    $0xc,%esp
  801a00:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a03:	50                   	push   %eax
  801a04:	e8 67 f8 ff ff       	call   801270 <fd_alloc>
  801a09:	89 c3                	mov    %eax,%ebx
  801a0b:	83 c4 10             	add    $0x10,%esp
  801a0e:	85 c0                	test   %eax,%eax
  801a10:	78 3c                	js     801a4e <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801a12:	83 ec 08             	sub    $0x8,%esp
  801a15:	56                   	push   %esi
  801a16:	68 00 60 80 00       	push   $0x806000
  801a1b:	e8 d5 ee ff ff       	call   8008f5 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a20:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a23:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a2b:	b8 01 00 00 00       	mov    $0x1,%eax
  801a30:	e8 db fd ff ff       	call   801810 <fsipc>
  801a35:	89 c3                	mov    %eax,%ebx
  801a37:	83 c4 10             	add    $0x10,%esp
  801a3a:	85 c0                	test   %eax,%eax
  801a3c:	78 19                	js     801a57 <open+0x79>
	return fd2num(fd);
  801a3e:	83 ec 0c             	sub    $0xc,%esp
  801a41:	ff 75 f4             	pushl  -0xc(%ebp)
  801a44:	e8 f8 f7 ff ff       	call   801241 <fd2num>
  801a49:	89 c3                	mov    %eax,%ebx
  801a4b:	83 c4 10             	add    $0x10,%esp
}
  801a4e:	89 d8                	mov    %ebx,%eax
  801a50:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a53:	5b                   	pop    %ebx
  801a54:	5e                   	pop    %esi
  801a55:	5d                   	pop    %ebp
  801a56:	c3                   	ret    
		fd_close(fd, 0);
  801a57:	83 ec 08             	sub    $0x8,%esp
  801a5a:	6a 00                	push   $0x0
  801a5c:	ff 75 f4             	pushl  -0xc(%ebp)
  801a5f:	e8 10 f9 ff ff       	call   801374 <fd_close>
		return r;
  801a64:	83 c4 10             	add    $0x10,%esp
  801a67:	eb e5                	jmp    801a4e <open+0x70>
		return -E_BAD_PATH;
  801a69:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a6e:	eb de                	jmp    801a4e <open+0x70>

00801a70 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a70:	f3 0f 1e fb          	endbr32 
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
  801a77:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a7a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a7f:	b8 08 00 00 00       	mov    $0x8,%eax
  801a84:	e8 87 fd ff ff       	call   801810 <fsipc>
}
  801a89:	c9                   	leave  
  801a8a:	c3                   	ret    

00801a8b <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801a8b:	f3 0f 1e fb          	endbr32 
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
  801a92:	57                   	push   %edi
  801a93:	56                   	push   %esi
  801a94:	53                   	push   %ebx
  801a95:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801a9b:	6a 00                	push   $0x0
  801a9d:	ff 75 08             	pushl  0x8(%ebp)
  801aa0:	e8 39 ff ff ff       	call   8019de <open>
  801aa5:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801aab:	83 c4 10             	add    $0x10,%esp
  801aae:	85 c0                	test   %eax,%eax
  801ab0:	0f 88 e7 04 00 00    	js     801f9d <spawn+0x512>
  801ab6:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801ab8:	83 ec 04             	sub    $0x4,%esp
  801abb:	68 00 02 00 00       	push   $0x200
  801ac0:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801ac6:	50                   	push   %eax
  801ac7:	52                   	push   %edx
  801ac8:	e8 07 fb ff ff       	call   8015d4 <readn>
  801acd:	83 c4 10             	add    $0x10,%esp
  801ad0:	3d 00 02 00 00       	cmp    $0x200,%eax
  801ad5:	75 7e                	jne    801b55 <spawn+0xca>
	    || elf->e_magic != ELF_MAGIC) {
  801ad7:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801ade:	45 4c 46 
  801ae1:	75 72                	jne    801b55 <spawn+0xca>
  801ae3:	b8 07 00 00 00       	mov    $0x7,%eax
  801ae8:	cd 30                	int    $0x30
  801aea:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801af0:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801af6:	85 c0                	test   %eax,%eax
  801af8:	0f 88 93 04 00 00    	js     801f91 <spawn+0x506>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801afe:	25 ff 03 00 00       	and    $0x3ff,%eax
  801b03:	6b f0 7c             	imul   $0x7c,%eax,%esi
  801b06:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801b0c:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801b12:	b9 11 00 00 00       	mov    $0x11,%ecx
  801b17:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801b19:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801b1f:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801b25:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801b2a:	be 00 00 00 00       	mov    $0x0,%esi
  801b2f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801b32:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
	for (argc = 0; argv[argc] != 0; argc++)
  801b39:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801b3c:	85 c0                	test   %eax,%eax
  801b3e:	74 4d                	je     801b8d <spawn+0x102>
		string_size += strlen(argv[argc]) + 1;
  801b40:	83 ec 0c             	sub    $0xc,%esp
  801b43:	50                   	push   %eax
  801b44:	e8 69 ed ff ff       	call   8008b2 <strlen>
  801b49:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801b4d:	83 c3 01             	add    $0x1,%ebx
  801b50:	83 c4 10             	add    $0x10,%esp
  801b53:	eb dd                	jmp    801b32 <spawn+0xa7>
		close(fd);
  801b55:	83 ec 0c             	sub    $0xc,%esp
  801b58:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801b5e:	e8 9c f8 ff ff       	call   8013ff <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801b63:	83 c4 0c             	add    $0xc,%esp
  801b66:	68 7f 45 4c 46       	push   $0x464c457f
  801b6b:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801b71:	68 87 2f 80 00       	push   $0x802f87
  801b76:	e8 70 e7 ff ff       	call   8002eb <cprintf>
		return -E_NOT_EXEC;
  801b7b:	83 c4 10             	add    $0x10,%esp
  801b7e:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801b85:	ff ff ff 
  801b88:	e9 10 04 00 00       	jmp    801f9d <spawn+0x512>
  801b8d:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801b93:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801b99:	bf 00 10 40 00       	mov    $0x401000,%edi
  801b9e:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801ba0:	89 fa                	mov    %edi,%edx
  801ba2:	83 e2 fc             	and    $0xfffffffc,%edx
  801ba5:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801bac:	29 c2                	sub    %eax,%edx
  801bae:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801bb4:	8d 42 f8             	lea    -0x8(%edx),%eax
  801bb7:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801bbc:	0f 86 fe 03 00 00    	jbe    801fc0 <spawn+0x535>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801bc2:	83 ec 04             	sub    $0x4,%esp
  801bc5:	6a 07                	push   $0x7
  801bc7:	68 00 00 40 00       	push   $0x400000
  801bcc:	6a 00                	push   $0x0
  801bce:	e8 64 f1 ff ff       	call   800d37 <sys_page_alloc>
  801bd3:	83 c4 10             	add    $0x10,%esp
  801bd6:	85 c0                	test   %eax,%eax
  801bd8:	0f 88 e7 03 00 00    	js     801fc5 <spawn+0x53a>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801bde:	be 00 00 00 00       	mov    $0x0,%esi
  801be3:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801be9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801bec:	eb 30                	jmp    801c1e <spawn+0x193>
		argv_store[i] = UTEMP2USTACK(string_store);
  801bee:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801bf4:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801bfa:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801bfd:	83 ec 08             	sub    $0x8,%esp
  801c00:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801c03:	57                   	push   %edi
  801c04:	e8 ec ec ff ff       	call   8008f5 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801c09:	83 c4 04             	add    $0x4,%esp
  801c0c:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801c0f:	e8 9e ec ff ff       	call   8008b2 <strlen>
  801c14:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801c18:	83 c6 01             	add    $0x1,%esi
  801c1b:	83 c4 10             	add    $0x10,%esp
  801c1e:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801c24:	7f c8                	jg     801bee <spawn+0x163>
	}
	argv_store[argc] = 0;
  801c26:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801c2c:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801c32:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801c39:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801c3f:	0f 85 86 00 00 00    	jne    801ccb <spawn+0x240>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801c45:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801c4b:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  801c51:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801c54:	89 c8                	mov    %ecx,%eax
  801c56:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  801c5c:	89 48 f8             	mov    %ecx,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801c5f:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801c64:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801c6a:	83 ec 0c             	sub    $0xc,%esp
  801c6d:	6a 07                	push   $0x7
  801c6f:	68 00 d0 bf ee       	push   $0xeebfd000
  801c74:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801c7a:	68 00 00 40 00       	push   $0x400000
  801c7f:	6a 00                	push   $0x0
  801c81:	e8 f8 f0 ff ff       	call   800d7e <sys_page_map>
  801c86:	89 c3                	mov    %eax,%ebx
  801c88:	83 c4 20             	add    $0x20,%esp
  801c8b:	85 c0                	test   %eax,%eax
  801c8d:	0f 88 3a 03 00 00    	js     801fcd <spawn+0x542>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801c93:	83 ec 08             	sub    $0x8,%esp
  801c96:	68 00 00 40 00       	push   $0x400000
  801c9b:	6a 00                	push   $0x0
  801c9d:	e8 22 f1 ff ff       	call   800dc4 <sys_page_unmap>
  801ca2:	89 c3                	mov    %eax,%ebx
  801ca4:	83 c4 10             	add    $0x10,%esp
  801ca7:	85 c0                	test   %eax,%eax
  801ca9:	0f 88 1e 03 00 00    	js     801fcd <spawn+0x542>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801caf:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801cb5:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801cbc:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  801cc3:	00 00 00 
  801cc6:	e9 4f 01 00 00       	jmp    801e1a <spawn+0x38f>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801ccb:	68 e4 2f 80 00       	push   $0x802fe4
  801cd0:	68 5b 2f 80 00       	push   $0x802f5b
  801cd5:	68 f2 00 00 00       	push   $0xf2
  801cda:	68 a1 2f 80 00       	push   $0x802fa1
  801cdf:	e8 20 e5 ff ff       	call   800204 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801ce4:	83 ec 04             	sub    $0x4,%esp
  801ce7:	6a 07                	push   $0x7
  801ce9:	68 00 00 40 00       	push   $0x400000
  801cee:	6a 00                	push   $0x0
  801cf0:	e8 42 f0 ff ff       	call   800d37 <sys_page_alloc>
  801cf5:	83 c4 10             	add    $0x10,%esp
  801cf8:	85 c0                	test   %eax,%eax
  801cfa:	0f 88 ab 02 00 00    	js     801fab <spawn+0x520>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801d00:	83 ec 08             	sub    $0x8,%esp
  801d03:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801d09:	01 f0                	add    %esi,%eax
  801d0b:	50                   	push   %eax
  801d0c:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801d12:	e8 8e f9 ff ff       	call   8016a5 <seek>
  801d17:	83 c4 10             	add    $0x10,%esp
  801d1a:	85 c0                	test   %eax,%eax
  801d1c:	0f 88 90 02 00 00    	js     801fb2 <spawn+0x527>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801d22:	83 ec 04             	sub    $0x4,%esp
  801d25:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801d2b:	29 f0                	sub    %esi,%eax
  801d2d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d32:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801d37:	0f 47 c1             	cmova  %ecx,%eax
  801d3a:	50                   	push   %eax
  801d3b:	68 00 00 40 00       	push   $0x400000
  801d40:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801d46:	e8 89 f8 ff ff       	call   8015d4 <readn>
  801d4b:	83 c4 10             	add    $0x10,%esp
  801d4e:	85 c0                	test   %eax,%eax
  801d50:	0f 88 63 02 00 00    	js     801fb9 <spawn+0x52e>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801d56:	83 ec 0c             	sub    $0xc,%esp
  801d59:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801d5f:	53                   	push   %ebx
  801d60:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801d66:	68 00 00 40 00       	push   $0x400000
  801d6b:	6a 00                	push   $0x0
  801d6d:	e8 0c f0 ff ff       	call   800d7e <sys_page_map>
  801d72:	83 c4 20             	add    $0x20,%esp
  801d75:	85 c0                	test   %eax,%eax
  801d77:	78 7c                	js     801df5 <spawn+0x36a>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801d79:	83 ec 08             	sub    $0x8,%esp
  801d7c:	68 00 00 40 00       	push   $0x400000
  801d81:	6a 00                	push   $0x0
  801d83:	e8 3c f0 ff ff       	call   800dc4 <sys_page_unmap>
  801d88:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801d8b:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801d91:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801d97:	89 fe                	mov    %edi,%esi
  801d99:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801d9f:	76 69                	jbe    801e0a <spawn+0x37f>
		if (i >= filesz) {
  801da1:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801da7:	0f 87 37 ff ff ff    	ja     801ce4 <spawn+0x259>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801dad:	83 ec 04             	sub    $0x4,%esp
  801db0:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801db6:	53                   	push   %ebx
  801db7:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801dbd:	e8 75 ef ff ff       	call   800d37 <sys_page_alloc>
  801dc2:	83 c4 10             	add    $0x10,%esp
  801dc5:	85 c0                	test   %eax,%eax
  801dc7:	79 c2                	jns    801d8b <spawn+0x300>
  801dc9:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801dcb:	83 ec 0c             	sub    $0xc,%esp
  801dce:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801dd4:	e8 d3 ee ff ff       	call   800cac <sys_env_destroy>
	close(fd);
  801dd9:	83 c4 04             	add    $0x4,%esp
  801ddc:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801de2:	e8 18 f6 ff ff       	call   8013ff <close>
	return r;
  801de7:	83 c4 10             	add    $0x10,%esp
  801dea:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801df0:	e9 a8 01 00 00       	jmp    801f9d <spawn+0x512>
				panic("spawn: sys_page_map data: %e", r);
  801df5:	50                   	push   %eax
  801df6:	68 ad 2f 80 00       	push   $0x802fad
  801dfb:	68 25 01 00 00       	push   $0x125
  801e00:	68 a1 2f 80 00       	push   $0x802fa1
  801e05:	e8 fa e3 ff ff       	call   800204 <_panic>
  801e0a:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801e10:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801e17:	83 c6 20             	add    $0x20,%esi
  801e1a:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801e21:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801e27:	7e 6d                	jle    801e96 <spawn+0x40b>
		if (ph->p_type != ELF_PROG_LOAD)
  801e29:	83 3e 01             	cmpl   $0x1,(%esi)
  801e2c:	75 e2                	jne    801e10 <spawn+0x385>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801e2e:	8b 46 18             	mov    0x18(%esi),%eax
  801e31:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801e34:	83 f8 01             	cmp    $0x1,%eax
  801e37:	19 c0                	sbb    %eax,%eax
  801e39:	83 e0 fe             	and    $0xfffffffe,%eax
  801e3c:	83 c0 07             	add    $0x7,%eax
  801e3f:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801e45:	8b 4e 04             	mov    0x4(%esi),%ecx
  801e48:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801e4e:	8b 56 10             	mov    0x10(%esi),%edx
  801e51:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801e57:	8b 7e 14             	mov    0x14(%esi),%edi
  801e5a:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  801e60:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801e63:	89 d8                	mov    %ebx,%eax
  801e65:	25 ff 0f 00 00       	and    $0xfff,%eax
  801e6a:	74 1a                	je     801e86 <spawn+0x3fb>
		va -= i;
  801e6c:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801e6e:	01 c7                	add    %eax,%edi
  801e70:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801e76:	01 c2                	add    %eax,%edx
  801e78:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  801e7e:	29 c1                	sub    %eax,%ecx
  801e80:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801e86:	bf 00 00 00 00       	mov    $0x0,%edi
  801e8b:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801e91:	e9 01 ff ff ff       	jmp    801d97 <spawn+0x30c>
	close(fd);
  801e96:	83 ec 0c             	sub    $0xc,%esp
  801e99:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801e9f:	e8 5b f5 ff ff       	call   8013ff <close>
  801ea4:	83 c4 10             	add    $0x10,%esp
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	uint32_t addr;
	int r;
	for(addr = 0; addr < USTACKTOP; addr += PGSIZE){
  801ea7:	bb 00 00 00 00       	mov    $0x0,%ebx
  801eac:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  801eb2:	eb 0e                	jmp    801ec2 <spawn+0x437>
  801eb4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801eba:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801ec0:	74 5a                	je     801f1c <spawn+0x491>
		if((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U) && (uvpt[PGNUM(addr)] & PTE_SHARE)){
  801ec2:	89 d8                	mov    %ebx,%eax
  801ec4:	c1 e8 16             	shr    $0x16,%eax
  801ec7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801ece:	a8 01                	test   $0x1,%al
  801ed0:	74 e2                	je     801eb4 <spawn+0x429>
  801ed2:	89 d8                	mov    %ebx,%eax
  801ed4:	c1 e8 0c             	shr    $0xc,%eax
  801ed7:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801ede:	f6 c2 01             	test   $0x1,%dl
  801ee1:	74 d1                	je     801eb4 <spawn+0x429>
  801ee3:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801eea:	f6 c2 04             	test   $0x4,%dl
  801eed:	74 c5                	je     801eb4 <spawn+0x429>
  801eef:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801ef6:	f6 c6 04             	test   $0x4,%dh
  801ef9:	74 b9                	je     801eb4 <spawn+0x429>
			if(r = sys_page_map(0, (void*)addr, child, (void*)addr, (uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  801efb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801f02:	83 ec 0c             	sub    $0xc,%esp
  801f05:	25 07 0e 00 00       	and    $0xe07,%eax
  801f0a:	50                   	push   %eax
  801f0b:	53                   	push   %ebx
  801f0c:	56                   	push   %esi
  801f0d:	53                   	push   %ebx
  801f0e:	6a 00                	push   $0x0
  801f10:	e8 69 ee ff ff       	call   800d7e <sys_page_map>
  801f15:	83 c4 20             	add    $0x20,%esp
  801f18:	85 c0                	test   %eax,%eax
  801f1a:	79 98                	jns    801eb4 <spawn+0x429>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801f1c:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801f23:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801f26:	83 ec 08             	sub    $0x8,%esp
  801f29:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801f2f:	50                   	push   %eax
  801f30:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801f36:	e8 15 ef ff ff       	call   800e50 <sys_env_set_trapframe>
  801f3b:	83 c4 10             	add    $0x10,%esp
  801f3e:	85 c0                	test   %eax,%eax
  801f40:	78 25                	js     801f67 <spawn+0x4dc>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801f42:	83 ec 08             	sub    $0x8,%esp
  801f45:	6a 02                	push   $0x2
  801f47:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801f4d:	e8 b8 ee ff ff       	call   800e0a <sys_env_set_status>
  801f52:	83 c4 10             	add    $0x10,%esp
  801f55:	85 c0                	test   %eax,%eax
  801f57:	78 23                	js     801f7c <spawn+0x4f1>
	return child;
  801f59:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801f5f:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801f65:	eb 36                	jmp    801f9d <spawn+0x512>
		panic("sys_env_set_trapframe: %e", r);
  801f67:	50                   	push   %eax
  801f68:	68 ca 2f 80 00       	push   $0x802fca
  801f6d:	68 86 00 00 00       	push   $0x86
  801f72:	68 a1 2f 80 00       	push   $0x802fa1
  801f77:	e8 88 e2 ff ff       	call   800204 <_panic>
		panic("sys_env_set_status: %e", r);
  801f7c:	50                   	push   %eax
  801f7d:	68 9b 2e 80 00       	push   $0x802e9b
  801f82:	68 89 00 00 00       	push   $0x89
  801f87:	68 a1 2f 80 00       	push   $0x802fa1
  801f8c:	e8 73 e2 ff ff       	call   800204 <_panic>
		return r;
  801f91:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801f97:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  801f9d:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801fa3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fa6:	5b                   	pop    %ebx
  801fa7:	5e                   	pop    %esi
  801fa8:	5f                   	pop    %edi
  801fa9:	5d                   	pop    %ebp
  801faa:	c3                   	ret    
  801fab:	89 c7                	mov    %eax,%edi
  801fad:	e9 19 fe ff ff       	jmp    801dcb <spawn+0x340>
  801fb2:	89 c7                	mov    %eax,%edi
  801fb4:	e9 12 fe ff ff       	jmp    801dcb <spawn+0x340>
  801fb9:	89 c7                	mov    %eax,%edi
  801fbb:	e9 0b fe ff ff       	jmp    801dcb <spawn+0x340>
		return -E_NO_MEM;
  801fc0:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(addr = 0; addr < USTACKTOP; addr += PGSIZE){
  801fc5:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801fcb:	eb d0                	jmp    801f9d <spawn+0x512>
	sys_page_unmap(0, UTEMP);
  801fcd:	83 ec 08             	sub    $0x8,%esp
  801fd0:	68 00 00 40 00       	push   $0x400000
  801fd5:	6a 00                	push   $0x0
  801fd7:	e8 e8 ed ff ff       	call   800dc4 <sys_page_unmap>
  801fdc:	83 c4 10             	add    $0x10,%esp
  801fdf:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801fe5:	eb b6                	jmp    801f9d <spawn+0x512>

00801fe7 <spawnl>:
{
  801fe7:	f3 0f 1e fb          	endbr32 
  801feb:	55                   	push   %ebp
  801fec:	89 e5                	mov    %esp,%ebp
  801fee:	57                   	push   %edi
  801fef:	56                   	push   %esi
  801ff0:	53                   	push   %ebx
  801ff1:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801ff4:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801ff7:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801ffc:	8d 4a 04             	lea    0x4(%edx),%ecx
  801fff:	83 3a 00             	cmpl   $0x0,(%edx)
  802002:	74 07                	je     80200b <spawnl+0x24>
		argc++;
  802004:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  802007:	89 ca                	mov    %ecx,%edx
  802009:	eb f1                	jmp    801ffc <spawnl+0x15>
	const char *argv[argc+2];
  80200b:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  802012:	89 d1                	mov    %edx,%ecx
  802014:	83 e1 f0             	and    $0xfffffff0,%ecx
  802017:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  80201d:	89 e6                	mov    %esp,%esi
  80201f:	29 d6                	sub    %edx,%esi
  802021:	89 f2                	mov    %esi,%edx
  802023:	39 d4                	cmp    %edx,%esp
  802025:	74 10                	je     802037 <spawnl+0x50>
  802027:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  80202d:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  802034:	00 
  802035:	eb ec                	jmp    802023 <spawnl+0x3c>
  802037:	89 ca                	mov    %ecx,%edx
  802039:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  80203f:	29 d4                	sub    %edx,%esp
  802041:	85 d2                	test   %edx,%edx
  802043:	74 05                	je     80204a <spawnl+0x63>
  802045:	83 4c 14 fc 00       	orl    $0x0,-0x4(%esp,%edx,1)
  80204a:	8d 74 24 03          	lea    0x3(%esp),%esi
  80204e:	89 f2                	mov    %esi,%edx
  802050:	c1 ea 02             	shr    $0x2,%edx
  802053:	83 e6 fc             	and    $0xfffffffc,%esi
  802056:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802058:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80205b:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  802062:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  802069:	00 
	va_start(vl, arg0);
  80206a:	8d 4d 10             	lea    0x10(%ebp),%ecx
  80206d:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  80206f:	b8 00 00 00 00       	mov    $0x0,%eax
  802074:	eb 0b                	jmp    802081 <spawnl+0x9a>
		argv[i+1] = va_arg(vl, const char *);
  802076:	83 c0 01             	add    $0x1,%eax
  802079:	8b 39                	mov    (%ecx),%edi
  80207b:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  80207e:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  802081:	39 d0                	cmp    %edx,%eax
  802083:	75 f1                	jne    802076 <spawnl+0x8f>
	return spawn(prog, argv);
  802085:	83 ec 08             	sub    $0x8,%esp
  802088:	56                   	push   %esi
  802089:	ff 75 08             	pushl  0x8(%ebp)
  80208c:	e8 fa f9 ff ff       	call   801a8b <spawn>
}
  802091:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802094:	5b                   	pop    %ebx
  802095:	5e                   	pop    %esi
  802096:	5f                   	pop    %edi
  802097:	5d                   	pop    %ebp
  802098:	c3                   	ret    

00802099 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802099:	f3 0f 1e fb          	endbr32 
  80209d:	55                   	push   %ebp
  80209e:	89 e5                	mov    %esp,%ebp
  8020a0:	56                   	push   %esi
  8020a1:	53                   	push   %ebx
  8020a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8020a5:	83 ec 0c             	sub    $0xc,%esp
  8020a8:	ff 75 08             	pushl  0x8(%ebp)
  8020ab:	e8 a5 f1 ff ff       	call   801255 <fd2data>
  8020b0:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8020b2:	83 c4 08             	add    $0x8,%esp
  8020b5:	68 0a 30 80 00       	push   $0x80300a
  8020ba:	53                   	push   %ebx
  8020bb:	e8 35 e8 ff ff       	call   8008f5 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8020c0:	8b 46 04             	mov    0x4(%esi),%eax
  8020c3:	2b 06                	sub    (%esi),%eax
  8020c5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8020cb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8020d2:	00 00 00 
	stat->st_dev = &devpipe;
  8020d5:	c7 83 88 00 00 00 28 	movl   $0x804028,0x88(%ebx)
  8020dc:	40 80 00 
	return 0;
}
  8020df:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020e7:	5b                   	pop    %ebx
  8020e8:	5e                   	pop    %esi
  8020e9:	5d                   	pop    %ebp
  8020ea:	c3                   	ret    

008020eb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8020eb:	f3 0f 1e fb          	endbr32 
  8020ef:	55                   	push   %ebp
  8020f0:	89 e5                	mov    %esp,%ebp
  8020f2:	53                   	push   %ebx
  8020f3:	83 ec 0c             	sub    $0xc,%esp
  8020f6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8020f9:	53                   	push   %ebx
  8020fa:	6a 00                	push   $0x0
  8020fc:	e8 c3 ec ff ff       	call   800dc4 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802101:	89 1c 24             	mov    %ebx,(%esp)
  802104:	e8 4c f1 ff ff       	call   801255 <fd2data>
  802109:	83 c4 08             	add    $0x8,%esp
  80210c:	50                   	push   %eax
  80210d:	6a 00                	push   $0x0
  80210f:	e8 b0 ec ff ff       	call   800dc4 <sys_page_unmap>
}
  802114:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802117:	c9                   	leave  
  802118:	c3                   	ret    

00802119 <_pipeisclosed>:
{
  802119:	55                   	push   %ebp
  80211a:	89 e5                	mov    %esp,%ebp
  80211c:	57                   	push   %edi
  80211d:	56                   	push   %esi
  80211e:	53                   	push   %ebx
  80211f:	83 ec 1c             	sub    $0x1c,%esp
  802122:	89 c7                	mov    %eax,%edi
  802124:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802126:	a1 04 50 80 00       	mov    0x805004,%eax
  80212b:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80212e:	83 ec 0c             	sub    $0xc,%esp
  802131:	57                   	push   %edi
  802132:	e8 63 06 00 00       	call   80279a <pageref>
  802137:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80213a:	89 34 24             	mov    %esi,(%esp)
  80213d:	e8 58 06 00 00       	call   80279a <pageref>
		nn = thisenv->env_runs;
  802142:	8b 15 04 50 80 00    	mov    0x805004,%edx
  802148:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80214b:	83 c4 10             	add    $0x10,%esp
  80214e:	39 cb                	cmp    %ecx,%ebx
  802150:	74 1b                	je     80216d <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802152:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802155:	75 cf                	jne    802126 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802157:	8b 42 58             	mov    0x58(%edx),%eax
  80215a:	6a 01                	push   $0x1
  80215c:	50                   	push   %eax
  80215d:	53                   	push   %ebx
  80215e:	68 11 30 80 00       	push   $0x803011
  802163:	e8 83 e1 ff ff       	call   8002eb <cprintf>
  802168:	83 c4 10             	add    $0x10,%esp
  80216b:	eb b9                	jmp    802126 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80216d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802170:	0f 94 c0             	sete   %al
  802173:	0f b6 c0             	movzbl %al,%eax
}
  802176:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802179:	5b                   	pop    %ebx
  80217a:	5e                   	pop    %esi
  80217b:	5f                   	pop    %edi
  80217c:	5d                   	pop    %ebp
  80217d:	c3                   	ret    

0080217e <devpipe_write>:
{
  80217e:	f3 0f 1e fb          	endbr32 
  802182:	55                   	push   %ebp
  802183:	89 e5                	mov    %esp,%ebp
  802185:	57                   	push   %edi
  802186:	56                   	push   %esi
  802187:	53                   	push   %ebx
  802188:	83 ec 28             	sub    $0x28,%esp
  80218b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80218e:	56                   	push   %esi
  80218f:	e8 c1 f0 ff ff       	call   801255 <fd2data>
  802194:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802196:	83 c4 10             	add    $0x10,%esp
  802199:	bf 00 00 00 00       	mov    $0x0,%edi
  80219e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8021a1:	74 4f                	je     8021f2 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8021a3:	8b 43 04             	mov    0x4(%ebx),%eax
  8021a6:	8b 0b                	mov    (%ebx),%ecx
  8021a8:	8d 51 20             	lea    0x20(%ecx),%edx
  8021ab:	39 d0                	cmp    %edx,%eax
  8021ad:	72 14                	jb     8021c3 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8021af:	89 da                	mov    %ebx,%edx
  8021b1:	89 f0                	mov    %esi,%eax
  8021b3:	e8 61 ff ff ff       	call   802119 <_pipeisclosed>
  8021b8:	85 c0                	test   %eax,%eax
  8021ba:	75 3b                	jne    8021f7 <devpipe_write+0x79>
			sys_yield();
  8021bc:	e8 53 eb ff ff       	call   800d14 <sys_yield>
  8021c1:	eb e0                	jmp    8021a3 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8021c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021c6:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8021ca:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8021cd:	89 c2                	mov    %eax,%edx
  8021cf:	c1 fa 1f             	sar    $0x1f,%edx
  8021d2:	89 d1                	mov    %edx,%ecx
  8021d4:	c1 e9 1b             	shr    $0x1b,%ecx
  8021d7:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8021da:	83 e2 1f             	and    $0x1f,%edx
  8021dd:	29 ca                	sub    %ecx,%edx
  8021df:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8021e3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8021e7:	83 c0 01             	add    $0x1,%eax
  8021ea:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8021ed:	83 c7 01             	add    $0x1,%edi
  8021f0:	eb ac                	jmp    80219e <devpipe_write+0x20>
	return i;
  8021f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8021f5:	eb 05                	jmp    8021fc <devpipe_write+0x7e>
				return 0;
  8021f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021ff:	5b                   	pop    %ebx
  802200:	5e                   	pop    %esi
  802201:	5f                   	pop    %edi
  802202:	5d                   	pop    %ebp
  802203:	c3                   	ret    

00802204 <devpipe_read>:
{
  802204:	f3 0f 1e fb          	endbr32 
  802208:	55                   	push   %ebp
  802209:	89 e5                	mov    %esp,%ebp
  80220b:	57                   	push   %edi
  80220c:	56                   	push   %esi
  80220d:	53                   	push   %ebx
  80220e:	83 ec 18             	sub    $0x18,%esp
  802211:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802214:	57                   	push   %edi
  802215:	e8 3b f0 ff ff       	call   801255 <fd2data>
  80221a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80221c:	83 c4 10             	add    $0x10,%esp
  80221f:	be 00 00 00 00       	mov    $0x0,%esi
  802224:	3b 75 10             	cmp    0x10(%ebp),%esi
  802227:	75 14                	jne    80223d <devpipe_read+0x39>
	return i;
  802229:	8b 45 10             	mov    0x10(%ebp),%eax
  80222c:	eb 02                	jmp    802230 <devpipe_read+0x2c>
				return i;
  80222e:	89 f0                	mov    %esi,%eax
}
  802230:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802233:	5b                   	pop    %ebx
  802234:	5e                   	pop    %esi
  802235:	5f                   	pop    %edi
  802236:	5d                   	pop    %ebp
  802237:	c3                   	ret    
			sys_yield();
  802238:	e8 d7 ea ff ff       	call   800d14 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80223d:	8b 03                	mov    (%ebx),%eax
  80223f:	3b 43 04             	cmp    0x4(%ebx),%eax
  802242:	75 18                	jne    80225c <devpipe_read+0x58>
			if (i > 0)
  802244:	85 f6                	test   %esi,%esi
  802246:	75 e6                	jne    80222e <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  802248:	89 da                	mov    %ebx,%edx
  80224a:	89 f8                	mov    %edi,%eax
  80224c:	e8 c8 fe ff ff       	call   802119 <_pipeisclosed>
  802251:	85 c0                	test   %eax,%eax
  802253:	74 e3                	je     802238 <devpipe_read+0x34>
				return 0;
  802255:	b8 00 00 00 00       	mov    $0x0,%eax
  80225a:	eb d4                	jmp    802230 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80225c:	99                   	cltd   
  80225d:	c1 ea 1b             	shr    $0x1b,%edx
  802260:	01 d0                	add    %edx,%eax
  802262:	83 e0 1f             	and    $0x1f,%eax
  802265:	29 d0                	sub    %edx,%eax
  802267:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80226c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80226f:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802272:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802275:	83 c6 01             	add    $0x1,%esi
  802278:	eb aa                	jmp    802224 <devpipe_read+0x20>

0080227a <pipe>:
{
  80227a:	f3 0f 1e fb          	endbr32 
  80227e:	55                   	push   %ebp
  80227f:	89 e5                	mov    %esp,%ebp
  802281:	56                   	push   %esi
  802282:	53                   	push   %ebx
  802283:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802286:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802289:	50                   	push   %eax
  80228a:	e8 e1 ef ff ff       	call   801270 <fd_alloc>
  80228f:	89 c3                	mov    %eax,%ebx
  802291:	83 c4 10             	add    $0x10,%esp
  802294:	85 c0                	test   %eax,%eax
  802296:	0f 88 23 01 00 00    	js     8023bf <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80229c:	83 ec 04             	sub    $0x4,%esp
  80229f:	68 07 04 00 00       	push   $0x407
  8022a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8022a7:	6a 00                	push   $0x0
  8022a9:	e8 89 ea ff ff       	call   800d37 <sys_page_alloc>
  8022ae:	89 c3                	mov    %eax,%ebx
  8022b0:	83 c4 10             	add    $0x10,%esp
  8022b3:	85 c0                	test   %eax,%eax
  8022b5:	0f 88 04 01 00 00    	js     8023bf <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  8022bb:	83 ec 0c             	sub    $0xc,%esp
  8022be:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8022c1:	50                   	push   %eax
  8022c2:	e8 a9 ef ff ff       	call   801270 <fd_alloc>
  8022c7:	89 c3                	mov    %eax,%ebx
  8022c9:	83 c4 10             	add    $0x10,%esp
  8022cc:	85 c0                	test   %eax,%eax
  8022ce:	0f 88 db 00 00 00    	js     8023af <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022d4:	83 ec 04             	sub    $0x4,%esp
  8022d7:	68 07 04 00 00       	push   $0x407
  8022dc:	ff 75 f0             	pushl  -0x10(%ebp)
  8022df:	6a 00                	push   $0x0
  8022e1:	e8 51 ea ff ff       	call   800d37 <sys_page_alloc>
  8022e6:	89 c3                	mov    %eax,%ebx
  8022e8:	83 c4 10             	add    $0x10,%esp
  8022eb:	85 c0                	test   %eax,%eax
  8022ed:	0f 88 bc 00 00 00    	js     8023af <pipe+0x135>
	va = fd2data(fd0);
  8022f3:	83 ec 0c             	sub    $0xc,%esp
  8022f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8022f9:	e8 57 ef ff ff       	call   801255 <fd2data>
  8022fe:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802300:	83 c4 0c             	add    $0xc,%esp
  802303:	68 07 04 00 00       	push   $0x407
  802308:	50                   	push   %eax
  802309:	6a 00                	push   $0x0
  80230b:	e8 27 ea ff ff       	call   800d37 <sys_page_alloc>
  802310:	89 c3                	mov    %eax,%ebx
  802312:	83 c4 10             	add    $0x10,%esp
  802315:	85 c0                	test   %eax,%eax
  802317:	0f 88 82 00 00 00    	js     80239f <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80231d:	83 ec 0c             	sub    $0xc,%esp
  802320:	ff 75 f0             	pushl  -0x10(%ebp)
  802323:	e8 2d ef ff ff       	call   801255 <fd2data>
  802328:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80232f:	50                   	push   %eax
  802330:	6a 00                	push   $0x0
  802332:	56                   	push   %esi
  802333:	6a 00                	push   $0x0
  802335:	e8 44 ea ff ff       	call   800d7e <sys_page_map>
  80233a:	89 c3                	mov    %eax,%ebx
  80233c:	83 c4 20             	add    $0x20,%esp
  80233f:	85 c0                	test   %eax,%eax
  802341:	78 4e                	js     802391 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  802343:	a1 28 40 80 00       	mov    0x804028,%eax
  802348:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80234b:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80234d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802350:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802357:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80235a:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80235c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80235f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802366:	83 ec 0c             	sub    $0xc,%esp
  802369:	ff 75 f4             	pushl  -0xc(%ebp)
  80236c:	e8 d0 ee ff ff       	call   801241 <fd2num>
  802371:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802374:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802376:	83 c4 04             	add    $0x4,%esp
  802379:	ff 75 f0             	pushl  -0x10(%ebp)
  80237c:	e8 c0 ee ff ff       	call   801241 <fd2num>
  802381:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802384:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802387:	83 c4 10             	add    $0x10,%esp
  80238a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80238f:	eb 2e                	jmp    8023bf <pipe+0x145>
	sys_page_unmap(0, va);
  802391:	83 ec 08             	sub    $0x8,%esp
  802394:	56                   	push   %esi
  802395:	6a 00                	push   $0x0
  802397:	e8 28 ea ff ff       	call   800dc4 <sys_page_unmap>
  80239c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80239f:	83 ec 08             	sub    $0x8,%esp
  8023a2:	ff 75 f0             	pushl  -0x10(%ebp)
  8023a5:	6a 00                	push   $0x0
  8023a7:	e8 18 ea ff ff       	call   800dc4 <sys_page_unmap>
  8023ac:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8023af:	83 ec 08             	sub    $0x8,%esp
  8023b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8023b5:	6a 00                	push   $0x0
  8023b7:	e8 08 ea ff ff       	call   800dc4 <sys_page_unmap>
  8023bc:	83 c4 10             	add    $0x10,%esp
}
  8023bf:	89 d8                	mov    %ebx,%eax
  8023c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023c4:	5b                   	pop    %ebx
  8023c5:	5e                   	pop    %esi
  8023c6:	5d                   	pop    %ebp
  8023c7:	c3                   	ret    

008023c8 <pipeisclosed>:
{
  8023c8:	f3 0f 1e fb          	endbr32 
  8023cc:	55                   	push   %ebp
  8023cd:	89 e5                	mov    %esp,%ebp
  8023cf:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023d5:	50                   	push   %eax
  8023d6:	ff 75 08             	pushl  0x8(%ebp)
  8023d9:	e8 e8 ee ff ff       	call   8012c6 <fd_lookup>
  8023de:	83 c4 10             	add    $0x10,%esp
  8023e1:	85 c0                	test   %eax,%eax
  8023e3:	78 18                	js     8023fd <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  8023e5:	83 ec 0c             	sub    $0xc,%esp
  8023e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8023eb:	e8 65 ee ff ff       	call   801255 <fd2data>
  8023f0:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  8023f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f5:	e8 1f fd ff ff       	call   802119 <_pipeisclosed>
  8023fa:	83 c4 10             	add    $0x10,%esp
}
  8023fd:	c9                   	leave  
  8023fe:	c3                   	ret    

008023ff <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8023ff:	f3 0f 1e fb          	endbr32 
  802403:	55                   	push   %ebp
  802404:	89 e5                	mov    %esp,%ebp
  802406:	56                   	push   %esi
  802407:	53                   	push   %ebx
  802408:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  80240b:	85 f6                	test   %esi,%esi
  80240d:	74 13                	je     802422 <wait+0x23>
	e = &envs[ENVX(envid)];
  80240f:	89 f3                	mov    %esi,%ebx
  802411:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802417:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  80241a:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802420:	eb 1b                	jmp    80243d <wait+0x3e>
	assert(envid != 0);
  802422:	68 29 30 80 00       	push   $0x803029
  802427:	68 5b 2f 80 00       	push   $0x802f5b
  80242c:	6a 09                	push   $0x9
  80242e:	68 34 30 80 00       	push   $0x803034
  802433:	e8 cc dd ff ff       	call   800204 <_panic>
		sys_yield();
  802438:	e8 d7 e8 ff ff       	call   800d14 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80243d:	8b 43 48             	mov    0x48(%ebx),%eax
  802440:	39 f0                	cmp    %esi,%eax
  802442:	75 07                	jne    80244b <wait+0x4c>
  802444:	8b 43 54             	mov    0x54(%ebx),%eax
  802447:	85 c0                	test   %eax,%eax
  802449:	75 ed                	jne    802438 <wait+0x39>
}
  80244b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80244e:	5b                   	pop    %ebx
  80244f:	5e                   	pop    %esi
  802450:	5d                   	pop    %ebp
  802451:	c3                   	ret    

00802452 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802452:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  802456:	b8 00 00 00 00       	mov    $0x0,%eax
  80245b:	c3                   	ret    

0080245c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80245c:	f3 0f 1e fb          	endbr32 
  802460:	55                   	push   %ebp
  802461:	89 e5                	mov    %esp,%ebp
  802463:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802466:	68 3f 30 80 00       	push   $0x80303f
  80246b:	ff 75 0c             	pushl  0xc(%ebp)
  80246e:	e8 82 e4 ff ff       	call   8008f5 <strcpy>
	return 0;
}
  802473:	b8 00 00 00 00       	mov    $0x0,%eax
  802478:	c9                   	leave  
  802479:	c3                   	ret    

0080247a <devcons_write>:
{
  80247a:	f3 0f 1e fb          	endbr32 
  80247e:	55                   	push   %ebp
  80247f:	89 e5                	mov    %esp,%ebp
  802481:	57                   	push   %edi
  802482:	56                   	push   %esi
  802483:	53                   	push   %ebx
  802484:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80248a:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80248f:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802495:	3b 75 10             	cmp    0x10(%ebp),%esi
  802498:	73 31                	jae    8024cb <devcons_write+0x51>
		m = n - tot;
  80249a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80249d:	29 f3                	sub    %esi,%ebx
  80249f:	83 fb 7f             	cmp    $0x7f,%ebx
  8024a2:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8024a7:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8024aa:	83 ec 04             	sub    $0x4,%esp
  8024ad:	53                   	push   %ebx
  8024ae:	89 f0                	mov    %esi,%eax
  8024b0:	03 45 0c             	add    0xc(%ebp),%eax
  8024b3:	50                   	push   %eax
  8024b4:	57                   	push   %edi
  8024b5:	e8 f1 e5 ff ff       	call   800aab <memmove>
		sys_cputs(buf, m);
  8024ba:	83 c4 08             	add    $0x8,%esp
  8024bd:	53                   	push   %ebx
  8024be:	57                   	push   %edi
  8024bf:	e8 a3 e7 ff ff       	call   800c67 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8024c4:	01 de                	add    %ebx,%esi
  8024c6:	83 c4 10             	add    $0x10,%esp
  8024c9:	eb ca                	jmp    802495 <devcons_write+0x1b>
}
  8024cb:	89 f0                	mov    %esi,%eax
  8024cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024d0:	5b                   	pop    %ebx
  8024d1:	5e                   	pop    %esi
  8024d2:	5f                   	pop    %edi
  8024d3:	5d                   	pop    %ebp
  8024d4:	c3                   	ret    

008024d5 <devcons_read>:
{
  8024d5:	f3 0f 1e fb          	endbr32 
  8024d9:	55                   	push   %ebp
  8024da:	89 e5                	mov    %esp,%ebp
  8024dc:	83 ec 08             	sub    $0x8,%esp
  8024df:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8024e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8024e8:	74 21                	je     80250b <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8024ea:	e8 9a e7 ff ff       	call   800c89 <sys_cgetc>
  8024ef:	85 c0                	test   %eax,%eax
  8024f1:	75 07                	jne    8024fa <devcons_read+0x25>
		sys_yield();
  8024f3:	e8 1c e8 ff ff       	call   800d14 <sys_yield>
  8024f8:	eb f0                	jmp    8024ea <devcons_read+0x15>
	if (c < 0)
  8024fa:	78 0f                	js     80250b <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8024fc:	83 f8 04             	cmp    $0x4,%eax
  8024ff:	74 0c                	je     80250d <devcons_read+0x38>
	*(char*)vbuf = c;
  802501:	8b 55 0c             	mov    0xc(%ebp),%edx
  802504:	88 02                	mov    %al,(%edx)
	return 1;
  802506:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80250b:	c9                   	leave  
  80250c:	c3                   	ret    
		return 0;
  80250d:	b8 00 00 00 00       	mov    $0x0,%eax
  802512:	eb f7                	jmp    80250b <devcons_read+0x36>

00802514 <cputchar>:
{
  802514:	f3 0f 1e fb          	endbr32 
  802518:	55                   	push   %ebp
  802519:	89 e5                	mov    %esp,%ebp
  80251b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80251e:	8b 45 08             	mov    0x8(%ebp),%eax
  802521:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802524:	6a 01                	push   $0x1
  802526:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802529:	50                   	push   %eax
  80252a:	e8 38 e7 ff ff       	call   800c67 <sys_cputs>
}
  80252f:	83 c4 10             	add    $0x10,%esp
  802532:	c9                   	leave  
  802533:	c3                   	ret    

00802534 <getchar>:
{
  802534:	f3 0f 1e fb          	endbr32 
  802538:	55                   	push   %ebp
  802539:	89 e5                	mov    %esp,%ebp
  80253b:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80253e:	6a 01                	push   $0x1
  802540:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802543:	50                   	push   %eax
  802544:	6a 00                	push   $0x0
  802546:	e8 fe ef ff ff       	call   801549 <read>
	if (r < 0)
  80254b:	83 c4 10             	add    $0x10,%esp
  80254e:	85 c0                	test   %eax,%eax
  802550:	78 06                	js     802558 <getchar+0x24>
	if (r < 1)
  802552:	74 06                	je     80255a <getchar+0x26>
	return c;
  802554:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802558:	c9                   	leave  
  802559:	c3                   	ret    
		return -E_EOF;
  80255a:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80255f:	eb f7                	jmp    802558 <getchar+0x24>

00802561 <iscons>:
{
  802561:	f3 0f 1e fb          	endbr32 
  802565:	55                   	push   %ebp
  802566:	89 e5                	mov    %esp,%ebp
  802568:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80256b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80256e:	50                   	push   %eax
  80256f:	ff 75 08             	pushl  0x8(%ebp)
  802572:	e8 4f ed ff ff       	call   8012c6 <fd_lookup>
  802577:	83 c4 10             	add    $0x10,%esp
  80257a:	85 c0                	test   %eax,%eax
  80257c:	78 11                	js     80258f <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80257e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802581:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802587:	39 10                	cmp    %edx,(%eax)
  802589:	0f 94 c0             	sete   %al
  80258c:	0f b6 c0             	movzbl %al,%eax
}
  80258f:	c9                   	leave  
  802590:	c3                   	ret    

00802591 <opencons>:
{
  802591:	f3 0f 1e fb          	endbr32 
  802595:	55                   	push   %ebp
  802596:	89 e5                	mov    %esp,%ebp
  802598:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80259b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80259e:	50                   	push   %eax
  80259f:	e8 cc ec ff ff       	call   801270 <fd_alloc>
  8025a4:	83 c4 10             	add    $0x10,%esp
  8025a7:	85 c0                	test   %eax,%eax
  8025a9:	78 3a                	js     8025e5 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8025ab:	83 ec 04             	sub    $0x4,%esp
  8025ae:	68 07 04 00 00       	push   $0x407
  8025b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8025b6:	6a 00                	push   $0x0
  8025b8:	e8 7a e7 ff ff       	call   800d37 <sys_page_alloc>
  8025bd:	83 c4 10             	add    $0x10,%esp
  8025c0:	85 c0                	test   %eax,%eax
  8025c2:	78 21                	js     8025e5 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8025c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c7:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8025cd:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8025cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8025d9:	83 ec 0c             	sub    $0xc,%esp
  8025dc:	50                   	push   %eax
  8025dd:	e8 5f ec ff ff       	call   801241 <fd2num>
  8025e2:	83 c4 10             	add    $0x10,%esp
}
  8025e5:	c9                   	leave  
  8025e6:	c3                   	ret    

008025e7 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8025e7:	f3 0f 1e fb          	endbr32 
  8025eb:	55                   	push   %ebp
  8025ec:	89 e5                	mov    %esp,%ebp
  8025ee:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8025f1:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  8025f8:	74 0a                	je     802604 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8025fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fd:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802602:	c9                   	leave  
  802603:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  802604:	83 ec 04             	sub    $0x4,%esp
  802607:	6a 07                	push   $0x7
  802609:	68 00 f0 bf ee       	push   $0xeebff000
  80260e:	6a 00                	push   $0x0
  802610:	e8 22 e7 ff ff       	call   800d37 <sys_page_alloc>
  802615:	83 c4 10             	add    $0x10,%esp
  802618:	85 c0                	test   %eax,%eax
  80261a:	78 2a                	js     802646 <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  80261c:	83 ec 08             	sub    $0x8,%esp
  80261f:	68 5a 26 80 00       	push   $0x80265a
  802624:	6a 00                	push   $0x0
  802626:	e8 6b e8 ff ff       	call   800e96 <sys_env_set_pgfault_upcall>
  80262b:	83 c4 10             	add    $0x10,%esp
  80262e:	85 c0                	test   %eax,%eax
  802630:	79 c8                	jns    8025fa <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  802632:	83 ec 04             	sub    $0x4,%esp
  802635:	68 78 30 80 00       	push   $0x803078
  80263a:	6a 25                	push   $0x25
  80263c:	68 b0 30 80 00       	push   $0x8030b0
  802641:	e8 be db ff ff       	call   800204 <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  802646:	83 ec 04             	sub    $0x4,%esp
  802649:	68 4c 30 80 00       	push   $0x80304c
  80264e:	6a 22                	push   $0x22
  802650:	68 b0 30 80 00       	push   $0x8030b0
  802655:	e8 aa db ff ff       	call   800204 <_panic>

0080265a <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80265a:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80265b:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  802660:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802662:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  802665:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  802669:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  80266d:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802670:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  802672:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  802676:	83 c4 08             	add    $0x8,%esp
	popal
  802679:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  80267a:	83 c4 04             	add    $0x4,%esp
	popfl
  80267d:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  80267e:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  80267f:	c3                   	ret    

00802680 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802680:	f3 0f 1e fb          	endbr32 
  802684:	55                   	push   %ebp
  802685:	89 e5                	mov    %esp,%ebp
  802687:	56                   	push   %esi
  802688:	53                   	push   %ebx
  802689:	8b 75 08             	mov    0x8(%ebp),%esi
  80268c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80268f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  802692:	85 c0                	test   %eax,%eax
  802694:	74 3d                	je     8026d3 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  802696:	83 ec 0c             	sub    $0xc,%esp
  802699:	50                   	push   %eax
  80269a:	e8 64 e8 ff ff       	call   800f03 <sys_ipc_recv>
  80269f:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  8026a2:	85 f6                	test   %esi,%esi
  8026a4:	74 0b                	je     8026b1 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8026a6:	8b 15 04 50 80 00    	mov    0x805004,%edx
  8026ac:	8b 52 74             	mov    0x74(%edx),%edx
  8026af:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  8026b1:	85 db                	test   %ebx,%ebx
  8026b3:	74 0b                	je     8026c0 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  8026b5:	8b 15 04 50 80 00    	mov    0x805004,%edx
  8026bb:	8b 52 78             	mov    0x78(%edx),%edx
  8026be:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  8026c0:	85 c0                	test   %eax,%eax
  8026c2:	78 21                	js     8026e5 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  8026c4:	a1 04 50 80 00       	mov    0x805004,%eax
  8026c9:	8b 40 70             	mov    0x70(%eax),%eax
}
  8026cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026cf:	5b                   	pop    %ebx
  8026d0:	5e                   	pop    %esi
  8026d1:	5d                   	pop    %ebp
  8026d2:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  8026d3:	83 ec 0c             	sub    $0xc,%esp
  8026d6:	68 00 00 c0 ee       	push   $0xeec00000
  8026db:	e8 23 e8 ff ff       	call   800f03 <sys_ipc_recv>
  8026e0:	83 c4 10             	add    $0x10,%esp
  8026e3:	eb bd                	jmp    8026a2 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  8026e5:	85 f6                	test   %esi,%esi
  8026e7:	74 10                	je     8026f9 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  8026e9:	85 db                	test   %ebx,%ebx
  8026eb:	75 df                	jne    8026cc <ipc_recv+0x4c>
  8026ed:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8026f4:	00 00 00 
  8026f7:	eb d3                	jmp    8026cc <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  8026f9:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802700:	00 00 00 
  802703:	eb e4                	jmp    8026e9 <ipc_recv+0x69>

00802705 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802705:	f3 0f 1e fb          	endbr32 
  802709:	55                   	push   %ebp
  80270a:	89 e5                	mov    %esp,%ebp
  80270c:	57                   	push   %edi
  80270d:	56                   	push   %esi
  80270e:	53                   	push   %ebx
  80270f:	83 ec 0c             	sub    $0xc,%esp
  802712:	8b 7d 08             	mov    0x8(%ebp),%edi
  802715:	8b 75 0c             	mov    0xc(%ebp),%esi
  802718:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  80271b:	85 db                	test   %ebx,%ebx
  80271d:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802722:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  802725:	ff 75 14             	pushl  0x14(%ebp)
  802728:	53                   	push   %ebx
  802729:	56                   	push   %esi
  80272a:	57                   	push   %edi
  80272b:	e8 ac e7 ff ff       	call   800edc <sys_ipc_try_send>
  802730:	83 c4 10             	add    $0x10,%esp
  802733:	85 c0                	test   %eax,%eax
  802735:	79 1e                	jns    802755 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  802737:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80273a:	75 07                	jne    802743 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  80273c:	e8 d3 e5 ff ff       	call   800d14 <sys_yield>
  802741:	eb e2                	jmp    802725 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  802743:	50                   	push   %eax
  802744:	68 be 30 80 00       	push   $0x8030be
  802749:	6a 59                	push   $0x59
  80274b:	68 d9 30 80 00       	push   $0x8030d9
  802750:	e8 af da ff ff       	call   800204 <_panic>
	}
}
  802755:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802758:	5b                   	pop    %ebx
  802759:	5e                   	pop    %esi
  80275a:	5f                   	pop    %edi
  80275b:	5d                   	pop    %ebp
  80275c:	c3                   	ret    

0080275d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80275d:	f3 0f 1e fb          	endbr32 
  802761:	55                   	push   %ebp
  802762:	89 e5                	mov    %esp,%ebp
  802764:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802767:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80276c:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80276f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802775:	8b 52 50             	mov    0x50(%edx),%edx
  802778:	39 ca                	cmp    %ecx,%edx
  80277a:	74 11                	je     80278d <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80277c:	83 c0 01             	add    $0x1,%eax
  80277f:	3d 00 04 00 00       	cmp    $0x400,%eax
  802784:	75 e6                	jne    80276c <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802786:	b8 00 00 00 00       	mov    $0x0,%eax
  80278b:	eb 0b                	jmp    802798 <ipc_find_env+0x3b>
			return envs[i].env_id;
  80278d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802790:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802795:	8b 40 48             	mov    0x48(%eax),%eax
}
  802798:	5d                   	pop    %ebp
  802799:	c3                   	ret    

0080279a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80279a:	f3 0f 1e fb          	endbr32 
  80279e:	55                   	push   %ebp
  80279f:	89 e5                	mov    %esp,%ebp
  8027a1:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8027a4:	89 c2                	mov    %eax,%edx
  8027a6:	c1 ea 16             	shr    $0x16,%edx
  8027a9:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8027b0:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8027b5:	f6 c1 01             	test   $0x1,%cl
  8027b8:	74 1c                	je     8027d6 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8027ba:	c1 e8 0c             	shr    $0xc,%eax
  8027bd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8027c4:	a8 01                	test   $0x1,%al
  8027c6:	74 0e                	je     8027d6 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8027c8:	c1 e8 0c             	shr    $0xc,%eax
  8027cb:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8027d2:	ef 
  8027d3:	0f b7 d2             	movzwl %dx,%edx
}
  8027d6:	89 d0                	mov    %edx,%eax
  8027d8:	5d                   	pop    %ebp
  8027d9:	c3                   	ret    
  8027da:	66 90                	xchg   %ax,%ax
  8027dc:	66 90                	xchg   %ax,%ax
  8027de:	66 90                	xchg   %ax,%ax

008027e0 <__udivdi3>:
  8027e0:	f3 0f 1e fb          	endbr32 
  8027e4:	55                   	push   %ebp
  8027e5:	57                   	push   %edi
  8027e6:	56                   	push   %esi
  8027e7:	53                   	push   %ebx
  8027e8:	83 ec 1c             	sub    $0x1c,%esp
  8027eb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8027ef:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8027f3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8027f7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8027fb:	85 d2                	test   %edx,%edx
  8027fd:	75 19                	jne    802818 <__udivdi3+0x38>
  8027ff:	39 f3                	cmp    %esi,%ebx
  802801:	76 4d                	jbe    802850 <__udivdi3+0x70>
  802803:	31 ff                	xor    %edi,%edi
  802805:	89 e8                	mov    %ebp,%eax
  802807:	89 f2                	mov    %esi,%edx
  802809:	f7 f3                	div    %ebx
  80280b:	89 fa                	mov    %edi,%edx
  80280d:	83 c4 1c             	add    $0x1c,%esp
  802810:	5b                   	pop    %ebx
  802811:	5e                   	pop    %esi
  802812:	5f                   	pop    %edi
  802813:	5d                   	pop    %ebp
  802814:	c3                   	ret    
  802815:	8d 76 00             	lea    0x0(%esi),%esi
  802818:	39 f2                	cmp    %esi,%edx
  80281a:	76 14                	jbe    802830 <__udivdi3+0x50>
  80281c:	31 ff                	xor    %edi,%edi
  80281e:	31 c0                	xor    %eax,%eax
  802820:	89 fa                	mov    %edi,%edx
  802822:	83 c4 1c             	add    $0x1c,%esp
  802825:	5b                   	pop    %ebx
  802826:	5e                   	pop    %esi
  802827:	5f                   	pop    %edi
  802828:	5d                   	pop    %ebp
  802829:	c3                   	ret    
  80282a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802830:	0f bd fa             	bsr    %edx,%edi
  802833:	83 f7 1f             	xor    $0x1f,%edi
  802836:	75 48                	jne    802880 <__udivdi3+0xa0>
  802838:	39 f2                	cmp    %esi,%edx
  80283a:	72 06                	jb     802842 <__udivdi3+0x62>
  80283c:	31 c0                	xor    %eax,%eax
  80283e:	39 eb                	cmp    %ebp,%ebx
  802840:	77 de                	ja     802820 <__udivdi3+0x40>
  802842:	b8 01 00 00 00       	mov    $0x1,%eax
  802847:	eb d7                	jmp    802820 <__udivdi3+0x40>
  802849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802850:	89 d9                	mov    %ebx,%ecx
  802852:	85 db                	test   %ebx,%ebx
  802854:	75 0b                	jne    802861 <__udivdi3+0x81>
  802856:	b8 01 00 00 00       	mov    $0x1,%eax
  80285b:	31 d2                	xor    %edx,%edx
  80285d:	f7 f3                	div    %ebx
  80285f:	89 c1                	mov    %eax,%ecx
  802861:	31 d2                	xor    %edx,%edx
  802863:	89 f0                	mov    %esi,%eax
  802865:	f7 f1                	div    %ecx
  802867:	89 c6                	mov    %eax,%esi
  802869:	89 e8                	mov    %ebp,%eax
  80286b:	89 f7                	mov    %esi,%edi
  80286d:	f7 f1                	div    %ecx
  80286f:	89 fa                	mov    %edi,%edx
  802871:	83 c4 1c             	add    $0x1c,%esp
  802874:	5b                   	pop    %ebx
  802875:	5e                   	pop    %esi
  802876:	5f                   	pop    %edi
  802877:	5d                   	pop    %ebp
  802878:	c3                   	ret    
  802879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802880:	89 f9                	mov    %edi,%ecx
  802882:	b8 20 00 00 00       	mov    $0x20,%eax
  802887:	29 f8                	sub    %edi,%eax
  802889:	d3 e2                	shl    %cl,%edx
  80288b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80288f:	89 c1                	mov    %eax,%ecx
  802891:	89 da                	mov    %ebx,%edx
  802893:	d3 ea                	shr    %cl,%edx
  802895:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802899:	09 d1                	or     %edx,%ecx
  80289b:	89 f2                	mov    %esi,%edx
  80289d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8028a1:	89 f9                	mov    %edi,%ecx
  8028a3:	d3 e3                	shl    %cl,%ebx
  8028a5:	89 c1                	mov    %eax,%ecx
  8028a7:	d3 ea                	shr    %cl,%edx
  8028a9:	89 f9                	mov    %edi,%ecx
  8028ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8028af:	89 eb                	mov    %ebp,%ebx
  8028b1:	d3 e6                	shl    %cl,%esi
  8028b3:	89 c1                	mov    %eax,%ecx
  8028b5:	d3 eb                	shr    %cl,%ebx
  8028b7:	09 de                	or     %ebx,%esi
  8028b9:	89 f0                	mov    %esi,%eax
  8028bb:	f7 74 24 08          	divl   0x8(%esp)
  8028bf:	89 d6                	mov    %edx,%esi
  8028c1:	89 c3                	mov    %eax,%ebx
  8028c3:	f7 64 24 0c          	mull   0xc(%esp)
  8028c7:	39 d6                	cmp    %edx,%esi
  8028c9:	72 15                	jb     8028e0 <__udivdi3+0x100>
  8028cb:	89 f9                	mov    %edi,%ecx
  8028cd:	d3 e5                	shl    %cl,%ebp
  8028cf:	39 c5                	cmp    %eax,%ebp
  8028d1:	73 04                	jae    8028d7 <__udivdi3+0xf7>
  8028d3:	39 d6                	cmp    %edx,%esi
  8028d5:	74 09                	je     8028e0 <__udivdi3+0x100>
  8028d7:	89 d8                	mov    %ebx,%eax
  8028d9:	31 ff                	xor    %edi,%edi
  8028db:	e9 40 ff ff ff       	jmp    802820 <__udivdi3+0x40>
  8028e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8028e3:	31 ff                	xor    %edi,%edi
  8028e5:	e9 36 ff ff ff       	jmp    802820 <__udivdi3+0x40>
  8028ea:	66 90                	xchg   %ax,%ax
  8028ec:	66 90                	xchg   %ax,%ax
  8028ee:	66 90                	xchg   %ax,%ax

008028f0 <__umoddi3>:
  8028f0:	f3 0f 1e fb          	endbr32 
  8028f4:	55                   	push   %ebp
  8028f5:	57                   	push   %edi
  8028f6:	56                   	push   %esi
  8028f7:	53                   	push   %ebx
  8028f8:	83 ec 1c             	sub    $0x1c,%esp
  8028fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8028ff:	8b 74 24 30          	mov    0x30(%esp),%esi
  802903:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802907:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80290b:	85 c0                	test   %eax,%eax
  80290d:	75 19                	jne    802928 <__umoddi3+0x38>
  80290f:	39 df                	cmp    %ebx,%edi
  802911:	76 5d                	jbe    802970 <__umoddi3+0x80>
  802913:	89 f0                	mov    %esi,%eax
  802915:	89 da                	mov    %ebx,%edx
  802917:	f7 f7                	div    %edi
  802919:	89 d0                	mov    %edx,%eax
  80291b:	31 d2                	xor    %edx,%edx
  80291d:	83 c4 1c             	add    $0x1c,%esp
  802920:	5b                   	pop    %ebx
  802921:	5e                   	pop    %esi
  802922:	5f                   	pop    %edi
  802923:	5d                   	pop    %ebp
  802924:	c3                   	ret    
  802925:	8d 76 00             	lea    0x0(%esi),%esi
  802928:	89 f2                	mov    %esi,%edx
  80292a:	39 d8                	cmp    %ebx,%eax
  80292c:	76 12                	jbe    802940 <__umoddi3+0x50>
  80292e:	89 f0                	mov    %esi,%eax
  802930:	89 da                	mov    %ebx,%edx
  802932:	83 c4 1c             	add    $0x1c,%esp
  802935:	5b                   	pop    %ebx
  802936:	5e                   	pop    %esi
  802937:	5f                   	pop    %edi
  802938:	5d                   	pop    %ebp
  802939:	c3                   	ret    
  80293a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802940:	0f bd e8             	bsr    %eax,%ebp
  802943:	83 f5 1f             	xor    $0x1f,%ebp
  802946:	75 50                	jne    802998 <__umoddi3+0xa8>
  802948:	39 d8                	cmp    %ebx,%eax
  80294a:	0f 82 e0 00 00 00    	jb     802a30 <__umoddi3+0x140>
  802950:	89 d9                	mov    %ebx,%ecx
  802952:	39 f7                	cmp    %esi,%edi
  802954:	0f 86 d6 00 00 00    	jbe    802a30 <__umoddi3+0x140>
  80295a:	89 d0                	mov    %edx,%eax
  80295c:	89 ca                	mov    %ecx,%edx
  80295e:	83 c4 1c             	add    $0x1c,%esp
  802961:	5b                   	pop    %ebx
  802962:	5e                   	pop    %esi
  802963:	5f                   	pop    %edi
  802964:	5d                   	pop    %ebp
  802965:	c3                   	ret    
  802966:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80296d:	8d 76 00             	lea    0x0(%esi),%esi
  802970:	89 fd                	mov    %edi,%ebp
  802972:	85 ff                	test   %edi,%edi
  802974:	75 0b                	jne    802981 <__umoddi3+0x91>
  802976:	b8 01 00 00 00       	mov    $0x1,%eax
  80297b:	31 d2                	xor    %edx,%edx
  80297d:	f7 f7                	div    %edi
  80297f:	89 c5                	mov    %eax,%ebp
  802981:	89 d8                	mov    %ebx,%eax
  802983:	31 d2                	xor    %edx,%edx
  802985:	f7 f5                	div    %ebp
  802987:	89 f0                	mov    %esi,%eax
  802989:	f7 f5                	div    %ebp
  80298b:	89 d0                	mov    %edx,%eax
  80298d:	31 d2                	xor    %edx,%edx
  80298f:	eb 8c                	jmp    80291d <__umoddi3+0x2d>
  802991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802998:	89 e9                	mov    %ebp,%ecx
  80299a:	ba 20 00 00 00       	mov    $0x20,%edx
  80299f:	29 ea                	sub    %ebp,%edx
  8029a1:	d3 e0                	shl    %cl,%eax
  8029a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8029a7:	89 d1                	mov    %edx,%ecx
  8029a9:	89 f8                	mov    %edi,%eax
  8029ab:	d3 e8                	shr    %cl,%eax
  8029ad:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8029b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8029b5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8029b9:	09 c1                	or     %eax,%ecx
  8029bb:	89 d8                	mov    %ebx,%eax
  8029bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8029c1:	89 e9                	mov    %ebp,%ecx
  8029c3:	d3 e7                	shl    %cl,%edi
  8029c5:	89 d1                	mov    %edx,%ecx
  8029c7:	d3 e8                	shr    %cl,%eax
  8029c9:	89 e9                	mov    %ebp,%ecx
  8029cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8029cf:	d3 e3                	shl    %cl,%ebx
  8029d1:	89 c7                	mov    %eax,%edi
  8029d3:	89 d1                	mov    %edx,%ecx
  8029d5:	89 f0                	mov    %esi,%eax
  8029d7:	d3 e8                	shr    %cl,%eax
  8029d9:	89 e9                	mov    %ebp,%ecx
  8029db:	89 fa                	mov    %edi,%edx
  8029dd:	d3 e6                	shl    %cl,%esi
  8029df:	09 d8                	or     %ebx,%eax
  8029e1:	f7 74 24 08          	divl   0x8(%esp)
  8029e5:	89 d1                	mov    %edx,%ecx
  8029e7:	89 f3                	mov    %esi,%ebx
  8029e9:	f7 64 24 0c          	mull   0xc(%esp)
  8029ed:	89 c6                	mov    %eax,%esi
  8029ef:	89 d7                	mov    %edx,%edi
  8029f1:	39 d1                	cmp    %edx,%ecx
  8029f3:	72 06                	jb     8029fb <__umoddi3+0x10b>
  8029f5:	75 10                	jne    802a07 <__umoddi3+0x117>
  8029f7:	39 c3                	cmp    %eax,%ebx
  8029f9:	73 0c                	jae    802a07 <__umoddi3+0x117>
  8029fb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8029ff:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802a03:	89 d7                	mov    %edx,%edi
  802a05:	89 c6                	mov    %eax,%esi
  802a07:	89 ca                	mov    %ecx,%edx
  802a09:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802a0e:	29 f3                	sub    %esi,%ebx
  802a10:	19 fa                	sbb    %edi,%edx
  802a12:	89 d0                	mov    %edx,%eax
  802a14:	d3 e0                	shl    %cl,%eax
  802a16:	89 e9                	mov    %ebp,%ecx
  802a18:	d3 eb                	shr    %cl,%ebx
  802a1a:	d3 ea                	shr    %cl,%edx
  802a1c:	09 d8                	or     %ebx,%eax
  802a1e:	83 c4 1c             	add    $0x1c,%esp
  802a21:	5b                   	pop    %ebx
  802a22:	5e                   	pop    %esi
  802a23:	5f                   	pop    %edi
  802a24:	5d                   	pop    %ebp
  802a25:	c3                   	ret    
  802a26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a2d:	8d 76 00             	lea    0x0(%esi),%esi
  802a30:	29 fe                	sub    %edi,%esi
  802a32:	19 c3                	sbb    %eax,%ebx
  802a34:	89 f2                	mov    %esi,%edx
  802a36:	89 d9                	mov    %ebx,%ecx
  802a38:	e9 1d ff ff ff       	jmp    80295a <__umoddi3+0x6a>
