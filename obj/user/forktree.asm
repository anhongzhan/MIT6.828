
obj/user/forktree:     file format elf32-i386


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
  800041:	e8 ac 0b 00 00       	call   800bf2 <sys_getenvid>
  800046:	83 ec 04             	sub    $0x4,%esp
  800049:	53                   	push   %ebx
  80004a:	50                   	push   %eax
  80004b:	68 20 14 80 00       	push   $0x801420
  800050:	e8 97 01 00 00       	call   8001ec <cprintf>

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
  800086:	e8 28 07 00 00       	call   8007b3 <strlen>
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
  8000a4:	68 31 14 80 00       	push   $0x801431
  8000a9:	6a 04                	push   $0x4
  8000ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000ae:	50                   	push   %eax
  8000af:	e8 e1 06 00 00       	call   800795 <snprintf>
	if (fork() == 0) {
  8000b4:	83 c4 20             	add    $0x20,%esp
  8000b7:	e8 27 0e 00 00       	call   800ee3 <fork>
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
  8000e0:	68 30 14 80 00       	push   $0x801430
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
  8000fe:	e8 ef 0a 00 00       	call   800bf2 <sys_getenvid>
  800103:	25 ff 03 00 00       	and    $0x3ff,%eax
  800108:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80010b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800110:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800115:	85 db                	test   %ebx,%ebx
  800117:	7e 07                	jle    800120 <libmain+0x31>
		binaryname = argv[0];
  800119:	8b 06                	mov    (%esi),%eax
  80011b:	a3 00 20 80 00       	mov    %eax,0x802000

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
  800140:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  800143:	6a 00                	push   $0x0
  800145:	e8 63 0a 00 00       	call   800bad <sys_env_destroy>
}
  80014a:	83 c4 10             	add    $0x10,%esp
  80014d:	c9                   	leave  
  80014e:	c3                   	ret    

0080014f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80014f:	f3 0f 1e fb          	endbr32 
  800153:	55                   	push   %ebp
  800154:	89 e5                	mov    %esp,%ebp
  800156:	53                   	push   %ebx
  800157:	83 ec 04             	sub    $0x4,%esp
  80015a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80015d:	8b 13                	mov    (%ebx),%edx
  80015f:	8d 42 01             	lea    0x1(%edx),%eax
  800162:	89 03                	mov    %eax,(%ebx)
  800164:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800167:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80016b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800170:	74 09                	je     80017b <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800172:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800176:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800179:	c9                   	leave  
  80017a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80017b:	83 ec 08             	sub    $0x8,%esp
  80017e:	68 ff 00 00 00       	push   $0xff
  800183:	8d 43 08             	lea    0x8(%ebx),%eax
  800186:	50                   	push   %eax
  800187:	e8 dc 09 00 00       	call   800b68 <sys_cputs>
		b->idx = 0;
  80018c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800192:	83 c4 10             	add    $0x10,%esp
  800195:	eb db                	jmp    800172 <putch+0x23>

00800197 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800197:	f3 0f 1e fb          	endbr32 
  80019b:	55                   	push   %ebp
  80019c:	89 e5                	mov    %esp,%ebp
  80019e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001a4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001ab:	00 00 00 
	b.cnt = 0;
  8001ae:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001b5:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001b8:	ff 75 0c             	pushl  0xc(%ebp)
  8001bb:	ff 75 08             	pushl  0x8(%ebp)
  8001be:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001c4:	50                   	push   %eax
  8001c5:	68 4f 01 80 00       	push   $0x80014f
  8001ca:	e8 20 01 00 00       	call   8002ef <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001cf:	83 c4 08             	add    $0x8,%esp
  8001d2:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001d8:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001de:	50                   	push   %eax
  8001df:	e8 84 09 00 00       	call   800b68 <sys_cputs>

	return b.cnt;
}
  8001e4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001ea:	c9                   	leave  
  8001eb:	c3                   	ret    

008001ec <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001ec:	f3 0f 1e fb          	endbr32 
  8001f0:	55                   	push   %ebp
  8001f1:	89 e5                	mov    %esp,%ebp
  8001f3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001f6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001f9:	50                   	push   %eax
  8001fa:	ff 75 08             	pushl  0x8(%ebp)
  8001fd:	e8 95 ff ff ff       	call   800197 <vcprintf>
	va_end(ap);

	return cnt;
}
  800202:	c9                   	leave  
  800203:	c3                   	ret    

00800204 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800204:	55                   	push   %ebp
  800205:	89 e5                	mov    %esp,%ebp
  800207:	57                   	push   %edi
  800208:	56                   	push   %esi
  800209:	53                   	push   %ebx
  80020a:	83 ec 1c             	sub    $0x1c,%esp
  80020d:	89 c7                	mov    %eax,%edi
  80020f:	89 d6                	mov    %edx,%esi
  800211:	8b 45 08             	mov    0x8(%ebp),%eax
  800214:	8b 55 0c             	mov    0xc(%ebp),%edx
  800217:	89 d1                	mov    %edx,%ecx
  800219:	89 c2                	mov    %eax,%edx
  80021b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80021e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800221:	8b 45 10             	mov    0x10(%ebp),%eax
  800224:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800227:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80022a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800231:	39 c2                	cmp    %eax,%edx
  800233:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800236:	72 3e                	jb     800276 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800238:	83 ec 0c             	sub    $0xc,%esp
  80023b:	ff 75 18             	pushl  0x18(%ebp)
  80023e:	83 eb 01             	sub    $0x1,%ebx
  800241:	53                   	push   %ebx
  800242:	50                   	push   %eax
  800243:	83 ec 08             	sub    $0x8,%esp
  800246:	ff 75 e4             	pushl  -0x1c(%ebp)
  800249:	ff 75 e0             	pushl  -0x20(%ebp)
  80024c:	ff 75 dc             	pushl  -0x24(%ebp)
  80024f:	ff 75 d8             	pushl  -0x28(%ebp)
  800252:	e8 69 0f 00 00       	call   8011c0 <__udivdi3>
  800257:	83 c4 18             	add    $0x18,%esp
  80025a:	52                   	push   %edx
  80025b:	50                   	push   %eax
  80025c:	89 f2                	mov    %esi,%edx
  80025e:	89 f8                	mov    %edi,%eax
  800260:	e8 9f ff ff ff       	call   800204 <printnum>
  800265:	83 c4 20             	add    $0x20,%esp
  800268:	eb 13                	jmp    80027d <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80026a:	83 ec 08             	sub    $0x8,%esp
  80026d:	56                   	push   %esi
  80026e:	ff 75 18             	pushl  0x18(%ebp)
  800271:	ff d7                	call   *%edi
  800273:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800276:	83 eb 01             	sub    $0x1,%ebx
  800279:	85 db                	test   %ebx,%ebx
  80027b:	7f ed                	jg     80026a <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80027d:	83 ec 08             	sub    $0x8,%esp
  800280:	56                   	push   %esi
  800281:	83 ec 04             	sub    $0x4,%esp
  800284:	ff 75 e4             	pushl  -0x1c(%ebp)
  800287:	ff 75 e0             	pushl  -0x20(%ebp)
  80028a:	ff 75 dc             	pushl  -0x24(%ebp)
  80028d:	ff 75 d8             	pushl  -0x28(%ebp)
  800290:	e8 3b 10 00 00       	call   8012d0 <__umoddi3>
  800295:	83 c4 14             	add    $0x14,%esp
  800298:	0f be 80 40 14 80 00 	movsbl 0x801440(%eax),%eax
  80029f:	50                   	push   %eax
  8002a0:	ff d7                	call   *%edi
}
  8002a2:	83 c4 10             	add    $0x10,%esp
  8002a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002a8:	5b                   	pop    %ebx
  8002a9:	5e                   	pop    %esi
  8002aa:	5f                   	pop    %edi
  8002ab:	5d                   	pop    %ebp
  8002ac:	c3                   	ret    

008002ad <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002ad:	f3 0f 1e fb          	endbr32 
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002b7:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002bb:	8b 10                	mov    (%eax),%edx
  8002bd:	3b 50 04             	cmp    0x4(%eax),%edx
  8002c0:	73 0a                	jae    8002cc <sprintputch+0x1f>
		*b->buf++ = ch;
  8002c2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002c5:	89 08                	mov    %ecx,(%eax)
  8002c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ca:	88 02                	mov    %al,(%edx)
}
  8002cc:	5d                   	pop    %ebp
  8002cd:	c3                   	ret    

008002ce <printfmt>:
{
  8002ce:	f3 0f 1e fb          	endbr32 
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002d8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002db:	50                   	push   %eax
  8002dc:	ff 75 10             	pushl  0x10(%ebp)
  8002df:	ff 75 0c             	pushl  0xc(%ebp)
  8002e2:	ff 75 08             	pushl  0x8(%ebp)
  8002e5:	e8 05 00 00 00       	call   8002ef <vprintfmt>
}
  8002ea:	83 c4 10             	add    $0x10,%esp
  8002ed:	c9                   	leave  
  8002ee:	c3                   	ret    

