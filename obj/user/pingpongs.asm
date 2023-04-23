
obj/user/pingpongs.debug:     file format elf32-i386


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
  800040:	e8 ae 11 00 00       	call   8011f3 <sfork>
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
  800057:	e8 b5 11 00 00       	call   801211 <ipc_recv>
		cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  80005c:	8b 1d 0c 40 80 00    	mov    0x80400c,%ebx
  800062:	8b 7b 48             	mov    0x48(%ebx),%edi
  800065:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800068:	a1 08 40 80 00       	mov    0x804008,%eax
  80006d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800070:	e8 9d 0b 00 00       	call   800c12 <sys_getenvid>
  800075:	83 c4 08             	add    $0x8,%esp
  800078:	57                   	push   %edi
  800079:	53                   	push   %ebx
  80007a:	56                   	push   %esi
  80007b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80007e:	50                   	push   %eax
  80007f:	68 f0 28 80 00       	push   $0x8028f0
  800084:	e8 83 01 00 00       	call   80020c <cprintf>
		if (val == 10)
  800089:	a1 08 40 80 00       	mov    0x804008,%eax
  80008e:	83 c4 20             	add    $0x20,%esp
  800091:	83 f8 0a             	cmp    $0xa,%eax
  800094:	74 22                	je     8000b8 <umain+0x85>
			return;
		++val;
  800096:	83 c0 01             	add    $0x1,%eax
  800099:	a3 08 40 80 00       	mov    %eax,0x804008
		ipc_send(who, 0, 0, 0);
  80009e:	6a 00                	push   $0x0
  8000a0:	6a 00                	push   $0x0
  8000a2:	6a 00                	push   $0x0
  8000a4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000a7:	e8 ea 11 00 00       	call   801296 <ipc_send>
		if (val == 10)
  8000ac:	83 c4 10             	add    $0x10,%esp
  8000af:	83 3d 08 40 80 00 0a 	cmpl   $0xa,0x804008
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
  8000c0:	8b 1d 0c 40 80 00    	mov    0x80400c,%ebx
  8000c6:	e8 47 0b 00 00       	call   800c12 <sys_getenvid>
  8000cb:	83 ec 04             	sub    $0x4,%esp
  8000ce:	53                   	push   %ebx
  8000cf:	50                   	push   %eax
  8000d0:	68 c0 28 80 00       	push   $0x8028c0
  8000d5:	e8 32 01 00 00       	call   80020c <cprintf>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  8000da:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8000dd:	e8 30 0b 00 00       	call   800c12 <sys_getenvid>
  8000e2:	83 c4 0c             	add    $0xc,%esp
  8000e5:	53                   	push   %ebx
  8000e6:	50                   	push   %eax
  8000e7:	68 da 28 80 00       	push   $0x8028da
  8000ec:	e8 1b 01 00 00       	call   80020c <cprintf>
		ipc_send(who, 0, 0, 0);
  8000f1:	6a 00                	push   $0x0
  8000f3:	6a 00                	push   $0x0
  8000f5:	6a 00                	push   $0x0
  8000f7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000fa:	e8 97 11 00 00       	call   801296 <ipc_send>
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
  800116:	e8 f7 0a 00 00       	call   800c12 <sys_getenvid>
  80011b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800120:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800123:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800128:	a3 0c 40 80 00       	mov    %eax,0x80400c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80012d:	85 db                	test   %ebx,%ebx
  80012f:	7e 07                	jle    800138 <libmain+0x31>
		binaryname = argv[0];
  800131:	8b 06                	mov    (%esi),%eax
  800133:	a3 00 30 80 00       	mov    %eax,0x803000

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
  800158:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80015b:	e8 bf 13 00 00       	call   80151f <close_all>
	sys_env_destroy(0);
  800160:	83 ec 0c             	sub    $0xc,%esp
  800163:	6a 00                	push   $0x0
  800165:	e8 63 0a 00 00       	call   800bcd <sys_env_destroy>
}
  80016a:	83 c4 10             	add    $0x10,%esp
  80016d:	c9                   	leave  
  80016e:	c3                   	ret    

0080016f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80016f:	f3 0f 1e fb          	endbr32 
  800173:	55                   	push   %ebp
  800174:	89 e5                	mov    %esp,%ebp
  800176:	53                   	push   %ebx
  800177:	83 ec 04             	sub    $0x4,%esp
  80017a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80017d:	8b 13                	mov    (%ebx),%edx
  80017f:	8d 42 01             	lea    0x1(%edx),%eax
  800182:	89 03                	mov    %eax,(%ebx)
  800184:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800187:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80018b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800190:	74 09                	je     80019b <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800192:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800196:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800199:	c9                   	leave  
  80019a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80019b:	83 ec 08             	sub    $0x8,%esp
  80019e:	68 ff 00 00 00       	push   $0xff
  8001a3:	8d 43 08             	lea    0x8(%ebx),%eax
  8001a6:	50                   	push   %eax
  8001a7:	e8 dc 09 00 00       	call   800b88 <sys_cputs>
		b->idx = 0;
  8001ac:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001b2:	83 c4 10             	add    $0x10,%esp
  8001b5:	eb db                	jmp    800192 <putch+0x23>

008001b7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001b7:	f3 0f 1e fb          	endbr32 
  8001bb:	55                   	push   %ebp
  8001bc:	89 e5                	mov    %esp,%ebp
  8001be:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001c4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001cb:	00 00 00 
	b.cnt = 0;
  8001ce:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001d5:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001d8:	ff 75 0c             	pushl  0xc(%ebp)
  8001db:	ff 75 08             	pushl  0x8(%ebp)
  8001de:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001e4:	50                   	push   %eax
  8001e5:	68 6f 01 80 00       	push   $0x80016f
  8001ea:	e8 20 01 00 00       	call   80030f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001ef:	83 c4 08             	add    $0x8,%esp
  8001f2:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001f8:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001fe:	50                   	push   %eax
  8001ff:	e8 84 09 00 00       	call   800b88 <sys_cputs>

	return b.cnt;
}
  800204:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80020a:	c9                   	leave  
  80020b:	c3                   	ret    

0080020c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80020c:	f3 0f 1e fb          	endbr32 
  800210:	55                   	push   %ebp
  800211:	89 e5                	mov    %esp,%ebp
  800213:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800216:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800219:	50                   	push   %eax
  80021a:	ff 75 08             	pushl  0x8(%ebp)
  80021d:	e8 95 ff ff ff       	call   8001b7 <vcprintf>
	va_end(ap);

	return cnt;
}
  800222:	c9                   	leave  
  800223:	c3                   	ret    

00800224 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800224:	55                   	push   %ebp
  800225:	89 e5                	mov    %esp,%ebp
  800227:	57                   	push   %edi
  800228:	56                   	push   %esi
  800229:	53                   	push   %ebx
  80022a:	83 ec 1c             	sub    $0x1c,%esp
  80022d:	89 c7                	mov    %eax,%edi
  80022f:	89 d6                	mov    %edx,%esi
  800231:	8b 45 08             	mov    0x8(%ebp),%eax
  800234:	8b 55 0c             	mov    0xc(%ebp),%edx
  800237:	89 d1                	mov    %edx,%ecx
  800239:	89 c2                	mov    %eax,%edx
  80023b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80023e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800241:	8b 45 10             	mov    0x10(%ebp),%eax
  800244:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800247:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80024a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800251:	39 c2                	cmp    %eax,%edx
  800253:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800256:	72 3e                	jb     800296 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800258:	83 ec 0c             	sub    $0xc,%esp
  80025b:	ff 75 18             	pushl  0x18(%ebp)
  80025e:	83 eb 01             	sub    $0x1,%ebx
  800261:	53                   	push   %ebx
  800262:	50                   	push   %eax
  800263:	83 ec 08             	sub    $0x8,%esp
  800266:	ff 75 e4             	pushl  -0x1c(%ebp)
  800269:	ff 75 e0             	pushl  -0x20(%ebp)
  80026c:	ff 75 dc             	pushl  -0x24(%ebp)
  80026f:	ff 75 d8             	pushl  -0x28(%ebp)
  800272:	e8 d9 23 00 00       	call   802650 <__udivdi3>
  800277:	83 c4 18             	add    $0x18,%esp
  80027a:	52                   	push   %edx
  80027b:	50                   	push   %eax
  80027c:	89 f2                	mov    %esi,%edx
  80027e:	89 f8                	mov    %edi,%eax
  800280:	e8 9f ff ff ff       	call   800224 <printnum>
  800285:	83 c4 20             	add    $0x20,%esp
  800288:	eb 13                	jmp    80029d <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	56                   	push   %esi
  80028e:	ff 75 18             	pushl  0x18(%ebp)
  800291:	ff d7                	call   *%edi
  800293:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800296:	83 eb 01             	sub    $0x1,%ebx
  800299:	85 db                	test   %ebx,%ebx
  80029b:	7f ed                	jg     80028a <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80029d:	83 ec 08             	sub    $0x8,%esp
  8002a0:	56                   	push   %esi
  8002a1:	83 ec 04             	sub    $0x4,%esp
  8002a4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a7:	ff 75 e0             	pushl  -0x20(%ebp)
  8002aa:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ad:	ff 75 d8             	pushl  -0x28(%ebp)
  8002b0:	e8 ab 24 00 00       	call   802760 <__umoddi3>
  8002b5:	83 c4 14             	add    $0x14,%esp
  8002b8:	0f be 80 20 29 80 00 	movsbl 0x802920(%eax),%eax
  8002bf:	50                   	push   %eax
  8002c0:	ff d7                	call   *%edi
}
  8002c2:	83 c4 10             	add    $0x10,%esp
  8002c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c8:	5b                   	pop    %ebx
  8002c9:	5e                   	pop    %esi
  8002ca:	5f                   	pop    %edi
  8002cb:	5d                   	pop    %ebp
  8002cc:	c3                   	ret    

008002cd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002cd:	f3 0f 1e fb          	endbr32 
  8002d1:	55                   	push   %ebp
  8002d2:	89 e5                	mov    %esp,%ebp
  8002d4:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002d7:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002db:	8b 10                	mov    (%eax),%edx
  8002dd:	3b 50 04             	cmp    0x4(%eax),%edx
  8002e0:	73 0a                	jae    8002ec <sprintputch+0x1f>
		*b->buf++ = ch;
  8002e2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002e5:	89 08                	mov    %ecx,(%eax)
  8002e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ea:	88 02                	mov    %al,(%edx)
}
  8002ec:	5d                   	pop    %ebp
  8002ed:	c3                   	ret    

008002ee <printfmt>:
{
  8002ee:	f3 0f 1e fb          	endbr32 
  8002f2:	55                   	push   %ebp
  8002f3:	89 e5                	mov    %esp,%ebp
  8002f5:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002f8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002fb:	50                   	push   %eax
  8002fc:	ff 75 10             	pushl  0x10(%ebp)
  8002ff:	ff 75 0c             	pushl  0xc(%ebp)
  800302:	ff 75 08             	pushl  0x8(%ebp)
  800305:	e8 05 00 00 00       	call   80030f <vprintfmt>
}
  80030a:	83 c4 10             	add    $0x10,%esp
  80030d:	c9                   	leave  
  80030e:	c3                   	ret    

0080030f <vprintfmt>:
{
  80030f:	f3 0f 1e fb          	endbr32 
  800313:	55                   	push   %ebp
  800314:	89 e5                	mov    %esp,%ebp
  800316:	57                   	push   %edi
  800317:	56                   	push   %esi
  800318:	53                   	push   %ebx
  800319:	83 ec 3c             	sub    $0x3c,%esp
  80031c:	8b 75 08             	mov    0x8(%ebp),%esi
  80031f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800322:	8b 7d 10             	mov    0x10(%ebp),%edi
  800325:	e9 8e 03 00 00       	jmp    8006b8 <vprintfmt+0x3a9>
		padc = ' ';
  80032a:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80032e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800335:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80033c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800343:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800348:	8d 47 01             	lea    0x1(%edi),%eax
  80034b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80034e:	0f b6 17             	movzbl (%edi),%edx
  800351:	8d 42 dd             	lea    -0x23(%edx),%eax
  800354:	3c 55                	cmp    $0x55,%al
  800356:	0f 87 df 03 00 00    	ja     80073b <vprintfmt+0x42c>
  80035c:	0f b6 c0             	movzbl %al,%eax
  80035f:	3e ff 24 85 60 2a 80 	notrack jmp *0x802a60(,%eax,4)
  800366:	00 
  800367:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80036a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80036e:	eb d8                	jmp    800348 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800370:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800373:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800377:	eb cf                	jmp    800348 <vprintfmt+0x39>
  800379:	0f b6 d2             	movzbl %dl,%edx
  80037c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80037f:	b8 00 00 00 00       	mov    $0x0,%eax
  800384:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800387:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80038a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80038e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800391:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800394:	83 f9 09             	cmp    $0x9,%ecx
  800397:	77 55                	ja     8003ee <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800399:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80039c:	eb e9                	jmp    800387 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80039e:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a1:	8b 00                	mov    (%eax),%eax
  8003a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a9:	8d 40 04             	lea    0x4(%eax),%eax
  8003ac:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003af:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003b2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003b6:	79 90                	jns    800348 <vprintfmt+0x39>
				width = precision, precision = -1;
  8003b8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003be:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003c5:	eb 81                	jmp    800348 <vprintfmt+0x39>
  8003c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ca:	85 c0                	test   %eax,%eax
  8003cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d1:	0f 49 d0             	cmovns %eax,%edx
  8003d4:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003da:	e9 69 ff ff ff       	jmp    800348 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003e2:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003e9:	e9 5a ff ff ff       	jmp    800348 <vprintfmt+0x39>
  8003ee:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003f4:	eb bc                	jmp    8003b2 <vprintfmt+0xa3>
			lflag++;
  8003f6:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003fc:	e9 47 ff ff ff       	jmp    800348 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800401:	8b 45 14             	mov    0x14(%ebp),%eax
  800404:	8d 78 04             	lea    0x4(%eax),%edi
  800407:	83 ec 08             	sub    $0x8,%esp
  80040a:	53                   	push   %ebx
  80040b:	ff 30                	pushl  (%eax)
  80040d:	ff d6                	call   *%esi
			break;
  80040f:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800412:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800415:	e9 9b 02 00 00       	jmp    8006b5 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80041a:	8b 45 14             	mov    0x14(%ebp),%eax
  80041d:	8d 78 04             	lea    0x4(%eax),%edi
  800420:	8b 00                	mov    (%eax),%eax
  800422:	99                   	cltd   
  800423:	31 d0                	xor    %edx,%eax
  800425:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800427:	83 f8 0f             	cmp    $0xf,%eax
  80042a:	7f 23                	jg     80044f <vprintfmt+0x140>
  80042c:	8b 14 85 c0 2b 80 00 	mov    0x802bc0(,%eax,4),%edx
  800433:	85 d2                	test   %edx,%edx
  800435:	74 18                	je     80044f <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800437:	52                   	push   %edx
  800438:	68 a9 2d 80 00       	push   $0x802da9
  80043d:	53                   	push   %ebx
  80043e:	56                   	push   %esi
  80043f:	e8 aa fe ff ff       	call   8002ee <printfmt>
  800444:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800447:	89 7d 14             	mov    %edi,0x14(%ebp)
  80044a:	e9 66 02 00 00       	jmp    8006b5 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80044f:	50                   	push   %eax
  800450:	68 38 29 80 00       	push   $0x802938
  800455:	53                   	push   %ebx
  800456:	56                   	push   %esi
  800457:	e8 92 fe ff ff       	call   8002ee <printfmt>
  80045c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80045f:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800462:	e9 4e 02 00 00       	jmp    8006b5 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800467:	8b 45 14             	mov    0x14(%ebp),%eax
  80046a:	83 c0 04             	add    $0x4,%eax
  80046d:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800470:	8b 45 14             	mov    0x14(%ebp),%eax
  800473:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800475:	85 d2                	test   %edx,%edx
  800477:	b8 31 29 80 00       	mov    $0x802931,%eax
  80047c:	0f 45 c2             	cmovne %edx,%eax
  80047f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800482:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800486:	7e 06                	jle    80048e <vprintfmt+0x17f>
  800488:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80048c:	75 0d                	jne    80049b <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80048e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800491:	89 c7                	mov    %eax,%edi
  800493:	03 45 e0             	add    -0x20(%ebp),%eax
  800496:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800499:	eb 55                	jmp    8004f0 <vprintfmt+0x1e1>
  80049b:	83 ec 08             	sub    $0x8,%esp
  80049e:	ff 75 d8             	pushl  -0x28(%ebp)
  8004a1:	ff 75 cc             	pushl  -0x34(%ebp)
  8004a4:	e8 46 03 00 00       	call   8007ef <strnlen>
  8004a9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004ac:	29 c2                	sub    %eax,%edx
  8004ae:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004b1:	83 c4 10             	add    $0x10,%esp
  8004b4:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004b6:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004bd:	85 ff                	test   %edi,%edi
  8004bf:	7e 11                	jle    8004d2 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8004c1:	83 ec 08             	sub    $0x8,%esp
  8004c4:	53                   	push   %ebx
  8004c5:	ff 75 e0             	pushl  -0x20(%ebp)
  8004c8:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ca:	83 ef 01             	sub    $0x1,%edi
  8004cd:	83 c4 10             	add    $0x10,%esp
  8004d0:	eb eb                	jmp    8004bd <vprintfmt+0x1ae>
  8004d2:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004d5:	85 d2                	test   %edx,%edx
  8004d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8004dc:	0f 49 c2             	cmovns %edx,%eax
  8004df:	29 c2                	sub    %eax,%edx
  8004e1:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004e4:	eb a8                	jmp    80048e <vprintfmt+0x17f>
					putch(ch, putdat);
  8004e6:	83 ec 08             	sub    $0x8,%esp
  8004e9:	53                   	push   %ebx
  8004ea:	52                   	push   %edx
  8004eb:	ff d6                	call   *%esi
  8004ed:	83 c4 10             	add    $0x10,%esp
  8004f0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004f3:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004f5:	83 c7 01             	add    $0x1,%edi
  8004f8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004fc:	0f be d0             	movsbl %al,%edx
  8004ff:	85 d2                	test   %edx,%edx
  800501:	74 4b                	je     80054e <vprintfmt+0x23f>
  800503:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800507:	78 06                	js     80050f <vprintfmt+0x200>
  800509:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80050d:	78 1e                	js     80052d <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  80050f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800513:	74 d1                	je     8004e6 <vprintfmt+0x1d7>
  800515:	0f be c0             	movsbl %al,%eax
  800518:	83 e8 20             	sub    $0x20,%eax
  80051b:	83 f8 5e             	cmp    $0x5e,%eax
  80051e:	76 c6                	jbe    8004e6 <vprintfmt+0x1d7>
					putch('?', putdat);
  800520:	83 ec 08             	sub    $0x8,%esp
  800523:	53                   	push   %ebx
  800524:	6a 3f                	push   $0x3f
  800526:	ff d6                	call   *%esi
  800528:	83 c4 10             	add    $0x10,%esp
  80052b:	eb c3                	jmp    8004f0 <vprintfmt+0x1e1>
  80052d:	89 cf                	mov    %ecx,%edi
  80052f:	eb 0e                	jmp    80053f <vprintfmt+0x230>
				putch(' ', putdat);
  800531:	83 ec 08             	sub    $0x8,%esp
  800534:	53                   	push   %ebx
  800535:	6a 20                	push   $0x20
  800537:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800539:	83 ef 01             	sub    $0x1,%edi
  80053c:	83 c4 10             	add    $0x10,%esp
  80053f:	85 ff                	test   %edi,%edi
  800541:	7f ee                	jg     800531 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800543:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800546:	89 45 14             	mov    %eax,0x14(%ebp)
  800549:	e9 67 01 00 00       	jmp    8006b5 <vprintfmt+0x3a6>
  80054e:	89 cf                	mov    %ecx,%edi
  800550:	eb ed                	jmp    80053f <vprintfmt+0x230>
	if (lflag >= 2)
  800552:	83 f9 01             	cmp    $0x1,%ecx
  800555:	7f 1b                	jg     800572 <vprintfmt+0x263>
	else if (lflag)
  800557:	85 c9                	test   %ecx,%ecx
  800559:	74 63                	je     8005be <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80055b:	8b 45 14             	mov    0x14(%ebp),%eax
  80055e:	8b 00                	mov    (%eax),%eax
  800560:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800563:	99                   	cltd   
  800564:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800567:	8b 45 14             	mov    0x14(%ebp),%eax
  80056a:	8d 40 04             	lea    0x4(%eax),%eax
  80056d:	89 45 14             	mov    %eax,0x14(%ebp)
  800570:	eb 17                	jmp    800589 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800572:	8b 45 14             	mov    0x14(%ebp),%eax
  800575:	8b 50 04             	mov    0x4(%eax),%edx
  800578:	8b 00                	mov    (%eax),%eax
  80057a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80057d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800580:	8b 45 14             	mov    0x14(%ebp),%eax
  800583:	8d 40 08             	lea    0x8(%eax),%eax
  800586:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800589:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80058c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80058f:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800594:	85 c9                	test   %ecx,%ecx
  800596:	0f 89 ff 00 00 00    	jns    80069b <vprintfmt+0x38c>
				putch('-', putdat);
  80059c:	83 ec 08             	sub    $0x8,%esp
  80059f:	53                   	push   %ebx
  8005a0:	6a 2d                	push   $0x2d
  8005a2:	ff d6                	call   *%esi
				num = -(long long) num;
  8005a4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005a7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005aa:	f7 da                	neg    %edx
  8005ac:	83 d1 00             	adc    $0x0,%ecx
  8005af:	f7 d9                	neg    %ecx
  8005b1:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005b4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005b9:	e9 dd 00 00 00       	jmp    80069b <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8005be:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c1:	8b 00                	mov    (%eax),%eax
  8005c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c6:	99                   	cltd   
  8005c7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cd:	8d 40 04             	lea    0x4(%eax),%eax
  8005d0:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d3:	eb b4                	jmp    800589 <vprintfmt+0x27a>
	if (lflag >= 2)
  8005d5:	83 f9 01             	cmp    $0x1,%ecx
  8005d8:	7f 1e                	jg     8005f8 <vprintfmt+0x2e9>
	else if (lflag)
  8005da:	85 c9                	test   %ecx,%ecx
  8005dc:	74 32                	je     800610 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8005de:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e1:	8b 10                	mov    (%eax),%edx
  8005e3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005e8:	8d 40 04             	lea    0x4(%eax),%eax
  8005eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ee:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8005f3:	e9 a3 00 00 00       	jmp    80069b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fb:	8b 10                	mov    (%eax),%edx
  8005fd:	8b 48 04             	mov    0x4(%eax),%ecx
  800600:	8d 40 08             	lea    0x8(%eax),%eax
  800603:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800606:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80060b:	e9 8b 00 00 00       	jmp    80069b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800610:	8b 45 14             	mov    0x14(%ebp),%eax
  800613:	8b 10                	mov    (%eax),%edx
  800615:	b9 00 00 00 00       	mov    $0x0,%ecx
  80061a:	8d 40 04             	lea    0x4(%eax),%eax
  80061d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800620:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800625:	eb 74                	jmp    80069b <vprintfmt+0x38c>
	if (lflag >= 2)
  800627:	83 f9 01             	cmp    $0x1,%ecx
  80062a:	7f 1b                	jg     800647 <vprintfmt+0x338>
	else if (lflag)
  80062c:	85 c9                	test   %ecx,%ecx
  80062e:	74 2c                	je     80065c <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800630:	8b 45 14             	mov    0x14(%ebp),%eax
  800633:	8b 10                	mov    (%eax),%edx
  800635:	b9 00 00 00 00       	mov    $0x0,%ecx
  80063a:	8d 40 04             	lea    0x4(%eax),%eax
  80063d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800640:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800645:	eb 54                	jmp    80069b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800647:	8b 45 14             	mov    0x14(%ebp),%eax
  80064a:	8b 10                	mov    (%eax),%edx
  80064c:	8b 48 04             	mov    0x4(%eax),%ecx
  80064f:	8d 40 08             	lea    0x8(%eax),%eax
  800652:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800655:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80065a:	eb 3f                	jmp    80069b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8b 10                	mov    (%eax),%edx
  800661:	b9 00 00 00 00       	mov    $0x0,%ecx
  800666:	8d 40 04             	lea    0x4(%eax),%eax
  800669:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80066c:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800671:	eb 28                	jmp    80069b <vprintfmt+0x38c>
			putch('0', putdat);
  800673:	83 ec 08             	sub    $0x8,%esp
  800676:	53                   	push   %ebx
  800677:	6a 30                	push   $0x30
  800679:	ff d6                	call   *%esi
			putch('x', putdat);
  80067b:	83 c4 08             	add    $0x8,%esp
  80067e:	53                   	push   %ebx
  80067f:	6a 78                	push   $0x78
  800681:	ff d6                	call   *%esi
			num = (unsigned long long)
  800683:	8b 45 14             	mov    0x14(%ebp),%eax
  800686:	8b 10                	mov    (%eax),%edx
  800688:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80068d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800690:	8d 40 04             	lea    0x4(%eax),%eax
  800693:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800696:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80069b:	83 ec 0c             	sub    $0xc,%esp
  80069e:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8006a2:	57                   	push   %edi
  8006a3:	ff 75 e0             	pushl  -0x20(%ebp)
  8006a6:	50                   	push   %eax
  8006a7:	51                   	push   %ecx
  8006a8:	52                   	push   %edx
  8006a9:	89 da                	mov    %ebx,%edx
  8006ab:	89 f0                	mov    %esi,%eax
  8006ad:	e8 72 fb ff ff       	call   800224 <printnum>
			break;
  8006b2:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006b5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006b8:	83 c7 01             	add    $0x1,%edi
  8006bb:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006bf:	83 f8 25             	cmp    $0x25,%eax
  8006c2:	0f 84 62 fc ff ff    	je     80032a <vprintfmt+0x1b>
			if (ch == '\0')
  8006c8:	85 c0                	test   %eax,%eax
  8006ca:	0f 84 8b 00 00 00    	je     80075b <vprintfmt+0x44c>
			putch(ch, putdat);
  8006d0:	83 ec 08             	sub    $0x8,%esp
  8006d3:	53                   	push   %ebx
  8006d4:	50                   	push   %eax
  8006d5:	ff d6                	call   *%esi
  8006d7:	83 c4 10             	add    $0x10,%esp
  8006da:	eb dc                	jmp    8006b8 <vprintfmt+0x3a9>
	if (lflag >= 2)
  8006dc:	83 f9 01             	cmp    $0x1,%ecx
  8006df:	7f 1b                	jg     8006fc <vprintfmt+0x3ed>
	else if (lflag)
  8006e1:	85 c9                	test   %ecx,%ecx
  8006e3:	74 2c                	je     800711 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8006e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e8:	8b 10                	mov    (%eax),%edx
  8006ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ef:	8d 40 04             	lea    0x4(%eax),%eax
  8006f2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006f5:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8006fa:	eb 9f                	jmp    80069b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8006fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ff:	8b 10                	mov    (%eax),%edx
  800701:	8b 48 04             	mov    0x4(%eax),%ecx
  800704:	8d 40 08             	lea    0x8(%eax),%eax
  800707:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80070a:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  80070f:	eb 8a                	jmp    80069b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800711:	8b 45 14             	mov    0x14(%ebp),%eax
  800714:	8b 10                	mov    (%eax),%edx
  800716:	b9 00 00 00 00       	mov    $0x0,%ecx
  80071b:	8d 40 04             	lea    0x4(%eax),%eax
  80071e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800721:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800726:	e9 70 ff ff ff       	jmp    80069b <vprintfmt+0x38c>
			putch(ch, putdat);
  80072b:	83 ec 08             	sub    $0x8,%esp
  80072e:	53                   	push   %ebx
  80072f:	6a 25                	push   $0x25
  800731:	ff d6                	call   *%esi
			break;
  800733:	83 c4 10             	add    $0x10,%esp
  800736:	e9 7a ff ff ff       	jmp    8006b5 <vprintfmt+0x3a6>
			putch('%', putdat);
  80073b:	83 ec 08             	sub    $0x8,%esp
  80073e:	53                   	push   %ebx
  80073f:	6a 25                	push   $0x25
  800741:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800743:	83 c4 10             	add    $0x10,%esp
  800746:	89 f8                	mov    %edi,%eax
  800748:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80074c:	74 05                	je     800753 <vprintfmt+0x444>
  80074e:	83 e8 01             	sub    $0x1,%eax
  800751:	eb f5                	jmp    800748 <vprintfmt+0x439>
  800753:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800756:	e9 5a ff ff ff       	jmp    8006b5 <vprintfmt+0x3a6>
}
  80075b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80075e:	5b                   	pop    %ebx
  80075f:	5e                   	pop    %esi
  800760:	5f                   	pop    %edi
  800761:	5d                   	pop    %ebp
  800762:	c3                   	ret    

