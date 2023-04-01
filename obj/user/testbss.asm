
obj/user/testbss:     file format elf32-i386


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
  80002c:	e8 db 00 00 00       	call   80010c <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t bigarray[ARRAYSIZE];

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	53                   	push   %ebx
  80003b:	83 ec 10             	sub    $0x10,%esp
  80003e:	e8 c5 00 00 00       	call   800108 <__x86.get_pc_thunk.bx>
  800043:	81 c3 bd 1f 00 00    	add    $0x1fbd,%ebx
	int i;

	cprintf("Making sure bss works right...\n");
  800049:	8d 83 e0 ef ff ff    	lea    -0x1020(%ebx),%eax
  80004f:	50                   	push   %eax
  800050:	e8 56 02 00 00       	call   8002ab <cprintf>
  800055:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < ARRAYSIZE; i++)
  800058:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != 0)
  80005d:	c7 c2 40 20 80 00    	mov    $0x802040,%edx
  800063:	83 3c 82 00          	cmpl   $0x0,(%edx,%eax,4)
  800067:	75 73                	jne    8000dc <umain+0xa9>
	for (i = 0; i < ARRAYSIZE; i++)
  800069:	83 c0 01             	add    $0x1,%eax
  80006c:	3d 00 00 10 00       	cmp    $0x100000,%eax
  800071:	75 f0                	jne    800063 <umain+0x30>
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
  800073:	b8 00 00 00 00       	mov    $0x0,%eax
		bigarray[i] = i;
  800078:	c7 c2 40 20 80 00    	mov    $0x802040,%edx
  80007e:	89 04 82             	mov    %eax,(%edx,%eax,4)
	for (i = 0; i < ARRAYSIZE; i++)
  800081:	83 c0 01             	add    $0x1,%eax
  800084:	3d 00 00 10 00       	cmp    $0x100000,%eax
  800089:	75 f3                	jne    80007e <umain+0x4b>
	for (i = 0; i < ARRAYSIZE; i++)
  80008b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != i)
  800090:	c7 c2 40 20 80 00    	mov    $0x802040,%edx
  800096:	39 04 82             	cmp    %eax,(%edx,%eax,4)
  800099:	75 57                	jne    8000f2 <umain+0xbf>
	for (i = 0; i < ARRAYSIZE; i++)
  80009b:	83 c0 01             	add    $0x1,%eax
  80009e:	3d 00 00 10 00       	cmp    $0x100000,%eax
  8000a3:	75 f1                	jne    800096 <umain+0x63>
			panic("bigarray[%d] didn't hold its value!\n", i);

	cprintf("Yes, good.  Now doing a wild write off the end...\n");
  8000a5:	83 ec 0c             	sub    $0xc,%esp
  8000a8:	8d 83 28 f0 ff ff    	lea    -0xfd8(%ebx),%eax
  8000ae:	50                   	push   %eax
  8000af:	e8 f7 01 00 00       	call   8002ab <cprintf>
	bigarray[ARRAYSIZE+1024] = 0;
  8000b4:	c7 c0 40 20 80 00    	mov    $0x802040,%eax
  8000ba:	c7 80 00 10 40 00 00 	movl   $0x0,0x401000(%eax)
  8000c1:	00 00 00 
	panic("SHOULD HAVE TRAPPED!!!");
  8000c4:	83 c4 0c             	add    $0xc,%esp
  8000c7:	8d 83 87 f0 ff ff    	lea    -0xf79(%ebx),%eax
  8000cd:	50                   	push   %eax
  8000ce:	6a 1a                	push   $0x1a
  8000d0:	8d 83 78 f0 ff ff    	lea    -0xf88(%ebx),%eax
  8000d6:	50                   	push   %eax
  8000d7:	e8 b7 00 00 00       	call   800193 <_panic>
			panic("bigarray[%d] isn't cleared!\n", i);
  8000dc:	50                   	push   %eax
  8000dd:	8d 83 5b f0 ff ff    	lea    -0xfa5(%ebx),%eax
  8000e3:	50                   	push   %eax
  8000e4:	6a 11                	push   $0x11
  8000e6:	8d 83 78 f0 ff ff    	lea    -0xf88(%ebx),%eax
  8000ec:	50                   	push   %eax
  8000ed:	e8 a1 00 00 00       	call   800193 <_panic>
			panic("bigarray[%d] didn't hold its value!\n", i);
  8000f2:	50                   	push   %eax
  8000f3:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  8000f9:	50                   	push   %eax
  8000fa:	6a 16                	push   $0x16
  8000fc:	8d 83 78 f0 ff ff    	lea    -0xf88(%ebx),%eax
  800102:	50                   	push   %eax
  800103:	e8 8b 00 00 00       	call   800193 <_panic>

00800108 <__x86.get_pc_thunk.bx>:
  800108:	8b 1c 24             	mov    (%esp),%ebx
  80010b:	c3                   	ret    

0080010c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80010c:	f3 0f 1e fb          	endbr32 
  800110:	55                   	push   %ebp
  800111:	89 e5                	mov    %esp,%ebp
  800113:	57                   	push   %edi
  800114:	56                   	push   %esi
  800115:	53                   	push   %ebx
  800116:	83 ec 0c             	sub    $0xc,%esp
  800119:	e8 ea ff ff ff       	call   800108 <__x86.get_pc_thunk.bx>
  80011e:	81 c3 e2 1e 00 00    	add    $0x1ee2,%ebx
  800124:	8b 75 08             	mov    0x8(%ebp),%esi
  800127:	8b 7d 0c             	mov    0xc(%ebp),%edi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80012a:	e8 25 0c 00 00       	call   800d54 <sys_getenvid>
  80012f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800134:	8d 04 40             	lea    (%eax,%eax,2),%eax
  800137:	c1 e0 05             	shl    $0x5,%eax
  80013a:	81 c0 00 00 c0 ee    	add    $0xeec00000,%eax
  800140:	c7 c2 40 20 c0 00    	mov    $0xc02040,%edx
  800146:	89 02                	mov    %eax,(%edx)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800148:	85 f6                	test   %esi,%esi
  80014a:	7e 08                	jle    800154 <libmain+0x48>
		binaryname = argv[0];
  80014c:	8b 07                	mov    (%edi),%eax
  80014e:	89 83 0c 00 00 00    	mov    %eax,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  800154:	83 ec 08             	sub    $0x8,%esp
  800157:	57                   	push   %edi
  800158:	56                   	push   %esi
  800159:	e8 d5 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80015e:	e8 0b 00 00 00       	call   80016e <exit>
}
  800163:	83 c4 10             	add    $0x10,%esp
  800166:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800169:	5b                   	pop    %ebx
  80016a:	5e                   	pop    %esi
  80016b:	5f                   	pop    %edi
  80016c:	5d                   	pop    %ebp
  80016d:	c3                   	ret    

0080016e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80016e:	f3 0f 1e fb          	endbr32 
  800172:	55                   	push   %ebp
  800173:	89 e5                	mov    %esp,%ebp
  800175:	53                   	push   %ebx
  800176:	83 ec 10             	sub    $0x10,%esp
  800179:	e8 8a ff ff ff       	call   800108 <__x86.get_pc_thunk.bx>
  80017e:	81 c3 82 1e 00 00    	add    $0x1e82,%ebx
	sys_env_destroy(0);
  800184:	6a 00                	push   $0x0
  800186:	e8 70 0b 00 00       	call   800cfb <sys_env_destroy>
}
  80018b:	83 c4 10             	add    $0x10,%esp
  80018e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800191:	c9                   	leave  
  800192:	c3                   	ret    

00800193 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800193:	f3 0f 1e fb          	endbr32 
  800197:	55                   	push   %ebp
  800198:	89 e5                	mov    %esp,%ebp
  80019a:	57                   	push   %edi
  80019b:	56                   	push   %esi
  80019c:	53                   	push   %ebx
  80019d:	83 ec 0c             	sub    $0xc,%esp
  8001a0:	e8 63 ff ff ff       	call   800108 <__x86.get_pc_thunk.bx>
  8001a5:	81 c3 5b 1e 00 00    	add    $0x1e5b,%ebx
	va_list ap;

	va_start(ap, fmt);
  8001ab:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001ae:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  8001b4:	8b 38                	mov    (%eax),%edi
  8001b6:	e8 99 0b 00 00       	call   800d54 <sys_getenvid>
  8001bb:	83 ec 0c             	sub    $0xc,%esp
  8001be:	ff 75 0c             	pushl  0xc(%ebp)
  8001c1:	ff 75 08             	pushl  0x8(%ebp)
  8001c4:	57                   	push   %edi
  8001c5:	50                   	push   %eax
  8001c6:	8d 83 a8 f0 ff ff    	lea    -0xf58(%ebx),%eax
  8001cc:	50                   	push   %eax
  8001cd:	e8 d9 00 00 00       	call   8002ab <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001d2:	83 c4 18             	add    $0x18,%esp
  8001d5:	56                   	push   %esi
  8001d6:	ff 75 10             	pushl  0x10(%ebp)
  8001d9:	e8 67 00 00 00       	call   800245 <vcprintf>
	cprintf("\n");
  8001de:	8d 83 76 f0 ff ff    	lea    -0xf8a(%ebx),%eax
  8001e4:	89 04 24             	mov    %eax,(%esp)
  8001e7:	e8 bf 00 00 00       	call   8002ab <cprintf>
  8001ec:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001ef:	cc                   	int3   
  8001f0:	eb fd                	jmp    8001ef <_panic+0x5c>

