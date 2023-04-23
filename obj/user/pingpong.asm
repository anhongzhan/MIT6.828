
obj/user/pingpong.debug:     file format elf32-i386


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
  800040:	e8 70 0f 00 00       	call   800fb5 <fork>
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
  800057:	e8 72 11 00 00       	call   8011ce <ipc_recv>
  80005c:	89 c3                	mov    %eax,%ebx
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  80005e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800061:	e8 69 0b 00 00       	call   800bcf <sys_getenvid>
  800066:	57                   	push   %edi
  800067:	53                   	push   %ebx
  800068:	50                   	push   %eax
  800069:	68 96 28 80 00       	push   $0x802896
  80006e:	e8 56 01 00 00       	call   8001c9 <cprintf>
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
  800086:	e8 c8 11 00 00       	call   801253 <ipc_send>
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
  80009d:	e8 2d 0b 00 00       	call   800bcf <sys_getenvid>
  8000a2:	83 ec 04             	sub    $0x4,%esp
  8000a5:	53                   	push   %ebx
  8000a6:	50                   	push   %eax
  8000a7:	68 80 28 80 00       	push   $0x802880
  8000ac:	e8 18 01 00 00       	call   8001c9 <cprintf>
		ipc_send(who, 0, 0, 0);
  8000b1:	6a 00                	push   $0x0
  8000b3:	6a 00                	push   $0x0
  8000b5:	6a 00                	push   $0x0
  8000b7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000ba:	e8 94 11 00 00       	call   801253 <ipc_send>
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
  8000d3:	e8 f7 0a 00 00       	call   800bcf <sys_getenvid>
  8000d8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000dd:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000e0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000e5:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ea:	85 db                	test   %ebx,%ebx
  8000ec:	7e 07                	jle    8000f5 <libmain+0x31>
		binaryname = argv[0];
  8000ee:	8b 06                	mov    (%esi),%eax
  8000f0:	a3 00 30 80 00       	mov    %eax,0x803000

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
  800115:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800118:	e8 bf 13 00 00       	call   8014dc <close_all>
	sys_env_destroy(0);
  80011d:	83 ec 0c             	sub    $0xc,%esp
  800120:	6a 00                	push   $0x0
  800122:	e8 63 0a 00 00       	call   800b8a <sys_env_destroy>
}
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	c9                   	leave  
  80012b:	c3                   	ret    

0080012c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80012c:	f3 0f 1e fb          	endbr32 
  800130:	55                   	push   %ebp
  800131:	89 e5                	mov    %esp,%ebp
  800133:	53                   	push   %ebx
  800134:	83 ec 04             	sub    $0x4,%esp
  800137:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80013a:	8b 13                	mov    (%ebx),%edx
  80013c:	8d 42 01             	lea    0x1(%edx),%eax
  80013f:	89 03                	mov    %eax,(%ebx)
  800141:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800144:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800148:	3d ff 00 00 00       	cmp    $0xff,%eax
  80014d:	74 09                	je     800158 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80014f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800153:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800156:	c9                   	leave  
  800157:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800158:	83 ec 08             	sub    $0x8,%esp
  80015b:	68 ff 00 00 00       	push   $0xff
  800160:	8d 43 08             	lea    0x8(%ebx),%eax
  800163:	50                   	push   %eax
  800164:	e8 dc 09 00 00       	call   800b45 <sys_cputs>
		b->idx = 0;
  800169:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80016f:	83 c4 10             	add    $0x10,%esp
  800172:	eb db                	jmp    80014f <putch+0x23>

00800174 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800174:	f3 0f 1e fb          	endbr32 
  800178:	55                   	push   %ebp
  800179:	89 e5                	mov    %esp,%ebp
  80017b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800181:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800188:	00 00 00 
	b.cnt = 0;
  80018b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800192:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800195:	ff 75 0c             	pushl  0xc(%ebp)
  800198:	ff 75 08             	pushl  0x8(%ebp)
  80019b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001a1:	50                   	push   %eax
  8001a2:	68 2c 01 80 00       	push   $0x80012c
  8001a7:	e8 20 01 00 00       	call   8002cc <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001ac:	83 c4 08             	add    $0x8,%esp
  8001af:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001b5:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001bb:	50                   	push   %eax
  8001bc:	e8 84 09 00 00       	call   800b45 <sys_cputs>

	return b.cnt;
}
  8001c1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001c7:	c9                   	leave  
  8001c8:	c3                   	ret    

008001c9 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001c9:	f3 0f 1e fb          	endbr32 
  8001cd:	55                   	push   %ebp
  8001ce:	89 e5                	mov    %esp,%ebp
  8001d0:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001d3:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001d6:	50                   	push   %eax
  8001d7:	ff 75 08             	pushl  0x8(%ebp)
  8001da:	e8 95 ff ff ff       	call   800174 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001df:	c9                   	leave  
  8001e0:	c3                   	ret    

008001e1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001e1:	55                   	push   %ebp
  8001e2:	89 e5                	mov    %esp,%ebp
  8001e4:	57                   	push   %edi
  8001e5:	56                   	push   %esi
  8001e6:	53                   	push   %ebx
  8001e7:	83 ec 1c             	sub    $0x1c,%esp
  8001ea:	89 c7                	mov    %eax,%edi
  8001ec:	89 d6                	mov    %edx,%esi
  8001ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001f4:	89 d1                	mov    %edx,%ecx
  8001f6:	89 c2                	mov    %eax,%edx
  8001f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001fb:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800201:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800204:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800207:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80020e:	39 c2                	cmp    %eax,%edx
  800210:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800213:	72 3e                	jb     800253 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800215:	83 ec 0c             	sub    $0xc,%esp
  800218:	ff 75 18             	pushl  0x18(%ebp)
  80021b:	83 eb 01             	sub    $0x1,%ebx
  80021e:	53                   	push   %ebx
  80021f:	50                   	push   %eax
  800220:	83 ec 08             	sub    $0x8,%esp
  800223:	ff 75 e4             	pushl  -0x1c(%ebp)
  800226:	ff 75 e0             	pushl  -0x20(%ebp)
  800229:	ff 75 dc             	pushl  -0x24(%ebp)
  80022c:	ff 75 d8             	pushl  -0x28(%ebp)
  80022f:	e8 dc 23 00 00       	call   802610 <__udivdi3>
  800234:	83 c4 18             	add    $0x18,%esp
  800237:	52                   	push   %edx
  800238:	50                   	push   %eax
  800239:	89 f2                	mov    %esi,%edx
  80023b:	89 f8                	mov    %edi,%eax
  80023d:	e8 9f ff ff ff       	call   8001e1 <printnum>
  800242:	83 c4 20             	add    $0x20,%esp
  800245:	eb 13                	jmp    80025a <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800247:	83 ec 08             	sub    $0x8,%esp
  80024a:	56                   	push   %esi
  80024b:	ff 75 18             	pushl  0x18(%ebp)
  80024e:	ff d7                	call   *%edi
  800250:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800253:	83 eb 01             	sub    $0x1,%ebx
  800256:	85 db                	test   %ebx,%ebx
  800258:	7f ed                	jg     800247 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	56                   	push   %esi
  80025e:	83 ec 04             	sub    $0x4,%esp
  800261:	ff 75 e4             	pushl  -0x1c(%ebp)
  800264:	ff 75 e0             	pushl  -0x20(%ebp)
  800267:	ff 75 dc             	pushl  -0x24(%ebp)
  80026a:	ff 75 d8             	pushl  -0x28(%ebp)
  80026d:	e8 ae 24 00 00       	call   802720 <__umoddi3>
  800272:	83 c4 14             	add    $0x14,%esp
  800275:	0f be 80 b3 28 80 00 	movsbl 0x8028b3(%eax),%eax
  80027c:	50                   	push   %eax
  80027d:	ff d7                	call   *%edi
}
  80027f:	83 c4 10             	add    $0x10,%esp
  800282:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800285:	5b                   	pop    %ebx
  800286:	5e                   	pop    %esi
  800287:	5f                   	pop    %edi
  800288:	5d                   	pop    %ebp
  800289:	c3                   	ret    

0080028a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80028a:	f3 0f 1e fb          	endbr32 
  80028e:	55                   	push   %ebp
  80028f:	89 e5                	mov    %esp,%ebp
  800291:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800294:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800298:	8b 10                	mov    (%eax),%edx
  80029a:	3b 50 04             	cmp    0x4(%eax),%edx
  80029d:	73 0a                	jae    8002a9 <sprintputch+0x1f>
		*b->buf++ = ch;
  80029f:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002a2:	89 08                	mov    %ecx,(%eax)
  8002a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a7:	88 02                	mov    %al,(%edx)
}
  8002a9:	5d                   	pop    %ebp
  8002aa:	c3                   	ret    

008002ab <printfmt>:
{
  8002ab:	f3 0f 1e fb          	endbr32 
  8002af:	55                   	push   %ebp
  8002b0:	89 e5                	mov    %esp,%ebp
  8002b2:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002b5:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002b8:	50                   	push   %eax
  8002b9:	ff 75 10             	pushl  0x10(%ebp)
  8002bc:	ff 75 0c             	pushl  0xc(%ebp)
  8002bf:	ff 75 08             	pushl  0x8(%ebp)
  8002c2:	e8 05 00 00 00       	call   8002cc <vprintfmt>
}
  8002c7:	83 c4 10             	add    $0x10,%esp
  8002ca:	c9                   	leave  
  8002cb:	c3                   	ret    

008002cc <vprintfmt>:
{
  8002cc:	f3 0f 1e fb          	endbr32 
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	57                   	push   %edi
  8002d4:	56                   	push   %esi
  8002d5:	53                   	push   %ebx
  8002d6:	83 ec 3c             	sub    $0x3c,%esp
  8002d9:	8b 75 08             	mov    0x8(%ebp),%esi
  8002dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002df:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002e2:	e9 8e 03 00 00       	jmp    800675 <vprintfmt+0x3a9>
		padc = ' ';
  8002e7:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002eb:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002f2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002f9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800300:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800305:	8d 47 01             	lea    0x1(%edi),%eax
  800308:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80030b:	0f b6 17             	movzbl (%edi),%edx
  80030e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800311:	3c 55                	cmp    $0x55,%al
  800313:	0f 87 df 03 00 00    	ja     8006f8 <vprintfmt+0x42c>
  800319:	0f b6 c0             	movzbl %al,%eax
  80031c:	3e ff 24 85 00 2a 80 	notrack jmp *0x802a00(,%eax,4)
  800323:	00 
  800324:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800327:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80032b:	eb d8                	jmp    800305 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80032d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800330:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800334:	eb cf                	jmp    800305 <vprintfmt+0x39>
  800336:	0f b6 d2             	movzbl %dl,%edx
  800339:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80033c:	b8 00 00 00 00       	mov    $0x0,%eax
  800341:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800344:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800347:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80034b:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80034e:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800351:	83 f9 09             	cmp    $0x9,%ecx
  800354:	77 55                	ja     8003ab <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800356:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800359:	eb e9                	jmp    800344 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80035b:	8b 45 14             	mov    0x14(%ebp),%eax
  80035e:	8b 00                	mov    (%eax),%eax
  800360:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800363:	8b 45 14             	mov    0x14(%ebp),%eax
  800366:	8d 40 04             	lea    0x4(%eax),%eax
  800369:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80036c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80036f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800373:	79 90                	jns    800305 <vprintfmt+0x39>
				width = precision, precision = -1;
  800375:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800378:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80037b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800382:	eb 81                	jmp    800305 <vprintfmt+0x39>
  800384:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800387:	85 c0                	test   %eax,%eax
  800389:	ba 00 00 00 00       	mov    $0x0,%edx
  80038e:	0f 49 d0             	cmovns %eax,%edx
  800391:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800394:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800397:	e9 69 ff ff ff       	jmp    800305 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80039c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80039f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003a6:	e9 5a ff ff ff       	jmp    800305 <vprintfmt+0x39>
  8003ab:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003b1:	eb bc                	jmp    80036f <vprintfmt+0xa3>
			lflag++;
  8003b3:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003b6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003b9:	e9 47 ff ff ff       	jmp    800305 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8003be:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c1:	8d 78 04             	lea    0x4(%eax),%edi
  8003c4:	83 ec 08             	sub    $0x8,%esp
  8003c7:	53                   	push   %ebx
  8003c8:	ff 30                	pushl  (%eax)
  8003ca:	ff d6                	call   *%esi
			break;
  8003cc:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003cf:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003d2:	e9 9b 02 00 00       	jmp    800672 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8003d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003da:	8d 78 04             	lea    0x4(%eax),%edi
  8003dd:	8b 00                	mov    (%eax),%eax
  8003df:	99                   	cltd   
  8003e0:	31 d0                	xor    %edx,%eax
  8003e2:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003e4:	83 f8 0f             	cmp    $0xf,%eax
  8003e7:	7f 23                	jg     80040c <vprintfmt+0x140>
  8003e9:	8b 14 85 60 2b 80 00 	mov    0x802b60(,%eax,4),%edx
  8003f0:	85 d2                	test   %edx,%edx
  8003f2:	74 18                	je     80040c <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8003f4:	52                   	push   %edx
  8003f5:	68 49 2d 80 00       	push   $0x802d49
  8003fa:	53                   	push   %ebx
  8003fb:	56                   	push   %esi
  8003fc:	e8 aa fe ff ff       	call   8002ab <printfmt>
  800401:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800404:	89 7d 14             	mov    %edi,0x14(%ebp)
  800407:	e9 66 02 00 00       	jmp    800672 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80040c:	50                   	push   %eax
  80040d:	68 cb 28 80 00       	push   $0x8028cb
  800412:	53                   	push   %ebx
  800413:	56                   	push   %esi
  800414:	e8 92 fe ff ff       	call   8002ab <printfmt>
  800419:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80041c:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80041f:	e9 4e 02 00 00       	jmp    800672 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800424:	8b 45 14             	mov    0x14(%ebp),%eax
  800427:	83 c0 04             	add    $0x4,%eax
  80042a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80042d:	8b 45 14             	mov    0x14(%ebp),%eax
  800430:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800432:	85 d2                	test   %edx,%edx
  800434:	b8 c4 28 80 00       	mov    $0x8028c4,%eax
  800439:	0f 45 c2             	cmovne %edx,%eax
  80043c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80043f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800443:	7e 06                	jle    80044b <vprintfmt+0x17f>
  800445:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800449:	75 0d                	jne    800458 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80044b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80044e:	89 c7                	mov    %eax,%edi
  800450:	03 45 e0             	add    -0x20(%ebp),%eax
  800453:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800456:	eb 55                	jmp    8004ad <vprintfmt+0x1e1>
  800458:	83 ec 08             	sub    $0x8,%esp
  80045b:	ff 75 d8             	pushl  -0x28(%ebp)
  80045e:	ff 75 cc             	pushl  -0x34(%ebp)
  800461:	e8 46 03 00 00       	call   8007ac <strnlen>
  800466:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800469:	29 c2                	sub    %eax,%edx
  80046b:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80046e:	83 c4 10             	add    $0x10,%esp
  800471:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800473:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800477:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80047a:	85 ff                	test   %edi,%edi
  80047c:	7e 11                	jle    80048f <vprintfmt+0x1c3>
					putch(padc, putdat);
  80047e:	83 ec 08             	sub    $0x8,%esp
  800481:	53                   	push   %ebx
  800482:	ff 75 e0             	pushl  -0x20(%ebp)
  800485:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800487:	83 ef 01             	sub    $0x1,%edi
  80048a:	83 c4 10             	add    $0x10,%esp
  80048d:	eb eb                	jmp    80047a <vprintfmt+0x1ae>
  80048f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800492:	85 d2                	test   %edx,%edx
  800494:	b8 00 00 00 00       	mov    $0x0,%eax
  800499:	0f 49 c2             	cmovns %edx,%eax
  80049c:	29 c2                	sub    %eax,%edx
  80049e:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004a1:	eb a8                	jmp    80044b <vprintfmt+0x17f>
					putch(ch, putdat);
  8004a3:	83 ec 08             	sub    $0x8,%esp
  8004a6:	53                   	push   %ebx
  8004a7:	52                   	push   %edx
  8004a8:	ff d6                	call   *%esi
  8004aa:	83 c4 10             	add    $0x10,%esp
  8004ad:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004b0:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004b2:	83 c7 01             	add    $0x1,%edi
  8004b5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004b9:	0f be d0             	movsbl %al,%edx
  8004bc:	85 d2                	test   %edx,%edx
  8004be:	74 4b                	je     80050b <vprintfmt+0x23f>
  8004c0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004c4:	78 06                	js     8004cc <vprintfmt+0x200>
  8004c6:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004ca:	78 1e                	js     8004ea <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004cc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004d0:	74 d1                	je     8004a3 <vprintfmt+0x1d7>
  8004d2:	0f be c0             	movsbl %al,%eax
  8004d5:	83 e8 20             	sub    $0x20,%eax
  8004d8:	83 f8 5e             	cmp    $0x5e,%eax
  8004db:	76 c6                	jbe    8004a3 <vprintfmt+0x1d7>
					putch('?', putdat);
  8004dd:	83 ec 08             	sub    $0x8,%esp
  8004e0:	53                   	push   %ebx
  8004e1:	6a 3f                	push   $0x3f
  8004e3:	ff d6                	call   *%esi
  8004e5:	83 c4 10             	add    $0x10,%esp
  8004e8:	eb c3                	jmp    8004ad <vprintfmt+0x1e1>
  8004ea:	89 cf                	mov    %ecx,%edi
  8004ec:	eb 0e                	jmp    8004fc <vprintfmt+0x230>
				putch(' ', putdat);
  8004ee:	83 ec 08             	sub    $0x8,%esp
  8004f1:	53                   	push   %ebx
  8004f2:	6a 20                	push   $0x20
  8004f4:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004f6:	83 ef 01             	sub    $0x1,%edi
  8004f9:	83 c4 10             	add    $0x10,%esp
  8004fc:	85 ff                	test   %edi,%edi
  8004fe:	7f ee                	jg     8004ee <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800500:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800503:	89 45 14             	mov    %eax,0x14(%ebp)
  800506:	e9 67 01 00 00       	jmp    800672 <vprintfmt+0x3a6>
  80050b:	89 cf                	mov    %ecx,%edi
  80050d:	eb ed                	jmp    8004fc <vprintfmt+0x230>
	if (lflag >= 2)
  80050f:	83 f9 01             	cmp    $0x1,%ecx
  800512:	7f 1b                	jg     80052f <vprintfmt+0x263>
	else if (lflag)
  800514:	85 c9                	test   %ecx,%ecx
  800516:	74 63                	je     80057b <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800518:	8b 45 14             	mov    0x14(%ebp),%eax
  80051b:	8b 00                	mov    (%eax),%eax
  80051d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800520:	99                   	cltd   
  800521:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800524:	8b 45 14             	mov    0x14(%ebp),%eax
  800527:	8d 40 04             	lea    0x4(%eax),%eax
  80052a:	89 45 14             	mov    %eax,0x14(%ebp)
  80052d:	eb 17                	jmp    800546 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  80052f:	8b 45 14             	mov    0x14(%ebp),%eax
  800532:	8b 50 04             	mov    0x4(%eax),%edx
  800535:	8b 00                	mov    (%eax),%eax
  800537:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80053a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80053d:	8b 45 14             	mov    0x14(%ebp),%eax
  800540:	8d 40 08             	lea    0x8(%eax),%eax
  800543:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800546:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800549:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80054c:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800551:	85 c9                	test   %ecx,%ecx
  800553:	0f 89 ff 00 00 00    	jns    800658 <vprintfmt+0x38c>
				putch('-', putdat);
  800559:	83 ec 08             	sub    $0x8,%esp
  80055c:	53                   	push   %ebx
  80055d:	6a 2d                	push   $0x2d
  80055f:	ff d6                	call   *%esi
				num = -(long long) num;
  800561:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800564:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800567:	f7 da                	neg    %edx
  800569:	83 d1 00             	adc    $0x0,%ecx
  80056c:	f7 d9                	neg    %ecx
  80056e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800571:	b8 0a 00 00 00       	mov    $0xa,%eax
  800576:	e9 dd 00 00 00       	jmp    800658 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  80057b:	8b 45 14             	mov    0x14(%ebp),%eax
  80057e:	8b 00                	mov    (%eax),%eax
  800580:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800583:	99                   	cltd   
  800584:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800587:	8b 45 14             	mov    0x14(%ebp),%eax
  80058a:	8d 40 04             	lea    0x4(%eax),%eax
  80058d:	89 45 14             	mov    %eax,0x14(%ebp)
  800590:	eb b4                	jmp    800546 <vprintfmt+0x27a>
	if (lflag >= 2)
  800592:	83 f9 01             	cmp    $0x1,%ecx
  800595:	7f 1e                	jg     8005b5 <vprintfmt+0x2e9>
	else if (lflag)
  800597:	85 c9                	test   %ecx,%ecx
  800599:	74 32                	je     8005cd <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  80059b:	8b 45 14             	mov    0x14(%ebp),%eax
  80059e:	8b 10                	mov    (%eax),%edx
  8005a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005a5:	8d 40 04             	lea    0x4(%eax),%eax
  8005a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ab:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8005b0:	e9 a3 00 00 00       	jmp    800658 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b8:	8b 10                	mov    (%eax),%edx
  8005ba:	8b 48 04             	mov    0x4(%eax),%ecx
  8005bd:	8d 40 08             	lea    0x8(%eax),%eax
  8005c0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005c3:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8005c8:	e9 8b 00 00 00       	jmp    800658 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d0:	8b 10                	mov    (%eax),%edx
  8005d2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005d7:	8d 40 04             	lea    0x4(%eax),%eax
  8005da:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005dd:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8005e2:	eb 74                	jmp    800658 <vprintfmt+0x38c>
	if (lflag >= 2)
  8005e4:	83 f9 01             	cmp    $0x1,%ecx
  8005e7:	7f 1b                	jg     800604 <vprintfmt+0x338>
	else if (lflag)
  8005e9:	85 c9                	test   %ecx,%ecx
  8005eb:	74 2c                	je     800619 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8005ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f0:	8b 10                	mov    (%eax),%edx
  8005f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005f7:	8d 40 04             	lea    0x4(%eax),%eax
  8005fa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005fd:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800602:	eb 54                	jmp    800658 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800604:	8b 45 14             	mov    0x14(%ebp),%eax
  800607:	8b 10                	mov    (%eax),%edx
  800609:	8b 48 04             	mov    0x4(%eax),%ecx
  80060c:	8d 40 08             	lea    0x8(%eax),%eax
  80060f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800612:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800617:	eb 3f                	jmp    800658 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800619:	8b 45 14             	mov    0x14(%ebp),%eax
  80061c:	8b 10                	mov    (%eax),%edx
  80061e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800623:	8d 40 04             	lea    0x4(%eax),%eax
  800626:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800629:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  80062e:	eb 28                	jmp    800658 <vprintfmt+0x38c>
			putch('0', putdat);
  800630:	83 ec 08             	sub    $0x8,%esp
  800633:	53                   	push   %ebx
  800634:	6a 30                	push   $0x30
  800636:	ff d6                	call   *%esi
			putch('x', putdat);
  800638:	83 c4 08             	add    $0x8,%esp
  80063b:	53                   	push   %ebx
  80063c:	6a 78                	push   $0x78
  80063e:	ff d6                	call   *%esi
			num = (unsigned long long)
  800640:	8b 45 14             	mov    0x14(%ebp),%eax
  800643:	8b 10                	mov    (%eax),%edx
  800645:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80064a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80064d:	8d 40 04             	lea    0x4(%eax),%eax
  800650:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800653:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800658:	83 ec 0c             	sub    $0xc,%esp
  80065b:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80065f:	57                   	push   %edi
  800660:	ff 75 e0             	pushl  -0x20(%ebp)
  800663:	50                   	push   %eax
  800664:	51                   	push   %ecx
  800665:	52                   	push   %edx
  800666:	89 da                	mov    %ebx,%edx
  800668:	89 f0                	mov    %esi,%eax
  80066a:	e8 72 fb ff ff       	call   8001e1 <printnum>
			break;
  80066f:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800672:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800675:	83 c7 01             	add    $0x1,%edi
  800678:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80067c:	83 f8 25             	cmp    $0x25,%eax
  80067f:	0f 84 62 fc ff ff    	je     8002e7 <vprintfmt+0x1b>
			if (ch == '\0')
  800685:	85 c0                	test   %eax,%eax
  800687:	0f 84 8b 00 00 00    	je     800718 <vprintfmt+0x44c>
			putch(ch, putdat);
  80068d:	83 ec 08             	sub    $0x8,%esp
  800690:	53                   	push   %ebx
  800691:	50                   	push   %eax
  800692:	ff d6                	call   *%esi
  800694:	83 c4 10             	add    $0x10,%esp
  800697:	eb dc                	jmp    800675 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800699:	83 f9 01             	cmp    $0x1,%ecx
  80069c:	7f 1b                	jg     8006b9 <vprintfmt+0x3ed>
	else if (lflag)
  80069e:	85 c9                	test   %ecx,%ecx
  8006a0:	74 2c                	je     8006ce <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8006a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a5:	8b 10                	mov    (%eax),%edx
  8006a7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ac:	8d 40 04             	lea    0x4(%eax),%eax
  8006af:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b2:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8006b7:	eb 9f                	jmp    800658 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8006b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bc:	8b 10                	mov    (%eax),%edx
  8006be:	8b 48 04             	mov    0x4(%eax),%ecx
  8006c1:	8d 40 08             	lea    0x8(%eax),%eax
  8006c4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006c7:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8006cc:	eb 8a                	jmp    800658 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d1:	8b 10                	mov    (%eax),%edx
  8006d3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006d8:	8d 40 04             	lea    0x4(%eax),%eax
  8006db:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006de:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8006e3:	e9 70 ff ff ff       	jmp    800658 <vprintfmt+0x38c>
			putch(ch, putdat);
  8006e8:	83 ec 08             	sub    $0x8,%esp
  8006eb:	53                   	push   %ebx
  8006ec:	6a 25                	push   $0x25
  8006ee:	ff d6                	call   *%esi
			break;
  8006f0:	83 c4 10             	add    $0x10,%esp
  8006f3:	e9 7a ff ff ff       	jmp    800672 <vprintfmt+0x3a6>
			putch('%', putdat);
  8006f8:	83 ec 08             	sub    $0x8,%esp
  8006fb:	53                   	push   %ebx
  8006fc:	6a 25                	push   $0x25
  8006fe:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800700:	83 c4 10             	add    $0x10,%esp
  800703:	89 f8                	mov    %edi,%eax
  800705:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800709:	74 05                	je     800710 <vprintfmt+0x444>
  80070b:	83 e8 01             	sub    $0x1,%eax
  80070e:	eb f5                	jmp    800705 <vprintfmt+0x439>
  800710:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800713:	e9 5a ff ff ff       	jmp    800672 <vprintfmt+0x3a6>
}
  800718:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80071b:	5b                   	pop    %ebx
  80071c:	5e                   	pop    %esi
  80071d:	5f                   	pop    %edi
  80071e:	5d                   	pop    %ebp
  80071f:	c3                   	ret    