00800763 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800763:	f3 0f 1e fb          	endbr32 
  800767:	55                   	push   %ebp
  800768:	89 e5                	mov    %esp,%ebp
  80076a:	83 ec 18             	sub    $0x18,%esp
  80076d:	8b 45 08             	mov    0x8(%ebp),%eax
  800770:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800773:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800776:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80077a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80077d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800784:	85 c0                	test   %eax,%eax
  800786:	74 26                	je     8007ae <vsnprintf+0x4b>
  800788:	85 d2                	test   %edx,%edx
  80078a:	7e 22                	jle    8007ae <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80078c:	ff 75 14             	pushl  0x14(%ebp)
  80078f:	ff 75 10             	pushl  0x10(%ebp)
  800792:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800795:	50                   	push   %eax
  800796:	68 cd 02 80 00       	push   $0x8002cd
  80079b:	e8 6f fb ff ff       	call   80030f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007a3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007a9:	83 c4 10             	add    $0x10,%esp
}
  8007ac:	c9                   	leave  
  8007ad:	c3                   	ret    
		return -E_INVAL;
  8007ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007b3:	eb f7                	jmp    8007ac <vsnprintf+0x49>

008007b5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007b5:	f3 0f 1e fb          	endbr32 
  8007b9:	55                   	push   %ebp
  8007ba:	89 e5                	mov    %esp,%ebp
  8007bc:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007bf:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007c2:	50                   	push   %eax
  8007c3:	ff 75 10             	pushl  0x10(%ebp)
  8007c6:	ff 75 0c             	pushl  0xc(%ebp)
  8007c9:	ff 75 08             	pushl  0x8(%ebp)
  8007cc:	e8 92 ff ff ff       	call   800763 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007d1:	c9                   	leave  
  8007d2:	c3                   	ret    

008007d3 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007d3:	f3 0f 1e fb          	endbr32 
  8007d7:	55                   	push   %ebp
  8007d8:	89 e5                	mov    %esp,%ebp
  8007da:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e2:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007e6:	74 05                	je     8007ed <strlen+0x1a>
		n++;
  8007e8:	83 c0 01             	add    $0x1,%eax
  8007eb:	eb f5                	jmp    8007e2 <strlen+0xf>
	return n;
}
  8007ed:	5d                   	pop    %ebp
  8007ee:	c3                   	ret    

008007ef <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007ef:	f3 0f 1e fb          	endbr32 
  8007f3:	55                   	push   %ebp
  8007f4:	89 e5                	mov    %esp,%ebp
  8007f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007f9:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800801:	39 d0                	cmp    %edx,%eax
  800803:	74 0d                	je     800812 <strnlen+0x23>
  800805:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800809:	74 05                	je     800810 <strnlen+0x21>
		n++;
  80080b:	83 c0 01             	add    $0x1,%eax
  80080e:	eb f1                	jmp    800801 <strnlen+0x12>
  800810:	89 c2                	mov    %eax,%edx
	return n;
}
  800812:	89 d0                	mov    %edx,%eax
  800814:	5d                   	pop    %ebp
  800815:	c3                   	ret    

00800816 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800816:	f3 0f 1e fb          	endbr32 
  80081a:	55                   	push   %ebp
  80081b:	89 e5                	mov    %esp,%ebp
  80081d:	53                   	push   %ebx
  80081e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800821:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800824:	b8 00 00 00 00       	mov    $0x0,%eax
  800829:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80082d:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800830:	83 c0 01             	add    $0x1,%eax
  800833:	84 d2                	test   %dl,%dl
  800835:	75 f2                	jne    800829 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800837:	89 c8                	mov    %ecx,%eax
  800839:	5b                   	pop    %ebx
  80083a:	5d                   	pop    %ebp
  80083b:	c3                   	ret    

0080083c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80083c:	f3 0f 1e fb          	endbr32 
  800840:	55                   	push   %ebp
  800841:	89 e5                	mov    %esp,%ebp
  800843:	53                   	push   %ebx
  800844:	83 ec 10             	sub    $0x10,%esp
  800847:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80084a:	53                   	push   %ebx
  80084b:	e8 83 ff ff ff       	call   8007d3 <strlen>
  800850:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800853:	ff 75 0c             	pushl  0xc(%ebp)
  800856:	01 d8                	add    %ebx,%eax
  800858:	50                   	push   %eax
  800859:	e8 b8 ff ff ff       	call   800816 <strcpy>
	return dst;
}
  80085e:	89 d8                	mov    %ebx,%eax
  800860:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800863:	c9                   	leave  
  800864:	c3                   	ret    

00800865 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800865:	f3 0f 1e fb          	endbr32 
  800869:	55                   	push   %ebp
  80086a:	89 e5                	mov    %esp,%ebp
  80086c:	56                   	push   %esi
  80086d:	53                   	push   %ebx
  80086e:	8b 75 08             	mov    0x8(%ebp),%esi
  800871:	8b 55 0c             	mov    0xc(%ebp),%edx
  800874:	89 f3                	mov    %esi,%ebx
  800876:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800879:	89 f0                	mov    %esi,%eax
  80087b:	39 d8                	cmp    %ebx,%eax
  80087d:	74 11                	je     800890 <strncpy+0x2b>
		*dst++ = *src;
  80087f:	83 c0 01             	add    $0x1,%eax
  800882:	0f b6 0a             	movzbl (%edx),%ecx
  800885:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800888:	80 f9 01             	cmp    $0x1,%cl
  80088b:	83 da ff             	sbb    $0xffffffff,%edx
  80088e:	eb eb                	jmp    80087b <strncpy+0x16>
	}
	return ret;
}
  800890:	89 f0                	mov    %esi,%eax
  800892:	5b                   	pop    %ebx
  800893:	5e                   	pop    %esi
  800894:	5d                   	pop    %ebp
  800895:	c3                   	ret    

00800896 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800896:	f3 0f 1e fb          	endbr32 
  80089a:	55                   	push   %ebp
  80089b:	89 e5                	mov    %esp,%ebp
  80089d:	56                   	push   %esi
  80089e:	53                   	push   %ebx
  80089f:	8b 75 08             	mov    0x8(%ebp),%esi
  8008a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008a5:	8b 55 10             	mov    0x10(%ebp),%edx
  8008a8:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008aa:	85 d2                	test   %edx,%edx
  8008ac:	74 21                	je     8008cf <strlcpy+0x39>
  8008ae:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008b2:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008b4:	39 c2                	cmp    %eax,%edx
  8008b6:	74 14                	je     8008cc <strlcpy+0x36>
  8008b8:	0f b6 19             	movzbl (%ecx),%ebx
  8008bb:	84 db                	test   %bl,%bl
  8008bd:	74 0b                	je     8008ca <strlcpy+0x34>
			*dst++ = *src++;
  8008bf:	83 c1 01             	add    $0x1,%ecx
  8008c2:	83 c2 01             	add    $0x1,%edx
  8008c5:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008c8:	eb ea                	jmp    8008b4 <strlcpy+0x1e>
  8008ca:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008cc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008cf:	29 f0                	sub    %esi,%eax
}
  8008d1:	5b                   	pop    %ebx
  8008d2:	5e                   	pop    %esi
  8008d3:	5d                   	pop    %ebp
  8008d4:	c3                   	ret    

008008d5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008d5:	f3 0f 1e fb          	endbr32 
  8008d9:	55                   	push   %ebp
  8008da:	89 e5                	mov    %esp,%ebp
  8008dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008df:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008e2:	0f b6 01             	movzbl (%ecx),%eax
  8008e5:	84 c0                	test   %al,%al
  8008e7:	74 0c                	je     8008f5 <strcmp+0x20>
  8008e9:	3a 02                	cmp    (%edx),%al
  8008eb:	75 08                	jne    8008f5 <strcmp+0x20>
		p++, q++;
  8008ed:	83 c1 01             	add    $0x1,%ecx
  8008f0:	83 c2 01             	add    $0x1,%edx
  8008f3:	eb ed                	jmp    8008e2 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008f5:	0f b6 c0             	movzbl %al,%eax
  8008f8:	0f b6 12             	movzbl (%edx),%edx
  8008fb:	29 d0                	sub    %edx,%eax
}
  8008fd:	5d                   	pop    %ebp
  8008fe:	c3                   	ret    

008008ff <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008ff:	f3 0f 1e fb          	endbr32 
  800903:	55                   	push   %ebp
  800904:	89 e5                	mov    %esp,%ebp
  800906:	53                   	push   %ebx
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090d:	89 c3                	mov    %eax,%ebx
  80090f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800912:	eb 06                	jmp    80091a <strncmp+0x1b>
		n--, p++, q++;
  800914:	83 c0 01             	add    $0x1,%eax
  800917:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80091a:	39 d8                	cmp    %ebx,%eax
  80091c:	74 16                	je     800934 <strncmp+0x35>
  80091e:	0f b6 08             	movzbl (%eax),%ecx
  800921:	84 c9                	test   %cl,%cl
  800923:	74 04                	je     800929 <strncmp+0x2a>
  800925:	3a 0a                	cmp    (%edx),%cl
  800927:	74 eb                	je     800914 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800929:	0f b6 00             	movzbl (%eax),%eax
  80092c:	0f b6 12             	movzbl (%edx),%edx
  80092f:	29 d0                	sub    %edx,%eax
}
  800931:	5b                   	pop    %ebx
  800932:	5d                   	pop    %ebp
  800933:	c3                   	ret    
		return 0;
  800934:	b8 00 00 00 00       	mov    $0x0,%eax
  800939:	eb f6                	jmp    800931 <strncmp+0x32>

0080093b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80093b:	f3 0f 1e fb          	endbr32 
  80093f:	55                   	push   %ebp
  800940:	89 e5                	mov    %esp,%ebp
  800942:	8b 45 08             	mov    0x8(%ebp),%eax
  800945:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800949:	0f b6 10             	movzbl (%eax),%edx
  80094c:	84 d2                	test   %dl,%dl
  80094e:	74 09                	je     800959 <strchr+0x1e>
		if (*s == c)
  800950:	38 ca                	cmp    %cl,%dl
  800952:	74 0a                	je     80095e <strchr+0x23>
	for (; *s; s++)
  800954:	83 c0 01             	add    $0x1,%eax
  800957:	eb f0                	jmp    800949 <strchr+0xe>
			return (char *) s;
	return 0;
  800959:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80095e:	5d                   	pop    %ebp
  80095f:	c3                   	ret    

00800960 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800960:	f3 0f 1e fb          	endbr32 
  800964:	55                   	push   %ebp
  800965:	89 e5                	mov    %esp,%ebp
  800967:	8b 45 08             	mov    0x8(%ebp),%eax
  80096a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80096e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800971:	38 ca                	cmp    %cl,%dl
  800973:	74 09                	je     80097e <strfind+0x1e>
  800975:	84 d2                	test   %dl,%dl
  800977:	74 05                	je     80097e <strfind+0x1e>
	for (; *s; s++)
  800979:	83 c0 01             	add    $0x1,%eax
  80097c:	eb f0                	jmp    80096e <strfind+0xe>
			break;
	return (char *) s;
}
  80097e:	5d                   	pop    %ebp
  80097f:	c3                   	ret    

00800980 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800980:	f3 0f 1e fb          	endbr32 
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
  800987:	57                   	push   %edi
  800988:	56                   	push   %esi
  800989:	53                   	push   %ebx
  80098a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80098d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800990:	85 c9                	test   %ecx,%ecx
  800992:	74 31                	je     8009c5 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800994:	89 f8                	mov    %edi,%eax
  800996:	09 c8                	or     %ecx,%eax
  800998:	a8 03                	test   $0x3,%al
  80099a:	75 23                	jne    8009bf <memset+0x3f>
		c &= 0xFF;
  80099c:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009a0:	89 d3                	mov    %edx,%ebx
  8009a2:	c1 e3 08             	shl    $0x8,%ebx
  8009a5:	89 d0                	mov    %edx,%eax
  8009a7:	c1 e0 18             	shl    $0x18,%eax
  8009aa:	89 d6                	mov    %edx,%esi
  8009ac:	c1 e6 10             	shl    $0x10,%esi
  8009af:	09 f0                	or     %esi,%eax
  8009b1:	09 c2                	or     %eax,%edx
  8009b3:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009b5:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009b8:	89 d0                	mov    %edx,%eax
  8009ba:	fc                   	cld    
  8009bb:	f3 ab                	rep stos %eax,%es:(%edi)
  8009bd:	eb 06                	jmp    8009c5 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c2:	fc                   	cld    
  8009c3:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009c5:	89 f8                	mov    %edi,%eax
  8009c7:	5b                   	pop    %ebx
  8009c8:	5e                   	pop    %esi
  8009c9:	5f                   	pop    %edi
  8009ca:	5d                   	pop    %ebp
  8009cb:	c3                   	ret    

008009cc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009cc:	f3 0f 1e fb          	endbr32 
  8009d0:	55                   	push   %ebp
  8009d1:	89 e5                	mov    %esp,%ebp
  8009d3:	57                   	push   %edi
  8009d4:	56                   	push   %esi
  8009d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009db:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009de:	39 c6                	cmp    %eax,%esi
  8009e0:	73 32                	jae    800a14 <memmove+0x48>
  8009e2:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009e5:	39 c2                	cmp    %eax,%edx
  8009e7:	76 2b                	jbe    800a14 <memmove+0x48>
		s += n;
		d += n;
  8009e9:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009ec:	89 fe                	mov    %edi,%esi
  8009ee:	09 ce                	or     %ecx,%esi
  8009f0:	09 d6                	or     %edx,%esi
  8009f2:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009f8:	75 0e                	jne    800a08 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009fa:	83 ef 04             	sub    $0x4,%edi
  8009fd:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a00:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a03:	fd                   	std    
  800a04:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a06:	eb 09                	jmp    800a11 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a08:	83 ef 01             	sub    $0x1,%edi
  800a0b:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a0e:	fd                   	std    
  800a0f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a11:	fc                   	cld    
  800a12:	eb 1a                	jmp    800a2e <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a14:	89 c2                	mov    %eax,%edx
  800a16:	09 ca                	or     %ecx,%edx
  800a18:	09 f2                	or     %esi,%edx
  800a1a:	f6 c2 03             	test   $0x3,%dl
  800a1d:	75 0a                	jne    800a29 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a1f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a22:	89 c7                	mov    %eax,%edi
  800a24:	fc                   	cld    
  800a25:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a27:	eb 05                	jmp    800a2e <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800a29:	89 c7                	mov    %eax,%edi
  800a2b:	fc                   	cld    
  800a2c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a2e:	5e                   	pop    %esi
  800a2f:	5f                   	pop    %edi
  800a30:	5d                   	pop    %ebp
  800a31:	c3                   	ret    

00800a32 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a32:	f3 0f 1e fb          	endbr32 
  800a36:	55                   	push   %ebp
  800a37:	89 e5                	mov    %esp,%ebp
  800a39:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a3c:	ff 75 10             	pushl  0x10(%ebp)
  800a3f:	ff 75 0c             	pushl  0xc(%ebp)
  800a42:	ff 75 08             	pushl  0x8(%ebp)
  800a45:	e8 82 ff ff ff       	call   8009cc <memmove>
}
  800a4a:	c9                   	leave  
  800a4b:	c3                   	ret    

00800a4c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a4c:	f3 0f 1e fb          	endbr32 
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	56                   	push   %esi
  800a54:	53                   	push   %ebx
  800a55:	8b 45 08             	mov    0x8(%ebp),%eax
  800a58:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a5b:	89 c6                	mov    %eax,%esi
  800a5d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a60:	39 f0                	cmp    %esi,%eax
  800a62:	74 1c                	je     800a80 <memcmp+0x34>
		if (*s1 != *s2)
  800a64:	0f b6 08             	movzbl (%eax),%ecx
  800a67:	0f b6 1a             	movzbl (%edx),%ebx
  800a6a:	38 d9                	cmp    %bl,%cl
  800a6c:	75 08                	jne    800a76 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a6e:	83 c0 01             	add    $0x1,%eax
  800a71:	83 c2 01             	add    $0x1,%edx
  800a74:	eb ea                	jmp    800a60 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a76:	0f b6 c1             	movzbl %cl,%eax
  800a79:	0f b6 db             	movzbl %bl,%ebx
  800a7c:	29 d8                	sub    %ebx,%eax
  800a7e:	eb 05                	jmp    800a85 <memcmp+0x39>
	}

	return 0;
  800a80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a85:	5b                   	pop    %ebx
  800a86:	5e                   	pop    %esi
  800a87:	5d                   	pop    %ebp
  800a88:	c3                   	ret    

