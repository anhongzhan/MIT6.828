
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
  80008b:	e8 47 10 00 00       	call   8010d7 <fork>
  800090:	89 c3                	mov    %eax,%ebx
  800092:	85 c0                	test   %eax,%eax
  800094:	0f 88 be 00 00 00    	js     800158 <umain+0x101>
	if (r == 0) {
  80009a:	0f 84 ca 00 00 00    	je     80016a <umain+0x113>
	wait(r);
  8000a0:	83 ec 0c             	sub    $0xc,%esp
  8000a3:	53                   	push   %ebx
  8000a4:	e8 c2 28 00 00       	call   80296b <wait>
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  8000a9:	83 c4 08             	add    $0x8,%esp
  8000ac:	ff 35 04 40 80 00    	pushl  0x804004
  8000b2:	68 00 00 00 a0       	push   $0xa0000000
  8000b7:	e8 f8 08 00 00       	call   8009b4 <strcmp>
  8000bc:	83 c4 08             	add    $0x8,%esp
  8000bf:	85 c0                	test   %eax,%eax
  8000c1:	b8 c0 2f 80 00       	mov    $0x802fc0,%eax
  8000c6:	ba c6 2f 80 00       	mov    $0x802fc6,%edx
  8000cb:	0f 45 c2             	cmovne %edx,%eax
  8000ce:	50                   	push   %eax
  8000cf:	68 f3 2f 80 00       	push   $0x802ff3
  8000d4:	e8 12 02 00 00       	call   8002eb <cprintf>
	if ((r = spawnl("/testpteshare", "testpteshare", "arg", 0)) < 0)
  8000d9:	6a 00                	push   $0x0
  8000db:	68 0e 30 80 00       	push   $0x80300e
  8000e0:	68 13 30 80 00       	push   $0x803013
  8000e5:	68 12 30 80 00       	push   $0x803012
  8000ea:	e8 ac 1f 00 00       	call   80209b <spawnl>
  8000ef:	83 c4 20             	add    $0x20,%esp
  8000f2:	85 c0                	test   %eax,%eax
  8000f4:	0f 88 90 00 00 00    	js     80018a <umain+0x133>
	wait(r);
  8000fa:	83 ec 0c             	sub    $0xc,%esp
  8000fd:	50                   	push   %eax
  8000fe:	e8 68 28 00 00       	call   80296b <wait>
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  800103:	83 c4 08             	add    $0x8,%esp
  800106:	ff 35 00 40 80 00    	pushl  0x804000
  80010c:	68 00 00 00 a0       	push   $0xa0000000
  800111:	e8 9e 08 00 00       	call   8009b4 <strcmp>
  800116:	83 c4 08             	add    $0x8,%esp
  800119:	85 c0                	test   %eax,%eax
  80011b:	b8 c0 2f 80 00       	mov    $0x802fc0,%eax
  800120:	ba c6 2f 80 00       	mov    $0x802fc6,%edx
  800125:	0f 45 c2             	cmovne %edx,%eax
  800128:	50                   	push   %eax
  800129:	68 2a 30 80 00       	push   $0x80302a
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
  800147:	68 cc 2f 80 00       	push   $0x802fcc
  80014c:	6a 13                	push   $0x13
  80014e:	68 df 2f 80 00       	push   $0x802fdf
  800153:	e8 ac 00 00 00       	call   800204 <_panic>
		panic("fork: %e", r);
  800158:	50                   	push   %eax
  800159:	68 05 34 80 00       	push   $0x803405
  80015e:	6a 17                	push   $0x17
  800160:	68 df 2f 80 00       	push   $0x802fdf
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
  80018b:	68 20 30 80 00       	push   $0x803020
  800190:	6a 21                	push   $0x21
  800192:	68 df 2f 80 00       	push   $0x802fdf
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
  8001bd:	a3 08 50 80 00       	mov    %eax,0x805008

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
  8001f0:	e8 ef 12 00 00       	call   8014e4 <close_all>
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
  800226:	68 70 30 80 00       	push   $0x803070
  80022b:	e8 bb 00 00 00       	call   8002eb <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800230:	83 c4 18             	add    $0x18,%esp
  800233:	53                   	push   %ebx
  800234:	ff 75 10             	pushl  0x10(%ebp)
  800237:	e8 5a 00 00 00       	call   800296 <vcprintf>
	cprintf("\n");
  80023c:	c7 04 24 93 36 80 00 	movl   $0x803693,(%esp)
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
  800351:	e8 fa 29 00 00       	call   802d50 <__udivdi3>
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
  80038f:	e8 cc 2a 00 00       	call   802e60 <__umoddi3>
  800394:	83 c4 14             	add    $0x14,%esp
  800397:	0f be 80 93 30 80 00 	movsbl 0x803093(%eax),%eax
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
  80043e:	3e ff 24 85 e0 31 80 	notrack jmp *0x8031e0(,%eax,4)
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
  80050b:	8b 14 85 40 33 80 00 	mov    0x803340(,%eax,4),%edx
  800512:	85 d2                	test   %edx,%edx
  800514:	74 18                	je     80052e <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800516:	52                   	push   %edx
  800517:	68 f1 34 80 00       	push   $0x8034f1
  80051c:	53                   	push   %ebx
  80051d:	56                   	push   %esi
  80051e:	e8 aa fe ff ff       	call   8003cd <printfmt>
  800523:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800526:	89 7d 14             	mov    %edi,0x14(%ebp)
  800529:	e9 66 02 00 00       	jmp    800794 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80052e:	50                   	push   %eax
  80052f:	68 ab 30 80 00       	push   $0x8030ab
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
  800556:	b8 a4 30 80 00       	mov    $0x8030a4,%eax
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
  800ce0:	68 9f 33 80 00       	push   $0x80339f
  800ce5:	6a 23                	push   $0x23
  800ce7:	68 bc 33 80 00       	push   $0x8033bc
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
  800d6d:	68 9f 33 80 00       	push   $0x80339f
  800d72:	6a 23                	push   $0x23
  800d74:	68 bc 33 80 00       	push   $0x8033bc
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
  800db3:	68 9f 33 80 00       	push   $0x80339f
  800db8:	6a 23                	push   $0x23
  800dba:	68 bc 33 80 00       	push   $0x8033bc
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
  800df9:	68 9f 33 80 00       	push   $0x80339f
  800dfe:	6a 23                	push   $0x23
  800e00:	68 bc 33 80 00       	push   $0x8033bc
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
  800e3f:	68 9f 33 80 00       	push   $0x80339f
  800e44:	6a 23                	push   $0x23
  800e46:	68 bc 33 80 00       	push   $0x8033bc
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
  800e85:	68 9f 33 80 00       	push   $0x80339f
  800e8a:	6a 23                	push   $0x23
  800e8c:	68 bc 33 80 00       	push   $0x8033bc
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
  800ecb:	68 9f 33 80 00       	push   $0x80339f
  800ed0:	6a 23                	push   $0x23
  800ed2:	68 bc 33 80 00       	push   $0x8033bc
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
  800f37:	68 9f 33 80 00       	push   $0x80339f
  800f3c:	6a 23                	push   $0x23
  800f3e:	68 bc 33 80 00       	push   $0x8033bc
  800f43:	e8 bc f2 ff ff       	call   800204 <_panic>

00800f48 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f48:	f3 0f 1e fb          	endbr32 
  800f4c:	55                   	push   %ebp
  800f4d:	89 e5                	mov    %esp,%ebp
  800f4f:	57                   	push   %edi
  800f50:	56                   	push   %esi
  800f51:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f52:	ba 00 00 00 00       	mov    $0x0,%edx
  800f57:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f5c:	89 d1                	mov    %edx,%ecx
  800f5e:	89 d3                	mov    %edx,%ebx
  800f60:	89 d7                	mov    %edx,%edi
  800f62:	89 d6                	mov    %edx,%esi
  800f64:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f66:	5b                   	pop    %ebx
  800f67:	5e                   	pop    %esi
  800f68:	5f                   	pop    %edi
  800f69:	5d                   	pop    %ebp
  800f6a:	c3                   	ret    

00800f6b <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  800f6b:	f3 0f 1e fb          	endbr32 
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	57                   	push   %edi
  800f73:	56                   	push   %esi
  800f74:	53                   	push   %ebx
  800f75:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f78:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f83:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f88:	89 df                	mov    %ebx,%edi
  800f8a:	89 de                	mov    %ebx,%esi
  800f8c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f8e:	85 c0                	test   %eax,%eax
  800f90:	7f 08                	jg     800f9a <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  800f92:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f95:	5b                   	pop    %ebx
  800f96:	5e                   	pop    %esi
  800f97:	5f                   	pop    %edi
  800f98:	5d                   	pop    %ebp
  800f99:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f9a:	83 ec 0c             	sub    $0xc,%esp
  800f9d:	50                   	push   %eax
  800f9e:	6a 0f                	push   $0xf
  800fa0:	68 9f 33 80 00       	push   $0x80339f
  800fa5:	6a 23                	push   $0x23
  800fa7:	68 bc 33 80 00       	push   $0x8033bc
  800fac:	e8 53 f2 ff ff       	call   800204 <_panic>

00800fb1 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  800fb1:	f3 0f 1e fb          	endbr32 
  800fb5:	55                   	push   %ebp
  800fb6:	89 e5                	mov    %esp,%ebp
  800fb8:	57                   	push   %edi
  800fb9:	56                   	push   %esi
  800fba:	53                   	push   %ebx
  800fbb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fbe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc9:	b8 10 00 00 00       	mov    $0x10,%eax
  800fce:	89 df                	mov    %ebx,%edi
  800fd0:	89 de                	mov    %ebx,%esi
  800fd2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fd4:	85 c0                	test   %eax,%eax
  800fd6:	7f 08                	jg     800fe0 <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  800fd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fdb:	5b                   	pop    %ebx
  800fdc:	5e                   	pop    %esi
  800fdd:	5f                   	pop    %edi
  800fde:	5d                   	pop    %ebp
  800fdf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe0:	83 ec 0c             	sub    $0xc,%esp
  800fe3:	50                   	push   %eax
  800fe4:	6a 10                	push   $0x10
  800fe6:	68 9f 33 80 00       	push   $0x80339f
  800feb:	6a 23                	push   $0x23
  800fed:	68 bc 33 80 00       	push   $0x8033bc
  800ff2:	e8 0d f2 ff ff       	call   800204 <_panic>

00800ff7 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800ff7:	f3 0f 1e fb          	endbr32 
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	53                   	push   %ebx
  800fff:	83 ec 04             	sub    $0x4,%esp
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  801005:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  801007:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  80100b:	74 74                	je     801081 <pgfault+0x8a>
  80100d:	89 d8                	mov    %ebx,%eax
  80100f:	c1 e8 0c             	shr    $0xc,%eax
  801012:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801019:	f6 c4 08             	test   $0x8,%ah
  80101c:	74 63                	je     801081 <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  80101e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  801024:	83 ec 0c             	sub    $0xc,%esp
  801027:	6a 05                	push   $0x5
  801029:	68 00 f0 7f 00       	push   $0x7ff000
  80102e:	6a 00                	push   $0x0
  801030:	53                   	push   %ebx
  801031:	6a 00                	push   $0x0
  801033:	e8 46 fd ff ff       	call   800d7e <sys_page_map>
  801038:	83 c4 20             	add    $0x20,%esp
  80103b:	85 c0                	test   %eax,%eax
  80103d:	78 59                	js     801098 <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  80103f:	83 ec 04             	sub    $0x4,%esp
  801042:	6a 07                	push   $0x7
  801044:	53                   	push   %ebx
  801045:	6a 00                	push   $0x0
  801047:	e8 eb fc ff ff       	call   800d37 <sys_page_alloc>
  80104c:	83 c4 10             	add    $0x10,%esp
  80104f:	85 c0                	test   %eax,%eax
  801051:	78 5a                	js     8010ad <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  801053:	83 ec 04             	sub    $0x4,%esp
  801056:	68 00 10 00 00       	push   $0x1000
  80105b:	68 00 f0 7f 00       	push   $0x7ff000
  801060:	53                   	push   %ebx
  801061:	e8 45 fa ff ff       	call   800aab <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  801066:	83 c4 08             	add    $0x8,%esp
  801069:	68 00 f0 7f 00       	push   $0x7ff000
  80106e:	6a 00                	push   $0x0
  801070:	e8 4f fd ff ff       	call   800dc4 <sys_page_unmap>
  801075:	83 c4 10             	add    $0x10,%esp
  801078:	85 c0                	test   %eax,%eax
  80107a:	78 46                	js     8010c2 <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  80107c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80107f:	c9                   	leave  
  801080:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  801081:	83 ec 04             	sub    $0x4,%esp
  801084:	68 ca 33 80 00       	push   $0x8033ca
  801089:	68 d3 00 00 00       	push   $0xd3
  80108e:	68 e6 33 80 00       	push   $0x8033e6
  801093:	e8 6c f1 ff ff       	call   800204 <_panic>
		panic("pgfault: %e\n", r);
  801098:	50                   	push   %eax
  801099:	68 f1 33 80 00       	push   $0x8033f1
  80109e:	68 df 00 00 00       	push   $0xdf
  8010a3:	68 e6 33 80 00       	push   $0x8033e6
  8010a8:	e8 57 f1 ff ff       	call   800204 <_panic>
		panic("pgfault: %e\n", r);
  8010ad:	50                   	push   %eax
  8010ae:	68 f1 33 80 00       	push   $0x8033f1
  8010b3:	68 e3 00 00 00       	push   $0xe3
  8010b8:	68 e6 33 80 00       	push   $0x8033e6
  8010bd:	e8 42 f1 ff ff       	call   800204 <_panic>
		panic("pgfault: %e\n", r);
  8010c2:	50                   	push   %eax
  8010c3:	68 f1 33 80 00       	push   $0x8033f1
  8010c8:	68 e9 00 00 00       	push   $0xe9
  8010cd:	68 e6 33 80 00       	push   $0x8033e6
  8010d2:	e8 2d f1 ff ff       	call   800204 <_panic>

008010d7 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8010d7:	f3 0f 1e fb          	endbr32 
  8010db:	55                   	push   %ebp
  8010dc:	89 e5                	mov    %esp,%ebp
  8010de:	57                   	push   %edi
  8010df:	56                   	push   %esi
  8010e0:	53                   	push   %ebx
  8010e1:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  8010e4:	68 f7 0f 80 00       	push   $0x800ff7
  8010e9:	e8 65 1a 00 00       	call   802b53 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8010ee:	b8 07 00 00 00       	mov    $0x7,%eax
  8010f3:	cd 30                	int    $0x30
  8010f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  8010f8:	83 c4 10             	add    $0x10,%esp
  8010fb:	85 c0                	test   %eax,%eax
  8010fd:	78 2d                	js     80112c <fork+0x55>
  8010ff:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801101:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  801106:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80110a:	0f 85 9b 00 00 00    	jne    8011ab <fork+0xd4>
		thisenv = &envs[ENVX(sys_getenvid())];
  801110:	e8 dc fb ff ff       	call   800cf1 <sys_getenvid>
  801115:	25 ff 03 00 00       	and    $0x3ff,%eax
  80111a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80111d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801122:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801127:	e9 71 01 00 00       	jmp    80129d <fork+0x1c6>
		panic("sys_exofork: %e", envid);
  80112c:	50                   	push   %eax
  80112d:	68 fe 33 80 00       	push   $0x8033fe
  801132:	68 2a 01 00 00       	push   $0x12a
  801137:	68 e6 33 80 00       	push   $0x8033e6
  80113c:	e8 c3 f0 ff ff       	call   800204 <_panic>
		sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_SYSCALL);
  801141:	c1 e6 0c             	shl    $0xc,%esi
  801144:	83 ec 0c             	sub    $0xc,%esp
  801147:	68 07 0e 00 00       	push   $0xe07
  80114c:	56                   	push   %esi
  80114d:	57                   	push   %edi
  80114e:	56                   	push   %esi
  80114f:	6a 00                	push   $0x0
  801151:	e8 28 fc ff ff       	call   800d7e <sys_page_map>
  801156:	83 c4 20             	add    $0x20,%esp
  801159:	eb 3e                	jmp    801199 <fork+0xc2>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  80115b:	c1 e6 0c             	shl    $0xc,%esi
  80115e:	83 ec 0c             	sub    $0xc,%esp
  801161:	68 05 08 00 00       	push   $0x805
  801166:	56                   	push   %esi
  801167:	57                   	push   %edi
  801168:	56                   	push   %esi
  801169:	6a 00                	push   $0x0
  80116b:	e8 0e fc ff ff       	call   800d7e <sys_page_map>
  801170:	83 c4 20             	add    $0x20,%esp
  801173:	85 c0                	test   %eax,%eax
  801175:	0f 88 bc 00 00 00    	js     801237 <fork+0x160>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  80117b:	83 ec 0c             	sub    $0xc,%esp
  80117e:	68 05 08 00 00       	push   $0x805
  801183:	56                   	push   %esi
  801184:	6a 00                	push   $0x0
  801186:	56                   	push   %esi
  801187:	6a 00                	push   $0x0
  801189:	e8 f0 fb ff ff       	call   800d7e <sys_page_map>
  80118e:	83 c4 20             	add    $0x20,%esp
  801191:	85 c0                	test   %eax,%eax
  801193:	0f 88 b3 00 00 00    	js     80124c <fork+0x175>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801199:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80119f:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8011a5:	0f 84 b6 00 00 00    	je     801261 <fork+0x18a>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  8011ab:	89 d8                	mov    %ebx,%eax
  8011ad:	c1 e8 16             	shr    $0x16,%eax
  8011b0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011b7:	a8 01                	test   $0x1,%al
  8011b9:	74 de                	je     801199 <fork+0xc2>
  8011bb:	89 de                	mov    %ebx,%esi
  8011bd:	c1 ee 0c             	shr    $0xc,%esi
  8011c0:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011c7:	a8 01                	test   $0x1,%al
  8011c9:	74 ce                	je     801199 <fork+0xc2>
  8011cb:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011d2:	a8 04                	test   $0x4,%al
  8011d4:	74 c3                	je     801199 <fork+0xc2>
	if ((uvpt[pn] & PTE_SHARE)){
  8011d6:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011dd:	f6 c4 04             	test   $0x4,%ah
  8011e0:	0f 85 5b ff ff ff    	jne    801141 <fork+0x6a>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  8011e6:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011ed:	a8 02                	test   $0x2,%al
  8011ef:	0f 85 66 ff ff ff    	jne    80115b <fork+0x84>
  8011f5:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011fc:	f6 c4 08             	test   $0x8,%ah
  8011ff:	0f 85 56 ff ff ff    	jne    80115b <fork+0x84>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  801205:	c1 e6 0c             	shl    $0xc,%esi
  801208:	83 ec 0c             	sub    $0xc,%esp
  80120b:	6a 05                	push   $0x5
  80120d:	56                   	push   %esi
  80120e:	57                   	push   %edi
  80120f:	56                   	push   %esi
  801210:	6a 00                	push   $0x0
  801212:	e8 67 fb ff ff       	call   800d7e <sys_page_map>
  801217:	83 c4 20             	add    $0x20,%esp
  80121a:	85 c0                	test   %eax,%eax
  80121c:	0f 89 77 ff ff ff    	jns    801199 <fork+0xc2>
		panic("duppage: %e\n", r);
  801222:	50                   	push   %eax
  801223:	68 0e 34 80 00       	push   $0x80340e
  801228:	68 0c 01 00 00       	push   $0x10c
  80122d:	68 e6 33 80 00       	push   $0x8033e6
  801232:	e8 cd ef ff ff       	call   800204 <_panic>
			panic("duppage: %e\n", r);
  801237:	50                   	push   %eax
  801238:	68 0e 34 80 00       	push   $0x80340e
  80123d:	68 05 01 00 00       	push   $0x105
  801242:	68 e6 33 80 00       	push   $0x8033e6
  801247:	e8 b8 ef ff ff       	call   800204 <_panic>
			panic("duppage: %e\n", r);
  80124c:	50                   	push   %eax
  80124d:	68 0e 34 80 00       	push   $0x80340e
  801252:	68 09 01 00 00       	push   $0x109
  801257:	68 e6 33 80 00       	push   $0x8033e6
  80125c:	e8 a3 ef ff ff       	call   800204 <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  801261:	83 ec 04             	sub    $0x4,%esp
  801264:	6a 07                	push   $0x7
  801266:	68 00 f0 bf ee       	push   $0xeebff000
  80126b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80126e:	e8 c4 fa ff ff       	call   800d37 <sys_page_alloc>
  801273:	83 c4 10             	add    $0x10,%esp
  801276:	85 c0                	test   %eax,%eax
  801278:	78 2e                	js     8012a8 <fork+0x1d1>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  80127a:	83 ec 08             	sub    $0x8,%esp
  80127d:	68 c6 2b 80 00       	push   $0x802bc6
  801282:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801285:	57                   	push   %edi
  801286:	e8 0b fc ff ff       	call   800e96 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80128b:	83 c4 08             	add    $0x8,%esp
  80128e:	6a 02                	push   $0x2
  801290:	57                   	push   %edi
  801291:	e8 74 fb ff ff       	call   800e0a <sys_env_set_status>
  801296:	83 c4 10             	add    $0x10,%esp
  801299:	85 c0                	test   %eax,%eax
  80129b:	78 20                	js     8012bd <fork+0x1e6>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  80129d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012a3:	5b                   	pop    %ebx
  8012a4:	5e                   	pop    %esi
  8012a5:	5f                   	pop    %edi
  8012a6:	5d                   	pop    %ebp
  8012a7:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  8012a8:	50                   	push   %eax
  8012a9:	68 cc 2f 80 00       	push   $0x802fcc
  8012ae:	68 3e 01 00 00       	push   $0x13e
  8012b3:	68 e6 33 80 00       	push   $0x8033e6
  8012b8:	e8 47 ef ff ff       	call   800204 <_panic>
		panic("sys_env_set_status: %e", r);
  8012bd:	50                   	push   %eax
  8012be:	68 1b 34 80 00       	push   $0x80341b
  8012c3:	68 43 01 00 00       	push   $0x143
  8012c8:	68 e6 33 80 00       	push   $0x8033e6
  8012cd:	e8 32 ef ff ff       	call   800204 <_panic>

008012d2 <sfork>:

// Challenge!
int
sfork(void)
{
  8012d2:	f3 0f 1e fb          	endbr32 
  8012d6:	55                   	push   %ebp
  8012d7:	89 e5                	mov    %esp,%ebp
  8012d9:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8012dc:	68 32 34 80 00       	push   $0x803432
  8012e1:	68 4c 01 00 00       	push   $0x14c
  8012e6:	68 e6 33 80 00       	push   $0x8033e6
  8012eb:	e8 14 ef ff ff       	call   800204 <_panic>

008012f0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012f0:	f3 0f 1e fb          	endbr32 
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fa:	05 00 00 00 30       	add    $0x30000000,%eax
  8012ff:	c1 e8 0c             	shr    $0xc,%eax
}
  801302:	5d                   	pop    %ebp
  801303:	c3                   	ret    

00801304 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801304:	f3 0f 1e fb          	endbr32 
  801308:	55                   	push   %ebp
  801309:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80130b:	8b 45 08             	mov    0x8(%ebp),%eax
  80130e:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801313:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801318:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80131d:	5d                   	pop    %ebp
  80131e:	c3                   	ret    

0080131f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80131f:	f3 0f 1e fb          	endbr32 
  801323:	55                   	push   %ebp
  801324:	89 e5                	mov    %esp,%ebp
  801326:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80132b:	89 c2                	mov    %eax,%edx
  80132d:	c1 ea 16             	shr    $0x16,%edx
  801330:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801337:	f6 c2 01             	test   $0x1,%dl
  80133a:	74 2d                	je     801369 <fd_alloc+0x4a>
  80133c:	89 c2                	mov    %eax,%edx
  80133e:	c1 ea 0c             	shr    $0xc,%edx
  801341:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801348:	f6 c2 01             	test   $0x1,%dl
  80134b:	74 1c                	je     801369 <fd_alloc+0x4a>
  80134d:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801352:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801357:	75 d2                	jne    80132b <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801362:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801367:	eb 0a                	jmp    801373 <fd_alloc+0x54>
			*fd_store = fd;
  801369:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80136c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80136e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801373:	5d                   	pop    %ebp
  801374:	c3                   	ret    

00801375 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801375:	f3 0f 1e fb          	endbr32 
  801379:	55                   	push   %ebp
  80137a:	89 e5                	mov    %esp,%ebp
  80137c:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80137f:	83 f8 1f             	cmp    $0x1f,%eax
  801382:	77 30                	ja     8013b4 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801384:	c1 e0 0c             	shl    $0xc,%eax
  801387:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80138c:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801392:	f6 c2 01             	test   $0x1,%dl
  801395:	74 24                	je     8013bb <fd_lookup+0x46>
  801397:	89 c2                	mov    %eax,%edx
  801399:	c1 ea 0c             	shr    $0xc,%edx
  80139c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013a3:	f6 c2 01             	test   $0x1,%dl
  8013a6:	74 1a                	je     8013c2 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8013a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ab:	89 02                	mov    %eax,(%edx)
	return 0;
  8013ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013b2:	5d                   	pop    %ebp
  8013b3:	c3                   	ret    
		return -E_INVAL;
  8013b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013b9:	eb f7                	jmp    8013b2 <fd_lookup+0x3d>
		return -E_INVAL;
  8013bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013c0:	eb f0                	jmp    8013b2 <fd_lookup+0x3d>
  8013c2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013c7:	eb e9                	jmp    8013b2 <fd_lookup+0x3d>

008013c9 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013c9:	f3 0f 1e fb          	endbr32 
  8013cd:	55                   	push   %ebp
  8013ce:	89 e5                	mov    %esp,%ebp
  8013d0:	83 ec 08             	sub    $0x8,%esp
  8013d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8013d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8013db:	b8 0c 40 80 00       	mov    $0x80400c,%eax
		if (devtab[i]->dev_id == dev_id) {
  8013e0:	39 08                	cmp    %ecx,(%eax)
  8013e2:	74 38                	je     80141c <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  8013e4:	83 c2 01             	add    $0x1,%edx
  8013e7:	8b 04 95 c4 34 80 00 	mov    0x8034c4(,%edx,4),%eax
  8013ee:	85 c0                	test   %eax,%eax
  8013f0:	75 ee                	jne    8013e0 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8013f2:	a1 08 50 80 00       	mov    0x805008,%eax
  8013f7:	8b 40 48             	mov    0x48(%eax),%eax
  8013fa:	83 ec 04             	sub    $0x4,%esp
  8013fd:	51                   	push   %ecx
  8013fe:	50                   	push   %eax
  8013ff:	68 48 34 80 00       	push   $0x803448
  801404:	e8 e2 ee ff ff       	call   8002eb <cprintf>
	*dev = 0;
  801409:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801412:	83 c4 10             	add    $0x10,%esp
  801415:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80141a:	c9                   	leave  
  80141b:	c3                   	ret    
			*dev = devtab[i];
  80141c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80141f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801421:	b8 00 00 00 00       	mov    $0x0,%eax
  801426:	eb f2                	jmp    80141a <dev_lookup+0x51>

00801428 <fd_close>:
{
  801428:	f3 0f 1e fb          	endbr32 
  80142c:	55                   	push   %ebp
  80142d:	89 e5                	mov    %esp,%ebp
  80142f:	57                   	push   %edi
  801430:	56                   	push   %esi
  801431:	53                   	push   %ebx
  801432:	83 ec 24             	sub    $0x24,%esp
  801435:	8b 75 08             	mov    0x8(%ebp),%esi
  801438:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80143b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80143e:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80143f:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801445:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801448:	50                   	push   %eax
  801449:	e8 27 ff ff ff       	call   801375 <fd_lookup>
  80144e:	89 c3                	mov    %eax,%ebx
  801450:	83 c4 10             	add    $0x10,%esp
  801453:	85 c0                	test   %eax,%eax
  801455:	78 05                	js     80145c <fd_close+0x34>
	    || fd != fd2)
  801457:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80145a:	74 16                	je     801472 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80145c:	89 f8                	mov    %edi,%eax
  80145e:	84 c0                	test   %al,%al
  801460:	b8 00 00 00 00       	mov    $0x0,%eax
  801465:	0f 44 d8             	cmove  %eax,%ebx
}
  801468:	89 d8                	mov    %ebx,%eax
  80146a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80146d:	5b                   	pop    %ebx
  80146e:	5e                   	pop    %esi
  80146f:	5f                   	pop    %edi
  801470:	5d                   	pop    %ebp
  801471:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801472:	83 ec 08             	sub    $0x8,%esp
  801475:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801478:	50                   	push   %eax
  801479:	ff 36                	pushl  (%esi)
  80147b:	e8 49 ff ff ff       	call   8013c9 <dev_lookup>
  801480:	89 c3                	mov    %eax,%ebx
  801482:	83 c4 10             	add    $0x10,%esp
  801485:	85 c0                	test   %eax,%eax
  801487:	78 1a                	js     8014a3 <fd_close+0x7b>
		if (dev->dev_close)
  801489:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80148c:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80148f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801494:	85 c0                	test   %eax,%eax
  801496:	74 0b                	je     8014a3 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801498:	83 ec 0c             	sub    $0xc,%esp
  80149b:	56                   	push   %esi
  80149c:	ff d0                	call   *%eax
  80149e:	89 c3                	mov    %eax,%ebx
  8014a0:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8014a3:	83 ec 08             	sub    $0x8,%esp
  8014a6:	56                   	push   %esi
  8014a7:	6a 00                	push   $0x0
  8014a9:	e8 16 f9 ff ff       	call   800dc4 <sys_page_unmap>
	return r;
  8014ae:	83 c4 10             	add    $0x10,%esp
  8014b1:	eb b5                	jmp    801468 <fd_close+0x40>

008014b3 <close>:

int
close(int fdnum)
{
  8014b3:	f3 0f 1e fb          	endbr32 
  8014b7:	55                   	push   %ebp
  8014b8:	89 e5                	mov    %esp,%ebp
  8014ba:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014c0:	50                   	push   %eax
  8014c1:	ff 75 08             	pushl  0x8(%ebp)
  8014c4:	e8 ac fe ff ff       	call   801375 <fd_lookup>
  8014c9:	83 c4 10             	add    $0x10,%esp
  8014cc:	85 c0                	test   %eax,%eax
  8014ce:	79 02                	jns    8014d2 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8014d0:	c9                   	leave  
  8014d1:	c3                   	ret    
		return fd_close(fd, 1);
  8014d2:	83 ec 08             	sub    $0x8,%esp
  8014d5:	6a 01                	push   $0x1
  8014d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8014da:	e8 49 ff ff ff       	call   801428 <fd_close>
  8014df:	83 c4 10             	add    $0x10,%esp
  8014e2:	eb ec                	jmp    8014d0 <close+0x1d>

008014e4 <close_all>:

void
close_all(void)
{
  8014e4:	f3 0f 1e fb          	endbr32 
  8014e8:	55                   	push   %ebp
  8014e9:	89 e5                	mov    %esp,%ebp
  8014eb:	53                   	push   %ebx
  8014ec:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8014ef:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8014f4:	83 ec 0c             	sub    $0xc,%esp
  8014f7:	53                   	push   %ebx
  8014f8:	e8 b6 ff ff ff       	call   8014b3 <close>
	for (i = 0; i < MAXFD; i++)
  8014fd:	83 c3 01             	add    $0x1,%ebx
  801500:	83 c4 10             	add    $0x10,%esp
  801503:	83 fb 20             	cmp    $0x20,%ebx
  801506:	75 ec                	jne    8014f4 <close_all+0x10>
}
  801508:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80150b:	c9                   	leave  
  80150c:	c3                   	ret    

0080150d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80150d:	f3 0f 1e fb          	endbr32 
  801511:	55                   	push   %ebp
  801512:	89 e5                	mov    %esp,%ebp
  801514:	57                   	push   %edi
  801515:	56                   	push   %esi
  801516:	53                   	push   %ebx
  801517:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80151a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80151d:	50                   	push   %eax
  80151e:	ff 75 08             	pushl  0x8(%ebp)
  801521:	e8 4f fe ff ff       	call   801375 <fd_lookup>
  801526:	89 c3                	mov    %eax,%ebx
  801528:	83 c4 10             	add    $0x10,%esp
  80152b:	85 c0                	test   %eax,%eax
  80152d:	0f 88 81 00 00 00    	js     8015b4 <dup+0xa7>
		return r;
	close(newfdnum);
  801533:	83 ec 0c             	sub    $0xc,%esp
  801536:	ff 75 0c             	pushl  0xc(%ebp)
  801539:	e8 75 ff ff ff       	call   8014b3 <close>

	newfd = INDEX2FD(newfdnum);
  80153e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801541:	c1 e6 0c             	shl    $0xc,%esi
  801544:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80154a:	83 c4 04             	add    $0x4,%esp
  80154d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801550:	e8 af fd ff ff       	call   801304 <fd2data>
  801555:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801557:	89 34 24             	mov    %esi,(%esp)
  80155a:	e8 a5 fd ff ff       	call   801304 <fd2data>
  80155f:	83 c4 10             	add    $0x10,%esp
  801562:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801564:	89 d8                	mov    %ebx,%eax
  801566:	c1 e8 16             	shr    $0x16,%eax
  801569:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801570:	a8 01                	test   $0x1,%al
  801572:	74 11                	je     801585 <dup+0x78>
  801574:	89 d8                	mov    %ebx,%eax
  801576:	c1 e8 0c             	shr    $0xc,%eax
  801579:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801580:	f6 c2 01             	test   $0x1,%dl
  801583:	75 39                	jne    8015be <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801585:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801588:	89 d0                	mov    %edx,%eax
  80158a:	c1 e8 0c             	shr    $0xc,%eax
  80158d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801594:	83 ec 0c             	sub    $0xc,%esp
  801597:	25 07 0e 00 00       	and    $0xe07,%eax
  80159c:	50                   	push   %eax
  80159d:	56                   	push   %esi
  80159e:	6a 00                	push   $0x0
  8015a0:	52                   	push   %edx
  8015a1:	6a 00                	push   $0x0
  8015a3:	e8 d6 f7 ff ff       	call   800d7e <sys_page_map>
  8015a8:	89 c3                	mov    %eax,%ebx
  8015aa:	83 c4 20             	add    $0x20,%esp
  8015ad:	85 c0                	test   %eax,%eax
  8015af:	78 31                	js     8015e2 <dup+0xd5>
		goto err;

	return newfdnum;
  8015b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8015b4:	89 d8                	mov    %ebx,%eax
  8015b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015b9:	5b                   	pop    %ebx
  8015ba:	5e                   	pop    %esi
  8015bb:	5f                   	pop    %edi
  8015bc:	5d                   	pop    %ebp
  8015bd:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015be:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015c5:	83 ec 0c             	sub    $0xc,%esp
  8015c8:	25 07 0e 00 00       	and    $0xe07,%eax
  8015cd:	50                   	push   %eax
  8015ce:	57                   	push   %edi
  8015cf:	6a 00                	push   $0x0
  8015d1:	53                   	push   %ebx
  8015d2:	6a 00                	push   $0x0
  8015d4:	e8 a5 f7 ff ff       	call   800d7e <sys_page_map>
  8015d9:	89 c3                	mov    %eax,%ebx
  8015db:	83 c4 20             	add    $0x20,%esp
  8015de:	85 c0                	test   %eax,%eax
  8015e0:	79 a3                	jns    801585 <dup+0x78>
	sys_page_unmap(0, newfd);
  8015e2:	83 ec 08             	sub    $0x8,%esp
  8015e5:	56                   	push   %esi
  8015e6:	6a 00                	push   $0x0
  8015e8:	e8 d7 f7 ff ff       	call   800dc4 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8015ed:	83 c4 08             	add    $0x8,%esp
  8015f0:	57                   	push   %edi
  8015f1:	6a 00                	push   $0x0
  8015f3:	e8 cc f7 ff ff       	call   800dc4 <sys_page_unmap>
	return r;
  8015f8:	83 c4 10             	add    $0x10,%esp
  8015fb:	eb b7                	jmp    8015b4 <dup+0xa7>

008015fd <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015fd:	f3 0f 1e fb          	endbr32 
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
  801604:	53                   	push   %ebx
  801605:	83 ec 1c             	sub    $0x1c,%esp
  801608:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80160b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80160e:	50                   	push   %eax
  80160f:	53                   	push   %ebx
  801610:	e8 60 fd ff ff       	call   801375 <fd_lookup>
  801615:	83 c4 10             	add    $0x10,%esp
  801618:	85 c0                	test   %eax,%eax
  80161a:	78 3f                	js     80165b <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80161c:	83 ec 08             	sub    $0x8,%esp
  80161f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801622:	50                   	push   %eax
  801623:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801626:	ff 30                	pushl  (%eax)
  801628:	e8 9c fd ff ff       	call   8013c9 <dev_lookup>
  80162d:	83 c4 10             	add    $0x10,%esp
  801630:	85 c0                	test   %eax,%eax
  801632:	78 27                	js     80165b <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801634:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801637:	8b 42 08             	mov    0x8(%edx),%eax
  80163a:	83 e0 03             	and    $0x3,%eax
  80163d:	83 f8 01             	cmp    $0x1,%eax
  801640:	74 1e                	je     801660 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801645:	8b 40 08             	mov    0x8(%eax),%eax
  801648:	85 c0                	test   %eax,%eax
  80164a:	74 35                	je     801681 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80164c:	83 ec 04             	sub    $0x4,%esp
  80164f:	ff 75 10             	pushl  0x10(%ebp)
  801652:	ff 75 0c             	pushl  0xc(%ebp)
  801655:	52                   	push   %edx
  801656:	ff d0                	call   *%eax
  801658:	83 c4 10             	add    $0x10,%esp
}
  80165b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80165e:	c9                   	leave  
  80165f:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801660:	a1 08 50 80 00       	mov    0x805008,%eax
  801665:	8b 40 48             	mov    0x48(%eax),%eax
  801668:	83 ec 04             	sub    $0x4,%esp
  80166b:	53                   	push   %ebx
  80166c:	50                   	push   %eax
  80166d:	68 89 34 80 00       	push   $0x803489
  801672:	e8 74 ec ff ff       	call   8002eb <cprintf>
		return -E_INVAL;
  801677:	83 c4 10             	add    $0x10,%esp
  80167a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80167f:	eb da                	jmp    80165b <read+0x5e>
		return -E_NOT_SUPP;
  801681:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801686:	eb d3                	jmp    80165b <read+0x5e>

00801688 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801688:	f3 0f 1e fb          	endbr32 
  80168c:	55                   	push   %ebp
  80168d:	89 e5                	mov    %esp,%ebp
  80168f:	57                   	push   %edi
  801690:	56                   	push   %esi
  801691:	53                   	push   %ebx
  801692:	83 ec 0c             	sub    $0xc,%esp
  801695:	8b 7d 08             	mov    0x8(%ebp),%edi
  801698:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80169b:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016a0:	eb 02                	jmp    8016a4 <readn+0x1c>
  8016a2:	01 c3                	add    %eax,%ebx
  8016a4:	39 f3                	cmp    %esi,%ebx
  8016a6:	73 21                	jae    8016c9 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016a8:	83 ec 04             	sub    $0x4,%esp
  8016ab:	89 f0                	mov    %esi,%eax
  8016ad:	29 d8                	sub    %ebx,%eax
  8016af:	50                   	push   %eax
  8016b0:	89 d8                	mov    %ebx,%eax
  8016b2:	03 45 0c             	add    0xc(%ebp),%eax
  8016b5:	50                   	push   %eax
  8016b6:	57                   	push   %edi
  8016b7:	e8 41 ff ff ff       	call   8015fd <read>
		if (m < 0)
  8016bc:	83 c4 10             	add    $0x10,%esp
  8016bf:	85 c0                	test   %eax,%eax
  8016c1:	78 04                	js     8016c7 <readn+0x3f>
			return m;
		if (m == 0)
  8016c3:	75 dd                	jne    8016a2 <readn+0x1a>
  8016c5:	eb 02                	jmp    8016c9 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016c7:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8016c9:	89 d8                	mov    %ebx,%eax
  8016cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016ce:	5b                   	pop    %ebx
  8016cf:	5e                   	pop    %esi
  8016d0:	5f                   	pop    %edi
  8016d1:	5d                   	pop    %ebp
  8016d2:	c3                   	ret    

008016d3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016d3:	f3 0f 1e fb          	endbr32 
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
  8016da:	53                   	push   %ebx
  8016db:	83 ec 1c             	sub    $0x1c,%esp
  8016de:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016e1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016e4:	50                   	push   %eax
  8016e5:	53                   	push   %ebx
  8016e6:	e8 8a fc ff ff       	call   801375 <fd_lookup>
  8016eb:	83 c4 10             	add    $0x10,%esp
  8016ee:	85 c0                	test   %eax,%eax
  8016f0:	78 3a                	js     80172c <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016f2:	83 ec 08             	sub    $0x8,%esp
  8016f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016f8:	50                   	push   %eax
  8016f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016fc:	ff 30                	pushl  (%eax)
  8016fe:	e8 c6 fc ff ff       	call   8013c9 <dev_lookup>
  801703:	83 c4 10             	add    $0x10,%esp
  801706:	85 c0                	test   %eax,%eax
  801708:	78 22                	js     80172c <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80170a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80170d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801711:	74 1e                	je     801731 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801713:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801716:	8b 52 0c             	mov    0xc(%edx),%edx
  801719:	85 d2                	test   %edx,%edx
  80171b:	74 35                	je     801752 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80171d:	83 ec 04             	sub    $0x4,%esp
  801720:	ff 75 10             	pushl  0x10(%ebp)
  801723:	ff 75 0c             	pushl  0xc(%ebp)
  801726:	50                   	push   %eax
  801727:	ff d2                	call   *%edx
  801729:	83 c4 10             	add    $0x10,%esp
}
  80172c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80172f:	c9                   	leave  
  801730:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801731:	a1 08 50 80 00       	mov    0x805008,%eax
  801736:	8b 40 48             	mov    0x48(%eax),%eax
  801739:	83 ec 04             	sub    $0x4,%esp
  80173c:	53                   	push   %ebx
  80173d:	50                   	push   %eax
  80173e:	68 a5 34 80 00       	push   $0x8034a5
  801743:	e8 a3 eb ff ff       	call   8002eb <cprintf>
		return -E_INVAL;
  801748:	83 c4 10             	add    $0x10,%esp
  80174b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801750:	eb da                	jmp    80172c <write+0x59>
		return -E_NOT_SUPP;
  801752:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801757:	eb d3                	jmp    80172c <write+0x59>

