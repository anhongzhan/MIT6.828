
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
  80004b:	68 40 23 80 00       	push   $0x802340
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
  8000a4:	68 51 23 80 00       	push   $0x802351
  8000a9:	6a 04                	push   $0x4
  8000ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000ae:	50                   	push   %eax
  8000af:	e8 e9 06 00 00       	call   80079d <snprintf>
	if (fork() == 0) {
  8000b4:	83 c4 20             	add    $0x20,%esp
  8000b7:	e8 75 0e 00 00       	call   800f31 <fork>
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
  8000e0:	68 50 23 80 00       	push   $0x802350
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
  800110:	a3 04 40 80 00       	mov    %eax,0x804004

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
  800143:	e8 f1 11 00 00       	call   801339 <close_all>
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
  80025a:	e8 71 1e 00 00       	call   8020d0 <__udivdi3>
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
  800298:	e8 43 1f 00 00       	call   8021e0 <__umoddi3>
  80029d:	83 c4 14             	add    $0x14,%esp
  8002a0:	0f be 80 60 23 80 00 	movsbl 0x802360(%eax),%eax
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
  800347:	3e ff 24 85 a0 24 80 	notrack jmp *0x8024a0(,%eax,4)
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
  800414:	8b 14 85 00 26 80 00 	mov    0x802600(,%eax,4),%edx
  80041b:	85 d2                	test   %edx,%edx
  80041d:	74 18                	je     800437 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80041f:	52                   	push   %edx
  800420:	68 c1 27 80 00       	push   $0x8027c1
  800425:	53                   	push   %ebx
  800426:	56                   	push   %esi
  800427:	e8 aa fe ff ff       	call   8002d6 <printfmt>
  80042c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80042f:	89 7d 14             	mov    %edi,0x14(%ebp)
  800432:	e9 66 02 00 00       	jmp    80069d <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800437:	50                   	push   %eax
  800438:	68 78 23 80 00       	push   $0x802378
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
  80045f:	b8 71 23 80 00       	mov    $0x802371,%eax
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
  800be9:	68 5f 26 80 00       	push   $0x80265f
  800bee:	6a 23                	push   $0x23
  800bf0:	68 7c 26 80 00       	push   $0x80267c
  800bf5:	e8 95 12 00 00       	call   801e8f <_panic>

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
  800c76:	68 5f 26 80 00       	push   $0x80265f
  800c7b:	6a 23                	push   $0x23
  800c7d:	68 7c 26 80 00       	push   $0x80267c
  800c82:	e8 08 12 00 00       	call   801e8f <_panic>

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
  800cbc:	68 5f 26 80 00       	push   $0x80265f
  800cc1:	6a 23                	push   $0x23
  800cc3:	68 7c 26 80 00       	push   $0x80267c
  800cc8:	e8 c2 11 00 00       	call   801e8f <_panic>

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
  800d02:	68 5f 26 80 00       	push   $0x80265f
  800d07:	6a 23                	push   $0x23
  800d09:	68 7c 26 80 00       	push   $0x80267c
  800d0e:	e8 7c 11 00 00       	call   801e8f <_panic>

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
  800d48:	68 5f 26 80 00       	push   $0x80265f
  800d4d:	6a 23                	push   $0x23
  800d4f:	68 7c 26 80 00       	push   $0x80267c
  800d54:	e8 36 11 00 00       	call   801e8f <_panic>

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
  800d8e:	68 5f 26 80 00       	push   $0x80265f
  800d93:	6a 23                	push   $0x23
  800d95:	68 7c 26 80 00       	push   $0x80267c
  800d9a:	e8 f0 10 00 00       	call   801e8f <_panic>

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
  800dd4:	68 5f 26 80 00       	push   $0x80265f
  800dd9:	6a 23                	push   $0x23
  800ddb:	68 7c 26 80 00       	push   $0x80267c
  800de0:	e8 aa 10 00 00       	call   801e8f <_panic>

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
  800e40:	68 5f 26 80 00       	push   $0x80265f
  800e45:	6a 23                	push   $0x23
  800e47:	68 7c 26 80 00       	push   $0x80267c
  800e4c:	e8 3e 10 00 00       	call   801e8f <_panic>

00800e51 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800e51:	f3 0f 1e fb          	endbr32 
  800e55:	55                   	push   %ebp
  800e56:	89 e5                	mov    %esp,%ebp
  800e58:	53                   	push   %ebx
  800e59:	83 ec 04             	sub    $0x4,%esp
  800e5c:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800e5f:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  800e61:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800e65:	74 74                	je     800edb <pgfault+0x8a>
  800e67:	89 d8                	mov    %ebx,%eax
  800e69:	c1 e8 0c             	shr    $0xc,%eax
  800e6c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800e73:	f6 c4 08             	test   $0x8,%ah
  800e76:	74 63                	je     800edb <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800e78:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  800e7e:	83 ec 0c             	sub    $0xc,%esp
  800e81:	6a 05                	push   $0x5
  800e83:	68 00 f0 7f 00       	push   $0x7ff000
  800e88:	6a 00                	push   $0x0
  800e8a:	53                   	push   %ebx
  800e8b:	6a 00                	push   $0x0
  800e8d:	e8 f5 fd ff ff       	call   800c87 <sys_page_map>
  800e92:	83 c4 20             	add    $0x20,%esp
  800e95:	85 c0                	test   %eax,%eax
  800e97:	78 59                	js     800ef2 <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  800e99:	83 ec 04             	sub    $0x4,%esp
  800e9c:	6a 07                	push   $0x7
  800e9e:	53                   	push   %ebx
  800e9f:	6a 00                	push   $0x0
  800ea1:	e8 9a fd ff ff       	call   800c40 <sys_page_alloc>
  800ea6:	83 c4 10             	add    $0x10,%esp
  800ea9:	85 c0                	test   %eax,%eax
  800eab:	78 5a                	js     800f07 <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  800ead:	83 ec 04             	sub    $0x4,%esp
  800eb0:	68 00 10 00 00       	push   $0x1000
  800eb5:	68 00 f0 7f 00       	push   $0x7ff000
  800eba:	53                   	push   %ebx
  800ebb:	e8 f4 fa ff ff       	call   8009b4 <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  800ec0:	83 c4 08             	add    $0x8,%esp
  800ec3:	68 00 f0 7f 00       	push   $0x7ff000
  800ec8:	6a 00                	push   $0x0
  800eca:	e8 fe fd ff ff       	call   800ccd <sys_page_unmap>
  800ecf:	83 c4 10             	add    $0x10,%esp
  800ed2:	85 c0                	test   %eax,%eax
  800ed4:	78 46                	js     800f1c <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  800ed6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ed9:	c9                   	leave  
  800eda:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  800edb:	83 ec 04             	sub    $0x4,%esp
  800ede:	68 8a 26 80 00       	push   $0x80268a
  800ee3:	68 d3 00 00 00       	push   $0xd3
  800ee8:	68 a6 26 80 00       	push   $0x8026a6
  800eed:	e8 9d 0f 00 00       	call   801e8f <_panic>
		panic("pgfault: %e\n", r);
  800ef2:	50                   	push   %eax
  800ef3:	68 b1 26 80 00       	push   $0x8026b1
  800ef8:	68 df 00 00 00       	push   $0xdf
  800efd:	68 a6 26 80 00       	push   $0x8026a6
  800f02:	e8 88 0f 00 00       	call   801e8f <_panic>
		panic("pgfault: %e\n", r);
  800f07:	50                   	push   %eax
  800f08:	68 b1 26 80 00       	push   $0x8026b1
  800f0d:	68 e3 00 00 00       	push   $0xe3
  800f12:	68 a6 26 80 00       	push   $0x8026a6
  800f17:	e8 73 0f 00 00       	call   801e8f <_panic>
		panic("pgfault: %e\n", r);
  800f1c:	50                   	push   %eax
  800f1d:	68 b1 26 80 00       	push   $0x8026b1
  800f22:	68 e9 00 00 00       	push   $0xe9
  800f27:	68 a6 26 80 00       	push   $0x8026a6
  800f2c:	e8 5e 0f 00 00       	call   801e8f <_panic>

00800f31 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800f31:	f3 0f 1e fb          	endbr32 
  800f35:	55                   	push   %ebp
  800f36:	89 e5                	mov    %esp,%ebp
  800f38:	57                   	push   %edi
  800f39:	56                   	push   %esi
  800f3a:	53                   	push   %ebx
  800f3b:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  800f3e:	68 51 0e 80 00       	push   $0x800e51
  800f43:	e8 91 0f 00 00       	call   801ed9 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f48:	b8 07 00 00 00       	mov    $0x7,%eax
  800f4d:	cd 30                	int    $0x30
  800f4f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  800f52:	83 c4 10             	add    $0x10,%esp
  800f55:	85 c0                	test   %eax,%eax
  800f57:	78 2d                	js     800f86 <fork+0x55>
  800f59:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800f5b:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  800f60:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f64:	0f 85 9b 00 00 00    	jne    801005 <fork+0xd4>
		thisenv = &envs[ENVX(sys_getenvid())];
  800f6a:	e8 8b fc ff ff       	call   800bfa <sys_getenvid>
  800f6f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f74:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f77:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f7c:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  800f81:	e9 71 01 00 00       	jmp    8010f7 <fork+0x1c6>
		panic("sys_exofork: %e", envid);
  800f86:	50                   	push   %eax
  800f87:	68 be 26 80 00       	push   $0x8026be
  800f8c:	68 2a 01 00 00       	push   $0x12a
  800f91:	68 a6 26 80 00       	push   $0x8026a6
  800f96:	e8 f4 0e 00 00       	call   801e8f <_panic>
		sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_SYSCALL);
  800f9b:	c1 e6 0c             	shl    $0xc,%esi
  800f9e:	83 ec 0c             	sub    $0xc,%esp
  800fa1:	68 07 0e 00 00       	push   $0xe07
  800fa6:	56                   	push   %esi
  800fa7:	57                   	push   %edi
  800fa8:	56                   	push   %esi
  800fa9:	6a 00                	push   $0x0
  800fab:	e8 d7 fc ff ff       	call   800c87 <sys_page_map>
  800fb0:	83 c4 20             	add    $0x20,%esp
  800fb3:	eb 3e                	jmp    800ff3 <fork+0xc2>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  800fb5:	c1 e6 0c             	shl    $0xc,%esi
  800fb8:	83 ec 0c             	sub    $0xc,%esp
  800fbb:	68 05 08 00 00       	push   $0x805
  800fc0:	56                   	push   %esi
  800fc1:	57                   	push   %edi
  800fc2:	56                   	push   %esi
  800fc3:	6a 00                	push   $0x0
  800fc5:	e8 bd fc ff ff       	call   800c87 <sys_page_map>
  800fca:	83 c4 20             	add    $0x20,%esp
  800fcd:	85 c0                	test   %eax,%eax
  800fcf:	0f 88 bc 00 00 00    	js     801091 <fork+0x160>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  800fd5:	83 ec 0c             	sub    $0xc,%esp
  800fd8:	68 05 08 00 00       	push   $0x805
  800fdd:	56                   	push   %esi
  800fde:	6a 00                	push   $0x0
  800fe0:	56                   	push   %esi
  800fe1:	6a 00                	push   $0x0
  800fe3:	e8 9f fc ff ff       	call   800c87 <sys_page_map>
  800fe8:	83 c4 20             	add    $0x20,%esp
  800feb:	85 c0                	test   %eax,%eax
  800fed:	0f 88 b3 00 00 00    	js     8010a6 <fork+0x175>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800ff3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800ff9:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  800fff:	0f 84 b6 00 00 00    	je     8010bb <fork+0x18a>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  801005:	89 d8                	mov    %ebx,%eax
  801007:	c1 e8 16             	shr    $0x16,%eax
  80100a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801011:	a8 01                	test   $0x1,%al
  801013:	74 de                	je     800ff3 <fork+0xc2>
  801015:	89 de                	mov    %ebx,%esi
  801017:	c1 ee 0c             	shr    $0xc,%esi
  80101a:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801021:	a8 01                	test   $0x1,%al
  801023:	74 ce                	je     800ff3 <fork+0xc2>
  801025:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80102c:	a8 04                	test   $0x4,%al
  80102e:	74 c3                	je     800ff3 <fork+0xc2>
	if ((uvpt[pn] & PTE_SHARE)){
  801030:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801037:	f6 c4 04             	test   $0x4,%ah
  80103a:	0f 85 5b ff ff ff    	jne    800f9b <fork+0x6a>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  801040:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801047:	a8 02                	test   $0x2,%al
  801049:	0f 85 66 ff ff ff    	jne    800fb5 <fork+0x84>
  80104f:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801056:	f6 c4 08             	test   $0x8,%ah
  801059:	0f 85 56 ff ff ff    	jne    800fb5 <fork+0x84>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  80105f:	c1 e6 0c             	shl    $0xc,%esi
  801062:	83 ec 0c             	sub    $0xc,%esp
  801065:	6a 05                	push   $0x5
  801067:	56                   	push   %esi
  801068:	57                   	push   %edi
  801069:	56                   	push   %esi
  80106a:	6a 00                	push   $0x0
  80106c:	e8 16 fc ff ff       	call   800c87 <sys_page_map>
  801071:	83 c4 20             	add    $0x20,%esp
  801074:	85 c0                	test   %eax,%eax
  801076:	0f 89 77 ff ff ff    	jns    800ff3 <fork+0xc2>
		panic("duppage: %e\n", r);
  80107c:	50                   	push   %eax
  80107d:	68 ce 26 80 00       	push   $0x8026ce
  801082:	68 0c 01 00 00       	push   $0x10c
  801087:	68 a6 26 80 00       	push   $0x8026a6
  80108c:	e8 fe 0d 00 00       	call   801e8f <_panic>
			panic("duppage: %e\n", r);
  801091:	50                   	push   %eax
  801092:	68 ce 26 80 00       	push   $0x8026ce
  801097:	68 05 01 00 00       	push   $0x105
  80109c:	68 a6 26 80 00       	push   $0x8026a6
  8010a1:	e8 e9 0d 00 00       	call   801e8f <_panic>
			panic("duppage: %e\n", r);
  8010a6:	50                   	push   %eax
  8010a7:	68 ce 26 80 00       	push   $0x8026ce
  8010ac:	68 09 01 00 00       	push   $0x109
  8010b1:	68 a6 26 80 00       	push   $0x8026a6
  8010b6:	e8 d4 0d 00 00       	call   801e8f <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  8010bb:	83 ec 04             	sub    $0x4,%esp
  8010be:	6a 07                	push   $0x7
  8010c0:	68 00 f0 bf ee       	push   $0xeebff000
  8010c5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010c8:	e8 73 fb ff ff       	call   800c40 <sys_page_alloc>
  8010cd:	83 c4 10             	add    $0x10,%esp
  8010d0:	85 c0                	test   %eax,%eax
  8010d2:	78 2e                	js     801102 <fork+0x1d1>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8010d4:	83 ec 08             	sub    $0x8,%esp
  8010d7:	68 4c 1f 80 00       	push   $0x801f4c
  8010dc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8010df:	57                   	push   %edi
  8010e0:	e8 ba fc ff ff       	call   800d9f <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8010e5:	83 c4 08             	add    $0x8,%esp
  8010e8:	6a 02                	push   $0x2
  8010ea:	57                   	push   %edi
  8010eb:	e8 23 fc ff ff       	call   800d13 <sys_env_set_status>
  8010f0:	83 c4 10             	add    $0x10,%esp
  8010f3:	85 c0                	test   %eax,%eax
  8010f5:	78 20                	js     801117 <fork+0x1e6>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  8010f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8010fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010fd:	5b                   	pop    %ebx
  8010fe:	5e                   	pop    %esi
  8010ff:	5f                   	pop    %edi
  801100:	5d                   	pop    %ebp
  801101:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  801102:	50                   	push   %eax
  801103:	68 db 26 80 00       	push   $0x8026db
  801108:	68 3e 01 00 00       	push   $0x13e
  80110d:	68 a6 26 80 00       	push   $0x8026a6
  801112:	e8 78 0d 00 00       	call   801e8f <_panic>
		panic("sys_env_set_status: %e", r);
  801117:	50                   	push   %eax
  801118:	68 ee 26 80 00       	push   $0x8026ee
  80111d:	68 43 01 00 00       	push   $0x143
  801122:	68 a6 26 80 00       	push   $0x8026a6
  801127:	e8 63 0d 00 00       	call   801e8f <_panic>

0080112c <sfork>:

// Challenge!
int
sfork(void)
{
  80112c:	f3 0f 1e fb          	endbr32 
  801130:	55                   	push   %ebp
  801131:	89 e5                	mov    %esp,%ebp
  801133:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801136:	68 05 27 80 00       	push   $0x802705
  80113b:	68 4c 01 00 00       	push   $0x14c
  801140:	68 a6 26 80 00       	push   $0x8026a6
  801145:	e8 45 0d 00 00       	call   801e8f <_panic>

0080114a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80114a:	f3 0f 1e fb          	endbr32 
  80114e:	55                   	push   %ebp
  80114f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	05 00 00 00 30       	add    $0x30000000,%eax
  801159:	c1 e8 0c             	shr    $0xc,%eax
}
  80115c:	5d                   	pop    %ebp
  80115d:	c3                   	ret    

0080115e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80115e:	f3 0f 1e fb          	endbr32 
  801162:	55                   	push   %ebp
  801163:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801165:	8b 45 08             	mov    0x8(%ebp),%eax
  801168:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80116d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801172:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801177:	5d                   	pop    %ebp
  801178:	c3                   	ret    

00801179 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801179:	f3 0f 1e fb          	endbr32 
  80117d:	55                   	push   %ebp
  80117e:	89 e5                	mov    %esp,%ebp
  801180:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801185:	89 c2                	mov    %eax,%edx
  801187:	c1 ea 16             	shr    $0x16,%edx
  80118a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801191:	f6 c2 01             	test   $0x1,%dl
  801194:	74 2d                	je     8011c3 <fd_alloc+0x4a>
  801196:	89 c2                	mov    %eax,%edx
  801198:	c1 ea 0c             	shr    $0xc,%edx
  80119b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011a2:	f6 c2 01             	test   $0x1,%dl
  8011a5:	74 1c                	je     8011c3 <fd_alloc+0x4a>
  8011a7:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8011ac:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011b1:	75 d2                	jne    801185 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8011bc:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011c1:	eb 0a                	jmp    8011cd <fd_alloc+0x54>
			*fd_store = fd;
  8011c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011c6:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011cd:	5d                   	pop    %ebp
  8011ce:	c3                   	ret    

008011cf <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011cf:	f3 0f 1e fb          	endbr32 
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
  8011d6:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011d9:	83 f8 1f             	cmp    $0x1f,%eax
  8011dc:	77 30                	ja     80120e <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011de:	c1 e0 0c             	shl    $0xc,%eax
  8011e1:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011e6:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8011ec:	f6 c2 01             	test   $0x1,%dl
  8011ef:	74 24                	je     801215 <fd_lookup+0x46>
  8011f1:	89 c2                	mov    %eax,%edx
  8011f3:	c1 ea 0c             	shr    $0xc,%edx
  8011f6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011fd:	f6 c2 01             	test   $0x1,%dl
  801200:	74 1a                	je     80121c <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801202:	8b 55 0c             	mov    0xc(%ebp),%edx
  801205:	89 02                	mov    %eax,(%edx)
	return 0;
  801207:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80120c:	5d                   	pop    %ebp
  80120d:	c3                   	ret    
		return -E_INVAL;
  80120e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801213:	eb f7                	jmp    80120c <fd_lookup+0x3d>
		return -E_INVAL;
  801215:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80121a:	eb f0                	jmp    80120c <fd_lookup+0x3d>
  80121c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801221:	eb e9                	jmp    80120c <fd_lookup+0x3d>

00801223 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801223:	f3 0f 1e fb          	endbr32 
  801227:	55                   	push   %ebp
  801228:	89 e5                	mov    %esp,%ebp
  80122a:	83 ec 08             	sub    $0x8,%esp
  80122d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801230:	ba 98 27 80 00       	mov    $0x802798,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801235:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80123a:	39 08                	cmp    %ecx,(%eax)
  80123c:	74 33                	je     801271 <dev_lookup+0x4e>
  80123e:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801241:	8b 02                	mov    (%edx),%eax
  801243:	85 c0                	test   %eax,%eax
  801245:	75 f3                	jne    80123a <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801247:	a1 04 40 80 00       	mov    0x804004,%eax
  80124c:	8b 40 48             	mov    0x48(%eax),%eax
  80124f:	83 ec 04             	sub    $0x4,%esp
  801252:	51                   	push   %ecx
  801253:	50                   	push   %eax
  801254:	68 1c 27 80 00       	push   $0x80271c
  801259:	e8 96 ef ff ff       	call   8001f4 <cprintf>
	*dev = 0;
  80125e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801261:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801267:	83 c4 10             	add    $0x10,%esp
  80126a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80126f:	c9                   	leave  
  801270:	c3                   	ret    
			*dev = devtab[i];
  801271:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801274:	89 01                	mov    %eax,(%ecx)
			return 0;
  801276:	b8 00 00 00 00       	mov    $0x0,%eax
  80127b:	eb f2                	jmp    80126f <dev_lookup+0x4c>

0080127d <fd_close>:
{
  80127d:	f3 0f 1e fb          	endbr32 
  801281:	55                   	push   %ebp
  801282:	89 e5                	mov    %esp,%ebp
  801284:	57                   	push   %edi
  801285:	56                   	push   %esi
  801286:	53                   	push   %ebx
  801287:	83 ec 24             	sub    $0x24,%esp
  80128a:	8b 75 08             	mov    0x8(%ebp),%esi
  80128d:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801290:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801293:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801294:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80129a:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80129d:	50                   	push   %eax
  80129e:	e8 2c ff ff ff       	call   8011cf <fd_lookup>
  8012a3:	89 c3                	mov    %eax,%ebx
  8012a5:	83 c4 10             	add    $0x10,%esp
  8012a8:	85 c0                	test   %eax,%eax
  8012aa:	78 05                	js     8012b1 <fd_close+0x34>
	    || fd != fd2)
  8012ac:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012af:	74 16                	je     8012c7 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8012b1:	89 f8                	mov    %edi,%eax
  8012b3:	84 c0                	test   %al,%al
  8012b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ba:	0f 44 d8             	cmove  %eax,%ebx
}
  8012bd:	89 d8                	mov    %ebx,%eax
  8012bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012c2:	5b                   	pop    %ebx
  8012c3:	5e                   	pop    %esi
  8012c4:	5f                   	pop    %edi
  8012c5:	5d                   	pop    %ebp
  8012c6:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012c7:	83 ec 08             	sub    $0x8,%esp
  8012ca:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012cd:	50                   	push   %eax
  8012ce:	ff 36                	pushl  (%esi)
  8012d0:	e8 4e ff ff ff       	call   801223 <dev_lookup>
  8012d5:	89 c3                	mov    %eax,%ebx
  8012d7:	83 c4 10             	add    $0x10,%esp
  8012da:	85 c0                	test   %eax,%eax
  8012dc:	78 1a                	js     8012f8 <fd_close+0x7b>
		if (dev->dev_close)
  8012de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012e1:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8012e4:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8012e9:	85 c0                	test   %eax,%eax
  8012eb:	74 0b                	je     8012f8 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8012ed:	83 ec 0c             	sub    $0xc,%esp
  8012f0:	56                   	push   %esi
  8012f1:	ff d0                	call   *%eax
  8012f3:	89 c3                	mov    %eax,%ebx
  8012f5:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8012f8:	83 ec 08             	sub    $0x8,%esp
  8012fb:	56                   	push   %esi
  8012fc:	6a 00                	push   $0x0
  8012fe:	e8 ca f9 ff ff       	call   800ccd <sys_page_unmap>
	return r;
  801303:	83 c4 10             	add    $0x10,%esp
  801306:	eb b5                	jmp    8012bd <fd_close+0x40>