008002ef <vprintfmt>:
{
  8002ef:	f3 0f 1e fb          	endbr32 
  8002f3:	55                   	push   %ebp
  8002f4:	89 e5                	mov    %esp,%ebp
  8002f6:	57                   	push   %edi
  8002f7:	56                   	push   %esi
  8002f8:	53                   	push   %ebx
  8002f9:	83 ec 3c             	sub    $0x3c,%esp
  8002fc:	8b 75 08             	mov    0x8(%ebp),%esi
  8002ff:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800302:	8b 7d 10             	mov    0x10(%ebp),%edi
  800305:	e9 8e 03 00 00       	jmp    800698 <vprintfmt+0x3a9>
		padc = ' ';
  80030a:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80030e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800315:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80031c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800323:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800328:	8d 47 01             	lea    0x1(%edi),%eax
  80032b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80032e:	0f b6 17             	movzbl (%edi),%edx
  800331:	8d 42 dd             	lea    -0x23(%edx),%eax
  800334:	3c 55                	cmp    $0x55,%al
  800336:	0f 87 df 03 00 00    	ja     80071b <vprintfmt+0x42c>
  80033c:	0f b6 c0             	movzbl %al,%eax
  80033f:	3e ff 24 85 00 15 80 	notrack jmp *0x801500(,%eax,4)
  800346:	00 
  800347:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80034a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80034e:	eb d8                	jmp    800328 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800350:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800353:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800357:	eb cf                	jmp    800328 <vprintfmt+0x39>
  800359:	0f b6 d2             	movzbl %dl,%edx
  80035c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80035f:	b8 00 00 00 00       	mov    $0x0,%eax
  800364:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800367:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80036a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80036e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800371:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800374:	83 f9 09             	cmp    $0x9,%ecx
  800377:	77 55                	ja     8003ce <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800379:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80037c:	eb e9                	jmp    800367 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80037e:	8b 45 14             	mov    0x14(%ebp),%eax
  800381:	8b 00                	mov    (%eax),%eax
  800383:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800386:	8b 45 14             	mov    0x14(%ebp),%eax
  800389:	8d 40 04             	lea    0x4(%eax),%eax
  80038c:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80038f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800392:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800396:	79 90                	jns    800328 <vprintfmt+0x39>
				width = precision, precision = -1;
  800398:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80039b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80039e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003a5:	eb 81                	jmp    800328 <vprintfmt+0x39>
  8003a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003aa:	85 c0                	test   %eax,%eax
  8003ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b1:	0f 49 d0             	cmovns %eax,%edx
  8003b4:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003ba:	e9 69 ff ff ff       	jmp    800328 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003c2:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003c9:	e9 5a ff ff ff       	jmp    800328 <vprintfmt+0x39>
  8003ce:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003d4:	eb bc                	jmp    800392 <vprintfmt+0xa3>
			lflag++;
  8003d6:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003dc:	e9 47 ff ff ff       	jmp    800328 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8003e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e4:	8d 78 04             	lea    0x4(%eax),%edi
  8003e7:	83 ec 08             	sub    $0x8,%esp
  8003ea:	53                   	push   %ebx
  8003eb:	ff 30                	pushl  (%eax)
  8003ed:	ff d6                	call   *%esi
			break;
  8003ef:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003f2:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003f5:	e9 9b 02 00 00       	jmp    800695 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8003fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fd:	8d 78 04             	lea    0x4(%eax),%edi
  800400:	8b 00                	mov    (%eax),%eax
  800402:	99                   	cltd   
  800403:	31 d0                	xor    %edx,%eax
  800405:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800407:	83 f8 08             	cmp    $0x8,%eax
  80040a:	7f 23                	jg     80042f <vprintfmt+0x140>
  80040c:	8b 14 85 60 16 80 00 	mov    0x801660(,%eax,4),%edx
  800413:	85 d2                	test   %edx,%edx
  800415:	74 18                	je     80042f <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800417:	52                   	push   %edx
  800418:	68 61 14 80 00       	push   $0x801461
  80041d:	53                   	push   %ebx
  80041e:	56                   	push   %esi
  80041f:	e8 aa fe ff ff       	call   8002ce <printfmt>
  800424:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800427:	89 7d 14             	mov    %edi,0x14(%ebp)
  80042a:	e9 66 02 00 00       	jmp    800695 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80042f:	50                   	push   %eax
  800430:	68 58 14 80 00       	push   $0x801458
  800435:	53                   	push   %ebx
  800436:	56                   	push   %esi
  800437:	e8 92 fe ff ff       	call   8002ce <printfmt>
  80043c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80043f:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800442:	e9 4e 02 00 00       	jmp    800695 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800447:	8b 45 14             	mov    0x14(%ebp),%eax
  80044a:	83 c0 04             	add    $0x4,%eax
  80044d:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800450:	8b 45 14             	mov    0x14(%ebp),%eax
  800453:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800455:	85 d2                	test   %edx,%edx
  800457:	b8 51 14 80 00       	mov    $0x801451,%eax
  80045c:	0f 45 c2             	cmovne %edx,%eax
  80045f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800462:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800466:	7e 06                	jle    80046e <vprintfmt+0x17f>
  800468:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80046c:	75 0d                	jne    80047b <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80046e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800471:	89 c7                	mov    %eax,%edi
  800473:	03 45 e0             	add    -0x20(%ebp),%eax
  800476:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800479:	eb 55                	jmp    8004d0 <vprintfmt+0x1e1>
  80047b:	83 ec 08             	sub    $0x8,%esp
  80047e:	ff 75 d8             	pushl  -0x28(%ebp)
  800481:	ff 75 cc             	pushl  -0x34(%ebp)
  800484:	e8 46 03 00 00       	call   8007cf <strnlen>
  800489:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80048c:	29 c2                	sub    %eax,%edx
  80048e:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800491:	83 c4 10             	add    $0x10,%esp
  800494:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800496:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80049a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80049d:	85 ff                	test   %edi,%edi
  80049f:	7e 11                	jle    8004b2 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8004a1:	83 ec 08             	sub    $0x8,%esp
  8004a4:	53                   	push   %ebx
  8004a5:	ff 75 e0             	pushl  -0x20(%ebp)
  8004a8:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004aa:	83 ef 01             	sub    $0x1,%edi
  8004ad:	83 c4 10             	add    $0x10,%esp
  8004b0:	eb eb                	jmp    80049d <vprintfmt+0x1ae>
  8004b2:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004b5:	85 d2                	test   %edx,%edx
  8004b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8004bc:	0f 49 c2             	cmovns %edx,%eax
  8004bf:	29 c2                	sub    %eax,%edx
  8004c1:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004c4:	eb a8                	jmp    80046e <vprintfmt+0x17f>
					putch(ch, putdat);
  8004c6:	83 ec 08             	sub    $0x8,%esp
  8004c9:	53                   	push   %ebx
  8004ca:	52                   	push   %edx
  8004cb:	ff d6                	call   *%esi
  8004cd:	83 c4 10             	add    $0x10,%esp
  8004d0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004d3:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004d5:	83 c7 01             	add    $0x1,%edi
  8004d8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004dc:	0f be d0             	movsbl %al,%edx
  8004df:	85 d2                	test   %edx,%edx
  8004e1:	74 4b                	je     80052e <vprintfmt+0x23f>
  8004e3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004e7:	78 06                	js     8004ef <vprintfmt+0x200>
  8004e9:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004ed:	78 1e                	js     80050d <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004ef:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004f3:	74 d1                	je     8004c6 <vprintfmt+0x1d7>
  8004f5:	0f be c0             	movsbl %al,%eax
  8004f8:	83 e8 20             	sub    $0x20,%eax
  8004fb:	83 f8 5e             	cmp    $0x5e,%eax
  8004fe:	76 c6                	jbe    8004c6 <vprintfmt+0x1d7>
					putch('?', putdat);
  800500:	83 ec 08             	sub    $0x8,%esp
  800503:	53                   	push   %ebx
  800504:	6a 3f                	push   $0x3f
  800506:	ff d6                	call   *%esi
  800508:	83 c4 10             	add    $0x10,%esp
  80050b:	eb c3                	jmp    8004d0 <vprintfmt+0x1e1>
  80050d:	89 cf                	mov    %ecx,%edi
  80050f:	eb 0e                	jmp    80051f <vprintfmt+0x230>
				putch(' ', putdat);
  800511:	83 ec 08             	sub    $0x8,%esp
  800514:	53                   	push   %ebx
  800515:	6a 20                	push   $0x20
  800517:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800519:	83 ef 01             	sub    $0x1,%edi
  80051c:	83 c4 10             	add    $0x10,%esp
  80051f:	85 ff                	test   %edi,%edi
  800521:	7f ee                	jg     800511 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800523:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800526:	89 45 14             	mov    %eax,0x14(%ebp)
  800529:	e9 67 01 00 00       	jmp    800695 <vprintfmt+0x3a6>
  80052e:	89 cf                	mov    %ecx,%edi
  800530:	eb ed                	jmp    80051f <vprintfmt+0x230>
	if (lflag >= 2)
  800532:	83 f9 01             	cmp    $0x1,%ecx
  800535:	7f 1b                	jg     800552 <vprintfmt+0x263>
	else if (lflag)
  800537:	85 c9                	test   %ecx,%ecx
  800539:	74 63                	je     80059e <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80053b:	8b 45 14             	mov    0x14(%ebp),%eax
  80053e:	8b 00                	mov    (%eax),%eax
  800540:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800543:	99                   	cltd   
  800544:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800547:	8b 45 14             	mov    0x14(%ebp),%eax
  80054a:	8d 40 04             	lea    0x4(%eax),%eax
  80054d:	89 45 14             	mov    %eax,0x14(%ebp)
  800550:	eb 17                	jmp    800569 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800552:	8b 45 14             	mov    0x14(%ebp),%eax
  800555:	8b 50 04             	mov    0x4(%eax),%edx
  800558:	8b 00                	mov    (%eax),%eax
  80055a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80055d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800560:	8b 45 14             	mov    0x14(%ebp),%eax
  800563:	8d 40 08             	lea    0x8(%eax),%eax
  800566:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800569:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80056c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80056f:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800574:	85 c9                	test   %ecx,%ecx
  800576:	0f 89 ff 00 00 00    	jns    80067b <vprintfmt+0x38c>
				putch('-', putdat);
  80057c:	83 ec 08             	sub    $0x8,%esp
  80057f:	53                   	push   %ebx
  800580:	6a 2d                	push   $0x2d
  800582:	ff d6                	call   *%esi
				num = -(long long) num;
  800584:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800587:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80058a:	f7 da                	neg    %edx
  80058c:	83 d1 00             	adc    $0x0,%ecx
  80058f:	f7 d9                	neg    %ecx
  800591:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800594:	b8 0a 00 00 00       	mov    $0xa,%eax
  800599:	e9 dd 00 00 00       	jmp    80067b <vprintfmt+0x38c>
		return va_arg(*ap, int);
  80059e:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a1:	8b 00                	mov    (%eax),%eax
  8005a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a6:	99                   	cltd   
  8005a7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ad:	8d 40 04             	lea    0x4(%eax),%eax
  8005b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b3:	eb b4                	jmp    800569 <vprintfmt+0x27a>
	if (lflag >= 2)
  8005b5:	83 f9 01             	cmp    $0x1,%ecx
  8005b8:	7f 1e                	jg     8005d8 <vprintfmt+0x2e9>
	else if (lflag)
  8005ba:	85 c9                	test   %ecx,%ecx
  8005bc:	74 32                	je     8005f0 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8005be:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c1:	8b 10                	mov    (%eax),%edx
  8005c3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005c8:	8d 40 04             	lea    0x4(%eax),%eax
  8005cb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ce:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8005d3:	e9 a3 00 00 00       	jmp    80067b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005db:	8b 10                	mov    (%eax),%edx
  8005dd:	8b 48 04             	mov    0x4(%eax),%ecx
  8005e0:	8d 40 08             	lea    0x8(%eax),%eax
  8005e3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005e6:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8005eb:	e9 8b 00 00 00       	jmp    80067b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f3:	8b 10                	mov    (%eax),%edx
  8005f5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005fa:	8d 40 04             	lea    0x4(%eax),%eax
  8005fd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800600:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800605:	eb 74                	jmp    80067b <vprintfmt+0x38c>
	if (lflag >= 2)
  800607:	83 f9 01             	cmp    $0x1,%ecx
  80060a:	7f 1b                	jg     800627 <vprintfmt+0x338>
	else if (lflag)
  80060c:	85 c9                	test   %ecx,%ecx
  80060e:	74 2c                	je     80063c <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800610:	8b 45 14             	mov    0x14(%ebp),%eax
  800613:	8b 10                	mov    (%eax),%edx
  800615:	b9 00 00 00 00       	mov    $0x0,%ecx
  80061a:	8d 40 04             	lea    0x4(%eax),%eax
  80061d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800620:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800625:	eb 54                	jmp    80067b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800627:	8b 45 14             	mov    0x14(%ebp),%eax
  80062a:	8b 10                	mov    (%eax),%edx
  80062c:	8b 48 04             	mov    0x4(%eax),%ecx
  80062f:	8d 40 08             	lea    0x8(%eax),%eax
  800632:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800635:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80063a:	eb 3f                	jmp    80067b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80063c:	8b 45 14             	mov    0x14(%ebp),%eax
  80063f:	8b 10                	mov    (%eax),%edx
  800641:	b9 00 00 00 00       	mov    $0x0,%ecx
  800646:	8d 40 04             	lea    0x4(%eax),%eax
  800649:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80064c:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800651:	eb 28                	jmp    80067b <vprintfmt+0x38c>
			putch('0', putdat);
  800653:	83 ec 08             	sub    $0x8,%esp
  800656:	53                   	push   %ebx
  800657:	6a 30                	push   $0x30
  800659:	ff d6                	call   *%esi
			putch('x', putdat);
  80065b:	83 c4 08             	add    $0x8,%esp
  80065e:	53                   	push   %ebx
  80065f:	6a 78                	push   $0x78
  800661:	ff d6                	call   *%esi
			num = (unsigned long long)
  800663:	8b 45 14             	mov    0x14(%ebp),%eax
  800666:	8b 10                	mov    (%eax),%edx
  800668:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80066d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800670:	8d 40 04             	lea    0x4(%eax),%eax
  800673:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800676:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80067b:	83 ec 0c             	sub    $0xc,%esp
  80067e:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800682:	57                   	push   %edi
  800683:	ff 75 e0             	pushl  -0x20(%ebp)
  800686:	50                   	push   %eax
  800687:	51                   	push   %ecx
  800688:	52                   	push   %edx
  800689:	89 da                	mov    %ebx,%edx
  80068b:	89 f0                	mov    %esi,%eax
  80068d:	e8 72 fb ff ff       	call   800204 <printnum>
			break;
  800692:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800695:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800698:	83 c7 01             	add    $0x1,%edi
  80069b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80069f:	83 f8 25             	cmp    $0x25,%eax
  8006a2:	0f 84 62 fc ff ff    	je     80030a <vprintfmt+0x1b>
			if (ch == '\0')
  8006a8:	85 c0                	test   %eax,%eax
  8006aa:	0f 84 8b 00 00 00    	je     80073b <vprintfmt+0x44c>
			putch(ch, putdat);
  8006b0:	83 ec 08             	sub    $0x8,%esp
  8006b3:	53                   	push   %ebx
  8006b4:	50                   	push   %eax
  8006b5:	ff d6                	call   *%esi
  8006b7:	83 c4 10             	add    $0x10,%esp
  8006ba:	eb dc                	jmp    800698 <vprintfmt+0x3a9>
	if (lflag >= 2)
  8006bc:	83 f9 01             	cmp    $0x1,%ecx
  8006bf:	7f 1b                	jg     8006dc <vprintfmt+0x3ed>
	else if (lflag)
  8006c1:	85 c9                	test   %ecx,%ecx
  8006c3:	74 2c                	je     8006f1 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8006c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c8:	8b 10                	mov    (%eax),%edx
  8006ca:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006cf:	8d 40 04             	lea    0x4(%eax),%eax
  8006d2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006d5:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8006da:	eb 9f                	jmp    80067b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8006dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006df:	8b 10                	mov    (%eax),%edx
  8006e1:	8b 48 04             	mov    0x4(%eax),%ecx
  8006e4:	8d 40 08             	lea    0x8(%eax),%eax
  8006e7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ea:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8006ef:	eb 8a                	jmp    80067b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f4:	8b 10                	mov    (%eax),%edx
  8006f6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006fb:	8d 40 04             	lea    0x4(%eax),%eax
  8006fe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800701:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800706:	e9 70 ff ff ff       	jmp    80067b <vprintfmt+0x38c>
			putch(ch, putdat);
  80070b:	83 ec 08             	sub    $0x8,%esp
  80070e:	53                   	push   %ebx
  80070f:	6a 25                	push   $0x25
  800711:	ff d6                	call   *%esi
			break;
  800713:	83 c4 10             	add    $0x10,%esp
  800716:	e9 7a ff ff ff       	jmp    800695 <vprintfmt+0x3a6>
			putch('%', putdat);
  80071b:	83 ec 08             	sub    $0x8,%esp
  80071e:	53                   	push   %ebx
  80071f:	6a 25                	push   $0x25
  800721:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800723:	83 c4 10             	add    $0x10,%esp
  800726:	89 f8                	mov    %edi,%eax
  800728:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80072c:	74 05                	je     800733 <vprintfmt+0x444>
  80072e:	83 e8 01             	sub    $0x1,%eax
  800731:	eb f5                	jmp    800728 <vprintfmt+0x439>
  800733:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800736:	e9 5a ff ff ff       	jmp    800695 <vprintfmt+0x3a6>
}
  80073b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80073e:	5b                   	pop    %ebx
  80073f:	5e                   	pop    %esi
  800740:	5f                   	pop    %edi
  800741:	5d                   	pop    %ebp
  800742:	c3                   	ret    

