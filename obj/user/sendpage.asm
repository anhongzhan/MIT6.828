
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
  80003d:	e8 57 10 00 00       	call   801099 <fork>
  800042:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800045:	85 c0                	test   %eax,%eax
  800047:	0f 84 a5 00 00 00    	je     8000f2 <umain+0xbf>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
		return;
	}

	// Parent
	sys_page_alloc(thisenv->env_id, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  80004d:	a1 08 40 80 00       	mov    0x804008,%eax
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
  800096:	e8 9c 12 00 00       	call   801337 <ipc_send>

	ipc_recv(&who, TEMP_ADDR, 0);
  80009b:	83 c4 1c             	add    $0x1c,%esp
  80009e:	6a 00                	push   $0x0
  8000a0:	68 00 00 a0 00       	push   $0xa00000
  8000a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000a8:	50                   	push   %eax
  8000a9:	e8 04 12 00 00       	call   8012b2 <ipc_recv>
	cprintf("%x got message: %s\n", who, TEMP_ADDR);
  8000ae:	83 c4 0c             	add    $0xc,%esp
  8000b1:	68 00 00 a0 00       	push   $0xa00000
  8000b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b9:	68 60 29 80 00       	push   $0x802960
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
  800100:	e8 ad 11 00 00       	call   8012b2 <ipc_recv>
		cprintf("%x got message: %s\n", who, TEMP_ADDR_CHILD);
  800105:	83 c4 0c             	add    $0xc,%esp
  800108:	68 00 00 b0 00       	push   $0xb00000
  80010d:	ff 75 f4             	pushl  -0xc(%ebp)
  800110:	68 60 29 80 00       	push   $0x802960
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
  800174:	e8 be 11 00 00       	call   801337 <ipc_send>
		return;
  800179:	83 c4 20             	add    $0x20,%esp
  80017c:	e9 6f ff ff ff       	jmp    8000f0 <umain+0xbd>
			cprintf("child received correct message\n");
  800181:	83 ec 0c             	sub    $0xc,%esp
  800184:	68 74 29 80 00       	push   $0x802974
  800189:	e8 1f 01 00 00       	call   8002ad <cprintf>
  80018e:	83 c4 10             	add    $0x10,%esp
  800191:	eb b0                	jmp    800143 <umain+0x110>
		cprintf("parent received correct message\n");
  800193:	83 ec 0c             	sub    $0xc,%esp
  800196:	68 94 29 80 00       	push   $0x802994
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
  8001c9:	a3 08 40 80 00       	mov    %eax,0x804008

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
  8001fc:	e8 bf 13 00 00       	call   8015c0 <close_all>
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
  800313:	e8 e8 23 00 00       	call   802700 <__udivdi3>
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
  800351:	e8 ba 24 00 00       	call   802810 <__umoddi3>
  800356:	83 c4 14             	add    $0x14,%esp
  800359:	0f be 80 0c 2a 80 00 	movsbl 0x802a0c(%eax),%eax
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
  800400:	3e ff 24 85 40 2b 80 	notrack jmp *0x802b40(,%eax,4)
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
  8004cd:	8b 14 85 a0 2c 80 00 	mov    0x802ca0(,%eax,4),%edx
  8004d4:	85 d2                	test   %edx,%edx
  8004d6:	74 18                	je     8004f0 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8004d8:	52                   	push   %edx
  8004d9:	68 89 2e 80 00       	push   $0x802e89
  8004de:	53                   	push   %ebx
  8004df:	56                   	push   %esi
  8004e0:	e8 aa fe ff ff       	call   80038f <printfmt>
  8004e5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004e8:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004eb:	e9 66 02 00 00       	jmp    800756 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8004f0:	50                   	push   %eax
  8004f1:	68 24 2a 80 00       	push   $0x802a24
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
  800518:	b8 1d 2a 80 00       	mov    $0x802a1d,%eax
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
  800ca2:	68 ff 2c 80 00       	push   $0x802cff
  800ca7:	6a 23                	push   $0x23
  800ca9:	68 1c 2d 80 00       	push   $0x802d1c
  800cae:	e8 1b 19 00 00       	call   8025ce <_panic>

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
  800d2f:	68 ff 2c 80 00       	push   $0x802cff
  800d34:	6a 23                	push   $0x23
  800d36:	68 1c 2d 80 00       	push   $0x802d1c
  800d3b:	e8 8e 18 00 00       	call   8025ce <_panic>

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
  800d75:	68 ff 2c 80 00       	push   $0x802cff
  800d7a:	6a 23                	push   $0x23
  800d7c:	68 1c 2d 80 00       	push   $0x802d1c
  800d81:	e8 48 18 00 00       	call   8025ce <_panic>

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
  800dbb:	68 ff 2c 80 00       	push   $0x802cff
  800dc0:	6a 23                	push   $0x23
  800dc2:	68 1c 2d 80 00       	push   $0x802d1c
  800dc7:	e8 02 18 00 00       	call   8025ce <_panic>

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
  800e01:	68 ff 2c 80 00       	push   $0x802cff
  800e06:	6a 23                	push   $0x23
  800e08:	68 1c 2d 80 00       	push   $0x802d1c
  800e0d:	e8 bc 17 00 00       	call   8025ce <_panic>

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
  800e47:	68 ff 2c 80 00       	push   $0x802cff
  800e4c:	6a 23                	push   $0x23
  800e4e:	68 1c 2d 80 00       	push   $0x802d1c
  800e53:	e8 76 17 00 00       	call   8025ce <_panic>

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
  800e8d:	68 ff 2c 80 00       	push   $0x802cff
  800e92:	6a 23                	push   $0x23
  800e94:	68 1c 2d 80 00       	push   $0x802d1c
  800e99:	e8 30 17 00 00       	call   8025ce <_panic>

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
  800ef9:	68 ff 2c 80 00       	push   $0x802cff
  800efe:	6a 23                	push   $0x23
  800f00:	68 1c 2d 80 00       	push   $0x802d1c
  800f05:	e8 c4 16 00 00       	call   8025ce <_panic>

00800f0a <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f0a:	f3 0f 1e fb          	endbr32 
  800f0e:	55                   	push   %ebp
  800f0f:	89 e5                	mov    %esp,%ebp
  800f11:	57                   	push   %edi
  800f12:	56                   	push   %esi
  800f13:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f14:	ba 00 00 00 00       	mov    $0x0,%edx
  800f19:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f1e:	89 d1                	mov    %edx,%ecx
  800f20:	89 d3                	mov    %edx,%ebx
  800f22:	89 d7                	mov    %edx,%edi
  800f24:	89 d6                	mov    %edx,%esi
  800f26:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f28:	5b                   	pop    %ebx
  800f29:	5e                   	pop    %esi
  800f2a:	5f                   	pop    %edi
  800f2b:	5d                   	pop    %ebp
  800f2c:	c3                   	ret    

00800f2d <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  800f2d:	f3 0f 1e fb          	endbr32 
  800f31:	55                   	push   %ebp
  800f32:	89 e5                	mov    %esp,%ebp
  800f34:	57                   	push   %edi
  800f35:	56                   	push   %esi
  800f36:	53                   	push   %ebx
  800f37:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f3a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f45:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f4a:	89 df                	mov    %ebx,%edi
  800f4c:	89 de                	mov    %ebx,%esi
  800f4e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f50:	85 c0                	test   %eax,%eax
  800f52:	7f 08                	jg     800f5c <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  800f54:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f57:	5b                   	pop    %ebx
  800f58:	5e                   	pop    %esi
  800f59:	5f                   	pop    %edi
  800f5a:	5d                   	pop    %ebp
  800f5b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f5c:	83 ec 0c             	sub    $0xc,%esp
  800f5f:	50                   	push   %eax
  800f60:	6a 0f                	push   $0xf
  800f62:	68 ff 2c 80 00       	push   $0x802cff
  800f67:	6a 23                	push   $0x23
  800f69:	68 1c 2d 80 00       	push   $0x802d1c
  800f6e:	e8 5b 16 00 00       	call   8025ce <_panic>

00800f73 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  800f73:	f3 0f 1e fb          	endbr32 
  800f77:	55                   	push   %ebp
  800f78:	89 e5                	mov    %esp,%ebp
  800f7a:	57                   	push   %edi
  800f7b:	56                   	push   %esi
  800f7c:	53                   	push   %ebx
  800f7d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f80:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f85:	8b 55 08             	mov    0x8(%ebp),%edx
  800f88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f8b:	b8 10 00 00 00       	mov    $0x10,%eax
  800f90:	89 df                	mov    %ebx,%edi
  800f92:	89 de                	mov    %ebx,%esi
  800f94:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f96:	85 c0                	test   %eax,%eax
  800f98:	7f 08                	jg     800fa2 <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  800f9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f9d:	5b                   	pop    %ebx
  800f9e:	5e                   	pop    %esi
  800f9f:	5f                   	pop    %edi
  800fa0:	5d                   	pop    %ebp
  800fa1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fa2:	83 ec 0c             	sub    $0xc,%esp
  800fa5:	50                   	push   %eax
  800fa6:	6a 10                	push   $0x10
  800fa8:	68 ff 2c 80 00       	push   $0x802cff
  800fad:	6a 23                	push   $0x23
  800faf:	68 1c 2d 80 00       	push   $0x802d1c
  800fb4:	e8 15 16 00 00       	call   8025ce <_panic>

00800fb9 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800fb9:	f3 0f 1e fb          	endbr32 
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	53                   	push   %ebx
  800fc1:	83 ec 04             	sub    $0x4,%esp
  800fc4:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800fc7:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  800fc9:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800fcd:	74 74                	je     801043 <pgfault+0x8a>
  800fcf:	89 d8                	mov    %ebx,%eax
  800fd1:	c1 e8 0c             	shr    $0xc,%eax
  800fd4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fdb:	f6 c4 08             	test   $0x8,%ah
  800fde:	74 63                	je     801043 <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800fe0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  800fe6:	83 ec 0c             	sub    $0xc,%esp
  800fe9:	6a 05                	push   $0x5
  800feb:	68 00 f0 7f 00       	push   $0x7ff000
  800ff0:	6a 00                	push   $0x0
  800ff2:	53                   	push   %ebx
  800ff3:	6a 00                	push   $0x0
  800ff5:	e8 46 fd ff ff       	call   800d40 <sys_page_map>
  800ffa:	83 c4 20             	add    $0x20,%esp
  800ffd:	85 c0                	test   %eax,%eax
  800fff:	78 59                	js     80105a <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  801001:	83 ec 04             	sub    $0x4,%esp
  801004:	6a 07                	push   $0x7
  801006:	53                   	push   %ebx
  801007:	6a 00                	push   $0x0
  801009:	e8 eb fc ff ff       	call   800cf9 <sys_page_alloc>
  80100e:	83 c4 10             	add    $0x10,%esp
  801011:	85 c0                	test   %eax,%eax
  801013:	78 5a                	js     80106f <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  801015:	83 ec 04             	sub    $0x4,%esp
  801018:	68 00 10 00 00       	push   $0x1000
  80101d:	68 00 f0 7f 00       	push   $0x7ff000
  801022:	53                   	push   %ebx
  801023:	e8 45 fa ff ff       	call   800a6d <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  801028:	83 c4 08             	add    $0x8,%esp
  80102b:	68 00 f0 7f 00       	push   $0x7ff000
  801030:	6a 00                	push   $0x0
  801032:	e8 4f fd ff ff       	call   800d86 <sys_page_unmap>
  801037:	83 c4 10             	add    $0x10,%esp
  80103a:	85 c0                	test   %eax,%eax
  80103c:	78 46                	js     801084 <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  80103e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801041:	c9                   	leave  
  801042:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  801043:	83 ec 04             	sub    $0x4,%esp
  801046:	68 2a 2d 80 00       	push   $0x802d2a
  80104b:	68 d3 00 00 00       	push   $0xd3
  801050:	68 46 2d 80 00       	push   $0x802d46
  801055:	e8 74 15 00 00       	call   8025ce <_panic>
		panic("pgfault: %e\n", r);
  80105a:	50                   	push   %eax
  80105b:	68 51 2d 80 00       	push   $0x802d51
  801060:	68 df 00 00 00       	push   $0xdf
  801065:	68 46 2d 80 00       	push   $0x802d46
  80106a:	e8 5f 15 00 00       	call   8025ce <_panic>
		panic("pgfault: %e\n", r);
  80106f:	50                   	push   %eax
  801070:	68 51 2d 80 00       	push   $0x802d51
  801075:	68 e3 00 00 00       	push   $0xe3
  80107a:	68 46 2d 80 00       	push   $0x802d46
  80107f:	e8 4a 15 00 00       	call   8025ce <_panic>
		panic("pgfault: %e\n", r);
  801084:	50                   	push   %eax
  801085:	68 51 2d 80 00       	push   $0x802d51
  80108a:	68 e9 00 00 00       	push   $0xe9
  80108f:	68 46 2d 80 00       	push   $0x802d46
  801094:	e8 35 15 00 00       	call   8025ce <_panic>

00801099 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801099:	f3 0f 1e fb          	endbr32 
  80109d:	55                   	push   %ebp
  80109e:	89 e5                	mov    %esp,%ebp
  8010a0:	57                   	push   %edi
  8010a1:	56                   	push   %esi
  8010a2:	53                   	push   %ebx
  8010a3:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  8010a6:	68 b9 0f 80 00       	push   $0x800fb9
  8010ab:	e8 68 15 00 00       	call   802618 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8010b0:	b8 07 00 00 00       	mov    $0x7,%eax
  8010b5:	cd 30                	int    $0x30
  8010b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  8010ba:	83 c4 10             	add    $0x10,%esp
  8010bd:	85 c0                	test   %eax,%eax
  8010bf:	78 2d                	js     8010ee <fork+0x55>
  8010c1:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8010c3:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  8010c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010cc:	0f 85 9b 00 00 00    	jne    80116d <fork+0xd4>
		thisenv = &envs[ENVX(sys_getenvid())];
  8010d2:	e8 dc fb ff ff       	call   800cb3 <sys_getenvid>
  8010d7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010dc:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010df:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010e4:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  8010e9:	e9 71 01 00 00       	jmp    80125f <fork+0x1c6>
		panic("sys_exofork: %e", envid);
  8010ee:	50                   	push   %eax
  8010ef:	68 5e 2d 80 00       	push   $0x802d5e
  8010f4:	68 2a 01 00 00       	push   $0x12a
  8010f9:	68 46 2d 80 00       	push   $0x802d46
  8010fe:	e8 cb 14 00 00       	call   8025ce <_panic>
		sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_SYSCALL);
  801103:	c1 e6 0c             	shl    $0xc,%esi
  801106:	83 ec 0c             	sub    $0xc,%esp
  801109:	68 07 0e 00 00       	push   $0xe07
  80110e:	56                   	push   %esi
  80110f:	57                   	push   %edi
  801110:	56                   	push   %esi
  801111:	6a 00                	push   $0x0
  801113:	e8 28 fc ff ff       	call   800d40 <sys_page_map>
  801118:	83 c4 20             	add    $0x20,%esp
  80111b:	eb 3e                	jmp    80115b <fork+0xc2>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  80111d:	c1 e6 0c             	shl    $0xc,%esi
  801120:	83 ec 0c             	sub    $0xc,%esp
  801123:	68 05 08 00 00       	push   $0x805
  801128:	56                   	push   %esi
  801129:	57                   	push   %edi
  80112a:	56                   	push   %esi
  80112b:	6a 00                	push   $0x0
  80112d:	e8 0e fc ff ff       	call   800d40 <sys_page_map>
  801132:	83 c4 20             	add    $0x20,%esp
  801135:	85 c0                	test   %eax,%eax
  801137:	0f 88 bc 00 00 00    	js     8011f9 <fork+0x160>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  80113d:	83 ec 0c             	sub    $0xc,%esp
  801140:	68 05 08 00 00       	push   $0x805
  801145:	56                   	push   %esi
  801146:	6a 00                	push   $0x0
  801148:	56                   	push   %esi
  801149:	6a 00                	push   $0x0
  80114b:	e8 f0 fb ff ff       	call   800d40 <sys_page_map>
  801150:	83 c4 20             	add    $0x20,%esp
  801153:	85 c0                	test   %eax,%eax
  801155:	0f 88 b3 00 00 00    	js     80120e <fork+0x175>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  80115b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801161:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801167:	0f 84 b6 00 00 00    	je     801223 <fork+0x18a>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  80116d:	89 d8                	mov    %ebx,%eax
  80116f:	c1 e8 16             	shr    $0x16,%eax
  801172:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801179:	a8 01                	test   $0x1,%al
  80117b:	74 de                	je     80115b <fork+0xc2>
  80117d:	89 de                	mov    %ebx,%esi
  80117f:	c1 ee 0c             	shr    $0xc,%esi
  801182:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801189:	a8 01                	test   $0x1,%al
  80118b:	74 ce                	je     80115b <fork+0xc2>
  80118d:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801194:	a8 04                	test   $0x4,%al
  801196:	74 c3                	je     80115b <fork+0xc2>
	if ((uvpt[pn] & PTE_SHARE)){
  801198:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80119f:	f6 c4 04             	test   $0x4,%ah
  8011a2:	0f 85 5b ff ff ff    	jne    801103 <fork+0x6a>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  8011a8:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011af:	a8 02                	test   $0x2,%al
  8011b1:	0f 85 66 ff ff ff    	jne    80111d <fork+0x84>
  8011b7:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011be:	f6 c4 08             	test   $0x8,%ah
  8011c1:	0f 85 56 ff ff ff    	jne    80111d <fork+0x84>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  8011c7:	c1 e6 0c             	shl    $0xc,%esi
  8011ca:	83 ec 0c             	sub    $0xc,%esp
  8011cd:	6a 05                	push   $0x5
  8011cf:	56                   	push   %esi
  8011d0:	57                   	push   %edi
  8011d1:	56                   	push   %esi
  8011d2:	6a 00                	push   $0x0
  8011d4:	e8 67 fb ff ff       	call   800d40 <sys_page_map>
  8011d9:	83 c4 20             	add    $0x20,%esp
  8011dc:	85 c0                	test   %eax,%eax
  8011de:	0f 89 77 ff ff ff    	jns    80115b <fork+0xc2>
		panic("duppage: %e\n", r);
  8011e4:	50                   	push   %eax
  8011e5:	68 6e 2d 80 00       	push   $0x802d6e
  8011ea:	68 0c 01 00 00       	push   $0x10c
  8011ef:	68 46 2d 80 00       	push   $0x802d46
  8011f4:	e8 d5 13 00 00       	call   8025ce <_panic>
			panic("duppage: %e\n", r);
  8011f9:	50                   	push   %eax
  8011fa:	68 6e 2d 80 00       	push   $0x802d6e
  8011ff:	68 05 01 00 00       	push   $0x105
  801204:	68 46 2d 80 00       	push   $0x802d46
  801209:	e8 c0 13 00 00       	call   8025ce <_panic>
			panic("duppage: %e\n", r);
  80120e:	50                   	push   %eax
  80120f:	68 6e 2d 80 00       	push   $0x802d6e
  801214:	68 09 01 00 00       	push   $0x109
  801219:	68 46 2d 80 00       	push   $0x802d46
  80121e:	e8 ab 13 00 00       	call   8025ce <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  801223:	83 ec 04             	sub    $0x4,%esp
  801226:	6a 07                	push   $0x7
  801228:	68 00 f0 bf ee       	push   $0xeebff000
  80122d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801230:	e8 c4 fa ff ff       	call   800cf9 <sys_page_alloc>
  801235:	83 c4 10             	add    $0x10,%esp
  801238:	85 c0                	test   %eax,%eax
  80123a:	78 2e                	js     80126a <fork+0x1d1>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  80123c:	83 ec 08             	sub    $0x8,%esp
  80123f:	68 8b 26 80 00       	push   $0x80268b
  801244:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801247:	57                   	push   %edi
  801248:	e8 0b fc ff ff       	call   800e58 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80124d:	83 c4 08             	add    $0x8,%esp
  801250:	6a 02                	push   $0x2
  801252:	57                   	push   %edi
  801253:	e8 74 fb ff ff       	call   800dcc <sys_env_set_status>
  801258:	83 c4 10             	add    $0x10,%esp
  80125b:	85 c0                	test   %eax,%eax
  80125d:	78 20                	js     80127f <fork+0x1e6>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  80125f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801262:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801265:	5b                   	pop    %ebx
  801266:	5e                   	pop    %esi
  801267:	5f                   	pop    %edi
  801268:	5d                   	pop    %ebp
  801269:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  80126a:	50                   	push   %eax
  80126b:	68 7b 2d 80 00       	push   $0x802d7b
  801270:	68 3e 01 00 00       	push   $0x13e
  801275:	68 46 2d 80 00       	push   $0x802d46
  80127a:	e8 4f 13 00 00       	call   8025ce <_panic>
		panic("sys_env_set_status: %e", r);
  80127f:	50                   	push   %eax
  801280:	68 8e 2d 80 00       	push   $0x802d8e
  801285:	68 43 01 00 00       	push   $0x143
  80128a:	68 46 2d 80 00       	push   $0x802d46
  80128f:	e8 3a 13 00 00       	call   8025ce <_panic>

00801294 <sfork>:

// Challenge!
int
sfork(void)
{
  801294:	f3 0f 1e fb          	endbr32 
  801298:	55                   	push   %ebp
  801299:	89 e5                	mov    %esp,%ebp
  80129b:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80129e:	68 a5 2d 80 00       	push   $0x802da5
  8012a3:	68 4c 01 00 00       	push   $0x14c
  8012a8:	68 46 2d 80 00       	push   $0x802d46
  8012ad:	e8 1c 13 00 00       	call   8025ce <_panic>

008012b2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8012b2:	f3 0f 1e fb          	endbr32 
  8012b6:	55                   	push   %ebp
  8012b7:	89 e5                	mov    %esp,%ebp
  8012b9:	56                   	push   %esi
  8012ba:	53                   	push   %ebx
  8012bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8012be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  8012c4:	85 c0                	test   %eax,%eax
  8012c6:	74 3d                	je     801305 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  8012c8:	83 ec 0c             	sub    $0xc,%esp
  8012cb:	50                   	push   %eax
  8012cc:	e8 f4 fb ff ff       	call   800ec5 <sys_ipc_recv>
  8012d1:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  8012d4:	85 f6                	test   %esi,%esi
  8012d6:	74 0b                	je     8012e3 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8012d8:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8012de:	8b 52 74             	mov    0x74(%edx),%edx
  8012e1:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  8012e3:	85 db                	test   %ebx,%ebx
  8012e5:	74 0b                	je     8012f2 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  8012e7:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8012ed:	8b 52 78             	mov    0x78(%edx),%edx
  8012f0:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  8012f2:	85 c0                	test   %eax,%eax
  8012f4:	78 21                	js     801317 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  8012f6:	a1 08 40 80 00       	mov    0x804008,%eax
  8012fb:	8b 40 70             	mov    0x70(%eax),%eax
}
  8012fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801301:	5b                   	pop    %ebx
  801302:	5e                   	pop    %esi
  801303:	5d                   	pop    %ebp
  801304:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  801305:	83 ec 0c             	sub    $0xc,%esp
  801308:	68 00 00 c0 ee       	push   $0xeec00000
  80130d:	e8 b3 fb ff ff       	call   800ec5 <sys_ipc_recv>
  801312:	83 c4 10             	add    $0x10,%esp
  801315:	eb bd                	jmp    8012d4 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  801317:	85 f6                	test   %esi,%esi
  801319:	74 10                	je     80132b <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  80131b:	85 db                	test   %ebx,%ebx
  80131d:	75 df                	jne    8012fe <ipc_recv+0x4c>
  80131f:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801326:	00 00 00 
  801329:	eb d3                	jmp    8012fe <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  80132b:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801332:	00 00 00 
  801335:	eb e4                	jmp    80131b <ipc_recv+0x69>

00801337 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801337:	f3 0f 1e fb          	endbr32 
  80133b:	55                   	push   %ebp
  80133c:	89 e5                	mov    %esp,%ebp
  80133e:	57                   	push   %edi
  80133f:	56                   	push   %esi
  801340:	53                   	push   %ebx
  801341:	83 ec 0c             	sub    $0xc,%esp
  801344:	8b 7d 08             	mov    0x8(%ebp),%edi
  801347:	8b 75 0c             	mov    0xc(%ebp),%esi
  80134a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  80134d:	85 db                	test   %ebx,%ebx
  80134f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801354:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  801357:	ff 75 14             	pushl  0x14(%ebp)
  80135a:	53                   	push   %ebx
  80135b:	56                   	push   %esi
  80135c:	57                   	push   %edi
  80135d:	e8 3c fb ff ff       	call   800e9e <sys_ipc_try_send>
  801362:	83 c4 10             	add    $0x10,%esp
  801365:	85 c0                	test   %eax,%eax
  801367:	79 1e                	jns    801387 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  801369:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80136c:	75 07                	jne    801375 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  80136e:	e8 63 f9 ff ff       	call   800cd6 <sys_yield>
  801373:	eb e2                	jmp    801357 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  801375:	50                   	push   %eax
  801376:	68 bb 2d 80 00       	push   $0x802dbb
  80137b:	6a 59                	push   $0x59
  80137d:	68 d6 2d 80 00       	push   $0x802dd6
  801382:	e8 47 12 00 00       	call   8025ce <_panic>
	}
}
  801387:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80138a:	5b                   	pop    %ebx
  80138b:	5e                   	pop    %esi
  80138c:	5f                   	pop    %edi
  80138d:	5d                   	pop    %ebp
  80138e:	c3                   	ret    