00801759 <seek>:

int
seek(int fdnum, off_t offset)
{
  801759:	f3 0f 1e fb          	endbr32 
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
  801760:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801763:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801766:	50                   	push   %eax
  801767:	ff 75 08             	pushl  0x8(%ebp)
  80176a:	e8 06 fc ff ff       	call   801375 <fd_lookup>
  80176f:	83 c4 10             	add    $0x10,%esp
  801772:	85 c0                	test   %eax,%eax
  801774:	78 0e                	js     801784 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801776:	8b 55 0c             	mov    0xc(%ebp),%edx
  801779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80177c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80177f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801784:	c9                   	leave  
  801785:	c3                   	ret    

00801786 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801786:	f3 0f 1e fb          	endbr32 
  80178a:	55                   	push   %ebp
  80178b:	89 e5                	mov    %esp,%ebp
  80178d:	53                   	push   %ebx
  80178e:	83 ec 1c             	sub    $0x1c,%esp
  801791:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801794:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801797:	50                   	push   %eax
  801798:	53                   	push   %ebx
  801799:	e8 d7 fb ff ff       	call   801375 <fd_lookup>
  80179e:	83 c4 10             	add    $0x10,%esp
  8017a1:	85 c0                	test   %eax,%eax
  8017a3:	78 37                	js     8017dc <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017a5:	83 ec 08             	sub    $0x8,%esp
  8017a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ab:	50                   	push   %eax
  8017ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017af:	ff 30                	pushl  (%eax)
  8017b1:	e8 13 fc ff ff       	call   8013c9 <dev_lookup>
  8017b6:	83 c4 10             	add    $0x10,%esp
  8017b9:	85 c0                	test   %eax,%eax
  8017bb:	78 1f                	js     8017dc <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017c4:	74 1b                	je     8017e1 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8017c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c9:	8b 52 18             	mov    0x18(%edx),%edx
  8017cc:	85 d2                	test   %edx,%edx
  8017ce:	74 32                	je     801802 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017d0:	83 ec 08             	sub    $0x8,%esp
  8017d3:	ff 75 0c             	pushl  0xc(%ebp)
  8017d6:	50                   	push   %eax
  8017d7:	ff d2                	call   *%edx
  8017d9:	83 c4 10             	add    $0x10,%esp
}
  8017dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017df:	c9                   	leave  
  8017e0:	c3                   	ret    
			thisenv->env_id, fdnum);
  8017e1:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8017e6:	8b 40 48             	mov    0x48(%eax),%eax
  8017e9:	83 ec 04             	sub    $0x4,%esp
  8017ec:	53                   	push   %ebx
  8017ed:	50                   	push   %eax
  8017ee:	68 68 34 80 00       	push   $0x803468
  8017f3:	e8 f3 ea ff ff       	call   8002eb <cprintf>
		return -E_INVAL;
  8017f8:	83 c4 10             	add    $0x10,%esp
  8017fb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801800:	eb da                	jmp    8017dc <ftruncate+0x56>
		return -E_NOT_SUPP;
  801802:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801807:	eb d3                	jmp    8017dc <ftruncate+0x56>

