
obj/user/sendpage.debug:     file format elf32-i386


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
  80002c:	e8 77 01 00 00       	call   8001a8 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#define TEMP_ADDR	((char*)0xa00000)
#define TEMP_ADDR_CHILD	((char*)0xb00000)

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	83 ec 18             	sub    $0x18,%esp
	envid_t who;

	if ((who = fork()) == 0) {
  80003d:	e8 a8 0f 00 00       	call   800fea <fork>
  800042:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800045:	85 c0                	test   %eax,%eax
  800047:	0f 84 a5 00 00 00    	je     8000f2 <umain+0xbf>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
		return;
	}

	// Parent
	sys_page_alloc(thisenv->env_id, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  80004d:	a1 04 40 80 00       	mov    0x804004,%eax
  800052:	8b 40 48             	mov    0x48(%eax),%eax
  800055:	83 ec 04             	sub    $0x4,%esp
  800058:	6a 07                	push   $0x7
  80005a:	68 00 00 a0 00       	push   $0xa00000
  80005f:	50                   	push   %eax
  800060:	e8 94 0c 00 00       	call   800cf9 <sys_page_alloc>
	memcpy(TEMP_ADDR, str1, strlen(str1) + 1);
  800065:	83 c4 04             	add    $0x4,%esp
  800068:	ff 35 04 30 80 00    	pushl  0x803004
  80006e:	e8 01 08 00 00       	call   800874 <strlen>
  800073:	83 c4 0c             	add    $0xc,%esp
  800076:	83 c0 01             	add    $0x1,%eax
  800079:	50                   	push   %eax
  80007a:	ff 35 04 30 80 00    	pushl  0x803004
  800080:	68 00 00 a0 00       	push   $0xa00000
  800085:	e8 49 0a 00 00       	call   800ad3 <memcpy>
	ipc_send(who, 0, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  80008a:	6a 07                	push   $0x7
  80008c:	68 00 00 a0 00       	push   $0xa00000
  800091:	6a 00                	push   $0x0
  800093:	ff 75 f4             	pushl  -0xc(%ebp)
  800096:	e8 ed 11 00 00       	call   801288 <ipc_send>

	ipc_recv(&who, TEMP_ADDR, 0);
  80009b:	83 c4 1c             	add    $0x1c,%esp
  80009e:	6a 00                	push   $0x0
  8000a0:	68 00 00 a0 00       	push   $0xa00000
  8000a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000a8:	50                   	push   %eax
  8000a9:	e8 55 11 00 00       	call   801203 <ipc_recv>
	cprintf("%x got message: %s\n", who, TEMP_ADDR);
  8000ae:	83 c4 0c             	add    $0xc,%esp
  8000b1:	68 00 00 a0 00       	push   $0xa00000
  8000b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b9:	68 00 24 80 00       	push   $0x802400
  8000be:	e8 ea 01 00 00       	call   8002ad <cprintf>
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
  8000c3:	83 c4 04             	add    $0x4,%esp
  8000c6:	ff 35 00 30 80 00    	pushl  0x803000
  8000cc:	e8 a3 07 00 00       	call   800874 <strlen>
  8000d1:	83 c4 0c             	add    $0xc,%esp
  8000d4:	50                   	push   %eax
  8000d5:	ff 35 00 30 80 00    	pushl  0x803000
  8000db:	68 00 00 a0 00       	push   $0xa00000
  8000e0:	e8 bb 08 00 00       	call   8009a0 <strncmp>
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	85 c0                	test   %eax,%eax
  8000ea:	0f 84 a3 00 00 00    	je     800193 <umain+0x160>
		cprintf("parent received correct message\n");
	return;
}
  8000f0:	c9                   	leave  
  8000f1:	c3                   	ret    
		ipc_recv(&who, TEMP_ADDR_CHILD, 0);
  8000f2:	83 ec 04             	sub    $0x4,%esp
  8000f5:	6a 00                	push   $0x0
  8000f7:	68 00 00 b0 00       	push   $0xb00000
  8000fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000ff:	50                   	push   %eax
  800100:	e8 fe 10 00 00       	call   801203 <ipc_recv>
		cprintf("%x got message: %s\n", who, TEMP_ADDR_CHILD);
  800105:	83 c4 0c             	add    $0xc,%esp
  800108:	68 00 00 b0 00       	push   $0xb00000
  80010d:	ff 75 f4             	pushl  -0xc(%ebp)
  800110:	68 00 24 80 00       	push   $0x802400
  800115:	e8 93 01 00 00       	call   8002ad <cprintf>
		if (strncmp(TEMP_ADDR_CHILD, str1, strlen(str1)) == 0)
  80011a:	83 c4 04             	add    $0x4,%esp
  80011d:	ff 35 04 30 80 00    	pushl  0x803004
  800123:	e8 4c 07 00 00       	call   800874 <strlen>
  800128:	83 c4 0c             	add    $0xc,%esp
  80012b:	50                   	push   %eax
  80012c:	ff 35 04 30 80 00    	pushl  0x803004
  800132:	68 00 00 b0 00       	push   $0xb00000
  800137:	e8 64 08 00 00       	call   8009a0 <strncmp>
  80013c:	83 c4 10             	add    $0x10,%esp
  80013f:	85 c0                	test   %eax,%eax
  800141:	74 3e                	je     800181 <umain+0x14e>
		memcpy(TEMP_ADDR_CHILD, str2, strlen(str2) + 1);
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	ff 35 00 30 80 00    	pushl  0x803000
  80014c:	e8 23 07 00 00       	call   800874 <strlen>
  800151:	83 c4 0c             	add    $0xc,%esp
  800154:	83 c0 01             	add    $0x1,%eax
  800157:	50                   	push   %eax
  800158:	ff 35 00 30 80 00    	pushl  0x803000
  80015e:	68 00 00 b0 00       	push   $0xb00000
  800163:	e8 6b 09 00 00       	call   800ad3 <memcpy>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
  800168:	6a 07                	push   $0x7
  80016a:	68 00 00 b0 00       	push   $0xb00000
  80016f:	6a 00                	push   $0x0
  800171:	ff 75 f4             	pushl  -0xc(%ebp)
  800174:	e8 0f 11 00 00       	call   801288 <ipc_send>
		return;
  800179:	83 c4 20             	add    $0x20,%esp
  80017c:	e9 6f ff ff ff       	jmp    8000f0 <umain+0xbd>
			cprintf("child received correct message\n");
  800181:	83 ec 0c             	sub    $0xc,%esp
  800184:	68 14 24 80 00       	push   $0x802414
  800189:	e8 1f 01 00 00       	call   8002ad <cprintf>
  80018e:	83 c4 10             	add    $0x10,%esp
  800191:	eb b0                	jmp    800143 <umain+0x110>
		cprintf("parent received correct message\n");
  800193:	83 ec 0c             	sub    $0xc,%esp
  800196:	68 34 24 80 00       	push   $0x802434
  80019b:	e8 0d 01 00 00       	call   8002ad <cprintf>
  8001a0:	83 c4 10             	add    $0x10,%esp
  8001a3:	e9 48 ff ff ff       	jmp    8000f0 <umain+0xbd>

008001a8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001a8:	f3 0f 1e fb          	endbr32 
  8001ac:	55                   	push   %ebp
  8001ad:	89 e5                	mov    %esp,%ebp
  8001af:	56                   	push   %esi
  8001b0:	53                   	push   %ebx
  8001b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001b4:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001b7:	e8 f7 0a 00 00       	call   800cb3 <sys_getenvid>
  8001bc:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001c1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001c4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001c9:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ce:	85 db                	test   %ebx,%ebx
  8001d0:	7e 07                	jle    8001d9 <libmain+0x31>
		binaryname = argv[0];
  8001d2:	8b 06                	mov    (%esi),%eax
  8001d4:	a3 08 30 80 00       	mov    %eax,0x803008

	// call user main routine
	umain(argc, argv);
  8001d9:	83 ec 08             	sub    $0x8,%esp
  8001dc:	56                   	push   %esi
  8001dd:	53                   	push   %ebx
  8001de:	e8 50 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8001e3:	e8 0a 00 00 00       	call   8001f2 <exit>
}
  8001e8:	83 c4 10             	add    $0x10,%esp
  8001eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001ee:	5b                   	pop    %ebx
  8001ef:	5e                   	pop    %esi
  8001f0:	5d                   	pop    %ebp
  8001f1:	c3                   	ret    

008001f2 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001f2:	f3 0f 1e fb          	endbr32 
  8001f6:	55                   	push   %ebp
  8001f7:	89 e5                	mov    %esp,%ebp
  8001f9:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8001fc:	e8 0b 13 00 00       	call   80150c <close_all>
	sys_env_destroy(0);
  800201:	83 ec 0c             	sub    $0xc,%esp
  800204:	6a 00                	push   $0x0
  800206:	e8 63 0a 00 00       	call   800c6e <sys_env_destroy>
}
  80020b:	83 c4 10             	add    $0x10,%esp
  80020e:	c9                   	leave  
  80020f:	c3                   	ret    

00800210 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800210:	f3 0f 1e fb          	endbr32 
  800214:	55                   	push   %ebp
  800215:	89 e5                	mov    %esp,%ebp
  800217:	53                   	push   %ebx
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80021e:	8b 13                	mov    (%ebx),%edx
  800220:	8d 42 01             	lea    0x1(%edx),%eax
  800223:	89 03                	mov    %eax,(%ebx)
  800225:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800228:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80022c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800231:	74 09                	je     80023c <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800233:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800237:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80023a:	c9                   	leave  
  80023b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80023c:	83 ec 08             	sub    $0x8,%esp
  80023f:	68 ff 00 00 00       	push   $0xff
  800244:	8d 43 08             	lea    0x8(%ebx),%eax
  800247:	50                   	push   %eax
  800248:	e8 dc 09 00 00       	call   800c29 <sys_cputs>
		b->idx = 0;
  80024d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800253:	83 c4 10             	add    $0x10,%esp
  800256:	eb db                	jmp    800233 <putch+0x23>

00800258 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800258:	f3 0f 1e fb          	endbr32 
  80025c:	55                   	push   %ebp
  80025d:	89 e5                	mov    %esp,%ebp
  80025f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800265:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80026c:	00 00 00 
	b.cnt = 0;
  80026f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800276:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800279:	ff 75 0c             	pushl  0xc(%ebp)
  80027c:	ff 75 08             	pushl  0x8(%ebp)
  80027f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800285:	50                   	push   %eax
  800286:	68 10 02 80 00       	push   $0x800210
  80028b:	e8 20 01 00 00       	call   8003b0 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800290:	83 c4 08             	add    $0x8,%esp
  800293:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800299:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80029f:	50                   	push   %eax
  8002a0:	e8 84 09 00 00       	call   800c29 <sys_cputs>

	return b.cnt;
}
  8002a5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002ab:	c9                   	leave  
  8002ac:	c3                   	ret    

008002ad <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002ad:	f3 0f 1e fb          	endbr32 
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002b7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002ba:	50                   	push   %eax
  8002bb:	ff 75 08             	pushl  0x8(%ebp)
  8002be:	e8 95 ff ff ff       	call   800258 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002c3:	c9                   	leave  
  8002c4:	c3                   	ret    

008002c5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002c5:	55                   	push   %ebp
  8002c6:	89 e5                	mov    %esp,%ebp
  8002c8:	57                   	push   %edi
  8002c9:	56                   	push   %esi
  8002ca:	53                   	push   %ebx
  8002cb:	83 ec 1c             	sub    $0x1c,%esp
  8002ce:	89 c7                	mov    %eax,%edi
  8002d0:	89 d6                	mov    %edx,%esi
  8002d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002d8:	89 d1                	mov    %edx,%ecx
  8002da:	89 c2                	mov    %eax,%edx
  8002dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002df:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e5:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002eb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8002f2:	39 c2                	cmp    %eax,%edx
  8002f4:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8002f7:	72 3e                	jb     800337 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002f9:	83 ec 0c             	sub    $0xc,%esp
  8002fc:	ff 75 18             	pushl  0x18(%ebp)
  8002ff:	83 eb 01             	sub    $0x1,%ebx
  800302:	53                   	push   %ebx
  800303:	50                   	push   %eax
  800304:	83 ec 08             	sub    $0x8,%esp
  800307:	ff 75 e4             	pushl  -0x1c(%ebp)
  80030a:	ff 75 e0             	pushl  -0x20(%ebp)
  80030d:	ff 75 dc             	pushl  -0x24(%ebp)
  800310:	ff 75 d8             	pushl  -0x28(%ebp)
  800313:	e8 78 1e 00 00       	call   802190 <__udivdi3>
  800318:	83 c4 18             	add    $0x18,%esp
  80031b:	52                   	push   %edx
  80031c:	50                   	push   %eax
  80031d:	89 f2                	mov    %esi,%edx
  80031f:	89 f8                	mov    %edi,%eax
  800321:	e8 9f ff ff ff       	call   8002c5 <printnum>
  800326:	83 c4 20             	add    $0x20,%esp
  800329:	eb 13                	jmp    80033e <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80032b:	83 ec 08             	sub    $0x8,%esp
  80032e:	56                   	push   %esi
  80032f:	ff 75 18             	pushl  0x18(%ebp)
  800332:	ff d7                	call   *%edi
  800334:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800337:	83 eb 01             	sub    $0x1,%ebx
  80033a:	85 db                	test   %ebx,%ebx
  80033c:	7f ed                	jg     80032b <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80033e:	83 ec 08             	sub    $0x8,%esp
  800341:	56                   	push   %esi
  800342:	83 ec 04             	sub    $0x4,%esp
  800345:	ff 75 e4             	pushl  -0x1c(%ebp)
  800348:	ff 75 e0             	pushl  -0x20(%ebp)
  80034b:	ff 75 dc             	pushl  -0x24(%ebp)
  80034e:	ff 75 d8             	pushl  -0x28(%ebp)
  800351:	e8 4a 1f 00 00       	call   8022a0 <__umoddi3>
  800356:	83 c4 14             	add    $0x14,%esp
  800359:	0f be 80 ac 24 80 00 	movsbl 0x8024ac(%eax),%eax
  800360:	50                   	push   %eax
  800361:	ff d7                	call   *%edi
}
  800363:	83 c4 10             	add    $0x10,%esp
  800366:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800369:	5b                   	pop    %ebx
  80036a:	5e                   	pop    %esi
  80036b:	5f                   	pop    %edi
  80036c:	5d                   	pop    %ebp
  80036d:	c3                   	ret    

0080036e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80036e:	f3 0f 1e fb          	endbr32 
  800372:	55                   	push   %ebp
  800373:	89 e5                	mov    %esp,%ebp
  800375:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800378:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80037c:	8b 10                	mov    (%eax),%edx
  80037e:	3b 50 04             	cmp    0x4(%eax),%edx
  800381:	73 0a                	jae    80038d <sprintputch+0x1f>
		*b->buf++ = ch;
  800383:	8d 4a 01             	lea    0x1(%edx),%ecx
  800386:	89 08                	mov    %ecx,(%eax)
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	88 02                	mov    %al,(%edx)
}
  80038d:	5d                   	pop    %ebp
  80038e:	c3                   	ret    

0080038f <printfmt>:
{
  80038f:	f3 0f 1e fb          	endbr32 
  800393:	55                   	push   %ebp
  800394:	89 e5                	mov    %esp,%ebp
  800396:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800399:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80039c:	50                   	push   %eax
  80039d:	ff 75 10             	pushl  0x10(%ebp)
  8003a0:	ff 75 0c             	pushl  0xc(%ebp)
  8003a3:	ff 75 08             	pushl  0x8(%ebp)
  8003a6:	e8 05 00 00 00       	call   8003b0 <vprintfmt>
}
  8003ab:	83 c4 10             	add    $0x10,%esp
  8003ae:	c9                   	leave  
  8003af:	c3                   	ret    

