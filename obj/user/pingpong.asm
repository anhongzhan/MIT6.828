
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
  800040:	e8 c1 0e 00 00       	call   800f06 <fork>
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
  800057:	e8 c3 10 00 00       	call   80111f <ipc_recv>
  80005c:	89 c3                	mov    %eax,%ebx
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  80005e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800061:	e8 69 0b 00 00       	call   800bcf <sys_getenvid>
  800066:	57                   	push   %edi
  800067:	53                   	push   %ebx
  800068:	50                   	push   %eax
  800069:	68 36 23 80 00       	push   $0x802336
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
  800086:	e8 19 11 00 00       	call   8011a4 <ipc_send>
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
  8000a7:	68 20 23 80 00       	push   $0x802320
  8000ac:	e8 18 01 00 00       	call   8001c9 <cprintf>
		ipc_send(who, 0, 0, 0);
  8000b1:	6a 00                	push   $0x0
  8000b3:	6a 00                	push   $0x0
  8000b5:	6a 00                	push   $0x0
  8000b7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000ba:	e8 e5 10 00 00       	call   8011a4 <ipc_send>
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
  8000e5:	a3 04 40 80 00       	mov    %eax,0x804004

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
  800118:	e8 0b 13 00 00       	call   801428 <close_all>
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
  80022f:	e8 7c 1e 00 00       	call   8020b0 <__udivdi3>
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
  80026d:	e8 4e 1f 00 00       	call   8021c0 <__umoddi3>
  800272:	83 c4 14             	add    $0x14,%esp
  800275:	0f be 80 53 23 80 00 	movsbl 0x802353(%eax),%eax
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
  80031c:	3e ff 24 85 a0 24 80 	notrack jmp *0x8024a0(,%eax,4)
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
  8003e9:	8b 14 85 00 26 80 00 	mov    0x802600(,%eax,4),%edx
  8003f0:	85 d2                	test   %edx,%edx
  8003f2:	74 18                	je     80040c <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8003f4:	52                   	push   %edx
  8003f5:	68 e5 27 80 00       	push   $0x8027e5
  8003fa:	53                   	push   %ebx
  8003fb:	56                   	push   %esi
  8003fc:	e8 aa fe ff ff       	call   8002ab <printfmt>
  800401:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800404:	89 7d 14             	mov    %edi,0x14(%ebp)
  800407:	e9 66 02 00 00       	jmp    800672 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80040c:	50                   	push   %eax
  80040d:	68 6b 23 80 00       	push   $0x80236b
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
  800434:	b8 64 23 80 00       	mov    $0x802364,%eax
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
  800bbe:	68 5f 26 80 00       	push   $0x80265f
  800bc3:	6a 23                	push   $0x23
  800bc5:	68 7c 26 80 00       	push   $0x80267c
  800bca:	e8 af 13 00 00       	call   801f7e <_panic>

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
  800c4b:	68 5f 26 80 00       	push   $0x80265f
  800c50:	6a 23                	push   $0x23
  800c52:	68 7c 26 80 00       	push   $0x80267c
  800c57:	e8 22 13 00 00       	call   801f7e <_panic>

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
  800c91:	68 5f 26 80 00       	push   $0x80265f
  800c96:	6a 23                	push   $0x23
  800c98:	68 7c 26 80 00       	push   $0x80267c
  800c9d:	e8 dc 12 00 00       	call   801f7e <_panic>

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
  800cd7:	68 5f 26 80 00       	push   $0x80265f
  800cdc:	6a 23                	push   $0x23
  800cde:	68 7c 26 80 00       	push   $0x80267c
  800ce3:	e8 96 12 00 00       	call   801f7e <_panic>

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
  800d1d:	68 5f 26 80 00       	push   $0x80265f
  800d22:	6a 23                	push   $0x23
  800d24:	68 7c 26 80 00       	push   $0x80267c
  800d29:	e8 50 12 00 00       	call   801f7e <_panic>

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
  800d63:	68 5f 26 80 00       	push   $0x80265f
  800d68:	6a 23                	push   $0x23
  800d6a:	68 7c 26 80 00       	push   $0x80267c
  800d6f:	e8 0a 12 00 00       	call   801f7e <_panic>

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
  800da9:	68 5f 26 80 00       	push   $0x80265f
  800dae:	6a 23                	push   $0x23
  800db0:	68 7c 26 80 00       	push   $0x80267c
  800db5:	e8 c4 11 00 00       	call   801f7e <_panic>

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
  800e15:	68 5f 26 80 00       	push   $0x80265f
  800e1a:	6a 23                	push   $0x23
  800e1c:	68 7c 26 80 00       	push   $0x80267c
  800e21:	e8 58 11 00 00       	call   801f7e <_panic>

00800e26 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800e26:	f3 0f 1e fb          	endbr32 
  800e2a:	55                   	push   %ebp
  800e2b:	89 e5                	mov    %esp,%ebp
  800e2d:	53                   	push   %ebx
  800e2e:	83 ec 04             	sub    $0x4,%esp
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800e34:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  800e36:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800e3a:	74 74                	je     800eb0 <pgfault+0x8a>
  800e3c:	89 d8                	mov    %ebx,%eax
  800e3e:	c1 e8 0c             	shr    $0xc,%eax
  800e41:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800e48:	f6 c4 08             	test   $0x8,%ah
  800e4b:	74 63                	je     800eb0 <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800e4d:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  800e53:	83 ec 0c             	sub    $0xc,%esp
  800e56:	6a 05                	push   $0x5
  800e58:	68 00 f0 7f 00       	push   $0x7ff000
  800e5d:	6a 00                	push   $0x0
  800e5f:	53                   	push   %ebx
  800e60:	6a 00                	push   $0x0
  800e62:	e8 f5 fd ff ff       	call   800c5c <sys_page_map>
  800e67:	83 c4 20             	add    $0x20,%esp
  800e6a:	85 c0                	test   %eax,%eax
  800e6c:	78 59                	js     800ec7 <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  800e6e:	83 ec 04             	sub    $0x4,%esp
  800e71:	6a 07                	push   $0x7
  800e73:	53                   	push   %ebx
  800e74:	6a 00                	push   $0x0
  800e76:	e8 9a fd ff ff       	call   800c15 <sys_page_alloc>
  800e7b:	83 c4 10             	add    $0x10,%esp
  800e7e:	85 c0                	test   %eax,%eax
  800e80:	78 5a                	js     800edc <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  800e82:	83 ec 04             	sub    $0x4,%esp
  800e85:	68 00 10 00 00       	push   $0x1000
  800e8a:	68 00 f0 7f 00       	push   $0x7ff000
  800e8f:	53                   	push   %ebx
  800e90:	e8 f4 fa ff ff       	call   800989 <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  800e95:	83 c4 08             	add    $0x8,%esp
  800e98:	68 00 f0 7f 00       	push   $0x7ff000
  800e9d:	6a 00                	push   $0x0
  800e9f:	e8 fe fd ff ff       	call   800ca2 <sys_page_unmap>
  800ea4:	83 c4 10             	add    $0x10,%esp
  800ea7:	85 c0                	test   %eax,%eax
  800ea9:	78 46                	js     800ef1 <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  800eab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800eae:	c9                   	leave  
  800eaf:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  800eb0:	83 ec 04             	sub    $0x4,%esp
  800eb3:	68 8a 26 80 00       	push   $0x80268a
  800eb8:	68 d3 00 00 00       	push   $0xd3
  800ebd:	68 a6 26 80 00       	push   $0x8026a6
  800ec2:	e8 b7 10 00 00       	call   801f7e <_panic>
		panic("pgfault: %e\n", r);
  800ec7:	50                   	push   %eax
  800ec8:	68 b1 26 80 00       	push   $0x8026b1
  800ecd:	68 df 00 00 00       	push   $0xdf
  800ed2:	68 a6 26 80 00       	push   $0x8026a6
  800ed7:	e8 a2 10 00 00       	call   801f7e <_panic>
		panic("pgfault: %e\n", r);
  800edc:	50                   	push   %eax
  800edd:	68 b1 26 80 00       	push   $0x8026b1
  800ee2:	68 e3 00 00 00       	push   $0xe3
  800ee7:	68 a6 26 80 00       	push   $0x8026a6
  800eec:	e8 8d 10 00 00       	call   801f7e <_panic>
		panic("pgfault: %e\n", r);
  800ef1:	50                   	push   %eax
  800ef2:	68 b1 26 80 00       	push   $0x8026b1
  800ef7:	68 e9 00 00 00       	push   $0xe9
  800efc:	68 a6 26 80 00       	push   $0x8026a6
  800f01:	e8 78 10 00 00       	call   801f7e <_panic>