00801809 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801809:	f3 0f 1e fb          	endbr32 
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
  801810:	53                   	push   %ebx
  801811:	83 ec 1c             	sub    $0x1c,%esp
  801814:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801817:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80181a:	50                   	push   %eax
  80181b:	ff 75 08             	pushl  0x8(%ebp)
  80181e:	e8 52 fb ff ff       	call   801375 <fd_lookup>
  801823:	83 c4 10             	add    $0x10,%esp
  801826:	85 c0                	test   %eax,%eax
  801828:	78 4b                	js     801875 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80182a:	83 ec 08             	sub    $0x8,%esp
  80182d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801830:	50                   	push   %eax
  801831:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801834:	ff 30                	pushl  (%eax)
  801836:	e8 8e fb ff ff       	call   8013c9 <dev_lookup>
  80183b:	83 c4 10             	add    $0x10,%esp
  80183e:	85 c0                	test   %eax,%eax
  801840:	78 33                	js     801875 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801845:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801849:	74 2f                	je     80187a <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80184b:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80184e:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801855:	00 00 00 
	stat->st_isdir = 0;
  801858:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80185f:	00 00 00 
	stat->st_dev = dev;
  801862:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801868:	83 ec 08             	sub    $0x8,%esp
  80186b:	53                   	push   %ebx
  80186c:	ff 75 f0             	pushl  -0x10(%ebp)
  80186f:	ff 50 14             	call   *0x14(%eax)
  801872:	83 c4 10             	add    $0x10,%esp
}
  801875:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801878:	c9                   	leave  
  801879:	c3                   	ret    
		return -E_NOT_SUPP;
  80187a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80187f:	eb f4                	jmp    801875 <fstat+0x6c>

00801881 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801881:	f3 0f 1e fb          	endbr32 
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
  801888:	56                   	push   %esi
  801889:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80188a:	83 ec 08             	sub    $0x8,%esp
  80188d:	6a 00                	push   $0x0
  80188f:	ff 75 08             	pushl  0x8(%ebp)
  801892:	e8 fb 01 00 00       	call   801a92 <open>
  801897:	89 c3                	mov    %eax,%ebx
  801899:	83 c4 10             	add    $0x10,%esp
  80189c:	85 c0                	test   %eax,%eax
  80189e:	78 1b                	js     8018bb <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8018a0:	83 ec 08             	sub    $0x8,%esp
  8018a3:	ff 75 0c             	pushl  0xc(%ebp)
  8018a6:	50                   	push   %eax
  8018a7:	e8 5d ff ff ff       	call   801809 <fstat>
  8018ac:	89 c6                	mov    %eax,%esi
	close(fd);
  8018ae:	89 1c 24             	mov    %ebx,(%esp)
  8018b1:	e8 fd fb ff ff       	call   8014b3 <close>
	return r;
  8018b6:	83 c4 10             	add    $0x10,%esp
  8018b9:	89 f3                	mov    %esi,%ebx
}
  8018bb:	89 d8                	mov    %ebx,%eax
  8018bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018c0:	5b                   	pop    %ebx
  8018c1:	5e                   	pop    %esi
  8018c2:	5d                   	pop    %ebp
  8018c3:	c3                   	ret    

008018c4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
  8018c7:	56                   	push   %esi
  8018c8:	53                   	push   %ebx
  8018c9:	89 c6                	mov    %eax,%esi
  8018cb:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8018cd:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8018d4:	74 27                	je     8018fd <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018d6:	6a 07                	push   $0x7
  8018d8:	68 00 60 80 00       	push   $0x806000
  8018dd:	56                   	push   %esi
  8018de:	ff 35 00 50 80 00    	pushl  0x805000
  8018e4:	e8 88 13 00 00       	call   802c71 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8018e9:	83 c4 0c             	add    $0xc,%esp
  8018ec:	6a 00                	push   $0x0
  8018ee:	53                   	push   %ebx
  8018ef:	6a 00                	push   $0x0
  8018f1:	e8 f6 12 00 00       	call   802bec <ipc_recv>
}
  8018f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018f9:	5b                   	pop    %ebx
  8018fa:	5e                   	pop    %esi
  8018fb:	5d                   	pop    %ebp
  8018fc:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8018fd:	83 ec 0c             	sub    $0xc,%esp
  801900:	6a 01                	push   $0x1
  801902:	e8 c2 13 00 00       	call   802cc9 <ipc_find_env>
  801907:	a3 00 50 80 00       	mov    %eax,0x805000
  80190c:	83 c4 10             	add    $0x10,%esp
  80190f:	eb c5                	jmp    8018d6 <fsipc+0x12>

00801911 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801911:	f3 0f 1e fb          	endbr32 
  801915:	55                   	push   %ebp
  801916:	89 e5                	mov    %esp,%ebp
  801918:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80191b:	8b 45 08             	mov    0x8(%ebp),%eax
  80191e:	8b 40 0c             	mov    0xc(%eax),%eax
  801921:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801926:	8b 45 0c             	mov    0xc(%ebp),%eax
  801929:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80192e:	ba 00 00 00 00       	mov    $0x0,%edx
  801933:	b8 02 00 00 00       	mov    $0x2,%eax
  801938:	e8 87 ff ff ff       	call   8018c4 <fsipc>
}
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    

0080193f <devfile_flush>:
{
  80193f:	f3 0f 1e fb          	endbr32 
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
  801946:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801949:	8b 45 08             	mov    0x8(%ebp),%eax
  80194c:	8b 40 0c             	mov    0xc(%eax),%eax
  80194f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801954:	ba 00 00 00 00       	mov    $0x0,%edx
  801959:	b8 06 00 00 00       	mov    $0x6,%eax
  80195e:	e8 61 ff ff ff       	call   8018c4 <fsipc>
}
  801963:	c9                   	leave  
  801964:	c3                   	ret    

00801965 <devfile_stat>:
{
  801965:	f3 0f 1e fb          	endbr32 
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
  80196c:	53                   	push   %ebx
  80196d:	83 ec 04             	sub    $0x4,%esp
  801970:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801973:	8b 45 08             	mov    0x8(%ebp),%eax
  801976:	8b 40 0c             	mov    0xc(%eax),%eax
  801979:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80197e:	ba 00 00 00 00       	mov    $0x0,%edx
  801983:	b8 05 00 00 00       	mov    $0x5,%eax
  801988:	e8 37 ff ff ff       	call   8018c4 <fsipc>
  80198d:	85 c0                	test   %eax,%eax
  80198f:	78 2c                	js     8019bd <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801991:	83 ec 08             	sub    $0x8,%esp
  801994:	68 00 60 80 00       	push   $0x806000
  801999:	53                   	push   %ebx
  80199a:	e8 56 ef ff ff       	call   8008f5 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80199f:	a1 80 60 80 00       	mov    0x806080,%eax
  8019a4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019aa:	a1 84 60 80 00       	mov    0x806084,%eax
  8019af:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8019b5:	83 c4 10             	add    $0x10,%esp
  8019b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019c0:	c9                   	leave  
  8019c1:	c3                   	ret    

008019c2 <devfile_write>:
{
  8019c2:	f3 0f 1e fb          	endbr32 
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
  8019c9:	83 ec 0c             	sub    $0xc,%esp
  8019cc:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8019d2:	8b 52 0c             	mov    0xc(%edx),%edx
  8019d5:	89 15 00 60 80 00    	mov    %edx,0x806000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  8019db:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8019e0:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8019e5:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  8019e8:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, n);
  8019ed:	50                   	push   %eax
  8019ee:	ff 75 0c             	pushl  0xc(%ebp)
  8019f1:	68 08 60 80 00       	push   $0x806008
  8019f6:	e8 b0 f0 ff ff       	call   800aab <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  8019fb:	ba 00 00 00 00       	mov    $0x0,%edx
  801a00:	b8 04 00 00 00       	mov    $0x4,%eax
  801a05:	e8 ba fe ff ff       	call   8018c4 <fsipc>
}
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    

00801a0c <devfile_read>:
{
  801a0c:	f3 0f 1e fb          	endbr32 
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
  801a13:	56                   	push   %esi
  801a14:	53                   	push   %ebx
  801a15:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	8b 40 0c             	mov    0xc(%eax),%eax
  801a1e:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801a23:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a29:	ba 00 00 00 00       	mov    $0x0,%edx
  801a2e:	b8 03 00 00 00       	mov    $0x3,%eax
  801a33:	e8 8c fe ff ff       	call   8018c4 <fsipc>
  801a38:	89 c3                	mov    %eax,%ebx
  801a3a:	85 c0                	test   %eax,%eax
  801a3c:	78 1f                	js     801a5d <devfile_read+0x51>
	assert(r <= n);
  801a3e:	39 f0                	cmp    %esi,%eax
  801a40:	77 24                	ja     801a66 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801a42:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a47:	7f 33                	jg     801a7c <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a49:	83 ec 04             	sub    $0x4,%esp
  801a4c:	50                   	push   %eax
  801a4d:	68 00 60 80 00       	push   $0x806000
  801a52:	ff 75 0c             	pushl  0xc(%ebp)
  801a55:	e8 51 f0 ff ff       	call   800aab <memmove>
	return r;
  801a5a:	83 c4 10             	add    $0x10,%esp
}
  801a5d:	89 d8                	mov    %ebx,%eax
  801a5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a62:	5b                   	pop    %ebx
  801a63:	5e                   	pop    %esi
  801a64:	5d                   	pop    %ebp
  801a65:	c3                   	ret    
	assert(r <= n);
  801a66:	68 d8 34 80 00       	push   $0x8034d8
  801a6b:	68 df 34 80 00       	push   $0x8034df
  801a70:	6a 7c                	push   $0x7c
  801a72:	68 f4 34 80 00       	push   $0x8034f4
  801a77:	e8 88 e7 ff ff       	call   800204 <_panic>
	assert(r <= PGSIZE);
  801a7c:	68 ff 34 80 00       	push   $0x8034ff
  801a81:	68 df 34 80 00       	push   $0x8034df
  801a86:	6a 7d                	push   $0x7d
  801a88:	68 f4 34 80 00       	push   $0x8034f4
  801a8d:	e8 72 e7 ff ff       	call   800204 <_panic>