008003b0 <vprintfmt>:
{
  8003b0:	f3 0f 1e fb          	endbr32 
  8003b4:	55                   	push   %ebp
  8003b5:	89 e5                	mov    %esp,%ebp
  8003b7:	57                   	push   %edi
  8003b8:	56                   	push   %esi
  8003b9:	53                   	push   %ebx
  8003ba:	83 ec 3c             	sub    $0x3c,%esp
  8003bd:	8b 75 08             	mov    0x8(%ebp),%esi
  8003c0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003c3:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003c6:	e9 8e 03 00 00       	jmp    800759 <vprintfmt+0x3a9>
		padc = ' ';
  8003cb:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8003cf:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8003d6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003dd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003e4:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003e9:	8d 47 01             	lea    0x1(%edi),%eax
  8003ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003ef:	0f b6 17             	movzbl (%edi),%edx
  8003f2:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003f5:	3c 55                	cmp    $0x55,%al
  8003f7:	0f 87 df 03 00 00    	ja     8007dc <vprintfmt+0x42c>
  8003fd:	0f b6 c0             	movzbl %al,%eax
  800400:	3e ff 24 85 e0 25 80 	notrack jmp *0x8025e0(,%eax,4)
  800407:	00 
  800408:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80040b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80040f:	eb d8                	jmp    8003e9 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800411:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800414:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800418:	eb cf                	jmp    8003e9 <vprintfmt+0x39>
  80041a:	0f b6 d2             	movzbl %dl,%edx
  80041d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800420:	b8 00 00 00 00       	mov    $0x0,%eax
  800425:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800428:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80042b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80042f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800432:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800435:	83 f9 09             	cmp    $0x9,%ecx
  800438:	77 55                	ja     80048f <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  80043a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80043d:	eb e9                	jmp    800428 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80043f:	8b 45 14             	mov    0x14(%ebp),%eax
  800442:	8b 00                	mov    (%eax),%eax
  800444:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800447:	8b 45 14             	mov    0x14(%ebp),%eax
  80044a:	8d 40 04             	lea    0x4(%eax),%eax
  80044d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800450:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800453:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800457:	79 90                	jns    8003e9 <vprintfmt+0x39>
				width = precision, precision = -1;
  800459:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80045c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80045f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800466:	eb 81                	jmp    8003e9 <vprintfmt+0x39>
  800468:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80046b:	85 c0                	test   %eax,%eax
  80046d:	ba 00 00 00 00       	mov    $0x0,%edx
  800472:	0f 49 d0             	cmovns %eax,%edx
  800475:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800478:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80047b:	e9 69 ff ff ff       	jmp    8003e9 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800480:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800483:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80048a:	e9 5a ff ff ff       	jmp    8003e9 <vprintfmt+0x39>
  80048f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800492:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800495:	eb bc                	jmp    800453 <vprintfmt+0xa3>
			lflag++;
  800497:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80049a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80049d:	e9 47 ff ff ff       	jmp    8003e9 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8004a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a5:	8d 78 04             	lea    0x4(%eax),%edi
  8004a8:	83 ec 08             	sub    $0x8,%esp
  8004ab:	53                   	push   %ebx
  8004ac:	ff 30                	pushl  (%eax)
  8004ae:	ff d6                	call   *%esi
			break;
  8004b0:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004b3:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004b6:	e9 9b 02 00 00       	jmp    800756 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8004bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004be:	8d 78 04             	lea    0x4(%eax),%edi
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	99                   	cltd   
  8004c4:	31 d0                	xor    %edx,%eax
  8004c6:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004c8:	83 f8 0f             	cmp    $0xf,%eax
  8004cb:	7f 23                	jg     8004f0 <vprintfmt+0x140>
  8004cd:	8b 14 85 40 27 80 00 	mov    0x802740(,%eax,4),%edx
  8004d4:	85 d2                	test   %edx,%edx
  8004d6:	74 18                	je     8004f0 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8004d8:	52                   	push   %edx
  8004d9:	68 25 29 80 00       	push   $0x802925
  8004de:	53                   	push   %ebx
  8004df:	56                   	push   %esi
  8004e0:	e8 aa fe ff ff       	call   80038f <printfmt>
  8004e5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004e8:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004eb:	e9 66 02 00 00       	jmp    800756 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8004f0:	50                   	push   %eax
  8004f1:	68 c4 24 80 00       	push   $0x8024c4
  8004f6:	53                   	push   %ebx
  8004f7:	56                   	push   %esi
  8004f8:	e8 92 fe ff ff       	call   80038f <printfmt>
  8004fd:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800500:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800503:	e9 4e 02 00 00       	jmp    800756 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800508:	8b 45 14             	mov    0x14(%ebp),%eax
  80050b:	83 c0 04             	add    $0x4,%eax
  80050e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800511:	8b 45 14             	mov    0x14(%ebp),%eax
  800514:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800516:	85 d2                	test   %edx,%edx
  800518:	b8 bd 24 80 00       	mov    $0x8024bd,%eax
  80051d:	0f 45 c2             	cmovne %edx,%eax
  800520:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800523:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800527:	7e 06                	jle    80052f <vprintfmt+0x17f>
  800529:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80052d:	75 0d                	jne    80053c <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80052f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800532:	89 c7                	mov    %eax,%edi
  800534:	03 45 e0             	add    -0x20(%ebp),%eax
  800537:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80053a:	eb 55                	jmp    800591 <vprintfmt+0x1e1>
  80053c:	83 ec 08             	sub    $0x8,%esp
  80053f:	ff 75 d8             	pushl  -0x28(%ebp)
  800542:	ff 75 cc             	pushl  -0x34(%ebp)
  800545:	e8 46 03 00 00       	call   800890 <strnlen>
  80054a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80054d:	29 c2                	sub    %eax,%edx
  80054f:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800552:	83 c4 10             	add    $0x10,%esp
  800555:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800557:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80055b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80055e:	85 ff                	test   %edi,%edi
  800560:	7e 11                	jle    800573 <vprintfmt+0x1c3>
					putch(padc, putdat);
  800562:	83 ec 08             	sub    $0x8,%esp
  800565:	53                   	push   %ebx
  800566:	ff 75 e0             	pushl  -0x20(%ebp)
  800569:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80056b:	83 ef 01             	sub    $0x1,%edi
  80056e:	83 c4 10             	add    $0x10,%esp
  800571:	eb eb                	jmp    80055e <vprintfmt+0x1ae>
  800573:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800576:	85 d2                	test   %edx,%edx
  800578:	b8 00 00 00 00       	mov    $0x0,%eax
  80057d:	0f 49 c2             	cmovns %edx,%eax
  800580:	29 c2                	sub    %eax,%edx
  800582:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800585:	eb a8                	jmp    80052f <vprintfmt+0x17f>
					putch(ch, putdat);
  800587:	83 ec 08             	sub    $0x8,%esp
  80058a:	53                   	push   %ebx
  80058b:	52                   	push   %edx
  80058c:	ff d6                	call   *%esi
  80058e:	83 c4 10             	add    $0x10,%esp
  800591:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800594:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800596:	83 c7 01             	add    $0x1,%edi
  800599:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80059d:	0f be d0             	movsbl %al,%edx
  8005a0:	85 d2                	test   %edx,%edx
  8005a2:	74 4b                	je     8005ef <vprintfmt+0x23f>
  8005a4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005a8:	78 06                	js     8005b0 <vprintfmt+0x200>
  8005aa:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005ae:	78 1e                	js     8005ce <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8005b0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005b4:	74 d1                	je     800587 <vprintfmt+0x1d7>
  8005b6:	0f be c0             	movsbl %al,%eax
  8005b9:	83 e8 20             	sub    $0x20,%eax
  8005bc:	83 f8 5e             	cmp    $0x5e,%eax
  8005bf:	76 c6                	jbe    800587 <vprintfmt+0x1d7>
					putch('?', putdat);
  8005c1:	83 ec 08             	sub    $0x8,%esp
  8005c4:	53                   	push   %ebx
  8005c5:	6a 3f                	push   $0x3f
  8005c7:	ff d6                	call   *%esi
  8005c9:	83 c4 10             	add    $0x10,%esp
  8005cc:	eb c3                	jmp    800591 <vprintfmt+0x1e1>
  8005ce:	89 cf                	mov    %ecx,%edi
  8005d0:	eb 0e                	jmp    8005e0 <vprintfmt+0x230>
				putch(' ', putdat);
  8005d2:	83 ec 08             	sub    $0x8,%esp
  8005d5:	53                   	push   %ebx
  8005d6:	6a 20                	push   $0x20
  8005d8:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005da:	83 ef 01             	sub    $0x1,%edi
  8005dd:	83 c4 10             	add    $0x10,%esp
  8005e0:	85 ff                	test   %edi,%edi
  8005e2:	7f ee                	jg     8005d2 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8005e4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005e7:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ea:	e9 67 01 00 00       	jmp    800756 <vprintfmt+0x3a6>
  8005ef:	89 cf                	mov    %ecx,%edi
  8005f1:	eb ed                	jmp    8005e0 <vprintfmt+0x230>
	if (lflag >= 2)
  8005f3:	83 f9 01             	cmp    $0x1,%ecx
  8005f6:	7f 1b                	jg     800613 <vprintfmt+0x263>
	else if (lflag)
  8005f8:	85 c9                	test   %ecx,%ecx
  8005fa:	74 63                	je     80065f <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8005fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ff:	8b 00                	mov    (%eax),%eax
  800601:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800604:	99                   	cltd   
  800605:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800608:	8b 45 14             	mov    0x14(%ebp),%eax
  80060b:	8d 40 04             	lea    0x4(%eax),%eax
  80060e:	89 45 14             	mov    %eax,0x14(%ebp)
  800611:	eb 17                	jmp    80062a <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800613:	8b 45 14             	mov    0x14(%ebp),%eax
  800616:	8b 50 04             	mov    0x4(%eax),%edx
  800619:	8b 00                	mov    (%eax),%eax
  80061b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800621:	8b 45 14             	mov    0x14(%ebp),%eax
  800624:	8d 40 08             	lea    0x8(%eax),%eax
  800627:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80062a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80062d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800630:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800635:	85 c9                	test   %ecx,%ecx
  800637:	0f 89 ff 00 00 00    	jns    80073c <vprintfmt+0x38c>
				putch('-', putdat);
  80063d:	83 ec 08             	sub    $0x8,%esp
  800640:	53                   	push   %ebx
  800641:	6a 2d                	push   $0x2d
  800643:	ff d6                	call   *%esi
				num = -(long long) num;
  800645:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800648:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80064b:	f7 da                	neg    %edx
  80064d:	83 d1 00             	adc    $0x0,%ecx
  800650:	f7 d9                	neg    %ecx
  800652:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800655:	b8 0a 00 00 00       	mov    $0xa,%eax
  80065a:	e9 dd 00 00 00       	jmp    80073c <vprintfmt+0x38c>
		return va_arg(*ap, int);
  80065f:	8b 45 14             	mov    0x14(%ebp),%eax
  800662:	8b 00                	mov    (%eax),%eax
  800664:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800667:	99                   	cltd   
  800668:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80066b:	8b 45 14             	mov    0x14(%ebp),%eax
  80066e:	8d 40 04             	lea    0x4(%eax),%eax
  800671:	89 45 14             	mov    %eax,0x14(%ebp)
  800674:	eb b4                	jmp    80062a <vprintfmt+0x27a>
	if (lflag >= 2)
  800676:	83 f9 01             	cmp    $0x1,%ecx
  800679:	7f 1e                	jg     800699 <vprintfmt+0x2e9>
	else if (lflag)
  80067b:	85 c9                	test   %ecx,%ecx
  80067d:	74 32                	je     8006b1 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  80067f:	8b 45 14             	mov    0x14(%ebp),%eax
  800682:	8b 10                	mov    (%eax),%edx
  800684:	b9 00 00 00 00       	mov    $0x0,%ecx
  800689:	8d 40 04             	lea    0x4(%eax),%eax
  80068c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80068f:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800694:	e9 a3 00 00 00       	jmp    80073c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800699:	8b 45 14             	mov    0x14(%ebp),%eax
  80069c:	8b 10                	mov    (%eax),%edx
  80069e:	8b 48 04             	mov    0x4(%eax),%ecx
  8006a1:	8d 40 08             	lea    0x8(%eax),%eax
  8006a4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006a7:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8006ac:	e9 8b 00 00 00       	jmp    80073c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b4:	8b 10                	mov    (%eax),%edx
  8006b6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006bb:	8d 40 04             	lea    0x4(%eax),%eax
  8006be:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006c1:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8006c6:	eb 74                	jmp    80073c <vprintfmt+0x38c>
	if (lflag >= 2)
  8006c8:	83 f9 01             	cmp    $0x1,%ecx
  8006cb:	7f 1b                	jg     8006e8 <vprintfmt+0x338>
	else if (lflag)
  8006cd:	85 c9                	test   %ecx,%ecx
  8006cf:	74 2c                	je     8006fd <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8006d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d4:	8b 10                	mov    (%eax),%edx
  8006d6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006db:	8d 40 04             	lea    0x4(%eax),%eax
  8006de:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006e1:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8006e6:	eb 54                	jmp    80073c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8006e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006eb:	8b 10                	mov    (%eax),%edx
  8006ed:	8b 48 04             	mov    0x4(%eax),%ecx
  8006f0:	8d 40 08             	lea    0x8(%eax),%eax
  8006f3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006f6:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  8006fb:	eb 3f                	jmp    80073c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800700:	8b 10                	mov    (%eax),%edx
  800702:	b9 00 00 00 00       	mov    $0x0,%ecx
  800707:	8d 40 04             	lea    0x4(%eax),%eax
  80070a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80070d:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800712:	eb 28                	jmp    80073c <vprintfmt+0x38c>
			putch('0', putdat);
  800714:	83 ec 08             	sub    $0x8,%esp
  800717:	53                   	push   %ebx
  800718:	6a 30                	push   $0x30
  80071a:	ff d6                	call   *%esi
			putch('x', putdat);
  80071c:	83 c4 08             	add    $0x8,%esp
  80071f:	53                   	push   %ebx
  800720:	6a 78                	push   $0x78
  800722:	ff d6                	call   *%esi
			num = (unsigned long long)
  800724:	8b 45 14             	mov    0x14(%ebp),%eax
  800727:	8b 10                	mov    (%eax),%edx
  800729:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80072e:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800731:	8d 40 04             	lea    0x4(%eax),%eax
  800734:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800737:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80073c:	83 ec 0c             	sub    $0xc,%esp
  80073f:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800743:	57                   	push   %edi
  800744:	ff 75 e0             	pushl  -0x20(%ebp)
  800747:	50                   	push   %eax
  800748:	51                   	push   %ecx
  800749:	52                   	push   %edx
  80074a:	89 da                	mov    %ebx,%edx
  80074c:	89 f0                	mov    %esi,%eax
  80074e:	e8 72 fb ff ff       	call   8002c5 <printnum>
			break;
  800753:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800756:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800759:	83 c7 01             	add    $0x1,%edi
  80075c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800760:	83 f8 25             	cmp    $0x25,%eax
  800763:	0f 84 62 fc ff ff    	je     8003cb <vprintfmt+0x1b>
			if (ch == '\0')
  800769:	85 c0                	test   %eax,%eax
  80076b:	0f 84 8b 00 00 00    	je     8007fc <vprintfmt+0x44c>
			putch(ch, putdat);
  800771:	83 ec 08             	sub    $0x8,%esp
  800774:	53                   	push   %ebx
  800775:	50                   	push   %eax
  800776:	ff d6                	call   *%esi
  800778:	83 c4 10             	add    $0x10,%esp
  80077b:	eb dc                	jmp    800759 <vprintfmt+0x3a9>
	if (lflag >= 2)
  80077d:	83 f9 01             	cmp    $0x1,%ecx
  800780:	7f 1b                	jg     80079d <vprintfmt+0x3ed>
	else if (lflag)
  800782:	85 c9                	test   %ecx,%ecx
  800784:	74 2c                	je     8007b2 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800786:	8b 45 14             	mov    0x14(%ebp),%eax
  800789:	8b 10                	mov    (%eax),%edx
  80078b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800790:	8d 40 04             	lea    0x4(%eax),%eax
  800793:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800796:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80079b:	eb 9f                	jmp    80073c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80079d:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a0:	8b 10                	mov    (%eax),%edx
  8007a2:	8b 48 04             	mov    0x4(%eax),%ecx
  8007a5:	8d 40 08             	lea    0x8(%eax),%eax
  8007a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ab:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8007b0:	eb 8a                	jmp    80073c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8007b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b5:	8b 10                	mov    (%eax),%edx
  8007b7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007bc:	8d 40 04             	lea    0x4(%eax),%eax
  8007bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c2:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8007c7:	e9 70 ff ff ff       	jmp    80073c <vprintfmt+0x38c>
			putch(ch, putdat);
  8007cc:	83 ec 08             	sub    $0x8,%esp
  8007cf:	53                   	push   %ebx
  8007d0:	6a 25                	push   $0x25
  8007d2:	ff d6                	call   *%esi
			break;
  8007d4:	83 c4 10             	add    $0x10,%esp
  8007d7:	e9 7a ff ff ff       	jmp    800756 <vprintfmt+0x3a6>
			putch('%', putdat);
  8007dc:	83 ec 08             	sub    $0x8,%esp
  8007df:	53                   	push   %ebx
  8007e0:	6a 25                	push   $0x25
  8007e2:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007e4:	83 c4 10             	add    $0x10,%esp
  8007e7:	89 f8                	mov    %edi,%eax
  8007e9:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007ed:	74 05                	je     8007f4 <vprintfmt+0x444>
  8007ef:	83 e8 01             	sub    $0x1,%eax
  8007f2:	eb f5                	jmp    8007e9 <vprintfmt+0x439>
  8007f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007f7:	e9 5a ff ff ff       	jmp    800756 <vprintfmt+0x3a6>
}
  8007fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007ff:	5b                   	pop    %ebx
  800800:	5e                   	pop    %esi
  800801:	5f                   	pop    %edi
  800802:	5d                   	pop    %ebp
  800803:	c3                   	ret    

00800804 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800804:	f3 0f 1e fb          	endbr32 
  800808:	55                   	push   %ebp
  800809:	89 e5                	mov    %esp,%ebp
  80080b:	83 ec 18             	sub    $0x18,%esp
  80080e:	8b 45 08             	mov    0x8(%ebp),%eax
  800811:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800814:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800817:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80081b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80081e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800825:	85 c0                	test   %eax,%eax
  800827:	74 26                	je     80084f <vsnprintf+0x4b>
  800829:	85 d2                	test   %edx,%edx
  80082b:	7e 22                	jle    80084f <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80082d:	ff 75 14             	pushl  0x14(%ebp)
  800830:	ff 75 10             	pushl  0x10(%ebp)
  800833:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800836:	50                   	push   %eax
  800837:	68 6e 03 80 00       	push   $0x80036e
  80083c:	e8 6f fb ff ff       	call   8003b0 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800841:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800844:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80084a:	83 c4 10             	add    $0x10,%esp
}
  80084d:	c9                   	leave  
  80084e:	c3                   	ret    
		return -E_INVAL;
  80084f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800854:	eb f7                	jmp    80084d <vsnprintf+0x49>

00800856 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800856:	f3 0f 1e fb          	endbr32 
  80085a:	55                   	push   %ebp
  80085b:	89 e5                	mov    %esp,%ebp
  80085d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800860:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800863:	50                   	push   %eax
  800864:	ff 75 10             	pushl  0x10(%ebp)
  800867:	ff 75 0c             	pushl  0xc(%ebp)
  80086a:	ff 75 08             	pushl  0x8(%ebp)
  80086d:	e8 92 ff ff ff       	call   800804 <vsnprintf>
	va_end(ap);

	return rc;
}
  800872:	c9                   	leave  
  800873:	c3                   	ret    

00800874 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800874:	f3 0f 1e fb          	endbr32 
  800878:	55                   	push   %ebp
  800879:	89 e5                	mov    %esp,%ebp
  80087b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80087e:	b8 00 00 00 00       	mov    $0x0,%eax
  800883:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800887:	74 05                	je     80088e <strlen+0x1a>
		n++;
  800889:	83 c0 01             	add    $0x1,%eax
  80088c:	eb f5                	jmp    800883 <strlen+0xf>
	return n;
}
  80088e:	5d                   	pop    %ebp
  80088f:	c3                   	ret    

00800890 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800890:	f3 0f 1e fb          	endbr32 
  800894:	55                   	push   %ebp
  800895:	89 e5                	mov    %esp,%ebp
  800897:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80089a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80089d:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a2:	39 d0                	cmp    %edx,%eax
  8008a4:	74 0d                	je     8008b3 <strnlen+0x23>
  8008a6:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008aa:	74 05                	je     8008b1 <strnlen+0x21>
		n++;
  8008ac:	83 c0 01             	add    $0x1,%eax
  8008af:	eb f1                	jmp    8008a2 <strnlen+0x12>
  8008b1:	89 c2                	mov    %eax,%edx
	return n;
}
  8008b3:	89 d0                	mov    %edx,%eax
  8008b5:	5d                   	pop    %ebp
  8008b6:	c3                   	ret    

008008b7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008b7:	f3 0f 1e fb          	endbr32 
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	53                   	push   %ebx
  8008bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008c2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ca:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8008ce:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8008d1:	83 c0 01             	add    $0x1,%eax
  8008d4:	84 d2                	test   %dl,%dl
  8008d6:	75 f2                	jne    8008ca <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8008d8:	89 c8                	mov    %ecx,%eax
  8008da:	5b                   	pop    %ebx
  8008db:	5d                   	pop    %ebp
  8008dc:	c3                   	ret    

008008dd <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008dd:	f3 0f 1e fb          	endbr32 
  8008e1:	55                   	push   %ebp
  8008e2:	89 e5                	mov    %esp,%ebp
  8008e4:	53                   	push   %ebx
  8008e5:	83 ec 10             	sub    $0x10,%esp
  8008e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008eb:	53                   	push   %ebx
  8008ec:	e8 83 ff ff ff       	call   800874 <strlen>
  8008f1:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008f4:	ff 75 0c             	pushl  0xc(%ebp)
  8008f7:	01 d8                	add    %ebx,%eax
  8008f9:	50                   	push   %eax
  8008fa:	e8 b8 ff ff ff       	call   8008b7 <strcpy>
	return dst;
}
  8008ff:	89 d8                	mov    %ebx,%eax
  800901:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800904:	c9                   	leave  
  800905:	c3                   	ret    

00800906 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800906:	f3 0f 1e fb          	endbr32 
  80090a:	55                   	push   %ebp
  80090b:	89 e5                	mov    %esp,%ebp
  80090d:	56                   	push   %esi
  80090e:	53                   	push   %ebx
  80090f:	8b 75 08             	mov    0x8(%ebp),%esi
  800912:	8b 55 0c             	mov    0xc(%ebp),%edx
  800915:	89 f3                	mov    %esi,%ebx
  800917:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80091a:	89 f0                	mov    %esi,%eax
  80091c:	39 d8                	cmp    %ebx,%eax
  80091e:	74 11                	je     800931 <strncpy+0x2b>
		*dst++ = *src;
  800920:	83 c0 01             	add    $0x1,%eax
  800923:	0f b6 0a             	movzbl (%edx),%ecx
  800926:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800929:	80 f9 01             	cmp    $0x1,%cl
  80092c:	83 da ff             	sbb    $0xffffffff,%edx
  80092f:	eb eb                	jmp    80091c <strncpy+0x16>
	}
	return ret;
}
  800931:	89 f0                	mov    %esi,%eax
  800933:	5b                   	pop    %ebx
  800934:	5e                   	pop    %esi
  800935:	5d                   	pop    %ebp
  800936:	c3                   	ret    

00800937 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800937:	f3 0f 1e fb          	endbr32 
  80093b:	55                   	push   %ebp
  80093c:	89 e5                	mov    %esp,%ebp
  80093e:	56                   	push   %esi
  80093f:	53                   	push   %ebx
  800940:	8b 75 08             	mov    0x8(%ebp),%esi
  800943:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800946:	8b 55 10             	mov    0x10(%ebp),%edx
  800949:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80094b:	85 d2                	test   %edx,%edx
  80094d:	74 21                	je     800970 <strlcpy+0x39>
  80094f:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800953:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800955:	39 c2                	cmp    %eax,%edx
  800957:	74 14                	je     80096d <strlcpy+0x36>
  800959:	0f b6 19             	movzbl (%ecx),%ebx
  80095c:	84 db                	test   %bl,%bl
  80095e:	74 0b                	je     80096b <strlcpy+0x34>
			*dst++ = *src++;
  800960:	83 c1 01             	add    $0x1,%ecx
  800963:	83 c2 01             	add    $0x1,%edx
  800966:	88 5a ff             	mov    %bl,-0x1(%edx)
  800969:	eb ea                	jmp    800955 <strlcpy+0x1e>
  80096b:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80096d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800970:	29 f0                	sub    %esi,%eax
}
  800972:	5b                   	pop    %ebx
  800973:	5e                   	pop    %esi
  800974:	5d                   	pop    %ebp
  800975:	c3                   	ret    