00801308 <close>:

int
close(int fdnum)
{
  801308:	f3 0f 1e fb          	endbr32 
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
  80130f:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801312:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801315:	50                   	push   %eax
  801316:	ff 75 08             	pushl  0x8(%ebp)
  801319:	e8 b1 fe ff ff       	call   8011cf <fd_lookup>
  80131e:	83 c4 10             	add    $0x10,%esp
  801321:	85 c0                	test   %eax,%eax
  801323:	79 02                	jns    801327 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801325:	c9                   	leave  
  801326:	c3                   	ret    
		return fd_close(fd, 1);
  801327:	83 ec 08             	sub    $0x8,%esp
  80132a:	6a 01                	push   $0x1
  80132c:	ff 75 f4             	pushl  -0xc(%ebp)
  80132f:	e8 49 ff ff ff       	call   80127d <fd_close>
  801334:	83 c4 10             	add    $0x10,%esp
  801337:	eb ec                	jmp    801325 <close+0x1d>

00801339 <close_all>:

void
close_all(void)
{
  801339:	f3 0f 1e fb          	endbr32 
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
  801340:	53                   	push   %ebx
  801341:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801344:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801349:	83 ec 0c             	sub    $0xc,%esp
  80134c:	53                   	push   %ebx
  80134d:	e8 b6 ff ff ff       	call   801308 <close>
	for (i = 0; i < MAXFD; i++)
  801352:	83 c3 01             	add    $0x1,%ebx
  801355:	83 c4 10             	add    $0x10,%esp
  801358:	83 fb 20             	cmp    $0x20,%ebx
  80135b:	75 ec                	jne    801349 <close_all+0x10>
}
  80135d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801360:	c9                   	leave  
  801361:	c3                   	ret    

00801362 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801362:	f3 0f 1e fb          	endbr32 
  801366:	55                   	push   %ebp
  801367:	89 e5                	mov    %esp,%ebp
  801369:	57                   	push   %edi
  80136a:	56                   	push   %esi
  80136b:	53                   	push   %ebx
  80136c:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80136f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801372:	50                   	push   %eax
  801373:	ff 75 08             	pushl  0x8(%ebp)
  801376:	e8 54 fe ff ff       	call   8011cf <fd_lookup>
  80137b:	89 c3                	mov    %eax,%ebx
  80137d:	83 c4 10             	add    $0x10,%esp
  801380:	85 c0                	test   %eax,%eax
  801382:	0f 88 81 00 00 00    	js     801409 <dup+0xa7>
		return r;
	close(newfdnum);
  801388:	83 ec 0c             	sub    $0xc,%esp
  80138b:	ff 75 0c             	pushl  0xc(%ebp)
  80138e:	e8 75 ff ff ff       	call   801308 <close>

	newfd = INDEX2FD(newfdnum);
  801393:	8b 75 0c             	mov    0xc(%ebp),%esi
  801396:	c1 e6 0c             	shl    $0xc,%esi
  801399:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80139f:	83 c4 04             	add    $0x4,%esp
  8013a2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013a5:	e8 b4 fd ff ff       	call   80115e <fd2data>
  8013aa:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013ac:	89 34 24             	mov    %esi,(%esp)
  8013af:	e8 aa fd ff ff       	call   80115e <fd2data>
  8013b4:	83 c4 10             	add    $0x10,%esp
  8013b7:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013b9:	89 d8                	mov    %ebx,%eax
  8013bb:	c1 e8 16             	shr    $0x16,%eax
  8013be:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013c5:	a8 01                	test   $0x1,%al
  8013c7:	74 11                	je     8013da <dup+0x78>
  8013c9:	89 d8                	mov    %ebx,%eax
  8013cb:	c1 e8 0c             	shr    $0xc,%eax
  8013ce:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013d5:	f6 c2 01             	test   $0x1,%dl
  8013d8:	75 39                	jne    801413 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013dd:	89 d0                	mov    %edx,%eax
  8013df:	c1 e8 0c             	shr    $0xc,%eax
  8013e2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013e9:	83 ec 0c             	sub    $0xc,%esp
  8013ec:	25 07 0e 00 00       	and    $0xe07,%eax
  8013f1:	50                   	push   %eax
  8013f2:	56                   	push   %esi
  8013f3:	6a 00                	push   $0x0
  8013f5:	52                   	push   %edx
  8013f6:	6a 00                	push   $0x0
  8013f8:	e8 8a f8 ff ff       	call   800c87 <sys_page_map>
  8013fd:	89 c3                	mov    %eax,%ebx
  8013ff:	83 c4 20             	add    $0x20,%esp
  801402:	85 c0                	test   %eax,%eax
  801404:	78 31                	js     801437 <dup+0xd5>
		goto err;

	return newfdnum;
  801406:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801409:	89 d8                	mov    %ebx,%eax
  80140b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80140e:	5b                   	pop    %ebx
  80140f:	5e                   	pop    %esi
  801410:	5f                   	pop    %edi
  801411:	5d                   	pop    %ebp
  801412:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801413:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80141a:	83 ec 0c             	sub    $0xc,%esp
  80141d:	25 07 0e 00 00       	and    $0xe07,%eax
  801422:	50                   	push   %eax
  801423:	57                   	push   %edi
  801424:	6a 00                	push   $0x0
  801426:	53                   	push   %ebx
  801427:	6a 00                	push   $0x0
  801429:	e8 59 f8 ff ff       	call   800c87 <sys_page_map>
  80142e:	89 c3                	mov    %eax,%ebx
  801430:	83 c4 20             	add    $0x20,%esp
  801433:	85 c0                	test   %eax,%eax
  801435:	79 a3                	jns    8013da <dup+0x78>
	sys_page_unmap(0, newfd);
  801437:	83 ec 08             	sub    $0x8,%esp
  80143a:	56                   	push   %esi
  80143b:	6a 00                	push   $0x0
  80143d:	e8 8b f8 ff ff       	call   800ccd <sys_page_unmap>
	sys_page_unmap(0, nva);
  801442:	83 c4 08             	add    $0x8,%esp
  801445:	57                   	push   %edi
  801446:	6a 00                	push   $0x0
  801448:	e8 80 f8 ff ff       	call   800ccd <sys_page_unmap>
	return r;
  80144d:	83 c4 10             	add    $0x10,%esp
  801450:	eb b7                	jmp    801409 <dup+0xa7>

00801452 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801452:	f3 0f 1e fb          	endbr32 
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
  801459:	53                   	push   %ebx
  80145a:	83 ec 1c             	sub    $0x1c,%esp
  80145d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801460:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801463:	50                   	push   %eax
  801464:	53                   	push   %ebx
  801465:	e8 65 fd ff ff       	call   8011cf <fd_lookup>
  80146a:	83 c4 10             	add    $0x10,%esp
  80146d:	85 c0                	test   %eax,%eax
  80146f:	78 3f                	js     8014b0 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801471:	83 ec 08             	sub    $0x8,%esp
  801474:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801477:	50                   	push   %eax
  801478:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80147b:	ff 30                	pushl  (%eax)
  80147d:	e8 a1 fd ff ff       	call   801223 <dev_lookup>
  801482:	83 c4 10             	add    $0x10,%esp
  801485:	85 c0                	test   %eax,%eax
  801487:	78 27                	js     8014b0 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801489:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80148c:	8b 42 08             	mov    0x8(%edx),%eax
  80148f:	83 e0 03             	and    $0x3,%eax
  801492:	83 f8 01             	cmp    $0x1,%eax
  801495:	74 1e                	je     8014b5 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80149a:	8b 40 08             	mov    0x8(%eax),%eax
  80149d:	85 c0                	test   %eax,%eax
  80149f:	74 35                	je     8014d6 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014a1:	83 ec 04             	sub    $0x4,%esp
  8014a4:	ff 75 10             	pushl  0x10(%ebp)
  8014a7:	ff 75 0c             	pushl  0xc(%ebp)
  8014aa:	52                   	push   %edx
  8014ab:	ff d0                	call   *%eax
  8014ad:	83 c4 10             	add    $0x10,%esp
}
  8014b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014b3:	c9                   	leave  
  8014b4:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014b5:	a1 04 40 80 00       	mov    0x804004,%eax
  8014ba:	8b 40 48             	mov    0x48(%eax),%eax
  8014bd:	83 ec 04             	sub    $0x4,%esp
  8014c0:	53                   	push   %ebx
  8014c1:	50                   	push   %eax
  8014c2:	68 5d 27 80 00       	push   $0x80275d
  8014c7:	e8 28 ed ff ff       	call   8001f4 <cprintf>
		return -E_INVAL;
  8014cc:	83 c4 10             	add    $0x10,%esp
  8014cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014d4:	eb da                	jmp    8014b0 <read+0x5e>
		return -E_NOT_SUPP;
  8014d6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014db:	eb d3                	jmp    8014b0 <read+0x5e>