00800743 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800743:	f3 0f 1e fb          	endbr32 
  800747:	55                   	push   %ebp
  800748:	89 e5                	mov    %esp,%ebp
  80074a:	83 ec 18             	sub    $0x18,%esp
  80074d:	8b 45 08             	mov    0x8(%ebp),%eax
  800750:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800753:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800756:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80075a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80075d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800764:	85 c0                	test   %eax,%eax
  800766:	74 26                	je     80078e <vsnprintf+0x4b>
  800768:	85 d2                	test   %edx,%edx
  80076a:	7e 22                	jle    80078e <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80076c:	ff 75 14             	pushl  0x14(%ebp)
  80076f:	ff 75 10             	pushl  0x10(%ebp)
  800772:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800775:	50                   	push   %eax
  800776:	68 ad 02 80 00       	push   $0x8002ad
  80077b:	e8 6f fb ff ff       	call   8002ef <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800780:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800783:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800786:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800789:	83 c4 10             	add    $0x10,%esp
}
  80078c:	c9                   	leave  
  80078d:	c3                   	ret    
		return -E_INVAL;
  80078e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800793:	eb f7                	jmp    80078c <vsnprintf+0x49>

00800795 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800795:	f3 0f 1e fb          	endbr32 
  800799:	55                   	push   %ebp
  80079a:	89 e5                	mov    %esp,%ebp
  80079c:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80079f:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007a2:	50                   	push   %eax
  8007a3:	ff 75 10             	pushl  0x10(%ebp)
  8007a6:	ff 75 0c             	pushl  0xc(%ebp)
  8007a9:	ff 75 08             	pushl  0x8(%ebp)
  8007ac:	e8 92 ff ff ff       	call   800743 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007b1:	c9                   	leave  
  8007b2:	c3                   	ret    

008007b3 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007b3:	f3 0f 1e fb          	endbr32 
  8007b7:	55                   	push   %ebp
  8007b8:	89 e5                	mov    %esp,%ebp
  8007ba:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c2:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007c6:	74 05                	je     8007cd <strlen+0x1a>
		n++;
  8007c8:	83 c0 01             	add    $0x1,%eax
  8007cb:	eb f5                	jmp    8007c2 <strlen+0xf>
	return n;
}
  8007cd:	5d                   	pop    %ebp
  8007ce:	c3                   	ret    

008007cf <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007cf:	f3 0f 1e fb          	endbr32 
  8007d3:	55                   	push   %ebp
  8007d4:	89 e5                	mov    %esp,%ebp
  8007d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007d9:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e1:	39 d0                	cmp    %edx,%eax
  8007e3:	74 0d                	je     8007f2 <strnlen+0x23>
  8007e5:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007e9:	74 05                	je     8007f0 <strnlen+0x21>
		n++;
  8007eb:	83 c0 01             	add    $0x1,%eax
  8007ee:	eb f1                	jmp    8007e1 <strnlen+0x12>
  8007f0:	89 c2                	mov    %eax,%edx
	return n;
}
  8007f2:	89 d0                	mov    %edx,%eax
  8007f4:	5d                   	pop    %ebp
  8007f5:	c3                   	ret    

008007f6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007f6:	f3 0f 1e fb          	endbr32 
  8007fa:	55                   	push   %ebp
  8007fb:	89 e5                	mov    %esp,%ebp
  8007fd:	53                   	push   %ebx
  8007fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800801:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800804:	b8 00 00 00 00       	mov    $0x0,%eax
  800809:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80080d:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800810:	83 c0 01             	add    $0x1,%eax
  800813:	84 d2                	test   %dl,%dl
  800815:	75 f2                	jne    800809 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800817:	89 c8                	mov    %ecx,%eax
  800819:	5b                   	pop    %ebx
  80081a:	5d                   	pop    %ebp
  80081b:	c3                   	ret    

0080081c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80081c:	f3 0f 1e fb          	endbr32 
  800820:	55                   	push   %ebp
  800821:	89 e5                	mov    %esp,%ebp
  800823:	53                   	push   %ebx
  800824:	83 ec 10             	sub    $0x10,%esp
  800827:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80082a:	53                   	push   %ebx
  80082b:	e8 83 ff ff ff       	call   8007b3 <strlen>
  800830:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	01 d8                	add    %ebx,%eax
  800838:	50                   	push   %eax
  800839:	e8 b8 ff ff ff       	call   8007f6 <strcpy>
	return dst;
}
  80083e:	89 d8                	mov    %ebx,%eax
  800840:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800843:	c9                   	leave  
  800844:	c3                   	ret    

00800845 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800845:	f3 0f 1e fb          	endbr32 
  800849:	55                   	push   %ebp
  80084a:	89 e5                	mov    %esp,%ebp
  80084c:	56                   	push   %esi
  80084d:	53                   	push   %ebx
  80084e:	8b 75 08             	mov    0x8(%ebp),%esi
  800851:	8b 55 0c             	mov    0xc(%ebp),%edx
  800854:	89 f3                	mov    %esi,%ebx
  800856:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800859:	89 f0                	mov    %esi,%eax
  80085b:	39 d8                	cmp    %ebx,%eax
  80085d:	74 11                	je     800870 <strncpy+0x2b>
		*dst++ = *src;
  80085f:	83 c0 01             	add    $0x1,%eax
  800862:	0f b6 0a             	movzbl (%edx),%ecx
  800865:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800868:	80 f9 01             	cmp    $0x1,%cl
  80086b:	83 da ff             	sbb    $0xffffffff,%edx
  80086e:	eb eb                	jmp    80085b <strncpy+0x16>
	}
	return ret;
}
  800870:	89 f0                	mov    %esi,%eax
  800872:	5b                   	pop    %ebx
  800873:	5e                   	pop    %esi
  800874:	5d                   	pop    %ebp
  800875:	c3                   	ret    

00800876 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800876:	f3 0f 1e fb          	endbr32 
  80087a:	55                   	push   %ebp
  80087b:	89 e5                	mov    %esp,%ebp
  80087d:	56                   	push   %esi
  80087e:	53                   	push   %ebx
  80087f:	8b 75 08             	mov    0x8(%ebp),%esi
  800882:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800885:	8b 55 10             	mov    0x10(%ebp),%edx
  800888:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80088a:	85 d2                	test   %edx,%edx
  80088c:	74 21                	je     8008af <strlcpy+0x39>
  80088e:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800892:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800894:	39 c2                	cmp    %eax,%edx
  800896:	74 14                	je     8008ac <strlcpy+0x36>
  800898:	0f b6 19             	movzbl (%ecx),%ebx
  80089b:	84 db                	test   %bl,%bl
  80089d:	74 0b                	je     8008aa <strlcpy+0x34>
			*dst++ = *src++;
  80089f:	83 c1 01             	add    $0x1,%ecx
  8008a2:	83 c2 01             	add    $0x1,%edx
  8008a5:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008a8:	eb ea                	jmp    800894 <strlcpy+0x1e>
  8008aa:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008ac:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008af:	29 f0                	sub    %esi,%eax
}
  8008b1:	5b                   	pop    %ebx
  8008b2:	5e                   	pop    %esi
  8008b3:	5d                   	pop    %ebp
  8008b4:	c3                   	ret    