0080138f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80138f:	f3 0f 1e fb          	endbr32 
  801393:	55                   	push   %ebp
  801394:	89 e5                	mov    %esp,%ebp
  801396:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801399:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80139e:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8013a1:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8013a7:	8b 52 50             	mov    0x50(%edx),%edx
  8013aa:	39 ca                	cmp    %ecx,%edx
  8013ac:	74 11                	je     8013bf <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8013ae:	83 c0 01             	add    $0x1,%eax
  8013b1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8013b6:	75 e6                	jne    80139e <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8013b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8013bd:	eb 0b                	jmp    8013ca <ipc_find_env+0x3b>
			return envs[i].env_id;
  8013bf:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8013c2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013c7:	8b 40 48             	mov    0x48(%eax),%eax
}
  8013ca:	5d                   	pop    %ebp
  8013cb:	c3                   	ret    

008013cc <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8013cc:	f3 0f 1e fb          	endbr32 
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d6:	05 00 00 00 30       	add    $0x30000000,%eax
  8013db:	c1 e8 0c             	shr    $0xc,%eax
}
  8013de:	5d                   	pop    %ebp
  8013df:	c3                   	ret    

008013e0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013e0:	f3 0f 1e fb          	endbr32 
  8013e4:	55                   	push   %ebp
  8013e5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ea:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8013ef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013f4:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8013f9:	5d                   	pop    %ebp
  8013fa:	c3                   	ret    

008013fb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013fb:	f3 0f 1e fb          	endbr32 
  8013ff:	55                   	push   %ebp
  801400:	89 e5                	mov    %esp,%ebp
  801402:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801407:	89 c2                	mov    %eax,%edx
  801409:	c1 ea 16             	shr    $0x16,%edx
  80140c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801413:	f6 c2 01             	test   $0x1,%dl
  801416:	74 2d                	je     801445 <fd_alloc+0x4a>
  801418:	89 c2                	mov    %eax,%edx
  80141a:	c1 ea 0c             	shr    $0xc,%edx
  80141d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801424:	f6 c2 01             	test   $0x1,%dl
  801427:	74 1c                	je     801445 <fd_alloc+0x4a>
  801429:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80142e:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801433:	75 d2                	jne    801407 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801435:	8b 45 08             	mov    0x8(%ebp),%eax
  801438:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80143e:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801443:	eb 0a                	jmp    80144f <fd_alloc+0x54>
			*fd_store = fd;
  801445:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801448:	89 01                	mov    %eax,(%ecx)
			return 0;
  80144a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80144f:	5d                   	pop    %ebp
  801450:	c3                   	ret    

00801451 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801451:	f3 0f 1e fb          	endbr32 
  801455:	55                   	push   %ebp
  801456:	89 e5                	mov    %esp,%ebp
  801458:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80145b:	83 f8 1f             	cmp    $0x1f,%eax
  80145e:	77 30                	ja     801490 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801460:	c1 e0 0c             	shl    $0xc,%eax
  801463:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801468:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80146e:	f6 c2 01             	test   $0x1,%dl
  801471:	74 24                	je     801497 <fd_lookup+0x46>
  801473:	89 c2                	mov    %eax,%edx
  801475:	c1 ea 0c             	shr    $0xc,%edx
  801478:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80147f:	f6 c2 01             	test   $0x1,%dl
  801482:	74 1a                	je     80149e <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801484:	8b 55 0c             	mov    0xc(%ebp),%edx
  801487:	89 02                	mov    %eax,(%edx)
	return 0;
  801489:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80148e:	5d                   	pop    %ebp
  80148f:	c3                   	ret    
		return -E_INVAL;
  801490:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801495:	eb f7                	jmp    80148e <fd_lookup+0x3d>
		return -E_INVAL;
  801497:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80149c:	eb f0                	jmp    80148e <fd_lookup+0x3d>
  80149e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014a3:	eb e9                	jmp    80148e <fd_lookup+0x3d>

