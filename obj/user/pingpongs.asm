
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
  800040:	e8 ff 10 00 00       	call   801144 <sfork>
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
  800057:	e8 06 11 00 00       	call   801162 <ipc_recv>
		cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  80005c:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  800062:	8b 7b 48             	mov    0x48(%ebx),%edi
  800065:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800068:	a1 04 40 80 00       	mov    0x804004,%eax
  80006d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800070:	e8 9d 0b 00 00       	call   800c12 <sys_getenvid>
  800075:	83 c4 08             	add    $0x8,%esp
  800078:	57                   	push   %edi
  800079:	53                   	push   %ebx
  80007a:	56                   	push   %esi
  80007b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80007e:	50                   	push   %eax
  80007f:	68 90 23 80 00       	push   $0x802390
  800084:	e8 83 01 00 00       	call   80020c <cprintf>
		if (val == 10)
  800089:	a1 04 40 80 00       	mov    0x804004,%eax
  80008e:	83 c4 20             	add    $0x20,%esp
  800091:	83 f8 0a             	cmp    $0xa,%eax
  800094:	74 22                	je     8000b8 <umain+0x85>
			return;
		++val;
  800096:	83 c0 01             	add    $0x1,%eax
  800099:	a3 04 40 80 00       	mov    %eax,0x804004
		ipc_send(who, 0, 0, 0);
  80009e:	6a 00                	push   $0x0
  8000a0:	6a 00                	push   $0x0
  8000a2:	6a 00                	push   $0x0
  8000a4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000a7:	e8 3b 11 00 00       	call   8011e7 <ipc_send>
		if (val == 10)
  8000ac:	83 c4 10             	add    $0x10,%esp
  8000af:	83 3d 04 40 80 00 0a 	cmpl   $0xa,0x804004
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
  8000c0:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  8000c6:	e8 47 0b 00 00       	call   800c12 <sys_getenvid>
  8000cb:	83 ec 04             	sub    $0x4,%esp
  8000ce:	53                   	push   %ebx
  8000cf:	50                   	push   %eax
  8000d0:	68 60 23 80 00       	push   $0x802360
  8000d5:	e8 32 01 00 00       	call   80020c <cprintf>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  8000da:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8000dd:	e8 30 0b 00 00       	call   800c12 <sys_getenvid>
  8000e2:	83 c4 0c             	add    $0xc,%esp
  8000e5:	53                   	push   %ebx
  8000e6:	50                   	push   %eax
  8000e7:	68 7a 23 80 00       	push   $0x80237a
  8000ec:	e8 1b 01 00 00       	call   80020c <cprintf>
		ipc_send(who, 0, 0, 0);
  8000f1:	6a 00                	push   $0x0
  8000f3:	6a 00                	push   $0x0
  8000f5:	6a 00                	push   $0x0
  8000f7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000fa:	e8 e8 10 00 00       	call   8011e7 <ipc_send>
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
  800128:	a3 08 40 80 00       	mov    %eax,0x804008

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
  80015b:	e8 0b 13 00 00       	call   80146b <close_all>
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
  800272:	e8 79 1e 00 00       	call   8020f0 <__udivdi3>
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
  8002b0:	e8 4b 1f 00 00       	call   802200 <__umoddi3>
  8002b5:	83 c4 14             	add    $0x14,%esp
  8002b8:	0f be 80 c0 23 80 00 	movsbl 0x8023c0(%eax),%eax
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
  80035f:	3e ff 24 85 00 25 80 	notrack jmp *0x802500(,%eax,4)
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
  80042c:	8b 14 85 60 26 80 00 	mov    0x802660(,%eax,4),%edx
  800433:	85 d2                	test   %edx,%edx
  800435:	74 18                	je     80044f <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800437:	52                   	push   %edx
  800438:	68 45 28 80 00       	push   $0x802845
  80043d:	53                   	push   %ebx
  80043e:	56                   	push   %esi
  80043f:	e8 aa fe ff ff       	call   8002ee <printfmt>
  800444:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800447:	89 7d 14             	mov    %edi,0x14(%ebp)
  80044a:	e9 66 02 00 00       	jmp    8006b5 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80044f:	50                   	push   %eax
  800450:	68 d8 23 80 00       	push   $0x8023d8
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
  800477:	b8 d1 23 80 00       	mov    $0x8023d1,%eax
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
  800c01:	68 bf 26 80 00       	push   $0x8026bf
  800c06:	6a 23                	push   $0x23
  800c08:	68 dc 26 80 00       	push   $0x8026dc
  800c0d:	e8 af 13 00 00       	call   801fc1 <_panic>

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
  800c8e:	68 bf 26 80 00       	push   $0x8026bf
  800c93:	6a 23                	push   $0x23
  800c95:	68 dc 26 80 00       	push   $0x8026dc
  800c9a:	e8 22 13 00 00       	call   801fc1 <_panic>

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
  800cd4:	68 bf 26 80 00       	push   $0x8026bf
  800cd9:	6a 23                	push   $0x23
  800cdb:	68 dc 26 80 00       	push   $0x8026dc
  800ce0:	e8 dc 12 00 00       	call   801fc1 <_panic>

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
  800d1a:	68 bf 26 80 00       	push   $0x8026bf
  800d1f:	6a 23                	push   $0x23
  800d21:	68 dc 26 80 00       	push   $0x8026dc
  800d26:	e8 96 12 00 00       	call   801fc1 <_panic>

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
  800d60:	68 bf 26 80 00       	push   $0x8026bf
  800d65:	6a 23                	push   $0x23
  800d67:	68 dc 26 80 00       	push   $0x8026dc
  800d6c:	e8 50 12 00 00       	call   801fc1 <_panic>

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
  800da6:	68 bf 26 80 00       	push   $0x8026bf
  800dab:	6a 23                	push   $0x23
  800dad:	68 dc 26 80 00       	push   $0x8026dc
  800db2:	e8 0a 12 00 00       	call   801fc1 <_panic>

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
  800dec:	68 bf 26 80 00       	push   $0x8026bf
  800df1:	6a 23                	push   $0x23
  800df3:	68 dc 26 80 00       	push   $0x8026dc
  800df8:	e8 c4 11 00 00       	call   801fc1 <_panic>

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
  800e58:	68 bf 26 80 00       	push   $0x8026bf
  800e5d:	6a 23                	push   $0x23
  800e5f:	68 dc 26 80 00       	push   $0x8026dc
  800e64:	e8 58 11 00 00       	call   801fc1 <_panic>

00800e69 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800e69:	f3 0f 1e fb          	endbr32 
  800e6d:	55                   	push   %ebp
  800e6e:	89 e5                	mov    %esp,%ebp
  800e70:	53                   	push   %ebx
  800e71:	83 ec 04             	sub    $0x4,%esp
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800e77:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  800e79:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800e7d:	74 74                	je     800ef3 <pgfault+0x8a>
  800e7f:	89 d8                	mov    %ebx,%eax
  800e81:	c1 e8 0c             	shr    $0xc,%eax
  800e84:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800e8b:	f6 c4 08             	test   $0x8,%ah
  800e8e:	74 63                	je     800ef3 <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800e90:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  800e96:	83 ec 0c             	sub    $0xc,%esp
  800e99:	6a 05                	push   $0x5
  800e9b:	68 00 f0 7f 00       	push   $0x7ff000
  800ea0:	6a 00                	push   $0x0
  800ea2:	53                   	push   %ebx
  800ea3:	6a 00                	push   $0x0
  800ea5:	e8 f5 fd ff ff       	call   800c9f <sys_page_map>
  800eaa:	83 c4 20             	add    $0x20,%esp
  800ead:	85 c0                	test   %eax,%eax
  800eaf:	78 59                	js     800f0a <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  800eb1:	83 ec 04             	sub    $0x4,%esp
  800eb4:	6a 07                	push   $0x7
  800eb6:	53                   	push   %ebx
  800eb7:	6a 00                	push   $0x0
  800eb9:	e8 9a fd ff ff       	call   800c58 <sys_page_alloc>
  800ebe:	83 c4 10             	add    $0x10,%esp
  800ec1:	85 c0                	test   %eax,%eax
  800ec3:	78 5a                	js     800f1f <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  800ec5:	83 ec 04             	sub    $0x4,%esp
  800ec8:	68 00 10 00 00       	push   $0x1000
  800ecd:	68 00 f0 7f 00       	push   $0x7ff000
  800ed2:	53                   	push   %ebx
  800ed3:	e8 f4 fa ff ff       	call   8009cc <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  800ed8:	83 c4 08             	add    $0x8,%esp
  800edb:	68 00 f0 7f 00       	push   $0x7ff000
  800ee0:	6a 00                	push   $0x0
  800ee2:	e8 fe fd ff ff       	call   800ce5 <sys_page_unmap>
  800ee7:	83 c4 10             	add    $0x10,%esp
  800eea:	85 c0                	test   %eax,%eax
  800eec:	78 46                	js     800f34 <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  800eee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ef1:	c9                   	leave  
  800ef2:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  800ef3:	83 ec 04             	sub    $0x4,%esp
  800ef6:	68 ea 26 80 00       	push   $0x8026ea
  800efb:	68 d3 00 00 00       	push   $0xd3
  800f00:	68 06 27 80 00       	push   $0x802706
  800f05:	e8 b7 10 00 00       	call   801fc1 <_panic>
		panic("pgfault: %e\n", r);
  800f0a:	50                   	push   %eax
  800f0b:	68 11 27 80 00       	push   $0x802711
  800f10:	68 df 00 00 00       	push   $0xdf
  800f15:	68 06 27 80 00       	push   $0x802706
  800f1a:	e8 a2 10 00 00       	call   801fc1 <_panic>
		panic("pgfault: %e\n", r);
  800f1f:	50                   	push   %eax
  800f20:	68 11 27 80 00       	push   $0x802711
  800f25:	68 e3 00 00 00       	push   $0xe3
  800f2a:	68 06 27 80 00       	push   $0x802706
  800f2f:	e8 8d 10 00 00       	call   801fc1 <_panic>
		panic("pgfault: %e\n", r);
  800f34:	50                   	push   %eax
  800f35:	68 11 27 80 00       	push   $0x802711
  800f3a:	68 e9 00 00 00       	push   $0xe9
  800f3f:	68 06 27 80 00       	push   $0x802706
  800f44:	e8 78 10 00 00       	call   801fc1 <_panic>