008001f2 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001f2:	f3 0f 1e fb          	endbr32 
  8001f6:	55                   	push   %ebp
  8001f7:	89 e5                	mov    %esp,%ebp
  8001f9:	56                   	push   %esi
  8001fa:	53                   	push   %ebx
  8001fb:	e8 08 ff ff ff       	call   800108 <__x86.get_pc_thunk.bx>
  800200:	81 c3 00 1e 00 00    	add    $0x1e00,%ebx
  800206:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
  800209:	8b 16                	mov    (%esi),%edx
  80020b:	8d 42 01             	lea    0x1(%edx),%eax
  80020e:	89 06                	mov    %eax,(%esi)
  800210:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800213:	88 4c 16 08          	mov    %cl,0x8(%esi,%edx,1)
	if (b->idx == 256-1) {
  800217:	3d ff 00 00 00       	cmp    $0xff,%eax
  80021c:	74 0b                	je     800229 <putch+0x37>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80021e:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  800222:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800225:	5b                   	pop    %ebx
  800226:	5e                   	pop    %esi
  800227:	5d                   	pop    %ebp
  800228:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800229:	83 ec 08             	sub    $0x8,%esp
  80022c:	68 ff 00 00 00       	push   $0xff
  800231:	8d 46 08             	lea    0x8(%esi),%eax
  800234:	50                   	push   %eax
  800235:	e8 7c 0a 00 00       	call   800cb6 <sys_cputs>
		b->idx = 0;
  80023a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  800240:	83 c4 10             	add    $0x10,%esp
  800243:	eb d9                	jmp    80021e <putch+0x2c>

00800245 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800245:	f3 0f 1e fb          	endbr32 
  800249:	55                   	push   %ebp
  80024a:	89 e5                	mov    %esp,%ebp
  80024c:	53                   	push   %ebx
  80024d:	81 ec 14 01 00 00    	sub    $0x114,%esp
  800253:	e8 b0 fe ff ff       	call   800108 <__x86.get_pc_thunk.bx>
  800258:	81 c3 a8 1d 00 00    	add    $0x1da8,%ebx
	struct printbuf b;

	b.idx = 0;
  80025e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800265:	00 00 00 
	b.cnt = 0;
  800268:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80026f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800272:	ff 75 0c             	pushl  0xc(%ebp)
  800275:	ff 75 08             	pushl  0x8(%ebp)
  800278:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80027e:	50                   	push   %eax
  80027f:	8d 83 f2 e1 ff ff    	lea    -0x1e0e(%ebx),%eax
  800285:	50                   	push   %eax
  800286:	e8 38 01 00 00       	call   8003c3 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80028b:	83 c4 08             	add    $0x8,%esp
  80028e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800294:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80029a:	50                   	push   %eax
  80029b:	e8 16 0a 00 00       	call   800cb6 <sys_cputs>

	return b.cnt;
}
  8002a0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002a9:	c9                   	leave  
  8002aa:	c3                   	ret    

008002ab <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002ab:	f3 0f 1e fb          	endbr32 
  8002af:	55                   	push   %ebp
  8002b0:	89 e5                	mov    %esp,%ebp
  8002b2:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002b5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002b8:	50                   	push   %eax
  8002b9:	ff 75 08             	pushl  0x8(%ebp)
  8002bc:	e8 84 ff ff ff       	call   800245 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002c1:	c9                   	leave  
  8002c2:	c3                   	ret    

008002c3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002c3:	55                   	push   %ebp
  8002c4:	89 e5                	mov    %esp,%ebp
  8002c6:	57                   	push   %edi
  8002c7:	56                   	push   %esi
  8002c8:	53                   	push   %ebx
  8002c9:	83 ec 2c             	sub    $0x2c,%esp
  8002cc:	e8 2c 06 00 00       	call   8008fd <__x86.get_pc_thunk.cx>
  8002d1:	81 c1 2f 1d 00 00    	add    $0x1d2f,%ecx
  8002d7:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002da:	89 c7                	mov    %eax,%edi
  8002dc:	89 d6                	mov    %edx,%esi
  8002de:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002e4:	89 d1                	mov    %edx,%ecx
  8002e6:	89 c2                	mov    %eax,%edx
  8002e8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002eb:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8002ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8002f1:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002f7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8002fe:	39 c2                	cmp    %eax,%edx
  800300:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800303:	72 41                	jb     800346 <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800305:	83 ec 0c             	sub    $0xc,%esp
  800308:	ff 75 18             	pushl  0x18(%ebp)
  80030b:	83 eb 01             	sub    $0x1,%ebx
  80030e:	53                   	push   %ebx
  80030f:	50                   	push   %eax
  800310:	83 ec 08             	sub    $0x8,%esp
  800313:	ff 75 e4             	pushl  -0x1c(%ebp)
  800316:	ff 75 e0             	pushl  -0x20(%ebp)
  800319:	ff 75 d4             	pushl  -0x2c(%ebp)
  80031c:	ff 75 d0             	pushl  -0x30(%ebp)
  80031f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800322:	e8 59 0a 00 00       	call   800d80 <__udivdi3>
  800327:	83 c4 18             	add    $0x18,%esp
  80032a:	52                   	push   %edx
  80032b:	50                   	push   %eax
  80032c:	89 f2                	mov    %esi,%edx
  80032e:	89 f8                	mov    %edi,%eax
  800330:	e8 8e ff ff ff       	call   8002c3 <printnum>
  800335:	83 c4 20             	add    $0x20,%esp
  800338:	eb 13                	jmp    80034d <printnum+0x8a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80033a:	83 ec 08             	sub    $0x8,%esp
  80033d:	56                   	push   %esi
  80033e:	ff 75 18             	pushl  0x18(%ebp)
  800341:	ff d7                	call   *%edi
  800343:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800346:	83 eb 01             	sub    $0x1,%ebx
  800349:	85 db                	test   %ebx,%ebx
  80034b:	7f ed                	jg     80033a <printnum+0x77>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80034d:	83 ec 08             	sub    $0x8,%esp
  800350:	56                   	push   %esi
  800351:	83 ec 04             	sub    $0x4,%esp
  800354:	ff 75 e4             	pushl  -0x1c(%ebp)
  800357:	ff 75 e0             	pushl  -0x20(%ebp)
  80035a:	ff 75 d4             	pushl  -0x2c(%ebp)
  80035d:	ff 75 d0             	pushl  -0x30(%ebp)
  800360:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800363:	e8 28 0b 00 00       	call   800e90 <__umoddi3>
  800368:	83 c4 14             	add    $0x14,%esp
  80036b:	0f be 84 03 cb f0 ff 	movsbl -0xf35(%ebx,%eax,1),%eax
  800372:	ff 
  800373:	50                   	push   %eax
  800374:	ff d7                	call   *%edi
}
  800376:	83 c4 10             	add    $0x10,%esp
  800379:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80037c:	5b                   	pop    %ebx
  80037d:	5e                   	pop    %esi
  80037e:	5f                   	pop    %edi
  80037f:	5d                   	pop    %ebp
  800380:	c3                   	ret    

00800381 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800381:	f3 0f 1e fb          	endbr32 
  800385:	55                   	push   %ebp
  800386:	89 e5                	mov    %esp,%ebp
  800388:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80038b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80038f:	8b 10                	mov    (%eax),%edx
  800391:	3b 50 04             	cmp    0x4(%eax),%edx
  800394:	73 0a                	jae    8003a0 <sprintputch+0x1f>
		*b->buf++ = ch;
  800396:	8d 4a 01             	lea    0x1(%edx),%ecx
  800399:	89 08                	mov    %ecx,(%eax)
  80039b:	8b 45 08             	mov    0x8(%ebp),%eax
  80039e:	88 02                	mov    %al,(%edx)
}
  8003a0:	5d                   	pop    %ebp
  8003a1:	c3                   	ret    

008003a2 <printfmt>:
{
  8003a2:	f3 0f 1e fb          	endbr32 
  8003a6:	55                   	push   %ebp
  8003a7:	89 e5                	mov    %esp,%ebp
  8003a9:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003ac:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003af:	50                   	push   %eax
  8003b0:	ff 75 10             	pushl  0x10(%ebp)
  8003b3:	ff 75 0c             	pushl  0xc(%ebp)
  8003b6:	ff 75 08             	pushl  0x8(%ebp)
  8003b9:	e8 05 00 00 00       	call   8003c3 <vprintfmt>
}
  8003be:	83 c4 10             	add    $0x10,%esp
  8003c1:	c9                   	leave  
  8003c2:	c3                   	ret    