00801a92 <open>:
{
  801a92:	f3 0f 1e fb          	endbr32 
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
  801a99:	56                   	push   %esi
  801a9a:	53                   	push   %ebx
  801a9b:	83 ec 1c             	sub    $0x1c,%esp
  801a9e:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801aa1:	56                   	push   %esi
  801aa2:	e8 0b ee ff ff       	call   8008b2 <strlen>
  801aa7:	83 c4 10             	add    $0x10,%esp
  801aaa:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801aaf:	7f 6c                	jg     801b1d <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801ab1:	83 ec 0c             	sub    $0xc,%esp
  801ab4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ab7:	50                   	push   %eax
  801ab8:	e8 62 f8 ff ff       	call   80131f <fd_alloc>
  801abd:	89 c3                	mov    %eax,%ebx
  801abf:	83 c4 10             	add    $0x10,%esp
  801ac2:	85 c0                	test   %eax,%eax
  801ac4:	78 3c                	js     801b02 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801ac6:	83 ec 08             	sub    $0x8,%esp
  801ac9:	56                   	push   %esi
  801aca:	68 00 60 80 00       	push   $0x806000
  801acf:	e8 21 ee ff ff       	call   8008f5 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801ad4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad7:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801adc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801adf:	b8 01 00 00 00       	mov    $0x1,%eax
  801ae4:	e8 db fd ff ff       	call   8018c4 <fsipc>
  801ae9:	89 c3                	mov    %eax,%ebx
  801aeb:	83 c4 10             	add    $0x10,%esp
  801aee:	85 c0                	test   %eax,%eax
  801af0:	78 19                	js     801b0b <open+0x79>
	return fd2num(fd);
  801af2:	83 ec 0c             	sub    $0xc,%esp
  801af5:	ff 75 f4             	pushl  -0xc(%ebp)
  801af8:	e8 f3 f7 ff ff       	call   8012f0 <fd2num>
  801afd:	89 c3                	mov    %eax,%ebx
  801aff:	83 c4 10             	add    $0x10,%esp
}
  801b02:	89 d8                	mov    %ebx,%eax
  801b04:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b07:	5b                   	pop    %ebx
  801b08:	5e                   	pop    %esi
  801b09:	5d                   	pop    %ebp
  801b0a:	c3                   	ret    
		fd_close(fd, 0);
  801b0b:	83 ec 08             	sub    $0x8,%esp
  801b0e:	6a 00                	push   $0x0
  801b10:	ff 75 f4             	pushl  -0xc(%ebp)
  801b13:	e8 10 f9 ff ff       	call   801428 <fd_close>
		return r;
  801b18:	83 c4 10             	add    $0x10,%esp
  801b1b:	eb e5                	jmp    801b02 <open+0x70>
		return -E_BAD_PATH;
  801b1d:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b22:	eb de                	jmp    801b02 <open+0x70>

00801b24 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b24:	f3 0f 1e fb          	endbr32 
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
  801b2b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b2e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b33:	b8 08 00 00 00       	mov    $0x8,%eax
  801b38:	e8 87 fd ff ff       	call   8018c4 <fsipc>
}
  801b3d:	c9                   	leave  
  801b3e:	c3                   	ret    