00800a89 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a89:	f3 0f 1e fb          	endbr32 
  800a8d:	55                   	push   %ebp
  800a8e:	89 e5                	mov    %esp,%ebp
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a96:	89 c2                	mov    %eax,%edx
  800a98:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a9b:	39 d0                	cmp    %edx,%eax
  800a9d:	73 09                	jae    800aa8 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a9f:	38 08                	cmp    %cl,(%eax)
  800aa1:	74 05                	je     800aa8 <memfind+0x1f>
	for (; s < ends; s++)
  800aa3:	83 c0 01             	add    $0x1,%eax
  800aa6:	eb f3                	jmp    800a9b <memfind+0x12>
			break;
	return (void *) s;
}
  800aa8:	5d                   	pop    %ebp
  800aa9:	c3                   	ret    

00800aaa <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800aaa:	f3 0f 1e fb          	endbr32 
  800aae:	55                   	push   %ebp
  800aaf:	89 e5                	mov    %esp,%ebp
  800ab1:	57                   	push   %edi
  800ab2:	56                   	push   %esi
  800ab3:	53                   	push   %ebx
  800ab4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ab7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aba:	eb 03                	jmp    800abf <strtol+0x15>
		s++;
  800abc:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800abf:	0f b6 01             	movzbl (%ecx),%eax
  800ac2:	3c 20                	cmp    $0x20,%al
  800ac4:	74 f6                	je     800abc <strtol+0x12>
  800ac6:	3c 09                	cmp    $0x9,%al
  800ac8:	74 f2                	je     800abc <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800aca:	3c 2b                	cmp    $0x2b,%al
  800acc:	74 2a                	je     800af8 <strtol+0x4e>
	int neg = 0;
  800ace:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ad3:	3c 2d                	cmp    $0x2d,%al
  800ad5:	74 2b                	je     800b02 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ad7:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800add:	75 0f                	jne    800aee <strtol+0x44>
  800adf:	80 39 30             	cmpb   $0x30,(%ecx)
  800ae2:	74 28                	je     800b0c <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ae4:	85 db                	test   %ebx,%ebx
  800ae6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800aeb:	0f 44 d8             	cmove  %eax,%ebx
  800aee:	b8 00 00 00 00       	mov    $0x0,%eax
  800af3:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800af6:	eb 46                	jmp    800b3e <strtol+0x94>
		s++;
  800af8:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800afb:	bf 00 00 00 00       	mov    $0x0,%edi
  800b00:	eb d5                	jmp    800ad7 <strtol+0x2d>
		s++, neg = 1;
  800b02:	83 c1 01             	add    $0x1,%ecx
  800b05:	bf 01 00 00 00       	mov    $0x1,%edi
  800b0a:	eb cb                	jmp    800ad7 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b0c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b10:	74 0e                	je     800b20 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b12:	85 db                	test   %ebx,%ebx
  800b14:	75 d8                	jne    800aee <strtol+0x44>
		s++, base = 8;
  800b16:	83 c1 01             	add    $0x1,%ecx
  800b19:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b1e:	eb ce                	jmp    800aee <strtol+0x44>
		s += 2, base = 16;
  800b20:	83 c1 02             	add    $0x2,%ecx
  800b23:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b28:	eb c4                	jmp    800aee <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b2a:	0f be d2             	movsbl %dl,%edx
  800b2d:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b30:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b33:	7d 3a                	jge    800b6f <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b35:	83 c1 01             	add    $0x1,%ecx
  800b38:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b3c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b3e:	0f b6 11             	movzbl (%ecx),%edx
  800b41:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b44:	89 f3                	mov    %esi,%ebx
  800b46:	80 fb 09             	cmp    $0x9,%bl
  800b49:	76 df                	jbe    800b2a <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b4b:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b4e:	89 f3                	mov    %esi,%ebx
  800b50:	80 fb 19             	cmp    $0x19,%bl
  800b53:	77 08                	ja     800b5d <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b55:	0f be d2             	movsbl %dl,%edx
  800b58:	83 ea 57             	sub    $0x57,%edx
  800b5b:	eb d3                	jmp    800b30 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b5d:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b60:	89 f3                	mov    %esi,%ebx
  800b62:	80 fb 19             	cmp    $0x19,%bl
  800b65:	77 08                	ja     800b6f <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b67:	0f be d2             	movsbl %dl,%edx
  800b6a:	83 ea 37             	sub    $0x37,%edx
  800b6d:	eb c1                	jmp    800b30 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b73:	74 05                	je     800b7a <strtol+0xd0>
		*endptr = (char *) s;
  800b75:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b78:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b7a:	89 c2                	mov    %eax,%edx
  800b7c:	f7 da                	neg    %edx
  800b7e:	85 ff                	test   %edi,%edi
  800b80:	0f 45 c2             	cmovne %edx,%eax
}
  800b83:	5b                   	pop    %ebx
  800b84:	5e                   	pop    %esi
  800b85:	5f                   	pop    %edi
  800b86:	5d                   	pop    %ebp
  800b87:	c3                   	ret    

00800b88 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b88:	f3 0f 1e fb          	endbr32 
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	57                   	push   %edi
  800b90:	56                   	push   %esi
  800b91:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b92:	b8 00 00 00 00       	mov    $0x0,%eax
  800b97:	8b 55 08             	mov    0x8(%ebp),%edx
  800b9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b9d:	89 c3                	mov    %eax,%ebx
  800b9f:	89 c7                	mov    %eax,%edi
  800ba1:	89 c6                	mov    %eax,%esi
  800ba3:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ba5:	5b                   	pop    %ebx
  800ba6:	5e                   	pop    %esi
  800ba7:	5f                   	pop    %edi
  800ba8:	5d                   	pop    %ebp
  800ba9:	c3                   	ret    

00800baa <sys_cgetc>:

int
sys_cgetc(void)
{
  800baa:	f3 0f 1e fb          	endbr32 
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	57                   	push   %edi
  800bb2:	56                   	push   %esi
  800bb3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bb4:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb9:	b8 01 00 00 00       	mov    $0x1,%eax
  800bbe:	89 d1                	mov    %edx,%ecx
  800bc0:	89 d3                	mov    %edx,%ebx
  800bc2:	89 d7                	mov    %edx,%edi
  800bc4:	89 d6                	mov    %edx,%esi
  800bc6:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bc8:	5b                   	pop    %ebx
  800bc9:	5e                   	pop    %esi
  800bca:	5f                   	pop    %edi
  800bcb:	5d                   	pop    %ebp
  800bcc:	c3                   	ret    

00800bcd <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bcd:	f3 0f 1e fb          	endbr32 
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	57                   	push   %edi
  800bd5:	56                   	push   %esi
  800bd6:	53                   	push   %ebx
  800bd7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bda:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bdf:	8b 55 08             	mov    0x8(%ebp),%edx
  800be2:	b8 03 00 00 00       	mov    $0x3,%eax
  800be7:	89 cb                	mov    %ecx,%ebx
  800be9:	89 cf                	mov    %ecx,%edi
  800beb:	89 ce                	mov    %ecx,%esi
  800bed:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bef:	85 c0                	test   %eax,%eax
  800bf1:	7f 08                	jg     800bfb <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bf3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bf6:	5b                   	pop    %ebx
  800bf7:	5e                   	pop    %esi
  800bf8:	5f                   	pop    %edi
  800bf9:	5d                   	pop    %ebp
  800bfa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bfb:	83 ec 0c             	sub    $0xc,%esp
  800bfe:	50                   	push   %eax
  800bff:	6a 03                	push   $0x3
  800c01:	68 1f 2c 80 00       	push   $0x802c1f
  800c06:	6a 23                	push   $0x23
  800c08:	68 3c 2c 80 00       	push   $0x802c3c
  800c0d:	e8 1b 19 00 00       	call   80252d <_panic>

00800c12 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c12:	f3 0f 1e fb          	endbr32 
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	57                   	push   %edi
  800c1a:	56                   	push   %esi
  800c1b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c1c:	ba 00 00 00 00       	mov    $0x0,%edx
  800c21:	b8 02 00 00 00       	mov    $0x2,%eax
  800c26:	89 d1                	mov    %edx,%ecx
  800c28:	89 d3                	mov    %edx,%ebx
  800c2a:	89 d7                	mov    %edx,%edi
  800c2c:	89 d6                	mov    %edx,%esi
  800c2e:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c30:	5b                   	pop    %ebx
  800c31:	5e                   	pop    %esi
  800c32:	5f                   	pop    %edi
  800c33:	5d                   	pop    %ebp
  800c34:	c3                   	ret    

00800c35 <sys_yield>:

void
sys_yield(void)
{
  800c35:	f3 0f 1e fb          	endbr32 
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
  800c3c:	57                   	push   %edi
  800c3d:	56                   	push   %esi
  800c3e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c3f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c44:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c49:	89 d1                	mov    %edx,%ecx
  800c4b:	89 d3                	mov    %edx,%ebx
  800c4d:	89 d7                	mov    %edx,%edi
  800c4f:	89 d6                	mov    %edx,%esi
  800c51:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c53:	5b                   	pop    %ebx
  800c54:	5e                   	pop    %esi
  800c55:	5f                   	pop    %edi
  800c56:	5d                   	pop    %ebp
  800c57:	c3                   	ret    

00800c58 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c58:	f3 0f 1e fb          	endbr32 
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	57                   	push   %edi
  800c60:	56                   	push   %esi
  800c61:	53                   	push   %ebx
  800c62:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c65:	be 00 00 00 00       	mov    $0x0,%esi
  800c6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c70:	b8 04 00 00 00       	mov    $0x4,%eax
  800c75:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c78:	89 f7                	mov    %esi,%edi
  800c7a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c7c:	85 c0                	test   %eax,%eax
  800c7e:	7f 08                	jg     800c88 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c83:	5b                   	pop    %ebx
  800c84:	5e                   	pop    %esi
  800c85:	5f                   	pop    %edi
  800c86:	5d                   	pop    %ebp
  800c87:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c88:	83 ec 0c             	sub    $0xc,%esp
  800c8b:	50                   	push   %eax
  800c8c:	6a 04                	push   $0x4
  800c8e:	68 1f 2c 80 00       	push   $0x802c1f
  800c93:	6a 23                	push   $0x23
  800c95:	68 3c 2c 80 00       	push   $0x802c3c
  800c9a:	e8 8e 18 00 00       	call   80252d <_panic>

00800c9f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c9f:	f3 0f 1e fb          	endbr32 
  800ca3:	55                   	push   %ebp
  800ca4:	89 e5                	mov    %esp,%ebp
  800ca6:	57                   	push   %edi
  800ca7:	56                   	push   %esi
  800ca8:	53                   	push   %ebx
  800ca9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cac:	8b 55 08             	mov    0x8(%ebp),%edx
  800caf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb2:	b8 05 00 00 00       	mov    $0x5,%eax
  800cb7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cba:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cbd:	8b 75 18             	mov    0x18(%ebp),%esi
  800cc0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc2:	85 c0                	test   %eax,%eax
  800cc4:	7f 08                	jg     800cce <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc9:	5b                   	pop    %ebx
  800cca:	5e                   	pop    %esi
  800ccb:	5f                   	pop    %edi
  800ccc:	5d                   	pop    %ebp
  800ccd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cce:	83 ec 0c             	sub    $0xc,%esp
  800cd1:	50                   	push   %eax
  800cd2:	6a 05                	push   $0x5
  800cd4:	68 1f 2c 80 00       	push   $0x802c1f
  800cd9:	6a 23                	push   $0x23
  800cdb:	68 3c 2c 80 00       	push   $0x802c3c
  800ce0:	e8 48 18 00 00       	call   80252d <_panic>

00800ce5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ce5:	f3 0f 1e fb          	endbr32 
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
  800cec:	57                   	push   %edi
  800ced:	56                   	push   %esi
  800cee:	53                   	push   %ebx
  800cef:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cf7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cfd:	b8 06 00 00 00       	mov    $0x6,%eax
  800d02:	89 df                	mov    %ebx,%edi
  800d04:	89 de                	mov    %ebx,%esi
  800d06:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d08:	85 c0                	test   %eax,%eax
  800d0a:	7f 08                	jg     800d14 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d0f:	5b                   	pop    %ebx
  800d10:	5e                   	pop    %esi
  800d11:	5f                   	pop    %edi
  800d12:	5d                   	pop    %ebp
  800d13:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d14:	83 ec 0c             	sub    $0xc,%esp
  800d17:	50                   	push   %eax
  800d18:	6a 06                	push   $0x6
  800d1a:	68 1f 2c 80 00       	push   $0x802c1f
  800d1f:	6a 23                	push   $0x23
  800d21:	68 3c 2c 80 00       	push   $0x802c3c
  800d26:	e8 02 18 00 00       	call   80252d <_panic>

00800d2b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d2b:	f3 0f 1e fb          	endbr32 
  800d2f:	55                   	push   %ebp
  800d30:	89 e5                	mov    %esp,%ebp
  800d32:	57                   	push   %edi
  800d33:	56                   	push   %esi
  800d34:	53                   	push   %ebx
  800d35:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d38:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d3d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d43:	b8 08 00 00 00       	mov    $0x8,%eax
  800d48:	89 df                	mov    %ebx,%edi
  800d4a:	89 de                	mov    %ebx,%esi
  800d4c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d4e:	85 c0                	test   %eax,%eax
  800d50:	7f 08                	jg     800d5a <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d52:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d55:	5b                   	pop    %ebx
  800d56:	5e                   	pop    %esi
  800d57:	5f                   	pop    %edi
  800d58:	5d                   	pop    %ebp
  800d59:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5a:	83 ec 0c             	sub    $0xc,%esp
  800d5d:	50                   	push   %eax
  800d5e:	6a 08                	push   $0x8
  800d60:	68 1f 2c 80 00       	push   $0x802c1f
  800d65:	6a 23                	push   $0x23
  800d67:	68 3c 2c 80 00       	push   $0x802c3c
  800d6c:	e8 bc 17 00 00       	call   80252d <_panic>

00800d71 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d71:	f3 0f 1e fb          	endbr32 
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
  800d78:	57                   	push   %edi
  800d79:	56                   	push   %esi
  800d7a:	53                   	push   %ebx
  800d7b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d7e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d83:	8b 55 08             	mov    0x8(%ebp),%edx
  800d86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d89:	b8 09 00 00 00       	mov    $0x9,%eax
  800d8e:	89 df                	mov    %ebx,%edi
  800d90:	89 de                	mov    %ebx,%esi
  800d92:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d94:	85 c0                	test   %eax,%eax
  800d96:	7f 08                	jg     800da0 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9b:	5b                   	pop    %ebx
  800d9c:	5e                   	pop    %esi
  800d9d:	5f                   	pop    %edi
  800d9e:	5d                   	pop    %ebp
  800d9f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da0:	83 ec 0c             	sub    $0xc,%esp
  800da3:	50                   	push   %eax
  800da4:	6a 09                	push   $0x9
  800da6:	68 1f 2c 80 00       	push   $0x802c1f
  800dab:	6a 23                	push   $0x23
  800dad:	68 3c 2c 80 00       	push   $0x802c3c
  800db2:	e8 76 17 00 00       	call   80252d <_panic>

00800db7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800db7:	f3 0f 1e fb          	endbr32 
  800dbb:	55                   	push   %ebp
  800dbc:	89 e5                	mov    %esp,%ebp
  800dbe:	57                   	push   %edi
  800dbf:	56                   	push   %esi
  800dc0:	53                   	push   %ebx
  800dc1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dcf:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dd4:	89 df                	mov    %ebx,%edi
  800dd6:	89 de                	mov    %ebx,%esi
  800dd8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dda:	85 c0                	test   %eax,%eax
  800ddc:	7f 08                	jg     800de6 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dde:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de1:	5b                   	pop    %ebx
  800de2:	5e                   	pop    %esi
  800de3:	5f                   	pop    %edi
  800de4:	5d                   	pop    %ebp
  800de5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de6:	83 ec 0c             	sub    $0xc,%esp
  800de9:	50                   	push   %eax
  800dea:	6a 0a                	push   $0xa
  800dec:	68 1f 2c 80 00       	push   $0x802c1f
  800df1:	6a 23                	push   $0x23
  800df3:	68 3c 2c 80 00       	push   $0x802c3c
  800df8:	e8 30 17 00 00       	call   80252d <_panic>

00800dfd <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dfd:	f3 0f 1e fb          	endbr32 
  800e01:	55                   	push   %ebp
  800e02:	89 e5                	mov    %esp,%ebp
  800e04:	57                   	push   %edi
  800e05:	56                   	push   %esi
  800e06:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e07:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0d:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e12:	be 00 00 00 00       	mov    $0x0,%esi
  800e17:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e1a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e1d:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e1f:	5b                   	pop    %ebx
  800e20:	5e                   	pop    %esi
  800e21:	5f                   	pop    %edi
  800e22:	5d                   	pop    %ebp
  800e23:	c3                   	ret    

00800e24 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e24:	f3 0f 1e fb          	endbr32 
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
  800e2b:	57                   	push   %edi
  800e2c:	56                   	push   %esi
  800e2d:	53                   	push   %ebx
  800e2e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e31:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e36:	8b 55 08             	mov    0x8(%ebp),%edx
  800e39:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e3e:	89 cb                	mov    %ecx,%ebx
  800e40:	89 cf                	mov    %ecx,%edi
  800e42:	89 ce                	mov    %ecx,%esi
  800e44:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e46:	85 c0                	test   %eax,%eax
  800e48:	7f 08                	jg     800e52 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e4d:	5b                   	pop    %ebx
  800e4e:	5e                   	pop    %esi
  800e4f:	5f                   	pop    %edi
  800e50:	5d                   	pop    %ebp
  800e51:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e52:	83 ec 0c             	sub    $0xc,%esp
  800e55:	50                   	push   %eax
  800e56:	6a 0d                	push   $0xd
  800e58:	68 1f 2c 80 00       	push   $0x802c1f
  800e5d:	6a 23                	push   $0x23
  800e5f:	68 3c 2c 80 00       	push   $0x802c3c
  800e64:	e8 c4 16 00 00       	call   80252d <_panic>

00800e69 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e69:	f3 0f 1e fb          	endbr32 
  800e6d:	55                   	push   %ebp
  800e6e:	89 e5                	mov    %esp,%ebp
  800e70:	57                   	push   %edi
  800e71:	56                   	push   %esi
  800e72:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e73:	ba 00 00 00 00       	mov    $0x0,%edx
  800e78:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e7d:	89 d1                	mov    %edx,%ecx
  800e7f:	89 d3                	mov    %edx,%ebx
  800e81:	89 d7                	mov    %edx,%edi
  800e83:	89 d6                	mov    %edx,%esi
  800e85:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e87:	5b                   	pop    %ebx
  800e88:	5e                   	pop    %esi
  800e89:	5f                   	pop    %edi
  800e8a:	5d                   	pop    %ebp
  800e8b:	c3                   	ret    

00800e8c <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  800e8c:	f3 0f 1e fb          	endbr32 
  800e90:	55                   	push   %ebp
  800e91:	89 e5                	mov    %esp,%ebp
  800e93:	57                   	push   %edi
  800e94:	56                   	push   %esi
  800e95:	53                   	push   %ebx
  800e96:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e99:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea4:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ea9:	89 df                	mov    %ebx,%edi
  800eab:	89 de                	mov    %ebx,%esi
  800ead:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eaf:	85 c0                	test   %eax,%eax
  800eb1:	7f 08                	jg     800ebb <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  800eb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb6:	5b                   	pop    %ebx
  800eb7:	5e                   	pop    %esi
  800eb8:	5f                   	pop    %edi
  800eb9:	5d                   	pop    %ebp
  800eba:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ebb:	83 ec 0c             	sub    $0xc,%esp
  800ebe:	50                   	push   %eax
  800ebf:	6a 0f                	push   $0xf
  800ec1:	68 1f 2c 80 00       	push   $0x802c1f
  800ec6:	6a 23                	push   $0x23
  800ec8:	68 3c 2c 80 00       	push   $0x802c3c
  800ecd:	e8 5b 16 00 00       	call   80252d <_panic>

00800ed2 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  800ed2:	f3 0f 1e fb          	endbr32 
  800ed6:	55                   	push   %ebp
  800ed7:	89 e5                	mov    %esp,%ebp
  800ed9:	57                   	push   %edi
  800eda:	56                   	push   %esi
  800edb:	53                   	push   %ebx
  800edc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800edf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eea:	b8 10 00 00 00       	mov    $0x10,%eax
  800eef:	89 df                	mov    %ebx,%edi
  800ef1:	89 de                	mov    %ebx,%esi
  800ef3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef5:	85 c0                	test   %eax,%eax
  800ef7:	7f 08                	jg     800f01 <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  800ef9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800efc:	5b                   	pop    %ebx
  800efd:	5e                   	pop    %esi
  800efe:	5f                   	pop    %edi
  800eff:	5d                   	pop    %ebp
  800f00:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f01:	83 ec 0c             	sub    $0xc,%esp
  800f04:	50                   	push   %eax
  800f05:	6a 10                	push   $0x10
  800f07:	68 1f 2c 80 00       	push   $0x802c1f
  800f0c:	6a 23                	push   $0x23
  800f0e:	68 3c 2c 80 00       	push   $0x802c3c
  800f13:	e8 15 16 00 00       	call   80252d <_panic>

00800f18 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f18:	f3 0f 1e fb          	endbr32 
  800f1c:	55                   	push   %ebp
  800f1d:	89 e5                	mov    %esp,%ebp
  800f1f:	53                   	push   %ebx
  800f20:	83 ec 04             	sub    $0x4,%esp
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800f26:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  800f28:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f2c:	74 74                	je     800fa2 <pgfault+0x8a>
  800f2e:	89 d8                	mov    %ebx,%eax
  800f30:	c1 e8 0c             	shr    $0xc,%eax
  800f33:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f3a:	f6 c4 08             	test   $0x8,%ah
  800f3d:	74 63                	je     800fa2 <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800f3f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  800f45:	83 ec 0c             	sub    $0xc,%esp
  800f48:	6a 05                	push   $0x5
  800f4a:	68 00 f0 7f 00       	push   $0x7ff000
  800f4f:	6a 00                	push   $0x0
  800f51:	53                   	push   %ebx
  800f52:	6a 00                	push   $0x0
  800f54:	e8 46 fd ff ff       	call   800c9f <sys_page_map>
  800f59:	83 c4 20             	add    $0x20,%esp
  800f5c:	85 c0                	test   %eax,%eax
  800f5e:	78 59                	js     800fb9 <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  800f60:	83 ec 04             	sub    $0x4,%esp
  800f63:	6a 07                	push   $0x7
  800f65:	53                   	push   %ebx
  800f66:	6a 00                	push   $0x0
  800f68:	e8 eb fc ff ff       	call   800c58 <sys_page_alloc>
  800f6d:	83 c4 10             	add    $0x10,%esp
  800f70:	85 c0                	test   %eax,%eax
  800f72:	78 5a                	js     800fce <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  800f74:	83 ec 04             	sub    $0x4,%esp
  800f77:	68 00 10 00 00       	push   $0x1000
  800f7c:	68 00 f0 7f 00       	push   $0x7ff000
  800f81:	53                   	push   %ebx
  800f82:	e8 45 fa ff ff       	call   8009cc <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  800f87:	83 c4 08             	add    $0x8,%esp
  800f8a:	68 00 f0 7f 00       	push   $0x7ff000
  800f8f:	6a 00                	push   $0x0
  800f91:	e8 4f fd ff ff       	call   800ce5 <sys_page_unmap>
  800f96:	83 c4 10             	add    $0x10,%esp
  800f99:	85 c0                	test   %eax,%eax
  800f9b:	78 46                	js     800fe3 <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  800f9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fa0:	c9                   	leave  
  800fa1:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  800fa2:	83 ec 04             	sub    $0x4,%esp
  800fa5:	68 4a 2c 80 00       	push   $0x802c4a
  800faa:	68 d3 00 00 00       	push   $0xd3
  800faf:	68 66 2c 80 00       	push   $0x802c66
  800fb4:	e8 74 15 00 00       	call   80252d <_panic>
		panic("pgfault: %e\n", r);
  800fb9:	50                   	push   %eax
  800fba:	68 71 2c 80 00       	push   $0x802c71
  800fbf:	68 df 00 00 00       	push   $0xdf
  800fc4:	68 66 2c 80 00       	push   $0x802c66
  800fc9:	e8 5f 15 00 00       	call   80252d <_panic>
		panic("pgfault: %e\n", r);
  800fce:	50                   	push   %eax
  800fcf:	68 71 2c 80 00       	push   $0x802c71
  800fd4:	68 e3 00 00 00       	push   $0xe3
  800fd9:	68 66 2c 80 00       	push   $0x802c66
  800fde:	e8 4a 15 00 00       	call   80252d <_panic>
		panic("pgfault: %e\n", r);
  800fe3:	50                   	push   %eax
  800fe4:	68 71 2c 80 00       	push   $0x802c71
  800fe9:	68 e9 00 00 00       	push   $0xe9
  800fee:	68 66 2c 80 00       	push   $0x802c66
  800ff3:	e8 35 15 00 00       	call   80252d <_panic>

00800ff8 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800ff8:	f3 0f 1e fb          	endbr32 
  800ffc:	55                   	push   %ebp
  800ffd:	89 e5                	mov    %esp,%ebp
  800fff:	57                   	push   %edi
  801000:	56                   	push   %esi
  801001:	53                   	push   %ebx
  801002:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  801005:	68 18 0f 80 00       	push   $0x800f18
  80100a:	e8 68 15 00 00       	call   802577 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80100f:	b8 07 00 00 00       	mov    $0x7,%eax
  801014:	cd 30                	int    $0x30
  801016:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  801019:	83 c4 10             	add    $0x10,%esp
  80101c:	85 c0                	test   %eax,%eax
  80101e:	78 2d                	js     80104d <fork+0x55>
  801020:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801022:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  801027:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80102b:	0f 85 9b 00 00 00    	jne    8010cc <fork+0xd4>
		thisenv = &envs[ENVX(sys_getenvid())];
  801031:	e8 dc fb ff ff       	call   800c12 <sys_getenvid>
  801036:	25 ff 03 00 00       	and    $0x3ff,%eax
  80103b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80103e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801043:	a3 0c 40 80 00       	mov    %eax,0x80400c
		return 0;
  801048:	e9 71 01 00 00       	jmp    8011be <fork+0x1c6>
		panic("sys_exofork: %e", envid);
  80104d:	50                   	push   %eax
  80104e:	68 7e 2c 80 00       	push   $0x802c7e
  801053:	68 2a 01 00 00       	push   $0x12a
  801058:	68 66 2c 80 00       	push   $0x802c66
  80105d:	e8 cb 14 00 00       	call   80252d <_panic>
		sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_SYSCALL);
  801062:	c1 e6 0c             	shl    $0xc,%esi
  801065:	83 ec 0c             	sub    $0xc,%esp
  801068:	68 07 0e 00 00       	push   $0xe07
  80106d:	56                   	push   %esi
  80106e:	57                   	push   %edi
  80106f:	56                   	push   %esi
  801070:	6a 00                	push   $0x0
  801072:	e8 28 fc ff ff       	call   800c9f <sys_page_map>
  801077:	83 c4 20             	add    $0x20,%esp
  80107a:	eb 3e                	jmp    8010ba <fork+0xc2>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  80107c:	c1 e6 0c             	shl    $0xc,%esi
  80107f:	83 ec 0c             	sub    $0xc,%esp
  801082:	68 05 08 00 00       	push   $0x805
  801087:	56                   	push   %esi
  801088:	57                   	push   %edi
  801089:	56                   	push   %esi
  80108a:	6a 00                	push   $0x0
  80108c:	e8 0e fc ff ff       	call   800c9f <sys_page_map>
  801091:	83 c4 20             	add    $0x20,%esp
  801094:	85 c0                	test   %eax,%eax
  801096:	0f 88 bc 00 00 00    	js     801158 <fork+0x160>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  80109c:	83 ec 0c             	sub    $0xc,%esp
  80109f:	68 05 08 00 00       	push   $0x805
  8010a4:	56                   	push   %esi
  8010a5:	6a 00                	push   $0x0
  8010a7:	56                   	push   %esi
  8010a8:	6a 00                	push   $0x0
  8010aa:	e8 f0 fb ff ff       	call   800c9f <sys_page_map>
  8010af:	83 c4 20             	add    $0x20,%esp
  8010b2:	85 c0                	test   %eax,%eax
  8010b4:	0f 88 b3 00 00 00    	js     80116d <fork+0x175>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8010ba:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8010c0:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8010c6:	0f 84 b6 00 00 00    	je     801182 <fork+0x18a>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  8010cc:	89 d8                	mov    %ebx,%eax
  8010ce:	c1 e8 16             	shr    $0x16,%eax
  8010d1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010d8:	a8 01                	test   $0x1,%al
  8010da:	74 de                	je     8010ba <fork+0xc2>
  8010dc:	89 de                	mov    %ebx,%esi
  8010de:	c1 ee 0c             	shr    $0xc,%esi
  8010e1:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010e8:	a8 01                	test   $0x1,%al
  8010ea:	74 ce                	je     8010ba <fork+0xc2>
  8010ec:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010f3:	a8 04                	test   $0x4,%al
  8010f5:	74 c3                	je     8010ba <fork+0xc2>
	if ((uvpt[pn] & PTE_SHARE)){
  8010f7:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010fe:	f6 c4 04             	test   $0x4,%ah
  801101:	0f 85 5b ff ff ff    	jne    801062 <fork+0x6a>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  801107:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80110e:	a8 02                	test   $0x2,%al
  801110:	0f 85 66 ff ff ff    	jne    80107c <fork+0x84>
  801116:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80111d:	f6 c4 08             	test   $0x8,%ah
  801120:	0f 85 56 ff ff ff    	jne    80107c <fork+0x84>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  801126:	c1 e6 0c             	shl    $0xc,%esi
  801129:	83 ec 0c             	sub    $0xc,%esp
  80112c:	6a 05                	push   $0x5
  80112e:	56                   	push   %esi
  80112f:	57                   	push   %edi
  801130:	56                   	push   %esi
  801131:	6a 00                	push   $0x0
  801133:	e8 67 fb ff ff       	call   800c9f <sys_page_map>
  801138:	83 c4 20             	add    $0x20,%esp
  80113b:	85 c0                	test   %eax,%eax
  80113d:	0f 89 77 ff ff ff    	jns    8010ba <fork+0xc2>
		panic("duppage: %e\n", r);
  801143:	50                   	push   %eax
  801144:	68 8e 2c 80 00       	push   $0x802c8e
  801149:	68 0c 01 00 00       	push   $0x10c
  80114e:	68 66 2c 80 00       	push   $0x802c66
  801153:	e8 d5 13 00 00       	call   80252d <_panic>
			panic("duppage: %e\n", r);
  801158:	50                   	push   %eax
  801159:	68 8e 2c 80 00       	push   $0x802c8e
  80115e:	68 05 01 00 00       	push   $0x105
  801163:	68 66 2c 80 00       	push   $0x802c66
  801168:	e8 c0 13 00 00       	call   80252d <_panic>
			panic("duppage: %e\n", r);
  80116d:	50                   	push   %eax
  80116e:	68 8e 2c 80 00       	push   $0x802c8e
  801173:	68 09 01 00 00       	push   $0x109
  801178:	68 66 2c 80 00       	push   $0x802c66
  80117d:	e8 ab 13 00 00       	call   80252d <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  801182:	83 ec 04             	sub    $0x4,%esp
  801185:	6a 07                	push   $0x7
  801187:	68 00 f0 bf ee       	push   $0xeebff000
  80118c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80118f:	e8 c4 fa ff ff       	call   800c58 <sys_page_alloc>
  801194:	83 c4 10             	add    $0x10,%esp
  801197:	85 c0                	test   %eax,%eax
  801199:	78 2e                	js     8011c9 <fork+0x1d1>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  80119b:	83 ec 08             	sub    $0x8,%esp
  80119e:	68 ea 25 80 00       	push   $0x8025ea
  8011a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8011a6:	57                   	push   %edi
  8011a7:	e8 0b fc ff ff       	call   800db7 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8011ac:	83 c4 08             	add    $0x8,%esp
  8011af:	6a 02                	push   $0x2
  8011b1:	57                   	push   %edi
  8011b2:	e8 74 fb ff ff       	call   800d2b <sys_env_set_status>
  8011b7:	83 c4 10             	add    $0x10,%esp
  8011ba:	85 c0                	test   %eax,%eax
  8011bc:	78 20                	js     8011de <fork+0x1e6>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  8011be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011c4:	5b                   	pop    %ebx
  8011c5:	5e                   	pop    %esi
  8011c6:	5f                   	pop    %edi
  8011c7:	5d                   	pop    %ebp
  8011c8:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  8011c9:	50                   	push   %eax
  8011ca:	68 9b 2c 80 00       	push   $0x802c9b
  8011cf:	68 3e 01 00 00       	push   $0x13e
  8011d4:	68 66 2c 80 00       	push   $0x802c66
  8011d9:	e8 4f 13 00 00       	call   80252d <_panic>
		panic("sys_env_set_status: %e", r);
  8011de:	50                   	push   %eax
  8011df:	68 ae 2c 80 00       	push   $0x802cae
  8011e4:	68 43 01 00 00       	push   $0x143
  8011e9:	68 66 2c 80 00       	push   $0x802c66
  8011ee:	e8 3a 13 00 00       	call   80252d <_panic>

008011f3 <sfork>:

// Challenge!
int
sfork(void)
{
  8011f3:	f3 0f 1e fb          	endbr32 
  8011f7:	55                   	push   %ebp
  8011f8:	89 e5                	mov    %esp,%ebp
  8011fa:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8011fd:	68 c5 2c 80 00       	push   $0x802cc5
  801202:	68 4c 01 00 00       	push   $0x14c
  801207:	68 66 2c 80 00       	push   $0x802c66
  80120c:	e8 1c 13 00 00       	call   80252d <_panic>

00801211 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801211:	f3 0f 1e fb          	endbr32 
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
  801218:	56                   	push   %esi
  801219:	53                   	push   %ebx
  80121a:	8b 75 08             	mov    0x8(%ebp),%esi
  80121d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801220:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  801223:	85 c0                	test   %eax,%eax
  801225:	74 3d                	je     801264 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  801227:	83 ec 0c             	sub    $0xc,%esp
  80122a:	50                   	push   %eax
  80122b:	e8 f4 fb ff ff       	call   800e24 <sys_ipc_recv>
  801230:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  801233:	85 f6                	test   %esi,%esi
  801235:	74 0b                	je     801242 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801237:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  80123d:	8b 52 74             	mov    0x74(%edx),%edx
  801240:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801242:	85 db                	test   %ebx,%ebx
  801244:	74 0b                	je     801251 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  801246:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  80124c:	8b 52 78             	mov    0x78(%edx),%edx
  80124f:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  801251:	85 c0                	test   %eax,%eax
  801253:	78 21                	js     801276 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  801255:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80125a:	8b 40 70             	mov    0x70(%eax),%eax
}
  80125d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801260:	5b                   	pop    %ebx
  801261:	5e                   	pop    %esi
  801262:	5d                   	pop    %ebp
  801263:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  801264:	83 ec 0c             	sub    $0xc,%esp
  801267:	68 00 00 c0 ee       	push   $0xeec00000
  80126c:	e8 b3 fb ff ff       	call   800e24 <sys_ipc_recv>
  801271:	83 c4 10             	add    $0x10,%esp
  801274:	eb bd                	jmp    801233 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  801276:	85 f6                	test   %esi,%esi
  801278:	74 10                	je     80128a <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  80127a:	85 db                	test   %ebx,%ebx
  80127c:	75 df                	jne    80125d <ipc_recv+0x4c>
  80127e:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801285:	00 00 00 
  801288:	eb d3                	jmp    80125d <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  80128a:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801291:	00 00 00 
  801294:	eb e4                	jmp    80127a <ipc_recv+0x69>

00801296 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801296:	f3 0f 1e fb          	endbr32 
  80129a:	55                   	push   %ebp
  80129b:	89 e5                	mov    %esp,%ebp
  80129d:	57                   	push   %edi
  80129e:	56                   	push   %esi
  80129f:	53                   	push   %ebx
  8012a0:	83 ec 0c             	sub    $0xc,%esp
  8012a3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012a6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  8012ac:	85 db                	test   %ebx,%ebx
  8012ae:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8012b3:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  8012b6:	ff 75 14             	pushl  0x14(%ebp)
  8012b9:	53                   	push   %ebx
  8012ba:	56                   	push   %esi
  8012bb:	57                   	push   %edi
  8012bc:	e8 3c fb ff ff       	call   800dfd <sys_ipc_try_send>
  8012c1:	83 c4 10             	add    $0x10,%esp
  8012c4:	85 c0                	test   %eax,%eax
  8012c6:	79 1e                	jns    8012e6 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  8012c8:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8012cb:	75 07                	jne    8012d4 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  8012cd:	e8 63 f9 ff ff       	call   800c35 <sys_yield>
  8012d2:	eb e2                	jmp    8012b6 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  8012d4:	50                   	push   %eax
  8012d5:	68 db 2c 80 00       	push   $0x802cdb
  8012da:	6a 59                	push   $0x59
  8012dc:	68 f6 2c 80 00       	push   $0x802cf6
  8012e1:	e8 47 12 00 00       	call   80252d <_panic>
	}
}
  8012e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012e9:	5b                   	pop    %ebx
  8012ea:	5e                   	pop    %esi
  8012eb:	5f                   	pop    %edi
  8012ec:	5d                   	pop    %ebp
  8012ed:	c3                   	ret    

