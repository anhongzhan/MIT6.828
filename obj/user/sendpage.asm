
obj/user/sendpage:     file format elf32-i386


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
  80003d:	e8 5a 0f 00 00       	call   800f9c <fork>
  800042:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800045:	85 c0                	test   %eax,%eax
  800047:	0f 84 a5 00 00 00    	je     8000f2 <umain+0xbf>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
		return;
	}

	// Parent
	sys_page_alloc(thisenv->env_id, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  80004d:	a1 0c 20 80 00       	mov    0x80200c,%eax
  800052:	8b 40 48             	mov    0x48(%eax),%eax
  800055:	83 ec 04             	sub    $0x4,%esp
  800058:	6a 07                	push   $0x7
  80005a:	68 00 00 a0 00       	push   $0xa00000
  80005f:	50                   	push   %eax
  800060:	e8 8c 0c 00 00       	call   800cf1 <sys_page_alloc>
	memcpy(TEMP_ADDR, str1, strlen(str1) + 1);
  800065:	83 c4 04             	add    $0x4,%esp
  800068:	ff 35 04 20 80 00    	pushl  0x802004
  80006e:	e8 f9 07 00 00       	call   80086c <strlen>
  800073:	83 c4 0c             	add    $0xc,%esp
  800076:	83 c0 01             	add    $0x1,%eax
  800079:	50                   	push   %eax
  80007a:	ff 35 04 20 80 00    	pushl  0x802004
  800080:	68 00 00 a0 00       	push   $0xa00000
  800085:	e8 41 0a 00 00       	call   800acb <memcpy>
	ipc_send(who, 0, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  80008a:	6a 07                	push   $0x7
  80008c:	68 00 00 a0 00       	push   $0xa00000
  800091:	6a 00                	push   $0x0
  800093:	ff 75 f4             	pushl  -0xc(%ebp)
  800096:	e8 71 11 00 00       	call   80120c <ipc_send>

	ipc_recv(&who, TEMP_ADDR, 0);
  80009b:	83 c4 1c             	add    $0x1c,%esp
  80009e:	6a 00                	push   $0x0
  8000a0:	68 00 00 a0 00       	push   $0xa00000
  8000a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000a8:	50                   	push   %eax
  8000a9:	e8 d9 10 00 00       	call   801187 <ipc_recv>
	cprintf("%x got message: %s\n", who, TEMP_ADDR);
  8000ae:	83 c4 0c             	add    $0xc,%esp
  8000b1:	68 00 00 a0 00       	push   $0xa00000
  8000b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b9:	68 00 16 80 00       	push   $0x801600
  8000be:	e8 e2 01 00 00       	call   8002a5 <cprintf>
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
  8000c3:	83 c4 04             	add    $0x4,%esp
  8000c6:	ff 35 00 20 80 00    	pushl  0x802000
  8000cc:	e8 9b 07 00 00       	call   80086c <strlen>
  8000d1:	83 c4 0c             	add    $0xc,%esp
  8000d4:	50                   	push   %eax
  8000d5:	ff 35 00 20 80 00    	pushl  0x802000
  8000db:	68 00 00 a0 00       	push   $0xa00000
  8000e0:	e8 b3 08 00 00       	call   800998 <strncmp>
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
  800100:	e8 82 10 00 00       	call   801187 <ipc_recv>
		cprintf("%x got message: %s\n", who, TEMP_ADDR_CHILD);
  800105:	83 c4 0c             	add    $0xc,%esp
  800108:	68 00 00 b0 00       	push   $0xb00000
  80010d:	ff 75 f4             	pushl  -0xc(%ebp)
  800110:	68 00 16 80 00       	push   $0x801600
  800115:	e8 8b 01 00 00       	call   8002a5 <cprintf>
		if (strncmp(TEMP_ADDR_CHILD, str1, strlen(str1)) == 0)
  80011a:	83 c4 04             	add    $0x4,%esp
  80011d:	ff 35 04 20 80 00    	pushl  0x802004
  800123:	e8 44 07 00 00       	call   80086c <strlen>
  800128:	83 c4 0c             	add    $0xc,%esp
  80012b:	50                   	push   %eax
  80012c:	ff 35 04 20 80 00    	pushl  0x802004
  800132:	68 00 00 b0 00       	push   $0xb00000
  800137:	e8 5c 08 00 00       	call   800998 <strncmp>
  80013c:	83 c4 10             	add    $0x10,%esp
  80013f:	85 c0                	test   %eax,%eax
  800141:	74 3e                	je     800181 <umain+0x14e>
		memcpy(TEMP_ADDR_CHILD, str2, strlen(str2) + 1);
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	ff 35 00 20 80 00    	pushl  0x802000
  80014c:	e8 1b 07 00 00       	call   80086c <strlen>
  800151:	83 c4 0c             	add    $0xc,%esp
  800154:	83 c0 01             	add    $0x1,%eax
  800157:	50                   	push   %eax
  800158:	ff 35 00 20 80 00    	pushl  0x802000
  80015e:	68 00 00 b0 00       	push   $0xb00000
  800163:	e8 63 09 00 00       	call   800acb <memcpy>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
  800168:	6a 07                	push   $0x7
  80016a:	68 00 00 b0 00       	push   $0xb00000
  80016f:	6a 00                	push   $0x0
  800171:	ff 75 f4             	pushl  -0xc(%ebp)
  800174:	e8 93 10 00 00       	call   80120c <ipc_send>
		return;
  800179:	83 c4 20             	add    $0x20,%esp
  80017c:	e9 6f ff ff ff       	jmp    8000f0 <umain+0xbd>
			cprintf("child received correct message\n");
  800181:	83 ec 0c             	sub    $0xc,%esp
  800184:	68 14 16 80 00       	push   $0x801614
  800189:	e8 17 01 00 00       	call   8002a5 <cprintf>
  80018e:	83 c4 10             	add    $0x10,%esp
  800191:	eb b0                	jmp    800143 <umain+0x110>
		cprintf("parent received correct message\n");
  800193:	83 ec 0c             	sub    $0xc,%esp
  800196:	68 34 16 80 00       	push   $0x801634
  80019b:	e8 05 01 00 00       	call   8002a5 <cprintf>
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
  8001b7:	e8 ef 0a 00 00       	call   800cab <sys_getenvid>
  8001bc:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001c1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001c4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001c9:	a3 0c 20 80 00       	mov    %eax,0x80200c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ce:	85 db                	test   %ebx,%ebx
  8001d0:	7e 07                	jle    8001d9 <libmain+0x31>
		binaryname = argv[0];
  8001d2:	8b 06                	mov    (%esi),%eax
  8001d4:	a3 08 20 80 00       	mov    %eax,0x802008

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
  8001f9:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  8001fc:	6a 00                	push   $0x0
  8001fe:	e8 63 0a 00 00       	call   800c66 <sys_env_destroy>
}
  800203:	83 c4 10             	add    $0x10,%esp
  800206:	c9                   	leave  
  800207:	c3                   	ret    

00800208 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800208:	f3 0f 1e fb          	endbr32 
  80020c:	55                   	push   %ebp
  80020d:	89 e5                	mov    %esp,%ebp
  80020f:	53                   	push   %ebx
  800210:	83 ec 04             	sub    $0x4,%esp
  800213:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800216:	8b 13                	mov    (%ebx),%edx
  800218:	8d 42 01             	lea    0x1(%edx),%eax
  80021b:	89 03                	mov    %eax,(%ebx)
  80021d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800220:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800224:	3d ff 00 00 00       	cmp    $0xff,%eax
  800229:	74 09                	je     800234 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80022b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80022f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800232:	c9                   	leave  
  800233:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800234:	83 ec 08             	sub    $0x8,%esp
  800237:	68 ff 00 00 00       	push   $0xff
  80023c:	8d 43 08             	lea    0x8(%ebx),%eax
  80023f:	50                   	push   %eax
  800240:	e8 dc 09 00 00       	call   800c21 <sys_cputs>
		b->idx = 0;
  800245:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80024b:	83 c4 10             	add    $0x10,%esp
  80024e:	eb db                	jmp    80022b <putch+0x23>

00800250 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800250:	f3 0f 1e fb          	endbr32 
  800254:	55                   	push   %ebp
  800255:	89 e5                	mov    %esp,%ebp
  800257:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80025d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800264:	00 00 00 
	b.cnt = 0;
  800267:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80026e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800271:	ff 75 0c             	pushl  0xc(%ebp)
  800274:	ff 75 08             	pushl  0x8(%ebp)
  800277:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80027d:	50                   	push   %eax
  80027e:	68 08 02 80 00       	push   $0x800208
  800283:	e8 20 01 00 00       	call   8003a8 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800288:	83 c4 08             	add    $0x8,%esp
  80028b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800291:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800297:	50                   	push   %eax
  800298:	e8 84 09 00 00       	call   800c21 <sys_cputs>

	return b.cnt;
}
  80029d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002a3:	c9                   	leave  
  8002a4:	c3                   	ret    

008002a5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002a5:	f3 0f 1e fb          	endbr32 
  8002a9:	55                   	push   %ebp
  8002aa:	89 e5                	mov    %esp,%ebp
  8002ac:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002af:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002b2:	50                   	push   %eax
  8002b3:	ff 75 08             	pushl  0x8(%ebp)
  8002b6:	e8 95 ff ff ff       	call   800250 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002bb:	c9                   	leave  
  8002bc:	c3                   	ret    

008002bd <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002bd:	55                   	push   %ebp
  8002be:	89 e5                	mov    %esp,%ebp
  8002c0:	57                   	push   %edi
  8002c1:	56                   	push   %esi
  8002c2:	53                   	push   %ebx
  8002c3:	83 ec 1c             	sub    $0x1c,%esp
  8002c6:	89 c7                	mov    %eax,%edi
  8002c8:	89 d6                	mov    %edx,%esi
  8002ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8002cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002d0:	89 d1                	mov    %edx,%ecx
  8002d2:	89 c2                	mov    %eax,%edx
  8002d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002d7:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002da:	8b 45 10             	mov    0x10(%ebp),%eax
  8002dd:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002e3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8002ea:	39 c2                	cmp    %eax,%edx
  8002ec:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8002ef:	72 3e                	jb     80032f <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002f1:	83 ec 0c             	sub    $0xc,%esp
  8002f4:	ff 75 18             	pushl  0x18(%ebp)
  8002f7:	83 eb 01             	sub    $0x1,%ebx
  8002fa:	53                   	push   %ebx
  8002fb:	50                   	push   %eax
  8002fc:	83 ec 08             	sub    $0x8,%esp
  8002ff:	ff 75 e4             	pushl  -0x1c(%ebp)
  800302:	ff 75 e0             	pushl  -0x20(%ebp)
  800305:	ff 75 dc             	pushl  -0x24(%ebp)
  800308:	ff 75 d8             	pushl  -0x28(%ebp)
  80030b:	e8 80 10 00 00       	call   801390 <__udivdi3>
  800310:	83 c4 18             	add    $0x18,%esp
  800313:	52                   	push   %edx
  800314:	50                   	push   %eax
  800315:	89 f2                	mov    %esi,%edx
  800317:	89 f8                	mov    %edi,%eax
  800319:	e8 9f ff ff ff       	call   8002bd <printnum>
  80031e:	83 c4 20             	add    $0x20,%esp
  800321:	eb 13                	jmp    800336 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800323:	83 ec 08             	sub    $0x8,%esp
  800326:	56                   	push   %esi
  800327:	ff 75 18             	pushl  0x18(%ebp)
  80032a:	ff d7                	call   *%edi
  80032c:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80032f:	83 eb 01             	sub    $0x1,%ebx
  800332:	85 db                	test   %ebx,%ebx
  800334:	7f ed                	jg     800323 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800336:	83 ec 08             	sub    $0x8,%esp
  800339:	56                   	push   %esi
  80033a:	83 ec 04             	sub    $0x4,%esp
  80033d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800340:	ff 75 e0             	pushl  -0x20(%ebp)
  800343:	ff 75 dc             	pushl  -0x24(%ebp)
  800346:	ff 75 d8             	pushl  -0x28(%ebp)
  800349:	e8 52 11 00 00       	call   8014a0 <__umoddi3>
  80034e:	83 c4 14             	add    $0x14,%esp
  800351:	0f be 80 ac 16 80 00 	movsbl 0x8016ac(%eax),%eax
  800358:	50                   	push   %eax
  800359:	ff d7                	call   *%edi
}
  80035b:	83 c4 10             	add    $0x10,%esp
  80035e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800361:	5b                   	pop    %ebx
  800362:	5e                   	pop    %esi
  800363:	5f                   	pop    %edi
  800364:	5d                   	pop    %ebp
  800365:	c3                   	ret    

