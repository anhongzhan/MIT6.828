
obj/user/forktree.debug:     file format elf32-i386


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
  80002c:	e8 be 00 00 00       	call   8000ef <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <forktree>:
	}
}

void
forktree(const char *cur)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	53                   	push   %ebx
  80003b:	83 ec 04             	sub    $0x4,%esp
  80003e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  800041:	e8 b4 0b 00 00       	call   800bfa <sys_getenvid>
  800046:	83 ec 04             	sub    $0x4,%esp
  800049:	53                   	push   %ebx
  80004a:	50                   	push   %eax
  80004b:	68 a0 28 80 00       	push   $0x8028a0
  800050:	e8 9f 01 00 00       	call   8001f4 <cprintf>

	forkchild(cur, '0');
  800055:	83 c4 08             	add    $0x8,%esp
  800058:	6a 30                	push   $0x30
  80005a:	53                   	push   %ebx
  80005b:	e8 13 00 00 00       	call   800073 <forkchild>
	forkchild(cur, '1');
  800060:	83 c4 08             	add    $0x8,%esp
  800063:	6a 31                	push   $0x31
  800065:	53                   	push   %ebx
  800066:	e8 08 00 00 00       	call   800073 <forkchild>
}
  80006b:	83 c4 10             	add    $0x10,%esp
  80006e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800071:	c9                   	leave  
  800072:	c3                   	ret    

00800073 <forkchild>:
{
  800073:	f3 0f 1e fb          	endbr32 
  800077:	55                   	push   %ebp
  800078:	89 e5                	mov    %esp,%ebp
  80007a:	56                   	push   %esi
  80007b:	53                   	push   %ebx
  80007c:	83 ec 1c             	sub    $0x1c,%esp
  80007f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800082:	8b 75 0c             	mov    0xc(%ebp),%esi
	if (strlen(cur) >= DEPTH)
  800085:	53                   	push   %ebx
  800086:	e8 30 07 00 00       	call   8007bb <strlen>
  80008b:	83 c4 10             	add    $0x10,%esp
  80008e:	83 f8 02             	cmp    $0x2,%eax
  800091:	7e 07                	jle    80009a <forkchild+0x27>
}
  800093:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800096:	5b                   	pop    %ebx
  800097:	5e                   	pop    %esi
  800098:	5d                   	pop    %ebp
  800099:	c3                   	ret    
	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
  80009a:	83 ec 0c             	sub    $0xc,%esp
  80009d:	89 f0                	mov    %esi,%eax
  80009f:	0f be f0             	movsbl %al,%esi
  8000a2:	56                   	push   %esi
  8000a3:	53                   	push   %ebx
  8000a4:	68 b1 28 80 00       	push   $0x8028b1
  8000a9:	6a 04                	push   $0x4
  8000ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000ae:	50                   	push   %eax
  8000af:	e8 e9 06 00 00       	call   80079d <snprintf>
	if (fork() == 0) {
  8000b4:	83 c4 20             	add    $0x20,%esp
  8000b7:	e8 24 0f 00 00       	call   800fe0 <fork>
  8000bc:	85 c0                	test   %eax,%eax
  8000be:	75 d3                	jne    800093 <forkchild+0x20>
		forktree(nxt);
  8000c0:	83 ec 0c             	sub    $0xc,%esp
  8000c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000c6:	50                   	push   %eax
  8000c7:	e8 67 ff ff ff       	call   800033 <forktree>
		exit();
  8000cc:	e8 68 00 00 00       	call   800139 <exit>
  8000d1:	83 c4 10             	add    $0x10,%esp
  8000d4:	eb bd                	jmp    800093 <forkchild+0x20>

008000d6 <umain>:

void
umain(int argc, char **argv)
{
  8000d6:	f3 0f 1e fb          	endbr32 
  8000da:	55                   	push   %ebp
  8000db:	89 e5                	mov    %esp,%ebp
  8000dd:	83 ec 14             	sub    $0x14,%esp
	forktree("");
  8000e0:	68 b0 28 80 00       	push   $0x8028b0
  8000e5:	e8 49 ff ff ff       	call   800033 <forktree>
}
  8000ea:	83 c4 10             	add    $0x10,%esp
  8000ed:	c9                   	leave  
  8000ee:	c3                   	ret    

008000ef <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000ef:	f3 0f 1e fb          	endbr32 
  8000f3:	55                   	push   %ebp
  8000f4:	89 e5                	mov    %esp,%ebp
  8000f6:	56                   	push   %esi
  8000f7:	53                   	push   %ebx
  8000f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000fb:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000fe:	e8 f7 0a 00 00       	call   800bfa <sys_getenvid>
  800103:	25 ff 03 00 00       	and    $0x3ff,%eax
  800108:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80010b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800110:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800115:	85 db                	test   %ebx,%ebx
  800117:	7e 07                	jle    800120 <libmain+0x31>
		binaryname = argv[0];
  800119:	8b 06                	mov    (%esi),%eax
  80011b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800120:	83 ec 08             	sub    $0x8,%esp
  800123:	56                   	push   %esi
  800124:	53                   	push   %ebx
  800125:	e8 ac ff ff ff       	call   8000d6 <umain>

	// exit gracefully
	exit();
  80012a:	e8 0a 00 00 00       	call   800139 <exit>
}
  80012f:	83 c4 10             	add    $0x10,%esp
  800132:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800135:	5b                   	pop    %ebx
  800136:	5e                   	pop    %esi
  800137:	5d                   	pop    %ebp
  800138:	c3                   	ret    

00800139 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800139:	f3 0f 1e fb          	endbr32 
  80013d:	55                   	push   %ebp
  80013e:	89 e5                	mov    %esp,%ebp
  800140:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800143:	e8 a5 12 00 00       	call   8013ed <close_all>
	sys_env_destroy(0);
  800148:	83 ec 0c             	sub    $0xc,%esp
  80014b:	6a 00                	push   $0x0
  80014d:	e8 63 0a 00 00       	call   800bb5 <sys_env_destroy>
}
  800152:	83 c4 10             	add    $0x10,%esp
  800155:	c9                   	leave  
  800156:	c3                   	ret    

00800157 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800157:	f3 0f 1e fb          	endbr32 
  80015b:	55                   	push   %ebp
  80015c:	89 e5                	mov    %esp,%ebp
  80015e:	53                   	push   %ebx
  80015f:	83 ec 04             	sub    $0x4,%esp
  800162:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800165:	8b 13                	mov    (%ebx),%edx
  800167:	8d 42 01             	lea    0x1(%edx),%eax
  80016a:	89 03                	mov    %eax,(%ebx)
  80016c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80016f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800173:	3d ff 00 00 00       	cmp    $0xff,%eax
  800178:	74 09                	je     800183 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80017a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80017e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800181:	c9                   	leave  
  800182:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800183:	83 ec 08             	sub    $0x8,%esp
  800186:	68 ff 00 00 00       	push   $0xff
  80018b:	8d 43 08             	lea    0x8(%ebx),%eax
  80018e:	50                   	push   %eax
  80018f:	e8 dc 09 00 00       	call   800b70 <sys_cputs>
		b->idx = 0;
  800194:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80019a:	83 c4 10             	add    $0x10,%esp
  80019d:	eb db                	jmp    80017a <putch+0x23>

0080019f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80019f:	f3 0f 1e fb          	endbr32 
  8001a3:	55                   	push   %ebp
  8001a4:	89 e5                	mov    %esp,%ebp
  8001a6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001ac:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001b3:	00 00 00 
	b.cnt = 0;
  8001b6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001bd:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001c0:	ff 75 0c             	pushl  0xc(%ebp)
  8001c3:	ff 75 08             	pushl  0x8(%ebp)
  8001c6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001cc:	50                   	push   %eax
  8001cd:	68 57 01 80 00       	push   $0x800157
  8001d2:	e8 20 01 00 00       	call   8002f7 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001d7:	83 c4 08             	add    $0x8,%esp
  8001da:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001e0:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001e6:	50                   	push   %eax
  8001e7:	e8 84 09 00 00       	call   800b70 <sys_cputs>

	return b.cnt;
}
  8001ec:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001f2:	c9                   	leave  
  8001f3:	c3                   	ret    

008001f4 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001f4:	f3 0f 1e fb          	endbr32 
  8001f8:	55                   	push   %ebp
  8001f9:	89 e5                	mov    %esp,%ebp
  8001fb:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001fe:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800201:	50                   	push   %eax
  800202:	ff 75 08             	pushl  0x8(%ebp)
  800205:	e8 95 ff ff ff       	call   80019f <vcprintf>
	va_end(ap);

	return cnt;
}
  80020a:	c9                   	leave  
  80020b:	c3                   	ret    

0080020c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80020c:	55                   	push   %ebp
  80020d:	89 e5                	mov    %esp,%ebp
  80020f:	57                   	push   %edi
  800210:	56                   	push   %esi
  800211:	53                   	push   %ebx
  800212:	83 ec 1c             	sub    $0x1c,%esp
  800215:	89 c7                	mov    %eax,%edi
  800217:	89 d6                	mov    %edx,%esi
  800219:	8b 45 08             	mov    0x8(%ebp),%eax
  80021c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80021f:	89 d1                	mov    %edx,%ecx
  800221:	89 c2                	mov    %eax,%edx
  800223:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800226:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800229:	8b 45 10             	mov    0x10(%ebp),%eax
  80022c:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80022f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800232:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800239:	39 c2                	cmp    %eax,%edx
  80023b:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80023e:	72 3e                	jb     80027e <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800240:	83 ec 0c             	sub    $0xc,%esp
  800243:	ff 75 18             	pushl  0x18(%ebp)
  800246:	83 eb 01             	sub    $0x1,%ebx
  800249:	53                   	push   %ebx
  80024a:	50                   	push   %eax
  80024b:	83 ec 08             	sub    $0x8,%esp
  80024e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800251:	ff 75 e0             	pushl  -0x20(%ebp)
  800254:	ff 75 dc             	pushl  -0x24(%ebp)
  800257:	ff 75 d8             	pushl  -0x28(%ebp)
  80025a:	e8 e1 23 00 00       	call   802640 <__udivdi3>
  80025f:	83 c4 18             	add    $0x18,%esp
  800262:	52                   	push   %edx
  800263:	50                   	push   %eax
  800264:	89 f2                	mov    %esi,%edx
  800266:	89 f8                	mov    %edi,%eax
  800268:	e8 9f ff ff ff       	call   80020c <printnum>
  80026d:	83 c4 20             	add    $0x20,%esp
  800270:	eb 13                	jmp    800285 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	56                   	push   %esi
  800276:	ff 75 18             	pushl  0x18(%ebp)
  800279:	ff d7                	call   *%edi
  80027b:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80027e:	83 eb 01             	sub    $0x1,%ebx
  800281:	85 db                	test   %ebx,%ebx
  800283:	7f ed                	jg     800272 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800285:	83 ec 08             	sub    $0x8,%esp
  800288:	56                   	push   %esi
  800289:	83 ec 04             	sub    $0x4,%esp
  80028c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80028f:	ff 75 e0             	pushl  -0x20(%ebp)
  800292:	ff 75 dc             	pushl  -0x24(%ebp)
  800295:	ff 75 d8             	pushl  -0x28(%ebp)
  800298:	e8 b3 24 00 00       	call   802750 <__umoddi3>
  80029d:	83 c4 14             	add    $0x14,%esp
  8002a0:	0f be 80 c0 28 80 00 	movsbl 0x8028c0(%eax),%eax
  8002a7:	50                   	push   %eax
  8002a8:	ff d7                	call   *%edi
}
  8002aa:	83 c4 10             	add    $0x10,%esp
  8002ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b0:	5b                   	pop    %ebx
  8002b1:	5e                   	pop    %esi
  8002b2:	5f                   	pop    %edi
  8002b3:	5d                   	pop    %ebp
  8002b4:	c3                   	ret    

008002b5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002b5:	f3 0f 1e fb          	endbr32 
  8002b9:	55                   	push   %ebp
  8002ba:	89 e5                	mov    %esp,%ebp
  8002bc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002bf:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002c3:	8b 10                	mov    (%eax),%edx
  8002c5:	3b 50 04             	cmp    0x4(%eax),%edx
  8002c8:	73 0a                	jae    8002d4 <sprintputch+0x1f>
		*b->buf++ = ch;
  8002ca:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002cd:	89 08                	mov    %ecx,(%eax)
  8002cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d2:	88 02                	mov    %al,(%edx)
}
  8002d4:	5d                   	pop    %ebp
  8002d5:	c3                   	ret    

008002d6 <printfmt>:
{
  8002d6:	f3 0f 1e fb          	endbr32 
  8002da:	55                   	push   %ebp
  8002db:	89 e5                	mov    %esp,%ebp
  8002dd:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002e0:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002e3:	50                   	push   %eax
  8002e4:	ff 75 10             	pushl  0x10(%ebp)
  8002e7:	ff 75 0c             	pushl  0xc(%ebp)
  8002ea:	ff 75 08             	pushl  0x8(%ebp)
  8002ed:	e8 05 00 00 00       	call   8002f7 <vprintfmt>
}
  8002f2:	83 c4 10             	add    $0x10,%esp
  8002f5:	c9                   	leave  
  8002f6:	c3                   	ret    

008002f7 <vprintfmt>:
{
  8002f7:	f3 0f 1e fb          	endbr32 
  8002fb:	55                   	push   %ebp
  8002fc:	89 e5                	mov    %esp,%ebp
  8002fe:	57                   	push   %edi
  8002ff:	56                   	push   %esi
  800300:	53                   	push   %ebx
  800301:	83 ec 3c             	sub    $0x3c,%esp
  800304:	8b 75 08             	mov    0x8(%ebp),%esi
  800307:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80030a:	8b 7d 10             	mov    0x10(%ebp),%edi
  80030d:	e9 8e 03 00 00       	jmp    8006a0 <vprintfmt+0x3a9>
		padc = ' ';
  800312:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800316:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80031d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800324:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80032b:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800330:	8d 47 01             	lea    0x1(%edi),%eax
  800333:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800336:	0f b6 17             	movzbl (%edi),%edx
  800339:	8d 42 dd             	lea    -0x23(%edx),%eax
  80033c:	3c 55                	cmp    $0x55,%al
  80033e:	0f 87 df 03 00 00    	ja     800723 <vprintfmt+0x42c>
  800344:	0f b6 c0             	movzbl %al,%eax
  800347:	3e ff 24 85 00 2a 80 	notrack jmp *0x802a00(,%eax,4)
  80034e:	00 
  80034f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800352:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800356:	eb d8                	jmp    800330 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800358:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80035b:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80035f:	eb cf                	jmp    800330 <vprintfmt+0x39>
  800361:	0f b6 d2             	movzbl %dl,%edx
  800364:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800367:	b8 00 00 00 00       	mov    $0x0,%eax
  80036c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80036f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800372:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800376:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800379:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80037c:	83 f9 09             	cmp    $0x9,%ecx
  80037f:	77 55                	ja     8003d6 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800381:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800384:	eb e9                	jmp    80036f <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800386:	8b 45 14             	mov    0x14(%ebp),%eax
  800389:	8b 00                	mov    (%eax),%eax
  80038b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80038e:	8b 45 14             	mov    0x14(%ebp),%eax
  800391:	8d 40 04             	lea    0x4(%eax),%eax
  800394:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800397:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80039a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80039e:	79 90                	jns    800330 <vprintfmt+0x39>
				width = precision, precision = -1;
  8003a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003a6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003ad:	eb 81                	jmp    800330 <vprintfmt+0x39>
  8003af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b2:	85 c0                	test   %eax,%eax
  8003b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b9:	0f 49 d0             	cmovns %eax,%edx
  8003bc:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003c2:	e9 69 ff ff ff       	jmp    800330 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003ca:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003d1:	e9 5a ff ff ff       	jmp    800330 <vprintfmt+0x39>
  8003d6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003dc:	eb bc                	jmp    80039a <vprintfmt+0xa3>
			lflag++;
  8003de:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003e1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003e4:	e9 47 ff ff ff       	jmp    800330 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8003e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ec:	8d 78 04             	lea    0x4(%eax),%edi
  8003ef:	83 ec 08             	sub    $0x8,%esp
  8003f2:	53                   	push   %ebx
  8003f3:	ff 30                	pushl  (%eax)
  8003f5:	ff d6                	call   *%esi
			break;
  8003f7:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003fa:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003fd:	e9 9b 02 00 00       	jmp    80069d <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800402:	8b 45 14             	mov    0x14(%ebp),%eax
  800405:	8d 78 04             	lea    0x4(%eax),%edi
  800408:	8b 00                	mov    (%eax),%eax
  80040a:	99                   	cltd   
  80040b:	31 d0                	xor    %edx,%eax
  80040d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80040f:	83 f8 0f             	cmp    $0xf,%eax
  800412:	7f 23                	jg     800437 <vprintfmt+0x140>
  800414:	8b 14 85 60 2b 80 00 	mov    0x802b60(,%eax,4),%edx
  80041b:	85 d2                	test   %edx,%edx
  80041d:	74 18                	je     800437 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80041f:	52                   	push   %edx
  800420:	68 25 2d 80 00       	push   $0x802d25
  800425:	53                   	push   %ebx
  800426:	56                   	push   %esi
  800427:	e8 aa fe ff ff       	call   8002d6 <printfmt>
  80042c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80042f:	89 7d 14             	mov    %edi,0x14(%ebp)
  800432:	e9 66 02 00 00       	jmp    80069d <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800437:	50                   	push   %eax
  800438:	68 d8 28 80 00       	push   $0x8028d8
  80043d:	53                   	push   %ebx
  80043e:	56                   	push   %esi
  80043f:	e8 92 fe ff ff       	call   8002d6 <printfmt>
  800444:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800447:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80044a:	e9 4e 02 00 00       	jmp    80069d <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  80044f:	8b 45 14             	mov    0x14(%ebp),%eax
  800452:	83 c0 04             	add    $0x4,%eax
  800455:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800458:	8b 45 14             	mov    0x14(%ebp),%eax
  80045b:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80045d:	85 d2                	test   %edx,%edx
  80045f:	b8 d1 28 80 00       	mov    $0x8028d1,%eax
  800464:	0f 45 c2             	cmovne %edx,%eax
  800467:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80046a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80046e:	7e 06                	jle    800476 <vprintfmt+0x17f>
  800470:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800474:	75 0d                	jne    800483 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  800476:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800479:	89 c7                	mov    %eax,%edi
  80047b:	03 45 e0             	add    -0x20(%ebp),%eax
  80047e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800481:	eb 55                	jmp    8004d8 <vprintfmt+0x1e1>
  800483:	83 ec 08             	sub    $0x8,%esp
  800486:	ff 75 d8             	pushl  -0x28(%ebp)
  800489:	ff 75 cc             	pushl  -0x34(%ebp)
  80048c:	e8 46 03 00 00       	call   8007d7 <strnlen>
  800491:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800494:	29 c2                	sub    %eax,%edx
  800496:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800499:	83 c4 10             	add    $0x10,%esp
  80049c:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80049e:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a5:	85 ff                	test   %edi,%edi
  8004a7:	7e 11                	jle    8004ba <vprintfmt+0x1c3>
					putch(padc, putdat);
  8004a9:	83 ec 08             	sub    $0x8,%esp
  8004ac:	53                   	push   %ebx
  8004ad:	ff 75 e0             	pushl  -0x20(%ebp)
  8004b0:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b2:	83 ef 01             	sub    $0x1,%edi
  8004b5:	83 c4 10             	add    $0x10,%esp
  8004b8:	eb eb                	jmp    8004a5 <vprintfmt+0x1ae>
  8004ba:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004bd:	85 d2                	test   %edx,%edx
  8004bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c4:	0f 49 c2             	cmovns %edx,%eax
  8004c7:	29 c2                	sub    %eax,%edx
  8004c9:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004cc:	eb a8                	jmp    800476 <vprintfmt+0x17f>
					putch(ch, putdat);
  8004ce:	83 ec 08             	sub    $0x8,%esp
  8004d1:	53                   	push   %ebx
  8004d2:	52                   	push   %edx
  8004d3:	ff d6                	call   *%esi
  8004d5:	83 c4 10             	add    $0x10,%esp
  8004d8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004db:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004dd:	83 c7 01             	add    $0x1,%edi
  8004e0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004e4:	0f be d0             	movsbl %al,%edx
  8004e7:	85 d2                	test   %edx,%edx
  8004e9:	74 4b                	je     800536 <vprintfmt+0x23f>
  8004eb:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004ef:	78 06                	js     8004f7 <vprintfmt+0x200>
  8004f1:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004f5:	78 1e                	js     800515 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004f7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004fb:	74 d1                	je     8004ce <vprintfmt+0x1d7>
  8004fd:	0f be c0             	movsbl %al,%eax
  800500:	83 e8 20             	sub    $0x20,%eax
  800503:	83 f8 5e             	cmp    $0x5e,%eax
  800506:	76 c6                	jbe    8004ce <vprintfmt+0x1d7>
					putch('?', putdat);
  800508:	83 ec 08             	sub    $0x8,%esp
  80050b:	53                   	push   %ebx
  80050c:	6a 3f                	push   $0x3f
  80050e:	ff d6                	call   *%esi
  800510:	83 c4 10             	add    $0x10,%esp
  800513:	eb c3                	jmp    8004d8 <vprintfmt+0x1e1>
  800515:	89 cf                	mov    %ecx,%edi
  800517:	eb 0e                	jmp    800527 <vprintfmt+0x230>
				putch(' ', putdat);
  800519:	83 ec 08             	sub    $0x8,%esp
  80051c:	53                   	push   %ebx
  80051d:	6a 20                	push   $0x20
  80051f:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800521:	83 ef 01             	sub    $0x1,%edi
  800524:	83 c4 10             	add    $0x10,%esp
  800527:	85 ff                	test   %edi,%edi
  800529:	7f ee                	jg     800519 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  80052b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80052e:	89 45 14             	mov    %eax,0x14(%ebp)
  800531:	e9 67 01 00 00       	jmp    80069d <vprintfmt+0x3a6>
  800536:	89 cf                	mov    %ecx,%edi
  800538:	eb ed                	jmp    800527 <vprintfmt+0x230>
	if (lflag >= 2)
  80053a:	83 f9 01             	cmp    $0x1,%ecx
  80053d:	7f 1b                	jg     80055a <vprintfmt+0x263>
	else if (lflag)
  80053f:	85 c9                	test   %ecx,%ecx
  800541:	74 63                	je     8005a6 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800543:	8b 45 14             	mov    0x14(%ebp),%eax
  800546:	8b 00                	mov    (%eax),%eax
  800548:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80054b:	99                   	cltd   
  80054c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80054f:	8b 45 14             	mov    0x14(%ebp),%eax
  800552:	8d 40 04             	lea    0x4(%eax),%eax
  800555:	89 45 14             	mov    %eax,0x14(%ebp)
  800558:	eb 17                	jmp    800571 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  80055a:	8b 45 14             	mov    0x14(%ebp),%eax
  80055d:	8b 50 04             	mov    0x4(%eax),%edx
  800560:	8b 00                	mov    (%eax),%eax
  800562:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800565:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800568:	8b 45 14             	mov    0x14(%ebp),%eax
  80056b:	8d 40 08             	lea    0x8(%eax),%eax
  80056e:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800571:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800574:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800577:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80057c:	85 c9                	test   %ecx,%ecx
  80057e:	0f 89 ff 00 00 00    	jns    800683 <vprintfmt+0x38c>
				putch('-', putdat);
  800584:	83 ec 08             	sub    $0x8,%esp
  800587:	53                   	push   %ebx
  800588:	6a 2d                	push   $0x2d
  80058a:	ff d6                	call   *%esi
				num = -(long long) num;
  80058c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80058f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800592:	f7 da                	neg    %edx
  800594:	83 d1 00             	adc    $0x0,%ecx
  800597:	f7 d9                	neg    %ecx
  800599:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80059c:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005a1:	e9 dd 00 00 00       	jmp    800683 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8005a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a9:	8b 00                	mov    (%eax),%eax
  8005ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ae:	99                   	cltd   
  8005af:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b5:	8d 40 04             	lea    0x4(%eax),%eax
  8005b8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005bb:	eb b4                	jmp    800571 <vprintfmt+0x27a>
	if (lflag >= 2)
  8005bd:	83 f9 01             	cmp    $0x1,%ecx
  8005c0:	7f 1e                	jg     8005e0 <vprintfmt+0x2e9>
	else if (lflag)
  8005c2:	85 c9                	test   %ecx,%ecx
  8005c4:	74 32                	je     8005f8 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8005c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c9:	8b 10                	mov    (%eax),%edx
  8005cb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005d0:	8d 40 04             	lea    0x4(%eax),%eax
  8005d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005d6:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8005db:	e9 a3 00 00 00       	jmp    800683 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e3:	8b 10                	mov    (%eax),%edx
  8005e5:	8b 48 04             	mov    0x4(%eax),%ecx
  8005e8:	8d 40 08             	lea    0x8(%eax),%eax
  8005eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ee:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8005f3:	e9 8b 00 00 00       	jmp    800683 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fb:	8b 10                	mov    (%eax),%edx
  8005fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800602:	8d 40 04             	lea    0x4(%eax),%eax
  800605:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800608:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  80060d:	eb 74                	jmp    800683 <vprintfmt+0x38c>
	if (lflag >= 2)
  80060f:	83 f9 01             	cmp    $0x1,%ecx
  800612:	7f 1b                	jg     80062f <vprintfmt+0x338>
	else if (lflag)
  800614:	85 c9                	test   %ecx,%ecx
  800616:	74 2c                	je     800644 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800618:	8b 45 14             	mov    0x14(%ebp),%eax
  80061b:	8b 10                	mov    (%eax),%edx
  80061d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800622:	8d 40 04             	lea    0x4(%eax),%eax
  800625:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800628:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  80062d:	eb 54                	jmp    800683 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80062f:	8b 45 14             	mov    0x14(%ebp),%eax
  800632:	8b 10                	mov    (%eax),%edx
  800634:	8b 48 04             	mov    0x4(%eax),%ecx
  800637:	8d 40 08             	lea    0x8(%eax),%eax
  80063a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80063d:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800642:	eb 3f                	jmp    800683 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800644:	8b 45 14             	mov    0x14(%ebp),%eax
  800647:	8b 10                	mov    (%eax),%edx
  800649:	b9 00 00 00 00       	mov    $0x0,%ecx
  80064e:	8d 40 04             	lea    0x4(%eax),%eax
  800651:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800654:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800659:	eb 28                	jmp    800683 <vprintfmt+0x38c>
			putch('0', putdat);
  80065b:	83 ec 08             	sub    $0x8,%esp
  80065e:	53                   	push   %ebx
  80065f:	6a 30                	push   $0x30
  800661:	ff d6                	call   *%esi
			putch('x', putdat);
  800663:	83 c4 08             	add    $0x8,%esp
  800666:	53                   	push   %ebx
  800667:	6a 78                	push   $0x78
  800669:	ff d6                	call   *%esi
			num = (unsigned long long)
  80066b:	8b 45 14             	mov    0x14(%ebp),%eax
  80066e:	8b 10                	mov    (%eax),%edx
  800670:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800675:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800678:	8d 40 04             	lea    0x4(%eax),%eax
  80067b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80067e:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800683:	83 ec 0c             	sub    $0xc,%esp
  800686:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80068a:	57                   	push   %edi
  80068b:	ff 75 e0             	pushl  -0x20(%ebp)
  80068e:	50                   	push   %eax
  80068f:	51                   	push   %ecx
  800690:	52                   	push   %edx
  800691:	89 da                	mov    %ebx,%edx
  800693:	89 f0                	mov    %esi,%eax
  800695:	e8 72 fb ff ff       	call   80020c <printnum>
			break;
  80069a:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80069d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006a0:	83 c7 01             	add    $0x1,%edi
  8006a3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006a7:	83 f8 25             	cmp    $0x25,%eax
  8006aa:	0f 84 62 fc ff ff    	je     800312 <vprintfmt+0x1b>
			if (ch == '\0')
  8006b0:	85 c0                	test   %eax,%eax
  8006b2:	0f 84 8b 00 00 00    	je     800743 <vprintfmt+0x44c>
			putch(ch, putdat);
  8006b8:	83 ec 08             	sub    $0x8,%esp
  8006bb:	53                   	push   %ebx
  8006bc:	50                   	push   %eax
  8006bd:	ff d6                	call   *%esi
  8006bf:	83 c4 10             	add    $0x10,%esp
  8006c2:	eb dc                	jmp    8006a0 <vprintfmt+0x3a9>
	if (lflag >= 2)
  8006c4:	83 f9 01             	cmp    $0x1,%ecx
  8006c7:	7f 1b                	jg     8006e4 <vprintfmt+0x3ed>
	else if (lflag)
  8006c9:	85 c9                	test   %ecx,%ecx
  8006cb:	74 2c                	je     8006f9 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8006cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d0:	8b 10                	mov    (%eax),%edx
  8006d2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006d7:	8d 40 04             	lea    0x4(%eax),%eax
  8006da:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006dd:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8006e2:	eb 9f                	jmp    800683 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8006e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e7:	8b 10                	mov    (%eax),%edx
  8006e9:	8b 48 04             	mov    0x4(%eax),%ecx
  8006ec:	8d 40 08             	lea    0x8(%eax),%eax
  8006ef:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006f2:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8006f7:	eb 8a                	jmp    800683 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fc:	8b 10                	mov    (%eax),%edx
  8006fe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800703:	8d 40 04             	lea    0x4(%eax),%eax
  800706:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800709:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  80070e:	e9 70 ff ff ff       	jmp    800683 <vprintfmt+0x38c>
			putch(ch, putdat);
  800713:	83 ec 08             	sub    $0x8,%esp
  800716:	53                   	push   %ebx
  800717:	6a 25                	push   $0x25
  800719:	ff d6                	call   *%esi
			break;
  80071b:	83 c4 10             	add    $0x10,%esp
  80071e:	e9 7a ff ff ff       	jmp    80069d <vprintfmt+0x3a6>
			putch('%', putdat);
  800723:	83 ec 08             	sub    $0x8,%esp
  800726:	53                   	push   %ebx
  800727:	6a 25                	push   $0x25
  800729:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80072b:	83 c4 10             	add    $0x10,%esp
  80072e:	89 f8                	mov    %edi,%eax
  800730:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800734:	74 05                	je     80073b <vprintfmt+0x444>
  800736:	83 e8 01             	sub    $0x1,%eax
  800739:	eb f5                	jmp    800730 <vprintfmt+0x439>
  80073b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80073e:	e9 5a ff ff ff       	jmp    80069d <vprintfmt+0x3a6>
}
  800743:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800746:	5b                   	pop    %ebx
  800747:	5e                   	pop    %esi
  800748:	5f                   	pop    %edi
  800749:	5d                   	pop    %ebp
  80074a:	c3                   	ret    