008014a5 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8014a5:	f3 0f 1e fb          	endbr32 
  8014a9:	55                   	push   %ebp
  8014aa:	89 e5                	mov    %esp,%ebp
  8014ac:	83 ec 08             	sub    $0x8,%esp
  8014af:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8014b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b7:	b8 0c 30 80 00       	mov    $0x80300c,%eax
		if (devtab[i]->dev_id == dev_id) {
  8014bc:	39 08                	cmp    %ecx,(%eax)
  8014be:	74 38                	je     8014f8 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  8014c0:	83 c2 01             	add    $0x1,%edx
  8014c3:	8b 04 95 5c 2e 80 00 	mov    0x802e5c(,%edx,4),%eax
  8014ca:	85 c0                	test   %eax,%eax
  8014cc:	75 ee                	jne    8014bc <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8014ce:	a1 08 40 80 00       	mov    0x804008,%eax
  8014d3:	8b 40 48             	mov    0x48(%eax),%eax
  8014d6:	83 ec 04             	sub    $0x4,%esp
  8014d9:	51                   	push   %ecx
  8014da:	50                   	push   %eax
  8014db:	68 e0 2d 80 00       	push   $0x802de0
  8014e0:	e8 c8 ed ff ff       	call   8002ad <cprintf>
	*dev = 0;
  8014e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8014ee:	83 c4 10             	add    $0x10,%esp
  8014f1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014f6:	c9                   	leave  
  8014f7:	c3                   	ret    
			*dev = devtab[i];
  8014f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014fb:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801502:	eb f2                	jmp    8014f6 <dev_lookup+0x51>

00801504 <fd_close>:
{
  801504:	f3 0f 1e fb          	endbr32 
  801508:	55                   	push   %ebp
  801509:	89 e5                	mov    %esp,%ebp
  80150b:	57                   	push   %edi
  80150c:	56                   	push   %esi
  80150d:	53                   	push   %ebx
  80150e:	83 ec 24             	sub    $0x24,%esp
  801511:	8b 75 08             	mov    0x8(%ebp),%esi
  801514:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801517:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80151a:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80151b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801521:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801524:	50                   	push   %eax
  801525:	e8 27 ff ff ff       	call   801451 <fd_lookup>
  80152a:	89 c3                	mov    %eax,%ebx
  80152c:	83 c4 10             	add    $0x10,%esp
  80152f:	85 c0                	test   %eax,%eax
  801531:	78 05                	js     801538 <fd_close+0x34>
	    || fd != fd2)
  801533:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801536:	74 16                	je     80154e <fd_close+0x4a>
		return (must_exist ? r : 0);
  801538:	89 f8                	mov    %edi,%eax
  80153a:	84 c0                	test   %al,%al
  80153c:	b8 00 00 00 00       	mov    $0x0,%eax
  801541:	0f 44 d8             	cmove  %eax,%ebx
}
  801544:	89 d8                	mov    %ebx,%eax
  801546:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801549:	5b                   	pop    %ebx
  80154a:	5e                   	pop    %esi
  80154b:	5f                   	pop    %edi
  80154c:	5d                   	pop    %ebp
  80154d:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80154e:	83 ec 08             	sub    $0x8,%esp
  801551:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801554:	50                   	push   %eax
  801555:	ff 36                	pushl  (%esi)
  801557:	e8 49 ff ff ff       	call   8014a5 <dev_lookup>
  80155c:	89 c3                	mov    %eax,%ebx
  80155e:	83 c4 10             	add    $0x10,%esp
  801561:	85 c0                	test   %eax,%eax
  801563:	78 1a                	js     80157f <fd_close+0x7b>
		if (dev->dev_close)
  801565:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801568:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80156b:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801570:	85 c0                	test   %eax,%eax
  801572:	74 0b                	je     80157f <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801574:	83 ec 0c             	sub    $0xc,%esp
  801577:	56                   	push   %esi
  801578:	ff d0                	call   *%eax
  80157a:	89 c3                	mov    %eax,%ebx
  80157c:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80157f:	83 ec 08             	sub    $0x8,%esp
  801582:	56                   	push   %esi
  801583:	6a 00                	push   $0x0
  801585:	e8 fc f7 ff ff       	call   800d86 <sys_page_unmap>
	return r;
  80158a:	83 c4 10             	add    $0x10,%esp
  80158d:	eb b5                	jmp    801544 <fd_close+0x40>

0080158f <close>:

int
close(int fdnum)
{
  80158f:	f3 0f 1e fb          	endbr32 
  801593:	55                   	push   %ebp
  801594:	89 e5                	mov    %esp,%ebp
  801596:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801599:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80159c:	50                   	push   %eax
  80159d:	ff 75 08             	pushl  0x8(%ebp)
  8015a0:	e8 ac fe ff ff       	call   801451 <fd_lookup>
  8015a5:	83 c4 10             	add    $0x10,%esp
  8015a8:	85 c0                	test   %eax,%eax
  8015aa:	79 02                	jns    8015ae <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8015ac:	c9                   	leave  
  8015ad:	c3                   	ret    
		return fd_close(fd, 1);
  8015ae:	83 ec 08             	sub    $0x8,%esp
  8015b1:	6a 01                	push   $0x1
  8015b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8015b6:	e8 49 ff ff ff       	call   801504 <fd_close>
  8015bb:	83 c4 10             	add    $0x10,%esp
  8015be:	eb ec                	jmp    8015ac <close+0x1d>

008015c0 <close_all>:

void
close_all(void)
{
  8015c0:	f3 0f 1e fb          	endbr32 
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
  8015c7:	53                   	push   %ebx
  8015c8:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8015cb:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8015d0:	83 ec 0c             	sub    $0xc,%esp
  8015d3:	53                   	push   %ebx
  8015d4:	e8 b6 ff ff ff       	call   80158f <close>
	for (i = 0; i < MAXFD; i++)
  8015d9:	83 c3 01             	add    $0x1,%ebx
  8015dc:	83 c4 10             	add    $0x10,%esp
  8015df:	83 fb 20             	cmp    $0x20,%ebx
  8015e2:	75 ec                	jne    8015d0 <close_all+0x10>
}
  8015e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015e7:	c9                   	leave  
  8015e8:	c3                   	ret    

008015e9 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015e9:	f3 0f 1e fb          	endbr32 
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
  8015f0:	57                   	push   %edi
  8015f1:	56                   	push   %esi
  8015f2:	53                   	push   %ebx
  8015f3:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015f6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015f9:	50                   	push   %eax
  8015fa:	ff 75 08             	pushl  0x8(%ebp)
  8015fd:	e8 4f fe ff ff       	call   801451 <fd_lookup>
  801602:	89 c3                	mov    %eax,%ebx
  801604:	83 c4 10             	add    $0x10,%esp
  801607:	85 c0                	test   %eax,%eax
  801609:	0f 88 81 00 00 00    	js     801690 <dup+0xa7>
		return r;
	close(newfdnum);
  80160f:	83 ec 0c             	sub    $0xc,%esp
  801612:	ff 75 0c             	pushl  0xc(%ebp)
  801615:	e8 75 ff ff ff       	call   80158f <close>

	newfd = INDEX2FD(newfdnum);
  80161a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80161d:	c1 e6 0c             	shl    $0xc,%esi
  801620:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801626:	83 c4 04             	add    $0x4,%esp
  801629:	ff 75 e4             	pushl  -0x1c(%ebp)
  80162c:	e8 af fd ff ff       	call   8013e0 <fd2data>
  801631:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801633:	89 34 24             	mov    %esi,(%esp)
  801636:	e8 a5 fd ff ff       	call   8013e0 <fd2data>
  80163b:	83 c4 10             	add    $0x10,%esp
  80163e:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801640:	89 d8                	mov    %ebx,%eax
  801642:	c1 e8 16             	shr    $0x16,%eax
  801645:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80164c:	a8 01                	test   $0x1,%al
  80164e:	74 11                	je     801661 <dup+0x78>
  801650:	89 d8                	mov    %ebx,%eax
  801652:	c1 e8 0c             	shr    $0xc,%eax
  801655:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80165c:	f6 c2 01             	test   $0x1,%dl
  80165f:	75 39                	jne    80169a <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801661:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801664:	89 d0                	mov    %edx,%eax
  801666:	c1 e8 0c             	shr    $0xc,%eax
  801669:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801670:	83 ec 0c             	sub    $0xc,%esp
  801673:	25 07 0e 00 00       	and    $0xe07,%eax
  801678:	50                   	push   %eax
  801679:	56                   	push   %esi
  80167a:	6a 00                	push   $0x0
  80167c:	52                   	push   %edx
  80167d:	6a 00                	push   $0x0
  80167f:	e8 bc f6 ff ff       	call   800d40 <sys_page_map>
  801684:	89 c3                	mov    %eax,%ebx
  801686:	83 c4 20             	add    $0x20,%esp
  801689:	85 c0                	test   %eax,%eax
  80168b:	78 31                	js     8016be <dup+0xd5>
		goto err;

	return newfdnum;
  80168d:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801690:	89 d8                	mov    %ebx,%eax
  801692:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801695:	5b                   	pop    %ebx
  801696:	5e                   	pop    %esi
  801697:	5f                   	pop    %edi
  801698:	5d                   	pop    %ebp
  801699:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80169a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016a1:	83 ec 0c             	sub    $0xc,%esp
  8016a4:	25 07 0e 00 00       	and    $0xe07,%eax
  8016a9:	50                   	push   %eax
  8016aa:	57                   	push   %edi
  8016ab:	6a 00                	push   $0x0
  8016ad:	53                   	push   %ebx
  8016ae:	6a 00                	push   $0x0
  8016b0:	e8 8b f6 ff ff       	call   800d40 <sys_page_map>
  8016b5:	89 c3                	mov    %eax,%ebx
  8016b7:	83 c4 20             	add    $0x20,%esp
  8016ba:	85 c0                	test   %eax,%eax
  8016bc:	79 a3                	jns    801661 <dup+0x78>
	sys_page_unmap(0, newfd);
  8016be:	83 ec 08             	sub    $0x8,%esp
  8016c1:	56                   	push   %esi
  8016c2:	6a 00                	push   $0x0
  8016c4:	e8 bd f6 ff ff       	call   800d86 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8016c9:	83 c4 08             	add    $0x8,%esp
  8016cc:	57                   	push   %edi
  8016cd:	6a 00                	push   $0x0
  8016cf:	e8 b2 f6 ff ff       	call   800d86 <sys_page_unmap>
	return r;
  8016d4:	83 c4 10             	add    $0x10,%esp
  8016d7:	eb b7                	jmp    801690 <dup+0xa7>

008016d9 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016d9:	f3 0f 1e fb          	endbr32 
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
  8016e0:	53                   	push   %ebx
  8016e1:	83 ec 1c             	sub    $0x1c,%esp
  8016e4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016e7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016ea:	50                   	push   %eax
  8016eb:	53                   	push   %ebx
  8016ec:	e8 60 fd ff ff       	call   801451 <fd_lookup>
  8016f1:	83 c4 10             	add    $0x10,%esp
  8016f4:	85 c0                	test   %eax,%eax
  8016f6:	78 3f                	js     801737 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016f8:	83 ec 08             	sub    $0x8,%esp
  8016fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016fe:	50                   	push   %eax
  8016ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801702:	ff 30                	pushl  (%eax)
  801704:	e8 9c fd ff ff       	call   8014a5 <dev_lookup>
  801709:	83 c4 10             	add    $0x10,%esp
  80170c:	85 c0                	test   %eax,%eax
  80170e:	78 27                	js     801737 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801710:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801713:	8b 42 08             	mov    0x8(%edx),%eax
  801716:	83 e0 03             	and    $0x3,%eax
  801719:	83 f8 01             	cmp    $0x1,%eax
  80171c:	74 1e                	je     80173c <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80171e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801721:	8b 40 08             	mov    0x8(%eax),%eax
  801724:	85 c0                	test   %eax,%eax
  801726:	74 35                	je     80175d <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801728:	83 ec 04             	sub    $0x4,%esp
  80172b:	ff 75 10             	pushl  0x10(%ebp)
  80172e:	ff 75 0c             	pushl  0xc(%ebp)
  801731:	52                   	push   %edx
  801732:	ff d0                	call   *%eax
  801734:	83 c4 10             	add    $0x10,%esp
}
  801737:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80173c:	a1 08 40 80 00       	mov    0x804008,%eax
  801741:	8b 40 48             	mov    0x48(%eax),%eax
  801744:	83 ec 04             	sub    $0x4,%esp
  801747:	53                   	push   %ebx
  801748:	50                   	push   %eax
  801749:	68 21 2e 80 00       	push   $0x802e21
  80174e:	e8 5a eb ff ff       	call   8002ad <cprintf>
		return -E_INVAL;
  801753:	83 c4 10             	add    $0x10,%esp
  801756:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80175b:	eb da                	jmp    801737 <read+0x5e>
		return -E_NOT_SUPP;
  80175d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801762:	eb d3                	jmp    801737 <read+0x5e>

00801764 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801764:	f3 0f 1e fb          	endbr32 
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
  80176b:	57                   	push   %edi
  80176c:	56                   	push   %esi
  80176d:	53                   	push   %ebx
  80176e:	83 ec 0c             	sub    $0xc,%esp
  801771:	8b 7d 08             	mov    0x8(%ebp),%edi
  801774:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801777:	bb 00 00 00 00       	mov    $0x0,%ebx
  80177c:	eb 02                	jmp    801780 <readn+0x1c>
  80177e:	01 c3                	add    %eax,%ebx
  801780:	39 f3                	cmp    %esi,%ebx
  801782:	73 21                	jae    8017a5 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801784:	83 ec 04             	sub    $0x4,%esp
  801787:	89 f0                	mov    %esi,%eax
  801789:	29 d8                	sub    %ebx,%eax
  80178b:	50                   	push   %eax
  80178c:	89 d8                	mov    %ebx,%eax
  80178e:	03 45 0c             	add    0xc(%ebp),%eax
  801791:	50                   	push   %eax
  801792:	57                   	push   %edi
  801793:	e8 41 ff ff ff       	call   8016d9 <read>
		if (m < 0)
  801798:	83 c4 10             	add    $0x10,%esp
  80179b:	85 c0                	test   %eax,%eax
  80179d:	78 04                	js     8017a3 <readn+0x3f>
			return m;
		if (m == 0)
  80179f:	75 dd                	jne    80177e <readn+0x1a>
  8017a1:	eb 02                	jmp    8017a5 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017a3:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8017a5:	89 d8                	mov    %ebx,%eax
  8017a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017aa:	5b                   	pop    %ebx
  8017ab:	5e                   	pop    %esi
  8017ac:	5f                   	pop    %edi
  8017ad:	5d                   	pop    %ebp
  8017ae:	c3                   	ret    

008017af <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8017af:	f3 0f 1e fb          	endbr32 
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
  8017b6:	53                   	push   %ebx
  8017b7:	83 ec 1c             	sub    $0x1c,%esp
  8017ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017bd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017c0:	50                   	push   %eax
  8017c1:	53                   	push   %ebx
  8017c2:	e8 8a fc ff ff       	call   801451 <fd_lookup>
  8017c7:	83 c4 10             	add    $0x10,%esp
  8017ca:	85 c0                	test   %eax,%eax
  8017cc:	78 3a                	js     801808 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017ce:	83 ec 08             	sub    $0x8,%esp
  8017d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d4:	50                   	push   %eax
  8017d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d8:	ff 30                	pushl  (%eax)
  8017da:	e8 c6 fc ff ff       	call   8014a5 <dev_lookup>
  8017df:	83 c4 10             	add    $0x10,%esp
  8017e2:	85 c0                	test   %eax,%eax
  8017e4:	78 22                	js     801808 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017ed:	74 1e                	je     80180d <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8017ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017f2:	8b 52 0c             	mov    0xc(%edx),%edx
  8017f5:	85 d2                	test   %edx,%edx
  8017f7:	74 35                	je     80182e <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017f9:	83 ec 04             	sub    $0x4,%esp
  8017fc:	ff 75 10             	pushl  0x10(%ebp)
  8017ff:	ff 75 0c             	pushl  0xc(%ebp)
  801802:	50                   	push   %eax
  801803:	ff d2                	call   *%edx
  801805:	83 c4 10             	add    $0x10,%esp
}
  801808:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80180b:	c9                   	leave  
  80180c:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80180d:	a1 08 40 80 00       	mov    0x804008,%eax
  801812:	8b 40 48             	mov    0x48(%eax),%eax
  801815:	83 ec 04             	sub    $0x4,%esp
  801818:	53                   	push   %ebx
  801819:	50                   	push   %eax
  80181a:	68 3d 2e 80 00       	push   $0x802e3d
  80181f:	e8 89 ea ff ff       	call   8002ad <cprintf>
		return -E_INVAL;
  801824:	83 c4 10             	add    $0x10,%esp
  801827:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80182c:	eb da                	jmp    801808 <write+0x59>
		return -E_NOT_SUPP;
  80182e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801833:	eb d3                	jmp    801808 <write+0x59>

00801835 <seek>:

int
seek(int fdnum, off_t offset)
{
  801835:	f3 0f 1e fb          	endbr32 
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
  80183c:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80183f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801842:	50                   	push   %eax
  801843:	ff 75 08             	pushl  0x8(%ebp)
  801846:	e8 06 fc ff ff       	call   801451 <fd_lookup>
  80184b:	83 c4 10             	add    $0x10,%esp
  80184e:	85 c0                	test   %eax,%eax
  801850:	78 0e                	js     801860 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801852:	8b 55 0c             	mov    0xc(%ebp),%edx
  801855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801858:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80185b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801860:	c9                   	leave  
  801861:	c3                   	ret    

00801862 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801862:	f3 0f 1e fb          	endbr32 
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
  801869:	53                   	push   %ebx
  80186a:	83 ec 1c             	sub    $0x1c,%esp
  80186d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801870:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801873:	50                   	push   %eax
  801874:	53                   	push   %ebx
  801875:	e8 d7 fb ff ff       	call   801451 <fd_lookup>
  80187a:	83 c4 10             	add    $0x10,%esp
  80187d:	85 c0                	test   %eax,%eax
  80187f:	78 37                	js     8018b8 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801881:	83 ec 08             	sub    $0x8,%esp
  801884:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801887:	50                   	push   %eax
  801888:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80188b:	ff 30                	pushl  (%eax)
  80188d:	e8 13 fc ff ff       	call   8014a5 <dev_lookup>
  801892:	83 c4 10             	add    $0x10,%esp
  801895:	85 c0                	test   %eax,%eax
  801897:	78 1f                	js     8018b8 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801899:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80189c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018a0:	74 1b                	je     8018bd <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8018a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018a5:	8b 52 18             	mov    0x18(%edx),%edx
  8018a8:	85 d2                	test   %edx,%edx
  8018aa:	74 32                	je     8018de <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8018ac:	83 ec 08             	sub    $0x8,%esp
  8018af:	ff 75 0c             	pushl  0xc(%ebp)
  8018b2:	50                   	push   %eax
  8018b3:	ff d2                	call   *%edx
  8018b5:	83 c4 10             	add    $0x10,%esp
}
  8018b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018bb:	c9                   	leave  
  8018bc:	c3                   	ret    
			thisenv->env_id, fdnum);
  8018bd:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8018c2:	8b 40 48             	mov    0x48(%eax),%eax
  8018c5:	83 ec 04             	sub    $0x4,%esp
  8018c8:	53                   	push   %ebx
  8018c9:	50                   	push   %eax
  8018ca:	68 00 2e 80 00       	push   $0x802e00
  8018cf:	e8 d9 e9 ff ff       	call   8002ad <cprintf>
		return -E_INVAL;
  8018d4:	83 c4 10             	add    $0x10,%esp
  8018d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018dc:	eb da                	jmp    8018b8 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8018de:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018e3:	eb d3                	jmp    8018b8 <ftruncate+0x56>

008018e5 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018e5:	f3 0f 1e fb          	endbr32 
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
  8018ec:	53                   	push   %ebx
  8018ed:	83 ec 1c             	sub    $0x1c,%esp
  8018f0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018f6:	50                   	push   %eax
  8018f7:	ff 75 08             	pushl  0x8(%ebp)
  8018fa:	e8 52 fb ff ff       	call   801451 <fd_lookup>
  8018ff:	83 c4 10             	add    $0x10,%esp
  801902:	85 c0                	test   %eax,%eax
  801904:	78 4b                	js     801951 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801906:	83 ec 08             	sub    $0x8,%esp
  801909:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80190c:	50                   	push   %eax
  80190d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801910:	ff 30                	pushl  (%eax)
  801912:	e8 8e fb ff ff       	call   8014a5 <dev_lookup>
  801917:	83 c4 10             	add    $0x10,%esp
  80191a:	85 c0                	test   %eax,%eax
  80191c:	78 33                	js     801951 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80191e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801921:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801925:	74 2f                	je     801956 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801927:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80192a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801931:	00 00 00 
	stat->st_isdir = 0;
  801934:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80193b:	00 00 00 
	stat->st_dev = dev;
  80193e:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801944:	83 ec 08             	sub    $0x8,%esp
  801947:	53                   	push   %ebx
  801948:	ff 75 f0             	pushl  -0x10(%ebp)
  80194b:	ff 50 14             	call   *0x14(%eax)
  80194e:	83 c4 10             	add    $0x10,%esp
}
  801951:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801954:	c9                   	leave  
  801955:	c3                   	ret    
		return -E_NOT_SUPP;
  801956:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80195b:	eb f4                	jmp    801951 <fstat+0x6c>

0080195d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80195d:	f3 0f 1e fb          	endbr32 
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
  801964:	56                   	push   %esi
  801965:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801966:	83 ec 08             	sub    $0x8,%esp
  801969:	6a 00                	push   $0x0
  80196b:	ff 75 08             	pushl  0x8(%ebp)
  80196e:	e8 fb 01 00 00       	call   801b6e <open>
  801973:	89 c3                	mov    %eax,%ebx
  801975:	83 c4 10             	add    $0x10,%esp
  801978:	85 c0                	test   %eax,%eax
  80197a:	78 1b                	js     801997 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80197c:	83 ec 08             	sub    $0x8,%esp
  80197f:	ff 75 0c             	pushl  0xc(%ebp)
  801982:	50                   	push   %eax
  801983:	e8 5d ff ff ff       	call   8018e5 <fstat>
  801988:	89 c6                	mov    %eax,%esi
	close(fd);
  80198a:	89 1c 24             	mov    %ebx,(%esp)
  80198d:	e8 fd fb ff ff       	call   80158f <close>
	return r;
  801992:	83 c4 10             	add    $0x10,%esp
  801995:	89 f3                	mov    %esi,%ebx
}
  801997:	89 d8                	mov    %ebx,%eax
  801999:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80199c:	5b                   	pop    %ebx
  80199d:	5e                   	pop    %esi
  80199e:	5d                   	pop    %ebp
  80199f:	c3                   	ret    

008019a0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
  8019a3:	56                   	push   %esi
  8019a4:	53                   	push   %ebx
  8019a5:	89 c6                	mov    %eax,%esi
  8019a7:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8019a9:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8019b0:	74 27                	je     8019d9 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8019b2:	6a 07                	push   $0x7
  8019b4:	68 00 50 80 00       	push   $0x805000
  8019b9:	56                   	push   %esi
  8019ba:	ff 35 00 40 80 00    	pushl  0x804000
  8019c0:	e8 72 f9 ff ff       	call   801337 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8019c5:	83 c4 0c             	add    $0xc,%esp
  8019c8:	6a 00                	push   $0x0
  8019ca:	53                   	push   %ebx
  8019cb:	6a 00                	push   $0x0
  8019cd:	e8 e0 f8 ff ff       	call   8012b2 <ipc_recv>
}
  8019d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019d5:	5b                   	pop    %ebx
  8019d6:	5e                   	pop    %esi
  8019d7:	5d                   	pop    %ebp
  8019d8:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8019d9:	83 ec 0c             	sub    $0xc,%esp
  8019dc:	6a 01                	push   $0x1
  8019de:	e8 ac f9 ff ff       	call   80138f <ipc_find_env>
  8019e3:	a3 00 40 80 00       	mov    %eax,0x804000
  8019e8:	83 c4 10             	add    $0x10,%esp
  8019eb:	eb c5                	jmp    8019b2 <fsipc+0x12>

008019ed <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8019ed:	f3 0f 1e fb          	endbr32 
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
  8019f4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8019f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8019fd:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801a02:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a05:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a0a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a0f:	b8 02 00 00 00       	mov    $0x2,%eax
  801a14:	e8 87 ff ff ff       	call   8019a0 <fsipc>
}
  801a19:	c9                   	leave  
  801a1a:	c3                   	ret    

00801a1b <devfile_flush>:
{
  801a1b:	f3 0f 1e fb          	endbr32 
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
  801a22:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a25:	8b 45 08             	mov    0x8(%ebp),%eax
  801a28:	8b 40 0c             	mov    0xc(%eax),%eax
  801a2b:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801a30:	ba 00 00 00 00       	mov    $0x0,%edx
  801a35:	b8 06 00 00 00       	mov    $0x6,%eax
  801a3a:	e8 61 ff ff ff       	call   8019a0 <fsipc>
}
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    

00801a41 <devfile_stat>:
{
  801a41:	f3 0f 1e fb          	endbr32 
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
  801a48:	53                   	push   %ebx
  801a49:	83 ec 04             	sub    $0x4,%esp
  801a4c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a52:	8b 40 0c             	mov    0xc(%eax),%eax
  801a55:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a5a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a5f:	b8 05 00 00 00       	mov    $0x5,%eax
  801a64:	e8 37 ff ff ff       	call   8019a0 <fsipc>
  801a69:	85 c0                	test   %eax,%eax
  801a6b:	78 2c                	js     801a99 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a6d:	83 ec 08             	sub    $0x8,%esp
  801a70:	68 00 50 80 00       	push   $0x805000
  801a75:	53                   	push   %ebx
  801a76:	e8 3c ee ff ff       	call   8008b7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a7b:	a1 80 50 80 00       	mov    0x805080,%eax
  801a80:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a86:	a1 84 50 80 00       	mov    0x805084,%eax
  801a8b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a91:	83 c4 10             	add    $0x10,%esp
  801a94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    

00801a9e <devfile_write>:
{
  801a9e:	f3 0f 1e fb          	endbr32 
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
  801aa5:	83 ec 0c             	sub    $0xc,%esp
  801aa8:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801aab:	8b 55 08             	mov    0x8(%ebp),%edx
  801aae:	8b 52 0c             	mov    0xc(%edx),%edx
  801ab1:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801ab7:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801abc:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801ac1:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  801ac4:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801ac9:	50                   	push   %eax
  801aca:	ff 75 0c             	pushl  0xc(%ebp)
  801acd:	68 08 50 80 00       	push   $0x805008
  801ad2:	e8 96 ef ff ff       	call   800a6d <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801ad7:	ba 00 00 00 00       	mov    $0x0,%edx
  801adc:	b8 04 00 00 00       	mov    $0x4,%eax
  801ae1:	e8 ba fe ff ff       	call   8019a0 <fsipc>
}
  801ae6:	c9                   	leave  
  801ae7:	c3                   	ret    

00801ae8 <devfile_read>:
{
  801ae8:	f3 0f 1e fb          	endbr32 
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
  801aef:	56                   	push   %esi
  801af0:	53                   	push   %ebx
  801af1:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801af4:	8b 45 08             	mov    0x8(%ebp),%eax
  801af7:	8b 40 0c             	mov    0xc(%eax),%eax
  801afa:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801aff:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b05:	ba 00 00 00 00       	mov    $0x0,%edx
  801b0a:	b8 03 00 00 00       	mov    $0x3,%eax
  801b0f:	e8 8c fe ff ff       	call   8019a0 <fsipc>
  801b14:	89 c3                	mov    %eax,%ebx
  801b16:	85 c0                	test   %eax,%eax
  801b18:	78 1f                	js     801b39 <devfile_read+0x51>
	assert(r <= n);
  801b1a:	39 f0                	cmp    %esi,%eax
  801b1c:	77 24                	ja     801b42 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801b1e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b23:	7f 33                	jg     801b58 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b25:	83 ec 04             	sub    $0x4,%esp
  801b28:	50                   	push   %eax
  801b29:	68 00 50 80 00       	push   $0x805000
  801b2e:	ff 75 0c             	pushl  0xc(%ebp)
  801b31:	e8 37 ef ff ff       	call   800a6d <memmove>
	return r;
  801b36:	83 c4 10             	add    $0x10,%esp
}
  801b39:	89 d8                	mov    %ebx,%eax
  801b3b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b3e:	5b                   	pop    %ebx
  801b3f:	5e                   	pop    %esi
  801b40:	5d                   	pop    %ebp
  801b41:	c3                   	ret    
	assert(r <= n);
  801b42:	68 70 2e 80 00       	push   $0x802e70
  801b47:	68 77 2e 80 00       	push   $0x802e77
  801b4c:	6a 7c                	push   $0x7c
  801b4e:	68 8c 2e 80 00       	push   $0x802e8c
  801b53:	e8 76 0a 00 00       	call   8025ce <_panic>
	assert(r <= PGSIZE);
  801b58:	68 97 2e 80 00       	push   $0x802e97
  801b5d:	68 77 2e 80 00       	push   $0x802e77
  801b62:	6a 7d                	push   $0x7d
  801b64:	68 8c 2e 80 00       	push   $0x802e8c
  801b69:	e8 60 0a 00 00       	call   8025ce <_panic>

00801b6e <open>:
{
  801b6e:	f3 0f 1e fb          	endbr32 
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
  801b75:	56                   	push   %esi
  801b76:	53                   	push   %ebx
  801b77:	83 ec 1c             	sub    $0x1c,%esp
  801b7a:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b7d:	56                   	push   %esi
  801b7e:	e8 f1 ec ff ff       	call   800874 <strlen>
  801b83:	83 c4 10             	add    $0x10,%esp
  801b86:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b8b:	7f 6c                	jg     801bf9 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801b8d:	83 ec 0c             	sub    $0xc,%esp
  801b90:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b93:	50                   	push   %eax
  801b94:	e8 62 f8 ff ff       	call   8013fb <fd_alloc>
  801b99:	89 c3                	mov    %eax,%ebx
  801b9b:	83 c4 10             	add    $0x10,%esp
  801b9e:	85 c0                	test   %eax,%eax
  801ba0:	78 3c                	js     801bde <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801ba2:	83 ec 08             	sub    $0x8,%esp
  801ba5:	56                   	push   %esi
  801ba6:	68 00 50 80 00       	push   $0x805000
  801bab:	e8 07 ed ff ff       	call   8008b7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb3:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801bb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bbb:	b8 01 00 00 00       	mov    $0x1,%eax
  801bc0:	e8 db fd ff ff       	call   8019a0 <fsipc>
  801bc5:	89 c3                	mov    %eax,%ebx
  801bc7:	83 c4 10             	add    $0x10,%esp
  801bca:	85 c0                	test   %eax,%eax
  801bcc:	78 19                	js     801be7 <open+0x79>
	return fd2num(fd);
  801bce:	83 ec 0c             	sub    $0xc,%esp
  801bd1:	ff 75 f4             	pushl  -0xc(%ebp)
  801bd4:	e8 f3 f7 ff ff       	call   8013cc <fd2num>
  801bd9:	89 c3                	mov    %eax,%ebx
  801bdb:	83 c4 10             	add    $0x10,%esp
}
  801bde:	89 d8                	mov    %ebx,%eax
  801be0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801be3:	5b                   	pop    %ebx
  801be4:	5e                   	pop    %esi
  801be5:	5d                   	pop    %ebp
  801be6:	c3                   	ret    
		fd_close(fd, 0);
  801be7:	83 ec 08             	sub    $0x8,%esp
  801bea:	6a 00                	push   $0x0
  801bec:	ff 75 f4             	pushl  -0xc(%ebp)
  801bef:	e8 10 f9 ff ff       	call   801504 <fd_close>
		return r;
  801bf4:	83 c4 10             	add    $0x10,%esp
  801bf7:	eb e5                	jmp    801bde <open+0x70>
		return -E_BAD_PATH;
  801bf9:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801bfe:	eb de                	jmp    801bde <open+0x70>

00801c00 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c00:	f3 0f 1e fb          	endbr32 
  801c04:	55                   	push   %ebp
  801c05:	89 e5                	mov    %esp,%ebp
  801c07:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c0a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c0f:	b8 08 00 00 00       	mov    $0x8,%eax
  801c14:	e8 87 fd ff ff       	call   8019a0 <fsipc>
}
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    