008003c3 <vprintfmt>:
{
  8003c3:	f3 0f 1e fb          	endbr32 
  8003c7:	55                   	push   %ebp
  8003c8:	89 e5                	mov    %esp,%ebp
  8003ca:	57                   	push   %edi
  8003cb:	56                   	push   %esi
  8003cc:	53                   	push   %ebx
  8003cd:	83 ec 3c             	sub    $0x3c,%esp
  8003d0:	e8 24 05 00 00       	call   8008f9 <__x86.get_pc_thunk.ax>
  8003d5:	05 2b 1c 00 00       	add    $0x1c2b,%eax
  8003da:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003dd:	8b 75 08             	mov    0x8(%ebp),%esi
  8003e0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8003e3:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003e6:	8d 80 10 00 00 00    	lea    0x10(%eax),%eax
  8003ec:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8003ef:	e9 cd 03 00 00       	jmp    8007c1 <.L25+0x48>
		padc = ' ';
  8003f4:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		altflag = 0;
  8003f8:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003ff:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800406:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  80040d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800412:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800415:	89 75 08             	mov    %esi,0x8(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800418:	8d 43 01             	lea    0x1(%ebx),%eax
  80041b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80041e:	0f b6 13             	movzbl (%ebx),%edx
  800421:	8d 42 dd             	lea    -0x23(%edx),%eax
  800424:	3c 55                	cmp    $0x55,%al
  800426:	0f 87 21 04 00 00    	ja     80084d <.L20>
  80042c:	0f b6 c0             	movzbl %al,%eax
  80042f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800432:	89 ce                	mov    %ecx,%esi
  800434:	03 b4 81 58 f1 ff ff 	add    -0xea8(%ecx,%eax,4),%esi
  80043b:	3e ff e6             	notrack jmp *%esi

0080043e <.L68>:
  80043e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			padc = '-';
  800441:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800445:	eb d1                	jmp    800418 <vprintfmt+0x55>

00800447 <.L32>:
		switch (ch = *(unsigned char *) fmt++) {
  800447:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80044a:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80044e:	eb c8                	jmp    800418 <vprintfmt+0x55>

00800450 <.L31>:
  800450:	0f b6 d2             	movzbl %dl,%edx
  800453:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			for (precision = 0; ; ++fmt) {
  800456:	b8 00 00 00 00       	mov    $0x0,%eax
  80045b:	8b 75 08             	mov    0x8(%ebp),%esi
				precision = precision * 10 + ch - '0';
  80045e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800461:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800465:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  800468:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80046b:	83 f9 09             	cmp    $0x9,%ecx
  80046e:	77 58                	ja     8004c8 <.L36+0xf>
			for (precision = 0; ; ++fmt) {
  800470:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  800473:	eb e9                	jmp    80045e <.L31+0xe>

00800475 <.L34>:
			precision = va_arg(ap, int);
  800475:	8b 45 14             	mov    0x14(%ebp),%eax
  800478:	8b 00                	mov    (%eax),%eax
  80047a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80047d:	8b 45 14             	mov    0x14(%ebp),%eax
  800480:	8d 40 04             	lea    0x4(%eax),%eax
  800483:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800486:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			if (width < 0)
  800489:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80048d:	79 89                	jns    800418 <vprintfmt+0x55>
				width = precision, precision = -1;
  80048f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800492:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800495:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80049c:	e9 77 ff ff ff       	jmp    800418 <vprintfmt+0x55>

008004a1 <.L33>:
  8004a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004a4:	85 c0                	test   %eax,%eax
  8004a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ab:	0f 49 d0             	cmovns %eax,%edx
  8004ae:	89 55 d4             	mov    %edx,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004b1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  8004b4:	e9 5f ff ff ff       	jmp    800418 <vprintfmt+0x55>

008004b9 <.L36>:
		switch (ch = *(unsigned char *) fmt++) {
  8004b9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			altflag = 1;
  8004bc:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8004c3:	e9 50 ff ff ff       	jmp    800418 <vprintfmt+0x55>
  8004c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004cb:	89 75 08             	mov    %esi,0x8(%ebp)
  8004ce:	eb b9                	jmp    800489 <.L34+0x14>

008004d0 <.L27>:
			lflag++;
  8004d0:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004d4:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  8004d7:	e9 3c ff ff ff       	jmp    800418 <vprintfmt+0x55>

008004dc <.L30>:
  8004dc:	8b 75 08             	mov    0x8(%ebp),%esi
			putch(va_arg(ap, int), putdat);
  8004df:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e2:	8d 58 04             	lea    0x4(%eax),%ebx
  8004e5:	83 ec 08             	sub    $0x8,%esp
  8004e8:	57                   	push   %edi
  8004e9:	ff 30                	pushl  (%eax)
  8004eb:	ff d6                	call   *%esi
			break;
  8004ed:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004f0:	89 5d 14             	mov    %ebx,0x14(%ebp)
			break;
  8004f3:	e9 c6 02 00 00       	jmp    8007be <.L25+0x45>

008004f8 <.L28>:
  8004f8:	8b 75 08             	mov    0x8(%ebp),%esi
			err = va_arg(ap, int);
  8004fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fe:	8d 58 04             	lea    0x4(%eax),%ebx
  800501:	8b 00                	mov    (%eax),%eax
  800503:	99                   	cltd   
  800504:	31 d0                	xor    %edx,%eax
  800506:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800508:	83 f8 06             	cmp    $0x6,%eax
  80050b:	7f 27                	jg     800534 <.L28+0x3c>
  80050d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800510:	8b 14 82             	mov    (%edx,%eax,4),%edx
  800513:	85 d2                	test   %edx,%edx
  800515:	74 1d                	je     800534 <.L28+0x3c>
				printfmt(putch, putdat, "%s", p);
  800517:	52                   	push   %edx
  800518:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80051b:	8d 80 ec f0 ff ff    	lea    -0xf14(%eax),%eax
  800521:	50                   	push   %eax
  800522:	57                   	push   %edi
  800523:	56                   	push   %esi
  800524:	e8 79 fe ff ff       	call   8003a2 <printfmt>
  800529:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80052c:	89 5d 14             	mov    %ebx,0x14(%ebp)
  80052f:	e9 8a 02 00 00       	jmp    8007be <.L25+0x45>
				printfmt(putch, putdat, "error %d", err);
  800534:	50                   	push   %eax
  800535:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800538:	8d 80 e3 f0 ff ff    	lea    -0xf1d(%eax),%eax
  80053e:	50                   	push   %eax
  80053f:	57                   	push   %edi
  800540:	56                   	push   %esi
  800541:	e8 5c fe ff ff       	call   8003a2 <printfmt>
  800546:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800549:	89 5d 14             	mov    %ebx,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80054c:	e9 6d 02 00 00       	jmp    8007be <.L25+0x45>

00800551 <.L24>:
  800551:	8b 75 08             	mov    0x8(%ebp),%esi
			if ((p = va_arg(ap, char *)) == NULL)
  800554:	8b 45 14             	mov    0x14(%ebp),%eax
  800557:	83 c0 04             	add    $0x4,%eax
  80055a:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80055d:	8b 45 14             	mov    0x14(%ebp),%eax
  800560:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800562:	85 d2                	test   %edx,%edx
  800564:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800567:	8d 80 dc f0 ff ff    	lea    -0xf24(%eax),%eax
  80056d:	0f 45 c2             	cmovne %edx,%eax
  800570:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800573:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800577:	7e 06                	jle    80057f <.L24+0x2e>
  800579:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80057d:	75 0d                	jne    80058c <.L24+0x3b>
				for (width -= strnlen(p, precision); width > 0; width--)
  80057f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800582:	89 c3                	mov    %eax,%ebx
  800584:	03 45 d4             	add    -0x2c(%ebp),%eax
  800587:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80058a:	eb 58                	jmp    8005e4 <.L24+0x93>
  80058c:	83 ec 08             	sub    $0x8,%esp
  80058f:	ff 75 d8             	pushl  -0x28(%ebp)
  800592:	ff 75 c8             	pushl  -0x38(%ebp)
  800595:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800598:	e8 80 03 00 00       	call   80091d <strnlen>
  80059d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005a0:	29 c2                	sub    %eax,%edx
  8005a2:	89 55 bc             	mov    %edx,-0x44(%ebp)
  8005a5:	83 c4 10             	add    $0x10,%esp
  8005a8:	89 d3                	mov    %edx,%ebx
					putch(padc, putdat);
  8005aa:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8005ae:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b1:	85 db                	test   %ebx,%ebx
  8005b3:	7e 11                	jle    8005c6 <.L24+0x75>
					putch(padc, putdat);
  8005b5:	83 ec 08             	sub    $0x8,%esp
  8005b8:	57                   	push   %edi
  8005b9:	ff 75 d4             	pushl  -0x2c(%ebp)
  8005bc:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005be:	83 eb 01             	sub    $0x1,%ebx
  8005c1:	83 c4 10             	add    $0x10,%esp
  8005c4:	eb eb                	jmp    8005b1 <.L24+0x60>
  8005c6:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8005c9:	85 d2                	test   %edx,%edx
  8005cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8005d0:	0f 49 c2             	cmovns %edx,%eax
  8005d3:	29 c2                	sub    %eax,%edx
  8005d5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005d8:	eb a5                	jmp    80057f <.L24+0x2e>
					putch(ch, putdat);
  8005da:	83 ec 08             	sub    $0x8,%esp
  8005dd:	57                   	push   %edi
  8005de:	52                   	push   %edx
  8005df:	ff d6                	call   *%esi
  8005e1:	83 c4 10             	add    $0x10,%esp
  8005e4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005e7:	29 d9                	sub    %ebx,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005e9:	83 c3 01             	add    $0x1,%ebx
  8005ec:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  8005f0:	0f be d0             	movsbl %al,%edx
  8005f3:	85 d2                	test   %edx,%edx
  8005f5:	74 4b                	je     800642 <.L24+0xf1>
  8005f7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005fb:	78 06                	js     800603 <.L24+0xb2>
  8005fd:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800601:	78 1e                	js     800621 <.L24+0xd0>
				if (altflag && (ch < ' ' || ch > '~'))
  800603:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800607:	74 d1                	je     8005da <.L24+0x89>
  800609:	0f be c0             	movsbl %al,%eax
  80060c:	83 e8 20             	sub    $0x20,%eax
  80060f:	83 f8 5e             	cmp    $0x5e,%eax
  800612:	76 c6                	jbe    8005da <.L24+0x89>
					putch('?', putdat);
  800614:	83 ec 08             	sub    $0x8,%esp
  800617:	57                   	push   %edi
  800618:	6a 3f                	push   $0x3f
  80061a:	ff d6                	call   *%esi
  80061c:	83 c4 10             	add    $0x10,%esp
  80061f:	eb c3                	jmp    8005e4 <.L24+0x93>
  800621:	89 cb                	mov    %ecx,%ebx
  800623:	eb 0e                	jmp    800633 <.L24+0xe2>
				putch(' ', putdat);
  800625:	83 ec 08             	sub    $0x8,%esp
  800628:	57                   	push   %edi
  800629:	6a 20                	push   $0x20
  80062b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80062d:	83 eb 01             	sub    $0x1,%ebx
  800630:	83 c4 10             	add    $0x10,%esp
  800633:	85 db                	test   %ebx,%ebx
  800635:	7f ee                	jg     800625 <.L24+0xd4>
			if ((p = va_arg(ap, char *)) == NULL)
  800637:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80063a:	89 45 14             	mov    %eax,0x14(%ebp)
  80063d:	e9 7c 01 00 00       	jmp    8007be <.L25+0x45>
  800642:	89 cb                	mov    %ecx,%ebx
  800644:	eb ed                	jmp    800633 <.L24+0xe2>

00800646 <.L29>:
  800646:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800649:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  80064c:	83 f9 01             	cmp    $0x1,%ecx
  80064f:	7f 1b                	jg     80066c <.L29+0x26>
	else if (lflag)
  800651:	85 c9                	test   %ecx,%ecx
  800653:	74 63                	je     8006b8 <.L29+0x72>
		return va_arg(*ap, long);
  800655:	8b 45 14             	mov    0x14(%ebp),%eax
  800658:	8b 00                	mov    (%eax),%eax
  80065a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065d:	99                   	cltd   
  80065e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800661:	8b 45 14             	mov    0x14(%ebp),%eax
  800664:	8d 40 04             	lea    0x4(%eax),%eax
  800667:	89 45 14             	mov    %eax,0x14(%ebp)
  80066a:	eb 17                	jmp    800683 <.L29+0x3d>
		return va_arg(*ap, long long);
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	8b 50 04             	mov    0x4(%eax),%edx
  800672:	8b 00                	mov    (%eax),%eax
  800674:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800677:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067a:	8b 45 14             	mov    0x14(%ebp),%eax
  80067d:	8d 40 08             	lea    0x8(%eax),%eax
  800680:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800683:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800686:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800689:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80068e:	85 c9                	test   %ecx,%ecx
  800690:	0f 89 0e 01 00 00    	jns    8007a4 <.L25+0x2b>
				putch('-', putdat);
  800696:	83 ec 08             	sub    $0x8,%esp
  800699:	57                   	push   %edi
  80069a:	6a 2d                	push   $0x2d
  80069c:	ff d6                	call   *%esi
				num = -(long long) num;
  80069e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006a1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006a4:	f7 da                	neg    %edx
  8006a6:	83 d1 00             	adc    $0x0,%ecx
  8006a9:	f7 d9                	neg    %ecx
  8006ab:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006ae:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006b3:	e9 ec 00 00 00       	jmp    8007a4 <.L25+0x2b>
		return va_arg(*ap, int);
  8006b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bb:	8b 00                	mov    (%eax),%eax
  8006bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c0:	99                   	cltd   
  8006c1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c7:	8d 40 04             	lea    0x4(%eax),%eax
  8006ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8006cd:	eb b4                	jmp    800683 <.L29+0x3d>

008006cf <.L23>:
  8006cf:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006d2:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  8006d5:	83 f9 01             	cmp    $0x1,%ecx
  8006d8:	7f 1e                	jg     8006f8 <.L23+0x29>
	else if (lflag)
  8006da:	85 c9                	test   %ecx,%ecx
  8006dc:	74 32                	je     800710 <.L23+0x41>
		return va_arg(*ap, unsigned long);
  8006de:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e1:	8b 10                	mov    (%eax),%edx
  8006e3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006e8:	8d 40 04             	lea    0x4(%eax),%eax
  8006eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ee:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8006f3:	e9 ac 00 00 00       	jmp    8007a4 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  8006f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fb:	8b 10                	mov    (%eax),%edx
  8006fd:	8b 48 04             	mov    0x4(%eax),%ecx
  800700:	8d 40 08             	lea    0x8(%eax),%eax
  800703:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800706:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80070b:	e9 94 00 00 00       	jmp    8007a4 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  800710:	8b 45 14             	mov    0x14(%ebp),%eax
  800713:	8b 10                	mov    (%eax),%edx
  800715:	b9 00 00 00 00       	mov    $0x0,%ecx
  80071a:	8d 40 04             	lea    0x4(%eax),%eax
  80071d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800720:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800725:	eb 7d                	jmp    8007a4 <.L25+0x2b>

00800727 <.L26>:
  800727:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80072a:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  80072d:	83 f9 01             	cmp    $0x1,%ecx
  800730:	7f 1b                	jg     80074d <.L26+0x26>
	else if (lflag)
  800732:	85 c9                	test   %ecx,%ecx
  800734:	74 2c                	je     800762 <.L26+0x3b>
		return va_arg(*ap, unsigned long);
  800736:	8b 45 14             	mov    0x14(%ebp),%eax
  800739:	8b 10                	mov    (%eax),%edx
  80073b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800740:	8d 40 04             	lea    0x4(%eax),%eax
  800743:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800746:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  80074b:	eb 57                	jmp    8007a4 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  80074d:	8b 45 14             	mov    0x14(%ebp),%eax
  800750:	8b 10                	mov    (%eax),%edx
  800752:	8b 48 04             	mov    0x4(%eax),%ecx
  800755:	8d 40 08             	lea    0x8(%eax),%eax
  800758:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80075b:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800760:	eb 42                	jmp    8007a4 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  800762:	8b 45 14             	mov    0x14(%ebp),%eax
  800765:	8b 10                	mov    (%eax),%edx
  800767:	b9 00 00 00 00       	mov    $0x0,%ecx
  80076c:	8d 40 04             	lea    0x4(%eax),%eax
  80076f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800772:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800777:	eb 2b                	jmp    8007a4 <.L25+0x2b>

00800779 <.L25>:
  800779:	8b 75 08             	mov    0x8(%ebp),%esi
			putch('0', putdat);
  80077c:	83 ec 08             	sub    $0x8,%esp
  80077f:	57                   	push   %edi
  800780:	6a 30                	push   $0x30
  800782:	ff d6                	call   *%esi
			putch('x', putdat);
  800784:	83 c4 08             	add    $0x8,%esp
  800787:	57                   	push   %edi
  800788:	6a 78                	push   $0x78
  80078a:	ff d6                	call   *%esi
			num = (unsigned long long)
  80078c:	8b 45 14             	mov    0x14(%ebp),%eax
  80078f:	8b 10                	mov    (%eax),%edx
  800791:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800796:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800799:	8d 40 04             	lea    0x4(%eax),%eax
  80079c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80079f:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007a4:	83 ec 0c             	sub    $0xc,%esp
  8007a7:	0f be 5d cf          	movsbl -0x31(%ebp),%ebx
  8007ab:	53                   	push   %ebx
  8007ac:	ff 75 d4             	pushl  -0x2c(%ebp)
  8007af:	50                   	push   %eax
  8007b0:	51                   	push   %ecx
  8007b1:	52                   	push   %edx
  8007b2:	89 fa                	mov    %edi,%edx
  8007b4:	89 f0                	mov    %esi,%eax
  8007b6:	e8 08 fb ff ff       	call   8002c3 <printnum>
			break;
  8007bb:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007be:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007c1:	83 c3 01             	add    $0x1,%ebx
  8007c4:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  8007c8:	83 f8 25             	cmp    $0x25,%eax
  8007cb:	0f 84 23 fc ff ff    	je     8003f4 <vprintfmt+0x31>
			if (ch == '\0')
  8007d1:	85 c0                	test   %eax,%eax
  8007d3:	0f 84 97 00 00 00    	je     800870 <.L20+0x23>
			putch(ch, putdat);
  8007d9:	83 ec 08             	sub    $0x8,%esp
  8007dc:	57                   	push   %edi
  8007dd:	50                   	push   %eax
  8007de:	ff d6                	call   *%esi
  8007e0:	83 c4 10             	add    $0x10,%esp
  8007e3:	eb dc                	jmp    8007c1 <.L25+0x48>

008007e5 <.L21>:
  8007e5:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8007e8:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  8007eb:	83 f9 01             	cmp    $0x1,%ecx
  8007ee:	7f 1b                	jg     80080b <.L21+0x26>
	else if (lflag)
  8007f0:	85 c9                	test   %ecx,%ecx
  8007f2:	74 2c                	je     800820 <.L21+0x3b>
		return va_arg(*ap, unsigned long);
  8007f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f7:	8b 10                	mov    (%eax),%edx
  8007f9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007fe:	8d 40 04             	lea    0x4(%eax),%eax
  800801:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800804:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800809:	eb 99                	jmp    8007a4 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  80080b:	8b 45 14             	mov    0x14(%ebp),%eax
  80080e:	8b 10                	mov    (%eax),%edx
  800810:	8b 48 04             	mov    0x4(%eax),%ecx
  800813:	8d 40 08             	lea    0x8(%eax),%eax
  800816:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800819:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  80081e:	eb 84                	jmp    8007a4 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  800820:	8b 45 14             	mov    0x14(%ebp),%eax
  800823:	8b 10                	mov    (%eax),%edx
  800825:	b9 00 00 00 00       	mov    $0x0,%ecx
  80082a:	8d 40 04             	lea    0x4(%eax),%eax
  80082d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800830:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800835:	e9 6a ff ff ff       	jmp    8007a4 <.L25+0x2b>

0080083a <.L35>:
  80083a:	8b 75 08             	mov    0x8(%ebp),%esi
			putch(ch, putdat);
  80083d:	83 ec 08             	sub    $0x8,%esp
  800840:	57                   	push   %edi
  800841:	6a 25                	push   $0x25
  800843:	ff d6                	call   *%esi
			break;
  800845:	83 c4 10             	add    $0x10,%esp
  800848:	e9 71 ff ff ff       	jmp    8007be <.L25+0x45>

0080084d <.L20>:
  80084d:	8b 75 08             	mov    0x8(%ebp),%esi
			putch('%', putdat);
  800850:	83 ec 08             	sub    $0x8,%esp
  800853:	57                   	push   %edi
  800854:	6a 25                	push   $0x25
  800856:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800858:	83 c4 10             	add    $0x10,%esp
  80085b:	89 d8                	mov    %ebx,%eax
  80085d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800861:	74 05                	je     800868 <.L20+0x1b>
  800863:	83 e8 01             	sub    $0x1,%eax
  800866:	eb f5                	jmp    80085d <.L20+0x10>
  800868:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80086b:	e9 4e ff ff ff       	jmp    8007be <.L25+0x45>
}
  800870:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800873:	5b                   	pop    %ebx
  800874:	5e                   	pop    %esi
  800875:	5f                   	pop    %edi
  800876:	5d                   	pop    %ebp
  800877:	c3                   	ret    

00800878 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800878:	f3 0f 1e fb          	endbr32 
  80087c:	55                   	push   %ebp
  80087d:	89 e5                	mov    %esp,%ebp
  80087f:	53                   	push   %ebx
  800880:	83 ec 14             	sub    $0x14,%esp
  800883:	e8 80 f8 ff ff       	call   800108 <__x86.get_pc_thunk.bx>
  800888:	81 c3 78 17 00 00    	add    $0x1778,%ebx
  80088e:	8b 45 08             	mov    0x8(%ebp),%eax
  800891:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800894:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800897:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80089b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80089e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008a5:	85 c0                	test   %eax,%eax
  8008a7:	74 2b                	je     8008d4 <vsnprintf+0x5c>
  8008a9:	85 d2                	test   %edx,%edx
  8008ab:	7e 27                	jle    8008d4 <vsnprintf+0x5c>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008ad:	ff 75 14             	pushl  0x14(%ebp)
  8008b0:	ff 75 10             	pushl  0x10(%ebp)
  8008b3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008b6:	50                   	push   %eax
  8008b7:	8d 83 81 e3 ff ff    	lea    -0x1c7f(%ebx),%eax
  8008bd:	50                   	push   %eax
  8008be:	e8 00 fb ff ff       	call   8003c3 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008cc:	83 c4 10             	add    $0x10,%esp
}
  8008cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008d2:	c9                   	leave  
  8008d3:	c3                   	ret    
		return -E_INVAL;
  8008d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008d9:	eb f4                	jmp    8008cf <vsnprintf+0x57>

008008db <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008db:	f3 0f 1e fb          	endbr32 
  8008df:	55                   	push   %ebp
  8008e0:	89 e5                	mov    %esp,%ebp
  8008e2:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008e5:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008e8:	50                   	push   %eax
  8008e9:	ff 75 10             	pushl  0x10(%ebp)
  8008ec:	ff 75 0c             	pushl  0xc(%ebp)
  8008ef:	ff 75 08             	pushl  0x8(%ebp)
  8008f2:	e8 81 ff ff ff       	call   800878 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008f7:	c9                   	leave  
  8008f8:	c3                   	ret    

008008f9 <__x86.get_pc_thunk.ax>:
  8008f9:	8b 04 24             	mov    (%esp),%eax
  8008fc:	c3                   	ret    

008008fd <__x86.get_pc_thunk.cx>:
  8008fd:	8b 0c 24             	mov    (%esp),%ecx
  800900:	c3                   	ret    

00800901 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800901:	f3 0f 1e fb          	endbr32 
  800905:	55                   	push   %ebp
  800906:	89 e5                	mov    %esp,%ebp
  800908:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80090b:	b8 00 00 00 00       	mov    $0x0,%eax
  800910:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800914:	74 05                	je     80091b <strlen+0x1a>
		n++;
  800916:	83 c0 01             	add    $0x1,%eax
  800919:	eb f5                	jmp    800910 <strlen+0xf>
	return n;
}
  80091b:	5d                   	pop    %ebp
  80091c:	c3                   	ret    

0080091d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80091d:	f3 0f 1e fb          	endbr32 
  800921:	55                   	push   %ebp
  800922:	89 e5                	mov    %esp,%ebp
  800924:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800927:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80092a:	b8 00 00 00 00       	mov    $0x0,%eax
  80092f:	39 d0                	cmp    %edx,%eax
  800931:	74 0d                	je     800940 <strnlen+0x23>
  800933:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800937:	74 05                	je     80093e <strnlen+0x21>
		n++;
  800939:	83 c0 01             	add    $0x1,%eax
  80093c:	eb f1                	jmp    80092f <strnlen+0x12>
  80093e:	89 c2                	mov    %eax,%edx
	return n;
}
  800940:	89 d0                	mov    %edx,%eax
  800942:	5d                   	pop    %ebp
  800943:	c3                   	ret    

00800944 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800944:	f3 0f 1e fb          	endbr32 
  800948:	55                   	push   %ebp
  800949:	89 e5                	mov    %esp,%ebp
  80094b:	53                   	push   %ebx
  80094c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80094f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800952:	b8 00 00 00 00       	mov    $0x0,%eax
  800957:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80095b:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  80095e:	83 c0 01             	add    $0x1,%eax
  800961:	84 d2                	test   %dl,%dl
  800963:	75 f2                	jne    800957 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800965:	89 c8                	mov    %ecx,%eax
  800967:	5b                   	pop    %ebx
  800968:	5d                   	pop    %ebp
  800969:	c3                   	ret    

0080096a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80096a:	f3 0f 1e fb          	endbr32 
  80096e:	55                   	push   %ebp
  80096f:	89 e5                	mov    %esp,%ebp
  800971:	53                   	push   %ebx
  800972:	83 ec 10             	sub    $0x10,%esp
  800975:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800978:	53                   	push   %ebx
  800979:	e8 83 ff ff ff       	call   800901 <strlen>
  80097e:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800981:	ff 75 0c             	pushl  0xc(%ebp)
  800984:	01 d8                	add    %ebx,%eax
  800986:	50                   	push   %eax
  800987:	e8 b8 ff ff ff       	call   800944 <strcpy>
	return dst;
}
  80098c:	89 d8                	mov    %ebx,%eax
  80098e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800991:	c9                   	leave  
  800992:	c3                   	ret    

00800993 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800993:	f3 0f 1e fb          	endbr32 
  800997:	55                   	push   %ebp
  800998:	89 e5                	mov    %esp,%ebp
  80099a:	56                   	push   %esi
  80099b:	53                   	push   %ebx
  80099c:	8b 75 08             	mov    0x8(%ebp),%esi
  80099f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a2:	89 f3                	mov    %esi,%ebx
  8009a4:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009a7:	89 f0                	mov    %esi,%eax
  8009a9:	39 d8                	cmp    %ebx,%eax
  8009ab:	74 11                	je     8009be <strncpy+0x2b>
		*dst++ = *src;
  8009ad:	83 c0 01             	add    $0x1,%eax
  8009b0:	0f b6 0a             	movzbl (%edx),%ecx
  8009b3:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009b6:	80 f9 01             	cmp    $0x1,%cl
  8009b9:	83 da ff             	sbb    $0xffffffff,%edx
  8009bc:	eb eb                	jmp    8009a9 <strncpy+0x16>
	}
	return ret;
}
  8009be:	89 f0                	mov    %esi,%eax
  8009c0:	5b                   	pop    %ebx
  8009c1:	5e                   	pop    %esi
  8009c2:	5d                   	pop    %ebp
  8009c3:	c3                   	ret    