00800f49 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800f49:	f3 0f 1e fb          	endbr32 
  800f4d:	55                   	push   %ebp
  800f4e:	89 e5                	mov    %esp,%ebp
  800f50:	57                   	push   %edi
  800f51:	56                   	push   %esi
  800f52:	53                   	push   %ebx
  800f53:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  800f56:	68 69 0e 80 00       	push   $0x800e69
  800f5b:	e8 ab 10 00 00       	call   80200b <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f60:	b8 07 00 00 00       	mov    $0x7,%eax
  800f65:	cd 30                	int    $0x30
  800f67:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  800f6a:	83 c4 10             	add    $0x10,%esp
  800f6d:	85 c0                	test   %eax,%eax
  800f6f:	78 2d                	js     800f9e <fork+0x55>
  800f71:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800f73:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  800f78:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f7c:	0f 85 9b 00 00 00    	jne    80101d <fork+0xd4>
		thisenv = &envs[ENVX(sys_getenvid())];
  800f82:	e8 8b fc ff ff       	call   800c12 <sys_getenvid>
  800f87:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f8c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f8f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f94:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  800f99:	e9 71 01 00 00       	jmp    80110f <fork+0x1c6>
		panic("sys_exofork: %e", envid);
  800f9e:	50                   	push   %eax
  800f9f:	68 1e 27 80 00       	push   $0x80271e
  800fa4:	68 2a 01 00 00       	push   $0x12a
  800fa9:	68 06 27 80 00       	push   $0x802706
  800fae:	e8 0e 10 00 00       	call   801fc1 <_panic>
		sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_SYSCALL);
  800fb3:	c1 e6 0c             	shl    $0xc,%esi
  800fb6:	83 ec 0c             	sub    $0xc,%esp
  800fb9:	68 07 0e 00 00       	push   $0xe07
  800fbe:	56                   	push   %esi
  800fbf:	57                   	push   %edi
  800fc0:	56                   	push   %esi
  800fc1:	6a 00                	push   $0x0
  800fc3:	e8 d7 fc ff ff       	call   800c9f <sys_page_map>
  800fc8:	83 c4 20             	add    $0x20,%esp
  800fcb:	eb 3e                	jmp    80100b <fork+0xc2>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  800fcd:	c1 e6 0c             	shl    $0xc,%esi
  800fd0:	83 ec 0c             	sub    $0xc,%esp
  800fd3:	68 05 08 00 00       	push   $0x805
  800fd8:	56                   	push   %esi
  800fd9:	57                   	push   %edi
  800fda:	56                   	push   %esi
  800fdb:	6a 00                	push   $0x0
  800fdd:	e8 bd fc ff ff       	call   800c9f <sys_page_map>
  800fe2:	83 c4 20             	add    $0x20,%esp
  800fe5:	85 c0                	test   %eax,%eax
  800fe7:	0f 88 bc 00 00 00    	js     8010a9 <fork+0x160>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  800fed:	83 ec 0c             	sub    $0xc,%esp
  800ff0:	68 05 08 00 00       	push   $0x805
  800ff5:	56                   	push   %esi
  800ff6:	6a 00                	push   $0x0
  800ff8:	56                   	push   %esi
  800ff9:	6a 00                	push   $0x0
  800ffb:	e8 9f fc ff ff       	call   800c9f <sys_page_map>
  801000:	83 c4 20             	add    $0x20,%esp
  801003:	85 c0                	test   %eax,%eax
  801005:	0f 88 b3 00 00 00    	js     8010be <fork+0x175>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  80100b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801011:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801017:	0f 84 b6 00 00 00    	je     8010d3 <fork+0x18a>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  80101d:	89 d8                	mov    %ebx,%eax
  80101f:	c1 e8 16             	shr    $0x16,%eax
  801022:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801029:	a8 01                	test   $0x1,%al
  80102b:	74 de                	je     80100b <fork+0xc2>
  80102d:	89 de                	mov    %ebx,%esi
  80102f:	c1 ee 0c             	shr    $0xc,%esi
  801032:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801039:	a8 01                	test   $0x1,%al
  80103b:	74 ce                	je     80100b <fork+0xc2>
  80103d:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801044:	a8 04                	test   $0x4,%al
  801046:	74 c3                	je     80100b <fork+0xc2>
	if ((uvpt[pn] & PTE_SHARE)){
  801048:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80104f:	f6 c4 04             	test   $0x4,%ah
  801052:	0f 85 5b ff ff ff    	jne    800fb3 <fork+0x6a>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  801058:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80105f:	a8 02                	test   $0x2,%al
  801061:	0f 85 66 ff ff ff    	jne    800fcd <fork+0x84>
  801067:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80106e:	f6 c4 08             	test   $0x8,%ah
  801071:	0f 85 56 ff ff ff    	jne    800fcd <fork+0x84>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  801077:	c1 e6 0c             	shl    $0xc,%esi
  80107a:	83 ec 0c             	sub    $0xc,%esp
  80107d:	6a 05                	push   $0x5
  80107f:	56                   	push   %esi
  801080:	57                   	push   %edi
  801081:	56                   	push   %esi
  801082:	6a 00                	push   $0x0
  801084:	e8 16 fc ff ff       	call   800c9f <sys_page_map>
  801089:	83 c4 20             	add    $0x20,%esp
  80108c:	85 c0                	test   %eax,%eax
  80108e:	0f 89 77 ff ff ff    	jns    80100b <fork+0xc2>
		panic("duppage: %e\n", r);
  801094:	50                   	push   %eax
  801095:	68 2e 27 80 00       	push   $0x80272e
  80109a:	68 0c 01 00 00       	push   $0x10c
  80109f:	68 06 27 80 00       	push   $0x802706
  8010a4:	e8 18 0f 00 00       	call   801fc1 <_panic>
			panic("duppage: %e\n", r);
  8010a9:	50                   	push   %eax
  8010aa:	68 2e 27 80 00       	push   $0x80272e
  8010af:	68 05 01 00 00       	push   $0x105
  8010b4:	68 06 27 80 00       	push   $0x802706
  8010b9:	e8 03 0f 00 00       	call   801fc1 <_panic>
			panic("duppage: %e\n", r);
  8010be:	50                   	push   %eax
  8010bf:	68 2e 27 80 00       	push   $0x80272e
  8010c4:	68 09 01 00 00       	push   $0x109
  8010c9:	68 06 27 80 00       	push   $0x802706
  8010ce:	e8 ee 0e 00 00       	call   801fc1 <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  8010d3:	83 ec 04             	sub    $0x4,%esp
  8010d6:	6a 07                	push   $0x7
  8010d8:	68 00 f0 bf ee       	push   $0xeebff000
  8010dd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010e0:	e8 73 fb ff ff       	call   800c58 <sys_page_alloc>
  8010e5:	83 c4 10             	add    $0x10,%esp
  8010e8:	85 c0                	test   %eax,%eax
  8010ea:	78 2e                	js     80111a <fork+0x1d1>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8010ec:	83 ec 08             	sub    $0x8,%esp
  8010ef:	68 7e 20 80 00       	push   $0x80207e
  8010f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8010f7:	57                   	push   %edi
  8010f8:	e8 ba fc ff ff       	call   800db7 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8010fd:	83 c4 08             	add    $0x8,%esp
  801100:	6a 02                	push   $0x2
  801102:	57                   	push   %edi
  801103:	e8 23 fc ff ff       	call   800d2b <sys_env_set_status>
  801108:	83 c4 10             	add    $0x10,%esp
  80110b:	85 c0                	test   %eax,%eax
  80110d:	78 20                	js     80112f <fork+0x1e6>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  80110f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801112:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801115:	5b                   	pop    %ebx
  801116:	5e                   	pop    %esi
  801117:	5f                   	pop    %edi
  801118:	5d                   	pop    %ebp
  801119:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  80111a:	50                   	push   %eax
  80111b:	68 3b 27 80 00       	push   $0x80273b
  801120:	68 3e 01 00 00       	push   $0x13e
  801125:	68 06 27 80 00       	push   $0x802706
  80112a:	e8 92 0e 00 00       	call   801fc1 <_panic>
		panic("sys_env_set_status: %e", r);
  80112f:	50                   	push   %eax
  801130:	68 4e 27 80 00       	push   $0x80274e
  801135:	68 43 01 00 00       	push   $0x143
  80113a:	68 06 27 80 00       	push   $0x802706
  80113f:	e8 7d 0e 00 00       	call   801fc1 <_panic>

00801144 <sfork>:

// Challenge!
int
sfork(void)
{
  801144:	f3 0f 1e fb          	endbr32 
  801148:	55                   	push   %ebp
  801149:	89 e5                	mov    %esp,%ebp
  80114b:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80114e:	68 65 27 80 00       	push   $0x802765
  801153:	68 4c 01 00 00       	push   $0x14c
  801158:	68 06 27 80 00       	push   $0x802706
  80115d:	e8 5f 0e 00 00       	call   801fc1 <_panic>

00801162 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801162:	f3 0f 1e fb          	endbr32 
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
  801169:	56                   	push   %esi
  80116a:	53                   	push   %ebx
  80116b:	8b 75 08             	mov    0x8(%ebp),%esi
  80116e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801171:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  801174:	85 c0                	test   %eax,%eax
  801176:	74 3d                	je     8011b5 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  801178:	83 ec 0c             	sub    $0xc,%esp
  80117b:	50                   	push   %eax
  80117c:	e8 a3 fc ff ff       	call   800e24 <sys_ipc_recv>
  801181:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  801184:	85 f6                	test   %esi,%esi
  801186:	74 0b                	je     801193 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801188:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80118e:	8b 52 74             	mov    0x74(%edx),%edx
  801191:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801193:	85 db                	test   %ebx,%ebx
  801195:	74 0b                	je     8011a2 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  801197:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80119d:	8b 52 78             	mov    0x78(%edx),%edx
  8011a0:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  8011a2:	85 c0                	test   %eax,%eax
  8011a4:	78 21                	js     8011c7 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  8011a6:	a1 08 40 80 00       	mov    0x804008,%eax
  8011ab:	8b 40 70             	mov    0x70(%eax),%eax
}
  8011ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011b1:	5b                   	pop    %ebx
  8011b2:	5e                   	pop    %esi
  8011b3:	5d                   	pop    %ebp
  8011b4:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  8011b5:	83 ec 0c             	sub    $0xc,%esp
  8011b8:	68 00 00 c0 ee       	push   $0xeec00000
  8011bd:	e8 62 fc ff ff       	call   800e24 <sys_ipc_recv>
  8011c2:	83 c4 10             	add    $0x10,%esp
  8011c5:	eb bd                	jmp    801184 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  8011c7:	85 f6                	test   %esi,%esi
  8011c9:	74 10                	je     8011db <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  8011cb:	85 db                	test   %ebx,%ebx
  8011cd:	75 df                	jne    8011ae <ipc_recv+0x4c>
  8011cf:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8011d6:	00 00 00 
  8011d9:	eb d3                	jmp    8011ae <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  8011db:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8011e2:	00 00 00 
  8011e5:	eb e4                	jmp    8011cb <ipc_recv+0x69>

008011e7 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8011e7:	f3 0f 1e fb          	endbr32 
  8011eb:	55                   	push   %ebp
  8011ec:	89 e5                	mov    %esp,%ebp
  8011ee:	57                   	push   %edi
  8011ef:	56                   	push   %esi
  8011f0:	53                   	push   %ebx
  8011f1:	83 ec 0c             	sub    $0xc,%esp
  8011f4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011f7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011fa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  8011fd:	85 db                	test   %ebx,%ebx
  8011ff:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801204:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  801207:	ff 75 14             	pushl  0x14(%ebp)
  80120a:	53                   	push   %ebx
  80120b:	56                   	push   %esi
  80120c:	57                   	push   %edi
  80120d:	e8 eb fb ff ff       	call   800dfd <sys_ipc_try_send>
  801212:	83 c4 10             	add    $0x10,%esp
  801215:	85 c0                	test   %eax,%eax
  801217:	79 1e                	jns    801237 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  801219:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80121c:	75 07                	jne    801225 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  80121e:	e8 12 fa ff ff       	call   800c35 <sys_yield>
  801223:	eb e2                	jmp    801207 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  801225:	50                   	push   %eax
  801226:	68 7b 27 80 00       	push   $0x80277b
  80122b:	6a 59                	push   $0x59
  80122d:	68 96 27 80 00       	push   $0x802796
  801232:	e8 8a 0d 00 00       	call   801fc1 <_panic>
	}
}
  801237:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80123a:	5b                   	pop    %ebx
  80123b:	5e                   	pop    %esi
  80123c:	5f                   	pop    %edi
  80123d:	5d                   	pop    %ebp
  80123e:	c3                   	ret    

0080123f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80123f:	f3 0f 1e fb          	endbr32 
  801243:	55                   	push   %ebp
  801244:	89 e5                	mov    %esp,%ebp
  801246:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801249:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80124e:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801251:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801257:	8b 52 50             	mov    0x50(%edx),%edx
  80125a:	39 ca                	cmp    %ecx,%edx
  80125c:	74 11                	je     80126f <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80125e:	83 c0 01             	add    $0x1,%eax
  801261:	3d 00 04 00 00       	cmp    $0x400,%eax
  801266:	75 e6                	jne    80124e <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801268:	b8 00 00 00 00       	mov    $0x0,%eax
  80126d:	eb 0b                	jmp    80127a <ipc_find_env+0x3b>
			return envs[i].env_id;
  80126f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801272:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801277:	8b 40 48             	mov    0x48(%eax),%eax
}
  80127a:	5d                   	pop    %ebp
  80127b:	c3                   	ret    

0080127c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80127c:	f3 0f 1e fb          	endbr32 
  801280:	55                   	push   %ebp
  801281:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	05 00 00 00 30       	add    $0x30000000,%eax
  80128b:	c1 e8 0c             	shr    $0xc,%eax
}
  80128e:	5d                   	pop    %ebp
  80128f:	c3                   	ret    

00801290 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801290:	f3 0f 1e fb          	endbr32 
  801294:	55                   	push   %ebp
  801295:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
  80129a:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80129f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012a4:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012a9:	5d                   	pop    %ebp
  8012aa:	c3                   	ret    

008012ab <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012ab:	f3 0f 1e fb          	endbr32 
  8012af:	55                   	push   %ebp
  8012b0:	89 e5                	mov    %esp,%ebp
  8012b2:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012b7:	89 c2                	mov    %eax,%edx
  8012b9:	c1 ea 16             	shr    $0x16,%edx
  8012bc:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012c3:	f6 c2 01             	test   $0x1,%dl
  8012c6:	74 2d                	je     8012f5 <fd_alloc+0x4a>
  8012c8:	89 c2                	mov    %eax,%edx
  8012ca:	c1 ea 0c             	shr    $0xc,%edx
  8012cd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012d4:	f6 c2 01             	test   $0x1,%dl
  8012d7:	74 1c                	je     8012f5 <fd_alloc+0x4a>
  8012d9:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8012de:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012e3:	75 d2                	jne    8012b7 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8012ee:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8012f3:	eb 0a                	jmp    8012ff <fd_alloc+0x54>
			*fd_store = fd;
  8012f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012f8:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012ff:	5d                   	pop    %ebp
  801300:	c3                   	ret    