00801c1b <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801c1b:	f3 0f 1e fb          	endbr32 
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
  801c22:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801c25:	68 a3 2e 80 00       	push   $0x802ea3
  801c2a:	ff 75 0c             	pushl  0xc(%ebp)
  801c2d:	e8 85 ec ff ff       	call   8008b7 <strcpy>
	return 0;
}
  801c32:	b8 00 00 00 00       	mov    $0x0,%eax
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    

00801c39 <devsock_close>:
{
  801c39:	f3 0f 1e fb          	endbr32 
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
  801c40:	53                   	push   %ebx
  801c41:	83 ec 10             	sub    $0x10,%esp
  801c44:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801c47:	53                   	push   %ebx
  801c48:	e8 64 0a 00 00       	call   8026b1 <pageref>
  801c4d:	89 c2                	mov    %eax,%edx
  801c4f:	83 c4 10             	add    $0x10,%esp
		return 0;
  801c52:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801c57:	83 fa 01             	cmp    $0x1,%edx
  801c5a:	74 05                	je     801c61 <devsock_close+0x28>
}
  801c5c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c5f:	c9                   	leave  
  801c60:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801c61:	83 ec 0c             	sub    $0xc,%esp
  801c64:	ff 73 0c             	pushl  0xc(%ebx)
  801c67:	e8 e3 02 00 00       	call   801f4f <nsipc_close>
  801c6c:	83 c4 10             	add    $0x10,%esp
  801c6f:	eb eb                	jmp    801c5c <devsock_close+0x23>

00801c71 <devsock_write>:
{
  801c71:	f3 0f 1e fb          	endbr32 
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
  801c78:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801c7b:	6a 00                	push   $0x0
  801c7d:	ff 75 10             	pushl  0x10(%ebp)
  801c80:	ff 75 0c             	pushl  0xc(%ebp)
  801c83:	8b 45 08             	mov    0x8(%ebp),%eax
  801c86:	ff 70 0c             	pushl  0xc(%eax)
  801c89:	e8 b5 03 00 00       	call   802043 <nsipc_send>
}
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <devsock_read>:
{
  801c90:	f3 0f 1e fb          	endbr32 
  801c94:	55                   	push   %ebp
  801c95:	89 e5                	mov    %esp,%ebp
  801c97:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801c9a:	6a 00                	push   $0x0
  801c9c:	ff 75 10             	pushl  0x10(%ebp)
  801c9f:	ff 75 0c             	pushl  0xc(%ebp)
  801ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca5:	ff 70 0c             	pushl  0xc(%eax)
  801ca8:	e8 1f 03 00 00       	call   801fcc <nsipc_recv>
}
  801cad:	c9                   	leave  
  801cae:	c3                   	ret    

00801caf <fd2sockid>:
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
  801cb2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801cb5:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801cb8:	52                   	push   %edx
  801cb9:	50                   	push   %eax
  801cba:	e8 92 f7 ff ff       	call   801451 <fd_lookup>
  801cbf:	83 c4 10             	add    $0x10,%esp
  801cc2:	85 c0                	test   %eax,%eax
  801cc4:	78 10                	js     801cd6 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc9:	8b 0d 28 30 80 00    	mov    0x803028,%ecx
  801ccf:	39 08                	cmp    %ecx,(%eax)
  801cd1:	75 05                	jne    801cd8 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801cd3:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801cd6:	c9                   	leave  
  801cd7:	c3                   	ret    
		return -E_NOT_SUPP;
  801cd8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801cdd:	eb f7                	jmp    801cd6 <fd2sockid+0x27>

00801cdf <alloc_sockfd>:
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
  801ce2:	56                   	push   %esi
  801ce3:	53                   	push   %ebx
  801ce4:	83 ec 1c             	sub    $0x1c,%esp
  801ce7:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801ce9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cec:	50                   	push   %eax
  801ced:	e8 09 f7 ff ff       	call   8013fb <fd_alloc>
  801cf2:	89 c3                	mov    %eax,%ebx
  801cf4:	83 c4 10             	add    $0x10,%esp
  801cf7:	85 c0                	test   %eax,%eax
  801cf9:	78 43                	js     801d3e <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801cfb:	83 ec 04             	sub    $0x4,%esp
  801cfe:	68 07 04 00 00       	push   $0x407
  801d03:	ff 75 f4             	pushl  -0xc(%ebp)
  801d06:	6a 00                	push   $0x0
  801d08:	e8 ec ef ff ff       	call   800cf9 <sys_page_alloc>
  801d0d:	89 c3                	mov    %eax,%ebx
  801d0f:	83 c4 10             	add    $0x10,%esp
  801d12:	85 c0                	test   %eax,%eax
  801d14:	78 28                	js     801d3e <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d19:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801d1f:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d24:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801d2b:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801d2e:	83 ec 0c             	sub    $0xc,%esp
  801d31:	50                   	push   %eax
  801d32:	e8 95 f6 ff ff       	call   8013cc <fd2num>
  801d37:	89 c3                	mov    %eax,%ebx
  801d39:	83 c4 10             	add    $0x10,%esp
  801d3c:	eb 0c                	jmp    801d4a <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801d3e:	83 ec 0c             	sub    $0xc,%esp
  801d41:	56                   	push   %esi
  801d42:	e8 08 02 00 00       	call   801f4f <nsipc_close>
		return r;
  801d47:	83 c4 10             	add    $0x10,%esp
}
  801d4a:	89 d8                	mov    %ebx,%eax
  801d4c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d4f:	5b                   	pop    %ebx
  801d50:	5e                   	pop    %esi
  801d51:	5d                   	pop    %ebp
  801d52:	c3                   	ret    

00801d53 <accept>:
{
  801d53:	f3 0f 1e fb          	endbr32 
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
  801d5a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d60:	e8 4a ff ff ff       	call   801caf <fd2sockid>
  801d65:	85 c0                	test   %eax,%eax
  801d67:	78 1b                	js     801d84 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801d69:	83 ec 04             	sub    $0x4,%esp
  801d6c:	ff 75 10             	pushl  0x10(%ebp)
  801d6f:	ff 75 0c             	pushl  0xc(%ebp)
  801d72:	50                   	push   %eax
  801d73:	e8 22 01 00 00       	call   801e9a <nsipc_accept>
  801d78:	83 c4 10             	add    $0x10,%esp
  801d7b:	85 c0                	test   %eax,%eax
  801d7d:	78 05                	js     801d84 <accept+0x31>
	return alloc_sockfd(r);
  801d7f:	e8 5b ff ff ff       	call   801cdf <alloc_sockfd>
}
  801d84:	c9                   	leave  
  801d85:	c3                   	ret    

00801d86 <bind>:
{
  801d86:	f3 0f 1e fb          	endbr32 
  801d8a:	55                   	push   %ebp
  801d8b:	89 e5                	mov    %esp,%ebp
  801d8d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d90:	8b 45 08             	mov    0x8(%ebp),%eax
  801d93:	e8 17 ff ff ff       	call   801caf <fd2sockid>
  801d98:	85 c0                	test   %eax,%eax
  801d9a:	78 12                	js     801dae <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801d9c:	83 ec 04             	sub    $0x4,%esp
  801d9f:	ff 75 10             	pushl  0x10(%ebp)
  801da2:	ff 75 0c             	pushl  0xc(%ebp)
  801da5:	50                   	push   %eax
  801da6:	e8 45 01 00 00       	call   801ef0 <nsipc_bind>
  801dab:	83 c4 10             	add    $0x10,%esp
}
  801dae:	c9                   	leave  
  801daf:	c3                   	ret    

00801db0 <shutdown>:
{
  801db0:	f3 0f 1e fb          	endbr32 
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
  801db7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801dba:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbd:	e8 ed fe ff ff       	call   801caf <fd2sockid>
  801dc2:	85 c0                	test   %eax,%eax
  801dc4:	78 0f                	js     801dd5 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801dc6:	83 ec 08             	sub    $0x8,%esp
  801dc9:	ff 75 0c             	pushl  0xc(%ebp)
  801dcc:	50                   	push   %eax
  801dcd:	e8 57 01 00 00       	call   801f29 <nsipc_shutdown>
  801dd2:	83 c4 10             	add    $0x10,%esp
}
  801dd5:	c9                   	leave  
  801dd6:	c3                   	ret    

00801dd7 <connect>:
{
  801dd7:	f3 0f 1e fb          	endbr32 
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
  801dde:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801de1:	8b 45 08             	mov    0x8(%ebp),%eax
  801de4:	e8 c6 fe ff ff       	call   801caf <fd2sockid>
  801de9:	85 c0                	test   %eax,%eax
  801deb:	78 12                	js     801dff <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801ded:	83 ec 04             	sub    $0x4,%esp
  801df0:	ff 75 10             	pushl  0x10(%ebp)
  801df3:	ff 75 0c             	pushl  0xc(%ebp)
  801df6:	50                   	push   %eax
  801df7:	e8 71 01 00 00       	call   801f6d <nsipc_connect>
  801dfc:	83 c4 10             	add    $0x10,%esp
}
  801dff:	c9                   	leave  
  801e00:	c3                   	ret    

00801e01 <listen>:
{
  801e01:	f3 0f 1e fb          	endbr32 
  801e05:	55                   	push   %ebp
  801e06:	89 e5                	mov    %esp,%ebp
  801e08:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0e:	e8 9c fe ff ff       	call   801caf <fd2sockid>
  801e13:	85 c0                	test   %eax,%eax
  801e15:	78 0f                	js     801e26 <listen+0x25>
	return nsipc_listen(r, backlog);
  801e17:	83 ec 08             	sub    $0x8,%esp
  801e1a:	ff 75 0c             	pushl  0xc(%ebp)
  801e1d:	50                   	push   %eax
  801e1e:	e8 83 01 00 00       	call   801fa6 <nsipc_listen>
  801e23:	83 c4 10             	add    $0x10,%esp
}
  801e26:	c9                   	leave  
  801e27:	c3                   	ret    

00801e28 <socket>:

int
socket(int domain, int type, int protocol)
{
  801e28:	f3 0f 1e fb          	endbr32 
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
  801e2f:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801e32:	ff 75 10             	pushl  0x10(%ebp)
  801e35:	ff 75 0c             	pushl  0xc(%ebp)
  801e38:	ff 75 08             	pushl  0x8(%ebp)
  801e3b:	e8 65 02 00 00       	call   8020a5 <nsipc_socket>
  801e40:	83 c4 10             	add    $0x10,%esp
  801e43:	85 c0                	test   %eax,%eax
  801e45:	78 05                	js     801e4c <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801e47:	e8 93 fe ff ff       	call   801cdf <alloc_sockfd>
}
  801e4c:	c9                   	leave  
  801e4d:	c3                   	ret    

00801e4e <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
  801e51:	53                   	push   %ebx
  801e52:	83 ec 04             	sub    $0x4,%esp
  801e55:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801e57:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801e5e:	74 26                	je     801e86 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801e60:	6a 07                	push   $0x7
  801e62:	68 00 60 80 00       	push   $0x806000
  801e67:	53                   	push   %ebx
  801e68:	ff 35 04 40 80 00    	pushl  0x804004
  801e6e:	e8 c4 f4 ff ff       	call   801337 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801e73:	83 c4 0c             	add    $0xc,%esp
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	e8 31 f4 ff ff       	call   8012b2 <ipc_recv>
}
  801e81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e84:	c9                   	leave  
  801e85:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801e86:	83 ec 0c             	sub    $0xc,%esp
  801e89:	6a 02                	push   $0x2
  801e8b:	e8 ff f4 ff ff       	call   80138f <ipc_find_env>
  801e90:	a3 04 40 80 00       	mov    %eax,0x804004
  801e95:	83 c4 10             	add    $0x10,%esp
  801e98:	eb c6                	jmp    801e60 <nsipc+0x12>

00801e9a <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e9a:	f3 0f 1e fb          	endbr32 
  801e9e:	55                   	push   %ebp
  801e9f:	89 e5                	mov    %esp,%ebp
  801ea1:	56                   	push   %esi
  801ea2:	53                   	push   %ebx
  801ea3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801eae:	8b 06                	mov    (%esi),%eax
  801eb0:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801eb5:	b8 01 00 00 00       	mov    $0x1,%eax
  801eba:	e8 8f ff ff ff       	call   801e4e <nsipc>
  801ebf:	89 c3                	mov    %eax,%ebx
  801ec1:	85 c0                	test   %eax,%eax
  801ec3:	79 09                	jns    801ece <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801ec5:	89 d8                	mov    %ebx,%eax
  801ec7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801eca:	5b                   	pop    %ebx
  801ecb:	5e                   	pop    %esi
  801ecc:	5d                   	pop    %ebp
  801ecd:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ece:	83 ec 04             	sub    $0x4,%esp
  801ed1:	ff 35 10 60 80 00    	pushl  0x806010
  801ed7:	68 00 60 80 00       	push   $0x806000
  801edc:	ff 75 0c             	pushl  0xc(%ebp)
  801edf:	e8 89 eb ff ff       	call   800a6d <memmove>
		*addrlen = ret->ret_addrlen;
  801ee4:	a1 10 60 80 00       	mov    0x806010,%eax
  801ee9:	89 06                	mov    %eax,(%esi)
  801eeb:	83 c4 10             	add    $0x10,%esp
	return r;
  801eee:	eb d5                	jmp    801ec5 <nsipc_accept+0x2b>

00801ef0 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ef0:	f3 0f 1e fb          	endbr32 
  801ef4:	55                   	push   %ebp
  801ef5:	89 e5                	mov    %esp,%ebp
  801ef7:	53                   	push   %ebx
  801ef8:	83 ec 08             	sub    $0x8,%esp
  801efb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801efe:	8b 45 08             	mov    0x8(%ebp),%eax
  801f01:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801f06:	53                   	push   %ebx
  801f07:	ff 75 0c             	pushl  0xc(%ebp)
  801f0a:	68 04 60 80 00       	push   $0x806004
  801f0f:	e8 59 eb ff ff       	call   800a6d <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801f14:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801f1a:	b8 02 00 00 00       	mov    $0x2,%eax
  801f1f:	e8 2a ff ff ff       	call   801e4e <nsipc>
}
  801f24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f27:	c9                   	leave  
  801f28:	c3                   	ret    

00801f29 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801f29:	f3 0f 1e fb          	endbr32 
  801f2d:	55                   	push   %ebp
  801f2e:	89 e5                	mov    %esp,%ebp
  801f30:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801f33:	8b 45 08             	mov    0x8(%ebp),%eax
  801f36:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801f3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f3e:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801f43:	b8 03 00 00 00       	mov    $0x3,%eax
  801f48:	e8 01 ff ff ff       	call   801e4e <nsipc>
}
  801f4d:	c9                   	leave  
  801f4e:	c3                   	ret    

00801f4f <nsipc_close>:

int
nsipc_close(int s)
{
  801f4f:	f3 0f 1e fb          	endbr32 
  801f53:	55                   	push   %ebp
  801f54:	89 e5                	mov    %esp,%ebp
  801f56:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801f59:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5c:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801f61:	b8 04 00 00 00       	mov    $0x4,%eax
  801f66:	e8 e3 fe ff ff       	call   801e4e <nsipc>
}
  801f6b:	c9                   	leave  
  801f6c:	c3                   	ret    