008012ee <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8012ee:	f3 0f 1e fb          	endbr32 
  8012f2:	55                   	push   %ebp
  8012f3:	89 e5                	mov    %esp,%ebp
  8012f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8012f8:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8012fd:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801300:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801306:	8b 52 50             	mov    0x50(%edx),%edx
  801309:	39 ca                	cmp    %ecx,%edx
  80130b:	74 11                	je     80131e <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80130d:	83 c0 01             	add    $0x1,%eax
  801310:	3d 00 04 00 00       	cmp    $0x400,%eax
  801315:	75 e6                	jne    8012fd <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801317:	b8 00 00 00 00       	mov    $0x0,%eax
  80131c:	eb 0b                	jmp    801329 <ipc_find_env+0x3b>
			return envs[i].env_id;
  80131e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801321:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801326:	8b 40 48             	mov    0x48(%eax),%eax
}
  801329:	5d                   	pop    %ebp
  80132a:	c3                   	ret    

0080132b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80132b:	f3 0f 1e fb          	endbr32 
  80132f:	55                   	push   %ebp
  801330:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
  801335:	05 00 00 00 30       	add    $0x30000000,%eax
  80133a:	c1 e8 0c             	shr    $0xc,%eax
}
  80133d:	5d                   	pop    %ebp
  80133e:	c3                   	ret    

0080133f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80133f:	f3 0f 1e fb          	endbr32 
  801343:	55                   	push   %ebp
  801344:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801346:	8b 45 08             	mov    0x8(%ebp),%eax
  801349:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80134e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801353:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801358:	5d                   	pop    %ebp
  801359:	c3                   	ret    

0080135a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80135a:	f3 0f 1e fb          	endbr32 
  80135e:	55                   	push   %ebp
  80135f:	89 e5                	mov    %esp,%ebp
  801361:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801366:	89 c2                	mov    %eax,%edx
  801368:	c1 ea 16             	shr    $0x16,%edx
  80136b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801372:	f6 c2 01             	test   $0x1,%dl
  801375:	74 2d                	je     8013a4 <fd_alloc+0x4a>
  801377:	89 c2                	mov    %eax,%edx
  801379:	c1 ea 0c             	shr    $0xc,%edx
  80137c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801383:	f6 c2 01             	test   $0x1,%dl
  801386:	74 1c                	je     8013a4 <fd_alloc+0x4a>
  801388:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80138d:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801392:	75 d2                	jne    801366 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801394:	8b 45 08             	mov    0x8(%ebp),%eax
  801397:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80139d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8013a2:	eb 0a                	jmp    8013ae <fd_alloc+0x54>
			*fd_store = fd;
  8013a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013a7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ae:	5d                   	pop    %ebp
  8013af:	c3                   	ret    

008013b0 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8013b0:	f3 0f 1e fb          	endbr32 
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
  8013b7:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8013ba:	83 f8 1f             	cmp    $0x1f,%eax
  8013bd:	77 30                	ja     8013ef <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8013bf:	c1 e0 0c             	shl    $0xc,%eax
  8013c2:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8013c7:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8013cd:	f6 c2 01             	test   $0x1,%dl
  8013d0:	74 24                	je     8013f6 <fd_lookup+0x46>
  8013d2:	89 c2                	mov    %eax,%edx
  8013d4:	c1 ea 0c             	shr    $0xc,%edx
  8013d7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013de:	f6 c2 01             	test   $0x1,%dl
  8013e1:	74 1a                	je     8013fd <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8013e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e6:	89 02                	mov    %eax,(%edx)
	return 0;
  8013e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ed:	5d                   	pop    %ebp
  8013ee:	c3                   	ret    
		return -E_INVAL;
  8013ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013f4:	eb f7                	jmp    8013ed <fd_lookup+0x3d>
		return -E_INVAL;
  8013f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013fb:	eb f0                	jmp    8013ed <fd_lookup+0x3d>
  8013fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801402:	eb e9                	jmp    8013ed <fd_lookup+0x3d>

00801404 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801404:	f3 0f 1e fb          	endbr32 
  801408:	55                   	push   %ebp
  801409:	89 e5                	mov    %esp,%ebp
  80140b:	83 ec 08             	sub    $0x8,%esp
  80140e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801411:	ba 00 00 00 00       	mov    $0x0,%edx
  801416:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80141b:	39 08                	cmp    %ecx,(%eax)
  80141d:	74 38                	je     801457 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  80141f:	83 c2 01             	add    $0x1,%edx
  801422:	8b 04 95 7c 2d 80 00 	mov    0x802d7c(,%edx,4),%eax
  801429:	85 c0                	test   %eax,%eax
  80142b:	75 ee                	jne    80141b <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80142d:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801432:	8b 40 48             	mov    0x48(%eax),%eax
  801435:	83 ec 04             	sub    $0x4,%esp
  801438:	51                   	push   %ecx
  801439:	50                   	push   %eax
  80143a:	68 00 2d 80 00       	push   $0x802d00
  80143f:	e8 c8 ed ff ff       	call   80020c <cprintf>
	*dev = 0;
  801444:	8b 45 0c             	mov    0xc(%ebp),%eax
  801447:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80144d:	83 c4 10             	add    $0x10,%esp
  801450:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801455:	c9                   	leave  
  801456:	c3                   	ret    
			*dev = devtab[i];
  801457:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80145a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80145c:	b8 00 00 00 00       	mov    $0x0,%eax
  801461:	eb f2                	jmp    801455 <dev_lookup+0x51>

00801463 <fd_close>:
{
  801463:	f3 0f 1e fb          	endbr32 
  801467:	55                   	push   %ebp
  801468:	89 e5                	mov    %esp,%ebp
  80146a:	57                   	push   %edi
  80146b:	56                   	push   %esi
  80146c:	53                   	push   %ebx
  80146d:	83 ec 24             	sub    $0x24,%esp
  801470:	8b 75 08             	mov    0x8(%ebp),%esi
  801473:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801476:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801479:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80147a:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801480:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801483:	50                   	push   %eax
  801484:	e8 27 ff ff ff       	call   8013b0 <fd_lookup>
  801489:	89 c3                	mov    %eax,%ebx
  80148b:	83 c4 10             	add    $0x10,%esp
  80148e:	85 c0                	test   %eax,%eax
  801490:	78 05                	js     801497 <fd_close+0x34>
	    || fd != fd2)
  801492:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801495:	74 16                	je     8014ad <fd_close+0x4a>
		return (must_exist ? r : 0);
  801497:	89 f8                	mov    %edi,%eax
  801499:	84 c0                	test   %al,%al
  80149b:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a0:	0f 44 d8             	cmove  %eax,%ebx
}
  8014a3:	89 d8                	mov    %ebx,%eax
  8014a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014a8:	5b                   	pop    %ebx
  8014a9:	5e                   	pop    %esi
  8014aa:	5f                   	pop    %edi
  8014ab:	5d                   	pop    %ebp
  8014ac:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8014ad:	83 ec 08             	sub    $0x8,%esp
  8014b0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8014b3:	50                   	push   %eax
  8014b4:	ff 36                	pushl  (%esi)
  8014b6:	e8 49 ff ff ff       	call   801404 <dev_lookup>
  8014bb:	89 c3                	mov    %eax,%ebx
  8014bd:	83 c4 10             	add    $0x10,%esp
  8014c0:	85 c0                	test   %eax,%eax
  8014c2:	78 1a                	js     8014de <fd_close+0x7b>
		if (dev->dev_close)
  8014c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014c7:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8014ca:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8014cf:	85 c0                	test   %eax,%eax
  8014d1:	74 0b                	je     8014de <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8014d3:	83 ec 0c             	sub    $0xc,%esp
  8014d6:	56                   	push   %esi
  8014d7:	ff d0                	call   *%eax
  8014d9:	89 c3                	mov    %eax,%ebx
  8014db:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8014de:	83 ec 08             	sub    $0x8,%esp
  8014e1:	56                   	push   %esi
  8014e2:	6a 00                	push   $0x0
  8014e4:	e8 fc f7 ff ff       	call   800ce5 <sys_page_unmap>
	return r;
  8014e9:	83 c4 10             	add    $0x10,%esp
  8014ec:	eb b5                	jmp    8014a3 <fd_close+0x40>