00800366 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800366:	f3 0f 1e fb          	endbr32 
  80036a:	55                   	push   %ebp
  80036b:	89 e5                	mov    %esp,%ebp
  80036d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800370:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800374:	8b 10                	mov    (%eax),%edx
  800376:	3b 50 04             	cmp    0x4(%eax),%edx
  800379:	73 0a                	jae    800385 <sprintputch+0x1f>
		*b->buf++ = ch;
  80037b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80037e:	89 08                	mov    %ecx,(%eax)
  800380:	8b 45 08             	mov    0x8(%ebp),%eax
  800383:	88 02                	mov    %al,(%edx)
}
  800385:	5d                   	pop    %ebp
  800386:	c3                   	ret    

00800387 <printfmt>:
{
  800387:	f3 0f 1e fb          	endbr32 
  80038b:	55                   	push   %ebp
  80038c:	89 e5                	mov    %esp,%ebp
  80038e:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800391:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800394:	50                   	push   %eax
  800395:	ff 75 10             	pushl  0x10(%ebp)
  800398:	ff 75 0c             	pushl  0xc(%ebp)
  80039b:	ff 75 08             	pushl  0x8(%ebp)
  80039e:	e8 05 00 00 00       	call   8003a8 <vprintfmt>
}
  8003a3:	83 c4 10             	add    $0x10,%esp
  8003a6:	c9                   	leave  
  8003a7:	c3                   	ret    

008003a8 <vprintfmt>:
{
  8003a8:	f3 0f 1e fb          	endbr32 
  8003ac:	55                   	push   %ebp
  8003ad:	89 e5                	mov    %esp,%ebp
  8003af:	57                   	push   %edi
  8003b0:	56                   	push   %esi
  8003b1:	53                   	push   %ebx
  8003b2:	83 ec 3c             	sub    $0x3c,%esp
  8003b5:	8b 75 08             	mov    0x8(%ebp),%esi
  8003b8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003bb:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003be:	e9 8e 03 00 00       	jmp    800751 <vprintfmt+0x3a9>
		padc = ' ';
  8003c3:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8003c7:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8003ce:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003d5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003dc:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003e1:	8d 47 01             	lea    0x1(%edi),%eax
  8003e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003e7:	0f b6 17             	movzbl (%edi),%edx
  8003ea:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003ed:	3c 55                	cmp    $0x55,%al
  8003ef:	0f 87 df 03 00 00    	ja     8007d4 <vprintfmt+0x42c>
  8003f5:	0f b6 c0             	movzbl %al,%eax
  8003f8:	3e ff 24 85 80 17 80 	notrack jmp *0x801780(,%eax,4)
  8003ff:	00 
  800400:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800403:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800407:	eb d8                	jmp    8003e1 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800409:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80040c:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800410:	eb cf                	jmp    8003e1 <vprintfmt+0x39>
  800412:	0f b6 d2             	movzbl %dl,%edx
  800415:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800418:	b8 00 00 00 00       	mov    $0x0,%eax
  80041d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800420:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800423:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800427:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80042a:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80042d:	83 f9 09             	cmp    $0x9,%ecx
  800430:	77 55                	ja     800487 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800432:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800435:	eb e9                	jmp    800420 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800437:	8b 45 14             	mov    0x14(%ebp),%eax
  80043a:	8b 00                	mov    (%eax),%eax
  80043c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80043f:	8b 45 14             	mov    0x14(%ebp),%eax
  800442:	8d 40 04             	lea    0x4(%eax),%eax
  800445:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800448:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80044b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80044f:	79 90                	jns    8003e1 <vprintfmt+0x39>
				width = precision, precision = -1;
  800451:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800454:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800457:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80045e:	eb 81                	jmp    8003e1 <vprintfmt+0x39>
  800460:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800463:	85 c0                	test   %eax,%eax
  800465:	ba 00 00 00 00       	mov    $0x0,%edx
  80046a:	0f 49 d0             	cmovns %eax,%edx
  80046d:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800470:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800473:	e9 69 ff ff ff       	jmp    8003e1 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800478:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80047b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800482:	e9 5a ff ff ff       	jmp    8003e1 <vprintfmt+0x39>
  800487:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80048a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80048d:	eb bc                	jmp    80044b <vprintfmt+0xa3>
			lflag++;
  80048f:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800492:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800495:	e9 47 ff ff ff       	jmp    8003e1 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80049a:	8b 45 14             	mov    0x14(%ebp),%eax
  80049d:	8d 78 04             	lea    0x4(%eax),%edi
  8004a0:	83 ec 08             	sub    $0x8,%esp
  8004a3:	53                   	push   %ebx
  8004a4:	ff 30                	pushl  (%eax)
  8004a6:	ff d6                	call   *%esi
			break;
  8004a8:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004ab:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004ae:	e9 9b 02 00 00       	jmp    80074e <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8004b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b6:	8d 78 04             	lea    0x4(%eax),%edi
  8004b9:	8b 00                	mov    (%eax),%eax
  8004bb:	99                   	cltd   
  8004bc:	31 d0                	xor    %edx,%eax
  8004be:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004c0:	83 f8 08             	cmp    $0x8,%eax
  8004c3:	7f 23                	jg     8004e8 <vprintfmt+0x140>
  8004c5:	8b 14 85 e0 18 80 00 	mov    0x8018e0(,%eax,4),%edx
  8004cc:	85 d2                	test   %edx,%edx
  8004ce:	74 18                	je     8004e8 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8004d0:	52                   	push   %edx
  8004d1:	68 cd 16 80 00       	push   $0x8016cd
  8004d6:	53                   	push   %ebx
  8004d7:	56                   	push   %esi
  8004d8:	e8 aa fe ff ff       	call   800387 <printfmt>
  8004dd:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004e0:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004e3:	e9 66 02 00 00       	jmp    80074e <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8004e8:	50                   	push   %eax
  8004e9:	68 c4 16 80 00       	push   $0x8016c4
  8004ee:	53                   	push   %ebx
  8004ef:	56                   	push   %esi
  8004f0:	e8 92 fe ff ff       	call   800387 <printfmt>
  8004f5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004f8:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004fb:	e9 4e 02 00 00       	jmp    80074e <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800500:	8b 45 14             	mov    0x14(%ebp),%eax
  800503:	83 c0 04             	add    $0x4,%eax
  800506:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800509:	8b 45 14             	mov    0x14(%ebp),%eax
  80050c:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80050e:	85 d2                	test   %edx,%edx
  800510:	b8 bd 16 80 00       	mov    $0x8016bd,%eax
  800515:	0f 45 c2             	cmovne %edx,%eax
  800518:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80051b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80051f:	7e 06                	jle    800527 <vprintfmt+0x17f>
  800521:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800525:	75 0d                	jne    800534 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  800527:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80052a:	89 c7                	mov    %eax,%edi
  80052c:	03 45 e0             	add    -0x20(%ebp),%eax
  80052f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800532:	eb 55                	jmp    800589 <vprintfmt+0x1e1>
  800534:	83 ec 08             	sub    $0x8,%esp
  800537:	ff 75 d8             	pushl  -0x28(%ebp)
  80053a:	ff 75 cc             	pushl  -0x34(%ebp)
  80053d:	e8 46 03 00 00       	call   800888 <strnlen>
  800542:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800545:	29 c2                	sub    %eax,%edx
  800547:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80054a:	83 c4 10             	add    $0x10,%esp
  80054d:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80054f:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800553:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800556:	85 ff                	test   %edi,%edi
  800558:	7e 11                	jle    80056b <vprintfmt+0x1c3>
					putch(padc, putdat);
  80055a:	83 ec 08             	sub    $0x8,%esp
  80055d:	53                   	push   %ebx
  80055e:	ff 75 e0             	pushl  -0x20(%ebp)
  800561:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800563:	83 ef 01             	sub    $0x1,%edi
  800566:	83 c4 10             	add    $0x10,%esp
  800569:	eb eb                	jmp    800556 <vprintfmt+0x1ae>
  80056b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80056e:	85 d2                	test   %edx,%edx
  800570:	b8 00 00 00 00       	mov    $0x0,%eax
  800575:	0f 49 c2             	cmovns %edx,%eax
  800578:	29 c2                	sub    %eax,%edx
  80057a:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80057d:	eb a8                	jmp    800527 <vprintfmt+0x17f>
					putch(ch, putdat);
  80057f:	83 ec 08             	sub    $0x8,%esp
  800582:	53                   	push   %ebx
  800583:	52                   	push   %edx
  800584:	ff d6                	call   *%esi
  800586:	83 c4 10             	add    $0x10,%esp
  800589:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80058c:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80058e:	83 c7 01             	add    $0x1,%edi
  800591:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800595:	0f be d0             	movsbl %al,%edx
  800598:	85 d2                	test   %edx,%edx
  80059a:	74 4b                	je     8005e7 <vprintfmt+0x23f>
  80059c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005a0:	78 06                	js     8005a8 <vprintfmt+0x200>
  8005a2:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005a6:	78 1e                	js     8005c6 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8005a8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005ac:	74 d1                	je     80057f <vprintfmt+0x1d7>
  8005ae:	0f be c0             	movsbl %al,%eax
  8005b1:	83 e8 20             	sub    $0x20,%eax
  8005b4:	83 f8 5e             	cmp    $0x5e,%eax
  8005b7:	76 c6                	jbe    80057f <vprintfmt+0x1d7>
					putch('?', putdat);
  8005b9:	83 ec 08             	sub    $0x8,%esp
  8005bc:	53                   	push   %ebx
  8005bd:	6a 3f                	push   $0x3f
  8005bf:	ff d6                	call   *%esi
  8005c1:	83 c4 10             	add    $0x10,%esp
  8005c4:	eb c3                	jmp    800589 <vprintfmt+0x1e1>
  8005c6:	89 cf                	mov    %ecx,%edi
  8005c8:	eb 0e                	jmp    8005d8 <vprintfmt+0x230>
				putch(' ', putdat);
  8005ca:	83 ec 08             	sub    $0x8,%esp
  8005cd:	53                   	push   %ebx
  8005ce:	6a 20                	push   $0x20
  8005d0:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005d2:	83 ef 01             	sub    $0x1,%edi
  8005d5:	83 c4 10             	add    $0x10,%esp
  8005d8:	85 ff                	test   %edi,%edi
  8005da:	7f ee                	jg     8005ca <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8005dc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005df:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e2:	e9 67 01 00 00       	jmp    80074e <vprintfmt+0x3a6>
  8005e7:	89 cf                	mov    %ecx,%edi
  8005e9:	eb ed                	jmp    8005d8 <vprintfmt+0x230>
	if (lflag >= 2)
  8005eb:	83 f9 01             	cmp    $0x1,%ecx
  8005ee:	7f 1b                	jg     80060b <vprintfmt+0x263>
	else if (lflag)
  8005f0:	85 c9                	test   %ecx,%ecx
  8005f2:	74 63                	je     800657 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8005f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f7:	8b 00                	mov    (%eax),%eax
  8005f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005fc:	99                   	cltd   
  8005fd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800600:	8b 45 14             	mov    0x14(%ebp),%eax
  800603:	8d 40 04             	lea    0x4(%eax),%eax
  800606:	89 45 14             	mov    %eax,0x14(%ebp)
  800609:	eb 17                	jmp    800622 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  80060b:	8b 45 14             	mov    0x14(%ebp),%eax
  80060e:	8b 50 04             	mov    0x4(%eax),%edx
  800611:	8b 00                	mov    (%eax),%eax
  800613:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800616:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800619:	8b 45 14             	mov    0x14(%ebp),%eax
  80061c:	8d 40 08             	lea    0x8(%eax),%eax
  80061f:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800622:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800625:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800628:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80062d:	85 c9                	test   %ecx,%ecx
  80062f:	0f 89 ff 00 00 00    	jns    800734 <vprintfmt+0x38c>
				putch('-', putdat);
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	53                   	push   %ebx
  800639:	6a 2d                	push   $0x2d
  80063b:	ff d6                	call   *%esi
				num = -(long long) num;
  80063d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800640:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800643:	f7 da                	neg    %edx
  800645:	83 d1 00             	adc    $0x0,%ecx
  800648:	f7 d9                	neg    %ecx
  80064a:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80064d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800652:	e9 dd 00 00 00       	jmp    800734 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  800657:	8b 45 14             	mov    0x14(%ebp),%eax
  80065a:	8b 00                	mov    (%eax),%eax
  80065c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065f:	99                   	cltd   
  800660:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800663:	8b 45 14             	mov    0x14(%ebp),%eax
  800666:	8d 40 04             	lea    0x4(%eax),%eax
  800669:	89 45 14             	mov    %eax,0x14(%ebp)
  80066c:	eb b4                	jmp    800622 <vprintfmt+0x27a>
	if (lflag >= 2)
  80066e:	83 f9 01             	cmp    $0x1,%ecx
  800671:	7f 1e                	jg     800691 <vprintfmt+0x2e9>
	else if (lflag)
  800673:	85 c9                	test   %ecx,%ecx
  800675:	74 32                	je     8006a9 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800677:	8b 45 14             	mov    0x14(%ebp),%eax
  80067a:	8b 10                	mov    (%eax),%edx
  80067c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800681:	8d 40 04             	lea    0x4(%eax),%eax
  800684:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800687:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  80068c:	e9 a3 00 00 00       	jmp    800734 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800691:	8b 45 14             	mov    0x14(%ebp),%eax
  800694:	8b 10                	mov    (%eax),%edx
  800696:	8b 48 04             	mov    0x4(%eax),%ecx
  800699:	8d 40 08             	lea    0x8(%eax),%eax
  80069c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80069f:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8006a4:	e9 8b 00 00 00       	jmp    800734 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ac:	8b 10                	mov    (%eax),%edx
  8006ae:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b3:	8d 40 04             	lea    0x4(%eax),%eax
  8006b6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006b9:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8006be:	eb 74                	jmp    800734 <vprintfmt+0x38c>
	if (lflag >= 2)
  8006c0:	83 f9 01             	cmp    $0x1,%ecx
  8006c3:	7f 1b                	jg     8006e0 <vprintfmt+0x338>
	else if (lflag)
  8006c5:	85 c9                	test   %ecx,%ecx
  8006c7:	74 2c                	je     8006f5 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8006c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cc:	8b 10                	mov    (%eax),%edx
  8006ce:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006d3:	8d 40 04             	lea    0x4(%eax),%eax
  8006d6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006d9:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8006de:	eb 54                	jmp    800734 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8006e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e3:	8b 10                	mov    (%eax),%edx
  8006e5:	8b 48 04             	mov    0x4(%eax),%ecx
  8006e8:	8d 40 08             	lea    0x8(%eax),%eax
  8006eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006ee:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  8006f3:	eb 3f                	jmp    800734 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f8:	8b 10                	mov    (%eax),%edx
  8006fa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ff:	8d 40 04             	lea    0x4(%eax),%eax
  800702:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800705:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  80070a:	eb 28                	jmp    800734 <vprintfmt+0x38c>
			putch('0', putdat);
  80070c:	83 ec 08             	sub    $0x8,%esp
  80070f:	53                   	push   %ebx
  800710:	6a 30                	push   $0x30
  800712:	ff d6                	call   *%esi
			putch('x', putdat);
  800714:	83 c4 08             	add    $0x8,%esp
  800717:	53                   	push   %ebx
  800718:	6a 78                	push   $0x78
  80071a:	ff d6                	call   *%esi
			num = (unsigned long long)
  80071c:	8b 45 14             	mov    0x14(%ebp),%eax
  80071f:	8b 10                	mov    (%eax),%edx
  800721:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800726:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800729:	8d 40 04             	lea    0x4(%eax),%eax
  80072c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80072f:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800734:	83 ec 0c             	sub    $0xc,%esp
  800737:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80073b:	57                   	push   %edi
  80073c:	ff 75 e0             	pushl  -0x20(%ebp)
  80073f:	50                   	push   %eax
  800740:	51                   	push   %ecx
  800741:	52                   	push   %edx
  800742:	89 da                	mov    %ebx,%edx
  800744:	89 f0                	mov    %esi,%eax
  800746:	e8 72 fb ff ff       	call   8002bd <printnum>
			break;
  80074b:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80074e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800751:	83 c7 01             	add    $0x1,%edi
  800754:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800758:	83 f8 25             	cmp    $0x25,%eax
  80075b:	0f 84 62 fc ff ff    	je     8003c3 <vprintfmt+0x1b>
			if (ch == '\0')
  800761:	85 c0                	test   %eax,%eax
  800763:	0f 84 8b 00 00 00    	je     8007f4 <vprintfmt+0x44c>
			putch(ch, putdat);
  800769:	83 ec 08             	sub    $0x8,%esp
  80076c:	53                   	push   %ebx
  80076d:	50                   	push   %eax
  80076e:	ff d6                	call   *%esi
  800770:	83 c4 10             	add    $0x10,%esp
  800773:	eb dc                	jmp    800751 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800775:	83 f9 01             	cmp    $0x1,%ecx
  800778:	7f 1b                	jg     800795 <vprintfmt+0x3ed>
	else if (lflag)
  80077a:	85 c9                	test   %ecx,%ecx
  80077c:	74 2c                	je     8007aa <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  80077e:	8b 45 14             	mov    0x14(%ebp),%eax
  800781:	8b 10                	mov    (%eax),%edx
  800783:	b9 00 00 00 00       	mov    $0x0,%ecx
  800788:	8d 40 04             	lea    0x4(%eax),%eax
  80078b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80078e:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800793:	eb 9f                	jmp    800734 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800795:	8b 45 14             	mov    0x14(%ebp),%eax
  800798:	8b 10                	mov    (%eax),%edx
  80079a:	8b 48 04             	mov    0x4(%eax),%ecx
  80079d:	8d 40 08             	lea    0x8(%eax),%eax
  8007a0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007a3:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8007a8:	eb 8a                	jmp    800734 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8007aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ad:	8b 10                	mov    (%eax),%edx
  8007af:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007b4:	8d 40 04             	lea    0x4(%eax),%eax
  8007b7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ba:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8007bf:	e9 70 ff ff ff       	jmp    800734 <vprintfmt+0x38c>
			putch(ch, putdat);
  8007c4:	83 ec 08             	sub    $0x8,%esp
  8007c7:	53                   	push   %ebx
  8007c8:	6a 25                	push   $0x25
  8007ca:	ff d6                	call   *%esi
			break;
  8007cc:	83 c4 10             	add    $0x10,%esp
  8007cf:	e9 7a ff ff ff       	jmp    80074e <vprintfmt+0x3a6>
			putch('%', putdat);
  8007d4:	83 ec 08             	sub    $0x8,%esp
  8007d7:	53                   	push   %ebx
  8007d8:	6a 25                	push   $0x25
  8007da:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007dc:	83 c4 10             	add    $0x10,%esp
  8007df:	89 f8                	mov    %edi,%eax
  8007e1:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007e5:	74 05                	je     8007ec <vprintfmt+0x444>
  8007e7:	83 e8 01             	sub    $0x1,%eax
  8007ea:	eb f5                	jmp    8007e1 <vprintfmt+0x439>
  8007ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007ef:	e9 5a ff ff ff       	jmp    80074e <vprintfmt+0x3a6>
}
  8007f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007f7:	5b                   	pop    %ebx
  8007f8:	5e                   	pop    %esi
  8007f9:	5f                   	pop    %edi
  8007fa:	5d                   	pop    %ebp
  8007fb:	c3                   	ret    