00801f6d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801f6d:	f3 0f 1e fb          	endbr32 
  801f71:	55                   	push   %ebp
  801f72:	89 e5                	mov    %esp,%ebp
  801f74:	53                   	push   %ebx
  801f75:	83 ec 08             	sub    $0x8,%esp
  801f78:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801f83:	53                   	push   %ebx
  801f84:	ff 75 0c             	pushl  0xc(%ebp)
  801f87:	68 04 60 80 00       	push   $0x806004
  801f8c:	e8 dc ea ff ff       	call   800a6d <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801f91:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801f97:	b8 05 00 00 00       	mov    $0x5,%eax
  801f9c:	e8 ad fe ff ff       	call   801e4e <nsipc>
}
  801fa1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fa4:	c9                   	leave  
  801fa5:	c3                   	ret    

00801fa6 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801fa6:	f3 0f 1e fb          	endbr32 
  801faa:	55                   	push   %ebp
  801fab:	89 e5                	mov    %esp,%ebp
  801fad:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801fb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fbb:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801fc0:	b8 06 00 00 00       	mov    $0x6,%eax
  801fc5:	e8 84 fe ff ff       	call   801e4e <nsipc>
}
  801fca:	c9                   	leave  
  801fcb:	c3                   	ret    

00801fcc <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801fcc:	f3 0f 1e fb          	endbr32 
  801fd0:	55                   	push   %ebp
  801fd1:	89 e5                	mov    %esp,%ebp
  801fd3:	56                   	push   %esi
  801fd4:	53                   	push   %ebx
  801fd5:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdb:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801fe0:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801fe6:	8b 45 14             	mov    0x14(%ebp),%eax
  801fe9:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801fee:	b8 07 00 00 00       	mov    $0x7,%eax
  801ff3:	e8 56 fe ff ff       	call   801e4e <nsipc>
  801ff8:	89 c3                	mov    %eax,%ebx
  801ffa:	85 c0                	test   %eax,%eax
  801ffc:	78 26                	js     802024 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801ffe:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  802004:	b8 3f 06 00 00       	mov    $0x63f,%eax
  802009:	0f 4e c6             	cmovle %esi,%eax
  80200c:	39 c3                	cmp    %eax,%ebx
  80200e:	7f 1d                	jg     80202d <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802010:	83 ec 04             	sub    $0x4,%esp
  802013:	53                   	push   %ebx
  802014:	68 00 60 80 00       	push   $0x806000
  802019:	ff 75 0c             	pushl  0xc(%ebp)
  80201c:	e8 4c ea ff ff       	call   800a6d <memmove>
  802021:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802024:	89 d8                	mov    %ebx,%eax
  802026:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802029:	5b                   	pop    %ebx
  80202a:	5e                   	pop    %esi
  80202b:	5d                   	pop    %ebp
  80202c:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80202d:	68 af 2e 80 00       	push   $0x802eaf
  802032:	68 77 2e 80 00       	push   $0x802e77
  802037:	6a 62                	push   $0x62
  802039:	68 c4 2e 80 00       	push   $0x802ec4
  80203e:	e8 8b 05 00 00       	call   8025ce <_panic>

00802043 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802043:	f3 0f 1e fb          	endbr32 
  802047:	55                   	push   %ebp
  802048:	89 e5                	mov    %esp,%ebp
  80204a:	53                   	push   %ebx
  80204b:	83 ec 04             	sub    $0x4,%esp
  80204e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802051:	8b 45 08             	mov    0x8(%ebp),%eax
  802054:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802059:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80205f:	7f 2e                	jg     80208f <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802061:	83 ec 04             	sub    $0x4,%esp
  802064:	53                   	push   %ebx
  802065:	ff 75 0c             	pushl  0xc(%ebp)
  802068:	68 0c 60 80 00       	push   $0x80600c
  80206d:	e8 fb e9 ff ff       	call   800a6d <memmove>
	nsipcbuf.send.req_size = size;
  802072:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802078:	8b 45 14             	mov    0x14(%ebp),%eax
  80207b:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  802080:	b8 08 00 00 00       	mov    $0x8,%eax
  802085:	e8 c4 fd ff ff       	call   801e4e <nsipc>
}
  80208a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80208d:	c9                   	leave  
  80208e:	c3                   	ret    
	assert(size < 1600);
  80208f:	68 d0 2e 80 00       	push   $0x802ed0
  802094:	68 77 2e 80 00       	push   $0x802e77
  802099:	6a 6d                	push   $0x6d
  80209b:	68 c4 2e 80 00       	push   $0x802ec4
  8020a0:	e8 29 05 00 00       	call   8025ce <_panic>

008020a5 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8020a5:	f3 0f 1e fb          	endbr32 
  8020a9:	55                   	push   %ebp
  8020aa:	89 e5                	mov    %esp,%ebp
  8020ac:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8020af:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8020b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ba:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8020bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8020c2:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8020c7:	b8 09 00 00 00       	mov    $0x9,%eax
  8020cc:	e8 7d fd ff ff       	call   801e4e <nsipc>
}
  8020d1:	c9                   	leave  
  8020d2:	c3                   	ret    

008020d3 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8020d3:	f3 0f 1e fb          	endbr32 
  8020d7:	55                   	push   %ebp
  8020d8:	89 e5                	mov    %esp,%ebp
  8020da:	56                   	push   %esi
  8020db:	53                   	push   %ebx
  8020dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8020df:	83 ec 0c             	sub    $0xc,%esp
  8020e2:	ff 75 08             	pushl  0x8(%ebp)
  8020e5:	e8 f6 f2 ff ff       	call   8013e0 <fd2data>
  8020ea:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8020ec:	83 c4 08             	add    $0x8,%esp
  8020ef:	68 dc 2e 80 00       	push   $0x802edc
  8020f4:	53                   	push   %ebx
  8020f5:	e8 bd e7 ff ff       	call   8008b7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8020fa:	8b 46 04             	mov    0x4(%esi),%eax
  8020fd:	2b 06                	sub    (%esi),%eax
  8020ff:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802105:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80210c:	00 00 00 
	stat->st_dev = &devpipe;
  80210f:	c7 83 88 00 00 00 44 	movl   $0x803044,0x88(%ebx)
  802116:	30 80 00 
	return 0;
}
  802119:	b8 00 00 00 00       	mov    $0x0,%eax
  80211e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802121:	5b                   	pop    %ebx
  802122:	5e                   	pop    %esi
  802123:	5d                   	pop    %ebp
  802124:	c3                   	ret    

00802125 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802125:	f3 0f 1e fb          	endbr32 
  802129:	55                   	push   %ebp
  80212a:	89 e5                	mov    %esp,%ebp
  80212c:	53                   	push   %ebx
  80212d:	83 ec 0c             	sub    $0xc,%esp
  802130:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802133:	53                   	push   %ebx
  802134:	6a 00                	push   $0x0
  802136:	e8 4b ec ff ff       	call   800d86 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80213b:	89 1c 24             	mov    %ebx,(%esp)
  80213e:	e8 9d f2 ff ff       	call   8013e0 <fd2data>
  802143:	83 c4 08             	add    $0x8,%esp
  802146:	50                   	push   %eax
  802147:	6a 00                	push   $0x0
  802149:	e8 38 ec ff ff       	call   800d86 <sys_page_unmap>
}
  80214e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802151:	c9                   	leave  
  802152:	c3                   	ret    

00802153 <_pipeisclosed>:
{
  802153:	55                   	push   %ebp
  802154:	89 e5                	mov    %esp,%ebp
  802156:	57                   	push   %edi
  802157:	56                   	push   %esi
  802158:	53                   	push   %ebx
  802159:	83 ec 1c             	sub    $0x1c,%esp
  80215c:	89 c7                	mov    %eax,%edi
  80215e:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802160:	a1 08 40 80 00       	mov    0x804008,%eax
  802165:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802168:	83 ec 0c             	sub    $0xc,%esp
  80216b:	57                   	push   %edi
  80216c:	e8 40 05 00 00       	call   8026b1 <pageref>
  802171:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802174:	89 34 24             	mov    %esi,(%esp)
  802177:	e8 35 05 00 00       	call   8026b1 <pageref>
		nn = thisenv->env_runs;
  80217c:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802182:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802185:	83 c4 10             	add    $0x10,%esp
  802188:	39 cb                	cmp    %ecx,%ebx
  80218a:	74 1b                	je     8021a7 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80218c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80218f:	75 cf                	jne    802160 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802191:	8b 42 58             	mov    0x58(%edx),%eax
  802194:	6a 01                	push   $0x1
  802196:	50                   	push   %eax
  802197:	53                   	push   %ebx
  802198:	68 e3 2e 80 00       	push   $0x802ee3
  80219d:	e8 0b e1 ff ff       	call   8002ad <cprintf>
  8021a2:	83 c4 10             	add    $0x10,%esp
  8021a5:	eb b9                	jmp    802160 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8021a7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8021aa:	0f 94 c0             	sete   %al
  8021ad:	0f b6 c0             	movzbl %al,%eax
}
  8021b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021b3:	5b                   	pop    %ebx
  8021b4:	5e                   	pop    %esi
  8021b5:	5f                   	pop    %edi
  8021b6:	5d                   	pop    %ebp
  8021b7:	c3                   	ret    

008021b8 <devpipe_write>:
{
  8021b8:	f3 0f 1e fb          	endbr32 
  8021bc:	55                   	push   %ebp
  8021bd:	89 e5                	mov    %esp,%ebp
  8021bf:	57                   	push   %edi
  8021c0:	56                   	push   %esi
  8021c1:	53                   	push   %ebx
  8021c2:	83 ec 28             	sub    $0x28,%esp
  8021c5:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8021c8:	56                   	push   %esi
  8021c9:	e8 12 f2 ff ff       	call   8013e0 <fd2data>
  8021ce:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8021d0:	83 c4 10             	add    $0x10,%esp
  8021d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8021d8:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8021db:	74 4f                	je     80222c <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8021dd:	8b 43 04             	mov    0x4(%ebx),%eax
  8021e0:	8b 0b                	mov    (%ebx),%ecx
  8021e2:	8d 51 20             	lea    0x20(%ecx),%edx
  8021e5:	39 d0                	cmp    %edx,%eax
  8021e7:	72 14                	jb     8021fd <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8021e9:	89 da                	mov    %ebx,%edx
  8021eb:	89 f0                	mov    %esi,%eax
  8021ed:	e8 61 ff ff ff       	call   802153 <_pipeisclosed>
  8021f2:	85 c0                	test   %eax,%eax
  8021f4:	75 3b                	jne    802231 <devpipe_write+0x79>
			sys_yield();
  8021f6:	e8 db ea ff ff       	call   800cd6 <sys_yield>
  8021fb:	eb e0                	jmp    8021dd <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8021fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802200:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802204:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802207:	89 c2                	mov    %eax,%edx
  802209:	c1 fa 1f             	sar    $0x1f,%edx
  80220c:	89 d1                	mov    %edx,%ecx
  80220e:	c1 e9 1b             	shr    $0x1b,%ecx
  802211:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802214:	83 e2 1f             	and    $0x1f,%edx
  802217:	29 ca                	sub    %ecx,%edx
  802219:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80221d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802221:	83 c0 01             	add    $0x1,%eax
  802224:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802227:	83 c7 01             	add    $0x1,%edi
  80222a:	eb ac                	jmp    8021d8 <devpipe_write+0x20>
	return i;
  80222c:	8b 45 10             	mov    0x10(%ebp),%eax
  80222f:	eb 05                	jmp    802236 <devpipe_write+0x7e>
				return 0;
  802231:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802236:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802239:	5b                   	pop    %ebx
  80223a:	5e                   	pop    %esi
  80223b:	5f                   	pop    %edi
  80223c:	5d                   	pop    %ebp
  80223d:	c3                   	ret    

0080223e <devpipe_read>:
{
  80223e:	f3 0f 1e fb          	endbr32 
  802242:	55                   	push   %ebp
  802243:	89 e5                	mov    %esp,%ebp
  802245:	57                   	push   %edi
  802246:	56                   	push   %esi
  802247:	53                   	push   %ebx
  802248:	83 ec 18             	sub    $0x18,%esp
  80224b:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80224e:	57                   	push   %edi
  80224f:	e8 8c f1 ff ff       	call   8013e0 <fd2data>
  802254:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802256:	83 c4 10             	add    $0x10,%esp
  802259:	be 00 00 00 00       	mov    $0x0,%esi
  80225e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802261:	75 14                	jne    802277 <devpipe_read+0x39>
	return i;
  802263:	8b 45 10             	mov    0x10(%ebp),%eax
  802266:	eb 02                	jmp    80226a <devpipe_read+0x2c>
				return i;
  802268:	89 f0                	mov    %esi,%eax
}
  80226a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80226d:	5b                   	pop    %ebx
  80226e:	5e                   	pop    %esi
  80226f:	5f                   	pop    %edi
  802270:	5d                   	pop    %ebp
  802271:	c3                   	ret    
			sys_yield();
  802272:	e8 5f ea ff ff       	call   800cd6 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802277:	8b 03                	mov    (%ebx),%eax
  802279:	3b 43 04             	cmp    0x4(%ebx),%eax
  80227c:	75 18                	jne    802296 <devpipe_read+0x58>
			if (i > 0)
  80227e:	85 f6                	test   %esi,%esi
  802280:	75 e6                	jne    802268 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  802282:	89 da                	mov    %ebx,%edx
  802284:	89 f8                	mov    %edi,%eax
  802286:	e8 c8 fe ff ff       	call   802153 <_pipeisclosed>
  80228b:	85 c0                	test   %eax,%eax
  80228d:	74 e3                	je     802272 <devpipe_read+0x34>
				return 0;
  80228f:	b8 00 00 00 00       	mov    $0x0,%eax
  802294:	eb d4                	jmp    80226a <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802296:	99                   	cltd   
  802297:	c1 ea 1b             	shr    $0x1b,%edx
  80229a:	01 d0                	add    %edx,%eax
  80229c:	83 e0 1f             	and    $0x1f,%eax
  80229f:	29 d0                	sub    %edx,%eax
  8022a1:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8022a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022a9:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8022ac:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8022af:	83 c6 01             	add    $0x1,%esi
  8022b2:	eb aa                	jmp    80225e <devpipe_read+0x20>

008022b4 <pipe>:
{
  8022b4:	f3 0f 1e fb          	endbr32 
  8022b8:	55                   	push   %ebp
  8022b9:	89 e5                	mov    %esp,%ebp
  8022bb:	56                   	push   %esi
  8022bc:	53                   	push   %ebx
  8022bd:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8022c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022c3:	50                   	push   %eax
  8022c4:	e8 32 f1 ff ff       	call   8013fb <fd_alloc>
  8022c9:	89 c3                	mov    %eax,%ebx
  8022cb:	83 c4 10             	add    $0x10,%esp
  8022ce:	85 c0                	test   %eax,%eax
  8022d0:	0f 88 23 01 00 00    	js     8023f9 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022d6:	83 ec 04             	sub    $0x4,%esp
  8022d9:	68 07 04 00 00       	push   $0x407
  8022de:	ff 75 f4             	pushl  -0xc(%ebp)
  8022e1:	6a 00                	push   $0x0
  8022e3:	e8 11 ea ff ff       	call   800cf9 <sys_page_alloc>
  8022e8:	89 c3                	mov    %eax,%ebx
  8022ea:	83 c4 10             	add    $0x10,%esp
  8022ed:	85 c0                	test   %eax,%eax
  8022ef:	0f 88 04 01 00 00    	js     8023f9 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  8022f5:	83 ec 0c             	sub    $0xc,%esp
  8022f8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8022fb:	50                   	push   %eax
  8022fc:	e8 fa f0 ff ff       	call   8013fb <fd_alloc>
  802301:	89 c3                	mov    %eax,%ebx
  802303:	83 c4 10             	add    $0x10,%esp
  802306:	85 c0                	test   %eax,%eax
  802308:	0f 88 db 00 00 00    	js     8023e9 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80230e:	83 ec 04             	sub    $0x4,%esp
  802311:	68 07 04 00 00       	push   $0x407
  802316:	ff 75 f0             	pushl  -0x10(%ebp)
  802319:	6a 00                	push   $0x0
  80231b:	e8 d9 e9 ff ff       	call   800cf9 <sys_page_alloc>
  802320:	89 c3                	mov    %eax,%ebx
  802322:	83 c4 10             	add    $0x10,%esp
  802325:	85 c0                	test   %eax,%eax
  802327:	0f 88 bc 00 00 00    	js     8023e9 <pipe+0x135>
	va = fd2data(fd0);
  80232d:	83 ec 0c             	sub    $0xc,%esp
  802330:	ff 75 f4             	pushl  -0xc(%ebp)
  802333:	e8 a8 f0 ff ff       	call   8013e0 <fd2data>
  802338:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80233a:	83 c4 0c             	add    $0xc,%esp
  80233d:	68 07 04 00 00       	push   $0x407
  802342:	50                   	push   %eax
  802343:	6a 00                	push   $0x0
  802345:	e8 af e9 ff ff       	call   800cf9 <sys_page_alloc>
  80234a:	89 c3                	mov    %eax,%ebx
  80234c:	83 c4 10             	add    $0x10,%esp
  80234f:	85 c0                	test   %eax,%eax
  802351:	0f 88 82 00 00 00    	js     8023d9 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802357:	83 ec 0c             	sub    $0xc,%esp
  80235a:	ff 75 f0             	pushl  -0x10(%ebp)
  80235d:	e8 7e f0 ff ff       	call   8013e0 <fd2data>
  802362:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802369:	50                   	push   %eax
  80236a:	6a 00                	push   $0x0
  80236c:	56                   	push   %esi
  80236d:	6a 00                	push   $0x0
  80236f:	e8 cc e9 ff ff       	call   800d40 <sys_page_map>
  802374:	89 c3                	mov    %eax,%ebx
  802376:	83 c4 20             	add    $0x20,%esp
  802379:	85 c0                	test   %eax,%eax
  80237b:	78 4e                	js     8023cb <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  80237d:	a1 44 30 80 00       	mov    0x803044,%eax
  802382:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802385:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802387:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80238a:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802391:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802394:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802396:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802399:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8023a0:	83 ec 0c             	sub    $0xc,%esp
  8023a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8023a6:	e8 21 f0 ff ff       	call   8013cc <fd2num>
  8023ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023ae:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8023b0:	83 c4 04             	add    $0x4,%esp
  8023b3:	ff 75 f0             	pushl  -0x10(%ebp)
  8023b6:	e8 11 f0 ff ff       	call   8013cc <fd2num>
  8023bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023be:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8023c1:	83 c4 10             	add    $0x10,%esp
  8023c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8023c9:	eb 2e                	jmp    8023f9 <pipe+0x145>
	sys_page_unmap(0, va);
  8023cb:	83 ec 08             	sub    $0x8,%esp
  8023ce:	56                   	push   %esi
  8023cf:	6a 00                	push   $0x0
  8023d1:	e8 b0 e9 ff ff       	call   800d86 <sys_page_unmap>
  8023d6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8023d9:	83 ec 08             	sub    $0x8,%esp
  8023dc:	ff 75 f0             	pushl  -0x10(%ebp)
  8023df:	6a 00                	push   $0x0
  8023e1:	e8 a0 e9 ff ff       	call   800d86 <sys_page_unmap>
  8023e6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8023e9:	83 ec 08             	sub    $0x8,%esp
  8023ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8023ef:	6a 00                	push   $0x0
  8023f1:	e8 90 e9 ff ff       	call   800d86 <sys_page_unmap>
  8023f6:	83 c4 10             	add    $0x10,%esp
}
  8023f9:	89 d8                	mov    %ebx,%eax
  8023fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023fe:	5b                   	pop    %ebx
  8023ff:	5e                   	pop    %esi
  802400:	5d                   	pop    %ebp
  802401:	c3                   	ret    

00802402 <pipeisclosed>:
{
  802402:	f3 0f 1e fb          	endbr32 
  802406:	55                   	push   %ebp
  802407:	89 e5                	mov    %esp,%ebp
  802409:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80240c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80240f:	50                   	push   %eax
  802410:	ff 75 08             	pushl  0x8(%ebp)
  802413:	e8 39 f0 ff ff       	call   801451 <fd_lookup>
  802418:	83 c4 10             	add    $0x10,%esp
  80241b:	85 c0                	test   %eax,%eax
  80241d:	78 18                	js     802437 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  80241f:	83 ec 0c             	sub    $0xc,%esp
  802422:	ff 75 f4             	pushl  -0xc(%ebp)
  802425:	e8 b6 ef ff ff       	call   8013e0 <fd2data>
  80242a:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  80242c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242f:	e8 1f fd ff ff       	call   802153 <_pipeisclosed>
  802434:	83 c4 10             	add    $0x10,%esp
}
  802437:	c9                   	leave  
  802438:	c3                   	ret    

00802439 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802439:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  80243d:	b8 00 00 00 00       	mov    $0x0,%eax
  802442:	c3                   	ret    

00802443 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802443:	f3 0f 1e fb          	endbr32 
  802447:	55                   	push   %ebp
  802448:	89 e5                	mov    %esp,%ebp
  80244a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80244d:	68 fb 2e 80 00       	push   $0x802efb
  802452:	ff 75 0c             	pushl  0xc(%ebp)
  802455:	e8 5d e4 ff ff       	call   8008b7 <strcpy>
	return 0;
}
  80245a:	b8 00 00 00 00       	mov    $0x0,%eax
  80245f:	c9                   	leave  
  802460:	c3                   	ret    