00801b3f <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801b3f:	f3 0f 1e fb          	endbr32 
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
  801b46:	57                   	push   %edi
  801b47:	56                   	push   %esi
  801b48:	53                   	push   %ebx
  801b49:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801b4f:	6a 00                	push   $0x0
  801b51:	ff 75 08             	pushl  0x8(%ebp)
  801b54:	e8 39 ff ff ff       	call   801a92 <open>
  801b59:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801b5f:	83 c4 10             	add    $0x10,%esp
  801b62:	85 c0                	test   %eax,%eax
  801b64:	0f 88 e7 04 00 00    	js     802051 <spawn+0x512>
  801b6a:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801b6c:	83 ec 04             	sub    $0x4,%esp
  801b6f:	68 00 02 00 00       	push   $0x200
  801b74:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801b7a:	50                   	push   %eax
  801b7b:	52                   	push   %edx
  801b7c:	e8 07 fb ff ff       	call   801688 <readn>
  801b81:	83 c4 10             	add    $0x10,%esp
  801b84:	3d 00 02 00 00       	cmp    $0x200,%eax
  801b89:	75 7e                	jne    801c09 <spawn+0xca>
	    || elf->e_magic != ELF_MAGIC) {
  801b8b:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801b92:	45 4c 46 
  801b95:	75 72                	jne    801c09 <spawn+0xca>
  801b97:	b8 07 00 00 00       	mov    $0x7,%eax
  801b9c:	cd 30                	int    $0x30
  801b9e:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801ba4:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801baa:	85 c0                	test   %eax,%eax
  801bac:	0f 88 93 04 00 00    	js     802045 <spawn+0x506>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801bb2:	25 ff 03 00 00       	and    $0x3ff,%eax
  801bb7:	6b f0 7c             	imul   $0x7c,%eax,%esi
  801bba:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801bc0:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801bc6:	b9 11 00 00 00       	mov    $0x11,%ecx
  801bcb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801bcd:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801bd3:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801bd9:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801bde:	be 00 00 00 00       	mov    $0x0,%esi
  801be3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801be6:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
	for (argc = 0; argv[argc] != 0; argc++)
  801bed:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801bf0:	85 c0                	test   %eax,%eax
  801bf2:	74 4d                	je     801c41 <spawn+0x102>
		string_size += strlen(argv[argc]) + 1;
  801bf4:	83 ec 0c             	sub    $0xc,%esp
  801bf7:	50                   	push   %eax
  801bf8:	e8 b5 ec ff ff       	call   8008b2 <strlen>
  801bfd:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801c01:	83 c3 01             	add    $0x1,%ebx
  801c04:	83 c4 10             	add    $0x10,%esp
  801c07:	eb dd                	jmp    801be6 <spawn+0xa7>
		close(fd);
  801c09:	83 ec 0c             	sub    $0xc,%esp
  801c0c:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801c12:	e8 9c f8 ff ff       	call   8014b3 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801c17:	83 c4 0c             	add    $0xc,%esp
  801c1a:	68 7f 45 4c 46       	push   $0x464c457f
  801c1f:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801c25:	68 0b 35 80 00       	push   $0x80350b
  801c2a:	e8 bc e6 ff ff       	call   8002eb <cprintf>
		return -E_NOT_EXEC;
  801c2f:	83 c4 10             	add    $0x10,%esp
  801c32:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801c39:	ff ff ff 
  801c3c:	e9 10 04 00 00       	jmp    802051 <spawn+0x512>
  801c41:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801c47:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801c4d:	bf 00 10 40 00       	mov    $0x401000,%edi
  801c52:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801c54:	89 fa                	mov    %edi,%edx
  801c56:	83 e2 fc             	and    $0xfffffffc,%edx
  801c59:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801c60:	29 c2                	sub    %eax,%edx
  801c62:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801c68:	8d 42 f8             	lea    -0x8(%edx),%eax
  801c6b:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801c70:	0f 86 fe 03 00 00    	jbe    802074 <spawn+0x535>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801c76:	83 ec 04             	sub    $0x4,%esp
  801c79:	6a 07                	push   $0x7
  801c7b:	68 00 00 40 00       	push   $0x400000
  801c80:	6a 00                	push   $0x0
  801c82:	e8 b0 f0 ff ff       	call   800d37 <sys_page_alloc>
  801c87:	83 c4 10             	add    $0x10,%esp
  801c8a:	85 c0                	test   %eax,%eax
  801c8c:	0f 88 e7 03 00 00    	js     802079 <spawn+0x53a>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801c92:	be 00 00 00 00       	mov    $0x0,%esi
  801c97:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801c9d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801ca0:	eb 30                	jmp    801cd2 <spawn+0x193>
		argv_store[i] = UTEMP2USTACK(string_store);
  801ca2:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801ca8:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801cae:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801cb1:	83 ec 08             	sub    $0x8,%esp
  801cb4:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801cb7:	57                   	push   %edi
  801cb8:	e8 38 ec ff ff       	call   8008f5 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801cbd:	83 c4 04             	add    $0x4,%esp
  801cc0:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801cc3:	e8 ea eb ff ff       	call   8008b2 <strlen>
  801cc8:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801ccc:	83 c6 01             	add    $0x1,%esi
  801ccf:	83 c4 10             	add    $0x10,%esp
  801cd2:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801cd8:	7f c8                	jg     801ca2 <spawn+0x163>
	}
	argv_store[argc] = 0;
  801cda:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801ce0:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801ce6:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801ced:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801cf3:	0f 85 86 00 00 00    	jne    801d7f <spawn+0x240>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801cf9:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801cff:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  801d05:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801d08:	89 c8                	mov    %ecx,%eax
  801d0a:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  801d10:	89 48 f8             	mov    %ecx,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801d13:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801d18:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801d1e:	83 ec 0c             	sub    $0xc,%esp
  801d21:	6a 07                	push   $0x7
  801d23:	68 00 d0 bf ee       	push   $0xeebfd000
  801d28:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801d2e:	68 00 00 40 00       	push   $0x400000
  801d33:	6a 00                	push   $0x0
  801d35:	e8 44 f0 ff ff       	call   800d7e <sys_page_map>
  801d3a:	89 c3                	mov    %eax,%ebx
  801d3c:	83 c4 20             	add    $0x20,%esp
  801d3f:	85 c0                	test   %eax,%eax
  801d41:	0f 88 3a 03 00 00    	js     802081 <spawn+0x542>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801d47:	83 ec 08             	sub    $0x8,%esp
  801d4a:	68 00 00 40 00       	push   $0x400000
  801d4f:	6a 00                	push   $0x0
  801d51:	e8 6e f0 ff ff       	call   800dc4 <sys_page_unmap>
  801d56:	89 c3                	mov    %eax,%ebx
  801d58:	83 c4 10             	add    $0x10,%esp
  801d5b:	85 c0                	test   %eax,%eax
  801d5d:	0f 88 1e 03 00 00    	js     802081 <spawn+0x542>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801d63:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801d69:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801d70:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  801d77:	00 00 00 
  801d7a:	e9 4f 01 00 00       	jmp    801ece <spawn+0x38f>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801d7f:	68 68 35 80 00       	push   $0x803568
  801d84:	68 df 34 80 00       	push   $0x8034df
  801d89:	68 f2 00 00 00       	push   $0xf2
  801d8e:	68 25 35 80 00       	push   $0x803525
  801d93:	e8 6c e4 ff ff       	call   800204 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801d98:	83 ec 04             	sub    $0x4,%esp
  801d9b:	6a 07                	push   $0x7
  801d9d:	68 00 00 40 00       	push   $0x400000
  801da2:	6a 00                	push   $0x0
  801da4:	e8 8e ef ff ff       	call   800d37 <sys_page_alloc>
  801da9:	83 c4 10             	add    $0x10,%esp
  801dac:	85 c0                	test   %eax,%eax
  801dae:	0f 88 ab 02 00 00    	js     80205f <spawn+0x520>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801db4:	83 ec 08             	sub    $0x8,%esp
  801db7:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801dbd:	01 f0                	add    %esi,%eax
  801dbf:	50                   	push   %eax
  801dc0:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801dc6:	e8 8e f9 ff ff       	call   801759 <seek>
  801dcb:	83 c4 10             	add    $0x10,%esp
  801dce:	85 c0                	test   %eax,%eax
  801dd0:	0f 88 90 02 00 00    	js     802066 <spawn+0x527>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801dd6:	83 ec 04             	sub    $0x4,%esp
  801dd9:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801ddf:	29 f0                	sub    %esi,%eax
  801de1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801de6:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801deb:	0f 47 c1             	cmova  %ecx,%eax
  801dee:	50                   	push   %eax
  801def:	68 00 00 40 00       	push   $0x400000
  801df4:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801dfa:	e8 89 f8 ff ff       	call   801688 <readn>
  801dff:	83 c4 10             	add    $0x10,%esp
  801e02:	85 c0                	test   %eax,%eax
  801e04:	0f 88 63 02 00 00    	js     80206d <spawn+0x52e>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801e0a:	83 ec 0c             	sub    $0xc,%esp
  801e0d:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801e13:	53                   	push   %ebx
  801e14:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801e1a:	68 00 00 40 00       	push   $0x400000
  801e1f:	6a 00                	push   $0x0
  801e21:	e8 58 ef ff ff       	call   800d7e <sys_page_map>
  801e26:	83 c4 20             	add    $0x20,%esp
  801e29:	85 c0                	test   %eax,%eax
  801e2b:	78 7c                	js     801ea9 <spawn+0x36a>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801e2d:	83 ec 08             	sub    $0x8,%esp
  801e30:	68 00 00 40 00       	push   $0x400000
  801e35:	6a 00                	push   $0x0
  801e37:	e8 88 ef ff ff       	call   800dc4 <sys_page_unmap>
  801e3c:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801e3f:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801e45:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801e4b:	89 fe                	mov    %edi,%esi
  801e4d:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801e53:	76 69                	jbe    801ebe <spawn+0x37f>
		if (i >= filesz) {
  801e55:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801e5b:	0f 87 37 ff ff ff    	ja     801d98 <spawn+0x259>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801e61:	83 ec 04             	sub    $0x4,%esp
  801e64:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801e6a:	53                   	push   %ebx
  801e6b:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801e71:	e8 c1 ee ff ff       	call   800d37 <sys_page_alloc>
  801e76:	83 c4 10             	add    $0x10,%esp
  801e79:	85 c0                	test   %eax,%eax
  801e7b:	79 c2                	jns    801e3f <spawn+0x300>
  801e7d:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801e7f:	83 ec 0c             	sub    $0xc,%esp
  801e82:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801e88:	e8 1f ee ff ff       	call   800cac <sys_env_destroy>
	close(fd);
  801e8d:	83 c4 04             	add    $0x4,%esp
  801e90:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801e96:	e8 18 f6 ff ff       	call   8014b3 <close>
	return r;
  801e9b:	83 c4 10             	add    $0x10,%esp
  801e9e:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801ea4:	e9 a8 01 00 00       	jmp    802051 <spawn+0x512>
				panic("spawn: sys_page_map data: %e", r);
  801ea9:	50                   	push   %eax
  801eaa:	68 31 35 80 00       	push   $0x803531
  801eaf:	68 25 01 00 00       	push   $0x125
  801eb4:	68 25 35 80 00       	push   $0x803525
  801eb9:	e8 46 e3 ff ff       	call   800204 <_panic>
  801ebe:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801ec4:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801ecb:	83 c6 20             	add    $0x20,%esi
  801ece:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801ed5:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801edb:	7e 6d                	jle    801f4a <spawn+0x40b>
		if (ph->p_type != ELF_PROG_LOAD)
  801edd:	83 3e 01             	cmpl   $0x1,(%esi)
  801ee0:	75 e2                	jne    801ec4 <spawn+0x385>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801ee2:	8b 46 18             	mov    0x18(%esi),%eax
  801ee5:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801ee8:	83 f8 01             	cmp    $0x1,%eax
  801eeb:	19 c0                	sbb    %eax,%eax
  801eed:	83 e0 fe             	and    $0xfffffffe,%eax
  801ef0:	83 c0 07             	add    $0x7,%eax
  801ef3:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801ef9:	8b 4e 04             	mov    0x4(%esi),%ecx
  801efc:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801f02:	8b 56 10             	mov    0x10(%esi),%edx
  801f05:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801f0b:	8b 7e 14             	mov    0x14(%esi),%edi
  801f0e:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  801f14:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801f17:	89 d8                	mov    %ebx,%eax
  801f19:	25 ff 0f 00 00       	and    $0xfff,%eax
  801f1e:	74 1a                	je     801f3a <spawn+0x3fb>
		va -= i;
  801f20:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801f22:	01 c7                	add    %eax,%edi
  801f24:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801f2a:	01 c2                	add    %eax,%edx
  801f2c:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  801f32:	29 c1                	sub    %eax,%ecx
  801f34:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801f3a:	bf 00 00 00 00       	mov    $0x0,%edi
  801f3f:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801f45:	e9 01 ff ff ff       	jmp    801e4b <spawn+0x30c>
	close(fd);
  801f4a:	83 ec 0c             	sub    $0xc,%esp
  801f4d:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801f53:	e8 5b f5 ff ff       	call   8014b3 <close>
  801f58:	83 c4 10             	add    $0x10,%esp
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	uint32_t addr;
	int r;
	for(addr = 0; addr < USTACKTOP; addr += PGSIZE){
  801f5b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f60:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  801f66:	eb 0e                	jmp    801f76 <spawn+0x437>
  801f68:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801f6e:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801f74:	74 5a                	je     801fd0 <spawn+0x491>
		if((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U) && (uvpt[PGNUM(addr)] & PTE_SHARE)){
  801f76:	89 d8                	mov    %ebx,%eax
  801f78:	c1 e8 16             	shr    $0x16,%eax
  801f7b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801f82:	a8 01                	test   $0x1,%al
  801f84:	74 e2                	je     801f68 <spawn+0x429>
  801f86:	89 d8                	mov    %ebx,%eax
  801f88:	c1 e8 0c             	shr    $0xc,%eax
  801f8b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801f92:	f6 c2 01             	test   $0x1,%dl
  801f95:	74 d1                	je     801f68 <spawn+0x429>
  801f97:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801f9e:	f6 c2 04             	test   $0x4,%dl
  801fa1:	74 c5                	je     801f68 <spawn+0x429>
  801fa3:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801faa:	f6 c6 04             	test   $0x4,%dh
  801fad:	74 b9                	je     801f68 <spawn+0x429>
			if(r = sys_page_map(0, (void*)addr, child, (void*)addr, (uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  801faf:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801fb6:	83 ec 0c             	sub    $0xc,%esp
  801fb9:	25 07 0e 00 00       	and    $0xe07,%eax
  801fbe:	50                   	push   %eax
  801fbf:	53                   	push   %ebx
  801fc0:	56                   	push   %esi
  801fc1:	53                   	push   %ebx
  801fc2:	6a 00                	push   $0x0
  801fc4:	e8 b5 ed ff ff       	call   800d7e <sys_page_map>
  801fc9:	83 c4 20             	add    $0x20,%esp
  801fcc:	85 c0                	test   %eax,%eax
  801fce:	79 98                	jns    801f68 <spawn+0x429>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801fd0:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801fd7:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801fda:	83 ec 08             	sub    $0x8,%esp
  801fdd:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801fe3:	50                   	push   %eax
  801fe4:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801fea:	e8 61 ee ff ff       	call   800e50 <sys_env_set_trapframe>
  801fef:	83 c4 10             	add    $0x10,%esp
  801ff2:	85 c0                	test   %eax,%eax
  801ff4:	78 25                	js     80201b <spawn+0x4dc>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801ff6:	83 ec 08             	sub    $0x8,%esp
  801ff9:	6a 02                	push   $0x2
  801ffb:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802001:	e8 04 ee ff ff       	call   800e0a <sys_env_set_status>
  802006:	83 c4 10             	add    $0x10,%esp
  802009:	85 c0                	test   %eax,%eax
  80200b:	78 23                	js     802030 <spawn+0x4f1>
	return child;
  80200d:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802013:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802019:	eb 36                	jmp    802051 <spawn+0x512>
		panic("sys_env_set_trapframe: %e", r);
  80201b:	50                   	push   %eax
  80201c:	68 4e 35 80 00       	push   $0x80354e
  802021:	68 86 00 00 00       	push   $0x86
  802026:	68 25 35 80 00       	push   $0x803525
  80202b:	e8 d4 e1 ff ff       	call   800204 <_panic>
		panic("sys_env_set_status: %e", r);
  802030:	50                   	push   %eax
  802031:	68 1b 34 80 00       	push   $0x80341b
  802036:	68 89 00 00 00       	push   $0x89
  80203b:	68 25 35 80 00       	push   $0x803525
  802040:	e8 bf e1 ff ff       	call   800204 <_panic>
		return r;
  802045:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80204b:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  802051:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802057:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80205a:	5b                   	pop    %ebx
  80205b:	5e                   	pop    %esi
  80205c:	5f                   	pop    %edi
  80205d:	5d                   	pop    %ebp
  80205e:	c3                   	ret    
  80205f:	89 c7                	mov    %eax,%edi
  802061:	e9 19 fe ff ff       	jmp    801e7f <spawn+0x340>
  802066:	89 c7                	mov    %eax,%edi
  802068:	e9 12 fe ff ff       	jmp    801e7f <spawn+0x340>
  80206d:	89 c7                	mov    %eax,%edi
  80206f:	e9 0b fe ff ff       	jmp    801e7f <spawn+0x340>
		return -E_NO_MEM;
  802074:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(addr = 0; addr < USTACKTOP; addr += PGSIZE){
  802079:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  80207f:	eb d0                	jmp    802051 <spawn+0x512>
	sys_page_unmap(0, UTEMP);
  802081:	83 ec 08             	sub    $0x8,%esp
  802084:	68 00 00 40 00       	push   $0x400000
  802089:	6a 00                	push   $0x0
  80208b:	e8 34 ed ff ff       	call   800dc4 <sys_page_unmap>
  802090:	83 c4 10             	add    $0x10,%esp
  802093:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  802099:	eb b6                	jmp    802051 <spawn+0x512>

0080209b <spawnl>:
{
  80209b:	f3 0f 1e fb          	endbr32 
  80209f:	55                   	push   %ebp
  8020a0:	89 e5                	mov    %esp,%ebp
  8020a2:	57                   	push   %edi
  8020a3:	56                   	push   %esi
  8020a4:	53                   	push   %ebx
  8020a5:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  8020a8:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  8020ab:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  8020b0:	8d 4a 04             	lea    0x4(%edx),%ecx
  8020b3:	83 3a 00             	cmpl   $0x0,(%edx)
  8020b6:	74 07                	je     8020bf <spawnl+0x24>
		argc++;
  8020b8:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  8020bb:	89 ca                	mov    %ecx,%edx
  8020bd:	eb f1                	jmp    8020b0 <spawnl+0x15>
	const char *argv[argc+2];
  8020bf:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  8020c6:	89 d1                	mov    %edx,%ecx
  8020c8:	83 e1 f0             	and    $0xfffffff0,%ecx
  8020cb:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8020d1:	89 e6                	mov    %esp,%esi
  8020d3:	29 d6                	sub    %edx,%esi
  8020d5:	89 f2                	mov    %esi,%edx
  8020d7:	39 d4                	cmp    %edx,%esp
  8020d9:	74 10                	je     8020eb <spawnl+0x50>
  8020db:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  8020e1:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  8020e8:	00 
  8020e9:	eb ec                	jmp    8020d7 <spawnl+0x3c>
  8020eb:	89 ca                	mov    %ecx,%edx
  8020ed:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8020f3:	29 d4                	sub    %edx,%esp
  8020f5:	85 d2                	test   %edx,%edx
  8020f7:	74 05                	je     8020fe <spawnl+0x63>
  8020f9:	83 4c 14 fc 00       	orl    $0x0,-0x4(%esp,%edx,1)
  8020fe:	8d 74 24 03          	lea    0x3(%esp),%esi
  802102:	89 f2                	mov    %esi,%edx
  802104:	c1 ea 02             	shr    $0x2,%edx
  802107:	83 e6 fc             	and    $0xfffffffc,%esi
  80210a:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  80210c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80210f:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  802116:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  80211d:	00 
	va_start(vl, arg0);
  80211e:	8d 4d 10             	lea    0x10(%ebp),%ecx
  802121:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  802123:	b8 00 00 00 00       	mov    $0x0,%eax
  802128:	eb 0b                	jmp    802135 <spawnl+0x9a>
		argv[i+1] = va_arg(vl, const char *);
  80212a:	83 c0 01             	add    $0x1,%eax
  80212d:	8b 39                	mov    (%ecx),%edi
  80212f:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  802132:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  802135:	39 d0                	cmp    %edx,%eax
  802137:	75 f1                	jne    80212a <spawnl+0x8f>
	return spawn(prog, argv);
  802139:	83 ec 08             	sub    $0x8,%esp
  80213c:	56                   	push   %esi
  80213d:	ff 75 08             	pushl  0x8(%ebp)
  802140:	e8 fa f9 ff ff       	call   801b3f <spawn>
}
  802145:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802148:	5b                   	pop    %ebx
  802149:	5e                   	pop    %esi
  80214a:	5f                   	pop    %edi
  80214b:	5d                   	pop    %ebp
  80214c:	c3                   	ret    

0080214d <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80214d:	f3 0f 1e fb          	endbr32 
  802151:	55                   	push   %ebp
  802152:	89 e5                	mov    %esp,%ebp
  802154:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  802157:	68 8e 35 80 00       	push   $0x80358e
  80215c:	ff 75 0c             	pushl  0xc(%ebp)
  80215f:	e8 91 e7 ff ff       	call   8008f5 <strcpy>
	return 0;
}
  802164:	b8 00 00 00 00       	mov    $0x0,%eax
  802169:	c9                   	leave  
  80216a:	c3                   	ret    

0080216b <devsock_close>:
{
  80216b:	f3 0f 1e fb          	endbr32 
  80216f:	55                   	push   %ebp
  802170:	89 e5                	mov    %esp,%ebp
  802172:	53                   	push   %ebx
  802173:	83 ec 10             	sub    $0x10,%esp
  802176:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  802179:	53                   	push   %ebx
  80217a:	e8 87 0b 00 00       	call   802d06 <pageref>
  80217f:	89 c2                	mov    %eax,%edx
  802181:	83 c4 10             	add    $0x10,%esp
		return 0;
  802184:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  802189:	83 fa 01             	cmp    $0x1,%edx
  80218c:	74 05                	je     802193 <devsock_close+0x28>
}
  80218e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802191:	c9                   	leave  
  802192:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  802193:	83 ec 0c             	sub    $0xc,%esp
  802196:	ff 73 0c             	pushl  0xc(%ebx)
  802199:	e8 e3 02 00 00       	call   802481 <nsipc_close>
  80219e:	83 c4 10             	add    $0x10,%esp
  8021a1:	eb eb                	jmp    80218e <devsock_close+0x23>

008021a3 <devsock_write>:
{
  8021a3:	f3 0f 1e fb          	endbr32 
  8021a7:	55                   	push   %ebp
  8021a8:	89 e5                	mov    %esp,%ebp
  8021aa:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8021ad:	6a 00                	push   $0x0
  8021af:	ff 75 10             	pushl  0x10(%ebp)
  8021b2:	ff 75 0c             	pushl  0xc(%ebp)
  8021b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b8:	ff 70 0c             	pushl  0xc(%eax)
  8021bb:	e8 b5 03 00 00       	call   802575 <nsipc_send>
}
  8021c0:	c9                   	leave  
  8021c1:	c3                   	ret    

008021c2 <devsock_read>:
{
  8021c2:	f3 0f 1e fb          	endbr32 
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
  8021c9:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8021cc:	6a 00                	push   $0x0
  8021ce:	ff 75 10             	pushl  0x10(%ebp)
  8021d1:	ff 75 0c             	pushl  0xc(%ebp)
  8021d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d7:	ff 70 0c             	pushl  0xc(%eax)
  8021da:	e8 1f 03 00 00       	call   8024fe <nsipc_recv>
}
  8021df:	c9                   	leave  
  8021e0:	c3                   	ret    

008021e1 <fd2sockid>:
{
  8021e1:	55                   	push   %ebp
  8021e2:	89 e5                	mov    %esp,%ebp
  8021e4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8021e7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8021ea:	52                   	push   %edx
  8021eb:	50                   	push   %eax
  8021ec:	e8 84 f1 ff ff       	call   801375 <fd_lookup>
  8021f1:	83 c4 10             	add    $0x10,%esp
  8021f4:	85 c0                	test   %eax,%eax
  8021f6:	78 10                	js     802208 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8021f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fb:	8b 0d 28 40 80 00    	mov    0x804028,%ecx
  802201:	39 08                	cmp    %ecx,(%eax)
  802203:	75 05                	jne    80220a <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802205:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802208:	c9                   	leave  
  802209:	c3                   	ret    
		return -E_NOT_SUPP;
  80220a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80220f:	eb f7                	jmp    802208 <fd2sockid+0x27>

00802211 <alloc_sockfd>:
{
  802211:	55                   	push   %ebp
  802212:	89 e5                	mov    %esp,%ebp
  802214:	56                   	push   %esi
  802215:	53                   	push   %ebx
  802216:	83 ec 1c             	sub    $0x1c,%esp
  802219:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80221b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80221e:	50                   	push   %eax
  80221f:	e8 fb f0 ff ff       	call   80131f <fd_alloc>
  802224:	89 c3                	mov    %eax,%ebx
  802226:	83 c4 10             	add    $0x10,%esp
  802229:	85 c0                	test   %eax,%eax
  80222b:	78 43                	js     802270 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80222d:	83 ec 04             	sub    $0x4,%esp
  802230:	68 07 04 00 00       	push   $0x407
  802235:	ff 75 f4             	pushl  -0xc(%ebp)
  802238:	6a 00                	push   $0x0
  80223a:	e8 f8 ea ff ff       	call   800d37 <sys_page_alloc>
  80223f:	89 c3                	mov    %eax,%ebx
  802241:	83 c4 10             	add    $0x10,%esp
  802244:	85 c0                	test   %eax,%eax
  802246:	78 28                	js     802270 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802248:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224b:	8b 15 28 40 80 00    	mov    0x804028,%edx
  802251:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802253:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802256:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80225d:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802260:	83 ec 0c             	sub    $0xc,%esp
  802263:	50                   	push   %eax
  802264:	e8 87 f0 ff ff       	call   8012f0 <fd2num>
  802269:	89 c3                	mov    %eax,%ebx
  80226b:	83 c4 10             	add    $0x10,%esp
  80226e:	eb 0c                	jmp    80227c <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802270:	83 ec 0c             	sub    $0xc,%esp
  802273:	56                   	push   %esi
  802274:	e8 08 02 00 00       	call   802481 <nsipc_close>
		return r;
  802279:	83 c4 10             	add    $0x10,%esp
}
  80227c:	89 d8                	mov    %ebx,%eax
  80227e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802281:	5b                   	pop    %ebx
  802282:	5e                   	pop    %esi
  802283:	5d                   	pop    %ebp
  802284:	c3                   	ret    

00802285 <accept>:
{
  802285:	f3 0f 1e fb          	endbr32 
  802289:	55                   	push   %ebp
  80228a:	89 e5                	mov    %esp,%ebp
  80228c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80228f:	8b 45 08             	mov    0x8(%ebp),%eax
  802292:	e8 4a ff ff ff       	call   8021e1 <fd2sockid>
  802297:	85 c0                	test   %eax,%eax
  802299:	78 1b                	js     8022b6 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80229b:	83 ec 04             	sub    $0x4,%esp
  80229e:	ff 75 10             	pushl  0x10(%ebp)
  8022a1:	ff 75 0c             	pushl  0xc(%ebp)
  8022a4:	50                   	push   %eax
  8022a5:	e8 22 01 00 00       	call   8023cc <nsipc_accept>
  8022aa:	83 c4 10             	add    $0x10,%esp
  8022ad:	85 c0                	test   %eax,%eax
  8022af:	78 05                	js     8022b6 <accept+0x31>
	return alloc_sockfd(r);
  8022b1:	e8 5b ff ff ff       	call   802211 <alloc_sockfd>
}
  8022b6:	c9                   	leave  
  8022b7:	c3                   	ret    

008022b8 <bind>:
{
  8022b8:	f3 0f 1e fb          	endbr32 
  8022bc:	55                   	push   %ebp
  8022bd:	89 e5                	mov    %esp,%ebp
  8022bf:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8022c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c5:	e8 17 ff ff ff       	call   8021e1 <fd2sockid>
  8022ca:	85 c0                	test   %eax,%eax
  8022cc:	78 12                	js     8022e0 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  8022ce:	83 ec 04             	sub    $0x4,%esp
  8022d1:	ff 75 10             	pushl  0x10(%ebp)
  8022d4:	ff 75 0c             	pushl  0xc(%ebp)
  8022d7:	50                   	push   %eax
  8022d8:	e8 45 01 00 00       	call   802422 <nsipc_bind>
  8022dd:	83 c4 10             	add    $0x10,%esp
}
  8022e0:	c9                   	leave  
  8022e1:	c3                   	ret    

008022e2 <shutdown>:
{
  8022e2:	f3 0f 1e fb          	endbr32 
  8022e6:	55                   	push   %ebp
  8022e7:	89 e5                	mov    %esp,%ebp
  8022e9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8022ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ef:	e8 ed fe ff ff       	call   8021e1 <fd2sockid>
  8022f4:	85 c0                	test   %eax,%eax
  8022f6:	78 0f                	js     802307 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  8022f8:	83 ec 08             	sub    $0x8,%esp
  8022fb:	ff 75 0c             	pushl  0xc(%ebp)
  8022fe:	50                   	push   %eax
  8022ff:	e8 57 01 00 00       	call   80245b <nsipc_shutdown>
  802304:	83 c4 10             	add    $0x10,%esp
}
  802307:	c9                   	leave  
  802308:	c3                   	ret    

00802309 <connect>:
{
  802309:	f3 0f 1e fb          	endbr32 
  80230d:	55                   	push   %ebp
  80230e:	89 e5                	mov    %esp,%ebp
  802310:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802313:	8b 45 08             	mov    0x8(%ebp),%eax
  802316:	e8 c6 fe ff ff       	call   8021e1 <fd2sockid>
  80231b:	85 c0                	test   %eax,%eax
  80231d:	78 12                	js     802331 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  80231f:	83 ec 04             	sub    $0x4,%esp
  802322:	ff 75 10             	pushl  0x10(%ebp)
  802325:	ff 75 0c             	pushl  0xc(%ebp)
  802328:	50                   	push   %eax
  802329:	e8 71 01 00 00       	call   80249f <nsipc_connect>
  80232e:	83 c4 10             	add    $0x10,%esp
}
  802331:	c9                   	leave  
  802332:	c3                   	ret    

00802333 <listen>:
{
  802333:	f3 0f 1e fb          	endbr32 
  802337:	55                   	push   %ebp
  802338:	89 e5                	mov    %esp,%ebp
  80233a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80233d:	8b 45 08             	mov    0x8(%ebp),%eax
  802340:	e8 9c fe ff ff       	call   8021e1 <fd2sockid>
  802345:	85 c0                	test   %eax,%eax
  802347:	78 0f                	js     802358 <listen+0x25>
	return nsipc_listen(r, backlog);
  802349:	83 ec 08             	sub    $0x8,%esp
  80234c:	ff 75 0c             	pushl  0xc(%ebp)
  80234f:	50                   	push   %eax
  802350:	e8 83 01 00 00       	call   8024d8 <nsipc_listen>
  802355:	83 c4 10             	add    $0x10,%esp
}
  802358:	c9                   	leave  
  802359:	c3                   	ret    

0080235a <socket>:

int
socket(int domain, int type, int protocol)
{
  80235a:	f3 0f 1e fb          	endbr32 
  80235e:	55                   	push   %ebp
  80235f:	89 e5                	mov    %esp,%ebp
  802361:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802364:	ff 75 10             	pushl  0x10(%ebp)
  802367:	ff 75 0c             	pushl  0xc(%ebp)
  80236a:	ff 75 08             	pushl  0x8(%ebp)
  80236d:	e8 65 02 00 00       	call   8025d7 <nsipc_socket>
  802372:	83 c4 10             	add    $0x10,%esp
  802375:	85 c0                	test   %eax,%eax
  802377:	78 05                	js     80237e <socket+0x24>
		return r;
	return alloc_sockfd(r);
  802379:	e8 93 fe ff ff       	call   802211 <alloc_sockfd>
}
  80237e:	c9                   	leave  
  80237f:	c3                   	ret    

00802380 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802380:	55                   	push   %ebp
  802381:	89 e5                	mov    %esp,%ebp
  802383:	53                   	push   %ebx
  802384:	83 ec 04             	sub    $0x4,%esp
  802387:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802389:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802390:	74 26                	je     8023b8 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802392:	6a 07                	push   $0x7
  802394:	68 00 70 80 00       	push   $0x807000
  802399:	53                   	push   %ebx
  80239a:	ff 35 04 50 80 00    	pushl  0x805004
  8023a0:	e8 cc 08 00 00       	call   802c71 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8023a5:	83 c4 0c             	add    $0xc,%esp
  8023a8:	6a 00                	push   $0x0
  8023aa:	6a 00                	push   $0x0
  8023ac:	6a 00                	push   $0x0
  8023ae:	e8 39 08 00 00       	call   802bec <ipc_recv>
}
  8023b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023b6:	c9                   	leave  
  8023b7:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8023b8:	83 ec 0c             	sub    $0xc,%esp
  8023bb:	6a 02                	push   $0x2
  8023bd:	e8 07 09 00 00       	call   802cc9 <ipc_find_env>
  8023c2:	a3 04 50 80 00       	mov    %eax,0x805004
  8023c7:	83 c4 10             	add    $0x10,%esp
  8023ca:	eb c6                	jmp    802392 <nsipc+0x12>

008023cc <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8023cc:	f3 0f 1e fb          	endbr32 
  8023d0:	55                   	push   %ebp
  8023d1:	89 e5                	mov    %esp,%ebp
  8023d3:	56                   	push   %esi
  8023d4:	53                   	push   %ebx
  8023d5:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8023d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023db:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8023e0:	8b 06                	mov    (%esi),%eax
  8023e2:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8023e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8023ec:	e8 8f ff ff ff       	call   802380 <nsipc>
  8023f1:	89 c3                	mov    %eax,%ebx
  8023f3:	85 c0                	test   %eax,%eax
  8023f5:	79 09                	jns    802400 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8023f7:	89 d8                	mov    %ebx,%eax
  8023f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023fc:	5b                   	pop    %ebx
  8023fd:	5e                   	pop    %esi
  8023fe:	5d                   	pop    %ebp
  8023ff:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802400:	83 ec 04             	sub    $0x4,%esp
  802403:	ff 35 10 70 80 00    	pushl  0x807010
  802409:	68 00 70 80 00       	push   $0x807000
  80240e:	ff 75 0c             	pushl  0xc(%ebp)
  802411:	e8 95 e6 ff ff       	call   800aab <memmove>
		*addrlen = ret->ret_addrlen;
  802416:	a1 10 70 80 00       	mov    0x807010,%eax
  80241b:	89 06                	mov    %eax,(%esi)
  80241d:	83 c4 10             	add    $0x10,%esp
	return r;
  802420:	eb d5                	jmp    8023f7 <nsipc_accept+0x2b>

00802422 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802422:	f3 0f 1e fb          	endbr32 
  802426:	55                   	push   %ebp
  802427:	89 e5                	mov    %esp,%ebp
  802429:	53                   	push   %ebx
  80242a:	83 ec 08             	sub    $0x8,%esp
  80242d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802430:	8b 45 08             	mov    0x8(%ebp),%eax
  802433:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802438:	53                   	push   %ebx
  802439:	ff 75 0c             	pushl  0xc(%ebp)
  80243c:	68 04 70 80 00       	push   $0x807004
  802441:	e8 65 e6 ff ff       	call   800aab <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802446:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80244c:	b8 02 00 00 00       	mov    $0x2,%eax
  802451:	e8 2a ff ff ff       	call   802380 <nsipc>
}
  802456:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802459:	c9                   	leave  
  80245a:	c3                   	ret    

0080245b <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80245b:	f3 0f 1e fb          	endbr32 
  80245f:	55                   	push   %ebp
  802460:	89 e5                	mov    %esp,%ebp
  802462:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802465:	8b 45 08             	mov    0x8(%ebp),%eax
  802468:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80246d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802470:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802475:	b8 03 00 00 00       	mov    $0x3,%eax
  80247a:	e8 01 ff ff ff       	call   802380 <nsipc>
}
  80247f:	c9                   	leave  
  802480:	c3                   	ret    

00802481 <nsipc_close>:

int
nsipc_close(int s)
{
  802481:	f3 0f 1e fb          	endbr32 
  802485:	55                   	push   %ebp
  802486:	89 e5                	mov    %esp,%ebp
  802488:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80248b:	8b 45 08             	mov    0x8(%ebp),%eax
  80248e:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802493:	b8 04 00 00 00       	mov    $0x4,%eax
  802498:	e8 e3 fe ff ff       	call   802380 <nsipc>
}
  80249d:	c9                   	leave  
  80249e:	c3                   	ret    

0080249f <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80249f:	f3 0f 1e fb          	endbr32 
  8024a3:	55                   	push   %ebp
  8024a4:	89 e5                	mov    %esp,%ebp
  8024a6:	53                   	push   %ebx
  8024a7:	83 ec 08             	sub    $0x8,%esp
  8024aa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8024ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b0:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8024b5:	53                   	push   %ebx
  8024b6:	ff 75 0c             	pushl  0xc(%ebp)
  8024b9:	68 04 70 80 00       	push   $0x807004
  8024be:	e8 e8 e5 ff ff       	call   800aab <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8024c3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8024c9:	b8 05 00 00 00       	mov    $0x5,%eax
  8024ce:	e8 ad fe ff ff       	call   802380 <nsipc>
}
  8024d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024d6:	c9                   	leave  
  8024d7:	c3                   	ret    

008024d8 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8024d8:	f3 0f 1e fb          	endbr32 
  8024dc:	55                   	push   %ebp
  8024dd:	89 e5                	mov    %esp,%ebp
  8024df:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8024e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e5:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8024ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ed:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8024f2:	b8 06 00 00 00       	mov    $0x6,%eax
  8024f7:	e8 84 fe ff ff       	call   802380 <nsipc>
}
  8024fc:	c9                   	leave  
  8024fd:	c3                   	ret    

008024fe <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8024fe:	f3 0f 1e fb          	endbr32 
  802502:	55                   	push   %ebp
  802503:	89 e5                	mov    %esp,%ebp
  802505:	56                   	push   %esi
  802506:	53                   	push   %ebx
  802507:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80250a:	8b 45 08             	mov    0x8(%ebp),%eax
  80250d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802512:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802518:	8b 45 14             	mov    0x14(%ebp),%eax
  80251b:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802520:	b8 07 00 00 00       	mov    $0x7,%eax
  802525:	e8 56 fe ff ff       	call   802380 <nsipc>
  80252a:	89 c3                	mov    %eax,%ebx
  80252c:	85 c0                	test   %eax,%eax
  80252e:	78 26                	js     802556 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  802530:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  802536:	b8 3f 06 00 00       	mov    $0x63f,%eax
  80253b:	0f 4e c6             	cmovle %esi,%eax
  80253e:	39 c3                	cmp    %eax,%ebx
  802540:	7f 1d                	jg     80255f <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802542:	83 ec 04             	sub    $0x4,%esp
  802545:	53                   	push   %ebx
  802546:	68 00 70 80 00       	push   $0x807000
  80254b:	ff 75 0c             	pushl  0xc(%ebp)
  80254e:	e8 58 e5 ff ff       	call   800aab <memmove>
  802553:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802556:	89 d8                	mov    %ebx,%eax
  802558:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80255b:	5b                   	pop    %ebx
  80255c:	5e                   	pop    %esi
  80255d:	5d                   	pop    %ebp
  80255e:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80255f:	68 9a 35 80 00       	push   $0x80359a
  802564:	68 df 34 80 00       	push   $0x8034df
  802569:	6a 62                	push   $0x62
  80256b:	68 af 35 80 00       	push   $0x8035af
  802570:	e8 8f dc ff ff       	call   800204 <_panic>

00802575 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802575:	f3 0f 1e fb          	endbr32 
  802579:	55                   	push   %ebp
  80257a:	89 e5                	mov    %esp,%ebp
  80257c:	53                   	push   %ebx
  80257d:	83 ec 04             	sub    $0x4,%esp
  802580:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802583:	8b 45 08             	mov    0x8(%ebp),%eax
  802586:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80258b:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802591:	7f 2e                	jg     8025c1 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802593:	83 ec 04             	sub    $0x4,%esp
  802596:	53                   	push   %ebx
  802597:	ff 75 0c             	pushl  0xc(%ebp)
  80259a:	68 0c 70 80 00       	push   $0x80700c
  80259f:	e8 07 e5 ff ff       	call   800aab <memmove>
	nsipcbuf.send.req_size = size;
  8025a4:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8025aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8025ad:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8025b2:	b8 08 00 00 00       	mov    $0x8,%eax
  8025b7:	e8 c4 fd ff ff       	call   802380 <nsipc>
}
  8025bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025bf:	c9                   	leave  
  8025c0:	c3                   	ret    
	assert(size < 1600);
  8025c1:	68 bb 35 80 00       	push   $0x8035bb
  8025c6:	68 df 34 80 00       	push   $0x8034df
  8025cb:	6a 6d                	push   $0x6d
  8025cd:	68 af 35 80 00       	push   $0x8035af
  8025d2:	e8 2d dc ff ff       	call   800204 <_panic>

008025d7 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8025d7:	f3 0f 1e fb          	endbr32 
  8025db:	55                   	push   %ebp
  8025dc:	89 e5                	mov    %esp,%ebp
  8025de:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8025e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e4:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8025e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025ec:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8025f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8025f4:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8025f9:	b8 09 00 00 00       	mov    $0x9,%eax
  8025fe:	e8 7d fd ff ff       	call   802380 <nsipc>
}
  802603:	c9                   	leave  
  802604:	c3                   	ret    