00800720 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800720:	f3 0f 1e fb          	endbr32 
  800724:	55                   	push   %ebp
  800725:	89 e5                	mov    %esp,%ebp
  800727:	83 ec 18             	sub    $0x18,%esp
  80072a:	8b 45 08             	mov    0x8(%ebp),%eax
  80072d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800730:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800733:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800737:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80073a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800741:	85 c0                	test   %eax,%eax
  800743:	74 26                	je     80076b <vsnprintf+0x4b>
  800745:	85 d2                	test   %edx,%edx
  800747:	7e 22                	jle    80076b <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800749:	ff 75 14             	pushl  0x14(%ebp)
  80074c:	ff 75 10             	pushl  0x10(%ebp)
  80074f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800752:	50                   	push   %eax
  800753:	68 8a 02 80 00       	push   $0x80028a
  800758:	e8 6f fb ff ff       	call   8002cc <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80075d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800760:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800766:	83 c4 10             	add    $0x10,%esp
}
  800769:	c9                   	leave  
  80076a:	c3                   	ret    
		return -E_INVAL;
  80076b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800770:	eb f7                	jmp    800769 <vsnprintf+0x49>

00800772 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800772:	f3 0f 1e fb          	endbr32 
  800776:	55                   	push   %ebp
  800777:	89 e5                	mov    %esp,%ebp
  800779:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80077c:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80077f:	50                   	push   %eax
  800780:	ff 75 10             	pushl  0x10(%ebp)
  800783:	ff 75 0c             	pushl  0xc(%ebp)
  800786:	ff 75 08             	pushl  0x8(%ebp)
  800789:	e8 92 ff ff ff       	call   800720 <vsnprintf>
	va_end(ap);

	return rc;
}
  80078e:	c9                   	leave  
  80078f:	c3                   	ret    

00800790 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800790:	f3 0f 1e fb          	endbr32 
  800794:	55                   	push   %ebp
  800795:	89 e5                	mov    %esp,%ebp
  800797:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80079a:	b8 00 00 00 00       	mov    $0x0,%eax
  80079f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007a3:	74 05                	je     8007aa <strlen+0x1a>
		n++;
  8007a5:	83 c0 01             	add    $0x1,%eax
  8007a8:	eb f5                	jmp    80079f <strlen+0xf>
	return n;
}
  8007aa:	5d                   	pop    %ebp
  8007ab:	c3                   	ret    

008007ac <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007ac:	f3 0f 1e fb          	endbr32 
  8007b0:	55                   	push   %ebp
  8007b1:	89 e5                	mov    %esp,%ebp
  8007b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007b6:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8007be:	39 d0                	cmp    %edx,%eax
  8007c0:	74 0d                	je     8007cf <strnlen+0x23>
  8007c2:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007c6:	74 05                	je     8007cd <strnlen+0x21>
		n++;
  8007c8:	83 c0 01             	add    $0x1,%eax
  8007cb:	eb f1                	jmp    8007be <strnlen+0x12>
  8007cd:	89 c2                	mov    %eax,%edx
	return n;
}
  8007cf:	89 d0                	mov    %edx,%eax
  8007d1:	5d                   	pop    %ebp
  8007d2:	c3                   	ret    

008007d3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007d3:	f3 0f 1e fb          	endbr32 
  8007d7:	55                   	push   %ebp
  8007d8:	89 e5                	mov    %esp,%ebp
  8007da:	53                   	push   %ebx
  8007db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007de:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e6:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8007ea:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8007ed:	83 c0 01             	add    $0x1,%eax
  8007f0:	84 d2                	test   %dl,%dl
  8007f2:	75 f2                	jne    8007e6 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8007f4:	89 c8                	mov    %ecx,%eax
  8007f6:	5b                   	pop    %ebx
  8007f7:	5d                   	pop    %ebp
  8007f8:	c3                   	ret    

008007f9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007f9:	f3 0f 1e fb          	endbr32 
  8007fd:	55                   	push   %ebp
  8007fe:	89 e5                	mov    %esp,%ebp
  800800:	53                   	push   %ebx
  800801:	83 ec 10             	sub    $0x10,%esp
  800804:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800807:	53                   	push   %ebx
  800808:	e8 83 ff ff ff       	call   800790 <strlen>
  80080d:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800810:	ff 75 0c             	pushl  0xc(%ebp)
  800813:	01 d8                	add    %ebx,%eax
  800815:	50                   	push   %eax
  800816:	e8 b8 ff ff ff       	call   8007d3 <strcpy>
	return dst;
}
  80081b:	89 d8                	mov    %ebx,%eax
  80081d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800820:	c9                   	leave  
  800821:	c3                   	ret    

00800822 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800822:	f3 0f 1e fb          	endbr32 
  800826:	55                   	push   %ebp
  800827:	89 e5                	mov    %esp,%ebp
  800829:	56                   	push   %esi
  80082a:	53                   	push   %ebx
  80082b:	8b 75 08             	mov    0x8(%ebp),%esi
  80082e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800831:	89 f3                	mov    %esi,%ebx
  800833:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800836:	89 f0                	mov    %esi,%eax
  800838:	39 d8                	cmp    %ebx,%eax
  80083a:	74 11                	je     80084d <strncpy+0x2b>
		*dst++ = *src;
  80083c:	83 c0 01             	add    $0x1,%eax
  80083f:	0f b6 0a             	movzbl (%edx),%ecx
  800842:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800845:	80 f9 01             	cmp    $0x1,%cl
  800848:	83 da ff             	sbb    $0xffffffff,%edx
  80084b:	eb eb                	jmp    800838 <strncpy+0x16>
	}
	return ret;
}
  80084d:	89 f0                	mov    %esi,%eax
  80084f:	5b                   	pop    %ebx
  800850:	5e                   	pop    %esi
  800851:	5d                   	pop    %ebp
  800852:	c3                   	ret    

00800853 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800853:	f3 0f 1e fb          	endbr32 
  800857:	55                   	push   %ebp
  800858:	89 e5                	mov    %esp,%ebp
  80085a:	56                   	push   %esi
  80085b:	53                   	push   %ebx
  80085c:	8b 75 08             	mov    0x8(%ebp),%esi
  80085f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800862:	8b 55 10             	mov    0x10(%ebp),%edx
  800865:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800867:	85 d2                	test   %edx,%edx
  800869:	74 21                	je     80088c <strlcpy+0x39>
  80086b:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80086f:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800871:	39 c2                	cmp    %eax,%edx
  800873:	74 14                	je     800889 <strlcpy+0x36>
  800875:	0f b6 19             	movzbl (%ecx),%ebx
  800878:	84 db                	test   %bl,%bl
  80087a:	74 0b                	je     800887 <strlcpy+0x34>
			*dst++ = *src++;
  80087c:	83 c1 01             	add    $0x1,%ecx
  80087f:	83 c2 01             	add    $0x1,%edx
  800882:	88 5a ff             	mov    %bl,-0x1(%edx)
  800885:	eb ea                	jmp    800871 <strlcpy+0x1e>
  800887:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800889:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80088c:	29 f0                	sub    %esi,%eax
}
  80088e:	5b                   	pop    %ebx
  80088f:	5e                   	pop    %esi
  800890:	5d                   	pop    %ebp
  800891:	c3                   	ret    

00800892 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800892:	f3 0f 1e fb          	endbr32 
  800896:	55                   	push   %ebp
  800897:	89 e5                	mov    %esp,%ebp
  800899:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80089c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80089f:	0f b6 01             	movzbl (%ecx),%eax
  8008a2:	84 c0                	test   %al,%al
  8008a4:	74 0c                	je     8008b2 <strcmp+0x20>
  8008a6:	3a 02                	cmp    (%edx),%al
  8008a8:	75 08                	jne    8008b2 <strcmp+0x20>
		p++, q++;
  8008aa:	83 c1 01             	add    $0x1,%ecx
  8008ad:	83 c2 01             	add    $0x1,%edx
  8008b0:	eb ed                	jmp    80089f <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008b2:	0f b6 c0             	movzbl %al,%eax
  8008b5:	0f b6 12             	movzbl (%edx),%edx
  8008b8:	29 d0                	sub    %edx,%eax
}
  8008ba:	5d                   	pop    %ebp
  8008bb:	c3                   	ret    

008008bc <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008bc:	f3 0f 1e fb          	endbr32 
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	53                   	push   %ebx
  8008c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ca:	89 c3                	mov    %eax,%ebx
  8008cc:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008cf:	eb 06                	jmp    8008d7 <strncmp+0x1b>
		n--, p++, q++;
  8008d1:	83 c0 01             	add    $0x1,%eax
  8008d4:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008d7:	39 d8                	cmp    %ebx,%eax
  8008d9:	74 16                	je     8008f1 <strncmp+0x35>
  8008db:	0f b6 08             	movzbl (%eax),%ecx
  8008de:	84 c9                	test   %cl,%cl
  8008e0:	74 04                	je     8008e6 <strncmp+0x2a>
  8008e2:	3a 0a                	cmp    (%edx),%cl
  8008e4:	74 eb                	je     8008d1 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008e6:	0f b6 00             	movzbl (%eax),%eax
  8008e9:	0f b6 12             	movzbl (%edx),%edx
  8008ec:	29 d0                	sub    %edx,%eax
}
  8008ee:	5b                   	pop    %ebx
  8008ef:	5d                   	pop    %ebp
  8008f0:	c3                   	ret    
		return 0;
  8008f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f6:	eb f6                	jmp    8008ee <strncmp+0x32>

008008f8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008f8:	f3 0f 1e fb          	endbr32 
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
  8008ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800902:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800906:	0f b6 10             	movzbl (%eax),%edx
  800909:	84 d2                	test   %dl,%dl
  80090b:	74 09                	je     800916 <strchr+0x1e>
		if (*s == c)
  80090d:	38 ca                	cmp    %cl,%dl
  80090f:	74 0a                	je     80091b <strchr+0x23>
	for (; *s; s++)
  800911:	83 c0 01             	add    $0x1,%eax
  800914:	eb f0                	jmp    800906 <strchr+0xe>
			return (char *) s;
	return 0;
  800916:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80091b:	5d                   	pop    %ebp
  80091c:	c3                   	ret    

0080091d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80091d:	f3 0f 1e fb          	endbr32 
  800921:	55                   	push   %ebp
  800922:	89 e5                	mov    %esp,%ebp
  800924:	8b 45 08             	mov    0x8(%ebp),%eax
  800927:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80092b:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80092e:	38 ca                	cmp    %cl,%dl
  800930:	74 09                	je     80093b <strfind+0x1e>
  800932:	84 d2                	test   %dl,%dl
  800934:	74 05                	je     80093b <strfind+0x1e>
	for (; *s; s++)
  800936:	83 c0 01             	add    $0x1,%eax
  800939:	eb f0                	jmp    80092b <strfind+0xe>
			break;
	return (char *) s;
}
  80093b:	5d                   	pop    %ebp
  80093c:	c3                   	ret    

0080093d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80093d:	f3 0f 1e fb          	endbr32 
  800941:	55                   	push   %ebp
  800942:	89 e5                	mov    %esp,%ebp
  800944:	57                   	push   %edi
  800945:	56                   	push   %esi
  800946:	53                   	push   %ebx
  800947:	8b 7d 08             	mov    0x8(%ebp),%edi
  80094a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80094d:	85 c9                	test   %ecx,%ecx
  80094f:	74 31                	je     800982 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800951:	89 f8                	mov    %edi,%eax
  800953:	09 c8                	or     %ecx,%eax
  800955:	a8 03                	test   $0x3,%al
  800957:	75 23                	jne    80097c <memset+0x3f>
		c &= 0xFF;
  800959:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80095d:	89 d3                	mov    %edx,%ebx
  80095f:	c1 e3 08             	shl    $0x8,%ebx
  800962:	89 d0                	mov    %edx,%eax
  800964:	c1 e0 18             	shl    $0x18,%eax
  800967:	89 d6                	mov    %edx,%esi
  800969:	c1 e6 10             	shl    $0x10,%esi
  80096c:	09 f0                	or     %esi,%eax
  80096e:	09 c2                	or     %eax,%edx
  800970:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800972:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800975:	89 d0                	mov    %edx,%eax
  800977:	fc                   	cld    
  800978:	f3 ab                	rep stos %eax,%es:(%edi)
  80097a:	eb 06                	jmp    800982 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80097c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097f:	fc                   	cld    
  800980:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800982:	89 f8                	mov    %edi,%eax
  800984:	5b                   	pop    %ebx
  800985:	5e                   	pop    %esi
  800986:	5f                   	pop    %edi
  800987:	5d                   	pop    %ebp
  800988:	c3                   	ret    

00800989 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800989:	f3 0f 1e fb          	endbr32 
  80098d:	55                   	push   %ebp
  80098e:	89 e5                	mov    %esp,%ebp
  800990:	57                   	push   %edi
  800991:	56                   	push   %esi
  800992:	8b 45 08             	mov    0x8(%ebp),%eax
  800995:	8b 75 0c             	mov    0xc(%ebp),%esi
  800998:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80099b:	39 c6                	cmp    %eax,%esi
  80099d:	73 32                	jae    8009d1 <memmove+0x48>
  80099f:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009a2:	39 c2                	cmp    %eax,%edx
  8009a4:	76 2b                	jbe    8009d1 <memmove+0x48>
		s += n;
		d += n;
  8009a6:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009a9:	89 fe                	mov    %edi,%esi
  8009ab:	09 ce                	or     %ecx,%esi
  8009ad:	09 d6                	or     %edx,%esi
  8009af:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009b5:	75 0e                	jne    8009c5 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009b7:	83 ef 04             	sub    $0x4,%edi
  8009ba:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009bd:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009c0:	fd                   	std    
  8009c1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009c3:	eb 09                	jmp    8009ce <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009c5:	83 ef 01             	sub    $0x1,%edi
  8009c8:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009cb:	fd                   	std    
  8009cc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009ce:	fc                   	cld    
  8009cf:	eb 1a                	jmp    8009eb <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009d1:	89 c2                	mov    %eax,%edx
  8009d3:	09 ca                	or     %ecx,%edx
  8009d5:	09 f2                	or     %esi,%edx
  8009d7:	f6 c2 03             	test   $0x3,%dl
  8009da:	75 0a                	jne    8009e6 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009dc:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009df:	89 c7                	mov    %eax,%edi
  8009e1:	fc                   	cld    
  8009e2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009e4:	eb 05                	jmp    8009eb <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8009e6:	89 c7                	mov    %eax,%edi
  8009e8:	fc                   	cld    
  8009e9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009eb:	5e                   	pop    %esi
  8009ec:	5f                   	pop    %edi
  8009ed:	5d                   	pop    %ebp
  8009ee:	c3                   	ret    

008009ef <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009ef:	f3 0f 1e fb          	endbr32 
  8009f3:	55                   	push   %ebp
  8009f4:	89 e5                	mov    %esp,%ebp
  8009f6:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009f9:	ff 75 10             	pushl  0x10(%ebp)
  8009fc:	ff 75 0c             	pushl  0xc(%ebp)
  8009ff:	ff 75 08             	pushl  0x8(%ebp)
  800a02:	e8 82 ff ff ff       	call   800989 <memmove>
}
  800a07:	c9                   	leave  
  800a08:	c3                   	ret    

00800a09 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a09:	f3 0f 1e fb          	endbr32 
  800a0d:	55                   	push   %ebp
  800a0e:	89 e5                	mov    %esp,%ebp
  800a10:	56                   	push   %esi
  800a11:	53                   	push   %ebx
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a18:	89 c6                	mov    %eax,%esi
  800a1a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a1d:	39 f0                	cmp    %esi,%eax
  800a1f:	74 1c                	je     800a3d <memcmp+0x34>
		if (*s1 != *s2)
  800a21:	0f b6 08             	movzbl (%eax),%ecx
  800a24:	0f b6 1a             	movzbl (%edx),%ebx
  800a27:	38 d9                	cmp    %bl,%cl
  800a29:	75 08                	jne    800a33 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a2b:	83 c0 01             	add    $0x1,%eax
  800a2e:	83 c2 01             	add    $0x1,%edx
  800a31:	eb ea                	jmp    800a1d <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a33:	0f b6 c1             	movzbl %cl,%eax
  800a36:	0f b6 db             	movzbl %bl,%ebx
  800a39:	29 d8                	sub    %ebx,%eax
  800a3b:	eb 05                	jmp    800a42 <memcmp+0x39>
	}

	return 0;
  800a3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a42:	5b                   	pop    %ebx
  800a43:	5e                   	pop    %esi
  800a44:	5d                   	pop    %ebp
  800a45:	c3                   	ret    

00800a46 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a46:	f3 0f 1e fb          	endbr32 
  800a4a:	55                   	push   %ebp
  800a4b:	89 e5                	mov    %esp,%ebp
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a53:	89 c2                	mov    %eax,%edx
  800a55:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a58:	39 d0                	cmp    %edx,%eax
  800a5a:	73 09                	jae    800a65 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a5c:	38 08                	cmp    %cl,(%eax)
  800a5e:	74 05                	je     800a65 <memfind+0x1f>
	for (; s < ends; s++)
  800a60:	83 c0 01             	add    $0x1,%eax
  800a63:	eb f3                	jmp    800a58 <memfind+0x12>
			break;
	return (void *) s;
}
  800a65:	5d                   	pop    %ebp
  800a66:	c3                   	ret    

