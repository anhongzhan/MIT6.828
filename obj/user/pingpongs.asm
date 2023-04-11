
obj/user/pingpongs:     file format elf32-i386


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
  80002c:	e8 d6 00 00 00       	call   800107 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t val;

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	57                   	push   %edi
  80003b:	56                   	push   %esi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 2c             	sub    $0x2c,%esp
	envid_t who;
	uint32_t i;

	i = 0;
	if ((who = sfork()) != 0) {
  800040:	e8 83 10 00 00       	call   8010c8 <sfork>
  800045:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800048:	85 c0                	test   %eax,%eax
  80004a:	75 74                	jne    8000c0 <umain+0x8d>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		ipc_recv(&who, 0, 0);
  80004c:	83 ec 04             	sub    $0x4,%esp
  80004f:	6a 00                	push   $0x0
  800051:	6a 00                	push   $0x0
  800053:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800056:	50                   	push   %eax
  800057:	e8 8a 10 00 00       	call   8010e6 <ipc_recv>
		cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  80005c:	8b 1d 08 20 80 00    	mov    0x802008,%ebx
  800062:	8b 7b 48             	mov    0x48(%ebx),%edi
  800065:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800068:	a1 04 20 80 00       	mov    0x802004,%eax
  80006d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800070:	e8 95 0b 00 00       	call   800c0a <sys_getenvid>
  800075:	83 c4 08             	add    $0x8,%esp
  800078:	57                   	push   %edi
  800079:	53                   	push   %ebx
  80007a:	56                   	push   %esi
  80007b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80007e:	50                   	push   %eax
  80007f:	68 90 15 80 00       	push   $0x801590
  800084:	e8 7b 01 00 00       	call   800204 <cprintf>
		if (val == 10)
  800089:	a1 04 20 80 00       	mov    0x802004,%eax
  80008e:	83 c4 20             	add    $0x20,%esp
  800091:	83 f8 0a             	cmp    $0xa,%eax
  800094:	74 22                	je     8000b8 <umain+0x85>
			return;
		++val;
  800096:	83 c0 01             	add    $0x1,%eax
  800099:	a3 04 20 80 00       	mov    %eax,0x802004
		ipc_send(who, 0, 0, 0);
  80009e:	6a 00                	push   $0x0
  8000a0:	6a 00                	push   $0x0
  8000a2:	6a 00                	push   $0x0
  8000a4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000a7:	e8 bf 10 00 00       	call   80116b <ipc_send>
		if (val == 10)
  8000ac:	83 c4 10             	add    $0x10,%esp
  8000af:	83 3d 04 20 80 00 0a 	cmpl   $0xa,0x802004
  8000b6:	75 94                	jne    80004c <umain+0x19>
			return;
	}

}
  8000b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000bb:	5b                   	pop    %ebx
  8000bc:	5e                   	pop    %esi
  8000bd:	5f                   	pop    %edi
  8000be:	5d                   	pop    %ebp
  8000bf:	c3                   	ret    
		cprintf("i am %08x; thisenv is %p\n", sys_getenvid(), thisenv);
  8000c0:	8b 1d 08 20 80 00    	mov    0x802008,%ebx
  8000c6:	e8 3f 0b 00 00       	call   800c0a <sys_getenvid>
  8000cb:	83 ec 04             	sub    $0x4,%esp
  8000ce:	53                   	push   %ebx
  8000cf:	50                   	push   %eax
  8000d0:	68 60 15 80 00       	push   $0x801560
  8000d5:	e8 2a 01 00 00       	call   800204 <cprintf>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  8000da:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8000dd:	e8 28 0b 00 00       	call   800c0a <sys_getenvid>
  8000e2:	83 c4 0c             	add    $0xc,%esp
  8000e5:	53                   	push   %ebx
  8000e6:	50                   	push   %eax
  8000e7:	68 7a 15 80 00       	push   $0x80157a
  8000ec:	e8 13 01 00 00       	call   800204 <cprintf>
		ipc_send(who, 0, 0, 0);
  8000f1:	6a 00                	push   $0x0
  8000f3:	6a 00                	push   $0x0
  8000f5:	6a 00                	push   $0x0
  8000f7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000fa:	e8 6c 10 00 00       	call   80116b <ipc_send>
  8000ff:	83 c4 20             	add    $0x20,%esp
  800102:	e9 45 ff ff ff       	jmp    80004c <umain+0x19>

00800107 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800107:	f3 0f 1e fb          	endbr32 
  80010b:	55                   	push   %ebp
  80010c:	89 e5                	mov    %esp,%ebp
  80010e:	56                   	push   %esi
  80010f:	53                   	push   %ebx
  800110:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800113:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800116:	e8 ef 0a 00 00       	call   800c0a <sys_getenvid>
  80011b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800120:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800123:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800128:	a3 08 20 80 00       	mov    %eax,0x802008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80012d:	85 db                	test   %ebx,%ebx
  80012f:	7e 07                	jle    800138 <libmain+0x31>
		binaryname = argv[0];
  800131:	8b 06                	mov    (%esi),%eax
  800133:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800138:	83 ec 08             	sub    $0x8,%esp
  80013b:	56                   	push   %esi
  80013c:	53                   	push   %ebx
  80013d:	e8 f1 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800142:	e8 0a 00 00 00       	call   800151 <exit>
}
  800147:	83 c4 10             	add    $0x10,%esp
  80014a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80014d:	5b                   	pop    %ebx
  80014e:	5e                   	pop    %esi
  80014f:	5d                   	pop    %ebp
  800150:	c3                   	ret    

00800151 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800151:	f3 0f 1e fb          	endbr32 
  800155:	55                   	push   %ebp
  800156:	89 e5                	mov    %esp,%ebp
  800158:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  80015b:	6a 00                	push   $0x0
  80015d:	e8 63 0a 00 00       	call   800bc5 <sys_env_destroy>
}
  800162:	83 c4 10             	add    $0x10,%esp
  800165:	c9                   	leave  
  800166:	c3                   	ret    

00800167 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800167:	f3 0f 1e fb          	endbr32 
  80016b:	55                   	push   %ebp
  80016c:	89 e5                	mov    %esp,%ebp
  80016e:	53                   	push   %ebx
  80016f:	83 ec 04             	sub    $0x4,%esp
  800172:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800175:	8b 13                	mov    (%ebx),%edx
  800177:	8d 42 01             	lea    0x1(%edx),%eax
  80017a:	89 03                	mov    %eax,(%ebx)
  80017c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80017f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800183:	3d ff 00 00 00       	cmp    $0xff,%eax
  800188:	74 09                	je     800193 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80018a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80018e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800191:	c9                   	leave  
  800192:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800193:	83 ec 08             	sub    $0x8,%esp
  800196:	68 ff 00 00 00       	push   $0xff
  80019b:	8d 43 08             	lea    0x8(%ebx),%eax
  80019e:	50                   	push   %eax
  80019f:	e8 dc 09 00 00       	call   800b80 <sys_cputs>
		b->idx = 0;
  8001a4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001aa:	83 c4 10             	add    $0x10,%esp
  8001ad:	eb db                	jmp    80018a <putch+0x23>

008001af <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001af:	f3 0f 1e fb          	endbr32 
  8001b3:	55                   	push   %ebp
  8001b4:	89 e5                	mov    %esp,%ebp
  8001b6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001bc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001c3:	00 00 00 
	b.cnt = 0;
  8001c6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001cd:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001d0:	ff 75 0c             	pushl  0xc(%ebp)
  8001d3:	ff 75 08             	pushl  0x8(%ebp)
  8001d6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001dc:	50                   	push   %eax
  8001dd:	68 67 01 80 00       	push   $0x800167
  8001e2:	e8 20 01 00 00       	call   800307 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001e7:	83 c4 08             	add    $0x8,%esp
  8001ea:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001f0:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001f6:	50                   	push   %eax
  8001f7:	e8 84 09 00 00       	call   800b80 <sys_cputs>

	return b.cnt;
}
  8001fc:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800202:	c9                   	leave  
  800203:	c3                   	ret    

00800204 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800204:	f3 0f 1e fb          	endbr32 
  800208:	55                   	push   %ebp
  800209:	89 e5                	mov    %esp,%ebp
  80020b:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80020e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800211:	50                   	push   %eax
  800212:	ff 75 08             	pushl  0x8(%ebp)
  800215:	e8 95 ff ff ff       	call   8001af <vcprintf>
	va_end(ap);

	return cnt;
}
  80021a:	c9                   	leave  
  80021b:	c3                   	ret    

0080021c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80021c:	55                   	push   %ebp
  80021d:	89 e5                	mov    %esp,%ebp
  80021f:	57                   	push   %edi
  800220:	56                   	push   %esi
  800221:	53                   	push   %ebx
  800222:	83 ec 1c             	sub    $0x1c,%esp
  800225:	89 c7                	mov    %eax,%edi
  800227:	89 d6                	mov    %edx,%esi
  800229:	8b 45 08             	mov    0x8(%ebp),%eax
  80022c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80022f:	89 d1                	mov    %edx,%ecx
  800231:	89 c2                	mov    %eax,%edx
  800233:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800236:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800239:	8b 45 10             	mov    0x10(%ebp),%eax
  80023c:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80023f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800242:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800249:	39 c2                	cmp    %eax,%edx
  80024b:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80024e:	72 3e                	jb     80028e <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800250:	83 ec 0c             	sub    $0xc,%esp
  800253:	ff 75 18             	pushl  0x18(%ebp)
  800256:	83 eb 01             	sub    $0x1,%ebx
  800259:	53                   	push   %ebx
  80025a:	50                   	push   %eax
  80025b:	83 ec 08             	sub    $0x8,%esp
  80025e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800261:	ff 75 e0             	pushl  -0x20(%ebp)
  800264:	ff 75 dc             	pushl  -0x24(%ebp)
  800267:	ff 75 d8             	pushl  -0x28(%ebp)
  80026a:	e8 81 10 00 00       	call   8012f0 <__udivdi3>
  80026f:	83 c4 18             	add    $0x18,%esp
  800272:	52                   	push   %edx
  800273:	50                   	push   %eax
  800274:	89 f2                	mov    %esi,%edx
  800276:	89 f8                	mov    %edi,%eax
  800278:	e8 9f ff ff ff       	call   80021c <printnum>
  80027d:	83 c4 20             	add    $0x20,%esp
  800280:	eb 13                	jmp    800295 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800282:	83 ec 08             	sub    $0x8,%esp
  800285:	56                   	push   %esi
  800286:	ff 75 18             	pushl  0x18(%ebp)
  800289:	ff d7                	call   *%edi
  80028b:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80028e:	83 eb 01             	sub    $0x1,%ebx
  800291:	85 db                	test   %ebx,%ebx
  800293:	7f ed                	jg     800282 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800295:	83 ec 08             	sub    $0x8,%esp
  800298:	56                   	push   %esi
  800299:	83 ec 04             	sub    $0x4,%esp
  80029c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80029f:	ff 75 e0             	pushl  -0x20(%ebp)
  8002a2:	ff 75 dc             	pushl  -0x24(%ebp)
  8002a5:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a8:	e8 53 11 00 00       	call   801400 <__umoddi3>
  8002ad:	83 c4 14             	add    $0x14,%esp
  8002b0:	0f be 80 c0 15 80 00 	movsbl 0x8015c0(%eax),%eax
  8002b7:	50                   	push   %eax
  8002b8:	ff d7                	call   *%edi
}
  8002ba:	83 c4 10             	add    $0x10,%esp
  8002bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c0:	5b                   	pop    %ebx
  8002c1:	5e                   	pop    %esi
  8002c2:	5f                   	pop    %edi
  8002c3:	5d                   	pop    %ebp
  8002c4:	c3                   	ret    

008002c5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002c5:	f3 0f 1e fb          	endbr32 
  8002c9:	55                   	push   %ebp
  8002ca:	89 e5                	mov    %esp,%ebp
  8002cc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002cf:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002d3:	8b 10                	mov    (%eax),%edx
  8002d5:	3b 50 04             	cmp    0x4(%eax),%edx
  8002d8:	73 0a                	jae    8002e4 <sprintputch+0x1f>
		*b->buf++ = ch;
  8002da:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002dd:	89 08                	mov    %ecx,(%eax)
  8002df:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e2:	88 02                	mov    %al,(%edx)
}
  8002e4:	5d                   	pop    %ebp
  8002e5:	c3                   	ret    