00802605 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802605:	f3 0f 1e fb          	endbr32 
  802609:	55                   	push   %ebp
  80260a:	89 e5                	mov    %esp,%ebp
  80260c:	56                   	push   %esi
  80260d:	53                   	push   %ebx
  80260e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802611:	83 ec 0c             	sub    $0xc,%esp
  802614:	ff 75 08             	pushl  0x8(%ebp)
  802617:	e8 e8 ec ff ff       	call   801304 <fd2data>
  80261c:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80261e:	83 c4 08             	add    $0x8,%esp
  802621:	68 c7 35 80 00       	push   $0x8035c7
  802626:	53                   	push   %ebx
  802627:	e8 c9 e2 ff ff       	call   8008f5 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80262c:	8b 46 04             	mov    0x4(%esi),%eax
  80262f:	2b 06                	sub    (%esi),%eax
  802631:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802637:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80263e:	00 00 00 
	stat->st_dev = &devpipe;
  802641:	c7 83 88 00 00 00 44 	movl   $0x804044,0x88(%ebx)
  802648:	40 80 00 
	return 0;
}
  80264b:	b8 00 00 00 00       	mov    $0x0,%eax
  802650:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802653:	5b                   	pop    %ebx
  802654:	5e                   	pop    %esi
  802655:	5d                   	pop    %ebp
  802656:	c3                   	ret    

00802657 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802657:	f3 0f 1e fb          	endbr32 
  80265b:	55                   	push   %ebp
  80265c:	89 e5                	mov    %esp,%ebp
  80265e:	53                   	push   %ebx
  80265f:	83 ec 0c             	sub    $0xc,%esp
  802662:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802665:	53                   	push   %ebx
  802666:	6a 00                	push   $0x0
  802668:	e8 57 e7 ff ff       	call   800dc4 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80266d:	89 1c 24             	mov    %ebx,(%esp)
  802670:	e8 8f ec ff ff       	call   801304 <fd2data>
  802675:	83 c4 08             	add    $0x8,%esp
  802678:	50                   	push   %eax
  802679:	6a 00                	push   $0x0
  80267b:	e8 44 e7 ff ff       	call   800dc4 <sys_page_unmap>
}
  802680:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802683:	c9                   	leave  
  802684:	c3                   	ret    

00802685 <_pipeisclosed>:
{
  802685:	55                   	push   %ebp
  802686:	89 e5                	mov    %esp,%ebp
  802688:	57                   	push   %edi
  802689:	56                   	push   %esi
  80268a:	53                   	push   %ebx
  80268b:	83 ec 1c             	sub    $0x1c,%esp
  80268e:	89 c7                	mov    %eax,%edi
  802690:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802692:	a1 08 50 80 00       	mov    0x805008,%eax
  802697:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80269a:	83 ec 0c             	sub    $0xc,%esp
  80269d:	57                   	push   %edi
  80269e:	e8 63 06 00 00       	call   802d06 <pageref>
  8026a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8026a6:	89 34 24             	mov    %esi,(%esp)
  8026a9:	e8 58 06 00 00       	call   802d06 <pageref>
		nn = thisenv->env_runs;
  8026ae:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8026b4:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8026b7:	83 c4 10             	add    $0x10,%esp
  8026ba:	39 cb                	cmp    %ecx,%ebx
  8026bc:	74 1b                	je     8026d9 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8026be:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8026c1:	75 cf                	jne    802692 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8026c3:	8b 42 58             	mov    0x58(%edx),%eax
  8026c6:	6a 01                	push   $0x1
  8026c8:	50                   	push   %eax
  8026c9:	53                   	push   %ebx
  8026ca:	68 ce 35 80 00       	push   $0x8035ce
  8026cf:	e8 17 dc ff ff       	call   8002eb <cprintf>
  8026d4:	83 c4 10             	add    $0x10,%esp
  8026d7:	eb b9                	jmp    802692 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8026d9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8026dc:	0f 94 c0             	sete   %al
  8026df:	0f b6 c0             	movzbl %al,%eax
}
  8026e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026e5:	5b                   	pop    %ebx
  8026e6:	5e                   	pop    %esi
  8026e7:	5f                   	pop    %edi
  8026e8:	5d                   	pop    %ebp
  8026e9:	c3                   	ret    