008014dd <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014dd:	f3 0f 1e fb          	endbr32 
  8014e1:	55                   	push   %ebp
  8014e2:	89 e5                	mov    %esp,%ebp
  8014e4:	57                   	push   %edi
  8014e5:	56                   	push   %esi
  8014e6:	53                   	push   %ebx
  8014e7:	83 ec 0c             	sub    $0xc,%esp
  8014ea:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014ed:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014f5:	eb 02                	jmp    8014f9 <readn+0x1c>
  8014f7:	01 c3                	add    %eax,%ebx
  8014f9:	39 f3                	cmp    %esi,%ebx
  8014fb:	73 21                	jae    80151e <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014fd:	83 ec 04             	sub    $0x4,%esp
  801500:	89 f0                	mov    %esi,%eax
  801502:	29 d8                	sub    %ebx,%eax
  801504:	50                   	push   %eax
  801505:	89 d8                	mov    %ebx,%eax
  801507:	03 45 0c             	add    0xc(%ebp),%eax
  80150a:	50                   	push   %eax
  80150b:	57                   	push   %edi
  80150c:	e8 41 ff ff ff       	call   801452 <read>
		if (m < 0)
  801511:	83 c4 10             	add    $0x10,%esp
  801514:	85 c0                	test   %eax,%eax
  801516:	78 04                	js     80151c <readn+0x3f>
			return m;
		if (m == 0)
  801518:	75 dd                	jne    8014f7 <readn+0x1a>
  80151a:	eb 02                	jmp    80151e <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80151c:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80151e:	89 d8                	mov    %ebx,%eax
  801520:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801523:	5b                   	pop    %ebx
  801524:	5e                   	pop    %esi
  801525:	5f                   	pop    %edi
  801526:	5d                   	pop    %ebp
  801527:	c3                   	ret    