00800f06 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800f06:	f3 0f 1e fb          	endbr32 
  800f0a:	55                   	push   %ebp
  800f0b:	89 e5                	mov    %esp,%ebp
  800f0d:	57                   	push   %edi
  800f0e:	56                   	push   %esi
  800f0f:	53                   	push   %ebx
  800f10:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  800f13:	68 26 0e 80 00       	push   $0x800e26
  800f18:	e8 ab 10 00 00       	call   801fc8 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f1d:	b8 07 00 00 00       	mov    $0x7,%eax
  800f22:	cd 30                	int    $0x30
  800f24:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  800f27:	83 c4 10             	add    $0x10,%esp
  800f2a:	85 c0                	test   %eax,%eax
  800f2c:	78 2d                	js     800f5b <fork+0x55>
  800f2e:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800f30:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  800f35:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f39:	0f 85 9b 00 00 00    	jne    800fda <fork+0xd4>
		thisenv = &envs[ENVX(sys_getenvid())];
  800f3f:	e8 8b fc ff ff       	call   800bcf <sys_getenvid>
  800f44:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f49:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f4c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f51:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  800f56:	e9 71 01 00 00       	jmp    8010cc <fork+0x1c6>
		panic("sys_exofork: %e", envid);
  800f5b:	50                   	push   %eax
  800f5c:	68 be 26 80 00       	push   $0x8026be
  800f61:	68 2a 01 00 00       	push   $0x12a
  800f66:	68 a6 26 80 00       	push   $0x8026a6
  800f6b:	e8 0e 10 00 00       	call   801f7e <_panic>
		sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_SYSCALL);
  800f70:	c1 e6 0c             	shl    $0xc,%esi
  800f73:	83 ec 0c             	sub    $0xc,%esp
  800f76:	68 07 0e 00 00       	push   $0xe07
  800f7b:	56                   	push   %esi
  800f7c:	57                   	push   %edi
  800f7d:	56                   	push   %esi
  800f7e:	6a 00                	push   $0x0
  800f80:	e8 d7 fc ff ff       	call   800c5c <sys_page_map>
  800f85:	83 c4 20             	add    $0x20,%esp
  800f88:	eb 3e                	jmp    800fc8 <fork+0xc2>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  800f8a:	c1 e6 0c             	shl    $0xc,%esi
  800f8d:	83 ec 0c             	sub    $0xc,%esp
  800f90:	68 05 08 00 00       	push   $0x805
  800f95:	56                   	push   %esi
  800f96:	57                   	push   %edi
  800f97:	56                   	push   %esi
  800f98:	6a 00                	push   $0x0
  800f9a:	e8 bd fc ff ff       	call   800c5c <sys_page_map>
  800f9f:	83 c4 20             	add    $0x20,%esp
  800fa2:	85 c0                	test   %eax,%eax
  800fa4:	0f 88 bc 00 00 00    	js     801066 <fork+0x160>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  800faa:	83 ec 0c             	sub    $0xc,%esp
  800fad:	68 05 08 00 00       	push   $0x805
  800fb2:	56                   	push   %esi
  800fb3:	6a 00                	push   $0x0
  800fb5:	56                   	push   %esi
  800fb6:	6a 00                	push   $0x0
  800fb8:	e8 9f fc ff ff       	call   800c5c <sys_page_map>
  800fbd:	83 c4 20             	add    $0x20,%esp
  800fc0:	85 c0                	test   %eax,%eax
  800fc2:	0f 88 b3 00 00 00    	js     80107b <fork+0x175>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800fc8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800fce:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  800fd4:	0f 84 b6 00 00 00    	je     801090 <fork+0x18a>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  800fda:	89 d8                	mov    %ebx,%eax
  800fdc:	c1 e8 16             	shr    $0x16,%eax
  800fdf:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fe6:	a8 01                	test   $0x1,%al
  800fe8:	74 de                	je     800fc8 <fork+0xc2>
  800fea:	89 de                	mov    %ebx,%esi
  800fec:	c1 ee 0c             	shr    $0xc,%esi
  800fef:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  800ff6:	a8 01                	test   $0x1,%al
  800ff8:	74 ce                	je     800fc8 <fork+0xc2>
  800ffa:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801001:	a8 04                	test   $0x4,%al
  801003:	74 c3                	je     800fc8 <fork+0xc2>
	if ((uvpt[pn] & PTE_SHARE)){
  801005:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80100c:	f6 c4 04             	test   $0x4,%ah
  80100f:	0f 85 5b ff ff ff    	jne    800f70 <fork+0x6a>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  801015:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80101c:	a8 02                	test   $0x2,%al
  80101e:	0f 85 66 ff ff ff    	jne    800f8a <fork+0x84>
  801024:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80102b:	f6 c4 08             	test   $0x8,%ah
  80102e:	0f 85 56 ff ff ff    	jne    800f8a <fork+0x84>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  801034:	c1 e6 0c             	shl    $0xc,%esi
  801037:	83 ec 0c             	sub    $0xc,%esp
  80103a:	6a 05                	push   $0x5
  80103c:	56                   	push   %esi
  80103d:	57                   	push   %edi
  80103e:	56                   	push   %esi
  80103f:	6a 00                	push   $0x0
  801041:	e8 16 fc ff ff       	call   800c5c <sys_page_map>
  801046:	83 c4 20             	add    $0x20,%esp
  801049:	85 c0                	test   %eax,%eax
  80104b:	0f 89 77 ff ff ff    	jns    800fc8 <fork+0xc2>
		panic("duppage: %e\n", r);
  801051:	50                   	push   %eax
  801052:	68 ce 26 80 00       	push   $0x8026ce
  801057:	68 0c 01 00 00       	push   $0x10c
  80105c:	68 a6 26 80 00       	push   $0x8026a6
  801061:	e8 18 0f 00 00       	call   801f7e <_panic>
			panic("duppage: %e\n", r);
  801066:	50                   	push   %eax
  801067:	68 ce 26 80 00       	push   $0x8026ce
  80106c:	68 05 01 00 00       	push   $0x105
  801071:	68 a6 26 80 00       	push   $0x8026a6
  801076:	e8 03 0f 00 00       	call   801f7e <_panic>
			panic("duppage: %e\n", r);
  80107b:	50                   	push   %eax
  80107c:	68 ce 26 80 00       	push   $0x8026ce
  801081:	68 09 01 00 00       	push   $0x109
  801086:	68 a6 26 80 00       	push   $0x8026a6
  80108b:	e8 ee 0e 00 00       	call   801f7e <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  801090:	83 ec 04             	sub    $0x4,%esp
  801093:	6a 07                	push   $0x7
  801095:	68 00 f0 bf ee       	push   $0xeebff000
  80109a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80109d:	e8 73 fb ff ff       	call   800c15 <sys_page_alloc>
  8010a2:	83 c4 10             	add    $0x10,%esp
  8010a5:	85 c0                	test   %eax,%eax
  8010a7:	78 2e                	js     8010d7 <fork+0x1d1>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8010a9:	83 ec 08             	sub    $0x8,%esp
  8010ac:	68 3b 20 80 00       	push   $0x80203b
  8010b1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8010b4:	57                   	push   %edi
  8010b5:	e8 ba fc ff ff       	call   800d74 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8010ba:	83 c4 08             	add    $0x8,%esp
  8010bd:	6a 02                	push   $0x2
  8010bf:	57                   	push   %edi
  8010c0:	e8 23 fc ff ff       	call   800ce8 <sys_env_set_status>
  8010c5:	83 c4 10             	add    $0x10,%esp
  8010c8:	85 c0                	test   %eax,%eax
  8010ca:	78 20                	js     8010ec <fork+0x1e6>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  8010cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8010cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010d2:	5b                   	pop    %ebx
  8010d3:	5e                   	pop    %esi
  8010d4:	5f                   	pop    %edi
  8010d5:	5d                   	pop    %ebp
  8010d6:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  8010d7:	50                   	push   %eax
  8010d8:	68 db 26 80 00       	push   $0x8026db
  8010dd:	68 3e 01 00 00       	push   $0x13e
  8010e2:	68 a6 26 80 00       	push   $0x8026a6
  8010e7:	e8 92 0e 00 00       	call   801f7e <_panic>
		panic("sys_env_set_status: %e", r);
  8010ec:	50                   	push   %eax
  8010ed:	68 ee 26 80 00       	push   $0x8026ee
  8010f2:	68 43 01 00 00       	push   $0x143
  8010f7:	68 a6 26 80 00       	push   $0x8026a6
  8010fc:	e8 7d 0e 00 00       	call   801f7e <_panic>

00801101 <sfork>:

// Challenge!
int
sfork(void)
{
  801101:	f3 0f 1e fb          	endbr32 
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
  801108:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80110b:	68 05 27 80 00       	push   $0x802705
  801110:	68 4c 01 00 00       	push   $0x14c
  801115:	68 a6 26 80 00       	push   $0x8026a6
  80111a:	e8 5f 0e 00 00       	call   801f7e <_panic>

0080111f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80111f:	f3 0f 1e fb          	endbr32 
  801123:	55                   	push   %ebp
  801124:	89 e5                	mov    %esp,%ebp
  801126:	56                   	push   %esi
  801127:	53                   	push   %ebx
  801128:	8b 75 08             	mov    0x8(%ebp),%esi
  80112b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  801131:	85 c0                	test   %eax,%eax
  801133:	74 3d                	je     801172 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  801135:	83 ec 0c             	sub    $0xc,%esp
  801138:	50                   	push   %eax
  801139:	e8 a3 fc ff ff       	call   800de1 <sys_ipc_recv>
  80113e:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  801141:	85 f6                	test   %esi,%esi
  801143:	74 0b                	je     801150 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801145:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80114b:	8b 52 74             	mov    0x74(%edx),%edx
  80114e:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801150:	85 db                	test   %ebx,%ebx
  801152:	74 0b                	je     80115f <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  801154:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80115a:	8b 52 78             	mov    0x78(%edx),%edx
  80115d:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  80115f:	85 c0                	test   %eax,%eax
  801161:	78 21                	js     801184 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  801163:	a1 04 40 80 00       	mov    0x804004,%eax
  801168:	8b 40 70             	mov    0x70(%eax),%eax
}
  80116b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80116e:	5b                   	pop    %ebx
  80116f:	5e                   	pop    %esi
  801170:	5d                   	pop    %ebp
  801171:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  801172:	83 ec 0c             	sub    $0xc,%esp
  801175:	68 00 00 c0 ee       	push   $0xeec00000
  80117a:	e8 62 fc ff ff       	call   800de1 <sys_ipc_recv>
  80117f:	83 c4 10             	add    $0x10,%esp
  801182:	eb bd                	jmp    801141 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  801184:	85 f6                	test   %esi,%esi
  801186:	74 10                	je     801198 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  801188:	85 db                	test   %ebx,%ebx
  80118a:	75 df                	jne    80116b <ipc_recv+0x4c>
  80118c:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801193:	00 00 00 
  801196:	eb d3                	jmp    80116b <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  801198:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80119f:	00 00 00 
  8011a2:	eb e4                	jmp    801188 <ipc_recv+0x69>

008011a4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8011a4:	f3 0f 1e fb          	endbr32 
  8011a8:	55                   	push   %ebp
  8011a9:	89 e5                	mov    %esp,%ebp
  8011ab:	57                   	push   %edi
  8011ac:	56                   	push   %esi
  8011ad:	53                   	push   %ebx
  8011ae:	83 ec 0c             	sub    $0xc,%esp
  8011b1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011b4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  8011ba:	85 db                	test   %ebx,%ebx
  8011bc:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8011c1:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  8011c4:	ff 75 14             	pushl  0x14(%ebp)
  8011c7:	53                   	push   %ebx
  8011c8:	56                   	push   %esi
  8011c9:	57                   	push   %edi
  8011ca:	e8 eb fb ff ff       	call   800dba <sys_ipc_try_send>
  8011cf:	83 c4 10             	add    $0x10,%esp
  8011d2:	85 c0                	test   %eax,%eax
  8011d4:	79 1e                	jns    8011f4 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  8011d6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8011d9:	75 07                	jne    8011e2 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  8011db:	e8 12 fa ff ff       	call   800bf2 <sys_yield>
  8011e0:	eb e2                	jmp    8011c4 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  8011e2:	50                   	push   %eax
  8011e3:	68 1b 27 80 00       	push   $0x80271b
  8011e8:	6a 59                	push   $0x59
  8011ea:	68 36 27 80 00       	push   $0x802736
  8011ef:	e8 8a 0d 00 00       	call   801f7e <_panic>
	}
}
  8011f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011f7:	5b                   	pop    %ebx
  8011f8:	5e                   	pop    %esi
  8011f9:	5f                   	pop    %edi
  8011fa:	5d                   	pop    %ebp
  8011fb:	c3                   	ret    

008011fc <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8011fc:	f3 0f 1e fb          	endbr32 
  801200:	55                   	push   %ebp
  801201:	89 e5                	mov    %esp,%ebp
  801203:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801206:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80120b:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80120e:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801214:	8b 52 50             	mov    0x50(%edx),%edx
  801217:	39 ca                	cmp    %ecx,%edx
  801219:	74 11                	je     80122c <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80121b:	83 c0 01             	add    $0x1,%eax
  80121e:	3d 00 04 00 00       	cmp    $0x400,%eax
  801223:	75 e6                	jne    80120b <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801225:	b8 00 00 00 00       	mov    $0x0,%eax
  80122a:	eb 0b                	jmp    801237 <ipc_find_env+0x3b>
			return envs[i].env_id;
  80122c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80122f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801234:	8b 40 48             	mov    0x48(%eax),%eax
}
  801237:	5d                   	pop    %ebp
  801238:	c3                   	ret    

00801239 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801239:	f3 0f 1e fb          	endbr32 
  80123d:	55                   	push   %ebp
  80123e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	05 00 00 00 30       	add    $0x30000000,%eax
  801248:	c1 e8 0c             	shr    $0xc,%eax
}
  80124b:	5d                   	pop    %ebp
  80124c:	c3                   	ret    

0080124d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80124d:	f3 0f 1e fb          	endbr32 
  801251:	55                   	push   %ebp
  801252:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801254:	8b 45 08             	mov    0x8(%ebp),%eax
  801257:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80125c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801261:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801266:	5d                   	pop    %ebp
  801267:	c3                   	ret    

00801268 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801268:	f3 0f 1e fb          	endbr32 
  80126c:	55                   	push   %ebp
  80126d:	89 e5                	mov    %esp,%ebp
  80126f:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801274:	89 c2                	mov    %eax,%edx
  801276:	c1 ea 16             	shr    $0x16,%edx
  801279:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801280:	f6 c2 01             	test   $0x1,%dl
  801283:	74 2d                	je     8012b2 <fd_alloc+0x4a>
  801285:	89 c2                	mov    %eax,%edx
  801287:	c1 ea 0c             	shr    $0xc,%edx
  80128a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801291:	f6 c2 01             	test   $0x1,%dl
  801294:	74 1c                	je     8012b2 <fd_alloc+0x4a>
  801296:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80129b:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012a0:	75 d2                	jne    801274 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8012ab:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8012b0:	eb 0a                	jmp    8012bc <fd_alloc+0x54>
			*fd_store = fd;
  8012b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012b5:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012bc:	5d                   	pop    %ebp
  8012bd:	c3                   	ret    

008012be <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8012be:	f3 0f 1e fb          	endbr32 
  8012c2:	55                   	push   %ebp
  8012c3:	89 e5                	mov    %esp,%ebp
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8012c8:	83 f8 1f             	cmp    $0x1f,%eax
  8012cb:	77 30                	ja     8012fd <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8012cd:	c1 e0 0c             	shl    $0xc,%eax
  8012d0:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8012d5:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8012db:	f6 c2 01             	test   $0x1,%dl
  8012de:	74 24                	je     801304 <fd_lookup+0x46>
  8012e0:	89 c2                	mov    %eax,%edx
  8012e2:	c1 ea 0c             	shr    $0xc,%edx
  8012e5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012ec:	f6 c2 01             	test   $0x1,%dl
  8012ef:	74 1a                	je     80130b <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f4:	89 02                	mov    %eax,(%edx)
	return 0;
  8012f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012fb:	5d                   	pop    %ebp
  8012fc:	c3                   	ret    
		return -E_INVAL;
  8012fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801302:	eb f7                	jmp    8012fb <fd_lookup+0x3d>
		return -E_INVAL;
  801304:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801309:	eb f0                	jmp    8012fb <fd_lookup+0x3d>
  80130b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801310:	eb e9                	jmp    8012fb <fd_lookup+0x3d>