00800a67 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a67:	f3 0f 1e fb          	endbr32 
  800a6b:	55                   	push   %ebp
  800a6c:	89 e5                	mov    %esp,%ebp
  800a6e:	57                   	push   %edi
  800a6f:	56                   	push   %esi
  800a70:	53                   	push   %ebx
  800a71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a74:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a77:	eb 03                	jmp    800a7c <strtol+0x15>
		s++;
  800a79:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a7c:	0f b6 01             	movzbl (%ecx),%eax
  800a7f:	3c 20                	cmp    $0x20,%al
  800a81:	74 f6                	je     800a79 <strtol+0x12>
  800a83:	3c 09                	cmp    $0x9,%al
  800a85:	74 f2                	je     800a79 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a87:	3c 2b                	cmp    $0x2b,%al
  800a89:	74 2a                	je     800ab5 <strtol+0x4e>
	int neg = 0;
  800a8b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a90:	3c 2d                	cmp    $0x2d,%al
  800a92:	74 2b                	je     800abf <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a94:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a9a:	75 0f                	jne    800aab <strtol+0x44>
  800a9c:	80 39 30             	cmpb   $0x30,(%ecx)
  800a9f:	74 28                	je     800ac9 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800aa1:	85 db                	test   %ebx,%ebx
  800aa3:	b8 0a 00 00 00       	mov    $0xa,%eax
  800aa8:	0f 44 d8             	cmove  %eax,%ebx
  800aab:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ab3:	eb 46                	jmp    800afb <strtol+0x94>
		s++;
  800ab5:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ab8:	bf 00 00 00 00       	mov    $0x0,%edi
  800abd:	eb d5                	jmp    800a94 <strtol+0x2d>
		s++, neg = 1;
  800abf:	83 c1 01             	add    $0x1,%ecx
  800ac2:	bf 01 00 00 00       	mov    $0x1,%edi
  800ac7:	eb cb                	jmp    800a94 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ac9:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800acd:	74 0e                	je     800add <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800acf:	85 db                	test   %ebx,%ebx
  800ad1:	75 d8                	jne    800aab <strtol+0x44>
		s++, base = 8;
  800ad3:	83 c1 01             	add    $0x1,%ecx
  800ad6:	bb 08 00 00 00       	mov    $0x8,%ebx
  800adb:	eb ce                	jmp    800aab <strtol+0x44>
		s += 2, base = 16;
  800add:	83 c1 02             	add    $0x2,%ecx
  800ae0:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ae5:	eb c4                	jmp    800aab <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800ae7:	0f be d2             	movsbl %dl,%edx
  800aea:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800aed:	3b 55 10             	cmp    0x10(%ebp),%edx
  800af0:	7d 3a                	jge    800b2c <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800af2:	83 c1 01             	add    $0x1,%ecx
  800af5:	0f af 45 10          	imul   0x10(%ebp),%eax
  800af9:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800afb:	0f b6 11             	movzbl (%ecx),%edx
  800afe:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b01:	89 f3                	mov    %esi,%ebx
  800b03:	80 fb 09             	cmp    $0x9,%bl
  800b06:	76 df                	jbe    800ae7 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b08:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b0b:	89 f3                	mov    %esi,%ebx
  800b0d:	80 fb 19             	cmp    $0x19,%bl
  800b10:	77 08                	ja     800b1a <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b12:	0f be d2             	movsbl %dl,%edx
  800b15:	83 ea 57             	sub    $0x57,%edx
  800b18:	eb d3                	jmp    800aed <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b1a:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b1d:	89 f3                	mov    %esi,%ebx
  800b1f:	80 fb 19             	cmp    $0x19,%bl
  800b22:	77 08                	ja     800b2c <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b24:	0f be d2             	movsbl %dl,%edx
  800b27:	83 ea 37             	sub    $0x37,%edx
  800b2a:	eb c1                	jmp    800aed <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b2c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b30:	74 05                	je     800b37 <strtol+0xd0>
		*endptr = (char *) s;
  800b32:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b35:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b37:	89 c2                	mov    %eax,%edx
  800b39:	f7 da                	neg    %edx
  800b3b:	85 ff                	test   %edi,%edi
  800b3d:	0f 45 c2             	cmovne %edx,%eax
}
  800b40:	5b                   	pop    %ebx
  800b41:	5e                   	pop    %esi
  800b42:	5f                   	pop    %edi
  800b43:	5d                   	pop    %ebp
  800b44:	c3                   	ret    

00800b45 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b45:	f3 0f 1e fb          	endbr32 
  800b49:	55                   	push   %ebp
  800b4a:	89 e5                	mov    %esp,%ebp
  800b4c:	57                   	push   %edi
  800b4d:	56                   	push   %esi
  800b4e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b4f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b54:	8b 55 08             	mov    0x8(%ebp),%edx
  800b57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b5a:	89 c3                	mov    %eax,%ebx
  800b5c:	89 c7                	mov    %eax,%edi
  800b5e:	89 c6                	mov    %eax,%esi
  800b60:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b62:	5b                   	pop    %ebx
  800b63:	5e                   	pop    %esi
  800b64:	5f                   	pop    %edi
  800b65:	5d                   	pop    %ebp
  800b66:	c3                   	ret    

00800b67 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b67:	f3 0f 1e fb          	endbr32 
  800b6b:	55                   	push   %ebp
  800b6c:	89 e5                	mov    %esp,%ebp
  800b6e:	57                   	push   %edi
  800b6f:	56                   	push   %esi
  800b70:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b71:	ba 00 00 00 00       	mov    $0x0,%edx
  800b76:	b8 01 00 00 00       	mov    $0x1,%eax
  800b7b:	89 d1                	mov    %edx,%ecx
  800b7d:	89 d3                	mov    %edx,%ebx
  800b7f:	89 d7                	mov    %edx,%edi
  800b81:	89 d6                	mov    %edx,%esi
  800b83:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b85:	5b                   	pop    %ebx
  800b86:	5e                   	pop    %esi
  800b87:	5f                   	pop    %edi
  800b88:	5d                   	pop    %ebp
  800b89:	c3                   	ret    

00800b8a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b8a:	f3 0f 1e fb          	endbr32 
  800b8e:	55                   	push   %ebp
  800b8f:	89 e5                	mov    %esp,%ebp
  800b91:	57                   	push   %edi
  800b92:	56                   	push   %esi
  800b93:	53                   	push   %ebx
  800b94:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b97:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b9f:	b8 03 00 00 00       	mov    $0x3,%eax
  800ba4:	89 cb                	mov    %ecx,%ebx
  800ba6:	89 cf                	mov    %ecx,%edi
  800ba8:	89 ce                	mov    %ecx,%esi
  800baa:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bac:	85 c0                	test   %eax,%eax
  800bae:	7f 08                	jg     800bb8 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bb3:	5b                   	pop    %ebx
  800bb4:	5e                   	pop    %esi
  800bb5:	5f                   	pop    %edi
  800bb6:	5d                   	pop    %ebp
  800bb7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bb8:	83 ec 0c             	sub    $0xc,%esp
  800bbb:	50                   	push   %eax
  800bbc:	6a 03                	push   $0x3
  800bbe:	68 bf 2b 80 00       	push   $0x802bbf
  800bc3:	6a 23                	push   $0x23
  800bc5:	68 dc 2b 80 00       	push   $0x802bdc
  800bca:	e8 1b 19 00 00       	call   8024ea <_panic>

00800bcf <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bcf:	f3 0f 1e fb          	endbr32 
  800bd3:	55                   	push   %ebp
  800bd4:	89 e5                	mov    %esp,%ebp
  800bd6:	57                   	push   %edi
  800bd7:	56                   	push   %esi
  800bd8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd9:	ba 00 00 00 00       	mov    $0x0,%edx
  800bde:	b8 02 00 00 00       	mov    $0x2,%eax
  800be3:	89 d1                	mov    %edx,%ecx
  800be5:	89 d3                	mov    %edx,%ebx
  800be7:	89 d7                	mov    %edx,%edi
  800be9:	89 d6                	mov    %edx,%esi
  800beb:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bed:	5b                   	pop    %ebx
  800bee:	5e                   	pop    %esi
  800bef:	5f                   	pop    %edi
  800bf0:	5d                   	pop    %ebp
  800bf1:	c3                   	ret    

00800bf2 <sys_yield>:

void
sys_yield(void)
{
  800bf2:	f3 0f 1e fb          	endbr32 
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
  800bf9:	57                   	push   %edi
  800bfa:	56                   	push   %esi
  800bfb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bfc:	ba 00 00 00 00       	mov    $0x0,%edx
  800c01:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c06:	89 d1                	mov    %edx,%ecx
  800c08:	89 d3                	mov    %edx,%ebx
  800c0a:	89 d7                	mov    %edx,%edi
  800c0c:	89 d6                	mov    %edx,%esi
  800c0e:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c10:	5b                   	pop    %ebx
  800c11:	5e                   	pop    %esi
  800c12:	5f                   	pop    %edi
  800c13:	5d                   	pop    %ebp
  800c14:	c3                   	ret    

00800c15 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c15:	f3 0f 1e fb          	endbr32 
  800c19:	55                   	push   %ebp
  800c1a:	89 e5                	mov    %esp,%ebp
  800c1c:	57                   	push   %edi
  800c1d:	56                   	push   %esi
  800c1e:	53                   	push   %ebx
  800c1f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c22:	be 00 00 00 00       	mov    $0x0,%esi
  800c27:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c2d:	b8 04 00 00 00       	mov    $0x4,%eax
  800c32:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c35:	89 f7                	mov    %esi,%edi
  800c37:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c39:	85 c0                	test   %eax,%eax
  800c3b:	7f 08                	jg     800c45 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c40:	5b                   	pop    %ebx
  800c41:	5e                   	pop    %esi
  800c42:	5f                   	pop    %edi
  800c43:	5d                   	pop    %ebp
  800c44:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c45:	83 ec 0c             	sub    $0xc,%esp
  800c48:	50                   	push   %eax
  800c49:	6a 04                	push   $0x4
  800c4b:	68 bf 2b 80 00       	push   $0x802bbf
  800c50:	6a 23                	push   $0x23
  800c52:	68 dc 2b 80 00       	push   $0x802bdc
  800c57:	e8 8e 18 00 00       	call   8024ea <_panic>

00800c5c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c5c:	f3 0f 1e fb          	endbr32 
  800c60:	55                   	push   %ebp
  800c61:	89 e5                	mov    %esp,%ebp
  800c63:	57                   	push   %edi
  800c64:	56                   	push   %esi
  800c65:	53                   	push   %ebx
  800c66:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c69:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c6f:	b8 05 00 00 00       	mov    $0x5,%eax
  800c74:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c77:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c7a:	8b 75 18             	mov    0x18(%ebp),%esi
  800c7d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c7f:	85 c0                	test   %eax,%eax
  800c81:	7f 08                	jg     800c8b <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c83:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c86:	5b                   	pop    %ebx
  800c87:	5e                   	pop    %esi
  800c88:	5f                   	pop    %edi
  800c89:	5d                   	pop    %ebp
  800c8a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c8b:	83 ec 0c             	sub    $0xc,%esp
  800c8e:	50                   	push   %eax
  800c8f:	6a 05                	push   $0x5
  800c91:	68 bf 2b 80 00       	push   $0x802bbf
  800c96:	6a 23                	push   $0x23
  800c98:	68 dc 2b 80 00       	push   $0x802bdc
  800c9d:	e8 48 18 00 00       	call   8024ea <_panic>

00800ca2 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ca2:	f3 0f 1e fb          	endbr32 
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	57                   	push   %edi
  800caa:	56                   	push   %esi
  800cab:	53                   	push   %ebx
  800cac:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800caf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cba:	b8 06 00 00 00       	mov    $0x6,%eax
  800cbf:	89 df                	mov    %ebx,%edi
  800cc1:	89 de                	mov    %ebx,%esi
  800cc3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc5:	85 c0                	test   %eax,%eax
  800cc7:	7f 08                	jg     800cd1 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ccc:	5b                   	pop    %ebx
  800ccd:	5e                   	pop    %esi
  800cce:	5f                   	pop    %edi
  800ccf:	5d                   	pop    %ebp
  800cd0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd1:	83 ec 0c             	sub    $0xc,%esp
  800cd4:	50                   	push   %eax
  800cd5:	6a 06                	push   $0x6
  800cd7:	68 bf 2b 80 00       	push   $0x802bbf
  800cdc:	6a 23                	push   $0x23
  800cde:	68 dc 2b 80 00       	push   $0x802bdc
  800ce3:	e8 02 18 00 00       	call   8024ea <_panic>

00800ce8 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ce8:	f3 0f 1e fb          	endbr32 
  800cec:	55                   	push   %ebp
  800ced:	89 e5                	mov    %esp,%ebp
  800cef:	57                   	push   %edi
  800cf0:	56                   	push   %esi
  800cf1:	53                   	push   %ebx
  800cf2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cfa:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d00:	b8 08 00 00 00       	mov    $0x8,%eax
  800d05:	89 df                	mov    %ebx,%edi
  800d07:	89 de                	mov    %ebx,%esi
  800d09:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d0b:	85 c0                	test   %eax,%eax
  800d0d:	7f 08                	jg     800d17 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d12:	5b                   	pop    %ebx
  800d13:	5e                   	pop    %esi
  800d14:	5f                   	pop    %edi
  800d15:	5d                   	pop    %ebp
  800d16:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d17:	83 ec 0c             	sub    $0xc,%esp
  800d1a:	50                   	push   %eax
  800d1b:	6a 08                	push   $0x8
  800d1d:	68 bf 2b 80 00       	push   $0x802bbf
  800d22:	6a 23                	push   $0x23
  800d24:	68 dc 2b 80 00       	push   $0x802bdc
  800d29:	e8 bc 17 00 00       	call   8024ea <_panic>

00800d2e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d2e:	f3 0f 1e fb          	endbr32 
  800d32:	55                   	push   %ebp
  800d33:	89 e5                	mov    %esp,%ebp
  800d35:	57                   	push   %edi
  800d36:	56                   	push   %esi
  800d37:	53                   	push   %ebx
  800d38:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d3b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d40:	8b 55 08             	mov    0x8(%ebp),%edx
  800d43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d46:	b8 09 00 00 00       	mov    $0x9,%eax
  800d4b:	89 df                	mov    %ebx,%edi
  800d4d:	89 de                	mov    %ebx,%esi
  800d4f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d51:	85 c0                	test   %eax,%eax
  800d53:	7f 08                	jg     800d5d <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d55:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d58:	5b                   	pop    %ebx
  800d59:	5e                   	pop    %esi
  800d5a:	5f                   	pop    %edi
  800d5b:	5d                   	pop    %ebp
  800d5c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5d:	83 ec 0c             	sub    $0xc,%esp
  800d60:	50                   	push   %eax
  800d61:	6a 09                	push   $0x9
  800d63:	68 bf 2b 80 00       	push   $0x802bbf
  800d68:	6a 23                	push   $0x23
  800d6a:	68 dc 2b 80 00       	push   $0x802bdc
  800d6f:	e8 76 17 00 00       	call   8024ea <_panic>

00800d74 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d74:	f3 0f 1e fb          	endbr32 
  800d78:	55                   	push   %ebp
  800d79:	89 e5                	mov    %esp,%ebp
  800d7b:	57                   	push   %edi
  800d7c:	56                   	push   %esi
  800d7d:	53                   	push   %ebx
  800d7e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d81:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d86:	8b 55 08             	mov    0x8(%ebp),%edx
  800d89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d91:	89 df                	mov    %ebx,%edi
  800d93:	89 de                	mov    %ebx,%esi
  800d95:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d97:	85 c0                	test   %eax,%eax
  800d99:	7f 08                	jg     800da3 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9e:	5b                   	pop    %ebx
  800d9f:	5e                   	pop    %esi
  800da0:	5f                   	pop    %edi
  800da1:	5d                   	pop    %ebp
  800da2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da3:	83 ec 0c             	sub    $0xc,%esp
  800da6:	50                   	push   %eax
  800da7:	6a 0a                	push   $0xa
  800da9:	68 bf 2b 80 00       	push   $0x802bbf
  800dae:	6a 23                	push   $0x23
  800db0:	68 dc 2b 80 00       	push   $0x802bdc
  800db5:	e8 30 17 00 00       	call   8024ea <_panic>

00800dba <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dba:	f3 0f 1e fb          	endbr32 
  800dbe:	55                   	push   %ebp
  800dbf:	89 e5                	mov    %esp,%ebp
  800dc1:	57                   	push   %edi
  800dc2:	56                   	push   %esi
  800dc3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dca:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dcf:	be 00 00 00 00       	mov    $0x0,%esi
  800dd4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dd7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dda:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ddc:	5b                   	pop    %ebx
  800ddd:	5e                   	pop    %esi
  800dde:	5f                   	pop    %edi
  800ddf:	5d                   	pop    %ebp
  800de0:	c3                   	ret    

00800de1 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800de1:	f3 0f 1e fb          	endbr32 
  800de5:	55                   	push   %ebp
  800de6:	89 e5                	mov    %esp,%ebp
  800de8:	57                   	push   %edi
  800de9:	56                   	push   %esi
  800dea:	53                   	push   %ebx
  800deb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dee:	b9 00 00 00 00       	mov    $0x0,%ecx
  800df3:	8b 55 08             	mov    0x8(%ebp),%edx
  800df6:	b8 0d 00 00 00       	mov    $0xd,%eax
  800dfb:	89 cb                	mov    %ecx,%ebx
  800dfd:	89 cf                	mov    %ecx,%edi
  800dff:	89 ce                	mov    %ecx,%esi
  800e01:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e03:	85 c0                	test   %eax,%eax
  800e05:	7f 08                	jg     800e0f <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e07:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e0a:	5b                   	pop    %ebx
  800e0b:	5e                   	pop    %esi
  800e0c:	5f                   	pop    %edi
  800e0d:	5d                   	pop    %ebp
  800e0e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0f:	83 ec 0c             	sub    $0xc,%esp
  800e12:	50                   	push   %eax
  800e13:	6a 0d                	push   $0xd
  800e15:	68 bf 2b 80 00       	push   $0x802bbf
  800e1a:	6a 23                	push   $0x23
  800e1c:	68 dc 2b 80 00       	push   $0x802bdc
  800e21:	e8 c4 16 00 00       	call   8024ea <_panic>

00800e26 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e26:	f3 0f 1e fb          	endbr32 
  800e2a:	55                   	push   %ebp
  800e2b:	89 e5                	mov    %esp,%ebp
  800e2d:	57                   	push   %edi
  800e2e:	56                   	push   %esi
  800e2f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e30:	ba 00 00 00 00       	mov    $0x0,%edx
  800e35:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e3a:	89 d1                	mov    %edx,%ecx
  800e3c:	89 d3                	mov    %edx,%ebx
  800e3e:	89 d7                	mov    %edx,%edi
  800e40:	89 d6                	mov    %edx,%esi
  800e42:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e44:	5b                   	pop    %ebx
  800e45:	5e                   	pop    %esi
  800e46:	5f                   	pop    %edi
  800e47:	5d                   	pop    %ebp
  800e48:	c3                   	ret    

00800e49 <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  800e49:	f3 0f 1e fb          	endbr32 
  800e4d:	55                   	push   %ebp
  800e4e:	89 e5                	mov    %esp,%ebp
  800e50:	57                   	push   %edi
  800e51:	56                   	push   %esi
  800e52:	53                   	push   %ebx
  800e53:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e56:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e61:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e66:	89 df                	mov    %ebx,%edi
  800e68:	89 de                	mov    %ebx,%esi
  800e6a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e6c:	85 c0                	test   %eax,%eax
  800e6e:	7f 08                	jg     800e78 <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  800e70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e73:	5b                   	pop    %ebx
  800e74:	5e                   	pop    %esi
  800e75:	5f                   	pop    %edi
  800e76:	5d                   	pop    %ebp
  800e77:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e78:	83 ec 0c             	sub    $0xc,%esp
  800e7b:	50                   	push   %eax
  800e7c:	6a 0f                	push   $0xf
  800e7e:	68 bf 2b 80 00       	push   $0x802bbf
  800e83:	6a 23                	push   $0x23
  800e85:	68 dc 2b 80 00       	push   $0x802bdc
  800e8a:	e8 5b 16 00 00       	call   8024ea <_panic>

00800e8f <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  800e8f:	f3 0f 1e fb          	endbr32 
  800e93:	55                   	push   %ebp
  800e94:	89 e5                	mov    %esp,%ebp
  800e96:	57                   	push   %edi
  800e97:	56                   	push   %esi
  800e98:	53                   	push   %ebx
  800e99:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e9c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea7:	b8 10 00 00 00       	mov    $0x10,%eax
  800eac:	89 df                	mov    %ebx,%edi
  800eae:	89 de                	mov    %ebx,%esi
  800eb0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb2:	85 c0                	test   %eax,%eax
  800eb4:	7f 08                	jg     800ebe <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  800eb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb9:	5b                   	pop    %ebx
  800eba:	5e                   	pop    %esi
  800ebb:	5f                   	pop    %edi
  800ebc:	5d                   	pop    %ebp
  800ebd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ebe:	83 ec 0c             	sub    $0xc,%esp
  800ec1:	50                   	push   %eax
  800ec2:	6a 10                	push   $0x10
  800ec4:	68 bf 2b 80 00       	push   $0x802bbf
  800ec9:	6a 23                	push   $0x23
  800ecb:	68 dc 2b 80 00       	push   $0x802bdc
  800ed0:	e8 15 16 00 00       	call   8024ea <_panic>

00800ed5 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800ed5:	f3 0f 1e fb          	endbr32 
  800ed9:	55                   	push   %ebp
  800eda:	89 e5                	mov    %esp,%ebp
  800edc:	53                   	push   %ebx
  800edd:	83 ec 04             	sub    $0x4,%esp
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800ee3:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  800ee5:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800ee9:	74 74                	je     800f5f <pgfault+0x8a>
  800eeb:	89 d8                	mov    %ebx,%eax
  800eed:	c1 e8 0c             	shr    $0xc,%eax
  800ef0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800ef7:	f6 c4 08             	test   $0x8,%ah
  800efa:	74 63                	je     800f5f <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800efc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  800f02:	83 ec 0c             	sub    $0xc,%esp
  800f05:	6a 05                	push   $0x5
  800f07:	68 00 f0 7f 00       	push   $0x7ff000
  800f0c:	6a 00                	push   $0x0
  800f0e:	53                   	push   %ebx
  800f0f:	6a 00                	push   $0x0
  800f11:	e8 46 fd ff ff       	call   800c5c <sys_page_map>
  800f16:	83 c4 20             	add    $0x20,%esp
  800f19:	85 c0                	test   %eax,%eax
  800f1b:	78 59                	js     800f76 <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  800f1d:	83 ec 04             	sub    $0x4,%esp
  800f20:	6a 07                	push   $0x7
  800f22:	53                   	push   %ebx
  800f23:	6a 00                	push   $0x0
  800f25:	e8 eb fc ff ff       	call   800c15 <sys_page_alloc>
  800f2a:	83 c4 10             	add    $0x10,%esp
  800f2d:	85 c0                	test   %eax,%eax
  800f2f:	78 5a                	js     800f8b <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  800f31:	83 ec 04             	sub    $0x4,%esp
  800f34:	68 00 10 00 00       	push   $0x1000
  800f39:	68 00 f0 7f 00       	push   $0x7ff000
  800f3e:	53                   	push   %ebx
  800f3f:	e8 45 fa ff ff       	call   800989 <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  800f44:	83 c4 08             	add    $0x8,%esp
  800f47:	68 00 f0 7f 00       	push   $0x7ff000
  800f4c:	6a 00                	push   $0x0
  800f4e:	e8 4f fd ff ff       	call   800ca2 <sys_page_unmap>
  800f53:	83 c4 10             	add    $0x10,%esp
  800f56:	85 c0                	test   %eax,%eax
  800f58:	78 46                	js     800fa0 <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  800f5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f5d:	c9                   	leave  
  800f5e:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  800f5f:	83 ec 04             	sub    $0x4,%esp
  800f62:	68 ea 2b 80 00       	push   $0x802bea
  800f67:	68 d3 00 00 00       	push   $0xd3
  800f6c:	68 06 2c 80 00       	push   $0x802c06
  800f71:	e8 74 15 00 00       	call   8024ea <_panic>
		panic("pgfault: %e\n", r);
  800f76:	50                   	push   %eax
  800f77:	68 11 2c 80 00       	push   $0x802c11
  800f7c:	68 df 00 00 00       	push   $0xdf
  800f81:	68 06 2c 80 00       	push   $0x802c06
  800f86:	e8 5f 15 00 00       	call   8024ea <_panic>
		panic("pgfault: %e\n", r);
  800f8b:	50                   	push   %eax
  800f8c:	68 11 2c 80 00       	push   $0x802c11
  800f91:	68 e3 00 00 00       	push   $0xe3
  800f96:	68 06 2c 80 00       	push   $0x802c06
  800f9b:	e8 4a 15 00 00       	call   8024ea <_panic>
		panic("pgfault: %e\n", r);
  800fa0:	50                   	push   %eax
  800fa1:	68 11 2c 80 00       	push   $0x802c11
  800fa6:	68 e9 00 00 00       	push   $0xe9
  800fab:	68 06 2c 80 00       	push   $0x802c06
  800fb0:	e8 35 15 00 00       	call   8024ea <_panic>

00800fb5 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800fb5:	f3 0f 1e fb          	endbr32 
  800fb9:	55                   	push   %ebp
  800fba:	89 e5                	mov    %esp,%ebp
  800fbc:	57                   	push   %edi
  800fbd:	56                   	push   %esi
  800fbe:	53                   	push   %ebx
  800fbf:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  800fc2:	68 d5 0e 80 00       	push   $0x800ed5
  800fc7:	e8 68 15 00 00       	call   802534 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800fcc:	b8 07 00 00 00       	mov    $0x7,%eax
  800fd1:	cd 30                	int    $0x30
  800fd3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  800fd6:	83 c4 10             	add    $0x10,%esp
  800fd9:	85 c0                	test   %eax,%eax
  800fdb:	78 2d                	js     80100a <fork+0x55>
  800fdd:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800fdf:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  800fe4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fe8:	0f 85 9b 00 00 00    	jne    801089 <fork+0xd4>
		thisenv = &envs[ENVX(sys_getenvid())];
  800fee:	e8 dc fb ff ff       	call   800bcf <sys_getenvid>
  800ff3:	25 ff 03 00 00       	and    $0x3ff,%eax
  800ff8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800ffb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801000:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  801005:	e9 71 01 00 00       	jmp    80117b <fork+0x1c6>
		panic("sys_exofork: %e", envid);
  80100a:	50                   	push   %eax
  80100b:	68 1e 2c 80 00       	push   $0x802c1e
  801010:	68 2a 01 00 00       	push   $0x12a
  801015:	68 06 2c 80 00       	push   $0x802c06
  80101a:	e8 cb 14 00 00       	call   8024ea <_panic>
		sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_SYSCALL);
  80101f:	c1 e6 0c             	shl    $0xc,%esi
  801022:	83 ec 0c             	sub    $0xc,%esp
  801025:	68 07 0e 00 00       	push   $0xe07
  80102a:	56                   	push   %esi
  80102b:	57                   	push   %edi
  80102c:	56                   	push   %esi
  80102d:	6a 00                	push   $0x0
  80102f:	e8 28 fc ff ff       	call   800c5c <sys_page_map>
  801034:	83 c4 20             	add    $0x20,%esp
  801037:	eb 3e                	jmp    801077 <fork+0xc2>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  801039:	c1 e6 0c             	shl    $0xc,%esi
  80103c:	83 ec 0c             	sub    $0xc,%esp
  80103f:	68 05 08 00 00       	push   $0x805
  801044:	56                   	push   %esi
  801045:	57                   	push   %edi
  801046:	56                   	push   %esi
  801047:	6a 00                	push   $0x0
  801049:	e8 0e fc ff ff       	call   800c5c <sys_page_map>
  80104e:	83 c4 20             	add    $0x20,%esp
  801051:	85 c0                	test   %eax,%eax
  801053:	0f 88 bc 00 00 00    	js     801115 <fork+0x160>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  801059:	83 ec 0c             	sub    $0xc,%esp
  80105c:	68 05 08 00 00       	push   $0x805
  801061:	56                   	push   %esi
  801062:	6a 00                	push   $0x0
  801064:	56                   	push   %esi
  801065:	6a 00                	push   $0x0
  801067:	e8 f0 fb ff ff       	call   800c5c <sys_page_map>
  80106c:	83 c4 20             	add    $0x20,%esp
  80106f:	85 c0                	test   %eax,%eax
  801071:	0f 88 b3 00 00 00    	js     80112a <fork+0x175>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801077:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80107d:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801083:	0f 84 b6 00 00 00    	je     80113f <fork+0x18a>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  801089:	89 d8                	mov    %ebx,%eax
  80108b:	c1 e8 16             	shr    $0x16,%eax
  80108e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801095:	a8 01                	test   $0x1,%al
  801097:	74 de                	je     801077 <fork+0xc2>
  801099:	89 de                	mov    %ebx,%esi
  80109b:	c1 ee 0c             	shr    $0xc,%esi
  80109e:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010a5:	a8 01                	test   $0x1,%al
  8010a7:	74 ce                	je     801077 <fork+0xc2>
  8010a9:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010b0:	a8 04                	test   $0x4,%al
  8010b2:	74 c3                	je     801077 <fork+0xc2>
	if ((uvpt[pn] & PTE_SHARE)){
  8010b4:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010bb:	f6 c4 04             	test   $0x4,%ah
  8010be:	0f 85 5b ff ff ff    	jne    80101f <fork+0x6a>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  8010c4:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010cb:	a8 02                	test   $0x2,%al
  8010cd:	0f 85 66 ff ff ff    	jne    801039 <fork+0x84>
  8010d3:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010da:	f6 c4 08             	test   $0x8,%ah
  8010dd:	0f 85 56 ff ff ff    	jne    801039 <fork+0x84>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  8010e3:	c1 e6 0c             	shl    $0xc,%esi
  8010e6:	83 ec 0c             	sub    $0xc,%esp
  8010e9:	6a 05                	push   $0x5
  8010eb:	56                   	push   %esi
  8010ec:	57                   	push   %edi
  8010ed:	56                   	push   %esi
  8010ee:	6a 00                	push   $0x0
  8010f0:	e8 67 fb ff ff       	call   800c5c <sys_page_map>
  8010f5:	83 c4 20             	add    $0x20,%esp
  8010f8:	85 c0                	test   %eax,%eax
  8010fa:	0f 89 77 ff ff ff    	jns    801077 <fork+0xc2>
		panic("duppage: %e\n", r);
  801100:	50                   	push   %eax
  801101:	68 2e 2c 80 00       	push   $0x802c2e
  801106:	68 0c 01 00 00       	push   $0x10c
  80110b:	68 06 2c 80 00       	push   $0x802c06
  801110:	e8 d5 13 00 00       	call   8024ea <_panic>
			panic("duppage: %e\n", r);
  801115:	50                   	push   %eax
  801116:	68 2e 2c 80 00       	push   $0x802c2e
  80111b:	68 05 01 00 00       	push   $0x105
  801120:	68 06 2c 80 00       	push   $0x802c06
  801125:	e8 c0 13 00 00       	call   8024ea <_panic>
			panic("duppage: %e\n", r);
  80112a:	50                   	push   %eax
  80112b:	68 2e 2c 80 00       	push   $0x802c2e
  801130:	68 09 01 00 00       	push   $0x109
  801135:	68 06 2c 80 00       	push   $0x802c06
  80113a:	e8 ab 13 00 00       	call   8024ea <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  80113f:	83 ec 04             	sub    $0x4,%esp
  801142:	6a 07                	push   $0x7
  801144:	68 00 f0 bf ee       	push   $0xeebff000
  801149:	ff 75 e4             	pushl  -0x1c(%ebp)
  80114c:	e8 c4 fa ff ff       	call   800c15 <sys_page_alloc>
  801151:	83 c4 10             	add    $0x10,%esp
  801154:	85 c0                	test   %eax,%eax
  801156:	78 2e                	js     801186 <fork+0x1d1>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801158:	83 ec 08             	sub    $0x8,%esp
  80115b:	68 a7 25 80 00       	push   $0x8025a7
  801160:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801163:	57                   	push   %edi
  801164:	e8 0b fc ff ff       	call   800d74 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801169:	83 c4 08             	add    $0x8,%esp
  80116c:	6a 02                	push   $0x2
  80116e:	57                   	push   %edi
  80116f:	e8 74 fb ff ff       	call   800ce8 <sys_env_set_status>
  801174:	83 c4 10             	add    $0x10,%esp
  801177:	85 c0                	test   %eax,%eax
  801179:	78 20                	js     80119b <fork+0x1e6>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  80117b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80117e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801181:	5b                   	pop    %ebx
  801182:	5e                   	pop    %esi
  801183:	5f                   	pop    %edi
  801184:	5d                   	pop    %ebp
  801185:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  801186:	50                   	push   %eax
  801187:	68 3b 2c 80 00       	push   $0x802c3b
  80118c:	68 3e 01 00 00       	push   $0x13e
  801191:	68 06 2c 80 00       	push   $0x802c06
  801196:	e8 4f 13 00 00       	call   8024ea <_panic>
		panic("sys_env_set_status: %e", r);
  80119b:	50                   	push   %eax
  80119c:	68 4e 2c 80 00       	push   $0x802c4e
  8011a1:	68 43 01 00 00       	push   $0x143
  8011a6:	68 06 2c 80 00       	push   $0x802c06
  8011ab:	e8 3a 13 00 00       	call   8024ea <_panic>

008011b0 <sfork>:

// Challenge!
int
sfork(void)
{
  8011b0:	f3 0f 1e fb          	endbr32 
  8011b4:	55                   	push   %ebp
  8011b5:	89 e5                	mov    %esp,%ebp
  8011b7:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8011ba:	68 65 2c 80 00       	push   $0x802c65
  8011bf:	68 4c 01 00 00       	push   $0x14c
  8011c4:	68 06 2c 80 00       	push   $0x802c06
  8011c9:	e8 1c 13 00 00       	call   8024ea <_panic>

008011ce <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8011ce:	f3 0f 1e fb          	endbr32 
  8011d2:	55                   	push   %ebp
  8011d3:	89 e5                	mov    %esp,%ebp
  8011d5:	56                   	push   %esi
  8011d6:	53                   	push   %ebx
  8011d7:	8b 75 08             	mov    0x8(%ebp),%esi
  8011da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011dd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  8011e0:	85 c0                	test   %eax,%eax
  8011e2:	74 3d                	je     801221 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  8011e4:	83 ec 0c             	sub    $0xc,%esp
  8011e7:	50                   	push   %eax
  8011e8:	e8 f4 fb ff ff       	call   800de1 <sys_ipc_recv>
  8011ed:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  8011f0:	85 f6                	test   %esi,%esi
  8011f2:	74 0b                	je     8011ff <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8011f4:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8011fa:	8b 52 74             	mov    0x74(%edx),%edx
  8011fd:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  8011ff:	85 db                	test   %ebx,%ebx
  801201:	74 0b                	je     80120e <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  801203:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801209:	8b 52 78             	mov    0x78(%edx),%edx
  80120c:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  80120e:	85 c0                	test   %eax,%eax
  801210:	78 21                	js     801233 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  801212:	a1 08 40 80 00       	mov    0x804008,%eax
  801217:	8b 40 70             	mov    0x70(%eax),%eax
}
  80121a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80121d:	5b                   	pop    %ebx
  80121e:	5e                   	pop    %esi
  80121f:	5d                   	pop    %ebp
  801220:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  801221:	83 ec 0c             	sub    $0xc,%esp
  801224:	68 00 00 c0 ee       	push   $0xeec00000
  801229:	e8 b3 fb ff ff       	call   800de1 <sys_ipc_recv>
  80122e:	83 c4 10             	add    $0x10,%esp
  801231:	eb bd                	jmp    8011f0 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  801233:	85 f6                	test   %esi,%esi
  801235:	74 10                	je     801247 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  801237:	85 db                	test   %ebx,%ebx
  801239:	75 df                	jne    80121a <ipc_recv+0x4c>
  80123b:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801242:	00 00 00 
  801245:	eb d3                	jmp    80121a <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  801247:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80124e:	00 00 00 
  801251:	eb e4                	jmp    801237 <ipc_recv+0x69>

00801253 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801253:	f3 0f 1e fb          	endbr32 
  801257:	55                   	push   %ebp
  801258:	89 e5                	mov    %esp,%ebp
  80125a:	57                   	push   %edi
  80125b:	56                   	push   %esi
  80125c:	53                   	push   %ebx
  80125d:	83 ec 0c             	sub    $0xc,%esp
  801260:	8b 7d 08             	mov    0x8(%ebp),%edi
  801263:	8b 75 0c             	mov    0xc(%ebp),%esi
  801266:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  801269:	85 db                	test   %ebx,%ebx
  80126b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801270:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  801273:	ff 75 14             	pushl  0x14(%ebp)
  801276:	53                   	push   %ebx
  801277:	56                   	push   %esi
  801278:	57                   	push   %edi
  801279:	e8 3c fb ff ff       	call   800dba <sys_ipc_try_send>
  80127e:	83 c4 10             	add    $0x10,%esp
  801281:	85 c0                	test   %eax,%eax
  801283:	79 1e                	jns    8012a3 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  801285:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801288:	75 07                	jne    801291 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  80128a:	e8 63 f9 ff ff       	call   800bf2 <sys_yield>
  80128f:	eb e2                	jmp    801273 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  801291:	50                   	push   %eax
  801292:	68 7b 2c 80 00       	push   $0x802c7b
  801297:	6a 59                	push   $0x59
  801299:	68 96 2c 80 00       	push   $0x802c96
  80129e:	e8 47 12 00 00       	call   8024ea <_panic>
	}
}
  8012a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012a6:	5b                   	pop    %ebx
  8012a7:	5e                   	pop    %esi
  8012a8:	5f                   	pop    %edi
  8012a9:	5d                   	pop    %ebp
  8012aa:	c3                   	ret    

008012ab <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8012ab:	f3 0f 1e fb          	endbr32 
  8012af:	55                   	push   %ebp
  8012b0:	89 e5                	mov    %esp,%ebp
  8012b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8012b5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8012ba:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8012bd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8012c3:	8b 52 50             	mov    0x50(%edx),%edx
  8012c6:	39 ca                	cmp    %ecx,%edx
  8012c8:	74 11                	je     8012db <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8012ca:	83 c0 01             	add    $0x1,%eax
  8012cd:	3d 00 04 00 00       	cmp    $0x400,%eax
  8012d2:	75 e6                	jne    8012ba <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8012d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d9:	eb 0b                	jmp    8012e6 <ipc_find_env+0x3b>
			return envs[i].env_id;
  8012db:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8012de:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012e3:	8b 40 48             	mov    0x48(%eax),%eax
}
  8012e6:	5d                   	pop    %ebp
  8012e7:	c3                   	ret    

008012e8 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012e8:	f3 0f 1e fb          	endbr32 
  8012ec:	55                   	push   %ebp
  8012ed:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f2:	05 00 00 00 30       	add    $0x30000000,%eax
  8012f7:	c1 e8 0c             	shr    $0xc,%eax
}
  8012fa:	5d                   	pop    %ebp
  8012fb:	c3                   	ret    

008012fc <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012fc:	f3 0f 1e fb          	endbr32 
  801300:	55                   	push   %ebp
  801301:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801303:	8b 45 08             	mov    0x8(%ebp),%eax
  801306:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80130b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801310:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801315:	5d                   	pop    %ebp
  801316:	c3                   	ret    

00801317 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801317:	f3 0f 1e fb          	endbr32 
  80131b:	55                   	push   %ebp
  80131c:	89 e5                	mov    %esp,%ebp
  80131e:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801323:	89 c2                	mov    %eax,%edx
  801325:	c1 ea 16             	shr    $0x16,%edx
  801328:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80132f:	f6 c2 01             	test   $0x1,%dl
  801332:	74 2d                	je     801361 <fd_alloc+0x4a>
  801334:	89 c2                	mov    %eax,%edx
  801336:	c1 ea 0c             	shr    $0xc,%edx
  801339:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801340:	f6 c2 01             	test   $0x1,%dl
  801343:	74 1c                	je     801361 <fd_alloc+0x4a>
  801345:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80134a:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80134f:	75 d2                	jne    801323 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801351:	8b 45 08             	mov    0x8(%ebp),%eax
  801354:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80135a:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80135f:	eb 0a                	jmp    80136b <fd_alloc+0x54>
			*fd_store = fd;
  801361:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801364:	89 01                	mov    %eax,(%ecx)
			return 0;
  801366:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80136b:	5d                   	pop    %ebp
  80136c:	c3                   	ret    

0080136d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80136d:	f3 0f 1e fb          	endbr32 
  801371:	55                   	push   %ebp
  801372:	89 e5                	mov    %esp,%ebp
  801374:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801377:	83 f8 1f             	cmp    $0x1f,%eax
  80137a:	77 30                	ja     8013ac <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80137c:	c1 e0 0c             	shl    $0xc,%eax
  80137f:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801384:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80138a:	f6 c2 01             	test   $0x1,%dl
  80138d:	74 24                	je     8013b3 <fd_lookup+0x46>
  80138f:	89 c2                	mov    %eax,%edx
  801391:	c1 ea 0c             	shr    $0xc,%edx
  801394:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80139b:	f6 c2 01             	test   $0x1,%dl
  80139e:	74 1a                	je     8013ba <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8013a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013a3:	89 02                	mov    %eax,(%edx)
	return 0;
  8013a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013aa:	5d                   	pop    %ebp
  8013ab:	c3                   	ret    
		return -E_INVAL;
  8013ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013b1:	eb f7                	jmp    8013aa <fd_lookup+0x3d>
		return -E_INVAL;
  8013b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013b8:	eb f0                	jmp    8013aa <fd_lookup+0x3d>
  8013ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013bf:	eb e9                	jmp    8013aa <fd_lookup+0x3d>

008013c1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013c1:	f3 0f 1e fb          	endbr32 
  8013c5:	55                   	push   %ebp
  8013c6:	89 e5                	mov    %esp,%ebp
  8013c8:	83 ec 08             	sub    $0x8,%esp
  8013cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8013ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8013d3:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8013d8:	39 08                	cmp    %ecx,(%eax)
  8013da:	74 38                	je     801414 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  8013dc:	83 c2 01             	add    $0x1,%edx
  8013df:	8b 04 95 1c 2d 80 00 	mov    0x802d1c(,%edx,4),%eax
  8013e6:	85 c0                	test   %eax,%eax
  8013e8:	75 ee                	jne    8013d8 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8013ea:	a1 08 40 80 00       	mov    0x804008,%eax
  8013ef:	8b 40 48             	mov    0x48(%eax),%eax
  8013f2:	83 ec 04             	sub    $0x4,%esp
  8013f5:	51                   	push   %ecx
  8013f6:	50                   	push   %eax
  8013f7:	68 a0 2c 80 00       	push   $0x802ca0
  8013fc:	e8 c8 ed ff ff       	call   8001c9 <cprintf>
	*dev = 0;
  801401:	8b 45 0c             	mov    0xc(%ebp),%eax
  801404:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80140a:	83 c4 10             	add    $0x10,%esp
  80140d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801412:	c9                   	leave  
  801413:	c3                   	ret    
			*dev = devtab[i];
  801414:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801417:	89 01                	mov    %eax,(%ecx)
			return 0;
  801419:	b8 00 00 00 00       	mov    $0x0,%eax
  80141e:	eb f2                	jmp    801412 <dev_lookup+0x51>

00801420 <fd_close>:
{
  801420:	f3 0f 1e fb          	endbr32 
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
  801427:	57                   	push   %edi
  801428:	56                   	push   %esi
  801429:	53                   	push   %ebx
  80142a:	83 ec 24             	sub    $0x24,%esp
  80142d:	8b 75 08             	mov    0x8(%ebp),%esi
  801430:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801433:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801436:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801437:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80143d:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801440:	50                   	push   %eax
  801441:	e8 27 ff ff ff       	call   80136d <fd_lookup>
  801446:	89 c3                	mov    %eax,%ebx
  801448:	83 c4 10             	add    $0x10,%esp
  80144b:	85 c0                	test   %eax,%eax
  80144d:	78 05                	js     801454 <fd_close+0x34>
	    || fd != fd2)
  80144f:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801452:	74 16                	je     80146a <fd_close+0x4a>
		return (must_exist ? r : 0);
  801454:	89 f8                	mov    %edi,%eax
  801456:	84 c0                	test   %al,%al
  801458:	b8 00 00 00 00       	mov    $0x0,%eax
  80145d:	0f 44 d8             	cmove  %eax,%ebx
}
  801460:	89 d8                	mov    %ebx,%eax
  801462:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801465:	5b                   	pop    %ebx
  801466:	5e                   	pop    %esi
  801467:	5f                   	pop    %edi
  801468:	5d                   	pop    %ebp
  801469:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80146a:	83 ec 08             	sub    $0x8,%esp
  80146d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801470:	50                   	push   %eax
  801471:	ff 36                	pushl  (%esi)
  801473:	e8 49 ff ff ff       	call   8013c1 <dev_lookup>
  801478:	89 c3                	mov    %eax,%ebx
  80147a:	83 c4 10             	add    $0x10,%esp
  80147d:	85 c0                	test   %eax,%eax
  80147f:	78 1a                	js     80149b <fd_close+0x7b>
		if (dev->dev_close)
  801481:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801484:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801487:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80148c:	85 c0                	test   %eax,%eax
  80148e:	74 0b                	je     80149b <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801490:	83 ec 0c             	sub    $0xc,%esp
  801493:	56                   	push   %esi
  801494:	ff d0                	call   *%eax
  801496:	89 c3                	mov    %eax,%ebx
  801498:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80149b:	83 ec 08             	sub    $0x8,%esp
  80149e:	56                   	push   %esi
  80149f:	6a 00                	push   $0x0
  8014a1:	e8 fc f7 ff ff       	call   800ca2 <sys_page_unmap>
	return r;
  8014a6:	83 c4 10             	add    $0x10,%esp
  8014a9:	eb b5                	jmp    801460 <fd_close+0x40>

