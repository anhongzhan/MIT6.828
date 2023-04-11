
obj/user/pingpong:     file format elf32-i386


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
  80002c:	e8 93 00 00 00       	call   8000c4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	57                   	push   %edi
  80003b:	56                   	push   %esi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 1c             	sub    $0x1c,%esp
	envid_t who;

	if ((who = fork()) != 0) {
  800040:	e8 73 0e 00 00       	call   800eb8 <fork>
  800045:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800048:	85 c0                	test   %eax,%eax
  80004a:	75 4f                	jne    80009b <umain+0x68>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  80004c:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80004f:	83 ec 04             	sub    $0x4,%esp
  800052:	6a 00                	push   $0x0
  800054:	6a 00                	push   $0x0
  800056:	56                   	push   %esi
  800057:	e8 47 10 00 00       	call   8010a3 <ipc_recv>
  80005c:	89 c3                	mov    %eax,%ebx
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  80005e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800061:	e8 61 0b 00 00       	call   800bc7 <sys_getenvid>
  800066:	57                   	push   %edi
  800067:	53                   	push   %ebx
  800068:	50                   	push   %eax
  800069:	68 16 15 80 00       	push   $0x801516
  80006e:	e8 4e 01 00 00       	call   8001c1 <cprintf>
		if (i == 10)
  800073:	83 c4 20             	add    $0x20,%esp
  800076:	83 fb 0a             	cmp    $0xa,%ebx
  800079:	74 18                	je     800093 <umain+0x60>
			return;
		i++;
  80007b:	83 c3 01             	add    $0x1,%ebx
		ipc_send(who, i, 0, 0);
  80007e:	6a 00                	push   $0x0
  800080:	6a 00                	push   $0x0
  800082:	53                   	push   %ebx
  800083:	ff 75 e4             	pushl  -0x1c(%ebp)
  800086:	e8 9d 10 00 00       	call   801128 <ipc_send>
		if (i == 10)
  80008b:	83 c4 10             	add    $0x10,%esp
  80008e:	83 fb 0a             	cmp    $0xa,%ebx
  800091:	75 bc                	jne    80004f <umain+0x1c>
			return;
	}

}
  800093:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800096:	5b                   	pop    %ebx
  800097:	5e                   	pop    %esi
  800098:	5f                   	pop    %edi
  800099:	5d                   	pop    %ebp
  80009a:	c3                   	ret    
  80009b:	89 c3                	mov    %eax,%ebx
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  80009d:	e8 25 0b 00 00       	call   800bc7 <sys_getenvid>
  8000a2:	83 ec 04             	sub    $0x4,%esp
  8000a5:	53                   	push   %ebx
  8000a6:	50                   	push   %eax
  8000a7:	68 00 15 80 00       	push   $0x801500
  8000ac:	e8 10 01 00 00       	call   8001c1 <cprintf>
		ipc_send(who, 0, 0, 0);
  8000b1:	6a 00                	push   $0x0
  8000b3:	6a 00                	push   $0x0
  8000b5:	6a 00                	push   $0x0
  8000b7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000ba:	e8 69 10 00 00       	call   801128 <ipc_send>
  8000bf:	83 c4 20             	add    $0x20,%esp
  8000c2:	eb 88                	jmp    80004c <umain+0x19>

008000c4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000c4:	f3 0f 1e fb          	endbr32 
  8000c8:	55                   	push   %ebp
  8000c9:	89 e5                	mov    %esp,%ebp
  8000cb:	56                   	push   %esi
  8000cc:	53                   	push   %ebx
  8000cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000d0:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000d3:	e8 ef 0a 00 00       	call   800bc7 <sys_getenvid>
  8000d8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000dd:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000e0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000e5:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ea:	85 db                	test   %ebx,%ebx
  8000ec:	7e 07                	jle    8000f5 <libmain+0x31>
		binaryname = argv[0];
  8000ee:	8b 06                	mov    (%esi),%eax
  8000f0:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000f5:	83 ec 08             	sub    $0x8,%esp
  8000f8:	56                   	push   %esi
  8000f9:	53                   	push   %ebx
  8000fa:	e8 34 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000ff:	e8 0a 00 00 00       	call   80010e <exit>
}
  800104:	83 c4 10             	add    $0x10,%esp
  800107:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80010a:	5b                   	pop    %ebx
  80010b:	5e                   	pop    %esi
  80010c:	5d                   	pop    %ebp
  80010d:	c3                   	ret    

0080010e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80010e:	f3 0f 1e fb          	endbr32 
  800112:	55                   	push   %ebp
  800113:	89 e5                	mov    %esp,%ebp
  800115:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  800118:	6a 00                	push   $0x0
  80011a:	e8 63 0a 00 00       	call   800b82 <sys_env_destroy>
}
  80011f:	83 c4 10             	add    $0x10,%esp
  800122:	c9                   	leave  
  800123:	c3                   	ret    

00800124 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800124:	f3 0f 1e fb          	endbr32 
  800128:	55                   	push   %ebp
  800129:	89 e5                	mov    %esp,%ebp
  80012b:	53                   	push   %ebx
  80012c:	83 ec 04             	sub    $0x4,%esp
  80012f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800132:	8b 13                	mov    (%ebx),%edx
  800134:	8d 42 01             	lea    0x1(%edx),%eax
  800137:	89 03                	mov    %eax,(%ebx)
  800139:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80013c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800140:	3d ff 00 00 00       	cmp    $0xff,%eax
  800145:	74 09                	je     800150 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800147:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80014b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80014e:	c9                   	leave  
  80014f:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800150:	83 ec 08             	sub    $0x8,%esp
  800153:	68 ff 00 00 00       	push   $0xff
  800158:	8d 43 08             	lea    0x8(%ebx),%eax
  80015b:	50                   	push   %eax
  80015c:	e8 dc 09 00 00       	call   800b3d <sys_cputs>
		b->idx = 0;
  800161:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800167:	83 c4 10             	add    $0x10,%esp
  80016a:	eb db                	jmp    800147 <putch+0x23>

0080016c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80016c:	f3 0f 1e fb          	endbr32 
  800170:	55                   	push   %ebp
  800171:	89 e5                	mov    %esp,%ebp
  800173:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800179:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800180:	00 00 00 
	b.cnt = 0;
  800183:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80018a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80018d:	ff 75 0c             	pushl  0xc(%ebp)
  800190:	ff 75 08             	pushl  0x8(%ebp)
  800193:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800199:	50                   	push   %eax
  80019a:	68 24 01 80 00       	push   $0x800124
  80019f:	e8 20 01 00 00       	call   8002c4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001a4:	83 c4 08             	add    $0x8,%esp
  8001a7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001ad:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001b3:	50                   	push   %eax
  8001b4:	e8 84 09 00 00       	call   800b3d <sys_cputs>

	return b.cnt;
}
  8001b9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001bf:	c9                   	leave  
  8001c0:	c3                   	ret    

008001c1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001c1:	f3 0f 1e fb          	endbr32 
  8001c5:	55                   	push   %ebp
  8001c6:	89 e5                	mov    %esp,%ebp
  8001c8:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001cb:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001ce:	50                   	push   %eax
  8001cf:	ff 75 08             	pushl  0x8(%ebp)
  8001d2:	e8 95 ff ff ff       	call   80016c <vcprintf>
	va_end(ap);

	return cnt;
}
  8001d7:	c9                   	leave  
  8001d8:	c3                   	ret    

008001d9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001d9:	55                   	push   %ebp
  8001da:	89 e5                	mov    %esp,%ebp
  8001dc:	57                   	push   %edi
  8001dd:	56                   	push   %esi
  8001de:	53                   	push   %ebx
  8001df:	83 ec 1c             	sub    $0x1c,%esp
  8001e2:	89 c7                	mov    %eax,%edi
  8001e4:	89 d6                	mov    %edx,%esi
  8001e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8001e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001ec:	89 d1                	mov    %edx,%ecx
  8001ee:	89 c2                	mov    %eax,%edx
  8001f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001f3:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8001f9:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001ff:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800206:	39 c2                	cmp    %eax,%edx
  800208:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80020b:	72 3e                	jb     80024b <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80020d:	83 ec 0c             	sub    $0xc,%esp
  800210:	ff 75 18             	pushl  0x18(%ebp)
  800213:	83 eb 01             	sub    $0x1,%ebx
  800216:	53                   	push   %ebx
  800217:	50                   	push   %eax
  800218:	83 ec 08             	sub    $0x8,%esp
  80021b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80021e:	ff 75 e0             	pushl  -0x20(%ebp)
  800221:	ff 75 dc             	pushl  -0x24(%ebp)
  800224:	ff 75 d8             	pushl  -0x28(%ebp)
  800227:	e8 74 10 00 00       	call   8012a0 <__udivdi3>
  80022c:	83 c4 18             	add    $0x18,%esp
  80022f:	52                   	push   %edx
  800230:	50                   	push   %eax
  800231:	89 f2                	mov    %esi,%edx
  800233:	89 f8                	mov    %edi,%eax
  800235:	e8 9f ff ff ff       	call   8001d9 <printnum>
  80023a:	83 c4 20             	add    $0x20,%esp
  80023d:	eb 13                	jmp    800252 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80023f:	83 ec 08             	sub    $0x8,%esp
  800242:	56                   	push   %esi
  800243:	ff 75 18             	pushl  0x18(%ebp)
  800246:	ff d7                	call   *%edi
  800248:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80024b:	83 eb 01             	sub    $0x1,%ebx
  80024e:	85 db                	test   %ebx,%ebx
  800250:	7f ed                	jg     80023f <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800252:	83 ec 08             	sub    $0x8,%esp
  800255:	56                   	push   %esi
  800256:	83 ec 04             	sub    $0x4,%esp
  800259:	ff 75 e4             	pushl  -0x1c(%ebp)
  80025c:	ff 75 e0             	pushl  -0x20(%ebp)
  80025f:	ff 75 dc             	pushl  -0x24(%ebp)
  800262:	ff 75 d8             	pushl  -0x28(%ebp)
  800265:	e8 46 11 00 00       	call   8013b0 <__umoddi3>
  80026a:	83 c4 14             	add    $0x14,%esp
  80026d:	0f be 80 33 15 80 00 	movsbl 0x801533(%eax),%eax
  800274:	50                   	push   %eax
  800275:	ff d7                	call   *%edi
}
  800277:	83 c4 10             	add    $0x10,%esp
  80027a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80027d:	5b                   	pop    %ebx
  80027e:	5e                   	pop    %esi
  80027f:	5f                   	pop    %edi
  800280:	5d                   	pop    %ebp
  800281:	c3                   	ret    

00800282 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800282:	f3 0f 1e fb          	endbr32 
  800286:	55                   	push   %ebp
  800287:	89 e5                	mov    %esp,%ebp
  800289:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80028c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800290:	8b 10                	mov    (%eax),%edx
  800292:	3b 50 04             	cmp    0x4(%eax),%edx
  800295:	73 0a                	jae    8002a1 <sprintputch+0x1f>
		*b->buf++ = ch;
  800297:	8d 4a 01             	lea    0x1(%edx),%ecx
  80029a:	89 08                	mov    %ecx,(%eax)
  80029c:	8b 45 08             	mov    0x8(%ebp),%eax
  80029f:	88 02                	mov    %al,(%edx)
}
  8002a1:	5d                   	pop    %ebp
  8002a2:	c3                   	ret    

008002a3 <printfmt>:
{
  8002a3:	f3 0f 1e fb          	endbr32 
  8002a7:	55                   	push   %ebp
  8002a8:	89 e5                	mov    %esp,%ebp
  8002aa:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002ad:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002b0:	50                   	push   %eax
  8002b1:	ff 75 10             	pushl  0x10(%ebp)
  8002b4:	ff 75 0c             	pushl  0xc(%ebp)
  8002b7:	ff 75 08             	pushl  0x8(%ebp)
  8002ba:	e8 05 00 00 00       	call   8002c4 <vprintfmt>
}
  8002bf:	83 c4 10             	add    $0x10,%esp
  8002c2:	c9                   	leave  
  8002c3:	c3                   	ret    