00801312 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801312:	f3 0f 1e fb          	endbr32 
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
  801319:	83 ec 08             	sub    $0x8,%esp
  80131c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80131f:	ba bc 27 80 00       	mov    $0x8027bc,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801324:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801329:	39 08                	cmp    %ecx,(%eax)
  80132b:	74 33                	je     801360 <dev_lookup+0x4e>
  80132d:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801330:	8b 02                	mov    (%edx),%eax
  801332:	85 c0                	test   %eax,%eax
  801334:	75 f3                	jne    801329 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801336:	a1 04 40 80 00       	mov    0x804004,%eax
  80133b:	8b 40 48             	mov    0x48(%eax),%eax
  80133e:	83 ec 04             	sub    $0x4,%esp
  801341:	51                   	push   %ecx
  801342:	50                   	push   %eax
  801343:	68 40 27 80 00       	push   $0x802740
  801348:	e8 7c ee ff ff       	call   8001c9 <cprintf>
	*dev = 0;
  80134d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801350:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801356:	83 c4 10             	add    $0x10,%esp
  801359:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80135e:	c9                   	leave  
  80135f:	c3                   	ret    
			*dev = devtab[i];
  801360:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801363:	89 01                	mov    %eax,(%ecx)
			return 0;
  801365:	b8 00 00 00 00       	mov    $0x0,%eax
  80136a:	eb f2                	jmp    80135e <dev_lookup+0x4c>

0080136c <fd_close>:
{
  80136c:	f3 0f 1e fb          	endbr32 
  801370:	55                   	push   %ebp
  801371:	89 e5                	mov    %esp,%ebp
  801373:	57                   	push   %edi
  801374:	56                   	push   %esi
  801375:	53                   	push   %ebx
  801376:	83 ec 24             	sub    $0x24,%esp
  801379:	8b 75 08             	mov    0x8(%ebp),%esi
  80137c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80137f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801382:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801383:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801389:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80138c:	50                   	push   %eax
  80138d:	e8 2c ff ff ff       	call   8012be <fd_lookup>
  801392:	89 c3                	mov    %eax,%ebx
  801394:	83 c4 10             	add    $0x10,%esp
  801397:	85 c0                	test   %eax,%eax
  801399:	78 05                	js     8013a0 <fd_close+0x34>
	    || fd != fd2)
  80139b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80139e:	74 16                	je     8013b6 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8013a0:	89 f8                	mov    %edi,%eax
  8013a2:	84 c0                	test   %al,%al
  8013a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a9:	0f 44 d8             	cmove  %eax,%ebx
}
  8013ac:	89 d8                	mov    %ebx,%eax
  8013ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013b1:	5b                   	pop    %ebx
  8013b2:	5e                   	pop    %esi
  8013b3:	5f                   	pop    %edi
  8013b4:	5d                   	pop    %ebp
  8013b5:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8013b6:	83 ec 08             	sub    $0x8,%esp
  8013b9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8013bc:	50                   	push   %eax
  8013bd:	ff 36                	pushl  (%esi)
  8013bf:	e8 4e ff ff ff       	call   801312 <dev_lookup>
  8013c4:	89 c3                	mov    %eax,%ebx
  8013c6:	83 c4 10             	add    $0x10,%esp
  8013c9:	85 c0                	test   %eax,%eax
  8013cb:	78 1a                	js     8013e7 <fd_close+0x7b>
		if (dev->dev_close)
  8013cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013d0:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8013d3:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8013d8:	85 c0                	test   %eax,%eax
  8013da:	74 0b                	je     8013e7 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8013dc:	83 ec 0c             	sub    $0xc,%esp
  8013df:	56                   	push   %esi
  8013e0:	ff d0                	call   *%eax
  8013e2:	89 c3                	mov    %eax,%ebx
  8013e4:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8013e7:	83 ec 08             	sub    $0x8,%esp
  8013ea:	56                   	push   %esi
  8013eb:	6a 00                	push   $0x0
  8013ed:	e8 b0 f8 ff ff       	call   800ca2 <sys_page_unmap>
	return r;
  8013f2:	83 c4 10             	add    $0x10,%esp
  8013f5:	eb b5                	jmp    8013ac <fd_close+0x40>

008013f7 <close>:

int
close(int fdnum)
{
  8013f7:	f3 0f 1e fb          	endbr32 
  8013fb:	55                   	push   %ebp
  8013fc:	89 e5                	mov    %esp,%ebp
  8013fe:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801401:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801404:	50                   	push   %eax
  801405:	ff 75 08             	pushl  0x8(%ebp)
  801408:	e8 b1 fe ff ff       	call   8012be <fd_lookup>
  80140d:	83 c4 10             	add    $0x10,%esp
  801410:	85 c0                	test   %eax,%eax
  801412:	79 02                	jns    801416 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801414:	c9                   	leave  
  801415:	c3                   	ret    
		return fd_close(fd, 1);
  801416:	83 ec 08             	sub    $0x8,%esp
  801419:	6a 01                	push   $0x1
  80141b:	ff 75 f4             	pushl  -0xc(%ebp)
  80141e:	e8 49 ff ff ff       	call   80136c <fd_close>
  801423:	83 c4 10             	add    $0x10,%esp
  801426:	eb ec                	jmp    801414 <close+0x1d>

00801428 <close_all>:

void
close_all(void)
{
  801428:	f3 0f 1e fb          	endbr32 
  80142c:	55                   	push   %ebp
  80142d:	89 e5                	mov    %esp,%ebp
  80142f:	53                   	push   %ebx
  801430:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801433:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801438:	83 ec 0c             	sub    $0xc,%esp
  80143b:	53                   	push   %ebx
  80143c:	e8 b6 ff ff ff       	call   8013f7 <close>
	for (i = 0; i < MAXFD; i++)
  801441:	83 c3 01             	add    $0x1,%ebx
  801444:	83 c4 10             	add    $0x10,%esp
  801447:	83 fb 20             	cmp    $0x20,%ebx
  80144a:	75 ec                	jne    801438 <close_all+0x10>
}
  80144c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80144f:	c9                   	leave  
  801450:	c3                   	ret    

00801451 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801451:	f3 0f 1e fb          	endbr32 
  801455:	55                   	push   %ebp
  801456:	89 e5                	mov    %esp,%ebp
  801458:	57                   	push   %edi
  801459:	56                   	push   %esi
  80145a:	53                   	push   %ebx
  80145b:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80145e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801461:	50                   	push   %eax
  801462:	ff 75 08             	pushl  0x8(%ebp)
  801465:	e8 54 fe ff ff       	call   8012be <fd_lookup>
  80146a:	89 c3                	mov    %eax,%ebx
  80146c:	83 c4 10             	add    $0x10,%esp
  80146f:	85 c0                	test   %eax,%eax
  801471:	0f 88 81 00 00 00    	js     8014f8 <dup+0xa7>
		return r;
	close(newfdnum);
  801477:	83 ec 0c             	sub    $0xc,%esp
  80147a:	ff 75 0c             	pushl  0xc(%ebp)
  80147d:	e8 75 ff ff ff       	call   8013f7 <close>

	newfd = INDEX2FD(newfdnum);
  801482:	8b 75 0c             	mov    0xc(%ebp),%esi
  801485:	c1 e6 0c             	shl    $0xc,%esi
  801488:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80148e:	83 c4 04             	add    $0x4,%esp
  801491:	ff 75 e4             	pushl  -0x1c(%ebp)
  801494:	e8 b4 fd ff ff       	call   80124d <fd2data>
  801499:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80149b:	89 34 24             	mov    %esi,(%esp)
  80149e:	e8 aa fd ff ff       	call   80124d <fd2data>
  8014a3:	83 c4 10             	add    $0x10,%esp
  8014a6:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8014a8:	89 d8                	mov    %ebx,%eax
  8014aa:	c1 e8 16             	shr    $0x16,%eax
  8014ad:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014b4:	a8 01                	test   $0x1,%al
  8014b6:	74 11                	je     8014c9 <dup+0x78>
  8014b8:	89 d8                	mov    %ebx,%eax
  8014ba:	c1 e8 0c             	shr    $0xc,%eax
  8014bd:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014c4:	f6 c2 01             	test   $0x1,%dl
  8014c7:	75 39                	jne    801502 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8014c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014cc:	89 d0                	mov    %edx,%eax
  8014ce:	c1 e8 0c             	shr    $0xc,%eax
  8014d1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014d8:	83 ec 0c             	sub    $0xc,%esp
  8014db:	25 07 0e 00 00       	and    $0xe07,%eax
  8014e0:	50                   	push   %eax
  8014e1:	56                   	push   %esi
  8014e2:	6a 00                	push   $0x0
  8014e4:	52                   	push   %edx
  8014e5:	6a 00                	push   $0x0
  8014e7:	e8 70 f7 ff ff       	call   800c5c <sys_page_map>
  8014ec:	89 c3                	mov    %eax,%ebx
  8014ee:	83 c4 20             	add    $0x20,%esp
  8014f1:	85 c0                	test   %eax,%eax
  8014f3:	78 31                	js     801526 <dup+0xd5>
		goto err;

	return newfdnum;
  8014f5:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8014f8:	89 d8                	mov    %ebx,%eax
  8014fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014fd:	5b                   	pop    %ebx
  8014fe:	5e                   	pop    %esi
  8014ff:	5f                   	pop    %edi
  801500:	5d                   	pop    %ebp
  801501:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801502:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801509:	83 ec 0c             	sub    $0xc,%esp
  80150c:	25 07 0e 00 00       	and    $0xe07,%eax
  801511:	50                   	push   %eax
  801512:	57                   	push   %edi
  801513:	6a 00                	push   $0x0
  801515:	53                   	push   %ebx
  801516:	6a 00                	push   $0x0
  801518:	e8 3f f7 ff ff       	call   800c5c <sys_page_map>
  80151d:	89 c3                	mov    %eax,%ebx
  80151f:	83 c4 20             	add    $0x20,%esp
  801522:	85 c0                	test   %eax,%eax
  801524:	79 a3                	jns    8014c9 <dup+0x78>
	sys_page_unmap(0, newfd);
  801526:	83 ec 08             	sub    $0x8,%esp
  801529:	56                   	push   %esi
  80152a:	6a 00                	push   $0x0
  80152c:	e8 71 f7 ff ff       	call   800ca2 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801531:	83 c4 08             	add    $0x8,%esp
  801534:	57                   	push   %edi
  801535:	6a 00                	push   $0x0
  801537:	e8 66 f7 ff ff       	call   800ca2 <sys_page_unmap>
	return r;
  80153c:	83 c4 10             	add    $0x10,%esp
  80153f:	eb b7                	jmp    8014f8 <dup+0xa7>

00801541 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801541:	f3 0f 1e fb          	endbr32 
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
  801548:	53                   	push   %ebx
  801549:	83 ec 1c             	sub    $0x1c,%esp
  80154c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80154f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801552:	50                   	push   %eax
  801553:	53                   	push   %ebx
  801554:	e8 65 fd ff ff       	call   8012be <fd_lookup>
  801559:	83 c4 10             	add    $0x10,%esp
  80155c:	85 c0                	test   %eax,%eax
  80155e:	78 3f                	js     80159f <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801560:	83 ec 08             	sub    $0x8,%esp
  801563:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801566:	50                   	push   %eax
  801567:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80156a:	ff 30                	pushl  (%eax)
  80156c:	e8 a1 fd ff ff       	call   801312 <dev_lookup>
  801571:	83 c4 10             	add    $0x10,%esp
  801574:	85 c0                	test   %eax,%eax
  801576:	78 27                	js     80159f <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801578:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80157b:	8b 42 08             	mov    0x8(%edx),%eax
  80157e:	83 e0 03             	and    $0x3,%eax
  801581:	83 f8 01             	cmp    $0x1,%eax
  801584:	74 1e                	je     8015a4 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801586:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801589:	8b 40 08             	mov    0x8(%eax),%eax
  80158c:	85 c0                	test   %eax,%eax
  80158e:	74 35                	je     8015c5 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801590:	83 ec 04             	sub    $0x4,%esp
  801593:	ff 75 10             	pushl  0x10(%ebp)
  801596:	ff 75 0c             	pushl  0xc(%ebp)
  801599:	52                   	push   %edx
  80159a:	ff d0                	call   *%eax
  80159c:	83 c4 10             	add    $0x10,%esp
}
  80159f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015a2:	c9                   	leave  
  8015a3:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8015a4:	a1 04 40 80 00       	mov    0x804004,%eax
  8015a9:	8b 40 48             	mov    0x48(%eax),%eax
  8015ac:	83 ec 04             	sub    $0x4,%esp
  8015af:	53                   	push   %ebx
  8015b0:	50                   	push   %eax
  8015b1:	68 81 27 80 00       	push   $0x802781
  8015b6:	e8 0e ec ff ff       	call   8001c9 <cprintf>
		return -E_INVAL;
  8015bb:	83 c4 10             	add    $0x10,%esp
  8015be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015c3:	eb da                	jmp    80159f <read+0x5e>
		return -E_NOT_SUPP;
  8015c5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015ca:	eb d3                	jmp    80159f <read+0x5e>