00800976 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800976:	f3 0f 1e fb          	endbr32 
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
  80097d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800980:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800983:	0f b6 01             	movzbl (%ecx),%eax
  800986:	84 c0                	test   %al,%al
  800988:	74 0c                	je     800996 <strcmp+0x20>
  80098a:	3a 02                	cmp    (%edx),%al
  80098c:	75 08                	jne    800996 <strcmp+0x20>
		p++, q++;
  80098e:	83 c1 01             	add    $0x1,%ecx
  800991:	83 c2 01             	add    $0x1,%edx
  800994:	eb ed                	jmp    800983 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800996:	0f b6 c0             	movzbl %al,%eax
  800999:	0f b6 12             	movzbl (%edx),%edx
  80099c:	29 d0                	sub    %edx,%eax
}
  80099e:	5d                   	pop    %ebp
  80099f:	c3                   	ret    

008009a0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009a0:	f3 0f 1e fb          	endbr32 
  8009a4:	55                   	push   %ebp
  8009a5:	89 e5                	mov    %esp,%ebp
  8009a7:	53                   	push   %ebx
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ae:	89 c3                	mov    %eax,%ebx
  8009b0:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009b3:	eb 06                	jmp    8009bb <strncmp+0x1b>
		n--, p++, q++;
  8009b5:	83 c0 01             	add    $0x1,%eax
  8009b8:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009bb:	39 d8                	cmp    %ebx,%eax
  8009bd:	74 16                	je     8009d5 <strncmp+0x35>
  8009bf:	0f b6 08             	movzbl (%eax),%ecx
  8009c2:	84 c9                	test   %cl,%cl
  8009c4:	74 04                	je     8009ca <strncmp+0x2a>
  8009c6:	3a 0a                	cmp    (%edx),%cl
  8009c8:	74 eb                	je     8009b5 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009ca:	0f b6 00             	movzbl (%eax),%eax
  8009cd:	0f b6 12             	movzbl (%edx),%edx
  8009d0:	29 d0                	sub    %edx,%eax
}
  8009d2:	5b                   	pop    %ebx
  8009d3:	5d                   	pop    %ebp
  8009d4:	c3                   	ret    
		return 0;
  8009d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8009da:	eb f6                	jmp    8009d2 <strncmp+0x32>

008009dc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009dc:	f3 0f 1e fb          	endbr32 
  8009e0:	55                   	push   %ebp
  8009e1:	89 e5                	mov    %esp,%ebp
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009ea:	0f b6 10             	movzbl (%eax),%edx
  8009ed:	84 d2                	test   %dl,%dl
  8009ef:	74 09                	je     8009fa <strchr+0x1e>
		if (*s == c)
  8009f1:	38 ca                	cmp    %cl,%dl
  8009f3:	74 0a                	je     8009ff <strchr+0x23>
	for (; *s; s++)
  8009f5:	83 c0 01             	add    $0x1,%eax
  8009f8:	eb f0                	jmp    8009ea <strchr+0xe>
			return (char *) s;
	return 0;
  8009fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009ff:	5d                   	pop    %ebp
  800a00:	c3                   	ret    

00800a01 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a01:	f3 0f 1e fb          	endbr32 
  800a05:	55                   	push   %ebp
  800a06:	89 e5                	mov    %esp,%ebp
  800a08:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a0f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a12:	38 ca                	cmp    %cl,%dl
  800a14:	74 09                	je     800a1f <strfind+0x1e>
  800a16:	84 d2                	test   %dl,%dl
  800a18:	74 05                	je     800a1f <strfind+0x1e>
	for (; *s; s++)
  800a1a:	83 c0 01             	add    $0x1,%eax
  800a1d:	eb f0                	jmp    800a0f <strfind+0xe>
			break;
	return (char *) s;
}
  800a1f:	5d                   	pop    %ebp
  800a20:	c3                   	ret    

00800a21 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a21:	f3 0f 1e fb          	endbr32 
  800a25:	55                   	push   %ebp
  800a26:	89 e5                	mov    %esp,%ebp
  800a28:	57                   	push   %edi
  800a29:	56                   	push   %esi
  800a2a:	53                   	push   %ebx
  800a2b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a2e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a31:	85 c9                	test   %ecx,%ecx
  800a33:	74 31                	je     800a66 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a35:	89 f8                	mov    %edi,%eax
  800a37:	09 c8                	or     %ecx,%eax
  800a39:	a8 03                	test   $0x3,%al
  800a3b:	75 23                	jne    800a60 <memset+0x3f>
		c &= 0xFF;
  800a3d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a41:	89 d3                	mov    %edx,%ebx
  800a43:	c1 e3 08             	shl    $0x8,%ebx
  800a46:	89 d0                	mov    %edx,%eax
  800a48:	c1 e0 18             	shl    $0x18,%eax
  800a4b:	89 d6                	mov    %edx,%esi
  800a4d:	c1 e6 10             	shl    $0x10,%esi
  800a50:	09 f0                	or     %esi,%eax
  800a52:	09 c2                	or     %eax,%edx
  800a54:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a56:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a59:	89 d0                	mov    %edx,%eax
  800a5b:	fc                   	cld    
  800a5c:	f3 ab                	rep stos %eax,%es:(%edi)
  800a5e:	eb 06                	jmp    800a66 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a63:	fc                   	cld    
  800a64:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a66:	89 f8                	mov    %edi,%eax
  800a68:	5b                   	pop    %ebx
  800a69:	5e                   	pop    %esi
  800a6a:	5f                   	pop    %edi
  800a6b:	5d                   	pop    %ebp
  800a6c:	c3                   	ret    

00800a6d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a6d:	f3 0f 1e fb          	endbr32 
  800a71:	55                   	push   %ebp
  800a72:	89 e5                	mov    %esp,%ebp
  800a74:	57                   	push   %edi
  800a75:	56                   	push   %esi
  800a76:	8b 45 08             	mov    0x8(%ebp),%eax
  800a79:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a7c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a7f:	39 c6                	cmp    %eax,%esi
  800a81:	73 32                	jae    800ab5 <memmove+0x48>
  800a83:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a86:	39 c2                	cmp    %eax,%edx
  800a88:	76 2b                	jbe    800ab5 <memmove+0x48>
		s += n;
		d += n;
  800a8a:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a8d:	89 fe                	mov    %edi,%esi
  800a8f:	09 ce                	or     %ecx,%esi
  800a91:	09 d6                	or     %edx,%esi
  800a93:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a99:	75 0e                	jne    800aa9 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a9b:	83 ef 04             	sub    $0x4,%edi
  800a9e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aa1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800aa4:	fd                   	std    
  800aa5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aa7:	eb 09                	jmp    800ab2 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aa9:	83 ef 01             	sub    $0x1,%edi
  800aac:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800aaf:	fd                   	std    
  800ab0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ab2:	fc                   	cld    
  800ab3:	eb 1a                	jmp    800acf <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ab5:	89 c2                	mov    %eax,%edx
  800ab7:	09 ca                	or     %ecx,%edx
  800ab9:	09 f2                	or     %esi,%edx
  800abb:	f6 c2 03             	test   $0x3,%dl
  800abe:	75 0a                	jne    800aca <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ac0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ac3:	89 c7                	mov    %eax,%edi
  800ac5:	fc                   	cld    
  800ac6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ac8:	eb 05                	jmp    800acf <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800aca:	89 c7                	mov    %eax,%edi
  800acc:	fc                   	cld    
  800acd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800acf:	5e                   	pop    %esi
  800ad0:	5f                   	pop    %edi
  800ad1:	5d                   	pop    %ebp
  800ad2:	c3                   	ret    

00800ad3 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ad3:	f3 0f 1e fb          	endbr32 
  800ad7:	55                   	push   %ebp
  800ad8:	89 e5                	mov    %esp,%ebp
  800ada:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800add:	ff 75 10             	pushl  0x10(%ebp)
  800ae0:	ff 75 0c             	pushl  0xc(%ebp)
  800ae3:	ff 75 08             	pushl  0x8(%ebp)
  800ae6:	e8 82 ff ff ff       	call   800a6d <memmove>
}
  800aeb:	c9                   	leave  
  800aec:	c3                   	ret    

00800aed <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800aed:	f3 0f 1e fb          	endbr32 
  800af1:	55                   	push   %ebp
  800af2:	89 e5                	mov    %esp,%ebp
  800af4:	56                   	push   %esi
  800af5:	53                   	push   %ebx
  800af6:	8b 45 08             	mov    0x8(%ebp),%eax
  800af9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800afc:	89 c6                	mov    %eax,%esi
  800afe:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b01:	39 f0                	cmp    %esi,%eax
  800b03:	74 1c                	je     800b21 <memcmp+0x34>
		if (*s1 != *s2)
  800b05:	0f b6 08             	movzbl (%eax),%ecx
  800b08:	0f b6 1a             	movzbl (%edx),%ebx
  800b0b:	38 d9                	cmp    %bl,%cl
  800b0d:	75 08                	jne    800b17 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b0f:	83 c0 01             	add    $0x1,%eax
  800b12:	83 c2 01             	add    $0x1,%edx
  800b15:	eb ea                	jmp    800b01 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800b17:	0f b6 c1             	movzbl %cl,%eax
  800b1a:	0f b6 db             	movzbl %bl,%ebx
  800b1d:	29 d8                	sub    %ebx,%eax
  800b1f:	eb 05                	jmp    800b26 <memcmp+0x39>
	}

	return 0;
  800b21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b26:	5b                   	pop    %ebx
  800b27:	5e                   	pop    %esi
  800b28:	5d                   	pop    %ebp
  800b29:	c3                   	ret    

00800b2a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b2a:	f3 0f 1e fb          	endbr32 
  800b2e:	55                   	push   %ebp
  800b2f:	89 e5                	mov    %esp,%ebp
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b37:	89 c2                	mov    %eax,%edx
  800b39:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b3c:	39 d0                	cmp    %edx,%eax
  800b3e:	73 09                	jae    800b49 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b40:	38 08                	cmp    %cl,(%eax)
  800b42:	74 05                	je     800b49 <memfind+0x1f>
	for (; s < ends; s++)
  800b44:	83 c0 01             	add    $0x1,%eax
  800b47:	eb f3                	jmp    800b3c <memfind+0x12>
			break;
	return (void *) s;
}
  800b49:	5d                   	pop    %ebp
  800b4a:	c3                   	ret    

00800b4b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b4b:	f3 0f 1e fb          	endbr32 
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
  800b52:	57                   	push   %edi
  800b53:	56                   	push   %esi
  800b54:	53                   	push   %ebx
  800b55:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b58:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b5b:	eb 03                	jmp    800b60 <strtol+0x15>
		s++;
  800b5d:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b60:	0f b6 01             	movzbl (%ecx),%eax
  800b63:	3c 20                	cmp    $0x20,%al
  800b65:	74 f6                	je     800b5d <strtol+0x12>
  800b67:	3c 09                	cmp    $0x9,%al
  800b69:	74 f2                	je     800b5d <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800b6b:	3c 2b                	cmp    $0x2b,%al
  800b6d:	74 2a                	je     800b99 <strtol+0x4e>
	int neg = 0;
  800b6f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b74:	3c 2d                	cmp    $0x2d,%al
  800b76:	74 2b                	je     800ba3 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b78:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b7e:	75 0f                	jne    800b8f <strtol+0x44>
  800b80:	80 39 30             	cmpb   $0x30,(%ecx)
  800b83:	74 28                	je     800bad <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b85:	85 db                	test   %ebx,%ebx
  800b87:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b8c:	0f 44 d8             	cmove  %eax,%ebx
  800b8f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b94:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b97:	eb 46                	jmp    800bdf <strtol+0x94>
		s++;
  800b99:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b9c:	bf 00 00 00 00       	mov    $0x0,%edi
  800ba1:	eb d5                	jmp    800b78 <strtol+0x2d>
		s++, neg = 1;
  800ba3:	83 c1 01             	add    $0x1,%ecx
  800ba6:	bf 01 00 00 00       	mov    $0x1,%edi
  800bab:	eb cb                	jmp    800b78 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bad:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bb1:	74 0e                	je     800bc1 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800bb3:	85 db                	test   %ebx,%ebx
  800bb5:	75 d8                	jne    800b8f <strtol+0x44>
		s++, base = 8;
  800bb7:	83 c1 01             	add    $0x1,%ecx
  800bba:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bbf:	eb ce                	jmp    800b8f <strtol+0x44>
		s += 2, base = 16;
  800bc1:	83 c1 02             	add    $0x2,%ecx
  800bc4:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bc9:	eb c4                	jmp    800b8f <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800bcb:	0f be d2             	movsbl %dl,%edx
  800bce:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bd1:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bd4:	7d 3a                	jge    800c10 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800bd6:	83 c1 01             	add    $0x1,%ecx
  800bd9:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bdd:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bdf:	0f b6 11             	movzbl (%ecx),%edx
  800be2:	8d 72 d0             	lea    -0x30(%edx),%esi
  800be5:	89 f3                	mov    %esi,%ebx
  800be7:	80 fb 09             	cmp    $0x9,%bl
  800bea:	76 df                	jbe    800bcb <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800bec:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bef:	89 f3                	mov    %esi,%ebx
  800bf1:	80 fb 19             	cmp    $0x19,%bl
  800bf4:	77 08                	ja     800bfe <strtol+0xb3>
			dig = *s - 'a' + 10;
  800bf6:	0f be d2             	movsbl %dl,%edx
  800bf9:	83 ea 57             	sub    $0x57,%edx
  800bfc:	eb d3                	jmp    800bd1 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800bfe:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c01:	89 f3                	mov    %esi,%ebx
  800c03:	80 fb 19             	cmp    $0x19,%bl
  800c06:	77 08                	ja     800c10 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c08:	0f be d2             	movsbl %dl,%edx
  800c0b:	83 ea 37             	sub    $0x37,%edx
  800c0e:	eb c1                	jmp    800bd1 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c10:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c14:	74 05                	je     800c1b <strtol+0xd0>
		*endptr = (char *) s;
  800c16:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c19:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c1b:	89 c2                	mov    %eax,%edx
  800c1d:	f7 da                	neg    %edx
  800c1f:	85 ff                	test   %edi,%edi
  800c21:	0f 45 c2             	cmovne %edx,%eax
}
  800c24:	5b                   	pop    %ebx
  800c25:	5e                   	pop    %esi
  800c26:	5f                   	pop    %edi
  800c27:	5d                   	pop    %ebp
  800c28:	c3                   	ret    

00800c29 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c29:	f3 0f 1e fb          	endbr32 
  800c2d:	55                   	push   %ebp
  800c2e:	89 e5                	mov    %esp,%ebp
  800c30:	57                   	push   %edi
  800c31:	56                   	push   %esi
  800c32:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c33:	b8 00 00 00 00       	mov    $0x0,%eax
  800c38:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c3e:	89 c3                	mov    %eax,%ebx
  800c40:	89 c7                	mov    %eax,%edi
  800c42:	89 c6                	mov    %eax,%esi
  800c44:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c46:	5b                   	pop    %ebx
  800c47:	5e                   	pop    %esi
  800c48:	5f                   	pop    %edi
  800c49:	5d                   	pop    %ebp
  800c4a:	c3                   	ret    

00800c4b <sys_cgetc>:

int
sys_cgetc(void)
{
  800c4b:	f3 0f 1e fb          	endbr32 
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	57                   	push   %edi
  800c53:	56                   	push   %esi
  800c54:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c55:	ba 00 00 00 00       	mov    $0x0,%edx
  800c5a:	b8 01 00 00 00       	mov    $0x1,%eax
  800c5f:	89 d1                	mov    %edx,%ecx
  800c61:	89 d3                	mov    %edx,%ebx
  800c63:	89 d7                	mov    %edx,%edi
  800c65:	89 d6                	mov    %edx,%esi
  800c67:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c69:	5b                   	pop    %ebx
  800c6a:	5e                   	pop    %esi
  800c6b:	5f                   	pop    %edi
  800c6c:	5d                   	pop    %ebp
  800c6d:	c3                   	ret    

00800c6e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c6e:	f3 0f 1e fb          	endbr32 
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
  800c75:	57                   	push   %edi
  800c76:	56                   	push   %esi
  800c77:	53                   	push   %ebx
  800c78:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c7b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c80:	8b 55 08             	mov    0x8(%ebp),%edx
  800c83:	b8 03 00 00 00       	mov    $0x3,%eax
  800c88:	89 cb                	mov    %ecx,%ebx
  800c8a:	89 cf                	mov    %ecx,%edi
  800c8c:	89 ce                	mov    %ecx,%esi
  800c8e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c90:	85 c0                	test   %eax,%eax
  800c92:	7f 08                	jg     800c9c <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c94:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c97:	5b                   	pop    %ebx
  800c98:	5e                   	pop    %esi
  800c99:	5f                   	pop    %edi
  800c9a:	5d                   	pop    %ebp
  800c9b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c9c:	83 ec 0c             	sub    $0xc,%esp
  800c9f:	50                   	push   %eax
  800ca0:	6a 03                	push   $0x3
  800ca2:	68 9f 27 80 00       	push   $0x80279f
  800ca7:	6a 23                	push   $0x23
  800ca9:	68 bc 27 80 00       	push   $0x8027bc
  800cae:	e8 af 13 00 00       	call   802062 <_panic>

00800cb3 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cb3:	f3 0f 1e fb          	endbr32 
  800cb7:	55                   	push   %ebp
  800cb8:	89 e5                	mov    %esp,%ebp
  800cba:	57                   	push   %edi
  800cbb:	56                   	push   %esi
  800cbc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cbd:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc2:	b8 02 00 00 00       	mov    $0x2,%eax
  800cc7:	89 d1                	mov    %edx,%ecx
  800cc9:	89 d3                	mov    %edx,%ebx
  800ccb:	89 d7                	mov    %edx,%edi
  800ccd:	89 d6                	mov    %edx,%esi
  800ccf:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cd1:	5b                   	pop    %ebx
  800cd2:	5e                   	pop    %esi
  800cd3:	5f                   	pop    %edi
  800cd4:	5d                   	pop    %ebp
  800cd5:	c3                   	ret    

00800cd6 <sys_yield>:

void
sys_yield(void)
{
  800cd6:	f3 0f 1e fb          	endbr32 
  800cda:	55                   	push   %ebp
  800cdb:	89 e5                	mov    %esp,%ebp
  800cdd:	57                   	push   %edi
  800cde:	56                   	push   %esi
  800cdf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ce0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce5:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cea:	89 d1                	mov    %edx,%ecx
  800cec:	89 d3                	mov    %edx,%ebx
  800cee:	89 d7                	mov    %edx,%edi
  800cf0:	89 d6                	mov    %edx,%esi
  800cf2:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cf4:	5b                   	pop    %ebx
  800cf5:	5e                   	pop    %esi
  800cf6:	5f                   	pop    %edi
  800cf7:	5d                   	pop    %ebp
  800cf8:	c3                   	ret    

00800cf9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cf9:	f3 0f 1e fb          	endbr32 
  800cfd:	55                   	push   %ebp
  800cfe:	89 e5                	mov    %esp,%ebp
  800d00:	57                   	push   %edi
  800d01:	56                   	push   %esi
  800d02:	53                   	push   %ebx
  800d03:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d06:	be 00 00 00 00       	mov    $0x0,%esi
  800d0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d11:	b8 04 00 00 00       	mov    $0x4,%eax
  800d16:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d19:	89 f7                	mov    %esi,%edi
  800d1b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d1d:	85 c0                	test   %eax,%eax
  800d1f:	7f 08                	jg     800d29 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800d2d:	6a 04                	push   $0x4
  800d2f:	68 9f 27 80 00       	push   $0x80279f
  800d34:	6a 23                	push   $0x23
  800d36:	68 bc 27 80 00       	push   $0x8027bc
  800d3b:	e8 22 13 00 00       	call   802062 <_panic>

00800d40 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d40:	f3 0f 1e fb          	endbr32 
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
  800d47:	57                   	push   %edi
  800d48:	56                   	push   %esi
  800d49:	53                   	push   %ebx
  800d4a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d53:	b8 05 00 00 00       	mov    $0x5,%eax
  800d58:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d5b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d5e:	8b 75 18             	mov    0x18(%ebp),%esi
  800d61:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d63:	85 c0                	test   %eax,%eax
  800d65:	7f 08                	jg     800d6f <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  800d73:	6a 05                	push   $0x5
  800d75:	68 9f 27 80 00       	push   $0x80279f
  800d7a:	6a 23                	push   $0x23
  800d7c:	68 bc 27 80 00       	push   $0x8027bc
  800d81:	e8 dc 12 00 00       	call   802062 <_panic>

00800d86 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
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
  800d9e:	b8 06 00 00 00       	mov    $0x6,%eax
  800da3:	89 df                	mov    %ebx,%edi
  800da5:	89 de                	mov    %ebx,%esi
  800da7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da9:	85 c0                	test   %eax,%eax
  800dab:	7f 08                	jg     800db5 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  800db9:	6a 06                	push   $0x6
  800dbb:	68 9f 27 80 00       	push   $0x80279f
  800dc0:	6a 23                	push   $0x23
  800dc2:	68 bc 27 80 00       	push   $0x8027bc
  800dc7:	e8 96 12 00 00       	call   802062 <_panic>

00800dcc <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
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
  800de4:	b8 08 00 00 00       	mov    $0x8,%eax
  800de9:	89 df                	mov    %ebx,%edi
  800deb:	89 de                	mov    %ebx,%esi
  800ded:	cd 30                	int    $0x30
	if(check && ret > 0)
  800def:	85 c0                	test   %eax,%eax
  800df1:	7f 08                	jg     800dfb <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  800dff:	6a 08                	push   $0x8
  800e01:	68 9f 27 80 00       	push   $0x80279f
  800e06:	6a 23                	push   $0x23
  800e08:	68 bc 27 80 00       	push   $0x8027bc
  800e0d:	e8 50 12 00 00       	call   802062 <_panic>

00800e12 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e12:	f3 0f 1e fb          	endbr32 
  800e16:	55                   	push   %ebp
  800e17:	89 e5                	mov    %esp,%ebp
  800e19:	57                   	push   %edi
  800e1a:	56                   	push   %esi
  800e1b:	53                   	push   %ebx
  800e1c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e1f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e24:	8b 55 08             	mov    0x8(%ebp),%edx
  800e27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2a:	b8 09 00 00 00       	mov    $0x9,%eax
  800e2f:	89 df                	mov    %ebx,%edi
  800e31:	89 de                	mov    %ebx,%esi
  800e33:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e35:	85 c0                	test   %eax,%eax
  800e37:	7f 08                	jg     800e41 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e3c:	5b                   	pop    %ebx
  800e3d:	5e                   	pop    %esi
  800e3e:	5f                   	pop    %edi
  800e3f:	5d                   	pop    %ebp
  800e40:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e41:	83 ec 0c             	sub    $0xc,%esp
  800e44:	50                   	push   %eax
  800e45:	6a 09                	push   $0x9
  800e47:	68 9f 27 80 00       	push   $0x80279f
  800e4c:	6a 23                	push   $0x23
  800e4e:	68 bc 27 80 00       	push   $0x8027bc
  800e53:	e8 0a 12 00 00       	call   802062 <_panic>

00800e58 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e58:	f3 0f 1e fb          	endbr32 
  800e5c:	55                   	push   %ebp
  800e5d:	89 e5                	mov    %esp,%ebp
  800e5f:	57                   	push   %edi
  800e60:	56                   	push   %esi
  800e61:	53                   	push   %ebx
  800e62:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e65:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e70:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e75:	89 df                	mov    %ebx,%edi
  800e77:	89 de                	mov    %ebx,%esi
  800e79:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e7b:	85 c0                	test   %eax,%eax
  800e7d:	7f 08                	jg     800e87 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e82:	5b                   	pop    %ebx
  800e83:	5e                   	pop    %esi
  800e84:	5f                   	pop    %edi
  800e85:	5d                   	pop    %ebp
  800e86:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e87:	83 ec 0c             	sub    $0xc,%esp
  800e8a:	50                   	push   %eax
  800e8b:	6a 0a                	push   $0xa
  800e8d:	68 9f 27 80 00       	push   $0x80279f
  800e92:	6a 23                	push   $0x23
  800e94:	68 bc 27 80 00       	push   $0x8027bc
  800e99:	e8 c4 11 00 00       	call   802062 <_panic>

00800e9e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e9e:	f3 0f 1e fb          	endbr32 
  800ea2:	55                   	push   %ebp
  800ea3:	89 e5                	mov    %esp,%ebp
  800ea5:	57                   	push   %edi
  800ea6:	56                   	push   %esi
  800ea7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ea8:	8b 55 08             	mov    0x8(%ebp),%edx
  800eab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eae:	b8 0c 00 00 00       	mov    $0xc,%eax
  800eb3:	be 00 00 00 00       	mov    $0x0,%esi
  800eb8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ebb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ebe:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ec0:	5b                   	pop    %ebx
  800ec1:	5e                   	pop    %esi
  800ec2:	5f                   	pop    %edi
  800ec3:	5d                   	pop    %ebp
  800ec4:	c3                   	ret    

00800ec5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ec5:	f3 0f 1e fb          	endbr32 
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	57                   	push   %edi
  800ecd:	56                   	push   %esi
  800ece:	53                   	push   %ebx
  800ecf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ed7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eda:	b8 0d 00 00 00       	mov    $0xd,%eax
  800edf:	89 cb                	mov    %ecx,%ebx
  800ee1:	89 cf                	mov    %ecx,%edi
  800ee3:	89 ce                	mov    %ecx,%esi
  800ee5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ee7:	85 c0                	test   %eax,%eax
  800ee9:	7f 08                	jg     800ef3 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800eeb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eee:	5b                   	pop    %ebx
  800eef:	5e                   	pop    %esi
  800ef0:	5f                   	pop    %edi
  800ef1:	5d                   	pop    %ebp
  800ef2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef3:	83 ec 0c             	sub    $0xc,%esp
  800ef6:	50                   	push   %eax
  800ef7:	6a 0d                	push   $0xd
  800ef9:	68 9f 27 80 00       	push   $0x80279f
  800efe:	6a 23                	push   $0x23
  800f00:	68 bc 27 80 00       	push   $0x8027bc
  800f05:	e8 58 11 00 00       	call   802062 <_panic>

00800f0a <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f0a:	f3 0f 1e fb          	endbr32 
  800f0e:	55                   	push   %ebp
  800f0f:	89 e5                	mov    %esp,%ebp
  800f11:	53                   	push   %ebx
  800f12:	83 ec 04             	sub    $0x4,%esp
  800f15:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800f18:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  800f1a:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f1e:	74 74                	je     800f94 <pgfault+0x8a>
  800f20:	89 d8                	mov    %ebx,%eax
  800f22:	c1 e8 0c             	shr    $0xc,%eax
  800f25:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f2c:	f6 c4 08             	test   $0x8,%ah
  800f2f:	74 63                	je     800f94 <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800f31:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  800f37:	83 ec 0c             	sub    $0xc,%esp
  800f3a:	6a 05                	push   $0x5
  800f3c:	68 00 f0 7f 00       	push   $0x7ff000
  800f41:	6a 00                	push   $0x0
  800f43:	53                   	push   %ebx
  800f44:	6a 00                	push   $0x0
  800f46:	e8 f5 fd ff ff       	call   800d40 <sys_page_map>
  800f4b:	83 c4 20             	add    $0x20,%esp
  800f4e:	85 c0                	test   %eax,%eax
  800f50:	78 59                	js     800fab <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  800f52:	83 ec 04             	sub    $0x4,%esp
  800f55:	6a 07                	push   $0x7
  800f57:	53                   	push   %ebx
  800f58:	6a 00                	push   $0x0
  800f5a:	e8 9a fd ff ff       	call   800cf9 <sys_page_alloc>
  800f5f:	83 c4 10             	add    $0x10,%esp
  800f62:	85 c0                	test   %eax,%eax
  800f64:	78 5a                	js     800fc0 <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  800f66:	83 ec 04             	sub    $0x4,%esp
  800f69:	68 00 10 00 00       	push   $0x1000
  800f6e:	68 00 f0 7f 00       	push   $0x7ff000
  800f73:	53                   	push   %ebx
  800f74:	e8 f4 fa ff ff       	call   800a6d <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  800f79:	83 c4 08             	add    $0x8,%esp
  800f7c:	68 00 f0 7f 00       	push   $0x7ff000
  800f81:	6a 00                	push   $0x0
  800f83:	e8 fe fd ff ff       	call   800d86 <sys_page_unmap>
  800f88:	83 c4 10             	add    $0x10,%esp
  800f8b:	85 c0                	test   %eax,%eax
  800f8d:	78 46                	js     800fd5 <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  800f8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f92:	c9                   	leave  
  800f93:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  800f94:	83 ec 04             	sub    $0x4,%esp
  800f97:	68 ca 27 80 00       	push   $0x8027ca
  800f9c:	68 d3 00 00 00       	push   $0xd3
  800fa1:	68 e6 27 80 00       	push   $0x8027e6
  800fa6:	e8 b7 10 00 00       	call   802062 <_panic>
		panic("pgfault: %e\n", r);
  800fab:	50                   	push   %eax
  800fac:	68 f1 27 80 00       	push   $0x8027f1
  800fb1:	68 df 00 00 00       	push   $0xdf
  800fb6:	68 e6 27 80 00       	push   $0x8027e6
  800fbb:	e8 a2 10 00 00       	call   802062 <_panic>
		panic("pgfault: %e\n", r);
  800fc0:	50                   	push   %eax
  800fc1:	68 f1 27 80 00       	push   $0x8027f1
  800fc6:	68 e3 00 00 00       	push   $0xe3
  800fcb:	68 e6 27 80 00       	push   $0x8027e6
  800fd0:	e8 8d 10 00 00       	call   802062 <_panic>
		panic("pgfault: %e\n", r);
  800fd5:	50                   	push   %eax
  800fd6:	68 f1 27 80 00       	push   $0x8027f1
  800fdb:	68 e9 00 00 00       	push   $0xe9
  800fe0:	68 e6 27 80 00       	push   $0x8027e6
  800fe5:	e8 78 10 00 00       	call   802062 <_panic>

00800fea <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800fea:	f3 0f 1e fb          	endbr32 
  800fee:	55                   	push   %ebp
  800fef:	89 e5                	mov    %esp,%ebp
  800ff1:	57                   	push   %edi
  800ff2:	56                   	push   %esi
  800ff3:	53                   	push   %ebx
  800ff4:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  800ff7:	68 0a 0f 80 00       	push   $0x800f0a
  800ffc:	e8 ab 10 00 00       	call   8020ac <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801001:	b8 07 00 00 00       	mov    $0x7,%eax
  801006:	cd 30                	int    $0x30
  801008:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  80100b:	83 c4 10             	add    $0x10,%esp
  80100e:	85 c0                	test   %eax,%eax
  801010:	78 2d                	js     80103f <fork+0x55>
  801012:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801014:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  801019:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80101d:	0f 85 9b 00 00 00    	jne    8010be <fork+0xd4>
		thisenv = &envs[ENVX(sys_getenvid())];
  801023:	e8 8b fc ff ff       	call   800cb3 <sys_getenvid>
  801028:	25 ff 03 00 00       	and    $0x3ff,%eax
  80102d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801030:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801035:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  80103a:	e9 71 01 00 00       	jmp    8011b0 <fork+0x1c6>
		panic("sys_exofork: %e", envid);
  80103f:	50                   	push   %eax
  801040:	68 fe 27 80 00       	push   $0x8027fe
  801045:	68 2a 01 00 00       	push   $0x12a
  80104a:	68 e6 27 80 00       	push   $0x8027e6
  80104f:	e8 0e 10 00 00       	call   802062 <_panic>
		sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_SYSCALL);
  801054:	c1 e6 0c             	shl    $0xc,%esi
  801057:	83 ec 0c             	sub    $0xc,%esp
  80105a:	68 07 0e 00 00       	push   $0xe07
  80105f:	56                   	push   %esi
  801060:	57                   	push   %edi
  801061:	56                   	push   %esi
  801062:	6a 00                	push   $0x0
  801064:	e8 d7 fc ff ff       	call   800d40 <sys_page_map>
  801069:	83 c4 20             	add    $0x20,%esp
  80106c:	eb 3e                	jmp    8010ac <fork+0xc2>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  80106e:	c1 e6 0c             	shl    $0xc,%esi
  801071:	83 ec 0c             	sub    $0xc,%esp
  801074:	68 05 08 00 00       	push   $0x805
  801079:	56                   	push   %esi
  80107a:	57                   	push   %edi
  80107b:	56                   	push   %esi
  80107c:	6a 00                	push   $0x0
  80107e:	e8 bd fc ff ff       	call   800d40 <sys_page_map>
  801083:	83 c4 20             	add    $0x20,%esp
  801086:	85 c0                	test   %eax,%eax
  801088:	0f 88 bc 00 00 00    	js     80114a <fork+0x160>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  80108e:	83 ec 0c             	sub    $0xc,%esp
  801091:	68 05 08 00 00       	push   $0x805
  801096:	56                   	push   %esi
  801097:	6a 00                	push   $0x0
  801099:	56                   	push   %esi
  80109a:	6a 00                	push   $0x0
  80109c:	e8 9f fc ff ff       	call   800d40 <sys_page_map>
  8010a1:	83 c4 20             	add    $0x20,%esp
  8010a4:	85 c0                	test   %eax,%eax
  8010a6:	0f 88 b3 00 00 00    	js     80115f <fork+0x175>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8010ac:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8010b2:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8010b8:	0f 84 b6 00 00 00    	je     801174 <fork+0x18a>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  8010be:	89 d8                	mov    %ebx,%eax
  8010c0:	c1 e8 16             	shr    $0x16,%eax
  8010c3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010ca:	a8 01                	test   $0x1,%al
  8010cc:	74 de                	je     8010ac <fork+0xc2>
  8010ce:	89 de                	mov    %ebx,%esi
  8010d0:	c1 ee 0c             	shr    $0xc,%esi
  8010d3:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010da:	a8 01                	test   $0x1,%al
  8010dc:	74 ce                	je     8010ac <fork+0xc2>
  8010de:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010e5:	a8 04                	test   $0x4,%al
  8010e7:	74 c3                	je     8010ac <fork+0xc2>
	if ((uvpt[pn] & PTE_SHARE)){
  8010e9:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010f0:	f6 c4 04             	test   $0x4,%ah
  8010f3:	0f 85 5b ff ff ff    	jne    801054 <fork+0x6a>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  8010f9:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801100:	a8 02                	test   $0x2,%al
  801102:	0f 85 66 ff ff ff    	jne    80106e <fork+0x84>
  801108:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80110f:	f6 c4 08             	test   $0x8,%ah
  801112:	0f 85 56 ff ff ff    	jne    80106e <fork+0x84>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  801118:	c1 e6 0c             	shl    $0xc,%esi
  80111b:	83 ec 0c             	sub    $0xc,%esp
  80111e:	6a 05                	push   $0x5
  801120:	56                   	push   %esi
  801121:	57                   	push   %edi
  801122:	56                   	push   %esi
  801123:	6a 00                	push   $0x0
  801125:	e8 16 fc ff ff       	call   800d40 <sys_page_map>
  80112a:	83 c4 20             	add    $0x20,%esp
  80112d:	85 c0                	test   %eax,%eax
  80112f:	0f 89 77 ff ff ff    	jns    8010ac <fork+0xc2>
		panic("duppage: %e\n", r);
  801135:	50                   	push   %eax
  801136:	68 0e 28 80 00       	push   $0x80280e
  80113b:	68 0c 01 00 00       	push   $0x10c
  801140:	68 e6 27 80 00       	push   $0x8027e6
  801145:	e8 18 0f 00 00       	call   802062 <_panic>
			panic("duppage: %e\n", r);
  80114a:	50                   	push   %eax
  80114b:	68 0e 28 80 00       	push   $0x80280e
  801150:	68 05 01 00 00       	push   $0x105
  801155:	68 e6 27 80 00       	push   $0x8027e6
  80115a:	e8 03 0f 00 00       	call   802062 <_panic>
			panic("duppage: %e\n", r);
  80115f:	50                   	push   %eax
  801160:	68 0e 28 80 00       	push   $0x80280e
  801165:	68 09 01 00 00       	push   $0x109
  80116a:	68 e6 27 80 00       	push   $0x8027e6
  80116f:	e8 ee 0e 00 00       	call   802062 <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  801174:	83 ec 04             	sub    $0x4,%esp
  801177:	6a 07                	push   $0x7
  801179:	68 00 f0 bf ee       	push   $0xeebff000
  80117e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801181:	e8 73 fb ff ff       	call   800cf9 <sys_page_alloc>
  801186:	83 c4 10             	add    $0x10,%esp
  801189:	85 c0                	test   %eax,%eax
  80118b:	78 2e                	js     8011bb <fork+0x1d1>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  80118d:	83 ec 08             	sub    $0x8,%esp
  801190:	68 1f 21 80 00       	push   $0x80211f
  801195:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801198:	57                   	push   %edi
  801199:	e8 ba fc ff ff       	call   800e58 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80119e:	83 c4 08             	add    $0x8,%esp
  8011a1:	6a 02                	push   $0x2
  8011a3:	57                   	push   %edi
  8011a4:	e8 23 fc ff ff       	call   800dcc <sys_env_set_status>
  8011a9:	83 c4 10             	add    $0x10,%esp
  8011ac:	85 c0                	test   %eax,%eax
  8011ae:	78 20                	js     8011d0 <fork+0x1e6>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  8011b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011b6:	5b                   	pop    %ebx
  8011b7:	5e                   	pop    %esi
  8011b8:	5f                   	pop    %edi
  8011b9:	5d                   	pop    %ebp
  8011ba:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  8011bb:	50                   	push   %eax
  8011bc:	68 1b 28 80 00       	push   $0x80281b
  8011c1:	68 3e 01 00 00       	push   $0x13e
  8011c6:	68 e6 27 80 00       	push   $0x8027e6
  8011cb:	e8 92 0e 00 00       	call   802062 <_panic>
		panic("sys_env_set_status: %e", r);
  8011d0:	50                   	push   %eax
  8011d1:	68 2e 28 80 00       	push   $0x80282e
  8011d6:	68 43 01 00 00       	push   $0x143
  8011db:	68 e6 27 80 00       	push   $0x8027e6
  8011e0:	e8 7d 0e 00 00       	call   802062 <_panic>

008011e5 <sfork>:

// Challenge!
int
sfork(void)
{
  8011e5:	f3 0f 1e fb          	endbr32 
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
  8011ec:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8011ef:	68 45 28 80 00       	push   $0x802845
  8011f4:	68 4c 01 00 00       	push   $0x14c
  8011f9:	68 e6 27 80 00       	push   $0x8027e6
  8011fe:	e8 5f 0e 00 00       	call   802062 <_panic>

00801203 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801203:	f3 0f 1e fb          	endbr32 
  801207:	55                   	push   %ebp
  801208:	89 e5                	mov    %esp,%ebp
  80120a:	56                   	push   %esi
  80120b:	53                   	push   %ebx
  80120c:	8b 75 08             	mov    0x8(%ebp),%esi
  80120f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801212:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  801215:	85 c0                	test   %eax,%eax
  801217:	74 3d                	je     801256 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  801219:	83 ec 0c             	sub    $0xc,%esp
  80121c:	50                   	push   %eax
  80121d:	e8 a3 fc ff ff       	call   800ec5 <sys_ipc_recv>
  801222:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  801225:	85 f6                	test   %esi,%esi
  801227:	74 0b                	je     801234 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801229:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80122f:	8b 52 74             	mov    0x74(%edx),%edx
  801232:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801234:	85 db                	test   %ebx,%ebx
  801236:	74 0b                	je     801243 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  801238:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80123e:	8b 52 78             	mov    0x78(%edx),%edx
  801241:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  801243:	85 c0                	test   %eax,%eax
  801245:	78 21                	js     801268 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  801247:	a1 04 40 80 00       	mov    0x804004,%eax
  80124c:	8b 40 70             	mov    0x70(%eax),%eax
}
  80124f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801252:	5b                   	pop    %ebx
  801253:	5e                   	pop    %esi
  801254:	5d                   	pop    %ebp
  801255:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  801256:	83 ec 0c             	sub    $0xc,%esp
  801259:	68 00 00 c0 ee       	push   $0xeec00000
  80125e:	e8 62 fc ff ff       	call   800ec5 <sys_ipc_recv>
  801263:	83 c4 10             	add    $0x10,%esp
  801266:	eb bd                	jmp    801225 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  801268:	85 f6                	test   %esi,%esi
  80126a:	74 10                	je     80127c <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  80126c:	85 db                	test   %ebx,%ebx
  80126e:	75 df                	jne    80124f <ipc_recv+0x4c>
  801270:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801277:	00 00 00 
  80127a:	eb d3                	jmp    80124f <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  80127c:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801283:	00 00 00 
  801286:	eb e4                	jmp    80126c <ipc_recv+0x69>

00801288 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801288:	f3 0f 1e fb          	endbr32 
  80128c:	55                   	push   %ebp
  80128d:	89 e5                	mov    %esp,%ebp
  80128f:	57                   	push   %edi
  801290:	56                   	push   %esi
  801291:	53                   	push   %ebx
  801292:	83 ec 0c             	sub    $0xc,%esp
  801295:	8b 7d 08             	mov    0x8(%ebp),%edi
  801298:	8b 75 0c             	mov    0xc(%ebp),%esi
  80129b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  80129e:	85 db                	test   %ebx,%ebx
  8012a0:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8012a5:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  8012a8:	ff 75 14             	pushl  0x14(%ebp)
  8012ab:	53                   	push   %ebx
  8012ac:	56                   	push   %esi
  8012ad:	57                   	push   %edi
  8012ae:	e8 eb fb ff ff       	call   800e9e <sys_ipc_try_send>
  8012b3:	83 c4 10             	add    $0x10,%esp
  8012b6:	85 c0                	test   %eax,%eax
  8012b8:	79 1e                	jns    8012d8 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  8012ba:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8012bd:	75 07                	jne    8012c6 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  8012bf:	e8 12 fa ff ff       	call   800cd6 <sys_yield>
  8012c4:	eb e2                	jmp    8012a8 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  8012c6:	50                   	push   %eax
  8012c7:	68 5b 28 80 00       	push   $0x80285b
  8012cc:	6a 59                	push   $0x59
  8012ce:	68 76 28 80 00       	push   $0x802876
  8012d3:	e8 8a 0d 00 00       	call   802062 <_panic>
	}
}
  8012d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012db:	5b                   	pop    %ebx
  8012dc:	5e                   	pop    %esi
  8012dd:	5f                   	pop    %edi
  8012de:	5d                   	pop    %ebp
  8012df:	c3                   	ret    