008002c4 <vprintfmt>:
{
  8002c4:	f3 0f 1e fb          	endbr32 
  8002c8:	55                   	push   %ebp
  8002c9:	89 e5                	mov    %esp,%ebp
  8002cb:	57                   	push   %edi
  8002cc:	56                   	push   %esi
  8002cd:	53                   	push   %ebx
  8002ce:	83 ec 3c             	sub    $0x3c,%esp
  8002d1:	8b 75 08             	mov    0x8(%ebp),%esi
  8002d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002d7:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002da:	e9 8e 03 00 00       	jmp    80066d <vprintfmt+0x3a9>
		padc = ' ';
  8002df:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002e3:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002ea:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002f1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002f8:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002fd:	8d 47 01             	lea    0x1(%edi),%eax
  800300:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800303:	0f b6 17             	movzbl (%edi),%edx
  800306:	8d 42 dd             	lea    -0x23(%edx),%eax
  800309:	3c 55                	cmp    $0x55,%al
  80030b:	0f 87 df 03 00 00    	ja     8006f0 <vprintfmt+0x42c>
  800311:	0f b6 c0             	movzbl %al,%eax
  800314:	3e ff 24 85 00 16 80 	notrack jmp *0x801600(,%eax,4)
  80031b:	00 
  80031c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80031f:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800323:	eb d8                	jmp    8002fd <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800325:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800328:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80032c:	eb cf                	jmp    8002fd <vprintfmt+0x39>
  80032e:	0f b6 d2             	movzbl %dl,%edx
  800331:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800334:	b8 00 00 00 00       	mov    $0x0,%eax
  800339:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80033c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80033f:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800343:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800346:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800349:	83 f9 09             	cmp    $0x9,%ecx
  80034c:	77 55                	ja     8003a3 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  80034e:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800351:	eb e9                	jmp    80033c <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800353:	8b 45 14             	mov    0x14(%ebp),%eax
  800356:	8b 00                	mov    (%eax),%eax
  800358:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80035b:	8b 45 14             	mov    0x14(%ebp),%eax
  80035e:	8d 40 04             	lea    0x4(%eax),%eax
  800361:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800364:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800367:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80036b:	79 90                	jns    8002fd <vprintfmt+0x39>
				width = precision, precision = -1;
  80036d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800370:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800373:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80037a:	eb 81                	jmp    8002fd <vprintfmt+0x39>
  80037c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80037f:	85 c0                	test   %eax,%eax
  800381:	ba 00 00 00 00       	mov    $0x0,%edx
  800386:	0f 49 d0             	cmovns %eax,%edx
  800389:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80038c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80038f:	e9 69 ff ff ff       	jmp    8002fd <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800394:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800397:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80039e:	e9 5a ff ff ff       	jmp    8002fd <vprintfmt+0x39>
  8003a3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003a9:	eb bc                	jmp    800367 <vprintfmt+0xa3>
			lflag++;
  8003ab:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003ae:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003b1:	e9 47 ff ff ff       	jmp    8002fd <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8003b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b9:	8d 78 04             	lea    0x4(%eax),%edi
  8003bc:	83 ec 08             	sub    $0x8,%esp
  8003bf:	53                   	push   %ebx
  8003c0:	ff 30                	pushl  (%eax)
  8003c2:	ff d6                	call   *%esi
			break;
  8003c4:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003c7:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003ca:	e9 9b 02 00 00       	jmp    80066a <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8003cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d2:	8d 78 04             	lea    0x4(%eax),%edi
  8003d5:	8b 00                	mov    (%eax),%eax
  8003d7:	99                   	cltd   
  8003d8:	31 d0                	xor    %edx,%eax
  8003da:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003dc:	83 f8 08             	cmp    $0x8,%eax
  8003df:	7f 23                	jg     800404 <vprintfmt+0x140>
  8003e1:	8b 14 85 60 17 80 00 	mov    0x801760(,%eax,4),%edx
  8003e8:	85 d2                	test   %edx,%edx
  8003ea:	74 18                	je     800404 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8003ec:	52                   	push   %edx
  8003ed:	68 54 15 80 00       	push   $0x801554
  8003f2:	53                   	push   %ebx
  8003f3:	56                   	push   %esi
  8003f4:	e8 aa fe ff ff       	call   8002a3 <printfmt>
  8003f9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003fc:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003ff:	e9 66 02 00 00       	jmp    80066a <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800404:	50                   	push   %eax
  800405:	68 4b 15 80 00       	push   $0x80154b
  80040a:	53                   	push   %ebx
  80040b:	56                   	push   %esi
  80040c:	e8 92 fe ff ff       	call   8002a3 <printfmt>
  800411:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800414:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800417:	e9 4e 02 00 00       	jmp    80066a <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  80041c:	8b 45 14             	mov    0x14(%ebp),%eax
  80041f:	83 c0 04             	add    $0x4,%eax
  800422:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800425:	8b 45 14             	mov    0x14(%ebp),%eax
  800428:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80042a:	85 d2                	test   %edx,%edx
  80042c:	b8 44 15 80 00       	mov    $0x801544,%eax
  800431:	0f 45 c2             	cmovne %edx,%eax
  800434:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800437:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80043b:	7e 06                	jle    800443 <vprintfmt+0x17f>
  80043d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800441:	75 0d                	jne    800450 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  800443:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800446:	89 c7                	mov    %eax,%edi
  800448:	03 45 e0             	add    -0x20(%ebp),%eax
  80044b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80044e:	eb 55                	jmp    8004a5 <vprintfmt+0x1e1>
  800450:	83 ec 08             	sub    $0x8,%esp
  800453:	ff 75 d8             	pushl  -0x28(%ebp)
  800456:	ff 75 cc             	pushl  -0x34(%ebp)
  800459:	e8 46 03 00 00       	call   8007a4 <strnlen>
  80045e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800461:	29 c2                	sub    %eax,%edx
  800463:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800466:	83 c4 10             	add    $0x10,%esp
  800469:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80046b:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80046f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800472:	85 ff                	test   %edi,%edi
  800474:	7e 11                	jle    800487 <vprintfmt+0x1c3>
					putch(padc, putdat);
  800476:	83 ec 08             	sub    $0x8,%esp
  800479:	53                   	push   %ebx
  80047a:	ff 75 e0             	pushl  -0x20(%ebp)
  80047d:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80047f:	83 ef 01             	sub    $0x1,%edi
  800482:	83 c4 10             	add    $0x10,%esp
  800485:	eb eb                	jmp    800472 <vprintfmt+0x1ae>
  800487:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80048a:	85 d2                	test   %edx,%edx
  80048c:	b8 00 00 00 00       	mov    $0x0,%eax
  800491:	0f 49 c2             	cmovns %edx,%eax
  800494:	29 c2                	sub    %eax,%edx
  800496:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800499:	eb a8                	jmp    800443 <vprintfmt+0x17f>
					putch(ch, putdat);
  80049b:	83 ec 08             	sub    $0x8,%esp
  80049e:	53                   	push   %ebx
  80049f:	52                   	push   %edx
  8004a0:	ff d6                	call   *%esi
  8004a2:	83 c4 10             	add    $0x10,%esp
  8004a5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004a8:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004aa:	83 c7 01             	add    $0x1,%edi
  8004ad:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004b1:	0f be d0             	movsbl %al,%edx
  8004b4:	85 d2                	test   %edx,%edx
  8004b6:	74 4b                	je     800503 <vprintfmt+0x23f>
  8004b8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004bc:	78 06                	js     8004c4 <vprintfmt+0x200>
  8004be:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004c2:	78 1e                	js     8004e2 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004c4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004c8:	74 d1                	je     80049b <vprintfmt+0x1d7>
  8004ca:	0f be c0             	movsbl %al,%eax
  8004cd:	83 e8 20             	sub    $0x20,%eax
  8004d0:	83 f8 5e             	cmp    $0x5e,%eax
  8004d3:	76 c6                	jbe    80049b <vprintfmt+0x1d7>
					putch('?', putdat);
  8004d5:	83 ec 08             	sub    $0x8,%esp
  8004d8:	53                   	push   %ebx
  8004d9:	6a 3f                	push   $0x3f
  8004db:	ff d6                	call   *%esi
  8004dd:	83 c4 10             	add    $0x10,%esp
  8004e0:	eb c3                	jmp    8004a5 <vprintfmt+0x1e1>
  8004e2:	89 cf                	mov    %ecx,%edi
  8004e4:	eb 0e                	jmp    8004f4 <vprintfmt+0x230>
				putch(' ', putdat);
  8004e6:	83 ec 08             	sub    $0x8,%esp
  8004e9:	53                   	push   %ebx
  8004ea:	6a 20                	push   $0x20
  8004ec:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004ee:	83 ef 01             	sub    $0x1,%edi
  8004f1:	83 c4 10             	add    $0x10,%esp
  8004f4:	85 ff                	test   %edi,%edi
  8004f6:	7f ee                	jg     8004e6 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8004f8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004fb:	89 45 14             	mov    %eax,0x14(%ebp)
  8004fe:	e9 67 01 00 00       	jmp    80066a <vprintfmt+0x3a6>
  800503:	89 cf                	mov    %ecx,%edi
  800505:	eb ed                	jmp    8004f4 <vprintfmt+0x230>
	if (lflag >= 2)
  800507:	83 f9 01             	cmp    $0x1,%ecx
  80050a:	7f 1b                	jg     800527 <vprintfmt+0x263>
	else if (lflag)
  80050c:	85 c9                	test   %ecx,%ecx
  80050e:	74 63                	je     800573 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800510:	8b 45 14             	mov    0x14(%ebp),%eax
  800513:	8b 00                	mov    (%eax),%eax
  800515:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800518:	99                   	cltd   
  800519:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80051c:	8b 45 14             	mov    0x14(%ebp),%eax
  80051f:	8d 40 04             	lea    0x4(%eax),%eax
  800522:	89 45 14             	mov    %eax,0x14(%ebp)
  800525:	eb 17                	jmp    80053e <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800527:	8b 45 14             	mov    0x14(%ebp),%eax
  80052a:	8b 50 04             	mov    0x4(%eax),%edx
  80052d:	8b 00                	mov    (%eax),%eax
  80052f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800532:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800535:	8b 45 14             	mov    0x14(%ebp),%eax
  800538:	8d 40 08             	lea    0x8(%eax),%eax
  80053b:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80053e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800541:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800544:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800549:	85 c9                	test   %ecx,%ecx
  80054b:	0f 89 ff 00 00 00    	jns    800650 <vprintfmt+0x38c>
				putch('-', putdat);
  800551:	83 ec 08             	sub    $0x8,%esp
  800554:	53                   	push   %ebx
  800555:	6a 2d                	push   $0x2d
  800557:	ff d6                	call   *%esi
				num = -(long long) num;
  800559:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80055c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80055f:	f7 da                	neg    %edx
  800561:	83 d1 00             	adc    $0x0,%ecx
  800564:	f7 d9                	neg    %ecx
  800566:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800569:	b8 0a 00 00 00       	mov    $0xa,%eax
  80056e:	e9 dd 00 00 00       	jmp    800650 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  800573:	8b 45 14             	mov    0x14(%ebp),%eax
  800576:	8b 00                	mov    (%eax),%eax
  800578:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80057b:	99                   	cltd   
  80057c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80057f:	8b 45 14             	mov    0x14(%ebp),%eax
  800582:	8d 40 04             	lea    0x4(%eax),%eax
  800585:	89 45 14             	mov    %eax,0x14(%ebp)
  800588:	eb b4                	jmp    80053e <vprintfmt+0x27a>
	if (lflag >= 2)
  80058a:	83 f9 01             	cmp    $0x1,%ecx
  80058d:	7f 1e                	jg     8005ad <vprintfmt+0x2e9>
	else if (lflag)
  80058f:	85 c9                	test   %ecx,%ecx
  800591:	74 32                	je     8005c5 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800593:	8b 45 14             	mov    0x14(%ebp),%eax
  800596:	8b 10                	mov    (%eax),%edx
  800598:	b9 00 00 00 00       	mov    $0x0,%ecx
  80059d:	8d 40 04             	lea    0x4(%eax),%eax
  8005a0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005a3:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8005a8:	e9 a3 00 00 00       	jmp    800650 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b0:	8b 10                	mov    (%eax),%edx
  8005b2:	8b 48 04             	mov    0x4(%eax),%ecx
  8005b5:	8d 40 08             	lea    0x8(%eax),%eax
  8005b8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005bb:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8005c0:	e9 8b 00 00 00       	jmp    800650 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c8:	8b 10                	mov    (%eax),%edx
  8005ca:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005cf:	8d 40 04             	lea    0x4(%eax),%eax
  8005d2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005d5:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8005da:	eb 74                	jmp    800650 <vprintfmt+0x38c>
	if (lflag >= 2)
  8005dc:	83 f9 01             	cmp    $0x1,%ecx
  8005df:	7f 1b                	jg     8005fc <vprintfmt+0x338>
	else if (lflag)
  8005e1:	85 c9                	test   %ecx,%ecx
  8005e3:	74 2c                	je     800611 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8005e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e8:	8b 10                	mov    (%eax),%edx
  8005ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005ef:	8d 40 04             	lea    0x4(%eax),%eax
  8005f2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005f5:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8005fa:	eb 54                	jmp    800650 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ff:	8b 10                	mov    (%eax),%edx
  800601:	8b 48 04             	mov    0x4(%eax),%ecx
  800604:	8d 40 08             	lea    0x8(%eax),%eax
  800607:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80060a:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80060f:	eb 3f                	jmp    800650 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800611:	8b 45 14             	mov    0x14(%ebp),%eax
  800614:	8b 10                	mov    (%eax),%edx
  800616:	b9 00 00 00 00       	mov    $0x0,%ecx
  80061b:	8d 40 04             	lea    0x4(%eax),%eax
  80061e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800621:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800626:	eb 28                	jmp    800650 <vprintfmt+0x38c>
			putch('0', putdat);
  800628:	83 ec 08             	sub    $0x8,%esp
  80062b:	53                   	push   %ebx
  80062c:	6a 30                	push   $0x30
  80062e:	ff d6                	call   *%esi
			putch('x', putdat);
  800630:	83 c4 08             	add    $0x8,%esp
  800633:	53                   	push   %ebx
  800634:	6a 78                	push   $0x78
  800636:	ff d6                	call   *%esi
			num = (unsigned long long)
  800638:	8b 45 14             	mov    0x14(%ebp),%eax
  80063b:	8b 10                	mov    (%eax),%edx
  80063d:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800642:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800645:	8d 40 04             	lea    0x4(%eax),%eax
  800648:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80064b:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800650:	83 ec 0c             	sub    $0xc,%esp
  800653:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800657:	57                   	push   %edi
  800658:	ff 75 e0             	pushl  -0x20(%ebp)
  80065b:	50                   	push   %eax
  80065c:	51                   	push   %ecx
  80065d:	52                   	push   %edx
  80065e:	89 da                	mov    %ebx,%edx
  800660:	89 f0                	mov    %esi,%eax
  800662:	e8 72 fb ff ff       	call   8001d9 <printnum>
			break;
  800667:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80066a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80066d:	83 c7 01             	add    $0x1,%edi
  800670:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800674:	83 f8 25             	cmp    $0x25,%eax
  800677:	0f 84 62 fc ff ff    	je     8002df <vprintfmt+0x1b>
			if (ch == '\0')
  80067d:	85 c0                	test   %eax,%eax
  80067f:	0f 84 8b 00 00 00    	je     800710 <vprintfmt+0x44c>
			putch(ch, putdat);
  800685:	83 ec 08             	sub    $0x8,%esp
  800688:	53                   	push   %ebx
  800689:	50                   	push   %eax
  80068a:	ff d6                	call   *%esi
  80068c:	83 c4 10             	add    $0x10,%esp
  80068f:	eb dc                	jmp    80066d <vprintfmt+0x3a9>
	if (lflag >= 2)
  800691:	83 f9 01             	cmp    $0x1,%ecx
  800694:	7f 1b                	jg     8006b1 <vprintfmt+0x3ed>
	else if (lflag)
  800696:	85 c9                	test   %ecx,%ecx
  800698:	74 2c                	je     8006c6 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  80069a:	8b 45 14             	mov    0x14(%ebp),%eax
  80069d:	8b 10                	mov    (%eax),%edx
  80069f:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006a4:	8d 40 04             	lea    0x4(%eax),%eax
  8006a7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006aa:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8006af:	eb 9f                	jmp    800650 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8006b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b4:	8b 10                	mov    (%eax),%edx
  8006b6:	8b 48 04             	mov    0x4(%eax),%ecx
  8006b9:	8d 40 08             	lea    0x8(%eax),%eax
  8006bc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006bf:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8006c4:	eb 8a                	jmp    800650 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c9:	8b 10                	mov    (%eax),%edx
  8006cb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006d0:	8d 40 04             	lea    0x4(%eax),%eax
  8006d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006d6:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8006db:	e9 70 ff ff ff       	jmp    800650 <vprintfmt+0x38c>
			putch(ch, putdat);
  8006e0:	83 ec 08             	sub    $0x8,%esp
  8006e3:	53                   	push   %ebx
  8006e4:	6a 25                	push   $0x25
  8006e6:	ff d6                	call   *%esi
			break;
  8006e8:	83 c4 10             	add    $0x10,%esp
  8006eb:	e9 7a ff ff ff       	jmp    80066a <vprintfmt+0x3a6>
			putch('%', putdat);
  8006f0:	83 ec 08             	sub    $0x8,%esp
  8006f3:	53                   	push   %ebx
  8006f4:	6a 25                	push   $0x25
  8006f6:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006f8:	83 c4 10             	add    $0x10,%esp
  8006fb:	89 f8                	mov    %edi,%eax
  8006fd:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800701:	74 05                	je     800708 <vprintfmt+0x444>
  800703:	83 e8 01             	sub    $0x1,%eax
  800706:	eb f5                	jmp    8006fd <vprintfmt+0x439>
  800708:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80070b:	e9 5a ff ff ff       	jmp    80066a <vprintfmt+0x3a6>
}
  800710:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800713:	5b                   	pop    %ebx
  800714:	5e                   	pop    %esi
  800715:	5f                   	pop    %edi
  800716:	5d                   	pop    %ebp
  800717:	c3                   	ret    