008009c4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009c4:	f3 0f 1e fb          	endbr32 
  8009c8:	55                   	push   %ebp
  8009c9:	89 e5                	mov    %esp,%ebp
  8009cb:	56                   	push   %esi
  8009cc:	53                   	push   %ebx
  8009cd:	8b 75 08             	mov    0x8(%ebp),%esi
  8009d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009d3:	8b 55 10             	mov    0x10(%ebp),%edx
  8009d6:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009d8:	85 d2                	test   %edx,%edx
  8009da:	74 21                	je     8009fd <strlcpy+0x39>
  8009dc:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009e0:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009e2:	39 c2                	cmp    %eax,%edx
  8009e4:	74 14                	je     8009fa <strlcpy+0x36>
  8009e6:	0f b6 19             	movzbl (%ecx),%ebx
  8009e9:	84 db                	test   %bl,%bl
  8009eb:	74 0b                	je     8009f8 <strlcpy+0x34>
			*dst++ = *src++;
  8009ed:	83 c1 01             	add    $0x1,%ecx
  8009f0:	83 c2 01             	add    $0x1,%edx
  8009f3:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009f6:	eb ea                	jmp    8009e2 <strlcpy+0x1e>
  8009f8:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009fa:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009fd:	29 f0                	sub    %esi,%eax
}
  8009ff:	5b                   	pop    %ebx
  800a00:	5e                   	pop    %esi
  800a01:	5d                   	pop    %ebp
  800a02:	c3                   	ret    