008014ee <close>:

int
close(int fdnum)
{
  8014ee:	f3 0f 1e fb          	endbr32 
  8014f2:	55                   	push   %ebp
  8014f3:	89 e5                	mov    %esp,%ebp
  8014f5:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014fb:	50                   	push   %eax
  8014fc:	ff 75 08             	pushl  0x8(%ebp)
  8014ff:	e8 ac fe ff ff       	call   8013b0 <fd_lookup>
  801504:	83 c4 10             	add    $0x10,%esp
  801507:	85 c0                	test   %eax,%eax
  801509:	79 02                	jns    80150d <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80150b:	c9                   	leave  
  80150c:	c3                   	ret    
		return fd_close(fd, 1);
  80150d:	83 ec 08             	sub    $0x8,%esp
  801510:	6a 01                	push   $0x1
  801512:	ff 75 f4             	pushl  -0xc(%ebp)
  801515:	e8 49 ff ff ff       	call   801463 <fd_close>
  80151a:	83 c4 10             	add    $0x10,%esp
  80151d:	eb ec                	jmp    80150b <close+0x1d>

0080151f <close_all>:

void
close_all(void)
{
  80151f:	f3 0f 1e fb          	endbr32 
  801523:	55                   	push   %ebp
  801524:	89 e5                	mov    %esp,%ebp
  801526:	53                   	push   %ebx
  801527:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80152a:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80152f:	83 ec 0c             	sub    $0xc,%esp
  801532:	53                   	push   %ebx
  801533:	e8 b6 ff ff ff       	call   8014ee <close>
	for (i = 0; i < MAXFD; i++)
  801538:	83 c3 01             	add    $0x1,%ebx
  80153b:	83 c4 10             	add    $0x10,%esp
  80153e:	83 fb 20             	cmp    $0x20,%ebx
  801541:	75 ec                	jne    80152f <close_all+0x10>
}
  801543:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801546:	c9                   	leave  
  801547:	c3                   	ret    

00801548 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801548:	f3 0f 1e fb          	endbr32 
  80154c:	55                   	push   %ebp
  80154d:	89 e5                	mov    %esp,%ebp
  80154f:	57                   	push   %edi
  801550:	56                   	push   %esi
  801551:	53                   	push   %ebx
  801552:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801555:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801558:	50                   	push   %eax
  801559:	ff 75 08             	pushl  0x8(%ebp)
  80155c:	e8 4f fe ff ff       	call   8013b0 <fd_lookup>
  801561:	89 c3                	mov    %eax,%ebx
  801563:	83 c4 10             	add    $0x10,%esp
  801566:	85 c0                	test   %eax,%eax
  801568:	0f 88 81 00 00 00    	js     8015ef <dup+0xa7>
		return r;
	close(newfdnum);
  80156e:	83 ec 0c             	sub    $0xc,%esp
  801571:	ff 75 0c             	pushl  0xc(%ebp)
  801574:	e8 75 ff ff ff       	call   8014ee <close>

	newfd = INDEX2FD(newfdnum);
  801579:	8b 75 0c             	mov    0xc(%ebp),%esi
  80157c:	c1 e6 0c             	shl    $0xc,%esi
  80157f:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801585:	83 c4 04             	add    $0x4,%esp
  801588:	ff 75 e4             	pushl  -0x1c(%ebp)
  80158b:	e8 af fd ff ff       	call   80133f <fd2data>
  801590:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801592:	89 34 24             	mov    %esi,(%esp)
  801595:	e8 a5 fd ff ff       	call   80133f <fd2data>
  80159a:	83 c4 10             	add    $0x10,%esp
  80159d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80159f:	89 d8                	mov    %ebx,%eax
  8015a1:	c1 e8 16             	shr    $0x16,%eax
  8015a4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015ab:	a8 01                	test   $0x1,%al
  8015ad:	74 11                	je     8015c0 <dup+0x78>
  8015af:	89 d8                	mov    %ebx,%eax
  8015b1:	c1 e8 0c             	shr    $0xc,%eax
  8015b4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8015bb:	f6 c2 01             	test   $0x1,%dl
  8015be:	75 39                	jne    8015f9 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015c3:	89 d0                	mov    %edx,%eax
  8015c5:	c1 e8 0c             	shr    $0xc,%eax
  8015c8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015cf:	83 ec 0c             	sub    $0xc,%esp
  8015d2:	25 07 0e 00 00       	and    $0xe07,%eax
  8015d7:	50                   	push   %eax
  8015d8:	56                   	push   %esi
  8015d9:	6a 00                	push   $0x0
  8015db:	52                   	push   %edx
  8015dc:	6a 00                	push   $0x0
  8015de:	e8 bc f6 ff ff       	call   800c9f <sys_page_map>
  8015e3:	89 c3                	mov    %eax,%ebx
  8015e5:	83 c4 20             	add    $0x20,%esp
  8015e8:	85 c0                	test   %eax,%eax
  8015ea:	78 31                	js     80161d <dup+0xd5>
		goto err;

	return newfdnum;
  8015ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8015ef:	89 d8                	mov    %ebx,%eax
  8015f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015f4:	5b                   	pop    %ebx
  8015f5:	5e                   	pop    %esi
  8015f6:	5f                   	pop    %edi
  8015f7:	5d                   	pop    %ebp
  8015f8:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015f9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801600:	83 ec 0c             	sub    $0xc,%esp
  801603:	25 07 0e 00 00       	and    $0xe07,%eax
  801608:	50                   	push   %eax
  801609:	57                   	push   %edi
  80160a:	6a 00                	push   $0x0
  80160c:	53                   	push   %ebx
  80160d:	6a 00                	push   $0x0
  80160f:	e8 8b f6 ff ff       	call   800c9f <sys_page_map>
  801614:	89 c3                	mov    %eax,%ebx
  801616:	83 c4 20             	add    $0x20,%esp
  801619:	85 c0                	test   %eax,%eax
  80161b:	79 a3                	jns    8015c0 <dup+0x78>
	sys_page_unmap(0, newfd);
  80161d:	83 ec 08             	sub    $0x8,%esp
  801620:	56                   	push   %esi
  801621:	6a 00                	push   $0x0
  801623:	e8 bd f6 ff ff       	call   800ce5 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801628:	83 c4 08             	add    $0x8,%esp
  80162b:	57                   	push   %edi
  80162c:	6a 00                	push   $0x0
  80162e:	e8 b2 f6 ff ff       	call   800ce5 <sys_page_unmap>
	return r;
  801633:	83 c4 10             	add    $0x10,%esp
  801636:	eb b7                	jmp    8015ef <dup+0xa7>

00801638 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801638:	f3 0f 1e fb          	endbr32 
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
  80163f:	53                   	push   %ebx
  801640:	83 ec 1c             	sub    $0x1c,%esp
  801643:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801646:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801649:	50                   	push   %eax
  80164a:	53                   	push   %ebx
  80164b:	e8 60 fd ff ff       	call   8013b0 <fd_lookup>
  801650:	83 c4 10             	add    $0x10,%esp
  801653:	85 c0                	test   %eax,%eax
  801655:	78 3f                	js     801696 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801657:	83 ec 08             	sub    $0x8,%esp
  80165a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80165d:	50                   	push   %eax
  80165e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801661:	ff 30                	pushl  (%eax)
  801663:	e8 9c fd ff ff       	call   801404 <dev_lookup>
  801668:	83 c4 10             	add    $0x10,%esp
  80166b:	85 c0                	test   %eax,%eax
  80166d:	78 27                	js     801696 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80166f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801672:	8b 42 08             	mov    0x8(%edx),%eax
  801675:	83 e0 03             	and    $0x3,%eax
  801678:	83 f8 01             	cmp    $0x1,%eax
  80167b:	74 1e                	je     80169b <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80167d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801680:	8b 40 08             	mov    0x8(%eax),%eax
  801683:	85 c0                	test   %eax,%eax
  801685:	74 35                	je     8016bc <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801687:	83 ec 04             	sub    $0x4,%esp
  80168a:	ff 75 10             	pushl  0x10(%ebp)
  80168d:	ff 75 0c             	pushl  0xc(%ebp)
  801690:	52                   	push   %edx
  801691:	ff d0                	call   *%eax
  801693:	83 c4 10             	add    $0x10,%esp
}
  801696:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801699:	c9                   	leave  
  80169a:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80169b:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8016a0:	8b 40 48             	mov    0x48(%eax),%eax
  8016a3:	83 ec 04             	sub    $0x4,%esp
  8016a6:	53                   	push   %ebx
  8016a7:	50                   	push   %eax
  8016a8:	68 41 2d 80 00       	push   $0x802d41
  8016ad:	e8 5a eb ff ff       	call   80020c <cprintf>
		return -E_INVAL;
  8016b2:	83 c4 10             	add    $0x10,%esp
  8016b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016ba:	eb da                	jmp    801696 <read+0x5e>
		return -E_NOT_SUPP;
  8016bc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016c1:	eb d3                	jmp    801696 <read+0x5e>

008016c3 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8016c3:	f3 0f 1e fb          	endbr32 
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
  8016ca:	57                   	push   %edi
  8016cb:	56                   	push   %esi
  8016cc:	53                   	push   %ebx
  8016cd:	83 ec 0c             	sub    $0xc,%esp
  8016d0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016d3:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016d6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016db:	eb 02                	jmp    8016df <readn+0x1c>
  8016dd:	01 c3                	add    %eax,%ebx
  8016df:	39 f3                	cmp    %esi,%ebx
  8016e1:	73 21                	jae    801704 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016e3:	83 ec 04             	sub    $0x4,%esp
  8016e6:	89 f0                	mov    %esi,%eax
  8016e8:	29 d8                	sub    %ebx,%eax
  8016ea:	50                   	push   %eax
  8016eb:	89 d8                	mov    %ebx,%eax
  8016ed:	03 45 0c             	add    0xc(%ebp),%eax
  8016f0:	50                   	push   %eax
  8016f1:	57                   	push   %edi
  8016f2:	e8 41 ff ff ff       	call   801638 <read>
		if (m < 0)
  8016f7:	83 c4 10             	add    $0x10,%esp
  8016fa:	85 c0                	test   %eax,%eax
  8016fc:	78 04                	js     801702 <readn+0x3f>
			return m;
		if (m == 0)
  8016fe:	75 dd                	jne    8016dd <readn+0x1a>
  801700:	eb 02                	jmp    801704 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801702:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801704:	89 d8                	mov    %ebx,%eax
  801706:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801709:	5b                   	pop    %ebx
  80170a:	5e                   	pop    %esi
  80170b:	5f                   	pop    %edi
  80170c:	5d                   	pop    %ebp
  80170d:	c3                   	ret    

0080170e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80170e:	f3 0f 1e fb          	endbr32 
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
  801715:	53                   	push   %ebx
  801716:	83 ec 1c             	sub    $0x1c,%esp
  801719:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80171c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80171f:	50                   	push   %eax
  801720:	53                   	push   %ebx
  801721:	e8 8a fc ff ff       	call   8013b0 <fd_lookup>
  801726:	83 c4 10             	add    $0x10,%esp
  801729:	85 c0                	test   %eax,%eax
  80172b:	78 3a                	js     801767 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80172d:	83 ec 08             	sub    $0x8,%esp
  801730:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801733:	50                   	push   %eax
  801734:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801737:	ff 30                	pushl  (%eax)
  801739:	e8 c6 fc ff ff       	call   801404 <dev_lookup>
  80173e:	83 c4 10             	add    $0x10,%esp
  801741:	85 c0                	test   %eax,%eax
  801743:	78 22                	js     801767 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801745:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801748:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80174c:	74 1e                	je     80176c <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80174e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801751:	8b 52 0c             	mov    0xc(%edx),%edx
  801754:	85 d2                	test   %edx,%edx
  801756:	74 35                	je     80178d <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801758:	83 ec 04             	sub    $0x4,%esp
  80175b:	ff 75 10             	pushl  0x10(%ebp)
  80175e:	ff 75 0c             	pushl  0xc(%ebp)
  801761:	50                   	push   %eax
  801762:	ff d2                	call   *%edx
  801764:	83 c4 10             	add    $0x10,%esp
}
  801767:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80176a:	c9                   	leave  
  80176b:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80176c:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801771:	8b 40 48             	mov    0x48(%eax),%eax
  801774:	83 ec 04             	sub    $0x4,%esp
  801777:	53                   	push   %ebx
  801778:	50                   	push   %eax
  801779:	68 5d 2d 80 00       	push   $0x802d5d
  80177e:	e8 89 ea ff ff       	call   80020c <cprintf>
		return -E_INVAL;
  801783:	83 c4 10             	add    $0x10,%esp
  801786:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80178b:	eb da                	jmp    801767 <write+0x59>
		return -E_NOT_SUPP;
  80178d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801792:	eb d3                	jmp    801767 <write+0x59>

00801794 <seek>:

int
seek(int fdnum, off_t offset)
{
  801794:	f3 0f 1e fb          	endbr32 
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
  80179b:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80179e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017a1:	50                   	push   %eax
  8017a2:	ff 75 08             	pushl  0x8(%ebp)
  8017a5:	e8 06 fc ff ff       	call   8013b0 <fd_lookup>
  8017aa:	83 c4 10             	add    $0x10,%esp
  8017ad:	85 c0                	test   %eax,%eax
  8017af:	78 0e                	js     8017bf <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8017b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b7:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8017ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017bf:	c9                   	leave  
  8017c0:	c3                   	ret    

008017c1 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8017c1:	f3 0f 1e fb          	endbr32 
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
  8017c8:	53                   	push   %ebx
  8017c9:	83 ec 1c             	sub    $0x1c,%esp
  8017cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017cf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017d2:	50                   	push   %eax
  8017d3:	53                   	push   %ebx
  8017d4:	e8 d7 fb ff ff       	call   8013b0 <fd_lookup>
  8017d9:	83 c4 10             	add    $0x10,%esp
  8017dc:	85 c0                	test   %eax,%eax
  8017de:	78 37                	js     801817 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017e0:	83 ec 08             	sub    $0x8,%esp
  8017e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017e6:	50                   	push   %eax
  8017e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ea:	ff 30                	pushl  (%eax)
  8017ec:	e8 13 fc ff ff       	call   801404 <dev_lookup>
  8017f1:	83 c4 10             	add    $0x10,%esp
  8017f4:	85 c0                	test   %eax,%eax
  8017f6:	78 1f                	js     801817 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017fb:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017ff:	74 1b                	je     80181c <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801801:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801804:	8b 52 18             	mov    0x18(%edx),%edx
  801807:	85 d2                	test   %edx,%edx
  801809:	74 32                	je     80183d <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80180b:	83 ec 08             	sub    $0x8,%esp
  80180e:	ff 75 0c             	pushl  0xc(%ebp)
  801811:	50                   	push   %eax
  801812:	ff d2                	call   *%edx
  801814:	83 c4 10             	add    $0x10,%esp
}
  801817:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80181a:	c9                   	leave  
  80181b:	c3                   	ret    
			thisenv->env_id, fdnum);
  80181c:	a1 0c 40 80 00       	mov    0x80400c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801821:	8b 40 48             	mov    0x48(%eax),%eax
  801824:	83 ec 04             	sub    $0x4,%esp
  801827:	53                   	push   %ebx
  801828:	50                   	push   %eax
  801829:	68 20 2d 80 00       	push   $0x802d20
  80182e:	e8 d9 e9 ff ff       	call   80020c <cprintf>
		return -E_INVAL;
  801833:	83 c4 10             	add    $0x10,%esp
  801836:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80183b:	eb da                	jmp    801817 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80183d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801842:	eb d3                	jmp    801817 <ftruncate+0x56>

00801844 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801844:	f3 0f 1e fb          	endbr32 
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
  80184b:	53                   	push   %ebx
  80184c:	83 ec 1c             	sub    $0x1c,%esp
  80184f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801852:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801855:	50                   	push   %eax
  801856:	ff 75 08             	pushl  0x8(%ebp)
  801859:	e8 52 fb ff ff       	call   8013b0 <fd_lookup>
  80185e:	83 c4 10             	add    $0x10,%esp
  801861:	85 c0                	test   %eax,%eax
  801863:	78 4b                	js     8018b0 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801865:	83 ec 08             	sub    $0x8,%esp
  801868:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80186b:	50                   	push   %eax
  80186c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80186f:	ff 30                	pushl  (%eax)
  801871:	e8 8e fb ff ff       	call   801404 <dev_lookup>
  801876:	83 c4 10             	add    $0x10,%esp
  801879:	85 c0                	test   %eax,%eax
  80187b:	78 33                	js     8018b0 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80187d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801880:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801884:	74 2f                	je     8018b5 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801886:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801889:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801890:	00 00 00 
	stat->st_isdir = 0;
  801893:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80189a:	00 00 00 
	stat->st_dev = dev;
  80189d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018a3:	83 ec 08             	sub    $0x8,%esp
  8018a6:	53                   	push   %ebx
  8018a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8018aa:	ff 50 14             	call   *0x14(%eax)
  8018ad:	83 c4 10             	add    $0x10,%esp
}
  8018b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018b3:	c9                   	leave  
  8018b4:	c3                   	ret    
		return -E_NOT_SUPP;
  8018b5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018ba:	eb f4                	jmp    8018b0 <fstat+0x6c>

008018bc <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8018bc:	f3 0f 1e fb          	endbr32 
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
  8018c3:	56                   	push   %esi
  8018c4:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018c5:	83 ec 08             	sub    $0x8,%esp
  8018c8:	6a 00                	push   $0x0
  8018ca:	ff 75 08             	pushl  0x8(%ebp)
  8018cd:	e8 fb 01 00 00       	call   801acd <open>
  8018d2:	89 c3                	mov    %eax,%ebx
  8018d4:	83 c4 10             	add    $0x10,%esp
  8018d7:	85 c0                	test   %eax,%eax
  8018d9:	78 1b                	js     8018f6 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8018db:	83 ec 08             	sub    $0x8,%esp
  8018de:	ff 75 0c             	pushl  0xc(%ebp)
  8018e1:	50                   	push   %eax
  8018e2:	e8 5d ff ff ff       	call   801844 <fstat>
  8018e7:	89 c6                	mov    %eax,%esi
	close(fd);
  8018e9:	89 1c 24             	mov    %ebx,(%esp)
  8018ec:	e8 fd fb ff ff       	call   8014ee <close>
	return r;
  8018f1:	83 c4 10             	add    $0x10,%esp
  8018f4:	89 f3                	mov    %esi,%ebx
}
  8018f6:	89 d8                	mov    %ebx,%eax
  8018f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018fb:	5b                   	pop    %ebx
  8018fc:	5e                   	pop    %esi
  8018fd:	5d                   	pop    %ebp
  8018fe:	c3                   	ret    

008018ff <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
  801902:	56                   	push   %esi
  801903:	53                   	push   %ebx
  801904:	89 c6                	mov    %eax,%esi
  801906:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801908:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80190f:	74 27                	je     801938 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801911:	6a 07                	push   $0x7
  801913:	68 00 50 80 00       	push   $0x805000
  801918:	56                   	push   %esi
  801919:	ff 35 00 40 80 00    	pushl  0x804000
  80191f:	e8 72 f9 ff ff       	call   801296 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801924:	83 c4 0c             	add    $0xc,%esp
  801927:	6a 00                	push   $0x0
  801929:	53                   	push   %ebx
  80192a:	6a 00                	push   $0x0
  80192c:	e8 e0 f8 ff ff       	call   801211 <ipc_recv>
}
  801931:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801934:	5b                   	pop    %ebx
  801935:	5e                   	pop    %esi
  801936:	5d                   	pop    %ebp
  801937:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801938:	83 ec 0c             	sub    $0xc,%esp
  80193b:	6a 01                	push   $0x1
  80193d:	e8 ac f9 ff ff       	call   8012ee <ipc_find_env>
  801942:	a3 00 40 80 00       	mov    %eax,0x804000
  801947:	83 c4 10             	add    $0x10,%esp
  80194a:	eb c5                	jmp    801911 <fsipc+0x12>

0080194c <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80194c:	f3 0f 1e fb          	endbr32 
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
  801953:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801956:	8b 45 08             	mov    0x8(%ebp),%eax
  801959:	8b 40 0c             	mov    0xc(%eax),%eax
  80195c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801961:	8b 45 0c             	mov    0xc(%ebp),%eax
  801964:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801969:	ba 00 00 00 00       	mov    $0x0,%edx
  80196e:	b8 02 00 00 00       	mov    $0x2,%eax
  801973:	e8 87 ff ff ff       	call   8018ff <fsipc>
}
  801978:	c9                   	leave  
  801979:	c3                   	ret    

0080197a <devfile_flush>:
{
  80197a:	f3 0f 1e fb          	endbr32 
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
  801981:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801984:	8b 45 08             	mov    0x8(%ebp),%eax
  801987:	8b 40 0c             	mov    0xc(%eax),%eax
  80198a:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80198f:	ba 00 00 00 00       	mov    $0x0,%edx
  801994:	b8 06 00 00 00       	mov    $0x6,%eax
  801999:	e8 61 ff ff ff       	call   8018ff <fsipc>
}
  80199e:	c9                   	leave  
  80199f:	c3                   	ret    