008008b5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008b5:	f3 0f 1e fb          	endbr32 
  8008b9:	55                   	push   %ebp
  8008ba:	89 e5                	mov    %esp,%ebp
  8008bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008bf:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008c2:	0f b6 01             	movzbl (%ecx),%eax
  8008c5:	84 c0                	test   %al,%al
  8008c7:	74 0c                	je     8008d5 <strcmp+0x20>
  8008c9:	3a 02                	cmp    (%edx),%al
  8008cb:	75 08                	jne    8008d5 <strcmp+0x20>
		p++, q++;
  8008cd:	83 c1 01             	add    $0x1,%ecx
  8008d0:	83 c2 01             	add    $0x1,%edx
  8008d3:	eb ed                	jmp    8008c2 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008d5:	0f b6 c0             	movzbl %al,%eax
  8008d8:	0f b6 12             	movzbl (%edx),%edx
  8008db:	29 d0                	sub    %edx,%eax
}
  8008dd:	5d                   	pop    %ebp
  8008de:	c3                   	ret    

008008df <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008df:	f3 0f 1e fb          	endbr32 
  8008e3:	55                   	push   %ebp
  8008e4:	89 e5                	mov    %esp,%ebp
  8008e6:	53                   	push   %ebx
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ed:	89 c3                	mov    %eax,%ebx
  8008ef:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008f2:	eb 06                	jmp    8008fa <strncmp+0x1b>
		n--, p++, q++;
  8008f4:	83 c0 01             	add    $0x1,%eax
  8008f7:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008fa:	39 d8                	cmp    %ebx,%eax
  8008fc:	74 16                	je     800914 <strncmp+0x35>
  8008fe:	0f b6 08             	movzbl (%eax),%ecx
  800901:	84 c9                	test   %cl,%cl
  800903:	74 04                	je     800909 <strncmp+0x2a>
  800905:	3a 0a                	cmp    (%edx),%cl
  800907:	74 eb                	je     8008f4 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800909:	0f b6 00             	movzbl (%eax),%eax
  80090c:	0f b6 12             	movzbl (%edx),%edx
  80090f:	29 d0                	sub    %edx,%eax
}
  800911:	5b                   	pop    %ebx
  800912:	5d                   	pop    %ebp
  800913:	c3                   	ret    
		return 0;
  800914:	b8 00 00 00 00       	mov    $0x0,%eax
  800919:	eb f6                	jmp    800911 <strncmp+0x32>

0080091b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80091b:	f3 0f 1e fb          	endbr32 
  80091f:	55                   	push   %ebp
  800920:	89 e5                	mov    %esp,%ebp
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800929:	0f b6 10             	movzbl (%eax),%edx
  80092c:	84 d2                	test   %dl,%dl
  80092e:	74 09                	je     800939 <strchr+0x1e>
		if (*s == c)
  800930:	38 ca                	cmp    %cl,%dl
  800932:	74 0a                	je     80093e <strchr+0x23>
	for (; *s; s++)
  800934:	83 c0 01             	add    $0x1,%eax
  800937:	eb f0                	jmp    800929 <strchr+0xe>
			return (char *) s;
	return 0;
  800939:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80093e:	5d                   	pop    %ebp
  80093f:	c3                   	ret    

00800940 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800940:	f3 0f 1e fb          	endbr32 
  800944:	55                   	push   %ebp
  800945:	89 e5                	mov    %esp,%ebp
  800947:	8b 45 08             	mov    0x8(%ebp),%eax
  80094a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80094e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800951:	38 ca                	cmp    %cl,%dl
  800953:	74 09                	je     80095e <strfind+0x1e>
  800955:	84 d2                	test   %dl,%dl
  800957:	74 05                	je     80095e <strfind+0x1e>
	for (; *s; s++)
  800959:	83 c0 01             	add    $0x1,%eax
  80095c:	eb f0                	jmp    80094e <strfind+0xe>
			break;
	return (char *) s;
}
  80095e:	5d                   	pop    %ebp
  80095f:	c3                   	ret    

00800960 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800960:	f3 0f 1e fb          	endbr32 
  800964:	55                   	push   %ebp
  800965:	89 e5                	mov    %esp,%ebp
  800967:	57                   	push   %edi
  800968:	56                   	push   %esi
  800969:	53                   	push   %ebx
  80096a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80096d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800970:	85 c9                	test   %ecx,%ecx
  800972:	74 31                	je     8009a5 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800974:	89 f8                	mov    %edi,%eax
  800976:	09 c8                	or     %ecx,%eax
  800978:	a8 03                	test   $0x3,%al
  80097a:	75 23                	jne    80099f <memset+0x3f>
		c &= 0xFF;
  80097c:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800980:	89 d3                	mov    %edx,%ebx
  800982:	c1 e3 08             	shl    $0x8,%ebx
  800985:	89 d0                	mov    %edx,%eax
  800987:	c1 e0 18             	shl    $0x18,%eax
  80098a:	89 d6                	mov    %edx,%esi
  80098c:	c1 e6 10             	shl    $0x10,%esi
  80098f:	09 f0                	or     %esi,%eax
  800991:	09 c2                	or     %eax,%edx
  800993:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800995:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800998:	89 d0                	mov    %edx,%eax
  80099a:	fc                   	cld    
  80099b:	f3 ab                	rep stos %eax,%es:(%edi)
  80099d:	eb 06                	jmp    8009a5 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80099f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a2:	fc                   	cld    
  8009a3:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009a5:	89 f8                	mov    %edi,%eax
  8009a7:	5b                   	pop    %ebx
  8009a8:	5e                   	pop    %esi
  8009a9:	5f                   	pop    %edi
  8009aa:	5d                   	pop    %ebp
  8009ab:	c3                   	ret    

008009ac <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009ac:	f3 0f 1e fb          	endbr32 
  8009b0:	55                   	push   %ebp
  8009b1:	89 e5                	mov    %esp,%ebp
  8009b3:	57                   	push   %edi
  8009b4:	56                   	push   %esi
  8009b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009be:	39 c6                	cmp    %eax,%esi
  8009c0:	73 32                	jae    8009f4 <memmove+0x48>
  8009c2:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009c5:	39 c2                	cmp    %eax,%edx
  8009c7:	76 2b                	jbe    8009f4 <memmove+0x48>
		s += n;
		d += n;
  8009c9:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009cc:	89 fe                	mov    %edi,%esi
  8009ce:	09 ce                	or     %ecx,%esi
  8009d0:	09 d6                	or     %edx,%esi
  8009d2:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009d8:	75 0e                	jne    8009e8 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009da:	83 ef 04             	sub    $0x4,%edi
  8009dd:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009e0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009e3:	fd                   	std    
  8009e4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009e6:	eb 09                	jmp    8009f1 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009e8:	83 ef 01             	sub    $0x1,%edi
  8009eb:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009ee:	fd                   	std    
  8009ef:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009f1:	fc                   	cld    
  8009f2:	eb 1a                	jmp    800a0e <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009f4:	89 c2                	mov    %eax,%edx
  8009f6:	09 ca                	or     %ecx,%edx
  8009f8:	09 f2                	or     %esi,%edx
  8009fa:	f6 c2 03             	test   $0x3,%dl
  8009fd:	75 0a                	jne    800a09 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009ff:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a02:	89 c7                	mov    %eax,%edi
  800a04:	fc                   	cld    
  800a05:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a07:	eb 05                	jmp    800a0e <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800a09:	89 c7                	mov    %eax,%edi
  800a0b:	fc                   	cld    
  800a0c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a0e:	5e                   	pop    %esi
  800a0f:	5f                   	pop    %edi
  800a10:	5d                   	pop    %ebp
  800a11:	c3                   	ret    

00800a12 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a12:	f3 0f 1e fb          	endbr32 
  800a16:	55                   	push   %ebp
  800a17:	89 e5                	mov    %esp,%ebp
  800a19:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a1c:	ff 75 10             	pushl  0x10(%ebp)
  800a1f:	ff 75 0c             	pushl  0xc(%ebp)
  800a22:	ff 75 08             	pushl  0x8(%ebp)
  800a25:	e8 82 ff ff ff       	call   8009ac <memmove>
}
  800a2a:	c9                   	leave  
  800a2b:	c3                   	ret    

00800a2c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a2c:	f3 0f 1e fb          	endbr32 
  800a30:	55                   	push   %ebp
  800a31:	89 e5                	mov    %esp,%ebp
  800a33:	56                   	push   %esi
  800a34:	53                   	push   %ebx
  800a35:	8b 45 08             	mov    0x8(%ebp),%eax
  800a38:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a3b:	89 c6                	mov    %eax,%esi
  800a3d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a40:	39 f0                	cmp    %esi,%eax
  800a42:	74 1c                	je     800a60 <memcmp+0x34>
		if (*s1 != *s2)
  800a44:	0f b6 08             	movzbl (%eax),%ecx
  800a47:	0f b6 1a             	movzbl (%edx),%ebx
  800a4a:	38 d9                	cmp    %bl,%cl
  800a4c:	75 08                	jne    800a56 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a4e:	83 c0 01             	add    $0x1,%eax
  800a51:	83 c2 01             	add    $0x1,%edx
  800a54:	eb ea                	jmp    800a40 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a56:	0f b6 c1             	movzbl %cl,%eax
  800a59:	0f b6 db             	movzbl %bl,%ebx
  800a5c:	29 d8                	sub    %ebx,%eax
  800a5e:	eb 05                	jmp    800a65 <memcmp+0x39>
	}

	return 0;
  800a60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a65:	5b                   	pop    %ebx
  800a66:	5e                   	pop    %esi
  800a67:	5d                   	pop    %ebp
  800a68:	c3                   	ret    

00800a69 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a69:	f3 0f 1e fb          	endbr32 
  800a6d:	55                   	push   %ebp
  800a6e:	89 e5                	mov    %esp,%ebp
  800a70:	8b 45 08             	mov    0x8(%ebp),%eax
  800a73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a76:	89 c2                	mov    %eax,%edx
  800a78:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a7b:	39 d0                	cmp    %edx,%eax
  800a7d:	73 09                	jae    800a88 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a7f:	38 08                	cmp    %cl,(%eax)
  800a81:	74 05                	je     800a88 <memfind+0x1f>
	for (; s < ends; s++)
  800a83:	83 c0 01             	add    $0x1,%eax
  800a86:	eb f3                	jmp    800a7b <memfind+0x12>
			break;
	return (void *) s;
}
  800a88:	5d                   	pop    %ebp
  800a89:	c3                   	ret    