008002e6 <printfmt>:
{
  8002e6:	f3 0f 1e fb          	endbr32 
  8002ea:	55                   	push   %ebp
  8002eb:	89 e5                	mov    %esp,%ebp
  8002ed:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002f0:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002f3:	50                   	push   %eax
  8002f4:	ff 75 10             	pushl  0x10(%ebp)
  8002f7:	ff 75 0c             	pushl  0xc(%ebp)
  8002fa:	ff 75 08             	pushl  0x8(%ebp)
  8002fd:	e8 05 00 00 00       	call   800307 <vprintfmt>
}
  800302:	83 c4 10             	add    $0x10,%esp
  800305:	c9                   	leave  
  800306:	c3                   	ret    

00800307 <vprintfmt>:
{
  800307:	f3 0f 1e fb          	endbr32 
  80030b:	55                   	push   %ebp
  80030c:	89 e5                	mov    %esp,%ebp
  80030e:	57                   	push   %edi
  80030f:	56                   	push   %esi
  800310:	53                   	push   %ebx
  800311:	83 ec 3c             	sub    $0x3c,%esp
  800314:	8b 75 08             	mov    0x8(%ebp),%esi
  800317:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80031a:	8b 7d 10             	mov    0x10(%ebp),%edi
  80031d:	e9 8e 03 00 00       	jmp    8006b0 <vprintfmt+0x3a9>
		padc = ' ';
  800322:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800326:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80032d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800334:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80033b:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800340:	8d 47 01             	lea    0x1(%edi),%eax
  800343:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800346:	0f b6 17             	movzbl (%edi),%edx
  800349:	8d 42 dd             	lea    -0x23(%edx),%eax
  80034c:	3c 55                	cmp    $0x55,%al
  80034e:	0f 87 df 03 00 00    	ja     800733 <vprintfmt+0x42c>
  800354:	0f b6 c0             	movzbl %al,%eax
  800357:	3e ff 24 85 80 16 80 	notrack jmp *0x801680(,%eax,4)
  80035e:	00 
  80035f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800362:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800366:	eb d8                	jmp    800340 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800368:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80036b:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80036f:	eb cf                	jmp    800340 <vprintfmt+0x39>
  800371:	0f b6 d2             	movzbl %dl,%edx
  800374:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800377:	b8 00 00 00 00       	mov    $0x0,%eax
  80037c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80037f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800382:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800386:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800389:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80038c:	83 f9 09             	cmp    $0x9,%ecx
  80038f:	77 55                	ja     8003e6 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800391:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800394:	eb e9                	jmp    80037f <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800396:	8b 45 14             	mov    0x14(%ebp),%eax
  800399:	8b 00                	mov    (%eax),%eax
  80039b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80039e:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a1:	8d 40 04             	lea    0x4(%eax),%eax
  8003a4:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003aa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003ae:	79 90                	jns    800340 <vprintfmt+0x39>
				width = precision, precision = -1;
  8003b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003b6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003bd:	eb 81                	jmp    800340 <vprintfmt+0x39>
  8003bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003c2:	85 c0                	test   %eax,%eax
  8003c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c9:	0f 49 d0             	cmovns %eax,%edx
  8003cc:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003d2:	e9 69 ff ff ff       	jmp    800340 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003da:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003e1:	e9 5a ff ff ff       	jmp    800340 <vprintfmt+0x39>
  8003e6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003ec:	eb bc                	jmp    8003aa <vprintfmt+0xa3>
			lflag++;
  8003ee:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003f4:	e9 47 ff ff ff       	jmp    800340 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8003f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fc:	8d 78 04             	lea    0x4(%eax),%edi
  8003ff:	83 ec 08             	sub    $0x8,%esp
  800402:	53                   	push   %ebx
  800403:	ff 30                	pushl  (%eax)
  800405:	ff d6                	call   *%esi
			break;
  800407:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80040a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80040d:	e9 9b 02 00 00       	jmp    8006ad <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800412:	8b 45 14             	mov    0x14(%ebp),%eax
  800415:	8d 78 04             	lea    0x4(%eax),%edi
  800418:	8b 00                	mov    (%eax),%eax
  80041a:	99                   	cltd   
  80041b:	31 d0                	xor    %edx,%eax
  80041d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80041f:	83 f8 08             	cmp    $0x8,%eax
  800422:	7f 23                	jg     800447 <vprintfmt+0x140>
  800424:	8b 14 85 e0 17 80 00 	mov    0x8017e0(,%eax,4),%edx
  80042b:	85 d2                	test   %edx,%edx
  80042d:	74 18                	je     800447 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80042f:	52                   	push   %edx
  800430:	68 e1 15 80 00       	push   $0x8015e1
  800435:	53                   	push   %ebx
  800436:	56                   	push   %esi
  800437:	e8 aa fe ff ff       	call   8002e6 <printfmt>
  80043c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80043f:	89 7d 14             	mov    %edi,0x14(%ebp)
  800442:	e9 66 02 00 00       	jmp    8006ad <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800447:	50                   	push   %eax
  800448:	68 d8 15 80 00       	push   $0x8015d8
  80044d:	53                   	push   %ebx
  80044e:	56                   	push   %esi
  80044f:	e8 92 fe ff ff       	call   8002e6 <printfmt>
  800454:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800457:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80045a:	e9 4e 02 00 00       	jmp    8006ad <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  80045f:	8b 45 14             	mov    0x14(%ebp),%eax
  800462:	83 c0 04             	add    $0x4,%eax
  800465:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800468:	8b 45 14             	mov    0x14(%ebp),%eax
  80046b:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80046d:	85 d2                	test   %edx,%edx
  80046f:	b8 d1 15 80 00       	mov    $0x8015d1,%eax
  800474:	0f 45 c2             	cmovne %edx,%eax
  800477:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80047a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80047e:	7e 06                	jle    800486 <vprintfmt+0x17f>
  800480:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800484:	75 0d                	jne    800493 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  800486:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800489:	89 c7                	mov    %eax,%edi
  80048b:	03 45 e0             	add    -0x20(%ebp),%eax
  80048e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800491:	eb 55                	jmp    8004e8 <vprintfmt+0x1e1>
  800493:	83 ec 08             	sub    $0x8,%esp
  800496:	ff 75 d8             	pushl  -0x28(%ebp)
  800499:	ff 75 cc             	pushl  -0x34(%ebp)
  80049c:	e8 46 03 00 00       	call   8007e7 <strnlen>
  8004a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004a4:	29 c2                	sub    %eax,%edx
  8004a6:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004a9:	83 c4 10             	add    $0x10,%esp
  8004ac:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004ae:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b5:	85 ff                	test   %edi,%edi
  8004b7:	7e 11                	jle    8004ca <vprintfmt+0x1c3>
					putch(padc, putdat);
  8004b9:	83 ec 08             	sub    $0x8,%esp
  8004bc:	53                   	push   %ebx
  8004bd:	ff 75 e0             	pushl  -0x20(%ebp)
  8004c0:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c2:	83 ef 01             	sub    $0x1,%edi
  8004c5:	83 c4 10             	add    $0x10,%esp
  8004c8:	eb eb                	jmp    8004b5 <vprintfmt+0x1ae>
  8004ca:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004cd:	85 d2                	test   %edx,%edx
  8004cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d4:	0f 49 c2             	cmovns %edx,%eax
  8004d7:	29 c2                	sub    %eax,%edx
  8004d9:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004dc:	eb a8                	jmp    800486 <vprintfmt+0x17f>
					putch(ch, putdat);
  8004de:	83 ec 08             	sub    $0x8,%esp
  8004e1:	53                   	push   %ebx
  8004e2:	52                   	push   %edx
  8004e3:	ff d6                	call   *%esi
  8004e5:	83 c4 10             	add    $0x10,%esp
  8004e8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004eb:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004ed:	83 c7 01             	add    $0x1,%edi
  8004f0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004f4:	0f be d0             	movsbl %al,%edx
  8004f7:	85 d2                	test   %edx,%edx
  8004f9:	74 4b                	je     800546 <vprintfmt+0x23f>
  8004fb:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004ff:	78 06                	js     800507 <vprintfmt+0x200>
  800501:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800505:	78 1e                	js     800525 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800507:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80050b:	74 d1                	je     8004de <vprintfmt+0x1d7>
  80050d:	0f be c0             	movsbl %al,%eax
  800510:	83 e8 20             	sub    $0x20,%eax
  800513:	83 f8 5e             	cmp    $0x5e,%eax
  800516:	76 c6                	jbe    8004de <vprintfmt+0x1d7>
					putch('?', putdat);
  800518:	83 ec 08             	sub    $0x8,%esp
  80051b:	53                   	push   %ebx
  80051c:	6a 3f                	push   $0x3f
  80051e:	ff d6                	call   *%esi
  800520:	83 c4 10             	add    $0x10,%esp
  800523:	eb c3                	jmp    8004e8 <vprintfmt+0x1e1>
  800525:	89 cf                	mov    %ecx,%edi
  800527:	eb 0e                	jmp    800537 <vprintfmt+0x230>
				putch(' ', putdat);
  800529:	83 ec 08             	sub    $0x8,%esp
  80052c:	53                   	push   %ebx
  80052d:	6a 20                	push   $0x20
  80052f:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800531:	83 ef 01             	sub    $0x1,%edi
  800534:	83 c4 10             	add    $0x10,%esp
  800537:	85 ff                	test   %edi,%edi
  800539:	7f ee                	jg     800529 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  80053b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80053e:	89 45 14             	mov    %eax,0x14(%ebp)
  800541:	e9 67 01 00 00       	jmp    8006ad <vprintfmt+0x3a6>
  800546:	89 cf                	mov    %ecx,%edi
  800548:	eb ed                	jmp    800537 <vprintfmt+0x230>
	if (lflag >= 2)
  80054a:	83 f9 01             	cmp    $0x1,%ecx
  80054d:	7f 1b                	jg     80056a <vprintfmt+0x263>
	else if (lflag)
  80054f:	85 c9                	test   %ecx,%ecx
  800551:	74 63                	je     8005b6 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800553:	8b 45 14             	mov    0x14(%ebp),%eax
  800556:	8b 00                	mov    (%eax),%eax
  800558:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80055b:	99                   	cltd   
  80055c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80055f:	8b 45 14             	mov    0x14(%ebp),%eax
  800562:	8d 40 04             	lea    0x4(%eax),%eax
  800565:	89 45 14             	mov    %eax,0x14(%ebp)
  800568:	eb 17                	jmp    800581 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  80056a:	8b 45 14             	mov    0x14(%ebp),%eax
  80056d:	8b 50 04             	mov    0x4(%eax),%edx
  800570:	8b 00                	mov    (%eax),%eax
  800572:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800575:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800578:	8b 45 14             	mov    0x14(%ebp),%eax
  80057b:	8d 40 08             	lea    0x8(%eax),%eax
  80057e:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800581:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800584:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800587:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80058c:	85 c9                	test   %ecx,%ecx
  80058e:	0f 89 ff 00 00 00    	jns    800693 <vprintfmt+0x38c>
				putch('-', putdat);
  800594:	83 ec 08             	sub    $0x8,%esp
  800597:	53                   	push   %ebx
  800598:	6a 2d                	push   $0x2d
  80059a:	ff d6                	call   *%esi
				num = -(long long) num;
  80059c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80059f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005a2:	f7 da                	neg    %edx
  8005a4:	83 d1 00             	adc    $0x0,%ecx
  8005a7:	f7 d9                	neg    %ecx
  8005a9:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005ac:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005b1:	e9 dd 00 00 00       	jmp    800693 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8005b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b9:	8b 00                	mov    (%eax),%eax
  8005bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005be:	99                   	cltd   
  8005bf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c5:	8d 40 04             	lea    0x4(%eax),%eax
  8005c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005cb:	eb b4                	jmp    800581 <vprintfmt+0x27a>
	if (lflag >= 2)
  8005cd:	83 f9 01             	cmp    $0x1,%ecx
  8005d0:	7f 1e                	jg     8005f0 <vprintfmt+0x2e9>
	else if (lflag)
  8005d2:	85 c9                	test   %ecx,%ecx
  8005d4:	74 32                	je     800608 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8005d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d9:	8b 10                	mov    (%eax),%edx
  8005db:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005e0:	8d 40 04             	lea    0x4(%eax),%eax
  8005e3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005e6:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8005eb:	e9 a3 00 00 00       	jmp    800693 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f3:	8b 10                	mov    (%eax),%edx
  8005f5:	8b 48 04             	mov    0x4(%eax),%ecx
  8005f8:	8d 40 08             	lea    0x8(%eax),%eax
  8005fb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005fe:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800603:	e9 8b 00 00 00       	jmp    800693 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800608:	8b 45 14             	mov    0x14(%ebp),%eax
  80060b:	8b 10                	mov    (%eax),%edx
  80060d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800612:	8d 40 04             	lea    0x4(%eax),%eax
  800615:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800618:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  80061d:	eb 74                	jmp    800693 <vprintfmt+0x38c>
	if (lflag >= 2)
  80061f:	83 f9 01             	cmp    $0x1,%ecx
  800622:	7f 1b                	jg     80063f <vprintfmt+0x338>
	else if (lflag)
  800624:	85 c9                	test   %ecx,%ecx
  800626:	74 2c                	je     800654 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800628:	8b 45 14             	mov    0x14(%ebp),%eax
  80062b:	8b 10                	mov    (%eax),%edx
  80062d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800632:	8d 40 04             	lea    0x4(%eax),%eax
  800635:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800638:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  80063d:	eb 54                	jmp    800693 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80063f:	8b 45 14             	mov    0x14(%ebp),%eax
  800642:	8b 10                	mov    (%eax),%edx
  800644:	8b 48 04             	mov    0x4(%eax),%ecx
  800647:	8d 40 08             	lea    0x8(%eax),%eax
  80064a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80064d:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800652:	eb 3f                	jmp    800693 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800654:	8b 45 14             	mov    0x14(%ebp),%eax
  800657:	8b 10                	mov    (%eax),%edx
  800659:	b9 00 00 00 00       	mov    $0x0,%ecx
  80065e:	8d 40 04             	lea    0x4(%eax),%eax
  800661:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800664:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800669:	eb 28                	jmp    800693 <vprintfmt+0x38c>
			putch('0', putdat);
  80066b:	83 ec 08             	sub    $0x8,%esp
  80066e:	53                   	push   %ebx
  80066f:	6a 30                	push   $0x30
  800671:	ff d6                	call   *%esi
			putch('x', putdat);
  800673:	83 c4 08             	add    $0x8,%esp
  800676:	53                   	push   %ebx
  800677:	6a 78                	push   $0x78
  800679:	ff d6                	call   *%esi
			num = (unsigned long long)
  80067b:	8b 45 14             	mov    0x14(%ebp),%eax
  80067e:	8b 10                	mov    (%eax),%edx
  800680:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800685:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800688:	8d 40 04             	lea    0x4(%eax),%eax
  80068b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80068e:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800693:	83 ec 0c             	sub    $0xc,%esp
  800696:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80069a:	57                   	push   %edi
  80069b:	ff 75 e0             	pushl  -0x20(%ebp)
  80069e:	50                   	push   %eax
  80069f:	51                   	push   %ecx
  8006a0:	52                   	push   %edx
  8006a1:	89 da                	mov    %ebx,%edx
  8006a3:	89 f0                	mov    %esi,%eax
  8006a5:	e8 72 fb ff ff       	call   80021c <printnum>
			break;
  8006aa:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006b0:	83 c7 01             	add    $0x1,%edi
  8006b3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006b7:	83 f8 25             	cmp    $0x25,%eax
  8006ba:	0f 84 62 fc ff ff    	je     800322 <vprintfmt+0x1b>
			if (ch == '\0')
  8006c0:	85 c0                	test   %eax,%eax
  8006c2:	0f 84 8b 00 00 00    	je     800753 <vprintfmt+0x44c>
			putch(ch, putdat);
  8006c8:	83 ec 08             	sub    $0x8,%esp
  8006cb:	53                   	push   %ebx
  8006cc:	50                   	push   %eax
  8006cd:	ff d6                	call   *%esi
  8006cf:	83 c4 10             	add    $0x10,%esp
  8006d2:	eb dc                	jmp    8006b0 <vprintfmt+0x3a9>
	if (lflag >= 2)
  8006d4:	83 f9 01             	cmp    $0x1,%ecx
  8006d7:	7f 1b                	jg     8006f4 <vprintfmt+0x3ed>
	else if (lflag)
  8006d9:	85 c9                	test   %ecx,%ecx
  8006db:	74 2c                	je     800709 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8006dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e0:	8b 10                	mov    (%eax),%edx
  8006e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006e7:	8d 40 04             	lea    0x4(%eax),%eax
  8006ea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ed:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8006f2:	eb 9f                	jmp    800693 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8006f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f7:	8b 10                	mov    (%eax),%edx
  8006f9:	8b 48 04             	mov    0x4(%eax),%ecx
  8006fc:	8d 40 08             	lea    0x8(%eax),%eax
  8006ff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800702:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800707:	eb 8a                	jmp    800693 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800709:	8b 45 14             	mov    0x14(%ebp),%eax
  80070c:	8b 10                	mov    (%eax),%edx
  80070e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800713:	8d 40 04             	lea    0x4(%eax),%eax
  800716:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800719:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  80071e:	e9 70 ff ff ff       	jmp    800693 <vprintfmt+0x38c>
			putch(ch, putdat);
  800723:	83 ec 08             	sub    $0x8,%esp
  800726:	53                   	push   %ebx
  800727:	6a 25                	push   $0x25
  800729:	ff d6                	call   *%esi
			break;
  80072b:	83 c4 10             	add    $0x10,%esp
  80072e:	e9 7a ff ff ff       	jmp    8006ad <vprintfmt+0x3a6>
			putch('%', putdat);
  800733:	83 ec 08             	sub    $0x8,%esp
  800736:	53                   	push   %ebx
  800737:	6a 25                	push   $0x25
  800739:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80073b:	83 c4 10             	add    $0x10,%esp
  80073e:	89 f8                	mov    %edi,%eax
  800740:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800744:	74 05                	je     80074b <vprintfmt+0x444>
  800746:	83 e8 01             	sub    $0x1,%eax
  800749:	eb f5                	jmp    800740 <vprintfmt+0x439>
  80074b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80074e:	e9 5a ff ff ff       	jmp    8006ad <vprintfmt+0x3a6>
}
  800753:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800756:	5b                   	pop    %ebx
  800757:	5e                   	pop    %esi
  800758:	5f                   	pop    %edi
  800759:	5d                   	pop    %ebp
  80075a:	c3                   	ret    