00802461 <devcons_write>:
{
  802461:	f3 0f 1e fb          	endbr32 
  802465:	55                   	push   %ebp
  802466:	89 e5                	mov    %esp,%ebp
  802468:	57                   	push   %edi
  802469:	56                   	push   %esi
  80246a:	53                   	push   %ebx
  80246b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802471:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802476:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80247c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80247f:	73 31                	jae    8024b2 <devcons_write+0x51>
		m = n - tot;
  802481:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802484:	29 f3                	sub    %esi,%ebx
  802486:	83 fb 7f             	cmp    $0x7f,%ebx
  802489:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80248e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802491:	83 ec 04             	sub    $0x4,%esp
  802494:	53                   	push   %ebx
  802495:	89 f0                	mov    %esi,%eax
  802497:	03 45 0c             	add    0xc(%ebp),%eax
  80249a:	50                   	push   %eax
  80249b:	57                   	push   %edi
  80249c:	e8 cc e5 ff ff       	call   800a6d <memmove>
		sys_cputs(buf, m);
  8024a1:	83 c4 08             	add    $0x8,%esp
  8024a4:	53                   	push   %ebx
  8024a5:	57                   	push   %edi
  8024a6:	e8 7e e7 ff ff       	call   800c29 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8024ab:	01 de                	add    %ebx,%esi
  8024ad:	83 c4 10             	add    $0x10,%esp
  8024b0:	eb ca                	jmp    80247c <devcons_write+0x1b>
}
  8024b2:	89 f0                	mov    %esi,%eax
  8024b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024b7:	5b                   	pop    %ebx
  8024b8:	5e                   	pop    %esi
  8024b9:	5f                   	pop    %edi
  8024ba:	5d                   	pop    %ebp
  8024bb:	c3                   	ret    