008012e0 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8012e0:	f3 0f 1e fb          	endbr32 
  8012e4:	55                   	push   %ebp
  8012e5:	89 e5                	mov    %esp,%ebp
  8012e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8012ea:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8012ef:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8012f2:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8012f8:	8b 52 50             	mov    0x50(%edx),%edx
  8012fb:	39 ca                	cmp    %ecx,%edx
  8012fd:	74 11                	je     801310 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8012ff:	83 c0 01             	add    $0x1,%eax
  801302:	3d 00 04 00 00       	cmp    $0x400,%eax
  801307:	75 e6                	jne    8012ef <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801309:	b8 00 00 00 00       	mov    $0x0,%eax
  80130e:	eb 0b                	jmp    80131b <ipc_find_env+0x3b>
			return envs[i].env_id;
  801310:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801313:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801318:	8b 40 48             	mov    0x48(%eax),%eax
}
  80131b:	5d                   	pop    %ebp
  80131c:	c3                   	ret    

0080131d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80131d:	f3 0f 1e fb          	endbr32 
  801321:	55                   	push   %ebp
  801322:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	05 00 00 00 30       	add    $0x30000000,%eax
  80132c:	c1 e8 0c             	shr    $0xc,%eax
}
  80132f:	5d                   	pop    %ebp
  801330:	c3                   	ret    

00801331 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801331:	f3 0f 1e fb          	endbr32 
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801338:	8b 45 08             	mov    0x8(%ebp),%eax
  80133b:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801340:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801345:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80134a:	5d                   	pop    %ebp
  80134b:	c3                   	ret    

0080134c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80134c:	f3 0f 1e fb          	endbr32 
  801350:	55                   	push   %ebp
  801351:	89 e5                	mov    %esp,%ebp
  801353:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801358:	89 c2                	mov    %eax,%edx
  80135a:	c1 ea 16             	shr    $0x16,%edx
  80135d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801364:	f6 c2 01             	test   $0x1,%dl
  801367:	74 2d                	je     801396 <fd_alloc+0x4a>
  801369:	89 c2                	mov    %eax,%edx
  80136b:	c1 ea 0c             	shr    $0xc,%edx
  80136e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801375:	f6 c2 01             	test   $0x1,%dl
  801378:	74 1c                	je     801396 <fd_alloc+0x4a>
  80137a:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80137f:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801384:	75 d2                	jne    801358 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801386:	8b 45 08             	mov    0x8(%ebp),%eax
  801389:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80138f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801394:	eb 0a                	jmp    8013a0 <fd_alloc+0x54>
			*fd_store = fd;
  801396:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801399:	89 01                	mov    %eax,(%ecx)
			return 0;
  80139b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013a0:	5d                   	pop    %ebp
  8013a1:	c3                   	ret    

008013a2 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8013a2:	f3 0f 1e fb          	endbr32 
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
  8013a9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8013ac:	83 f8 1f             	cmp    $0x1f,%eax
  8013af:	77 30                	ja     8013e1 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8013b1:	c1 e0 0c             	shl    $0xc,%eax
  8013b4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8013b9:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8013bf:	f6 c2 01             	test   $0x1,%dl
  8013c2:	74 24                	je     8013e8 <fd_lookup+0x46>
  8013c4:	89 c2                	mov    %eax,%edx
  8013c6:	c1 ea 0c             	shr    $0xc,%edx
  8013c9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013d0:	f6 c2 01             	test   $0x1,%dl
  8013d3:	74 1a                	je     8013ef <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8013d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013d8:	89 02                	mov    %eax,(%edx)
	return 0;
  8013da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013df:	5d                   	pop    %ebp
  8013e0:	c3                   	ret    
		return -E_INVAL;
  8013e1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013e6:	eb f7                	jmp    8013df <fd_lookup+0x3d>
		return -E_INVAL;
  8013e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013ed:	eb f0                	jmp    8013df <fd_lookup+0x3d>
  8013ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013f4:	eb e9                	jmp    8013df <fd_lookup+0x3d>

008013f6 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013f6:	f3 0f 1e fb          	endbr32 
  8013fa:	55                   	push   %ebp
  8013fb:	89 e5                	mov    %esp,%ebp
  8013fd:	83 ec 08             	sub    $0x8,%esp
  801400:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801403:	ba fc 28 80 00       	mov    $0x8028fc,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801408:	b8 0c 30 80 00       	mov    $0x80300c,%eax
		if (devtab[i]->dev_id == dev_id) {
  80140d:	39 08                	cmp    %ecx,(%eax)
  80140f:	74 33                	je     801444 <dev_lookup+0x4e>
  801411:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801414:	8b 02                	mov    (%edx),%eax
  801416:	85 c0                	test   %eax,%eax
  801418:	75 f3                	jne    80140d <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80141a:	a1 04 40 80 00       	mov    0x804004,%eax
  80141f:	8b 40 48             	mov    0x48(%eax),%eax
  801422:	83 ec 04             	sub    $0x4,%esp
  801425:	51                   	push   %ecx
  801426:	50                   	push   %eax
  801427:	68 80 28 80 00       	push   $0x802880
  80142c:	e8 7c ee ff ff       	call   8002ad <cprintf>
	*dev = 0;
  801431:	8b 45 0c             	mov    0xc(%ebp),%eax
  801434:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80143a:	83 c4 10             	add    $0x10,%esp
  80143d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801442:	c9                   	leave  
  801443:	c3                   	ret    
			*dev = devtab[i];
  801444:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801447:	89 01                	mov    %eax,(%ecx)
			return 0;
  801449:	b8 00 00 00 00       	mov    $0x0,%eax
  80144e:	eb f2                	jmp    801442 <dev_lookup+0x4c>

00801450 <fd_close>:
{
  801450:	f3 0f 1e fb          	endbr32 
  801454:	55                   	push   %ebp
  801455:	89 e5                	mov    %esp,%ebp
  801457:	57                   	push   %edi
  801458:	56                   	push   %esi
  801459:	53                   	push   %ebx
  80145a:	83 ec 24             	sub    $0x24,%esp
  80145d:	8b 75 08             	mov    0x8(%ebp),%esi
  801460:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801463:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801466:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801467:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80146d:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801470:	50                   	push   %eax
  801471:	e8 2c ff ff ff       	call   8013a2 <fd_lookup>
  801476:	89 c3                	mov    %eax,%ebx
  801478:	83 c4 10             	add    $0x10,%esp
  80147b:	85 c0                	test   %eax,%eax
  80147d:	78 05                	js     801484 <fd_close+0x34>
	    || fd != fd2)
  80147f:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801482:	74 16                	je     80149a <fd_close+0x4a>
		return (must_exist ? r : 0);
  801484:	89 f8                	mov    %edi,%eax
  801486:	84 c0                	test   %al,%al
  801488:	b8 00 00 00 00       	mov    $0x0,%eax
  80148d:	0f 44 d8             	cmove  %eax,%ebx
}
  801490:	89 d8                	mov    %ebx,%eax
  801492:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801495:	5b                   	pop    %ebx
  801496:	5e                   	pop    %esi
  801497:	5f                   	pop    %edi
  801498:	5d                   	pop    %ebp
  801499:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80149a:	83 ec 08             	sub    $0x8,%esp
  80149d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8014a0:	50                   	push   %eax
  8014a1:	ff 36                	pushl  (%esi)
  8014a3:	e8 4e ff ff ff       	call   8013f6 <dev_lookup>
  8014a8:	89 c3                	mov    %eax,%ebx
  8014aa:	83 c4 10             	add    $0x10,%esp
  8014ad:	85 c0                	test   %eax,%eax
  8014af:	78 1a                	js     8014cb <fd_close+0x7b>
		if (dev->dev_close)
  8014b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014b4:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8014b7:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8014bc:	85 c0                	test   %eax,%eax
  8014be:	74 0b                	je     8014cb <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8014c0:	83 ec 0c             	sub    $0xc,%esp
  8014c3:	56                   	push   %esi
  8014c4:	ff d0                	call   *%eax
  8014c6:	89 c3                	mov    %eax,%ebx
  8014c8:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8014cb:	83 ec 08             	sub    $0x8,%esp
  8014ce:	56                   	push   %esi
  8014cf:	6a 00                	push   $0x0
  8014d1:	e8 b0 f8 ff ff       	call   800d86 <sys_page_unmap>
	return r;
  8014d6:	83 c4 10             	add    $0x10,%esp
  8014d9:	eb b5                	jmp    801490 <fd_close+0x40>

008014db <close>:

int
close(int fdnum)
{
  8014db:	f3 0f 1e fb          	endbr32 
  8014df:	55                   	push   %ebp
  8014e0:	89 e5                	mov    %esp,%ebp
  8014e2:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014e8:	50                   	push   %eax
  8014e9:	ff 75 08             	pushl  0x8(%ebp)
  8014ec:	e8 b1 fe ff ff       	call   8013a2 <fd_lookup>
  8014f1:	83 c4 10             	add    $0x10,%esp
  8014f4:	85 c0                	test   %eax,%eax
  8014f6:	79 02                	jns    8014fa <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8014f8:	c9                   	leave  
  8014f9:	c3                   	ret    
		return fd_close(fd, 1);
  8014fa:	83 ec 08             	sub    $0x8,%esp
  8014fd:	6a 01                	push   $0x1
  8014ff:	ff 75 f4             	pushl  -0xc(%ebp)
  801502:	e8 49 ff ff ff       	call   801450 <fd_close>
  801507:	83 c4 10             	add    $0x10,%esp
  80150a:	eb ec                	jmp    8014f8 <close+0x1d>

0080150c <close_all>:

void
close_all(void)
{
  80150c:	f3 0f 1e fb          	endbr32 
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
  801513:	53                   	push   %ebx
  801514:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801517:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80151c:	83 ec 0c             	sub    $0xc,%esp
  80151f:	53                   	push   %ebx
  801520:	e8 b6 ff ff ff       	call   8014db <close>
	for (i = 0; i < MAXFD; i++)
  801525:	83 c3 01             	add    $0x1,%ebx
  801528:	83 c4 10             	add    $0x10,%esp
  80152b:	83 fb 20             	cmp    $0x20,%ebx
  80152e:	75 ec                	jne    80151c <close_all+0x10>
}
  801530:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801533:	c9                   	leave  
  801534:	c3                   	ret    

00801535 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801535:	f3 0f 1e fb          	endbr32 
  801539:	55                   	push   %ebp
  80153a:	89 e5                	mov    %esp,%ebp
  80153c:	57                   	push   %edi
  80153d:	56                   	push   %esi
  80153e:	53                   	push   %ebx
  80153f:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801542:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801545:	50                   	push   %eax
  801546:	ff 75 08             	pushl  0x8(%ebp)
  801549:	e8 54 fe ff ff       	call   8013a2 <fd_lookup>
  80154e:	89 c3                	mov    %eax,%ebx
  801550:	83 c4 10             	add    $0x10,%esp
  801553:	85 c0                	test   %eax,%eax
  801555:	0f 88 81 00 00 00    	js     8015dc <dup+0xa7>
		return r;
	close(newfdnum);
  80155b:	83 ec 0c             	sub    $0xc,%esp
  80155e:	ff 75 0c             	pushl  0xc(%ebp)
  801561:	e8 75 ff ff ff       	call   8014db <close>

	newfd = INDEX2FD(newfdnum);
  801566:	8b 75 0c             	mov    0xc(%ebp),%esi
  801569:	c1 e6 0c             	shl    $0xc,%esi
  80156c:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801572:	83 c4 04             	add    $0x4,%esp
  801575:	ff 75 e4             	pushl  -0x1c(%ebp)
  801578:	e8 b4 fd ff ff       	call   801331 <fd2data>
  80157d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80157f:	89 34 24             	mov    %esi,(%esp)
  801582:	e8 aa fd ff ff       	call   801331 <fd2data>
  801587:	83 c4 10             	add    $0x10,%esp
  80158a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80158c:	89 d8                	mov    %ebx,%eax
  80158e:	c1 e8 16             	shr    $0x16,%eax
  801591:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801598:	a8 01                	test   $0x1,%al
  80159a:	74 11                	je     8015ad <dup+0x78>
  80159c:	89 d8                	mov    %ebx,%eax
  80159e:	c1 e8 0c             	shr    $0xc,%eax
  8015a1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8015a8:	f6 c2 01             	test   $0x1,%dl
  8015ab:	75 39                	jne    8015e6 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015b0:	89 d0                	mov    %edx,%eax
  8015b2:	c1 e8 0c             	shr    $0xc,%eax
  8015b5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015bc:	83 ec 0c             	sub    $0xc,%esp
  8015bf:	25 07 0e 00 00       	and    $0xe07,%eax
  8015c4:	50                   	push   %eax
  8015c5:	56                   	push   %esi
  8015c6:	6a 00                	push   $0x0
  8015c8:	52                   	push   %edx
  8015c9:	6a 00                	push   $0x0
  8015cb:	e8 70 f7 ff ff       	call   800d40 <sys_page_map>
  8015d0:	89 c3                	mov    %eax,%ebx
  8015d2:	83 c4 20             	add    $0x20,%esp
  8015d5:	85 c0                	test   %eax,%eax
  8015d7:	78 31                	js     80160a <dup+0xd5>
		goto err;

	return newfdnum;
  8015d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8015dc:	89 d8                	mov    %ebx,%eax
  8015de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015e1:	5b                   	pop    %ebx
  8015e2:	5e                   	pop    %esi
  8015e3:	5f                   	pop    %edi
  8015e4:	5d                   	pop    %ebp
  8015e5:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015e6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015ed:	83 ec 0c             	sub    $0xc,%esp
  8015f0:	25 07 0e 00 00       	and    $0xe07,%eax
  8015f5:	50                   	push   %eax
  8015f6:	57                   	push   %edi
  8015f7:	6a 00                	push   $0x0
  8015f9:	53                   	push   %ebx
  8015fa:	6a 00                	push   $0x0
  8015fc:	e8 3f f7 ff ff       	call   800d40 <sys_page_map>
  801601:	89 c3                	mov    %eax,%ebx
  801603:	83 c4 20             	add    $0x20,%esp
  801606:	85 c0                	test   %eax,%eax
  801608:	79 a3                	jns    8015ad <dup+0x78>
	sys_page_unmap(0, newfd);
  80160a:	83 ec 08             	sub    $0x8,%esp
  80160d:	56                   	push   %esi
  80160e:	6a 00                	push   $0x0
  801610:	e8 71 f7 ff ff       	call   800d86 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801615:	83 c4 08             	add    $0x8,%esp
  801618:	57                   	push   %edi
  801619:	6a 00                	push   $0x0
  80161b:	e8 66 f7 ff ff       	call   800d86 <sys_page_unmap>
	return r;
  801620:	83 c4 10             	add    $0x10,%esp
  801623:	eb b7                	jmp    8015dc <dup+0xa7>

00801625 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801625:	f3 0f 1e fb          	endbr32 
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
  80162c:	53                   	push   %ebx
  80162d:	83 ec 1c             	sub    $0x1c,%esp
  801630:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801633:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801636:	50                   	push   %eax
  801637:	53                   	push   %ebx
  801638:	e8 65 fd ff ff       	call   8013a2 <fd_lookup>
  80163d:	83 c4 10             	add    $0x10,%esp
  801640:	85 c0                	test   %eax,%eax
  801642:	78 3f                	js     801683 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801644:	83 ec 08             	sub    $0x8,%esp
  801647:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80164a:	50                   	push   %eax
  80164b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164e:	ff 30                	pushl  (%eax)
  801650:	e8 a1 fd ff ff       	call   8013f6 <dev_lookup>
  801655:	83 c4 10             	add    $0x10,%esp
  801658:	85 c0                	test   %eax,%eax
  80165a:	78 27                	js     801683 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80165c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80165f:	8b 42 08             	mov    0x8(%edx),%eax
  801662:	83 e0 03             	and    $0x3,%eax
  801665:	83 f8 01             	cmp    $0x1,%eax
  801668:	74 1e                	je     801688 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80166a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80166d:	8b 40 08             	mov    0x8(%eax),%eax
  801670:	85 c0                	test   %eax,%eax
  801672:	74 35                	je     8016a9 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801674:	83 ec 04             	sub    $0x4,%esp
  801677:	ff 75 10             	pushl  0x10(%ebp)
  80167a:	ff 75 0c             	pushl  0xc(%ebp)
  80167d:	52                   	push   %edx
  80167e:	ff d0                	call   *%eax
  801680:	83 c4 10             	add    $0x10,%esp
}
  801683:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801686:	c9                   	leave  
  801687:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801688:	a1 04 40 80 00       	mov    0x804004,%eax
  80168d:	8b 40 48             	mov    0x48(%eax),%eax
  801690:	83 ec 04             	sub    $0x4,%esp
  801693:	53                   	push   %ebx
  801694:	50                   	push   %eax
  801695:	68 c1 28 80 00       	push   $0x8028c1
  80169a:	e8 0e ec ff ff       	call   8002ad <cprintf>
		return -E_INVAL;
  80169f:	83 c4 10             	add    $0x10,%esp
  8016a2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016a7:	eb da                	jmp    801683 <read+0x5e>
		return -E_NOT_SUPP;
  8016a9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016ae:	eb d3                	jmp    801683 <read+0x5e>