0080075b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80075b:	f3 0f 1e fb          	endbr32 
  80075f:	55                   	push   %ebp
  800760:	89 e5                	mov    %esp,%ebp
  800762:	83 ec 18             	sub    $0x18,%esp
  800765:	8b 45 08             	mov    0x8(%ebp),%eax
  800768:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80076b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80076e:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800772:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800775:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80077c:	85 c0                	test   %eax,%eax
  80077e:	74 26                	je     8007a6 <vsnprintf+0x4b>
  800780:	85 d2                	test   %edx,%edx
  800782:	7e 22                	jle    8007a6 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800784:	ff 75 14             	pushl  0x14(%ebp)
  800787:	ff 75 10             	pushl  0x10(%ebp)
  80078a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80078d:	50                   	push   %eax
  80078e:	68 c5 02 80 00       	push   $0x8002c5
  800793:	e8 6f fb ff ff       	call   800307 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800798:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80079b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80079e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007a1:	83 c4 10             	add    $0x10,%esp
}
  8007a4:	c9                   	leave  
  8007a5:	c3                   	ret    
		return -E_INVAL;
  8007a6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007ab:	eb f7                	jmp    8007a4 <vsnprintf+0x49>

008007ad <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007ad:	f3 0f 1e fb          	endbr32 
  8007b1:	55                   	push   %ebp
  8007b2:	89 e5                	mov    %esp,%ebp
  8007b4:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007b7:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007ba:	50                   	push   %eax
  8007bb:	ff 75 10             	pushl  0x10(%ebp)
  8007be:	ff 75 0c             	pushl  0xc(%ebp)
  8007c1:	ff 75 08             	pushl  0x8(%ebp)
  8007c4:	e8 92 ff ff ff       	call   80075b <vsnprintf>
	va_end(ap);

	return rc;
}
  8007c9:	c9                   	leave  
  8007ca:	c3                   	ret    

008007cb <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007cb:	f3 0f 1e fb          	endbr32 
  8007cf:	55                   	push   %ebp
  8007d0:	89 e5                	mov    %esp,%ebp
  8007d2:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8007da:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007de:	74 05                	je     8007e5 <strlen+0x1a>
		n++;
  8007e0:	83 c0 01             	add    $0x1,%eax
  8007e3:	eb f5                	jmp    8007da <strlen+0xf>
	return n;
}
  8007e5:	5d                   	pop    %ebp
  8007e6:	c3                   	ret    

008007e7 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007e7:	f3 0f 1e fb          	endbr32 
  8007eb:	55                   	push   %ebp
  8007ec:	89 e5                	mov    %esp,%ebp
  8007ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007f1:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f9:	39 d0                	cmp    %edx,%eax
  8007fb:	74 0d                	je     80080a <strnlen+0x23>
  8007fd:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800801:	74 05                	je     800808 <strnlen+0x21>
		n++;
  800803:	83 c0 01             	add    $0x1,%eax
  800806:	eb f1                	jmp    8007f9 <strnlen+0x12>
  800808:	89 c2                	mov    %eax,%edx
	return n;
}
  80080a:	89 d0                	mov    %edx,%eax
  80080c:	5d                   	pop    %ebp
  80080d:	c3                   	ret    

0080080e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80080e:	f3 0f 1e fb          	endbr32 
  800812:	55                   	push   %ebp
  800813:	89 e5                	mov    %esp,%ebp
  800815:	53                   	push   %ebx
  800816:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800819:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80081c:	b8 00 00 00 00       	mov    $0x0,%eax
  800821:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800825:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800828:	83 c0 01             	add    $0x1,%eax
  80082b:	84 d2                	test   %dl,%dl
  80082d:	75 f2                	jne    800821 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  80082f:	89 c8                	mov    %ecx,%eax
  800831:	5b                   	pop    %ebx
  800832:	5d                   	pop    %ebp
  800833:	c3                   	ret    

00800834 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800834:	f3 0f 1e fb          	endbr32 
  800838:	55                   	push   %ebp
  800839:	89 e5                	mov    %esp,%ebp
  80083b:	53                   	push   %ebx
  80083c:	83 ec 10             	sub    $0x10,%esp
  80083f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800842:	53                   	push   %ebx
  800843:	e8 83 ff ff ff       	call   8007cb <strlen>
  800848:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80084b:	ff 75 0c             	pushl  0xc(%ebp)
  80084e:	01 d8                	add    %ebx,%eax
  800850:	50                   	push   %eax
  800851:	e8 b8 ff ff ff       	call   80080e <strcpy>
	return dst;
}
  800856:	89 d8                	mov    %ebx,%eax
  800858:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80085b:	c9                   	leave  
  80085c:	c3                   	ret    

0080085d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80085d:	f3 0f 1e fb          	endbr32 
  800861:	55                   	push   %ebp
  800862:	89 e5                	mov    %esp,%ebp
  800864:	56                   	push   %esi
  800865:	53                   	push   %ebx
  800866:	8b 75 08             	mov    0x8(%ebp),%esi
  800869:	8b 55 0c             	mov    0xc(%ebp),%edx
  80086c:	89 f3                	mov    %esi,%ebx
  80086e:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800871:	89 f0                	mov    %esi,%eax
  800873:	39 d8                	cmp    %ebx,%eax
  800875:	74 11                	je     800888 <strncpy+0x2b>
		*dst++ = *src;
  800877:	83 c0 01             	add    $0x1,%eax
  80087a:	0f b6 0a             	movzbl (%edx),%ecx
  80087d:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800880:	80 f9 01             	cmp    $0x1,%cl
  800883:	83 da ff             	sbb    $0xffffffff,%edx
  800886:	eb eb                	jmp    800873 <strncpy+0x16>
	}
	return ret;
}
  800888:	89 f0                	mov    %esi,%eax
  80088a:	5b                   	pop    %ebx
  80088b:	5e                   	pop    %esi
  80088c:	5d                   	pop    %ebp
  80088d:	c3                   	ret    