00800718 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800718:	f3 0f 1e fb          	endbr32 
  80071c:	55                   	push   %ebp
  80071d:	89 e5                	mov    %esp,%ebp
  80071f:	83 ec 18             	sub    $0x18,%esp
  800722:	8b 45 08             	mov    0x8(%ebp),%eax
  800725:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800728:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80072b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80072f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800732:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800739:	85 c0                	test   %eax,%eax
  80073b:	74 26                	je     800763 <vsnprintf+0x4b>
  80073d:	85 d2                	test   %edx,%edx
  80073f:	7e 22                	jle    800763 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800741:	ff 75 14             	pushl  0x14(%ebp)
  800744:	ff 75 10             	pushl  0x10(%ebp)
  800747:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80074a:	50                   	push   %eax
  80074b:	68 82 02 80 00       	push   $0x800282
  800750:	e8 6f fb ff ff       	call   8002c4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800755:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800758:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80075b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80075e:	83 c4 10             	add    $0x10,%esp
}
  800761:	c9                   	leave  
  800762:	c3                   	ret    
		return -E_INVAL;
  800763:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800768:	eb f7                	jmp    800761 <vsnprintf+0x49>

0080076a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80076a:	f3 0f 1e fb          	endbr32 
  80076e:	55                   	push   %ebp
  80076f:	89 e5                	mov    %esp,%ebp
  800771:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800774:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800777:	50                   	push   %eax
  800778:	ff 75 10             	pushl  0x10(%ebp)
  80077b:	ff 75 0c             	pushl  0xc(%ebp)
  80077e:	ff 75 08             	pushl  0x8(%ebp)
  800781:	e8 92 ff ff ff       	call   800718 <vsnprintf>
	va_end(ap);

	return rc;
}
  800786:	c9                   	leave  
  800787:	c3                   	ret    

00800788 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800788:	f3 0f 1e fb          	endbr32 
  80078c:	55                   	push   %ebp
  80078d:	89 e5                	mov    %esp,%ebp
  80078f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800792:	b8 00 00 00 00       	mov    $0x0,%eax
  800797:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80079b:	74 05                	je     8007a2 <strlen+0x1a>
		n++;
  80079d:	83 c0 01             	add    $0x1,%eax
  8007a0:	eb f5                	jmp    800797 <strlen+0xf>
	return n;
}
  8007a2:	5d                   	pop    %ebp
  8007a3:	c3                   	ret    

008007a4 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007a4:	f3 0f 1e fb          	endbr32 
  8007a8:	55                   	push   %ebp
  8007a9:	89 e5                	mov    %esp,%ebp
  8007ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007ae:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8007b6:	39 d0                	cmp    %edx,%eax
  8007b8:	74 0d                	je     8007c7 <strnlen+0x23>
  8007ba:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007be:	74 05                	je     8007c5 <strnlen+0x21>
		n++;
  8007c0:	83 c0 01             	add    $0x1,%eax
  8007c3:	eb f1                	jmp    8007b6 <strnlen+0x12>
  8007c5:	89 c2                	mov    %eax,%edx
	return n;
}
  8007c7:	89 d0                	mov    %edx,%eax
  8007c9:	5d                   	pop    %ebp
  8007ca:	c3                   	ret    

008007cb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007cb:	f3 0f 1e fb          	endbr32 
  8007cf:	55                   	push   %ebp
  8007d0:	89 e5                	mov    %esp,%ebp
  8007d2:	53                   	push   %ebx
  8007d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007d6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8007de:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8007e2:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8007e5:	83 c0 01             	add    $0x1,%eax
  8007e8:	84 d2                	test   %dl,%dl
  8007ea:	75 f2                	jne    8007de <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8007ec:	89 c8                	mov    %ecx,%eax
  8007ee:	5b                   	pop    %ebx
  8007ef:	5d                   	pop    %ebp
  8007f0:	c3                   	ret    

008007f1 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007f1:	f3 0f 1e fb          	endbr32 
  8007f5:	55                   	push   %ebp
  8007f6:	89 e5                	mov    %esp,%ebp
  8007f8:	53                   	push   %ebx
  8007f9:	83 ec 10             	sub    $0x10,%esp
  8007fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007ff:	53                   	push   %ebx
  800800:	e8 83 ff ff ff       	call   800788 <strlen>
  800805:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800808:	ff 75 0c             	pushl  0xc(%ebp)
  80080b:	01 d8                	add    %ebx,%eax
  80080d:	50                   	push   %eax
  80080e:	e8 b8 ff ff ff       	call   8007cb <strcpy>
	return dst;
}
  800813:	89 d8                	mov    %ebx,%eax
  800815:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800818:	c9                   	leave  
  800819:	c3                   	ret    

0080081a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80081a:	f3 0f 1e fb          	endbr32 
  80081e:	55                   	push   %ebp
  80081f:	89 e5                	mov    %esp,%ebp
  800821:	56                   	push   %esi
  800822:	53                   	push   %ebx
  800823:	8b 75 08             	mov    0x8(%ebp),%esi
  800826:	8b 55 0c             	mov    0xc(%ebp),%edx
  800829:	89 f3                	mov    %esi,%ebx
  80082b:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80082e:	89 f0                	mov    %esi,%eax
  800830:	39 d8                	cmp    %ebx,%eax
  800832:	74 11                	je     800845 <strncpy+0x2b>
		*dst++ = *src;
  800834:	83 c0 01             	add    $0x1,%eax
  800837:	0f b6 0a             	movzbl (%edx),%ecx
  80083a:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80083d:	80 f9 01             	cmp    $0x1,%cl
  800840:	83 da ff             	sbb    $0xffffffff,%edx
  800843:	eb eb                	jmp    800830 <strncpy+0x16>
	}
	return ret;
}
  800845:	89 f0                	mov    %esi,%eax
  800847:	5b                   	pop    %ebx
  800848:	5e                   	pop    %esi
  800849:	5d                   	pop    %ebp
  80084a:	c3                   	ret    

0080084b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80084b:	f3 0f 1e fb          	endbr32 
  80084f:	55                   	push   %ebp
  800850:	89 e5                	mov    %esp,%ebp
  800852:	56                   	push   %esi
  800853:	53                   	push   %ebx
  800854:	8b 75 08             	mov    0x8(%ebp),%esi
  800857:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80085a:	8b 55 10             	mov    0x10(%ebp),%edx
  80085d:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80085f:	85 d2                	test   %edx,%edx
  800861:	74 21                	je     800884 <strlcpy+0x39>
  800863:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800867:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800869:	39 c2                	cmp    %eax,%edx
  80086b:	74 14                	je     800881 <strlcpy+0x36>
  80086d:	0f b6 19             	movzbl (%ecx),%ebx
  800870:	84 db                	test   %bl,%bl
  800872:	74 0b                	je     80087f <strlcpy+0x34>
			*dst++ = *src++;
  800874:	83 c1 01             	add    $0x1,%ecx
  800877:	83 c2 01             	add    $0x1,%edx
  80087a:	88 5a ff             	mov    %bl,-0x1(%edx)
  80087d:	eb ea                	jmp    800869 <strlcpy+0x1e>
  80087f:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800881:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800884:	29 f0                	sub    %esi,%eax
}
  800886:	5b                   	pop    %ebx
  800887:	5e                   	pop    %esi
  800888:	5d                   	pop    %ebp
  800889:	c3                   	ret    