008026ea <devpipe_write>:
{
  8026ea:	f3 0f 1e fb          	endbr32 
  8026ee:	55                   	push   %ebp
  8026ef:	89 e5                	mov    %esp,%ebp
  8026f1:	57                   	push   %edi
  8026f2:	56                   	push   %esi
  8026f3:	53                   	push   %ebx
  8026f4:	83 ec 28             	sub    $0x28,%esp
  8026f7:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8026fa:	56                   	push   %esi
  8026fb:	e8 04 ec ff ff       	call   801304 <fd2data>
  802700:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802702:	83 c4 10             	add    $0x10,%esp
  802705:	bf 00 00 00 00       	mov    $0x0,%edi
  80270a:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80270d:	74 4f                	je     80275e <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80270f:	8b 43 04             	mov    0x4(%ebx),%eax
  802712:	8b 0b                	mov    (%ebx),%ecx
  802714:	8d 51 20             	lea    0x20(%ecx),%edx
  802717:	39 d0                	cmp    %edx,%eax
  802719:	72 14                	jb     80272f <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  80271b:	89 da                	mov    %ebx,%edx
  80271d:	89 f0                	mov    %esi,%eax
  80271f:	e8 61 ff ff ff       	call   802685 <_pipeisclosed>
  802724:	85 c0                	test   %eax,%eax
  802726:	75 3b                	jne    802763 <devpipe_write+0x79>
			sys_yield();
  802728:	e8 e7 e5 ff ff       	call   800d14 <sys_yield>
  80272d:	eb e0                	jmp    80270f <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80272f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802732:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802736:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802739:	89 c2                	mov    %eax,%edx
  80273b:	c1 fa 1f             	sar    $0x1f,%edx
  80273e:	89 d1                	mov    %edx,%ecx
  802740:	c1 e9 1b             	shr    $0x1b,%ecx
  802743:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802746:	83 e2 1f             	and    $0x1f,%edx
  802749:	29 ca                	sub    %ecx,%edx
  80274b:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80274f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802753:	83 c0 01             	add    $0x1,%eax
  802756:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802759:	83 c7 01             	add    $0x1,%edi
  80275c:	eb ac                	jmp    80270a <devpipe_write+0x20>
	return i;
  80275e:	8b 45 10             	mov    0x10(%ebp),%eax
  802761:	eb 05                	jmp    802768 <devpipe_write+0x7e>
				return 0;
  802763:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802768:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80276b:	5b                   	pop    %ebx
  80276c:	5e                   	pop    %esi
  80276d:	5f                   	pop    %edi
  80276e:	5d                   	pop    %ebp
  80276f:	c3                   	ret    

00802770 <devpipe_read>:
{
  802770:	f3 0f 1e fb          	endbr32 
  802774:	55                   	push   %ebp
  802775:	89 e5                	mov    %esp,%ebp
  802777:	57                   	push   %edi
  802778:	56                   	push   %esi
  802779:	53                   	push   %ebx
  80277a:	83 ec 18             	sub    $0x18,%esp
  80277d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802780:	57                   	push   %edi
  802781:	e8 7e eb ff ff       	call   801304 <fd2data>
  802786:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802788:	83 c4 10             	add    $0x10,%esp
  80278b:	be 00 00 00 00       	mov    $0x0,%esi
  802790:	3b 75 10             	cmp    0x10(%ebp),%esi
  802793:	75 14                	jne    8027a9 <devpipe_read+0x39>
	return i;
  802795:	8b 45 10             	mov    0x10(%ebp),%eax
  802798:	eb 02                	jmp    80279c <devpipe_read+0x2c>
				return i;
  80279a:	89 f0                	mov    %esi,%eax
}
  80279c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80279f:	5b                   	pop    %ebx
  8027a0:	5e                   	pop    %esi
  8027a1:	5f                   	pop    %edi
  8027a2:	5d                   	pop    %ebp
  8027a3:	c3                   	ret    
			sys_yield();
  8027a4:	e8 6b e5 ff ff       	call   800d14 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8027a9:	8b 03                	mov    (%ebx),%eax
  8027ab:	3b 43 04             	cmp    0x4(%ebx),%eax
  8027ae:	75 18                	jne    8027c8 <devpipe_read+0x58>
			if (i > 0)
  8027b0:	85 f6                	test   %esi,%esi
  8027b2:	75 e6                	jne    80279a <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8027b4:	89 da                	mov    %ebx,%edx
  8027b6:	89 f8                	mov    %edi,%eax
  8027b8:	e8 c8 fe ff ff       	call   802685 <_pipeisclosed>
  8027bd:	85 c0                	test   %eax,%eax
  8027bf:	74 e3                	je     8027a4 <devpipe_read+0x34>
				return 0;
  8027c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c6:	eb d4                	jmp    80279c <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8027c8:	99                   	cltd   
  8027c9:	c1 ea 1b             	shr    $0x1b,%edx
  8027cc:	01 d0                	add    %edx,%eax
  8027ce:	83 e0 1f             	and    $0x1f,%eax
  8027d1:	29 d0                	sub    %edx,%eax
  8027d3:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8027d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027db:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8027de:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8027e1:	83 c6 01             	add    $0x1,%esi
  8027e4:	eb aa                	jmp    802790 <devpipe_read+0x20>

008027e6 <pipe>:
{
  8027e6:	f3 0f 1e fb          	endbr32 
  8027ea:	55                   	push   %ebp
  8027eb:	89 e5                	mov    %esp,%ebp
  8027ed:	56                   	push   %esi
  8027ee:	53                   	push   %ebx
  8027ef:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8027f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027f5:	50                   	push   %eax
  8027f6:	e8 24 eb ff ff       	call   80131f <fd_alloc>
  8027fb:	89 c3                	mov    %eax,%ebx
  8027fd:	83 c4 10             	add    $0x10,%esp
  802800:	85 c0                	test   %eax,%eax
  802802:	0f 88 23 01 00 00    	js     80292b <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802808:	83 ec 04             	sub    $0x4,%esp
  80280b:	68 07 04 00 00       	push   $0x407
  802810:	ff 75 f4             	pushl  -0xc(%ebp)
  802813:	6a 00                	push   $0x0
  802815:	e8 1d e5 ff ff       	call   800d37 <sys_page_alloc>
  80281a:	89 c3                	mov    %eax,%ebx
  80281c:	83 c4 10             	add    $0x10,%esp
  80281f:	85 c0                	test   %eax,%eax
  802821:	0f 88 04 01 00 00    	js     80292b <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  802827:	83 ec 0c             	sub    $0xc,%esp
  80282a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80282d:	50                   	push   %eax
  80282e:	e8 ec ea ff ff       	call   80131f <fd_alloc>
  802833:	89 c3                	mov    %eax,%ebx
  802835:	83 c4 10             	add    $0x10,%esp
  802838:	85 c0                	test   %eax,%eax
  80283a:	0f 88 db 00 00 00    	js     80291b <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802840:	83 ec 04             	sub    $0x4,%esp
  802843:	68 07 04 00 00       	push   $0x407
  802848:	ff 75 f0             	pushl  -0x10(%ebp)
  80284b:	6a 00                	push   $0x0
  80284d:	e8 e5 e4 ff ff       	call   800d37 <sys_page_alloc>
  802852:	89 c3                	mov    %eax,%ebx
  802854:	83 c4 10             	add    $0x10,%esp
  802857:	85 c0                	test   %eax,%eax
  802859:	0f 88 bc 00 00 00    	js     80291b <pipe+0x135>
	va = fd2data(fd0);
  80285f:	83 ec 0c             	sub    $0xc,%esp
  802862:	ff 75 f4             	pushl  -0xc(%ebp)
  802865:	e8 9a ea ff ff       	call   801304 <fd2data>
  80286a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80286c:	83 c4 0c             	add    $0xc,%esp
  80286f:	68 07 04 00 00       	push   $0x407
  802874:	50                   	push   %eax
  802875:	6a 00                	push   $0x0
  802877:	e8 bb e4 ff ff       	call   800d37 <sys_page_alloc>
  80287c:	89 c3                	mov    %eax,%ebx
  80287e:	83 c4 10             	add    $0x10,%esp
  802881:	85 c0                	test   %eax,%eax
  802883:	0f 88 82 00 00 00    	js     80290b <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802889:	83 ec 0c             	sub    $0xc,%esp
  80288c:	ff 75 f0             	pushl  -0x10(%ebp)
  80288f:	e8 70 ea ff ff       	call   801304 <fd2data>
  802894:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80289b:	50                   	push   %eax
  80289c:	6a 00                	push   $0x0
  80289e:	56                   	push   %esi
  80289f:	6a 00                	push   $0x0
  8028a1:	e8 d8 e4 ff ff       	call   800d7e <sys_page_map>
  8028a6:	89 c3                	mov    %eax,%ebx
  8028a8:	83 c4 20             	add    $0x20,%esp
  8028ab:	85 c0                	test   %eax,%eax
  8028ad:	78 4e                	js     8028fd <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8028af:	a1 44 40 80 00       	mov    0x804044,%eax
  8028b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b7:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8028b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028bc:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8028c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028c6:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8028c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cb:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8028d2:	83 ec 0c             	sub    $0xc,%esp
  8028d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8028d8:	e8 13 ea ff ff       	call   8012f0 <fd2num>
  8028dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8028e0:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8028e2:	83 c4 04             	add    $0x4,%esp
  8028e5:	ff 75 f0             	pushl  -0x10(%ebp)
  8028e8:	e8 03 ea ff ff       	call   8012f0 <fd2num>
  8028ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8028f0:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8028f3:	83 c4 10             	add    $0x10,%esp
  8028f6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8028fb:	eb 2e                	jmp    80292b <pipe+0x145>
	sys_page_unmap(0, va);
  8028fd:	83 ec 08             	sub    $0x8,%esp
  802900:	56                   	push   %esi
  802901:	6a 00                	push   $0x0
  802903:	e8 bc e4 ff ff       	call   800dc4 <sys_page_unmap>
  802908:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80290b:	83 ec 08             	sub    $0x8,%esp
  80290e:	ff 75 f0             	pushl  -0x10(%ebp)
  802911:	6a 00                	push   $0x0
  802913:	e8 ac e4 ff ff       	call   800dc4 <sys_page_unmap>
  802918:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80291b:	83 ec 08             	sub    $0x8,%esp
  80291e:	ff 75 f4             	pushl  -0xc(%ebp)
  802921:	6a 00                	push   $0x0
  802923:	e8 9c e4 ff ff       	call   800dc4 <sys_page_unmap>
  802928:	83 c4 10             	add    $0x10,%esp
}
  80292b:	89 d8                	mov    %ebx,%eax
  80292d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802930:	5b                   	pop    %ebx
  802931:	5e                   	pop    %esi
  802932:	5d                   	pop    %ebp
  802933:	c3                   	ret    

00802934 <pipeisclosed>:
{
  802934:	f3 0f 1e fb          	endbr32 
  802938:	55                   	push   %ebp
  802939:	89 e5                	mov    %esp,%ebp
  80293b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80293e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802941:	50                   	push   %eax
  802942:	ff 75 08             	pushl  0x8(%ebp)
  802945:	e8 2b ea ff ff       	call   801375 <fd_lookup>
  80294a:	83 c4 10             	add    $0x10,%esp
  80294d:	85 c0                	test   %eax,%eax
  80294f:	78 18                	js     802969 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802951:	83 ec 0c             	sub    $0xc,%esp
  802954:	ff 75 f4             	pushl  -0xc(%ebp)
  802957:	e8 a8 e9 ff ff       	call   801304 <fd2data>
  80295c:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  80295e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802961:	e8 1f fd ff ff       	call   802685 <_pipeisclosed>
  802966:	83 c4 10             	add    $0x10,%esp
}
  802969:	c9                   	leave  
  80296a:	c3                   	ret    

0080296b <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80296b:	f3 0f 1e fb          	endbr32 
  80296f:	55                   	push   %ebp
  802970:	89 e5                	mov    %esp,%ebp
  802972:	56                   	push   %esi
  802973:	53                   	push   %ebx
  802974:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802977:	85 f6                	test   %esi,%esi
  802979:	74 13                	je     80298e <wait+0x23>
	e = &envs[ENVX(envid)];
  80297b:	89 f3                	mov    %esi,%ebx
  80297d:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802983:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802986:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80298c:	eb 1b                	jmp    8029a9 <wait+0x3e>
	assert(envid != 0);
  80298e:	68 e6 35 80 00       	push   $0x8035e6
  802993:	68 df 34 80 00       	push   $0x8034df
  802998:	6a 09                	push   $0x9
  80299a:	68 f1 35 80 00       	push   $0x8035f1
  80299f:	e8 60 d8 ff ff       	call   800204 <_panic>
		sys_yield();
  8029a4:	e8 6b e3 ff ff       	call   800d14 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8029a9:	8b 43 48             	mov    0x48(%ebx),%eax
  8029ac:	39 f0                	cmp    %esi,%eax
  8029ae:	75 07                	jne    8029b7 <wait+0x4c>
  8029b0:	8b 43 54             	mov    0x54(%ebx),%eax
  8029b3:	85 c0                	test   %eax,%eax
  8029b5:	75 ed                	jne    8029a4 <wait+0x39>
}
  8029b7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8029ba:	5b                   	pop    %ebx
  8029bb:	5e                   	pop    %esi
  8029bc:	5d                   	pop    %ebp
  8029bd:	c3                   	ret    

008029be <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8029be:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8029c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c7:	c3                   	ret    

008029c8 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8029c8:	f3 0f 1e fb          	endbr32 
  8029cc:	55                   	push   %ebp
  8029cd:	89 e5                	mov    %esp,%ebp
  8029cf:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8029d2:	68 fc 35 80 00       	push   $0x8035fc
  8029d7:	ff 75 0c             	pushl  0xc(%ebp)
  8029da:	e8 16 df ff ff       	call   8008f5 <strcpy>
	return 0;
}
  8029df:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e4:	c9                   	leave  
  8029e5:	c3                   	ret    

008029e6 <devcons_write>:
{
  8029e6:	f3 0f 1e fb          	endbr32 
  8029ea:	55                   	push   %ebp
  8029eb:	89 e5                	mov    %esp,%ebp
  8029ed:	57                   	push   %edi
  8029ee:	56                   	push   %esi
  8029ef:	53                   	push   %ebx
  8029f0:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8029f6:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8029fb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802a01:	3b 75 10             	cmp    0x10(%ebp),%esi
  802a04:	73 31                	jae    802a37 <devcons_write+0x51>
		m = n - tot;
  802a06:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802a09:	29 f3                	sub    %esi,%ebx
  802a0b:	83 fb 7f             	cmp    $0x7f,%ebx
  802a0e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802a13:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802a16:	83 ec 04             	sub    $0x4,%esp
  802a19:	53                   	push   %ebx
  802a1a:	89 f0                	mov    %esi,%eax
  802a1c:	03 45 0c             	add    0xc(%ebp),%eax
  802a1f:	50                   	push   %eax
  802a20:	57                   	push   %edi
  802a21:	e8 85 e0 ff ff       	call   800aab <memmove>
		sys_cputs(buf, m);
  802a26:	83 c4 08             	add    $0x8,%esp
  802a29:	53                   	push   %ebx
  802a2a:	57                   	push   %edi
  802a2b:	e8 37 e2 ff ff       	call   800c67 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802a30:	01 de                	add    %ebx,%esi
  802a32:	83 c4 10             	add    $0x10,%esp
  802a35:	eb ca                	jmp    802a01 <devcons_write+0x1b>
}
  802a37:	89 f0                	mov    %esi,%eax
  802a39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a3c:	5b                   	pop    %ebx
  802a3d:	5e                   	pop    %esi
  802a3e:	5f                   	pop    %edi
  802a3f:	5d                   	pop    %ebp
  802a40:	c3                   	ret    

00802a41 <devcons_read>:
{
  802a41:	f3 0f 1e fb          	endbr32 
  802a45:	55                   	push   %ebp
  802a46:	89 e5                	mov    %esp,%ebp
  802a48:	83 ec 08             	sub    $0x8,%esp
  802a4b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802a50:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802a54:	74 21                	je     802a77 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802a56:	e8 2e e2 ff ff       	call   800c89 <sys_cgetc>
  802a5b:	85 c0                	test   %eax,%eax
  802a5d:	75 07                	jne    802a66 <devcons_read+0x25>
		sys_yield();
  802a5f:	e8 b0 e2 ff ff       	call   800d14 <sys_yield>
  802a64:	eb f0                	jmp    802a56 <devcons_read+0x15>
	if (c < 0)
  802a66:	78 0f                	js     802a77 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  802a68:	83 f8 04             	cmp    $0x4,%eax
  802a6b:	74 0c                	je     802a79 <devcons_read+0x38>
	*(char*)vbuf = c;
  802a6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a70:	88 02                	mov    %al,(%edx)
	return 1;
  802a72:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802a77:	c9                   	leave  
  802a78:	c3                   	ret    
		return 0;
  802a79:	b8 00 00 00 00       	mov    $0x0,%eax
  802a7e:	eb f7                	jmp    802a77 <devcons_read+0x36>

00802a80 <cputchar>:
{
  802a80:	f3 0f 1e fb          	endbr32 
  802a84:	55                   	push   %ebp
  802a85:	89 e5                	mov    %esp,%ebp
  802a87:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8d:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802a90:	6a 01                	push   $0x1
  802a92:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802a95:	50                   	push   %eax
  802a96:	e8 cc e1 ff ff       	call   800c67 <sys_cputs>
}
  802a9b:	83 c4 10             	add    $0x10,%esp
  802a9e:	c9                   	leave  
  802a9f:	c3                   	ret    

00802aa0 <getchar>:
{
  802aa0:	f3 0f 1e fb          	endbr32 
  802aa4:	55                   	push   %ebp
  802aa5:	89 e5                	mov    %esp,%ebp
  802aa7:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802aaa:	6a 01                	push   $0x1
  802aac:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802aaf:	50                   	push   %eax
  802ab0:	6a 00                	push   $0x0
  802ab2:	e8 46 eb ff ff       	call   8015fd <read>
	if (r < 0)
  802ab7:	83 c4 10             	add    $0x10,%esp
  802aba:	85 c0                	test   %eax,%eax
  802abc:	78 06                	js     802ac4 <getchar+0x24>
	if (r < 1)
  802abe:	74 06                	je     802ac6 <getchar+0x26>
	return c;
  802ac0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802ac4:	c9                   	leave  
  802ac5:	c3                   	ret    
		return -E_EOF;
  802ac6:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802acb:	eb f7                	jmp    802ac4 <getchar+0x24>

00802acd <iscons>:
{
  802acd:	f3 0f 1e fb          	endbr32 
  802ad1:	55                   	push   %ebp
  802ad2:	89 e5                	mov    %esp,%ebp
  802ad4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ad7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ada:	50                   	push   %eax
  802adb:	ff 75 08             	pushl  0x8(%ebp)
  802ade:	e8 92 e8 ff ff       	call   801375 <fd_lookup>
  802ae3:	83 c4 10             	add    $0x10,%esp
  802ae6:	85 c0                	test   %eax,%eax
  802ae8:	78 11                	js     802afb <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  802aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aed:	8b 15 60 40 80 00    	mov    0x804060,%edx
  802af3:	39 10                	cmp    %edx,(%eax)
  802af5:	0f 94 c0             	sete   %al
  802af8:	0f b6 c0             	movzbl %al,%eax
}
  802afb:	c9                   	leave  
  802afc:	c3                   	ret    

00802afd <opencons>:
{
  802afd:	f3 0f 1e fb          	endbr32 
  802b01:	55                   	push   %ebp
  802b02:	89 e5                	mov    %esp,%ebp
  802b04:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802b07:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b0a:	50                   	push   %eax
  802b0b:	e8 0f e8 ff ff       	call   80131f <fd_alloc>
  802b10:	83 c4 10             	add    $0x10,%esp
  802b13:	85 c0                	test   %eax,%eax
  802b15:	78 3a                	js     802b51 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802b17:	83 ec 04             	sub    $0x4,%esp
  802b1a:	68 07 04 00 00       	push   $0x407
  802b1f:	ff 75 f4             	pushl  -0xc(%ebp)
  802b22:	6a 00                	push   $0x0
  802b24:	e8 0e e2 ff ff       	call   800d37 <sys_page_alloc>
  802b29:	83 c4 10             	add    $0x10,%esp
  802b2c:	85 c0                	test   %eax,%eax
  802b2e:	78 21                	js     802b51 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b33:	8b 15 60 40 80 00    	mov    0x804060,%edx
  802b39:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802b45:	83 ec 0c             	sub    $0xc,%esp
  802b48:	50                   	push   %eax
  802b49:	e8 a2 e7 ff ff       	call   8012f0 <fd2num>
  802b4e:	83 c4 10             	add    $0x10,%esp
}
  802b51:	c9                   	leave  
  802b52:	c3                   	ret    

00802b53 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802b53:	f3 0f 1e fb          	endbr32 
  802b57:	55                   	push   %ebp
  802b58:	89 e5                	mov    %esp,%ebp
  802b5a:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802b5d:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802b64:	74 0a                	je     802b70 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802b66:	8b 45 08             	mov    0x8(%ebp),%eax
  802b69:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802b6e:	c9                   	leave  
  802b6f:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  802b70:	83 ec 04             	sub    $0x4,%esp
  802b73:	6a 07                	push   $0x7
  802b75:	68 00 f0 bf ee       	push   $0xeebff000
  802b7a:	6a 00                	push   $0x0
  802b7c:	e8 b6 e1 ff ff       	call   800d37 <sys_page_alloc>
  802b81:	83 c4 10             	add    $0x10,%esp
  802b84:	85 c0                	test   %eax,%eax
  802b86:	78 2a                	js     802bb2 <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  802b88:	83 ec 08             	sub    $0x8,%esp
  802b8b:	68 c6 2b 80 00       	push   $0x802bc6
  802b90:	6a 00                	push   $0x0
  802b92:	e8 ff e2 ff ff       	call   800e96 <sys_env_set_pgfault_upcall>
  802b97:	83 c4 10             	add    $0x10,%esp
  802b9a:	85 c0                	test   %eax,%eax
  802b9c:	79 c8                	jns    802b66 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  802b9e:	83 ec 04             	sub    $0x4,%esp
  802ba1:	68 34 36 80 00       	push   $0x803634
  802ba6:	6a 25                	push   $0x25
  802ba8:	68 6c 36 80 00       	push   $0x80366c
  802bad:	e8 52 d6 ff ff       	call   800204 <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  802bb2:	83 ec 04             	sub    $0x4,%esp
  802bb5:	68 08 36 80 00       	push   $0x803608
  802bba:	6a 22                	push   $0x22
  802bbc:	68 6c 36 80 00       	push   $0x80366c
  802bc1:	e8 3e d6 ff ff       	call   800204 <_panic>

00802bc6 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802bc6:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802bc7:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802bcc:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802bce:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  802bd1:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  802bd5:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  802bd9:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802bdc:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  802bde:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  802be2:	83 c4 08             	add    $0x8,%esp
	popal
  802be5:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  802be6:	83 c4 04             	add    $0x4,%esp
	popfl
  802be9:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  802bea:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  802beb:	c3                   	ret    

00802bec <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802bec:	f3 0f 1e fb          	endbr32 
  802bf0:	55                   	push   %ebp
  802bf1:	89 e5                	mov    %esp,%ebp
  802bf3:	56                   	push   %esi
  802bf4:	53                   	push   %ebx
  802bf5:	8b 75 08             	mov    0x8(%ebp),%esi
  802bf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bfb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  802bfe:	85 c0                	test   %eax,%eax
  802c00:	74 3d                	je     802c3f <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  802c02:	83 ec 0c             	sub    $0xc,%esp
  802c05:	50                   	push   %eax
  802c06:	e8 f8 e2 ff ff       	call   800f03 <sys_ipc_recv>
  802c0b:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  802c0e:	85 f6                	test   %esi,%esi
  802c10:	74 0b                	je     802c1d <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  802c12:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802c18:	8b 52 74             	mov    0x74(%edx),%edx
  802c1b:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  802c1d:	85 db                	test   %ebx,%ebx
  802c1f:	74 0b                	je     802c2c <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  802c21:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802c27:	8b 52 78             	mov    0x78(%edx),%edx
  802c2a:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  802c2c:	85 c0                	test   %eax,%eax
  802c2e:	78 21                	js     802c51 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  802c30:	a1 08 50 80 00       	mov    0x805008,%eax
  802c35:	8b 40 70             	mov    0x70(%eax),%eax
}
  802c38:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802c3b:	5b                   	pop    %ebx
  802c3c:	5e                   	pop    %esi
  802c3d:	5d                   	pop    %ebp
  802c3e:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  802c3f:	83 ec 0c             	sub    $0xc,%esp
  802c42:	68 00 00 c0 ee       	push   $0xeec00000
  802c47:	e8 b7 e2 ff ff       	call   800f03 <sys_ipc_recv>
  802c4c:	83 c4 10             	add    $0x10,%esp
  802c4f:	eb bd                	jmp    802c0e <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  802c51:	85 f6                	test   %esi,%esi
  802c53:	74 10                	je     802c65 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  802c55:	85 db                	test   %ebx,%ebx
  802c57:	75 df                	jne    802c38 <ipc_recv+0x4c>
  802c59:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802c60:	00 00 00 
  802c63:	eb d3                	jmp    802c38 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  802c65:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802c6c:	00 00 00 
  802c6f:	eb e4                	jmp    802c55 <ipc_recv+0x69>

00802c71 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802c71:	f3 0f 1e fb          	endbr32 
  802c75:	55                   	push   %ebp
  802c76:	89 e5                	mov    %esp,%ebp
  802c78:	57                   	push   %edi
  802c79:	56                   	push   %esi
  802c7a:	53                   	push   %ebx
  802c7b:	83 ec 0c             	sub    $0xc,%esp
  802c7e:	8b 7d 08             	mov    0x8(%ebp),%edi
  802c81:	8b 75 0c             	mov    0xc(%ebp),%esi
  802c84:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  802c87:	85 db                	test   %ebx,%ebx
  802c89:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802c8e:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  802c91:	ff 75 14             	pushl  0x14(%ebp)
  802c94:	53                   	push   %ebx
  802c95:	56                   	push   %esi
  802c96:	57                   	push   %edi
  802c97:	e8 40 e2 ff ff       	call   800edc <sys_ipc_try_send>
  802c9c:	83 c4 10             	add    $0x10,%esp
  802c9f:	85 c0                	test   %eax,%eax
  802ca1:	79 1e                	jns    802cc1 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  802ca3:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802ca6:	75 07                	jne    802caf <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  802ca8:	e8 67 e0 ff ff       	call   800d14 <sys_yield>
  802cad:	eb e2                	jmp    802c91 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  802caf:	50                   	push   %eax
  802cb0:	68 7a 36 80 00       	push   $0x80367a
  802cb5:	6a 59                	push   $0x59
  802cb7:	68 95 36 80 00       	push   $0x803695
  802cbc:	e8 43 d5 ff ff       	call   800204 <_panic>
	}
}
  802cc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802cc4:	5b                   	pop    %ebx
  802cc5:	5e                   	pop    %esi
  802cc6:	5f                   	pop    %edi
  802cc7:	5d                   	pop    %ebp
  802cc8:	c3                   	ret    