008007fc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007fc:	f3 0f 1e fb          	endbr32 
  800800:	55                   	push   %ebp
  800801:	89 e5                	mov    %esp,%ebp
  800803:	83 ec 18             	sub    $0x18,%esp
  800806:	8b 45 08             	mov    0x8(%ebp),%eax
  800809:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80080c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80080f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800813:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800816:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80081d:	85 c0                	test   %eax,%eax
  80081f:	74 26                	je     800847 <vsnprintf+0x4b>
  800821:	85 d2                	test   %edx,%edx
  800823:	7e 22                	jle    800847 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800825:	ff 75 14             	pushl  0x14(%ebp)
  800828:	ff 75 10             	pushl  0x10(%ebp)
  80082b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80082e:	50                   	push   %eax
  80082f:	68 66 03 80 00       	push   $0x800366
  800834:	e8 6f fb ff ff       	call   8003a8 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800839:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80083c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80083f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800842:	83 c4 10             	add    $0x10,%esp
}
  800845:	c9                   	leave  
  800846:	c3                   	ret    
		return -E_INVAL;
  800847:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80084c:	eb f7                	jmp    800845 <vsnprintf+0x49>

0080084e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80084e:	f3 0f 1e fb          	endbr32 
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
  800855:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800858:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80085b:	50                   	push   %eax
  80085c:	ff 75 10             	pushl  0x10(%ebp)
  80085f:	ff 75 0c             	pushl  0xc(%ebp)
  800862:	ff 75 08             	pushl  0x8(%ebp)
  800865:	e8 92 ff ff ff       	call   8007fc <vsnprintf>
	va_end(ap);

	return rc;
}
  80086a:	c9                   	leave  
  80086b:	c3                   	ret    

0080086c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80086c:	f3 0f 1e fb          	endbr32 
  800870:	55                   	push   %ebp
  800871:	89 e5                	mov    %esp,%ebp
  800873:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800876:	b8 00 00 00 00       	mov    $0x0,%eax
  80087b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80087f:	74 05                	je     800886 <strlen+0x1a>
		n++;
  800881:	83 c0 01             	add    $0x1,%eax
  800884:	eb f5                	jmp    80087b <strlen+0xf>
	return n;
}
  800886:	5d                   	pop    %ebp
  800887:	c3                   	ret    

00800888 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800888:	f3 0f 1e fb          	endbr32 
  80088c:	55                   	push   %ebp
  80088d:	89 e5                	mov    %esp,%ebp
  80088f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800892:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800895:	b8 00 00 00 00       	mov    $0x0,%eax
  80089a:	39 d0                	cmp    %edx,%eax
  80089c:	74 0d                	je     8008ab <strnlen+0x23>
  80089e:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008a2:	74 05                	je     8008a9 <strnlen+0x21>
		n++;
  8008a4:	83 c0 01             	add    $0x1,%eax
  8008a7:	eb f1                	jmp    80089a <strnlen+0x12>
  8008a9:	89 c2                	mov    %eax,%edx
	return n;
}
  8008ab:	89 d0                	mov    %edx,%eax
  8008ad:	5d                   	pop    %ebp
  8008ae:	c3                   	ret    

008008af <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008af:	f3 0f 1e fb          	endbr32 
  8008b3:	55                   	push   %ebp
  8008b4:	89 e5                	mov    %esp,%ebp
  8008b6:	53                   	push   %ebx
  8008b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ba:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c2:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8008c6:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8008c9:	83 c0 01             	add    $0x1,%eax
  8008cc:	84 d2                	test   %dl,%dl
  8008ce:	75 f2                	jne    8008c2 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8008d0:	89 c8                	mov    %ecx,%eax
  8008d2:	5b                   	pop    %ebx
  8008d3:	5d                   	pop    %ebp
  8008d4:	c3                   	ret    

008008d5 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008d5:	f3 0f 1e fb          	endbr32 
  8008d9:	55                   	push   %ebp
  8008da:	89 e5                	mov    %esp,%ebp
  8008dc:	53                   	push   %ebx
  8008dd:	83 ec 10             	sub    $0x10,%esp
  8008e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008e3:	53                   	push   %ebx
  8008e4:	e8 83 ff ff ff       	call   80086c <strlen>
  8008e9:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008ec:	ff 75 0c             	pushl  0xc(%ebp)
  8008ef:	01 d8                	add    %ebx,%eax
  8008f1:	50                   	push   %eax
  8008f2:	e8 b8 ff ff ff       	call   8008af <strcpy>
	return dst;
}
  8008f7:	89 d8                	mov    %ebx,%eax
  8008f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008fc:	c9                   	leave  
  8008fd:	c3                   	ret    