00801301 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801301:	f3 0f 1e fb          	endbr32 
  801305:	55                   	push   %ebp
  801306:	89 e5                	mov    %esp,%ebp
  801308:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80130b:	83 f8 1f             	cmp    $0x1f,%eax
  80130e:	77 30                	ja     801340 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801310:	c1 e0 0c             	shl    $0xc,%eax
  801313:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801318:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80131e:	f6 c2 01             	test   $0x1,%dl
  801321:	74 24                	je     801347 <fd_lookup+0x46>
  801323:	89 c2                	mov    %eax,%edx
  801325:	c1 ea 0c             	shr    $0xc,%edx
  801328:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80132f:	f6 c2 01             	test   $0x1,%dl
  801332:	74 1a                	je     80134e <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801334:	8b 55 0c             	mov    0xc(%ebp),%edx
  801337:	89 02                	mov    %eax,(%edx)
	return 0;
  801339:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80133e:	5d                   	pop    %ebp
  80133f:	c3                   	ret    
		return -E_INVAL;
  801340:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801345:	eb f7                	jmp    80133e <fd_lookup+0x3d>
		return -E_INVAL;
  801347:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80134c:	eb f0                	jmp    80133e <fd_lookup+0x3d>
  80134e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801353:	eb e9                	jmp    80133e <fd_lookup+0x3d>

00801355 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801355:	f3 0f 1e fb          	endbr32 
  801359:	55                   	push   %ebp
  80135a:	89 e5                	mov    %esp,%ebp
  80135c:	83 ec 08             	sub    $0x8,%esp
  80135f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801362:	ba 1c 28 80 00       	mov    $0x80281c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801367:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80136c:	39 08                	cmp    %ecx,(%eax)
  80136e:	74 33                	je     8013a3 <dev_lookup+0x4e>
  801370:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801373:	8b 02                	mov    (%edx),%eax
  801375:	85 c0                	test   %eax,%eax
  801377:	75 f3                	jne    80136c <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801379:	a1 08 40 80 00       	mov    0x804008,%eax
  80137e:	8b 40 48             	mov    0x48(%eax),%eax
  801381:	83 ec 04             	sub    $0x4,%esp
  801384:	51                   	push   %ecx
  801385:	50                   	push   %eax
  801386:	68 a0 27 80 00       	push   $0x8027a0
  80138b:	e8 7c ee ff ff       	call   80020c <cprintf>
	*dev = 0;
  801390:	8b 45 0c             	mov    0xc(%ebp),%eax
  801393:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801399:	83 c4 10             	add    $0x10,%esp
  80139c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013a1:	c9                   	leave  
  8013a2:	c3                   	ret    
			*dev = devtab[i];
  8013a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013a6:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ad:	eb f2                	jmp    8013a1 <dev_lookup+0x4c>

008013af <fd_close>:
{
  8013af:	f3 0f 1e fb          	endbr32 
  8013b3:	55                   	push   %ebp
  8013b4:	89 e5                	mov    %esp,%ebp
  8013b6:	57                   	push   %edi
  8013b7:	56                   	push   %esi
  8013b8:	53                   	push   %ebx
  8013b9:	83 ec 24             	sub    $0x24,%esp
  8013bc:	8b 75 08             	mov    0x8(%ebp),%esi
  8013bf:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013c2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013c5:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013c6:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8013cc:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013cf:	50                   	push   %eax
  8013d0:	e8 2c ff ff ff       	call   801301 <fd_lookup>
  8013d5:	89 c3                	mov    %eax,%ebx
  8013d7:	83 c4 10             	add    $0x10,%esp
  8013da:	85 c0                	test   %eax,%eax
  8013dc:	78 05                	js     8013e3 <fd_close+0x34>
	    || fd != fd2)
  8013de:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8013e1:	74 16                	je     8013f9 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8013e3:	89 f8                	mov    %edi,%eax
  8013e5:	84 c0                	test   %al,%al
  8013e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ec:	0f 44 d8             	cmove  %eax,%ebx
}
  8013ef:	89 d8                	mov    %ebx,%eax
  8013f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013f4:	5b                   	pop    %ebx
  8013f5:	5e                   	pop    %esi
  8013f6:	5f                   	pop    %edi
  8013f7:	5d                   	pop    %ebp
  8013f8:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8013f9:	83 ec 08             	sub    $0x8,%esp
  8013fc:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8013ff:	50                   	push   %eax
  801400:	ff 36                	pushl  (%esi)
  801402:	e8 4e ff ff ff       	call   801355 <dev_lookup>
  801407:	89 c3                	mov    %eax,%ebx
  801409:	83 c4 10             	add    $0x10,%esp
  80140c:	85 c0                	test   %eax,%eax
  80140e:	78 1a                	js     80142a <fd_close+0x7b>
		if (dev->dev_close)
  801410:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801413:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801416:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80141b:	85 c0                	test   %eax,%eax
  80141d:	74 0b                	je     80142a <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80141f:	83 ec 0c             	sub    $0xc,%esp
  801422:	56                   	push   %esi
  801423:	ff d0                	call   *%eax
  801425:	89 c3                	mov    %eax,%ebx
  801427:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80142a:	83 ec 08             	sub    $0x8,%esp
  80142d:	56                   	push   %esi
  80142e:	6a 00                	push   $0x0
  801430:	e8 b0 f8 ff ff       	call   800ce5 <sys_page_unmap>
	return r;
  801435:	83 c4 10             	add    $0x10,%esp
  801438:	eb b5                	jmp    8013ef <fd_close+0x40>

0080143a <close>:

int
close(int fdnum)
{
  80143a:	f3 0f 1e fb          	endbr32 
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
  801441:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801444:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801447:	50                   	push   %eax
  801448:	ff 75 08             	pushl  0x8(%ebp)
  80144b:	e8 b1 fe ff ff       	call   801301 <fd_lookup>
  801450:	83 c4 10             	add    $0x10,%esp
  801453:	85 c0                	test   %eax,%eax
  801455:	79 02                	jns    801459 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801457:	c9                   	leave  
  801458:	c3                   	ret    
		return fd_close(fd, 1);
  801459:	83 ec 08             	sub    $0x8,%esp
  80145c:	6a 01                	push   $0x1
  80145e:	ff 75 f4             	pushl  -0xc(%ebp)
  801461:	e8 49 ff ff ff       	call   8013af <fd_close>
  801466:	83 c4 10             	add    $0x10,%esp
  801469:	eb ec                	jmp    801457 <close+0x1d>

0080146b <close_all>:

void
close_all(void)
{
  80146b:	f3 0f 1e fb          	endbr32 
  80146f:	55                   	push   %ebp
  801470:	89 e5                	mov    %esp,%ebp
  801472:	53                   	push   %ebx
  801473:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801476:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80147b:	83 ec 0c             	sub    $0xc,%esp
  80147e:	53                   	push   %ebx
  80147f:	e8 b6 ff ff ff       	call   80143a <close>
	for (i = 0; i < MAXFD; i++)
  801484:	83 c3 01             	add    $0x1,%ebx
  801487:	83 c4 10             	add    $0x10,%esp
  80148a:	83 fb 20             	cmp    $0x20,%ebx
  80148d:	75 ec                	jne    80147b <close_all+0x10>
}
  80148f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801492:	c9                   	leave  
  801493:	c3                   	ret    

00801494 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801494:	f3 0f 1e fb          	endbr32 
  801498:	55                   	push   %ebp
  801499:	89 e5                	mov    %esp,%ebp
  80149b:	57                   	push   %edi
  80149c:	56                   	push   %esi
  80149d:	53                   	push   %ebx
  80149e:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8014a1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014a4:	50                   	push   %eax
  8014a5:	ff 75 08             	pushl  0x8(%ebp)
  8014a8:	e8 54 fe ff ff       	call   801301 <fd_lookup>
  8014ad:	89 c3                	mov    %eax,%ebx
  8014af:	83 c4 10             	add    $0x10,%esp
  8014b2:	85 c0                	test   %eax,%eax
  8014b4:	0f 88 81 00 00 00    	js     80153b <dup+0xa7>
		return r;
	close(newfdnum);
  8014ba:	83 ec 0c             	sub    $0xc,%esp
  8014bd:	ff 75 0c             	pushl  0xc(%ebp)
  8014c0:	e8 75 ff ff ff       	call   80143a <close>

	newfd = INDEX2FD(newfdnum);
  8014c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014c8:	c1 e6 0c             	shl    $0xc,%esi
  8014cb:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8014d1:	83 c4 04             	add    $0x4,%esp
  8014d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014d7:	e8 b4 fd ff ff       	call   801290 <fd2data>
  8014dc:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8014de:	89 34 24             	mov    %esi,(%esp)
  8014e1:	e8 aa fd ff ff       	call   801290 <fd2data>
  8014e6:	83 c4 10             	add    $0x10,%esp
  8014e9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8014eb:	89 d8                	mov    %ebx,%eax
  8014ed:	c1 e8 16             	shr    $0x16,%eax
  8014f0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014f7:	a8 01                	test   $0x1,%al
  8014f9:	74 11                	je     80150c <dup+0x78>
  8014fb:	89 d8                	mov    %ebx,%eax
  8014fd:	c1 e8 0c             	shr    $0xc,%eax
  801500:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801507:	f6 c2 01             	test   $0x1,%dl
  80150a:	75 39                	jne    801545 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80150c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80150f:	89 d0                	mov    %edx,%eax
  801511:	c1 e8 0c             	shr    $0xc,%eax
  801514:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80151b:	83 ec 0c             	sub    $0xc,%esp
  80151e:	25 07 0e 00 00       	and    $0xe07,%eax
  801523:	50                   	push   %eax
  801524:	56                   	push   %esi
  801525:	6a 00                	push   $0x0
  801527:	52                   	push   %edx
  801528:	6a 00                	push   $0x0
  80152a:	e8 70 f7 ff ff       	call   800c9f <sys_page_map>
  80152f:	89 c3                	mov    %eax,%ebx
  801531:	83 c4 20             	add    $0x20,%esp
  801534:	85 c0                	test   %eax,%eax
  801536:	78 31                	js     801569 <dup+0xd5>
		goto err;

	return newfdnum;
  801538:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80153b:	89 d8                	mov    %ebx,%eax
  80153d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801540:	5b                   	pop    %ebx
  801541:	5e                   	pop    %esi
  801542:	5f                   	pop    %edi
  801543:	5d                   	pop    %ebp
  801544:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801545:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80154c:	83 ec 0c             	sub    $0xc,%esp
  80154f:	25 07 0e 00 00       	and    $0xe07,%eax
  801554:	50                   	push   %eax
  801555:	57                   	push   %edi
  801556:	6a 00                	push   $0x0
  801558:	53                   	push   %ebx
  801559:	6a 00                	push   $0x0
  80155b:	e8 3f f7 ff ff       	call   800c9f <sys_page_map>
  801560:	89 c3                	mov    %eax,%ebx
  801562:	83 c4 20             	add    $0x20,%esp
  801565:	85 c0                	test   %eax,%eax
  801567:	79 a3                	jns    80150c <dup+0x78>
	sys_page_unmap(0, newfd);
  801569:	83 ec 08             	sub    $0x8,%esp
  80156c:	56                   	push   %esi
  80156d:	6a 00                	push   $0x0
  80156f:	e8 71 f7 ff ff       	call   800ce5 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801574:	83 c4 08             	add    $0x8,%esp
  801577:	57                   	push   %edi
  801578:	6a 00                	push   $0x0
  80157a:	e8 66 f7 ff ff       	call   800ce5 <sys_page_unmap>
	return r;
  80157f:	83 c4 10             	add    $0x10,%esp
  801582:	eb b7                	jmp    80153b <dup+0xa7>

00801584 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801584:	f3 0f 1e fb          	endbr32 
  801588:	55                   	push   %ebp
  801589:	89 e5                	mov    %esp,%ebp
  80158b:	53                   	push   %ebx
  80158c:	83 ec 1c             	sub    $0x1c,%esp
  80158f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801592:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801595:	50                   	push   %eax
  801596:	53                   	push   %ebx
  801597:	e8 65 fd ff ff       	call   801301 <fd_lookup>
  80159c:	83 c4 10             	add    $0x10,%esp
  80159f:	85 c0                	test   %eax,%eax
  8015a1:	78 3f                	js     8015e2 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015a3:	83 ec 08             	sub    $0x8,%esp
  8015a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015a9:	50                   	push   %eax
  8015aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ad:	ff 30                	pushl  (%eax)
  8015af:	e8 a1 fd ff ff       	call   801355 <dev_lookup>
  8015b4:	83 c4 10             	add    $0x10,%esp
  8015b7:	85 c0                	test   %eax,%eax
  8015b9:	78 27                	js     8015e2 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015be:	8b 42 08             	mov    0x8(%edx),%eax
  8015c1:	83 e0 03             	and    $0x3,%eax
  8015c4:	83 f8 01             	cmp    $0x1,%eax
  8015c7:	74 1e                	je     8015e7 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8015c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015cc:	8b 40 08             	mov    0x8(%eax),%eax
  8015cf:	85 c0                	test   %eax,%eax
  8015d1:	74 35                	je     801608 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8015d3:	83 ec 04             	sub    $0x4,%esp
  8015d6:	ff 75 10             	pushl  0x10(%ebp)
  8015d9:	ff 75 0c             	pushl  0xc(%ebp)
  8015dc:	52                   	push   %edx
  8015dd:	ff d0                	call   *%eax
  8015df:	83 c4 10             	add    $0x10,%esp
}
  8015e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015e5:	c9                   	leave  
  8015e6:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8015e7:	a1 08 40 80 00       	mov    0x804008,%eax
  8015ec:	8b 40 48             	mov    0x48(%eax),%eax
  8015ef:	83 ec 04             	sub    $0x4,%esp
  8015f2:	53                   	push   %ebx
  8015f3:	50                   	push   %eax
  8015f4:	68 e1 27 80 00       	push   $0x8027e1
  8015f9:	e8 0e ec ff ff       	call   80020c <cprintf>
		return -E_INVAL;
  8015fe:	83 c4 10             	add    $0x10,%esp
  801601:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801606:	eb da                	jmp    8015e2 <read+0x5e>
		return -E_NOT_SUPP;
  801608:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80160d:	eb d3                	jmp    8015e2 <read+0x5e>