0080074b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80074b:	f3 0f 1e fb          	endbr32 
  80074f:	55                   	push   %ebp
  800750:	89 e5                	mov    %esp,%ebp
  800752:	83 ec 18             	sub    $0x18,%esp
  800755:	8b 45 08             	mov    0x8(%ebp),%eax
  800758:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80075b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80075e:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800762:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800765:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80076c:	85 c0                	test   %eax,%eax
  80076e:	74 26                	je     800796 <vsnprintf+0x4b>
  800770:	85 d2                	test   %edx,%edx
  800772:	7e 22                	jle    800796 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800774:	ff 75 14             	pushl  0x14(%ebp)
  800777:	ff 75 10             	pushl  0x10(%ebp)
  80077a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80077d:	50                   	push   %eax
  80077e:	68 b5 02 80 00       	push   $0x8002b5
  800783:	e8 6f fb ff ff       	call   8002f7 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800788:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80078b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80078e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800791:	83 c4 10             	add    $0x10,%esp
}
  800794:	c9                   	leave  
  800795:	c3                   	ret    
		return -E_INVAL;
  800796:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80079b:	eb f7                	jmp    800794 <vsnprintf+0x49>

0080079d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80079d:	f3 0f 1e fb          	endbr32 
  8007a1:	55                   	push   %ebp
  8007a2:	89 e5                	mov    %esp,%ebp
  8007a4:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007a7:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007aa:	50                   	push   %eax
  8007ab:	ff 75 10             	pushl  0x10(%ebp)
  8007ae:	ff 75 0c             	pushl  0xc(%ebp)
  8007b1:	ff 75 08             	pushl  0x8(%ebp)
  8007b4:	e8 92 ff ff ff       	call   80074b <vsnprintf>
	va_end(ap);

	return rc;
}
  8007b9:	c9                   	leave  
  8007ba:	c3                   	ret    

008007bb <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007bb:	f3 0f 1e fb          	endbr32 
  8007bf:	55                   	push   %ebp
  8007c0:	89 e5                	mov    %esp,%ebp
  8007c2:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ca:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007ce:	74 05                	je     8007d5 <strlen+0x1a>
		n++;
  8007d0:	83 c0 01             	add    $0x1,%eax
  8007d3:	eb f5                	jmp    8007ca <strlen+0xf>
	return n;
}
  8007d5:	5d                   	pop    %ebp
  8007d6:	c3                   	ret    

008007d7 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007d7:	f3 0f 1e fb          	endbr32 
  8007db:	55                   	push   %ebp
  8007dc:	89 e5                	mov    %esp,%ebp
  8007de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007e1:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e9:	39 d0                	cmp    %edx,%eax
  8007eb:	74 0d                	je     8007fa <strnlen+0x23>
  8007ed:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007f1:	74 05                	je     8007f8 <strnlen+0x21>
		n++;
  8007f3:	83 c0 01             	add    $0x1,%eax
  8007f6:	eb f1                	jmp    8007e9 <strnlen+0x12>
  8007f8:	89 c2                	mov    %eax,%edx
	return n;
}
  8007fa:	89 d0                	mov    %edx,%eax
  8007fc:	5d                   	pop    %ebp
  8007fd:	c3                   	ret    

008007fe <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007fe:	f3 0f 1e fb          	endbr32 
  800802:	55                   	push   %ebp
  800803:	89 e5                	mov    %esp,%ebp
  800805:	53                   	push   %ebx
  800806:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800809:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80080c:	b8 00 00 00 00       	mov    $0x0,%eax
  800811:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800815:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800818:	83 c0 01             	add    $0x1,%eax
  80081b:	84 d2                	test   %dl,%dl
  80081d:	75 f2                	jne    800811 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  80081f:	89 c8                	mov    %ecx,%eax
  800821:	5b                   	pop    %ebx
  800822:	5d                   	pop    %ebp
  800823:	c3                   	ret    

00800824 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800824:	f3 0f 1e fb          	endbr32 
  800828:	55                   	push   %ebp
  800829:	89 e5                	mov    %esp,%ebp
  80082b:	53                   	push   %ebx
  80082c:	83 ec 10             	sub    $0x10,%esp
  80082f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800832:	53                   	push   %ebx
  800833:	e8 83 ff ff ff       	call   8007bb <strlen>
  800838:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80083b:	ff 75 0c             	pushl  0xc(%ebp)
  80083e:	01 d8                	add    %ebx,%eax
  800840:	50                   	push   %eax
  800841:	e8 b8 ff ff ff       	call   8007fe <strcpy>
	return dst;
}
  800846:	89 d8                	mov    %ebx,%eax
  800848:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80084b:	c9                   	leave  
  80084c:	c3                   	ret    

0080084d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80084d:	f3 0f 1e fb          	endbr32 
  800851:	55                   	push   %ebp
  800852:	89 e5                	mov    %esp,%ebp
  800854:	56                   	push   %esi
  800855:	53                   	push   %ebx
  800856:	8b 75 08             	mov    0x8(%ebp),%esi
  800859:	8b 55 0c             	mov    0xc(%ebp),%edx
  80085c:	89 f3                	mov    %esi,%ebx
  80085e:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800861:	89 f0                	mov    %esi,%eax
  800863:	39 d8                	cmp    %ebx,%eax
  800865:	74 11                	je     800878 <strncpy+0x2b>
		*dst++ = *src;
  800867:	83 c0 01             	add    $0x1,%eax
  80086a:	0f b6 0a             	movzbl (%edx),%ecx
  80086d:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800870:	80 f9 01             	cmp    $0x1,%cl
  800873:	83 da ff             	sbb    $0xffffffff,%edx
  800876:	eb eb                	jmp    800863 <strncpy+0x16>
	}
	return ret;
}
  800878:	89 f0                	mov    %esi,%eax
  80087a:	5b                   	pop    %ebx
  80087b:	5e                   	pop    %esi
  80087c:	5d                   	pop    %ebp
  80087d:	c3                   	ret    

0080087e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80087e:	f3 0f 1e fb          	endbr32 
  800882:	55                   	push   %ebp
  800883:	89 e5                	mov    %esp,%ebp
  800885:	56                   	push   %esi
  800886:	53                   	push   %ebx
  800887:	8b 75 08             	mov    0x8(%ebp),%esi
  80088a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80088d:	8b 55 10             	mov    0x10(%ebp),%edx
  800890:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800892:	85 d2                	test   %edx,%edx
  800894:	74 21                	je     8008b7 <strlcpy+0x39>
  800896:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80089a:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80089c:	39 c2                	cmp    %eax,%edx
  80089e:	74 14                	je     8008b4 <strlcpy+0x36>
  8008a0:	0f b6 19             	movzbl (%ecx),%ebx
  8008a3:	84 db                	test   %bl,%bl
  8008a5:	74 0b                	je     8008b2 <strlcpy+0x34>
			*dst++ = *src++;
  8008a7:	83 c1 01             	add    $0x1,%ecx
  8008aa:	83 c2 01             	add    $0x1,%edx
  8008ad:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008b0:	eb ea                	jmp    80089c <strlcpy+0x1e>
  8008b2:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008b4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008b7:	29 f0                	sub    %esi,%eax
}
  8008b9:	5b                   	pop    %ebx
  8008ba:	5e                   	pop    %esi
  8008bb:	5d                   	pop    %ebp
  8008bc:	c3                   	ret    

008008bd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008bd:	f3 0f 1e fb          	endbr32 
  8008c1:	55                   	push   %ebp
  8008c2:	89 e5                	mov    %esp,%ebp
  8008c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008c7:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008ca:	0f b6 01             	movzbl (%ecx),%eax
  8008cd:	84 c0                	test   %al,%al
  8008cf:	74 0c                	je     8008dd <strcmp+0x20>
  8008d1:	3a 02                	cmp    (%edx),%al
  8008d3:	75 08                	jne    8008dd <strcmp+0x20>
		p++, q++;
  8008d5:	83 c1 01             	add    $0x1,%ecx
  8008d8:	83 c2 01             	add    $0x1,%edx
  8008db:	eb ed                	jmp    8008ca <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008dd:	0f b6 c0             	movzbl %al,%eax
  8008e0:	0f b6 12             	movzbl (%edx),%edx
  8008e3:	29 d0                	sub    %edx,%eax
}
  8008e5:	5d                   	pop    %ebp
  8008e6:	c3                   	ret    

008008e7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008e7:	f3 0f 1e fb          	endbr32 
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
  8008ee:	53                   	push   %ebx
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f5:	89 c3                	mov    %eax,%ebx
  8008f7:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008fa:	eb 06                	jmp    800902 <strncmp+0x1b>
		n--, p++, q++;
  8008fc:	83 c0 01             	add    $0x1,%eax
  8008ff:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800902:	39 d8                	cmp    %ebx,%eax
  800904:	74 16                	je     80091c <strncmp+0x35>
  800906:	0f b6 08             	movzbl (%eax),%ecx
  800909:	84 c9                	test   %cl,%cl
  80090b:	74 04                	je     800911 <strncmp+0x2a>
  80090d:	3a 0a                	cmp    (%edx),%cl
  80090f:	74 eb                	je     8008fc <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800911:	0f b6 00             	movzbl (%eax),%eax
  800914:	0f b6 12             	movzbl (%edx),%edx
  800917:	29 d0                	sub    %edx,%eax
}
  800919:	5b                   	pop    %ebx
  80091a:	5d                   	pop    %ebp
  80091b:	c3                   	ret    
		return 0;
  80091c:	b8 00 00 00 00       	mov    $0x0,%eax
  800921:	eb f6                	jmp    800919 <strncmp+0x32>

00800923 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800923:	f3 0f 1e fb          	endbr32 
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800931:	0f b6 10             	movzbl (%eax),%edx
  800934:	84 d2                	test   %dl,%dl
  800936:	74 09                	je     800941 <strchr+0x1e>
		if (*s == c)
  800938:	38 ca                	cmp    %cl,%dl
  80093a:	74 0a                	je     800946 <strchr+0x23>
	for (; *s; s++)
  80093c:	83 c0 01             	add    $0x1,%eax
  80093f:	eb f0                	jmp    800931 <strchr+0xe>
			return (char *) s;
	return 0;
  800941:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800946:	5d                   	pop    %ebp
  800947:	c3                   	ret    

00800948 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800948:	f3 0f 1e fb          	endbr32 
  80094c:	55                   	push   %ebp
  80094d:	89 e5                	mov    %esp,%ebp
  80094f:	8b 45 08             	mov    0x8(%ebp),%eax
  800952:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800956:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800959:	38 ca                	cmp    %cl,%dl
  80095b:	74 09                	je     800966 <strfind+0x1e>
  80095d:	84 d2                	test   %dl,%dl
  80095f:	74 05                	je     800966 <strfind+0x1e>
	for (; *s; s++)
  800961:	83 c0 01             	add    $0x1,%eax
  800964:	eb f0                	jmp    800956 <strfind+0xe>
			break;
	return (char *) s;
}
  800966:	5d                   	pop    %ebp
  800967:	c3                   	ret    

00800968 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800968:	f3 0f 1e fb          	endbr32 
  80096c:	55                   	push   %ebp
  80096d:	89 e5                	mov    %esp,%ebp
  80096f:	57                   	push   %edi
  800970:	56                   	push   %esi
  800971:	53                   	push   %ebx
  800972:	8b 7d 08             	mov    0x8(%ebp),%edi
  800975:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800978:	85 c9                	test   %ecx,%ecx
  80097a:	74 31                	je     8009ad <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80097c:	89 f8                	mov    %edi,%eax
  80097e:	09 c8                	or     %ecx,%eax
  800980:	a8 03                	test   $0x3,%al
  800982:	75 23                	jne    8009a7 <memset+0x3f>
		c &= 0xFF;
  800984:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800988:	89 d3                	mov    %edx,%ebx
  80098a:	c1 e3 08             	shl    $0x8,%ebx
  80098d:	89 d0                	mov    %edx,%eax
  80098f:	c1 e0 18             	shl    $0x18,%eax
  800992:	89 d6                	mov    %edx,%esi
  800994:	c1 e6 10             	shl    $0x10,%esi
  800997:	09 f0                	or     %esi,%eax
  800999:	09 c2                	or     %eax,%edx
  80099b:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80099d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009a0:	89 d0                	mov    %edx,%eax
  8009a2:	fc                   	cld    
  8009a3:	f3 ab                	rep stos %eax,%es:(%edi)
  8009a5:	eb 06                	jmp    8009ad <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009aa:	fc                   	cld    
  8009ab:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009ad:	89 f8                	mov    %edi,%eax
  8009af:	5b                   	pop    %ebx
  8009b0:	5e                   	pop    %esi
  8009b1:	5f                   	pop    %edi
  8009b2:	5d                   	pop    %ebp
  8009b3:	c3                   	ret    

008009b4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009b4:	f3 0f 1e fb          	endbr32 
  8009b8:	55                   	push   %ebp
  8009b9:	89 e5                	mov    %esp,%ebp
  8009bb:	57                   	push   %edi
  8009bc:	56                   	push   %esi
  8009bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009c6:	39 c6                	cmp    %eax,%esi
  8009c8:	73 32                	jae    8009fc <memmove+0x48>
  8009ca:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009cd:	39 c2                	cmp    %eax,%edx
  8009cf:	76 2b                	jbe    8009fc <memmove+0x48>
		s += n;
		d += n;
  8009d1:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009d4:	89 fe                	mov    %edi,%esi
  8009d6:	09 ce                	or     %ecx,%esi
  8009d8:	09 d6                	or     %edx,%esi
  8009da:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009e0:	75 0e                	jne    8009f0 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009e2:	83 ef 04             	sub    $0x4,%edi
  8009e5:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009e8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009eb:	fd                   	std    
  8009ec:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009ee:	eb 09                	jmp    8009f9 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009f0:	83 ef 01             	sub    $0x1,%edi
  8009f3:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009f6:	fd                   	std    
  8009f7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009f9:	fc                   	cld    
  8009fa:	eb 1a                	jmp    800a16 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009fc:	89 c2                	mov    %eax,%edx
  8009fe:	09 ca                	or     %ecx,%edx
  800a00:	09 f2                	or     %esi,%edx
  800a02:	f6 c2 03             	test   $0x3,%dl
  800a05:	75 0a                	jne    800a11 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a07:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a0a:	89 c7                	mov    %eax,%edi
  800a0c:	fc                   	cld    
  800a0d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a0f:	eb 05                	jmp    800a16 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800a11:	89 c7                	mov    %eax,%edi
  800a13:	fc                   	cld    
  800a14:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a16:	5e                   	pop    %esi
  800a17:	5f                   	pop    %edi
  800a18:	5d                   	pop    %ebp
  800a19:	c3                   	ret    

00800a1a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a1a:	f3 0f 1e fb          	endbr32 
  800a1e:	55                   	push   %ebp
  800a1f:	89 e5                	mov    %esp,%ebp
  800a21:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a24:	ff 75 10             	pushl  0x10(%ebp)
  800a27:	ff 75 0c             	pushl  0xc(%ebp)
  800a2a:	ff 75 08             	pushl  0x8(%ebp)
  800a2d:	e8 82 ff ff ff       	call   8009b4 <memmove>
}
  800a32:	c9                   	leave  
  800a33:	c3                   	ret    