00800a03 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a03:	f3 0f 1e fb          	endbr32 
  800a07:	55                   	push   %ebp
  800a08:	89 e5                	mov    %esp,%ebp
  800a0a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a0d:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a10:	0f b6 01             	movzbl (%ecx),%eax
  800a13:	84 c0                	test   %al,%al
  800a15:	74 0c                	je     800a23 <strcmp+0x20>
  800a17:	3a 02                	cmp    (%edx),%al
  800a19:	75 08                	jne    800a23 <strcmp+0x20>
		p++, q++;
  800a1b:	83 c1 01             	add    $0x1,%ecx
  800a1e:	83 c2 01             	add    $0x1,%edx
  800a21:	eb ed                	jmp    800a10 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a23:	0f b6 c0             	movzbl %al,%eax
  800a26:	0f b6 12             	movzbl (%edx),%edx
  800a29:	29 d0                	sub    %edx,%eax
}
  800a2b:	5d                   	pop    %ebp
  800a2c:	c3                   	ret    

00800a2d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a2d:	f3 0f 1e fb          	endbr32 
  800a31:	55                   	push   %ebp
  800a32:	89 e5                	mov    %esp,%ebp
  800a34:	53                   	push   %ebx
  800a35:	8b 45 08             	mov    0x8(%ebp),%eax
  800a38:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a3b:	89 c3                	mov    %eax,%ebx
  800a3d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a40:	eb 06                	jmp    800a48 <strncmp+0x1b>
		n--, p++, q++;
  800a42:	83 c0 01             	add    $0x1,%eax
  800a45:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a48:	39 d8                	cmp    %ebx,%eax
  800a4a:	74 16                	je     800a62 <strncmp+0x35>
  800a4c:	0f b6 08             	movzbl (%eax),%ecx
  800a4f:	84 c9                	test   %cl,%cl
  800a51:	74 04                	je     800a57 <strncmp+0x2a>
  800a53:	3a 0a                	cmp    (%edx),%cl
  800a55:	74 eb                	je     800a42 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a57:	0f b6 00             	movzbl (%eax),%eax
  800a5a:	0f b6 12             	movzbl (%edx),%edx
  800a5d:	29 d0                	sub    %edx,%eax
}
  800a5f:	5b                   	pop    %ebx
  800a60:	5d                   	pop    %ebp
  800a61:	c3                   	ret    
		return 0;
  800a62:	b8 00 00 00 00       	mov    $0x0,%eax
  800a67:	eb f6                	jmp    800a5f <strncmp+0x32>

00800a69 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a69:	f3 0f 1e fb          	endbr32 
  800a6d:	55                   	push   %ebp
  800a6e:	89 e5                	mov    %esp,%ebp
  800a70:	8b 45 08             	mov    0x8(%ebp),%eax
  800a73:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a77:	0f b6 10             	movzbl (%eax),%edx
  800a7a:	84 d2                	test   %dl,%dl
  800a7c:	74 09                	je     800a87 <strchr+0x1e>
		if (*s == c)
  800a7e:	38 ca                	cmp    %cl,%dl
  800a80:	74 0a                	je     800a8c <strchr+0x23>
	for (; *s; s++)
  800a82:	83 c0 01             	add    $0x1,%eax
  800a85:	eb f0                	jmp    800a77 <strchr+0xe>
			return (char *) s;
	return 0;
  800a87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a8c:	5d                   	pop    %ebp
  800a8d:	c3                   	ret    