0080088e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80088e:	f3 0f 1e fb          	endbr32 
  800892:	55                   	push   %ebp
  800893:	89 e5                	mov    %esp,%ebp
  800895:	56                   	push   %esi
  800896:	53                   	push   %ebx
  800897:	8b 75 08             	mov    0x8(%ebp),%esi
  80089a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80089d:	8b 55 10             	mov    0x10(%ebp),%edx
  8008a0:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008a2:	85 d2                	test   %edx,%edx
  8008a4:	74 21                	je     8008c7 <strlcpy+0x39>
  8008a6:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008aa:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008ac:	39 c2                	cmp    %eax,%edx
  8008ae:	74 14                	je     8008c4 <strlcpy+0x36>
  8008b0:	0f b6 19             	movzbl (%ecx),%ebx
  8008b3:	84 db                	test   %bl,%bl
  8008b5:	74 0b                	je     8008c2 <strlcpy+0x34>
			*dst++ = *src++;
  8008b7:	83 c1 01             	add    $0x1,%ecx
  8008ba:	83 c2 01             	add    $0x1,%edx
  8008bd:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008c0:	eb ea                	jmp    8008ac <strlcpy+0x1e>
  8008c2:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008c4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008c7:	29 f0                	sub    %esi,%eax
}
  8008c9:	5b                   	pop    %ebx
  8008ca:	5e                   	pop    %esi
  8008cb:	5d                   	pop    %ebp
  8008cc:	c3                   	ret    

008008cd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008cd:	f3 0f 1e fb          	endbr32 
  8008d1:	55                   	push   %ebp
  8008d2:	89 e5                	mov    %esp,%ebp
  8008d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008d7:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008da:	0f b6 01             	movzbl (%ecx),%eax
  8008dd:	84 c0                	test   %al,%al
  8008df:	74 0c                	je     8008ed <strcmp+0x20>
  8008e1:	3a 02                	cmp    (%edx),%al
  8008e3:	75 08                	jne    8008ed <strcmp+0x20>
		p++, q++;
  8008e5:	83 c1 01             	add    $0x1,%ecx
  8008e8:	83 c2 01             	add    $0x1,%edx
  8008eb:	eb ed                	jmp    8008da <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008ed:	0f b6 c0             	movzbl %al,%eax
  8008f0:	0f b6 12             	movzbl (%edx),%edx
  8008f3:	29 d0                	sub    %edx,%eax
}
  8008f5:	5d                   	pop    %ebp
  8008f6:	c3                   	ret    

008008f7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008f7:	f3 0f 1e fb          	endbr32 
  8008fb:	55                   	push   %ebp
  8008fc:	89 e5                	mov    %esp,%ebp
  8008fe:	53                   	push   %ebx
  8008ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800902:	8b 55 0c             	mov    0xc(%ebp),%edx
  800905:	89 c3                	mov    %eax,%ebx
  800907:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80090a:	eb 06                	jmp    800912 <strncmp+0x1b>
		n--, p++, q++;
  80090c:	83 c0 01             	add    $0x1,%eax
  80090f:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800912:	39 d8                	cmp    %ebx,%eax
  800914:	74 16                	je     80092c <strncmp+0x35>
  800916:	0f b6 08             	movzbl (%eax),%ecx
  800919:	84 c9                	test   %cl,%cl
  80091b:	74 04                	je     800921 <strncmp+0x2a>
  80091d:	3a 0a                	cmp    (%edx),%cl
  80091f:	74 eb                	je     80090c <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800921:	0f b6 00             	movzbl (%eax),%eax
  800924:	0f b6 12             	movzbl (%edx),%edx
  800927:	29 d0                	sub    %edx,%eax
}
  800929:	5b                   	pop    %ebx
  80092a:	5d                   	pop    %ebp
  80092b:	c3                   	ret    
		return 0;
  80092c:	b8 00 00 00 00       	mov    $0x0,%eax
  800931:	eb f6                	jmp    800929 <strncmp+0x32>

00800933 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800933:	f3 0f 1e fb          	endbr32 
  800937:	55                   	push   %ebp
  800938:	89 e5                	mov    %esp,%ebp
  80093a:	8b 45 08             	mov    0x8(%ebp),%eax
  80093d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800941:	0f b6 10             	movzbl (%eax),%edx
  800944:	84 d2                	test   %dl,%dl
  800946:	74 09                	je     800951 <strchr+0x1e>
		if (*s == c)
  800948:	38 ca                	cmp    %cl,%dl
  80094a:	74 0a                	je     800956 <strchr+0x23>
	for (; *s; s++)
  80094c:	83 c0 01             	add    $0x1,%eax
  80094f:	eb f0                	jmp    800941 <strchr+0xe>
			return (char *) s;
	return 0;
  800951:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800956:	5d                   	pop    %ebp
  800957:	c3                   	ret    

00800958 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800958:	f3 0f 1e fb          	endbr32 
  80095c:	55                   	push   %ebp
  80095d:	89 e5                	mov    %esp,%ebp
  80095f:	8b 45 08             	mov    0x8(%ebp),%eax
  800962:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800966:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800969:	38 ca                	cmp    %cl,%dl
  80096b:	74 09                	je     800976 <strfind+0x1e>
  80096d:	84 d2                	test   %dl,%dl
  80096f:	74 05                	je     800976 <strfind+0x1e>
	for (; *s; s++)
  800971:	83 c0 01             	add    $0x1,%eax
  800974:	eb f0                	jmp    800966 <strfind+0xe>
			break;
	return (char *) s;
}
  800976:	5d                   	pop    %ebp
  800977:	c3                   	ret    

00800978 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800978:	f3 0f 1e fb          	endbr32 
  80097c:	55                   	push   %ebp
  80097d:	89 e5                	mov    %esp,%ebp
  80097f:	57                   	push   %edi
  800980:	56                   	push   %esi
  800981:	53                   	push   %ebx
  800982:	8b 7d 08             	mov    0x8(%ebp),%edi
  800985:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800988:	85 c9                	test   %ecx,%ecx
  80098a:	74 31                	je     8009bd <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80098c:	89 f8                	mov    %edi,%eax
  80098e:	09 c8                	or     %ecx,%eax
  800990:	a8 03                	test   $0x3,%al
  800992:	75 23                	jne    8009b7 <memset+0x3f>
		c &= 0xFF;
  800994:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800998:	89 d3                	mov    %edx,%ebx
  80099a:	c1 e3 08             	shl    $0x8,%ebx
  80099d:	89 d0                	mov    %edx,%eax
  80099f:	c1 e0 18             	shl    $0x18,%eax
  8009a2:	89 d6                	mov    %edx,%esi
  8009a4:	c1 e6 10             	shl    $0x10,%esi
  8009a7:	09 f0                	or     %esi,%eax
  8009a9:	09 c2                	or     %eax,%edx
  8009ab:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009ad:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009b0:	89 d0                	mov    %edx,%eax
  8009b2:	fc                   	cld    
  8009b3:	f3 ab                	rep stos %eax,%es:(%edi)
  8009b5:	eb 06                	jmp    8009bd <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ba:	fc                   	cld    
  8009bb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009bd:	89 f8                	mov    %edi,%eax
  8009bf:	5b                   	pop    %ebx
  8009c0:	5e                   	pop    %esi
  8009c1:	5f                   	pop    %edi
  8009c2:	5d                   	pop    %ebp
  8009c3:	c3                   	ret    

008009c4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009c4:	f3 0f 1e fb          	endbr32 
  8009c8:	55                   	push   %ebp
  8009c9:	89 e5                	mov    %esp,%ebp
  8009cb:	57                   	push   %edi
  8009cc:	56                   	push   %esi
  8009cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009d6:	39 c6                	cmp    %eax,%esi
  8009d8:	73 32                	jae    800a0c <memmove+0x48>
  8009da:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009dd:	39 c2                	cmp    %eax,%edx
  8009df:	76 2b                	jbe    800a0c <memmove+0x48>
		s += n;
		d += n;
  8009e1:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009e4:	89 fe                	mov    %edi,%esi
  8009e6:	09 ce                	or     %ecx,%esi
  8009e8:	09 d6                	or     %edx,%esi
  8009ea:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009f0:	75 0e                	jne    800a00 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009f2:	83 ef 04             	sub    $0x4,%edi
  8009f5:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009f8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009fb:	fd                   	std    
  8009fc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009fe:	eb 09                	jmp    800a09 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a00:	83 ef 01             	sub    $0x1,%edi
  800a03:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a06:	fd                   	std    
  800a07:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a09:	fc                   	cld    
  800a0a:	eb 1a                	jmp    800a26 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a0c:	89 c2                	mov    %eax,%edx
  800a0e:	09 ca                	or     %ecx,%edx
  800a10:	09 f2                	or     %esi,%edx
  800a12:	f6 c2 03             	test   $0x3,%dl
  800a15:	75 0a                	jne    800a21 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a17:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a1a:	89 c7                	mov    %eax,%edi
  800a1c:	fc                   	cld    
  800a1d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a1f:	eb 05                	jmp    800a26 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800a21:	89 c7                	mov    %eax,%edi
  800a23:	fc                   	cld    
  800a24:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a26:	5e                   	pop    %esi
  800a27:	5f                   	pop    %edi
  800a28:	5d                   	pop    %ebp
  800a29:	c3                   	ret    

00800a2a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a2a:	f3 0f 1e fb          	endbr32 
  800a2e:	55                   	push   %ebp
  800a2f:	89 e5                	mov    %esp,%ebp
  800a31:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a34:	ff 75 10             	pushl  0x10(%ebp)
  800a37:	ff 75 0c             	pushl  0xc(%ebp)
  800a3a:	ff 75 08             	pushl  0x8(%ebp)
  800a3d:	e8 82 ff ff ff       	call   8009c4 <memmove>
}
  800a42:	c9                   	leave  
  800a43:	c3                   	ret    

00800a44 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a44:	f3 0f 1e fb          	endbr32 
  800a48:	55                   	push   %ebp
  800a49:	89 e5                	mov    %esp,%ebp
  800a4b:	56                   	push   %esi
  800a4c:	53                   	push   %ebx
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a53:	89 c6                	mov    %eax,%esi
  800a55:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a58:	39 f0                	cmp    %esi,%eax
  800a5a:	74 1c                	je     800a78 <memcmp+0x34>
		if (*s1 != *s2)
  800a5c:	0f b6 08             	movzbl (%eax),%ecx
  800a5f:	0f b6 1a             	movzbl (%edx),%ebx
  800a62:	38 d9                	cmp    %bl,%cl
  800a64:	75 08                	jne    800a6e <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a66:	83 c0 01             	add    $0x1,%eax
  800a69:	83 c2 01             	add    $0x1,%edx
  800a6c:	eb ea                	jmp    800a58 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a6e:	0f b6 c1             	movzbl %cl,%eax
  800a71:	0f b6 db             	movzbl %bl,%ebx
  800a74:	29 d8                	sub    %ebx,%eax
  800a76:	eb 05                	jmp    800a7d <memcmp+0x39>
	}

	return 0;
  800a78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a7d:	5b                   	pop    %ebx
  800a7e:	5e                   	pop    %esi
  800a7f:	5d                   	pop    %ebp
  800a80:	c3                   	ret    

00800a81 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a81:	f3 0f 1e fb          	endbr32 
  800a85:	55                   	push   %ebp
  800a86:	89 e5                	mov    %esp,%ebp
  800a88:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a8e:	89 c2                	mov    %eax,%edx
  800a90:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a93:	39 d0                	cmp    %edx,%eax
  800a95:	73 09                	jae    800aa0 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a97:	38 08                	cmp    %cl,(%eax)
  800a99:	74 05                	je     800aa0 <memfind+0x1f>
	for (; s < ends; s++)
  800a9b:	83 c0 01             	add    $0x1,%eax
  800a9e:	eb f3                	jmp    800a93 <memfind+0x12>
			break;
	return (void *) s;
}
  800aa0:	5d                   	pop    %ebp
  800aa1:	c3                   	ret    