0080160f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80160f:	f3 0f 1e fb          	endbr32 
  801613:	55                   	push   %ebp
  801614:	89 e5                	mov    %esp,%ebp
  801616:	57                   	push   %edi
  801617:	56                   	push   %esi
  801618:	53                   	push   %ebx
  801619:	83 ec 0c             	sub    $0xc,%esp
  80161c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80161f:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801622:	bb 00 00 00 00       	mov    $0x0,%ebx
  801627:	eb 02                	jmp    80162b <readn+0x1c>
  801629:	01 c3                	add    %eax,%ebx
  80162b:	39 f3                	cmp    %esi,%ebx
  80162d:	73 21                	jae    801650 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80162f:	83 ec 04             	sub    $0x4,%esp
  801632:	89 f0                	mov    %esi,%eax
  801634:	29 d8                	sub    %ebx,%eax
  801636:	50                   	push   %eax
  801637:	89 d8                	mov    %ebx,%eax
  801639:	03 45 0c             	add    0xc(%ebp),%eax
  80163c:	50                   	push   %eax
  80163d:	57                   	push   %edi
  80163e:	e8 41 ff ff ff       	call   801584 <read>
		if (m < 0)
  801643:	83 c4 10             	add    $0x10,%esp
  801646:	85 c0                	test   %eax,%eax
  801648:	78 04                	js     80164e <readn+0x3f>
			return m;
		if (m == 0)
  80164a:	75 dd                	jne    801629 <readn+0x1a>
  80164c:	eb 02                	jmp    801650 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80164e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801650:	89 d8                	mov    %ebx,%eax
  801652:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801655:	5b                   	pop    %ebx
  801656:	5e                   	pop    %esi
  801657:	5f                   	pop    %edi
  801658:	5d                   	pop    %ebp
  801659:	c3                   	ret    

0080165a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80165a:	f3 0f 1e fb          	endbr32 
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
  801661:	53                   	push   %ebx
  801662:	83 ec 1c             	sub    $0x1c,%esp
  801665:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801668:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80166b:	50                   	push   %eax
  80166c:	53                   	push   %ebx
  80166d:	e8 8f fc ff ff       	call   801301 <fd_lookup>
  801672:	83 c4 10             	add    $0x10,%esp
  801675:	85 c0                	test   %eax,%eax
  801677:	78 3a                	js     8016b3 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801679:	83 ec 08             	sub    $0x8,%esp
  80167c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80167f:	50                   	push   %eax
  801680:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801683:	ff 30                	pushl  (%eax)
  801685:	e8 cb fc ff ff       	call   801355 <dev_lookup>
  80168a:	83 c4 10             	add    $0x10,%esp
  80168d:	85 c0                	test   %eax,%eax
  80168f:	78 22                	js     8016b3 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801691:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801694:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801698:	74 1e                	je     8016b8 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80169a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80169d:	8b 52 0c             	mov    0xc(%edx),%edx
  8016a0:	85 d2                	test   %edx,%edx
  8016a2:	74 35                	je     8016d9 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8016a4:	83 ec 04             	sub    $0x4,%esp
  8016a7:	ff 75 10             	pushl  0x10(%ebp)
  8016aa:	ff 75 0c             	pushl  0xc(%ebp)
  8016ad:	50                   	push   %eax
  8016ae:	ff d2                	call   *%edx
  8016b0:	83 c4 10             	add    $0x10,%esp
}
  8016b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016b6:	c9                   	leave  
  8016b7:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016b8:	a1 08 40 80 00       	mov    0x804008,%eax
  8016bd:	8b 40 48             	mov    0x48(%eax),%eax
  8016c0:	83 ec 04             	sub    $0x4,%esp
  8016c3:	53                   	push   %ebx
  8016c4:	50                   	push   %eax
  8016c5:	68 fd 27 80 00       	push   $0x8027fd
  8016ca:	e8 3d eb ff ff       	call   80020c <cprintf>
		return -E_INVAL;
  8016cf:	83 c4 10             	add    $0x10,%esp
  8016d2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016d7:	eb da                	jmp    8016b3 <write+0x59>
		return -E_NOT_SUPP;
  8016d9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016de:	eb d3                	jmp    8016b3 <write+0x59>

008016e0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8016e0:	f3 0f 1e fb          	endbr32 
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
  8016e7:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016ed:	50                   	push   %eax
  8016ee:	ff 75 08             	pushl  0x8(%ebp)
  8016f1:	e8 0b fc ff ff       	call   801301 <fd_lookup>
  8016f6:	83 c4 10             	add    $0x10,%esp
  8016f9:	85 c0                	test   %eax,%eax
  8016fb:	78 0e                	js     80170b <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8016fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801703:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801706:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80170b:	c9                   	leave  
  80170c:	c3                   	ret    

0080170d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80170d:	f3 0f 1e fb          	endbr32 
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
  801714:	53                   	push   %ebx
  801715:	83 ec 1c             	sub    $0x1c,%esp
  801718:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80171b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80171e:	50                   	push   %eax
  80171f:	53                   	push   %ebx
  801720:	e8 dc fb ff ff       	call   801301 <fd_lookup>
  801725:	83 c4 10             	add    $0x10,%esp
  801728:	85 c0                	test   %eax,%eax
  80172a:	78 37                	js     801763 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80172c:	83 ec 08             	sub    $0x8,%esp
  80172f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801732:	50                   	push   %eax
  801733:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801736:	ff 30                	pushl  (%eax)
  801738:	e8 18 fc ff ff       	call   801355 <dev_lookup>
  80173d:	83 c4 10             	add    $0x10,%esp
  801740:	85 c0                	test   %eax,%eax
  801742:	78 1f                	js     801763 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801744:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801747:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80174b:	74 1b                	je     801768 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80174d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801750:	8b 52 18             	mov    0x18(%edx),%edx
  801753:	85 d2                	test   %edx,%edx
  801755:	74 32                	je     801789 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801757:	83 ec 08             	sub    $0x8,%esp
  80175a:	ff 75 0c             	pushl  0xc(%ebp)
  80175d:	50                   	push   %eax
  80175e:	ff d2                	call   *%edx
  801760:	83 c4 10             	add    $0x10,%esp
}
  801763:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801766:	c9                   	leave  
  801767:	c3                   	ret    
			thisenv->env_id, fdnum);
  801768:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80176d:	8b 40 48             	mov    0x48(%eax),%eax
  801770:	83 ec 04             	sub    $0x4,%esp
  801773:	53                   	push   %ebx
  801774:	50                   	push   %eax
  801775:	68 c0 27 80 00       	push   $0x8027c0
  80177a:	e8 8d ea ff ff       	call   80020c <cprintf>
		return -E_INVAL;
  80177f:	83 c4 10             	add    $0x10,%esp
  801782:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801787:	eb da                	jmp    801763 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801789:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80178e:	eb d3                	jmp    801763 <ftruncate+0x56>

00801790 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801790:	f3 0f 1e fb          	endbr32 
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
  801797:	53                   	push   %ebx
  801798:	83 ec 1c             	sub    $0x1c,%esp
  80179b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80179e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017a1:	50                   	push   %eax
  8017a2:	ff 75 08             	pushl  0x8(%ebp)
  8017a5:	e8 57 fb ff ff       	call   801301 <fd_lookup>
  8017aa:	83 c4 10             	add    $0x10,%esp
  8017ad:	85 c0                	test   %eax,%eax
  8017af:	78 4b                	js     8017fc <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017b1:	83 ec 08             	sub    $0x8,%esp
  8017b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017b7:	50                   	push   %eax
  8017b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017bb:	ff 30                	pushl  (%eax)
  8017bd:	e8 93 fb ff ff       	call   801355 <dev_lookup>
  8017c2:	83 c4 10             	add    $0x10,%esp
  8017c5:	85 c0                	test   %eax,%eax
  8017c7:	78 33                	js     8017fc <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8017c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017cc:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8017d0:	74 2f                	je     801801 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017d2:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017d5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017dc:	00 00 00 
	stat->st_isdir = 0;
  8017df:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017e6:	00 00 00 
	stat->st_dev = dev;
  8017e9:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8017ef:	83 ec 08             	sub    $0x8,%esp
  8017f2:	53                   	push   %ebx
  8017f3:	ff 75 f0             	pushl  -0x10(%ebp)
  8017f6:	ff 50 14             	call   *0x14(%eax)
  8017f9:	83 c4 10             	add    $0x10,%esp
}
  8017fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ff:	c9                   	leave  
  801800:	c3                   	ret    
		return -E_NOT_SUPP;
  801801:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801806:	eb f4                	jmp    8017fc <fstat+0x6c>

00801808 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801808:	f3 0f 1e fb          	endbr32 
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
  80180f:	56                   	push   %esi
  801810:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801811:	83 ec 08             	sub    $0x8,%esp
  801814:	6a 00                	push   $0x0
  801816:	ff 75 08             	pushl  0x8(%ebp)
  801819:	e8 fb 01 00 00       	call   801a19 <open>
  80181e:	89 c3                	mov    %eax,%ebx
  801820:	83 c4 10             	add    $0x10,%esp
  801823:	85 c0                	test   %eax,%eax
  801825:	78 1b                	js     801842 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801827:	83 ec 08             	sub    $0x8,%esp
  80182a:	ff 75 0c             	pushl  0xc(%ebp)
  80182d:	50                   	push   %eax
  80182e:	e8 5d ff ff ff       	call   801790 <fstat>
  801833:	89 c6                	mov    %eax,%esi
	close(fd);
  801835:	89 1c 24             	mov    %ebx,(%esp)
  801838:	e8 fd fb ff ff       	call   80143a <close>
	return r;
  80183d:	83 c4 10             	add    $0x10,%esp
  801840:	89 f3                	mov    %esi,%ebx
}
  801842:	89 d8                	mov    %ebx,%eax
  801844:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801847:	5b                   	pop    %ebx
  801848:	5e                   	pop    %esi
  801849:	5d                   	pop    %ebp
  80184a:	c3                   	ret    