00801528 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801528:	f3 0f 1e fb          	endbr32 
  80152c:	55                   	push   %ebp
  80152d:	89 e5                	mov    %esp,%ebp
  80152f:	53                   	push   %ebx
  801530:	83 ec 1c             	sub    $0x1c,%esp
  801533:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801536:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801539:	50                   	push   %eax
  80153a:	53                   	push   %ebx
  80153b:	e8 8f fc ff ff       	call   8011cf <fd_lookup>
  801540:	83 c4 10             	add    $0x10,%esp
  801543:	85 c0                	test   %eax,%eax
  801545:	78 3a                	js     801581 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801547:	83 ec 08             	sub    $0x8,%esp
  80154a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80154d:	50                   	push   %eax
  80154e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801551:	ff 30                	pushl  (%eax)
  801553:	e8 cb fc ff ff       	call   801223 <dev_lookup>
  801558:	83 c4 10             	add    $0x10,%esp
  80155b:	85 c0                	test   %eax,%eax
  80155d:	78 22                	js     801581 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80155f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801562:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801566:	74 1e                	je     801586 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801568:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80156b:	8b 52 0c             	mov    0xc(%edx),%edx
  80156e:	85 d2                	test   %edx,%edx
  801570:	74 35                	je     8015a7 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801572:	83 ec 04             	sub    $0x4,%esp
  801575:	ff 75 10             	pushl  0x10(%ebp)
  801578:	ff 75 0c             	pushl  0xc(%ebp)
  80157b:	50                   	push   %eax
  80157c:	ff d2                	call   *%edx
  80157e:	83 c4 10             	add    $0x10,%esp
}
  801581:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801584:	c9                   	leave  
  801585:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801586:	a1 04 40 80 00       	mov    0x804004,%eax
  80158b:	8b 40 48             	mov    0x48(%eax),%eax
  80158e:	83 ec 04             	sub    $0x4,%esp
  801591:	53                   	push   %ebx
  801592:	50                   	push   %eax
  801593:	68 79 27 80 00       	push   $0x802779
  801598:	e8 57 ec ff ff       	call   8001f4 <cprintf>
		return -E_INVAL;
  80159d:	83 c4 10             	add    $0x10,%esp
  8015a0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015a5:	eb da                	jmp    801581 <write+0x59>
		return -E_NOT_SUPP;
  8015a7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015ac:	eb d3                	jmp    801581 <write+0x59>

008015ae <seek>:

int
seek(int fdnum, off_t offset)
{
  8015ae:	f3 0f 1e fb          	endbr32 
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
  8015b5:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015bb:	50                   	push   %eax
  8015bc:	ff 75 08             	pushl  0x8(%ebp)
  8015bf:	e8 0b fc ff ff       	call   8011cf <fd_lookup>
  8015c4:	83 c4 10             	add    $0x10,%esp
  8015c7:	85 c0                	test   %eax,%eax
  8015c9:	78 0e                	js     8015d9 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8015cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d1:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d9:	c9                   	leave  
  8015da:	c3                   	ret    

008015db <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015db:	f3 0f 1e fb          	endbr32 
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
  8015e2:	53                   	push   %ebx
  8015e3:	83 ec 1c             	sub    $0x1c,%esp
  8015e6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015e9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015ec:	50                   	push   %eax
  8015ed:	53                   	push   %ebx
  8015ee:	e8 dc fb ff ff       	call   8011cf <fd_lookup>
  8015f3:	83 c4 10             	add    $0x10,%esp
  8015f6:	85 c0                	test   %eax,%eax
  8015f8:	78 37                	js     801631 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015fa:	83 ec 08             	sub    $0x8,%esp
  8015fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801600:	50                   	push   %eax
  801601:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801604:	ff 30                	pushl  (%eax)
  801606:	e8 18 fc ff ff       	call   801223 <dev_lookup>
  80160b:	83 c4 10             	add    $0x10,%esp
  80160e:	85 c0                	test   %eax,%eax
  801610:	78 1f                	js     801631 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801612:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801615:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801619:	74 1b                	je     801636 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80161b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80161e:	8b 52 18             	mov    0x18(%edx),%edx
  801621:	85 d2                	test   %edx,%edx
  801623:	74 32                	je     801657 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801625:	83 ec 08             	sub    $0x8,%esp
  801628:	ff 75 0c             	pushl  0xc(%ebp)
  80162b:	50                   	push   %eax
  80162c:	ff d2                	call   *%edx
  80162e:	83 c4 10             	add    $0x10,%esp
}
  801631:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801634:	c9                   	leave  
  801635:	c3                   	ret    
			thisenv->env_id, fdnum);
  801636:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80163b:	8b 40 48             	mov    0x48(%eax),%eax
  80163e:	83 ec 04             	sub    $0x4,%esp
  801641:	53                   	push   %ebx
  801642:	50                   	push   %eax
  801643:	68 3c 27 80 00       	push   $0x80273c
  801648:	e8 a7 eb ff ff       	call   8001f4 <cprintf>
		return -E_INVAL;
  80164d:	83 c4 10             	add    $0x10,%esp
  801650:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801655:	eb da                	jmp    801631 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801657:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80165c:	eb d3                	jmp    801631 <ftruncate+0x56>

0080165e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80165e:	f3 0f 1e fb          	endbr32 
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
  801665:	53                   	push   %ebx
  801666:	83 ec 1c             	sub    $0x1c,%esp
  801669:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80166c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80166f:	50                   	push   %eax
  801670:	ff 75 08             	pushl  0x8(%ebp)
  801673:	e8 57 fb ff ff       	call   8011cf <fd_lookup>
  801678:	83 c4 10             	add    $0x10,%esp
  80167b:	85 c0                	test   %eax,%eax
  80167d:	78 4b                	js     8016ca <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80167f:	83 ec 08             	sub    $0x8,%esp
  801682:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801685:	50                   	push   %eax
  801686:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801689:	ff 30                	pushl  (%eax)
  80168b:	e8 93 fb ff ff       	call   801223 <dev_lookup>
  801690:	83 c4 10             	add    $0x10,%esp
  801693:	85 c0                	test   %eax,%eax
  801695:	78 33                	js     8016ca <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169a:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80169e:	74 2f                	je     8016cf <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016a0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016a3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016aa:	00 00 00 
	stat->st_isdir = 0;
  8016ad:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016b4:	00 00 00 
	stat->st_dev = dev;
  8016b7:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016bd:	83 ec 08             	sub    $0x8,%esp
  8016c0:	53                   	push   %ebx
  8016c1:	ff 75 f0             	pushl  -0x10(%ebp)
  8016c4:	ff 50 14             	call   *0x14(%eax)
  8016c7:	83 c4 10             	add    $0x10,%esp
}
  8016ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016cd:	c9                   	leave  
  8016ce:	c3                   	ret    
		return -E_NOT_SUPP;
  8016cf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016d4:	eb f4                	jmp    8016ca <fstat+0x6c>

008016d6 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016d6:	f3 0f 1e fb          	endbr32 
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
  8016dd:	56                   	push   %esi
  8016de:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016df:	83 ec 08             	sub    $0x8,%esp
  8016e2:	6a 00                	push   $0x0
  8016e4:	ff 75 08             	pushl  0x8(%ebp)
  8016e7:	e8 fb 01 00 00       	call   8018e7 <open>
  8016ec:	89 c3                	mov    %eax,%ebx
  8016ee:	83 c4 10             	add    $0x10,%esp
  8016f1:	85 c0                	test   %eax,%eax
  8016f3:	78 1b                	js     801710 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8016f5:	83 ec 08             	sub    $0x8,%esp
  8016f8:	ff 75 0c             	pushl  0xc(%ebp)
  8016fb:	50                   	push   %eax
  8016fc:	e8 5d ff ff ff       	call   80165e <fstat>
  801701:	89 c6                	mov    %eax,%esi
	close(fd);
  801703:	89 1c 24             	mov    %ebx,(%esp)
  801706:	e8 fd fb ff ff       	call   801308 <close>
	return r;
  80170b:	83 c4 10             	add    $0x10,%esp
  80170e:	89 f3                	mov    %esi,%ebx
}
  801710:	89 d8                	mov    %ebx,%eax
  801712:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801715:	5b                   	pop    %ebx
  801716:	5e                   	pop    %esi
  801717:	5d                   	pop    %ebp
  801718:	c3                   	ret    