00800aa2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800aa2:	f3 0f 1e fb          	endbr32 
  800aa6:	55                   	push   %ebp
  800aa7:	89 e5                	mov    %esp,%ebp
  800aa9:	57                   	push   %edi
  800aaa:	56                   	push   %esi
  800aab:	53                   	push   %ebx
  800aac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aaf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ab2:	eb 03                	jmp    800ab7 <strtol+0x15>
		s++;
  800ab4:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ab7:	0f b6 01             	movzbl (%ecx),%eax
  800aba:	3c 20                	cmp    $0x20,%al
  800abc:	74 f6                	je     800ab4 <strtol+0x12>
  800abe:	3c 09                	cmp    $0x9,%al
  800ac0:	74 f2                	je     800ab4 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800ac2:	3c 2b                	cmp    $0x2b,%al
  800ac4:	74 2a                	je     800af0 <strtol+0x4e>
	int neg = 0;
  800ac6:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800acb:	3c 2d                	cmp    $0x2d,%al
  800acd:	74 2b                	je     800afa <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800acf:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ad5:	75 0f                	jne    800ae6 <strtol+0x44>
  800ad7:	80 39 30             	cmpb   $0x30,(%ecx)
  800ada:	74 28                	je     800b04 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800adc:	85 db                	test   %ebx,%ebx
  800ade:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ae3:	0f 44 d8             	cmove  %eax,%ebx
  800ae6:	b8 00 00 00 00       	mov    $0x0,%eax
  800aeb:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800aee:	eb 46                	jmp    800b36 <strtol+0x94>
		s++;
  800af0:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800af3:	bf 00 00 00 00       	mov    $0x0,%edi
  800af8:	eb d5                	jmp    800acf <strtol+0x2d>
		s++, neg = 1;
  800afa:	83 c1 01             	add    $0x1,%ecx
  800afd:	bf 01 00 00 00       	mov    $0x1,%edi
  800b02:	eb cb                	jmp    800acf <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b04:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b08:	74 0e                	je     800b18 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b0a:	85 db                	test   %ebx,%ebx
  800b0c:	75 d8                	jne    800ae6 <strtol+0x44>
		s++, base = 8;
  800b0e:	83 c1 01             	add    $0x1,%ecx
  800b11:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b16:	eb ce                	jmp    800ae6 <strtol+0x44>
		s += 2, base = 16;
  800b18:	83 c1 02             	add    $0x2,%ecx
  800b1b:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b20:	eb c4                	jmp    800ae6 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b22:	0f be d2             	movsbl %dl,%edx
  800b25:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b28:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b2b:	7d 3a                	jge    800b67 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b2d:	83 c1 01             	add    $0x1,%ecx
  800b30:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b34:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b36:	0f b6 11             	movzbl (%ecx),%edx
  800b39:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b3c:	89 f3                	mov    %esi,%ebx
  800b3e:	80 fb 09             	cmp    $0x9,%bl
  800b41:	76 df                	jbe    800b22 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b43:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b46:	89 f3                	mov    %esi,%ebx
  800b48:	80 fb 19             	cmp    $0x19,%bl
  800b4b:	77 08                	ja     800b55 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b4d:	0f be d2             	movsbl %dl,%edx
  800b50:	83 ea 57             	sub    $0x57,%edx
  800b53:	eb d3                	jmp    800b28 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b55:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b58:	89 f3                	mov    %esi,%ebx
  800b5a:	80 fb 19             	cmp    $0x19,%bl
  800b5d:	77 08                	ja     800b67 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b5f:	0f be d2             	movsbl %dl,%edx
  800b62:	83 ea 37             	sub    $0x37,%edx
  800b65:	eb c1                	jmp    800b28 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b67:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b6b:	74 05                	je     800b72 <strtol+0xd0>
		*endptr = (char *) s;
  800b6d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b70:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b72:	89 c2                	mov    %eax,%edx
  800b74:	f7 da                	neg    %edx
  800b76:	85 ff                	test   %edi,%edi
  800b78:	0f 45 c2             	cmovne %edx,%eax
}
  800b7b:	5b                   	pop    %ebx
  800b7c:	5e                   	pop    %esi
  800b7d:	5f                   	pop    %edi
  800b7e:	5d                   	pop    %ebp
  800b7f:	c3                   	ret    

00800b80 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b80:	f3 0f 1e fb          	endbr32 
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
  800b87:	57                   	push   %edi
  800b88:	56                   	push   %esi
  800b89:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b8a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800b92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b95:	89 c3                	mov    %eax,%ebx
  800b97:	89 c7                	mov    %eax,%edi
  800b99:	89 c6                	mov    %eax,%esi
  800b9b:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b9d:	5b                   	pop    %ebx
  800b9e:	5e                   	pop    %esi
  800b9f:	5f                   	pop    %edi
  800ba0:	5d                   	pop    %ebp
  800ba1:	c3                   	ret    

00800ba2 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ba2:	f3 0f 1e fb          	endbr32 
  800ba6:	55                   	push   %ebp
  800ba7:	89 e5                	mov    %esp,%ebp
  800ba9:	57                   	push   %edi
  800baa:	56                   	push   %esi
  800bab:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bac:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb1:	b8 01 00 00 00       	mov    $0x1,%eax
  800bb6:	89 d1                	mov    %edx,%ecx
  800bb8:	89 d3                	mov    %edx,%ebx
  800bba:	89 d7                	mov    %edx,%edi
  800bbc:	89 d6                	mov    %edx,%esi
  800bbe:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bc0:	5b                   	pop    %ebx
  800bc1:	5e                   	pop    %esi
  800bc2:	5f                   	pop    %edi
  800bc3:	5d                   	pop    %ebp
  800bc4:	c3                   	ret    

00800bc5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bc5:	f3 0f 1e fb          	endbr32 
  800bc9:	55                   	push   %ebp
  800bca:	89 e5                	mov    %esp,%ebp
  800bcc:	57                   	push   %edi
  800bcd:	56                   	push   %esi
  800bce:	53                   	push   %ebx
  800bcf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bd2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bd7:	8b 55 08             	mov    0x8(%ebp),%edx
  800bda:	b8 03 00 00 00       	mov    $0x3,%eax
  800bdf:	89 cb                	mov    %ecx,%ebx
  800be1:	89 cf                	mov    %ecx,%edi
  800be3:	89 ce                	mov    %ecx,%esi
  800be5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800be7:	85 c0                	test   %eax,%eax
  800be9:	7f 08                	jg     800bf3 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800beb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bee:	5b                   	pop    %ebx
  800bef:	5e                   	pop    %esi
  800bf0:	5f                   	pop    %edi
  800bf1:	5d                   	pop    %ebp
  800bf2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bf3:	83 ec 0c             	sub    $0xc,%esp
  800bf6:	50                   	push   %eax
  800bf7:	6a 03                	push   $0x3
  800bf9:	68 04 18 80 00       	push   $0x801804
  800bfe:	6a 23                	push   $0x23
  800c00:	68 21 18 80 00       	push   $0x801821
  800c05:	e8 f6 05 00 00       	call   801200 <_panic>

00800c0a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c0a:	f3 0f 1e fb          	endbr32 
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	57                   	push   %edi
  800c12:	56                   	push   %esi
  800c13:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c14:	ba 00 00 00 00       	mov    $0x0,%edx
  800c19:	b8 02 00 00 00       	mov    $0x2,%eax
  800c1e:	89 d1                	mov    %edx,%ecx
  800c20:	89 d3                	mov    %edx,%ebx
  800c22:	89 d7                	mov    %edx,%edi
  800c24:	89 d6                	mov    %edx,%esi
  800c26:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c28:	5b                   	pop    %ebx
  800c29:	5e                   	pop    %esi
  800c2a:	5f                   	pop    %edi
  800c2b:	5d                   	pop    %ebp
  800c2c:	c3                   	ret    

00800c2d <sys_yield>:

void
sys_yield(void)
{
  800c2d:	f3 0f 1e fb          	endbr32 
  800c31:	55                   	push   %ebp
  800c32:	89 e5                	mov    %esp,%ebp
  800c34:	57                   	push   %edi
  800c35:	56                   	push   %esi
  800c36:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c37:	ba 00 00 00 00       	mov    $0x0,%edx
  800c3c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c41:	89 d1                	mov    %edx,%ecx
  800c43:	89 d3                	mov    %edx,%ebx
  800c45:	89 d7                	mov    %edx,%edi
  800c47:	89 d6                	mov    %edx,%esi
  800c49:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c4b:	5b                   	pop    %ebx
  800c4c:	5e                   	pop    %esi
  800c4d:	5f                   	pop    %edi
  800c4e:	5d                   	pop    %ebp
  800c4f:	c3                   	ret    

00800c50 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c50:	f3 0f 1e fb          	endbr32 
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	57                   	push   %edi
  800c58:	56                   	push   %esi
  800c59:	53                   	push   %ebx
  800c5a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c5d:	be 00 00 00 00       	mov    $0x0,%esi
  800c62:	8b 55 08             	mov    0x8(%ebp),%edx
  800c65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c68:	b8 04 00 00 00       	mov    $0x4,%eax
  800c6d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c70:	89 f7                	mov    %esi,%edi
  800c72:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c74:	85 c0                	test   %eax,%eax
  800c76:	7f 08                	jg     800c80 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c7b:	5b                   	pop    %ebx
  800c7c:	5e                   	pop    %esi
  800c7d:	5f                   	pop    %edi
  800c7e:	5d                   	pop    %ebp
  800c7f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c80:	83 ec 0c             	sub    $0xc,%esp
  800c83:	50                   	push   %eax
  800c84:	6a 04                	push   $0x4
  800c86:	68 04 18 80 00       	push   $0x801804
  800c8b:	6a 23                	push   $0x23
  800c8d:	68 21 18 80 00       	push   $0x801821
  800c92:	e8 69 05 00 00       	call   801200 <_panic>

00800c97 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c97:	f3 0f 1e fb          	endbr32 
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
  800c9e:	57                   	push   %edi
  800c9f:	56                   	push   %esi
  800ca0:	53                   	push   %ebx
  800ca1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ca4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800caa:	b8 05 00 00 00       	mov    $0x5,%eax
  800caf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cb2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cb5:	8b 75 18             	mov    0x18(%ebp),%esi
  800cb8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cba:	85 c0                	test   %eax,%eax
  800cbc:	7f 08                	jg     800cc6 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc1:	5b                   	pop    %ebx
  800cc2:	5e                   	pop    %esi
  800cc3:	5f                   	pop    %edi
  800cc4:	5d                   	pop    %ebp
  800cc5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc6:	83 ec 0c             	sub    $0xc,%esp
  800cc9:	50                   	push   %eax
  800cca:	6a 05                	push   $0x5
  800ccc:	68 04 18 80 00       	push   $0x801804
  800cd1:	6a 23                	push   $0x23
  800cd3:	68 21 18 80 00       	push   $0x801821
  800cd8:	e8 23 05 00 00       	call   801200 <_panic>

00800cdd <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cdd:	f3 0f 1e fb          	endbr32 
  800ce1:	55                   	push   %ebp
  800ce2:	89 e5                	mov    %esp,%ebp
  800ce4:	57                   	push   %edi
  800ce5:	56                   	push   %esi
  800ce6:	53                   	push   %ebx
  800ce7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cea:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cef:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf5:	b8 06 00 00 00       	mov    $0x6,%eax
  800cfa:	89 df                	mov    %ebx,%edi
  800cfc:	89 de                	mov    %ebx,%esi
  800cfe:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d00:	85 c0                	test   %eax,%eax
  800d02:	7f 08                	jg     800d0c <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d04:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d07:	5b                   	pop    %ebx
  800d08:	5e                   	pop    %esi
  800d09:	5f                   	pop    %edi
  800d0a:	5d                   	pop    %ebp
  800d0b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0c:	83 ec 0c             	sub    $0xc,%esp
  800d0f:	50                   	push   %eax
  800d10:	6a 06                	push   $0x6
  800d12:	68 04 18 80 00       	push   $0x801804
  800d17:	6a 23                	push   $0x23
  800d19:	68 21 18 80 00       	push   $0x801821
  800d1e:	e8 dd 04 00 00       	call   801200 <_panic>

00800d23 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d23:	f3 0f 1e fb          	endbr32 
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	57                   	push   %edi
  800d2b:	56                   	push   %esi
  800d2c:	53                   	push   %ebx
  800d2d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d30:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d35:	8b 55 08             	mov    0x8(%ebp),%edx
  800d38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3b:	b8 08 00 00 00       	mov    $0x8,%eax
  800d40:	89 df                	mov    %ebx,%edi
  800d42:	89 de                	mov    %ebx,%esi
  800d44:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d46:	85 c0                	test   %eax,%eax
  800d48:	7f 08                	jg     800d52 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4d:	5b                   	pop    %ebx
  800d4e:	5e                   	pop    %esi
  800d4f:	5f                   	pop    %edi
  800d50:	5d                   	pop    %ebp
  800d51:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d52:	83 ec 0c             	sub    $0xc,%esp
  800d55:	50                   	push   %eax
  800d56:	6a 08                	push   $0x8
  800d58:	68 04 18 80 00       	push   $0x801804
  800d5d:	6a 23                	push   $0x23
  800d5f:	68 21 18 80 00       	push   $0x801821
  800d64:	e8 97 04 00 00       	call   801200 <_panic>

00800d69 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d69:	f3 0f 1e fb          	endbr32 
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
  800d70:	57                   	push   %edi
  800d71:	56                   	push   %esi
  800d72:	53                   	push   %ebx
  800d73:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d76:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d81:	b8 09 00 00 00       	mov    $0x9,%eax
  800d86:	89 df                	mov    %ebx,%edi
  800d88:	89 de                	mov    %ebx,%esi
  800d8a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8c:	85 c0                	test   %eax,%eax
  800d8e:	7f 08                	jg     800d98 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d93:	5b                   	pop    %ebx
  800d94:	5e                   	pop    %esi
  800d95:	5f                   	pop    %edi
  800d96:	5d                   	pop    %ebp
  800d97:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d98:	83 ec 0c             	sub    $0xc,%esp
  800d9b:	50                   	push   %eax
  800d9c:	6a 09                	push   $0x9
  800d9e:	68 04 18 80 00       	push   $0x801804
  800da3:	6a 23                	push   $0x23
  800da5:	68 21 18 80 00       	push   $0x801821
  800daa:	e8 51 04 00 00       	call   801200 <_panic>

00800daf <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800daf:	f3 0f 1e fb          	endbr32 
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	57                   	push   %edi
  800db7:	56                   	push   %esi
  800db8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800db9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dbf:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dc4:	be 00 00 00 00       	mov    $0x0,%esi
  800dc9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dcc:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dcf:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800dd1:	5b                   	pop    %ebx
  800dd2:	5e                   	pop    %esi
  800dd3:	5f                   	pop    %edi
  800dd4:	5d                   	pop    %ebp
  800dd5:	c3                   	ret    

00800dd6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dd6:	f3 0f 1e fb          	endbr32 
  800dda:	55                   	push   %ebp
  800ddb:	89 e5                	mov    %esp,%ebp
  800ddd:	57                   	push   %edi
  800dde:	56                   	push   %esi
  800ddf:	53                   	push   %ebx
  800de0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800de8:	8b 55 08             	mov    0x8(%ebp),%edx
  800deb:	b8 0c 00 00 00       	mov    $0xc,%eax
  800df0:	89 cb                	mov    %ecx,%ebx
  800df2:	89 cf                	mov    %ecx,%edi
  800df4:	89 ce                	mov    %ecx,%esi
  800df6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df8:	85 c0                	test   %eax,%eax
  800dfa:	7f 08                	jg     800e04 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800dfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dff:	5b                   	pop    %ebx
  800e00:	5e                   	pop    %esi
  800e01:	5f                   	pop    %edi
  800e02:	5d                   	pop    %ebp
  800e03:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e04:	83 ec 0c             	sub    $0xc,%esp
  800e07:	50                   	push   %eax
  800e08:	6a 0c                	push   $0xc
  800e0a:	68 04 18 80 00       	push   $0x801804
  800e0f:	6a 23                	push   $0x23
  800e11:	68 21 18 80 00       	push   $0x801821
  800e16:	e8 e5 03 00 00       	call   801200 <_panic>

00800e1b <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800e1b:	f3 0f 1e fb          	endbr32 
  800e1f:	55                   	push   %ebp
  800e20:	89 e5                	mov    %esp,%ebp
  800e22:	53                   	push   %ebx
  800e23:	83 ec 04             	sub    $0x4,%esp
  800e26:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800e29:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  800e2b:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800e2f:	74 74                	je     800ea5 <pgfault+0x8a>
  800e31:	89 d8                	mov    %ebx,%eax
  800e33:	c1 e8 0c             	shr    $0xc,%eax
  800e36:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800e3d:	f6 c4 08             	test   $0x8,%ah
  800e40:	74 63                	je     800ea5 <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800e42:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  800e48:	83 ec 0c             	sub    $0xc,%esp
  800e4b:	6a 05                	push   $0x5
  800e4d:	68 00 f0 7f 00       	push   $0x7ff000
  800e52:	6a 00                	push   $0x0
  800e54:	53                   	push   %ebx
  800e55:	6a 00                	push   $0x0
  800e57:	e8 3b fe ff ff       	call   800c97 <sys_page_map>
  800e5c:	83 c4 20             	add    $0x20,%esp
  800e5f:	85 c0                	test   %eax,%eax
  800e61:	78 59                	js     800ebc <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  800e63:	83 ec 04             	sub    $0x4,%esp
  800e66:	6a 07                	push   $0x7
  800e68:	53                   	push   %ebx
  800e69:	6a 00                	push   $0x0
  800e6b:	e8 e0 fd ff ff       	call   800c50 <sys_page_alloc>
  800e70:	83 c4 10             	add    $0x10,%esp
  800e73:	85 c0                	test   %eax,%eax
  800e75:	78 5a                	js     800ed1 <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  800e77:	83 ec 04             	sub    $0x4,%esp
  800e7a:	68 00 10 00 00       	push   $0x1000
  800e7f:	68 00 f0 7f 00       	push   $0x7ff000
  800e84:	53                   	push   %ebx
  800e85:	e8 3a fb ff ff       	call   8009c4 <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  800e8a:	83 c4 08             	add    $0x8,%esp
  800e8d:	68 00 f0 7f 00       	push   $0x7ff000
  800e92:	6a 00                	push   $0x0
  800e94:	e8 44 fe ff ff       	call   800cdd <sys_page_unmap>
  800e99:	83 c4 10             	add    $0x10,%esp
  800e9c:	85 c0                	test   %eax,%eax
  800e9e:	78 46                	js     800ee6 <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  800ea0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ea3:	c9                   	leave  
  800ea4:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  800ea5:	83 ec 04             	sub    $0x4,%esp
  800ea8:	68 2f 18 80 00       	push   $0x80182f
  800ead:	68 d3 00 00 00       	push   $0xd3
  800eb2:	68 4b 18 80 00       	push   $0x80184b
  800eb7:	e8 44 03 00 00       	call   801200 <_panic>
		panic("pgfault: %e\n", r);
  800ebc:	50                   	push   %eax
  800ebd:	68 56 18 80 00       	push   $0x801856
  800ec2:	68 df 00 00 00       	push   $0xdf
  800ec7:	68 4b 18 80 00       	push   $0x80184b
  800ecc:	e8 2f 03 00 00       	call   801200 <_panic>
		panic("pgfault: %e\n", r);
  800ed1:	50                   	push   %eax
  800ed2:	68 56 18 80 00       	push   $0x801856
  800ed7:	68 e3 00 00 00       	push   $0xe3
  800edc:	68 4b 18 80 00       	push   $0x80184b
  800ee1:	e8 1a 03 00 00       	call   801200 <_panic>
		panic("pgfault: %e\n", r);
  800ee6:	50                   	push   %eax
  800ee7:	68 56 18 80 00       	push   $0x801856
  800eec:	68 e9 00 00 00       	push   $0xe9
  800ef1:	68 4b 18 80 00       	push   $0x80184b
  800ef6:	e8 05 03 00 00       	call   801200 <_panic>

00800efb <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800efb:	f3 0f 1e fb          	endbr32 
  800eff:	55                   	push   %ebp
  800f00:	89 e5                	mov    %esp,%ebp
  800f02:	57                   	push   %edi
  800f03:	56                   	push   %esi
  800f04:	53                   	push   %ebx
  800f05:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  800f08:	68 1b 0e 80 00       	push   $0x800e1b
  800f0d:	e8 38 03 00 00       	call   80124a <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f12:	b8 07 00 00 00       	mov    $0x7,%eax
  800f17:	cd 30                	int    $0x30
  800f19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  800f1c:	83 c4 10             	add    $0x10,%esp
  800f1f:	85 c0                	test   %eax,%eax
  800f21:	78 2d                	js     800f50 <fork+0x55>
  800f23:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800f25:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  800f2a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f2e:	0f 85 81 00 00 00    	jne    800fb5 <fork+0xba>
		thisenv = &envs[ENVX(sys_getenvid())];
  800f34:	e8 d1 fc ff ff       	call   800c0a <sys_getenvid>
  800f39:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f3e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f41:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f46:	a3 08 20 80 00       	mov    %eax,0x802008
		return 0;
  800f4b:	e9 43 01 00 00       	jmp    801093 <fork+0x198>
		panic("sys_exofork: %e", envid);
  800f50:	50                   	push   %eax
  800f51:	68 63 18 80 00       	push   $0x801863
  800f56:	68 26 01 00 00       	push   $0x126
  800f5b:	68 4b 18 80 00       	push   $0x80184b
  800f60:	e8 9b 02 00 00       	call   801200 <_panic>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  800f65:	c1 e6 0c             	shl    $0xc,%esi
  800f68:	83 ec 0c             	sub    $0xc,%esp
  800f6b:	68 05 08 00 00       	push   $0x805
  800f70:	56                   	push   %esi
  800f71:	57                   	push   %edi
  800f72:	56                   	push   %esi
  800f73:	6a 00                	push   $0x0
  800f75:	e8 1d fd ff ff       	call   800c97 <sys_page_map>
  800f7a:	83 c4 20             	add    $0x20,%esp
  800f7d:	85 c0                	test   %eax,%eax
  800f7f:	0f 88 a8 00 00 00    	js     80102d <fork+0x132>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  800f85:	83 ec 0c             	sub    $0xc,%esp
  800f88:	68 05 08 00 00       	push   $0x805
  800f8d:	56                   	push   %esi
  800f8e:	6a 00                	push   $0x0
  800f90:	56                   	push   %esi
  800f91:	6a 00                	push   $0x0
  800f93:	e8 ff fc ff ff       	call   800c97 <sys_page_map>
  800f98:	83 c4 20             	add    $0x20,%esp
  800f9b:	85 c0                	test   %eax,%eax
  800f9d:	0f 88 9f 00 00 00    	js     801042 <fork+0x147>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800fa3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800fa9:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  800faf:	0f 84 a2 00 00 00    	je     801057 <fork+0x15c>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  800fb5:	89 d8                	mov    %ebx,%eax
  800fb7:	c1 e8 16             	shr    $0x16,%eax
  800fba:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fc1:	a8 01                	test   $0x1,%al
  800fc3:	74 de                	je     800fa3 <fork+0xa8>
  800fc5:	89 de                	mov    %ebx,%esi
  800fc7:	c1 ee 0c             	shr    $0xc,%esi
  800fca:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  800fd1:	a8 01                	test   $0x1,%al
  800fd3:	74 ce                	je     800fa3 <fork+0xa8>
  800fd5:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  800fdc:	a8 04                	test   $0x4,%al
  800fde:	74 c3                	je     800fa3 <fork+0xa8>
	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  800fe0:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  800fe7:	a8 02                	test   $0x2,%al
  800fe9:	0f 85 76 ff ff ff    	jne    800f65 <fork+0x6a>
  800fef:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  800ff6:	f6 c4 08             	test   $0x8,%ah
  800ff9:	0f 85 66 ff ff ff    	jne    800f65 <fork+0x6a>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  800fff:	c1 e6 0c             	shl    $0xc,%esi
  801002:	83 ec 0c             	sub    $0xc,%esp
  801005:	6a 05                	push   $0x5
  801007:	56                   	push   %esi
  801008:	57                   	push   %edi
  801009:	56                   	push   %esi
  80100a:	6a 00                	push   $0x0
  80100c:	e8 86 fc ff ff       	call   800c97 <sys_page_map>
  801011:	83 c4 20             	add    $0x20,%esp
  801014:	85 c0                	test   %eax,%eax
  801016:	79 8b                	jns    800fa3 <fork+0xa8>
		panic("duppage: %e\n", r);
  801018:	50                   	push   %eax
  801019:	68 73 18 80 00       	push   $0x801873
  80101e:	68 08 01 00 00       	push   $0x108
  801023:	68 4b 18 80 00       	push   $0x80184b
  801028:	e8 d3 01 00 00       	call   801200 <_panic>
			panic("duppage: %e\n", r);
  80102d:	50                   	push   %eax
  80102e:	68 73 18 80 00       	push   $0x801873
  801033:	68 01 01 00 00       	push   $0x101
  801038:	68 4b 18 80 00       	push   $0x80184b
  80103d:	e8 be 01 00 00       	call   801200 <_panic>
			panic("duppage: %e\n", r);
  801042:	50                   	push   %eax
  801043:	68 73 18 80 00       	push   $0x801873
  801048:	68 05 01 00 00       	push   $0x105
  80104d:	68 4b 18 80 00       	push   $0x80184b
  801052:	e8 a9 01 00 00       	call   801200 <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  801057:	83 ec 04             	sub    $0x4,%esp
  80105a:	6a 07                	push   $0x7
  80105c:	68 00 f0 bf ee       	push   $0xeebff000
  801061:	ff 75 e4             	pushl  -0x1c(%ebp)
  801064:	e8 e7 fb ff ff       	call   800c50 <sys_page_alloc>
  801069:	83 c4 10             	add    $0x10,%esp
  80106c:	85 c0                	test   %eax,%eax
  80106e:	78 2e                	js     80109e <fork+0x1a3>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801070:	83 ec 08             	sub    $0x8,%esp
  801073:	68 bd 12 80 00       	push   $0x8012bd
  801078:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80107b:	57                   	push   %edi
  80107c:	e8 e8 fc ff ff       	call   800d69 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801081:	83 c4 08             	add    $0x8,%esp
  801084:	6a 02                	push   $0x2
  801086:	57                   	push   %edi
  801087:	e8 97 fc ff ff       	call   800d23 <sys_env_set_status>
  80108c:	83 c4 10             	add    $0x10,%esp
  80108f:	85 c0                	test   %eax,%eax
  801091:	78 20                	js     8010b3 <fork+0x1b8>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  801093:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801096:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801099:	5b                   	pop    %ebx
  80109a:	5e                   	pop    %esi
  80109b:	5f                   	pop    %edi
  80109c:	5d                   	pop    %ebp
  80109d:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  80109e:	50                   	push   %eax
  80109f:	68 80 18 80 00       	push   $0x801880
  8010a4:	68 3a 01 00 00       	push   $0x13a
  8010a9:	68 4b 18 80 00       	push   $0x80184b
  8010ae:	e8 4d 01 00 00       	call   801200 <_panic>
		panic("sys_env_set_status: %e", r);
  8010b3:	50                   	push   %eax
  8010b4:	68 93 18 80 00       	push   $0x801893
  8010b9:	68 3f 01 00 00       	push   $0x13f
  8010be:	68 4b 18 80 00       	push   $0x80184b
  8010c3:	e8 38 01 00 00       	call   801200 <_panic>

008010c8 <sfork>:

// Challenge!
int
sfork(void)
{
  8010c8:	f3 0f 1e fb          	endbr32 
  8010cc:	55                   	push   %ebp
  8010cd:	89 e5                	mov    %esp,%ebp
  8010cf:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8010d2:	68 aa 18 80 00       	push   $0x8018aa
  8010d7:	68 48 01 00 00       	push   $0x148
  8010dc:	68 4b 18 80 00       	push   $0x80184b
  8010e1:	e8 1a 01 00 00       	call   801200 <_panic>

008010e6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8010e6:	f3 0f 1e fb          	endbr32 
  8010ea:	55                   	push   %ebp
  8010eb:	89 e5                	mov    %esp,%ebp
  8010ed:	56                   	push   %esi
  8010ee:	53                   	push   %ebx
  8010ef:	8b 75 08             	mov    0x8(%ebp),%esi
  8010f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  8010f8:	85 c0                	test   %eax,%eax
  8010fa:	74 3d                	je     801139 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  8010fc:	83 ec 0c             	sub    $0xc,%esp
  8010ff:	50                   	push   %eax
  801100:	e8 d1 fc ff ff       	call   800dd6 <sys_ipc_recv>
  801105:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  801108:	85 f6                	test   %esi,%esi
  80110a:	74 0b                	je     801117 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  80110c:	8b 15 08 20 80 00    	mov    0x802008,%edx
  801112:	8b 52 74             	mov    0x74(%edx),%edx
  801115:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801117:	85 db                	test   %ebx,%ebx
  801119:	74 0b                	je     801126 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  80111b:	8b 15 08 20 80 00    	mov    0x802008,%edx
  801121:	8b 52 78             	mov    0x78(%edx),%edx
  801124:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  801126:	85 c0                	test   %eax,%eax
  801128:	78 21                	js     80114b <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  80112a:	a1 08 20 80 00       	mov    0x802008,%eax
  80112f:	8b 40 70             	mov    0x70(%eax),%eax
}
  801132:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801135:	5b                   	pop    %ebx
  801136:	5e                   	pop    %esi
  801137:	5d                   	pop    %ebp
  801138:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  801139:	83 ec 0c             	sub    $0xc,%esp
  80113c:	68 00 00 c0 ee       	push   $0xeec00000
  801141:	e8 90 fc ff ff       	call   800dd6 <sys_ipc_recv>
  801146:	83 c4 10             	add    $0x10,%esp
  801149:	eb bd                	jmp    801108 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  80114b:	85 f6                	test   %esi,%esi
  80114d:	74 10                	je     80115f <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  80114f:	85 db                	test   %ebx,%ebx
  801151:	75 df                	jne    801132 <ipc_recv+0x4c>
  801153:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80115a:	00 00 00 
  80115d:	eb d3                	jmp    801132 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  80115f:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801166:	00 00 00 
  801169:	eb e4                	jmp    80114f <ipc_recv+0x69>

0080116b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80116b:	f3 0f 1e fb          	endbr32 
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
  801172:	57                   	push   %edi
  801173:	56                   	push   %esi
  801174:	53                   	push   %ebx
  801175:	83 ec 0c             	sub    $0xc,%esp
  801178:	8b 7d 08             	mov    0x8(%ebp),%edi
  80117b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80117e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  801181:	85 db                	test   %ebx,%ebx
  801183:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801188:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  80118b:	ff 75 14             	pushl  0x14(%ebp)
  80118e:	53                   	push   %ebx
  80118f:	56                   	push   %esi
  801190:	57                   	push   %edi
  801191:	e8 19 fc ff ff       	call   800daf <sys_ipc_try_send>
  801196:	83 c4 10             	add    $0x10,%esp
  801199:	85 c0                	test   %eax,%eax
  80119b:	79 1e                	jns    8011bb <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  80119d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8011a0:	75 07                	jne    8011a9 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  8011a2:	e8 86 fa ff ff       	call   800c2d <sys_yield>
  8011a7:	eb e2                	jmp    80118b <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  8011a9:	50                   	push   %eax
  8011aa:	68 c0 18 80 00       	push   $0x8018c0
  8011af:	6a 59                	push   $0x59
  8011b1:	68 db 18 80 00       	push   $0x8018db
  8011b6:	e8 45 00 00 00       	call   801200 <_panic>
	}


}
  8011bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011be:	5b                   	pop    %ebx
  8011bf:	5e                   	pop    %esi
  8011c0:	5f                   	pop    %edi
  8011c1:	5d                   	pop    %ebp
  8011c2:	c3                   	ret    