008014ab <close>:

int
close(int fdnum)
{
  8014ab:	f3 0f 1e fb          	endbr32 
  8014af:	55                   	push   %ebp
  8014b0:	89 e5                	mov    %esp,%ebp
  8014b2:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014b8:	50                   	push   %eax
  8014b9:	ff 75 08             	pushl  0x8(%ebp)
  8014bc:	e8 ac fe ff ff       	call   80136d <fd_lookup>
  8014c1:	83 c4 10             	add    $0x10,%esp
  8014c4:	85 c0                	test   %eax,%eax
  8014c6:	79 02                	jns    8014ca <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8014c8:	c9                   	leave  
  8014c9:	c3                   	ret    
		return fd_close(fd, 1);
  8014ca:	83 ec 08             	sub    $0x8,%esp
  8014cd:	6a 01                	push   $0x1
  8014cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8014d2:	e8 49 ff ff ff       	call   801420 <fd_close>
  8014d7:	83 c4 10             	add    $0x10,%esp
  8014da:	eb ec                	jmp    8014c8 <close+0x1d>

008014dc <close_all>:

void
close_all(void)
{
  8014dc:	f3 0f 1e fb          	endbr32 
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
  8014e3:	53                   	push   %ebx
  8014e4:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8014e7:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8014ec:	83 ec 0c             	sub    $0xc,%esp
  8014ef:	53                   	push   %ebx
  8014f0:	e8 b6 ff ff ff       	call   8014ab <close>
	for (i = 0; i < MAXFD; i++)
  8014f5:	83 c3 01             	add    $0x1,%ebx
  8014f8:	83 c4 10             	add    $0x10,%esp
  8014fb:	83 fb 20             	cmp    $0x20,%ebx
  8014fe:	75 ec                	jne    8014ec <close_all+0x10>
}
  801500:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801503:	c9                   	leave  
  801504:	c3                   	ret    

00801505 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801505:	f3 0f 1e fb          	endbr32 
  801509:	55                   	push   %ebp
  80150a:	89 e5                	mov    %esp,%ebp
  80150c:	57                   	push   %edi
  80150d:	56                   	push   %esi
  80150e:	53                   	push   %ebx
  80150f:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801512:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801515:	50                   	push   %eax
  801516:	ff 75 08             	pushl  0x8(%ebp)
  801519:	e8 4f fe ff ff       	call   80136d <fd_lookup>
  80151e:	89 c3                	mov    %eax,%ebx
  801520:	83 c4 10             	add    $0x10,%esp
  801523:	85 c0                	test   %eax,%eax
  801525:	0f 88 81 00 00 00    	js     8015ac <dup+0xa7>
		return r;
	close(newfdnum);
  80152b:	83 ec 0c             	sub    $0xc,%esp
  80152e:	ff 75 0c             	pushl  0xc(%ebp)
  801531:	e8 75 ff ff ff       	call   8014ab <close>

	newfd = INDEX2FD(newfdnum);
  801536:	8b 75 0c             	mov    0xc(%ebp),%esi
  801539:	c1 e6 0c             	shl    $0xc,%esi
  80153c:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801542:	83 c4 04             	add    $0x4,%esp
  801545:	ff 75 e4             	pushl  -0x1c(%ebp)
  801548:	e8 af fd ff ff       	call   8012fc <fd2data>
  80154d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80154f:	89 34 24             	mov    %esi,(%esp)
  801552:	e8 a5 fd ff ff       	call   8012fc <fd2data>
  801557:	83 c4 10             	add    $0x10,%esp
  80155a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80155c:	89 d8                	mov    %ebx,%eax
  80155e:	c1 e8 16             	shr    $0x16,%eax
  801561:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801568:	a8 01                	test   $0x1,%al
  80156a:	74 11                	je     80157d <dup+0x78>
  80156c:	89 d8                	mov    %ebx,%eax
  80156e:	c1 e8 0c             	shr    $0xc,%eax
  801571:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801578:	f6 c2 01             	test   $0x1,%dl
  80157b:	75 39                	jne    8015b6 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80157d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801580:	89 d0                	mov    %edx,%eax
  801582:	c1 e8 0c             	shr    $0xc,%eax
  801585:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80158c:	83 ec 0c             	sub    $0xc,%esp
  80158f:	25 07 0e 00 00       	and    $0xe07,%eax
  801594:	50                   	push   %eax
  801595:	56                   	push   %esi
  801596:	6a 00                	push   $0x0
  801598:	52                   	push   %edx
  801599:	6a 00                	push   $0x0
  80159b:	e8 bc f6 ff ff       	call   800c5c <sys_page_map>
  8015a0:	89 c3                	mov    %eax,%ebx
  8015a2:	83 c4 20             	add    $0x20,%esp
  8015a5:	85 c0                	test   %eax,%eax
  8015a7:	78 31                	js     8015da <dup+0xd5>
		goto err;

	return newfdnum;
  8015a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8015ac:	89 d8                	mov    %ebx,%eax
  8015ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015b1:	5b                   	pop    %ebx
  8015b2:	5e                   	pop    %esi
  8015b3:	5f                   	pop    %edi
  8015b4:	5d                   	pop    %ebp
  8015b5:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015b6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015bd:	83 ec 0c             	sub    $0xc,%esp
  8015c0:	25 07 0e 00 00       	and    $0xe07,%eax
  8015c5:	50                   	push   %eax
  8015c6:	57                   	push   %edi
  8015c7:	6a 00                	push   $0x0
  8015c9:	53                   	push   %ebx
  8015ca:	6a 00                	push   $0x0
  8015cc:	e8 8b f6 ff ff       	call   800c5c <sys_page_map>
  8015d1:	89 c3                	mov    %eax,%ebx
  8015d3:	83 c4 20             	add    $0x20,%esp
  8015d6:	85 c0                	test   %eax,%eax
  8015d8:	79 a3                	jns    80157d <dup+0x78>
	sys_page_unmap(0, newfd);
  8015da:	83 ec 08             	sub    $0x8,%esp
  8015dd:	56                   	push   %esi
  8015de:	6a 00                	push   $0x0
  8015e0:	e8 bd f6 ff ff       	call   800ca2 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8015e5:	83 c4 08             	add    $0x8,%esp
  8015e8:	57                   	push   %edi
  8015e9:	6a 00                	push   $0x0
  8015eb:	e8 b2 f6 ff ff       	call   800ca2 <sys_page_unmap>
	return r;
  8015f0:	83 c4 10             	add    $0x10,%esp
  8015f3:	eb b7                	jmp    8015ac <dup+0xa7>

008015f5 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015f5:	f3 0f 1e fb          	endbr32 
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
  8015fc:	53                   	push   %ebx
  8015fd:	83 ec 1c             	sub    $0x1c,%esp
  801600:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801603:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801606:	50                   	push   %eax
  801607:	53                   	push   %ebx
  801608:	e8 60 fd ff ff       	call   80136d <fd_lookup>
  80160d:	83 c4 10             	add    $0x10,%esp
  801610:	85 c0                	test   %eax,%eax
  801612:	78 3f                	js     801653 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801614:	83 ec 08             	sub    $0x8,%esp
  801617:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80161a:	50                   	push   %eax
  80161b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161e:	ff 30                	pushl  (%eax)
  801620:	e8 9c fd ff ff       	call   8013c1 <dev_lookup>
  801625:	83 c4 10             	add    $0x10,%esp
  801628:	85 c0                	test   %eax,%eax
  80162a:	78 27                	js     801653 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80162c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80162f:	8b 42 08             	mov    0x8(%edx),%eax
  801632:	83 e0 03             	and    $0x3,%eax
  801635:	83 f8 01             	cmp    $0x1,%eax
  801638:	74 1e                	je     801658 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80163a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80163d:	8b 40 08             	mov    0x8(%eax),%eax
  801640:	85 c0                	test   %eax,%eax
  801642:	74 35                	je     801679 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801644:	83 ec 04             	sub    $0x4,%esp
  801647:	ff 75 10             	pushl  0x10(%ebp)
  80164a:	ff 75 0c             	pushl  0xc(%ebp)
  80164d:	52                   	push   %edx
  80164e:	ff d0                	call   *%eax
  801650:	83 c4 10             	add    $0x10,%esp
}
  801653:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801656:	c9                   	leave  
  801657:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801658:	a1 08 40 80 00       	mov    0x804008,%eax
  80165d:	8b 40 48             	mov    0x48(%eax),%eax
  801660:	83 ec 04             	sub    $0x4,%esp
  801663:	53                   	push   %ebx
  801664:	50                   	push   %eax
  801665:	68 e1 2c 80 00       	push   $0x802ce1
  80166a:	e8 5a eb ff ff       	call   8001c9 <cprintf>
		return -E_INVAL;
  80166f:	83 c4 10             	add    $0x10,%esp
  801672:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801677:	eb da                	jmp    801653 <read+0x5e>
		return -E_NOT_SUPP;
  801679:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80167e:	eb d3                	jmp    801653 <read+0x5e>

00801680 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801680:	f3 0f 1e fb          	endbr32 
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
  801687:	57                   	push   %edi
  801688:	56                   	push   %esi
  801689:	53                   	push   %ebx
  80168a:	83 ec 0c             	sub    $0xc,%esp
  80168d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801690:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801693:	bb 00 00 00 00       	mov    $0x0,%ebx
  801698:	eb 02                	jmp    80169c <readn+0x1c>
  80169a:	01 c3                	add    %eax,%ebx
  80169c:	39 f3                	cmp    %esi,%ebx
  80169e:	73 21                	jae    8016c1 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016a0:	83 ec 04             	sub    $0x4,%esp
  8016a3:	89 f0                	mov    %esi,%eax
  8016a5:	29 d8                	sub    %ebx,%eax
  8016a7:	50                   	push   %eax
  8016a8:	89 d8                	mov    %ebx,%eax
  8016aa:	03 45 0c             	add    0xc(%ebp),%eax
  8016ad:	50                   	push   %eax
  8016ae:	57                   	push   %edi
  8016af:	e8 41 ff ff ff       	call   8015f5 <read>
		if (m < 0)
  8016b4:	83 c4 10             	add    $0x10,%esp
  8016b7:	85 c0                	test   %eax,%eax
  8016b9:	78 04                	js     8016bf <readn+0x3f>
			return m;
		if (m == 0)
  8016bb:	75 dd                	jne    80169a <readn+0x1a>
  8016bd:	eb 02                	jmp    8016c1 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016bf:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8016c1:	89 d8                	mov    %ebx,%eax
  8016c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016c6:	5b                   	pop    %ebx
  8016c7:	5e                   	pop    %esi
  8016c8:	5f                   	pop    %edi
  8016c9:	5d                   	pop    %ebp
  8016ca:	c3                   	ret    

008016cb <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016cb:	f3 0f 1e fb          	endbr32 
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
  8016d2:	53                   	push   %ebx
  8016d3:	83 ec 1c             	sub    $0x1c,%esp
  8016d6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016d9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016dc:	50                   	push   %eax
  8016dd:	53                   	push   %ebx
  8016de:	e8 8a fc ff ff       	call   80136d <fd_lookup>
  8016e3:	83 c4 10             	add    $0x10,%esp
  8016e6:	85 c0                	test   %eax,%eax
  8016e8:	78 3a                	js     801724 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016ea:	83 ec 08             	sub    $0x8,%esp
  8016ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016f0:	50                   	push   %eax
  8016f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f4:	ff 30                	pushl  (%eax)
  8016f6:	e8 c6 fc ff ff       	call   8013c1 <dev_lookup>
  8016fb:	83 c4 10             	add    $0x10,%esp
  8016fe:	85 c0                	test   %eax,%eax
  801700:	78 22                	js     801724 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801702:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801705:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801709:	74 1e                	je     801729 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80170b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80170e:	8b 52 0c             	mov    0xc(%edx),%edx
  801711:	85 d2                	test   %edx,%edx
  801713:	74 35                	je     80174a <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801715:	83 ec 04             	sub    $0x4,%esp
  801718:	ff 75 10             	pushl  0x10(%ebp)
  80171b:	ff 75 0c             	pushl  0xc(%ebp)
  80171e:	50                   	push   %eax
  80171f:	ff d2                	call   *%edx
  801721:	83 c4 10             	add    $0x10,%esp
}
  801724:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801727:	c9                   	leave  
  801728:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801729:	a1 08 40 80 00       	mov    0x804008,%eax
  80172e:	8b 40 48             	mov    0x48(%eax),%eax
  801731:	83 ec 04             	sub    $0x4,%esp
  801734:	53                   	push   %ebx
  801735:	50                   	push   %eax
  801736:	68 fd 2c 80 00       	push   $0x802cfd
  80173b:	e8 89 ea ff ff       	call   8001c9 <cprintf>
		return -E_INVAL;
  801740:	83 c4 10             	add    $0x10,%esp
  801743:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801748:	eb da                	jmp    801724 <write+0x59>
		return -E_NOT_SUPP;
  80174a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80174f:	eb d3                	jmp    801724 <write+0x59>

00801751 <seek>:

int
seek(int fdnum, off_t offset)
{
  801751:	f3 0f 1e fb          	endbr32 
  801755:	55                   	push   %ebp
  801756:	89 e5                	mov    %esp,%ebp
  801758:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80175b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80175e:	50                   	push   %eax
  80175f:	ff 75 08             	pushl  0x8(%ebp)
  801762:	e8 06 fc ff ff       	call   80136d <fd_lookup>
  801767:	83 c4 10             	add    $0x10,%esp
  80176a:	85 c0                	test   %eax,%eax
  80176c:	78 0e                	js     80177c <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80176e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801774:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801777:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80177c:	c9                   	leave  
  80177d:	c3                   	ret    

0080177e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80177e:	f3 0f 1e fb          	endbr32 
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
  801785:	53                   	push   %ebx
  801786:	83 ec 1c             	sub    $0x1c,%esp
  801789:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80178c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80178f:	50                   	push   %eax
  801790:	53                   	push   %ebx
  801791:	e8 d7 fb ff ff       	call   80136d <fd_lookup>
  801796:	83 c4 10             	add    $0x10,%esp
  801799:	85 c0                	test   %eax,%eax
  80179b:	78 37                	js     8017d4 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80179d:	83 ec 08             	sub    $0x8,%esp
  8017a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017a3:	50                   	push   %eax
  8017a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a7:	ff 30                	pushl  (%eax)
  8017a9:	e8 13 fc ff ff       	call   8013c1 <dev_lookup>
  8017ae:	83 c4 10             	add    $0x10,%esp
  8017b1:	85 c0                	test   %eax,%eax
  8017b3:	78 1f                	js     8017d4 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017bc:	74 1b                	je     8017d9 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8017be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c1:	8b 52 18             	mov    0x18(%edx),%edx
  8017c4:	85 d2                	test   %edx,%edx
  8017c6:	74 32                	je     8017fa <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017c8:	83 ec 08             	sub    $0x8,%esp
  8017cb:	ff 75 0c             	pushl  0xc(%ebp)
  8017ce:	50                   	push   %eax
  8017cf:	ff d2                	call   *%edx
  8017d1:	83 c4 10             	add    $0x10,%esp
}
  8017d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017d7:	c9                   	leave  
  8017d8:	c3                   	ret    
			thisenv->env_id, fdnum);
  8017d9:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8017de:	8b 40 48             	mov    0x48(%eax),%eax
  8017e1:	83 ec 04             	sub    $0x4,%esp
  8017e4:	53                   	push   %ebx
  8017e5:	50                   	push   %eax
  8017e6:	68 c0 2c 80 00       	push   $0x802cc0
  8017eb:	e8 d9 e9 ff ff       	call   8001c9 <cprintf>
		return -E_INVAL;
  8017f0:	83 c4 10             	add    $0x10,%esp
  8017f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017f8:	eb da                	jmp    8017d4 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8017fa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017ff:	eb d3                	jmp    8017d4 <ftruncate+0x56>

00801801 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801801:	f3 0f 1e fb          	endbr32 
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
  801808:	53                   	push   %ebx
  801809:	83 ec 1c             	sub    $0x1c,%esp
  80180c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80180f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801812:	50                   	push   %eax
  801813:	ff 75 08             	pushl  0x8(%ebp)
  801816:	e8 52 fb ff ff       	call   80136d <fd_lookup>
  80181b:	83 c4 10             	add    $0x10,%esp
  80181e:	85 c0                	test   %eax,%eax
  801820:	78 4b                	js     80186d <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801822:	83 ec 08             	sub    $0x8,%esp
  801825:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801828:	50                   	push   %eax
  801829:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80182c:	ff 30                	pushl  (%eax)
  80182e:	e8 8e fb ff ff       	call   8013c1 <dev_lookup>
  801833:	83 c4 10             	add    $0x10,%esp
  801836:	85 c0                	test   %eax,%eax
  801838:	78 33                	js     80186d <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80183a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80183d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801841:	74 2f                	je     801872 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801843:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801846:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80184d:	00 00 00 
	stat->st_isdir = 0;
  801850:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801857:	00 00 00 
	stat->st_dev = dev;
  80185a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801860:	83 ec 08             	sub    $0x8,%esp
  801863:	53                   	push   %ebx
  801864:	ff 75 f0             	pushl  -0x10(%ebp)
  801867:	ff 50 14             	call   *0x14(%eax)
  80186a:	83 c4 10             	add    $0x10,%esp
}
  80186d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801870:	c9                   	leave  
  801871:	c3                   	ret    
		return -E_NOT_SUPP;
  801872:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801877:	eb f4                	jmp    80186d <fstat+0x6c>

00801879 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801879:	f3 0f 1e fb          	endbr32 
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
  801880:	56                   	push   %esi
  801881:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801882:	83 ec 08             	sub    $0x8,%esp
  801885:	6a 00                	push   $0x0
  801887:	ff 75 08             	pushl  0x8(%ebp)
  80188a:	e8 fb 01 00 00       	call   801a8a <open>
  80188f:	89 c3                	mov    %eax,%ebx
  801891:	83 c4 10             	add    $0x10,%esp
  801894:	85 c0                	test   %eax,%eax
  801896:	78 1b                	js     8018b3 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801898:	83 ec 08             	sub    $0x8,%esp
  80189b:	ff 75 0c             	pushl  0xc(%ebp)
  80189e:	50                   	push   %eax
  80189f:	e8 5d ff ff ff       	call   801801 <fstat>
  8018a4:	89 c6                	mov    %eax,%esi
	close(fd);
  8018a6:	89 1c 24             	mov    %ebx,(%esp)
  8018a9:	e8 fd fb ff ff       	call   8014ab <close>
	return r;
  8018ae:	83 c4 10             	add    $0x10,%esp
  8018b1:	89 f3                	mov    %esi,%ebx
}
  8018b3:	89 d8                	mov    %ebx,%eax
  8018b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018b8:	5b                   	pop    %ebx
  8018b9:	5e                   	pop    %esi
  8018ba:	5d                   	pop    %ebp
  8018bb:	c3                   	ret    

008018bc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
  8018bf:	56                   	push   %esi
  8018c0:	53                   	push   %ebx
  8018c1:	89 c6                	mov    %eax,%esi
  8018c3:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8018c5:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8018cc:	74 27                	je     8018f5 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018ce:	6a 07                	push   $0x7
  8018d0:	68 00 50 80 00       	push   $0x805000
  8018d5:	56                   	push   %esi
  8018d6:	ff 35 00 40 80 00    	pushl  0x804000
  8018dc:	e8 72 f9 ff ff       	call   801253 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8018e1:	83 c4 0c             	add    $0xc,%esp
  8018e4:	6a 00                	push   $0x0
  8018e6:	53                   	push   %ebx
  8018e7:	6a 00                	push   $0x0
  8018e9:	e8 e0 f8 ff ff       	call   8011ce <ipc_recv>
}
  8018ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018f1:	5b                   	pop    %ebx
  8018f2:	5e                   	pop    %esi
  8018f3:	5d                   	pop    %ebp
  8018f4:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8018f5:	83 ec 0c             	sub    $0xc,%esp
  8018f8:	6a 01                	push   $0x1
  8018fa:	e8 ac f9 ff ff       	call   8012ab <ipc_find_env>
  8018ff:	a3 00 40 80 00       	mov    %eax,0x804000
  801904:	83 c4 10             	add    $0x10,%esp
  801907:	eb c5                	jmp    8018ce <fsipc+0x12>

00801909 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801909:	f3 0f 1e fb          	endbr32 
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
  801910:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801913:	8b 45 08             	mov    0x8(%ebp),%eax
  801916:	8b 40 0c             	mov    0xc(%eax),%eax
  801919:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80191e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801921:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801926:	ba 00 00 00 00       	mov    $0x0,%edx
  80192b:	b8 02 00 00 00       	mov    $0x2,%eax
  801930:	e8 87 ff ff ff       	call   8018bc <fsipc>
}
  801935:	c9                   	leave  
  801936:	c3                   	ret    

00801937 <devfile_flush>:
{
  801937:	f3 0f 1e fb          	endbr32 
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
  80193e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801941:	8b 45 08             	mov    0x8(%ebp),%eax
  801944:	8b 40 0c             	mov    0xc(%eax),%eax
  801947:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80194c:	ba 00 00 00 00       	mov    $0x0,%edx
  801951:	b8 06 00 00 00       	mov    $0x6,%eax
  801956:	e8 61 ff ff ff       	call   8018bc <fsipc>
}
  80195b:	c9                   	leave  
  80195c:	c3                   	ret    