008008fe <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008fe:	f3 0f 1e fb          	endbr32 
  800902:	55                   	push   %ebp
  800903:	89 e5                	mov    %esp,%ebp
  800905:	56                   	push   %esi
  800906:	53                   	push   %ebx
  800907:	8b 75 08             	mov    0x8(%ebp),%esi
  80090a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090d:	89 f3                	mov    %esi,%ebx
  80090f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800912:	89 f0                	mov    %esi,%eax
  800914:	39 d8                	cmp    %ebx,%eax
  800916:	74 11                	je     800929 <strncpy+0x2b>
		*dst++ = *src;
  800918:	83 c0 01             	add    $0x1,%eax
  80091b:	0f b6 0a             	movzbl (%edx),%ecx
  80091e:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800921:	80 f9 01             	cmp    $0x1,%cl
  800924:	83 da ff             	sbb    $0xffffffff,%edx
  800927:	eb eb                	jmp    800914 <strncpy+0x16>
	}
	return ret;
}
  800929:	89 f0                	mov    %esi,%eax
  80092b:	5b                   	pop    %ebx
  80092c:	5e                   	pop    %esi
  80092d:	5d                   	pop    %ebp
  80092e:	c3                   	ret    

0080092f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80092f:	f3 0f 1e fb          	endbr32 
  800933:	55                   	push   %ebp
  800934:	89 e5                	mov    %esp,%ebp
  800936:	56                   	push   %esi
  800937:	53                   	push   %ebx
  800938:	8b 75 08             	mov    0x8(%ebp),%esi
  80093b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80093e:	8b 55 10             	mov    0x10(%ebp),%edx
  800941:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800943:	85 d2                	test   %edx,%edx
  800945:	74 21                	je     800968 <strlcpy+0x39>
  800947:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80094b:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80094d:	39 c2                	cmp    %eax,%edx
  80094f:	74 14                	je     800965 <strlcpy+0x36>
  800951:	0f b6 19             	movzbl (%ecx),%ebx
  800954:	84 db                	test   %bl,%bl
  800956:	74 0b                	je     800963 <strlcpy+0x34>
			*dst++ = *src++;
  800958:	83 c1 01             	add    $0x1,%ecx
  80095b:	83 c2 01             	add    $0x1,%edx
  80095e:	88 5a ff             	mov    %bl,-0x1(%edx)
  800961:	eb ea                	jmp    80094d <strlcpy+0x1e>
  800963:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800965:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800968:	29 f0                	sub    %esi,%eax
}
  80096a:	5b                   	pop    %ebx
  80096b:	5e                   	pop    %esi
  80096c:	5d                   	pop    %ebp
  80096d:	c3                   	ret    

0080096e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80096e:	f3 0f 1e fb          	endbr32 
  800972:	55                   	push   %ebp
  800973:	89 e5                	mov    %esp,%ebp
  800975:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800978:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80097b:	0f b6 01             	movzbl (%ecx),%eax
  80097e:	84 c0                	test   %al,%al
  800980:	74 0c                	je     80098e <strcmp+0x20>
  800982:	3a 02                	cmp    (%edx),%al
  800984:	75 08                	jne    80098e <strcmp+0x20>
		p++, q++;
  800986:	83 c1 01             	add    $0x1,%ecx
  800989:	83 c2 01             	add    $0x1,%edx
  80098c:	eb ed                	jmp    80097b <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80098e:	0f b6 c0             	movzbl %al,%eax
  800991:	0f b6 12             	movzbl (%edx),%edx
  800994:	29 d0                	sub    %edx,%eax
}
  800996:	5d                   	pop    %ebp
  800997:	c3                   	ret    

00800998 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800998:	f3 0f 1e fb          	endbr32 
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	53                   	push   %ebx
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a6:	89 c3                	mov    %eax,%ebx
  8009a8:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009ab:	eb 06                	jmp    8009b3 <strncmp+0x1b>
		n--, p++, q++;
  8009ad:	83 c0 01             	add    $0x1,%eax
  8009b0:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009b3:	39 d8                	cmp    %ebx,%eax
  8009b5:	74 16                	je     8009cd <strncmp+0x35>
  8009b7:	0f b6 08             	movzbl (%eax),%ecx
  8009ba:	84 c9                	test   %cl,%cl
  8009bc:	74 04                	je     8009c2 <strncmp+0x2a>
  8009be:	3a 0a                	cmp    (%edx),%cl
  8009c0:	74 eb                	je     8009ad <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009c2:	0f b6 00             	movzbl (%eax),%eax
  8009c5:	0f b6 12             	movzbl (%edx),%edx
  8009c8:	29 d0                	sub    %edx,%eax
}
  8009ca:	5b                   	pop    %ebx
  8009cb:	5d                   	pop    %ebp
  8009cc:	c3                   	ret    
		return 0;
  8009cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d2:	eb f6                	jmp    8009ca <strncmp+0x32>

008009d4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009d4:	f3 0f 1e fb          	endbr32 
  8009d8:	55                   	push   %ebp
  8009d9:	89 e5                	mov    %esp,%ebp
  8009db:	8b 45 08             	mov    0x8(%ebp),%eax
  8009de:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009e2:	0f b6 10             	movzbl (%eax),%edx
  8009e5:	84 d2                	test   %dl,%dl
  8009e7:	74 09                	je     8009f2 <strchr+0x1e>
		if (*s == c)
  8009e9:	38 ca                	cmp    %cl,%dl
  8009eb:	74 0a                	je     8009f7 <strchr+0x23>
	for (; *s; s++)
  8009ed:	83 c0 01             	add    $0x1,%eax
  8009f0:	eb f0                	jmp    8009e2 <strchr+0xe>
			return (char *) s;
	return 0;
  8009f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009f7:	5d                   	pop    %ebp
  8009f8:	c3                   	ret    

008009f9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009f9:	f3 0f 1e fb          	endbr32 
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	8b 45 08             	mov    0x8(%ebp),%eax
  800a03:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a07:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a0a:	38 ca                	cmp    %cl,%dl
  800a0c:	74 09                	je     800a17 <strfind+0x1e>
  800a0e:	84 d2                	test   %dl,%dl
  800a10:	74 05                	je     800a17 <strfind+0x1e>
	for (; *s; s++)
  800a12:	83 c0 01             	add    $0x1,%eax
  800a15:	eb f0                	jmp    800a07 <strfind+0xe>
			break;
	return (char *) s;
}
  800a17:	5d                   	pop    %ebp
  800a18:	c3                   	ret    

00800a19 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a19:	f3 0f 1e fb          	endbr32 
  800a1d:	55                   	push   %ebp
  800a1e:	89 e5                	mov    %esp,%ebp
  800a20:	57                   	push   %edi
  800a21:	56                   	push   %esi
  800a22:	53                   	push   %ebx
  800a23:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a26:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a29:	85 c9                	test   %ecx,%ecx
  800a2b:	74 31                	je     800a5e <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a2d:	89 f8                	mov    %edi,%eax
  800a2f:	09 c8                	or     %ecx,%eax
  800a31:	a8 03                	test   $0x3,%al
  800a33:	75 23                	jne    800a58 <memset+0x3f>
		c &= 0xFF;
  800a35:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a39:	89 d3                	mov    %edx,%ebx
  800a3b:	c1 e3 08             	shl    $0x8,%ebx
  800a3e:	89 d0                	mov    %edx,%eax
  800a40:	c1 e0 18             	shl    $0x18,%eax
  800a43:	89 d6                	mov    %edx,%esi
  800a45:	c1 e6 10             	shl    $0x10,%esi
  800a48:	09 f0                	or     %esi,%eax
  800a4a:	09 c2                	or     %eax,%edx
  800a4c:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a4e:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a51:	89 d0                	mov    %edx,%eax
  800a53:	fc                   	cld    
  800a54:	f3 ab                	rep stos %eax,%es:(%edi)
  800a56:	eb 06                	jmp    800a5e <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5b:	fc                   	cld    
  800a5c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a5e:	89 f8                	mov    %edi,%eax
  800a60:	5b                   	pop    %ebx
  800a61:	5e                   	pop    %esi
  800a62:	5f                   	pop    %edi
  800a63:	5d                   	pop    %ebp
  800a64:	c3                   	ret    

00800a65 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a65:	f3 0f 1e fb          	endbr32 
  800a69:	55                   	push   %ebp
  800a6a:	89 e5                	mov    %esp,%ebp
  800a6c:	57                   	push   %edi
  800a6d:	56                   	push   %esi
  800a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a71:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a74:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a77:	39 c6                	cmp    %eax,%esi
  800a79:	73 32                	jae    800aad <memmove+0x48>
  800a7b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a7e:	39 c2                	cmp    %eax,%edx
  800a80:	76 2b                	jbe    800aad <memmove+0x48>
		s += n;
		d += n;
  800a82:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a85:	89 fe                	mov    %edi,%esi
  800a87:	09 ce                	or     %ecx,%esi
  800a89:	09 d6                	or     %edx,%esi
  800a8b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a91:	75 0e                	jne    800aa1 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a93:	83 ef 04             	sub    $0x4,%edi
  800a96:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a99:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a9c:	fd                   	std    
  800a9d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a9f:	eb 09                	jmp    800aaa <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aa1:	83 ef 01             	sub    $0x1,%edi
  800aa4:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800aa7:	fd                   	std    
  800aa8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800aaa:	fc                   	cld    
  800aab:	eb 1a                	jmp    800ac7 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aad:	89 c2                	mov    %eax,%edx
  800aaf:	09 ca                	or     %ecx,%edx
  800ab1:	09 f2                	or     %esi,%edx
  800ab3:	f6 c2 03             	test   $0x3,%dl
  800ab6:	75 0a                	jne    800ac2 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ab8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800abb:	89 c7                	mov    %eax,%edi
  800abd:	fc                   	cld    
  800abe:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ac0:	eb 05                	jmp    800ac7 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800ac2:	89 c7                	mov    %eax,%edi
  800ac4:	fc                   	cld    
  800ac5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ac7:	5e                   	pop    %esi
  800ac8:	5f                   	pop    %edi
  800ac9:	5d                   	pop    %ebp
  800aca:	c3                   	ret    

00800acb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800acb:	f3 0f 1e fb          	endbr32 
  800acf:	55                   	push   %ebp
  800ad0:	89 e5                	mov    %esp,%ebp
  800ad2:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ad5:	ff 75 10             	pushl  0x10(%ebp)
  800ad8:	ff 75 0c             	pushl  0xc(%ebp)
  800adb:	ff 75 08             	pushl  0x8(%ebp)
  800ade:	e8 82 ff ff ff       	call   800a65 <memmove>
}
  800ae3:	c9                   	leave  
  800ae4:	c3                   	ret    

00800ae5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ae5:	f3 0f 1e fb          	endbr32 
  800ae9:	55                   	push   %ebp
  800aea:	89 e5                	mov    %esp,%ebp
  800aec:	56                   	push   %esi
  800aed:	53                   	push   %ebx
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af4:	89 c6                	mov    %eax,%esi
  800af6:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800af9:	39 f0                	cmp    %esi,%eax
  800afb:	74 1c                	je     800b19 <memcmp+0x34>
		if (*s1 != *s2)
  800afd:	0f b6 08             	movzbl (%eax),%ecx
  800b00:	0f b6 1a             	movzbl (%edx),%ebx
  800b03:	38 d9                	cmp    %bl,%cl
  800b05:	75 08                	jne    800b0f <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b07:	83 c0 01             	add    $0x1,%eax
  800b0a:	83 c2 01             	add    $0x1,%edx
  800b0d:	eb ea                	jmp    800af9 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800b0f:	0f b6 c1             	movzbl %cl,%eax
  800b12:	0f b6 db             	movzbl %bl,%ebx
  800b15:	29 d8                	sub    %ebx,%eax
  800b17:	eb 05                	jmp    800b1e <memcmp+0x39>
	}

	return 0;
  800b19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b1e:	5b                   	pop    %ebx
  800b1f:	5e                   	pop    %esi
  800b20:	5d                   	pop    %ebp
  800b21:	c3                   	ret    

00800b22 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b22:	f3 0f 1e fb          	endbr32 
  800b26:	55                   	push   %ebp
  800b27:	89 e5                	mov    %esp,%ebp
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b2f:	89 c2                	mov    %eax,%edx
  800b31:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b34:	39 d0                	cmp    %edx,%eax
  800b36:	73 09                	jae    800b41 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b38:	38 08                	cmp    %cl,(%eax)
  800b3a:	74 05                	je     800b41 <memfind+0x1f>
	for (; s < ends; s++)
  800b3c:	83 c0 01             	add    $0x1,%eax
  800b3f:	eb f3                	jmp    800b34 <memfind+0x12>
			break;
	return (void *) s;
}
  800b41:	5d                   	pop    %ebp
  800b42:	c3                   	ret    