00800a34 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a34:	f3 0f 1e fb          	endbr32 
  800a38:	55                   	push   %ebp
  800a39:	89 e5                	mov    %esp,%ebp
  800a3b:	56                   	push   %esi
  800a3c:	53                   	push   %ebx
  800a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a40:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a43:	89 c6                	mov    %eax,%esi
  800a45:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a48:	39 f0                	cmp    %esi,%eax
  800a4a:	74 1c                	je     800a68 <memcmp+0x34>
		if (*s1 != *s2)
  800a4c:	0f b6 08             	movzbl (%eax),%ecx
  800a4f:	0f b6 1a             	movzbl (%edx),%ebx
  800a52:	38 d9                	cmp    %bl,%cl
  800a54:	75 08                	jne    800a5e <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a56:	83 c0 01             	add    $0x1,%eax
  800a59:	83 c2 01             	add    $0x1,%edx
  800a5c:	eb ea                	jmp    800a48 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a5e:	0f b6 c1             	movzbl %cl,%eax
  800a61:	0f b6 db             	movzbl %bl,%ebx
  800a64:	29 d8                	sub    %ebx,%eax
  800a66:	eb 05                	jmp    800a6d <memcmp+0x39>
	}

	return 0;
  800a68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a6d:	5b                   	pop    %ebx
  800a6e:	5e                   	pop    %esi
  800a6f:	5d                   	pop    %ebp
  800a70:	c3                   	ret    

00800a71 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a71:	f3 0f 1e fb          	endbr32 
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a7e:	89 c2                	mov    %eax,%edx
  800a80:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a83:	39 d0                	cmp    %edx,%eax
  800a85:	73 09                	jae    800a90 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a87:	38 08                	cmp    %cl,(%eax)
  800a89:	74 05                	je     800a90 <memfind+0x1f>
	for (; s < ends; s++)
  800a8b:	83 c0 01             	add    $0x1,%eax
  800a8e:	eb f3                	jmp    800a83 <memfind+0x12>
			break;
	return (void *) s;
}
  800a90:	5d                   	pop    %ebp
  800a91:	c3                   	ret    

00800a92 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a92:	f3 0f 1e fb          	endbr32 
  800a96:	55                   	push   %ebp
  800a97:	89 e5                	mov    %esp,%ebp
  800a99:	57                   	push   %edi
  800a9a:	56                   	push   %esi
  800a9b:	53                   	push   %ebx
  800a9c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a9f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aa2:	eb 03                	jmp    800aa7 <strtol+0x15>
		s++;
  800aa4:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800aa7:	0f b6 01             	movzbl (%ecx),%eax
  800aaa:	3c 20                	cmp    $0x20,%al
  800aac:	74 f6                	je     800aa4 <strtol+0x12>
  800aae:	3c 09                	cmp    $0x9,%al
  800ab0:	74 f2                	je     800aa4 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800ab2:	3c 2b                	cmp    $0x2b,%al
  800ab4:	74 2a                	je     800ae0 <strtol+0x4e>
	int neg = 0;
  800ab6:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800abb:	3c 2d                	cmp    $0x2d,%al
  800abd:	74 2b                	je     800aea <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800abf:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ac5:	75 0f                	jne    800ad6 <strtol+0x44>
  800ac7:	80 39 30             	cmpb   $0x30,(%ecx)
  800aca:	74 28                	je     800af4 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800acc:	85 db                	test   %ebx,%ebx
  800ace:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ad3:	0f 44 d8             	cmove  %eax,%ebx
  800ad6:	b8 00 00 00 00       	mov    $0x0,%eax
  800adb:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ade:	eb 46                	jmp    800b26 <strtol+0x94>
		s++;
  800ae0:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ae3:	bf 00 00 00 00       	mov    $0x0,%edi
  800ae8:	eb d5                	jmp    800abf <strtol+0x2d>
		s++, neg = 1;
  800aea:	83 c1 01             	add    $0x1,%ecx
  800aed:	bf 01 00 00 00       	mov    $0x1,%edi
  800af2:	eb cb                	jmp    800abf <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800af4:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800af8:	74 0e                	je     800b08 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800afa:	85 db                	test   %ebx,%ebx
  800afc:	75 d8                	jne    800ad6 <strtol+0x44>
		s++, base = 8;
  800afe:	83 c1 01             	add    $0x1,%ecx
  800b01:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b06:	eb ce                	jmp    800ad6 <strtol+0x44>
		s += 2, base = 16;
  800b08:	83 c1 02             	add    $0x2,%ecx
  800b0b:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b10:	eb c4                	jmp    800ad6 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b12:	0f be d2             	movsbl %dl,%edx
  800b15:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b18:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b1b:	7d 3a                	jge    800b57 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b1d:	83 c1 01             	add    $0x1,%ecx
  800b20:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b24:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b26:	0f b6 11             	movzbl (%ecx),%edx
  800b29:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b2c:	89 f3                	mov    %esi,%ebx
  800b2e:	80 fb 09             	cmp    $0x9,%bl
  800b31:	76 df                	jbe    800b12 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b33:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b36:	89 f3                	mov    %esi,%ebx
  800b38:	80 fb 19             	cmp    $0x19,%bl
  800b3b:	77 08                	ja     800b45 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b3d:	0f be d2             	movsbl %dl,%edx
  800b40:	83 ea 57             	sub    $0x57,%edx
  800b43:	eb d3                	jmp    800b18 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b45:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b48:	89 f3                	mov    %esi,%ebx
  800b4a:	80 fb 19             	cmp    $0x19,%bl
  800b4d:	77 08                	ja     800b57 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b4f:	0f be d2             	movsbl %dl,%edx
  800b52:	83 ea 37             	sub    $0x37,%edx
  800b55:	eb c1                	jmp    800b18 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b57:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b5b:	74 05                	je     800b62 <strtol+0xd0>
		*endptr = (char *) s;
  800b5d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b60:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b62:	89 c2                	mov    %eax,%edx
  800b64:	f7 da                	neg    %edx
  800b66:	85 ff                	test   %edi,%edi
  800b68:	0f 45 c2             	cmovne %edx,%eax
}
  800b6b:	5b                   	pop    %ebx
  800b6c:	5e                   	pop    %esi
  800b6d:	5f                   	pop    %edi
  800b6e:	5d                   	pop    %ebp
  800b6f:	c3                   	ret    

00800b70 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b70:	f3 0f 1e fb          	endbr32 
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	57                   	push   %edi
  800b78:	56                   	push   %esi
  800b79:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b7a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800b82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b85:	89 c3                	mov    %eax,%ebx
  800b87:	89 c7                	mov    %eax,%edi
  800b89:	89 c6                	mov    %eax,%esi
  800b8b:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b8d:	5b                   	pop    %ebx
  800b8e:	5e                   	pop    %esi
  800b8f:	5f                   	pop    %edi
  800b90:	5d                   	pop    %ebp
  800b91:	c3                   	ret    

00800b92 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b92:	f3 0f 1e fb          	endbr32 
  800b96:	55                   	push   %ebp
  800b97:	89 e5                	mov    %esp,%ebp
  800b99:	57                   	push   %edi
  800b9a:	56                   	push   %esi
  800b9b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b9c:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba1:	b8 01 00 00 00       	mov    $0x1,%eax
  800ba6:	89 d1                	mov    %edx,%ecx
  800ba8:	89 d3                	mov    %edx,%ebx
  800baa:	89 d7                	mov    %edx,%edi
  800bac:	89 d6                	mov    %edx,%esi
  800bae:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bb0:	5b                   	pop    %ebx
  800bb1:	5e                   	pop    %esi
  800bb2:	5f                   	pop    %edi
  800bb3:	5d                   	pop    %ebp
  800bb4:	c3                   	ret    

00800bb5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bb5:	f3 0f 1e fb          	endbr32 
  800bb9:	55                   	push   %ebp
  800bba:	89 e5                	mov    %esp,%ebp
  800bbc:	57                   	push   %edi
  800bbd:	56                   	push   %esi
  800bbe:	53                   	push   %ebx
  800bbf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bc2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bc7:	8b 55 08             	mov    0x8(%ebp),%edx
  800bca:	b8 03 00 00 00       	mov    $0x3,%eax
  800bcf:	89 cb                	mov    %ecx,%ebx
  800bd1:	89 cf                	mov    %ecx,%edi
  800bd3:	89 ce                	mov    %ecx,%esi
  800bd5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bd7:	85 c0                	test   %eax,%eax
  800bd9:	7f 08                	jg     800be3 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bde:	5b                   	pop    %ebx
  800bdf:	5e                   	pop    %esi
  800be0:	5f                   	pop    %edi
  800be1:	5d                   	pop    %ebp
  800be2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800be3:	83 ec 0c             	sub    $0xc,%esp
  800be6:	50                   	push   %eax
  800be7:	6a 03                	push   $0x3
  800be9:	68 bf 2b 80 00       	push   $0x802bbf
  800bee:	6a 23                	push   $0x23
  800bf0:	68 dc 2b 80 00       	push   $0x802bdc
  800bf5:	e8 01 18 00 00       	call   8023fb <_panic>

00800bfa <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bfa:	f3 0f 1e fb          	endbr32 
  800bfe:	55                   	push   %ebp
  800bff:	89 e5                	mov    %esp,%ebp
  800c01:	57                   	push   %edi
  800c02:	56                   	push   %esi
  800c03:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c04:	ba 00 00 00 00       	mov    $0x0,%edx
  800c09:	b8 02 00 00 00       	mov    $0x2,%eax
  800c0e:	89 d1                	mov    %edx,%ecx
  800c10:	89 d3                	mov    %edx,%ebx
  800c12:	89 d7                	mov    %edx,%edi
  800c14:	89 d6                	mov    %edx,%esi
  800c16:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c18:	5b                   	pop    %ebx
  800c19:	5e                   	pop    %esi
  800c1a:	5f                   	pop    %edi
  800c1b:	5d                   	pop    %ebp
  800c1c:	c3                   	ret    

00800c1d <sys_yield>:

void
sys_yield(void)
{
  800c1d:	f3 0f 1e fb          	endbr32 
  800c21:	55                   	push   %ebp
  800c22:	89 e5                	mov    %esp,%ebp
  800c24:	57                   	push   %edi
  800c25:	56                   	push   %esi
  800c26:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c27:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2c:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c31:	89 d1                	mov    %edx,%ecx
  800c33:	89 d3                	mov    %edx,%ebx
  800c35:	89 d7                	mov    %edx,%edi
  800c37:	89 d6                	mov    %edx,%esi
  800c39:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c3b:	5b                   	pop    %ebx
  800c3c:	5e                   	pop    %esi
  800c3d:	5f                   	pop    %edi
  800c3e:	5d                   	pop    %ebp
  800c3f:	c3                   	ret    

00800c40 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c40:	f3 0f 1e fb          	endbr32 
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	57                   	push   %edi
  800c48:	56                   	push   %esi
  800c49:	53                   	push   %ebx
  800c4a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c4d:	be 00 00 00 00       	mov    $0x0,%esi
  800c52:	8b 55 08             	mov    0x8(%ebp),%edx
  800c55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c58:	b8 04 00 00 00       	mov    $0x4,%eax
  800c5d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c60:	89 f7                	mov    %esi,%edi
  800c62:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c64:	85 c0                	test   %eax,%eax
  800c66:	7f 08                	jg     800c70 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c68:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c6b:	5b                   	pop    %ebx
  800c6c:	5e                   	pop    %esi
  800c6d:	5f                   	pop    %edi
  800c6e:	5d                   	pop    %ebp
  800c6f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c70:	83 ec 0c             	sub    $0xc,%esp
  800c73:	50                   	push   %eax
  800c74:	6a 04                	push   $0x4
  800c76:	68 bf 2b 80 00       	push   $0x802bbf
  800c7b:	6a 23                	push   $0x23
  800c7d:	68 dc 2b 80 00       	push   $0x802bdc
  800c82:	e8 74 17 00 00       	call   8023fb <_panic>

00800c87 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c87:	f3 0f 1e fb          	endbr32 
  800c8b:	55                   	push   %ebp
  800c8c:	89 e5                	mov    %esp,%ebp
  800c8e:	57                   	push   %edi
  800c8f:	56                   	push   %esi
  800c90:	53                   	push   %ebx
  800c91:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c94:	8b 55 08             	mov    0x8(%ebp),%edx
  800c97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9a:	b8 05 00 00 00       	mov    $0x5,%eax
  800c9f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ca2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ca5:	8b 75 18             	mov    0x18(%ebp),%esi
  800ca8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800caa:	85 c0                	test   %eax,%eax
  800cac:	7f 08                	jg     800cb6 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb1:	5b                   	pop    %ebx
  800cb2:	5e                   	pop    %esi
  800cb3:	5f                   	pop    %edi
  800cb4:	5d                   	pop    %ebp
  800cb5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb6:	83 ec 0c             	sub    $0xc,%esp
  800cb9:	50                   	push   %eax
  800cba:	6a 05                	push   $0x5
  800cbc:	68 bf 2b 80 00       	push   $0x802bbf
  800cc1:	6a 23                	push   $0x23
  800cc3:	68 dc 2b 80 00       	push   $0x802bdc
  800cc8:	e8 2e 17 00 00       	call   8023fb <_panic>

00800ccd <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ccd:	f3 0f 1e fb          	endbr32 
  800cd1:	55                   	push   %ebp
  800cd2:	89 e5                	mov    %esp,%ebp
  800cd4:	57                   	push   %edi
  800cd5:	56                   	push   %esi
  800cd6:	53                   	push   %ebx
  800cd7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cda:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cdf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce5:	b8 06 00 00 00       	mov    $0x6,%eax
  800cea:	89 df                	mov    %ebx,%edi
  800cec:	89 de                	mov    %ebx,%esi
  800cee:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf0:	85 c0                	test   %eax,%eax
  800cf2:	7f 08                	jg     800cfc <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cf4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf7:	5b                   	pop    %ebx
  800cf8:	5e                   	pop    %esi
  800cf9:	5f                   	pop    %edi
  800cfa:	5d                   	pop    %ebp
  800cfb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cfc:	83 ec 0c             	sub    $0xc,%esp
  800cff:	50                   	push   %eax
  800d00:	6a 06                	push   $0x6
  800d02:	68 bf 2b 80 00       	push   $0x802bbf
  800d07:	6a 23                	push   $0x23
  800d09:	68 dc 2b 80 00       	push   $0x802bdc
  800d0e:	e8 e8 16 00 00       	call   8023fb <_panic>

00800d13 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d13:	f3 0f 1e fb          	endbr32 
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
  800d1a:	57                   	push   %edi
  800d1b:	56                   	push   %esi
  800d1c:	53                   	push   %ebx
  800d1d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d20:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d25:	8b 55 08             	mov    0x8(%ebp),%edx
  800d28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2b:	b8 08 00 00 00       	mov    $0x8,%eax
  800d30:	89 df                	mov    %ebx,%edi
  800d32:	89 de                	mov    %ebx,%esi
  800d34:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d36:	85 c0                	test   %eax,%eax
  800d38:	7f 08                	jg     800d42 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d3d:	5b                   	pop    %ebx
  800d3e:	5e                   	pop    %esi
  800d3f:	5f                   	pop    %edi
  800d40:	5d                   	pop    %ebp
  800d41:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d42:	83 ec 0c             	sub    $0xc,%esp
  800d45:	50                   	push   %eax
  800d46:	6a 08                	push   $0x8
  800d48:	68 bf 2b 80 00       	push   $0x802bbf
  800d4d:	6a 23                	push   $0x23
  800d4f:	68 dc 2b 80 00       	push   $0x802bdc
  800d54:	e8 a2 16 00 00       	call   8023fb <_panic>

00800d59 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d59:	f3 0f 1e fb          	endbr32 
  800d5d:	55                   	push   %ebp
  800d5e:	89 e5                	mov    %esp,%ebp
  800d60:	57                   	push   %edi
  800d61:	56                   	push   %esi
  800d62:	53                   	push   %ebx
  800d63:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d66:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d71:	b8 09 00 00 00       	mov    $0x9,%eax
  800d76:	89 df                	mov    %ebx,%edi
  800d78:	89 de                	mov    %ebx,%esi
  800d7a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d7c:	85 c0                	test   %eax,%eax
  800d7e:	7f 08                	jg     800d88 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d83:	5b                   	pop    %ebx
  800d84:	5e                   	pop    %esi
  800d85:	5f                   	pop    %edi
  800d86:	5d                   	pop    %ebp
  800d87:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d88:	83 ec 0c             	sub    $0xc,%esp
  800d8b:	50                   	push   %eax
  800d8c:	6a 09                	push   $0x9
  800d8e:	68 bf 2b 80 00       	push   $0x802bbf
  800d93:	6a 23                	push   $0x23
  800d95:	68 dc 2b 80 00       	push   $0x802bdc
  800d9a:	e8 5c 16 00 00       	call   8023fb <_panic>

00800d9f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d9f:	f3 0f 1e fb          	endbr32 
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	57                   	push   %edi
  800da7:	56                   	push   %esi
  800da8:	53                   	push   %ebx
  800da9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dac:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db1:	8b 55 08             	mov    0x8(%ebp),%edx
  800db4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dbc:	89 df                	mov    %ebx,%edi
  800dbe:	89 de                	mov    %ebx,%esi
  800dc0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc2:	85 c0                	test   %eax,%eax
  800dc4:	7f 08                	jg     800dce <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc9:	5b                   	pop    %ebx
  800dca:	5e                   	pop    %esi
  800dcb:	5f                   	pop    %edi
  800dcc:	5d                   	pop    %ebp
  800dcd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dce:	83 ec 0c             	sub    $0xc,%esp
  800dd1:	50                   	push   %eax
  800dd2:	6a 0a                	push   $0xa
  800dd4:	68 bf 2b 80 00       	push   $0x802bbf
  800dd9:	6a 23                	push   $0x23
  800ddb:	68 dc 2b 80 00       	push   $0x802bdc
  800de0:	e8 16 16 00 00       	call   8023fb <_panic>

00800de5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800de5:	f3 0f 1e fb          	endbr32 
  800de9:	55                   	push   %ebp
  800dea:	89 e5                	mov    %esp,%ebp
  800dec:	57                   	push   %edi
  800ded:	56                   	push   %esi
  800dee:	53                   	push   %ebx
	asm volatile("int %1\n"
  800def:	8b 55 08             	mov    0x8(%ebp),%edx
  800df2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df5:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dfa:	be 00 00 00 00       	mov    $0x0,%esi
  800dff:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e02:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e05:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e07:	5b                   	pop    %ebx
  800e08:	5e                   	pop    %esi
  800e09:	5f                   	pop    %edi
  800e0a:	5d                   	pop    %ebp
  800e0b:	c3                   	ret    

00800e0c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e0c:	f3 0f 1e fb          	endbr32 
  800e10:	55                   	push   %ebp
  800e11:	89 e5                	mov    %esp,%ebp
  800e13:	57                   	push   %edi
  800e14:	56                   	push   %esi
  800e15:	53                   	push   %ebx
  800e16:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e19:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e21:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e26:	89 cb                	mov    %ecx,%ebx
  800e28:	89 cf                	mov    %ecx,%edi
  800e2a:	89 ce                	mov    %ecx,%esi
  800e2c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e2e:	85 c0                	test   %eax,%eax
  800e30:	7f 08                	jg     800e3a <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e32:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e35:	5b                   	pop    %ebx
  800e36:	5e                   	pop    %esi
  800e37:	5f                   	pop    %edi
  800e38:	5d                   	pop    %ebp
  800e39:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3a:	83 ec 0c             	sub    $0xc,%esp
  800e3d:	50                   	push   %eax
  800e3e:	6a 0d                	push   $0xd
  800e40:	68 bf 2b 80 00       	push   $0x802bbf
  800e45:	6a 23                	push   $0x23
  800e47:	68 dc 2b 80 00       	push   $0x802bdc
  800e4c:	e8 aa 15 00 00       	call   8023fb <_panic>

00800e51 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e51:	f3 0f 1e fb          	endbr32 
  800e55:	55                   	push   %ebp
  800e56:	89 e5                	mov    %esp,%ebp
  800e58:	57                   	push   %edi
  800e59:	56                   	push   %esi
  800e5a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e5b:	ba 00 00 00 00       	mov    $0x0,%edx
  800e60:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e65:	89 d1                	mov    %edx,%ecx
  800e67:	89 d3                	mov    %edx,%ebx
  800e69:	89 d7                	mov    %edx,%edi
  800e6b:	89 d6                	mov    %edx,%esi
  800e6d:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e6f:	5b                   	pop    %ebx
  800e70:	5e                   	pop    %esi
  800e71:	5f                   	pop    %edi
  800e72:	5d                   	pop    %ebp
  800e73:	c3                   	ret    

00800e74 <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  800e74:	f3 0f 1e fb          	endbr32 
  800e78:	55                   	push   %ebp
  800e79:	89 e5                	mov    %esp,%ebp
  800e7b:	57                   	push   %edi
  800e7c:	56                   	push   %esi
  800e7d:	53                   	push   %ebx
  800e7e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e81:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e86:	8b 55 08             	mov    0x8(%ebp),%edx
  800e89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8c:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e91:	89 df                	mov    %ebx,%edi
  800e93:	89 de                	mov    %ebx,%esi
  800e95:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e97:	85 c0                	test   %eax,%eax
  800e99:	7f 08                	jg     800ea3 <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  800e9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e9e:	5b                   	pop    %ebx
  800e9f:	5e                   	pop    %esi
  800ea0:	5f                   	pop    %edi
  800ea1:	5d                   	pop    %ebp
  800ea2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea3:	83 ec 0c             	sub    $0xc,%esp
  800ea6:	50                   	push   %eax
  800ea7:	6a 0f                	push   $0xf
  800ea9:	68 bf 2b 80 00       	push   $0x802bbf
  800eae:	6a 23                	push   $0x23
  800eb0:	68 dc 2b 80 00       	push   $0x802bdc
  800eb5:	e8 41 15 00 00       	call   8023fb <_panic>

00800eba <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  800eba:	f3 0f 1e fb          	endbr32 
  800ebe:	55                   	push   %ebp
  800ebf:	89 e5                	mov    %esp,%ebp
  800ec1:	57                   	push   %edi
  800ec2:	56                   	push   %esi
  800ec3:	53                   	push   %ebx
  800ec4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ecc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed2:	b8 10 00 00 00       	mov    $0x10,%eax
  800ed7:	89 df                	mov    %ebx,%edi
  800ed9:	89 de                	mov    %ebx,%esi
  800edb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800edd:	85 c0                	test   %eax,%eax
  800edf:	7f 08                	jg     800ee9 <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  800ee1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee4:	5b                   	pop    %ebx
  800ee5:	5e                   	pop    %esi
  800ee6:	5f                   	pop    %edi
  800ee7:	5d                   	pop    %ebp
  800ee8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee9:	83 ec 0c             	sub    $0xc,%esp
  800eec:	50                   	push   %eax
  800eed:	6a 10                	push   $0x10
  800eef:	68 bf 2b 80 00       	push   $0x802bbf
  800ef4:	6a 23                	push   $0x23
  800ef6:	68 dc 2b 80 00       	push   $0x802bdc
  800efb:	e8 fb 14 00 00       	call   8023fb <_panic>

00800f00 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f00:	f3 0f 1e fb          	endbr32 
  800f04:	55                   	push   %ebp
  800f05:	89 e5                	mov    %esp,%ebp
  800f07:	53                   	push   %ebx
  800f08:	83 ec 04             	sub    $0x4,%esp
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800f0e:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  800f10:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f14:	74 74                	je     800f8a <pgfault+0x8a>
  800f16:	89 d8                	mov    %ebx,%eax
  800f18:	c1 e8 0c             	shr    $0xc,%eax
  800f1b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f22:	f6 c4 08             	test   $0x8,%ah
  800f25:	74 63                	je     800f8a <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800f27:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  800f2d:	83 ec 0c             	sub    $0xc,%esp
  800f30:	6a 05                	push   $0x5
  800f32:	68 00 f0 7f 00       	push   $0x7ff000
  800f37:	6a 00                	push   $0x0
  800f39:	53                   	push   %ebx
  800f3a:	6a 00                	push   $0x0
  800f3c:	e8 46 fd ff ff       	call   800c87 <sys_page_map>
  800f41:	83 c4 20             	add    $0x20,%esp
  800f44:	85 c0                	test   %eax,%eax
  800f46:	78 59                	js     800fa1 <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  800f48:	83 ec 04             	sub    $0x4,%esp
  800f4b:	6a 07                	push   $0x7
  800f4d:	53                   	push   %ebx
  800f4e:	6a 00                	push   $0x0
  800f50:	e8 eb fc ff ff       	call   800c40 <sys_page_alloc>
  800f55:	83 c4 10             	add    $0x10,%esp
  800f58:	85 c0                	test   %eax,%eax
  800f5a:	78 5a                	js     800fb6 <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  800f5c:	83 ec 04             	sub    $0x4,%esp
  800f5f:	68 00 10 00 00       	push   $0x1000
  800f64:	68 00 f0 7f 00       	push   $0x7ff000
  800f69:	53                   	push   %ebx
  800f6a:	e8 45 fa ff ff       	call   8009b4 <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  800f6f:	83 c4 08             	add    $0x8,%esp
  800f72:	68 00 f0 7f 00       	push   $0x7ff000
  800f77:	6a 00                	push   $0x0
  800f79:	e8 4f fd ff ff       	call   800ccd <sys_page_unmap>
  800f7e:	83 c4 10             	add    $0x10,%esp
  800f81:	85 c0                	test   %eax,%eax
  800f83:	78 46                	js     800fcb <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  800f85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f88:	c9                   	leave  
  800f89:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  800f8a:	83 ec 04             	sub    $0x4,%esp
  800f8d:	68 ea 2b 80 00       	push   $0x802bea
  800f92:	68 d3 00 00 00       	push   $0xd3
  800f97:	68 06 2c 80 00       	push   $0x802c06
  800f9c:	e8 5a 14 00 00       	call   8023fb <_panic>
		panic("pgfault: %e\n", r);
  800fa1:	50                   	push   %eax
  800fa2:	68 11 2c 80 00       	push   $0x802c11
  800fa7:	68 df 00 00 00       	push   $0xdf
  800fac:	68 06 2c 80 00       	push   $0x802c06
  800fb1:	e8 45 14 00 00       	call   8023fb <_panic>
		panic("pgfault: %e\n", r);
  800fb6:	50                   	push   %eax
  800fb7:	68 11 2c 80 00       	push   $0x802c11
  800fbc:	68 e3 00 00 00       	push   $0xe3
  800fc1:	68 06 2c 80 00       	push   $0x802c06
  800fc6:	e8 30 14 00 00       	call   8023fb <_panic>
		panic("pgfault: %e\n", r);
  800fcb:	50                   	push   %eax
  800fcc:	68 11 2c 80 00       	push   $0x802c11
  800fd1:	68 e9 00 00 00       	push   $0xe9
  800fd6:	68 06 2c 80 00       	push   $0x802c06
  800fdb:	e8 1b 14 00 00       	call   8023fb <_panic>

00800fe0 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800fe0:	f3 0f 1e fb          	endbr32 
  800fe4:	55                   	push   %ebp
  800fe5:	89 e5                	mov    %esp,%ebp
  800fe7:	57                   	push   %edi
  800fe8:	56                   	push   %esi
  800fe9:	53                   	push   %ebx
  800fea:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  800fed:	68 00 0f 80 00       	push   $0x800f00
  800ff2:	e8 4e 14 00 00       	call   802445 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800ff7:	b8 07 00 00 00       	mov    $0x7,%eax
  800ffc:	cd 30                	int    $0x30
  800ffe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  801001:	83 c4 10             	add    $0x10,%esp
  801004:	85 c0                	test   %eax,%eax
  801006:	78 2d                	js     801035 <fork+0x55>
  801008:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  80100a:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  80100f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801013:	0f 85 9b 00 00 00    	jne    8010b4 <fork+0xd4>
		thisenv = &envs[ENVX(sys_getenvid())];
  801019:	e8 dc fb ff ff       	call   800bfa <sys_getenvid>
  80101e:	25 ff 03 00 00       	and    $0x3ff,%eax
  801023:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801026:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80102b:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  801030:	e9 71 01 00 00       	jmp    8011a6 <fork+0x1c6>
		panic("sys_exofork: %e", envid);
  801035:	50                   	push   %eax
  801036:	68 1e 2c 80 00       	push   $0x802c1e
  80103b:	68 2a 01 00 00       	push   $0x12a
  801040:	68 06 2c 80 00       	push   $0x802c06
  801045:	e8 b1 13 00 00       	call   8023fb <_panic>
		sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_SYSCALL);
  80104a:	c1 e6 0c             	shl    $0xc,%esi
  80104d:	83 ec 0c             	sub    $0xc,%esp
  801050:	68 07 0e 00 00       	push   $0xe07
  801055:	56                   	push   %esi
  801056:	57                   	push   %edi
  801057:	56                   	push   %esi
  801058:	6a 00                	push   $0x0
  80105a:	e8 28 fc ff ff       	call   800c87 <sys_page_map>
  80105f:	83 c4 20             	add    $0x20,%esp
  801062:	eb 3e                	jmp    8010a2 <fork+0xc2>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  801064:	c1 e6 0c             	shl    $0xc,%esi
  801067:	83 ec 0c             	sub    $0xc,%esp
  80106a:	68 05 08 00 00       	push   $0x805
  80106f:	56                   	push   %esi
  801070:	57                   	push   %edi
  801071:	56                   	push   %esi
  801072:	6a 00                	push   $0x0
  801074:	e8 0e fc ff ff       	call   800c87 <sys_page_map>
  801079:	83 c4 20             	add    $0x20,%esp
  80107c:	85 c0                	test   %eax,%eax
  80107e:	0f 88 bc 00 00 00    	js     801140 <fork+0x160>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  801084:	83 ec 0c             	sub    $0xc,%esp
  801087:	68 05 08 00 00       	push   $0x805
  80108c:	56                   	push   %esi
  80108d:	6a 00                	push   $0x0
  80108f:	56                   	push   %esi
  801090:	6a 00                	push   $0x0
  801092:	e8 f0 fb ff ff       	call   800c87 <sys_page_map>
  801097:	83 c4 20             	add    $0x20,%esp
  80109a:	85 c0                	test   %eax,%eax
  80109c:	0f 88 b3 00 00 00    	js     801155 <fork+0x175>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8010a2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8010a8:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8010ae:	0f 84 b6 00 00 00    	je     80116a <fork+0x18a>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  8010b4:	89 d8                	mov    %ebx,%eax
  8010b6:	c1 e8 16             	shr    $0x16,%eax
  8010b9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010c0:	a8 01                	test   $0x1,%al
  8010c2:	74 de                	je     8010a2 <fork+0xc2>
  8010c4:	89 de                	mov    %ebx,%esi
  8010c6:	c1 ee 0c             	shr    $0xc,%esi
  8010c9:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010d0:	a8 01                	test   $0x1,%al
  8010d2:	74 ce                	je     8010a2 <fork+0xc2>
  8010d4:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010db:	a8 04                	test   $0x4,%al
  8010dd:	74 c3                	je     8010a2 <fork+0xc2>
	if ((uvpt[pn] & PTE_SHARE)){
  8010df:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010e6:	f6 c4 04             	test   $0x4,%ah
  8010e9:	0f 85 5b ff ff ff    	jne    80104a <fork+0x6a>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  8010ef:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010f6:	a8 02                	test   $0x2,%al
  8010f8:	0f 85 66 ff ff ff    	jne    801064 <fork+0x84>
  8010fe:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801105:	f6 c4 08             	test   $0x8,%ah
  801108:	0f 85 56 ff ff ff    	jne    801064 <fork+0x84>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  80110e:	c1 e6 0c             	shl    $0xc,%esi
  801111:	83 ec 0c             	sub    $0xc,%esp
  801114:	6a 05                	push   $0x5
  801116:	56                   	push   %esi
  801117:	57                   	push   %edi
  801118:	56                   	push   %esi
  801119:	6a 00                	push   $0x0
  80111b:	e8 67 fb ff ff       	call   800c87 <sys_page_map>
  801120:	83 c4 20             	add    $0x20,%esp
  801123:	85 c0                	test   %eax,%eax
  801125:	0f 89 77 ff ff ff    	jns    8010a2 <fork+0xc2>
		panic("duppage: %e\n", r);
  80112b:	50                   	push   %eax
  80112c:	68 2e 2c 80 00       	push   $0x802c2e
  801131:	68 0c 01 00 00       	push   $0x10c
  801136:	68 06 2c 80 00       	push   $0x802c06
  80113b:	e8 bb 12 00 00       	call   8023fb <_panic>
			panic("duppage: %e\n", r);
  801140:	50                   	push   %eax
  801141:	68 2e 2c 80 00       	push   $0x802c2e
  801146:	68 05 01 00 00       	push   $0x105
  80114b:	68 06 2c 80 00       	push   $0x802c06
  801150:	e8 a6 12 00 00       	call   8023fb <_panic>
			panic("duppage: %e\n", r);
  801155:	50                   	push   %eax
  801156:	68 2e 2c 80 00       	push   $0x802c2e
  80115b:	68 09 01 00 00       	push   $0x109
  801160:	68 06 2c 80 00       	push   $0x802c06
  801165:	e8 91 12 00 00       	call   8023fb <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  80116a:	83 ec 04             	sub    $0x4,%esp
  80116d:	6a 07                	push   $0x7
  80116f:	68 00 f0 bf ee       	push   $0xeebff000
  801174:	ff 75 e4             	pushl  -0x1c(%ebp)
  801177:	e8 c4 fa ff ff       	call   800c40 <sys_page_alloc>
  80117c:	83 c4 10             	add    $0x10,%esp
  80117f:	85 c0                	test   %eax,%eax
  801181:	78 2e                	js     8011b1 <fork+0x1d1>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801183:	83 ec 08             	sub    $0x8,%esp
  801186:	68 b8 24 80 00       	push   $0x8024b8
  80118b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80118e:	57                   	push   %edi
  80118f:	e8 0b fc ff ff       	call   800d9f <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801194:	83 c4 08             	add    $0x8,%esp
  801197:	6a 02                	push   $0x2
  801199:	57                   	push   %edi
  80119a:	e8 74 fb ff ff       	call   800d13 <sys_env_set_status>
  80119f:	83 c4 10             	add    $0x10,%esp
  8011a2:	85 c0                	test   %eax,%eax
  8011a4:	78 20                	js     8011c6 <fork+0x1e6>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  8011a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011ac:	5b                   	pop    %ebx
  8011ad:	5e                   	pop    %esi
  8011ae:	5f                   	pop    %edi
  8011af:	5d                   	pop    %ebp
  8011b0:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  8011b1:	50                   	push   %eax
  8011b2:	68 3b 2c 80 00       	push   $0x802c3b
  8011b7:	68 3e 01 00 00       	push   $0x13e
  8011bc:	68 06 2c 80 00       	push   $0x802c06
  8011c1:	e8 35 12 00 00       	call   8023fb <_panic>
		panic("sys_env_set_status: %e", r);
  8011c6:	50                   	push   %eax
  8011c7:	68 4e 2c 80 00       	push   $0x802c4e
  8011cc:	68 43 01 00 00       	push   $0x143
  8011d1:	68 06 2c 80 00       	push   $0x802c06
  8011d6:	e8 20 12 00 00       	call   8023fb <_panic>

008011db <sfork>:

// Challenge!
int
sfork(void)
{
  8011db:	f3 0f 1e fb          	endbr32 
  8011df:	55                   	push   %ebp
  8011e0:	89 e5                	mov    %esp,%ebp
  8011e2:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8011e5:	68 65 2c 80 00       	push   $0x802c65
  8011ea:	68 4c 01 00 00       	push   $0x14c
  8011ef:	68 06 2c 80 00       	push   $0x802c06
  8011f4:	e8 02 12 00 00       	call   8023fb <_panic>

008011f9 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011f9:	f3 0f 1e fb          	endbr32 
  8011fd:	55                   	push   %ebp
  8011fe:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
  801203:	05 00 00 00 30       	add    $0x30000000,%eax
  801208:	c1 e8 0c             	shr    $0xc,%eax
}
  80120b:	5d                   	pop    %ebp
  80120c:	c3                   	ret    

0080120d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80120d:	f3 0f 1e fb          	endbr32 
  801211:	55                   	push   %ebp
  801212:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801214:	8b 45 08             	mov    0x8(%ebp),%eax
  801217:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80121c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801221:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801226:	5d                   	pop    %ebp
  801227:	c3                   	ret    

00801228 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801228:	f3 0f 1e fb          	endbr32 
  80122c:	55                   	push   %ebp
  80122d:	89 e5                	mov    %esp,%ebp
  80122f:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801234:	89 c2                	mov    %eax,%edx
  801236:	c1 ea 16             	shr    $0x16,%edx
  801239:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801240:	f6 c2 01             	test   $0x1,%dl
  801243:	74 2d                	je     801272 <fd_alloc+0x4a>
  801245:	89 c2                	mov    %eax,%edx
  801247:	c1 ea 0c             	shr    $0xc,%edx
  80124a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801251:	f6 c2 01             	test   $0x1,%dl
  801254:	74 1c                	je     801272 <fd_alloc+0x4a>
  801256:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80125b:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801260:	75 d2                	jne    801234 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801262:	8b 45 08             	mov    0x8(%ebp),%eax
  801265:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80126b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801270:	eb 0a                	jmp    80127c <fd_alloc+0x54>
			*fd_store = fd;
  801272:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801275:	89 01                	mov    %eax,(%ecx)
			return 0;
  801277:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80127c:	5d                   	pop    %ebp
  80127d:	c3                   	ret    

0080127e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80127e:	f3 0f 1e fb          	endbr32 
  801282:	55                   	push   %ebp
  801283:	89 e5                	mov    %esp,%ebp
  801285:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801288:	83 f8 1f             	cmp    $0x1f,%eax
  80128b:	77 30                	ja     8012bd <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80128d:	c1 e0 0c             	shl    $0xc,%eax
  801290:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801295:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80129b:	f6 c2 01             	test   $0x1,%dl
  80129e:	74 24                	je     8012c4 <fd_lookup+0x46>
  8012a0:	89 c2                	mov    %eax,%edx
  8012a2:	c1 ea 0c             	shr    $0xc,%edx
  8012a5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012ac:	f6 c2 01             	test   $0x1,%dl
  8012af:	74 1a                	je     8012cb <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b4:	89 02                	mov    %eax,(%edx)
	return 0;
  8012b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012bb:	5d                   	pop    %ebp
  8012bc:	c3                   	ret    
		return -E_INVAL;
  8012bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012c2:	eb f7                	jmp    8012bb <fd_lookup+0x3d>
		return -E_INVAL;
  8012c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012c9:	eb f0                	jmp    8012bb <fd_lookup+0x3d>
  8012cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012d0:	eb e9                	jmp    8012bb <fd_lookup+0x3d>

008012d2 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8012d2:	f3 0f 1e fb          	endbr32 
  8012d6:	55                   	push   %ebp
  8012d7:	89 e5                	mov    %esp,%ebp
  8012d9:	83 ec 08             	sub    $0x8,%esp
  8012dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8012df:	ba 00 00 00 00       	mov    $0x0,%edx
  8012e4:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8012e9:	39 08                	cmp    %ecx,(%eax)
  8012eb:	74 38                	je     801325 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  8012ed:	83 c2 01             	add    $0x1,%edx
  8012f0:	8b 04 95 f8 2c 80 00 	mov    0x802cf8(,%edx,4),%eax
  8012f7:	85 c0                	test   %eax,%eax
  8012f9:	75 ee                	jne    8012e9 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8012fb:	a1 08 40 80 00       	mov    0x804008,%eax
  801300:	8b 40 48             	mov    0x48(%eax),%eax
  801303:	83 ec 04             	sub    $0x4,%esp
  801306:	51                   	push   %ecx
  801307:	50                   	push   %eax
  801308:	68 7c 2c 80 00       	push   $0x802c7c
  80130d:	e8 e2 ee ff ff       	call   8001f4 <cprintf>
	*dev = 0;
  801312:	8b 45 0c             	mov    0xc(%ebp),%eax
  801315:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80131b:	83 c4 10             	add    $0x10,%esp
  80131e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801323:	c9                   	leave  
  801324:	c3                   	ret    
			*dev = devtab[i];
  801325:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801328:	89 01                	mov    %eax,(%ecx)
			return 0;
  80132a:	b8 00 00 00 00       	mov    $0x0,%eax
  80132f:	eb f2                	jmp    801323 <dev_lookup+0x51>

00801331 <fd_close>:
{
  801331:	f3 0f 1e fb          	endbr32 
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
  801338:	57                   	push   %edi
  801339:	56                   	push   %esi
  80133a:	53                   	push   %ebx
  80133b:	83 ec 24             	sub    $0x24,%esp
  80133e:	8b 75 08             	mov    0x8(%ebp),%esi
  801341:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801344:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801347:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801348:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80134e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801351:	50                   	push   %eax
  801352:	e8 27 ff ff ff       	call   80127e <fd_lookup>
  801357:	89 c3                	mov    %eax,%ebx
  801359:	83 c4 10             	add    $0x10,%esp
  80135c:	85 c0                	test   %eax,%eax
  80135e:	78 05                	js     801365 <fd_close+0x34>
	    || fd != fd2)
  801360:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801363:	74 16                	je     80137b <fd_close+0x4a>
		return (must_exist ? r : 0);
  801365:	89 f8                	mov    %edi,%eax
  801367:	84 c0                	test   %al,%al
  801369:	b8 00 00 00 00       	mov    $0x0,%eax
  80136e:	0f 44 d8             	cmove  %eax,%ebx
}
  801371:	89 d8                	mov    %ebx,%eax
  801373:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801376:	5b                   	pop    %ebx
  801377:	5e                   	pop    %esi
  801378:	5f                   	pop    %edi
  801379:	5d                   	pop    %ebp
  80137a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80137b:	83 ec 08             	sub    $0x8,%esp
  80137e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801381:	50                   	push   %eax
  801382:	ff 36                	pushl  (%esi)
  801384:	e8 49 ff ff ff       	call   8012d2 <dev_lookup>
  801389:	89 c3                	mov    %eax,%ebx
  80138b:	83 c4 10             	add    $0x10,%esp
  80138e:	85 c0                	test   %eax,%eax
  801390:	78 1a                	js     8013ac <fd_close+0x7b>
		if (dev->dev_close)
  801392:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801395:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801398:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80139d:	85 c0                	test   %eax,%eax
  80139f:	74 0b                	je     8013ac <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8013a1:	83 ec 0c             	sub    $0xc,%esp
  8013a4:	56                   	push   %esi
  8013a5:	ff d0                	call   *%eax
  8013a7:	89 c3                	mov    %eax,%ebx
  8013a9:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8013ac:	83 ec 08             	sub    $0x8,%esp
  8013af:	56                   	push   %esi
  8013b0:	6a 00                	push   $0x0
  8013b2:	e8 16 f9 ff ff       	call   800ccd <sys_page_unmap>
	return r;
  8013b7:	83 c4 10             	add    $0x10,%esp
  8013ba:	eb b5                	jmp    801371 <fd_close+0x40>

008013bc <close>:

int
close(int fdnum)
{
  8013bc:	f3 0f 1e fb          	endbr32 
  8013c0:	55                   	push   %ebp
  8013c1:	89 e5                	mov    %esp,%ebp
  8013c3:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013c9:	50                   	push   %eax
  8013ca:	ff 75 08             	pushl  0x8(%ebp)
  8013cd:	e8 ac fe ff ff       	call   80127e <fd_lookup>
  8013d2:	83 c4 10             	add    $0x10,%esp
  8013d5:	85 c0                	test   %eax,%eax
  8013d7:	79 02                	jns    8013db <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8013d9:	c9                   	leave  
  8013da:	c3                   	ret    
		return fd_close(fd, 1);
  8013db:	83 ec 08             	sub    $0x8,%esp
  8013de:	6a 01                	push   $0x1
  8013e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8013e3:	e8 49 ff ff ff       	call   801331 <fd_close>
  8013e8:	83 c4 10             	add    $0x10,%esp
  8013eb:	eb ec                	jmp    8013d9 <close+0x1d>

008013ed <close_all>:

void
close_all(void)
{
  8013ed:	f3 0f 1e fb          	endbr32 
  8013f1:	55                   	push   %ebp
  8013f2:	89 e5                	mov    %esp,%ebp
  8013f4:	53                   	push   %ebx
  8013f5:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013f8:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8013fd:	83 ec 0c             	sub    $0xc,%esp
  801400:	53                   	push   %ebx
  801401:	e8 b6 ff ff ff       	call   8013bc <close>
	for (i = 0; i < MAXFD; i++)
  801406:	83 c3 01             	add    $0x1,%ebx
  801409:	83 c4 10             	add    $0x10,%esp
  80140c:	83 fb 20             	cmp    $0x20,%ebx
  80140f:	75 ec                	jne    8013fd <close_all+0x10>
}
  801411:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801414:	c9                   	leave  
  801415:	c3                   	ret    

00801416 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801416:	f3 0f 1e fb          	endbr32 
  80141a:	55                   	push   %ebp
  80141b:	89 e5                	mov    %esp,%ebp
  80141d:	57                   	push   %edi
  80141e:	56                   	push   %esi
  80141f:	53                   	push   %ebx
  801420:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801423:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801426:	50                   	push   %eax
  801427:	ff 75 08             	pushl  0x8(%ebp)
  80142a:	e8 4f fe ff ff       	call   80127e <fd_lookup>
  80142f:	89 c3                	mov    %eax,%ebx
  801431:	83 c4 10             	add    $0x10,%esp
  801434:	85 c0                	test   %eax,%eax
  801436:	0f 88 81 00 00 00    	js     8014bd <dup+0xa7>
		return r;
	close(newfdnum);
  80143c:	83 ec 0c             	sub    $0xc,%esp
  80143f:	ff 75 0c             	pushl  0xc(%ebp)
  801442:	e8 75 ff ff ff       	call   8013bc <close>

	newfd = INDEX2FD(newfdnum);
  801447:	8b 75 0c             	mov    0xc(%ebp),%esi
  80144a:	c1 e6 0c             	shl    $0xc,%esi
  80144d:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801453:	83 c4 04             	add    $0x4,%esp
  801456:	ff 75 e4             	pushl  -0x1c(%ebp)
  801459:	e8 af fd ff ff       	call   80120d <fd2data>
  80145e:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801460:	89 34 24             	mov    %esi,(%esp)
  801463:	e8 a5 fd ff ff       	call   80120d <fd2data>
  801468:	83 c4 10             	add    $0x10,%esp
  80146b:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80146d:	89 d8                	mov    %ebx,%eax
  80146f:	c1 e8 16             	shr    $0x16,%eax
  801472:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801479:	a8 01                	test   $0x1,%al
  80147b:	74 11                	je     80148e <dup+0x78>
  80147d:	89 d8                	mov    %ebx,%eax
  80147f:	c1 e8 0c             	shr    $0xc,%eax
  801482:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801489:	f6 c2 01             	test   $0x1,%dl
  80148c:	75 39                	jne    8014c7 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80148e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801491:	89 d0                	mov    %edx,%eax
  801493:	c1 e8 0c             	shr    $0xc,%eax
  801496:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80149d:	83 ec 0c             	sub    $0xc,%esp
  8014a0:	25 07 0e 00 00       	and    $0xe07,%eax
  8014a5:	50                   	push   %eax
  8014a6:	56                   	push   %esi
  8014a7:	6a 00                	push   $0x0
  8014a9:	52                   	push   %edx
  8014aa:	6a 00                	push   $0x0
  8014ac:	e8 d6 f7 ff ff       	call   800c87 <sys_page_map>
  8014b1:	89 c3                	mov    %eax,%ebx
  8014b3:	83 c4 20             	add    $0x20,%esp
  8014b6:	85 c0                	test   %eax,%eax
  8014b8:	78 31                	js     8014eb <dup+0xd5>
		goto err;

	return newfdnum;
  8014ba:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8014bd:	89 d8                	mov    %ebx,%eax
  8014bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014c2:	5b                   	pop    %ebx
  8014c3:	5e                   	pop    %esi
  8014c4:	5f                   	pop    %edi
  8014c5:	5d                   	pop    %ebp
  8014c6:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8014c7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014ce:	83 ec 0c             	sub    $0xc,%esp
  8014d1:	25 07 0e 00 00       	and    $0xe07,%eax
  8014d6:	50                   	push   %eax
  8014d7:	57                   	push   %edi
  8014d8:	6a 00                	push   $0x0
  8014da:	53                   	push   %ebx
  8014db:	6a 00                	push   $0x0
  8014dd:	e8 a5 f7 ff ff       	call   800c87 <sys_page_map>
  8014e2:	89 c3                	mov    %eax,%ebx
  8014e4:	83 c4 20             	add    $0x20,%esp
  8014e7:	85 c0                	test   %eax,%eax
  8014e9:	79 a3                	jns    80148e <dup+0x78>
	sys_page_unmap(0, newfd);
  8014eb:	83 ec 08             	sub    $0x8,%esp
  8014ee:	56                   	push   %esi
  8014ef:	6a 00                	push   $0x0
  8014f1:	e8 d7 f7 ff ff       	call   800ccd <sys_page_unmap>
	sys_page_unmap(0, nva);
  8014f6:	83 c4 08             	add    $0x8,%esp
  8014f9:	57                   	push   %edi
  8014fa:	6a 00                	push   $0x0
  8014fc:	e8 cc f7 ff ff       	call   800ccd <sys_page_unmap>
	return r;
  801501:	83 c4 10             	add    $0x10,%esp
  801504:	eb b7                	jmp    8014bd <dup+0xa7>

00801506 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801506:	f3 0f 1e fb          	endbr32 
  80150a:	55                   	push   %ebp
  80150b:	89 e5                	mov    %esp,%ebp
  80150d:	53                   	push   %ebx
  80150e:	83 ec 1c             	sub    $0x1c,%esp
  801511:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801514:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801517:	50                   	push   %eax
  801518:	53                   	push   %ebx
  801519:	e8 60 fd ff ff       	call   80127e <fd_lookup>
  80151e:	83 c4 10             	add    $0x10,%esp
  801521:	85 c0                	test   %eax,%eax
  801523:	78 3f                	js     801564 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801525:	83 ec 08             	sub    $0x8,%esp
  801528:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80152b:	50                   	push   %eax
  80152c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152f:	ff 30                	pushl  (%eax)
  801531:	e8 9c fd ff ff       	call   8012d2 <dev_lookup>
  801536:	83 c4 10             	add    $0x10,%esp
  801539:	85 c0                	test   %eax,%eax
  80153b:	78 27                	js     801564 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80153d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801540:	8b 42 08             	mov    0x8(%edx),%eax
  801543:	83 e0 03             	and    $0x3,%eax
  801546:	83 f8 01             	cmp    $0x1,%eax
  801549:	74 1e                	je     801569 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80154b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80154e:	8b 40 08             	mov    0x8(%eax),%eax
  801551:	85 c0                	test   %eax,%eax
  801553:	74 35                	je     80158a <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801555:	83 ec 04             	sub    $0x4,%esp
  801558:	ff 75 10             	pushl  0x10(%ebp)
  80155b:	ff 75 0c             	pushl  0xc(%ebp)
  80155e:	52                   	push   %edx
  80155f:	ff d0                	call   *%eax
  801561:	83 c4 10             	add    $0x10,%esp
}
  801564:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801567:	c9                   	leave  
  801568:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801569:	a1 08 40 80 00       	mov    0x804008,%eax
  80156e:	8b 40 48             	mov    0x48(%eax),%eax
  801571:	83 ec 04             	sub    $0x4,%esp
  801574:	53                   	push   %ebx
  801575:	50                   	push   %eax
  801576:	68 bd 2c 80 00       	push   $0x802cbd
  80157b:	e8 74 ec ff ff       	call   8001f4 <cprintf>
		return -E_INVAL;
  801580:	83 c4 10             	add    $0x10,%esp
  801583:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801588:	eb da                	jmp    801564 <read+0x5e>
		return -E_NOT_SUPP;
  80158a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80158f:	eb d3                	jmp    801564 <read+0x5e>

00801591 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801591:	f3 0f 1e fb          	endbr32 
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
  801598:	57                   	push   %edi
  801599:	56                   	push   %esi
  80159a:	53                   	push   %ebx
  80159b:	83 ec 0c             	sub    $0xc,%esp
  80159e:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015a1:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015a4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015a9:	eb 02                	jmp    8015ad <readn+0x1c>
  8015ab:	01 c3                	add    %eax,%ebx
  8015ad:	39 f3                	cmp    %esi,%ebx
  8015af:	73 21                	jae    8015d2 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015b1:	83 ec 04             	sub    $0x4,%esp
  8015b4:	89 f0                	mov    %esi,%eax
  8015b6:	29 d8                	sub    %ebx,%eax
  8015b8:	50                   	push   %eax
  8015b9:	89 d8                	mov    %ebx,%eax
  8015bb:	03 45 0c             	add    0xc(%ebp),%eax
  8015be:	50                   	push   %eax
  8015bf:	57                   	push   %edi
  8015c0:	e8 41 ff ff ff       	call   801506 <read>
		if (m < 0)
  8015c5:	83 c4 10             	add    $0x10,%esp
  8015c8:	85 c0                	test   %eax,%eax
  8015ca:	78 04                	js     8015d0 <readn+0x3f>
			return m;
		if (m == 0)
  8015cc:	75 dd                	jne    8015ab <readn+0x1a>
  8015ce:	eb 02                	jmp    8015d2 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015d0:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8015d2:	89 d8                	mov    %ebx,%eax
  8015d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015d7:	5b                   	pop    %ebx
  8015d8:	5e                   	pop    %esi
  8015d9:	5f                   	pop    %edi
  8015da:	5d                   	pop    %ebp
  8015db:	c3                   	ret    

008015dc <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015dc:	f3 0f 1e fb          	endbr32 
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
  8015e3:	53                   	push   %ebx
  8015e4:	83 ec 1c             	sub    $0x1c,%esp
  8015e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015ea:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015ed:	50                   	push   %eax
  8015ee:	53                   	push   %ebx
  8015ef:	e8 8a fc ff ff       	call   80127e <fd_lookup>
  8015f4:	83 c4 10             	add    $0x10,%esp
  8015f7:	85 c0                	test   %eax,%eax
  8015f9:	78 3a                	js     801635 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015fb:	83 ec 08             	sub    $0x8,%esp
  8015fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801601:	50                   	push   %eax
  801602:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801605:	ff 30                	pushl  (%eax)
  801607:	e8 c6 fc ff ff       	call   8012d2 <dev_lookup>
  80160c:	83 c4 10             	add    $0x10,%esp
  80160f:	85 c0                	test   %eax,%eax
  801611:	78 22                	js     801635 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801613:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801616:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80161a:	74 1e                	je     80163a <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80161c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80161f:	8b 52 0c             	mov    0xc(%edx),%edx
  801622:	85 d2                	test   %edx,%edx
  801624:	74 35                	je     80165b <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801626:	83 ec 04             	sub    $0x4,%esp
  801629:	ff 75 10             	pushl  0x10(%ebp)
  80162c:	ff 75 0c             	pushl  0xc(%ebp)
  80162f:	50                   	push   %eax
  801630:	ff d2                	call   *%edx
  801632:	83 c4 10             	add    $0x10,%esp
}
  801635:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801638:	c9                   	leave  
  801639:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80163a:	a1 08 40 80 00       	mov    0x804008,%eax
  80163f:	8b 40 48             	mov    0x48(%eax),%eax
  801642:	83 ec 04             	sub    $0x4,%esp
  801645:	53                   	push   %ebx
  801646:	50                   	push   %eax
  801647:	68 d9 2c 80 00       	push   $0x802cd9
  80164c:	e8 a3 eb ff ff       	call   8001f4 <cprintf>
		return -E_INVAL;
  801651:	83 c4 10             	add    $0x10,%esp
  801654:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801659:	eb da                	jmp    801635 <write+0x59>
		return -E_NOT_SUPP;
  80165b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801660:	eb d3                	jmp    801635 <write+0x59>