008015cc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8015cc:	f3 0f 1e fb          	endbr32 
  8015d0:	55                   	push   %ebp
  8015d1:	89 e5                	mov    %esp,%ebp
  8015d3:	57                   	push   %edi
  8015d4:	56                   	push   %esi
  8015d5:	53                   	push   %ebx
  8015d6:	83 ec 0c             	sub    $0xc,%esp
  8015d9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015dc:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015df:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015e4:	eb 02                	jmp    8015e8 <readn+0x1c>
  8015e6:	01 c3                	add    %eax,%ebx
  8015e8:	39 f3                	cmp    %esi,%ebx
  8015ea:	73 21                	jae    80160d <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015ec:	83 ec 04             	sub    $0x4,%esp
  8015ef:	89 f0                	mov    %esi,%eax
  8015f1:	29 d8                	sub    %ebx,%eax
  8015f3:	50                   	push   %eax
  8015f4:	89 d8                	mov    %ebx,%eax
  8015f6:	03 45 0c             	add    0xc(%ebp),%eax
  8015f9:	50                   	push   %eax
  8015fa:	57                   	push   %edi
  8015fb:	e8 41 ff ff ff       	call   801541 <read>
		if (m < 0)
  801600:	83 c4 10             	add    $0x10,%esp
  801603:	85 c0                	test   %eax,%eax
  801605:	78 04                	js     80160b <readn+0x3f>
			return m;
		if (m == 0)
  801607:	75 dd                	jne    8015e6 <readn+0x1a>
  801609:	eb 02                	jmp    80160d <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80160b:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80160d:	89 d8                	mov    %ebx,%eax
  80160f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801612:	5b                   	pop    %ebx
  801613:	5e                   	pop    %esi
  801614:	5f                   	pop    %edi
  801615:	5d                   	pop    %ebp
  801616:	c3                   	ret    

00801617 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801617:	f3 0f 1e fb          	endbr32 
  80161b:	55                   	push   %ebp
  80161c:	89 e5                	mov    %esp,%ebp
  80161e:	53                   	push   %ebx
  80161f:	83 ec 1c             	sub    $0x1c,%esp
  801622:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801625:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801628:	50                   	push   %eax
  801629:	53                   	push   %ebx
  80162a:	e8 8f fc ff ff       	call   8012be <fd_lookup>
  80162f:	83 c4 10             	add    $0x10,%esp
  801632:	85 c0                	test   %eax,%eax
  801634:	78 3a                	js     801670 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801636:	83 ec 08             	sub    $0x8,%esp
  801639:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80163c:	50                   	push   %eax
  80163d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801640:	ff 30                	pushl  (%eax)
  801642:	e8 cb fc ff ff       	call   801312 <dev_lookup>
  801647:	83 c4 10             	add    $0x10,%esp
  80164a:	85 c0                	test   %eax,%eax
  80164c:	78 22                	js     801670 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80164e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801651:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801655:	74 1e                	je     801675 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801657:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80165a:	8b 52 0c             	mov    0xc(%edx),%edx
  80165d:	85 d2                	test   %edx,%edx
  80165f:	74 35                	je     801696 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801661:	83 ec 04             	sub    $0x4,%esp
  801664:	ff 75 10             	pushl  0x10(%ebp)
  801667:	ff 75 0c             	pushl  0xc(%ebp)
  80166a:	50                   	push   %eax
  80166b:	ff d2                	call   *%edx
  80166d:	83 c4 10             	add    $0x10,%esp
}
  801670:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801673:	c9                   	leave  
  801674:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801675:	a1 04 40 80 00       	mov    0x804004,%eax
  80167a:	8b 40 48             	mov    0x48(%eax),%eax
  80167d:	83 ec 04             	sub    $0x4,%esp
  801680:	53                   	push   %ebx
  801681:	50                   	push   %eax
  801682:	68 9d 27 80 00       	push   $0x80279d
  801687:	e8 3d eb ff ff       	call   8001c9 <cprintf>
		return -E_INVAL;
  80168c:	83 c4 10             	add    $0x10,%esp
  80168f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801694:	eb da                	jmp    801670 <write+0x59>
		return -E_NOT_SUPP;
  801696:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80169b:	eb d3                	jmp    801670 <write+0x59>

0080169d <seek>:

int
seek(int fdnum, off_t offset)
{
  80169d:	f3 0f 1e fb          	endbr32 
  8016a1:	55                   	push   %ebp
  8016a2:	89 e5                	mov    %esp,%ebp
  8016a4:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016aa:	50                   	push   %eax
  8016ab:	ff 75 08             	pushl  0x8(%ebp)
  8016ae:	e8 0b fc ff ff       	call   8012be <fd_lookup>
  8016b3:	83 c4 10             	add    $0x10,%esp
  8016b6:	85 c0                	test   %eax,%eax
  8016b8:	78 0e                	js     8016c8 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8016ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c0:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8016c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016c8:	c9                   	leave  
  8016c9:	c3                   	ret    

008016ca <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8016ca:	f3 0f 1e fb          	endbr32 
  8016ce:	55                   	push   %ebp
  8016cf:	89 e5                	mov    %esp,%ebp
  8016d1:	53                   	push   %ebx
  8016d2:	83 ec 1c             	sub    $0x1c,%esp
  8016d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016d8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016db:	50                   	push   %eax
  8016dc:	53                   	push   %ebx
  8016dd:	e8 dc fb ff ff       	call   8012be <fd_lookup>
  8016e2:	83 c4 10             	add    $0x10,%esp
  8016e5:	85 c0                	test   %eax,%eax
  8016e7:	78 37                	js     801720 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016e9:	83 ec 08             	sub    $0x8,%esp
  8016ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016ef:	50                   	push   %eax
  8016f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f3:	ff 30                	pushl  (%eax)
  8016f5:	e8 18 fc ff ff       	call   801312 <dev_lookup>
  8016fa:	83 c4 10             	add    $0x10,%esp
  8016fd:	85 c0                	test   %eax,%eax
  8016ff:	78 1f                	js     801720 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801701:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801704:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801708:	74 1b                	je     801725 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80170a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80170d:	8b 52 18             	mov    0x18(%edx),%edx
  801710:	85 d2                	test   %edx,%edx
  801712:	74 32                	je     801746 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801714:	83 ec 08             	sub    $0x8,%esp
  801717:	ff 75 0c             	pushl  0xc(%ebp)
  80171a:	50                   	push   %eax
  80171b:	ff d2                	call   *%edx
  80171d:	83 c4 10             	add    $0x10,%esp
}
  801720:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801723:	c9                   	leave  
  801724:	c3                   	ret    
			thisenv->env_id, fdnum);
  801725:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80172a:	8b 40 48             	mov    0x48(%eax),%eax
  80172d:	83 ec 04             	sub    $0x4,%esp
  801730:	53                   	push   %ebx
  801731:	50                   	push   %eax
  801732:	68 60 27 80 00       	push   $0x802760
  801737:	e8 8d ea ff ff       	call   8001c9 <cprintf>
		return -E_INVAL;
  80173c:	83 c4 10             	add    $0x10,%esp
  80173f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801744:	eb da                	jmp    801720 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801746:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80174b:	eb d3                	jmp    801720 <ftruncate+0x56>

0080174d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80174d:	f3 0f 1e fb          	endbr32 
  801751:	55                   	push   %ebp
  801752:	89 e5                	mov    %esp,%ebp
  801754:	53                   	push   %ebx
  801755:	83 ec 1c             	sub    $0x1c,%esp
  801758:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80175b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80175e:	50                   	push   %eax
  80175f:	ff 75 08             	pushl  0x8(%ebp)
  801762:	e8 57 fb ff ff       	call   8012be <fd_lookup>
  801767:	83 c4 10             	add    $0x10,%esp
  80176a:	85 c0                	test   %eax,%eax
  80176c:	78 4b                	js     8017b9 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80176e:	83 ec 08             	sub    $0x8,%esp
  801771:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801774:	50                   	push   %eax
  801775:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801778:	ff 30                	pushl  (%eax)
  80177a:	e8 93 fb ff ff       	call   801312 <dev_lookup>
  80177f:	83 c4 10             	add    $0x10,%esp
  801782:	85 c0                	test   %eax,%eax
  801784:	78 33                	js     8017b9 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801786:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801789:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80178d:	74 2f                	je     8017be <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80178f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801792:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801799:	00 00 00 
	stat->st_isdir = 0;
  80179c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017a3:	00 00 00 
	stat->st_dev = dev;
  8017a6:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8017ac:	83 ec 08             	sub    $0x8,%esp
  8017af:	53                   	push   %ebx
  8017b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8017b3:	ff 50 14             	call   *0x14(%eax)
  8017b6:	83 c4 10             	add    $0x10,%esp
}
  8017b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017bc:	c9                   	leave  
  8017bd:	c3                   	ret    
		return -E_NOT_SUPP;
  8017be:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017c3:	eb f4                	jmp    8017b9 <fstat+0x6c>

008017c5 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8017c5:	f3 0f 1e fb          	endbr32 
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
  8017cc:	56                   	push   %esi
  8017cd:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8017ce:	83 ec 08             	sub    $0x8,%esp
  8017d1:	6a 00                	push   $0x0
  8017d3:	ff 75 08             	pushl  0x8(%ebp)
  8017d6:	e8 fb 01 00 00       	call   8019d6 <open>
  8017db:	89 c3                	mov    %eax,%ebx
  8017dd:	83 c4 10             	add    $0x10,%esp
  8017e0:	85 c0                	test   %eax,%eax
  8017e2:	78 1b                	js     8017ff <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8017e4:	83 ec 08             	sub    $0x8,%esp
  8017e7:	ff 75 0c             	pushl  0xc(%ebp)
  8017ea:	50                   	push   %eax
  8017eb:	e8 5d ff ff ff       	call   80174d <fstat>
  8017f0:	89 c6                	mov    %eax,%esi
	close(fd);
  8017f2:	89 1c 24             	mov    %ebx,(%esp)
  8017f5:	e8 fd fb ff ff       	call   8013f7 <close>
	return r;
  8017fa:	83 c4 10             	add    $0x10,%esp
  8017fd:	89 f3                	mov    %esi,%ebx
}
  8017ff:	89 d8                	mov    %ebx,%eax
  801801:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801804:	5b                   	pop    %ebx
  801805:	5e                   	pop    %esi
  801806:	5d                   	pop    %ebp
  801807:	c3                   	ret    

00801808 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
  80180b:	56                   	push   %esi
  80180c:	53                   	push   %ebx
  80180d:	89 c6                	mov    %eax,%esi
  80180f:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801811:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801818:	74 27                	je     801841 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80181a:	6a 07                	push   $0x7
  80181c:	68 00 50 80 00       	push   $0x805000
  801821:	56                   	push   %esi
  801822:	ff 35 00 40 80 00    	pushl  0x804000
  801828:	e8 77 f9 ff ff       	call   8011a4 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80182d:	83 c4 0c             	add    $0xc,%esp
  801830:	6a 00                	push   $0x0
  801832:	53                   	push   %ebx
  801833:	6a 00                	push   $0x0
  801835:	e8 e5 f8 ff ff       	call   80111f <ipc_recv>
}
  80183a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80183d:	5b                   	pop    %ebx
  80183e:	5e                   	pop    %esi
  80183f:	5d                   	pop    %ebp
  801840:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801841:	83 ec 0c             	sub    $0xc,%esp
  801844:	6a 01                	push   $0x1
  801846:	e8 b1 f9 ff ff       	call   8011fc <ipc_find_env>
  80184b:	a3 00 40 80 00       	mov    %eax,0x804000
  801850:	83 c4 10             	add    $0x10,%esp
  801853:	eb c5                	jmp    80181a <fsipc+0x12>