00800b43 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b43:	f3 0f 1e fb          	endbr32 
  800b47:	55                   	push   %ebp
  800b48:	89 e5                	mov    %esp,%ebp
  800b4a:	57                   	push   %edi
  800b4b:	56                   	push   %esi
  800b4c:	53                   	push   %ebx
  800b4d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b50:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b53:	eb 03                	jmp    800b58 <strtol+0x15>
		s++;
  800b55:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b58:	0f b6 01             	movzbl (%ecx),%eax
  800b5b:	3c 20                	cmp    $0x20,%al
  800b5d:	74 f6                	je     800b55 <strtol+0x12>
  800b5f:	3c 09                	cmp    $0x9,%al
  800b61:	74 f2                	je     800b55 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800b63:	3c 2b                	cmp    $0x2b,%al
  800b65:	74 2a                	je     800b91 <strtol+0x4e>
	int neg = 0;
  800b67:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b6c:	3c 2d                	cmp    $0x2d,%al
  800b6e:	74 2b                	je     800b9b <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b70:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b76:	75 0f                	jne    800b87 <strtol+0x44>
  800b78:	80 39 30             	cmpb   $0x30,(%ecx)
  800b7b:	74 28                	je     800ba5 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b7d:	85 db                	test   %ebx,%ebx
  800b7f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b84:	0f 44 d8             	cmove  %eax,%ebx
  800b87:	b8 00 00 00 00       	mov    $0x0,%eax
  800b8c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b8f:	eb 46                	jmp    800bd7 <strtol+0x94>
		s++;
  800b91:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b94:	bf 00 00 00 00       	mov    $0x0,%edi
  800b99:	eb d5                	jmp    800b70 <strtol+0x2d>
		s++, neg = 1;
  800b9b:	83 c1 01             	add    $0x1,%ecx
  800b9e:	bf 01 00 00 00       	mov    $0x1,%edi
  800ba3:	eb cb                	jmp    800b70 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ba5:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ba9:	74 0e                	je     800bb9 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800bab:	85 db                	test   %ebx,%ebx
  800bad:	75 d8                	jne    800b87 <strtol+0x44>
		s++, base = 8;
  800baf:	83 c1 01             	add    $0x1,%ecx
  800bb2:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bb7:	eb ce                	jmp    800b87 <strtol+0x44>
		s += 2, base = 16;
  800bb9:	83 c1 02             	add    $0x2,%ecx
  800bbc:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bc1:	eb c4                	jmp    800b87 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800bc3:	0f be d2             	movsbl %dl,%edx
  800bc6:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bc9:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bcc:	7d 3a                	jge    800c08 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800bce:	83 c1 01             	add    $0x1,%ecx
  800bd1:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bd5:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bd7:	0f b6 11             	movzbl (%ecx),%edx
  800bda:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bdd:	89 f3                	mov    %esi,%ebx
  800bdf:	80 fb 09             	cmp    $0x9,%bl
  800be2:	76 df                	jbe    800bc3 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800be4:	8d 72 9f             	lea    -0x61(%edx),%esi
  800be7:	89 f3                	mov    %esi,%ebx
  800be9:	80 fb 19             	cmp    $0x19,%bl
  800bec:	77 08                	ja     800bf6 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800bee:	0f be d2             	movsbl %dl,%edx
  800bf1:	83 ea 57             	sub    $0x57,%edx
  800bf4:	eb d3                	jmp    800bc9 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800bf6:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bf9:	89 f3                	mov    %esi,%ebx
  800bfb:	80 fb 19             	cmp    $0x19,%bl
  800bfe:	77 08                	ja     800c08 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c00:	0f be d2             	movsbl %dl,%edx
  800c03:	83 ea 37             	sub    $0x37,%edx
  800c06:	eb c1                	jmp    800bc9 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c08:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c0c:	74 05                	je     800c13 <strtol+0xd0>
		*endptr = (char *) s;
  800c0e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c11:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c13:	89 c2                	mov    %eax,%edx
  800c15:	f7 da                	neg    %edx
  800c17:	85 ff                	test   %edi,%edi
  800c19:	0f 45 c2             	cmovne %edx,%eax
}
  800c1c:	5b                   	pop    %ebx
  800c1d:	5e                   	pop    %esi
  800c1e:	5f                   	pop    %edi
  800c1f:	5d                   	pop    %ebp
  800c20:	c3                   	ret    

00800c21 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c21:	f3 0f 1e fb          	endbr32 
  800c25:	55                   	push   %ebp
  800c26:	89 e5                	mov    %esp,%ebp
  800c28:	57                   	push   %edi
  800c29:	56                   	push   %esi
  800c2a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c2b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c30:	8b 55 08             	mov    0x8(%ebp),%edx
  800c33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c36:	89 c3                	mov    %eax,%ebx
  800c38:	89 c7                	mov    %eax,%edi
  800c3a:	89 c6                	mov    %eax,%esi
  800c3c:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c3e:	5b                   	pop    %ebx
  800c3f:	5e                   	pop    %esi
  800c40:	5f                   	pop    %edi
  800c41:	5d                   	pop    %ebp
  800c42:	c3                   	ret    

00800c43 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c43:	f3 0f 1e fb          	endbr32 
  800c47:	55                   	push   %ebp
  800c48:	89 e5                	mov    %esp,%ebp
  800c4a:	57                   	push   %edi
  800c4b:	56                   	push   %esi
  800c4c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c52:	b8 01 00 00 00       	mov    $0x1,%eax
  800c57:	89 d1                	mov    %edx,%ecx
  800c59:	89 d3                	mov    %edx,%ebx
  800c5b:	89 d7                	mov    %edx,%edi
  800c5d:	89 d6                	mov    %edx,%esi
  800c5f:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c61:	5b                   	pop    %ebx
  800c62:	5e                   	pop    %esi
  800c63:	5f                   	pop    %edi
  800c64:	5d                   	pop    %ebp
  800c65:	c3                   	ret    

00800c66 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c66:	f3 0f 1e fb          	endbr32 
  800c6a:	55                   	push   %ebp
  800c6b:	89 e5                	mov    %esp,%ebp
  800c6d:	57                   	push   %edi
  800c6e:	56                   	push   %esi
  800c6f:	53                   	push   %ebx
  800c70:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c73:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c78:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7b:	b8 03 00 00 00       	mov    $0x3,%eax
  800c80:	89 cb                	mov    %ecx,%ebx
  800c82:	89 cf                	mov    %ecx,%edi
  800c84:	89 ce                	mov    %ecx,%esi
  800c86:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c88:	85 c0                	test   %eax,%eax
  800c8a:	7f 08                	jg     800c94 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c8f:	5b                   	pop    %ebx
  800c90:	5e                   	pop    %esi
  800c91:	5f                   	pop    %edi
  800c92:	5d                   	pop    %ebp
  800c93:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c94:	83 ec 0c             	sub    $0xc,%esp
  800c97:	50                   	push   %eax
  800c98:	6a 03                	push   $0x3
  800c9a:	68 04 19 80 00       	push   $0x801904
  800c9f:	6a 23                	push   $0x23
  800ca1:	68 21 19 80 00       	push   $0x801921
  800ca6:	e8 f6 05 00 00       	call   8012a1 <_panic>

00800cab <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cab:	f3 0f 1e fb          	endbr32 
  800caf:	55                   	push   %ebp
  800cb0:	89 e5                	mov    %esp,%ebp
  800cb2:	57                   	push   %edi
  800cb3:	56                   	push   %esi
  800cb4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cb5:	ba 00 00 00 00       	mov    $0x0,%edx
  800cba:	b8 02 00 00 00       	mov    $0x2,%eax
  800cbf:	89 d1                	mov    %edx,%ecx
  800cc1:	89 d3                	mov    %edx,%ebx
  800cc3:	89 d7                	mov    %edx,%edi
  800cc5:	89 d6                	mov    %edx,%esi
  800cc7:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cc9:	5b                   	pop    %ebx
  800cca:	5e                   	pop    %esi
  800ccb:	5f                   	pop    %edi
  800ccc:	5d                   	pop    %ebp
  800ccd:	c3                   	ret    

00800cce <sys_yield>:

void
sys_yield(void)
{
  800cce:	f3 0f 1e fb          	endbr32 
  800cd2:	55                   	push   %ebp
  800cd3:	89 e5                	mov    %esp,%ebp
  800cd5:	57                   	push   %edi
  800cd6:	56                   	push   %esi
  800cd7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cd8:	ba 00 00 00 00       	mov    $0x0,%edx
  800cdd:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ce2:	89 d1                	mov    %edx,%ecx
  800ce4:	89 d3                	mov    %edx,%ebx
  800ce6:	89 d7                	mov    %edx,%edi
  800ce8:	89 d6                	mov    %edx,%esi
  800cea:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cec:	5b                   	pop    %ebx
  800ced:	5e                   	pop    %esi
  800cee:	5f                   	pop    %edi
  800cef:	5d                   	pop    %ebp
  800cf0:	c3                   	ret    

00800cf1 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cf1:	f3 0f 1e fb          	endbr32 
  800cf5:	55                   	push   %ebp
  800cf6:	89 e5                	mov    %esp,%ebp
  800cf8:	57                   	push   %edi
  800cf9:	56                   	push   %esi
  800cfa:	53                   	push   %ebx
  800cfb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cfe:	be 00 00 00 00       	mov    $0x0,%esi
  800d03:	8b 55 08             	mov    0x8(%ebp),%edx
  800d06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d09:	b8 04 00 00 00       	mov    $0x4,%eax
  800d0e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d11:	89 f7                	mov    %esi,%edi
  800d13:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d15:	85 c0                	test   %eax,%eax
  800d17:	7f 08                	jg     800d21 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800d25:	6a 04                	push   $0x4
  800d27:	68 04 19 80 00       	push   $0x801904
  800d2c:	6a 23                	push   $0x23
  800d2e:	68 21 19 80 00       	push   $0x801921
  800d33:	e8 69 05 00 00       	call   8012a1 <_panic>

00800d38 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d38:	f3 0f 1e fb          	endbr32 
  800d3c:	55                   	push   %ebp
  800d3d:	89 e5                	mov    %esp,%ebp
  800d3f:	57                   	push   %edi
  800d40:	56                   	push   %esi
  800d41:	53                   	push   %ebx
  800d42:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d45:	8b 55 08             	mov    0x8(%ebp),%edx
  800d48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4b:	b8 05 00 00 00       	mov    $0x5,%eax
  800d50:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d53:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d56:	8b 75 18             	mov    0x18(%ebp),%esi
  800d59:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d5b:	85 c0                	test   %eax,%eax
  800d5d:	7f 08                	jg     800d67 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  800d6b:	6a 05                	push   $0x5
  800d6d:	68 04 19 80 00       	push   $0x801904
  800d72:	6a 23                	push   $0x23
  800d74:	68 21 19 80 00       	push   $0x801921
  800d79:	e8 23 05 00 00       	call   8012a1 <_panic>

00800d7e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
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
  800d96:	b8 06 00 00 00       	mov    $0x6,%eax
  800d9b:	89 df                	mov    %ebx,%edi
  800d9d:	89 de                	mov    %ebx,%esi
  800d9f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da1:	85 c0                	test   %eax,%eax
  800da3:	7f 08                	jg     800dad <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  800db1:	6a 06                	push   $0x6
  800db3:	68 04 19 80 00       	push   $0x801904
  800db8:	6a 23                	push   $0x23
  800dba:	68 21 19 80 00       	push   $0x801921
  800dbf:	e8 dd 04 00 00       	call   8012a1 <_panic>

00800dc4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
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
  800ddc:	b8 08 00 00 00       	mov    $0x8,%eax
  800de1:	89 df                	mov    %ebx,%edi
  800de3:	89 de                	mov    %ebx,%esi
  800de5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de7:	85 c0                	test   %eax,%eax
  800de9:	7f 08                	jg     800df3 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  800df7:	6a 08                	push   $0x8
  800df9:	68 04 19 80 00       	push   $0x801904
  800dfe:	6a 23                	push   $0x23
  800e00:	68 21 19 80 00       	push   $0x801921
  800e05:	e8 97 04 00 00       	call   8012a1 <_panic>

00800e0a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
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
  800e22:	b8 09 00 00 00       	mov    $0x9,%eax
  800e27:	89 df                	mov    %ebx,%edi
  800e29:	89 de                	mov    %ebx,%esi
  800e2b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e2d:	85 c0                	test   %eax,%eax
  800e2f:	7f 08                	jg     800e39 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
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
  800e3d:	6a 09                	push   $0x9
  800e3f:	68 04 19 80 00       	push   $0x801904
  800e44:	6a 23                	push   $0x23
  800e46:	68 21 19 80 00       	push   $0x801921
  800e4b:	e8 51 04 00 00       	call   8012a1 <_panic>

00800e50 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e50:	f3 0f 1e fb          	endbr32 
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	57                   	push   %edi
  800e58:	56                   	push   %esi
  800e59:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e60:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e65:	be 00 00 00 00       	mov    $0x0,%esi
  800e6a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e6d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e70:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e72:	5b                   	pop    %ebx
  800e73:	5e                   	pop    %esi
  800e74:	5f                   	pop    %edi
  800e75:	5d                   	pop    %ebp
  800e76:	c3                   	ret    

00800e77 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e77:	f3 0f 1e fb          	endbr32 
  800e7b:	55                   	push   %ebp
  800e7c:	89 e5                	mov    %esp,%ebp
  800e7e:	57                   	push   %edi
  800e7f:	56                   	push   %esi
  800e80:	53                   	push   %ebx
  800e81:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e84:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e89:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8c:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e91:	89 cb                	mov    %ecx,%ebx
  800e93:	89 cf                	mov    %ecx,%edi
  800e95:	89 ce                	mov    %ecx,%esi
  800e97:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e99:	85 c0                	test   %eax,%eax
  800e9b:	7f 08                	jg     800ea5 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ea0:	5b                   	pop    %ebx
  800ea1:	5e                   	pop    %esi
  800ea2:	5f                   	pop    %edi
  800ea3:	5d                   	pop    %ebp
  800ea4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea5:	83 ec 0c             	sub    $0xc,%esp
  800ea8:	50                   	push   %eax
  800ea9:	6a 0c                	push   $0xc
  800eab:	68 04 19 80 00       	push   $0x801904
  800eb0:	6a 23                	push   $0x23
  800eb2:	68 21 19 80 00       	push   $0x801921
  800eb7:	e8 e5 03 00 00       	call   8012a1 <_panic>

00800ebc <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800ebc:	f3 0f 1e fb          	endbr32 
  800ec0:	55                   	push   %ebp
  800ec1:	89 e5                	mov    %esp,%ebp
  800ec3:	53                   	push   %ebx
  800ec4:	83 ec 04             	sub    $0x4,%esp
  800ec7:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800eca:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  800ecc:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800ed0:	74 74                	je     800f46 <pgfault+0x8a>
  800ed2:	89 d8                	mov    %ebx,%eax
  800ed4:	c1 e8 0c             	shr    $0xc,%eax
  800ed7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800ede:	f6 c4 08             	test   $0x8,%ah
  800ee1:	74 63                	je     800f46 <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800ee3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  800ee9:	83 ec 0c             	sub    $0xc,%esp
  800eec:	6a 05                	push   $0x5
  800eee:	68 00 f0 7f 00       	push   $0x7ff000
  800ef3:	6a 00                	push   $0x0
  800ef5:	53                   	push   %ebx
  800ef6:	6a 00                	push   $0x0
  800ef8:	e8 3b fe ff ff       	call   800d38 <sys_page_map>
  800efd:	83 c4 20             	add    $0x20,%esp
  800f00:	85 c0                	test   %eax,%eax
  800f02:	78 59                	js     800f5d <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  800f04:	83 ec 04             	sub    $0x4,%esp
  800f07:	6a 07                	push   $0x7
  800f09:	53                   	push   %ebx
  800f0a:	6a 00                	push   $0x0
  800f0c:	e8 e0 fd ff ff       	call   800cf1 <sys_page_alloc>
  800f11:	83 c4 10             	add    $0x10,%esp
  800f14:	85 c0                	test   %eax,%eax
  800f16:	78 5a                	js     800f72 <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  800f18:	83 ec 04             	sub    $0x4,%esp
  800f1b:	68 00 10 00 00       	push   $0x1000
  800f20:	68 00 f0 7f 00       	push   $0x7ff000
  800f25:	53                   	push   %ebx
  800f26:	e8 3a fb ff ff       	call   800a65 <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  800f2b:	83 c4 08             	add    $0x8,%esp
  800f2e:	68 00 f0 7f 00       	push   $0x7ff000
  800f33:	6a 00                	push   $0x0
  800f35:	e8 44 fe ff ff       	call   800d7e <sys_page_unmap>
  800f3a:	83 c4 10             	add    $0x10,%esp
  800f3d:	85 c0                	test   %eax,%eax
  800f3f:	78 46                	js     800f87 <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  800f41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f44:	c9                   	leave  
  800f45:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  800f46:	83 ec 04             	sub    $0x4,%esp
  800f49:	68 2f 19 80 00       	push   $0x80192f
  800f4e:	68 d3 00 00 00       	push   $0xd3
  800f53:	68 4b 19 80 00       	push   $0x80194b
  800f58:	e8 44 03 00 00       	call   8012a1 <_panic>
		panic("pgfault: %e\n", r);
  800f5d:	50                   	push   %eax
  800f5e:	68 56 19 80 00       	push   $0x801956
  800f63:	68 df 00 00 00       	push   $0xdf
  800f68:	68 4b 19 80 00       	push   $0x80194b
  800f6d:	e8 2f 03 00 00       	call   8012a1 <_panic>
		panic("pgfault: %e\n", r);
  800f72:	50                   	push   %eax
  800f73:	68 56 19 80 00       	push   $0x801956
  800f78:	68 e3 00 00 00       	push   $0xe3
  800f7d:	68 4b 19 80 00       	push   $0x80194b
  800f82:	e8 1a 03 00 00       	call   8012a1 <_panic>
		panic("pgfault: %e\n", r);
  800f87:	50                   	push   %eax
  800f88:	68 56 19 80 00       	push   $0x801956
  800f8d:	68 e9 00 00 00       	push   $0xe9
  800f92:	68 4b 19 80 00       	push   $0x80194b
  800f97:	e8 05 03 00 00       	call   8012a1 <_panic>

00800f9c <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800f9c:	f3 0f 1e fb          	endbr32 
  800fa0:	55                   	push   %ebp
  800fa1:	89 e5                	mov    %esp,%ebp
  800fa3:	57                   	push   %edi
  800fa4:	56                   	push   %esi
  800fa5:	53                   	push   %ebx
  800fa6:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  800fa9:	68 bc 0e 80 00       	push   $0x800ebc
  800fae:	e8 38 03 00 00       	call   8012eb <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800fb3:	b8 07 00 00 00       	mov    $0x7,%eax
  800fb8:	cd 30                	int    $0x30
  800fba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  800fbd:	83 c4 10             	add    $0x10,%esp
  800fc0:	85 c0                	test   %eax,%eax
  800fc2:	78 2d                	js     800ff1 <fork+0x55>
  800fc4:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800fc6:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  800fcb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fcf:	0f 85 81 00 00 00    	jne    801056 <fork+0xba>
		thisenv = &envs[ENVX(sys_getenvid())];
  800fd5:	e8 d1 fc ff ff       	call   800cab <sys_getenvid>
  800fda:	25 ff 03 00 00       	and    $0x3ff,%eax
  800fdf:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800fe2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800fe7:	a3 0c 20 80 00       	mov    %eax,0x80200c
		return 0;
  800fec:	e9 43 01 00 00       	jmp    801134 <fork+0x198>
		panic("sys_exofork: %e", envid);
  800ff1:	50                   	push   %eax
  800ff2:	68 63 19 80 00       	push   $0x801963
  800ff7:	68 26 01 00 00       	push   $0x126
  800ffc:	68 4b 19 80 00       	push   $0x80194b
  801001:	e8 9b 02 00 00       	call   8012a1 <_panic>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  801006:	c1 e6 0c             	shl    $0xc,%esi
  801009:	83 ec 0c             	sub    $0xc,%esp
  80100c:	68 05 08 00 00       	push   $0x805
  801011:	56                   	push   %esi
  801012:	57                   	push   %edi
  801013:	56                   	push   %esi
  801014:	6a 00                	push   $0x0
  801016:	e8 1d fd ff ff       	call   800d38 <sys_page_map>
  80101b:	83 c4 20             	add    $0x20,%esp
  80101e:	85 c0                	test   %eax,%eax
  801020:	0f 88 a8 00 00 00    	js     8010ce <fork+0x132>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  801026:	83 ec 0c             	sub    $0xc,%esp
  801029:	68 05 08 00 00       	push   $0x805
  80102e:	56                   	push   %esi
  80102f:	6a 00                	push   $0x0
  801031:	56                   	push   %esi
  801032:	6a 00                	push   $0x0
  801034:	e8 ff fc ff ff       	call   800d38 <sys_page_map>
  801039:	83 c4 20             	add    $0x20,%esp
  80103c:	85 c0                	test   %eax,%eax
  80103e:	0f 88 9f 00 00 00    	js     8010e3 <fork+0x147>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801044:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80104a:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801050:	0f 84 a2 00 00 00    	je     8010f8 <fork+0x15c>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  801056:	89 d8                	mov    %ebx,%eax
  801058:	c1 e8 16             	shr    $0x16,%eax
  80105b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801062:	a8 01                	test   $0x1,%al
  801064:	74 de                	je     801044 <fork+0xa8>
  801066:	89 de                	mov    %ebx,%esi
  801068:	c1 ee 0c             	shr    $0xc,%esi
  80106b:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801072:	a8 01                	test   $0x1,%al
  801074:	74 ce                	je     801044 <fork+0xa8>
  801076:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80107d:	a8 04                	test   $0x4,%al
  80107f:	74 c3                	je     801044 <fork+0xa8>
	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  801081:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801088:	a8 02                	test   $0x2,%al
  80108a:	0f 85 76 ff ff ff    	jne    801006 <fork+0x6a>
  801090:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801097:	f6 c4 08             	test   $0x8,%ah
  80109a:	0f 85 66 ff ff ff    	jne    801006 <fork+0x6a>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  8010a0:	c1 e6 0c             	shl    $0xc,%esi
  8010a3:	83 ec 0c             	sub    $0xc,%esp
  8010a6:	6a 05                	push   $0x5
  8010a8:	56                   	push   %esi
  8010a9:	57                   	push   %edi
  8010aa:	56                   	push   %esi
  8010ab:	6a 00                	push   $0x0
  8010ad:	e8 86 fc ff ff       	call   800d38 <sys_page_map>
  8010b2:	83 c4 20             	add    $0x20,%esp
  8010b5:	85 c0                	test   %eax,%eax
  8010b7:	79 8b                	jns    801044 <fork+0xa8>
		panic("duppage: %e\n", r);
  8010b9:	50                   	push   %eax
  8010ba:	68 73 19 80 00       	push   $0x801973
  8010bf:	68 08 01 00 00       	push   $0x108
  8010c4:	68 4b 19 80 00       	push   $0x80194b
  8010c9:	e8 d3 01 00 00       	call   8012a1 <_panic>
			panic("duppage: %e\n", r);
  8010ce:	50                   	push   %eax
  8010cf:	68 73 19 80 00       	push   $0x801973
  8010d4:	68 01 01 00 00       	push   $0x101
  8010d9:	68 4b 19 80 00       	push   $0x80194b
  8010de:	e8 be 01 00 00       	call   8012a1 <_panic>
			panic("duppage: %e\n", r);
  8010e3:	50                   	push   %eax
  8010e4:	68 73 19 80 00       	push   $0x801973
  8010e9:	68 05 01 00 00       	push   $0x105
  8010ee:	68 4b 19 80 00       	push   $0x80194b
  8010f3:	e8 a9 01 00 00       	call   8012a1 <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  8010f8:	83 ec 04             	sub    $0x4,%esp
  8010fb:	6a 07                	push   $0x7
  8010fd:	68 00 f0 bf ee       	push   $0xeebff000
  801102:	ff 75 e4             	pushl  -0x1c(%ebp)
  801105:	e8 e7 fb ff ff       	call   800cf1 <sys_page_alloc>
  80110a:	83 c4 10             	add    $0x10,%esp
  80110d:	85 c0                	test   %eax,%eax
  80110f:	78 2e                	js     80113f <fork+0x1a3>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801111:	83 ec 08             	sub    $0x8,%esp
  801114:	68 5e 13 80 00       	push   $0x80135e
  801119:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80111c:	57                   	push   %edi
  80111d:	e8 e8 fc ff ff       	call   800e0a <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801122:	83 c4 08             	add    $0x8,%esp
  801125:	6a 02                	push   $0x2
  801127:	57                   	push   %edi
  801128:	e8 97 fc ff ff       	call   800dc4 <sys_env_set_status>
  80112d:	83 c4 10             	add    $0x10,%esp
  801130:	85 c0                	test   %eax,%eax
  801132:	78 20                	js     801154 <fork+0x1b8>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  801134:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801137:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80113a:	5b                   	pop    %ebx
  80113b:	5e                   	pop    %esi
  80113c:	5f                   	pop    %edi
  80113d:	5d                   	pop    %ebp
  80113e:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  80113f:	50                   	push   %eax
  801140:	68 80 19 80 00       	push   $0x801980
  801145:	68 3a 01 00 00       	push   $0x13a
  80114a:	68 4b 19 80 00       	push   $0x80194b
  80114f:	e8 4d 01 00 00       	call   8012a1 <_panic>
		panic("sys_env_set_status: %e", r);
  801154:	50                   	push   %eax
  801155:	68 93 19 80 00       	push   $0x801993
  80115a:	68 3f 01 00 00       	push   $0x13f
  80115f:	68 4b 19 80 00       	push   $0x80194b
  801164:	e8 38 01 00 00       	call   8012a1 <_panic>

00801169 <sfork>:

// Challenge!
int
sfork(void)
{
  801169:	f3 0f 1e fb          	endbr32 
  80116d:	55                   	push   %ebp
  80116e:	89 e5                	mov    %esp,%ebp
  801170:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801173:	68 aa 19 80 00       	push   $0x8019aa
  801178:	68 48 01 00 00       	push   $0x148
  80117d:	68 4b 19 80 00       	push   $0x80194b
  801182:	e8 1a 01 00 00       	call   8012a1 <_panic>

00801187 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801187:	f3 0f 1e fb          	endbr32 
  80118b:	55                   	push   %ebp
  80118c:	89 e5                	mov    %esp,%ebp
  80118e:	56                   	push   %esi
  80118f:	53                   	push   %ebx
  801190:	8b 75 08             	mov    0x8(%ebp),%esi
  801193:	8b 45 0c             	mov    0xc(%ebp),%eax
  801196:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  801199:	85 c0                	test   %eax,%eax
  80119b:	74 3d                	je     8011da <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  80119d:	83 ec 0c             	sub    $0xc,%esp
  8011a0:	50                   	push   %eax
  8011a1:	e8 d1 fc ff ff       	call   800e77 <sys_ipc_recv>
  8011a6:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  8011a9:	85 f6                	test   %esi,%esi
  8011ab:	74 0b                	je     8011b8 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8011ad:	8b 15 0c 20 80 00    	mov    0x80200c,%edx
  8011b3:	8b 52 74             	mov    0x74(%edx),%edx
  8011b6:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  8011b8:	85 db                	test   %ebx,%ebx
  8011ba:	74 0b                	je     8011c7 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  8011bc:	8b 15 0c 20 80 00    	mov    0x80200c,%edx
  8011c2:	8b 52 78             	mov    0x78(%edx),%edx
  8011c5:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  8011c7:	85 c0                	test   %eax,%eax
  8011c9:	78 21                	js     8011ec <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  8011cb:	a1 0c 20 80 00       	mov    0x80200c,%eax
  8011d0:	8b 40 70             	mov    0x70(%eax),%eax
}
  8011d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011d6:	5b                   	pop    %ebx
  8011d7:	5e                   	pop    %esi
  8011d8:	5d                   	pop    %ebp
  8011d9:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  8011da:	83 ec 0c             	sub    $0xc,%esp
  8011dd:	68 00 00 c0 ee       	push   $0xeec00000
  8011e2:	e8 90 fc ff ff       	call   800e77 <sys_ipc_recv>
  8011e7:	83 c4 10             	add    $0x10,%esp
  8011ea:	eb bd                	jmp    8011a9 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  8011ec:	85 f6                	test   %esi,%esi
  8011ee:	74 10                	je     801200 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  8011f0:	85 db                	test   %ebx,%ebx
  8011f2:	75 df                	jne    8011d3 <ipc_recv+0x4c>
  8011f4:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8011fb:	00 00 00 
  8011fe:	eb d3                	jmp    8011d3 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  801200:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801207:	00 00 00 
  80120a:	eb e4                	jmp    8011f0 <ipc_recv+0x69>

0080120c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80120c:	f3 0f 1e fb          	endbr32 
  801210:	55                   	push   %ebp
  801211:	89 e5                	mov    %esp,%ebp
  801213:	57                   	push   %edi
  801214:	56                   	push   %esi
  801215:	53                   	push   %ebx
  801216:	83 ec 0c             	sub    $0xc,%esp
  801219:	8b 7d 08             	mov    0x8(%ebp),%edi
  80121c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80121f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  801222:	85 db                	test   %ebx,%ebx
  801224:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801229:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  80122c:	ff 75 14             	pushl  0x14(%ebp)
  80122f:	53                   	push   %ebx
  801230:	56                   	push   %esi
  801231:	57                   	push   %edi
  801232:	e8 19 fc ff ff       	call   800e50 <sys_ipc_try_send>
  801237:	83 c4 10             	add    $0x10,%esp
  80123a:	85 c0                	test   %eax,%eax
  80123c:	79 1e                	jns    80125c <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  80123e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801241:	75 07                	jne    80124a <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  801243:	e8 86 fa ff ff       	call   800cce <sys_yield>
  801248:	eb e2                	jmp    80122c <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  80124a:	50                   	push   %eax
  80124b:	68 c0 19 80 00       	push   $0x8019c0
  801250:	6a 59                	push   $0x59
  801252:	68 db 19 80 00       	push   $0x8019db
  801257:	e8 45 00 00 00       	call   8012a1 <_panic>
	}


}
  80125c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80125f:	5b                   	pop    %ebx
  801260:	5e                   	pop    %esi
  801261:	5f                   	pop    %edi
  801262:	5d                   	pop    %ebp
  801263:	c3                   	ret    