0080088a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80088a:	f3 0f 1e fb          	endbr32 
  80088e:	55                   	push   %ebp
  80088f:	89 e5                	mov    %esp,%ebp
  800891:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800894:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800897:	0f b6 01             	movzbl (%ecx),%eax
  80089a:	84 c0                	test   %al,%al
  80089c:	74 0c                	je     8008aa <strcmp+0x20>
  80089e:	3a 02                	cmp    (%edx),%al
  8008a0:	75 08                	jne    8008aa <strcmp+0x20>
		p++, q++;
  8008a2:	83 c1 01             	add    $0x1,%ecx
  8008a5:	83 c2 01             	add    $0x1,%edx
  8008a8:	eb ed                	jmp    800897 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008aa:	0f b6 c0             	movzbl %al,%eax
  8008ad:	0f b6 12             	movzbl (%edx),%edx
  8008b0:	29 d0                	sub    %edx,%eax
}
  8008b2:	5d                   	pop    %ebp
  8008b3:	c3                   	ret    

008008b4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008b4:	f3 0f 1e fb          	endbr32 
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	53                   	push   %ebx
  8008bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c2:	89 c3                	mov    %eax,%ebx
  8008c4:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008c7:	eb 06                	jmp    8008cf <strncmp+0x1b>
		n--, p++, q++;
  8008c9:	83 c0 01             	add    $0x1,%eax
  8008cc:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008cf:	39 d8                	cmp    %ebx,%eax
  8008d1:	74 16                	je     8008e9 <strncmp+0x35>
  8008d3:	0f b6 08             	movzbl (%eax),%ecx
  8008d6:	84 c9                	test   %cl,%cl
  8008d8:	74 04                	je     8008de <strncmp+0x2a>
  8008da:	3a 0a                	cmp    (%edx),%cl
  8008dc:	74 eb                	je     8008c9 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008de:	0f b6 00             	movzbl (%eax),%eax
  8008e1:	0f b6 12             	movzbl (%edx),%edx
  8008e4:	29 d0                	sub    %edx,%eax
}
  8008e6:	5b                   	pop    %ebx
  8008e7:	5d                   	pop    %ebp
  8008e8:	c3                   	ret    
		return 0;
  8008e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ee:	eb f6                	jmp    8008e6 <strncmp+0x32>

008008f0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008f0:	f3 0f 1e fb          	endbr32 
  8008f4:	55                   	push   %ebp
  8008f5:	89 e5                	mov    %esp,%ebp
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008fe:	0f b6 10             	movzbl (%eax),%edx
  800901:	84 d2                	test   %dl,%dl
  800903:	74 09                	je     80090e <strchr+0x1e>
		if (*s == c)
  800905:	38 ca                	cmp    %cl,%dl
  800907:	74 0a                	je     800913 <strchr+0x23>
	for (; *s; s++)
  800909:	83 c0 01             	add    $0x1,%eax
  80090c:	eb f0                	jmp    8008fe <strchr+0xe>
			return (char *) s;
	return 0;
  80090e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800913:	5d                   	pop    %ebp
  800914:	c3                   	ret    

00800915 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800915:	f3 0f 1e fb          	endbr32 
  800919:	55                   	push   %ebp
  80091a:	89 e5                	mov    %esp,%ebp
  80091c:	8b 45 08             	mov    0x8(%ebp),%eax
  80091f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800923:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800926:	38 ca                	cmp    %cl,%dl
  800928:	74 09                	je     800933 <strfind+0x1e>
  80092a:	84 d2                	test   %dl,%dl
  80092c:	74 05                	je     800933 <strfind+0x1e>
	for (; *s; s++)
  80092e:	83 c0 01             	add    $0x1,%eax
  800931:	eb f0                	jmp    800923 <strfind+0xe>
			break;
	return (char *) s;
}
  800933:	5d                   	pop    %ebp
  800934:	c3                   	ret    

00800935 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800935:	f3 0f 1e fb          	endbr32 
  800939:	55                   	push   %ebp
  80093a:	89 e5                	mov    %esp,%ebp
  80093c:	57                   	push   %edi
  80093d:	56                   	push   %esi
  80093e:	53                   	push   %ebx
  80093f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800942:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800945:	85 c9                	test   %ecx,%ecx
  800947:	74 31                	je     80097a <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800949:	89 f8                	mov    %edi,%eax
  80094b:	09 c8                	or     %ecx,%eax
  80094d:	a8 03                	test   $0x3,%al
  80094f:	75 23                	jne    800974 <memset+0x3f>
		c &= 0xFF;
  800951:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800955:	89 d3                	mov    %edx,%ebx
  800957:	c1 e3 08             	shl    $0x8,%ebx
  80095a:	89 d0                	mov    %edx,%eax
  80095c:	c1 e0 18             	shl    $0x18,%eax
  80095f:	89 d6                	mov    %edx,%esi
  800961:	c1 e6 10             	shl    $0x10,%esi
  800964:	09 f0                	or     %esi,%eax
  800966:	09 c2                	or     %eax,%edx
  800968:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80096a:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80096d:	89 d0                	mov    %edx,%eax
  80096f:	fc                   	cld    
  800970:	f3 ab                	rep stos %eax,%es:(%edi)
  800972:	eb 06                	jmp    80097a <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800974:	8b 45 0c             	mov    0xc(%ebp),%eax
  800977:	fc                   	cld    
  800978:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80097a:	89 f8                	mov    %edi,%eax
  80097c:	5b                   	pop    %ebx
  80097d:	5e                   	pop    %esi
  80097e:	5f                   	pop    %edi
  80097f:	5d                   	pop    %ebp
  800980:	c3                   	ret    

00800981 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800981:	f3 0f 1e fb          	endbr32 
  800985:	55                   	push   %ebp
  800986:	89 e5                	mov    %esp,%ebp
  800988:	57                   	push   %edi
  800989:	56                   	push   %esi
  80098a:	8b 45 08             	mov    0x8(%ebp),%eax
  80098d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800990:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800993:	39 c6                	cmp    %eax,%esi
  800995:	73 32                	jae    8009c9 <memmove+0x48>
  800997:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80099a:	39 c2                	cmp    %eax,%edx
  80099c:	76 2b                	jbe    8009c9 <memmove+0x48>
		s += n;
		d += n;
  80099e:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009a1:	89 fe                	mov    %edi,%esi
  8009a3:	09 ce                	or     %ecx,%esi
  8009a5:	09 d6                	or     %edx,%esi
  8009a7:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009ad:	75 0e                	jne    8009bd <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009af:	83 ef 04             	sub    $0x4,%edi
  8009b2:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009b5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009b8:	fd                   	std    
  8009b9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009bb:	eb 09                	jmp    8009c6 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009bd:	83 ef 01             	sub    $0x1,%edi
  8009c0:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009c3:	fd                   	std    
  8009c4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009c6:	fc                   	cld    
  8009c7:	eb 1a                	jmp    8009e3 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009c9:	89 c2                	mov    %eax,%edx
  8009cb:	09 ca                	or     %ecx,%edx
  8009cd:	09 f2                	or     %esi,%edx
  8009cf:	f6 c2 03             	test   $0x3,%dl
  8009d2:	75 0a                	jne    8009de <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009d4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009d7:	89 c7                	mov    %eax,%edi
  8009d9:	fc                   	cld    
  8009da:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009dc:	eb 05                	jmp    8009e3 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8009de:	89 c7                	mov    %eax,%edi
  8009e0:	fc                   	cld    
  8009e1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009e3:	5e                   	pop    %esi
  8009e4:	5f                   	pop    %edi
  8009e5:	5d                   	pop    %ebp
  8009e6:	c3                   	ret    

008009e7 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009e7:	f3 0f 1e fb          	endbr32 
  8009eb:	55                   	push   %ebp
  8009ec:	89 e5                	mov    %esp,%ebp
  8009ee:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009f1:	ff 75 10             	pushl  0x10(%ebp)
  8009f4:	ff 75 0c             	pushl  0xc(%ebp)
  8009f7:	ff 75 08             	pushl  0x8(%ebp)
  8009fa:	e8 82 ff ff ff       	call   800981 <memmove>
}
  8009ff:	c9                   	leave  
  800a00:	c3                   	ret    

00800a01 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a01:	f3 0f 1e fb          	endbr32 
  800a05:	55                   	push   %ebp
  800a06:	89 e5                	mov    %esp,%ebp
  800a08:	56                   	push   %esi
  800a09:	53                   	push   %ebx
  800a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a10:	89 c6                	mov    %eax,%esi
  800a12:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a15:	39 f0                	cmp    %esi,%eax
  800a17:	74 1c                	je     800a35 <memcmp+0x34>
		if (*s1 != *s2)
  800a19:	0f b6 08             	movzbl (%eax),%ecx
  800a1c:	0f b6 1a             	movzbl (%edx),%ebx
  800a1f:	38 d9                	cmp    %bl,%cl
  800a21:	75 08                	jne    800a2b <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a23:	83 c0 01             	add    $0x1,%eax
  800a26:	83 c2 01             	add    $0x1,%edx
  800a29:	eb ea                	jmp    800a15 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a2b:	0f b6 c1             	movzbl %cl,%eax
  800a2e:	0f b6 db             	movzbl %bl,%ebx
  800a31:	29 d8                	sub    %ebx,%eax
  800a33:	eb 05                	jmp    800a3a <memcmp+0x39>
	}

	return 0;
  800a35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a3a:	5b                   	pop    %ebx
  800a3b:	5e                   	pop    %esi
  800a3c:	5d                   	pop    %ebp
  800a3d:	c3                   	ret    

00800a3e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a3e:	f3 0f 1e fb          	endbr32 
  800a42:	55                   	push   %ebp
  800a43:	89 e5                	mov    %esp,%ebp
  800a45:	8b 45 08             	mov    0x8(%ebp),%eax
  800a48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a4b:	89 c2                	mov    %eax,%edx
  800a4d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a50:	39 d0                	cmp    %edx,%eax
  800a52:	73 09                	jae    800a5d <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a54:	38 08                	cmp    %cl,(%eax)
  800a56:	74 05                	je     800a5d <memfind+0x1f>
	for (; s < ends; s++)
  800a58:	83 c0 01             	add    $0x1,%eax
  800a5b:	eb f3                	jmp    800a50 <memfind+0x12>
			break;
	return (void *) s;
}
  800a5d:	5d                   	pop    %ebp
  800a5e:	c3                   	ret    