00801855 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801855:	f3 0f 1e fb          	endbr32 
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
  80185c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80185f:	8b 45 08             	mov    0x8(%ebp),%eax
  801862:	8b 40 0c             	mov    0xc(%eax),%eax
  801865:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80186a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80186d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801872:	ba 00 00 00 00       	mov    $0x0,%edx
  801877:	b8 02 00 00 00       	mov    $0x2,%eax
  80187c:	e8 87 ff ff ff       	call   801808 <fsipc>
}
  801881:	c9                   	leave  
  801882:	c3                   	ret    

00801883 <devfile_flush>:
{
  801883:	f3 0f 1e fb          	endbr32 
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
  80188a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80188d:	8b 45 08             	mov    0x8(%ebp),%eax
  801890:	8b 40 0c             	mov    0xc(%eax),%eax
  801893:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801898:	ba 00 00 00 00       	mov    $0x0,%edx
  80189d:	b8 06 00 00 00       	mov    $0x6,%eax
  8018a2:	e8 61 ff ff ff       	call   801808 <fsipc>
}
  8018a7:	c9                   	leave  
  8018a8:	c3                   	ret    

008018a9 <devfile_stat>:
{
  8018a9:	f3 0f 1e fb          	endbr32 
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
  8018b0:	53                   	push   %ebx
  8018b1:	83 ec 04             	sub    $0x4,%esp
  8018b4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8018b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8018bd:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8018c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8018c7:	b8 05 00 00 00       	mov    $0x5,%eax
  8018cc:	e8 37 ff ff ff       	call   801808 <fsipc>
  8018d1:	85 c0                	test   %eax,%eax
  8018d3:	78 2c                	js     801901 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8018d5:	83 ec 08             	sub    $0x8,%esp
  8018d8:	68 00 50 80 00       	push   $0x805000
  8018dd:	53                   	push   %ebx
  8018de:	e8 f0 ee ff ff       	call   8007d3 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8018e3:	a1 80 50 80 00       	mov    0x805080,%eax
  8018e8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8018ee:	a1 84 50 80 00       	mov    0x805084,%eax
  8018f3:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8018f9:	83 c4 10             	add    $0x10,%esp
  8018fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801901:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801904:	c9                   	leave  
  801905:	c3                   	ret    

00801906 <devfile_write>:
{
  801906:	f3 0f 1e fb          	endbr32 
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
  80190d:	83 ec 0c             	sub    $0xc,%esp
  801910:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801913:	8b 55 08             	mov    0x8(%ebp),%edx
  801916:	8b 52 0c             	mov    0xc(%edx),%edx
  801919:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  80191f:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801924:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801929:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  80192c:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801931:	50                   	push   %eax
  801932:	ff 75 0c             	pushl  0xc(%ebp)
  801935:	68 08 50 80 00       	push   $0x805008
  80193a:	e8 4a f0 ff ff       	call   800989 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  80193f:	ba 00 00 00 00       	mov    $0x0,%edx
  801944:	b8 04 00 00 00       	mov    $0x4,%eax
  801949:	e8 ba fe ff ff       	call   801808 <fsipc>
}
  80194e:	c9                   	leave  
  80194f:	c3                   	ret    

00801950 <devfile_read>:
{
  801950:	f3 0f 1e fb          	endbr32 
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
  801957:	56                   	push   %esi
  801958:	53                   	push   %ebx
  801959:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80195c:	8b 45 08             	mov    0x8(%ebp),%eax
  80195f:	8b 40 0c             	mov    0xc(%eax),%eax
  801962:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801967:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80196d:	ba 00 00 00 00       	mov    $0x0,%edx
  801972:	b8 03 00 00 00       	mov    $0x3,%eax
  801977:	e8 8c fe ff ff       	call   801808 <fsipc>
  80197c:	89 c3                	mov    %eax,%ebx
  80197e:	85 c0                	test   %eax,%eax
  801980:	78 1f                	js     8019a1 <devfile_read+0x51>
	assert(r <= n);
  801982:	39 f0                	cmp    %esi,%eax
  801984:	77 24                	ja     8019aa <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801986:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80198b:	7f 33                	jg     8019c0 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80198d:	83 ec 04             	sub    $0x4,%esp
  801990:	50                   	push   %eax
  801991:	68 00 50 80 00       	push   $0x805000
  801996:	ff 75 0c             	pushl  0xc(%ebp)
  801999:	e8 eb ef ff ff       	call   800989 <memmove>
	return r;
  80199e:	83 c4 10             	add    $0x10,%esp
}
  8019a1:	89 d8                	mov    %ebx,%eax
  8019a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019a6:	5b                   	pop    %ebx
  8019a7:	5e                   	pop    %esi
  8019a8:	5d                   	pop    %ebp
  8019a9:	c3                   	ret    
	assert(r <= n);
  8019aa:	68 cc 27 80 00       	push   $0x8027cc
  8019af:	68 d3 27 80 00       	push   $0x8027d3
  8019b4:	6a 7c                	push   $0x7c
  8019b6:	68 e8 27 80 00       	push   $0x8027e8
  8019bb:	e8 be 05 00 00       	call   801f7e <_panic>
	assert(r <= PGSIZE);
  8019c0:	68 f3 27 80 00       	push   $0x8027f3
  8019c5:	68 d3 27 80 00       	push   $0x8027d3
  8019ca:	6a 7d                	push   $0x7d
  8019cc:	68 e8 27 80 00       	push   $0x8027e8
  8019d1:	e8 a8 05 00 00       	call   801f7e <_panic>

008019d6 <open>:
{
  8019d6:	f3 0f 1e fb          	endbr32 
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
  8019dd:	56                   	push   %esi
  8019de:	53                   	push   %ebx
  8019df:	83 ec 1c             	sub    $0x1c,%esp
  8019e2:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8019e5:	56                   	push   %esi
  8019e6:	e8 a5 ed ff ff       	call   800790 <strlen>
  8019eb:	83 c4 10             	add    $0x10,%esp
  8019ee:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8019f3:	7f 6c                	jg     801a61 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8019f5:	83 ec 0c             	sub    $0xc,%esp
  8019f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019fb:	50                   	push   %eax
  8019fc:	e8 67 f8 ff ff       	call   801268 <fd_alloc>
  801a01:	89 c3                	mov    %eax,%ebx
  801a03:	83 c4 10             	add    $0x10,%esp
  801a06:	85 c0                	test   %eax,%eax
  801a08:	78 3c                	js     801a46 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801a0a:	83 ec 08             	sub    $0x8,%esp
  801a0d:	56                   	push   %esi
  801a0e:	68 00 50 80 00       	push   $0x805000
  801a13:	e8 bb ed ff ff       	call   8007d3 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a18:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a1b:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a23:	b8 01 00 00 00       	mov    $0x1,%eax
  801a28:	e8 db fd ff ff       	call   801808 <fsipc>
  801a2d:	89 c3                	mov    %eax,%ebx
  801a2f:	83 c4 10             	add    $0x10,%esp
  801a32:	85 c0                	test   %eax,%eax
  801a34:	78 19                	js     801a4f <open+0x79>
	return fd2num(fd);
  801a36:	83 ec 0c             	sub    $0xc,%esp
  801a39:	ff 75 f4             	pushl  -0xc(%ebp)
  801a3c:	e8 f8 f7 ff ff       	call   801239 <fd2num>
  801a41:	89 c3                	mov    %eax,%ebx
  801a43:	83 c4 10             	add    $0x10,%esp
}
  801a46:	89 d8                	mov    %ebx,%eax
  801a48:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a4b:	5b                   	pop    %ebx
  801a4c:	5e                   	pop    %esi
  801a4d:	5d                   	pop    %ebp
  801a4e:	c3                   	ret    
		fd_close(fd, 0);
  801a4f:	83 ec 08             	sub    $0x8,%esp
  801a52:	6a 00                	push   $0x0
  801a54:	ff 75 f4             	pushl  -0xc(%ebp)
  801a57:	e8 10 f9 ff ff       	call   80136c <fd_close>
		return r;
  801a5c:	83 c4 10             	add    $0x10,%esp
  801a5f:	eb e5                	jmp    801a46 <open+0x70>
		return -E_BAD_PATH;
  801a61:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a66:	eb de                	jmp    801a46 <open+0x70>

00801a68 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a68:	f3 0f 1e fb          	endbr32 
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
  801a6f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a72:	ba 00 00 00 00       	mov    $0x0,%edx
  801a77:	b8 08 00 00 00       	mov    $0x8,%eax
  801a7c:	e8 87 fd ff ff       	call   801808 <fsipc>
}
  801a81:	c9                   	leave  
  801a82:	c3                   	ret    

00801a83 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a83:	f3 0f 1e fb          	endbr32 
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
  801a8a:	56                   	push   %esi
  801a8b:	53                   	push   %ebx
  801a8c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801a8f:	83 ec 0c             	sub    $0xc,%esp
  801a92:	ff 75 08             	pushl  0x8(%ebp)
  801a95:	e8 b3 f7 ff ff       	call   80124d <fd2data>
  801a9a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801a9c:	83 c4 08             	add    $0x8,%esp
  801a9f:	68 ff 27 80 00       	push   $0x8027ff
  801aa4:	53                   	push   %ebx
  801aa5:	e8 29 ed ff ff       	call   8007d3 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801aaa:	8b 46 04             	mov    0x4(%esi),%eax
  801aad:	2b 06                	sub    (%esi),%eax
  801aaf:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801ab5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801abc:	00 00 00 
	stat->st_dev = &devpipe;
  801abf:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801ac6:	30 80 00 
	return 0;
}
  801ac9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ace:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ad1:	5b                   	pop    %ebx
  801ad2:	5e                   	pop    %esi
  801ad3:	5d                   	pop    %ebp
  801ad4:	c3                   	ret    

00801ad5 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ad5:	f3 0f 1e fb          	endbr32 
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
  801adc:	53                   	push   %ebx
  801add:	83 ec 0c             	sub    $0xc,%esp
  801ae0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ae3:	53                   	push   %ebx
  801ae4:	6a 00                	push   $0x0
  801ae6:	e8 b7 f1 ff ff       	call   800ca2 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801aeb:	89 1c 24             	mov    %ebx,(%esp)
  801aee:	e8 5a f7 ff ff       	call   80124d <fd2data>
  801af3:	83 c4 08             	add    $0x8,%esp
  801af6:	50                   	push   %eax
  801af7:	6a 00                	push   $0x0
  801af9:	e8 a4 f1 ff ff       	call   800ca2 <sys_page_unmap>
}
  801afe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b01:	c9                   	leave  
  801b02:	c3                   	ret    

00801b03 <_pipeisclosed>:
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
  801b06:	57                   	push   %edi
  801b07:	56                   	push   %esi
  801b08:	53                   	push   %ebx
  801b09:	83 ec 1c             	sub    $0x1c,%esp
  801b0c:	89 c7                	mov    %eax,%edi
  801b0e:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b10:	a1 04 40 80 00       	mov    0x804004,%eax
  801b15:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b18:	83 ec 0c             	sub    $0xc,%esp
  801b1b:	57                   	push   %edi
  801b1c:	e8 40 05 00 00       	call   802061 <pageref>
  801b21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b24:	89 34 24             	mov    %esi,(%esp)
  801b27:	e8 35 05 00 00       	call   802061 <pageref>
		nn = thisenv->env_runs;
  801b2c:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b32:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b35:	83 c4 10             	add    $0x10,%esp
  801b38:	39 cb                	cmp    %ecx,%ebx
  801b3a:	74 1b                	je     801b57 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b3c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b3f:	75 cf                	jne    801b10 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b41:	8b 42 58             	mov    0x58(%edx),%eax
  801b44:	6a 01                	push   $0x1
  801b46:	50                   	push   %eax
  801b47:	53                   	push   %ebx
  801b48:	68 06 28 80 00       	push   $0x802806
  801b4d:	e8 77 e6 ff ff       	call   8001c9 <cprintf>
  801b52:	83 c4 10             	add    $0x10,%esp
  801b55:	eb b9                	jmp    801b10 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801b57:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b5a:	0f 94 c0             	sete   %al
  801b5d:	0f b6 c0             	movzbl %al,%eax
}
  801b60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b63:	5b                   	pop    %ebx
  801b64:	5e                   	pop    %esi
  801b65:	5f                   	pop    %edi
  801b66:	5d                   	pop    %ebp
  801b67:	c3                   	ret    