0080184b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
  80184e:	56                   	push   %esi
  80184f:	53                   	push   %ebx
  801850:	89 c6                	mov    %eax,%esi
  801852:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801854:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80185b:	74 27                	je     801884 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80185d:	6a 07                	push   $0x7
  80185f:	68 00 50 80 00       	push   $0x805000
  801864:	56                   	push   %esi
  801865:	ff 35 00 40 80 00    	pushl  0x804000
  80186b:	e8 77 f9 ff ff       	call   8011e7 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801870:	83 c4 0c             	add    $0xc,%esp
  801873:	6a 00                	push   $0x0
  801875:	53                   	push   %ebx
  801876:	6a 00                	push   $0x0
  801878:	e8 e5 f8 ff ff       	call   801162 <ipc_recv>
}
  80187d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801880:	5b                   	pop    %ebx
  801881:	5e                   	pop    %esi
  801882:	5d                   	pop    %ebp
  801883:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801884:	83 ec 0c             	sub    $0xc,%esp
  801887:	6a 01                	push   $0x1
  801889:	e8 b1 f9 ff ff       	call   80123f <ipc_find_env>
  80188e:	a3 00 40 80 00       	mov    %eax,0x804000
  801893:	83 c4 10             	add    $0x10,%esp
  801896:	eb c5                	jmp    80185d <fsipc+0x12>

00801898 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801898:	f3 0f 1e fb          	endbr32 
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
  80189f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8018a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8018a8:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8018ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b0:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ba:	b8 02 00 00 00       	mov    $0x2,%eax
  8018bf:	e8 87 ff ff ff       	call   80184b <fsipc>
}
  8018c4:	c9                   	leave  
  8018c5:	c3                   	ret    

008018c6 <devfile_flush>:
{
  8018c6:	f3 0f 1e fb          	endbr32 
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
  8018cd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8018d6:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8018db:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e0:	b8 06 00 00 00       	mov    $0x6,%eax
  8018e5:	e8 61 ff ff ff       	call   80184b <fsipc>
}
  8018ea:	c9                   	leave  
  8018eb:	c3                   	ret    

008018ec <devfile_stat>:
{
  8018ec:	f3 0f 1e fb          	endbr32 
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
  8018f3:	53                   	push   %ebx
  8018f4:	83 ec 04             	sub    $0x4,%esp
  8018f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8018fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fd:	8b 40 0c             	mov    0xc(%eax),%eax
  801900:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801905:	ba 00 00 00 00       	mov    $0x0,%edx
  80190a:	b8 05 00 00 00       	mov    $0x5,%eax
  80190f:	e8 37 ff ff ff       	call   80184b <fsipc>
  801914:	85 c0                	test   %eax,%eax
  801916:	78 2c                	js     801944 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801918:	83 ec 08             	sub    $0x8,%esp
  80191b:	68 00 50 80 00       	push   $0x805000
  801920:	53                   	push   %ebx
  801921:	e8 f0 ee ff ff       	call   800816 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801926:	a1 80 50 80 00       	mov    0x805080,%eax
  80192b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801931:	a1 84 50 80 00       	mov    0x805084,%eax
  801936:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80193c:	83 c4 10             	add    $0x10,%esp
  80193f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801944:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801947:	c9                   	leave  
  801948:	c3                   	ret    

00801949 <devfile_write>:
{
  801949:	f3 0f 1e fb          	endbr32 
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
  801950:	83 ec 0c             	sub    $0xc,%esp
  801953:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801956:	8b 55 08             	mov    0x8(%ebp),%edx
  801959:	8b 52 0c             	mov    0xc(%edx),%edx
  80195c:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801962:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801967:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80196c:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  80196f:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801974:	50                   	push   %eax
  801975:	ff 75 0c             	pushl  0xc(%ebp)
  801978:	68 08 50 80 00       	push   $0x805008
  80197d:	e8 4a f0 ff ff       	call   8009cc <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801982:	ba 00 00 00 00       	mov    $0x0,%edx
  801987:	b8 04 00 00 00       	mov    $0x4,%eax
  80198c:	e8 ba fe ff ff       	call   80184b <fsipc>
}
  801991:	c9                   	leave  
  801992:	c3                   	ret    

00801993 <devfile_read>:
{
  801993:	f3 0f 1e fb          	endbr32 
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
  80199a:	56                   	push   %esi
  80199b:	53                   	push   %ebx
  80199c:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80199f:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8019a5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8019aa:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b5:	b8 03 00 00 00       	mov    $0x3,%eax
  8019ba:	e8 8c fe ff ff       	call   80184b <fsipc>
  8019bf:	89 c3                	mov    %eax,%ebx
  8019c1:	85 c0                	test   %eax,%eax
  8019c3:	78 1f                	js     8019e4 <devfile_read+0x51>
	assert(r <= n);
  8019c5:	39 f0                	cmp    %esi,%eax
  8019c7:	77 24                	ja     8019ed <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8019c9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019ce:	7f 33                	jg     801a03 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019d0:	83 ec 04             	sub    $0x4,%esp
  8019d3:	50                   	push   %eax
  8019d4:	68 00 50 80 00       	push   $0x805000
  8019d9:	ff 75 0c             	pushl  0xc(%ebp)
  8019dc:	e8 eb ef ff ff       	call   8009cc <memmove>
	return r;
  8019e1:	83 c4 10             	add    $0x10,%esp
}
  8019e4:	89 d8                	mov    %ebx,%eax
  8019e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019e9:	5b                   	pop    %ebx
  8019ea:	5e                   	pop    %esi
  8019eb:	5d                   	pop    %ebp
  8019ec:	c3                   	ret    
	assert(r <= n);
  8019ed:	68 2c 28 80 00       	push   $0x80282c
  8019f2:	68 33 28 80 00       	push   $0x802833
  8019f7:	6a 7c                	push   $0x7c
  8019f9:	68 48 28 80 00       	push   $0x802848
  8019fe:	e8 be 05 00 00       	call   801fc1 <_panic>
	assert(r <= PGSIZE);
  801a03:	68 53 28 80 00       	push   $0x802853
  801a08:	68 33 28 80 00       	push   $0x802833
  801a0d:	6a 7d                	push   $0x7d
  801a0f:	68 48 28 80 00       	push   $0x802848
  801a14:	e8 a8 05 00 00       	call   801fc1 <_panic>

00801a19 <open>:
{
  801a19:	f3 0f 1e fb          	endbr32 
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
  801a20:	56                   	push   %esi
  801a21:	53                   	push   %ebx
  801a22:	83 ec 1c             	sub    $0x1c,%esp
  801a25:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a28:	56                   	push   %esi
  801a29:	e8 a5 ed ff ff       	call   8007d3 <strlen>
  801a2e:	83 c4 10             	add    $0x10,%esp
  801a31:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a36:	7f 6c                	jg     801aa4 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801a38:	83 ec 0c             	sub    $0xc,%esp
  801a3b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a3e:	50                   	push   %eax
  801a3f:	e8 67 f8 ff ff       	call   8012ab <fd_alloc>
  801a44:	89 c3                	mov    %eax,%ebx
  801a46:	83 c4 10             	add    $0x10,%esp
  801a49:	85 c0                	test   %eax,%eax
  801a4b:	78 3c                	js     801a89 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801a4d:	83 ec 08             	sub    $0x8,%esp
  801a50:	56                   	push   %esi
  801a51:	68 00 50 80 00       	push   $0x805000
  801a56:	e8 bb ed ff ff       	call   800816 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a5e:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a66:	b8 01 00 00 00       	mov    $0x1,%eax
  801a6b:	e8 db fd ff ff       	call   80184b <fsipc>
  801a70:	89 c3                	mov    %eax,%ebx
  801a72:	83 c4 10             	add    $0x10,%esp
  801a75:	85 c0                	test   %eax,%eax
  801a77:	78 19                	js     801a92 <open+0x79>
	return fd2num(fd);
  801a79:	83 ec 0c             	sub    $0xc,%esp
  801a7c:	ff 75 f4             	pushl  -0xc(%ebp)
  801a7f:	e8 f8 f7 ff ff       	call   80127c <fd2num>
  801a84:	89 c3                	mov    %eax,%ebx
  801a86:	83 c4 10             	add    $0x10,%esp
}
  801a89:	89 d8                	mov    %ebx,%eax
  801a8b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a8e:	5b                   	pop    %ebx
  801a8f:	5e                   	pop    %esi
  801a90:	5d                   	pop    %ebp
  801a91:	c3                   	ret    
		fd_close(fd, 0);
  801a92:	83 ec 08             	sub    $0x8,%esp
  801a95:	6a 00                	push   $0x0
  801a97:	ff 75 f4             	pushl  -0xc(%ebp)
  801a9a:	e8 10 f9 ff ff       	call   8013af <fd_close>
		return r;
  801a9f:	83 c4 10             	add    $0x10,%esp
  801aa2:	eb e5                	jmp    801a89 <open+0x70>
		return -E_BAD_PATH;
  801aa4:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801aa9:	eb de                	jmp    801a89 <open+0x70>

00801aab <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801aab:	f3 0f 1e fb          	endbr32 
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
  801ab2:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ab5:	ba 00 00 00 00       	mov    $0x0,%edx
  801aba:	b8 08 00 00 00       	mov    $0x8,%eax
  801abf:	e8 87 fd ff ff       	call   80184b <fsipc>
}
  801ac4:	c9                   	leave  
  801ac5:	c3                   	ret    

00801ac6 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ac6:	f3 0f 1e fb          	endbr32 
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
  801acd:	56                   	push   %esi
  801ace:	53                   	push   %ebx
  801acf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ad2:	83 ec 0c             	sub    $0xc,%esp
  801ad5:	ff 75 08             	pushl  0x8(%ebp)
  801ad8:	e8 b3 f7 ff ff       	call   801290 <fd2data>
  801add:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801adf:	83 c4 08             	add    $0x8,%esp
  801ae2:	68 5f 28 80 00       	push   $0x80285f
  801ae7:	53                   	push   %ebx
  801ae8:	e8 29 ed ff ff       	call   800816 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801aed:	8b 46 04             	mov    0x4(%esi),%eax
  801af0:	2b 06                	sub    (%esi),%eax
  801af2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801af8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801aff:	00 00 00 
	stat->st_dev = &devpipe;
  801b02:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801b09:	30 80 00 
	return 0;
}
  801b0c:	b8 00 00 00 00       	mov    $0x0,%eax
  801b11:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b14:	5b                   	pop    %ebx
  801b15:	5e                   	pop    %esi
  801b16:	5d                   	pop    %ebp
  801b17:	c3                   	ret    

00801b18 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b18:	f3 0f 1e fb          	endbr32 
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
  801b1f:	53                   	push   %ebx
  801b20:	83 ec 0c             	sub    $0xc,%esp
  801b23:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b26:	53                   	push   %ebx
  801b27:	6a 00                	push   $0x0
  801b29:	e8 b7 f1 ff ff       	call   800ce5 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b2e:	89 1c 24             	mov    %ebx,(%esp)
  801b31:	e8 5a f7 ff ff       	call   801290 <fd2data>
  801b36:	83 c4 08             	add    $0x8,%esp
  801b39:	50                   	push   %eax
  801b3a:	6a 00                	push   $0x0
  801b3c:	e8 a4 f1 ff ff       	call   800ce5 <sys_page_unmap>
}
  801b41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b44:	c9                   	leave  
  801b45:	c3                   	ret    

00801b46 <_pipeisclosed>:
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
  801b49:	57                   	push   %edi
  801b4a:	56                   	push   %esi
  801b4b:	53                   	push   %ebx
  801b4c:	83 ec 1c             	sub    $0x1c,%esp
  801b4f:	89 c7                	mov    %eax,%edi
  801b51:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b53:	a1 08 40 80 00       	mov    0x804008,%eax
  801b58:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b5b:	83 ec 0c             	sub    $0xc,%esp
  801b5e:	57                   	push   %edi
  801b5f:	e8 40 05 00 00       	call   8020a4 <pageref>
  801b64:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b67:	89 34 24             	mov    %esi,(%esp)
  801b6a:	e8 35 05 00 00       	call   8020a4 <pageref>
		nn = thisenv->env_runs;
  801b6f:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801b75:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b78:	83 c4 10             	add    $0x10,%esp
  801b7b:	39 cb                	cmp    %ecx,%ebx
  801b7d:	74 1b                	je     801b9a <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b7f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b82:	75 cf                	jne    801b53 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b84:	8b 42 58             	mov    0x58(%edx),%eax
  801b87:	6a 01                	push   $0x1
  801b89:	50                   	push   %eax
  801b8a:	53                   	push   %ebx
  801b8b:	68 66 28 80 00       	push   $0x802866
  801b90:	e8 77 e6 ff ff       	call   80020c <cprintf>
  801b95:	83 c4 10             	add    $0x10,%esp
  801b98:	eb b9                	jmp    801b53 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801b9a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b9d:	0f 94 c0             	sete   %al
  801ba0:	0f b6 c0             	movzbl %al,%eax
}
  801ba3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ba6:	5b                   	pop    %ebx
  801ba7:	5e                   	pop    %esi
  801ba8:	5f                   	pop    %edi
  801ba9:	5d                   	pop    %ebp
  801baa:	c3                   	ret    