00801662 <seek>:

int
seek(int fdnum, off_t offset)
{
  801662:	f3 0f 1e fb          	endbr32 
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
  801669:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80166c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80166f:	50                   	push   %eax
  801670:	ff 75 08             	pushl  0x8(%ebp)
  801673:	e8 06 fc ff ff       	call   80127e <fd_lookup>
  801678:	83 c4 10             	add    $0x10,%esp
  80167b:	85 c0                	test   %eax,%eax
  80167d:	78 0e                	js     80168d <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80167f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801685:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801688:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80168d:	c9                   	leave  
  80168e:	c3                   	ret    

0080168f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80168f:	f3 0f 1e fb          	endbr32 
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
  801696:	53                   	push   %ebx
  801697:	83 ec 1c             	sub    $0x1c,%esp
  80169a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80169d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016a0:	50                   	push   %eax
  8016a1:	53                   	push   %ebx
  8016a2:	e8 d7 fb ff ff       	call   80127e <fd_lookup>
  8016a7:	83 c4 10             	add    $0x10,%esp
  8016aa:	85 c0                	test   %eax,%eax
  8016ac:	78 37                	js     8016e5 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016ae:	83 ec 08             	sub    $0x8,%esp
  8016b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016b4:	50                   	push   %eax
  8016b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b8:	ff 30                	pushl  (%eax)
  8016ba:	e8 13 fc ff ff       	call   8012d2 <dev_lookup>
  8016bf:	83 c4 10             	add    $0x10,%esp
  8016c2:	85 c0                	test   %eax,%eax
  8016c4:	78 1f                	js     8016e5 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016cd:	74 1b                	je     8016ea <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8016cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016d2:	8b 52 18             	mov    0x18(%edx),%edx
  8016d5:	85 d2                	test   %edx,%edx
  8016d7:	74 32                	je     80170b <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8016d9:	83 ec 08             	sub    $0x8,%esp
  8016dc:	ff 75 0c             	pushl  0xc(%ebp)
  8016df:	50                   	push   %eax
  8016e0:	ff d2                	call   *%edx
  8016e2:	83 c4 10             	add    $0x10,%esp
}
  8016e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016e8:	c9                   	leave  
  8016e9:	c3                   	ret    
			thisenv->env_id, fdnum);
  8016ea:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016ef:	8b 40 48             	mov    0x48(%eax),%eax
  8016f2:	83 ec 04             	sub    $0x4,%esp
  8016f5:	53                   	push   %ebx
  8016f6:	50                   	push   %eax
  8016f7:	68 9c 2c 80 00       	push   $0x802c9c
  8016fc:	e8 f3 ea ff ff       	call   8001f4 <cprintf>
		return -E_INVAL;
  801701:	83 c4 10             	add    $0x10,%esp
  801704:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801709:	eb da                	jmp    8016e5 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80170b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801710:	eb d3                	jmp    8016e5 <ftruncate+0x56>

00801712 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801712:	f3 0f 1e fb          	endbr32 
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
  801719:	53                   	push   %ebx
  80171a:	83 ec 1c             	sub    $0x1c,%esp
  80171d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801720:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801723:	50                   	push   %eax
  801724:	ff 75 08             	pushl  0x8(%ebp)
  801727:	e8 52 fb ff ff       	call   80127e <fd_lookup>
  80172c:	83 c4 10             	add    $0x10,%esp
  80172f:	85 c0                	test   %eax,%eax
  801731:	78 4b                	js     80177e <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801733:	83 ec 08             	sub    $0x8,%esp
  801736:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801739:	50                   	push   %eax
  80173a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80173d:	ff 30                	pushl  (%eax)
  80173f:	e8 8e fb ff ff       	call   8012d2 <dev_lookup>
  801744:	83 c4 10             	add    $0x10,%esp
  801747:	85 c0                	test   %eax,%eax
  801749:	78 33                	js     80177e <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80174b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80174e:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801752:	74 2f                	je     801783 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801754:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801757:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80175e:	00 00 00 
	stat->st_isdir = 0;
  801761:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801768:	00 00 00 
	stat->st_dev = dev;
  80176b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801771:	83 ec 08             	sub    $0x8,%esp
  801774:	53                   	push   %ebx
  801775:	ff 75 f0             	pushl  -0x10(%ebp)
  801778:	ff 50 14             	call   *0x14(%eax)
  80177b:	83 c4 10             	add    $0x10,%esp
}
  80177e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801781:	c9                   	leave  
  801782:	c3                   	ret    
		return -E_NOT_SUPP;
  801783:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801788:	eb f4                	jmp    80177e <fstat+0x6c>

0080178a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80178a:	f3 0f 1e fb          	endbr32 
  80178e:	55                   	push   %ebp
  80178f:	89 e5                	mov    %esp,%ebp
  801791:	56                   	push   %esi
  801792:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801793:	83 ec 08             	sub    $0x8,%esp
  801796:	6a 00                	push   $0x0
  801798:	ff 75 08             	pushl  0x8(%ebp)
  80179b:	e8 fb 01 00 00       	call   80199b <open>
  8017a0:	89 c3                	mov    %eax,%ebx
  8017a2:	83 c4 10             	add    $0x10,%esp
  8017a5:	85 c0                	test   %eax,%eax
  8017a7:	78 1b                	js     8017c4 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8017a9:	83 ec 08             	sub    $0x8,%esp
  8017ac:	ff 75 0c             	pushl  0xc(%ebp)
  8017af:	50                   	push   %eax
  8017b0:	e8 5d ff ff ff       	call   801712 <fstat>
  8017b5:	89 c6                	mov    %eax,%esi
	close(fd);
  8017b7:	89 1c 24             	mov    %ebx,(%esp)
  8017ba:	e8 fd fb ff ff       	call   8013bc <close>
	return r;
  8017bf:	83 c4 10             	add    $0x10,%esp
  8017c2:	89 f3                	mov    %esi,%ebx
}
  8017c4:	89 d8                	mov    %ebx,%eax
  8017c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017c9:	5b                   	pop    %ebx
  8017ca:	5e                   	pop    %esi
  8017cb:	5d                   	pop    %ebp
  8017cc:	c3                   	ret    

008017cd <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
  8017d0:	56                   	push   %esi
  8017d1:	53                   	push   %ebx
  8017d2:	89 c6                	mov    %eax,%esi
  8017d4:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8017d6:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8017dd:	74 27                	je     801806 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8017df:	6a 07                	push   $0x7
  8017e1:	68 00 50 80 00       	push   $0x805000
  8017e6:	56                   	push   %esi
  8017e7:	ff 35 00 40 80 00    	pushl  0x804000
  8017ed:	e8 71 0d 00 00       	call   802563 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017f2:	83 c4 0c             	add    $0xc,%esp
  8017f5:	6a 00                	push   $0x0
  8017f7:	53                   	push   %ebx
  8017f8:	6a 00                	push   $0x0
  8017fa:	e8 df 0c 00 00       	call   8024de <ipc_recv>
}
  8017ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801802:	5b                   	pop    %ebx
  801803:	5e                   	pop    %esi
  801804:	5d                   	pop    %ebp
  801805:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801806:	83 ec 0c             	sub    $0xc,%esp
  801809:	6a 01                	push   $0x1
  80180b:	e8 ab 0d 00 00       	call   8025bb <ipc_find_env>
  801810:	a3 00 40 80 00       	mov    %eax,0x804000
  801815:	83 c4 10             	add    $0x10,%esp
  801818:	eb c5                	jmp    8017df <fsipc+0x12>

0080181a <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80181a:	f3 0f 1e fb          	endbr32 
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
  801821:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801824:	8b 45 08             	mov    0x8(%ebp),%eax
  801827:	8b 40 0c             	mov    0xc(%eax),%eax
  80182a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80182f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801832:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801837:	ba 00 00 00 00       	mov    $0x0,%edx
  80183c:	b8 02 00 00 00       	mov    $0x2,%eax
  801841:	e8 87 ff ff ff       	call   8017cd <fsipc>
}
  801846:	c9                   	leave  
  801847:	c3                   	ret    

00801848 <devfile_flush>:
{
  801848:	f3 0f 1e fb          	endbr32 
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
  80184f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801852:	8b 45 08             	mov    0x8(%ebp),%eax
  801855:	8b 40 0c             	mov    0xc(%eax),%eax
  801858:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80185d:	ba 00 00 00 00       	mov    $0x0,%edx
  801862:	b8 06 00 00 00       	mov    $0x6,%eax
  801867:	e8 61 ff ff ff       	call   8017cd <fsipc>
}
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    

0080186e <devfile_stat>:
{
  80186e:	f3 0f 1e fb          	endbr32 
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	53                   	push   %ebx
  801876:	83 ec 04             	sub    $0x4,%esp
  801879:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80187c:	8b 45 08             	mov    0x8(%ebp),%eax
  80187f:	8b 40 0c             	mov    0xc(%eax),%eax
  801882:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801887:	ba 00 00 00 00       	mov    $0x0,%edx
  80188c:	b8 05 00 00 00       	mov    $0x5,%eax
  801891:	e8 37 ff ff ff       	call   8017cd <fsipc>
  801896:	85 c0                	test   %eax,%eax
  801898:	78 2c                	js     8018c6 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80189a:	83 ec 08             	sub    $0x8,%esp
  80189d:	68 00 50 80 00       	push   $0x805000
  8018a2:	53                   	push   %ebx
  8018a3:	e8 56 ef ff ff       	call   8007fe <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8018a8:	a1 80 50 80 00       	mov    0x805080,%eax
  8018ad:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8018b3:	a1 84 50 80 00       	mov    0x805084,%eax
  8018b8:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8018be:	83 c4 10             	add    $0x10,%esp
  8018c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018c9:	c9                   	leave  
  8018ca:	c3                   	ret    

008018cb <devfile_write>:
{
  8018cb:	f3 0f 1e fb          	endbr32 
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
  8018d2:	83 ec 0c             	sub    $0xc,%esp
  8018d5:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8018d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8018db:	8b 52 0c             	mov    0xc(%edx),%edx
  8018de:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  8018e4:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8018e9:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8018ee:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  8018f1:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  8018f6:	50                   	push   %eax
  8018f7:	ff 75 0c             	pushl  0xc(%ebp)
  8018fa:	68 08 50 80 00       	push   $0x805008
  8018ff:	e8 b0 f0 ff ff       	call   8009b4 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801904:	ba 00 00 00 00       	mov    $0x0,%edx
  801909:	b8 04 00 00 00       	mov    $0x4,%eax
  80190e:	e8 ba fe ff ff       	call   8017cd <fsipc>
}
  801913:	c9                   	leave  
  801914:	c3                   	ret    

00801915 <devfile_read>:
{
  801915:	f3 0f 1e fb          	endbr32 
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
  80191c:	56                   	push   %esi
  80191d:	53                   	push   %ebx
  80191e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801921:	8b 45 08             	mov    0x8(%ebp),%eax
  801924:	8b 40 0c             	mov    0xc(%eax),%eax
  801927:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80192c:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801932:	ba 00 00 00 00       	mov    $0x0,%edx
  801937:	b8 03 00 00 00       	mov    $0x3,%eax
  80193c:	e8 8c fe ff ff       	call   8017cd <fsipc>
  801941:	89 c3                	mov    %eax,%ebx
  801943:	85 c0                	test   %eax,%eax
  801945:	78 1f                	js     801966 <devfile_read+0x51>
	assert(r <= n);
  801947:	39 f0                	cmp    %esi,%eax
  801949:	77 24                	ja     80196f <devfile_read+0x5a>
	assert(r <= PGSIZE);
  80194b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801950:	7f 33                	jg     801985 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801952:	83 ec 04             	sub    $0x4,%esp
  801955:	50                   	push   %eax
  801956:	68 00 50 80 00       	push   $0x805000
  80195b:	ff 75 0c             	pushl  0xc(%ebp)
  80195e:	e8 51 f0 ff ff       	call   8009b4 <memmove>
	return r;
  801963:	83 c4 10             	add    $0x10,%esp
}
  801966:	89 d8                	mov    %ebx,%eax
  801968:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80196b:	5b                   	pop    %ebx
  80196c:	5e                   	pop    %esi
  80196d:	5d                   	pop    %ebp
  80196e:	c3                   	ret    
	assert(r <= n);
  80196f:	68 0c 2d 80 00       	push   $0x802d0c
  801974:	68 13 2d 80 00       	push   $0x802d13
  801979:	6a 7c                	push   $0x7c
  80197b:	68 28 2d 80 00       	push   $0x802d28
  801980:	e8 76 0a 00 00       	call   8023fb <_panic>
	assert(r <= PGSIZE);
  801985:	68 33 2d 80 00       	push   $0x802d33
  80198a:	68 13 2d 80 00       	push   $0x802d13
  80198f:	6a 7d                	push   $0x7d
  801991:	68 28 2d 80 00       	push   $0x802d28
  801996:	e8 60 0a 00 00       	call   8023fb <_panic>

0080199b <open>:
{
  80199b:	f3 0f 1e fb          	endbr32 
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
  8019a2:	56                   	push   %esi
  8019a3:	53                   	push   %ebx
  8019a4:	83 ec 1c             	sub    $0x1c,%esp
  8019a7:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8019aa:	56                   	push   %esi
  8019ab:	e8 0b ee ff ff       	call   8007bb <strlen>
  8019b0:	83 c4 10             	add    $0x10,%esp
  8019b3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8019b8:	7f 6c                	jg     801a26 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8019ba:	83 ec 0c             	sub    $0xc,%esp
  8019bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019c0:	50                   	push   %eax
  8019c1:	e8 62 f8 ff ff       	call   801228 <fd_alloc>
  8019c6:	89 c3                	mov    %eax,%ebx
  8019c8:	83 c4 10             	add    $0x10,%esp
  8019cb:	85 c0                	test   %eax,%eax
  8019cd:	78 3c                	js     801a0b <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8019cf:	83 ec 08             	sub    $0x8,%esp
  8019d2:	56                   	push   %esi
  8019d3:	68 00 50 80 00       	push   $0x805000
  8019d8:	e8 21 ee ff ff       	call   8007fe <strcpy>
	fsipcbuf.open.req_omode = mode;
  8019dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e0:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8019e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019e8:	b8 01 00 00 00       	mov    $0x1,%eax
  8019ed:	e8 db fd ff ff       	call   8017cd <fsipc>
  8019f2:	89 c3                	mov    %eax,%ebx
  8019f4:	83 c4 10             	add    $0x10,%esp
  8019f7:	85 c0                	test   %eax,%eax
  8019f9:	78 19                	js     801a14 <open+0x79>
	return fd2num(fd);
  8019fb:	83 ec 0c             	sub    $0xc,%esp
  8019fe:	ff 75 f4             	pushl  -0xc(%ebp)
  801a01:	e8 f3 f7 ff ff       	call   8011f9 <fd2num>
  801a06:	89 c3                	mov    %eax,%ebx
  801a08:	83 c4 10             	add    $0x10,%esp
}
  801a0b:	89 d8                	mov    %ebx,%eax
  801a0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a10:	5b                   	pop    %ebx
  801a11:	5e                   	pop    %esi
  801a12:	5d                   	pop    %ebp
  801a13:	c3                   	ret    
		fd_close(fd, 0);
  801a14:	83 ec 08             	sub    $0x8,%esp
  801a17:	6a 00                	push   $0x0
  801a19:	ff 75 f4             	pushl  -0xc(%ebp)
  801a1c:	e8 10 f9 ff ff       	call   801331 <fd_close>
		return r;
  801a21:	83 c4 10             	add    $0x10,%esp
  801a24:	eb e5                	jmp    801a0b <open+0x70>
		return -E_BAD_PATH;
  801a26:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a2b:	eb de                	jmp    801a0b <open+0x70>

00801a2d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a2d:	f3 0f 1e fb          	endbr32 
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
  801a34:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a37:	ba 00 00 00 00       	mov    $0x0,%edx
  801a3c:	b8 08 00 00 00       	mov    $0x8,%eax
  801a41:	e8 87 fd ff ff       	call   8017cd <fsipc>
}
  801a46:	c9                   	leave  
  801a47:	c3                   	ret    