00802cc9 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802cc9:	f3 0f 1e fb          	endbr32 
  802ccd:	55                   	push   %ebp
  802cce:	89 e5                	mov    %esp,%ebp
  802cd0:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802cd3:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802cd8:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802cdb:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802ce1:	8b 52 50             	mov    0x50(%edx),%edx
  802ce4:	39 ca                	cmp    %ecx,%edx
  802ce6:	74 11                	je     802cf9 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802ce8:	83 c0 01             	add    $0x1,%eax
  802ceb:	3d 00 04 00 00       	cmp    $0x400,%eax
  802cf0:	75 e6                	jne    802cd8 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802cf2:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf7:	eb 0b                	jmp    802d04 <ipc_find_env+0x3b>
			return envs[i].env_id;
  802cf9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802cfc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802d01:	8b 40 48             	mov    0x48(%eax),%eax
}
  802d04:	5d                   	pop    %ebp
  802d05:	c3                   	ret    

00802d06 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802d06:	f3 0f 1e fb          	endbr32 
  802d0a:	55                   	push   %ebp
  802d0b:	89 e5                	mov    %esp,%ebp
  802d0d:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802d10:	89 c2                	mov    %eax,%edx
  802d12:	c1 ea 16             	shr    $0x16,%edx
  802d15:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802d1c:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802d21:	f6 c1 01             	test   $0x1,%cl
  802d24:	74 1c                	je     802d42 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802d26:	c1 e8 0c             	shr    $0xc,%eax
  802d29:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802d30:	a8 01                	test   $0x1,%al
  802d32:	74 0e                	je     802d42 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802d34:	c1 e8 0c             	shr    $0xc,%eax
  802d37:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802d3e:	ef 
  802d3f:	0f b7 d2             	movzwl %dx,%edx
}
  802d42:	89 d0                	mov    %edx,%eax
  802d44:	5d                   	pop    %ebp
  802d45:	c3                   	ret    
  802d46:	66 90                	xchg   %ax,%ax
  802d48:	66 90                	xchg   %ax,%ax
  802d4a:	66 90                	xchg   %ax,%ax
  802d4c:	66 90                	xchg   %ax,%ax
  802d4e:	66 90                	xchg   %ax,%ax

00802d50 <__udivdi3>:
  802d50:	f3 0f 1e fb          	endbr32 
  802d54:	55                   	push   %ebp
  802d55:	57                   	push   %edi
  802d56:	56                   	push   %esi
  802d57:	53                   	push   %ebx
  802d58:	83 ec 1c             	sub    $0x1c,%esp
  802d5b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802d5f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802d63:	8b 74 24 34          	mov    0x34(%esp),%esi
  802d67:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802d6b:	85 d2                	test   %edx,%edx
  802d6d:	75 19                	jne    802d88 <__udivdi3+0x38>
  802d6f:	39 f3                	cmp    %esi,%ebx
  802d71:	76 4d                	jbe    802dc0 <__udivdi3+0x70>
  802d73:	31 ff                	xor    %edi,%edi
  802d75:	89 e8                	mov    %ebp,%eax
  802d77:	89 f2                	mov    %esi,%edx
  802d79:	f7 f3                	div    %ebx
  802d7b:	89 fa                	mov    %edi,%edx
  802d7d:	83 c4 1c             	add    $0x1c,%esp
  802d80:	5b                   	pop    %ebx
  802d81:	5e                   	pop    %esi
  802d82:	5f                   	pop    %edi
  802d83:	5d                   	pop    %ebp
  802d84:	c3                   	ret    
  802d85:	8d 76 00             	lea    0x0(%esi),%esi
  802d88:	39 f2                	cmp    %esi,%edx
  802d8a:	76 14                	jbe    802da0 <__udivdi3+0x50>
  802d8c:	31 ff                	xor    %edi,%edi
  802d8e:	31 c0                	xor    %eax,%eax
  802d90:	89 fa                	mov    %edi,%edx
  802d92:	83 c4 1c             	add    $0x1c,%esp
  802d95:	5b                   	pop    %ebx
  802d96:	5e                   	pop    %esi
  802d97:	5f                   	pop    %edi
  802d98:	5d                   	pop    %ebp
  802d99:	c3                   	ret    
  802d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802da0:	0f bd fa             	bsr    %edx,%edi
  802da3:	83 f7 1f             	xor    $0x1f,%edi
  802da6:	75 48                	jne    802df0 <__udivdi3+0xa0>
  802da8:	39 f2                	cmp    %esi,%edx
  802daa:	72 06                	jb     802db2 <__udivdi3+0x62>
  802dac:	31 c0                	xor    %eax,%eax
  802dae:	39 eb                	cmp    %ebp,%ebx
  802db0:	77 de                	ja     802d90 <__udivdi3+0x40>
  802db2:	b8 01 00 00 00       	mov    $0x1,%eax
  802db7:	eb d7                	jmp    802d90 <__udivdi3+0x40>
  802db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802dc0:	89 d9                	mov    %ebx,%ecx
  802dc2:	85 db                	test   %ebx,%ebx
  802dc4:	75 0b                	jne    802dd1 <__udivdi3+0x81>
  802dc6:	b8 01 00 00 00       	mov    $0x1,%eax
  802dcb:	31 d2                	xor    %edx,%edx
  802dcd:	f7 f3                	div    %ebx
  802dcf:	89 c1                	mov    %eax,%ecx
  802dd1:	31 d2                	xor    %edx,%edx
  802dd3:	89 f0                	mov    %esi,%eax
  802dd5:	f7 f1                	div    %ecx
  802dd7:	89 c6                	mov    %eax,%esi
  802dd9:	89 e8                	mov    %ebp,%eax
  802ddb:	89 f7                	mov    %esi,%edi
  802ddd:	f7 f1                	div    %ecx
  802ddf:	89 fa                	mov    %edi,%edx
  802de1:	83 c4 1c             	add    $0x1c,%esp
  802de4:	5b                   	pop    %ebx
  802de5:	5e                   	pop    %esi
  802de6:	5f                   	pop    %edi
  802de7:	5d                   	pop    %ebp
  802de8:	c3                   	ret    
  802de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802df0:	89 f9                	mov    %edi,%ecx
  802df2:	b8 20 00 00 00       	mov    $0x20,%eax
  802df7:	29 f8                	sub    %edi,%eax
  802df9:	d3 e2                	shl    %cl,%edx
  802dfb:	89 54 24 08          	mov    %edx,0x8(%esp)
  802dff:	89 c1                	mov    %eax,%ecx
  802e01:	89 da                	mov    %ebx,%edx
  802e03:	d3 ea                	shr    %cl,%edx
  802e05:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802e09:	09 d1                	or     %edx,%ecx
  802e0b:	89 f2                	mov    %esi,%edx
  802e0d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802e11:	89 f9                	mov    %edi,%ecx
  802e13:	d3 e3                	shl    %cl,%ebx
  802e15:	89 c1                	mov    %eax,%ecx
  802e17:	d3 ea                	shr    %cl,%edx
  802e19:	89 f9                	mov    %edi,%ecx
  802e1b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802e1f:	89 eb                	mov    %ebp,%ebx
  802e21:	d3 e6                	shl    %cl,%esi
  802e23:	89 c1                	mov    %eax,%ecx
  802e25:	d3 eb                	shr    %cl,%ebx
  802e27:	09 de                	or     %ebx,%esi
  802e29:	89 f0                	mov    %esi,%eax
  802e2b:	f7 74 24 08          	divl   0x8(%esp)
  802e2f:	89 d6                	mov    %edx,%esi
  802e31:	89 c3                	mov    %eax,%ebx
  802e33:	f7 64 24 0c          	mull   0xc(%esp)
  802e37:	39 d6                	cmp    %edx,%esi
  802e39:	72 15                	jb     802e50 <__udivdi3+0x100>
  802e3b:	89 f9                	mov    %edi,%ecx
  802e3d:	d3 e5                	shl    %cl,%ebp
  802e3f:	39 c5                	cmp    %eax,%ebp
  802e41:	73 04                	jae    802e47 <__udivdi3+0xf7>
  802e43:	39 d6                	cmp    %edx,%esi
  802e45:	74 09                	je     802e50 <__udivdi3+0x100>
  802e47:	89 d8                	mov    %ebx,%eax
  802e49:	31 ff                	xor    %edi,%edi
  802e4b:	e9 40 ff ff ff       	jmp    802d90 <__udivdi3+0x40>
  802e50:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802e53:	31 ff                	xor    %edi,%edi
  802e55:	e9 36 ff ff ff       	jmp    802d90 <__udivdi3+0x40>
  802e5a:	66 90                	xchg   %ax,%ax
  802e5c:	66 90                	xchg   %ax,%ax
  802e5e:	66 90                	xchg   %ax,%ax

00802e60 <__umoddi3>:
  802e60:	f3 0f 1e fb          	endbr32 
  802e64:	55                   	push   %ebp
  802e65:	57                   	push   %edi
  802e66:	56                   	push   %esi
  802e67:	53                   	push   %ebx
  802e68:	83 ec 1c             	sub    $0x1c,%esp
  802e6b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802e6f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802e73:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802e77:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802e7b:	85 c0                	test   %eax,%eax
  802e7d:	75 19                	jne    802e98 <__umoddi3+0x38>
  802e7f:	39 df                	cmp    %ebx,%edi
  802e81:	76 5d                	jbe    802ee0 <__umoddi3+0x80>
  802e83:	89 f0                	mov    %esi,%eax
  802e85:	89 da                	mov    %ebx,%edx
  802e87:	f7 f7                	div    %edi
  802e89:	89 d0                	mov    %edx,%eax
  802e8b:	31 d2                	xor    %edx,%edx
  802e8d:	83 c4 1c             	add    $0x1c,%esp
  802e90:	5b                   	pop    %ebx
  802e91:	5e                   	pop    %esi
  802e92:	5f                   	pop    %edi
  802e93:	5d                   	pop    %ebp
  802e94:	c3                   	ret    
  802e95:	8d 76 00             	lea    0x0(%esi),%esi
  802e98:	89 f2                	mov    %esi,%edx
  802e9a:	39 d8                	cmp    %ebx,%eax
  802e9c:	76 12                	jbe    802eb0 <__umoddi3+0x50>
  802e9e:	89 f0                	mov    %esi,%eax
  802ea0:	89 da                	mov    %ebx,%edx
  802ea2:	83 c4 1c             	add    $0x1c,%esp
  802ea5:	5b                   	pop    %ebx
  802ea6:	5e                   	pop    %esi
  802ea7:	5f                   	pop    %edi
  802ea8:	5d                   	pop    %ebp
  802ea9:	c3                   	ret    
  802eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802eb0:	0f bd e8             	bsr    %eax,%ebp
  802eb3:	83 f5 1f             	xor    $0x1f,%ebp
  802eb6:	75 50                	jne    802f08 <__umoddi3+0xa8>
  802eb8:	39 d8                	cmp    %ebx,%eax
  802eba:	0f 82 e0 00 00 00    	jb     802fa0 <__umoddi3+0x140>
  802ec0:	89 d9                	mov    %ebx,%ecx
  802ec2:	39 f7                	cmp    %esi,%edi
  802ec4:	0f 86 d6 00 00 00    	jbe    802fa0 <__umoddi3+0x140>
  802eca:	89 d0                	mov    %edx,%eax
  802ecc:	89 ca                	mov    %ecx,%edx
  802ece:	83 c4 1c             	add    $0x1c,%esp
  802ed1:	5b                   	pop    %ebx
  802ed2:	5e                   	pop    %esi
  802ed3:	5f                   	pop    %edi
  802ed4:	5d                   	pop    %ebp
  802ed5:	c3                   	ret    
  802ed6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802edd:	8d 76 00             	lea    0x0(%esi),%esi
  802ee0:	89 fd                	mov    %edi,%ebp
  802ee2:	85 ff                	test   %edi,%edi
  802ee4:	75 0b                	jne    802ef1 <__umoddi3+0x91>
  802ee6:	b8 01 00 00 00       	mov    $0x1,%eax
  802eeb:	31 d2                	xor    %edx,%edx
  802eed:	f7 f7                	div    %edi
  802eef:	89 c5                	mov    %eax,%ebp
  802ef1:	89 d8                	mov    %ebx,%eax
  802ef3:	31 d2                	xor    %edx,%edx
  802ef5:	f7 f5                	div    %ebp
  802ef7:	89 f0                	mov    %esi,%eax
  802ef9:	f7 f5                	div    %ebp
  802efb:	89 d0                	mov    %edx,%eax
  802efd:	31 d2                	xor    %edx,%edx
  802eff:	eb 8c                	jmp    802e8d <__umoddi3+0x2d>
  802f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802f08:	89 e9                	mov    %ebp,%ecx
  802f0a:	ba 20 00 00 00       	mov    $0x20,%edx
  802f0f:	29 ea                	sub    %ebp,%edx
  802f11:	d3 e0                	shl    %cl,%eax
  802f13:	89 44 24 08          	mov    %eax,0x8(%esp)
  802f17:	89 d1                	mov    %edx,%ecx
  802f19:	89 f8                	mov    %edi,%eax
  802f1b:	d3 e8                	shr    %cl,%eax
  802f1d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802f21:	89 54 24 04          	mov    %edx,0x4(%esp)
  802f25:	8b 54 24 04          	mov    0x4(%esp),%edx
  802f29:	09 c1                	or     %eax,%ecx
  802f2b:	89 d8                	mov    %ebx,%eax
  802f2d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802f31:	89 e9                	mov    %ebp,%ecx
  802f33:	d3 e7                	shl    %cl,%edi
  802f35:	89 d1                	mov    %edx,%ecx
  802f37:	d3 e8                	shr    %cl,%eax
  802f39:	89 e9                	mov    %ebp,%ecx
  802f3b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802f3f:	d3 e3                	shl    %cl,%ebx
  802f41:	89 c7                	mov    %eax,%edi
  802f43:	89 d1                	mov    %edx,%ecx
  802f45:	89 f0                	mov    %esi,%eax
  802f47:	d3 e8                	shr    %cl,%eax
  802f49:	89 e9                	mov    %ebp,%ecx
  802f4b:	89 fa                	mov    %edi,%edx
  802f4d:	d3 e6                	shl    %cl,%esi
  802f4f:	09 d8                	or     %ebx,%eax
  802f51:	f7 74 24 08          	divl   0x8(%esp)
  802f55:	89 d1                	mov    %edx,%ecx
  802f57:	89 f3                	mov    %esi,%ebx
  802f59:	f7 64 24 0c          	mull   0xc(%esp)
  802f5d:	89 c6                	mov    %eax,%esi
  802f5f:	89 d7                	mov    %edx,%edi
  802f61:	39 d1                	cmp    %edx,%ecx
  802f63:	72 06                	jb     802f6b <__umoddi3+0x10b>
  802f65:	75 10                	jne    802f77 <__umoddi3+0x117>
  802f67:	39 c3                	cmp    %eax,%ebx
  802f69:	73 0c                	jae    802f77 <__umoddi3+0x117>
  802f6b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802f6f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802f73:	89 d7                	mov    %edx,%edi
  802f75:	89 c6                	mov    %eax,%esi
  802f77:	89 ca                	mov    %ecx,%edx
  802f79:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802f7e:	29 f3                	sub    %esi,%ebx
  802f80:	19 fa                	sbb    %edi,%edx
  802f82:	89 d0                	mov    %edx,%eax
  802f84:	d3 e0                	shl    %cl,%eax
  802f86:	89 e9                	mov    %ebp,%ecx
  802f88:	d3 eb                	shr    %cl,%ebx
  802f8a:	d3 ea                	shr    %cl,%edx
  802f8c:	09 d8                	or     %ebx,%eax
  802f8e:	83 c4 1c             	add    $0x1c,%esp
  802f91:	5b                   	pop    %ebx
  802f92:	5e                   	pop    %esi
  802f93:	5f                   	pop    %edi
  802f94:	5d                   	pop    %ebp
  802f95:	c3                   	ret    
  802f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802f9d:	8d 76 00             	lea    0x0(%esi),%esi
  802fa0:	29 fe                	sub    %edi,%esi
  802fa2:	19 c3                	sbb    %eax,%ebx
  802fa4:	89 f2                	mov    %esi,%edx
  802fa6:	89 d9                	mov    %ebx,%ecx
  802fa8:	e9 1d ff ff ff       	jmp    802eca <__umoddi3+0x6a>