00800a5f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a5f:	f3 0f 1e fb          	endbr32 
  800a63:	55                   	push   %ebp
  800a64:	89 e5                	mov    %esp,%ebp
  800a66:	57                   	push   %edi
  800a67:	56                   	push   %esi
  800a68:	53                   	push   %ebx
  800a69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a6c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a6f:	eb 03                	jmp    800a74 <strtol+0x15>
		s++;
  800a71:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a74:	0f b6 01             	movzbl (%ecx),%eax
  800a77:	3c 20                	cmp    $0x20,%al
  800a79:	74 f6                	je     800a71 <strtol+0x12>
  800a7b:	3c 09                	cmp    $0x9,%al
  800a7d:	74 f2                	je     800a71 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a7f:	3c 2b                	cmp    $0x2b,%al
  800a81:	74 2a                	je     800aad <strtol+0x4e>
	int neg = 0;
  800a83:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a88:	3c 2d                	cmp    $0x2d,%al
  800a8a:	74 2b                	je     800ab7 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a8c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a92:	75 0f                	jne    800aa3 <strtol+0x44>
  800a94:	80 39 30             	cmpb   $0x30,(%ecx)
  800a97:	74 28                	je     800ac1 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a99:	85 db                	test   %ebx,%ebx
  800a9b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800aa0:	0f 44 d8             	cmove  %eax,%ebx
  800aa3:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa8:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800aab:	eb 46                	jmp    800af3 <strtol+0x94>
		s++;
  800aad:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ab0:	bf 00 00 00 00       	mov    $0x0,%edi
  800ab5:	eb d5                	jmp    800a8c <strtol+0x2d>
		s++, neg = 1;
  800ab7:	83 c1 01             	add    $0x1,%ecx
  800aba:	bf 01 00 00 00       	mov    $0x1,%edi
  800abf:	eb cb                	jmp    800a8c <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ac1:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ac5:	74 0e                	je     800ad5 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800ac7:	85 db                	test   %ebx,%ebx
  800ac9:	75 d8                	jne    800aa3 <strtol+0x44>
		s++, base = 8;
  800acb:	83 c1 01             	add    $0x1,%ecx
  800ace:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ad3:	eb ce                	jmp    800aa3 <strtol+0x44>
		s += 2, base = 16;
  800ad5:	83 c1 02             	add    $0x2,%ecx
  800ad8:	bb 10 00 00 00       	mov    $0x10,%ebx
  800add:	eb c4                	jmp    800aa3 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800adf:	0f be d2             	movsbl %dl,%edx
  800ae2:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ae5:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ae8:	7d 3a                	jge    800b24 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800aea:	83 c1 01             	add    $0x1,%ecx
  800aed:	0f af 45 10          	imul   0x10(%ebp),%eax
  800af1:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800af3:	0f b6 11             	movzbl (%ecx),%edx
  800af6:	8d 72 d0             	lea    -0x30(%edx),%esi
  800af9:	89 f3                	mov    %esi,%ebx
  800afb:	80 fb 09             	cmp    $0x9,%bl
  800afe:	76 df                	jbe    800adf <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b00:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b03:	89 f3                	mov    %esi,%ebx
  800b05:	80 fb 19             	cmp    $0x19,%bl
  800b08:	77 08                	ja     800b12 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b0a:	0f be d2             	movsbl %dl,%edx
  800b0d:	83 ea 57             	sub    $0x57,%edx
  800b10:	eb d3                	jmp    800ae5 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b12:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b15:	89 f3                	mov    %esi,%ebx
  800b17:	80 fb 19             	cmp    $0x19,%bl
  800b1a:	77 08                	ja     800b24 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b1c:	0f be d2             	movsbl %dl,%edx
  800b1f:	83 ea 37             	sub    $0x37,%edx
  800b22:	eb c1                	jmp    800ae5 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b24:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b28:	74 05                	je     800b2f <strtol+0xd0>
		*endptr = (char *) s;
  800b2a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b2d:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b2f:	89 c2                	mov    %eax,%edx
  800b31:	f7 da                	neg    %edx
  800b33:	85 ff                	test   %edi,%edi
  800b35:	0f 45 c2             	cmovne %edx,%eax
}
  800b38:	5b                   	pop    %ebx
  800b39:	5e                   	pop    %esi
  800b3a:	5f                   	pop    %edi
  800b3b:	5d                   	pop    %ebp
  800b3c:	c3                   	ret    

00800b3d <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b3d:	f3 0f 1e fb          	endbr32 
  800b41:	55                   	push   %ebp
  800b42:	89 e5                	mov    %esp,%ebp
  800b44:	57                   	push   %edi
  800b45:	56                   	push   %esi
  800b46:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b47:	b8 00 00 00 00       	mov    $0x0,%eax
  800b4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b4f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b52:	89 c3                	mov    %eax,%ebx
  800b54:	89 c7                	mov    %eax,%edi
  800b56:	89 c6                	mov    %eax,%esi
  800b58:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b5a:	5b                   	pop    %ebx
  800b5b:	5e                   	pop    %esi
  800b5c:	5f                   	pop    %edi
  800b5d:	5d                   	pop    %ebp
  800b5e:	c3                   	ret    

00800b5f <sys_cgetc>:

int
sys_cgetc(void)
{
  800b5f:	f3 0f 1e fb          	endbr32 
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
  800b66:	57                   	push   %edi
  800b67:	56                   	push   %esi
  800b68:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b69:	ba 00 00 00 00       	mov    $0x0,%edx
  800b6e:	b8 01 00 00 00       	mov    $0x1,%eax
  800b73:	89 d1                	mov    %edx,%ecx
  800b75:	89 d3                	mov    %edx,%ebx
  800b77:	89 d7                	mov    %edx,%edi
  800b79:	89 d6                	mov    %edx,%esi
  800b7b:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b7d:	5b                   	pop    %ebx
  800b7e:	5e                   	pop    %esi
  800b7f:	5f                   	pop    %edi
  800b80:	5d                   	pop    %ebp
  800b81:	c3                   	ret    

00800b82 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b82:	f3 0f 1e fb          	endbr32 
  800b86:	55                   	push   %ebp
  800b87:	89 e5                	mov    %esp,%ebp
  800b89:	57                   	push   %edi
  800b8a:	56                   	push   %esi
  800b8b:	53                   	push   %ebx
  800b8c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b8f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b94:	8b 55 08             	mov    0x8(%ebp),%edx
  800b97:	b8 03 00 00 00       	mov    $0x3,%eax
  800b9c:	89 cb                	mov    %ecx,%ebx
  800b9e:	89 cf                	mov    %ecx,%edi
  800ba0:	89 ce                	mov    %ecx,%esi
  800ba2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ba4:	85 c0                	test   %eax,%eax
  800ba6:	7f 08                	jg     800bb0 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ba8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bab:	5b                   	pop    %ebx
  800bac:	5e                   	pop    %esi
  800bad:	5f                   	pop    %edi
  800bae:	5d                   	pop    %ebp
  800baf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bb0:	83 ec 0c             	sub    $0xc,%esp
  800bb3:	50                   	push   %eax
  800bb4:	6a 03                	push   $0x3
  800bb6:	68 84 17 80 00       	push   $0x801784
  800bbb:	6a 23                	push   $0x23
  800bbd:	68 a1 17 80 00       	push   $0x8017a1
  800bc2:	e8 f6 05 00 00       	call   8011bd <_panic>

00800bc7 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bc7:	f3 0f 1e fb          	endbr32 
  800bcb:	55                   	push   %ebp
  800bcc:	89 e5                	mov    %esp,%ebp
  800bce:	57                   	push   %edi
  800bcf:	56                   	push   %esi
  800bd0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd1:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd6:	b8 02 00 00 00       	mov    $0x2,%eax
  800bdb:	89 d1                	mov    %edx,%ecx
  800bdd:	89 d3                	mov    %edx,%ebx
  800bdf:	89 d7                	mov    %edx,%edi
  800be1:	89 d6                	mov    %edx,%esi
  800be3:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800be5:	5b                   	pop    %ebx
  800be6:	5e                   	pop    %esi
  800be7:	5f                   	pop    %edi
  800be8:	5d                   	pop    %ebp
  800be9:	c3                   	ret    

00800bea <sys_yield>:

void
sys_yield(void)
{
  800bea:	f3 0f 1e fb          	endbr32 
  800bee:	55                   	push   %ebp
  800bef:	89 e5                	mov    %esp,%ebp
  800bf1:	57                   	push   %edi
  800bf2:	56                   	push   %esi
  800bf3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bf4:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bfe:	89 d1                	mov    %edx,%ecx
  800c00:	89 d3                	mov    %edx,%ebx
  800c02:	89 d7                	mov    %edx,%edi
  800c04:	89 d6                	mov    %edx,%esi
  800c06:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c08:	5b                   	pop    %ebx
  800c09:	5e                   	pop    %esi
  800c0a:	5f                   	pop    %edi
  800c0b:	5d                   	pop    %ebp
  800c0c:	c3                   	ret    

00800c0d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c0d:	f3 0f 1e fb          	endbr32 
  800c11:	55                   	push   %ebp
  800c12:	89 e5                	mov    %esp,%ebp
  800c14:	57                   	push   %edi
  800c15:	56                   	push   %esi
  800c16:	53                   	push   %ebx
  800c17:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c1a:	be 00 00 00 00       	mov    $0x0,%esi
  800c1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c25:	b8 04 00 00 00       	mov    $0x4,%eax
  800c2a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c2d:	89 f7                	mov    %esi,%edi
  800c2f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c31:	85 c0                	test   %eax,%eax
  800c33:	7f 08                	jg     800c3d <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c35:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c38:	5b                   	pop    %ebx
  800c39:	5e                   	pop    %esi
  800c3a:	5f                   	pop    %edi
  800c3b:	5d                   	pop    %ebp
  800c3c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c3d:	83 ec 0c             	sub    $0xc,%esp
  800c40:	50                   	push   %eax
  800c41:	6a 04                	push   $0x4
  800c43:	68 84 17 80 00       	push   $0x801784
  800c48:	6a 23                	push   $0x23
  800c4a:	68 a1 17 80 00       	push   $0x8017a1
  800c4f:	e8 69 05 00 00       	call   8011bd <_panic>

00800c54 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c54:	f3 0f 1e fb          	endbr32 
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	57                   	push   %edi
  800c5c:	56                   	push   %esi
  800c5d:	53                   	push   %ebx
  800c5e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c61:	8b 55 08             	mov    0x8(%ebp),%edx
  800c64:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c67:	b8 05 00 00 00       	mov    $0x5,%eax
  800c6c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c6f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c72:	8b 75 18             	mov    0x18(%ebp),%esi
  800c75:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c77:	85 c0                	test   %eax,%eax
  800c79:	7f 08                	jg     800c83 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c7e:	5b                   	pop    %ebx
  800c7f:	5e                   	pop    %esi
  800c80:	5f                   	pop    %edi
  800c81:	5d                   	pop    %ebp
  800c82:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c83:	83 ec 0c             	sub    $0xc,%esp
  800c86:	50                   	push   %eax
  800c87:	6a 05                	push   $0x5
  800c89:	68 84 17 80 00       	push   $0x801784
  800c8e:	6a 23                	push   $0x23
  800c90:	68 a1 17 80 00       	push   $0x8017a1
  800c95:	e8 23 05 00 00       	call   8011bd <_panic>

00800c9a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c9a:	f3 0f 1e fb          	endbr32 
  800c9e:	55                   	push   %ebp
  800c9f:	89 e5                	mov    %esp,%ebp
  800ca1:	57                   	push   %edi
  800ca2:	56                   	push   %esi
  800ca3:	53                   	push   %ebx
  800ca4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ca7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cac:	8b 55 08             	mov    0x8(%ebp),%edx
  800caf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb2:	b8 06 00 00 00       	mov    $0x6,%eax
  800cb7:	89 df                	mov    %ebx,%edi
  800cb9:	89 de                	mov    %ebx,%esi
  800cbb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cbd:	85 c0                	test   %eax,%eax
  800cbf:	7f 08                	jg     800cc9 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc4:	5b                   	pop    %ebx
  800cc5:	5e                   	pop    %esi
  800cc6:	5f                   	pop    %edi
  800cc7:	5d                   	pop    %ebp
  800cc8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc9:	83 ec 0c             	sub    $0xc,%esp
  800ccc:	50                   	push   %eax
  800ccd:	6a 06                	push   $0x6
  800ccf:	68 84 17 80 00       	push   $0x801784
  800cd4:	6a 23                	push   $0x23
  800cd6:	68 a1 17 80 00       	push   $0x8017a1
  800cdb:	e8 dd 04 00 00       	call   8011bd <_panic>

00800ce0 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ce0:	f3 0f 1e fb          	endbr32 
  800ce4:	55                   	push   %ebp
  800ce5:	89 e5                	mov    %esp,%ebp
  800ce7:	57                   	push   %edi
  800ce8:	56                   	push   %esi
  800ce9:	53                   	push   %ebx
  800cea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ced:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cf2:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf8:	b8 08 00 00 00       	mov    $0x8,%eax
  800cfd:	89 df                	mov    %ebx,%edi
  800cff:	89 de                	mov    %ebx,%esi
  800d01:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d03:	85 c0                	test   %eax,%eax
  800d05:	7f 08                	jg     800d0f <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d07:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d0a:	5b                   	pop    %ebx
  800d0b:	5e                   	pop    %esi
  800d0c:	5f                   	pop    %edi
  800d0d:	5d                   	pop    %ebp
  800d0e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0f:	83 ec 0c             	sub    $0xc,%esp
  800d12:	50                   	push   %eax
  800d13:	6a 08                	push   $0x8
  800d15:	68 84 17 80 00       	push   $0x801784
  800d1a:	6a 23                	push   $0x23
  800d1c:	68 a1 17 80 00       	push   $0x8017a1
  800d21:	e8 97 04 00 00       	call   8011bd <_panic>

00800d26 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d26:	f3 0f 1e fb          	endbr32 
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	57                   	push   %edi
  800d2e:	56                   	push   %esi
  800d2f:	53                   	push   %ebx
  800d30:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d33:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d38:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3e:	b8 09 00 00 00       	mov    $0x9,%eax
  800d43:	89 df                	mov    %ebx,%edi
  800d45:	89 de                	mov    %ebx,%esi
  800d47:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d49:	85 c0                	test   %eax,%eax
  800d4b:	7f 08                	jg     800d55 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d50:	5b                   	pop    %ebx
  800d51:	5e                   	pop    %esi
  800d52:	5f                   	pop    %edi
  800d53:	5d                   	pop    %ebp
  800d54:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d55:	83 ec 0c             	sub    $0xc,%esp
  800d58:	50                   	push   %eax
  800d59:	6a 09                	push   $0x9
  800d5b:	68 84 17 80 00       	push   $0x801784
  800d60:	6a 23                	push   $0x23
  800d62:	68 a1 17 80 00       	push   $0x8017a1
  800d67:	e8 51 04 00 00       	call   8011bd <_panic>

00800d6c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d6c:	f3 0f 1e fb          	endbr32 
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
  800d73:	57                   	push   %edi
  800d74:	56                   	push   %esi
  800d75:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d76:	8b 55 08             	mov    0x8(%ebp),%edx
  800d79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7c:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d81:	be 00 00 00 00       	mov    $0x0,%esi
  800d86:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d89:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d8c:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d8e:	5b                   	pop    %ebx
  800d8f:	5e                   	pop    %esi
  800d90:	5f                   	pop    %edi
  800d91:	5d                   	pop    %ebp
  800d92:	c3                   	ret    

00800d93 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d93:	f3 0f 1e fb          	endbr32 
  800d97:	55                   	push   %ebp
  800d98:	89 e5                	mov    %esp,%ebp
  800d9a:	57                   	push   %edi
  800d9b:	56                   	push   %esi
  800d9c:	53                   	push   %ebx
  800d9d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800da5:	8b 55 08             	mov    0x8(%ebp),%edx
  800da8:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dad:	89 cb                	mov    %ecx,%ebx
  800daf:	89 cf                	mov    %ecx,%edi
  800db1:	89 ce                	mov    %ecx,%esi
  800db3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db5:	85 c0                	test   %eax,%eax
  800db7:	7f 08                	jg     800dc1 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800db9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dbc:	5b                   	pop    %ebx
  800dbd:	5e                   	pop    %esi
  800dbe:	5f                   	pop    %edi
  800dbf:	5d                   	pop    %ebp
  800dc0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc1:	83 ec 0c             	sub    $0xc,%esp
  800dc4:	50                   	push   %eax
  800dc5:	6a 0c                	push   $0xc
  800dc7:	68 84 17 80 00       	push   $0x801784
  800dcc:	6a 23                	push   $0x23
  800dce:	68 a1 17 80 00       	push   $0x8017a1
  800dd3:	e8 e5 03 00 00       	call   8011bd <_panic>

00800dd8 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800dd8:	f3 0f 1e fb          	endbr32 
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
  800ddf:	53                   	push   %ebx
  800de0:	83 ec 04             	sub    $0x4,%esp
  800de3:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800de6:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  800de8:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800dec:	74 74                	je     800e62 <pgfault+0x8a>
  800dee:	89 d8                	mov    %ebx,%eax
  800df0:	c1 e8 0c             	shr    $0xc,%eax
  800df3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800dfa:	f6 c4 08             	test   $0x8,%ah
  800dfd:	74 63                	je     800e62 <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800dff:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  800e05:	83 ec 0c             	sub    $0xc,%esp
  800e08:	6a 05                	push   $0x5
  800e0a:	68 00 f0 7f 00       	push   $0x7ff000
  800e0f:	6a 00                	push   $0x0
  800e11:	53                   	push   %ebx
  800e12:	6a 00                	push   $0x0
  800e14:	e8 3b fe ff ff       	call   800c54 <sys_page_map>
  800e19:	83 c4 20             	add    $0x20,%esp
  800e1c:	85 c0                	test   %eax,%eax
  800e1e:	78 59                	js     800e79 <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  800e20:	83 ec 04             	sub    $0x4,%esp
  800e23:	6a 07                	push   $0x7
  800e25:	53                   	push   %ebx
  800e26:	6a 00                	push   $0x0
  800e28:	e8 e0 fd ff ff       	call   800c0d <sys_page_alloc>
  800e2d:	83 c4 10             	add    $0x10,%esp
  800e30:	85 c0                	test   %eax,%eax
  800e32:	78 5a                	js     800e8e <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  800e34:	83 ec 04             	sub    $0x4,%esp
  800e37:	68 00 10 00 00       	push   $0x1000
  800e3c:	68 00 f0 7f 00       	push   $0x7ff000
  800e41:	53                   	push   %ebx
  800e42:	e8 3a fb ff ff       	call   800981 <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  800e47:	83 c4 08             	add    $0x8,%esp
  800e4a:	68 00 f0 7f 00       	push   $0x7ff000
  800e4f:	6a 00                	push   $0x0
  800e51:	e8 44 fe ff ff       	call   800c9a <sys_page_unmap>
  800e56:	83 c4 10             	add    $0x10,%esp
  800e59:	85 c0                	test   %eax,%eax
  800e5b:	78 46                	js     800ea3 <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  800e5d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e60:	c9                   	leave  
  800e61:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  800e62:	83 ec 04             	sub    $0x4,%esp
  800e65:	68 af 17 80 00       	push   $0x8017af
  800e6a:	68 d3 00 00 00       	push   $0xd3
  800e6f:	68 cb 17 80 00       	push   $0x8017cb
  800e74:	e8 44 03 00 00       	call   8011bd <_panic>
		panic("pgfault: %e\n", r);
  800e79:	50                   	push   %eax
  800e7a:	68 d6 17 80 00       	push   $0x8017d6
  800e7f:	68 df 00 00 00       	push   $0xdf
  800e84:	68 cb 17 80 00       	push   $0x8017cb
  800e89:	e8 2f 03 00 00       	call   8011bd <_panic>
		panic("pgfault: %e\n", r);
  800e8e:	50                   	push   %eax
  800e8f:	68 d6 17 80 00       	push   $0x8017d6
  800e94:	68 e3 00 00 00       	push   $0xe3
  800e99:	68 cb 17 80 00       	push   $0x8017cb
  800e9e:	e8 1a 03 00 00       	call   8011bd <_panic>
		panic("pgfault: %e\n", r);
  800ea3:	50                   	push   %eax
  800ea4:	68 d6 17 80 00       	push   $0x8017d6
  800ea9:	68 e9 00 00 00       	push   $0xe9
  800eae:	68 cb 17 80 00       	push   $0x8017cb
  800eb3:	e8 05 03 00 00       	call   8011bd <_panic>

00800eb8 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800eb8:	f3 0f 1e fb          	endbr32 
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	57                   	push   %edi
  800ec0:	56                   	push   %esi
  800ec1:	53                   	push   %ebx
  800ec2:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  800ec5:	68 d8 0d 80 00       	push   $0x800dd8
  800eca:	e8 38 03 00 00       	call   801207 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800ecf:	b8 07 00 00 00       	mov    $0x7,%eax
  800ed4:	cd 30                	int    $0x30
  800ed6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  800ed9:	83 c4 10             	add    $0x10,%esp
  800edc:	85 c0                	test   %eax,%eax
  800ede:	78 2d                	js     800f0d <fork+0x55>
  800ee0:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800ee2:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  800ee7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eeb:	0f 85 81 00 00 00    	jne    800f72 <fork+0xba>
		thisenv = &envs[ENVX(sys_getenvid())];
  800ef1:	e8 d1 fc ff ff       	call   800bc7 <sys_getenvid>
  800ef6:	25 ff 03 00 00       	and    $0x3ff,%eax
  800efb:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800efe:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f03:	a3 04 20 80 00       	mov    %eax,0x802004
		return 0;
  800f08:	e9 43 01 00 00       	jmp    801050 <fork+0x198>
		panic("sys_exofork: %e", envid);
  800f0d:	50                   	push   %eax
  800f0e:	68 e3 17 80 00       	push   $0x8017e3
  800f13:	68 26 01 00 00       	push   $0x126
  800f18:	68 cb 17 80 00       	push   $0x8017cb
  800f1d:	e8 9b 02 00 00       	call   8011bd <_panic>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  800f22:	c1 e6 0c             	shl    $0xc,%esi
  800f25:	83 ec 0c             	sub    $0xc,%esp
  800f28:	68 05 08 00 00       	push   $0x805
  800f2d:	56                   	push   %esi
  800f2e:	57                   	push   %edi
  800f2f:	56                   	push   %esi
  800f30:	6a 00                	push   $0x0
  800f32:	e8 1d fd ff ff       	call   800c54 <sys_page_map>
  800f37:	83 c4 20             	add    $0x20,%esp
  800f3a:	85 c0                	test   %eax,%eax
  800f3c:	0f 88 a8 00 00 00    	js     800fea <fork+0x132>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  800f42:	83 ec 0c             	sub    $0xc,%esp
  800f45:	68 05 08 00 00       	push   $0x805
  800f4a:	56                   	push   %esi
  800f4b:	6a 00                	push   $0x0
  800f4d:	56                   	push   %esi
  800f4e:	6a 00                	push   $0x0
  800f50:	e8 ff fc ff ff       	call   800c54 <sys_page_map>
  800f55:	83 c4 20             	add    $0x20,%esp
  800f58:	85 c0                	test   %eax,%eax
  800f5a:	0f 88 9f 00 00 00    	js     800fff <fork+0x147>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800f60:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800f66:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  800f6c:	0f 84 a2 00 00 00    	je     801014 <fork+0x15c>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  800f72:	89 d8                	mov    %ebx,%eax
  800f74:	c1 e8 16             	shr    $0x16,%eax
  800f77:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f7e:	a8 01                	test   $0x1,%al
  800f80:	74 de                	je     800f60 <fork+0xa8>
  800f82:	89 de                	mov    %ebx,%esi
  800f84:	c1 ee 0c             	shr    $0xc,%esi
  800f87:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  800f8e:	a8 01                	test   $0x1,%al
  800f90:	74 ce                	je     800f60 <fork+0xa8>
  800f92:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  800f99:	a8 04                	test   $0x4,%al
  800f9b:	74 c3                	je     800f60 <fork+0xa8>
	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  800f9d:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  800fa4:	a8 02                	test   $0x2,%al
  800fa6:	0f 85 76 ff ff ff    	jne    800f22 <fork+0x6a>
  800fac:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  800fb3:	f6 c4 08             	test   $0x8,%ah
  800fb6:	0f 85 66 ff ff ff    	jne    800f22 <fork+0x6a>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  800fbc:	c1 e6 0c             	shl    $0xc,%esi
  800fbf:	83 ec 0c             	sub    $0xc,%esp
  800fc2:	6a 05                	push   $0x5
  800fc4:	56                   	push   %esi
  800fc5:	57                   	push   %edi
  800fc6:	56                   	push   %esi
  800fc7:	6a 00                	push   $0x0
  800fc9:	e8 86 fc ff ff       	call   800c54 <sys_page_map>
  800fce:	83 c4 20             	add    $0x20,%esp
  800fd1:	85 c0                	test   %eax,%eax
  800fd3:	79 8b                	jns    800f60 <fork+0xa8>
		panic("duppage: %e\n", r);
  800fd5:	50                   	push   %eax
  800fd6:	68 f3 17 80 00       	push   $0x8017f3
  800fdb:	68 08 01 00 00       	push   $0x108
  800fe0:	68 cb 17 80 00       	push   $0x8017cb
  800fe5:	e8 d3 01 00 00       	call   8011bd <_panic>
			panic("duppage: %e\n", r);
  800fea:	50                   	push   %eax
  800feb:	68 f3 17 80 00       	push   $0x8017f3
  800ff0:	68 01 01 00 00       	push   $0x101
  800ff5:	68 cb 17 80 00       	push   $0x8017cb
  800ffa:	e8 be 01 00 00       	call   8011bd <_panic>
			panic("duppage: %e\n", r);
  800fff:	50                   	push   %eax
  801000:	68 f3 17 80 00       	push   $0x8017f3
  801005:	68 05 01 00 00       	push   $0x105
  80100a:	68 cb 17 80 00       	push   $0x8017cb
  80100f:	e8 a9 01 00 00       	call   8011bd <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  801014:	83 ec 04             	sub    $0x4,%esp
  801017:	6a 07                	push   $0x7
  801019:	68 00 f0 bf ee       	push   $0xeebff000
  80101e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801021:	e8 e7 fb ff ff       	call   800c0d <sys_page_alloc>
  801026:	83 c4 10             	add    $0x10,%esp
  801029:	85 c0                	test   %eax,%eax
  80102b:	78 2e                	js     80105b <fork+0x1a3>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  80102d:	83 ec 08             	sub    $0x8,%esp
  801030:	68 7a 12 80 00       	push   $0x80127a
  801035:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801038:	57                   	push   %edi
  801039:	e8 e8 fc ff ff       	call   800d26 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80103e:	83 c4 08             	add    $0x8,%esp
  801041:	6a 02                	push   $0x2
  801043:	57                   	push   %edi
  801044:	e8 97 fc ff ff       	call   800ce0 <sys_env_set_status>
  801049:	83 c4 10             	add    $0x10,%esp
  80104c:	85 c0                	test   %eax,%eax
  80104e:	78 20                	js     801070 <fork+0x1b8>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  801050:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801053:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801056:	5b                   	pop    %ebx
  801057:	5e                   	pop    %esi
  801058:	5f                   	pop    %edi
  801059:	5d                   	pop    %ebp
  80105a:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  80105b:	50                   	push   %eax
  80105c:	68 00 18 80 00       	push   $0x801800
  801061:	68 3a 01 00 00       	push   $0x13a
  801066:	68 cb 17 80 00       	push   $0x8017cb
  80106b:	e8 4d 01 00 00       	call   8011bd <_panic>
		panic("sys_env_set_status: %e", r);
  801070:	50                   	push   %eax
  801071:	68 13 18 80 00       	push   $0x801813
  801076:	68 3f 01 00 00       	push   $0x13f
  80107b:	68 cb 17 80 00       	push   $0x8017cb
  801080:	e8 38 01 00 00       	call   8011bd <_panic>

00801085 <sfork>:

// Challenge!
int
sfork(void)
{
  801085:	f3 0f 1e fb          	endbr32 
  801089:	55                   	push   %ebp
  80108a:	89 e5                	mov    %esp,%ebp
  80108c:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80108f:	68 2a 18 80 00       	push   $0x80182a
  801094:	68 48 01 00 00       	push   $0x148
  801099:	68 cb 17 80 00       	push   $0x8017cb
  80109e:	e8 1a 01 00 00       	call   8011bd <_panic>

008010a3 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8010a3:	f3 0f 1e fb          	endbr32 
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	56                   	push   %esi
  8010ab:	53                   	push   %ebx
  8010ac:	8b 75 08             	mov    0x8(%ebp),%esi
  8010af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  8010b5:	85 c0                	test   %eax,%eax
  8010b7:	74 3d                	je     8010f6 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  8010b9:	83 ec 0c             	sub    $0xc,%esp
  8010bc:	50                   	push   %eax
  8010bd:	e8 d1 fc ff ff       	call   800d93 <sys_ipc_recv>
  8010c2:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  8010c5:	85 f6                	test   %esi,%esi
  8010c7:	74 0b                	je     8010d4 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8010c9:	8b 15 04 20 80 00    	mov    0x802004,%edx
  8010cf:	8b 52 74             	mov    0x74(%edx),%edx
  8010d2:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  8010d4:	85 db                	test   %ebx,%ebx
  8010d6:	74 0b                	je     8010e3 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  8010d8:	8b 15 04 20 80 00    	mov    0x802004,%edx
  8010de:	8b 52 78             	mov    0x78(%edx),%edx
  8010e1:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  8010e3:	85 c0                	test   %eax,%eax
  8010e5:	78 21                	js     801108 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  8010e7:	a1 04 20 80 00       	mov    0x802004,%eax
  8010ec:	8b 40 70             	mov    0x70(%eax),%eax
}
  8010ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010f2:	5b                   	pop    %ebx
  8010f3:	5e                   	pop    %esi
  8010f4:	5d                   	pop    %ebp
  8010f5:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  8010f6:	83 ec 0c             	sub    $0xc,%esp
  8010f9:	68 00 00 c0 ee       	push   $0xeec00000
  8010fe:	e8 90 fc ff ff       	call   800d93 <sys_ipc_recv>
  801103:	83 c4 10             	add    $0x10,%esp
  801106:	eb bd                	jmp    8010c5 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  801108:	85 f6                	test   %esi,%esi
  80110a:	74 10                	je     80111c <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  80110c:	85 db                	test   %ebx,%ebx
  80110e:	75 df                	jne    8010ef <ipc_recv+0x4c>
  801110:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801117:	00 00 00 
  80111a:	eb d3                	jmp    8010ef <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  80111c:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801123:	00 00 00 
  801126:	eb e4                	jmp    80110c <ipc_recv+0x69>

00801128 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801128:	f3 0f 1e fb          	endbr32 
  80112c:	55                   	push   %ebp
  80112d:	89 e5                	mov    %esp,%ebp
  80112f:	57                   	push   %edi
  801130:	56                   	push   %esi
  801131:	53                   	push   %ebx
  801132:	83 ec 0c             	sub    $0xc,%esp
  801135:	8b 7d 08             	mov    0x8(%ebp),%edi
  801138:	8b 75 0c             	mov    0xc(%ebp),%esi
  80113b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  80113e:	85 db                	test   %ebx,%ebx
  801140:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801145:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  801148:	ff 75 14             	pushl  0x14(%ebp)
  80114b:	53                   	push   %ebx
  80114c:	56                   	push   %esi
  80114d:	57                   	push   %edi
  80114e:	e8 19 fc ff ff       	call   800d6c <sys_ipc_try_send>
  801153:	83 c4 10             	add    $0x10,%esp
  801156:	85 c0                	test   %eax,%eax
  801158:	79 1e                	jns    801178 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  80115a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80115d:	75 07                	jne    801166 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  80115f:	e8 86 fa ff ff       	call   800bea <sys_yield>
  801164:	eb e2                	jmp    801148 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  801166:	50                   	push   %eax
  801167:	68 40 18 80 00       	push   $0x801840
  80116c:	6a 59                	push   $0x59
  80116e:	68 5b 18 80 00       	push   $0x80185b
  801173:	e8 45 00 00 00       	call   8011bd <_panic>
	}


}
  801178:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80117b:	5b                   	pop    %ebx
  80117c:	5e                   	pop    %esi
  80117d:	5f                   	pop    %edi
  80117e:	5d                   	pop    %ebp
  80117f:	c3                   	ret    