00801a48 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801a48:	f3 0f 1e fb          	endbr32 
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
  801a4f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801a52:	68 3f 2d 80 00       	push   $0x802d3f
  801a57:	ff 75 0c             	pushl  0xc(%ebp)
  801a5a:	e8 9f ed ff ff       	call   8007fe <strcpy>
	return 0;
}
  801a5f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a64:	c9                   	leave  
  801a65:	c3                   	ret    

00801a66 <devsock_close>:
{
  801a66:	f3 0f 1e fb          	endbr32 
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
  801a6d:	53                   	push   %ebx
  801a6e:	83 ec 10             	sub    $0x10,%esp
  801a71:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801a74:	53                   	push   %ebx
  801a75:	e8 7e 0b 00 00       	call   8025f8 <pageref>
  801a7a:	89 c2                	mov    %eax,%edx
  801a7c:	83 c4 10             	add    $0x10,%esp
		return 0;
  801a7f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801a84:	83 fa 01             	cmp    $0x1,%edx
  801a87:	74 05                	je     801a8e <devsock_close+0x28>
}
  801a89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801a8e:	83 ec 0c             	sub    $0xc,%esp
  801a91:	ff 73 0c             	pushl  0xc(%ebx)
  801a94:	e8 e3 02 00 00       	call   801d7c <nsipc_close>
  801a99:	83 c4 10             	add    $0x10,%esp
  801a9c:	eb eb                	jmp    801a89 <devsock_close+0x23>

00801a9e <devsock_write>:
{
  801a9e:	f3 0f 1e fb          	endbr32 
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
  801aa5:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801aa8:	6a 00                	push   $0x0
  801aaa:	ff 75 10             	pushl  0x10(%ebp)
  801aad:	ff 75 0c             	pushl  0xc(%ebp)
  801ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab3:	ff 70 0c             	pushl  0xc(%eax)
  801ab6:	e8 b5 03 00 00       	call   801e70 <nsipc_send>
}
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    

00801abd <devsock_read>:
{
  801abd:	f3 0f 1e fb          	endbr32 
  801ac1:	55                   	push   %ebp
  801ac2:	89 e5                	mov    %esp,%ebp
  801ac4:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ac7:	6a 00                	push   $0x0
  801ac9:	ff 75 10             	pushl  0x10(%ebp)
  801acc:	ff 75 0c             	pushl  0xc(%ebp)
  801acf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad2:	ff 70 0c             	pushl  0xc(%eax)
  801ad5:	e8 1f 03 00 00       	call   801df9 <nsipc_recv>
}
  801ada:	c9                   	leave  
  801adb:	c3                   	ret    

00801adc <fd2sockid>:
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
  801adf:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ae2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ae5:	52                   	push   %edx
  801ae6:	50                   	push   %eax
  801ae7:	e8 92 f7 ff ff       	call   80127e <fd_lookup>
  801aec:	83 c4 10             	add    $0x10,%esp
  801aef:	85 c0                	test   %eax,%eax
  801af1:	78 10                	js     801b03 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af6:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801afc:	39 08                	cmp    %ecx,(%eax)
  801afe:	75 05                	jne    801b05 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801b00:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    
		return -E_NOT_SUPP;
  801b05:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b0a:	eb f7                	jmp    801b03 <fd2sockid+0x27>

00801b0c <alloc_sockfd>:
{
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
  801b0f:	56                   	push   %esi
  801b10:	53                   	push   %ebx
  801b11:	83 ec 1c             	sub    $0x1c,%esp
  801b14:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801b16:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b19:	50                   	push   %eax
  801b1a:	e8 09 f7 ff ff       	call   801228 <fd_alloc>
  801b1f:	89 c3                	mov    %eax,%ebx
  801b21:	83 c4 10             	add    $0x10,%esp
  801b24:	85 c0                	test   %eax,%eax
  801b26:	78 43                	js     801b6b <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801b28:	83 ec 04             	sub    $0x4,%esp
  801b2b:	68 07 04 00 00       	push   $0x407
  801b30:	ff 75 f4             	pushl  -0xc(%ebp)
  801b33:	6a 00                	push   $0x0
  801b35:	e8 06 f1 ff ff       	call   800c40 <sys_page_alloc>
  801b3a:	89 c3                	mov    %eax,%ebx
  801b3c:	83 c4 10             	add    $0x10,%esp
  801b3f:	85 c0                	test   %eax,%eax
  801b41:	78 28                	js     801b6b <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b46:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b4c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b51:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801b58:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801b5b:	83 ec 0c             	sub    $0xc,%esp
  801b5e:	50                   	push   %eax
  801b5f:	e8 95 f6 ff ff       	call   8011f9 <fd2num>
  801b64:	89 c3                	mov    %eax,%ebx
  801b66:	83 c4 10             	add    $0x10,%esp
  801b69:	eb 0c                	jmp    801b77 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801b6b:	83 ec 0c             	sub    $0xc,%esp
  801b6e:	56                   	push   %esi
  801b6f:	e8 08 02 00 00       	call   801d7c <nsipc_close>
		return r;
  801b74:	83 c4 10             	add    $0x10,%esp
}
  801b77:	89 d8                	mov    %ebx,%eax
  801b79:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b7c:	5b                   	pop    %ebx
  801b7d:	5e                   	pop    %esi
  801b7e:	5d                   	pop    %ebp
  801b7f:	c3                   	ret    

00801b80 <accept>:
{
  801b80:	f3 0f 1e fb          	endbr32 
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
  801b87:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8d:	e8 4a ff ff ff       	call   801adc <fd2sockid>
  801b92:	85 c0                	test   %eax,%eax
  801b94:	78 1b                	js     801bb1 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b96:	83 ec 04             	sub    $0x4,%esp
  801b99:	ff 75 10             	pushl  0x10(%ebp)
  801b9c:	ff 75 0c             	pushl  0xc(%ebp)
  801b9f:	50                   	push   %eax
  801ba0:	e8 22 01 00 00       	call   801cc7 <nsipc_accept>
  801ba5:	83 c4 10             	add    $0x10,%esp
  801ba8:	85 c0                	test   %eax,%eax
  801baa:	78 05                	js     801bb1 <accept+0x31>
	return alloc_sockfd(r);
  801bac:	e8 5b ff ff ff       	call   801b0c <alloc_sockfd>
}
  801bb1:	c9                   	leave  
  801bb2:	c3                   	ret    

00801bb3 <bind>:
{
  801bb3:	f3 0f 1e fb          	endbr32 
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
  801bba:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc0:	e8 17 ff ff ff       	call   801adc <fd2sockid>
  801bc5:	85 c0                	test   %eax,%eax
  801bc7:	78 12                	js     801bdb <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801bc9:	83 ec 04             	sub    $0x4,%esp
  801bcc:	ff 75 10             	pushl  0x10(%ebp)
  801bcf:	ff 75 0c             	pushl  0xc(%ebp)
  801bd2:	50                   	push   %eax
  801bd3:	e8 45 01 00 00       	call   801d1d <nsipc_bind>
  801bd8:	83 c4 10             	add    $0x10,%esp
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <shutdown>:
{
  801bdd:	f3 0f 1e fb          	endbr32 
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
  801be4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801be7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bea:	e8 ed fe ff ff       	call   801adc <fd2sockid>
  801bef:	85 c0                	test   %eax,%eax
  801bf1:	78 0f                	js     801c02 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801bf3:	83 ec 08             	sub    $0x8,%esp
  801bf6:	ff 75 0c             	pushl  0xc(%ebp)
  801bf9:	50                   	push   %eax
  801bfa:	e8 57 01 00 00       	call   801d56 <nsipc_shutdown>
  801bff:	83 c4 10             	add    $0x10,%esp
}
  801c02:	c9                   	leave  
  801c03:	c3                   	ret    

00801c04 <connect>:
{
  801c04:	f3 0f 1e fb          	endbr32 
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
  801c0b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c11:	e8 c6 fe ff ff       	call   801adc <fd2sockid>
  801c16:	85 c0                	test   %eax,%eax
  801c18:	78 12                	js     801c2c <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801c1a:	83 ec 04             	sub    $0x4,%esp
  801c1d:	ff 75 10             	pushl  0x10(%ebp)
  801c20:	ff 75 0c             	pushl  0xc(%ebp)
  801c23:	50                   	push   %eax
  801c24:	e8 71 01 00 00       	call   801d9a <nsipc_connect>
  801c29:	83 c4 10             	add    $0x10,%esp
}
  801c2c:	c9                   	leave  
  801c2d:	c3                   	ret    

00801c2e <listen>:
{
  801c2e:	f3 0f 1e fb          	endbr32 
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
  801c35:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c38:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3b:	e8 9c fe ff ff       	call   801adc <fd2sockid>
  801c40:	85 c0                	test   %eax,%eax
  801c42:	78 0f                	js     801c53 <listen+0x25>
	return nsipc_listen(r, backlog);
  801c44:	83 ec 08             	sub    $0x8,%esp
  801c47:	ff 75 0c             	pushl  0xc(%ebp)
  801c4a:	50                   	push   %eax
  801c4b:	e8 83 01 00 00       	call   801dd3 <nsipc_listen>
  801c50:	83 c4 10             	add    $0x10,%esp
}
  801c53:	c9                   	leave  
  801c54:	c3                   	ret    

00801c55 <socket>:

int
socket(int domain, int type, int protocol)
{
  801c55:	f3 0f 1e fb          	endbr32 
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
  801c5c:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801c5f:	ff 75 10             	pushl  0x10(%ebp)
  801c62:	ff 75 0c             	pushl  0xc(%ebp)
  801c65:	ff 75 08             	pushl  0x8(%ebp)
  801c68:	e8 65 02 00 00       	call   801ed2 <nsipc_socket>
  801c6d:	83 c4 10             	add    $0x10,%esp
  801c70:	85 c0                	test   %eax,%eax
  801c72:	78 05                	js     801c79 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801c74:	e8 93 fe ff ff       	call   801b0c <alloc_sockfd>
}
  801c79:	c9                   	leave  
  801c7a:	c3                   	ret    

00801c7b <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801c7b:	55                   	push   %ebp
  801c7c:	89 e5                	mov    %esp,%ebp
  801c7e:	53                   	push   %ebx
  801c7f:	83 ec 04             	sub    $0x4,%esp
  801c82:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801c84:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801c8b:	74 26                	je     801cb3 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801c8d:	6a 07                	push   $0x7
  801c8f:	68 00 60 80 00       	push   $0x806000
  801c94:	53                   	push   %ebx
  801c95:	ff 35 04 40 80 00    	pushl  0x804004
  801c9b:	e8 c3 08 00 00       	call   802563 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ca0:	83 c4 0c             	add    $0xc,%esp
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	e8 30 08 00 00       	call   8024de <ipc_recv>
}
  801cae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801cb3:	83 ec 0c             	sub    $0xc,%esp
  801cb6:	6a 02                	push   $0x2
  801cb8:	e8 fe 08 00 00       	call   8025bb <ipc_find_env>
  801cbd:	a3 04 40 80 00       	mov    %eax,0x804004
  801cc2:	83 c4 10             	add    $0x10,%esp
  801cc5:	eb c6                	jmp    801c8d <nsipc+0x12>

00801cc7 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801cc7:	f3 0f 1e fb          	endbr32 
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
  801cce:	56                   	push   %esi
  801ccf:	53                   	push   %ebx
  801cd0:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801cdb:	8b 06                	mov    (%esi),%eax
  801cdd:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ce2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ce7:	e8 8f ff ff ff       	call   801c7b <nsipc>
  801cec:	89 c3                	mov    %eax,%ebx
  801cee:	85 c0                	test   %eax,%eax
  801cf0:	79 09                	jns    801cfb <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801cf2:	89 d8                	mov    %ebx,%eax
  801cf4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cf7:	5b                   	pop    %ebx
  801cf8:	5e                   	pop    %esi
  801cf9:	5d                   	pop    %ebp
  801cfa:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801cfb:	83 ec 04             	sub    $0x4,%esp
  801cfe:	ff 35 10 60 80 00    	pushl  0x806010
  801d04:	68 00 60 80 00       	push   $0x806000
  801d09:	ff 75 0c             	pushl  0xc(%ebp)
  801d0c:	e8 a3 ec ff ff       	call   8009b4 <memmove>
		*addrlen = ret->ret_addrlen;
  801d11:	a1 10 60 80 00       	mov    0x806010,%eax
  801d16:	89 06                	mov    %eax,(%esi)
  801d18:	83 c4 10             	add    $0x10,%esp
	return r;
  801d1b:	eb d5                	jmp    801cf2 <nsipc_accept+0x2b>

00801d1d <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801d1d:	f3 0f 1e fb          	endbr32 
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
  801d24:	53                   	push   %ebx
  801d25:	83 ec 08             	sub    $0x8,%esp
  801d28:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801d33:	53                   	push   %ebx
  801d34:	ff 75 0c             	pushl  0xc(%ebp)
  801d37:	68 04 60 80 00       	push   $0x806004
  801d3c:	e8 73 ec ff ff       	call   8009b4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801d41:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801d47:	b8 02 00 00 00       	mov    $0x2,%eax
  801d4c:	e8 2a ff ff ff       	call   801c7b <nsipc>
}
  801d51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d54:	c9                   	leave  
  801d55:	c3                   	ret    

00801d56 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801d56:	f3 0f 1e fb          	endbr32 
  801d5a:	55                   	push   %ebp
  801d5b:	89 e5                	mov    %esp,%ebp
  801d5d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801d60:	8b 45 08             	mov    0x8(%ebp),%eax
  801d63:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801d68:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d6b:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801d70:	b8 03 00 00 00       	mov    $0x3,%eax
  801d75:	e8 01 ff ff ff       	call   801c7b <nsipc>
}
  801d7a:	c9                   	leave  
  801d7b:	c3                   	ret    

00801d7c <nsipc_close>:

int
nsipc_close(int s)
{
  801d7c:	f3 0f 1e fb          	endbr32 
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
  801d83:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801d86:	8b 45 08             	mov    0x8(%ebp),%eax
  801d89:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801d8e:	b8 04 00 00 00       	mov    $0x4,%eax
  801d93:	e8 e3 fe ff ff       	call   801c7b <nsipc>
}
  801d98:	c9                   	leave  
  801d99:	c3                   	ret    

00801d9a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d9a:	f3 0f 1e fb          	endbr32 
  801d9e:	55                   	push   %ebp
  801d9f:	89 e5                	mov    %esp,%ebp
  801da1:	53                   	push   %ebx
  801da2:	83 ec 08             	sub    $0x8,%esp
  801da5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801da8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dab:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801db0:	53                   	push   %ebx
  801db1:	ff 75 0c             	pushl  0xc(%ebp)
  801db4:	68 04 60 80 00       	push   $0x806004
  801db9:	e8 f6 eb ff ff       	call   8009b4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801dbe:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801dc4:	b8 05 00 00 00       	mov    $0x5,%eax
  801dc9:	e8 ad fe ff ff       	call   801c7b <nsipc>
}
  801dce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    

00801dd3 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801dd3:	f3 0f 1e fb          	endbr32 
  801dd7:	55                   	push   %ebp
  801dd8:	89 e5                	mov    %esp,%ebp
  801dda:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  801de0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801de5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de8:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801ded:	b8 06 00 00 00       	mov    $0x6,%eax
  801df2:	e8 84 fe ff ff       	call   801c7b <nsipc>
}
  801df7:	c9                   	leave  
  801df8:	c3                   	ret    

00801df9 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801df9:	f3 0f 1e fb          	endbr32 
  801dfd:	55                   	push   %ebp
  801dfe:	89 e5                	mov    %esp,%ebp
  801e00:	56                   	push   %esi
  801e01:	53                   	push   %ebx
  801e02:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801e05:	8b 45 08             	mov    0x8(%ebp),%eax
  801e08:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801e0d:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801e13:	8b 45 14             	mov    0x14(%ebp),%eax
  801e16:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801e1b:	b8 07 00 00 00       	mov    $0x7,%eax
  801e20:	e8 56 fe ff ff       	call   801c7b <nsipc>
  801e25:	89 c3                	mov    %eax,%ebx
  801e27:	85 c0                	test   %eax,%eax
  801e29:	78 26                	js     801e51 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801e2b:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801e31:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801e36:	0f 4e c6             	cmovle %esi,%eax
  801e39:	39 c3                	cmp    %eax,%ebx
  801e3b:	7f 1d                	jg     801e5a <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801e3d:	83 ec 04             	sub    $0x4,%esp
  801e40:	53                   	push   %ebx
  801e41:	68 00 60 80 00       	push   $0x806000
  801e46:	ff 75 0c             	pushl  0xc(%ebp)
  801e49:	e8 66 eb ff ff       	call   8009b4 <memmove>
  801e4e:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801e51:	89 d8                	mov    %ebx,%eax
  801e53:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e56:	5b                   	pop    %ebx
  801e57:	5e                   	pop    %esi
  801e58:	5d                   	pop    %ebp
  801e59:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801e5a:	68 4b 2d 80 00       	push   $0x802d4b
  801e5f:	68 13 2d 80 00       	push   $0x802d13
  801e64:	6a 62                	push   $0x62
  801e66:	68 60 2d 80 00       	push   $0x802d60
  801e6b:	e8 8b 05 00 00       	call   8023fb <_panic>

00801e70 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801e70:	f3 0f 1e fb          	endbr32 
  801e74:	55                   	push   %ebp
  801e75:	89 e5                	mov    %esp,%ebp
  801e77:	53                   	push   %ebx
  801e78:	83 ec 04             	sub    $0x4,%esp
  801e7b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e81:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801e86:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801e8c:	7f 2e                	jg     801ebc <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e8e:	83 ec 04             	sub    $0x4,%esp
  801e91:	53                   	push   %ebx
  801e92:	ff 75 0c             	pushl  0xc(%ebp)
  801e95:	68 0c 60 80 00       	push   $0x80600c
  801e9a:	e8 15 eb ff ff       	call   8009b4 <memmove>
	nsipcbuf.send.req_size = size;
  801e9f:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801ea5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ea8:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801ead:	b8 08 00 00 00       	mov    $0x8,%eax
  801eb2:	e8 c4 fd ff ff       	call   801c7b <nsipc>
}
  801eb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eba:	c9                   	leave  
  801ebb:	c3                   	ret    
	assert(size < 1600);
  801ebc:	68 6c 2d 80 00       	push   $0x802d6c
  801ec1:	68 13 2d 80 00       	push   $0x802d13
  801ec6:	6a 6d                	push   $0x6d
  801ec8:	68 60 2d 80 00       	push   $0x802d60
  801ecd:	e8 29 05 00 00       	call   8023fb <_panic>

00801ed2 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801ed2:	f3 0f 1e fb          	endbr32 
  801ed6:	55                   	push   %ebp
  801ed7:	89 e5                	mov    %esp,%ebp
  801ed9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801edc:	8b 45 08             	mov    0x8(%ebp),%eax
  801edf:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801ee4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee7:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801eec:	8b 45 10             	mov    0x10(%ebp),%eax
  801eef:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801ef4:	b8 09 00 00 00       	mov    $0x9,%eax
  801ef9:	e8 7d fd ff ff       	call   801c7b <nsipc>
}
  801efe:	c9                   	leave  
  801eff:	c3                   	ret    