008016b0 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8016b0:	f3 0f 1e fb          	endbr32 
  8016b4:	55                   	push   %ebp
  8016b5:	89 e5                	mov    %esp,%ebp
  8016b7:	57                   	push   %edi
  8016b8:	56                   	push   %esi
  8016b9:	53                   	push   %ebx
  8016ba:	83 ec 0c             	sub    $0xc,%esp
  8016bd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016c0:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016c3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016c8:	eb 02                	jmp    8016cc <readn+0x1c>
  8016ca:	01 c3                	add    %eax,%ebx
  8016cc:	39 f3                	cmp    %esi,%ebx
  8016ce:	73 21                	jae    8016f1 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016d0:	83 ec 04             	sub    $0x4,%esp
  8016d3:	89 f0                	mov    %esi,%eax
  8016d5:	29 d8                	sub    %ebx,%eax
  8016d7:	50                   	push   %eax
  8016d8:	89 d8                	mov    %ebx,%eax
  8016da:	03 45 0c             	add    0xc(%ebp),%eax
  8016dd:	50                   	push   %eax
  8016de:	57                   	push   %edi
  8016df:	e8 41 ff ff ff       	call   801625 <read>
		if (m < 0)
  8016e4:	83 c4 10             	add    $0x10,%esp
  8016e7:	85 c0                	test   %eax,%eax
  8016e9:	78 04                	js     8016ef <readn+0x3f>
			return m;
		if (m == 0)
  8016eb:	75 dd                	jne    8016ca <readn+0x1a>
  8016ed:	eb 02                	jmp    8016f1 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016ef:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8016f1:	89 d8                	mov    %ebx,%eax
  8016f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016f6:	5b                   	pop    %ebx
  8016f7:	5e                   	pop    %esi
  8016f8:	5f                   	pop    %edi
  8016f9:	5d                   	pop    %ebp
  8016fa:	c3                   	ret    

008016fb <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016fb:	f3 0f 1e fb          	endbr32 
  8016ff:	55                   	push   %ebp
  801700:	89 e5                	mov    %esp,%ebp
  801702:	53                   	push   %ebx
  801703:	83 ec 1c             	sub    $0x1c,%esp
  801706:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801709:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80170c:	50                   	push   %eax
  80170d:	53                   	push   %ebx
  80170e:	e8 8f fc ff ff       	call   8013a2 <fd_lookup>
  801713:	83 c4 10             	add    $0x10,%esp
  801716:	85 c0                	test   %eax,%eax
  801718:	78 3a                	js     801754 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80171a:	83 ec 08             	sub    $0x8,%esp
  80171d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801720:	50                   	push   %eax
  801721:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801724:	ff 30                	pushl  (%eax)
  801726:	e8 cb fc ff ff       	call   8013f6 <dev_lookup>
  80172b:	83 c4 10             	add    $0x10,%esp
  80172e:	85 c0                	test   %eax,%eax
  801730:	78 22                	js     801754 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801732:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801735:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801739:	74 1e                	je     801759 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80173b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80173e:	8b 52 0c             	mov    0xc(%edx),%edx
  801741:	85 d2                	test   %edx,%edx
  801743:	74 35                	je     80177a <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801745:	83 ec 04             	sub    $0x4,%esp
  801748:	ff 75 10             	pushl  0x10(%ebp)
  80174b:	ff 75 0c             	pushl  0xc(%ebp)
  80174e:	50                   	push   %eax
  80174f:	ff d2                	call   *%edx
  801751:	83 c4 10             	add    $0x10,%esp
}
  801754:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801757:	c9                   	leave  
  801758:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801759:	a1 04 40 80 00       	mov    0x804004,%eax
  80175e:	8b 40 48             	mov    0x48(%eax),%eax
  801761:	83 ec 04             	sub    $0x4,%esp
  801764:	53                   	push   %ebx
  801765:	50                   	push   %eax
  801766:	68 dd 28 80 00       	push   $0x8028dd
  80176b:	e8 3d eb ff ff       	call   8002ad <cprintf>
		return -E_INVAL;
  801770:	83 c4 10             	add    $0x10,%esp
  801773:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801778:	eb da                	jmp    801754 <write+0x59>
		return -E_NOT_SUPP;
  80177a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80177f:	eb d3                	jmp    801754 <write+0x59>

00801781 <seek>:

int
seek(int fdnum, off_t offset)
{
  801781:	f3 0f 1e fb          	endbr32 
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
  801788:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80178b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80178e:	50                   	push   %eax
  80178f:	ff 75 08             	pushl  0x8(%ebp)
  801792:	e8 0b fc ff ff       	call   8013a2 <fd_lookup>
  801797:	83 c4 10             	add    $0x10,%esp
  80179a:	85 c0                	test   %eax,%eax
  80179c:	78 0e                	js     8017ac <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80179e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a4:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8017a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ac:	c9                   	leave  
  8017ad:	c3                   	ret    

008017ae <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8017ae:	f3 0f 1e fb          	endbr32 
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
  8017b5:	53                   	push   %ebx
  8017b6:	83 ec 1c             	sub    $0x1c,%esp
  8017b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017bc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017bf:	50                   	push   %eax
  8017c0:	53                   	push   %ebx
  8017c1:	e8 dc fb ff ff       	call   8013a2 <fd_lookup>
  8017c6:	83 c4 10             	add    $0x10,%esp
  8017c9:	85 c0                	test   %eax,%eax
  8017cb:	78 37                	js     801804 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017cd:	83 ec 08             	sub    $0x8,%esp
  8017d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d3:	50                   	push   %eax
  8017d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d7:	ff 30                	pushl  (%eax)
  8017d9:	e8 18 fc ff ff       	call   8013f6 <dev_lookup>
  8017de:	83 c4 10             	add    $0x10,%esp
  8017e1:	85 c0                	test   %eax,%eax
  8017e3:	78 1f                	js     801804 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017ec:	74 1b                	je     801809 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8017ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017f1:	8b 52 18             	mov    0x18(%edx),%edx
  8017f4:	85 d2                	test   %edx,%edx
  8017f6:	74 32                	je     80182a <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017f8:	83 ec 08             	sub    $0x8,%esp
  8017fb:	ff 75 0c             	pushl  0xc(%ebp)
  8017fe:	50                   	push   %eax
  8017ff:	ff d2                	call   *%edx
  801801:	83 c4 10             	add    $0x10,%esp
}
  801804:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801807:	c9                   	leave  
  801808:	c3                   	ret    
			thisenv->env_id, fdnum);
  801809:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80180e:	8b 40 48             	mov    0x48(%eax),%eax
  801811:	83 ec 04             	sub    $0x4,%esp
  801814:	53                   	push   %ebx
  801815:	50                   	push   %eax
  801816:	68 a0 28 80 00       	push   $0x8028a0
  80181b:	e8 8d ea ff ff       	call   8002ad <cprintf>
		return -E_INVAL;
  801820:	83 c4 10             	add    $0x10,%esp
  801823:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801828:	eb da                	jmp    801804 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80182a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80182f:	eb d3                	jmp    801804 <ftruncate+0x56>

00801831 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801831:	f3 0f 1e fb          	endbr32 
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
  801838:	53                   	push   %ebx
  801839:	83 ec 1c             	sub    $0x1c,%esp
  80183c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80183f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801842:	50                   	push   %eax
  801843:	ff 75 08             	pushl  0x8(%ebp)
  801846:	e8 57 fb ff ff       	call   8013a2 <fd_lookup>
  80184b:	83 c4 10             	add    $0x10,%esp
  80184e:	85 c0                	test   %eax,%eax
  801850:	78 4b                	js     80189d <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801852:	83 ec 08             	sub    $0x8,%esp
  801855:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801858:	50                   	push   %eax
  801859:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80185c:	ff 30                	pushl  (%eax)
  80185e:	e8 93 fb ff ff       	call   8013f6 <dev_lookup>
  801863:	83 c4 10             	add    $0x10,%esp
  801866:	85 c0                	test   %eax,%eax
  801868:	78 33                	js     80189d <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80186a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80186d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801871:	74 2f                	je     8018a2 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801873:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801876:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80187d:	00 00 00 
	stat->st_isdir = 0;
  801880:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801887:	00 00 00 
	stat->st_dev = dev;
  80188a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801890:	83 ec 08             	sub    $0x8,%esp
  801893:	53                   	push   %ebx
  801894:	ff 75 f0             	pushl  -0x10(%ebp)
  801897:	ff 50 14             	call   *0x14(%eax)
  80189a:	83 c4 10             	add    $0x10,%esp
}
  80189d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    
		return -E_NOT_SUPP;
  8018a2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018a7:	eb f4                	jmp    80189d <fstat+0x6c>

008018a9 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8018a9:	f3 0f 1e fb          	endbr32 
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
  8018b0:	56                   	push   %esi
  8018b1:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018b2:	83 ec 08             	sub    $0x8,%esp
  8018b5:	6a 00                	push   $0x0
  8018b7:	ff 75 08             	pushl  0x8(%ebp)
  8018ba:	e8 fb 01 00 00       	call   801aba <open>
  8018bf:	89 c3                	mov    %eax,%ebx
  8018c1:	83 c4 10             	add    $0x10,%esp
  8018c4:	85 c0                	test   %eax,%eax
  8018c6:	78 1b                	js     8018e3 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8018c8:	83 ec 08             	sub    $0x8,%esp
  8018cb:	ff 75 0c             	pushl  0xc(%ebp)
  8018ce:	50                   	push   %eax
  8018cf:	e8 5d ff ff ff       	call   801831 <fstat>
  8018d4:	89 c6                	mov    %eax,%esi
	close(fd);
  8018d6:	89 1c 24             	mov    %ebx,(%esp)
  8018d9:	e8 fd fb ff ff       	call   8014db <close>
	return r;
  8018de:	83 c4 10             	add    $0x10,%esp
  8018e1:	89 f3                	mov    %esi,%ebx
}
  8018e3:	89 d8                	mov    %ebx,%eax
  8018e5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e8:	5b                   	pop    %ebx
  8018e9:	5e                   	pop    %esi
  8018ea:	5d                   	pop    %ebp
  8018eb:	c3                   	ret    

008018ec <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018ec:	55                   	push   %ebp
  8018ed:	89 e5                	mov    %esp,%ebp
  8018ef:	56                   	push   %esi
  8018f0:	53                   	push   %ebx
  8018f1:	89 c6                	mov    %eax,%esi
  8018f3:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8018f5:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8018fc:	74 27                	je     801925 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018fe:	6a 07                	push   $0x7
  801900:	68 00 50 80 00       	push   $0x805000
  801905:	56                   	push   %esi
  801906:	ff 35 00 40 80 00    	pushl  0x804000
  80190c:	e8 77 f9 ff ff       	call   801288 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801911:	83 c4 0c             	add    $0xc,%esp
  801914:	6a 00                	push   $0x0
  801916:	53                   	push   %ebx
  801917:	6a 00                	push   $0x0
  801919:	e8 e5 f8 ff ff       	call   801203 <ipc_recv>
}
  80191e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801921:	5b                   	pop    %ebx
  801922:	5e                   	pop    %esi
  801923:	5d                   	pop    %ebp
  801924:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801925:	83 ec 0c             	sub    $0xc,%esp
  801928:	6a 01                	push   $0x1
  80192a:	e8 b1 f9 ff ff       	call   8012e0 <ipc_find_env>
  80192f:	a3 00 40 80 00       	mov    %eax,0x804000
  801934:	83 c4 10             	add    $0x10,%esp
  801937:	eb c5                	jmp    8018fe <fsipc+0x12>

00801939 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801939:	f3 0f 1e fb          	endbr32 
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
  801940:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801943:	8b 45 08             	mov    0x8(%ebp),%eax
  801946:	8b 40 0c             	mov    0xc(%eax),%eax
  801949:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80194e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801951:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801956:	ba 00 00 00 00       	mov    $0x0,%edx
  80195b:	b8 02 00 00 00       	mov    $0x2,%eax
  801960:	e8 87 ff ff ff       	call   8018ec <fsipc>
}
  801965:	c9                   	leave  
  801966:	c3                   	ret    

00801967 <devfile_flush>:
{
  801967:	f3 0f 1e fb          	endbr32 
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
  80196e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801971:	8b 45 08             	mov    0x8(%ebp),%eax
  801974:	8b 40 0c             	mov    0xc(%eax),%eax
  801977:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80197c:	ba 00 00 00 00       	mov    $0x0,%edx
  801981:	b8 06 00 00 00       	mov    $0x6,%eax
  801986:	e8 61 ff ff ff       	call   8018ec <fsipc>
}
  80198b:	c9                   	leave  
  80198c:	c3                   	ret    

0080198d <devfile_stat>:
{
  80198d:	f3 0f 1e fb          	endbr32 
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
  801994:	53                   	push   %ebx
  801995:	83 ec 04             	sub    $0x4,%esp
  801998:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80199b:	8b 45 08             	mov    0x8(%ebp),%eax
  80199e:	8b 40 0c             	mov    0xc(%eax),%eax
  8019a1:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8019a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ab:	b8 05 00 00 00       	mov    $0x5,%eax
  8019b0:	e8 37 ff ff ff       	call   8018ec <fsipc>
  8019b5:	85 c0                	test   %eax,%eax
  8019b7:	78 2c                	js     8019e5 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019b9:	83 ec 08             	sub    $0x8,%esp
  8019bc:	68 00 50 80 00       	push   $0x805000
  8019c1:	53                   	push   %ebx
  8019c2:	e8 f0 ee ff ff       	call   8008b7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019c7:	a1 80 50 80 00       	mov    0x805080,%eax
  8019cc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019d2:	a1 84 50 80 00       	mov    0x805084,%eax
  8019d7:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8019dd:	83 c4 10             	add    $0x10,%esp
  8019e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <devfile_write>:
{
  8019ea:	f3 0f 1e fb          	endbr32 
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
  8019f1:	83 ec 0c             	sub    $0xc,%esp
  8019f4:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8019fa:	8b 52 0c             	mov    0xc(%edx),%edx
  8019fd:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801a03:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801a08:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801a0d:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  801a10:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801a15:	50                   	push   %eax
  801a16:	ff 75 0c             	pushl  0xc(%ebp)
  801a19:	68 08 50 80 00       	push   $0x805008
  801a1e:	e8 4a f0 ff ff       	call   800a6d <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801a23:	ba 00 00 00 00       	mov    $0x0,%edx
  801a28:	b8 04 00 00 00       	mov    $0x4,%eax
  801a2d:	e8 ba fe ff ff       	call   8018ec <fsipc>
}
  801a32:	c9                   	leave  
  801a33:	c3                   	ret    

00801a34 <devfile_read>:
{
  801a34:	f3 0f 1e fb          	endbr32 
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
  801a3b:	56                   	push   %esi
  801a3c:	53                   	push   %ebx
  801a3d:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a40:	8b 45 08             	mov    0x8(%ebp),%eax
  801a43:	8b 40 0c             	mov    0xc(%eax),%eax
  801a46:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a4b:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a51:	ba 00 00 00 00       	mov    $0x0,%edx
  801a56:	b8 03 00 00 00       	mov    $0x3,%eax
  801a5b:	e8 8c fe ff ff       	call   8018ec <fsipc>
  801a60:	89 c3                	mov    %eax,%ebx
  801a62:	85 c0                	test   %eax,%eax
  801a64:	78 1f                	js     801a85 <devfile_read+0x51>
	assert(r <= n);
  801a66:	39 f0                	cmp    %esi,%eax
  801a68:	77 24                	ja     801a8e <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801a6a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a6f:	7f 33                	jg     801aa4 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a71:	83 ec 04             	sub    $0x4,%esp
  801a74:	50                   	push   %eax
  801a75:	68 00 50 80 00       	push   $0x805000
  801a7a:	ff 75 0c             	pushl  0xc(%ebp)
  801a7d:	e8 eb ef ff ff       	call   800a6d <memmove>
	return r;
  801a82:	83 c4 10             	add    $0x10,%esp
}
  801a85:	89 d8                	mov    %ebx,%eax
  801a87:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a8a:	5b                   	pop    %ebx
  801a8b:	5e                   	pop    %esi
  801a8c:	5d                   	pop    %ebp
  801a8d:	c3                   	ret    
	assert(r <= n);
  801a8e:	68 0c 29 80 00       	push   $0x80290c
  801a93:	68 13 29 80 00       	push   $0x802913
  801a98:	6a 7c                	push   $0x7c
  801a9a:	68 28 29 80 00       	push   $0x802928
  801a9f:	e8 be 05 00 00       	call   802062 <_panic>
	assert(r <= PGSIZE);
  801aa4:	68 33 29 80 00       	push   $0x802933
  801aa9:	68 13 29 80 00       	push   $0x802913
  801aae:	6a 7d                	push   $0x7d
  801ab0:	68 28 29 80 00       	push   $0x802928
  801ab5:	e8 a8 05 00 00       	call   802062 <_panic>

00801aba <open>:
{
  801aba:	f3 0f 1e fb          	endbr32 
  801abe:	55                   	push   %ebp
  801abf:	89 e5                	mov    %esp,%ebp
  801ac1:	56                   	push   %esi
  801ac2:	53                   	push   %ebx
  801ac3:	83 ec 1c             	sub    $0x1c,%esp
  801ac6:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801ac9:	56                   	push   %esi
  801aca:	e8 a5 ed ff ff       	call   800874 <strlen>
  801acf:	83 c4 10             	add    $0x10,%esp
  801ad2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ad7:	7f 6c                	jg     801b45 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801ad9:	83 ec 0c             	sub    $0xc,%esp
  801adc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801adf:	50                   	push   %eax
  801ae0:	e8 67 f8 ff ff       	call   80134c <fd_alloc>
  801ae5:	89 c3                	mov    %eax,%ebx
  801ae7:	83 c4 10             	add    $0x10,%esp
  801aea:	85 c0                	test   %eax,%eax
  801aec:	78 3c                	js     801b2a <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801aee:	83 ec 08             	sub    $0x8,%esp
  801af1:	56                   	push   %esi
  801af2:	68 00 50 80 00       	push   $0x805000
  801af7:	e8 bb ed ff ff       	call   8008b7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801afc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aff:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b07:	b8 01 00 00 00       	mov    $0x1,%eax
  801b0c:	e8 db fd ff ff       	call   8018ec <fsipc>
  801b11:	89 c3                	mov    %eax,%ebx
  801b13:	83 c4 10             	add    $0x10,%esp
  801b16:	85 c0                	test   %eax,%eax
  801b18:	78 19                	js     801b33 <open+0x79>
	return fd2num(fd);
  801b1a:	83 ec 0c             	sub    $0xc,%esp
  801b1d:	ff 75 f4             	pushl  -0xc(%ebp)
  801b20:	e8 f8 f7 ff ff       	call   80131d <fd2num>
  801b25:	89 c3                	mov    %eax,%ebx
  801b27:	83 c4 10             	add    $0x10,%esp
}
  801b2a:	89 d8                	mov    %ebx,%eax
  801b2c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b2f:	5b                   	pop    %ebx
  801b30:	5e                   	pop    %esi
  801b31:	5d                   	pop    %ebp
  801b32:	c3                   	ret    
		fd_close(fd, 0);
  801b33:	83 ec 08             	sub    $0x8,%esp
  801b36:	6a 00                	push   $0x0
  801b38:	ff 75 f4             	pushl  -0xc(%ebp)
  801b3b:	e8 10 f9 ff ff       	call   801450 <fd_close>
		return r;
  801b40:	83 c4 10             	add    $0x10,%esp
  801b43:	eb e5                	jmp    801b2a <open+0x70>
		return -E_BAD_PATH;
  801b45:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b4a:	eb de                	jmp    801b2a <open+0x70>

00801b4c <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b4c:	f3 0f 1e fb          	endbr32 
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
  801b53:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b56:	ba 00 00 00 00       	mov    $0x0,%edx
  801b5b:	b8 08 00 00 00       	mov    $0x8,%eax
  801b60:	e8 87 fd ff ff       	call   8018ec <fsipc>
}
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b67:	f3 0f 1e fb          	endbr32 
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
  801b6e:	56                   	push   %esi
  801b6f:	53                   	push   %ebx
  801b70:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b73:	83 ec 0c             	sub    $0xc,%esp
  801b76:	ff 75 08             	pushl  0x8(%ebp)
  801b79:	e8 b3 f7 ff ff       	call   801331 <fd2data>
  801b7e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b80:	83 c4 08             	add    $0x8,%esp
  801b83:	68 3f 29 80 00       	push   $0x80293f
  801b88:	53                   	push   %ebx
  801b89:	e8 29 ed ff ff       	call   8008b7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b8e:	8b 46 04             	mov    0x4(%esi),%eax
  801b91:	2b 06                	sub    (%esi),%eax
  801b93:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b99:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ba0:	00 00 00 
	stat->st_dev = &devpipe;
  801ba3:	c7 83 88 00 00 00 28 	movl   $0x803028,0x88(%ebx)
  801baa:	30 80 00 
	return 0;
}
  801bad:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bb5:	5b                   	pop    %ebx
  801bb6:	5e                   	pop    %esi
  801bb7:	5d                   	pop    %ebp
  801bb8:	c3                   	ret    