00800a8e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a8e:	f3 0f 1e fb          	endbr32 
  800a92:	55                   	push   %ebp
  800a93:	89 e5                	mov    %esp,%ebp
  800a95:	8b 45 08             	mov    0x8(%ebp),%eax
  800a98:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a9c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a9f:	38 ca                	cmp    %cl,%dl
  800aa1:	74 09                	je     800aac <strfind+0x1e>
  800aa3:	84 d2                	test   %dl,%dl
  800aa5:	74 05                	je     800aac <strfind+0x1e>
	for (; *s; s++)
  800aa7:	83 c0 01             	add    $0x1,%eax
  800aaa:	eb f0                	jmp    800a9c <strfind+0xe>
			break;
	return (char *) s;
}
  800aac:	5d                   	pop    %ebp
  800aad:	c3                   	ret    

00800aae <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800aae:	f3 0f 1e fb          	endbr32 
  800ab2:	55                   	push   %ebp
  800ab3:	89 e5                	mov    %esp,%ebp
  800ab5:	57                   	push   %edi
  800ab6:	56                   	push   %esi
  800ab7:	53                   	push   %ebx
  800ab8:	8b 7d 08             	mov    0x8(%ebp),%edi
  800abb:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800abe:	85 c9                	test   %ecx,%ecx
  800ac0:	74 31                	je     800af3 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ac2:	89 f8                	mov    %edi,%eax
  800ac4:	09 c8                	or     %ecx,%eax
  800ac6:	a8 03                	test   $0x3,%al
  800ac8:	75 23                	jne    800aed <memset+0x3f>
		c &= 0xFF;
  800aca:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ace:	89 d3                	mov    %edx,%ebx
  800ad0:	c1 e3 08             	shl    $0x8,%ebx
  800ad3:	89 d0                	mov    %edx,%eax
  800ad5:	c1 e0 18             	shl    $0x18,%eax
  800ad8:	89 d6                	mov    %edx,%esi
  800ada:	c1 e6 10             	shl    $0x10,%esi
  800add:	09 f0                	or     %esi,%eax
  800adf:	09 c2                	or     %eax,%edx
  800ae1:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ae3:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ae6:	89 d0                	mov    %edx,%eax
  800ae8:	fc                   	cld    
  800ae9:	f3 ab                	rep stos %eax,%es:(%edi)
  800aeb:	eb 06                	jmp    800af3 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800aed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af0:	fc                   	cld    
  800af1:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800af3:	89 f8                	mov    %edi,%eax
  800af5:	5b                   	pop    %ebx
  800af6:	5e                   	pop    %esi
  800af7:	5f                   	pop    %edi
  800af8:	5d                   	pop    %ebp
  800af9:	c3                   	ret    

00800afa <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800afa:	f3 0f 1e fb          	endbr32 
  800afe:	55                   	push   %ebp
  800aff:	89 e5                	mov    %esp,%ebp
  800b01:	57                   	push   %edi
  800b02:	56                   	push   %esi
  800b03:	8b 45 08             	mov    0x8(%ebp),%eax
  800b06:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b09:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b0c:	39 c6                	cmp    %eax,%esi
  800b0e:	73 32                	jae    800b42 <memmove+0x48>
  800b10:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b13:	39 c2                	cmp    %eax,%edx
  800b15:	76 2b                	jbe    800b42 <memmove+0x48>
		s += n;
		d += n;
  800b17:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b1a:	89 fe                	mov    %edi,%esi
  800b1c:	09 ce                	or     %ecx,%esi
  800b1e:	09 d6                	or     %edx,%esi
  800b20:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b26:	75 0e                	jne    800b36 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b28:	83 ef 04             	sub    $0x4,%edi
  800b2b:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b2e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b31:	fd                   	std    
  800b32:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b34:	eb 09                	jmp    800b3f <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b36:	83 ef 01             	sub    $0x1,%edi
  800b39:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b3c:	fd                   	std    
  800b3d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b3f:	fc                   	cld    
  800b40:	eb 1a                	jmp    800b5c <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b42:	89 c2                	mov    %eax,%edx
  800b44:	09 ca                	or     %ecx,%edx
  800b46:	09 f2                	or     %esi,%edx
  800b48:	f6 c2 03             	test   $0x3,%dl
  800b4b:	75 0a                	jne    800b57 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b4d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b50:	89 c7                	mov    %eax,%edi
  800b52:	fc                   	cld    
  800b53:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b55:	eb 05                	jmp    800b5c <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800b57:	89 c7                	mov    %eax,%edi
  800b59:	fc                   	cld    
  800b5a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b5c:	5e                   	pop    %esi
  800b5d:	5f                   	pop    %edi
  800b5e:	5d                   	pop    %ebp
  800b5f:	c3                   	ret    

00800b60 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b60:	f3 0f 1e fb          	endbr32 
  800b64:	55                   	push   %ebp
  800b65:	89 e5                	mov    %esp,%ebp
  800b67:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b6a:	ff 75 10             	pushl  0x10(%ebp)
  800b6d:	ff 75 0c             	pushl  0xc(%ebp)
  800b70:	ff 75 08             	pushl  0x8(%ebp)
  800b73:	e8 82 ff ff ff       	call   800afa <memmove>
}
  800b78:	c9                   	leave  
  800b79:	c3                   	ret    

00800b7a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b7a:	f3 0f 1e fb          	endbr32 
  800b7e:	55                   	push   %ebp
  800b7f:	89 e5                	mov    %esp,%ebp
  800b81:	56                   	push   %esi
  800b82:	53                   	push   %ebx
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
  800b86:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b89:	89 c6                	mov    %eax,%esi
  800b8b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b8e:	39 f0                	cmp    %esi,%eax
  800b90:	74 1c                	je     800bae <memcmp+0x34>
		if (*s1 != *s2)
  800b92:	0f b6 08             	movzbl (%eax),%ecx
  800b95:	0f b6 1a             	movzbl (%edx),%ebx
  800b98:	38 d9                	cmp    %bl,%cl
  800b9a:	75 08                	jne    800ba4 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b9c:	83 c0 01             	add    $0x1,%eax
  800b9f:	83 c2 01             	add    $0x1,%edx
  800ba2:	eb ea                	jmp    800b8e <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800ba4:	0f b6 c1             	movzbl %cl,%eax
  800ba7:	0f b6 db             	movzbl %bl,%ebx
  800baa:	29 d8                	sub    %ebx,%eax
  800bac:	eb 05                	jmp    800bb3 <memcmp+0x39>
	}

	return 0;
  800bae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bb3:	5b                   	pop    %ebx
  800bb4:	5e                   	pop    %esi
  800bb5:	5d                   	pop    %ebp
  800bb6:	c3                   	ret    

00800bb7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bb7:	f3 0f 1e fb          	endbr32 
  800bbb:	55                   	push   %ebp
  800bbc:	89 e5                	mov    %esp,%ebp
  800bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bc4:	89 c2                	mov    %eax,%edx
  800bc6:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bc9:	39 d0                	cmp    %edx,%eax
  800bcb:	73 09                	jae    800bd6 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bcd:	38 08                	cmp    %cl,(%eax)
  800bcf:	74 05                	je     800bd6 <memfind+0x1f>
	for (; s < ends; s++)
  800bd1:	83 c0 01             	add    $0x1,%eax
  800bd4:	eb f3                	jmp    800bc9 <memfind+0x12>
			break;
	return (void *) s;
}
  800bd6:	5d                   	pop    %ebp
  800bd7:	c3                   	ret    

00800bd8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bd8:	f3 0f 1e fb          	endbr32 
  800bdc:	55                   	push   %ebp
  800bdd:	89 e5                	mov    %esp,%ebp
  800bdf:	57                   	push   %edi
  800be0:	56                   	push   %esi
  800be1:	53                   	push   %ebx
  800be2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800be5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800be8:	eb 03                	jmp    800bed <strtol+0x15>
		s++;
  800bea:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bed:	0f b6 01             	movzbl (%ecx),%eax
  800bf0:	3c 20                	cmp    $0x20,%al
  800bf2:	74 f6                	je     800bea <strtol+0x12>
  800bf4:	3c 09                	cmp    $0x9,%al
  800bf6:	74 f2                	je     800bea <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800bf8:	3c 2b                	cmp    $0x2b,%al
  800bfa:	74 2a                	je     800c26 <strtol+0x4e>
	int neg = 0;
  800bfc:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c01:	3c 2d                	cmp    $0x2d,%al
  800c03:	74 2b                	je     800c30 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c05:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c0b:	75 0f                	jne    800c1c <strtol+0x44>
  800c0d:	80 39 30             	cmpb   $0x30,(%ecx)
  800c10:	74 28                	je     800c3a <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c12:	85 db                	test   %ebx,%ebx
  800c14:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c19:	0f 44 d8             	cmove  %eax,%ebx
  800c1c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c21:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c24:	eb 46                	jmp    800c6c <strtol+0x94>
		s++;
  800c26:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c29:	bf 00 00 00 00       	mov    $0x0,%edi
  800c2e:	eb d5                	jmp    800c05 <strtol+0x2d>
		s++, neg = 1;
  800c30:	83 c1 01             	add    $0x1,%ecx
  800c33:	bf 01 00 00 00       	mov    $0x1,%edi
  800c38:	eb cb                	jmp    800c05 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c3a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c3e:	74 0e                	je     800c4e <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c40:	85 db                	test   %ebx,%ebx
  800c42:	75 d8                	jne    800c1c <strtol+0x44>
		s++, base = 8;
  800c44:	83 c1 01             	add    $0x1,%ecx
  800c47:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c4c:	eb ce                	jmp    800c1c <strtol+0x44>
		s += 2, base = 16;
  800c4e:	83 c1 02             	add    $0x2,%ecx
  800c51:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c56:	eb c4                	jmp    800c1c <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800c58:	0f be d2             	movsbl %dl,%edx
  800c5b:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c5e:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c61:	7d 3a                	jge    800c9d <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c63:	83 c1 01             	add    $0x1,%ecx
  800c66:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c6a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c6c:	0f b6 11             	movzbl (%ecx),%edx
  800c6f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c72:	89 f3                	mov    %esi,%ebx
  800c74:	80 fb 09             	cmp    $0x9,%bl
  800c77:	76 df                	jbe    800c58 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800c79:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c7c:	89 f3                	mov    %esi,%ebx
  800c7e:	80 fb 19             	cmp    $0x19,%bl
  800c81:	77 08                	ja     800c8b <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c83:	0f be d2             	movsbl %dl,%edx
  800c86:	83 ea 57             	sub    $0x57,%edx
  800c89:	eb d3                	jmp    800c5e <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800c8b:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c8e:	89 f3                	mov    %esi,%ebx
  800c90:	80 fb 19             	cmp    $0x19,%bl
  800c93:	77 08                	ja     800c9d <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c95:	0f be d2             	movsbl %dl,%edx
  800c98:	83 ea 37             	sub    $0x37,%edx
  800c9b:	eb c1                	jmp    800c5e <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c9d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ca1:	74 05                	je     800ca8 <strtol+0xd0>
		*endptr = (char *) s;
  800ca3:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ca6:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ca8:	89 c2                	mov    %eax,%edx
  800caa:	f7 da                	neg    %edx
  800cac:	85 ff                	test   %edi,%edi
  800cae:	0f 45 c2             	cmovne %edx,%eax
}
  800cb1:	5b                   	pop    %ebx
  800cb2:	5e                   	pop    %esi
  800cb3:	5f                   	pop    %edi
  800cb4:	5d                   	pop    %ebp
  800cb5:	c3                   	ret    