008019a0 <devfile_stat>:
{
  8019a0:	f3 0f 1e fb          	endbr32 
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
  8019a7:	53                   	push   %ebx
  8019a8:	83 ec 04             	sub    $0x4,%esp
  8019ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8019b4:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8019b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8019be:	b8 05 00 00 00       	mov    $0x5,%eax
  8019c3:	e8 37 ff ff ff       	call   8018ff <fsipc>
  8019c8:	85 c0                	test   %eax,%eax
  8019ca:	78 2c                	js     8019f8 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019cc:	83 ec 08             	sub    $0x8,%esp
  8019cf:	68 00 50 80 00       	push   $0x805000
  8019d4:	53                   	push   %ebx
  8019d5:	e8 3c ee ff ff       	call   800816 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019da:	a1 80 50 80 00       	mov    0x805080,%eax
  8019df:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019e5:	a1 84 50 80 00       	mov    0x805084,%eax
  8019ea:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8019f0:	83 c4 10             	add    $0x10,%esp
  8019f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <devfile_write>:
{
  8019fd:	f3 0f 1e fb          	endbr32 
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
  801a04:	83 ec 0c             	sub    $0xc,%esp
  801a07:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a0a:	8b 55 08             	mov    0x8(%ebp),%edx
  801a0d:	8b 52 0c             	mov    0xc(%edx),%edx
  801a10:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801a16:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801a1b:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801a20:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  801a23:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801a28:	50                   	push   %eax
  801a29:	ff 75 0c             	pushl  0xc(%ebp)
  801a2c:	68 08 50 80 00       	push   $0x805008
  801a31:	e8 96 ef ff ff       	call   8009cc <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801a36:	ba 00 00 00 00       	mov    $0x0,%edx
  801a3b:	b8 04 00 00 00       	mov    $0x4,%eax
  801a40:	e8 ba fe ff ff       	call   8018ff <fsipc>
}
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <devfile_read>:
{
  801a47:	f3 0f 1e fb          	endbr32 
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
  801a4e:	56                   	push   %esi
  801a4f:	53                   	push   %ebx
  801a50:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a53:	8b 45 08             	mov    0x8(%ebp),%eax
  801a56:	8b 40 0c             	mov    0xc(%eax),%eax
  801a59:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a5e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a64:	ba 00 00 00 00       	mov    $0x0,%edx
  801a69:	b8 03 00 00 00       	mov    $0x3,%eax
  801a6e:	e8 8c fe ff ff       	call   8018ff <fsipc>
  801a73:	89 c3                	mov    %eax,%ebx
  801a75:	85 c0                	test   %eax,%eax
  801a77:	78 1f                	js     801a98 <devfile_read+0x51>
	assert(r <= n);
  801a79:	39 f0                	cmp    %esi,%eax
  801a7b:	77 24                	ja     801aa1 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801a7d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a82:	7f 33                	jg     801ab7 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a84:	83 ec 04             	sub    $0x4,%esp
  801a87:	50                   	push   %eax
  801a88:	68 00 50 80 00       	push   $0x805000
  801a8d:	ff 75 0c             	pushl  0xc(%ebp)
  801a90:	e8 37 ef ff ff       	call   8009cc <memmove>
	return r;
  801a95:	83 c4 10             	add    $0x10,%esp
}
  801a98:	89 d8                	mov    %ebx,%eax
  801a9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a9d:	5b                   	pop    %ebx
  801a9e:	5e                   	pop    %esi
  801a9f:	5d                   	pop    %ebp
  801aa0:	c3                   	ret    
	assert(r <= n);
  801aa1:	68 90 2d 80 00       	push   $0x802d90
  801aa6:	68 97 2d 80 00       	push   $0x802d97
  801aab:	6a 7c                	push   $0x7c
  801aad:	68 ac 2d 80 00       	push   $0x802dac
  801ab2:	e8 76 0a 00 00       	call   80252d <_panic>
	assert(r <= PGSIZE);
  801ab7:	68 b7 2d 80 00       	push   $0x802db7
  801abc:	68 97 2d 80 00       	push   $0x802d97
  801ac1:	6a 7d                	push   $0x7d
  801ac3:	68 ac 2d 80 00       	push   $0x802dac
  801ac8:	e8 60 0a 00 00       	call   80252d <_panic>

00801acd <open>:
{
  801acd:	f3 0f 1e fb          	endbr32 
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
  801ad4:	56                   	push   %esi
  801ad5:	53                   	push   %ebx
  801ad6:	83 ec 1c             	sub    $0x1c,%esp
  801ad9:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801adc:	56                   	push   %esi
  801add:	e8 f1 ec ff ff       	call   8007d3 <strlen>
  801ae2:	83 c4 10             	add    $0x10,%esp
  801ae5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801aea:	7f 6c                	jg     801b58 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801aec:	83 ec 0c             	sub    $0xc,%esp
  801aef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801af2:	50                   	push   %eax
  801af3:	e8 62 f8 ff ff       	call   80135a <fd_alloc>
  801af8:	89 c3                	mov    %eax,%ebx
  801afa:	83 c4 10             	add    $0x10,%esp
  801afd:	85 c0                	test   %eax,%eax
  801aff:	78 3c                	js     801b3d <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801b01:	83 ec 08             	sub    $0x8,%esp
  801b04:	56                   	push   %esi
  801b05:	68 00 50 80 00       	push   $0x805000
  801b0a:	e8 07 ed ff ff       	call   800816 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b12:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b1a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b1f:	e8 db fd ff ff       	call   8018ff <fsipc>
  801b24:	89 c3                	mov    %eax,%ebx
  801b26:	83 c4 10             	add    $0x10,%esp
  801b29:	85 c0                	test   %eax,%eax
  801b2b:	78 19                	js     801b46 <open+0x79>
	return fd2num(fd);
  801b2d:	83 ec 0c             	sub    $0xc,%esp
  801b30:	ff 75 f4             	pushl  -0xc(%ebp)
  801b33:	e8 f3 f7 ff ff       	call   80132b <fd2num>
  801b38:	89 c3                	mov    %eax,%ebx
  801b3a:	83 c4 10             	add    $0x10,%esp
}
  801b3d:	89 d8                	mov    %ebx,%eax
  801b3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b42:	5b                   	pop    %ebx
  801b43:	5e                   	pop    %esi
  801b44:	5d                   	pop    %ebp
  801b45:	c3                   	ret    
		fd_close(fd, 0);
  801b46:	83 ec 08             	sub    $0x8,%esp
  801b49:	6a 00                	push   $0x0
  801b4b:	ff 75 f4             	pushl  -0xc(%ebp)
  801b4e:	e8 10 f9 ff ff       	call   801463 <fd_close>
		return r;
  801b53:	83 c4 10             	add    $0x10,%esp
  801b56:	eb e5                	jmp    801b3d <open+0x70>
		return -E_BAD_PATH;
  801b58:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b5d:	eb de                	jmp    801b3d <open+0x70>

00801b5f <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b5f:	f3 0f 1e fb          	endbr32 
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
  801b66:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b69:	ba 00 00 00 00       	mov    $0x0,%edx
  801b6e:	b8 08 00 00 00       	mov    $0x8,%eax
  801b73:	e8 87 fd ff ff       	call   8018ff <fsipc>
}
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801b7a:	f3 0f 1e fb          	endbr32 
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801b84:	68 c3 2d 80 00       	push   $0x802dc3
  801b89:	ff 75 0c             	pushl  0xc(%ebp)
  801b8c:	e8 85 ec ff ff       	call   800816 <strcpy>
	return 0;
}
  801b91:	b8 00 00 00 00       	mov    $0x0,%eax
  801b96:	c9                   	leave  
  801b97:	c3                   	ret    

00801b98 <devsock_close>:
{
  801b98:	f3 0f 1e fb          	endbr32 
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
  801b9f:	53                   	push   %ebx
  801ba0:	83 ec 10             	sub    $0x10,%esp
  801ba3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801ba6:	53                   	push   %ebx
  801ba7:	e8 64 0a 00 00       	call   802610 <pageref>
  801bac:	89 c2                	mov    %eax,%edx
  801bae:	83 c4 10             	add    $0x10,%esp
		return 0;
  801bb1:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801bb6:	83 fa 01             	cmp    $0x1,%edx
  801bb9:	74 05                	je     801bc0 <devsock_close+0x28>
}
  801bbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bbe:	c9                   	leave  
  801bbf:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801bc0:	83 ec 0c             	sub    $0xc,%esp
  801bc3:	ff 73 0c             	pushl  0xc(%ebx)
  801bc6:	e8 e3 02 00 00       	call   801eae <nsipc_close>
  801bcb:	83 c4 10             	add    $0x10,%esp
  801bce:	eb eb                	jmp    801bbb <devsock_close+0x23>

00801bd0 <devsock_write>:
{
  801bd0:	f3 0f 1e fb          	endbr32 
  801bd4:	55                   	push   %ebp
  801bd5:	89 e5                	mov    %esp,%ebp
  801bd7:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801bda:	6a 00                	push   $0x0
  801bdc:	ff 75 10             	pushl  0x10(%ebp)
  801bdf:	ff 75 0c             	pushl  0xc(%ebp)
  801be2:	8b 45 08             	mov    0x8(%ebp),%eax
  801be5:	ff 70 0c             	pushl  0xc(%eax)
  801be8:	e8 b5 03 00 00       	call   801fa2 <nsipc_send>
}
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <devsock_read>:
{
  801bef:	f3 0f 1e fb          	endbr32 
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
  801bf6:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801bf9:	6a 00                	push   $0x0
  801bfb:	ff 75 10             	pushl  0x10(%ebp)
  801bfe:	ff 75 0c             	pushl  0xc(%ebp)
  801c01:	8b 45 08             	mov    0x8(%ebp),%eax
  801c04:	ff 70 0c             	pushl  0xc(%eax)
  801c07:	e8 1f 03 00 00       	call   801f2b <nsipc_recv>
}
  801c0c:	c9                   	leave  
  801c0d:	c3                   	ret    

00801c0e <fd2sockid>:
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
  801c11:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801c14:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801c17:	52                   	push   %edx
  801c18:	50                   	push   %eax
  801c19:	e8 92 f7 ff ff       	call   8013b0 <fd_lookup>
  801c1e:	83 c4 10             	add    $0x10,%esp
  801c21:	85 c0                	test   %eax,%eax
  801c23:	78 10                	js     801c35 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c28:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801c2e:	39 08                	cmp    %ecx,(%eax)
  801c30:	75 05                	jne    801c37 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801c32:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    
		return -E_NOT_SUPP;
  801c37:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c3c:	eb f7                	jmp    801c35 <fd2sockid+0x27>

00801c3e <alloc_sockfd>:
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
  801c41:	56                   	push   %esi
  801c42:	53                   	push   %ebx
  801c43:	83 ec 1c             	sub    $0x1c,%esp
  801c46:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801c48:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c4b:	50                   	push   %eax
  801c4c:	e8 09 f7 ff ff       	call   80135a <fd_alloc>
  801c51:	89 c3                	mov    %eax,%ebx
  801c53:	83 c4 10             	add    $0x10,%esp
  801c56:	85 c0                	test   %eax,%eax
  801c58:	78 43                	js     801c9d <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801c5a:	83 ec 04             	sub    $0x4,%esp
  801c5d:	68 07 04 00 00       	push   $0x407
  801c62:	ff 75 f4             	pushl  -0xc(%ebp)
  801c65:	6a 00                	push   $0x0
  801c67:	e8 ec ef ff ff       	call   800c58 <sys_page_alloc>
  801c6c:	89 c3                	mov    %eax,%ebx
  801c6e:	83 c4 10             	add    $0x10,%esp
  801c71:	85 c0                	test   %eax,%eax
  801c73:	78 28                	js     801c9d <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c78:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c7e:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c83:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801c8a:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801c8d:	83 ec 0c             	sub    $0xc,%esp
  801c90:	50                   	push   %eax
  801c91:	e8 95 f6 ff ff       	call   80132b <fd2num>
  801c96:	89 c3                	mov    %eax,%ebx
  801c98:	83 c4 10             	add    $0x10,%esp
  801c9b:	eb 0c                	jmp    801ca9 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801c9d:	83 ec 0c             	sub    $0xc,%esp
  801ca0:	56                   	push   %esi
  801ca1:	e8 08 02 00 00       	call   801eae <nsipc_close>
		return r;
  801ca6:	83 c4 10             	add    $0x10,%esp
}
  801ca9:	89 d8                	mov    %ebx,%eax
  801cab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cae:	5b                   	pop    %ebx
  801caf:	5e                   	pop    %esi
  801cb0:	5d                   	pop    %ebp
  801cb1:	c3                   	ret    

00801cb2 <accept>:
{
  801cb2:	f3 0f 1e fb          	endbr32 
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
  801cb9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbf:	e8 4a ff ff ff       	call   801c0e <fd2sockid>
  801cc4:	85 c0                	test   %eax,%eax
  801cc6:	78 1b                	js     801ce3 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801cc8:	83 ec 04             	sub    $0x4,%esp
  801ccb:	ff 75 10             	pushl  0x10(%ebp)
  801cce:	ff 75 0c             	pushl  0xc(%ebp)
  801cd1:	50                   	push   %eax
  801cd2:	e8 22 01 00 00       	call   801df9 <nsipc_accept>
  801cd7:	83 c4 10             	add    $0x10,%esp
  801cda:	85 c0                	test   %eax,%eax
  801cdc:	78 05                	js     801ce3 <accept+0x31>
	return alloc_sockfd(r);
  801cde:	e8 5b ff ff ff       	call   801c3e <alloc_sockfd>
}
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <bind>:
{
  801ce5:	f3 0f 1e fb          	endbr32 
  801ce9:	55                   	push   %ebp
  801cea:	89 e5                	mov    %esp,%ebp
  801cec:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cef:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf2:	e8 17 ff ff ff       	call   801c0e <fd2sockid>
  801cf7:	85 c0                	test   %eax,%eax
  801cf9:	78 12                	js     801d0d <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801cfb:	83 ec 04             	sub    $0x4,%esp
  801cfe:	ff 75 10             	pushl  0x10(%ebp)
  801d01:	ff 75 0c             	pushl  0xc(%ebp)
  801d04:	50                   	push   %eax
  801d05:	e8 45 01 00 00       	call   801e4f <nsipc_bind>
  801d0a:	83 c4 10             	add    $0x10,%esp
}
  801d0d:	c9                   	leave  
  801d0e:	c3                   	ret    

00801d0f <shutdown>:
{
  801d0f:	f3 0f 1e fb          	endbr32 
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
  801d16:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d19:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1c:	e8 ed fe ff ff       	call   801c0e <fd2sockid>
  801d21:	85 c0                	test   %eax,%eax
  801d23:	78 0f                	js     801d34 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801d25:	83 ec 08             	sub    $0x8,%esp
  801d28:	ff 75 0c             	pushl  0xc(%ebp)
  801d2b:	50                   	push   %eax
  801d2c:	e8 57 01 00 00       	call   801e88 <nsipc_shutdown>
  801d31:	83 c4 10             	add    $0x10,%esp
}
  801d34:	c9                   	leave  
  801d35:	c3                   	ret    

00801d36 <connect>:
{
  801d36:	f3 0f 1e fb          	endbr32 
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
  801d3d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d40:	8b 45 08             	mov    0x8(%ebp),%eax
  801d43:	e8 c6 fe ff ff       	call   801c0e <fd2sockid>
  801d48:	85 c0                	test   %eax,%eax
  801d4a:	78 12                	js     801d5e <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801d4c:	83 ec 04             	sub    $0x4,%esp
  801d4f:	ff 75 10             	pushl  0x10(%ebp)
  801d52:	ff 75 0c             	pushl  0xc(%ebp)
  801d55:	50                   	push   %eax
  801d56:	e8 71 01 00 00       	call   801ecc <nsipc_connect>
  801d5b:	83 c4 10             	add    $0x10,%esp
}
  801d5e:	c9                   	leave  
  801d5f:	c3                   	ret    

00801d60 <listen>:
{
  801d60:	f3 0f 1e fb          	endbr32 
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
  801d67:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6d:	e8 9c fe ff ff       	call   801c0e <fd2sockid>
  801d72:	85 c0                	test   %eax,%eax
  801d74:	78 0f                	js     801d85 <listen+0x25>
	return nsipc_listen(r, backlog);
  801d76:	83 ec 08             	sub    $0x8,%esp
  801d79:	ff 75 0c             	pushl  0xc(%ebp)
  801d7c:	50                   	push   %eax
  801d7d:	e8 83 01 00 00       	call   801f05 <nsipc_listen>
  801d82:	83 c4 10             	add    $0x10,%esp
}
  801d85:	c9                   	leave  
  801d86:	c3                   	ret    

00801d87 <socket>:

int
socket(int domain, int type, int protocol)
{
  801d87:	f3 0f 1e fb          	endbr32 
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
  801d8e:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801d91:	ff 75 10             	pushl  0x10(%ebp)
  801d94:	ff 75 0c             	pushl  0xc(%ebp)
  801d97:	ff 75 08             	pushl  0x8(%ebp)
  801d9a:	e8 65 02 00 00       	call   802004 <nsipc_socket>
  801d9f:	83 c4 10             	add    $0x10,%esp
  801da2:	85 c0                	test   %eax,%eax
  801da4:	78 05                	js     801dab <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801da6:	e8 93 fe ff ff       	call   801c3e <alloc_sockfd>
}
  801dab:	c9                   	leave  
  801dac:	c3                   	ret    

00801dad <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801dad:	55                   	push   %ebp
  801dae:	89 e5                	mov    %esp,%ebp
  801db0:	53                   	push   %ebx
  801db1:	83 ec 04             	sub    $0x4,%esp
  801db4:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801db6:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801dbd:	74 26                	je     801de5 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801dbf:	6a 07                	push   $0x7
  801dc1:	68 00 60 80 00       	push   $0x806000
  801dc6:	53                   	push   %ebx
  801dc7:	ff 35 04 40 80 00    	pushl  0x804004
  801dcd:	e8 c4 f4 ff ff       	call   801296 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801dd2:	83 c4 0c             	add    $0xc,%esp
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	e8 31 f4 ff ff       	call   801211 <ipc_recv>
}
  801de0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801de5:	83 ec 0c             	sub    $0xc,%esp
  801de8:	6a 02                	push   $0x2
  801dea:	e8 ff f4 ff ff       	call   8012ee <ipc_find_env>
  801def:	a3 04 40 80 00       	mov    %eax,0x804004
  801df4:	83 c4 10             	add    $0x10,%esp
  801df7:	eb c6                	jmp    801dbf <nsipc+0x12>

00801df9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801df9:	f3 0f 1e fb          	endbr32 
  801dfd:	55                   	push   %ebp
  801dfe:	89 e5                	mov    %esp,%ebp
  801e00:	56                   	push   %esi
  801e01:	53                   	push   %ebx
  801e02:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801e05:	8b 45 08             	mov    0x8(%ebp),%eax
  801e08:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801e0d:	8b 06                	mov    (%esi),%eax
  801e0f:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801e14:	b8 01 00 00 00       	mov    $0x1,%eax
  801e19:	e8 8f ff ff ff       	call   801dad <nsipc>
  801e1e:	89 c3                	mov    %eax,%ebx
  801e20:	85 c0                	test   %eax,%eax
  801e22:	79 09                	jns    801e2d <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801e24:	89 d8                	mov    %ebx,%eax
  801e26:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e29:	5b                   	pop    %ebx
  801e2a:	5e                   	pop    %esi
  801e2b:	5d                   	pop    %ebp
  801e2c:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801e2d:	83 ec 04             	sub    $0x4,%esp
  801e30:	ff 35 10 60 80 00    	pushl  0x806010
  801e36:	68 00 60 80 00       	push   $0x806000
  801e3b:	ff 75 0c             	pushl  0xc(%ebp)
  801e3e:	e8 89 eb ff ff       	call   8009cc <memmove>
		*addrlen = ret->ret_addrlen;
  801e43:	a1 10 60 80 00       	mov    0x806010,%eax
  801e48:	89 06                	mov    %eax,(%esi)
  801e4a:	83 c4 10             	add    $0x10,%esp
	return r;
  801e4d:	eb d5                	jmp    801e24 <nsipc_accept+0x2b>

00801e4f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e4f:	f3 0f 1e fb          	endbr32 
  801e53:	55                   	push   %ebp
  801e54:	89 e5                	mov    %esp,%ebp
  801e56:	53                   	push   %ebx
  801e57:	83 ec 08             	sub    $0x8,%esp
  801e5a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e60:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801e65:	53                   	push   %ebx
  801e66:	ff 75 0c             	pushl  0xc(%ebp)
  801e69:	68 04 60 80 00       	push   $0x806004
  801e6e:	e8 59 eb ff ff       	call   8009cc <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801e73:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801e79:	b8 02 00 00 00       	mov    $0x2,%eax
  801e7e:	e8 2a ff ff ff       	call   801dad <nsipc>
}
  801e83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e86:	c9                   	leave  
  801e87:	c3                   	ret    

00801e88 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801e88:	f3 0f 1e fb          	endbr32 
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
  801e8f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801e92:	8b 45 08             	mov    0x8(%ebp),%eax
  801e95:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801e9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e9d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801ea2:	b8 03 00 00 00       	mov    $0x3,%eax
  801ea7:	e8 01 ff ff ff       	call   801dad <nsipc>
}
  801eac:	c9                   	leave  
  801ead:	c3                   	ret    

00801eae <nsipc_close>:

int
nsipc_close(int s)
{
  801eae:	f3 0f 1e fb          	endbr32 
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
  801eb5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebb:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801ec0:	b8 04 00 00 00       	mov    $0x4,%eax
  801ec5:	e8 e3 fe ff ff       	call   801dad <nsipc>
}
  801eca:	c9                   	leave  
  801ecb:	c3                   	ret    

00801ecc <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ecc:	f3 0f 1e fb          	endbr32 
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
  801ed3:	53                   	push   %ebx
  801ed4:	83 ec 08             	sub    $0x8,%esp
  801ed7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801eda:	8b 45 08             	mov    0x8(%ebp),%eax
  801edd:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801ee2:	53                   	push   %ebx
  801ee3:	ff 75 0c             	pushl  0xc(%ebp)
  801ee6:	68 04 60 80 00       	push   $0x806004
  801eeb:	e8 dc ea ff ff       	call   8009cc <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801ef0:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801ef6:	b8 05 00 00 00       	mov    $0x5,%eax
  801efb:	e8 ad fe ff ff       	call   801dad <nsipc>
}
  801f00:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f03:	c9                   	leave  
  801f04:	c3                   	ret    