00801719 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
  80171c:	56                   	push   %esi
  80171d:	53                   	push   %ebx
  80171e:	89 c6                	mov    %eax,%esi
  801720:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801722:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801729:	74 27                	je     801752 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80172b:	6a 07                	push   $0x7
  80172d:	68 00 50 80 00       	push   $0x805000
  801732:	56                   	push   %esi
  801733:	ff 35 00 40 80 00    	pushl  0x804000
  801739:	e8 b9 08 00 00       	call   801ff7 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80173e:	83 c4 0c             	add    $0xc,%esp
  801741:	6a 00                	push   $0x0
  801743:	53                   	push   %ebx
  801744:	6a 00                	push   $0x0
  801746:	e8 27 08 00 00       	call   801f72 <ipc_recv>
}
  80174b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80174e:	5b                   	pop    %ebx
  80174f:	5e                   	pop    %esi
  801750:	5d                   	pop    %ebp
  801751:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801752:	83 ec 0c             	sub    $0xc,%esp
  801755:	6a 01                	push   $0x1
  801757:	e8 f3 08 00 00       	call   80204f <ipc_find_env>
  80175c:	a3 00 40 80 00       	mov    %eax,0x804000
  801761:	83 c4 10             	add    $0x10,%esp
  801764:	eb c5                	jmp    80172b <fsipc+0x12>

00801766 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801766:	f3 0f 1e fb          	endbr32 
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
  80176d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801770:	8b 45 08             	mov    0x8(%ebp),%eax
  801773:	8b 40 0c             	mov    0xc(%eax),%eax
  801776:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80177b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177e:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801783:	ba 00 00 00 00       	mov    $0x0,%edx
  801788:	b8 02 00 00 00       	mov    $0x2,%eax
  80178d:	e8 87 ff ff ff       	call   801719 <fsipc>
}
  801792:	c9                   	leave  
  801793:	c3                   	ret    

00801794 <devfile_flush>:
{
  801794:	f3 0f 1e fb          	endbr32 
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
  80179b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80179e:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8017a4:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ae:	b8 06 00 00 00       	mov    $0x6,%eax
  8017b3:	e8 61 ff ff ff       	call   801719 <fsipc>
}
  8017b8:	c9                   	leave  
  8017b9:	c3                   	ret    

008017ba <devfile_stat>:
{
  8017ba:	f3 0f 1e fb          	endbr32 
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
  8017c1:	53                   	push   %ebx
  8017c2:	83 ec 04             	sub    $0x4,%esp
  8017c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8017ce:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d8:	b8 05 00 00 00       	mov    $0x5,%eax
  8017dd:	e8 37 ff ff ff       	call   801719 <fsipc>
  8017e2:	85 c0                	test   %eax,%eax
  8017e4:	78 2c                	js     801812 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017e6:	83 ec 08             	sub    $0x8,%esp
  8017e9:	68 00 50 80 00       	push   $0x805000
  8017ee:	53                   	push   %ebx
  8017ef:	e8 0a f0 ff ff       	call   8007fe <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017f4:	a1 80 50 80 00       	mov    0x805080,%eax
  8017f9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017ff:	a1 84 50 80 00       	mov    0x805084,%eax
  801804:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80180a:	83 c4 10             	add    $0x10,%esp
  80180d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801812:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801815:	c9                   	leave  
  801816:	c3                   	ret    

00801817 <devfile_write>:
{
  801817:	f3 0f 1e fb          	endbr32 
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
  80181e:	83 ec 0c             	sub    $0xc,%esp
  801821:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801824:	8b 55 08             	mov    0x8(%ebp),%edx
  801827:	8b 52 0c             	mov    0xc(%edx),%edx
  80182a:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801830:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801835:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80183a:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  80183d:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801842:	50                   	push   %eax
  801843:	ff 75 0c             	pushl  0xc(%ebp)
  801846:	68 08 50 80 00       	push   $0x805008
  80184b:	e8 64 f1 ff ff       	call   8009b4 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801850:	ba 00 00 00 00       	mov    $0x0,%edx
  801855:	b8 04 00 00 00       	mov    $0x4,%eax
  80185a:	e8 ba fe ff ff       	call   801719 <fsipc>
}
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <devfile_read>:
{
  801861:	f3 0f 1e fb          	endbr32 
  801865:	55                   	push   %ebp
  801866:	89 e5                	mov    %esp,%ebp
  801868:	56                   	push   %esi
  801869:	53                   	push   %ebx
  80186a:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80186d:	8b 45 08             	mov    0x8(%ebp),%eax
  801870:	8b 40 0c             	mov    0xc(%eax),%eax
  801873:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801878:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80187e:	ba 00 00 00 00       	mov    $0x0,%edx
  801883:	b8 03 00 00 00       	mov    $0x3,%eax
  801888:	e8 8c fe ff ff       	call   801719 <fsipc>
  80188d:	89 c3                	mov    %eax,%ebx
  80188f:	85 c0                	test   %eax,%eax
  801891:	78 1f                	js     8018b2 <devfile_read+0x51>
	assert(r <= n);
  801893:	39 f0                	cmp    %esi,%eax
  801895:	77 24                	ja     8018bb <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801897:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80189c:	7f 33                	jg     8018d1 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80189e:	83 ec 04             	sub    $0x4,%esp
  8018a1:	50                   	push   %eax
  8018a2:	68 00 50 80 00       	push   $0x805000
  8018a7:	ff 75 0c             	pushl  0xc(%ebp)
  8018aa:	e8 05 f1 ff ff       	call   8009b4 <memmove>
	return r;
  8018af:	83 c4 10             	add    $0x10,%esp
}
  8018b2:	89 d8                	mov    %ebx,%eax
  8018b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018b7:	5b                   	pop    %ebx
  8018b8:	5e                   	pop    %esi
  8018b9:	5d                   	pop    %ebp
  8018ba:	c3                   	ret    
	assert(r <= n);
  8018bb:	68 a8 27 80 00       	push   $0x8027a8
  8018c0:	68 af 27 80 00       	push   $0x8027af
  8018c5:	6a 7c                	push   $0x7c
  8018c7:	68 c4 27 80 00       	push   $0x8027c4
  8018cc:	e8 be 05 00 00       	call   801e8f <_panic>
	assert(r <= PGSIZE);
  8018d1:	68 cf 27 80 00       	push   $0x8027cf
  8018d6:	68 af 27 80 00       	push   $0x8027af
  8018db:	6a 7d                	push   $0x7d
  8018dd:	68 c4 27 80 00       	push   $0x8027c4
  8018e2:	e8 a8 05 00 00       	call   801e8f <_panic>

008018e7 <open>:
{
  8018e7:	f3 0f 1e fb          	endbr32 
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
  8018ee:	56                   	push   %esi
  8018ef:	53                   	push   %ebx
  8018f0:	83 ec 1c             	sub    $0x1c,%esp
  8018f3:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8018f6:	56                   	push   %esi
  8018f7:	e8 bf ee ff ff       	call   8007bb <strlen>
  8018fc:	83 c4 10             	add    $0x10,%esp
  8018ff:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801904:	7f 6c                	jg     801972 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801906:	83 ec 0c             	sub    $0xc,%esp
  801909:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80190c:	50                   	push   %eax
  80190d:	e8 67 f8 ff ff       	call   801179 <fd_alloc>
  801912:	89 c3                	mov    %eax,%ebx
  801914:	83 c4 10             	add    $0x10,%esp
  801917:	85 c0                	test   %eax,%eax
  801919:	78 3c                	js     801957 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  80191b:	83 ec 08             	sub    $0x8,%esp
  80191e:	56                   	push   %esi
  80191f:	68 00 50 80 00       	push   $0x805000
  801924:	e8 d5 ee ff ff       	call   8007fe <strcpy>
	fsipcbuf.open.req_omode = mode;
  801929:	8b 45 0c             	mov    0xc(%ebp),%eax
  80192c:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801931:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801934:	b8 01 00 00 00       	mov    $0x1,%eax
  801939:	e8 db fd ff ff       	call   801719 <fsipc>
  80193e:	89 c3                	mov    %eax,%ebx
  801940:	83 c4 10             	add    $0x10,%esp
  801943:	85 c0                	test   %eax,%eax
  801945:	78 19                	js     801960 <open+0x79>
	return fd2num(fd);
  801947:	83 ec 0c             	sub    $0xc,%esp
  80194a:	ff 75 f4             	pushl  -0xc(%ebp)
  80194d:	e8 f8 f7 ff ff       	call   80114a <fd2num>
  801952:	89 c3                	mov    %eax,%ebx
  801954:	83 c4 10             	add    $0x10,%esp
}
  801957:	89 d8                	mov    %ebx,%eax
  801959:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80195c:	5b                   	pop    %ebx
  80195d:	5e                   	pop    %esi
  80195e:	5d                   	pop    %ebp
  80195f:	c3                   	ret    
		fd_close(fd, 0);
  801960:	83 ec 08             	sub    $0x8,%esp
  801963:	6a 00                	push   $0x0
  801965:	ff 75 f4             	pushl  -0xc(%ebp)
  801968:	e8 10 f9 ff ff       	call   80127d <fd_close>
		return r;
  80196d:	83 c4 10             	add    $0x10,%esp
  801970:	eb e5                	jmp    801957 <open+0x70>
		return -E_BAD_PATH;
  801972:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801977:	eb de                	jmp    801957 <open+0x70>

00801979 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801979:	f3 0f 1e fb          	endbr32 
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
  801980:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801983:	ba 00 00 00 00       	mov    $0x0,%edx
  801988:	b8 08 00 00 00       	mov    $0x8,%eax
  80198d:	e8 87 fd ff ff       	call   801719 <fsipc>
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801994:	f3 0f 1e fb          	endbr32 
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
  80199b:	56                   	push   %esi
  80199c:	53                   	push   %ebx
  80199d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8019a0:	83 ec 0c             	sub    $0xc,%esp
  8019a3:	ff 75 08             	pushl  0x8(%ebp)
  8019a6:	e8 b3 f7 ff ff       	call   80115e <fd2data>
  8019ab:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8019ad:	83 c4 08             	add    $0x8,%esp
  8019b0:	68 db 27 80 00       	push   $0x8027db
  8019b5:	53                   	push   %ebx
  8019b6:	e8 43 ee ff ff       	call   8007fe <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8019bb:	8b 46 04             	mov    0x4(%esi),%eax
  8019be:	2b 06                	sub    (%esi),%eax
  8019c0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8019c6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019cd:	00 00 00 
	stat->st_dev = &devpipe;
  8019d0:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8019d7:	30 80 00 
	return 0;
}
  8019da:	b8 00 00 00 00       	mov    $0x0,%eax
  8019df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019e2:	5b                   	pop    %ebx
  8019e3:	5e                   	pop    %esi
  8019e4:	5d                   	pop    %ebp
  8019e5:	c3                   	ret    