008024bc <devcons_read>:
{
  8024bc:	f3 0f 1e fb          	endbr32 
  8024c0:	55                   	push   %ebp
  8024c1:	89 e5                	mov    %esp,%ebp
  8024c3:	83 ec 08             	sub    $0x8,%esp
  8024c6:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8024cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8024cf:	74 21                	je     8024f2 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8024d1:	e8 75 e7 ff ff       	call   800c4b <sys_cgetc>
  8024d6:	85 c0                	test   %eax,%eax
  8024d8:	75 07                	jne    8024e1 <devcons_read+0x25>
		sys_yield();
  8024da:	e8 f7 e7 ff ff       	call   800cd6 <sys_yield>
  8024df:	eb f0                	jmp    8024d1 <devcons_read+0x15>
	if (c < 0)
  8024e1:	78 0f                	js     8024f2 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8024e3:	83 f8 04             	cmp    $0x4,%eax
  8024e6:	74 0c                	je     8024f4 <devcons_read+0x38>
	*(char*)vbuf = c;
  8024e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024eb:	88 02                	mov    %al,(%edx)
	return 1;
  8024ed:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8024f2:	c9                   	leave  
  8024f3:	c3                   	ret    
		return 0;
  8024f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f9:	eb f7                	jmp    8024f2 <devcons_read+0x36>

008024fb <cputchar>:
{
  8024fb:	f3 0f 1e fb          	endbr32 
  8024ff:	55                   	push   %ebp
  802500:	89 e5                	mov    %esp,%ebp
  802502:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802505:	8b 45 08             	mov    0x8(%ebp),%eax
  802508:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80250b:	6a 01                	push   $0x1
  80250d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802510:	50                   	push   %eax
  802511:	e8 13 e7 ff ff       	call   800c29 <sys_cputs>
}
  802516:	83 c4 10             	add    $0x10,%esp
  802519:	c9                   	leave  
  80251a:	c3                   	ret    

0080251b <getchar>:
{
  80251b:	f3 0f 1e fb          	endbr32 
  80251f:	55                   	push   %ebp
  802520:	89 e5                	mov    %esp,%ebp
  802522:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802525:	6a 01                	push   $0x1
  802527:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80252a:	50                   	push   %eax
  80252b:	6a 00                	push   $0x0
  80252d:	e8 a7 f1 ff ff       	call   8016d9 <read>
	if (r < 0)
  802532:	83 c4 10             	add    $0x10,%esp
  802535:	85 c0                	test   %eax,%eax
  802537:	78 06                	js     80253f <getchar+0x24>
	if (r < 1)
  802539:	74 06                	je     802541 <getchar+0x26>
	return c;
  80253b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80253f:	c9                   	leave  
  802540:	c3                   	ret    
		return -E_EOF;
  802541:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802546:	eb f7                	jmp    80253f <getchar+0x24>

00802548 <iscons>:
{
  802548:	f3 0f 1e fb          	endbr32 
  80254c:	55                   	push   %ebp
  80254d:	89 e5                	mov    %esp,%ebp
  80254f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802552:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802555:	50                   	push   %eax
  802556:	ff 75 08             	pushl  0x8(%ebp)
  802559:	e8 f3 ee ff ff       	call   801451 <fd_lookup>
  80255e:	83 c4 10             	add    $0x10,%esp
  802561:	85 c0                	test   %eax,%eax
  802563:	78 11                	js     802576 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  802565:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802568:	8b 15 60 30 80 00    	mov    0x803060,%edx
  80256e:	39 10                	cmp    %edx,(%eax)
  802570:	0f 94 c0             	sete   %al
  802573:	0f b6 c0             	movzbl %al,%eax
}
  802576:	c9                   	leave  
  802577:	c3                   	ret    

00802578 <opencons>:
{
  802578:	f3 0f 1e fb          	endbr32 
  80257c:	55                   	push   %ebp
  80257d:	89 e5                	mov    %esp,%ebp
  80257f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802582:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802585:	50                   	push   %eax
  802586:	e8 70 ee ff ff       	call   8013fb <fd_alloc>
  80258b:	83 c4 10             	add    $0x10,%esp
  80258e:	85 c0                	test   %eax,%eax
  802590:	78 3a                	js     8025cc <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802592:	83 ec 04             	sub    $0x4,%esp
  802595:	68 07 04 00 00       	push   $0x407
  80259a:	ff 75 f4             	pushl  -0xc(%ebp)
  80259d:	6a 00                	push   $0x0
  80259f:	e8 55 e7 ff ff       	call   800cf9 <sys_page_alloc>
  8025a4:	83 c4 10             	add    $0x10,%esp
  8025a7:	85 c0                	test   %eax,%eax
  8025a9:	78 21                	js     8025cc <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8025ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ae:	8b 15 60 30 80 00    	mov    0x803060,%edx
  8025b4:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8025b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8025c0:	83 ec 0c             	sub    $0xc,%esp
  8025c3:	50                   	push   %eax
  8025c4:	e8 03 ee ff ff       	call   8013cc <fd2num>
  8025c9:	83 c4 10             	add    $0x10,%esp
}
  8025cc:	c9                   	leave  
  8025cd:	c3                   	ret    

008025ce <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8025ce:	f3 0f 1e fb          	endbr32 
  8025d2:	55                   	push   %ebp
  8025d3:	89 e5                	mov    %esp,%ebp
  8025d5:	56                   	push   %esi
  8025d6:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8025d7:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8025da:	8b 35 08 30 80 00    	mov    0x803008,%esi
  8025e0:	e8 ce e6 ff ff       	call   800cb3 <sys_getenvid>
  8025e5:	83 ec 0c             	sub    $0xc,%esp
  8025e8:	ff 75 0c             	pushl  0xc(%ebp)
  8025eb:	ff 75 08             	pushl  0x8(%ebp)
  8025ee:	56                   	push   %esi
  8025ef:	50                   	push   %eax
  8025f0:	68 08 2f 80 00       	push   $0x802f08
  8025f5:	e8 b3 dc ff ff       	call   8002ad <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8025fa:	83 c4 18             	add    $0x18,%esp
  8025fd:	53                   	push   %ebx
  8025fe:	ff 75 10             	pushl  0x10(%ebp)
  802601:	e8 52 dc ff ff       	call   800258 <vcprintf>
	cprintf("\n");
  802606:	c7 04 24 d4 2d 80 00 	movl   $0x802dd4,(%esp)
  80260d:	e8 9b dc ff ff       	call   8002ad <cprintf>
  802612:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802615:	cc                   	int3   
  802616:	eb fd                	jmp    802615 <_panic+0x47>

00802618 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802618:	f3 0f 1e fb          	endbr32 
  80261c:	55                   	push   %ebp
  80261d:	89 e5                	mov    %esp,%ebp
  80261f:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802622:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802629:	74 0a                	je     802635 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80262b:	8b 45 08             	mov    0x8(%ebp),%eax
  80262e:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802633:	c9                   	leave  
  802634:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  802635:	83 ec 04             	sub    $0x4,%esp
  802638:	6a 07                	push   $0x7
  80263a:	68 00 f0 bf ee       	push   $0xeebff000
  80263f:	6a 00                	push   $0x0
  802641:	e8 b3 e6 ff ff       	call   800cf9 <sys_page_alloc>
  802646:	83 c4 10             	add    $0x10,%esp
  802649:	85 c0                	test   %eax,%eax
  80264b:	78 2a                	js     802677 <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  80264d:	83 ec 08             	sub    $0x8,%esp
  802650:	68 8b 26 80 00       	push   $0x80268b
  802655:	6a 00                	push   $0x0
  802657:	e8 fc e7 ff ff       	call   800e58 <sys_env_set_pgfault_upcall>
  80265c:	83 c4 10             	add    $0x10,%esp
  80265f:	85 c0                	test   %eax,%eax
  802661:	79 c8                	jns    80262b <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  802663:	83 ec 04             	sub    $0x4,%esp
  802666:	68 58 2f 80 00       	push   $0x802f58
  80266b:	6a 25                	push   $0x25
  80266d:	68 90 2f 80 00       	push   $0x802f90
  802672:	e8 57 ff ff ff       	call   8025ce <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  802677:	83 ec 04             	sub    $0x4,%esp
  80267a:	68 2c 2f 80 00       	push   $0x802f2c
  80267f:	6a 22                	push   $0x22
  802681:	68 90 2f 80 00       	push   $0x802f90
  802686:	e8 43 ff ff ff       	call   8025ce <_panic>

0080268b <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80268b:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80268c:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  802691:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802693:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  802696:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  80269a:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  80269e:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8026a1:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  8026a3:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  8026a7:	83 c4 08             	add    $0x8,%esp
	popal
  8026aa:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  8026ab:	83 c4 04             	add    $0x4,%esp
	popfl
  8026ae:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  8026af:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  8026b0:	c3                   	ret    

008026b1 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8026b1:	f3 0f 1e fb          	endbr32 
  8026b5:	55                   	push   %ebp
  8026b6:	89 e5                	mov    %esp,%ebp
  8026b8:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8026bb:	89 c2                	mov    %eax,%edx
  8026bd:	c1 ea 16             	shr    $0x16,%edx
  8026c0:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8026c7:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8026cc:	f6 c1 01             	test   $0x1,%cl
  8026cf:	74 1c                	je     8026ed <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8026d1:	c1 e8 0c             	shr    $0xc,%eax
  8026d4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8026db:	a8 01                	test   $0x1,%al
  8026dd:	74 0e                	je     8026ed <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8026df:	c1 e8 0c             	shr    $0xc,%eax
  8026e2:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8026e9:	ef 
  8026ea:	0f b7 d2             	movzwl %dx,%edx
}
  8026ed:	89 d0                	mov    %edx,%eax
  8026ef:	5d                   	pop    %ebp
  8026f0:	c3                   	ret    
  8026f1:	66 90                	xchg   %ax,%ax
  8026f3:	66 90                	xchg   %ax,%ax
  8026f5:	66 90                	xchg   %ax,%ax
  8026f7:	66 90                	xchg   %ax,%ax
  8026f9:	66 90                	xchg   %ax,%ax
  8026fb:	66 90                	xchg   %ax,%ax
  8026fd:	66 90                	xchg   %ax,%ax
  8026ff:	90                   	nop

00802700 <__udivdi3>:
  802700:	f3 0f 1e fb          	endbr32 
  802704:	55                   	push   %ebp
  802705:	57                   	push   %edi
  802706:	56                   	push   %esi
  802707:	53                   	push   %ebx
  802708:	83 ec 1c             	sub    $0x1c,%esp
  80270b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80270f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802713:	8b 74 24 34          	mov    0x34(%esp),%esi
  802717:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80271b:	85 d2                	test   %edx,%edx
  80271d:	75 19                	jne    802738 <__udivdi3+0x38>
  80271f:	39 f3                	cmp    %esi,%ebx
  802721:	76 4d                	jbe    802770 <__udivdi3+0x70>
  802723:	31 ff                	xor    %edi,%edi
  802725:	89 e8                	mov    %ebp,%eax
  802727:	89 f2                	mov    %esi,%edx
  802729:	f7 f3                	div    %ebx
  80272b:	89 fa                	mov    %edi,%edx
  80272d:	83 c4 1c             	add    $0x1c,%esp
  802730:	5b                   	pop    %ebx
  802731:	5e                   	pop    %esi
  802732:	5f                   	pop    %edi
  802733:	5d                   	pop    %ebp
  802734:	c3                   	ret    
  802735:	8d 76 00             	lea    0x0(%esi),%esi
  802738:	39 f2                	cmp    %esi,%edx
  80273a:	76 14                	jbe    802750 <__udivdi3+0x50>
  80273c:	31 ff                	xor    %edi,%edi
  80273e:	31 c0                	xor    %eax,%eax
  802740:	89 fa                	mov    %edi,%edx
  802742:	83 c4 1c             	add    $0x1c,%esp
  802745:	5b                   	pop    %ebx
  802746:	5e                   	pop    %esi
  802747:	5f                   	pop    %edi
  802748:	5d                   	pop    %ebp
  802749:	c3                   	ret    
  80274a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802750:	0f bd fa             	bsr    %edx,%edi
  802753:	83 f7 1f             	xor    $0x1f,%edi
  802756:	75 48                	jne    8027a0 <__udivdi3+0xa0>
  802758:	39 f2                	cmp    %esi,%edx
  80275a:	72 06                	jb     802762 <__udivdi3+0x62>
  80275c:	31 c0                	xor    %eax,%eax
  80275e:	39 eb                	cmp    %ebp,%ebx
  802760:	77 de                	ja     802740 <__udivdi3+0x40>
  802762:	b8 01 00 00 00       	mov    $0x1,%eax
  802767:	eb d7                	jmp    802740 <__udivdi3+0x40>
  802769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802770:	89 d9                	mov    %ebx,%ecx
  802772:	85 db                	test   %ebx,%ebx
  802774:	75 0b                	jne    802781 <__udivdi3+0x81>
  802776:	b8 01 00 00 00       	mov    $0x1,%eax
  80277b:	31 d2                	xor    %edx,%edx
  80277d:	f7 f3                	div    %ebx
  80277f:	89 c1                	mov    %eax,%ecx
  802781:	31 d2                	xor    %edx,%edx
  802783:	89 f0                	mov    %esi,%eax
  802785:	f7 f1                	div    %ecx
  802787:	89 c6                	mov    %eax,%esi
  802789:	89 e8                	mov    %ebp,%eax
  80278b:	89 f7                	mov    %esi,%edi
  80278d:	f7 f1                	div    %ecx
  80278f:	89 fa                	mov    %edi,%edx
  802791:	83 c4 1c             	add    $0x1c,%esp
  802794:	5b                   	pop    %ebx
  802795:	5e                   	pop    %esi
  802796:	5f                   	pop    %edi
  802797:	5d                   	pop    %ebp
  802798:	c3                   	ret    
  802799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027a0:	89 f9                	mov    %edi,%ecx
  8027a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8027a7:	29 f8                	sub    %edi,%eax
  8027a9:	d3 e2                	shl    %cl,%edx
  8027ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8027af:	89 c1                	mov    %eax,%ecx
  8027b1:	89 da                	mov    %ebx,%edx
  8027b3:	d3 ea                	shr    %cl,%edx
  8027b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8027b9:	09 d1                	or     %edx,%ecx
  8027bb:	89 f2                	mov    %esi,%edx
  8027bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027c1:	89 f9                	mov    %edi,%ecx
  8027c3:	d3 e3                	shl    %cl,%ebx
  8027c5:	89 c1                	mov    %eax,%ecx
  8027c7:	d3 ea                	shr    %cl,%edx
  8027c9:	89 f9                	mov    %edi,%ecx
  8027cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8027cf:	89 eb                	mov    %ebp,%ebx
  8027d1:	d3 e6                	shl    %cl,%esi
  8027d3:	89 c1                	mov    %eax,%ecx
  8027d5:	d3 eb                	shr    %cl,%ebx
  8027d7:	09 de                	or     %ebx,%esi
  8027d9:	89 f0                	mov    %esi,%eax
  8027db:	f7 74 24 08          	divl   0x8(%esp)
  8027df:	89 d6                	mov    %edx,%esi
  8027e1:	89 c3                	mov    %eax,%ebx
  8027e3:	f7 64 24 0c          	mull   0xc(%esp)
  8027e7:	39 d6                	cmp    %edx,%esi
  8027e9:	72 15                	jb     802800 <__udivdi3+0x100>
  8027eb:	89 f9                	mov    %edi,%ecx
  8027ed:	d3 e5                	shl    %cl,%ebp
  8027ef:	39 c5                	cmp    %eax,%ebp
  8027f1:	73 04                	jae    8027f7 <__udivdi3+0xf7>
  8027f3:	39 d6                	cmp    %edx,%esi
  8027f5:	74 09                	je     802800 <__udivdi3+0x100>
  8027f7:	89 d8                	mov    %ebx,%eax
  8027f9:	31 ff                	xor    %edi,%edi
  8027fb:	e9 40 ff ff ff       	jmp    802740 <__udivdi3+0x40>
  802800:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802803:	31 ff                	xor    %edi,%edi
  802805:	e9 36 ff ff ff       	jmp    802740 <__udivdi3+0x40>
  80280a:	66 90                	xchg   %ax,%ax
  80280c:	66 90                	xchg   %ax,%ax
  80280e:	66 90                	xchg   %ax,%ax

00802810 <__umoddi3>:
  802810:	f3 0f 1e fb          	endbr32 
  802814:	55                   	push   %ebp
  802815:	57                   	push   %edi
  802816:	56                   	push   %esi
  802817:	53                   	push   %ebx
  802818:	83 ec 1c             	sub    $0x1c,%esp
  80281b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80281f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802823:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802827:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80282b:	85 c0                	test   %eax,%eax
  80282d:	75 19                	jne    802848 <__umoddi3+0x38>
  80282f:	39 df                	cmp    %ebx,%edi
  802831:	76 5d                	jbe    802890 <__umoddi3+0x80>
  802833:	89 f0                	mov    %esi,%eax
  802835:	89 da                	mov    %ebx,%edx
  802837:	f7 f7                	div    %edi
  802839:	89 d0                	mov    %edx,%eax
  80283b:	31 d2                	xor    %edx,%edx
  80283d:	83 c4 1c             	add    $0x1c,%esp
  802840:	5b                   	pop    %ebx
  802841:	5e                   	pop    %esi
  802842:	5f                   	pop    %edi
  802843:	5d                   	pop    %ebp
  802844:	c3                   	ret    
  802845:	8d 76 00             	lea    0x0(%esi),%esi
  802848:	89 f2                	mov    %esi,%edx
  80284a:	39 d8                	cmp    %ebx,%eax
  80284c:	76 12                	jbe    802860 <__umoddi3+0x50>
  80284e:	89 f0                	mov    %esi,%eax
  802850:	89 da                	mov    %ebx,%edx
  802852:	83 c4 1c             	add    $0x1c,%esp
  802855:	5b                   	pop    %ebx
  802856:	5e                   	pop    %esi
  802857:	5f                   	pop    %edi
  802858:	5d                   	pop    %ebp
  802859:	c3                   	ret    
  80285a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802860:	0f bd e8             	bsr    %eax,%ebp
  802863:	83 f5 1f             	xor    $0x1f,%ebp
  802866:	75 50                	jne    8028b8 <__umoddi3+0xa8>
  802868:	39 d8                	cmp    %ebx,%eax
  80286a:	0f 82 e0 00 00 00    	jb     802950 <__umoddi3+0x140>
  802870:	89 d9                	mov    %ebx,%ecx
  802872:	39 f7                	cmp    %esi,%edi
  802874:	0f 86 d6 00 00 00    	jbe    802950 <__umoddi3+0x140>
  80287a:	89 d0                	mov    %edx,%eax
  80287c:	89 ca                	mov    %ecx,%edx
  80287e:	83 c4 1c             	add    $0x1c,%esp
  802881:	5b                   	pop    %ebx
  802882:	5e                   	pop    %esi
  802883:	5f                   	pop    %edi
  802884:	5d                   	pop    %ebp
  802885:	c3                   	ret    
  802886:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80288d:	8d 76 00             	lea    0x0(%esi),%esi
  802890:	89 fd                	mov    %edi,%ebp
  802892:	85 ff                	test   %edi,%edi
  802894:	75 0b                	jne    8028a1 <__umoddi3+0x91>
  802896:	b8 01 00 00 00       	mov    $0x1,%eax
  80289b:	31 d2                	xor    %edx,%edx
  80289d:	f7 f7                	div    %edi
  80289f:	89 c5                	mov    %eax,%ebp
  8028a1:	89 d8                	mov    %ebx,%eax
  8028a3:	31 d2                	xor    %edx,%edx
  8028a5:	f7 f5                	div    %ebp
  8028a7:	89 f0                	mov    %esi,%eax
  8028a9:	f7 f5                	div    %ebp
  8028ab:	89 d0                	mov    %edx,%eax
  8028ad:	31 d2                	xor    %edx,%edx
  8028af:	eb 8c                	jmp    80283d <__umoddi3+0x2d>
  8028b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028b8:	89 e9                	mov    %ebp,%ecx
  8028ba:	ba 20 00 00 00       	mov    $0x20,%edx
  8028bf:	29 ea                	sub    %ebp,%edx
  8028c1:	d3 e0                	shl    %cl,%eax
  8028c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8028c7:	89 d1                	mov    %edx,%ecx
  8028c9:	89 f8                	mov    %edi,%eax
  8028cb:	d3 e8                	shr    %cl,%eax
  8028cd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8028d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8028d5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8028d9:	09 c1                	or     %eax,%ecx
  8028db:	89 d8                	mov    %ebx,%eax
  8028dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8028e1:	89 e9                	mov    %ebp,%ecx
  8028e3:	d3 e7                	shl    %cl,%edi
  8028e5:	89 d1                	mov    %edx,%ecx
  8028e7:	d3 e8                	shr    %cl,%eax
  8028e9:	89 e9                	mov    %ebp,%ecx
  8028eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028ef:	d3 e3                	shl    %cl,%ebx
  8028f1:	89 c7                	mov    %eax,%edi
  8028f3:	89 d1                	mov    %edx,%ecx
  8028f5:	89 f0                	mov    %esi,%eax
  8028f7:	d3 e8                	shr    %cl,%eax
  8028f9:	89 e9                	mov    %ebp,%ecx
  8028fb:	89 fa                	mov    %edi,%edx
  8028fd:	d3 e6                	shl    %cl,%esi
  8028ff:	09 d8                	or     %ebx,%eax
  802901:	f7 74 24 08          	divl   0x8(%esp)
  802905:	89 d1                	mov    %edx,%ecx
  802907:	89 f3                	mov    %esi,%ebx
  802909:	f7 64 24 0c          	mull   0xc(%esp)
  80290d:	89 c6                	mov    %eax,%esi
  80290f:	89 d7                	mov    %edx,%edi
  802911:	39 d1                	cmp    %edx,%ecx
  802913:	72 06                	jb     80291b <__umoddi3+0x10b>
  802915:	75 10                	jne    802927 <__umoddi3+0x117>
  802917:	39 c3                	cmp    %eax,%ebx
  802919:	73 0c                	jae    802927 <__umoddi3+0x117>
  80291b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80291f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802923:	89 d7                	mov    %edx,%edi
  802925:	89 c6                	mov    %eax,%esi
  802927:	89 ca                	mov    %ecx,%edx
  802929:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80292e:	29 f3                	sub    %esi,%ebx
  802930:	19 fa                	sbb    %edi,%edx
  802932:	89 d0                	mov    %edx,%eax
  802934:	d3 e0                	shl    %cl,%eax
  802936:	89 e9                	mov    %ebp,%ecx
  802938:	d3 eb                	shr    %cl,%ebx
  80293a:	d3 ea                	shr    %cl,%edx
  80293c:	09 d8                	or     %ebx,%eax
  80293e:	83 c4 1c             	add    $0x1c,%esp
  802941:	5b                   	pop    %ebx
  802942:	5e                   	pop    %esi
  802943:	5f                   	pop    %edi
  802944:	5d                   	pop    %ebp
  802945:	c3                   	ret    
  802946:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80294d:	8d 76 00             	lea    0x0(%esi),%esi
  802950:	29 fe                	sub    %edi,%esi
  802952:	19 c3                	sbb    %eax,%ebx
  802954:	89 f2                	mov    %esi,%edx
  802956:	89 d9                	mov    %ebx,%ecx
  802958:	e9 1d ff ff ff       	jmp    80287a <__umoddi3+0x6a>