00801bb9 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801bb9:	f3 0f 1e fb          	endbr32 
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
  801bc0:	53                   	push   %ebx
  801bc1:	83 ec 0c             	sub    $0xc,%esp
  801bc4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801bc7:	53                   	push   %ebx
  801bc8:	6a 00                	push   $0x0
  801bca:	e8 b7 f1 ff ff       	call   800d86 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801bcf:	89 1c 24             	mov    %ebx,(%esp)
  801bd2:	e8 5a f7 ff ff       	call   801331 <fd2data>
  801bd7:	83 c4 08             	add    $0x8,%esp
  801bda:	50                   	push   %eax
  801bdb:	6a 00                	push   $0x0
  801bdd:	e8 a4 f1 ff ff       	call   800d86 <sys_page_unmap>
}
  801be2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <_pipeisclosed>:
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
  801bea:	57                   	push   %edi
  801beb:	56                   	push   %esi
  801bec:	53                   	push   %ebx
  801bed:	83 ec 1c             	sub    $0x1c,%esp
  801bf0:	89 c7                	mov    %eax,%edi
  801bf2:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801bf4:	a1 04 40 80 00       	mov    0x804004,%eax
  801bf9:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801bfc:	83 ec 0c             	sub    $0xc,%esp
  801bff:	57                   	push   %edi
  801c00:	e8 40 05 00 00       	call   802145 <pageref>
  801c05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c08:	89 34 24             	mov    %esi,(%esp)
  801c0b:	e8 35 05 00 00       	call   802145 <pageref>
		nn = thisenv->env_runs;
  801c10:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c16:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c19:	83 c4 10             	add    $0x10,%esp
  801c1c:	39 cb                	cmp    %ecx,%ebx
  801c1e:	74 1b                	je     801c3b <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c20:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c23:	75 cf                	jne    801bf4 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c25:	8b 42 58             	mov    0x58(%edx),%eax
  801c28:	6a 01                	push   $0x1
  801c2a:	50                   	push   %eax
  801c2b:	53                   	push   %ebx
  801c2c:	68 46 29 80 00       	push   $0x802946
  801c31:	e8 77 e6 ff ff       	call   8002ad <cprintf>
  801c36:	83 c4 10             	add    $0x10,%esp
  801c39:	eb b9                	jmp    801bf4 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801c3b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c3e:	0f 94 c0             	sete   %al
  801c41:	0f b6 c0             	movzbl %al,%eax
}
  801c44:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c47:	5b                   	pop    %ebx
  801c48:	5e                   	pop    %esi
  801c49:	5f                   	pop    %edi
  801c4a:	5d                   	pop    %ebp
  801c4b:	c3                   	ret    

00801c4c <devpipe_write>:
{
  801c4c:	f3 0f 1e fb          	endbr32 
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
  801c53:	57                   	push   %edi
  801c54:	56                   	push   %esi
  801c55:	53                   	push   %ebx
  801c56:	83 ec 28             	sub    $0x28,%esp
  801c59:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801c5c:	56                   	push   %esi
  801c5d:	e8 cf f6 ff ff       	call   801331 <fd2data>
  801c62:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c64:	83 c4 10             	add    $0x10,%esp
  801c67:	bf 00 00 00 00       	mov    $0x0,%edi
  801c6c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c6f:	74 4f                	je     801cc0 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c71:	8b 43 04             	mov    0x4(%ebx),%eax
  801c74:	8b 0b                	mov    (%ebx),%ecx
  801c76:	8d 51 20             	lea    0x20(%ecx),%edx
  801c79:	39 d0                	cmp    %edx,%eax
  801c7b:	72 14                	jb     801c91 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801c7d:	89 da                	mov    %ebx,%edx
  801c7f:	89 f0                	mov    %esi,%eax
  801c81:	e8 61 ff ff ff       	call   801be7 <_pipeisclosed>
  801c86:	85 c0                	test   %eax,%eax
  801c88:	75 3b                	jne    801cc5 <devpipe_write+0x79>
			sys_yield();
  801c8a:	e8 47 f0 ff ff       	call   800cd6 <sys_yield>
  801c8f:	eb e0                	jmp    801c71 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c94:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c98:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c9b:	89 c2                	mov    %eax,%edx
  801c9d:	c1 fa 1f             	sar    $0x1f,%edx
  801ca0:	89 d1                	mov    %edx,%ecx
  801ca2:	c1 e9 1b             	shr    $0x1b,%ecx
  801ca5:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801ca8:	83 e2 1f             	and    $0x1f,%edx
  801cab:	29 ca                	sub    %ecx,%edx
  801cad:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801cb1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801cb5:	83 c0 01             	add    $0x1,%eax
  801cb8:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801cbb:	83 c7 01             	add    $0x1,%edi
  801cbe:	eb ac                	jmp    801c6c <devpipe_write+0x20>
	return i;
  801cc0:	8b 45 10             	mov    0x10(%ebp),%eax
  801cc3:	eb 05                	jmp    801cca <devpipe_write+0x7e>
				return 0;
  801cc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ccd:	5b                   	pop    %ebx
  801cce:	5e                   	pop    %esi
  801ccf:	5f                   	pop    %edi
  801cd0:	5d                   	pop    %ebp
  801cd1:	c3                   	ret    

00801cd2 <devpipe_read>:
{
  801cd2:	f3 0f 1e fb          	endbr32 
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
  801cd9:	57                   	push   %edi
  801cda:	56                   	push   %esi
  801cdb:	53                   	push   %ebx
  801cdc:	83 ec 18             	sub    $0x18,%esp
  801cdf:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801ce2:	57                   	push   %edi
  801ce3:	e8 49 f6 ff ff       	call   801331 <fd2data>
  801ce8:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801cea:	83 c4 10             	add    $0x10,%esp
  801ced:	be 00 00 00 00       	mov    $0x0,%esi
  801cf2:	3b 75 10             	cmp    0x10(%ebp),%esi
  801cf5:	75 14                	jne    801d0b <devpipe_read+0x39>
	return i;
  801cf7:	8b 45 10             	mov    0x10(%ebp),%eax
  801cfa:	eb 02                	jmp    801cfe <devpipe_read+0x2c>
				return i;
  801cfc:	89 f0                	mov    %esi,%eax
}
  801cfe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d01:	5b                   	pop    %ebx
  801d02:	5e                   	pop    %esi
  801d03:	5f                   	pop    %edi
  801d04:	5d                   	pop    %ebp
  801d05:	c3                   	ret    
			sys_yield();
  801d06:	e8 cb ef ff ff       	call   800cd6 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801d0b:	8b 03                	mov    (%ebx),%eax
  801d0d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d10:	75 18                	jne    801d2a <devpipe_read+0x58>
			if (i > 0)
  801d12:	85 f6                	test   %esi,%esi
  801d14:	75 e6                	jne    801cfc <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801d16:	89 da                	mov    %ebx,%edx
  801d18:	89 f8                	mov    %edi,%eax
  801d1a:	e8 c8 fe ff ff       	call   801be7 <_pipeisclosed>
  801d1f:	85 c0                	test   %eax,%eax
  801d21:	74 e3                	je     801d06 <devpipe_read+0x34>
				return 0;
  801d23:	b8 00 00 00 00       	mov    $0x0,%eax
  801d28:	eb d4                	jmp    801cfe <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d2a:	99                   	cltd   
  801d2b:	c1 ea 1b             	shr    $0x1b,%edx
  801d2e:	01 d0                	add    %edx,%eax
  801d30:	83 e0 1f             	and    $0x1f,%eax
  801d33:	29 d0                	sub    %edx,%eax
  801d35:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d3d:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d40:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801d43:	83 c6 01             	add    $0x1,%esi
  801d46:	eb aa                	jmp    801cf2 <devpipe_read+0x20>

00801d48 <pipe>:
{
  801d48:	f3 0f 1e fb          	endbr32 
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
  801d4f:	56                   	push   %esi
  801d50:	53                   	push   %ebx
  801d51:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801d54:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d57:	50                   	push   %eax
  801d58:	e8 ef f5 ff ff       	call   80134c <fd_alloc>
  801d5d:	89 c3                	mov    %eax,%ebx
  801d5f:	83 c4 10             	add    $0x10,%esp
  801d62:	85 c0                	test   %eax,%eax
  801d64:	0f 88 23 01 00 00    	js     801e8d <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d6a:	83 ec 04             	sub    $0x4,%esp
  801d6d:	68 07 04 00 00       	push   $0x407
  801d72:	ff 75 f4             	pushl  -0xc(%ebp)
  801d75:	6a 00                	push   $0x0
  801d77:	e8 7d ef ff ff       	call   800cf9 <sys_page_alloc>
  801d7c:	89 c3                	mov    %eax,%ebx
  801d7e:	83 c4 10             	add    $0x10,%esp
  801d81:	85 c0                	test   %eax,%eax
  801d83:	0f 88 04 01 00 00    	js     801e8d <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801d89:	83 ec 0c             	sub    $0xc,%esp
  801d8c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d8f:	50                   	push   %eax
  801d90:	e8 b7 f5 ff ff       	call   80134c <fd_alloc>
  801d95:	89 c3                	mov    %eax,%ebx
  801d97:	83 c4 10             	add    $0x10,%esp
  801d9a:	85 c0                	test   %eax,%eax
  801d9c:	0f 88 db 00 00 00    	js     801e7d <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801da2:	83 ec 04             	sub    $0x4,%esp
  801da5:	68 07 04 00 00       	push   $0x407
  801daa:	ff 75 f0             	pushl  -0x10(%ebp)
  801dad:	6a 00                	push   $0x0
  801daf:	e8 45 ef ff ff       	call   800cf9 <sys_page_alloc>
  801db4:	89 c3                	mov    %eax,%ebx
  801db6:	83 c4 10             	add    $0x10,%esp
  801db9:	85 c0                	test   %eax,%eax
  801dbb:	0f 88 bc 00 00 00    	js     801e7d <pipe+0x135>
	va = fd2data(fd0);
  801dc1:	83 ec 0c             	sub    $0xc,%esp
  801dc4:	ff 75 f4             	pushl  -0xc(%ebp)
  801dc7:	e8 65 f5 ff ff       	call   801331 <fd2data>
  801dcc:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dce:	83 c4 0c             	add    $0xc,%esp
  801dd1:	68 07 04 00 00       	push   $0x407
  801dd6:	50                   	push   %eax
  801dd7:	6a 00                	push   $0x0
  801dd9:	e8 1b ef ff ff       	call   800cf9 <sys_page_alloc>
  801dde:	89 c3                	mov    %eax,%ebx
  801de0:	83 c4 10             	add    $0x10,%esp
  801de3:	85 c0                	test   %eax,%eax
  801de5:	0f 88 82 00 00 00    	js     801e6d <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801deb:	83 ec 0c             	sub    $0xc,%esp
  801dee:	ff 75 f0             	pushl  -0x10(%ebp)
  801df1:	e8 3b f5 ff ff       	call   801331 <fd2data>
  801df6:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801dfd:	50                   	push   %eax
  801dfe:	6a 00                	push   $0x0
  801e00:	56                   	push   %esi
  801e01:	6a 00                	push   $0x0
  801e03:	e8 38 ef ff ff       	call   800d40 <sys_page_map>
  801e08:	89 c3                	mov    %eax,%ebx
  801e0a:	83 c4 20             	add    $0x20,%esp
  801e0d:	85 c0                	test   %eax,%eax
  801e0f:	78 4e                	js     801e5f <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801e11:	a1 28 30 80 00       	mov    0x803028,%eax
  801e16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e19:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801e1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e1e:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801e25:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e28:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801e2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e2d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e34:	83 ec 0c             	sub    $0xc,%esp
  801e37:	ff 75 f4             	pushl  -0xc(%ebp)
  801e3a:	e8 de f4 ff ff       	call   80131d <fd2num>
  801e3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e42:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e44:	83 c4 04             	add    $0x4,%esp
  801e47:	ff 75 f0             	pushl  -0x10(%ebp)
  801e4a:	e8 ce f4 ff ff       	call   80131d <fd2num>
  801e4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e52:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e55:	83 c4 10             	add    $0x10,%esp
  801e58:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e5d:	eb 2e                	jmp    801e8d <pipe+0x145>
	sys_page_unmap(0, va);
  801e5f:	83 ec 08             	sub    $0x8,%esp
  801e62:	56                   	push   %esi
  801e63:	6a 00                	push   $0x0
  801e65:	e8 1c ef ff ff       	call   800d86 <sys_page_unmap>
  801e6a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e6d:	83 ec 08             	sub    $0x8,%esp
  801e70:	ff 75 f0             	pushl  -0x10(%ebp)
  801e73:	6a 00                	push   $0x0
  801e75:	e8 0c ef ff ff       	call   800d86 <sys_page_unmap>
  801e7a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801e7d:	83 ec 08             	sub    $0x8,%esp
  801e80:	ff 75 f4             	pushl  -0xc(%ebp)
  801e83:	6a 00                	push   $0x0
  801e85:	e8 fc ee ff ff       	call   800d86 <sys_page_unmap>
  801e8a:	83 c4 10             	add    $0x10,%esp
}
  801e8d:	89 d8                	mov    %ebx,%eax
  801e8f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e92:	5b                   	pop    %ebx
  801e93:	5e                   	pop    %esi
  801e94:	5d                   	pop    %ebp
  801e95:	c3                   	ret    

00801e96 <pipeisclosed>:
{
  801e96:	f3 0f 1e fb          	endbr32 
  801e9a:	55                   	push   %ebp
  801e9b:	89 e5                	mov    %esp,%ebp
  801e9d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ea0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ea3:	50                   	push   %eax
  801ea4:	ff 75 08             	pushl  0x8(%ebp)
  801ea7:	e8 f6 f4 ff ff       	call   8013a2 <fd_lookup>
  801eac:	83 c4 10             	add    $0x10,%esp
  801eaf:	85 c0                	test   %eax,%eax
  801eb1:	78 18                	js     801ecb <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801eb3:	83 ec 0c             	sub    $0xc,%esp
  801eb6:	ff 75 f4             	pushl  -0xc(%ebp)
  801eb9:	e8 73 f4 ff ff       	call   801331 <fd2data>
  801ebe:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec3:	e8 1f fd ff ff       	call   801be7 <_pipeisclosed>
  801ec8:	83 c4 10             	add    $0x10,%esp
}
  801ecb:	c9                   	leave  
  801ecc:	c3                   	ret    

00801ecd <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801ecd:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801ed1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed6:	c3                   	ret    

00801ed7 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801ed7:	f3 0f 1e fb          	endbr32 
  801edb:	55                   	push   %ebp
  801edc:	89 e5                	mov    %esp,%ebp
  801ede:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801ee1:	68 5e 29 80 00       	push   $0x80295e
  801ee6:	ff 75 0c             	pushl  0xc(%ebp)
  801ee9:	e8 c9 e9 ff ff       	call   8008b7 <strcpy>
	return 0;
}
  801eee:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef3:	c9                   	leave  
  801ef4:	c3                   	ret    

00801ef5 <devcons_write>:
{
  801ef5:	f3 0f 1e fb          	endbr32 
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
  801efc:	57                   	push   %edi
  801efd:	56                   	push   %esi
  801efe:	53                   	push   %ebx
  801eff:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801f05:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801f0a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801f10:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f13:	73 31                	jae    801f46 <devcons_write+0x51>
		m = n - tot;
  801f15:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f18:	29 f3                	sub    %esi,%ebx
  801f1a:	83 fb 7f             	cmp    $0x7f,%ebx
  801f1d:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801f22:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801f25:	83 ec 04             	sub    $0x4,%esp
  801f28:	53                   	push   %ebx
  801f29:	89 f0                	mov    %esi,%eax
  801f2b:	03 45 0c             	add    0xc(%ebp),%eax
  801f2e:	50                   	push   %eax
  801f2f:	57                   	push   %edi
  801f30:	e8 38 eb ff ff       	call   800a6d <memmove>
		sys_cputs(buf, m);
  801f35:	83 c4 08             	add    $0x8,%esp
  801f38:	53                   	push   %ebx
  801f39:	57                   	push   %edi
  801f3a:	e8 ea ec ff ff       	call   800c29 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801f3f:	01 de                	add    %ebx,%esi
  801f41:	83 c4 10             	add    $0x10,%esp
  801f44:	eb ca                	jmp    801f10 <devcons_write+0x1b>
}
  801f46:	89 f0                	mov    %esi,%eax
  801f48:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f4b:	5b                   	pop    %ebx
  801f4c:	5e                   	pop    %esi
  801f4d:	5f                   	pop    %edi
  801f4e:	5d                   	pop    %ebp
  801f4f:	c3                   	ret    