008019e6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8019e6:	f3 0f 1e fb          	endbr32 
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
  8019ed:	53                   	push   %ebx
  8019ee:	83 ec 0c             	sub    $0xc,%esp
  8019f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8019f4:	53                   	push   %ebx
  8019f5:	6a 00                	push   $0x0
  8019f7:	e8 d1 f2 ff ff       	call   800ccd <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8019fc:	89 1c 24             	mov    %ebx,(%esp)
  8019ff:	e8 5a f7 ff ff       	call   80115e <fd2data>
  801a04:	83 c4 08             	add    $0x8,%esp
  801a07:	50                   	push   %eax
  801a08:	6a 00                	push   $0x0
  801a0a:	e8 be f2 ff ff       	call   800ccd <sys_page_unmap>
}
  801a0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <_pipeisclosed>:
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
  801a17:	57                   	push   %edi
  801a18:	56                   	push   %esi
  801a19:	53                   	push   %ebx
  801a1a:	83 ec 1c             	sub    $0x1c,%esp
  801a1d:	89 c7                	mov    %eax,%edi
  801a1f:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801a21:	a1 04 40 80 00       	mov    0x804004,%eax
  801a26:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801a29:	83 ec 0c             	sub    $0xc,%esp
  801a2c:	57                   	push   %edi
  801a2d:	e8 5a 06 00 00       	call   80208c <pageref>
  801a32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a35:	89 34 24             	mov    %esi,(%esp)
  801a38:	e8 4f 06 00 00       	call   80208c <pageref>
		nn = thisenv->env_runs;
  801a3d:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801a43:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801a46:	83 c4 10             	add    $0x10,%esp
  801a49:	39 cb                	cmp    %ecx,%ebx
  801a4b:	74 1b                	je     801a68 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801a4d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a50:	75 cf                	jne    801a21 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801a52:	8b 42 58             	mov    0x58(%edx),%eax
  801a55:	6a 01                	push   $0x1
  801a57:	50                   	push   %eax
  801a58:	53                   	push   %ebx
  801a59:	68 e2 27 80 00       	push   $0x8027e2
  801a5e:	e8 91 e7 ff ff       	call   8001f4 <cprintf>
  801a63:	83 c4 10             	add    $0x10,%esp
  801a66:	eb b9                	jmp    801a21 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801a68:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a6b:	0f 94 c0             	sete   %al
  801a6e:	0f b6 c0             	movzbl %al,%eax
}
  801a71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a74:	5b                   	pop    %ebx
  801a75:	5e                   	pop    %esi
  801a76:	5f                   	pop    %edi
  801a77:	5d                   	pop    %ebp
  801a78:	c3                   	ret    

00801a79 <devpipe_write>:
{
  801a79:	f3 0f 1e fb          	endbr32 
  801a7d:	55                   	push   %ebp
  801a7e:	89 e5                	mov    %esp,%ebp
  801a80:	57                   	push   %edi
  801a81:	56                   	push   %esi
  801a82:	53                   	push   %ebx
  801a83:	83 ec 28             	sub    $0x28,%esp
  801a86:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801a89:	56                   	push   %esi
  801a8a:	e8 cf f6 ff ff       	call   80115e <fd2data>
  801a8f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801a91:	83 c4 10             	add    $0x10,%esp
  801a94:	bf 00 00 00 00       	mov    $0x0,%edi
  801a99:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801a9c:	74 4f                	je     801aed <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a9e:	8b 43 04             	mov    0x4(%ebx),%eax
  801aa1:	8b 0b                	mov    (%ebx),%ecx
  801aa3:	8d 51 20             	lea    0x20(%ecx),%edx
  801aa6:	39 d0                	cmp    %edx,%eax
  801aa8:	72 14                	jb     801abe <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801aaa:	89 da                	mov    %ebx,%edx
  801aac:	89 f0                	mov    %esi,%eax
  801aae:	e8 61 ff ff ff       	call   801a14 <_pipeisclosed>
  801ab3:	85 c0                	test   %eax,%eax
  801ab5:	75 3b                	jne    801af2 <devpipe_write+0x79>
			sys_yield();
  801ab7:	e8 61 f1 ff ff       	call   800c1d <sys_yield>
  801abc:	eb e0                	jmp    801a9e <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801abe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ac1:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ac5:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ac8:	89 c2                	mov    %eax,%edx
  801aca:	c1 fa 1f             	sar    $0x1f,%edx
  801acd:	89 d1                	mov    %edx,%ecx
  801acf:	c1 e9 1b             	shr    $0x1b,%ecx
  801ad2:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801ad5:	83 e2 1f             	and    $0x1f,%edx
  801ad8:	29 ca                	sub    %ecx,%edx
  801ada:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801ade:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801ae2:	83 c0 01             	add    $0x1,%eax
  801ae5:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801ae8:	83 c7 01             	add    $0x1,%edi
  801aeb:	eb ac                	jmp    801a99 <devpipe_write+0x20>
	return i;
  801aed:	8b 45 10             	mov    0x10(%ebp),%eax
  801af0:	eb 05                	jmp    801af7 <devpipe_write+0x7e>
				return 0;
  801af2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801af7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801afa:	5b                   	pop    %ebx
  801afb:	5e                   	pop    %esi
  801afc:	5f                   	pop    %edi
  801afd:	5d                   	pop    %ebp
  801afe:	c3                   	ret    

00801aff <devpipe_read>:
{
  801aff:	f3 0f 1e fb          	endbr32 
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
  801b06:	57                   	push   %edi
  801b07:	56                   	push   %esi
  801b08:	53                   	push   %ebx
  801b09:	83 ec 18             	sub    $0x18,%esp
  801b0c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801b0f:	57                   	push   %edi
  801b10:	e8 49 f6 ff ff       	call   80115e <fd2data>
  801b15:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b17:	83 c4 10             	add    $0x10,%esp
  801b1a:	be 00 00 00 00       	mov    $0x0,%esi
  801b1f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b22:	75 14                	jne    801b38 <devpipe_read+0x39>
	return i;
  801b24:	8b 45 10             	mov    0x10(%ebp),%eax
  801b27:	eb 02                	jmp    801b2b <devpipe_read+0x2c>
				return i;
  801b29:	89 f0                	mov    %esi,%eax
}
  801b2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b2e:	5b                   	pop    %ebx
  801b2f:	5e                   	pop    %esi
  801b30:	5f                   	pop    %edi
  801b31:	5d                   	pop    %ebp
  801b32:	c3                   	ret    
			sys_yield();
  801b33:	e8 e5 f0 ff ff       	call   800c1d <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801b38:	8b 03                	mov    (%ebx),%eax
  801b3a:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b3d:	75 18                	jne    801b57 <devpipe_read+0x58>
			if (i > 0)
  801b3f:	85 f6                	test   %esi,%esi
  801b41:	75 e6                	jne    801b29 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801b43:	89 da                	mov    %ebx,%edx
  801b45:	89 f8                	mov    %edi,%eax
  801b47:	e8 c8 fe ff ff       	call   801a14 <_pipeisclosed>
  801b4c:	85 c0                	test   %eax,%eax
  801b4e:	74 e3                	je     801b33 <devpipe_read+0x34>
				return 0;
  801b50:	b8 00 00 00 00       	mov    $0x0,%eax
  801b55:	eb d4                	jmp    801b2b <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801b57:	99                   	cltd   
  801b58:	c1 ea 1b             	shr    $0x1b,%edx
  801b5b:	01 d0                	add    %edx,%eax
  801b5d:	83 e0 1f             	and    $0x1f,%eax
  801b60:	29 d0                	sub    %edx,%eax
  801b62:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801b67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b6a:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801b6d:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801b70:	83 c6 01             	add    $0x1,%esi
  801b73:	eb aa                	jmp    801b1f <devpipe_read+0x20>

00801b75 <pipe>:
{
  801b75:	f3 0f 1e fb          	endbr32 
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
  801b7c:	56                   	push   %esi
  801b7d:	53                   	push   %ebx
  801b7e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801b81:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b84:	50                   	push   %eax
  801b85:	e8 ef f5 ff ff       	call   801179 <fd_alloc>
  801b8a:	89 c3                	mov    %eax,%ebx
  801b8c:	83 c4 10             	add    $0x10,%esp
  801b8f:	85 c0                	test   %eax,%eax
  801b91:	0f 88 23 01 00 00    	js     801cba <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b97:	83 ec 04             	sub    $0x4,%esp
  801b9a:	68 07 04 00 00       	push   $0x407
  801b9f:	ff 75 f4             	pushl  -0xc(%ebp)
  801ba2:	6a 00                	push   $0x0
  801ba4:	e8 97 f0 ff ff       	call   800c40 <sys_page_alloc>
  801ba9:	89 c3                	mov    %eax,%ebx
  801bab:	83 c4 10             	add    $0x10,%esp
  801bae:	85 c0                	test   %eax,%eax
  801bb0:	0f 88 04 01 00 00    	js     801cba <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801bb6:	83 ec 0c             	sub    $0xc,%esp
  801bb9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bbc:	50                   	push   %eax
  801bbd:	e8 b7 f5 ff ff       	call   801179 <fd_alloc>
  801bc2:	89 c3                	mov    %eax,%ebx
  801bc4:	83 c4 10             	add    $0x10,%esp
  801bc7:	85 c0                	test   %eax,%eax
  801bc9:	0f 88 db 00 00 00    	js     801caa <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bcf:	83 ec 04             	sub    $0x4,%esp
  801bd2:	68 07 04 00 00       	push   $0x407
  801bd7:	ff 75 f0             	pushl  -0x10(%ebp)
  801bda:	6a 00                	push   $0x0
  801bdc:	e8 5f f0 ff ff       	call   800c40 <sys_page_alloc>
  801be1:	89 c3                	mov    %eax,%ebx
  801be3:	83 c4 10             	add    $0x10,%esp
  801be6:	85 c0                	test   %eax,%eax
  801be8:	0f 88 bc 00 00 00    	js     801caa <pipe+0x135>
	va = fd2data(fd0);
  801bee:	83 ec 0c             	sub    $0xc,%esp
  801bf1:	ff 75 f4             	pushl  -0xc(%ebp)
  801bf4:	e8 65 f5 ff ff       	call   80115e <fd2data>
  801bf9:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bfb:	83 c4 0c             	add    $0xc,%esp
  801bfe:	68 07 04 00 00       	push   $0x407
  801c03:	50                   	push   %eax
  801c04:	6a 00                	push   $0x0
  801c06:	e8 35 f0 ff ff       	call   800c40 <sys_page_alloc>
  801c0b:	89 c3                	mov    %eax,%ebx
  801c0d:	83 c4 10             	add    $0x10,%esp
  801c10:	85 c0                	test   %eax,%eax
  801c12:	0f 88 82 00 00 00    	js     801c9a <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c18:	83 ec 0c             	sub    $0xc,%esp
  801c1b:	ff 75 f0             	pushl  -0x10(%ebp)
  801c1e:	e8 3b f5 ff ff       	call   80115e <fd2data>
  801c23:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801c2a:	50                   	push   %eax
  801c2b:	6a 00                	push   $0x0
  801c2d:	56                   	push   %esi
  801c2e:	6a 00                	push   $0x0
  801c30:	e8 52 f0 ff ff       	call   800c87 <sys_page_map>
  801c35:	89 c3                	mov    %eax,%ebx
  801c37:	83 c4 20             	add    $0x20,%esp
  801c3a:	85 c0                	test   %eax,%eax
  801c3c:	78 4e                	js     801c8c <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801c3e:	a1 20 30 80 00       	mov    0x803020,%eax
  801c43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c46:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801c48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c4b:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801c52:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c55:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c5a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801c61:	83 ec 0c             	sub    $0xc,%esp
  801c64:	ff 75 f4             	pushl  -0xc(%ebp)
  801c67:	e8 de f4 ff ff       	call   80114a <fd2num>
  801c6c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c6f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801c71:	83 c4 04             	add    $0x4,%esp
  801c74:	ff 75 f0             	pushl  -0x10(%ebp)
  801c77:	e8 ce f4 ff ff       	call   80114a <fd2num>
  801c7c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c7f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801c82:	83 c4 10             	add    $0x10,%esp
  801c85:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c8a:	eb 2e                	jmp    801cba <pipe+0x145>
	sys_page_unmap(0, va);
  801c8c:	83 ec 08             	sub    $0x8,%esp
  801c8f:	56                   	push   %esi
  801c90:	6a 00                	push   $0x0
  801c92:	e8 36 f0 ff ff       	call   800ccd <sys_page_unmap>
  801c97:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801c9a:	83 ec 08             	sub    $0x8,%esp
  801c9d:	ff 75 f0             	pushl  -0x10(%ebp)
  801ca0:	6a 00                	push   $0x0
  801ca2:	e8 26 f0 ff ff       	call   800ccd <sys_page_unmap>
  801ca7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801caa:	83 ec 08             	sub    $0x8,%esp
  801cad:	ff 75 f4             	pushl  -0xc(%ebp)
  801cb0:	6a 00                	push   $0x0
  801cb2:	e8 16 f0 ff ff       	call   800ccd <sys_page_unmap>
  801cb7:	83 c4 10             	add    $0x10,%esp
}
  801cba:	89 d8                	mov    %ebx,%eax
  801cbc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cbf:	5b                   	pop    %ebx
  801cc0:	5e                   	pop    %esi
  801cc1:	5d                   	pop    %ebp
  801cc2:	c3                   	ret    

00801cc3 <pipeisclosed>:
{
  801cc3:	f3 0f 1e fb          	endbr32 
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
  801cca:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ccd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cd0:	50                   	push   %eax
  801cd1:	ff 75 08             	pushl  0x8(%ebp)
  801cd4:	e8 f6 f4 ff ff       	call   8011cf <fd_lookup>
  801cd9:	83 c4 10             	add    $0x10,%esp
  801cdc:	85 c0                	test   %eax,%eax
  801cde:	78 18                	js     801cf8 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801ce0:	83 ec 0c             	sub    $0xc,%esp
  801ce3:	ff 75 f4             	pushl  -0xc(%ebp)
  801ce6:	e8 73 f4 ff ff       	call   80115e <fd2data>
  801ceb:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf0:	e8 1f fd ff ff       	call   801a14 <_pipeisclosed>
  801cf5:	83 c4 10             	add    $0x10,%esp
}
  801cf8:	c9                   	leave  
  801cf9:	c3                   	ret    

00801cfa <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801cfa:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801cfe:	b8 00 00 00 00       	mov    $0x0,%eax
  801d03:	c3                   	ret    

00801d04 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801d04:	f3 0f 1e fb          	endbr32 
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
  801d0b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801d0e:	68 fa 27 80 00       	push   $0x8027fa
  801d13:	ff 75 0c             	pushl  0xc(%ebp)
  801d16:	e8 e3 ea ff ff       	call   8007fe <strcpy>
	return 0;
}
  801d1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d20:	c9                   	leave  
  801d21:	c3                   	ret    