008011c3 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8011c3:	f3 0f 1e fb          	endbr32 
  8011c7:	55                   	push   %ebp
  8011c8:	89 e5                	mov    %esp,%ebp
  8011ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8011cd:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8011d2:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8011d5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8011db:	8b 52 50             	mov    0x50(%edx),%edx
  8011de:	39 ca                	cmp    %ecx,%edx
  8011e0:	74 11                	je     8011f3 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8011e2:	83 c0 01             	add    $0x1,%eax
  8011e5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8011ea:	75 e6                	jne    8011d2 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8011ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8011f1:	eb 0b                	jmp    8011fe <ipc_find_env+0x3b>
			return envs[i].env_id;
  8011f3:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8011f6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011fb:	8b 40 48             	mov    0x48(%eax),%eax
}
  8011fe:	5d                   	pop    %ebp
  8011ff:	c3                   	ret    

00801200 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801200:	f3 0f 1e fb          	endbr32 
  801204:	55                   	push   %ebp
  801205:	89 e5                	mov    %esp,%ebp
  801207:	56                   	push   %esi
  801208:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801209:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80120c:	8b 35 00 20 80 00    	mov    0x802000,%esi
  801212:	e8 f3 f9 ff ff       	call   800c0a <sys_getenvid>
  801217:	83 ec 0c             	sub    $0xc,%esp
  80121a:	ff 75 0c             	pushl  0xc(%ebp)
  80121d:	ff 75 08             	pushl  0x8(%ebp)
  801220:	56                   	push   %esi
  801221:	50                   	push   %eax
  801222:	68 e8 18 80 00       	push   $0x8018e8
  801227:	e8 d8 ef ff ff       	call   800204 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80122c:	83 c4 18             	add    $0x18,%esp
  80122f:	53                   	push   %ebx
  801230:	ff 75 10             	pushl  0x10(%ebp)
  801233:	e8 77 ef ff ff       	call   8001af <vcprintf>
	cprintf("\n");
  801238:	c7 04 24 d9 18 80 00 	movl   $0x8018d9,(%esp)
  80123f:	e8 c0 ef ff ff       	call   800204 <cprintf>
  801244:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801247:	cc                   	int3   
  801248:	eb fd                	jmp    801247 <_panic+0x47>

0080124a <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80124a:	f3 0f 1e fb          	endbr32 
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
  801251:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801254:	83 3d 0c 20 80 00 00 	cmpl   $0x0,0x80200c
  80125b:	74 0a                	je     801267 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	a3 0c 20 80 00       	mov    %eax,0x80200c
}
  801265:	c9                   	leave  
  801266:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  801267:	83 ec 04             	sub    $0x4,%esp
  80126a:	6a 07                	push   $0x7
  80126c:	68 00 f0 bf ee       	push   $0xeebff000
  801271:	6a 00                	push   $0x0
  801273:	e8 d8 f9 ff ff       	call   800c50 <sys_page_alloc>
  801278:	83 c4 10             	add    $0x10,%esp
  80127b:	85 c0                	test   %eax,%eax
  80127d:	78 2a                	js     8012a9 <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  80127f:	83 ec 08             	sub    $0x8,%esp
  801282:	68 bd 12 80 00       	push   $0x8012bd
  801287:	6a 00                	push   $0x0
  801289:	e8 db fa ff ff       	call   800d69 <sys_env_set_pgfault_upcall>
  80128e:	83 c4 10             	add    $0x10,%esp
  801291:	85 c0                	test   %eax,%eax
  801293:	79 c8                	jns    80125d <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  801295:	83 ec 04             	sub    $0x4,%esp
  801298:	68 38 19 80 00       	push   $0x801938
  80129d:	6a 25                	push   $0x25
  80129f:	68 70 19 80 00       	push   $0x801970
  8012a4:	e8 57 ff ff ff       	call   801200 <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  8012a9:	83 ec 04             	sub    $0x4,%esp
  8012ac:	68 0c 19 80 00       	push   $0x80190c
  8012b1:	6a 22                	push   $0x22
  8012b3:	68 70 19 80 00       	push   $0x801970
  8012b8:	e8 43 ff ff ff       	call   801200 <_panic>

008012bd <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8012bd:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8012be:	a1 0c 20 80 00       	mov    0x80200c,%eax
	call *%eax
  8012c3:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8012c5:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  8012c8:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  8012cc:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  8012d0:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8012d3:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  8012d5:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  8012d9:	83 c4 08             	add    $0x8,%esp
	popal
  8012dc:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  8012dd:	83 c4 04             	add    $0x4,%esp
	popfl
  8012e0:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  8012e1:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  8012e2:	c3                   	ret    
  8012e3:	66 90                	xchg   %ax,%ax
  8012e5:	66 90                	xchg   %ax,%ax
  8012e7:	66 90                	xchg   %ax,%ax
  8012e9:	66 90                	xchg   %ax,%ax
  8012eb:	66 90                	xchg   %ax,%ax
  8012ed:	66 90                	xchg   %ax,%ax
  8012ef:	90                   	nop