00801180 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801180:	f3 0f 1e fb          	endbr32 
  801184:	55                   	push   %ebp
  801185:	89 e5                	mov    %esp,%ebp
  801187:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80118a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80118f:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801192:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801198:	8b 52 50             	mov    0x50(%edx),%edx
  80119b:	39 ca                	cmp    %ecx,%edx
  80119d:	74 11                	je     8011b0 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80119f:	83 c0 01             	add    $0x1,%eax
  8011a2:	3d 00 04 00 00       	cmp    $0x400,%eax
  8011a7:	75 e6                	jne    80118f <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8011a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8011ae:	eb 0b                	jmp    8011bb <ipc_find_env+0x3b>
			return envs[i].env_id;
  8011b0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8011b3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011b8:	8b 40 48             	mov    0x48(%eax),%eax
}
  8011bb:	5d                   	pop    %ebp
  8011bc:	c3                   	ret    

008011bd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8011bd:	f3 0f 1e fb          	endbr32 
  8011c1:	55                   	push   %ebp
  8011c2:	89 e5                	mov    %esp,%ebp
  8011c4:	56                   	push   %esi
  8011c5:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8011c6:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8011c9:	8b 35 00 20 80 00    	mov    0x802000,%esi
  8011cf:	e8 f3 f9 ff ff       	call   800bc7 <sys_getenvid>
  8011d4:	83 ec 0c             	sub    $0xc,%esp
  8011d7:	ff 75 0c             	pushl  0xc(%ebp)
  8011da:	ff 75 08             	pushl  0x8(%ebp)
  8011dd:	56                   	push   %esi
  8011de:	50                   	push   %eax
  8011df:	68 68 18 80 00       	push   $0x801868
  8011e4:	e8 d8 ef ff ff       	call   8001c1 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8011e9:	83 c4 18             	add    $0x18,%esp
  8011ec:	53                   	push   %ebx
  8011ed:	ff 75 10             	pushl  0x10(%ebp)
  8011f0:	e8 77 ef ff ff       	call   80016c <vcprintf>
	cprintf("\n");
  8011f5:	c7 04 24 59 18 80 00 	movl   $0x801859,(%esp)
  8011fc:	e8 c0 ef ff ff       	call   8001c1 <cprintf>
  801201:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801204:	cc                   	int3   
  801205:	eb fd                	jmp    801204 <_panic+0x47>

00801207 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801207:	f3 0f 1e fb          	endbr32 
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
  80120e:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801211:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  801218:	74 0a                	je     801224 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80121a:	8b 45 08             	mov    0x8(%ebp),%eax
  80121d:	a3 08 20 80 00       	mov    %eax,0x802008
}
  801222:	c9                   	leave  
  801223:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  801224:	83 ec 04             	sub    $0x4,%esp
  801227:	6a 07                	push   $0x7
  801229:	68 00 f0 bf ee       	push   $0xeebff000
  80122e:	6a 00                	push   $0x0
  801230:	e8 d8 f9 ff ff       	call   800c0d <sys_page_alloc>
  801235:	83 c4 10             	add    $0x10,%esp
  801238:	85 c0                	test   %eax,%eax
  80123a:	78 2a                	js     801266 <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  80123c:	83 ec 08             	sub    $0x8,%esp
  80123f:	68 7a 12 80 00       	push   $0x80127a
  801244:	6a 00                	push   $0x0
  801246:	e8 db fa ff ff       	call   800d26 <sys_env_set_pgfault_upcall>
  80124b:	83 c4 10             	add    $0x10,%esp
  80124e:	85 c0                	test   %eax,%eax
  801250:	79 c8                	jns    80121a <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  801252:	83 ec 04             	sub    $0x4,%esp
  801255:	68 b8 18 80 00       	push   $0x8018b8
  80125a:	6a 25                	push   $0x25
  80125c:	68 f0 18 80 00       	push   $0x8018f0
  801261:	e8 57 ff ff ff       	call   8011bd <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  801266:	83 ec 04             	sub    $0x4,%esp
  801269:	68 8c 18 80 00       	push   $0x80188c
  80126e:	6a 22                	push   $0x22
  801270:	68 f0 18 80 00       	push   $0x8018f0
  801275:	e8 43 ff ff ff       	call   8011bd <_panic>

0080127a <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80127a:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80127b:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  801280:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801282:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  801285:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  801289:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  80128d:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  801290:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  801292:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  801296:	83 c4 08             	add    $0x8,%esp
	popal
  801299:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  80129a:	83 c4 04             	add    $0x4,%esp
	popfl
  80129d:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  80129e:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  80129f:	c3                   	ret    