00801b68 <devpipe_write>:
{
  801b68:	f3 0f 1e fb          	endbr32 
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
  801b6f:	57                   	push   %edi
  801b70:	56                   	push   %esi
  801b71:	53                   	push   %ebx
  801b72:	83 ec 28             	sub    $0x28,%esp
  801b75:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801b78:	56                   	push   %esi
  801b79:	e8 cf f6 ff ff       	call   80124d <fd2data>
  801b7e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b80:	83 c4 10             	add    $0x10,%esp
  801b83:	bf 00 00 00 00       	mov    $0x0,%edi
  801b88:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801b8b:	74 4f                	je     801bdc <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b8d:	8b 43 04             	mov    0x4(%ebx),%eax
  801b90:	8b 0b                	mov    (%ebx),%ecx
  801b92:	8d 51 20             	lea    0x20(%ecx),%edx
  801b95:	39 d0                	cmp    %edx,%eax
  801b97:	72 14                	jb     801bad <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801b99:	89 da                	mov    %ebx,%edx
  801b9b:	89 f0                	mov    %esi,%eax
  801b9d:	e8 61 ff ff ff       	call   801b03 <_pipeisclosed>
  801ba2:	85 c0                	test   %eax,%eax
  801ba4:	75 3b                	jne    801be1 <devpipe_write+0x79>
			sys_yield();
  801ba6:	e8 47 f0 ff ff       	call   800bf2 <sys_yield>
  801bab:	eb e0                	jmp    801b8d <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801bad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bb0:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801bb4:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801bb7:	89 c2                	mov    %eax,%edx
  801bb9:	c1 fa 1f             	sar    $0x1f,%edx
  801bbc:	89 d1                	mov    %edx,%ecx
  801bbe:	c1 e9 1b             	shr    $0x1b,%ecx
  801bc1:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801bc4:	83 e2 1f             	and    $0x1f,%edx
  801bc7:	29 ca                	sub    %ecx,%edx
  801bc9:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801bcd:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801bd1:	83 c0 01             	add    $0x1,%eax
  801bd4:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801bd7:	83 c7 01             	add    $0x1,%edi
  801bda:	eb ac                	jmp    801b88 <devpipe_write+0x20>
	return i;
  801bdc:	8b 45 10             	mov    0x10(%ebp),%eax
  801bdf:	eb 05                	jmp    801be6 <devpipe_write+0x7e>
				return 0;
  801be1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801be6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801be9:	5b                   	pop    %ebx
  801bea:	5e                   	pop    %esi
  801beb:	5f                   	pop    %edi
  801bec:	5d                   	pop    %ebp
  801bed:	c3                   	ret    

00801bee <devpipe_read>:
{
  801bee:	f3 0f 1e fb          	endbr32 
  801bf2:	55                   	push   %ebp
  801bf3:	89 e5                	mov    %esp,%ebp
  801bf5:	57                   	push   %edi
  801bf6:	56                   	push   %esi
  801bf7:	53                   	push   %ebx
  801bf8:	83 ec 18             	sub    $0x18,%esp
  801bfb:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801bfe:	57                   	push   %edi
  801bff:	e8 49 f6 ff ff       	call   80124d <fd2data>
  801c04:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c06:	83 c4 10             	add    $0x10,%esp
  801c09:	be 00 00 00 00       	mov    $0x0,%esi
  801c0e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c11:	75 14                	jne    801c27 <devpipe_read+0x39>
	return i;
  801c13:	8b 45 10             	mov    0x10(%ebp),%eax
  801c16:	eb 02                	jmp    801c1a <devpipe_read+0x2c>
				return i;
  801c18:	89 f0                	mov    %esi,%eax
}
  801c1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c1d:	5b                   	pop    %ebx
  801c1e:	5e                   	pop    %esi
  801c1f:	5f                   	pop    %edi
  801c20:	5d                   	pop    %ebp
  801c21:	c3                   	ret    
			sys_yield();
  801c22:	e8 cb ef ff ff       	call   800bf2 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801c27:	8b 03                	mov    (%ebx),%eax
  801c29:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c2c:	75 18                	jne    801c46 <devpipe_read+0x58>
			if (i > 0)
  801c2e:	85 f6                	test   %esi,%esi
  801c30:	75 e6                	jne    801c18 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801c32:	89 da                	mov    %ebx,%edx
  801c34:	89 f8                	mov    %edi,%eax
  801c36:	e8 c8 fe ff ff       	call   801b03 <_pipeisclosed>
  801c3b:	85 c0                	test   %eax,%eax
  801c3d:	74 e3                	je     801c22 <devpipe_read+0x34>
				return 0;
  801c3f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c44:	eb d4                	jmp    801c1a <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c46:	99                   	cltd   
  801c47:	c1 ea 1b             	shr    $0x1b,%edx
  801c4a:	01 d0                	add    %edx,%eax
  801c4c:	83 e0 1f             	and    $0x1f,%eax
  801c4f:	29 d0                	sub    %edx,%eax
  801c51:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801c56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c59:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801c5c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801c5f:	83 c6 01             	add    $0x1,%esi
  801c62:	eb aa                	jmp    801c0e <devpipe_read+0x20>

00801c64 <pipe>:
{
  801c64:	f3 0f 1e fb          	endbr32 
  801c68:	55                   	push   %ebp
  801c69:	89 e5                	mov    %esp,%ebp
  801c6b:	56                   	push   %esi
  801c6c:	53                   	push   %ebx
  801c6d:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801c70:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c73:	50                   	push   %eax
  801c74:	e8 ef f5 ff ff       	call   801268 <fd_alloc>
  801c79:	89 c3                	mov    %eax,%ebx
  801c7b:	83 c4 10             	add    $0x10,%esp
  801c7e:	85 c0                	test   %eax,%eax
  801c80:	0f 88 23 01 00 00    	js     801da9 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c86:	83 ec 04             	sub    $0x4,%esp
  801c89:	68 07 04 00 00       	push   $0x407
  801c8e:	ff 75 f4             	pushl  -0xc(%ebp)
  801c91:	6a 00                	push   $0x0
  801c93:	e8 7d ef ff ff       	call   800c15 <sys_page_alloc>
  801c98:	89 c3                	mov    %eax,%ebx
  801c9a:	83 c4 10             	add    $0x10,%esp
  801c9d:	85 c0                	test   %eax,%eax
  801c9f:	0f 88 04 01 00 00    	js     801da9 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801ca5:	83 ec 0c             	sub    $0xc,%esp
  801ca8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cab:	50                   	push   %eax
  801cac:	e8 b7 f5 ff ff       	call   801268 <fd_alloc>
  801cb1:	89 c3                	mov    %eax,%ebx
  801cb3:	83 c4 10             	add    $0x10,%esp
  801cb6:	85 c0                	test   %eax,%eax
  801cb8:	0f 88 db 00 00 00    	js     801d99 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cbe:	83 ec 04             	sub    $0x4,%esp
  801cc1:	68 07 04 00 00       	push   $0x407
  801cc6:	ff 75 f0             	pushl  -0x10(%ebp)
  801cc9:	6a 00                	push   $0x0
  801ccb:	e8 45 ef ff ff       	call   800c15 <sys_page_alloc>
  801cd0:	89 c3                	mov    %eax,%ebx
  801cd2:	83 c4 10             	add    $0x10,%esp
  801cd5:	85 c0                	test   %eax,%eax
  801cd7:	0f 88 bc 00 00 00    	js     801d99 <pipe+0x135>
	va = fd2data(fd0);
  801cdd:	83 ec 0c             	sub    $0xc,%esp
  801ce0:	ff 75 f4             	pushl  -0xc(%ebp)
  801ce3:	e8 65 f5 ff ff       	call   80124d <fd2data>
  801ce8:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cea:	83 c4 0c             	add    $0xc,%esp
  801ced:	68 07 04 00 00       	push   $0x407
  801cf2:	50                   	push   %eax
  801cf3:	6a 00                	push   $0x0
  801cf5:	e8 1b ef ff ff       	call   800c15 <sys_page_alloc>
  801cfa:	89 c3                	mov    %eax,%ebx
  801cfc:	83 c4 10             	add    $0x10,%esp
  801cff:	85 c0                	test   %eax,%eax
  801d01:	0f 88 82 00 00 00    	js     801d89 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d07:	83 ec 0c             	sub    $0xc,%esp
  801d0a:	ff 75 f0             	pushl  -0x10(%ebp)
  801d0d:	e8 3b f5 ff ff       	call   80124d <fd2data>
  801d12:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d19:	50                   	push   %eax
  801d1a:	6a 00                	push   $0x0
  801d1c:	56                   	push   %esi
  801d1d:	6a 00                	push   $0x0
  801d1f:	e8 38 ef ff ff       	call   800c5c <sys_page_map>
  801d24:	89 c3                	mov    %eax,%ebx
  801d26:	83 c4 20             	add    $0x20,%esp
  801d29:	85 c0                	test   %eax,%eax
  801d2b:	78 4e                	js     801d7b <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801d2d:	a1 20 30 80 00       	mov    0x803020,%eax
  801d32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d35:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801d37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d3a:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801d41:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d44:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801d46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d49:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801d50:	83 ec 0c             	sub    $0xc,%esp
  801d53:	ff 75 f4             	pushl  -0xc(%ebp)
  801d56:	e8 de f4 ff ff       	call   801239 <fd2num>
  801d5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d5e:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d60:	83 c4 04             	add    $0x4,%esp
  801d63:	ff 75 f0             	pushl  -0x10(%ebp)
  801d66:	e8 ce f4 ff ff       	call   801239 <fd2num>
  801d6b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d6e:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801d71:	83 c4 10             	add    $0x10,%esp
  801d74:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d79:	eb 2e                	jmp    801da9 <pipe+0x145>
	sys_page_unmap(0, va);
  801d7b:	83 ec 08             	sub    $0x8,%esp
  801d7e:	56                   	push   %esi
  801d7f:	6a 00                	push   $0x0
  801d81:	e8 1c ef ff ff       	call   800ca2 <sys_page_unmap>
  801d86:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801d89:	83 ec 08             	sub    $0x8,%esp
  801d8c:	ff 75 f0             	pushl  -0x10(%ebp)
  801d8f:	6a 00                	push   $0x0
  801d91:	e8 0c ef ff ff       	call   800ca2 <sys_page_unmap>
  801d96:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801d99:	83 ec 08             	sub    $0x8,%esp
  801d9c:	ff 75 f4             	pushl  -0xc(%ebp)
  801d9f:	6a 00                	push   $0x0
  801da1:	e8 fc ee ff ff       	call   800ca2 <sys_page_unmap>
  801da6:	83 c4 10             	add    $0x10,%esp
}
  801da9:	89 d8                	mov    %ebx,%eax
  801dab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dae:	5b                   	pop    %ebx
  801daf:	5e                   	pop    %esi
  801db0:	5d                   	pop    %ebp
  801db1:	c3                   	ret    

00801db2 <pipeisclosed>:
{
  801db2:	f3 0f 1e fb          	endbr32 
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
  801db9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801dbc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dbf:	50                   	push   %eax
  801dc0:	ff 75 08             	pushl  0x8(%ebp)
  801dc3:	e8 f6 f4 ff ff       	call   8012be <fd_lookup>
  801dc8:	83 c4 10             	add    $0x10,%esp
  801dcb:	85 c0                	test   %eax,%eax
  801dcd:	78 18                	js     801de7 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801dcf:	83 ec 0c             	sub    $0xc,%esp
  801dd2:	ff 75 f4             	pushl  -0xc(%ebp)
  801dd5:	e8 73 f4 ff ff       	call   80124d <fd2data>
  801dda:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ddf:	e8 1f fd ff ff       	call   801b03 <_pipeisclosed>
  801de4:	83 c4 10             	add    $0x10,%esp
}
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    

00801de9 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801de9:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801ded:	b8 00 00 00 00       	mov    $0x0,%eax
  801df2:	c3                   	ret    

00801df3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801df3:	f3 0f 1e fb          	endbr32 
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
  801dfa:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801dfd:	68 1e 28 80 00       	push   $0x80281e
  801e02:	ff 75 0c             	pushl  0xc(%ebp)
  801e05:	e8 c9 e9 ff ff       	call   8007d3 <strcpy>
	return 0;
}
  801e0a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0f:	c9                   	leave  
  801e10:	c3                   	ret    