00800a8a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a8a:	f3 0f 1e fb          	endbr32 
  800a8e:	55                   	push   %ebp
  800a8f:	89 e5                	mov    %esp,%ebp
  800a91:	57                   	push   %edi
  800a92:	56                   	push   %esi
  800a93:	53                   	push   %ebx
  800a94:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a97:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a9a:	eb 03                	jmp    800a9f <strtol+0x15>
		s++;
  800a9c:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a9f:	0f b6 01             	movzbl (%ecx),%eax
  800aa2:	3c 20                	cmp    $0x20,%al
  800aa4:	74 f6                	je     800a9c <strtol+0x12>
  800aa6:	3c 09                	cmp    $0x9,%al
  800aa8:	74 f2                	je     800a9c <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800aaa:	3c 2b                	cmp    $0x2b,%al
  800aac:	74 2a                	je     800ad8 <strtol+0x4e>
	int neg = 0;
  800aae:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ab3:	3c 2d                	cmp    $0x2d,%al
  800ab5:	74 2b                	je     800ae2 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ab7:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800abd:	75 0f                	jne    800ace <strtol+0x44>
  800abf:	80 39 30             	cmpb   $0x30,(%ecx)
  800ac2:	74 28                	je     800aec <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ac4:	85 db                	test   %ebx,%ebx
  800ac6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800acb:	0f 44 d8             	cmove  %eax,%ebx
  800ace:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad3:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ad6:	eb 46                	jmp    800b1e <strtol+0x94>
		s++;
  800ad8:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800adb:	bf 00 00 00 00       	mov    $0x0,%edi
  800ae0:	eb d5                	jmp    800ab7 <strtol+0x2d>
		s++, neg = 1;
  800ae2:	83 c1 01             	add    $0x1,%ecx
  800ae5:	bf 01 00 00 00       	mov    $0x1,%edi
  800aea:	eb cb                	jmp    800ab7 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800aec:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800af0:	74 0e                	je     800b00 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800af2:	85 db                	test   %ebx,%ebx
  800af4:	75 d8                	jne    800ace <strtol+0x44>
		s++, base = 8;
  800af6:	83 c1 01             	add    $0x1,%ecx
  800af9:	bb 08 00 00 00       	mov    $0x8,%ebx
  800afe:	eb ce                	jmp    800ace <strtol+0x44>
		s += 2, base = 16;
  800b00:	83 c1 02             	add    $0x2,%ecx
  800b03:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b08:	eb c4                	jmp    800ace <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b0a:	0f be d2             	movsbl %dl,%edx
  800b0d:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b10:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b13:	7d 3a                	jge    800b4f <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b15:	83 c1 01             	add    $0x1,%ecx
  800b18:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b1c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b1e:	0f b6 11             	movzbl (%ecx),%edx
  800b21:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b24:	89 f3                	mov    %esi,%ebx
  800b26:	80 fb 09             	cmp    $0x9,%bl
  800b29:	76 df                	jbe    800b0a <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b2b:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b2e:	89 f3                	mov    %esi,%ebx
  800b30:	80 fb 19             	cmp    $0x19,%bl
  800b33:	77 08                	ja     800b3d <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b35:	0f be d2             	movsbl %dl,%edx
  800b38:	83 ea 57             	sub    $0x57,%edx
  800b3b:	eb d3                	jmp    800b10 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b3d:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b40:	89 f3                	mov    %esi,%ebx
  800b42:	80 fb 19             	cmp    $0x19,%bl
  800b45:	77 08                	ja     800b4f <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b47:	0f be d2             	movsbl %dl,%edx
  800b4a:	83 ea 37             	sub    $0x37,%edx
  800b4d:	eb c1                	jmp    800b10 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b4f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b53:	74 05                	je     800b5a <strtol+0xd0>
		*endptr = (char *) s;
  800b55:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b58:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b5a:	89 c2                	mov    %eax,%edx
  800b5c:	f7 da                	neg    %edx
  800b5e:	85 ff                	test   %edi,%edi
  800b60:	0f 45 c2             	cmovne %edx,%eax
}
  800b63:	5b                   	pop    %ebx
  800b64:	5e                   	pop    %esi
  800b65:	5f                   	pop    %edi
  800b66:	5d                   	pop    %ebp
  800b67:	c3                   	ret    

00800b68 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b68:	f3 0f 1e fb          	endbr32 
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	57                   	push   %edi
  800b70:	56                   	push   %esi
  800b71:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b72:	b8 00 00 00 00       	mov    $0x0,%eax
  800b77:	8b 55 08             	mov    0x8(%ebp),%edx
  800b7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b7d:	89 c3                	mov    %eax,%ebx
  800b7f:	89 c7                	mov    %eax,%edi
  800b81:	89 c6                	mov    %eax,%esi
  800b83:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b85:	5b                   	pop    %ebx
  800b86:	5e                   	pop    %esi
  800b87:	5f                   	pop    %edi
  800b88:	5d                   	pop    %ebp
  800b89:	c3                   	ret    

00800b8a <sys_cgetc>:

int
sys_cgetc(void)
{
  800b8a:	f3 0f 1e fb          	endbr32 
  800b8e:	55                   	push   %ebp
  800b8f:	89 e5                	mov    %esp,%ebp
  800b91:	57                   	push   %edi
  800b92:	56                   	push   %esi
  800b93:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b94:	ba 00 00 00 00       	mov    $0x0,%edx
  800b99:	b8 01 00 00 00       	mov    $0x1,%eax
  800b9e:	89 d1                	mov    %edx,%ecx
  800ba0:	89 d3                	mov    %edx,%ebx
  800ba2:	89 d7                	mov    %edx,%edi
  800ba4:	89 d6                	mov    %edx,%esi
  800ba6:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ba8:	5b                   	pop    %ebx
  800ba9:	5e                   	pop    %esi
  800baa:	5f                   	pop    %edi
  800bab:	5d                   	pop    %ebp
  800bac:	c3                   	ret    

00800bad <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bad:	f3 0f 1e fb          	endbr32 
  800bb1:	55                   	push   %ebp
  800bb2:	89 e5                	mov    %esp,%ebp
  800bb4:	57                   	push   %edi
  800bb5:	56                   	push   %esi
  800bb6:	53                   	push   %ebx
  800bb7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bba:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bbf:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc2:	b8 03 00 00 00       	mov    $0x3,%eax
  800bc7:	89 cb                	mov    %ecx,%ebx
  800bc9:	89 cf                	mov    %ecx,%edi
  800bcb:	89 ce                	mov    %ecx,%esi
  800bcd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bcf:	85 c0                	test   %eax,%eax
  800bd1:	7f 08                	jg     800bdb <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bd6:	5b                   	pop    %ebx
  800bd7:	5e                   	pop    %esi
  800bd8:	5f                   	pop    %edi
  800bd9:	5d                   	pop    %ebp
  800bda:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bdb:	83 ec 0c             	sub    $0xc,%esp
  800bde:	50                   	push   %eax
  800bdf:	6a 03                	push   $0x3
  800be1:	68 84 16 80 00       	push   $0x801684
  800be6:	6a 23                	push   $0x23
  800be8:	68 a1 16 80 00       	push   $0x8016a1
  800bed:	e8 dc 04 00 00       	call   8010ce <_panic>

00800bf2 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bf2:	f3 0f 1e fb          	endbr32 
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
  800bf9:	57                   	push   %edi
  800bfa:	56                   	push   %esi
  800bfb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bfc:	ba 00 00 00 00       	mov    $0x0,%edx
  800c01:	b8 02 00 00 00       	mov    $0x2,%eax
  800c06:	89 d1                	mov    %edx,%ecx
  800c08:	89 d3                	mov    %edx,%ebx
  800c0a:	89 d7                	mov    %edx,%edi
  800c0c:	89 d6                	mov    %edx,%esi
  800c0e:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c10:	5b                   	pop    %ebx
  800c11:	5e                   	pop    %esi
  800c12:	5f                   	pop    %edi
  800c13:	5d                   	pop    %ebp
  800c14:	c3                   	ret    

00800c15 <sys_yield>:

void
sys_yield(void)
{
  800c15:	f3 0f 1e fb          	endbr32 
  800c19:	55                   	push   %ebp
  800c1a:	89 e5                	mov    %esp,%ebp
  800c1c:	57                   	push   %edi
  800c1d:	56                   	push   %esi
  800c1e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c1f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c24:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c29:	89 d1                	mov    %edx,%ecx
  800c2b:	89 d3                	mov    %edx,%ebx
  800c2d:	89 d7                	mov    %edx,%edi
  800c2f:	89 d6                	mov    %edx,%esi
  800c31:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c33:	5b                   	pop    %ebx
  800c34:	5e                   	pop    %esi
  800c35:	5f                   	pop    %edi
  800c36:	5d                   	pop    %ebp
  800c37:	c3                   	ret    

00800c38 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c38:	f3 0f 1e fb          	endbr32 
  800c3c:	55                   	push   %ebp
  800c3d:	89 e5                	mov    %esp,%ebp
  800c3f:	57                   	push   %edi
  800c40:	56                   	push   %esi
  800c41:	53                   	push   %ebx
  800c42:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c45:	be 00 00 00 00       	mov    $0x0,%esi
  800c4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c50:	b8 04 00 00 00       	mov    $0x4,%eax
  800c55:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c58:	89 f7                	mov    %esi,%edi
  800c5a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c5c:	85 c0                	test   %eax,%eax
  800c5e:	7f 08                	jg     800c68 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c63:	5b                   	pop    %ebx
  800c64:	5e                   	pop    %esi
  800c65:	5f                   	pop    %edi
  800c66:	5d                   	pop    %ebp
  800c67:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c68:	83 ec 0c             	sub    $0xc,%esp
  800c6b:	50                   	push   %eax
  800c6c:	6a 04                	push   $0x4
  800c6e:	68 84 16 80 00       	push   $0x801684
  800c73:	6a 23                	push   $0x23
  800c75:	68 a1 16 80 00       	push   $0x8016a1
  800c7a:	e8 4f 04 00 00       	call   8010ce <_panic>

00800c7f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c7f:	f3 0f 1e fb          	endbr32 
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	57                   	push   %edi
  800c87:	56                   	push   %esi
  800c88:	53                   	push   %ebx
  800c89:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c92:	b8 05 00 00 00       	mov    $0x5,%eax
  800c97:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c9a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c9d:	8b 75 18             	mov    0x18(%ebp),%esi
  800ca0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ca2:	85 c0                	test   %eax,%eax
  800ca4:	7f 08                	jg     800cae <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ca6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca9:	5b                   	pop    %ebx
  800caa:	5e                   	pop    %esi
  800cab:	5f                   	pop    %edi
  800cac:	5d                   	pop    %ebp
  800cad:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cae:	83 ec 0c             	sub    $0xc,%esp
  800cb1:	50                   	push   %eax
  800cb2:	6a 05                	push   $0x5
  800cb4:	68 84 16 80 00       	push   $0x801684
  800cb9:	6a 23                	push   $0x23
  800cbb:	68 a1 16 80 00       	push   $0x8016a1
  800cc0:	e8 09 04 00 00       	call   8010ce <_panic>

00800cc5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cc5:	f3 0f 1e fb          	endbr32 
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
  800ccc:	57                   	push   %edi
  800ccd:	56                   	push   %esi
  800cce:	53                   	push   %ebx
  800ccf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cd2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cd7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cdd:	b8 06 00 00 00       	mov    $0x6,%eax
  800ce2:	89 df                	mov    %ebx,%edi
  800ce4:	89 de                	mov    %ebx,%esi
  800ce6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce8:	85 c0                	test   %eax,%eax
  800cea:	7f 08                	jg     800cf4 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cef:	5b                   	pop    %ebx
  800cf0:	5e                   	pop    %esi
  800cf1:	5f                   	pop    %edi
  800cf2:	5d                   	pop    %ebp
  800cf3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf4:	83 ec 0c             	sub    $0xc,%esp
  800cf7:	50                   	push   %eax
  800cf8:	6a 06                	push   $0x6
  800cfa:	68 84 16 80 00       	push   $0x801684
  800cff:	6a 23                	push   $0x23
  800d01:	68 a1 16 80 00       	push   $0x8016a1
  800d06:	e8 c3 03 00 00       	call   8010ce <_panic>

00800d0b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d0b:	f3 0f 1e fb          	endbr32 
  800d0f:	55                   	push   %ebp
  800d10:	89 e5                	mov    %esp,%ebp
  800d12:	57                   	push   %edi
  800d13:	56                   	push   %esi
  800d14:	53                   	push   %ebx
  800d15:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d18:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d23:	b8 08 00 00 00       	mov    $0x8,%eax
  800d28:	89 df                	mov    %ebx,%edi
  800d2a:	89 de                	mov    %ebx,%esi
  800d2c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d2e:	85 c0                	test   %eax,%eax
  800d30:	7f 08                	jg     800d3a <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d32:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d35:	5b                   	pop    %ebx
  800d36:	5e                   	pop    %esi
  800d37:	5f                   	pop    %edi
  800d38:	5d                   	pop    %ebp
  800d39:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3a:	83 ec 0c             	sub    $0xc,%esp
  800d3d:	50                   	push   %eax
  800d3e:	6a 08                	push   $0x8
  800d40:	68 84 16 80 00       	push   $0x801684
  800d45:	6a 23                	push   $0x23
  800d47:	68 a1 16 80 00       	push   $0x8016a1
  800d4c:	e8 7d 03 00 00       	call   8010ce <_panic>

00800d51 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d51:	f3 0f 1e fb          	endbr32 
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	57                   	push   %edi
  800d59:	56                   	push   %esi
  800d5a:	53                   	push   %ebx
  800d5b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d5e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d63:	8b 55 08             	mov    0x8(%ebp),%edx
  800d66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d69:	b8 09 00 00 00       	mov    $0x9,%eax
  800d6e:	89 df                	mov    %ebx,%edi
  800d70:	89 de                	mov    %ebx,%esi
  800d72:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d74:	85 c0                	test   %eax,%eax
  800d76:	7f 08                	jg     800d80 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7b:	5b                   	pop    %ebx
  800d7c:	5e                   	pop    %esi
  800d7d:	5f                   	pop    %edi
  800d7e:	5d                   	pop    %ebp
  800d7f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d80:	83 ec 0c             	sub    $0xc,%esp
  800d83:	50                   	push   %eax
  800d84:	6a 09                	push   $0x9
  800d86:	68 84 16 80 00       	push   $0x801684
  800d8b:	6a 23                	push   $0x23
  800d8d:	68 a1 16 80 00       	push   $0x8016a1
  800d92:	e8 37 03 00 00       	call   8010ce <_panic>

00800d97 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d97:	f3 0f 1e fb          	endbr32 
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	57                   	push   %edi
  800d9f:	56                   	push   %esi
  800da0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800da1:	8b 55 08             	mov    0x8(%ebp),%edx
  800da4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da7:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dac:	be 00 00 00 00       	mov    $0x0,%esi
  800db1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800db4:	8b 7d 14             	mov    0x14(%ebp),%edi
  800db7:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800db9:	5b                   	pop    %ebx
  800dba:	5e                   	pop    %esi
  800dbb:	5f                   	pop    %edi
  800dbc:	5d                   	pop    %ebp
  800dbd:	c3                   	ret    

00800dbe <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dbe:	f3 0f 1e fb          	endbr32 
  800dc2:	55                   	push   %ebp
  800dc3:	89 e5                	mov    %esp,%ebp
  800dc5:	57                   	push   %edi
  800dc6:	56                   	push   %esi
  800dc7:	53                   	push   %ebx
  800dc8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dcb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dd0:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd3:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dd8:	89 cb                	mov    %ecx,%ebx
  800dda:	89 cf                	mov    %ecx,%edi
  800ddc:	89 ce                	mov    %ecx,%esi
  800dde:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de0:	85 c0                	test   %eax,%eax
  800de2:	7f 08                	jg     800dec <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800de4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de7:	5b                   	pop    %ebx
  800de8:	5e                   	pop    %esi
  800de9:	5f                   	pop    %edi
  800dea:	5d                   	pop    %ebp
  800deb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dec:	83 ec 0c             	sub    $0xc,%esp
  800def:	50                   	push   %eax
  800df0:	6a 0c                	push   $0xc
  800df2:	68 84 16 80 00       	push   $0x801684
  800df7:	6a 23                	push   $0x23
  800df9:	68 a1 16 80 00       	push   $0x8016a1
  800dfe:	e8 cb 02 00 00       	call   8010ce <_panic>

00800e03 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800e03:	f3 0f 1e fb          	endbr32 
  800e07:	55                   	push   %ebp
  800e08:	89 e5                	mov    %esp,%ebp
  800e0a:	53                   	push   %ebx
  800e0b:	83 ec 04             	sub    $0x4,%esp
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800e11:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  800e13:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800e17:	74 74                	je     800e8d <pgfault+0x8a>
  800e19:	89 d8                	mov    %ebx,%eax
  800e1b:	c1 e8 0c             	shr    $0xc,%eax
  800e1e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800e25:	f6 c4 08             	test   $0x8,%ah
  800e28:	74 63                	je     800e8d <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800e2a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  800e30:	83 ec 0c             	sub    $0xc,%esp
  800e33:	6a 05                	push   $0x5
  800e35:	68 00 f0 7f 00       	push   $0x7ff000
  800e3a:	6a 00                	push   $0x0
  800e3c:	53                   	push   %ebx
  800e3d:	6a 00                	push   $0x0
  800e3f:	e8 3b fe ff ff       	call   800c7f <sys_page_map>
  800e44:	83 c4 20             	add    $0x20,%esp
  800e47:	85 c0                	test   %eax,%eax
  800e49:	78 59                	js     800ea4 <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  800e4b:	83 ec 04             	sub    $0x4,%esp
  800e4e:	6a 07                	push   $0x7
  800e50:	53                   	push   %ebx
  800e51:	6a 00                	push   $0x0
  800e53:	e8 e0 fd ff ff       	call   800c38 <sys_page_alloc>
  800e58:	83 c4 10             	add    $0x10,%esp
  800e5b:	85 c0                	test   %eax,%eax
  800e5d:	78 5a                	js     800eb9 <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  800e5f:	83 ec 04             	sub    $0x4,%esp
  800e62:	68 00 10 00 00       	push   $0x1000
  800e67:	68 00 f0 7f 00       	push   $0x7ff000
  800e6c:	53                   	push   %ebx
  800e6d:	e8 3a fb ff ff       	call   8009ac <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  800e72:	83 c4 08             	add    $0x8,%esp
  800e75:	68 00 f0 7f 00       	push   $0x7ff000
  800e7a:	6a 00                	push   $0x0
  800e7c:	e8 44 fe ff ff       	call   800cc5 <sys_page_unmap>
  800e81:	83 c4 10             	add    $0x10,%esp
  800e84:	85 c0                	test   %eax,%eax
  800e86:	78 46                	js     800ece <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  800e88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e8b:	c9                   	leave  
  800e8c:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  800e8d:	83 ec 04             	sub    $0x4,%esp
  800e90:	68 af 16 80 00       	push   $0x8016af
  800e95:	68 d3 00 00 00       	push   $0xd3
  800e9a:	68 cb 16 80 00       	push   $0x8016cb
  800e9f:	e8 2a 02 00 00       	call   8010ce <_panic>
		panic("pgfault: %e\n", r);
  800ea4:	50                   	push   %eax
  800ea5:	68 d6 16 80 00       	push   $0x8016d6
  800eaa:	68 df 00 00 00       	push   $0xdf
  800eaf:	68 cb 16 80 00       	push   $0x8016cb
  800eb4:	e8 15 02 00 00       	call   8010ce <_panic>
		panic("pgfault: %e\n", r);
  800eb9:	50                   	push   %eax
  800eba:	68 d6 16 80 00       	push   $0x8016d6
  800ebf:	68 e3 00 00 00       	push   $0xe3
  800ec4:	68 cb 16 80 00       	push   $0x8016cb
  800ec9:	e8 00 02 00 00       	call   8010ce <_panic>
		panic("pgfault: %e\n", r);
  800ece:	50                   	push   %eax
  800ecf:	68 d6 16 80 00       	push   $0x8016d6
  800ed4:	68 e9 00 00 00       	push   $0xe9
  800ed9:	68 cb 16 80 00       	push   $0x8016cb
  800ede:	e8 eb 01 00 00       	call   8010ce <_panic>

00800ee3 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800ee3:	f3 0f 1e fb          	endbr32 
  800ee7:	55                   	push   %ebp
  800ee8:	89 e5                	mov    %esp,%ebp
  800eea:	57                   	push   %edi
  800eeb:	56                   	push   %esi
  800eec:	53                   	push   %ebx
  800eed:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  800ef0:	68 03 0e 80 00       	push   $0x800e03
  800ef5:	e8 1e 02 00 00       	call   801118 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800efa:	b8 07 00 00 00       	mov    $0x7,%eax
  800eff:	cd 30                	int    $0x30
  800f01:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  800f04:	83 c4 10             	add    $0x10,%esp
  800f07:	85 c0                	test   %eax,%eax
  800f09:	78 2d                	js     800f38 <fork+0x55>
  800f0b:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800f0d:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  800f12:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f16:	0f 85 81 00 00 00    	jne    800f9d <fork+0xba>
		thisenv = &envs[ENVX(sys_getenvid())];
  800f1c:	e8 d1 fc ff ff       	call   800bf2 <sys_getenvid>
  800f21:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f26:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f29:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f2e:	a3 04 20 80 00       	mov    %eax,0x802004
		return 0;
  800f33:	e9 43 01 00 00       	jmp    80107b <fork+0x198>
		panic("sys_exofork: %e", envid);
  800f38:	50                   	push   %eax
  800f39:	68 e3 16 80 00       	push   $0x8016e3
  800f3e:	68 26 01 00 00       	push   $0x126
  800f43:	68 cb 16 80 00       	push   $0x8016cb
  800f48:	e8 81 01 00 00       	call   8010ce <_panic>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  800f4d:	c1 e6 0c             	shl    $0xc,%esi
  800f50:	83 ec 0c             	sub    $0xc,%esp
  800f53:	68 05 08 00 00       	push   $0x805
  800f58:	56                   	push   %esi
  800f59:	57                   	push   %edi
  800f5a:	56                   	push   %esi
  800f5b:	6a 00                	push   $0x0
  800f5d:	e8 1d fd ff ff       	call   800c7f <sys_page_map>
  800f62:	83 c4 20             	add    $0x20,%esp
  800f65:	85 c0                	test   %eax,%eax
  800f67:	0f 88 a8 00 00 00    	js     801015 <fork+0x132>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  800f6d:	83 ec 0c             	sub    $0xc,%esp
  800f70:	68 05 08 00 00       	push   $0x805
  800f75:	56                   	push   %esi
  800f76:	6a 00                	push   $0x0
  800f78:	56                   	push   %esi
  800f79:	6a 00                	push   $0x0
  800f7b:	e8 ff fc ff ff       	call   800c7f <sys_page_map>
  800f80:	83 c4 20             	add    $0x20,%esp
  800f83:	85 c0                	test   %eax,%eax
  800f85:	0f 88 9f 00 00 00    	js     80102a <fork+0x147>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800f8b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800f91:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  800f97:	0f 84 a2 00 00 00    	je     80103f <fork+0x15c>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  800f9d:	89 d8                	mov    %ebx,%eax
  800f9f:	c1 e8 16             	shr    $0x16,%eax
  800fa2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fa9:	a8 01                	test   $0x1,%al
  800fab:	74 de                	je     800f8b <fork+0xa8>
  800fad:	89 de                	mov    %ebx,%esi
  800faf:	c1 ee 0c             	shr    $0xc,%esi
  800fb2:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  800fb9:	a8 01                	test   $0x1,%al
  800fbb:	74 ce                	je     800f8b <fork+0xa8>
  800fbd:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  800fc4:	a8 04                	test   $0x4,%al
  800fc6:	74 c3                	je     800f8b <fork+0xa8>
	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  800fc8:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  800fcf:	a8 02                	test   $0x2,%al
  800fd1:	0f 85 76 ff ff ff    	jne    800f4d <fork+0x6a>
  800fd7:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  800fde:	f6 c4 08             	test   $0x8,%ah
  800fe1:	0f 85 66 ff ff ff    	jne    800f4d <fork+0x6a>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  800fe7:	c1 e6 0c             	shl    $0xc,%esi
  800fea:	83 ec 0c             	sub    $0xc,%esp
  800fed:	6a 05                	push   $0x5
  800fef:	56                   	push   %esi
  800ff0:	57                   	push   %edi
  800ff1:	56                   	push   %esi
  800ff2:	6a 00                	push   $0x0
  800ff4:	e8 86 fc ff ff       	call   800c7f <sys_page_map>
  800ff9:	83 c4 20             	add    $0x20,%esp
  800ffc:	85 c0                	test   %eax,%eax
  800ffe:	79 8b                	jns    800f8b <fork+0xa8>
		panic("duppage: %e\n", r);
  801000:	50                   	push   %eax
  801001:	68 f3 16 80 00       	push   $0x8016f3
  801006:	68 08 01 00 00       	push   $0x108
  80100b:	68 cb 16 80 00       	push   $0x8016cb
  801010:	e8 b9 00 00 00       	call   8010ce <_panic>
			panic("duppage: %e\n", r);
  801015:	50                   	push   %eax
  801016:	68 f3 16 80 00       	push   $0x8016f3
  80101b:	68 01 01 00 00       	push   $0x101
  801020:	68 cb 16 80 00       	push   $0x8016cb
  801025:	e8 a4 00 00 00       	call   8010ce <_panic>
			panic("duppage: %e\n", r);
  80102a:	50                   	push   %eax
  80102b:	68 f3 16 80 00       	push   $0x8016f3
  801030:	68 05 01 00 00       	push   $0x105
  801035:	68 cb 16 80 00       	push   $0x8016cb
  80103a:	e8 8f 00 00 00       	call   8010ce <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  80103f:	83 ec 04             	sub    $0x4,%esp
  801042:	6a 07                	push   $0x7
  801044:	68 00 f0 bf ee       	push   $0xeebff000
  801049:	ff 75 e4             	pushl  -0x1c(%ebp)
  80104c:	e8 e7 fb ff ff       	call   800c38 <sys_page_alloc>
  801051:	83 c4 10             	add    $0x10,%esp
  801054:	85 c0                	test   %eax,%eax
  801056:	78 2e                	js     801086 <fork+0x1a3>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801058:	83 ec 08             	sub    $0x8,%esp
  80105b:	68 8b 11 80 00       	push   $0x80118b
  801060:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801063:	57                   	push   %edi
  801064:	e8 e8 fc ff ff       	call   800d51 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801069:	83 c4 08             	add    $0x8,%esp
  80106c:	6a 02                	push   $0x2
  80106e:	57                   	push   %edi
  80106f:	e8 97 fc ff ff       	call   800d0b <sys_env_set_status>
  801074:	83 c4 10             	add    $0x10,%esp
  801077:	85 c0                	test   %eax,%eax
  801079:	78 20                	js     80109b <fork+0x1b8>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  80107b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80107e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801081:	5b                   	pop    %ebx
  801082:	5e                   	pop    %esi
  801083:	5f                   	pop    %edi
  801084:	5d                   	pop    %ebp
  801085:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  801086:	50                   	push   %eax
  801087:	68 00 17 80 00       	push   $0x801700
  80108c:	68 3a 01 00 00       	push   $0x13a
  801091:	68 cb 16 80 00       	push   $0x8016cb
  801096:	e8 33 00 00 00       	call   8010ce <_panic>
		panic("sys_env_set_status: %e", r);
  80109b:	50                   	push   %eax
  80109c:	68 13 17 80 00       	push   $0x801713
  8010a1:	68 3f 01 00 00       	push   $0x13f
  8010a6:	68 cb 16 80 00       	push   $0x8016cb
  8010ab:	e8 1e 00 00 00       	call   8010ce <_panic>

008010b0 <sfork>:

// Challenge!
int
sfork(void)
{
  8010b0:	f3 0f 1e fb          	endbr32 
  8010b4:	55                   	push   %ebp
  8010b5:	89 e5                	mov    %esp,%ebp
  8010b7:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8010ba:	68 2a 17 80 00       	push   $0x80172a
  8010bf:	68 48 01 00 00       	push   $0x148
  8010c4:	68 cb 16 80 00       	push   $0x8016cb
  8010c9:	e8 00 00 00 00       	call   8010ce <_panic>

008010ce <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8010ce:	f3 0f 1e fb          	endbr32 
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	56                   	push   %esi
  8010d6:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8010d7:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8010da:	8b 35 00 20 80 00    	mov    0x802000,%esi
  8010e0:	e8 0d fb ff ff       	call   800bf2 <sys_getenvid>
  8010e5:	83 ec 0c             	sub    $0xc,%esp
  8010e8:	ff 75 0c             	pushl  0xc(%ebp)
  8010eb:	ff 75 08             	pushl  0x8(%ebp)
  8010ee:	56                   	push   %esi
  8010ef:	50                   	push   %eax
  8010f0:	68 40 17 80 00       	push   $0x801740
  8010f5:	e8 f2 f0 ff ff       	call   8001ec <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8010fa:	83 c4 18             	add    $0x18,%esp
  8010fd:	53                   	push   %ebx
  8010fe:	ff 75 10             	pushl  0x10(%ebp)
  801101:	e8 91 f0 ff ff       	call   800197 <vcprintf>
	cprintf("\n");
  801106:	c7 04 24 2f 14 80 00 	movl   $0x80142f,(%esp)
  80110d:	e8 da f0 ff ff       	call   8001ec <cprintf>
  801112:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801115:	cc                   	int3   
  801116:	eb fd                	jmp    801115 <_panic+0x47>

00801118 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801118:	f3 0f 1e fb          	endbr32 
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
  80111f:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801122:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  801129:	74 0a                	je     801135 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
  80112e:	a3 08 20 80 00       	mov    %eax,0x802008
}
  801133:	c9                   	leave  
  801134:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  801135:	83 ec 04             	sub    $0x4,%esp
  801138:	6a 07                	push   $0x7
  80113a:	68 00 f0 bf ee       	push   $0xeebff000
  80113f:	6a 00                	push   $0x0
  801141:	e8 f2 fa ff ff       	call   800c38 <sys_page_alloc>
  801146:	83 c4 10             	add    $0x10,%esp
  801149:	85 c0                	test   %eax,%eax
  80114b:	78 2a                	js     801177 <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  80114d:	83 ec 08             	sub    $0x8,%esp
  801150:	68 8b 11 80 00       	push   $0x80118b
  801155:	6a 00                	push   $0x0
  801157:	e8 f5 fb ff ff       	call   800d51 <sys_env_set_pgfault_upcall>
  80115c:	83 c4 10             	add    $0x10,%esp
  80115f:	85 c0                	test   %eax,%eax
  801161:	79 c8                	jns    80112b <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  801163:	83 ec 04             	sub    $0x4,%esp
  801166:	68 90 17 80 00       	push   $0x801790
  80116b:	6a 25                	push   $0x25
  80116d:	68 c8 17 80 00       	push   $0x8017c8
  801172:	e8 57 ff ff ff       	call   8010ce <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  801177:	83 ec 04             	sub    $0x4,%esp
  80117a:	68 64 17 80 00       	push   $0x801764
  80117f:	6a 22                	push   $0x22
  801181:	68 c8 17 80 00       	push   $0x8017c8
  801186:	e8 43 ff ff ff       	call   8010ce <_panic>

0080118b <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80118b:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80118c:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  801191:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801193:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  801196:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  80119a:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  80119e:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8011a1:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  8011a3:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  8011a7:	83 c4 08             	add    $0x8,%esp
	popal
  8011aa:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  8011ab:	83 c4 04             	add    $0x4,%esp
	popfl
  8011ae:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  8011af:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  8011b0:	c3                   	ret    
  8011b1:	66 90                	xchg   %ax,%ax
  8011b3:	66 90                	xchg   %ax,%ax
  8011b5:	66 90                	xchg   %ax,%ax
  8011b7:	66 90                	xchg   %ax,%ax
  8011b9:	66 90                	xchg   %ax,%ax
  8011bb:	66 90                	xchg   %ax,%ax
  8011bd:	66 90                	xchg   %ax,%ax
  8011bf:	90                   	nop

008011c0 <__udivdi3>:
  8011c0:	f3 0f 1e fb          	endbr32 
  8011c4:	55                   	push   %ebp
  8011c5:	57                   	push   %edi
  8011c6:	56                   	push   %esi
  8011c7:	53                   	push   %ebx
  8011c8:	83 ec 1c             	sub    $0x1c,%esp
  8011cb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8011cf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8011d3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8011d7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8011db:	85 d2                	test   %edx,%edx
  8011dd:	75 19                	jne    8011f8 <__udivdi3+0x38>
  8011df:	39 f3                	cmp    %esi,%ebx
  8011e1:	76 4d                	jbe    801230 <__udivdi3+0x70>
  8011e3:	31 ff                	xor    %edi,%edi
  8011e5:	89 e8                	mov    %ebp,%eax
  8011e7:	89 f2                	mov    %esi,%edx
  8011e9:	f7 f3                	div    %ebx
  8011eb:	89 fa                	mov    %edi,%edx
  8011ed:	83 c4 1c             	add    $0x1c,%esp
  8011f0:	5b                   	pop    %ebx
  8011f1:	5e                   	pop    %esi
  8011f2:	5f                   	pop    %edi
  8011f3:	5d                   	pop    %ebp
  8011f4:	c3                   	ret    
  8011f5:	8d 76 00             	lea    0x0(%esi),%esi
  8011f8:	39 f2                	cmp    %esi,%edx
  8011fa:	76 14                	jbe    801210 <__udivdi3+0x50>
  8011fc:	31 ff                	xor    %edi,%edi
  8011fe:	31 c0                	xor    %eax,%eax
  801200:	89 fa                	mov    %edi,%edx
  801202:	83 c4 1c             	add    $0x1c,%esp
  801205:	5b                   	pop    %ebx
  801206:	5e                   	pop    %esi
  801207:	5f                   	pop    %edi
  801208:	5d                   	pop    %ebp
  801209:	c3                   	ret    
  80120a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801210:	0f bd fa             	bsr    %edx,%edi
  801213:	83 f7 1f             	xor    $0x1f,%edi
  801216:	75 48                	jne    801260 <__udivdi3+0xa0>
  801218:	39 f2                	cmp    %esi,%edx
  80121a:	72 06                	jb     801222 <__udivdi3+0x62>
  80121c:	31 c0                	xor    %eax,%eax
  80121e:	39 eb                	cmp    %ebp,%ebx
  801220:	77 de                	ja     801200 <__udivdi3+0x40>
  801222:	b8 01 00 00 00       	mov    $0x1,%eax
  801227:	eb d7                	jmp    801200 <__udivdi3+0x40>
  801229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801230:	89 d9                	mov    %ebx,%ecx
  801232:	85 db                	test   %ebx,%ebx
  801234:	75 0b                	jne    801241 <__udivdi3+0x81>
  801236:	b8 01 00 00 00       	mov    $0x1,%eax
  80123b:	31 d2                	xor    %edx,%edx
  80123d:	f7 f3                	div    %ebx
  80123f:	89 c1                	mov    %eax,%ecx
  801241:	31 d2                	xor    %edx,%edx
  801243:	89 f0                	mov    %esi,%eax
  801245:	f7 f1                	div    %ecx
  801247:	89 c6                	mov    %eax,%esi
  801249:	89 e8                	mov    %ebp,%eax
  80124b:	89 f7                	mov    %esi,%edi
  80124d:	f7 f1                	div    %ecx
  80124f:	89 fa                	mov    %edi,%edx
  801251:	83 c4 1c             	add    $0x1c,%esp
  801254:	5b                   	pop    %ebx
  801255:	5e                   	pop    %esi
  801256:	5f                   	pop    %edi
  801257:	5d                   	pop    %ebp
  801258:	c3                   	ret    
  801259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801260:	89 f9                	mov    %edi,%ecx
  801262:	b8 20 00 00 00       	mov    $0x20,%eax
  801267:	29 f8                	sub    %edi,%eax
  801269:	d3 e2                	shl    %cl,%edx
  80126b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80126f:	89 c1                	mov    %eax,%ecx
  801271:	89 da                	mov    %ebx,%edx
  801273:	d3 ea                	shr    %cl,%edx
  801275:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801279:	09 d1                	or     %edx,%ecx
  80127b:	89 f2                	mov    %esi,%edx
  80127d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801281:	89 f9                	mov    %edi,%ecx
  801283:	d3 e3                	shl    %cl,%ebx
  801285:	89 c1                	mov    %eax,%ecx
  801287:	d3 ea                	shr    %cl,%edx
  801289:	89 f9                	mov    %edi,%ecx
  80128b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80128f:	89 eb                	mov    %ebp,%ebx
  801291:	d3 e6                	shl    %cl,%esi
  801293:	89 c1                	mov    %eax,%ecx
  801295:	d3 eb                	shr    %cl,%ebx
  801297:	09 de                	or     %ebx,%esi
  801299:	89 f0                	mov    %esi,%eax
  80129b:	f7 74 24 08          	divl   0x8(%esp)
  80129f:	89 d6                	mov    %edx,%esi
  8012a1:	89 c3                	mov    %eax,%ebx
  8012a3:	f7 64 24 0c          	mull   0xc(%esp)
  8012a7:	39 d6                	cmp    %edx,%esi
  8012a9:	72 15                	jb     8012c0 <__udivdi3+0x100>
  8012ab:	89 f9                	mov    %edi,%ecx
  8012ad:	d3 e5                	shl    %cl,%ebp
  8012af:	39 c5                	cmp    %eax,%ebp
  8012b1:	73 04                	jae    8012b7 <__udivdi3+0xf7>
  8012b3:	39 d6                	cmp    %edx,%esi
  8012b5:	74 09                	je     8012c0 <__udivdi3+0x100>
  8012b7:	89 d8                	mov    %ebx,%eax
  8012b9:	31 ff                	xor    %edi,%edi
  8012bb:	e9 40 ff ff ff       	jmp    801200 <__udivdi3+0x40>
  8012c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8012c3:	31 ff                	xor    %edi,%edi
  8012c5:	e9 36 ff ff ff       	jmp    801200 <__udivdi3+0x40>
  8012ca:	66 90                	xchg   %ax,%ax
  8012cc:	66 90                	xchg   %ax,%ax
  8012ce:	66 90                	xchg   %ax,%ax

008012d0 <__umoddi3>:
  8012d0:	f3 0f 1e fb          	endbr32 
  8012d4:	55                   	push   %ebp
  8012d5:	57                   	push   %edi
  8012d6:	56                   	push   %esi
  8012d7:	53                   	push   %ebx
  8012d8:	83 ec 1c             	sub    $0x1c,%esp
  8012db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8012df:	8b 74 24 30          	mov    0x30(%esp),%esi
  8012e3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8012e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8012eb:	85 c0                	test   %eax,%eax
  8012ed:	75 19                	jne    801308 <__umoddi3+0x38>
  8012ef:	39 df                	cmp    %ebx,%edi
  8012f1:	76 5d                	jbe    801350 <__umoddi3+0x80>
  8012f3:	89 f0                	mov    %esi,%eax
  8012f5:	89 da                	mov    %ebx,%edx
  8012f7:	f7 f7                	div    %edi
  8012f9:	89 d0                	mov    %edx,%eax
  8012fb:	31 d2                	xor    %edx,%edx
  8012fd:	83 c4 1c             	add    $0x1c,%esp
  801300:	5b                   	pop    %ebx
  801301:	5e                   	pop    %esi
  801302:	5f                   	pop    %edi
  801303:	5d                   	pop    %ebp
  801304:	c3                   	ret    
  801305:	8d 76 00             	lea    0x0(%esi),%esi
  801308:	89 f2                	mov    %esi,%edx
  80130a:	39 d8                	cmp    %ebx,%eax
  80130c:	76 12                	jbe    801320 <__umoddi3+0x50>
  80130e:	89 f0                	mov    %esi,%eax
  801310:	89 da                	mov    %ebx,%edx
  801312:	83 c4 1c             	add    $0x1c,%esp
  801315:	5b                   	pop    %ebx
  801316:	5e                   	pop    %esi
  801317:	5f                   	pop    %edi
  801318:	5d                   	pop    %ebp
  801319:	c3                   	ret    
  80131a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801320:	0f bd e8             	bsr    %eax,%ebp
  801323:	83 f5 1f             	xor    $0x1f,%ebp
  801326:	75 50                	jne    801378 <__umoddi3+0xa8>
  801328:	39 d8                	cmp    %ebx,%eax
  80132a:	0f 82 e0 00 00 00    	jb     801410 <__umoddi3+0x140>
  801330:	89 d9                	mov    %ebx,%ecx
  801332:	39 f7                	cmp    %esi,%edi
  801334:	0f 86 d6 00 00 00    	jbe    801410 <__umoddi3+0x140>
  80133a:	89 d0                	mov    %edx,%eax
  80133c:	89 ca                	mov    %ecx,%edx
  80133e:	83 c4 1c             	add    $0x1c,%esp
  801341:	5b                   	pop    %ebx
  801342:	5e                   	pop    %esi
  801343:	5f                   	pop    %edi
  801344:	5d                   	pop    %ebp
  801345:	c3                   	ret    
  801346:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80134d:	8d 76 00             	lea    0x0(%esi),%esi
  801350:	89 fd                	mov    %edi,%ebp
  801352:	85 ff                	test   %edi,%edi
  801354:	75 0b                	jne    801361 <__umoddi3+0x91>
  801356:	b8 01 00 00 00       	mov    $0x1,%eax
  80135b:	31 d2                	xor    %edx,%edx
  80135d:	f7 f7                	div    %edi
  80135f:	89 c5                	mov    %eax,%ebp
  801361:	89 d8                	mov    %ebx,%eax
  801363:	31 d2                	xor    %edx,%edx
  801365:	f7 f5                	div    %ebp
  801367:	89 f0                	mov    %esi,%eax
  801369:	f7 f5                	div    %ebp
  80136b:	89 d0                	mov    %edx,%eax
  80136d:	31 d2                	xor    %edx,%edx
  80136f:	eb 8c                	jmp    8012fd <__umoddi3+0x2d>
  801371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801378:	89 e9                	mov    %ebp,%ecx
  80137a:	ba 20 00 00 00       	mov    $0x20,%edx
  80137f:	29 ea                	sub    %ebp,%edx
  801381:	d3 e0                	shl    %cl,%eax
  801383:	89 44 24 08          	mov    %eax,0x8(%esp)
  801387:	89 d1                	mov    %edx,%ecx
  801389:	89 f8                	mov    %edi,%eax
  80138b:	d3 e8                	shr    %cl,%eax
  80138d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801391:	89 54 24 04          	mov    %edx,0x4(%esp)
  801395:	8b 54 24 04          	mov    0x4(%esp),%edx
  801399:	09 c1                	or     %eax,%ecx
  80139b:	89 d8                	mov    %ebx,%eax
  80139d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013a1:	89 e9                	mov    %ebp,%ecx
  8013a3:	d3 e7                	shl    %cl,%edi
  8013a5:	89 d1                	mov    %edx,%ecx
  8013a7:	d3 e8                	shr    %cl,%eax
  8013a9:	89 e9                	mov    %ebp,%ecx
  8013ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8013af:	d3 e3                	shl    %cl,%ebx
  8013b1:	89 c7                	mov    %eax,%edi
  8013b3:	89 d1                	mov    %edx,%ecx
  8013b5:	89 f0                	mov    %esi,%eax
  8013b7:	d3 e8                	shr    %cl,%eax
  8013b9:	89 e9                	mov    %ebp,%ecx
  8013bb:	89 fa                	mov    %edi,%edx
  8013bd:	d3 e6                	shl    %cl,%esi
  8013bf:	09 d8                	or     %ebx,%eax
  8013c1:	f7 74 24 08          	divl   0x8(%esp)
  8013c5:	89 d1                	mov    %edx,%ecx
  8013c7:	89 f3                	mov    %esi,%ebx
  8013c9:	f7 64 24 0c          	mull   0xc(%esp)
  8013cd:	89 c6                	mov    %eax,%esi
  8013cf:	89 d7                	mov    %edx,%edi
  8013d1:	39 d1                	cmp    %edx,%ecx
  8013d3:	72 06                	jb     8013db <__umoddi3+0x10b>
  8013d5:	75 10                	jne    8013e7 <__umoddi3+0x117>
  8013d7:	39 c3                	cmp    %eax,%ebx
  8013d9:	73 0c                	jae    8013e7 <__umoddi3+0x117>
  8013db:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8013df:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8013e3:	89 d7                	mov    %edx,%edi
  8013e5:	89 c6                	mov    %eax,%esi
  8013e7:	89 ca                	mov    %ecx,%edx
  8013e9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8013ee:	29 f3                	sub    %esi,%ebx
  8013f0:	19 fa                	sbb    %edi,%edx
  8013f2:	89 d0                	mov    %edx,%eax
  8013f4:	d3 e0                	shl    %cl,%eax
  8013f6:	89 e9                	mov    %ebp,%ecx
  8013f8:	d3 eb                	shr    %cl,%ebx
  8013fa:	d3 ea                	shr    %cl,%edx
  8013fc:	09 d8                	or     %ebx,%eax
  8013fe:	83 c4 1c             	add    $0x1c,%esp
  801401:	5b                   	pop    %ebx
  801402:	5e                   	pop    %esi
  801403:	5f                   	pop    %edi
  801404:	5d                   	pop    %ebp
  801405:	c3                   	ret    
  801406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80140d:	8d 76 00             	lea    0x0(%esi),%esi
  801410:	29 fe                	sub    %edi,%esi
  801412:	19 c3                	sbb    %eax,%ebx
  801414:	89 f2                	mov    %esi,%edx
  801416:	89 d9                	mov    %ebx,%ecx
  801418:	e9 1d ff ff ff       	jmp    80133a <__umoddi3+0x6a>