00801d22 <devcons_write>:
{
  801d22:	f3 0f 1e fb          	endbr32 
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
  801d29:	57                   	push   %edi
  801d2a:	56                   	push   %esi
  801d2b:	53                   	push   %ebx
  801d2c:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801d32:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801d37:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801d3d:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d40:	73 31                	jae    801d73 <devcons_write+0x51>
		m = n - tot;
  801d42:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d45:	29 f3                	sub    %esi,%ebx
  801d47:	83 fb 7f             	cmp    $0x7f,%ebx
  801d4a:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801d4f:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801d52:	83 ec 04             	sub    $0x4,%esp
  801d55:	53                   	push   %ebx
  801d56:	89 f0                	mov    %esi,%eax
  801d58:	03 45 0c             	add    0xc(%ebp),%eax
  801d5b:	50                   	push   %eax
  801d5c:	57                   	push   %edi
  801d5d:	e8 52 ec ff ff       	call   8009b4 <memmove>
		sys_cputs(buf, m);
  801d62:	83 c4 08             	add    $0x8,%esp
  801d65:	53                   	push   %ebx
  801d66:	57                   	push   %edi
  801d67:	e8 04 ee ff ff       	call   800b70 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801d6c:	01 de                	add    %ebx,%esi
  801d6e:	83 c4 10             	add    $0x10,%esp
  801d71:	eb ca                	jmp    801d3d <devcons_write+0x1b>
}
  801d73:	89 f0                	mov    %esi,%eax
  801d75:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d78:	5b                   	pop    %ebx
  801d79:	5e                   	pop    %esi
  801d7a:	5f                   	pop    %edi
  801d7b:	5d                   	pop    %ebp
  801d7c:	c3                   	ret    