0080195d <devfile_stat>:
{
  80195d:	f3 0f 1e fb          	endbr32 
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
  801964:	53                   	push   %ebx
  801965:	83 ec 04             	sub    $0x4,%esp
  801968:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80196b:	8b 45 08             	mov    0x8(%ebp),%eax
  80196e:	8b 40 0c             	mov    0xc(%eax),%eax
  801971:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801976:	ba 00 00 00 00       	mov    $0x0,%edx
  80197b:	b8 05 00 00 00       	mov    $0x5,%eax
  801980:	e8 37 ff ff ff       	call   8018bc <fsipc>
  801985:	85 c0                	test   %eax,%eax
  801987:	78 2c                	js     8019b5 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801989:	83 ec 08             	sub    $0x8,%esp
  80198c:	68 00 50 80 00       	push   $0x805000
  801991:	53                   	push   %ebx
  801992:	e8 3c ee ff ff       	call   8007d3 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801997:	a1 80 50 80 00       	mov    0x805080,%eax
  80199c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019a2:	a1 84 50 80 00       	mov    0x805084,%eax
  8019a7:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8019ad:	83 c4 10             	add    $0x10,%esp
  8019b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <devfile_write>:
{
  8019ba:	f3 0f 1e fb          	endbr32 
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
  8019c1:	83 ec 0c             	sub    $0xc,%esp
  8019c4:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8019ca:	8b 52 0c             	mov    0xc(%edx),%edx
  8019cd:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  8019d3:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8019d8:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8019dd:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  8019e0:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  8019e5:	50                   	push   %eax
  8019e6:	ff 75 0c             	pushl  0xc(%ebp)
  8019e9:	68 08 50 80 00       	push   $0x805008
  8019ee:	e8 96 ef ff ff       	call   800989 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  8019f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f8:	b8 04 00 00 00       	mov    $0x4,%eax
  8019fd:	e8 ba fe ff ff       	call   8018bc <fsipc>
}
  801a02:	c9                   	leave  
  801a03:	c3                   	ret    

00801a04 <devfile_read>:
{
  801a04:	f3 0f 1e fb          	endbr32 
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
  801a0b:	56                   	push   %esi
  801a0c:	53                   	push   %ebx
  801a0d:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a10:	8b 45 08             	mov    0x8(%ebp),%eax
  801a13:	8b 40 0c             	mov    0xc(%eax),%eax
  801a16:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a1b:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a21:	ba 00 00 00 00       	mov    $0x0,%edx
  801a26:	b8 03 00 00 00       	mov    $0x3,%eax
  801a2b:	e8 8c fe ff ff       	call   8018bc <fsipc>
  801a30:	89 c3                	mov    %eax,%ebx
  801a32:	85 c0                	test   %eax,%eax
  801a34:	78 1f                	js     801a55 <devfile_read+0x51>
	assert(r <= n);
  801a36:	39 f0                	cmp    %esi,%eax
  801a38:	77 24                	ja     801a5e <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801a3a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a3f:	7f 33                	jg     801a74 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a41:	83 ec 04             	sub    $0x4,%esp
  801a44:	50                   	push   %eax
  801a45:	68 00 50 80 00       	push   $0x805000
  801a4a:	ff 75 0c             	pushl  0xc(%ebp)
  801a4d:	e8 37 ef ff ff       	call   800989 <memmove>
	return r;
  801a52:	83 c4 10             	add    $0x10,%esp
}
  801a55:	89 d8                	mov    %ebx,%eax
  801a57:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a5a:	5b                   	pop    %ebx
  801a5b:	5e                   	pop    %esi
  801a5c:	5d                   	pop    %ebp
  801a5d:	c3                   	ret    
	assert(r <= n);
  801a5e:	68 30 2d 80 00       	push   $0x802d30
  801a63:	68 37 2d 80 00       	push   $0x802d37
  801a68:	6a 7c                	push   $0x7c
  801a6a:	68 4c 2d 80 00       	push   $0x802d4c
  801a6f:	e8 76 0a 00 00       	call   8024ea <_panic>
	assert(r <= PGSIZE);
  801a74:	68 57 2d 80 00       	push   $0x802d57
  801a79:	68 37 2d 80 00       	push   $0x802d37
  801a7e:	6a 7d                	push   $0x7d
  801a80:	68 4c 2d 80 00       	push   $0x802d4c
  801a85:	e8 60 0a 00 00       	call   8024ea <_panic>

00801a8a <open>:
{
  801a8a:	f3 0f 1e fb          	endbr32 
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
  801a91:	56                   	push   %esi
  801a92:	53                   	push   %ebx
  801a93:	83 ec 1c             	sub    $0x1c,%esp
  801a96:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a99:	56                   	push   %esi
  801a9a:	e8 f1 ec ff ff       	call   800790 <strlen>
  801a9f:	83 c4 10             	add    $0x10,%esp
  801aa2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801aa7:	7f 6c                	jg     801b15 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801aa9:	83 ec 0c             	sub    $0xc,%esp
  801aac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aaf:	50                   	push   %eax
  801ab0:	e8 62 f8 ff ff       	call   801317 <fd_alloc>
  801ab5:	89 c3                	mov    %eax,%ebx
  801ab7:	83 c4 10             	add    $0x10,%esp
  801aba:	85 c0                	test   %eax,%eax
  801abc:	78 3c                	js     801afa <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801abe:	83 ec 08             	sub    $0x8,%esp
  801ac1:	56                   	push   %esi
  801ac2:	68 00 50 80 00       	push   $0x805000
  801ac7:	e8 07 ed ff ff       	call   8007d3 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801acc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801acf:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ad4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ad7:	b8 01 00 00 00       	mov    $0x1,%eax
  801adc:	e8 db fd ff ff       	call   8018bc <fsipc>
  801ae1:	89 c3                	mov    %eax,%ebx
  801ae3:	83 c4 10             	add    $0x10,%esp
  801ae6:	85 c0                	test   %eax,%eax
  801ae8:	78 19                	js     801b03 <open+0x79>
	return fd2num(fd);
  801aea:	83 ec 0c             	sub    $0xc,%esp
  801aed:	ff 75 f4             	pushl  -0xc(%ebp)
  801af0:	e8 f3 f7 ff ff       	call   8012e8 <fd2num>
  801af5:	89 c3                	mov    %eax,%ebx
  801af7:	83 c4 10             	add    $0x10,%esp
}
  801afa:	89 d8                	mov    %ebx,%eax
  801afc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aff:	5b                   	pop    %ebx
  801b00:	5e                   	pop    %esi
  801b01:	5d                   	pop    %ebp
  801b02:	c3                   	ret    
		fd_close(fd, 0);
  801b03:	83 ec 08             	sub    $0x8,%esp
  801b06:	6a 00                	push   $0x0
  801b08:	ff 75 f4             	pushl  -0xc(%ebp)
  801b0b:	e8 10 f9 ff ff       	call   801420 <fd_close>
		return r;
  801b10:	83 c4 10             	add    $0x10,%esp
  801b13:	eb e5                	jmp    801afa <open+0x70>
		return -E_BAD_PATH;
  801b15:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b1a:	eb de                	jmp    801afa <open+0x70>

00801b1c <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b1c:	f3 0f 1e fb          	endbr32 
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
  801b23:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b26:	ba 00 00 00 00       	mov    $0x0,%edx
  801b2b:	b8 08 00 00 00       	mov    $0x8,%eax
  801b30:	e8 87 fd ff ff       	call   8018bc <fsipc>
}
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801b37:	f3 0f 1e fb          	endbr32 
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
  801b3e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801b41:	68 63 2d 80 00       	push   $0x802d63
  801b46:	ff 75 0c             	pushl  0xc(%ebp)
  801b49:	e8 85 ec ff ff       	call   8007d3 <strcpy>
	return 0;
}
  801b4e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b53:	c9                   	leave  
  801b54:	c3                   	ret    

00801b55 <devsock_close>:
{
  801b55:	f3 0f 1e fb          	endbr32 
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
  801b5c:	53                   	push   %ebx
  801b5d:	83 ec 10             	sub    $0x10,%esp
  801b60:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801b63:	53                   	push   %ebx
  801b64:	e8 64 0a 00 00       	call   8025cd <pageref>
  801b69:	89 c2                	mov    %eax,%edx
  801b6b:	83 c4 10             	add    $0x10,%esp
		return 0;
  801b6e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801b73:	83 fa 01             	cmp    $0x1,%edx
  801b76:	74 05                	je     801b7d <devsock_close+0x28>
}
  801b78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b7b:	c9                   	leave  
  801b7c:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801b7d:	83 ec 0c             	sub    $0xc,%esp
  801b80:	ff 73 0c             	pushl  0xc(%ebx)
  801b83:	e8 e3 02 00 00       	call   801e6b <nsipc_close>
  801b88:	83 c4 10             	add    $0x10,%esp
  801b8b:	eb eb                	jmp    801b78 <devsock_close+0x23>

00801b8d <devsock_write>:
{
  801b8d:	f3 0f 1e fb          	endbr32 
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
  801b94:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801b97:	6a 00                	push   $0x0
  801b99:	ff 75 10             	pushl  0x10(%ebp)
  801b9c:	ff 75 0c             	pushl  0xc(%ebp)
  801b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba2:	ff 70 0c             	pushl  0xc(%eax)
  801ba5:	e8 b5 03 00 00       	call   801f5f <nsipc_send>
}
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <devsock_read>:
{
  801bac:	f3 0f 1e fb          	endbr32 
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
  801bb3:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801bb6:	6a 00                	push   $0x0
  801bb8:	ff 75 10             	pushl  0x10(%ebp)
  801bbb:	ff 75 0c             	pushl  0xc(%ebp)
  801bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc1:	ff 70 0c             	pushl  0xc(%eax)
  801bc4:	e8 1f 03 00 00       	call   801ee8 <nsipc_recv>
}
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    

00801bcb <fd2sockid>:
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
  801bce:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801bd1:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801bd4:	52                   	push   %edx
  801bd5:	50                   	push   %eax
  801bd6:	e8 92 f7 ff ff       	call   80136d <fd_lookup>
  801bdb:	83 c4 10             	add    $0x10,%esp
  801bde:	85 c0                	test   %eax,%eax
  801be0:	78 10                	js     801bf2 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be5:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801beb:	39 08                	cmp    %ecx,(%eax)
  801bed:	75 05                	jne    801bf4 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801bef:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801bf2:	c9                   	leave  
  801bf3:	c3                   	ret    
		return -E_NOT_SUPP;
  801bf4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bf9:	eb f7                	jmp    801bf2 <fd2sockid+0x27>

00801bfb <alloc_sockfd>:
{
  801bfb:	55                   	push   %ebp
  801bfc:	89 e5                	mov    %esp,%ebp
  801bfe:	56                   	push   %esi
  801bff:	53                   	push   %ebx
  801c00:	83 ec 1c             	sub    $0x1c,%esp
  801c03:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801c05:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c08:	50                   	push   %eax
  801c09:	e8 09 f7 ff ff       	call   801317 <fd_alloc>
  801c0e:	89 c3                	mov    %eax,%ebx
  801c10:	83 c4 10             	add    $0x10,%esp
  801c13:	85 c0                	test   %eax,%eax
  801c15:	78 43                	js     801c5a <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801c17:	83 ec 04             	sub    $0x4,%esp
  801c1a:	68 07 04 00 00       	push   $0x407
  801c1f:	ff 75 f4             	pushl  -0xc(%ebp)
  801c22:	6a 00                	push   $0x0
  801c24:	e8 ec ef ff ff       	call   800c15 <sys_page_alloc>
  801c29:	89 c3                	mov    %eax,%ebx
  801c2b:	83 c4 10             	add    $0x10,%esp
  801c2e:	85 c0                	test   %eax,%eax
  801c30:	78 28                	js     801c5a <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c35:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c3b:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c40:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801c47:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801c4a:	83 ec 0c             	sub    $0xc,%esp
  801c4d:	50                   	push   %eax
  801c4e:	e8 95 f6 ff ff       	call   8012e8 <fd2num>
  801c53:	89 c3                	mov    %eax,%ebx
  801c55:	83 c4 10             	add    $0x10,%esp
  801c58:	eb 0c                	jmp    801c66 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801c5a:	83 ec 0c             	sub    $0xc,%esp
  801c5d:	56                   	push   %esi
  801c5e:	e8 08 02 00 00       	call   801e6b <nsipc_close>
		return r;
  801c63:	83 c4 10             	add    $0x10,%esp
}
  801c66:	89 d8                	mov    %ebx,%eax
  801c68:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c6b:	5b                   	pop    %ebx
  801c6c:	5e                   	pop    %esi
  801c6d:	5d                   	pop    %ebp
  801c6e:	c3                   	ret    

00801c6f <accept>:
{
  801c6f:	f3 0f 1e fb          	endbr32 
  801c73:	55                   	push   %ebp
  801c74:	89 e5                	mov    %esp,%ebp
  801c76:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c79:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7c:	e8 4a ff ff ff       	call   801bcb <fd2sockid>
  801c81:	85 c0                	test   %eax,%eax
  801c83:	78 1b                	js     801ca0 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c85:	83 ec 04             	sub    $0x4,%esp
  801c88:	ff 75 10             	pushl  0x10(%ebp)
  801c8b:	ff 75 0c             	pushl  0xc(%ebp)
  801c8e:	50                   	push   %eax
  801c8f:	e8 22 01 00 00       	call   801db6 <nsipc_accept>
  801c94:	83 c4 10             	add    $0x10,%esp
  801c97:	85 c0                	test   %eax,%eax
  801c99:	78 05                	js     801ca0 <accept+0x31>
	return alloc_sockfd(r);
  801c9b:	e8 5b ff ff ff       	call   801bfb <alloc_sockfd>
}
  801ca0:	c9                   	leave  
  801ca1:	c3                   	ret    

00801ca2 <bind>:
{
  801ca2:	f3 0f 1e fb          	endbr32 
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
  801ca9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cac:	8b 45 08             	mov    0x8(%ebp),%eax
  801caf:	e8 17 ff ff ff       	call   801bcb <fd2sockid>
  801cb4:	85 c0                	test   %eax,%eax
  801cb6:	78 12                	js     801cca <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801cb8:	83 ec 04             	sub    $0x4,%esp
  801cbb:	ff 75 10             	pushl  0x10(%ebp)
  801cbe:	ff 75 0c             	pushl  0xc(%ebp)
  801cc1:	50                   	push   %eax
  801cc2:	e8 45 01 00 00       	call   801e0c <nsipc_bind>
  801cc7:	83 c4 10             	add    $0x10,%esp
}
  801cca:	c9                   	leave  
  801ccb:	c3                   	ret    

00801ccc <shutdown>:
{
  801ccc:	f3 0f 1e fb          	endbr32 
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd9:	e8 ed fe ff ff       	call   801bcb <fd2sockid>
  801cde:	85 c0                	test   %eax,%eax
  801ce0:	78 0f                	js     801cf1 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801ce2:	83 ec 08             	sub    $0x8,%esp
  801ce5:	ff 75 0c             	pushl  0xc(%ebp)
  801ce8:	50                   	push   %eax
  801ce9:	e8 57 01 00 00       	call   801e45 <nsipc_shutdown>
  801cee:	83 c4 10             	add    $0x10,%esp
}
  801cf1:	c9                   	leave  
  801cf2:	c3                   	ret    

00801cf3 <connect>:
{
  801cf3:	f3 0f 1e fb          	endbr32 
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
  801cfa:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801d00:	e8 c6 fe ff ff       	call   801bcb <fd2sockid>
  801d05:	85 c0                	test   %eax,%eax
  801d07:	78 12                	js     801d1b <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801d09:	83 ec 04             	sub    $0x4,%esp
  801d0c:	ff 75 10             	pushl  0x10(%ebp)
  801d0f:	ff 75 0c             	pushl  0xc(%ebp)
  801d12:	50                   	push   %eax
  801d13:	e8 71 01 00 00       	call   801e89 <nsipc_connect>
  801d18:	83 c4 10             	add    $0x10,%esp
}
  801d1b:	c9                   	leave  
  801d1c:	c3                   	ret    

00801d1d <listen>:
{
  801d1d:	f3 0f 1e fb          	endbr32 
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
  801d24:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d27:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2a:	e8 9c fe ff ff       	call   801bcb <fd2sockid>
  801d2f:	85 c0                	test   %eax,%eax
  801d31:	78 0f                	js     801d42 <listen+0x25>
	return nsipc_listen(r, backlog);
  801d33:	83 ec 08             	sub    $0x8,%esp
  801d36:	ff 75 0c             	pushl  0xc(%ebp)
  801d39:	50                   	push   %eax
  801d3a:	e8 83 01 00 00       	call   801ec2 <nsipc_listen>
  801d3f:	83 c4 10             	add    $0x10,%esp
}
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <socket>:

int
socket(int domain, int type, int protocol)
{
  801d44:	f3 0f 1e fb          	endbr32 
  801d48:	55                   	push   %ebp
  801d49:	89 e5                	mov    %esp,%ebp
  801d4b:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801d4e:	ff 75 10             	pushl  0x10(%ebp)
  801d51:	ff 75 0c             	pushl  0xc(%ebp)
  801d54:	ff 75 08             	pushl  0x8(%ebp)
  801d57:	e8 65 02 00 00       	call   801fc1 <nsipc_socket>
  801d5c:	83 c4 10             	add    $0x10,%esp
  801d5f:	85 c0                	test   %eax,%eax
  801d61:	78 05                	js     801d68 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801d63:	e8 93 fe ff ff       	call   801bfb <alloc_sockfd>
}
  801d68:	c9                   	leave  
  801d69:	c3                   	ret    

00801d6a <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
  801d6d:	53                   	push   %ebx
  801d6e:	83 ec 04             	sub    $0x4,%esp
  801d71:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801d73:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801d7a:	74 26                	je     801da2 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801d7c:	6a 07                	push   $0x7
  801d7e:	68 00 60 80 00       	push   $0x806000
  801d83:	53                   	push   %ebx
  801d84:	ff 35 04 40 80 00    	pushl  0x804004
  801d8a:	e8 c4 f4 ff ff       	call   801253 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801d8f:	83 c4 0c             	add    $0xc,%esp
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	e8 31 f4 ff ff       	call   8011ce <ipc_recv>
}
  801d9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801da0:	c9                   	leave  
  801da1:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801da2:	83 ec 0c             	sub    $0xc,%esp
  801da5:	6a 02                	push   $0x2
  801da7:	e8 ff f4 ff ff       	call   8012ab <ipc_find_env>
  801dac:	a3 04 40 80 00       	mov    %eax,0x804004
  801db1:	83 c4 10             	add    $0x10,%esp
  801db4:	eb c6                	jmp    801d7c <nsipc+0x12>

00801db6 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801db6:	f3 0f 1e fb          	endbr32 
  801dba:	55                   	push   %ebp
  801dbb:	89 e5                	mov    %esp,%ebp
  801dbd:	56                   	push   %esi
  801dbe:	53                   	push   %ebx
  801dbf:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc5:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801dca:	8b 06                	mov    (%esi),%eax
  801dcc:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801dd1:	b8 01 00 00 00       	mov    $0x1,%eax
  801dd6:	e8 8f ff ff ff       	call   801d6a <nsipc>
  801ddb:	89 c3                	mov    %eax,%ebx
  801ddd:	85 c0                	test   %eax,%eax
  801ddf:	79 09                	jns    801dea <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801de1:	89 d8                	mov    %ebx,%eax
  801de3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801de6:	5b                   	pop    %ebx
  801de7:	5e                   	pop    %esi
  801de8:	5d                   	pop    %ebp
  801de9:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801dea:	83 ec 04             	sub    $0x4,%esp
  801ded:	ff 35 10 60 80 00    	pushl  0x806010
  801df3:	68 00 60 80 00       	push   $0x806000
  801df8:	ff 75 0c             	pushl  0xc(%ebp)
  801dfb:	e8 89 eb ff ff       	call   800989 <memmove>
		*addrlen = ret->ret_addrlen;
  801e00:	a1 10 60 80 00       	mov    0x806010,%eax
  801e05:	89 06                	mov    %eax,(%esi)
  801e07:	83 c4 10             	add    $0x10,%esp
	return r;
  801e0a:	eb d5                	jmp    801de1 <nsipc_accept+0x2b>

00801e0c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e0c:	f3 0f 1e fb          	endbr32 
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
  801e13:	53                   	push   %ebx
  801e14:	83 ec 08             	sub    $0x8,%esp
  801e17:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801e22:	53                   	push   %ebx
  801e23:	ff 75 0c             	pushl  0xc(%ebp)
  801e26:	68 04 60 80 00       	push   $0x806004
  801e2b:	e8 59 eb ff ff       	call   800989 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801e30:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801e36:	b8 02 00 00 00       	mov    $0x2,%eax
  801e3b:	e8 2a ff ff ff       	call   801d6a <nsipc>
}
  801e40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e43:	c9                   	leave  
  801e44:	c3                   	ret    

00801e45 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801e45:	f3 0f 1e fb          	endbr32 
  801e49:	55                   	push   %ebp
  801e4a:	89 e5                	mov    %esp,%ebp
  801e4c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e52:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e5a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801e5f:	b8 03 00 00 00       	mov    $0x3,%eax
  801e64:	e8 01 ff ff ff       	call   801d6a <nsipc>
}
  801e69:	c9                   	leave  
  801e6a:	c3                   	ret    

00801e6b <nsipc_close>:

int
nsipc_close(int s)
{
  801e6b:	f3 0f 1e fb          	endbr32 
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
  801e72:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801e75:	8b 45 08             	mov    0x8(%ebp),%eax
  801e78:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801e7d:	b8 04 00 00 00       	mov    $0x4,%eax
  801e82:	e8 e3 fe ff ff       	call   801d6a <nsipc>
}
  801e87:	c9                   	leave  
  801e88:	c3                   	ret    

00801e89 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e89:	f3 0f 1e fb          	endbr32 
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
  801e90:	53                   	push   %ebx
  801e91:	83 ec 08             	sub    $0x8,%esp
  801e94:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801e97:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9a:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801e9f:	53                   	push   %ebx
  801ea0:	ff 75 0c             	pushl  0xc(%ebp)
  801ea3:	68 04 60 80 00       	push   $0x806004
  801ea8:	e8 dc ea ff ff       	call   800989 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801ead:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801eb3:	b8 05 00 00 00       	mov    $0x5,%eax
  801eb8:	e8 ad fe ff ff       	call   801d6a <nsipc>
}
  801ebd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ec0:	c9                   	leave  
  801ec1:	c3                   	ret    