008012f0 <__udivdi3>:
  8012f0:	f3 0f 1e fb          	endbr32 
  8012f4:	55                   	push   %ebp
  8012f5:	57                   	push   %edi
  8012f6:	56                   	push   %esi
  8012f7:	53                   	push   %ebx
  8012f8:	83 ec 1c             	sub    $0x1c,%esp
  8012fb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8012ff:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801303:	8b 74 24 34          	mov    0x34(%esp),%esi
  801307:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80130b:	85 d2                	test   %edx,%edx
  80130d:	75 19                	jne    801328 <__udivdi3+0x38>
  80130f:	39 f3                	cmp    %esi,%ebx
  801311:	76 4d                	jbe    801360 <__udivdi3+0x70>
  801313:	31 ff                	xor    %edi,%edi
  801315:	89 e8                	mov    %ebp,%eax
  801317:	89 f2                	mov    %esi,%edx
  801319:	f7 f3                	div    %ebx
  80131b:	89 fa                	mov    %edi,%edx
  80131d:	83 c4 1c             	add    $0x1c,%esp
  801320:	5b                   	pop    %ebx
  801321:	5e                   	pop    %esi
  801322:	5f                   	pop    %edi
  801323:	5d                   	pop    %ebp
  801324:	c3                   	ret    
  801325:	8d 76 00             	lea    0x0(%esi),%esi
  801328:	39 f2                	cmp    %esi,%edx
  80132a:	76 14                	jbe    801340 <__udivdi3+0x50>
  80132c:	31 ff                	xor    %edi,%edi
  80132e:	31 c0                	xor    %eax,%eax
  801330:	89 fa                	mov    %edi,%edx
  801332:	83 c4 1c             	add    $0x1c,%esp
  801335:	5b                   	pop    %ebx
  801336:	5e                   	pop    %esi
  801337:	5f                   	pop    %edi
  801338:	5d                   	pop    %ebp
  801339:	c3                   	ret    
  80133a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801340:	0f bd fa             	bsr    %edx,%edi
  801343:	83 f7 1f             	xor    $0x1f,%edi
  801346:	75 48                	jne    801390 <__udivdi3+0xa0>
  801348:	39 f2                	cmp    %esi,%edx
  80134a:	72 06                	jb     801352 <__udivdi3+0x62>
  80134c:	31 c0                	xor    %eax,%eax
  80134e:	39 eb                	cmp    %ebp,%ebx
  801350:	77 de                	ja     801330 <__udivdi3+0x40>
  801352:	b8 01 00 00 00       	mov    $0x1,%eax
  801357:	eb d7                	jmp    801330 <__udivdi3+0x40>
  801359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801360:	89 d9                	mov    %ebx,%ecx
  801362:	85 db                	test   %ebx,%ebx
  801364:	75 0b                	jne    801371 <__udivdi3+0x81>
  801366:	b8 01 00 00 00       	mov    $0x1,%eax
  80136b:	31 d2                	xor    %edx,%edx
  80136d:	f7 f3                	div    %ebx
  80136f:	89 c1                	mov    %eax,%ecx
  801371:	31 d2                	xor    %edx,%edx
  801373:	89 f0                	mov    %esi,%eax
  801375:	f7 f1                	div    %ecx
  801377:	89 c6                	mov    %eax,%esi
  801379:	89 e8                	mov    %ebp,%eax
  80137b:	89 f7                	mov    %esi,%edi
  80137d:	f7 f1                	div    %ecx
  80137f:	89 fa                	mov    %edi,%edx
  801381:	83 c4 1c             	add    $0x1c,%esp
  801384:	5b                   	pop    %ebx
  801385:	5e                   	pop    %esi
  801386:	5f                   	pop    %edi
  801387:	5d                   	pop    %ebp
  801388:	c3                   	ret    
  801389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801390:	89 f9                	mov    %edi,%ecx
  801392:	b8 20 00 00 00       	mov    $0x20,%eax
  801397:	29 f8                	sub    %edi,%eax
  801399:	d3 e2                	shl    %cl,%edx
  80139b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80139f:	89 c1                	mov    %eax,%ecx
  8013a1:	89 da                	mov    %ebx,%edx
  8013a3:	d3 ea                	shr    %cl,%edx
  8013a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8013a9:	09 d1                	or     %edx,%ecx
  8013ab:	89 f2                	mov    %esi,%edx
  8013ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013b1:	89 f9                	mov    %edi,%ecx
  8013b3:	d3 e3                	shl    %cl,%ebx
  8013b5:	89 c1                	mov    %eax,%ecx
  8013b7:	d3 ea                	shr    %cl,%edx
  8013b9:	89 f9                	mov    %edi,%ecx
  8013bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8013bf:	89 eb                	mov    %ebp,%ebx
  8013c1:	d3 e6                	shl    %cl,%esi
  8013c3:	89 c1                	mov    %eax,%ecx
  8013c5:	d3 eb                	shr    %cl,%ebx
  8013c7:	09 de                	or     %ebx,%esi
  8013c9:	89 f0                	mov    %esi,%eax
  8013cb:	f7 74 24 08          	divl   0x8(%esp)
  8013cf:	89 d6                	mov    %edx,%esi
  8013d1:	89 c3                	mov    %eax,%ebx
  8013d3:	f7 64 24 0c          	mull   0xc(%esp)
  8013d7:	39 d6                	cmp    %edx,%esi
  8013d9:	72 15                	jb     8013f0 <__udivdi3+0x100>
  8013db:	89 f9                	mov    %edi,%ecx
  8013dd:	d3 e5                	shl    %cl,%ebp
  8013df:	39 c5                	cmp    %eax,%ebp
  8013e1:	73 04                	jae    8013e7 <__udivdi3+0xf7>
  8013e3:	39 d6                	cmp    %edx,%esi
  8013e5:	74 09                	je     8013f0 <__udivdi3+0x100>
  8013e7:	89 d8                	mov    %ebx,%eax
  8013e9:	31 ff                	xor    %edi,%edi
  8013eb:	e9 40 ff ff ff       	jmp    801330 <__udivdi3+0x40>
  8013f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8013f3:	31 ff                	xor    %edi,%edi
  8013f5:	e9 36 ff ff ff       	jmp    801330 <__udivdi3+0x40>
  8013fa:	66 90                	xchg   %ax,%ax
  8013fc:	66 90                	xchg   %ax,%ax
  8013fe:	66 90                	xchg   %ax,%ax

00801400 <__umoddi3>:
  801400:	f3 0f 1e fb          	endbr32 
  801404:	55                   	push   %ebp
  801405:	57                   	push   %edi
  801406:	56                   	push   %esi
  801407:	53                   	push   %ebx
  801408:	83 ec 1c             	sub    $0x1c,%esp
  80140b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80140f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801413:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801417:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80141b:	85 c0                	test   %eax,%eax
  80141d:	75 19                	jne    801438 <__umoddi3+0x38>
  80141f:	39 df                	cmp    %ebx,%edi
  801421:	76 5d                	jbe    801480 <__umoddi3+0x80>
  801423:	89 f0                	mov    %esi,%eax
  801425:	89 da                	mov    %ebx,%edx
  801427:	f7 f7                	div    %edi
  801429:	89 d0                	mov    %edx,%eax
  80142b:	31 d2                	xor    %edx,%edx
  80142d:	83 c4 1c             	add    $0x1c,%esp
  801430:	5b                   	pop    %ebx
  801431:	5e                   	pop    %esi
  801432:	5f                   	pop    %edi
  801433:	5d                   	pop    %ebp
  801434:	c3                   	ret    
  801435:	8d 76 00             	lea    0x0(%esi),%esi
  801438:	89 f2                	mov    %esi,%edx
  80143a:	39 d8                	cmp    %ebx,%eax
  80143c:	76 12                	jbe    801450 <__umoddi3+0x50>
  80143e:	89 f0                	mov    %esi,%eax
  801440:	89 da                	mov    %ebx,%edx
  801442:	83 c4 1c             	add    $0x1c,%esp
  801445:	5b                   	pop    %ebx
  801446:	5e                   	pop    %esi
  801447:	5f                   	pop    %edi
  801448:	5d                   	pop    %ebp
  801449:	c3                   	ret    
  80144a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801450:	0f bd e8             	bsr    %eax,%ebp
  801453:	83 f5 1f             	xor    $0x1f,%ebp
  801456:	75 50                	jne    8014a8 <__umoddi3+0xa8>
  801458:	39 d8                	cmp    %ebx,%eax
  80145a:	0f 82 e0 00 00 00    	jb     801540 <__umoddi3+0x140>
  801460:	89 d9                	mov    %ebx,%ecx
  801462:	39 f7                	cmp    %esi,%edi
  801464:	0f 86 d6 00 00 00    	jbe    801540 <__umoddi3+0x140>
  80146a:	89 d0                	mov    %edx,%eax
  80146c:	89 ca                	mov    %ecx,%edx
  80146e:	83 c4 1c             	add    $0x1c,%esp
  801471:	5b                   	pop    %ebx
  801472:	5e                   	pop    %esi
  801473:	5f                   	pop    %edi
  801474:	5d                   	pop    %ebp
  801475:	c3                   	ret    
  801476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80147d:	8d 76 00             	lea    0x0(%esi),%esi
  801480:	89 fd                	mov    %edi,%ebp
  801482:	85 ff                	test   %edi,%edi
  801484:	75 0b                	jne    801491 <__umoddi3+0x91>
  801486:	b8 01 00 00 00       	mov    $0x1,%eax
  80148b:	31 d2                	xor    %edx,%edx
  80148d:	f7 f7                	div    %edi
  80148f:	89 c5                	mov    %eax,%ebp
  801491:	89 d8                	mov    %ebx,%eax
  801493:	31 d2                	xor    %edx,%edx
  801495:	f7 f5                	div    %ebp
  801497:	89 f0                	mov    %esi,%eax
  801499:	f7 f5                	div    %ebp
  80149b:	89 d0                	mov    %edx,%eax
  80149d:	31 d2                	xor    %edx,%edx
  80149f:	eb 8c                	jmp    80142d <__umoddi3+0x2d>
  8014a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8014a8:	89 e9                	mov    %ebp,%ecx
  8014aa:	ba 20 00 00 00       	mov    $0x20,%edx
  8014af:	29 ea                	sub    %ebp,%edx
  8014b1:	d3 e0                	shl    %cl,%eax
  8014b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014b7:	89 d1                	mov    %edx,%ecx
  8014b9:	89 f8                	mov    %edi,%eax
  8014bb:	d3 e8                	shr    %cl,%eax
  8014bd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8014c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8014c5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8014c9:	09 c1                	or     %eax,%ecx
  8014cb:	89 d8                	mov    %ebx,%eax
  8014cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014d1:	89 e9                	mov    %ebp,%ecx
  8014d3:	d3 e7                	shl    %cl,%edi
  8014d5:	89 d1                	mov    %edx,%ecx
  8014d7:	d3 e8                	shr    %cl,%eax
  8014d9:	89 e9                	mov    %ebp,%ecx
  8014db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8014df:	d3 e3                	shl    %cl,%ebx
  8014e1:	89 c7                	mov    %eax,%edi
  8014e3:	89 d1                	mov    %edx,%ecx
  8014e5:	89 f0                	mov    %esi,%eax
  8014e7:	d3 e8                	shr    %cl,%eax
  8014e9:	89 e9                	mov    %ebp,%ecx
  8014eb:	89 fa                	mov    %edi,%edx
  8014ed:	d3 e6                	shl    %cl,%esi
  8014ef:	09 d8                	or     %ebx,%eax
  8014f1:	f7 74 24 08          	divl   0x8(%esp)
  8014f5:	89 d1                	mov    %edx,%ecx
  8014f7:	89 f3                	mov    %esi,%ebx
  8014f9:	f7 64 24 0c          	mull   0xc(%esp)
  8014fd:	89 c6                	mov    %eax,%esi
  8014ff:	89 d7                	mov    %edx,%edi
  801501:	39 d1                	cmp    %edx,%ecx
  801503:	72 06                	jb     80150b <__umoddi3+0x10b>
  801505:	75 10                	jne    801517 <__umoddi3+0x117>
  801507:	39 c3                	cmp    %eax,%ebx
  801509:	73 0c                	jae    801517 <__umoddi3+0x117>
  80150b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80150f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801513:	89 d7                	mov    %edx,%edi
  801515:	89 c6                	mov    %eax,%esi
  801517:	89 ca                	mov    %ecx,%edx
  801519:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80151e:	29 f3                	sub    %esi,%ebx
  801520:	19 fa                	sbb    %edi,%edx
  801522:	89 d0                	mov    %edx,%eax
  801524:	d3 e0                	shl    %cl,%eax
  801526:	89 e9                	mov    %ebp,%ecx
  801528:	d3 eb                	shr    %cl,%ebx
  80152a:	d3 ea                	shr    %cl,%edx
  80152c:	09 d8                	or     %ebx,%eax
  80152e:	83 c4 1c             	add    $0x1c,%esp
  801531:	5b                   	pop    %ebx
  801532:	5e                   	pop    %esi
  801533:	5f                   	pop    %edi
  801534:	5d                   	pop    %ebp
  801535:	c3                   	ret    
  801536:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80153d:	8d 76 00             	lea    0x0(%esi),%esi
  801540:	29 fe                	sub    %edi,%esi
  801542:	19 c3                	sbb    %eax,%ebx
  801544:	89 f2                	mov    %esi,%edx
  801546:	89 d9                	mov    %ebx,%ecx
  801548:	e9 1d ff ff ff       	jmp    80146a <__umoddi3+0x6a>