00801d7d <devcons_read>:
{
  801d7d:	f3 0f 1e fb          	endbr32 
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
  801d84:	83 ec 08             	sub    $0x8,%esp
  801d87:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801d8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d90:	74 21                	je     801db3 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801d92:	e8 fb ed ff ff       	call   800b92 <sys_cgetc>
  801d97:	85 c0                	test   %eax,%eax
  801d99:	75 07                	jne    801da2 <devcons_read+0x25>
		sys_yield();
  801d9b:	e8 7d ee ff ff       	call   800c1d <sys_yield>
  801da0:	eb f0                	jmp    801d92 <devcons_read+0x15>
	if (c < 0)
  801da2:	78 0f                	js     801db3 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801da4:	83 f8 04             	cmp    $0x4,%eax
  801da7:	74 0c                	je     801db5 <devcons_read+0x38>
	*(char*)vbuf = c;
  801da9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dac:	88 02                	mov    %al,(%edx)
	return 1;
  801dae:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801db3:	c9                   	leave  
  801db4:	c3                   	ret    
		return 0;
  801db5:	b8 00 00 00 00       	mov    $0x0,%eax
  801dba:	eb f7                	jmp    801db3 <devcons_read+0x36>

00801dbc <cputchar>:
{
  801dbc:	f3 0f 1e fb          	endbr32 
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
  801dc3:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc9:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801dcc:	6a 01                	push   $0x1
  801dce:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801dd1:	50                   	push   %eax
  801dd2:	e8 99 ed ff ff       	call   800b70 <sys_cputs>
}
  801dd7:	83 c4 10             	add    $0x10,%esp
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    

00801ddc <getchar>:
{
  801ddc:	f3 0f 1e fb          	endbr32 
  801de0:	55                   	push   %ebp
  801de1:	89 e5                	mov    %esp,%ebp
  801de3:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801de6:	6a 01                	push   $0x1
  801de8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801deb:	50                   	push   %eax
  801dec:	6a 00                	push   $0x0
  801dee:	e8 5f f6 ff ff       	call   801452 <read>
	if (r < 0)
  801df3:	83 c4 10             	add    $0x10,%esp
  801df6:	85 c0                	test   %eax,%eax
  801df8:	78 06                	js     801e00 <getchar+0x24>
	if (r < 1)
  801dfa:	74 06                	je     801e02 <getchar+0x26>
	return c;
  801dfc:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801e00:	c9                   	leave  
  801e01:	c3                   	ret    
		return -E_EOF;
  801e02:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801e07:	eb f7                	jmp    801e00 <getchar+0x24>

00801e09 <iscons>:
{
  801e09:	f3 0f 1e fb          	endbr32 
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
  801e10:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e13:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e16:	50                   	push   %eax
  801e17:	ff 75 08             	pushl  0x8(%ebp)
  801e1a:	e8 b0 f3 ff ff       	call   8011cf <fd_lookup>
  801e1f:	83 c4 10             	add    $0x10,%esp
  801e22:	85 c0                	test   %eax,%eax
  801e24:	78 11                	js     801e37 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e29:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e2f:	39 10                	cmp    %edx,(%eax)
  801e31:	0f 94 c0             	sete   %al
  801e34:	0f b6 c0             	movzbl %al,%eax
}
  801e37:	c9                   	leave  
  801e38:	c3                   	ret    

00801e39 <opencons>:
{
  801e39:	f3 0f 1e fb          	endbr32 
  801e3d:	55                   	push   %ebp
  801e3e:	89 e5                	mov    %esp,%ebp
  801e40:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801e43:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e46:	50                   	push   %eax
  801e47:	e8 2d f3 ff ff       	call   801179 <fd_alloc>
  801e4c:	83 c4 10             	add    $0x10,%esp
  801e4f:	85 c0                	test   %eax,%eax
  801e51:	78 3a                	js     801e8d <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e53:	83 ec 04             	sub    $0x4,%esp
  801e56:	68 07 04 00 00       	push   $0x407
  801e5b:	ff 75 f4             	pushl  -0xc(%ebp)
  801e5e:	6a 00                	push   $0x0
  801e60:	e8 db ed ff ff       	call   800c40 <sys_page_alloc>
  801e65:	83 c4 10             	add    $0x10,%esp
  801e68:	85 c0                	test   %eax,%eax
  801e6a:	78 21                	js     801e8d <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6f:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e75:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801e81:	83 ec 0c             	sub    $0xc,%esp
  801e84:	50                   	push   %eax
  801e85:	e8 c0 f2 ff ff       	call   80114a <fd2num>
  801e8a:	83 c4 10             	add    $0x10,%esp
}
  801e8d:	c9                   	leave  
  801e8e:	c3                   	ret    

00801e8f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801e8f:	f3 0f 1e fb          	endbr32 
  801e93:	55                   	push   %ebp
  801e94:	89 e5                	mov    %esp,%ebp
  801e96:	56                   	push   %esi
  801e97:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801e98:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801e9b:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801ea1:	e8 54 ed ff ff       	call   800bfa <sys_getenvid>
  801ea6:	83 ec 0c             	sub    $0xc,%esp
  801ea9:	ff 75 0c             	pushl  0xc(%ebp)
  801eac:	ff 75 08             	pushl  0x8(%ebp)
  801eaf:	56                   	push   %esi
  801eb0:	50                   	push   %eax
  801eb1:	68 08 28 80 00       	push   $0x802808
  801eb6:	e8 39 e3 ff ff       	call   8001f4 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801ebb:	83 c4 18             	add    $0x18,%esp
  801ebe:	53                   	push   %ebx
  801ebf:	ff 75 10             	pushl  0x10(%ebp)
  801ec2:	e8 d8 e2 ff ff       	call   80019f <vcprintf>
	cprintf("\n");
  801ec7:	c7 04 24 4f 23 80 00 	movl   $0x80234f,(%esp)
  801ece:	e8 21 e3 ff ff       	call   8001f4 <cprintf>
  801ed3:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801ed6:	cc                   	int3   
  801ed7:	eb fd                	jmp    801ed6 <_panic+0x47>

00801ed9 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801ed9:	f3 0f 1e fb          	endbr32 
  801edd:	55                   	push   %ebp
  801ede:	89 e5                	mov    %esp,%ebp
  801ee0:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801ee3:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801eea:	74 0a                	je     801ef6 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801eec:	8b 45 08             	mov    0x8(%ebp),%eax
  801eef:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801ef4:	c9                   	leave  
  801ef5:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  801ef6:	83 ec 04             	sub    $0x4,%esp
  801ef9:	6a 07                	push   $0x7
  801efb:	68 00 f0 bf ee       	push   $0xeebff000
  801f00:	6a 00                	push   $0x0
  801f02:	e8 39 ed ff ff       	call   800c40 <sys_page_alloc>
  801f07:	83 c4 10             	add    $0x10,%esp
  801f0a:	85 c0                	test   %eax,%eax
  801f0c:	78 2a                	js     801f38 <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  801f0e:	83 ec 08             	sub    $0x8,%esp
  801f11:	68 4c 1f 80 00       	push   $0x801f4c
  801f16:	6a 00                	push   $0x0
  801f18:	e8 82 ee ff ff       	call   800d9f <sys_env_set_pgfault_upcall>
  801f1d:	83 c4 10             	add    $0x10,%esp
  801f20:	85 c0                	test   %eax,%eax
  801f22:	79 c8                	jns    801eec <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  801f24:	83 ec 04             	sub    $0x4,%esp
  801f27:	68 58 28 80 00       	push   $0x802858
  801f2c:	6a 25                	push   $0x25
  801f2e:	68 90 28 80 00       	push   $0x802890
  801f33:	e8 57 ff ff ff       	call   801e8f <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  801f38:	83 ec 04             	sub    $0x4,%esp
  801f3b:	68 2c 28 80 00       	push   $0x80282c
  801f40:	6a 22                	push   $0x22
  801f42:	68 90 28 80 00       	push   $0x802890
  801f47:	e8 43 ff ff ff       	call   801e8f <_panic>

00801f4c <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801f4c:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801f4d:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  801f52:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801f54:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  801f57:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  801f5b:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  801f5f:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  801f62:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  801f64:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  801f68:	83 c4 08             	add    $0x8,%esp
	popal
  801f6b:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  801f6c:	83 c4 04             	add    $0x4,%esp
	popfl
  801f6f:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  801f70:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  801f71:	c3                   	ret    

00801f72 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f72:	f3 0f 1e fb          	endbr32 
  801f76:	55                   	push   %ebp
  801f77:	89 e5                	mov    %esp,%ebp
  801f79:	56                   	push   %esi
  801f7a:	53                   	push   %ebx
  801f7b:	8b 75 08             	mov    0x8(%ebp),%esi
  801f7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f81:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  801f84:	85 c0                	test   %eax,%eax
  801f86:	74 3d                	je     801fc5 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  801f88:	83 ec 0c             	sub    $0xc,%esp
  801f8b:	50                   	push   %eax
  801f8c:	e8 7b ee ff ff       	call   800e0c <sys_ipc_recv>
  801f91:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  801f94:	85 f6                	test   %esi,%esi
  801f96:	74 0b                	je     801fa3 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801f98:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801f9e:	8b 52 74             	mov    0x74(%edx),%edx
  801fa1:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801fa3:	85 db                	test   %ebx,%ebx
  801fa5:	74 0b                	je     801fb2 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  801fa7:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801fad:	8b 52 78             	mov    0x78(%edx),%edx
  801fb0:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  801fb2:	85 c0                	test   %eax,%eax
  801fb4:	78 21                	js     801fd7 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  801fb6:	a1 04 40 80 00       	mov    0x804004,%eax
  801fbb:	8b 40 70             	mov    0x70(%eax),%eax
}
  801fbe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fc1:	5b                   	pop    %ebx
  801fc2:	5e                   	pop    %esi
  801fc3:	5d                   	pop    %ebp
  801fc4:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  801fc5:	83 ec 0c             	sub    $0xc,%esp
  801fc8:	68 00 00 c0 ee       	push   $0xeec00000
  801fcd:	e8 3a ee ff ff       	call   800e0c <sys_ipc_recv>
  801fd2:	83 c4 10             	add    $0x10,%esp
  801fd5:	eb bd                	jmp    801f94 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  801fd7:	85 f6                	test   %esi,%esi
  801fd9:	74 10                	je     801feb <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  801fdb:	85 db                	test   %ebx,%ebx
  801fdd:	75 df                	jne    801fbe <ipc_recv+0x4c>
  801fdf:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801fe6:	00 00 00 
  801fe9:	eb d3                	jmp    801fbe <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  801feb:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801ff2:	00 00 00 
  801ff5:	eb e4                	jmp    801fdb <ipc_recv+0x69>

00801ff7 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801ff7:	f3 0f 1e fb          	endbr32 
  801ffb:	55                   	push   %ebp
  801ffc:	89 e5                	mov    %esp,%ebp
  801ffe:	57                   	push   %edi
  801fff:	56                   	push   %esi
  802000:	53                   	push   %ebx
  802001:	83 ec 0c             	sub    $0xc,%esp
  802004:	8b 7d 08             	mov    0x8(%ebp),%edi
  802007:	8b 75 0c             	mov    0xc(%ebp),%esi
  80200a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  80200d:	85 db                	test   %ebx,%ebx
  80200f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802014:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  802017:	ff 75 14             	pushl  0x14(%ebp)
  80201a:	53                   	push   %ebx
  80201b:	56                   	push   %esi
  80201c:	57                   	push   %edi
  80201d:	e8 c3 ed ff ff       	call   800de5 <sys_ipc_try_send>
  802022:	83 c4 10             	add    $0x10,%esp
  802025:	85 c0                	test   %eax,%eax
  802027:	79 1e                	jns    802047 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  802029:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80202c:	75 07                	jne    802035 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  80202e:	e8 ea eb ff ff       	call   800c1d <sys_yield>
  802033:	eb e2                	jmp    802017 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  802035:	50                   	push   %eax
  802036:	68 9e 28 80 00       	push   $0x80289e
  80203b:	6a 59                	push   $0x59
  80203d:	68 b9 28 80 00       	push   $0x8028b9
  802042:	e8 48 fe ff ff       	call   801e8f <_panic>
	}
}
  802047:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80204a:	5b                   	pop    %ebx
  80204b:	5e                   	pop    %esi
  80204c:	5f                   	pop    %edi
  80204d:	5d                   	pop    %ebp
  80204e:	c3                   	ret    

0080204f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80204f:	f3 0f 1e fb          	endbr32 
  802053:	55                   	push   %ebp
  802054:	89 e5                	mov    %esp,%ebp
  802056:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802059:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80205e:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802061:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802067:	8b 52 50             	mov    0x50(%edx),%edx
  80206a:	39 ca                	cmp    %ecx,%edx
  80206c:	74 11                	je     80207f <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80206e:	83 c0 01             	add    $0x1,%eax
  802071:	3d 00 04 00 00       	cmp    $0x400,%eax
  802076:	75 e6                	jne    80205e <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802078:	b8 00 00 00 00       	mov    $0x0,%eax
  80207d:	eb 0b                	jmp    80208a <ipc_find_env+0x3b>
			return envs[i].env_id;
  80207f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802082:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802087:	8b 40 48             	mov    0x48(%eax),%eax
}
  80208a:	5d                   	pop    %ebp
  80208b:	c3                   	ret    

0080208c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80208c:	f3 0f 1e fb          	endbr32 
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
  802093:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802096:	89 c2                	mov    %eax,%edx
  802098:	c1 ea 16             	shr    $0x16,%edx
  80209b:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8020a2:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8020a7:	f6 c1 01             	test   $0x1,%cl
  8020aa:	74 1c                	je     8020c8 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8020ac:	c1 e8 0c             	shr    $0xc,%eax
  8020af:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8020b6:	a8 01                	test   $0x1,%al
  8020b8:	74 0e                	je     8020c8 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020ba:	c1 e8 0c             	shr    $0xc,%eax
  8020bd:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8020c4:	ef 
  8020c5:	0f b7 d2             	movzwl %dx,%edx
}
  8020c8:	89 d0                	mov    %edx,%eax
  8020ca:	5d                   	pop    %ebp
  8020cb:	c3                   	ret    
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