00801ec2 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801ec2:	f3 0f 1e fb          	endbr32 
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
  801ec9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecf:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801ed4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed7:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801edc:	b8 06 00 00 00       	mov    $0x6,%eax
  801ee1:	e8 84 fe ff ff       	call   801d6a <nsipc>
}
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801ee8:	f3 0f 1e fb          	endbr32 
  801eec:	55                   	push   %ebp
  801eed:	89 e5                	mov    %esp,%ebp
  801eef:	56                   	push   %esi
  801ef0:	53                   	push   %ebx
  801ef1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801efc:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801f02:	8b 45 14             	mov    0x14(%ebp),%eax
  801f05:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801f0a:	b8 07 00 00 00       	mov    $0x7,%eax
  801f0f:	e8 56 fe ff ff       	call   801d6a <nsipc>
  801f14:	89 c3                	mov    %eax,%ebx
  801f16:	85 c0                	test   %eax,%eax
  801f18:	78 26                	js     801f40 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801f1a:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801f20:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801f25:	0f 4e c6             	cmovle %esi,%eax
  801f28:	39 c3                	cmp    %eax,%ebx
  801f2a:	7f 1d                	jg     801f49 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801f2c:	83 ec 04             	sub    $0x4,%esp
  801f2f:	53                   	push   %ebx
  801f30:	68 00 60 80 00       	push   $0x806000
  801f35:	ff 75 0c             	pushl  0xc(%ebp)
  801f38:	e8 4c ea ff ff       	call   800989 <memmove>
  801f3d:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801f40:	89 d8                	mov    %ebx,%eax
  801f42:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f45:	5b                   	pop    %ebx
  801f46:	5e                   	pop    %esi
  801f47:	5d                   	pop    %ebp
  801f48:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801f49:	68 6f 2d 80 00       	push   $0x802d6f
  801f4e:	68 37 2d 80 00       	push   $0x802d37
  801f53:	6a 62                	push   $0x62
  801f55:	68 84 2d 80 00       	push   $0x802d84
  801f5a:	e8 8b 05 00 00       	call   8024ea <_panic>

00801f5f <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801f5f:	f3 0f 1e fb          	endbr32 
  801f63:	55                   	push   %ebp
  801f64:	89 e5                	mov    %esp,%ebp
  801f66:	53                   	push   %ebx
  801f67:	83 ec 04             	sub    $0x4,%esp
  801f6a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f70:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801f75:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801f7b:	7f 2e                	jg     801fab <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801f7d:	83 ec 04             	sub    $0x4,%esp
  801f80:	53                   	push   %ebx
  801f81:	ff 75 0c             	pushl  0xc(%ebp)
  801f84:	68 0c 60 80 00       	push   $0x80600c
  801f89:	e8 fb e9 ff ff       	call   800989 <memmove>
	nsipcbuf.send.req_size = size;
  801f8e:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801f94:	8b 45 14             	mov    0x14(%ebp),%eax
  801f97:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801f9c:	b8 08 00 00 00       	mov    $0x8,%eax
  801fa1:	e8 c4 fd ff ff       	call   801d6a <nsipc>
}
  801fa6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fa9:	c9                   	leave  
  801faa:	c3                   	ret    
	assert(size < 1600);
  801fab:	68 90 2d 80 00       	push   $0x802d90
  801fb0:	68 37 2d 80 00       	push   $0x802d37
  801fb5:	6a 6d                	push   $0x6d
  801fb7:	68 84 2d 80 00       	push   $0x802d84
  801fbc:	e8 29 05 00 00       	call   8024ea <_panic>

00801fc1 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801fc1:	f3 0f 1e fb          	endbr32 
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
  801fc8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fce:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801fd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd6:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801fdb:	8b 45 10             	mov    0x10(%ebp),%eax
  801fde:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801fe3:	b8 09 00 00 00       	mov    $0x9,%eax
  801fe8:	e8 7d fd ff ff       	call   801d6a <nsipc>
}
  801fed:	c9                   	leave  
  801fee:	c3                   	ret    

00801fef <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801fef:	f3 0f 1e fb          	endbr32 
  801ff3:	55                   	push   %ebp
  801ff4:	89 e5                	mov    %esp,%ebp
  801ff6:	56                   	push   %esi
  801ff7:	53                   	push   %ebx
  801ff8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ffb:	83 ec 0c             	sub    $0xc,%esp
  801ffe:	ff 75 08             	pushl  0x8(%ebp)
  802001:	e8 f6 f2 ff ff       	call   8012fc <fd2data>
  802006:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802008:	83 c4 08             	add    $0x8,%esp
  80200b:	68 9c 2d 80 00       	push   $0x802d9c
  802010:	53                   	push   %ebx
  802011:	e8 bd e7 ff ff       	call   8007d3 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802016:	8b 46 04             	mov    0x4(%esi),%eax
  802019:	2b 06                	sub    (%esi),%eax
  80201b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802021:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802028:	00 00 00 
	stat->st_dev = &devpipe;
  80202b:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  802032:	30 80 00 
	return 0;
}
  802035:	b8 00 00 00 00       	mov    $0x0,%eax
  80203a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80203d:	5b                   	pop    %ebx
  80203e:	5e                   	pop    %esi
  80203f:	5d                   	pop    %ebp
  802040:	c3                   	ret    

00802041 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802041:	f3 0f 1e fb          	endbr32 
  802045:	55                   	push   %ebp
  802046:	89 e5                	mov    %esp,%ebp
  802048:	53                   	push   %ebx
  802049:	83 ec 0c             	sub    $0xc,%esp
  80204c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80204f:	53                   	push   %ebx
  802050:	6a 00                	push   $0x0
  802052:	e8 4b ec ff ff       	call   800ca2 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802057:	89 1c 24             	mov    %ebx,(%esp)
  80205a:	e8 9d f2 ff ff       	call   8012fc <fd2data>
  80205f:	83 c4 08             	add    $0x8,%esp
  802062:	50                   	push   %eax
  802063:	6a 00                	push   $0x0
  802065:	e8 38 ec ff ff       	call   800ca2 <sys_page_unmap>
}
  80206a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80206d:	c9                   	leave  
  80206e:	c3                   	ret    

0080206f <_pipeisclosed>:
{
  80206f:	55                   	push   %ebp
  802070:	89 e5                	mov    %esp,%ebp
  802072:	57                   	push   %edi
  802073:	56                   	push   %esi
  802074:	53                   	push   %ebx
  802075:	83 ec 1c             	sub    $0x1c,%esp
  802078:	89 c7                	mov    %eax,%edi
  80207a:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80207c:	a1 08 40 80 00       	mov    0x804008,%eax
  802081:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802084:	83 ec 0c             	sub    $0xc,%esp
  802087:	57                   	push   %edi
  802088:	e8 40 05 00 00       	call   8025cd <pageref>
  80208d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802090:	89 34 24             	mov    %esi,(%esp)
  802093:	e8 35 05 00 00       	call   8025cd <pageref>
		nn = thisenv->env_runs;
  802098:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80209e:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8020a1:	83 c4 10             	add    $0x10,%esp
  8020a4:	39 cb                	cmp    %ecx,%ebx
  8020a6:	74 1b                	je     8020c3 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8020a8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8020ab:	75 cf                	jne    80207c <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8020ad:	8b 42 58             	mov    0x58(%edx),%eax
  8020b0:	6a 01                	push   $0x1
  8020b2:	50                   	push   %eax
  8020b3:	53                   	push   %ebx
  8020b4:	68 a3 2d 80 00       	push   $0x802da3
  8020b9:	e8 0b e1 ff ff       	call   8001c9 <cprintf>
  8020be:	83 c4 10             	add    $0x10,%esp
  8020c1:	eb b9                	jmp    80207c <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8020c3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8020c6:	0f 94 c0             	sete   %al
  8020c9:	0f b6 c0             	movzbl %al,%eax
}
  8020cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020cf:	5b                   	pop    %ebx
  8020d0:	5e                   	pop    %esi
  8020d1:	5f                   	pop    %edi
  8020d2:	5d                   	pop    %ebp
  8020d3:	c3                   	ret    

008020d4 <devpipe_write>:
{
  8020d4:	f3 0f 1e fb          	endbr32 
  8020d8:	55                   	push   %ebp
  8020d9:	89 e5                	mov    %esp,%ebp
  8020db:	57                   	push   %edi
  8020dc:	56                   	push   %esi
  8020dd:	53                   	push   %ebx
  8020de:	83 ec 28             	sub    $0x28,%esp
  8020e1:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8020e4:	56                   	push   %esi
  8020e5:	e8 12 f2 ff ff       	call   8012fc <fd2data>
  8020ea:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8020ec:	83 c4 10             	add    $0x10,%esp
  8020ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8020f4:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8020f7:	74 4f                	je     802148 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8020f9:	8b 43 04             	mov    0x4(%ebx),%eax
  8020fc:	8b 0b                	mov    (%ebx),%ecx
  8020fe:	8d 51 20             	lea    0x20(%ecx),%edx
  802101:	39 d0                	cmp    %edx,%eax
  802103:	72 14                	jb     802119 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  802105:	89 da                	mov    %ebx,%edx
  802107:	89 f0                	mov    %esi,%eax
  802109:	e8 61 ff ff ff       	call   80206f <_pipeisclosed>
  80210e:	85 c0                	test   %eax,%eax
  802110:	75 3b                	jne    80214d <devpipe_write+0x79>
			sys_yield();
  802112:	e8 db ea ff ff       	call   800bf2 <sys_yield>
  802117:	eb e0                	jmp    8020f9 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802119:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80211c:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802120:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802123:	89 c2                	mov    %eax,%edx
  802125:	c1 fa 1f             	sar    $0x1f,%edx
  802128:	89 d1                	mov    %edx,%ecx
  80212a:	c1 e9 1b             	shr    $0x1b,%ecx
  80212d:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802130:	83 e2 1f             	and    $0x1f,%edx
  802133:	29 ca                	sub    %ecx,%edx
  802135:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802139:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80213d:	83 c0 01             	add    $0x1,%eax
  802140:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802143:	83 c7 01             	add    $0x1,%edi
  802146:	eb ac                	jmp    8020f4 <devpipe_write+0x20>
	return i;
  802148:	8b 45 10             	mov    0x10(%ebp),%eax
  80214b:	eb 05                	jmp    802152 <devpipe_write+0x7e>
				return 0;
  80214d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802152:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802155:	5b                   	pop    %ebx
  802156:	5e                   	pop    %esi
  802157:	5f                   	pop    %edi
  802158:	5d                   	pop    %ebp
  802159:	c3                   	ret    

0080215a <devpipe_read>:
{
  80215a:	f3 0f 1e fb          	endbr32 
  80215e:	55                   	push   %ebp
  80215f:	89 e5                	mov    %esp,%ebp
  802161:	57                   	push   %edi
  802162:	56                   	push   %esi
  802163:	53                   	push   %ebx
  802164:	83 ec 18             	sub    $0x18,%esp
  802167:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80216a:	57                   	push   %edi
  80216b:	e8 8c f1 ff ff       	call   8012fc <fd2data>
  802170:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802172:	83 c4 10             	add    $0x10,%esp
  802175:	be 00 00 00 00       	mov    $0x0,%esi
  80217a:	3b 75 10             	cmp    0x10(%ebp),%esi
  80217d:	75 14                	jne    802193 <devpipe_read+0x39>
	return i;
  80217f:	8b 45 10             	mov    0x10(%ebp),%eax
  802182:	eb 02                	jmp    802186 <devpipe_read+0x2c>
				return i;
  802184:	89 f0                	mov    %esi,%eax
}
  802186:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802189:	5b                   	pop    %ebx
  80218a:	5e                   	pop    %esi
  80218b:	5f                   	pop    %edi
  80218c:	5d                   	pop    %ebp
  80218d:	c3                   	ret    
			sys_yield();
  80218e:	e8 5f ea ff ff       	call   800bf2 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802193:	8b 03                	mov    (%ebx),%eax
  802195:	3b 43 04             	cmp    0x4(%ebx),%eax
  802198:	75 18                	jne    8021b2 <devpipe_read+0x58>
			if (i > 0)
  80219a:	85 f6                	test   %esi,%esi
  80219c:	75 e6                	jne    802184 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  80219e:	89 da                	mov    %ebx,%edx
  8021a0:	89 f8                	mov    %edi,%eax
  8021a2:	e8 c8 fe ff ff       	call   80206f <_pipeisclosed>
  8021a7:	85 c0                	test   %eax,%eax
  8021a9:	74 e3                	je     80218e <devpipe_read+0x34>
				return 0;
  8021ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b0:	eb d4                	jmp    802186 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8021b2:	99                   	cltd   
  8021b3:	c1 ea 1b             	shr    $0x1b,%edx
  8021b6:	01 d0                	add    %edx,%eax
  8021b8:	83 e0 1f             	and    $0x1f,%eax
  8021bb:	29 d0                	sub    %edx,%eax
  8021bd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8021c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021c5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8021c8:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8021cb:	83 c6 01             	add    $0x1,%esi
  8021ce:	eb aa                	jmp    80217a <devpipe_read+0x20>

008021d0 <pipe>:
{
  8021d0:	f3 0f 1e fb          	endbr32 
  8021d4:	55                   	push   %ebp
  8021d5:	89 e5                	mov    %esp,%ebp
  8021d7:	56                   	push   %esi
  8021d8:	53                   	push   %ebx
  8021d9:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8021dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021df:	50                   	push   %eax
  8021e0:	e8 32 f1 ff ff       	call   801317 <fd_alloc>
  8021e5:	89 c3                	mov    %eax,%ebx
  8021e7:	83 c4 10             	add    $0x10,%esp
  8021ea:	85 c0                	test   %eax,%eax
  8021ec:	0f 88 23 01 00 00    	js     802315 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021f2:	83 ec 04             	sub    $0x4,%esp
  8021f5:	68 07 04 00 00       	push   $0x407
  8021fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8021fd:	6a 00                	push   $0x0
  8021ff:	e8 11 ea ff ff       	call   800c15 <sys_page_alloc>
  802204:	89 c3                	mov    %eax,%ebx
  802206:	83 c4 10             	add    $0x10,%esp
  802209:	85 c0                	test   %eax,%eax
  80220b:	0f 88 04 01 00 00    	js     802315 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  802211:	83 ec 0c             	sub    $0xc,%esp
  802214:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802217:	50                   	push   %eax
  802218:	e8 fa f0 ff ff       	call   801317 <fd_alloc>
  80221d:	89 c3                	mov    %eax,%ebx
  80221f:	83 c4 10             	add    $0x10,%esp
  802222:	85 c0                	test   %eax,%eax
  802224:	0f 88 db 00 00 00    	js     802305 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80222a:	83 ec 04             	sub    $0x4,%esp
  80222d:	68 07 04 00 00       	push   $0x407
  802232:	ff 75 f0             	pushl  -0x10(%ebp)
  802235:	6a 00                	push   $0x0
  802237:	e8 d9 e9 ff ff       	call   800c15 <sys_page_alloc>
  80223c:	89 c3                	mov    %eax,%ebx
  80223e:	83 c4 10             	add    $0x10,%esp
  802241:	85 c0                	test   %eax,%eax
  802243:	0f 88 bc 00 00 00    	js     802305 <pipe+0x135>
	va = fd2data(fd0);
  802249:	83 ec 0c             	sub    $0xc,%esp
  80224c:	ff 75 f4             	pushl  -0xc(%ebp)
  80224f:	e8 a8 f0 ff ff       	call   8012fc <fd2data>
  802254:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802256:	83 c4 0c             	add    $0xc,%esp
  802259:	68 07 04 00 00       	push   $0x407
  80225e:	50                   	push   %eax
  80225f:	6a 00                	push   $0x0
  802261:	e8 af e9 ff ff       	call   800c15 <sys_page_alloc>
  802266:	89 c3                	mov    %eax,%ebx
  802268:	83 c4 10             	add    $0x10,%esp
  80226b:	85 c0                	test   %eax,%eax
  80226d:	0f 88 82 00 00 00    	js     8022f5 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802273:	83 ec 0c             	sub    $0xc,%esp
  802276:	ff 75 f0             	pushl  -0x10(%ebp)
  802279:	e8 7e f0 ff ff       	call   8012fc <fd2data>
  80227e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802285:	50                   	push   %eax
  802286:	6a 00                	push   $0x0
  802288:	56                   	push   %esi
  802289:	6a 00                	push   $0x0
  80228b:	e8 cc e9 ff ff       	call   800c5c <sys_page_map>
  802290:	89 c3                	mov    %eax,%ebx
  802292:	83 c4 20             	add    $0x20,%esp
  802295:	85 c0                	test   %eax,%eax
  802297:	78 4e                	js     8022e7 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  802299:	a1 3c 30 80 00       	mov    0x80303c,%eax
  80229e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022a1:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8022a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022a6:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8022ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022b0:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8022b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8022bc:	83 ec 0c             	sub    $0xc,%esp
  8022bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8022c2:	e8 21 f0 ff ff       	call   8012e8 <fd2num>
  8022c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022ca:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8022cc:	83 c4 04             	add    $0x4,%esp
  8022cf:	ff 75 f0             	pushl  -0x10(%ebp)
  8022d2:	e8 11 f0 ff ff       	call   8012e8 <fd2num>
  8022d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022da:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8022dd:	83 c4 10             	add    $0x10,%esp
  8022e0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8022e5:	eb 2e                	jmp    802315 <pipe+0x145>
	sys_page_unmap(0, va);
  8022e7:	83 ec 08             	sub    $0x8,%esp
  8022ea:	56                   	push   %esi
  8022eb:	6a 00                	push   $0x0
  8022ed:	e8 b0 e9 ff ff       	call   800ca2 <sys_page_unmap>
  8022f2:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8022f5:	83 ec 08             	sub    $0x8,%esp
  8022f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8022fb:	6a 00                	push   $0x0
  8022fd:	e8 a0 e9 ff ff       	call   800ca2 <sys_page_unmap>
  802302:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802305:	83 ec 08             	sub    $0x8,%esp
  802308:	ff 75 f4             	pushl  -0xc(%ebp)
  80230b:	6a 00                	push   $0x0
  80230d:	e8 90 e9 ff ff       	call   800ca2 <sys_page_unmap>
  802312:	83 c4 10             	add    $0x10,%esp
}
  802315:	89 d8                	mov    %ebx,%eax
  802317:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80231a:	5b                   	pop    %ebx
  80231b:	5e                   	pop    %esi
  80231c:	5d                   	pop    %ebp
  80231d:	c3                   	ret    

0080231e <pipeisclosed>:
{
  80231e:	f3 0f 1e fb          	endbr32 
  802322:	55                   	push   %ebp
  802323:	89 e5                	mov    %esp,%ebp
  802325:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802328:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80232b:	50                   	push   %eax
  80232c:	ff 75 08             	pushl  0x8(%ebp)
  80232f:	e8 39 f0 ff ff       	call   80136d <fd_lookup>
  802334:	83 c4 10             	add    $0x10,%esp
  802337:	85 c0                	test   %eax,%eax
  802339:	78 18                	js     802353 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  80233b:	83 ec 0c             	sub    $0xc,%esp
  80233e:	ff 75 f4             	pushl  -0xc(%ebp)
  802341:	e8 b6 ef ff ff       	call   8012fc <fd2data>
  802346:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234b:	e8 1f fd ff ff       	call   80206f <_pipeisclosed>
  802350:	83 c4 10             	add    $0x10,%esp
}
  802353:	c9                   	leave  
  802354:	c3                   	ret    

00802355 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802355:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  802359:	b8 00 00 00 00       	mov    $0x0,%eax
  80235e:	c3                   	ret    

0080235f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80235f:	f3 0f 1e fb          	endbr32 
  802363:	55                   	push   %ebp
  802364:	89 e5                	mov    %esp,%ebp
  802366:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802369:	68 bb 2d 80 00       	push   $0x802dbb
  80236e:	ff 75 0c             	pushl  0xc(%ebp)
  802371:	e8 5d e4 ff ff       	call   8007d3 <strcpy>
	return 0;
}
  802376:	b8 00 00 00 00       	mov    $0x0,%eax
  80237b:	c9                   	leave  
  80237c:	c3                   	ret    

0080237d <devcons_write>:
{
  80237d:	f3 0f 1e fb          	endbr32 
  802381:	55                   	push   %ebp
  802382:	89 e5                	mov    %esp,%ebp
  802384:	57                   	push   %edi
  802385:	56                   	push   %esi
  802386:	53                   	push   %ebx
  802387:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80238d:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802392:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802398:	3b 75 10             	cmp    0x10(%ebp),%esi
  80239b:	73 31                	jae    8023ce <devcons_write+0x51>
		m = n - tot;
  80239d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8023a0:	29 f3                	sub    %esi,%ebx
  8023a2:	83 fb 7f             	cmp    $0x7f,%ebx
  8023a5:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8023aa:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8023ad:	83 ec 04             	sub    $0x4,%esp
  8023b0:	53                   	push   %ebx
  8023b1:	89 f0                	mov    %esi,%eax
  8023b3:	03 45 0c             	add    0xc(%ebp),%eax
  8023b6:	50                   	push   %eax
  8023b7:	57                   	push   %edi
  8023b8:	e8 cc e5 ff ff       	call   800989 <memmove>
		sys_cputs(buf, m);
  8023bd:	83 c4 08             	add    $0x8,%esp
  8023c0:	53                   	push   %ebx
  8023c1:	57                   	push   %edi
  8023c2:	e8 7e e7 ff ff       	call   800b45 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8023c7:	01 de                	add    %ebx,%esi
  8023c9:	83 c4 10             	add    $0x10,%esp
  8023cc:	eb ca                	jmp    802398 <devcons_write+0x1b>
}
  8023ce:	89 f0                	mov    %esi,%eax
  8023d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023d3:	5b                   	pop    %ebx
  8023d4:	5e                   	pop    %esi
  8023d5:	5f                   	pop    %edi
  8023d6:	5d                   	pop    %ebp
  8023d7:	c3                   	ret    