00801264 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801264:	f3 0f 1e fb          	endbr32 
  801268:	55                   	push   %ebp
  801269:	89 e5                	mov    %esp,%ebp
  80126b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80126e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801273:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801276:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80127c:	8b 52 50             	mov    0x50(%edx),%edx
  80127f:	39 ca                	cmp    %ecx,%edx
  801281:	74 11                	je     801294 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801283:	83 c0 01             	add    $0x1,%eax
  801286:	3d 00 04 00 00       	cmp    $0x400,%eax
  80128b:	75 e6                	jne    801273 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  80128d:	b8 00 00 00 00       	mov    $0x0,%eax
  801292:	eb 0b                	jmp    80129f <ipc_find_env+0x3b>
			return envs[i].env_id;
  801294:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801297:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80129c:	8b 40 48             	mov    0x48(%eax),%eax
}
  80129f:	5d                   	pop    %ebp
  8012a0:	c3                   	ret    

008012a1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8012a1:	f3 0f 1e fb          	endbr32 
  8012a5:	55                   	push   %ebp
  8012a6:	89 e5                	mov    %esp,%ebp
  8012a8:	56                   	push   %esi
  8012a9:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8012aa:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8012ad:	8b 35 08 20 80 00    	mov    0x802008,%esi
  8012b3:	e8 f3 f9 ff ff       	call   800cab <sys_getenvid>
  8012b8:	83 ec 0c             	sub    $0xc,%esp
  8012bb:	ff 75 0c             	pushl  0xc(%ebp)
  8012be:	ff 75 08             	pushl  0x8(%ebp)
  8012c1:	56                   	push   %esi
  8012c2:	50                   	push   %eax
  8012c3:	68 e8 19 80 00       	push   $0x8019e8
  8012c8:	e8 d8 ef ff ff       	call   8002a5 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8012cd:	83 c4 18             	add    $0x18,%esp
  8012d0:	53                   	push   %ebx
  8012d1:	ff 75 10             	pushl  0x10(%ebp)
  8012d4:	e8 77 ef ff ff       	call   800250 <vcprintf>
	cprintf("\n");
  8012d9:	c7 04 24 d9 19 80 00 	movl   $0x8019d9,(%esp)
  8012e0:	e8 c0 ef ff ff       	call   8002a5 <cprintf>
  8012e5:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8012e8:	cc                   	int3   
  8012e9:	eb fd                	jmp    8012e8 <_panic+0x47>

008012eb <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8012eb:	f3 0f 1e fb          	endbr32 
  8012ef:	55                   	push   %ebp
  8012f0:	89 e5                	mov    %esp,%ebp
  8012f2:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8012f5:	83 3d 10 20 80 00 00 	cmpl   $0x0,0x802010
  8012fc:	74 0a                	je     801308 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8012fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801301:	a3 10 20 80 00       	mov    %eax,0x802010
}
  801306:	c9                   	leave  
  801307:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  801308:	83 ec 04             	sub    $0x4,%esp
  80130b:	6a 07                	push   $0x7
  80130d:	68 00 f0 bf ee       	push   $0xeebff000
  801312:	6a 00                	push   $0x0
  801314:	e8 d8 f9 ff ff       	call   800cf1 <sys_page_alloc>
  801319:	83 c4 10             	add    $0x10,%esp
  80131c:	85 c0                	test   %eax,%eax
  80131e:	78 2a                	js     80134a <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  801320:	83 ec 08             	sub    $0x8,%esp
  801323:	68 5e 13 80 00       	push   $0x80135e
  801328:	6a 00                	push   $0x0
  80132a:	e8 db fa ff ff       	call   800e0a <sys_env_set_pgfault_upcall>
  80132f:	83 c4 10             	add    $0x10,%esp
  801332:	85 c0                	test   %eax,%eax
  801334:	79 c8                	jns    8012fe <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  801336:	83 ec 04             	sub    $0x4,%esp
  801339:	68 38 1a 80 00       	push   $0x801a38
  80133e:	6a 25                	push   $0x25
  801340:	68 70 1a 80 00       	push   $0x801a70
  801345:	e8 57 ff ff ff       	call   8012a1 <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  80134a:	83 ec 04             	sub    $0x4,%esp
  80134d:	68 0c 1a 80 00       	push   $0x801a0c
  801352:	6a 22                	push   $0x22
  801354:	68 70 1a 80 00       	push   $0x801a70
  801359:	e8 43 ff ff ff       	call   8012a1 <_panic>

0080135e <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80135e:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80135f:	a1 10 20 80 00       	mov    0x802010,%eax
	call *%eax
  801364:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801366:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  801369:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  80136d:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  801371:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  801374:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  801376:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  80137a:	83 c4 08             	add    $0x8,%esp
	popal
  80137d:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  80137e:	83 c4 04             	add    $0x4,%esp
	popfl
  801381:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  801382:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  801383:	c3                   	ret    
  801384:	66 90                	xchg   %ax,%ax
  801386:	66 90                	xchg   %ax,%ax
  801388:	66 90                	xchg   %ax,%ax
  80138a:	66 90                	xchg   %ax,%ax
  80138c:	66 90                	xchg   %ax,%ax
  80138e:	66 90                	xchg   %ax,%ax