00801bab <devpipe_write>:
{
  801bab:	f3 0f 1e fb          	endbr32 
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
  801bb2:	57                   	push   %edi
  801bb3:	56                   	push   %esi
  801bb4:	53                   	push   %ebx
  801bb5:	83 ec 28             	sub    $0x28,%esp
  801bb8:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801bbb:	56                   	push   %esi
  801bbc:	e8 cf f6 ff ff       	call   801290 <fd2data>
  801bc1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801bc3:	83 c4 10             	add    $0x10,%esp
  801bc6:	bf 00 00 00 00       	mov    $0x0,%edi
  801bcb:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801bce:	74 4f                	je     801c1f <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801bd0:	8b 43 04             	mov    0x4(%ebx),%eax
  801bd3:	8b 0b                	mov    (%ebx),%ecx
  801bd5:	8d 51 20             	lea    0x20(%ecx),%edx
  801bd8:	39 d0                	cmp    %edx,%eax
  801bda:	72 14                	jb     801bf0 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801bdc:	89 da                	mov    %ebx,%edx
  801bde:	89 f0                	mov    %esi,%eax
  801be0:	e8 61 ff ff ff       	call   801b46 <_pipeisclosed>
  801be5:	85 c0                	test   %eax,%eax
  801be7:	75 3b                	jne    801c24 <devpipe_write+0x79>
			sys_yield();
  801be9:	e8 47 f0 ff ff       	call   800c35 <sys_yield>
  801bee:	eb e0                	jmp    801bd0 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801bf0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bf3:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801bf7:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801bfa:	89 c2                	mov    %eax,%edx
  801bfc:	c1 fa 1f             	sar    $0x1f,%edx
  801bff:	89 d1                	mov    %edx,%ecx
  801c01:	c1 e9 1b             	shr    $0x1b,%ecx
  801c04:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c07:	83 e2 1f             	and    $0x1f,%edx
  801c0a:	29 ca                	sub    %ecx,%edx
  801c0c:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c10:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c14:	83 c0 01             	add    $0x1,%eax
  801c17:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c1a:	83 c7 01             	add    $0x1,%edi
  801c1d:	eb ac                	jmp    801bcb <devpipe_write+0x20>
	return i;
  801c1f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c22:	eb 05                	jmp    801c29 <devpipe_write+0x7e>
				return 0;
  801c24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c2c:	5b                   	pop    %ebx
  801c2d:	5e                   	pop    %esi
  801c2e:	5f                   	pop    %edi
  801c2f:	5d                   	pop    %ebp
  801c30:	c3                   	ret    

00801c31 <devpipe_read>:
{
  801c31:	f3 0f 1e fb          	endbr32 
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
  801c38:	57                   	push   %edi
  801c39:	56                   	push   %esi
  801c3a:	53                   	push   %ebx
  801c3b:	83 ec 18             	sub    $0x18,%esp
  801c3e:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c41:	57                   	push   %edi
  801c42:	e8 49 f6 ff ff       	call   801290 <fd2data>
  801c47:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c49:	83 c4 10             	add    $0x10,%esp
  801c4c:	be 00 00 00 00       	mov    $0x0,%esi
  801c51:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c54:	75 14                	jne    801c6a <devpipe_read+0x39>
	return i;
  801c56:	8b 45 10             	mov    0x10(%ebp),%eax
  801c59:	eb 02                	jmp    801c5d <devpipe_read+0x2c>
				return i;
  801c5b:	89 f0                	mov    %esi,%eax
}
  801c5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c60:	5b                   	pop    %ebx
  801c61:	5e                   	pop    %esi
  801c62:	5f                   	pop    %edi
  801c63:	5d                   	pop    %ebp
  801c64:	c3                   	ret    
			sys_yield();
  801c65:	e8 cb ef ff ff       	call   800c35 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801c6a:	8b 03                	mov    (%ebx),%eax
  801c6c:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c6f:	75 18                	jne    801c89 <devpipe_read+0x58>
			if (i > 0)
  801c71:	85 f6                	test   %esi,%esi
  801c73:	75 e6                	jne    801c5b <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801c75:	89 da                	mov    %ebx,%edx
  801c77:	89 f8                	mov    %edi,%eax
  801c79:	e8 c8 fe ff ff       	call   801b46 <_pipeisclosed>
  801c7e:	85 c0                	test   %eax,%eax
  801c80:	74 e3                	je     801c65 <devpipe_read+0x34>
				return 0;
  801c82:	b8 00 00 00 00       	mov    $0x0,%eax
  801c87:	eb d4                	jmp    801c5d <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c89:	99                   	cltd   
  801c8a:	c1 ea 1b             	shr    $0x1b,%edx
  801c8d:	01 d0                	add    %edx,%eax
  801c8f:	83 e0 1f             	and    $0x1f,%eax
  801c92:	29 d0                	sub    %edx,%eax
  801c94:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801c99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c9c:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801c9f:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801ca2:	83 c6 01             	add    $0x1,%esi
  801ca5:	eb aa                	jmp    801c51 <devpipe_read+0x20>

00801ca7 <pipe>:
{
  801ca7:	f3 0f 1e fb          	endbr32 
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
  801cae:	56                   	push   %esi
  801caf:	53                   	push   %ebx
  801cb0:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801cb3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cb6:	50                   	push   %eax
  801cb7:	e8 ef f5 ff ff       	call   8012ab <fd_alloc>
  801cbc:	89 c3                	mov    %eax,%ebx
  801cbe:	83 c4 10             	add    $0x10,%esp
  801cc1:	85 c0                	test   %eax,%eax
  801cc3:	0f 88 23 01 00 00    	js     801dec <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cc9:	83 ec 04             	sub    $0x4,%esp
  801ccc:	68 07 04 00 00       	push   $0x407
  801cd1:	ff 75 f4             	pushl  -0xc(%ebp)
  801cd4:	6a 00                	push   $0x0
  801cd6:	e8 7d ef ff ff       	call   800c58 <sys_page_alloc>
  801cdb:	89 c3                	mov    %eax,%ebx
  801cdd:	83 c4 10             	add    $0x10,%esp
  801ce0:	85 c0                	test   %eax,%eax
  801ce2:	0f 88 04 01 00 00    	js     801dec <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801ce8:	83 ec 0c             	sub    $0xc,%esp
  801ceb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cee:	50                   	push   %eax
  801cef:	e8 b7 f5 ff ff       	call   8012ab <fd_alloc>
  801cf4:	89 c3                	mov    %eax,%ebx
  801cf6:	83 c4 10             	add    $0x10,%esp
  801cf9:	85 c0                	test   %eax,%eax
  801cfb:	0f 88 db 00 00 00    	js     801ddc <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d01:	83 ec 04             	sub    $0x4,%esp
  801d04:	68 07 04 00 00       	push   $0x407
  801d09:	ff 75 f0             	pushl  -0x10(%ebp)
  801d0c:	6a 00                	push   $0x0
  801d0e:	e8 45 ef ff ff       	call   800c58 <sys_page_alloc>
  801d13:	89 c3                	mov    %eax,%ebx
  801d15:	83 c4 10             	add    $0x10,%esp
  801d18:	85 c0                	test   %eax,%eax
  801d1a:	0f 88 bc 00 00 00    	js     801ddc <pipe+0x135>
	va = fd2data(fd0);
  801d20:	83 ec 0c             	sub    $0xc,%esp
  801d23:	ff 75 f4             	pushl  -0xc(%ebp)
  801d26:	e8 65 f5 ff ff       	call   801290 <fd2data>
  801d2b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d2d:	83 c4 0c             	add    $0xc,%esp
  801d30:	68 07 04 00 00       	push   $0x407
  801d35:	50                   	push   %eax
  801d36:	6a 00                	push   $0x0
  801d38:	e8 1b ef ff ff       	call   800c58 <sys_page_alloc>
  801d3d:	89 c3                	mov    %eax,%ebx
  801d3f:	83 c4 10             	add    $0x10,%esp
  801d42:	85 c0                	test   %eax,%eax
  801d44:	0f 88 82 00 00 00    	js     801dcc <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d4a:	83 ec 0c             	sub    $0xc,%esp
  801d4d:	ff 75 f0             	pushl  -0x10(%ebp)
  801d50:	e8 3b f5 ff ff       	call   801290 <fd2data>
  801d55:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d5c:	50                   	push   %eax
  801d5d:	6a 00                	push   $0x0
  801d5f:	56                   	push   %esi
  801d60:	6a 00                	push   $0x0
  801d62:	e8 38 ef ff ff       	call   800c9f <sys_page_map>
  801d67:	89 c3                	mov    %eax,%ebx
  801d69:	83 c4 20             	add    $0x20,%esp
  801d6c:	85 c0                	test   %eax,%eax
  801d6e:	78 4e                	js     801dbe <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801d70:	a1 20 30 80 00       	mov    0x803020,%eax
  801d75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d78:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801d7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d7d:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801d84:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d87:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801d89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d8c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801d93:	83 ec 0c             	sub    $0xc,%esp
  801d96:	ff 75 f4             	pushl  -0xc(%ebp)
  801d99:	e8 de f4 ff ff       	call   80127c <fd2num>
  801d9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801da1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801da3:	83 c4 04             	add    $0x4,%esp
  801da6:	ff 75 f0             	pushl  -0x10(%ebp)
  801da9:	e8 ce f4 ff ff       	call   80127c <fd2num>
  801dae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801db1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801db4:	83 c4 10             	add    $0x10,%esp
  801db7:	bb 00 00 00 00       	mov    $0x0,%ebx
  801dbc:	eb 2e                	jmp    801dec <pipe+0x145>
	sys_page_unmap(0, va);
  801dbe:	83 ec 08             	sub    $0x8,%esp
  801dc1:	56                   	push   %esi
  801dc2:	6a 00                	push   $0x0
  801dc4:	e8 1c ef ff ff       	call   800ce5 <sys_page_unmap>
  801dc9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801dcc:	83 ec 08             	sub    $0x8,%esp
  801dcf:	ff 75 f0             	pushl  -0x10(%ebp)
  801dd2:	6a 00                	push   $0x0
  801dd4:	e8 0c ef ff ff       	call   800ce5 <sys_page_unmap>
  801dd9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801ddc:	83 ec 08             	sub    $0x8,%esp
  801ddf:	ff 75 f4             	pushl  -0xc(%ebp)
  801de2:	6a 00                	push   $0x0
  801de4:	e8 fc ee ff ff       	call   800ce5 <sys_page_unmap>
  801de9:	83 c4 10             	add    $0x10,%esp
}
  801dec:	89 d8                	mov    %ebx,%eax
  801dee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801df1:	5b                   	pop    %ebx
  801df2:	5e                   	pop    %esi
  801df3:	5d                   	pop    %ebp
  801df4:	c3                   	ret    

00801df5 <pipeisclosed>:
{
  801df5:	f3 0f 1e fb          	endbr32 
  801df9:	55                   	push   %ebp
  801dfa:	89 e5                	mov    %esp,%ebp
  801dfc:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801dff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e02:	50                   	push   %eax
  801e03:	ff 75 08             	pushl  0x8(%ebp)
  801e06:	e8 f6 f4 ff ff       	call   801301 <fd_lookup>
  801e0b:	83 c4 10             	add    $0x10,%esp
  801e0e:	85 c0                	test   %eax,%eax
  801e10:	78 18                	js     801e2a <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801e12:	83 ec 0c             	sub    $0xc,%esp
  801e15:	ff 75 f4             	pushl  -0xc(%ebp)
  801e18:	e8 73 f4 ff ff       	call   801290 <fd2data>
  801e1d:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801e1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e22:	e8 1f fd ff ff       	call   801b46 <_pipeisclosed>
  801e27:	83 c4 10             	add    $0x10,%esp
}
  801e2a:	c9                   	leave  
  801e2b:	c3                   	ret    

00801e2c <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801e2c:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801e30:	b8 00 00 00 00       	mov    $0x0,%eax
  801e35:	c3                   	ret    

00801e36 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e36:	f3 0f 1e fb          	endbr32 
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
  801e3d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801e40:	68 7e 28 80 00       	push   $0x80287e
  801e45:	ff 75 0c             	pushl  0xc(%ebp)
  801e48:	e8 c9 e9 ff ff       	call   800816 <strcpy>
	return 0;
}
  801e4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <devcons_write>:
{
  801e54:	f3 0f 1e fb          	endbr32 
  801e58:	55                   	push   %ebp
  801e59:	89 e5                	mov    %esp,%ebp
  801e5b:	57                   	push   %edi
  801e5c:	56                   	push   %esi
  801e5d:	53                   	push   %ebx
  801e5e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801e64:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801e69:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801e6f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e72:	73 31                	jae    801ea5 <devcons_write+0x51>
		m = n - tot;
  801e74:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e77:	29 f3                	sub    %esi,%ebx
  801e79:	83 fb 7f             	cmp    $0x7f,%ebx
  801e7c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801e81:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801e84:	83 ec 04             	sub    $0x4,%esp
  801e87:	53                   	push   %ebx
  801e88:	89 f0                	mov    %esi,%eax
  801e8a:	03 45 0c             	add    0xc(%ebp),%eax
  801e8d:	50                   	push   %eax
  801e8e:	57                   	push   %edi
  801e8f:	e8 38 eb ff ff       	call   8009cc <memmove>
		sys_cputs(buf, m);
  801e94:	83 c4 08             	add    $0x8,%esp
  801e97:	53                   	push   %ebx
  801e98:	57                   	push   %edi
  801e99:	e8 ea ec ff ff       	call   800b88 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801e9e:	01 de                	add    %ebx,%esi
  801ea0:	83 c4 10             	add    $0x10,%esp
  801ea3:	eb ca                	jmp    801e6f <devcons_write+0x1b>
}
  801ea5:	89 f0                	mov    %esi,%eax
  801ea7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801eaa:	5b                   	pop    %ebx
  801eab:	5e                   	pop    %esi
  801eac:	5f                   	pop    %edi
  801ead:	5d                   	pop    %ebp
  801eae:	c3                   	ret    