008023d8 <devcons_read>:
{
  8023d8:	f3 0f 1e fb          	endbr32 
  8023dc:	55                   	push   %ebp
  8023dd:	89 e5                	mov    %esp,%ebp
  8023df:	83 ec 08             	sub    $0x8,%esp
  8023e2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8023e7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023eb:	74 21                	je     80240e <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8023ed:	e8 75 e7 ff ff       	call   800b67 <sys_cgetc>
  8023f2:	85 c0                	test   %eax,%eax
  8023f4:	75 07                	jne    8023fd <devcons_read+0x25>
		sys_yield();
  8023f6:	e8 f7 e7 ff ff       	call   800bf2 <sys_yield>
  8023fb:	eb f0                	jmp    8023ed <devcons_read+0x15>
	if (c < 0)
  8023fd:	78 0f                	js     80240e <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8023ff:	83 f8 04             	cmp    $0x4,%eax
  802402:	74 0c                	je     802410 <devcons_read+0x38>
	*(char*)vbuf = c;
  802404:	8b 55 0c             	mov    0xc(%ebp),%edx
  802407:	88 02                	mov    %al,(%edx)
	return 1;
  802409:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80240e:	c9                   	leave  
  80240f:	c3                   	ret    
		return 0;
  802410:	b8 00 00 00 00       	mov    $0x0,%eax
  802415:	eb f7                	jmp    80240e <devcons_read+0x36>

00802417 <cputchar>:
{
  802417:	f3 0f 1e fb          	endbr32 
  80241b:	55                   	push   %ebp
  80241c:	89 e5                	mov    %esp,%ebp
  80241e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802421:	8b 45 08             	mov    0x8(%ebp),%eax
  802424:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802427:	6a 01                	push   $0x1
  802429:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80242c:	50                   	push   %eax
  80242d:	e8 13 e7 ff ff       	call   800b45 <sys_cputs>
}
  802432:	83 c4 10             	add    $0x10,%esp
  802435:	c9                   	leave  
  802436:	c3                   	ret    

00802437 <getchar>:
{
  802437:	f3 0f 1e fb          	endbr32 
  80243b:	55                   	push   %ebp
  80243c:	89 e5                	mov    %esp,%ebp
  80243e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802441:	6a 01                	push   $0x1
  802443:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802446:	50                   	push   %eax
  802447:	6a 00                	push   $0x0
  802449:	e8 a7 f1 ff ff       	call   8015f5 <read>
	if (r < 0)
  80244e:	83 c4 10             	add    $0x10,%esp
  802451:	85 c0                	test   %eax,%eax
  802453:	78 06                	js     80245b <getchar+0x24>
	if (r < 1)
  802455:	74 06                	je     80245d <getchar+0x26>
	return c;
  802457:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80245b:	c9                   	leave  
  80245c:	c3                   	ret    
		return -E_EOF;
  80245d:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802462:	eb f7                	jmp    80245b <getchar+0x24>

00802464 <iscons>:
{
  802464:	f3 0f 1e fb          	endbr32 
  802468:	55                   	push   %ebp
  802469:	89 e5                	mov    %esp,%ebp
  80246b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80246e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802471:	50                   	push   %eax
  802472:	ff 75 08             	pushl  0x8(%ebp)
  802475:	e8 f3 ee ff ff       	call   80136d <fd_lookup>
  80247a:	83 c4 10             	add    $0x10,%esp
  80247d:	85 c0                	test   %eax,%eax
  80247f:	78 11                	js     802492 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  802481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802484:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80248a:	39 10                	cmp    %edx,(%eax)
  80248c:	0f 94 c0             	sete   %al
  80248f:	0f b6 c0             	movzbl %al,%eax
}
  802492:	c9                   	leave  
  802493:	c3                   	ret    

00802494 <opencons>:
{
  802494:	f3 0f 1e fb          	endbr32 
  802498:	55                   	push   %ebp
  802499:	89 e5                	mov    %esp,%ebp
  80249b:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80249e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024a1:	50                   	push   %eax
  8024a2:	e8 70 ee ff ff       	call   801317 <fd_alloc>
  8024a7:	83 c4 10             	add    $0x10,%esp
  8024aa:	85 c0                	test   %eax,%eax
  8024ac:	78 3a                	js     8024e8 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8024ae:	83 ec 04             	sub    $0x4,%esp
  8024b1:	68 07 04 00 00       	push   $0x407
  8024b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8024b9:	6a 00                	push   $0x0
  8024bb:	e8 55 e7 ff ff       	call   800c15 <sys_page_alloc>
  8024c0:	83 c4 10             	add    $0x10,%esp
  8024c3:	85 c0                	test   %eax,%eax
  8024c5:	78 21                	js     8024e8 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8024c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ca:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8024d0:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8024d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8024dc:	83 ec 0c             	sub    $0xc,%esp
  8024df:	50                   	push   %eax
  8024e0:	e8 03 ee ff ff       	call   8012e8 <fd2num>
  8024e5:	83 c4 10             	add    $0x10,%esp
}
  8024e8:	c9                   	leave  
  8024e9:	c3                   	ret    

008024ea <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8024ea:	f3 0f 1e fb          	endbr32 
  8024ee:	55                   	push   %ebp
  8024ef:	89 e5                	mov    %esp,%ebp
  8024f1:	56                   	push   %esi
  8024f2:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8024f3:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8024f6:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8024fc:	e8 ce e6 ff ff       	call   800bcf <sys_getenvid>
  802501:	83 ec 0c             	sub    $0xc,%esp
  802504:	ff 75 0c             	pushl  0xc(%ebp)
  802507:	ff 75 08             	pushl  0x8(%ebp)
  80250a:	56                   	push   %esi
  80250b:	50                   	push   %eax
  80250c:	68 c8 2d 80 00       	push   $0x802dc8
  802511:	e8 b3 dc ff ff       	call   8001c9 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802516:	83 c4 18             	add    $0x18,%esp
  802519:	53                   	push   %ebx
  80251a:	ff 75 10             	pushl  0x10(%ebp)
  80251d:	e8 52 dc ff ff       	call   800174 <vcprintf>
	cprintf("\n");
  802522:	c7 04 24 94 2c 80 00 	movl   $0x802c94,(%esp)
  802529:	e8 9b dc ff ff       	call   8001c9 <cprintf>
  80252e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802531:	cc                   	int3   
  802532:	eb fd                	jmp    802531 <_panic+0x47>

00802534 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802534:	f3 0f 1e fb          	endbr32 
  802538:	55                   	push   %ebp
  802539:	89 e5                	mov    %esp,%ebp
  80253b:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80253e:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802545:	74 0a                	je     802551 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802547:	8b 45 08             	mov    0x8(%ebp),%eax
  80254a:	a3 00 70 80 00       	mov    %eax,0x807000
}
  80254f:	c9                   	leave  
  802550:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  802551:	83 ec 04             	sub    $0x4,%esp
  802554:	6a 07                	push   $0x7
  802556:	68 00 f0 bf ee       	push   $0xeebff000
  80255b:	6a 00                	push   $0x0
  80255d:	e8 b3 e6 ff ff       	call   800c15 <sys_page_alloc>
  802562:	83 c4 10             	add    $0x10,%esp
  802565:	85 c0                	test   %eax,%eax
  802567:	78 2a                	js     802593 <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  802569:	83 ec 08             	sub    $0x8,%esp
  80256c:	68 a7 25 80 00       	push   $0x8025a7
  802571:	6a 00                	push   $0x0
  802573:	e8 fc e7 ff ff       	call   800d74 <sys_env_set_pgfault_upcall>
  802578:	83 c4 10             	add    $0x10,%esp
  80257b:	85 c0                	test   %eax,%eax
  80257d:	79 c8                	jns    802547 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  80257f:	83 ec 04             	sub    $0x4,%esp
  802582:	68 18 2e 80 00       	push   $0x802e18
  802587:	6a 25                	push   $0x25
  802589:	68 50 2e 80 00       	push   $0x802e50
  80258e:	e8 57 ff ff ff       	call   8024ea <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  802593:	83 ec 04             	sub    $0x4,%esp
  802596:	68 ec 2d 80 00       	push   $0x802dec
  80259b:	6a 22                	push   $0x22
  80259d:	68 50 2e 80 00       	push   $0x802e50
  8025a2:	e8 43 ff ff ff       	call   8024ea <_panic>

008025a7 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8025a7:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8025a8:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  8025ad:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8025af:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  8025b2:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  8025b6:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  8025ba:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8025bd:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  8025bf:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  8025c3:	83 c4 08             	add    $0x8,%esp
	popal
  8025c6:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  8025c7:	83 c4 04             	add    $0x4,%esp
	popfl
  8025ca:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  8025cb:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  8025cc:	c3                   	ret    

008025cd <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8025cd:	f3 0f 1e fb          	endbr32 
  8025d1:	55                   	push   %ebp
  8025d2:	89 e5                	mov    %esp,%ebp
  8025d4:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8025d7:	89 c2                	mov    %eax,%edx
  8025d9:	c1 ea 16             	shr    $0x16,%edx
  8025dc:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8025e3:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8025e8:	f6 c1 01             	test   $0x1,%cl
  8025eb:	74 1c                	je     802609 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8025ed:	c1 e8 0c             	shr    $0xc,%eax
  8025f0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8025f7:	a8 01                	test   $0x1,%al
  8025f9:	74 0e                	je     802609 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8025fb:	c1 e8 0c             	shr    $0xc,%eax
  8025fe:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802605:	ef 
  802606:	0f b7 d2             	movzwl %dx,%edx
}
  802609:	89 d0                	mov    %edx,%eax
  80260b:	5d                   	pop    %ebp
  80260c:	c3                   	ret    
  80260d:	66 90                	xchg   %ax,%ax
  80260f:	90                   	nop

00802610 <__udivdi3>:
  802610:	f3 0f 1e fb          	endbr32 
  802614:	55                   	push   %ebp
  802615:	57                   	push   %edi
  802616:	56                   	push   %esi
  802617:	53                   	push   %ebx
  802618:	83 ec 1c             	sub    $0x1c,%esp
  80261b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80261f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802623:	8b 74 24 34          	mov    0x34(%esp),%esi
  802627:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80262b:	85 d2                	test   %edx,%edx
  80262d:	75 19                	jne    802648 <__udivdi3+0x38>
  80262f:	39 f3                	cmp    %esi,%ebx
  802631:	76 4d                	jbe    802680 <__udivdi3+0x70>
  802633:	31 ff                	xor    %edi,%edi
  802635:	89 e8                	mov    %ebp,%eax
  802637:	89 f2                	mov    %esi,%edx
  802639:	f7 f3                	div    %ebx
  80263b:	89 fa                	mov    %edi,%edx
  80263d:	83 c4 1c             	add    $0x1c,%esp
  802640:	5b                   	pop    %ebx
  802641:	5e                   	pop    %esi
  802642:	5f                   	pop    %edi
  802643:	5d                   	pop    %ebp
  802644:	c3                   	ret    
  802645:	8d 76 00             	lea    0x0(%esi),%esi
  802648:	39 f2                	cmp    %esi,%edx
  80264a:	76 14                	jbe    802660 <__udivdi3+0x50>
  80264c:	31 ff                	xor    %edi,%edi
  80264e:	31 c0                	xor    %eax,%eax
  802650:	89 fa                	mov    %edi,%edx
  802652:	83 c4 1c             	add    $0x1c,%esp
  802655:	5b                   	pop    %ebx
  802656:	5e                   	pop    %esi
  802657:	5f                   	pop    %edi
  802658:	5d                   	pop    %ebp
  802659:	c3                   	ret    
  80265a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802660:	0f bd fa             	bsr    %edx,%edi
  802663:	83 f7 1f             	xor    $0x1f,%edi
  802666:	75 48                	jne    8026b0 <__udivdi3+0xa0>
  802668:	39 f2                	cmp    %esi,%edx
  80266a:	72 06                	jb     802672 <__udivdi3+0x62>
  80266c:	31 c0                	xor    %eax,%eax
  80266e:	39 eb                	cmp    %ebp,%ebx
  802670:	77 de                	ja     802650 <__udivdi3+0x40>
  802672:	b8 01 00 00 00       	mov    $0x1,%eax
  802677:	eb d7                	jmp    802650 <__udivdi3+0x40>
  802679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802680:	89 d9                	mov    %ebx,%ecx
  802682:	85 db                	test   %ebx,%ebx
  802684:	75 0b                	jne    802691 <__udivdi3+0x81>
  802686:	b8 01 00 00 00       	mov    $0x1,%eax
  80268b:	31 d2                	xor    %edx,%edx
  80268d:	f7 f3                	div    %ebx
  80268f:	89 c1                	mov    %eax,%ecx
  802691:	31 d2                	xor    %edx,%edx
  802693:	89 f0                	mov    %esi,%eax
  802695:	f7 f1                	div    %ecx
  802697:	89 c6                	mov    %eax,%esi
  802699:	89 e8                	mov    %ebp,%eax
  80269b:	89 f7                	mov    %esi,%edi
  80269d:	f7 f1                	div    %ecx
  80269f:	89 fa                	mov    %edi,%edx
  8026a1:	83 c4 1c             	add    $0x1c,%esp
  8026a4:	5b                   	pop    %ebx
  8026a5:	5e                   	pop    %esi
  8026a6:	5f                   	pop    %edi
  8026a7:	5d                   	pop    %ebp
  8026a8:	c3                   	ret    
  8026a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026b0:	89 f9                	mov    %edi,%ecx
  8026b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8026b7:	29 f8                	sub    %edi,%eax
  8026b9:	d3 e2                	shl    %cl,%edx
  8026bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8026bf:	89 c1                	mov    %eax,%ecx
  8026c1:	89 da                	mov    %ebx,%edx
  8026c3:	d3 ea                	shr    %cl,%edx
  8026c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8026c9:	09 d1                	or     %edx,%ecx
  8026cb:	89 f2                	mov    %esi,%edx
  8026cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026d1:	89 f9                	mov    %edi,%ecx
  8026d3:	d3 e3                	shl    %cl,%ebx
  8026d5:	89 c1                	mov    %eax,%ecx
  8026d7:	d3 ea                	shr    %cl,%edx
  8026d9:	89 f9                	mov    %edi,%ecx
  8026db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8026df:	89 eb                	mov    %ebp,%ebx
  8026e1:	d3 e6                	shl    %cl,%esi
  8026e3:	89 c1                	mov    %eax,%ecx
  8026e5:	d3 eb                	shr    %cl,%ebx
  8026e7:	09 de                	or     %ebx,%esi
  8026e9:	89 f0                	mov    %esi,%eax
  8026eb:	f7 74 24 08          	divl   0x8(%esp)
  8026ef:	89 d6                	mov    %edx,%esi
  8026f1:	89 c3                	mov    %eax,%ebx
  8026f3:	f7 64 24 0c          	mull   0xc(%esp)
  8026f7:	39 d6                	cmp    %edx,%esi
  8026f9:	72 15                	jb     802710 <__udivdi3+0x100>
  8026fb:	89 f9                	mov    %edi,%ecx
  8026fd:	d3 e5                	shl    %cl,%ebp
  8026ff:	39 c5                	cmp    %eax,%ebp
  802701:	73 04                	jae    802707 <__udivdi3+0xf7>
  802703:	39 d6                	cmp    %edx,%esi
  802705:	74 09                	je     802710 <__udivdi3+0x100>
  802707:	89 d8                	mov    %ebx,%eax
  802709:	31 ff                	xor    %edi,%edi
  80270b:	e9 40 ff ff ff       	jmp    802650 <__udivdi3+0x40>
  802710:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802713:	31 ff                	xor    %edi,%edi
  802715:	e9 36 ff ff ff       	jmp    802650 <__udivdi3+0x40>
  80271a:	66 90                	xchg   %ax,%ax
  80271c:	66 90                	xchg   %ax,%ax
  80271e:	66 90                	xchg   %ax,%ax

00802720 <__umoddi3>:
  802720:	f3 0f 1e fb          	endbr32 
  802724:	55                   	push   %ebp
  802725:	57                   	push   %edi
  802726:	56                   	push   %esi
  802727:	53                   	push   %ebx
  802728:	83 ec 1c             	sub    $0x1c,%esp
  80272b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80272f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802733:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802737:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80273b:	85 c0                	test   %eax,%eax
  80273d:	75 19                	jne    802758 <__umoddi3+0x38>
  80273f:	39 df                	cmp    %ebx,%edi
  802741:	76 5d                	jbe    8027a0 <__umoddi3+0x80>
  802743:	89 f0                	mov    %esi,%eax
  802745:	89 da                	mov    %ebx,%edx
  802747:	f7 f7                	div    %edi
  802749:	89 d0                	mov    %edx,%eax
  80274b:	31 d2                	xor    %edx,%edx
  80274d:	83 c4 1c             	add    $0x1c,%esp
  802750:	5b                   	pop    %ebx
  802751:	5e                   	pop    %esi
  802752:	5f                   	pop    %edi
  802753:	5d                   	pop    %ebp
  802754:	c3                   	ret    
  802755:	8d 76 00             	lea    0x0(%esi),%esi
  802758:	89 f2                	mov    %esi,%edx
  80275a:	39 d8                	cmp    %ebx,%eax
  80275c:	76 12                	jbe    802770 <__umoddi3+0x50>
  80275e:	89 f0                	mov    %esi,%eax
  802760:	89 da                	mov    %ebx,%edx
  802762:	83 c4 1c             	add    $0x1c,%esp
  802765:	5b                   	pop    %ebx
  802766:	5e                   	pop    %esi
  802767:	5f                   	pop    %edi
  802768:	5d                   	pop    %ebp
  802769:	c3                   	ret    
  80276a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802770:	0f bd e8             	bsr    %eax,%ebp
  802773:	83 f5 1f             	xor    $0x1f,%ebp
  802776:	75 50                	jne    8027c8 <__umoddi3+0xa8>
  802778:	39 d8                	cmp    %ebx,%eax
  80277a:	0f 82 e0 00 00 00    	jb     802860 <__umoddi3+0x140>
  802780:	89 d9                	mov    %ebx,%ecx
  802782:	39 f7                	cmp    %esi,%edi
  802784:	0f 86 d6 00 00 00    	jbe    802860 <__umoddi3+0x140>
  80278a:	89 d0                	mov    %edx,%eax
  80278c:	89 ca                	mov    %ecx,%edx
  80278e:	83 c4 1c             	add    $0x1c,%esp
  802791:	5b                   	pop    %ebx
  802792:	5e                   	pop    %esi
  802793:	5f                   	pop    %edi
  802794:	5d                   	pop    %ebp
  802795:	c3                   	ret    
  802796:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80279d:	8d 76 00             	lea    0x0(%esi),%esi
  8027a0:	89 fd                	mov    %edi,%ebp
  8027a2:	85 ff                	test   %edi,%edi
  8027a4:	75 0b                	jne    8027b1 <__umoddi3+0x91>
  8027a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8027ab:	31 d2                	xor    %edx,%edx
  8027ad:	f7 f7                	div    %edi
  8027af:	89 c5                	mov    %eax,%ebp
  8027b1:	89 d8                	mov    %ebx,%eax
  8027b3:	31 d2                	xor    %edx,%edx
  8027b5:	f7 f5                	div    %ebp
  8027b7:	89 f0                	mov    %esi,%eax
  8027b9:	f7 f5                	div    %ebp
  8027bb:	89 d0                	mov    %edx,%eax
  8027bd:	31 d2                	xor    %edx,%edx
  8027bf:	eb 8c                	jmp    80274d <__umoddi3+0x2d>
  8027c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027c8:	89 e9                	mov    %ebp,%ecx
  8027ca:	ba 20 00 00 00       	mov    $0x20,%edx
  8027cf:	29 ea                	sub    %ebp,%edx
  8027d1:	d3 e0                	shl    %cl,%eax
  8027d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027d7:	89 d1                	mov    %edx,%ecx
  8027d9:	89 f8                	mov    %edi,%eax
  8027db:	d3 e8                	shr    %cl,%eax
  8027dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8027e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8027e5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8027e9:	09 c1                	or     %eax,%ecx
  8027eb:	89 d8                	mov    %ebx,%eax
  8027ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027f1:	89 e9                	mov    %ebp,%ecx
  8027f3:	d3 e7                	shl    %cl,%edi
  8027f5:	89 d1                	mov    %edx,%ecx
  8027f7:	d3 e8                	shr    %cl,%eax
  8027f9:	89 e9                	mov    %ebp,%ecx
  8027fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027ff:	d3 e3                	shl    %cl,%ebx
  802801:	89 c7                	mov    %eax,%edi
  802803:	89 d1                	mov    %edx,%ecx
  802805:	89 f0                	mov    %esi,%eax
  802807:	d3 e8                	shr    %cl,%eax
  802809:	89 e9                	mov    %ebp,%ecx
  80280b:	89 fa                	mov    %edi,%edx
  80280d:	d3 e6                	shl    %cl,%esi
  80280f:	09 d8                	or     %ebx,%eax
  802811:	f7 74 24 08          	divl   0x8(%esp)
  802815:	89 d1                	mov    %edx,%ecx
  802817:	89 f3                	mov    %esi,%ebx
  802819:	f7 64 24 0c          	mull   0xc(%esp)
  80281d:	89 c6                	mov    %eax,%esi
  80281f:	89 d7                	mov    %edx,%edi
  802821:	39 d1                	cmp    %edx,%ecx
  802823:	72 06                	jb     80282b <__umoddi3+0x10b>
  802825:	75 10                	jne    802837 <__umoddi3+0x117>
  802827:	39 c3                	cmp    %eax,%ebx
  802829:	73 0c                	jae    802837 <__umoddi3+0x117>
  80282b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80282f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802833:	89 d7                	mov    %edx,%edi
  802835:	89 c6                	mov    %eax,%esi
  802837:	89 ca                	mov    %ecx,%edx
  802839:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80283e:	29 f3                	sub    %esi,%ebx
  802840:	19 fa                	sbb    %edi,%edx
  802842:	89 d0                	mov    %edx,%eax
  802844:	d3 e0                	shl    %cl,%eax
  802846:	89 e9                	mov    %ebp,%ecx
  802848:	d3 eb                	shr    %cl,%ebx
  80284a:	d3 ea                	shr    %cl,%edx
  80284c:	09 d8                	or     %ebx,%eax
  80284e:	83 c4 1c             	add    $0x1c,%esp
  802851:	5b                   	pop    %ebx
  802852:	5e                   	pop    %esi
  802853:	5f                   	pop    %edi
  802854:	5d                   	pop    %ebp
  802855:	c3                   	ret    
  802856:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80285d:	8d 76 00             	lea    0x0(%esi),%esi
  802860:	29 fe                	sub    %edi,%esi
  802862:	19 c3                	sbb    %eax,%ebx
  802864:	89 f2                	mov    %esi,%edx
  802866:	89 d9                	mov    %ebx,%ecx
  802868:	e9 1d ff ff ff       	jmp    80278a <__umoddi3+0x6a>