00801f05 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801f05:	f3 0f 1e fb          	endbr32 
  801f09:	55                   	push   %ebp
  801f0a:	89 e5                	mov    %esp,%ebp
  801f0c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f12:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801f17:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f1a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801f1f:	b8 06 00 00 00       	mov    $0x6,%eax
  801f24:	e8 84 fe ff ff       	call   801dad <nsipc>
}
  801f29:	c9                   	leave  
  801f2a:	c3                   	ret    

00801f2b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801f2b:	f3 0f 1e fb          	endbr32 
  801f2f:	55                   	push   %ebp
  801f30:	89 e5                	mov    %esp,%ebp
  801f32:	56                   	push   %esi
  801f33:	53                   	push   %ebx
  801f34:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801f37:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801f3f:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801f45:	8b 45 14             	mov    0x14(%ebp),%eax
  801f48:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801f4d:	b8 07 00 00 00       	mov    $0x7,%eax
  801f52:	e8 56 fe ff ff       	call   801dad <nsipc>
  801f57:	89 c3                	mov    %eax,%ebx
  801f59:	85 c0                	test   %eax,%eax
  801f5b:	78 26                	js     801f83 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801f5d:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801f63:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801f68:	0f 4e c6             	cmovle %esi,%eax
  801f6b:	39 c3                	cmp    %eax,%ebx
  801f6d:	7f 1d                	jg     801f8c <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801f6f:	83 ec 04             	sub    $0x4,%esp
  801f72:	53                   	push   %ebx
  801f73:	68 00 60 80 00       	push   $0x806000
  801f78:	ff 75 0c             	pushl  0xc(%ebp)
  801f7b:	e8 4c ea ff ff       	call   8009cc <memmove>
  801f80:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801f83:	89 d8                	mov    %ebx,%eax
  801f85:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f88:	5b                   	pop    %ebx
  801f89:	5e                   	pop    %esi
  801f8a:	5d                   	pop    %ebp
  801f8b:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801f8c:	68 cf 2d 80 00       	push   $0x802dcf
  801f91:	68 97 2d 80 00       	push   $0x802d97
  801f96:	6a 62                	push   $0x62
  801f98:	68 e4 2d 80 00       	push   $0x802de4
  801f9d:	e8 8b 05 00 00       	call   80252d <_panic>

00801fa2 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801fa2:	f3 0f 1e fb          	endbr32 
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
  801fa9:	53                   	push   %ebx
  801faa:	83 ec 04             	sub    $0x4,%esp
  801fad:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb3:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801fb8:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801fbe:	7f 2e                	jg     801fee <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801fc0:	83 ec 04             	sub    $0x4,%esp
  801fc3:	53                   	push   %ebx
  801fc4:	ff 75 0c             	pushl  0xc(%ebp)
  801fc7:	68 0c 60 80 00       	push   $0x80600c
  801fcc:	e8 fb e9 ff ff       	call   8009cc <memmove>
	nsipcbuf.send.req_size = size;
  801fd1:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801fd7:	8b 45 14             	mov    0x14(%ebp),%eax
  801fda:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801fdf:	b8 08 00 00 00       	mov    $0x8,%eax
  801fe4:	e8 c4 fd ff ff       	call   801dad <nsipc>
}
  801fe9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fec:	c9                   	leave  
  801fed:	c3                   	ret    
	assert(size < 1600);
  801fee:	68 f0 2d 80 00       	push   $0x802df0
  801ff3:	68 97 2d 80 00       	push   $0x802d97
  801ff8:	6a 6d                	push   $0x6d
  801ffa:	68 e4 2d 80 00       	push   $0x802de4
  801fff:	e8 29 05 00 00       	call   80252d <_panic>

00802004 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802004:	f3 0f 1e fb          	endbr32 
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
  80200b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80200e:	8b 45 08             	mov    0x8(%ebp),%eax
  802011:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802016:	8b 45 0c             	mov    0xc(%ebp),%eax
  802019:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80201e:	8b 45 10             	mov    0x10(%ebp),%eax
  802021:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802026:	b8 09 00 00 00       	mov    $0x9,%eax
  80202b:	e8 7d fd ff ff       	call   801dad <nsipc>
}
  802030:	c9                   	leave  
  802031:	c3                   	ret    

00802032 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802032:	f3 0f 1e fb          	endbr32 
  802036:	55                   	push   %ebp
  802037:	89 e5                	mov    %esp,%ebp
  802039:	56                   	push   %esi
  80203a:	53                   	push   %ebx
  80203b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80203e:	83 ec 0c             	sub    $0xc,%esp
  802041:	ff 75 08             	pushl  0x8(%ebp)
  802044:	e8 f6 f2 ff ff       	call   80133f <fd2data>
  802049:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80204b:	83 c4 08             	add    $0x8,%esp
  80204e:	68 fc 2d 80 00       	push   $0x802dfc
  802053:	53                   	push   %ebx
  802054:	e8 bd e7 ff ff       	call   800816 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802059:	8b 46 04             	mov    0x4(%esi),%eax
  80205c:	2b 06                	sub    (%esi),%eax
  80205e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802064:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80206b:	00 00 00 
	stat->st_dev = &devpipe;
  80206e:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  802075:	30 80 00 
	return 0;
}
  802078:	b8 00 00 00 00       	mov    $0x0,%eax
  80207d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802080:	5b                   	pop    %ebx
  802081:	5e                   	pop    %esi
  802082:	5d                   	pop    %ebp
  802083:	c3                   	ret    

00802084 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802084:	f3 0f 1e fb          	endbr32 
  802088:	55                   	push   %ebp
  802089:	89 e5                	mov    %esp,%ebp
  80208b:	53                   	push   %ebx
  80208c:	83 ec 0c             	sub    $0xc,%esp
  80208f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802092:	53                   	push   %ebx
  802093:	6a 00                	push   $0x0
  802095:	e8 4b ec ff ff       	call   800ce5 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80209a:	89 1c 24             	mov    %ebx,(%esp)
  80209d:	e8 9d f2 ff ff       	call   80133f <fd2data>
  8020a2:	83 c4 08             	add    $0x8,%esp
  8020a5:	50                   	push   %eax
  8020a6:	6a 00                	push   $0x0
  8020a8:	e8 38 ec ff ff       	call   800ce5 <sys_page_unmap>
}
  8020ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020b0:	c9                   	leave  
  8020b1:	c3                   	ret    

008020b2 <_pipeisclosed>:
{
  8020b2:	55                   	push   %ebp
  8020b3:	89 e5                	mov    %esp,%ebp
  8020b5:	57                   	push   %edi
  8020b6:	56                   	push   %esi
  8020b7:	53                   	push   %ebx
  8020b8:	83 ec 1c             	sub    $0x1c,%esp
  8020bb:	89 c7                	mov    %eax,%edi
  8020bd:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8020bf:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8020c4:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8020c7:	83 ec 0c             	sub    $0xc,%esp
  8020ca:	57                   	push   %edi
  8020cb:	e8 40 05 00 00       	call   802610 <pageref>
  8020d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8020d3:	89 34 24             	mov    %esi,(%esp)
  8020d6:	e8 35 05 00 00       	call   802610 <pageref>
		nn = thisenv->env_runs;
  8020db:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  8020e1:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8020e4:	83 c4 10             	add    $0x10,%esp
  8020e7:	39 cb                	cmp    %ecx,%ebx
  8020e9:	74 1b                	je     802106 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8020eb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8020ee:	75 cf                	jne    8020bf <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8020f0:	8b 42 58             	mov    0x58(%edx),%eax
  8020f3:	6a 01                	push   $0x1
  8020f5:	50                   	push   %eax
  8020f6:	53                   	push   %ebx
  8020f7:	68 03 2e 80 00       	push   $0x802e03
  8020fc:	e8 0b e1 ff ff       	call   80020c <cprintf>
  802101:	83 c4 10             	add    $0x10,%esp
  802104:	eb b9                	jmp    8020bf <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802106:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802109:	0f 94 c0             	sete   %al
  80210c:	0f b6 c0             	movzbl %al,%eax
}
  80210f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802112:	5b                   	pop    %ebx
  802113:	5e                   	pop    %esi
  802114:	5f                   	pop    %edi
  802115:	5d                   	pop    %ebp
  802116:	c3                   	ret    

00802117 <devpipe_write>:
{
  802117:	f3 0f 1e fb          	endbr32 
  80211b:	55                   	push   %ebp
  80211c:	89 e5                	mov    %esp,%ebp
  80211e:	57                   	push   %edi
  80211f:	56                   	push   %esi
  802120:	53                   	push   %ebx
  802121:	83 ec 28             	sub    $0x28,%esp
  802124:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802127:	56                   	push   %esi
  802128:	e8 12 f2 ff ff       	call   80133f <fd2data>
  80212d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80212f:	83 c4 10             	add    $0x10,%esp
  802132:	bf 00 00 00 00       	mov    $0x0,%edi
  802137:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80213a:	74 4f                	je     80218b <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80213c:	8b 43 04             	mov    0x4(%ebx),%eax
  80213f:	8b 0b                	mov    (%ebx),%ecx
  802141:	8d 51 20             	lea    0x20(%ecx),%edx
  802144:	39 d0                	cmp    %edx,%eax
  802146:	72 14                	jb     80215c <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  802148:	89 da                	mov    %ebx,%edx
  80214a:	89 f0                	mov    %esi,%eax
  80214c:	e8 61 ff ff ff       	call   8020b2 <_pipeisclosed>
  802151:	85 c0                	test   %eax,%eax
  802153:	75 3b                	jne    802190 <devpipe_write+0x79>
			sys_yield();
  802155:	e8 db ea ff ff       	call   800c35 <sys_yield>
  80215a:	eb e0                	jmp    80213c <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80215c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80215f:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802163:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802166:	89 c2                	mov    %eax,%edx
  802168:	c1 fa 1f             	sar    $0x1f,%edx
  80216b:	89 d1                	mov    %edx,%ecx
  80216d:	c1 e9 1b             	shr    $0x1b,%ecx
  802170:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802173:	83 e2 1f             	and    $0x1f,%edx
  802176:	29 ca                	sub    %ecx,%edx
  802178:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80217c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802180:	83 c0 01             	add    $0x1,%eax
  802183:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802186:	83 c7 01             	add    $0x1,%edi
  802189:	eb ac                	jmp    802137 <devpipe_write+0x20>
	return i;
  80218b:	8b 45 10             	mov    0x10(%ebp),%eax
  80218e:	eb 05                	jmp    802195 <devpipe_write+0x7e>
				return 0;
  802190:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802195:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802198:	5b                   	pop    %ebx
  802199:	5e                   	pop    %esi
  80219a:	5f                   	pop    %edi
  80219b:	5d                   	pop    %ebp
  80219c:	c3                   	ret    

0080219d <devpipe_read>:
{
  80219d:	f3 0f 1e fb          	endbr32 
  8021a1:	55                   	push   %ebp
  8021a2:	89 e5                	mov    %esp,%ebp
  8021a4:	57                   	push   %edi
  8021a5:	56                   	push   %esi
  8021a6:	53                   	push   %ebx
  8021a7:	83 ec 18             	sub    $0x18,%esp
  8021aa:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8021ad:	57                   	push   %edi
  8021ae:	e8 8c f1 ff ff       	call   80133f <fd2data>
  8021b3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8021b5:	83 c4 10             	add    $0x10,%esp
  8021b8:	be 00 00 00 00       	mov    $0x0,%esi
  8021bd:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021c0:	75 14                	jne    8021d6 <devpipe_read+0x39>
	return i;
  8021c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8021c5:	eb 02                	jmp    8021c9 <devpipe_read+0x2c>
				return i;
  8021c7:	89 f0                	mov    %esi,%eax
}
  8021c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021cc:	5b                   	pop    %ebx
  8021cd:	5e                   	pop    %esi
  8021ce:	5f                   	pop    %edi
  8021cf:	5d                   	pop    %ebp
  8021d0:	c3                   	ret    
			sys_yield();
  8021d1:	e8 5f ea ff ff       	call   800c35 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8021d6:	8b 03                	mov    (%ebx),%eax
  8021d8:	3b 43 04             	cmp    0x4(%ebx),%eax
  8021db:	75 18                	jne    8021f5 <devpipe_read+0x58>
			if (i > 0)
  8021dd:	85 f6                	test   %esi,%esi
  8021df:	75 e6                	jne    8021c7 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8021e1:	89 da                	mov    %ebx,%edx
  8021e3:	89 f8                	mov    %edi,%eax
  8021e5:	e8 c8 fe ff ff       	call   8020b2 <_pipeisclosed>
  8021ea:	85 c0                	test   %eax,%eax
  8021ec:	74 e3                	je     8021d1 <devpipe_read+0x34>
				return 0;
  8021ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f3:	eb d4                	jmp    8021c9 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8021f5:	99                   	cltd   
  8021f6:	c1 ea 1b             	shr    $0x1b,%edx
  8021f9:	01 d0                	add    %edx,%eax
  8021fb:	83 e0 1f             	and    $0x1f,%eax
  8021fe:	29 d0                	sub    %edx,%eax
  802200:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802205:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802208:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80220b:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80220e:	83 c6 01             	add    $0x1,%esi
  802211:	eb aa                	jmp    8021bd <devpipe_read+0x20>

00802213 <pipe>:
{
  802213:	f3 0f 1e fb          	endbr32 
  802217:	55                   	push   %ebp
  802218:	89 e5                	mov    %esp,%ebp
  80221a:	56                   	push   %esi
  80221b:	53                   	push   %ebx
  80221c:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80221f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802222:	50                   	push   %eax
  802223:	e8 32 f1 ff ff       	call   80135a <fd_alloc>
  802228:	89 c3                	mov    %eax,%ebx
  80222a:	83 c4 10             	add    $0x10,%esp
  80222d:	85 c0                	test   %eax,%eax
  80222f:	0f 88 23 01 00 00    	js     802358 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802235:	83 ec 04             	sub    $0x4,%esp
  802238:	68 07 04 00 00       	push   $0x407
  80223d:	ff 75 f4             	pushl  -0xc(%ebp)
  802240:	6a 00                	push   $0x0
  802242:	e8 11 ea ff ff       	call   800c58 <sys_page_alloc>
  802247:	89 c3                	mov    %eax,%ebx
  802249:	83 c4 10             	add    $0x10,%esp
  80224c:	85 c0                	test   %eax,%eax
  80224e:	0f 88 04 01 00 00    	js     802358 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  802254:	83 ec 0c             	sub    $0xc,%esp
  802257:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80225a:	50                   	push   %eax
  80225b:	e8 fa f0 ff ff       	call   80135a <fd_alloc>
  802260:	89 c3                	mov    %eax,%ebx
  802262:	83 c4 10             	add    $0x10,%esp
  802265:	85 c0                	test   %eax,%eax
  802267:	0f 88 db 00 00 00    	js     802348 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80226d:	83 ec 04             	sub    $0x4,%esp
  802270:	68 07 04 00 00       	push   $0x407
  802275:	ff 75 f0             	pushl  -0x10(%ebp)
  802278:	6a 00                	push   $0x0
  80227a:	e8 d9 e9 ff ff       	call   800c58 <sys_page_alloc>
  80227f:	89 c3                	mov    %eax,%ebx
  802281:	83 c4 10             	add    $0x10,%esp
  802284:	85 c0                	test   %eax,%eax
  802286:	0f 88 bc 00 00 00    	js     802348 <pipe+0x135>
	va = fd2data(fd0);
  80228c:	83 ec 0c             	sub    $0xc,%esp
  80228f:	ff 75 f4             	pushl  -0xc(%ebp)
  802292:	e8 a8 f0 ff ff       	call   80133f <fd2data>
  802297:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802299:	83 c4 0c             	add    $0xc,%esp
  80229c:	68 07 04 00 00       	push   $0x407
  8022a1:	50                   	push   %eax
  8022a2:	6a 00                	push   $0x0
  8022a4:	e8 af e9 ff ff       	call   800c58 <sys_page_alloc>
  8022a9:	89 c3                	mov    %eax,%ebx
  8022ab:	83 c4 10             	add    $0x10,%esp
  8022ae:	85 c0                	test   %eax,%eax
  8022b0:	0f 88 82 00 00 00    	js     802338 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022b6:	83 ec 0c             	sub    $0xc,%esp
  8022b9:	ff 75 f0             	pushl  -0x10(%ebp)
  8022bc:	e8 7e f0 ff ff       	call   80133f <fd2data>
  8022c1:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8022c8:	50                   	push   %eax
  8022c9:	6a 00                	push   $0x0
  8022cb:	56                   	push   %esi
  8022cc:	6a 00                	push   $0x0
  8022ce:	e8 cc e9 ff ff       	call   800c9f <sys_page_map>
  8022d3:	89 c3                	mov    %eax,%ebx
  8022d5:	83 c4 20             	add    $0x20,%esp
  8022d8:	85 c0                	test   %eax,%eax
  8022da:	78 4e                	js     80232a <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8022dc:	a1 3c 30 80 00       	mov    0x80303c,%eax
  8022e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e4:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8022e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e9:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8022f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022f3:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8022f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f8:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8022ff:	83 ec 0c             	sub    $0xc,%esp
  802302:	ff 75 f4             	pushl  -0xc(%ebp)
  802305:	e8 21 f0 ff ff       	call   80132b <fd2num>
  80230a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80230d:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80230f:	83 c4 04             	add    $0x4,%esp
  802312:	ff 75 f0             	pushl  -0x10(%ebp)
  802315:	e8 11 f0 ff ff       	call   80132b <fd2num>
  80231a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80231d:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802320:	83 c4 10             	add    $0x10,%esp
  802323:	bb 00 00 00 00       	mov    $0x0,%ebx
  802328:	eb 2e                	jmp    802358 <pipe+0x145>
	sys_page_unmap(0, va);
  80232a:	83 ec 08             	sub    $0x8,%esp
  80232d:	56                   	push   %esi
  80232e:	6a 00                	push   $0x0
  802330:	e8 b0 e9 ff ff       	call   800ce5 <sys_page_unmap>
  802335:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802338:	83 ec 08             	sub    $0x8,%esp
  80233b:	ff 75 f0             	pushl  -0x10(%ebp)
  80233e:	6a 00                	push   $0x0
  802340:	e8 a0 e9 ff ff       	call   800ce5 <sys_page_unmap>
  802345:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802348:	83 ec 08             	sub    $0x8,%esp
  80234b:	ff 75 f4             	pushl  -0xc(%ebp)
  80234e:	6a 00                	push   $0x0
  802350:	e8 90 e9 ff ff       	call   800ce5 <sys_page_unmap>
  802355:	83 c4 10             	add    $0x10,%esp
}
  802358:	89 d8                	mov    %ebx,%eax
  80235a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80235d:	5b                   	pop    %ebx
  80235e:	5e                   	pop    %esi
  80235f:	5d                   	pop    %ebp
  802360:	c3                   	ret    

00802361 <pipeisclosed>:
{
  802361:	f3 0f 1e fb          	endbr32 
  802365:	55                   	push   %ebp
  802366:	89 e5                	mov    %esp,%ebp
  802368:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80236b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80236e:	50                   	push   %eax
  80236f:	ff 75 08             	pushl  0x8(%ebp)
  802372:	e8 39 f0 ff ff       	call   8013b0 <fd_lookup>
  802377:	83 c4 10             	add    $0x10,%esp
  80237a:	85 c0                	test   %eax,%eax
  80237c:	78 18                	js     802396 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  80237e:	83 ec 0c             	sub    $0xc,%esp
  802381:	ff 75 f4             	pushl  -0xc(%ebp)
  802384:	e8 b6 ef ff ff       	call   80133f <fd2data>
  802389:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  80238b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238e:	e8 1f fd ff ff       	call   8020b2 <_pipeisclosed>
  802393:	83 c4 10             	add    $0x10,%esp
}
  802396:	c9                   	leave  
  802397:	c3                   	ret    

00802398 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802398:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  80239c:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a1:	c3                   	ret    

008023a2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8023a2:	f3 0f 1e fb          	endbr32 
  8023a6:	55                   	push   %ebp
  8023a7:	89 e5                	mov    %esp,%ebp
  8023a9:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8023ac:	68 1b 2e 80 00       	push   $0x802e1b
  8023b1:	ff 75 0c             	pushl  0xc(%ebp)
  8023b4:	e8 5d e4 ff ff       	call   800816 <strcpy>
	return 0;
}
  8023b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8023be:	c9                   	leave  
  8023bf:	c3                   	ret    

008023c0 <devcons_write>:
{
  8023c0:	f3 0f 1e fb          	endbr32 
  8023c4:	55                   	push   %ebp
  8023c5:	89 e5                	mov    %esp,%ebp
  8023c7:	57                   	push   %edi
  8023c8:	56                   	push   %esi
  8023c9:	53                   	push   %ebx
  8023ca:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8023d0:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8023d5:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8023db:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023de:	73 31                	jae    802411 <devcons_write+0x51>
		m = n - tot;
  8023e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8023e3:	29 f3                	sub    %esi,%ebx
  8023e5:	83 fb 7f             	cmp    $0x7f,%ebx
  8023e8:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8023ed:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8023f0:	83 ec 04             	sub    $0x4,%esp
  8023f3:	53                   	push   %ebx
  8023f4:	89 f0                	mov    %esi,%eax
  8023f6:	03 45 0c             	add    0xc(%ebp),%eax
  8023f9:	50                   	push   %eax
  8023fa:	57                   	push   %edi
  8023fb:	e8 cc e5 ff ff       	call   8009cc <memmove>
		sys_cputs(buf, m);
  802400:	83 c4 08             	add    $0x8,%esp
  802403:	53                   	push   %ebx
  802404:	57                   	push   %edi
  802405:	e8 7e e7 ff ff       	call   800b88 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80240a:	01 de                	add    %ebx,%esi
  80240c:	83 c4 10             	add    $0x10,%esp
  80240f:	eb ca                	jmp    8023db <devcons_write+0x1b>
}
  802411:	89 f0                	mov    %esi,%eax
  802413:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802416:	5b                   	pop    %ebx
  802417:	5e                   	pop    %esi
  802418:	5f                   	pop    %edi
  802419:	5d                   	pop    %ebp
  80241a:	c3                   	ret    