00801f00 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801f00:	f3 0f 1e fb          	endbr32 
  801f04:	55                   	push   %ebp
  801f05:	89 e5                	mov    %esp,%ebp
  801f07:	56                   	push   %esi
  801f08:	53                   	push   %ebx
  801f09:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801f0c:	83 ec 0c             	sub    $0xc,%esp
  801f0f:	ff 75 08             	pushl  0x8(%ebp)
  801f12:	e8 f6 f2 ff ff       	call   80120d <fd2data>
  801f17:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801f19:	83 c4 08             	add    $0x8,%esp
  801f1c:	68 78 2d 80 00       	push   $0x802d78
  801f21:	53                   	push   %ebx
  801f22:	e8 d7 e8 ff ff       	call   8007fe <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801f27:	8b 46 04             	mov    0x4(%esi),%eax
  801f2a:	2b 06                	sub    (%esi),%eax
  801f2c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801f32:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801f39:	00 00 00 
	stat->st_dev = &devpipe;
  801f3c:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801f43:	30 80 00 
	return 0;
}
  801f46:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f4e:	5b                   	pop    %ebx
  801f4f:	5e                   	pop    %esi
  801f50:	5d                   	pop    %ebp
  801f51:	c3                   	ret    

00801f52 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801f52:	f3 0f 1e fb          	endbr32 
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
  801f59:	53                   	push   %ebx
  801f5a:	83 ec 0c             	sub    $0xc,%esp
  801f5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801f60:	53                   	push   %ebx
  801f61:	6a 00                	push   $0x0
  801f63:	e8 65 ed ff ff       	call   800ccd <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f68:	89 1c 24             	mov    %ebx,(%esp)
  801f6b:	e8 9d f2 ff ff       	call   80120d <fd2data>
  801f70:	83 c4 08             	add    $0x8,%esp
  801f73:	50                   	push   %eax
  801f74:	6a 00                	push   $0x0
  801f76:	e8 52 ed ff ff       	call   800ccd <sys_page_unmap>
}
  801f7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f7e:	c9                   	leave  
  801f7f:	c3                   	ret    

00801f80 <_pipeisclosed>:
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
  801f83:	57                   	push   %edi
  801f84:	56                   	push   %esi
  801f85:	53                   	push   %ebx
  801f86:	83 ec 1c             	sub    $0x1c,%esp
  801f89:	89 c7                	mov    %eax,%edi
  801f8b:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801f8d:	a1 08 40 80 00       	mov    0x804008,%eax
  801f92:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f95:	83 ec 0c             	sub    $0xc,%esp
  801f98:	57                   	push   %edi
  801f99:	e8 5a 06 00 00       	call   8025f8 <pageref>
  801f9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801fa1:	89 34 24             	mov    %esi,(%esp)
  801fa4:	e8 4f 06 00 00       	call   8025f8 <pageref>
		nn = thisenv->env_runs;
  801fa9:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801faf:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801fb2:	83 c4 10             	add    $0x10,%esp
  801fb5:	39 cb                	cmp    %ecx,%ebx
  801fb7:	74 1b                	je     801fd4 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801fb9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801fbc:	75 cf                	jne    801f8d <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801fbe:	8b 42 58             	mov    0x58(%edx),%eax
  801fc1:	6a 01                	push   $0x1
  801fc3:	50                   	push   %eax
  801fc4:	53                   	push   %ebx
  801fc5:	68 7f 2d 80 00       	push   $0x802d7f
  801fca:	e8 25 e2 ff ff       	call   8001f4 <cprintf>
  801fcf:	83 c4 10             	add    $0x10,%esp
  801fd2:	eb b9                	jmp    801f8d <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801fd4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801fd7:	0f 94 c0             	sete   %al
  801fda:	0f b6 c0             	movzbl %al,%eax
}
  801fdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fe0:	5b                   	pop    %ebx
  801fe1:	5e                   	pop    %esi
  801fe2:	5f                   	pop    %edi
  801fe3:	5d                   	pop    %ebp
  801fe4:	c3                   	ret    

00801fe5 <devpipe_write>:
{
  801fe5:	f3 0f 1e fb          	endbr32 
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
  801fec:	57                   	push   %edi
  801fed:	56                   	push   %esi
  801fee:	53                   	push   %ebx
  801fef:	83 ec 28             	sub    $0x28,%esp
  801ff2:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801ff5:	56                   	push   %esi
  801ff6:	e8 12 f2 ff ff       	call   80120d <fd2data>
  801ffb:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ffd:	83 c4 10             	add    $0x10,%esp
  802000:	bf 00 00 00 00       	mov    $0x0,%edi
  802005:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802008:	74 4f                	je     802059 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80200a:	8b 43 04             	mov    0x4(%ebx),%eax
  80200d:	8b 0b                	mov    (%ebx),%ecx
  80200f:	8d 51 20             	lea    0x20(%ecx),%edx
  802012:	39 d0                	cmp    %edx,%eax
  802014:	72 14                	jb     80202a <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  802016:	89 da                	mov    %ebx,%edx
  802018:	89 f0                	mov    %esi,%eax
  80201a:	e8 61 ff ff ff       	call   801f80 <_pipeisclosed>
  80201f:	85 c0                	test   %eax,%eax
  802021:	75 3b                	jne    80205e <devpipe_write+0x79>
			sys_yield();
  802023:	e8 f5 eb ff ff       	call   800c1d <sys_yield>
  802028:	eb e0                	jmp    80200a <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80202a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80202d:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802031:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802034:	89 c2                	mov    %eax,%edx
  802036:	c1 fa 1f             	sar    $0x1f,%edx
  802039:	89 d1                	mov    %edx,%ecx
  80203b:	c1 e9 1b             	shr    $0x1b,%ecx
  80203e:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802041:	83 e2 1f             	and    $0x1f,%edx
  802044:	29 ca                	sub    %ecx,%edx
  802046:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80204a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80204e:	83 c0 01             	add    $0x1,%eax
  802051:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802054:	83 c7 01             	add    $0x1,%edi
  802057:	eb ac                	jmp    802005 <devpipe_write+0x20>
	return i;
  802059:	8b 45 10             	mov    0x10(%ebp),%eax
  80205c:	eb 05                	jmp    802063 <devpipe_write+0x7e>
				return 0;
  80205e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802063:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802066:	5b                   	pop    %ebx
  802067:	5e                   	pop    %esi
  802068:	5f                   	pop    %edi
  802069:	5d                   	pop    %ebp
  80206a:	c3                   	ret    

0080206b <devpipe_read>:
{
  80206b:	f3 0f 1e fb          	endbr32 
  80206f:	55                   	push   %ebp
  802070:	89 e5                	mov    %esp,%ebp
  802072:	57                   	push   %edi
  802073:	56                   	push   %esi
  802074:	53                   	push   %ebx
  802075:	83 ec 18             	sub    $0x18,%esp
  802078:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80207b:	57                   	push   %edi
  80207c:	e8 8c f1 ff ff       	call   80120d <fd2data>
  802081:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802083:	83 c4 10             	add    $0x10,%esp
  802086:	be 00 00 00 00       	mov    $0x0,%esi
  80208b:	3b 75 10             	cmp    0x10(%ebp),%esi
  80208e:	75 14                	jne    8020a4 <devpipe_read+0x39>
	return i;
  802090:	8b 45 10             	mov    0x10(%ebp),%eax
  802093:	eb 02                	jmp    802097 <devpipe_read+0x2c>
				return i;
  802095:	89 f0                	mov    %esi,%eax
}
  802097:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80209a:	5b                   	pop    %ebx
  80209b:	5e                   	pop    %esi
  80209c:	5f                   	pop    %edi
  80209d:	5d                   	pop    %ebp
  80209e:	c3                   	ret    
			sys_yield();
  80209f:	e8 79 eb ff ff       	call   800c1d <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8020a4:	8b 03                	mov    (%ebx),%eax
  8020a6:	3b 43 04             	cmp    0x4(%ebx),%eax
  8020a9:	75 18                	jne    8020c3 <devpipe_read+0x58>
			if (i > 0)
  8020ab:	85 f6                	test   %esi,%esi
  8020ad:	75 e6                	jne    802095 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8020af:	89 da                	mov    %ebx,%edx
  8020b1:	89 f8                	mov    %edi,%eax
  8020b3:	e8 c8 fe ff ff       	call   801f80 <_pipeisclosed>
  8020b8:	85 c0                	test   %eax,%eax
  8020ba:	74 e3                	je     80209f <devpipe_read+0x34>
				return 0;
  8020bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c1:	eb d4                	jmp    802097 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8020c3:	99                   	cltd   
  8020c4:	c1 ea 1b             	shr    $0x1b,%edx
  8020c7:	01 d0                	add    %edx,%eax
  8020c9:	83 e0 1f             	and    $0x1f,%eax
  8020cc:	29 d0                	sub    %edx,%eax
  8020ce:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8020d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020d6:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8020d9:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8020dc:	83 c6 01             	add    $0x1,%esi
  8020df:	eb aa                	jmp    80208b <devpipe_read+0x20>

008020e1 <pipe>:
{
  8020e1:	f3 0f 1e fb          	endbr32 
  8020e5:	55                   	push   %ebp
  8020e6:	89 e5                	mov    %esp,%ebp
  8020e8:	56                   	push   %esi
  8020e9:	53                   	push   %ebx
  8020ea:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8020ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020f0:	50                   	push   %eax
  8020f1:	e8 32 f1 ff ff       	call   801228 <fd_alloc>
  8020f6:	89 c3                	mov    %eax,%ebx
  8020f8:	83 c4 10             	add    $0x10,%esp
  8020fb:	85 c0                	test   %eax,%eax
  8020fd:	0f 88 23 01 00 00    	js     802226 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802103:	83 ec 04             	sub    $0x4,%esp
  802106:	68 07 04 00 00       	push   $0x407
  80210b:	ff 75 f4             	pushl  -0xc(%ebp)
  80210e:	6a 00                	push   $0x0
  802110:	e8 2b eb ff ff       	call   800c40 <sys_page_alloc>
  802115:	89 c3                	mov    %eax,%ebx
  802117:	83 c4 10             	add    $0x10,%esp
  80211a:	85 c0                	test   %eax,%eax
  80211c:	0f 88 04 01 00 00    	js     802226 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  802122:	83 ec 0c             	sub    $0xc,%esp
  802125:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802128:	50                   	push   %eax
  802129:	e8 fa f0 ff ff       	call   801228 <fd_alloc>
  80212e:	89 c3                	mov    %eax,%ebx
  802130:	83 c4 10             	add    $0x10,%esp
  802133:	85 c0                	test   %eax,%eax
  802135:	0f 88 db 00 00 00    	js     802216 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80213b:	83 ec 04             	sub    $0x4,%esp
  80213e:	68 07 04 00 00       	push   $0x407
  802143:	ff 75 f0             	pushl  -0x10(%ebp)
  802146:	6a 00                	push   $0x0
  802148:	e8 f3 ea ff ff       	call   800c40 <sys_page_alloc>
  80214d:	89 c3                	mov    %eax,%ebx
  80214f:	83 c4 10             	add    $0x10,%esp
  802152:	85 c0                	test   %eax,%eax
  802154:	0f 88 bc 00 00 00    	js     802216 <pipe+0x135>
	va = fd2data(fd0);
  80215a:	83 ec 0c             	sub    $0xc,%esp
  80215d:	ff 75 f4             	pushl  -0xc(%ebp)
  802160:	e8 a8 f0 ff ff       	call   80120d <fd2data>
  802165:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802167:	83 c4 0c             	add    $0xc,%esp
  80216a:	68 07 04 00 00       	push   $0x407
  80216f:	50                   	push   %eax
  802170:	6a 00                	push   $0x0
  802172:	e8 c9 ea ff ff       	call   800c40 <sys_page_alloc>
  802177:	89 c3                	mov    %eax,%ebx
  802179:	83 c4 10             	add    $0x10,%esp
  80217c:	85 c0                	test   %eax,%eax
  80217e:	0f 88 82 00 00 00    	js     802206 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802184:	83 ec 0c             	sub    $0xc,%esp
  802187:	ff 75 f0             	pushl  -0x10(%ebp)
  80218a:	e8 7e f0 ff ff       	call   80120d <fd2data>
  80218f:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802196:	50                   	push   %eax
  802197:	6a 00                	push   $0x0
  802199:	56                   	push   %esi
  80219a:	6a 00                	push   $0x0
  80219c:	e8 e6 ea ff ff       	call   800c87 <sys_page_map>
  8021a1:	89 c3                	mov    %eax,%ebx
  8021a3:	83 c4 20             	add    $0x20,%esp
  8021a6:	85 c0                	test   %eax,%eax
  8021a8:	78 4e                	js     8021f8 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8021aa:	a1 3c 30 80 00       	mov    0x80303c,%eax
  8021af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b2:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8021b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b7:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8021be:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021c1:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8021c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8021cd:	83 ec 0c             	sub    $0xc,%esp
  8021d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8021d3:	e8 21 f0 ff ff       	call   8011f9 <fd2num>
  8021d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021db:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8021dd:	83 c4 04             	add    $0x4,%esp
  8021e0:	ff 75 f0             	pushl  -0x10(%ebp)
  8021e3:	e8 11 f0 ff ff       	call   8011f9 <fd2num>
  8021e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021eb:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8021ee:	83 c4 10             	add    $0x10,%esp
  8021f1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8021f6:	eb 2e                	jmp    802226 <pipe+0x145>
	sys_page_unmap(0, va);
  8021f8:	83 ec 08             	sub    $0x8,%esp
  8021fb:	56                   	push   %esi
  8021fc:	6a 00                	push   $0x0
  8021fe:	e8 ca ea ff ff       	call   800ccd <sys_page_unmap>
  802203:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802206:	83 ec 08             	sub    $0x8,%esp
  802209:	ff 75 f0             	pushl  -0x10(%ebp)
  80220c:	6a 00                	push   $0x0
  80220e:	e8 ba ea ff ff       	call   800ccd <sys_page_unmap>
  802213:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802216:	83 ec 08             	sub    $0x8,%esp
  802219:	ff 75 f4             	pushl  -0xc(%ebp)
  80221c:	6a 00                	push   $0x0
  80221e:	e8 aa ea ff ff       	call   800ccd <sys_page_unmap>
  802223:	83 c4 10             	add    $0x10,%esp
}
  802226:	89 d8                	mov    %ebx,%eax
  802228:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80222b:	5b                   	pop    %ebx
  80222c:	5e                   	pop    %esi
  80222d:	5d                   	pop    %ebp
  80222e:	c3                   	ret    

0080222f <pipeisclosed>:
{
  80222f:	f3 0f 1e fb          	endbr32 
  802233:	55                   	push   %ebp
  802234:	89 e5                	mov    %esp,%ebp
  802236:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802239:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80223c:	50                   	push   %eax
  80223d:	ff 75 08             	pushl  0x8(%ebp)
  802240:	e8 39 f0 ff ff       	call   80127e <fd_lookup>
  802245:	83 c4 10             	add    $0x10,%esp
  802248:	85 c0                	test   %eax,%eax
  80224a:	78 18                	js     802264 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  80224c:	83 ec 0c             	sub    $0xc,%esp
  80224f:	ff 75 f4             	pushl  -0xc(%ebp)
  802252:	e8 b6 ef ff ff       	call   80120d <fd2data>
  802257:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225c:	e8 1f fd ff ff       	call   801f80 <_pipeisclosed>
  802261:	83 c4 10             	add    $0x10,%esp
}
  802264:	c9                   	leave  
  802265:	c3                   	ret    

00802266 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802266:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  80226a:	b8 00 00 00 00       	mov    $0x0,%eax
  80226f:	c3                   	ret    

00802270 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802270:	f3 0f 1e fb          	endbr32 
  802274:	55                   	push   %ebp
  802275:	89 e5                	mov    %esp,%ebp
  802277:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80227a:	68 97 2d 80 00       	push   $0x802d97
  80227f:	ff 75 0c             	pushl  0xc(%ebp)
  802282:	e8 77 e5 ff ff       	call   8007fe <strcpy>
	return 0;
}
  802287:	b8 00 00 00 00       	mov    $0x0,%eax
  80228c:	c9                   	leave  
  80228d:	c3                   	ret    

0080228e <devcons_write>:
{
  80228e:	f3 0f 1e fb          	endbr32 
  802292:	55                   	push   %ebp
  802293:	89 e5                	mov    %esp,%ebp
  802295:	57                   	push   %edi
  802296:	56                   	push   %esi
  802297:	53                   	push   %ebx
  802298:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80229e:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8022a3:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8022a9:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022ac:	73 31                	jae    8022df <devcons_write+0x51>
		m = n - tot;
  8022ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8022b1:	29 f3                	sub    %esi,%ebx
  8022b3:	83 fb 7f             	cmp    $0x7f,%ebx
  8022b6:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8022bb:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8022be:	83 ec 04             	sub    $0x4,%esp
  8022c1:	53                   	push   %ebx
  8022c2:	89 f0                	mov    %esi,%eax
  8022c4:	03 45 0c             	add    0xc(%ebp),%eax
  8022c7:	50                   	push   %eax
  8022c8:	57                   	push   %edi
  8022c9:	e8 e6 e6 ff ff       	call   8009b4 <memmove>
		sys_cputs(buf, m);
  8022ce:	83 c4 08             	add    $0x8,%esp
  8022d1:	53                   	push   %ebx
  8022d2:	57                   	push   %edi
  8022d3:	e8 98 e8 ff ff       	call   800b70 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8022d8:	01 de                	add    %ebx,%esi
  8022da:	83 c4 10             	add    $0x10,%esp
  8022dd:	eb ca                	jmp    8022a9 <devcons_write+0x1b>
}
  8022df:	89 f0                	mov    %esi,%eax
  8022e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022e4:	5b                   	pop    %ebx
  8022e5:	5e                   	pop    %esi
  8022e6:	5f                   	pop    %edi
  8022e7:	5d                   	pop    %ebp
  8022e8:	c3                   	ret    