00801e11 <devcons_write>:
{
  801e11:	f3 0f 1e fb          	endbr32 
  801e15:	55                   	push   %ebp
  801e16:	89 e5                	mov    %esp,%ebp
  801e18:	57                   	push   %edi
  801e19:	56                   	push   %esi
  801e1a:	53                   	push   %ebx
  801e1b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801e21:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801e26:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801e2c:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e2f:	73 31                	jae    801e62 <devcons_write+0x51>
		m = n - tot;
  801e31:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e34:	29 f3                	sub    %esi,%ebx
  801e36:	83 fb 7f             	cmp    $0x7f,%ebx
  801e39:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801e3e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801e41:	83 ec 04             	sub    $0x4,%esp
  801e44:	53                   	push   %ebx
  801e45:	89 f0                	mov    %esi,%eax
  801e47:	03 45 0c             	add    0xc(%ebp),%eax
  801e4a:	50                   	push   %eax
  801e4b:	57                   	push   %edi
  801e4c:	e8 38 eb ff ff       	call   800989 <memmove>
		sys_cputs(buf, m);
  801e51:	83 c4 08             	add    $0x8,%esp
  801e54:	53                   	push   %ebx
  801e55:	57                   	push   %edi
  801e56:	e8 ea ec ff ff       	call   800b45 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801e5b:	01 de                	add    %ebx,%esi
  801e5d:	83 c4 10             	add    $0x10,%esp
  801e60:	eb ca                	jmp    801e2c <devcons_write+0x1b>
}
  801e62:	89 f0                	mov    %esi,%eax
  801e64:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e67:	5b                   	pop    %ebx
  801e68:	5e                   	pop    %esi
  801e69:	5f                   	pop    %edi
  801e6a:	5d                   	pop    %ebp
  801e6b:	c3                   	ret    