00800cb6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cb6:	f3 0f 1e fb          	endbr32 
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	57                   	push   %edi
  800cbe:	56                   	push   %esi
  800cbf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cc0:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc5:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ccb:	89 c3                	mov    %eax,%ebx
  800ccd:	89 c7                	mov    %eax,%edi
  800ccf:	89 c6                	mov    %eax,%esi
  800cd1:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cd3:	5b                   	pop    %ebx
  800cd4:	5e                   	pop    %esi
  800cd5:	5f                   	pop    %edi
  800cd6:	5d                   	pop    %ebp
  800cd7:	c3                   	ret    

00800cd8 <sys_cgetc>:

int
sys_cgetc(void)
{
  800cd8:	f3 0f 1e fb          	endbr32 
  800cdc:	55                   	push   %ebp
  800cdd:	89 e5                	mov    %esp,%ebp
  800cdf:	57                   	push   %edi
  800ce0:	56                   	push   %esi
  800ce1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ce2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce7:	b8 01 00 00 00       	mov    $0x1,%eax
  800cec:	89 d1                	mov    %edx,%ecx
  800cee:	89 d3                	mov    %edx,%ebx
  800cf0:	89 d7                	mov    %edx,%edi
  800cf2:	89 d6                	mov    %edx,%esi
  800cf4:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cf6:	5b                   	pop    %ebx
  800cf7:	5e                   	pop    %esi
  800cf8:	5f                   	pop    %edi
  800cf9:	5d                   	pop    %ebp
  800cfa:	c3                   	ret    

00800cfb <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cfb:	f3 0f 1e fb          	endbr32 
  800cff:	55                   	push   %ebp
  800d00:	89 e5                	mov    %esp,%ebp
  800d02:	57                   	push   %edi
  800d03:	56                   	push   %esi
  800d04:	53                   	push   %ebx
  800d05:	83 ec 1c             	sub    $0x1c,%esp
  800d08:	e8 ec fb ff ff       	call   8008f9 <__x86.get_pc_thunk.ax>
  800d0d:	05 f3 12 00 00       	add    $0x12f3,%eax
  800d12:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	asm volatile("int %1\n"
  800d15:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1d:	b8 03 00 00 00       	mov    $0x3,%eax
  800d22:	89 cb                	mov    %ecx,%ebx
  800d24:	89 cf                	mov    %ecx,%edi
  800d26:	89 ce                	mov    %ecx,%esi
  800d28:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d2a:	85 c0                	test   %eax,%eax
  800d2c:	7f 08                	jg     800d36 <sys_env_destroy+0x3b>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d31:	5b                   	pop    %ebx
  800d32:	5e                   	pop    %esi
  800d33:	5f                   	pop    %edi
  800d34:	5d                   	pop    %ebp
  800d35:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d36:	83 ec 0c             	sub    $0xc,%esp
  800d39:	50                   	push   %eax
  800d3a:	6a 03                	push   $0x3
  800d3c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800d3f:	8d 83 b0 f2 ff ff    	lea    -0xd50(%ebx),%eax
  800d45:	50                   	push   %eax
  800d46:	6a 23                	push   $0x23
  800d48:	8d 83 cd f2 ff ff    	lea    -0xd33(%ebx),%eax
  800d4e:	50                   	push   %eax
  800d4f:	e8 3f f4 ff ff       	call   800193 <_panic>

00800d54 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d54:	f3 0f 1e fb          	endbr32 
  800d58:	55                   	push   %ebp
  800d59:	89 e5                	mov    %esp,%ebp
  800d5b:	57                   	push   %edi
  800d5c:	56                   	push   %esi
  800d5d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d5e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d63:	b8 02 00 00 00       	mov    $0x2,%eax
  800d68:	89 d1                	mov    %edx,%ecx
  800d6a:	89 d3                	mov    %edx,%ebx
  800d6c:	89 d7                	mov    %edx,%edi
  800d6e:	89 d6                	mov    %edx,%esi
  800d70:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d72:	5b                   	pop    %ebx
  800d73:	5e                   	pop    %esi
  800d74:	5f                   	pop    %edi
  800d75:	5d                   	pop    %ebp
  800d76:	c3                   	ret    
  800d77:	66 90                	xchg   %ax,%ax
  800d79:	66 90                	xchg   %ax,%ax
  800d7b:	66 90                	xchg   %ax,%ax
  800d7d:	66 90                	xchg   %ax,%ax
  800d7f:	90                   	nop

00800d80 <__udivdi3>:
  800d80:	f3 0f 1e fb          	endbr32 
  800d84:	55                   	push   %ebp
  800d85:	57                   	push   %edi
  800d86:	56                   	push   %esi
  800d87:	53                   	push   %ebx
  800d88:	83 ec 1c             	sub    $0x1c,%esp
  800d8b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800d8f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800d93:	8b 74 24 34          	mov    0x34(%esp),%esi
  800d97:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800d9b:	85 d2                	test   %edx,%edx
  800d9d:	75 19                	jne    800db8 <__udivdi3+0x38>
  800d9f:	39 f3                	cmp    %esi,%ebx
  800da1:	76 4d                	jbe    800df0 <__udivdi3+0x70>
  800da3:	31 ff                	xor    %edi,%edi
  800da5:	89 e8                	mov    %ebp,%eax
  800da7:	89 f2                	mov    %esi,%edx
  800da9:	f7 f3                	div    %ebx
  800dab:	89 fa                	mov    %edi,%edx
  800dad:	83 c4 1c             	add    $0x1c,%esp
  800db0:	5b                   	pop    %ebx
  800db1:	5e                   	pop    %esi
  800db2:	5f                   	pop    %edi
  800db3:	5d                   	pop    %ebp
  800db4:	c3                   	ret    
  800db5:	8d 76 00             	lea    0x0(%esi),%esi
  800db8:	39 f2                	cmp    %esi,%edx
  800dba:	76 14                	jbe    800dd0 <__udivdi3+0x50>
  800dbc:	31 ff                	xor    %edi,%edi
  800dbe:	31 c0                	xor    %eax,%eax
  800dc0:	89 fa                	mov    %edi,%edx
  800dc2:	83 c4 1c             	add    $0x1c,%esp
  800dc5:	5b                   	pop    %ebx
  800dc6:	5e                   	pop    %esi
  800dc7:	5f                   	pop    %edi
  800dc8:	5d                   	pop    %ebp
  800dc9:	c3                   	ret    
  800dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800dd0:	0f bd fa             	bsr    %edx,%edi
  800dd3:	83 f7 1f             	xor    $0x1f,%edi
  800dd6:	75 48                	jne    800e20 <__udivdi3+0xa0>
  800dd8:	39 f2                	cmp    %esi,%edx
  800dda:	72 06                	jb     800de2 <__udivdi3+0x62>
  800ddc:	31 c0                	xor    %eax,%eax
  800dde:	39 eb                	cmp    %ebp,%ebx
  800de0:	77 de                	ja     800dc0 <__udivdi3+0x40>
  800de2:	b8 01 00 00 00       	mov    $0x1,%eax
  800de7:	eb d7                	jmp    800dc0 <__udivdi3+0x40>
  800de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800df0:	89 d9                	mov    %ebx,%ecx
  800df2:	85 db                	test   %ebx,%ebx
  800df4:	75 0b                	jne    800e01 <__udivdi3+0x81>
  800df6:	b8 01 00 00 00       	mov    $0x1,%eax
  800dfb:	31 d2                	xor    %edx,%edx
  800dfd:	f7 f3                	div    %ebx
  800dff:	89 c1                	mov    %eax,%ecx
  800e01:	31 d2                	xor    %edx,%edx
  800e03:	89 f0                	mov    %esi,%eax
  800e05:	f7 f1                	div    %ecx
  800e07:	89 c6                	mov    %eax,%esi
  800e09:	89 e8                	mov    %ebp,%eax
  800e0b:	89 f7                	mov    %esi,%edi
  800e0d:	f7 f1                	div    %ecx
  800e0f:	89 fa                	mov    %edi,%edx
  800e11:	83 c4 1c             	add    $0x1c,%esp
  800e14:	5b                   	pop    %ebx
  800e15:	5e                   	pop    %esi
  800e16:	5f                   	pop    %edi
  800e17:	5d                   	pop    %ebp
  800e18:	c3                   	ret    
  800e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800e20:	89 f9                	mov    %edi,%ecx
  800e22:	b8 20 00 00 00       	mov    $0x20,%eax
  800e27:	29 f8                	sub    %edi,%eax
  800e29:	d3 e2                	shl    %cl,%edx
  800e2b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800e2f:	89 c1                	mov    %eax,%ecx
  800e31:	89 da                	mov    %ebx,%edx
  800e33:	d3 ea                	shr    %cl,%edx
  800e35:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800e39:	09 d1                	or     %edx,%ecx
  800e3b:	89 f2                	mov    %esi,%edx
  800e3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800e41:	89 f9                	mov    %edi,%ecx
  800e43:	d3 e3                	shl    %cl,%ebx
  800e45:	89 c1                	mov    %eax,%ecx
  800e47:	d3 ea                	shr    %cl,%edx
  800e49:	89 f9                	mov    %edi,%ecx
  800e4b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800e4f:	89 eb                	mov    %ebp,%ebx
  800e51:	d3 e6                	shl    %cl,%esi
  800e53:	89 c1                	mov    %eax,%ecx
  800e55:	d3 eb                	shr    %cl,%ebx
  800e57:	09 de                	or     %ebx,%esi
  800e59:	89 f0                	mov    %esi,%eax
  800e5b:	f7 74 24 08          	divl   0x8(%esp)
  800e5f:	89 d6                	mov    %edx,%esi
  800e61:	89 c3                	mov    %eax,%ebx
  800e63:	f7 64 24 0c          	mull   0xc(%esp)
  800e67:	39 d6                	cmp    %edx,%esi
  800e69:	72 15                	jb     800e80 <__udivdi3+0x100>
  800e6b:	89 f9                	mov    %edi,%ecx
  800e6d:	d3 e5                	shl    %cl,%ebp
  800e6f:	39 c5                	cmp    %eax,%ebp
  800e71:	73 04                	jae    800e77 <__udivdi3+0xf7>
  800e73:	39 d6                	cmp    %edx,%esi
  800e75:	74 09                	je     800e80 <__udivdi3+0x100>
  800e77:	89 d8                	mov    %ebx,%eax
  800e79:	31 ff                	xor    %edi,%edi
  800e7b:	e9 40 ff ff ff       	jmp    800dc0 <__udivdi3+0x40>
  800e80:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800e83:	31 ff                	xor    %edi,%edi
  800e85:	e9 36 ff ff ff       	jmp    800dc0 <__udivdi3+0x40>
  800e8a:	66 90                	xchg   %ax,%ax
  800e8c:	66 90                	xchg   %ax,%ax
  800e8e:	66 90                	xchg   %ax,%ax

00800e90 <__umoddi3>:
  800e90:	f3 0f 1e fb          	endbr32 
  800e94:	55                   	push   %ebp
  800e95:	57                   	push   %edi
  800e96:	56                   	push   %esi
  800e97:	53                   	push   %ebx
  800e98:	83 ec 1c             	sub    $0x1c,%esp
  800e9b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800e9f:	8b 74 24 30          	mov    0x30(%esp),%esi
  800ea3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800ea7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800eab:	85 c0                	test   %eax,%eax
  800ead:	75 19                	jne    800ec8 <__umoddi3+0x38>
  800eaf:	39 df                	cmp    %ebx,%edi
  800eb1:	76 5d                	jbe    800f10 <__umoddi3+0x80>
  800eb3:	89 f0                	mov    %esi,%eax
  800eb5:	89 da                	mov    %ebx,%edx
  800eb7:	f7 f7                	div    %edi
  800eb9:	89 d0                	mov    %edx,%eax
  800ebb:	31 d2                	xor    %edx,%edx
  800ebd:	83 c4 1c             	add    $0x1c,%esp
  800ec0:	5b                   	pop    %ebx
  800ec1:	5e                   	pop    %esi
  800ec2:	5f                   	pop    %edi
  800ec3:	5d                   	pop    %ebp
  800ec4:	c3                   	ret    
  800ec5:	8d 76 00             	lea    0x0(%esi),%esi
  800ec8:	89 f2                	mov    %esi,%edx
  800eca:	39 d8                	cmp    %ebx,%eax
  800ecc:	76 12                	jbe    800ee0 <__umoddi3+0x50>
  800ece:	89 f0                	mov    %esi,%eax
  800ed0:	89 da                	mov    %ebx,%edx
  800ed2:	83 c4 1c             	add    $0x1c,%esp
  800ed5:	5b                   	pop    %ebx
  800ed6:	5e                   	pop    %esi
  800ed7:	5f                   	pop    %edi
  800ed8:	5d                   	pop    %ebp
  800ed9:	c3                   	ret    
  800eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800ee0:	0f bd e8             	bsr    %eax,%ebp
  800ee3:	83 f5 1f             	xor    $0x1f,%ebp
  800ee6:	75 50                	jne    800f38 <__umoddi3+0xa8>
  800ee8:	39 d8                	cmp    %ebx,%eax
  800eea:	0f 82 e0 00 00 00    	jb     800fd0 <__umoddi3+0x140>
  800ef0:	89 d9                	mov    %ebx,%ecx
  800ef2:	39 f7                	cmp    %esi,%edi
  800ef4:	0f 86 d6 00 00 00    	jbe    800fd0 <__umoddi3+0x140>
  800efa:	89 d0                	mov    %edx,%eax
  800efc:	89 ca                	mov    %ecx,%edx
  800efe:	83 c4 1c             	add    $0x1c,%esp
  800f01:	5b                   	pop    %ebx
  800f02:	5e                   	pop    %esi
  800f03:	5f                   	pop    %edi
  800f04:	5d                   	pop    %ebp
  800f05:	c3                   	ret    
  800f06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f0d:	8d 76 00             	lea    0x0(%esi),%esi
  800f10:	89 fd                	mov    %edi,%ebp
  800f12:	85 ff                	test   %edi,%edi
  800f14:	75 0b                	jne    800f21 <__umoddi3+0x91>
  800f16:	b8 01 00 00 00       	mov    $0x1,%eax
  800f1b:	31 d2                	xor    %edx,%edx
  800f1d:	f7 f7                	div    %edi
  800f1f:	89 c5                	mov    %eax,%ebp
  800f21:	89 d8                	mov    %ebx,%eax
  800f23:	31 d2                	xor    %edx,%edx
  800f25:	f7 f5                	div    %ebp
  800f27:	89 f0                	mov    %esi,%eax
  800f29:	f7 f5                	div    %ebp
  800f2b:	89 d0                	mov    %edx,%eax
  800f2d:	31 d2                	xor    %edx,%edx
  800f2f:	eb 8c                	jmp    800ebd <__umoddi3+0x2d>
  800f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f38:	89 e9                	mov    %ebp,%ecx
  800f3a:	ba 20 00 00 00       	mov    $0x20,%edx
  800f3f:	29 ea                	sub    %ebp,%edx
  800f41:	d3 e0                	shl    %cl,%eax
  800f43:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f47:	89 d1                	mov    %edx,%ecx
  800f49:	89 f8                	mov    %edi,%eax
  800f4b:	d3 e8                	shr    %cl,%eax
  800f4d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800f51:	89 54 24 04          	mov    %edx,0x4(%esp)
  800f55:	8b 54 24 04          	mov    0x4(%esp),%edx
  800f59:	09 c1                	or     %eax,%ecx
  800f5b:	89 d8                	mov    %ebx,%eax
  800f5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800f61:	89 e9                	mov    %ebp,%ecx
  800f63:	d3 e7                	shl    %cl,%edi
  800f65:	89 d1                	mov    %edx,%ecx
  800f67:	d3 e8                	shr    %cl,%eax
  800f69:	89 e9                	mov    %ebp,%ecx
  800f6b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800f6f:	d3 e3                	shl    %cl,%ebx
  800f71:	89 c7                	mov    %eax,%edi
  800f73:	89 d1                	mov    %edx,%ecx
  800f75:	89 f0                	mov    %esi,%eax
  800f77:	d3 e8                	shr    %cl,%eax
  800f79:	89 e9                	mov    %ebp,%ecx
  800f7b:	89 fa                	mov    %edi,%edx
  800f7d:	d3 e6                	shl    %cl,%esi
  800f7f:	09 d8                	or     %ebx,%eax
  800f81:	f7 74 24 08          	divl   0x8(%esp)
  800f85:	89 d1                	mov    %edx,%ecx
  800f87:	89 f3                	mov    %esi,%ebx
  800f89:	f7 64 24 0c          	mull   0xc(%esp)
  800f8d:	89 c6                	mov    %eax,%esi
  800f8f:	89 d7                	mov    %edx,%edi
  800f91:	39 d1                	cmp    %edx,%ecx
  800f93:	72 06                	jb     800f9b <__umoddi3+0x10b>
  800f95:	75 10                	jne    800fa7 <__umoddi3+0x117>
  800f97:	39 c3                	cmp    %eax,%ebx
  800f99:	73 0c                	jae    800fa7 <__umoddi3+0x117>
  800f9b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  800f9f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  800fa3:	89 d7                	mov    %edx,%edi
  800fa5:	89 c6                	mov    %eax,%esi
  800fa7:	89 ca                	mov    %ecx,%edx
  800fa9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800fae:	29 f3                	sub    %esi,%ebx
  800fb0:	19 fa                	sbb    %edi,%edx
  800fb2:	89 d0                	mov    %edx,%eax
  800fb4:	d3 e0                	shl    %cl,%eax
  800fb6:	89 e9                	mov    %ebp,%ecx
  800fb8:	d3 eb                	shr    %cl,%ebx
  800fba:	d3 ea                	shr    %cl,%edx
  800fbc:	09 d8                	or     %ebx,%eax
  800fbe:	83 c4 1c             	add    $0x1c,%esp
  800fc1:	5b                   	pop    %ebx
  800fc2:	5e                   	pop    %esi
  800fc3:	5f                   	pop    %edi
  800fc4:	5d                   	pop    %ebp
  800fc5:	c3                   	ret    
  800fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fcd:	8d 76 00             	lea    0x0(%esi),%esi
  800fd0:	29 fe                	sub    %edi,%esi
  800fd2:	19 c3                	sbb    %eax,%ebx
  800fd4:	89 f2                	mov    %esi,%edx
  800fd6:	89 d9                	mov    %ebx,%ecx
  800fd8:	e9 1d ff ff ff       	jmp    800efa <__umoddi3+0x6a>