008022e9 <devcons_read>:
{
  8022e9:	f3 0f 1e fb          	endbr32 
  8022ed:	55                   	push   %ebp
  8022ee:	89 e5                	mov    %esp,%ebp
  8022f0:	83 ec 08             	sub    $0x8,%esp
  8022f3:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8022f8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022fc:	74 21                	je     80231f <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8022fe:	e8 8f e8 ff ff       	call   800b92 <sys_cgetc>
  802303:	85 c0                	test   %eax,%eax
  802305:	75 07                	jne    80230e <devcons_read+0x25>
		sys_yield();
  802307:	e8 11 e9 ff ff       	call   800c1d <sys_yield>
  80230c:	eb f0                	jmp    8022fe <devcons_read+0x15>
	if (c < 0)
  80230e:	78 0f                	js     80231f <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  802310:	83 f8 04             	cmp    $0x4,%eax
  802313:	74 0c                	je     802321 <devcons_read+0x38>
	*(char*)vbuf = c;
  802315:	8b 55 0c             	mov    0xc(%ebp),%edx
  802318:	88 02                	mov    %al,(%edx)
	return 1;
  80231a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80231f:	c9                   	leave  
  802320:	c3                   	ret    
		return 0;
  802321:	b8 00 00 00 00       	mov    $0x0,%eax
  802326:	eb f7                	jmp    80231f <devcons_read+0x36>

00802328 <cputchar>:
{
  802328:	f3 0f 1e fb          	endbr32 
  80232c:	55                   	push   %ebp
  80232d:	89 e5                	mov    %esp,%ebp
  80232f:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802332:	8b 45 08             	mov    0x8(%ebp),%eax
  802335:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802338:	6a 01                	push   $0x1
  80233a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80233d:	50                   	push   %eax
  80233e:	e8 2d e8 ff ff       	call   800b70 <sys_cputs>
}
  802343:	83 c4 10             	add    $0x10,%esp
  802346:	c9                   	leave  
  802347:	c3                   	ret    

00802348 <getchar>:
{
  802348:	f3 0f 1e fb          	endbr32 
  80234c:	55                   	push   %ebp
  80234d:	89 e5                	mov    %esp,%ebp
  80234f:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802352:	6a 01                	push   $0x1
  802354:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802357:	50                   	push   %eax
  802358:	6a 00                	push   $0x0
  80235a:	e8 a7 f1 ff ff       	call   801506 <read>
	if (r < 0)
  80235f:	83 c4 10             	add    $0x10,%esp
  802362:	85 c0                	test   %eax,%eax
  802364:	78 06                	js     80236c <getchar+0x24>
	if (r < 1)
  802366:	74 06                	je     80236e <getchar+0x26>
	return c;
  802368:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80236c:	c9                   	leave  
  80236d:	c3                   	ret    
		return -E_EOF;
  80236e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802373:	eb f7                	jmp    80236c <getchar+0x24>

00802375 <iscons>:
{
  802375:	f3 0f 1e fb          	endbr32 
  802379:	55                   	push   %ebp
  80237a:	89 e5                	mov    %esp,%ebp
  80237c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80237f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802382:	50                   	push   %eax
  802383:	ff 75 08             	pushl  0x8(%ebp)
  802386:	e8 f3 ee ff ff       	call   80127e <fd_lookup>
  80238b:	83 c4 10             	add    $0x10,%esp
  80238e:	85 c0                	test   %eax,%eax
  802390:	78 11                	js     8023a3 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  802392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802395:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80239b:	39 10                	cmp    %edx,(%eax)
  80239d:	0f 94 c0             	sete   %al
  8023a0:	0f b6 c0             	movzbl %al,%eax
}
  8023a3:	c9                   	leave  
  8023a4:	c3                   	ret    

008023a5 <opencons>:
{
  8023a5:	f3 0f 1e fb          	endbr32 
  8023a9:	55                   	push   %ebp
  8023aa:	89 e5                	mov    %esp,%ebp
  8023ac:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8023af:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023b2:	50                   	push   %eax
  8023b3:	e8 70 ee ff ff       	call   801228 <fd_alloc>
  8023b8:	83 c4 10             	add    $0x10,%esp
  8023bb:	85 c0                	test   %eax,%eax
  8023bd:	78 3a                	js     8023f9 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8023bf:	83 ec 04             	sub    $0x4,%esp
  8023c2:	68 07 04 00 00       	push   $0x407
  8023c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8023ca:	6a 00                	push   $0x0
  8023cc:	e8 6f e8 ff ff       	call   800c40 <sys_page_alloc>
  8023d1:	83 c4 10             	add    $0x10,%esp
  8023d4:	85 c0                	test   %eax,%eax
  8023d6:	78 21                	js     8023f9 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8023d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023db:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8023e1:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8023e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8023ed:	83 ec 0c             	sub    $0xc,%esp
  8023f0:	50                   	push   %eax
  8023f1:	e8 03 ee ff ff       	call   8011f9 <fd2num>
  8023f6:	83 c4 10             	add    $0x10,%esp
}
  8023f9:	c9                   	leave  
  8023fa:	c3                   	ret    

008023fb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8023fb:	f3 0f 1e fb          	endbr32 
  8023ff:	55                   	push   %ebp
  802400:	89 e5                	mov    %esp,%ebp
  802402:	56                   	push   %esi
  802403:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  802404:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802407:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80240d:	e8 e8 e7 ff ff       	call   800bfa <sys_getenvid>
  802412:	83 ec 0c             	sub    $0xc,%esp
  802415:	ff 75 0c             	pushl  0xc(%ebp)
  802418:	ff 75 08             	pushl  0x8(%ebp)
  80241b:	56                   	push   %esi
  80241c:	50                   	push   %eax
  80241d:	68 a4 2d 80 00       	push   $0x802da4
  802422:	e8 cd dd ff ff       	call   8001f4 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802427:	83 c4 18             	add    $0x18,%esp
  80242a:	53                   	push   %ebx
  80242b:	ff 75 10             	pushl  0x10(%ebp)
  80242e:	e8 6c dd ff ff       	call   80019f <vcprintf>
	cprintf("\n");
  802433:	c7 04 24 af 28 80 00 	movl   $0x8028af,(%esp)
  80243a:	e8 b5 dd ff ff       	call   8001f4 <cprintf>
  80243f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802442:	cc                   	int3   
  802443:	eb fd                	jmp    802442 <_panic+0x47>

00802445 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802445:	f3 0f 1e fb          	endbr32 
  802449:	55                   	push   %ebp
  80244a:	89 e5                	mov    %esp,%ebp
  80244c:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80244f:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802456:	74 0a                	je     802462 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802458:	8b 45 08             	mov    0x8(%ebp),%eax
  80245b:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802460:	c9                   	leave  
  802461:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  802462:	83 ec 04             	sub    $0x4,%esp
  802465:	6a 07                	push   $0x7
  802467:	68 00 f0 bf ee       	push   $0xeebff000
  80246c:	6a 00                	push   $0x0
  80246e:	e8 cd e7 ff ff       	call   800c40 <sys_page_alloc>
  802473:	83 c4 10             	add    $0x10,%esp
  802476:	85 c0                	test   %eax,%eax
  802478:	78 2a                	js     8024a4 <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  80247a:	83 ec 08             	sub    $0x8,%esp
  80247d:	68 b8 24 80 00       	push   $0x8024b8
  802482:	6a 00                	push   $0x0
  802484:	e8 16 e9 ff ff       	call   800d9f <sys_env_set_pgfault_upcall>
  802489:	83 c4 10             	add    $0x10,%esp
  80248c:	85 c0                	test   %eax,%eax
  80248e:	79 c8                	jns    802458 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  802490:	83 ec 04             	sub    $0x4,%esp
  802493:	68 f4 2d 80 00       	push   $0x802df4
  802498:	6a 25                	push   $0x25
  80249a:	68 2c 2e 80 00       	push   $0x802e2c
  80249f:	e8 57 ff ff ff       	call   8023fb <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  8024a4:	83 ec 04             	sub    $0x4,%esp
  8024a7:	68 c8 2d 80 00       	push   $0x802dc8
  8024ac:	6a 22                	push   $0x22
  8024ae:	68 2c 2e 80 00       	push   $0x802e2c
  8024b3:	e8 43 ff ff ff       	call   8023fb <_panic>

008024b8 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8024b8:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8024b9:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  8024be:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8024c0:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  8024c3:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  8024c7:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  8024cb:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8024ce:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  8024d0:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  8024d4:	83 c4 08             	add    $0x8,%esp
	popal
  8024d7:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  8024d8:	83 c4 04             	add    $0x4,%esp
	popfl
  8024db:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  8024dc:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  8024dd:	c3                   	ret    

008024de <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8024de:	f3 0f 1e fb          	endbr32 
  8024e2:	55                   	push   %ebp
  8024e3:	89 e5                	mov    %esp,%ebp
  8024e5:	56                   	push   %esi
  8024e6:	53                   	push   %ebx
  8024e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8024ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ed:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  8024f0:	85 c0                	test   %eax,%eax
  8024f2:	74 3d                	je     802531 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  8024f4:	83 ec 0c             	sub    $0xc,%esp
  8024f7:	50                   	push   %eax
  8024f8:	e8 0f e9 ff ff       	call   800e0c <sys_ipc_recv>
  8024fd:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  802500:	85 f6                	test   %esi,%esi
  802502:	74 0b                	je     80250f <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  802504:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80250a:	8b 52 74             	mov    0x74(%edx),%edx
  80250d:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  80250f:	85 db                	test   %ebx,%ebx
  802511:	74 0b                	je     80251e <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  802513:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802519:	8b 52 78             	mov    0x78(%edx),%edx
  80251c:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  80251e:	85 c0                	test   %eax,%eax
  802520:	78 21                	js     802543 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  802522:	a1 08 40 80 00       	mov    0x804008,%eax
  802527:	8b 40 70             	mov    0x70(%eax),%eax
}
  80252a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80252d:	5b                   	pop    %ebx
  80252e:	5e                   	pop    %esi
  80252f:	5d                   	pop    %ebp
  802530:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  802531:	83 ec 0c             	sub    $0xc,%esp
  802534:	68 00 00 c0 ee       	push   $0xeec00000
  802539:	e8 ce e8 ff ff       	call   800e0c <sys_ipc_recv>
  80253e:	83 c4 10             	add    $0x10,%esp
  802541:	eb bd                	jmp    802500 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  802543:	85 f6                	test   %esi,%esi
  802545:	74 10                	je     802557 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  802547:	85 db                	test   %ebx,%ebx
  802549:	75 df                	jne    80252a <ipc_recv+0x4c>
  80254b:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802552:	00 00 00 
  802555:	eb d3                	jmp    80252a <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  802557:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80255e:	00 00 00 
  802561:	eb e4                	jmp    802547 <ipc_recv+0x69>

00802563 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802563:	f3 0f 1e fb          	endbr32 
  802567:	55                   	push   %ebp
  802568:	89 e5                	mov    %esp,%ebp
  80256a:	57                   	push   %edi
  80256b:	56                   	push   %esi
  80256c:	53                   	push   %ebx
  80256d:	83 ec 0c             	sub    $0xc,%esp
  802570:	8b 7d 08             	mov    0x8(%ebp),%edi
  802573:	8b 75 0c             	mov    0xc(%ebp),%esi
  802576:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  802579:	85 db                	test   %ebx,%ebx
  80257b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802580:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  802583:	ff 75 14             	pushl  0x14(%ebp)
  802586:	53                   	push   %ebx
  802587:	56                   	push   %esi
  802588:	57                   	push   %edi
  802589:	e8 57 e8 ff ff       	call   800de5 <sys_ipc_try_send>
  80258e:	83 c4 10             	add    $0x10,%esp
  802591:	85 c0                	test   %eax,%eax
  802593:	79 1e                	jns    8025b3 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  802595:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802598:	75 07                	jne    8025a1 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  80259a:	e8 7e e6 ff ff       	call   800c1d <sys_yield>
  80259f:	eb e2                	jmp    802583 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  8025a1:	50                   	push   %eax
  8025a2:	68 3a 2e 80 00       	push   $0x802e3a
  8025a7:	6a 59                	push   $0x59
  8025a9:	68 55 2e 80 00       	push   $0x802e55
  8025ae:	e8 48 fe ff ff       	call   8023fb <_panic>
	}
}
  8025b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025b6:	5b                   	pop    %ebx
  8025b7:	5e                   	pop    %esi
  8025b8:	5f                   	pop    %edi
  8025b9:	5d                   	pop    %ebp
  8025ba:	c3                   	ret    

008025bb <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8025bb:	f3 0f 1e fb          	endbr32 
  8025bf:	55                   	push   %ebp
  8025c0:	89 e5                	mov    %esp,%ebp
  8025c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8025c5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8025ca:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8025cd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8025d3:	8b 52 50             	mov    0x50(%edx),%edx
  8025d6:	39 ca                	cmp    %ecx,%edx
  8025d8:	74 11                	je     8025eb <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8025da:	83 c0 01             	add    $0x1,%eax
  8025dd:	3d 00 04 00 00       	cmp    $0x400,%eax
  8025e2:	75 e6                	jne    8025ca <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8025e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e9:	eb 0b                	jmp    8025f6 <ipc_find_env+0x3b>
			return envs[i].env_id;
  8025eb:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8025ee:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8025f3:	8b 40 48             	mov    0x48(%eax),%eax
}
  8025f6:	5d                   	pop    %ebp
  8025f7:	c3                   	ret    

008025f8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8025f8:	f3 0f 1e fb          	endbr32 
  8025fc:	55                   	push   %ebp
  8025fd:	89 e5                	mov    %esp,%ebp
  8025ff:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802602:	89 c2                	mov    %eax,%edx
  802604:	c1 ea 16             	shr    $0x16,%edx
  802607:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80260e:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802613:	f6 c1 01             	test   $0x1,%cl
  802616:	74 1c                	je     802634 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802618:	c1 e8 0c             	shr    $0xc,%eax
  80261b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802622:	a8 01                	test   $0x1,%al
  802624:	74 0e                	je     802634 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802626:	c1 e8 0c             	shr    $0xc,%eax
  802629:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802630:	ef 
  802631:	0f b7 d2             	movzwl %dx,%edx
}
  802634:	89 d0                	mov    %edx,%eax
  802636:	5d                   	pop    %ebp
  802637:	c3                   	ret    
  802638:	66 90                	xchg   %ax,%ax
  80263a:	66 90                	xchg   %ax,%ax
  80263c:	66 90                	xchg   %ax,%ax
  80263e:	66 90                	xchg   %ax,%ax

00802640 <__udivdi3>:
  802640:	f3 0f 1e fb          	endbr32 
  802644:	55                   	push   %ebp
  802645:	57                   	push   %edi
  802646:	56                   	push   %esi
  802647:	53                   	push   %ebx
  802648:	83 ec 1c             	sub    $0x1c,%esp
  80264b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80264f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802653:	8b 74 24 34          	mov    0x34(%esp),%esi
  802657:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80265b:	85 d2                	test   %edx,%edx
  80265d:	75 19                	jne    802678 <__udivdi3+0x38>
  80265f:	39 f3                	cmp    %esi,%ebx
  802661:	76 4d                	jbe    8026b0 <__udivdi3+0x70>
  802663:	31 ff                	xor    %edi,%edi
  802665:	89 e8                	mov    %ebp,%eax
  802667:	89 f2                	mov    %esi,%edx
  802669:	f7 f3                	div    %ebx
  80266b:	89 fa                	mov    %edi,%edx
  80266d:	83 c4 1c             	add    $0x1c,%esp
  802670:	5b                   	pop    %ebx
  802671:	5e                   	pop    %esi
  802672:	5f                   	pop    %edi
  802673:	5d                   	pop    %ebp
  802674:	c3                   	ret    
  802675:	8d 76 00             	lea    0x0(%esi),%esi
  802678:	39 f2                	cmp    %esi,%edx
  80267a:	76 14                	jbe    802690 <__udivdi3+0x50>
  80267c:	31 ff                	xor    %edi,%edi
  80267e:	31 c0                	xor    %eax,%eax
  802680:	89 fa                	mov    %edi,%edx
  802682:	83 c4 1c             	add    $0x1c,%esp
  802685:	5b                   	pop    %ebx
  802686:	5e                   	pop    %esi
  802687:	5f                   	pop    %edi
  802688:	5d                   	pop    %ebp
  802689:	c3                   	ret    
  80268a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802690:	0f bd fa             	bsr    %edx,%edi
  802693:	83 f7 1f             	xor    $0x1f,%edi
  802696:	75 48                	jne    8026e0 <__udivdi3+0xa0>
  802698:	39 f2                	cmp    %esi,%edx
  80269a:	72 06                	jb     8026a2 <__udivdi3+0x62>
  80269c:	31 c0                	xor    %eax,%eax
  80269e:	39 eb                	cmp    %ebp,%ebx
  8026a0:	77 de                	ja     802680 <__udivdi3+0x40>
  8026a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8026a7:	eb d7                	jmp    802680 <__udivdi3+0x40>
  8026a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026b0:	89 d9                	mov    %ebx,%ecx
  8026b2:	85 db                	test   %ebx,%ebx
  8026b4:	75 0b                	jne    8026c1 <__udivdi3+0x81>
  8026b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8026bb:	31 d2                	xor    %edx,%edx
  8026bd:	f7 f3                	div    %ebx
  8026bf:	89 c1                	mov    %eax,%ecx
  8026c1:	31 d2                	xor    %edx,%edx
  8026c3:	89 f0                	mov    %esi,%eax
  8026c5:	f7 f1                	div    %ecx
  8026c7:	89 c6                	mov    %eax,%esi
  8026c9:	89 e8                	mov    %ebp,%eax
  8026cb:	89 f7                	mov    %esi,%edi
  8026cd:	f7 f1                	div    %ecx
  8026cf:	89 fa                	mov    %edi,%edx
  8026d1:	83 c4 1c             	add    $0x1c,%esp
  8026d4:	5b                   	pop    %ebx
  8026d5:	5e                   	pop    %esi
  8026d6:	5f                   	pop    %edi
  8026d7:	5d                   	pop    %ebp
  8026d8:	c3                   	ret    
  8026d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026e0:	89 f9                	mov    %edi,%ecx
  8026e2:	b8 20 00 00 00       	mov    $0x20,%eax
  8026e7:	29 f8                	sub    %edi,%eax
  8026e9:	d3 e2                	shl    %cl,%edx
  8026eb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8026ef:	89 c1                	mov    %eax,%ecx
  8026f1:	89 da                	mov    %ebx,%edx
  8026f3:	d3 ea                	shr    %cl,%edx
  8026f5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8026f9:	09 d1                	or     %edx,%ecx
  8026fb:	89 f2                	mov    %esi,%edx
  8026fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802701:	89 f9                	mov    %edi,%ecx
  802703:	d3 e3                	shl    %cl,%ebx
  802705:	89 c1                	mov    %eax,%ecx
  802707:	d3 ea                	shr    %cl,%edx
  802709:	89 f9                	mov    %edi,%ecx
  80270b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80270f:	89 eb                	mov    %ebp,%ebx
  802711:	d3 e6                	shl    %cl,%esi
  802713:	89 c1                	mov    %eax,%ecx
  802715:	d3 eb                	shr    %cl,%ebx
  802717:	09 de                	or     %ebx,%esi
  802719:	89 f0                	mov    %esi,%eax
  80271b:	f7 74 24 08          	divl   0x8(%esp)
  80271f:	89 d6                	mov    %edx,%esi
  802721:	89 c3                	mov    %eax,%ebx
  802723:	f7 64 24 0c          	mull   0xc(%esp)
  802727:	39 d6                	cmp    %edx,%esi
  802729:	72 15                	jb     802740 <__udivdi3+0x100>
  80272b:	89 f9                	mov    %edi,%ecx
  80272d:	d3 e5                	shl    %cl,%ebp
  80272f:	39 c5                	cmp    %eax,%ebp
  802731:	73 04                	jae    802737 <__udivdi3+0xf7>
  802733:	39 d6                	cmp    %edx,%esi
  802735:	74 09                	je     802740 <__udivdi3+0x100>
  802737:	89 d8                	mov    %ebx,%eax
  802739:	31 ff                	xor    %edi,%edi
  80273b:	e9 40 ff ff ff       	jmp    802680 <__udivdi3+0x40>
  802740:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802743:	31 ff                	xor    %edi,%edi
  802745:	e9 36 ff ff ff       	jmp    802680 <__udivdi3+0x40>
  80274a:	66 90                	xchg   %ax,%ax
  80274c:	66 90                	xchg   %ax,%ax
  80274e:	66 90                	xchg   %ax,%ax

00802750 <__umoddi3>:
  802750:	f3 0f 1e fb          	endbr32 
  802754:	55                   	push   %ebp
  802755:	57                   	push   %edi
  802756:	56                   	push   %esi
  802757:	53                   	push   %ebx
  802758:	83 ec 1c             	sub    $0x1c,%esp
  80275b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80275f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802763:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802767:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80276b:	85 c0                	test   %eax,%eax
  80276d:	75 19                	jne    802788 <__umoddi3+0x38>
  80276f:	39 df                	cmp    %ebx,%edi
  802771:	76 5d                	jbe    8027d0 <__umoddi3+0x80>
  802773:	89 f0                	mov    %esi,%eax
  802775:	89 da                	mov    %ebx,%edx
  802777:	f7 f7                	div    %edi
  802779:	89 d0                	mov    %edx,%eax
  80277b:	31 d2                	xor    %edx,%edx
  80277d:	83 c4 1c             	add    $0x1c,%esp
  802780:	5b                   	pop    %ebx
  802781:	5e                   	pop    %esi
  802782:	5f                   	pop    %edi
  802783:	5d                   	pop    %ebp
  802784:	c3                   	ret    
  802785:	8d 76 00             	lea    0x0(%esi),%esi
  802788:	89 f2                	mov    %esi,%edx
  80278a:	39 d8                	cmp    %ebx,%eax
  80278c:	76 12                	jbe    8027a0 <__umoddi3+0x50>
  80278e:	89 f0                	mov    %esi,%eax
  802790:	89 da                	mov    %ebx,%edx
  802792:	83 c4 1c             	add    $0x1c,%esp
  802795:	5b                   	pop    %ebx
  802796:	5e                   	pop    %esi
  802797:	5f                   	pop    %edi
  802798:	5d                   	pop    %ebp
  802799:	c3                   	ret    
  80279a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8027a0:	0f bd e8             	bsr    %eax,%ebp
  8027a3:	83 f5 1f             	xor    $0x1f,%ebp
  8027a6:	75 50                	jne    8027f8 <__umoddi3+0xa8>
  8027a8:	39 d8                	cmp    %ebx,%eax
  8027aa:	0f 82 e0 00 00 00    	jb     802890 <__umoddi3+0x140>
  8027b0:	89 d9                	mov    %ebx,%ecx
  8027b2:	39 f7                	cmp    %esi,%edi
  8027b4:	0f 86 d6 00 00 00    	jbe    802890 <__umoddi3+0x140>
  8027ba:	89 d0                	mov    %edx,%eax
  8027bc:	89 ca                	mov    %ecx,%edx
  8027be:	83 c4 1c             	add    $0x1c,%esp
  8027c1:	5b                   	pop    %ebx
  8027c2:	5e                   	pop    %esi
  8027c3:	5f                   	pop    %edi
  8027c4:	5d                   	pop    %ebp
  8027c5:	c3                   	ret    
  8027c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027cd:	8d 76 00             	lea    0x0(%esi),%esi
  8027d0:	89 fd                	mov    %edi,%ebp
  8027d2:	85 ff                	test   %edi,%edi
  8027d4:	75 0b                	jne    8027e1 <__umoddi3+0x91>
  8027d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8027db:	31 d2                	xor    %edx,%edx
  8027dd:	f7 f7                	div    %edi
  8027df:	89 c5                	mov    %eax,%ebp
  8027e1:	89 d8                	mov    %ebx,%eax
  8027e3:	31 d2                	xor    %edx,%edx
  8027e5:	f7 f5                	div    %ebp
  8027e7:	89 f0                	mov    %esi,%eax
  8027e9:	f7 f5                	div    %ebp
  8027eb:	89 d0                	mov    %edx,%eax
  8027ed:	31 d2                	xor    %edx,%edx
  8027ef:	eb 8c                	jmp    80277d <__umoddi3+0x2d>
  8027f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027f8:	89 e9                	mov    %ebp,%ecx
  8027fa:	ba 20 00 00 00       	mov    $0x20,%edx
  8027ff:	29 ea                	sub    %ebp,%edx
  802801:	d3 e0                	shl    %cl,%eax
  802803:	89 44 24 08          	mov    %eax,0x8(%esp)
  802807:	89 d1                	mov    %edx,%ecx
  802809:	89 f8                	mov    %edi,%eax
  80280b:	d3 e8                	shr    %cl,%eax
  80280d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802811:	89 54 24 04          	mov    %edx,0x4(%esp)
  802815:	8b 54 24 04          	mov    0x4(%esp),%edx
  802819:	09 c1                	or     %eax,%ecx
  80281b:	89 d8                	mov    %ebx,%eax
  80281d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802821:	89 e9                	mov    %ebp,%ecx
  802823:	d3 e7                	shl    %cl,%edi
  802825:	89 d1                	mov    %edx,%ecx
  802827:	d3 e8                	shr    %cl,%eax
  802829:	89 e9                	mov    %ebp,%ecx
  80282b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80282f:	d3 e3                	shl    %cl,%ebx
  802831:	89 c7                	mov    %eax,%edi
  802833:	89 d1                	mov    %edx,%ecx
  802835:	89 f0                	mov    %esi,%eax
  802837:	d3 e8                	shr    %cl,%eax
  802839:	89 e9                	mov    %ebp,%ecx
  80283b:	89 fa                	mov    %edi,%edx
  80283d:	d3 e6                	shl    %cl,%esi
  80283f:	09 d8                	or     %ebx,%eax
  802841:	f7 74 24 08          	divl   0x8(%esp)
  802845:	89 d1                	mov    %edx,%ecx
  802847:	89 f3                	mov    %esi,%ebx
  802849:	f7 64 24 0c          	mull   0xc(%esp)
  80284d:	89 c6                	mov    %eax,%esi
  80284f:	89 d7                	mov    %edx,%edi
  802851:	39 d1                	cmp    %edx,%ecx
  802853:	72 06                	jb     80285b <__umoddi3+0x10b>
  802855:	75 10                	jne    802867 <__umoddi3+0x117>
  802857:	39 c3                	cmp    %eax,%ebx
  802859:	73 0c                	jae    802867 <__umoddi3+0x117>
  80285b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80285f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802863:	89 d7                	mov    %edx,%edi
  802865:	89 c6                	mov    %eax,%esi
  802867:	89 ca                	mov    %ecx,%edx
  802869:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80286e:	29 f3                	sub    %esi,%ebx
  802870:	19 fa                	sbb    %edi,%edx
  802872:	89 d0                	mov    %edx,%eax
  802874:	d3 e0                	shl    %cl,%eax
  802876:	89 e9                	mov    %ebp,%ecx
  802878:	d3 eb                	shr    %cl,%ebx
  80287a:	d3 ea                	shr    %cl,%edx
  80287c:	09 d8                	or     %ebx,%eax
  80287e:	83 c4 1c             	add    $0x1c,%esp
  802881:	5b                   	pop    %ebx
  802882:	5e                   	pop    %esi
  802883:	5f                   	pop    %edi
  802884:	5d                   	pop    %ebp
  802885:	c3                   	ret    
  802886:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80288d:	8d 76 00             	lea    0x0(%esi),%esi
  802890:	29 fe                	sub    %edi,%esi
  802892:	19 c3                	sbb    %eax,%ebx
  802894:	89 f2                	mov    %esi,%edx
  802896:	89 d9                	mov    %ebx,%ecx
  802898:	e9 1d ff ff ff       	jmp    8027ba <__umoddi3+0x6a>