00801e6c <devcons_read>:
{
  801e6c:	f3 0f 1e fb          	endbr32 
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
  801e73:	83 ec 08             	sub    $0x8,%esp
  801e76:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801e7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e7f:	74 21                	je     801ea2 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801e81:	e8 e1 ec ff ff       	call   800b67 <sys_cgetc>
  801e86:	85 c0                	test   %eax,%eax
  801e88:	75 07                	jne    801e91 <devcons_read+0x25>
		sys_yield();
  801e8a:	e8 63 ed ff ff       	call   800bf2 <sys_yield>
  801e8f:	eb f0                	jmp    801e81 <devcons_read+0x15>
	if (c < 0)
  801e91:	78 0f                	js     801ea2 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801e93:	83 f8 04             	cmp    $0x4,%eax
  801e96:	74 0c                	je     801ea4 <devcons_read+0x38>
	*(char*)vbuf = c;
  801e98:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e9b:	88 02                	mov    %al,(%edx)
	return 1;
  801e9d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ea2:	c9                   	leave  
  801ea3:	c3                   	ret    
		return 0;
  801ea4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea9:	eb f7                	jmp    801ea2 <devcons_read+0x36>

00801eab <cputchar>:
{
  801eab:	f3 0f 1e fb          	endbr32 
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
  801eb2:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb8:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801ebb:	6a 01                	push   $0x1
  801ebd:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ec0:	50                   	push   %eax
  801ec1:	e8 7f ec ff ff       	call   800b45 <sys_cputs>
}
  801ec6:	83 c4 10             	add    $0x10,%esp
  801ec9:	c9                   	leave  
  801eca:	c3                   	ret    

00801ecb <getchar>:
{
  801ecb:	f3 0f 1e fb          	endbr32 
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
  801ed2:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801ed5:	6a 01                	push   $0x1
  801ed7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801eda:	50                   	push   %eax
  801edb:	6a 00                	push   $0x0
  801edd:	e8 5f f6 ff ff       	call   801541 <read>
	if (r < 0)
  801ee2:	83 c4 10             	add    $0x10,%esp
  801ee5:	85 c0                	test   %eax,%eax
  801ee7:	78 06                	js     801eef <getchar+0x24>
	if (r < 1)
  801ee9:	74 06                	je     801ef1 <getchar+0x26>
	return c;
  801eeb:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801eef:	c9                   	leave  
  801ef0:	c3                   	ret    
		return -E_EOF;
  801ef1:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801ef6:	eb f7                	jmp    801eef <getchar+0x24>

00801ef8 <iscons>:
{
  801ef8:	f3 0f 1e fb          	endbr32 
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
  801eff:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f02:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f05:	50                   	push   %eax
  801f06:	ff 75 08             	pushl  0x8(%ebp)
  801f09:	e8 b0 f3 ff ff       	call   8012be <fd_lookup>
  801f0e:	83 c4 10             	add    $0x10,%esp
  801f11:	85 c0                	test   %eax,%eax
  801f13:	78 11                	js     801f26 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f18:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f1e:	39 10                	cmp    %edx,(%eax)
  801f20:	0f 94 c0             	sete   %al
  801f23:	0f b6 c0             	movzbl %al,%eax
}
  801f26:	c9                   	leave  
  801f27:	c3                   	ret    

00801f28 <opencons>:
{
  801f28:	f3 0f 1e fb          	endbr32 
  801f2c:	55                   	push   %ebp
  801f2d:	89 e5                	mov    %esp,%ebp
  801f2f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801f32:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f35:	50                   	push   %eax
  801f36:	e8 2d f3 ff ff       	call   801268 <fd_alloc>
  801f3b:	83 c4 10             	add    $0x10,%esp
  801f3e:	85 c0                	test   %eax,%eax
  801f40:	78 3a                	js     801f7c <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f42:	83 ec 04             	sub    $0x4,%esp
  801f45:	68 07 04 00 00       	push   $0x407
  801f4a:	ff 75 f4             	pushl  -0xc(%ebp)
  801f4d:	6a 00                	push   $0x0
  801f4f:	e8 c1 ec ff ff       	call   800c15 <sys_page_alloc>
  801f54:	83 c4 10             	add    $0x10,%esp
  801f57:	85 c0                	test   %eax,%eax
  801f59:	78 21                	js     801f7c <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5e:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f64:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f69:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801f70:	83 ec 0c             	sub    $0xc,%esp
  801f73:	50                   	push   %eax
  801f74:	e8 c0 f2 ff ff       	call   801239 <fd2num>
  801f79:	83 c4 10             	add    $0x10,%esp
}
  801f7c:	c9                   	leave  
  801f7d:	c3                   	ret    

00801f7e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801f7e:	f3 0f 1e fb          	endbr32 
  801f82:	55                   	push   %ebp
  801f83:	89 e5                	mov    %esp,%ebp
  801f85:	56                   	push   %esi
  801f86:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801f87:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801f8a:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801f90:	e8 3a ec ff ff       	call   800bcf <sys_getenvid>
  801f95:	83 ec 0c             	sub    $0xc,%esp
  801f98:	ff 75 0c             	pushl  0xc(%ebp)
  801f9b:	ff 75 08             	pushl  0x8(%ebp)
  801f9e:	56                   	push   %esi
  801f9f:	50                   	push   %eax
  801fa0:	68 2c 28 80 00       	push   $0x80282c
  801fa5:	e8 1f e2 ff ff       	call   8001c9 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801faa:	83 c4 18             	add    $0x18,%esp
  801fad:	53                   	push   %ebx
  801fae:	ff 75 10             	pushl  0x10(%ebp)
  801fb1:	e8 be e1 ff ff       	call   800174 <vcprintf>
	cprintf("\n");
  801fb6:	c7 04 24 34 27 80 00 	movl   $0x802734,(%esp)
  801fbd:	e8 07 e2 ff ff       	call   8001c9 <cprintf>
  801fc2:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801fc5:	cc                   	int3   
  801fc6:	eb fd                	jmp    801fc5 <_panic+0x47>

00801fc8 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801fc8:	f3 0f 1e fb          	endbr32 
  801fcc:	55                   	push   %ebp
  801fcd:	89 e5                	mov    %esp,%ebp
  801fcf:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801fd2:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801fd9:	74 0a                	je     801fe5 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fde:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801fe3:	c9                   	leave  
  801fe4:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  801fe5:	83 ec 04             	sub    $0x4,%esp
  801fe8:	6a 07                	push   $0x7
  801fea:	68 00 f0 bf ee       	push   $0xeebff000
  801fef:	6a 00                	push   $0x0
  801ff1:	e8 1f ec ff ff       	call   800c15 <sys_page_alloc>
  801ff6:	83 c4 10             	add    $0x10,%esp
  801ff9:	85 c0                	test   %eax,%eax
  801ffb:	78 2a                	js     802027 <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  801ffd:	83 ec 08             	sub    $0x8,%esp
  802000:	68 3b 20 80 00       	push   $0x80203b
  802005:	6a 00                	push   $0x0
  802007:	e8 68 ed ff ff       	call   800d74 <sys_env_set_pgfault_upcall>
  80200c:	83 c4 10             	add    $0x10,%esp
  80200f:	85 c0                	test   %eax,%eax
  802011:	79 c8                	jns    801fdb <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  802013:	83 ec 04             	sub    $0x4,%esp
  802016:	68 7c 28 80 00       	push   $0x80287c
  80201b:	6a 25                	push   $0x25
  80201d:	68 b4 28 80 00       	push   $0x8028b4
  802022:	e8 57 ff ff ff       	call   801f7e <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  802027:	83 ec 04             	sub    $0x4,%esp
  80202a:	68 50 28 80 00       	push   $0x802850
  80202f:	6a 22                	push   $0x22
  802031:	68 b4 28 80 00       	push   $0x8028b4
  802036:	e8 43 ff ff ff       	call   801f7e <_panic>

0080203b <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80203b:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80203c:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  802041:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802043:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  802046:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  80204a:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  80204e:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802051:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  802053:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  802057:	83 c4 08             	add    $0x8,%esp
	popal
  80205a:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  80205b:	83 c4 04             	add    $0x4,%esp
	popfl
  80205e:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  80205f:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  802060:	c3                   	ret    

00802061 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802061:	f3 0f 1e fb          	endbr32 
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
  802068:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80206b:	89 c2                	mov    %eax,%edx
  80206d:	c1 ea 16             	shr    $0x16,%edx
  802070:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802077:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  80207c:	f6 c1 01             	test   $0x1,%cl
  80207f:	74 1c                	je     80209d <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802081:	c1 e8 0c             	shr    $0xc,%eax
  802084:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80208b:	a8 01                	test   $0x1,%al
  80208d:	74 0e                	je     80209d <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80208f:	c1 e8 0c             	shr    $0xc,%eax
  802092:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802099:	ef 
  80209a:	0f b7 d2             	movzwl %dx,%edx
}
  80209d:	89 d0                	mov    %edx,%eax
  80209f:	5d                   	pop    %ebp
  8020a0:	c3                   	ret    
  8020a1:	66 90                	xchg   %ax,%ax
  8020a3:	66 90                	xchg   %ax,%ax
  8020a5:	66 90                	xchg   %ax,%ax
  8020a7:	66 90                	xchg   %ax,%ax
  8020a9:	66 90                	xchg   %ax,%ax
  8020ab:	66 90                	xchg   %ax,%ax
  8020ad:	66 90                	xchg   %ax,%ax
  8020af:	90                   	nop

008020b0 <__udivdi3>:
  8020b0:	f3 0f 1e fb          	endbr32 
  8020b4:	55                   	push   %ebp
  8020b5:	57                   	push   %edi
  8020b6:	56                   	push   %esi
  8020b7:	53                   	push   %ebx
  8020b8:	83 ec 1c             	sub    $0x1c,%esp
  8020bb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8020bf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8020c3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8020c7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8020cb:	85 d2                	test   %edx,%edx
  8020cd:	75 19                	jne    8020e8 <__udivdi3+0x38>
  8020cf:	39 f3                	cmp    %esi,%ebx
  8020d1:	76 4d                	jbe    802120 <__udivdi3+0x70>
  8020d3:	31 ff                	xor    %edi,%edi
  8020d5:	89 e8                	mov    %ebp,%eax
  8020d7:	89 f2                	mov    %esi,%edx
  8020d9:	f7 f3                	div    %ebx
  8020db:	89 fa                	mov    %edi,%edx
  8020dd:	83 c4 1c             	add    $0x1c,%esp
  8020e0:	5b                   	pop    %ebx
  8020e1:	5e                   	pop    %esi
  8020e2:	5f                   	pop    %edi
  8020e3:	5d                   	pop    %ebp
  8020e4:	c3                   	ret    
  8020e5:	8d 76 00             	lea    0x0(%esi),%esi
  8020e8:	39 f2                	cmp    %esi,%edx
  8020ea:	76 14                	jbe    802100 <__udivdi3+0x50>
  8020ec:	31 ff                	xor    %edi,%edi
  8020ee:	31 c0                	xor    %eax,%eax
  8020f0:	89 fa                	mov    %edi,%edx
  8020f2:	83 c4 1c             	add    $0x1c,%esp
  8020f5:	5b                   	pop    %ebx
  8020f6:	5e                   	pop    %esi
  8020f7:	5f                   	pop    %edi
  8020f8:	5d                   	pop    %ebp
  8020f9:	c3                   	ret    
  8020fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802100:	0f bd fa             	bsr    %edx,%edi
  802103:	83 f7 1f             	xor    $0x1f,%edi
  802106:	75 48                	jne    802150 <__udivdi3+0xa0>
  802108:	39 f2                	cmp    %esi,%edx
  80210a:	72 06                	jb     802112 <__udivdi3+0x62>
  80210c:	31 c0                	xor    %eax,%eax
  80210e:	39 eb                	cmp    %ebp,%ebx
  802110:	77 de                	ja     8020f0 <__udivdi3+0x40>
  802112:	b8 01 00 00 00       	mov    $0x1,%eax
  802117:	eb d7                	jmp    8020f0 <__udivdi3+0x40>
  802119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802120:	89 d9                	mov    %ebx,%ecx
  802122:	85 db                	test   %ebx,%ebx
  802124:	75 0b                	jne    802131 <__udivdi3+0x81>
  802126:	b8 01 00 00 00       	mov    $0x1,%eax
  80212b:	31 d2                	xor    %edx,%edx
  80212d:	f7 f3                	div    %ebx
  80212f:	89 c1                	mov    %eax,%ecx
  802131:	31 d2                	xor    %edx,%edx
  802133:	89 f0                	mov    %esi,%eax
  802135:	f7 f1                	div    %ecx
  802137:	89 c6                	mov    %eax,%esi
  802139:	89 e8                	mov    %ebp,%eax
  80213b:	89 f7                	mov    %esi,%edi
  80213d:	f7 f1                	div    %ecx
  80213f:	89 fa                	mov    %edi,%edx
  802141:	83 c4 1c             	add    $0x1c,%esp
  802144:	5b                   	pop    %ebx
  802145:	5e                   	pop    %esi
  802146:	5f                   	pop    %edi
  802147:	5d                   	pop    %ebp
  802148:	c3                   	ret    
  802149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802150:	89 f9                	mov    %edi,%ecx
  802152:	b8 20 00 00 00       	mov    $0x20,%eax
  802157:	29 f8                	sub    %edi,%eax
  802159:	d3 e2                	shl    %cl,%edx
  80215b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80215f:	89 c1                	mov    %eax,%ecx
  802161:	89 da                	mov    %ebx,%edx
  802163:	d3 ea                	shr    %cl,%edx
  802165:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802169:	09 d1                	or     %edx,%ecx
  80216b:	89 f2                	mov    %esi,%edx
  80216d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802171:	89 f9                	mov    %edi,%ecx
  802173:	d3 e3                	shl    %cl,%ebx
  802175:	89 c1                	mov    %eax,%ecx
  802177:	d3 ea                	shr    %cl,%edx
  802179:	89 f9                	mov    %edi,%ecx
  80217b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80217f:	89 eb                	mov    %ebp,%ebx
  802181:	d3 e6                	shl    %cl,%esi
  802183:	89 c1                	mov    %eax,%ecx
  802185:	d3 eb                	shr    %cl,%ebx
  802187:	09 de                	or     %ebx,%esi
  802189:	89 f0                	mov    %esi,%eax
  80218b:	f7 74 24 08          	divl   0x8(%esp)
  80218f:	89 d6                	mov    %edx,%esi
  802191:	89 c3                	mov    %eax,%ebx
  802193:	f7 64 24 0c          	mull   0xc(%esp)
  802197:	39 d6                	cmp    %edx,%esi
  802199:	72 15                	jb     8021b0 <__udivdi3+0x100>
  80219b:	89 f9                	mov    %edi,%ecx
  80219d:	d3 e5                	shl    %cl,%ebp
  80219f:	39 c5                	cmp    %eax,%ebp
  8021a1:	73 04                	jae    8021a7 <__udivdi3+0xf7>
  8021a3:	39 d6                	cmp    %edx,%esi
  8021a5:	74 09                	je     8021b0 <__udivdi3+0x100>
  8021a7:	89 d8                	mov    %ebx,%eax
  8021a9:	31 ff                	xor    %edi,%edi
  8021ab:	e9 40 ff ff ff       	jmp    8020f0 <__udivdi3+0x40>
  8021b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021b3:	31 ff                	xor    %edi,%edi
  8021b5:	e9 36 ff ff ff       	jmp    8020f0 <__udivdi3+0x40>
  8021ba:	66 90                	xchg   %ax,%ax
  8021bc:	66 90                	xchg   %ax,%ax
  8021be:	66 90                	xchg   %ax,%ax

008021c0 <__umoddi3>:
  8021c0:	f3 0f 1e fb          	endbr32 
  8021c4:	55                   	push   %ebp
  8021c5:	57                   	push   %edi
  8021c6:	56                   	push   %esi
  8021c7:	53                   	push   %ebx
  8021c8:	83 ec 1c             	sub    $0x1c,%esp
  8021cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8021cf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8021d3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8021d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021db:	85 c0                	test   %eax,%eax
  8021dd:	75 19                	jne    8021f8 <__umoddi3+0x38>
  8021df:	39 df                	cmp    %ebx,%edi
  8021e1:	76 5d                	jbe    802240 <__umoddi3+0x80>
  8021e3:	89 f0                	mov    %esi,%eax
  8021e5:	89 da                	mov    %ebx,%edx
  8021e7:	f7 f7                	div    %edi
  8021e9:	89 d0                	mov    %edx,%eax
  8021eb:	31 d2                	xor    %edx,%edx
  8021ed:	83 c4 1c             	add    $0x1c,%esp
  8021f0:	5b                   	pop    %ebx
  8021f1:	5e                   	pop    %esi
  8021f2:	5f                   	pop    %edi
  8021f3:	5d                   	pop    %ebp
  8021f4:	c3                   	ret    
  8021f5:	8d 76 00             	lea    0x0(%esi),%esi
  8021f8:	89 f2                	mov    %esi,%edx
  8021fa:	39 d8                	cmp    %ebx,%eax
  8021fc:	76 12                	jbe    802210 <__umoddi3+0x50>
  8021fe:	89 f0                	mov    %esi,%eax
  802200:	89 da                	mov    %ebx,%edx
  802202:	83 c4 1c             	add    $0x1c,%esp
  802205:	5b                   	pop    %ebx
  802206:	5e                   	pop    %esi
  802207:	5f                   	pop    %edi
  802208:	5d                   	pop    %ebp
  802209:	c3                   	ret    
  80220a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802210:	0f bd e8             	bsr    %eax,%ebp
  802213:	83 f5 1f             	xor    $0x1f,%ebp
  802216:	75 50                	jne    802268 <__umoddi3+0xa8>
  802218:	39 d8                	cmp    %ebx,%eax
  80221a:	0f 82 e0 00 00 00    	jb     802300 <__umoddi3+0x140>
  802220:	89 d9                	mov    %ebx,%ecx
  802222:	39 f7                	cmp    %esi,%edi
  802224:	0f 86 d6 00 00 00    	jbe    802300 <__umoddi3+0x140>
  80222a:	89 d0                	mov    %edx,%eax
  80222c:	89 ca                	mov    %ecx,%edx
  80222e:	83 c4 1c             	add    $0x1c,%esp
  802231:	5b                   	pop    %ebx
  802232:	5e                   	pop    %esi
  802233:	5f                   	pop    %edi
  802234:	5d                   	pop    %ebp
  802235:	c3                   	ret    
  802236:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80223d:	8d 76 00             	lea    0x0(%esi),%esi
  802240:	89 fd                	mov    %edi,%ebp
  802242:	85 ff                	test   %edi,%edi
  802244:	75 0b                	jne    802251 <__umoddi3+0x91>
  802246:	b8 01 00 00 00       	mov    $0x1,%eax
  80224b:	31 d2                	xor    %edx,%edx
  80224d:	f7 f7                	div    %edi
  80224f:	89 c5                	mov    %eax,%ebp
  802251:	89 d8                	mov    %ebx,%eax
  802253:	31 d2                	xor    %edx,%edx
  802255:	f7 f5                	div    %ebp
  802257:	89 f0                	mov    %esi,%eax
  802259:	f7 f5                	div    %ebp
  80225b:	89 d0                	mov    %edx,%eax
  80225d:	31 d2                	xor    %edx,%edx
  80225f:	eb 8c                	jmp    8021ed <__umoddi3+0x2d>
  802261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802268:	89 e9                	mov    %ebp,%ecx
  80226a:	ba 20 00 00 00       	mov    $0x20,%edx
  80226f:	29 ea                	sub    %ebp,%edx
  802271:	d3 e0                	shl    %cl,%eax
  802273:	89 44 24 08          	mov    %eax,0x8(%esp)
  802277:	89 d1                	mov    %edx,%ecx
  802279:	89 f8                	mov    %edi,%eax
  80227b:	d3 e8                	shr    %cl,%eax
  80227d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802281:	89 54 24 04          	mov    %edx,0x4(%esp)
  802285:	8b 54 24 04          	mov    0x4(%esp),%edx
  802289:	09 c1                	or     %eax,%ecx
  80228b:	89 d8                	mov    %ebx,%eax
  80228d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802291:	89 e9                	mov    %ebp,%ecx
  802293:	d3 e7                	shl    %cl,%edi
  802295:	89 d1                	mov    %edx,%ecx
  802297:	d3 e8                	shr    %cl,%eax
  802299:	89 e9                	mov    %ebp,%ecx
  80229b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80229f:	d3 e3                	shl    %cl,%ebx
  8022a1:	89 c7                	mov    %eax,%edi
  8022a3:	89 d1                	mov    %edx,%ecx
  8022a5:	89 f0                	mov    %esi,%eax
  8022a7:	d3 e8                	shr    %cl,%eax
  8022a9:	89 e9                	mov    %ebp,%ecx
  8022ab:	89 fa                	mov    %edi,%edx
  8022ad:	d3 e6                	shl    %cl,%esi
  8022af:	09 d8                	or     %ebx,%eax
  8022b1:	f7 74 24 08          	divl   0x8(%esp)
  8022b5:	89 d1                	mov    %edx,%ecx
  8022b7:	89 f3                	mov    %esi,%ebx
  8022b9:	f7 64 24 0c          	mull   0xc(%esp)
  8022bd:	89 c6                	mov    %eax,%esi
  8022bf:	89 d7                	mov    %edx,%edi
  8022c1:	39 d1                	cmp    %edx,%ecx
  8022c3:	72 06                	jb     8022cb <__umoddi3+0x10b>
  8022c5:	75 10                	jne    8022d7 <__umoddi3+0x117>
  8022c7:	39 c3                	cmp    %eax,%ebx
  8022c9:	73 0c                	jae    8022d7 <__umoddi3+0x117>
  8022cb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8022cf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8022d3:	89 d7                	mov    %edx,%edi
  8022d5:	89 c6                	mov    %eax,%esi
  8022d7:	89 ca                	mov    %ecx,%edx
  8022d9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8022de:	29 f3                	sub    %esi,%ebx
  8022e0:	19 fa                	sbb    %edi,%edx
  8022e2:	89 d0                	mov    %edx,%eax
  8022e4:	d3 e0                	shl    %cl,%eax
  8022e6:	89 e9                	mov    %ebp,%ecx
  8022e8:	d3 eb                	shr    %cl,%ebx
  8022ea:	d3 ea                	shr    %cl,%edx
  8022ec:	09 d8                	or     %ebx,%eax
  8022ee:	83 c4 1c             	add    $0x1c,%esp
  8022f1:	5b                   	pop    %ebx
  8022f2:	5e                   	pop    %esi
  8022f3:	5f                   	pop    %edi
  8022f4:	5d                   	pop    %ebp
  8022f5:	c3                   	ret    
  8022f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022fd:	8d 76 00             	lea    0x0(%esi),%esi
  802300:	29 fe                	sub    %edi,%esi
  802302:	19 c3                	sbb    %eax,%ebx
  802304:	89 f2                	mov    %esi,%edx
  802306:	89 d9                	mov    %ebx,%ecx
  802308:	e9 1d ff ff ff       	jmp    80222a <__umoddi3+0x6a>