00801eaf <devcons_read>:
{
  801eaf:	f3 0f 1e fb          	endbr32 
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
  801eb6:	83 ec 08             	sub    $0x8,%esp
  801eb9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801ebe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ec2:	74 21                	je     801ee5 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801ec4:	e8 e1 ec ff ff       	call   800baa <sys_cgetc>
  801ec9:	85 c0                	test   %eax,%eax
  801ecb:	75 07                	jne    801ed4 <devcons_read+0x25>
		sys_yield();
  801ecd:	e8 63 ed ff ff       	call   800c35 <sys_yield>
  801ed2:	eb f0                	jmp    801ec4 <devcons_read+0x15>
	if (c < 0)
  801ed4:	78 0f                	js     801ee5 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801ed6:	83 f8 04             	cmp    $0x4,%eax
  801ed9:	74 0c                	je     801ee7 <devcons_read+0x38>
	*(char*)vbuf = c;
  801edb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ede:	88 02                	mov    %al,(%edx)
	return 1;
  801ee0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ee5:	c9                   	leave  
  801ee6:	c3                   	ret    
		return 0;
  801ee7:	b8 00 00 00 00       	mov    $0x0,%eax
  801eec:	eb f7                	jmp    801ee5 <devcons_read+0x36>

00801eee <cputchar>:
{
  801eee:	f3 0f 1e fb          	endbr32 
  801ef2:	55                   	push   %ebp
  801ef3:	89 e5                	mov    %esp,%ebp
  801ef5:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  801efb:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801efe:	6a 01                	push   $0x1
  801f00:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f03:	50                   	push   %eax
  801f04:	e8 7f ec ff ff       	call   800b88 <sys_cputs>
}
  801f09:	83 c4 10             	add    $0x10,%esp
  801f0c:	c9                   	leave  
  801f0d:	c3                   	ret    

00801f0e <getchar>:
{
  801f0e:	f3 0f 1e fb          	endbr32 
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
  801f15:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801f18:	6a 01                	push   $0x1
  801f1a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f1d:	50                   	push   %eax
  801f1e:	6a 00                	push   $0x0
  801f20:	e8 5f f6 ff ff       	call   801584 <read>
	if (r < 0)
  801f25:	83 c4 10             	add    $0x10,%esp
  801f28:	85 c0                	test   %eax,%eax
  801f2a:	78 06                	js     801f32 <getchar+0x24>
	if (r < 1)
  801f2c:	74 06                	je     801f34 <getchar+0x26>
	return c;
  801f2e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801f32:	c9                   	leave  
  801f33:	c3                   	ret    
		return -E_EOF;
  801f34:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801f39:	eb f7                	jmp    801f32 <getchar+0x24>

00801f3b <iscons>:
{
  801f3b:	f3 0f 1e fb          	endbr32 
  801f3f:	55                   	push   %ebp
  801f40:	89 e5                	mov    %esp,%ebp
  801f42:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f45:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f48:	50                   	push   %eax
  801f49:	ff 75 08             	pushl  0x8(%ebp)
  801f4c:	e8 b0 f3 ff ff       	call   801301 <fd_lookup>
  801f51:	83 c4 10             	add    $0x10,%esp
  801f54:	85 c0                	test   %eax,%eax
  801f56:	78 11                	js     801f69 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f61:	39 10                	cmp    %edx,(%eax)
  801f63:	0f 94 c0             	sete   %al
  801f66:	0f b6 c0             	movzbl %al,%eax
}
  801f69:	c9                   	leave  
  801f6a:	c3                   	ret    

00801f6b <opencons>:
{
  801f6b:	f3 0f 1e fb          	endbr32 
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
  801f72:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801f75:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f78:	50                   	push   %eax
  801f79:	e8 2d f3 ff ff       	call   8012ab <fd_alloc>
  801f7e:	83 c4 10             	add    $0x10,%esp
  801f81:	85 c0                	test   %eax,%eax
  801f83:	78 3a                	js     801fbf <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f85:	83 ec 04             	sub    $0x4,%esp
  801f88:	68 07 04 00 00       	push   $0x407
  801f8d:	ff 75 f4             	pushl  -0xc(%ebp)
  801f90:	6a 00                	push   $0x0
  801f92:	e8 c1 ec ff ff       	call   800c58 <sys_page_alloc>
  801f97:	83 c4 10             	add    $0x10,%esp
  801f9a:	85 c0                	test   %eax,%eax
  801f9c:	78 21                	js     801fbf <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa1:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801fa7:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fac:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801fb3:	83 ec 0c             	sub    $0xc,%esp
  801fb6:	50                   	push   %eax
  801fb7:	e8 c0 f2 ff ff       	call   80127c <fd2num>
  801fbc:	83 c4 10             	add    $0x10,%esp
}
  801fbf:	c9                   	leave  
  801fc0:	c3                   	ret    

00801fc1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801fc1:	f3 0f 1e fb          	endbr32 
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
  801fc8:	56                   	push   %esi
  801fc9:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801fca:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801fcd:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801fd3:	e8 3a ec ff ff       	call   800c12 <sys_getenvid>
  801fd8:	83 ec 0c             	sub    $0xc,%esp
  801fdb:	ff 75 0c             	pushl  0xc(%ebp)
  801fde:	ff 75 08             	pushl  0x8(%ebp)
  801fe1:	56                   	push   %esi
  801fe2:	50                   	push   %eax
  801fe3:	68 8c 28 80 00       	push   $0x80288c
  801fe8:	e8 1f e2 ff ff       	call   80020c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801fed:	83 c4 18             	add    $0x18,%esp
  801ff0:	53                   	push   %ebx
  801ff1:	ff 75 10             	pushl  0x10(%ebp)
  801ff4:	e8 be e1 ff ff       	call   8001b7 <vcprintf>
	cprintf("\n");
  801ff9:	c7 04 24 94 27 80 00 	movl   $0x802794,(%esp)
  802000:	e8 07 e2 ff ff       	call   80020c <cprintf>
  802005:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802008:	cc                   	int3   
  802009:	eb fd                	jmp    802008 <_panic+0x47>

0080200b <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80200b:	f3 0f 1e fb          	endbr32 
  80200f:	55                   	push   %ebp
  802010:	89 e5                	mov    %esp,%ebp
  802012:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802015:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80201c:	74 0a                	je     802028 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80201e:	8b 45 08             	mov    0x8(%ebp),%eax
  802021:	a3 00 60 80 00       	mov    %eax,0x806000
}
  802026:	c9                   	leave  
  802027:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  802028:	83 ec 04             	sub    $0x4,%esp
  80202b:	6a 07                	push   $0x7
  80202d:	68 00 f0 bf ee       	push   $0xeebff000
  802032:	6a 00                	push   $0x0
  802034:	e8 1f ec ff ff       	call   800c58 <sys_page_alloc>
  802039:	83 c4 10             	add    $0x10,%esp
  80203c:	85 c0                	test   %eax,%eax
  80203e:	78 2a                	js     80206a <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  802040:	83 ec 08             	sub    $0x8,%esp
  802043:	68 7e 20 80 00       	push   $0x80207e
  802048:	6a 00                	push   $0x0
  80204a:	e8 68 ed ff ff       	call   800db7 <sys_env_set_pgfault_upcall>
  80204f:	83 c4 10             	add    $0x10,%esp
  802052:	85 c0                	test   %eax,%eax
  802054:	79 c8                	jns    80201e <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  802056:	83 ec 04             	sub    $0x4,%esp
  802059:	68 dc 28 80 00       	push   $0x8028dc
  80205e:	6a 25                	push   $0x25
  802060:	68 14 29 80 00       	push   $0x802914
  802065:	e8 57 ff ff ff       	call   801fc1 <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  80206a:	83 ec 04             	sub    $0x4,%esp
  80206d:	68 b0 28 80 00       	push   $0x8028b0
  802072:	6a 22                	push   $0x22
  802074:	68 14 29 80 00       	push   $0x802914
  802079:	e8 43 ff ff ff       	call   801fc1 <_panic>

0080207e <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80207e:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80207f:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  802084:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802086:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  802089:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  80208d:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  802091:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802094:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  802096:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  80209a:	83 c4 08             	add    $0x8,%esp
	popal
  80209d:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  80209e:	83 c4 04             	add    $0x4,%esp
	popfl
  8020a1:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  8020a2:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  8020a3:	c3                   	ret    

008020a4 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8020a4:	f3 0f 1e fb          	endbr32 
  8020a8:	55                   	push   %ebp
  8020a9:	89 e5                	mov    %esp,%ebp
  8020ab:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8020ae:	89 c2                	mov    %eax,%edx
  8020b0:	c1 ea 16             	shr    $0x16,%edx
  8020b3:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8020ba:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8020bf:	f6 c1 01             	test   $0x1,%cl
  8020c2:	74 1c                	je     8020e0 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8020c4:	c1 e8 0c             	shr    $0xc,%eax
  8020c7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8020ce:	a8 01                	test   $0x1,%al
  8020d0:	74 0e                	je     8020e0 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020d2:	c1 e8 0c             	shr    $0xc,%eax
  8020d5:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8020dc:	ef 
  8020dd:	0f b7 d2             	movzwl %dx,%edx
}
  8020e0:	89 d0                	mov    %edx,%eax
  8020e2:	5d                   	pop    %ebp
  8020e3:	c3                   	ret    
  8020e4:	66 90                	xchg   %ax,%ax
  8020e6:	66 90                	xchg   %ax,%ax
  8020e8:	66 90                	xchg   %ax,%ax
  8020ea:	66 90                	xchg   %ax,%ax
  8020ec:	66 90                	xchg   %ax,%ax
  8020ee:	66 90                	xchg   %ax,%ax