0080241b <devcons_read>:
{
  80241b:	f3 0f 1e fb          	endbr32 
  80241f:	55                   	push   %ebp
  802420:	89 e5                	mov    %esp,%ebp
  802422:	83 ec 08             	sub    $0x8,%esp
  802425:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80242a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80242e:	74 21                	je     802451 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802430:	e8 75 e7 ff ff       	call   800baa <sys_cgetc>
  802435:	85 c0                	test   %eax,%eax
  802437:	75 07                	jne    802440 <devcons_read+0x25>
		sys_yield();
  802439:	e8 f7 e7 ff ff       	call   800c35 <sys_yield>
  80243e:	eb f0                	jmp    802430 <devcons_read+0x15>
	if (c < 0)
  802440:	78 0f                	js     802451 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  802442:	83 f8 04             	cmp    $0x4,%eax
  802445:	74 0c                	je     802453 <devcons_read+0x38>
	*(char*)vbuf = c;
  802447:	8b 55 0c             	mov    0xc(%ebp),%edx
  80244a:	88 02                	mov    %al,(%edx)
	return 1;
  80244c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802451:	c9                   	leave  
  802452:	c3                   	ret    
		return 0;
  802453:	b8 00 00 00 00       	mov    $0x0,%eax
  802458:	eb f7                	jmp    802451 <devcons_read+0x36>

0080245a <cputchar>:
{
  80245a:	f3 0f 1e fb          	endbr32 
  80245e:	55                   	push   %ebp
  80245f:	89 e5                	mov    %esp,%ebp
  802461:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802464:	8b 45 08             	mov    0x8(%ebp),%eax
  802467:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80246a:	6a 01                	push   $0x1
  80246c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80246f:	50                   	push   %eax
  802470:	e8 13 e7 ff ff       	call   800b88 <sys_cputs>
}
  802475:	83 c4 10             	add    $0x10,%esp
  802478:	c9                   	leave  
  802479:	c3                   	ret    

0080247a <getchar>:
{
  80247a:	f3 0f 1e fb          	endbr32 
  80247e:	55                   	push   %ebp
  80247f:	89 e5                	mov    %esp,%ebp
  802481:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802484:	6a 01                	push   $0x1
  802486:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802489:	50                   	push   %eax
  80248a:	6a 00                	push   $0x0
  80248c:	e8 a7 f1 ff ff       	call   801638 <read>
	if (r < 0)
  802491:	83 c4 10             	add    $0x10,%esp
  802494:	85 c0                	test   %eax,%eax
  802496:	78 06                	js     80249e <getchar+0x24>
	if (r < 1)
  802498:	74 06                	je     8024a0 <getchar+0x26>
	return c;
  80249a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80249e:	c9                   	leave  
  80249f:	c3                   	ret    
		return -E_EOF;
  8024a0:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8024a5:	eb f7                	jmp    80249e <getchar+0x24>

008024a7 <iscons>:
{
  8024a7:	f3 0f 1e fb          	endbr32 
  8024ab:	55                   	push   %ebp
  8024ac:	89 e5                	mov    %esp,%ebp
  8024ae:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024b4:	50                   	push   %eax
  8024b5:	ff 75 08             	pushl  0x8(%ebp)
  8024b8:	e8 f3 ee ff ff       	call   8013b0 <fd_lookup>
  8024bd:	83 c4 10             	add    $0x10,%esp
  8024c0:	85 c0                	test   %eax,%eax
  8024c2:	78 11                	js     8024d5 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8024c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c7:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8024cd:	39 10                	cmp    %edx,(%eax)
  8024cf:	0f 94 c0             	sete   %al
  8024d2:	0f b6 c0             	movzbl %al,%eax
}
  8024d5:	c9                   	leave  
  8024d6:	c3                   	ret    

008024d7 <opencons>:
{
  8024d7:	f3 0f 1e fb          	endbr32 
  8024db:	55                   	push   %ebp
  8024dc:	89 e5                	mov    %esp,%ebp
  8024de:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8024e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024e4:	50                   	push   %eax
  8024e5:	e8 70 ee ff ff       	call   80135a <fd_alloc>
  8024ea:	83 c4 10             	add    $0x10,%esp
  8024ed:	85 c0                	test   %eax,%eax
  8024ef:	78 3a                	js     80252b <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8024f1:	83 ec 04             	sub    $0x4,%esp
  8024f4:	68 07 04 00 00       	push   $0x407
  8024f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8024fc:	6a 00                	push   $0x0
  8024fe:	e8 55 e7 ff ff       	call   800c58 <sys_page_alloc>
  802503:	83 c4 10             	add    $0x10,%esp
  802506:	85 c0                	test   %eax,%eax
  802508:	78 21                	js     80252b <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80250a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250d:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802513:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802518:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80251f:	83 ec 0c             	sub    $0xc,%esp
  802522:	50                   	push   %eax
  802523:	e8 03 ee ff ff       	call   80132b <fd2num>
  802528:	83 c4 10             	add    $0x10,%esp
}
  80252b:	c9                   	leave  
  80252c:	c3                   	ret    

0080252d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80252d:	f3 0f 1e fb          	endbr32 
  802531:	55                   	push   %ebp
  802532:	89 e5                	mov    %esp,%ebp
  802534:	56                   	push   %esi
  802535:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  802536:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802539:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80253f:	e8 ce e6 ff ff       	call   800c12 <sys_getenvid>
  802544:	83 ec 0c             	sub    $0xc,%esp
  802547:	ff 75 0c             	pushl  0xc(%ebp)
  80254a:	ff 75 08             	pushl  0x8(%ebp)
  80254d:	56                   	push   %esi
  80254e:	50                   	push   %eax
  80254f:	68 28 2e 80 00       	push   $0x802e28
  802554:	e8 b3 dc ff ff       	call   80020c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802559:	83 c4 18             	add    $0x18,%esp
  80255c:	53                   	push   %ebx
  80255d:	ff 75 10             	pushl  0x10(%ebp)
  802560:	e8 52 dc ff ff       	call   8001b7 <vcprintf>
	cprintf("\n");
  802565:	c7 04 24 f4 2c 80 00 	movl   $0x802cf4,(%esp)
  80256c:	e8 9b dc ff ff       	call   80020c <cprintf>
  802571:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802574:	cc                   	int3   
  802575:	eb fd                	jmp    802574 <_panic+0x47>

00802577 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802577:	f3 0f 1e fb          	endbr32 
  80257b:	55                   	push   %ebp
  80257c:	89 e5                	mov    %esp,%ebp
  80257e:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802581:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802588:	74 0a                	je     802594 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80258a:	8b 45 08             	mov    0x8(%ebp),%eax
  80258d:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802592:	c9                   	leave  
  802593:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  802594:	83 ec 04             	sub    $0x4,%esp
  802597:	6a 07                	push   $0x7
  802599:	68 00 f0 bf ee       	push   $0xeebff000
  80259e:	6a 00                	push   $0x0
  8025a0:	e8 b3 e6 ff ff       	call   800c58 <sys_page_alloc>
  8025a5:	83 c4 10             	add    $0x10,%esp
  8025a8:	85 c0                	test   %eax,%eax
  8025aa:	78 2a                	js     8025d6 <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  8025ac:	83 ec 08             	sub    $0x8,%esp
  8025af:	68 ea 25 80 00       	push   $0x8025ea
  8025b4:	6a 00                	push   $0x0
  8025b6:	e8 fc e7 ff ff       	call   800db7 <sys_env_set_pgfault_upcall>
  8025bb:	83 c4 10             	add    $0x10,%esp
  8025be:	85 c0                	test   %eax,%eax
  8025c0:	79 c8                	jns    80258a <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  8025c2:	83 ec 04             	sub    $0x4,%esp
  8025c5:	68 78 2e 80 00       	push   $0x802e78
  8025ca:	6a 25                	push   $0x25
  8025cc:	68 b0 2e 80 00       	push   $0x802eb0
  8025d1:	e8 57 ff ff ff       	call   80252d <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  8025d6:	83 ec 04             	sub    $0x4,%esp
  8025d9:	68 4c 2e 80 00       	push   $0x802e4c
  8025de:	6a 22                	push   $0x22
  8025e0:	68 b0 2e 80 00       	push   $0x802eb0
  8025e5:	e8 43 ff ff ff       	call   80252d <_panic>

008025ea <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8025ea:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8025eb:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  8025f0:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8025f2:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  8025f5:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  8025f9:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  8025fd:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802600:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  802602:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  802606:	83 c4 08             	add    $0x8,%esp
	popal
  802609:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  80260a:	83 c4 04             	add    $0x4,%esp
	popfl
  80260d:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  80260e:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  80260f:	c3                   	ret    

00802610 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802610:	f3 0f 1e fb          	endbr32 
  802614:	55                   	push   %ebp
  802615:	89 e5                	mov    %esp,%ebp
  802617:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80261a:	89 c2                	mov    %eax,%edx
  80261c:	c1 ea 16             	shr    $0x16,%edx
  80261f:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802626:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  80262b:	f6 c1 01             	test   $0x1,%cl
  80262e:	74 1c                	je     80264c <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802630:	c1 e8 0c             	shr    $0xc,%eax
  802633:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80263a:	a8 01                	test   $0x1,%al
  80263c:	74 0e                	je     80264c <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80263e:	c1 e8 0c             	shr    $0xc,%eax
  802641:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802648:	ef 
  802649:	0f b7 d2             	movzwl %dx,%edx
}
  80264c:	89 d0                	mov    %edx,%eax
  80264e:	5d                   	pop    %ebp
  80264f:	c3                   	ret    

00802650 <__udivdi3>:
  802650:	f3 0f 1e fb          	endbr32 
  802654:	55                   	push   %ebp
  802655:	57                   	push   %edi
  802656:	56                   	push   %esi
  802657:	53                   	push   %ebx
  802658:	83 ec 1c             	sub    $0x1c,%esp
  80265b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80265f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802663:	8b 74 24 34          	mov    0x34(%esp),%esi
  802667:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80266b:	85 d2                	test   %edx,%edx
  80266d:	75 19                	jne    802688 <__udivdi3+0x38>
  80266f:	39 f3                	cmp    %esi,%ebx
  802671:	76 4d                	jbe    8026c0 <__udivdi3+0x70>
  802673:	31 ff                	xor    %edi,%edi
  802675:	89 e8                	mov    %ebp,%eax
  802677:	89 f2                	mov    %esi,%edx
  802679:	f7 f3                	div    %ebx
  80267b:	89 fa                	mov    %edi,%edx
  80267d:	83 c4 1c             	add    $0x1c,%esp
  802680:	5b                   	pop    %ebx
  802681:	5e                   	pop    %esi
  802682:	5f                   	pop    %edi
  802683:	5d                   	pop    %ebp
  802684:	c3                   	ret    
  802685:	8d 76 00             	lea    0x0(%esi),%esi
  802688:	39 f2                	cmp    %esi,%edx
  80268a:	76 14                	jbe    8026a0 <__udivdi3+0x50>
  80268c:	31 ff                	xor    %edi,%edi
  80268e:	31 c0                	xor    %eax,%eax
  802690:	89 fa                	mov    %edi,%edx
  802692:	83 c4 1c             	add    $0x1c,%esp
  802695:	5b                   	pop    %ebx
  802696:	5e                   	pop    %esi
  802697:	5f                   	pop    %edi
  802698:	5d                   	pop    %ebp
  802699:	c3                   	ret    
  80269a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8026a0:	0f bd fa             	bsr    %edx,%edi
  8026a3:	83 f7 1f             	xor    $0x1f,%edi
  8026a6:	75 48                	jne    8026f0 <__udivdi3+0xa0>
  8026a8:	39 f2                	cmp    %esi,%edx
  8026aa:	72 06                	jb     8026b2 <__udivdi3+0x62>
  8026ac:	31 c0                	xor    %eax,%eax
  8026ae:	39 eb                	cmp    %ebp,%ebx
  8026b0:	77 de                	ja     802690 <__udivdi3+0x40>
  8026b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8026b7:	eb d7                	jmp    802690 <__udivdi3+0x40>
  8026b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026c0:	89 d9                	mov    %ebx,%ecx
  8026c2:	85 db                	test   %ebx,%ebx
  8026c4:	75 0b                	jne    8026d1 <__udivdi3+0x81>
  8026c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8026cb:	31 d2                	xor    %edx,%edx
  8026cd:	f7 f3                	div    %ebx
  8026cf:	89 c1                	mov    %eax,%ecx
  8026d1:	31 d2                	xor    %edx,%edx
  8026d3:	89 f0                	mov    %esi,%eax
  8026d5:	f7 f1                	div    %ecx
  8026d7:	89 c6                	mov    %eax,%esi
  8026d9:	89 e8                	mov    %ebp,%eax
  8026db:	89 f7                	mov    %esi,%edi
  8026dd:	f7 f1                	div    %ecx
  8026df:	89 fa                	mov    %edi,%edx
  8026e1:	83 c4 1c             	add    $0x1c,%esp
  8026e4:	5b                   	pop    %ebx
  8026e5:	5e                   	pop    %esi
  8026e6:	5f                   	pop    %edi
  8026e7:	5d                   	pop    %ebp
  8026e8:	c3                   	ret    
  8026e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026f0:	89 f9                	mov    %edi,%ecx
  8026f2:	b8 20 00 00 00       	mov    $0x20,%eax
  8026f7:	29 f8                	sub    %edi,%eax
  8026f9:	d3 e2                	shl    %cl,%edx
  8026fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8026ff:	89 c1                	mov    %eax,%ecx
  802701:	89 da                	mov    %ebx,%edx
  802703:	d3 ea                	shr    %cl,%edx
  802705:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802709:	09 d1                	or     %edx,%ecx
  80270b:	89 f2                	mov    %esi,%edx
  80270d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802711:	89 f9                	mov    %edi,%ecx
  802713:	d3 e3                	shl    %cl,%ebx
  802715:	89 c1                	mov    %eax,%ecx
  802717:	d3 ea                	shr    %cl,%edx
  802719:	89 f9                	mov    %edi,%ecx
  80271b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80271f:	89 eb                	mov    %ebp,%ebx
  802721:	d3 e6                	shl    %cl,%esi
  802723:	89 c1                	mov    %eax,%ecx
  802725:	d3 eb                	shr    %cl,%ebx
  802727:	09 de                	or     %ebx,%esi
  802729:	89 f0                	mov    %esi,%eax
  80272b:	f7 74 24 08          	divl   0x8(%esp)
  80272f:	89 d6                	mov    %edx,%esi
  802731:	89 c3                	mov    %eax,%ebx
  802733:	f7 64 24 0c          	mull   0xc(%esp)
  802737:	39 d6                	cmp    %edx,%esi
  802739:	72 15                	jb     802750 <__udivdi3+0x100>
  80273b:	89 f9                	mov    %edi,%ecx
  80273d:	d3 e5                	shl    %cl,%ebp
  80273f:	39 c5                	cmp    %eax,%ebp
  802741:	73 04                	jae    802747 <__udivdi3+0xf7>
  802743:	39 d6                	cmp    %edx,%esi
  802745:	74 09                	je     802750 <__udivdi3+0x100>
  802747:	89 d8                	mov    %ebx,%eax
  802749:	31 ff                	xor    %edi,%edi
  80274b:	e9 40 ff ff ff       	jmp    802690 <__udivdi3+0x40>
  802750:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802753:	31 ff                	xor    %edi,%edi
  802755:	e9 36 ff ff ff       	jmp    802690 <__udivdi3+0x40>
  80275a:	66 90                	xchg   %ax,%ax
  80275c:	66 90                	xchg   %ax,%ax
  80275e:	66 90                	xchg   %ax,%ax

00802760 <__umoddi3>:
  802760:	f3 0f 1e fb          	endbr32 
  802764:	55                   	push   %ebp
  802765:	57                   	push   %edi
  802766:	56                   	push   %esi
  802767:	53                   	push   %ebx
  802768:	83 ec 1c             	sub    $0x1c,%esp
  80276b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80276f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802773:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802777:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80277b:	85 c0                	test   %eax,%eax
  80277d:	75 19                	jne    802798 <__umoddi3+0x38>
  80277f:	39 df                	cmp    %ebx,%edi
  802781:	76 5d                	jbe    8027e0 <__umoddi3+0x80>
  802783:	89 f0                	mov    %esi,%eax
  802785:	89 da                	mov    %ebx,%edx
  802787:	f7 f7                	div    %edi
  802789:	89 d0                	mov    %edx,%eax
  80278b:	31 d2                	xor    %edx,%edx
  80278d:	83 c4 1c             	add    $0x1c,%esp
  802790:	5b                   	pop    %ebx
  802791:	5e                   	pop    %esi
  802792:	5f                   	pop    %edi
  802793:	5d                   	pop    %ebp
  802794:	c3                   	ret    
  802795:	8d 76 00             	lea    0x0(%esi),%esi
  802798:	89 f2                	mov    %esi,%edx
  80279a:	39 d8                	cmp    %ebx,%eax
  80279c:	76 12                	jbe    8027b0 <__umoddi3+0x50>
  80279e:	89 f0                	mov    %esi,%eax
  8027a0:	89 da                	mov    %ebx,%edx
  8027a2:	83 c4 1c             	add    $0x1c,%esp
  8027a5:	5b                   	pop    %ebx
  8027a6:	5e                   	pop    %esi
  8027a7:	5f                   	pop    %edi
  8027a8:	5d                   	pop    %ebp
  8027a9:	c3                   	ret    
  8027aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8027b0:	0f bd e8             	bsr    %eax,%ebp
  8027b3:	83 f5 1f             	xor    $0x1f,%ebp
  8027b6:	75 50                	jne    802808 <__umoddi3+0xa8>
  8027b8:	39 d8                	cmp    %ebx,%eax
  8027ba:	0f 82 e0 00 00 00    	jb     8028a0 <__umoddi3+0x140>
  8027c0:	89 d9                	mov    %ebx,%ecx
  8027c2:	39 f7                	cmp    %esi,%edi
  8027c4:	0f 86 d6 00 00 00    	jbe    8028a0 <__umoddi3+0x140>
  8027ca:	89 d0                	mov    %edx,%eax
  8027cc:	89 ca                	mov    %ecx,%edx
  8027ce:	83 c4 1c             	add    $0x1c,%esp
  8027d1:	5b                   	pop    %ebx
  8027d2:	5e                   	pop    %esi
  8027d3:	5f                   	pop    %edi
  8027d4:	5d                   	pop    %ebp
  8027d5:	c3                   	ret    
  8027d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027dd:	8d 76 00             	lea    0x0(%esi),%esi
  8027e0:	89 fd                	mov    %edi,%ebp
  8027e2:	85 ff                	test   %edi,%edi
  8027e4:	75 0b                	jne    8027f1 <__umoddi3+0x91>
  8027e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8027eb:	31 d2                	xor    %edx,%edx
  8027ed:	f7 f7                	div    %edi
  8027ef:	89 c5                	mov    %eax,%ebp
  8027f1:	89 d8                	mov    %ebx,%eax
  8027f3:	31 d2                	xor    %edx,%edx
  8027f5:	f7 f5                	div    %ebp
  8027f7:	89 f0                	mov    %esi,%eax
  8027f9:	f7 f5                	div    %ebp
  8027fb:	89 d0                	mov    %edx,%eax
  8027fd:	31 d2                	xor    %edx,%edx
  8027ff:	eb 8c                	jmp    80278d <__umoddi3+0x2d>
  802801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802808:	89 e9                	mov    %ebp,%ecx
  80280a:	ba 20 00 00 00       	mov    $0x20,%edx
  80280f:	29 ea                	sub    %ebp,%edx
  802811:	d3 e0                	shl    %cl,%eax
  802813:	89 44 24 08          	mov    %eax,0x8(%esp)
  802817:	89 d1                	mov    %edx,%ecx
  802819:	89 f8                	mov    %edi,%eax
  80281b:	d3 e8                	shr    %cl,%eax
  80281d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802821:	89 54 24 04          	mov    %edx,0x4(%esp)
  802825:	8b 54 24 04          	mov    0x4(%esp),%edx
  802829:	09 c1                	or     %eax,%ecx
  80282b:	89 d8                	mov    %ebx,%eax
  80282d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802831:	89 e9                	mov    %ebp,%ecx
  802833:	d3 e7                	shl    %cl,%edi
  802835:	89 d1                	mov    %edx,%ecx
  802837:	d3 e8                	shr    %cl,%eax
  802839:	89 e9                	mov    %ebp,%ecx
  80283b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80283f:	d3 e3                	shl    %cl,%ebx
  802841:	89 c7                	mov    %eax,%edi
  802843:	89 d1                	mov    %edx,%ecx
  802845:	89 f0                	mov    %esi,%eax
  802847:	d3 e8                	shr    %cl,%eax
  802849:	89 e9                	mov    %ebp,%ecx
  80284b:	89 fa                	mov    %edi,%edx
  80284d:	d3 e6                	shl    %cl,%esi
  80284f:	09 d8                	or     %ebx,%eax
  802851:	f7 74 24 08          	divl   0x8(%esp)
  802855:	89 d1                	mov    %edx,%ecx
  802857:	89 f3                	mov    %esi,%ebx
  802859:	f7 64 24 0c          	mull   0xc(%esp)
  80285d:	89 c6                	mov    %eax,%esi
  80285f:	89 d7                	mov    %edx,%edi
  802861:	39 d1                	cmp    %edx,%ecx
  802863:	72 06                	jb     80286b <__umoddi3+0x10b>
  802865:	75 10                	jne    802877 <__umoddi3+0x117>
  802867:	39 c3                	cmp    %eax,%ebx
  802869:	73 0c                	jae    802877 <__umoddi3+0x117>
  80286b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80286f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802873:	89 d7                	mov    %edx,%edi
  802875:	89 c6                	mov    %eax,%esi
  802877:	89 ca                	mov    %ecx,%edx
  802879:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80287e:	29 f3                	sub    %esi,%ebx
  802880:	19 fa                	sbb    %edi,%edx
  802882:	89 d0                	mov    %edx,%eax
  802884:	d3 e0                	shl    %cl,%eax
  802886:	89 e9                	mov    %ebp,%ecx
  802888:	d3 eb                	shr    %cl,%ebx
  80288a:	d3 ea                	shr    %cl,%edx
  80288c:	09 d8                	or     %ebx,%eax
  80288e:	83 c4 1c             	add    $0x1c,%esp
  802891:	5b                   	pop    %ebx
  802892:	5e                   	pop    %esi
  802893:	5f                   	pop    %edi
  802894:	5d                   	pop    %ebp
  802895:	c3                   	ret    
  802896:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80289d:	8d 76 00             	lea    0x0(%esi),%esi
  8028a0:	29 fe                	sub    %edi,%esi
  8028a2:	19 c3                	sbb    %eax,%ebx
  8028a4:	89 f2                	mov    %esi,%edx
  8028a6:	89 d9                	mov    %ebx,%ecx
  8028a8:	e9 1d ff ff ff       	jmp    8027ca <__umoddi3+0x6a>