00801390 <__udivdi3>:
  801390:	f3 0f 1e fb          	endbr32 
  801394:	55                   	push   %ebp
  801395:	57                   	push   %edi
  801396:	56                   	push   %esi
  801397:	53                   	push   %ebx
  801398:	83 ec 1c             	sub    $0x1c,%esp
  80139b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80139f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8013a3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8013a7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8013ab:	85 d2                	test   %edx,%edx
  8013ad:	75 19                	jne    8013c8 <__udivdi3+0x38>
  8013af:	39 f3                	cmp    %esi,%ebx
  8013b1:	76 4d                	jbe    801400 <__udivdi3+0x70>
  8013b3:	31 ff                	xor    %edi,%edi
  8013b5:	89 e8                	mov    %ebp,%eax
  8013b7:	89 f2                	mov    %esi,%edx
  8013b9:	f7 f3                	div    %ebx
  8013bb:	89 fa                	mov    %edi,%edx
  8013bd:	83 c4 1c             	add    $0x1c,%esp
  8013c0:	5b                   	pop    %ebx
  8013c1:	5e                   	pop    %esi
  8013c2:	5f                   	pop    %edi
  8013c3:	5d                   	pop    %ebp
  8013c4:	c3                   	ret    
  8013c5:	8d 76 00             	lea    0x0(%esi),%esi
  8013c8:	39 f2                	cmp    %esi,%edx
  8013ca:	76 14                	jbe    8013e0 <__udivdi3+0x50>
  8013cc:	31 ff                	xor    %edi,%edi
  8013ce:	31 c0                	xor    %eax,%eax
  8013d0:	89 fa                	mov    %edi,%edx
  8013d2:	83 c4 1c             	add    $0x1c,%esp
  8013d5:	5b                   	pop    %ebx
  8013d6:	5e                   	pop    %esi
  8013d7:	5f                   	pop    %edi
  8013d8:	5d                   	pop    %ebp
  8013d9:	c3                   	ret    
  8013da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8013e0:	0f bd fa             	bsr    %edx,%edi
  8013e3:	83 f7 1f             	xor    $0x1f,%edi
  8013e6:	75 48                	jne    801430 <__udivdi3+0xa0>
  8013e8:	39 f2                	cmp    %esi,%edx
  8013ea:	72 06                	jb     8013f2 <__udivdi3+0x62>
  8013ec:	31 c0                	xor    %eax,%eax
  8013ee:	39 eb                	cmp    %ebp,%ebx
  8013f0:	77 de                	ja     8013d0 <__udivdi3+0x40>
  8013f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8013f7:	eb d7                	jmp    8013d0 <__udivdi3+0x40>
  8013f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801400:	89 d9                	mov    %ebx,%ecx
  801402:	85 db                	test   %ebx,%ebx
  801404:	75 0b                	jne    801411 <__udivdi3+0x81>
  801406:	b8 01 00 00 00       	mov    $0x1,%eax
  80140b:	31 d2                	xor    %edx,%edx
  80140d:	f7 f3                	div    %ebx
  80140f:	89 c1                	mov    %eax,%ecx
  801411:	31 d2                	xor    %edx,%edx
  801413:	89 f0                	mov    %esi,%eax
  801415:	f7 f1                	div    %ecx
  801417:	89 c6                	mov    %eax,%esi
  801419:	89 e8                	mov    %ebp,%eax
  80141b:	89 f7                	mov    %esi,%edi
  80141d:	f7 f1                	div    %ecx
  80141f:	89 fa                	mov    %edi,%edx
  801421:	83 c4 1c             	add    $0x1c,%esp
  801424:	5b                   	pop    %ebx
  801425:	5e                   	pop    %esi
  801426:	5f                   	pop    %edi
  801427:	5d                   	pop    %ebp
  801428:	c3                   	ret    
  801429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801430:	89 f9                	mov    %edi,%ecx
  801432:	b8 20 00 00 00       	mov    $0x20,%eax
  801437:	29 f8                	sub    %edi,%eax
  801439:	d3 e2                	shl    %cl,%edx
  80143b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80143f:	89 c1                	mov    %eax,%ecx
  801441:	89 da                	mov    %ebx,%edx
  801443:	d3 ea                	shr    %cl,%edx
  801445:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801449:	09 d1                	or     %edx,%ecx
  80144b:	89 f2                	mov    %esi,%edx
  80144d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801451:	89 f9                	mov    %edi,%ecx
  801453:	d3 e3                	shl    %cl,%ebx
  801455:	89 c1                	mov    %eax,%ecx
  801457:	d3 ea                	shr    %cl,%edx
  801459:	89 f9                	mov    %edi,%ecx
  80145b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80145f:	89 eb                	mov    %ebp,%ebx
  801461:	d3 e6                	shl    %cl,%esi
  801463:	89 c1                	mov    %eax,%ecx
  801465:	d3 eb                	shr    %cl,%ebx
  801467:	09 de                	or     %ebx,%esi
  801469:	89 f0                	mov    %esi,%eax
  80146b:	f7 74 24 08          	divl   0x8(%esp)
  80146f:	89 d6                	mov    %edx,%esi
  801471:	89 c3                	mov    %eax,%ebx
  801473:	f7 64 24 0c          	mull   0xc(%esp)
  801477:	39 d6                	cmp    %edx,%esi
  801479:	72 15                	jb     801490 <__udivdi3+0x100>
  80147b:	89 f9                	mov    %edi,%ecx
  80147d:	d3 e5                	shl    %cl,%ebp
  80147f:	39 c5                	cmp    %eax,%ebp
  801481:	73 04                	jae    801487 <__udivdi3+0xf7>
  801483:	39 d6                	cmp    %edx,%esi
  801485:	74 09                	je     801490 <__udivdi3+0x100>
  801487:	89 d8                	mov    %ebx,%eax
  801489:	31 ff                	xor    %edi,%edi
  80148b:	e9 40 ff ff ff       	jmp    8013d0 <__udivdi3+0x40>
  801490:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801493:	31 ff                	xor    %edi,%edi
  801495:	e9 36 ff ff ff       	jmp    8013d0 <__udivdi3+0x40>
  80149a:	66 90                	xchg   %ax,%ax
  80149c:	66 90                	xchg   %ax,%ax
  80149e:	66 90                	xchg   %ax,%ax

008014a0 <__umoddi3>:
  8014a0:	f3 0f 1e fb          	endbr32 
  8014a4:	55                   	push   %ebp
  8014a5:	57                   	push   %edi
  8014a6:	56                   	push   %esi
  8014a7:	53                   	push   %ebx
  8014a8:	83 ec 1c             	sub    $0x1c,%esp
  8014ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8014af:	8b 74 24 30          	mov    0x30(%esp),%esi
  8014b3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8014b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8014bb:	85 c0                	test   %eax,%eax
  8014bd:	75 19                	jne    8014d8 <__umoddi3+0x38>
  8014bf:	39 df                	cmp    %ebx,%edi
  8014c1:	76 5d                	jbe    801520 <__umoddi3+0x80>
  8014c3:	89 f0                	mov    %esi,%eax
  8014c5:	89 da                	mov    %ebx,%edx
  8014c7:	f7 f7                	div    %edi
  8014c9:	89 d0                	mov    %edx,%eax
  8014cb:	31 d2                	xor    %edx,%edx
  8014cd:	83 c4 1c             	add    $0x1c,%esp
  8014d0:	5b                   	pop    %ebx
  8014d1:	5e                   	pop    %esi
  8014d2:	5f                   	pop    %edi
  8014d3:	5d                   	pop    %ebp
  8014d4:	c3                   	ret    
  8014d5:	8d 76 00             	lea    0x0(%esi),%esi
  8014d8:	89 f2                	mov    %esi,%edx
  8014da:	39 d8                	cmp    %ebx,%eax
  8014dc:	76 12                	jbe    8014f0 <__umoddi3+0x50>
  8014de:	89 f0                	mov    %esi,%eax
  8014e0:	89 da                	mov    %ebx,%edx
  8014e2:	83 c4 1c             	add    $0x1c,%esp
  8014e5:	5b                   	pop    %ebx
  8014e6:	5e                   	pop    %esi
  8014e7:	5f                   	pop    %edi
  8014e8:	5d                   	pop    %ebp
  8014e9:	c3                   	ret    
  8014ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8014f0:	0f bd e8             	bsr    %eax,%ebp
  8014f3:	83 f5 1f             	xor    $0x1f,%ebp
  8014f6:	75 50                	jne    801548 <__umoddi3+0xa8>
  8014f8:	39 d8                	cmp    %ebx,%eax
  8014fa:	0f 82 e0 00 00 00    	jb     8015e0 <__umoddi3+0x140>
  801500:	89 d9                	mov    %ebx,%ecx
  801502:	39 f7                	cmp    %esi,%edi
  801504:	0f 86 d6 00 00 00    	jbe    8015e0 <__umoddi3+0x140>
  80150a:	89 d0                	mov    %edx,%eax
  80150c:	89 ca                	mov    %ecx,%edx
  80150e:	83 c4 1c             	add    $0x1c,%esp
  801511:	5b                   	pop    %ebx
  801512:	5e                   	pop    %esi
  801513:	5f                   	pop    %edi
  801514:	5d                   	pop    %ebp
  801515:	c3                   	ret    
  801516:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80151d:	8d 76 00             	lea    0x0(%esi),%esi
  801520:	89 fd                	mov    %edi,%ebp
  801522:	85 ff                	test   %edi,%edi
  801524:	75 0b                	jne    801531 <__umoddi3+0x91>
  801526:	b8 01 00 00 00       	mov    $0x1,%eax
  80152b:	31 d2                	xor    %edx,%edx
  80152d:	f7 f7                	div    %edi
  80152f:	89 c5                	mov    %eax,%ebp
  801531:	89 d8                	mov    %ebx,%eax
  801533:	31 d2                	xor    %edx,%edx
  801535:	f7 f5                	div    %ebp
  801537:	89 f0                	mov    %esi,%eax
  801539:	f7 f5                	div    %ebp
  80153b:	89 d0                	mov    %edx,%eax
  80153d:	31 d2                	xor    %edx,%edx
  80153f:	eb 8c                	jmp    8014cd <__umoddi3+0x2d>
  801541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801548:	89 e9                	mov    %ebp,%ecx
  80154a:	ba 20 00 00 00       	mov    $0x20,%edx
  80154f:	29 ea                	sub    %ebp,%edx
  801551:	d3 e0                	shl    %cl,%eax
  801553:	89 44 24 08          	mov    %eax,0x8(%esp)
  801557:	89 d1                	mov    %edx,%ecx
  801559:	89 f8                	mov    %edi,%eax
  80155b:	d3 e8                	shr    %cl,%eax
  80155d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801561:	89 54 24 04          	mov    %edx,0x4(%esp)
  801565:	8b 54 24 04          	mov    0x4(%esp),%edx
  801569:	09 c1                	or     %eax,%ecx
  80156b:	89 d8                	mov    %ebx,%eax
  80156d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801571:	89 e9                	mov    %ebp,%ecx
  801573:	d3 e7                	shl    %cl,%edi
  801575:	89 d1                	mov    %edx,%ecx
  801577:	d3 e8                	shr    %cl,%eax
  801579:	89 e9                	mov    %ebp,%ecx
  80157b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80157f:	d3 e3                	shl    %cl,%ebx
  801581:	89 c7                	mov    %eax,%edi
  801583:	89 d1                	mov    %edx,%ecx
  801585:	89 f0                	mov    %esi,%eax
  801587:	d3 e8                	shr    %cl,%eax
  801589:	89 e9                	mov    %ebp,%ecx
  80158b:	89 fa                	mov    %edi,%edx
  80158d:	d3 e6                	shl    %cl,%esi
  80158f:	09 d8                	or     %ebx,%eax
  801591:	f7 74 24 08          	divl   0x8(%esp)
  801595:	89 d1                	mov    %edx,%ecx
  801597:	89 f3                	mov    %esi,%ebx
  801599:	f7 64 24 0c          	mull   0xc(%esp)
  80159d:	89 c6                	mov    %eax,%esi
  80159f:	89 d7                	mov    %edx,%edi
  8015a1:	39 d1                	cmp    %edx,%ecx
  8015a3:	72 06                	jb     8015ab <__umoddi3+0x10b>
  8015a5:	75 10                	jne    8015b7 <__umoddi3+0x117>
  8015a7:	39 c3                	cmp    %eax,%ebx
  8015a9:	73 0c                	jae    8015b7 <__umoddi3+0x117>
  8015ab:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8015af:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8015b3:	89 d7                	mov    %edx,%edi
  8015b5:	89 c6                	mov    %eax,%esi
  8015b7:	89 ca                	mov    %ecx,%edx
  8015b9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8015be:	29 f3                	sub    %esi,%ebx
  8015c0:	19 fa                	sbb    %edi,%edx
  8015c2:	89 d0                	mov    %edx,%eax
  8015c4:	d3 e0                	shl    %cl,%eax
  8015c6:	89 e9                	mov    %ebp,%ecx
  8015c8:	d3 eb                	shr    %cl,%ebx
  8015ca:	d3 ea                	shr    %cl,%edx
  8015cc:	09 d8                	or     %ebx,%eax
  8015ce:	83 c4 1c             	add    $0x1c,%esp
  8015d1:	5b                   	pop    %ebx
  8015d2:	5e                   	pop    %esi
  8015d3:	5f                   	pop    %edi
  8015d4:	5d                   	pop    %ebp
  8015d5:	c3                   	ret    
  8015d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8015dd:	8d 76 00             	lea    0x0(%esi),%esi
  8015e0:	29 fe                	sub    %edi,%esi
  8015e2:	19 c3                	sbb    %eax,%ebx
  8015e4:	89 f2                	mov    %esi,%edx
  8015e6:	89 d9                	mov    %ebx,%ecx
  8015e8:	e9 1d ff ff ff       	jmp    80150a <__umoddi3+0x6a>