008020f0 <__udivdi3>:
  8020f0:	f3 0f 1e fb          	endbr32 
  8020f4:	55                   	push   %ebp
  8020f5:	57                   	push   %edi
  8020f6:	56                   	push   %esi
  8020f7:	53                   	push   %ebx
  8020f8:	83 ec 1c             	sub    $0x1c,%esp
  8020fb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8020ff:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802103:	8b 74 24 34          	mov    0x34(%esp),%esi
  802107:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80210b:	85 d2                	test   %edx,%edx
  80210d:	75 19                	jne    802128 <__udivdi3+0x38>
  80210f:	39 f3                	cmp    %esi,%ebx
  802111:	76 4d                	jbe    802160 <__udivdi3+0x70>
  802113:	31 ff                	xor    %edi,%edi
  802115:	89 e8                	mov    %ebp,%eax
  802117:	89 f2                	mov    %esi,%edx
  802119:	f7 f3                	div    %ebx
  80211b:	89 fa                	mov    %edi,%edx
  80211d:	83 c4 1c             	add    $0x1c,%esp
  802120:	5b                   	pop    %ebx
  802121:	5e                   	pop    %esi
  802122:	5f                   	pop    %edi
  802123:	5d                   	pop    %ebp
  802124:	c3                   	ret    
  802125:	8d 76 00             	lea    0x0(%esi),%esi
  802128:	39 f2                	cmp    %esi,%edx
  80212a:	76 14                	jbe    802140 <__udivdi3+0x50>
  80212c:	31 ff                	xor    %edi,%edi
  80212e:	31 c0                	xor    %eax,%eax
  802130:	89 fa                	mov    %edi,%edx
  802132:	83 c4 1c             	add    $0x1c,%esp
  802135:	5b                   	pop    %ebx
  802136:	5e                   	pop    %esi
  802137:	5f                   	pop    %edi
  802138:	5d                   	pop    %ebp
  802139:	c3                   	ret    
  80213a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802140:	0f bd fa             	bsr    %edx,%edi
  802143:	83 f7 1f             	xor    $0x1f,%edi
  802146:	75 48                	jne    802190 <__udivdi3+0xa0>
  802148:	39 f2                	cmp    %esi,%edx
  80214a:	72 06                	jb     802152 <__udivdi3+0x62>
  80214c:	31 c0                	xor    %eax,%eax
  80214e:	39 eb                	cmp    %ebp,%ebx
  802150:	77 de                	ja     802130 <__udivdi3+0x40>
  802152:	b8 01 00 00 00       	mov    $0x1,%eax
  802157:	eb d7                	jmp    802130 <__udivdi3+0x40>
  802159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802160:	89 d9                	mov    %ebx,%ecx
  802162:	85 db                	test   %ebx,%ebx
  802164:	75 0b                	jne    802171 <__udivdi3+0x81>
  802166:	b8 01 00 00 00       	mov    $0x1,%eax
  80216b:	31 d2                	xor    %edx,%edx
  80216d:	f7 f3                	div    %ebx
  80216f:	89 c1                	mov    %eax,%ecx
  802171:	31 d2                	xor    %edx,%edx
  802173:	89 f0                	mov    %esi,%eax
  802175:	f7 f1                	div    %ecx
  802177:	89 c6                	mov    %eax,%esi
  802179:	89 e8                	mov    %ebp,%eax
  80217b:	89 f7                	mov    %esi,%edi
  80217d:	f7 f1                	div    %ecx
  80217f:	89 fa                	mov    %edi,%edx
  802181:	83 c4 1c             	add    $0x1c,%esp
  802184:	5b                   	pop    %ebx
  802185:	5e                   	pop    %esi
  802186:	5f                   	pop    %edi
  802187:	5d                   	pop    %ebp
  802188:	c3                   	ret    
  802189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802190:	89 f9                	mov    %edi,%ecx
  802192:	b8 20 00 00 00       	mov    $0x20,%eax
  802197:	29 f8                	sub    %edi,%eax
  802199:	d3 e2                	shl    %cl,%edx
  80219b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80219f:	89 c1                	mov    %eax,%ecx
  8021a1:	89 da                	mov    %ebx,%edx
  8021a3:	d3 ea                	shr    %cl,%edx
  8021a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8021a9:	09 d1                	or     %edx,%ecx
  8021ab:	89 f2                	mov    %esi,%edx
  8021ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021b1:	89 f9                	mov    %edi,%ecx
  8021b3:	d3 e3                	shl    %cl,%ebx
  8021b5:	89 c1                	mov    %eax,%ecx
  8021b7:	d3 ea                	shr    %cl,%edx
  8021b9:	89 f9                	mov    %edi,%ecx
  8021bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8021bf:	89 eb                	mov    %ebp,%ebx
  8021c1:	d3 e6                	shl    %cl,%esi
  8021c3:	89 c1                	mov    %eax,%ecx
  8021c5:	d3 eb                	shr    %cl,%ebx
  8021c7:	09 de                	or     %ebx,%esi
  8021c9:	89 f0                	mov    %esi,%eax
  8021cb:	f7 74 24 08          	divl   0x8(%esp)
  8021cf:	89 d6                	mov    %edx,%esi
  8021d1:	89 c3                	mov    %eax,%ebx
  8021d3:	f7 64 24 0c          	mull   0xc(%esp)
  8021d7:	39 d6                	cmp    %edx,%esi
  8021d9:	72 15                	jb     8021f0 <__udivdi3+0x100>
  8021db:	89 f9                	mov    %edi,%ecx
  8021dd:	d3 e5                	shl    %cl,%ebp
  8021df:	39 c5                	cmp    %eax,%ebp
  8021e1:	73 04                	jae    8021e7 <__udivdi3+0xf7>
  8021e3:	39 d6                	cmp    %edx,%esi
  8021e5:	74 09                	je     8021f0 <__udivdi3+0x100>
  8021e7:	89 d8                	mov    %ebx,%eax
  8021e9:	31 ff                	xor    %edi,%edi
  8021eb:	e9 40 ff ff ff       	jmp    802130 <__udivdi3+0x40>
  8021f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021f3:	31 ff                	xor    %edi,%edi
  8021f5:	e9 36 ff ff ff       	jmp    802130 <__udivdi3+0x40>
  8021fa:	66 90                	xchg   %ax,%ax
  8021fc:	66 90                	xchg   %ax,%ax
  8021fe:	66 90                	xchg   %ax,%ax

00802200 <__umoddi3>:
  802200:	f3 0f 1e fb          	endbr32 
  802204:	55                   	push   %ebp
  802205:	57                   	push   %edi
  802206:	56                   	push   %esi
  802207:	53                   	push   %ebx
  802208:	83 ec 1c             	sub    $0x1c,%esp
  80220b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80220f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802213:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802217:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80221b:	85 c0                	test   %eax,%eax
  80221d:	75 19                	jne    802238 <__umoddi3+0x38>
  80221f:	39 df                	cmp    %ebx,%edi
  802221:	76 5d                	jbe    802280 <__umoddi3+0x80>
  802223:	89 f0                	mov    %esi,%eax
  802225:	89 da                	mov    %ebx,%edx
  802227:	f7 f7                	div    %edi
  802229:	89 d0                	mov    %edx,%eax
  80222b:	31 d2                	xor    %edx,%edx
  80222d:	83 c4 1c             	add    $0x1c,%esp
  802230:	5b                   	pop    %ebx
  802231:	5e                   	pop    %esi
  802232:	5f                   	pop    %edi
  802233:	5d                   	pop    %ebp
  802234:	c3                   	ret    
  802235:	8d 76 00             	lea    0x0(%esi),%esi
  802238:	89 f2                	mov    %esi,%edx
  80223a:	39 d8                	cmp    %ebx,%eax
  80223c:	76 12                	jbe    802250 <__umoddi3+0x50>
  80223e:	89 f0                	mov    %esi,%eax
  802240:	89 da                	mov    %ebx,%edx
  802242:	83 c4 1c             	add    $0x1c,%esp
  802245:	5b                   	pop    %ebx
  802246:	5e                   	pop    %esi
  802247:	5f                   	pop    %edi
  802248:	5d                   	pop    %ebp
  802249:	c3                   	ret    
  80224a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802250:	0f bd e8             	bsr    %eax,%ebp
  802253:	83 f5 1f             	xor    $0x1f,%ebp
  802256:	75 50                	jne    8022a8 <__umoddi3+0xa8>
  802258:	39 d8                	cmp    %ebx,%eax
  80225a:	0f 82 e0 00 00 00    	jb     802340 <__umoddi3+0x140>
  802260:	89 d9                	mov    %ebx,%ecx
  802262:	39 f7                	cmp    %esi,%edi
  802264:	0f 86 d6 00 00 00    	jbe    802340 <__umoddi3+0x140>
  80226a:	89 d0                	mov    %edx,%eax
  80226c:	89 ca                	mov    %ecx,%edx
  80226e:	83 c4 1c             	add    $0x1c,%esp
  802271:	5b                   	pop    %ebx
  802272:	5e                   	pop    %esi
  802273:	5f                   	pop    %edi
  802274:	5d                   	pop    %ebp
  802275:	c3                   	ret    
  802276:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80227d:	8d 76 00             	lea    0x0(%esi),%esi
  802280:	89 fd                	mov    %edi,%ebp
  802282:	85 ff                	test   %edi,%edi
  802284:	75 0b                	jne    802291 <__umoddi3+0x91>
  802286:	b8 01 00 00 00       	mov    $0x1,%eax
  80228b:	31 d2                	xor    %edx,%edx
  80228d:	f7 f7                	div    %edi
  80228f:	89 c5                	mov    %eax,%ebp
  802291:	89 d8                	mov    %ebx,%eax
  802293:	31 d2                	xor    %edx,%edx
  802295:	f7 f5                	div    %ebp
  802297:	89 f0                	mov    %esi,%eax
  802299:	f7 f5                	div    %ebp
  80229b:	89 d0                	mov    %edx,%eax
  80229d:	31 d2                	xor    %edx,%edx
  80229f:	eb 8c                	jmp    80222d <__umoddi3+0x2d>
  8022a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022a8:	89 e9                	mov    %ebp,%ecx
  8022aa:	ba 20 00 00 00       	mov    $0x20,%edx
  8022af:	29 ea                	sub    %ebp,%edx
  8022b1:	d3 e0                	shl    %cl,%eax
  8022b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022b7:	89 d1                	mov    %edx,%ecx
  8022b9:	89 f8                	mov    %edi,%eax
  8022bb:	d3 e8                	shr    %cl,%eax
  8022bd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8022c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022c5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8022c9:	09 c1                	or     %eax,%ecx
  8022cb:	89 d8                	mov    %ebx,%eax
  8022cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022d1:	89 e9                	mov    %ebp,%ecx
  8022d3:	d3 e7                	shl    %cl,%edi
  8022d5:	89 d1                	mov    %edx,%ecx
  8022d7:	d3 e8                	shr    %cl,%eax
  8022d9:	89 e9                	mov    %ebp,%ecx
  8022db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8022df:	d3 e3                	shl    %cl,%ebx
  8022e1:	89 c7                	mov    %eax,%edi
  8022e3:	89 d1                	mov    %edx,%ecx
  8022e5:	89 f0                	mov    %esi,%eax
  8022e7:	d3 e8                	shr    %cl,%eax
  8022e9:	89 e9                	mov    %ebp,%ecx
  8022eb:	89 fa                	mov    %edi,%edx
  8022ed:	d3 e6                	shl    %cl,%esi
  8022ef:	09 d8                	or     %ebx,%eax
  8022f1:	f7 74 24 08          	divl   0x8(%esp)
  8022f5:	89 d1                	mov    %edx,%ecx
  8022f7:	89 f3                	mov    %esi,%ebx
  8022f9:	f7 64 24 0c          	mull   0xc(%esp)
  8022fd:	89 c6                	mov    %eax,%esi
  8022ff:	89 d7                	mov    %edx,%edi
  802301:	39 d1                	cmp    %edx,%ecx
  802303:	72 06                	jb     80230b <__umoddi3+0x10b>
  802305:	75 10                	jne    802317 <__umoddi3+0x117>
  802307:	39 c3                	cmp    %eax,%ebx
  802309:	73 0c                	jae    802317 <__umoddi3+0x117>
  80230b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80230f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802313:	89 d7                	mov    %edx,%edi
  802315:	89 c6                	mov    %eax,%esi
  802317:	89 ca                	mov    %ecx,%edx
  802319:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80231e:	29 f3                	sub    %esi,%ebx
  802320:	19 fa                	sbb    %edi,%edx
  802322:	89 d0                	mov    %edx,%eax
  802324:	d3 e0                	shl    %cl,%eax
  802326:	89 e9                	mov    %ebp,%ecx
  802328:	d3 eb                	shr    %cl,%ebx
  80232a:	d3 ea                	shr    %cl,%edx
  80232c:	09 d8                	or     %ebx,%eax
  80232e:	83 c4 1c             	add    $0x1c,%esp
  802331:	5b                   	pop    %ebx
  802332:	5e                   	pop    %esi
  802333:	5f                   	pop    %edi
  802334:	5d                   	pop    %ebp
  802335:	c3                   	ret    
  802336:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80233d:	8d 76 00             	lea    0x0(%esi),%esi
  802340:	29 fe                	sub    %edi,%esi
  802342:	19 c3                	sbb    %eax,%ebx
  802344:	89 f2                	mov    %esi,%edx
  802346:	89 d9                	mov    %ebx,%ecx
  802348:	e9 1d ff ff ff       	jmp    80226a <__umoddi3+0x6a>