00801f50 <devcons_read>:
{
  801f50:	f3 0f 1e fb          	endbr32 
  801f54:	55                   	push   %ebp
  801f55:	89 e5                	mov    %esp,%ebp
  801f57:	83 ec 08             	sub    $0x8,%esp
  801f5a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801f5f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f63:	74 21                	je     801f86 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801f65:	e8 e1 ec ff ff       	call   800c4b <sys_cgetc>
  801f6a:	85 c0                	test   %eax,%eax
  801f6c:	75 07                	jne    801f75 <devcons_read+0x25>
		sys_yield();
  801f6e:	e8 63 ed ff ff       	call   800cd6 <sys_yield>
  801f73:	eb f0                	jmp    801f65 <devcons_read+0x15>
	if (c < 0)
  801f75:	78 0f                	js     801f86 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801f77:	83 f8 04             	cmp    $0x4,%eax
  801f7a:	74 0c                	je     801f88 <devcons_read+0x38>
	*(char*)vbuf = c;
  801f7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f7f:	88 02                	mov    %al,(%edx)
	return 1;
  801f81:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801f86:	c9                   	leave  
  801f87:	c3                   	ret    
		return 0;
  801f88:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8d:	eb f7                	jmp    801f86 <devcons_read+0x36>

00801f8f <cputchar>:
{
  801f8f:	f3 0f 1e fb          	endbr32 
  801f93:	55                   	push   %ebp
  801f94:	89 e5                	mov    %esp,%ebp
  801f96:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f99:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9c:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801f9f:	6a 01                	push   $0x1
  801fa1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801fa4:	50                   	push   %eax
  801fa5:	e8 7f ec ff ff       	call   800c29 <sys_cputs>
}
  801faa:	83 c4 10             	add    $0x10,%esp
  801fad:	c9                   	leave  
  801fae:	c3                   	ret    

00801faf <getchar>:
{
  801faf:	f3 0f 1e fb          	endbr32 
  801fb3:	55                   	push   %ebp
  801fb4:	89 e5                	mov    %esp,%ebp
  801fb6:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801fb9:	6a 01                	push   $0x1
  801fbb:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801fbe:	50                   	push   %eax
  801fbf:	6a 00                	push   $0x0
  801fc1:	e8 5f f6 ff ff       	call   801625 <read>
	if (r < 0)
  801fc6:	83 c4 10             	add    $0x10,%esp
  801fc9:	85 c0                	test   %eax,%eax
  801fcb:	78 06                	js     801fd3 <getchar+0x24>
	if (r < 1)
  801fcd:	74 06                	je     801fd5 <getchar+0x26>
	return c;
  801fcf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801fd3:	c9                   	leave  
  801fd4:	c3                   	ret    
		return -E_EOF;
  801fd5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801fda:	eb f7                	jmp    801fd3 <getchar+0x24>

00801fdc <iscons>:
{
  801fdc:	f3 0f 1e fb          	endbr32 
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
  801fe3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fe6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fe9:	50                   	push   %eax
  801fea:	ff 75 08             	pushl  0x8(%ebp)
  801fed:	e8 b0 f3 ff ff       	call   8013a2 <fd_lookup>
  801ff2:	83 c4 10             	add    $0x10,%esp
  801ff5:	85 c0                	test   %eax,%eax
  801ff7:	78 11                	js     80200a <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffc:	8b 15 44 30 80 00    	mov    0x803044,%edx
  802002:	39 10                	cmp    %edx,(%eax)
  802004:	0f 94 c0             	sete   %al
  802007:	0f b6 c0             	movzbl %al,%eax
}
  80200a:	c9                   	leave  
  80200b:	c3                   	ret    

0080200c <opencons>:
{
  80200c:	f3 0f 1e fb          	endbr32 
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
  802013:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802016:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802019:	50                   	push   %eax
  80201a:	e8 2d f3 ff ff       	call   80134c <fd_alloc>
  80201f:	83 c4 10             	add    $0x10,%esp
  802022:	85 c0                	test   %eax,%eax
  802024:	78 3a                	js     802060 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802026:	83 ec 04             	sub    $0x4,%esp
  802029:	68 07 04 00 00       	push   $0x407
  80202e:	ff 75 f4             	pushl  -0xc(%ebp)
  802031:	6a 00                	push   $0x0
  802033:	e8 c1 ec ff ff       	call   800cf9 <sys_page_alloc>
  802038:	83 c4 10             	add    $0x10,%esp
  80203b:	85 c0                	test   %eax,%eax
  80203d:	78 21                	js     802060 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80203f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802042:	8b 15 44 30 80 00    	mov    0x803044,%edx
  802048:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80204a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802054:	83 ec 0c             	sub    $0xc,%esp
  802057:	50                   	push   %eax
  802058:	e8 c0 f2 ff ff       	call   80131d <fd2num>
  80205d:	83 c4 10             	add    $0x10,%esp
}
  802060:	c9                   	leave  
  802061:	c3                   	ret    

00802062 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802062:	f3 0f 1e fb          	endbr32 
  802066:	55                   	push   %ebp
  802067:	89 e5                	mov    %esp,%ebp
  802069:	56                   	push   %esi
  80206a:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80206b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80206e:	8b 35 08 30 80 00    	mov    0x803008,%esi
  802074:	e8 3a ec ff ff       	call   800cb3 <sys_getenvid>
  802079:	83 ec 0c             	sub    $0xc,%esp
  80207c:	ff 75 0c             	pushl  0xc(%ebp)
  80207f:	ff 75 08             	pushl  0x8(%ebp)
  802082:	56                   	push   %esi
  802083:	50                   	push   %eax
  802084:	68 6c 29 80 00       	push   $0x80296c
  802089:	e8 1f e2 ff ff       	call   8002ad <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80208e:	83 c4 18             	add    $0x18,%esp
  802091:	53                   	push   %ebx
  802092:	ff 75 10             	pushl  0x10(%ebp)
  802095:	e8 be e1 ff ff       	call   800258 <vcprintf>
	cprintf("\n");
  80209a:	c7 04 24 74 28 80 00 	movl   $0x802874,(%esp)
  8020a1:	e8 07 e2 ff ff       	call   8002ad <cprintf>
  8020a6:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8020a9:	cc                   	int3   
  8020aa:	eb fd                	jmp    8020a9 <_panic+0x47>

008020ac <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8020ac:	f3 0f 1e fb          	endbr32 
  8020b0:	55                   	push   %ebp
  8020b1:	89 e5                	mov    %esp,%ebp
  8020b3:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8020b6:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8020bd:	74 0a                	je     8020c9 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8020bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c2:	a3 00 60 80 00       	mov    %eax,0x806000
}
  8020c7:	c9                   	leave  
  8020c8:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  8020c9:	83 ec 04             	sub    $0x4,%esp
  8020cc:	6a 07                	push   $0x7
  8020ce:	68 00 f0 bf ee       	push   $0xeebff000
  8020d3:	6a 00                	push   $0x0
  8020d5:	e8 1f ec ff ff       	call   800cf9 <sys_page_alloc>
  8020da:	83 c4 10             	add    $0x10,%esp
  8020dd:	85 c0                	test   %eax,%eax
  8020df:	78 2a                	js     80210b <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  8020e1:	83 ec 08             	sub    $0x8,%esp
  8020e4:	68 1f 21 80 00       	push   $0x80211f
  8020e9:	6a 00                	push   $0x0
  8020eb:	e8 68 ed ff ff       	call   800e58 <sys_env_set_pgfault_upcall>
  8020f0:	83 c4 10             	add    $0x10,%esp
  8020f3:	85 c0                	test   %eax,%eax
  8020f5:	79 c8                	jns    8020bf <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  8020f7:	83 ec 04             	sub    $0x4,%esp
  8020fa:	68 bc 29 80 00       	push   $0x8029bc
  8020ff:	6a 25                	push   $0x25
  802101:	68 f4 29 80 00       	push   $0x8029f4
  802106:	e8 57 ff ff ff       	call   802062 <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  80210b:	83 ec 04             	sub    $0x4,%esp
  80210e:	68 90 29 80 00       	push   $0x802990
  802113:	6a 22                	push   $0x22
  802115:	68 f4 29 80 00       	push   $0x8029f4
  80211a:	e8 43 ff ff ff       	call   802062 <_panic>

0080211f <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80211f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802120:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  802125:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802127:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  80212a:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  80212e:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  802132:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802135:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  802137:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  80213b:	83 c4 08             	add    $0x8,%esp
	popal
  80213e:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  80213f:	83 c4 04             	add    $0x4,%esp
	popfl
  802142:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  802143:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  802144:	c3                   	ret    

00802145 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802145:	f3 0f 1e fb          	endbr32 
  802149:	55                   	push   %ebp
  80214a:	89 e5                	mov    %esp,%ebp
  80214c:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80214f:	89 c2                	mov    %eax,%edx
  802151:	c1 ea 16             	shr    $0x16,%edx
  802154:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80215b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802160:	f6 c1 01             	test   $0x1,%cl
  802163:	74 1c                	je     802181 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802165:	c1 e8 0c             	shr    $0xc,%eax
  802168:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80216f:	a8 01                	test   $0x1,%al
  802171:	74 0e                	je     802181 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802173:	c1 e8 0c             	shr    $0xc,%eax
  802176:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80217d:	ef 
  80217e:	0f b7 d2             	movzwl %dx,%edx
}
  802181:	89 d0                	mov    %edx,%eax
  802183:	5d                   	pop    %ebp
  802184:	c3                   	ret    
  802185:	66 90                	xchg   %ax,%ax
  802187:	66 90                	xchg   %ax,%ax
  802189:	66 90                	xchg   %ax,%ax
  80218b:	66 90                	xchg   %ax,%ax
  80218d:	66 90                	xchg   %ax,%ax
  80218f:	90                   	nop

00802190 <__udivdi3>:
  802190:	f3 0f 1e fb          	endbr32 
  802194:	55                   	push   %ebp
  802195:	57                   	push   %edi
  802196:	56                   	push   %esi
  802197:	53                   	push   %ebx
  802198:	83 ec 1c             	sub    $0x1c,%esp
  80219b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80219f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8021a3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021a7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8021ab:	85 d2                	test   %edx,%edx
  8021ad:	75 19                	jne    8021c8 <__udivdi3+0x38>
  8021af:	39 f3                	cmp    %esi,%ebx
  8021b1:	76 4d                	jbe    802200 <__udivdi3+0x70>
  8021b3:	31 ff                	xor    %edi,%edi
  8021b5:	89 e8                	mov    %ebp,%eax
  8021b7:	89 f2                	mov    %esi,%edx
  8021b9:	f7 f3                	div    %ebx
  8021bb:	89 fa                	mov    %edi,%edx
  8021bd:	83 c4 1c             	add    $0x1c,%esp
  8021c0:	5b                   	pop    %ebx
  8021c1:	5e                   	pop    %esi
  8021c2:	5f                   	pop    %edi
  8021c3:	5d                   	pop    %ebp
  8021c4:	c3                   	ret    
  8021c5:	8d 76 00             	lea    0x0(%esi),%esi
  8021c8:	39 f2                	cmp    %esi,%edx
  8021ca:	76 14                	jbe    8021e0 <__udivdi3+0x50>
  8021cc:	31 ff                	xor    %edi,%edi
  8021ce:	31 c0                	xor    %eax,%eax
  8021d0:	89 fa                	mov    %edi,%edx
  8021d2:	83 c4 1c             	add    $0x1c,%esp
  8021d5:	5b                   	pop    %ebx
  8021d6:	5e                   	pop    %esi
  8021d7:	5f                   	pop    %edi
  8021d8:	5d                   	pop    %ebp
  8021d9:	c3                   	ret    
  8021da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021e0:	0f bd fa             	bsr    %edx,%edi
  8021e3:	83 f7 1f             	xor    $0x1f,%edi
  8021e6:	75 48                	jne    802230 <__udivdi3+0xa0>
  8021e8:	39 f2                	cmp    %esi,%edx
  8021ea:	72 06                	jb     8021f2 <__udivdi3+0x62>
  8021ec:	31 c0                	xor    %eax,%eax
  8021ee:	39 eb                	cmp    %ebp,%ebx
  8021f0:	77 de                	ja     8021d0 <__udivdi3+0x40>
  8021f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8021f7:	eb d7                	jmp    8021d0 <__udivdi3+0x40>
  8021f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802200:	89 d9                	mov    %ebx,%ecx
  802202:	85 db                	test   %ebx,%ebx
  802204:	75 0b                	jne    802211 <__udivdi3+0x81>
  802206:	b8 01 00 00 00       	mov    $0x1,%eax
  80220b:	31 d2                	xor    %edx,%edx
  80220d:	f7 f3                	div    %ebx
  80220f:	89 c1                	mov    %eax,%ecx
  802211:	31 d2                	xor    %edx,%edx
  802213:	89 f0                	mov    %esi,%eax
  802215:	f7 f1                	div    %ecx
  802217:	89 c6                	mov    %eax,%esi
  802219:	89 e8                	mov    %ebp,%eax
  80221b:	89 f7                	mov    %esi,%edi
  80221d:	f7 f1                	div    %ecx
  80221f:	89 fa                	mov    %edi,%edx
  802221:	83 c4 1c             	add    $0x1c,%esp
  802224:	5b                   	pop    %ebx
  802225:	5e                   	pop    %esi
  802226:	5f                   	pop    %edi
  802227:	5d                   	pop    %ebp
  802228:	c3                   	ret    
  802229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802230:	89 f9                	mov    %edi,%ecx
  802232:	b8 20 00 00 00       	mov    $0x20,%eax
  802237:	29 f8                	sub    %edi,%eax
  802239:	d3 e2                	shl    %cl,%edx
  80223b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80223f:	89 c1                	mov    %eax,%ecx
  802241:	89 da                	mov    %ebx,%edx
  802243:	d3 ea                	shr    %cl,%edx
  802245:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802249:	09 d1                	or     %edx,%ecx
  80224b:	89 f2                	mov    %esi,%edx
  80224d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802251:	89 f9                	mov    %edi,%ecx
  802253:	d3 e3                	shl    %cl,%ebx
  802255:	89 c1                	mov    %eax,%ecx
  802257:	d3 ea                	shr    %cl,%edx
  802259:	89 f9                	mov    %edi,%ecx
  80225b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80225f:	89 eb                	mov    %ebp,%ebx
  802261:	d3 e6                	shl    %cl,%esi
  802263:	89 c1                	mov    %eax,%ecx
  802265:	d3 eb                	shr    %cl,%ebx
  802267:	09 de                	or     %ebx,%esi
  802269:	89 f0                	mov    %esi,%eax
  80226b:	f7 74 24 08          	divl   0x8(%esp)
  80226f:	89 d6                	mov    %edx,%esi
  802271:	89 c3                	mov    %eax,%ebx
  802273:	f7 64 24 0c          	mull   0xc(%esp)
  802277:	39 d6                	cmp    %edx,%esi
  802279:	72 15                	jb     802290 <__udivdi3+0x100>
  80227b:	89 f9                	mov    %edi,%ecx
  80227d:	d3 e5                	shl    %cl,%ebp
  80227f:	39 c5                	cmp    %eax,%ebp
  802281:	73 04                	jae    802287 <__udivdi3+0xf7>
  802283:	39 d6                	cmp    %edx,%esi
  802285:	74 09                	je     802290 <__udivdi3+0x100>
  802287:	89 d8                	mov    %ebx,%eax
  802289:	31 ff                	xor    %edi,%edi
  80228b:	e9 40 ff ff ff       	jmp    8021d0 <__udivdi3+0x40>
  802290:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802293:	31 ff                	xor    %edi,%edi
  802295:	e9 36 ff ff ff       	jmp    8021d0 <__udivdi3+0x40>
  80229a:	66 90                	xchg   %ax,%ax
  80229c:	66 90                	xchg   %ax,%ax
  80229e:	66 90                	xchg   %ax,%ax

008022a0 <__umoddi3>:
  8022a0:	f3 0f 1e fb          	endbr32 
  8022a4:	55                   	push   %ebp
  8022a5:	57                   	push   %edi
  8022a6:	56                   	push   %esi
  8022a7:	53                   	push   %ebx
  8022a8:	83 ec 1c             	sub    $0x1c,%esp
  8022ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8022af:	8b 74 24 30          	mov    0x30(%esp),%esi
  8022b3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8022b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022bb:	85 c0                	test   %eax,%eax
  8022bd:	75 19                	jne    8022d8 <__umoddi3+0x38>
  8022bf:	39 df                	cmp    %ebx,%edi
  8022c1:	76 5d                	jbe    802320 <__umoddi3+0x80>
  8022c3:	89 f0                	mov    %esi,%eax
  8022c5:	89 da                	mov    %ebx,%edx
  8022c7:	f7 f7                	div    %edi
  8022c9:	89 d0                	mov    %edx,%eax
  8022cb:	31 d2                	xor    %edx,%edx
  8022cd:	83 c4 1c             	add    $0x1c,%esp
  8022d0:	5b                   	pop    %ebx
  8022d1:	5e                   	pop    %esi
  8022d2:	5f                   	pop    %edi
  8022d3:	5d                   	pop    %ebp
  8022d4:	c3                   	ret    
  8022d5:	8d 76 00             	lea    0x0(%esi),%esi
  8022d8:	89 f2                	mov    %esi,%edx
  8022da:	39 d8                	cmp    %ebx,%eax
  8022dc:	76 12                	jbe    8022f0 <__umoddi3+0x50>
  8022de:	89 f0                	mov    %esi,%eax
  8022e0:	89 da                	mov    %ebx,%edx
  8022e2:	83 c4 1c             	add    $0x1c,%esp
  8022e5:	5b                   	pop    %ebx
  8022e6:	5e                   	pop    %esi
  8022e7:	5f                   	pop    %edi
  8022e8:	5d                   	pop    %ebp
  8022e9:	c3                   	ret    
  8022ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8022f0:	0f bd e8             	bsr    %eax,%ebp
  8022f3:	83 f5 1f             	xor    $0x1f,%ebp
  8022f6:	75 50                	jne    802348 <__umoddi3+0xa8>
  8022f8:	39 d8                	cmp    %ebx,%eax
  8022fa:	0f 82 e0 00 00 00    	jb     8023e0 <__umoddi3+0x140>
  802300:	89 d9                	mov    %ebx,%ecx
  802302:	39 f7                	cmp    %esi,%edi
  802304:	0f 86 d6 00 00 00    	jbe    8023e0 <__umoddi3+0x140>
  80230a:	89 d0                	mov    %edx,%eax
  80230c:	89 ca                	mov    %ecx,%edx
  80230e:	83 c4 1c             	add    $0x1c,%esp
  802311:	5b                   	pop    %ebx
  802312:	5e                   	pop    %esi
  802313:	5f                   	pop    %edi
  802314:	5d                   	pop    %ebp
  802315:	c3                   	ret    
  802316:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80231d:	8d 76 00             	lea    0x0(%esi),%esi
  802320:	89 fd                	mov    %edi,%ebp
  802322:	85 ff                	test   %edi,%edi
  802324:	75 0b                	jne    802331 <__umoddi3+0x91>
  802326:	b8 01 00 00 00       	mov    $0x1,%eax
  80232b:	31 d2                	xor    %edx,%edx
  80232d:	f7 f7                	div    %edi
  80232f:	89 c5                	mov    %eax,%ebp
  802331:	89 d8                	mov    %ebx,%eax
  802333:	31 d2                	xor    %edx,%edx
  802335:	f7 f5                	div    %ebp
  802337:	89 f0                	mov    %esi,%eax
  802339:	f7 f5                	div    %ebp
  80233b:	89 d0                	mov    %edx,%eax
  80233d:	31 d2                	xor    %edx,%edx
  80233f:	eb 8c                	jmp    8022cd <__umoddi3+0x2d>
  802341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802348:	89 e9                	mov    %ebp,%ecx
  80234a:	ba 20 00 00 00       	mov    $0x20,%edx
  80234f:	29 ea                	sub    %ebp,%edx
  802351:	d3 e0                	shl    %cl,%eax
  802353:	89 44 24 08          	mov    %eax,0x8(%esp)
  802357:	89 d1                	mov    %edx,%ecx
  802359:	89 f8                	mov    %edi,%eax
  80235b:	d3 e8                	shr    %cl,%eax
  80235d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802361:	89 54 24 04          	mov    %edx,0x4(%esp)
  802365:	8b 54 24 04          	mov    0x4(%esp),%edx
  802369:	09 c1                	or     %eax,%ecx
  80236b:	89 d8                	mov    %ebx,%eax
  80236d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802371:	89 e9                	mov    %ebp,%ecx
  802373:	d3 e7                	shl    %cl,%edi
  802375:	89 d1                	mov    %edx,%ecx
  802377:	d3 e8                	shr    %cl,%eax
  802379:	89 e9                	mov    %ebp,%ecx
  80237b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80237f:	d3 e3                	shl    %cl,%ebx
  802381:	89 c7                	mov    %eax,%edi
  802383:	89 d1                	mov    %edx,%ecx
  802385:	89 f0                	mov    %esi,%eax
  802387:	d3 e8                	shr    %cl,%eax
  802389:	89 e9                	mov    %ebp,%ecx
  80238b:	89 fa                	mov    %edi,%edx
  80238d:	d3 e6                	shl    %cl,%esi
  80238f:	09 d8                	or     %ebx,%eax
  802391:	f7 74 24 08          	divl   0x8(%esp)
  802395:	89 d1                	mov    %edx,%ecx
  802397:	89 f3                	mov    %esi,%ebx
  802399:	f7 64 24 0c          	mull   0xc(%esp)
  80239d:	89 c6                	mov    %eax,%esi
  80239f:	89 d7                	mov    %edx,%edi
  8023a1:	39 d1                	cmp    %edx,%ecx
  8023a3:	72 06                	jb     8023ab <__umoddi3+0x10b>
  8023a5:	75 10                	jne    8023b7 <__umoddi3+0x117>
  8023a7:	39 c3                	cmp    %eax,%ebx
  8023a9:	73 0c                	jae    8023b7 <__umoddi3+0x117>
  8023ab:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8023af:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8023b3:	89 d7                	mov    %edx,%edi
  8023b5:	89 c6                	mov    %eax,%esi
  8023b7:	89 ca                	mov    %ecx,%edx
  8023b9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8023be:	29 f3                	sub    %esi,%ebx
  8023c0:	19 fa                	sbb    %edi,%edx
  8023c2:	89 d0                	mov    %edx,%eax
  8023c4:	d3 e0                	shl    %cl,%eax
  8023c6:	89 e9                	mov    %ebp,%ecx
  8023c8:	d3 eb                	shr    %cl,%ebx
  8023ca:	d3 ea                	shr    %cl,%edx
  8023cc:	09 d8                	or     %ebx,%eax
  8023ce:	83 c4 1c             	add    $0x1c,%esp
  8023d1:	5b                   	pop    %ebx
  8023d2:	5e                   	pop    %esi
  8023d3:	5f                   	pop    %edi
  8023d4:	5d                   	pop    %ebp
  8023d5:	c3                   	ret    
  8023d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023dd:	8d 76 00             	lea    0x0(%esi),%esi
  8023e0:	29 fe                	sub    %edi,%esi
  8023e2:	19 c3                	sbb    %eax,%ebx
  8023e4:	89 f2                	mov    %esi,%edx
  8023e6:	89 d9                	mov    %ebx,%ecx
  8023e8:	e9 1d ff ff ff       	jmp    80230a <__umoddi3+0x6a>