008012a0 <__udivdi3>:
  8012a0:	f3 0f 1e fb          	endbr32 
  8012a4:	55                   	push   %ebp
  8012a5:	57                   	push   %edi
  8012a6:	56                   	push   %esi
  8012a7:	53                   	push   %ebx
  8012a8:	83 ec 1c             	sub    $0x1c,%esp
  8012ab:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8012af:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8012b3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8012b7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8012bb:	85 d2                	test   %edx,%edx
  8012bd:	75 19                	jne    8012d8 <__udivdi3+0x38>
  8012bf:	39 f3                	cmp    %esi,%ebx
  8012c1:	76 4d                	jbe    801310 <__udivdi3+0x70>
  8012c3:	31 ff                	xor    %edi,%edi
  8012c5:	89 e8                	mov    %ebp,%eax
  8012c7:	89 f2                	mov    %esi,%edx
  8012c9:	f7 f3                	div    %ebx
  8012cb:	89 fa                	mov    %edi,%edx
  8012cd:	83 c4 1c             	add    $0x1c,%esp
  8012d0:	5b                   	pop    %ebx
  8012d1:	5e                   	pop    %esi
  8012d2:	5f                   	pop    %edi
  8012d3:	5d                   	pop    %ebp
  8012d4:	c3                   	ret    
  8012d5:	8d 76 00             	lea    0x0(%esi),%esi
  8012d8:	39 f2                	cmp    %esi,%edx
  8012da:	76 14                	jbe    8012f0 <__udivdi3+0x50>
  8012dc:	31 ff                	xor    %edi,%edi
  8012de:	31 c0                	xor    %eax,%eax
  8012e0:	89 fa                	mov    %edi,%edx
  8012e2:	83 c4 1c             	add    $0x1c,%esp
  8012e5:	5b                   	pop    %ebx
  8012e6:	5e                   	pop    %esi
  8012e7:	5f                   	pop    %edi
  8012e8:	5d                   	pop    %ebp
  8012e9:	c3                   	ret    
  8012ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8012f0:	0f bd fa             	bsr    %edx,%edi
  8012f3:	83 f7 1f             	xor    $0x1f,%edi
  8012f6:	75 48                	jne    801340 <__udivdi3+0xa0>
  8012f8:	39 f2                	cmp    %esi,%edx
  8012fa:	72 06                	jb     801302 <__udivdi3+0x62>
  8012fc:	31 c0                	xor    %eax,%eax
  8012fe:	39 eb                	cmp    %ebp,%ebx
  801300:	77 de                	ja     8012e0 <__udivdi3+0x40>
  801302:	b8 01 00 00 00       	mov    $0x1,%eax
  801307:	eb d7                	jmp    8012e0 <__udivdi3+0x40>
  801309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801310:	89 d9                	mov    %ebx,%ecx
  801312:	85 db                	test   %ebx,%ebx
  801314:	75 0b                	jne    801321 <__udivdi3+0x81>
  801316:	b8 01 00 00 00       	mov    $0x1,%eax
  80131b:	31 d2                	xor    %edx,%edx
  80131d:	f7 f3                	div    %ebx
  80131f:	89 c1                	mov    %eax,%ecx
  801321:	31 d2                	xor    %edx,%edx
  801323:	89 f0                	mov    %esi,%eax
  801325:	f7 f1                	div    %ecx
  801327:	89 c6                	mov    %eax,%esi
  801329:	89 e8                	mov    %ebp,%eax
  80132b:	89 f7                	mov    %esi,%edi
  80132d:	f7 f1                	div    %ecx
  80132f:	89 fa                	mov    %edi,%edx
  801331:	83 c4 1c             	add    $0x1c,%esp
  801334:	5b                   	pop    %ebx
  801335:	5e                   	pop    %esi
  801336:	5f                   	pop    %edi
  801337:	5d                   	pop    %ebp
  801338:	c3                   	ret    
  801339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801340:	89 f9                	mov    %edi,%ecx
  801342:	b8 20 00 00 00       	mov    $0x20,%eax
  801347:	29 f8                	sub    %edi,%eax
  801349:	d3 e2                	shl    %cl,%edx
  80134b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80134f:	89 c1                	mov    %eax,%ecx
  801351:	89 da                	mov    %ebx,%edx
  801353:	d3 ea                	shr    %cl,%edx
  801355:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801359:	09 d1                	or     %edx,%ecx
  80135b:	89 f2                	mov    %esi,%edx
  80135d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801361:	89 f9                	mov    %edi,%ecx
  801363:	d3 e3                	shl    %cl,%ebx
  801365:	89 c1                	mov    %eax,%ecx
  801367:	d3 ea                	shr    %cl,%edx
  801369:	89 f9                	mov    %edi,%ecx
  80136b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80136f:	89 eb                	mov    %ebp,%ebx
  801371:	d3 e6                	shl    %cl,%esi
  801373:	89 c1                	mov    %eax,%ecx
  801375:	d3 eb                	shr    %cl,%ebx
  801377:	09 de                	or     %ebx,%esi
  801379:	89 f0                	mov    %esi,%eax
  80137b:	f7 74 24 08          	divl   0x8(%esp)
  80137f:	89 d6                	mov    %edx,%esi
  801381:	89 c3                	mov    %eax,%ebx
  801383:	f7 64 24 0c          	mull   0xc(%esp)
  801387:	39 d6                	cmp    %edx,%esi
  801389:	72 15                	jb     8013a0 <__udivdi3+0x100>
  80138b:	89 f9                	mov    %edi,%ecx
  80138d:	d3 e5                	shl    %cl,%ebp
  80138f:	39 c5                	cmp    %eax,%ebp
  801391:	73 04                	jae    801397 <__udivdi3+0xf7>
  801393:	39 d6                	cmp    %edx,%esi
  801395:	74 09                	je     8013a0 <__udivdi3+0x100>
  801397:	89 d8                	mov    %ebx,%eax
  801399:	31 ff                	xor    %edi,%edi
  80139b:	e9 40 ff ff ff       	jmp    8012e0 <__udivdi3+0x40>
  8013a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8013a3:	31 ff                	xor    %edi,%edi
  8013a5:	e9 36 ff ff ff       	jmp    8012e0 <__udivdi3+0x40>
  8013aa:	66 90                	xchg   %ax,%ax
  8013ac:	66 90                	xchg   %ax,%ax
  8013ae:	66 90                	xchg   %ax,%ax

008013b0 <__umoddi3>:
  8013b0:	f3 0f 1e fb          	endbr32 
  8013b4:	55                   	push   %ebp
  8013b5:	57                   	push   %edi
  8013b6:	56                   	push   %esi
  8013b7:	53                   	push   %ebx
  8013b8:	83 ec 1c             	sub    $0x1c,%esp
  8013bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8013bf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8013c3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8013c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8013cb:	85 c0                	test   %eax,%eax
  8013cd:	75 19                	jne    8013e8 <__umoddi3+0x38>
  8013cf:	39 df                	cmp    %ebx,%edi
  8013d1:	76 5d                	jbe    801430 <__umoddi3+0x80>
  8013d3:	89 f0                	mov    %esi,%eax
  8013d5:	89 da                	mov    %ebx,%edx
  8013d7:	f7 f7                	div    %edi
  8013d9:	89 d0                	mov    %edx,%eax
  8013db:	31 d2                	xor    %edx,%edx
  8013dd:	83 c4 1c             	add    $0x1c,%esp
  8013e0:	5b                   	pop    %ebx
  8013e1:	5e                   	pop    %esi
  8013e2:	5f                   	pop    %edi
  8013e3:	5d                   	pop    %ebp
  8013e4:	c3                   	ret    
  8013e5:	8d 76 00             	lea    0x0(%esi),%esi
  8013e8:	89 f2                	mov    %esi,%edx
  8013ea:	39 d8                	cmp    %ebx,%eax
  8013ec:	76 12                	jbe    801400 <__umoddi3+0x50>
  8013ee:	89 f0                	mov    %esi,%eax
  8013f0:	89 da                	mov    %ebx,%edx
  8013f2:	83 c4 1c             	add    $0x1c,%esp
  8013f5:	5b                   	pop    %ebx
  8013f6:	5e                   	pop    %esi
  8013f7:	5f                   	pop    %edi
  8013f8:	5d                   	pop    %ebp
  8013f9:	c3                   	ret    
  8013fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801400:	0f bd e8             	bsr    %eax,%ebp
  801403:	83 f5 1f             	xor    $0x1f,%ebp
  801406:	75 50                	jne    801458 <__umoddi3+0xa8>
  801408:	39 d8                	cmp    %ebx,%eax
  80140a:	0f 82 e0 00 00 00    	jb     8014f0 <__umoddi3+0x140>
  801410:	89 d9                	mov    %ebx,%ecx
  801412:	39 f7                	cmp    %esi,%edi
  801414:	0f 86 d6 00 00 00    	jbe    8014f0 <__umoddi3+0x140>
  80141a:	89 d0                	mov    %edx,%eax
  80141c:	89 ca                	mov    %ecx,%edx
  80141e:	83 c4 1c             	add    $0x1c,%esp
  801421:	5b                   	pop    %ebx
  801422:	5e                   	pop    %esi
  801423:	5f                   	pop    %edi
  801424:	5d                   	pop    %ebp
  801425:	c3                   	ret    
  801426:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80142d:	8d 76 00             	lea    0x0(%esi),%esi
  801430:	89 fd                	mov    %edi,%ebp
  801432:	85 ff                	test   %edi,%edi
  801434:	75 0b                	jne    801441 <__umoddi3+0x91>
  801436:	b8 01 00 00 00       	mov    $0x1,%eax
  80143b:	31 d2                	xor    %edx,%edx
  80143d:	f7 f7                	div    %edi
  80143f:	89 c5                	mov    %eax,%ebp
  801441:	89 d8                	mov    %ebx,%eax
  801443:	31 d2                	xor    %edx,%edx
  801445:	f7 f5                	div    %ebp
  801447:	89 f0                	mov    %esi,%eax
  801449:	f7 f5                	div    %ebp
  80144b:	89 d0                	mov    %edx,%eax
  80144d:	31 d2                	xor    %edx,%edx
  80144f:	eb 8c                	jmp    8013dd <__umoddi3+0x2d>
  801451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801458:	89 e9                	mov    %ebp,%ecx
  80145a:	ba 20 00 00 00       	mov    $0x20,%edx
  80145f:	29 ea                	sub    %ebp,%edx
  801461:	d3 e0                	shl    %cl,%eax
  801463:	89 44 24 08          	mov    %eax,0x8(%esp)
  801467:	89 d1                	mov    %edx,%ecx
  801469:	89 f8                	mov    %edi,%eax
  80146b:	d3 e8                	shr    %cl,%eax
  80146d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801471:	89 54 24 04          	mov    %edx,0x4(%esp)
  801475:	8b 54 24 04          	mov    0x4(%esp),%edx
  801479:	09 c1                	or     %eax,%ecx
  80147b:	89 d8                	mov    %ebx,%eax
  80147d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801481:	89 e9                	mov    %ebp,%ecx
  801483:	d3 e7                	shl    %cl,%edi
  801485:	89 d1                	mov    %edx,%ecx
  801487:	d3 e8                	shr    %cl,%eax
  801489:	89 e9                	mov    %ebp,%ecx
  80148b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80148f:	d3 e3                	shl    %cl,%ebx
  801491:	89 c7                	mov    %eax,%edi
  801493:	89 d1                	mov    %edx,%ecx
  801495:	89 f0                	mov    %esi,%eax
  801497:	d3 e8                	shr    %cl,%eax
  801499:	89 e9                	mov    %ebp,%ecx
  80149b:	89 fa                	mov    %edi,%edx
  80149d:	d3 e6                	shl    %cl,%esi
  80149f:	09 d8                	or     %ebx,%eax
  8014a1:	f7 74 24 08          	divl   0x8(%esp)
  8014a5:	89 d1                	mov    %edx,%ecx
  8014a7:	89 f3                	mov    %esi,%ebx
  8014a9:	f7 64 24 0c          	mull   0xc(%esp)
  8014ad:	89 c6                	mov    %eax,%esi
  8014af:	89 d7                	mov    %edx,%edi
  8014b1:	39 d1                	cmp    %edx,%ecx
  8014b3:	72 06                	jb     8014bb <__umoddi3+0x10b>
  8014b5:	75 10                	jne    8014c7 <__umoddi3+0x117>
  8014b7:	39 c3                	cmp    %eax,%ebx
  8014b9:	73 0c                	jae    8014c7 <__umoddi3+0x117>
  8014bb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8014bf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8014c3:	89 d7                	mov    %edx,%edi
  8014c5:	89 c6                	mov    %eax,%esi
  8014c7:	89 ca                	mov    %ecx,%edx
  8014c9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8014ce:	29 f3                	sub    %esi,%ebx
  8014d0:	19 fa                	sbb    %edi,%edx
  8014d2:	89 d0                	mov    %edx,%eax
  8014d4:	d3 e0                	shl    %cl,%eax
  8014d6:	89 e9                	mov    %ebp,%ecx
  8014d8:	d3 eb                	shr    %cl,%ebx
  8014da:	d3 ea                	shr    %cl,%edx
  8014dc:	09 d8                	or     %ebx,%eax
  8014de:	83 c4 1c             	add    $0x1c,%esp
  8014e1:	5b                   	pop    %ebx
  8014e2:	5e                   	pop    %esi
  8014e3:	5f                   	pop    %edi
  8014e4:	5d                   	pop    %ebp
  8014e5:	c3                   	ret    
  8014e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8014ed:	8d 76 00             	lea    0x0(%esi),%esi
  8014f0:	29 fe                	sub    %edi,%esi
  8014f2:	19 c3                	sbb    %eax,%ebx
  8014f4:	89 f2                	mov    %esi,%edx
  8014f6:	89 d9                	mov    %ebx,%ecx
  8014f8:	e9 1d ff ff ff       	jmp    80141a <__umoddi3+0x6a>
